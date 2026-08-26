---
document_type: pipeline-state
level: ops
version: "3.09"
status: active
producer: state-manager
timestamp: 2026-08-26T15:45:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). F2-ROUND2-FRESH-STREAK (2026-08-26): after the DEC-307->DEC-310 propagation sweep closed, a SECOND fresh 3-pass adversary streak was run against the field-dx delta (attempt to reach 3/3 CLEAN) -- ALL THREE passes again returned NOT-CLEAN, this time 5 MEDIUM + 2 LOW findings (smaller than round-1's 6 MED+~9 LOW, but still non-clean). Fixed via a PO->verifier->PO back-fill chain (no architect step needed this round): Pass1-F1 rewrote VP-580-006 Section 2's stale pre-D1 4-boolean resolve_field_context signature to the correct 3-boolean shape; Pass2-F1 widened the :asset cold-cache workspace-discovery failure taxonomy to all 3 call sites (edit/create/jsm_create, BC-3.4.030/VP-578-022); Pass2-F2 added a new --project-not-found (404) taxonomy row + EC-X.14.004-6 + minted VP-580-012 (BC-X.14.004), with PO back-filling its one-line cross-cutting.md BC-body declaration; Pass2-F3 mandated str::split_once(':') for the :asset WORKSPACE:OBJECTID split (BC-3.4.030, VP-578-012 extended); Pass2-F4 (LOW) corrected objectId's \\d+ to ASCII-only [0-9]+; Pass2-F5 (LOW) pinned the evaluation order between the D2 create-path collision guard and the pre-existing BC-3.8.013 guard; Pass3 corrected a dangling `.factory/specs/verification-delta/` path citation at 3 sites to the real `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md`. VP count 29->30 (VP-580-012 minted; no BC change, 719 stays). Clean-pass streak REMAINS 0/3 -- this was a second failed attempt at a clean streak, not a partial credit; a fresh, fully-clean 3-pass run is still required before F2 Step 5/8. Both guard scripts re-verified PASS. Pipeline stays ACTIVE (loop in progress). trajectory-tail →1→3→0→2 (unchanged). Full detail in Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE, F2 adversarial spec-convergence loop RESUMED this session (0/3 clean streak, in progress, second fresh streak also NOT-CLEAN this round); see current_step + Session Resume Checkpoint"
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, F2-ROUND2-FRESH-STREAK burst):
     178 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 178 = 22 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 178 = 322 lines of headroom remain before the hard cap of 500.
     This burst updated frontmatter (version/timestamp/current_step), added one Phase Progress
     row, added one Current Phase Steps row (archived the oldest superseded row's detail to
     burst-log Burst 2), updated the Convergence Status paragraph, and updated the Session Resume
     Checkpoint -- no new H2 sections added, one full-content Write, no Edit chain (DEC-247).
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
| **Last Updated** | F2-ROUND2-FRESH-STREAK (2026-08-26): a second fresh 3-pass adversary streak (post-propagation-sweep) again returned ALL NOT-CLEAN (5 MEDIUM + 2 LOW). Fixed via PO->verifier->PO back-fill chain: VP-580-006 3-bool signature rewrite, :asset failure-taxonomy widened to 3 call sites, new `--project` 404 taxonomy row + VP-580-012 minted, `:`-split MUST, objectId ASCII-only fix, guard-ordering pin, dangling path citation fixed. VP 29→30; 719 BCs and 106 holdouts unchanged. Both guards re-verified PASS. Clean-streak still 0/3. trajectory-tail →1→3→0→2 (unchanged). v3.08→v3.09. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- Phase F2 (spec evolution), ACTIVE inside the mandatory adversarial spec-convergence loop (streak 0/3, second fresh-streak attempt also NOT-CLEAN). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2 is spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| WRAP-F2-CONVERGENCE-PAUSE | PAUSED (superseded) | 2026-08-26 | human /wrap | cycle-002 F1 COMPLETE+approved; F2 spec authoring COMPLETE. Loop stopped mid pass-30 (no verdict) after passes 26/27 CLEAN, 28/29 MEDIUM-fixed. Superseded by the F2-ADVERSARY-CONVERGENCE-RESUME row below -- full checkpoint archived to cycles/cycle-002/session-checkpoints.md. | trajectory-tail →1→3→0→2 (unchanged); ~30 passes run, clean-streak was 0/3 at wrap |
| F2-ADVERSARY-CONVERGENCE-RESUME | SUPERSEDED (round-1) | 2026-08-26 | fix-burst (architect->PO->verifier) | 3 fresh-context passes (correctness/completeness/traceability) ALL NOT-CLEAN. 6 MEDIUM+9 LOW fixed: M2 default-project parity, create-path Gate-B guard, cascading-split hardening, BC-X.14.002 example fix, BC-X.14.001 pagination correction, DEC-307->DEC-310 renumber (2-file scope, partial). 719 BCs unchanged; VP 25->29; 106 holdouts unchanged. Superseded by the round-2 row below (propagation sweep + a further fresh streak followed). | trajectory-tail →1→3→0→2 (unchanged); streak reset to 0/3 this burst |
| DEC-307-TO-DEC-310-PROPAGATION-SWEEP | COMPLETE | 2026-08-26 | state-manager commit | product-owner closed the owed follow-up: 35 residual DEC-307 refs corrected to DEC-310 across 6 flagged spec files. cycle-001's genuine DEC-307 and STATE.md/cycles/cycle-002 renumber-narration correctly left untouched. Both guard scripts re-verified PASS (719 BCs / 29 VPs / 106 holdouts unchanged). | trajectory-tail →1→3→0→2 (unchanged); streak still 0/3 -- sweep is bookkeeping, not an adversary pass |
| F2-ROUND2-FRESH-STREAK | ACTIVE (loop in progress) | 2026-08-26 | fix-chain (PO->verifier->PO back-fill) | A SECOND fresh 3-pass streak (post-sweep) again ALL NOT-CLEAN: 5 MEDIUM+2 LOW fixed -- VP-580-006 3-bool signature rewrite (Pass1-F1), :asset cold-cache failure taxonomy widened to 3 call sites (Pass2-F1, BC-3.4.030/VP-578-022), new `--project` 404 taxonomy row + VP-580-012 minted + back-filled (Pass2-F2, BC-X.14.004), `:`-split `str::split_once` MUST (Pass2-F3, BC-3.4.030/VP-578-012 extended), objectId ASCII-only `[0-9]+` fix (Pass2-F4, LOW), D2/BC-3.8.013 guard-ordering pin (Pass2-F5, LOW), dangling verification-delta path fixed at 3 sites (Pass3). 719 BCs unchanged; VP 29->30; 106 holdouts unchanged. Both guard scripts re-verified PASS post-burst. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINS 0/3 -- second failed clean-streak attempt |

## Current Phase Steps (cycle-002, phase F2; last 5)

| Step | Status | Notes |
|------|--------|-------|
| Owed follow-up: DEC-307->DEC-310 propagation sweep | CLOSED | product-owner completed the sweep: 35 residual `DEC-307` references corrected to `DEC-310` across the 6 files flagged by state-manager's defensive sweep. cycle-001's genuine DEC-307 and the intentional renumber-narration in STATE.md/`cycles/cycle-002/*` were left untouched. Both guard scripts re-verified PASS post-sweep. |
| F2 mandatory adversarial spec-convergence loop -- round-1 fresh streak (superseded) | SUPERSEDED | First fresh 3-pass streak post-resume, all NOT-CLEAN (6 MED+~9 LOW fixed). Full detail in `cycles/cycle-002/burst-log.md` Burst 1. Superseded by the round-2 streak below. |
| F2 mandatory adversarial spec-convergence loop -- round-2 fresh streak | ACTIVE (0/3 clean) | This session ran a SECOND fresh 3-pass adversary streak (post-propagation-sweep) against the delta; all three again NOT-CLEAN. 5 MEDIUM+2 LOW findings fixed via a PO->verifier->PO back-fill chain (no architect step this round) -- see `cycles/cycle-002/burst-log.md` Burst 2. Clean-pass streak REMAINS 0/3 -- 3 CONSECUTIVE CLEAN passes are still required before F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). |
| VP total updated 29 -> 30 | COMPLETE | VP-580-012 minted this round (BC-X.14.004, `--project` not-found (404) taxonomy). No BC-INDEX.md/CANONICAL-COUNTS.md VP-total surface exists to update (only STATE.md carries a standalone VP-count figure; confirmed again this round). 719 BCs / 106 holdouts unchanged. |
| Guard scripts re-verified | PASS | `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files)"). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered; propagation sweep completed 2026-08-26) | product-owner (proposed); orchestrator/state-manager to register formally at cycle close |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>` | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; `>` avoids collision with field names | F1/F2 | 2026-08-25 (Accepted); § Amendment 2026-08-26 (D1/D2/D3) | architect |
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

`cycle-002` (`field-dx`) is mid F2's mandatory adversarial spec-convergence loop. After the round-1 fresh streak (all NOT-CLEAN, 6 MEDIUM+~9 LOW fixed) and the subsequent DEC-307->DEC-310 propagation sweep closed, a SECOND fresh 3-pass streak was run against the now-fully-propagated delta to attempt the required 3/3 CLEAN -- **it again returned ALL NOT-CLEAN**, this time 5 MEDIUM + 2 LOW findings: a stale pre-D1 VP-580-006 signature in the verification delta, an under-scoped `:asset` cold-cache failure taxonomy (only 1 of 3 call sites), a missing `--project` not-found (404) taxonomy row (now VP-580-012), a missing `str::split_once(':')` MUST on the `:asset` colon-split, a Unicode-vs-ASCII `objectId` validation gap, an unpinned guard-evaluation order between the D2 create-path guard and BC-3.8.013, and a dangling `.factory/specs/verification-delta/` path citation. All were fixed via a PO -> verifier -> PO back-fill chain (this round needed no architect involvement). Counts: 719 BCs unchanged; VP total **29 -> 30** (VP-580-012 newly minted); 106 holdouts unchanged. **Mandatory rule unchanged: 3 CONSECUTIVE clean adversary passes are still required before F2 Step 5/8 -- the streak remains 0/3.** This is now the second consecutive fresh-streak attempt to fail cleanly at 0/3 within this session; see Drift/Standing Items for the recurring-pattern watch item.

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at F2, adversarial spec-convergence loop in progress (streak 0/3, second fresh-streak attempt also NOT-CLEAN). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase F2 (spec evolution), inside the MANDATORY adversarial spec-convergence loop. Pipeline ACTIVE -- loop in progress this session, not paused.

**F1:** COMPLETE + human-approved (unchanged this burst). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2 authoring:** COMPLETE (unchanged this burst) plus round-1's fix-burst amendments, the DEC propagation sweep, and this round's fix-chain. 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25, § Amendment 2026-08-26 D1/D2/D3), BC-3.8.012 reversed (governance flag **DEC-310**, fully propagated). Counts: **719 total BCs** (BC-INDEX v6.82), **30 VPs** (was 29; VP-580-012 minted this round), **106 holdout scenarios**.

**This session's work (2026-08-26, round-2):** after the DEC-307->DEC-310 propagation sweep closed, a second fresh 3-pass adversary streak was run against the delta (attempting the required 3/3 CLEAN) -- all three again returned NOT-CLEAN, 5 MEDIUM + 2 LOW findings this time. Fixed via a PO -> verifier -> PO back-fill chain: Pass1-F1 rewrote VP-580-006 §2's stale pre-D1 4-boolean `resolve_field_context` signature to the correct 3-boolean shape (`verification-delta-field-dx.md`); Pass2-F1 widened the `:asset` cold-cache workspace-discovery failure taxonomy from 1 to all 3 call sites (edit/create/jsm_create -- BC-3.4.030, VP-578-022); Pass2-F2 added a new `--project not found (404)` taxonomy row + EC-X.14.004-6 + minted VP-580-012 (BC-X.14.004, cross-cutting.md), with the PO back-filling its one-line BC-body declaration in the same chain; Pass2-F3 mandated `str::split_once(':')` for the `:asset` `WORKSPACE:OBJECTID` first-colon split (BC-3.4.030, VP-578-012 extended); Pass2-F4 (LOW) corrected `objectId` validation from Unicode-aware `\d+` to ASCII-only `[0-9]+`; Pass2-F5 (LOW) pinned the evaluation order between the D2 create-path collision guard and the pre-existing BC-3.8.013 guard (BC-3.8.013 evaluated first); Pass3 corrected a dangling `.factory/specs/verification-delta/` path citation (never existed) at 3 sites to `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md`. No BC change (719 stays). VP total **29 -> 30**. 106 holdouts unchanged.

**Guard scripts re-verified post-burst by state-manager:** `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). VP-total surface check: only STATE.md carries a standalone VP-count figure -- BC-INDEX.md and CANONICAL-COUNTS.md carry BC counts only (no VP-total field to update); individual `VP-NNN-NNN` citations inside BC bodies are not count surfaces.

**Convergence counter -- CRITICAL for resume:** clean-pass streak is **still 0/3** -- this was the second consecutive fresh-streak attempt within this session to fail to reach 3/3 CLEAN. **ON RESUME:** run a fresh adversary pass on the now-doubly-fixed delta; do not assume convergence without a real CLEAN verdict. Continue until 3 CONSECUTIVE CLEAN passes are achieved, then proceed to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate).

**Decisions of record:** DEC-310 (reverses DEC-188; proposed, propagation complete) -- still needs formal registration at cycle close. ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26).

**Process-gap follow-ups owed at cycle close:**
1. **Register DEC-310** formally (supersedes the "Register DEC-307" item -- DEC-307 turned out to already be allocated to a cycle-001 decision). Propagation of the renumber is CLOSED; only the formal registration step remains.
2. **DEC-namespace disambiguation question (still open):** spec-authored DECs (e.g. DEC-188, DEC-310) and cycle-gate DECs (e.g. DEC-309, cycle-001's F7 closure) currently share one flat `DEC-NNN` prefix with no central registry -- this is what made the DEC-307 collision possible even with a correct survey scope. Needs a cycle-close decision: split the namespaces, or stand up a single authoritative `DECISIONS-INDEX.md`.
3. No guard exists on CANONICAL-COUNTS ADR-count prose (drifted once already, fixed pass-19).
4. No guard exists on the amended-BC roster prose across its 5 surfaces (recurring stragglers, passes 12-17).
5. Need a reversal-propagation checklist for the PO/state-manager workflow -- reversing a DEC (or renumbering one) has a predictable propagation set that keeps getting missed piecemeal.
6. **DEC-survey-scope gap:** any future "next sequential DEC number" survey MUST scan the whole `.factory/` tree (STATE.md + `cycles/` included), not just `specs/`.

**Pending human decision:** F2 human gate (after convergence -- 3/3 clean), then F3-F7.

**In flight / uncommitted at this checkpoint:** none -- this round's touched files (`phase-f2-spec-evolution/prd-delta-field-dx.md`, `phase-f2-spec-evolution/verification-delta-field-dx.md`, `specs/prd/bc-3-issue-write.md`, `specs/prd/cross-cutting.md`, `sidecar-learning.md`) and this STATE.md are committed to `factory-artifacts` together as part of this session's commit.

**Resume command:** `/vsdd-factory:next-step` (or resume the F2 adversarial convergence loop directly -- run a fresh adversary pass first; do not assume the prior "converged" framing without a real CLEAN verdict this time).

**Superseded checkpoint:** prior Session Resume Checkpoint (WRAP-F2-CONVERGENCE-PAUSE, v3.06, 2026-08-26) archived verbatim to `cycles/cycle-002/session-checkpoints.md`. The round-1 fresh-streak checkpoint (v3.08, 2026-08-26) is superseded by this one. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1 = round-1 fresh streak; Burst 2 = round-2 fresh streak) |
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
- `CLEAN-STREAK-REPEATED-RESET` (LOW->WATCH, observational; upgraded this session) -- this is now the SECOND consecutive fresh-streak attempt within this session (and the third session overall) where the F2 convergence streak failed to reach 3/3 CLEAN, each time with genuine (if shrinking: ~15 -> 7) findings. The "frozen delta" framing between attempts continues to be unreliable in practice; each resume should default-assume un-converged until a fresh pass proves otherwise, and the shrinking finding count across rounds (round-1: 6 MED+~9 LOW; round-2: 5 MED+2 LOW) is a reasonable, but not yet proven, signal of approaching convergence.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
