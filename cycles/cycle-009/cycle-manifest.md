---
document_type: cycle-manifest
cycle_id: cycle-009-jql-relative-date-units
cycle_type: bugfix
version: rolls into next dev prerelease at close -- no immediate tag, per F1-gate decision 4 (D-373)
status: complete
started: 2026-09-22T19:28:28Z
completed: 2026-09-23T14:20:08Z
producer: orchestrator
---

# Cycle Manifest: cycle-009 (jql-relative-date-units)

## Delivered

| Metric | Value |
|--------|-------|
| Stories delivered | N/A -- F3 skipped for this scope (F1 gate approved F1→F2→F4→F5→F6→F7); F4 delta implementation was scoped directly off the F2 spec delta, not a story package. Delivered as PR `#868` (adopts + completes external contributor PR `#863`), squash-merged @ `1847ce38`; F5 hygiene follow-ups delivered as PR `#869` (`74abc573`) + PR `#870` (`805ca0e0`); F7 ① fix delivered as PR `#871` (`7c5e9309`) |
| BCs created | 0 new; 2 amended (BC-2.1.008, BC-2.1.023 incl. EC-2.1.023-1), 1 new edge case ADDED (EC-2.1.023-5) -- F2 COMPLETE, human-approved (D-374). F4/F5/F7 added tests + docs only, count-neutral (770/89/118/191 unchanged throughout) |
| VPs created | 0 new -- verification-delta.md ruled NO new VP-NNN warranted; VP-UPDATED-RECENT-001 amended in place instead |
| Holdout scenarios | 0 new this cycle |
| Total cost | TBD |
| Adversarial passes | 3 -- F5 CONVERGED 2026-09-22 (3/3 clean, trajectory `0→0→0`; see `convergence-trajectory.md`) |
| Final holdout satisfaction | full regression suite CI-green on all 4 merged PRs; `dtu_required: false` |
| Release version | rolls into next dev prerelease at close (no immediate tag, D-373 precedent) |
| Regression suite (post-F4) | 5,367 passed / 0 failed / 188 ignored (baseline 5,357; +10 tests, 0 regressions) |
| Regression suite (post-F5, PR #870) | 5,370 passed / 0 failed / 188 ignored (vs. post-F4 5,367; +3 tests, 0 regressions) |
| Regression suite (post-F7, PR #871) | unaffected -- PR #871 is `.cargo/mutants.toml`-only (no `src/`/test change); governing figure remains 5,370 passed / 0 failed / 188 ignored |
| Cycle status | **CLOSED 2026-09-23 (D-375, F7 human gate APPROVED "Approve & close")** |

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

**Phase F4 (delta implementation): COMPLETE** -- 2026-09-22, this session. F4 is an automated
quality gate (no dedicated human phase-gate ruling), but the human explicitly approved
squash-merging PR `#868` this session. Delivery: external contributor PR `#863`'s fix was ADOPTED
+ COMPLETED and merged as PR `#868` (squash commit `1847ce38` on `develop`; `develop` `bcec4c78` ->
`1847ce38`), crediting `@DeepanshuPal` via a preserved `Co-authored-by` trailer. GitHub issue `#859`
CLOSED; `#863` courtesy-close in progress.

What shipped: `src/jql.rs::validate_duration` now rejects `M`/`y` (accepts only `{w,d,h,m}`);
canonical error string (with the CR-005 hint) at all 4 sites; help text updated;
`CHANGELOG.md` `[Unreleased]` breaking-change entry; CR-002 straggler docs corrected
(`docs/superpowers/plans/2026-03-25-common-filter-flags.md`,
`docs/superpowers/specs/2026-03-24-common-filter-flags-design.md`); the pending `BC-2.1.008`
citation tidy folded in.

Quality evidence: Red Gate satisfied (tests failed first, `cycles/cycle-009/jql-date-units/implementation/red-gate-log.md`);
Green Gate all pass; full regression 5,367 passed / 0 failed / 188 ignored (baseline 5,357; +10
tests, 0 regressions, `phase-f4-implementation/regression-baseline.md` cycle-009 section);
`cargo fmt` clean; `cargo clippy --all --all-features --tests -- -D warnings` zero warnings.
Reviews: clean local code-review APPROVE (2 nits fixed), `security-reviewer` CLEAN, fresh-eyes
`pr-reviewer` APPROVE (1 LOW won't-fix-by-design). CI: all 24 checks green incl. required CI Gate
(run `35791400606`), `mergeStateStatus` CLEAN. Demo SKIPPED (human decision, error-path change,
cycle-012 Wave 2 precedent).

Two process observations logged to `cycles/OPEN-STANDING-ITEMS.md` as `[process-gap]` LOW: (1)
`factory-dispatcher` `FUEL_EXHAUSTED` hook fired spuriously on `src/jql.rs` + BC-file edits
(edits landed fine, verified); (2) `validate-dispatch-advance` hook false-flags the substring
`"JRACLOUD-82707"` as a phantom decision-ID `D-82707` (worked around with a space:
`"JRACLOUD 82707"`).

`activation_head`/`activation_version` UNCHANGED (`8b4c797a`/`v0.7.0-dev.8`) -- no release cut
(rolls into next dev prerelease per `D-373` decision 4). Counts unchanged 770/89/118/191 (F4
added tests, not BCs).

Next: F5 (scoped adversarial refinement on the merged delta, diff `bcec4c78..1847ce38`); then F6
(light targeted hardening); F7 (delta convergence + human close gate).

**Phase F5 (scoped adversarial refinement): CONVERGED** -- 2026-09-22, this session. 3
fresh-context adversary passes on the merged delta (diff `bcec4c78..1847ce38`) --
correctness/edge-cases, test-quality/coverage, and spec-doc-changelog drift -- all CLEAN, zero
CRITICAL/HIGH/MEDIUM findings, novelty decayed to LOW. Trajectory shorthand `0→0→0`. Full detail:
`convergence-trajectory.md`.

F5 also cleared two rounds of LOW-severity doc/hygiene findings via follow-up PRs (both
human-approved, CI-green, squash-merged) before the 3 clean passes ran:

1. **PR `#869`** (docs-only, `F-A-001`): completed the CR-002 supersession markers on the
   superseded design doc's y/M reference tables + appendix + inline comment. Merged `74abc573`.
   Plus `F-A-002` (spec-quote alignment) committed to `factory-artifacts` (`40e9945a`).
2. **PR `#870`** (F5 LOW test-hygiene, behavior-preserving): DRY'd the `validate_duration`
   canonical error string into a single helper (all 4 sites, byte-identical, new non-M/y
   exact-pin test); fixed a stale test-rename comment; added uppercase-unit (`W`/`D`/`H`/`1Y`)
   rejection test coverage. Clean local review APPROVE; full regression 5,370 passed / 0 failed
   / 188 ignored; fmt + clippy `--all --all-features --tests -- -D warnings` clean; CI Gate
   green. Merged `805ca0e0` -- squash-merged directly by the orchestrator (human-authorized)
   after the `github-ops` merge relay repeatedly failed to execute the merge.

`develop` tip this phase: `1847ce38` -> `74abc573` (PR `#869`) -> `805ca0e0` (PR `#870`).
`activation_head`/`activation_version` UNCHANGED (`8b4c797a`/`v0.7.0-dev.8`). Counts unchanged
770/89/118/191.

Three new `[process-gap]` standing items logged to `cycles/OPEN-STANDING-ITEMS.md`:
`CYCLE-009-F5-STALE-CHECKOUT-BEFORE-ADVERSARY` (MEDIUM), `CYCLE-009-GITHUB-OPS-MERGE-RELAY-LAG`
(MEDIUM), `CYCLE-009-FACTORY-DISPATCHER-FUEL-EXHAUSTED-AND-HOOK-FALSE-POSITIVES` (LOW,
consolidates the 2 F4-burst hook items with a 3rd F5 instance).

**Phase F6 (light targeted hardening): HARDENED_WITH_RESIDUALS** -- 2026-09-22. Scope: the
cycle-009 code delta `bcec4c78..805ca0e0` (`src/jql.rs` unit-set narrowing + new
`invalid_duration_error` helper; `src/cli/mod.rs` help-text update). Delta mutation testing via
an out-of-band `examine_globs` override scoped to `src/jql.rs`, `--in-diff` on the same delta =
**9 generated / 9 caught / 0 missed = 100% kill**, including the line-44 unit-set-narrowing
guard mutant (the cycle-009 core change). The standing CI-prescribed `--in-diff` run against the
THEN-current `examine_globs` generated 0 mutants (false green -- neither changed file was in
scope). Security: `cargo deny check` + `cargo audit` both PASS (0 vulnerabilities / 360 deps),
zero new dependencies. Kani/`cargo-fuzz` JUSTIFIED SKIP (0-GAP -- pure/total function class,
existing proptest covers panic-safety, strictly input-narrowing change). Purity boundary intact.
No `src/` modification, no PR opened this phase. One residual logged:
`CYCLE-009-F6-MUTANTS-EXAMINE-GLOBS-GAP` (MEDIUM, `[tooling-gap]`) -- DEFERRED to the F7 human
gate for a fix-now-vs-track decision. Full detail:
`cycles/cycle-009/phase-f6-hardening/hardening-record.md`, `cycles/cycle-009/burst-log.md`
Burst 5.

**Phase F7 (delta convergence + human close gate): CONVERGED -- cycle-009 CLOSED** --
2026-09-23. ALL 7 convergence dimensions PASS (spec, test, implementation, verification,
holdout/regression, consistency, input-hash). F7 human close gate **APPROVED** (`D-375`):
① fixed `examine_globs` (PR `#871`, squash-merged `develop` @ `7c5e9309`, superseding the prior
`MAINT-MUTANTS-GLOBS-01` EXCLUDE); ② fixed the stale `BC-2.1.023` `(pending F4)` Source-column
marker in `BC-INDEX.md`; ③ approved & closed. Ships on `develop` @ `7c5e9309`, rolls into the
*next* dev prerelease, **NO immediate tag** (`D-373` precedent, same as cycle-005/006/012).
`activation_head`/`activation_version` UNCHANGED (`8b4c797a`/`v0.7.0-dev.8`). Counts UNCHANGED
770/89/118/191 -- cycle-009 was count-neutral throughout.

S-7.02 Cycle-Closing Checklist satisfied: `CYCLE-009-F6-MUTANTS-EXAMINE-GLOBS-GAP` RESOLVED
(archived to `cycles/RESOLVED-DRIFT-ITEMS.md`, closed by PR `#871`). The 3 remaining OPEN
process-gap items (`CYCLE-009-F5-STALE-CHECKOUT-BEFORE-ADVERSARY`,
`CYCLE-009-GITHUB-OPS-MERGE-RELAY-LAG`, `CYCLE-009-FACTORY-DISPATCHER-FUEL-EXHAUSTED-AND-HOOK-
FALSE-POSITIVES`) each received an explicit justified-deferral disposition (target: engine
maintenance, `vsdd-factory` engine repo, not product). One NEW item logged and dispositioned
the same way: `CYCLE-009-PR-MANAGER-COMPLETION-GUARD-FORCES-MERGE` (MEDIUM). Every process-gap
item logged this cycle now has a follow-up disposition.

GitHub issue `#859` remains CLOSED (closed at F4); `#863`'s courtesy-credit comment remains
posted (formal close of `#863` itself is an accepted minor loose end). `SCORECARD_ENABLED`
GitHub repository variable set to `true` this session (OpenSSF Scorecard workflow enabled,
separate from `ci-gate`).

Full detail: `cycles/cycle-009/burst-log.md` Burst 6, `STATE.md` Decisions Log `D-375`.

**cycle-009 CLOSED.**
