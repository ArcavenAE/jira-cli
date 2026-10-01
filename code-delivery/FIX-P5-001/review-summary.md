# Review Summary — FIX-P5-001 (PR #891)

**Closes:** `SEC-001-RENDER-TABLE-ANSI-SANITIZE` (MEDIUM, CWE-150/CWE-116), human decision `D-392`.
**PR:** #891, "fix(FIX-P5-001): sanitize table output against terminal escape injection
(SEC-001, CWE-150)". Squash-merged to `develop` by the human 2026-10-01T03:48:52Z, merge commit
`769365ab99be60c92a3494d630c423b962a0509d`. Final CI head `2973ef65`: 24/24 checks green.

This document narrates every review round in order, in prose, as the authoritative record of
how the PR's scope grew from a single-chokepoint fix to a four-sink fix across three human
decisions (`D-393`, `D-394`, `D-395`).

## Round 1 — pr-review cycle 1: REQUEST_CHANGES

First `pr-reviewer` pass confirmed the core fix was correct and complete for `render_table`'s
own call sites: `sanitize_table_cell` runs inside both `render_table` and
`render_table_with_styles`, covering all 9 direct `render_table` production sites
(`issue/attachments.rs` x4, `assets/view.rs` x2, `assets/schemas.rs`, `auth/list.rs`,
`issue/view.rs`), the ~30 `print_output` sites, and the 2 `user.rs` styled sites. `clippy -D
warnings` and `fmt --check` were clean, and the targeted test suites passed.

One blocking finding, **B-1**: the styled path (`render_table_with_styles` /
`print_output_with_styles`, used by `jr user list`/`jr user view`) had no test coverage for
either its sanitization or its structural-styling behavior. A regression to
`Cell::new(&c.text)` would silently reopen SEC-001 for user commands without failing any
existing test. Eight non-blocking nits accompanied it (stale Red-Gate comments, inaccurate
rustdoc claims, an out-of-date CLAUDE.md size figure, duplication between the plain and styled
render functions, a column-order fragility in `format_user_row_styled`, a documented Unicode
residual, and a note that non-table human output sits outside this BC's scope).

## Round 2 — pr-review cycle 2: APPROVE

B-1 was closed with new unit tests exercising `render_table_with_styles`/
`print_output_with_styles` directly against hostile `StyledCell`s, plus an end-to-end `jr user
list` case in `tests/table_output_sanitization.rs`. The reviewer verified the regression is
actually caught by reverting `src/output.rs`'s `Cell::new(&c.text)` line locally and confirming
both new tests failed, then restoring the file. Most of the Round 1 nits were fixed; three
minor stale-comment nits remained, explicitly accepted as non-blocking. Verdict: **APPROVE**,
no blocking findings, review converged at this point for the render_table scope.

## Round 3 — Security review 1 (fresh reviewer): REQUEST_CHANGES on SEC-003

The PR's original security-reviewer dispatch hung for hours and never returned; the orchestrator
dispatched a fresh security-reviewer agent. That fresh review found **SEC-003** (HIGH,
CWE-150/CWE-116): `jr issue comment view`'s human output is not a `render_table` call site —
`handle_comment_view` prints its six labeled fields and ADF-derived body directly via
`print!`/`println!`, bypassing the new sanitizer entirely. The review also flagged that the PR's
own description overclaimed coverage ("every table-mode command"), which was not true once a
non-`render_table` sink existed.

This became **D-393** (human decision, 2026-09-30): extend the fix, in the same PR, to cover
comment view. It was implemented via the `output::sanitize_terminal_text` alias of
`sanitize_table_cell`, and the PR's coverage claims were corrected to state precisely what is
and is not covered. Spec `bc-7-output-render.md` BC-7.1.006/VP-SEC-001-001 moved to `v2.5.2`.

## Round 4 — Delta reviews: APPROVE, with W-1 and W-2

With the D-393 fix landed, a delta `pr-reviewer` pass returned **APPROVE** with two
non-blocking warnings: **W-1**, the Out-of-scope residual list was incomplete relative to what
the reviewer could find by inspection; and **W-2**, the comment-view fields `id`/`created`/
`updated` were sanitized by the same function but had no dedicated test pinning that they
specifically survive a hostile value. Both were fixed directly: the residual list was widened
and explicitly marked "known, non-exhaustive" rather than implying completeness, and dedicated
test coverage was added for the three previously-untested fields.

## Round 5 — Security re-review: APPROVE, plus the `handle_assign` finding (→ D-394)

The security re-review approved D-393's comment-view fix outright, but separately surfaced a
second, independent residual with the identical exposure class: `jr issue assign`
(`handle_assign`, `src/cli/issue/workflow.rs`) echoes the assignee's server-side, user-editable
Jira `displayName` raw in both its changed-assignment and idempotent-already-assigned human
success messages — again not a `render_table` call site.

This became **D-394** (2026-09-30): fix it in the same PR. Both `print_success` call sites in
`handle_assign` now sanitize via `sanitize_terminal_text`; the `--unassign` path (key-only, no
server text) stays explicitly out of scope. `--output json`'s `assignee` field stays lossless.
Spec moved to `v2.5.3`.

## Round 6 — D-394 reviews: PR APPROVE; Security REQUEST_CHANGES on SEC-891-2 (→ D-395)

`pr-reviewer` approved the `handle_assign` fix with no new blocking findings. The security
reviewer, however, found a third sink of the same class: `SEC-891-2` (MEDIUM, CWE-150/CWE-116)
— the shared resolver `src/cli/issue/helpers.rs::disambiguate_user` echoes raw
`display_name`/`email_address`/`account_id` in its `ExactMultiple`/`Ambiguous`/`None`-branch
`JrError::UserError` messages, its interactive `dialoguer::Select` picker labels, and the
`None`-branch "Found: …" candidate list. This resolver is reached from four call sites:
`jr issue assign --to`, `jr issue create`/`edit --assignee`, `jr issue list --assignee`, and
`@Name` mention resolution.

This became **D-395** (2026-09-30): fix it at construction time, inside `disambiguate_user`
itself, covering all four callers uniformly via a new, factored-out `disambiguation_labels`
helper for the interactive-picker label text. Because `src/main.rs`'s single error-formatting
site builds both the human-text and `--output json` error envelope from the same already-
sanitized `JrError::UserError` `Display` string, the JSON error envelope is sanitized too — a
deliberate asymmetry from `render_table`'s table/JSON split, documented as a spec decision
rather than a bug. **D-395 also froze PR #891's scope**: any further residual found after this
point goes on the known, non-exhaustive residual list rather than triggering another PR
amendment. Spec moved to `v2.5.4`.

## Round 7 — Final reviews: both APPROVE, nits fixed in `2973ef65`

Both the final `pr-reviewer` pass and the final security re-review returned **APPROVE** with
zero blocking findings. A small number of nits (stale comment wording, a miscount in an earlier
version-history row) were fixed directly in commit `2973ef65`, which became the PR's final CI
head (24/24 checks green).

## Final non-blocking item: `resolve_asset` (MEDIUM, residual)

The final security review additionally flagged `src/cli/issue/helpers.rs::resolve_asset` (the
Assets `--asset` disambiguation flow) as a MEDIUM residual with the identical exposure class as
`disambiguate_user`'s now-covered sink — it echoes raw server-supplied `label`/`object_key`
values unsanitized in both its `JrError` messages and its `dialoguer::Select` picker items.
Because this was raised *after* D-395's scope freeze, it was not fixed under this PR. It is
recorded as a new entry in the `NONTABLE-SERVER-TEXT-SANITIZE` residual list
(`cycles/OPEN-STANDING-ITEMS.md`), flagged as MEDIUM/priority for the next maintenance sweep or
a future security-hardening cycle, and in spec `v2.5.5`'s post-merge amendment to
`bc-7-output-render.md` BC-7.1.006's Out-of-scope paragraph.

## Outcome

16+ commits landed on the PR in total (stub/RED/fix/docs triplets for each of the four scope
extensions above, plus review-nit commits) — every commit type used was valid for its content.
One commit subject (`stub(issue):`) was reworded to `refactor(issue):` before it was pushed, to
match its actual content. Spec `bc-7-output-render.md` progressed `v2.5.1` → `v2.5.2` (D-393) →
`v2.5.3` (D-394) → `v2.5.4` (D-395) → `v2.5.5` (post-merge citation/test-name correction +
`resolve_asset` residual). BC count held at 773 throughout; VP count held at 98. PR #891 merged
squash to `develop` at `769365ab` with a clean final review state on both review tracks.
