---
document_type: story
level: ops
story_id: "S-PG-FIX-SCOPE-VERIFY-1"
epic_id: "SELF-IMPROVEMENT"
title: "Scope-and-verify guard for orchestrator-issued fix instructions (prevent fix-caused regressions)"
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
target_module: pipeline-workflow-orchestrator-dispatch
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — an
  # orchestrator dispatch-time design pass and guard rule — with no jira-cli
  # behavioral-contract surface. Follows the no-BC precedent set by
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
traces_to: ".factory/phase-f7-convergence/components-delta-convergence-report.md §6 Keep-Deferred Disposition, row ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION"
spec_source: "F7 component-mgmt delta-convergence report §6 (producer spec-steward, 2026-08-20), human-ratified recommendation to open a follow-up story targeting the self-improvement epic, per the S-7.02 Cycle-Closing Checklist and the human's F7 final-authorization gate."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened from the F7 component-mgmt cycle §6 Keep-Deferred Disposition, item ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION (S-605-1 Step-4.5, recurred as a 3-round fix-chain R3→R4→R5→R6; human F7 final-authorization gate; human ratified the recommendation to open a follow-up story). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
drift_items:
  - ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION
files_created: []
files_modified:
  - "[engine]/workflows/orchestrator-per-story-delivery.md"   # MODIFY — add a "show full combination matrix" guard rule before dispatching a fix instruction into a matching/identity code path
  - "[engine]/agents/orchestrator/AGENT.md"                    # MODIFY (or equivalent orchestrator prompt surface) — codify the scope-and-verify discipline for fix instructions
  - "[engine]/docs/fix-instruction-scoping-contract.md"        # CREATE — document the guard rule, the motivating R3→R4→R5→R6 case, and when a fix instruction requires a full combination-matrix review before dispatch
---

# S-PG-FIX-SCOPE-VERIFY-1 — Scope-and-Verify Guard for Orchestrator-Issued Fix Instructions

## Source of Truth

`.factory/phase-f7-convergence/components-delta-convergence-report.md` §6 Keep-Deferred
Disposition, row `ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION` (MEDIUM), origin: "S-605-1
Step-4.5 (recurred as a 3-round fix-chain, R3→R4→R5→R6)". Verbatim description: "An
orchestrator-issued fix instruction itself introduced a regression that took 3 further rounds to
resolve; the general rule (how fix instructions should be scoped/verified before dispatch)
remains undecided." Recommended disposition (human ratified at the F7 gate): "Open follow-up
story targeting the self-improvement epic — this is a recurring engine-level process gap, not
specific to component-mgmt, and merits a dedicated design pass." STATE.md's account of the
underlying S-605-1 R3→R4→R5→R6 chain additionally frames the needed fix as a "show full
combination matrix" guard rule for fix instructions dispatched into a matching/identity code
path (R5's `ComponentRef`-collapse refactor introduced the R6 regression — a name-remove silently
no-op'd against live id-bearing components — which then required a further round to fix
definitively via a full RMW identity-matching test matrix).

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** before the orchestrator dispatches a fix instruction that targets a
  matching/identity code path (e.g., "match by X" logic, resolver dispatch, RMW identity
  comparison), the dispatch includes or requires the implementer to enumerate the full
  combination matrix of inputs the change affects (e.g., id-present × name-present ×
  add/remove × single/bulk).
- **Postcondition:** a fix instruction dispatched into such a path is verified against that full
  matrix before being reported as resolved, not merely against the one failing case the fix
  instruction was written to address.
- **Invariant:** a fix instruction is never dispatched as a bare instruction with no scoping
  context when it targets a matching/identity code path — the orchestrator's dispatch prompt
  itself carries the combination-matrix requirement forward to the implementer.

## Narrative

As the orchestrator dispatching fix instructions during Step-4.5 convergence, I want a
scope-and-verify guard rule for fix instructions that target matching/identity code paths, so
that a fix targeting one specific failing case does not itself introduce a regression in an
adjacent case within that same combination space — the way S-605-1's R5 fix (a
`ComponentRef`-collapse refactor) silently broke name-based removal against live id-bearing
components, requiring three further rounds (R4 was itself the fix for a different regression,
R6 caught the R5 regression, and R6's own fix required the full RMW combination-matrix test
suite to close definitively).

## Problem Statement

During S-605-1's Step-4.5 convergence window, a chain of fix rounds (R3→R4→R5→R6) illustrates a
recurring failure mode: an orchestrator-issued fix instruction, scoped narrowly to resolve one
adversary-found defect, altered code shared across a wider combination space than the fix
instruction accounted for — and the alteration itself introduced a *new* regression, only caught
by the *next* adversary round rather than by the fix's own verification. Specifically: R3 fixed a
numeric-`--component` wiring bug; R4 fixed an RMW name-fallback duplicate-data-loss bug; R5's fix
(a `ComponentRef`-collapse refactor) inadvertently made name-based component removal silently
no-op against live id-bearing components — a regression not present before R5's fix and not
caught until R6's adversary pass. R6's fix required building a full RMW identity-matching test
matrix (match by id OR name against the embedded `Component`) to close the class definitively,
rather than patching the one symptom. This recurring shape — "the fix instruction itself became
the next round's defect" — is a process gap in how the orchestrator scopes and verifies fix
instructions before dispatch, not a one-off implementer mistake specific to S-605-1.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,200 |
| F7 delta-convergence report §6 (relevant row) | ~1,200 |
| S-605-1 Step-4.5 R3–R6 fix-round history (STATE.md narrative + PR #712 commits) | ~4,500 |
| Engine orchestrator-per-story-delivery workflow (once located) | ~4,000 |
| **Total** | **~12,900** |

Well within budget. No split required.

## Previous Story Intelligence

**S-PG-MERGE-AUTH-BYPASS** establishes this repo's precedent for codifying an orchestrator-level
discipline as an explicit, machine-readable dispatch-prompt requirement rather than relying on
"the orchestrator will remember to be careful" — that story's key lesson ("do NOT auto-merge in a
conversational context does not constitute a durable machine-readable constraint... must be
codified as a required field in the dispatch payload") applies directly here: the
combination-matrix requirement must be a required, visible part of the fix-instruction dispatch,
not an implicit expectation.

**S-604-3's real bug (R7, global `--project` + `--all-projects` clap-guard gap)** and **S-605-1's
own earlier rounds (R1 dry-run/live parity, R4 RMW fallback)** are further examples, within this
same cycle, of fixes targeting a narrow symptom in a path that had a wider combination space than
initially scoped — this story's guard rule should be evaluated against those cases too as
corroborating (not just motivating) evidence, since a fix-chain-of-length-1 (R7 fixed cleanly,
no regression) versus a fix-chain-of-length-3 (R3→R4→R5→R6) suggests the risk is proportional to
how "identity/matching"-shaped the affected code path is — informing where this story's guard
rule should trigger (AC-002).

**N/A — first story targeting the orchestrator's fix-instruction dispatch mechanics
specifically** (as opposed to its merge-authorization mechanics, covered by
S-PG-MERGE-AUTH-BYPASS).

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Guard triggers on matching/identity-shaped code paths specifically | STATE.md's own framing ("show full combination matrix" guard rule) + S-605-1's actual case (id-vs-name matching, RMW identity comparison) | The guard should not require a full combination matrix for every fix instruction — only ones that touch matching/identity/dispatch logic where multiple input dimensions combine (id×name, single×bulk, add×remove, etc.). Scope this explicitly (AC-002) rather than making it a blanket requirement that would slow down unrelated narrow fixes. |
| Codified as a dispatch-prompt requirement, not a convention only | S-PG-MERGE-AUTH-BYPASS lesson (verbatim, reused here) | The combination-matrix requirement must appear as an explicit field or checklist item in the orchestrator's fix-dispatch prompt template, not merely documented in a doc nobody re-reads mid-round. |
| Verification against the matrix happens before the fix is reported resolved | Behavioral Contracts postcondition | The guard is not satisfied merely by *listing* the combination matrix — the fix instruction's resolution report must state which matrix cells were verified. |
| Dark Factory engine only | Scope boundary (mirrors S-PG-MERGE-AUTH-BYPASS Rule 1) | Zero changes to `jr` product files. |

## Library & Framework Requirements

Not applicable. This story modifies orchestrator workflow documentation and dispatch-prompt
templates only. No Rust crates, no Cargo.toml changes.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `[engine]/workflows/orchestrator-per-story-delivery.md` | MODIFY | Add the "show full combination matrix" guard rule as a required step before dispatching a fix instruction into a matching/identity-shaped code path. |
| `[engine]/agents/orchestrator/AGENT.md` (or equivalent orchestrator prompt surface) | MODIFY | Codify the scope-and-verify discipline: a fix-dispatch prompt targeting matching/identity logic must include the combination matrix and require the implementer to confirm each cell. |
| `[engine]/docs/fix-instruction-scoping-contract.md` | CREATE | Document the guard rule, the motivating S-605-1 R3→R4→R5→R6 case (with the specific regression: R5's `ComponentRef`-collapse refactor silently broke name-based removal against live id-bearing components), and the trigger criteria for when the matrix requirement applies. |

**Files NOT to modify:** `src/`, `tests/`, `.github/` (jr product code) — zero product changes.

## Acceptance Criteria

### AC-001 — S-605-1's R3→R4→R5→R6 chain documented as the motivating case

The contract doc includes the specific chain of events: R3's numeric-id fix, R4's RMW
name-fallback fix, R5's `ComponentRef`-collapse refactor (which introduced the regression), R6's
catch (name-remove silently no-op'd against live id-bearing components), and R6's actual fix (a
full RMW identity-matching test matrix, matching by id-OR-name against the embedded
`Component`). (traces to drift item ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION — pending BC
authorship)

### AC-002 — Trigger criteria for the combination-matrix requirement are explicit, not blanket

The guard rule states concretely which kinds of fix instructions require a combination matrix
(matching/identity/dispatch-logic changes touching ≥2 independent input dimensions) versus which
do not (narrow, single-dimension fixes), avoiding an unscoped blanket requirement that would slow
every fix instruction regardless of risk shape. (traces to drift item
ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION — pending BC authorship)

### AC-003 — Guard rule is codified in the dispatch-prompt template, not only in prose docs

The orchestrator's fix-dispatch mechanism (workflow doc and/or agent prompt) includes an
explicit, checkable requirement — not merely a documentation note — that a matching-scoped fix
instruction's dispatch payload includes the combination matrix. (traces to drift item
ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION — pending BC authorship)

### AC-004 — Resolution report must state which matrix cells were verified

The fix-instruction resolution reporting convention requires the implementer to state which
combination-matrix cells were exercised/verified before the fix is considered closed — closing
the specific gap that let R5's fix be reported resolved without the id-vs-name removal case
having been checked. (traces to drift item ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION —
pending BC authorship)

## Tasks

1. Pull the full S-605-1 R3→R4→R5→R6 commit/finding history from STATE.md and PR #712 to
   document the motivating case precisely (AC-001).
2. Design the trigger criteria distinguishing matching/identity-shaped fixes from narrow ones
   (AC-002), cross-checking against S-604-3's R7 (no chain) and S-605-1's R1/R4 (shorter chains)
   as corroborating data points.
3. Update the orchestrator workflow doc and dispatch-prompt template to require the combination
   matrix on qualifying fix instructions (AC-003).
4. Update the resolution-reporting convention to require stating which matrix cells were
   verified (AC-004).
5. Write the contract doc consolidating all of the above (AC-001–AC-004).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A fix instruction is narrowly scoped (e.g., a single off-by-one in a message string) and does not touch matching/identity logic | The guard does not trigger — AC-002's explicit trigger criteria prevent unnecessary overhead on genuinely narrow fixes. |
| EC-002 | The implementer cannot enumerate the full combination matrix because the affected dimension count is unclear at dispatch time | The dispatch prompt should require the implementer to state the matrix explicitly as a first step of the fix, not assume the orchestrator pre-computed it — this shifts the "am I missing a dimension" risk to a documented, reviewable step rather than an implicit assumption. |
| EC-003 | A future fix-chain recurs despite this guard (the guard rule itself has a gap) | Treated the same way S-CIGATE-2's rounds treat lexer gaps: document the new gap, harden the trigger criteria, do not treat one recurrence as proof the guard is worthless — this is explicitly a design-pass story, not a claim of a complete, closed-form solution. |

## Dependency Analysis

**depends_on: []** — standalone; does not require any other story in this batch.

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- A fully automated static-analysis tool that detects "matching/identity-shaped" code changes —
  this story is a process/dispatch-prompt design pass, not a code-analysis tool build.
- Retroactively re-verifying every past fix instruction in this repo's history against the new
  guard.
- Any jr `src/` production code change.

## Story Points and Effort

**5 story points (small).** Breakdown: motivating-case documentation (1 SP), trigger-criteria
design (1.5 SP), dispatch-prompt + workflow-doc updates (1.5 SP), contract doc (1 SP).
**Priority P2.**
