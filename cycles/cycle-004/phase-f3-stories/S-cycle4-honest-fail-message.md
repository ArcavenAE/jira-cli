---
document_type: story
level: ops
story_id: "S-cycle4-honest-fail-message"
epic_id: "WINDOWS-CORRECTNESS-1"
title: "Honest-fail backstop: accurate DpapiFallbackFailed messaging + required grant-revoke instruction (#759)"
wave: 2
status: draft
intent: bug-fix
feature_type: backend
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 5
priority: P0
tdd_mode: strict
producer: story-writer
timestamp: "2026-09-04T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md"
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/cycles/cycle-004/phase-f3-stories/S-cycle4-dpapi-storage-fix.md"
input-hash: "d4cbe50"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md"
cycle: cycle-004-windows-correctness
estimated_effort: small
estimated_days: 2
target_module: src/api/auth.rs
subsystems: ["SS-03"]
depends_on: ["S-cycle4-dpapi-storage-fix"]
blocks: []
behavioral_contracts:
  - "BC-1.4.039"
bcs:
  - "BC-1.4.039"
verification_properties:
  - "VP-AUTHDX-017"
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0021"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-09-04"
version: "1.4"
last_updated: "2026-09-05"
breaking_change: false
retroactive: false
origin: >
  cycle-004 windows-correctness, Wave 2 (depends on S-cycle4-dpapi-storage-fix for the
  DpapiFallbackFailed/ProfilePathEscape marker types). Implements DEC-334/DEC-335's
  honest-fail backstop for #759: two of the four existing "Unlock your keychain"
  message sites in src/api/auth.rs are revised to branch on the new typed markers,
  replacing the misdirecting message with accurate, scenario-specific text and making
  the dangling Atlassian grant revoke a required remediation step (login site only) --
  never for the refresh site, where the grant may still back other active sessions.
  Per DEC-335, this story ships in the SAME RELEASE as S-cycle4-dpapi-storage-fix, not
  as an independent, ahead-of-schedule fast-follow.
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. Message-selection logic on a
> security-critical error path, not a facade candidate.

> **Execute:** `/vsdd-factory:deliver-story S-cycle4-honest-fail-message`

# S-cycle4-honest-fail-message — Honest-fail backstop for the two revised message sites

> **Revision note (v1.3 → v1.4, DEC-334 correction, 2026-09-05):** AC-002 and AC-004
> rewritten to apply the product-owner's amended BC-1.4.039, issued this session after an
> adversarial review CONFIRMED the prior Site-1 guidance — "state the grant-revoke step
> ... as a REQUIRED action" — was account-wide-harmful: Atlassian's
> `https://id.atlassian.com/manage-profile/apps` revoke has no per-profile granularity, so
> requiring it for a single-profile Site-1 failure would sign the user out of every other
> `jr` profile on that Atlassian account. Validated by
> `.factory/research/atlassian-3lo-revoke-granularity-2026-09-05.md`. AC-002 now recommends
> `jr auth logout`/`jr auth remove` (scoped to the one profile) as the DEFAULT cleanup, and
> demotes the account-wide grant-revoke to an OPTIONAL step carrying an explicit
> account-wide warning. AC-004 is retitled and corrected to match: Site 3's legacy message
> stays byte-for-byte unchanged, but Site 1's legacy message is no longer asserted
> unchanged — its final grant-revoke sentence is corrected to the same
> scoped-default/optional-warned-revoke guidance AC-002 establishes. No other AC, the BC/VP
> anchors (BC-1.4.039 / VP-AUTHDX-017), or the AC count (7) changed. See DEC-334 in
> `.factory/cycles/cycle-004/` decision log for the full adversarial-finding record.
>
> **Revision note (v1.2 → v1.3, F3 round-3 re-review comprehensive fix pass, 2026-09-04):**
> appended the anchoring `VP-AUTHDX-017` citation to AC-001 and AC-006 — both are within
> VP-AUTHDX-017's oracle (AC-001's `ProfilePathEscape`-checked-first-at-both-sites
> rendering is the VP's own "`ProfilePathEscape` RENDERING, checked FIRST" clause; AC-006's
> "Sites 2 and 4 confirmed unaffected" is the VP's own Site-2/Site-4-unaffected
> confirmation clause) but had omitted the citation while every other BC-1.4.039-scope AC
> in this story already carried it (F3 round-3 re-review Finding #2 — comprehensive sweep
> of all four cycle-004 stories' ACs for the same omission class).
>
> **Revision note (v1.1 → v1.2, F3 re-review comprehensive fix pass, 2026-09-04):**
> (1) added a `CHANGELOG.md` row to File Structure Requirements — Task 14 already required
> a CHANGELOG entry, but the file itself was missing from this table, and it is
> concurrently edited by all three other cycle-004 stories; also clarified that
> `tests/oauth_refresh_integration.rs`, if extended rather than sibling-created, is the
> SAME file `S-cycle4-dpapi-storage-fix` modifies (F3 re-review Finding #1; see
> `conflict-report.md` §1/§4, `wave-schedule.md` §2/§3); (2) `dependency-graph-extended.md`
> §6's re-derived BC Clause Coverage Matrix classifies BC-1.4.039 Invariants 1/2 as
> descriptive/compound properties already established by the union of this story's
> postcondition-tracing ACs (AC-001-004/AC-006/AC-007), not independently testable new
> assertions — no story-body change needed for that finding (F3 re-review Finding #2).

## Anchor Justification

**Subsystem anchor:** `SS-03` — same module (`src/api/auth.rs`) and same anchor rationale
as `S-cycle4-dpapi-storage-fix`; this story only revises two existing `map_err` closures
within that already-anchored file, adding no new module.

**Dependency anchor:** `depends_on: ["S-cycle4-dpapi-storage-fix"]` because Site 1
(`oauth_login`'s store-failure `map_err`) and Site 3
(`refresh_oauth_token_with_url`'s post-refresh store-failure `map_err`) both branch on
`e.downcast_ref::<auth_windows_store::DpapiFallbackFailed>()` and
`e.downcast_ref::<auth_windows_store::ProfilePathEscape>()` (BC-1.4.039 Postcondition 1)
— neither type exists until `S-cycle4-dpapi-storage-fix` creates
`src/api/auth_windows_store.rs`. This is a hard compile-time dependency, not merely a
scheduling preference, and it is the mechanism that realizes DEC-335's "bundle 1+2 into
one release" instruction: this story cannot even build, let alone land, ahead of
`S-cycle4-dpapi-storage-fix`.

**No `blocks` entries:** nothing else in cycle-004's F3 scope depends on this story.

## Source of Truth

- `.factory/specs/prd/bc-1-auth-identity.md` §1.4, BC-1.4.039 (read in full for this
  story).
- `ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md` §6 ("Honest-fail backstop —
  reachable only when BOTH keyring AND the DPAPI store fail").
- `architecture-delta.md` §2.1 (module interface table, `DpapiFallbackFailed` row), §3
  (Sites 1/3 rows).

## Narrative

As a `jr` user on Windows whose OAuth token is too large for BOTH Credential Manager AND
the new DPAPI-encrypted-file fallback, I want an accurate error message that tells me
exactly what failed and what to do next — including whether I need to revoke a dangling
Atlassian grant — instead of the misleading "Unlock your keychain" message that told me to
retry an action that would fail identically every time.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-1.4.039 | NEW | Sites 1 (`oauth_login` store-failure) and 3 (`refresh_oauth_token_with_url` post-refresh store-failure) branch, in order, on `ProfilePathEscape` then `DpapiFallbackFailed`; each of the two `DpapiFallbackFailed` arms gets DISTINCT message text (Site 1 recommends scoped `jr auth logout`/`jr auth remove` cleanup by default and presents the account-wide `manage-profile/apps` revoke as OPTIONAL with an explicit account-wide warning; Site 3 contains no revoke advice at all); Site 3 additionally proactively clears the profile's now-stale stored pair; Sites 2 and 4 confirmed unaffected |

## Acceptance Criteria

### AC-001 — `ProfilePathEscape` checked first at both sites
At Sites 1 and 3, `e.downcast_ref::<ProfilePathEscape>()` is checked BEFORE
`DpapiFallbackFailed` and before the generic "Unlock your keychain" fallback; a `Some(_)`
match renders the SAME distinct exit-64 invalid-profile-name `JrError::UserError` as the
read path (BC-1.4.036) at both sites — never the honest-fail message, never "Unlock your
keychain."
(traces to BC-1.4.039 postcondition 1 (`ProfilePathEscape` bullet), invariant 4; VP-AUTHDX-017)

### AC-002 — Site 1 (login) honest-fail message offers scoped cleanup by default, account-wide revoke as optional
When `e.downcast_ref::<DpapiFallbackFailed>()` is `Some(_)` at Site 1, the message names
the 2560-byte Credential Manager limit and the fallback failure (`{inner}`), instructs the
user to check disk space/permissions and re-run `jr auth login --oauth --profile {profile}`,
and recommends `jr auth logout --profile {profile}` / `jr auth remove {profile}` as the
DEFAULT cleanup step (scoped to this one profile). The
`https://id.atlassian.com/manage-profile/apps` grant-revoke is presented as an OPTIONAL
step only, carrying an explicit warning that it is ACCOUNT-WIDE — it signs out every `jr`
profile authenticated against that same Atlassian account, not just the profile that hit
this failure. This replaces the prior "required, no other consumer" framing, which
Perplexity-validated research
(`.factory/research/atlassian-3lo-revoke-granularity-2026-09-05.md`) confirmed is
CONFIRMED-harmful: Atlassian's per-account grant-revoke page has no per-profile/per-site
granularity, so recommending it as required guidance for a single-profile failure would
sign the user out of every other `jr` profile on that account.
(traces to BC-1.4.039 postcondition 1 (Site 1 `Some(_)` bullet); VP-AUTHDX-017)

### AC-003 — Site 3 (refresh) honest-fail message MUST NOT instruct grant revoke
When `e.downcast_ref::<DpapiFallbackFailed>()` is `Some(_)` at Site 3, the message names
the same limit/fallback failure and instructs a fresh `jr auth login --oauth --profile {profile}`,
but contains NO grant-revoke instruction of any kind — the oracle asserts its ABSENCE,
since the grant may still back other active sessions for the profile and revoking it
would destroy working auth.
(traces to BC-1.4.039 postcondition 1 (Site 3 `Some(_)` bullet); VP-AUTHDX-017)

### AC-004 — Neither marker matched → legacy message corrected at Site 1 only (account-wide-harmful sentence replaced)
Given ANY store error without either marker (a genuine lock/permission `keyring::Error` on
the small-secret path, or — on macOS/Linux, always, per BC-1.4.035 invariant 3 — a backend
error where DPAPI was never engaged): Site 3's legacy "Unlock your keychain (or grant
access to jr)…" message fires BYTE-FOR-BYTE UNCHANGED. Site 1's legacy message is
corrected — ONLY its final grant-revoke sentence is replaced with the scoped-cleanup-by-
default / optional-account-wide-warned-revoke guidance established in AC-002 (the same
`jr auth logout`/`jr auth remove` default plus the optional, account-wide-warned
`https://id.atlassian.com/manage-profile/apps` step); the rest of Site 1's legacy message
text is otherwise unchanged. This replaces the prior framing where the `None` branch was
asserted unchanged at BOTH sites — that framing is no longer accurate once Site 1's
harmful final sentence is corrected, per DEC-334.
(traces to BC-1.4.039 postcondition 1 (`None` bullet); VP-AUTHDX-017)

### AC-005 — Site 3 proactive stale-pair clear
When Site 3's `DpapiFallbackFailed` branch fires, `refresh_oauth_token_with_url`
additionally clears the profile's now-stale stored OAuth pair (via the same deletion step
`clear_profile_oauth_pair` provides, BC-1.4.038) as part of returning the honest-fail
error — tolerating absence as the expected common case (the delete-first ordering in
`S-cycle4-dpapi-storage-fix` usually already removed it; this clear is retained,
NotFound-tolerant, as defense-in-depth and must not be optimized away as apparent dead
code). This does NOT apply to Site 1 — the oracle asserts Site 1 clears nothing.
(traces to BC-1.4.039 postcondition 4; VP-AUTHDX-017)

### AC-006 — Sites 2 and 4 confirmed unaffected
Site 2 (`refresh_oauth_token_with_url`'s `load_oauth_tokens` read-failure branch) gets no
message-text change of its own — it becomes DPAPI-aware transitively via
`S-cycle4-dpapi-storage-fix`'s `load_oauth_tokens` correction. Site 4
(`resolve_refresh_app_credentials`'s BYO app-credential-read error) is UNCHANGED; this
story's Tasks include an F4 AUDIT (not a code change) confirming no `TooLong` path is
reachable there (client_id/client_secret are short strings by construction).
(traces to BC-1.4.039 postconditions 2/3; VP-AUTHDX-017)

### AC-007 — Non-Windows unreachability, direct proof
Feeding a mocked `keyring::Error::TooLong` into `store_oauth_tokens` on a non-Windows test
run WITH `JR_FORCE_DPAPI_FALLBACK` UNSET asserts the LEGACY "Unlock your keychain" message
appears at both sites — never the honest-fail text — proving the `DpapiFallbackFailed`
`Some(_)` arm is dead code on macOS/Linux release builds, not merely improbable.
(traces to BC-1.4.039 invariant 3; VP-AUTHDX-017)

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `oauth_login`'s store-failure `map_err` (Site 1) | `src/api/auth.rs` | Effectful Shell (error-mapping within an already-effectful function) |
| `refresh_oauth_token_with_url`'s post-refresh store-failure `map_err` (Site 3) | `src/api/auth.rs` | Effectful Shell |
| Message-selection logic itself (marker downcast + string selection) | `src/api/auth.rs` | Pure Core (deterministic function of the error value; testable with constructed error values, no I/O) |

## UX Screens

N/A — CLI-only, no UI surface.

## Design System Components

N/A — not a UI story.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-1.4.039-1 | Genuine lock/permission error on the small-secret keyring path (never reaches `TooLong`) | `None` downcast at both sites; existing "Unlock your keychain" message fires correctly (majority case, and — on macOS/Linux release builds — the ONLY reachable case) |
| EC-1.4.039-2 | DPAPI fallback write fails for a reason other than disk-full/permission | `{inner}` interpolation carries whatever diagnostic the underlying `anyhow::Error` provides; this BC pins the template and trigger condition, not every `{inner}` value |
| EC-1.4.039-3 | A future refactor accidentally lets `TooLong` reach Site 4 | Out-of-scope residual; F4 confirms unreachable via audit, not a code change |
| EC-1.4.039-4 | Refresh-path store-failure data loss: the single-use refresh token is already consumed server-side by the time Site 3's `DpapiFallbackFailed` fires | Resolved by AC-005's proactive clear — the stale pair never surfaces a confusing `invalid_grant` on next use |
| EC-1.4.039-5 | Site 1's or Site 3's store error contains `ProfilePathEscape` | Checked FIRST, before `DpapiFallbackFailed` and the generic fallback; renders the same distinct invalid-profile-name error as the read path |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| Message-selection function (marker downcast → text) | Pure Core | Deterministic given an error value; no I/O, testable with constructed `anyhow::Error` chains |
| `oauth_login`, `refresh_oauth_token_with_url` (the enclosing functions) | Effectful Shell (unchanged) | Already effectful (network + credential I/O) before this cycle; only the internal message-selection sub-logic is factored as pure |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|---------------|-----------------|
| This story spec | ~2,600 |
| BC-1.4.039 (full) | ~4,200 |
| ADR-0021 §6 | ~1,500 |
| `src/api/auth.rs` (the four message sites, ~150 LOC total, post-`S-cycle4-dpapi-storage-fix`) | ~2,000 |
| `auth_windows_store.rs`'s marker-type definitions (read-only reference) | ~500 |
| Existing/new test files | ~1,500 |
| `cargo test` output | ~500 |
| **Total** | **~12,800** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~6%** |

Well within budget — this is the smallest story in the cycle by design (a focused,
message-selection-only change layered on top of `S-cycle4-dpapi-storage-fix`'s
infrastructure).

## Tasks

1. [ ] Write failing tests for Site 1's three-way branch (`ProfilePathEscape` /
   `DpapiFallbackFailed` / `None`) — AC-001, AC-002, AC-004
2. [ ] Write failing tests for Site 3's three-way branch, including the DISTINCT
   (grant-revoke-free) message text — AC-001, AC-003, AC-004
3. [ ] Write failing test for Site 3's proactive stale-pair clear (seam over
   `clear_profile_oauth_pair` / `load_oauth_tokens`-returns-`Ok(None)` afterward), and that
   Site 1 clears nothing — AC-005
4. [ ] Write failing test proving non-Windows unreachability with the seam UNSET — AC-007
5. [ ] Implement the Site 1 and Site 3 `map_err` closures per BC-1.4.039 Postcondition 1
6. [ ] Implement Site 3's proactive clear call (BC-1.4.039 Postcondition 4)
7. [ ] AUDIT (do not modify unless a real defect is found) Site 4
   (`resolve_refresh_app_credentials`) to confirm no `TooLong` path is reachable — AC-006
8. [ ] Confirm Site 2 requires no message-text change (relies on
   `S-cycle4-dpapi-storage-fix`'s `load_oauth_tokens` correction) — AC-006
9. [ ] Verify purity boundaries against the table above
10. [ ] Update STATE.md (state-manager, not this story's implementer)
11. [ ] Verify Red Gate (all new tests fail before implementation)
12. [ ] Refactor
13. [ ] Run the FULL existing `src/api/auth.rs` test suite byte-for-byte green as a gate
    on this story's PR (regression-critical — this story edits two long-lived,
    heavily-tested message sites)
14. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` describing the honest-fail
    message change, before creating the PR

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| `S-cycle4-dpapi-storage-fix` | Defines `DpapiFallbackFailed`/`ProfilePathEscape`/`CorruptSecretFile` as typed, never-string-matched marker errors on `src/api/auth_windows_store.rs`; the `JR_FORCE_DPAPI_FALLBACK` debug-only seam and its `env_lock`-style mutex serialization requirement | Use `e.downcast_ref::<T>()` for marker discrimination, never `.to_string().contains(...)` | Every test that sets/reads/unsets `JR_FORCE_DPAPI_FALLBACK` MUST serialize via the SAME `env_lock`-style `std::sync::Mutex` `S-cycle4-dpapi-storage-fix`'s tests use — this story's AC-007 (env-UNSET legacy-message assertion) is the DIRECT counterpart of that story's seam-engaged tests and MUST participate in the identical mutex, or `cargo test`'s default parallelism can interleave the two opposing-outcome classes |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|-----------|
| Marker discrimination is type-based (`downcast_ref`), never string-matched | BC-1.4.039 Description | Code review; AC-001-004 tests construct typed errors, never string-pattern errors |
| `ProfilePathEscape` checked BEFORE `DpapiFallbackFailed` at both sites | BC-1.4.039 Postcondition 1, Invariant 4 | AC-001 |
| Site 1 and Site 3 message text is DISTINCT, never a shared verbatim template | BC-1.4.039 Description; ADR-0021 §6 | AC-002/AC-003 — code review must reject a shared-template refactor |
| Honest-fail message unreachable on macOS/Linux in release builds | BC-1.4.039 Invariant 3 | AC-007 |
| `JR_FORCE_DPAPI_FALLBACK`-touching tests serialize via the shared `env_lock` mutex | BC-1.4.039 Trace (Pass-6 Finding #4) | Code review; reuse the mutex `S-cycle4-dpapi-storage-fix` introduces, do not create a second one |
| Site 3's proactive clear is retained even though typically redundant with the delete-first write ordering | BC-1.4.039 Postcondition 4 (Pass-7 Finding #2) | Code review must reject removing this call as "dead code" |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| (none new) | — | This story introduces no new dependency — it consumes the marker types `S-cycle4-dpapi-storage-fix` already adds to `Cargo.toml`'s existing dependency graph |

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/auth.rs` | MODIFY | Site 1 (`oauth_login`'s store-failure `map_err`) and Site 3 (`refresh_oauth_token_with_url`'s post-refresh store-failure `map_err`) message-selection logic; Site 3's proactive `clear_profile_oauth_pair` call |
| `tests/oauth_refresh_integration.rs` or a new sibling test file | MODIFY/CREATE | Message-selection unit tests (AC-001-004, AC-007) and the Site-3-clear seam test (AC-005), reusing `S-cycle4-dpapi-storage-fix`'s `env_lock` mutex — NOTE: if extending the existing file (rather than creating a sibling), this is the SAME `tests/oauth_refresh_integration.rs` `S-cycle4-dpapi-storage-fix` (Wave 1) also modifies; resolved by wave sequencing (Wave 1 → Wave 2), see `conflict-report.md` §4 |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Fixed` entry per Task 14 (F3 story-review Finding #1) — this file is ALSO edited by `S-cycle4-dpapi-storage-fix` (Wave 1), `S-cycle4-cloud-id-correctness` (Wave 1), and `S-cycle4-windows-docs` (Wave 2, parallel); see `conflict-report.md` §1/§4 and `wave-schedule.md` §2/§3 for the cross-story `[Unreleased]`-section hotspot analysis — each story appends its OWN distinct bullet line, so this is a trivial append-collision, not a real conflict |

**Files NOT to touch:** `src/api/auth_windows_store.rs` (read-only reference to its marker
types — no changes), `src/cli/auth/*` (no CLI-layer change needed), `src/cli/auth/login.rs`
and `src/cli/auth/refresh.rs` (`cloud_id`-related changes are
`S-cycle4-cloud-id-correctness`'s scope, unrelated to this story), `README.md`
(`S-cycle4-windows-docs`'s scope).

## Out of Scope

- Any change to `src/api/auth_windows_store.rs` itself (the module and its marker types
  are `S-cycle4-dpapi-storage-fix`'s scope; this story only consumes them).
- `cloud_id` acquisition — `S-cycle4-cloud-id-correctness`.
- README/documentation — `S-cycle4-windows-docs`.
- Site 4 code changes — audit-only per AC-006/Task 7.

## Dependency Analysis

**depends_on:** `["S-cycle4-dpapi-storage-fix"]` — see Anchor Justification above (hard
compile-time dependency on the marker types).

**blocks:** `[]` — terminal node in cycle-004's dependency graph.

**Release bundling (DEC-335):** this story and `S-cycle4-dpapi-storage-fix` ship in the
SAME cycle-004 release. The `depends_on` edge (Wave 1 → Wave 2) is the mechanism that
enforces this — honest-fail-message cannot be released ahead of, or independently from,
the durable fix, closing F1 §12 item 6's open question in favor of "land together," not
"fast-follow independently."

## Story Points and Effort

**5 story points** (small). Breakdown:
- Site 1/Site 3 message-selection logic + distinct text: 2 SP
- Site 3 proactive clear + defense-in-depth reasoning tests: 1.5 SP
- Non-Windows unreachability proof + `env_lock` serialization: 1 SP
- Site 4 audit + regression-suite gate: 0.5 SP

Risk: MEDIUM — small, well-bounded diff on a HIGH-criticality module, but the two message
sites are user-facing and the "must NOT share one verbatim template" requirement (Pass-2
adversarial review Finding #3) is easy to violate accidentally during a later refactor;
code review should watch for this specifically.
