---
document_type: f3-wave-schedule
phase: phase-f3-incremental-stories
epic_id: "BUCKET1-DEFECTS"
producer: story-writer
timestamp: 2026-08-13
status: complete
---

# F3 Wave Schedule — Bucket 1 Defect/Enhancement Bundle

## Wave 1 (only wave)

All four stories are independent (see `bucket1-defects-dependency-graph-extended.md`)
and run in parallel, each in its own worktree.

| Story | Points | Priority | Breaking? | Target module |
|-------|--------|----------|-----------|-----------------|
| S-692-1 | 5 | HIGH | YES — CHANGELOG entry required | `src/cli/issue/edit.rs` |
| S-663-1 | 3 | HIGH | YES — CHANGELOG entry required | `src/main.rs` |
| S-693-1 | 5 | MEDIUM | No (additive) | `src/cli/queue.rs` |
| S-694-1 | 2 | LOW | No (docs-only) | `src/cli/mod.rs` |

**Wave total: 15 points.**

## Critical Path

Trivial — max(story delivery time) across the 4 independent stories, not a
sum. No story blocks another. The longest individual story (S-692-1 or
S-693-1, both 5 points, both touching a live-path/dry-run-preview or
HTTP-pipeline seam with more edge cases than S-663-1's single-guard scope or
S-694-1's docs-only scope) sets the wave's wall-clock floor if delivered
serially by a single agent; delivered in 4 parallel worktrees, the wave
completes in roughly one story's worth of wall-clock time.

## Wave Gate

Standard post-wave integration gate applies at wave close
(`vsdd-factory:wave-gate`): full test suite on `develop` after all four merge,
adversarial review of the combined wave diff, holdout evaluation (see
`bucket1-defects-wave-holdout-scenarios.md`), demo evidence, before any
subsequent wave (none currently planned for this bundle — this is the only
wave).

## Notes

- No DTU clone stories flagged at F2 — none of the four issues introduces a
  new external-service dependency; all four operate against Jira/JSM
  endpoints already covered by existing wiremock fixtures.
- No `implementation_strategy: gene-transfusion` stories — all four are
  `tdd` (net-new/modified logic in an existing, well-understood module; no
  reference implementation to port).
- Two of the four (S-692-1, S-663-1) carry `breaking_change: true` — each
  requires a `CHANGELOG.md` `### Breaking Changes` entry in its own PR, per
  its story's AC-14/AC-9 respectively. These are independent breaking changes
  (different CLI surfaces) and do not need to ship in the same release train,
  though bundling them in one release is the current plan (BUCKET1-DEFECTS is
  a single F1-F7 cycle).
