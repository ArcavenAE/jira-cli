---
document_type: f3-dependency-graph-extended
phase: phase-f3-incremental-stories
epic_id: "COMPONENT-MGMT"
producer: story-writer
timestamp: 2026-08-15
status: complete
---

# F3 Dependency Graph — Component Management Bundle (Issues #604, #605, #606, #608)

## New Stories

| Story | Issue | File | Target module | Points | Criticality |
|-------|-------|------|-----------------|--------|--------------|
| S-604-1 | #604 | `.factory/stories/S-604-1-component-foundation-list.md` | `src/cli/component.rs` (+ types/api/cache/resolver foundation) | 13 | MEDIUM |
| S-604-2 | #604 | `.factory/stories/S-604-2-component-create-edit.md` | `src/cli/component.rs` | 8 | HIGH |
| S-604-3 | #604 | `.factory/stories/S-604-3-component-delete-safety.md` | `src/cli/component.rs` | 13 | SAFETY-CRITICAL |
| S-605-1 | #605 | `.factory/stories/S-605-1-issue-component-single-key.md` | `src/cli/issue/edit.rs`, `src/cli/issue/create.rs` | 8 | HIGH |
| S-605-2 | #605 | `.factory/stories/S-605-2-issue-component-bulk-edit.md` | `src/cli/issue/edit.rs` | 5 | HIGH |
| S-606-1 | #606 | `.factory/stories/S-606-1-issue-list-component-filter.md` | `src/cli/issue/list.rs` | 8 | LOW |
| S-608-1 | #608 | `.factory/stories/S-608-1-component-rename.md` | `src/cli/component.rs` | 8 | HIGH |

**Total: 7 stories, 63 points.**

## Dependency Edges

```
S-604-1 (foundation: types, api client, cache, resolver, `jr component list`)
  ├──> S-604-2 (component create/edit)
  ├──> S-604-3 (component delete safety)
  ├──> S-605-1 (issue create/edit --component, single-key)
  │       └──> S-605-2 (issue edit --component, bulk)
  ├──> S-606-1 (issue list --component filter)
  └──> S-608-1 (component rename)
```

Adjacency list (`depends_on`):

| Story | depends_on | blocks |
|-------|------------|--------|
| S-604-1 | `[]` | `["S-604-2", "S-604-3", "S-605-1", "S-606-1", "S-608-1"]` |
| S-604-2 | `["S-604-1"]` | `[]` |
| S-604-3 | `["S-604-1"]` | `[]` |
| S-605-1 | `["S-604-1"]` | `["S-605-2"]` |
| S-605-2 | `["S-605-1"]` | `[]` |
| S-606-1 | `["S-604-1"]` | `[]` |
| S-608-1 | `["S-604-1"]` | `[]` |

### Dependency Anchor Justifications

- **S-604-2/S-604-3/S-605-1/S-606-1/S-608-1 each `depends_on: ["S-604-1"]`** because S-604-1
  is the SOLE story that introduces `src/types/jira/component.rs::Component` (the full
  resource type), `src/api/jira/components.rs` (the HTTP client methods every later story's
  `api/jira/components.rs` additions build on top of), the components cache family in
  `cache.rs`, and — most load-bearingly — `src/cli/issue/helpers.rs::resolve_component`, the
  single shared resolver EVERY other story's `NAME|ID` resolution calls through (BC-8.4.001,
  cited by BC-8.1.007 M1, BC-8.1.008, BC-8.2.002 M1, BC-8.3.001 M1, BC-2.1.018-022,
  BC-3.4.022/024/025). None of these five stories can compile, let alone pass its own tests,
  without that resolver and type existing first.
- **S-605-2 `depends_on: ["S-605-1"]`** because S-605-2's bulk path (BC-3.4.023) reuses the
  SAME `add:`/`remove:` CLI-surface parsing S-605-1 establishes for the single-key path (one
  parse, then a fork on `keys.len()` per BC-3.4.022 Invariant 1/BC-3.4.023 Invariant 3) — the
  bulk story does not reimplement flag parsing, it reuses S-605-1's. It also shares S-605-1's
  target module (`src/cli/issue/edit.rs`), so sequencing them dependently avoids two stories
  editing the same handler function concurrently in separate worktrees.
- **No story in this bundle depends on anything OUTSIDE the bundle.** All seven trace to
  already-ratified, sealed F2 BC bodies (`bc-8-components.md`, `bc-2-issue-read.md` §2.1
  amendments, `bc-3-issue-write.md` §3.4 amendments) with no open cross-story preconditions
  from prior cycles.
- **No story in this bundle is depended on by anything OUTSIDE the bundle.** This is a new,
  independent subgraph — verified by grep across every existing `.factory/stories/S-*.md`
  file's `depends_on:`/`blocks:` frontmatter for any reference to `S-604-*`/`S-605-*`/
  `S-606-*`/`S-608-*` (none found; these story IDs did not exist before this burst).

## Cycle Detection

Topological sort (Kahn's algorithm) over the adjacency list above:

1. In-degree 0: `S-604-1` (no incoming edges). Emit `S-604-1`.
2. Remove S-604-1's outgoing edges. New in-degree 0 set: `S-604-2`, `S-604-3`, `S-605-1`,
   `S-606-1`, `S-608-1` (each had exactly one incoming edge, from S-604-1, now removed).
   Emit in wave order: `S-604-2`, `S-604-3`, `S-605-1`, `S-606-1`, `S-608-1`.
3. Remove S-605-1's outgoing edge (to S-605-2). New in-degree 0: `S-605-2`. Emit `S-605-2`.
4. All 7 nodes emitted, 0 edges remaining. **No cycle.**

A valid topological order: `S-604-1, S-604-2, S-604-3, S-605-1, S-606-1, S-608-1, S-605-2`
(or any permutation respecting `S-604-1` first and `S-605-1` before `S-605-2`).

## Conflict Detection

- **File overlap within the bundle**: `src/cli/component.rs` is touched by S-604-1 (create),
  S-604-2, S-604-3, S-608-1 (all modify). This is EXPECTED and safe — S-604-2/S-604-3/S-608-1
  all `depends_on: ["S-604-1"]` and add disjoint handler functions (`handle_create`/
  `handle_edit`, `handle_delete`, `handle_rename` respectively) to the same file; none of
  S-604-2/S-604-3/S-608-1 depends on each other, so if wave-scheduling places them in the same
  wave, worktree-level merge conflicts on `component.rs` are POSSIBLE (same file, different
  functions) — flag this for the wave-scheduling skill (DF-022) to either serialize
  S-604-2/S-604-3/S-608-1 within a wave or accept sequential merge-conflict resolution as a
  known cost of parallelizing same-file, different-function stories. `src/cli/issue/edit.rs`
  is touched by BOTH S-605-1 (single-key `--component`) and S-605-2 (bulk `--component`) — safe
  by construction since S-605-2 `depends_on: ["S-605-1"]` (strictly sequential, not parallel).
  `src/cli/mod.rs` is touched by every story in the bundle (new CLI flags/subcommands) — this
  is a shared, append-only file across the whole codebase and does not itself create a
  dependency between otherwise-independent stories (same posture as the BUCKET1-DEFECTS
  precedent's `src/cli/mod.rs` note).
- **File overlap with in-progress work OUTSIDE the bundle**: none found — `git status` and
  `STORY-INDEX.md` at the time of this F3 pass show no other `status: in-progress` story
  touching `src/cli/component.rs` (new file), `src/api/jira/components.rs` (new file),
  `src/types/jira/component.rs` (new file), or the specific windows of `src/cli/issue/{edit,
  create,list}.rs`, `src/cli/mod.rs`, `src/cache.rs`, `src/cli/issue/helpers.rs`, `src/error.rs`
  this bundle's stories modify.
- **Dependency on incomplete stories**: every `depends_on` entry in this bundle points to
  another story WITHIN this same bundle (S-604-1), never to an external in-flight story — so
  there is no risk of this bundle stalling on unrelated work.
- **Race conditions**: S-604-2, S-604-3, S-605-1, S-606-1, S-608-1 are mutually independent
  (none depends on another among these five) and therefore SAFE to schedule in the same wave
  from a correctness standpoint (each adds disjoint behavior); the only caution is the
  `component.rs`/`edit.rs`/`mod.rs` shared-file merge-conflict note above, which is a
  worktree-mechanics concern, not a correctness/ordering concern.

## Attachment to the Existing Story Graph

This is a NEW, INDEPENDENT SUBGRAPH. Confirmed by:

1. **No existing story `depends_on` any of S-604-1/S-604-2/S-604-3/S-605-1/S-605-2/S-606-1/
   S-608-1** — these story IDs are newly minted by this burst; no prior story file could have
   referenced them.
2. **No existing story is `blocked` by this bundle** — none of the seven stories' target
   modules (`src/cli/component.rs`, `src/api/jira/components.rs`,
   `src/types/jira/component.rs`, plus additive changes to `src/cli/issue/{edit,create,list}.rs`,
   `src/cli/mod.rs`, `src/cache.rs`, `src/cli/issue/helpers.rs`, `src/error.rs`) is the SOLE
   target module of any other story currently `status: draft`/`ready`/`in-progress` in
   `STORY-INDEX.md` — the additive changes to shared files (`cli/mod.rs`, `cli/issue/helpers.rs`,
   `cache.rs`) are append-only and do not conflict with unrelated concurrent work in those
   files' OTHER sections.
3. **This bundle depends on no other story's DELIVERED artifact** — it reads only sealed F2
   specs (`bc-8-components.md`, `bc-2-issue-read.md` §2.1 amendments, `bc-3-issue-write.md`
   §3.4 amendments, `ADR-0018`), none of which are themselves story deliverables.

## Result

7 new stories, 1 new subgraph, internally connected via 7 edges (6 direct `S-604-1 → *` edges
plus 1 `S-605-1 → S-605-2` edge), 63 total points. Topological sort succeeds — **acyclic,
confirmed**. Zero edges to/from the pre-existing story graph — this bundle attaches to
`STORY-INDEX.md` as a wholly independent unit, safe for parallel-worktree delivery starting
from S-604-1 once wave scheduling (a later burst, out of scope here) assigns concrete wave
numbers.

**Target-wave intent (informational only — NOT authoritative; the wave-scheduling skill
computes the real assignment from the `depends_on` graph above at the later integrate burst)**:
Wave 1 = S-604-1, S-604-2, S-604-3 (S-604-1 is a hard predecessor within the wave — if the
scheduler enforces "no two dependent stories share a wave," S-604-1 alone forms Wave 1 and
S-604-2/S-604-3 land in Wave 2). Wave 2 = S-605-1, S-606-1 (both depend only on S-604-1,
mutually independent, parallelizable). Wave 3 = S-605-2 (depends on S-605-1). Wave 4 = S-608-1
(depends only on S-604-1; sequenced last per the orchestrator's dispatch intent, though the
dependency graph alone would permit it as early as Wave 2 alongside S-605-1/S-606-1).
