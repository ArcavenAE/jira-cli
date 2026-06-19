---
document_type: adversarial-review
phase: F5
pass: 1
bundle: S-FORK-OPS-BACKFILL
date: 2026-06-19
verdict: FINDINGS
novelty: 0.35
converged: false
findings_crit: 0
findings_high: 0
findings_med: 2
findings_low: 4
reviewer: vsdd-factory:adversary
---

# F5 Pass 1 — S-FORK-OPS-BACKFILL Scoped Adversarial Review

**Date:** 2026-06-19
**Verdict:** FINDINGS (novelty 0.35)
**Scope:** Combined delta — backfill-release.yml (S-FORK-OPS-BACKFILL-1, PR #539) + GITLEAKS_DISABLED doc changes (S-FORK-OPS-GITLEAKS-DOC-1, PR #538). Wave-gate adversarial consolidated into F5 (no double-adversarial).
**develop HEAD reviewed:** f85647b

---

## Summary

0 CRIT, 0 HIGH, 2 actionable MEDIUM, 4 LOW.

2 actionable MEDIUM findings:

- **M2** (latent coupling): `gh release upload jr-*.zip` hard-fails on zero-match glob. This is a deliberate fail-loud design that diverges from release.yml which uses softprops/action-gh-release (no glob-fail behavior). ACCEPTED — the fail-loud behavior is correct (zero Windows binaries is a genuine error); guarded by `needs: build` + matrix-parity test ensures build succeeded first.
- **M4** (test quality): `test_backfill_release_job_zip_in_both_upsert_branches` counted `jr-*.zip` appearances ≥2 anywhere in the file instead of anchoring the assertion to distinct branches. A single branch with two references would have passed vacuously. FIXED via FIX-F5-001 / PR #540.

4 LOW findings:

- **O1** (observation): `backfill-release.yml` upsert bash uses `set -euo pipefail` correctly; exit-code propagation confirmed.
- **O2** (observation): CWE-77 env-binding confirmed at all `inputs.tag` sites — pattern matches release.yml treatment.
- **O3** (process-gap): F5 checklist conflates `--self-test` inline fixture with real-file scan. Wording could mislead a future reviewer into thinking the fixture file IS the artifact under test. TRACKED as drift item FORK-OPS-F5-SELFTEST-CHECKLIST.
- **O4** (observation): WIN-TARGET steps byte-faithful to release.yml — confirmed.

---

## Positive Parity Confirmations

- All 11 tests non-vacuous (basis confirmed).
- GITLEAKS_DISABLED doc change exact-match to ci.yml:145 — confirmed.
- Draft/prerelease invariants in upsert logic correct.
- `shell: bash` present on all multi-line run steps.
- `needs: build` dependency chain correct.

---

## Disposition

| ID | Severity | Finding | Disposition |
|----|----------|---------|-------------|
| M2 | MEDIUM | `jr-*.zip` glob hard-fail coupling | ACCEPTED — fail-loud, guarded by needs:build + matrix-parity test |
| M4 | MEDIUM | Test non-anchored zip-branch assertion | FIXED via FIX-F5-001 / PR #540 |
| O1 | LOW | upsert bash set -euo pipefail confirmed | POSITIVE CONFIRMATION |
| O2 | LOW | CWE-77 env-binding confirmed | POSITIVE CONFIRMATION |
| O3 | LOW | F5 checklist --self-test/real-file conflation | TRACKED (drift item) |
| O4 | LOW | WIN-TARGET steps byte-faithful | POSITIVE CONFIRMATION |
