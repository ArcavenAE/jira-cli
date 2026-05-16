---
document_type: f1-delta-analysis
phase: phase-f1-delta-analysis
producer: state-manager
issue: 340
input-hash: 96b509fc6ba2b2a35e852b095e110df27e13a234d376011eaf7dcc5f01f49408
status: orchestrator-approved
timestamp: 2026-05-15
project: jira-cli
mode: BROWNFIELD
intent: enhancement
feature_type: backend
trivial_scope: false
regression_risk: low
inputs:
  - ".factory/phase-f1-delta-analysis/architect-input.md"
  - ".factory/phase-f1-delta-analysis/business-analyst-input.md"
---

# F1 Delta Analysis — Issue #340

## Issue Summary

Issue #340 ("chore(bulk): scale await_bulk_task timeout with bulk size or include task_id in timeout error") emerged from the F5 adversarial review of PR #348 / issue #110 part 2. It presents three options: (a) a size-scaling formula for the timeout, (b) a const-bump from 300s to a larger fixed value, and (c) including task_id in the timeout error message. Option (c) — task_id in the error message — is ALREADY satisfied by production code at `src/api/jira/bulk.rs:412` (message: `"[deadline:bulk-outer] Bulk task {task_id} did not complete within …"`) delivered via PR #360. What is missing is only the test pinning that contract as a behavioral guarantee. Options (a) and (b) are DEFERRED per orchestrator directive (see Deferred Follow-ups below).

## Approved Scope

TEST-PIN only. Pin the existing task_id-in-timeout-message behavior as a behavioral contract via one new BC (ID TBD by F2 product-owner) and one additive assertion in `tests/bulk_deadline_propagation.rs`. No production code changes. No options (a) or (b) in this cycle.

## Impact Assessment Table

| Artifact | Change |
|----------|--------|
| PRD | +1 new BC (ID TBD by F2 product-owner; under `bc-3-issue-write.md`) |
| Architecture | unchanged |
| UX | n/a (backend only) |
| Stories | +1 new story (created in F3) |
| Tests | `tests/bulk_deadline_propagation.rs` — additive assertion only |
| VPs | extend VP-deadline-bounded-bulk-poll (assert task_id literal in stderr on timeout) |

## Files Likely Changed

- `tests/bulk_deadline_propagation.rs` (MODIFIED — additive assertion: `stderr.contains(task_id)` on the B-1 test fixture task_id)
- `.factory/specs/prd/bc-3-issue-write.md` (MODIFIED — append new BC for task_id-in-timeout-message contract)
- `.factory/specs/prd/BC-INDEX.md` (MODIFIED — register new BC)
- `.factory/specs/prd/CANONICAL-COUNTS.md` (MODIFIED — bump BC count by 1)
- `.factory/stories/wave-4/STORY-NNN.md` (NEW — story for this feature; NNN = next available ID in F3)
- `.factory/stories/STORY-INDEX.md` (MODIFIED — register new story)

## Files NOT Changed (regression baseline)

- `src/api/jira/bulk.rs` — production code already correct from PR #360; `[deadline:bulk-outer] Bulk task {task_id} did not complete within…` at line 412 is the contract being pinned, not changed
- `src/cli/issue/create.rs` — no call-site signature change (options (a)/(b) deferred)
- `src/cli/issue/workflow.rs` — no call-site signature change (options (a)/(b) deferred)
- `tests/bulk_await_timeout_release_gate.rs` — unaffected (resolver signature unchanged)
- `tests/issue_bulk_pr2.rs` — no change; integration tests invoke binary via subprocess
- `src/error.rs` — `JrError::DeadlineExceeded { remaining_ms, message }` already correct; no variant taxonomy change
- `src/api/client.rs` — deadline propagation fully implemented by PR #360; no structural change
- `CLAUDE.md` — no new seam documentation needed (no new env-var or resolver parameter)
- All other test files

## Risk Assessment

- **Regression risk: LOW** — additive test-only change; no production code touched; no resolver signature change; existing deadline tests (`test_333_bulk_429_storm_respects_deadline_within_grace` and `test_333_b1_bulk_running_storm_respects_deadline_via_outer_clamp`) remain valid as-is and the new assertion adds on top of the existing B-1 test infrastructure
- **Architecture risk: NONE** — no new modules, no new interfaces, no dependency graph changes
- **Security risk: NONE** — `task_id` surface already audited and validated via PR #355 (`validate_task_id` in `src/api/jira/bulk.rs`); CWE-117 log-injection surface for task_id already addressed (PR #356)

## Recommended Scope for Subsequent Phases

- **F2:** product-owner appends 1 new BC to `bc-3-issue-write.md`; updates BC-INDEX + CANONICAL-COUNTS; extends VP-deadline-bounded-bulk-poll to assert task_id literal in stderr
- **F3:** story-writer creates 1 story tracing to the new BC + the existing VP extension; story target: `tests/bulk_deadline_propagation.rs` additive assertion
- **F4:** test-writer extends `tests/bulk_deadline_propagation.rs` with 1 assertion (`stderr.contains(task_id_fixture_string)`) on the B-1 test; implementer no-op (production code already correct)
- **F5:** scoped adversarial on the test diff only (1-file diff; no production code surface)
- **F6:** minimal — no proofs, fuzz, or mutation testing needed for a single additive test assertion
- **F7:** PR via pr-manager, target develop, label `audit-followup`, close #340

## Deferred Follow-ups

- **Option (a) size-scaling formula** (`300 + keys.len() * 2`, capped at 1800s) — requires resolver signature change propagating to 3 call sites + 1 release-gate test update + new unit test for formula. File as a NEW enhancement issue if/when operational data shows the 300s fixed default is insufficient for real-world bulk operations.
- **Option (b) const-bump** (300s → 900s) — simpler than (a), but no empirical data justifies the bump today. File as a NEW enhancement issue with operational justification (e.g., field reports of timeout failures on large bulk edits) before acting.

## Quality Gate

Orchestrator approved 2026-05-15.
Human approval gate: implicitly approved via "proceed and follow vsdd process" directive.
