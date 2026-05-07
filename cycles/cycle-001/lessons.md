---
document_type: lessons-learned
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-05-07T00:00:00
cycle: "cycle-001"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Lessons Learned — cycle-001

<!-- Durable lessons from this cycle for future VSDD factory runs.
     Organized by category: agent-level, process-level, infrastructure-level.
     Each lesson is numbered continuously and includes the pass/burst
     where it was discovered. -->

## Agent-Level

_(none yet)_

## Process-Level

1. **PR-body 'Deviations' section + reviewer prompt catches scope-creep** — S-0.04 review cycle 1 surfaced a CLAUDE.md violation (cross-profile cache fallback in cache.rs) that would have shipped undetected. The implementer listed the deviation explicitly in the PR body under a "Deviations" section, and the reviewer prompt was drafted to evaluate scope-creep. This pattern validated: surface implementer deviations explicitly in PR body so reviewer can triage (revert vs. accept) rather than accepting silently.
   _Discovered: S-0.04 review cycle 1, 2026-05-07_

## Infrastructure-Level

_(none yet)_

## Policy Candidates

<!-- Lessons that should be formalized as governance policies.
     Reference the lesson number and proposed policy scope. -->

| Lesson | Proposed Policy | Scope | Status |
|--------|----------------|-------|--------|
| 1 | Require "Deviations" section in all Phase 3 PR bodies; reviewer must explicitly accept or reject each deviation | Phase 3 fix-PR delivery (vsdd-factory:fix-pr-delivery) | proposed |
