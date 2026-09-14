# PR Review — #811 `fix/e2e-edit-field-adf-readback`

**Verdict: APPROVE** (no blocking findings)

`covered_sha: a611d07dd592b76e629d03d5fc69da072a45f183`

Test-only change: +45/-5 in `tests/e2e_live.rs`, one commit ahead of `develop`.
Makes the `edit --field` live read-back assertion tolerate the ADF-document
shape that #809 now (correctly) persists for rich-text fields.

---

## What I verified

I did not take the "test-only, therefore low-risk" shortcut — the substantive
risk in a change like this is a *weakened* assertion that turns a real
regression into a green run. It isn't weakened. Specifics:

**1. The DFS walk is correct.** `extract_adf_text_walk` checks the node's own
`type == "text"` and then recurses into the `content` array. That ordering is
right for ADF, where a node is never simultaneously `text`-typed and a content
container — so no node is visited twice and none is skipped. Nested
`paragraph`/`doc` wrappers are traversed to arbitrary depth.

**2. The assertion cannot pass when the write failed.** Three paths considered:
- Field cleared/absent → `fields.<wire_key>` is `Value::Null`, so `.get()`
  returns `Some(Value::Null)` (not `None`), `extract_field_text` returns `""`,
  and `contains(label)` is false → **still fails**. No silent pass.
- Unexpected non-string/non-ADF object → walk yields `""` → fails. Good.
- False positive from the label appearing elsewhere on the issue (e.g. the
  `labels` array, which `seed_issue` populates with the same `run_label()`) →
  not possible; the lookup stays scoped to `fields.<wire_key>` exactly as
  before. This scoping was the part most worth checking and it is preserved.

**3. It matches what the production fix actually writes.** #809 (`e926cb70`)
converts `--field` values via `crate::adf::text_to_adf`, **not**
`markdown_to_adf`. That matters: `text_to_adf` preserves the input verbatim as
plain text nodes with no mark transformation, so the written
`e2e dynamic edit e2e-<digits>` lands as one contiguous text node and
`contains(label)` holds. (`run_label()` is `e2e-{GITHUB_RUN_ID|millis}` —
digits only, no markdown-special characters — so even the `markdown_to_adf`
path would have been safe. Worth stating since the concatenation strategy would
be fragile against mark-splitting.)

**4. Recursion is bounded — no CWE-674 exposure on this path.** The input is an
untrusted-shaped live API response, so unbounded recursion is a fair question.
`fetch_raw` parses with `serde_json::from_slice(...).ok()`, and serde_json's
default recursion limit (128) rejects a pathologically deep document at *parse*
time — `fetch_raw` returns `None` and the walk never runs. Combined with the
shallow (2–3 level) reality of live `environment` field docs, the absence of a
`MAX_ADF_DEPTH`-style guard here is fine. Production `adf.rs` keeps its
`MAX_ADF_DEPTH = 256` guard; this test helper doesn't need to duplicate it.

**5. Conventions and gates.**
- No let-chains — nested `if` blocks used, MSRV 1.85 safe.
- No `unsafe`, no `#[allow]`, no new dependencies, no production code touched.
- `cargo clippy --test e2e_live` — clean, zero warnings.
- `cargo test --test e2e_live` — 30 always-run passed, 78 ignored, 0 failed
  (includes `test_every_ignored_test_has_gate_guard` and
  `test_no_test_function_exceeds_line_budget`).
- `cargo test --test e2e_cli_surface_guard` — 10/10 passed. The new helpers add
  no `h.cmd()` invocation, so no SURFACE-table registration was required.
- Style matches the file's existing recursive-ADF helper
  (`adf_contains_mention_id`) and its rustdoc-heavy helper convention; the
  helpers are placed adjacent to their single consumer.

**6. Checklist items with no finding.**
- *CHANGELOG*: correctly absent. Verified against 11 prior `test:`/`fix(test):`
  commits in history — none touched `CHANGELOG.md`.
- *Demo evidence*: not applicable. The repo has no `docs/demo-evidence/`
  directory at all, and an `#[ignore]`d live-Jira assertion cannot be demoed
  without site credentials.
- *Dependency status*: #809 (`e926cb70`) is confirmed an ancestor of
  `origin/develop`. The branch is exactly **1 commit** ahead of the current
  `develop` tip, so CLAUDE.md's `strict: false` stale-base concern (a green
  gate computed against a since-moved base) does not apply here.
- *Diff coherence / size*: 50 lines, one file, one purpose, no drive-by edits.

---

## Findings

| # | Severity | Category | Finding |
|---|----------|----------|---------|
| 1 | SUGGESTION | coverage | New pure helpers have no always-run unit test, deviating from this file's own convention |
| 2 | NIT | coherence | Text concatenation inserts no separator at block/`hardBreak` boundaries |
| 3 | NIT | coherence | Text-bearing non-`text` nodes (`mention`, `emoji`, `inlineCard`) contribute nothing |
| 4 | NIT | description | Commit references an internal finding ID rather than `closes #NNN` |

### 1. [SUGGESTION] `extract_field_text` / `extract_adf_text_walk` get no always-run unit test

Both helpers are pure, deterministic, and reachable **only** on the
`JR_RUN_E2E=1 --include-ignored` live path. A logic bug in them — say, an
inverted `type` check, or losing the self-check so a top-level bare text node
returns `""` — would never surface in CI; it would surface as a confusing live
red (or, worse, a live green) weeks later when someone runs the suite with
credentials.

`e2e_live.rs` already has the answer to this, in the "Unit tests for ...
(always-run, no gate required)" block right below the change:
`extract_fn_body`, `poll_schedule`, `poll_outcome`, `is_transient_error`, and
`key_format_valid` are all pure helpers with always-run unit tests, precisely
so the gated suite's own scaffolding is CI-verified. This change adds a sixth
pure helper without joining that pattern.

Suggested addition (three cases, no gate, no network):

```rust
#[test]
fn test_extract_field_text_returns_plain_string_unchanged() {
    assert_eq!(extract_field_text(&json!("plain value")), "plain value");
}

#[test]
fn test_extract_field_text_concatenates_nested_adf_text_nodes() {
    let doc = json!({"type":"doc","version":1,"content":[
        {"type":"paragraph","content":[{"type":"text","text":"e2e dynamic edit e2e-1"}]}
    ]});
    assert!(extract_field_text(&doc).contains("e2e-1"));
}

#[test]
fn test_extract_field_text_returns_empty_for_null_so_assertion_still_fails() {
    assert_eq!(extract_field_text(&Value::Null), "");
}
```

The third one is the valuable one — it pins the no-silent-pass property I
reasoned about above so a future refactor can't quietly turn a cleared field
into a passing assertion.

Non-blocking, and precedent is admittedly mixed: the sibling
`adf_contains_mention_id` walker is also untested. Fix here or track it; either
is defensible.

### 2. [NIT] Concatenation drops block boundaries

`extract_adf_text_walk` appends text with no separator, so a two-paragraph doc
yields `"lineAlineB"` rather than `"lineA\nlineB"`. Harmless today — the value
written is single-line and the assertion is a `contains` on a unique token. But
if anyone later widens this test to a multi-line value or asserts full
equality, the missing boundary will read as a mismatch whose cause is in this
helper rather than in the code under test. A one-line note in the rustdoc
("boundaries between block nodes are not preserved; suitable for `contains`
checks on single-line values, not for full-text equality") would save that
future debugging session. Purely a documentation nit.

### 3. [NIT] Non-`text` text-bearing nodes are invisible

`mention`, `emoji`, and `inlineCard` carry their user-visible text in `attrs`,
not in a `text` field, so they extract as empty. Correct for this test's scope
(a benign generated string on a plain rich-text field) and consistent with the
narrow rustdoc contract. Noted only so it isn't mistaken for a general-purpose
ADF-to-text utility if someone reaches for it later — `adf::adf_to_text` is the
real one.

### 4. [NIT] Commit message references an internal ID

`closes E2E-EDIT-FIELD-ADF-HEURISTIC` follows Conventional Commits and is clear
about intent, but the repo's dominant pattern for fixes is `closes #NNN` against
a GitHub issue. If there is no tracking issue for this, that's fine — just means
the trail to the originating finding lives outside GitHub.

---

## Summary

Correct, tightly scoped, well-documented fix to a real test defect created by
#809's behavior change. The assertion is strictly more accurate than before,
not more permissive — I checked the null/absent and cross-field-leak paths
specifically. Clippy clean, all always-run tests and both offline guard suites
pass, dependency merged, base fresh. Approving; finding 1 is worth a follow-up
but does not gate merge.
