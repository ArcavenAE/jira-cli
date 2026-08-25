---
document_type: story
level: ops
story_id: "S-PG-F5-HEADSHA-PREFLIGHT-1"
epic_id: "SELF-IMPROVEMENT"
title: "Codify HEAD-SHA/worktree-identity preflight into cycle-level F5 dispatch"
version: "1.0"
producer: story-writer
timestamp: "2026-08-24T00:00:00"
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
estimated_effort: small
estimated_days: 1
target_module: pipeline-workflow-f5-scoped-adversarial
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — a
  # standing HEAD-SHA/worktree-identity preflight step inside the cycle-level
  # F5 (combined-delta) adversarial dispatch workflow — with no jira-cli
  # behavioral-contract surface. Follows the no-BC precedent set by
  # S-PG-MERGE-AUTH-BYPASS and its 8 SELF-IMPROVEMENT sibling stories.
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
  - ".factory/phase-f7-delta-convergence/list-read-ergonomics/delta-convergence-report.md"
input-hash: "6949e71"
traces_to: ".factory/phase-f7-delta-convergence/list-read-ergonomics/delta-convergence-report.md §4 Keep-Deferred Disposition (S-7.02), row F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT"
spec_source: "F7 list-read-ergonomics delta-convergence report §4 (producer: orchestrator F7 delta-convergence synthesis, timestamp 2026-08-24), human-granted F7 final-authorization gate directing follow-up stories be opened for the S-7.02 deferred process-gaps, anchored to the SELF-IMPROVEMENT epic per the human's explicit instruction."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-24"
last_updated: "2026-08-24"
changelog:
  - "1.0 (2026-08-24): Initial draft — opened from the F7 list-read-ergonomics delta-convergence report §4 Keep-Deferred Disposition, item F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT (process-gap; human F7 final-authorization gate; human directed follow-up stories be opened for the S-7.02 deferred process-gaps). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS and its 8 sibling stories). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
  - S-PG-DELTA-DOC-RESYNC-1
  - S-PG-FIX-SCOPE-VERIFY-1
drift_items:
  - F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT
files_created: []
files_modified:
  # All targets are Dark Factory engine files, NOT jr product code. Exact
  # paths TBD at implementation time based on the current engine layout
  # (mirrors the [engine] placeholder convention established by
  # S-PG-MERGE-AUTH-BYPASS and its 8 sibling stories).
  - "[engine]/skills/phase-f5-scoped-adversarial/SKILL.md"       # MODIFY — add a standing HEAD-SHA + working-tree-clean preflight step before dispatching read-only reviewers, for the cycle-level (combined-delta) dispatch path specifically
  - "[engine]/workflows/orchestrator-per-story-delivery.md"      # POSSIBLE MODIFY — confirm/cross-check the existing per-story worktree-identity tuple pattern this story generalizes from
  - "[engine]/docs/f5-worktree-identity-preflight.md"            # CREATE — codify the HEAD-SHA/working-tree-clean preflight contract (what is checked, when, and how a mismatch is handled) for reuse by cycle-level and future dispatch paths
---

# S-PG-F5-HEADSHA-PREFLIGHT-1 — Codify HEAD-SHA/Worktree-Identity Preflight Into Cycle-Level F5 Dispatch

## Source of Truth

`.factory/phase-f7-delta-convergence/list-read-ergonomics/delta-convergence-report.md` §4
Keep-Deferred Disposition (S-7.02), row `F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT`
(process-gap). Verbatim description: "Cycle-level F5 adversarial dispatch aimed read-only
reviewers at a checkout that could go stale between dispatch and review (observed as a risk
during this cycle's Round 1/Round 2 F5 execution); mitigated ad hoc this cycle by embedding a
HEAD-SHA preflight check into the dispatch prompt, but the mitigation is not yet codified into
the reusable F5 workflow/skill itself." Recommended disposition: "Open a self-improvement
follow-up story to add the HEAD-SHA preflight as a standing step in
`vsdd-factory:phase-f5-scoped-adversarial` (or its cycle-level analogue), so future cycles get
it by default rather than by ad hoc reviewer discipline. Not blocking — this cycle's F5 rounds
are independently confirmed to have run against the correct SHAs (Round 1 baseline
`67c5a6d0`→`748247e3`; Round 2 re-verification at `28596274`, both cited explicitly in the F5
records)."

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** a cycle-level (combined-delta) F5 adversarial dispatch is about to hand a
  read-only reviewer a checkout/worktree to review.
- **Postcondition:** the dispatch verifies `working-tree HEAD == target SHA` (and that the
  working tree is clean) immediately before dispatching each read-only reviewer; on a mismatch,
  the dispatch halts and either re-syncs the checkout or re-dispatches with the corrected SHA,
  rather than allowing a reviewer to run against a stale checkout.
- **Invariant:** the preflight is a standing step in the reusable F5 workflow/skill definition
  itself, not a one-off addition to a single dispatch prompt — so every future cycle-level F5
  round gets it automatically, not by ad hoc reviewer discipline.

## Narrative

As the cycle-level (combined-delta) F5 adversarial-review dispatch step, I want a standing
HEAD-SHA and working-tree-clean preflight check before handing a checkout to a read-only
reviewer, so that a stale checkout between dispatch and review — which this cycle's Round 1/
Round 2 F5 execution risked and had to catch and mitigate ad hoc — is prevented by default in
every future cycle, not only when a human or reviewer happens to notice and improvise a fix.

## Problem Statement

During this cycle's (`list-read-ergonomics`) F5 phase, the first cycle-level (combined-delta)
adversarial dispatch aimed read-only reviewers at a MAIN checkout that was stale relative to the
pre-cycle baseline — the relevant merges lived on `origin/develop`, but the local `develop`
branch had not been fast-forwarded to match. All 3 review passes correctly HALTED on
worktree-identity mismatch rather than emit false findings against the wrong code — a good
outcome, but one that depended on those passes individually detecting the problem. It was
mitigated ad hoc this cycle by fast-forwarding the local checkout and then embedding an explicit
HEAD-SHA preflight instruction into the re-dispatch prompt (confirmed: Round 1 baseline
`67c5a6d0`→`748247e3`; Round 2 re-verification at `28596274`). That mitigation lives only in this
cycle's dispatch prompts, not in the reusable `vsdd-factory:phase-f5-scoped-adversarial`
workflow/skill or its cycle-level (combined-delta) analogue — so the next cycle's F5 round starts
from zero on this exact risk. Notably, the **per-story** F5 delivery flow already embeds a
worktree-identity tuple check (per `orchestrator-per-story-delivery`); the **combined-delta**
(cycle-level) path is the one missing this standing check, which this story closes.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,700 |
| F7 list-read-ergonomics delta-convergence report §4 (relevant row) | ~900 |
| This cycle's F5 dispatch records (Round 1/Round 2, HEAD-SHA mitigation prompts) | ~2,500 |
| `vsdd-factory:phase-f5-scoped-adversarial` skill + `orchestrator-per-story-delivery` workflow (once located in the engine repo) | ~4,000 |
| **Total** | **~10,100** |

Well within budget. No split required.

## Previous Story Intelligence

**S-PG-FIX-SCOPE-VERIFY-1** (sibling story, F7 component-mgmt disposition batch) established a
related pattern in this epic: a scope-and-verify guard for orchestrator-issued fix instructions,
to prevent fix-caused regressions from an unverified assumption about what code a fix actually
touches. This story is analogous but for review *dispatch* rather than fix *instructions*: both
are about verifying an assumption (what code is being acted on / reviewed) mechanically instead
of trusting it implicitly. The implementer should check whether `S-PG-FIX-SCOPE-VERIFY-1`'s
eventual design (once implemented) shares any reusable verification-tooling shape with this
story's HEAD-SHA preflight.

**S-PG-DELTA-DOC-RESYNC-1** and other siblings establish this epic's shared "flag, never
auto-fix" convention for engine-process guards — this story's preflight follows the same rule:
it halts/flags on mismatch, it does not silently force a resync or guess which SHA was intended.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Standing step in the reusable workflow, not a one-off prompt addition | Behavioral Contracts postcondition | The preflight must live in `[engine]/skills/phase-f5-scoped-adversarial/SKILL.md` (or its cycle-level analogue) itself, so it applies automatically to every future cycle-level F5 dispatch without a human re-adding it to a prompt each time. |
| Halt on mismatch, never silently proceed or silently re-sync | Problem Statement ("All 3 passes correctly HALTED") | Preserve the behavior that already worked this cycle — a mismatch stops the dispatch pipeline for human/orchestrator resolution, rather than the reviewer running (and potentially emitting false findings) against the wrong checkout. |
| Generalize, don't duplicate, the existing per-story worktree-identity tuple | Problem Statement | The per-story F5 delivery flow already has an equivalent check (per `orchestrator-per-story-delivery`); this story's design should reuse or closely mirror that existing tuple/check shape for the cycle-level path, not invent an unrelated mechanism. |
| No jr product `src/` changes | Scope boundary | This story adds a pipeline-workflow/skill check, not jr product code. |

## Library & Framework Requirements

No new dependencies. Standard `git rev-parse HEAD` / `git status --porcelain` (or engine
tooling's existing equivalent) is sufficient for the SHA and clean-tree checks — consistent with
whatever mechanism the existing per-story worktree-identity tuple already uses.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `[engine]/skills/phase-f5-scoped-adversarial/SKILL.md` | MODIFY | Add the HEAD-SHA + working-tree-clean preflight as a standing step before dispatching read-only reviewers, scoped to (at minimum) the cycle-level combined-delta dispatch path. |
| `[engine]/workflows/orchestrator-per-story-delivery.md` | POSSIBLE MODIFY | Cross-check against the existing per-story worktree-identity tuple this story generalizes from; update only if a shared helper/reference is introduced. |
| `[engine]/docs/f5-worktree-identity-preflight.md` | CREATE | Document the preflight contract: what is checked (HEAD SHA, working-tree cleanliness), when (immediately before each read-only reviewer dispatch), and the halt/report behavior on mismatch. |

## Acceptance Criteria

### AC-001 — Preflight step is added to the cycle-level F5 dispatch workflow

`vsdd-factory:phase-f5-scoped-adversarial` (or its cycle-level/combined-delta analogue) contains
a standing step verifying `working-tree HEAD == target SHA` before each read-only reviewer
dispatch. (traces to drift item F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT — pending BC
authorship)

### AC-002 — Mismatch halts dispatch rather than proceeding

A fixture/dry-run proves that when the working tree's HEAD does not match the intended target
SHA (or the tree is not clean), the dispatch halts and reports the mismatch instead of
dispatching a reviewer. (traces to drift item F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT
— pending BC authorship)

### AC-003 — Preflight contract is documented for reuse

`[engine]/docs/f5-worktree-identity-preflight.md` documents the check's contract so future
dispatch paths (not just this cycle's combined-delta path) can adopt it consistently. (traces to
drift item F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT — pending BC authorship)

### AC-004 — No regression to the existing per-story worktree-identity check

The per-story F5 delivery flow's existing worktree-identity tuple check continues to function
unchanged; this story's change is additive to the cycle-level path only. (traces to drift item
F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT — pending BC authorship)

## Tasks

1. Locate and read the current `vsdd-factory:phase-f5-scoped-adversarial` skill definition and
   the `orchestrator-per-story-delivery` workflow's existing worktree-identity tuple check in
   the engine repo (AC-001, AC-004).
2. Design the cycle-level (combined-delta) preflight step, reusing the per-story check's shape
   where practical (AC-001, AC-004).
3. Add the standing preflight step to the skill/workflow definition, with halt-on-mismatch
   behavior (AC-001, AC-002).
4. Fixture/dry-run the halt behavior (AC-002).
5. Write `f5-worktree-identity-preflight.md` documenting the contract (AC-003).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | The working tree is at the correct SHA but has uncommitted changes | Treated as a mismatch condition (per Behavioral Contracts postcondition, "working-tree HEAD == target SHA AND clean") — halt, do not dispatch. |
| EC-002 | The checkout goes stale *during* a review round (after dispatch, before the reviewer finishes), not only before dispatch | Out of scope for this story's minimum bar (the F7 report frames the risk as "between dispatch and review," i.e. a pre-dispatch check) — a mid-review staleness detector is a possible future extension, not required here. |
| EC-003 | A legitimate mid-cycle fast-forward of `develop` happens intentionally between F5 rounds | The preflight should compare against the *current intended target SHA* (which the orchestrator updates when it deliberately re-syncs), not a stale hard-coded SHA from an earlier round — implementer confirms the target-SHA source is always freshly resolved, not cached. |

## Dependency Analysis

**depends_on: []** — standalone; does not require any other story in this batch to land first,
though implementation should cross-check `S-PG-FIX-SCOPE-VERIFY-1`'s eventual design for shared
verification-tooling opportunities.

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- Mid-review staleness detection (EC-002) — pre-dispatch preflight only.
- Any change to the per-story F5 delivery flow's existing worktree-identity check beyond
  confirming it as a reference pattern (AC-004 is a non-regression check, not a redesign).
- Any jr product `src/` code change.

## Story Points and Effort

**3 story points (small, per the F7 disposition's low-effort/"codify an already-proven ad hoc
mitigation" characterization).** Breakdown: existing-check review + design (1 SP), skill/workflow
edit + halt-behavior fixture (1.5 SP), preflight-contract doc (0.5 SP). **Priority P2.**
