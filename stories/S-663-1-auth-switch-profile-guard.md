---
document_type: story
level: ops
epic_id: "BUCKET1-DEFECTS"
story_id: "S-663-1"
title: "auth switch --profile <X> exits 64 (closes #663)"
wave: feature-followup
status: done
intent: enhancement
feature_type: backend
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: true
issue: 663
points: 3
priority: HIGH
tdd_mode: strict
estimated_effort: small
producer: story-writer
timestamp: "2026-08-13T00:00:00"
phase: 3
cycle: cycle-bucket1-defects
inputs:
  - ".factory/phase-f1-delta-analysis/bucket1-impact-boundary.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-bucket1-defects.md"
  - ".factory/research/bucket1-663-auth-switch-profile-2026-08-13.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
input-hash: "adfe5dd"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md"
estimated_days: 1
target_module: src/main.rs
subsystems: ["SS-01"]
depends_on: []
blocks: []
behavioral_contracts:
  - "BC-1.2.047"
  - "BC-1.2.018"
bcs:
  - "BC-1.2.047"
  - "BC-1.2.018"
verification_properties:
  - "VP-663-001"
  - "VP-663-002"
  - "VP-663-003"
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-1-auth-identity.md"
implementation_strategy: tdd
module_criticality: "informal (no module-criticality.md exists in this repo; target_module src/main.rs is the central command-dispatch/error-handling seam — treat as HIGH by convention pending a formal criticality doc)"
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations: []
created: "2026-08-13"
version: "1.1"
last_updated: "2026-08-13"
breaking_change: true
retroactive: false
origin: >
  BUCKET1-DEFECTS bundle. `auth switch --profile <X> <NAME>` changes from a
  silently-accepted no-op (exit 0, --profile's value ignored) to a hard
  rejection (exit 64) — BC-1.2.047 (NEW), BC-1.2.018 (AMENDED carve-out).
  Requires a CHANGELOG.md Breaking: entry at release (F2 "Acceptance Note for
  F3/Release").
files_modified:
  - src/main.rs
  - CLAUDE.md
  - CHANGELOG.md
test_files:
  - tests/auth_profiles.rs
---

> **Execute:** `/vsdd-factory:deliver-story S-663-1`

# S-663-1 — `auth switch --profile <X>` Exits 64

## Narrative

- **As a** `jr auth switch` caller
- **I want to** get an immediate, actionable exit-64 error if I pass the global
  `--profile` flag to `auth switch`
- **So that** I do not fall into the confusing `jr auth switch --profile X X`
  incantation the issue reports — `--profile` was a semantic no-op on this
  subcommand whose only observable effect was an extra, confusing
  existence-check constraint; the real switch target has always been the
  positional `<NAME>`.

*Breaking change: `jr auth switch --profile <X> <NAME>` previously succeeded
(exit 0, `--profile`'s value silently ignored). As of this story it is a hard
rejection (exit 64). Any script or alias that happened to pass `--profile` to
`auth switch` will now fail where it previously (confusingly) succeeded. See
CHANGELOG.md `### Breaking Changes`.*

## Source of Truth

- F2 spec evolution (authoritative): `.factory/specs/prd/bc-1-auth-identity.md`
  BC-1.2.047 (NEW) and BC-1.2.018 (`STATUS: UPDATED (2026-08-13, issue #663)`,
  carve-out amendment).
- Research brief: `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md`
  (clap-mechanism verification of the three usage-string forms; confirms the
  runtime-guard fix — Option 3 — over `conflicts_with` — Option 1b, unreliable
  for `global = true` args per clap issues #5335/#5358).

## Problem Statement

The global `--profile` flag (`src/cli/mod.rs :: Cli.profile`, `global = true`)
propagates to every subcommand including `auth switch`, but `AuthCommand::Switch`
has no subcommand-level `profile` field to compose it against — `main.rs`'s
`AuthCommand::Switch { name } => cli::auth::handle_switch(&name,
cli.profile.as_deref(), &cli.output)` passes it through, but
`handle_switch`'s write path (`src/cli/auth/switch.rs::handle_switch`) depends
only on the positional `name`. `--profile`'s only observable side effect was
forcing `Config::load_with`'s active-profile existence-check to additionally
validate the flag's value — producing the confusing `jr auth switch --profile
X X` incantation (both values must be real profiles, but only the positional
is the true argument).

## Behavioral Contracts

| BC ID | Title | Clause |
|-------|-------|--------|
| BC-1.2.047 | `auth switch --profile <X>` rejected, exit 64 | NEW — Preconditions/Postconditions/Invariants/EC-1.2.047-1..5/VP-663-001..003 |
| BC-1.2.018 | Global `--profile` propagation, `auth switch` carve-out | AMENDED — title/Behavior clarification (List/Remove direct pass-through vs. Login/Status/Refresh/Logout `.or()` composition vs. Switch rejection) |

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| Guard | `src/main.rs`, `AuthCommand::Switch` dispatch arm, BEFORE `handle_switch`/`Config::load_with` | pure check (`cli.profile.is_some()`) embedded in effectful dispatch |
| Error emission | central error handler (`src/main.rs`'s error-exit path, ~line 143) | effectful-shell (stderr write) |

## Guard Implementation Pattern

Add the guard at the `AuthCommand::Switch { name }` dispatch arm in
`src/main.rs`, BEFORE `cli::auth::handle_switch(...)` is called — so a
nonexistent `--profile` value does not first trip `Config::load_with`'s
active-profile existence-check side effect. Rejection is unconditional on
`cli.profile.is_some()`, independent of whether `<X>` or `<NAME>` name real
profiles, and independent of flag/positional argument order.

**MUST NOT** use clap `conflicts_with = "profile"` as even a secondary defense
— per research brief §3 and BC-1.2.047 "Explicitly out of scope", this is
documented unreliable for `global = true` args (clap issues #5335, #5358) and
incomplete for the flag-without-positional case. Use a runtime
`JrError::UserError` guard exclusively, flowing through the existing central
error handler (satisfies the #526 JSON render invariant with no bespoke
formatter).

**Error string (fixed constant, no interpolation):**
```
--profile is not valid for 'auth switch'. The profile to activate is the positional argument. Try: jr auth switch <NAME>
```

## Acceptance Criteria

### AC-1 (traces to BC-1.2.047 Postconditions 2/3, VP-663-001): basic rejection, human mode
- `jr auth switch --profile foo foo` (both existing profiles) → exit 64;
  stderr contains `"--profile is not valid for 'auth switch'"`; no config file
  write (mtime unchanged); no keychain access.
- **Test:** `test_BC_1_2_047_auth_switch_with_profile_flag_exits_64`

### AC-2 (traces to BC-1.2.047 Postcondition 4, VP-663-002): `--output json` error envelope
- `jr auth switch --profile foo foo --output json` → exit 64; **stdout is
  EMPTY**; stderr parses as JSON with keys `{"error", "code"}`; `code == 64`.
- **Test:** `test_BC_1_2_047_auth_switch_with_profile_flag_json_error_envelope_stderr_stdout_empty`

### AC-3 (traces to BC-1.2.047 Postcondition 1/5): guard fires before `Config::load_with`, no side effects
- `jr auth switch --profile bogus realprofile` → exits 64 on the `--profile`
  guard, NOT on a "bogus profile does not exist" message — the guard fires
  before any profile-existence check is reachable. No config read/write, no
  keychain access.
- **Test:** `test_BC_1_2_047_auth_switch_guard_fires_before_config_load_no_existence_check`

### AC-4 (traces to BC-1.2.047 EC-1.2.047-1/-3): incantation + order independence
- `jr auth switch --profile foo foo` (the "confusing incantation" the issue
  reports) → still exits 64 regardless of value coincidence with the
  positional. `jr auth switch realprofile --profile bogus` (flag after
  positional) → same exit-64 rejection; guard is order-independent.
- **Test:** `test_BC_1_2_047_auth_switch_profile_flag_rejected_regardless_of_order_or_value`

### AC-5 (traces to BC-1.2.047 EC-1.2.047-4, VP-663-003 — protects the direnv-scoped-sandbox workflow): `JR_PROFILE` env var NOT rejected
- `JR_PROFILE=sandbox jr auth switch realprofile` (global `--profile` FLAG
  absent; only the env var is set) → NOT rejected; exit 0;
  `handle_switch_in_memory("realprofile")` proceeds normally. The guard keys
  ONLY on `cli.profile.is_some()` (CLI flag presence), never on `JR_PROFILE`,
  `config.default_profile`, or any other stage of the profile-resolution
  precedence chain.
- **Test:** `test_BC_1_2_047_auth_switch_jr_profile_env_var_not_rejected`

### AC-6 (traces to BC-1.2.047 EC-1.2.047-5): charset-invalid `--profile` value pre-empted by `validate_profile_name`
- `jr auth switch --profile 'in!valid' realprofile` → still exits 64, but via
  the EARLIER `config::validate_profile_name` check in `run()` (before command
  dispatch), with stderr `"Profile name contains invalid characters (use a-z,
  0-9, -, _)"` — NOT this BC's `"--profile is not valid for 'auth switch'…"`
  message. A test asserting the wrong message here would be testing the wrong
  layer.
- **Test:** `test_BC_1_2_047_auth_switch_charset_invalid_profile_preempted_by_validate_profile_name`

### AC-7 (traces to BC-1.2.047 Invariant 1, BC-1.2.018 amended): `Login`/`Status`/`Refresh`/`Logout` unaffected regression pin
- `jr auth login --profile X`, `jr auth status --profile X`, `jr auth refresh
  --profile X`, `jr auth logout --profile X` all continue to compose
  `subcmd.profile.or(cli.profile)` exactly as before this story — no
  regression to their existing `--profile` handling.
- **Test:** `test_BC_1_2_018_auth_login_status_refresh_logout_profile_composition_unaffected`

### AC-8 (traces to BC-1.2.018 LOW-2 clarification): `List`/`Remove` unaffected — still honor `--profile`
- `jr auth list --profile X` and `jr auth remove --profile X <target>`
  continue to pass `cli.profile.as_deref()` straight through (no `.or()`
  composition, since they have no subcommand-level `profile` field) — NEVER
  rejected. `auth switch` remains the sole subcommand where `--profile` is
  REJECTED rather than honored.
- **Test:** `test_BC_1_2_018_auth_list_remove_profile_flag_still_honored_not_rejected`

### AC-9 (release obligation, F2 "Acceptance Note for F3/Release", mirrors S-639-1 precedent): CHANGELOG `Breaking:` entry
- `CHANGELOG.md` gains a `### Breaking Changes` entry describing the
  `auth switch --profile <X>` exit 0 → exit 64 change, citing issue #663, in
  the SAME PR/commit as the code change. `CLAUDE.md` gains a one-line gotcha:
  "`--profile` is rejected on `auth switch` (use the positional)."
- **Test:** manual/PR-review gate (not a `cargo test` assertion) — verified at
  PR creation per the Branch/PR Plan below.

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | `--profile foo foo` (both real) | Exit 64 (AC-1/AC-4) |
| EC-2 | `--profile bogus realprofile` | Exit 64 on the `--profile` guard, not an existence error (AC-3) |
| EC-3 | `realprofile --profile bogus` (order swapped) | Exit 64, order-independent (AC-4) |
| EC-4 | `JR_PROFILE=sandbox`, no `--profile` flag | NOT rejected — exit 0 (AC-5) |
| EC-5 | `--profile 'in!valid'` (charset-invalid) | Exit 64 via `validate_profile_name`, different message (AC-6) |
| EC-6 | No `--profile` flag at all | Unaffected — existing BC-1.1.003 unknown-profile-positional path applies |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/main.rs`, `AuthCommand::Switch` guard check | pure (`cli.profile.is_some()`) | No I/O; embedded in effectful dispatch |
| `src/cli/auth/switch.rs::handle_switch` | effectful-shell | Config read/write, keychain access (unaffected by this story except for the earlier-return guard) |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|-------------------|
| This story file | ~3 k |
| BC-1.2.047 + BC-1.2.018 bodies | ~4 k |
| Research brief `bucket1-663-auth-switch-profile-2026-08-13.md` | ~3 k |
| `src/main.rs` (Switch dispatch arm + `run()` validate_profile_name call site) | ~2 k |
| `src/cli/auth/switch.rs` | ~1 k |
| `tests/auth_profiles.rs` (existing tests to extend) | ~4 k |
| Tool outputs + `cargo test` output | ~3 k |
| **Total** | **~20 k** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~10%** |

## Tasks

1. [ ] Read BC-1.2.047 and BC-1.2.018 (amended) in full.
2. [ ] Write failing tests for AC-1 through AC-8 (Red Gate).
3. [ ] Implement the guard in `src/main.rs`'s `AuthCommand::Switch` dispatch
   arm, before `handle_switch` is called.
4. [ ] Verify AC-1 through AC-8 GREEN.
5. [ ] Add `CLAUDE.md` gotcha line + `CHANGELOG.md` `### Breaking Changes`
   entry (AC-9).
6. [ ] Full suite: `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all
   -- --check`, `cargo deny check`.
7. [ ] Per-story adversarial review (project convention — 3/3 CLEAN before
   push).

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|-------------------------|------------------------|
| S-639-1 | Runtime `JrError::UserError` guard over clap `requires`/`conflicts_with` for exit-64 semantics | Pre-flight guard placed before any effectful call; breaking_change frontmatter marker + CHANGELOG discipline | clap `conflicts_with` against a `global = true` arg has documented reliability bugs (clap #5335/#5358) — do not rely on it even as a secondary defense |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| Guard fires BEFORE `Config::load_with`/`handle_switch` | BC-1.2.047 Postcondition 1 | AC-3 |
| No clap `conflicts_with` as even a secondary defense | BC-1.2.047 "Explicitly out of scope" | Code review at PR; no clap attribute in diff |
| Guard keys ONLY on `cli.profile.is_some()`, never `JR_PROFILE`/config default | BC-1.2.047 EC-1.2.047-4 | AC-5 |
| `--output json` error on stderr, stdout empty | BC-1.2.047 Postcondition 4 | AC-2 |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| clap 4 (existing) | as in `Cargo.lock` | No new attributes — runtime guard only |

No new crate dependencies.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/main.rs` | MODIFY | Add exit-64 guard in `AuthCommand::Switch` dispatch arm |
| `tests/auth_profiles.rs` | MODIFY | Add tests for AC-1..AC-8 |
| `CLAUDE.md` | MODIFY | One-line gotcha (AC-9) |
| `CHANGELOG.md` | MODIFY | `### Breaking Changes` entry (AC-9) |

**MUST NOT change**: `src/cli/auth/switch.rs::handle_switch` internals (write
logic unchanged — this story only adds an earlier-return guard upstream of the
call); BC files in `.factory/specs/prd/` (F2 sealed — escalate discrepancies to
orchestrator).

## Branch / PR Plan

- Bundle: `BUCKET1-DEFECTS`
- Branch: `feat/663-auth-switch-profile-guard`
- Target: `develop`
- Commit style: `feat(auth)!: reject --profile on auth switch (#663)` (breaking
  change `!`)
- PR closes #663
- `CHANGELOG.md` `### Breaking Changes` entry in same commit (AC-9)

---

## Close-Out (v1.1, 2026-08-14)

**DELIVERED AND MERGED.**

- Implemented on branch `feat/663-auth-switch-profile-guard` (matches the plan above), full
  VSDD Feature Mode pipeline F1–F7 as part of the `bucket1-defects` bundle.
- F5 scoped adversarial review: reviewer verdict APPROVE / no blocking findings (COMMENT-state
  only — reviewer==author, standing structural gap). Zero CRIT/HIGH findings.
- F6 targeted hardening: `src/main.rs` is **not** in `.cargo/mutants.toml examine_globs` — CI's
  in-diff mutation gate correctly reported 0 mutants (a real, pre-existing scope gap, not a
  defect introduced by this story; tracked as drift item `MUTANTS-SCOPE-GAP-QUEUE-MAIN`).
- F7 delta convergence: **5/5 dimensions PASS** — full report:
  `.factory/phase-f7-convergence/bucket1-defects-delta-convergence-report.md`.
- PR #696 (`feat(auth)!: reject --profile on auth switch (#663) [BREAKING]`) squash-merged into
  `develop` as `c9218389` (2026-08-14T00:14:39Z), **closing #663**. All 15 CI checks green
  including CI Gate.
- 1 demo artifact (`demo.gif`) captured at `.factory/demos/S-663-1/`.
- `CHANGELOG.md` `### Breaking Changes` entry present in the merged commit (AC-9 satisfied).

Full detail: `STATE.md`, `cycles/cycle-001/burst-log.md` § BUCKET1-DEFECTS-COMPLETE,
`cycles/cycle-001/decisions-archive.md` DEC-276.
