---
document_type: pipeline-state
level: ops
version: "4.26"
status: active
producer: state-manager
timestamp: 2026-09-14T03:50:08Z
phase: "ACTIVE 2026-09-13. cycle-012 (field-adf-autoconvert) F4 delta-implementation STARTED — Story 1 (S-cycle12-platform-adf-autoconvert, platform, Wave 1) delivery IN PROGRESS via per-story TDD. global STORY-INDEX 180->182 registered (this burst, v4.26). cycle-007 still PAUSED at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@30bb1a18)."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-13, v4.25->v4.26, state-manager -- cycle-012 F4 STARTED; global STORY-INDEX 180->182 registered; pipeline ACTIVE."
current_step: "CYCLE-012-F4-STARTED-2026-09-13: pipeline ACTIVE. global STORY-INDEX registered (180->182). cycle-012 Story 1 (S-cycle12-platform-adf-autoconvert) delivery IN PROGRESS. trajectory-tail →1→3→0→2 (unchanged). CI/CD gate PASS (develop@30bb1a18). NEXT = per-story TDD delivery (implementer). D-441/442/443/444/449/D-2026."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-012-field-adf-autoconvert (F3 APPROVED DEC-360; F4 STARTED 2026-09-13, Story 1 in-progress). cycle-007 auth-correctness-dx PAUSED: F4 IMPL COMPLETE, Wave-2 gate PENDING, develop@30bb1a18."
feature_mode_bundle: "field-adf-autoconvert: addresses E2E-EDIT-FIELD-ADF-HEURISTIC / test_e2e_issue_edit_custom_field pre-existing defect (confirmed pre-cycle-007 @ 14e695ae)"
cycle_012_status: "field-adf-autoconvert -- ACTIVE, Feature Mode, Phase F4 STARTED 2026-09-13. Story 1 (S-cycle12-platform-adf-autoconvert) delivery IN PROGRESS. F1 APPROVED DEC-357, F2 APPROVED DEC-358 (DEC-359), F3 APPROVED DEC-360. twelve new BCs + 4 VPs + ADR-0024, spec 2.4.0. total_bcs 769, VPs 86, total_stories 182."
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

<!-- STATE.md SIZE BUDGET (2026-09-13, CYCLE-012-F4-STARTED v4.26):
     pipeline ACTIVE. cycle-012 F4 STARTED. global STORY-INDEX 180->182 registered. version: 4.25->4.26.
     soft target 200 lines; hard cap 500 lines. 207 lines (wc-l). margin from soft-target = -7 (7 lines over soft); margin from actual = 293. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **ACTIVE** -- cycle-012 (`field-adf-autoconvert`) F4 STARTED 2026-09-13. Story 1 (`S-cycle12-platform-adf-autoconvert`, platform, Wave 1) delivery IN PROGRESS. global STORY-INDEX registered 180→182 (this burst). cycle-007 (`auth-correctness-dx`) **PAUSED** at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@`30bb1a18`). |
| **trajectory-tail** | →1→3→0→2 (cycle-012 F2 CLOSED, 33 passes, MAXIMUM_VIABLE_REFINEMENT_REACHED) |
| **Last Updated** | 2026-09-13, CYCLE-012-F4-STARTED: trajectory-tail →1→3→0→2 (unchanged); global STORY-INDEX 180→182 registered; pipeline PAUSED→ACTIVE; cycle-012 F4 Story 1 delivery starting (v4.25→v4.26). |
| **Current Phase** | cycle-012 Phase F4 STARTED (Story 1 in-progress). cycle-007 Phase F4 IMPL COMPLETE (PAUSED). |
| **Activation HEAD** | `a9168212` (unchanged; `develop`'s real tip is `30bb1a18`) |

## Phase Progress (recent 9; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **WAVE-1-INTEGRATION-GATE-PASSED-CYCLE-007** | **PASSED** | 2026-09-11 | F4 Wave-1 integration gate (4-dimension): combined-tree CI green + wave adversarial 3 consecutive CLEAN + wave security CLEAN + all 8 MUST-PASS holdout scenarios satisfied | All 4 Wave-1 stories (A/C/D/B1) merged to `develop@33567e92`. CI run `34668700676` GREEN. Wave 2 = B2 STARTING. | counts unchanged (757/82/118/180) |
| **WAVE-2-B2-MERGED-F4-IMPL-COMPLETE-2026-09-12** | **COMPLETE** | 2026-09-12 | F4 Wave-2 impl complete; Wave-2 integration gate PENDING | Story B2 CONVERGED (6-pass, 4/5/6 CLEAN) + MERGED PR #807 @ `develop@30bb1a18` (BC-1.6.050, retires NFR-O-N; #787 closed). ALL 5 stories merged. Wave-2 integration gate PENDING. | counts unchanged (757/82/118/180) |
| **SESSION-WRAP-PAUSE-2026-09-12** | **COMPLETE** | 2026-09-12 | Bookkeeping only, session wrap; no quality gate | STATE.md v4.19->v4.20, pipeline ACTIVE->PAUSED. cycle-007 Wave-2 gate PENDING. Discovering E2E pre-existing defect triggers cycle-012. | counts unchanged (757/82/118/180) |
| **CYCLE-012-F1-APPROVED-2026-09-12** | **APPROVED** | 2026-09-12 | F1 human gate (explicit scope approval) | DEC-357: cycle-012 `field-adf-autoconvert` F1 HUMAN GATE APPROVED. Scope: ADF auto-convert on edit/create (platform + JSM). v4.20->v4.21. cycle-012 formalized. cycle-007 remains PAUSED. | counts unchanged (757/82/118/180) |
| **SESSION-WRAP-PAUSE-2026-09-12** | **COMPLETE** | 2026-09-12 | Bookkeeping only, session wrap; no quality gate | cycle-012 F2 adversarial-convergence in progress (10 passes, streak 0/3); F2 artifacts (twelve new BCs, 4 VPs, ADR-0024) committed; pipeline PAUSED; counts reconciled 769 BCs/86 VP. v4.21->v4.22. | 769 BCs / 86 VPs |
| **CYCLE-012-F2-APPROVED-2026-09-13** | **APPROVED** | 2026-09-13 | F2 human gate (explicit spec approval) | DEC-358/359: F2 HUMAN GATE APPROVED. twelve new BCs + 4 VPs + ADR-0024, spec 2.3.0->2.4.0. 33 adversarial passes, MAXIMUM_VIABLE_REFINEMENT_REACHED. DEC-359: uniform exit-64 for `--markdown`+`--field description=`. F3 starting. v4.22->v4.23. | 769 BCs / 86 VPs |
| **CYCLE-012-F3-APPROVED-2026-09-13** | **APPROVED** | 2026-09-13 | F3 human gate (explicit story-decomposition approval) | DEC-360: F3 HUMAN GATE APPROVED. 2-story decomposition (S-cycle12-platform-adf-autoconvert 13pts Wave 1; S-cycle12-jsm-adf-autoconvert 13pts Wave 2; 26 pts total, S1→S2 sequential). Adversarial story convergence 3 consecutive CLEAN (passes 8/9/10); consistency-validator CONSISTENT; zero input-hash drift. total_stories 180->182. F4 starting. v4.23->v4.24. | 769 BCs / 86 VPs / 182 stories |
| **SESSION-WRAP-PAUSE-2026-09-13** | **COMPLETE** | 2026-09-13 | Bookkeeping only, session wrap; no quality gate | STATE.md v4.24->v4.25, pipeline ACTIVE->PAUSED at cycle-012 F4-start. sidecar-learning.md committed. | counts unchanged (769/86/118/182) |
| **CYCLE-012-F4-STARTED-2026-09-13** | **IN PROGRESS** | 2026-09-13 | per-story TDD delivery | global STORY-INDEX 180->182 registered (S-cycle12-platform-adf-autoconvert + S-cycle12-jsm-adf-autoconvert); pipeline ACTIVE; CI/CD gate PASS (develop@`30bb1a18`); Story 1 delivery starting. v4.25->v4.26. | 769 BCs / 86 VPs / 118 holdout / 182 stories |

## Current Phase Steps

**cycle-012 (`field-adf-autoconvert`) Phase F4 ACTIVE as of 2026-09-13.** Global STORY-INDEX registered (180→182). Story 1 (`S-cycle12-platform-adf-autoconvert`, platform, Wave 1, 13pts) delivery IN PROGRESS via per-story TDD. Story 2 (`S-cycle12-jsm-adf-autoconvert`, Wave 2) starts AFTER Story 1 merges. **cycle-007 (`auth-correctness-dx`) PAUSED at F4** -- Wave-2 gate PENDING (develop@`30bb1a18`). **NEXT** = per-story TDD delivery (implementer).

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-360 | cycle-012 F3 **HUMAN GATE APPROVED** 2026-09-13 -- 2-story decomposition (S-cycle12-platform-adf-autoconvert 13pts Wave 1; S-cycle12-jsm-adf-autoconvert 13pts Wave 2; 26 pts total, acyclic S1→S2), full BC/VP/§5 coverage, two-checkbox F4 gate on Story 2. F3 adversarial story convergence 3 consecutive CLEAN (passes 8/9/10 of 10; no-CRIT/HIGH/MED bar), consistency-validator CONSISTENT, zero input-hash drift. Human confirmed sequential S1→S2 critical path (no parallelism) acceptable. total_stories 180→182. | Human reviewed F3 story decomposition (CONVERGED 3 consecutive CLEAN passes) and made explicit approval ruling. Sequential critical path (S1→S2) accepted; no parallelism risk. | F3 (gate) | 2026-09-13 | human (explicit F3-gate approval) |
| DEC-359 | cycle-012 F2-gate uniform-exit-64: `--markdown` + `--field description=` (raw key `description`, case-sensitive, no-trim) UNIFORMLY exits 64 across platform `issue create` (NET-NEW guard step 2c), platform `issue edit` (guard extension), and JSM `create --request-type` (pre-existing BC-3.8.017). Message MUST contain pinned substring `cannot be combined with \`--markdown\`` + remediation "Pass --description with --markdown, or omit --markdown". | Human F2-gate qualifier "consistent with all of jr" caught that create was silently lenient while edit+JSM exited 64. Codebase analysis confirmed CLI-wide principle. Scoped adversary re-verified CLEAN. Supersedes DQ-1-Option-A silent-ignore framing. | F2 (gate) | 2026-09-13 | human (F2-gate qualifier) |
| DEC-358 | cycle-012 F2 **HUMAN GATE APPROVED** 2026-09-13 -- twelve new BCs + 4 VPs + ADR-0024, spec 2.3.0->2.4.0; adversarial spec-convergence MAXIMUM_VIABLE_REFINEMENT_REACHED after 33 passes. | Human reviewed F2 PRD delta + verification delta; applied F2-gate qualifier (DEC-359); explicitly approved proceeding to F3. | F2 (gate) | 2026-09-13 | human (explicit F2-gate approval) |
| DEC-357 | cycle-012 F1 **HUMAN GATE APPROVED** 2026-09-12 -- scope: ADF auto-convert `--field NAME=VALUE` for rich-text fields on `jr issue edit`, `jr issue create` (platform), AND `jr issue create --request-type` (JSM, explicitly included). | Human reviewed F1 delta v4 after research + fresh-context adversarial review (1 CRITICAL/2 HIGH/5 MEDIUM all resolved in v4) + 2 live-Jira read-only probes; made explicit scope-gate approval including JSM path. DQ-6 noted. | F1 (gate) | 2026-09-12 | human (explicit F1-gate approval) |
| DEC-356 | cycle-007 F3 **HUMAN GATE APPROVED** 2026-09-11 -- 5-story decomposition (28 pts, 2 waves, acyclic B1->B2); A->B1 merge-order honored; `FIX-F6-A` deferral accepted. | Human reviewed F3 story-decomposition (CONVERGED 11 adversary passes) and made explicit approval ruling | F3 (gate) | 2026-09-11 | human (explicit F3-gate approval) |
| (360 older decisions) | DEC-355 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-12 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**cycle-012 F1 artifacts:** `phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md` (OPERATIVE; v1/v2/v3 SUPERSEDED). Research: `research/field-adf-autoconvert-design-research-2026-09-12.md`, `research/e2e-environment-adf-field-2026-09-11.md`. Probes: `research/createmeta-schema-probe-2026-09-12.md`, `research/jsm-requesttype-fields-adf-probe-2026-09-12.md`. **cycle-012 F2 artifacts:** `phase-f2-spec-evolution/cycle-012-verification-delta.md`, `specs/architecture/decisions/ADR-0024-adf-autoconversion-for-field-on-richtext-fields.md`, `specs/prd/bc-3-issue-write.md` (twelve cycle-012 BCs + base-BC amendments). **cycle-012 F3 artifacts:** `cycles/cycle-012/phase-f3-stories/S-cycle12-platform-adf-autoconvert.md`, `cycles/cycle-012/phase-f3-stories/S-cycle12-jsm-adf-autoconvert.md`, `cycles/cycle-012/phase-f3-stories/dependency-graph.md`, `cycles/cycle-012/phase-f3-stories/STORY-INDEX.md`, `cycles/cycle-012/phase-f3-stories/wave-schedule.md`.

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

**NONE OPEN.** Zero Blocking Issues remain open. cycle-012 ACTIVE, F4 STARTED (Story 1 in-progress). cycle-007 PAUSED at F4 IMPL COMPLETE (Wave-2 gate PENDING). All six prior cycles (001-006) CLOSED. Resolved items: `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking: `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) PAUSED, F4 IMPL COMPLETE. Wave-2 integration gate PENDING on resume. cycle-012 (`field-adf-autoconvert`) ACTIVE, F4 STARTED 2026-09-13; Story 1 in-progress. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Nine tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) PAUSED** at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@`30bb1a18`); **cycle-012 (`field-adf-autoconvert`) ACTIVE** at F4 STARTED (Story 1 in-progress). Cycles 008-011 PARKED (not yet started). `activation_head` stays `a9168212`. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing currently blocking. cycle-007 host constraint (`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`: nextest unusable on dev host) carries forward.

## Session Resume Checkpoint

**Date:** 2026-09-13. **Pipeline: ACTIVE** (cycle-012 `field-adf-autoconvert`, Feature Mode, Phase F4 STARTED; cycle-007 `auth-correctness-dx` PAUSED at F4 IMPL COMPLETE, Wave-2 gate PENDING).

**Pipeline position:** cycle-012 F4 IN PROGRESS. Current = Story 1 (`S-cycle12-platform-adf-autoconvert`, platform, Wave 1, 13pts) via per-story TDD delivery. Global STORY-INDEX registration complete (180→182, this burst). DTU check N/A (`dtu_required: false`). F1 APPROVED (DEC-357). F2 APPROVED (DEC-358, DEC-359). F3 APPROVED (DEC-360) 2026-09-13.

**Convergence counter:** NONE active. F3 story convergence achieved 3/3 consecutive CLEAN (passes 8/9/10). F2 MAXIMUM_VIABLE_REFINEMENT_REACHED/APPROVED (33 passes). No active adversarial convergence underway.

**In-flight work:** Story 1 TDD delivery in progress; no open PRs; no story worktrees yet (pre-implementation setup next).

**Pending human decisions / blockers:** NONE open. F1/F2/F3 all human-APPROVED; DEC-359 uniform-exit-64 confirmed; sequential S1→S2 path confirmed. cycle-007 Wave-2 integration gate remains PENDING (resume after cycle-012 closes).

**WIP branch list:** NONE yet (Story 1 worktree/branch creation = next step).

**Resume command:** `/vsdd-factory:next-step` (Story 1 per-story TDD delivery).

**Counts:** total_bcs 769 (unchanged); VP count 86 (unchanged); holdout scenarios 118 (unchanged); total_stories 182 (global STORY-INDEX registered 2026-09-13, this burst). Prior checkpoint (STATE.md v4.25): archived to `cycles/cycle-012/session-checkpoints.md`.

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
| cycle-012 F2 spec evolution | `phase-f2-spec-evolution/cycle-012-verification-delta.md`, `specs/architecture/decisions/ADR-0024-adf-autoconversion-for-field-on-richtext-fields.md`, `specs/prd/bc-3-issue-write.md` |
| cycle-012 F3 stories + wave artifacts | `cycles/cycle-012/phase-f3-stories/` |
| cycle-012 session checkpoints | `cycles/cycle-012/session-checkpoints.md` |
| cycle-012 lessons (L-001..L-004) | `cycles/cycle-012/lessons.md` |
| cycle-012 F1 design research + live-Jira probes | `research/field-adf-autoconvert-design-research-2026-09-12.md`, `research/e2e-environment-adf-field-2026-09-11.md`, `research/createmeta-schema-probe-2026-09-12.md`, `research/jsm-requesttype-fields-adf-probe-2026-09-12.md` |
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`BC-CITE-001 ZERO-TOLERANCE (CODIFIED, L-001)`** -- POLICY. `scripts/check-bc-citation-symbols.sh` exits 1 on ANY backtick-wrapped pending `src/…::symbol` token in BC Trace/Source. Future spec-ahead-of-code cycles MUST cite not-yet-existing F4 symbols in the un-backticked "(…pending — F4 Story N)" convention. Codified in `cycles/cycle-012/lessons.md` (L-001).
- **`INPUT-HASH-DRIFT-STALE-ARTIFACTS`** -- LOW, non-blocking. Input-hash scan shows 209 STALE + 4 UNRESOLVABLE artifacts, ALL from prior closed cycles. Pre-existing repo-wide condition. No action required for cycle-012.
- **`AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM`** -- LOW, non-blocking. `jr auth refresh --api-token` doc comment has latent unconditional-notice overclaim. Fix in future doc sweep. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`AUTH-REMEDIATION-EQUALS-FORM-BROADER`** -- LOW, non-blocking. Broader remediation remains. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking (pre-existing since cycle-004). DEC-356 EXPLICITLY ACCEPTED deferral. Target: future maintenance cycle.
- **`CYCLE-007-PARKED-BUNDLES`** -- 4 bundles PARKED: **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). Full triage: `phase-f1-delta-analysis/issue-triage-*.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap; candidate follow-up in vsdd-factory repo.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. PR #799 rebalance fix statically validated only; nightly must confirm.
- **`E2E-EDIT-FIELD-ADF-HEURISTIC`** -- **BEING ADDRESSED by cycle-012** (route B product fix). F3 APPROVED (DEC-360). F4 ACTIVE (Story 1 in-progress). Will close when cycle-012 F7 approved.
- **`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`** -- LOW, non-blocking, dev-host-only. `cargo-nextest` UNUSABLE for full suite. NOT a CI issue. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.

**RESOLVED this burst (2026-09-13, v4.26):** cycle-012 F4 STARTED; global STORY-INDEX 180→182 registered (2 new S-cycle12-* rows added to Story Manifest + Feature Followup); pipeline PAUSED→ACTIVE.

**RESOLVED prior burst (2026-09-13, v4.25):** pipeline PAUSED at cycle-012 F4-start (SESSION-WRAP-PAUSE-2026-09-13). sidecar-learning.md committed.

All other standing debt -- full text preserved, nothing deleted: OPEN items at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items at `cycles/RESOLVED-DRIFT-ITEMS.md`.
