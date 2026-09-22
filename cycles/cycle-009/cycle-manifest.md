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
| BCs created | 0 new; 2 amended (BC-2.1.008, BC-2.1.023 incl. EC-2.1.023-1), 1 new edge case ADDED (EC-2.1.023-5) -- F2 COMPLETE, human-approved (D-374) |
| VPs created | 0 new -- verification-delta.md ruled NO new VP-NNN warranted; VP-UPDATED-RECENT-001 amended in place instead |
| Holdout scenarios | TBD (F2/F4) |
| Total cost | TBD |
| Adversarial passes | 0 so far (F5 not yet reached) |
| Final holdout satisfaction | N/A yet |
| Release version | rolls into next dev prerelease at close (no immediate tag) |

## Spec Changes

| Artifact | Change | Before | After |
|----------|--------|--------|-------|
| src/jql.rs::validate_duration | Reject unsupported JQL relative-date units `M` (month) and `y` (year) -- Jira rejects `-1y` etc. as invalid (400), per Perplexity/JRACLOUD 82707 verification (NOT the GitHub issue's original "empty result" claim) | Accepts M/y silently, producing a JQL string Jira later 400s on | Rejects M/y at validation time with an error pointing month/year users at `--created-after`/`--created-before`/`--updated-after`/`--updated-before` (CR-005 nit included) -- F4 scope, not yet coded |
| .factory/specs/prd/bc-2-issue-read.md | Amend BC-2.1.008 (Behavior), BC-2.1.023 (EC-2.1.023-1); add new EC-2.1.023-5 (M/y rejection + case-sensitivity boundary disposition) | pre-F2 prose | DONE in F2 -- canonical error string pinned byte-identical across 4 sites; file-local trace v1.5.1→v1.5.2, `total_bcs`/`definitional_count` unchanged 122/80 |
| .factory/spec-changelog.md | PATCH version bump, breaking-change entry | 2.3.1 | 2.3.2 -- DONE in F2 |
| .factory/cycles/cycle-009/phase-f2-spec-evolution/verification-delta.md | NO new VP-NNN; F7 Delta-Convergence Acceptance Gate defined (5 CR-004 assertions) | N/A (new file) | DONE in F2 |

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

**Phase F2 (spec evolution): APPROVED** -- decision `D-374` (2026-09-22, human gate, this session). product-owner amended `BC-2.1.008` (Behavior) + `BC-2.1.023` `EC-2.1.023-1` with the canonical error string (byte-identical across 4 pinned sites: `prd-delta.md`, `BC-2.1.008`, `EC-2.1.023-1`, `spec-changelog.md` 2.3.2 entry -- includes the CR-005 hint pointing month/year users at `--created-after`/`--created-before`/`--updated-after`/`--updated-before`); added new `EC-2.1.023-5` (M/y rejection, corrected rationale -- `M` silently mis-parsed as minutes server-side per Atlassian's DateUtils.getDuration Javadoc, `y` rejected HTTP 400, not issue `#859`'s original "empty result" claim -- plus a full client case-sensitivity boundary disposition table). `spec-changelog.md` PATCH bump 2.3.1→2.3.2, breaking-change flagged. `verification-delta.md` ruled NO new VP-NNN (amended `VP-UPDATED-RECENT-001` in place) and defined an explicit F7 Delta-Convergence Acceptance Gate (5 required CR-004 assertions).

Scoped adversary (fresh context) ran ITERATE (1 HIGH `F2-ADV-H1` case-sensitivity mischaracterization, 1 MEDIUM `F2-ADV-M1` unenforced no-new-VP reliance, 1 LOW `F2-ADV-L1` docs-straggler process gap) -- H1+M1 RESOLVED same burst, L1 DEFERRED to F4 per the prior CR-002 decision. CONVERGED -- zero findings above cosmetic remain. research-agent then ran a grounding audit confirming every JQL factual claim traces to a first-party Atlassian source; one ungrounded "30x" magnitude figure was dropped and replaced with a direct DateUtils.getDuration Javadoc citation. Both `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` verified exit 0 -- count-neutral, 0 new BC/VP.

Human APPROVED F2 as complete; noted one small pending F4 to-do -- tidy `BC-2.1.008`'s Behavior clause to add the same "(per Atlassian's DateUtils.getDuration Javadoc)" citation `EC-2.1.023-5`/`spec-changelog.md` now carry (cosmetic citation-consistency, human-approved for F4).

Committed to `factory-artifacts` across 3 commits: `858b4f47` (F2 spec evolution), `4e9d8a37` (adversary H1/M1 resolution), `45b49928` (grounding-audit correction).

F2 artifacts: `phase-f2-spec-evolution/prd-delta.md`, `phase-f2-spec-evolution/verification-delta.md`, `phase-f2-spec-evolution/adversarial-spec-delta-review.md`.

Next: F4 delta implementation (F3 skipped per D-373).
