---
document_type: delta-analysis-report
feature_name: "jql-relative-date-units — reject unsupported JQL relative date units (M, y)"
created: 2026-09-22
spec_version_at_analysis: "BC-INDEX.md total_bcs=770 (cumulative, as of 8b4c797a / v0.7.0-dev.8)"
status: draft
intent: "bug-fix"
feature_type: "backend"
scope: "standard"
severity: "MEDIUM"
---

# Delta Analysis Report: jql-relative-date-units

## Feature Request

- **Brief:** Adopt external PR #863 ("fix: reject unsupported JQL relative date units"),
  which fixes GitHub issue #859.
- **Requested by:** External contributor (PR #863), issue reporter (#859). Routed
  through the human for cycle adoption.
- **Date:** 2026-09-22
- **Working cycle id:** cycle-009 (slug `jql-relative-date-units`; number to be
  confirmed by the human at the F1 gate — the cycle sequence currently jumps
  cycle-008 → cycle-012 in `.factory/cycles/`, so `cycle-009` is provisionally
  free but unconfirmed).

## Root Cause (confirmed, this session)

`src/jql.rs::validate_duration` (used by `jr issue list --recent`/`--updated-recent`)
accepts unit set `{y, M, w, d, h, m}`, matched case-insensitively against a
single trailing char via `matches!`. Jira JQL raw relative-date offsets
(`created >= -{d}` / `updated >= -{d}`, emitted at `src/cli/issue/list.rs`
`build_filter_clauses`, lines ~1210/1215) support only `{w, d, h, m}`. Consequences
confirmed by Perplexity research against first-party Atlassian sources this
session:
- `2M` is silently reinterpreted by Jira as **2 minutes**, not 2 months (unit
  matching is case-insensitive server-side too — `M` and `m` collide).
- `1y` is **rejected by Jira with HTTP 400** ("invalid date value",
  JRACLOUD-82707) — NOT a silent empty result set as issue #859 claims. This
  refutes part of the issue's narrative; the fix's rationale for rejecting `y`
  should read "Jira rejects `-1y` as invalid (400)", not "returns an empty
  result set". `M`/`y` remain valid ONLY inside JQL functions like
  `startOfMonth()`/`startOfYear()`, which `validate_duration` does not govern
  (out of scope for both the raw-offset flags and this fix).

Root-cause BC (the contract that should hold but doesn't): **the CLI must not
accept a duration unit Jira will silently mis-parse or reject** — currently
violated for `M` (silent mis-parse) and `y` (400 the user has no pre-flight
warning for).

## Classifications

### Intent Classification

**Classified intent:** `bug-fix`
**Rationale:** Human-supplied framing ("fixes GitHub issue #859", "the bug (root
cause, confirmed)") and the nature of the change — existing validated behavior
produces silently-wrong results, not a missing capability. Routes to the bug-fix
path (this analysis), skipping the full new-feature F2/F3 spec-and-story creation
in favor of amend-in-place spec evolution (see Scope Recommendation).

### Feature Type Classification

**Classified type:** `backend`
**Rationale:** Confined to CLI input validation logic (`src/jql.rs`) and its two
call sites in the read-path JQL composer (`src/cli/issue/list.rs`). No UI/rendering
surface, no new external dependency, no infrastructure/CI change.

### Trivial Scope Classification

- [x] Impact boundary: touches 2 source files (`src/jql.rs`, `src/cli/issue/list.rs`
  help text via `src/cli/mod.rs`) plus 1 test file in the adopted diff — narrow, but
      **not** single-file when spec fallout is counted.
- [ ] No new BCs needed — **FALSE**. The current PRD text pins the *old* error
  string verbatim as normative prose in two places (BC-2.1.008 Behavior clause,
  `bc-2-issue-read.md` line ~293; BC-2.1.023 EC-2.1.023-1, lines ~872-874). Both
  MUST be amended in place to match the new `w, d, h, or m` wording before the
  code diff can land without breaking spec-code traceability. A new edge case
  documenting the M/y-rejection behavior explicitly is also warranted (see below).
- [x] No architecture change
- [x] No new external dependencies
- [ ] Regression risk: LOW — assessed **LOW-MEDIUM** (see Risk Assessment; not a
  clean LOW because `list.rs` is a high-traffic, oversized file per
  CLAUDE.md's Known Size Deviations, and the change is a breaking behavior
  change for previously-accepted inputs).

**Classified scope:** `standard`
**Rationale:** Fails 2 of the 5 trivial criteria (BC-prose amendment required;
regression risk not clean LOW). This is spec-touching, not documentation-only —
quick-dev routing is **not** applicable. Requires F2 (spec evolution) before F4
(implementation), consistent with `feedback_vsdd_process.md`: no fix, however
small, skips the pipeline or gets hand-edited directly.

### Severity Classification (bug-fix intent only)

**Classified severity:** `MEDIUM`
**Rationale:**
- Not CRITICAL/HIGH: no data loss, no security exposure, no crash; a workaround
  exists today (`--created-after`/`--created-before`/`--updated-after`/
  `--updated-before` with explicit dates cover the same filtering need for
  month/year windows).
- Not LOW: the `2M` failure mode is **silent** — exit 0, plausible-looking but
  wrong result set (30x magnitude error, minutes vs. months), which is worse
  than a loud failure and matches the MEDIUM bar ("functionality impaired,
  workaround exists") rather than LOW ("cosmetic/edge case"). The `1y` case is
  already loud today (Jira 400) but with a confusing, non-actionable message
  from the API rather than `jr`'s own pre-flight guidance — still MEDIUM, not
  LOW, because a user gets no hint of the reason.
- Confirms the human's MEDIUM assessment in the brief.

> Not CRITICAL — full F1-F7 delta rigor applies, not the expedited flow.

## Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements | 0 new, 2 modified, 1 new EC recommended | **Modified:** BC-2.1.008 (`bc-2-issue-read.md` ~line 293, Behavior clause pins old error string), BC-2.1.023 (~lines 872-874, EC-2.1.023-1 pins old error string). **New EC recommended:** an explicit M/y-rejection edge case (e.g. EC-2.1.008-N or EC-2.1.023-N) documenting `--recent 2M`/`--recent 1y` → exit 64 pre-HTTP, replacing any implicit "M/y are accepted" prose, and correcting the rationale to "Jira rejects `-1y`\" as invalid (JRACLOUD-82707), not \"returns empty\"" per this session's Perplexity finding. |
| Architecture | 0 components added, 0 modified | No architecture doc changes — `validate_duration` is a pure function inside an existing module; no new module, no purity-boundary change. |
| UX Screens | N/A | CLI-only; help text changes are covered under Files Changed, not a UX artifact. |
| Stories | 0 new stories | Bug-fix route skips F3 story decomposition; delivered as a scoped fix PR (F4) against the amended BCs. |
| Existing Tests | ~23 tests in risk zone | `src/jql.rs` inline `mod tests`: 2 unit tests must flip (`validate_duration_valid_months_uppercase`→`validate_duration_rejects_months`, `validate_duration_valid_years`→`validate_duration_rejects_years`) + 1 proptest-adjacent assertion in the multibyte-unit test updates its expected substring (`"y, M, w, d, h, or m"` → `"w, d, h, or m"`); `tests/issue_commands.rs`: 1 direct assertion update (`test_bc_2_1_023_issue_list_updated_recent_rejects_combined_units_pre_http`) plus ~18 other `test_bc_2_1_023_*`/`test_bc_2_1_007_*` tests that exercise `--updated-recent` through the same `validate_duration` call site (none currently assert on `M`/`y` acceptance, so they are risk-zone-adjacent, not expected to break) + `test_issue_list_created_after_and_recent_conflict` (`tests/cli_smoke.rs`) which uses `--recent` but not the `M`/`y` boundary. CR-004 (code review) identified a real gap: **zero** existing test proves the end-to-end repro (`jr issue list --recent 2M`/`1y` → exit 64, zero HTTP) — only unit-level `validate_duration` assertions and one combined-units integration test exist. |
| Verification Properties | 0 new VP strictly required | No VP-NNN currently cited for `validate_duration`; none of the referencing comments (`create.rs` FIX-F6-LRE-1 citations) assert unit-set behavior, only the multibyte byte-index panic guard, which is unaffected by this change. |

## Files Changed

### New Files

None.

### Modified Files

| File Path | Change Type | Risk |
|-----------|------------|------|
| `src/jql.rs` | Internal logic — `validate_duration`'s `matches!` unit set narrows from `y\|M\|w\|d\|h\|m` to `w\|d\|h\|m`; 4 `format!` error-string literals updated in lockstep; doc comment above the function updated; 2 inline unit tests flipped from accept→reject; 1 inline property/table-driven test's expected-substring assertion updated | MEDIUM — pure function, single call-site family, but is a **breaking behavior change**: previously-accepted `--recent 2M`/`1y` now exit 64 instead of proceeding (silently-wrong or Jira-400, respectively) |
| `src/cli/mod.rs` | Interface text only — `--recent`/`--updated-recent` clap `#[arg]` doc-comment help strings change example unit from `2M` to `12h` (×2 occurrences, lines ~357/360) | LOW — no behavioral change, string-literal only |
| `tests/issue_commands.rs` | Test assertion update — `test_bc_2_1_023_issue_list_updated_recent_rejects_combined_units_pre_http`'s expected stderr substring updated to match the new error string | LOW — test-only |
| `.factory/specs/prd/bc-2-issue-read.md` | **Not touched by PR #863; required in F2** — BC-2.1.008 Behavior clause (~line 293) and BC-2.1.023 EC-2.1.023-1 (~lines 872-874) pin the OLD error string verbatim and must be amended to the new `w, d, h, or m` / `7d, 4w, 12h` wording; a new edge case for M/y rejection should be added with the corrected (Jira-400, not "empty result") rationale for `y` | HIGH for spec-code drift if skipped — this is the reason `scope: standard` rather than `trivial` |
| `CHANGELOG.md` | **Not touched by PR #863; required in F4** — `[Unreleased]` section is currently empty; needs an entry documenting the breaking change (previously-accepted `2M`/`1y` now rejected) per CR-003 | MEDIUM if skipped — user-facing breaking change with no changelog trail |

### Dependent Files (unchanged but depend on modified files)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `src/cli/issue/list.rs` (`build_filter_clauses`, ~lines 1209-1215; `validate_duration` call sites, ~lines 235, 256) | `src/jql.rs::validate_duration` | LOW — call sites are unconditional `?`-propagation of the validator's `Result`; no logic in `list.rs` inspects the specific unit accepted/rejected, so narrowing the unit set changes only which inputs reach `build_filter_clauses`, not how it composes clauses. Confirmed via grep: these are the ONLY two call sites of `validate_duration` in the entire codebase (`src/cli/issue/create.rs` only cites it in doc-comments about an unrelated multibyte-panic fix, never calls it). |

## Files NOT Changed (Regression Baseline)

These files must not be modified during implementation. All their tests must
continue to pass after implementation.

- `src/duration.rs` — the *separate* worklog-duration parser (`2h`, `1h30m`, `1d`,
  `1w`); explicitly a different validator/grammar from `jql::validate_duration`
  per `list.rs`'s own comment ("validator --recent uses (jql::validate_duration,
  NOT duration.rs)"). No overlap, no risk.
- `src/jql.rs::validate_date`, `validate_asset_key`, `escape_value`, and the
  asset-clause builder — untouched functions in the same file; the diff is
  scoped to `validate_duration` only.
- `src/cli/issue/create.rs` — cites `jql::validate_duration` only in rustdoc
  comments describing an unrelated multibyte byte-index panic fix (FIX-F6-LRE-1,
  issue #734); never calls the function. No behavioral coupling.
- All other `--recent`/`--updated-recent` composition logic in `list.rs`
  (assignee/reporter/status/team/open/component/asset/jql clause composition,
  board/sprint scope fallthrough) — unaffected; only the *acceptance* of the
  duration string changes, not its downstream clause-building or interaction
  with other filters.
- `src/api/jira/issues.rs` and all HTTP-call code — the fix is entirely
  pre-HTTP (`validate_duration` runs before any network call per BC-2.1.008/
  BC-2.1.023's existing pre-HTTP-validation discipline); no wire-format change.

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | LOW-MEDIUM | The code change itself is narrowly scoped (one `matches!` arm set, in-lockstep string literals, two call sites, confirmed via grep to be the only call sites). Risk is elevated above a clean LOW only because (a) `list.rs` is a documented oversized/high-traffic file (CLAUDE.md Known Size Deviations, ~2,012 LOC) where the two call sites live, and (b) the change is a **breaking** behavior change for previously-accepted inputs (`2M`, `1y`) — any external script/CI/automation currently passing those values will start failing with exit 64 instead of proceeding, which is the intended fix but is a real behavioral break, not additive. No HIGH-risk signal found (no core-module rewrite, no security boundary, no persistence/schema change). |
| Architecture | LOW | No new module, no interface change, no purity-boundary shift — `validate_duration` remains a pure, side-effect-free string validator called before any I/O, exactly as before. |
| Security | LOW | Input-validation tightening (rejecting a wider set of previously-valid strings) reduces, not increases, attack/misuse surface. No injection vector — `validate_duration`'s output only ever appears inside a JQL numeric-duration position (`created >= -{d}`), and the existing multibyte-panic guard (FIX-F6-LRE-1) and combined-unit rejection are both preserved unchanged in this diff. |
| Performance | LOW | No algorithmic or I/O change; single-character `matches!` comparison, same cost class as before. |

## Regression Baseline

- **Total existing tests (repo-wide):** not exhaustively counted in this
  analysis; `tests/issue_commands.rs` alone contains ~204 test functions,
  `src/jql.rs` contains 89 `#[test]`/proptest-marked items in its inline `mod
  tests`.
- **Tests in risk zone:** ~23 (11 in `src/jql.rs` directly exercising
  `validate_duration` incl. the 2 that must flip + 1 assertion-text update; ~18
  `--updated-recent`-composition tests in `tests/issue_commands.rs` that route
  through the same validator but don't assert on the `M`/`y` boundary, so they
  are exposure-adjacent rather than expected-to-break; 1 `--recent`-conflict
  smoke test in `tests/cli_smoke.rs`).
- **Risk zone test files:** `src/jql.rs` (inline `mod tests`), `tests/issue_commands.rs`
  (all `test_bc_2_1_023_*`, `test_bc_2_1_007_issue_list_updated_recent_clause_ordering_*`),
  `tests/cli_smoke.rs` (`test_issue_list_created_after_and_recent_conflict`).
- **Confirmed gap (CR-004, HIGH):** no test in the current suite exercises the
  actual repro path end-to-end — `jr issue list --recent 2M` / `jr issue list
  --recent 1y` asserting exit code 64 and zero HTTP calls issued. This must be
  added in F4 as new coverage, not merely inherited from PR #863's diff.

## Scope Recommendation

- **Mode:** Feature Mode, bug-fix route (not Full Pipeline — impact boundary is
  a single validator function + its two call sites + BC prose amendment; no
  architecture or story-graph change warranted).
- **Recommended phase sequence (confirmed as proposed):**
  1. **F1 (this report)** — delta analysis, human gate.
  2. **F2 (spec evolution)** — amend `bc-2-issue-read.md`: BC-2.1.008 Behavior
     clause and BC-2.1.023 EC-2.1.023-1 to the new `w, d, h, or m` / `7d, 4w,
     12h` error-string wording; add a new edge case documenting M/y rejection
     explicitly, with the corrected rationale for `y` ("Jira returns HTTP 400
     'invalid date value' — JRACLOUD-82707 — not a silent empty result",
     per this session's Perplexity-validated finding, which refutes issue
     #859's own framing on that point). Run `scripts/check-spec-counts.sh`
     after the edit (DRIFT-001 mitigation) since this may add a new EC.
  3. **F4 (delta implementation)** — adopt PR #863's diff as the base
     (`src/jql.rs`, `src/cli/mod.rs`, `tests/issue_commands.rs` changes),
     PLUS: (a) add the CR-004 end-to-end integration test proving
     `--recent 2M`/`1y` → exit 64 pre-HTTP with zero HTTP calls; (b) add a
     `CHANGELOG.md` `[Unreleased]` entry documenting the breaking change
     (CR-003); (c) consider folding in CR-005's nit (point M/y users at
     `--created-after`/`--created-before` in the error hint) if it doesn't
     expand scope meaningfully — otherwise defer as a follow-up. CR-002's
     historical `docs/superpowers/{plans,specs}/*common-filter-flags*`
     stragglers are non-living docs; note but do not block on them (confirmed:
     `docs/superpowers/plans/2026-03-25-common-filter-flags.md` and
     `docs/superpowers/specs/2026-03-24-common-filter-flags-design.md` both
     still show `2M`/`1y` as valid — optional cleanup, not gating).
  4. **F5 (scoped adversarial)** — fresh-context review scoped to the diff
     (`src/jql.rs`, `list.rs` call sites, amended BC prose, new integration
     test) — not a full-tree adversarial pass.
  5. **F6 (targeted hardening)** — light: the existing `validate_duration`
     proptest (`validate_duration_never_panics`) already covers the panic-safety
     property under arbitrary input; no new formal proof needed for a
     narrowed-`matches!`-arm-set change. Mutation testing via
     `cargo mutants --in-diff` on the PR diff scope is sufficient; skip
     full fuzz/formal-proof escalation.
  6. **F7 (delta convergence)** — 5-dimension check on the delta (spec/BC
     amendment lands with the code, CHANGELOG entry present, new integration
     test passes, mutation score on diff acceptable, docs stragglers noted)
     plus full regression suite on develop. Final human gate before release
     (PATCH-level version bump — this is a bug fix, breaking-change nature is
     communicated via CHANGELOG, not a MAJOR bump under this project's semver
     policy for CLI validation tightening).
- **Estimated new stories:** 0 (bug-fix route; delivered as one scoped fix PR
  per `fix-pr-delivery` conventions, not the full per-story pipeline).
  **Estimated effort:** small (≤1 day) — diff is 14+/15-, well-scoped; primary
  effort is the BC prose amendment (F2) and the new integration test (F4).
- **Can parallelize:** F2 (spec amendment) can proceed independently of
  drafting the F4 integration test, but F4's `src/jql.rs`/`list.rs` code
  changes must not land before F2's BC amendment is merged (spec-first
  discipline — code changing a BC-pinned error string ahead of the BC amendment
  would itself violate the traceability the amendment exists to fix).

## Open Questions

- Confirm the cycle number: `.factory/cycles/` currently has cycle-001..008
  then jumps to cycle-012/013 — should this land as `cycle-009` as requested,
  or does the gap (009-011) indicate those numbers are reserved/in-flight
  elsewhere and a different number should be used? Human to confirm at the F1
  gate.
- Should CR-005 (error-message hint pointing M/y users at
  `--created-after`/`--created-before`) be included in this cycle's F4 scope,
  or deferred as a separate low-priority follow-up? Recommendation: include if
  trivial to add alongside the CR-004 test (low marginal cost), otherwise defer.
- Confirm whether the CR-002 historical-docs stragglers
  (`docs/superpowers/plans/2026-03-25-common-filter-flags.md`,
  `docs/superpowers/specs/2026-03-24-common-filter-flags-design.md`) should be
  updated in this cycle or left as-is (non-living docs, no CI enforcement
  found referencing them).
- Confirm PATCH-level semver treatment for this breaking-but-corrective change
  is acceptable, or whether the breaking-change nature warrants a MINOR bump
  per this project's (undocumented in CLAUDE.md) versioning policy — flagging
  since CLAUDE.md doesn't state a semver policy for CLI-flag-input breaking
  changes explicitly.
