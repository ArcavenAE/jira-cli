---
document_type: pipeline-state
level: ops
version: "3.07"
status: active
producer: state-manager
timestamp: 2026-08-26T12:00:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). F2-ADVERSARY-CONVERGENCE-RESUME (2026-08-26): Feature Mode cycle-002 (field-dx bundle, GH #580 + #578) resumed from the prior /wrap. 3 fresh-context adversary passes ran against the frozen F2 delta (correctness / completeness / traceability lenses) -- ALL THREE returned NOT-CLEAN. 6 MEDIUM + ~9 LOW findings routed through architect->product-owner->verifier and fixed this burst (arity-model M2 parity, create-path Gate-B collision guard, cascading split hardening, DEC-307->DEC-310 renumber, several LOW polish items). VP count 25->29. Clean-pass streak RESET to 0/3 -- a fresh 3-consecutive-CLEAN run is required before F2 Step 5/8. Pipeline flipped PAUSED->ACTIVE (loop resumed, in progress, not paused again this burst). state-manager's post-burst defensive sweep (S-7.02) found the DEC-307->DEC-310 renumber is INCOMPLETE (35 residual DEC-307 references across 6 further files) -- routed forward as an owed follow-up, not fixed this burst. trajectory-tail →1→3→0→2 (unchanged this burst). Full detail in Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE, F2 adversarial spec-convergence loop RESUMED this session (0/3 clean streak, in progress); see current_step + Session Resume Checkpoint"
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, F2-ADVERSARY-CONVERGENCE-RESUME burst):
     189 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 189 = 11 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 189 = 311 lines of headroom remain before the hard cap of 500.
     Grew from 150 (v3.07 pre-template-fix) to 189 (v3.07 final) to add the four
     template-mandated H2 sections (Decisions Log, Skip Log, Blocking Issues, Historical
     Content) this repo's STATE.md has never carried, and to satisfy the trajectory-tail
     cell-completeness hook (marker now present in frontmatter current_step AND the Last
     Updated table cell) -- still ONE full-content Write, no Edit chain (DEC-247). The
     superseded WRAP-F2-CONVERGENCE-PAUSE Session Resume Checkpoint was archived verbatim to
     cycles/cycle-002/session-checkpoints.md (newly created this burst) before this Write.
     This burst also created cycles/cycle-002/ for the first time (burst-log.md +
     session-checkpoints.md) -- prior cycle-002 activity was tracked only in STATE.md /
     phase-f1-delta-analysis/ / phase-f2-spec-evolution/ / spec-changelog.md.
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
| **Last Updated** | F2-ADVERSARY-CONVERGENCE-RESUME (2026-08-26): F2 loop resumed, 3 fresh passes (all NOT-CLEAN), 6 MEDIUM+9 LOW fixed, VP 25→29, DEC-307→DEC-310 (partial propagation), clean-streak reset 0/3. v3.06→v3.07. trajectory-tail →1→3→0→2 (unchanged). |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- Phase F2 (spec evolution), ACTIVE inside the mandatory adversarial spec-convergence loop (streak 0/3). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2 is spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| RELEASE-V0.7.0-DEV.2 | COMPLETE | 2026-08-25 | release pipeline | PR #736 squash-merged `00df3823`; tag `v0.7.0-dev.2` pushed; release.yml run 32858800028 SUCCESS. | trajectory-tail →1→3→0→2 (unchanged) |
| MAINTENANCE-SWEEP-2026-08-25 | COMPLETE | 2026-08-25 | quality sweep | 10 findings (dependency CLEAN; doc drift 6 fixed via PR #737 MERGED squash `e7e194ff`; pattern CLEAN; holdout gap flagged; tech debt none overdue). 4 findings pending (see Drift/Standing Items). | trajectory-tail →1→3→0→2 (unchanged) |
| STATE-COMPACTION | COMPLETE | 2026-08-25 | -- | STATE.md compacted 274 to under-120 lines to cure validator-timeout hangs. Pre-compaction content at factory-artifacts@43f4a5e3. | trajectory-tail →1→3→0→2 (unchanged) |
| WRAP-F2-CONVERGENCE-PAUSE | PAUSED (superseded) | 2026-08-26 | human /wrap | cycle-002 F1 COMPLETE+approved; F2 spec authoring COMPLETE. Loop stopped mid pass-30 (no verdict) after passes 26/27 CLEAN, 28/29 MEDIUM-fixed. Superseded by the F2-ADVERSARY-CONVERGENCE-RESUME row below -- full checkpoint archived to cycles/cycle-002/session-checkpoints.md. | trajectory-tail →1→3→0→2 (unchanged); ~30 passes run, clean-streak was 0/3 at wrap |
| F2-ADVERSARY-CONVERGENCE-RESUME | ACTIVE (loop in progress) | 2026-08-26 | fix-burst (architect->PO->verifier) | 3 fresh-context passes (correctness/completeness/traceability) ALL NOT-CLEAN. 6 MEDIUM+9 LOW fixed: M2 default-project parity (A-M1/D1), create-path Gate-B guard (B-F3/D2), cascading-split hardening (B-F2/D3), BC-X.14.002 example fix (A-M2), BC-X.14.001 M3 pagination correction (B-F1), DEC-307->DEC-310 renumber (C-M1, partial). 719 BCs unchanged; VP 25->29; 106 holdouts unchanged. Both guard scripts re-verified PASS post-burst. | trajectory-tail →1→3→0→2 (unchanged); streak reset to 0/3 this burst |

## Current Phase Steps (cycle-002, phase F2; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F2 mandatory adversarial spec-convergence loop -- pass-30 (superseded) | SUPERSEDED | Was PAUSED mid pass-30 (no verdict) at prior `/wrap`. Superseded by this session's resume; see next row. Full detail archived in `cycles/cycle-002/session-checkpoints.md`. |
| F2 mandatory adversarial spec-convergence loop -- resume fix-burst | ACTIVE (0/3 clean) | This session ran 3 fresh-context adversary passes against the frozen delta; all three NOT-CLEAN. 6 MEDIUM+9 LOW findings fixed via architect->PO->verifier (see `cycles/cycle-002/burst-log.md` Burst 1). Clean-pass streak reset to 0/3 -- 3 CONSECUTIVE CLEAN passes are required before proceeding to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). |
| Owed follow-up: DEC-307->DEC-310 propagation sweep | OPEN | state-manager's post-burst defensive sweep found 35 residual `DEC-307` references (field-dx/BC-3.8.012-reversal context) still unswept across 6 files, after the architect's fix scoped the renumber to only 2 files. Must be closed before F2 Step 5/cycle close. See Drift/Standing Items and `cycles/cycle-002/burst-log.md` Burst 1 process-gap findings 1-2 for the full file list. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered this burst) | product-owner (proposed); orchestrator/state-manager to register formally at cycle close |
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
| (none currently open) | -- the DEC-307->DEC-310 propagation gap and the DEC-namespace question (see Session Resume Checkpoint "Process-gap follow-ups") are tracked debt, not hard blockers -- they must close before F2 Step 5/cycle close but do not block resuming the adversary loop | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): all five convergence dimensions plus Regression are PASS (MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized 2026-08-24) -- historical, unchanged this burst.

`cycle-002` (`field-dx`) is mid F2's mandatory adversarial spec-convergence loop, RESUMED this session. Substantive design was believed CONVERGED entering this session (arity model, DEC-307 reversal cluster, Gate B x hint interaction, `:asset` split, createmeta pagination), but three fresh-context adversary passes (correctness / completeness / traceability lenses) run against that "frozen" delta **all returned NOT-CLEAN** -- fresh eyes found 6 MEDIUM + ~9 LOW findings the prior ~30-pass run had missed or that regressed. All were fixed this burst via the architect -> product-owner -> verifier chain: M2 (`--type`) default-project parity restored (arity fn narrowed to 3 bools + new sibling `resolve_m2_project`); create-path Gate-B collision guard added (mirrors the edit-path guard); cascading `>`-split hardened to `str::split_once('>')` everywhere (FIX-F6-LRE-1 class); a worked example and a pagination postcondition were corrected; DEC-307 (the proposed governance flag for BC-3.8.012's reversal) was found to already be allocated to an unrelated cycle-001 decision and renumbered to **DEC-310**. Counts: 719 BCs unchanged; VP total **25 -> 29** (5 new ids: VP-578-020/021/022, VP-580-010/011); 106 holdouts unchanged. **Mandatory rule: 3 CONSECUTIVE clean passes required before F2 Step 5/8 -- the streak restarts at 0/3 following this burst's fixes**, exactly as it did after the prior wrap (this is the SECOND reset in a row -- see Drift/Standing Items for the recurring-regression concern this raises).

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at F2, adversarial spec-convergence loop in progress (streak 0/3). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase F2 (spec evolution), inside the MANDATORY adversarial spec-convergence loop. Pipeline ACTIVE -- loop resumed and in progress this session, not paused.

**F1:** COMPLETE + human-approved (unchanged this burst). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2 authoring:** COMPLETE (unchanged this burst) plus this session's fix-burst amendments. 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25, § Amendment 2026-08-26 D1/D2/D3 added this burst), BC-3.8.012 reversed (governance flag now **DEC-310**, was proposed DEC-307). Counts: **719 total BCs** (BC-INDEX v6.82), **29 VPs** (VP-578-001..022 + VP-580-005..011; was 25), **106 holdout scenarios**.

**This session's burst (2026-08-26):** 3 fresh-context adversary passes (correctness / completeness / traceability lenses) ran against the delta the prior session believed frozen-converged. **All three NOT-CLEAN.** 6 MEDIUM + ~9 LOW findings closed via architect -> product-owner -> verifier:
- A-M1/D1: M2 default-project parity (arity fn narrowed to `(has_type, has_request_type, has_issue)`; new sibling `resolve_m2_project`).
- B-F3/D2: create-path Gate-B collision guard (`create --priority X --field priority:name=X` now exits 64, mirrors edit-path).
- B-F2/D3: cascading `>`-split hardened to `str::split_once('>')` at every call site.
- A-M2: BC-X.14.002 worked example corrected (was missing a mode selector).
- B-F1: BC-X.14.001 M3 pagination postcondition corrected (`get_request_type_fields` is single-GET, non-paginated -- confirmed not a gap).
- C-M1: DEC-307 found ALREADY ALLOCATED (cycle-001 F5 combined-delta fix) via a full-`.factory/`-tree survey (the original proposal used a `specs/`-only grep that missed STATE.md/`cycles/`; true max was DEC-309). Renumbered to **DEC-310** (proposed, owed formal registration).
- ~9 LOWs: BC-3.4.026 scope qualifier; BC-X.14.001 precondition + reverse-resolution EC; `:asset` failure-taxonomy catalog (new VP-578-022); empty cascading-segment EC; `--value ""` + graceful-degrade (new VP-580-011); H-NEW-PREFLIGHT-006 removal-obligation addition.

**Guard scripts re-verified post-burst by state-manager:** `scripts/check-spec-counts.sh` -> exit 0 ("8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("719 total across 9 files"). The verifier's reported validation-hook timeout during its own edit pass was tooling noise, not a real rejection -- on-disk counts are clean.

**Convergence counter -- CRITICAL for resume:** clean-pass streak is **0/3** as of this burst (this is the SECOND consecutive reset -- the prior session also entered `/wrap` at 0/3 after pass-28/29 broke a 2-pass streak). **ON RESUME:** run fresh adversary passes on the now-refixed delta until 3 in a row are CLEAN, then proceed to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). **Before that**, close the owed DEC-307->DEC-310 propagation sweep below -- leaving stale decision-ID references in a changelog line that ships at Step 5 would itself likely trip a future adversary pass.

**Decisions of record:** DEC-310 (reverses DEC-188; proposed, supersedes the collided DEC-307 proposal) -- needs formal registration at cycle close. ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26 this burst).

**Process-gap follow-ups owed at cycle close:**
1. **Register DEC-310** (supersedes the "Register DEC-307" item -- DEC-307 turned out to already be allocated to a cycle-001 decision).
2. **DEC-namespace disambiguation question (NEW this burst):** spec-authored DECs (e.g. DEC-188, DEC-310) and cycle-gate DECs (e.g. DEC-309, cycle-001's F7 closure) currently share one flat `DEC-NNN` prefix with no central registry -- this is what made the DEC-307 collision possible even with a correct survey scope. Needs a cycle-close decision: split the namespaces, or stand up a single authoritative `DECISIONS-INDEX.md`.
3. **DEC-307->DEC-310 propagation is INCOMPLETE (NEW this burst, found by state-manager's defensive sweep, S-7.02):** the architect's fix explicitly scoped the renumber to 2 files (`bc-3-issue-write.md`, `prd-delta-field-dx.md`). 35 residual `DEC-307` references remain across 6 further files -- see Drift/Standing Items below for the full file list. state-manager cannot fix spec content directly; routed forward.
4. No guard exists on CANONICAL-COUNTS ADR-count prose (drifted once already, fixed pass-19).
5. No guard exists on the amended-BC roster prose across its 5 surfaces (recurring stragglers, passes 12-17).
6. Need a reversal-propagation checklist for the PO/state-manager workflow -- reversing a DEC (or renumbering one) has a predictable propagation set that keeps getting missed piecemeal. This burst's item 3 is the same gap recurring against a fresh cause.
7. **DEC-survey-scope gap (NEW this burst, root cause of the DEC-307 collision):** any future "next sequential DEC number" survey MUST scan the whole `.factory/` tree (STATE.md + `cycles/` included), not just `specs/` -- a `specs/`-only grep is what produced the wrong DEC-307 proposal this burst had to correct.

**Pending human decision:** F2 human gate (after convergence -- 3/3 clean), then F3-F7.

**In flight / uncommitted at this checkpoint:** none -- all files touched this burst (spec deltas, ADR-0019, `bc-3-issue-write.md`, `cross-cutting.md`, `sidecar-learning.md`, this STATE.md, `cycles/cycle-002/burst-log.md`, `cycles/cycle-002/session-checkpoints.md`) are committed to `factory-artifacts` together as part of this burst.

**Resume command:** `/vsdd-factory:next-step` (or resume the F2 adversarial convergence loop directly -- run a fresh adversary pass first; do not assume the prior "converged" framing without a real CLEAN verdict this time).

**Superseded checkpoint:** prior Session Resume Checkpoint (WRAP-F2-CONVERGENCE-PAUSE, v3.06, 2026-08-26) archived verbatim to `cycles/cycle-002/session-checkpoints.md` (newly created this burst). The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1, this session) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**New (2026-08-26, this burst):**
- `DEC-307-TO-DEC-310-PROPAGATION-INCOMPLETE` (MEDIUM) -- state-manager's post-commit defensive sweep (S-7.02) found 35 residual `DEC-307` occurrences (field-dx/BC-3.8.012-reversal context) still unswept, after the architect's renumbering fix scoped itself to 2 files. Remaining files: `phase-f2-spec-evolution/verification-delta-field-dx.md` (7), `phase-f2-spec-evolution/architecture-delta-field-dx.md` (1), `specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md` (1, §References), `specs/prd/holdout-scenarios.md` (15), `specs/prd/CANONICAL-COUNTS.md` (4, `last_verified` changelog prose), `specs/prd/BC-INDEX.md` (7, `last_updated` changelog prose). Must be swept before F2 Step 5 (spec version bump + changelog) and before cycle close. state-manager cannot fix spec content directly (bookkeeping-only role) -- routed to next fix pass.
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry; this is what allowed the DEC-307 collision. See Session Resume Checkpoint process-gap follow-up #2.
- `CLEAN-STREAK-DOUBLE-RESET` (LOW, observational) -- this is the second consecutive session where the F2 convergence streak was reset to 0/3 by fresh findings (prior: pass-28/29 broke a 2-pass streak; this session: 3/3 fresh passes all NOT-CLEAN against a delta believed converged). Worth watching whether the "frozen delta" framing between sessions is reliable, or whether each resume should default-assume un-converged until a fresh pass proves otherwise.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
