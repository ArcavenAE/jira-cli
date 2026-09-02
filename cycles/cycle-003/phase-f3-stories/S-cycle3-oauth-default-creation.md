---
document_type: story
story_id: "S-cycle3-oauth-default-creation"
epic_id: "AUTH-PROFILE-DX-1"
title: "OAuth-default-at-creation picker + non-interactive guard + --oauth/--api-token flags (DEC-313/DEC-323)"
wave: feature-followup
status: draft
intent: feature
feature_type: feature
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 13
priority: P0
tdd_mode: strict
producer: story-writer
timestamp: "2026-09-01T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md"
  - ".factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
input-hash: "9c093c7"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md"
cycle: cycle-003-auth-profile-dx
estimated_effort: x-large
estimated_days: 5
target_module: src/cli/auth/login.rs
subsystems: []
depends_on: ["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard", "S-cycle3-remove-logout-semantics"]
blocks: ["S-cycle3-chosen-flow-reconcile"]
behavioral_contracts:
  - "BC-1.1.013"
  - "BC-1.1.014"
  - "BC-1.1.015"
  - "BC-1.1.016"
  - "BC-1.2.049"
  - "BC-1.2.050"
bcs:
  - "BC-1.1.013"
  - "BC-1.1.014"
  - "BC-1.1.015"
  - "BC-1.1.016"
  - "BC-1.2.049"
  - "BC-1.2.050"
verification_properties:
  - "VP-AUTHDX-001"
  - "VP-AUTHDX-002"
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0020"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 15
assumption_validations: []
risk_mitigations: ["R-cycle3-ci-hang"]
created: "2026-09-01"
version: "1.0"
last_updated: "2026-09-01"
breaking_change: false
retroactive: false
origin: >
  cycle-003 auth-profile-dx, Wave 5 (depends on S-cycle3-percred-storage,
  S-cycle3-credential-absence-guard, and -- per the orchestrator's explicit dependency
  addition -- S-cycle3-remove-logout-semantics, since BC-1.1.013 EC-1.1.013-2's
  re-declaration credential-clear reuses clear_profile_creds's API-token-pair branch, which
  S-cycle3-remove-logout-semantics adds; recommended, not required, to also land after
  S-cycle3-adr0011-newtype to avoid file-collision churn). `jr auth login` bare/interactive
  defaults to an OAuth-first picker mirroring `jr init` (DEC-313); non-interactive invocation
  is airtight-guarded to NEVER launch a browser, covering both the no-flag default (BC-1.1.014)
  and the explicit --oauth / implicit oauth-profile-refresh cases (BC-1.1.016, closes
  adversarial finding I-1); new symmetric --oauth (deprecated alias)/--api-token flags land
  on both `auth login` and `auth refresh` (DEC-323). NOTE: S-MAINT-532 (draft, pre-existing
  story) is explicitly OUT OF SCOPE for this cycle and is not folded into this story or any
  other cycle-003 story.
---

# S-cycle3-oauth-default-creation — OAuth-default-at-creation picker + non-interactive guard + `--oauth`/`--api-token` flags

## Anchor Justification

**Dependency anchors:**
- `depends_on: "S-cycle3-percred-storage"` — newly-OAuth-defaulted profiles' sibling
  API-token path (for a later mechanism switch, or a non-interactive fallback) must already
  be on the new per-profile storage model (ADR-0020 § Sequencing item 6).
- `depends_on: "S-cycle3-credential-absence-guard"` — same rationale; this story's
  non-interactive api-token default path (BC-1.1.014) must resolve credentials through the
  final, redesigned `load_api_token` error taxonomy, not the pre-redesign shape.
- `depends_on: "S-cycle3-remove-logout-semantics"` — **ORCHESTRATOR-ADDED dependency,
  beyond ADR-0020's literal "#2/#3" Sequencing text.** BC-1.1.013 EC-1.1.013-2 requires that
  when a mechanism-switching `auth login` re-declaration clears the OUTGOING mechanism's
  credentials, it "reus[es] the same per-kind clear branches `auth remove` uses
  (`clear_profile_creds`'s OAuth-pair and API-token-pair deletion...)." The API-token-pair
  deletion branch inside `clear_profile_creds`/`clear_all_credentials` is added BY
  `S-cycle3-remove-logout-semantics` (BC-1.2.014's 4th step) — this story's re-declaration
  credential-clear logic has a REAL CODE dependency on that story's output, not merely a
  conceptual one. Without this dependency, this story's EC-1.1.013-2/EC-1.1.014-4
  implementation would have nothing to call for the API-token-pair-clear half of the
  re-declaration sequence.

**Blocks anchors:** `S-cycle3-chosen-flow-reconcile` depends on this story per ADR-0020 §
Sequencing item 7 ("depends on #6") — that story removes `chosen_flow_for_profile`'s
`oauth_override` parameter entirely, which presupposes this story's `--oauth`/`--api-token`
flags already exist and are wired to `refresh_credentials` in their (about-to-become-inert)
form.

**Recommended, non-blocking sequencing note:** land after `S-cycle3-adr0011-newtype` per that
story's file-collision-avoidance rationale (both touch `src/api/auth.rs` and
`src/cli/auth/login.rs`) — not a hard dependency, but avoids rebase churn.

**Out-of-scope confirmation:** `S-MAINT-532` (a pre-existing DRAFT story covering the
global `--profile` fallback coverage gap on Login/Refresh/Logout) is explicitly NOT folded
into this story, per the orchestrator's directive. This story's `LoginArgs`/`RefreshArgs`
changes touch the same composition logic `S-MAINT-532` would test, but that story remains a
fully separate, independently-scheduled item outside cycle-003 — do not reference it as a
dependency or sub-task anywhere in this story's implementation.

## Source of Truth

- `.factory/specs/prd/bc-1-auth-identity.md` §1.1 (BC-1.1.013/014/015/016), §1.2
  (BC-1.2.049/050) — **read BC-1.1.013, BC-1.1.014, and BC-1.1.016 in full, in that order**;
  they form one interlocking precedence/guard system and must not be implemented from
  summary alone.
- ADR-0020 § Decision 5 ("`auth_method` as an intrinsic, creation-time-only profile
  property"), § Decision 8 ("Non-interactive OAuth guard is airtight")
- `.factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` §2
  ("Auth-Mechanism-Selection Flow: Creation-Time vs. Runtime"), §2.3 ("Non-interactive OAuth
  guard, hardened")

## Narrative

As a `jr` user running `jr auth login` interactively for the first time,
I want the mechanism picker to default to OAuth (matching `jr init`'s existing behavior),
so that the two entry points are consistent and I get the more secure, token-rotating
default without having to know to ask for it.

As a script or CI pipeline running `jr auth login`/`jr auth refresh` non-interactively,
I want an airtight guarantee that NO invocation — bare, `--oauth`-flagged, or against an
already-oauth profile's `refresh` — ever attempts to launch a browser or bind the OAuth
callback listener,
so that my automation never hangs waiting on a redirect that can never complete.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-1.1.013 | NEW | `jr auth login` bare + interactive → OAuth-default picker mirroring `jr init`; re-declaration credential-clear (EC-1.1.013-2, O-1/SR-011) |
| BC-1.1.014 | NEW | non-interactive `jr auth login` (no flag) always selects `api_token`, never launches a browser (VP-AUTHDX-001 base case); SR-010 negative-space cell (interactive TTY + env vars present → picker still shown) |
| BC-1.1.015 | NEW | `JiraClient::from_config`'s `.unwrap_or("api_token")` runtime default for an UNSET `auth_method` field is unchanged — regression pin (VP-AUTHDX-002) |
| BC-1.1.016 | NEW | airtight non-interactive OAuth guard: explicit `--oauth` OR implicit oauth-profile `refresh`, under any non-interactive trigger → exit 64 fail-fast BEFORE any network/listener/browser code (closes I-1; VP-AUTHDX-001 extended cells) |
| BC-1.2.049 | NEW | `--oauth` retained as a deprecated-but-accepted alias, stderr-only deprecation notice (never under `--output json`) |
| BC-1.2.050 | NEW | new, symmetric `--api-token` flag; functional on `login`, inert-with-notice on `refresh` (O-2/CV-2) |

## Current State (read before implementing)

- `src/cli/mod.rs`'s `AuthCommand::Login`/`AuthCommand::Refresh` variants (`~line 214-247`
  for `Login`, `~line 261-...` for `Refresh`) currently declare `oauth: bool` only — no
  `--api-token` flag exists yet. This story adds it to BOTH variants.
- `src/cli/auth/login.rs::LoginArgs` (`~line 232`) currently has `pub oauth: bool` — this
  story adds `pub api_token: bool` (or equivalent naming), mutually exclusive with `oauth`
  (clap `conflicts_with`).
- `src/cli/auth/refresh.rs::RefreshArgs<'a>` (`~line 44`) currently has `pub oauth: bool` —
  same addition needed, same mutual exclusion.
- `src/cli/init.rs::handle` is the REFERENCE implementation for the OAuth-default picker —
  read it before writing this story's picker code; BC-1.1.013 requires byte-identical
  behavior (items, default index) between `jr init`'s existing picker and this story's new
  `auth login` picker.
- `src/cli/auth/mod.rs::chosen_flow_for_profile` (`~line 107`) currently has an
  `oauth_override: bool` parameter that, when `true`, unconditionally returns
  `AuthFlow::OAuth` — this is the pre-cycle-003 override mechanism BC-1.2.051 (owned by
  `S-cycle3-chosen-flow-reconcile`, NOT this story) will remove. This story does NOT touch
  `chosen_flow_for_profile`'s override semantics — it only ADDS the `--api-token` flag
  alongside the existing `--oauth` flag on the SAME two commands. The removal of the
  override's EFFECT is the next story's scope; this story's job is purely: (a) the
  creation-time picker, (b) the non-interactive guards, (c) the two flags' presence/parsing/
  deprecation-notice plumbing.
- `src/cli/auth/refresh.rs`'s doc comment on the clear-then-relogin helper (`~line 24-33`,
  above `refresh_credentials`) currently reads "Ordering is clear-then-login" — this is the
  I-6 self-contradiction BC-1.2.051 (again, `S-cycle3-chosen-flow-reconcile`'s scope) fixes.
  Do NOT attempt to fix the ordering in THIS story — only be aware it exists so this story's
  own non-interactive-guard precondition check (BC-1.1.016) is inserted BEFORE that existing
  (soon-to-be-reordered) logic runs, not interleaved with it.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~7,000 |
| BC-1.1.013 (full — the largest single precedence-bearing BC) | ~3,800 |
| BC-1.1.014 (full) | ~3,600 |
| BC-1.1.015 (full) | ~1,600 |
| BC-1.1.016 (full) | ~2,400 |
| BC-1.2.049/050 (full) | ~2,800 |
| `src/cli/auth/login.rs` (full, `handle_login` + `LoginArgs` + `login_token`/`login_oauth`) | ~3,500 |
| `src/cli/auth/refresh.rs` (full) | ~1,800 |
| `src/cli/init.rs::handle` (picker reference, relevant excerpt) | ~800 |
| `cargo test` output for verification | ~700 |
| **Total** | **~28,000** |

Approaches the upper end of a 20-30% context-window allocation. **SPLIT CANDIDATE** — see
Story Points below for the recommended split point (creation-time picker + flags vs.
non-interactive guards) if the `login.rs`+`refresh.rs`+`mod.rs` diff proves larger than
expected once file-level scoping is done.

## Previous Story Intelligence

**`S-cycle3-remove-logout-semantics`** landed the API-token-pair branch inside
`clear_profile_creds`. This story's EC-1.1.013-2/EC-1.1.014-4 re-declaration credential-clear
logic calls that function directly (with the OUTGOING mechanism implied by which of the two
branches — OAuth-pair or API-token-pair — actually needs clearing) — read that story's final
`clear_profile_creds` signature and confirm it clears BOTH kinds correctly before wiring this
story's re-declaration logic on top of it. Do NOT re-implement per-kind clearing inline in
`login.rs`/`refresh.rs` — call `clear_profile_creds`, matching the reuse requirement BC-1.1.013
EC-1.1.013-2 states explicitly.

**`S-cycle3-credential-absence-guard`** finalized `load_api_token`'s error taxonomy
(BC-1.4.032/033). This story's non-interactive default path (BC-1.1.014) that falls through
to api-token credential resolution on a profile with NO stored credential yet (a brand-new
profile) should surface that story's actionable error, not a bespoke one — do not duplicate
error text.

**Cross-story fixture awareness — `auth list` 5-column snapshot break (DEC-324, owned by
`S-cycle3-env-tag`, NOT this story's scope to implement, but load-bearing for this story's
own test fixtures):** by the time this story lands (Wave 5, after Wave 1's
`S-cycle3-env-tag`), `jr auth list`'s table snapshot has ALREADY moved from 4 columns
(`NAME, URL, AUTH, STATUS`) to 5 (`NAME, URL, ENV, AUTH, STATUS`) per BC-1.6.046's amended,
deliberately-breaking insta-snapshot contract. Any test THIS story writes or extends that
asserts on `jr auth list`'s table output — e.g., a test confirming a newly-OAuth-defaulted
profile (or a profile created via the new `--api-token` flag) appears correctly in `auth
list` after `handle_login` completes — MUST assume the 5-column, `ENV`-inclusive shape, not
the pre-cycle-003 4-column shape. Do NOT write a new `auth list` assertion against the old
4-column snapshot, and do NOT re-litigate or re-break the `ENV` column here — it is
`S-cycle3-env-tag`'s already-landed, already-reviewed contract by this story's Wave. If this
story's own test suite needs a fresh `auth list` fixture row for a newly-created profile,
extend the EXISTING 5-column fixture `S-cycle3-env-tag` produced rather than reintroducing a
4-column one.

**Key implementation risk (read twice):** BC-1.1.016's guard-ordering invariant is THE single
most safety-critical requirement in this story. The non-interactive × (explicit `--oauth` OR
implicit oauth-profile `refresh`) check MUST be evaluated as a PRECONDITION, before any
network call, callback-listener bind, or browser-open attempt in EITHER `handle_login` or
`refresh_credentials` — not a timeout on an already-started flow. Get the ordering wrong and
a CI runner can still hang despite this story's tests passing (a test using a mocked/short-
circuited network layer would not catch a guard inserted too late in real execution order).
Write the guard as the FIRST statement in the relevant code path, before any `Config::load`
side effect that could itself block, and cover it with a test that would fail if the guard
were moved even one statement later (e.g. assert a listener-bind call is never reached via a
call-count/mock assertion, not just assert the final exit code).

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Creation-time mechanism-selection precedence (SR-012) | BC-1.1.013 Invariant 2 | explicit `--oauth`/`--api-token` flag **>** non-interactive default (BC-1.1.014) **>** interactive OAuth-default picker (BC-1.1.013). Each tier consulted only when every tier above does not apply. |
| Picker byte-identical to `jr init`'s | BC-1.1.013 Invariant 1 | Same items (`["OAuth 2.0 (recommended)", "API Token"]`), same `.default(0)`. No divergent copy/wording/default between the two entry points. |
| SR-010: env vars are NOT an independent non-interactive trigger | BC-1.1.014 Precondition 1 | `JR_EMAIL`/`JR_API_TOKEN` presence alone, on an otherwise-interactive TTY session, does NOT suppress the picker. Only `--no-input` or non-TTY stdin trigger the non-interactive default. |
| Re-declaration credential-clear is a MUST | BC-1.1.013 EC-1.1.013-2, BC-1.1.014 EC-1.1.014-4 (M-1) | A mechanism-switching re-declaration (interactive OR non-interactive) MUST clear the outgoing mechanism's credentials via `clear_profile_creds`'s existing per-kind branches, BEFORE or ALONGSIDE writing the new mechanism's credentials. A SAME-mechanism re-declaration is a plain overwrite — no clear step needed. |
| Non-interactive mechanism-switch stderr notice is a SHOULD, not a MUST | BC-1.1.014 EC-1.1.014-4 | Implement it (do not omit), but do not over-engineer it as a hard requirement with its own error path. |
| BC-1.1.016's guard MUST fire before any network/listener/browser code | BC-1.1.016 Postcondition 3 | Precondition-evaluated, not a timeout/cancellation of an already-started flow. Applies in BOTH `handle_login` and `refresh_credentials`. |
| BC-1.1.016 exact stderr string | BC-1.1.016 Postcondition 2 | `"OAuth requires an interactive terminal; use --api-token for non-interactive auth."` — fixed constant, no interpolation. |
| `--output json` gets the standard exit-64 envelope | BC-1.1.016 Postcondition 4; CLAUDE.md #526 | `{"error": "<message>", "code": 64}` — route through `output::render_json`. |
| `--oauth`/`--api-token` mutually exclusive | BC-1.2.050 Invariant 1 | clap `conflicts_with`, exit 2 on both present. |
| Deprecation/inertness notices: stderr-only, human-mode-only, never under `--output json` | BC-1.2.049 Postcondition 2, EC-1.2.049-1; BC-1.2.050 Postcondition 3 (O-2/CV-2) | Gated on OUTPUT FORMAT, not TTY-ness. |
| `--api-token` on `refresh` is inert-with-notice | BC-1.2.050 Postcondition 3 | Syntactically accepted, zero effect on mechanism selection, but MUST emit the parity notice (worded for inertness, not deprecation). |
| Runtime `.unwrap_or("api_token")` fallback unchanged | BC-1.1.015 | Do NOT touch `JiraClient::from_config`'s absent-`auth_method` fallback literal — this story's picker only affects CREATION time, never the runtime absent-field default. |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` must pass. |

## Library and Framework Requirements

No new external dependencies. Uses the existing `dialoguer` crate (`Select`, already used
by `jr init`) and `clap` (`conflicts_with`, already used elsewhere in this CLI surface).

| Item | Version / Constraint |
|------|----------------------|
| `dialoguer` | pinned version unchanged |
| `clap` | pinned version unchanged |
| `proptest` (dev-dependency, already present) | VP-AUTHDX-001's 2-member non-interactive trigger set × credential-presence/absence matrix, plus extended cells |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/cli/mod.rs` | MODIFY | `AuthCommand::Login`/`AuthCommand::Refresh`: add `--api-token` flag, `conflicts_with = "oauth"`. |
| `src/cli/auth/login.rs` | MODIFY | `LoginArgs`: add `api_token: bool`. `handle_login`: insert the BC-1.1.016 precondition guard FIRST; implement the BC-1.1.013 interactive picker (mirroring `src/cli/init.rs::handle`); implement BC-1.1.014's non-interactive default; wire BC-1.2.049's deprecation notice and BC-1.2.050's flag handling; implement the EC-1.1.013-2/EC-1.1.014-4 re-declaration credential-clear via `clear_profile_creds`. |
| `src/cli/auth/refresh.rs` | MODIFY | `RefreshArgs`: add `api_token: bool`. `refresh_credentials`: insert the BC-1.1.016 precondition guard FIRST (implicit oauth-profile case); wire BC-1.2.050's inert-with-notice behavior for `--api-token`. |
| `src/cli/init.rs` | READ-ONLY reference | Do not modify — this is the picker's model implementation, cited not duplicated logic-wise (a small shared helper is acceptable if it avoids literal duplication, but is not required by the BC). |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Added` entry: OAuth-default creation-time picker, `--api-token` flag; `[Unreleased] > Deprecated` entry for `--oauth`'s new deprecation notice. |

**Files NOT to touch:** `src/cli/auth/mod.rs::chosen_flow_for_profile`'s override
SEMANTICS (only read it, do not remove the `oauth_override` parameter or change its
behavior — that is `S-cycle3-chosen-flow-reconcile`'s scope).

## Acceptance Criteria

### AC-001 — bare interactive `auth login` shows the OAuth-default picker
`jr auth login` with neither `--oauth` nor `--api-token`, interactive TTY, presents
`["OAuth 2.0 (recommended)", "API Token"]` with `.default(0)`.
(traces to BC-1.1.013 postcondition 1)

### AC-002 — picker selection drives the actual flow for this invocation
The user's picker selection is written as the profile's `auth_method` and determines which
flow (`login_oauth`/`login_token`) runs.
(traces to BC-1.1.013 postcondition 2)

### AC-003 — mechanism-switching re-declaration clears the outgoing mechanism's credentials
An existing profile re-running bare interactive `auth login` that selects a DIFFERENT
mechanism than its current `auth_method` clears the outgoing mechanism's credentials via
`clear_profile_creds`, before/alongside writing the new mechanism's credentials.
(traces to BC-1.1.013 EC-1.1.013-2)

### AC-004 — same-mechanism re-declaration is a plain overwrite, no clear step
A re-declaration selecting the SAME mechanism as current `auth_method` performs an ordinary
overwrite via the existing write path — no separate clear call.
(traces to BC-1.1.013 EC-1.1.013-2)

### AC-005 — non-interactive `auth login` (no flag) always selects `api_token`, never a browser (VP-AUTHDX-001 base case)
A `proptest` over the 2-member non-interactive trigger set `{--no-input set, stdin not a
TTY}` crossed with credential-completeness state: `auth_method` resolves to `api_token`;
callback listener on port 53682 is never bound; no browser-open call is ever made.
(traces to BC-1.1.014 VP-AUTHDX-001 base case)

### AC-006 — SR-010 negative-space cell: interactive TTY + env vars present → picker still shown
An interactive TTY session (no `--no-input`, stdin IS a TTY) with `JR_EMAIL`/`JR_API_TOKEN`
both set still presents the picker; `auth_method` is not silently forced to `api_token`.
(traces to BC-1.1.014 EC-1.1.014-3, VP-AUTHDX-001 negative-space cell)

### AC-007 — non-interactive mechanism switch also clears outgoing credentials (M-1)
`jr auth login prod` run non-interactively against an existing profile whose CURRENT
`auth_method` is `oauth` clears `prod`'s OAuth pair as part of the same invocation, before/
alongside writing the new `api_token` credentials.
(traces to BC-1.1.014 EC-1.1.014-4)

### AC-008 — non-interactive mechanism switch emits an informational stderr notice (SHOULD)
The same scenario as AC-007 emits an informational stderr line naming the mechanism change.
(traces to BC-1.1.014 EC-1.1.014-4, SHOULD — implemented, not treated as a hard MUST failure mode)

### AC-009 — runtime `.unwrap_or("api_token")` fallback is byte-for-byte unchanged (VP-AUTHDX-002)
A `proptest` over arbitrary `ProfileConfig` field combinations holding `auth_method: None`
fixed asserts `JiraClient::from_config` always resolves to exactly `"api_token"`.
(traces to BC-1.1.015 VP-AUTHDX-002)

### AC-010 — explicit `--oauth` under any non-interactive trigger → exit 64, fail-fast
`jr auth login --oauth` (or `jr auth refresh --oauth`) under `--no-input`/non-TTY exits 64
with the exact BC-1.1.016 stderr string, and the callback listener/browser are never reached.
(traces to BC-1.1.016 postcondition 1/2/3, precondition 2a)

### AC-011 — implicit oauth-profile `refresh` under any non-interactive trigger → exit 64, fail-fast
`jr auth refresh <profile>` (no flag, or `--api-token`, per BC-1.2.051's inertness — not yet
landed but this story's guard must already account for the flag having no override power)
against a profile whose `auth_method == "oauth"`, under a non-interactive trigger, exits 64
identically.
(traces to BC-1.1.016 postcondition 1/2/3, precondition 2b)

### AC-012 — guard fires BEFORE any network/listener/browser code (ordering proof)
A test proves the guard check happens before any listener-bind or HTTP call is attempted —
e.g., via a call-count/mock assertion on the listener-bind function, not merely the final
exit code.
(traces to BC-1.1.016 postcondition 3)

### AC-013 — `--oauth` deprecation notice: stderr-only, human-mode-only
`jr auth login --oauth` (interactive, functional path) emits the deprecation notice to
stderr in table/human mode; under `--output json`, no notice appears on stderr either.
(traces to BC-1.2.049 postcondition 2, EC-1.2.049-1)

### AC-014 — `--api-token` functional on `login`, inert-with-notice on `refresh`
`jr auth login --api-token` selects `api_token` directly, skipping the picker. `jr auth
refresh --api-token <profile>` is syntactically accepted but has zero effect on mechanism
selection, and emits the inertness notice (stderr-only, human-mode-only).
(traces to BC-1.2.050 postcondition 1/2/3)

### AC-015 — `--oauth`/`--api-token` mutual exclusion
Both flags on the same invocation → clap exit 2.
(traces to BC-1.2.050 invariant 1)

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-1.1.013-1 | BC-1.1.013 | `--oauth`/`--api-token` supplied explicitly | picker skipped entirely, flag's mechanism used directly |
| EC-1.1.013-2 | BC-1.1.013 | mechanism-switching re-declaration | outgoing credentials cleared (AC-003/004) |
| EC-1.1.014-1 | BC-1.1.014 | `--no-input` set, no credentials available at all | falls through to pre-existing non-interactive credential-resolution error (unchanged) |
| EC-1.1.014-2 | BC-1.1.014 | non-TTY stdin without explicit `--no-input` | still classified non-interactive |
| EC-1.1.014-3 | BC-1.1.014 | interactive TTY + env vars present (SR-010) | picker IS shown (AC-006) |
| EC-1.1.014-4 | BC-1.1.014 | non-interactive mechanism switch | outgoing credentials cleared + SHOULD notice (AC-007/008) |
| EC-1.1.016-1 | BC-1.1.016 | `--oauth` non-interactively for a BRAND NEW profile | still fails fast — no exception for creation |
| EC-1.1.016-2 | BC-1.1.016 | `refresh` non-interactively, profile is `api_token` | Precondition 2(b) does NOT match — proceeds via ordinary api-token relogin |
| EC-1.1.016-3 | BC-1.1.016 | `refresh --api-token`, profile is `oauth`, non-interactive | still fails fast (inert flag has no override power) |
| EC-1.2.049-1 | BC-1.2.049 | `--oauth --output json` | no deprecation notice on stderr either (AC-013) |
| EC-1.2.049-2 | BC-1.2.049 | `--oauth` + `--api-token` | clap exit 2 (AC-015) |
| EC-1.2.050-1 | BC-1.2.050 | `--api-token` + `--no-input` + complete credentials | succeeds identically to the pre-existing non-interactive path |
| EC-1.2.050-2 | BC-1.2.050 | `--api-token` interactively with incomplete credentials | falls through to existing interactive credential-prompt behavior |

## Tasks

### Item 1: Read the reference implementation and the interlocking BC trio
- [ ] Read `src/cli/init.rs::handle`'s picker code in full
- [ ] Read BC-1.1.013, BC-1.1.014, BC-1.1.016 in full, in that order (they interlock — do not implement from summary)
- [ ] Confirm `S-cycle3-remove-logout-semantics`'s final `clear_profile_creds` signature/branches

### Item 2: Add the `--api-token` flag
- [ ] `src/cli/mod.rs`: add `--api-token` to `AuthCommand::Login`/`Refresh`, `conflicts_with = "oauth"`
- [ ] `LoginArgs`/`RefreshArgs`: add the corresponding field
- [ ] AC-015 test

### Item 3: Implement the BC-1.1.016 airtight guard FIRST
- [ ] Insert the guard as the FIRST statement in `handle_login` and `refresh_credentials`'s relevant code paths
- [ ] AC-010/011/012 tests, including the ordering-proof test (call-count/mock assertion)

### Item 4: Implement the creation-time picker (BC-1.1.013)
- [ ] Mirror `jr init`'s picker exactly (items, default index)
- [ ] Wire the SR-012 precedence: explicit flag > non-interactive default > picker
- [ ] Implement EC-1.1.013-2's re-declaration credential-clear via `clear_profile_creds`
- [ ] AC-001/002/003/004 tests

### Item 5: Implement the non-interactive default (BC-1.1.014)
- [ ] Precondition 1's SR-010-corrected trigger set (`--no-input`/non-TTY only, NOT env-var presence alone)
- [ ] EC-1.1.014-4's non-interactive mechanism-switch clear + SHOULD notice
- [ ] AC-005/006/007/008 tests, VP-AUTHDX-001 proptest (base + negative-space + extended cells)

### Item 6: Regression pin (BC-1.1.015)
- [ ] Confirm `JiraClient::from_config`'s fallback literal is untouched
- [ ] AC-009 proptest (VP-AUTHDX-002)

### Item 7: Deprecation/inertness notices (BC-1.2.049/050)
- [ ] `--oauth` deprecation notice, stderr-only, human-mode-only
- [ ] `--api-token` functional-on-login / inert-with-notice-on-refresh
- [ ] AC-013/014 tests

### Item 8: CHANGELOG
- [ ] `[Unreleased] > Added`: OAuth-default picker, `--api-token` flag
- [ ] `[Unreleased] > Deprecated`: `--oauth` deprecation notice

### Integration checks (all must pass before PR)
- [ ] `cargo test` exits 0 (full suite)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- Removing `chosen_flow_for_profile`'s `oauth_override` parameter/effect —
  `S-cycle3-chosen-flow-reconcile` (BC-1.2.048/051).
- Fixing `refresh`'s "clear-then-relogin"/"relogin-then-replace" ordering (I-6) —
  `S-cycle3-chosen-flow-reconcile`'s scope; this story's own guard insertion must not
  interleave with that (not-yet-fixed) logic, only precede it.
- `S-MAINT-532`'s global `--profile` fallback test coverage — explicitly NOT folded into
  this story per the orchestrator's directive; remains a fully separate, out-of-cycle item.

## Dependency Analysis

**depends_on:** `["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard", "S-cycle3-remove-logout-semantics"]`
— see Anchor Justification above; the `remove-logout-semantics` edge is the
orchestrator-directed addition beyond ADR-0020's literal Sequencing text.
**blocks:** `S-cycle3-chosen-flow-reconcile` — see Anchor Justification above.

## Story Points and Effort

**13 story points** (large — the SECOND story at the 13-point ceiling). Breakdown:
- BC-1.1.016 airtight guard (both command handlers) + ordering-proof tests: 3 SP
- BC-1.1.013 creation-time picker + re-declaration credential-clear: 3 SP
- BC-1.1.014 non-interactive default + SR-010 fix + M-1 mechanism-switch clear: 2.5 SP
- BC-1.1.015 regression pin: 0.5 SP
- BC-1.2.049/050 flags + notices: 2.5 SP
- Integration + CHANGELOG: 1.5 SP

Risk: HIGH — module criticality HIGH (`handle_login` is the entry point for every new
profile's credential establishment; the airtight guard is a correctness-critical ordering
invariant). **SPLIT CANDIDATE**: if the `login.rs`+`refresh.rs`+`mod.rs` diff proves larger
than expected once file-level scoping is done, a natural split point is "creation-time
picker + flags" (BC-1.1.013/1.2.049/1.2.050) vs. "non-interactive guards"
(BC-1.1.014/015/016) — flag this to the orchestrator early rather than after the diff has
already grown unwieldy.
