---
document_type: story
level: ops
epic_id: "SOH-ATTACHMENTS-1"
story_id: "S-MAINT-576-HYG-1"
title: "S-576 family retroactive factory-artifacts hygiene: status drift, delivered/completed convention, subsystem correction"
wave: feature-followup
status: draft
intent: maintenance
feature_type: infrastructure
mode: feature
scope: standard
severity: LOW
trivial_scope: false
issue: null
points: 1
priority: LOW
tdd_mode: standard
estimated_effort: tiny
producer: story-writer
timestamp: "2026-08-03T00:00:00"
phase: 3
cycle: cycle-attachment-576
inputs:
  - ".factory/stories/STORY-INDEX.md"
  - ".factory/stories/S-576-1.md"
  - ".factory/stories/S-576-2.md"
  - ".factory/stories/S-576-3.md"
  - ".factory/stories/S-576-4.md"
  - ".factory/stories/S-576-5.md"
  - ".factory/stories/S-576-6.md"
input-hash: "211101f"
traces_to: ".factory/stories/STORY-INDEX.md"
estimated_days: 0.5
target_module: ".factory/stories/"
subsystems: ["SS-09"]
depends_on: []
blocks: []
behavioral_contracts: []
# BC status: pending PO authorship
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: "adversary passes 12/13/14 — review finding"
implementation_strategy: standard
module_criticality: LOW
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-08-03"
version: "1.0"
last_updated: "2026-08-03"
breaking_change: false
retroactive: true
origin: >
  Three independent adversary passes (12/13/14) found coherence drift between
  STORY-INDEX status records and individual story file `status:` fields for the
  S-576 family. S-576-1/2/3/4 merged PRs but their files still say `ready`;
  S-576-5 says `delivered` while STORY-INDEX says `completed`. The same passes
  found S-576-1/2/3/4/6 declare `["SS-03","SS-09"]` subsystems (HTTP Client Core
  + Build & Release) which do not match their primary files `src/cli/issue/attachments.rs`
  (SS-02) and `src/api/jira/attachments.rs` (SS-04). Human routing: own story.
files_modified:
  - .factory/stories/S-576-1.md
  - .factory/stories/S-576-2.md
  - .factory/stories/S-576-3.md
  - .factory/stories/S-576-4.md
  - .factory/stories/S-576-5.md
  - .factory/stories/S-576-6.md
  - .factory/stories/STORY-INDEX.md
test_files: []
---

# S-MAINT-576-HYG-1 — S-576 Family Retroactive Factory-Artifacts Hygiene

## Narrative

As a factory maintainer, I want the S-576 story files to accurately reflect the
lifecycle state and subsystem ownership of the SOH-ATTACHMENTS-1 bundle, so that
downstream re-derivation tooling and future adversarial passes read accurate
machine-readable metadata rather than stale pre-delivery placeholders.

## Acceptance Criteria

> **DRAFT scope — behavioral contracts not yet authored (status must stay `draft` per S-7.01).**

### AC-1: Status fields corrected in S-576-1/2/3/4

In each of `S-576-1.md`, `S-576-2.md`, `S-576-3.md`, and `S-576-4.md`, the frontmatter
`status:` field is changed from `ready` to `completed`. These stories were merged as:

| Story | PR | Merge date |
|-------|----|------------|
| S-576-1 | #630 / e33624c1 | 2026-07-19 |
| S-576-2 | #631 / efa8b5d9 | 2026-07-20 |
| S-576-3 | #635 / f2d3b378 | 2026-07-21 |
| S-576-4 | #638 / c28ae940 | 2026-07-22 |

Their `status: ready` values are pre-delivery placeholders that survived because no
post-merge sweep updated the factory-artifacts files.

### AC-2: Status field corrected in S-576-5; `delivered` vs `completed` convention settled

In `S-576-5.md`, the frontmatter `status:` field is changed from `delivered` to `completed`.
S-576-5 was merged as PR #640 / 0498e596 on 2026-07-23.

**Convention ruling (required by this story):** The `completed` terminal state is
the canonical post-merge value for stories whose PRs have merged to `develop`. There is
no separate `delivered` status in this project's lifecycle. The lifecycle is:
`draft` → `ready` → `in-progress` → `completed`. The value `delivered` in S-576-5 was
set ad-hoc (possibly meaning "PR merged but the bundle's S-576-6 E2E story was not yet
done") — but the bundle-completion signal is the STORY-INDEX bundle header, not individual
story status values. This story settles the convention by mapping `delivered` → `completed`
and documenting here that `delivered` is not a valid lifecycle state for this project.

S-576-6 already has `status: completed` and agrees with the STORY-INDEX; no change needed
for S-576-6's status field.

### AC-3: Subsystem declarations corrected in S-576-1/2/3/4/6

In each of `S-576-1.md`, `S-576-2.md`, `S-576-3.md`, `S-576-4.md`, and `S-576-6.md`,
the `subsystems:` frontmatter field is changed from `["SS-03","SS-09"]` to the
re-derived set based on their File Structure Requirements tables:

| Story | Primary files in scope | Correct subsystems | Justification |
|-------|------------------------|---------------------|---------------|
| S-576-1 | `src/cli/issue/attachments.rs` (CREATE), `src/api/jira/attachments.rs` (CREATE) | `["SS-02","SS-04"]` | SS-02=CLI Layer owns `src/cli/`; SS-04=Jira API Resources owns `src/api/jira/` |
| S-576-2 | `src/cli/issue/attachments.rs` (MODIFY), `src/api/jira/attachments.rs` (MODIFY) | `["SS-02","SS-04"]` | same as S-576-1 |
| S-576-3 | `src/cli/issue/attachments.rs` (MODIFY), `src/api/jira/attachments.rs` (MODIFY) | `["SS-02","SS-04"]` | same as S-576-1 |
| S-576-4 | `src/cli/issue/attachments.rs` (MODIFY), `src/api/jira/attachments.rs` (MODIFY) | `["SS-02","SS-04"]` | same as S-576-1 |
| S-576-6 | `tests/e2e_live.rs` (MODIFY), zero `src/` delta (tdd_mode: facade) | `["SS-02","SS-04"]` | E2E tests exercise the S-576-1..5 implementation; SS-02+SS-04 are the subsystems exercised |

**Why SS-03 was wrong:** SS-03 = HTTP Client Core covers `src/api/client.rs`,
`src/api/auth.rs`, `src/api/auth_embedded.rs`, `src/api/pagination.rs`,
`src/api/rate_limit.rs`, and `src/api/refresh_coordinator.rs`. None of these files
appear in any S-576 story's File Structure Requirements. SS-03 was likely a loose
stand-in for "API layer" rather than the canonical ARCH-INDEX definition.

**Why SS-09 was wrong:** SS-09 = Build & Release covers `Cargo.toml`, `build.rs`,
`.github/workflows/`, and `deny.toml`. The only S-576 change to these files was
ADR-0017 adding `reqwest` multipart features to `Cargo.toml` in S-576-3. That scope
is limited to S-576-3, not the whole family. Even for S-576-3 the dominant file
changes are CLI + API layer (SS-02 + SS-04).

Note: S-576-5 was already corrected to `["SS-02","SS-04","SS-05","SS-08"]` in v1.47
(adversary pass sweep 2026-08-03). No change needed for S-576-5's subsystems.

### AC-4: STORY-INDEX updated to reflect all corrections and document enabling gap

`STORY-INDEX.md` is updated to reflect:
- S-576-1/2/3/4/5 status: `completed` in each row (already recorded as such; verify the
  status string in each row still reads `completed`)
- S-576-1/2/3/4/6 subsystems: updated to the corrected values per AC-3
- This story (S-MAINT-576-HYG-1) registered as a new row
- STORY-INDEX `total_stories` and `version` bumped

**Enabling gap documented (note, no code change):** There is currently no automated guard
that enforces coherence between STORY-INDEX status/subsystem values and story file
frontmatter. The `tests/claude_md_citations.rs` guard validates CLAUDE.md file-path
citations but does not cover STORY-INDEX↔file field coherence. Similarly, the ARCH-INDEX
registry covers `src/`, `Cargo.toml`, `build.rs`, `deny.toml`, and `.github/workflows/`
paths — it declares no subsystems for `tests/`, `.factory/`, or `docs/` paths. The drift documented by this story is an
example of the class of defect that would be caught by a coherence guard; adding such a
guard is out of scope for this story but is noted here as a future improvement.

---

## Architecture Mapping

| Component | File | Action |
|-----------|------|--------|
| Story file status fields (5 files) | `.factory/stories/S-576-{1,2,3,4,5}.md` | `status: ready` → `completed`; `status: delivered` → `completed` |
| Story file subsystem fields (5 files) | `.factory/stories/S-576-{1,2,3,4,6}.md` | `subsystems: ["SS-03","SS-09"]` → `["SS-02","SS-04"]` |
| Story index | `.factory/stories/STORY-INDEX.md` | Register new story, bump version, verify S-576 row subsystems |

**Subsystem anchor justifications:**
- SS-09 owns this story's scope because `.factory/stories/STORY-INDEX.md` has no declared
  subsystem in ARCH-INDEX; best-fit is SS-09 (Build & Release / housekeeping) per the
  disclosure requirement. The modified `.factory/` story files are not directly code.
- No `depends_on` or `blocks` entries: this story has no product-code dependencies and
  blocks no other story. It is a factory-artifacts-only maintenance sweep.

---

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-1 | S-576-5 subsystems already corrected to `["SS-02","SS-04","SS-05","SS-08"]` | Leave S-576-5 subsystems unchanged; only fix its `status:` field |
| EC-2 | STORY-INDEX row for a story already says `completed` but file says `ready` | Canonical source of truth for completion is PR merge; update the file to match |
| EC-3 | `delivered` appears in STORY-INDEX row prose (past-participle) vs as a status value | Prose usage ("status: completed (DELIVERED...)") is fine; only the YAML `status:` field value is governed by this story |

---

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `.factory/stories/*.md` edits | documentation | Frontmatter field corrections; no logic changes |
| `STORY-INDEX.md` edits | documentation | Index registration and row corrections |

---

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,500 |
| 6 story files (S-576-1..6) frontmatter sections | ~1,500 |
| STORY-INDEX.md (relevant rows) | ~4,000 |
| ARCH-INDEX subsystem registry (verification) | ~500 |
| Tool outputs | ~500 |
| **Total (estimated)** | **~10,000** |

Budget usage: ~10,000 / 200,000 = ~5%. Well within per-story budget.

---

## Tasks (MANDATORY)

### Task 1: Correct `status:` in S-576-1/2/3/4

For each of `S-576-1.md`, `S-576-2.md`, `S-576-3.md`, `S-576-4.md`:
- Read the frontmatter `status:` field. Confirm it reads `ready`.
- Change to `completed`.
- Bump `last_updated` to today's date.

### Task 2: Correct `status:` in S-576-5

- Read S-576-5.md frontmatter. Confirm `status: delivered`.
- Change to `completed`.
- Bump `last_updated`.
- Note: subsystems are already correct (`["SS-02","SS-04","SS-05","SS-08"]`); do not touch.

### Task 3: Correct `subsystems:` in S-576-1/2/3/4/6

For each of `S-576-1.md`, `S-576-2.md`, `S-576-3.md`, `S-576-4.md`, `S-576-6.md`:
- Read the frontmatter `subsystems:` field. Confirm it reads `["SS-03","SS-09"]`.
- Change to `["SS-02","SS-04"]`.
- Bump `last_updated`.

### Task 4: Update STORY-INDEX

- Locate the rows for S-576-1/2/3/4/6 in STORY-INDEX.
- Update each row's inline subsystem annotation from `SS-03/SS-09` to `SS-02/SS-04`.
- **VERIFY (do NOT re-increment):** This story's row (S-MAINT-576-HYG-1) was already
  registered and STORY-INDEX `total_stories` was already bumped to 123 during story
  creation. Confirm the row exists at position 123 and `total_stories: 123` — do not
  increment again.
- Bump STORY-INDEX `version` by one patch (for the subsystem annotation updates).

### Task 5: Verify no unintended changes

- Run `scripts/check-spec-counts.sh` (must exit 0; this story touches no BC files).
- Run `scripts/check-bc-cumulative-counts.sh` (must exit 0; no BC changes).

---

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|--------------------|
| S-576-5 (v1.47) | Subsystem re-derivation from File Structure Requirements table was applied to S-576-5 during adversary pass 2026-08-03 — the same method applies here to the other family members. | Subsystem re-derivation method: read the story's File Structure Requirements table, map each file to its owning subsystem per ARCH-INDEX, take the union. | SS-03 ("HTTP Client Core") is frequently mis-anchored as a stand-in for "any API layer code" — it is NOT. SS-03 covers exactly six files: `src/api/client.rs`, `src/api/auth.rs`, `src/api/auth_embedded.rs`, `src/api/pagination.rs`, `src/api/rate_limit.rs`, and `src/api/refresh_coordinator.rs`. Story files that modify `src/api/jira/*.rs` or `src/api/jsm/*.rs` belong to SS-04 or SS-05, not SS-03. |
| STORY-INDEX v1.5.53 | `delivered` appeared once as a `status:` value (S-576-5). The prior adversary sweep corrected subsystems but did not resolve the `delivered`/`completed` ambiguity — that is settled here. | Terminal lifecycle state for merged stories: `completed`. No intermediate `delivered` state exists in this project's story workflow. | Post-merge status updates to story files are frequently missed because the factory-artifacts `git push` happens separately from the product PR merge. A coherence guard would catch this class of drift automatically. |

---

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| Subsystem IDs must be from ARCH-INDEX registry (SS-01..SS-09) | Policy 6 / ARCH-INDEX | Manual verification against `arch-index.md` |
| `status: ready` in a merged story is a coherence defect | STORY-INDEX↔file coherence convention (no guard) | This story (manual sweep) |
| `delivered` is not a valid status value | AC-2 lifecycle ruling | Corrected by this story; enforced by convention |
| Only `.factory/stories/` files are modified | Scope constraint | Do not modify any `src/` or `tests/` or `.github/` files |

---

## Library & Framework Requirements (MANDATORY)

No crate dependencies for this story — it modifies only `.factory/` YAML/Markdown files.
N/A — factory-artifacts-only delivery.

---

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `.factory/stories/S-576-1.md` | MODIFY | `status: ready` → `completed`; `subsystems: ["SS-03","SS-09"]` → `["SS-02","SS-04"]` |
| `.factory/stories/S-576-2.md` | MODIFY | `status: ready` → `completed`; `subsystems: ["SS-03","SS-09"]` → `["SS-02","SS-04"]` |
| `.factory/stories/S-576-3.md` | MODIFY | `status: ready` → `completed`; `subsystems: ["SS-03","SS-09"]` → `["SS-02","SS-04"]` |
| `.factory/stories/S-576-4.md` | MODIFY | `status: ready` → `completed`; `subsystems: ["SS-03","SS-09"]` → `["SS-02","SS-04"]` |
| `.factory/stories/S-576-5.md` | MODIFY | `status: delivered` → `completed` (subsystems already correct; no change) |
| `.factory/stories/S-576-6.md` | MODIFY | `subsystems: ["SS-03","SS-09"]` → `["SS-02","SS-04"]` (status already `completed`; no change) |
| `.factory/stories/STORY-INDEX.md` | MODIFY | Register new story row; update S-576 subsystem annotations; bump version and total_stories |

**MUST NOT change**: any `src/` files, any `tests/` files, any `.github/workflows/` files,
any `.factory/specs/` files, any BC files, any CLAUDE.md or Cargo.toml files.
