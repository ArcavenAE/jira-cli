---
document_type: pipeline-state
level: ops
version: "3.14"
status: active
producer: state-manager
timestamp: 2026-08-26T22:27:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). F2-CONVERGENCE-CLOSE (2026-08-26): the mandatory adversarial spec-convergence loop reached 3-CONSECUTIVE-CLEAN. A fresh 3-pass streak (orchestrator label: streak-6; run against the round-6 committed delta, factory-artifacts@b8082ba4, with NO intervening fixes) returned CLEAN on all three diverse-lens passes: Pass 1 (correctness) CLEAN -- verified the D2 create-guard TEN-key count against actual source (create.rs), guard-ordering determinism, and the VP-count reconciliation (32, three ways); Pass 2 (completeness) CLEAN -- no new CRITICAL/HIGH/MEDIUM, six rounds of convergence drove the delta to the floor; Pass 3 (traceability) CLEAN -- VP inventory (32, no orphans), TEN-count consistent across all 4 surfaces, DEC-310 governance, holdouts, and the 719/32/106 counts all reconcile. Each pass surfaced only 1-2 LOW doc-hygiene items (4 total, tracked below as non-blocking debt -- these do NOT reset the clean streak, per the mandatory rule, which resets only on NOT-CLEAN/MEDIUM+ verdicts). F2 mandatory adversarial spec-convergence is CONVERGED. Spec version bumped v1.5.0 -> v1.6.0 (MINOR per DF-030; MINOR-vs-MAJOR question on the BC-3.8.012/DEC-310 reversal explicitly flagged for the human gate, not forced). spec-changelog.md's [1.6.0] entry PROCESS-INTEGRITY CAVEAT (which had recorded the pre-convergence 0/3 streak as of b8082ba4) is reconciled in this commit to state convergence achieved and recorded here, superseding that caveat. Both guard scripts re-verified PASS (719). Pipeline stays ACTIVE, F2 now ready for Step 8 (human gate) -- still OPEN: DEC-310 formal registration, DEC-namespace disambiguation question, F-3 JSM collision-guard extension decision, and MINOR-vs-MAJOR spec-version confirmation. Full detail in Session Resume Checkpoint below and cycles/cycle-002/burst-log.md Burst 7."
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
cycle_002_status: "field-dx -- ACTIVE at F2; mandatory adversarial spec-convergence loop CONVERGED (streak-6: 3/3 CONSECUTIVE CLEAN, run against b8082ba4 with zero intervening fixes). Ready for F2 Step 8 human gate. Spec v1.6.0 (MINOR, MINOR-vs-MAJOR question flagged for human). See current_step + Session Resume Checkpoint."
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, F2-CONVERGENCE-CLOSE burst):
     192 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 192 = 8 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 192 = 308 lines of headroom remain before the hard cap of 500.
     This burst updated frontmatter (version/timestamp/current_step/cycle_002_status),
     superseded the round-6 Phase Progress row and added a CONVERGED row, refreshed Current
     Phase Steps (last 5 rows), replaced the Convergence Status paragraph with a condensed
     CONVERGED summary, and replaced the Session Resume Checkpoint (round-6's checkpoint
     archived to cycles/cycle-002/session-checkpoints.md) -- no new H2 sections added, one
     full-content Write, no Edit chain (DEC-247).
     Pre-compaction (pre-2026-08-25) full history remains at factory-artifacts commit
     43f4a5e3 and cycles/cycle-001/burst-log.md. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst -- spec-convergence bookkeeping only, no develop merges) |
| **Last Updated** | F2-CONVERGENCE-CLOSE (2026-08-26): trajectory-tail →1→3→0→2 (unchanged). A fresh 3-pass adversary streak (streak-6), run against the round-6 committed delta (b8082ba4) with zero intervening fixes, returned CLEAN on all three diverse-lens passes (Pass 1 correctness, Pass 2 completeness, Pass 3 traceability). F2 mandatory adversarial spec-convergence is CONVERGED (3/3 CONSECUTIVE CLEAN). 4 residual LOW doc-hygiene items tracked non-blocking. Spec v1.5.0 -> v1.6.0 (MINOR, MINOR-vs-MAJOR flagged for human gate). Both guards re-verified PASS (719). v3.13->v3.14. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- Phase F2 (spec evolution), mandatory adversarial spec-convergence loop **CONVERGED**; ready for F2 Step 8 (human gate). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2 is spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F2-ROUND5-FIX-CHAIN | SUPERSEDED (round-5) | 2026-08-26 | fix-chain | Fifth fresh streak, Pass 3 CLEAN, streak did not close (D2 governed-set count later found wrong in round-6). Full detail: `cycles/cycle-002/burst-log.md` Burst 5. | streak reset 0/3 |
| F2-ROUND6-FIX-CHAIN | SUPERSEDED (round-6) | 2026-08-26 | fix-chain | Sixth fresh streak -- Pass 1 NOT-CLEAN (1 MEDIUM), Pass 2+3 CLEAN. D2 create-guard count corrected 9->10 + 4 LOWs fixed. Full detail: `cycles/cycle-002/burst-log.md` Burst 6. | streak reset 0/3 |
| F2-CONVERGENCE-CLOSE (streak-6) | **CONVERGED** | 2026-08-26 | adversary (3 fresh diverse-lens passes) | Fresh 3-pass streak run against round-6 committed delta (b8082ba4), zero intervening fixes -- Pass 1 (correctness) CLEAN, Pass 2 (completeness) CLEAN, Pass 3 (traceability) CLEAN. 4 residual LOW doc-hygiene items tracked non-blocking (see Drift/Standing Items). Spec bumped v1.5.0->v1.6.0. Full detail: `cycles/cycle-002/burst-log.md` Burst 7. | **3/3 CONSECUTIVE CLEAN -- CONVERGED** |

## Current Phase Steps (cycle-002, phase F2; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F2 mandatory adversarial spec-convergence loop -- round-6 fix chain | SUPERSEDED | Closed by streak-6's clean run below. Full detail `cycles/cycle-002/burst-log.md` Burst 6. |
| Streak-6 fresh 3-pass adversary run (vs b8082ba4) | **COMPLETE -- 3/3 CLEAN** | Pass 1 (correctness) CLEAN, Pass 2 (completeness) CLEAN, Pass 3 (traceability) CLEAN, zero intervening fixes. F2 mandatory adversarial spec-convergence CONVERGED. |
| Spec version bumped v1.5.0 -> v1.6.0 | COMPLETE | `spec-changelog.md` [1.6.0] PROCESS-INTEGRITY CAVEAT reconciled to record achieved+recorded convergence, superseding the prior 0/3 caveat. MINOR-vs-MAJOR question explicitly flagged for the human gate, not forced. |
| Guard scripts re-verified post-convergence | PASS | `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files)"). |
| STATE.md updated to record F2 CONVERGED | COMPLETE | Phase F2, pipeline ACTIVE, status = ready for F2 Step 8 human gate. 4 residual LOW doc-hygiene items added to Drift/Standing Items as tracked non-blocking debt. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered; propagation sweep completed 2026-08-26) | product-owner (proposed); formal registration OPEN, owed at F2 human gate / cycle close |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>`; § Amendment F-B: `FieldOption.id`/`.label` are `Option<String>` (never-drop invariant); § Amendment D4: non-cascading `>`-collision detected structurally + bare-form `>` is literal; § "D2 correction": create-path collision-guard governed set corrected 5->9 (round-5), then 9->10 (round-6, `--points`/`--team` are two distinct wire keys) | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; `>` avoids collision with field names; F-B closes a HIGH-risk silent-drop gap; D4 closes a structural-detection + bare-form-asymmetry gap; D2 correction closes an under-scoped guard, then a count-arithmetic error in that same fix | F1/F2 | 2026-08-25 (Accepted); § Amendment 2026-08-26 (D1/D2/D3, F-B round-3, D4 round-4, D2 correction round-5, D2 count fix round-6) | architect |
| (pending) | D2 collision-guard extension to the JSM create path (dedicated flags that ARE merged onto the wire: `--summary`/`--description`/`--priority`/`--label`) -- DEFERRED, not decided either way | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform (several flags silently IGNORED, not merged) so the platform-shaped collision does not identically arise; needs explicit product judgment | F2 | 2026-08-26 (flagged round-4, MED-1/F-3; unchanged through streak-6) | owed at F2 human gate |
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
| (none currently open) | -- the DEC-namespace disambiguation question, formal DEC-310 registration, the DEFERRED D2-extension-to-JSM product decision (F-3), and the MINOR-vs-MAJOR spec-version confirmation are tracked debt/open decisions, not hard blockers -- they must close at the F2 human gate but do not block scheduling it | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): all five convergence dimensions plus Regression are PASS (MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized 2026-08-24) -- historical, unchanged this burst.

`cycle-002` (`field-dx`) F2's mandatory adversarial spec-convergence loop is **CONVERGED**. After rounds 1-6 (each a fix-chain that closed genuine findings but never reached 3 consecutive clean passes within one streak -- full history in `cycles/cycle-002/burst-log.md` Bursts 1-6), a fresh 3-pass streak (orchestrator label: streak-6) was run against the round-6 committed delta (factory-artifacts@`b8082ba4`) using three diverse review lenses -- Pass 1 correctness, Pass 2 completeness, Pass 3 traceability -- and **all three returned CLEAN with zero intervening fixes required**. Pass 1 verified the D2 create-guard TEN-key count against actual `create.rs` source, guard-ordering determinism, and the VP-count reconciliation (32, three independent ways). Pass 2 found no new CRITICAL/HIGH/MEDIUM -- six rounds of convergence drove the delta's defect surface to the floor. Pass 3 confirmed the VP inventory (32, no orphans), TEN-count consistency across all 4 contract surfaces, DEC-310 governance, holdout coverage, and the 719/32/106 counts all reconcile. Each pass surfaced 1-2 LOW doc-hygiene findings (4 total) -- these do NOT reset the streak (the mandatory rule resets only on a NOT-CLEAN/MEDIUM+ verdict) and are tracked as non-blocking debt in Drift/Standing Items below. **F2 mandatory adversarial spec-convergence is CONVERGED (3/3 CONSECUTIVE CLEAN).** Spec version bumped v1.5.0 -> v1.6.0 (MINOR per DF-030), recorded in `spec-changelog.md`; the MINOR-vs-MAJOR question on the BC-3.8.012/DEC-310 reversal is explicitly flagged for the F2 human gate, not forced. F2 is now ready for **Step 8 (human gate)** -- still OPEN: DEC-310 formal registration, the DEC-namespace disambiguation question, the F-3 JSM collision-guard-extension product decision, and MINOR-vs-MAJOR spec-version confirmation.

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at F2 -- mandatory adversarial spec-convergence loop **CONVERGED** (streak-6, 3/3 clean, zero intervening fixes), ready for F2 Step 8 human gate. No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase F2 (spec evolution) -- mandatory adversarial spec-convergence loop **CONVERGED**. Pipeline ACTIVE, awaiting F2 Step 8 human gate.

**F1:** COMPLETE + human-approved (unchanged). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2 authoring + rounds 1-6:** COMPLETE (unchanged this burst) -- 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26 D1/D2/D3 + F-B + D4 + D2 correction + D2 count fix), BC-3.8.012 reversed (governance flag **DEC-310**, fully propagated). Counts: **719 total BCs** (BC-INDEX v6.82), **32 VPs**, **106 holdout scenarios** -- all unchanged this burst (convergence-close is a bookkeeping/version burst; no spec-content edits beyond the version/changelog reconciliation).

**This session's work (2026-08-26, streak-6 / convergence-close):** a fresh 3-pass adversary streak was run against the round-6 committed delta (factory-artifacts@`b8082ba4`) -- **Pass 1 (correctness) CLEAN** (verified the D2 create-guard TEN-key count against actual `create.rs` source, guard-ordering determinism, and the VP-count reconciliation 32 three ways; only 2 LOW doc-hygiene items), **Pass 2 (completeness) CLEAN** (no new CRITICAL/HIGH/MEDIUM -- six-round convergence drove the delta to the floor; 1 LOW), **Pass 3 (traceability) CLEAN** (VP inventory 32 with no orphans, TEN-count consistent across all 4 surfaces, DEC-310 governance, holdouts, counts 719/32/106 all reconcile; 1 LOW). Zero intervening fixes were required between passes -- this is the first streak this session to reach **3/3 CONSECUTIVE CLEAN**. **F2 mandatory adversarial spec-convergence is CONVERGED.** 4 residual LOW doc-hygiene findings are tracked as non-blocking debt (they do not reset the streak): (1) stale `prd-delta-field-dx.md` round-2 step-2a narration; (2) platform `:asset` wire-shape UNVERIFIED note; (3) M1 (`jr field options`)'s editmeta-fallback path missing an explicit status/permission-dependency caveat; (4) `prd-delta-field-dx.md`'s Summary section's "9 amended BCs" count is stale -- should include BC-3.4.021/028/030 (round-5/round-6 amendments). Spec version bumped **v1.5.0 -> v1.6.0** (MINOR per DF-030) in `spec-changelog.md`; that entry's PROCESS-INTEGRITY CAVEAT (which had recorded the pre-convergence 0/3 streak as of `b8082ba4`) is reconciled in this commit to state convergence achieved and recorded here, superseding the prior caveat. MINOR-vs-MAJOR on the BC-3.8.012/DEC-310 reversal is explicitly flagged for the human gate, not forced. Both guard scripts re-verified PASS (`check-spec-counts.sh` -> exit 0, 8 files; `check-bc-cumulative-counts.sh` -> exit 0, 719 total across 9 files). Full detail: `cycles/cycle-002/burst-log.md` Burst 7.

**Convergence counter -- RESOLVED:** streak is **3/3 CONSECUTIVE CLEAN -- CONVERGED.** No further adversary passes are required for F2. **ON RESUME:** proceed directly to **F2 Step 8 (human gate)** -- do not restart the adversary loop.

**Decisions of record:** DEC-310 (reverses DEC-188; proposed, propagation complete) -- **still needs formal registration**, owed at the F2 human gate / cycle close. ADR-0019 (Accepted 2026-08-25; 6 amendment rounds through round-6's D2 count fix). D2-collision-guard-extension-to-JSM question (F-3, round-4) remains DEFERRED, owed at the F2 human gate.

**Cycle-closing checklist -- process-gap follow-ups still owed (unchanged by this bookkeeping burst, none closed here):**
1. **Register DEC-310** formally.
2. **DEC-namespace disambiguation question:** spec-authored DECs and cycle-gate DECs currently share one flat `DEC-NNN` prefix with no central registry -- needs a cycle-close decision (split namespaces, or stand up a `DECISIONS-INDEX.md`).
3. **Reversal-propagation checklist** for the PO/state-manager workflow -- still not built.
4. **`COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN`** lesson from round-6 (a count-discrepancy reconciliation must re-derive the semantically correct count from the underlying distinct entities, not force consistency onto whichever number appeared first) -- candidate for a spec-authoring checklist item, not yet actioned.
5. The **4 residual LOW doc-hygiene items** from streak-6 (see above and Drift/Standing Items) -- non-blocking, owed before or at cycle close.
6. **MINOR-vs-MAJOR spec-version confirmation** -- `spec-changelog.md` [1.6.0]'s classification is a spec-steward judgment call, explicitly flagged for human confirmation at the F2 gate.

**Pending human decision:** F2 human gate (Step 8) -- confirm convergence, register DEC-310, decide the DEC-namespace question, decide F-3 (D2-extension-to-JSM), and confirm/override the MINOR spec-version classification. Then proceed to F3-F7.

**In flight / uncommitted at this checkpoint:** none -- `STATE.md`, `spec-changelog.md`, and `cycles/cycle-002/burst-log.md` are committed to `factory-artifacts` together as part of this session's commit.

**Resume command:** `/vsdd-factory:next-step` (or proceed directly to the F2 human gate -- the adversary loop is CONVERGED, do not restart it).

**Superseded checkpoint:** the round-6 fresh-streak checkpoint (v3.13, 2026-08-26) is archived to `cycles/cycle-002/session-checkpoints.md`. Rounds 2-5 checkpoints and the WRAP-F2-CONVERGENCE-PAUSE checkpoint remain archived there. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1 = round-1 fresh streak; Burst 2 = round-2 fresh streak; Burst 3 = round-3 fix chain; Burst 4 = round-4 fix chain; Burst 5 = round-5 fix chain; Burst 6 = round-6 fix chain; Burst 7 = streak-6 convergence-close) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE + F2-ROUND2-FRESH-STREAK + F2-ROUND3-FIX-CHAIN + F2-ROUND4-FIX-CHAIN + F2-ROUND5-FIX-CHAIN + F2-ROUND6-FIX-CHAIN archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-002 lessons learned | `cycles/cycle-002/lessons.md` (round-6's [process-gap] count-reconciliation lesson) |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**Resolved this session (2026-08-26, streak-6 convergence-close):**
- `CLEAN-STREAK-REPEATED-RESET` (was WATCH) -- **CLOSED**. Streak-6 reached 3/3 CONSECUTIVE CLEAN against the round-6 committed delta (b8082ba4) with zero intervening fixes; F2 mandatory adversarial spec-convergence is CONVERGED.
- `DEC-307-TO-DEC-310-PROPAGATION-INCOMPLETE` (was MEDIUM) -- CLOSED (round-6). product-owner corrected the 35 residual `DEC-307` occurrences across the 6 flagged files; guards re-verified PASS.
- `D2-CREATE-GUARD-COUNT-ARITHMETIC-ERROR` (MEDIUM, round-6) -- CLOSED. Round-5's D2 create-path collision-guard governed set was reported as "nine," but `--points`/`--team` are two distinct wire keys, not one collapsed category; corrected to TEN across all 5 contract surfaces (verified again, unchanged, by streak-6 Pass 1).

**New (2026-08-26, streak-6 residual doc-hygiene, LOW, non-blocking -- do NOT reset convergence):**
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION` (LOW) -- `prd-delta-field-dx.md`'s round-2 step-2a narration is stale; flagged by streak-6, not yet fixed. Tracked for cycle close.
- `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED` (LOW) -- the platform `:asset` wire-shape carries an UNVERIFIED note; flagged by streak-6, tracked non-blocking for cycle close.
- `M1-EDITMETA-STATUS-PERMISSION-CAVEAT` (LOW) -- M1 (`jr field options`)'s editmeta FALLBACK path needs an explicit status/permission-dependency caveat; flagged by streak-6, tracked non-blocking for cycle close.
- `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE` (LOW) -- `prd-delta-field-dx.md`'s Summary section says "9 amended BCs" but should include BC-3.4.021/028/030 (round-5/round-6 amendments); flagged by streak-6, tracked non-blocking for cycle close.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry. See Session Resume Checkpoint process-gap follow-up #2. Owed at F2 human gate.
- `BC-INDEX-GUARD-GAP` (LOW, unchanged) -- no automated guard ties BC-INDEX.md prose to BC-body H1/text; the specific round-3 drift instance is fixed. See process-gap follow-up in prior rounds.
- `D2-JSM-EXTENSION-DEFERRED` (LOW/product-decision, round-4, unchanged through streak-6) -- MED-1/F-3 flagged extending the D2 collision guard to JSM's wire-merged dedicated flags as an open product decision, not yet made either way. Owed at the F2 human gate.
- `GUARD-SCOPE-COPY-PASTE-PATTERN` (LOW/process, round-5, unchanged through streak-6) -- round-5's F-NEW-1 is a guard-scope-copy-paste instance; candidate spec-authoring checklist item.
- `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` (LOW/process, round-6, unchanged through streak-6) -- round-6's M-1 sibling failure mode to `GUARD-SCOPE-COPY-PASTE-PATTERN`: a count-discrepancy reconciliation forced consistency onto a prior round's cited number instead of re-deriving the semantically correct count. Logged in `cycles/cycle-002/lessons.md`.
- `DEC-310-FORMAL-REGISTRATION-OPEN` (LOW/governance) -- DEC-310 is proposed and fully propagated but not yet formally registered. Owed at the F2 human gate / cycle close.
- `MINOR-VS-MAJOR-SPEC-VERSION-FLAGGED` (LOW/governance, new this burst) -- `spec-changelog.md` [1.6.0]'s MINOR classification for the BC-3.8.012/DEC-310 reversal is a spec-steward judgment call, explicitly flagged for human confirmation at the F2 gate; if overridden, version should be revised to v2.0.0 before cycle close.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
