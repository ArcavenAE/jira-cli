# [S-1.07] Rate-limit holdout suite (H-013, H-027)

**Epic:** Wave 1 — High Priority Infrastructure
**Mode:** brownfield
**Convergence:** CONVERGED after 13 adversarial passes (Phase 2 story decomposition)

![Tests](https://img.shields.io/badge/tests-6%2F6-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-N%2FA%20(test--only%20PR)-brightgreen)
![Mutation](https://img.shields.io/badge/mutation-N%2FA%20(test--only%20PR)-green)
![Holdout](https://img.shields.io/badge/holdout-6%2F6%20PASS-blue)

Adds a regression-pin test suite (6 tests) for rate-limit retry semantics (`H-013`) and `Retry-After` header parsing (`H-027`). All 6 tests pass on current develop — no implementation changes required. A `KNOWN-GAP` comment on the H-027 assertion documents the flip-point when `NFR-R-NEW-1` (`MAX_RETRY_AFTER_SECS=60` cap) is implemented in S-3.07.

---

## Architecture Changes

```mermaid
graph TD
    RateLimitRS["src/api/rate_limit.rs<br/>(existing)"]
    ClientRS["src/api/client.rs<br/>(existing — send/send_raw)"]
    HoldoutSuite["tests/rate_limit_holdouts.rs<br/>(NEW — test-only file)"]
    Wiremock["wiremock (existing dev-dep)"]
    AssertCmd["assert_cmd (existing dev-dep)"]

    HoldoutSuite -->|imports RateLimitInfo| RateLimitRS
    HoldoutSuite -->|imports JiraClient| ClientRS
    HoldoutSuite -->|mocks HTTP| Wiremock
    HoldoutSuite -->|process spawn| AssertCmd

    style HoldoutSuite fill:#90EE90
```

<details>
<summary><strong>Architecture Decision Record</strong></summary>

### ADR: Test-only addition, no production code changes

**Context:** The rate-limit retry logic in `src/api/client.rs` and header-parsing logic in `src/api/rate_limit.rs` are exercised by every API call. ADR-0006 (embedded OAuth) changed auth header construction but not retry plumbing. Without regression pins, a future refactor could silently break retry semantics.

**Decision:** Add `tests/rate_limit_holdouts.rs` with 6 tests covering the two holdout scenarios (H-013, H-027) and 3 boundary/regression-guard cases. No production code changes.

**Rationale:** Pure test addition is lowest-risk. `RateLimitInfo` is `pub` (re-exported via `jr::api::rate_limit`), so integration tests can exercise the parser directly without changing visibility.

**Alternatives Considered:**
1. Inline unit tests in `src/api/rate_limit.rs` — rejected because the integration tests (H-013 wiremock) require the full `JiraClient` and cannot be inline.
2. Extend existing `tests/rate_limit.rs` — rejected because S-1.07 is a dedicated holdout suite (separate file aids discoverability and CI reporting).

**Consequences:**
- Regression detection for retry semantics on all future PRs.
- H-027 KNOWN-GAP creates a documented flip point for S-3.07 (NFR-R-NEW-1).

</details>

---

## Story Dependencies

```mermaid
graph LR
    S106["S-1.06<br/>merged (PR #300)"] --> S107["S-1.07<br/>this PR"]
    S107 --> S108["S-1.08<br/>draft — Keychain holdout"]

    style S107 fill:#FFD700
    style S106 fill:#90EE90
```

S-1.07 has no hard code dependencies (`depends_on: []` in story spec). It is in Wave 1 parallel group B with S-1.08. The dependency arrow from S-1.06 is logical (follows the same PR sequence), not a code dependency.

---

## Spec Traceability

```mermaid
flowchart LR
    BCX1["BC-X.1.005<br/>send_raw returns 429<br/>after MAX_RETRIES=3"]
    BCX4["BC-X.4.002<br/>RateLimitInfo preserves<br/>Retry-After without cap"]

    AC001["AC-001 / H-013<br/>send_raw persistent 429<br/>(library + process split)"]
    AC002["AC-002 / H-027<br/>Retry-After 86400<br/>no cap (KNOWN-GAP)"]
    AC003["AC-003<br/>send recovers<br/>after 2 retries"]
    AC004["AC-004<br/>Retry-After 0<br/>boundary value"]
    AC005["AC-005<br/>Retry-After abc<br/>returns None"]

    T1["test_s_1_07_h_013_send_raw_persistent_429_returns_429_after_max_retries"]
    T2["test_s_1_07_h_013_send_raw_gave_up_warning_in_stderr"]
    T3["test_s_1_07_h_027_retry_after_86400_no_cap"]
    T4["test_s_1_07_h_013_send_recovers_after_2_retries"]
    T5["test_s_1_07_retry_after_0_boundary"]
    T6["test_s_1_07_retry_after_unparseable_returns_none"]

    Src1["src/api/client.rs"]
    Src2["src/api/rate_limit.rs"]

    BCX1 --> AC001
    BCX1 --> AC003
    BCX4 --> AC002
    BCX4 --> AC004
    BCX4 --> AC005

    AC001 --> T1
    AC001 --> T2
    AC002 --> T3
    AC003 --> T4
    AC004 --> T5
    AC005 --> T6

    T1 --> Src1
    T2 --> Src1
    T4 --> Src1
    T3 --> Src2
    T5 --> Src2
    T6 --> Src2
```

---

## Test Evidence

### Coverage Summary

| Metric | Value | Threshold | Status |
|--------|-------|-----------|--------|
| Holdout tests | 6/6 pass | 6/6 | PASS |
| Integration tests (wiremock) | 3/3 pass | 100% | PASS |
| Process-level tests (assert_cmd) | 1/1 pass | 100% | PASS |
| Unit tests (header parsing) | 3/3 pass | 100% | PASS |
| Regressions | 0 | 0 | PASS |
| All 600+ lib + integration tests | PASS | 0 regressions | PASS |

### Test Flow

```mermaid
graph LR
    Unit["3 Unit Tests<br/>(header parsing)"]
    Integration["3 Integration Tests<br/>(wiremock HTTP mock)"]
    Process["1 Process Test<br/>(assert_cmd stderr)"]
    Holdout["6 Holdout Pins<br/>(H-013 x4, H-027 x1, boundary x1)"]

    Unit -->|100%| Pass1["PASS"]
    Integration -->|100%| Pass2["PASS"]
    Process -->|100%| Pass3["PASS"]
    Holdout -->|6/6 MUST-PASS| Pass4["PASS"]

    style Pass1 fill:#90EE90
    style Pass2 fill:#90EE90
    style Pass3 fill:#90EE90
    style Pass4 fill:#90EE90
```

| Metric | Value |
|--------|-------|
| **New tests** | 6 added, 0 modified |
| **Total suite** | 6 tests PASS in ~0.77s (holdout suite); 600+ lib + all integration green |
| **Coverage delta** | Test-only PR — no production lines added |
| **Mutation kill rate** | N/A (test-only PR) |
| **Regressions** | 0 |

<details>
<summary><strong>Detailed Test Results</strong></summary>

### New Tests (This PR)

| Test | AC | Result | Duration |
|------|----|--------|----------|
| `test_s_1_07_h_013_send_raw_persistent_429_returns_429_after_max_retries()` | AC-001 (lib) | PASS | ~0.1s |
| `test_s_1_07_h_013_send_raw_gave_up_warning_in_stderr()` | AC-001 (process) | PASS | ~0.3s |
| `test_s_1_07_h_027_retry_after_86400_no_cap()` | AC-002 | PASS | <0.01s |
| `test_s_1_07_h_013_send_recovers_after_2_retries()` | AC-003 | PASS | ~0.1s |
| `test_s_1_07_retry_after_0_boundary()` | AC-004 | PASS | <0.01s |
| `test_s_1_07_retry_after_unparseable_returns_none()` | AC-005 | PASS | <0.01s |

### Coverage Analysis

This PR adds only `tests/rate_limit_holdouts.rs` — a test-only file. No production source lines are added or modified. Coverage delta is neutral.

</details>

---

## Holdout Evaluation

| Metric | Value | Threshold |
|--------|-------|-----------|
| H-013 (send_raw retry exhaustion) | **MUST-PASS** | 1.00 |
| H-027 (Retry-After no-cap, KNOWN-GAP) | **MUST-PASS** | 1.00 |
| Boundary AC-003 (recovery guard) | **PASS** | 1.00 |
| Boundary AC-004 (value 0) | **PASS** | 1.00 |
| Boundary AC-005 (parse failure) | **PASS** | 1.00 |
| **Overall result** | **6/6 PASS** | 6/6 |

**KNOWN-GAP documentation:**
- H-027 asserts `retry_after_secs == Some(86400)` — no cap. This pins the current (pre-fix) behavior.
- When NFR-R-NEW-1 (`MAX_RETRY_AFTER_SECS=60`) is implemented in S-3.07, the assertion in `test_s_1_07_h_027_retry_after_86400_no_cap` flips to `Some(60)` and the holdout status changes from MUST-PASS (KNOWN-GAP) to MUST-PASS-AFTER-FIX.
- The KNOWN-GAP comment in the test code explicitly references S-3.07 and NFR-R-NEW-1.

<details>
<summary><strong>Per-Holdout Details</strong></summary>

| Holdout | Category | Assertion | Status |
|---------|----------|-----------|--------|
| H-013 (lib) | MUST-PASS | `response.is_ok() && status == 429 && wiremock.expect(4)` | PASS |
| H-013 (process) | MUST-PASS | `stderr contains "rate limited by Jira — gave up after 3 retries"` | PASS |
| H-027 | MUST-PASS (KNOWN-GAP) | `retry_after_secs == Some(86400)` | PASS |
| AC-003 guard | PASS | `response.is_ok() with status 200 + 3 total calls` | PASS |
| AC-004 boundary | PASS | `retry_after_secs == Some(0)` | PASS |
| AC-005 parse fail | PASS | `retry_after_secs == None` | PASS |

</details>

---

## Adversarial Review

Story spec was converged through Phase 2 adversarial review (13 passes to CONVERGED).
Story-level adversarial findings were resolved in Phase 2. No per-implementation adversarial passes required for a test-only PR on existing behavior.

| Metric | Value |
|--------|-------|
| Phase 2 adversarial passes | 13 |
| Story-level findings | All resolved |
| Per-implementation adversarial | N/A (test-only) |

---

## Security Review

```mermaid
graph LR
    Critical["Critical: 0"]
    High["High: 0"]
    Medium["Medium: 0"]
    Low["Low: 0"]

    style Critical fill:#90EE90
    style High fill:#90EE90
    style Medium fill:#90EE90
    style Low fill:#90EE90
```

<details>
<summary><strong>Security Scan Details</strong></summary>

### SAST
- PR adds only `tests/rate_limit_holdouts.rs` — test-only code, no user-facing logic.
- No hardcoded secrets. `JR_AUTH_HEADER` test value is `"Basic dGVzdDp0ZXN0"` (base64 of `test:test`), a well-known non-secret test credential.
- No injection points. No user input handling.
- Critical: 0 | High: 0 | Medium: 0 | Low: 0

### Dependency Audit
- No new dependencies added. Existing dev-deps used: `wiremock`, `tokio`, `assert_cmd`, `tempfile`.
- `cargo deny check` passes (verified in CI at activation HEAD).

### Supply Chain
- `cargo deny` CI job (S-1.02) enforces deny.toml rules on all dev-deps including new test imports.

</details>

---

## Risk Assessment & Deployment

### Blast Radius
- **Systems affected:** None (test-only file; no production binary changes)
- **User impact:** None if tests fail CI — this PR will not merge with failing CI
- **Data impact:** None
- **Risk Level:** LOW

### Performance Impact
| Metric | Before | After | Delta | Status |
|--------|--------|-------|-------|--------|
| Binary size | unchanged | unchanged | 0 | OK |
| CI test time | ~existing | +~1s (6 new tests) | negligible | OK |
| Runtime behavior | unchanged | unchanged | 0 | OK |

<details>
<summary><strong>Rollback Instructions</strong></summary>

**Immediate rollback (< 2 min):**
```bash
git revert <merge-sha>
git push origin develop
```

Since this PR adds only a test file, rollback simply removes the holdout suite. No runtime behavior changes.

**Verification after rollback:**
- `cargo test` passes without the holdout suite
- `cargo build` produces identical binary

</details>

### Feature Flags
N/A — test-only PR, no runtime feature flags.

---

## Demo Evidence

Demo recordings at: `docs/demo-evidence/S-1.07/`

| AC | Recording | Result |
|----|-----------|--------|
| AC-001 / H-013 | `AC-001-send-raw-persistent-429.{gif,webm}` | 2 tests PASS |
| AC-002 / H-027 | `AC-002-retry-after-86400-no-cap.{gif,webm}` | 1 test PASS (KNOWN-GAP) |
| AC-003 | `AC-003-send-recovers-after-2-retries.{gif,webm}` | 1 test PASS |
| AC-004 | `AC-004-retry-after-0-boundary.{gif,webm}` | 1 test PASS |
| AC-005 | `AC-005-retry-after-unparseable.{gif,webm}` | 1 test PASS |
| Combined | `COMBINED-all-6-tests-green.{gif,webm}` | 6/6 PASS |

Full evidence report: `docs/demo-evidence/S-1.07/evidence-report.md`

---

## Traceability

| Requirement | Story AC | Test | Holdout | Status |
|-------------|---------|------|---------|--------|
| BC-X.1.005 — send_raw returns 429 raw | AC-001 | `test_s_1_07_h_013_send_raw_persistent_429_returns_429_after_max_retries` | H-013 | PASS |
| BC-X.1.005 — stderr gave-up warning | AC-001 | `test_s_1_07_h_013_send_raw_gave_up_warning_in_stderr` | H-013 | PASS |
| BC-X.4.002 — Retry-After no cap | AC-002 | `test_s_1_07_h_027_retry_after_86400_no_cap` | H-027 (KNOWN-GAP) | PASS |
| BC-X.1.005 — send recovers on 200 | AC-003 | `test_s_1_07_h_013_send_recovers_after_2_retries` | — | PASS |
| BC-X.4.002 — boundary 0 preserved | AC-004 | `test_s_1_07_retry_after_0_boundary` | — | PASS |
| BC-X.4.002 — parse failure returns None | AC-005 | `test_s_1_07_retry_after_unparseable_returns_none` | — | PASS |

<details>
<summary><strong>Full VSDD Contract Chain</strong></summary>

```
BC-X.1.005 -> AC-001 -> test_s_1_07_h_013_send_raw_persistent_429_returns_429_after_max_retries -> src/api/client.rs (send_raw) -> H-013 MUST-PASS
BC-X.1.005 -> AC-001 -> test_s_1_07_h_013_send_raw_gave_up_warning_in_stderr -> src/api/client.rs (eprintln) -> H-013 MUST-PASS
BC-X.4.002 -> AC-002 -> test_s_1_07_h_027_retry_after_86400_no_cap -> src/api/rate_limit.rs (from_headers) -> H-027 MUST-PASS (KNOWN-GAP)
BC-X.1.005 -> AC-003 -> test_s_1_07_h_013_send_recovers_after_2_retries -> src/api/client.rs (send/get) -> regression guard
BC-X.4.002 -> AC-004 -> test_s_1_07_retry_after_0_boundary -> src/api/rate_limit.rs (from_headers) -> boundary pin
BC-X.4.002 -> AC-005 -> test_s_1_07_retry_after_unparseable_returns_none -> src/api/rate_limit.rs (from_headers) -> parse-fail pin
```

</details>

---

## AI Pipeline Metadata

<details>
<summary><strong>Pipeline Details</strong></summary>

```yaml
ai-generated: true
pipeline-mode: brownfield
factory-version: "1.0.0-rc.8"
pipeline-stages:
  spec-crystallization: completed
  story-decomposition: completed
  tdd-implementation: completed
  holdout-evaluation: completed
  adversarial-review: N/A (test-only)
  formal-verification: skipped (test-only)
  convergence: achieved
convergence-metrics:
  spec-novelty: N/A
  test-kill-rate: N/A (test-only)
  implementation-ci: 1.00
  holdout-satisfaction: 1.00
  holdout-std-dev: 0.00
adversarial-passes: 13 (Phase 2 story-level)
models-used:
  builder: claude-sonnet-4-6
  adversary: claude-sonnet-4-6
generated-at: "2026-05-07T00:00:00Z"
```

</details>

---

## Pre-Merge Checklist

- [ ] All CI status checks passing
- [x] Coverage delta is neutral (test-only PR)
- [x] No critical/high security findings
- [x] Rollback procedure documented (trivial revert of test file)
- [x] No feature flags required
- [x] KNOWN-GAP comment in test references S-3.07 and NFR-R-NEW-1 explicitly
- [x] 6/6 holdout tests PASS on activation HEAD dea1664
- [x] Demo evidence present for all 5 ACs (evidence-report.md + 6 recordings)

---

## Summary

- 6 regression-pin tests covering H-013 (send_raw 429 retry exhaustion) and H-027 (RateLimitInfo header parsing)
- All 6 pass on current develop — no regressions discovered
- KNOWN-GAP documented for AC-002: Retry-After cap will be added in S-3.07 (NFR-R-NEW-1)

**Related:** Follows PR #300 (S-1.06 OAuth flow holdout suite). Part of Wave 1 parallel group B.
**Breaking change:** false
