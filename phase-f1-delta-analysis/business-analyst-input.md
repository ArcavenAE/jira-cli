---
document_type: business-analyst-input
phase: F1
issue: 340
producer: business-analyst
inputs:
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/nfr-catalog.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/stories/STORY-INDEX.md"
  - ".factory/STATE.md"
  - ".factory/code-delivery/issue-333/delta-analysis.md"
  - "tests/bulk_deadline_propagation.rs"
  - "tests/bulk_await_timeout_release_gate.rs"
  - "src/api/jira/bulk.rs"
input-hash: "[pending]"
status: draft
timestamp: 2026-05-15
---

# F1 Business-Analyst Input — Issue #340

## BC Mapping

No existing L3 BC covers the `await_bulk_task` polling timeout as a
behaviorally-contracted guarantee. BC-3.4.xxx (Edit and Open) covers the
per-key `issue edit` PUT path; none of those BCs mention bulk polling duration,
the timeout message text, or task_id inclusion in error output.

The issue-333 F1 delta analysis (`.factory/code-delivery/issue-333/delta-analysis.md`)
proposed `BC-bulk.poll.deadline-bounded` as a new BC but that was a working label, not
a canonically-registered ID. The cross-cutting.md and BC-INDEX.md confirm no
`BC-bulk.*` heading was ever formally registered — the `await_bulk_task` timeout
behavior is currently uncontracted in the L3 PRD.

| BC ID | Title | Status | Notes |
|-------|-------|--------|-------|
| BC-3.4.003 | `issue edit` PUTs `/rest/api/3/issue/<key>` with ADF description; accepts 204 | UNCHANGED | Single-key edit path; not the bulk polling path; unaffected by #340 |
| BC-3.4.004 | `issue edit` with markdown ADF conversion | UNCHANGED | Field-building, not polling; unaffected |
| BC-3.4.005 | `issue edit` with multiple fields sends both in body simultaneously | UNCHANGED | Request shape, not timeout or task_id; unaffected |
| (new) BC-3.4.NNN | `await_bulk_task` timeout error MUST include task_id in message | NEW — required | Pins the existing `[deadline:bulk-outer] Bulk task {task_id} did not complete within …` message text; satisfies #340 AC #1 |
| (new) BC-3.4.NNN+1 | `JR_BULK_AWAIT_TIMEOUT_SECS` debug-only seam allows test-driven timeout verification | NEW — required | Needed for wiremock-driven AC test; mirrors BC-2.6.050 pattern |

**Justification for new BCs:** Both BCs are grounded in #340's explicit acceptance
criteria ("a test that verifies the timeout error mentions the task_id") and the
existing code path at `src/api/jira/bulk.rs:412`. The `[deadline:bulk-outer]` message
already includes `task_id` in code, but no BC pins this as a contract — the gap is
confirmed: `tests/bulk_deadline_propagation.rs` only asserts `stderr.contains("deadline")`,
not `stderr.contains(task_id)`. Exact IDs to be assigned by F2 spec-evolution pass.

## NFR/VP Mapping

| NFR-ID / VP-ID | Title | Coverage Note |
|----------------|-------|---------------|
| (no existing NFR) | Bulk poll timeout bounded and informative | No NFR in `nfr-catalog.md` covers bulk timeout behavior. The issue is out-of-scope for all 40 catalogued NFRs. A new NFR is NOT recommended — the change is narrow enough to be captured as BCs only. |
| VP-deadline-bounded-bulk-poll | Wiremock-driven: 429 storm + 30s deadline → error within ~35s | EXTENSION NEEDED — current VP (from issue-333 delta-analysis) asserts wall-clock bound and `"deadline"` in stderr; needs extension to also assert `task_id` literal appears in stderr. No new VP needed — extend existing. |

## Story Risk-Zone

| Story | File | Why in risk zone |
|-------|------|------------------|
| S-333 (closed — PR #360) | `.factory/stories/wave-3/` (no dedicated file; delivered as feature-mode) | Directly delivered `await_bulk_task` outer-loop deadline clamping and the `[deadline:bulk-outer]` message. Any new test touching `bulk_deadline_propagation.rs` is in the same file as S-333 test infrastructure. |
| S-110-pr2 (closed — PR #348) | `tests/issue_bulk.rs`, `tests/issue_bulk_pr2.rs` | Original bulk-edit feature delivery. Tests in `issue_bulk.rs` and `issue_bulk_pr2.rs` exercise `await_bulk_task` through the full CLI path. Any signature change to `await_bulk_task` is in the regression blast radius. |

No Wave 0–3 story modifies `src/api/jira/bulk.rs` timeout logic post-#333 closure.
The risk zone is bounded: only `bulk_deadline_propagation.rs` and the two
`issue_bulk*.rs` files are active test surfaces.

## Tests in Neighborhood

| File | Test | Relation to #340 |
|------|------|-----------------|
| `tests/bulk_deadline_propagation.rs` | `test_333_bulk_429_storm_respects_deadline_within_grace` | Pins AC-001 of #333: wall-clock bound + exit 124 + stderr contains "deadline". Does NOT assert `task_id` in stderr — this is the gap #340 AC #1 targets. |
| `tests/bulk_deadline_propagation.rs` | `test_333_b1_bulk_running_storm_respects_deadline_via_outer_clamp` | Same gap: only asserts `"deadline"` substring, not task_id literal. |
| `tests/bulk_await_timeout_release_gate.rs` | `test_333_cfg_gate_present_in_bulk_source` | Regression-guards that `JR_BULK_AWAIT_TIMEOUT_SECS` env-var seam is present in source. Must remain green. |
| `tests/bulk_await_timeout_release_gate.rs` | `test_333_debug_assertions_active_in_test_binary` | Guards that `#[cfg(debug_assertions)]` gate is active in test builds. Must remain green. |
| `tests/bulk_unknown_grace_release_gate.rs` | (all tests) | Guards `JR_BULK_UNKNOWN_GRACE_SECS` seam. Indirect neighbor; not touched by #340. |
| `tests/issue_bulk.rs` | `test_edit_multi_key_issues_one_bulk_post_then_polls_to_complete` | Tests polling happy-path end-to-end. Regression baseline. |
| `tests/issue_bulk_pr2.rs` | `test_bulk_task_failed_status_exits_nonzero_with_failed_in_stderr` | Asserts task_id appears in combined output for FAILED state. Related pattern — the timeout path has no equivalent assertion yet. |
| `tests/issue_bulk_pr2.rs` | `test_336_cli_unknown_status_emits_warning_and_escalates` | Unknown-status escalation path. Neighbor; unaffected by #340. |

## Feature Type

`backend` — the change is entirely within the Rust CLI binary
(`src/api/jira/bulk.rs` and `tests/bulk_deadline_propagation.rs`). No UI,
no API schema change, no new external dependency, no configuration file format
change.

## Intent Classification

`enhancement`

**Reasoning:** The issue presents three fix options and states "at minimum: include
the task_id in the timeout error message." Option (c) — include task_id — is already
implemented in the code at `src/api/jira/bulk.rs:412` (message:
`"[deadline:bulk-outer] Bulk task {task_id} did not complete within …"`). What remains
is (1) a test that pins this behavior as a contract, and (2) optionally a scaling
formula. This is not a bug-fix in the classic sense: the user-visible behavior
(task_id in message) already works correctly. The remaining work is behavioral
contract coverage (test AC #1) and optionally a UX improvement (scaled timeout).
The issue is labeled "enhancement" by the author. Intent = `enhancement`.

**Not `bug-fix`:** The timeout *value* (300s fixed) is a known design trade-off,
not a correctness failure. The task_id message is already correct. The missing piece
is test coverage, which is a spec-coverage gap, not a behavioral regression.

**Not `feature`:** The capability (bulk-task timeout with error message) already
exists. This is incremental strengthening of test coverage and optionally a
timeout formula refinement.

## Trivial-Scope Verdict

STANDARD

Criterion-by-criterion:

- **Single module / single file:** NO — touches at minimum `tests/bulk_deadline_propagation.rs`
  (new assertion) and potentially `src/api/jira/bulk.rs` (if scaling option (a) is
  chosen: `300 + keys.len() * 2` formula and the `CLAUDE.md` env-var documentation
  entry for any new seam). Even the minimal AC #1 path (test-only) modifies one test
  file and requires verifying one impl file — two files minimum.
- **No new BCs:** NO — at least one new BC is needed to formally contract the
  task_id-in-timeout-message behavior. Without a BC, the test has no spec anchor.
  This is a spec evolution requirement, not just a test addition.
- **No architecture change:** YES — no new modules, no new abstractions, no
  dependency graph changes. The optional scaling formula is an arithmetic change to
  one constant site.
- **No new external deps:** YES — all test infrastructure (wiremock, assert_cmd) is
  already in use.
- **LOW regression risk:** YES for AC #1 path (test-only + no code change). MEDIUM
  if scaling option (a) is chosen, because changing the timeout value would require
  updating `JR_BULK_AWAIT_TIMEOUT_SECS`-driven tests and the `CLAUDE.md` seam
  documentation. The deadline propagation tests in `bulk_deadline_propagation.rs`
  are already sensitive to exact timeout values (lower-bound assertion enforces
  `elapsed > MIN_ELAPSED_SECS`).

Failing criteria: "Single module/file" (NO) and "No new BCs" (NO).

## Recommendation

Approve a STANDARD-scope delta with the following boundaries: (1) add one new BC
anchoring the task_id-in-timeout-message contract (BC-3.4.NNN or a new cross-cutting
sub-section); (2) extend the existing wiremock test in `tests/bulk_deadline_propagation.rs`
to assert that the task_id literal appears in stderr on timeout, satisfying #340 AC #1;
(3) defer scaling option (a) — the linear-scaling formula (`300 + keys.len() * 2`)
is a plausible UX improvement but introduces new seam documentation burden and
regression sensitivity in deadline tests, and the issue explicitly marks it as
optional ("at minimum: include the task_id"). The `JR_BULK_AWAIT_TIMEOUT_SECS`
debug-only env-var seam is already present and wired; no new seam is needed for
AC #1. Total estimated scope: 1 new BC, 1 modified test file (~10–20 lines), no
impl changes. Copilot review surface is minimal.
