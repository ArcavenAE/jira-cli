---
document_type: story
story_id: "S-cycle3-percred-storage"
epic_id: "AUTH-PROFILE-DX-1"
title: "Per-profile API-token keychain storage: store_api_token/load_api_token (DEC-315)"
wave: feature-followup
status: ready
intent: feature
feature_type: feature
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 8
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
estimated_days: 3
target_module: src/api/auth.rs
subsystems: []
depends_on: []
blocks: ["S-cycle3-credential-absence-guard", "S-cycle3-remove-logout-semantics", "S-cycle3-oauth-default-creation", "S-cycle3-adr0011-newtype", "S-cycle3-chosen-flow-reconcile"]
behavioral_contracts:
  - "BC-1.4.031"
  - "BC-1.4.027"
  - "BC-1.1.009"
  - "BC-1.1.010"
  - "BC-1.2.017"
bcs:
  - "BC-1.4.031"
  - "BC-1.4.027"
  - "BC-1.1.009"
  - "BC-1.1.010"
  - "BC-1.2.017"
verification_properties:
  - "VP-AUTHDX-004"
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0020", "ADR-0007"]
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
  cycle-003 auth-profile-dx, Wave 1 (no deps, file-disjoint from S-cycle3-env-tag). Moves
  API-token credentials (email, api-token) from shared/flat keychain keys to per-profile-
  namespaced keys (<profile>:email / <profile>:api-token), symmetric with the existing OAuth
  pair's namespacing. Foundational primitive every other credential-touching cycle-003 story
  builds on (S-cycle3-credential-absence-guard, S-cycle3-remove-logout-semantics,
  S-cycle3-oauth-default-creation, S-cycle3-adr0011-newtype, S-cycle3-chosen-flow-reconcile).
---

# S-cycle3-percred-storage — Per-profile API-token keychain storage

## Revision Note (F7 pre-gate consistency-audit fix, HIGH-1)

`BC-1.4.027` (AMENDED — namespaced-key split) was present in this story's `bcs:`/
`behavioral_contracts:` frontmatter and body BC table, but no acceptance criterion cited it
explicitly. The shipped code already implements this coverage — AC-001/AC-002 exercise
exactly the namespaced-key store/load behavior BC-1.4.027 documents (email/api-token joining
the namespaced-key set). This is a documentation-traceability fix only: AC-001 and AC-002 now
carry an explicit `BC-1.4.027` trace alongside their existing `BC-1.4.031` trace. No AC text,
scope, coverage, or dependency was changed.

## Correction Note (Wave 1 integration-gate adversary, [process-gap], LOW)

Frontmatter `breaking_change` was corrected from `false` to `true`. Removing the legacy
flat-key read fallback (see "Current State" and Architecture Compliance Rules above — the
new `load_api_token` has no `"default"`-only legacy-migration branch, unlike
`load_oauth_tokens`) locks out every existing api-token profile, including `"default"`, on
upgrade until the user re-authenticates — that is a breaking change by definition, not an
invisible infrastructure change. The human-facing CHANGELOG entry (Item 6 of Tasks) already
carried the correct `BREAKING — Action required` framing; only the machine-readable
`breaking_change:` frontmatter field was out of sync with it. No ACs, coverage, or
dependencies were changed by this correction.

## Anchor Justification

**Dependency anchors:** `depends_on: []` — ADR-0020 § Sequencing item 2: "no dependencies."
This is the foundational per-profile credential-storage primitive.

**Blocks anchors:**
- `S-cycle3-credential-absence-guard` depends on this story because its `load_api_token`
  detect-and-instruct branch (BC-1.4.032) is layered directly on top of this story's
  namespaced-key-lookup step — the "try namespaced keys first" precondition BC-1.4.032
  Precondition 2 requires this story's functions to exist.
- `S-cycle3-remove-logout-semantics` depends on this story because `auth remove`'s new 4th
  delete step (BC-1.2.014) targets the `<profile>:email`/`<profile>:api-token` pair this
  story creates.
- `S-cycle3-oauth-default-creation` depends on this story because newly-OAuth-defaulted
  profiles' sibling API-token path must already be on the new per-profile storage model
  (ADR-0020 § Sequencing item 6).
- `S-cycle3-adr0011-newtype` depends on this story (transitively, via #3/#4) because the
  `Profile` newtype sweep must cover `store_api_token`/`load_api_token` as first-class
  in-scope functions (ADR-0020 §Decision item 2 sub-bullet) — sweeping before this story
  lands would mean re-sweeping once these functions exist.
- `S-cycle3-chosen-flow-reconcile` depends on this story transitively via `S-cycle3-oauth-default-creation`.

## Source of Truth

- `.factory/specs/prd/bc-1-auth-identity.md` §1.1 (BC-1.1.009/010), §1.2 (BC-1.2.017), §1.4
  (BC-1.4.027, BC-1.4.031)
- ADR-0020 § Decision 1 ("Per-profile API-token credential storage (DEC-315)")

## Narrative

As a `jr` user with multiple Jira profiles authenticating via API token,
I want each profile's `email`/`api-token` pair stored under its own namespaced keychain
keys,
so that logging in to a new sandbox profile can never silently reuse or overwrite a
different profile's API-token credential.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-1.4.031 | NEW | `store_api_token(profile, email, token)` / `load_api_token(profile)` — new functions in `src/api/auth.rs`, mirroring `store_oauth_tokens`/`load_oauth_tokens` byte-for-byte in shape |
| BC-1.4.027 | AMENDED | `email`/`api-token` join the namespaced-key set (`<profile>:email`/`<profile>:api-token`); only `oauth_client_id`/`oauth_client_secret` remain shared/flat |
| BC-1.1.009 | AMENDED | `auth login --profile <new>` writes the new profile's own namespaced pair (Effects clause only — config-write behavior unchanged) |
| BC-1.1.010 | AMENDED | `auth login --profile X` against `JR_PROFILE=ghost` writes `X`'s namespaced pair, never `ghost`'s and never a shared/flat pair |
| BC-1.2.017 | AMENDED | Same per-profile write clause as BC-1.1.010, `JR_PROFILE=ghost` scenario |

## Current State (read before implementing)

- `src/api/auth.rs` currently has FLAT, unscoped `load_api_token()` / (implicit)
  `store_api_token` logic keyed by constants `KEY_EMAIL`/`KEY_API_TOKEN` — no `profile`
  parameter at all (`~line 220`):
  ```rust
  pub fn load_api_token() -> Result<(String, String)> {
      let email = entry(KEY_EMAIL)?.get_password()...
      let token = entry(KEY_API_TOKEN)?.get_password()...
      Ok((email, token))
  }
  ```
  This story ADDS new, profile-scoped functions alongside/replacing this — do not simply
  rename the existing flat function; the flat reader/writer for `KEY_EMAIL`/`KEY_API_TOKEN`
  is what `S-cycle3-credential-absence-guard`'s "legacy pair" existence-check refers to, so
  it must still exist (unused as a credential source going forward) after this story lands.
- `store_oauth_tokens(profile: &str, access: &str, refresh: &str)` and
  `load_oauth_tokens(profile: &str)` (`~line 235`/`~253`) are the exact shape to mirror —
  namespaced key helpers `oauth_access_key(profile)`/`oauth_refresh_key(profile)` already
  exist; this story needs analogous `api_token_email_key(profile)`/
  `api_token_key(profile)`-style helpers (naming is an implementer choice, but keep the
  `<profile>:email`/`<profile>:api-token` wire format exact per BC-1.4.031 Postcondition 1).
- `read_keyring_optional(key: &str) -> Result<Option<String>>` (`~line 323`) is the existing
  `NoEntry`-vs-real-error distinguishing helper — REUSE it for
  `store_api_token`/`load_api_token`'s backend-error-vs-absent distinction (EC-1.4.031-2);
  do not write a second copy.
- `src/cli/auth/login.rs::login_token` (`~line 47`) is the call site that will switch from
  the flat writer to `store_api_token(profile, ...)`.
- `src/api/client.rs::JiraClient::from_config`'s `load_auth_from_keychain` (per BC-1.4.031
  Postcondition 3) is the read-side call site that must switch to `load_api_token(profile_name)`.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~5,200 |
| BC-1.4.031 (full) | ~2,600 |
| BC-1.4.027 (full) | ~1,200 |
| BC-1.1.009/010/BC-1.2.017 (full) | ~2,200 |
| `src/api/auth.rs` (relevant ~250 LOC: existing OAuth pair + flat api-token fns) | ~3,200 |
| `src/cli/auth/login.rs::login_token` (~70 LOC) | ~900 |
| `src/api/client.rs::from_config`/`load_auth_from_keychain` (~80 LOC) | ~1,000 |
| `cargo test` + keyring-gated test output | ~600 |
| **Total** | **~16,900** |

Well within 20-30% of a typical agent context window. No splitting required.

## Previous Story Intelligence

`S-cycle3-env-tag` (Wave 1 co-story) touches a file-disjoint surface (`src/config.rs`,
`src/cli/auth/list.rs`, `src/cli/auth/status.rs`) — no merge-conflict risk, no shared
intelligence to carry beyond the general channel-split precedent (not directly relevant
here — this story has no display-layer component).

**Key implementation precedent to follow exactly:** `store_oauth_tokens`/`load_oauth_tokens`
(`src/api/auth.rs:~235-311`). Read this pair FIRST. The new `store_api_token`/`load_api_token`
functions should mirror their signature shape and the `read_keyring_optional`-based
backend-error-vs-absent handling, but MUST NOT mirror the OAuth pair's legacy-fallback
behavior (the `if profile == "default"` lazy-migration branches at `~line 266` and `~line 293`)
— per BC-1.4.032 (owned by the NEXT story, `S-cycle3-credential-absence-guard`), the new
API-token reader has NO copy-then-delete branch for any profile, including `"default"`. This
story's `load_api_token` should return the plain "no stored credential" error for the
namespaced-keys-absent case; the detect-and-instruct wording refinement and the legacy-pair
existence check are `S-cycle3-credential-absence-guard`'s scope, not this story's — but this
story's error shape must be compatible with that follow-on story extending it (i.e., don't
hardcode a message this story's error uses that BC-1.4.032's exact wording would then have
to awkwardly override; coordinate on the message text in BC-1.4.032 Postcondition 2 if
convenient, or leave a clearly-marked TODO-style placeholder error for the next story to
finalize).

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Mirror `store_oauth_tokens`/`load_oauth_tokens` shape | BC-1.4.031 Invariant 1; ADR-0020 §Decision 1 | Straight signature change, not a new storage backend or isolation boundary. No change to Windows Credential Manager posture (SEC-WCM-DOC). |
| Backend-error vs. absent-key distinction | BC-1.4.031 EC-1.4.031-2 (I-5) | MUST use `read_keyring_optional`'s `Err(keyring::Error::NoEntry)`-vs-other-`Err` pattern byte-for-byte, mirroring `load_oauth_tokens`. A backend error propagates as its own distinct error, never coerced into the absent-credential message. |
| `oauth_client_id`/`oauth_client_secret` out of scope | BC-1.4.031 Postcondition 4 | Do NOT touch the BYO OAuth **app**-credential pair — different axis, still shared/flat. |
| No `"default"`-only branch in the new functions | BC-1.4.031 Invariant 2 | Unlike `load_oauth_tokens`, `load_api_token` has no legacy-migration special case for any profile in THIS story's scope — the detect-and-instruct legacy-pair check belongs to `S-cycle3-credential-absence-guard` (BC-1.4.032), not here. |
| `store_api_token`'s write is unconditional overwrite | BC-1.4.033 Postcondition 3 (forward reference — informs this story's write semantics even though the BC itself is owned by a later story) | `store_api_token` performs a plain two-key write (not read-modify-write), so a later `auth login` cleanly repairs a partial-write state with no bespoke recovery logic in the writer itself. |
| `JiraClient::from_config`'s `api_token` branch reads via `load_api_token(profile_name)` | BC-1.4.031 Postcondition 3 | Never the old flat-key reader, once this story lands. |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` must pass. |

## Library and Framework Requirements

No new external dependencies — reuses the existing `keyring` crate already in
`Cargo.toml` and the existing `entry()`/`read_keyring_optional()` helpers in
`src/api/auth.rs`.

| Item | Version / Constraint |
|------|----------------------|
| `keyring` | pinned version unchanged |
| `proptest` (dev-dependency, already present) | bounded generators only — see AC-005 note below (O-3) |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/api/auth.rs` | MODIFY | Add `store_api_token(profile: &str, email: &str, token: &str) -> Result<()>` and `load_api_token(profile: &str) -> Result<(String, String)>`, plus namespaced-key helper functions (`<profile>:email` / `<profile>:api-token`). Retain the existing flat `load_api_token()` (no-arg) function — rename it if needed to disambiguate (e.g. `load_legacy_flat_api_token()`), since a later story (`S-cycle3-credential-absence-guard`) needs an existence-only check against the legacy flat pair. |
| `src/cli/auth/login.rs` | MODIFY | `login_token`: switch from the flat writer to `store_api_token(profile, email, token)`. |
| `src/api/client.rs` | MODIFY | `JiraClient::from_config`'s `load_auth_from_keychain`, `api_token` branch: switch to `load_api_token(profile_name)`. |
| `tests/` (new or existing auth test file) | MODIFY/CREATE | `proptest` for VP-AUTHDX-004 (round-trip + cross-profile isolation, bounded generators) and a keyring-gated (`#[ignore]`, `JR_RUN_KEYRING_TESTS=1`) integration test against the real OS backend, mirroring the existing pattern in `src/api/auth.rs`'s inline tests / `tests/oauth_refresh_integration.rs`. |

**Files NOT to touch:** `src/cli/auth/remove.rs`, `src/cli/auth/logout.rs` (the 4-step
delete / non-destructive-logout changes are `S-cycle3-remove-logout-semantics`'s scope, not
this story's — this story only ADDS the storage primitive, it does not wire deletion).

## Acceptance Criteria

### AC-001 — `store_api_token` writes the namespaced pair
`store_api_token(profile, email, token)` writes `email` under `<profile>:email` and `token`
under `<profile>:api-token`.
(traces to BC-1.4.031 postcondition 1; BC-1.4.027 — `email`/`api-token` joining the
namespaced-key set)

### AC-002 — `load_api_token` reads back the same namespaced pair, no shared/flat fallback
`load_api_token(profile)` returns exactly the pair written by `store_api_token(profile, ...)`
when both namespaced keys are present — no shared/flat fallback for a profile whose
namespaced keys already exist.
(traces to BC-1.4.031 postcondition 2; BC-1.4.027 — namespaced-key read supersedes the
prior shared/flat behavior)

### AC-003 — `JiraClient::from_config`'s `api_token` branch reads via `load_api_token`
`load_auth_from_keychain`'s `api_token` branch calls `load_api_token(profile_name)`, never
the old flat-key reader.
(traces to BC-1.4.031 postcondition 3)

### AC-004 — `oauth_client_id`/`oauth_client_secret` untouched
This story's diff does not modify `store_oauth_app_credentials`/`load_oauth_app_credentials`
or their keys.
(traces to BC-1.4.031 postcondition 4)

### AC-005 — round-trip + cross-profile isolation property test (VP-AUTHDX-004)
A `proptest` with BOUNDED generators (realistic ASCII API-token-shaped strings; RFC
5321/5322-constrained email-shaped strings — NOT an unbounded arbitrary-byte fuzz, per O-3)
asserts: (a) for any profile and any valid `(email, token)`, `store_api_token` then
`load_api_token` returns exactly `(email, token)`; (b) for any two distinct profiles `p1 ≠
p2`, after `store_api_token(p1, e1, t1)`, `load_api_token(p2)` never returns `(e1, t1)` nor
any component of it.
(traces to BC-1.4.031 VP-AUTHDX-004)

### AC-006 — keyring-gated end-to-end round-trip against the real OS backend
A `#[ignore]`-gated test (`JR_RUN_KEYRING_TESTS=1`) proves AC-005's round-trip property
against the real macOS Keychain / Windows Credential Manager / Linux Secret Service backend,
not just an in-memory double.
(traces to BC-1.4.031 VP-AUTHDX-004, F6 target)

### AC-007 — backend error vs. absent-key distinction (I-5)
A simulated keychain BACKEND error (not `NoEntry`) on `load_api_token`/`store_api_token`
propagates as its own distinct error naming the backend problem — never coerced into a
"no stored credential" message.
(traces to BC-1.4.031 EC-1.4.031-2)

### AC-008 — brand-new profile with no keys at all → actionable "no credential" error shape
A profile with no namespaced keys and no legacy flat keys returns an actionable error
mirroring `load_oauth_tokens`'s non-default absent-case error shape (exact final wording is
finalized by `S-cycle3-credential-absence-guard`; this story's placeholder message must be
compatible with that refinement, not contradictory).
(traces to BC-1.4.031 EC-1.4.031-1)

### AC-009 — `login_token` writes via `store_api_token`, namespaced not shared
`jr auth login --profile <new>` (and the `JR_PROFILE=ghost` variants of BC-1.1.010/BC-1.2.017)
write `<new>:email`/`<new>:api-token` — never a shared/flat pair, never the `JR_PROFILE`-
resolved absent profile's namespace.
(traces to BC-1.1.009/BC-1.1.010/BC-1.2.017 Effects clauses)

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-1.4.031-1 | BC-1.4.031 | brand-new, non-`"default"` profile, no namespaced or legacy keys | actionable "no stored credential, run `jr auth login`" error (AC-008) |
| EC-1.4.031-2 | BC-1.4.031 | keychain backend error vs. genuine absence | distinct, non-coerced error (AC-007) |

## Tasks

### Item 1: Read the OAuth pair pattern
- [ ] Read `src/api/auth.rs::store_oauth_tokens`/`load_oauth_tokens` (`~line 235-311`) end to end
- [ ] Read `read_keyring_optional` (`~line 323`)
- [ ] Confirm the existing flat `load_api_token()` (no-arg) function and `KEY_EMAIL`/`KEY_API_TOKEN` constants — decide the disambiguating rename

### Item 2: New per-profile functions
- [ ] Add `api_token_email_key(profile)` / `api_token_key(profile)` (or equivalent) namespaced-key helpers
- [ ] Implement `store_api_token(profile, email, token) -> Result<()>`
- [ ] Implement `load_api_token(profile) -> Result<(String, String)>` — namespaced-only, no legacy fallback, using `read_keyring_optional`
- [ ] Rename the existing flat no-arg `load_api_token()` to avoid a name collision (e.g. `load_legacy_flat_api_token()`), confirm all its existing callers still compile

### Item 3: Wire the write side
- [ ] `login_token` (`src/cli/auth/login.rs`): switch to `store_api_token(profile, email, token)`
- [ ] Verify AC-009 with an integration test (or existing `#[ignore]`-gated test extension)

### Item 4: Wire the read side
- [ ] `JiraClient::from_config`'s `load_auth_from_keychain`, `api_token` branch: switch to `load_api_token(profile_name)`
- [ ] Verify AC-003

### Item 5: Tests
- [ ] AC-001/002/004/007/008 unit tests
- [ ] AC-005 bounded `proptest` (VP-AUTHDX-004)
- [ ] AC-006 keyring-gated integration test (`#[ignore]`, `JR_RUN_KEYRING_TESTS=1`)

### Item 6: CHANGELOG
- [ ] Add `[Unreleased] > Changed` CHANGELOG entry describing per-profile API-token storage (this is infrastructure invisible to most users until `S-cycle3-credential-absence-guard` ships the breaking-change consequence — keep the entry factual/neutral, not alarming, since the actual breaking-change user notice belongs to that follow-on story per BC-1.4.034's F4 doc-fallout obligation)

### Integration checks (all must pass before PR)
- [ ] `cargo test` exits 0 (full suite; keyring-gated tests skipped by default)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- The no-copy detect-and-instruct final error wording and the legacy-pair existence check —
  `S-cycle3-credential-absence-guard` (BC-1.4.032/033/034).
- `auth remove`'s 4th delete step and `auth logout`'s non-destructive notice —
  `S-cycle3-remove-logout-semantics` (BC-1.2.013/014).
- `Profile` newtype threading — `S-cycle3-adr0011-newtype`.
- Interactive OAuth-default picker / non-interactive flags — `S-cycle3-oauth-default-creation`.

## Dependency Analysis

**depends_on: []** — root story alongside `S-cycle3-env-tag`.
**blocks:** `S-cycle3-credential-absence-guard`, `S-cycle3-remove-logout-semantics`,
`S-cycle3-oauth-default-creation`, and (transitively) `S-cycle3-adr0011-newtype`,
`S-cycle3-chosen-flow-reconcile` — see Anchor Justification above for the specific technical
reason each depends on this story.

## Story Points and Effort

**8 story points** (medium). Breakdown:
- New keychain functions (store/load, namespaced-key helpers): 2 SP
- `client.rs` branch switch + `login_token` integration: 1.5 SP
- Backend-error-vs-absent distinction (I-5): 1 SP
- 3 amended BCs' write-side clause verification (BC-1.1.009/010, BC-1.2.017): 1 SP
- Bounded-generator property test (VP-AUTHDX-004): 1.5 SP
- Keyring-gated integration test: 1 SP

Risk: HIGH-adjacent (module criticality HIGH — sits on the auth-header composition hot path)
but well-bounded scope: this is a straight mirror of an existing, already-proven function
pair. The main risk is getting the backend-error-vs-absent distinction (EC-1.4.031-2) right,
since `S-cycle3-credential-absence-guard` builds its entire detect-and-instruct contract on
top of this story's error taxonomy — do not rush Task Item 2/5.
