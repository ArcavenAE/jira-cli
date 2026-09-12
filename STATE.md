---
document_type: pipeline-state
level: ops
version: "4.22"
status: paused
producer: state-manager
timestamp: 2026-09-12T20:15:25Z
phase: "PAUSED 2026-09-12. cycle-012 (field-adf-autoconvert) OPEN, Feature Mode, Phase F2 spec-evolution mid adversarial convergence (10 passes run, 0 consecutive clean; need 3). F1 APPROVED DEC-357. cycle-007 (auth-correctness-dx) also PAUSED at F4 IMPL COMPLETE (Wave-2 integration gate PENDING, develop@30bb1a18)."
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-12, v4.22, state-manager -- SESSION-WRAP-PAUSE: cycle-012 F2 adversarial-convergence in progress (10 passes, streak 0/3); pipeline ACTIVE->PAUSED. F2 artifacts committed (12 BCs, 4 VPs, ADR-0024). cycle-007 remains PAUSED at F4."
current_step: "SESSION-WRAP-PAUSE-2026-09-12. cycle-012 F2 adversarial convergence in progress: 10 passes, streak 0/3. Pass-10 architect fixes (F-1 marker side-channel, F-3 bare-only fail-open, §5 item 2) written to verification-delta + ADR-0024. PENDING product-owner pass-10 BC fixes (F-2 BC-3.4.035, F-3 EC-3.8.019-2/020-5) then fresh pass 11. NEXT = /vsdd-factory:rehydrate-wave then /vsdd-factory:next-step."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-012-field-adf-autoconvert (F2 adversarial convergence in progress: 10 passes, streak 0/3). cycle-007 auth-correctness-dx PAUSED: F4 IMPL COMPLETE, Wave-2 gate PENDING, develop@30bb1a18."
feature_mode_bundle: "field-adf-autoconvert: addresses E2E-EDIT-FIELD-ADF-HEURISTIC / test_e2e_issue_edit_custom_field pre-existing defect (confirmed pre-cycle-007 @ 14e695ae)"
cycle_012_status: "field-adf-autoconvert -- OPEN, Feature Mode, F2 adversarial spec-convergence in progress (10 passes, streak 0/3). 12 BCs + 4 VPs + ADR-0024 produced. PENDING: pass-10 BC fixes (BC-3.4.035, EC-3.8.019-2/020-5), then pass 11, then 3-clean streak, then F2 human gate. Spec bump 2.3.0->2.4.0 produced in F2."
cycle_007_status: "auth-correctness-dx -- PAUSED at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@30bb1a18). F1 APPROVED DEC-354, F2 APPROVED DEC-355, F3 APPROVED DEC-356. All 5 stories merged (PRs #803/805/804/806/#807). Resumable after cycle-012 closes."
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

<!-- STATE.md SIZE BUDGET (2026-09-12, SESSION-WRAP-PAUSE v4.22):
     cycle-012 F2 adversarial-convergence in progress (10 passes, streak 0/3). pipeline PAUSED.
     F2 artifacts (12 BCs, 4 VPs, ADR-0024) committed. counts reconciled to 769 BCs/86 VPs.
     Session Resume Checkpoint replaced (v4.21 archived to cycles/cycle-012/session-checkpoints.md). version: 4.21->4.22.
     soft target 200 lines; hard cap 500 lines. 205 lines (wc-l). margin from soft-target = -5 (5 over soft); margin from actual = 295. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **PAUSED** -- cycle-012 (`field-adf-autoconvert`) OPEN, Feature Mode, Phase F2 spec-evolution, 10 adversarial passes (streak 0/3). cycle-007 (`auth-correctness-dx`) **PAUSED** at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@`30bb1a18`). |
| **trajectory-tail** | →1→3→0→2 (cycle-012 F2 adversarial convergence in progress) |
| **Last Updated** | 2026-09-12, SESSION-WRAP-PAUSE: cycle-012 F2 adversarial-convergence PAUSED (10 passes, streak 0/3); F2 artifacts committed 769 BCs/86 VPs; pipeline PAUSED. |
| **Current Phase** | cycle-012 Phase F2 spec-evolution (adversarial convergence 10 passes, streak 0/3). cycle-007 Phase F4 IMPL COMPLETE (PAUSED). |
| **Activation HEAD** | `a9168212` (unchanged; `develop`'s real tip is `30bb1a18`) |

## Phase Progress (recent 8; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **STORY-A-MERGED-2026-09-11** | **MERGED** | 2026-09-11 | PR #803 squash-merge to `develop` @ `08021685` | Story A MERGED. ci-gate PASS (25). pr-reviewer APPROVE. security CLEAN. 3 CI fix cycles. Demo skipped. #784 closed; #786 manual close needed. `develop` tip `14e695ae`->`08021685`. | counts unchanged (757/82/118/180) |
| **WAVE-1-C-MERGED-D-READY-B1-CONVERGED-2026-09-11** | **IN PROGRESS** | 2026-09-11 | F4 Wave-1 progress checkpoint; no gate | Story C MERGED PR #805 @ `5b5b4432` (#790 closed). Story D CONVERGED (4-pass, 3 consecutive CLEAN). Story B1 CONVERGED 11 passes (9/10/11 CLEAN). PG-C1 + PG-B1 codified. | counts unchanged (757/82/118/180) |
| **WAVE-1-D-B1-MERGED-2026-09-11** | **MERGED** | 2026-09-11 | PR #804+#806 squash-merges to `develop` | Story D MERGED PR #804 @ `develop@24e6f5d1`. Story B1 MERGED PR #806 @ `develop@33567e92` (#788 auto-closed; BC-1.6.048/049). `develop` tip `5b5b4432`->`33567e92`. | counts unchanged (757/82/118/180) |
| **WAVE-1-INTEGRATION-GATE-PASSED-CYCLE-007** | **PASSED** | 2026-09-11 | F4 Wave-1 integration gate (4-dimension): combined-tree CI green + wave adversarial 3 consecutive CLEAN + wave security CLEAN + all 8 MUST-PASS holdout scenarios satisfied | All 4 Wave-1 stories (A/C/D/B1) merged to `develop@33567e92`. CI run `34668700676` GREEN. Wave 2 = B2 STARTING. | counts unchanged (757/82/118/180) |
| **WAVE-2-B2-MERGED-F4-IMPL-COMPLETE-2026-09-12** | **COMPLETE** | 2026-09-12 | F4 Wave-2 impl complete; Wave-2 integration gate PENDING | Story B2 CONVERGED (6-pass, 4/5/6 CLEAN) + MERGED PR #807 @ `develop@30bb1a18` (BC-1.6.050, retires NFR-O-N; #787 closed). ALL 5 stories merged. Wave-2 integration gate PENDING. | counts unchanged (757/82/118/180) |
| **SESSION-WRAP-PAUSE-2026-09-12** | **COMPLETE** | 2026-09-12 | Bookkeeping only, session wrap; no quality gate | STATE.md v4.19->v4.20, pipeline ACTIVE->PAUSED. cycle-007 Wave-2 gate PENDING. Discovering E2E pre-existing defect triggers cycle-012. | counts unchanged (757/82/118/180) |
| **CYCLE-012-F1-APPROVED-2026-09-12** | **APPROVED** | 2026-09-12 | F1 human gate (explicit scope approval) | DEC-357: cycle-012 `field-adf-autoconvert` F1 HUMAN GATE APPROVED. Scope: ADF auto-convert on edit/create (platform + JSM). v4.20->v4.21. cycle-012 formalized. cycle-007 remains PAUSED. | counts unchanged (757/82/118/180) |
| **SESSION-WRAP-PAUSE-2026-09-12** | **COMPLETE** | 2026-09-12 | Bookkeeping only, session wrap; no quality gate | cycle-012 F2 adversarial-convergence in progress (10 passes, streak 0/3); F2 artifacts (12 BCs, 4 VPs, ADR-0024) committed; pipeline PAUSED; counts reconciled 769 BCs/86 VP. v4.21->v4.22. | 769 BCs / 86 VPs |

## Current Phase Steps

**cycle-012 (`field-adf-autoconvert`) Phase F2 spec-evolution -- adversarial convergence in progress 2026-09-12.** 10 adversarial passes run, streak 0/3. Pass-10 architect fixes (F-1 live-marker side-channel, F-3 bare-only fail-open, §5 item 2 ambiguity) written to `phase-f2-spec-evolution/cycle-012-verification-delta.md` + ADR-0024. PENDING product-owner pass-10 BC fixes: F-2 = BC-3.4.035 must show `(adf)`/`(adf-clear)` NOT `(updated)` for `--field description=`; F-3 = EC-3.8.019-2/020-5 warning string + fail-open scope to BARE (kind.is_none()) `--field` only. **cycle-007 (`auth-correctness-dx`) PAUSED at F4** -- Wave-2 gate PENDING (develop@`30bb1a18`). **NEXT** = `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-357 | cycle-012 F1 **HUMAN GATE APPROVED** 2026-09-12 -- scope: ADF auto-convert `--field NAME=VALUE` for rich-text fields on `jr issue edit`, `jr issue create` (platform), AND `jr issue create --request-type` (JSM, explicitly included). | Human reviewed F1 delta v4 after research + fresh-context adversarial review (1 CRITICAL/2 HIGH/5 MEDIUM all resolved in v4) + 2 live-Jira read-only probes; made explicit scope-gate approval including JSM path. DQ-6 noted. | F1 (gate) | 2026-09-12 | human (explicit F1-gate approval) |
| DEC-356 | cycle-007 F3 **HUMAN GATE APPROVED** 2026-09-11 -- 5-story decomposition (28 pts, 2 waves, acyclic B1->B2); A->B1 merge-order honored; `FIX-F6-A` deferral accepted. | Human reviewed F3 story-decomposition (CONVERGED 11 adversary passes) and made explicit approval ruling | F3 (gate) | 2026-09-11 | human (explicit F3-gate approval) |
| DEC-355 | cycle-007 F2 **HUMAN GATE APPROVED** 2026-09-10 -- 3 new BCs (BC-1.6.048/049/050) + 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 MINOR; authorized proceeding to F3. | Human reviewed F2 PRD delta (CONVERGED 10 adversary passes) and made explicit approval ruling | F2 (gate) | 2026-09-10 | human (explicit F2-gate approval) |
| DEC-354 | cycle-007 F1 **HUMAN GATE APPROVED** 2026-09-10 -- 6-issue scope: #784, #786 (narrowed), #787, #788, #790, #783; #785 DEFERRED. | Human reviewed F1 delta-analysis and made explicit scope-gate ruling | F1 (gate) | 2026-09-10 | human (explicit F1-gate approval) |
| DEC-353 | cycle-005 F7 **HUMAN GATE APPROVED / cycle CLOSED** 2026-09-09, **NO RELEASE**. 5-dim delta convergence PASS. Ships on `develop`; tag deferred. | Human reviewed 5-dim delta-convergence and explicitly approved closing without a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| (358 older decisions) | DEC-352 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-09 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**cycle-012 F1 artifacts:** `phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md` (OPERATIVE; v1/v2/v3 SUPERSEDED). Research: `research/field-adf-autoconvert-design-research-2026-09-12.md`, `research/e2e-environment-adf-field-2026-09-11.md`. Probes: `research/createmeta-schema-probe-2026-09-12.md`, `research/jsm-requesttype-fields-adf-probe-2026-09-12.md`. cycle-007 decisions: `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`; F2 delta: `phase-f2-spec-evolution/cycle-007-prd-delta.md`; F3 stories: `cycles/cycle-007/phase-f3-stories/`.

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

**NONE OPEN.** Zero Blocking Issues remain open. cycle-007 PAUSED at F4 IMPL COMPLETE (Wave-2 gate PENDING); cycle-012 OPEN at F2 adversarial convergence (10 passes, streak 0/3). All six prior cycles (001-006) CLOSED. Resolved items: `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking: `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) PAUSED, F4 IMPL COMPLETE. All 5 stories merged to `develop@30bb1a18`. Wave-2 integration gate PENDING on resume. cycle-012 (`field-adf-autoconvert`) OPEN, F2 adversarial spec-convergence: 10 passes run, streak 0/3 (need 3 consecutive clean). Full detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Nine tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) PAUSED** at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@`30bb1a18`); **cycle-012 (`field-adf-autoconvert`) ACTIVE** at F2 adversarial convergence (10 passes, streak 0/3). Cycles 008-011 PARKED (not yet started). `activation_head` stays `a9168212`. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing currently blocking. cycle-007 host constraint (`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`: nextest unusable on dev host) carries forward.

## Session Resume Checkpoint

**Date:** 2026-09-12. **Pipeline: PAUSED** (cycle-012 `field-adf-autoconvert`, Feature Mode, Phase F2 spec-evolution, mid adversarial spec-convergence). F1 APPROVED (DEC-357). F2 content produced: 12 BCs (platform create BC-3.3.013/014/015, platform edit BC-3.4.033/034/035/036/037, JSM BC-3.8.019/020/021/022), 4 VPs (VP-FIELD-ADF-001/002/003/004), ADR-0024 (ADF auto-conversion design), spec bump 2.3.0->2.4.0. NEXT after convergence: F2 human gate, then F3.

**Convergence counter:** F2 adversarial spec-convergence = 10 passes run, streak 0 of 3 consecutive-clean required. Trajectory: pass1 CRIT+HIGH+MED → pass2 HIGH+MED → pass3 MED+LOW → pass4 CRIT(propagation) → pass5 HIGH → pass6 HIGH+MED → pass7 HIGH+3MED → pass8 3MED → pass9 1MED → pass10 1HIGH(F-1 live-marker)+2MED. Pass-10 delta/ADR fixes DONE; pass-10 BC fixes PENDING; pass 11 not yet run.

**In-flight work:** (1) Pass-10 architect fixes (verification-delta + ADR-0024) committed by this pause burst. (2) PENDING product-owner BC fixes: F-2 = BC-3.4.035 must show marker `(adf)`/`(adf-clear)` NOT `(updated)` for `--field description=`; F-3 = EC-3.8.019-2 and EC-3.8.020-5 warning string → "warning: could not fetch request type fields — ADF-backed --field values will be sent as plain strings" + scope fail-open to BARE (kind.is_none()) `--field` only. (3) After BC fixes: run fresh pass 11, continue until 3 consecutive clean. (4) Then consistency-validator audit + F2 human gate. No code WIP, no open PRs.

**Pending human decisions / blockers:** F2 human gate PENDING (after 3-clean). cycle-007 PAUSED at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@`30bb1a18`; resume after cycle-012 closes). Session decisions: route B (full fix); JSM path INCLUDED in cycle-012 scope; converging JSM in-cycle. `test_e2e_issue_edit_custom_field` nightly failure is pre-existing defect fixed BY cycle-012 (confirmed pre-cycle-007 @ `14e695ae`).

**WIP branch list:** NONE (F2 is spec-only; no story feature branches, no open cycle-012 PRs).

**Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

**Counts:** total_bcs 769 (12 new F2 BCs; was 757); VP count 86 (4 new VPs; was 82); holdout scenarios 118 (unchanged); total_stories 180 (unchanged). Prior checkpoint (STATE.md v4.21): archived to `cycles/cycle-012/session-checkpoints.md`.

**NEXT:** Run `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step` to resume cycle-012 F2 adversarial convergence.

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
| cycle-007 Step-4.5 convergence records (Stories A/C/D/B1/B2) | `cycles/cycle-007/adversarial-reviews/story-{A,C,D,B1,B2}-convergence.md` |
| cycle-007 lessons (PG-A1..A4, PG-C1, PG-B1) | `cycles/cycle-007/lessons.md` |
| cycle-012 F1 operative delta analysis | `phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md` (v1/v2/v3 SUPERSEDED) |
| cycle-012 F2 spec evolution | `phase-f2-spec-evolution/cycle-012-verification-delta.md`, `specs/architecture/decisions/ADR-0024-adf-autoconversion-for-field-on-richtext-fields.md` |
| cycle-012 F1 design research + live-Jira probes | `research/field-adf-autoconvert-design-research-2026-09-12.md`, `research/e2e-environment-adf-field-2026-09-11.md`, `research/createmeta-schema-probe-2026-09-12.md`, `research/jsm-requesttype-fields-adf-probe-2026-09-12.md` |
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM`** -- LOW, non-blocking. `jr auth refresh --api-token` doc comment (`src/cli/mod.rs`) has latent unconditional-notice overclaim. Fix in future doc sweep. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`AUTH-REMEDIATION-EQUALS-FORM-BROADER`** -- LOW, non-blocking. `load_oauth_tokens` stale-keyring + `auth logout` strings still emit SPACE form. Broader remediation remains. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking (pre-existing since cycle-004). DEC-356 EXPLICITLY ACCEPTED deferral. OBS-2: `.cargo/mutants.toml` comment mis-attributes `derive_auth_state` mutation coverage. Target: future maintenance cycle.
- **`CYCLE-007-PARKED-BUNDLES`** -- 4 bundles PARKED: **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). Full triage: `phase-f1-delta-analysis/issue-triage-*.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap; candidate follow-up in vsdd-factory repo.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. PR #799 rebalance fix statically validated only; nightly must confirm.
- **`E2E-EDIT-FIELD-ADF-HEURISTIC`** -- **BEING ADDRESSED by cycle-012** (route B product fix: ADF auto-convert on `--field NAME=VALUE` for rich-text fields). F2 adversarial convergence in progress (10 passes, streak 0/3). Will close when cycle-012 F7 approved.
- **`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`** -- LOW, non-blocking, dev-host-only. `cargo-nextest` UNUSABLE for full suite. NOT a CI issue. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.

**RESOLVED this burst (2026-09-12, v4.22):** STATE.md v4.21->v4.22; cycle-012 F2 adversarial-convergence PAUSED (10 passes, streak 0/3); F2 artifacts (12 BCs/4 VPs/ADR-0024) committed; pipeline ACTIVE->PAUSED; counts reconciled to 769 BCs/86 VPs.

**RESOLVED prior burst:** `#786-MANUAL-CLOSE` -- GitHub issue #786 CLOSED (all 6 F1-scope issues now closed). All cycle-007 story worktrees removed + branches deleted post-merge.

**RESOLVED prior bursts (moved to `cycles/RESOLVED-DRIFT-ITEMS.md`):** `MAINTENANCE-SWEEP-2026-09-10-MERGES-PENDING`, `CYCLE-007-F1-SCOPE-GATE-PENDING`, `CYCLE-007-F2-SCOPE-GATE-PENDING`, `STATE-MD-OVER-SOFT-TARGET`.

All other standing debt -- full text preserved, nothing deleted: OPEN items at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items at `cycles/RESOLVED-DRIFT-ITEMS.md`.
