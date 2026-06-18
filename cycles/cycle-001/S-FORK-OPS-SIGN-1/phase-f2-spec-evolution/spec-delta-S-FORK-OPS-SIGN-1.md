---
story: S-FORK-OPS-SIGN-1
phase: F2-spec-evolution
date: 2026-06-18
status: COMPLETE
convergence: 6 adversary passes
---

# F2 Spec Delta — S-FORK-OPS-SIGN-1 (fork-ops signing workflow hardening)

## Convergence

6 adversary passes to converge. Notable catches during F2:

- **Round 4:** Self-defeating --cleanup-tag ordering bug. The spec described the
  atomic alpha-tag sequence in piecewise normative paragraphs across multiple
  sections. Round 4 adversary identified that `--cleanup-tag` was being called
  in a position that could purge the tag just created by the atomic `gh api
  git/refs` call. Fixing required rewriting the control-flow block as a single
  worked multi-step sequence, not scattered normative clauses.
- **Round 6:** Piecewise control-flow process-gap. Adversary noted that multi-step
  atomic sequences specified as separate numbered paragraphs (not as one worked
  code block) are vulnerable to implementation gaps where intermediate state
  assumptions fail silently. Spec revised to show atomic sequences as single
  worked control-flow blocks with explicit intermediate state.

## Key Spec Decisions

1. Injection guard (`check-signing-workflow-injection.sh`) uses structural scope
   (every job with secrets: write OR contents: write), not hardcoded-scope.
   Hardcoded scope was a F5 finding (see adversarial-reviews/).
2. Signing enablement gate: INERT. SIGNING_ENABLED=true is a human decision
   (DEC-104). This story UNBLOCKS but does not enable.
3. Alpha-tag atomic protocol: `gh api git/refs` (create-or-fail atomic), NOT
   `gh release create --target <tag>` (which was the racy sequence).
4. Temp files: `mktemp -t cs.XXXXXX` + `trap 'rm -f "$TMP"' EXIT`. No predictable
   paths.
5. pipefail: `set -eo pipefail` on all bash blocks in verify steps.

## Lesson: Multi-Step Atomic Sequences (F2-PIECEWISE)

Multi-step atomic sequences MUST be specified as one worked control-flow block,
not piecewise normative paragraphs. Piecewise spec caused round-4 self-defeating
--cleanup-tag ordering bug in the F2 spec itself. This lesson is codified in
cycles/cycle-001/lessons.md.

_Recorded: 2026-06-18_
