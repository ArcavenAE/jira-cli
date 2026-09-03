---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-003
feature: auth-profile-dx
wave: 5
status: draft
producer: story-writer
created: 2026-09-01
inputs:
  - ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-chosen-flow-reconcile.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-schedule.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/wave-holdout-scenarios/wave-4-holdout-scenarios.md"
traces_to: "BC-1.2.048; BC-1.2.051"
input-hash: "63bcc93"
---

# Wave 5 Holdout Scenarios — `S-cycle3-chosen-flow-reconcile`

Terminal single-story wave, depends solely on Wave 4's `oauth-default-creation`. This is
the cycle's closing wave: it removes `chosen_flow_for_profile`'s per-command override
entirely, making `auth_method` fully intrinsic. Cross-story scenarios here test that the
removal doesn't reopen any of Wave 4's non-interactive-guard behavior it sits downstream
of.

---

## 1. Cross-Story Integration Scenarios

### H-W5-INT-001 — `refresh_credentials` no longer accepts a per-command mechanism override, consistent with Wave 4's flags becoming inert on `refresh`

**Setup:** An `api_token` profile `steady`. Run `jr auth refresh steady --oauth`
(attempting to force an OAuth relogin via the flag, the pre-cycle-003 override
mechanism).

**Expectation:** `--oauth` on `refresh` is now a NO-OP with respect to mechanism
selection (per BC-1.2.051, "the flag silently narrows to a no-op on mechanism selection,
not error" — this IS a documented breaking change per ADR-0020). `refresh` still resolves
`steady`'s mechanism SOLELY from `profile.auth_method` (`api_token`), refreshing via the
api-token path (in practice: an api-token profile's "refresh" is largely inert/no-op
itself, since there's no token-expiry cycle to refresh the way OAuth has one — confirm
against the finalized BC-1.2.051 text for the exact no-op semantics). Crucially: **no
OAuth browser flow is launched** just because `--oauth` was passed — this directly
continues Wave 4's non-interactive-guard discipline (H-W4-REG-002/003) into the
now-flag-is-inert world, and must hold in BOTH interactive and non-interactive
invocations.

**MUST-PASS.**

### H-W5-INT-002 — `chosen_flow_for_profile` removal doesn't leave a dangling `--oauth`/`--api-token` reference on `refresh`

**Setup:** Full-crate `cargo build` + `cargo clippy -- -D warnings` after this story's
removal of `chosen_flow_for_profile` and its `oauth_override: bool` parameter.

**Expectation:** Clean build, zero warnings — confirms `src/cli/auth/refresh.rs`'s call
site was correctly updated to the new signature (dropping the override argument) rather
than left calling a function that no longer exists in that shape, and confirms
`src/cli/mod.rs`'s `--oauth`/`--api-token` flags on `RefreshArgs` (added by Wave 4) are
still syntactically valid clap declarations even though their semantic effect on
mechanism selection is now removed (per the manifest's own note: "Files NOT to touch:
`src/cli/mod.rs`" — the flags themselves stay, only their effect on `refresh`'s
mechanism resolution changes).

**MUST-PASS.**

---

## 2. Regression Scenarios — Existing Auth Behavior Preserved

### H-W5-REG-001 — "Relogin-then-replace" ordering fix (I-6): a failed refresh leaves the existing credential pair completely intact

**Setup:** An OAuth profile `stable-oauth` with a currently-valid token pair. Simulate a
`refresh` attempt that FAILS to obtain a usable replacement credential (e.g. token
endpoint returns an error, or the refresh token has been revoked server-side).

**Expectation:** After the failed refresh attempt, `stable-oauth`'s EXISTING credential
pair is still present and functional (i.e. any command that worked before the failed
refresh attempt still works after it) — the fix replaces the prior, self-contradicting
"clear-then-relogin" framing (BC-1.2.051's Trace notes this was caught by adversary
pass-2, L-1) with "obtain/confirm the new value first, then `store_api_token`/
`store_oauth_tokens` overwrites atomically-in-effect — never a separate delete-then-fetch
step." This is THE regression this wave's I-6 ordering fix exists to close — a defect
here would mean a failed refresh silently locks a user out of a previously-working
profile.

**MUST-PASS. Regression-critical — genuine correctness fix, not merely a rename** (per
the story's own Notes: "The prior 'clear-then-relogin' framing was self-contradicting").

### H-W5-REG-002 — VP-AUTHDX-003's 2×3 mechanism/flag proptest matrix holds end-to-end

**Setup:** Exercise the full 2×3 matrix: {`api_token`, `oauth`} profile mechanisms ×
{no flag, `--oauth`, `--api-token`} flag states, across `auth login` (re-declaration path)
and `auth refresh` (now-inert-override path).

**Expectation:** In every one of the 6 cells, the resolved mechanism used for the actual
HTTP auth header matches `profile.auth_method` exactly — no cell shows a flag silently
overriding the intrinsic mechanism for anything other than `login`'s explicit
re-declaration flow (which is a deliberate, user-initiated MECHANISM CHANGE, not a
per-command override — the distinction BC-1.2.048's invariant draws). This is
VP-AUTHDX-003 (`auth_method`-is-intrinsic invariant — SAFETY INVARIANT) exercised as a
holdout scenario, not just a property test in isolation.

**MUST-PASS. Safety invariant.**

### H-W5-REG-003 — `src/cli/auth/refresh.rs::refresh_credentials` is confirmed as the SOLE F6 citable target (SR-013 correction)

**Setup:** Formal-hardening-phase (F6) target verification — grep this wave's own diff
and the story's Verification Properties table for any citation of
`chosen_flow_for_profile` as an F6 mutation-testing/fuzz target.

**Expectation:** Zero citations — `chosen_flow_for_profile` no longer exists post-this-
story, so any F6 tooling configured to target it (e.g. a stale `mutants.toml`
`examine_globs` entry, mirroring this repo's own documented history of exactly this class
of drift — see CLAUDE.md's `S-MUTANTS-EXAMINE-GLOBS-1` precedent) would silently fail to
find its target. This scenario exists specifically to catch that drift class before it
recurs in cycle-003's own delivery.

**MUST-PASS.**

---

## 3. Summary

| ID | Type | Priority |
|---|---|---|
| H-W5-INT-001 | cross-story integration (Wave 4 guard-discipline continuity) | MUST-PASS |
| H-W5-INT-002 | cross-story integration (removal doesn't dangle) | MUST-PASS |
| H-W5-REG-001 | regression (relogin-then-replace ordering, I-6) | MUST-PASS, regression-critical |
| H-W5-REG-002 | regression (2×3 auth_method-is-intrinsic matrix, VP-AUTHDX-003) | MUST-PASS, safety invariant |
| H-W5-REG-003 | regression (F6 target citation hygiene, SR-013) | MUST-PASS |

5 scenarios. This is the cycle's final wave-gate — passing all 5 here, in combination
with Waves 1-4's own gates, is the F3-through-F7 exit condition for `auth-profile-dx`
as a whole (subject to whatever the cycle's own F7 delta-convergence gate additionally
requires beyond per-wave holdouts).
