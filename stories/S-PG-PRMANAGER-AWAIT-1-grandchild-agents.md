---
document_type: story
level: ops
story_id: "S-PG-PRMANAGER-AWAIT-1"
epic_id: "SELF-IMPROVEMENT"
title: "Fix pr-manager returning BLOCKED without awaiting its spawned grandchild review agents"
version: "1.0"
producer: story-writer
timestamp: "2026-08-20T00:00:00"
phase: 2
cycle: none
wave: feature-followup
status: draft
intent: process-codification
feature_type: pipeline-governance
mode: feature
scope: dark-factory-engine
severity: LOW
trivial_scope: false
points: 3
priority: P3
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 1
target_module: pipeline-workflow-pr-manager
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — a
  # pr-manager agent-behavior fix — with no jira-cli behavioral-contract surface.
  # Follows the no-BC precedent set by S-PG-MERGE-AUTH-BYPASS.
  []
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F7-delta-convergence
inputs:
  - ".factory/STATE.md"
  - ".factory/phase-f7-convergence/components-delta-convergence-report.md"
input-hash: "c3fc19a"
traces_to: ".factory/phase-f7-convergence/components-delta-convergence-report.md §6 Keep-Deferred Disposition, row PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN"
spec_source: "F7 component-mgmt delta-convergence report §6 (producer spec-steward, 2026-08-20), human-ratified recommendation to open a follow-up story targeting the self-improvement epic, per the S-7.02 Cycle-Closing Checklist and the human's F7 final-authorization gate."
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened from the F7 component-mgmt cycle §6 Keep-Deferred Disposition, item PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN (S-604-3, fifth+ occurrence this cycle alone; human F7 final-authorization gate; human ratified the recommendation to open a follow-up story). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
drift_items:
  - PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN
files_created: []
files_modified:
  - "[engine]/agents/pr-manager/AGENT.md"           # MODIFY — fix the stall condition: pr-manager must actually await its spawned security-reviewer + pr-reviewer subagents (grandchildren of the orchestrator) rather than returning BLOCKED prematurely
  - "[engine]/workflows/orchestrator-per-story-delivery.md"  # MODIFY (if needed) — remove/replace the orchestrator's current direct-dispatch workaround once the underlying stall is fixed
---

# S-PG-PRMANAGER-AWAIT-1 — Fix pr-manager Returning BLOCKED Without Awaiting Grandchild Agents

## Source of Truth

`.factory/phase-f7-convergence/components-delta-convergence-report.md` §6 Keep-Deferred
Disposition, row `PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN` (LOW), origin:
"S-604-3 (fifth+ occurrence)". Verbatim description: "pr-manager's spawned security-reviewer +
pr-reviewer subagents stalled; the orchestrator worked around it by dispatching both reviewers
directly. Recurred across 5+ stories this cycle alone." Recommended disposition (human ratified
at the F7 gate): "Open follow-up story targeting the self-improvement epic — engine-level
pr-manager fix; the workaround is holding but the underlying stall condition is unaddressed."

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** when pr-manager spawns security-reviewer and/or pr-reviewer subagents (its
  "grandchildren" from the orchestrator's perspective), it does not report a terminal status
  (e.g. BLOCKED) until it has actually received and processed their results.
- **Postcondition:** pr-manager's returned status accurately reflects the state of its spawned
  reviewer subagents — never a premature BLOCKED report issued before those subagents have
  completed or genuinely failed.
- **Invariant:** the orchestrator's direct-dispatch workaround (dispatching both reviewers
  itself, bypassing pr-manager) remains necessary only until this fix lands; the workaround is
  not a substitute for fixing pr-manager's own await logic.

## Narrative

As the orchestrator delegating PR review coordination to pr-manager, I want pr-manager to
correctly await the security-reviewer and pr-reviewer subagents it spawns, so that I no longer
need to work around a stall by dispatching both reviewers directly — a workaround applied on 5+
stories this cycle alone (most recently S-604-3), holding as a mitigation but not fixing the
underlying defect in pr-manager itself.

## Problem Statement

pr-manager is designed to spawn security-reviewer and pr-reviewer as sub-agents ("grandchildren"
from the orchestrator's vantage point) and coordinate their findings before reporting a terminal
status back to the orchestrator. In practice, across at least 5 stories this cycle
(component-mgmt's own S-604-3 being the fifth-plus occurrence), pr-manager has instead returned
BLOCKED without having actually awaited those spawned subagents' completion — the orchestrator
has consistently worked around this by dispatching security-reviewer and pr-reviewer directly
itself, bypassing pr-manager's intended coordination role. This workaround is holding (reviews
still happen, PRs still get reviewed), but it defeats the purpose of having pr-manager coordinate
the review lifecycle at all, and the recurrence rate (5+ times, not a one-off) indicates a
structural defect in pr-manager's spawn/await logic rather than an environmental fluke.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,600 |
| F7 delta-convergence report §6 (relevant row) | ~1,200 |
| S-604-3 delivery narrative (concrete stall instance, once located in STATE.md/burst-log) | ~2,000 |
| Engine pr-manager agent definition (once located) | ~3,000 |
| **Total** | **~8,800** |

Well within budget. No split required.

## Previous Story Intelligence

**S-PG-MERGE-AUTH-BYPASS** establishes the precedent that pr-manager's behavior gaps in this
engine are addressed via direct edits to its agent definition (`AGENT.md`), with the same
"codify explicitly, don't rely on the agent inferring correct behavior" discipline. This story's
fix is a sibling gap in the same agent: that story fixed *merge* over-eagerness (pr-manager
self-authorizing when it should wait); this story fixes *review-await* under-eagerness
(pr-manager reporting terminal status before it should wait for its own spawned subagents). Both
are instances of pr-manager's lifecycle-state tracking being unreliable around subagent
boundaries.

**Every component-mgmt story this cycle** (S-604-1 through S-608-1, 7 stories) is a candidate
source for concrete stall evidence — the implementer should pull the specific dispatch/response
sequence from at least S-604-3's delivery record (named as the fifth+ occurrence) to ground the
fix in an actual observed failure rather than a hypothetical one.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Fix the underlying await logic, not just document the workaround | Recommended disposition ("engine-level pr-manager fix; the workaround is holding but the underlying stall condition is unaddressed") | This story must change pr-manager's actual spawn/await behavior, not merely codify the orchestrator's workaround as permanent policy. |
| Orchestrator workaround remains as a fallback until verified fixed | Behavioral Contracts invariant | Do not remove the orchestrator's direct-dispatch fallback until this fix has been validated against a real story delivery — removing the safety net prematurely would reopen the exact stall this story exists to close. |
| Dark Factory engine only | Scope boundary (mirrors S-PG-MERGE-AUTH-BYPASS Rule 1) | Zero changes to `jr` product files. |

## Library & Framework Requirements

Not applicable. This story modifies an agent definition and (conditionally) an orchestrator
workflow doc. No Rust crates, no Cargo.toml changes.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `[engine]/agents/pr-manager/AGENT.md` | MODIFY | Fix the spawn/await logic so pr-manager actually blocks on its spawned security-reviewer + pr-reviewer subagents' completion before reporting a terminal status. |
| `[engine]/workflows/orchestrator-per-story-delivery.md` | MODIFY (conditional) | Once the fix is validated, either retire the direct-dispatch workaround or explicitly document it as a permanent defense-in-depth fallback (implementer's judgment, documented either way — see AC-004). |

## Acceptance Criteria

### AC-001 — Concrete stall instance documented from S-604-3 (or another cycle occurrence)

At least one specific, real instance of pr-manager returning BLOCKED without awaiting its
spawned subagents is documented (dispatch sequence, what pr-manager reported, what the
orchestrator's workaround did instead). (traces to drift item
PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN — pending BC authorship)

### AC-002 — pr-manager's agent definition is fixed to correctly await spawned subagents

The pr-manager agent definition is updated so it does not report a terminal status (BLOCKED or
otherwise) until it has genuinely received results from any security-reviewer/pr-reviewer
subagents it spawned. (traces to drift item
PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN — pending BC authorship)

### AC-003 — Fix is validated against a real (or realistic simulated) delivery sequence

The fix is exercised against at least one real or faithfully-reconstructed story-delivery
sequence (ideally the one documented in AC-001) and confirmed to no longer stall. (traces to
drift item PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN — pending BC authorship)

### AC-004 — Workaround disposition is explicit, not silently dropped or silently kept

A documented decision states whether the orchestrator's direct-dispatch workaround is retired
now that the underlying fix is validated, or intentionally retained as defense-in-depth — either
is acceptable, but the decision must be explicit and recorded. (traces to drift item
PR-MANAGER-RETURNS-BLOCKED-WITHOUT-AWAITING-GRANDCHILDREN — pending BC authorship)

## Tasks

1. Locate and document the concrete S-604-3 stall instance (or the clearest available occurrence
   among the 5+ this cycle) (AC-001).
2. Diagnose the root cause in pr-manager's spawn/await logic.
3. Fix the agent definition (AC-002).
4. Validate against the documented instance or a faithful reconstruction (AC-003).
5. Decide and document the workaround's disposition (AC-004).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A spawned reviewer subagent genuinely fails (crashes, errors) rather than merely being slow | pr-manager's fixed await logic must distinguish "genuinely failed" from "not yet responded" and report BLOCKED only for the former — this is the correctness bar the original bug violated (reporting BLOCKED for the latter). |
| EC-002 | Both security-reviewer and pr-reviewer are spawned but only one has responded when a timeout/poll-check fires | The fix must not report a terminal status based on a partial response set unless there is an explicit, bounded timeout policy — if such a policy exists elsewhere in this engine (per the "never unbounded poll loops" convention already codified for pr-manager, see S-PG-MERGE-AUTH-BYPASS's DEC-145 re-assessment Constraint 4), reuse it rather than inventing a new one. |
| EC-003 | The orchestrator's workaround itself has side effects (e.g., different review-request formatting than pr-manager would have used) | Document any such divergence discovered during AC-001's investigation — it may be relevant to AC-004's disposition decision. |

## Dependency Analysis

**depends_on: []** — standalone; does not require any other story in this batch.

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- Redesigning pr-manager's overall review-coordination architecture — this is a targeted fix to
  the specific await/stall defect, not a rewrite.
- Any jr `src/` production code change.

## Story Points and Effort

**3 story points (xsmall).** Breakdown: instance documentation + diagnosis (1 SP), agent
definition fix (1 SP), validation + workaround-disposition decision (1 SP). **Priority P3** —
the orchestrator's workaround is holding, so this is not blocking any in-flight delivery, but the
5+ occurrence rate this cycle alone argues for scheduling it reasonably soon.
