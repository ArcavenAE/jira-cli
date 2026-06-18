---
document_type: story
story_id: "S-TESTTOOL-1"
title: "Test-tooling hardening — cargo-mutants baseline scope + keyring-test gate"
wave: feature-followup
status: draft
intent: enhancement
feature_type: infrastructure
mode: feature
scope: xsmall
severity: LOW
trivial_scope: true
points: 2
priority: P3
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0.5
target_module: ci
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: no product BCs. These are test/CI-quality changes with NO behavioral-contract
# impact and NO production src/ runtime behavior. The changes are:
#   (1) a TOML config file edit expanding the mutation-testing file scope — no Rust code,
#       no user-visible behavior;
#   (2) a test attribute annotation (#[ignore] + early-return guard) on a single test
#       function — no semantic logic change, purely a harness scheduling annotation.
# Neither item meets the BC authorship threshold (no new postcondition, precondition,
# or invariant added to any domain behavior). BC catalog stays at its current count.
# Do NOT add BCs to this story.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/phase-f1-delta-analysis/test-tooling-hardening-2026-06-18.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 3
assumption_validations: []
risk_mitigations: []
created: "2026-06-18"
version: "1.6"
last_updated: "2026-06-18"
changelog:
  - "1.6 (2026-06-18): F5 round-7 (final polish): F1 body status line propagated (O-1); bare line citations → symbol-form per #408 (O-2)."
  - "1.5 (2026-06-18): F5 round-6: corrected AC-003 guard attribution to Config::load_with (O-1); F1 status advanced from awaiting-human-approval (O-2)."
  - "1.4 (2026-06-18): F5 round-5 remediation: propagated list_comments rationale to AC-001 + F1; full four-surface rationale-wording reconciliation; final self-consistency audit."
  - "1.3 (2026-06-18): F5 round-4 remediation: exhaustive #[tokio::test]→#[test] sweep (residual occurrences at AC-002/Item-2/EC-003); full self-consistency verification."
  - "1.2 (2026-06-18): F5 round-3 remediation: corrected AC-002/EC-002 false-verifier claim (test_every_ignored_test_has_gate_guard does not cover auth_profiles.rs); #[test] prose fix (was #[tokio::test])."
  - "1.1 (2026-06-18): F5 remediation — corrected guard-form mandate to is_err() (I-1, HIGH); added AC-003 non-keyring fallback-coverage test for global --profile→auth-subcommand fork."
  - "1.0 (2026-06-18): Initial story decomposition."
breaking_change: false
lineage:
  - S-346  # cargo-mutants CI job + whitelist policy (PR #373 @ d909e65, 2026-05-16)
  - S-410  # keychain test isolation — gate pattern (PR #416 @ 04e019a, 2026-05-27)
drift_items:
  - MAINT-MUTANTS-GLOBS-01
  - "#526-F6-KEYRING-GATE"
files_modified:
  - .cargo/mutants.toml           # MODIFY — add src/api/jira/issues.rs and src/cache.rs to examine_globs
  - tests/auth_profiles.rs        # MODIFY — (1) add #[ignore] + JR_RUN_KEYRING_TESTS is_err() guard to global_profile_flag_targets_auth_status; (2) add ungated test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64 for effective_profile fork coverage (AC-003)
  - CLAUDE.md                     # MODIFY (doc-fallout) — extend keyring-gated-test roster to name tests/auth_profiles.rs::global_profile_flag_targets_auth_status
---

# S-TESTTOOL-1 — Test-tooling hardening: cargo-mutants baseline scope + keyring-test gate

## Source of Truth

F1 Delta Analysis: `.factory/phase-f1-delta-analysis/test-tooling-hardening-2026-06-18.md`
F2 Spec delta (Item 1): `docs/specs/cargo-mutants-policy.md` § "Scope" table
F2 Spec delta (Item 2): `docs/specs/multi-profile-auth.md` § "Keyring CI compatibility"
Drift items: MAINT-MUTANTS-GLOBS-01 (cargo-mutants glob gap) and #526-F6-KEYRING-GATE (ungated keyring test).

## Behavioral Contracts

No product BCs are added or modified by this story. The BC catalog count is unchanged.

**Why no BC anchor:** Both items in this story are test/CI-quality changes that affect only the
test harness scheduling and the mutation-testing configuration. Neither modifies `src/` production
runtime behavior, nor does either change any externally observable postcondition, precondition, or
invariant of any domain entity. BC authorship is reserved for changes that alter what the system
does for its users — this story changes only what tests run and what files cargo-mutants inspects.

This story traces its ACs to the drift items MAINT-MUTANTS-GLOBS-01 and #526-F6-KEYRING-GATE,
following the same convention used by S-CIGATE-1 (CI-infra story with no product BC surface),
S-346 (cargo-mutants setup — also no BC anchor), and S-410 (keyring test isolation — also no BC anchor).

## Story Narrative

As a contributor to `jr`,
I want `src/api/jira/issues.rs` and `src/cache.rs` included in the cargo-mutants baseline scope,
and the `global_profile_flag_targets_auth_status` test properly gated behind `JR_RUN_KEYRING_TESTS=1`,
so that the mutation-testing baseline is accurate and keyring-touching tests no longer run
unconditionally in CI where they can block or flake.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,000 |
| `.cargo/mutants.toml` (current, ~29 LOC) | ~400 |
| `tests/auth_profiles.rs` (full, ~350 LOC estimated) | ~4,500 |
| `CLAUDE.md` keyring-gated roster section (relevant lines) | ~800 |
| `docs/specs/cargo-mutants-policy.md` § Scope (verification reference) | ~600 |
| F1 delta analysis (verification rationale) | ~2,500 |
| Tool outputs (cargo test, grep count verification) | ~500 |
| **Total** | **~12,300** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**S-346** (merged PR #373 @ d909e65, 2026-05-16) established `.cargo/mutants.toml` with the initial
`examine_globs` list (`src/adf.rs`, `src/api/jira/bulk.rs`, `src/types/jira/bulk.rs`,
`src/cli/issue/create.rs`, `src/api/jsm/requests.rs`, `src/api/jsm/request_types.rs`,
`src/cli/requesttype.rs`). This story extends that list with two high-value files identified in the
F1 sibling analysis. The S-346 pattern (no `--file` flags; scope via `examine_globs`) is preserved.

**S-410** (merged PR #416 @ 04e019a, 2026-05-27) established the canonical gate pattern for
keyring-touching tests: `#[ignore]` attribute + early-return guard as the first statement in the
test body. This story applies the identical pattern to one additional test in `tests/auth_profiles.rs`
(`global_profile_flag_targets_auth_status`) which was not in scope for S-410 (S-410 targeted
`multi_cloudid_disambiguation.rs` and `oauth_refresh_integration.rs`). The F1 analysis for this
cycle confirms `global_profile_flag_targets_auth_status` is the ONLY remaining ungated test with
a confirmed keyring touch across all test files; all other candidates are properly gated or exit
before the keychain path.

**Why `issues.rs` and `cache.rs` were not in S-346 scope:** S-346 was an audit-followup targeting
`bulk.rs` and `create.rs` specifically (prompted by an F6 hardening review of PR #110-pr2). The
sibling analysis in the current F1 was not performed at S-346 time. The F1 analysis for this cycle
retroactively confirms these files as HIGH-value mutation targets, and adds them now.

**N/A — first story with this specific lineage.** No story has previously modified
`tests/auth_profiles.rs` for keyring gating.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| `examine_globs` is the TOML config primitive for file scope | S-346 story + `.cargo/mutants.toml` current | Add new entries to the existing `examine_globs` array in `.cargo/mutants.toml`. Do NOT add `--file` CLI flags to CI; config file is the authoritative scope. |
| `#[ignore]` + early-return guard is the canonical keyring gate | S-410 AC-001 / CLAUDE.md "AI Agent Notes" / `tests/auth_profiles.rs` sibling tests | The guard form MUST be `if std::env::var("JR_RUN_KEYRING_TESTS").is_err() { return; }` — matching the two pre-existing keyring-gated tests in `tests/auth_profiles.rs` (`auth_login_creates_new_profile_with_url` and `auth_login_with_jr_profile_pointing_to_unrelated_profile_still_creates_target`). The `is_err()` form runs the test whenever the variable is SET to any value, which is the intended in-file sibling convention. Do NOT use `as_deref() != Ok("1")` — that form diverges from the established siblings in this file. |
| `#[ignore]` placement: outermost attribute before `#[test]` | S-410 Architecture Rule 3 | `#[ignore]` before `#[test]` before `fn`. (`global_profile_flag_targets_auth_status` is a plain synchronous `#[test]`, not `#[tokio::test]`.) |
| CLAUDE.md roster update is required doc-fallout | CLAUDE.md "AI Agent Notes" JR_RUN_KEYRING_TESTS section | The CLAUDE.md roster entry must name `tests/auth_profiles.rs::global_profile_flag_targets_auth_status`. This is not optional — it is the pattern established by S-410 for doc-fallout from every new keyring gate. |
| No production code changes | F1 delta analysis §7 "Files NOT Changed" | `src/` files are read-only. The only modified Rust source is `tests/auth_profiles.rs`. |
| `#[ignore]` attribute must carry a descriptive string | S-410 AC / project precedent | Use `#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to run"]` (matches sibling pattern at lines 252 and 302 of `tests/auth_profiles.rs`). |

## Library and Framework Requirements

No new library or framework dependencies. All changes are TOML config edits and Rust test
attribute annotations using only `std::env::var` (standard library — no new crate imports).

| Item | Version / Constraint |
|------|---------------------|
| `cargo-mutants` | Already installed via CI `cargo install` (S-346); binary tool — NOT a Cargo.toml dependency |
| `std::env::var` | Rust standard library — no crate needed |

Do not add any new entries to `Cargo.toml` or `deny.toml`.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `.cargo/mutants.toml` | MODIFY | Append `"src/api/jira/issues.rs"` and `"src/cache.rs"` to the `examine_globs` array. Keep all existing entries; add the two new entries at the end of the list with inline comments explaining the rationale (per the F1 sibling analysis table and F2 policy doc update). |
| `tests/auth_profiles.rs` | MODIFY | Add `#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to run"]` before `#[test]` on `global_profile_flag_targets_auth_status` (a plain synchronous test, not `#[tokio::test]`), and add the early-return guard as the first statement in the test body. |
| `CLAUDE.md` | MODIFY (doc-fallout) | Extend the `JR_RUN_KEYRING_TESTS=1` roster entry in "AI Agent Notes" to explicitly name `tests/auth_profiles.rs::global_profile_flag_targets_auth_status`. This is a required doc-fallout task per the S-410 pattern — not optional. |

**Files NOT to create:** No new source files, no new spec files, no new BC documents, no new ADR.

**Files NOT to touch:** `src/` (all production source), `.factory/specs/`, `Cargo.toml`,
`deny.toml`, all BC count surfaces (`bc-*.md` frontmatter, `BC-INDEX.md`, `CANONICAL-COUNTS.md`).

## Acceptance Criteria

### AC-001 (MAINT-MUTANTS-GLOBS-01) — `examine_globs` includes `issues.rs` and `cache.rs`

`.cargo/mutants.toml` `examine_globs` includes `"src/api/jira/issues.rs"` and `"src/cache.rs"`.

**Verifiable by:**
```bash
cargo mutants --list 2>/dev/null | grep -E "src/api/jira/issues\.rs|src/cache\.rs"
```
Expected: ≥1 mutant line for each file.

Alternatively (faster, no test execution):
```bash
cargo mutants --list-files 2>/dev/null | grep -E "issues\.rs|cache\.rs"
```

**Why these two files; why not others:**

| File | Decision | Rationale (per F1 LESSON-F1-SIBLING-CASE) |
|------|----------|-------------------------------------------|
| `src/api/jira/issues.rs` | INCLUDED | HIGH-value: contains JRACLOUD-95368 anti-loop guard, `seen_keys` dedup, `has_more` sentinel, cursor-vs-offset pagination branch, `list_comments`. Strong existing test coverage in `tests/search_issue_keys.rs` makes kill rate feasible. |
| `src/cache.rs` | INCLUDED | HIGH-value: TTL logic, per-profile path construction, model-a vs model-b error-handling split. Mutations of TTL comparisons or path-join calls would be invisible to tests that mock the filesystem via `JR_CACHE_DIR`. |
| `src/api/pagination.rs` | EXCLUDED | MEDIUM-value: simple field-access logic; mutation survivors would be caught by existing integration tests. Low payoff vs baseline cost. |
| `src/jql.rs` | EXCLUDED | LOW-value: property-tested via proptest inline; adding increases baseline cost without proportional benefit. |
| `src/api/jira/users.rs` | DEFERRED | MEDIUM-value: interesting `USER_PAGE_SIZE`-advance workaround (JRACLOUD-71293) but limited test coverage in `tests/user_commands.rs` risks a low kill rate and noisy first run. Address in a dedicated "users pagination hardening" cycle after targeted tests exist. |

**CI impact:** The `mutants` CI job runs `--in-diff` only; CI behavior for PRs NOT touching
`issues.rs` or `cache.rs` is unchanged. For PRs that DO touch them, `--in-diff` already
scoped them correctly (the gap was only in the standalone `cargo mutants` full-baseline
invocation used locally). No CI YAML change is required.

(traces to drift item MAINT-MUTANTS-GLOBS-01 — full-baseline scope gap)

---

### AC-002 (#526-F6-KEYRING-GATE) — `global_profile_flag_targets_auth_status` is gated

`tests/auth_profiles.rs::global_profile_flag_targets_auth_status` carries:
1. `#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to run"]` attribute before `#[test]`
2. Early-return guard as the FIRST statement in the test body:
   ```rust
   if std::env::var("JR_RUN_KEYRING_TESTS").is_err() {
       return; // requires JR_RUN_KEYRING_TESTS=1 and system keychain access
   }
   ```

**Guard form rationale:** `is_err()` matches the two pre-existing keyring-gated sibling tests in this file (`auth_login_creates_new_profile_with_url` and `auth_login_with_jr_profile_pointing_to_unrelated_profile_still_creates_target`). The `is_err()` form runs the test whenever `JR_RUN_KEYRING_TESTS` is set to ANY non-empty value (not just `"1"`), which is the established in-file convention. The `as_deref() != Ok("1")` form was previously mandated in error — it diverges from siblings and is corrected here (F5 I-1, HIGH).

**Verifiable by:**

*Test skips by default:*
```bash
cargo test --test auth_profiles global_profile_flag_targets_auth_status
# Expected output contains: "test global_profile_flag_targets_auth_status ... ignored"
```

*Test runs when opted in:*
```bash
JR_RUN_KEYRING_TESTS=1 cargo test --test auth_profiles -- \
  --include-ignored global_profile_flag_targets_auth_status
# Expected: test runs and passes
```

*Ignore count confirms exactly 3 gated tests in the file:*
```bash
grep -c '#\[ignore' tests/auth_profiles.rs
# Expected: 3 (2 pre-existing + 1 newly gated)
```

*Test appears as ignored under plain `cargo test`:*
```bash
cargo test --test auth_profiles global_profile_flag_targets_auth_status
# Expected: "test global_profile_flag_targets_auth_status ... ignored"
# (i.e., the test is skipped, not executed)
```

Note: `test_every_ignored_test_has_gate_guard` (in `tests/e2e_live.rs`) checks that
every `#[ignore]` test in `tests/e2e_live.rs` has an `e2e_enabled()` early-return guard.
It reads ONLY `tests/e2e_live.rs` and does NOT scan `tests/auth_profiles.rs`. It cannot
verify the `JR_RUN_KEYRING_TESTS` guard added here. The verification for AC-002 is the
grep-3 count above and the ignored-status confirmation from plain `cargo test`.

**Why this test specifically:** `global_profile_flag_targets_auth_status` reaches
`auth::load_api_token()` → `keyring::Entry::get_password()` on both the `KEY_EMAIL` and
`KEY_API_TOKEN` keychain entries. On Linux CI without a secret-service daemon, or under macOS
Keychain contention, this call can block waiting for the daemon or prompt for GUI authorization.
The `.is_ok()` wrapper means it never panics, but it CAN hang. All other tests in `tests/auth_profiles.rs`
exit before the credential probe and do NOT require gating (confirmed by F1 sibling analysis).

**CLAUDE.md doc-fallout (required):** The `CLAUDE.md` "AI Agent Notes" section entry for
`JR_RUN_KEYRING_TESTS=1` must be updated to include `tests/auth_profiles.rs::global_profile_flag_targets_auth_status`
in its roster. This is a required doc-fallout task — see Tasks below. It need not be in the
same commit as the test gate but must be applied in F4 implementation.

(traces to drift item #526-F6-KEYRING-GATE — ungated keyring-touching test in auth_profiles.rs)

---

### AC-003 (Coverage regression — F5 finding) — ungated regression test for global `--profile` propagation to auth subcommand fork

A new, **ungated** (no `#[ignore]`, no `JR_RUN_KEYRING_TESTS` requirement) test in
`tests/auth_profiles.rs` asserts that the global `--profile` flag propagates correctly
through the `effective_profile` fork in `src/main.rs` to auth subcommands, WITHOUT
reaching the keyring.

**Test mechanism:**

Invoke `jr --profile <nonexistent-profile-name> auth status` (global `--profile` BEFORE
the `auth` subcommand on the command line). The expected result is exit code 64 with an
"unknown profile" error message. This specific outcome is only possible if the global flag
propagated through the fork (`effective_profile = profile.or_else(|| cli.profile.clone())`
in `src/main.rs`) to `Config::load_with(Some("ghost"))`, which calls `load_inner(strict=true)`
and immediately exits 64 on an unknown profile name — this is the strict active-profile-existence
guard in `src/config.rs`, triggered as the first statement of `src/cli/auth/status.rs::status`. The
`src/cli/auth/status.rs` `contains_key` guard is a redundant backstop that is never reached
on this path. If the flag were silently dropped, resolution would fall back to the default
profile (which exists in the test's config), and the command would NOT exit 64.

**Why this is ungated (no keyring access):**

The profile-existence check fires BEFORE any keyring probe. A nonexistent profile name
causes the guard to exit 64 immediately — no credential lookup is ever attempted.
The test therefore runs safely in default CI under plain `cargo test` with no env var,
no secret-service daemon, and no macOS Keychain access.

**Coverage regression addressed:**

Gating `global_profile_flag_targets_auth_status` (AC-002) removes the ONLY prior coverage
of the `effective_profile` fork (at `src/main.rs`) for the Status/Login/Refresh/Logout auth
subcommand path from all default CI runs. The surviving precedence tests use `auth list`,
which bypasses that fork. Without AC-003, a regression to the `effective_profile` fork
(e.g., dropping `profile.or_else(|| cli.profile.clone())`) would pass all default CI tests.

**Test naming convention (per `docs/specs/test-naming-convention.md`):**
```
test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64
```

**Verifiable by:**
```bash
cargo test --test auth_profiles test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64
# Expected: test runs without JR_RUN_KEYRING_TESTS, exits 0 (test passes)
```

**References:**
- `src/main.rs` `effective_profile` fork: `let effective_profile = profile.or_else(|| cli.profile.clone())`
- `src/config.rs` `Config::load_with` strict guard (exits 64 on unknown profile — the operative path)
- `src/cli/auth/status.rs` `contains_key` guard (redundant backstop; never reached on this path)
- F5 coverage-regression finding (HIGH severity)

(traces to F5 coverage-regression finding — `effective_profile` fork loses all default-CI coverage when AC-002 gates the only existing test)

---

## Tasks

### Item 1: `.cargo/mutants.toml` — expand `examine_globs`

- [ ] Read `.cargo/mutants.toml` in full to confirm current state (7 existing entries)
- [ ] Append `"src/api/jira/issues.rs"` and `"src/cache.rs"` to the `examine_globs` array with inline comments per the F1 rationale
- [ ] Verify: `cargo mutants --list-files 2>/dev/null | grep -E "issues\.rs|cache\.rs"` outputs both files
- [ ] Optionally run `cargo mutants --list 2>/dev/null | grep -E "src/api/jira/issues\.rs|src/cache\.rs"` to confirm ≥1 mutant per file (wall-clock bounded to `--list` which does not run tests)

### Item 2: `tests/auth_profiles.rs` — gate `global_profile_flag_targets_auth_status`

- [ ] Read `tests/auth_profiles.rs` in full — verify `global_profile_flag_targets_auth_status` exists; confirm the sibling gate pattern at lines ~252 (`auth_login_creates_new_profile_with_url`) and ~302 (`auth_login_with_jr_profile_pointing_to_unrelated_profile_still_creates_target`)
- [ ] Add `#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to run"]` before `#[test]` on `global_profile_flag_targets_auth_status`
- [ ] Add early-return guard as the FIRST statement in the test body using the `is_err()` form (per Architecture Compliance Rule 2): `if std::env::var("JR_RUN_KEYRING_TESTS").is_err() { return; }`
- [ ] Verify: `cargo test --test auth_profiles global_profile_flag_targets_auth_status` shows the test as `ignored`
- [ ] Verify: `grep -c '#\[ignore' tests/auth_profiles.rs` → 3 (2 pre-existing + 1 newly gated)

### Item 2b: `tests/auth_profiles.rs` — add ungated `effective_profile` fork regression test (AC-003)

- [ ] Read `src/main.rs` to confirm the `effective_profile` assignment (`profile.or_else(|| cli.profile.clone())`) and how the resolved profile is threaded to auth subcommands
- [ ] Read `src/cli/auth/status.rs` to confirm the profile-existence guard that exits 64 for unknown profiles
- [ ] Add a new test `test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64` in `tests/auth_profiles.rs` — NO `#[ignore]`, NO `JR_RUN_KEYRING_TESTS` guard
  - The test invokes `jr --profile <nonexistent-profile-name> auth status` and asserts exit code 64
  - Use the same test harness pattern as other non-keyring tests in the file (wiremock / temp config with known profiles; the nonexistent profile name is one that is NOT in the config)
- [ ] Verify: `cargo test --test auth_profiles test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64` passes without any env var
- [ ] Verify: `cargo clippy -- -D warnings` exits 0 after adding the new test

### Item 3: `CLAUDE.md` — doc-fallout (REQUIRED)

**This is a required doc-fallout task, not optional.** The CLAUDE.md "AI Agent Notes" section
documents the full roster of keyring-gated tests. Omitting this update leaves the roster stale.

- [ ] Read the `JR_RUN_KEYRING_TESTS=1` entry in CLAUDE.md "AI Agent Notes"
- [ ] Extend the roster / coverage note to explicitly name `tests/auth_profiles.rs::global_profile_flag_targets_auth_status`

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0 (no keychain prompt; `global_profile_flag_targets_auth_status` is skipped)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0 (no BC files touched; counts unchanged)
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0 (no cumulative count drift)
- [ ] `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 (no BC files touched)

## Out of Scope

- **Adding `src/api/jira/users.rs` to `examine_globs`:** Deferred per F1 sibling analysis — limited
  test coverage risks a low kill rate on first run. Address in a subsequent hardening cycle.
- **Gating any other tests in `tests/auth_profiles.rs`:** The F1 sibling analysis confirmed only
  `global_profile_flag_targets_auth_status` requires gating; all other tests in this file exit
  before the credential probe.
- **Any change to the `mutants` CI YAML job:** The CI job uses `--in-diff`; expanding
  `examine_globs` does not change CI behavior for existing PRs.
- **New BCs, new VPs, new ADRs.** Test infrastructure changes only.
- **`CLAUDE.md` updates beyond the keyring roster extension.** Only the JR_RUN_KEYRING_TESTS roster entry is affected.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `.cargo/mutants.toml` | cargo config | N/A (TOML config) | Extends mutation-testing file scope; no runtime effect |
| `tests/auth_profiles.rs::global_profile_flag_targets_auth_status` | `tests/` | Effectful (keychain I/O) | Gating annotation adds harness-level skip guard; test logic unchanged |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | F1 §3 Item 1 | `cargo mutants` full-baseline run after adding the two files surfaces surviving mutants in `issues.rs` or `cache.rs` with kill rate < 90% | Expected and acceptable: the deferral policy in `docs/specs/cargo-mutants-policy.md` applies — file follow-up issues per surviving-mutant cluster, whitelist with justification comments. Do NOT block this PR on achieving 90% threshold. |
| EC-002 | F1 §3 Item 2 | Confirming the new `#[ignore]` test has its early-return guard | Verify with `grep -c '#\[ignore' tests/auth_profiles.rs` → 3, and confirm `cargo test --test auth_profiles global_profile_flag_targets_auth_status` shows the test as `ignored`. Note: `test_every_ignored_test_has_gate_guard` in `tests/e2e_live.rs` scans only that file and does NOT cover `tests/auth_profiles.rs` — it provides zero verification of the `JR_RUN_KEYRING_TESTS` guard here. |
| EC-003 | S-410 Architecture Rule 3 | `#[ignore]` placed after `#[test]` instead of before it | `cargo test -- --include-ignored` may not honor the attribute; always place `#[ignore]` BEFORE `#[test]` (outermost attribute). `global_profile_flag_targets_auth_status` is a plain synchronous `#[test]`, not `#[tokio::test]`. |
| EC-004 | F1 §4 Item 2 sibling table | Other tests in `tests/auth_profiles.rs` mistakenly gated | The F1 analysis confirms only `global_profile_flag_targets_auth_status` requires gating. `grep -c '#\[ignore' tests/auth_profiles.rs` must equal 3 post-fix. |

## Dependency Analysis

**depends_on: []** — No story dependencies. This is a standalone test-tooling story.

S-346 and S-410 are lineage ancestors (this story extends their work) but are already MERGED;
there is no runtime dependency. Topological order: leaf node. Can be implemented in any wave.

**blocks: []** — No story depends on this.

This is a LEAF story in the dependency graph. It has no predecessors and no successors.

---

## Story Points and Effort

**2 story points** (xsmall). Breakdown:
- Item 1 (`.cargo/mutants.toml` TOML edit + verification): 0.5 SP
- Item 2 (`tests/auth_profiles.rs` annotation + meta-test verification): 1 SP
- Item 3 (CLAUDE.md doc-fallout): 0.5 SP

The implementation diff is ~5 lines of TOML + ~5 lines of Rust test annotation + ~3 lines of
documentation. No new functions. No logic changes. Risk: LOW (see F1 analysis §3).
