---
document_type: delta-analysis-report
feature_name: "big-function-extraction — decompose edit.rs::handle_edit and list.rs::handle_list into cohesive sub-functions (behavior-preserving refactor)"
created: 2026-09-24
spec_version_at_analysis: "BC-INDEX.md total_bcs=770 (cumulative), definitional_count=118, VP=89, stories=191 (unchanged since cycle-009 close); develop tip 09bb2803, v0.8.0-dev.1"
status: draft
intent: "refactor (maps to enhancement — see Classifications; not feature, not bug-fix)"
feature_type: "backend"
scope: "standard"
severity: "N/A"
---

# Delta Analysis Report: big-function-extraction (cycle-010)

## Feature Request

- **Brief:** Human selected the two HIGH findings from the completed tech-debt
  assessment (`.factory/maintenance/tech-debt-assessment-2026-09-24.md`) for a
  dedicated refactoring cycle:
  - **TD-01:** `src/cli/issue/edit.rs::handle_edit` (`pub(super) async fn`, L45)
    is a single ~1,314-LOC function (confirmed by direct read: next sibling fn
    `edit_issue_components` begins at L1359, so the span is L45–L1358).
  - **TD-02:** `src/cli/issue/list.rs::handle_list` (`pub(super) async fn`, L152)
    is a single ~775-LOC function (confirmed: next sibling fn
    `resolve_component_clauses` begins at L927, so the span is L152–L926).
  Both file sizes (`edit.rs` 3,287 total / 2,511 prod LOC, `list.rs` 2,057 total /
  1,239 prod LOC) are documented-intentional in `CLAUDE.md`'s "Known Size
  Deviations" per ADR-0012 (single command-family cohesion) — the tech-debt
  report explicitly does **not** re-litigate the file-level DOCUMENT-AS-IS
  rationale. What it flags as genuinely undocumented debt is the
  **function-level** monolith inside each file.
- **Requested by:** Human, following review of the tech-debt assessment.
- **Date:** 2026-09-24.
- **Working cycle id:** cycle-010 (slug `big-function-extraction`). Confirmed
  free per `.factory/STATE.md` (line ~157: "Cycles 010-011 remain PARKED") —
  no numbering conflict, unlike cycle-009's provisional-number caveat.

## Critical Framing (governs every classification below)

This is a **behavior-preserving refactor**, not a feature or bug fix:
- External behavior of `jr issue edit` and `jr issue list` (stdout, stderr,
  exit codes, JSON shapes, flag handling, error message text) MUST be
  byte-for-byte identical before and after.
- Therefore **zero BC amendments** — all existing BC-3.4.001..037 (edit) and
  BC-2.1.001..025 (list) contracts are the thing being *preserved*, not
  evolved. F2 (spec evolution) is NULL for this cycle (see Scope
  Recommendation) — this is confirmed explicitly below, not merely assumed.
- The refactor is "green-to-green": every extraction step must keep the full
  existing suite passing, run incrementally, never as one big-bang rewrite.

## Classifications

### Intent Classification

| Intent | Detection Signals | Route |
|--------|------------------|-------|
| `feature` | Human says "add", "build", "new" | Full F1-F7 |
| `enhancement` | Human says "improve", "update", "change" | Full F1-F7 (may be quick dev if trivial) |
| `bug-fix` | Human says "fix", "bug", "broken", "regression" | Bug fix route (skip F2, F3) |

**Classified intent:** none of the three template buckets fit cleanly —
recorded as **`enhancement`** for routing purposes, with the caveat that it is
specifically an **internal-quality / maintainability refactor**, not a
user-facing improvement. This is closer to `enhancement` than `bug-fix`
(nothing is broken; `jr issue edit`/`jr issue list` behave correctly today)
and closer to `enhancement` than `feature` (no new capability). Unlike a
typical `enhancement`, though, the defining constraint is that the *output*
of the change must be externally invisible — flagged as an open question at
the F1 gate (see Open Questions) since this is the first refactor-only cycle
this project's Feature Mode routing has classified, and neither template
bucket names this case explicitly.
**Rationale:** Source is a completed tech-debt assessment (not a bug report,
not a capability request); `feedback_vsdd_process.md` (user memory) requires
all changes — including maintenance/refactor work — to go through the full
VSDD Feature Mode pipeline, so routing through F1-F7 (with F2/F3 scoped down
per the analysis below, not skipped by intent classification alone) is
correct regardless of which bucket label is used.

### Feature Type Classification

**Classified type:** `backend`
**Rationale:** Confined to two CLI command-handler files (`src/cli/issue/edit.rs`,
`src/cli/issue/list.rs`) and possibly new sibling submodule files under
`src/cli/issue/edit/` and/or `src/cli/issue/list/`. No UI/rendering surface
(CLI table/JSON output already exists and must not change), no new external
dependency, no infrastructure/CI change.

### Trivial Scope Classification

- [ ] Impact boundary: single module, single file, or documentation only —
  **FALSE**. Two independent files/command families (`edit.rs`, `list.rs`),
  each a candidate for its own submodule split. Not single-file.
- [x] No new BCs needed — **TRUE**, this is the defining constraint of the
  cycle (behavior-preserving; see Critical Framing).
- [x] No architecture change — **TRUE** at the ARCH-INDEX/module-decomposition
  level: no new subsystem, no new interface, no purity-boundary shift (both
  functions are already effectful-shell CLI handlers; decomposing into private
  sub-functions within the same module/crate boundary doesn't cross a
  documented boundary). A new `mod edit;`/`mod list;` directory (if chosen)
  is an internal module-organization change, not an architectural one —
  flagged for architect sign-off at the F1 gate regardless (see Open
  Questions), since `module-decomposition.md`/`purity-boundary-map.md` should
  at minimum note the new file layout for accuracy.
- [x] No new external dependencies — **TRUE**.
- [ ] Regression risk: LOW — **FALSE, assessed HIGH** (see Risk Assessment).
  `handle_edit`/`handle_list` are two of the highest-traffic write/read code
  paths in the CLI; `too_many_lines` clippy findings independently confirm
  both are outlier-complexity functions; no snapshot-test safety net exists
  for `list.rs`'s table-rendering path (see Regression Baseline).

**Classified scope:** `standard`
**Rationale:** Fails 2 of 5 trivial criteria (impact boundary spans 2
files/command-families; regression risk is HIGH, not LOW). Quick-dev routing
is **not** applicable — this is not documentation-only and not a clean
single-file low-risk change, even though it produces zero new BCs.

### Severity Classification (bug-fix intent only)

**N/A** — intent is not `bug-fix`; nothing is currently broken. No severity
classification applies. (Recorded as `N/A` per template convention, not
omitted, to make the non-applicability explicit rather than silent.)

## Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements | **0 new, 0 modified** | All of BC-3.4.001 through BC-3.4.037 (37 BCs, section "3.4 Edit and Open" in `.factory/specs/prd/bc-3-issue-write.md`) and BC-2.1.001 through BC-2.1.025 (25 BCs, section 2.1 in `.factory/specs/prd/bc-2-issue-read.md`) are the PRESERVE-set — confirmed zero amendments intended. Caveat: BC-3.4.* section title is "Edit **and Open**" — some BC-3.4.* IDs may trace to `jr issue open` (implemented in `workflow.rs`, out of scope for this cycle) rather than to `handle_edit` itself; F2 (if run at all) or F4 implementation must confirm the exact BC↔fn mapping before treating the full 001–037 range as edit.rs-scoped. Not re-verified line-by-line in this F1 pass — flagged as a to-do for whichever phase does the fine-grained BC↔test trace (recommend F4 pre-step, see Scope Recommendation). |
| Architecture | 0 components added, 0 modified (proposed) | No new subsystem/interface/purity-boundary change at the ARCH-INDEX level. If new submodule directories (`edit/`, `list/`) are introduced, `module-decomposition.md` should get a file-layout note for accuracy — lightweight, not a structural architecture change. Architect sign-off recommended at F1 gate rather than a full F2 architecture delta. |
| UX Screens | N/A | CLI-only; no UX artifacts exist for these commands. |
| Stories | 0 new stories (recommended) | See Scope Recommendation — F3 proposed SKIPPED; extraction waves tracked via burst-log/cycle-manifest instead of STORY-NNN files, consistent with cycle-009's precedent for scoped, non-BC-generating cycles. |
| Existing Tests | ~370-390 tests in the combined risk zone (approximate census, not exhaustive — see Regression Baseline) | Dedicated files: `tests/issue_edit*.rs` (7 files, 133 test fns), `tests/issue_list_{assets,errors,oauth_scope}.rs` (3 files, 15 test fns); shared file: `tests/issue_commands.rs` (~71 edit-named + ~74 list-named test fns out of 219 total in that file, by substring match on fn name — approximate, not BC-exhaustive); `tests/cli_smoke.rs` (~17 edit/list-related, combined count); inline unit tests in the source files themselves (`edit.rs` 14, `list.rs` 13); one insta JSON snapshot for edit's echo path (`src/cli/issue/snapshots/jr__cli__issue__json_output__tests__edit.snap`, in `json_output.rs`, not `edit.rs` itself). **No insta snapshot exists for `list.rs`'s table-rendering output** — that surface is covered only by string/substring assertions in the integration tests, a real regression-net gap (see Regression Baseline recommendation). |
| Verification Properties | 0 new VPs (expected) | No VP-NNN currently governs `handle_edit`/`handle_list` as monolithic units; decomposition into named sub-functions is an opportunity to *add* narrow VPs later (e.g., a pure sub-function extracted for JQL composition could become proof-eligible) but that is out of scope for this behavior-preserving cycle — flagged as a possible F6-adjacent follow-up, not required here. |

## Files Changed

### New Files (proposed, pending F1-gate decision on structure — see Open Questions)

| File Path | Purpose |
|-----------|---------|
| `src/cli/issue/edit/mod.rs` (if submodule split chosen) OR private fns added in-place in `edit.rs` | Houses the decomposed `handle_edit` dispatch + extracted sub-functions (see Decomposition Seams below) |
| `src/cli/issue/list/mod.rs` (if submodule split chosen) OR private fns added in-place in `list.rs` | Houses the decomposed `handle_list` dispatch + extracted sub-functions |
| Possible new characterization-test files (e.g. `tests/issue_edit_characterization.rs`, `tests/issue_list_characterization.rs`) — see Regression Risk Assessment recommendation | Golden-output snapshot/table-string tests added BEFORE extraction begins, to catch any accidental behavior drift the existing suite doesn't already pin |

### Modified Files

| File Path | Change Type | Risk |
|-----------|------------|------|
| `src/cli/issue/edit.rs` | Internal-only decomposition of `handle_edit` (L45–1358) into a thin dispatch fn + named private sub-functions; **zero signature change to `handle_edit` itself** (same params, same return type, same call site in `mod.rs`/dispatch); zero change to any other fn in the file (`edit_issue_components`, `handle_edit_bulk_labels`, `handle_edit_bulk_components`, `handle_edit_bulk_fields`, etc. at L1359+ are explicitly OUT of this decomposition — they are already reasonably-sized siblings per the tech-debt report) | HIGH — largest, most complex handler in the CLI; touches the mutual-exclusion gate, single/bulk routing, field/label/type/component dispatch, `--dry-run`, `--jql` resolution, and type-error enrichment, all currently sharing one stack frame |
| `src/cli/issue/list.rs` | Internal-only decomposition of `handle_list` (L152–926) into a thin dispatch fn + named private sub-functions (`compose_list_jql`, `enrich_rows`, `render_list` per the tech-debt report's proposed seams); zero signature change; zero change to already-extracted siblings (`build_jql_base_parts`, `resolve_component_clauses`, `validate_component_preflight`, `resolve_one_component_id`, `resolve_show_points`, `build_filter_clauses` are already separate functions and are OUT of scope — they're the good precedent this decomposition should follow) | HIGH — second-largest handler; JQL composition, full filter matrix (`--component`/`--updated-recent`/`--sort`/`--fields`/date clauses), team/points/component enrichment, table-vs-JSON rendering all in one body; nested `.map().map()` enrichment closures the report flags as complexity hotspots |

### Dependent Files (unchanged but depend on modified files)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `src/cli/issue/mod.rs` | calls `handle_edit`/`handle_list` via dispatch | LOW — call site is a single `?`-propagated async call per command; as long as the public/`pub(super)` signature of `handle_edit`/`handle_list` is preserved exactly, the dispatch site needs zero changes |
| `src/cli/mod.rs` | clap derive definitions for `issue edit`/`issue list` flags | NONE — no flag/CLI-surface change is in scope for this cycle; if extraction reveals a genuine need for a new private helper's own flag validation, that would be scope creep and should be flagged, not silently done |
| Every BC-3.4.*/BC-2.1.* test file (dedicated + shared, enumerated in Impact Assessment) | Exercises `handle_edit`/`handle_list`'s external behavior end-to-end via the CLI binary or `assert_cmd` | This IS the regression safety net for the refactor — see Regression Baseline. Not "dependent" in the usual code sense, but the artifacts whose continued green status is the actual acceptance criterion for the whole cycle. |

## Files NOT Changed (Regression Baseline)

- Every other `src/cli/issue/*.rs` file (`create.rs`, `jsm_create.rs`,
  `workflow.rs`, `interactions.rs`, `links.rs`, `helpers.rs`, `assets.rs`,
  `changelog.rs`, `field_resolve.rs`, `attachments.rs`, `mentions.rs`,
  `json_output.rs`, `format.rs`, `view.rs`, `comments.rs`) — no dependency on
  the internal structure of `handle_edit`/`handle_list`; several of these
  (`field_resolve.rs`, `helpers.rs`) are *called by* the two target functions
  but are themselves untouched (the extraction moves code *inside*
  `edit.rs`/`list.rs`, it does not change what those files call out to).
- `src/cli/issue/edit.rs`'s already-separate sibling functions
  (`edit_issue_components` L1359, `resolve_component_change_names` L1564,
  `build_labels_edited_fields` L1665, `handle_edit_bulk_labels` L1721,
  `project_key_from_issue_key` L1818, `handle_edit_bulk_components` L1885,
  `resolve_bulk_component_ids` L1995, `run_bulk_component_action` L2128,
  `render_bulk_component_results` L2156, `handle_edit_bulk_fields` L2271,
  `render_bulk_edit_results` L2363, `is_subtask_parent_error` L2459,
  `is_cross_hierarchy_type_error` L2500) — these are already decomposed and
  are explicitly out of scope; TD-01's remediation only targets the
  `handle_edit` body itself, L45–1358.
- `src/cli/issue/list.rs`'s already-separate sibling functions
  (`extract_unique_status_names`, `parse_sort`, `compose_order_by_with_sort`,
  `build_jql_base_parts`, `resolve_component_clauses`,
  `validate_component_preflight`, `resolve_one_component_id`,
  `resolve_show_points`, `build_filter_clauses`) — same rationale, out of
  scope; TD-02 targets only `handle_list`'s body, L152–926.
- `src/api/**` — no API call shapes change; the refactor is purely a
  control-flow reorganization of existing orchestration logic, not a wire
  protocol change.
- `src/adf.rs`, `src/jql.rs`, `src/duration.rs`, `src/partial_match.rs` — pure
  core modules called by both target functions; untouched.
- `src/cache.rs`, `src/config.rs`, `src/output.rs`, `src/error.rs` — untouched
  infrastructure.
- All other command families (`board.rs`, `sprint.rs`, `worklog.rs`,
  `team.rs`, `user.rs`, `project.rs`, `component.rs`, `queue.rs`,
  `requesttype.rs`, `field.rs`, `assets/`, `auth/`) — zero coupling to
  `handle_edit`/`handle_list`.

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | **HIGH** | `handle_edit`/`handle_list` are the two most complex, highest-traffic write/read command handlers in the CLI (per the tech-debt report's independent clippy `too_many_lines` corroboration). A 1,314-LOC function has many implicit data-flow dependencies between "sequential" steps (e.g., a variable computed at line 200 consumed at line 1100) that are easy to break silently when hoisted into separate functions — especially around borrow/ownership boundaries, early-return short-circuits (`?`), and shared mutable state built up incrementally (e.g., a `changed_fields` accumulator in `edit.rs`, filter-clause `Vec<String>` composition in `list.rs`). Elevated to HIGH (not MEDIUM) specifically because: (a) no `list.rs` table-render snapshot test exists — a subtle formatting/ordering regression could pass every existing assertion if those assertions only check substrings rather than exact output; (b) `edit.rs` is documented as carrying 23 `.clone()` calls and heavy branching (single/bulk × field/label/type/component × dry-run) — the state threaded through those branches is exactly what's hardest to safely re-thread across function boundaries; (c) this is the CLI's most-used command pair (`issue edit`, `issue list`) — a regression here has the widest blast radius of any handler in the codebase. |
| Architecture | LOW | No interface, purity-boundary, or subsystem change. Both functions remain effectful-shell CLI handlers before and after; extraction only changes where code physically lives within the same crate boundary. |
| Security | LOW | No new input-handling logic, no new external dependency, no change to auth/credential paths. Pure internal reorganization of already-reviewed control flow. |
| Performance | LOW | Extracting inline code into named functions has no expected runtime cost difference (compiler inlines aggressively in release builds; even without inlining, one extra async call frame per extracted step is negligible relative to network I/O, which dominates both handlers' wall-clock time). |

## Regression Baseline

- **Total existing tests (repo-wide):** ~1,850 `fn test_*`-named functions
  across `tests/*.rs` (126 integration-test files) — not counting non-`test_`-
  prefixed test fns like `issue_list_errors.rs`'s, nor `src/`-inline unit
  tests, nor proptests, nor the 118 holdout scenarios or existing snapshot
  files; a true repo-wide total was not exhaustively computed for this
  report (matches cycle-009's F1 precedent of not exhaustively counting).
- **Tests in the edit.rs risk zone:** ~133 dedicated-file test fns
  (`tests/issue_edit.rs` 12, `issue_edit_echo.rs` 16, `issue_edit_field.rs` 65,
  `issue_edit_field_adf.rs` 13, `issue_edit_labels.rs` 8,
  `issue_edit_no_parent.rs` 9, `issue_edit_type_errors.rs` 10) + ~71
  edit-named test fns inside `tests/issue_commands.rs` (substring match on fn
  name, approximate) + 14 inline unit tests in `edit.rs` itself + 1 insta JSON
  snapshot (edit echo path, lives in `json_output.rs`) + an unknown portion of
  `tests/cli_smoke.rs`'s 17 combined edit/list-related tests.
- **Tests in the list.rs risk zone:** ~15 dedicated-file test fns
  (`tests/issue_list_assets.rs` 2, `issue_list_errors.rs` 11,
  `issue_list_oauth_scope.rs` 2) + ~74 list-named test fns inside
  `tests/issue_commands.rs` (substring match, approximate) + 13 inline unit
  tests in `list.rs` itself + an unknown portion of `cli_smoke.rs`'s 17.
- **Coverage gap identified (elevates regression risk to HIGH, see above):**
  `list.rs`'s table-rendering output (the default, non-JSON display path) has
  **no insta snapshot test**. Only `edit.rs`'s JSON echo path has one, and it
  lives in `json_output.rs`, not `edit.rs`. Table output is covered only via
  string/substring assertions in integration tests, which will *not*
  reliably catch a column-ordering, spacing, or truncation-boundary
  regression introduced during extraction.
- **Recommendation — characterization tests BEFORE extraction (explicit
  recommendation, see Scope Recommendation):** For a 1,314-line function
  (`handle_edit`) and a 775-line function (`handle_list`), the existing suite
  — while large — is organized around *behavioral contracts* (BC-*), not
  around *internal code paths*. It is plausible for every BC-level assertion
  to keep passing while an internal refactor silently changes behavior on an
  input combination no BC test happens to exercise (e.g., an unusual flag
  combination, a specific error-ordering edge case, or exact table-column
  spacing). Recommend adding a **small number of high-value characterization
  tests FIRST**, specifically:
  1. A `list.rs` table-output insta snapshot (or golden-file test) covering
     at least one representative row set with points/team enrichment on, to
     close the identified gap.
  2. A handful of golden-output tests exercising `edit.rs`'s least-covered
     branch combinations (identify via a quick coverage pass — e.g.
     `cargo llvm-cov` or manual branch enumeration against the tech-debt
     report's seam list: single-key+`--dry-run`+type-error-enrichment
     combined, `--jql`-resolved bulk set + `--label` routing fork).
  This is NOT a full characterization-test rewrite of the whole surface
  (that would be disproportionate given ~370+ tests already exist) — it is a
  targeted top-up of the specific gaps this analysis found, run BEFORE the
  first extraction commit, so any of the ~370+ existing tests OR the new
  characterization tests failing during extraction is a real regression
  signal, not noise.

## Scope Recommendation

- **Mode:** Feature Mode, refactor route (not Full Pipeline — impact boundary
  is two well-understood, already-partially-decomposed command handlers; no
  architecture or story-graph change warranted).
- **Recommended phase sequence:**
  1. **F1 (this report)** — delta analysis, human gate. **Proposes**: split
     into TWO independent extraction waves (edit.rs, list.rs), sequenced
     edit.rs first (higher LOC, higher risk, more valuable to de-risk early)
     then list.rs, each its own sub-cycle of the F4 loop; OR run both in one
     F4 pass with per-file commits — human to decide (see Open Questions).
  2. **F2 (spec evolution) — PROPOSED NULL.** Confirmed no BC/VP changes are
     needed or wanted; this phase should be explicitly marked
     `NOT-APPLICABLE` / skipped rather than run-and-produce-nothing, to keep
     the cycle manifest honest. If the architect flags a
     `module-decomposition.md` file-layout note as warranted (see Open
     Questions on submodule directories), that is a MINIMAL, non-BC-bearing
     architecture-doc touch-up that can ride inside F1's close or a light F4
     pre-step — not a reason to run full F2.
  3. **F3 (incremental stories) — PROPOSED SKIPPED.** No new BCs means no
     natural story boundary in the usual VSDD sense (a story traces to a BC).
     Recommend instead: track each extraction step as a micro-commit inside
     a single F4 delta-implementation pass (or two, if split into edit/list
     sub-cycles), documented in `burst-log.md`/`cycle-manifest.md`, mirroring
     cycle-009's precedent of skipping F3 for a scope with 0 new BCs. This is
     explicitly flagged as an open question below, since the "one function"
     framing invites a "one story per extracted function" alternative the
     human may prefer for finer-grained review checkpoints.
  4. **F4 (delta implementation)** — the substantive work. Recommend, per
     function, a fixed incremental protocol: (a) add the characterization
     tests identified above and confirm they pass against the CURRENT
     (unrefactored) code first; (b) extract ONE cohesive sub-function at a
     time, in the order suggested below; (c) run the FULL existing suite
     (`cargo test`) after every single extraction, not just at the end; (d)
     `cargo clippy -- -D warnings` and `cargo fmt --all -- --check` clean at
     every commit; (e) never squash the incremental commits into one giant
     diff — the incremental history IS the safety evidence for reviewers.
  5. **F5 (scoped adversarial)** — fresh-context review scoped to the diff
     only (the two refactored files + any new characterization tests), NOT a
     full-tree pass. Adversary should specifically probe: did any extracted
     sub-function silently change error-message text, exit codes, JSON key
     ordering, or table column formatting? Did any early-return (`?`)
     short-circuit get reordered relative to a side effect (e.g., a
     dry-run/`--jql` combination now validates in a different order than
     before, changing which error surfaces first on invalid multi-flag
     input)?
  6. **F6 (targeted hardening)** — recommend: `cargo mutants --in-diff`
     against the cycle's diff scope (per the repo's standard PR-diff mutation
     policy) — this is a genuinely valuable signal here, since the point of
     the refactor is that mutation-testable, independently-testable
     sub-functions should show BETTER (not worse) mutation-kill isolation
     than the monolith did. No new formal-proof/fuzz escalation needed — this
     is CLI orchestration logic, not a new pure/total function class; if
     extraction happens to produce a genuinely pure sub-function (e.g. a JQL
     clause composer with no I/O), flag it as a *candidate* for a future
     VP-NNN, don't require one in this cycle.
  7. **F7 (delta convergence)** — 5-dimension check on the delta (zero BC/VP
     drift confirmed, full regression suite green including the new
     characterization tests, mutation score on diff acceptable, docs — this
     CLAUDE.md's function-span citations in the tech-debt report are now
     historical, no CLAUDE.md change is strictly required since function
     internals aren't cited there today, but the Known Size Deviations file
     totals should be re-measured if LOC shifts meaningfully) plus full
     regression suite on develop. Final human gate before release
     (PATCH-level or no-tag-this-cycle, per the versioning question below).
- **Estimated new stories:** 0 (refactor route; if F3 is run after all per the
  human's F1-gate decision, estimate ~6-10 micro-stories — one per extracted
  sub-function per the seam list below — but the default recommendation is 0,
  tracked via commits instead).
- **Estimated effort:** Medium (multi-day, not ≤1 day like cycle-009's
  bug-fix). `edit.rs` (TD-01, effort "L" in the source report) is
  substantially larger/riskier than `list.rs` (TD-02, effort "M").
- **Can parallelize:** The two files (`edit.rs`, `list.rs`) have no code
  dependency on each other and could in principle be extracted in parallel by
  two independent workstreams/agents. NOT recommended to actually run them
  concurrently in one F4 burst, though — both are HIGH-regression-risk,
  high-traffic surfaces, and serializing them (edit.rs fully green, merged,
  THEN list.rs) keeps the regression-attribution story clean (a test failure
  during list.rs's extraction can't be confused with an edit.rs regression
  landing at the same time).

## Concrete Decomposition Seams (from the tech-debt report, cross-checked against source)

### `edit.rs::handle_edit` (L45–1358) — target: dispatch ≤ ~80 LOC + named peers

Proposed extraction targets (mirrors TD-01's remediation, aligned to
already-existing sibling patterns like `edit_issue_components` at L1359):
- `resolve_edit_targets(...)` — the `--jql`/positional key-set builder
  (single-key vs. multi-key resolution).
- The `--field` + `--label` mutual-exclusion gate — a small, easily-isolated
  pure validation step.
- `edit_single_field(...)` / single-key field/type/priority/etc. write path.
- `edit_bulk_fields(...)` — thin wrapper delegating to the ALREADY-SEPARATE
  `handle_edit_bulk_fields` (L2271) where possible; the goal is for
  `handle_edit`'s body to *call* the existing bulk siblings rather than
  duplicate their logic inline.
- `edit_labels(...)` — thin wrapper toward the ALREADY-SEPARATE
  `handle_edit_bulk_labels` (L1721) for the bulk case; isolate the
  single-key label path that currently lives inline in `handle_edit`.
- `edit_type(...)` — the type-change path, including the
  `is_subtask_parent_error`/`is_cross_hierarchy_type_error` enrichment calls
  (both already separate helper fns at L2459/L2500 — `handle_edit` should be
  *calling* them, not inlining their logic).
- `edit_components(...)` — thin wrapper toward `edit_issue_components`
  (L1359, already separate) for the actual mutation; isolate any inline
  pre-dispatch logic that currently sits in `handle_edit` itself.
- `render_dry_run(...)` — the `--dry-run` preview-rendering path, isolated
  from the live-mutation path.
- `handle_edit` itself becomes pure dispatch: parse args → resolve targets →
  branch to exactly one of the above → render result.

### `list.rs::handle_list` (L152–926) — target: dispatch + 3 named peers

Proposed extraction targets (per TD-02's remediation, using functions/names
already partially validated by the file's existing sibling pattern):
- `compose_list_jql(...)` — JQL composition, delegating to the ALREADY-SEPARATE
  `build_jql_base_parts` (L138) and `build_filter_clauses` (L1192) for the
  parts they already own; isolates whatever inline composition glue
  currently lives directly in `handle_list`'s body (including the
  date-clause block the report cites at ~L282–288).
- `enrich_rows(...)` — team/points/component enrichment, replacing the
  nested `.map(...).map(...)` closures the report flags (originally around
  L332 and L813–843) with a named, independently-testable function.
- `render_list(...)` — table-vs-JSON rendering dispatch, isolating the
  field-projection block the report cites at ~L616.
- `handle_list` itself becomes: parse args/flags → `compose_list_jql` →
  fetch → `enrich_rows` → `render_list`.

Both proposed structures deliberately delegate to the pre-existing separate
sibling functions in each file rather than re-implementing their logic —
consistent with `field_resolve.rs`'s documented `dispatch_field_value`
sharing pattern (ADR-0012), which the tech-debt report calls out as "the
right pattern — good precedent for TD-06" and is equally the right precedent
here.

## Open Questions

1. **Add characterization tests first — recommended YES.** Confirm: should
   the F1 gate approve adding the `list.rs` table-snapshot gap-closer and a
   handful of `edit.rs` golden-output tests as a mandatory first F4 step
   before any extraction commit, per the Regression Baseline recommendation
   above? (Default recommendation: yes, scoped narrowly — not a full
   characterization rewrite.)
2. **One cycle for both functions, or split into two cycles/sub-cycles?**
   This report recommends ONE cycle (cycle-010) covering both, but
   sequenced serially (edit.rs fully done and green before list.rs starts),
   each tracked as its own extraction wave in the burst log — not run in
   parallel, not split into cycle-010/cycle-011. Confirm this sequencing is
   acceptable, or whether the human prefers two fully separate cycles
   (allowing an independent close/release checkpoint between them).
3. **Is introducing `edit/` and `list/` submodule directories acceptable,**
   or should the decomposition stay as private functions within the
   existing single `edit.rs`/`list.rs` files? Tradeoffs: a submodule split
   (`edit/mod.rs` + `edit/dry_run.rs` + `edit/bulk.rs` etc.) more visibly
   demonstrates the decomposition and may ease future navigation, but (a)
   touches more file paths, complicating the "same file, same diff" review
   story, (b) may collide with the `CLAUDE.md` Known Size Deviations
   bookkeeping (the file's LOC citation would need updating either way,
   but a submodule split changes *which files* those citations point at),
   and (c) the tech-debt report's own remediation language ("hoisting the
   inline branches into peers") reads as same-file private functions, not a
   submodule split. Recommend defaulting to **same-file private functions**
   unless the human prefers the submodule structure.
4. **F3 (stories) — skip (recommended) or run one story per extracted
   function/wave?** Default recommendation is skip, tracked via commits +
   burst-log per cycle-009's precedent. If the human wants finer-grained,
   independently-reviewable checkpoints (e.g., a separate PR per extracted
   sub-function rather than one PR per file), running F3 with ~6-10
   micro-stories (one per seam in the Decomposition Seams section) is the
   alternative — this would also produce more, smaller PRs, which may be
   preferable for a HIGH-regression-risk change specifically because each PR
   is easier to review and bisect if something goes wrong.
5. **Versioning/release treatment at cycle close?** Following cycle-009's
   precedent (`D-373`), recommend this rolls into the next dev prerelease
   with no immediate tag, since it is a pure internal refactor with no
   user-visible change to announce. Confirm at the F1 gate.
6. **`module-decomposition.md` touch-up — required or optional?** If the
   human approves same-file private functions (Question 3, recommended
   default), there is likely NOTHING for the architect to update in
   `architecture/` at all (no new file, no new module boundary). If a
   submodule split is chosen instead, recommend a minimal architect
   sign-off/file-layout note rather than a full F2 pass. Confirm this
   lightweight treatment is acceptable, or whether the human wants a
   dedicated (even if trivial) F2 acknowledgment regardless.
7. **Exact BC↔handler-vs-open-command mapping for BC-3.4.\*** — flagged in
   Impact Assessment: the "3.4 Edit **and Open**" section may include BCs
   that actually trace to `workflow.rs::handle_open`/`handle_move`, not
   `edit.rs::handle_edit`. This should be resolved (a fast grep/trace pass,
   not full BC re-authoring) before or during F4 so the "37 BCs to preserve"
   figure used for F4/F7 acceptance checks is accurate, not an
   over-inclusive upper bound.
