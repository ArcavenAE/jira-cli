---
document_type: f3-wave-schedule
phase: phase-f3-incremental-stories
epic_id: "COMPONENT-MGMT"
producer: story-writer
timestamp: 2026-08-15
status: complete
---

# F3 Wave Schedule — Component Management Bundle (Issues #604, #605, #606, #608)

Refines `components-dependency-graph-extended.md`'s dependency edges into a concrete,
dependency-driven execution schedule. This is NOT the informational "Target-wave intent"
sketch at the bottom of that file — it supersedes it with a real serialization
constraint the sketch did not account for: three stories append to the same
`ComponentSubcommand` enum and `src/cli/component.rs` handler file.

## Wave 1 (hard gate) — S-604-1

| Story | Points | Priority | Target module |
|-------|--------|----------|-----------------|
| S-604-1 | 13 | HIGH | `src/cli/component.rs` (new) + `src/types/jira/component.rs` (new) + `src/api/jira/components.rs` (new) + `src/cache.rs` + `src/cli/issue/helpers.rs::resolve_component` + `src/cli/mod.rs` |

**Wave 1 total: 13 points.**

**Why this is a hard gate, not just first-in-order:** S-604-1 is the SOLE story that
introduces the `Component` type, the HTTP client methods, the components cache family,
and — most load-bearingly — `resolve_component`, the single shared `NAME|ID` resolver
every other story's own resolution logic calls through (per the dependency graph's
Dependency Anchor Justifications). None of the other six stories can compile, let alone
pass their own tests, until S-604-1's foundation exists. Nothing else in this bundle
starts until S-604-1 merges.

## Wave 2 (after S-604-1) — everything else, under a serialization constraint

All six remaining stories depend only on S-604-1 (confirmed acyclic by the dependency
graph's Kahn's-algorithm sort) and are otherwise mutually independent from a
correctness standpoint. However, three of them collide on the same file surface and
must be serialized within the wave; the other three (as one dependent pair plus one
singleton) are file-disjoint from that trio and from each other, and run in parallel
alongside it.

### Serialized sub-track: S-604-2 → S-604-3 → S-608-1

| Order | Story | Points | Target module | Adds |
|-------|-------|--------|-----------------|------|
| 1 | S-604-2 | 8 | `src/cli/component.rs` | `ComponentSubcommand::{Create,Edit}` variants + `handle_create`/`handle_edit` |
| 2 | S-604-3 | 13 | `src/cli/component.rs` | `ComponentSubcommand::Delete` variant + `handle_delete` |
| 3 | S-608-1 | 8 | `src/cli/component.rs` | `ComponentSubcommand::Rename` variant + `handle_rename` |

**Serialization rationale:** S-604-2, S-604-3, and S-608-1 all insert a new variant
into the same `ComponentSubcommand` enum (`src/cli/mod.rs`) and add a new handler
function to the same `src/cli/component.rs` file. Three concurrent worktrees each
inserting an enum variant into the same match/derive block is a three-way
merge-conflict risk on every merge after the first — the second and third stories to
land would each need to rebase through a moving enum definition. Serializing avoids
this at the cost of wall-clock time, which is the right trade here given the file's
small size and the safety profile of the changes involved. Order chosen as:
1. **S-604-2 first** — it is the smaller of the two non-delete stories (8 pts) and
   establishes the create/edit pattern the other two can follow structurally.
2. **S-604-3 second** — SAFETY-CRITICAL (delete, irreversible without Jira's own undo
   path); isolating it as the sole in-flight change in `component.rs` at merge time
   maximizes reviewer/reviewer-bandwidth focus on its move-to/orphan-handling logic
   without a concurrent unrelated diff on the same file muddying the review.
3. **S-608-1 last** — lowest urgency of the three (rename is a convenience operation,
   not core CRUD or delete-safety), and by this point `component.rs` has stabilized
   around the create/edit/delete shape, minimizing rebase churn for the final entrant.

### Parallel track A: S-605-1 → S-605-2 (dependent pair, LIVE-JIRA-gated tail)

| Order | Story | Points | Target module |
|-------|-------|--------|-----------------|
| 1 | S-605-1 | 8 | `src/cli/issue/edit.rs`, `src/cli/issue/create.rs` |
| 2 | S-605-2 | 5 | `src/cli/issue/edit.rs` |

S-605-2 `depends_on: [S-605-1]` per the dependency graph (reuses the `add:`/`remove:`
CLI-surface parsing S-605-1 establishes, then forks on `keys.len()`). S-605-2 is
LIVE-JIRA-gated — its bulk-path E2E coverage requires a live run, which does not block
Wave 2 completion for the rest of the bundle but should be scheduled with that gate's
latency in mind.

### Parallel track B: S-606-1 (singleton)

| Story | Points | Target module |
|-------|--------|-----------------|
| S-606-1 | 8 | `src/cli/issue/list.rs`, `src/jql.rs` |

No file overlap with `component.rs`, `edit.rs`, or `create.rs`. Fully independent
within Wave 2 once S-604-1 has landed.

### Why Track A and Track B run alongside the serialized trio

Neither `S-605-1`/`S-605-2` (edit.rs, create.rs) nor `S-606-1` (list.rs, jql.rs)
touches `src/cli/component.rs` or the `ComponentSubcommand` enum — their additions are
new `--component` flags/filters on already-existing, unrelated handler functions in
different files. There is no merge-conflict surface between either parallel track and
the serialized trio, so both can proceed in their own worktrees concurrently with
S-604-2/S-604-3/S-608-1 without any of the three-way collision risk described above.

**Wave 2 total: 8 + 13 + 8 (serialized trio) + 8 + 5 (Track A) + 8 (Track B) = 50 points.**

## Critical Path

Practical critical path = Wave 1 + the serialized trio =
`S-604-1 (13) → S-604-2 (8) → S-604-3 (13) → S-608-1 (8)` = **42 points**.

Track A (`S-605-1 → S-605-2` = 13 points) and Track B (`S-606-1` = 8 points) both run
in parallel worktrees alongside the serialized trio and finish well inside that
42-point window — neither adds to the wall-clock floor. The wave's wall-clock length is
therefore governed by the serialized trio's chain, not by summing all Wave 2 points.

**Total bundle points: 13 (Wave 1) + 50 (Wave 2) = 63 points** (matches
`components-dependency-graph-extended.md`'s bundle total).

## Relationship to the F1 Issue Grouping

This refines, rather than replaces, the F1 4-issue-wave plan. At the issue level,
#604/#605/#606/#608 are independent once the shared foundation (#604's own
`component list`/foundation slice) exists — so at F1 granularity they collapse to 2
dependency-waves (foundation, then everything else). At the story level, decomposing
#604 into three separate stories (S-604-1 foundation, S-604-2 create/edit, S-604-3
delete) surfaces the `component.rs`/`ComponentSubcommand` file-collision constraint
that issue-level grouping couldn't see — hence the serialized sub-track inside Wave 2
above, which the F1 plan's "2 dependency-waves" framing did not (and could not, at that
granularity) capture.

## Wave Gate

Standard post-wave integration gate applies at the close of Wave 2
(`vsdd-factory:wave-gate`): full test suite on `develop` after all seven stories merge,
adversarial review of the combined wave diff, holdout evaluation (see
`components-wave-holdout-scenarios.md`), demo evidence, before this bundle is
considered converged. No Wave 3 is currently planned for this bundle.

## Notes

- No DTU clone stories flagged at F2 — all seven stories operate against Jira REST API
  v3 endpoints already covered by existing wiremock fixtures; no new external-service
  dependency is introduced.
- No `implementation_strategy: gene-transfusion` stories — all seven are `tdd_mode:
  strict` (net-new logic in an existing, well-understood module family; no reference
  implementation to port).
- S-604-3 (delete safety) and S-608-1 (rename) both carry `priority: P1`/HIGH per their
  own frontmatter — the serialization order above is a file-collision-avoidance
  ordering, not a priority ordering; S-604-3's SAFETY-CRITICAL classification is
  honored by isolating its review window, not by running it first.
- `--all-projects` fan-out in S-608-1 and delete-safety orphan handling in S-604-3 are
  both O(N)-scale operations against `jr`'s existing 429-retry machinery — no new
  rate-limit handling is introduced by either, consistent with both stories' own AC
  sets.
