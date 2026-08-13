---
document_type: f3-dependency-graph-extended
phase: phase-f3-incremental-stories
epic_id: "BUCKET1-DEFECTS"
producer: story-writer
timestamp: 2026-08-13
status: complete
---

# F3 Dependency Graph — Bucket 1 Defect/Enhancement Bundle

## New Stories

| Story | Issue | File | Target module |
|-------|-------|------|-----------------|
| S-692-1 | #692 | `.factory/stories/S-692-1-dry-run-stdin-adf-preview.md` | `src/cli/issue/edit.rs` |
| S-663-1 | #663 | `.factory/stories/S-663-1-auth-switch-profile-guard.md` | `src/main.rs` |
| S-693-1 | #693 | `.factory/stories/S-693-1-queue-view-custom-fields.md` | `src/cli/queue.rs` |
| S-694-1 | #694 | `.factory/stories/S-694-1-attachment-help-text-sync.md` | `src/cli/mod.rs` |

## Dependency Edges

**None.** All four stories are file-disjoint (confirmed at F1 delta analysis
and re-confirmed by this F3 pass against the actual target modules above:
`src/cli/issue/edit.rs`, `src/main.rs`, `src/cli/queue.rs`, `src/cli/mod.rs`
never overlap). Each story's `depends_on: []` and `blocks: []` frontmatter
fields are empty. No story in this bundle depends on any story outside the
bundle either — all four trace to already-ratified, sealed F2 BC bodies with
no open cross-story preconditions.

`src/cli/mod.rs` is touched by S-694-1 only (doc comments on the `Attachment`
variant and its `Download` subcommand fields) — this does NOT create a
dependency on S-692-1 (`src/cli/issue/edit.rs`), S-663-1 (`src/main.rs`), or
S-693-1 (`src/cli/queue.rs`), since none of those three stories touches
`src/cli/mod.rs`.

## Cycle Detection

Topological sort (Kahn's algorithm) over the adjacency list `{S-692-1: [],
S-663-1: [], S-693-1: [], S-694-1: []}` (four isolated nodes, zero edges)
trivially succeeds — no cycles possible with zero edges. No restructuring
required.

## Conflict Detection

- **File overlap with in-progress work**: none. `git status`/`STORY-INDEX.md`
  at the time of this F3 pass show no other story with `status: in-progress`
  touching `src/cli/issue/edit.rs`, `src/main.rs`, `src/cli/queue.rs`, or
  `src/cli/mod.rs`.
- **Dependency on incomplete stories**: none — all four have `depends_on: []`.
- **Race conditions**: none possible with zero edges and file-disjoint scope.

## Result

No new edges to the existing story graph. All four BUCKET1-DEFECTS stories are
independent leaves, safe for parallel-worktree delivery in a single wave.
