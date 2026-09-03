---
document_type: story
story_id: "S-cycle3-adr0011-newtype"
epic_id: "AUTH-PROFILE-DX-1"
title: "Profile(String) newtype -- un-defer ADR-0011, thread through ~60-80 call sites (DEC-317)"
wave: feature-followup
status: ready
intent: feature
feature_type: refactor
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
points: 13
priority: P1
tdd_mode: strict
producer: story-writer
timestamp: "2026-09-01T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-6-config-cache.md"
  - ".factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md"
  - ".factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md"
  - ".factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
input-hash: "abe1e20"
traces_to: ".factory/specs/prd/bc-6-config-cache.md"
cycle: cycle-003-auth-profile-dx
estimated_effort: x-large
estimated_days: 5
target_module: src/cache.rs
subsystems: []
depends_on: ["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard", "S-cycle3-remove-logout-semantics"]
blocks: []
behavioral_contracts:
  - "BC-6.2.015"
bcs:
  - "BC-6.2.015"
verification_properties: []
holdout_anchors: []
nfr_anchors: ["NFR-SCA-2"]
adr_refs: ["ADR-0011", "ADR-0020", "ADR-0007"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
created: "2026-09-01"
version: "1.0"
last_updated: "2026-09-01"
breaking_change: false
retroactive: false
origin: >
  cycle-003 auth-profile-dx, Wave 4 (depends on S-cycle3-percred-storage,
  S-cycle3-credential-absence-guard, S-cycle3-remove-logout-semantics -- sequenced LAST among
  the credential-restructuring stories so the call-site sweep covers the enlarged,
  post-restructuring surface exactly once, per ADR-0011's own Sequencing). Un-defers ADR-0011
  (Status: Deferred -> Accepted, DEC-317) by introducing a Profile(String) newtype and
  threading it through every per-profile cache function (12+ in src/cache.rs), plus
  src/api/auth.rs's four credential functions (store_api_token/load_api_token/
  store_oauth_tokens/load_oauth_tokens), Config::active_profile_name, and
  JiraClient::profile_name. A profile-unaware function or a hardcoded-&str call site becomes
  a compile error. MUST apply the staged ADR-0011 amendment to
  docs/adr/0011-type-level-profile-fence.md as part of this story's implementation PR --
  the main-repo file still reads Status: Deferred as of this writing.
---

# S-cycle3-adr0011-newtype — `Profile(String)` newtype: un-defer ADR-0011, thread through ~60-80 call sites

## Anchor Justification

**Dependency anchors:** `depends_on: ["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard", "S-cycle3-remove-logout-semantics"]`
— ADR-0020 § Sequencing item 5, verbatim: "depends on #2/#3/#4 landing first, so the
call-site sweep covers the enlarged, post-restructuring surface exactly once." Landing the
newtype BEFORE those three stories would mean sweeping the call-site surface once, then
re-sweeping it again once the credential restructuring adds new per-profile call sites
(`store_api_token`/`load_api_token`, the new `clear_profile_creds` API-token branch) — the
exact rework this sequencing exists to avoid. Both the staged ADR-0011 amendment and
ADR-0020 are explicit and consistent on this ordering; do not resequence this story earlier
even though its only HARD functional dependency (per the manifest) is on the credential
functions existing, which technically only requires story 2 — the sequencing intent is to
capture stories 3 and 4's call-site additions too, in one pass.

**Blocks anchors:** `blocks: []` — no other cycle-003 story's BCs name `Profile` as a
functional precondition (BC-1.2.048/BC-1.2.051 in `S-cycle3-chosen-flow-reconcile`, and
BC-1.1.013-016/BC-1.2.049/050 in `S-cycle3-oauth-default-creation`, are all written against
`profile: &str` signatures). This story is a leaf in the strict dependency graph, but ADR-0020's
own recommended land order places it BEFORE `S-cycle3-oauth-default-creation` anyway
(file-collision-avoidance on `src/api/auth.rs`/`src/cli/auth/login.rs` — a rebase-churn
concern, not a correctness dependency); the wave-scheduling step should honor that
recommendation even though the dependency graph alone would permit parallelism with story 6.

## Source of Truth

- `.factory/specs/prd/bc-6-config-cache.md` §6.2, BC-6.2.015 (the target contract — read the
  FULL BC body, including its "Status as of this amendment" and "Residual" sections)
- `.factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` — the
  STAGED amendment this story's PR MUST apply to `docs/adr/0011-type-level-profile-fence.md`
- ADR-0020 § Sequencing (cross-story ordering)

## Narrative

As a `jr` contributor,
I want a `Profile(String)` newtype threaded through every cache function, credential
function, and profile-name field that currently accepts a bare `&str`/`String`,
so that a profile-unaware function, or a call site passing a hardcoded string literal where
a real profile name is expected, becomes a compile error instead of a silent cross-profile
leakage risk.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-6.2.015 | AMENDED | The compile-time hard fence: `pub struct Profile(String)` with `From<String>`/`AsRef<str>`/`Display` impls, threaded through 12+ `src/cache.rs` functions, `src/api/auth.rs`'s 4 credential functions, `Config::active_profile_name`, `JiraClient::profile_name`. Design ACCEPTED at the F2 gate (DEC-317); this story is the F4 implementation. |

## Current State (read before implementing)

- `src/cache.rs` has 26 `pub fn` definitions today, 16 of which take `profile: &str` as a
  parameter (grep-verified: `grep -n 'pub fn ' src/cache.rs | grep -c 'profile: &str'` = 16
  of 26). **The exact count at implementation time governs this story's real diff size** —
  re-run this grep before starting and compare against the ~60-80 total call-site estimate
  below; if materially larger, invoke the SPLIT plan noted in Story Points below.
- `docs/adr/0011-type-level-profile-fence.md` (77 lines on `develop` as of this writing)
  currently reads `## Status` / `Deferred — Target version: v0.6.0 or later`. **This file has
  NOT been touched by any F2 pass.** The full replacement content is staged verbatim at
  `.factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` — this
  story's PR applies that staged content to the `docs/adr/` file (see Task Item 1 below;
  this is a NAMED, explicit task, not an implicit side effect of "implement the newtype").
- `src/config.rs::Config::active_profile_name` and `src/api/client.rs::JiraClient::profile_name`
  both currently use `String` — this story changes both to `Profile`.
- `src/api/auth.rs`'s four credential functions
  (`store_api_token`/`load_api_token`/`store_oauth_tokens`/`load_oauth_tokens`) — as landed
  by `S-cycle3-percred-storage` (the first two) and pre-existing (the OAuth pair) — all
  currently take `profile: &str`. This story changes all four to `profile: &Profile`.
  `clear_profile_creds`/`clear_all_credentials`'s aggregation loops (added-to by
  `S-cycle3-remove-logout-semantics`) are downstream callers, not separately-typed functions
  — they change to consume `&Profile` at their own call boundary, not to gain a new type of
  their own.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~6,000 |
| BC-6.2.015 (full, including both superseded-version blocks) | ~4,200 |
| Staged ADR-0011 amendment (full) | ~4,800 |
| `src/cache.rs` (full, all 16+ profile-taking functions) | ~9,000 |
| `src/api/auth.rs` (the 4 credential functions + call sites) | ~2,500 |
| `src/config.rs`/`src/api/client.rs` (relevant fields + call sites) | ~1,500 |
| `cargo build`/`cargo test` full-suite output for verification | ~1,000 |
| **Total** | **~29,000** |

This is the LARGEST token budget in the cycle and approaches the upper end of a 20-30%
context-window allocation for a typical implementing agent. **If the actual call-site count
proves materially larger than ~60-80 at implementation time, split this story** — a natural
split point is "a `cache.rs`-only pass" plus a separate "`auth.rs` + `Config` + `JiraClient`
pass" (flagged in the decomposition manifest for the integrate-burst wave-scheduler to
reassess against the real diff size).

## Previous Story Intelligence

By the time this story starts, `S-cycle3-percred-storage`, `S-cycle3-credential-absence-guard`,
and `S-cycle3-remove-logout-semantics` have all landed. **Re-grep `src/cache.rs` and
`src/api/auth.rs` for `profile: &str` occurrences at the START of this story** (do not trust
this story spec's counts as final — they were measured before those three stories' diffs
landed) to get the real, current call-site surface before starting the sweep. This is the
single most important "read before implementing" step in this story: the whole point of the
Wave 4 sequencing is that this story's scope is DEFINED by what the prior three stories
actually shipped, not by a pre-implementation estimate.

**Nothing from the prior three stories requires special handling beyond "use the enlarged
surface"** — none of them introduce a data shape or error taxonomy this story needs to
adapt to; they only add MORE functions taking `profile: &str`, which this story's mechanical
sweep picks up along with everything else.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Infallible constructor | Staged ADR-0011 amendment, § Consequences (SR-017) | `impl From<String> for Profile` performs NO validation — any `String` constructs a `Profile` without error. Do NOT add a validating `Profile::try_new(name, cfg) -> Result<Profile>` — this ADR deliberately scopes the newtype to presence-not-correctness (existence validation already happens at config-lookup time, a separate concern). |
| Full in-scope function set | Staged ADR-0011 amendment § Decision items 2-4 | ALL `cache::{read_*,write_*,clear_*,invalidate_*}` functions in `src/cache.rs`, PLUS `src/api/auth.rs`'s 4 credential functions, PLUS `Config::active_profile_name`, PLUS `JiraClient::profile_name`. Do not scope this narrower than the amendment states (SR-006 already corrected an earlier draft that omitted `auth.rs` — do not reintroduce that gap). |
| Zero on-disk/keychain/wire-format impact | Staged ADR-0011 amendment | This is a PURE Rust type-level change. No data migration, no cache-root version bump, no keychain-namespace change, no serialized representation change. |
| Compiler is the primary regression net, cross-profile isolation tests remain the operative safety net for value-correctness | BC-6.2.015 Residual clause | A correctly-`Profile`-typed but semantically WRONG substitution is NOT caught by the type system. Run BC-6.2.009/BC-6.2.010 (cross-profile isolation tests) as part of this story's verification — do not treat "it compiles" as sufficient proof of correctness. |
| Apply the staged ADR-0011 amendment to `docs/adr/` | STATE.md "Constraints Carried Forward"; this story's own frontmatter/origin | This is a NAMED task (Task Item 1) — replace `docs/adr/0011-type-level-profile-fence.md`'s content with the staged amendment's content, verbatim (adjust only if the actual call-site count or `src/cache.rs` function count diverges materially from the staged document's `~60-80`/`12+` estimates — update those specific numbers to match reality, nothing else). |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` must pass — a large mechanical diff is exactly the shape where a stray unused-import or dead-code warning is easy to miss; run clippy incrementally, not just at the end. |

## Library and Framework Requirements

No new external dependencies. Pure Rust type-level change using only `std` (`String`,
`AsRef`, `Display`, `From`).

| Item | Version / Constraint |
|------|----------------------|
| N/A | no `Cargo.toml` changes |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/config.rs` (or a new small module, e.g. `src/profile.rs`) | CREATE (type) / MODIFY | Define `pub struct Profile(String)` with `From<String>`, `AsRef<str>`, `Display` impls. Change `Config::active_profile_name: String` → `Profile`. |
| `src/cache.rs` | MODIFY | All 16+ (re-verify exact count) `profile: &str`-taking functions → `profile: &Profile`. |
| `src/api/auth.rs` | MODIFY | `store_api_token`/`load_api_token`/`store_oauth_tokens`/`load_oauth_tokens` → `profile: &Profile`. `clear_profile_creds`/`clear_all_credentials` call sites updated to pass `&Profile`. |
| `src/api/client.rs` | MODIFY | `JiraClient::profile_name: String` → `Profile`; `profile_name()` accessor updated accordingly. |
| Every caller of the above (CLI handlers under `src/cli/auth/`, `src/cli/**`, wherever a cache/credential function or `active_profile_name`/`profile_name` is read) | MODIFY | Thread `&Profile`/`Profile` through; construct via `Profile::from(String)` at the boundary where a raw profile name string first becomes available (CLI arg parsing / config resolution). |
| `docs/adr/0011-type-level-profile-fence.md` | MODIFY | Replace with the staged amendment's content (Task Item 1 — explicit, named). |
| `CHANGELOG.md` | MODIFY | `[Unreleased]` entry — this is an internal refactor with no user-visible behavior change; a brief `Changed`/`Internal` note is sufficient (not a breaking-change entry, since `breaking_change: false`). |

**Files NOT to touch beyond signature/call-site changes:** no test's ASSERTIONS should need
to change (only their call sites' argument types) — if a test's expected VALUE changes as a
result of this story's diff, that is a signal something went wrong, not an expected
consequence of a "pure type-level change."

## Acceptance Criteria

### AC-001 — `Profile` newtype exists with the specified trait impls
`pub struct Profile(String)` exists with `impl From<String> for Profile`, `impl AsRef<str>
for Profile`, and a `Display` impl that renders identically to the wrapped string (no
bracket/quote decoration).
(traces to BC-6.2.015 postcondition — Decision item 1)

### AC-002 — every `src/cache.rs` per-profile function takes `&Profile`
Every `cache::{read_*,write_*,clear_*,invalidate_*}` function's `profile` parameter is typed
`&Profile`, not `&str`.
(traces to BC-6.2.015 postcondition — Decision item 2)

### AC-003 — `src/api/auth.rs`'s 4 credential functions take `&Profile`
`store_api_token`, `load_api_token`, `store_oauth_tokens`, `load_oauth_tokens` all take
`profile: &Profile`.
(traces to BC-6.2.015 postcondition — Decision item 2 sub-bullet, SR-006)

### AC-004 — `Config::active_profile_name` and `JiraClient::profile_name` are `Profile`-typed
Both fields change from `String` to `Profile`.
(traces to BC-6.2.015 postcondition — Decision items 3/4)

### AC-005 — a profile-unaware call site is a compile error
Attempting to call a per-profile cache or credential function with a bare `&str`/hardcoded
string literal (not wrapped in `Profile`) fails to compile.
(traces to BC-6.2.015 postcondition — the hard-fence guarantee itself; verified by
demonstration during code review / a deliberately-reverted local smoke test, not a runtime
test)

### AC-006 — `cargo build` succeeds and the full existing test suite passes unchanged
`cargo build` succeeds; `cargo test` passes with NO test assertion changes beyond call-site
argument-type adaptation (constructing a `Profile` instead of passing a bare `&str`).
(traces to BC-6.2.015 — "all risk is mechanical... not behavioral")

### AC-007 — cross-profile isolation tests (BC-6.2.009/BC-6.2.010) remain green, unmodified in assertion
The existing cross-profile isolation tests pass with only their `profile` argument
construction updated (`Profile::from("prod".to_string())` instead of `"prod"`), never their
assertions.
(traces to BC-6.2.015 Residual clause — the operative safety net for value-correctness)

### AC-008 — `docs/adr/0011-type-level-profile-fence.md` reflects the staged amendment
The `docs/adr/` file's `## Status` reads `Accepted` (not `Deferred`), and its content matches
the staged amendment (adjusted only for any call-site-count/function-count numbers that
diverge from the staged estimate at actual implementation time).
(traces to this story's explicit F4 obligation, STATE.md "Constraints Carried Forward")

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-newtype-1 | Staged ADR-0011 amendment | a `Profile` value that is correctly typed but names a NON-EXISTENT profile | not caught by the type system — existing config-lookup-by-name error handling (unaffected by this story) is the operative check |
| EC-newtype-2 | Staged ADR-0011 amendment | wrong-but-compiling `Profile` substitution (e.g. passing `prod`'s `Profile` where `sandbox`'s was intended) | NOT caught by the type system alone — AC-007's cross-profile isolation tests are the safety net for this class |

## Tasks

### Item 1: Apply the staged ADR-0011 amendment to `docs/adr/` (EXPLICIT, NAMED TASK)
- [ ] Read `.factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` in full
- [ ] Replace `docs/adr/0011-type-level-profile-fence.md`'s content with the staged
      amendment's content (Status: Deferred → Accepted; full Decision/Consequences/Sequencing
      body)
- [ ] If the actual `src/cache.rs` function count or call-site count diverges materially from
      the staged document's `12+`/`~60-80` figures, update those specific numbers to match
      reality — do not blindly copy stale estimates once the real diff is known
- [ ] This task MUST land in the SAME PR as the newtype implementation — do not defer it to a
      follow-up

### Item 2: Define the `Profile` newtype
- [ ] `pub struct Profile(String)` with `From<String>`, `AsRef<str>`, `Display`
- [ ] Unit tests: `Display` renders identically to the wrapped string; `From<String>`
      constructs without error for any input including empty string

### Item 3: Re-measure the call-site surface
- [ ] `grep -n 'pub fn ' src/cache.rs | grep 'profile: &str'` — confirm current count
- [ ] `grep -n 'profile: &str' src/api/auth.rs` — confirm current count
- [ ] Compare against this story's ~60-80 estimate; if materially larger, flag to the
      orchestrator BEFORE proceeding with the full sweep (possible split trigger)

### Item 4: Thread `Profile` through `src/cache.rs`
- [ ] Change every per-profile function signature `profile: &str` → `profile: &Profile`
- [ ] Update every call site

### Item 5: Thread `Profile` through `src/api/auth.rs`
- [ ] Change the 4 credential functions' signatures
- [ ] Update `clear_profile_creds`/`clear_all_credentials` call sites
- [ ] Update every CLI-handler call site (`login.rs`, `logout.rs`, `remove.rs`, `refresh.rs`,
      `status.rs`)

### Item 6: Thread `Profile` through `Config`/`JiraClient`
- [ ] `Config::active_profile_name: String` → `Profile`
- [ ] `JiraClient::profile_name: String` → `Profile`, update `profile_name()` accessor
- [ ] Update every remaining call site across `src/cli/**`

### Item 7: Verification
- [ ] `cargo build` succeeds
- [ ] `cargo test` — full suite green, no assertion changes beyond call-site type adaptation
- [ ] Confirm BC-6.2.009/BC-6.2.010 (cross-profile isolation tests) pass unmodified in assertion

### Item 8: CHANGELOG
- [ ] `[Unreleased]` internal-refactor note (no user-visible behavior change)

### Integration checks (all must pass before PR)
- [ ] `cargo test` exits 0 (full suite)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- Any behavioral change to what a cache/credential function DOES — this is a pure
  type-level signature change.
- A validating `Profile::try_new` constructor — explicitly rejected by the staged ADR-0011
  amendment's Consequences section.
- Any cache-root or keychain-namespace version bump — this story has zero on-disk/keychain
  impact by design.

## Dependency Analysis

**depends_on:** `["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard", "S-cycle3-remove-logout-semantics"]`
— see Anchor Justification above; this is the LAST of the credential-restructuring stories,
by design, so the call-site sweep runs exactly once over the final, enlarged surface.
**blocks:** `[]` — no other cycle-003 story has a hard functional dependency on `Profile`
existing, though `S-cycle3-oauth-default-creation` is recommended (not required) to land
after this story to avoid file-collision churn.

## Story Points and Effort

**13 story points** (large — the ceiling of the "no story exceeds 13 story points" rule).
Breakdown:
- Newtype definition + `docs/adr/` amendment application: 1.5 SP
- `src/cache.rs` sweep (12-16+ functions + call sites): 4 SP
- `src/api/auth.rs` sweep (4 functions + call sites): 2.5 SP
- `Config`/`JiraClient` field changes + remaining call sites: 3 SP
- Verification (full suite + cross-profile isolation confirmation): 2 SP

Risk: HIGH by footprint (single widest-file-footprint story in the cycle, ~60-80 call
sites), LOW-MEDIUM behavioral risk (compiler-checked). **SPLIT CANDIDATE**: if the real
call-site count at implementation time proves materially larger than ~60-80, split into a
`cache.rs`-only pass plus a separate `auth.rs`+`Config`+`JiraClient` pass — flag this to the
orchestrator at the start of Task Item 3 rather than after the diff has already grown
unwieldy. Recommend landing this story ALONE in its wave (no wave-mate) to avoid
merge-conflict churn against any other in-flight story touching `src/api/auth.rs` or
`src/cache.rs`.
