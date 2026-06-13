---
document_type: story
story_id: "S-WIN-2"
title: "JR_CONFIG_DIR / JR_CACHE_DIR debug-only path-isolation seam + config_dir_release_gate test"
wave: feature-followup
status: ready
intent: feature
feature_type: backend
mode: feature
scope: small
severity: MEDIUM
trivial_scope: false
points: 3
priority: P0
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: config,cache
subsystems: []
depends_on: []
blocks: ["S-WIN-1", "S-WIN-5", "S-WIN-6"]
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
sd_refs:
  - SD-002
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-001/windows-build/architecture-delta.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: ["R-W2", "R-W5"]
created: "2026-06-12"
last_updated: "2026-06-12"
breaking_change: false
files_modified:
  - src/config.rs   # global_config_dir(): add JR_CONFIG_DIR seam at top of function, gated #[cfg(debug_assertions)]
  - src/cache.rs    # cache_root(): add JR_CACHE_DIR seam at top of function, gated #[cfg(debug_assertions)]
  - tests/config_dir_release_gate.rs   # NEW: source-adjacency grep test mirroring base_url_release_gate.rs
---

# S-WIN-2 — Debug Path-Isolation Seam: JR_CONFIG_DIR / JR_CACHE_DIR

## Source of Truth

Architecture delta: `.factory/cycles/cycle-001/windows-build/architecture-delta.md §2`
BC-6.2.017 body: `.factory/specs/prd/bc-6-config-cache.md §6.2.017`
ADR-0016: `.factory/architecture/adr/0016-windows-build-target.md §Decision 5`
Pattern reference: `tests/base_url_release_gate.rs` (existing; mirror this exactly)

## Behavioral Contracts

| BC | Title | Role in this story |
|----|-------|-------------------|
| BC-6.2.017 | `JR_CONFIG_DIR` / `JR_CACHE_DIR` env vars override config/cache directory resolution in debug builds; compiled out in release builds | PRIMARY: implement both seams + release gate test |

## Story Narrative

As a developer writing integration tests for `jr`,
I want a `JR_CONFIG_DIR` / `JR_CACHE_DIR` environment variable override
that is active in debug builds on ALL platforms (Unix and Windows),
so that integration tests can isolate config and cache to a TempDir
without relying on `XDG_CONFIG_HOME` (which `dirs` ignores on Windows),
and as a security property I want this override to be compiled out in
release builds so that production binaries cannot be redirected.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,500 |
| src/config.rs (full file) | ~4,000 |
| src/cache.rs (full file) | ~3,500 |
| tests/base_url_release_gate.rs (pattern reference) | ~500 |
| BC-6.2.017 body (bc-6-config-cache.md) | ~900 |
| architecture-delta.md §2 (seam design) | ~700 |
| **Total** | **~11,100** |

Within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**Pattern: `JR_BASE_URL` seam (SD-002, S-0.05)**
The `JR_BASE_URL` env var uses identical mechanics: `#[cfg(debug_assertions)]` gate,
`std::env::var("JR_BASE_URL")` read, return early if set, release gate test
`tests/base_url_release_gate.rs` uses `include_str!("../src/config.rs")` source-
adjacency grep. F4 implementer MUST read `tests/base_url_release_gate.rs` before
writing `tests/config_dir_release_gate.rs`. The gate test pattern is the same.

**This story is a PREREQUISITE for S-WIN-1 and S-WIN-5.**
The debug seam must be at the TOP of `global_config_dir()` and `cache_root()`,
BEFORE the `#[cfg(windows)]` / `#[cfg(not(windows))]` OS branches that S-WIN-1 adds.
F4 may implement S-WIN-2 and S-WIN-1 in the same PR, but the seam code must
appear first in the function body.

**N/A — first story in this Windows-build feature cycle.**
No predecessor story in this cycle to carry forward intelligence from.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| `#[cfg(debug_assertions)]` gate | BC-6.2.017 invariant; SD-002 pattern | The seam read (`std::env::var("JR_CONFIG_DIR")`) must be wrapped in `#[cfg(debug_assertions)]`. No runtime check is sufficient — must be compile-time. |
| Empty-string filter | BC-6.2.017 invariant; EC-1 | Use `.ok().filter(|s| !s.is_empty())`. An empty-string value is treated as unset; OS-branch logic proceeds. |
| Seam at function TOP, before OS branch | BC-6.2.017 invariant; architecture-delta.md §2.6 | The debug seam must be the FIRST code in `global_config_dir()` and `cache_root()`, before ANY `#[cfg(windows)]` / `#[cfg(not(windows))]` blocks. |
| Two independent seams | BC-6.2.017 EC-3 | `JR_CONFIG_DIR` controls config; `JR_CACHE_DIR` controls cache. They are independent: setting one does not affect the other. |
| Release gate test: dual-site source adjacency | BC-6.2.017 §Release gate test | `tests/config_dir_release_gate.rs` must assert BOTH the `src/config.rs` site AND the `src/cache.rs` site. One site unguarded → non-compliant. Pattern: `tests/base_url_release_gate.rs` (which guards both `src/config.rs::base_url()` AND `src/api/client.rs::from_config()`). |
| CLAUDE.md documentation | BC-6.2.017 §CLAUDE.md documentation | `JR_CONFIG_DIR` and `JR_CACHE_DIR` must be added to the JR_* env var table in CLAUDE.md. This doc update is delegated to S-WIN-6 (docs fallout story). The source code change and release gate test are this story's scope. |
| Forbidden: runtime OS check for gate | N/A | Do NOT use `std::env::consts::OS` or `#[cfg(target_os = "windows")]` as the release gate mechanism. The gate must be `#[cfg(debug_assertions)]` — it governs debug-vs-release, not the OS. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| std | stable Rust | `std::env::var` for seam read. `include_str!` macro for source-adjacency test. No new crates. |

No new crate dependencies.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/config.rs` | MODIFY | In `global_config_dir()`, prepend the seam block (exact shape from BC-6.2.017 and architecture-delta.md §1.2): `#[cfg(debug_assertions)] if let Some(dir) = std::env::var("JR_CONFIG_DIR").ok().filter(|s| !s.is_empty()) { return PathBuf::from(dir); }` |
| `src/cache.rs` | MODIFY | In `cache_root()`, prepend the seam block: `#[cfg(debug_assertions)] if let Some(dir) = std::env::var("JR_CACHE_DIR").ok().filter(|s| !s.is_empty()) { return PathBuf::from(dir); }` |
| `tests/config_dir_release_gate.rs` | CREATE | Source-adjacency test mirroring `tests/base_url_release_gate.rs`. Must assert: (1) `src/config.rs` has `#[cfg(debug_assertions)]` within 5 lines before `std::env::var("JR_CONFIG_DIR")`; (2) `src/cache.rs` has `#[cfg(debug_assertions)]` within 5 lines before `std::env::var("JR_CACHE_DIR")`; (3) `const { assert!(cfg!(debug_assertions)); }` compile-time assertion. |

## Acceptance Criteria

### AC-001 — JR_CONFIG_DIR seam overrides config dir in debug build
(traces to BC-6.2.017 postcondition (debug path) — `global_config_dir()` returns PathBuf from seam when set)

In a debug build, when `JR_CONFIG_DIR` is set to `"/tmp/test-config"`,
`global_config_dir()` returns `PathBuf::from("/tmp/test-config")`.
The `XDG_CONFIG_HOME` and OS path logic is bypassed entirely.

Pinned by: `test_bc_6_2_017_config_dir_seam_overrides_path` (unit test in `src/config.rs`)

---

### AC-002 — JR_CACHE_DIR seam overrides cache root in debug build
(traces to BC-6.2.017 postcondition (debug path) — symmetric for `cache_root()`)

In a debug build, when `JR_CACHE_DIR` is set to `"/tmp/test-cache"`,
`cache_root()` returns `PathBuf::from("/tmp/test-cache")`.
The `XDG_CACHE_HOME` and OS path logic is bypassed entirely.

Pinned by: `test_bc_6_2_017_cache_dir_seam_overrides_path` (unit test in `src/cache.rs`)

---

### AC-003 — Empty-string JR_CONFIG_DIR treated as unset
(traces to BC-6.2.017 EC-1 — empty-string filter)

In a debug build, when `JR_CONFIG_DIR` is set to `""` (empty string),
`global_config_dir()` proceeds to OS-branch logic as if the var were unset.
`PathBuf::from("")` is NOT returned.

Pinned by: `test_bc_6_2_017_empty_config_dir_uses_os_path` (unit test in `src/config.rs`)

---

### AC-004 — Only JR_CONFIG_DIR set does not affect cache
(traces to BC-6.2.017 EC-3 — seams are independent)

In a debug build, when `JR_CONFIG_DIR` is set but `JR_CACHE_DIR` is unset,
`cache_root()` returns the OS-determined path (not influenced by `JR_CONFIG_DIR`).

Pinned by: `test_bc_6_2_017_config_seam_does_not_affect_cache` (unit test in `src/cache.rs`)

---

### AC-005 — Release gate: `JR_CONFIG_DIR` read is adjacent to `#[cfg(debug_assertions)]` in src/config.rs
(traces to BC-6.2.017 §Release gate test — source-adjacency assertion for config site)

`tests/config_dir_release_gate.rs` successfully asserts that in the source text of
`src/config.rs`, the string `#[cfg(debug_assertions)]` appears within 5 lines
(in the preceding source) of the string `"JR_CONFIG_DIR"`. This is a compile-time
source-text check, not a runtime behavior check.

Pinned by: `test_jr_config_dir_seam_is_debug_gated_at_config_site` in `tests/config_dir_release_gate.rs`

---

### AC-006 — Release gate: `JR_CACHE_DIR` read is adjacent to `#[cfg(debug_assertions)]` in src/cache.rs
(traces to BC-6.2.017 §Release gate test — source-adjacency assertion for cache site)

`tests/config_dir_release_gate.rs` successfully asserts that in the source text of
`src/cache.rs`, the string `#[cfg(debug_assertions)]` appears within 5 lines
(in the preceding source) of the string `"JR_CACHE_DIR"`. This is a separate
required assertion from AC-005 — both sites must be verified.

Pinned by: `test_jr_cache_dir_seam_is_debug_gated_at_cache_site` in `tests/config_dir_release_gate.rs`

---

### AC-007 — Release gate test contains compile-time debug_assertions check
(traces to BC-6.2.017 §Release gate test — compile-time assertion in the test itself)

`tests/config_dir_release_gate.rs` contains `const { assert!(cfg!(debug_assertions)); }`
(or equivalent `static_assertions` / inline const block) so that the test file itself
fails to compile when run in a release profile. This ensures the test cannot give a
false green in a release build.

Pinned by: `const { assert!(cfg!(debug_assertions)); }` in `tests/config_dir_release_gate.rs`

---

### AC-008 — Empty-string JR_CACHE_DIR treated as unset
(traces to BC-6.2.017 EC-5 — empty-string filter, symmetric cache-side)

In a debug build, when `JR_CACHE_DIR` is set to `""` (empty string),
`cache_root()` proceeds to OS-branch logic as if the var were unset.
`PathBuf::from("")` is NOT returned.
The `.filter(|s| !s.is_empty())` guard fires and the seam is skipped, exactly
symmetric to AC-003 for the config side.

Pinned by: `test_bc_6_2_017_empty_cache_dir_uses_os_path` (unit test in `src/cache.rs`)

---

## Out of Scope (explicit)

- **`#[cfg(windows)]` / `#[cfg(not(windows))]` OS branches**: implemented in S-WIN-1.
- **Test helper migration** (`jr_isolated()` etc. adding `JR_CONFIG_DIR`/`JR_CACHE_DIR`): implemented in S-WIN-5.
- **CLAUDE.md doc update**: implemented in S-WIN-6.
- **Integration tests using the seam**: covered by S-WIN-5 (the seam is a prerequisite; S-WIN-5 exercises it via the migrated test helpers).

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `global_config_dir()` seam block | `src/config.rs` | Effectful (reads env var) | `#[cfg(debug_assertions)]` block; reads `JR_CONFIG_DIR`; returns early if set |
| `cache_root()` seam block | `src/cache.rs` | Effectful (reads env var) | `#[cfg(debug_assertions)]` block; reads `JR_CACHE_DIR`; returns early if set |
| `tests/config_dir_release_gate.rs` | test | Pure (source-text grep) | `include_str!` + string search; no binary execution |

**Dependency anchor:** `depends_on: []` — this is the foundational story with no prerequisites.
It must be the first story dispatched in the Windows-build feature cycle.

**Blocks:** S-WIN-1 (needs seam present before OS branches), S-WIN-5 (Windows CI test
isolation depends on seam), S-WIN-6 (docs fallout story documents JR_CONFIG_DIR /
JR_CACHE_DIR — seam must be implemented before docs can accurately describe the
env-var interface and the release-gate test).

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC / BC |
|----|--------|-------------|-------------------|---------|
| EC-001 | BC-6.2.017 EC-1 | `JR_CONFIG_DIR=""` in debug build | Treated as unset; OS-branch logic fires | AC-003 |
| EC-002 | BC-6.2.017 EC-2 | `JR_CONFIG_DIR` set in release build | Silently ignored (code compiled out); no warning emitted | (release gate test verifies this structurally) |
| EC-003 | BC-6.2.017 EC-3 | Only `JR_CONFIG_DIR` set, `JR_CACHE_DIR` unset | Config uses seam; cache uses OS logic | AC-004 |
| EC-004 | BC-6.2.017 §Test isolation note | Both `XDG_CONFIG_HOME` and `JR_CONFIG_DIR` set to different values | `JR_CONFIG_DIR` wins (seam is checked first); XDG is silently ignored | (architecture-delta.md §2.3) |
| EC-005 | BC-6.2.017 EC-5 | `JR_CACHE_DIR=""` in debug build | Treated as unset; symmetric to EC-001; `.filter(|s| !s.is_empty())` fires, OS-branch logic proceeds | AC-008 |

---

## Test Coverage Summary

| Test name | File | BC | AC |
|-----------|------|----|----|
| `test_bc_6_2_017_config_dir_seam_overrides_path` | `src/config.rs` (unit) | BC-6.2.017 postcondition | AC-001 |
| `test_bc_6_2_017_cache_dir_seam_overrides_path` | `src/cache.rs` (unit) | BC-6.2.017 postcondition | AC-002 |
| `test_bc_6_2_017_empty_config_dir_uses_os_path` | `src/config.rs` (unit) | BC-6.2.017 EC-1 | AC-003 |
| `test_bc_6_2_017_config_seam_does_not_affect_cache` | `src/cache.rs` (unit) | BC-6.2.017 EC-3 | AC-004 |
| `test_bc_6_2_017_empty_cache_dir_uses_os_path` | `src/cache.rs` (unit) | BC-6.2.017 EC-5 | AC-008 |
| `test_jr_config_dir_seam_is_debug_gated_at_config_site` | `tests/config_dir_release_gate.rs` | BC-6.2.017 §Release gate | AC-005 |
| `test_jr_cache_dir_seam_is_debug_gated_at_cache_site` | `tests/config_dir_release_gate.rs` | BC-6.2.017 §Release gate | AC-006 |
| `const { assert!(cfg!(debug_assertions)); }` | `tests/config_dir_release_gate.rs` | BC-6.2.017 §Release gate | AC-007 |

**Note on ENV_MUTEX:** Unit tests calling `std::env::set_var("JR_CONFIG_DIR", ...)` must
use the `ENV_MUTEX` serialization pattern (existing in `src/config.rs` and `src/cache.rs`
test modules) to avoid data races in parallel test execution.

---

## Holdout Scenarios

**H-WIN-3: Debug seam takes precedence over XDG on Unix**
On a Unix debug build, when both `JR_CONFIG_DIR=/tmp/seam` and `XDG_CONFIG_HOME=/tmp/xdg`
are set, `global_config_dir()` returns `/tmp/seam`. The seam fires first.
_Validation: unit test `test_bc_6_2_017_config_dir_seam_overrides_path` (AC-001)._

**H-WIN-4: Release gate test passes in release profile compile check**
The `tests/config_dir_release_gate.rs` source-adjacency grep tests pass on `cargo test`.
The `const { assert!(cfg!(debug_assertions)); }` would cause a compile-time failure
if the test were mistakenly compiled with `--release`.
_Validation: `cargo test tests/config_dir_release_gate` exits 0._

---

## Dependency Analysis

**depends_on: []** — No prerequisites. This story is Wave 1 in the Windows-build wave schedule.

**Blocks: S-WIN-1** (OS branches must have the seam above them), **S-WIN-5** (Windows CI
test isolation requires both the seam and the migrated test helpers), and **S-WIN-6**
(docs fallout: CLAUDE.md JR_* table entries and Windows path docs follow the seam
implementation — accurate docs require the seam interface to be finalized).

**No cycle.** Topological order: S-WIN-2 → {S-WIN-1, S-WIN-6} → S-WIN-5.

---

## Tasks

1. Read `tests/base_url_release_gate.rs` to understand the exact source-adjacency test pattern.
2. Read `src/config.rs::global_config_dir()` current body (baseline).
3. Read `src/cache.rs::cache_root()` current body (baseline).
4. In `src/config.rs::global_config_dir()`: add the seam block at the top of the function body (before any existing logic).
5. In `src/cache.rs::cache_root()`: add the seam block at the top of the function body.
6. Write 5 unit tests in respective source files (with `ENV_MUTEX` guards where `set_var` is used): AC-001..AC-004 plus AC-008 (`test_bc_6_2_017_empty_cache_dir_uses_os_path` in `src/cache.rs`).
7. Create `tests/config_dir_release_gate.rs` mirroring `tests/base_url_release_gate.rs` — dual-site source-adjacency assertions + compile-time `const { assert!(cfg!(debug_assertions)); }`.
8. Run `cargo test --lib` — all existing + new unit tests green.
9. Run `cargo test --test config_dir_release_gate` — release gate test passes.
10. Run `cargo clippy -- -D warnings` — zero warnings.

## Story Points and Effort

**3 story points.** Small, mechanical change following established pattern.

Breakdown:
- F4 TDD implementation (2 seam blocks + 4 unit tests + 1 release gate test file): 2 SP
- F5/F7 adversarial review + PR: 1 SP
