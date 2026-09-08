---
document_type: lessons-learned
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-08T19:20:00Z
cycle: "cycle-006-mutants-ci-sharding"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Lessons Learned — cycle-006 (mutants-ci-sharding)

<!-- Durable lessons from this cycle for future VSDD factory runs.
     Organized by category: agent-level, process-level, infrastructure-level.
     Each lesson is numbered continuously and includes the pass/burst
     where it was discovered. Created at the Phase F3 human gate approval
     (Burst 8, 2026-09-08) per the S-7.02 cycle-closing checklist, mirroring
     cycle-002/cycle-003's lessons.md precedent. cycle-006 is not yet CLOSED
     (F4-F7 remain ahead) -- this file will continue to accumulate lessons
     through the rest of the cycle. -->

## Agent-Level

<!-- none logged yet this cycle -->

## Process-Level

1. **[process-gap] Fix rounds 11/12's broad rewrites of the wave-holdout asymmetry note introduced the P29 HIGH EC-004/AC-037 mis-anchoring** that fresh-context adversarial pass 29 then had to catch, diagnosed, and round 13 had to fix. The remediation edit widened its own blast radius past the specific defect it was closing, drifting a cross-reference (EC-004 ↔ AC-037) that the surrounding prose depended on, and the edit was not paired with a check against the story's own edge-case tables before being accepted. Net effect: a genuine finding was fixed, but the fix itself became a new finding one adversarial pass later, costing an extra fix round and adversarial pass before convergence.
   _Discovered: fresh-context adversarial pass 29, Burst 5, 2026-09-08 (fix applied in round 13, same burst)._
   _Codification: remediation edits to cross-reference-dense prose must be tightly scoped to the specific defect being closed, and paired with an attribution cross-check against the story's own edge-case/AC tables before being accepted as complete — a broad rewrite of surrounding narrative in the same edit is itself a risk factor, not merely thoroughness._
   _Codified (S-7.02 cycle-closing checklist, 2026-09-08): a draft self-improvement follow-up story, `S-PG-CROSSREF-SCOPE-DISCIPLINE`, has been opened into the existing `S-PG-*` backlog (10→11, all `draft`, pending PO BC-authorship) — see STATE.md Standing Items. Tagged **[process-gap]** because the pattern (a scoped fix inadvertently widening into an unscoped rewrite) is generic to any fix-round/adversarial-pass loop, not unique to this story, and warrants a durable discipline check rather than a one-off note._

## Content-Level

<!-- none logged yet this cycle -->

## Infrastructure-Level

<!-- none logged yet this cycle -->

## Tooling-Level

1. **[tooling-friction] The `compute-input-hash` tool's transitive-input design cascaded a single-file refresh into a multi-burst chain.** Refreshing `wave-schedule.md`'s stale `input-hash` at Burst 6 changed that file's own bytes (the frontmatter field itself), which in turn made `wave-holdout-scenarios.md`'s stored `input-hash` stale (its `inputs:` list declares `wave-schedule.md` as a dependency) — a downstream cascade not visible until Burst 6's own `--check` re-verification pass. Terminating the cascade required a dedicated Burst 7 solely to refresh the second file and re-verify all 4 F3 artifacts clean in one stable pass. Net effect: what was substantively one fix (the story's real content was frozen and untouched throughout) took 3 separate bookkeeping bursts (5, 6, 7) to fully resolve.
   _Discovered: Burst 6, 2026-09-08 (surfaced when refreshing `wave-schedule.md`); resolved Burst 7, 2026-09-08._
   _Codification: when an input-hash drift check flags MULTIPLE artifacts in a dependency chain (a file whose own inputs include another file also under refresh), refresh ALL of them together, in topological order (leaf-most dependency last), in ONE operation/burst — rather than fixing the first-flagged file, re-running `--check`, discovering the next cascade link, and repeating. This avoids the per-file cascade churn this cycle incurred and keeps a bookkeeping remediation to a single burst instead of three._
   _Codified (S-7.02 cycle-closing checklist, 2026-09-08): accepted as a lesson without opening a dedicated follow-up story — the underlying tool (`compute-input-hash`) is correct and working as designed (transitive-input tracking is a feature, not a bug); the gap is purely in HOW the orchestrator sequences its own remediation bursts when a cascade is discovered mid-check. No code or tooling change is warranted; the codification above is the durable fix, to be applied by the orchestrator/state-manager pairing on the next occurrence rather than tracked as backlog._

## Policy Candidates

<!-- Lessons that should be formalized as governance policies.
     Reference the lesson number and proposed policy scope. -->

| Lesson | Proposed Policy | Scope | Status |
|--------|----------------|-------|--------|
| Process-Level 1 | Cross-reference remediation scoping discipline | Any fix-round edit touching cross-reference-dense prose (spec/story sections with EC/AC/BC cross-references) must stay scoped to the specific defect being closed and be paired with an attribution cross-check against the story's own edge-case/AC tables before being marked complete | proposed |
| Tooling-Level 1 | Topological input-hash cascade refresh | When `compute-input-hash --check` flags a drift and the flagged artifact is itself declared as an `inputs:` dependency of another artifact, refresh the full dependency chain in one topologically-ordered operation rather than iterating file-by-file across separate bursts | proposed |
