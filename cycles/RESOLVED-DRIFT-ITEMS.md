# Resolved Drift / Standing Items (extracted from STATE.md)

> Extracted from `.factory/STATE.md`'s `## Blocking Issues`, `## Constraints
> Carried Forward`, and `## Drift / Standing Items` sections during the
> 2026-09-10 `/compact-state` compaction (v4.03 -> v4.04). Everything below
> is RESOLVED/CLOSED — kept for audit trail, not tracked as open debt.
> STATE.md keeps only a one-line pointer to this file.

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
