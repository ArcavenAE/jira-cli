---
document_type: cycle-manifest
cycle_id: cycle-009-jql-relative-date-units
cycle_type: bugfix
version: TBD (rolls into next dev prerelease at close -- no immediate tag, per F1-gate decision 4)
status: in-progress
started: 2026-09-22T19:28:28Z
completed: ""
producer: orchestrator
---

# Cycle Manifest: cycle-009 (jql-relative-date-units)

## Delivered

| Metric | Value |
|--------|-------|
| Stories delivered | TBD -- F3 skipped for this scope (F1 gate approved F1→F2→F4→F5→F6→F7); F4 delta implementation is scoped directly off the F2 spec delta, not a story package |
| BCs created | 0 new; 2 amended (BC-2.1.008, BC-2.1.023 incl. EC-2.1.023-1), 1 new edge case pending in F2 |
| VPs created | TBD (F2) |
| Holdout scenarios | TBD (F2/F4) |
| Total cost | TBD |
| Adversarial passes | 0 so far (F5 not yet reached) |
| Final holdout satisfaction | N/A yet |
| Release version | rolls into next dev prerelease at close (no immediate tag) |

## Spec Changes

| Artifact | Change | Before | After |
|----------|--------|--------|-------|
| src/jql.rs::validate_duration | Reject unsupported JQL relative-date units `M` (month) and `y` (year) -- Jira rejects `-1y` etc. as invalid (400), per Perplexity/JRACLOUD-82707 verification (NOT the GitHub issue's original "empty result" claim) | Accepts M/y silently, producing a JQL string Jira later 400s on | Rejects M/y at validation time with an error pointing month/year users at `--created-after`/`--created-before` (CR-005 nit included) | 
| .factory/specs/prd/bc-2-issue-read.md | Amend BC-2.1.008, BC-2.1.023 (incl. EC-2.1.023-1); add new M/y-rejection edge case with corrected rationale | current prose | pending F2 |

## Living Spec Snapshot

Captured at: git tag (pending -- no tag yet this cycle)
Retrieve: N/A until F2 lands

## Deprecations (if any)

None.

## Tech Debt Created

None yet.

## Governance Policies Adopted

None yet.

## Notes

Adopts + completes external contributor PR #863 (fixes GitHub issue #859). Feature Mode, brownfield, intent bug-fix, severity MEDIUM, scope class standard (amends BC-documented prose + is a breaking change for any caller currently relying on M/y being silently accepted). Feature type: backend. Regression risk LOW-MEDIUM -- `validate_duration` has exactly 2 call sites (`src/cli/issue/list.rs:235,256`).

**Phase F1 (delta analysis): APPROVED** -- decision `D-373` (2026-09-22, human gate, this session). Human decisions at the F1 gate:
1. Scope APPROVED as F1→F2→F4→F5→F6→F7 (F3 incremental-stories phase skipped for this scope).
2. CR-005 nit INCLUDED -- the rejection error message will point month/year users at `--created-after`/`--created-before`.
3. CR-002 historical-docs stragglers WILL BE FIXED this cycle: `docs/superpowers/plans/2026-03-25-common-filter-flags.md`, `docs/superpowers/specs/2026-03-24-common-filter-flags-design.md`.
4. Versioning = ROLL INTO NEXT DEV PRERELEASE, no immediate tag at cycle close.

F1 artifacts: `phase-f1-delta-analysis/delta-analysis.md`, `phase-f1-delta-analysis/affected-files.txt`.

Next: F2 spec evolution.
