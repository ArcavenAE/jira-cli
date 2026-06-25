---
document_type: story
story_id: "S-MAINT-SEC-001"
title: "Add depth cap / convert to iterative: CWE-674 uncontrolled recursion in src/adf.rs normalize_*/assign_local_ids/render_node"
wave: feature-followup
status: done
intent: bug-fix
feature_type: security
mode: feature
scope: medium
severity: LOW
trivial_scope: false
points: 5
priority: P2
tdd_mode: strict
estimated_effort: medium
estimated_days: 2.0
target_module: adf
subsystems: []
depends_on: []
blocks: []
bc_anchors: ["BC-7.2.012"]
bcs: ["BC-7.2.012"]
# BC-7.2.012 was authored by the PO and shipped in PR #553 (merged to develop @ 35e20c9).
# S-7.01 gate satisfied. Story status promoted to done.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/maintenance/2026-06-19/pattern-consistency.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations:
  - SEC-001
created: "2026-06-19"
version: "1.1"
last_updated: "2026-06-25"
changelog:
  - "1.0 (2026-06-19): Initial draft — originated from 2026-06-19 maintenance sweep SEC-001 / CWE-674 (drift item; spec-coherence.md §3.2 row 11)."
  - "1.1 (2026-06-25): Promoted to done — BC-7.2.012 authored by PO and shipped in PR #553 (merged to develop @ 35e20c9). Corrected constant name ADF_MAX_DEPTH → MAX_ADF_DEPTH and value 64 → 256 to match shipped reality (threshold revised during implementation/dual review per DEC-132)."
breaking_change: false
lineage:
  - S-492   # adf.rs block-HTML hardBreak fix — established normalize_panel_content and is_empty_block_container patterns
  - S-483   # GFM alerts → ADF panel — introduced normalize_panel_content recursion
  - S-471   # GFM task lists — introduced normalize_list_item_content recursion
drift_items:
  - SEC-001
files_modified:
  - src/adf.rs          # MODIFY — add depth cap to normalize_panel_content, normalize_list_item_content,
                        # assign_local_ids_walk, render_node, autolink_bare_urls; convert hot recursive
                        # paths to iterative where practical
  - tests/adf_depth.rs  # CREATE — regression test: deeply nested input does not stack-overflow; depth
                        # cap returns graceful error or truncated output; existing tests unaffected
---

# S-MAINT-SEC-001 — Add depth cap to CWE-674 recursive functions in `src/adf.rs`

**Origin:** 2026-06-19 maintenance sweep, drift item SEC-001 / CWE-674 (`pattern-consistency.md` §5 "Carry-Forward Drift Items"; `spec-coherence.md` §3.2 row 11).
**Status at sweep:** OPEN (LOW severity — risk constrained by input trust model). **Resolved:** shipped in PR #553 (merged to develop @ 35e20c9).
**Security classification:** CWE-674 (Uncontrolled Recursion).

## Source of Truth

Maintenance sweep report: `.factory/maintenance/2026-06-19/pattern-consistency.md` §5 (SEC-001 / CWE-674 detail)
Spec coherence report: `.factory/maintenance/2026-06-19/spec-coherence.md` §3.2 row 11

## Problem Statement

`src/adf.rs` contains at least five functions that recurse through ADF node trees without a
depth guard:

| Function | Recursion path | Worst-case risk |
|----------|---------------|----------------|
| `normalize_panel_content` | Recurses via panel/blockquote `content` | Introduced by S-483 (#483 GFM alerts) |
| `normalize_list_item_content` | Recurses via list item children | Introduced by S-471 (task lists) |
| `assign_local_ids_walk` | DFS over all `content` arrays | Introduced by S-471 |
| `render_node` (in `adf_to_text`) | Recurses via `content` and block children | Pre-existing |
| `autolink_bare_urls` | Recurses via `_ =>` catch-all `content` arm | Introduced by S-473 |

**Risk model:** ADF input originates from the Jira REST API (trusted in the canonical use case).
An attacker would need to control the Jira instance's API response to deliver a deeply nested
ADF tree — possible only if the user is connected to a malicious Jira instance. The sweep
classifies this as LOW practical risk given the trust model, but the class (CWE-674) is real
and should be guarded against as a defense-in-depth measure.

**Contrast with guarded code:** `yaml_contains_secrets` in
`scripts/check-signing-workflow-injection.sh` guards `depth > 20`. ADF has no analogous guard.

## Behavioral Contracts

No user-visible behavioral contracts change in the happy path. The depth cap fires only when
ADF nesting exceeds a threshold (`MAX_ADF_DEPTH = 256` — see implementation note below). When
the cap fires, the function MUST return a graceful result (truncated output or an error, not a
stack overflow) — this is the only new behavioral postcondition introduced by this story.

**BC-7.2.012** (SEC-001 / CWE-674 ADF recursion-depth guard) was formally authored by the PO
and shipped in PR #553 (merged to develop @ 35e20c9). The S-7.01 gate is satisfied.

This story traces its ACs to drift item SEC-001.

## Story Narrative

As a user of `jr` who may be connected to an untrusted Jira instance,
I want `jr` to handle deeply nested ADF structures without crashing with a stack overflow,
so that a malformed or adversarially crafted Jira API response cannot cause the `jr` process
to crash on read commands such as `jr issue view` or `jr issue comments`.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~4,000 |
| `src/adf.rs` (full, ~10,531 LOC) | ~136,000 — too large; load only the 5 affected functions (estimated ~500 LOC total) | ~6,500 |
| `tests/adf_depth.rs` (new file, author from scratch) | ~2,000 |
| Maintenance sweep SEC-001 §5 detail | ~600 |
| `cargo test` output for verification | ~500 |
| **Total (without full adf.rs)** | **~13,600** |

CAUTION: `src/adf.rs` is 10,531 LOC. Load ONLY the specific function bodies, not the whole
file. Use grep to locate function boundaries before reading. Do not load the full file.

## Previous Story Intelligence

**S-483** (PR #487, 2026-06-09) introduced `normalize_panel_content`, which recurses through
`panel`/`blockquote` nodes without a depth counter. This was noted as acceptable at the time
because pulldown-cmark's parse depth imposes an implicit bound.

**S-471** (2026-06-10) introduced `normalize_list_item_content` and `assign_local_ids_walk`,
both recursive over ADF tree content arrays.

**S-473** (bare-URL autolinking, 2026-06-11) introduced `autolink_bare_urls` with a `_ =>`
catch-all arm that recurses into `content`.

**The existing `is_empty_block_container` function** in `src/adf.rs` is also recursive — read
its implementation to understand the established tree-traversal pattern before writing new
iterative alternatives.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Depth cap value | SEC-001 finding | Shipped as compile-time constant `const MAX_ADF_DEPTH: usize = 256;` (original draft proposed 64; revised to 256 during dual review per DEC-132 — a threshold decision balancing defense-in-depth against realistic deep-nesting from Jira's own editor). Document the constant with a comment citing CWE-674 and the pulldown-cmark implicit bound. |
| Graceful behavior at cap | SEC-001 finding | At depth > `MAX_ADF_DEPTH`, return the shallowest safe result (e.g., skip further nesting, return `None` for the walk function, or return the current accumulated output for `render_node`). Do NOT panic. |
| Prefer iterative conversion for `render_node` | SEC-001 finding | `render_node` / `adf_to_text` is the highest-risk function (called on every `jr issue view`). Prefer converting it to an explicit stack rather than adding a depth counter. Other functions (normalize_*) may use a depth counter parameter. |
| No behavioral change in depth ≤ 256 | SEC-001 finding | All existing ADF unit tests (130+ in `adf::tests`) MUST continue to pass. The depth cap MUST NOT affect any real-world or synthetic test input that fits within the cap. |
| `cargo clippy -D warnings` must pass | CLAUDE.md zero-warnings policy | After every edit, `cargo clippy -- -D warnings` must exit 0. |
| No new `#[allow]` without justification | CLAUDE.md lint-suppression policy | `src/adf.rs` already carries one justified `#[allow(clippy::too_many_lines)]` at the `finish()` function. Do NOT add new suppressions without a justification comment. |

## Library and Framework Requirements

No new library or framework dependencies. Uses only the Rust standard library.

| Item | Version / Constraint |
|------|---------------------|
| `std::collections::VecDeque` or `Vec` | Standard library — for explicit stack in iterative `render_node` |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `src/adf.rs` | MODIFY | Added `const MAX_ADF_DEPTH: usize = 256;` (original draft proposed 64; revised to 256 during implementation/dual review per DEC-132). Added depth counter parameter to `normalize_panel_content`, `normalize_list_item_content`. Converted `assign_local_ids_walk` and `autolink_bare_urls` to use depth counter or iterative form. Converted `render_node` to iterative stack. |
| `tests/adf_depth.rs` | CREATE | New test file: (1) a deeply nested JSON ADF structure (depth > 64 levels) passed to `adf_to_text` does not panic; (2) a moderately nested structure (depth ≤ 32) produces correct output; (3) `assign_local_ids` on a deep tree does not panic. |

**Files NOT to touch:** `src/api/`, `src/cli/`, `tests/` (existing tests), CLAUDE.md (unless a gotcha note is warranted), `.factory/specs/`.

## Acceptance Criteria

### AC-001 (SEC-001 / CWE-674) — `adf_to_text` on a 100-level-deep ADF tree does not stack-overflow

A synthetically constructed ADF JSON value with 100 nested `panel` → `paragraph` → `panel`
cycles is passed to `adf_to_text`. The function returns (either truncated output or an error)
without panicking or causing a stack overflow.

**Verifiable by:**
```bash
cargo test --test adf_depth test_adf_to_text_deep_nesting_does_not_overflow
# Expected: test passes (process does not abort with SIGSEGV or thread-stack-overflow)
```

(traces to SEC-001 / CWE-674 — `render_node` uncontrolled recursion)

---

### AC-002 (SEC-001 / CWE-674) — `assign_local_ids` on a 100-level-deep ADF tree does not stack-overflow

A synthetically constructed ADF JSON value with 100 nested `taskList` → `taskItem` → `taskList`
cycles is passed through `markdown_to_adf` (which calls `assign_local_ids`). The function
returns without panicking.

**Verifiable by:**
```bash
cargo test --test adf_depth test_assign_local_ids_deep_nesting_does_not_overflow
# Expected: test passes
```

(traces to SEC-001 / CWE-674 — `assign_local_ids_walk` uncontrolled recursion)

---

### AC-003 (SEC-001 / CWE-674) — `normalize_panel_content` on a 100-level-deep ADF tree does not stack-overflow

A synthetically constructed deeply-nested panel ADF value processed by `markdown_to_adf`
does not cause a stack overflow.

**Verifiable by:**
```bash
cargo test --test adf_depth test_normalize_panel_content_deep_nesting_does_not_overflow
# Expected: test passes
```

(traces to SEC-001 / CWE-674 — `normalize_panel_content` uncontrolled recursion)

---

### AC-004 (SEC-001) — All existing `adf::tests` pass unmodified

The 130+ existing unit tests in `src/adf.rs::tests` (covering all real-world ADF nesting
depths, which are well below 64 levels) continue to pass without modification.

**Verifiable by:**
```bash
cargo test --lib adf
# Expected: all existing adf::tests pass (exit 0)
```

(traces to SEC-001 / CWE-674 — depth cap must not affect normal operation)

---

### AC-005 (SEC-001) — `MAX_ADF_DEPTH` constant is documented with CWE-674 reference

The constant `MAX_ADF_DEPTH` in `src/adf.rs` carries a doc comment citing CWE-674 and
explaining the rationale (defense-in-depth; value 256 chosen per DEC-132 dual review).

**Verifiable by:**
```bash
grep -A3 'MAX_ADF_DEPTH' src/adf.rs
# Expected: constant definition (= 256) followed by a comment referencing CWE-674
```

(traces to SEC-001 — engineering rationale must be documented for future maintainers)

---

## Tasks

### Item 1: Locate and read the five affected functions in `src/adf.rs`

- [ ] `grep -n 'fn normalize_panel_content\|fn normalize_list_item_content\|fn assign_local_ids_walk\|fn render_node\|fn autolink_bare_urls' src/adf.rs` — note line numbers
- [ ] Read each function body (use offset+limit on the Read tool, not the full file)
- [ ] Understand the recursion structure and natural base cases

### Item 2: Add `const MAX_ADF_DEPTH: usize = 256;`

- [x] Added constant near the top of `src/adf.rs` with a CWE-674 rustdoc comment (note: original proposal was 64; revised to 256 during implementation/dual review per DEC-132)
- [x] `cargo build` exits 0

### Item 3: Add depth counter to `normalize_panel_content` and `normalize_list_item_content`

- [ ] Add `depth: usize` parameter; public callers pass `0`; recursive calls pass `depth + 1`
- [ ] At `depth > MAX_ADF_DEPTH`, return the current node/Vec without further recursion
- [ ] Verify: `cargo test --lib adf` exits 0 (all existing tests pass)

### Item 4: Add depth counter or convert `assign_local_ids_walk` to iterative

- [ ] Prefer iterative (explicit stack using `Vec`) for a clean, non-recursive implementation
- [ ] Alternatively, add `depth: usize` parameter; at `depth > MAX_ADF_DEPTH`, skip subtree
- [ ] Verify: `cargo test --lib adf` exits 0

### Item 5: Convert `render_node` to iterative or add depth counter

- [ ] Read `render_node` body to understand recursive structure
- [ ] If converting to iterative: use `Vec<(AdfNode, indent_level)>` work stack
- [ ] If adding depth counter: add `depth: usize` parameter; at `depth > MAX_ADF_DEPTH`, emit `"[...]"` placeholder or empty string
- [ ] Verify: `cargo test --lib adf` exits 0

### Item 6: Add depth guard to `autolink_bare_urls`

- [ ] Add `depth: usize` parameter to the inner recursive helper; cap at `MAX_ADF_DEPTH`
- [ ] Verify: `cargo test --lib adf` exits 0

### Item 7: Create `tests/adf_depth.rs`

- [ ] Author the 3 tests specified in AC-001, AC-002, AC-003 using synthetic deeply-nested ADF JSON
- [ ] Verify: `cargo test --test adf_depth` exits 0

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0 (full suite, including all existing `adf::tests`)
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0 (no BC files touched)
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0

## Out of Scope

- **`is_empty_block_container`** — also recursive, but called only from within depth-bounded contexts.
  Add to scope of a follow-on story if the sweep flags it.
- **Converting all recursive functions to iterative in one story.** Prioritize `render_node` for
  iterative conversion (highest call-frequency); others may use depth counter for now.
- **Authoring BC-7.2.012.** Completed — BC-7.2.012 was authored by the PO and shipped in PR #553. S-7.01 gate cleared.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `src/adf.rs::normalize_panel_content` | `adf` | Pure (tree transformation) | Add depth counter parameter; cap at MAX_ADF_DEPTH |
| `src/adf.rs::normalize_list_item_content` | `adf` | Pure (tree transformation) | Add depth counter parameter; cap at MAX_ADF_DEPTH |
| `src/adf.rs::assign_local_ids_walk` | `adf` | Pure (tree mutation) | Convert to iterative or add depth counter |
| `src/adf.rs::render_node` | `adf` | Pure (rendering) | Prefer iterative conversion |
| `src/adf.rs::autolink_bare_urls` | `adf` | Pure (tree transformation) | Add depth counter |
| `tests/adf_depth.rs` | `tests/` | Pure (synthetic ADF JSON) | New regression test file for depth-cap behavior |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | SEC-001 | Deeply nested ADF comes from a real Jira instance (e.g., a comment with 50 levels of nested blockquotes) | Depth cap of 64 is well above any realistic nesting level. Real Jira instances do not produce ADF trees deeper than ~10 levels. The cap is a defense-in-depth guard, not a practical truncation. |
| EC-002 | SEC-001 | Depth counter threading requires changing private function signatures | Private functions can freely gain `depth: usize` parameters. Public-facing functions (`adf_to_text`, `markdown_to_adf`) must not change their signatures. The counter is passed down via internal recursive calls only. |
| EC-003 | SEC-001 | Iterative conversion of `render_node` changes output ordering | Validate that the iterative version produces byte-for-byte identical output to the recursive version on all existing test vectors. If not, the iterative version has a bug — fix it before merging. |

## Dependency Analysis

**depends_on: []** — No story dependencies. Standalone security hardening.

**blocks: []** — No story depends on this within the current story graph.

This is a LEAF story in the dependency graph.

---

## Story Points and Effort

**5 story points** (medium). Breakdown:
- Locate and read 5 affected functions: 0.5 SP
- Add constant: 0.25 SP
- Depth counter for `normalize_panel_content` + `normalize_list_item_content`: 1 SP
- Depth counter or iterative for `assign_local_ids_walk`: 0.75 SP
- Iterative conversion or depth counter for `render_node`: 1.5 SP
- Depth guard for `autolink_bare_urls`: 0.5 SP
- Create `tests/adf_depth.rs` with 3 tests: 1 SP
- Integration checks: 0.5 SP

Risk: MEDIUM (complex recursive → iterative transformation in a 10k-LOC file; mitigated
by the 130+ existing unit tests that must stay green).
