---
story: S-FORK-OPS-SIGN-1
phase: F5-adversarial-refinement
date: 2026-06-18
passes: 5
status: CONVERGED
---

# F5 Adversarial Review Summary — S-FORK-OPS-SIGN-1

## Convergence: 5 passes

Notable findings:

### Pass 1 — CRITICAL: Guard hardcoded-scope false-negative

The initial `check-signing-workflow-injection.sh` used a hardcoded list of 5
injection sites. The adversary found that the guard had a live false-negative:
the structural scope (every job with secrets/contents:write permissions) covers
more jobs than the hardcoded list. Specifically, the guard would pass even if
new write-permission jobs were added with unbound context.

**Fix:** Rewrote guard to use structural scope — YAML-parse every job block
and check for `secrets: write` OR `contents: write` in permissions. Guard
now fails-closed on any new write-permission job that lacks env-binding.

This rewrite surfaced 23 injection sites vs the original 5. The original guard
was a false security check that would have shipped undetected.

### Pass 2 — CRITICAL: Missing negative self-test fixture

Guard lacked a "known-bad" fixture to confirm it WOULD catch an injection.
Positive-coverage assertion alone (guard passes on known-good workflow) does
not prove the guard works. Without a negative fixture, a guard that always exits
0 would pass CI.

**Fix:** Added `tests/fixtures/sign-and-publish-vulnerable.yml` — a deliberately
vulnerable YAML fixture used by `check-signing-workflow-injection.sh --self-test`
to assert that the guard WOULD fire on a known-bad input (exit 1 on the fixture,
exit 0 on the real workflow).

### Pass 3 — HIGH: F2 spec edits in wrong checkout

F2 spec edits to `.factory/` were confirmed in the story worktree (LESSON-F2-
WORKTREE-FIRST applied correctly).

### Passes 4–5 — LOW nits, converged

Converged with no new CRITICAL/HIGH findings.

## Structural-Scope Rewrite Impact

Original hardcoded scope: 5 injection sites checked.
Structural scope: 23 injection sites checked.

The 18 additional sites were jobs that had `contents: write` or `secrets: write`
in their permissions blocks but were not enumerated in the hardcoded list.
All 23 sites are now env-bound in the shipped sign-and-publish.yml.

## Validates DEC-121

Full VSDD Feature Mode on a CI-workflow-only security fix. F5 caught a CRITICAL
guard false-negative that a naive "looks good" review would have shipped.
Structural-scope rewrite surfaced 23 injection sites vs 5. Reinforces DEC-120.

_Recorded: 2026-06-18_
