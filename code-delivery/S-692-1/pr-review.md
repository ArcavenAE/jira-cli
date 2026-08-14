# PR Review — #697 `feat(edit)!: --dry-run reads stdin and renders ADF preview (#692, DEC-274)`

**Verdict: no blocking findings.** Posted as a COMMENT-state review (GitHub blocks
self-approval for the PR author's own account); treat this as an approve-equivalent
with 5 non-blocking items.

## What I reviewed

All 3 changed files, full diff (882+/15−): `src/cli/issue/edit.rs` (+64/−15),
`tests/issue_edit.rs` (new, +798), `CHANGELOG.md` (+20). I read the surrounding
`handle_edit` body (not just the diff hunks) to verify the ordering claim, and I
built the branch and ran `cargo test --test issue_edit` — **38 passed, 0 failed**
(12 new story tests + the shared `common::wf` module tests).

## Verification of the four load-bearing claims

**1. `plannedChanges.description` still carries the raw input verbatim (BC-3.4.013/#398) — CONFIRMED.**
The new code inserts `json!(text)` where `text` is `dr_desc_text`, which is either the
untouched `read_to_string` buffer or `description.clone()`. No trim, no normalization, no
ADF round-trip anywhere on that path. `test_..._multiline_markdown_stdin_produces_real_adf_document`
pins byte-identity against a string containing embedded newlines, a list, and a fenced code
block — that's a real discriminating assertion, not a smoke check.

**2. `descriptionAdf` is nested inside `plannedChanges`, never top-level — CONFIRMED.**
The insert targets the `planned` map that is subsequently wrapped in
`json!({"dryRun":…, "issues":…, "plannedChanges": planned})`. `assert_exactly_three_top_level_keys`
uses a sorted set-equality assertion (not `contains`), so an accidental top-level key fails
loudly, and AC-10 exercises all four description×markdown flag combinations.

**3. No partial-stdout leak before the exit-64 return — CONFIRMED, and stronger than the PR claims.**
The pre-step is textually and logically ahead of `match output_format`, so the first
`println!` in the table arm is unreachable when `markdown_to_adf` returns `Err`. I also checked
the rest of `handle_edit`: there is **no `println!` anywhere in the function before the dry-run
`match`** (only two occurrences of the token appear earlier, both inside comments), and
`field_resolve.rs::resolve_edit_fields` — the one thing that runs ahead of the pre-step —
contains no `println!` at all, so its `.await?` error path is equally leak-free. AC-3/AC-6 pin
this behaviorally with `stdout.trim().is_empty()` in table mode; AC-2/AC-5 get the same
guarantee via `assert_json_error_envelope`, which asserts empty stdout internally.

**4. CHANGELOG Breaking Changes entry present and accurate — CONFIRMED (one omission, below).**
Correctly placed under `## [Unreleased]` → `### Breaking Changes`, ahead of `### Added`,
matching the 0.6.0 section's ordering. Every factual claim in it checks out against the diff,
including "bare `--description` had no ADF preview at all." I also grepped the whole tree at
the PR head: the old placeholder literal `"<from stdin — not yet read in dry-run>"` survives
in exactly one place — the CHANGELOG entry describing it — with no stale references left in
`src/`, `tests/`, or `docs/`.

## Additional checks

- **Live-path parity:** the pre-step is a faithful mirror of the live single-key resolution at
  `edit.rs::handle_edit` (`desc_text` / `adf_body`) — same `spawn_blocking` + `read_to_string`
  idiom, same `if markdown { markdown_to_adf } else { text_to_adf }` selection. The
  "byte-identical to the live POST payload" claim holds for the single-key `PUT` path, which is
  the only path a description can reach (the C-1 multi-key guard rejects
  `--description`/`--description-stdin` upstream, before the dry-run block).
- **JSON render invariant (#526):** unchanged — output still goes through `output::render_json`.
- **Empty stdin:** `description: ""` + `text_to_adf("")` matches what the live path would PUT.
  Pinned by AC-7 in both modes.
- **Diff coherence:** every hunk serves the story. No drive-by edits.
- **Commits:** two, conventional, `feat(edit)!` with a `BREAKING CHANGE:` footer and the story/issue
  IDs; test commit precedes the feat commit (Red→Green ordering is visible in the history).
- **Diff size:** 882 additions, but 798 are tests and 20 are CHANGELOG — the behavioral surface is
  a 64-line/15-line change to one function. Well within reason.
- **CI at review time:** Format, both Clippy legs (ubuntu), Deny, MSRV, Spec Guards, gitleaks,
  dependency-review, signing guard all green; Test matrix, Windows clippy, Coverage, Mutation
  still pending. Merge should wait on the full gate.

## Findings

| # | Severity | Category | Finding |
|---|----------|----------|---------|
| 1 | suggestion | description | CHANGELOG omits the blocking-read consequence of the new stdin read |
| 2 | suggestion | coverage | No negative test pinning `descriptionAdf` **absent** when no description flag is passed |
| 3 | suggestion | missing | `docs/specs/json-output-shapes.md` still has no entry for the dry-run shape |
| 4 | nit | coherence | `--field`-resolved entries are merged *after* the description inserts and could shadow them |
| 5 | nit | coherence | New test file claims the generic name `tests/issue_edit.rs` for a narrowly-scoped suite |

### 1. [SUGGESTION] CHANGELOG understates the breaking change — `--dry-run --description-stdin` now blocks on stdin

The entry says the impact is that "automation asserting on the old literal placeholder string
will observe a different value." That's true but it's the *milder* half of the change. The
sharper half: `--dry-run` previously never touched stdin, so
`jr issue edit FOO-1 --description-stdin --dry-run` returned instantly regardless of what stdin
was attached to. It now performs a blocking `read_to_string(stdin)` and will **wait for EOF** —
so the same invocation from an interactive terminal, or from a CI step whose stdin is an
inherited open pipe, hangs instead of returning. A hang is a nastier failure mode for a caller to
diagnose than a changed string value, and it deserves an explicit sentence.

Suggested addition to the entry:

```
Note: `--dry-run --description-stdin` now performs a blocking read of stdin (matching the
live path). Invocations that previously returned immediately without stdin attached will
now wait for EOF — pipe input, or redirect from /dev/null.
```

### 2. [SUGGESTION] Add the negative pin: `descriptionAdf` must be absent when no description flag is given

Every new test asserts the *presence* and *value* of `description`/`descriptionAdf`. Nothing
asserts their **absence** on an edit that supplies no description input. A regression that
emitted `"descriptionAdf": null` (or `text_to_adf("")`) for, say, a `--summary`-only dry-run
would slip through the entire suite — and it would be a real problem for consumers doing
`if 'descriptionAdf' in plannedChanges`.

The label-only invocation already inside AC-12
(`test_..._other_fields_remain_simplified_previews_unaffected_by_description_fix`) is the
natural home; it already parses that JSON:

```rust
let label_planned = label_parsed["plannedChanges"].as_object().unwrap();
assert!(
    label_planned.get("descriptionAdf").is_none() && label_planned.get("description").is_none(),
    "neither description nor descriptionAdf may appear when no description flag was supplied; \
     planned={label_planned:?}"
);
```

Two lines, no new test function, and it closes the one direction the suite currently can't see.

### 3. [SUGGESTION] Register the dry-run shape in `docs/specs/json-output-shapes.md`

That file is the repo's canonical registry of `--output json` shapes, and it documents the
dry-run envelopes for `issue attachment upload` and `issue attachment delete` in detail. Its
`issue edit` row (line 12) covers only the live success shape `{"key", "updated"}` — the dry-run
`{dryRun, issues, plannedChanges}` envelope has never been registered there. The omission
predates this PR, so it isn't a regression, but this PR is making a *breaking* change to exactly
that undocumented shape, which makes it the natural moment to add the row (and the one place a
downstream consumer would look to discover `descriptionAdf`).

### 4. [NIT] `--field` merge can shadow the description keys

In the JSON arm, `description`/`descriptionAdf` are inserted first, then:

```rust
for (field, value) in &dr_changed {
    planned.insert(field.clone(), json!(value));
}
```

`insert` overwrites. Gate B (BC-3.4.017) blocks `--field description=…` only when a description
flag is *also* present, and it lowercase-compares against the literal `"description"`, so
`descriptionAdf` isn't covered by it at all. A Jira instance with a custom field whose resolved
name collides would silently replace the rendered ADF preview with a bare string.

This is remote enough that I'd not block on it (it needs a field literally named
`description`/`descriptionAdf`), and the same shadowing shape predates this PR for other keys.
Cheapest hardening if you want it: insert the `dr_changed` loop **before** the first-party field
inserts, so first-party flags always win — or note the precedence explicitly in the existing
comment so the next reader doesn't have to re-derive it.

### 5. [NIT] Test file naming

`tests/issue_edit.rs` is the broadest possible name in a directory that already has
`issue_edit_echo.rs` and `issue_edit_field.rs`, but its contents are scoped entirely to
`--dry-run` stdin + ADF preview. A future story adding general `issue edit` integration tests
will reasonably reach for this filename and find it taken by an unrelated suite. Something like
`tests/issue_edit_dry_run_adf.rs` reads better alongside its siblings. Renaming a *new* file
costs nothing and doesn't touch the "don't rename existing tests for style" convention.

## Demo evidence

The PR cites 4 VHS clips at `.factory/demos/S-692-1/`, which is not part of this diff and not
visible to me, so I could not verify them. Noting for the record only: `docs/demo-evidence/` in
this repo carries in-tree evidence for several earlier stories (S-388, S-576-1..4, and others),
while the most recent stories do not — so the out-of-tree location appears to be current
practice rather than a deviation. Not treated as a finding.

## Bottom line

Focused, well-tested change that does exactly what the description says. The ordering guarantee
— the one part of this that could have gone quietly wrong — is correct by construction and
pinned behaviorally in both output modes. Nothing here should block merge once the remaining CI
legs (Test matrix, Windows clippy, Coverage, Mutation) come back green.
