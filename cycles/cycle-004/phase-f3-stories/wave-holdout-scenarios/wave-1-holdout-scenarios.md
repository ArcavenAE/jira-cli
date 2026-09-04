---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-004
feature: windows-correctness
wave: 1
status: draft
producer: story-writer
created: 2026-09-04
inputs:
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-dpapi-storage-fix.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-cloud-id-correctness.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/wave-schedule.md"
traces_to: "BC-1.4.035; BC-1.4.036; BC-1.4.037; BC-1.4.038; BC-1.4.040; BC-1.4.028; BC-1.2.052; BC-1.2.053; BC-1.2.054"
input-hash: "0be69d9"
---

# Wave 1 Holdout Scenarios — `S-cycle4-dpapi-storage-fix` + `S-cycle4-cloud-id-correctness`

Two file-disjoint stories running in parallel. "Cross-story integration" here means
confirming the two stories' independent changes to `src/api/auth.rs`-adjacent surfaces
and `src/cli/auth/*`-adjacent surfaces do not interact in an unintended way when both land
in the same wave, plus regression scenarios against the cycle-003 `auth-profile-dx` work
both stories build on top of.

---

## 1. Cross-Story Integration Scenarios

### H-W1-INT-001 — A Windows profile with an oversized OAuth token AND a fresh API-token profile coexist cleanly

**Setup:** Two profiles on the same `jr` install: `winoauth` (authenticates via
`jr auth login --oauth`, default 8-scope set, oversized token that triggers the DPAPI
fallback) and `apitoken` (authenticates via `jr auth login --api-token`, triggering the
new `tenant_info` fetch).

**Expectation:** `winoauth`'s credentials land in the DPAPI-encrypted file
(`%LOCALAPPDATA%\jr\secrets\winoauth\oauth-tokens.dat`); `apitoken`'s `cloud_id` is
acquired and persisted in `config.toml`. Neither profile's storage mechanism interferes
with the other — `jr auth status --profile winoauth` and `jr auth status --profile
apitoken` both report correctly, and `jr issue list --profile apitoken` (Assets-unrelated)
succeeds regardless of `winoauth`'s DPAPI state.

**MUST-PASS.**

### H-W1-INT-002 — `jr init`'s picker exercises both stories' new logic in one flow

**Setup:** `jr init` on a fresh Windows install, choosing OAuth for the flow (triggering
`S-cycle4-dpapi-storage-fix`'s routing on an oversized token) — then, in a SEPARATE `jr
init` run for a second profile, choosing API-token (triggering
`S-cycle4-cloud-id-correctness`'s `tenant_info` fetch).

**Expectation:** Both flows complete successfully and independently; `jr init`'s dispatch
logic correctly routes to `login_oauth`/`login_token` respectively, with each function's
own new behavior (DPAPI fallback; `cloud_id` fetch) engaging only on its own path.

**MUST-PASS.**

---

## 2. Regression Scenarios — Existing Auth Behavior Preserved

### H-W1-REG-001 — macOS/Linux OAuth login byte-for-byte unchanged (BC-1.4.035 Invariant 3)

**Setup:** Run `store_oauth_tokens`'s FULL existing pre-cycle-004 test suite (not a
subset) on a macOS/Linux release build.

**Expectation:** 100% pass, zero modifications needed to any existing test. A mocked
`keyring::Error::TooLong` on this build renders the LEGACY "Unlock your keychain" message
(not yet even reachable — `S-cycle4-honest-fail-message` hasn't landed in this wave —
but the underlying `store_oauth_tokens` routing must still propagate the raw `TooLong`
error unchanged, per BC-1.4.035 Postcondition 4/Invariant 3).

**MUST-PASS. Regression-critical.**

### H-W1-REG-002 — cycle-003 per-profile credential storage untouched

**Setup:** Run `tests/auth_profiles.rs`, `tests/api_token_percred_wiring.rs`, and
`tests/auth_chosen_flow_reconcile.rs`'s FULL existing (pre-cycle-004) test suites.

**Expectation:** 100% pass. `S-cycle4-dpapi-storage-fix` extends (does not replace)
`load_oauth_tokens`'s existing namespaced-key and legacy-flat-key logic; `S-cycle4-cloud-id-correctness`
extends (does not replace) `login_token`'s existing credential-write logic. Neither story
touches `store_api_token`/`load_api_token` (cycle-003's per-profile API-token functions).

**MUST-PASS. Regression-critical.**

### H-W1-REG-003 — `Config::base_url()`/`assets_base_url` unchanged (BC-1.2.054 regression pin)

**Setup:** Run the new `proptest` from `S-cycle4-cloud-id-correctness`'s AC-009 against
the CURRENT (pre-this-story) `src/config.rs::base_url`/`src/api/client.rs`'s
`assets_base_url` computation.

**Expectation:** The property test PASSES against the unmodified functions — confirming
this story adds a regression pin on already-correct behavior, not a behavior change. If
this test fails against the CURRENT code, that is a sign the AC-009 pin was written
against a misunderstanding of the existing logic, not a real defect to fix.

**MUST-PASS. Regression-critical — this is a pin-correctness check, not a
behavior-change check.**

### H-W1-REG-004 — `refresh_credentials`'s relogin-then-replace invariant preserved (DEC-321)

**Setup:** Trigger `jr auth refresh` on both an OAuth profile (exercising
`S-cycle4-dpapi-storage-fix`'s routing indirectly, via `refresh_oauth_token_with_url`) and
an API-token profile (exercising `S-cycle4-cloud-id-correctness`'s new `tenant_info` fetch
on every refresh, per BC-1.2.052 Invariant 3) — for each, simulate a failure partway
through (network error mid-refresh for OAuth; `tenant_info` fetch failure for API-token).

**Expectation:** In BOTH cases, the existing credential is NEVER destroyed before a
replacement is confirmed (DEC-321) — a failed OAuth refresh leaves the OLD pair intact
(the new atomic dual-write in `S-cycle4-dpapi-storage-fix` reinforces, not weakens, this);
a failed `tenant_info` fetch on an API-token refresh leaves the prior `cloud_id` untouched
(BC-1.2.052 Postcondition 3), never a bare clear.

**MUST-PASS. Regression-critical — this is the exact invariant DEC-321 exists to
protect, now exercised by two independent new code paths in the same wave.**

---

## 3. Windows-Only / Keyring-Gated Scenarios (not runnable in default CI, recorded for
   completeness)

### H-W1-WIN-001 — Real DPAPI round-trip on Windows CI or manual smoke test

**Setup:** Per `S-cycle4-dpapi-storage-fix`'s "Windows Validation" section — the F4 CI
spike (does `windows-latest` exercise `CryptProtectData` headlessly?) and/or the required
F7 manual Windows smoke test.

**Expectation:** `jr auth login --oauth` with the default 8-scope set succeeds on real
Windows 11, with the token persisting via the DPAPI fallback and a subsequent
`jr auth status`/API call succeeding.

**DEFERRED to F4 spike / F7 manual gate — NOT a Wave-1 CI gate item**, per DEC-335.

---

## 4. Summary

| ID | Type | Priority |
|---|---|---|
| H-W1-INT-001 | cross-story integration | MUST-PASS |
| H-W1-INT-002 | cross-story integration | MUST-PASS |
| H-W1-REG-001 | regression (macOS/Linux byte-for-byte unchanged) | MUST-PASS, regression-critical |
| H-W1-REG-002 | regression (cycle-003 per-profile storage untouched) | MUST-PASS, regression-critical |
| H-W1-REG-003 | regression (base_url/assets_base_url pin correctness) | MUST-PASS, regression-critical |
| H-W1-REG-004 | regression (DEC-321 relogin-then-replace) | MUST-PASS, regression-critical |
| H-W1-WIN-001 | Windows-only / manual | DEFERRED to F4/F7, not a Wave-1 CI gate |

6 CI-gated scenarios + 1 deferred Windows-only scenario recorded for completeness.
