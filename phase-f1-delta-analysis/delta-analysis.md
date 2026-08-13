---
document_type: delta-analysis
cycle: bucket1-defects
mode: brownfield-feature
producer: business-analyst
timestamp: 2026-08-13
status: complete
feature: bucket1-defects (issues #692, #663, #693, #694)
intent: bundle (enhancement x3, docs x1) — see per-issue table
feature_type: backend (all four)
scope: standard
trivial: false
route: Full F1-F7 bundle
---

# Phase F1 Delta Analysis: Bucket 1 — Defect/Enhancement Bundle (#692, #663, #693, #694)

## Feature Summary

Four independent, file-disjoint fixes to the `jr` Jira CLI, bundled for a single F1-F7
cycle per human/orchestrator decision. Impact-boundary analysis (architect,
`.factory/phase-f1-delta-analysis/bucket1-impact-boundary.md`) confirms none of the four
require new modules, new CLI surface, or structural architecture change — all are
INTERNAL. This report consumes that analysis and adds the affected-artifact map, intent/
trivial/severity classification, regression-risk assessment, and consolidated file/test
inventory needed to gate F2.

| # | Issue | One-line description |
|---|---|---|
| 1 | #692 | `issue edit --dry-run` never reads stdin, so `--description-stdin` ADF conversion cannot be previewed — a **spec reversal** of BC-3.4.021 Invariant 3 |
| 2 | #663 | `auth switch --profile` is a confusing no-op that also produces a third, inconsistent usage string |
| 3 | #693 | `queue view` discards queue-endpoint custom fields, then re-fetches a fixed field set that never includes them |
| 4 | #694 | Attachment subcommand help text / doc comments are stale or missing (docs-only, no behavior change) |

**BC IDs verified against source spec files (not taken on the briefs' word):** BC-3.4.021,
BC-3.4.013 (`bc-3-issue-write.md`); BC-1.2.018, BC-1.1.003, BC-1.1.007, BC-1.1.008,
BC-7.4.014 (`bc-1-auth-identity.md` / `bc-7-output-render.md`); BC-X.8.008, BC-X.8.009
(`cross-cutting.md`); BC-2.7.007, BC-2.7.008, BC-2.7.009, BC-2.7.010, BC-7.2.012
(`bc-2-issue-read.md` / `bc-7-output-render.md`) — all confirmed present with the exact
clause content the research briefs and architect cite. No dead citations found.

---

## Step 4b — Intent Classification

| Issue | Intent | Detection signal | Route |
|---|---|---|---|
| #692 | **enhancement** (behavior-change reversing a ratified decision, not a plain bug fix) | Fix reverses BC-3.4.021 Invariant 3, which currently blesses the placeholder as "correct… not a bug." The reporter is asking for new capability (ADF preview under dry-run), not restoration of documented behavior. | Full F1-F7 |
| #663 | **enhancement** (arguably bug-fix; classified enhancement because current behavior is spec-silent on the confusion, not spec-violating) | "confusing", "usage string diverges" — no documented contract is broken; a new guard is being added | Full F1-F7 |
| #693 | **bug-fix** (documented `Queue.fields` capability exists and is silently dropped; re-fetch returns wrong-shaped data relative to what the queue declares) | "drops", "discards", data loss between what the API returns and what `jr` surfaces | Full F1-F7 |
| #694 | **docs/enhancement** (no behavior change) | Pure help-text/doc-comment sync; underlying BCs already assert the true behavior | Full F1-F7 (docs-only path within it — skips F2 BC-body edits) |

**Bundle-level intent:** mixed (enhancement-leaning), **not** a pure bug-fix bundle — #692
is explicitly a decision reversal and #663 adds new rejection behavior, so the bundle does
not qualify for the bug-fix route (which would skip F2/F3). **Route: Full F1-F7 bundle**,
as the human already directed. This is corroborated independently: #692 requires a BC
Invariant reversal (F2 spec work, human-recorded DEC), #663 requires one new BC, and #693
requires a BC amendment — three of four issues touch BC bodies, which rules out both
quick-dev and a bug-fix-only skip of F2/F3.

## Step 4 — Feature Type Classification

All four issues are **backend / CLI** (feature_type = `backend`) — no web UI, no
accessibility surface, no browser rendering. This holds bundle-wide:

- #692: CLI dry-run preview output (JSON + table stdout) — backend.
- #663: CLI argument validation / dispatch guard — backend.
- #693: CLI table + JSON rendering of API-fetched fields — backend.
- #694: CLI `--help` text (clap doc comments) — backend.

**Consequence for later phases:** UX design, accessibility audit, and browser/Playwright
e2e steps are **SKIPPED bundle-wide** in F2-F7 (no `ux-designer`, no
`accessibility-auditor`, no `e2e-tester` browser pass). Where CLI-surface regression
testing is warranted it is covered by Rust integration tests (`tests/*.rs`), not
browser e2e.

## Step 4c — Trivial-Scope Classification

Assessed against all four required-ALL criteria:

| Criterion | #692 | #663 | #693 | #694 | Bundle |
|---|---|---|---|---|---|
| Single module/file or docs-only | Single file (`edit.rs`) but BC reversal, not docs-only | Single file (`main.rs`) | Single file (`queue.rs`) + one dependent test surface | Docs-only (`mod.rs` doc comments) | **NOT uniformly trivial** |
| No new BCs needed | **FALSE** — amends BC-3.4.021 in place (reversal) | **FALSE** — adds one new BC | **FALSE** — amends BC-X.8.009 | TRUE — no BC body change | **FALSE** (3 of 4 fail) |
| No architecture change | TRUE | TRUE | TRUE | TRUE | TRUE |
| No new external dependencies | TRUE | TRUE | TRUE | TRUE | TRUE |
| Regression risk LOW | FALSE (see risk table below — MEDIUM) | TRUE (LOW) | FALSE (MEDIUM) | TRUE (LOW) | **NOT uniformly LOW** |

**Verdict: NOT TRIVIAL.** Reason: three of the four issues (#692, #663, #693) require a
BC body change (one an explicit spec reversal, one a net-new BC, one an amendment), which
alone disqualifies quick-dev routing per the scoping rule ("no new BCs needed" must be
true for ALL bundle members). #692 additionally carries a decision-reversal that must be
recorded as an explicit superseding DEC in F2 — this is process weight quick-dev's
compressed pipeline (F1→F4→regression→F7-lite) has no mechanism to carry. #694 alone
would qualify as trivial/docs-only in isolation, but is bundled with three non-trivial
siblings and does not need to be split out — its cost is near-zero regardless of route.
**Recommended scope: Full F1-F7 bundle**, matching the pre-existing human/orchestrator
decision. This is not a close call.

## Step 4d — Severity Classification

Not applicable bundle-wide: only #693 is bug-fix intent, and even there classification is
informational, not routing (bundle already routes Full F1-F7, so CRITICAL-severity
expedited-flow shortcuts are not invoked for any single issue inside the bundle).

| Issue | Severity (informational) | Rationale |
|---|---|---|
| #693 | **LOW** | Read-only command, no data loss on the server side (data still fetchable via `jr api`), workaround exists (`jr api /rest/servicedeskapi/.../queue/{id}/issue` directly). Not production-down, not security. |

No issue in this bundle qualifies for CRITICAL/HIGH severity or the expedited flow.

---

## Affected-Artifact Map (BC-S.SS.NNN terms)

### #692 — `issue edit --dry-run` stdin/ADF preview

| BC | Status | Change |
|---|---|---|
| BC-3.4.021 | **MODIFIED (reversal)** | Invariant 3 currently asserts placeholder-not-a-bug → REVERSED to assert stdin is read + ADF rendered. `--output json` Postconditions #3, `--output table` Postconditions #3, EC-3.4.021-6 all rewritten. Postconditions-json #1 ("exactly three top-level keys") preserved by nesting the new field inside `plannedChanges` (hard constraint per architect). **MUST be recorded in F2 as an explicit superseding DEC, not a silent amend-in-place**, per human ruling. |
| BC-3.4.013 | **UNCHANGED** (cross-reference only) | Raw-input invariant for `plannedChanges.description` / `changed_fields.description` (#398) is explicitly preserved — the ADF preview is additive (`plannedChanges.descriptionAdf` or equivalent), not a replacement. Annotation-only cross-ref check in F2, no body edit expected. |
| BC-7.2.012 | **UNCHANGED** (cross-reference) | `MAX_ADF_DEPTH = 256` guard's `Err` becomes reachable from dry-run for the first time; behavior of the guard itself is unchanged — new EC in BC-3.4.021 references it. |

**Regression-risk zone stories:** any story whose acceptance criteria assert the dry-run
placeholder string (`"<from stdin — not yet read in dry-run>"` / `"(read from stdin —
not yet read in dry-run)"`). Grep of `tests/*.rs` and `src/cli/issue/edit.rs` found **no
integration test currently pins either placeholder string** — the old behavior is
spec-pinned (BC-3.4.021) but not test-pinned. This narrows regression risk: F4 adds new
positive-path tests without needing to delete a contradicting old assertion.

**Existing covering tests (regression baseline / extension candidates):**
- `tests/issue_edit_echo.rs` — `test_bc_3_4_012_edit_echo_does_not_fire_on_dry_run` (dry-run/live echo boundary), `test_bc_3_4_013_description_stdin_trailing_newline_preserved_in_changed_fields` (live-path stdin handling, sibling behavior to mirror)
- `tests/issue_edit_field.rs` — `test_bc_3_4_015_field_dry_run_exits_0_no_put`, `test_bc_3_4_015_field_dry_run_json_planned_changes_includes_field`, `test_bc_3_4_017_gate_a_fires_under_dry_run` (dry-run short-circuit family; establishes the JSON-shape assertion pattern F4 should follow for the new field)
- `tests/adf_recursion_depth.rs` — depth-guard `Err`→exit-64 tests (live path today); F4 must add a dry-run-scoped sibling per the architect's §5 recommendation

**VP extension:** this repo has no standalone `VP-NNN` file corpus (`.factory/specs/`
contains no `verification-properties/` directory) — VPs here are embedded inline in BC
bodies (e.g. VP-398-001/002 cited in BC-3.4.013's own text). No separate VP file needs
creation; F2's BC-3.4.021 rewrite carries its own EC set as the verification surface.

### #663 — `auth switch --profile` guard

| BC | Status | Change |
|---|---|---|
| BC-1.2.018 | **MODIFIED** | "Global `--profile` propagates to all auth subcommands" amended to carve out `auth switch` as the explicit exception (rejected, exit 64). |
| **New BC** (bc-1-auth-identity.md) | **NEW** | `auth switch --profile <X>` exits 64; `--output json` uses the standard `{"error","code":64}` envelope (#526 invariant, no extra formatter work — flows through the central `main.rs` error handler). |
| BC-1.1.003 | **UNCHANGED** (sibling reference) | `auth switch <unknown>` exits 64 — the new guard is a sibling behavior, not a modification of this BC. |
| BC-1.1.007 | **UNCHANGED** | Profile precedence chain for all other subcommands is unaffected. |
| BC-1.1.008 | **UNCHANGED** (review-only) | Confirm wording doesn't imply `auth switch` also honors `--profile` — no edit expected, review pass only. |
| BC-7.4.014 | **UNCHANGED** | Success-shape BC for `auth switch --output json`; unaffected — new error path uses the standard error envelope, not this shape. |

**Regression-risk zone:** `AuthCommand::Login`/`Status`/`Refresh`/`Logout` — each declares
its own subcommand-level `profile: Option<String>` and composes `profile.or_else(||
cli.profile.clone())`; these are explicitly OUT of scope and must not be touched (the
guard is `Switch`-only). `src/main.rs`'s `run()` dispatch and `validate_profile_name`
(pre-existing, called unconditionally before dispatch) are in the same file as the new
guard — sequencing matters (guard must fire before `Config::load_with`'s existence-check
side effect, per architect's refinement) but the code itself is untouched.

**Existing covering tests:**
- `tests/auth_profiles.rs` — `auth_switch_unknown_profile_exits_64` (existing BC-1.1.003
  coverage; establishes the exit-64 + positional-arg test pattern the new guard test
  should follow) — this file is the natural home for the new
  `auth_switch_rejects_profile_flag_exits_64` test plus a `--output json` envelope
  assertion.
- No existing test currently exercises `auth switch --profile X X` (the confusing
  double-name incantation) — confirms this is genuinely new test surface, not a hole in
  existing coverage.

**Explicitly out of scope (per human ruling, carried forward):** clap `conflicts_with`
belt-and-suspenders — dropped from scope entirely (documented unreliable for `global =
true` args per clap #5335/#5358, and incomplete for the flag-without-positional case).
Usage-string full unification (`<NAME>` vs `[OPTIONS] <NAME>` vs the promoted third form)
is accepted as universal clap behavior — not pursued via `override_usage`.

### #693 — `queue view` custom-field passthrough

| BC | Status | Change |
|---|---|---|
| BC-X.8.009 | **MODIFIED** | Step-3 fetch-pipeline contract (`search_issues(&jql, Some(keys.len()), &[])` with empty `extra_fields`) amended to: the queue's declared `fields[]` (filtered to real requestable field ids — pseudo-tokens like `issuekey` and anything already in `BASE_ISSUE_FIELDS` dropped) are passed as `extra_fields`. JSON-output clause updated to acknowledge queue-configured custom fields now appear in `values[].fields`. **`--id` path costs one additional `list_queues` HTTP call** the `--name` path doesn't (architect's precision note) — this must be stated explicitly in the amended BC text, not left implicit. |
| BC-X.8.008 | **UNCHANGED** | `jr queue list` — already documents `Queue.fields` deserialization; no behavior change. |
| BC-2.2.028 (BASE_ISSUE_FIELDS family) | **UNCHANGED** | Field set is extended per-call via the existing `extra_fields` mechanism, not by changing the constant. |

**Regression-risk zone:** `src/cli/queue.rs::resolve_queue_by_name` return-shape change
(id-only → id + `Queue`, or a sibling helper) is the one signature-adjacent change in this
bundle — any other caller of `resolve_queue_by_name` is in the risk zone. Confirmed by
architect: `get_queue_issue_keys` (`src/api/jsm/queues.rs`) is unaffected — it already by
design discards `fields` for the key-listing step and does not need to change; the queue
metadata (`Queue.fields`) is obtained separately.

**Existing covering tests:**
- `tests/queue.rs` — `test_resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http`
  (directly exercises `resolve_queue_by_name`'s HTTP-call-count contract — must stay green
  if the function's return shape changes; a strong regression pin), plus the general
  `queue view`/`queue list` test suite in the same file (JSON/table output assertions to
  extend with a custom-field-present case).

**Explicit non-goals (both from the brief, endorsed by architect, carried forward):**
human-table column for custom fields (that is #575, out of scope here — JSON-only
surfacing is the full fix for #693's complaint); rendering directly from queue `fields`
without `search_issues` (Option 1, rejected — would blank Status/Priority/Assignee for
queues not configured to show them).

### #694 — attachment doc-comment sync

| BC | Status | Change |
|---|---|---|
| BC-2.7.010 | **UNCHANGED** (changelog note only) | Batch SHA-1 naming scheme already correctly specified; doc comment in `src/cli/mod.rs` simply syncs to match. |
| BC-2.7.007 / BC-2.7.008 | **UNCHANGED** (changelog note only) | Single-vs-batch filename distinction already specified. |
| BC-2.7.009 | **UNCHANGED** (changelog note only) | `--newest` filter-before-sort-before-truncate order already specified at `bc-2-issue-read.md:705`. |

**No BC body edit in this bundle for #694** — per human ruling, F2 records this issue as a
one-line frontmatter changelog note only: `"0 new BCs — help-text sync to
BC-2.7.010/BC-2.7.008/BC-2.7.009 for #694"`, following the established convention already
used elsewhere in `bc-2-issue-read.md`'s changelog.

**Regression-risk zone:** none — no logic path is touched. `src/cli/issue/attachments.rs`
(`sha1_hex`, `compute_default_output_path`, `handle_batch_download`) is the implementation
the new doc text describes and is explicitly DEPENDENT/unchanged.

**Existing covering tests (unaffected, confirm-only in F4):** `tests/attachment_download.rs`,
`tests/attachment_list.rs`, `tests/attachment_upload.rs`, `tests/attachment_delete.rs`,
`tests/attachment_jsm.rs` — none require modification; a doc-comment-only diff has no
test-visible surface.

---

## Step 5 — Regression Risk Assessment (per module)

| Module | Issue(s) | Change type | Risk | Rationale |
|---|---|---|---|---|
| `src/cli/issue/edit.rs` | #692 | MODIFIED (dry-run block only) | **MEDIUM** | Large (2,067 LOC, ADR-0012 exception), state-mutating command path overall — but the fix touches only the dry-run short-circuit block, which returns before any HTTP call; the live/mutating path (the actual risk surface of this file) is untouched. Not HIGH because no secrets/auth/network trust boundary is touched and the change is additive (new field), not a removal. Not LOW because it reverses a currently-pinned spec Invariant and the file is large enough that scope creep into the live path is a real implementer-discipline risk. |
| `src/adf.rs` | #692 (dependent) | DEPENDENT (unchanged) | **LOW** | Already-`pub` functions (`markdown_to_adf`, `text_to_adf`) called, not modified. Existing depth-guard behavior (BC-7.2.012) unchanged — only newly *reachable* from a different call site. |
| `src/main.rs` | #663 | MODIFIED (one new guard arm) | **LOW-MEDIUM** | Entry-point/dispatch module (SS-01) — any bug here has broad blast radius in principle, but the change is a single additive `if` guard on one match arm (`AuthCommand::Switch`), does not touch `validate_profile_name`, `Config::load_with`'s existing logic, or any other `AuthCommand` variant's dispatch. Sequencing (guard before config load) is the one thing worth a close review pass. |
| `src/cli/auth/switch.rs` | #663 (alternative site, not primary) | DEPENDENT (unchanged if `main.rs` is the guard site per recommendation) | **LOW** | `handle_switch_in_memory`'s write logic is explicitly unchanged regardless of which site hosts the guard. |
| `src/cli/queue.rs` | #693 | MODIFIED (`resolve_queue_by_name` return shape + `handle_view` step 2 argument) | **MEDIUM** | Only module in this bundle with a signature-adjacent change (return-shape change on a function with at least one other confirmed caller in the same file's test suite). Read-only command (no mutation), but the return-shape change is the one place a careless refactor could silently break the ambiguous-queue-name HTTP-call-count contract (`test_resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http`). |
| `src/api/jsm/queues.rs`, `src/types/jsm/queue.rs`, `src/api/jira/issues.rs` | #693 (dependent) | DEPENDENT (unchanged) | **LOW** | Confirmed by both brief and architect: `get_queue_issue_keys` needs no change (already discards `fields` by design for its own purpose); `search_issues`'s `extra_fields` parameter already exists — #693 supplies a non-empty value at the call site only, no signature change. |
| `src/cli/mod.rs` | #694 (required), #663 (optional/not required) | MODIFIED (doc comments only) | **LOW** | Clap derive doc-comment edits only, in the `AttachmentSubcommand` region (lines ~651-880). No logic path touched. File-level overlap with #663 exists only if #663's implementer also chooses to add a `mod.rs` gotcha comment near the global `--profile` flag (line ~47) — disjoint region, not a real merge risk (confirmed by architect). |
| `src/cli/issue/attachments.rs` | #694 (dependent) | DEPENDENT (unchanged) | **LOW** | Implementation the new doc text describes; zero logic change. |

**Bundle-wide HIGH-risk modules: none.** The highest-rated module in this bundle is
MEDIUM (`edit.rs` for #692, `queue.rs` for #693), both for structural/process reasons
(large file, one signature-adjacent change) rather than security or mutation-surface
reasons. This corroborates the architect's informal criticality read (no
`module-criticality.md` exists in this repo; ratings here are informal, using
`ARCH-INDEX.md`'s subsystem registry as the closest available reference).

**Security-reviewer sign-off:** **not mandatory for any of the four stories** — no issue
touches secrets, tokens, keychain storage, OAuth flow, or a network trust boundary.
Standard code review is sufficient bundle-wide, per architect's finding, independently
confirmed here: none of the affected files (`edit.rs`'s dry-run block, `main.rs`'s Switch
arm, `queue.rs`'s read-only fetch, `mod.rs`'s doc comments) appear in CLAUDE.md's
documented security-sensitive-file list (`api/auth.rs`, `auth_embedded.rs`, keychain
modules — none touched here).

---

## Files Likely MODIFIED (per story)

**#692:**
- `src/cli/issue/edit.rs` — dry-run block, both `OutputFormat::Json` and `OutputFormat::Table` arms
- `.factory/specs/prd/bc-3-issue-write.md` — BC-3.4.021 amend-in-place + explicit reversal note (recorded as a superseding DEC in F2, not silent)
- `tests/issue_edit_echo.rs` and/or a new integration test module — `issue edit --dry-run --description-stdin` coverage (stdin-read + ADF-render + new field), plus a dry-run-scoped depth-guard-`Err`→exit-64 test

**#663:**
- `src/main.rs` — `AuthCommand::Switch` dispatch arm, new runtime guard (preferred site, fires before `Config::load_with`)
- `.factory/specs/prd/bc-1-auth-identity.md` — amend BC-1.2.018 + add new BC
- `CLAUDE.md` — one-line gotcha note (`--profile` rejected on `auth switch`; use positional)
- `tests/auth_profiles.rs` — new exit-64 assertion + `--output json` envelope test

**#693:**
- `src/cli/queue.rs` — `resolve_queue_by_name` return-shape change (or sibling helper) + `handle_view` step-2 `extra_fields` argument
- `.factory/specs/prd/cross-cutting.md` — BC-X.8.009 amendment (including the `--id`-path extra-HTTP-call note)
- `tests/queue.rs` — new integration test(s) asserting queue-declared custom fields appear in `--output json`

**#694:**
- `src/cli/mod.rs` — three doc-comment edits: `Attachment` parent `about` (line ~651), `out_dir` help (~786-790), `newest` help (~773-779)
- `.factory/specs/prd/bc-2-issue-read.md` — frontmatter changelog line only, no body change

## Files NOT Changed (regression baseline)

- `src/adf.rs` (all of it — called, not modified)
- `src/cli/issue/edit.rs` — live (non-dry-run) edit path, bulk/multi-key paths, `--field`/`--label`/`--type`/`--points` flag handling
- `src/cli/auth/switch.rs::handle_switch_in_memory` (actual profile-write logic)
- `src/config.rs::validate_profile_name` and all `Config::load_with` internals
- Every other `AuthCommand` variant's `profile.or_else(...)` composition (`Login`, `Status`, `Refresh`, `Logout`)
- `src/api/jsm/queues.rs::get_queue_issue_keys` (pagination/key-extraction)
- `src/types/jsm/queue.rs` structs (no field changes)
- `src/api/jira/issues.rs::search_issues` signature (caller-side argument value only)
- `src/cli/issue/format.rs::format_issue_row` / `issue_table_headers` (table output unchanged — 6 columns as today)
- `src/cli/issue/attachments.rs` (all logic — `sha1_hex`, `compute_default_output_path`, `handle_batch_download`, `handle_single_download`, filter/sort/truncate order)
- All attachment integration tests (`tests/attachment_*.rs`) — confirm-only, no edits expected
- `BC-X.8.008`, `BC-1.1.003`, `BC-1.1.007`, `BC-1.1.008`, `BC-7.4.014`, `BC-3.4.013`, `BC-2.7.007/008/009/010`, `BC-7.2.012` bodies (all cross-referenced, none amended)

---

## Cross-Issue Coupling (from architect, confirmed)

- **No two issues share a Rust source file with overlapping logic.**
- `src/cli/mod.rs` has file-level (not line-level) overlap between #663 (optional,
  doc-only, not required by the recommended fix) and #694 (required, doc-only) — disjoint
  regions (`AuthCommand`/global-flag area vs. `AttachmentSubcommand` area). Not a merge
  risk; implementers should be told their `mod.rs` edits (if any) are comment-only and in
  disjoint regions so parallel worktrees are safe.
- **Spec files are fully disjoint**: #692 → `bc-3-issue-write.md`; #663 →
  `bc-1-auth-identity.md`; #693 → `cross-cutting.md`; #694 → `bc-2-issue-read.md`
  (changelog-only).
- **All four stories can be delivered in isolated worktrees with no forced sequencing.**

---

## Recommended Scope for F2-F7

| Phase | Bundle-wide scope | Per-story notes |
|---|---|---|
| **F2 (Spec Evolution)** | Full — 3 of 4 stories touch BC bodies | #692: amend BC-3.4.021 **as an explicit superseding DEC**, not silent amend (human ruling — highest-attention item in F2). #663: amend BC-1.2.018 + add 1 new BC. #693: amend BC-X.8.009 (include the `--id`-path extra-call note explicitly in the amended text). #694: **SKIPPED** — no BC body change, changelog-note only. |
| **F3 (Incremental Stories)** | Full — 4 new/updated stories, no dependency-graph cycles (files fully disjoint, no forced wave ordering) | All four stories can be scheduled in the same wave. |
| **F4 (Delta Implementation)** | Full TDD per story + full regression suite as safety net | UX/a11y steps SKIPPED (all backend/CLI). Browser e2e SKIPPED (CLI-only; Rust integration tests are the e2e surface here). |
| **F5 (Scoped Adversarial)** | Full, scoped to the four stories' diffs | #692 is the priority target — an adversary pass is the named risk-catcher for an under-documented decision reversal (per both research brief and architect). |
| **F6 (Targeted Hardening)** | Full regression + security scans on full tree; **no security-reviewer sign-off required** for any of the four stories (none touch secrets/auth/keychain/network trust boundary) | Mutation testing (`cargo mutants --in-diff`) scoped to the bundle's diff per standard policy. |
| **F7 (Delta Convergence)** | Full five-dimensional convergence check + regression on full codebase | Final human gate before bundle merge/release. |

**No story in this bundle qualifies for quick-dev routing individually or as a bundle.**
Bundle-level route confirmed: **Full F1-F7**, as directed.

---

## Human Approval Gate — Questions to Resolve

1. Is the #692 scope correct (fix-only, no `jr adf render` primitive, ADF preview additive
   inside `plannedChanges`, no `--file` flag on `issue edit`)? Confirm the DEC-reversal
   framing for F2 is acceptable as scoped.
2. Is the #663 scope correct (runtime guard in `main.rs`, no clap `conflicts_with`
   belt-and-suspenders, usage-string full unification explicitly out of scope)?
3. Is the #693 scope correct (Option 2 — thread `Queue.fields` into `extra_fields`; JSON-only,
   no table column; `--id` path's extra `list_queues` call accepted)?
4. Is the #694 docs-only scope (changelog-note-only, no BC body edit) acceptable?
5. Should any of the four be split out of the bundle for independent, faster delivery
   (e.g., #694 alone would qualify as trivial in isolation)? Recommendation: **no** — the
   marginal delivery cost of keeping #694 in the bundle is near-zero (docs-only, no test
   changes, no regression risk), and splitting adds coordination overhead for negligible
   gain.
6. Confirm: Feature Mode (this bundle) is appropriate scope — **not** a Full Pipeline
   restart. Agreed; no architecture/domain-spec/PRD-level change is implicated.

**Phase F1 is complete only when the human explicitly approves this scope.**
