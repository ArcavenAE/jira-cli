# F1 Architect Input — Issue #340

Issue: chore(bulk): scale await_bulk_task timeout with bulk size or include task_id in timeout error
Source: F5 adversarial review of PR #348 / issue #110 part 2, 2026-05-10.
Date: 2026-05-15

---

## Impact Boundary

| Component | File | Change Type | Justification |
|-----------|------|-------------|---------------|
| Bulk poll engine | `src/api/jira/bulk.rs` | MODIFIED | Contains `DEFAULT_BULK_AWAIT_TIMEOUT_SECS` const, `resolve_bulk_await_timeout()`, and `await_bulk_task_inner`. Any option (a), (b), or test-only path touches this file. |
| Bulk edit handler | `src/cli/issue/create.rs` | DEPENDENT | Two call sites at lines 906 and 973 call `await_bulk_task(&task_id, resolve_bulk_await_timeout())`. Cited in issue body. Under option (a), callers must pass `keys.len()` into the resolver, requiring the resolver signature to change. |
| Bulk move handler | `src/cli/issue/workflow.rs` | DEPENDENT | Call site at line 522 calls `await_bulk_task(&task_id, resolve_bulk_await_timeout())`. Same exposure as `create.rs`; must be updated in lockstep under option (a). |
| Deadline propagation tests | `tests/bulk_deadline_propagation.rs` | MODIFIED | Contains the two existing deadline tests (`test_333_bulk_429_storm_respects_deadline_within_grace`, `test_333_b1_bulk_running_storm_respects_deadline_via_outer_clamp`). AC #1 of issue #340 requires adding a new assertion (or a new test) that pins `task_id` literal in the timeout error message. |
| Bulk edit happy-path tests | `tests/issue_bulk_pr2.rs` | DEPENDENT | Contains 25+ bulk-edit tests (including `test_bulk_task_failed_status_exits_nonzero_with_failed_in_stderr`). These exercise the full CLI subprocess path through the resolver. A signature change to `resolve_bulk_await_timeout()` could break test setup if the function is called directly from test helper code. Grep confirms it is imported via `use crate::api::jira::bulk::resolve_bulk_await_timeout` in both handlers — integration tests do not call it directly, so risk is low. |
| Release-gate test | `tests/bulk_await_timeout_release_gate.rs` | DEPENDENT | Asserts that `JR_BULK_AWAIT_TIMEOUT_SECS` is ignored in release builds. Under option (a) the resolver gains a `key_count: usize` parameter; the gate test will need updating to call the new signature. Under option (b) (const-bump only) the gate test is unaffected. |
| Error type | `src/error.rs` | NO CHANGE | `JrError::DeadlineExceeded { remaining_ms, message }` is already the correct variant; message already interpolates `task_id`. No variant taxonomy change needed. |
| API client deadline plumbing | `src/api/client.rs` | NO CHANGE | `get_bounded` / `send` deadline propagation fully implemented by PR #360. No structural change required for any option. |
| Spec / BC anchors | `.factory/specs/prd/bc-3-issue-write.md` | DEPENDENT | BC-3 does not currently have an explicit BC for the bulk-poll timeout policy (the anchor is `BC-bulk.poll.deadline-bounded` in source comments, which traces to S-333, not to a numbered bc-3 entry). The new test-only AC pin (#340 AC #1) does not require a new BC; it reinforces an existing behavior already covered by `BC-bulk.poll.deadline-bounded`. No BC-3 edit needed for TEST-ONLY-PIN scope. Option (a) changes the timeout policy and would require a new or amended BC entry. |
| CLAUDE.md | `CLAUDE.md` | DEPENDENT | CLAUDE.md "AI Agent Notes" documents `JR_BULK_AWAIT_TIMEOUT_SECS`. Under option (a), if `resolve_bulk_await_timeout` gains a parameter, the documentation comment must be updated to reflect the scaling formula. Under TEST-ONLY-PIN and option (b), no CLAUDE.md change is needed. |

---

## Architecture Delta

### TEST-ONLY-PIN scope (adding the task_id assertion alone)

No structural change. The fix is confined to `tests/bulk_deadline_propagation.rs`:
add a quaternary assertion to the existing B-1 test (`test_333_b1_bulk_running_storm_respects_deadline_via_outer_clamp`)
that checks `stderr.contains("task-333-b1-deadline-test")` (or equivalent task_id used in that test's wiremock fixture).
The error message format `"[deadline:bulk-outer] Bulk task {task_id} did not complete..."` at `src/api/jira/bulk.rs:412-414`
is already production-correct. No source file, interface, or const changes. Zero new modules or interfaces.

### Option (b) scope (const-bump to e.g. 900s)

Internal change to `DEFAULT_BULK_AWAIT_TIMEOUT_SECS` at `src/api/jira/bulk.rs:60`.
`resolve_bulk_await_timeout()` signature is unchanged; all three call sites remain valid.
The release-gate test in `tests/bulk_await_timeout_release_gate.rs` is unaffected.
The B-1 and AC-001 deadline tests both use `JR_BULK_AWAIT_TIMEOUT_SECS` to override the timeout
to 30s for test speed — they do not hard-code the 300s value — so they survive a const-bump without modification.
No new modules or interfaces. CLAUDE.md documentation about the const is stable (no seam behavior change).

### Option (a) scope (size-scaling formula)

Requires a resolver signature change: `resolve_bulk_await_timeout(key_count: usize) -> Duration`.
This propagates to all three call sites (`create.rs:906`, `create.rs:973`, `workflow.rs:522`),
which currently call `resolve_bulk_await_timeout()` without arguments.
Each call site must supply `effective_keys.len()` or the resolved key count.
At `create.rs:906` (`handle_edit_bulk_labels`) and `create.rs:973` (`handle_edit_bulk_fields`),
the key slice is in scope. At `workflow.rs:522` (`handle_move_bulk`) the key vec is in scope.
No call site requires a plumbing change beyond passing the count.
`tests/bulk_await_timeout_release_gate.rs` must be updated to call `resolve_bulk_await_timeout(0)`
or an appropriate count. No new modules or interfaces required. The cap (e.g., 1800s) should be a
second module-level const alongside `DEFAULT_BULK_AWAIT_TIMEOUT_SECS`.
A test asserting the scaling formula (AC #2 of the issue) belongs as a unit test inside `src/api/jira/bulk.rs`
(inline `#[cfg(test)]` block), not in an integration test, since `resolve_bulk_await_timeout` is a
pure deterministic function.

### No new modules or cross-cutting interfaces are required for any option.

---

## Regression Risk

| Module | Risk | Rationale |
|--------|------|-----------|
| `src/api/jira/bulk.rs` | MEDIUM | Core of the bulk infrastructure. The timeout const and resolver are already well-isolated and tested via `JR_BULK_AWAIT_TIMEOUT_SECS` seam. Option (b) is a single-integer change with no behavioral surface change in test runs. Option (a) adds a parameter — risk of accidental call-site omission is LOW given only three call sites, but each must be verified. Existing AC-001 and B-1 tests continue to guard the deadline-bounded property. |
| `src/cli/issue/create.rs` | LOW | Under option (a), two call sites gain a `keys.len()` argument. The function signatures for `handle_edit_bulk_labels` and `handle_edit_bulk_fields` already have the key slice in scope. No control-flow change. Under TEST-ONLY-PIN and option (b): untouched. |
| `src/cli/issue/workflow.rs` | LOW | Under option (a), one call site at line 522 gains a `keys.len()` argument. The `keys` vec is in scope. No control-flow change. Under TEST-ONLY-PIN and option (b): untouched. |
| `tests/bulk_deadline_propagation.rs` | LOW | Additive change only — new assertion(s) on existing test infrastructure. The wiremock fixtures and subprocess command construction are unchanged. Risk of test fragility if the task_id fixture string is refactored, but the fix is a literal string assertion on an already-pinned fixture value. |
| `tests/bulk_await_timeout_release_gate.rs` | LOW (option a only) | The gate test calls `resolve_bulk_await_timeout()` with no arguments. Under option (a) this becomes a compile error, caught at CI. Under TEST-ONLY-PIN and option (b): unaffected. |
| `tests/issue_bulk_pr2.rs` | LOW | Integration tests invoke the binary through subprocess; they do not import `resolve_bulk_await_timeout` directly. A const-bump does not affect their `JR_BULK_AWAIT_TIMEOUT_SECS`-driven test speed. A signature change is invisible to them. |
| `src/api/client.rs` | NONE | No change under any option. The deadline propagation infrastructure (S-333 / PR #360) is complete and tested. |
| `src/error.rs` | NONE | `JrError::DeadlineExceeded` already exists; the `task_id` is already in the message. No error taxonomy change. |

### Is this core/security-critical?

The bulk timeout policy is reliability-adjacent (NFR-R-NEW-3 / `BC-bulk.poll.deadline-bounded`) but NOT
security-critical in the CWE sense. The `task_id` was independently audited and validated in PR #355
(`src/api/jira/bulk.rs::validate_task_id`) specifically because it appears in error messages — the
security surface (log injection, CWE-117) has already been addressed. The timeout policy change itself
has no auth, credential, or privilege-escalation surface. Risk classification: MEDIUM overall
(touches shared bulk infrastructure with three call sites across two handler modules), LOW per individual
call site.

---

## Recommendation

**Scope recommendation: TEST-PIN + OPTION-B**

Rationale:

1. AC #1 (task_id in timeout error) is already implemented in production code. Only the test pin is missing.
   Adding the assertion to `test_333_b1_bulk_running_storm_respects_deadline_via_outer_clamp` is the
   minimum viable delivery for AC #1. This is one line in one test file.

2. Option (b) (const-bump from 300s to e.g. 900s) addresses the real-world large-bulk scenario
   with zero architectural complexity: one integer changes, three call sites are untouched, no
   new interfaces, no release-gate churn, existing test seam (`JR_BULK_AWAIT_TIMEOUT_SECS`) continues
   to work unchanged. The tradeoff vs option (a): a fixed const does not scale with key count, but
   a 900s default covers the issue's stated concern (1000 issues × 2s/issue = 2000s theoretical max;
   in practice Atlassian processes in parallel so 900s is a reasonable upper bound). If the team
   wants option (a), the architectural delta is manageable but requires touching four files and
   updating one release-gate test.

3. Option (a) is NOT recommended as the first delivery for this audit-followup. The scaling formula
   `300 + keys.len() * 2` capped at 1800s is straightforward, but it introduces a new function
   signature that propagates to three call sites and one gate test, and it requires a new unit test
   for the formula. This is appropriate for a future feature cycle if operational data confirms the
   900s flat default is insufficient.

**Trivial-scope eligible (per F1 skill criteria)? YES**

The TEST-PIN + OPTION-B scope involves: (1) one new assertion in one existing test file, and
(2) one integer constant change in one source file. No new modules, no new interfaces, no BC additions,
no error taxonomy changes, no CLAUDE.md updates. Total estimated diff: ~20 lines across two files.
This qualifies as trivial scope under the F1 criteria (pure additive test + isolated const change,
no structural impact).

If the team escalates to option (a): NOT trivial (four-file change with signature propagation),
but still eligible for a single-story F3 delivery without a full feature-mode cycle.
