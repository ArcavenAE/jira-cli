---
document_type: story
story_id: "S-cycle3-chosen-flow-reconcile"
epic_id: "AUTH-PROFILE-DX-1"
title: "Remove chosen_flow_for_profile's per-command override; auth_method fully intrinsic (DEC-321)"
wave: feature-followup
status: ready
intent: feature
feature_type: refactor
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
input-hash: "2fd9059"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md"
cycle: cycle-003-auth-profile-dx
estimated_effort: medium
estimated_days: 2
target_module: src/cli/auth/refresh.rs
subsystems: []
depends_on: ["S-cycle3-oauth-default-creation"]
blocks: []
behavioral_contracts:
  - "BC-1.2.048"
  - "BC-1.2.051"
bcs:
  - "BC-1.2.048"
  - "BC-1.2.051"
verification_properties:
  - "VP-AUTHDX-003"
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0020"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations: []
created: "2026-09-01"
version: "1.1"
last_updated: "2026-09-03"
breaking_change: true
retroactive: false
origin: >
  cycle-003 auth-profile-dx, Wave 5 (depends on S-cycle3-oauth-default-creation; final story
  in the cycle). Removes chosen_flow_for_profile's oauth_override: bool parameter entirely --
  auth refresh --oauth/--api-token no longer override the profile's stored auth_method; the
  intrinsic mechanism always wins. Also fixes I-6: refresh's "clear-then-relogin" self-
  contradiction, renamed and corrected to "relogin-then-replace" -- a failed relogin must
  never clear existing credentials before a replacement is confirmed obtainable. This closes
  the sole pre-cycle-003 exception to "auth_method is intrinsic" (BC-1.2.048).
---

# S-cycle3-chosen-flow-reconcile — Remove `chosen_flow_for_profile`'s per-command override; `auth_method` fully intrinsic

## Revision Note (F7 pre-gate consistency-audit fix, MED-2)

Stale wave-number prose corrected: this story lands in **Wave 5** of the adopted 5-wave
schedule, not "Wave 6" as the `origin:` frontmatter block previously stated. This is a
label-only fix — the `depends_on:`/`blocks:` dependency edges were already correct and are
unchanged.

## Anchor Justification

**Dependency anchors:** `depends_on: ["S-cycle3-oauth-default-creation"]` — ADR-0020 §
Sequencing item 7, verbatim: "depends on #6." This story removes `--oauth`/`--api-token`'s
override POWER on `auth refresh`; those flags must already exist (added by
`S-cycle3-oauth-default-creation`, BC-1.2.049/050) before this story can remove their effect
on mechanism selection. Sequencing them the other way around would leave a window where the
flags exist but their (soon-to-be-removed) override behavior is undocumented/unfixed.

**Blocks anchors:** `blocks: []` — this is the terminal story in the cycle's dependency
chain; no other cycle-003 story depends on this story's output.

## Source of Truth

- `.factory/specs/prd/bc-1-auth-identity.md` §1.2 — BC-1.2.048 (general `auth_method`-is-
  intrinsic invariant), BC-1.2.051 (specific `auth refresh` override removal, I-6 ordering fix)
- ADR-0020 § Decision 6 ("`auth refresh`'s `--oauth`/`--api-token` become pure deprecated
  aliases with no override power")

## Narrative

As a `jr` user running `jr auth refresh --oauth` against a profile whose stored
`auth_method` is `api_token`,
I want the refresh to proceed via the profile's actual, stored mechanism (never launching an
unwanted OAuth browser flow),
so that a flag I pass out of habit or muscle memory can never surprise-launch a browser or
prompt for the wrong credential kind.

As a `jr` user whose `auth refresh` fails partway through (network error, cancelled
re-prompt),
I want my existing, working credential left completely intact,
so that a failed refresh never leaves my profile in a WORSE state than before I ran the
command.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-1.2.048 | NEW | General `auth_method`-is-intrinsic invariant statement; VP-AUTHDX-003 declared here |
| BC-1.2.051 | NEW | `auth refresh --oauth`/`--api-token` lose all override power — the specific, previously-non-compliant instance BC-1.2.048 closes; I-6 "relogin-then-replace" ordering fix (renamed from the self-contradicting "clear-then-relogin") |

## Current State (read before implementing)

- `src/cli/auth/mod.rs::chosen_flow_for_profile` (`~line 107-119`) TODAY:
  ```rust
  fn chosen_flow_for_profile(
      profile: &crate::config::ProfileConfig,
      oauth_override: bool,
  ) -> AuthFlow {
      if oauth_override {
          return AuthFlow::OAuth;
      }
      match profile.auth_method.as_deref() {
          Some("oauth") => AuthFlow::OAuth,
          _ => AuthFlow::Token,
      }
  }
  ```
  The `if oauth_override { return AuthFlow::OAuth; }` branch is EXACTLY the override this
  story removes. Per BC-1.2.051 Postcondition 3, the function's remaining logic (the `match`
  on `profile.auth_method`) is what survives — `oauth_override: bool` is removed as a
  parameter entirely (BC-1.2.051 explicitly says "the function (if retained at all) resolves
  solely from the profile's stored `auth_method`" — retaining the function with a narrower
  signature is the expected shape, not a full deletion).
- `src/cli/auth/mod.rs`'s `chosen_flow` test-only wrapper (`~line 99-101`, `#[cfg(test)]`)
  calls `chosen_flow_for_profile(&config.active_profile(), oauth_override)` — this wrapper's
  own signature must be updated (or removed, if it becomes redundant once
  `chosen_flow_for_profile` takes no override parameter) in step with the parameter removal.
- `src/cli/auth/refresh.rs::refresh_credentials` (`~line 55`) currently imports and calls
  `chosen_flow_for_profile` via `super::{AuthFlow, chosen_flow_for_profile, login_oauth,
  login_token}` (`~line 8`). Update this call site to the new signature.
- `src/cli/auth/refresh.rs`'s doc comment directly above the function that performs the
  clear-and-relogin sequence (`~line 24-33`) reads, verbatim: **"Ordering is clear-then-login.
  If the login step fails (e.g., EOF on stdin, network error during OAuth), the user is
  warned that credentials are gone and told exactly which `jr auth login` invocation will
  restore them, before the error is propagated."** This is the EXACT I-6 self-contradiction
  BC-1.2.051 Invariant 2 requires fixing — the current code (and its own doc comment) admits
  it clears BEFORE confirming a replacement is obtainable, which directly violates "a failed
  refresh must never leave a profile in a WORSE (credential-less) state than before the
  command was run." **This is a genuine logic reordering, not a comment-only fix** — read the
  actual function body this comment describes (not just the comment) before changing
  anything.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~5,000 |
| BC-1.2.048 (full) | ~2,600 |
| BC-1.2.051 (full) | ~3,000 |
| `src/cli/auth/mod.rs` (relevant ~40 LOC: `chosen_flow`/`chosen_flow_for_profile`) | ~600 |
| `src/cli/auth/refresh.rs` (full, ~120+ LOC including the clear-then-login function) | ~1,800 |
| `cargo test` + proptest output for verification | ~600 |
| **Total** | **~13,600** |

Well within 20-30% of a typical agent context window. No splitting required.

## Previous Story Intelligence

**`S-cycle3-oauth-default-creation`** landed the `--api-token` flag on `refresh.rs` and the
BC-1.1.016 airtight non-interactive guard (which cites `refresh_credentials` as an F6 target
for its implicit-oauth-profile-refresh extended cell). **Read that story's final
`refresh_credentials` diff before touching it here** — this story's I-6 ordering fix and the
`chosen_flow_for_profile` signature change must be layered on top of that story's guard
insertion, not interleaved with or ahead of it. The guard (a precondition check that must
fire before any network/listener/browser code) and this story's "relogin-then-replace"
ordering fix (a sequencing change to the actual credential-clear/re-obtain logic) are
DIFFERENT concerns at different points in the function — do not conflate them, and do not
accidentally move the guard check as a side effect of this story's reordering.

**SR-013 F6-target correction (binding, from BC-1.2.048's Trace):** cite
`src/cli/auth/refresh.rs::refresh_credentials` as the SOLE F6 target for VP-AUTHDX-003 — do
NOT cite `chosen_flow_for_profile`, since after this story's removal it may not exist as a
distinct function (or exists in a narrowed form with no override parameter left to test in
isolation the way the old override did).

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| `auth_method` is intrinsic — no per-command override, anywhere | BC-1.2.048 Postcondition 1 | After this story, `--oauth`/`--api-token` on `refresh` have ZERO effect on which mechanism is used — the only way to change a profile's mechanism is `auth login` re-declaration (already implemented by `S-cycle3-oauth-default-creation`). |
| Flags remain SYNTACTICALLY accepted, not hard errors | BC-1.2.051 Postcondition 2 | This is a silent behavior narrowing, not a new clap error — `--oauth`/`--api-token` still parse successfully on `refresh`, they just no longer change the outcome. |
| "Relogin-then-replace," never "clear-then-fetch" | BC-1.2.051 Invariant 2 (I-6) | Obtain/confirm the new credential value FIRST, then `store_api_token` overwrites atomically-in-effect — NEVER a separate delete step beforehand. A `refresh` that fails to obtain a usable replacement MUST leave the existing credential pair completely intact. |
| Term correction: "relogin-then-replace," not "clear-then-relogin" | BC-1.2.051 Postcondition 1 (adversary pass-2 fix L-1) | Use this corrected terminology in code comments/doc updates — the old term is self-contradicting against this story's own Invariant 2. |
| VP-AUTHDX-003's sole F6 target | BC-1.2.048 Trace (SR-013) | `src/cli/auth/refresh.rs::refresh_credentials` — do NOT cite `chosen_flow_for_profile` as an F6 target. |
| Breaking-change acknowledgment | BC-1.2.051 EC-1.2.051-1; ADR-0020 § Breaking-Change Acknowledgment | `jr auth refresh --oauth <profile>` where `<profile>.auth_method == "api_token"` no longer forces an OAuth relogin (pre-cycle-003 behavior) — this is a documented, intentional breaking change; the CHANGELOG task must cite it explicitly, mirroring the BC-1.2.047/S-663-1 precedent. |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` must pass. |

## Library and Framework Requirements

No new external dependencies.

| Item | Version / Constraint |
|------|----------------------|
| `proptest` (dev-dependency, already present) | 2×3 mechanism/flag matrix for VP-AUTHDX-003 |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/cli/auth/mod.rs` | MODIFY | `chosen_flow_for_profile`: remove the `oauth_override: bool` parameter and its `if oauth_override { return AuthFlow::OAuth; }` branch — resolve solely from `profile.auth_method`. Update or remove the `#[cfg(test)]` `chosen_flow` wrapper accordingly. |
| `src/cli/auth/refresh.rs` | MODIFY | Update the `chosen_flow_for_profile` call site to the new signature (drop the `--oauth`/`--api-token` argument being passed as an override). Fix the I-6 "relogin-then-replace" ordering in the credential-refresh logic; update the function's doc comment (the "Ordering is clear-then-login" text) to match the corrected sequencing and terminology. |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Changed` (Breaking) entry: `auth refresh --oauth`/`--api-token` no longer override the target profile's stored mechanism. |

**Files NOT to touch:** `src/cli/mod.rs` (the flags themselves and their clap declarations
are unchanged — this story only changes what they DO, not their presence/parsing, which
`S-cycle3-oauth-default-creation` already established).

## Acceptance Criteria

### AC-001 — `chosen_flow_for_profile` resolves solely from the profile's stored `auth_method`
The function's signature no longer takes an override parameter; its return value depends
only on `profile.auth_method`.
(traces to BC-1.2.051 postcondition 3)

### AC-002 — `refresh --oauth` on an `api_token` profile proceeds as api-token refresh, no browser
`jr auth refresh --oauth <profile>` where `<profile>.auth_method == "api_token"` performs an
api-token credential refresh/relogin; NO OAuth browser flow is launched.
(traces to BC-1.2.051 EC-1.2.051-1)

### AC-003 — `refresh --api-token` on an `oauth` profile proceeds as OAuth refresh, no token prompt
`jr auth refresh --api-token <profile>` where `<profile>.auth_method == "oauth"` performs an
OAuth relogin; no api-token credential prompt is shown.
(traces to BC-1.2.048 VP-AUTHDX-003, specific instance)

### AC-004 — no-flag `refresh` is unaffected (regression pin)
`jr auth refresh <profile>` with no flag continues to follow the stored `auth_method`
exactly as before.
(traces to BC-1.2.051 EC-1.2.051-2)

### AC-005 — 2×3 mechanism/flag matrix property test (VP-AUTHDX-003)
A `proptest` over `{profile's stored auth_method ∈ {oauth, api_token}} × {flag passed to
refresh ∈ {none, --oauth, --api-token}}` asserts the mechanism actually used is ALWAYS the
profile's stored `auth_method`, never the flag, on every generated case — including the
no-browser/no-prompt side-effect predicates.
(traces to BC-1.2.048 VP-AUTHDX-003)

### AC-006 — relogin-then-replace: existing credential NOT cleared before replacement confirmed
For an `api_token`-method profile, `refresh`'s relogin step does not delete/overwrite the
existing `<profile>:email`/`<profile>:api-token` pair until the new credential value has been
obtained and validated as usable.
(traces to BC-1.2.051 invariant 2, I-6)

### AC-007 — failed relogin leaves the existing credential pair completely intact
A `refresh` that fails to obtain a usable replacement (simulated network error, or a
cancelled interactive re-prompt) exits non-zero, but `<profile>:email`/`<profile>:api-token`
are UNCHANGED from their pre-`refresh` values; a subsequent `jr` invocation against that
profile continues to authenticate successfully with the old credential.
(traces to BC-1.2.051 EC-1.2.051-3)

### AC-008 — flags remain syntactically accepted on `refresh` (no clap error)
`jr auth refresh --oauth <profile>` and `jr auth refresh --api-token <profile>` both parse
successfully (no clap exit 2) regardless of the profile's actual mechanism.
(traces to BC-1.2.051 postcondition 2)

### AC-009 — CHANGELOG breaking-change entry
A `[Unreleased] > Changed` (Breaking) CHANGELOG entry describes the removed override
behavior, mirroring the BC-1.2.047/S-663-1 precedent.
(traces to BC-1.2.051 EC-1.2.051-1, ADR-0020 § Breaking-Change Acknowledgment)

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-1.2.048-1 | BC-1.2.048 | `--oauth`/`--api-token` supplied to `refresh` | accepted syntactically, zero effect on mechanism selection (AC-008) |
| EC-1.2.051-1 | BC-1.2.051 | `refresh --oauth` on an `api_token` profile | api-token refresh proceeds, no OAuth browser (AC-002) — documented breaking change |
| EC-1.2.051-2 | BC-1.2.051 | `refresh` with no flag | unaffected (AC-004) |
| EC-1.2.051-3 | BC-1.2.051 | relogin fails to obtain a usable replacement | existing credential pair intact (AC-006/007) |

## Tasks

### Item 1: Read the current implementation and the prior story's final diff
- [ ] Read `S-cycle3-oauth-default-creation`'s final `refresh.rs` diff — confirm the BC-1.1.016 guard's exact location so this story's changes don't disturb it
- [ ] Read `chosen_flow_for_profile`/`chosen_flow` (`src/cli/auth/mod.rs:~99-119`) in full
- [ ] Read the ACTUAL function body behind `refresh.rs`'s "Ordering is clear-then-login" doc comment (`~line 24-33` and its implementation, not just the comment)

### Item 2: Remove the override parameter
- [ ] `chosen_flow_for_profile`: drop `oauth_override: bool`, drop the `if oauth_override` branch
- [ ] Update/remove the `#[cfg(test)]` `chosen_flow` wrapper
- [ ] Update `refresh.rs`'s call site
- [ ] AC-001/002/003/004 tests

### Item 3: Fix the I-6 relogin-then-replace ordering
- [ ] Reorder the relogin logic: obtain/confirm new credential FIRST, then `store_api_token` overwrite — never a prior delete step
- [ ] Update the function's doc comment: rename "clear-then-login" to "relogin-then-replace," correct the described behavior
- [ ] AC-006/007 tests, including a simulated-failure test proving the existing credential survives

### Item 4: Property test (VP-AUTHDX-003)
- [ ] 2×3 mechanism/flag matrix `proptest`, asserting `actual_mechanism_used == profile.auth_method` on every case
- [ ] Retain the two concrete cases (api_token profile + `--oauth`; oauth profile +
      `--api-token`) as fixed regression seeds
- [ ] AC-005/008 tests

### Item 5: CHANGELOG
- [ ] `[Unreleased] > Changed` (Breaking) entry (AC-009)

### Integration checks (all must pass before PR)
- [ ] `cargo test` exits 0 (full suite)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- Any change to `auth login`'s picker or non-interactive guard — those are
  `S-cycle3-oauth-default-creation`'s already-landed scope; this story only touches
  `refresh`'s override removal and ordering fix.
- Any change to `--oauth`'s deprecation-notice text or `--api-token`'s inertness-notice text
  — those are `S-cycle3-oauth-default-creation`'s scope (BC-1.2.049/050); this story does not
  re-word them, only removes the underlying override BEHAVIOR the notices already describe as
  inert.

## Dependency Analysis

**depends_on:** `["S-cycle3-oauth-default-creation"]` — see Anchor Justification above.
**blocks:** `[]` — terminal story in the cycle.

## Story Points and Effort

**5 story points** (medium). Breakdown:
- Override-parameter removal (`chosen_flow_for_profile` + call site): 1 SP
- I-6 relogin-then-replace ordering fix: 1.5 SP
- VP-AUTHDX-003 2×3 proptest matrix: 1.5 SP
- CHANGELOG + integration: 1 SP

Risk: MEDIUM. The override removal itself is a small, mechanical change; the I-6 ordering
fix is a genuine correctness fix to existing logic (not a rename) and is where most of this
story's real risk lives — the prior "clear-then-relogin" framing was self-contradicting, so
implementing "relogin-then-replace" correctly requires actually reading and understanding
the current relogin code path, not just updating its comment.
