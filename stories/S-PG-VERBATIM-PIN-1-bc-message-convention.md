---
document_type: story
level: ops
story_id: "S-PG-VERBATIM-PIN-1"
epic_id: "SELF-IMPROVEMENT"
title: "Verbatim-pin test convention for BC-specified exact strings (close loose-contains drift class)"
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
target_module: pipeline-workflow-test-writer
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — a test-writer
  # convention plus an optional repo-side lint — with no jira-cli behavioral-contract
  # surface of its own. Follows the no-BC precedent set by S-PG-MERGE-AUTH-BYPASS.
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
traces_to: ".factory/phase-f7-convergence/components-delta-convergence-report.md §6 Keep-Deferred Disposition, row LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT"
spec_source: "F7 component-mgmt delta-convergence report §6 (producer spec-steward, 2026-08-20), human-ratified recommendation to open a follow-up story targeting the self-improvement epic, per the S-7.02 Cycle-Closing Checklist and the human's F7 final-authorization gate."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened from the F7 component-mgmt cycle §6 Keep-Deferred Disposition, item LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT (human F7 final-authorization gate; human ratified the recommendation to open a follow-up story). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
  - S-PG-RED-GREEN-SWEEP-1
drift_items:
  - LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT
files_created: []
files_modified:
  - "[engine]/agents/test-writer/AGENT.md"     # MODIFY — add a convention requiring exact-string/exact-JSON-shape assertions when a BC postcondition specifies verbatim text
  - "[engine]/skills/writing-skills/SKILL.md"  # MODIFY (or equivalent) — document the verbatim-pin convention with a positive/negative example pair
  - "scripts/check-verbatim-pin-convention.sh"  # CREATE (jr repo side, optional enforcement layer) — grep-based lint flagging contains()/contains_key() near a BC-citation comment referencing an exact-message postcondition
---

# S-PG-VERBATIM-PIN-1 — Verbatim-Pin Test Convention for BC-Specified Exact Strings

## Source of Truth

`.factory/phase-f7-convergence/components-delta-convergence-report.md` §6 Keep-Deferred
Disposition, row `LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT` (MEDIUM), origin: "S-604-2
Step-4.5 (7+ instances: F-02/F-03/F-05/B-01/B-02/P3-LOW-1/AC-013)". Verbatim description: "Loose
`contains`/`contains_key` assertions on BC-specified EXACT message strings/JSON shapes let
implementer output drift from spec while tests stayed green. Sibling of
RED-GREEN-STALE-COMMENT-SWEEP-MISSING." Recommended disposition (human ratified at the F7 gate):
"Open follow-up story targeting the self-improvement epic — establish and enforce a verbatim-pin
test convention for BC-specified exact strings."

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** when a BC postcondition specifies an exact message string, error code, or
  JSON shape, the test-writer generates an assertion that pins the exact value — not a substring
  or key-presence check.
- **Postcondition:** a test asserting a BC-specified exact string uses `assert_eq!` (or
  equivalent exact-match) against the full expected value, not `.contains(...)` /
  `.contains_key(...)` against a fragment.
- **Invariant:** a `.contains()`-shaped assertion is permitted only when the BC itself specifies
  substring/partial matching as the intended behavior (documented exception, not a default).

## Narrative

As the test-writer agent generating TDD test suites from behavioral contracts, I want a
documented, enforced convention that BC-specified exact strings are pinned with exact-match
assertions rather than loose `contains`/`contains_key` checks, so that an implementer's output
can drift from the BC's literal wording while the test suite stays green — a defect class that
recurred at least 7 times in a single story's Step-4.5 window (S-604-2: F-02/F-03/F-05/B-01/B-02/
P3-LOW-1/AC-013).

## Problem Statement

`.contains()` and `.contains_key()` are useful for genuinely partial-match assertions, but when
used against a BC postcondition that specifies an *exact* string (an error message, a JSON key
set, a CLI hint) they create a masking effect: the test passes as long as the actual output
contains the expected fragment somewhere, even if surrounding text has drifted from the BC's
literal wording, the JSON shape gained or lost unrelated keys, or the exact phrasing an operator
or downstream `jq` script depends on has silently changed. S-604-2's Step-4.5 window alone found
seven instances of this shape (F-02, F-03, F-05, B-01, B-02, P3-LOW-1, AC-013) — each an
individual adversary catch, not a systemic prevention. This is the sibling defect class to
`RED-GREEN-STALE-COMMENT-SWEEP-MISSING`: both are cases where a test's green status conceals a
drift between what the spec says and what the code actually does.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,000 |
| F7 delta-convergence report §6 (relevant row) | ~1,200 |
| S-604-2 Step-4.5 findings (F-02/F-03/F-05/B-01/B-02/P3-LOW-1/AC-013, for concrete examples) | ~3,000 |
| Engine test-writer agent definition (once located) | ~3,000 |
| jr repo CLAUDE.md test-naming-convention cross-reference | ~500 |
| **Total** | **~10,700** |

Well within budget. No split required.

## Previous Story Intelligence

**S-PG-RED-GREEN-SWEEP-1** (sibling story, same F7 disposition batch) addresses the RED/GREEN
comment staleness class; this story addresses the verbatim-message-drift class. Both are
"test stayed green while output drifted from spec" shapes — the engine-side fix pattern (agent
prompt convention + optional mechanical lint) should stay consistent between the two so future
maintainers recognize the pattern.

**jr repo precedent (CLAUDE.md "Test naming convention"):** this repo already has a convention
of this general shape — `docs/specs/test-naming-convention.md` defines `test_<verb>_<subject>_
<expected_outcome>()` naming and states existing tests are not renamed for style alone, but a
name asserting a guarantee its body doesn't check is a defect. The verbatim-pin convention this
story establishes is the assertion-body analogue of that naming convention: a `contains()` check
next to a BC-citation comment claiming an exact postcondition is the same shape of "claim vs.
body" mismatch.

**S-604-2's actual findings** (F-02/F-03/F-05/B-01/B-02/P3-LOW-1/AC-013) are the concrete
worked examples this story's convention doc should cite — the implementer at story-authoring
time should pull the specific before/after diffs from that story's Step-4.5 fix-burst commits as
the positive/negative example pair required by AC-002.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Convention lives in the test-writer agent definition, not only in a lint | Problem Statement | The primary fix is upstream — the test-writer generates exact-match assertions from the start. A repo-side lint (jr's `scripts/`) is a secondary backstop, not the primary mechanism, mirroring this repo's existing `scripts/check-*.sh` family shape without over-relying on it. |
| Documented exception path required | Behavioral Contracts invariant | The convention must explicitly allow `.contains()` when the BC itself specifies partial/substring matching — a blanket ban would create false positives against legitimate partial-match BCs. |
| No jr product `src/` changes | Scope boundary | This story adds a convention (engine) and, optionally, a new lint script (jr `scripts/`) — it does not touch `src/`. Any existing `.contains()` assertions found by the new lint are flagged, not auto-rewritten by this story. |

## Library & Framework Requirements

No new dependencies. The optional jr-side lint follows the existing `scripts/check-*.sh`
grep/awk-based family (e.g. `check-bc-citation-symbols.sh`).

| Item | Version / Constraint |
|------|---------------------|
| Lint tooling | bash + grep, matching the existing `scripts/` family — no new language/runtime |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `[engine]/agents/test-writer/AGENT.md` | MODIFY | Add the verbatim-pin convention: BC-specified exact strings/JSON shapes get exact-match assertions; `.contains()` only for BC-specified partial matches. |
| `[engine]/skills/writing-skills/SKILL.md` (or nearest equivalent) | MODIFY | Document the convention with a positive (exact-match) and negative (loose-contains masking a drift) example pair, drawn from S-604-2's real findings. |
| `scripts/check-verbatim-pin-convention.sh` | CREATE (jr repo, optional backstop) | Flags `.contains(`/`.contains_key(` occurrences within N lines of a `// traces to BC-` or `// BC-S.SS.NNN` citation comment, for human triage — not a hard CI gate on day one (see AC-004). |

## Acceptance Criteria

### AC-001 — Convention documented in the test-writer agent definition

The test-writer agent definition states the verbatim-pin rule (exact-match for BC-specified
exact strings; `.contains()` reserved for BC-specified partial matches) in language a fresh-context
agent can apply without re-deriving it. (traces to drift item
LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT — pending BC authorship)

### AC-002 — Positive/negative example pair from real S-604-2 findings

The convention doc includes at least one real before/after example drawn from S-604-2's Step-4.5
fix-burst commits (F-02 through AC-013), showing a loose `.contains()` assertion that masked a
drift and the corrected exact-match version. (traces to drift item
LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT — pending BC authorship)

### AC-003 — Documented exception path for legitimate partial-match BCs

The convention explicitly states when `.contains()` remains correct (BC specifies substring/
partial matching as intended behavior), with at least one example, so the convention does not
produce false-positive review friction against legitimate partial-match assertions. (traces to
drift item LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT — pending BC authorship)

### AC-004 — Optional jr-side lint script, self-tested, non-blocking on day one

`scripts/check-verbatim-pin-convention.sh` is created following this repo's existing
`--self-test` convention (DEC-148/DEC-150 shape), proven to flag at least one known-bad fixture.
Its CI wiring status (advisory-only vs. hard-gate) is an explicit, documented decision — not
silently defaulted — given the false-positive risk noted in AC-003. (traces to drift item
LOOSE-CONTAINS-MASKS-BC-VERBATIM-MESSAGE-DRIFT — pending BC authorship)

## Tasks

1. Pull the seven S-604-2 Step-4.5 findings (F-02/F-03/F-05/B-01/B-02/P3-LOW-1/AC-013) and select
   the clearest before/after example (AC-002).
2. Write the convention text for the test-writer agent definition, including the documented
   exception path (AC-001, AC-003).
3. Build and self-test `check-verbatim-pin-convention.sh` against a known-bad fixture (AC-004).
4. Decide and document CI-wiring posture (advisory vs. hard-gate) for the jr-side lint (AC-004).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A BC postcondition intentionally allows multiple valid message variants (not one exact string) | The convention's documented exception applies — `.contains()` or an enum-of-acceptable-values assertion is correct here, not a false positive for the new convention. |
| EC-002 | A pre-existing `.contains()` assertion (not touched by this story) is flagged by the new lint | Flag-only; this story does not retrofit or rewrite existing test files — that is separate follow-up work, named in Out of Scope. |
| EC-003 | The lint script cannot find a BC-citation comment near a `.contains()` call | Treated as out-of-scope for the lint (no BC citation = no verbatim-pin obligation to check), not a false flag. |

## Dependency Analysis

**depends_on: []** — standalone; does not require S-PG-RED-GREEN-SWEEP-1 to land first, though
both are recommended to ship close together given the shared "green test masks drift" theme.

**blocks: []** — no story currently declares a dependency on this one.

## Out of Scope

- Retrofitting existing `.contains()` assertions across the jr test suite into exact-match form
  — a separate, larger follow-up task, not performed here.
- Making the jr-side lint a hard CI gate by default — an explicit, separately-justified decision
  (AC-004), not assumed.
- Any jr `src/` production code change.

## Story Points and Effort

**5 story points (small).** Breakdown: findings review + example selection (1 SP), convention
doc authoring (1.5 SP), lint script + self-test (2 SP), CI-posture decision + doc fallout
(0.5 SP). **Priority P2.**
