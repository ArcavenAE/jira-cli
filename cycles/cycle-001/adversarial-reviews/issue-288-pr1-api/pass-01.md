---
pass: 01
story: issue-288-pr1-api
cycle: 3-feature-jsm-request-types-288
target: "S-288-pr1-api implementation diff (6 commits, ~250 LOC)"
model: "Opus 4.7 (1M)"
timestamp: 2026-05-18
verdict: CLEAN-PASS
counts:
  blocking: 0
  concern: 0
  nit: 3
counter_status: "1/3 (first CLEAN; 2 more required)"
---

# Adversarial Review — issue-288-pr1-api — Pass 01

## Findings Summary

| ID  | Severity | Location | Summary |
|-----|----------|----------|---------|
| F-01 | NIT | `.factory/code-delivery/issue-288-pr1-api/story.md:113` | AC-002 cites stale camelCase test name |
| F-02 | NIT | `src/api/jsm/request_types.rs:35-54` | Pagination loop missing `size:0 && isLastPage:false` infinite-loop guard |
| F-03 | NIT | `tests/jsm_request_api.rs:208-251` | AC-003 negative test self-documented as soft; matcher not strictly enforced |

---

## Detailed Findings

### F-01 (NIT) — AC-002 story.md cites stale test name

**File:** `.factory/code-delivery/issue-288-pr1-api/story.md:113`

**Observation:** AC-002 cites the test name `test_list_request_types_paginates_isLastPage` (camelCase tail). The actual test name at `tests/jsm_request_api.rs:65` is `test_list_request_types_paginates_is_last_page` (fully snake_case), which correctly follows the project test-naming convention documented in CLAUDE.md (`test_<verb>_<subject>_<expected_outcome>`).

**Impact:** Stale spec citation; no runtime impact. A reader auditing AC coverage against the spec would fail to locate the test by name.

**Recommendation:** Update story.md AC-002 line 113 to cite `test_list_request_types_paginates_is_last_page`.

---

### F-02 (NIT) — Pagination loop missing zero-progress guard

**File:** `src/api/jsm/request_types.rs:35-54`

**Observation:** The pagination loop advances `next_start = start + values.len()`. If Atlassian returns a response with `{values: [], isLastPage: false, size: 0}`, then `next_start = start + 0 = start` and the loop spins forever — no forward progress, no termination condition.

The same pattern is present as a pre-existing issue in `src/api/jsm/queues.rs:19-33`. This PR does not introduce the flaw; it inherits the precedent.

**Impact:** Theoretical infinite loop on malformed/unexpected upstream response. Not triggered by any known Atlassian behavior in production. Low probability but unbounded in duration if triggered.

**Recommendation:** Add a defensive guard: `if next_start == start && has_more { break; }` (or log-and-break with a warning). File as a follow-up issue tracking cleanup of both `request_types.rs` and the sibling `queues.rs`. Not a blocker for this PR.

---

### F-03 (NIT) — AC-003 negative test matcher softness self-documented

**File:** `tests/jsm_request_api.rs:208-251`

**Observation:** The test for the `searchQuery`-absent path explicitly self-documents that wiremock's additive matchers do not strictly verify absence of the `searchQuery` query parameter. The positive AC-003 test (lines 158-199) does provide affirmative proof that `searchQuery` is correctly included when supplied. The negative path test proves the non-error path but not strict parameter absence.

**Impact:** If a future refactor accidentally sends `searchQuery` on the no-query path, this test would not catch it.

**Recommendation:** Harden with a `query_param_is_missing("searchQuery")` matcher if the wiremock crate version supports it; otherwise add an inline comment acknowledging the limitation and track as a follow-up. Current state is acceptable; this is a coverage softness observation, not a defect.

---

## Per-Mandate Audit

| # | Mandate | Verdict | Notes |
|---|---------|---------|-------|
| 1 | AC coverage — AC-001..AC-007 each pinned by a named test or gate evidence | PASS | AC-001..AC-006 have named tests; AC-007 (release gate) evidenced by clean diff with no `cfg(debug_assertions)` bypass |
| 2 | Test quality — `expect(1)` on every mock | PASS | All mocks carry `.expect(1)` verified |
| 3 | HTTP error path — no swallowing | PASS | Clean `?` propagation throughout; no `unwrap_or_default` on error paths |
| 4 | URL encoding — path IDs encoded | PASS | `urlencoding::encode` applied at `request_types.rs:29`, `:70`, `:71` for all three path segment IDs |
| 5 | Pagination correctness — mirrors precedent | PASS | Uses `has_more()` + `next_start()`; mirrors `queues.rs` precedent (F-02 NIT tracks shared flaw) |
| 6 | Query param construction — `None` omits searchQuery | PASS | `Option`-matched; `None` branch omits the parameter; verified against AC-003 |
| 7 | Type design — nullable fields modeled correctly | PASS | `Option` for sometimes-absent fields; `Vec<String>` with `#[serde(default)]` for `groupIds` |
| 8 | JsmRequest type intent documented | PASS | Doc-comment on `JsmRequest` notes it is the pr4 caller's type; does not over-promise |
| 9 | Trace fidelity — BC IDs match current spec | PASS | `BC-3.8.001`, `BC-X.12.001`, `BC-X.12.005` all match the cycle-001 spec index |
| 10 | No CLI or cache imports in API layer | PASS | `src/api/jsm/request_types.rs` imports are clean (reqwest, serde, urlencoding, types) |
| 11 | No `#[allow]` suppressions | PASS | None present in diff |
| 12 | No `unimplemented!()` stubs shipped | PASS | Placeholder removed; all paths have real implementations |
| 13 | Test isolation — each test owns its MockServer | PASS | Each test function creates its own `MockServer::start().await` |
| 14 | Citation discipline — external tracker IDs validated | PASS | `JRACLOUD-71293` reference at `request_types.rs:8` is semantically correct (user pagination fixed-window behavior) |

---

## Novelty Assessment

This is the baseline pass for issue-288-pr1-api. The diff is shallow and well-bounded (~250 LOC, 6 commits). The implementation is a straightforward new JSM endpoint pair following established precedent in `queues.rs`. No novel algorithmic surface, no auth plumbing changes, no cache schema changes. F-02's zero-progress guard is the only systemic risk and it is pre-existing in the codebase; the PR does not make it worse.

Counter trajectory: `0/3 → 1/3`. Two additional consecutive CLEAN passes required before CONVERGENCE-PASS verdict.

---

## Verdict

**CLEAN-PASS — 0B / 0C / 3N — counter 0/3 → 1/3**

Three nits logged. None block merge. F-01 is a stale spec citation; F-02 is a pre-existing defensive-coding gap worth a follow-up issue; F-03 is a test-coverage softness acknowledged inline. No blocking findings. No concerns. Proceed to pass 02.
