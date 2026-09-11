---
document_type: story
level: ops
story_id: "S-cycle7-readme-migration-note"
epic_id: "AUTH-CORRECTNESS-DX-1"
title: "README per-profile-credential migration note (issue #783)"
wave: 1
status: draft
intent: enhancement
feature_type: documentation
mode: feature
scope: trivial
severity: LOW
trivial_scope: true
producer: story-writer
timestamp: "2026-09-10T00:00:00"
phase: 3
inputs:
  - ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md"
  - "README.md"
input-hash: "f9a04c7"
traces_to: ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md §6.2"
cycle: cycle-007-auth-correctness-dx
estimated_effort: xsmall
estimated_days: 0.5
target_module: "README.md"
subsystems: []
depends_on: []
blocks: []
behavioral_contracts: []
bcs: []
# BC status: N/A by design — doc-only deliverable, no BC anchor. Mirrors the
# S-cycle4-windows-docs precedent ("doc-only, no BC/VP anchors per this
# cycle's binding instruction that doc-content ACs are not force-fit to an
# unrelated BC"). PRD delta §6.2 explicitly scopes this as a doc-delta, not a
# BC amendment.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
priority: P4
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-007/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: facade
module_criticality: LOW
points: 2
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: []
created: "2026-09-10"
version: "1.0"
last_updated: "2026-09-10"
breaking_change: false
retroactive: false
origin: >
  cycle-007 auth-correctness-dx, Wave 1, no deps. README.md's existing
  migration section (near the `[instance]` -> `[profiles.default]` reshape
  note) is missing a bullet covering the per-profile-credential breaking
  change introduced in cycle-003 (BC-1.4.034): every pre-cycle-003 api-token
  profile must run `jr auth login --profile <name>` once after upgrading, and
  this requirement is asymmetric with OAuth (which lazy-migrates flat ->
  namespaced keys automatically; api-token deliberately does NOT, per
  BC-1.4.032's no-copy detect-and-instruct design). The README's primary
  claim about a "shared credential model" was already remediated before this
  cycle (per the validated triage report) — this story's scope is narrowly
  the missing migration-note bullet only (issue #783). Sequencing recommendation
  (editorial, not a functional dependency — see wave-schedule.md §3 for the
  distinction): land AFTER S-cycle7-credential-absence-fix so the bullet can
  cite the corrected `--profile` syntax directly, avoiding a follow-up
  correction; the `--profile` flag itself already works today regardless of
  that story's status, so this is a recommendation, not a graph edge. Human-
  approved at the F1 gate (2026-09-10) as part of the 6-issue
  `auth-correctness-dx` bundle.
---

> **tdd_mode:** `facade` — this is a documentation-only deliverable (a
> `README.md` prose addition) with no executable behavior to TDD against; the
> "test" for each AC is a content/prose-presence check, not a `#[test]`
> function. `module_criticality: LOW`.

> **Execute:** `/vsdd-factory:deliver-story S-cycle7-readme-migration-note`

# S-cycle7-readme-migration-note — README per-profile-credential migration bullet

## Narrative

- **As a** `jr` user upgrading from a pre-cycle-003 binary with an
  api-token-authenticated profile
- **I want to** find, in README.md's migration section, a clear statement
  that I must run `jr auth login --profile <name>` once after upgrading
- **So that** I understand why my previously-working profile suddenly fails
  with a credential-absence error, and know the exact remediation without
  filing a support issue or reading the source

## Behavioral Contracts

**N/A by design — doc-only deliverable.** No PRD BC anchors this story (PRD
delta §6.2 scopes it explicitly as a doc-delta, not a BC amendment — mirrors
the `S-cycle4-windows-docs` precedent for the same reason: a README prose
addition has no independently-testable behavioral contract to pin). This
story's ACs trace directly to the PRD delta's own content requirements (§6.2)
and, for context only (not as a normative anchor), to BC-1.4.032/BC-1.4.034
(the breaking-change contract the README bullet documents — owned and already
amended by `S-cycle7-credential-absence-fix`, not by this story).

## Acceptance Criteria

### AC-001 (traces to PRD delta §6.2, primary deliverable)
`README.md`'s existing migration section (the section discussing the
`[instance]` → `[profiles.default]` config reshape) gains a new bullet
stating: pre-cycle-003 api-token profiles must run
`jr auth login --profile <name>` once after upgrading to restore working
authentication.
**Test:** content-presence check — the bullet text exists in `README.md`'s
migration section, reviewed at PR time (not a `#[test]` function; a
`grep`-based CI doc-guard is an acceptable but not required implementation
choice)

### AC-002 (traces to PRD delta §6.2 / BC-1.4.034's breaking-change contract, cross-ref only)
The bullet cites the CORRECTED `--profile` syntax (`jr auth login --profile
<name>`, not the old non-parsing positional form) — this is why the PRD
delta recommends sequencing this edit after `S-cycle7-credential-absence-fix`
lands, so the bullet is written once, correctly, without a follow-up
correction. (Editorial sequencing recommendation only — see
`wave-schedule.md` §3 for why this is not a `depends_on:` graph edge: the
`--profile` flag itself already works today independent of that story's
status.)
**Test:** content-presence check — the bullet's exact syntax matches
`jr auth login --profile <name>`, not `jr auth login <name>`

### AC-003 (traces to PRD delta §6.2, asymmetry note)
The bullet (or an adjacent sentence in the same migration section) documents
the deliberate OAuth-vs-api-token migration asymmetry: OAuth profiles
lazy-migrate their flat → namespaced keychain keys automatically on first use;
api-token profiles do NOT (BC-1.4.032's no-copy detect-and-instruct design) —
so an api-token user must take the explicit re-login action, while an OAuth
user does not.
**Test:** content-presence check — the asymmetry is stated explicitly, not
merely implied

### AC-004 (traces to CLAUDE.md conventions — CHANGELOG delivery task)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Changed` (or `Fixed`) entry
noting the README migration-note addition (docs-only, but per this project's
standing rule that every story's Tasks list includes a CHANGELOG task).
**Test:** N/A (doc artifact; verified by PR review)

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| README migration section | `README.md` | N/A (documentation, not code) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| N/A | This is a prose-only addition to an existing, already-correct migration section — no new edge case is introduced | The "edge case" this story documents is the reader's own upgrade scenario (a pre-cycle-003 api-token profile), which is the primary deliverable itself (AC-001) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `README.md` | N/A (documentation) | Not source code; no purity classification applies |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~1,500 |
| Referenced content (`README.md`'s existing migration section, BC-1.4.032/034 for context) | ~2,000 |
| N/A (no test files — doc-only) | 0 |
| Tool outputs overhead | ~500 |
| **Total** | **~4,000** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~2%** |

Trivially within budget.

## Tasks

1. [ ] Read `README.md`'s existing migration section (the `[instance]` →
   `[profiles.default]` reshape note) to find the correct insertion point —
   `implementer`
2. [ ] **Recommended sequencing check (editorial, not a hard blocker):**
   confirm whether `S-cycle7-credential-absence-fix` has already landed; if
   so, cite its corrected `--profile` syntax directly; if not, the `--profile`
   flag already works today (it predates this cycle), so proceed and simply
   avoid citing the OLD positional-form error-message text as an example
3. [ ] Write the migration bullet (AC-001/AC-002) — `implementer`
4. [ ] Write the OAuth-vs-api-token asymmetry sentence (AC-003) — `implementer`
5. [ ] Review: confirm the bullet does NOT restate the already-remediated
   "shared credential model" claim (out of this story's scope per PRD delta
   §6.2 — that claim was already fixed before this cycle)
6. [ ] Add a CHANGELOG entry under `[Unreleased] > Changed` (AC-004), before
   creating the PR

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-cycle4-windows-docs (cycle-004) | Established the "doc-only story, no BC/VP anchor, `tdd_mode` need not be `strict`" precedent this story follows | A doc-only story's ACs trace to the PRD delta's own content requirements directly, not to a force-fit BC | A prior story's own doc-fallout obligation should be checked for overlap before writing new prose — no overlap found here (this bullet is net-new, not a rewrite of an existing claim) |
| S-cycle7-credential-absence-fix (this cycle, Wave 1, no dependency edge — editorial sequencing recommendation only) | Corrects the `--profile` syntax this story's bullet cites | N/A | The temptation to encode "recommended AFTER" as a hard `depends_on:` edge was considered and REJECTED — the `--profile` flag itself is not new in this cycle, only the ERROR MESSAGE's recommendation text is; a real dependency would misrepresent the actual build-order requirement (see this story's own frontmatter `origin:` for the full reasoning) |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| Do not restate or re-litigate README claims already remediated before this cycle (the "shared credential model" claim) | PRD delta §6.2 ("the primary README claim... was already remediated before this cycle") | Task 5 review step |
| A doc-only story's `depends_on:` must reflect actual build-order requirements, not editorial preference | Anchor Justification Requirement (this agent's own operating constraints) | This story's `depends_on: []` with the sequencing recommendation stated as prose, not a graph edge |

## Library & Framework Requirements

N/A — this story touches no source code and introduces no library dependency.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `README.md` | modify | Add the migration bullet + asymmetry sentence to the existing migration section |
| `CHANGELOG.md` | modify | `[Unreleased] > Changed` entry (Task 6) |
