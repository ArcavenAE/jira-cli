---
document_type: wave-schedule
level: ops
version: "1.0"
phase: phase-f3-incremental-stories
cycle: cycle-014
feature: issue-triage-quickfixes
status: draft
producer: story-writer
created: 2026-09-26
timestamp: "2026-09-26T00:00:00"
inputs:
  - ".factory/cycles/cycle-014/phase-f3-stories/dependency-graph-extended.md"
traces_to: "dependency-graph-extended.md §3, cycle-manifest.md D-381"
input-hash: "d53687b"
---

# F3 Wave Schedule -- `issue-triage-quickfixes` (cycle-014)

Wave grouping by Kahn-layering (BFS levels over the acyclic 3-node linear-chain graph proven in
`dependency-graph-extended.md` §3). Unlike cycle-008's mostly-parallel Wave 1, cycle-014 is
SERIAL by human decision (D-381, 2026-09-25 F2 review) -- one story per wave, three waves total.

## Summary

| Metric | Value |
|--------|-------|
| Total stories (this cycle) | 3 |
| Total waves | 3, fully serial (no parallelism within any wave) |
| Max parallelism (stories in one wave) | 1 |
| Total story points | 16 (A: 3, C: 8, B: 5) |
| Critical path (= the entire cycle, since delivery is serial) | A -> C -> B (3 + 8 + 5 = 16 points) |
| Estimated agent spawns | 3 (one implementer dispatch per story) |

---

## 1. Layering Derivation

| Round | Indegree-0 set at this round | Wave |
|-------|----------------------------------|------|
| 1 | {A} | **Wave 1** |
| 2 | {C} (reaches indegree 0 only after Wave 1's A completes and merges) | **Wave 2** |
| 3 | {B} (reaches indegree 0 only after Wave 2's C completes and merges) | **Wave 3** |

**Computed layering -- 3 serial waves, one story each:** A (`S-cycle14-user-list-project-resolution`)
has `depends_on: []` and reaches indegree 0 immediately (Wave 1). C
(`S-cycle14-api-query-param`) depends on A and reaches indegree 0 only once A merges (Wave 2). B
(`S-cycle14-field-options-name-label`) depends on C and reaches indegree 0 only once C merges
(Wave 3). This mirrors the topological order computed in `dependency-graph-extended.md` §3
exactly.

## Wave Plan

### Wave 1 (no dependencies)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-cycle14-user-list-project-resolution | 3 | S | 1 story/agent |

### Wave 2 (depends on Wave 1)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| C | S-cycle14-api-query-param | 8 | L | 1 story/agent |

### Wave 3 (depends on Wave 2)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| B | S-cycle14-field-options-name-label | 5 | M | 1 story/agent |

---

## 2. File-Overlap Check

| Story | Primary file(s) touched |
|-------|-----------------------------|
| A (Wave 1) | `src/cli/mod.rs`, `src/main.rs`, `src/cli/user.rs`, `tests/user_commands.rs` (modify), `tests/user_list_project_resolution.rs` (new), `tests/user_pagination.rs` (modify), `tests/all_flag_behavior.rs` (modify, conditional), `README.md`, `.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`, `CHANGELOG.md` |
| C (Wave 2) | `src/cli/mod.rs`, `src/main.rs`, `src/cli/api.rs`, `tests/api_query_param.rs` (new), `README.md`, `.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`, `CHANGELOG.md` |
| B (Wave 3) | `src/cli/field.rs`, `src/cli/mod.rs`, `src/types/jira/editmeta.rs`, `src/api/jira/issues.rs`, `tests/field_options.rs` (modify -- rename + comments only, no new test file), `README.md`, `CLAUDE.md`, `CHANGELOG.md` |

**Overlap is expected and intentional, not a defect:** `src/cli/mod.rs`/`README.md`/`CHANGELOG.md`
are touched by all three stories in different regions; `.cargo/mutants.toml`/
`docs/specs/cargo-mutants-policy.md` are touched by A and C only, with a genuine sequential
numeric dependency (32 -> 33 -> 34) described in `dependency-graph-extended.md` §4. Because
delivery is strictly serial (one story per wave, each rebased on the prior story's merged
`develop` tip before its own PR opens), there is no live merge-conflict window at all -- by
construction, only one story's diff is ever open against `develop` at a time.

- **`CHANGELOG.md` overlap (A, C, B):** append-only shared file, same low-risk class as every
  prior cycle's `CHANGELOG.md` overlap in this repo. Serial delivery means each story's entry is
  simply appended after the prior story's, in wave order -- no reconciliation needed.
- **`src/cli/mod.rs`/`README.md` overlap with EXISTING (non-cycle-014) draft stories** -- see
  `dependency-graph-extended.md` §6 for the full accounting: `S-cycle7-oauth-help-text-fix` and
  `S-cycle7-readme-migration-note` (both `status: draft`, cycle-007, still un-dispatched) also
  touch these two files, in disjoint sections (`AuthCommand::Login` help text / a different
  README migration bullet). No `depends_on:` edge added -- a file-overlap note only, recommending
  merge-order awareness (rebase, not blocking) if either cycle-007 story lands during cycle-014's
  delivery window.

---

## 3. Pipeline Serialization Plan

Because delivery is strictly serial (D-381), there is no pipeline overlap between waves at all --
each story's worktree is cut from `develop` only after its predecessor's PR has merged, and no
story's test-writing or implementation may begin before that merge, even where the two stories'
own functions have no type dependency on one another:

| Activity | When |
|------------------|------|
| Wave 2 (C) test-writing | MUST NOT start until Wave 1 (A) has merged to `develop` -- C's worktree is cut from `develop` only after A's merge, so no `develop` state exists yet for C's test-writing to build on even though C's own pure functions (`append_query_params`, `parse_query_param`) have no type dependency on A's `resolve_user_list_project` |
| Wave 2 (C) implementation | MUST NOT start until Wave 1 (A) has merged to `develop` -- C's PR must rebase onto A's landed `.cargo/mutants.toml`/`docs/specs/cargo-mutants-policy.md` count (32->33) before bumping it to 34 |
| Wave 3 (B) test-writing | MUST NOT start until Wave 2 (C) has merged to `develop` -- B's worktree is cut from `develop` only after C's merge, so no `develop` state exists yet for B's test-writing to build on even though B's own fix (`normalize_from_allowed_values_at_depth`) has no type dependency on C's new functions |
| Wave 3 (B) implementation | MUST NOT start until Wave 2 (C) has merged to `develop` -- B's PR must rebase onto C's landed `src/cli/mod.rs`/`README.md` state before editing its own disjoint regions of those files |

No row above permits overlap: each wave's test-writing and implementation are both gated on the
prior wave's merge, matching the `depends_on:` edges in `dependency-graph-extended.md` §4 (D-381)
and the `deliver-story` prerequisite that every `depends_on` story be complete -- stubs before
tests before implementation -- before the next story's worktree is even cut.

## Critical Path

The critical path IS the entire cycle, since delivery is serial by design: A (3 pts) -> C
(8 pts) -> B (5 pts) = **16 points total**, with zero parallelism available. This is a deliberate
trade-off, not an oversight: the human decision at D-381 prioritized avoiding a three-way
`src/cli/mod.rs`/`README.md` merge-conflict-resolution burden over minimizing wall-clock delivery
time for this LOW-severity, three-item bug-fix cycle.
