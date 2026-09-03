---
document_type: lessons-learned
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-03T15:30:00Z
cycle: "cycle-003-auth-profile-dx"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Lessons Learned — cycle-003 (auth-profile-dx)

<!-- Durable lessons from this cycle for future VSDD factory runs.
     Organized by category: agent-level, process-level, infrastructure-level.
     Each lesson is numbered continuously and includes the pass/burst
     where it was discovered. Created at cycle CLOSE (Burst 22, 2026-09-03)
     per the S-7.02 cycle-closing checklist, mirroring cycle-002's
     lessons.md precedent. -->

## Agent-Level

<!-- none logged yet this cycle -->

## Process-Level

1. **[process-gap] `STORY-INDEX.md` was frozen at F3 (status `ready`, "awaiting F4 dispatch") and never updated through F4/F5/F6 execution, despite all 7 cycle-003 stories shipping across Waves 1-5.** This was the root cause of the F7 pre-gate consistency audit's CRIT-1 finding (both the status table and the file-path table still read stale `ready`/pending-dispatch language for all 7 `S-cycle3-*` rows). The finding itself was fixed at Burst 20 (corrected to `done` with PR/commit citations for all 7 stories), but the underlying process gap — no mechanism re-syncs STORY-INDEX.md as stories complete each wave — was not addressed, only its symptom.
   _Discovered: F7 pre-gate fresh-context consistency audit, Burst 20, 2026-09-03_
   _Codified (S-7.02 cycle-closing checklist, 2026-09-03): no follow-up story exists in STORY-INDEX targeting this finding. Justified-deferral entry recorded in STATE.md Drift/Standing Items (target: future SELF-IMPROVEMENT/maintenance cycle; reason: process-doc/bookkeeping-discipline improvement — an index-currency sync step at each wave-gate close, not a code defect)._

2. **[process-gap] 4 of the 7 cycle-003 story files (`S-cycle3-percred-storage.md`, `S-cycle3-credential-absence-guard.md`, `S-cycle3-oauth-default-creation.md`, `S-cycle3-chosen-flow-reconcile.md`) are missing the story-template's `level` frontmatter key plus the Architecture Mapping / Purity / Library sections.** Pre-existing gap, surfaced only by the F7 pre-gate audit; did not block F4/F5/F6/F7/release — all 4 stories shipped and passed hardening/convergence regardless — but represents a template-conformance drift that a story-authoring discipline check would have caught earlier.
   _Discovered: F7 pre-gate fresh-context consistency audit, Burst 20, 2026-09-03_
   _Codified (S-7.02 cycle-closing checklist, 2026-09-03): no follow-up story exists in STORY-INDEX targeting this finding. Justified-deferral entry recorded in STATE.md Drift/Standing Items (target: future SELF-IMPROVEMENT/maintenance cycle; reason: story-template conformance sweep, non-blocking — a template-compliance validator at story-authoring time is a spec-authoring discipline improvement, not a code defect)._

## Content-Level

<!-- none logged yet this cycle -->

## Infrastructure-Level

1. **[infra-observation] `gh pr merge`/push actions initiated by an agent are auto-denied by the Claude Code auto-mode permission classifier, even when the merge DECISION is fully autonomous per policy (DEC-330/DEC-331).** First surfaced blocking PR #757; reaffirmed at every subsequent session resume through cycle-003's close — the resuming session must drive `gh pr merge`/push from the MAIN session loop, not via github-ops sub-agents, until this permission-classifier gap is resolved. Not a VSDD agent-prompt gap; a harness/infra behavior worth revisiting (e.g. a scoped session permission rule for the merge command) so the merge ACTION can be as autonomous as the merge DECISION.
   _Discovered: F4 Wave 3, PR #757, 2026-09-02; reaffirmed through cycle close, 2026-09-03_

## Policy Candidates

<!-- Lessons that should be formalized as governance policies.
     Reference the lesson number and proposed policy scope. -->

| Lesson | Proposed Policy | Scope | Status |
|--------|----------------|-------|--------|
| 1 | STORY-INDEX index-currency sync at each wave-gate close | Any wave/story-gate closing burst that merges a story PR must also update that story's STORY-INDEX.md row (status + PR/commit citation) in the same burst, not deferred to a later audit | proposed |
| 2 | Story-template conformance check at authoring time | story-writer's F3 authoring pass should validate every new story file against the full story-template section list (including `level` frontmatter key + Architecture Mapping/Purity/Library sections) before marking a story `ready` | proposed |
