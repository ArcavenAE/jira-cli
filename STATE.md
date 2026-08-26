---
document_type: pipeline-state
level: ops
version: "3.08"
status: active
producer: state-manager
timestamp: 2026-08-26T13:20:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). F2-ADVERSARY-CONVERGENCE-RESUME (2026-08-26): Feature Mode cycle-002 (field-dx bundle, GH #580 + #578) resumed from the prior /wrap. 3 fresh-context adversary passes ran against the frozen F2 delta (correctness / completeness / traceability lenses) -- ALL THREE returned NOT-CLEAN. 6 MEDIUM + ~9 LOW findings routed through architect->product-owner->verifier and fixed this burst (arity-model M2 parity, create-path Gate-B collision guard, cascading split hardening, DEC-307->DEC-310 renumber, several LOW polish items). VP count 25->29. Clean-pass streak RESET to 0/3 -- a fresh 3-consecutive-CLEAN run is required before F2 Step 5/8. Pipeline flipped PAUSED->ACTIVE (loop resumed, in progress, not paused again this burst). state-manager's post-burst defensive sweep (S-7.02) found the DEC-307->DEC-310 renumber is INCOMPLETE (35 residual DEC-307 references across 6 further files) -- routed forward as an owed follow-up, not fixed this burst. DEC-307->DEC-310-PROPAGATION-SWEEP (2026-08-26, this session): product-owner completed the owed sweep -- 35 residual DEC-307 references renumbered to DEC-310 across the 6 flagged spec files; genuine cycle-001 DEC-307 (`cycles/cycle-001/session-checkpoints.md`) and the intentional renumber-narration in STATE.md/`cycles/cycle-002/*` were correctly left untouched. Both guard scripts re-verified PASS post-sweep (719 BCs / 29 VPs / 106 holdouts all unchanged). Clean-pass streak remains 0/3 -- the sweep is bookkeeping, not an adversary pass. trajectory-tail →1→3→0→2 (unchanged). Full detail in Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE, F2 adversarial spec-convergence loop RESUMED this session (0/3 clean streak, in progress); DEC-307->DEC-310 propagation sweep CLOSED this session; see current_step + Session Resume Checkpoint"
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, DEC-307->DEC-310-PROPAGATION-SWEEP burst):
     176 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 176 = 24 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 176 = 324 lines of headroom remain before the hard cap of 500.
     This burst updated the Owed follow-up row (Current Phase Steps), the Session Resume
     Checkpoint process-gap item #3, and the Drift/Standing Items entry to reflect the
     propagation sweep's completion -- no new H2 sections added, one full-content Write,
     no Edit chain (DEC-247).
     Pre-compaction (pre-2026-08-25) full history remains at factory-artifacts commit
     43f4a5e3 and cycles/cycle-001/burst-log.md. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst -- spec-convergence loop only, no develop merges) |
| **Last Updated** | DEC-307->DEC-310-PROPAGATION-SWEEP (2026-08-26): owed propagation sweep CLOSED -- 35 residual DEC-307 refs corrected to DEC-310 across 6 spec files; cycle-001's genuine DEC-307 preserved. Guards re-verified PASS. Clean-streak unchanged at 0/3 (sweep is not an adversary pass). v3.07→v3.08. trajectory-tail →1→3→0→2 (unchanged). |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- Phase F2 (spec evolution), ACTIVE inside the mandatory adversarial spec-convergence loop (streak 0/3). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2 is spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| MAINTENANCE-SWEEP-2026-08-25 | COMPLETE | 2026-08-25 | quality sweep | 10 findings (dependency CLEAN; doc drift 6 fixed via PR #737 MERGED squash `e7e194ff`; pattern CLEAN; holdout gap flagged; tech debt none overdue). 4 findings pending (see Drift/Standing Items). | trajectory-tail →1→3→0→2 (unchanged) |
| WRAP-F2-CONVERGENCE-PAUSE | PAUSED (superseded) | 2026-08-26 | human /wrap | cycle-002 F1 COMPLETE+approved; F2 spec authoring COMPLETE. Loop stopped mid pass-30 (no verdict) after passes 26/27 CLEAN, 28/29 MEDIUM-fixed. Superseded by the F2-ADVERSARY-CONVERGENCE-RESUME row below -- full checkpoint archived to cycles/cycle-002/session-checkpoints.md. | trajectory-tail →1→3→0→2 (unchanged); ~30 passes run, clean-streak was 0/3 at wrap |
| F2-ADVERSARY-CONVERGENCE-RESUME | ACTIVE (loop in progress) | 2026-08-26 | fix-burst (architect->PO->verifier) | 3 fresh-context passes (correctness/completeness/traceability) ALL NOT-CLEAN. 6 MEDIUM+9 LOW fixed: M2 default-project parity (A-M1/D1), create-path Gate-B guard (B-F3/D2), cascading-split hardening (B-F2/D3), BC-X.14.002 example fix (A-M2), BC-X.14.001 M3 pagination correction (B-F1), DEC-307->DEC-310 renumber (C-M1, partial). 719 BCs unchanged; VP 25->29; 106 holdouts unchanged. Both guard scripts re-verified PASS post-burst. | trajectory-tail →1→3→0→2 (unchanged); streak reset to 0/3 this burst |
| DEC-307-TO-DEC-310-PROPAGATION-SWEEP | COMPLETE | 2026-08-26 | state-manager commit | product-owner closed the owed follow-up: 35 residual DEC-307 refs corrected to DEC-310 across `phase-f2-spec-evolution/architecture-delta-field-dx.md`, `phase-f2-spec-evolution/verification-delta-field-dx.md`, `specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md`, `specs/prd/BC-INDEX.md`, `specs/prd/CANONICAL-COUNTS.md`, `specs/prd/holdout-scenarios.md`. cycle-001's genuine DEC-307 and STATE.md/cycles/cycle-002 renumber-narration correctly left untouched. Both guard scripts re-verified PASS (719 BCs / 29 VPs / 106 holdouts unchanged). | trajectory-tail →1→3→0→2 (unchanged); streak still 0/3 -- sweep is bookkeeping, not an adversary pass |

## Current Phase Steps (cycle-002, phase F2; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F2 mandatory adversarial spec-convergence loop -- pass-30 (superseded) | SUPERSEDED | Was PAUSED mid pass-30 (no verdict) at prior `/wrap`. Superseded by this session's resume; see next row. Full detail archived in `cycles/cycle-002/session-checkpoints.md`. |
| F2 mandatory adversarial spec-convergence loop -- resume fix-burst | ACTIVE (0/3 clean) | This session ran 3 fresh-context adversary passes against the frozen delta; all three NOT-CLEAN. 6 MEDIUM+9 LOW findings fixed via architect->PO->verifier (see `cycles/cycle-002/burst-log.md` Burst 1). Clean-pass streak reset to 0/3 -- 3 CONSECUTIVE CLEAN passes are required before proceeding to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). |
| Owed follow-up: DEC-307->DEC-310 propagation sweep | CLOSED | product-owner completed the sweep this session: 35 residual `DEC-307` references (field-dx/BC-3.8.012-reversal context) corrected to `DEC-310` across the 6 files flagged by state-manager's defensive sweep. cycle-001's genuine DEC-307 and the intentional renumber-narration in STATE.md/`cycles/cycle-002/*` were left untouched. Both guard scripts re-verified PASS post-sweep. Remaining owed items before F2 Step 5/cycle close: formal DEC-310 registration, DEC-namespace disambiguation (see Session Resume Checkpoint). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered this burst; propagation sweep completed 2026-08-26) | product-owner (proposed); orchestrator/state-manager to register formally at cycle close |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>` | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; `>` avoids collision with field names | F1/F2 | 2026-08-25 (Accepted); § Amendment 2026-08-26 this burst (D1/D2/D3) | architect |
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
| (none currently open) | -- the DEC-namespace disambiguation question and formal DEC-310 registration (see Session Resume Checkpoint "Process-gap follow-ups") are tracked debt, not hard blockers -- they must close before F2 Step 5/cycle close but do not block resuming the adversary loop | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): all five convergence dimensions plus Regression are PASS (MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized 2026-08-24) -- historical, unchanged this burst.

`cycle-002` (`field-dx`) is mid F2's mandatory adversarial spec-convergence loop, RESUMED this session. Substantive design was believed CONVERGED entering this session (arity model, DEC-307 reversal cluster, Gate B x hint interaction, `:asset` split, createmeta pagination), but three fresh-context adversary passes (correctness / completeness / traceability lenses) run against that "frozen" delta **all returned NOT-CLEAN** -- fresh eyes found 6 MEDIUM + ~9 LOW findings the prior ~30-pass run had missed or that regressed. All were fixed via the architect -> product-owner -> verifier chain: M2 (`--type`) default-project parity restored, create-path Gate-B collision guard added, cascading `>`-split hardened, a worked example and a pagination postcondition corrected, and DEC-307 renumbered to **DEC-310** (collision found via a full-`.factory/`-tree survey). Counts: 719 BCs unchanged; VP total **25 -> 29** (5 new ids: VP-578-020/021/022, VP-580-010/011); 106 holdouts unchanged. **This session's follow-on:** the DEC-307->DEC-310 renumber's owed propagation sweep (35 residual refs across 6 files, found by state-manager's S-7.02 defensive sweep) is now **CLOSED**. **Mandatory rule unchanged: 3 CONSECUTIVE clean adversary passes are still required before F2 Step 5/8 -- the streak remains 0/3** (the sweep does not count as a pass; only a fresh adversary run can advance the streak).

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at F2, adversarial spec-convergence loop in progress (streak 0/3). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase F2 (spec evolution), inside the MANDATORY adversarial spec-convergence loop. Pipeline ACTIVE -- loop resumed and in progress this session, not paused.

**F1:** COMPLETE + human-approved (unchanged this burst). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2 authoring:** COMPLETE (unchanged this burst) plus the prior fix-burst amendments and this session's propagation sweep. 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25, § Amendment 2026-08-26 D1/D2/D3), BC-3.8.012 reversed (governance flag now **DEC-310**, fully propagated as of this session). Counts unchanged: **719 total BCs** (BC-INDEX v6.82), **29 VPs**, **106 holdout scenarios**.

**This session's work (2026-08-26):** state-manager committed the product-owner's completed DEC-307->DEC-310 propagation sweep -- the owed follow-up from the prior fix-burst. 35 residual `DEC-307` references were renumbered to `DEC-310` across the 6 files flagged by the S-7.02 defensive sweep: `phase-f2-spec-evolution/verification-delta-field-dx.md` (7), `phase-f2-spec-evolution/architecture-delta-field-dx.md` (1), `specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md` (1, §References), `specs/prd/holdout-scenarios.md` (15), `specs/prd/CANONICAL-COUNTS.md` (4, `last_verified` changelog prose), `specs/prd/BC-INDEX.md` (7, `last_updated` changelog prose). The genuine cycle-001 DEC-307 (`cycles/cycle-001/session-checkpoints.md`) and the intentional renumber-narration in STATE.md / `cycles/cycle-002/*` were correctly left untouched -- not swept. No count changes: 719 BCs / 29 VPs / 106 holdouts all unchanged. A pre-existing unrelated `sidecar-learning.md` line from an earlier burst was included in the same commit.

**Guard scripts re-verified post-sweep by state-manager:** `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)").

**Convergence counter -- CRITICAL for resume:** clean-pass streak is **still 0/3** (unchanged by this session -- the propagation sweep is bookkeeping, not an adversary pass). **ON RESUME:** run fresh adversary passes on the fully-propagated delta until 3 in a row are CLEAN, then proceed to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). The propagation gap that was previously flagged as a pre-Step-5 risk is now closed.

**Decisions of record:** DEC-310 (reverses DEC-188; proposed, propagation now complete) -- still needs formal registration at cycle close. ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26).

**Process-gap follow-ups owed at cycle close:**
1. **Register DEC-310** formally (supersedes the "Register DEC-307" item -- DEC-307 turned out to already be allocated to a cycle-001 decision). Propagation of the renumber itself is now CLOSED (this session); only the formal registration step remains.
2. **DEC-namespace disambiguation question (still open):** spec-authored DECs (e.g. DEC-188, DEC-310) and cycle-gate DECs (e.g. DEC-309, cycle-001's F7 closure) currently share one flat `DEC-NNN` prefix with no central registry -- this is what made the DEC-307 collision possible even with a correct survey scope. Needs a cycle-close decision: split the namespaces, or stand up a single authoritative `DECISIONS-INDEX.md`.
3. No guard exists on CANONICAL-COUNTS ADR-count prose (drifted once already, fixed pass-19).
4. No guard exists on the amended-BC roster prose across its 5 surfaces (recurring stragglers, passes 12-17).
5. Need a reversal-propagation checklist for the PO/state-manager workflow -- reversing a DEC (or renumbering one) has a predictable propagation set that keeps getting missed piecemeal. This session's sweep closed one instance of the gap; the checklist itself is still not built.
6. **DEC-survey-scope gap:** any future "next sequential DEC number" survey MUST scan the whole `.factory/` tree (STATE.md + `cycles/` included), not just `specs/`.

**Pending human decision:** F2 human gate (after convergence -- 3/3 clean), then F3-F7.

**In flight / uncommitted at this checkpoint:** none -- the propagation-sweep files (6 spec files + `sidecar-learning.md`) and this STATE.md are committed to `factory-artifacts` together as part of this session's commit.

**Resume command:** `/vsdd-factory:next-step` (or resume the F2 adversarial convergence loop directly -- run a fresh adversary pass first; do not assume the prior "converged" framing without a real CLEAN verdict this time).

**Superseded checkpoint:** prior Session Resume Checkpoint (WRAP-F2-CONVERGENCE-PAUSE, v3.06, 2026-08-26) archived verbatim to `cycles/cycle-002/session-checkpoints.md`. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**Resolved this session (2026-08-26):**
- `DEC-307-TO-DEC-310-PROPAGATION-INCOMPLETE` (was MEDIUM) -- CLOSED. product-owner corrected the 35 residual `DEC-307` occurrences across the 6 flagged files; guards re-verified PASS.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry; this is what allowed the DEC-307 collision. See Session Resume Checkpoint process-gap follow-up #2.
- `CLEAN-STREAK-DOUBLE-RESET` (LOW, observational) -- this was the second consecutive session where the F2 convergence streak was reset to 0/3 by fresh findings. Worth watching whether the "frozen delta" framing between sessions is reliable, or whether each resume should default-assume un-converged until a fresh pass proves otherwise.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
