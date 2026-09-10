---
document_type: pipeline-state
level: ops
version: "4.04"
status: active
producer: state-manager
timestamp: 2026-09-10T20:33:15Z
phase: "PAUSED 2026-09-10 (unchanged). Position: all six tracked cycles (001-006) CLOSED, no OPEN cycle. This burst performed a /compact-state STATE.md compaction (v4.03->v4.04): extracted historical narrative into cycles/ files per the governing extract-history/keep-live-state principle; no phase/cycle transition. Resume by opening a new feature cycle or making a release decision (see Session Resume Checkpoint)."
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-10, v4.04, state-manager -- STATE-MD-COMPACT-2026-09-10 (/compact-state skill): extracted historical content (verbose per-cycle frontmatter status paragraphs, SIZE BUDGET banner narrative, 2 oldest Phase Progress rows, full cycle-005 Burst-13 Current-Phase-Steps checklist, giant Decisions-Log cycle-005/006 narrative notes, resolved Blocking-Issues/Drift detail, cycle-002/003/004 Skip Log rows, verbose Historical-Content-table per-burst descriptions, full live Session-Resume-Checkpoint text) into cycles/ files (CYCLE-SUMMARY.md, HISTORY-PHASE-PROGRESS.md, RESOLVED-DRIFT-ITEMS.md, OPEN-STANDING-ITEMS.md, HISTORY-SKIP-LOG.md, HISTORICAL-CONTENT-INDEX-DETAIL.md, plus appends to cycles/cycle-005/burst-log.md, cycles/cycle-006/burst-log.md, cycles/cycle-005/session-checkpoints.md) -- nothing deleted, every pointer verified to resolve to a real written file. STATE.md 447->196 lines (single full-content Write, no sequential Edits, PC-12 clean worktree). Marked STATE-MD-OVER-SOFT-TARGET RESOLVED 2026-09-10; the other two open follow-ups (VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP, MUTANTS-NIGHTLY-VERIFY-FULL-RUN) left OPEN, unchanged, still visible. Pipeline stays PAUSED; no phase transition, no cycle change; counts unchanged (754/76/118/175); trajectory-tail unchanged →1→3→0→2."
current_step: "D-chain cite D-053, D-2026 latest brownfield. STATE-MD-COMPACT-2026-09-10: state-manager executed the /compact-state skill on STATE.md (447 lines, ~2.2x the 200-line soft target) in a single atomic burst on factory-artifacts (TD-VSDD-053), per human request. Extraction targets: verbose per-cycle frontmatter status paragraphs + the SOH-ATTACHMENTS-1 phase_3_status -> cycles/CYCLE-SUMMARY.md (full verbatim text, one-line + pointer left in frontmatter); SIZE BUDGET banner narrative collapsed to a short comment in place; 2 oldest Phase Progress rows (F5-CONVERGED-2026-09-09, F6-HARDENED-2026-09-09) -> cycles/HISTORY-PHASE-PROGRESS.md; the full cycle-005 Burst-13 Current-Phase-Steps 15-row checklist + the giant Decisions-Log cycle-005/cycle-006 narrative notes -> appended verbatim to cycles/cycle-005/burst-log.md and cycles/cycle-006/burst-log.md respectively; RESOLVED Blocking-Issues bullets + historical Constraints-Carried-Forward narrative -> cycles/RESOLVED-DRIFT-ITEMS.md; every still-OPEN low-priority standing-debt item (cycle-005/006 close deferrals, cycle-002/003/004 LOW items, process-gaps, Dependabot PRs, etc.) -> cycles/OPEN-STANDING-ITEMS.md, full text preserved, not deleted; cycle-002/003/004 Skip Log rows -> cycles/HISTORY-SKIP-LOG.md (cycle-005/006 rows kept inline); verbose Historical-Content-table per-burst inline descriptions -> cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md (condensed pointer-only table kept inline); the full live Session-Resume-Checkpoint prose -> appended to cycles/cycle-005/session-checkpoints.md (Appendix, not marked superseded since it is still the live checkpoint). STATE.md itself rewritten as ONE full-content Write (no sequential Edits, no Bash cp) with lean pointer-style sections; every pointer spot-checked to resolve to a real, actually-written file. version: 4.03->4.04 (exactly one bump, no double-bump). No count change (754 BCs/76 VPs/118 holdouts/175 stories) -- pure bookkeeping/reorganization, no spec/story authorship. Pipeline stays PAUSED throughout; no phase transition, no cycle change; trajectory-tail unchanged →1→3→0→2."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-08-25
  findings_count: 10
  fixes_applied: 6
  fixes_pending: 4
  pr: 737
current_cycle: "none"
feature_mode_bundle: "none"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: "SOH-ATTACHMENTS-1 CONVERGED + CLOSED 2026-07-25 (DEC-186, 5-dim PASS, MAXIMUM_VIABLE_REFINEMENT_REACHED); full text: cycles/CYCLE-SUMMARY.md#phase_3_status"
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 as v0.7.0-dev.3 (DEC-311). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_002_status"
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 as v0.7.0-dev.4 (PR #767). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_003_status"
cycle_004_status: "windows-correctness -- CLOSED + RELEASED 2026-09-06 as v0.7.0-dev.5 (DEC-343, PR #777). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_004_status"
cycle_005_status: "adf-mentions -- CLOSED, NO RELEASE, 2026-09-09 (DEC-353; closes GitHub #674; ships on develop @ cef4a021, tag deferred to a future release riding cycle-005+006). F1-F7 all APPROVED (DEC-344/345/346/347/352/353); full text: cycles/CYCLE-SUMMARY.md#cycle_005_status"
cycle_006_status: "mutants-ci-sharding -- CLOSED, NO RELEASE, 2026-09-09 (DEC-348/349/350/351; CI-infra-only, shipped binary byte-identical). F1-F7 all APPROVED; PR #791 merged to develop @ a9168212; full text: cycles/CYCLE-SUMMARY.md#cycle_006_status"
activation_head: "a9168212"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-10, STATE-MD-COMPACT-2026-09-10 checkpoint -- pipeline stays PAUSED,
     all six cycles (001-006) remain CLOSED, no OPEN cycle; line count refreshed after this burst's Write):
     This is a MAINTENANCE bookkeeping burst (state-manager, /compact-state skill, no phase transition,
     no cycle change). Extracted historical content (verbose per-cycle frontmatter status paragraphs,
     the old banner narrative, 2 oldest Phase Progress rows, the full cycle-005 Burst-13
     Current-Phase-Steps checklist, giant Decisions-Log narrative notes, resolved+open Drift/Standing-Items
     detail, historical Skip Log rows, verbose Historical-Content descriptions, and the full live
     Session-Resume-Checkpoint text) into `cycles/` files with a pointer left in each section below --
     nothing deleted, every pointer verified to resolve to a real written file.
     `timestamp:` refreshed to this burst's instant. `phase:`/`current_step:`/`last_amended:` rewritten
     via the verbatim-strict chain, preserving `D-chain cite D-053, D-2026 latest brownfield.` and
     trajectory-tail `→1→3→0→2`. `version:` 4.03 -> 4.04 (exactly one bump, no double-bump).
     `pipeline:` stays PAUSED throughout; no phase transition, no cycle change.
     Appended a Phase Progress row `STATE-MD-COMPACT-2026-09-10` (COMPLETE, no quality gate).
     Marked the `STATE-MD-OVER-SOFT-TARGET` Drift/Standing-Items follow-up RESOLVED 2026-09-10 (this
     burst); the other two open follow-ups (`VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP`,
     `MUTANTS-NIGHTLY-VERIFY-FULL-RUN`) left OPEN, unchanged, still visible.
     No count change (754 BCs / 76 VPs / 118 holdouts / 175 stories) -- a pure bookkeeping/reorganization
     event, no spec/story authorship.
     soft target 200 lines; hard cap 500 lines. 196 lines (wc-l) (this file, this Write) -- down from
     447 lines before this compaction (a ~56% cut).
     margin from soft-target = 200 - 196 = 4 (UNDER the soft target -- compaction target achieved;
     `STATE-MD-OVER-SOFT-TARGET` RESOLVED this burst).
     margin from actual = 500 - 196 = 304 (headroom remains before the hard cap).
     RECOVERY CONTEXT: no crash this burst -- a planned maintenance compaction, verified via a fresh
     read of this file before writing (still v4.03, prior state intact) -- this Write/commit is the
     first and only landing of this event.
     Factory lock: no `factory_lock` frontmatter block is present in this STATE.md and the
     lock-write/verify-sha-currency scripts are not provisioned in this repo -- the renew/unlock
     step this burst is therefore a no-op, noted rather than fabricated. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **PAUSED** (SESSION-WRAP PAUSE, 2026-09-10) -- all six tracked cycles (001-006) CLOSED, no OPEN cycle; resume by opening a new feature cycle or making a release decision (see Session Resume Checkpoint) |
| **trajectory-tail** | →1→3→0→2 (unchanged) |
| **Last Updated** | 2026-09-10, STATE-MD-COMPACT-2026-09-10 (`/compact-state`). trajectory-tail →1→3→0→2 (unchanged). Full prior per-cycle history: `cycles/CYCLE-SUMMARY.md` |
| **Current Phase** | No OPEN cycle; pipeline PAUSED. cycle-001 through cycle-006 all CLOSED, historical -- see `cycles/CYCLE-SUMMARY.md` |
| **Activation HEAD** | `a9168212` (unchanged -- no release tag cut; `develop`'s real tip is `78aeb86c`) |

## Phase Progress (recent 6; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **F7-CONVERGED-CYCLE5-CLOSED-2026-09-09 (cycle-005, Burst 13)** | **COMPLETE / CLOSED, NO RELEASE** | 2026-09-09 | Delta convergence, human gate -- 5-dimensional PASS; human APPROVED CLOSE with NO release cut (DEC-353) | 5-dim PASS on the combined Wave 1+Wave 2 `adf-mentions` delta; merged to `develop @ cef4a021` (PR #778/#794/#795); F6 HARDENED 20/21 VPs; human approved closing cycle-005 with NO release -- feature ships on `develop`, tag deferred. **cycle-005 CLOSED; ALL SIX tracked cycles (001-006) now CLOSED.** Full text: `cycles/HISTORY-PHASE-PROGRESS.md`. | counts unchanged (754/76/118/175); DEC-353 minted |
| **SESSION-WRAP-PAUSE-2026-09-10** | **COMPLETE** | 2026-09-10 | Session-lifecycle pause checkpoint, state-manager-executed, no quality gate | Paused the pipeline (`pipeline:` ACTIVE->PAUSED) in a single atomic burst, a retry of a stalled prior wrap attempt. Recorded a small E2E-CI test-infra follow-up as COMMITTED-BUT-UNVERIFIED (subsequently RESOLVED, see below). | counts unchanged; no DEC minted |
| **MAINTENANCE-CLAUDE-MD-COMPACTION-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Root `CLAUDE.md` compacted, MERGED to `develop` @ `a1f37995` via PR #797. Size 163,850->89,634 bytes (-45%); 458->397 lines. Detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md`. | counts unchanged; no DEC minted |
| **E2E-CI-DYNAMIC-TESTS-DELIVERED-2026-09-10** | **COMPLETE** | 2026-09-10 | Bookkeeping only, no quality gate | Resolved `E2E-CI-DYNAMIC-TESTS-WIP-UNVERIFIED`: branch `test/e2e-dynamic-parent-editfield` @ `6bfc2a0a` rebased, verified green, MERGED to `develop` @ `3a874d90` via PR #798. New follow-up: `E2E-DISCOVER-SAFE-EDIT-FIELD-VALIDATED-SUBTYPE` (see `cycles/OPEN-STANDING-ITEMS.md`). | counts unchanged; no DEC minted |
| **MUTANTS-NIGHTLY-REBALANCE-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Nightly mutation run `34478602590` ended `cancelled` (4/16 shards, PARTIAL data). Fix via PR #799 (merged @ `78aeb86c`): rebalanced N=16->24 shards + timeout 240->300 + completion-sentinel guard. New follow-up: `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` (see Drift/Standing Items below). | counts unchanged; no DEC minted |
| **STATE-MD-COMPACT-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping (`/compact-state` skill), state-manager-executed, no quality gate | Extracted historical content (frontmatter cycle-status prose, SIZE BUDGET banner, 2 oldest Phase Progress rows, full Current-Phase-Steps checklist, Decisions-Log narrative notes, resolved+open Drift/Standing-Items detail, cycle-002/003/004 Skip Log rows, verbose Historical-Content descriptions, full live Session-Resume-Checkpoint text) into `cycles/` files -- nothing deleted, every pointer resolves. STATE.md 447->196 lines, single full-content Write. `STATE-MD-OVER-SOFT-TARGET` marked RESOLVED. | counts unchanged (754/76/118/175); no DEC minted -- maintenance event |

## Current Phase Steps

No phase is currently mid-execution (pipeline PAUSED, no OPEN cycle). The last completed pipeline-phase checklist was cycle-005 Burst 13 (F7 delta convergence, cycle CLOSE) -- its full 15-step checklist is preserved at `cycles/cycle-005/burst-log.md` (Appendix). This burst's own steps (the `/compact-state` compaction) are summarized in the Phase Progress row above and the `last_amended`/`current_step` frontmatter fields.

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-353 | cycle-005 (`adf-mentions`, GitHub #674) Phase F7 (delta convergence) **HUMAN GATE APPROVED / cycle CLOSED**, 2026-09-09, **NO RELEASE**. 5-dimensional delta convergence PASS: (1) Spec -- F2 approved (DEC-346); (2) Story/Test -- F3 approved (DEC-347), all 15+17 ACs realized; (3) Implementation -- merged to `develop @ cef4a021` (Wave 1 PR #778 @ `708c8b32`, Wave 2 PR #794 @ `0eaf4268`, F5 fix FIX-F5-001 PR #795 @ `cef4a021`); (4) Verification -- F6 HARDENED, 20/21 VPs covered, sharded mutation gate ran clean in-line on both product PRs; (5) Regression -- full CI green on `develop @ cef4a021`. **NO RELEASE CUT** -- feature ships on `develop`, unreleased; tag deferred to a future release riding cycle-005 + cycle-006 | Human reviewed the complete 5-dimensional delta-convergence evidence package and explicitly approved closing the cycle without cutting a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| DEC-352 | cycle-005 (`adf-mentions`) Wave-1 story `S-cycle5-mention-pure-conversion` (PR #778) **MERGED to `develop` via the >120-mutation escape-hatch ADMIN-BYPASS**, human-authorized, 2026-09-09. Squash-merge commit `708c8b32`. PR #778's `src/adf.rs` diff generated **281 in-diff mutants** (> the 120-mutant escalation threshold), so the cycle-006 sharded mutation gate correctly **ESCALATED** -- the FIRST real production exercise of the escape hatch. Local `cargo mutants --in-diff` safety-net run showed 66 caught / **0 missed** / 21 timeout (environmental) / 9 unviable | Human judged the risk of merging a >120-mutant diff acceptable via admin-bypass rather than splitting or deferring | F4 (delivery) | 2026-09-09 | human (explicit admin-bypass authorization) |
| DEC-351 | cycle-006 (`mutants-ci-sharding`) Phase F7 **HUMAN GATE APPROVED / cycle CLOSED**, 2026-09-09, **NO RELEASE** -- CI-infrastructure-only; next release rides cycle-005 | Human reviewed the complete 5-dimensional delta-convergence evidence package and approved closing without a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| DEC-350 | cycle-006 Phase F3 **HUMAN GATE APPROVED** 2026-09-08. Story `S-cycle6-mutants-ci-sharding` reached 3-consecutive-clean adversarial convergence (32/33/34). Phase advances F3->F4 | Human approved proceeding to delta implementation with the story as-is | F3 (gate) | 2026-09-08 | human (explicit approval) |
| DEC-349 | Human **APPROVED** cycle-006 Phase F2 at the gate -- 16-pass adversarial convergence. Phase advances F2->F3 | Human approved proceeding to incremental story decomposition with the design unchanged | F2 (gate) | 2026-09-07 | human (explicit approval) |
| DEC-348 | Human **APPROVED** cycle-006 Phase F1 delta analysis in full -- scope, sequencing, escape-hatch inclusion, params (8 shards, ~120-mutant threshold). **HIGH regression risk** flagged on the CI-gate machinery -- RESOLVED and live in production per DEC-351's F7 close | Human approved proceeding to spec evolution with the captured decisions | F1 | 2026-09-07 | human (explicit approval) |
| DEC-347 | Human **APPROVED** cycle-005 Phase F3 story decomposition in full -- 2 stories, acyclic A->B dependency, 2 sequential waves, critical path 26 pts. Story count 172->174. Phase advances F3->F4. Accepted interim-shippability-window tradeoff RESOLVED/CLOSED as of Burst 10's Wave-2 merge | Human approved proceeding to delta implementation with the captured 2-wave split | F3 | 2026-09-06 | human (explicit approval) |
| DEC-345 / DEC-346 (condensed) | F2-gate **TIGHTENING** (`@Name` single-result `filter_by_name_match` hard-error) plus full F2 **APPROVAL** (12 new BCs, ADR-0023, 21 VPs, 12 holdouts, spec 2.1.0->2.2.0). Phase advanced F2->F3. Full text: `cycles/cycle-005/burst-log.md` Burst 2 | (condensed per the one-burst-lag compaction rule) | F2 (gate) | 2026-09-06 | human (explicit approval, both decisions) |
| DEC-344 | Human APPROVED cycle-005 Phase F1 delta analysis: two mention forms, hard-error `@Name` no-match with `\@` escape + `--no-mentions` opt-out, ambiguous-match handling, wiring incl. JSM, reverse-path update, live-Jira E2E requirement. Phase advanced F1->F2. Full text: `cycles/cycle-005/burst-log.md` Burst 1 | Human approved proceeding to spec evolution | F1 | 2026-09-06 | human (explicit approval) |
| DEC-343 | Human authorized and executed the cycle-004 dev release **v0.7.0-dev.5** (PR #777 squash-merged to `develop` @ `569d85a8`, tag `v0.7.0-dev.5` pushed, `release.yml` run `34046676423` SUCCESS). cycle-004 is now **CLOSED** | F7 reached human-authorized CONVERGENCE at DEC-342; the human then explicitly triggered the release action | RELEASE | 2026-09-06 | human (explicit authorization) |
| (352 older cycle-004/003/002/001 decisions) | DEC-342 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-06 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22 and `cycles/cycle-003/burst-log.md` Bursts 13-22 |

**cycle-005 decisions detail (Bursts 1-13, DEC-344 through DEC-353, CLOSED 2026-09-09, NO RELEASE):** full per-burst narrative (Bursts 6-12 minted no new DEC) preserved verbatim at `cycles/cycle-005/burst-log.md` (Appendix).

**cycle-006 decisions detail (Bursts 1-13, DEC-348 through DEC-351, CLOSED, superseded by DEC-353 as the factory's current max ID):** full per-burst narrative preserved verbatim at `cycles/cycle-006/burst-log.md` (Appendix).

**cycle-004 decisions detail (historical, all bursts):** F1 APPROVED (DEC-335) through RELEASED+CLOSED (DEC-343); full burst-by-burst detail `cycles/cycle-004/burst-log.md` Bursts 1-22.

## Skip Log

<!-- Full cycle-002/003/004 rows archived to cycles/HISTORY-SKIP-LOG.md; only the 2 most recent cycles' rows are kept inline. -->

| Step | Skipped? | Justification |
|------|----------|----------------|
| DTU creation (cycle-005) | yes | `dtu_required: false` -- targets Jira's own REST API user-search/mention surface, not a cloned third-party service. |
| UX Spec (cycle-005) | yes | `jr` is CLI-only; F1/F2 both confirmed no new UI surface -- `adf-mentions` is a write-path conversion feature only. |
| Demo recording (cycle-005, Wave 2) | yes | Human decision: demos skipped for `S-cycle5-mention-resolution-wiring` (backend/no-UI CLI). |
| F6 Kani formal verification (cycle-005) | yes | Not set up in repo; proptest substitution justified -- VP-674-008/018 + VP-674-006's depth-guard proptest cover the universal properties Kani would prove. 0-GAP. |
| F6 cargo-fuzz (cycle-005) | yes | Not set up in repo; proptest arbitrary-input substitution justified (VP-674-018, VP-674-008). 0-GAP. |
| F6 DTU adversarial testing / accessibility re-check (cycle-005) | yes | `dtu_required: false`; write-path ADF conversion feature, no UI surface, no cloned third-party service. |
| DTU creation (cycle-006) | yes | `dtu_required: no` -- `mutants-ci-sharding` is CI-tooling only. |
| UX Spec (cycle-006) | yes | `jr` is CLI-only; CI-workflow/policy-doc change with no product UI surface. |
| F5/F6 dedicated artifact subdirectory (cycle-006) | not skipped, folded | Feature-mode F5/F6 have no separate human gate; evidence folded directly into F7's 5-dimensional convergence record (DEC-351). |

**NOT a skip (tracked standing follow-up, human-owned post-close):** Live-Jira E2E round-trip acceptance (`H-NEW-MENTION-009`, AC-017) is **DEFERRED by human decision**, not skipped -- see `cycles/OPEN-STANDING-ITEMS.md`.

Older rows (cycle-001 through cycle-004, all CLOSED + RELEASED, historical): `cycles/HISTORY-SKIP-LOG.md`.

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

**NONE OPEN.** Zero Blocking Issues remain open anywhere in the factory. All six tracked cycles are CLOSED. Resolved items (`F-PE-MED-001`, `R-F2`, `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`, `E2E-CI-DYNAMIC-TESTS-WIP-UNVERIFIED`, `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1`, `STATE-MD-OVER-SOFT-TARGET`): `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking standing debt (not gate-blocking): `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

All six tracked cycles (001-006) are CLOSED. cycle-002 RELEASED as `v0.7.0-dev.3`; cycle-003 RELEASED as `v0.7.0-dev.4`; cycle-004 RELEASED as `v0.7.0-dev.5`; cycle-005 (`adf-mentions`, GitHub #674) and cycle-006 (`mutants-ci-sharding`) both CLOSED with NO release cut (ship on `develop @ cef4a021` / `a9168212`, tag deferred to a future release riding both). **No OPEN cycle remains.** Full per-cycle convergence detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Six tracked cycles, all CLOSED. `develop`'s real tip is `78aeb86c` (PR #799 merged); `activation_head` frontmatter stays `a9168212` -- no release tag cut. Pipeline PAUSED. Live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) remains DEFERRED, a human-owned post-close standing follow-up. Full per-cycle detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative (cycle-005/006 CLOSE + earlier F1-F7 detail, the SESSION-WRAP PAUSE account, the MUTANTS-NIGHTLY-REBALANCE narrative, cycle-004 maintenance items, PROCESS-GAP items, and Standing items) is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim, nothing deleted: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing in this section is currently blocking.

## Session Resume Checkpoint

**Date:** 2026-09-10. **Pipeline: PAUSED** (SESSION-WRAP PAUSE, unchanged since 2026-09-10, a retry of a stalled prior wrap attempt). **Position:** all six tracked cycles CLOSED, no OPEN cycle. This session delivered the `adf-mentions` feature (cycle-005, GitHub #674) through Phase F7 close (DEC-353, NO release), then completed four maintenance follow-ups in sequence: CLAUDE.md compaction (PR #797 @ `a1f37995`), E2E-CI dynamic-tests WIP resolution (PR #798 @ `3a874d90`), mutants-nightly rebalance (PR #799 @ `78aeb86c`), and this STATE.md `/compact-state` compaction (447->196 lines). **NEXT action** = a new feature request, or a release decision (would ride cycle-005 + cycle-006). **No WIP branches outstanding.** **Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step` (no OPEN wave/cycle -- pipeline idle/PAUSED). **Counts:** total_bcs 754; VP count 76; holdout scenarios 118; total_stories 175 (all unchanged this burst). Full original (pre-condensation) checkpoint text: `cycles/cycle-005/session-checkpoints.md` (Appendix).

## Historical Content

Burst logs, adversary pass details, session checkpoints, resolved/open standing debt, and full per-burst narrative for every cycle have been extracted to cycle files. This table lists file locations only; full per-burst inline descriptions previously carried inline here: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md`.

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-20) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Bursts 1-22) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Bursts 1-22) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Bursts 1-13 + Appendix) |
| cycle-006 burst history | `cycles/cycle-006/burst-log.md` (Bursts 1-13 + Appendix) |
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | see `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` for the full per-cycle path list |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap: vsdd-factory has no `compact-claude-md` capability mirroring `compact-state`; candidate follow-up in the vsdd-factory repo, NOT jira-cli.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. The mutants-nightly rebalance fix (N=16->24 shards, `timeout-minutes` 240->300, completion-sentinel guard; PR #799 @ `78aeb86c`) is statically validated only (actionlint/shellcheck/YAML-parse + local code-reviewer). A manual `workflow_dispatch` run, or the next scheduled 08:00 UTC nightly, must confirm all 24 shards complete within the 300-min cap and produce a real full-scope kill rate -- the true kill-rate-vs-90% posture is unknown until then.
- `STATE-MD-OVER-SOFT-TARGET` -- **RESOLVED 2026-09-10** (this burst, `/compact-state`). STATE.md reduced from 447 lines to 196 lines (a ~56% cut) via extraction of historical content into `cycles/` files (see this file's SIZE BUDGET banner and Historical Content section) -- now back UNDER the 200-line soft target with a 4-line margin.

All other standing debt -- full text preserved, nothing deleted: OPEN items (cycle-005/006 close deferrals, cycle-002/003/004 LOW items, process-gaps, `PR-REVIEW-SELF-APPROVE-HOOK-LOOP`, Dependabot PRs, `VP-COUNT-RECONCILIATION`, the S-PG-* backlog, etc.) at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items and historical narrative at `cycles/RESOLVED-DRIFT-ITEMS.md`.
