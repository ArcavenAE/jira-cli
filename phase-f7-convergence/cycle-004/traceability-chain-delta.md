---
document_type: traceability-chain-delta
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
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-dpapi-storage-fix.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-cloud-id-correctness.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-windows-docs.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-honest-fail-message.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
input-hash: "4073b1c"
traces_to: ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md; .factory/phase-f7-convergence/cycle-004/consistency-audit.md"
---

# Traceability Chain Delta — `windows-correctness` (cycle-004)

## Chain shape

```
BC-1.4.035..040 / BC-1.2.052..054 -> VP-AUTHDX-010..023 -> tests -> src -> PR#/commit
  -> F5-ADV-CONVERGED (0 CRIT/HIGH/MED) -> F6 (mutation + Kani/fuzz-substitution + security)
```

`F5-ADV-CONVERGED` = 3 fresh F5 scoped-adversarial passes + cross-model secondary, 0
CRIT/HIGH/MED, converged via fix rounds PR #773 + PR #774 (DEC-340). `F6(...)` cites the
mutation/security verdict from `.factory/phase-f6-hardening/cycle-004/summary.md` (DEC-341).

## Cross-references

- `S-cycle4-*` stories **extend** the existing cycle-003 `auth-profile-dx` stories
  (`S-cycle3-percred-storage`, `S-cycle3-chosen-flow-reconcile`, etc.) — same BC-1
  auth/identity domain capability, no new domain capability introduced this cycle.
- `BC-1.2.052..054` **depend_on** the pre-existing `cloud_id`/`base_url` BCs
  (`Config::base_url()`'s `auth_method == "oauth"` gateway guard, `assets_base_url`'s
  `cloud_id`-only computation) — BC-1.2.054 is CONFIRMED-UNCHANGED, not new behavior, just
  a regression-pin closing the acquisition half of A-PA-LOW-001 alongside BC-1.2.052/053.
- `BC-1.4.035..040` **extend** the existing `BC-1.4.02x`-series credential-storage BCs
  (`store_api_token`/`load_api_token`, per-profile namespacing) with the DPAPI-fallback
  envelope for oversized OAuth tokens (ADR-0021) — `S-cycle4-dpapi-storage-fix` additionally
  cites the pre-existing `BC-1.4.028` directly (unchanged, re-verified).
- `S-cycle4-honest-fail-message` **depends_on** `[S-cycle4-dpapi-storage-fix]` (reuses the
  `DpapiFallbackFailed`/`ProfilePathEscape` error types it defines).
- `S-cycle4-windows-docs` **depends_on** `[S-cycle4-cloud-id-correctness]` (its AC-004
  `cloud_id` caveat text must match the exact fetch/override/soft-fail contract
  BC-1.2.052/053 define — not the pre-fix "OAuth-only" framing).

---

## 1. `S-cycle4-dpapi-storage-fix` (PR #768 @ `9119b291`)

| Field | Value |
|---|---|
| BCs | BC-1.4.035 (NEW), BC-1.4.036 (NEW), BC-1.4.037 (NEW), BC-1.4.038 (NEW), BC-1.4.040 (NEW), BC-1.4.028 (pre-existing, re-verified unchanged) |
| VPs | VP-AUTHDX-010, VP-AUTHDX-011, VP-AUTHDX-012, VP-AUTHDX-013, VP-AUTHDX-014, VP-AUTHDX-015, VP-AUTHDX-016, VP-AUTHDX-018, VP-AUTHDX-022 |
| test | `src/api/auth.rs` (inline unit + proptests), `src/api/auth_windows_store.rs` (inline unit tests), keyring-gated integration companions |
| src | `src/api/auth.rs` (`store_oauth_tokens` TooLong-routing, `engage_dpapi_fallback`), `src/api/auth_windows_store.rs` (DPAPI-encrypted-file envelope, `ProfilePathEscape` guard, `load_pair`) |
| PR/commit | PR #768 @ `9119b291` |
| F5 | ADV-CONVERGED (0 CRIT/HIGH/MED, PR #773/#774 fix rounds) |
| F6 | Mutation: `tenant.rs`-adjacent surface 97-100% on default-CI-testable surface; sub-90% raw rates traced to spec-declared keyring-gated (VP-005/006/007) boundaries. Kani/fuzz: JUSTIFIED SKIP (proptest substitution, 0 GAP) |

## 2. `S-cycle4-cloud-id-correctness` (PR #769 @ `c2074247`)

| Field | Value |
|---|---|
| BCs | BC-1.2.052 (NEW), BC-1.2.053 (NEW), BC-1.2.054 (CONFIRMED-UNCHANGED) |
| VPs | VP-AUTHDX-019, VP-AUTHDX-020, VP-AUTHDX-021 |
| test | `src/api/jira/tenant.rs` (inline unit tests, 100% mutation-killed via FIX-F6-1), `tests/cloud_id_tenant_info.rs` (15 tests, 3 keyring-gated `#[ignore]`) |
| src | `src/api/jira/tenant.rs::fetch_cloud_id` (NEW), `src/cli/auth/login.rs::login_token` (`cloud_id_override` param + fallback chain), `src/config.rs::base_url()`/`assets_base_url` (BC-1.2.054 regression-pin only) |
| PR/commit | PR #769 @ `c2074247` |
| F5 | ADV-CONVERGED |
| F6 | Mutation: `tenant.rs` 21/21 (100%) via FIX-F6-1 (PR #775). Kani/fuzz: JUSTIFIED SKIP (proptest substitution — `tenant_info` parse + body-cap, 0 uncovered input surface) |

## 3. `S-cycle4-windows-docs` (PR #770 @ `abb283e8`) + FIX PR #772 @ `e5a18fe0`

| Field | Value |
|---|---|
| BCs | none — documentation-only story (#760); no `src/` code changes |
| VPs | none |
| test | N/A (docs-content assertions, not BC-backed) |
| src | `README.md` (Windows install steps, config/cache path table, `cloud_id` caveat — corrected to match BC-1.2.052/053's shipped soft-fail contract, not the pre-fix "OAuth-only" framing) |
| PR/commit | PR #770 @ `abb283e8`; Wave 2 integration gate found 3 README findings, fixed via FIX PR #772 @ `e5a18fe0` |
| F5 | ADV-CONVERGED (no BC surface; reviewed for doc/shipped-behavior accuracy) |
| F6 | N/A — no code delta to harden |

## 4. `S-cycle4-honest-fail-message` (PR #771 @ `281ba272`)

| Field | Value |
|---|---|
| BCs | BC-1.4.039 (NEW; amended mid-story per DEC-334 account-wide-revoke correction, spec-synced via commit `99443bfa`) |
| VPs | VP-AUTHDX-017 |
| test | `src/api/auth.rs` inline unit tests (Site 1 / Site 3 branch coverage, `ProfilePathEscape` vs `DpapiFallbackFailed` ordering, AC-005 isolation test) |
| src | `src/api/auth.rs` (`oauth_login` Site 1, `refresh_oauth_token_with_url` Site 3 — distinct message text per site; Site 3 proactively clears stale stored pair) |
| PR/commit | PR #771 @ `281ba272`; message-text correction landed via `6cea4146`/`b2a0c5d7` (this session's own commits, spec-sync `99443bfa`) |
| F5 | ADV-CONVERGED (BC-1.4.039 stale-message-quote Major finding fixed by product-owner, `99443bfa`) |
| F6 | Mutation: covered under the dpapi-storage-fix `auth.rs` surface above. Kani/fuzz: JUSTIFIED SKIP |

## Fix-PRs (in-cycle, not story deliveries)

| Fix PR | Scope | Commit |
|---|---|---|
| #772 | Wave 2 integration gate README findings (3) | `e5a18fe0` |
| #773 | F5 scoped-adversarial fix round 1 (LOWs) | `f3863f07` |
| #774 | F5 scoped-adversarial fix round 2 (LOWs) | `3b62cefa` |
| #775 | F6 mutation — `tenant.rs` 5 body-cap-boundary survivors killed + added to examine_globs | `024de4d8` |

`develop` tip at time of this pass: `024de4d8` (`v0.7.0-dev.4` base). Convergence report:
`.factory/phase-f7-convergence/cycle-004/delta-convergence-report.md`.
