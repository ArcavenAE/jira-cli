---
document_type: pipeline-state
level: ops
version: "3.16"
status: active
producer: state-manager
timestamp: 2026-08-26T23:49:00Z
phase: F3
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). F2-GATE-APPROVED-F3-TRANSITION (2026-08-26), spec-version RECONCILED (2026-08-26): human approved the F2 gate and delivered four decisions at the gate. (1) F2 gate APPROVED -> proceed to F3 (incremental stories). (2) Spec version APPLIED as v2.0.0 (MAJOR): at the gate the human initially rejected both the v1.6.0 MINOR and v2.0.0 MAJOR framings and declined to bump the version right then; the human's follow-up delegated the major/minor classification call to the orchestrator ('go ahead and bump the spec version, use your best judgement on major or minor'). Orchestrator determination: MAJOR -- v2.0.0, on the rationale that this cycle carries a governance-flagged reversal (DEC-188 -> DEC-310) of a previously-shipped, human-decided behavioral contract, which is MAJOR-worthy under this repo's own spec-versioning convention. `spec-changelog.md`'s entry header is now `[2.0.0]` (Type: MAJOR), and BC-INDEX.md/CANONICAL-COUNTS.md/bc-3-issue-write.md/prd-delta-field-dx.md already carry v2.0.0 on disk from the F2-gate-close burst; this reconciliation burst closes out the residual stale v1.6.0/DEFERRED/MINOR cross-references inside spec-changelog.md itself (Type legend, Changed Requirements bullet, Impact Assessment rows, and the state-manager UPDATE paragraph) that were outside the spec-steward's scope. (3) F-3 (JSM collision-guard extension question) RESOLVED: retain the pre-existing last-wins behavior on the JSM create path -- no guard extension; already documented (BC-3.8.008, PO-verified) -- removed from the owed-at-gate list. (4) DEC-310 REGISTERED: the PO updated all inline spec surfaces (bc-3-issue-write.md, BC-INDEX.md, CANONICAL-COUNTS.md, prd-delta-field-dx.md) from proposed to 'registered (2026-08-26, human-approved)'; state-manager completed the remaining bookkeeping surfaces across two bursts -- STATE.md Decisions Log, spec-changelog.md's [2.0.0] entry, cycles/cycle-002/burst-log.md, cycles/cycle-002/session-checkpoints.md. Both guard scripts re-verified PASS (719); no counts changed by either the DEC-310 registration or the spec-version reconciliation. Pipeline remains at F3 (incremental stories); F3 has not yet started -- ready to begin story decomposition. Full detail: cycles/cycle-002/burst-log.md Burst 8."
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
cycle_002_status: "field-dx -- ACTIVE at F3 (incremental stories, not yet started). F2 gate APPROVED by human 2026-08-26; DEC-310 REGISTERED; F-3 RESOLVED (JSM retains last-wins, no guard extension); spec version v2.0.0 (MAJOR) -- APPLIED 2026-08-26 under human delegation (DEC-188->DEC-310 reversal). See current_step + Session Resume Checkpoint."
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, spec-version-reconciliation burst):
     lines: see wc -l. soft-target 200; hard cap 500.
     This burst reconciles residual stale v1.6.0/DEFERRED/MINOR references left inside
     spec-changelog.md by the F2-gate-close burst (Burst 8) after the human delegated the
     major/minor classification call to the orchestrator, which determined MAJOR (v2.0.0).
     STATE.md changes: frontmatter version/timestamp bump, current_step and cycle_002_status
     updated to record the spec version as APPLIED (v2.0.0, MAJOR) rather than DEFERRED,
     the F2-GATE-APPROVED Phase Progress row and the "Spec version determination" Current
     Phase Step updated to APPLIED, the Session Resume Checkpoint's checklist item 5 and
     "Pending human decision" line updated, and the Drift/Standing Items entries for
     `SPEC-VERSION-DEFERRED-BY-HUMAN` / `MINOR-VS-MAJOR-SPEC-VERSION-FLAGGED` moved to
     Resolved. No new H2 sections added, one full-content Write, no Edit chain (DEC-247).
     Pre-compaction (pre-2026-08-25) full history remains at factory-artifacts commit
     43f4a5e3 and cycles/cycle-001/burst-log.md. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst -- spec-version reconciliation bookkeeping only, no develop merges) |
| **Last Updated** | SPEC-VERSION-RECONCILED (2026-08-26): trajectory-tail →1→3→0→2 (unchanged). Following the F2 human gate's four decisions (Burst 8), the human delegated the spec major/minor classification to the orchestrator, which determined **MAJOR -- v2.0.0** (DEC-188 -> DEC-310 governance-flagged reversal). This burst reconciles the residual stale v1.6.0/DEFERRED/MINOR cross-references inside `spec-changelog.md` (Type legend, Changed Requirements, Impact Assessment rows, state-manager UPDATE paragraph) that were outside the spec-steward's scope, and updates STATE.md accordingly. v3.15->v3.16. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- **Phase F3** (incremental stories), not yet started -- ready to begin story decomposition. F2 (spec evolution) is CLOSED, human-approved 2026-08-26; spec version APPLIED as v2.0.0 (MAJOR). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2/gate-close/spec-version-reconciliation were spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F2-ROUND6-FIX-CHAIN | SUPERSEDED (round-6) | 2026-08-26 | fix-chain | Sixth fresh streak -- Pass 1 NOT-CLEAN (1 MEDIUM), Pass 2+3 CLEAN. D2 create-guard count corrected 9->10 + 4 LOWs fixed. Full detail: `cycles/cycle-002/burst-log.md` Burst 6. | streak reset 0/3 |
| F2-CONVERGENCE-CLOSE (streak-6) | CONVERGED | 2026-08-26 | adversary (3 fresh diverse-lens passes) | Fresh 3-pass streak run against round-6 committed delta (b8082ba4), zero intervening fixes -- Pass 1 (correctness) CLEAN, Pass 2 (completeness) CLEAN, Pass 3 (traceability) CLEAN. Full detail: `cycles/cycle-002/burst-log.md` Burst 7. | 3/3 CONSECUTIVE CLEAN -- CONVERGED |
| F2-GATE-APPROVED | **APPROVED -> F3** | 2026-08-26 | human (F2 Step 8 gate) | Human approved the F2 gate and delivered 4 decisions: gate APPROVED; spec version v2.0.0 (MAJOR) -- applied 2026-08-26 under human delegation to the orchestrator; F-3 RESOLVED (JSM retain last-wins); DEC-310 REGISTERED. Pipeline transitions **F2 -> F3**. Full detail: `cycles/cycle-002/burst-log.md` Burst 8. | n/a -- gate decision, not an adversary pass |

## Current Phase Steps (cycle-002, phase F2->F3 transition; last 5)

| Step | Status | Notes |
|------|--------|-------|
| Human F2 gate decision (2026-08-26) | **APPROVED** | 4 decisions recorded: (1) F2 APPROVED, proceed to F3; (2) spec version -- initially deferred at the gate, then delegated to the orchestrator; (3) F-3 RESOLVED (JSM retain last-wins); (4) DEC-310 REGISTER NOW. |
| DEC-310 formal registration | **COMPLETE** | PO flipped inline spec surfaces proposed -> "registered (2026-08-26, human-approved)"; state-manager completed STATE.md Decisions Log, `spec-changelog.md` [2.0.0] entry, `cycles/cycle-002/burst-log.md`, `cycles/cycle-002/session-checkpoints.md`. |
| F-3 (JSM collision-guard extension) | **RESOLVED** | Retain the pre-existing last-wins behavior on the JSM create path -- no D2 guard extension; already documented (BC-3.8.008, PO-verified). Removed from the owed-at-gate list. |
| Spec version determination | **APPLIED -- v2.0.0 (MAJOR)** | Human initially rejected both v1.6.0 (MINOR) and v2.0.0 (MAJOR) at the gate, then delegated the classification call to the orchestrator ("use your best judgement on major or minor"). Orchestrator determined MAJOR (DEC-188->DEC-310 is a governance-flagged reversal of a shipped contract). `spec-changelog.md` header is now `[2.0.0]` (Type: MAJOR); BC-INDEX.md/CANONICAL-COUNTS.md/bc-3-issue-write.md/prd-delta-field-dx.md already carried v2.0.0; this burst reconciled spec-changelog.md's remaining stale v1.6.0/DEFERRED/MINOR cross-references. |
| Guard scripts re-verified post-spec-version-reconciliation | PASS | `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files)"). The spec-version reconciliation changed no counts. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered; propagation sweep completed 2026-08-26); **REGISTERED 2026-08-26 (human-approved at F2 gate)** | product-owner (authored); human (approved) |
| F-3 | D2 collision-guard extension to the JSM create path -- **RESOLVED: retain the pre-existing last-wins behavior**, no guard extension | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform (several flags silently IGNORED, not merged), so the platform-shaped collision does not identically arise; already documented and PO-verified | F2 | 2026-08-26 (flagged round-4 as MED-1/F-3, unchanged through streak-6; resolved at the F2 human gate) | human (decided) |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>`; § Amendment F-B: `FieldOption.id`/`.label` are `Option<String>` (never-drop invariant); § Amendment D4: non-cascading `>`-collision detected structurally + bare-form `>` is literal; § "D2 correction": create-path collision-guard governed set corrected 5->9 (round-5), then 9->10 (round-6, `--points`/`--team` are two distinct wire keys) | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; `>` avoids collision with field names; F-B closes a HIGH-risk silent-drop gap; D4 closes a structural-detection + bare-form-asymmetry gap; D2 correction closes an under-scoped guard, then a count-arithmetic error in that same fix | F1/F2 | 2026-08-25 (Accepted); § Amendment 2026-08-26 (D1/D2/D3, F-B round-3, D4 round-4, D2 correction round-5, D2 count fix round-6) | architect |
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
| (none currently open) | -- the DEC-namespace disambiguation question is tracked debt, not a hard blocker -- does not block F3 story decomposition | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): all five convergence dimensions plus Regression are PASS (MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized 2026-08-24) -- historical, unchanged this burst.

`cycle-002` (`field-dx`) F2's mandatory adversarial spec-convergence loop reached **CONVERGED** (streak-6, 3/3 consecutive clean) and the F2 human gate (Step 8) was **APPROVED** by the human on 2026-08-26, delivering four decisions: (1) gate APPROVED, pipeline transitions F2 -> F3; (2) spec version -- initially deferred at the gate (both v1.6.0 MINOR and v2.0.0 MAJOR framings rejected), then delegated to the orchestrator, which determined **MAJOR -- v2.0.0** (this burst); (3) F-3 (JSM D2 collision-guard extension) RESOLVED -- retain the pre-existing last-wins behavior, already documented (BC-3.8.008); (4) DEC-310 REGISTERED -- the PO flipped all inline spec surfaces from proposed to registered, and state-manager completed the remaining bookkeeping surfaces (STATE.md, `spec-changelog.md`, `cycles/cycle-002/burst-log.md`, `cycles/cycle-002/session-checkpoints.md`) across the gate-close and spec-version-reconciliation bursts. Both guard scripts re-verified PASS (719 total, no drift). **cycle-002 is now ACTIVE at F3** (incremental stories) -- story decomposition has not yet started.

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at **F3** -- F2 human gate APPROVED 2026-08-26 (DEC-310 registered, F-3 resolved retain-last-wins, spec version v2.0.0 MAJOR applied under human delegation); F3 (incremental stories) has not yet started. No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase **F3** (incremental stories) -- not yet started. F2 (spec evolution) is CLOSED, human-approved 2026-08-26 at the Step 8 gate; spec version APPLIED as v2.0.0 (MAJOR).

**F1:** COMPLETE + human-approved (unchanged). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2:** COMPLETE + human-approved 2026-08-26 -- 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26 D1/D2/D3 + F-B + D4 + D2 correction + D2 count fix), BC-3.8.012 reversed (governance flag **DEC-310**, now REGISTERED). Mandatory adversarial spec-convergence loop CONVERGED (streak-6, 3/3 consecutive clean). Spec version **v2.0.0 (MAJOR)**, applied 2026-08-26 under human delegation. Counts: **719 total BCs** (BC-INDEX v6.82), **32 VPs**, **106 holdout scenarios** -- all unchanged across the gate-close and spec-version-reconciliation bursts (both are bookkeeping/decision-recording only; no spec-content edits beyond the DEC-310 registration surfaces and the version-classification cross-references).

**This session's work (2026-08-26, F2 gate close + spec-version reconciliation):** the human reviewed the F2 gate (Step 8) and delivered four decisions, recorded verbatim in `cycles/cycle-002/burst-log.md` Burst 8: (1) **F2 gate APPROVED** -> proceed to F3; (2) **spec version** -- initially, at the gate, the human rejected both v1.6.0 MINOR and v2.0.0 MAJOR framings and said not to bump the version right then; the human's follow-up then delegated the major/minor classification call to the orchestrator ("go ahead and bump the spec version, use your best judgement on major or minor"), and the orchestrator determined **MAJOR -- v2.0.0** (DEC-188->DEC-310 is a governance-flagged reversal of a shipped, human-decided contract); (3) **F-3 (JSM collision-guard extension) RESOLVED** -- retain the pre-existing last-wins behavior on the JSM create path, no guard extension, already documented and PO-verified at BC-3.8.008; (4) **DEC-310 REGISTERED** -- the product-owner updated all inline spec surfaces (`bc-3-issue-write.md`, `BC-INDEX.md`, `CANONICAL-COUNTS.md`, `prd-delta-field-dx.md`) from "proposed" to "registered (2026-08-26, human-approved)"; state-manager completed the remaining bookkeeping surfaces -- STATE.md Decisions Log (this file), `spec-changelog.md`'s entry (now header `[2.0.0]`, Type: MAJOR, with all residual stale v1.6.0/DEFERRED/MINOR cross-references inside that file reconciled to v2.0.0/MAJOR this burst), `cycles/cycle-002/burst-log.md` (Burst 8), and `cycles/cycle-002/session-checkpoints.md`. Both guard scripts were re-run and PASS (719 total across 9 files, no drift -- neither the PO's DEC-310 edits nor the spec-version reconciliation changed any counts).

**Convergence counter:** RESOLVED, unchanged this burst -- F2's adversarial spec-convergence loop reached 3/3 CONSECUTIVE CLEAN (streak-6). No further adversary passes are required for F2. **ON RESUME:** begin **F3 story decomposition** -- the `vsdd-factory:decompose-stories` / `vsdd-factory:phase-f3-incremental-stories` workflow.

**Decisions of record:** DEC-310 (reverses DEC-188) -- **REGISTERED 2026-08-26, human-approved at the F2 gate.** ADR-0019 (Accepted 2026-08-25; 6 amendment rounds through round-6's D2 count fix). F-3 (D2-collision-guard-extension-to-JSM question) -- **RESOLVED 2026-08-26**, retain last-wins, no extension. Spec version -- **v2.0.0 (MAJOR), APPLIED 2026-08-26** under human delegation to the orchestrator.

**Cycle-closing checklist -- process-gap follow-ups still owed (updated this burst -- spec version determination removed, now closed):**
1. **DEC-namespace disambiguation question:** spec-authored DECs and cycle-gate DECs currently share one flat `DEC-NNN` prefix with no central registry -- the human did NOT choose a split at this gate; this remains open, tracked debt, revisit at a future cycle close.
2. **Reversal-propagation checklist** for the PO/state-manager workflow -- still not built.
3. **`COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN`** lesson from round-6 (a count-discrepancy reconciliation must re-derive the semantically correct count from the underlying distinct entities, not force consistency onto whichever number appeared first) -- candidate for a spec-authoring checklist item, not yet actioned.
4. The **4 residual LOW doc-hygiene items** from streak-6 (see Drift/Standing Items) -- non-blocking, owed before or at cycle close, do not block F3.
5. **Standing, pre-existing, NOT field-dx-scoped:** `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` -- ~145 historical stale input-hash artifacts from closed cycles remain a systemic bookkeeping-drift item across the whole factory, unrelated to the field-dx bundle; see Drift/Standing Items.

**Pending human decision:** none blocking F3 start. One item remains open for a later cycle-close touchpoint: the DEC-namespace disambiguation question. (The spec-version determination is now settled -- v2.0.0 MAJOR, applied 2026-08-26 under human delegation.)

**In flight / uncommitted at this checkpoint:** none -- `STATE.md`, `spec-changelog.md`, `cycles/cycle-002/burst-log.md`, `cycles/cycle-002/session-checkpoints.md`, `sidecar-learning.md`, and the PO's DEC-310 spec edits (`bc-3-issue-write.md`, `BC-INDEX.md`, `CANONICAL-COUNTS.md`, `prd-delta-field-dx.md`) are committed to `factory-artifacts` together as part of this session's commit.

**Resume command:** `/vsdd-factory:next-step` (proceed to F3 story decomposition).

**Superseded checkpoint:** the streak-6/convergence-close checkpoint (v3.14, 2026-08-26) is archived to `cycles/cycle-002/session-checkpoints.md`, with a superseding note recording the F2 gate's APPROVED outcome. Rounds 2-6 checkpoints and the WRAP-F2-CONVERGENCE-PAUSE checkpoint remain archived there. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1 = round-1 fresh streak; Burst 2 = round-2 fresh streak; Burst 3 = round-3 fix chain; Burst 4 = round-4 fix chain; Burst 5 = round-5 fix chain; Burst 6 = round-6 fix chain; Burst 7 = streak-6 convergence-close; Burst 8 = F2 human gate APPROVED + DEC-310 registration + F2->F3 transition) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE + F2-ROUND2-FRESH-STREAK + F2-ROUND3-FIX-CHAIN + F2-ROUND4-FIX-CHAIN + F2-ROUND5-FIX-CHAIN + F2-ROUND6-FIX-CHAIN + F2-CONVERGENCE-CLOSE-STREAK-6 archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-002 lessons learned | `cycles/cycle-002/lessons.md` (round-6's [process-gap] count-reconciliation lesson) |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**Resolved this session (2026-08-26, F2 gate close + spec-version reconciliation -- human decisions):**
- `DEC-310-FORMAL-REGISTRATION-OPEN` (was LOW/governance) -- **CLOSED**. DEC-310 REGISTERED 2026-08-26, human-approved at the F2 gate. All bookkeeping surfaces (STATE.md, `spec-changelog.md`, `cycles/cycle-002/burst-log.md`, `cycles/cycle-002/session-checkpoints.md`, plus the PO's inline spec-surface edits) reconciled.
- `D2-JSM-EXTENSION-DEFERRED` (was LOW/product-decision) -- **CLOSED (RESOLVED)**. Human decided at the F2 gate: retain the pre-existing last-wins behavior on the JSM create path, no D2 collision-guard extension. Already documented (BC-3.8.008, PO-verified).
- `MINOR-VS-MAJOR-SPEC-VERSION-FLAGGED` (was LOW/governance) -- **CLOSED**. Settled as **MAJOR (v2.0.0)**, applied 2026-08-26 under human delegation to the orchestrator.
- `SPEC-VERSION-DEFERRED-BY-HUMAN` (was LOW/governance) -- **CLOSED**. Superseded by the human's follow-up delegation of the major/minor call to the orchestrator, which determined MAJOR (v2.0.0). `spec-changelog.md`'s header is now `[2.0.0]` (Type: MAJOR); residual stale v1.6.0/DEFERRED/MINOR cross-references inside that file (Type legend, Changed Requirements bullet, Impact Assessment rows, state-manager UPDATE paragraph) were reconciled this burst.

**Resolved this session, previously (streak-6 convergence-close, unchanged from prior burst):**
- `CLEAN-STREAK-REPEATED-RESET` -- CLOSED. Streak-6 reached 3/3 CONSECUTIVE CLEAN; F2 mandatory adversarial spec-convergence CONVERGED.
- `DEC-307-TO-DEC-310-PROPAGATION-INCOMPLETE` -- CLOSED (round-6).
- `D2-CREATE-GUARD-COUNT-ARITHMETIC-ERROR` -- CLOSED (round-6, corrected to TEN across all 5 contract surfaces).

**Still open (unchanged from streak-6, LOW doc-hygiene, non-blocking -- do NOT block F3):**
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION` (LOW) -- `prd-delta-field-dx.md`'s round-2 step-2a narration is stale. Tracked for cycle close.
- `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED` (LOW) -- the platform `:asset` wire-shape carries an UNVERIFIED note. Tracked for cycle close.
- `M1-EDITMETA-STATUS-PERMISSION-CAVEAT` (LOW) -- M1 (`jr field options`)'s editmeta FALLBACK path needs an explicit status/permission-dependency caveat. Tracked for cycle close.
- `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE` (LOW) -- `prd-delta-field-dx.md`'s Summary section says "9 amended BCs" but should include BC-3.4.021/028/030. Tracked for cycle close.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry. The human did NOT choose a split at the F2 gate; remains tracked debt, revisit at a future cycle close.
- `BC-INDEX-GUARD-GAP` (LOW, unchanged) -- no automated guard ties BC-INDEX.md prose to BC-body H1/text; the specific round-3 drift instance is fixed.
- `GUARD-SCOPE-COPY-PASTE-PATTERN` (LOW/process, round-5, unchanged) -- round-5's F-NEW-1 is a guard-scope-copy-paste instance; candidate spec-authoring checklist item.
- `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` (LOW/process, round-6, unchanged) -- round-6's M-1 sibling failure mode to `GUARD-SCOPE-COPY-PASTE-PATTERN`. Logged in `cycles/cycle-002/lessons.md`.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep -- ~145 historical stale `input-hash` artifacts across closed cycles factory-wide; pre-existing systemic drift, standing debt, **not** a field-dx / cycle-002 item.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
