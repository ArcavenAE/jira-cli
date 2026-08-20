---
document_type: story
level: ops
story_id: "S-PG-VP-CITATION-RECONCILE-1"
epic_id: "SELF-IMPROVEMENT"
title: "Reconcile PRD-delta VP citations against the verification-delta map + add a citation-consistency check"
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
severity: MEDIUM
trivial_scope: false
points: 3
priority: P2
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 1
target_module: pipeline-workflow-spec-evolution
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — a one-time
  # reconciliation of two existing spec artifacts plus a citation-consistency check
  # — with no jira-cli behavioral-contract surface. Follows the no-BC precedent set
  # by S-PG-MERGE-AUTH-BYPASS.
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
traces_to: ".factory/phase-f7-convergence/components-delta-convergence-report.md §6 Keep-Deferred Disposition, row PRD-DELTA-VP-CITATION-HANDOFF-DRIFTS-FROM-MAP"
spec_source: "F7 component-mgmt delta-convergence report §6 (producer spec-steward, 2026-08-20), human-ratified recommendation to open a follow-up story targeting the self-improvement epic, per the S-7.02 Cycle-Closing Checklist and the human's F7 final-authorization gate."
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 3
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened from the F7 component-mgmt cycle §6 Keep-Deferred Disposition, item PRD-DELTA-VP-CITATION-HANDOFF-DRIFTS-FROM-MAP (F2 carry-forward; human F7 final-authorization gate; human ratified the recommendation to open a follow-up story). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
  - S-PG-VP-REGISTRY-1
  - S-PG-DELTA-DOC-RESYNC-1
drift_items:
  - PRD-DELTA-VP-CITATION-HANDOFF-DRIFTS-FROM-MAP
files_created: []
files_modified:
  - ".factory/specs/prd-delta-components.md"                    # MODIFY (this repo) — reconcile the VP-citation list against verification-delta-components.md §3's mapping
  - "[engine]/scripts/check-vp-citation-consistency.(sh|py)"    # CREATE — mechanical check comparing a prd-delta's VP-citation list against its paired verification-delta's §3 mapping
  - "[engine]/agents/spec-steward/AGENT.md"                      # MODIFY — add VP-citation consistency to the L4 governance mandate (companion to the VP registry duty added by S-PG-VP-REGISTRY-1)
---

# S-PG-VP-CITATION-RECONCILE-1 — Reconcile PRD-Delta VP Citations Against the Verification-Delta Map

## Source of Truth

`.factory/phase-f7-convergence/components-delta-convergence-report.md` §6 Keep-Deferred
Disposition, row `PRD-DELTA-VP-CITATION-HANDOFF-DRIFTS-FROM-MAP` (MEDIUM), origin: "F2
carry-forward". Verbatim description: "`prd-delta-components.md`'s VP-citation list drifts from
`verification-delta-components.md` §3's mapping — no evidence in this cycle's artifacts that the
drift was reconciled." Recommended disposition (human ratified at the F7 gate): "Open follow-up
story targeting the self-improvement epic — reconcile the two artifacts and add a
citation-consistency check between them."

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** a `prd-delta-<bundle>.md`'s VP-citation list is checked against its paired
  `verification-delta-<bundle>.md` §3 mapping at some defined checkpoint (this story's AC-003
  determines whether that checkpoint is F2 close, F7 disposition, or both).
- **Postcondition:** any VP cited in one artifact but absent (or differently mapped) in the
  other is flagged.
- **Invariant:** the check is symmetric — it must catch drift in both directions (a VP the
  prd-delta cites but the verification-delta doesn't map, and vice versa).

## Narrative

As the spec-steward, I want the two-part handoff between `prd-delta-components.md`'s VP-citation
list and `verification-delta-components.md` §3's mapping reconciled and mechanically checked
going forward, so that this specific known drift (recorded during F2 with no evidence it was ever
resolved) is fixed for the component-mgmt bundle and does not recur silently for future bundles.

## Problem Statement

The F2 spec-evolution phase produces two related artifacts per bundle: a `prd-delta-<bundle>.md`
that lists which VPs a set of PRD changes cites, and a `verification-delta-<bundle>.md` whose §3
section maps VPs to the BCs/ACs they verify. These two artifacts are meant to describe the same
underlying VP set from two different angles (PRD-side citation vs. verification-side mapping),
but nothing currently keeps them in sync — for the component-mgmt bundle specifically, the F2
carry-forward record states the two have drifted with "no evidence in this cycle's artifacts that
the drift was reconciled." This is a concrete, still-open discrepancy in already-shipped spec
artifacts (not merely a hypothetical future risk), so this story has two parts: fix the actual
drift for component-mgmt now, and add a mechanical check so future bundles don't accumulate the
same unreconciled gap.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,600 |
| `prd-delta-components.md` (full, VP-citation list) | ~2,500 |
| `verification-delta-components.md` §3 (full mapping section) | ~2,500 |
| F7 delta-convergence report §6 (relevant row) | ~1,200 |
| **Total** | **~8,800** |

Well within budget. No split required.

## Previous Story Intelligence

**S-PG-VP-REGISTRY-1** (sibling story, same F7 disposition batch) builds a centralized VP
registry; this story's reconciliation work is a natural first data-quality input to that
registry — the implementer for whichever story lands second should check the other's output for
consistency. They are independent (`depends_on: []` for both), but should not contradict each
other's findings about component-mgmt's actual VP set.

**S-PG-DELTA-DOC-RESYNC-1** (sibling story, same batch) addresses a structurally similar
"artifact A drifts from artifact B" gap for BC-content vs. delta-doc-summary; this story is the
VP-citation analogue. As noted in that story's Previous Story Intelligence, the two checks may
share comparison-tooling infrastructure — evaluate consolidation opportunity, not required.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Fix the real drift first, then add the check | Problem Statement ("no evidence… drift was reconciled") | This story is not purely preventative — component-mgmt's actual two artifacts are already drifted and must be reconciled as part of this story, not left as a pre-existing condition for the new check to merely detect going forward. |
| Symmetric check | Behavioral Contracts invariant | The consistency check must catch drift in both directions, not just "PRD-delta cites something verification-delta lacks." |
| Flag, never silently auto-resolve conflicting mappings | General pattern (consistent with sibling stories in this batch) | If the two artifacts disagree about what a VP maps to (not just presence/absence), report the conflict for human/spec-steward resolution rather than picking one side automatically. |
| No jr product `src/` changes | Scope boundary | This story touches `.factory/specs/` artifacts and engine tooling only. |

## Library & Framework Requirements

No new dependencies. Text/markdown comparison tooling consistent with this repo's existing
`scripts/check-*.sh` family.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `.factory/specs/prd-delta-components.md` | MODIFY | Reconcile the VP-citation list against `verification-delta-components.md` §3's mapping — the actual fix for the already-shipped component-mgmt bundle's drift. |
| `[engine]/scripts/check-vp-citation-consistency.(sh\|py)` | CREATE | Mechanically compares a `prd-delta-<bundle>.md`'s VP-citation list against its paired `verification-delta-<bundle>.md` §3 mapping; symmetric, flags both directions. |
| `[engine]/agents/spec-steward/AGENT.md` | MODIFY | Add VP-citation consistency to the L4 governance mandate, alongside the VP registry duty from `S-PG-VP-REGISTRY-1`. |

## Acceptance Criteria

### AC-001 — Component-mgmt's actual drift is identified and documented

The specific discrepancies between `prd-delta-components.md`'s VP-citation list and
`verification-delta-components.md` §3's mapping are enumerated (which VPs are cited in one but
not correctly reflected in the other). (traces to drift item
PRD-DELTA-VP-CITATION-HANDOFF-DRIFTS-FROM-MAP — pending BC authorship)

### AC-002 — Component-mgmt's two artifacts are reconciled

`prd-delta-components.md` is corrected so its VP-citation list matches
`verification-delta-components.md` §3's mapping (or, if the verification-delta side is the one
that is stale, that file is corrected instead — whichever direction the AC-001 investigation
determines is the actual source of truth, documented explicitly). (traces to drift item
PRD-DELTA-VP-CITATION-HANDOFF-DRIFTS-FROM-MAP — pending BC authorship)

### AC-003 — Symmetric consistency check built and wired into the F2 checkpoint

`check-vp-citation-consistency` is built, proven against a known-bad fixture (both drift
directions), and wired into the F2 spec-evolution workflow at a documented checkpoint so future
bundles cannot silently accumulate the same drift. (traces to drift item
PRD-DELTA-VP-CITATION-HANDOFF-DRIFTS-FROM-MAP — pending BC authorship)

## Tasks

1. Diff `prd-delta-components.md`'s VP-citation list against `verification-delta-components.md`
   §3's mapping; enumerate every discrepancy (AC-001).
2. Determine, per discrepancy, which artifact is stale and correct it (AC-002).
3. Build and fixture-test the symmetric `check-vp-citation-consistency` check (AC-003).
4. Wire the check into the F2 workflow at a documented checkpoint (AC-003).
5. Update the spec-steward agent definition (AC-003 support).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A VP is legitimately cited in the prd-delta but intentionally not yet mapped in the verification-delta (VP authored, verification pending) | The check should distinguish "not yet mapped, in progress" from "silently dropped" if the artifacts carry any status marker for this; if no such marker exists, flag conservatively and let a human disposition it. |
| EC-002 | The two artifacts disagree about what a shared VP maps to (not just presence/absence) | Flag as a conflict for human resolution, per Architecture Compliance Rules — do not auto-pick one side. |
| EC-003 | A future bundle's `prd-delta`/`verification-delta` pair uses non-standard section numbering (§3 renamed or renumbered) | The check should locate the VP-mapping section by content/heading match where feasible, and hard-error (not silently skip) if it cannot confidently locate the mapping section. |

## Dependency Analysis

**depends_on: []** — standalone; the AC-001/AC-002 reconciliation work does not require any
other story in this batch, though tooling-sharing with `S-PG-DELTA-DOC-RESYNC-1` should be
evaluated during implementation.

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- Reconciling any bundle other than component-mgmt's `prd-delta`/`verification-delta` pair —
  scoped to the specific drift named in the F7 disposition; other bundles are covered
  prospectively by the new check, not retroactively audited by this story.
- Any jr `src/` production code change.

## Story Points and Effort

**3 story points (xsmall).** Breakdown: drift diff + documentation (0.5 SP), reconciliation edit
(0.5 SP), consistency-check implementation + fixtures (1.5 SP), workflow wiring + doc fallout
(0.5 SP). **Priority P2.**
