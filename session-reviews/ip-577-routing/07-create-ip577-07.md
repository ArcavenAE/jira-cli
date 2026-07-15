## Summary

When a sub-agent is resumed via SendMessage after a context switch or cross-session handoff, it has no reliable memory of which worktree it was assigned to. Resume prompts currently specify the story to continue but do not include the explicit worktree path, branch name, or a mandatory pre-commit branch assertion. Stray commits in the wrong worktree are the result.

## Trigger (jira-cli SOH-COMMENT-CRUD-1, F4 wave-C — PG-F4-8)

During F4 wave-C, the implementer was working on story S-577-6 in worktree `.worktrees/S-577-6` on branch `feat/comment-view`. After a context switch (orchestrator resumed the implementer via SendMessage), the agent ran in `.worktrees/S-577-4` (the sibling story's worktree, also open at the time) instead of its assigned worktree. Commits were written to `.worktrees/S-577-4`'s branch before the orchestrator detected the error.

**Detection:** Caught at adversary pass-1 for S-577-6 when the reviewer found that the S-577-6 implementation changes were absent from the expected diff.

**Recovery:** Orchestrator cleaned up the stray commits from `.worktrees/S-577-4`, re-anchored the implementer to the correct worktree with an explicit path, and re-ran the implementation. Required one extra pass-fix round.

## Root Cause

The sub-agent's context window after a SendMessage resume contains only what the resume prompt includes. If the resume prompt says "continue implementing S-577-6" but does not specify `.worktrees/S-577-6` as the worktree path, the agent may infer the current working directory from its shell state — which, in a parallel-wave scenario with multiple open worktrees, may be the wrong one.

## Proposed Fix

**Implementer resume prompt template — mandatory additions:**

```
Resume implementing story <story-id>.

Worktree path: .worktrees/<story-id>
Branch: feat/<slug>

MANDATORY pre-commit guard: Before any `git commit`, run:
  git -C .worktrees/<story-id> rev-parse --abbrev-ref HEAD
Assert it equals: feat/<slug>
If it does NOT equal that branch name, STOP immediately and report to orchestrator before proceeding. Do NOT commit.
```

**Orchestrator dispatch checklist addition:** Every implementer dispatch (initial or resume) must include the explicit worktree path and branch name as named fields, not embedded prose.

**Parallel-wave context:** This risk is amplified when multiple stories share the same orchestrator context and multiple worktrees are open simultaneously. In that configuration, the "current working directory" the agent inherits from a prior step may belong to any of the open worktrees.

## Severity

LOW process-gap for single instances; MEDIUM aggregate risk in parallel-wave delivery where multiple worktrees are open simultaneously.

## Source

jira-cli SOH-COMMENT-CRUD-1 session review 2026-07-15 (IP-577-07). Codified in `.factory/cycles/cycle-001/lessons.md` as PG-F4-8 (RESUMED-SUBAGENT-IN-WRONG-WORKTREE).
