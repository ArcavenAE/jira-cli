# Fresh-Eyes PR Review — #741 (S-578-2)

**Verdict: APPROVE** — 0 BLOCKING findings, 11 NON-BLOCKING findings.

Reviewed against `git diff origin/develop...origin/feature/S-578-2-edit-field-dispatch`
(HEAD `4d0d54af`, base `74221bbc`), the PR body, the story spec
`S-578-2-edit-field-hint-dispatch.md`, and the BC text in
`.factory/specs/prd/bc-3-issue-write.md` (EC-3.4.027-1..7, EC-3.4.030-1..6,
BC-3.4.031 EC-2a..2d).

---

## What I actually read and checked

- **Full `src/` diff** (902 lines) line by line — `edit.rs` (47 lines changed),
  `field_resolve.rs` (+637/-216), `editmeta.rs` (+55).
- **`resolve_edit_fields` in full at HEAD** (not just the diff hunks) to verify the
  hinted branch sits at the right point in Phase 3 — after the editmeta
  presence check (Step 3) and the `operations` contains-`set` check (Step 3b),
  before the bare-form `field_type` match. Confirmed AC-001 ordering.
- **`edit.rs` guard ordering** (lines 128–260, 363–400, 524–560, 1040–1055) —
  verified Gate A (no-fields), Gate B (flag-overlap), the `--label` conflict
  list and the C-1 multi-key rejection all still fire *before* the dry-run
  block, so a hinted `--field` cannot reach `:asset`'s HTTP round-trip on a
  multi-key edit. Gate B keys off the bare field name, which `parse_field_kv`
  still produces for hinted pairs — so `--field priority:name=X --priority Y`
  still collides correctly.
- **Dead-code check**: `reject_unsupported_hint_kinds` is no longer called from
  `edit.rs` but is still live at `jsm_create.rs:288`. Not dead. Platform
  `issue create` has no gap either — DEC-188's pre-flight already exits 64 for
  `--field` without `--request-type`.
- **`get_or_fetch_workspace_id`** (`src/api/assets/workspace.rs`, unmodified) —
  confirmed it writes the disk cache after a cold fetch, which is what makes
  the "two `:asset` hints → one workspace GET" property hold.
- **Spec cross-check, spot-checked 7 of 19 ACs**: AC-001 (dispatch ordering),
  AC-002 (byte-identical non-cascading — verified via the shared
  `resolve_option_value` extraction, genuine code motion, no behavior drift),
  AC-004 / EC-3.4.027-7 (structural `children.is_empty()`, pinned substrings
  `"is not a cascading select"` + `"remove the"` — both present verbatim),
  AC-007 (`{"name": VALUE}` matches `edit.rs`'s `--priority` shape), AC-012
  (dry-run wire-shape preview), AC-019 / EC-3.4.027-1 (two message sub-cases,
  gate runs before `allowedValues` inspection), BC-3.4.031 EC-2a→2c→2d→2b
  check ordering in `compose_asset_hint` (matches the spec's required order
  exactly, including EC-2c preceding EC-2b so `:asset=:` gets the
  workspace-segment message).
- **Test files**: read `tests/issue_edit_field.rs` diff in full, and
  `tests/issue_field_hint_kinds.rs` structurally + ~600 lines in detail
  (41 top-level `#[test]`/`#[tokio::test]` fns + 2 `proptest!` blocks + inner
  scoped sub-blocks = the 64 reported cases).

## Test quality assessment (this is not a rubber stamp)

The tests are **substantially better than typical**. Concretely:

- **16 wire-body assertions** via `body_partial_json` / `body_json` with
  `.expect(N)` — the tests assert the actual PUT payload, not just exit codes.
- **22 `.expect(0)` mocks** — negative HTTP assertions (no PUT fired, no
  workspace-discovery GET fired) rather than exit-code-only checks.
- The flipped S-578-1 pin
  (`test_edit_field_id_hint_dispatches_verbatim_object_s578_2`) is genuinely
  discriminating: `Severity` is mounted as a `string`-type field, so a
  silent bare-form fallback would send `"customfield_10001": "10042"`
  (a JSON string) and the body-matched mock would not fire. The test comment
  explicitly reasons about why a body-blind `mount_put_204` would have been
  worthless here. That is the opposite of trivia.
- `test_bc_3_4_027_ec3_*` and `test_bc_3_4_027_ec6_empty_child_*` both assert
  `!stderr.contains("OtherChild")` — i.e. they verify the child enumeration is
  scoped to the *matched* parent and doesn't leak siblings. Real assertions.
- Multi-`--field` tests each use their own scoped `MockServer` per sub-block,
  so **no HashMap-iteration-order flakiness** — I specifically looked for a
  test that asserts which of two errors fires first across two `--field` pairs
  and found none. Good.
- `test_bc_3_4_030_two_bare_asset_hints_single_workspace_get` asserts the
  cache-write-then-read round trip collapses two `:asset` hints to one GET,
  with a comment forbidding a future agent from loosening it. Good discipline.

I independently re-ran `cargo test --test issue_field_hint_kinds` in
`.worktrees/S-578-2` at HEAD `4d0d54af`: **64 passed, 0 failed**. The count and
green status in the PR body are accurate, not just claimed.

Weak spots are listed as findings 5, 6, 8, 9 and 10 below. In particular,
roughly 15 of the ~38 test functions assert something about the actual composed
wire shape (via `body_partial_json` interception or exact `plannedChanges`
equality); the remainder are exit-code + stderr-substring + mock-call-count
assertions. That split is defensible for an error-taxonomy-heavy story — every
exit-64 test I checked does pin a message substring rather than only the code —
but findings 8 and 10 are places where the assertion is weaker than the test
name/comment claims.

---

## Findings

### NON-BLOCKING 1 — `:option` empty-child message deviates from EC-3.4.027-6, and the test pins the deviation
**Category:** spec-fidelity · **File:** `src/cli/issue/field_resolve.rs` (`compose_option_hint`, empty-`child_raw` branch)

EC-3.4.027-6 states an empty child segment must "fall through to the **SAME**
unresolvable-child exit-64 shape as EC-3.4.027-3 … **rather than introducing a
distinct empty-segment error message**."

The implementation does the opposite. Two different messages exist:

- Empty child (`Parent>`) → hand-rolled:
  `"Option value '' not found for field '<N>' under parent '<P>'. Allowed child values: …"`
- Real unresolvable child (`Parent>NoSuchChild`) → delegated to
  `find_option_match`, which emits:
  `"Option value 'NoSuchChild' not found for field '<N>'. Allowed values: …"`

The second has **no** `under parent` clause and says `Allowed values`, not
`Allowed child values`. So the shapes differ, contrary to EC-3.4.027-6.

Worse, `test_bc_3_4_027_ec6_empty_child_exits_64` **asserts** `stderr.contains("under parent")`
while `test_bc_3_4_027_ec2_unresolvable_parent_lists_allowed_values` asserts
`!stderr.contains("under parent")` — the divergence is deliberately pinned, so
the suite will never catch it. A future reader will conclude EC-3.4.027-6 is
satisfied when it isn't.

Note the deviation is in the *user-friendly* direction: the empty-child message
is better than the generic one. My recommendation is therefore to **converge
upward**, not downward:

- Make the resolvable-parent/unresolvable-child path also emit the
  `under parent '<P>' … Allowed child values:` shape (i.e. give
  `find_option_match` an optional parent-context parameter, or wrap its error
  at the child call site), then both cases genuinely share one shape and
  EC-3.4.027-6 is satisfied literally.
- Or, if the PO prefers the current split, amend EC-3.4.027-6 to authorize the
  distinct empty-segment message. Do not leave spec and code disagreeing.

### NON-BLOCKING 2 — `field_resolve.rs` crossed the ADR-0012 1,000-LOC shard threshold; PR body claims it didn't
**Category:** ADR compliance / description accuracy · **File:** `src/cli/issue/field_resolve.rs`, `CLAUDE.md`, PR body

Measured on the branch: **1,253 LOC total** (974 before `#[cfg(test)]` at line 975).
On `develop` it was 914.

ADR-0012 / CLAUDE.md: "`src/cli/` files at ≥1,000 LOC are shard candidates."
Every other file that crossed it (`edit.rs`, `component.rs`, `attachments.rs`,
`mod.rs`, `helpers.rs`, `list.rs`, `workflow.rs`) carries a **Known Size
Deviations** entry in `CLAUDE.md`. `field_resolve.rs` does not, and this PR
doesn't add one.

The PR body's ADR section states field_resolve.rs "stays well clear of the
1,000-LOC shard threshold" — that was true of the *pre-story* 914 and is not
true post-merge. Either shard, or add the standard one-line DOCUMENT-AS-IS
entry to `CLAUDE.md`'s Known Size Deviations in this PR and correct the PR
body sentence. (CLAUDE.md's existing entries count total file LOC including
inline tests, so 1,253 is the number to record.)

### NON-BLOCKING 3 — PR body misattributes the `editmeta.rs` change
**Category:** description accuracy · **File:** PR body diff-stat table

The table reads: `src/types/jira/editmeta.rs | +55 — AllowedValue.children: Vec<AllowedValue> (#[serde(default)])`.

The diff shows `pub children: Vec<AllowedValue>` as an **unchanged context
line** — the field was added by S-580-1 (merged at `74221bbc`). The entire +55
is a new `#[cfg(test)] mod tests` block. The rustdoc inside the file states
this correctly ("This test already passes today — `children` was added by
S-580-1"), and the security review states it correctly too; only the PR body
table is wrong. Reword to "+55 — regression pin for the pre-existing
`AllowedValue.children` field (AC-011)".

### NON-BLOCKING 4 — `Parent > Child` (whitespace around the delimiter) is unresolvable, but the echo renders with spaces
**Category:** UX / round-trip asymmetry · **File:** `field_resolve.rs` (`compose_option_hint`)

`split_once('>')` does not trim. `--field cf:option='Parent > Child'` yields
`parent_raw = "Parent "` and `child_raw = " Child"`, neither of which
case-insensitively exact-matches nor substring-matches (`"parent".contains("parent ")`
is false), so it exits 64 with "not found".

Meanwhile the success path's `display_value` is `format!("{parent_label} > {child_label}")`
— *with* spaces. So `jr` echoes back a form that `jr` itself rejects on input.
Consider either trimming both segments before matching, or emitting the echo
without spaces (`Parent>Child`) so echo and input syntax agree. Low impact,
but it will generate support questions.

### NON-BLOCKING 5 — No deterministic multibyte fixture for EC-3.4.027-5 / EC-3.4.030-6; the proptests only prove "no panic", at 20 cases
**Category:** coverage · **File:** `tests/issue_field_hint_kinds.rs`

EC-3.4.027-5 specifies `--field 'cf:option=Pré>Bñ'` **"resolves normally
(parent `Pré`, child `Bñ`)"**, and EC-3.4.030-6 specifies `--field cf:asset=Wé:123`
**"resolves normally (explicit workspaceId = `Wé`, objectId = `123`)"**.

Neither literal appears anywhere in the test file — I grepped for `Pré`, `Bñ`,
`Wé` and the only hit is a doc-comment mention at line 407. The only coverage
is the two `proptest!` blocks, both `ProptestConfig::with_cases(20)`, whose
assertions are limited to: exit code `!= 101`, stderr lacks `"panicked at"`,
stderr lacks the interim-guard message. That proves *absence of panic*; it
does **not** prove correct resolution, and 20 cases over `[^\x00]{0,24}` is a
thin corpus for reaching a multibyte scalar immediately adjacent to the
delimiter — which is the exact adjacency the spec's own MUST rationale calls
out ("a proptest can pass by accident against a corpus that happens not to
include a multibyte scalar immediately adjacent to the delimiter").

Add two small deterministic tests asserting the composed PUT body for `Pré>Bñ`
and `Wé:123`. These are the fixtures the BC names verbatim; they should be
cheap.

### NON-BLOCKING 6 — Missing `:option` coverage for ambiguous matches and for numeric id-bypass on a cascading parent
**Category:** coverage · **File:** `tests/issue_field_hint_kinds.rs`

`find_option_match` retains the bare form's ambiguity branches (exact-match
count > 1, substring-match count > 1) and its numeric id-bypass. Under
`:option` neither is exercised: grep for `ambiguous` / `id_bypass` /
`numeric id` in the new test file returns nothing.

The cascading path is where this matters most — `find_option_match` is called
for the parent segment, so `--field cascade:option=10001>ChildA` resolves the
parent *by id*, and then the composed wire value uses `parent_av.value`
(the label), not the id the user typed. That is almost certainly correct, but
it is an untested interaction between two features and worth one test.

### NON-BLOCKING 7 — `resolve_edit_fields`'s algorithm doc-block was not updated for the new dispatch step
**Category:** documentation · **File:** `field_resolve.rs`

The parameter docs were updated thoroughly (good), but the summary
`Step 1 … Step 6` pseudocode block above the fn still describes only the
bare-form pipeline. Add a line for the hinted branch between Step 3b and
Step 4 so the block matches the code.

### NON-BLOCKING 8 — `:id` / `:name` "bypasses allowedValues" is never proven against a *populated* allowedValues list
**Category:** coverage · **File:** `tests/issue_field_hint_kinds.rs`

AC-006's claim is that `:id` bypasses the `allowedValues` lookup **entirely**.
Every `:id=` / `:name=` fixture in the file uses an `allowedValues` that is
either `null` or `[]`:

- `:id=999` → field type `"array"`, `allowedValues: None`
- `:id=10286` (3 tests) → `allowedValues: Some(json!([]))` — empty array
- `:name=Medium` → `allowedValues: None`

An implementation that *still* performed a membership check but happened to
short-circuit on an empty/absent list would pass all of these. The
discriminating fixture is missing: a **non-empty** `allowedValues` (e.g.
`[{"id":"1","value":"High"}]`) with `:id=999` supplied — a value that is *not*
in the list — asserting the PUT still carries `{"id":"999"}`. One test closes
this.

### NON-BLOCKING 9 — Stale proptest doc comments and one now-permanently-vacuous assertion
**Category:** test quality / documentation · **File:** `tests/issue_field_hint_kinds.rs` lines ~407–420, 493, 1165

Commit `4d0d54af` updated the *module-level* doc to merged/GREEN reality but
missed the two `proptest!` blocks' own comments, which still describe RED-gate
state: "RED today: every generated case hits the interim guard…" and
"Vacuously true today (zero PUTs recorded, since the guard blocks before any
HTTP)".

More substantively, both proptests still assert
`!stderr.contains(INTERIM_GUARD_MSG)`. The guard's call site was removed from
`issue edit` by this very PR, so on this command that assertion can no longer
fail for any input — it is dead weight, not a regression signal, and the
module header at lines 35–39 claims the opposite ("remains meaningful").
Either drop the assertion or correct the comment.

### NON-BLOCKING 10 — EC-8/EC-9 sub-blocks assert only that *a* PUT fired, not that the body was verbatim
**Category:** test quality · **File:** `tests/issue_field_hint_kinds.rs` (`test_ec6_ec7_ec8_ec9_regression_at_edit_call_site`, ~lines 1837–1923)

The comment claims the assertion proves `:id=` "passes VALUE through verbatim
to the server". The actual assertion is:

```rust
let requests = server.received_requests().await.unwrap();
assert!(requests.iter().any(|r| r.method.as_str() == "PUT"), …);
```

`received_requests()` returns **every** request wiremock received, matched or
not. The block does mount a `body_partial_json({"fields":{…:{"id":""}}})`
matcher, but the response is discarded (`let _output = …`) and nothing asserts
the matched mock actually fired. If `jr` sent a different body, the request
would go unmatched (404) yet still be recorded as a PUT, and the assertion
would pass.

Per this repo's own convention ("a name asserting a guarantee its body doesn't
check is a defect, not a style deviation"), tighten this to `.expect(1)` on the
body-matched mock, or assert on the recorded request's body directly.

### NON-BLOCKING 11 (nit) — throwaway `&mut BTreeMap::new()` at the live call site
**Category:** code quality · **File:** `edit.rs` ~line 1053

`&mut BTreeMap::new()` as an inline argument works (temporary lives to
end-of-statement) and the comment explains it, but a named
`let mut _unused_preview = BTreeMap::new();` reads better and makes the intent
greppable. Alternatively make `planned_preview` an `Option<&mut …>`. Purely
stylistic.

---

## Things I specifically checked and found correct

- Hinted dispatch is correctly placed **after** the editmeta-presence and
  `operations` contains-`set` guards — a hinted `--field` cannot bypass either.
  (AC-001.)
- `resolve_option_value` / `find_option_match` extraction is genuine code
  motion: I diffed the extracted bodies against the deleted inline block
  branch by branch (id-bypass numeric pre-filter, `exact_av` len 1 / >1,
  `sub_av` empty / >1 / 1, the three `no machine-readable id` guards, all four
  message strings). The only semantic change is that the `id`-absent guard
  moved from three duplicated sites to one site in `resolve_option_value` —
  behaviorally identical because all three former sites returned the same
  message. AC-002's byte-identical claim holds structurally, not just by test.
- `compose_asset_hint` check order is exactly EC-2a → EC-2c → EC-2d → EC-2b/EC-3,
  which is what the spec requires (and `:asset=:` correctly hits EC-2c, not
  EC-2b). `str::split_once(':')` satisfies the Architecture Compliance Rule 2
  MUST. The workspace GET happens strictly after all malformed-shape checks
  (AC-009), and the tests assert it with `.expect(0)`.
- `get_or_fetch_workspace_id` is called at the L2 call site, not inside a
  sibling module (Architecture Compliance Rule 3).
- The dry-run JSON path switched from merging `dr_changed` to `dr_planned`.
  For bare fields `dr_planned` receives `json!(display_value)` — the same JSON
  string the old code produced from `dr_changed`. **No regression** for the
  unhinted form; I checked this specifically because it's the kind of swap
  that silently changes output type.
- `use std::collections::HashMap` removal from `edit.rs` is safe (no other use;
  clippy `-D warnings` is clean).
- No new dependency, no `unsafe`, no `#[allow]`, no lint suppression, no
  `todo!()`. All JSON built via `serde_json::json!` over typed values — no
  string concatenation into JSON. Commits are conventional-format with the
  story ID.
- Diff size: `edit.rs` at 47 changed lines is genuinely inside the ADR-0019
  §2(b) ~100-LOC narrow-touch guidance (AC-018).

## Pre-existing issue noted, NOT introduced by this PR

`find_option_match` with an empty `value` reaches the substring branch, where
`v.to_lowercase().contains("")` is `true` for **every** entry. On a field with
exactly one `allowedValue`, `--field cf=` (bare, pre-existing) and now
`--field cf:option=` silently resolve to that single option instead of
erroring. The `:option` cascading path guards against this explicitly for both
segments (the empty-parent and empty-child branches exist precisely because of
it — good catch by the implementer), but the non-cascading entry point does
not. This is inherited BC-3.4.016 behavior, out of scope for S-578-2; worth a
follow-up story.

---

## Checklist

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence — all changes relate to S-578-2 | PASS |
| 2 | Description accuracy | PARTIAL — findings 2, 3 |
| 3 | Test coverage of changed lines | PASS with gaps — findings 5, 6 |
| 4 | Demo evidence | Present on `factory-artifacts` per repo policy #708; 10 per-AC sets claimed. Not verifiable from this diff (by design). |
| 5 | Commit quality | PASS — conventional format, story ID, clear messages |
| 6 | Diff size | `src/` diff is 902 lines; the 3,448 total is dominated by the new test file. Justified. |
| 7 | Missing changes vs. story spec | PASS on the 7 ACs spot-checked, except finding 1 |
| 8 | Dependency status | PASS — S-578-1 merged at `993de833` (#739) |

**Recommendation:** merge. Findings 1, 2, 3, 9 and 10 are cheap enough that I'd
fix them in this PR rather than defer (1 = message-shape change + test-assertion
update; 2 = one-line `CLAUDE.md` entry + PR-body correction; 3 = PR-body edit;
9 = comment cleanup + drop a dead assertion; 10 = tighten one mock to
`.expect(1)`). Findings 4, 5, 6, 7, 8 and 11 are fine as follow-ups.

Nothing here risks incorrect data being written to Jira or a panic, which is
why none of it is BLOCKING. The dispatch logic itself is correct, correctly
ordered relative to the existing guards, and the bare-form path is genuinely
untouched.
