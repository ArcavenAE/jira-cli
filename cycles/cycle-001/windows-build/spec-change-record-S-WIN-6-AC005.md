---
document_type: spec-change-record
story_id: "S-WIN-6"
ac_id: "AC-005"
date: "2026-06-13"
change_type: "Red-Gate doc-target reconciliation"
spec_changelog_version: "1.3.13"
behavioral_re_gate_required: false
adversarial_re_convergence: "complete (3-clean; DEC-080/082/084 pre-existing)"
---

# Spec Change Record: S-WIN-6 AC-005 Red-Gate Reconciliation

## Summary

At Red-Gate for S-WIN-6, AC-005's deliverable was re-scoped from
`.factory/architecture/adr-index.md` (a factory-internal artifact on the
factory-artifacts orphan branch, unreachable by product CI) to the product-repo
ADR registry — CLAUDE.md `## Key Decisions` section (which was missing an
ADR-0016 entry).

## Defect Identified at Red-Gate

AC-005 as originally written named `.factory/architecture/adr-index.md` as the
product-repo artifact to verify. This is a factory bookkeeping file on the
`factory-artifacts` orphan branch. It is:

1. Not checked out in the product worktree during CI.
2. Not reachable by `cargo test` or any file-system test that reads product-repo
   files.
3. Already populated (row added during F2/F3) and therefore NOT a product-PR
   deliverable for S-WIN-6.

A test reading `.factory/architecture/adr-index.md` would always fail on CI
(file not found) even when the underlying intent — "ADR-0016 is registered in
the product's ADR index" — is satisfied.

## Re-Scope Applied

| Dimension | Before (original AC-005) | After (reconciled AC-005) |
|-----------|--------------------------|---------------------------|
| Deliverable artifact | `.factory/architecture/adr-index.md` | `CLAUDE.md §Key Decisions` |
| Artifact type | Factory bookkeeping (orphan branch) | Product-repo developer-facing doc |
| CI reachability | No (factory-artifacts orphan branch) | Yes (CLAUDE.md is always checked out) |
| Already done in F2/F3 | Yes (factory row already present) | No (ADR-0016 entry missing from CLAUDE.md) |
| Pinning test | (hypothetical: would read `.factory/` — CI failure) | `test_claude_md_key_decisions_includes_adr_0016` greps CLAUDE.md |

## Rationale

**Factory vs product artifact boundary.** The `.factory/` directory is not part
of the product PR deliverables. It lives on the `factory-artifacts` orphan
branch and is managed separately by the orchestrator. The product-repo ADR
registry has always been CLAUDE.md `## Key Decisions` (see entries ADR-0001
through ADR-0015 already present). The original AC-005 text confused the
factory bookkeeping artifact (which the F2/F3 pass did add) with the
product-repo deliverable (which was missing and needed to be added by S-WIN-6).

**CI-reachability is a correctness constraint.** A test that always fails on CI
due to a missing file defeats the purpose of the acceptance criterion. The
correction ensures the pinning test (`test_claude_md_key_decisions_includes_adr_0016`)
exercises a file that is unconditionally present in every CI checkout.

**The DECISION is unchanged.** The F3-approved and 3-clean-converged DECISION
was: "add ADR-0016 to the product-repo ADR registry." The correction only
clarifies which file IS the product-repo ADR registry (CLAUDE.md, not .factory/).

## Affected Artifacts

| Artifact | Change |
|----------|--------|
| `S-WIN-6-windows-docs-fallout.md` | `last_updated: 2026-06-13` (set by story-writer); AC-005 body, `files_modified` already reconciled by story-writer |
| `STORY-INDEX.md` | S-WIN-6 row title: "adr-index" → "CLAUDE.md §Key Decisions (ADR-0016 entry)" |
| `spec-changelog.md` | v1.3.13 entry (PATCH; this governance pass) |
| `spec-change-record-S-WIN-6-AC005.md` | This file (created) |

## Traceability Chain

Red-Gate defect (product test cannot read `.factory/` in CI)
  → AC-005 re-scope (factory artifact → product-repo CLAUDE.md §Key Decisions)
    → CLAUDE.md `## Key Decisions` deliverable (ADR-0016 entry)
      → `test_claude_md_key_decisions_includes_adr_0016` (greps CLAUDE.md; CI-safe)
        → forthcoming S-WIN-6 convergence DEC (post-F7)

## Adversarial Re-Convergence Status

3-clean adversarial re-convergence was already complete before this Red-Gate
finding was identified (DEC-080: F3 CONVERGED Pass P6/P7/P8; DEC-082: corrections
propagated; DEC-084: F3 re-gate RE-AFFIRMED by human). This correction is a
doc-target reconciliation within the approved story — the DECISION and the
story's functional intent are unchanged. No new adversarial re-convergence or
behavioral re-gate is required.

## No Behavioral Re-Gate Required

- No BC body changed.
- No NFR body changed.
- No ADR added or removed (ADR-0016 count remains 16, the content is unchanged).
- No story count changed (74 authoritative).
- The functional deliverable (ADR-0016 entry in the product ADR registry) is
  the same; only the artifact that IS the product ADR registry was clarified.
- The correction makes the pinning test CI-reachable (was a bug in the test
  spec, not a behavioral contract change).

**Assessment: standard per-story F7 convergence applies. S-WIN-6 F4 dispatch
is unblocked.**
