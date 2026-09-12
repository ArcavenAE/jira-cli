---
document_type: pipeline-state
level: ops
version: "4.18"
status: active
producer: state-manager
timestamp: 2026-09-12T01:00:00Z
phase: "ACTIVE 2026-09-11. cycle-007 (auth-correctness-dx) OPEN, Feature Mode. F1 APPROVED 2026-09-10 (DEC-354) -- 6-issue scope (#784/#786-narrowed/#787/#788/#790/#783); #785 DEFERRED. F2 APPROVED 2026-09-10 (DEC-355). F3 HUMAN GATE APPROVED 2026-09-11 (DEC-356) -- 5 new stories (28 points, 2 waves). F4 (delta implementation) IN PROGRESS -- Story A (S-cycle7-credential-absence-fix) MERGED PR #803 @ develop@08021685 (#784 closed; #786 manual-close pending). Story C (S-cycle7-oauth-help-text-fix) MERGED PR #805 @ develop@5b5b4432 (5-pass adversarial, 3 consecutive CLEAN; CI green; pr-reviewer APPROVE; #790 CLOSED). Story D (S-cycle7-readme-migration-note) CONVERGED 4-pass adversarial (3 consecutive CLEAN); PR #804 fully green; AWAITING human UI squash-merge (blocked by auto-mode permission gate). Story B1 (S-cycle7-auth-state-derivation) CONVERGED 11-pass adversarial (passes 9/10/11 CLEAN; human authorized past 10-pass ceiling); entering PR phase (rebase onto 5b5b4432, auth.rs = HIGH-criticality; branch feat/cycle7-auth-state-derivation HEAD ~4b751e3f). PG-C1 (pr-manager auto-merged #805 vs do-NOT-merge instruction) + PG-B1 (11-pass churn: incomplete-sweep/sibling-breakage) codified in lessons.md. NEXT: human merges #804; B1 PR in flight -> merge; then Wave 2 = B2 (auth-status-json). All six prior cycles (001-006) CLOSED. Full prior narrative: F1/F2/F3 Phase Progress rows + cycles/cycle-007/session-checkpoints.md."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-11, v4.18, state-manager -- WAVE-1-C-MERGED-D-READY-B1-CONVERGED: Story C PR #805 squash-merged to develop @ 5b5b4432 (#790 CLOSED; 5-pass adversarial). Story D CONVERGED 4-pass (3 consecutive CLEAN); PR #804 awaiting human UI merge. Story B1 CONVERGED 11 passes (passes 9/10/11 CLEAN; human authorized past 10-pass ceiling); entering PR (rebase onto 5b5b4432, HIGH-criticality auth.rs). develop tip 08021685->5b5b4432. PG-C1+PG-B1 codified. AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM + #804-AWAITING-HUMAN-UI-MERGE added. B1 demo-skip recorded. v4.17 checkpoint archived. Counts unchanged: total_bcs 757, VP 82, holdout 118, total_stories 180."
current_step: "D-chain cite D-053, D-2026 latest brownfield. F4-WAVE-1-IN-PROGRESS. trajectory-tail ->1->3->0->2 (Stories A+C merged to develop; F5 code-review loop not yet started). develop tip advanced to 5b5b4432 (PR #805 Story C squash-merge). Story D (docs/cycle7-readme-migration-note HEAD 800e67f1) PR #804 green 24/24 AWAITING human UI squash-merge. Story B1 (feat/cycle7-auth-state-derivation HEAD ~4b751e3f) CONVERGED 11 passes, entering PR (rebase onto 5b5b4432 first). NEXT: (1) human merges #804; (2) B1 PR creation + review + merge; then Wave 2 = B2 (S-cycle7-auth-status-json, depends on B1 merge)."
trajectory_tail: "->1->3->0->2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-007-auth-correctness-dx (F1 APPROVED via DEC-354; F2 APPROVED via DEC-355; F3 APPROVED via DEC-356; F4 delta implementation IN PROGRESS -- Stories A+C MERGED; D awaiting human UI merge PR #804; B1 CONVERGED entering PR; Wave 2 = B2 after B1 merge)"
feature_mode_bundle: "auth-correctness-dx: GitHub issues #784, #786 (narrowed), #787, #788, #790 (CLOSED Story C PR #805), #783 (6-issue F1-gate-approved scope); #785 DEFERRED"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: "SOH-ATTACHMENTS-1 CONVERGED + CLOSED 2026-07-25 (DEC-186, 5-dim PASS, MAXIMUM_VIABLE_REFINEMENT_REACHED); full text: cycles/CYCLE-SUMMARY.md#phase_3_status"
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 as v0.7.0-dev.3 (DEC-311). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_002_status"
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 as v0.7.0-dev.4 (PR #767). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_003_status"
cycle_004_status: "windows-correctness -- CLOSED + RELEASED 2026-09-06 as v0.7.0-dev.5 (DEC-343, PR #777). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_004_status"
cycle_005_status: "adf-mentions -- CLOSED, NO RELEASE, 2026-09-09 (DEC-353; closes GitHub #674; ships on develop @ cef4a021, tag deferred). F1-F7 all APPROVED; full text: cycles/CYCLE-SUMMARY.md#cycle_005_status"
cycle_006_status: "mutants-ci-sharding -- CLOSED, NO RELEASE, 2026-09-09 (DEC-348/349/350/351; CI-infra-only). F1-F7 all APPROVED; PR #791 merged to develop @ a9168212; full text: cycles/CYCLE-SUMMARY.md#cycle_006_status"
activation_head: "a9168212"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-11, WAVE-1-C-MERGED-D-READY-B1-CONVERGED v4.18):
     Story C MERGED PR #805 @ develop@5b5b4432 (#790 closed). Story D CONVERGED PR #804 awaiting human UI merge.
     Story B1 CONVERGED 11 passes entering PR. Skip Log +1 row (B1 demo). PG-C1+PG-B1 codified.
     Phase Progress rotated: F2-SPEC-EVOLUTION row evicted (oldest), WAVE-1-C-MERGED-D-READY-B1-CONVERGED added.
     Drift: AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM + #804-AWAITING-HUMAN-UI-MERGE added.
     Session Resume Checkpoint replaced (v4.17 archived). version: 4.17->4.18.
     soft target 200 lines; hard cap 500 lines. ~215 lines (estimated). margin from actual = 500-215 = 285 (headroom). -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **ACTIVE** -- cycle-007 (`auth-correctness-dx`) OPEN, Feature Mode; Phase F4 IN PROGRESS. Story A MERGED PR #803 @ `develop@08021685` (#784 closed; #786 manual close pending). Story C MERGED PR #805 @ `develop@5b5b4432` (5-pass adversarial, 3 consecutive CLEAN; **#790 CLOSED**). Story D CONVERGED; PR #804 green (24/24) AWAITING human UI squash-merge. Story B1 CONVERGED 11 passes (3 consecutive CLEAN 9/10/11), entering PR. F1/F2/F3 all APPROVED (DEC-354/355/356). |
| **trajectory-tail** | ->1->3->0->2 (Stories A+C merged; F5 code-review loop not yet started) |
| **Last Updated** | 2026-09-11, WAVE-1-C-MERGED-D-READY-B1-CONVERGED: Story C PR #805 @ `5b5b4432` (#790 closed). Story D CONVERGED PR #804 awaiting human UI merge. Story B1 CONVERGED 11 passes entering PR. PG-C1+PG-B1 codified. Prior: STORY-A-MERGED. Full history: `cycles/CYCLE-SUMMARY.md` |
| **Current Phase** | cycle-007 Phase F4 IN PROGRESS. Story D PR #804 awaiting human UI squash-merge. Story B1 (`feat/cycle7-auth-state-derivation` HEAD ~`4b751e3f`) entering PR (rebase onto `5b5b4432` first, HIGH-criticality auth.rs). Wave 2 = B2 (`S-cycle7-auth-status-json`) after B1 merge. |
| **Activation HEAD** | `a9168212` (unchanged -- no release tag cut; `develop`s real tip is `5b5b4432`) |

## Phase Progress (recent 8; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **F3-STORY-DECOMPOSITION-CYCLE-007** | **APPROVED (DEC-356)** | 2026-09-11 | Feature Mode F3, 11-pass adversarial convergence, human gate APPROVED | 5 new stories (28 points, 2 waves, acyclic B1->B2). **HUMAN GATE APPROVED 2026-09-11 (DEC-356)**. Detail: `cycles/cycle-007/phase-f3-stories/`. | 5 stories/28pts; story count 175->180. DEC-356 minted |
| **SESSION-WRAP-PAUSE-2026-09-11** | **COMPLETE** | 2026-09-11 | Session-lifecycle pause checkpoint, no quality gate | Paused cycle-007 at F4-start; regression-baseline sub-agent cleanly abandoned (re-runnable read-only). `pipeline:` ACTIVE -> PAUSED. | counts unchanged |
| **BOOKKEEPING-BURST-E2E-ADF-HEURISTIC-2026-09-11** | **COMPLETE** | 2026-09-11 | Bookkeeping only, no quality gate | Recorded `E2E-EDIT-FIELD-ADF-HEURISTIC` (LOW/non-blocking; deferred to next maintenance sweep). | counts unchanged; no DEC minted |
| **F4-BASELINE-GREEN-WAVE-1-STARTED-CYCLE-007** | **IN PROGRESS** | 2026-09-11 | Feature Mode F4 delta implementation; no gate yet | Resumed cycle-007 (PAUSED->ACTIVE). Baseline GREEN @ develop@`14e695ae`: 5,267/5,091/0/176. Wave-1 worktrees created. Story A delivery started. | counts unchanged (757/82/118/180) |
| **PASS4-F2-SPEC-SWEEP-BOOKKEEPING-2026-09-11** | **COMPLETE** | 2026-09-11 | Bookkeeping only, no quality gate | pass-4 F-2 spec sweep: equals-form propagation across BC-1.4.032/033/034. `AUTH-REMEDIATION-EQUALS-FORM-BROADER` recorded. | counts unchanged (757/82/118/180); no DEC minted |
| **STORY-A-STEP-4.5-CONVERGED-2026-09-11** | **CONVERGED** | 2026-09-11 | Step 4.5 per-story adversarial convergence | Story A CONVERGED: 9 passes (7/8/9 CLEAN). Scope: `load_api_token` credential-absence branches. PG-A1..A4 codified. | counts unchanged (757/82/118/180); no DEC minted |
| **STORY-A-MERGED-2026-09-11** | **MERGED** | 2026-09-11 | PR #803 squash-merge to `develop` @ `08021685` | Story A MERGED. ci-gate PASS (25). pr-reviewer APPROVE. security CLEAN. 3 CI fix cycles. Demo skipped. #784 closed; #786 manual close needed. `develop` tip `14e695ae`->`08021685`. | counts unchanged (757/82/118/180); no DEC minted |
| **WAVE-1-C-MERGED-D-READY-B1-CONVERGED-2026-09-11** | **IN PROGRESS** | 2026-09-11 | F4 Wave-1 progress checkpoint; no gate | Story C MERGED PR #805 @ `5b5b4432` (5-pass, 3 consecutive CLEAN; #790 closed). Story D CONVERGED (4-pass, 3 consecutive CLEAN); PR #804 green 24/24, AWAITING human UI merge. Story B1 CONVERGED 11 passes (passes 9/10/11 CLEAN; human authorized past 10-pass ceiling); entering PR (HIGH-criticality auth.rs). PG-C1 + PG-B1 codified. B1 demo skipped. `develop` tip `08021685`->`5b5b4432`. | counts unchanged (757/82/118/180); no DEC minted |

## Current Phase Steps

**cycle-007 (`auth-correctness-dx`) Phase F4 IN PROGRESS.** Story A MERGED PR #803 (`develop@08021685`; #784 closed; **#786 manual close required**). Story C MERGED PR #805 (`develop@5b5b4432`; 5-pass adversarial, 3 consecutive CLEAN; **#790 CLOSED**). Story D (`S-cycle7-readme-migration-note`) **CONVERGED** (4-pass adversarial, 3 consecutive CLEAN); PR #804 green 24/24; **AWAITING human UI squash-merge** (demo N/A doc-only; security review N/A no src/). Story B1 (`S-cycle7-auth-state-derivation`) **CONVERGED** (11 passes, 3 consecutive CLEAN passes 9/10/11; human authorized past 10-pass ceiling; demo skipped human decision); **entering PR** (rebase `feat/cycle7-auth-state-derivation` HEAD ~`4b751e3f` onto `develop@5b5b4432`; HIGH-criticality auth.rs -> full pr-reviewer + security-reviewer). **NEXT: (1) human merges PR #804 via GitHub UI; (2) B1 PR creation -> pr-reviewer -> security-reviewer -> merge; then Wave 2 = B2 (`S-cycle7-auth-status-json`).** F4 discipline: targeted `cargo test` only for TDD loop; full regression serial at story end; NEVER `cargo nextest` -- see `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`.

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-356 | cycle-007 F3 **HUMAN GATE APPROVED** 2026-09-11 -- 5-story decomposition (28 pts, 2 waves, acyclic B1->B2); A->B1 merge-order honored; `FIX-F6-A` deferral accepted. | Human reviewed F3 story-decomposition (CONVERGED 11 adversary passes) and made explicit approval ruling | F3 (gate) | 2026-09-11 | human (explicit F3-gate approval) |
| DEC-355 | cycle-007 F2 **HUMAN GATE APPROVED** 2026-09-10 -- 3 new BCs (BC-1.6.048/049/050) + 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 MINOR; authorized proceeding to F3. | Human reviewed F2 PRD delta (CONVERGED 10 adversary passes) and made explicit approval ruling | F2 (gate) | 2026-09-10 | human (explicit F2-gate approval) |
| DEC-354 | cycle-007 F1 **HUMAN GATE APPROVED** 2026-09-10 -- 6-issue scope: #784, #786 (narrowed), #787, #788, #790, #783; #785 DEFERRED. | Human reviewed F1 delta-analysis and made explicit scope-gate ruling | F1 (gate) | 2026-09-10 | human (explicit F1-gate approval) |
| DEC-353 | cycle-005 F7 **HUMAN GATE APPROVED / cycle CLOSED** 2026-09-09, **NO RELEASE**. 5-dim delta convergence PASS. Ships on `develop`; tag deferred. | Human reviewed 5-dim delta-convergence and explicitly approved closing without a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| (359 older decisions) | DEC-352 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-09 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**cycle-007 decisions detail (F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 APPROVED via DEC-356, F4 IN PROGRESS):** F1 delta-analysis: `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`; F2 PRD delta: `phase-f2-spec-evolution/cycle-007-prd-delta.md`; F3 stories: `cycles/cycle-007/phase-f3-stories/`; session checkpoints: `cycles/cycle-007/session-checkpoints.md`; F4 burst log: `cycles/cycle-007/burst-log.md`.

**cycle-005/006 decisions detail (Bursts 1-13 each, CLOSED 2026-09-09):** full per-burst narrative at `cycles/cycle-005/burst-log.md` and `cycles/cycle-006/burst-log.md` (both with Appendix).

## Skip Log

<!-- Full cycle-002/003/004 rows archived to cycles/HISTORY-SKIP-LOG.md; only the 2 most recent cycles rows are kept inline. -->

| Step | Skipped? | Justification |
|------|----------|----------------|
| DTU creation (cycle-005) | yes | `dtu_required: false` -- targets Jiras own REST API surface, not a cloned third-party service. |
| UX Spec (cycle-005) | yes | `jr` is CLI-only; no new UI surface -- `adf-mentions` is a write-path conversion feature only. |
| Demo recording (cycle-005, Wave 2) | yes | Human decision: demos skipped for `S-cycle5-mention-resolution-wiring` (backend/no-UI CLI). |
| F6 Kani formal verification (cycle-005) | yes | Not set up in repo; proptest substitution justified. 0-GAP. |
| F6 cargo-fuzz (cycle-005) | yes | Not set up in repo; proptest arbitrary-input substitution justified. 0-GAP. |
| F6 DTU adversarial testing / accessibility re-check (cycle-005) | yes | `dtu_required: false`; write-path ADF conversion, no UI surface. |
| DTU creation (cycle-006) | yes | `dtu_required: no` -- `mutants-ci-sharding` is CI-tooling only. |
| UX Spec (cycle-006) | yes | `jr` is CLI-only; CI-workflow/policy-doc change with no product UI surface. |
| F5/F6 dedicated artifact subdirectory (cycle-006) | not skipped, folded | Feature-mode F5/F6 evidence folded into F7s 5-dimensional convergence record (DEC-351). |
| Demo recording (cycle-007, Story A) | yes | Human decision: small two-branch error-classification / exit-code CLI change, no UI surface; cycle-005 backend/no-UI-CLI precedent. |
| Demo recording (cycle-007, Story B1) | yes | Human decision: `auth list` STATUS behavior exhaustively unit-tested + snapshot-pinned; multi-profile keychain-state demo setup impractical on Gatekeeper-fragile dev host; consistent with Story A demo-skip precedent. |

**NOT a skip (human-owned post-close):** Live-Jira E2E round-trip acceptance (`H-NEW-MENTION-009`, AC-017) is **DEFERRED by human decision**, not skipped -- see `cycles/OPEN-STANDING-ITEMS.md`.

Older rows (cycle-001 through cycle-004, historical): `cycles/HISTORY-SKIP-LOG.md`.

## Blocking Issues

**NONE OPEN.** Zero Blocking Issues remain open. cycle-007 OPEN, ACTIVE at F4 (Stories A+C MERGED; D awaiting human UI merge; B1 entering PR; Wave 2 pending); all six prior tracked cycles CLOSED. Resolved items: `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking: `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) OPEN, **ACTIVE**, F4 IN PROGRESS. Stories A+C MERGED (PRs #803+#805 @ `develop@5b5b4432`). Story D CONVERGED, PR #804 awaiting human UI merge. Story B1 CONVERGED (11 passes, 3 consecutive CLEAN), entering PR. Wave 2 = B2 pending B1 merge. F1 APPROVED via DEC-354, F2 via DEC-355, F3 via DEC-356. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Seven tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) OPEN, ACTIVE** at F4 IN PROGRESS. Stories A+C MERGED; D awaiting human UI merge; B1 entering PR; Wave 2 = B2 pending. `develop`s real tip is `5b5b4432`; `activation_head` stays `a9168212`. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing currently blocking. cycle-007 constraint (F1 HIGH regression risk on `src/api/auth.rs`, 3rd consecutive cycle; nextest unusable on dev host per `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`) carried in the Phase Progress row above.

## Session Resume Checkpoint

**Date:** 2026-09-11. **Pipeline: ACTIVE** (cycle-007 `auth-correctness-dx`, F4 delta implementation IN PROGRESS). **Position:** Stories A+C MERGED (PR #803 @ `develop@08021685`; PR #805 @ `develop@5b5b4432`; #784+#790 closed; #786 manual close pending). Story D (`S-cycle7-readme-migration-note`) CONVERGED (4-pass adversarial, 3 consecutive CLEAN); PR #804 fully green (24/24); AWAITING human UI squash-merge (demo N/A doc-only; security review N/A no src/). Story B1 (`S-cycle7-auth-state-derivation`) CONVERGED 11 passes (passes 9/10/11 CLEAN; human authorized past 10-pass ceiling; demo skipped human decision); entering PR phase: rebase `feat/cycle7-auth-state-derivation` HEAD ~`4b751e3f` onto `develop@5b5b4432`, HIGH-criticality auth.rs -> full pr-reviewer + security-reviewer. Wave 2 = B2 (`S-cycle7-auth-status-json`, depends on B1 merge) pending.

**NEXT** = (1) human merges PR #804 via GitHub UI squash-merge; (2) B1 PR creation (rebase onto `5b5b4432`) -> pr-reviewer + security-reviewer -> merge; (3) Wave 2 = B2 (`S-cycle7-auth-status-json`).

**Open action items:** `#786-MANUAL-CLOSE` (PR #803 merged to `develop` not `main`; confirm repo `Zious11/jira-cli`). `#804-AWAITING-HUMAN-UI-MERGE` (Story D PR fully green, blocked by auto-mode permission gate). `AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM` (LOW, non-blocking; `jr auth refresh --api-token` unconditional-notice overclaim; fold into future doc sweep).

**Convergence counter:** Story A MERGED (9 passes, demo skipped). Story C MERGED (5 passes, 3 consecutive CLEAN). Story D CONVERGED (4 passes, 3 consecutive CLEAN), awaiting PR #804 merge. Story B1 CONVERGED (11 passes, passes 9/10/11 CLEAN; demo skipped). trajectory-tail (`->1->3->0->2`) unchanged -- F5 not yet started. PG-C1 (pr-manager merge-authority boundary) + PG-B1 (incomplete-sweep/sibling-breakage) codified in `cycles/cycle-007/lessons.md`.

**WIP branch list:** `feat/cycle7-auth-state-derivation` (B1, needs rebase@`5b5b4432`).

**Resume command:** `/vsdd-factory:next-step` (human merges #804; B1 PR in flight -> merge; then Wave 2 = B2).

**Counts:** total_bcs 757 (unchanged); VP count 82 (unchanged); holdout scenarios 118 (unchanged); total_stories 180 (unchanged). Prior checkpoint (STATE.md v4.17): archived to `cycles/cycle-007/session-checkpoints.md`.

## Historical Content

Burst logs, adversary pass details, session checkpoints, and per-burst narrative for every cycle are in cycle files. Full inline descriptions: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md`.

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-20) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Bursts 1-22) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Bursts 1-22) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Bursts 1-13 + Appendix) |
| cycle-006 burst history | `cycles/cycle-006/burst-log.md` (Bursts 1-13 + Appendix) |
| cycle-007 F1 delta analysis + issue triage | `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`, `phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md`, `phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md` |
| cycle-007 F2 spec evolution | `phase-f2-spec-evolution/cycle-007-prd-delta.md`, `phase-f2-spec-evolution/cycle-007-verification-delta.md` |
| cycle-007 F3 incremental stories (5 new stories + wave artifacts) | `cycles/cycle-007/phase-f3-stories/` |
| cycle-007 F4 regression baseline | `phase-f4-implementation/regression-baseline.md` |
| cycle-007 session checkpoints | `cycles/cycle-007/session-checkpoints.md` |
| cycle-007 F4 burst log (Bursts 1-3) | `cycles/cycle-007/burst-log.md` |
| cycle-007 Story A Step-4.5 convergence (9 passes) | `cycles/cycle-007/adversarial-reviews/story-A-convergence.md` |
| cycle-007 Story C Step-4.5 convergence (5 passes, 3 consecutive CLEAN) | `cycles/cycle-007/adversarial-reviews/story-C-convergence.md` |
| cycle-007 Story B1 Step-4.5 convergence (11 passes, 3 consecutive CLEAN) | `cycles/cycle-007/adversarial-reviews/story-B1-convergence.md` |
| cycle-007 lessons (PG-A1..A4, PG-C1, PG-B1) | `cycles/cycle-007/lessons.md` |
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |
| E2E ADF-field heuristic research | `research/e2e-environment-adf-field-2026-09-11.md` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`#804-AWAITING-HUMAN-UI-MERGE`** -- ACTION REQUIRED. PR #804 (`docs/cycle7-readme-migration-note`) fully green (24/24, mergeStateStatus CLEAN) but BLOCKED from automated merge by the auto-mode permission gate. Human must perform the UI squash-merge. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`#786-MANUAL-CLOSE`** -- ACTION REQUIRED. PR #803 merged to `develop` (not `main`); GitHub `Closes #786` did not auto-close. Confirm repo URL (`Zious11/jira-cli`, NOT `drbothen/jira-cli`) before closing manually.
- **`AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM`** -- LOW, non-blocking. `jr auth refresh --api-token` doc comment (`src/cli/mod.rs`) has latent unconditional-notice overclaim (same class as Story C fix). Fix in future doc sweep. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`AUTH-REMEDIATION-EQUALS-FORM-BROADER`** -- LOW, non-blocking. `load_oauth_tokens` stale-keyring + `auth logout` strings still emit SPACE form. B1/B2 MUST emit equals-form. Candidate: fold into cycle-007 B1/B2. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking (pre-existing since cycle-004). DEC-356 EXPLICITLY ACCEPTED deferral. Target: future SELF-IMPROVEMENT/maintenance cycle.
- **`CYCLE-007-PARKED-BUNDLES`** -- 4 bundles PARKED: **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). Full triage: `phase-f1-delta-analysis/issue-triage-*.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap; candidate follow-up in vsdd-factory repo.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. PR #799 rebalance fix statically validated only; nightly must confirm.
- **`E2E-EDIT-FIELD-ADF-HEURISTIC`** -- LOW, non-blocking, test-infrastructure defect only. Deferred to next maintenance sweep.
- **`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`** -- LOW, non-blocking, dev-host-only. `cargo-nextest` UNUSABLE for full suite. NOT a CI issue. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- `STATE-MD-OVER-SOFT-TARGET` -- **RESOLVED 2026-09-10**. Subsequent bursts re-added transient overage -- tracked, not re-opened.

**RESOLVED this burst:** none (Wave-1 progress bookkeeping only).

**RESOLVED prior burst:** `CYCLE-007-F4-BASELINE-RERUN-PENDING` -- F4 regression baseline re-run successfully GREEN @ develop@`14e695ae`.

**RESOLVED prior bursts (moved to `cycles/RESOLVED-DRIFT-ITEMS.md`):** `MAINTENANCE-SWEEP-2026-09-10-MERGES-PENDING`, `CYCLE-007-F1-SCOPE-GATE-PENDING`, `CYCLE-007-F2-SCOPE-GATE-PENDING`.

All other standing debt -- full text preserved, nothing deleted: OPEN items at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items at `cycles/RESOLVED-DRIFT-ITEMS.md`.
