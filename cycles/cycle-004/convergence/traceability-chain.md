---
document_type: cycle-traceability-chain
cycle: cycle-004
bundle: windows-correctness
status: appended-only — this file accumulates one section per bundle/phase pass; never replaced wholesale
producer: state-manager
---

# cycle-004 Master Traceability Chain

This file did not exist prior to the `windows-correctness` Phase F7 convergence-prep pass
(2026-09-05); it is created here per the DF-030 lifecycle convention
(`cycles/<cycle>/convergence/` holds per-cycle convergence artifacts) and is intended to
accumulate one appended section per bundle/phase pass processed under cycle-004, never
replaced wholesale. The full per-BC detail lives in the bundle-prefixed file under
`.factory/phase-f7-convergence/cycle-004/traceability-chain-delta.md`; this master file
cross-links to that without duplicating its full content.

---

## windows-correctness (GitHub #759 + #760 + A-PA-LOW-001) — appended 2026-09-05, Phase F7

Full 4-level chain (BC -> VP -> test -> src) for the 4 cycle-004 stories:
**`.factory/phase-f7-convergence/cycle-004/traceability-chain-delta.md`**

**Stories (4):** `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`),
`S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`), `S-cycle4-windows-docs`
(PR #770 @ `abb283e8`), `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`).

**Fix-PRs (4):** #772 @ `e5a18fe0` (Wave 2 integration gate README findings), #773 @
`f3863f07` + #774 @ `3b62cefa` (F5 scoped-adversarial fix rounds, LOWs), #775 @ `024de4d8`
(F6 mutation — `tenant.rs` body-cap survivors + examine_globs).

**Key BCs:** BC-1.4.035, BC-1.4.036, BC-1.4.037, BC-1.4.038, BC-1.4.040, BC-1.4.028
(re-verified) — `S-cycle4-dpapi-storage-fix`; BC-1.2.052, BC-1.2.053, BC-1.2.054
(confirmed-unchanged) — `S-cycle4-cloud-id-correctness`; BC-1.4.039 (amended mid-story,
DEC-334) — `S-cycle4-honest-fail-message`; none (docs-only) — `S-cycle4-windows-docs`.

**Key VPs:** VP-AUTHDX-010..016, VP-AUTHDX-018, VP-AUTHDX-022 (dpapi-storage-fix);
VP-AUTHDX-019..021 (cloud-id-correctness); VP-AUTHDX-017 (honest-fail-message). Spec:
BC 733→742, VP 41→55.

**Key cross-references** (full detail in the bundle-prefixed file above):
- `S-cycle4-*` stories extend the existing cycle-003 `auth-profile-dx` credential-storage
  and profile-config BCs — same BC-1 auth/identity domain capability, no new domain
  capability introduced this cycle.
- BC-1.2.052..054 depend_on the existing `cloud_id`/`base_url` BCs
  (`Config::base_url()` gateway guard, `assets_base_url` computation).
- `S-cycle4-honest-fail-message` depends_on `[S-cycle4-dpapi-storage-fix]` (shares
  `DpapiFallbackFailed`/`ProfilePathEscape` error types).
- `S-cycle4-windows-docs` depends_on `[S-cycle4-cloud-id-correctness]` (README `cloud_id`
  caveat text must match the shipped soft-fail contract, not the pre-fix framing).

`develop` tip at time of this pass: `024de4d8` (base `v0.7.0-dev.4`). Convergence report:
`.factory/phase-f7-convergence/cycle-004/delta-convergence-report.md`.
