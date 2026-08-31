---
document_type: pipeline-state
level: ops
version: "3.24"
status: active
producer: state-manager
timestamp: 2026-08-31T13:38:31Z
phase: F4
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). F4 (delta implementation) COMPLETE: Wave 3 delivered -- S-578-4 (PR #746 @ ae8514b8) merged, the LAST story of the field-dx bundle. All 5 bundle stories now delivered+merged: S-580-1 (#740), S-578-1 (#739), S-578-2 (#741), S-578-3 (#742), S-578-4 (#746). Session resumed from the WRAP-F4-WAVE2-COMPLETE-PAUSE position and delivered Wave 3 to completion this burst. NEXT is a human decision: proceed to F5 (scoped adversarial refinement on the full field-dx delta) -> F6 (targeted hardening) -> F7 (delta convergence + human gate), or close/pause cycle-002 here. Full detail: cycles/cycle-002/burst-log.md Burst 14 + Session Resume Checkpoint below."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "cycle-002"
feature_mode_bundle: field-dx
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- Phase F4 (delta implementation) COMPLETE 2026-08-31. All 3 waves and all 5 stories delivered/merged: Wave 1 S-578-1 (PR #739 @ 993de833) + S-580-1 (PR #740 @ 74221bbc); Wave 2 S-578-2 (PR #741 @ a3739763) + S-578-3 (PR #742 @ 41763ff0); Wave 3 S-578-4 (PR #746 @ ae8514b8). F5 scoped-adversarial review of the full 5-story delta recorded 2026-08-31 (CONVERGED, 1 MED->FIX-F5-001, 4 LOW tracked). NEXT: human decision on F6->F7 vs. close/pause. Resume via /vsdd-factory:next-step."
activation_head: "ae8514b8"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-31, F5 scoped-adversarial review-record burst):
     204 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 204 = -4 -- 4 lines OVER the soft target of 200 (soft target only, not a hard block).
     margin from actual (hard cap) = 500 - 204 = 296 lines of headroom remain before the hard cap of 500.
     This burst records the Phase F5 scoped-adversarial review of the integrated
     field-dx delta (91d04fe1..ae8514b8, all 5 bundle stories) at
     .factory/phase-f5-adversarial/adversarial-delta-review.md -- CONVERGED, zero
     CRITICAL/HIGH, 1 MEDIUM (get_issue_types_for_project pagination-termination
     gap, being fixed as FIX-F5-001) and 4 LOW findings. Three of the four LOW
     findings are NEW tracked-debt ids appended to Drift/Standing Items this burst:
     F5-EDIT-GATEB-SHARE, F5-ISSUETYPE-CASEFOLD-SPLIT, F5-VP578021-WEAK-NEGPIN (the
     fourth LOW cross-references the pre-existing S-578-3-SHARED-ASSET-VALIDATOR
     id, no new id opened). Per explicit dispatch instruction this burst does NOT
     transition the pipeline phase or version field -- phase stays F4, version
     stays v3.24 -- this is the F5 review record, not the F5-close transition;
     only timestamp, cycle_002_status, and Drift/Standing Items changed. No BC/VP/
     holdout counts changed (719/32/106); no source code touched this burst (the
     FIX-F5-001 fix itself is tracked separately, not yet landed). One
     full-content Write, no Edit chain (DEC-247).
     Pre-compaction (pre-2026-08-25) full history remains at factory-artifacts commit 43f4a5e3. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst) |
| **Last Updated** | F5 SCOPED-ADVERSARIAL REVIEW RECORDED (2026-08-31): trajectory-tail →1→3→0→2 (unchanged this burst). Integrated field-dx delta (5 stories) reviewed -- CONVERGED, 1 MED (FIX-F5-001 in progress) + 4 LOW (3 new tracked-debt ids). Phase/version unchanged (F4 / v3.24) -- review record only, not the F5-close transition. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- **Phase F4 (delta implementation) COMPLETE**; F5 scoped-adversarial review of the full delta now recorded (CONVERGED). NEXT: human decision on F6/F7 vs. close/pause. cycle-001 remains CLOSED, historical. |
| **Activation HEAD** | ae8514b8 (`develop` tip after PR #746 merge; `v0.7.0-dev.2`) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F4-WAVE-1-COMPLETE | **COMPLETE** | 2026-08-26 | per-story-delivery pipeline (5-round adversarial convergence) + pr-reviewer (PR #740) | S-580-1 (`jr field options <field>`, BC-X.14.001-004). PR #740 squash-merged @ `74221bbc`. Wave 1 fully closed. 6 NON-BLOCKING pr-reviewer follow-ups tracked. Full detail: `cycles/cycle-002/burst-log.md` Burst 11. | 29→24→21→7→4→3→0 |
| F4-WAVE-2-COMPLETE | **COMPLETE** | 2026-08-27 | per-story-delivery (Red Gate + 3/3 adversary CLEAN + security APPROVE + pr-reviewer) x2 | S-578-2 (PR #741 @ `a3739763`) + S-578-3 (PR #742 @ `41763ff0`). Both 4-pass adversary convergence (P1 BLOCKING → fixed, P2-P4 clean). Wave 2 fully closed. Full detail: Bursts 12-13. | 2MED+5LOW→0 / 1HIGH+2MED→0, both then 3× clean |
| WRAP-F4-WAVE2-COMPLETE-PAUSE | **PAUSED** | 2026-08-27 | human (/wrap) | Human-requested session wrap at the Wave 2 COMPLETE checkpoint. Superseded by session resume. | n/a — pause event |
| F4-WAVE-3-COMPLETE | **COMPLETE** | 2026-08-31 | per-story-delivery (Red Gate + 14-pass adversarial CONVERGED STRICT, final 3 CLEAN) + security-reviewer CLEAN + pr-reviewer APPROVE | S-578-4 (platform `issue create --field` support, DEC-188 reversal via DEC-310, BC-3.3.010/011/3.4.014/3.8.012/013). PR #746 squash-merged @ `ae8514b8`. **WAVE 3 COMPLETE — cycle-002 Phase F4 (delta implementation) COMPLETE.** All 5 field-dx bundle stories delivered+merged. CI 15/15 green incl. CI Gate + mutation testing. Full detail: `cycles/cycle-002/burst-log.md` Burst 14. | 14 passes, final 3× CLEAN |
| F5-SCOPED-ADVERSARIAL-REVIEW | **CONVERGED** | 2026-08-31 | primary-adversary, scoped-delta review | Integrated field-dx delta (`91d04fe1..ae8514b8`, all 5 stories) reviewed as one unit. Zero CRITICAL/HIGH. 1 MEDIUM (`get_issue_types_for_project` pagination-termination gap) -> FIX-F5-001 in progress. 4 LOW: 3 new tracked-debt ids (`F5-EDIT-GATEB-SHARE`, `F5-ISSUETYPE-CASEFOLD-SPLIT`, `F5-VP578021-WEAK-NEGPIN`) + 1 cross-ref to existing `S-578-3-SHARED-ASSET-VALIDATOR`. Full report: `phase-f5-adversarial/adversarial-delta-review.md`. | pass 1: 5 findings (0 CRIT, 0 HIGH, 1 MED, 4 LOW), CONVERGENCE_REACHED |

## Current Phase Steps (cycle-002, phase F4/F5; last 5)

| Step | Status | Notes |
|------|--------|-------|
| Adversary convergence (S-578-4) | **CONVERGED STRICT** | 14 passes total; zero production-logic defects after pass 2; final 3 passes CLEAN. 3 process-gap spec-quality lessons captured (AC/Task placement conflict; File-Structure vs. Architecture-Mapping self-contradiction; test-inversion naming gap). |
| PR #746 opened, reviewed, converged | **APPROVE** | security-reviewer CLEAN; pr-reviewer APPROVE, 1 cycle, 0 blocking. CI 15/15 green incl. CI Gate + mutation testing. |
| S-578-4 PR #746 merged | **MERGED @ ae8514b8** | Squash-merged to `develop` (2026-08-31T06:16:25Z). `activation_head` advanced `41763ff0` -> `ae8514b8`. STORY-INDEX.md + sprint-state.yaml S-578-4 row set to `status: completed`. **WAVE 3 COMPLETE. cycle-002 Phase F4 COMPLETE.** |
| F5 scoped-adversarial review dispatched | **RUN** | Primary-adversary review of the integrated 5-story field-dx delta (`91d04fe1..ae8514b8`), scoped to integration seams across the bundle rather than re-litigating per-story findings already converged in F4. |
| F5 review recorded | **CONVERGED** | Zero CRITICAL/HIGH. 1 MEDIUM -> FIX-F5-001 (in progress, branch `fix/F5-001-issuetypes-pagination`). 4 LOW: 3 new tracked-debt ids appended to Drift/Standing Items, 1 cross-referenced to existing debt. Report committed at `phase-f5-adversarial/adversarial-delta-review.md`. Phase/version left at F4/v3.24 this burst -- review record only, not the F5-close transition. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25/26 | product-owner; human (approved) |
| F-3 | D2 collision-guard extension to the JSM create path -- **RESOLVED: retain the pre-existing last-wins behavior**, no guard extension | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform | F2 | 2026-08-26 | human (decided) |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>` | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md` | F1/F2 | 2026-08-25 (Accepted); amendments through round-6 | architect |
| DEC-309 (historical, cycle-001) | `list-read-ergonomics` cycle closure -- MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized | F7 5-dimensional convergence PASS | F7 | 2026-08-24 | human (authorized) |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|----------------|
| UX Spec (cycle-002) | yes | `jr` is a CLI-only product; field-dx bundle adds no UI surfaces. |
| DTU creation (cycle-002) | yes | `dtu_required: false` -- no external service behavior is being cloned by this bundle. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| (none currently open) | -- the DEC-namespace disambiguation question is tracked debt, not a hard blocker | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2 CONVERGED (streak-6) and human-approved. F3 COMPLETE. F4 COMPLETE -- Wave 1 (S-578-1 #739, S-580-1 #740), Wave 2 (S-578-2 #741, S-578-3 #742), and Wave 3 (S-578-4 #746) all delivered + merged; all 5 field-dx bundle stories closed. **F5 scoped-adversarial review of the integrated delta now CONVERGED** (zero CRITICAL/HIGH; 1 MEDIUM -> FIX-F5-001 in progress; 4 LOW tracked). No convergence loop open, nothing in-flight. **Human decision pending:** proceed to F6 (targeted hardening) -> F7 (delta convergence + human gate), or close/pause cycle-002 at this point. No BC/VP/holdout counts changed (719/32/106).

## Concurrent Cycles

Two tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is ACTIVE, F4 (delta implementation) COMPLETE (all 3 waves, all 5 stories merged), F5 scoped-adversarial review CONVERGED, awaiting human decision on F6/F7 vs. close/pause. No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Date:** 2026-08-31. **Position:** Feature Mode cycle-002 (`field-dx`, GitHub issues #580 + #578) -- Phase **F4 COMPLETE**, Phase **F5 (scoped adversarial review) CONVERGED** this burst. 5-story decomposition, full F1-F7 lifecycle, DTU not required.

**This burst:** Phase F5 scoped-adversarial review of the full integrated field-dx delta (`91d04fe1..ae8514b8`, all 5 stories: S-578-1/S-580-1/S-578-2/S-578-3/S-578-4) recorded at `phase-f5-adversarial/adversarial-delta-review.md`. **Verdict: CONVERGED** -- zero CRITICAL/HIGH findings. 1 MEDIUM (`get_issue_types_for_project` missing the pagination-termination safeguards its twin `get_createmeta_fields` gained this cycle -- MAX page bound + total-absent full-page heuristic; CWE-400-adjacent, undermines VP-578-020 in the total-absent branch) is being delivered as **FIX-F5-001** (branch `fix/F5-001-issuetypes-pagination`), not tracked as standing debt. 4 LOW findings: `F5-EDIT-GATEB-SHARE` (edit.rs Gate B not on the shared ADR-0019 §D2 overlap helper), `F5-ISSUETYPE-CASEFOLD-SPLIT` (ASCII vs. Unicode case-fold divergence on issue-type name resolution), `F5-VP578021-WEAK-NEGPIN` (weak test assertion), and one cross-reference to the pre-existing `S-578-3-SHARED-ASSET-VALIDATOR` id (no new id opened for the `:asset` validator duplication). No source code changed this burst -- FIX-F5-001 itself is tracked but not yet landed. Phase/version deliberately left at F4/v3.24 -- this is the review record, not the F5-close transition.

**Wave 3 / F4 COMPLETE (prior burst):** S-578-4 (platform `issue create --field` support + DEC-188 reversal via DEC-310, PR #746 @ `ae8514b8`, 2026-08-31T06:16:25Z) DELIVERED + MERGED -- the LAST story in the field-dx bundle. `develop` @ `ae8514b8` (`v0.7.0-dev.2`, re-derived from `Cargo.toml`, confirmed unchanged). Red Gate PASS; adversarial convergence CONVERGED STRICT (14 passes, final 3 CLEAN); security-reviewer CLEAN; pr-reviewer APPROVE (1 cycle, 0 blocking); CI 15/15 green incl. CI Gate + mutation testing. Demo evidence: `.factory/demos/S-578-4/`. Waves 1-2 (S-578-1 #739, S-580-1 #740, S-578-2 #741, S-578-3 #742) remain COMPLETE, unchanged. F1/F2/F3 COMPLETE + human-approved (unchanged). Counts: 719 total BCs (BC-INDEX v6.82), 32 VPs, 106 holdout scenarios -- unchanged.

**All 5 field-dx bundle stories delivered + merged:** S-580-1 (#740), S-578-1 (#739), S-578-2 (#741), S-578-3 (#742), S-578-4 (#746).

**NEXT on resume:** **Human decision required.** cycle-002 Phase F4 is complete and F5 (scoped adversarial review) is CONVERGED. Options: (a) land FIX-F5-001 then proceed to Phase F6 (targeted hardening) -> F7 (delta convergence + human gate) to formally close cycle-002; or (b) close/pause cycle-002 here, given the delta is now adversarially reviewed as a whole and each story already passed its own per-story gate. No implementation work is queued pending this decision besides FIX-F5-001 itself.

**In-flight:** FIX-F5-001 (branch `fix/F5-001-issuetypes-pagination`) is the only tracked follow-up; not yet landed. No worktrees, PRs, or adversary convergence loops otherwise open.

**Infra observation carried forward:** the `github-ops` sub-agent stalled on every dispatch this session (dependency check, stale-verdict check, merge) without returning completion reports, though the underlying `gh`/`git` actions succeeded; pr-manager fell back to direct `gh`/`git` verification. Worth investigating before the next PR cycle if the pattern recurs (logged as an observation, not a blocking process gap). Prior environment notes (manual-merge requirement, `validate-pr-review-posted` hook loop on author-owned PRs, demo-recorder race) remain relevant for any future story delivery in this repo.

**Phase-5 tracked debt (restated, full detail in Drift/Standing Items below):** `F5-EDIT-GATEB-SHARE`, `F5-ISSUETYPE-CASEFOLD-SPLIT`, `F5-VP578021-WEAK-NEGPIN`, `SEC-001-EDITMETA-RECURSION-GUARD`, `S-578-3-SHARED-ASSET-VALIDATOR`, `S-578-3-FIELDVALUESPEC-RELOCATION`, `S-578-3-PR742-RESIDUAL-NITS`, `S-578-2-PR741-RESIDUAL-NITS`.

**Pending human decisions / blockers:** the F6/F7-vs-close decision above. Otherwise NONE; full-autonomous-run mandate stands for whichever path is chosen.

**Resume command:** `/vsdd-factory:next-step` -- reads STATE.md and surfaces the F6-vs-close decision point for cycle-002.

**Superseded checkpoint:** the prior F4-COMPLETE checkpoint (v3.24, 2026-08-31, pre-F5) is superseded in place by this burst's F5-CONVERGED position above. The WRAP-F4-WAVE2-COMPLETE-PAUSE checkpoint (v3.23, 2026-08-27) is archived to `cycles/cycle-002/session-checkpoints.md`, alongside all prior cycle-002 checkpoints. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-6 = F2 adversary rounds; Burst 7 = streak-6 close; Burst 8 = F2 gate APPROVED + F2->F3; Burst 9 = F3 decomposition; Burst 10 = S-578-1 merged; Burst 11 = S-580-1 merged, WAVE 1 COMPLETE; Burst 12 = S-578-2 merged; Burst 13 = S-578-3 merged, WAVE 2 COMPLETE; Burst 14 = S-578-4 merged, WAVE 3 COMPLETE / F4 COMPLETE) |
| F5 scoped-adversarial review report | `phase-f5-adversarial/adversarial-delta-review.md` (full findings detail, disposition summary, novelty assessment) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (all prior F2/F3/F4 checkpoints incl. WRAP-F4-WAVE2-COMPLETE-PAUSE archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-002 lessons learned | `cycles/cycle-002/lessons.md` (round-6's [process-gap] lesson; S-578-2's 2 [infra-observation] lessons; S-578-3's 2 [content] + 1 [infra-observation] lessons; S-578-4's 3 [process-gap] + 1 [infra-observation] lessons) |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| S-578-2 delivery artifacts | `cycles/cycle-002/S-578-2/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-2/pr-review.md` |
| S-578-3 delivery artifacts | `cycles/cycle-002/S-578-3/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-3/pr-review.md` |
| S-578-4 delivery artifacts | `cycles/cycle-002/S-578-4/adversary-convergence-state.json`; `code-delivery/S-578-4/`; demo evidence at `.factory/demos/S-578-4/` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**New (2026-08-31, F5 scoped-adversarial review — `phase-f5-adversarial/adversarial-delta-review.md`):**
- `F5-EDIT-GATEB-SHARE` (LOW) -- `edit.rs:155-193` Gate B not refactored onto the shared `detect_flag_field_overlap` helper (ADR-0019 §D2); only `create.rs` wired to it. Behavior correct, error strings consistent; deliberately out-of-scope for S-578-4.
- `F5-ISSUETYPE-CASEFOLD-SPLIT` (LOW) -- `field_resolve.rs::resolve_against_createmeta` (`eq_ignore_ascii_case`) vs. `field.rs` (`to_lowercase()`) diverge on issue-type name→id case-folding. Negligible (issue-type names near-always ASCII).
- `F5-VP578021-WEAK-NEGPIN` (LOW) -- `tests/issue_create_field.rs::test_vp_578_021_negative_pin_display_name_spelling_does_not_trip_guard` asserts only `!requests.is_empty()`, not exit-0/POST-body/last-wins residual.
- 1 MEDIUM finding (`get_issue_types_for_project` pagination-termination-safeguard gap vs. its twin `get_createmeta_fields`) is being fixed as FIX-F5-001 (branch `fix/F5-001-issuetypes-pagination`), not tracked as standing debt.

**New (2026-08-30/31, S-578-4 / PR #746):**
- No new LOW-severity drift items tracked this burst -- pr-reviewer APPROVE was 0-blocking with no residual-nits list called out to state-manager. 3 process-gap spec-quality lessons captured instead (see `cycles/cycle-002/lessons.md` Process-Level 3-5): AC-to-Task placement conflict, File-Structure/Architecture-Mapping spec self-contradiction, test-inversion naming gap.

**Still open (2026-08-27, S-578-3 / PR #742):**
- `S-578-3-SHARED-ASSET-VALIDATOR` (LOW) -- extract a shared `validate_asset_value` helper used by BOTH `field_resolve.rs::compose_asset_hint` (platform) and `jsm_create.rs::resolve_asset_field_l2` (JSM). Cross-referenced (not duplicated) by the F5 review's `:asset` validator-duplication finding, 2026-08-31.
- `S-578-3-FIELDVALUESPEC-RELOCATION` (LOW, architectural) -- move `FieldValueSpec`/`FieldValueKind` from `cli/issue/create.rs` to a neutral `src/types/` module.
- `S-578-3-PR742-RESIDUAL-NITS` (LOW) -- residual pr-reviewer non-blocking nits on #742; details in `.factory/code-delivery/S-578-3/pr-review.md`.

**Still open (2026-08-27, S-578-2 / PR #741):**
- `SEC-001-EDITMETA-RECURSION-GUARD` (LOW, security-hardening follow-up) -- apply a MAX_ADF_DEPTH-style recursion-depth cap to `AllowedValue.children` serde deserialization in `src/types/jira/editmeta.rs`. Candidate for a future F6 pass on this bundle.
- `S-578-2-PR741-RESIDUAL-NITS` (LOW) -- 7 residual pr-reviewer NON-BLOCKING findings; details in `code-delivery/S-578-2/pr-review.md`.

**Still open (2026-08-26, PR #740 pr-reviewer NON-BLOCKING follow-ups):**
- `S-580-1-PR740-S1`/`S2`/`S3`, `S-580-1-PR740-N1`/`N2` (all LOW) -- pagination-truncation risk, untested fallback, test-naming, citation, CLAUDE.md tree gap. Tracked debt.
- `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE` (LOW, spec-hygiene) -- eligible for upgrade to enforced symbol-form now that `get_createmeta_fields` is implemented and reused across S-580-1/S-578-4. Tracked, not blocking.

**Still open (unchanged from streak-6, LOW doc-hygiene, non-blocking):**
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION`, `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED`, `M1-EDITMETA-STATUS-PERMISSION-CAVEAT`, `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE` (all LOW) -- tracked for cycle close.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process) -- flat `DEC-NNN` prefix shared by spec-authored and cycle-gate DECs, no central registry. Revisit at cycle-002 close.
- `BC-INDEX-GUARD-GAP`, `GUARD-SCOPE-COPY-PASTE-PATTERN`, `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` (all LOW/process, unchanged) -- logged in `cycles/cycle-002/lessons.md`.

**New (2026-08-25):** `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW, missing holdouts for 4 flags); `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW, pre-existing, unrelated to field-dx). Candidate: reactivate vsdd-factory plugin rc.20 to rc.23.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~145 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a field-dx / cycle-002 item.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
