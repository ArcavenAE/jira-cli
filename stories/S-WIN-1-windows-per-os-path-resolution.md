---
document_type: story
story_id: "S-WIN-1"
title: "Per-OS path resolution: #[cfg(windows)] branches in global_config_dir() and cache_root()"
wave: feature-followup
status: ready
intent: feature
feature_type: backend
mode: feature
scope: small
severity: MEDIUM
trivial_scope: false
points: 5
priority: P0
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: config,cache
subsystems: []
depends_on: ["S-WIN-2"]
blocks: ["S-WIN-5"]
bc_anchors:
  - BC-6.1.014
  - BC-6.2.016
  - BC-6.2.004
bcs:
  - BC-6.1.014
  - BC-6.2.016
  - BC-6.2.004
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
risk_mitigations: ["R-W5"]
created: "2026-06-12"
last_updated: "2026-06-12"
breaking_change: false
files_modified:
  - src/config.rs   # global_config_dir(): add #[cfg(windows)] branch using dirs::config_dir() with APPDATA defensive fallback; JR_CONFIG_DIR seam (from S-WIN-2) must be present first
  - src/cache.rs    # cache_root(): add #[cfg(windows)] branch using dirs::cache_dir() with LOCALAPPDATA defensive fallback; JR_CACHE_DIR seam (from S-WIN-2) must be present first
---

# S-WIN-1 — Per-OS Path Resolution: Windows AppData Branches

## Source of Truth

Architecture delta: `.factory/cycles/cycle-001/windows-build/architecture-delta.md §1`
BC-6.1.014 body: `.factory/specs/prd/bc-6-config-cache.md §6.1.014`
BC-6.2.016 body: `.factory/specs/prd/bc-6-config-cache.md §6.2.016`
BC-6.2.004 body: `.factory/specs/prd/bc-6-config-cache.md §6.2.004`
ADR-0016: `.factory/architecture/adr/0016-windows-build-target.md §Decision 4`

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-6.1.014 | On Windows, `global_config_dir()` resolves to `%APPDATA%\jr\` via `dirs::config_dir()`; XDG NOT consulted | PRIMARY: implement `#[cfg(windows)]` branch in `global_config_dir()` |
| BC-6.2.016 | On Windows, `cache_root()` resolves to `%LOCALAPPDATA%\jr\` via `dirs::cache_dir()`; XDG NOT consulted | PRIMARY: implement `#[cfg(windows)]` branch in `cache_root()` |
| BC-6.2.004 | Per-profile cache directory — platform-conditional root | TRACING: Windows clause now active; `v1/` versioning root preserved |

## Story Narrative

As a Windows user of `jr`,
I want the CLI to store its configuration in `%APPDATA%\jr\config.toml`
and its cache in `%LOCALAPPDATA%\jr\v1\<profile>\`,
so that `jr` follows Windows conventions and my config is visible in the
expected AppData location rather than an unusual `%USERPROFILE%\.config\jr` path.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,500 |
| src/config.rs (full file, ~500 LOC) | ~4,000 |
| src/cache.rs (full file, ~450 LOC) | ~3,500 |
| BC files (3 BCs — bc-6-config-cache.md delta) | ~800 |
| architecture-delta.md §1 | ~600 |
| Test output (cargo test cache/config unit tests) | ~400 |
| **Total** | **~10,800** |

Within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**Predecessor: S-WIN-2 (test-isolation seam — MUST land first)**
S-WIN-2 adds the `JR_CONFIG_DIR`/`JR_CACHE_DIR` debug seam at the TOP of
`global_config_dir()` and `cache_root()`. S-WIN-1 adds the `#[cfg(windows)]`
OS branch AFTER that seam. The seam code from S-WIN-2 must already be merged
before F4 implements this story. If implementing both S-WIN-1 and S-WIN-2 in
the same PR, put the seam block first (lines 1-6 of the function body), then
the `#[cfg(windows)]` block.

**Config location in codebase (baseline):**
`src/config.rs::global_config_dir()` ~line 466: currently uses
`if let Ok(xdg) = std::env::var("XDG_CONFIG_HOME")` → XDG or `home_dir().join(".config").join("jr")`.

**Cache location in codebase (baseline):**
`src/cache.rs::cache_root()` ~line 67: currently uses
`if let Ok(xdg) = std::env::var("XDG_CACHE_HOME")` → XDG or `home_dir().join(".cache").join("jr")`.

**`cache_dir(profile)` is unchanged:**
The composed function `cache_root().join("v1").join(profile)` remains untouched.
Only `cache_root()` changes. The `v1/` versioning root is preserved on all platforms.

**Unix behavior unchanged (load-bearing invariant):**
The `#[cfg(not(windows))]` branch is unchanged. The existing XDG / `home_dir`
logic for Unix must be preserved byte-for-byte inside the `#[cfg(not(windows))]`
block. Do NOT change the Unix fallback.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Seam before OS branch | BC-6.2.017 invariant; architecture-delta.md §2.6 | `JR_CONFIG_DIR` / `JR_CACHE_DIR` debug seam (from S-WIN-2) must appear BEFORE the `#[cfg(windows)]` block. Execution order: seam check → Windows branch → Unix branch. |
| `#[cfg(windows)]` / `#[cfg(not(windows))]` split | BC-6.1.014 invariant; ADR-0016 §Decision 4 | Use compile-time cfg, not runtime OS detection. Both branches must be present and mutually exclusive. |
| APPDATA empty-string filter | BC-6.1.014 EC-1 | `unwrap_or_else` fallback reads `APPDATA`/`LOCALAPPDATA` via `.ok().filter(|s| !s.is_empty()).map(PathBuf::from).unwrap_or_else(|| PathBuf::from("."))`. Empty string treated as unset → `./jr` defensive path. |
| XDG NOT consulted on Windows | BC-6.1.014 invariant; BC-6.2.016 invariant | `XDG_CONFIG_HOME` and `XDG_CACHE_HOME` must not appear inside the `#[cfg(windows)]` block. They remain ONLY in the `#[cfg(not(windows))]` block. |
| Unix behavior unchanged | BC-6.1.014; BC-6.2.016 | The `#[cfg(not(windows))]` branch is a verbatim wrap of the existing function body. No XDG logic changes. |
| No new crates | architecture-delta.md §5.1 | `dirs` is already a dependency (v6.0.0 in Cargo.toml). No new crate additions in this story. |
| Forbidden dependency | architecture-delta.md §1.2 | `config.rs` must NOT import platform-specific APIs directly. Use `dirs::config_dir()` and `dirs::cache_dir()` — the `dirs` crate provides the abstraction. `std::env::var("APPDATA")` is acceptable only as a fallback inside `unwrap_or_else`. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| dirs | 6.0.0 (from Cargo.toml) | `dirs::config_dir()` returns `Option<PathBuf>` mapping to `%APPDATA%` on Windows and `~/.config` on macOS/Linux. `dirs::cache_dir()` returns `%LOCALAPPDATA%` on Windows and `~/.cache` on macOS/Linux. These are the correct functions per ADR-0016. |
| std | stable Rust | `std::env::var("APPDATA")` and `std::env::var("LOCALAPPDATA")` are fallbacks only. |

No new crate dependencies.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/config.rs` | MODIFY | In `global_config_dir()`: wrap existing Unix body in `#[cfg(not(windows))]` block; add `#[cfg(windows)]` block using `dirs::config_dir().unwrap_or_else(...)...join("jr")` per architecture-delta.md §1.2 exact code shape. The seam check from S-WIN-2 remains at the top, before both cfg blocks. |
| `src/cache.rs` | MODIFY | In `cache_root()`: wrap existing Unix body in `#[cfg(not(windows))]` block; add `#[cfg(windows)]` block using `dirs::cache_dir().unwrap_or_else(...)...join("jr")` per architecture-delta.md §1.2 exact code shape. The seam check from S-WIN-2 remains at the top, before both cfg blocks. |

No new files created. No test files added here (test coverage is via unit tests that
run on the cross-compilation CI — Windows unit tests in the same source file, gated
by `#[cfg(windows)]`).

## Acceptance Criteria

### AC-001 — Windows config path is `%APPDATA%\jr`
(traces to BC-6.1.014 postcondition — `dirs::config_dir().join("jr")` on Windows)

When built for `#[cfg(windows)]` target and `dirs::config_dir()` returns
`Some(PathBuf::from("C:\\Users\\Alice\\AppData\\Roaming"))`,
`global_config_dir()` returns `PathBuf::from("C:\\Users\\Alice\\AppData\\Roaming\\jr")`.

Pinned by: `test_bc_6_1_014_windows_config_dir_uses_appdata` (unit test, `#[cfg(windows)]`)

---

### AC-002 — Windows config fallback when `dirs::config_dir()` fails
(traces to BC-6.1.014 EC-1 — APPDATA defensive fallback; empty-string filter)

When built for `#[cfg(windows)]` target and `dirs::config_dir()` returns `None`
and `APPDATA` env var is set to `"C:\\Users\\Alice\\AppData\\Roaming"`,
`global_config_dir()` returns `PathBuf::from("C:\\Users\\Alice\\AppData\\Roaming\\jr")`.

When `APPDATA` is empty (`""`) or unset, `global_config_dir()` returns `PathBuf::from("./jr")`
(the `PathBuf::from(".")` defensive fallback with `.join("jr")`).

Pinned by: `test_bc_6_1_014_appdata_env_fallback` (unit test, `#[cfg(windows)]`)

---

### AC-003 — Windows XDG_CONFIG_HOME has no effect
(traces to BC-6.1.014 invariant — XDG NOT consulted on Windows)

When built for `#[cfg(windows)]` target and `XDG_CONFIG_HOME` is set to any value,
`global_config_dir()` ignores it and returns the `dirs::config_dir()`-derived path.
`XDG_CONFIG_HOME` is not read inside the `#[cfg(windows)]` branch.

Pinned by: `test_bc_6_1_014_xdg_ignored_on_windows` (unit test, `#[cfg(windows)]`)

---

### AC-004 — Unix config path unchanged
(traces to BC-6.1.014 invariant — Unix behavior unchanged)

When built for `#[cfg(not(windows))]` target, `global_config_dir()` behavior is
byte-for-byte identical to the pre-Windows-build behavior:
- `XDG_CONFIG_HOME` set → `$XDG_CONFIG_HOME/jr`
- `XDG_CONFIG_HOME` unset → `dirs::home_dir().join(".config").join("jr")`

Pinned by: existing unit tests in `src/config.rs` (must remain green; no regression).

---

### AC-005 — Windows cache root is `%LOCALAPPDATA%\jr`
(traces to BC-6.2.016 postcondition — `dirs::cache_dir().join("jr")` on Windows)

When built for `#[cfg(windows)]` target and `dirs::cache_dir()` returns
`Some(PathBuf::from("C:\\Users\\Alice\\AppData\\Local"))`,
`cache_root()` returns `PathBuf::from("C:\\Users\\Alice\\AppData\\Local\\jr")`.

Pinned by: `test_bc_6_2_016_windows_cache_root_uses_localappdata` (unit test, `#[cfg(windows)]`)

---

### AC-006 — Windows cache fallback when `dirs::cache_dir()` fails
(traces to BC-6.2.016 EC-1 — LOCALAPPDATA defensive fallback; empty-string filter)

When built for `#[cfg(windows)]` target and `dirs::cache_dir()` returns `None`
and `LOCALAPPDATA` env var is set to `"C:\\Users\\Alice\\AppData\\Local"`,
`cache_root()` returns `PathBuf::from("C:\\Users\\Alice\\AppData\\Local\\jr")`.

When `LOCALAPPDATA` is empty (`""`) or unset, `cache_root()` returns `PathBuf::from("./jr")`.

Pinned by: `test_bc_6_2_016_localappdata_env_fallback` (unit test, `#[cfg(windows)]`)

---

### AC-007 — Windows per-profile cache path includes `v1/` root
(traces to BC-6.2.016 postcondition — per-profile path `%LOCALAPPDATA%\jr\v1\<profile>\`; BC-6.2.004 Windows clause)

The composed `cache_dir(profile)` = `cache_root().join("v1").join(profile)`.
On Windows, `cache_dir("default")` =
`PathBuf::from("C:\\Users\\Alice\\AppData\\Local\\jr\\v1\\default")`.
The `v1/` versioning root is present on Windows the same as on Unix.

Pinned by: `test_bc_6_2_004_windows_per_profile_path_includes_v1` (unit test, `#[cfg(windows)]`)

---

### AC-008 — Unix cache root unchanged
(traces to BC-6.2.016 invariant — Unix behavior unchanged)

When built for `#[cfg(not(windows))]` target, `cache_root()` behavior is
byte-for-byte identical to the pre-Windows-build behavior:
- `XDG_CACHE_HOME` set → `$XDG_CACHE_HOME/jr`
- `XDG_CACHE_HOME` unset → `dirs::home_dir().join(".cache").join("jr")`

Pinned by: existing unit tests in `src/cache.rs` (must remain green; no regression).

---

## Out of Scope (explicit)

- **`JR_CONFIG_DIR` / `JR_CACHE_DIR` debug seam**: implemented in S-WIN-2, which must land first.
- **CI pipeline changes**: implemented in S-WIN-5 (ci.yml Windows job).
- **Release pipeline changes**: implemented in S-WIN-4 (release.yml).
- **Keyring `windows-native` feature**: implemented in S-WIN-3.
- **Test helper migration**: the test helpers (`jr_isolated()` etc.) that set `JR_CONFIG_DIR`/`JR_CACHE_DIR` are migrated in S-WIN-5.
- **CLAUDE.md doc update**: implemented in S-WIN-6.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `global_config_dir()` — Windows branch | `src/config.rs` | Effectful (reads env vars, calls OS APIs via `dirs`) | New `#[cfg(windows)]` code path; returns OS-derived `PathBuf` |
| `global_config_dir()` — Unix branch | `src/config.rs` | Effectful (reads env vars via `dirs`) | Existing code, wrapped in `#[cfg(not(windows))]`; unchanged behavior |
| `cache_root()` — Windows branch | `src/cache.rs` | Effectful (reads env vars, calls OS APIs via `dirs`) | New `#[cfg(windows)]` code path; returns OS-derived `PathBuf` |
| `cache_root()` — Unix branch | `src/cache.rs` | Effectful (reads env vars via `dirs`) | Existing code, wrapped in `#[cfg(not(windows))]`; unchanged behavior |

**Dependency anchor:** `depends_on: ["S-WIN-2"]` — the debug seam (S-WIN-2) must be in
`global_config_dir()` and `cache_root()` before the OS branches are added. The seam
checks `JR_CONFIG_DIR`/`JR_CACHE_DIR` at the top of each function; the OS branches follow.
Without the seam, Windows CI tests (S-WIN-5) cannot isolate config/cache to TempDir.

**Blocks:** `S-WIN-5` (Windows CI job). The CI job requires correct Windows paths AND
the seam migration of test helpers. S-WIN-1 provides the correct Windows paths.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC / BC |
|----|--------|-------------|-------------------|---------|
| EC-001 | BC-6.1.014 EC-1 | `dirs::config_dir()` returns `None` on Windows (rare Known Folder API failure) | APPDATA env fallback with empty-string filter; falls to `./jr` if both fail | AC-002 |
| EC-002 | BC-6.2.016 EC-1 | `dirs::cache_dir()` returns `None` on Windows (rare Known Folder API failure) | LOCALAPPDATA env fallback with empty-string filter; falls to `./jr` if both fail | AC-006 |
| EC-003 | BC-6.1.014 EC-1 | `APPDATA` env var set to empty string `""` | Treated as unset (filtered); falls to `./jr` defensive path | AC-002 |
| EC-004 | BC-6.2.016 EC-1 | `LOCALAPPDATA` env var set to empty string `""` | Treated as unset (filtered); falls to `./jr` defensive path | AC-006 |
| EC-005 | BC-6.1.014 invariant | `XDG_CONFIG_HOME` set on Windows (e.g., in a WSL-adjacent environment) | Ignored; Windows branch calls `dirs::config_dir()` unconditionally | AC-003 |
| EC-006 | BC-6.2.016 EC-2 | Existing Windows user who ran pre-BC-6.2.016 build; has `%USERPROFILE%\.cache\jr\` files | Old files orphan harmlessly; TTL expiry → re-fetch; no migration | (documented, no test needed) |
| EC-007 | architecture-delta.md §2.6 | S-WIN-2 seam active and `JR_CONFIG_DIR` set | Seam fires first; OS branch not reached | (S-WIN-2 concern; AC-001 covers normal path) |

---

## Test Coverage Summary

All tests are `#[cfg(windows)]`-gated unit tests in `src/config.rs` and `src/cache.rs`.
These tests run on the Windows CI runner (S-WIN-5). On Unix CI they are compiled out.

| Test name | BC | AC |
|-----------|----|----|
| `test_bc_6_1_014_windows_config_dir_uses_appdata` | BC-6.1.014 postcondition | AC-001 |
| `test_bc_6_1_014_appdata_env_fallback` | BC-6.1.014 EC-1 | AC-002 |
| `test_bc_6_1_014_xdg_ignored_on_windows` | BC-6.1.014 invariant | AC-003 |
| `test_bc_6_2_016_windows_cache_root_uses_localappdata` | BC-6.2.016 postcondition | AC-005 |
| `test_bc_6_2_016_localappdata_env_fallback` | BC-6.2.016 EC-1 | AC-006 |
| `test_bc_6_2_004_windows_per_profile_path_includes_v1` | BC-6.2.004; BC-6.2.016 postcondition | AC-007 |

Existing Unix tests: must all remain green on Unix CI (no regression gate for AC-004, AC-008).

**Note on ENV_MUTEX:** The unit tests that call `std::env::set_var` must use the existing
`ENV_MUTEX` pattern (a `Mutex<()>` in `src/config.rs` and `src/cache.rs` tests) to
serialize tests that mutate global env state. F4 implementer must check whether the
existing mutex is present before adding new `set_var` calls, and add `ENV_MUTEX.lock()`
guards to new tests that call `std::env::set_var("APPDATA", ...)` etc.

**Note on path-separator assertions (F-WIN-F3-005):** These tests are `#[cfg(windows)]`-gated
and run on a Windows runner where `PathBuf::join` produces `\`-separated paths. When
writing assertions that compare expected path values, use `PathBuf`/`Path` component
comparison (e.g., `result.ends_with(Path::new("jr"))`, `result.components().collect()`)
or construct expected values via `PathBuf::from(root).join("jr")` rather than embedding
`/`-separated string literals (e.g., avoid `assert_eq!(result.to_str().unwrap(), "C:/Users/Alice/AppData/Roaming/jr")`).
`PathBuf::join` on Windows produces `\`-separated paths, so a string-literal assertion
with `/` will fail even when the path is semantically correct.

---

## Holdout Scenarios

These scenarios must PASS on a Windows runner after S-WIN-1 is implemented:

**H-WIN-1: Windows config dir is APPDATA-based**
`jr config show` (or equivalent debug invocation) on a Windows runner with a standard
user profile resolves the config path to a path containing `AppData\Roaming\jr`.
_Validation: CI log from Windows runner shows the path in startup output or test assertion._

**H-WIN-2: Unix config dir is unchanged after S-WIN-1**
On Ubuntu and macOS CI runners, `global_config_dir()` continues to return the XDG/home-based
path. No regression on existing config path tests.
_Validation: existing unit tests pass with no changes._

---

## Dependency Analysis

**Depends on: S-WIN-2** (debug seam must be present in both functions before OS branches are added).

**Blocks: S-WIN-5** (Windows CI job requires correct Windows path resolution AND the seam-based
test isolation to be working before `cargo test` can pass on `windows-latest`).

**No cycle:** S-WIN-1 ← S-WIN-2 (S-WIN-1 depends on S-WIN-2). S-WIN-5 depends on S-WIN-1 and S-WIN-2. No cycle.

Topological order: S-WIN-2 → S-WIN-1 → S-WIN-5.

---

## Tasks

1. Read `src/config.rs::global_config_dir()` (current body; ~line 466).
2. Read `src/cache.rs::cache_root()` (current body; ~line 67).
3. Read architecture-delta.md §1.2 for the exact target code shapes.
4. Verify S-WIN-2 (debug seam) is already merged (the `JR_CONFIG_DIR` seam block must be present at the top of each function before adding the OS branches).
5. In `src/config.rs::global_config_dir()`: wrap existing body in `#[cfg(not(windows))]`; add `#[cfg(windows)]` block per architecture-delta.md §1.2 exact shape.
6. In `src/cache.rs::cache_root()`: wrap existing body in `#[cfg(not(windows))]`; add `#[cfg(windows)]` block per architecture-delta.md §1.2 exact shape.
7. Write 6 unit tests (listed above) gated with `#[cfg(windows)]`.
8. Run `cargo test --lib` on a Unix host — all existing tests green (Windows-gated tests compile-out cleanly).
9. Run `cargo clippy -- -D warnings` on Unix host — zero warnings.

## Story Points and Effort

**5 story points.** New platform branch implementation with careful invariant-preservation
of Unix behavior, defensive fallbacks, and cfg-gated test coverage.

Breakdown:
- F4 TDD implementation (OS branch code + 6 unit tests): 3 SP
- F5 adversarial review + fixes: 1 SP
- F6/F7 formal verification + PR: 1 SP
