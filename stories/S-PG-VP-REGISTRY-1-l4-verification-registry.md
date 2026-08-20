---
document_type: story
level: ops
story_id: "S-PG-VP-REGISTRY-1"
epic_id: "SELF-IMPROVEMENT"
title: "Build an L4 Verification Property registry (ARCH-INDEX-equivalent for VPs)"
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
points: 8
priority: P2
tdd_mode: strict
estimated_effort: medium
estimated_days: 3
target_module: pipeline-workflow-spec-steward-governance
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  # BC status: no product BCs. This is an engine/process-tooling change — a new
  # spec-governance artifact type and its registry — with no jira-cli behavioral-
  # contract surface. Follows the no-BC precedent set by S-PG-MERGE-AUTH-BYPASS.
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
traces_to: ".factory/phase-f7-convergence/components-delta-convergence-report.md §6 Keep-Deferred Disposition, row NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE"
spec_source: "F7 component-mgmt delta-convergence report §6 (producer spec-steward, 2026-08-20), human-ratified recommendation to open a follow-up story targeting the self-improvement epic, per the S-7.02 Cycle-Closing Checklist and the human's F7 final-authorization gate."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-08-20"
last_updated: "2026-08-20"
changelog:
  - "1.0 (2026-08-20): Initial draft — opened from the F7 component-mgmt cycle §6 Keep-Deferred Disposition, item NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE (F2/spec-crystallization carry-forward; human F7 final-authorization gate; human ratified the recommendation to open a follow-up story). Self-improvement / engine-process scope, anchored to the SELF-IMPROVEMENT epic (precedent: S-PG-MERGE-AUTH-BYPASS). No BCs yet — PO authorship required before status=ready (S-7.01 gate)."
breaking_change: false
lineage:
  - S-PG-MERGE-AUTH-BYPASS
drift_items:
  - NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE
files_created: []
files_modified:
  - "[engine]/templates/vp-registry-template.md"        # CREATE — canonical VP registry format, mirroring ARCH-INDEX's structure/columns
  - "[engine]/agents/spec-steward/AGENT.md"              # MODIFY — add VP registry maintenance to the spec-steward's L4 governance mandate
  - ".factory/verification/VP-REGISTRY.md"               # CREATE (this repo's first instance) — centralized index of all VP-NNN IDs currently scattered across phase-scoped delta files
---

# S-PG-VP-REGISTRY-1 — L4 Verification Property Registry

## Source of Truth

`.factory/phase-f7-convergence/components-delta-convergence-report.md` §6 Keep-Deferred
Disposition, row `NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE` (MEDIUM), origin: "F2/spec-
crystallization carry-forward". Verbatim description: "No VP registry/ARCH-INDEX equivalent
exists — L4 Verification Properties live inline in phase-scoped delta files only, with no
centralized index a spec-steward governance sweep can walk." Recommended disposition (human
ratified at the F7 gate): "Open follow-up story targeting the self-improvement epic — build a
VP registry/ARCH-INDEX-equivalent for L4 VPs per the spec-steward's L4 governance mandate."

## Behavioral Contracts

No BCs have been authored yet. Status must remain `draft` until a product-owner authors
BC-S.SS.NNN contracts for this story (S-7.01 gate). When BCs are authored they should cover:

- **Precondition:** a VP-NNN ID is not considered fully registered until it appears in the
  centralized VP registry, in addition to whichever phase-scoped delta file originated it.
- **Postcondition:** the spec-steward's governance sweep can walk the VP registry to answer
  "which VPs exist, which BCs/stories cite them, and are any orphaned (cited nowhere) or
  duplicated (same ID assigned twice)" without needing to grep every phase-scoped delta file
  individually.
- **Invariant:** the registry is additive to, not a replacement for, the phase-scoped delta
  files where VPs are originally authored — same relationship ARCH-INDEX has to individual ADR
  files.

## Narrative

As the spec-steward performing L4 governance sweeps, I want a centralized VP registry (an
ARCH-INDEX-equivalent for Verification Properties), so that I can answer completeness and
duplication questions about VP-NNN IDs across the whole project without re-deriving the answer
by grepping every phase-scoped delta file each time.

## Problem Statement

This engine's L4 layer (Verification Properties, VP-NNN) has no centralized index analogous to
what ARCH-INDEX provides for L3 architecture decisions (ADRs) and subsystems. VPs are currently
authored inline within phase-scoped delta files (e.g. `verification-delta-<bundle>.md`) and
referenced by ID from story frontmatter (`verification_properties: [VP-NNN, ...]`), but nothing
aggregates them into one place. This is a governance gap, not (yet) a correctness defect: without
a registry, the spec-steward cannot mechanically answer "does every VP-NNN cited by a story
frontmatter actually exist in some delta file?" or "has this VP-NNN ID been assigned twice by two
different bundles?" without a manual, cycle-scoped search each time. As this repo accumulates
more Feature Mode bundles (bucket1-defects, SOH-ATTACHMENTS-1, SOH-DX-1, component-mgmt, and
whatever comes next), the number of scattered VP-authoring files grows and the manual-search cost
grows with it.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,200 |
| F7 delta-convergence report §6 (relevant row) | ~1,200 |
| Existing ARCH-INDEX (structure reference, if present in this repo's `.factory/architecture/`) | ~2,500 |
| Survey of existing `verification-delta-*.md` files across cycle-001's bundles | ~4,000 |
| Engine spec-steward agent definition (once located) | ~2,500 |
| **Total** | **~13,400** |

Well within budget (~7% of a 200K window). No split required.

## Previous Story Intelligence

**S-QUEUE-BC-1** (this repo, 2026-06-08) is the closest jr-side precedent for "author a missing
governance artifact retroactively to close a traceability orphan" — that story authored
document-as-is BCs to resolve a story-to-BC traceability gap discovered during S-JSM-E2E-1. The
same shape applies here: this story is authoring a missing *registry*, not new VPs themselves.

**component-mgmt cycle's own VP family** (`VP-COMPONENT-001` through `VP-COMPONENT-028`, cited
across `S-604-1` through `S-608-1`'s frontmatter) is the largest, most recent, most concrete VP
set in this repo and should be the registry's first fully-populated bundle-section — building the
registry against a real, already-shipped VP set (rather than a hypothetical schema) will surface
real gaps in the schema design before it is applied more broadly.

**N/A — first story building a centralized L4 artifact in this repo.** No prior story has
created a registry file under `.factory/verification/`.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Additive, not a replacement | Behavioral Contracts invariant | The registry indexes existing VPs; it does not move VP authorship out of phase-scoped delta files. Do not delete or hollow out any existing `verification-delta-*.md` file. |
| Mirror ARCH-INDEX's shape where it fits | Problem Statement | Reuse the same kind of columns ARCH-INDEX uses for ADRs (ID, title, status, originating bundle/story, citing artifacts) rather than inventing an unrelated schema — consistency lowers the cost for the spec-steward to reason about both registries together. |
| Populate against real data, not a placeholder | Previous Story Intelligence | The registry's first population pass must use this repo's actual existing VPs (component-mgmt's VP-COMPONENT-001..028 plus any other bundle's VPs discoverable from `verification-delta-*.md` files), not a synthetic example set. |
| No jr product `src/` changes | Scope boundary | This story creates spec-governance artifacts only. |

## Library & Framework Requirements

No new dependencies. Markdown table format, consistent with every other index file in this repo
(`STORY-INDEX.md`, `BC-INDEX.md`).

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `[engine]/templates/vp-registry-template.md` | CREATE | Canonical VP registry template for the engine, reusable across projects — columns: VP ID, title/description, originating bundle/story, citing BCs, citing stories, status (active/superseded/orphaned). |
| `[engine]/agents/spec-steward/AGENT.md` | MODIFY | Add VP registry maintenance (keep it in sync when new VPs are authored) to the spec-steward's stated L4 governance responsibilities. |
| `.factory/verification/VP-REGISTRY.md` | CREATE (this repo) | This repo's first populated instance, seeded from every VP currently discoverable in `verification-delta-*.md` files across all cycle-001 bundles. |

## Acceptance Criteria

### AC-001 — Registry template defined with ARCH-INDEX-consistent schema

`[engine]/templates/vp-registry-template.md` defines the registry's column schema, explicitly
modeled on ARCH-INDEX's existing shape for ADRs/subsystems. (traces to drift item
NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE — pending BC authorship)

### AC-002 — This repo's registry is populated from real existing VPs

`.factory/verification/VP-REGISTRY.md` is created and populated by walking every discoverable
`verification-delta-*.md` file in this repo's `.factory/` tree, including the full
`VP-COMPONENT-001..028` set from the component-mgmt bundle. (traces to drift item
NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE — pending BC authorship)

### AC-003 — Registry surfaces at least one real completeness/duplication finding, or explicitly reports none

Running the population sweep against real data (AC-002) either surfaces at least one real
orphan/duplicate/gap finding (report it, do not silently fix without human review) or explicitly
states the sweep found none — either outcome is acceptable, but the sweep's result must be
stated, not omitted. (traces to drift item NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE — pending
BC authorship)

### AC-004 — Spec-steward agent definition references the registry maintenance duty

The spec-steward agent definition documents that new VPs authored in any future
`verification-delta-*.md` file must also be added to the registry, as part of its L4 governance
mandate. (traces to drift item NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE — pending BC authorship)

### AC-005 — Registry is discoverable and cross-referenced

`STORY-INDEX.md`'s Cross-Reference Convention section (or an equivalent discoverable location)
gains a pointer to `.factory/verification/VP-REGISTRY.md`, so future story-writers and the
spec-steward can find it without prior knowledge of its path. (traces to drift item
NO-VP-REGISTRY-VERIFICATION-ARCHITECTURE — pending BC authorship)

## Tasks

1. Survey this repo's existing `.factory/architecture/ARCH-INDEX.md` (or equivalent) for its
   column schema to model the VP registry on (AC-001).
2. Draft `[engine]/templates/vp-registry-template.md` (AC-001).
3. Walk this repo's `.factory/` tree for every `verification-delta-*.md` file and every VP-NNN ID
   referenced in story frontmatter; populate `.factory/verification/VP-REGISTRY.md` (AC-002).
4. Cross-check populated entries for orphans (VP cited by a story but not found in any delta
   file) and duplicates (same VP-NNN ID assigned by two different bundles); report findings
   (AC-003).
5. Update the spec-steward agent definition (AC-004).
6. Add a cross-reference pointer from `STORY-INDEX.md` (AC-005).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A VP-NNN ID is cited in a story's frontmatter but no `verification-delta-*.md` file defines it | Report as an orphan finding (AC-003); do not silently fabricate a definition or silently drop the citation. |
| EC-002 | Two different bundles' delta files happen to assign the same VP-NNN number | Report as a duplicate finding (AC-003); resolution (renumbering) is a follow-up decision, not performed automatically by this story. |
| EC-003 | A `verification-delta-*.md` file cannot be parsed cleanly (malformed VP block) | Report the file/VP as unparseable, distinct from "VP not found" — never silently skip. |

## Dependency Analysis

**depends_on: []** — standalone; does not require any other story in this batch to land first.

**blocks: []** — no story currently declares a dependency on this one, though a future story
that further mechanizes registry-sync checking (analogous to
`S-PG-DELTA-DOC-RESYNC-1`) would naturally build on this registry's existence.

## Out of Scope

- Renumbering any VP-NNN ID found to be duplicated — flagged, not resolved, by this story.
- Retroactively authoring VPs for any BC found to lack one — a separate governance task.
- A mechanical CI check enforcing registry sync on every future VP authoring event — that is the
  natural next story (not opened here), analogous to `S-PG-DELTA-DOC-RESYNC-1`'s scope for BC
  edits.
- Any jr `src/` production code change.

## Story Points and Effort

**8 story points (medium).** Breakdown: schema design (1.5 SP), full-repo VP survey + population
(3 SP), completeness/duplication cross-check (1.5 SP), spec-steward doc update + cross-reference
(2 SP). **Priority P2.**
