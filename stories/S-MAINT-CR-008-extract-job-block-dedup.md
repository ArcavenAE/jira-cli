---
document_type: story
story_id: "S-MAINT-CR-008"
title: "Consolidate copy-pasted extract_job_block helper from 3 CI test files into tests/common/"
wave: feature-followup
status: draft
intent: refactor
feature_type: code-quality
mode: feature
scope: small
severity: LOW
trivial_scope: false
points: 3
priority: P3
tdd_mode: strict
estimated_effort: small
estimated_days: 0.75
target_module: tests
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: pending PO authorship
# No product BCs are added or modified by this story. This is a pure test-infrastructure
# refactor. No src/ code changes, no observable runtime behavior changes.
# Do NOT add BCs to this story.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/maintenance/2026-06-19/pattern-consistency.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 3
assumption_validations: []
risk_mitigations: []
created: "2026-06-19"
version: "1.0"
last_updated: "2026-06-19"
changelog:
  - "1.0 (2026-06-19): Initial draft — originated from 2026-06-19 maintenance sweep finding CR-008 (new finding this pass)."
breaking_change: false
lineage:
  - S-FORK-OPS-BACKFILL-1  # introduced the third copy of extract_job_block in backfill_matrix_parity.rs (commit 2756050)
drift_items: []
files_modified:
  - tests/common/mod.rs                  # MODIFY — add pub fn extract_job_block + pub fn ci_helpers mod (or add directly to mod.rs)
  - tests/ci_yml_windows_matrix.rs       # MODIFY — remove local extract_job_block; call common::extract_job_block
  - tests/ci_gate_completeness.rs        # MODIFY — remove local extract_job_block; call common::extract_job_block
  - tests/backfill_matrix_parity.rs      # MODIFY — remove local extract_job_block; call common::extract_job_block
---

# S-MAINT-CR-008 — Consolidate `extract_job_block` from 3 CI test files into `tests/common/`

**Origin:** 2026-06-19 maintenance sweep, finding CR-008 (`pattern-consistency.md` §4, "Part B — New Findings").
**Status at sweep:** OPEN (LOW severity). No correctness defect today — future maintenance hazard.

## Source of Truth

Maintenance sweep report: `.factory/maintenance/2026-06-19/pattern-consistency.md` §4 (CR-008)

## Behavioral Contracts

No product BCs are added or modified by this story. This is a pure test-infrastructure
refactor. The canonical implementation (see Architecture Compliance Rules below) produces
identical output to the two existing correct implementations; the `backfill_matrix_parity.rs`
variant's minor algorithmic difference is resolved by adopting the canonical form.

This story traces its ACs to finding CR-008.

## Story Narrative

As a contributor to `jr`,
I want `extract_job_block` defined exactly once in `tests/common/` and imported by the
three CI test files that use it,
so that a bug discovered in one copy automatically fixes all consumers, and future CI
test files inherit the shared helper without creating a fourth copy.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,000 |
| `tests/common/mod.rs` (current, ~50 LOC) | ~650 |
| `tests/ci_yml_windows_matrix.rs` (full, ~250 LOC) | ~3,250 |
| `tests/ci_gate_completeness.rs` (full, ~250 LOC) | ~3,250 |
| `tests/backfill_matrix_parity.rs` (full, ~300 LOC) | ~3,900 |
| Maintenance sweep CR-008 §4 (finding detail) | ~600 |
| `cargo test` output for verification | ~500 |
| **Total** | **~15,150** |

Within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**S-FORK-OPS-BACKFILL-1** introduced `tests/backfill_matrix_parity.rs` (commit 2756050 /
PR #539), which added the third copy of `extract_job_block`. That copy has a minor divergence
in its inner loop exit path (adds a `find("\n  ")` inner fallback absent from the other two).

The `tests/common/` directory already exists with `fixtures.rs`, `mock_server.rs`, and `mod.rs`.
The natural pattern for adding a new shared helper is to add it to `tests/common/mod.rs`
(or a new submodule `tests/common/ci_helpers.rs` with a re-export from `mod.rs`).

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Single canonical implementation | CR-008 finding | `extract_job_block` MUST exist exactly once in `tests/common/`. Delete all three local copies after the shared helper is in place. |
| Canonical body to use | CR-008 finding | Use the body from `tests/ci_yml_windows_matrix.rs` or `tests/ci_gate_completeness.rs` as the canonical form (those two are semantically identical). The `backfill_matrix_parity.rs` variant's inner `find("\n  ")` fallback MUST NOT be carried to the canonical; verify the canonical body passes the backfill tests. |
| Visibility | Rust module conventions | Mark the function `pub fn extract_job_block` in `tests/common/mod.rs`. Callers use `mod common; common::extract_job_block(…)`. |
| No behavioral change to tests | CR-008 finding | Every CI test that previously passed MUST still pass after the refactor. `cargo test --test ci_yml_windows_matrix --test ci_gate_completeness --test backfill_matrix_parity` must exit 0. |
| `cargo clippy -D warnings` must pass | CLAUDE.md zero-warnings policy | After every edit, `cargo clippy -- -D warnings` must exit 0. |

## Library and Framework Requirements

No new library or framework dependencies. Uses only the Rust standard library string
methods already in use (`str::find`, `str::lines`, etc.).

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `tests/common/mod.rs` | MODIFY | Add `pub fn extract_job_block<'a>(yaml: &'a str, job_name: &str) -> Option<&'a str>` with the canonical body. |
| `tests/ci_yml_windows_matrix.rs` | MODIFY | Remove local `fn extract_job_block`; add `mod common; use common::extract_job_block;` (or equivalent import). |
| `tests/ci_gate_completeness.rs` | MODIFY | Remove local `fn extract_job_block`; add import from `common`. |
| `tests/backfill_matrix_parity.rs` | MODIFY | Remove local `fn extract_job_block`; add import from `common`. Verify the canonical body passes all existing backfill assertions (the `find("\n  ")` inner fallback removal must be validated). |

**Files NOT to create:** No new test files. No new src/ files. No BC documents. No CLAUDE.md
changes (unless a future CLAUDE.md mention of `tests/common/` helpers is warranted — not required here).

## Acceptance Criteria

### AC-001 (CR-008) — Exactly one `extract_job_block` definition exists in the test tree

After the refactor, `extract_job_block` is defined exactly once.

**Verifiable by:**
```bash
grep -rn 'fn extract_job_block' tests/
# Expected: exactly 1 match (in tests/common/mod.rs or tests/common/ci_helpers.rs)
```

(traces to CR-008 — `extract_job_block` copy-pasted across 3 CI test files with divergent implementations)

---

### AC-002 (CR-008) — All three CI test files pass after the refactor

`cargo test` for the three affected test files exits 0 with no regressions.

**Verifiable by:**
```bash
cargo test --test ci_yml_windows_matrix
cargo test --test ci_gate_completeness
cargo test --test backfill_matrix_parity
# Expected: all three exit 0
```

(traces to CR-008 — refactor must not alter test outcomes)

---

### AC-003 (CR-008) — `cargo clippy -D warnings` exits 0

After all changes, `cargo clippy -- -D warnings` exits 0 with zero new warnings.
In particular, no `dead_code` warning is emitted for `extract_job_block` in `tests/common/`
(the function must be used by at least one caller in each of the three test files).

**Verifiable by:**
```bash
cargo clippy --tests -- -D warnings
# Expected: exit 0, no new warnings
```

(traces to CLAUDE.md zero-warnings policy)

---

## Tasks

### Item 1: Read all three existing implementations

- [ ] Read `tests/ci_yml_windows_matrix.rs` — copy the `extract_job_block` body (canonical)
- [ ] Read `tests/ci_gate_completeness.rs` — confirm body is identical to the above
- [ ] Read `tests/backfill_matrix_parity.rs` — note the divergence in the inner loop exit path (`find("\n  ")` fallback); record what tests use this helper

### Item 2: Add canonical helper to `tests/common/mod.rs`

- [ ] Read `tests/common/mod.rs` in full
- [ ] Add `pub fn extract_job_block<'a>(yaml: &'a str, job_name: &str) -> Option<&'a str>` with the canonical body (from `ci_yml_windows_matrix.rs` / `ci_gate_completeness.rs`)
- [ ] Run `cargo test --test ci_yml_windows_matrix` — must still pass (smoke check before any caller changes)

### Item 3: Update callers

- [ ] `tests/ci_yml_windows_matrix.rs`: remove local definition; add `#[path = "common/mod.rs"] mod common;` or equivalent; update call sites to `common::extract_job_block(…)`
- [ ] `tests/ci_gate_completeness.rs`: same removal and import pattern
- [ ] `tests/backfill_matrix_parity.rs`: same removal; verify the canonical body (without `find("\n  ")` fallback) produces passing tests; if a test fails, determine whether the test's assertion or the canonical function body needs adjustment (the test's assertion is ground truth)

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0 (full suite)
- [ ] `cargo clippy --tests -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `grep -rn 'fn extract_job_block' tests/` → exactly 1 match
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- **Refactoring other shared helpers in CI test files.** This story is limited to
  `extract_job_block`. Other duplication (if any) is a separate cleanup.
- **Adding new CI test coverage.** The goal is consolidation, not expansion.
- **`src/` changes.** Test-only refactor.
- **New BCs, new VPs, new NFRs, new ADRs.**

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `tests/common/mod.rs::extract_job_block` | `tests/common` | Pure (string parsing) | Canonical shared implementation replaces three local copies |
| `tests/ci_yml_windows_matrix.rs` | `tests/` | Pure (reads YAML string) | Remove local copy; import from common |
| `tests/ci_gate_completeness.rs` | `tests/` | Pure (reads YAML string) | Remove local copy; import from common |
| `tests/backfill_matrix_parity.rs` | `tests/` | Pure (reads YAML string) | Remove local copy; import from common; verify canonical body |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | CR-008 §"Evidence" | The `backfill_matrix_parity.rs` inner loop exit divergence causes a test to fail when the canonical body is used | Read the failing test assertion, determine whether the canonical body or the test assertion is correct. Ground truth: the test assertion describes the expected YAML structure. If the canonical body is wrong for that assertion, the canonical body needs the divergent logic. Document the decision in a comment on the shared function. |
| EC-002 | CR-008 | Rust module resolution for `mod common;` in multiple test files conflicts | Use `#[path = "common/mod.rs"] mod common;` in each test file, following the established pattern in other test files that import `common`. |
| EC-003 | General | `dead_code` warning on `extract_job_block` in `tests/common/mod.rs` | The function must be used by a public import in each of the three callers. If clippy still warns, add `#[allow(dead_code)]` ONLY with a comment explaining why (e.g., used via `mod common;` in multiple test binaries — Rust may not detect cross-binary usage in `--lib` lint pass). |

## Dependency Analysis

**depends_on: []** — No story dependencies. Standalone test-infrastructure refactor.

**blocks: []** — No story depends on this within the current story graph.

This is a LEAF story in the dependency graph.

---

## Story Points and Effort

**3 story points** (small). Breakdown:
- Read three existing implementations + diff: 0.5 SP
- Add canonical helper to `tests/common/mod.rs`: 0.5 SP
- Update three callers + verify: 1.5 SP
- Integration checks: 0.5 SP

Risk: LOW (test-only refactor; no production code changes).
The only non-trivial risk is EC-001 (the `backfill_matrix_parity.rs` divergence).
