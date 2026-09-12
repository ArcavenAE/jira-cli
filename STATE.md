---
document_type: pipeline-state
level: ops
version: "4.20"
status: paused
producer: state-manager
timestamp: 2026-09-12T06:42:59Z
phase: "PAUSED 2026-09-12. cycle-007 (auth-correctness-dx) OPEN, Feature Mode. F1-F3 APPROVED (DEC-354/355/356). F4 Wave-1 INTEGRATION GATE PASSED (2026-09-11) -- all 4 Wave-1 stories (A/C/D/B1) merged to develop @ 33567e92. F4 Wave-2: Story B2 (S-cycle7-auth-status-json, BC-1.6.050) CONVERGED (6-pass, passes 4/5/6 CLEAN) + MERGED PR #807 @ develop@30bb1a18 (retires NFR-O-N; #787 closed). ALL 5 CYCLE-007 STORIES now merged to develop@30bb1a18 (PRs #803/805/804/806/#807; issues #784/#786/#787/#788/#790/#783 all closed). Wave-2 integration gate PENDING (develop@30bb1a18 push-CI run should be confirmed green on resume). F4 impl COMPLETE pending gate. NEXT (on resume): Wave-2 integration gate -> F4 COMPLETE -> F5 scoped adversarial -> F6 targeted hardening -> F7 delta convergence + human gate. All six prior cycles (001-006) CLOSED. Full prior narrative: F1/F2/F3 Phase Progress rows + cycles/cycle-007/session-checkpoints.md."
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-12, v4.20, state-manager -- SESSION-WRAP-PAUSE: cycle-007 F4 all 5 stories merged to develop@30bb1a18 (PRs #803/805/804/806/#807); Wave-2 integration gate PENDING; pipeline PAUSED. B2 demo skipped (human decision). #786 closed. Counts unchanged: total_bcs 757, VP 82, holdout 118, total_stories 180."
current_step: "D-chain cite D-053, D-2026 latest brownfield. SESSION-WRAP-PAUSE-2026-09-12. trajectory-tail →1→3→0→2 (all 5 cycle-007 stories merged to develop@30bb1a18; F5 scoped-adversarial loop not yet started). WAVE-2-B2-MERGED: Story B2 (S-cycle7-auth-status-json) CONVERGED 6-pass (passes 4/5/6 CLEAN) + MERGED PR #807 @ develop@30bb1a18 (BC-1.6.050, retires NFR-O-N; #787 closed). develop tip 33567e92->30bb1a18. ALL 5 CYCLE-007 STORIES MERGED. Wave-2 integration gate PENDING. Pipeline PAUSED for session wrap. NEXT = /vsdd-factory:rehydrate-wave then /vsdd-factory:next-step."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-007-auth-correctness-dx (F1 APPROVED via DEC-354; F2 APPROVED via DEC-355; F3 APPROVED via DEC-356; F4 ALL 5 STORIES MERGED -- A PR #803 @ 08021685, C PR #805 @ 5b5b4432, D PR #804 @ 24e6f5d1, B1 PR #806 @ 33567e92, B2 PR #807 @ 30bb1a18; Wave-2 integration gate PENDING)"
feature_mode_bundle: "auth-correctness-dx: GitHub issues #784, #786, #787, #788, #790 (CLOSED Story C PR #805), #783 (6-issue F1-gate-approved scope; ALL 6 CLOSED); #785 DEFERRED"
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

<!-- STATE.md SIZE BUDGET (2026-09-12, SESSION-WRAP-PAUSE v4.20):
     All 5 cycle-007 stories merged to develop@30bb1a18. Wave-2 integration gate PENDING. Pipeline PAUSED.
     Phase Progress rotated: BOOKKEEPING-BURST-E2E-ADF + F4-BASELINE-GREEN rows evicted; WAVE-2-B2-MERGED + SESSION-WRAP-PAUSE added.
     Session Resume Checkpoint replaced (v4.19 archived to cycles/cycle-007/session-checkpoints.md). version: 4.19->4.20.
     soft target 200 lines; hard cap 500 lines. 204 lines (wc-l). margin from soft-target = -4 (4 over soft); margin from actual = 296. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **PAUSED** -- cycle-007 (`auth-correctness-dx`) OPEN, Feature Mode; Phase F4 ALL 5 STORIES MERGED. develop@`30bb1a18`. Wave-2 integration gate PENDING. F1/F2/F3 all APPROVED (DEC-354/355/356). Wave-1 gate PASSED 2026-09-11 (4 stories, CI run `34668700676` GREEN). B2 MERGED PR #807 2026-09-12 (BC-1.6.050, retires NFR-O-N). |
| **trajectory-tail** | ->1->3->0->2 (all 5 stories merged; F5 scoped-adversarial loop not yet started) |
| **Last Updated** | 2026-09-12, SESSION-WRAP-PAUSE: all 5 cycle-007 stories merged to `develop@30bb1a18` (PRs #803/805/804/806/#807); Wave-2 integration gate PENDING; pipeline PAUSED. #786 closed. trajectory-tail →1→3→0→2. Full history: `cycles/CYCLE-SUMMARY.md` |
| **Current Phase** | cycle-007 Phase F4 IMPL COMPLETE (5/5 stories merged). Wave-2 integration gate PENDING. On resume: gate -> F4 COMPLETE -> F5/F6/F7. `develop` tip `30bb1a18`. |
| **Activation HEAD** | `a9168212` (unchanged -- no release tag cut; `develop`'s real tip is `30bb1a18`) |

## Phase Progress (recent 8; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **PASS4-F2-SPEC-SWEEP-BOOKKEEPING-2026-09-11** | **COMPLETE** | 2026-09-11 | Bookkeeping only, no quality gate | pass-4 F-2 spec sweep: equals-form propagation across BC-1.4.032/033/034. `AUTH-REMEDIATION-EQUALS-FORM-BROADER` recorded. | counts unchanged (757/82/118/180); no DEC minted |
| **STORY-A-STEP-4.5-CONVERGED-2026-09-11** | **CONVERGED** | 2026-09-11 | Step 4.5 per-story adversarial convergence | Story A CONVERGED: 9 passes (7/8/9 CLEAN). Scope: `load_api_token` credential-absence branches. PG-A1..A4 codified. | counts unchanged (757/82/118/180); no DEC minted |
| **STORY-A-MERGED-2026-09-11** | **MERGED** | 2026-09-11 | PR #803 squash-merge to `develop` @ `08021685` | Story A MERGED. ci-gate PASS (25). pr-reviewer APPROVE. security CLEAN. 3 CI fix cycles. Demo skipped. #784 closed; #786 manual close needed. `develop` tip `14e695ae`->`08021685`. | counts unchanged (757/82/118/180); no DEC minted |
| **WAVE-1-C-MERGED-D-READY-B1-CONVERGED-2026-09-11** | **IN PROGRESS** | 2026-09-11 | F4 Wave-1 progress checkpoint; no gate | Story C MERGED PR #805 @ `5b5b4432` (5-pass, 3 consecutive CLEAN; #790 closed). Story D CONVERGED (4-pass, 3 consecutive CLEAN); PR #804 green 24/24, AWAITING human UI merge. Story B1 CONVERGED 11 passes (passes 9/10/11 CLEAN); entering PR (HIGH-criticality auth.rs). PG-C1 + PG-B1 codified. | counts unchanged (757/82/118/180); no DEC minted |
| **WAVE-1-D-B1-MERGED-2026-09-11** | **MERGED** | 2026-09-11 | PR #804+#806 squash-merges to `develop` | Story D MERGED PR #804 @ `develop@24e6f5d1` (#804-AWAITING-HUMAN-UI-MERGE RESOLVED). Story B1 MERGED PR #806 @ `develop@33567e92` (#788 auto-closed; bc-1.6.048/049). `develop` tip `5b5b4432`->`33567e92`. | counts unchanged (757/82/118/180); no DEC minted |
| **WAVE-1-INTEGRATION-GATE-PASSED-CYCLE-007** | **PASSED** | 2026-09-11 | F4 Wave-1 integration gate (4-dimension): combined-tree CI green + wave adversarial 3 consecutive CLEAN + wave security CLEAN + all 8 MUST-PASS holdout scenarios satisfied | All 4 Wave-1 stories (A/C/D/B1) merged to `develop@33567e92`. CI run `34668700676` GREEN. Wave adversarial 3 CLEAN (coexistence, vocabulary coherence, CHANGELOG, no collision). Wave security CLEAN. FIX-F6-A OBS-2 appended. Wave 2 = B2 STARTING. | counts unchanged (757/82/118/180); no DEC minted |
| **WAVE-2-B2-MERGED-F4-IMPL-COMPLETE-2026-09-12** | **COMPLETE** | 2026-09-12 | F4 Wave-2 impl complete; Wave-2 integration gate PENDING | Story B2 (`S-cycle7-auth-status-json`, BC-1.6.050) CONVERGED (6-pass, passes 4/5/6 CLEAN; C-1 dispatch-arm mutants killed by default-CI test) + MERGED PR #807 @ `develop@30bb1a18` (retires NFR-O-N; #787 closed; 2 reviewers covered_sha `0992e5c8` APPROVE; security CLEAN). B2 demo skipped (human decision). ALL 5 cycle-007 stories now merged (`develop` tip `33567e92`->`30bb1a18`; issues #784/#786/#787/#788/#790/#783 all closed). Wave-2 integration gate PENDING. | counts unchanged (757/82/118/180); no DEC minted |
| **SESSION-WRAP-PAUSE-2026-09-12** | **COMPLETE** | 2026-09-12 | Bookkeeping only, session wrap; no quality gate | STATE.md v4.19->v4.20, pipeline ACTIVE->PAUSED. v4.19 checkpoint archived. All 5 stories merged @ develop@30bb1a18; Wave-2 integration gate PENDING; F5/F6/F7 on resume. | counts unchanged (757/82/118/180) |

## Current Phase Steps

**cycle-007 (`auth-correctness-dx`) Phase F4 IMPL COMPLETE -- PAUSED 2026-09-12.** All 5 cycle-007 stories merged to `develop@30bb1a18`: Story A PR #803 @ `08021685` (#784/#786 closed), Story C PR #805 @ `5b5b4432` (#790 closed), Story D PR #804 @ `24e6f5d1`, Story B1 PR #806 @ `33567e92` (#788 closed; BC-1.6.048/049), Story B2 PR #807 @ `30bb1a18` (#787 closed; BC-1.6.050, retires NFR-O-N). B2 demo skipped. Issue #783 also closed. **Wave-2 integration gate PENDING** (confirm develop@`30bb1a18` push-CI run green on resume). **NEXT (on resume)** = Wave-2 integration gate -> F4 COMPLETE -> F5 scoped adversarial -> F6 targeted hardening -> F7 delta convergence + human gate. Use `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-356 | cycle-007 F3 **HUMAN GATE APPROVED** 2026-09-11 -- 5-story decomposition (28 pts, 2 waves, acyclic B1->B2); A->B1 merge-order honored; `FIX-F6-A` deferral accepted. | Human reviewed F3 story-decomposition (CONVERGED 11 adversary passes) and made explicit approval ruling | F3 (gate) | 2026-09-11 | human (explicit F3-gate approval) |
| DEC-355 | cycle-007 F2 **HUMAN GATE APPROVED** 2026-09-10 -- 3 new BCs (BC-1.6.048/049/050) + 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 MINOR; authorized proceeding to F3. | Human reviewed F2 PRD delta (CONVERGED 10 adversary passes) and made explicit approval ruling | F2 (gate) | 2026-09-10 | human (explicit F2-gate approval) |
| DEC-354 | cycle-007 F1 **HUMAN GATE APPROVED** 2026-09-10 -- 6-issue scope: #784, #786 (narrowed), #787, #788, #790, #783; #785 DEFERRED. | Human reviewed F1 delta-analysis and made explicit scope-gate ruling | F1 (gate) | 2026-09-10 | human (explicit F1-gate approval) |
| DEC-353 | cycle-005 F7 **HUMAN GATE APPROVED / cycle CLOSED** 2026-09-09, **NO RELEASE**. 5-dim delta convergence PASS. Ships on `develop`; tag deferred. | Human reviewed 5-dim delta-convergence and explicitly approved closing without a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| (359 older decisions) | DEC-352 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-09 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**cycle-007 decisions detail (F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 APPROVED via DEC-356, F4 ALL 5 STORIES MERGED):** F1 delta-analysis: `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`; F2 PRD delta: `phase-f2-spec-evolution/cycle-007-prd-delta.md`; F3 stories: `cycles/cycle-007/phase-f3-stories/`; session checkpoints: `cycles/cycle-007/session-checkpoints.md`; F4 burst log: `cycles/cycle-007/burst-log.md`.

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
| Demo recording (cycle-007, Story B2) | yes | Human decision: output-only CLI change (`auth status --output json`); covered by default-CI success-path test + keyring-gated AC tests; keychain-state demo impractical on Gatekeeper-fragile host; consistent with A/B1 skips. |

**NOT a skip (human-owned post-close):** Live-Jira E2E round-trip acceptance (`H-NEW-MENTION-009`, AC-017) is **DEFERRED by human decision**, not skipped -- see `cycles/OPEN-STANDING-ITEMS.md`.

Older rows (cycle-001 through cycle-004, historical): `cycles/HISTORY-SKIP-LOG.md`.

## Blocking Issues

**NONE OPEN.** Zero Blocking Issues remain open. cycle-007 OPEN at F4 IMPL COMPLETE (pipeline PAUSED; Wave-2 integration gate PENDING on resume); all six prior tracked cycles CLOSED. Resolved items: `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking: `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) OPEN, **PAUSED**, F4 IMPL COMPLETE. All 5 stories merged to `develop@30bb1a18` (PRs #803/805/804/806/#807). Wave-2 integration gate PENDING (confirm develop@`30bb1a18` push-CI green on resume). F1 APPROVED via DEC-354, F2 via DEC-355, F3 via DEC-356. Wave-1 gate PASSED 2026-09-11. B2 CONVERGED (6-pass, 3 consecutive CLEAN) + MERGED. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Seven tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) OPEN, PAUSED** at F4 IMPL COMPLETE. Wave-2 integration gate PENDING. `develop`'s real tip is `30bb1a18`; `activation_head` stays `a9168212`. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing currently blocking. cycle-007 host constraint (`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`: nextest unusable on dev host) carries forward.

## Session Resume Checkpoint

**Date:** 2026-09-12. **Pipeline: PAUSED** (cycle-007 `auth-correctness-dx`, F4 IMPL COMPLETE). **Position:** All 5 cycle-007 stories merged to `develop@30bb1a18`: Story A PR #803 @ `08021685` (#784/#786 closed), Story C PR #805 @ `5b5b4432` (#790 closed), Story D PR #804 @ `24e6f5d1`, Story B1 PR #806 @ `33567e92` (#788 closed; BC-1.6.048/049), Story B2 PR #807 @ `30bb1a18` (#787 closed; BC-1.6.050, retires NFR-O-N). B2 demo skipped (human decision; consistent with A/B1 skips). Issue #783 also closed. Wave-2 integration gate PENDING (confirm develop@`30bb1a18` push-CI run green on resume).

**NEXT** = Wave-2 integration gate -> F4 COMPLETE -> F5 scoped adversarial -> F6 targeted hardening -> F7 delta convergence + human gate.

**Convergence counter:** N/A -- all per-story Step-4.5 convergence complete (A: 9 passes, C: 5 passes, D: 4 passes, B1: 11 passes, B2: 6 passes). Wave-1 integration gate PASSED 2026-09-11. Wave-2 integration gate not yet started. trajectory-tail `->1->3->0->2` unchanged (F5 scoped-adversarial loop not yet started for the 5-story combined tree).

**In-flight work:** NONE. No story worktrees remain (all merged + worktrees removed). No open cycle-007 PRs (all merged).

**Pending human decisions / blockers:** None blocking. Standing follow-ups still open: `AUTH-REMEDIATION-EQUALS-FORM-BROADER` (LOW; `load_oauth_tokens` + `auth logout` SPACE-form), `FIX-F6-A` (`auth.rs` mutation `examine_globs` + `mutants.toml` `derive_auth_state` comment OBS-2), `MUTANTS-NIGHTLY-VERIFY-FULL-RUN`, `E2E-EDIT-FIELD-ADF-HEURISTIC` (LOW, test-infrastructure only).

**WIP branch list:** NONE (all cycle-007 story branches merged + deleted).

**Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

**Counts:** total_bcs 757 (unchanged); VP count 82 (unchanged); holdout scenarios 118 (unchanged); total_stories 180 (unchanged). Prior checkpoint (STATE.md v4.19): archived to `cycles/cycle-007/session-checkpoints.md`.

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
| cycle-007 F4 burst log (Bursts 1-5) | `cycles/cycle-007/burst-log.md` |
| cycle-007 Story A Step-4.5 convergence (9 passes) | `cycles/cycle-007/adversarial-reviews/story-A-convergence.md` |
| cycle-007 Story C Step-4.5 convergence (5 passes, 3 consecutive CLEAN) | `cycles/cycle-007/adversarial-reviews/story-C-convergence.md` |
| cycle-007 Story D Step-4.5 convergence (4 passes, 3 consecutive CLEAN) | `cycles/cycle-007/adversarial-reviews/story-D-convergence.md` |
| cycle-007 Story B1 Step-4.5 convergence (11 passes, 3 consecutive CLEAN) | `cycles/cycle-007/adversarial-reviews/story-B1-convergence.md` |
| cycle-007 Story B2 Step-4.5 convergence (6 passes, passes 4/5/6 CLEAN) | `cycles/cycle-007/adversarial-reviews/story-B2-convergence.md` |
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

- **`AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM`** -- LOW, non-blocking. `jr auth refresh --api-token` doc comment (`src/cli/mod.rs`) has latent unconditional-notice overclaim (same class as Story C fix). Fix in future doc sweep. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`AUTH-REMEDIATION-EQUALS-FORM-BROADER`** -- LOW, non-blocking. `load_oauth_tokens` stale-keyring + `auth logout` strings still emit SPACE form. B2 emits equals-form per spec; broader remediation remains. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking (pre-existing since cycle-004). DEC-356 EXPLICITLY ACCEPTED deferral. OBS-2 (appended 2026-09-11): `.cargo/mutants.toml` comment mis-attributes `derive_auth_state` mutation coverage; B2 adds a 2nd `derive_auth_state` call site. Target: future SELF-IMPROVEMENT/maintenance cycle.
- **`CYCLE-007-PARKED-BUNDLES`** -- 4 bundles PARKED: **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). Full triage: `phase-f1-delta-analysis/issue-triage-*.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap; candidate follow-up in vsdd-factory repo.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. PR #799 rebalance fix statically validated only; nightly must confirm.
- **`E2E-EDIT-FIELD-ADF-HEURISTIC`** -- LOW, non-blocking, test-infrastructure defect only. Deferred to next maintenance sweep.
- **`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`** -- LOW, non-blocking, dev-host-only. `cargo-nextest` UNUSABLE for full suite. NOT a CI issue. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.

**RESOLVED this burst (2026-09-12):** `#786-MANUAL-CLOSE` -- GitHub issue #786 CLOSED (all 6 F1-scope issues now closed). All cycle-007 story worktrees removed + branches deleted post-merge.

**RESOLVED prior burst:** `#804-AWAITING-HUMAN-UI-MERGE` -- Story D PR #804 squash-merged. `CYCLE-007-F4-BASELINE-RERUN-PENDING` -- F4 baseline re-run GREEN.

**RESOLVED prior bursts (moved to `cycles/RESOLVED-DRIFT-ITEMS.md`):** `MAINTENANCE-SWEEP-2026-09-10-MERGES-PENDING`, `CYCLE-007-F1-SCOPE-GATE-PENDING`, `CYCLE-007-F2-SCOPE-GATE-PENDING`, `STATE-MD-OVER-SOFT-TARGET`.

All other standing debt -- full text preserved, nothing deleted: OPEN items at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items at `cycles/RESOLVED-DRIFT-ITEMS.md`.
