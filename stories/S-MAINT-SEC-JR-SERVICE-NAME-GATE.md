---
document_type: story
story_id: "S-MAINT-SEC-JR-SERVICE-NAME-GATE"
title: "Gate JR_SERVICE_NAME env var behind #[cfg(debug_assertions)] and add release-gate regression test"
wave: feature-followup
status: draft
intent: bug-fix
feature_type: security
mode: feature
scope: small
severity: LOW
trivial_scope: false
points: 2
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 0.5
target_module: api
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: pending PO authorship
# Security hardening story. The JR_SERVICE_NAME gate is a seam-consistency fix, not a
# new user-visible behavioral contract. Closely mirrors the pattern of S-0.05
# (JR_AUTH_HEADER gate) and existing JR_BASE_URL gates.
# If a formal BC is authored (BC-1.X.NNN for env-var gate policy), add it here.
# Until then this story may not be dispatched to status: ready per S-7.01 gate.
# Do NOT add BCs to this story without PO sign-off.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs:
  - SD-002   # reference: JR_AUTH_HEADER gate pattern (the authoritative prior art for this gate)
sd_refs:
  - SD-002
parent_phase: F3-incremental-stories
spec_source: ".factory/maintenance/2026-06-19/spec-coherence.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 3
assumption_validations: []
risk_mitigations:
  - SEC-JR-SERVICE-NAME-GATE
created: "2026-06-19"
version: "1.0"
last_updated: "2026-06-19"
changelog:
  - "1.0 (2026-06-19): Initial draft — originated from 2026-06-19 maintenance sweep drift item SEC-JR-SERVICE-NAME-GATE (spec-coherence.md §3.2 row 5)."
breaking_change: false
lineage:
  - S-0.05  # gated JR_AUTH_HEADER (SD-002) — the pattern this story mirrors
drift_items:
  - SEC-JR-SERVICE-NAME-GATE
files_modified:
  - src/api/auth.rs            # MODIFY — gate service_name() / JR_SERVICE_NAME read behind #[cfg(debug_assertions)]
  - tests/jr_service_name_release_gate.rs  # CREATE — parallel to tests/base_url_release_gate.rs; verifies the gate fires in release builds
---

# S-MAINT-SEC-JR-SERVICE-NAME-GATE — Gate `JR_SERVICE_NAME` env var behind `#[cfg(debug_assertions)]`

**Origin:** 2026-06-19 maintenance sweep, drift item SEC-JR-SERVICE-NAME-GATE (`spec-coherence.md` §3.2 row 5).
**Status at sweep:** OPEN (LOW severity — "gate-all-seams" policy violation).

## Source of Truth

Spec coherence report: `.factory/maintenance/2026-06-19/spec-coherence.md` §3.2 row 5 (SEC-JR-SERVICE-NAME-GATE)
Prior art for the gate pattern: CLAUDE.md Gotchas §"`JR_BASE_URL` env var" and `tests/base_url_release_gate.rs`; SD-002 (S-0.05).

## Problem Statement

`src/api/auth.rs::service_name()` reads the `JR_SERVICE_NAME` environment variable in all
builds, including release binaries. This violates the established `gate-all-seams` policy
that governs all debug-only test seam env vars in `jr`:

| Variable | Gate | Regression test |
|----------|------|----------------|
| `JR_BASE_URL` | `#[cfg(debug_assertions)]` | `tests/base_url_release_gate.rs` |
| `JR_AUTH_HEADER` | `#[cfg(debug_assertions)]` | (covered by SD-002 audit) |
| `JR_CONFIG_DIR` | `#[cfg(debug_assertions)]` | `tests/config_dir_release_gate.rs` |
| `JR_CACHE_DIR` | `#[cfg(debug_assertions)]` | `tests/config_dir_release_gate.rs` |
| `JR_SERVICE_NAME` | **UNGATED** (releases also read it) | **MISSING** |

The security impact of `JR_SERVICE_NAME` being ungated is LOW (it controls the keychain
service name, not credentials). However, violating the gate-all-seams policy creates a
precedent for other seams to leak into release builds, and the inconsistency makes audit
harder. The fix is mechanical: mirror the `JR_BASE_URL` gate pattern exactly.

## Behavioral Contracts

No user-visible behavioral contracts change. Release binaries currently may read
`JR_SERVICE_NAME` but this variable is documented nowhere (not in CLAUDE.md); no user
should be relying on it. After the gate is applied, release builds behave as if the variable
is not set (same as the existing `JR_BASE_URL` and `JR_AUTH_HEADER` behavior).

Debug builds retain the behavior unchanged.

A formal BC for env-var gate policy consistency may be authored; until then this story
carries `status: draft` per the Spec-First Gate (S-7.01).

This story traces its ACs to drift item SEC-JR-SERVICE-NAME-GATE and SD-002.

## Story Narrative

As a security-conscious user of `jr`,
I want the `JR_SERVICE_NAME` debug seam to be gated behind `#[cfg(debug_assertions)]`
just like `JR_BASE_URL` and `JR_AUTH_HEADER`,
so that release binaries cannot be redirected to an alternate keychain service name via
an environment variable, and the gate-all-seams policy is uniformly enforced.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,000 |
| `src/api/auth.rs` `service_name()` function body (~30 LOC) | ~400 |
| `tests/base_url_release_gate.rs` (full, ~50 LOC — the template) | ~650 |
| `tests/config_dir_release_gate.rs` (full, ~50 LOC — secondary template) | ~650 |
| CLAUDE.md Gotchas §"JR_BASE_URL" and §"JR_AUTH_HEADER" (context) | ~400 |
| `cargo test` output for verification | ~500 |
| **Total** | **~5,600** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**S-0.05** (PR #293 / d907504) gated `JR_AUTH_HEADER` behind `#[cfg(debug_assertions)]`
(canonizing from `#[cfg(test)]`). It established the two-site rule: the env-var read AND
its consumers must both be gated. It also established the CLAUDE.md documentation requirement
for each gated seam.

**`tests/base_url_release_gate.rs`** is the authoritative template for the release-gate
regression test. Read it in full before writing the new `tests/jr_service_name_release_gate.rs`.
The test compiles the release binary (`cargo build --release`) and verifies that setting
`JR_SERVICE_NAME` does not affect the binary's behavior.

**The `JR_SERVICE_NAME` seam** is used in `src/api/auth.rs::service_name()` to allow tests
to override the keychain service name (e.g., to isolate different test runs). It should NOT
be active in release builds.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Gate placement | SD-002 / `JR_BASE_URL` pattern | The env-var read in `service_name()` MUST be wrapped in `#[cfg(debug_assertions)]` at BOTH the read site and any branching logic that selects between the env-var value and the default. The release path MUST always return the hard-coded default service name. |
| Two-site gate verification | CLAUDE.md Gotchas §"JR_BASE_URL" | "The override is gated via `#[cfg(debug_assertions)]` at BOTH read sites." Audit `src/api/auth.rs` for all calls to `service_name()` or direct reads of `JR_SERVICE_NAME`; gate each site. |
| Regression test required | `tests/base_url_release_gate.rs` pattern | A new `tests/jr_service_name_release_gate.rs` must verify that the gate fires (i.e., setting `JR_SERVICE_NAME` in the environment of a release build has no observable effect). |
| CLAUDE.md doc-fallout | CLAUDE.md AI Agent Notes / Gotchas | Add a `JR_SERVICE_NAME` bullet to the AI Agent Notes section documenting: the seam, the gate, and the regression test. Follow the exact format of the `JR_BASE_URL` bullet. |
| `cargo clippy -D warnings` must pass | CLAUDE.md zero-warnings policy | After every edit, `cargo clippy -- -D warnings` must exit 0. |

## Library and Framework Requirements

No new library or framework dependencies.

| Item | Version / Constraint |
|------|---------------------|
| `std::env::var` | Standard library — existing usage |
| `#[cfg(debug_assertions)]` | Rust attribute — existing pattern |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/api/auth.rs` | MODIFY | Gate `JR_SERVICE_NAME` env-var read in `service_name()` behind `#[cfg(debug_assertions)]`. |
| `tests/jr_service_name_release_gate.rs` | CREATE | Regression test verifying the gate fires in release builds (parallel to `tests/base_url_release_gate.rs`). |
| `CLAUDE.md` | MODIFY | Add `JR_SERVICE_NAME` bullet to AI Agent Notes (debug-only seam) adjacent to `JR_BASE_URL`. |

**Files NOT to touch:** `src/adf.rs`, `src/cli/`, `src/config.rs`, existing test files.

## Acceptance Criteria

### AC-001 (SEC-JR-SERVICE-NAME-GATE / SD-002) — `service_name()` reads `JR_SERVICE_NAME` only in debug builds

In `src/api/auth.rs`, the `JR_SERVICE_NAME` env-var read is wrapped in `#[cfg(debug_assertions)]`.
Release builds always use the hard-coded default service name regardless of the environment variable.

**Verifiable by:**
```bash
grep -n 'JR_SERVICE_NAME\|service_name' src/api/auth.rs
# Expected: JR_SERVICE_NAME is read inside a #[cfg(debug_assertions)] block only
```

(traces to drift item SEC-JR-SERVICE-NAME-GATE — ungated env var in release builds)

---

### AC-002 (SEC-JR-SERVICE-NAME-GATE) — Release-gate regression test passes

`tests/jr_service_name_release_gate.rs` contains at least one test that verifies:
setting `JR_SERVICE_NAME=custom_service` in the environment of a release build has
no observable effect (the release binary uses the default service name).

The test follows the same structure as `tests/base_url_release_gate.rs`:
it compiles a release binary (or uses `#[cfg(not(debug_assertions))]` to verify the
env-var read is compiled out) and asserts the gate is active.

**Verifiable by:**
```bash
cargo test --test jr_service_name_release_gate
# Expected: exit 0 (test passes)
```

(traces to SEC-JR-SERVICE-NAME-GATE — parallel regression test required per gate-all-seams policy)

---

### AC-003 (SEC-JR-SERVICE-NAME-GATE) — CLAUDE.md documents the gated seam

`CLAUDE.md` AI Agent Notes section contains a `JR_SERVICE_NAME` bullet documenting:
the seam's purpose (override keychain service name in debug builds), the gate
(`#[cfg(debug_assertions)]`), and the regression test (`tests/jr_service_name_release_gate.rs`).

**Verifiable by:**
```bash
grep 'JR_SERVICE_NAME' CLAUDE.md
# Expected: at least 1 match in AI Agent Notes
```

(traces to CLAUDE.md AI Agent Notes pattern — all debug-only env-var seams must be documented)

---

## Tasks

### Item 1: Locate `service_name()` in `src/api/auth.rs`

- [ ] `grep -n 'fn service_name\|JR_SERVICE_NAME' src/api/auth.rs` — note line numbers
- [ ] Read the `service_name()` function body
- [ ] Confirm: the env-var read is NOT currently gated

### Item 2: Apply the `#[cfg(debug_assertions)]` gate

Mirror the `JR_BASE_URL` pattern exactly. The typical form is:

```rust
fn service_name() -> String {
    #[cfg(debug_assertions)]
    if let Ok(name) = std::env::var("JR_SERVICE_NAME") {
        return name;
    }
    "jr".to_string()  // or whatever the hard-coded default is
}
```

- [ ] Apply the gate
- [ ] Run `cargo build` (debug) — must pass
- [ ] Run `cargo build --release` — must pass
- [ ] Run `cargo test --lib` — must pass (debug build; seam is active in tests)

### Item 3: Create `tests/jr_service_name_release_gate.rs`

- [ ] Read `tests/base_url_release_gate.rs` in full (template)
- [ ] Author the parallel test file using the same structure: verify `JR_SERVICE_NAME` has no effect in release builds
- [ ] Run `cargo test --test jr_service_name_release_gate` — must pass

### Item 4: CLAUDE.md doc-fallout (required)

- [ ] Read CLAUDE.md AI Agent Notes section for `JR_BASE_URL` (the template)
- [ ] Add `JR_SERVICE_NAME` bullet adjacent to `JR_BASE_URL` bullet with the same format

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- **Any change to the default service name.** The hard-coded default is unchanged.
- **Changes to other `JR_*` seams.** Only `JR_SERVICE_NAME` is in scope.
- **Adding new BCs.** The gate is a policy-consistency fix, not a new domain behavior.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `src/api/auth.rs::service_name` | `api` | Pure (returns string) | Add `#[cfg(debug_assertions)]` gate to JR_SERVICE_NAME read |
| `tests/jr_service_name_release_gate.rs` | `tests/` | Pure (compile-time or binary probe) | Release-gate regression test |
| `CLAUDE.md` | root | N/A (documentation) | Document the gated seam |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | SEC-JR-SERVICE-NAME-GATE | `JR_SERVICE_NAME` is set in a developer's shell environment | After the gate: debug builds honor it; release builds ignore it. This is the desired behavior — mirrors `JR_BASE_URL` and `JR_AUTH_HEADER` behavior. |
| EC-002 | S-0.05 precedent | `service_name()` is called from multiple sites; one is not gated | Read all callers of `service_name()` in `src/api/auth.rs`. The gate belongs inside `service_name()` itself, not at each call site. Gating the function body at the entry point ensures all callers are covered. |

## Dependency Analysis

**depends_on: []** — No story dependencies. Standalone security gate fix.

**blocks: []** — No story depends on this within the current story graph.

This is a LEAF story in the dependency graph.

---

## Story Points and Effort

**2 story points** (small). Breakdown:
- Locate and read `service_name()`: 0.25 SP
- Apply `#[cfg(debug_assertions)]` gate: 0.25 SP
- Create release-gate regression test: 0.75 SP
- CLAUDE.md doc-fallout: 0.25 SP
- Integration checks: 0.5 SP

Risk: LOW. The fix is mechanical (mirrors an established pattern). The regression test
is the only non-trivial part.
