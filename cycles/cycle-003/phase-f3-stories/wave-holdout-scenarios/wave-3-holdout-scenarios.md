---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-003
feature: auth-profile-dx
wave: 3
status: draft
producer: story-writer
created: 2026-09-01
inputs:
  - ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-remove-logout-semantics.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-schedule.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-holdout-scenarios/wave-2-holdout-scenarios.md"
traces_to: "BC-1.2.013; BC-1.2.014"
input-hash: "87e941e"
---

# Wave 3 Holdout Scenarios — `S-cycle3-remove-logout-semantics`

Single-story wave. Cross-story scenarios test integration with Wave 1's namespaced
storage (the 4th delete step's target) and Wave 2's error taxonomy (`logout`'s
non-destructive notice cross-references `credential-absence-guard`'s remediation text).

---

## 1. Cross-Story Integration Scenarios

### H-W3-INT-001 — `auth remove` deletes the namespaced pair Wave 1 created

**Setup:** Profile `doomed` created via `jr auth login doomed --api-token ...` (Wave 1's
`store_api_token`, namespaced keys `doomed:email`/`doomed:api-token` written). Run
`jr auth remove doomed --yes`.

**Expectation:** All 4 delete steps succeed, in the reordered
credentials-before-config-entry sequence (BC-1.2.014): the namespaced api-token pair (new
4th step, added by this story) is deleted alongside the pre-existing OAuth-pair delete
step; the config-file entry is removed LAST. Post-removal, `jr auth login doomed` (fresh)
does not find residual namespaced keys from the prior instance (no leftover credential
from the deleted profile bleeding into a same-named profile created later).

**MUST-PASS.**

### H-W3-INT-002 — `auth logout` on an api-token profile prints the non-destructive notice, references Wave 2's remediation text style

**Setup:** Profile `notify-me` (api-token, per-profile credentials via Wave 1). Run
`jr auth logout notify-me`.

**Expectation:** Exit 0. Stderr carries the informational notice (BC-1.2.013, I-3/SR-015)
explaining that `logout` is non-destructive for api-token profiles (no OAuth session to
invalidate) — worded consistently with Wave 2's BC-1.4.033 remediation-message fix per
the manifest's cross-reference note ("BC-1.2.013's Trace cross-references BC-1.4.033's
SR-009 remediation-message fix"). The namespaced api-token pair remains present and
functional afterward (logout does NOT delete it — that's `remove`'s job, exercised in
H-W3-INT-001).

**MUST-PASS.**

### H-W3-INT-003 — Genuine keychain backend error during `remove` surfaces (not swallowed), leaves config entry intact for retry

**Setup:** Simulate a genuine (non-`NoEntry`) keychain backend error during the
credentials-deletion steps of `jr auth remove <profile> --yes` (e.g. backend locked /
permission denied — via a test double that injects this error class).

**Expectation:** The command aborts with the genuine error surfaced (not
aggregated-and-swallowed, per I-4/SR-008's tightening) — exit reflects a real failure,
NOT exit 0. The config-file entry for `<profile>` is LEFT INTACT (steps 3/4 never ran,
per the reordering — credentials-before-config-entry means a credentials-step failure
never reaches the config-removal step). Re-running `jr auth remove <profile> --yes` after
the transient backend issue clears succeeds cleanly. This is the correctness gap the
step-reordering fix specifically closes (previously, a partial failure could leave a
profile in a bad state).

**MUST-PASS. This is a genuine correctness fix, not cosmetic** — the manifest flags this
exact behavior change as "worth a CHANGELOG entry even though it is framed as a bugfix."

---

## 2. Regression Scenarios — Existing Auth Behavior Preserved

### H-W3-REG-001 — OAuth-profile `remove`/`logout` behavior unchanged

**Setup:** An OAuth-method profile (pre-existing shape, untouched by cycle-003's Wave
1-3 scope for OAuth specifically). Run `jr auth remove <oauth-profile> --yes` and
separately `jr auth logout <oauth-profile>`.

**Expectation:** `remove` still deletes the OAuth token pair (existing branch, unchanged
logic) plus config entry, in the new reordered sequence (credentials-before-config —
this DOES apply to the OAuth branch too, since the reordering is sequence-level not
branch-specific) but with byte-identical OAuth-pair-deletion behavior otherwise. `logout`
still performs its EXISTING destructive behavior for OAuth profiles (token invalidation)
— the new non-destructive notice is SPECIFIC to api-token profiles (or profiles where the
OAuth pair is absent per the intrinsic-mechanism read); it must not suppress or alter
OAuth logout's existing semantics.

**MUST-PASS. Regression-critical** — confirms the api-token-specific notice doesn't leak
into or change the OAuth logout path, which existing users and scripts depend on today.

### H-W3-REG-002 — `clear_all_credentials` (bulk path) tightening doesn't regress multi-profile bulk clear

**Setup:** 3 profiles (`p1`, `p2`, `p3`), mixed OAuth/api-token, all with valid
credentials. Exercise `clear_all_credentials([p1, p2, p3])` (the bulk internal helper —
via whatever command path invokes it, e.g. a full config reset flow if one exists, or a
direct unit-level test if no CLI command exposes it directly).

**Expectation:** Each profile's per-kind credentials (OAuth pair where present,
namespaced api-token pair where present — this story's new addition) are cleared
correctly; genuine keychain errors on any one profile propagate rather than being
aggregated-and-swallowed (same I-4/SR-008 tightening applied at the bulk level), without
an unconditional legacy-flat-key clear being introduced (explicitly out of scope per this
story's File Structure Requirements: "do NOT add an unconditional legacy-flat-key
clear").

**MUST-PASS.**

---

## 3. Summary

| ID | Type | Priority |
|---|---|---|
| H-W3-INT-001 | cross-story integration (with Wave 1) | MUST-PASS |
| H-W3-INT-002 | cross-story integration (with Wave 2 message-style consistency) | MUST-PASS |
| H-W3-INT-003 | cross-story integration (reordering correctness, genuine-error surfacing) | MUST-PASS |
| H-W3-REG-001 | regression (OAuth remove/logout unchanged) | MUST-PASS, regression-critical |
| H-W3-REG-002 | regression (bulk clear tightening, no legacy-key clear) | MUST-PASS |

5 scenarios.
