---
document_type: delta-convergence-report
level: ops
version: "1.0"
status: final
producer: state-manager
phase: phase-f7-convergence
cycle: cycle-004
feature: windows-correctness
branch: develop
baseline_commit: 42e92b46
head_commit: 024de4d8
inputs:
  - ".factory/phase-f7-convergence/cycle-004/consistency-audit.md"
  - ".factory/phase-f7-convergence/cycle-004/holdout-eval.md"
  - ".factory/phase-f7-convergence/cycle-004/input-hash-drift.md"
  - ".factory/phase-f6-hardening/cycle-004/summary.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
input-hash: "c9fc7ef"
traces_to: ".factory/phase-f7-convergence/cycle-004/consistency-audit.md; .factory/phase-f7-convergence/cycle-004/holdout-eval.md; .factory/phase-f6-hardening/cycle-004/summary.md; .factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
---

# Delta Convergence Report — cycle-004 (windows-correctness)

## Feature Summary

- Bundle: GitHub #759 (Windows DPAPI-encrypted-file fallback for oversized OAuth tokens) +
  #760 (Windows docs) + cloud_id-correctness (A-PA-LOW-001) + honest-fail messages.
  Spec: BC 733→742, VP 41→55.
- Stories: `S-cycle4-dpapi-storage-fix`, `S-cycle4-cloud-id-correctness`,
  `S-cycle4-windows-docs`, `S-cycle4-honest-fail-message` (all merged: PRs #768/#769/#770/#771)
  + in-cycle fix PRs #772 (README consistency), #773/#774 (F5 LOWs), #775 (F6 mutation).
  `develop` @ `024de4d8`.

## Five-Dimensional Convergence (Delta)

| Dimension | Metric | Target | Actual | Status |
|-----------|--------|--------|--------|--------|
| 1 Spec | adversary novelty | <0.15 | LOW; 0 CRIT/HIGH/MED across 3 fresh F5 passes + cross-model secondary; BC-1.4.039 spec-sync landed (`99443bfa`) | PASS |
| 2 Test | mutation kill rate | >=90% | 97-100% on default-CI-testable surface; `tenant.rs` 100%; boundary survivors are spec-declared keyring-gated/Windows-cfg only | PASS |
| 3 Impl | findings / verification rate | no CRIT/HIGH; <60% | 0 CRIT/HIGH/MED open | PASS |
| 4 Verification | proofs+fuzz+audit | all pass | VP 0-GAP (14 VPs); Kani+fuzz justified-skip (proptest substitution); security CLEAN (no CRIT/HIGH), `cargo audit`/`cargo deny` clean | PASS |
| 5 Holdout | satisfaction | >=0.85 | 0.95 mean (12/13 evaluable; must-pass min 0.90); 1 real-DPAPI scenario deferred to the REQUIRED Windows-11 manual gate | PASS-WITH-WINDOWS-DEFERRAL |

## Regression Validation

Full suite GREEN — CI 3-OS matrix (all PRs) + local 4900+/0. Zero regressions vs F4 baseline.

## Consistency

CONSISTENT — F7 pre-gate audit found 1 Major spec-only drift (BC-1.4.039 stale message quote),
FIXED (product-owner, commit `99443bfa`). Counts 742/55/106/172 all agree.

## Input-hash

No gate-blocking drift: 9 cycle-004 real-hash artifacts recomputed (this burst); 165
factory-wide standing pool = documented non-blocker
(`F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING`).

## Cost-Benefit (DF-027)

MAXIMUM_VIABLE_REFINEMENT: 0 CRIT/HIGH/MED across many independent passes; residuals are
documented LOW/by-design/unreachable; P(finding next iteration)*value < cost*1.5. Further
automated iteration has low expected value — matches cycle-002/003 close pattern.

## Recommendation

READY FOR MERGE/RELEASE — CONTINGENT on two HUMAN gate items: (1) the REQUIRED manual
Windows-11 smoke test (reproduce #759 on real Windows 11: oversized-OAuth-token login
exercises the DPAPI-encrypted-file fallback + round-trip; H-W1-WIN-001 + the DPAPI legs of
H-W1-INT-001/002 & H-W2-INT-001); (2) final human F7 convergence authorization. All
automated dimensions PASS.
