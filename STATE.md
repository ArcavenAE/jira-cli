---
document_type: pipeline-state
level: ops
version: "4.36"
status: active
producer: state-manager
timestamp: 2026-09-15T02:17:52Z
phase: "cycle-012 (field-adf-autoconvert) Phase F7 HUMAN GATE APPROVED 2026-09-15 -- 'Approve & close'. All gates green (F4 both waves merged PR #809/#812, E2E-verified; F5 CONVERGED adversary 3/3 + code-review resolved PR #813 + security CLEAN; F6 HARDENED; F7 CONVERGENCE ALL 7 DIMENSIONS PASS; ADR-0024 Accepted). Release decision: ship on develop, NO TAG (cycle-005 precedent) -- changes ride develop @ 80bb4215 into the next tagged release; CHANGELOG [Unreleased] entry already present. cycle-012 CLOSED (DEC-361). cycle-007 (auth-correctness-dx) Wave-2 integration gate PASSED 2026-09-15 (regression GREEN + adversarial 3/3 CLEAN + security CLEAN + consistency PASS + holdout satisfied); Phase F4 COMPLETE -- all 5 stories merged (PRs #803/805/804/806/807) and both wave integration gates PASSED. F5/F6/F7 REMAIN (not yet started). No active cycle; pipeline idle/paused-ready. NEXT (future session) = (a) optional session-review of cycle-012, (b) cycle-007 F5 scoped adversarial (mirroring cycle-012's F5-F7 pattern) then F6/F7, or (c) a maintenance sweep to burn down deferred LOW debt (M-2/OBS-A/OBS-3/SEC-001-EDITMETA-RECURSION-GUARD/CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE)."
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-15, v4.35->v4.36, state-manager -- cycle-007 Wave-2 integration gate PASSED (regression GREEN + adversarial 3/3 CLEAN + security CLEAN + consistency PASS + holdout satisfied); Phase F4 COMPLETE (all 5 stories merged, both wave gates PASSED). No DEC minted (bookkeeping/automated gate, Wave-1-gate precedent). Pipeline remains PAUSED/idle -- no in-flight work started this burst; cycle-012 unaffected (still CLOSED)."
current_step: "CYCLE-007-WAVE2-GATE-PASSED-F4-COMPLETE-2026-09-15: Wave-2 integration gate PASSED (regression: auth_status_json 31/0, lib auth 270/0, auth_profiles 46/0 GREEN on develop@80bb4215; adversarial 3/3 CLEAN A/B/C; security CLEAN [1 LOW accepted]; consistency PASS; holdout H-W2-INT-001 satisfied via shared derive_auth_state). cycle-007 Phase F4 COMPLETE. Pipeline remains PAUSED -- no active cycle resumed. NEXT options: (a) session-review, (b) cycle-007 F5 scoped adversarial, (c) maintenance sweep. D-chain cite D-2026 latest brownfield. trajectory-tail →1→3→0→2."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "NONE ACTIVE -- cycle-012 (field-adf-autoconvert) CLOSED 2026-09-15 (DEC-361), NO RELEASE, ships on develop @ 80bb4215, tag deferred (cycle-005 precedent). cycle-007 (auth-correctness-dx) Phase F4 COMPLETE 2026-09-15 (both waves merged + gated, develop@80bb4215); F5/F6/F7 REMAIN, not yet started; resumable. Pipeline idle/paused-ready."
feature_mode_bundle: "field-adf-autoconvert: CLOSED 2026-09-15 (DEC-361). Addressed E2E-EDIT-FIELD-ADF-HEURISTIC / test_e2e_issue_edit_custom_field pre-existing defect (confirmed pre-cycle-007 @ 14e695ae) in full. Both waves merged (PR #809 @ e926cb70, E2E-verified + AC-014 strengthened PR #811; PR #812 @ 2a0b0fae). F5 CONVERGED (fix PR #813 @ 80bb4215). F6 HARDENED. F7 delta convergence ALL 7 DIMENSIONS PASS; ADR-0024 Accepted. F7 human gate APPROVED ('Approve & close'); ships on develop, NO TAG (cycle-005 precedent). Full text: cycles/CYCLE-SUMMARY.md#cycle_012_status."
cycle_012_status: "field-adf-autoconvert -- CLOSED, NO RELEASE, 2026-09-15 (DEC-361; closes E2E-EDIT-FIELD-ADF-HEURISTIC; ships on develop @ 80bb4215, tag deferred -- cycle-005 precedent). F1-F7 all APPROVED; full text: cycles/CYCLE-SUMMARY.md#cycle_012_status"
cycle_007_status: "auth-correctness-dx -- F4 COMPLETE (both waves gated); Wave-2 gate PASSED 2026-09-15. F5/F6/F7 REMAIN (not yet started). develop@80bb4215. F1 APPROVED DEC-354, F2 APPROVED DEC-355, F3 APPROVED DEC-356. All 5 stories merged (PRs #803/805/804/806/#807). Resumable."
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

<!-- STATE.md SIZE BUDGET (2026-09-15, CYCLE-007-WAVE2-GATE-PASSED-F4-COMPLETE v4.36):
     cycle-007 Wave-2 integration gate PASSED (regression + adversarial 3/3 CLEAN + security CLEAN + consistency PASS + holdout); Phase F4 COMPLETE. No DEC minted (bookkeeping gate, Wave-1 precedent). Pipeline remains PAUSED/idle. v4.35->v4.36.
     soft target 200 lines; hard cap 500 lines. 221 lines (wc-l). margin from soft-target = -21 (21 lines over); margin from actual = 279. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **PAUSED / IDLE** -- cycle-012 (`field-adf-autoconvert`) **CLOSED** 2026-09-15 (DEC-361; F7 human gate APPROVED "Approve & close"). NO RELEASE cut -- ships on `develop @ 80bb4215`, tag deferred (cycle-005 precedent); CHANGELOG `[Unreleased]` entry already present. cycle-007 (`auth-correctness-dx`) Wave-2 integration gate **PASSED** 2026-09-15; Phase **F4 COMPLETE** (all 5 stories merged + both wave gates PASSED). F5/F6/F7 REMAIN, not yet started. No active cycle. NEXT (future session) = (a) optional session-review of cycle-012, (b) cycle-007 F5 scoped adversarial, or (c) a maintenance sweep for deferred LOW debt. |
| **trajectory-tail** | →1→3→0→2 (unchanged -- bookkeeping burst, no code delta) |
| **Last Updated** | 2026-09-15, CYCLE-007-WAVE2-GATE-PASSED-F4-COMPLETE: v4.35->v4.36; Wave-2 integration gate PASSED; Phase F4 COMPLETE. Pipeline idle. trajectory-tail →1→3→0→2. |
| **Current Phase** | cycle-012 CLOSED -- no active phase. cycle-007 Phase F4 COMPLETE (both waves gated); F5 NEXT (not started, PAUSED/resumable). |
| **Activation HEAD** | `a9168212` (unchanged; `develop`'s real tip is `80bb4215`) |

## Phase Progress (recent 10; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **CYCLE-012-STORY1-E2E-VERIFIED-2026-09-14** | **COMPLETE** | 2026-09-14 | E2E live-Jira verification; AC-014 adaptive read-back strengthened (PR #811) | `test_e2e_issue_edit_custom_field` PASSED live Jira (run `34881320608` @ `develop@67b3939a`). PR #811 MERGED (`67b3939a`, squash) -- ADF-aware assertion. E2E-EDIT-FIELD-ADF-HEURISTIC RESOLVED/VERIFIED. E2E-COMPONENT-FILTER-SEARCH-INDEX-FLAKE registered (LOW). L-007 added. develop: `71d98800`->`e926cb70`->`67b3939a`. v4.27->v4.28. | counts unchanged (769/86/118/182) |
| **SESSION-WRAP-PAUSE-2026-09-14** | **COMPLETE** | 2026-09-14 | Bookkeeping only, session wrap; no quality gate | pipeline ACTIVE->PAUSED at cycle-012 Wave-1-complete/E2E-verified boundary; v4.28->v4.29; session wrap | counts unchanged (769/86/118/182) |
| **CYCLE-012-WAVE2-F4-STARTED-2026-09-14** | **COMPLETE** | 2026-09-14 | per-story TDD delivery start | pipeline PAUSED->ACTIVE. Local develop fast-forwarded to `67b3939a` (was `30bb1a18`); Main-Checkout Sync Protocol pre-check ran CLEAN. Worktree created: `.worktrees/S-cycle12-jsm-adf-autoconvert`, branch `feat/cycle12-jsm-adf-autoconvert`, base `67b3939a`. Story 2 (`S-cycle12-jsm-adf-autoconvert`, 13pts, strict TDD) delivery starting; Red Gate about to begin. v4.29->v4.30. | counts unchanged (769/86/118/182) |
| **CYCLE-012-STORY2-CONVERGED-2026-09-14** | **COMPLETE** | 2026-09-14 | Step 4.5 3/3 CLEAN + demo skip | S-cycle12-jsm-adf-autoconvert Step 4.5 CONVERGED -- 3 consecutive CLEAN adversary passes, zero CRIT/HIGH/MED (bar: DEC-360 precedent). OBS-P3-2 (CHANGELOG JSM assembly-order gap) RESOLVED, doc-only, no re-convergence. 4 BCs (BC-3.8.019-022) + 3 VPs (VP-FIELD-ADF-001/003/004). Demo recording SKIPPED (human decision). Implementation COMPLETE + GREEN: lib jsm 31/0, issue_create_jsm 113/0, clippy+fmt clean. L-008/L-009 added. v4.30->v4.31. | 769 BCs / 86 VPs / 118 holdout / 182 stories |
| **CYCLE-012-STORY2-MERGED-WAVE2-COMPLETE-2026-09-14** | **COMPLETE** | 2026-09-14 | Story 2 per-story TDD delivery + merge; Wave 2 complete; F4 complete | S-cycle12-jsm-adf-autoconvert MERGED PR #812 @ `2a0b0fae` (squash, `--admin`, 2026-09-14T22:57:09Z). develop: `67b3939a`->`2a0b0fae`. All quality gates PASS: Red Gate verified; GREEN; Step 4.5 3/3 CLEAN; security CLEAN; CI 24/24 green incl. CI Gate + 8 mutation shards; fresh-eyes pr-reviewer APPROVE; dependency gate satisfied; demo SKIPPED (human decision). cycle-012 F4 COMPLETE (both waves delivered). NEXT = Wave 2 integration gate -> F5. v4.31->v4.32. | 769 BCs / 86 VPs / 118 holdout / 182 stories |
| **CYCLE-012-F5-CONVERGED-2026-09-15** | **COMPLETE** | 2026-09-15 | F5 scoped adversarial: adversary 3/3 CLEAN + code-review resolved + security CLEAN; fix PR #813 merged | Adversary Pass 1 (pre-fix) surfaced OBS-1 (`changed_fields --output json` scope-leak, human-ruled: narrow to ADF fields only) + code-reviewer H-1 (`jsm_create.rs` missing from CLAUDE.md Known Size Deviations) + M-1 (`field_resolve.rs` size entry stale, refreshed to 2,269 LOC) + M-3 (stale `isAdfRequest` comment). All four resolved in fix PR #813 (`fix/cycle012-f5-findings`). Re-review Passes A/B/C: 3/3 consecutive CLEAN (`VERDICT CLEAN NITPICK_ONLY`, zero CRIT/HIGH/MED) -- F5 CONVERGED. Security-reviewer CLEAN throughout (SEC-001 LOW pre-existing, not reachable via cycle-012 paths). PR #813 MERGED squash @ `80bb4215` (2026-09-15T00:14:11Z, `--admin`); fresh-eyes pr-reviewer APPROVE; CI 21/21 green incl. CI Gate; security review CLEAN. `develop`: `2a0b0fae`->`80bb4215`. Worktree/branch cleaned up. New LOW debt: M-2, OBS-A, OBS-3. NEXT = F6 targeted hardening. v4.32->v4.33. Trajectory: `4→0→0→0`. | 769 BCs / 86 VPs / 118 holdout / 182 stories |
| **CYCLE-012-F6-HARDENED-2026-09-15** | **COMPLETE / HARDENED** | 2026-09-15 | Targeted hardening -- automated quality gate, no separate human gate (feature-mode convention); VP coverage mapping + mutation/regression/security evidence review | All 4 new VPs (VP-FIELD-ADF-001..004) have real, passing coverage cited against `field_resolve.rs`/`jsm_create.rs`/`adf.rs`/`api/jsm/requests.rs` tests, no uncovered axis. Kani/cargo-fuzz JUSTIFIED-SKIP (0-GAP, cycle-002/003/004/005 precedent -- pure pattern-match predicates, no overflow/unsafe/untrusted-deser surface). Mutation gate GREEN in CI (PR #812 run `34905420465`, PR #813 run `34910142474`, not re-run locally per policy). Security scan CLEAN (Deny/gitleaks/spec-guards). DTU/accessibility N/A (`dtu_required: false`; CLI-only). 2 LOW residuals accepted: L-1 (gated live-E2E JSM round-trip coverage), L-2 (repo-wide unprovisioned Kani/fuzz). Report: `cycles/cycle-012/phase-f6-hardening/hardening-record.md` (commit `21d2bf0f`). NEXT = F7 delta convergence. v4.33 (no version bump, folded into v4.34 burst). | counts unchanged (769/86/118/182); no DEC minted -- F6 hardening is an automated quality gate |
| **CYCLE-012-F7-CONVERGED-2026-09-15** | **COMPLETE / CONVERGED** | 2026-09-15 | Delta convergence -- ALL 7 dimensions PASS; human close/release gate PENDING | Fresh-context consistency-validator: spec<->code PASS; code<->test PASS (32/32/39/113 green); traceability PASS; index-consistency PASS (`check-spec-counts` + `check-bc-cumulative-counts` both exit 0, 769 BCs); ADR-0024 alignment PASS (flipped `Proposed`->`Accepted`, commit `2430bdc8`, post-implementation VSDD lifecycle); citation-integrity PASS (`claude_md_citations` 61/61, `bc-citation` 525 clean, clippy 0 warnings, `e2e_cli_surface_guard` 10/10); cross-references PASS. Benign cycle-012 input-hash drift (typo + 6 hashes stale from the ADR-0024 flip) resolved this burst; residual drift is the accepted `[live-state]` sentinel class + pre-existing prior-cycle baseline. NEXT = **F7 HUMAN GATE** (final cycle-012 close approval + release decision) -- awaiting human. v4.33->v4.34. | 769 BCs / 86 VPs / 118 holdout / 182 stories; no DEC minted yet -- awaiting human F7-gate ruling |
| **CYCLE-012-F7-APPROVED-CLOSED-2026-09-15** | **COMPLETE / CLOSED** | 2026-09-15 | F7 human gate -- approve & close, ship-on-develop-no-tag | Human APPROVED F7 gate: "Approve & close". All gates green (F4 both waves merged PR #809/#812, E2E-verified; F5 CONVERGED adversary 3/3 + code-review resolved PR #813 + security CLEAN; F6 HARDENED; F7 CONVERGENCE ALL 7 DIMENSIONS PASS; ADR-0024 Accepted). Release decision: ship on `develop`, NO TAG (cycle-005 precedent) -- changes ride `develop @ 80bb4215` into the next tagged release; CHANGELOG `[Unreleased]` entry already present. S-7.02 Cycle-Closing Checklist satisfied: findings CODIFIED as lessons (L-001..L-010) or DEFERRED as tracked LOW debt (`M-2`/`OBS-A`/`OBS-3`, pre-existing `SEC-001-EDITMETA-RECURSION-GUARD`) to a future maintenance sweep. **cycle-012 CLOSED.** Pipeline now idle/paused-ready -- no active cycle; cycle-007 remains PAUSED (resumable). v4.34->v4.35. | 769 BCs / 86 VPs / 118 holdout / 182 stories; DEC-361 minted |
| **CYCLE-007-WAVE2-GATE-PASSED-F4-COMPLETE-2026-09-15** | **COMPLETE** | 2026-09-15 | Wave-2 integration gate: regression + adversarial 3/3 CLEAN + security CLEAN + consistency PASS + holdout | Session resumed cycle-007 (PAUSED at "F4 IMPL COMPLETE, Wave-2 gate PENDING"). Story B2 (`S-cycle7-auth-status-json`, PR #807) already merged in a prior session; this burst ran the pending Wave-2 integration gate. Regression: `auth_status_json` 31/0, lib `auth` 270/0, `auth_profiles` 46/0 GREEN on `develop@80bb4215`. Wave-2 adversarial: 3 consecutive CLEAN passes (A/B/C), zero CRIT/HIGH/MED. Wave-2 security: CLEAN (0 CRIT/HIGH/MED; 1 LOW accepted -- env emitted verbatim, self-authored config, documented lossless-machine-channel choice). Consistency: PASS (BC-1.6.050 <-> code <-> tests; count guards exit 0). Holdout: Wave-2 scenarios covered; `H-W2-INT-001` (cross-command runtime parity) satisfied structurally via AC-002 shared-derivation + AC-011 field-name-match + shared `derive_auth_state` (VP-AUTHDX-024). Demo SKIPPED (prior human decision, already in Skip Log). **cycle-007 Phase F4 COMPLETE** (all 5 stories merged + both wave integration gates PASSED). New standing item `CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE` (OBS-C-01, LOW) recorded. No DEC minted (bookkeeping/automated gate, Wave-1-gate precedent). Pipeline remains PAUSED -- no active cycle resumed. NEXT = cycle-007 F5 scoped adversarial (not started). v4.35->v4.36. | 769 BCs / 86 VPs / 118 holdout / 182 stories; no DEC minted -- bookkeeping/automated gate |

## Current Phase Steps

**cycle-007 (`auth-correctness-dx`) Phase F4 COMPLETE 2026-09-15.** This session resumed cycle-007, which had been PAUSED at "F4 IMPL COMPLETE, Wave-2 gate PENDING" (all 5 stories already merged: Wave 1 = A/C/D/B1, gated PASSED earlier; Wave 2 = B2 `S-cycle7-auth-status-json`, PR #807 @ `30bb1a18`). The pending Wave-2 integration gate was run this burst and **PASSED**: regression suites GREEN on `develop@80bb4215` (`auth_status_json` 31/0, lib `auth` 270/0, `auth_profiles` 46/0); Wave-2 adversarial review 3 consecutive CLEAN passes (A/B/C), zero CRIT/HIGH/MED; Wave-2 security review CLEAN (1 LOW accepted -- `env` emitted verbatim in `auth status --output json`, a self-authored-config, lossless-machine-channel design choice, not a leak); consistency validation PASS (BC-1.6.050 ↔ code ↔ tests aligned, count guards exit 0); holdout scenario `H-W2-INT-001` (cross-command runtime parity between `auth list`/`auth status`) satisfied structurally via the shared `derive_auth_state` helper (VP-AUTHDX-024) plus AC-002/AC-011; demo recording SKIPPED per a prior human decision already recorded in the Skip Log. With both wave integration gates now PASSED and all 5 stories merged, **cycle-007 Phase F4 is COMPLETE**. A new LOW standing item was recorded this burst: `CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE` (OBS-C-01, surfaced by the Wave-2 gate's adversary Pass C) -- all cycle-007 F3 story frontmatter, including the merged stories, still reads `status: draft` post-merge (systemic; STATE.md is the authoritative status source); candidate fix is a status-flip sweep at cycle-007's full close (F7), and it's also an open question whether prior CLOSED cycles left the same gap. `NFR-O-N-CATALOG-RETIREMENT-EDIT` (added in an earlier burst, commit `bb0e1a9d`) was confirmed present, not duplicated. **cycle-012 (`field-adf-autoconvert`) remains CLOSED** (DEC-361, 2026-09-15) -- unaffected by this burst. **Pipeline remains PAUSED/idle** -- no in-flight work was started this burst; no open PRs; no story worktrees. NEXT (a future session's choice): (a) an optional session-review of cycle-012, (b) cycle-007's Phase F5 scoped adversarial review (mirroring cycle-012's F5→F6→F7 pattern), or (c) a maintenance sweep to burn down the deferred LOW debt (`M-2`/`OBS-A`/`OBS-3`/`SEC-001-EDITMETA-RECURSION-GUARD`/`CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE`).

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-361 | cycle-012 F7 **HUMAN GATE APPROVED** 2026-09-15 -- "Approve & close"; all gates green (F4 both waves merged PR #809/#812, E2E-verified; F5 CONVERGED adversary 3/3 + code-review resolved PR #813 + security CLEAN; F6 HARDENED; F7 CONVERGENCE ALL 7 DIMENSIONS PASS; ADR-0024 Accepted). Release: ship on `develop`, NO TAG (cycle-005 precedent) -- no release/tag now, changes ride `develop @ 80bb4215` into the next tagged release; CHANGELOG `[Unreleased]` entry already present. LOW debt (`M-2`/`OBS-A`/`OBS-3`/`SEC-001`) deferred to maintenance sweep. | Human reviewed the F7 convergence summary (ALL 7 DIMENSIONS PASS) and made an explicit approval + release ruling. S-7.02 Cycle-Closing Checklist satisfied: every process-gap/novel finding is CODIFIED as a lesson (L-008, L-010, L-001..L-009 prior) or DEFERRED as tracked debt with a maintenance-sweep target -- none left without a follow-up or justified deferral. | F7 (gate) | 2026-09-15 | human (explicit F7-gate approval) |
| DEC-360 | cycle-012 F3 **HUMAN GATE APPROVED** 2026-09-13 -- 2-story decomposition (S-cycle12-platform-adf-autoconvert 13pts Wave 1; S-cycle12-jsm-adf-autoconvert 13pts Wave 2; 26 pts total, acyclic S1->S2), full BC/VP/section-5 coverage, two-checkbox F4 gate on Story 2. F3 adversarial story convergence 3 consecutive CLEAN (passes 8/9/10 of 10; no-CRIT/HIGH/MED bar), consistency-validator CONSISTENT, zero input-hash drift. Human confirmed sequential S1->S2 critical path (no parallelism) acceptable. total_stories 180->182. | Human reviewed F3 story decomposition (CONVERGED 3 consecutive CLEAN passes) and made explicit approval ruling. Sequential critical path (S1->S2) accepted; no parallelism risk. | F3 (gate) | 2026-09-13 | human (explicit F3-gate approval) |
| DEC-359 | cycle-012 F2-gate uniform-exit-64: `--markdown` + `--field description=` (raw key `description`, case-sensitive, no-trim) UNIFORMLY exits 64 across platform `issue create` (NET-NEW guard step 2c), platform `issue edit` (guard extension), and JSM `create --request-type` (pre-existing BC-3.8.017). Message MUST contain pinned substring `cannot be combined with --markdown` + remediation "Pass --description with --markdown, or omit --markdown". | Human F2-gate qualifier "consistent with all of jr" caught that create was silently lenient while edit+JSM exited 64. Codebase analysis confirmed CLI-wide principle. Scoped adversary re-verified CLEAN. Supersedes DQ-1-Option-A silent-ignore framing. | F2 (gate) | 2026-09-13 | human (F2-gate qualifier) |
| DEC-358 | cycle-012 F2 **HUMAN GATE APPROVED** 2026-09-13 -- twelve new BCs + 4 VPs + ADR-0024, spec 2.3.0->2.4.0; adversarial spec-convergence MAXIMUM_VIABLE_REFINEMENT_REACHED after 33 passes. | Human reviewed F2 PRD delta + verification delta; applied F2-gate qualifier (DEC-359); explicitly approved proceeding to F3. | F2 (gate) | 2026-09-13 | human (explicit F2-gate approval) |
| (363 older decisions) | DEC-357 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-12 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**No new DEC minted this burst** -- cycle-007's Wave-2 integration gate PASS is a bookkeeping/automated-gate outcome (same convention as the F6-hardening and Wave-1-gate precedents), not a human decision point. `DEC-361` (cycle-012 F7 close, prior burst) remains the most recent decision.

**cycle-012 F1 artifacts:** `phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md` (OPERATIVE). **cycle-012 F2 artifacts:** `phase-f2-spec-evolution/cycle-012-verification-delta.md`, `specs/architecture/decisions/ADR-0024-adf-autoconversion-for-field-on-richtext-fields.md`, `specs/prd/bc-3-issue-write.md`. **cycle-012 F3 artifacts:** `cycles/cycle-012/phase-f3-stories/`. **cycle-012 F4 artifacts:** Story 1 convergence `cycles/cycle-012/adversarial-reviews/story-S-cycle12-platform-adf-autoconvert-convergence.md`; Story 2 convergence `cycles/cycle-012/adversarial-reviews/story-S-cycle12-jsm-adf-autoconvert-convergence.md`; both red-gate-logs under `cycles/cycle-012/S-cycle12-*/implementation/red-gate-log.md`. **E2E verification:** run `34881320608` @ `develop@67b3939a`; PR #811 (`67b3939a`). **cycle-012 F5 artifacts:** `cycles/cycle-012/convergence-trajectory.md` (Passes 1/A/B/C full detail); PR review evidence `code-delivery/cycle012-f5/pr-review.md`; fix PR #813 (`fix/cycle012-f5-findings`) squash-merged @ `80bb4215`. **cycle-012 F6 artifacts:** `cycles/cycle-012/phase-f6-hardening/hardening-record.md` (commit `21d2bf0f`, verdict HARDENED). **cycle-012 F7 artifacts:** fresh-context consistency-validator findings + F7 human-gate closure (DEC-361): `cycles/CYCLE-SUMMARY.md#cycle_012_status`. **cycle-007 Wave-2 gate artifacts:** `cycles/cycle-007/burst-log.md` Burst 5 (this burst's full narrative).

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
| Demo recording (cycle-007, Story B1) | yes | Human decision: `auth list` STATUS behavior exhaustively unit-tested + snapshot-pinned; multi-profile keychain-state demo setup impractical on Gatekeeper-fragile dev host. |
| Demo recording (cycle-007, Story B2) | yes | Human decision: output-only CLI change (`auth status --output json`); covered by default-CI success-path test + keyring-gated AC tests. |
| Demo recording (cycle-007, Wave-2 gate) | yes | Prior human decision (Story B2 demo skip), carried forward to the Wave-2 gate demo-evidence check -- no new demo requirement introduced by the gate itself. |
| Demo recording (cycle-012, Story 1) | yes | Human decision: `S-cycle12-platform-adf-autoconvert` is a backend/no-UI write-path CLI change, exhaustively covered by wiremock/CLI + proptest suite; consistent with cycle-005/007 precedent. |
| Demo recording (cycle-012, Story 2) | yes | Human decision (explicit): `S-cycle12-jsm-adf-autoconvert` is a backend/no-UI JSM write-path CLI change, no per-field echo surface, exhaustively covered by wiremock/CLI + unit tests + gated live-E2E. |
| F6 Kani formal verification (cycle-012) | yes | Not set up in repo; proptest substitution JUSTIFIED at 0-GAP -- see `cycles/cycle-012/phase-f6-hardening/hardening-record.md` §2. |
| F6 cargo-fuzz (cycle-012) | yes | Not set up in repo; proptest arbitrary-input substitution JUSTIFIED at 0-GAP -- see `cycles/cycle-012/phase-f6-hardening/hardening-record.md` §2. |

**NOT a skip (human-owned post-close):** Live-Jira E2E round-trip acceptance (`H-NEW-MENTION-009`, AC-017) is **DEFERRED by human decision**, not skipped -- see `cycles/OPEN-STANDING-ITEMS.md`.

Older rows (cycle-001 through cycle-004, historical): `cycles/HISTORY-SKIP-LOG.md`.

## Blocking Issues

**NONE OPEN.** Zero Blocking Issues remain open. cycle-012 **CLOSED** 2026-09-15 (DEC-361, F7 human gate APPROVED "Approve & close"); NO RELEASE, ships on `develop @ 80bb4215`, tag deferred (cycle-005 precedent). cycle-007 Phase **F4 COMPLETE** 2026-09-15 (Wave-2 integration gate PASSED); F5/F6/F7 REMAIN, not yet started, resumable. All seven cycles (001-006, 012) CLOSED. No active cycle; pipeline idle/paused-ready. Resolved items: `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking: `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) Phase **F4 COMPLETE** 2026-09-15 -- both wave integration gates PASSED, all 5 stories merged. F5 scoped adversarial NEXT (not started, PAUSED/resumable). cycle-012 (`field-adf-autoconvert`) **CLOSED** 2026-09-15 at the Phase F7 human gate (DEC-361, "Approve & close") -- NO RELEASE, ships on `develop @ 80bb4215`, tag deferred (cycle-005 precedent). No active cycle; pipeline idle/paused-ready. Full detail: `cycles/CYCLE-SUMMARY.md#cycle_012_status`.

## Concurrent Cycles

Nine tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`)** Phase **F4 COMPLETE** 2026-09-15 (Wave-2 integration gate PASSED, `develop@80bb4215`; F5/F6/F7 REMAIN, not yet started, resumable); **cycle-012 (`field-adf-autoconvert`) CLOSED** 2026-09-15 (DEC-361, NO RELEASE, ships on `develop @ 80bb4215`, tag deferred -- cycle-005 precedent). Cycles 008-011 PARKED (not yet started). `activation_head` stays `a9168212`. No active cycle anywhere in the factory. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing currently blocking. cycle-007 host constraint (`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`: nextest unusable on dev host) carries forward.

## Session Resume Checkpoint

**Date & position:** 2026-09-15. cycle-007 (`auth-correctness-dx`) Phase **F4 COMPLETE** -- Wave-2 integration gate PASSED this burst (regression GREEN + adversarial 3/3 CLEAN + security CLEAN + consistency PASS + holdout satisfied); all 5 stories merged, both wave gates PASSED. **F5/F6/F7 REMAIN, not yet started** -- pipeline PAUSED/resumable. cycle-012 (`field-adf-autoconvert`) remains **CLOSED** (DEC-361, F7 human gate APPROVED "Approve & close", 2026-09-15) -- unaffected by this burst.

**Convergence counter:** none active -- this burst was a gate-assessment bookkeeping recording, not a convergence loop. cycle-007's F5 scoped adversarial loop has not yet started.

**In-flight work:** NONE. No open PRs (#803/#804/#805/#806/#807 all MERGED for cycle-007; #809/#810/#811/#812/#813 all MERGED for cycle-012). No story worktrees.

**Pending human decisions / blockers:** NONE open. LOW standing items unchanged plus one new addition this burst: `M-2`/`OBS-A`/`OBS-3` (cycle-012 F5 debt), pre-existing `SEC-001-EDITMETA-RECURSION-GUARD`, `E2E-COMPONENT-FILTER-SEARCH-INDEX-FLAKE` (unrelated), F6 residuals L-1/L-2, and **new**: `CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE` (OBS-C-01, LOW, process-gap -- cycle-007 story frontmatter still `draft` post-merge; candidate fix at cycle-007's F7 close). `NFR-O-N-CATALOG-RETIREMENT-EDIT` confirmed present (commit `bb0e1a9d`), not duplicated. cycle-007's F5 scoped adversarial has not yet started.

**WIP branch list:** none open.

**Resume command (future session's choice):** (a) `/vsdd-factory:session-review` for an optional cycle-012 session review; (b) `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step` to begin cycle-007's Phase F5 scoped adversarial review; or (c) `/vsdd-factory:maintenance-sweep` to burn down the deferred LOW debt.

**Counts:** total_bcs 769 (unchanged); VP count 86 (unchanged); holdout scenarios 118 (unchanged); total_stories 182 (unchanged). Prior checkpoint (STATE.md v4.35): archived to `cycles/cycle-007/session-checkpoints.md`.

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
| cycle-007 F1-F4 artifacts, burst log (incl. Burst 5 Wave-2 gate), session checkpoints, lessons | `phase-f1-delta-analysis/cycle-007-*.md`, `phase-f2-spec-evolution/cycle-007-*.md`, `cycles/cycle-007/` (`phase-f3-stories/`, `burst-log.md` Bursts 1-5, `adversarial-reviews/story-{A,C,D,B1,B2}-convergence.md`, `session-checkpoints.md`, `lessons.md`) |
| cycle-012 F1 operative delta analysis | `phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md` (v1/v2/v3 SUPERSEDED) |
| cycle-012 F2 spec evolution | `phase-f2-spec-evolution/cycle-012-verification-delta.md`, `specs/architecture/decisions/ADR-0024-adf-autoconversion-for-field-on-richtext-fields.md`, `specs/prd/bc-3-issue-write.md` |
| cycle-012 F3 stories + wave artifacts | `cycles/cycle-012/phase-f3-stories/` |
| cycle-012 burst history | `cycles/cycle-012/burst-log.md` (Bursts 1-3) |
| cycle-012 session checkpoints | `cycles/cycle-012/session-checkpoints.md` |
| cycle-012 lessons (L-001..L-010) | `cycles/cycle-012/lessons.md` |
| cycle-012 F4 Story 1/Story 2 convergence + red-gate-logs | `cycles/cycle-012/adversarial-reviews/story-S-cycle12-{platform,jsm}-adf-autoconvert-convergence.md`, `cycles/cycle-012/S-cycle12-*/implementation/red-gate-log.md` |
| cycle-012 F5 convergence trajectory (Passes 1/A/B/C) + PR review evidence | `cycles/cycle-012/convergence-trajectory.md`, `code-delivery/cycle012-f5/pr-review.md` |
| cycle-012 F6 targeted hardening record | `cycles/cycle-012/phase-f6-hardening/hardening-record.md` (commit `21d2bf0f`, verdict HARDENED) |
| cycle-012 F7 human-gate closure (DEC-361) + full status | `cycles/CYCLE-SUMMARY.md#cycle_012_status` |
| cycle-012 F1 + E2E design research + live-Jira probes | `research/field-adf-autoconvert-design-research-2026-09-12.md`, `research/e2e-environment-adf-field-2026-09-11.md`, `research/createmeta-schema-probe-2026-09-12.md`, `research/jsm-requesttype-fields-adf-probe-2026-09-12.md`, `research/createmeta-fields-endpoint-verification-2026-09-14.md`, `research/jira-adf-field-readback-shape-2026-09-14.md` |
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`BC-CITE-001 ZERO-TOLERANCE (CODIFIED, L-001)`** -- POLICY. `scripts/check-bc-citation-symbols.sh` exits 1 on ANY backtick-wrapped pending `src/...::symbol` token in BC Trace/Source. Codified in `cycles/cycle-012/lessons.md` (L-001).
- **`INPUT-HASH-DRIFT-STALE-ARTIFACTS`** -- LOW, non-blocking. Input-hash scan shows widespread STALE artifacts across prior CLOSED cycles (repo-wide pre-existing condition, unrelated to cycle-012). cycle-012's own drift was narrowed to the four accepted `[live-state]` sentinel files as of F7 convergence (see `cycles/CYCLE-SUMMARY.md#cycle_012_status`).
- **`AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM`** -- LOW, non-blocking. `jr auth refresh --api-token` doc comment has latent unconditional-notice overclaim. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`AUTH-REMEDIATION-EQUALS-FORM-BROADER`** -- LOW, non-blocking. Broader remediation remains. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking (pre-existing since cycle-004). DEC-356 EXPLICITLY ACCEPTED deferral. Target: future maintenance cycle.
- **`CYCLE-007-PARKED-BUNDLES`** -- 4 bundles PARKED: **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). Full triage: `phase-f1-delta-analysis/issue-triage-*.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap; candidate follow-up in vsdd-factory repo.
- **`MUTANTS-NIGHTLY-VERIFY-FULL-RUN`** -- LOW, non-blocking. Nightly 34858140987 CANCELLED (user decision); last two nightlies FAILED. Cron unchanged; next nightly attempt pending.
- **`E2E-EDIT-FIELD-ADF-HEURISTIC`** -- **RESOLVED/VERIFIED, cycle-012 formally CLOSED.** `test_e2e_issue_edit_custom_field` PASSED on live Jira (run `34881320608` @ `develop@67b3939a`). Formal cycle-012 closure ACHIEVED 2026-09-15 at the F7 human gate (DEC-361).
- **`E2E-COMPONENT-FILTER-SEARCH-INDEX-FLAKE`** -- LOW, non-blocking, pre-existing, unrelated to cycle-012. `test_e2e_issue_list_component_filter_grammar` intermittently fails on live Jira search-index lag. Candidate fix: poll/retry helper. Relates to PARKED cycle-010 `read-index-lag` bundle.
- **`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`** -- LOW, non-blocking, dev-host-only. `cargo-nextest` UNUSABLE for full suite. NOT a CI issue. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`VP-FIELD-ADF-001-TEXTAREA-ANCHOR`** -- LOW, non-blocking residual. VP-FIELD-ADF-001 lacks a non-canonical `:textarea`-prefix positive anchor test. Candidate for a future maintenance sweep (L-005/L-006, `cycles/cycle-012/lessons.md`).
- **`CYCLE-012-STORY2-AC-012-OUTPUT-CHANNEL-WORDING`** -- LOW, non-blocking. `S-cycle12-jsm-adf-autoconvert` AC-012 story text names stdout for the field-conversion notice; actual/correct channel is stderr (jr's Symmetric output-channel convention). Test correctly asserts stderr. Fix story-text wording in a future doc sweep / maintenance pass (L-008, `cycles/cycle-012/lessons.md`). Deferred at F7 close per human decision, not fixed now.
- **`CYCLE-012-F5-M-2-SHARED-GUARD-HELPER`** -- LOW, non-blocking. The `--markdown` + `--field description=` conflict predicate is triplicated verbatim across `create.rs`/`edit.rs`/`jsm_create.rs`; extract a shared `field_pairs_raw_key_matches` helper into `field_resolve.rs`. Deferred to a future maintenance sweep (human F7-gate decision). Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`CYCLE-012-F5-OBS-A-ENVIRONMENT-REGRESSION-TEST-GAP`** -- LOW, non-blocking. The `environment` `changed_fields` lowercase-key arm has no non-gated CI regression test (only gated E2E covers it); pre-existing Wave-1 gap. Candidate: mirror `test_obs_1` for `environment`. Deferred to a future maintenance sweep (human F7-gate decision). Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`CYCLE-012-F5-OBS-3-EC38019-4-COVERAGE-NIT`** -- LOW, non-blocking. EC-3.8.019-4's supersession case has no dedicated test; code path identical to the tested case, not a viable mutation target. Deferred to a future maintenance sweep (human F7-gate decision). Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`CYCLE-012-F6-L1-JSM-E2E-GATED-ONLY`** -- LOW, non-blocking, accepted. VP-FIELD-ADF-004's live JSM ADF round-trip is exercised only via the nightly-gated `test_e2e_jsm_create_adf_field_description_roundtrip` (e2e_live.rs:2999); matches the project-wide wiremock+gated-E2E baseline, not a gap specific to this cycle. Full detail: `cycles/cycle-012/phase-f6-hardening/hardening-record.md` §7.
- **`CYCLE-012-F6-L2-KANI-FUZZ-UNPROVISIONED`** -- LOW, informational, accepted. Kani/cargo-fuzz remain unprovisioned repo-wide (documented substitution per hardening-record.md §2); would only warrant revisiting if a future feature introduces an untrusted-input parsing surface or arithmetic-heavy pure core.
- **`SEC-001-EDITMETA-RECURSION-GUARD`** -- LOW, pre-existing since S-580-1, unrelated to cycle-012 (noted during F5 security review as not reachable via cycle-012 paths). Apply a `MAX_ADF_DEPTH`-style recursion-depth cap to `AllowedValue.children` deserialization, mirroring `adf.rs` SEC-001/BC-7.2.012. Candidate for a future maintenance sweep. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`NFR-O-N-CATALOG-RETIREMENT-EDIT`** -- LOW, non-blocking (cycle-007 Wave-2 gate finding F-B2-01). `nfr-catalog.md`'s NFR-O-N row still reads `DEFER-DOCUMENTED`; RETIRED per BC-1.6.050. `validate-stable-anchors` hook fail-closed-blocks the whole file (pre-existing TD-031 debt, unrelated rows). Target: bundle with TD-031 stable-anchor remediation in a future maintenance sweep. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE`** -- NEW this burst. LOW, non-blocking, process-gap (cycle-007 Wave-2 gate adversary Pass C, OBS-C-01). All cycle-007 F3 story frontmatter, including the merged stories (A/C/D/B1/B2), still reads `status: draft` post-merge -- systemic; STATE.md remains the authoritative status source. Candidate: status-flip sweep at cycle-007's full close (F7); also an open question whether prior CLOSED cycles left the same gap or whether this is accepted convention. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.

**RESOLVED this burst (2026-09-15, v4.36):** cycle-007 (`auth-correctness-dx`) Wave-2 integration gate **PASSED** -- regression GREEN (`auth_status_json` 31/0, lib `auth` 270/0, `auth_profiles` 46/0 on `develop@80bb4215`); Wave-2 adversarial 3 consecutive CLEAN passes (A/B/C), zero CRIT/HIGH/MED; Wave-2 security CLEAN (1 LOW accepted); consistency PASS; holdout `H-W2-INT-001` satisfied structurally. **cycle-007 Phase F4 COMPLETE** (all 5 stories merged, both wave gates PASSED). New LOW standing item `CYCLE-007-STORY-STATUS-DRAFT-POSTMERGE` recorded; `NFR-O-N-CATALOG-RETIREMENT-EDIT` confirmed already present (commit `bb0e1a9d`), not duplicated. No DEC minted (bookkeeping/automated gate, Wave-1-gate precedent). Pipeline remains PAUSED/idle -- no in-flight work started this burst; cycle-012 unaffected (still CLOSED). STATE.md v4.35->v4.36; Phase Progress row `CYCLE-007-WAVE2-GATE-PASSED-F4-COMPLETE-2026-09-15` appended (oldest row `CYCLE-012-STORY1-DELIVERED-2026-09-14` archived to `cycles/HISTORY-PHASE-PROGRESS.md`, keeping the table at 10 rows). Prior Session Resume Checkpoint (v4.35) archived to `cycles/cycle-007/session-checkpoints.md`. `cycle_007_status` frontmatter field updated to reflect F4 COMPLETE with F5/F6/F7 remaining.

**RESOLVED prior burst (2026-09-15, v4.35):** cycle-012 Phase F7 **HUMAN GATE APPROVED** -- "Approve & close" (DEC-361); release decision: ship on `develop`, NO TAG (cycle-005 precedent), changes ride `develop @ 80bb4215` into the next tagged release, CHANGELOG `[Unreleased]` entry already present. S-7.02 Cycle-Closing Checklist executed: every process-gap/novel finding is CODIFIED as a lesson (L-008 AC-012 channel wording; L-010 F5 integration-scope value; L-001..L-009 prior) or DEFERRED as tracked LOW debt with a maintenance-sweep target (`M-2`/`OBS-A`/`OBS-3`, pre-existing `SEC-001-EDITMETA-RECURSION-GUARD`) -- no open process-gap finding lacks a follow-up or justified deferral. **cycle-012 CLOSED.** Pipeline PAUSED/idle -- no active cycle; cycle-007 remains PAUSED (resumable). STATE.md v4.34->v4.35; `CYCLE-012-F7-APPROVED-CLOSED-2026-09-15` phase progress row appended (oldest row `CYCLE-012-F4-STARTED-2026-09-13` archived out to `cycles/HISTORY-PHASE-PROGRESS.md`, keeping the table at 10 rows). Prior Session Resume Checkpoint (v4.34) archived to `cycles/cycle-012/session-checkpoints.md`. `cycle_012_status` frontmatter field collapsed to a one-line CLOSED summary (mirroring `cycle_005_status`/`cycle_006_status`); full narrative routed to `cycles/CYCLE-SUMMARY.md#cycle_012_status`.

All other standing debt -- full text preserved, nothing deleted: OPEN items at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items at `cycles/RESOLVED-DRIFT-ITEMS.md`.
