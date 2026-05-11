---
document_type: consistency-review
feature: issue-110-pr2
phase: F7-delta-convergence
verdict: PASS-WITH-FOLLOWUPS
date: 2026-05-10
followup_issues: ["#347"]
commit_range: "7704955..1ab056e"
---

# F7 Delta Convergence Review — issue-110-pr2

**Date:** 2026-05-10
**Phase:** F7 Delta Convergence
**Verdict:** PASS-WITH-FOLLOWUPS (5/5 axes PASS-WITH-OBS, 1 follow-up filed)

---

## Axis 1: Test Naming Convention

**Verdict:** PASS-WITH-OBS

All new tests in `tests/issue_bulk_pr2.rs` use the CLAUDE.md convention:
`test_<verb>_<subject>_<expected_outcome>`.

**Observation:** One test uses a legacy no-prefix naming style inconsistent with the
convention documented in `docs/specs/test-naming-convention.md`. The test is not
load-bearing for CI (it passes), but it breaks convention consistency and will confuse future
contributors.

**Action:** Filed as #347 (yes-flag test rename) — non-blocking, deferred.

---

## Axis 2: Output Channel Discipline

**Verdict:** PASS

| Path | stdout | stderr | Notes |
|------|--------|--------|-------|
| Dry-run table | Table output | Hints (if any) | Correct — data on stdout |
| Dry-run JSON | `{"dryRun":true,...}` | None | Correct — pure JSON on stdout |
| Bulk edit success | Per-issue results | None | Correct |
| Bulk edit error | None | Error message | Correct — errors on stderr |
| `--max` cap exceeded | None | Error message (exit 64) | Correct |
| Empty `--jql` | None | Error message (exit 64) | Correct |

No stdout pollution with diagnostic text in any path. JSON mode produces parseable JSON
exclusively on stdout. Consistent with output channel profiles in CLAUDE.md.

---

## Axis 3: Error Handling Convention

**Verdict:** PASS

All user-input error conditions use `JrError::UserError` (exit 64):
- Empty `--jql` → JrError::UserError
- `--jql` returns 0 matches → JrError::UserError
- `--max` cap exceeded → JrError::UserError
- `--dry-run` with no field changes → JrError::UserError
- `--max 0` (invalid) → rejected at clap parse time (clap validator)
- `--max` > 1000 → rejected at clap parse time (clap validator)
- Unsupported flags with multi-key (`--no-parent` etc.) → JrError::UserError
- `--label` combined with `--summary`/`--priority`/`--type` → JrError::UserError

API errors use `JrError::ApiError`. Bulk task FAILED/CANCELLED/DEAD uses `JrError::ApiError`
with `failureReason` in message. Exit codes are consistent with CLAUDE.md conventions.

---

## Axis 4: BC Traceability

**Verdict:** PASS

All acceptance criteria from the feature spec trace to:
1. A named test in `tests/issue_bulk_pr2.rs`
2. A passing test result in the CI run
3. A demo in `docs/demo-evidence/issue-110-pr2/`

| AC | Test | Demo |
|----|------|------|
| --jql selection | test_jql_search_and_bulk_edit | D-005 |
| --dry-run preview (table) | test_dry_run_table_output | D-002 |
| --dry-run preview (JSON) | test_dry_run_json_output | D-003 |
| --dry-run requires fields | test_dry_run_requires_field_changes | — |
| --max safety cap (default 50) | test_max_cap_default_50 | — |
| --max overrun error | test_max_cap_overrun_returns_err | — |
| --max ceiling 1000 | test_max_ceiling_1000 | — |
| --yes skips confirm | test_yes_flag_skips_confirm | — |
| confirm threshold at 5 | test_confirm_threshold_triggers_at_5 | — |
| multi-field: --summary | test_summary_routes_bulk_for_multi_key | — |
| multi-field: --priority | test_priority_routes_bulk_for_multi_key | — |
| multi-field: --type | test_type_routes_bulk_for_multi_key | — |

---

## Axis 5: CLAUDE.md Alignment

**Verdict:** PASS

- `--dry-run` NFR note updated at 1ab056e to reflect actual implementation behavior
- `clap requires / conflicts_with` interaction gotcha absent from CLAUDE.md (but codified in
  lessons.md as a process lesson rather than a per-feature gotcha — correct routing)
- No new gotchas introduced that should be in CLAUDE.md but are not

---

## Follow-Up Issues

| Issue | Description | Blocking? |
|-------|-------------|-----------|
| #347 | Yes-flag test rename to match naming convention | No |

---

## Verdict

**F7 PASS-WITH-FOLLOWUPS.** All 5 axes pass. One minor observation on test naming convention
(#347) filed as a non-blocking follow-up. PR #348 cleared for merge subject to human approval.
