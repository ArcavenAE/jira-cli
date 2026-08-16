---
document_type: story
level: ops
epic_id: "none"
story_id: "S-606-1"
title: "issue list --component filter (bare/not:/none/all:)"
wave: null
status: draft
intent: feature
feature_type: backend
mode: feature
scope: standard
severity: N/A
trivial_scope: false
issue: 606
points: 8
priority: P0
tdd_mode: strict
estimated_effort: medium
producer: story-writer
timestamp: "2026-08-15T00:00:00"
phase: 2
cycle: cycle-component-mgmt
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-8-components.md"
  - ".factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-components.md"
traces_to: ".factory/specs/prd/bc-2-issue-read.md"
estimated_days: 3
target_module: src/cli/issue/list.rs
subsystems: ["SS-02", "SS-04"]
depends_on: ["S-604-1"]
blocks: []
behavioral_contracts:
  - "BC-2.1.018"
  - "BC-2.1.019"
  - "BC-2.1.020"
  - "BC-2.1.021"
  - "BC-2.1.022"
bcs:
  - "BC-2.1.018"
  - "BC-2.1.019"
  - "BC-2.1.020"
  - "BC-2.1.021"
  - "BC-2.1.022"
verification_properties: ["VP-COMPONENT-013", "VP-COMPONENT-015"]
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0018"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-2-issue-read.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 17
assumption_validations: []
risk_mitigations: []
created: "2026-08-15"
version: "1.0"
last_updated: "2026-08-15"
breaking_change: false
retroactive: false
origin: >
  GitHub issue #606 (`jr issue list --component` filter). Depends only on S-604-1's shared
  resolver — this is a READ-ONLY filter, no mutation risk, hence LOW criticality relative to
  the rest of the bundle. Parallelizable with S-605-1/S-605-2 (Wave 2) since it touches only
  `src/cli/issue/list.rs` and shares no files with the `edit`/`create` paths. Explicitly does
  NOT implement issue #607 (generalized multi-valued/negatable filter grammar retrofit) — the
  `--component` filter's `not:`/`none`/`all:` forms are pre-composed, component-specific
  clauses, not a reusable grammar.
files_modified:
  - src/cli/issue/list.rs
  - src/cli/mod.rs
test_files:
  - tests/issue_commands.rs
  - tests/common/fixtures.rs
input-hash: "2ec39cd"
---

> **tdd_mode:** `strict`.

# S-606-1: `jr issue list --component` filter

## Narrative

As a `jr` user filtering issues by component, I want `--component <NAME>` (repeatable,
OR-combined), `--component not:<NAME>` (exclude, EMPTY-inclusive), `--component none`
(zero-component issues), and `--component all:<N1>,<N2>` (AND-combined, "has every listed
component"), all correctly resolved and project-scoped, so that I can filter issues by
component the same way I already filter by status/assignee/team, without accidentally
spanning projects or silently excluding untagged issues.

## Source of Truth

Read **BC-2.1.018 through BC-2.1.022** in `bc-2-issue-read.md` §2.1 in full — five BCs, each
covering one distinct `--component` filter form and their composition rules (bare+`not:` MAY
coexist; `none`/`all:` reject combination with anything else). Also read **BC-2.1.006** (no
default scope) and **BC-2.1.007** (the exact clause-ordering table this story's clauses slot
into: `assignee, reporter, status, open, team, recent, asset, component,
created-after/before, updated-after/before` — component sits AFTER `asset`, BEFORE the
date-range clauses) in the same file.

## Behavioral Contracts

| BC ID | Title |
|-------|-------|
| BC-2.1.018 | `--component <NAME>` (repeated) → OR-combined `component in (id1, id2, ...)`; independently resolved BEFORE composition |
| BC-2.1.019 | `--component not:<NAME>` → `(component not in (id) OR component is EMPTY)` |
| BC-2.1.020 | `--component none` → `component is EMPTY` |
| BC-2.1.021 | `--component all:<N1>,<N2>` → AND-combined `component = id1 AND component = id2` |
| BC-2.1.022 | Unresolvable/ambiguous name → exit 64 BEFORE any JQL search fires |

## Behavior Summary (verbatim per BC — do not deviate)

- **Bare `--component <NAME>` (BC-2.1.018)**: repeatable; each occurrence resolves
  independently via §8.4, scoped to the invocation's resolved project. Multiple values
  OR-combine into ONE `component in (id1, id2, ...)` clause (not one clause per value). A
  single value → `component in (10001)` (NOT rewritten to `component = 10001`).
- **`not:<NAME>` (BC-2.1.019)**: ALWAYS the full parenthesized `(component not in (...) OR
  component is EMPTY)` form — Jira's `NOT IN`/`!=` operators do not match `EMPTY`, so a bare
  `not in` clause would silently exclude untagged issues, defeating the intuitive meaning.
  Multiple `not:` values combine within the SAME group (one OR-EMPTY clause, not one per
  value). A component literally named `"not:Deprecated"` is UNREACHABLE (reserved-prefix
  collision, documented, not a bug — workaround via `--jql "component = <id>"`).
- **Bare + `not:` coexistence (BC-2.1.018 Precondition 3 / BC-2.1.019 Postcondition 2, M3
  fix-burst — NEW, additive constraint)**: bare and `not:` values MAY coexist in ONE
  invocation, composing TWO AND-joined clauses in bare-then-not: order:
  `component in (10001) AND (component not in (10002) OR component is EMPTY)`. Coexistence
  with `none`/`all:` remains REJECTED.
- **`none` (BC-2.1.020)**: the literal case-insensitive keyword `none`/`None`/`NONE` composes
  `component is EMPTY` with ZERO resolver HTTP (no §8.4 round-trip at all — this is the ONE
  `--component` value that skips resolution entirely). MUST be the ONLY `--component`
  occurrence, or exit 64 pre-flight (`"--component none cannot be combined with other
  --component values."`). Despite needing zero resolver HTTP, `none` is STILL subject to the
  project-scope requirement (Precondition 2, M2 fix-burst) — WITHOUT this, `component is
  EMPTY` would compose as an unscoped, org-wide search across every project the caller can
  see. No `--project`/configured project → exit 64 pre-flight, `"--component none requires
  --project (or a configured default project) to avoid an unrestricted org-wide search."` A
  component literally named `"none"` is unreachable (reserved-keyword collision, documented).
- **`all:<N1>,<N2>,...` (BC-2.1.021)**: comma-separated names after ONE `all:` prefix, AT MOST
  ONE `--component all:...` occurrence per invocation (repeating `all:` → exit 64). Requires
  the issue to carry EVERY listed component simultaneously → `component = id1 AND component =
  id2 AND ...` (repeated equality, AND-joined — NOT `IN`, since `IN` is inherently OR/any-of).
  Each name resolves independently, same project scope. NOT combined with bare/`not:`/`none`
  in the same invocation (exit 64 pre-flight). A component literally named `"all:Backend"`, or
  whose name contains a comma (e.g. `"Backend, Legacy"`), is unreachable/mis-split within an
  `all:` list — documented reserved-syntax collisions, workaround via raw `--jql`.
- **Resolution failure (BC-2.1.022)**: any non-`none` `--component` value resolves via §8.4
  BEFORE JQL composition. Zero matches (BC-8.4.002) → exit 64 listing valid names. 2+ matches
  (BC-8.4.003) → exit 64 listing candidates. In BOTH cases, `POST /rest/api/3/search/jql` is
  NEVER called (VP-COMPONENT-013). No `--project`/config for a bare/`not:`/`all:` value → exit
  64 pre-flight (same "no default scope" posture as BC-2.1.006) BEFORE attempting the
  project-scoped resolver GET.
- **Clause ordering (BC-2.1.007)**: the component clause(s) slot in at the position AFTER
  `asset`, BEFORE the `created-after/before`/`updated-after/before` date-range clauses, in the
  stable order `assignee, reporter, status, open, team, recent, asset, component,
  created-after/before, updated-after/before`.

## Acceptance Criteria

### AC-001 (traces to BC-2.1.018 postcondition 1 — OR composition)
`jr issue list --project FOO --component Backend --component Frontend` → single clause
`component in (10001, 10002)` (input order preserved), not two separate clauses.
**Test:** `test_bc_2_1_018_issue_list_component_repeated_or_composed_single_clause()`

### AC-002 (traces to BC-2.1.018 Edge Case EC-2.1.018-1 — single value)
`--component Backend` alone → `component in (10001)` — NOT rewritten to `component =
10001`.
**Test:** `test_bc_2_1_018_issue_list_component_single_value_stays_in_clause()`

### AC-003 (traces to BC-2.1.019 Behavior — OR-EMPTY form)
`--component not:Frontend` → `(component not in (10002) OR component is EMPTY)` — the FULL
parenthesized form, never a bare `not in`.
**Test:** `test_bc_2_1_019_issue_list_component_not_composes_or_empty_form()`

### AC-004 (traces to BC-2.1.019 Edge Case EC-2.1.019-1 — multiple not: in one group)
`--component not:Backend --component not:Frontend` → single clause `(component not in
(10001, 10002) OR component is EMPTY)`, not two clauses.
**Test:** `test_bc_2_1_019_issue_list_component_multiple_not_single_group()`

### AC-005 (traces to BC-2.1.018 Precondition 3 / BC-2.1.019 Postcondition 2 — bare+not: coexist)
`--component Backend --component not:Frontend` → composes BOTH clauses AND-joined, bare
first: `component in (10001) AND (component not in (10002) OR component is EMPTY)`.
**Test:** `test_bc_2_1_018_issue_list_component_bare_and_not_coexist_bare_first()`

### AC-006 (traces to BC-2.1.020 postcondition 1 — reserved keyword, zero resolver HTTP)
`jr issue list --project FOO --component none` → `component is EMPTY`, ZERO §8.4 resolver
HTTP (no candidate-list GET fires for `none` specifically).
**Test:** `test_bc_2_1_020_issue_list_component_none_zero_resolver_http()`

### AC-007 (traces to BC-2.1.020 Behavior — combination rejection)
`--component none --component Backend` (or `--component none --component not:Backend`) →
exit 64 pre-flight, zero HTTP — `none` rejects ANY other `--component` occurrence regardless
of that occurrence's own prefix.
**Test:** `test_bc_2_1_020_issue_list_component_none_combination_rejected()`

### AC-008 (traces to BC-2.1.020 Precondition 2 / EC-2.1.020-3 — project-scope requirement)
`jr issue list --component none` with no `--project` and no configured project → exit 64
pre-flight (BC-2.1.022 EC-2.1.022-2's message), ZERO HTTP — `none` is NOT exempt from
project-scoping despite needing zero resolver HTTP.
**Test:** `test_bc_2_1_020_issue_list_component_none_requires_project_scope()`

### AC-009 (traces to BC-2.1.021 postcondition 1 — AND composition)
`--component all:Backend,Frontend` → `component = 10001 AND component = 10002` (repeated
equality, NOT `IN`).
**Test:** `test_bc_2_1_021_issue_list_component_all_and_composed_repeated_equality()`

### AC-010 (traces to BC-2.1.021 Precondition 1 — repeated all: rejected)
`--component all:X --component all:Y` (two `all:` occurrences) → exit 64, `"--component all:
may only be specified once; comma-separate multiple names within one all: value."`
**Test:** `test_bc_2_1_021_issue_list_component_repeated_all_prefix_rejected()`

### AC-011 (traces to BC-2.1.021 Precondition 2 / EC-2.1.021-2 — all:+bare rejected)
`--component all:Backend --component Frontend` (mixing `all:` with a bare value) → exit 64
pre-flight, zero HTTP.
**Test:** `test_bc_2_1_021_issue_list_component_all_mixed_with_bare_rejected()`

### AC-012 (traces to BC-2.1.021 Edge Case EC-2.1.021-1 — single-name all: degenerates)
`--component all:Backend` (single name, no comma) → `component = 10001` (one-term AND,
functionally identical to but a DIFFERENT code path from `--component Backend`).
**Test:** `test_bc_2_1_021_issue_list_component_all_single_name_degenerates()`

### AC-013 (traces to BC-2.1.022 Behavior — zero-match resolver failure)
`--component BadName` (zero matches in scope) → exit 64,
`"Component 'BadName' not found in project <key>. Available: <comma-joined alphabetical
list>."`; `POST /rest/api/3/search/jql` NEVER called (`.expect(0)`, VP-COMPONENT-013).
**Test:** `test_bc_2_1_022_issue_list_component_unknown_name_zero_search()`

### AC-014 (traces to BC-2.1.022 Behavior — ambiguous resolver failure)
`--component Amb` (2+ matches) → exit 64, `"Ambiguous component 'Amb'. Matches:
<candidates>."`; zero JQL search calls.
**Test:** `test_bc_2_1_022_issue_list_component_ambiguous_name_zero_search()`

### AC-015 (traces to BC-2.1.022 Edge Case EC-2.1.022-1 — no project scope, bare/not:/all:)
`--component <NAME>` (bare, `not:`, or within `all:`) with no `--project` and no configured
project → exit 64 pre-flight BEFORE attempting the resolver GET, naming `--project`.
**Test:** `test_bc_2_1_022_issue_list_component_no_project_scope_exits_64_before_get()`

### AC-016 (traces to BC-2.1.007 amendment — clause ordering)
`jr issue list --project FOO --assignee alice --component Backend --created-after 2026-01-01`
composes clauses in the stable order with `component` positioned AFTER `asset` (absent here)
and BEFORE `created-after`/`updated-after` — verified via substring-index comparison in the
composed JQL string.
**Test:** `test_bc_2_1_007_issue_list_component_clause_ordering_after_asset_before_dates()`

### AC-017 (traces to BC-2.1.019 Edge Case EC-2.1.019-3 / BC-2.1.020 EC-2.1.020-4 / BC-2.1.021
EC-2.1.021-3 — reserved-syntax collision documentation)
A component literally named `"none"`, `"not:Deprecated"`, or `"all:Backend"` is unreachable
via the corresponding `--component` form (verified structurally: the reserved
prefix/keyword always short-circuits before name resolution is attempted) — this is a
documented limitation, not a bug; test asserts the SHORT-CIRCUIT behavior occurs (zero
resolver GET for the reserved forms), not that the literal name is somehow reachable.
**Test:** `test_bc_2_1_019_020_021_reserved_syntax_collisions_short_circuit_documented()`

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `--component` clause composition (`build_filter_clauses` extension) | `src/cli/issue/list.rs` (additive) | Pure (string/JQL composition) once candidates are resolved; the resolution step itself is effectful |
| `--component` CLI flag (repeatable) | `src/cli/mod.rs` (additive on `List` variant) | N/A (clap derive) |

## Edge Cases

Covered by dedicated ACs: EC-2.1.018-1/2, EC-2.1.019-1/2/3, EC-2.1.020-1/2/3/4,
EC-2.1.021-1/2/3, EC-2.1.022-1/2.

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `cli/issue/list.rs::build_filter_clauses` (component extension) | Pure (clause composition) once ids are resolved | String/JQL composition, no I/O in the composition step itself |
| `cli/issue/list.rs::handle_list` (component resolution call sites) | Effectful shell (unchanged classification) | Already-effectful handler; new call pattern |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|--------------------|
| This story spec | ~7k |
| BC-2.1.018-022 bodies (read in full) | ~9k |
| BC-2.1.006/007 (no-default-scope + clause-ordering context) | ~2k |
| S-604-1 resolver foundation | ~2k |
| `src/cli/issue/list.rs::build_filter_clauses` (existing window) | ~4k |
| Test files + fixtures | ~7k |
| Tool outputs | ~5k |
| **Total** | **~36k** |
| Agent context window | 200K |
| **Budget usage** | **~18%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for bare OR-composition, single-value non-rewrite
2. [ ] Write failing tests for `not:` OR-EMPTY form, multi-value grouping, bare+not: coexistence
3. [ ] Write failing tests for `none` (zero-HTTP, combination rejection, project-scope requirement)
4. [ ] Write failing tests for `all:` AND-composition, repeated-prefix rejection, mixing rejection
5. [ ] Write failing tests for unresolvable/ambiguous-name zero-search guarantee
6. [ ] Write failing tests for clause ordering (position relative to `asset`/date-range clauses)
7. [ ] Verify Red Gate
8. [ ] Implement `--component` parsing (bare/`not:`/`none`/`all:` prefix dispatch)
9. [ ] Implement clause composition in `build_filter_clauses`
10. [ ] Wire CLI flag into `cli/mod.rs`
11. [ ] Refactor; full suite green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|-----------------------|
| S-604-1 | `resolve_component` — project-scoped, numeric-bypass resolver | This story's resolver calls for bare/`not:`/`all:` values ARE `resolve_component` calls, one per name, scoped to the SAME project the invocation is already scoped to | `none` is the ONE `--component` value that bypasses `resolve_component` entirely — do not route it through the resolver "for consistency"; BC-2.1.020 Postcondition 1 explicitly requires zero resolver HTTP for `none` |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|--------------|
| `not:` ALWAYS emits the full parenthesized OR-EMPTY form — never a bare `not in` | BC-2.1.019 Postcondition 1 | AC-003; JQL surprise this codebase specifically avoids |
| `none` fires ZERO resolver HTTP but IS subject to the project-scope requirement | BC-2.1.020 Postcondition 1 / Precondition 2 | AC-006, AC-008 |
| `all:` uses repeated `=` AND-joined, NEVER `IN` | BC-2.1.021 Postcondition 1 | AC-009 |
| Unresolvable/ambiguous name → `POST /rest/api/3/search/jql` is NEVER called | BC-2.1.022 Behavior, VP-COMPONENT-013 | AC-013, AC-014 |
| Component clause position: AFTER `asset`, BEFORE `created-after/before`/`updated-after/before` | BC-2.1.007 amendment | AC-016 |
| This story does NOT implement issue #607's generalized filter grammar — `--component`'s forms are pre-composed, component-specific | F2 file preamble, out-of-scope note | Code review; no new generic multi-valued-filter abstraction introduced |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|----------|
| reqwest / serde (existing) | as in `Cargo.lock` | HTTP |
| wiremock (existing) | as in `Cargo.lock` | Integration tests |

No new crate dependencies.

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|----------|
| `src/cli/issue/list.rs` | MODIFY | `--component` parsing + `build_filter_clauses` extension |
| `src/cli/mod.rs` | MODIFY | `--component` repeatable flag on `List` variant |
| `tests/issue_commands.rs` | MODIFY | New test cases (17 ACs) |
| `tests/common/fixtures.rs` | MODIFY | Component-list fixtures for resolver-scoped tests |

**MUST NOT change**: `src/cli/issue/edit.rs`/`src/cli/issue/create.rs` (S-605-1/S-605-2,
unrelated); `src/cli/component.rs` (S-604-1/2/3, unrelated command group); the
already-established clause order for `assignee`/`reporter`/`status`/`open`/`team`/`recent`/
`asset` (only `component`'s slot is new).
