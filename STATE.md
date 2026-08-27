---
document_type: pipeline-state
level: ops
version: "3.22"
status: active
producer: state-manager
timestamp: 2026-08-27T13:39:03Z
phase: F4
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). F4 (delta implementation): WAVE 1 COMPLETE (unchanged). WAVE 2 COMPLETE: S-578-2 (PR #741 @ `a3739763`) + S-578-3 (JSM `issue create --field` dispatch, PR #742 @ `41763ff0`) both DELIVERED + MERGED. S-578-3 closed after 4-pass adversary convergence (Pass 1 BLOCKING HIGH `:asset` L2-validation-gap + 2 MEDIUM → fixed, Passes 2/3 NITPICK_ONLY, Pass 4 CLEAN — 3/3 clean) and pr-reviewer APPROVE (2 BLOCKING fixed via commit `29300a3b`: B1 test-count body correction, B2 byte-identity full-map pin). Wave 3 (S-578-4, depends_on:[S-580-1, S-578-2], both individually satisfied) is now unblocked and ready for dispatch — its gate was Wave 2 completing as a whole. Full detail: cycles/cycle-002/burst-log.md Burst 13 + Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE at F4 (delta implementation), pipeline resumed and progressing. Wave 1 COMPLETE: S-578-1 (PR #739 @ 993de833) + S-580-1 (PR #740 @ 74221bbc) both delivered/merged. Wave 2 COMPLETE: S-578-2 (PR #741 @ a3739763) + S-578-3 (PR #742 @ 41763ff0) both delivered/merged 2026-08-27. Wave 3 (S-578-4) now unblocked, ready for dispatch. Resume via /vsdd-factory:next-step."
activation_head: "41763ff0"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-27, F4-WAVE-2-S-578-3 burst -- WAVE 2 COMPLETE):
     193 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 193 = 7 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 193 = 307 lines of headroom remain before the hard cap of 500.
     This burst records S-578-3 (JSM `issue create --field` hint-kind dispatch, 8 pts), the second
     and final Wave 2 story, completing the per-story-delivery pipeline (Red Gate PASS, 4-pass
     adversary convergence [Pass 1 BLOCKING HIGH+2MED -> fixed, Passes 2/3 NITPICK_ONLY, Pass 4
     CLEAN], pr-reviewer APPROVE after 2-BLOCKING fix commit), and merging via PR #742 @ 41763ff0.
     STATE.md changes: version/timestamp bump, activation_head a3739763->41763ff0, current_step and
     cycle_002_status updated, a new Phase Progress row (F4-WAVE-2-COMPLETE), Current Phase Steps
     replaced with the 5 most recent S-578-3 delivery steps (older rows archived -- already fully
     narrated in burst-log.md Burst 12/13), Session Resume Checkpoint replaced with the Wave-3-next
     position (prior checkpoint archived to cycles/cycle-002/session-checkpoints.md), 3 new Drift
     items (S-578-3-SHARED-ASSET-VALIDATOR, S-578-3-FIELDVALUESPEC-RELOCATION,
     S-578-3-PR742-RESIDUAL-NITS). No BC/VP/holdout counts changed (719/32/106) -- PO confirmed no
     BC/EC/VP count change; check-spec-counts.sh and check-bc-cumulative-counts.sh both exit 0. One
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
| **Last Updated** | F4-WAVE-2-S-578-3 (2026-08-27): trajectory-tail →1→3→0→2 (unchanged this burst). S-578-3 delivered and merged (PR #742 @ 41763ff0). **Wave 2 CLOSED.** Pipeline stays **ACTIVE**. v3.21->v3.22. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- **Phase F4** (delta implementation), pipeline **ACTIVE**. Wave 1 COMPLETE. Wave 2 COMPLETE (S-578-2 PR #741 + S-578-3 PR #742 both merged). Wave 3 (S-578-4) unblocked, next. cycle-001 remains CLOSED, historical. |
| **Activation HEAD** | 41763ff0 (`develop` tip after PR #742 merge; `v0.7.0-dev.2`) -- advanced this burst from `a3739763` |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F4-WAVE-1-COMPLETE | **COMPLETE** | 2026-08-26 | per-story-delivery pipeline (5-round adversarial convergence) + pr-reviewer (PR #740) | S-580-1 (`jr field options <field>`, BC-X.14.001-004). PR #740 squash-merged @ `74221bbc`. Wave 1 fully closed. 6 NON-BLOCKING pr-reviewer follow-ups tracked. Full detail: `cycles/cycle-002/burst-log.md` Burst 11. | 29→24→21→7→4→3→0 |
| F4-WAVE-2-S-578-2 | **DELIVERED + MERGED** | 2026-08-27 | per-story-delivery pipeline (Red Gate + 4/4 adversary CLEAN) + security-reviewer + pr-reviewer | S-578-2 (`issue edit --field` hint-kind dispatch, BC-3.4.015/016/021/027/028/029/030/031). PR #741 @ `a3739763`; 4 adversary passes (P1 BLOCKING 2-MED+5-LOW → fixed, P2/P3/P4 NITPICK_ONLY = 3/3 clean); 4 pr-reviewer non-blocking findings fixed in-PR; 7 residual tracked. Full detail: Burst 12; `cycles/cycle-002/S-578-2/`. | 2MED+5LOW→0 (P1) then 3× clean |
| F4-WAVE-2-COMPLETE | **COMPLETE** | 2026-08-27 | per-story-delivery (Red Gate + 3/3 adversary CLEAN + security APPROVE + pr-reviewer) | S-578-3 (PR #742 @ 41763ff0): kind-aware JSM requestFieldValues + :asset L2 validation + interim-guard/helper removal; 4 adversary passes (P1 BLOCKING HIGH :asset-validation-gap → fixed, P2/P3 NITPICK → fixed, P4 CLEAN); pr-reviewer B1 (test-count body correction) + B2 (byte-identity full-map pin) resolved. Wave 2 (S-578-2 #741 + S-578-3 #742) now CLOSED. | P1 1HIGH+2MED→0 then 3× clean |

## Current Phase Steps (cycle-002, phase F4; last 5)

| Step | Status | Notes |
|------|--------|-------|
| Wave 2 S-578-3 dispatch (stub step) | **STUBBED** | `FieldValueSpec`-typed `extra_fields` + `:id`/`:name`/`:asset` composer stubs + `:asset` L2 resolver stub, interim guard intact; `cargo check` clean. |
| Red Gate verified | **PASS** | 11/11 new tests RED on real assertion mismatches (0 build errors, 0 panics); 102-test pre-existing baseline green. |
| Adversary Pass 1 BLOCKING fixed (:asset L2 validation gap) | **FIXED, 4/4 CONVERGED** | 1 HIGH + 2 MEDIUM (ADV-S578-3-P1-001..003): ported `field_resolve.rs::compose_asset_hint`'s 4-check value-shape validation into `jsm_create.rs::resolve_asset_field_l2`; corrected BC-3.8.008 EC-3.8.008-1/EC-3.8.008-3 to STRING_WRAP (PO adjudicated). Passes 2/3 NITPICK_ONLY, Pass 4 CLEAN, 3/3 clean. |
| PR #742 opened, reviewed, converged | **APPROVE** | pr-reviewer initial REQUEST_CHANGES (2 BLOCKING: B1 test-count overstatement, B2 partial byte-identity assertion) → both fixed via commit `29300a3b` → APPROVE at final confirmation review. |
| S-578-3 PR #742 merged | **MERGED @ 41763ff0** | Squash-merged to `develop` (human manual merge). `activation_head` advanced `a3739763` -> `41763ff0`. STORY-INDEX.md + sprint-state.yaml S-578-3 row set to `status: completed`. **WAVE 2 COMPLETE.** |

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

`cycle-002` (`field-dx`) F2 CONVERGED (streak-6) and human-approved. F3 COMPLETE. F4 Wave 1 COMPLETE. **F4 Wave 2 is now COMPLETE this burst: S-578-3 delivered via 4-pass per-story adversary convergence (Pass 1 BLOCKING → Passes 2/3 NITPICK_ONLY → Pass 4 CLEAN, 3/3 clean), pr-reviewer APPROVE (2 blocking fixed in-PR), merged PR #742 @ `41763ff0`.** Wave 3 (S-578-4) now unblocked, ready for dispatch. No BC/VP/holdout counts changed (719/32/106).

## Concurrent Cycles

Two tracked cycles. `cycle-001` is CLOSED, historical. `cycle-002` (`field-dx`) is ACTIVE, **F4 Wave 1 + Wave 2 COMPLETE** (S-578-2 + S-578-3 both merged), Wave 3 (S-578-4) next. No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>`) + #578 (`--field` value-kind hint syntax + non-JSM `issue create --field`). 5-story decomposition, full F1-F7 lifecycle, DTU not required.

**Position:** Phase **F4** (delta implementation), pipeline **ACTIVE**. Wave 1 of 3: **COMPLETE** (S-578-1 PR #739 @ `993de833`, S-580-1 PR #740 @ `74221bbc`). Wave 2 of 3: **COMPLETE** -- S-578-2 (PR #741 @ `a3739763`) + S-578-3 (JSM `issue create --field` hint dispatch, PR #742 @ `41763ff0`, 2026-08-27) both DELIVERED + MERGED. **Wave 3 is NEXT — S-578-4 (platform `issue create --field` support + DEC-188 reversal via DEC-310, 13 pts, depends_on [S-580-1, S-578-2] both satisfied). On resume: dispatch S-578-4 via per-story-delivery. S-578-4 reuses S-580-1's `get_createmeta_fields` verbatim and reverses the DEC-188 platform-path `--field`-alone exit-64 guard per DEC-310.**

**F1/F2/F3:** COMPLETE + human-approved (unchanged). Counts: 719 total BCs (BC-INDEX v6.82), 32 VPs, 106 holdout scenarios -- unchanged.

**S-578-3 delivery summary:** Red Gate PASS (stub `cargo check` clean, guard intact; 11/11 new tests RED on real assertions, 102-test regression baseline green; fix-burst Red Gate: 4 `:asset` negative-path tests RED→GREEN) then GREEN (107/107 tests in-binary -- 81 in-file `tests/issue_create_jsm.rs` + 26 unrelated `common::wf::tests` via `mod common;`; report the 61→81 in-file delta, not the binary total -- + regression + clippy + fmt clean). 4-pass adversary convergence: Pass 1 BLOCKING (1 HIGH + 2 MEDIUM, ADV-S578-3-P1-001..003 -- the `:asset` L2 value-shape validation gap vs. the platform sibling, plus a BC-3.8.008 EC-3.8.008-1/EC-3.8.008-3 wire-shape wording conflict adjudicated STRING_WRAP by PO), Passes 2/3 NITPICK_ONLY, Pass 4 CLEAN (3/3 clean). pr-reviewer: initial REQUEST_CHANGES (2 BLOCKING -- B1 test-count body overstatement, B2 partial byte-identity assertion), both fixed via commit `29300a3b`, **APPROVE at final confirmation review** (4 non-blocking + 4 nitpick residual, tracked as `S-578-3-PR742-RESIDUAL-NITS`). No BC/VP/holdout count change. Full detail: `cycles/cycle-002/burst-log.md` Burst 13; `cycles/cycle-002/S-578-3/implementation/red-gate-log.md` + `adversary-convergence-state.json`.

**Tracked debt (unchanged + confirmed owed):**
1. DEC-namespace disambiguation question (open, tracked debt).
2. Reversal-propagation checklist for PO/state-manager workflow (not built).
3. `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` lesson (round-6, not yet actioned).
4. 4 residual LOW doc-hygiene items from streak-6 + 6 PR #740 + 11 PR #741 pr-reviewer follow-ups (see Drift/Standing Items) -- non-blocking, owed before/at cycle close.
5. `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE` -- now upgradeable to enforced symbol-form. Not yet actioned.
6. `SEC-001-EDITMETA-RECURSION-GUARD` (LOW, pre-existing since S-580-1) -- see Drift/Standing Items.
7. `S-578-3-SHARED-ASSET-VALIDATOR`, `S-578-3-FIELDVALUESPEC-RELOCATION`, `S-578-3-PR742-RESIDUAL-NITS` (LOW, new this burst) -- see Drift/Standing Items.
8. Standing, pre-existing, NOT field-dx-scoped: `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` -- ~145 historical stale input-hash artifacts, factory-wide.

**Pending human decisions / blockers:** NONE. Full-autonomous-run mandate stands.

**In flight / uncommitted at this checkpoint:** none -- S-578-3's feature branch/worktree lifecycle is complete (PR merged, branch deleted). `STATE.md`, `sprint-state.yaml`, `stories/STORY-INDEX.md`, `specs/prd/bc-3-issue-write.md`, `stories/S-578-3-jsm-create-field-hint-dispatch.md`, `regression-state.json`, `sidecar-learning.md`, and the new `cycles/cycle-002/S-578-3/` artifacts are committed to `factory-artifacts` together as part of this burst's commit, alongside the prior pending demo commit `4a9910d3`.

**Resume command:** `/vsdd-factory:deliver-story S-578-4` (or `/vsdd-factory:next-step`) -- dispatches S-578-4, Wave 3 of 3, now unblocked.

**Superseded checkpoint:** the F4-WAVE-2-S-578-2 checkpoint (v3.21, 2026-08-27) is archived to `cycles/cycle-002/session-checkpoints.md`, alongside all prior cycle-002 checkpoints. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-6 = F2 adversary rounds; Burst 7 = streak-6 close; Burst 8 = F2 gate APPROVED + F2->F3; Burst 9 = F3 decomposition; Burst 10 = S-578-1 merged; Burst 11 = S-580-1 merged, WAVE 1 COMPLETE; Burst 12 = S-578-2 merged, WAVE 2 HALF DONE; Burst 13 = S-578-3 merged, WAVE 2 COMPLETE) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (all prior F2/F3/F4 checkpoints incl. F4-WAVE-2-S-578-2 archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-002 lessons learned | `cycles/cycle-002/lessons.md` (round-6's [process-gap] lesson; S-578-2's 2 [infra-observation] lessons; S-578-3's 2 [content] + 1 [infra-observation] lessons) |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| S-578-2 delivery artifacts | `cycles/cycle-002/S-578-2/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-2/pr-review.md` |
| S-578-3 delivery artifacts | `cycles/cycle-002/S-578-3/` (red-gate-log.md, adversary-convergence-state.json); `code-delivery/S-578-3/pr-review.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**New (2026-08-27, S-578-3 / PR #742):**
- `S-578-3-SHARED-ASSET-VALIDATOR` (LOW) -- extract a shared `validate_asset_value` helper used by BOTH `field_resolve.rs::compose_asset_hint` (platform) and `jsm_create.rs::resolve_asset_field_l2` (JSM) -- ~40 lines currently duplicated verbatim; also hoist the JSM `:asset` validation to before the `--description-stdin` read / request-type GET to match DEC-188's platform pre-flight ordering (pr-reviewer items 6+7).
- `S-578-3-FIELDVALUESPEC-RELOCATION` (LOW, architectural) -- move `FieldValueSpec`/`FieldValueKind` from `cli/issue/create.rs` to a neutral `src/types/` module to remove the only `api/`→`cli/` (L4→L2) import inversion and let `mod create` return to private (ADV-S578-3-P4-001 / pr-reviewer N1).
- `S-578-3-PR742-RESIDUAL-NITS` (LOW) -- residual pr-reviewer non-blocking nits on #742 (proptests pass empty `extra_fields` so the new dispatch loop lacks property coverage; `:asset` assertion messages omit the parity caveat; minor `format!`/value phrasing) -- details in `.factory/code-delivery/S-578-3/pr-review.md`.

**Still open (2026-08-27, S-578-2 / PR #741):**
- `SEC-001-EDITMETA-RECURSION-GUARD` (LOW, security-hardening follow-up) -- apply a MAX_ADF_DEPTH-style recursion-depth cap to `AllowedValue.children` serde deserialization in `src/types/jira/editmeta.rs` (mirrors `adf.rs` SEC-001 / PR #553 / BC-7.2.012). Tracked debt: draft a follow-up story or a justified deferral with a target.
- `S-578-2-PR741-RESIDUAL-NITS` (LOW) -- 7 residual pr-reviewer NON-BLOCKING findings on PR #741 (details in `code-delivery/S-578-2/pr-review.md`). Tracked, non-blocking.

**Still open (2026-08-26, PR #740 pr-reviewer NON-BLOCKING follow-ups):**
- `S-580-1-PR740-S1`/`S2`/`S3`, `S-580-1-PR740-N1`/`N2` (all LOW) -- pagination-truncation risk, untested fallback, test-naming, citation, CLAUDE.md tree gap. Tracked debt.
- `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE` (LOW, spec-hygiene) -- eligible for upgrade to enforced symbol-form. Tracked, not blocking.

**Still open (unchanged from streak-6, LOW doc-hygiene, non-blocking -- do NOT block F4):**
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION`, `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED`, `M1-EDITMETA-STATUS-PERMISSION-CAVEAT`, `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE` (all LOW) -- tracked for cycle close.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process) -- flat `DEC-NNN` prefix shared by spec-authored and cycle-gate DECs, no central registry. Revisit at a future cycle close.
- `BC-INDEX-GUARD-GAP`, `GUARD-SCOPE-COPY-PASTE-PATTERN`, `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` (all LOW/process, unchanged) -- logged in `cycles/cycle-002/lessons.md`.

**New (2026-08-25):** `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW, missing holdouts for 4 flags); `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW, pre-existing, unrelated to field-dx). Candidate: reactivate vsdd-factory plugin rc.20 to rc.23.

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` -- ~145 historical stale `input-hash` artifacts factory-wide; standing debt, **not** a field-dx / cycle-002 item.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
