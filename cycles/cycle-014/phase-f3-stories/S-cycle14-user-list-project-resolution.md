---
document_type: story
level: ops
story_id: "S-cycle14-user-list-project-resolution"
epic_id: "ISSUE-TRIAGE-QUICKFIXES-1"
title: "jr user list --project resolution order: local > global > configured default > exit 64"
wave: 1
status: draft
intent: bug-fix
feature_type: correctness
mode: feature
scope: standard
severity: LOW
trivial_scope: false
producer: story-writer
timestamp: "2026-09-26T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-014/phase-f2-spec-evolution/prd-delta.md"
  - ".factory/cycles/cycle-014/phase-f2-spec-evolution/verification-delta.md"
  - ".factory/specs/prd/cross-cutting.md"
  - "src/cli/mod.rs"
  - "src/main.rs"
  - "src/cli/user.rs"
  - "src/config.rs"
  - "tests/user_commands.rs"
  - "tests/all_flag_behavior.rs"
  - "README.md"
input-hash: "eb5b8a1"
traces_to: "BC-X.7.002"
cycle: cycle-014-issue-triage-quickfixes
estimated_effort: small
estimated_days: 1
target_module: "src/cli/user.rs, src/cli/mod.rs, src/main.rs"
subsystems: ["SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's scope because every file this
# story modifies (src/cli/mod.rs, src/cli/user.rs) lives under src/cli/ per
# ARCH-INDEX's Subsystem Registry (SS-02 row: "CLI Layer | src/cli/"). The
# src/main.rs dispatch-arm edit is a thin threading change into the same
# SS-02-owned handler, not a second subsystem's concern.
depends_on: []
blocks: ["S-cycle14-api-query-param"]
# S-cycle14-api-query-param depends on this story because both stories edit
# the SAME two files in the same numeric sequence: .cargo/mutants.toml's
# examine_globs array (this story: 32->33) and
# docs/specs/cargo-mutants-policy.md's single hard-coded "Current
# examine_globs count" line (this story sets it to 33; STORY-C's edit must
# start from that already-landed value to reach 34) -- a real content
# dependency, not mere file overlap. Delivery order A -> C -> B is human
# decision D-381 (2026-09-25 F2 review), recorded in cycle-manifest.md.
behavioral_contracts:
  - BC-X.7.002
bcs:
  - BC-X.7.002
verification_properties:
  - VP-USER-LIST-PROJECT-001
holdout_anchors: ["H-CYCLE14-W1-INT-001", "H-CYCLE14-W1-REG-001"]
nfr_anchors: []
adr_refs: []
sd_refs: []
priority: P2
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-014/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: "N/A -- no .factory/specs/module-criticality.md exists in this repo"
points: 3
acceptance_criteria_count: 11
assumption_validations: []
risk_mitigations: []
created: "2026-09-26"
version: "1.0"
last_updated: "2026-09-26"
breaking_change: true
retroactive: false
origin: >
  cycle-014 issue-triage-quickfixes (GitHub issue #862), Wave 1 of 3, first
  story in the human-decided SERIAL delivery order A -> C -> B (D-381,
  2026-09-25 F2 review). F1 delta-analysis (.factory/cycles/cycle-014/
  phase-f1-delta-analysis/delta-analysis.md) confirmed the root cause as
  UserCommand::List.project's clap-REQUIRED String typing, which rejects a
  global --project before clap's own propagation step ever runs. F2
  (prd-delta.md Item 1) amended BC-X.7.002 with the four-step resolution
  order this story implements. This story implements that already-approved
  spec amendment -- it does not re-litigate the resolution-order design.
---

> **tdd_mode:** `strict` -- this story adds new runtime logic (a pure
> resolver function, a type change, and config-threading through two call
> sites) that is not a config/constant-only edit, so the full TDD Iron Law
> applies: non-trivial function bodies start as `todo!()`, Red Gate density
> check >= 0.5 required before Step 4 dispatch.

> **Execute:** `/vsdd-factory:deliver-story S-cycle14-user-list-project-resolution`

# S-cycle14-user-list-project-resolution -- `jr user list --project` resolution order (#862)

## Narrative

- **As a** `jr` user who has a global `--project` flag or a configured default project
- **I want to** `jr user list` to resolve `--project` the same way `jr component list`/`jr queue`/`jr field options --type` already do (local flag > global flag > configured default)
- **So that** `jr --project FOO user list` and a bare `jr user list` (with a configured default) work instead of failing with clap's own "required argument" error before `jr`'s own logic ever runs

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-X.7.002 | PRIMARY (amended, cycle-014 F2) | The four-step resolution order (Behavior, Postconditions 1-5), the pure `resolve_user_list_project` resolver (Fix step 4), the `&Config`-threading requirement (Fix step 3, Invariants), the pinned exit-64 message (Postcondition 4), the pinned `--help` text (Fix step 1), and Edge Cases EC-X.7.002-1..7 |

**Anchor justification:** BC-X.7.002 is the sole BC governing `jr user list`'s project resolution in this spec corpus (`cross-cutting.md`). It was amended at cycle-014 F2 specifically to fix issue #862; this story is the F4-bound implementation of that already-approved amendment.

## Acceptance Criteria

### AC-001 (traces to BC-X.7.002 Fix step 1 / Postcondition 1)
`src/cli/mod.rs::UserCommand::List.project` (~L1148) changes from clap-REQUIRED `String` to `Option<String>`. The `#[arg(long, short = 'p')]` attribute, including `short = 'p'`, is unchanged. When a local `--project` is supplied, `Cli::try_parse_from` resolves it to `Some(value)` regardless of whether a global `--project` or a configured default is also present (local wins unconditionally).
**Test:** inline `Cli::try_parse_from` unit test asserting all four flag-presence cells plus both local/global `-p` short-alias cells (VP-USER-LIST-PROJECT-001(a)).

### AC-002 (traces to BC-X.7.002 Postcondition 2, EC-X.7.002-2)
`jr --project FOO user list` (global only, no local flag, no configured default) resolves the local field to `Some("FOO")` via clap's own `fill_in_global_values` propagation -- no `jr`-level local-vs-global merge code is written. This is the exact invocation issue #862 reported as broken (previously clap exit 2).
**Test:** `test_bc_x_7_002_...global_project_only...` wiremock cell, hermetic per `verification-delta.md` §2, asserting exactly one request with `projectKeys=FOO`.

### AC-003 (traces to BC-X.7.002 Postcondition 3, EC-X.7.002-3, EC-X.7.002-5, EC-X.7.002-7)
When both local and global `--project` are absent, `resolve_user_list_project(cli_project: Option<&str>, config: &Config) -> Option<String>` (new `pub(crate)` function in `src/cli/user.rs`) falls back to `Config::project_key`'s existing chain: `.jr.toml` project first, then the active profile's configured `project` default (including a non-default `--profile`'s own default, and including an empty-string configured default, EC-X.7.002-7). `handle_list` calls this resolver with the post-clap field value.
**Test:** `proptest!` over the 2x4 presence-space (VP-USER-LIST-PROJECT-001(b)) + three wiremock cells (`.jr.toml`-only, profile-only, both) + the `--profile alt` cell (EC-X.7.002-5).

### AC-004 (traces to BC-X.7.002 Postcondition 4, EC-X.7.002-4)
When none of {local `--project`, global `--project`, configured default} resolve, `handle_list` exits 64 (`JrError::UserError`) with the byte-identical message `"No project configured. Run \"jr init\" or pass --project. Run \"jr project list\" to see available projects."`, before any HTTP call.
**Test:** `tests/user_commands.rs::user_list_requires_project_flag` (no rename, per F1-gate Open Question 8; made hermetic per `verification-delta.md` §2, keeping its existing unreachable `JR_BASE_URL=http://127.0.0.1:1`) + a new hermetic EC-X.7.002-4 wiremock cell with `.expect(0)` on `multiProjectSearch`.

### AC-005 (traces to BC-X.7.002 EC-X.7.002-1)
`jr --project GLOBAL user list --project LOCAL` resolves to `LOCAL` (local wins over global when both are supplied), via clap propagation, producing the same observable result as `component create`'s explicit local-over-global merge code.
**Test:** `Cli::try_parse_from` cell (part of AC-001's test) + a wiremock cell asserting `projectKeys=LOCAL`.

### AC-006 (traces to BC-X.7.002 EC-X.7.002-6, D-380)
`--project ""` (empty string), whether local or global, passes through as `Some(String::new())` and resolves the project key to the empty string without consulting the configured default -- settled behavior, human-confirmed 2026-09-25 (D-380), matching `jr queue`/`jr requesttype`'s existing empty-string pass-through.
**Test:** two `Cli::try_parse_from` cells + a `proptest!` cell (`cli_project = Some("")` -> `Some(String::new())` in every configured cell) + a wiremock cell.

### AC-007 (traces to BC-X.7.002 Postcondition 5)
Once resolved (by any of steps 1-3), every request carries `projectKeys=<resolved-key>`: exactly one `GET /rest/api/3/user/assignable/multiProjectSearch` on the default (non-`--all`) path (BC-X.7.003's unchanged single-call contract); `--all` paginates one-or-more offset pages of the same endpoint, every page carrying the same `projectKeys` value.
**Test:** two `--all` pagination wiremock tests on `tests/user_pagination.rs::user_list_all_cli_paginates`'s three-page pattern (one with the global flag, one with the configured default), each with a `query_param_is_missing("projectKeys")` catch-all `.expect(0)`.

### AC-008 (traces to BC-X.7.002 Fix step 1, VP-USER-LIST-PROJECT-001(d))
`jr user list --help` exits 0 and its stdout (whitespace-collapsed) contains the pinned help string: `"Project key (overrides the configured default project). Required when no project is configured in"` and `"or the active profile"`.
**Test:** `--help` integration cell.

### AC-009 (traces to BC-X.7.002 Fix step 3, Invariants, EC-X.7.002-5)
`cli::user::handle` gains a `&Config` parameter, threaded from `src/main.rs`'s already-loaded `config` binding (`Config::load_with(cli.profile.as_deref())`) -- `handle`/`handle_list` MUST NOT call `Config::load`/`Config::load_with` themselves, or `--profile`/`JR_PROFILE` selection would be silently ignored.
**Test:** the EC-X.7.002-5 wiremock cell (profile `default` -> "DEF", profile `alt` -> "ALT"; `jr --profile alt user list` must resolve `ALT`) fails if the handler reloads config instead of using the passed value.

### AC-010 (traces to BC-X.7.002 Trace, prd-delta.md F4 doc-delta obligation PASS-13/P13-003)
`README.md`'s `jr user list --project FOO` row (~L335) is reworded to show `--project` as optional, reflecting the new fallback to the configured default project rather than implying the flag is required.
**Test:** N/A (doc artifact); presence checked at PR review.

### AC-011 (traces to verification-delta.md §2 "examine_globs" table, D-382)
`.cargo/mutants.toml`'s `examine_globs` array gains `"src/cli/user.rs"` (32 -> 33 entries, verified by actual count, not the policy doc's prose number). `docs/specs/cargo-mutants-policy.md` gains a `` `src/cli/user.rs` — `resolve_user_list_project` `` §Scope bullet, its "Current `examine_globs` count" line changes 32 -> 33, and a new newest-first row is added to the `## Changelog` table.
**Test:** N/A (config/doc); `tests/mutants_glob_existence.rs` passes automatically since the file already exists; `scripts/check-cargo-mutants-policy-citations.sh` passes since `resolve_user_list_project` is defined in the same PR.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `resolve_user_list_project` | `src/cli/user.rs` | Pure (no I/O; wraps `Config::project_key`) |
| `UserCommand::List.project` type change | `src/cli/mod.rs` | Pure (clap derive declaration) |
| `handle` / `handle_list` `&Config` threading | `src/cli/user.rs` | Effectful-shell (HTTP call site; the resolver itself is pure) |
| `Command::User` dispatch arm | `src/main.rs` | Effectful-shell (wiring only, no new logic) |

Reference: `architecture/module-decomposition.md`, `architecture/dependency-graph.md` (no module-boundary change; F1 confirmed no architecture delta for this cycle).

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-X.7.002-1 | Both local AND global `--project` supplied | LOCAL wins, via clap propagation |
| EC-X.7.002-2 | Global `--project` only | Resolves via clap propagation (the reported #862 bug) |
| EC-X.7.002-3 | Configured default only (`.jr.toml` or profile) | Resolves via `Config::project_key`'s fallback chain |
| EC-X.7.002-4 | None of the three present | Exit 64, pinned message, zero HTTP |
| EC-X.7.002-5 | No local/global flag, non-default `--profile` with its own configured default, no `.jr.toml` ancestor | That profile's own default resolves (requires passing `&Config` without reload) |
| EC-X.7.002-6 | `--project ""` (local or global) | Passes through as `Some("")`, configured default NOT consulted (D-380) |
| EC-X.7.002-7 | Configured empty project default (`.jr.toml`/profile `project = ""`), no local/global flag | Resolves to `Some("")` via `Config::project_key`; no exit 64 (informational, no dedicated VP cell) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `resolve_user_list_project` (`src/cli/user.rs`) | pure-core | No I/O; wraps `Config::project_key` |
| `UserCommand::List` clap declaration (`src/cli/mod.rs`) | pure-core | Derive-macro declaration, no I/O |
| `handle` / `handle_list` (`src/cli/user.rs`) | effectful-shell | Performs the HTTP request once the project key is resolved |
| `main.rs`'s `Command::User` dispatch arm | effectful-shell | Constructs `Config`/`JiraClient` and dispatches |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,600 |
| Referenced code (`src/cli/mod.rs` `UserCommand::List` region, `src/cli/user.rs` full file, `src/main.rs`'s `Command::User` arm, `src/config.rs::project_key`, `src/cli/component.rs::handle` List/Create arms as precedent, `src/cli/field.rs::resolve_m2_project` as signature precedent) | ~3,000 |
| Test files (`tests/user_commands.rs`, `tests/all_flag_behavior.rs:~260-`, `tests/user_pagination.rs` -- grep-scoped) | ~2,000 |
| Tool output overhead | ~1,000 |
| **Total** | **~8,600** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~4%** |

## Tasks

1. [ ] Grep `tests/` for any literal assertion tied to `UserCommand::List.project`'s clap-required behavior beyond `tests/user_commands.rs::user_list_requires_project_flag` -- `test-writer`
2. [ ] Write the inline `Cli::try_parse_from` unit test (AC-001, AC-005, AC-006) -- `test-writer`
3. [ ] Write the `proptest!` on `resolve_user_list_project` (AC-003, AC-006) -- `test-writer`
4. [ ] Write the hermetic wiremock integration cells: EC-X.7.002-1..7, the two `--all` pagination cells, and the `--help` cell -- `test-writer`
5. [ ] Make `tests/user_commands.rs::user_list_requires_project_flag` hermetic per `verification-delta.md` §2 (no rename); update its stale `// No server needed -- clap should fail before any HTTP call.` comment -- `test-writer`
6. [ ] Confirm Red Gate: new/updated tests fail against the current code
7. [ ] Change `UserCommand::List.project` to `Option<String>` and update its help text (AC-001, AC-008) -- `implementer`
8. [ ] Implement `resolve_user_list_project` in `src/cli/user.rs`; thread `&Config` through `handle`/`handle_list`; thread `config` through `src/main.rs`'s `Command::User` arm (AC-003, AC-009) -- `implementer`
9. [ ] Implement the exit-64 path with the pinned message (AC-004) -- `implementer`
10. [ ] Confirm Green Gate: all tests pass
11. [ ] Update `README.md`'s `jr user list --project FOO` row (~L335) (AC-010)
12. [ ] Add `src/cli/user.rs` to `.cargo/mutants.toml` `examine_globs`; add the §Scope bullet, bump the count line 32->33, and add a `## Changelog` row to `docs/specs/cargo-mutants-policy.md` (AC-011)
13. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` describing the shipped behavior, before creating the PR
14. [ ] Run `cargo fmt --all -- --check`, `cargo clippy -- -D warnings`, `cargo test`, and the scoped `cargo mutants --in-diff`

## Previous Story Intelligence

N/A -- first story in cycle-014's serial delivery chain (A -> C -> B, D-381); no cycle-014 predecessor exists yet.

**Pattern to follow (cross-cycle precedent):** `src/cli/field.rs::resolve_m2_project` (S-580-1, BC-X.14.001's M2 project-resolution step) already establishes the pure-resolver-plus-`&Config`-threading pattern this story mirrors; `resolve_user_list_project`'s signature is deliberately styled after it. `src/cli/component.rs::handle`'s `List`/`Create` arms are the codebase's other local-over-global precedent (explicit `.or()`/`or_else()` merge code, for a variant that does NOT rely on clap propagation) -- this story's variant DOES rely on clap propagation instead, so no equivalent merge code is written; do not copy `component.rs`'s explicit merge pattern here.

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `handle`/`handle_list` MUST NOT call `Config::load`/`Config::load_with` -- only the `&Config` passed from `main.rs` may be consulted | BC-X.7.002 Fix step 3, Invariants | AC-009's EC-X.7.002-5 test fails if the handler reloads config |
| Local-vs-global precedence is clap's own `fill_in_global_values` propagation -- no hand-written `jr`-level merge/`.or()` call is added for this half of the resolution | BC-X.7.002 Behavior, Fix step 2 | Code review; AC-001/AC-005 tests pass without any merge code in `handle_list` |
| The canonical no-project exit-64 message MUST be byte-identical to `queue.rs`/`requesttype.rs`'s existing wording | BC-X.7.002 Postcondition 4 | AC-004 |
| `--project ""` MUST NOT be special-cased to `None` (treated as absent) | BC-X.7.002 EC-X.7.002-6, D-380 | AC-006 |
| No new `Config`/`ProfileConfig` accessor and no new cache file -- reuse `Config::project_key` exactly | BC-X.7.002 Invariants | Code review |

## Library & Framework Requirements

No new dependency is added. `clap = { version = "4", features = ["derive"] }` (existing pin, `Cargo.toml`; resolves to 4.6.7 per the lockfile cited throughout `cross-cutting.md`) is relied upon for global-value propagation via `fill_in_global_values` -- no version change required.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/mod.rs` | modify | `UserCommand::List.project: String -> Option<String>`; help text update (AC-001, AC-008) |
| `src/main.rs` | modify | `Command::User` dispatch arm threads the already-loaded `config` binding through (AC-009) |
| `src/cli/user.rs` | modify | `handle`/`handle_list` gain `&Config`; new `resolve_user_list_project`; exit-64 message (AC-003, AC-004, AC-009) |
| `tests/user_commands.rs` | modify | Hermetic isolation for `user_list_requires_project_flag` (no rename); new EC-X.7.002-4 regression cell; stale comment fix (AC-004) |
| `tests/user_pagination.rs` | modify | Two new `--all` pagination cells (AC-007) |
| `tests/all_flag_behavior.rs` | modify (conditional, only if Task 1's grep finds a stale assertion) | Update any literal assertion tied to the old clap-required behavior |
| `README.md` | modify | `jr user list --project FOO` row (~L335) reworded (AC-010) |
| `.cargo/mutants.toml` | modify | Add `src/cli/user.rs` to `examine_globs` (32->33) (AC-011) |
| `docs/specs/cargo-mutants-policy.md` | modify | §Scope bullet + count line 32->33 + `## Changelog` row (AC-011) |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry |

## Definition of Done

- [ ] All 11 ACs pass their listed tests
- [ ] `cargo fmt --all -- --check` clean
- [ ] `cargo clippy -- -D warnings` clean
- [ ] `cargo test` green (full suite, not just this story's new tests)
- [ ] Scoped `cargo mutants --in-diff` (per CLAUDE.md's `DIFF_FILE=$(mktemp -t pr.diff.XXXXXX) && ... cargo mutants --in-diff "$DIFF_FILE" --jobs 4 --timeout 240`) run against the PR diff, with `src/cli/user.rs` now in `examine_globs` scope
- [ ] `.cargo/mutants.toml` / `docs/specs/cargo-mutants-policy.md` edits verified against `scripts/check-cargo-mutants-policy-citations.sh` and `tests/mutants_glob_existence.rs`
- [ ] CHANGELOG entry present under `[Unreleased] > Fixed`
- [ ] PR opened against `develop`, following commitizen branch/commit conventions

## Suggested Branch Name

`fix/user-list-project-resolution` (Conventional Commits, per CLAUDE.md's `type/short-description` convention; this is a bug fix, so `fix/`).
