---
document_type: story
story_id: "S-FORK-OPS-GITLEAKS-DOC-1"
title: "Document GITLEAKS_DISABLED repo variable in fork-friendly-release-ops.md and CLAUDE.md"
wave: feature-followup
status: draft
intent: bug-fix
feature_type: infrastructure
mode: feature
scope: standard
severity: LOW
trivial_scope: false
points: 1
priority: P3
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0.25
target_module: docs
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: pending PO authorship
# No product BCs are added or modified by this story. The BC catalog count is unchanged.
# This is a documentation-only change: one Markdown table row and one CLAUDE.md bullet.
# Zero workflow logic changes; zero src/ changes; zero test changes.
# Do NOT add BCs to this story.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 2
assumption_validations: []
risk_mitigations: []
created: "2026-06-18"
version: "1.0"
last_updated: "2026-06-18"
changelog:
  - "1.0 (2026-06-18): Initial story decomposition — Phase F3."
breaking_change: false
lineage:
  - S-E2E-FORK-1     # established the JR_E2E_ENABLED repo-variable-gate doc pattern this story extends
  - S-WIN-6          # established the CLAUDE.md doc-fallout pattern for JR_* env vars and ADR cross-refs
drift_items:
  - FORK-OPS-GITLEAKS-DOC
files_modified:
  - docs/specs/fork-friendly-release-ops.md  # MODIFY — add GITLEAKS_DISABLED row to repo variables table
  - CLAUDE.md                                 # MODIFY — add GITLEAKS_DISABLED bullet to AI Agent Notes
---

# S-FORK-OPS-GITLEAKS-DOC-1 — Document `GITLEAKS_DISABLED` repo variable

## Source of Truth

F1 Delta Analysis: `.factory/phase-f1-delta-analysis/delta-analysis-fork-ops-backfill-1.md` §LOW-1
F2 Spec Delta: `.factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md` §Story 2
Precedent: S-E2E-FORK-1 (established the `JR_E2E_ENABLED` AI Agent Notes bullet pattern)

## Behavioral Contracts

No product BCs are added or modified by this story. The BC catalog count is unchanged.

**Why no BC anchor:** FORK-OPS-GITLEAKS-DOC is a documentation gap. The `ci.yml`
guard (`jobs.security.if: github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`)
already exists and is correct. The variable simply is not surfaced in
`docs/specs/fork-friendly-release-ops.md` or `CLAUDE.md` for operators configuring
forks. This story adds the missing documentation rows — it does not change any workflow
logic, any `jr` binary behavior, or any observable postcondition of any domain entity.

This story traces its ACs to the named drift item FORK-OPS-GITLEAKS-DOC.

## Story Narrative

As a fork maintainer configuring release-ops from `docs/specs/fork-friendly-release-ops.md`,
I want `GITLEAKS_DISABLED` to appear in the repository variables table and in
`CLAUDE.md` AI Agent Notes alongside the analogous `JR_E2E_ENABLED` entry,
so that I can discover the gitleaks opt-out mechanism from the spec without needing
to read `ci.yml` directly.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,500 |
| `docs/specs/fork-friendly-release-ops.md` (variables table section, ~50 LOC) | ~650 |
| `CLAUDE.md` AI Agent Notes section (locate `JR_E2E_ENABLED` bullet context, ~20 LOC) | ~260 |
| F2 spec delta §Story 2 (normative exact wording) | ~800 |
| **Total** | **~4,210** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**S-E2E-FORK-1** (MERGED PR #459) established the `JR_E2E_ENABLED` bullet in
`CLAUDE.md` AI Agent Notes. The new `GITLEAKS_DISABLED` bullet MUST appear adjacent
to that bullet (before or after) and MUST follow the same structure: repo variable →
guards a CI job → "NOT a Rust env var" → cross-reference to spec.

**S-WIN-6** established the `CLAUDE.md` doc-fallout pattern for `JR_*` seam variables
and ADR entries. The `GITLEAKS_DISABLED` variable is a repo variable (not a Rust seam),
so it belongs in AI Agent Notes, NOT in the `JR_*` debug-seam section.

**N/A — this is the first story to add a row to the `fork-friendly-release-ops.md`
repository variables table** since S-E2E-FORK-1 added `JR_E2E_ENABLED` to CLAUDE.md.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| AI Agent Notes placement | F2 spec delta §"Placement constraint" | The `GITLEAKS_DISABLED` bullet MUST appear in the AI Agent Notes section, adjacent to (before or after) the `JR_E2E_ENABLED` bullet. It MUST NOT appear in a product-feature section, a Gotchas section, or anywhere implying the variable affects `jr` binary behavior. |
| Repo variables table row format | F2 spec delta §"Required addition — append as fifth row" | Append as the fifth row of the table. No other changes to the file. The table's explanatory prose below it is unchanged. |
| Exact `if:` wording | F2 spec delta §"Drift Item GITLEAKS-DOC: CLAUDE.md" (post-O3 correction) | The `if:` condition in the bullet MUST be quoted exactly as: `github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`. Do NOT abbreviate to just `vars.GITLEAKS_DISABLED != 'true'`. |
| "NOT a Rust env var" statement | F2 spec delta §"Required addition" | The bullet MUST state "NOT a Rust env var; never read by `src/` code." This is the canonical form used by `JR_E2E_ENABLED` and is load-bearing for AI agent disambiguation. |
| No workflow logic changes | F1 delta analysis §LOW-1 | `ci.yml` already has the correct `jobs.security.if:` guard. This story MUST NOT touch `ci.yml` or any workflow file. |

## Library and Framework Requirements

No library or framework dependencies. This is a pure Markdown edit to two documentation
files.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `docs/specs/fork-friendly-release-ops.md` | MODIFY | Append `GITLEAKS_DISABLED` as the fifth row of the `## Repository variables` table. No other changes. |
| `CLAUDE.md` | MODIFY | Add `GITLEAKS_DISABLED` bullet to AI Agent Notes section, adjacent to the `JR_E2E_ENABLED` bullet. |

**Files NOT to create or modify:** No workflow files (`.github/workflows/`), no Rust
source (`src/`), no Rust tests (`tests/`), no BC files, no ADRs, no spec count scripts.

## Acceptance Criteria

### AC-001 (FORK-OPS-GITLEAKS-DOC — fork-friendly-release-ops.md) — Variables table has exactly five rows

`docs/specs/fork-friendly-release-ops.md` `## Repository variables` table contains
exactly five data rows after the change (the four existing rows plus the new
`GITLEAKS_DISABLED` row):

| `GITLEAKS_DISABLED` | `'true'` disables the gitleaks secret-scan job in `ci.yml`; for forks that cannot obtain a gitleaks org/commercial license or prefer an alternative scanner | unset |

No other content in the file is modified.

**Verifiable by:**
```bash
grep 'GITLEAKS_DISABLED' docs/specs/fork-friendly-release-ops.md
# Expected: matches (the new table row)

# Table has exactly 5 data rows (4 existing + 1 new)
grep -c '^\| `' docs/specs/fork-friendly-release-ops.md
# Expected: 5 (or consistent with existing table structure)
```

(traces to drift item FORK-OPS-GITLEAKS-DOC — GITLEAKS_DISABLED undocumented in spec)

---

### AC-002 (FORK-OPS-GITLEAKS-DOC — CLAUDE.md) — AI Agent Notes bullet present with exact wording

`CLAUDE.md` AI Agent Notes section contains a bullet for `GITLEAKS_DISABLED` that:

1. Names the variable: `` **`GITLEAKS_DISABLED`** ``
2. Identifies it as a GitHub Actions **repository variable** (`vars.GITLEAKS_DISABLED`)
3. States the full `if:` condition:
   `github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`
4. States the purpose: skips the gitleaks secret-scan job on PR events when set to `'true'`
5. States the rationale: for forks that cannot obtain a gitleaks org/commercial license
   or prefer an alternative secret scanner
6. States: "NOT a Rust env var; never read by `src/` code."
7. Cross-references `docs/specs/fork-friendly-release-ops.md`
8. Is located adjacent to the existing `JR_E2E_ENABLED` bullet (before or after it) in
   the AI Agent Notes section

**Verifiable by:**
```bash
grep 'GITLEAKS_DISABLED' CLAUDE.md
# Expected: matches (the new bullet)

grep 'NOT a Rust env var' CLAUDE.md | grep -c 'GITLEAKS_DISABLED'
# Expected: 1 (or both appear on nearby lines confirming section context)

# Confirm placement in AI Agent Notes (not in Gotchas or product section)
grep -n 'GITLEAKS_DISABLED\|AI Agent Notes\|JR_E2E_ENABLED' CLAUDE.md
# Expected: GITLEAKS_DISABLED and JR_E2E_ENABLED appear in same section (AI Agent Notes)
```

(traces to drift item FORK-OPS-GITLEAKS-DOC — GITLEAKS_DISABLED undocumented in CLAUDE.md)

---

## Tasks

### Item 1: Edit `docs/specs/fork-friendly-release-ops.md`

- [ ] Read `docs/specs/fork-friendly-release-ops.md` in full
- [ ] Locate the `## Repository variables` table (four-row table with `SIGNING_ENABLED`,
  `HOMEBREW_TAP_REPO`, `RELEASE_GAP_FILL_ENABLED`, `SYNC_UPSTREAM_REPO`)
- [ ] Append the fifth row immediately after `SYNC_UPSTREAM_REPO`:
  ```markdown
  | `GITLEAKS_DISABLED` | `'true'` disables the gitleaks secret-scan job in `ci.yml`; for forks that cannot obtain a gitleaks org/commercial license or prefer an alternative scanner | unset |
  ```
- [ ] Confirm no other content in the file is changed

### Item 2: Edit `CLAUDE.md` AI Agent Notes

- [ ] Read `CLAUDE.md`, locating the AI Agent Notes section and the `JR_E2E_ENABLED`
  bullet
- [ ] Insert the `GITLEAKS_DISABLED` bullet adjacent to `JR_E2E_ENABLED` (immediately
  before or after it):
  ```markdown
  - **`GITLEAKS_DISABLED`** — GitHub Actions **repository variable**
    (`vars.GITLEAKS_DISABLED`). Skips the gitleaks secret-scan job on
    pull-request events when set to `'true'` (`ci.yml` `jobs.security.if:
    github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`).
    Provided for forks that cannot obtain a gitleaks org/commercial license or
    prefer an alternative secret scanner. NOT a Rust env var; never read by `src/`
    code. Follows the `vars.JR_E2E_ENABLED` repo-variable-gate doc pattern
    (`docs/specs/e2e-fork-safe-ci-enablement.md`). See
    `docs/specs/fork-friendly-release-ops.md`.
  ```
- [ ] Confirm the bullet is in AI Agent Notes section, NOT in Gotchas or a product
  section
- [ ] Confirm no other content in CLAUDE.md is changed by this story

### Integration checks

- [ ] `cargo test` exits 0 (no Rust files changed; this is a formality)
- [ ] `bash scripts/check-spec-counts.sh` exits 0 (no BC files touched)
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0 (no BC count changes)

## Out of Scope

**`ci.yml` guard change:** The `jobs.security.if:` condition already contains the
correct guard. This story MUST NOT modify `ci.yml`.

**Any workflow logic changes:** This story is documentation-only. Zero changes to
`.github/workflows/`.

**New BCs, new VPs, new NFRs, new ADRs:** Not applicable to documentation gap closure.

**`backfill-release.yml` edits:** Those belong to S-FORK-OPS-BACKFILL-1.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `docs/specs/fork-friendly-release-ops.md` | `docs/specs/` | N/A (documentation) | Add `GITLEAKS_DISABLED` to repository variables table |
| `CLAUDE.md` | root | N/A (documentation) | Add `GITLEAKS_DISABLED` AI Agent Notes bullet adjacent to `JR_E2E_ENABLED` |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | F2 spec delta §"Placement constraint" | `GITLEAKS_DISABLED` bullet placed in Gotchas section instead of AI Agent Notes | MUST be in AI Agent Notes. Gotchas section is for runtime `jr` binary behavior quirks. A repo-variable that gates a CI job belongs in AI Agent Notes alongside `JR_E2E_ENABLED`. |
| EC-002 | F2 spec delta §O3 (adversarial pass 2 correction) | `if:` condition in CLAUDE.md bullet abbreviated to `vars.GITLEAKS_DISABLED != 'true'` only | MUST include the full condition `github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`. The PR-event scope is part of the contract — the guard only activates on PR events, not push or schedule triggers. |
| EC-003 | General | CLAUDE.md edit introduces a conflict with the `JR_E2E_ENABLED` bullet's surrounding context | Adjacent placement should cause no structural conflict. The AI Agent Notes section is a flat bulleted list; appending a sibling bullet is structurally safe. |

## Dependency Analysis

**depends_on: []** — No story dependencies. Documentation-only change with no build
dependency on any code story.

**blocks: []** — No story depends on this story within the current story graph.

**Conflict check:** S-FORK-OPS-BACKFILL-1 touches `.github/workflows/backfill-release.yml`
and `tests/backfill_matrix_parity.rs`. This story touches `docs/specs/fork-friendly-release-ops.md`
and `CLAUDE.md`. No file overlap. Both stories are fully independent.

This is a LEAF story in the dependency graph.

---

## Story Points and Effort

**1 story point** (xsmall). This is a documentation-only change:
- Item 1 (fork-friendly-release-ops.md table row): < 0.25 SP
- Item 2 (CLAUDE.md bullet): 0.5 SP
- Integration checks (formality): 0.25 SP

Risk: NEAR-ZERO. Both files are Markdown; no logic, no YAML structure, no test impact.
The only failure mode is wrong placement (Gotchas instead of AI Agent Notes) or
incorrect `if:` wording, both of which are caught by AC-002.
