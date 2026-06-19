---
document_type: wave-schedule
bundle: S-FORK-OPS-BACKFILL
stories:
  - S-FORK-OPS-BACKFILL-1
  - S-FORK-OPS-GITLEAKS-DOC-1
produced_by: story-writer
phase: F3
created: "2026-06-18"
version: "1.0"
---

# Wave Schedule — S-FORK-OPS-BACKFILL Bundle

## Summary

Two independent stories, both in a single wave (parallelizable).

## Cycle Check Result

**ACYCLIC — trivially verified.**

Dependency graph: both stories have `depends_on: []`. There are no edges in the
dependency graph, so no cycles are possible. The graph is a forest of two isolated
leaf nodes.

```
S-FORK-OPS-BACKFILL-1    (no deps, no blockers)
S-FORK-OPS-GITLEAKS-DOC-1  (no deps, no blockers)
```

## Conflict Check Result

**NO CONFLICTS.**

File-level conflict analysis:

| Story | Files Modified |
|-------|---------------|
| S-FORK-OPS-BACKFILL-1 | `.github/workflows/backfill-release.yml`, `tests/backfill_matrix_parity.rs` (NEW) |
| S-FORK-OPS-GITLEAKS-DOC-1 | `docs/specs/fork-friendly-release-ops.md`, `CLAUDE.md` |

Zero file overlap. Both stories can be dispatched, reviewed, and merged in any
order or concurrently without worktree conflicts.

Additionally verified: no in-progress story in the current graph touches any of
these four files (no active open PRs as of 2026-06-18; last merged: S-FORK-OPS-SIGN-1
PR #535 → 1a2a79b).

## Wave Schedule

| Wave | Story | Rationale | Effort |
|------|-------|-----------|--------|
| 1 | S-FORK-OPS-BACKFILL-1 | No dependencies; touches backfill-release.yml + new test | 5 SP (small/medium) |
| 1 | S-FORK-OPS-GITLEAKS-DOC-1 | No dependencies; touches docs/CLAUDE.md only | 1 SP (xsmall) |

**Both stories are in Wave 1 (the only wave). They are parallelizable — independent
agents can implement them simultaneously with no coordination needed.**

## Execution Recommendation

Given the large effort differential (5 SP vs 1 SP), the recommended dispatching
order is:

1. **Dispatch S-FORK-OPS-BACKFILL-1 first** (critical path — YAML edits + Rust test)
2. **Dispatch S-FORK-OPS-GITLEAKS-DOC-1 concurrently or after** (trivial — 2 Markdown
   edits; can merge ahead of or after Story 1 independently)

S-FORK-OPS-GITLEAKS-DOC-1 should not block on S-FORK-OPS-BACKFILL-1 — it is safe
to merge the doc story first and have Story 1 follow.

## Exit Gate

All of the following must be true before this bundle is considered CLOSED:

- [ ] `cargo test --test backfill_matrix_parity` exits 0 (S-FORK-OPS-BACKFILL-1 REQUIRED test)
- [ ] `bash scripts/check-signing-workflow-injection.sh` exits 0 after Windows steps added
- [ ] `gh release delete` pattern absent from `backfill-release.yml` (DESTRUCTIVE fixed)
- [ ] `GITLEAKS_DISABLED` present in `docs/specs/fork-friendly-release-ops.md` variables table
- [ ] `GITLEAKS_DISABLED` bullet present in `CLAUDE.md` AI Agent Notes, adjacent to `JR_E2E_ENABLED`
- [ ] STATE.md drift items FORK-OPS-BACKFILL-WIN-TARGET, FORK-OPS-BACKFILL-DESTRUCTIVE,
  FORK-OPS-GITLEAKS-DOC marked RESOLVED
- [ ] STORY-INDEX.md updated with both story statuses

## Story Count

- Stories before this bundle: 81
- Stories added by this bundle: 2
- Stories after this bundle: **83**
