---
document_type: story
level: ops
story_id: "S-PG-REVIEW-DISTINCT-1"
epic_id: "SELF-IMPROVEMENT"
title: "Fix or document validate-pr-review-posted's assumption of a distinct (non-same-account) reviewer"
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
target_module: pipeline-workflow-pr-merge-validation
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — a
  # same-account review/approval handling fix (or an explicit documented
  # human-in-the-loop step) inside the pr-merge validation hook — with no
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
traces_to: ".factory/phase-f7-convergence/components-delta-convergence-report.md §6 Keep-Deferred Disposition, row VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER"
spec_source: "F7 component-mgmt delta-convergence report §6 (producer spec-steward, 2026-08-20), human-ratified recommendation to open a follow-up story targeting the self-improvement epic, per the S-7.02 Cycle-Closing Checklist and the human's F7 final-authorization gate."
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened from the F7 component-mgmt cycle §6 Keep-Deferred Disposition, item VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER (S-604-3, fifth+ consecutive occurrence this cycle; human F7 final-authorization gate; human ratified the recommendation to open a follow-up story). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS, whose own DEC-128/DEC-145 history documents the same-account tool-permission classifier as an existing, load-bearing merge-authorization control — this story addresses the review-posting side of that same boundary). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
  - S-PG-PRMANAGER-AWAIT-1
drift_items:
  - VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER
files_created: []
files_modified:
  - "[engine]/hooks/validate-pr-merge-prerequisites.(sh|py)"   # MODIFY — the `validate-pr-review-posted` check's same-account assumption; add same-account-aware handling OR an explicit documented human-in-the-loop bypass path
  - "[engine]/docs/merge-authorization-contract.md"            # MODIFY (companion doc from S-PG-MERGE-AUTH-BYPASS, if landed) — cross-reference the same-account review-posting boundary alongside the existing merge-authorization boundary
---

# S-PG-REVIEW-DISTINCT-1 — Fix or Document the Same-Account Reviewer Assumption in validate-pr-review-posted

## Source of Truth

`.factory/phase-f7-convergence/components-delta-convergence-report.md` §6 Keep-Deferred
Disposition, row `VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER` (LOW), origin: "S-604-3
(fifth+ consecutive occurrence)". Verbatim description: "The same-account tool-permission
classifier blocks self-approval, forcing a human to complete the squash-merge manually every
time; recurred on every story this cycle." Recommended disposition (human ratified at the F7
gate): "Open follow-up story targeting the self-improvement epic — engine-level fix for
same-account review/approval handling, or an explicit documented human-in-the-loop step if
that's the intended design." STATE.md's own delivery narrative corroborates this as a recurring,
already-observed pattern across this cycle (e.g. the S-605-1/S-604-2/S-604-3 delivery records
each cite DEC-284/285/289/290-style precedent: "the `gh pr merge` call was denied by the
same-account tool-permission classifier... human completed the squash-merge on GitHub directly").

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** `validate-pr-review-posted` (or the wider `validate-pr-merge-prerequisites`
  hook family) is invoked with knowledge of whether the review-posting account and the
  merge-executing account are the same identity.
- **Postcondition:** either (a) the check's logic accounts for the same-account case with a
  defined, non-surprising outcome, or (b) the check's same-account limitation is explicitly
  documented as an intended human-in-the-loop boundary, with a clear message explaining why a
  human must complete the action manually — not a generic/confusing failure.
- **Invariant:** whichever disposition is chosen (fix vs. document), it must be applied
  consistently — not left as an undocumented assumption a human has to rediscover by hitting the
  wall every single story, as has happened on every story this cycle.

## Narrative

As a delivery sub-agent (or the human operator standing in for it) attempting to complete a PR's
merge, I want the same-account reviewer/approval boundary in `validate-pr-review-posted` to be
either fixed or clearly, permanently documented, so that this does not have to be manually worked
around and re-explained on every single story this cycle (5+ consecutive occurrences), each time
requiring the human to step in and complete the squash-merge on GitHub directly.

## Problem Statement

GitHub's own branch-protection semantics generally disallow a PR author from approving their own
PR (a same-account self-approval restriction). This engine's automated delivery agents operate
under a single GitHub identity for both authoring and any review-posting/merge steps they
perform, so `validate-pr-review-posted` (part of the `validate-pr-merge-prerequisites` hook
family) consistently finds itself unable to satisfy a same-account review requirement — and this
has recurred on every story delivered this cycle (component-mgmt's S-604-1 through S-608-1 all
required a human to complete the squash-merge manually, per DEC-283 through DEC-292's repeated
"same-account tool-permission classifier" notes in STATE.md). This is currently handled
correctly in the *safety* sense (the classifier fails closed, denying self-approval rather than
silently bypassing it — see S-PG-MERGE-AUTH-BYPASS's DEC-145 re-assessment, which notes this as
one of the engine's real defense-in-depth controls), but it is *not yet a deliberate, documented*
design decision — it currently reads as an unaddressed assumption baked into the check's logic
rather than an intentional human-in-the-loop step, per the F7 disposition's own framing.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,800 |
| F7 delta-convergence report §6 (relevant row) | ~1,200 |
| STATE.md DEC-283..292 same-account precedent notes (already cited in this cycle's delivery records) | ~2,000 |
| Engine `validate-pr-review-posted` / `validate-pr-merge-prerequisites` hook source (once located) | ~3,000 |
| S-PG-MERGE-AUTH-BYPASS (cross-reference — related merge-authorization boundary) | ~2,500 |
| **Total** | **~11,500** |

Well within budget. No split required.

## Previous Story Intelligence

**S-PG-MERGE-AUTH-BYPASS** is the directly related prior story: its 2026-06-28 re-assessment
(DEC-145) explicitly names "the same-account tool-permission classifier" as an existing, working
defense-in-depth control ("behavioral evidence is encouraging — pr-manager held at merge on PRs
#566 and #567 this session, refusing even orchestrator-relayed authorization"). This story does
NOT propose weakening or bypassing that control — the classifier correctly fails closed. This
story's scope is narrower and different: deciding and documenting (or, if genuinely fixable
without weakening the safety property, fixing) what `validate-pr-review-posted` specifically
should do when it detects the same-account condition, so the outcome is a clear, expected,
documented step rather than a recurring surprise each story requires a human to manually resolve.

**Every component-mgmt story's DEC-28x/29x precedent notes** (DEC-283 through DEC-292, cited
verbatim in STATE.md's per-story merge burst narratives) are the concrete recurrence evidence —
5+ consecutive instances, each independently confirming the same root cause and the same
human-completes-manually resolution.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Do not weaken the same-account fail-closed safety property | S-PG-MERGE-AUTH-BYPASS DEC-145 precedent | Whatever this story does, it must not make it easier for a delivery agent to self-approve/self-merge without a human step — that would reopen the exact PG-MERGE-AUTH-BYPASS-class risk. A "fix" here means clarity and non-surprising behavior, not bypassing the boundary. |
| Two acceptable dispositions, both explicit | Recommended disposition (verbatim: "engine-level fix... or an explicit documented human-in-the-loop step if that's the intended design") | The implementer must choose and document one of: (a) a genuine fix that changes the check's behavior in the same-account case (e.g., a distinct, non-generic message explaining the human handoff is expected, rather than a confusing denial), or (b) an explicit statement in the engine's docs that this is permanent, intended human-in-the-loop design, with no further engine-side change needed beyond documentation. Silently doing nothing is not an acceptable outcome — the F7 gate explicitly asked for one or the other. |
| Dark Factory engine only | Scope boundary (mirrors S-PG-MERGE-AUTH-BYPASS Rule 1) | Zero changes to `jr` product files. |

## Library & Framework Requirements

Not applicable. This story modifies an engine hook/check and its documentation. No Rust crates,
no Cargo.toml changes, no GitHub Actions changes.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `[engine]/hooks/validate-pr-merge-prerequisites.(sh\|py)` | MODIFY | Update the `validate-pr-review-posted` check's same-account handling per the AC-002 disposition decision — either behavior change or, at minimum, a clearer message. |
| `[engine]/docs/merge-authorization-contract.md` (companion doc from S-PG-MERGE-AUTH-BYPASS, if that story has landed by implementation time) | MODIFY | Cross-reference this same-account review-posting boundary alongside the existing merge-authorization boundary, so both documented human-in-the-loop points live in one discoverable place. |

## Acceptance Criteria

### AC-001 — Recurrence evidence consolidated from this cycle's DEC-28x/29x notes

The 5+ consecutive occurrences (component-mgmt's own stories, each citing the same-account
tool-permission classifier per DEC-283 through DEC-292 in STATE.md) are consolidated into one
documented account confirming this is a systemic, not per-story, condition. (traces to drift item
VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER — pending BC authorship)

### AC-002 — Explicit disposition decision recorded: fix vs. documented human-in-the-loop

A decision is made and documented: either the check's same-account behavior is changed (with the
new behavior specified), or it is explicitly declared permanent intended design with a
human-in-the-loop step — not left undecided. (traces to drift item
VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER — pending BC authorship)

### AC-003 — Whichever disposition is chosen, the safety property is preserved

Whatever change is made (if any), a same-account delivery agent still cannot self-approve/
self-merge without the documented human step — the fail-closed property from
S-PG-MERGE-AUTH-BYPASS's DEC-145 is not weakened. (traces to drift item
VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER — pending BC authorship)

### AC-004 — Message/documentation clarity: a delivery agent hitting this condition gets an unambiguous, expected outcome

If the disposition is "documented human-in-the-loop" (AC-002 option b), the check's output
message is updated (if it is not already) to clearly state that a human must complete the
merge, rather than reading as an unexplained denial — closing the "recurring surprise" framing
from the Problem Statement. (traces to drift item
VALIDATE-PR-REVIEW-POSTED-ASSUMES-DISTINCT-REVIEWER — pending BC authorship)

## Tasks

1. Consolidate the DEC-283..292 recurrence evidence from STATE.md into one account (AC-001).
2. Locate the `validate-pr-review-posted` check / `validate-pr-merge-prerequisites` hook source.
3. Decide the disposition (fix vs. documented human-in-the-loop) in consultation with the
   existing S-PG-MERGE-AUTH-BYPASS precedent and its DEC-145 safety-property constraint (AC-002).
4. Implement the chosen disposition — behavior change and/or message/doc clarity (AC-003, AC-004).
5. Cross-reference the merge-authorization-contract doc if it exists (companion to
   S-PG-MERGE-AUTH-BYPASS).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A future engine configuration genuinely uses a distinct reviewer account (not the same-account case this story addresses) | The check's original distinct-reviewer logic path must remain correct and untouched — this story only addresses the same-account branch. |
| EC-002 | The chosen disposition is "fix" and the fix itself has a gap (e.g., misdetects same-account in an edge configuration) | Treated as a new, separate finding to raise (not silently absorbed into declaring the fix complete) — same "flag, don't paper over" discipline as this batch's other stories. |
| EC-003 | A human is not immediately available to complete the manual merge step (documented-human-in-the-loop disposition) | Out of scope for this story — this story does not change delivery cadence or add async-approval tooling; it only ensures the condition and required next step are clear when it occurs. |

## Dependency Analysis

**depends_on: []** — standalone; does not require any other story in this batch, though the
implementer should check whether `S-PG-PRMANAGER-AWAIT-1` and `S-PG-MERGE-AUTH-BYPASS` have
landed, for doc cross-referencing convenience (not a hard blocking dependency).

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- Introducing a second GitHub identity/bot account to work around the same-account restriction —
  a larger infrastructure change, not evaluated or recommended by this story.
- Weakening the same-account fail-closed safety property in any way (Architecture Compliance
  Rules).
- Any jr `src/` production code change.

## Story Points and Effort

**3 story points (xsmall).** Breakdown: recurrence-evidence consolidation (0.5 SP), disposition
decision (1 SP), implementation (fix and/or message/doc clarity) (1 SP), cross-reference doc
update (0.5 SP). **Priority P3** — the human-completes-manually workaround is holding every
time, so this is not blocking any in-flight delivery, but the 5+ occurrence rate this cycle
argues for scheduling it reasonably soon, alongside its sibling `S-PG-PRMANAGER-AWAIT-1`.
