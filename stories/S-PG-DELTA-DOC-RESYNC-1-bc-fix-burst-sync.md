---
document_type: story
level: ops
story_id: "S-PG-DELTA-DOC-RESYNC-1"
epic_id: "SELF-IMPROVEMENT"
title: "Mechanical resync gate between mid-review BC edits and their phase delta docs"
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
points: 5
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 1.5
target_module: pipeline-workflow-spec-evolution
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — a
  # mechanical resync check inside the F2 spec-evolution workflow — with no
  # jira-cli behavioral-contract surface. Follows the no-BC precedent set by
  # S-PG-MERGE-AUTH-BYPASS.
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
traces_to: ".factory/phase-f7-convergence/components-delta-convergence-report.md §6 Keep-Deferred Disposition, row DELTA-DOC-RESYNC-NOT-ENFORCED-ON-BC-FIX-BURST"
spec_source: "F7 component-mgmt delta-convergence report §6 (producer spec-steward, 2026-08-20), human-ratified recommendation to open a follow-up story targeting the self-improvement epic, per the S-7.02 Cycle-Closing Checklist and the human's F7 final-authorization gate."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened from the F7 component-mgmt cycle §6 Keep-Deferred Disposition, item DELTA-DOC-RESYNC-NOT-ENFORCED-ON-BC-FIX-BURST (F2 carry-forward, ~4 instances observed this bundle's F2; human F7 final-authorization gate; human ratified the recommendation to open a follow-up story). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
  - S-PG-VP-CITATION-RECONCILE-1
drift_items:
  - DELTA-DOC-RESYNC-NOT-ENFORCED-ON-BC-FIX-BURST
files_created: []
files_modified:
  - "[engine]/skills/phase-f2-spec-evolution/SKILL.md"      # MODIFY — add a resync check step after any BC edit made mid-review
  - "[engine]/agents/product-owner/AGENT.md"                 # MODIFY — add a self-check: when amending a BC mid-review, also check whether the phase's delta doc needs a matching update
  - "[engine]/scripts/check-delta-doc-resync.(sh|py)"        # CREATE — mechanical check comparing a BC file's last-modified content against its cited phase delta doc for staleness signals
---

# S-PG-DELTA-DOC-RESYNC-1 — Mechanical Resync Gate Between BC Edits and Phase Delta Docs

## Source of Truth

`.factory/phase-f7-convergence/components-delta-convergence-report.md` §6 Keep-Deferred
Disposition, row `DELTA-DOC-RESYNC-NOT-ENFORCED-ON-BC-FIX-BURST` (MEDIUM), origin: "F2 (~4
instances)". Verbatim description: "The corresponding phase delta doc is not auto-resynced when
a BC is edited mid-review, observed ~4x during this bundle's F2." Recommended disposition (human
ratified at the F7 gate): "Open follow-up story targeting the self-improvement epic — add a
mechanical resync check/gate between BC edits and their phase delta docs."

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** a BC file edit made during an active F2 spec-evolution review round
  triggers a check against that BC's cited phase delta doc.
- **Postcondition:** if the delta doc's summary of the BC (wording, clause count, or example
  text) no longer matches the BC file's current content, the check flags the specific mismatch
  for the product-owner to resolve before the review round closes.
- **Invariant:** the check never auto-edits the delta doc — resync is a human/product-owner
  action; the gate only detects and reports staleness.

## Narrative

As the F2 spec-evolution workflow, I want a mechanical check that flags a phase delta doc as
stale whenever the BC it summarizes is edited mid-review, so that the ~4 instances of this drift
observed during the component-mgmt bundle's own F2 round stop recurring silently and are caught
before the round closes.

## Problem Statement

During F2 (spec evolution), behavioral contracts sometimes need mid-review amendment — a
product-owner corrects wording, adds a clause, or fixes an error-taxonomy code after an
adversarial pass finds an issue. The phase's delta doc (e.g. `prd-delta-<bundle>.md`) typically
contains its own prose summary or excerpt of the affected BC, authored at the time the delta doc
was first written. When the BC is edited afterward, nothing re-checks whether the delta doc's
summary still matches — the component-mgmt bundle's own F2 round observed this drift roughly 4
times, each caught only because a human or adversary pass happened to cross-reference the two
documents by hand. This is architecturally similar to `RED-GREEN-STALE-COMMENT-SWEEP-MISSING`
and `LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT`: a downstream artifact's claim silently
outlives the upstream source-of-truth it was derived from.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,800 |
| F7 delta-convergence report §6 (relevant row) | ~1,200 |
| Component-mgmt F2 round artifacts (concrete drift examples, once located) | ~3,000 |
| Engine F2 spec-evolution skill + product-owner agent definition | ~3,500 |
| **Total** | **~10,500** |

Well within budget. No split required.

## Previous Story Intelligence

**S-PG-RED-GREEN-SWEEP-1** and **S-PG-VERBATIM-PIN-1** (sibling stories, same F7 disposition
batch) establish this batch's shared pattern: a downstream artifact (a comment, a test assertion,
a delta doc) drifts silently from its upstream source of truth (a test's pass/fail state, a BC's
exact wording, a BC's content). This story is the third instance of that same shape, applied to
delta docs specifically — the fix pattern (mechanical detection, flag-not-auto-fix, wired into
the relevant pipeline phase) should stay consistent across all three for maintainability.

**S-PG-VP-CITATION-RECONCILE-1** (sibling story, same batch) is closely related but distinct: that
story addresses VP-citation drift between `prd-delta-*.md` and `verification-delta-*.md`
specifically, while this story addresses BC-content drift between a BC file and its citing phase
delta doc more generally. The two checks may end up sharing tooling infrastructure (both are
"does artifact A still match what artifact B claims about it" checks) — flag this as a possible
consolidation opportunity for the implementer to evaluate, not a requirement.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Flag, never auto-resync | Behavioral Contracts invariant | The gate detects and reports; a human/product-owner performs the actual resync edit. Mirrors the same rule in `S-PG-RED-GREEN-SWEEP-1`. |
| Runs during F2, at BC-edit time | Origin: "observed ~4x during this bundle's F2" | The check belongs in the F2 spec-evolution workflow specifically, triggered by a BC file edit during an active review round — not a one-off end-of-cycle sweep. |
| Conservative staleness signal, not exact-diff enforcement | Problem Statement | A delta doc's prose summary is not expected to be a byte-identical mirror of the BC — the check should flag likely staleness signals (e.g., a cited clause number, an error code, or a quoted phrase that no longer appears verbatim in the BC) rather than demand full-text equality, to avoid false positives on legitimate paraphrasing. |
| No jr product `src/` changes | Scope boundary | This story adds a pipeline-workflow check, not jr product code. |

## Library & Framework Requirements

No new dependencies. Text-comparison tooling consistent with this repo's existing
`scripts/check-*.sh` family.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `[engine]/skills/phase-f2-spec-evolution/SKILL.md` | MODIFY | Add the resync check as a step triggered by any BC file edit during an active F2 review round. |
| `[engine]/agents/product-owner/AGENT.md` | MODIFY | Add a self-check: when amending a BC mid-review, also check whether the phase delta doc needs an update, and prompt for it. |
| `[engine]/scripts/check-delta-doc-resync.(sh\|py)` | CREATE | Compares a BC file's cited clauses/quoted phrases against its phase delta doc's summary; flags likely-stale summaries. |

## Acceptance Criteria

### AC-001 — Concrete drift examples surveyed from component-mgmt's F2 round

The ~4 instances of delta-doc staleness observed during this bundle's F2 round are located and
documented as concrete before/after examples, informing the check's design. (traces to drift
item DELTA-DOC-RESYNC-NOT-ENFORCED-ON-BC-FIX-BURST — pending BC authorship)

### AC-002 — Resync check triggers on mid-review BC edits

The F2 spec-evolution workflow runs the resync check whenever a BC file is edited during an
active review round, comparing it against the BC's cited phase delta doc(s). (traces to drift
item DELTA-DOC-RESYNC-NOT-ENFORCED-ON-BC-FIX-BURST — pending BC authorship)

### AC-003 — Check flags staleness without auto-editing

A fixture proves the check reports a specific staleness signal (e.g., a quoted phrase from the
delta doc no longer found verbatim in the BC) without modifying the delta doc itself. (traces to
drift item DELTA-DOC-RESYNC-NOT-ENFORCED-ON-BC-FIX-BURST — pending BC authorship)

### AC-004 — Product-owner agent definition documents the resync obligation

The product-owner agent definition states that amending a BC mid-review requires checking the
phase delta doc for a matching update, with the mechanical check as a backstop, not a substitute
for this awareness. (traces to drift item DELTA-DOC-RESYNC-NOT-ENFORCED-ON-BC-FIX-BURST —
pending BC authorship)

## Tasks

1. Locate and document the ~4 real drift instances from component-mgmt's F2 round (AC-001).
2. Design the staleness-signal heuristic (quoted-phrase / clause-number comparison), evaluating
   possible tooling overlap with `S-PG-VP-CITATION-RECONCILE-1` (AC-002).
3. Build and fixture-test `check-delta-doc-resync` (AC-003).
4. Wire the check into the F2 spec-evolution workflow, triggered on BC edits (AC-002).
5. Update the product-owner agent definition (AC-004).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A BC edit is purely cosmetic (typo fix, formatting) with no semantic change | The heuristic should avoid flagging pure whitespace/formatting diffs as staleness — scope the comparison to semantic content (quoted phrases, clause text, error codes), not raw byte diff. |
| EC-002 | A delta doc deliberately paraphrases rather than quotes the BC | Flag only when a previously-quoted phrase or cited clause number diverges — paraphrased summaries with no direct quotation are lower-confidence signals and may be excluded from day-one scope (implementer's documented judgment call). |
| EC-003 | A BC is edited outside an active F2 review round (e.g., a later F5/F7 amendment) | Out of scope for this story's trigger condition — this story is scoped to the F2 mid-review case specifically, per the origin note. A later-phase BC amendment triggering the same check is a possible future extension, not required here. |

## Dependency Analysis

**depends_on: []** — standalone; does not require any other story in this batch to land first,
though implementation should evaluate tooling overlap with `S-PG-VP-CITATION-RECONCILE-1`.

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- Extending the check to BC amendments made outside an active F2 round (EC-003).
- Retroactively resyncing any already-stale delta doc found in this repo's `.factory/` tree —
  flagged for human action, not auto-fixed by this story.
- Any jr `src/` production code change.

## Story Points and Effort

**5 story points (small).** Breakdown: drift-example survey (1 SP), heuristic design (1.5 SP),
check implementation + fixtures (1.5 SP), workflow wiring + doc fallout (1 SP). **Priority P2.**
