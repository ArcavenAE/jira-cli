---
document_type: story
level: ops
story_id: "S-PG-RED-GREEN-SWEEP-1"
epic_id: "SELF-IMPROVEMENT"
title: "Mechanical pre-convergence sweep gate for stale RED/GREEN TDD comments"
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
target_module: pipeline-workflow-tdd-iron-law
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — a
  # pre-convergence gate inside the VSDD pipeline's Step-4.5 workflow — with no
  # jira-cli behavioral-contract surface. Follows the established no-BC precedent
  # for this scope category set by S-PG-MERGE-AUTH-BYPASS.
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
traces_to: ".factory/phase-f7-convergence/components-delta-convergence-report.md §6 Keep-Deferred Disposition, row RED-GREEN-STALE-COMMENT-SWEEP-MISSING"
spec_source: "F7 component-mgmt delta-convergence report §6 (producer spec-steward, 2026-08-20), human-ratified recommendation to open a follow-up story targeting the self-improvement epic, per the S-7.02 Cycle-Closing Checklist and the human's F7 final-authorization gate."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened from the F7 component-mgmt cycle §6 Keep-Deferred Disposition, item RED-GREEN-STALE-COMMENT-SWEEP-MISSING (human F7 final-authorization gate; human ratified the recommendation to open a follow-up story). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS, the only prior engine self-improvement story in this repo's STORY-INDEX). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
drift_items:
  - RED-GREEN-STALE-COMMENT-SWEEP-MISSING
files_created: []
files_modified:
  # All targets are Dark Factory engine files, NOT jr product code. Exact paths
  # TBD at implementation time based on the current engine layout (mirrors the
  # [engine] placeholder convention established by S-PG-MERGE-AUTH-BYPASS).
  - "[engine]/skills/delivery-story/SKILL.md"                # MODIFY — add a pre-convergence stale-comment sweep step before Step-4.5 dispatch
  - "[engine]/agents/implementer/AGENT.md"                    # MODIFY — add a self-check: rewrite/remove RED/GREEN markers once a test transitions from failing to passing
  - "[engine]/scripts/check-stale-red-green-comments.(sh|py)" # CREATE — mechanical scanner: flags comments matching known RED/GREEN marker shapes that no longer match the test's actual pass/fail state
  - "[engine]/docs/tdd-iron-law.md"                            # MODIFY (or equivalent doc) — document the sweep gate alongside the existing Red Gate density check
---

# S-PG-RED-GREEN-SWEEP-1 — Mechanical Pre-Convergence Sweep Gate for Stale RED/GREEN Comments

## Source of Truth

`.factory/phase-f7-convergence/components-delta-convergence-report.md` §6 Keep-Deferred
Disposition, row `RED-GREEN-STALE-COMMENT-SWEEP-MISSING` (MEDIUM), origin: "Master Drift Items
table (cycle-wide, 6th instance, F5-C-004 on `tests/component_commands.rs`)". Verbatim
description: "No mechanical pre-convergence gate exists to rewrite stale comments left behind by
red-green-refactor cycles; individual instances continue to be hand-swept as found. Directly tied
to the S-7.02 Cycle-Closing Checklist this report is executing." Recommended disposition (human
ratified at the F7 gate): "Open follow-up story targeting the self-improvement epic — build a
mechanical pre-convergence stale-comment sweep gate so this class stops recurring
instance-by-instance."

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story and populates the `behavioral_contracts:` array (S-7.01
spec-first gate). When BCs are authored they should cover:

- **Precondition:** Step-4.5 convergence dispatch for a story does not proceed to its
  diverse-lens adversary passes until the sweep gate has run against that story's touched test
  files.
- **Postcondition:** any comment matching a known RED/GREEN marker shape (e.g. `// RED:`,
  `// TODO: make this pass`, `// this currently fails because…`) whose referenced test now
  passes is flagged for rewrite or removal before the gate reports clean.
- **Invariant:** the sweep never silently deletes a comment — it flags for human/implementer
  review, since a marker's staleness with respect to test outcome is a signal, not proof the
  comment itself is worthless commentary.

## Narrative

As the VSDD pipeline's Step-4.5 convergence workflow, I want a mechanical scan that flags stale
RED/GREEN TDD-cycle comments before the diverse-lens adversary passes begin, so that this defect
class (found by hand, six separate times across this cycle alone, most recently F5-C-004 on
`tests/component_commands.rs`) stops recurring instance-by-instance and is caught structurally
instead.

## Problem Statement

The TDD Iron Law (per this engine's `tdd_mode: strict` convention) requires non-trivial function
bodies to start as `todo!()` and comments to mark the RED (failing) state during the red-green
cycle. Nothing currently re-checks those comments once the corresponding test flips from failing
to passing — they are left in place until a human or an adversary pass happens to notice the
mismatch between the comment's claim ("this currently fails") and the code's actual state
("this now passes"). The Master Drift Items table records six such instances across this cycle;
the most recent, F5-C-004, was found on `tests/component_commands.rs` during the component-mgmt
delta. Each instance was hand-swept individually rather than caught by a gate — the same
structural gap the Red Gate density check (`≥0.5` before Step-4 dispatch) already closes for the
*opposite* direction (ensuring RED markers exist before implementation begins); this story closes
the matching gap on the *green* side (ensuring RED markers are retired once the test passes).

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,200 |
| F7 delta-convergence report §6 (relevant row + surrounding context) | ~1,200 |
| Engine TDD Iron Law / Red Gate doc (reference, once located) | ~2,500 |
| Engine delivery-story skill (Step-4.5 dispatch section) | ~2,000 |
| Tool outputs (test-run grep, marker-shape survey across `tests/`) | ~1,500 |
| **Total** | **~10,400** |

Well within a single agent's context budget. No split required.

## Previous Story Intelligence

**S-PG-MERGE-AUTH-BYPASS** (draft, this repo's only prior engine self-improvement story) is the
structural precedent this story follows: `scope: dark-factory-engine`, `[engine]` placeholder
paths for files not yet located, no product BC surface, status remains `draft` pending both
engine-source access and PO BC authorship. Key lesson from that story's re-assessment
(2026-06-28, DEC-145): "good behavior this session is NOT proof of prompt codification" — a
mechanical gate is required, not reliance on the implementer noticing. This directly motivates
building a script/check rather than relying on Step-4.5 adversary passes to catch staleness by
chance (which is exactly how all six prior instances of this defect class were actually found).

**S-CIGATE-2 / S-CIGATE-3** (this repo's `ci.yml` guard family) establish the sibling pattern
for this repo: a mechanical, CI-enforced re-derivation beats hand-vigilance, and a
pattern-matching predicate over "known marker shapes" will itself need periodic hardening as new
comment shapes are discovered (the same "lexer disagrees with reality" risk documented across
`S-CIGATE-2`'s many rounds) — the scanner in this story should be scoped conservatively
(flag-for-review, never silently resolve) rather than attempt to be exhaustive on day one.

**N/A — first story targeting the pipeline's Step-4.5 dispatch sequence itself** (as opposed to
a single agent's prompt). No prior story has modified the delivery-story skill's dispatch gate
ordering.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Dark Factory engine only | Scope boundary (mirrors S-PG-MERGE-AUTH-BYPASS Rule 1) | Zero changes to `jr` product files (`src/`, `tests/`, `.github/`). This story instruments the *pipeline*, not the product. |
| Flag, never silently delete | Problem Statement | The sweep gate must never auto-delete or auto-rewrite a flagged comment. It reports the file/line/marker and blocks Step-4.5 dispatch (or emits a warning, implementer's judgment on hard-block vs. soft-warn — see AC-002) until a human or the implementer resolves it. |
| Runs before Step-4.5, not during | Origin note: "Directly tied to the S-7.02 Cycle-Closing Checklist" | The gate is a pre-convergence step, not a Step-4.5 adversary-lens responsibility — it must not duplicate or replace the diverse-lens passes; it is a cheaper, mechanical, earlier check. |
| Conservative marker-shape matching | S-CIGATE-2 lesson (lexer/pattern gaps recur) | Start with the known marker shapes observed in this cycle's six instances (documented in Task 1); do not attempt to guess at unseen shapes. Extending the shape list is expected future maintenance, not a day-one requirement. |

## Library & Framework Requirements

No new library or framework dependencies expected. The scanner is a text/regex-based scan over
test file comments (mirroring this repo's own `scripts/check-*.sh` family precedent, e.g.
`check-bc-citation-symbols.sh`) or an engine-native equivalent — implementer's choice, documented
with rationale (AC-001).

| Item | Version / Constraint |
|------|---------------------|
| Scanning tool (bash+grep, or engine-native script language) | Whichever the engine's existing `scripts/` family already uses — do not introduce a new language/runtime for this one gate |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `[engine]/scripts/check-stale-red-green-comments.(sh\|py)` | CREATE | Scans a given set of test files for known RED/GREEN marker shapes and cross-references each against the test's actual pass/fail state (via a `cargo test`-equivalent run or a provided test-result artifact). Reports flagged comments; never mutates files. |
| `[engine]/skills/delivery-story/SKILL.md` | MODIFY | Insert the sweep as a pre-convergence step, before Step-4.5 diverse-lens dispatch begins. |
| `[engine]/agents/implementer/AGENT.md` | MODIFY | Add a self-check reminder: when a test transitions RED→GREEN, retire or rewrite its RED marker comment in the same commit. |
| `[engine]/docs/tdd-iron-law.md` (or equivalent) | MODIFY | Document the new gate alongside the existing Red Gate density check, framing it as the green-side counterpart. |

**Files NOT to touch:** `src/`, `tests/*.rs` (jr product code), `.github/` (jr CI), any
`bc-*.md`/BC-INDEX surfaces.

## Acceptance Criteria

### AC-001 — Marker-shape survey and tooling-approach decision documented

The known RED/GREEN comment marker shapes are surveyed from this cycle's six recorded instances
(the Master Drift Items table) and documented, along with the chosen scanning-tool approach and
rationale. (traces to drift item RED-GREEN-STALE-COMMENT-SWEEP-MISSING — pending BC authorship)

### AC-002 — Sweep gate runs before Step-4.5 dispatch and flags stale markers

The delivery-story skill's dispatch sequence is updated so the sweep runs against the story's
touched test files before the diverse-lens adversary passes are dispatched. A flagged comment
(RED/GREEN marker whose referenced test no longer matches the claimed state) halts or warns per
the implementer's documented hard-block-vs-soft-warn decision (AC-001's tooling-approach note
must state which). (traces to drift item RED-GREEN-STALE-COMMENT-SWEEP-MISSING — pending BC
authorship)

### AC-003 — Gate never silently mutates flagged files

A test/fixture proves the gate reports flagged comments without deleting or rewriting them —
resolution remains a human/implementer action. (traces to drift item
RED-GREEN-STALE-COMMENT-SWEEP-MISSING — pending BC authorship)

### AC-004 — Documentation fallout: TDD Iron Law doc references the new gate

The engine's TDD Iron Law documentation (or equivalent) is updated to describe the sweep gate as
the green-side counterpart to the existing Red Gate density check, so future story-writers and
implementers discover it without re-deriving the rationale. (traces to drift item
RED-GREEN-STALE-COMMENT-SWEEP-MISSING — pending BC authorship)

## Tasks

1. Survey the six recorded instances of this defect class (Master Drift Items table) and extract
   the concrete comment-marker shapes observed (AC-001).
2. Decide and document the scanning-tool approach (bash/grep vs. engine-native), consistent with
   this repo's `scripts/check-*.sh` precedent family (AC-001).
3. Build `check-stale-red-green-comments` against the documented marker shapes; prove it flags a
   known-bad fixture and passes clean on a known-good one (AC-003).
4. Wire the gate into the delivery-story skill's pre-convergence sequence (AC-002).
5. Add the implementer self-check reminder (AC-002 support).
6. Update the TDD Iron Law doc (AC-004).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A comment matches a known marker shape but is intentionally left in place (e.g., documenting a known-flaky test) | The gate flags it (conservative-by-design); a human/implementer marks it reviewed-and-kept rather than the gate silently excluding it — avoids the "silent exclusion" failure shape this cycle's other process-gap items warn against. |
| EC-002 | A new, previously-unseen marker shape appears in a future story | Out of scope for day-one detection (Architecture Compliance Rules); extending the shape list is expected future maintenance, not a defect in this story. |
| EC-003 | The gate cannot determine a test's current pass/fail state (e.g., compile failure) | Hard error, distinct from "no stale comments found" — never silently pass. |

## Dependency Analysis

**depends_on: []** — standalone engine-process story; does not require any other story to land
first.

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- Any `jr` product source, test, or CI workflow change.
- Exhaustive coverage of every conceivable RED/GREEN comment phrasing — scoped to the shapes
  actually observed this cycle (AC-001); extending coverage is future maintenance.
- Automatic rewriting/deletion of flagged comments — flag-only, per Architecture Compliance
  Rules.

## Story Points and Effort

**5 story points (small).** Breakdown: marker-shape survey + tooling decision (1 SP), scanner
implementation + self-test fixtures (2 SP), pipeline wiring (1 SP), doc fallout (1 SP).
**Priority P2** — process-quality improvement, not blocking any in-flight delivery.
