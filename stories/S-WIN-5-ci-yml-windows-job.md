---
document_type: story
story_id: "S-WIN-5"
title: "ci.yml Windows CI job: windows-latest test+clippy matrix, test-helper seam migration, .gitattributes snap eol=lf"
wave: feature-followup
status: ready
intent: feature
feature_type: ci
mode: feature
scope: medium
severity: MEDIUM
trivial_scope: false
points: 8
priority: P0
tdd_mode: strict
estimated_effort: medium
estimated_days: 2
target_module: ci,tests
subsystems: []
depends_on: ["S-WIN-1", "S-WIN-2"]
blocks: []
bc_anchors:
  - BC-6.2.017
bcs:
  - BC-6.2.017
verification_properties: []
holdout_anchors: []
nfr_anchors:
  - NFR-P-W1
adr_refs:
  - ADR-0016
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-001/windows-build/architecture-delta.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: ["R-W3", "R-W5"]
created: "2026-06-12"
last_updated: "2026-06-12"
breaking_change: false
files_modified:
  - .github/workflows/ci.yml       # TWO changes: (1) add windows-latest to test matrix os list; (2) add strategy.matrix.os to clippy job + runs-on: ${{ matrix.os }}
  - .gitattributes                  # CREATE or MODIFY: add "*.snap text eol=lf"
  - tests/auth_output_json.rs       # jr_isolated() helper: add JR_CONFIG_DIR + JR_CACHE_DIR alongside XDG vars
  - tests/issue_list_assets.rs      # add JR_CONFIG_DIR + JR_CACHE_DIR where XDG vars are set
  - tests/issue_resolution.rs       # add JR_CONFIG_DIR + JR_CACHE_DIR where XDG vars are set
  - tests/ (other files with XDG vars)  # same migration — grep and fix all occurrences
---

# S-WIN-5 — ci.yml Windows CI Job: Test + Clippy Matrix, Test Helper Seam Migration

## Source of Truth

Architecture delta: `.factory/cycles/cycle-001/windows-build/architecture-delta.md §4`
ADR-0016: `.factory/architecture/adr/0016-windows-build-target.md §Decision 3, 5`
BC-6.2.017 body: `.factory/specs/prd/bc-6-config-cache.md §6.2.017`
NFR-P-W1: `.factory/specs/prd/nfr-catalog.md §NFR-P-W1`

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-6.2.017 | `JR_CONFIG_DIR` / `JR_CACHE_DIR` env vars override config/cache directory resolution in debug builds; compiled out in release builds | TRACING: the seam (S-WIN-2) must be active; this story migrates test helpers to USE the seam so Windows CI passes |

## Story Narrative

As a developer contributing to `jr`,
I want `cargo test` to pass on `windows-latest` in CI on every PR,
so that Windows regressions are caught immediately rather than at release time,
and I want the snapshot files to be forced to LF line endings to prevent
CRLF contamination from Windows committers.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,500 |
| .github/workflows/ci.yml (current) | ~1,000 |
| tests/auth_output_json.rs (helper migration — primary shared helper) | ~2,000 |
| tests/issue_list_assets.rs (representative large test file) | ~800 |
| tests/issue_resolution.rs (representative mid-size file) | ~600 |
| 34 remaining in-scope test files (grep output + per-file edit diffs; avg ~300 tok each) | ~10,200 |
| BC-6.2.017 body | ~900 |
| architecture-delta.md §4 | ~600 |
| **Total** | **~17,600** |

Within 20% agent context window budget (37-file migration is mechanical: add two `.env()` calls
per existing XDG `.env()` call site). No splitting required — the migration is uniform
enough that the implementer can batch all 37 files in one pass with the grep output as a checklist.
If a future adversarial pass finds scope-creep in any individual file, splitting at that point
is the recommended mitigation.

## Previous Story Intelligence

**Depends on S-WIN-1 (path resolution) and S-WIN-2 (debug seam).**
Both must be merged before Windows CI can pass. This story is the final integration
story that wires together the preceding work and adds the CI matrix row.

**Test helper migration is the high-risk component of this story.**
The migration from `XDG_CONFIG_HOME`/`XDG_CACHE_HOME` to `JR_CONFIG_DIR`/`JR_CACHE_DIR`
must be done carefully. Architecture-delta.md §2.3/2.4 documents the exact migration
pattern and all affected test files. Authoritative scope: **37 in-scope test files** set
XDG vars and require the `JR_CONFIG_DIR`/`JR_CACHE_DIR` seam added alongside (38 total;
`tests/e2e_live.rs` excluded as fully `#[ignore]`-gated — never runs in the windows-latest
matrix). Enumerate targets with: `grep -rlE 'XDG_CONFIG_HOME|XDG_CACHE_HOME' tests/`

**CORRECTED migration rule (uniform, mechanical — `.join("jr")` on the value):**
The seam value must be the FULLY-RESOLVED directory where the fixture actually lives —
i.e., the XDG value joined with `jr`. This keeps the seam pointing at exactly the same
location as the fixture, on Windows AND Unix:

- For each `.env("XDG_CONFIG_HOME", X)` → add `.env("JR_CONFIG_DIR", X.join("jr"))`
- For each `.env("XDG_CACHE_HOME", Y)` → add `.env("JR_CACHE_DIR", Y.join("jr"))`

The addition is still mechanical and uniform (one `.join("jr")` on the existing path
value). The XDG vars may remain set (they are harmless on Unix).

**Why `.join("jr")` is required (not optional):**
Approximately 25 test files write their config/cache fixture into a `/jr/`-suffixed
subdir: e.g., `dir.path().join("jr").join("config.toml")`. The debug seam
(`JR_CONFIG_DIR`) is used AS-IS — it takes precedence over XDG on Unix debug builds
and is the ONLY isolation mechanism on Windows. Setting `JR_CONFIG_DIR=<TempDir root>`
makes `jr` resolve config at `<TempDir>/config.toml` while the fixture lives at
`<TempDir>/jr/config.toml` → config-not-found → test FAILS on ubuntu/macos too, not
just on Windows. The seam value must therefore be `X.join("jr")`, not `X`.

The only non-mechanical work is the path-string assertion audit described below.

**CRITICAL: two-grep path-string assertion audit (corrected)**
Before migrating, F4 must run BOTH greps:

1. **Fixture-write pattern** (≈25 hits): `grep -rE '\.join\("jr"\)' tests/`
   Identifies files where the fixture is written inside a `/jr/`-suffixed subdir —
   these are the files where the seam value MUST use `.join("jr")`.
   NOTE: this grep MISSES the defect if only the literal-path grep is run — the
   fixture-write is `.join("jr").join("config.toml")`, not the literal string
   `jr/config.toml`. Both greps are required.

2. **Literal path assertions** (may be 0 hits after rule change): `grep -r 'jr/config.toml\|jr/v1/' tests/`
   Identifies any remaining hard-coded path-string assertions that embed the `/jr/`
   suffix. If any remain after migration to the `.join("jr")` seam rule, they are now
   CORRECT (the seam resolves to the `/jr/`-suffixed dir) and do NOT need updating.
   If any such assertion previously expected the suffix to be absent, it should be removed.

See architecture-delta.md §2.3 note.

**Category A tests (`#[cfg(unix)]`) are already correct — do NOT touch them.**
`tests/issue_edit_field.rs::test_bc_3_4_015_*` (lines 1123 and 1190) use
`std::os::unix::fs::PermissionsExt` and `#[cfg(unix)]`. These will correctly
compile-out on Windows. Do not add `cfg` gates to these tests — they are already correct.

**`.gitattributes` — check if file exists before writing.**
If `.gitattributes` already exists in the repo root, ADD the `*.snap text eol=lf` line;
do not replace the file.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| `windows-latest` added to CI test matrix | ADR-0016 §Decision 3 | `.github/workflows/ci.yml` `test` job matrix includes `windows-latest`. `ci.yml` does not use bash syntax in its `run:` steps (only `cargo` commands), so no `shell: bash` override needed. |
| `windows-latest` added to CI clippy matrix | ADR-0016 §Decision 3 | `.github/workflows/ci.yml` `clippy` job gains `strategy.matrix.os: [ubuntu-latest, windows-latest]` and `runs-on: ${{ matrix.os }}`. This is necessary because the `#[cfg(windows)]` code paths added by S-WIN-1/S-WIN-2 can only be linted on a Windows runner. Ubuntu clippy cannot see those branches. |
| Test helper migration: add both vars with `.join("jr")` | architecture-delta.md §2.3 (corrected) | All test helpers that set `XDG_CONFIG_HOME`/`XDG_CACHE_HOME` must ALSO set `JR_CONFIG_DIR`/`JR_CACHE_DIR` to the XDG value `.join("jr")` — the directory where the fixture actually lives. Example: `.env("XDG_CONFIG_HOME", X)` → `.env("JR_CONFIG_DIR", X.join("jr"))`. The XDG vars may remain (harmless on Unix). Setting the seam to the raw TempDir root (without `.join("jr")`) points `jr` at `<TempDir>/config.toml` while the fixture is at `<TempDir>/jr/config.toml` → config-not-found → test FAILS on Ubuntu/macOS too. |
| Seam value = XDG value joined with `jr` | architecture-delta.md §2.3 (corrected) | `JR_CONFIG_DIR` = `<XDG_CONFIG_HOME value>.join("jr")`. `JR_CACHE_DIR` = `<XDG_CACHE_HOME value>.join("jr")`. The debug seam takes the value AS-IS (no additional suffix appended by `jr` itself); the caller must supply the fully-resolved directory. This is still mechanical and uniform — just `.join("jr")` on the XDG value. |
| Two-grep path-string assertion audit | architecture-delta.md §2.3 (corrected) | Before migration, run BOTH: (1) `grep -rE '\.join\("jr"\)' tests/` — fixture-write pattern, ≈25 hits, identifies files where the seam value MUST use `.join("jr")`; (2) `grep -r 'jr/config.toml\|jr/v1/' tests/` — literal-path assertions, identifies hard-coded path strings. Running only the literal-path grep MISSES the fixture-write pattern (it uses `.join("jr").join("config.toml")`, not the literal string `jr/config.toml`). Both greps are required. |
| `.gitattributes` snap LF | architecture-delta.md §4.2 Category C | `*.snap text eol=lf` must be present before Windows committers write snapshot files. This prevents CRLF contamination that would cause cross-platform snapshot mismatches. |
| `fmt` and `deny` jobs stay on ubuntu-latest | architecture-delta.md §4.3 | Only the `test` and `clippy` jobs gain the Windows matrix. `fmt` and `deny` jobs remain ubuntu-only. |
| Category D/E keyring and E2E tests | architecture-delta.md §4.2 D/E | Keyring-gated (`JR_RUN_KEYRING_TESTS=1`) and E2E (`JR_RUN_E2E=1`) tests are already excluded from standard `cargo test`. No additional changes needed. |
| Category F /tmp paths | architecture-delta.md §4.2 F | No `/tmp` hardcoded paths in tests. `tempfile::TempDir` is used everywhere. No changes needed. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| assert_cmd | current (from Cargo.toml dev-deps) | Subprocess invocation of `jr` binary with `.env("JR_CONFIG_DIR", dir.path())` on the `Command` builder. This is the existing pattern used for XDG vars. |
| tempfile | current (from Cargo.toml dev-deps) | `TempDir::new()` resolves to `%TEMP%` on Windows. No change needed. |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `.github/workflows/ci.yml` | MODIFY | TWO matrix changes: (1) In the `test` job's `strategy.matrix.os` list, add `windows-latest`. (2) In the `clippy` job, add `strategy.matrix.os: [ubuntu-latest, windows-latest]` and change `runs-on: ubuntu-latest` to `runs-on: ${{ matrix.os }}`. |
| `.gitattributes` | CREATE or MODIFY | Add `*.snap text eol=lf` (create file if absent; append if present) |
| `tests/auth_output_json.rs` | MODIFY | In `jr_isolated()` helper (~line 69): add `.env("JR_CONFIG_DIR", config_dir.path().join("jr")).env("JR_CACHE_DIR", cache_dir.path().join("jr"))` alongside the existing XDG `.env()` calls. The `.join("jr")` is required because the fixture is written into the `/jr/` subdir. |
| `tests/issue_list_assets.rs` | MODIFY | Locate `.env("XDG_CONFIG_HOME", ...)` and `.env("XDG_CACHE_HOME", ...)` calls; add corresponding `JR_CONFIG_DIR`/`JR_CACHE_DIR` env calls |
| `tests/issue_resolution.rs` | MODIFY | Same migration pattern |
| All other in-scope test files with XDG vars (34 remaining after the 3 named above) | MODIFY | Grep: `grep -rlE 'XDG_CONFIG_HOME\|XDG_CACHE_HOME' tests/` — 38 files total; migrate all 37 in-scope occurrences (skip `tests/e2e_live.rs`) |

## Acceptance Criteria

### AC-001 — `windows-latest` is in ci.yml test matrix
(traces to BC-6.2.017 postcondition — test isolation via seam enables Windows CI; NFR-P-W1)

`.github/workflows/ci.yml` `test` job matrix includes `windows-latest`.
Pinned by: `tests/ci_yml_windows_matrix.rs::test_ci_yml_has_windows_latest_in_test_matrix`
(source-text grep)

---

### AC-002 — `.gitattributes` has `*.snap text eol=lf`
(traces to NFR-P-W1; R-W3 mitigation — snapshot CRLF prevention)

`.gitattributes` contains the line `*.snap text eol=lf`.
Pinned by: `test_gitattributes_has_snap_lf_rule` (source-text grep/read)

---

### AC-003 — `jr_isolated()` helper sets both JR_CONFIG_DIR and JR_CACHE_DIR with `.join("jr")`
(traces to BC-6.2.017 §Test isolation use case — test helpers use cross-platform seam)

`tests/auth_output_json.rs::jr_isolated()` sets `JR_CONFIG_DIR` and `JR_CACHE_DIR`
environment variables via `.env()` calls on the `Command` builder. The seam values MUST
be `config_dir.path().join("jr")` and `cache_dir.path().join("jr")` respectively —
NOT `config_dir.path()` / `cache_dir.path()` alone. The fixture is written into the
`/jr/`-suffixed subdir; the seam must resolve to the same directory.

Pinned by: `test_jr_isolated_helper_sets_jr_config_dir` (source-text grep of the helper
function — must verify the `.join("jr")` suffix is present on the seam value, not merely
that the `.env("JR_CONFIG_DIR", ...)` call is present)

**Note on AC-003 vs AC-004/AC-005 relationship:** AC-003 is a presence-and-value check
on a single named helper. AC-004 is a presence-only cross-check across all 37 files.
Neither AC-003 nor AC-004 verifies runtime correctness — AC-005 (`cargo test` green on
both Unix and Windows) is the real correctness gate. See AC-004 and AC-005 for details.

---

### AC-004 — All in-scope XDG-isolation test files also set JR_CONFIG_DIR / JR_CACHE_DIR (presence check)
(traces to BC-6.2.017 §Test isolation use case; R-W5 mitigation — no test writes to real CI user profile)

Of the 38 test files that set `XDG_CONFIG_HOME`/`XDG_CACHE_HOME`, 37 are in-scope.
The one excluded file is `tests/e2e_live.rs`, which is fully gated behind
`#[ignore]` + `JR_RUN_E2E=1` and is NEVER executed in the `windows-latest` CI matrix
(which does not pass `--include-ignored`). Because `tests/e2e_live.rs` never runs on
Windows CI, its XDG vars do not create a Windows isolation failure.

The cross-check assertion enforces that every test file that sets `XDG_CONFIG_HOME` or
`XDG_CACHE_HOME` ALSO sets `JR_CONFIG_DIR`/`JR_CACHE_DIR`, with an explicit allowlist
containing exactly `["tests/e2e_live.rs"]` for the fully-`#[ignore]`-gated E2E file.
The allowlist in the pinning test MUST be kept in sync with the Out-of-Scope declaration
below: if a file is removed from the allowlist, it must be migrated; if a new file is
added to the allowlist, it must be fully `#[ignore]`-gated.

**Canonical enumeration commands (BOTH required — F-WIN-03 corrected audit):**

Step 1 — fixture-write pattern: `grep -rE '\.join\("jr"\)' tests/`
≈25 hits. Identifies files where the fixture is written into a `/jr/`-suffixed subdir —
the seam value for these files MUST use `.join("jr")` on the XDG path value.
This grep MUST be run FIRST because the literal-path grep below will MISS these files
(the fixture-write is `.join("jr").join("config.toml")`, not the literal `jr/config.toml`).

Step 2 — XDG call site enumeration: `grep -rlE 'XDG_CONFIG_HOME|XDG_CACHE_HOME' tests/`
Expected output: 38 files total, 37 in-scope (all except `tests/e2e_live.rs`).

Step 3 — literal path assertion check: `grep -r 'jr/config.toml\|jr/v1/' tests/`
With the corrected `.join("jr")` seam rule these are now expected to be absent or
correct; any remaining hits that assert the suffix is ABSENT must be removed.

Pinned by: `test_all_xdg_test_files_also_set_jr_seam_vars` (automated source-text grep cross-check
with `ALLOWLISTED_E2E_FILES: &[&str] = &["tests/e2e_live.rs"]` constant in the test)

**IMPORTANT — AC-004 limitation (F-WIN-03):**
`test_all_xdg_test_files_also_set_jr_seam_vars` is a PRESENCE-ONLY check. It verifies
that each in-scope file contains the string `JR_CONFIG_DIR`/`JR_CACHE_DIR` — it does NOT
verify that the seam value expression uses `.join("jr")`. A migration that sets
`JR_CONFIG_DIR = config_dir.path()` (wrong — missing `.join("jr")`) would pass AC-004
but fail at runtime. **AC-005 (`cargo test` green on Ubuntu/macOS/Windows) is the real
correctness gate.** A green AC-004 does NOT imply migration correctness; AC-005 must also
be green. The AC-003 pinning test for `jr_isolated()` should additionally grep for
`.join("jr")` on the seam-value expression to provide partial value-level coverage on
the primary shared helper (even though AC-004 cannot enforce this across all 37 files).

---

### AC-005 — `cargo test` passes on `windows-latest` AND on existing ubuntu/macos runners (regression protection)
(traces to NFR-P-W1 numerical target — Windows CI passes for all non-gated tests; migration must not regress Unix)

`cargo test --all-features` exits 0 on:
- `windows-latest` — the new Windows CI runner
- `ubuntu-latest` — existing Ubuntu CI runner (must remain green; migration is a regression risk)
- `macos-latest` — macOS runner (must remain green; the test matrix IS `[ubuntu-latest, macos-latest, windows-latest]` per architecture-delta.md §4.1 and the live ci.yml; macOS green is a required regression gate)

Tests in Category A (`#[cfg(unix)]`) compile out cleanly on Windows. Tests in Category B
(XDG-isolation) work because the seam override is active (debug build) and the seam value
resolves to the same directory as the fixture (`.join("jr")`).
Tests in Categories D/E (keyring/E2E, `#[ignore]`) are not run.

**AC-005 is the real correctness gate for the seam migration (F-WIN-03).**
AC-004 is a PRESENCE-ONLY check — it cannot detect a wrong seam value. AC-004 passing
with AC-005 FAILING on Ubuntu/macOS is the fingerprint of a seam-value defect (e.g.,
`JR_CONFIG_DIR=<TempDir>` without `.join("jr")`). This combination means the migration
set the `.env()` call but pointed it at the wrong directory.

Pinned by: Windows CI matrix job green (integration gate) AND Ubuntu/macOS CI jobs remaining green.

---

### AC-006 — `clippy` CI job is matrixed over `[ubuntu-latest, windows-latest]` and passes on both
(traces to NFR-P-W1 — Windows build must be warning-free; `#[cfg(windows)]` code linted on Windows runner)

The `clippy` job in `.github/workflows/ci.yml` has `strategy.matrix.os: [ubuntu-latest, windows-latest]`
and `runs-on: ${{ matrix.os }}`. This is required because the `#[cfg(windows)]` code paths introduced by
S-WIN-1/S-WIN-2 are only compiled (and therefore only linted) on a Windows runner. A ubuntu-only clippy
job CANNOT satisfy this criterion — the `#[cfg(windows)]` branches are silently excluded on Linux.

`cargo clippy --all --all-features --tests -- -D warnings` exits 0 on BOTH `ubuntu-latest` AND
`windows-latest` runners.

Pinned by:
- `test_ci_yml_has_windows_latest_in_clippy_matrix` (source-text grep on `strategy.matrix.os` of the `clippy` job) — in `tests/ci_yml_windows_matrix.rs`
- Windows CI clippy matrix job green (integration gate).

Note: AC-008 (`fmt` and `deny` remain ubuntu-only) is unchanged — only `test` and `clippy` gain the Windows matrix.

---

### AC-007 — Snapshot tests pass on Windows (no CRLF contamination)
(traces to R-W3 mitigation — `.gitattributes` ensures LF snapshots)

The `insta` snapshot tests (`tests/snapshots/*.snap`) do not produce cross-platform
mismatches on `windows-latest`. The `.gitattributes` `*.snap text eol=lf` rule
prevents CRLF-contaminated snapshot files from being committed.

Pinned by: Windows CI `cargo test` snapshot tests green.

---

### AC-008 — fmt and deny jobs unchanged (still ubuntu-latest only); clippy is the only other job gaining Windows matrix
(traces to architecture-delta.md §4.3 — only `test` and `clippy` jobs gain Windows; `fmt` and `deny` stay ubuntu-only)

`.github/workflows/ci.yml` `fmt` and `deny` jobs run only on `ubuntu-latest`.
No change to these jobs. The `clippy` job is the only additional job that gains the Windows matrix (see AC-006).

Pinned by: `test_ci_yml_fmt_deny_jobs_remain_ubuntu_only` (source-text grep verifying `fmt` and `deny` jobs have no `windows-latest` in their `runs-on` or matrix config)

---

## Out of Scope (explicit)

- **Keyring-gated tests on Windows**: already gated by `JR_RUN_KEYRING_TESTS=1` + `#[ignore]`.
  No change to the keyring test gate. Windows CI does NOT set `JR_RUN_KEYRING_TESTS=1`.
- **E2E tests on Windows (`tests/e2e_live.rs`)**: already gated by two-layer gate
  (`JR_E2E_ENABLED` + `JR_RUN_E2E`). Windows CI does NOT set these. This file is
  fully `#[ignore]`-gated and is the ONLY file explicitly allowlisted in the AC-004
  grep gate (allowlist constant: `ALLOWLISTED_E2E_FILES = ["tests/e2e_live.rs"]`).
  The allowlist covers exactly this one file (38 total − 1 = 37 in-scope).
  Do NOT add further files to the allowlist without verifying they are fully
  `#[ignore]`-gated and never run in the windows-latest matrix.
- **Windows PowerShell smoke step in release.yml**: deferred per ADR-0016 §Decision 5c.
- **`src/config.rs` inline unit test migration** (`std::env::set_var("JR_CONFIG_DIR")` in unit tests):
  The inline unit tests that call `set_var` may also need `JR_CONFIG_DIR` added if they test
  the full path-resolution flow. F4 must check these tests (they use `ENV_MUTEX`). If needed,
  set both `JR_CONFIG_DIR` and the XDG var in those tests.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `ci.yml` test matrix | `.github/workflows/` | N/A (CI config) | Instructs GitHub Actions to run the test job on Windows |
| `.gitattributes` | repo root | N/A (git config) | Forces LF on snapshot files |
| `jr_isolated()` migration | `tests/auth_output_json.rs` | Effectful (sets env vars) | Subprocess isolation using cross-platform seam vars |

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC / BC |
|----|--------|-------------|-------------------|---------|
| EC-001 | architecture-delta.md §2.3 (corrected) | Fixture written into `/jr/`-suffixed subdir; seam set to raw TempDir root | Seam value MUST use `.join("jr")` — `JR_CONFIG_DIR = X.join("jr")` — so it resolves to the same directory as the fixture. Detected by: `grep -rE '\.join\("jr"\)' tests/` (≈25 hits). Missed by the literal-path grep. A seam set to the raw root causes config-not-found on Ubuntu/macOS AND Windows. | AC-005 (runtime correctness gate); AC-003 (primary helper value check) |
| EC-002 | architecture-delta.md §4.2 B | `src/config.rs` inline unit tests use `set_var("XDG_CONFIG_HOME")` | On Windows these tests also need `set_var("JR_CONFIG_DIR")` added for correct isolation | F4 must handle during migration |
| EC-003 | architecture-delta.md §4.2 C | Windows committer writes snapshot file with CRLF before `.gitattributes` is in place | `.gitattributes` must be added in THIS story before Windows CI is added | AC-002 |
| EC-004 | architecture-delta.md §4.2 D | `JR_RUN_KEYRING_TESTS=1` — Windows Credential Manager in headless CI | Tests not run without the env flag; no issue | (no action) |
| EC-005 | architecture-delta.md §4.2 H | `cargo test` parallelism with `set_var` in unit tests | `ENV_MUTEX` pattern already handles this; preserve it | (verify during migration) |

---

## Test Coverage Summary

| Test name | File | AC |
|-----------|------|-----|
| `test_ci_yml_has_windows_latest_in_test_matrix` | `tests/ci_yml_windows_matrix.rs` (new) | AC-001 |
| `test_gitattributes_has_snap_lf_rule` | same file | AC-002 |
| `test_jr_isolated_helper_sets_jr_config_dir` | same file | AC-003 |
| `test_all_xdg_test_files_also_set_jr_seam_vars` | same file | AC-004 |
| `test_ci_yml_has_windows_latest_in_clippy_matrix` | same file | AC-006 (source-text grep) |
| `test_ci_yml_fmt_deny_jobs_remain_ubuntu_only` | same file | AC-008 |

AC-005/007 are gated by the Windows CI runner — they are integration outcomes, not new test files.
AC-006 is split: the source-text grep (`test_ci_yml_has_windows_latest_in_clippy_matrix`) is a new test file assertion; the "exits 0" half is an integration gate verified by the Windows CI clippy matrix job running green.

---

## Holdout Scenarios

**H-WIN-8: All integration tests pass on windows-latest**
After merging S-WIN-1/2/5, the `ci.yml` Windows test job runs `cargo test --all-features`
and exits 0. No test writes to the real Windows user profile.
_Validation: Windows CI job green on next PR after merge._

**H-WIN-9: Snapshot tests are CRLF-free**
After `.gitattributes` adds `*.snap text eol=lf`, a fresh `git checkout` on a Windows
machine produces snapshot files with LF line endings.
_Validation: `git ls-files -eol tests/snapshots/` shows `lf` for all `.snap` files._

---

## Dependency Analysis

**depends_on: ["S-WIN-1", "S-WIN-2"]**
- S-WIN-2 provides the debug seam (prerequisite for test isolation on Windows).
- S-WIN-1 provides the Windows path resolution (prerequisite for Windows binary behavior).
Both must be merged before this story's Windows CI job will produce green.

**blocks: []** — No other story depends on this.

**Topological order:** {S-WIN-2} → {S-WIN-1} → S-WIN-5 (S-WIN-5 also directly depends on S-WIN-2; see frontmatter `depends_on: ["S-WIN-1", "S-WIN-2"]`).

### S-WIN-3 Runtime Dependency Note (F-WIN-F3-002)

S-WIN-5 is NOT declared as hard-depending on S-WIN-3 (`depends_on` does not include
`"S-WIN-3"`), and this is intentional. The reasons:

1. **Keyring tests are `#[ignore]`-gated.** The standard `cargo test` run in the
   Windows CI matrix does NOT set `JR_RUN_KEYRING_TESTS=1`, so keyring-exercising
   tests are never executed in the CI matrix that this story targets.

2. **Keyring degrades gracefully to a compiling null backend on Windows without
   `windows-native`.** The keyring crate compiles without linker errors; the feature
   gate only determines WHICH credential store backend is selected at runtime. The
   integration test helpers this story migrates do NOT exercise credential storage.

3. **Intra-cycle schedule already orders S-WIN-3 before S-WIN-5.** The windows-build
   intra-cycle delivery schedule places S-WIN-3 in Wave 1 (independent, dispatched
   first) and S-WIN-5 in Wave 3 (after S-WIN-1 and S-WIN-2). In practice S-WIN-3
   will always be merged well before S-WIN-5 reaches F4. A merge-gate hard dependency
   is therefore redundant.

**Conclusion:** S-WIN-5 passes `cargo test` on `windows-latest` without S-WIN-3 being
merged first, because keyring tests are gated. S-WIN-3 must land before a fully
functional Windows _release_ binary (`jr auth login` persisting credentials), but that
is S-WIN-4's concern, not this story's. No `depends_on` change is needed.

---

## Tasks

1. Read `.github/workflows/ci.yml` to understand current `test` and `clippy` job structures.
2. Add `windows-latest` to the `test` job's `os` matrix list.
2b. Add `strategy.matrix.os: [ubuntu-latest, windows-latest]` to the `clippy` job and change its `runs-on: ubuntu-latest` to `runs-on: ${{ matrix.os }}`.
3. Check for `.gitattributes` at repo root. Create or append `*.snap text eol=lf`.
4. Run the two-grep audit (BOTH required):
   a. `grep -rE '\.join\("jr"\)' tests/` — ≈25 files; these are the fixture-write pattern files where the seam value MUST use `.join("jr")`.
   b. `grep -rlE 'XDG_CONFIG_HOME|XDG_CACHE_HOME' tests/` — 38 files total; exclude `tests/e2e_live.rs`; migrate the remaining 37.
   The fixture-write grep (a) must be run first — it identifies the files where `.join("jr")` is required on the seam value and is MISSED by the XDG-call-site grep alone.
5. For each migrated file: set `JR_CONFIG_DIR = <XDG_CONFIG_HOME value>.join("jr")` and `JR_CACHE_DIR = <XDG_CACHE_HOME value>.join("jr")`. For isolation-only helpers that do NOT write a fixture into a `/jr/` subdir, verify the fixture location before choosing the seam value.
5b. Run `grep -r 'jr/config.toml\|jr/v1/' tests/` — with the corrected seam rule, any remaining literal-path assertions that previously expected the suffix to be absent must be removed; hits that assert the suffix IS present are now correct.
6. Migrate `tests/auth_output_json.rs::jr_isolated()` (primary helper).
7. Migrate all other affected test files (see file list above).
8. Migrate any inline unit tests in `src/config.rs` and `src/cache.rs` that call `set_var("XDG_*")`.
9. Create `tests/ci_yml_windows_matrix.rs` with 6 source-text assertions.
10. Run `cargo test` on Unix — all existing tests pass (no regression).
11. Run `cargo test --test ci_yml_windows_matrix` — passes.
12. Run `cargo clippy -- -D warnings` — zero warnings.

## Story Points and Effort

**8 story points** (unchanged). The corrected migration rule (`.join("jr")` on the seam value) is still
mechanical and uniform — the implementer applies the same transformation to all 37 files. The additional
cognitive effort is: (a) running the fixture-write grep first to identify the ≈25 files that write into
a `/jr/` subdir, and (b) verifying isolation-only helpers (if any) that do not use the `/jr/` subdir
pattern. This is a per-file-audit step, not new implementation work, and is subsumed in the existing
37-file migration budget. The non-mechanical work (path-string assertion audit (now two greps), ci.yml
surgery (two matrix changes), `.gitattributes`, new `ci_yml_windows_matrix.rs` test file with 6 assertions)
is unchanged in character. 8 SP remains the correct estimate.

Breakdown:
- F4 TDD (ci.yml + .gitattributes + 37-file test helper migration + path-string audit): 5 SP
- F5/F7 adversarial review + Windows CI verification (AC-004 grep gate green, Windows runner green): 3 SP
