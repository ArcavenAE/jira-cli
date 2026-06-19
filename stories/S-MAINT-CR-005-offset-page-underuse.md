---
document_type: story
story_id: "S-MAINT-CR-005"
title: "Refactor remaining manual offset-pagination loops to use OffsetPage<T>::items()"
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
estimated_days: 1.0
target_module: api
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: pending PO authorship
# No product BCs are added or modified by this story. This is a pure code-quality refactor.
# All observable behaviour remains identical: the same data is returned through the
# pagination abstraction already present. No postcondition, precondition, or invariant
# of any domain entity changes.
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
  - "1.0 (2026-06-19): Initial draft — originated from 2026-06-19 maintenance sweep finding CR-005 (OPEN carry-forward from 2026-06-17)."
breaking_change: false
lineage: []
drift_items:
  - DRIFT-331-PAGINATION
files_modified:
  - src/api/jira/boards.rs       # MODIFY — replace .values.unwrap_or_default() with page.items()
  - src/api/jira/issues.rs       # MODIFY — replace .changelog / list_comments inline field access with page.items()
  - src/api/jira/sprints.rs      # MODIFY — replace two inline field-access patterns with page.items()
  - src/api/jira/projects.rs     # MODIFY — replace inline field-access pattern with page.items()
---

# S-MAINT-CR-005 — Refactor remaining manual offset-pagination loops to use `OffsetPage<T>::items()`

**Origin:** 2026-06-19 maintenance sweep, finding CR-005 (`pattern-consistency.md` §2, carry-forward from 2026-06-17 §CR-005).
**Status at sweep:** OPEN (LOW severity). No correctness defect — style/consistency gap.

## Source of Truth

Maintenance sweep report: `.factory/maintenance/2026-06-19/pattern-consistency.md` §2 (Fix Verification Table, CR-005 row)
Drift item: DRIFT-331-PAGINATION (`spec-coherence.md` §3.2 row 9)

## Behavioral Contracts

No product BCs are added or modified by this story. This is a pure code-quality refactor —
each loop already calls `OffsetPage<T>` internally; the only change is replacing the ad-hoc
field accessor (`.values.unwrap_or_default()`, `.issues.unwrap_or_default()`, etc.) with the
canonical `OffsetPage<T>::items()` accessor.

Observable behavior is identical. No postcondition, precondition, or invariant of any domain
entity changes. `cargo test` must stay green at every commit.

This story traces its ACs to the drift item DRIFT-331-PAGINATION and finding CR-005.

## Story Narrative

As a contributor to `jr`,
I want all offset-pagination loops that use `OffsetPage<T>` to call `page.items()` instead
of accessing the inner field directly,
so that there is a single, consistent abstraction usage throughout the codebase and future
changes to the `OffsetPage` struct require only one callsite to update.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,000 |
| `src/api/jira/boards.rs` (full, ~200 LOC) | ~2,600 |
| `src/api/jira/issues.rs` (relevant pagination sections, ~100 LOC) | ~1,300 |
| `src/api/jira/sprints.rs` (full, ~150 LOC) | ~2,000 |
| `src/api/jira/projects.rs` (relevant section, ~80 LOC) | ~1,000 |
| `src/api/pagination.rs` (OffsetPage definition, ~50 LOC) | ~650 |
| `cargo test` output for verification | ~500 |
| **Total** | **~11,050** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

N/A — first story in this maintenance-sweep bundle. No prior story covers this refactor.

The `OffsetPage<T>` abstraction was introduced early in the codebase. The inconsistency
between call sites using `.items()` and those using direct field access has existed since
the abstraction was added; CR-005 was first identified in the 2026-06-17 sweep and remained
open as a low-priority cleanup.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Use `OffsetPage<T>::items()` | CR-005 finding / `src/api/pagination.rs` | All pagination loops that receive an `OffsetPage<T>` MUST call `.items()`, never `.values.unwrap_or_default()` or field-specific accessors (`.issues`, `.values`, etc.). The `items()` method is the canonical public API for this type. |
| Pure refactor — no behavioral change | CR-005 finding | The refactored code MUST produce the same API responses as before. Swap the accessor; do not alter loop logic, pagination advance, or error handling. |
| `cargo clippy -D warnings` must pass | CLAUDE.md zero-warnings policy | After every edit, `cargo clippy -- -D warnings` must exit 0. |
| No new `#[allow]` suppressions | CLAUDE.md lint-suppression policy | If clippy warns, refactor to fix the root cause — do not add `#[allow]`. |

## Library and Framework Requirements

No new library or framework dependencies. Uses only existing crate-internal types.

| Item | Version / Constraint |
|------|---------------------|
| `OffsetPage<T>` | `src/api/pagination.rs` — existing type, no version change |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/api/jira/boards.rs` | MODIFY | Replace `.values.unwrap_or_default()` (or equivalent field access) in the offset-pagination loop with `page.items()`. |
| `src/api/jira/issues.rs` | MODIFY | Replace inline field accesses in `get_changelog` and `list_comments` pagination loops with `page.items()`. |
| `src/api/jira/sprints.rs` | MODIFY | Replace inline field accesses in the two identified pagination sites with `page.items()`. |
| `src/api/jira/projects.rs` | MODIFY | Replace inline field access in the identified pagination site with `page.items()`. |

**Files NOT to create:** No new files. No new BC documents. No CLAUDE.md changes.

**Files NOT to touch:** `src/api/pagination.rs` (no changes to the OffsetPage definition itself), all test files (pure refactor; no test changes needed unless an existing assertion tests the concrete field), `CLAUDE.md`, `.factory/specs/`.

## Acceptance Criteria

### AC-001 (CR-005) — All identified sites use `page.items()`

Each of the five identified call sites in `boards.rs`, `issues.rs` (2 sites), `sprints.rs`
(2 sites), and `projects.rs` uses `page.items()` rather than a direct field accessor.

**Verifiable by:**
```bash
# No direct field accesses remaining in pagination loops in these files
grep -n '\.values\.unwrap_or_default\(\)\|\.issues\.unwrap_or_default\(\)' \
  src/api/jira/boards.rs src/api/jira/issues.rs src/api/jira/sprints.rs src/api/jira/projects.rs
# Expected: 0 matches
```

(traces to CR-005 — `OffsetPage::items()` underuse in 5 of 6 pagination loops)

---

### AC-002 (CR-005) — `cargo test` green after each file change

`cargo test` passes without regression after each individual file change. The refactor
touches only how the collected items are extracted; no pagination logic, no page-advance
logic, and no error handling is modified.

**Verifiable by:**
```bash
cargo test
# Expected: all tests pass (exit 0)
```

(traces to CR-005 — pure refactor must not alter observable behaviour)

---

### AC-003 (CR-005) — `cargo clippy -D warnings` exits 0

After all changes, `cargo clippy -- -D warnings` exits 0 with zero new warnings.

**Verifiable by:**
```bash
cargo clippy -- -D warnings
# Expected: exit 0, no new warnings
```

(traces to CLAUDE.md zero-warnings policy)

---

## Tasks

### Item 1: Read `src/api/pagination.rs` — confirm `items()` API

- [ ] Read `src/api/pagination.rs` in full
- [ ] Confirm the `OffsetPage<T>` struct definition and the `items()` method signature

### Item 2: Refactor `src/api/jira/boards.rs`

- [ ] Read `src/api/jira/boards.rs` in full
- [ ] Locate the offset-pagination loop using `.values.unwrap_or_default()` or equivalent
- [ ] Replace with `page.items()`
- [ ] Run `cargo test --lib` — must pass

### Item 3: Refactor `src/api/jira/issues.rs`

- [ ] Read the `get_changelog` and `list_comments` functions in `src/api/jira/issues.rs`
- [ ] Locate the two inline field-access patterns
- [ ] Replace both with `page.items()`
- [ ] Run `cargo test --lib` — must pass

### Item 4: Refactor `src/api/jira/sprints.rs`

- [ ] Read `src/api/jira/sprints.rs` in full
- [ ] Locate the two identified pagination sites
- [ ] Replace both with `page.items()`
- [ ] Run `cargo test --lib` — must pass

### Item 5: Refactor `src/api/jira/projects.rs`

- [ ] Read `src/api/jira/projects.rs` in full
- [ ] Locate the identified pagination site
- [ ] Replace with `page.items()`
- [ ] Run `cargo test --lib` — must pass

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0 (full suite)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0 (no BC files touched)
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- **`get_issue_types_for_project` (DRIFT-331-PAGINATION):** That function has a justified
  inline reimplementation due to a divergent Jira API schema; its deviation is documented
  as accepted. Do NOT touch it in this story.
- **`src/api/pagination.rs` changes:** The `OffsetPage<T>` type itself is not changing.
- **New BCs, new VPs, new NFRs, new ADRs.** Refactor only.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `src/api/jira/boards.rs` | `api/jira` | Effectful (HTTP) | Replace direct field access with `items()` accessor |
| `src/api/jira/issues.rs` | `api/jira` | Effectful (HTTP) | Two pagination sites (`get_changelog`, `list_comments`) |
| `src/api/jira/sprints.rs` | `api/jira` | Effectful (HTTP) | Two pagination sites |
| `src/api/jira/projects.rs` | `api/jira` | Effectful (HTTP) | One pagination site |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | CR-005 | A pagination loop has a bespoke field name not matched by `items()` (e.g., a type-specific wrapper) | Read `pagination.rs` first and confirm `items()` exists for all target types. If a site's `OffsetPage<T>` variant does not expose `items()`, do NOT force-fit — note the exception and escalate. |
| EC-002 | CR-005 | Replacement breaks a snapshot test that asserts concrete field structure | Update the snapshot to reflect the refactored output, confirming the data is identical. |

## Dependency Analysis

**depends_on: []** — No story dependencies. Standalone code-quality refactor.

**blocks: []** — No story depends on this within the current story graph.

This is a LEAF story in the dependency graph.

---

## Story Points and Effort

**3 story points** (small). Breakdown:
- Read `pagination.rs` + confirm API: 0.25 SP
- 5 file edits (one per affected file): 0.5 SP each = 2.5 SP
- Integration checks: 0.25 SP

Risk: LOW. Each change is a mechanical accessor substitution with no logic change.
