---
document_type: story
story_id: "S-MAINT-532"
title: "Gate and cover Login/Refresh/Logout global --profile fallback path (GitHub issue #532)"
wave: feature-followup
status: draft
intent: bug-fix
feature_type: coverage-gap
mode: feature
scope: small
severity: LOW
trivial_scope: false
points: 3
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 1.0
target_module: cli
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: pending PO authorship
# Coverage-gap story tracking GitHub issue #532. The global --profile fallback path
# through Login/Refresh/Logout auth subcommands is exercised in production but has no
# dedicated non-keyring test coverage. A formal BC may be authored (BC-1.X.NNN) once
# the gap and expected behaviour are analysed; until then status must remain draft.
# Do NOT add BCs to this story without PO sign-off.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/maintenance/2026-06-19/spec-coherence.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-06-19"
version: "1.0"
last_updated: "2026-06-19"
changelog:
  - "1.0 (2026-06-19): Initial draft — originated from 2026-06-19 maintenance sweep drift item #532-COVERAGE-FOLLOW-UP (spec-coherence.md §3.2 row 23)."
breaking_change: false
lineage:
  - S-TESTTOOL-1  # added ungated test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64
                   # for auth status path; #532 is the analogous gap for login/refresh/logout
drift_items:
  - "#532-COVERAGE-FOLLOW-UP"
files_modified:
  - tests/auth_profiles.rs   # MODIFY — add ungated tests for Login/Refresh/Logout global --profile
                             # fallback with an unknown-profile name (exit 64; no keyring access)
---

# S-MAINT-532 — Cover Login/Refresh/Logout global `--profile` fallback path (issue #532)

**Origin:** 2026-06-19 maintenance sweep, drift item `#532-COVERAGE-FOLLOW-UP` (`spec-coherence.md` §3.2 row 23).
**Status at sweep:** OPEN (coverage-gap). GitHub issue #532 still OPEN.

## Source of Truth

Spec coherence report: `.factory/maintenance/2026-06-19/spec-coherence.md` §3.2 row 23 (`#532-COVERAGE-FOLLOW-UP`)
GitHub issue: #532 (OPEN — "Login/Refresh/Logout global --profile fallback ungated")

## Problem Statement

S-TESTTOOL-1 (PR #533, 2026-06-18) added an ungated regression test for the global
`--profile` flag's fallback path through the `auth status` subcommand
(`test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64`). That test
established a pattern: invoking `jr --profile <nonexistent> auth <subcommand>` with a profile
name that does NOT exist causes `Config::load_with` to exit 64 before any keyring access —
making the test safe to run in default CI without `JR_RUN_KEYRING_TESTS`.

**The analogous tests for `auth login`, `auth refresh`, and `auth logout` do not exist.**

The `effective_profile` fork in `src/main.rs` threads the global `--profile` flag into all
auth subcommands equally. If a regression were introduced that dropped the profile from the
`login` / `refresh` / `logout` dispatch path, default CI would not catch it.

## Behavioral Contracts

No new product BCs are introduced by this story (the behaviour already exists; this story
adds test coverage). A formal BC for global `--profile` propagation may be authored by the
PO. Until then, `status: draft` per the Spec-First Gate (S-7.01).

This story traces its ACs to drift item `#532-COVERAGE-FOLLOW-UP`.

## Story Narrative

As a contributor to `jr`,
I want ungated regression tests that verify the global `--profile` flag propagates correctly
to `auth login`, `auth refresh`, and `auth logout` subcommands,
so that a regression to the `effective_profile` fork in `src/main.rs` for these paths is
caught in default CI without requiring `JR_RUN_KEYRING_TESTS`.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,000 |
| `tests/auth_profiles.rs` (full, ~430 LOC estimated post S-TESTTOOL-1) | ~5,600 |
| `src/main.rs` `effective_profile` fork (relevant lines, ~30 LOC) | ~400 |
| `src/cli/auth/login.rs` (profile-existence guard, ~30 LOC) | ~400 |
| `src/cli/auth/refresh.rs` (profile-existence guard, ~30 LOC) | ~400 |
| `src/cli/auth/logout.rs` (profile-existence guard, ~30 LOC) | ~400 |
| GitHub issue #532 description | ~300 |
| `cargo test` output for verification | ~500 |
| **Total** | **~11,000** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**S-TESTTOOL-1** (PR #533 → b4a470f, 2026-06-18) established the exact pattern this
story follows:

```rust
#[test]
fn test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64() {
    // No #[ignore] — no JR_RUN_KEYRING_TESTS guard needed.
    // jr --profile <nonexistent> auth status → Config::load_with(strict=true) → exit 64
    // The profile-existence check fires BEFORE any keyring probe.
    ...
}
```

The key insight: an unknown profile name causes `Config::load_with` to exit 64 immediately
via the strict guard, before any credential lookup is attempted. The test is therefore
safe to run in default CI.

This story applies the same pattern to `auth login`, `auth refresh`, and `auth logout`.

**Read the S-TESTTOOL-1 test** (`tests/auth_profiles.rs::test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64`) before implementing the new tests — use its structure as the template.

**Verify the guard fires before keyring for each subcommand:** For `auth status`, the guard
is in `src/config.rs::Config::load_with`. Confirm that `auth login`, `auth refresh`, and
`auth logout` call `Config::load_with` (or an equivalent strict profile-existence check)
early enough that an unknown profile exits 64 before any keyring interaction.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| No `#[ignore]` on new tests | S-TESTTOOL-1 pattern | The new tests MUST be ungated (no `#[ignore]`, no `JR_RUN_KEYRING_TESTS` guard). They exercise the profile-existence check, which fires before the keyring. |
| Test naming convention | `docs/specs/test-naming-convention.md` | New test names: `test_global_profile_flag_propagates_to_auth_login_unknown_profile_exits_64`, `test_global_profile_flag_propagates_to_auth_refresh_unknown_profile_exits_64`, `test_global_profile_flag_propagates_to_auth_logout_unknown_profile_exits_64` |
| Exit code 64 | CLAUDE.md `JrError::exit_code()` | Unknown profile name MUST cause exit code 64. The test MUST assert `status.code() == Some(64)`. |
| Invoke via the same CLI harness | S-TESTTOOL-1 pattern | Use the same CLI-invocation test harness (e.g., `jr_cmd_with_xdg` or equivalent) with a temp config that knows a "real" profile but NOT the test profile name. |
| `cargo clippy -D warnings` must pass | CLAUDE.md zero-warnings policy | After every edit, `cargo clippy -- -D warnings` must exit 0. |

## Library and Framework Requirements

No new library or framework dependencies.

| Item | Version / Constraint |
|------|---------------------|
| Test harness helpers | `tests/common/fixtures.rs` — use existing wiremock/temp-config helpers |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/auth_profiles.rs` | MODIFY | Add 3 new ungated tests: one each for `auth login`, `auth refresh`, `auth logout` global `--profile` fallback with unknown profile name. |

**Files NOT to create:** No new test files. No src/ changes. No CLAUDE.md changes (no
new gated seams introduced; but OPTIONALLY add a comment in the existing `#532` issue
cross-reference in CLAUDE.md if one exists).

## Acceptance Criteria

### AC-001 (#532-COVERAGE-FOLLOW-UP) — `auth login` with unknown `--profile` exits 64 without keyring access

Invoking `jr --profile <nonexistent-profile> auth login` with a config that does NOT contain
that profile name exits with code 64 and does NOT attempt any keyring access (the test runs
without `JR_RUN_KEYRING_TESTS`).

Test name: `test_global_profile_flag_propagates_to_auth_login_unknown_profile_exits_64`

**Verifiable by:**
```bash
cargo test --test auth_profiles test_global_profile_flag_propagates_to_auth_login_unknown_profile_exits_64
# Expected: test runs and passes (no env var needed; exit 64 assertion holds)
```

(traces to #532-COVERAGE-FOLLOW-UP — Login global --profile fallback path ungated)

---

### AC-002 (#532-COVERAGE-FOLLOW-UP) — `auth refresh` with unknown `--profile` exits 64 without keyring access

Invoking `jr --profile <nonexistent-profile> auth refresh` with a config that does NOT
contain that profile exits 64 without keyring access.

Test name: `test_global_profile_flag_propagates_to_auth_refresh_unknown_profile_exits_64`

**Verifiable by:**
```bash
cargo test --test auth_profiles test_global_profile_flag_propagates_to_auth_refresh_unknown_profile_exits_64
# Expected: test runs and passes (no env var needed; exit 64 assertion holds)
```

(traces to #532-COVERAGE-FOLLOW-UP — Refresh global --profile fallback path ungated)

---

### AC-003 (#532-COVERAGE-FOLLOW-UP) — `auth logout` with unknown `--profile` exits 64 without keyring access

Invoking `jr --profile <nonexistent-profile> auth logout` with a config that does NOT
contain that profile exits 64 without keyring access.

Test name: `test_global_profile_flag_propagates_to_auth_logout_unknown_profile_exits_64`

**Verifiable by:**
```bash
cargo test --test auth_profiles test_global_profile_flag_propagates_to_auth_logout_unknown_profile_exits_64
# Expected: test runs and passes (no env var needed; exit 64 assertion holds)
```

(traces to #532-COVERAGE-FOLLOW-UP — Logout global --profile fallback path ungated)

---

### AC-004 (#532-COVERAGE-FOLLOW-UP) — All 3 new tests are ungated and run in default CI

`grep -c '#\[ignore' tests/auth_profiles.rs` is identical before and after adding the 3 new
tests (i.e., 3 after S-TESTTOOL-1, still 3 after this story — none of the new tests are gated).

**Verifiable by:**
```bash
grep -c '#\[ignore' tests/auth_profiles.rs
# Expected: same count as before this story (3 after S-TESTTOOL-1); the 3 new tests are NOT ignored
```

(traces to #532-COVERAGE-FOLLOW-UP — ungated tests for default CI coverage)

---

## Tasks

### Item 1: Read the template test and auth subcommand early-exit paths

- [ ] Read `tests/auth_profiles.rs::test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64` (the template — added by S-TESTTOOL-1)
- [ ] `grep -n 'fn login\|fn refresh\|fn logout' src/cli/auth/login.rs src/cli/auth/refresh.rs src/cli/auth/logout.rs` — note the early-exit location for unknown profile
- [ ] Confirm: each auth subcommand calls `Config::load_with` or equivalent strict guard before any keyring interaction

### Item 2: Add 3 ungated tests to `tests/auth_profiles.rs`

For each of `auth login`, `auth refresh`, `auth logout`:

- [ ] Copy the structure of `test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64`
- [ ] Change the subcommand argument from `auth status` to `auth <subcommand>`
- [ ] Assert `status.code() == Some(64)`
- [ ] Verify the test runs without any env var: `cargo test --test auth_profiles test_global_profile_flag_propagates_to_auth_<subcommand>_unknown_profile_exits_64` passes

### Item 3: Verify no gated tests were accidentally added

- [ ] `grep -c '#\[ignore' tests/auth_profiles.rs` → count unchanged from pre-story baseline (3)
- [ ] `cargo test --test auth_profiles` exits 0 (all gated tests are `#[ignore]` and skipped; all 3 new tests run and pass)

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0 (full suite)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- **Covering the `auth switch` global --profile path.** `auth switch` has different behavior
  (it creates or activates a profile) — defer to a separate analysis story if needed.
- **`src/` logic changes.** Test-only story. No production code is modified.
- **New BCs.** Coverage-gap closure only; PO authorship required for formal BCs.
- **`auth status` path.** Already covered by S-TESTTOOL-1's
  `test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64`.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `tests/auth_profiles.rs` | `tests/` | Effectful (CLI invocation; exits before keychain) | Add 3 ungated tests for Login/Refresh/Logout global --profile fallback |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | #532 | `auth login` with unknown profile does NOT exit 64 early (reaches keyring before profile check) | If confirmed, the test will hang or fail due to keyring access. In that case, the test MUST be gated (`#[ignore]` + `JR_RUN_KEYRING_TESTS`) and a src/-level fix story must be filed to add the early-exit guard. Do NOT merge an ungated test that touches the keyring. |
| EC-002 | #532 | `auth refresh` / `auth logout` early-exit behavior differs from `auth login` or `auth status` | Confirm by reading each handler. If the guard fires at different points, adjust the test invocation (e.g., mock the OAuth token check if needed). The goal is exit 64 BEFORE keyring — if that is not achievable ungatedly for a subcommand, file a separate story. |

## Dependency Analysis

**depends_on: []** — No story dependencies. Standalone test-coverage story.

**blocks: []** — No story depends on this within the current story graph.

This is a LEAF story in the dependency graph.

---

## Story Points and Effort

**3 story points** (small). Breakdown:
- Read template test + auth handler guards: 0.75 SP
- Add 3 new tests: 1.5 SP (0.5 each; mostly copy-paste of template)
- Integration checks: 0.75 SP

Risk: MEDIUM. The assumption that `auth login` / `auth refresh` / `auth logout` all exit 64
before keyring access for an unknown profile MUST be verified (EC-001 / EC-002). If any
subcommand reaches the keyring first, the story scope must expand to add a src/-level fix.
