---
document_type: f1-delta-analysis
phase: phase-f1-delta-analysis
producer: state-manager
feature: e2e-test-enhancements
status: awaiting-human-approval
timestamp: 2026-05-29
project: jira-cli
mode: BROWNFIELD
intent: enhancement
feature_type: infrastructure
trivial_scope: false
regression_risk: low
bc_delta: empty
src_delta: zero
---

# Delta Analysis Report — Live-Jira E2E Test Suite Enhancements

**Feature:** Live-Jira E2E test suite enhancements (regression-safety + portability hardening)
**Design spec:** docs/specs/e2e-test-enhancements.md (branch test/e2e-enhancements @ d0f6ba3)
**Research:** .factory/research/e2e-enhancement-best-practices.md (Perplexity-primary, cited)
**Mode:** BROWNFIELD / Feature Mode (F1-F7)

## Classification
| Dimension | Value |
|-----------|-------|
| Feature type | infrastructure (test-only) |
| Intent | enhancement |
| Trivial scope? | NO -- multiple new test functions + new CI workflow; full F1-F7 |
| BC delta | EMPTY (covers existing contracts) -- same as S-E2E-1/S-E2E-2 |
| src/ delta | ZERO (preserves S-E2E-1/S-E2E-2 precedent) |
| Architecture change | NO (.factory/specs/architecture absent; no ADR update) |

## Impact Assessment
| Layer | Impact |
|-------|--------|
| PRD / BCs | No change. Tests VERIFY existing BCs across bc-2, bc-3, bc-5, bc-7, error-taxonomy. |
| Architecture | No change. |
| UX | N/A (infrastructure). |
| Stories | 3 new stories (S-E2E-3/4/5). |
| Tests | tests/e2e_live.rs MODIFIED (deepen + add); new always-run unit tests for pure helpers. |
| Verification | E2E tests are the verification artifact. |
| CI | e2e.yml MODIFIED (failure classification); e2e-sweeper.yml NEW. |

## Component Impact Table
| Component | Type | Rationale |
|-----------|------|-----------|
| tests/e2e_live.rs | MODIFIED | M1 deepen assertions; M2 ~7-10 new gated tests; M3 poll_jql + matchers + transient classifier + secret-leak guard + leak log. |
| .github/workflows/e2e.yml | MODIFIED | M3: 401-vs-connection failure classification; optional JR_E2E_POLL_* env. |
| .github/workflows/e2e-sweeper.yml | NEW | M3: daily non-blocking sweeper; concurrency: jira-e2e; close-only. |
| CLAUDE.md (AI agent notes) | MODIFIED | Mandatory co-change: JR_E2E_POLL_* JR_* table entry (doc-fallout rule #335/#357). |
| src/* | DEPENDENT (regression baseline) | error.rs exit codes read-only; bulk.rs exemplar only. NOT modified. |
| tests/issue_view_errors.rs, tests/issue_list_errors.rs | DEPENDENT | Read for exit-code constants; NOT modified. |

## Poll-Budget Seam Verdict
JR_E2E_POLL_* is TEST-LAYER ONLY. Unlike JR_BULK_* (read by the jr binary inside its own async loop, requiring a #[cfg(debug_assertions)] src/ read site), poll_jql is a test-side loop that invokes jr as a subprocess repeatedly; the budget is owned by tests/e2e_live.rs and read via std::env::var there. ZERO src/ change.

## BC Coverage Map (all VERIFIED, none new; ids indicative -- confirm vs BC-INDEX.md in F3)
BC-2.2.028 (list default fields); BC-2.3.032 (issue view raw JSON); BC-2.4.039 (comments); BC-2.5.043-046 (changelog); BC-3.1.003 (assign --me); BC-3.2.001 (single-key move idempotency); BC-3.4.012/013 (edit echo asymmetry #398); BC-3.6.001/004/005 (link/unlink/link-types); BC-5.1.001 (board list); BC-5.2.005 (sprint current); BC-6.2.051 (pagination dedup JRACLOUD-95368); BC-7.1.005 (JSON error shape); BC-7.3.006 (exit-code mapping); BC-X.3.002 (401->exit2); BC-X.5.001 (worklog add); BC-X.6.004 (team list).

## Regression Risk Assessment
| Risk | Level | Detail |
|------|-------|--------|
| test_every_ignored_test_has_gate_guard (always-run meta-guard) | HIGH | Every new #[ignore] test MUST early-return via e2e_enabled() before any live call, or ci.yml fails. |
| always-run gate tests | HIGH | Un-gated live call surfaces immediately in normal cargo test. |
| new pure-helper unit tests | MEDIUM | poll_jql + matchers need their own always-run unit tests. |
| e2e-sweeper.yml concurrency | LOW | Must share concurrency: jira-e2e; close-only (no delete). |
| CLAUDE.md JR_* doc | LOW | JR_E2E_POLL_* documented in same commit as the seam. |
| src/, Cargo.toml, BC count surfaces, ci.yml, release.yml | NONE | Regression baseline. |

## Error-Path Exit-Code Contract (M2)
Implementer MUST read tests/issue_view_errors.rs + tests/issue_list_errors.rs and reuse pinned codes; do NOT invent. From src/error.rs::exit_code(): 404->1 (ApiError), 400 malformed JQL->1 (ApiError; freeform --jql not client-validated), 401 bad auth->2 (NotAuthenticated). Assert exit code + JSON error-field presence only; never message substrings (JRACLOUD-95368 lesson).

## Recommended Story Breakdown (3 stories, 13 SP)
| Story | Scope | SP | Depends on |
|-------|-------|----|-----------|
| S-E2E-3 | M1 + Foundation (poll_jql, matchers, transient classifier, JR_E2E_POLL_* seam, deepen existing test bodies, always-run helper unit tests) | 5 | - |
| S-E2E-4 | M2 (new read/discovery tests; write/behavioral: assign/link/unlink/dry-run/bulk-move/pagination-dedup; error/exit-code paths) | 5 | S-E2E-3 |
| S-E2E-5 | M3 (e2e-sweeper.yml, e2e.yml failure classification, secret-leak guard, leak-detection log, CLAUDE.md JR_E2E_POLL_* docs) | 3 | - |

## Regression Baseline (files NOT changed)
All of src/; Cargo.toml; Cargo.lock; deny.toml; .github/workflows/ci.yml; .github/workflows/release.yml; tests/common/; BC-INDEX.md; CANONICAL-COUNTS.md; tests/issue_view_errors.rs; tests/issue_list_errors.rs.

## Recommended scope for F2-F7
- F2: EMPTY BC delta -- confirm no PRD/BC change; record coverage intent only. Lightweight.
- F3: author S-E2E-3/4/5.
- F4: TDD per story; full regression (1490+/0) as safety net; zero src/.
- F5: scoped adversarial, 3-clean bar (prior E2E F5 caught 6 CRITICALs).
- F6: mutation N/A (zero src/); security scan on new CI workflow (harden-runner allowlist, secret handling).
- F7: delta convergence + full regression validation.

## Open questions for human gate
1. Scope correct (M1+M2+M3, JSM deferred)?
2. 3 stories vs 1 large + follow-up?
3. Confirm zero-src/ acceptable (poll seam stays test-layer)?
