---
document_type: f5-convergence-summary
phase: F5
bundle: S-FORK-OPS-BACKFILL
date: 2026-06-19
converged: true
passes: 3
develop_head_at_convergence: 83a141ad
fix_prs: ["#540 (FIX-F5-001)"]
---

# F5 Convergence Summary — S-FORK-OPS-BACKFILL

**Date:** 2026-06-19
**Result:** CONVERGED — 3 passes
**develop HEAD at convergence:** 83a141ad

---

## Finding Progression

| Pass | Verdict | Novelty | CRIT | HIGH | MED | LOW | Action |
|------|---------|---------|------|------|-----|-----|--------|
| 1 | FINDINGS | 0.35 | 0 | 0 | 2 | 4 | M4 FIXED via FIX-F5-001/PR #540; M2 ACCEPTED |
| 2 | CLEAN | 0.08 | 0 | 0 | 1* | 8 | *O-1 = recurrence of accepted M2; no action |
| 3 | CLEAN, CONVERGED | LOW | 0 | 0 | 0 | 1 | L-NEW-1 tracked as FORK-OPS-BACKFILL-TIMEOUT-PARITY |

Trajectory: `2→0→0` (actionable MED). CONVERGED at Pass 3.

---

## Key Actions Taken

| ID | Finding | Action | PR/Commit |
|----|---------|--------|-----------|
| M4 | Test `test_backfill_release_job_zip_in_both_upsert_branches` counted `jr-*.zip` ≥2 anywhere instead of anchoring to distinct branches — vacuous assertion | FIXED | FIX-F5-001 / PR #540 @ develop 83a141ad |
| M2 | `gh release upload jr-*.zip` hard-fails on zero-match glob; diverges from release.yml softprops behavior | ACCEPTED — fail-loud design; guarded by needs:build + matrix-parity test | — |

---

## Tracked Items (no action required for F5 gate)

| ID | Description | Drift Item |
|----|-------------|-----------|
| O3 | F5 checklist conflates `--self-test` inline fixture with real-file scan | FORK-OPS-F5-SELFTEST-CHECKLIST |
| L-NEW-1 | backfill build job lacks `timeout-minutes` (release.yml=60) | FORK-OPS-BACKFILL-TIMEOUT-PARITY |
| M2/O-1 | zip-glob hard-fail coupling (accepted) | FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING |

---

## Notes

- Wave-gate combined-diff adversarial was consolidated into F5. No separate wave-gate adversarial pass was run. This is per the F3 planning decision (see STATE.md RESUME PLAN Step 3).
- F5 input scope: `backfill-release.yml` changes (PR #539) + `GITLEAKS_DISABLED` doc changes (PR #538). Both were squash-merged to develop on 2026-06-19 before F5 began.
- develop now at 83a141ad (post FIX-F5-001/PR #540).

---

## Next Phase

**F6 — Formal Hardening** (targeted; CI-only bundle, no complex logic; likely light pass).
