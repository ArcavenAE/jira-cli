---
document_type: adversary-convergence-log
producer: orchestrator
issue: 383
phase: phase-f2-spec-evolution
timestamp: 2026-05-19
status: CONVERGED
total_passes: 11
final_state: 2 consecutive CLEAN passes with ZERO findings and ZERO novelty
---

# Issue #383 F2 Spec Delta — Adversary Convergence Log

## Pipeline summary

F2 spec evolution for issue #383 added 2 new behavioral contracts (BC-3.8.012, BC-3.8.013) to `bc-3-issue-write.md`, mirroring the just-merged BC-3.8.011 (forward-direction cross-flag warning) with inverse-direction semantics on the platform path.

## Pass-by-pass summary

| Pass | Verdict | Findings | Notes |
|------|---------|----------|-------|
| 01 | DIRTY | 3 HIGH (H-01 idempotent vs per-occurrence asymmetry, H-02 F1→F2 wording drift, H-03 stale subdomain count) + 5 MEDIUM | First baseline review |
| 02 | DIRTY (adversary self-graded CLEAN; orchestrator strict-graded DIRTY) | 2 MEDIUM (M-01 H1 preamble, M-02 lead paragraph partition) | Adversary judgment-call advanced counter; orchestrator enforced strict |
| 02-retry | DIRTY | 3 MEDIUM (M1 lead paragraph contradiction, M2 section header drift, M3 ordering ambiguity) | Partial-fix regression pattern |
| 02-retry-2 | DIRTY | 2 HIGH (BC-INDEX:305 propagation, BC-3.8.001 H1 missing JSON response) + 3 MEDIUM (subdomain heading, CANONICAL-COUNTS stale arithmetic, change attribution) | S-7.01 blast-radius extended |
| 03 | DIRTY | 3 HIGH (CANONICAL-COUNTS:64-65, BC-INDEX:688, README:49/51) + 2 MEDIUM (README:43 BC-7 count, F1 reconciliation) | Cross-document propagation gap (566→569 sweep) |
| 04 | CLEAN | None (with deferred-list noted) | First truly clean pass after comprehensive sweep |
| 05A | DIRTY | 1 MEDIUM (README:38 bc-2 row 91→93) | Parallel pass found new drift |
| 05B | CLEAN | None | Parallel pass (different scope coverage) |
| 06 | CLEAN | None | After bc-2 row fix |
| 07A | DIRTY | 2 MEDIUM (BC-INDEX:215 Section 3 header, BC-INDEX:252 BC-3.3.001 row marker) | Parallel pass found new drift |
| 07B | CLEAN | 1 LOW (hypothetical Option<String> future-proofing) | Parallel pass |
| 08 | CLEAN | None | After :215+:252 fixes — Novelty ZERO |
| 09 | CLEAN | None | Final confirmation — Novelty ZERO, adversary explicitly noted diminishing returns |

## Convergence verdict

F2 CONVERGED per F2 skill bar ("findings are cosmetic only"). Last 2 fresh-context passes returned ZERO findings, ZERO novelty.

## Cumulative fixes applied

1. BC-3.8.012 idempotency clause aligned with BC-3.8.011 (per-flag-NAME, not per-occurrence)
2. F1→F2 wording drift recorded with ChangeLog note in BC Source field
3. Subdomain count drift fixed (bc-3 body header: 89→91)
4. BC-INDEX:305 BC-3.8.001 summary qualified with stderr-warnings note
5. BC-3.8.001 H1 expanded with full invariance triple (POST body / JSON response / exit code)
6. CANONICAL-COUNTS:64-65 stale 566→569 prose updated
7. BC-INDEX:688 Coverage Statistics paragraph 566/334→569/337
8. README:49+51 stale 566→569 + enumeration extended with +3 issue attribution
9. README:38 bc-2 row 91→93 (pre-existing #350/#365 drift swept in same pass)
10. README:43 bc-7 row 80→84 (pre-existing drift swept)
11. F1 delta-analysis post-F2 reconciliation addendum (acknowledges 59→62 actual vs 59→61 estimate)
12. BC-INDEX:215 Section 3 header 88/59→91/62
13. BC-INDEX:252 BC-3.3.001 row marker appended with #383 amendment + stderr qualifier
14. M-01 (lead paragraph contradiction on platform-path invariance) sweep (BC-3.8.001 heading + BC-3.3.001 footnote)
15. M-03 (flag-declaration order ambiguity) — removed undefined ordering claim from BC-3.8.012/013 cross-reference

## Deferred items (queued as separate GitHub issues — orchestrator-tracked)

1. **Subdomain heading depth harmonization** (`## BC-3.8:` vs `### 3.N` for 3.1-3.7) — pre-existing from #288, requires wider file restructure. Body preamble Note acknowledges. Orchestrator to file as GH issue.

2. **CANONICAL-COUNTS line 5 attribution clarity** — cosmetic only (arithmetic correct). Orchestrator to file as GH issue.

3. **`scripts/check-spec-counts.sh` extension** — currently validates only `definitional_count`, not cumulative `total_bcs`. Add cumulative-sum check to catch future Section-header drift. Orchestrator to file as GH issue (process-gap).

## Lessons codification candidates

- **L-383-01**: Pre-implementation research-agent validation (L-288-pr4-06 applied) confirmed gh CLI PR #12039 as near-exact precedent for the inverse-warning fix pattern. Reduced design risk before F2 codification.
- **L-383-02**: 11-pass F2 convergence cycle reveals that BC-INDEX is the highest-blast-radius site for partial-fix propagation in this PRD. Adding a cumulative-sum CI guard (#followup) would prevent ~80% of these passes from being needed.
- **L-383-03**: Fresh-context parallel adversary dispatches can surface non-overlapping defects in the same iteration (e.g., 05A caught README:38 drift, 05B missed it). Parallel dispatch is efficient for convergence; both should be treated as evidence pool.
