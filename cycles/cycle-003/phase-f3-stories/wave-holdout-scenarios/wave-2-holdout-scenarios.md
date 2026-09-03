---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-003
feature: auth-profile-dx
wave: 2
status: draft
producer: story-writer
created: 2026-09-01
inputs:
  - ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-credential-absence-guard.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-schedule.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-holdout-scenarios/wave-1-holdout-scenarios.md"
traces_to: "BC-1.4.032; BC-1.4.033; BC-1.4.034; BC-1.4.025; BC-1.4.029"
input-hash: "a8df1a8"
---

# Wave 2 Holdout Scenarios — `S-cycle3-credential-absence-guard`

Single-story wave, flagged HIGH-RISK by the decomposition manifest: the cycle's only
MANDATORY keyring-gated end-to-end VP (VP-AUTHDX-007), the one-time breaking-change
contract (BC-1.4.034), and a MUST-NOT-TOUCH regression discipline against
`load_oauth_tokens`. Because it's a single-story wave, "cross-story integration" here
means integration with Wave 1's `percred-storage` (the namespaced reader/writer this
story's guard sits directly on top of) — the closest analog to cross-story coupling
available within a 1-story wave.

---

## 1. Cross-Story Integration Scenarios (with Wave 1)

### H-W2-INT-001 — Detect-and-instruct fires correctly against Wave 1's namespaced storage shape

**Setup:** A profile `fresh` created via `jr auth login fresh --api-token ...` (Wave 1's
`store_api_token`, namespaced keys written) is DELETED at the keychain level only (both
`fresh:email`/`fresh:api-token` removed, simulating a partial external tamper or an
incomplete migration state), leaving the config-file entry intact.

**Expectation:** Any command using `fresh` (e.g. `jr issue list --profile fresh`) hits
`load_api_token("fresh")`'s both-namespaced-keys-absent branch (BC-1.4.032) and returns
the exact actionable error text: `"No credentials stored for profile 'fresh'. This
version of jr requires per-profile credentials — run \`jr auth login fresh\` to set them
up."` — exit 64, `JrError::UserError`. This proves the guard's absence-detection reads
the SAME namespaced-key shape Wave 1's `store_api_token`/`load_api_token` actually write
(not a stale assumption about key naming).

**MUST-PASS.**

### H-W2-INT-002 — Partial-namespaced-pair recovery message names the correct remediation command

**Setup:** Same as above, but only ONE of the two namespaced keys is deleted (e.g.
`fresh:api-token` present, `fresh:email` absent — simulating an interrupted write).

**Expectation:** BC-1.4.033's partial-write recovery branch fires, with the finalized
"drops `jr auth logout`" wording per this story's own File Structure Requirements note
(the guard's own text, not `logout`'s handler, produces this message — `logout` isn't
touched by this story). VP-AUTHDX-008 (no-half-credential safety invariant) is exercised.

**MUST-PASS.**

---

## 2. Regression Scenarios — Existing Auth Behavior Preserved

### H-W2-REG-001 — `load_oauth_tokens` byte-for-byte unchanged (BC-1.4.025 MUST-NOT-TOUCH baseline)

**Setup:** Run `load_oauth_tokens`'s FULL existing pre-cycle-003 test suite (not a subset)
against the post-Wave-2 branch.

**Expectation:** 100% pass, zero modifications needed to any existing `load_oauth_tokens`
test to make it pass. This is the story's own mandated CI gate (per the manifest's Notes:
"running `load_oauth_tokens`'s existing test suite byte-for-byte green as a gate on this
story's own PR, not merely 'existing tests still pass' as an incidental side effect") —
recorded here as a holdout scenario so wave-gate tooling checks it explicitly, not just
as an implicit side effect of `cargo test`.

**MUST-PASS. Regression-critical.**

### H-W2-REG-002 — `"default"` profile is NOT special-cased (no asymmetric legacy-copy revival)

**Setup:** A pre-cycle-003-style `"default"` profile with ONLY the legacy flat
`email`/`api-token` pair present (no namespaced keys), simulating an existing user's
untouched pre-upgrade state. Run any `jr` command that needs credentials
(e.g. `jr issue list`, default profile, no `--profile` flag).

**Expectation:** The SAME `BC-1.4.032` no-copy detect-and-instruct error fires for
`"default"` as for any other profile name — exit 64, same actionable text (substituting
`'default'` for the profile name), NOT a silent auto-migration/copy from the legacy flat
pair. This is VP-AUTHDX-006 (no profile special-cased, including `"default"` —
SAFETY INVARIANT) and is the direct regression check for the REJECTED original design
(DEC-326): a "default"-only lazy copy-then-delete must NOT have crept back in.

**MUST-PASS. Regression-critical — this is the exact failure mode DEC-326 exists to
prevent** (cross-environment credential-bleed into a freshly created or upgraded
`"default"` profile).

### H-W2-REG-003 — Legacy flat pair is never read, copied, or deleted (any profile, any code path in this story)

**Setup:** A profile with BOTH the legacy flat pair present AND (deliberately, for this
test) no namespaced keys. Run `jr auth login <profile>` to explicitly re-establish
per-profile credentials, per the required one-time remediation.

**Expectation:** Before re-login: `load_api_token` returns the no-copy error (does not
silently succeed by reading the legacy pair). After `jr auth login <profile>` completes:
the LEGACY flat pair is still present and UNCHANGED in the keychain (byte-for-byte,
value-for-value) — this story's scope explicitly does not delete it (`§ Decision 2`:
"Leaving the legacy pair in place... That cleanup command is a recommended follow-up, not
built in this cycle"). Confirms VP-AUTHDX-005 (no legacy pair ever read/copied,
SAFETY-CRITICAL PROPERTY) holds through a full remediation cycle, not just at the
detection point.

**MUST-PASS. Regression-critical.**

### H-W2-REG-004 — Mandatory keyring-gated end-to-end scenario (VP-AUTHDX-007) against a real OS backend

**Setup:** `JR_RUN_KEYRING_TESTS=1`, real macOS Keychain / Windows Credential Manager /
Linux Secret Service backend (per the platform running CI) — NOT an in-memory double.
Exercise the full absence→instruct→remediate→success cycle end-to-end.

**Expectation:** Identical behavior to the in-memory-double tests above, proving the
error taxonomy and remediation flow work against the REAL backend's actual error shapes
(`NoEntry` vs. genuine backend errors), not just a test double's simplified model. This is
the cycle's only MANDATORY (not merely recommended) keyring-gated scenario — the manifest
explicitly states it is "NOT demotable to an ordinary integration test."

**MUST-PASS. MANDATORY per VP-AUTHDX-007 — do not skip or demote to `#[ignore]`-without-gate.**

---

## 3. Summary

| ID | Type | Priority |
|---|---|---|
| H-W2-INT-001 | cross-story integration (with Wave 1) | MUST-PASS |
| H-W2-INT-002 | cross-story integration (with Wave 1) | MUST-PASS |
| H-W2-REG-001 | regression (`load_oauth_tokens` MUST-NOT-TOUCH) | MUST-PASS, regression-critical |
| H-W2-REG-002 | regression (no `"default"` special-casing) | MUST-PASS, regression-critical |
| H-W2-REG-003 | regression (legacy pair never touched) | MUST-PASS, regression-critical |
| H-W2-REG-004 | regression (real-backend keyring-gated E2E) | MUST-PASS, MANDATORY (VP-AUTHDX-007) |

6 scenarios. This wave carries the highest MUST-PASS density in the cycle, consistent
with its HIGH-RISK flag — recommend undivided review attention on this wave's gate
(no other story shares Wave 2, so no scheduling action is needed to achieve this; it is
already structurally isolated).
