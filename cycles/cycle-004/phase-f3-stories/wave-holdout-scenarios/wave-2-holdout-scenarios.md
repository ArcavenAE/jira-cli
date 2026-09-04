---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-004
feature: windows-correctness
wave: 2
status: draft
producer: story-writer
created: 2026-09-04
inputs:
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-honest-fail-message.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-windows-docs.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/wave-schedule.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/wave-holdout-scenarios/wave-1-holdout-scenarios.md"
traces_to: "BC-1.4.039"
input-hash: "fb4c7e5"
---

# Wave 2 Holdout Scenarios — `S-cycle4-honest-fail-message` + `S-cycle4-windows-docs`

Two file-disjoint stories running in parallel, both depending on a DIFFERENT Wave-1
story (`honest-fail-message` on `dpapi-storage-fix`; `windows-docs` on
`cloud-id-correctness`). This is the cycle's FINAL wave — its gate closing is a
precondition for cycle-004's F7 delta-convergence gate.

---

## 1. Cross-Story Integration Scenarios (with Wave 1)

### H-W2-INT-001 — Honest-fail message fires correctly against Wave 1's actual marker types

**Setup:** Simulate a `DpapiFallbackFailed` error (constructed against Wave 1's ACTUAL
`src/api/auth_windows_store.rs::DpapiFallbackFailed` type, not a stand-in/mock type) at
Site 1 (`oauth_login`) and Site 3 (`refresh_oauth_token_with_url`).

**Expectation:** Both sites correctly `downcast_ref` the real marker type and select the
appropriate honest-fail message text (Site 1 with grant-revoke, Site 3 without) — this
proves `S-cycle4-honest-fail-message`'s code was written against the ACTUAL landed
`auth_windows_store.rs` interface, not a stale assumption about its shape from before
Wave 1 merged.

**MUST-PASS.**

### H-W2-INT-002 — README's `cloud_id` caveat matches Wave 1's actual shipped behavior

**Setup:** Cross-check `S-cycle4-windows-docs`'s AC-004 caveat text against
`S-cycle4-cloud-id-correctness`'s ACTUAL merged `login_token`/`fetch_cloud_id` behavior
(the exact fallback chain order, the exact `--cloud-id` flag name, the exact soft-fail
framing).

**Expectation:** The README text accurately describes the shipped behavior — no
drift between what Wave 1 actually implemented and what Wave 2's documentation claims.
This is the concrete instance of `S-cycle4-windows-docs`'s Anchor Justification
dependency actually paying off.

**MUST-PASS.**

---

## 2. Regression Scenarios — Existing Auth Behavior Preserved

### H-W2-REG-001 — The four message sites' FULL existing test suite is green

**Setup:** Run `src/api/auth.rs`'s complete existing message-site test suite (all four
sites: `oauth_login`, `refresh_oauth_token_with_url`'s two branches, and
`resolve_refresh_app_credentials`) against the post-Wave-2 branch.

**Expectation:** 100% pass, including Site 4 (`resolve_refresh_app_credentials`), which
`S-cycle4-honest-fail-message` explicitly does NOT modify (audit-only per that story's
Task 7) — this scenario confirms the audit did not accidentally introduce a change.

**MUST-PASS. Regression-critical — this is the story's own mandated CI gate (Task 13
of `S-cycle4-honest-fail-message`), recorded here so wave-gate tooling checks it
explicitly.**

### H-W2-REG-002 — Non-Windows release-build unreachability holds through both waves

**Setup:** On a macOS/Linux release build (no `JR_FORCE_DPAPI_FALLBACK` seam), feed a
mocked `keyring::Error::TooLong` into `store_oauth_tokens` and observe the message at
Sites 1 and 3.

**Expectation:** The LEGACY "Unlock your keychain" message fires at both sites — never
the new honest-fail text — proving `S-cycle4-honest-fail-message`'s changes did not
accidentally widen the `engage_dpapi_fallback` gate `S-cycle4-dpapi-storage-fix`
established in Wave 1.

**MUST-PASS. Regression-critical.**

### H-W2-REG-003 — README diff is scoped to the three intended sections

**Setup:** `git diff README.md` for `S-cycle4-windows-docs`'s PR.

**Expectation:** Only the install-steps/`Unblock-File`, config/cache path table, and
`cloud_id` caveat sections are touched — no unrelated content drift (AC-005), and the
already-correct Windows-asset language at `README.md:66-68` is confirmed UNCHANGED (per
AC-001's confirm-and-preserve correction, not a rewrite).

**MUST-PASS. Regression-critical for AC-001's corrected scope.**

---

## 3. Cycle-Closing Scenario

### H-W2-CLOSE-001 — Full cycle-004 regression suite green on `develop`

**Setup:** After Wave 2 merges, run the FULL `cargo test` suite (default CI tier) plus
`cargo clippy -- -D warnings`, `cargo fmt --all -- --check`, and the spec-guard scripts
(`scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`) against
`develop`.

**Expectation:** All green. This is the precondition for scheduling the F7 manual Windows
smoke-test gate (per `wave-schedule.md` §4) and, subsequently, cycle-004's F7
delta-convergence gate.

**MUST-PASS. MANDATORY — this is the final CI-side gate before F7's manual-validation
step, per DEC-335's Windows-validation split.**

---

## 4. Summary

| ID | Type | Priority |
|---|---|---|
| H-W2-INT-001 | cross-story integration (with Wave 1) | MUST-PASS |
| H-W2-INT-002 | cross-story integration (with Wave 1) | MUST-PASS |
| H-W2-REG-001 | regression (four message sites' full suite) | MUST-PASS, regression-critical |
| H-W2-REG-002 | regression (non-Windows release unreachability) | MUST-PASS, regression-critical |
| H-W2-REG-003 | regression (README diff scope) | MUST-PASS, regression-critical |
| H-W2-CLOSE-001 | cycle-closing full regression | MUST-PASS, MANDATORY (precondition for F7) |

6 scenarios. This wave's gate closing is a precondition for scheduling F7's required
manual Windows smoke test (`wave-schedule.md` §4) — no other cycle-004 wave carries this
obligation, since Wave 2 is the cycle's terminal wave.
