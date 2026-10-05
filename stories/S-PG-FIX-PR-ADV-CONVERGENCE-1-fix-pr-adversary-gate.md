---
document_type: story
level: ops
story_id: "S-PG-FIX-PR-ADV-CONVERGENCE-1"
epic_id: "SELF-IMPROVEMENT"
title: "Fix-PR adversary-convergence gate in fix-pr-delivery (engine-side hand-off)"
version: "1.0"
producer: story-writer
timestamp: "2026-10-04T00:00:00"
phase: 2
cycle: none
wave: feature-followup
status: draft
intent: process-codification
feature_type: pipeline-governance
mode: feature
scope: dark-factory-engine
target_repo: "vsdd-factory (~/Documents/GITHUB/vsdd-factory, drbothen/vsdd-factory) — NOT jira-cli"
severity: LOW
trivial_scope: false
points: 5
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 2
target_module: "plugins/vsdd-factory/skills/fix-pr-delivery/SKILL.md (+ pr-manager/orchestrator references)"
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no jira-cli product BCs (engine/process tooling, hand-off story).
  # The engine repo has its own BC space (e.g. BC-5.39.001 Step-4.5 adversary
  # convergence gate, cited as the model to extend); any engine-side BC
  # authorship happens in the vsdd-factory repo, not here.
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
  - ".factory/cycles/OPEN-STANDING-ITEMS.md"
  - ".factory/cycles/cycle-014/process-gaps.md"
input-hash: "488fcfd"
traces_to: "cycle-014 process-gap #46 (F5 Pass 1 adversary observation); standing item FIX-PR-NO-ADVERSARY-CONVERGENCE; human decision D-406(c) (uncounted rehearsal pass adopted)"
spec_source: "Human F7-gate disposition of cycle-014 process-gap items (STATE.md Pending human decisions (d)). Engine-side hand-off story: implementation lives in the vsdd-factory repo. Drafted for human review; NOT approved for delivery."
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-10-04"
last_updated: "2026-10-04"
changelog:
  - "1.0 (2026-10-04): Initial draft. Hand-off story: STORY-INDEX convention PERMITS engine stories (SELF-IMPROVEMENT epic holds 8+ scope: dark-factory-engine siblings, e.g. S-PG-F5-HEADSHA-PREFLIGHT-1). Implementation repo is vsdd-factory."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
  - S-PG-F5-HEADSHA-PREFLIGHT-1
  - S-PG-FIX-SCOPE-VERIFY-1
drift_items:
  - FIX-PR-NO-ADVERSARY-CONVERGENCE
files_created: []   # engine-side; enumerated below under File Structure Requirements (paths are in the vsdd-factory repo)
files_modified: []  # none in jira-cli
---

# S-PG-FIX-PR-ADV-CONVERGENCE-1 — Fix-PR Adversary-Convergence Gate (ENGINE-SIDE HAND-OFF)

## Hand-off Note (read first)

**Target repo: `vsdd-factory` (`~/Documents/GITHUB/vsdd-factory`), NOT jira-cli.** The jira-cli
STORY-INDEX convention allows engine stories: the `SELF-IMPROVEMENT` epic already holds
`scope: dark-factory-engine` stories (precedent `S-PG-MERGE-AUTH-BYPASS`,
`S-PG-F5-HEADSHA-PREFLIGHT-1`, `S-PG-FIX-SCOPE-VERIFY-1`). This file is the jira-cli-side
tracking record; delivery happens by opening/porting this work into the engine repo under
that repo's own process. No jira-cli `src/`, `ci.yml`, or `scripts/` change results from
this story.

## Source of Truth

- Process-gap `#46` (`.factory/cycles/cycle-014/process-gaps.md`), recorded from the F5 Pass 1
  adversary observation; standing item `FIX-PR-NO-ADVERSARY-CONVERGENCE` (LOW, engine-side).
- Evidence: `FIX-P5-001` grew scope three times (`D-393`/`D-394`/`D-395`) and was delivered
  with only PR-review and security-review verdicts and no dedicated convergence artifact;
  doc/test drift (`F-001`/`F-002`) escaped until F5 Pass 1.
- Human decision `D-406(c)`: cycle-014 adopted, ad hoc, an UNCOUNTED fresh-adversary
  "rehearsal" pass before each COUNTED pass (rehearsals R13/R14 found real issues, fixed as
  FIX-P5-013). This story decides whether/how to codify an adversary gate for fix PRs
  themselves, possibly absorbing the rehearsal practice.

## Behavioral Contracts

None for jira-cli (tooling, no BC). The engine's Step-4.5 adversary-convergence gate
(`BC-5.39.001`, per the standing item) is the model; verify its current text in the engine
repo before relying on this citation.

## Narrative

As the VSDD factory operator, I want `fix-pr-delivery` to require a recorded adversary
convergence outcome for fix PRs above a defined risk threshold, so that scope-creeping or
multi-round fix PRs cannot merge on PR-review/security-review verdicts alone and leak
doc/test drift into later passes.

## Problem Statement

`fix-pr-delivery` (SKILL.md Steps 1-10) goes implementer -> PR -> pr-reviewer ->
conditional security review -> review convergence -> merge. Story PRs additionally pass the
Step-4.5 adversary convergence gate; fix PRs do not, "streamlined" by design. In cycle-014 F5,
15 fix PRs (`FIX-P5-001`..`015`) were delivered; several introduced drift caught only by later
counted passes, costing extra passes against the cap (raised 10->15 by D-403). Whether a full
adversary loop on every fix PR is worth its cost is the open design question.

## DECISION POINTS (human; story does not decide)

1. **Threshold:** gate every fix PR, only fix PRs above a size/scope-growth trigger (e.g.
   scope expanded after first dispatch, > N files, touches spec/CLAUDE.md), or advisory only.
2. **Gate shape:** (a) full Step-4.5 loop (>= 3 clean passes) per fix PR, (b) single
   uncounted rehearsal-style pass (D-406(c)) with findings fixed before merge, (c) record-only
   artifact (no blocking).
3. **Relation to cycle-level F5:** does a fix-PR rehearsal count toward, or exist separately
   from, the counted pass cap.
4. **Artifact location/format** for the fix-PR convergence record.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,800 |
| `fix-pr-delivery/SKILL.md` (188 lines) | ~2,500 |
| Step-4.5 gate text (story per-story-delivery workflow) | ~2,500 |
| cycle-014 process-gaps #46 + D-406(c) + FIX-P5-001 history | ~2,500 |
| pr-manager agent doc (convergence/merge steps) | ~3,000 |
| **Total** | **~13,300** |

Within budget; no split required.

## Previous Story Intelligence

- `S-PG-F5-HEADSHA-PREFLIGHT-1` codified an ad hoc cycle practice into a reusable engine
  workflow step — same shape as this story (rehearsal pass -> standing step).
- `S-PG-FIX-SCOPE-VERIFY-1` guards orchestrator fix instructions; overlapping surface in
  `fix-pr-delivery` Step 1 — coordinate to avoid conflicting edits.
- `S-PG-PRMANAGER-AWAIT-1` / `S-PG-REVIEW-DISTINCT-1`: pr-manager convergence-step edits;
  sequence deliveries to avoid merge conflicts in the same agent doc.

## Architecture Mapping

| Component | Location | Pure/Effectful |
|---|---|---|
| fix-pr-delivery skill step text | vsdd-factory `plugins/vsdd-factory/skills/fix-pr-delivery/SKILL.md` | N/A (workflow definition) |
| pr-manager convergence checklist | vsdd-factory `plugins/vsdd-factory/agents/pr-manager.md` | N/A (agent definition) |
| fix-PR convergence record template | vsdd-factory `plugins/vsdd-factory/templates/` | N/A (document template) |

No jira-cli module is touched.

## Purity Classification

Not applicable: no executable code in jira-cli. Engine-side changes are markdown workflow/agent/template definitions; any engine test fixtures follow the engine repo's own conventions.

## Architecture Compliance Rules

| Rule | Constraint |
|---|---|
| Information asymmetry | The adversary dispatched for a fix PR must be fresh-context, no prior-pass visibility (per the adversary agent contract). |
| Flag, never auto-fix | The gate records findings; the implementer fixes via the normal fix loop. |
| No retroactive change | Applies to fix PRs opened after the engine release carrying the change; cycle-014's merged fix PRs are not re-reviewed. |
| Engine repo conventions | Follow the vsdd-factory repo's own CLAUDE.md, BC-authoring, and release process (out of this repo's control). |

## Library & Framework Requirements

None (markdown/workflow definitions). Any new validation hook should follow the engine's
existing hook conventions; verify there.

## Forbidden Dependencies

The gate MUST NOT introduce a dependency from `fix-pr-delivery` on a project-specific
(jira-cli) path or script; it must stay target-project-agnostic.

## File Structure Requirements (paths in the vsdd-factory repo; verify at implementation)

| File | Create / Modify | Description |
|---|---|---|
| `plugins/vsdd-factory/skills/fix-pr-delivery/SKILL.md` | MODIFY | Add the adversary-convergence step between Step 7/8 and Step 9 per the chosen shape. |
| `plugins/vsdd-factory/agents/pr-manager.md` | MODIFY | Convergence checklist references the new record. |
| `plugins/vsdd-factory/templates/` (fix-PR convergence record) | CREATE | Template for the convergence artifact, if Decision 4 selects a file. |
| engine BC/test for the gate | CREATE | Per the engine repo's own conventions. |

## Acceptance Criteria

Tooling story — no BC traces (tooling, no BC); each AC traces to standing item
`FIX-PR-NO-ADVERSARY-CONVERGENCE` / process-gap #46.

- **AC-001** The human's answers to Decision Points 1-4 are recorded in the story before
  implementation (story frontmatter `changelog` entry naming the choices).
- **AC-002** `fix-pr-delivery` SKILL.md contains a numbered step stating the adversary gate:
  trigger condition, shape, who dispatches, and the blocking/non-blocking status — verifiable
  by grep for the step heading and trigger text in the engine repo.
- **AC-003** For a PR meeting the trigger, merge is not permitted by pr-manager until a
  convergence record exists with a verdict; a PR below the trigger proceeds with a recorded
  "below threshold" note. Measured by a workflow dry-run/test fixture in the engine repo.
- **AC-004** The convergence record has a defined path and fields (PR, HEAD SHA reviewed, pass
  count, findings by severity, verdict) and the HEAD SHA is checked against the PR head at merge
  (reuses the HEAD-SHA preflight idea from S-PG-F5-HEADSHA-PREFLIGHT-1).
- **AC-005** The relation to the cycle-level counted-pass cap (Decision 3) is documented in
  both fix-pr-delivery and the F5 workflow text, with no contradiction.
- **AC-006** A backtest against cycle-014's `FIX-P5-001` scope-growth history is documented
  (would the chosen trigger have fired? how many extra passes would it have cost?). Findings
  from this backtest go in the PR description, not a new report file.
- **AC-007** Engine CHANGELOG entry (under the engine's [Unreleased]) describes the new gate;
  a jira-cli follow-up note in `OPEN-STANDING-ITEMS.md` marks the standing item closed once
  the engine release containing it is adopted.

## Tasks

1. Human resolves Decision Points 1-4.
2. Port to the vsdd-factory repo (open an issue/branch there per its workflow).
3. Read current `fix-pr-delivery` SKILL.md, per-story-delivery Step 4.5, `BC-5.39.001`.
4. Draft tests/fixtures first (TDD), then edit SKILL.md / pr-manager / template.
5. Backtest (AC-006); engine CHANGELOG entry (AC-007), before creating the engine PR.
6. After engine release: update jira-cli `OPEN-STANDING-ITEMS.md` (state-manager).

## Edge Cases

| ID | Description | Expected Behavior |
|---|---|---|
| EC-001 | Fix PR scope grows mid-flight (the FIX-P5-001 pattern) | Trigger re-evaluates on each scope change; a prior "below threshold" note is invalidated. |
| EC-002 | Adversary finds issues in code unrelated to the fix | Routed as new findings, not blocking this PR unless introduced by it (document rule). |
| EC-003 | Fix PR is docs-only / comment-only (e.g. FIX-P5-010) | Threshold decides; Decision 1 should state docs-only handling explicitly. |
| EC-004 | Adversary and reviewer disagree | pr-manager triage rules apply; no new tie-break invented here. |

## Dependency Analysis

depends_on: [] — standalone. blocks: []. Soft ordering note (not a dependency): sequence
after `S-PG-FIX-SCOPE-VERIFY-1` if both are delivered, as both edit `fix-pr-delivery` Step 1/7
neighborhood.

## Out of Scope

- Re-reviewing cycle-014's already-merged fix PRs.
- Changes to cycle-level F5 pass counting rules beyond documenting the relation (Decision 3).
- Any jira-cli code, CI, or script change.
- Story-PR Step-4.5 changes.

## Story Points and Effort

5 SP: design resolution + backtest 2, SKILL/pr-manager/template edits 2, engine tests +
changelog 1. Priority P2 (LOW severity process-gap).

## References

- `.factory/cycles/OPEN-STANDING-ITEMS.md` `FIX-PR-NO-ADVERSARY-CONVERGENCE`
- `.factory/cycles/cycle-014/process-gaps.md` item #46
- STATE.md Decisions Log `D-393`/`D-394`/`D-395` (FIX-P5-001 scope growth), `D-403`, `D-406(c)`
- `~/Documents/GITHUB/vsdd-factory/plugins/vsdd-factory/skills/fix-pr-delivery/SKILL.md`
