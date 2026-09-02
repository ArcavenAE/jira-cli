---
document_type: story
story_id: "S-cycle3-credential-absence-guard"
epic_id: "AUTH-PROFILE-DX-1"
title: "No-copy detect-and-instruct guard for absent per-profile API-token credentials (DEC-326)"
wave: feature-followup
status: ready
intent: feature
feature_type: feature
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 8
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
input-hash: "b46de8b"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md"
cycle: cycle-003-auth-profile-dx
estimated_effort: large
estimated_days: 3.5
target_module: src/api/auth.rs
subsystems: []
depends_on: ["S-cycle3-percred-storage"]
blocks: ["S-cycle3-remove-logout-semantics", "S-cycle3-adr0011-newtype", "S-cycle3-oauth-default-creation", "S-cycle3-chosen-flow-reconcile"]
behavioral_contracts:
  - "BC-1.4.032"
  - "BC-1.4.033"
  - "BC-1.4.034"
  - "BC-1.4.025"
  - "BC-1.4.029"
bcs:
  - "BC-1.4.032"
  - "BC-1.4.033"
  - "BC-1.4.034"
  - "BC-1.4.025"
  - "BC-1.4.029"
verification_properties:
  - "VP-AUTHDX-005"
  - "VP-AUTHDX-006"
  - "VP-AUTHDX-007"
  - "VP-AUTHDX-008"
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0020"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 12
assumption_validations: []
risk_mitigations: ["R-cycle3-credential-leak"]
created: "2026-09-01"
version: "1.0"
last_updated: "2026-09-01"
breaking_change: true
retroactive: false
origin: >
  cycle-003 auth-profile-dx, Wave 2 (depends on S-cycle3-percred-storage). THE HIGH-RISK
  STORY IN THIS CYCLE (F1 delta analysis §3). Implements the F2-gate-redesigned (DEC-326,
  HUMAN DECISION) no-copy detect-and-instruct contract for load_api_token's absent-credential
  branch: the legacy shared flat email/api-token pair is NEVER read as a credential, NEVER
  copied into any profile's namespaced slot, and NEVER deleted -- for any profile, including
  "default". This REPLACES the original copy-then-delete migration design in full. Formalizes
  the resulting one-time breaking-change contract (BC-1.4.034): every pre-cycle-003
  api-token profile loses working auth on first post-upgrade use until it runs
  `jr auth login <profile>` exactly once.
---

# S-cycle3-credential-absence-guard — No-copy detect-and-instruct guard for absent per-profile API-token credentials

**Renamed from F1's preliminary `S-cycle3-percred-migration`.** That design (lazy
copy-then-delete of the shared flat pair) was REJECTED at the F2 gate (DEC-326, HUMAN
DECISION) — see ADR-0020 § Decision 2 for the full rationale: a Basic-auth email/token pair
carries no environment binding, so copying it can silently hand a freshly sandbox/uat-tagged
profile the same credential as whatever environment the legacy pair happens to belong to
(in practice, usually production). This story implements the REDESIGNED, no-copy contract.
There is no migration left in this story's scope.

## Wave 1 integration-gate finding (MED) — adversary-recommended enhancement

The Wave 1 integration-gate adversary found that during the migration window this cycle
introduces, `jr auth list` and `jr auth status` DISAGREE about a pre-cycle-003 api-token
profile's credential state: `auth list`'s STATUS column is config-only (`url.is_some()` →
`configured`), while `auth status`'s Credentials line actually probes the keychain via
`load_api_token`. Concretely, a pre-cycle-003 api-token profile shows STATUS=`configured` in
`auth list` but `Credentials: not found` in `auth status` — the exact detect-and-instruct
condition this story exists to surface (BC-1.4.032) is invisible on the `auth list` surface.

Since this story is specifically about making credential absence visible and actionable, it
should EVALUATE making `auth list`'s STATUS column credential-aware — i.e., probe presence
the same way `auth status` does (existence-only, same discipline as the legacy-pair check
above: never surfacing values, only presence) — so the two surfaces stop disagreeing during
the very migration window this story is designed to smooth over.

Disposition: implement this if it fits cleanly within this story's existing scope and file
list (`src/cli/auth/list.rs` is not currently in this story's File Structure Requirements —
see `S-cycle3-env-tag`, the Wave 1 co-story, which does touch that file, for a possible
integration point). If it does not fit cleanly, the story's delivery must explicitly flag it
as a tracked follow-up in the PR description rather than silently dropping it — do not let
this finding disappear unaddressed.

This is an ADDED consideration only. It does not modify, replace, or supersede any existing
AC, coverage requirement, or dependency in this story.

**Related, not folded in:** a separate Wave 1 LOW finding observed that `auth status` (a
documented read-only probe) can transitively trigger the OAuth `"default"`-profile lazy
migration WRITE via `load_oauth_tokens`. That is pre-existing OAuth behavior tracked
separately from this cycle and is noted here only so it is not confused with the MED finding
above — it is out of scope for this story.

## Anchor Justification

**Dependency anchors:** `depends_on: ["S-cycle3-percred-storage"]` — ADR-0020 § Sequencing
item 3: "depends on #2 (needs the per-profile reader/writer to exist)." `load_api_token`'s
detect-and-instruct branch is layered directly on top of `S-cycle3-percred-storage`'s
namespaced-key-lookup step: BC-1.4.032 Precondition 2 ("both namespaced keys are absent")
presupposes `load_api_token(profile)` already performs that namespaced-key check, which
`S-cycle3-percred-storage` builds.

**Blocks anchors:**
- `S-cycle3-remove-logout-semantics` depends on this story because BC-1.2.013's amended
  `logout` contract cross-references BC-1.4.033's SR-009 remediation-message fix (which drops
  `jr auth logout` from the recommended remediation commands) — that fix is this story's
  scope.
- `S-cycle3-adr0011-newtype` depends on this story per ADR-0020 § Sequencing item 5 ("depends
  on #2/#3/#4... so the call-site sweep covers the enlarged, post-restructuring surface
  exactly once") — this story's `load_api_token` detect-and-instruct branch is part of that
  surface.
- `S-cycle3-oauth-default-creation` depends on this story per ADR-0020 § Sequencing item 6
  ("#2/#3... so newly-OAuth-defaulted profiles' sibling API-token path is already on the new
  per-profile storage model, including its absence-guard behavior").
- `S-cycle3-chosen-flow-reconcile` depends on this story transitively via
  `S-cycle3-oauth-default-creation`.

## Source of Truth

- `.factory/specs/prd/bc-1-auth-identity.md` §1.4 — BC-1.4.032 (the REDESIGNED core
  contract, read this one in full before writing any code), BC-1.4.033 (partial-write
  recovery, namespaced-pair-only), BC-1.4.034 (breaking-change contract), BC-1.4.025
  (amended — regression-confirmation clause), BC-1.4.029 (amended — cross-reference)
- ADR-0020 § Decision 2/2a/2b (the human-decided redesign and its rationale)
- `.factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` §3
  ("Credential-Absence Handling — No-Copy Detect-and-Instruct")

## Narrative

As a `jr` user upgrading from a pre-cycle-003 install with an existing api-token profile,
I want a clear, actionable, one-time instruction to re-run `jr auth login <profile>` when my
credentials are not found under the new per-profile keys,
so that I understand exactly what happened and how to fix it — without `jr` silently and
invisibly copying a possibly wrong-environment credential into my profile behind my back.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-1.4.032 | NEW, REDESIGNED | `load_api_token`'s no-copy detect-and-instruct branch — legacy pair NEVER read/copied/deleted, for ANY profile including `"default"`; identical actionable exit-64 error regardless of legacy-pair presence |
| BC-1.4.033 | NEW, REDESIGNED | Partial-write recovery for the NAMESPACED pair only (the legacy-partial branch is dissolved — no copy step left to interrupt); corrected remediation message (drops `jr auth logout`, SR-009) |
| BC-1.4.034 | NEW | Formalizes the one-time, per-profile, breaking-change re-login contract this redesign produces |
| BC-1.4.025 | AMENDED | Regression-confirmation clause: `load_oauth_tokens` and its test suite are a MUST-NOT-TOUCH baseline this story's PR must verify byte-for-byte green |
| BC-1.4.029 | AMENDED | Cross-reference confirming `load_api_token("sandbox")` never inherits legacy flat keys, mirroring `load_oauth_tokens`'s existing non-inheritance guarantee |

## Current State (read before implementing)

- `S-cycle3-percred-storage` (this story's dependency) adds `store_api_token(profile, ...)`
  and `load_api_token(profile)` to `src/api/auth.rs`, with the flat legacy reader retained
  (per that story's Task Item 2) under a disambiguated name (e.g.
  `load_legacy_flat_api_token()`) keyed by `KEY_EMAIL`/`KEY_API_TOKEN`. **Read that story's
  final diff before starting this one** — the exact function/constant names it lands with are
  this story's inputs.
- `load_oauth_tokens` (`src/api/auth.rs:~253`) is the pattern this story's shape PARTIALLY
  mirrors — ONLY the "try namespaced keys first" step. Do NOT mirror its copy-then-delete
  branches (`~line 266-274`, `~line 293-301`) — those are exactly what BC-1.4.032 forbids for
  the new function.
- `read_keyring_optional` (`~line 323`) is the existing backend-error-vs-absent helper —
  reuse it for the legacy-pair EXISTENCE-ONLY check this BC requires (Postcondition 1: check
  presence, never read values as credentials — actually, since the legacy pair's "values"
  and "presence" are the same underlying `get_password()` call via `read_keyring_optional`,
  the discipline here is BEHAVIORAL, not mechanical: call the existence check, but never use
  the returned `Some(value)` as a credential to return from this function — only its
  `Some`/`None` shape matters).

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~6,000 |
| BC-1.4.032 (full — the largest single BC in the corpus) | ~4,200 |
| BC-1.4.033 (full) | ~2,200 |
| BC-1.4.034 (full) | ~1,800 |
| BC-1.4.025/BC-1.4.029 amended clauses | ~1,200 |
| `src/api/auth.rs` (relevant ~350 LOC: OAuth pair + new api-token pair from prior story) | ~4,200 |
| `cargo test` + keyring-gated + regression-suite output | ~800 |
| **Total** | **~20,400** |

Approaching but still within 20-30% of a typical agent context window (assume ~150-200K
token windows for implementing agents). If `src/api/auth.rs` has grown materially larger by
implementation time, re-check this budget before starting — this is the single highest-risk
story in the cycle and should not be rushed for context-budget reasons.

## Previous Story Intelligence

**Read `S-cycle3-percred-storage`'s final PR diff before starting.** That story:
- Added `store_api_token`/`load_api_token` with a PLACEHOLDER absent-key error message
  (its Task Item 2 / AC-008 note explicitly defers the FINAL wording to this story).
  **This story finalizes that message** to the exact BC-1.4.032 Postcondition 2 text:
  `"No credentials stored for profile '{profile}'. This version of jr requires per-profile
  credentials — run \`jr auth login {profile}\` to set them up."`
- Retained the flat legacy reader under a disambiguated name — confirm its exact name and
  use it (existence-check only, per the discipline noted above) rather than re-adding a
  duplicate flat-key reader.
- Left `store_api_token` as a plain, unconditional two-key overwrite (no read-modify-write) —
  this story's BC-1.4.033 Postcondition 3 depends on that being true; verify it, don't
  re-implement it.

**Regression discipline is mandatory, not advisory (BC-1.4.025):** before opening this
story's PR, run `load_oauth_tokens`'s existing test suite and confirm it is byte-for-byte
unchanged and green. This is a CI gate for this specific story's PR, not incidental
"existing tests still pass" — add a task-list line item and check it explicitly (Tasks Item
5 below).

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| No-copy, permanently | BC-1.4.032 Invariant 1 | No code path in `load_api_token`/`store_api_token` ever reads the legacy flat pair's VALUES as a credential, writes them into a namespaced slot, or deletes them. This is the permanent contract, not transitional. |
| No profile special-cased | BC-1.4.032 Postcondition 4, EC-1.4.032-1/3 | `"default"` and every other profile go through the IDENTICAL check — no `if profile == "default"` branch anywhere in this story's code. |
| Existence-only legacy check | BC-1.4.032 Postcondition 1 | The legacy-pair check exists only to keep the code path's shape symmetric with the OAuth migration's detection step — it does NOT change the error the user sees and does NOT read the legacy pair's values as anything but a presence flag. |
| Identical error regardless of legacy-pair presence | BC-1.4.032 Postcondition 2 | Legacy pair present or absent → byte-identical error message. |
| Backend-error exemption preserved | BC-1.4.032 Invariant 4; BC-1.4.031 EC-1.4.031-2 | A keychain BACKEND error encountered while checking legacy-pair existence is NEVER coerced into the "no stored credential" message — reuse `S-cycle3-percred-storage`'s backend-error-vs-absent pattern. |
| Namespaced-pair-only partial-write branch | BC-1.4.033 | The legacy-partial branch is REMOVED — no code path distinguishes a complete vs. partial legacy pair; both produce the identical BC-1.4.032 error. |
| Remediation message drops `jr auth logout` | BC-1.4.033 Invariant 2 (SR-009) | The partial-write error's remediation text names ONLY `jr auth login <profile>` (primary) or `jr auth remove <profile>` (abandon) — never `jr auth logout`, which is a no-op for api-token profiles (BC-1.2.013, amended). |
| MUST-NOT-TOUCH regression baseline | BC-1.4.025 | `load_oauth_tokens` and its existing test suite are diff-zero for this story's PR — a mandatory CI gate, not incidental. |
| No single-flight coordination needed | BC-1.4.032 Invariant 3 | This branch is read-only with no mutating side effect — do NOT add a `refresh_coordinator.rs`-style single-flight lock; there is no race to coordinate. |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` must pass. |

## Library and Framework Requirements

No new external dependencies.

| Item | Version / Constraint |
|------|----------------------|
| `keyring` | pinned version unchanged |
| `proptest` (dev-dependency, already present) | arbitrary legacy email/token strings, plus a legacy-pair-absent variant (VP-AUTHDX-005/006) |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/api/auth.rs` | MODIFY | `load_api_token(profile)`: on both-namespaced-keys-absent, add the existence-only legacy-pair check (never reading values as credentials) and return the finalized BC-1.4.032 Postcondition 2 error text regardless of legacy-pair presence. On namespaced-pair-partial, return the finalized BC-1.4.033 Postcondition 2 error text (drops `jr auth logout`). |
| `tests/` (new or existing auth test file) | MODIFY/CREATE | `proptest` for VP-AUTHDX-005 (detect-and-instruct correctness, legacy pair untouched), VP-AUTHDX-006 (no profile special-cased, `"default"` included as a generated case), VP-AUTHDX-008 (namespaced-pair partial-state, narrowed 2-member set); a MANDATORY `#[ignore]`-gated keyring integration test for VP-AUTHDX-007 (real OS backend, pre-seeded legacy pair, confirms untouched after a failed call). |
| CHANGELOG.md | MODIFY | `[Unreleased] > Changed` (Breaking) entry per BC-1.4.034's F4 doc-fallout obligation — this is a first-class AC (AC-012 below), not a checklist afterthought. |
| `docs/specs/multi-profile-auth.md` (or nearest equivalent doc) | MODIFY (if exists) | Add a short migration-notes note describing the one-time re-login requirement, per BC-1.4.034's "any standalone migration-notes document" obligation. If no such doc exists yet, note this in the PR description rather than inventing a new doc file speculatively — confirm with the orchestrator before creating a new top-level doc. |

**Files NOT to touch:** `src/cli/auth/remove.rs`, `src/cli/auth/logout.rs` — those are
`S-cycle3-remove-logout-semantics`'s scope (this story only fixes the REMEDIATION TEXT
BC-1.4.033 requires inside `src/api/auth.rs`; it does not touch `logout`'s own handler).

## Acceptance Criteria

### AC-001 — absent namespaced keys, legacy pair present → identical actionable error
`load_api_token("default")` (or any profile) with absent namespaced keys and a PRESENT
legacy flat pair returns the exact BC-1.4.032 Postcondition 2 error text.
(traces to BC-1.4.032 postcondition 2, EC-1.4.032-1)

### AC-002 — absent namespaced keys, legacy pair absent → identical actionable error
Same as AC-001 but with the legacy pair ALSO absent — byte-identical error text.
(traces to BC-1.4.032 postcondition 2)

### AC-003 — legacy pair NEVER copied or deleted, for `"default"` or any other profile
After any number of `load_api_token` calls against a profile in the absent-namespaced-keys
state, the legacy flat pair's byte content is IDENTICAL before and after — no write, no
delete.
(traces to BC-1.4.032 invariant 1, postcondition 3)

### AC-004 — no `"default"`-only branch (VP-AUTHDX-006)
A `proptest` over arbitrary profile names, INCLUDING `"default"` itself as a generated case
(never excluded), asserts the identical error-and-untouched-legacy-pair invariant holds with
no special-cased branch.
(traces to BC-1.4.032 VP-AUTHDX-006)

### AC-005 — detect-and-instruct correctness property (VP-AUTHDX-005)
A `proptest` over arbitrary legacy `(email, token)` pairs (or none at all) against `"default"`
specifically proves: (a) `Err` with the actionable message regardless of legacy-pair
presence; (b) legacy pair bytes unchanged; (c) repeated calls in the same state return the
same `Err` (no first-call-migrates shape).
(traces to BC-1.4.032 VP-AUTHDX-005)

### AC-006 — mandatory keyring-gated end-to-end scenario (VP-AUTHDX-007)
A `#[ignore]`-gated (`JR_RUN_KEYRING_TESTS=1`) test against the REAL OS keychain backend:
pre-seed legacy flat keys, run the first post-upgrade `jr` invocation against `"default"`,
confirm exit-64 actionable error, confirm legacy pair byte-for-byte unchanged in the real
keychain, confirm no namespaced pair was ever written. Repeat for a `"sandbox"` profile if
configured — identical failure-and-untouched behavior, not differentiated.
(traces to BC-1.4.032 VP-AUTHDX-007, F6 target)

### AC-007 — namespaced-pair partial-write → distinct actionable error
Exactly one of `<profile>:email`/`<profile>:api-token` present → `Err` with the
BC-1.4.033 Postcondition 2 message (`"Incomplete credentials stored for profile
'{profile}' — run \`jr auth login {profile}\` to fix this."`), never a silently-incomplete
`Ok`.
(traces to BC-1.4.033 postcondition 1/2)

### AC-008 — namespaced-partial precedence over legacy-pair state (EC-1.4.033-1)
`default:email` present, `default:api-token` absent, AND a complete legacy flat pair also
exists → the namespaced partial-write error still fires (namespaced check runs first).
(traces to BC-1.4.033 EC-1.4.033-1)

### AC-009 — namespaced partial-state property test (VP-AUTHDX-008)
A `proptest` over the 2-member namespaced partial-state set (`email` present/`api-token`
absent; the reverse) asserts `Err` + the exact remediation message + no write side-effects,
on every generated case.
(traces to BC-1.4.033 VP-AUTHDX-008)

### AC-010 — remediation message never names `jr auth logout` (SR-009)
The partial-write error text contains neither the substring `jr auth logout` nor any
suggestion to run `logout` as a remediation step.
(traces to BC-1.4.033 invariant 2)

### AC-011 — regression baseline: `load_oauth_tokens` diff-zero
`load_oauth_tokens`'s existing test suite (unit tests covering default-partial-recovery and
non-default non-inheritance) passes byte-for-byte unchanged as part of this story's PR CI
run — confirmed as an explicit, named CI step, not incidental.
(traces to BC-1.4.025 regression-confirmation clause)

### AC-012 — CHANGELOG breaking-change entry + doc-fallout
A `[Unreleased] > Changed` (Breaking) CHANGELOG entry describes the one-time
`jr auth login <profile>` re-login requirement for every pre-cycle-003 api-token profile,
landing in the SAME PR as the code change.
(traces to BC-1.4.034 F4 doc-fallout obligation)

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-1.4.032-1 | BC-1.4.032 | `"default"`, legacy present, namespaced absent | identical error to any other profile (AC-001) |
| EC-1.4.032-2 | BC-1.4.032 | `"default"` already has namespaced keys | this branch never entered — ordinary success read |
| EC-1.4.032-3 | BC-1.4.032 | non-default profile, legacy pair still exists | identical error, no special-casing (AC-004) |
| EC-1.4.032-4 | BC-1.4.032 | user runs `jr auth login <profile>` once | subsequent calls hit the ordinary success path; legacy pair remains untouched, inert, never read again |
| EC-1.4.032-5 | BC-1.4.032 | exactly one NAMESPACED key present | NOT this BC's branch — see BC-1.4.033 (AC-007) |
| EC-1.4.033-1 | BC-1.4.033 | namespaced-partial + legacy pair present | namespaced check takes precedence (AC-008) |
| EC-1.4.033-2 | BC-1.4.033 | legacy pair itself happens to be partial (unrelated manual edit) | never inspected closely enough to notice — existence-only check is outcome-agnostic |
| EC-1.4.034-1 | BC-1.4.034 | profile created for the first time on cycle-003-or-later binary | never hits this failure — no legacy credentials to lose |
| EC-1.4.034-2 | BC-1.4.034 | user upgrades but never invokes a command needing this profile's auth | never observes the failure — lazy-on-use |

## Tasks

### Item 1: Read the dependency story's final diff and the OAuth pattern
- [ ] Read `S-cycle3-percred-storage`'s final `store_api_token`/`load_api_token` diff — confirm exact names and the placeholder error text location
- [ ] Read `load_oauth_tokens` (`~line 253-311`) — confirm which parts to mirror (existence check) vs. NOT mirror (copy-then-delete)

### Item 2: Implement the no-copy detect-and-instruct branch
- [ ] Add the existence-only legacy-pair check to `load_api_token`'s absent-namespaced-keys branch
- [ ] Finalize the BC-1.4.032 Postcondition 2 error text (exact wording)
- [ ] Confirm no `if profile == "default"` branch exists anywhere in this code path

### Item 3: Implement the namespaced-pair partial-write branch
- [ ] Finalize the BC-1.4.033 Postcondition 2 error text (drops `jr auth logout`)
- [ ] Confirm namespaced-partial check runs BEFORE the legacy-existence check (EC-1.4.033-1 ordering)

### Item 4: Tests
- [ ] AC-001/002/003/007/008/010 unit tests
- [ ] AC-004/005 `proptest`s (VP-AUTHDX-005/006), profile-name generator explicitly includes `"default"`
- [ ] AC-009 `proptest` (VP-AUTHDX-008), 2-member namespaced partial-state set
- [ ] AC-006 MANDATORY keyring-gated integration test (VP-AUTHDX-007) — do not skip or demote this to an ordinary integration test

### Item 5: Regression gate
- [ ] Run `load_oauth_tokens`'s existing test suite in isolation; confirm zero diff, all green
- [ ] Add this as an explicit CI-check line item in the PR description (AC-011)

### Item 6: CHANGELOG + doc-fallout
- [ ] `[Unreleased] > Changed` (Breaking) CHANGELOG entry (AC-012)
- [ ] Confirm whether `docs/specs/multi-profile-auth.md` (or equivalent) exists and needs a migration note; if creating a new doc file, confirm scope with the orchestrator first

### Integration checks (all must pass before PR)
- [ ] `cargo test` exits 0 (full suite; keyring-gated tests skipped by default)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- Any future `jr auth` cleanup command that deletes now-orphaned legacy keys — recommended
  follow-up (ADR-0020 § Decision 2), explicitly out of this cycle's scope. Do NOT add
  legacy-key deletion as scope creep.
- `auth remove`/`auth logout` handler changes — `S-cycle3-remove-logout-semantics`.
- `Profile` newtype threading — `S-cycle3-adr0011-newtype`.

## Dependency Analysis

**depends_on:** `["S-cycle3-percred-storage"]` — needs the namespaced reader/writer to
exist before this story's absence-guard branch can layer on top of it.
**blocks:** `S-cycle3-remove-logout-semantics`, `S-cycle3-adr0011-newtype`,
`S-cycle3-oauth-default-creation`, and transitively `S-cycle3-chosen-flow-reconcile` — see
Anchor Justification above.

## Story Points and Effort

**8 story points** (high complexity despite narrower scope than the original migration
design). Breakdown:
- No-copy detect-and-instruct branch implementation: 1.5 SP
- Namespaced-pair partial-write branch + SR-009 message fix: 1 SP
- VP-AUTHDX-005/006 property tests: 2 SP
- VP-AUTHDX-008 property test: 1 SP
- VP-AUTHDX-007 MANDATORY keyring-gated integration test: 1.5 SP
- Regression-baseline diff-zero verification (BC-1.4.025): 0.5 SP
- CHANGELOG + doc-fallout: 0.5 SP

Risk: HIGH — this is the single highest-scrutiny story in the cycle (F1 delta analysis §3).
Even after the F2-gate redesign removed the worst failure mode (cross-environment credential
leak via copy), this remains a genuinely new code path on the auth-header hot path, the
one-time breaking change every pre-cycle-003 api-token profile will hit, and the cycle's
only story carrying a MANDATORY keyring-gated end-to-end VP proven against a real OS
backend. Recommend NOT parallelizing this story's wave with any other in-flight story so
review attention is undivided.
