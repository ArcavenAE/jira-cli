---
document_type: story
story_id: "S-cycle3-remove-logout-semantics"
epic_id: "AUTH-PROFILE-DX-1"
title: "auth remove 4-step delete (reordered) + auth logout non-destructive notice (DEC-322)"
wave: feature-followup
status: ready
intent: feature
feature_type: feature
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
points: 5
priority: P1
tdd_mode: strict
producer: story-writer
timestamp: "2026-09-01T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
input-hash: "4c9e850"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md"
cycle: cycle-003-auth-profile-dx
estimated_effort: medium
estimated_days: 2
target_module: src/cli/auth
subsystems: []
depends_on: ["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard"]
blocks: ["S-cycle3-adr0011-newtype", "S-cycle3-oauth-default-creation"]
behavioral_contracts:
  - "BC-1.2.013"
  - "BC-1.2.014"
bcs:
  - "BC-1.2.013"
  - "BC-1.2.014"
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0020"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
created: "2026-09-01"
version: "1.0"
last_updated: "2026-09-01"
breaking_change: false
retroactive: false
origin: >
  cycle-003 auth-profile-dx, Wave 3 (depends on S-cycle3-percred-storage,
  S-cycle3-credential-absence-guard). auth remove gains a 4th delete step for the new
  per-profile API-token pair, with steps REORDERED (credentials before config entry, I-4/
  SR-008) and genuine keychain backend errors surfaced rather than swallowed. auth logout
  gains an informational stderr notice (exit 0) when run against an api_token profile,
  replacing the prior silent no-op (I-3/SR-015). This story is also the concrete code
  dependency S-cycle3-oauth-default-creation's re-declaration credential-clear logic
  (BC-1.1.013 EC-1.1.013-2) reuses, per the orchestrator's explicit dependency addition.
---

# S-cycle3-remove-logout-semantics — `auth remove` 4-step delete (reordered) + `auth logout` non-destructive notice

## Anchor Justification

**Dependency anchors:**
- `depends_on: "S-cycle3-percred-storage"` — the new 4th delete step targets the
  `<name>:email`/`<name>:api-token` pair that story creates; this story cannot add a delete
  branch for keys that don't yet exist.
- `depends_on: "S-cycle3-credential-absence-guard"` — BC-1.2.013's amended `logout` contract
  cross-references BC-1.4.033's SR-009 remediation-message fix (dropping `jr auth logout`
  from the recommended remediation text), which that story implements; this story's own
  `logout` notice text must not contradict that fix.

**Blocks anchors:**
- `S-cycle3-adr0011-newtype` depends on this story per ADR-0020 § Sequencing item 5
  ("depends on #2/#3/#4... so the call-site sweep covers the enlarged, post-restructuring
  surface exactly once") — this story's 4th `clear_profile_creds`/`clear_all_credentials`
  branch is part of that surface.
- `S-cycle3-oauth-default-creation` depends on this story (ORCHESTRATOR-ADDED dependency,
  beyond ADR-0020's literal "#2/#3" Sequencing text): BC-1.1.013 EC-1.1.013-2 requires that
  when a profile's mechanism-switching `auth login` re-declaration clears the OUTGOING
  mechanism's credentials, it reuses "the same per-kind clear branches `auth remove` uses
  (`clear_profile_creds`'s OAuth-pair and API-token-pair deletion)." The API-token-pair
  deletion branch in `clear_profile_creds`/`clear_all_credentials` is added BY THIS STORY
  (BC-1.2.014's 4th step) — `S-cycle3-oauth-default-creation`'s re-declaration logic has a
  real code dependency on this story's output, not merely a conceptual one.

## Source of Truth

- `.factory/specs/prd/bc-1-auth-identity.md` §1.2 — BC-1.2.013 (amended, `logout`),
  BC-1.2.014 (amended, `remove`)
- ADR-0020 § Decision 7 ("`auth remove`/`auth logout` scope extension for per-profile
  API-token credentials")

## Narrative

As a `jr` user cleaning up an old profile,
I want `jr auth remove <profile>` to delete BOTH credential kinds (OAuth tokens and
API-token pair) before touching the config entry, and to fail loudly on a genuine keychain
error instead of silently reporting success,
so that a recreated profile with the same name never inherits a stale credential, and I
learn about real backend problems instead of a false "removed" message.

As a `jr` user on an `api_token` profile who runs `jr auth logout` out of habit,
I want a clear message telling me there was nothing to log out of (rather than a silent
no-op),
so that I understand `logout` and `remove` are different operations and know which one to
use.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-1.2.013 | AMENDED | `auth logout` on an `api_token` profile emits an informational stderr notice (exit 0, not an error) instead of a silent no-op; profile entry and non-OAuth-session credentials remain PRESERVED (restated, not changed) |
| BC-1.2.014 | AMENDED | `auth remove <name>`: 4 steps in REORDERED sequence — (1) OAuth pair delete, (2) API-token pair delete (NEW), (3) cache clear, (4) config-entry removal LAST; genuine (non-`NoEntry`) keychain errors on steps 1/2 ABORT before steps 3/4 |

## Current State (read before implementing)

- `src/cli/auth/remove.rs::handle_remove` (`~line 68`) currently: confirms, then persists
  config removal, THEN best-effort clears keychain/cache (`handle_remove_in_memory` mutates
  the in-memory config and removes the profile from `global.profiles`, saved via
  `config.save_global()`, before any credential/cache clearing happens per the function's own
  doc comment: "Persist config first so a subsequent keychain/cache failure can't leave the
  profile listed..."). **This ordering is the OPPOSITE of what BC-1.2.014 (amended) now
  requires** — the BC requires credentials-before-config-entry, specifically so a failure
  partway through leaves the profile's config entry intact and re-`remove`-able. Read the
  current function fully before touching it; this is a genuine reordering, not additive-only.
- `src/api/auth.rs::clear_profile_creds(profile: &str)` (`~line 422`) currently clears ONLY
  the OAuth pair (`oauth_access_key`/`oauth_refresh_key`, plus the legacy OAuth pair for
  `"default"`). It does NOT clear the API-token pair at all today. This story adds that
  branch.
- `src/api/auth.rs::clear_all_credentials(profiles: &[&str])` (`~line 467`) currently clears
  the SHARED flat `KEY_EMAIL`/`KEY_API_TOKEN` keys UNCONDITIONALLY for every call, plus
  per-profile OAuth pairs for the listed profiles. Per DEC-315/BC-1.4.027 (amended, landed by
  `S-cycle3-percred-storage`), `KEY_EMAIL`/`KEY_API_TOKEN` are the LEGACY flat keys — this
  story's "genuine keychain error surfaced, not swallowed" tightening (I-4/SR-008) applies to
  the credential-deletion steps this function performs on behalf of `auth remove`; do NOT
  add a new unconditional clear of `KEY_EMAIL`/`KEY_API_TOKEN` here — that would violate
  BC-1.4.032's "legacy pair never deleted" invariant (`S-cycle3-credential-absence-guard`'s
  scope). This story's new per-profile API-token deletion branch must target ONLY the
  NAMESPACED `<profile>:email`/`<profile>:api-token` keys, exactly mirroring the existing
  per-profile OAuth-pair deletion loop's shape.
- `src/cli/auth/logout.rs::handle_logout` (`~line 24`) currently calls
  `crate::api::auth::clear_profile_creds(&target)` unconditionally and always prints a
  generic "Logged out of profile" success message — no branch for an `api_token` profile
  today.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~4,800 |
| BC-1.2.013 (full) | ~2,000 |
| BC-1.2.014 (full) | ~2,800 |
| `src/cli/auth/remove.rs` (full, ~130 LOC) | ~1,700 |
| `src/cli/auth/logout.rs` (full, ~50 LOC) | ~700 |
| `src/api/auth.rs::clear_profile_creds`/`clear_all_credentials` (~80 LOC) | ~1,000 |
| `cargo test` output for verification | ~500 |
| **Total** | **~13,500** |

Well within 20-30% of a typical agent context window. No splitting required.

## Previous Story Intelligence

**`S-cycle3-percred-storage`** landed `store_api_token`/`load_api_token` and the namespaced
`<profile>:email`/`<profile>:api-token` key helpers — this story's new `clear_profile_creds`
branch must reuse those SAME key-construction helpers (do not hand-roll a second
`format!("{profile}:email")` string, use whatever helper function
`S-cycle3-percred-storage` introduced for the write/read side).

**`S-cycle3-credential-absence-guard`** landed the `S-009` remediation-message fix for the
namespaced-pair partial-write error, dropping `jr auth logout` from its remediation text.
Read that story's final `BC-1.4.033` implementation before writing this story's `logout`
notice text — the two messages (this story's `logout` notice, and that story's partial-write
remediation) must be consistent in tone and must not contradict each other about what
`logout` does or does not do.

**Key insight for the reorder:** the existing `handle_remove` doc comment explains its
CURRENT ordering rationale ("persist config first so a subsequent keychain/cache failure
can't leave the profile listed after its credentials are gone") — this is the EXACT OPPOSITE
of what I-4/SR-008 now requires, and for a documented reason: the new priority is "a partial
failure leaves the profile RE-REMOVABLE" rather than "a partial failure leaves the profile
UN-LISTED but with orphaned credentials." Read BC-1.2.014's amended Behavior clause closely
— this is a genuine, deliberate behavior reversal, not a bug in the existing code.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Step order: credentials before config entry | BC-1.2.014 amended Behavior (I-4/SR-008) | (1) OAuth pair delete, (2) API-token pair delete, (3) cache clear, (4) config-entry removal — in this exact order. Config-entry removal is LAST. |
| Genuine keychain error aborts | BC-1.2.014 amended Behavior | A `keyring::Error::NoEntry` on any credential-delete step = success (already-absent). Any OTHER keychain error ABORTS the command before steps 3/4 run, surfaced to the user, non-zero exit. |
| Cache-clear step stays best-effort | BC-1.2.014 amended Behavior | Step 3 (cache directory removal) remains best-effort — only the two credential-deletion steps gained the "abort on real error" tightening. |
| `logout` exit code is 0 on an api_token profile | BC-1.2.013 amended, Informational notice clause | The stderr notice is a SUCCESSFUL, EXPECTED outcome, not an error — exit 0. |
| `logout` notice text (exact) | BC-1.2.013 amended | `"This profile uses API-token auth — nothing to log out; use \`jr auth remove <profile>\` to delete stored credentials."` (profile name interpolated). |
| `logout` notice is stderr-only, never stdout | BC-1.2.013 amended, `--output json` note | Under `--output json`, no stdout payload change from the pre-fix no-op behavior; notice never appears on stdout in any mode. |
| `logout` remains OAuth-specific by design | BC-1.2.013 amended | Do NOT extend `logout` to clear API-token credentials — that is `remove`'s job. This story only adds the informational notice, not new clearing behavior to `logout`. |
| `clear_profile_creds`'s new branch targets NAMESPACED keys only | BC-1.4.027 (amended, cross-ref); this story's Current State note | Never touch the legacy flat `KEY_EMAIL`/`KEY_API_TOKEN` pair — that is `S-cycle3-credential-absence-guard`'s no-touch invariant (BC-1.4.032), which this story must not violate. |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` must pass. |

## Library and Framework Requirements

No new external dependencies.

| Item | Version / Constraint |
|------|----------------------|
| `keyring` | pinned version unchanged |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/api/auth.rs` | MODIFY | `clear_profile_creds(profile)`: add the API-token-pair (namespaced) deletion branch, alongside the existing OAuth-pair branch; propagate genuine (non-`NoEntry`) errors instead of aggregating-and-swallowing for these two credential steps. `clear_all_credentials(profiles)`: same tightening for its per-profile API-token deletion additions — do NOT add an unconditional legacy-flat-key clear. |
| `src/cli/auth/remove.rs` | MODIFY | `handle_remove`: reorder to credentials-before-config-entry; propagate genuine keychain errors from steps 1/2 before running steps 3/4. |
| `src/cli/auth/logout.rs` | MODIFY | `handle_logout`: branch on the target profile's `auth_method`; on `api_token` (or profiles where the OAuth pair is absent per the intrinsic-mechanism read), print the informational stderr notice instead of the generic success message, exit 0. |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Fixed`/`Changed` entry — the error-surfacing tightening (I-4/SR-008) is a real user-facing behavior change worth noting even though framed as a bugfix. |

**Files NOT to touch:** `src/cache.rs` (cache-clear step's own logic is unchanged, only its
position in the sequence moves).

## Acceptance Criteria

### AC-001 — `auth remove` deletes credentials before config entry
`jr auth remove <name>` performs OAuth-pair delete, then API-token-pair delete, then cache
clear, then config-entry removal, in that order.
(traces to BC-1.2.014 postcondition — Behavior, step order)

### AC-002 — genuine keychain error on step 1 or 2 aborts before steps 3/4
A simulated genuine (non-`NoEntry`) keychain error injected at the OAuth-pair or API-token-
pair delete step aborts `handle_remove` before cache-clear/config-removal run; the error is
surfaced to the user.
(traces to BC-1.2.014 EC-1.2.014-1, VP-1.2.014-001)

### AC-003 — `[profiles.<name>]` remains after an aborted remove
After AC-002's aborted call, `[profiles.<name>]` is still present in config — a re-run of
`jr auth remove <name>` is the documented recovery path.
(traces to BC-1.2.014 postcondition — Effects)

### AC-004 — both credential-deletion steps independently re-attempted on retry
A subsequent retry of `jr auth remove <name>` (after resolving the backend issue)
independently re-attempts both credential-deletion steps, tolerating a `NoEntry` result from
whichever step already succeeded on the first attempt.
(traces to BC-1.2.014 EC-1.2.014-2)

### AC-005 — `NoEntry` on both credential steps → success, proceeds normally
Both credential-deletion steps reporting `NoEntry` (no stored credentials of either kind) is
treated as success; the command proceeds to cache-clear and config removal.
(traces to BC-1.2.014 EC-1.2.014-2)

### AC-006 — `auth logout` on an `api_token` profile emits the exact notice, exit 0
`jr auth logout --profile <api-token-profile>` prints the exact stderr string from BC-1.2.013
(profile name interpolated) and exits 0.
(traces to BC-1.2.013 postcondition — Informational notice)

### AC-007 — `auth logout` notice absent from stdout, JSON mode unaffected
Under `--output json`, the notice never appears on stdout; exit code and JSON payload shape
are unchanged from the pre-fix no-op behavior.
(traces to BC-1.2.013 postcondition — `--output json` note)

### AC-008 — `auth logout` on an `oauth` profile is unaffected (regression pin)
`jr auth logout` against an `oauth`-method profile still deletes the OAuth pair and prints
the ordinary success message — no notice, unchanged behavior.
(traces to BC-1.2.013 Behavior, regression pin — not itself a new BC clause but a required
non-regression per this story's scope discipline)

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-1.2.014-1 | BC-1.2.014 | genuine keychain backend error on step 1 or 2 | abort before steps 3/4; config entry remains (AC-002/003) |
| EC-1.2.014-2 | BC-1.2.014 | both credential-deletion steps report `NoEntry` | treated as success, proceed normally (AC-004/005) |

## Tasks

### Item 1: Read the current implementations
- [ ] Read `src/cli/auth/remove.rs::handle_remove` fully — note the CURRENT ordering rationale in its doc comment, which this story reverses
- [ ] Read `src/api/auth.rs::clear_profile_creds`/`clear_all_credentials` fully
- [ ] Read `src/cli/auth/logout.rs::handle_logout` fully
- [ ] Confirm `S-cycle3-percred-storage`'s namespaced-key helper function names (reuse, don't duplicate)

### Item 2: `clear_profile_creds`/`clear_all_credentials` — add API-token branch, tighten errors
- [ ] Add the namespaced API-token-pair deletion branch to `clear_profile_creds`
- [ ] Tighten error handling: genuine (non-`NoEntry`) errors on the two credential-deletion
      steps propagate rather than aggregate-and-continue
- [ ] Mirror the same additions in `clear_all_credentials`'s per-profile loop
- [ ] Confirm no unconditional legacy-flat-key (`KEY_EMAIL`/`KEY_API_TOKEN`) clear is added

### Item 3: `handle_remove` — reorder
- [ ] Reorder to: (1) OAuth delete, (2) API-token delete, (3) cache clear, (4) config-entry
      removal
- [ ] Propagate a genuine error from steps 1/2 before running 3/4
- [ ] Update the function's doc comment to reflect the new ordering rationale

### Item 4: `handle_logout` — informational notice
- [ ] Branch on target profile's stored `auth_method`
- [ ] On `api_token`, print the exact BC-1.2.013 stderr string, exit 0, skip the generic
      success message
- [ ] On `oauth`, unchanged behavior (AC-008 regression pin)

### Item 5: Tests
- [ ] AC-001 through AC-008 unit/integration tests
- [ ] Keyring-gated variant if the existing `remove`/`logout` test suite already uses
      `JR_RUN_KEYRING_TESTS=1` gating (follow existing pattern, don't invent a new one)

### Item 6: CHANGELOG
- [ ] `[Unreleased] > Fixed` entry: `auth remove` credential-deletion error surfacing
      tightened (was best-effort/swallowed, now aborts on genuine backend error)
- [ ] `[Unreleased] > Changed` entry: `auth logout` on an api-token profile now prints an
      informational notice instead of silently no-op-ing

### Integration checks (all must pass before PR)
- [ ] `cargo test` exits 0 (full suite)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- `Profile` newtype threading — `S-cycle3-adr0011-newtype`.
- Interactive OAuth-default picker / re-declaration credential-clear wiring at the `auth
  login` call site — `S-cycle3-oauth-default-creation` (that story CONSUMES this story's
  `clear_profile_creds` branches; it does not modify them further).
- Any change to `load_api_token`'s error taxonomy — `S-cycle3-credential-absence-guard`'s
  scope, already landed as this story's dependency.

## Dependency Analysis

**depends_on:** `["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard"]` — see
Anchor Justification above.
**blocks:** `S-cycle3-adr0011-newtype`, `S-cycle3-oauth-default-creation` — see Anchor
Justification above; the `oauth-default-creation` edge is the orchestrator-directed addition
beyond ADR-0020's literal Sequencing text.

## Story Points and Effort

**5 story points** (medium). Breakdown:
- `clear_profile_creds`/`clear_all_credentials` API-token branch + error tightening: 1.5 SP
- `handle_remove` reorder: 1 SP
- `handle_logout` informational notice: 1 SP
- Tests (8 ACs): 1.5 SP

Risk: MEDIUM-HIGH (module criticality) — destructive operations on credential state; the
step-reordering fix is itself closing a correctness gap where a partial failure could
previously leave a profile in a bad state. The reorder touches control flow that existing
tests already cover — run the FULL existing `remove`/`logout` test suite, not just new
tests, before considering this story done.
