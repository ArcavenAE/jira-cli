# Resolved Drift / Standing Items (extracted from STATE.md)

> Extracted from `.factory/STATE.md`'s `## Blocking Issues`, `## Constraints
> Carried Forward`, and `## Drift / Standing Items` sections during the
> 2026-09-10 `/compact-state` compaction (v4.03 -> v4.04). Everything below
> is RESOLVED/CLOSED — kept for audit trail, not tracked as open debt.
> STATE.md keeps only a one-line pointer to this file.

## RESOLVED at cycle-012 F7 close (2026-09-15, v4.35 -- archived from STATE.md's "RESOLVED prior burst" slot during the v4.36->v4.37 CYCLE-007-F5-CONVERGED burst)

cycle-012 Phase F7 **HUMAN GATE APPROVED** -- "Approve & close" (DEC-361); release decision: ship on `develop`, NO TAG (cycle-005 precedent), changes ride `develop @ 80bb4215` into the next tagged release, CHANGELOG `[Unreleased]` entry already present. S-7.02 Cycle-Closing Checklist executed: every process-gap/novel finding is CODIFIED as a lesson (L-008 AC-012 channel wording; L-010 F5 integration-scope value; L-001..L-009 prior) or DEFERRED as tracked LOW debt with a maintenance-sweep target (`M-2`/`OBS-A`/`OBS-3`, pre-existing `SEC-001-EDITMETA-RECURSION-GUARD`) -- no open process-gap finding lacks a follow-up or justified deferral. **cycle-012 CLOSED.** Pipeline PAUSED/idle -- no active cycle; cycle-007 remains PAUSED (resumable). STATE.md v4.34->v4.35; `CYCLE-012-F7-APPROVED-CLOSED-2026-09-15` phase progress row appended (oldest row `CYCLE-012-F4-STARTED-2026-09-13` archived out to `cycles/HISTORY-PHASE-PROGRESS.md`, keeping the table at 10 rows). Prior Session Resume Checkpoint (v4.34) archived to `cycles/cycle-012/session-checkpoints.md`. `cycle_012_status` frontmatter field collapsed to a one-line CLOSED summary (mirroring `cycle_005_status`/`cycle_006_status`); full narrative routed to `cycles/CYCLE-SUMMARY.md#cycle_012_status`.

## RESOLVED/CLOSED at cycle-006 close (Burst 13, NOT deferrals)

- `F-PE-MED-001` -- **CLOSED.** The Precondition-3 M-1 empirical `--list`<=>pooled partition evidence is now captured durably in PR #791's merged body.
- `R-F2` -- **CLOSED, not a defect.** The story's planning estimate `EXPECTED_GUARD_TEST_COUNT` 38->65 (AC-031) was explicitly subject to F4 re-verification; the shipped value 75 is the reconciled truth.

## RESOLVED subsequently at cycle-005 Burst 6 (2026-09-09, NOT a deferral — one of the S-7.02 deferrals itself closed)

- `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS` -- **RESOLVED.** Both stale inline comments citing the retired "Check kill rate" step were fixed by standalone PR #793's diff, squash-merged to `develop` @ `5b00b31e`.

Full resolution detail (including the earlier 3-finding Step-4.5 arc): `cycles/cycle-006/blocking-issues-resolved.md`.

## E2E-CI dynamic-tests WIP (SESSION-WRAP PAUSE, 2026-09-10 — RESOLVED same day)

- `E2E-CI-DYNAMIC-TESTS-WIP-UNVERIFIED` -- **RESOLVED 2026-09-10.** Branch `test/e2e-dynamic-parent-editfield` @ `6bfc2a0a` (making the live `create --parent` + `edit --field` E2E tests self-configuring/dynamic) was confirmed NOT redundant with #796 (distinct area: dynamic-parent/editfield seeding, built atop #796's self-mention defaults). Rebased onto `develop`, exit-gates verified green (build/test-compile/clippy/fmt + offline guards), local code-reviewer CLEAN, and MERGED to `develop` @ `3a874d90` via PR #798. Worktree `.worktrees/E2E-DYNAMIC` and both local+remote branches cleaned up; local `develop` fast-forwarded to `3a874d90`.
- `E2E-DYNAMIC-WIP-REDUNDANCY-CHECK` -- **RESOLVED 2026-09-10.** See above -- WIP branch verified NOT redundant with #796, rebased+verified green, MERGED via PR #798 @ `3a874d90`; worktree and branches cleaned up.

## `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1`

**RESOLVED/CLOSED** at cycle-005 Burst 10 (Wave 2 merge). The DEC-347 F3-approved 2-wave decomposition accepted an interim-shippability-window tradeoff (Wave 1 merged ahead of Wave 2); this was closed once Wave 2 (`S-cycle5-mention-resolution-wiring`, PR #794) merged, completing cycle-005 Phase F4.

## Historical narrative — Constraints Carried Forward (as it stood in STATE.md v4.03, all now historical/closed)

**cycle-005 (CLOSE + NO RELEASE, DEC-353, Burst 13, historical):** Phase F7 (delta convergence) reached a 5-dimensional PASS on the combined Wave 1+Wave 2 `adf-mentions` delta and the human **APPROVED cycle-005's CLOSE at the F7 gate, with NO release cut** -- feature ships on `develop @ cef4a021` unreleased, tag deferred to a future release riding cycle-005 + cycle-006. **cycle-005 (`adf-mentions`, GitHub #674) is CLOSED.** ALL SIX tracked cycles (001-006) are now CLOSED -- no OPEN cycle remains in the factory; pipeline stays ACTIVE (idle). S-7.02 cycle-closing checklist: human chose RECORD DEFERRALS ONLY, no follow-up stories opened -- see `cycles/OPEN-STANDING-ITEMS.md` for the consolidated cycle-005 CLOSE deferral set. A discovered process-gap, `CYCLE5-BURST12-LOG-GAP`, is tracked (not fixed): the F6-hardening burst was never appended as a discrete Burst 12 entry to `cycles/cycle-005/burst-log.md`. Full detail: `cycles/cycle-005/burst-log.md` Burst 13.

**cycle-005 (earlier F1-F6 detail, historical):** F1 **APPROVED** (DEC-344, Burst 1); F2-gate **TIGHTENING** + **APPROVED** (DEC-345/DEC-346, Burst 2); F3 **APPROVED** (DEC-347, Burst 3, 2-wave decomposition, accepted interim-shippability-window tradeoff, RESOLVED at Burst 10). Wave 1 (`S-cycle5-mention-pure-conversion`) implemented, per-story adversarially converged, PR #778 opened (Burst 4), then **MERGED** via the >120-mutant escape-hatch **ADMIN-BYPASS** (**DEC-352**, Burst 5) @ `708c8b32`. Standalone maintenance PR #793 merged @ `5b00b31e` (Burst 6, no DEC). SESSION-WRAP PAUSE / resume (Bursts 7-8, no DEC): `pipeline:` ACTIVE->PAUSED->ACTIVE; Wave 2 dispatched. Wave 2's Step-4.5 per-story adversarial convergence ACHIEVED (Burst 9, 4 passes, HEAD `9dc0b098`, no DEC, no version bump). Wave 2 **MERGED** via PR #794 (squash) @ `0eaf4268` (Burst 10, NORMAL merge, no escape-hatch) -- **cycle-005 Phase F4 (delta implementation) COMPLETE**, both waves merged; `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` RESOLVED/CLOSED. Phase **F5 (scoped adversarial refinement) CONVERGED** (Burst 11, no DEC) -- 3 consecutive clean-tier passes; Pass 1's F-M1 [MED]/F-L1 [LOW] FIXED via fix-PR `FIX-F5-001`/PR #795 @ `cef4a021`. Phase **F6 (targeted hardening) COMPLETE/HARDENED** (Burst 12, no DEC) -- VP-674-001..021 coverage mapping, 20/21 fully COVERED, VP-674-005 documented deferred/unreachable residual; mutation posture GREEN on PR #794/#795 with zero escalation; Kani/cargo-fuzz JUSTIFIED-SKIP (0-GAP); report `phase-f6-hardening/cycle-005/hardening-report.md`. Full per-burst detail preserved verbatim in `cycles/cycle-005/burst-log.md` Bursts 1-12 and `cycles/cycle-005/session-checkpoints.md` (v3.75-v3.78, v3.92-v3.98 archives).

**cycle-006 (CLOSE + NO RELEASE, DEC-351, Burst 13, historical):** F7 (delta convergence) reached a 5-dimensional PASS and the human **APPROVED cycle-006's CLOSE at the F7 gate, with NO release cut**. **cycle-006 (`mutants-ci-sharding`) is CLOSED.** Full detail: `cycles/cycle-006/burst-log.md` Bursts 1-13.

**cycle-006 (earlier F1-F4 detail, historical):** F1 **APPROVED** (DEC-348, Burst 1); F2 **APPROVED at the gate** (DEC-349, Burst 3); F3 **APPROVED at the gate** (DEC-350, Bursts 4-8); F4 (Bursts 9-12) reached Step-4.5 3-consecutive-clean, then delivered + merged via PR #791 to `develop` @ `a9168212`. Full per-round/per-burst detail preserved verbatim in `cycles/cycle-006/burst-log.md` (Bursts 1-13) and `cycles/cycle-006/session-checkpoints.md` (v3.79 through v3.91 archives).

**SESSION-WRAP PAUSE (2026-09-10, no DEC minted, historical):** The pipeline was PAUSED via a single atomic burst (TD-VSDD-053) -- a RETRY of a stalled prior wrap attempt whose changes had never landed (STATE.md was still v3.99/ACTIVE, no pause marker, no `factory(pause)` commit). `pipeline:` ACTIVE->PAUSED. All six tracked cycles remain CLOSED, historical, unmodified. This session (spanning cycle-005's F4 Wave 2 merge through F7 close, plus this pause) additionally started a small E2E-CI test-infra follow-up making the live `create --parent` and `edit --field` E2E tests self-configuring/dynamic, superseding the earlier static-env-var plan -- COMMITTED-BUT-UNVERIFIED on pushed branch `test/e2e-dynamic-parent-editfield` @ `6bfc2a0a` at the time of the pause, subsequently RESOLVED via PR #798 (see above). Concurrent uncommitted STATE.md hook-timestamp churn plus benign `regression-state.json`/`sidecar-learning.md` churn was reconciled into the pause Write/commit.

**MUTANTS-NIGHTLY-REBALANCE-2026-09-10 (no DEC minted, historical narrative — the follow-up item itself, `MUTANTS-NIGHTLY-VERIFY-FULL-RUN`, remains OPEN in STATE.md):** Investigated, at human request, the first scheduled nightly mutation run (GitHub Actions run `34478602590`, 2026-09-10), which ended `cancelled` -- only 4 of 16 shards finished within the `timeout-minutes: 240` job cap, and the report pooled the resulting PARTIAL data into an untrustworthy "88% / below-90%" warning with no completeness signal. Fix delivered via **PR #799** (merged to `develop` @ `78aeb86c`): `.github/workflows/mutants-nightly.yml` rebalanced N=16->24 shards + `timeout-minutes` 240->300 (per-mutant `--timeout 240` unchanged), plus a completion-sentinel guard (writes a sentinel only on genuine `cargo mutants` success, reports "N/24 completed" against `EXPECTED_SHARDS=24`, marks partial runs, suppresses the below-90% warning when incomplete). The advisory-only never-fail invariant on this nightly job is preserved. Docs updated (`docs/specs/cargo-mutants-policy.md`, `CHANGELOG.md [Unreleased]`); local code-reviewer CLEAN; actionlint/shellcheck/YAML-parse validation green. Pipeline stays PAUSED throughout; no phase transition, no cycle change. This is distinct from cycle-006's IN-DIFF sharded mutation GATE (the required, blocking `ci-gate` check exercised by PR #778/#794/#795) -- `mutants-nightly.yml` is the separate, advisory, FULL-SCOPE nightly run, unaffected in gating behavior by this fix.

## STATE-MD-OVER-SOFT-TARGET

**RESOLVED 2026-09-10** by this compaction itself (`/compact-state`, v4.03 -> v4.04): STATE.md reduced from 447 lines to under the 200-line soft target via extraction of historical content into this file and its siblings under `cycles/`.

## Cycle-005 S-7.02 doc-hygiene deferrals — RESOLVED at MAINTENANCE-SWEEP-2026-09-10

Fixed by spec-steward directly in the MAINTENANCE-SWEEP-2026-09-10 single-commit burst (guards `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` both green after the fix; counts unchanged 754/76/118/175; no DEC minted -- maintenance-mode doc-hygiene, not a spec revision).

- `CYCLE5-F7-DOC-1` -- **RESOLVED 2026-09-10.** `phase-f2-spec-evolution/verification-delta-674.md`'s VP-674-005 section, which still read F2-era "UNPROVEN" prose, received the F6 closure note: the decidable half of the empirical-schema question was resolved via AC-015 (Atlaskit `adf-schema` mark-composition rule pinned as an example anchor in `src/adf.rs::tests`), and the residual sub-case (a mention node lacking `attrs.text` reaching the mark-composition path) is documented UNREACHABLE -- BC-X.7.010's mandatory preflight always populates `attrs.text` on a bracket-form mention before conversion.
- `CYCLE5-F7-DOC-2` -- **RESOLVED 2026-09-10.** `specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` received a new §7a post-#795 implementation note documenting the `is_at_name_boundary` / `is_mention_boundary` boundary-character-set split introduced by `FIX-F5-001` (PR #795, commit `cef4a021`): the `@Name` detection path's boundary function excludes `]` from its opener boundary set (unlike the bracket-form path's function, which retains it), preventing misdetection of an `@` immediately following a closing bracket as a legitimate `@Name` opener.
- `CYCLE5-STEP45-LOW-1` (= `CYCLE5-W2-LOW-1-SPEC-PROSE`) -- **RESOLVED 2026-09-10.** `specs/prd/cross-cutting.md`'s BC-X.7.007 point 2 prose was clarified to spell out the exact-match-precedence-then-substring-fallback order explicitly: a case-insensitive exact match on `display_name` takes precedence and, when present, is the sole basis for keeping a candidate; only when no candidate exact-matches does the filter fall back to `partial_match`'s substring check. The implementation was already correct and faithful to the mandated `partial_match` reuse -- only the spec wording was unclear.

Full sweep detail: `.factory/maintenance/sweep-report-2026-09-10.md`.

## `MAINTENANCE-SWEEP-2026-09-10-MERGES-PENDING` — RESOLVED 2026-09-10 (same day)

**RESOLVED 2026-09-10.** All 4 human-gated merges from MAINTENANCE-SWEEP-2026-09-10 (`#800` chacha20 0.10.0->0.10.2 fix, `#801` README/CLAUDE.md doc-sync, `#779` `action-gh-release` 3.0.3 Dependabot bump, `#754` `codeql` 4.37.9 Dependabot bump) landed on `develop` by human action, same day as the sweep closed. `develop` tip advanced `78aeb86c` -> `14e695ae`:

| PR | Merge SHA |
|----|-----------|
| #779 | `211ae959` |
| #754 | `d4760cd5` |
| #800 | `522f9ba2` |
| #801 | `14e695ae` |

Sweep is fully closed with zero outstanding actions. `activation_head` frontmatter stays `a9168212` unchanged (no release tag cut). No DEC minted -- maintenance-mode bookkeeping only.

## RESOLVED at cycle-007 Wave-2 gate (2026-09-15, v4.36 -- archived from STATE.md's "RESOLVED prior burst" slot during the v4.37->v4.38 CYCLE-007-F7-CONVERGED burst)

cycle-007 (`auth-correctness-dx`) Wave-2 integration gate **PASSED** -- regression GREEN (`auth_status_json` 31/0, lib `auth` 270/0, `auth_profiles` 46/0 on `develop@80bb4215`); Wave-2 adversarial 3 consecutive CLEAN passes (A/B/C), zero CRIT/HIGH/MED; Wave-2 security CLEAN (1 LOW accepted); consistency PASS; holdout `H-W2-INT-001` satisfied structurally. **cycle-007 Phase F4 COMPLETE** (all 5 stories merged, both wave gates PASSED). New LOW standing item `CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE` recorded; `NFR-O-N-CATALOG-RETIREMENT-EDIT` confirmed already present (commit `bb0e1a9d`), not duplicated. No DEC minted (bookkeeping/automated gate, Wave-1-gate precedent). Full detail archived: `cycles/cycle-007/burst-log.md` Burst 5.

## RESOLVED at cycle-007 Phase F5 (2026-09-15, v4.37 -- archived from STATE.md's "RESOLVED prior burst" slot during the v4.38->v4.39 CYCLE-007-F7-APPROVED-CLOSED-RELEASED burst)

cycle-007 (`auth-correctness-dx`) Phase F5 scoped adversarial refinement **CONVERGED** -- adversary 4
rounds to 3 consecutive CLEAN, zero unresolved CRIT/HIGH/MED; code-reviewer `APPROVE_WITH_NITS`
(CR-002/CR-003 RESOLVED; CR-001/CR-004 human-DEFERRED); security-reviewer CLEAN throughout. Findings
closed via fix PR #814 (`11c95d5e`) + commits `0b9fb1fc`/`878ebe67`. 7 new LOW standing items recorded.
No DEC minted (automated gate, cycle-012-F5 precedent). Full detail archived:
`cycles/cycle-007/burst-log.md` Burst 6.

## RESOLVED at cycle-007 Phase F6/F7 (2026-09-15, v4.38 -- archived from STATE.md's "RESOLVED prior burst" slot during the v4.39->v4.40 CYCLE-013-F1-F2-APPROVED burst)

cycle-007 (`auth-correctness-dx`) Phase F6 targeted hardening **HARDENED_WITH_RESIDUALS** and Phase F7
delta convergence **ALL 7 DIMENSIONS PASS** both recorded (F6's evidence had already been committed at
`596ec950` in a prior burst but STATE.md had not yet reflected it; F7 was freshly run that burst). F6:
all 6 VPs (VP-AUTHDX-024..029) covered, no uncovered axis; Kani/fuzz proptest-substitution JUSTIFIED
(0-GAP); mutation gate GREEN in CI; 366 auth tests pass; security CLEAN; 3 LOW residuals (R1
keyring-gated human-text, R2 `auth.rs` outside `examine_globs`, R3 = already-tracked
`CYCLE-007-CR-001-KEYCHAIN-ERROR-VS-ABSENCE`). F7: fresh-context consistency-validator PASS on all 7
dimensions. Job A hygiene: 6 cycle-007 F3 artifacts had BENIGN input-hash drift, re-hashed via
`compute-input-hash --update` in topological order; cycle-007 drift narrowed to the accepted
`[live-state]` sentinel class only. No DEC minted that burst (automated gate, cycle-012 F6/F7-CONVERGED
precedent). Full detail archived: `cycles/cycle-007/burst-log.md` Burst 7.

## RESOLVED at cycle-007 F7 human-gate closure + v0.7.0-dev.6 release (2026-09-15, v4.39 -- archived from STATE.md's "RESOLVED prior burst" slot during the v4.40->v4.41 CYCLE-013-F3-APPROVED burst)

cycle-007 (`auth-correctness-dx`) Phase F7 **HUMAN GATE APPROVED** -- human ruled "Approve & close" and
explicitly chose to **cut a dev release** (DEC-362). Release executed via this repo's native
release-metadata-PR precedent (not the vsdd-factory release skill): PR #815
(`chore/release-v0.7.0-dev.6` -> `develop`) merged squash @ `7160a534`, mergedAt
2026-09-15T14:53:32Z, all CI green, local review clean; annotated tag `v0.7.0-dev.6` pushed on
`7160a534` (dev.5 topology -- tagged on `develop`, not promoted to `main`); `release.yml` run
`34984900326` BUILDING the 5-platform prerelease (not yet published as of that write). Version
bump `0.7.0-dev.5`->`0.7.0-dev.6`; CHANGELOG `[Unreleased]` promoted to `[0.7.0-dev.6] -
2026-09-15`. dev.6 ROLLS UP all previously-untagged `develop` changes since dev.5: cycle-005
(`adf-mentions`), cycle-006 (`mutants-ci-sharding`), the 2026-09-10 maintenance sweep, cycle-012
(`field-adf-autoconvert`), and cycle-007 + the rustls 0.23.45 security bump -- the first tagged
prerelease to capture cycle-005 and cycle-012's changes. S-7.02 Cycle-Closing Checklist CONFIRMED
SATISFIED: all 8 cycle-007 process-gap/novel findings DEFERRED as tracked standing items in
`cycles/OPEN-STANDING-ITEMS.md`, none left uncovered; no new deferrals invented. **cycle-007
CLOSED.** cycle-012 remains CLOSED (DEC-361), unaffected beyond now sharing the release. **All
nine tracked cycles (001-007, 012) now CLOSED.** Pipeline fully idle/paused at that point.
`activation_head` -> `7160a534`; `activation_version` -> `v0.7.0-dev.6`.
