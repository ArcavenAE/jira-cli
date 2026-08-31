---
document_type: pipeline-state
level: ops
version: "3.25"
status: active
producer: state-manager
timestamp: 2026-08-31T14:50:00Z
phase: F5
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). F5 (scoped adversarial review) COMPLETE: primary-adversary pass CONVERGED (0 CRIT/HIGH, 1 MED, 4 LOW); the MEDIUM fixed as FIX-F5-001, PR #747 merged @ 4e4ae4f5; 4 LOW tracked non-blocking. NEXT: Phase F6 (targeted hardening — fuzz/mutation/formal on the delta + full regression & security scan), then F7 (delta convergence + human gate). Full detail: cycles/cycle-002/burst-log.md Burst 15 + phase-f5-adversarial/convergence-summary.md."
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
cycle_002_status: "field-dx -- Phase F5 (scoped adversarial review) COMPLETE 2026-08-31. All 5 stories delivered/merged (F4). F5 primary-adversary review CONVERGED: 0 CRIT/HIGH, 1 MED -> FIX-F5-001 (PR #747 @ 4e4ae4f5, merged), 4 LOW tracked non-blocking. NEXT: Phase F6 (targeted hardening) -> F7 (delta convergence + human gate). Resume via /vsdd-factory:next-step."
activation_head: "4e4ae4f5"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-31, F5-close / F5->F6 transition burst):
     197 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 197 = 3 -- 3 lines UNDER the soft target of 200 (within budget).
     margin from actual (hard cap) = 500 - 197 = 303 lines of headroom remain before the hard cap of 500.
     This burst closes Phase F5 for cycle-002 (field-dx): the ADV-P01-MED-001
     pagination-termination-gap finding was fixed as FIX-F5-001 (PR #747,
     merge commit 4e4ae4f5, 2026-08-31T14:46:55Z) -- get_issue_types_for_project
     now shares get_createmeta_fields' MAX_CREATEMETA_PAGES bound + total-absent
     full-page heuristic. Full convergence record written to
     phase-f5-adversarial/convergence-summary.md (findings-by-severity,
     secondary-tier-skip justification, novelty, verdict CONVERGED). phase
     frontmatter field advances F4 -> F5 (F5 now COMPLETE); activation_head
     advances ae8514b8 -> 4e4ae4f5; activation_version re-derived from
     Cargo.toml on develop @ 4e4ae4f5 -- confirmed unchanged at v0.7.0-dev.2.
     This burst also compacts STATE.md: the F4-WAVE-1/F4-WAVE-2/WRAP-PAUSE
     Phase Progress rows and the pre-F5 Session Resume Checkpoint text are
     archived to cycles/cycle-002/burst-log.md (already fully narrated there,
     Bursts 11-14) and cycles/cycle-002/session-checkpoints.md respectively --
     STATE.md keeps only the current F4-WAVE-3/F5-COMPLETE rows and the
     latest checkpoint. No BC/VP/holdout counts changed (719/32/106). One
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
| **Last Updated** | F5 COMPLETE / TRANSITION TO F6 (2026-08-31): trajectory-tail →1→3→0→2 (unchanged this burst). FIX-F5-001 merged (PR #747 @ 4e4ae4f5); F5 primary-adversary review CONVERGED (0 CRIT/HIGH, 1 MED fixed, 4 LOW tracked). Phase advances F4 -> F5. NEXT: Phase F6 (targeted hardening). |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- **Phase F5 (scoped adversarial review) COMPLETE**. NEXT: **Phase F6 (targeted hardening)** -- fuzz/mutation/formal verification on the delta + full regression & security scan on the full tree -- then **Phase F7** (delta convergence + human gate). cycle-001 remains CLOSED, historical. |
| **Activation HEAD** | 4e4ae4f5 (`develop` tip after PR #747/FIX-F5-001 merge; `v0.7.0-dev.2`) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F4-WAVE-3-COMPLETE | **COMPLETE** | 2026-08-31 | per-story-delivery (Red Gate + 14-pass adversarial CONVERGED STRICT, final 3 CLEAN) + security-reviewer CLEAN + pr-reviewer APPROVE | S-578-4 (platform `issue create --field` support, DEC-188 reversal via DEC-310). PR #746 squash-merged @ `ae8514b8`. **WAVE 3 COMPLETE — cycle-002 Phase F4 (delta implementation) COMPLETE.** All 5 field-dx bundle stories delivered+merged. Full detail: `cycles/cycle-002/burst-log.md` Burst 14. | 14 passes, final 3× CLEAN |
| F5-SCOPED-ADVERSARIAL-COMPLETE | **CONVERGED** | 2026-08-31 | primary-adversary scoped review (F5 gate; secondary tier SKIPPED, justified) | Integrated field-dx delta (`91d04fe1..ae8514b8`, all 5 stories) reviewed as one unit. Zero CRITICAL/HIGH. 1 MEDIUM (`get_issue_types_for_project` pagination-termination gap) -> **FIX-F5-001 merged, PR #747 @ `4e4ae4f5`**. 4 LOW tracked non-blocking (`S-578-3-SHARED-ASSET-VALIDATOR` cross-ref, `F5-EDIT-GATEB-SHARE`, `F5-ISSUETYPE-CASEFOLD-SPLIT`, `F5-VP578021-WEAK-NEGPIN`). Full report: `phase-f5-adversarial/adversarial-delta-review.md` + `phase-f5-adversarial/convergence-summary.md`. | pass 1: 5 findings (0 CRIT, 0 HIGH, 1 MED, 4 LOW) -> MED fixed, CONVERGENCE_REACHED |

## Current Phase Steps (cycle-002, phase F5→F6; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F5 primary-adversary review dispatched | **RUN** | Fresh-context, delta-scoped (`91d04fe1..ae8514b8`, all 5 stories). First dispatch died on a transient API connection error and was re-run — logged as a transport retry, not a review round. |
| F5 review converged | **CONVERGED** | 0 CRIT/HIGH, 1 MEDIUM, 4 LOW. Secondary review-tier (Step 7) SKIPPED — justified (see `convergence-summary.md`). |
| FIX-F5-001 delivered + merged | **MERGED @ 4e4ae4f5** | PR #747 (2026-08-31T14:46:55Z). `get_issue_types_for_project` now mirrors `get_createmeta_fields`'s MAX-page bound + total-absent heuristic. security-reviewer CLEAN; pr-reviewer APPROVE; CI green. |
| F5 phase closed | **COMPLETE** | `phase-f5-adversarial/convergence-summary.md` written. `activation_head` advanced `ae8514b8` → `4e4ae4f5`. Phase frontmatter advanced F4 → F5. |
| STATE.md compacted | **DONE** | F4-WAVE-1/F4-WAVE-2/WRAP-PAUSE rows and pre-F5 checkpoint archived to `cycles/cycle-002/burst-log.md` (Bursts 11-13, already fully narrated) and `session-checkpoints.md`. |

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
| F5 secondary review-tier (Step 7) | yes | Every story already individually adversarially converged in F4; primary pass found only 1 low-likelihood MED + 4 LOW. Full justification: `phase-f5-adversarial/convergence-summary.md`. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| (none currently open) | -- the DEC-namespace disambiguation question is tracked debt, not a hard blocker | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): historical, unchanged this burst.

`cycle-002` (`field-dx`) F2 CONVERGED (streak-6) and human-approved. F3 COMPLETE. F4 COMPLETE (all 3 waves, all 5 stories merged). **F5 (scoped adversarial review) now COMPLETE** — primary-adversary pass CONVERGED (0 CRIT/HIGH, 1 MEDIUM fixed as FIX-F5-001/PR #747, 4 LOW tracked non-blocking); secondary tier skipped, justified. No convergence loop open, nothing in-flight. **NEXT:** Phase F6 (targeted hardening — fuzz/mutation/formal verification on the delta + full regression & security scan) → Phase F7 (delta convergence + human gate). No BC/VP/holdout counts changed (719/32/106).

## Concurrent Cycles

Two tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is ACTIVE, Phase F5 COMPLETE, queued to start Phase F6 (targeted hardening). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Date:** 2026-08-31. **Position:** Feature Mode cycle-002 (`field-dx`, GitHub issues #580 + #578) -- Phase **F5 (scoped adversarial review) COMPLETE** this burst. 5-story decomposition, full F1-F7 lifecycle, DTU not required.

**This burst:** FIX-F5-001 (branch `fix/F5-001-issuetypes-pagination`) delivered and merged — PR #747, merge commit `4e4ae4f5` on `develop` (2026-08-31T14:46:55Z). `get_issue_types_for_project` now mirrors `get_createmeta_fields`'s `MAX_CREATEMETA_PAGES` bound and total-absent full-page heuristic; regression test `test_vp_578_020b_type_on_issuetypes_page_2_resolves_when_total_absent` (RED→GREEN). security-reviewer confirmed genuine CWE-400 mitigation, no new risk. pr-reviewer APPROVE. CI green. With the MEDIUM fixed, **Phase F5 is now COMPLETE**: full convergence record written to `phase-f5-adversarial/convergence-summary.md` (findings-by-severity, secondary-tier-skip justification, novelty assessment, final verdict CONVERGED). `activation_head` advanced `ae8514b8` → `4e4ae4f5`; `activation_version` re-derived from `Cargo.toml` on `develop` @ `4e4ae4f5` — confirmed unchanged at `v0.7.0-dev.2`. Phase frontmatter field advanced `F4` → `F5`. 4 LOW findings remain tracked, non-blocking (see Drift/Standing Items).

**F4 (prior, unchanged):** all 5 field-dx bundle stories delivered + merged: S-580-1 (#740), S-578-1 (#739), S-578-2 (#741), S-578-3 (#742), S-578-4 (#746). Counts: 719 total BCs (BC-INDEX v6.82), 32 VPs, 106 holdout scenarios -- unchanged.

**NEXT on resume:** proceed to **Phase F6 (targeted hardening)** — fuzz testing, mutation testing, and formal verification scoped to the field-dx delta, plus full regression and security scans on the full tree — then **Phase F7** (delta convergence + human gate) to formally close cycle-002. No implementation work is queued besides F6 itself.

**In-flight:** none. FIX-F5-001 is delivered and merged; no worktrees, PRs, or adversary convergence loops open.

**Infra observation carried forward:** the `github-ops` sub-agent has stalled on prior dispatches this cycle (dependency check, stale-verdict check, merge) without returning completion reports, though the underlying `gh`/`git` actions succeeded; pr-manager fell back to direct `gh`/`git` verification. Worth investigating before the next PR cycle if the pattern recurs. Prior environment notes (manual-merge requirement, `validate-pr-review-posted` hook loop on author-owned PRs, demo-recorder race) remain relevant for any future story delivery in this repo.

**Pending human decisions / blockers:** none. Full-autonomous-run mandate stands for Phase F6.

**Resume command:** `/vsdd-factory:next-step` -- reads STATE.md and surfaces Phase F6 (targeted hardening) as the next step for cycle-002.

**Superseded checkpoint:** the prior F5-review-recorded checkpoint (v3.24, 2026-08-31, pre-FIX-F5-001) is superseded in place by this burst's F5-COMPLETE position above and archived to `cycles/cycle-002/session-checkpoints.md`, alongside the F4-COMPLETE (v3.24 pre-F5) and `WRAP-F4-WAVE2-COMPLETE-PAUSE` (v3.23, 2026-08-27) checkpoints. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-6 = F2 adversary rounds; Burst 7 = streak-6 close; Burst 8 = F2 gate APPROVED + F2->F3; Burst 9 = F3 decomposition; Burst 10 = S-578-1 merged; Burst 11 = S-580-1 merged, WAVE 1 COMPLETE; Burst 12 = S-578-2 merged; Burst 13 = S-578-3 merged, WAVE 2 COMPLETE; Burst 14 = S-578-4 merged, WAVE 3 COMPLETE / F4 COMPLETE; Burst 15 = F5 CONVERGED + FIX-F5-001 merged, F5 COMPLETE / transition to F6) |
| F5 scoped-adversarial review report | `phase-f5-adversarial/adversarial-delta-review.md` (raw pass-1 findings); `phase-f5-adversarial/convergence-summary.md` (F5 close record) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (all prior F2/F3/F4/F5-review checkpoints archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-002 lessons learned | `cycles/cycle-002/lessons.md` |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| S-578-2 delivery artifacts | `cycles/cycle-002/S-578-2/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-2/pr-review.md` |
| S-578-3 delivery artifacts | `cycles/cycle-002/S-578-3/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-3/pr-review.md` |
| S-578-4 delivery artifacts | `cycles/cycle-002/S-578-4/adversary-convergence-state.json`; `code-delivery/S-578-4/`; demo evidence at `.factory/demos/S-578-4/` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**New (2026-08-31, F5 scoped-adversarial review — `phase-f5-adversarial/convergence-summary.md`):**
- `F5-EDIT-GATEB-SHARE` (LOW) -- `edit.rs:155-193` Gate B not refactored onto the shared `detect_flag_field_overlap` helper (ADR-0019 §D2); only `create.rs` wired to it. Behavior correct, error strings consistent; deliberately out-of-scope for S-578-4.
- `F5-ISSUETYPE-CASEFOLD-SPLIT` (LOW) -- `field_resolve.rs::resolve_against_createmeta` (`eq_ignore_ascii_case`) vs. `field.rs` (`to_lowercase()`) diverge on issue-type name→id case-folding. Negligible (issue-type names near-always ASCII).
- `F5-VP578021-WEAK-NEGPIN` (LOW) -- `tests/issue_create_field.rs::test_vp_578_021_negative_pin_display_name_spelling_does_not_trip_guard` asserts only `!requests.is_empty()`, not exit-0/POST-body/last-wins residual.
- (The MEDIUM finding, `get_issue_types_for_project` pagination-termination-safeguard gap, is no longer tracked debt — fixed as FIX-F5-001, PR #747 @ `4e4ae4f5`, merged.)

**Still open (2026-08-27, S-578-3 / PR #742):**
- `S-578-3-SHARED-ASSET-VALIDATOR` (LOW) -- extract a shared `validate_asset_value` helper used by BOTH `field_resolve.rs::compose_asset_hint` (platform) and `jsm_create.rs::resolve_asset_field_l2` (JSM). Cross-referenced (not duplicated) by the F5 review's `:asset` validator-duplication finding, 2026-08-31.
- `S-578-3-FIELDVALUESPEC-RELOCATION` (LOW, architectural) -- move `FieldValueSpec`/`FieldValueKind` from `cli/issue/create.rs` to a neutral `src/types/` module.
- `S-578-3-PR742-RESIDUAL-NITS` (LOW) -- residual pr-reviewer non-blocking nits on #742; details in `.factory/code-delivery/S-578-3/pr-review.md`.

**Still open (2026-08-27, S-578-2 / PR #741):**
- `SEC-001-EDITMETA-RECURSION-GUARD` (LOW, security-hardening follow-up) -- apply a MAX_ADF_DEPTH-style recursion-depth cap to `AllowedValue.children` serde deserialization in `src/types/jira/editmeta.rs`. Candidate for the F6 targeted-hardening pass on this bundle.
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
