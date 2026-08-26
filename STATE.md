---
document_type: pipeline-state
level: ops
version: "3.10"
status: active
producer: state-manager
timestamp: 2026-08-26T17:50:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). F2-ROUND3-FIX-CHAIN (2026-08-26): a second fresh 3-pass adversary streak was run against the field-dx delta (attempt #3 overall to reach 3/3 CLEAN) -- Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, Pass 3 CLEAN (the first CLEAN verdict inside a round-2/3-attempt streak; findings continue to decay: round-1 6 MED+~9 LOW all-NOT-CLEAN -> round-2 5 MED+2 LOW all-NOT-CLEAN -> round-3 1 HIGH+3 MED+several LOW, 1/3 CLEAN). Fixed via a fix chain (architect -> PO -> verifier): F-A (HIGH) resolved a VP-578-013/BC-3.4.028-031 contradiction -- empty `:id=`/`:name=` now PASS-THROUGH (server-validated), only empty `:asset=` is a client-side structural exit-64; VP-578-013 rewritten + `prop_oneof!` extended to all four kinds. F-MED-1 pinned `parse_field_kv` as step 2a in the Platform-Path Guard Ordering SSOT (D2 collision guard renumbered 2a->2b). F-MED-2 corrected BC-X.14.001's H1 title `--type <T> --project <P>` (unbracketed) -> `--type <T> [--project <P>]` (bracketed, matching M2's flag-OR-default parity) -- state-manager propagated the matching BC-INDEX.md title-row edit this burst (the ONLY BC-INDEX content change; no count field touched). F-C added BC-3.4.031 EC-2d (`:asset=W:Y:Z` extra-colon, distinct message; \"three sub-cases\"->four), VP-578-012 aligned. F-B (architect-decided): `FieldOption.id`/`.label` changed `String`->`Option<String>` (ADR-0019 SS Amendment F-B), new never-drop invariant EC-X.14.001-7, table `\"--\"`/`\"(unnamed)\"` + JSON null rendering -- BC-X.14.001/003 amended, VP-580-005 strengthened + VP-580-008 gains (d). Several LOWs (message widening, `add:X`->`--component X` example fix, JSM cascading `>` ECs, missing-`=` EC, createmeta 400 taxonomy row, prd-delta count-narration cleanup) applied directly. NO BC change -- total_bcs stays 719 (bc-3 123/152, cross-cutting 89/155). VP total stays 30 (all four fixes -- VP-578-012, VP-578-013, VP-580-005, VP-580-008 -- are amendments to EXISTING VPs; no new VP minted). Holdouts 106 unchanged. VP-580-012's inline BC-X.14.004 declaration re-confirmed present (grep-verified, no action needed -- the verifier's earlier \"pending back-fill\" note was stale). Both guard scripts re-verified PASS post-burst. Clean-pass streak REMAINS 0/3 -- Pass 3's CLEAN verdict does not carry into a new streak attempt; the mandatory rule requires 3 CONSECUTIVE clean passes starting fresh. trajectory-tail →1→3→0→2 (unchanged). Pipeline stays ACTIVE (loop in progress). Full detail in Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE, F2 adversarial spec-convergence loop RESUMED this session (0/3 clean streak, in progress, THIRD fresh-streak attempt this session, round-3 got its first CLEAN pass mid-streak but streak did not close)); see current_step + Session Resume Checkpoint"
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, F2-ROUND3-FIX-CHAIN burst):
     182 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 182 = 18 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 182 = 318 lines of headroom remain before the hard cap of 500.
     This burst updated frontmatter (version/timestamp/current_step), added one Phase Progress
     row, added one Current Phase Steps row (archived the oldest superseded row's detail to
     burst-log Burst 3), updated the Convergence Status paragraph, and replaced the Session
     Resume Checkpoint (round-2's checkpoint archived verbatim to
     cycles/cycle-002/session-checkpoints.md) -- no new H2 sections added, one full-content
     Write, no Edit chain (DEC-247).
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
| **Last Updated** | F2-ROUND3-FIX-CHAIN (2026-08-26): a third fresh 3-pass adversary streak attempt this session -- Pass 1/2 NOT-CLEAN, Pass 3 CLEAN (first CLEAN verdict this session; findings decaying: 6 MED+~9 LOW -> 5 MED+2 LOW -> 1 HIGH+3 MED+several LOW). Fixed via architect->PO->verifier chain: F-A (HIGH) empty `:id=`/`:name=` now pass-through (only `:asset=` empty is exit-64); F-MED-1 `parse_field_kv` pinned as SSOT step 2a; F-MED-2 BC-X.14.001 H1 bracket fix + BC-INDEX.md title-row propagated by state-manager; F-C `:asset=W:Y:Z` distinct message; F-B (architect) `FieldOption.id`/`.label` -> `Option<String>` never-drop invariant. trajectory-tail →1→3→0→2 (unchanged). 719 BCs and 30 VPs unchanged (all VP fixes are amendments); 106 holdouts unchanged. Both guards re-verified PASS. Clean-streak still 0/3 (a mid-streak CLEAN pass does not persist across streak resets). v3.09->v3.10. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- Phase F2 (spec evolution), ACTIVE inside the mandatory adversarial spec-convergence loop (streak 0/3, third fresh-streak attempt this session got 1/3 CLEAN but did not close). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2 is spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F2-ADVERSARY-CONVERGENCE-RESUME | SUPERSEDED (round-1) | 2026-08-26 | fix-burst (architect->PO->verifier) | 3 fresh-context passes ALL NOT-CLEAN. 6 MEDIUM+9 LOW fixed. 719 BCs unchanged; VP 25->29; 106 holdouts unchanged. Superseded by round-2. | trajectory-tail →1→3→0→2 (unchanged); streak reset to 0/3 this burst |
| DEC-307-TO-DEC-310-PROPAGATION-SWEEP | COMPLETE | 2026-08-26 | state-manager commit | product-owner closed the owed follow-up: 35 residual DEC-307 refs corrected to DEC-310 across 6 flagged spec files. Both guards re-verified PASS (719 BCs / 29 VPs / 106 holdouts unchanged). | trajectory-tail →1→3→0→2 (unchanged); streak still 0/3 -- sweep is bookkeeping, not an adversary pass |
| F2-ROUND2-FRESH-STREAK | SUPERSEDED (round-2) | 2026-08-26 | fix-chain (PO->verifier->PO back-fill) | A second fresh 3-pass streak (post-sweep), ALL NOT-CLEAN: 5 MEDIUM+2 LOW fixed -- VP-580-006 3-bool rewrite, `:asset` cold-cache taxonomy widened to 3 call sites, new `--project` 404 row + VP-580-012 minted, `:`-split MUST, objectId ASCII-only fix, guard-ordering pin, dangling path citation fixed. 719 BCs unchanged; VP 29->30; 106 holdouts unchanged. Superseded by round-3 below. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINED 0/3 |
| F2-ROUND3-FIX-CHAIN | ACTIVE (loop in progress) | 2026-08-26 | fix-chain (architect->PO->verifier) | A THIRD fresh 3-pass streak attempt this session -- Pass 1/2 NOT-CLEAN, **Pass 3 CLEAN** (first CLEAN verdict this session). 1 HIGH+3 MEDIUM+several LOW fixed: F-A empty `:id=`/`:name=` pass-through vs `:asset=` structural exit-64 (VP-578-013 rewrite), F-MED-1 `parse_field_kv` SSOT ordering pin, F-MED-2 BC-X.14.001 H1 bracket fix + BC-INDEX.md title-row propagated, F-C `:asset=W:Y:Z` distinct message (VP-578-012 aligned), F-B (architect) `FieldOption.id`/`.label`->`Option<String>` never-drop invariant (VP-580-005/008 amended). 719 BCs unchanged; VP stays 30 (all amendments, no new VP); 106 holdouts unchanged. Both guard scripts re-verified PASS post-burst. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINS 0/3 -- mid-streak CLEAN does not persist across a streak reset |

## Current Phase Steps (cycle-002, phase F2; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F2 mandatory adversarial spec-convergence loop -- round-2 fresh streak (superseded) | SUPERSEDED | Second fresh 3-pass streak, all NOT-CLEAN (5 MED+2 LOW fixed). Full detail in `cycles/cycle-002/burst-log.md` Burst 2. Superseded by round-3 below. |
| F2 mandatory adversarial spec-convergence loop -- round-3 fix chain | ACTIVE (0/3 clean) | Third fresh-streak attempt this session: Pass 1/2 NOT-CLEAN, Pass 3 CLEAN. 1 HIGH+3 MEDIUM+several LOW fixed via architect->PO->verifier chain -- see `cycles/cycle-002/burst-log.md` Burst 3. Clean-pass streak REMAINS 0/3 -- 3 CONSECUTIVE CLEAN passes are still required before F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). |
| BC-INDEX.md BC-X.14.001 title row propagated | COMPLETE | Corrected `--type <T> --project <P>` (unbracketed) -> `--type <T> [--project <P>]` (bracketed) at BC-INDEX.md line ~861, matching the PO's already-corrected H1 in `cross-cutting.md`. Only BC-INDEX content change this burst; no count field touched. |
| VP-580-012 presence re-confirmed | COMPLETE | Grep-verified `VP-580-012` is present inline in `cross-cutting.md` under BC-X.14.004's Verification Properties list (round-2's PO back-fill). The verifier's stale "pending back-fill" note required no further action. |
| Guard scripts re-verified | PASS | `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files)"). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered; propagation sweep completed 2026-08-26) | product-owner (proposed); orchestrator/state-manager to register formally at cycle close |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>`; § Amendment F-B: `FieldOption.id`/`.label` are `Option<String>` (never-drop invariant) | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; `>` avoids collision with field names; F-B closes a HIGH-risk silent-drop gap for degenerate option entries | F1/F2 | 2026-08-25 (Accepted); § Amendment 2026-08-26 (D1/D2/D3, then F-B round-3) | architect |
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

`cycle-002` (`field-dx`) is mid F2's mandatory adversarial spec-convergence loop. After round-1 (all NOT-CLEAN, 6 MEDIUM+~9 LOW fixed), the DEC-307->DEC-310 propagation sweep, and round-2 (all NOT-CLEAN, 5 MEDIUM+2 LOW fixed), a THIRD fresh 3-pass streak was run this session -- **Pass 1 and Pass 2 returned NOT-CLEAN, but Pass 3 returned CLEAN**, the first CLEAN verdict recorded this session. Findings: 1 HIGH (F-A: VP-578-013 contradicted BC-3.4.028/029's "server is sole validator" posture for empty `:id=`/`:name=`; only `:asset=` empty is a genuine client-side structural failure) + 3 MEDIUM (F-MED-1: `parse_field_kv`'s exit-64 unpinned in the Platform-Path Guard Ordering SSOT; F-MED-2: BC-X.14.001's H1 title used an unbracketed `--project <P>` implying it was required for M2, contradicting M2's actual flag-OR-default resolution -- BC-INDEX.md's title row was out of sync and is now corrected by state-manager; F-C: BC-3.4.031's `:asset` malformed-hint catalog undercounted its own sub-cases, missing a distinct message for the extra-colon `W:Y:Z` case) + one architect-decided item (F-B: `FieldOption.id`/`.label` changed `String`->`Option<String>` for a never-drop degenerate-entry invariant) + several LOW findings (message widening, an example-syntax fix, JSM cascading edge cases, a createmeta 400 taxonomy row, prd-delta narration cleanup). All fixed via a fix chain (architect for F-B, product-owner for the BC-body propagation, verifier for the four amended-VP realizations -- VP-578-012, VP-578-013, VP-580-005, VP-580-008; no new VP minted). Counts: 719 BCs unchanged; VP total stays **30**; 106 holdouts unchanged. **Mandatory rule unchanged: 3 CONSECUTIVE clean adversary passes are still required before F2 Step 5/8 -- the streak remains 0/3.** A single CLEAN pass inside an otherwise-NOT-CLEAN streak does not count toward the 3-in-a-row requirement; the next resume must start a fresh streak at Pass 1. See Drift/Standing Items for the recurring-pattern watch item, now updated with a positive convergence signal (first CLEAN pass this session).

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at F2, adversarial spec-convergence loop in progress (streak 0/3, third fresh-streak attempt this session got its first CLEAN pass but did not close the streak). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase F2 (spec evolution), inside the MANDATORY adversarial spec-convergence loop. Pipeline ACTIVE -- loop in progress this session, not paused.

**F1:** COMPLETE + human-approved (unchanged this burst). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2 authoring:** COMPLETE (unchanged this burst) plus round-1's fix-burst amendments, the DEC propagation sweep, round-2's fix-chain, and this round's (round-3) fix chain. 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25, § Amendment 2026-08-26 D1/D2/D3 + round-3's F-B), BC-3.8.012 reversed (governance flag **DEC-310**, fully propagated). Counts: **719 total BCs** (BC-INDEX v6.82), **30 VPs** (unchanged this round -- all four round-3 VP fixes are amendments to existing VPs), **106 holdout scenarios**.

**This session's work (2026-08-26, round-3):** a third fresh 3-pass adversary streak was run against the delta (attempting the required 3/3 CLEAN) -- Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, **Pass 3 CLEAN** (the first CLEAN verdict recorded this session; findings continue to decay: round-1 6 MED+~9 LOW -> round-2 5 MED+2 LOW -> round-3 1 HIGH+3 MED+several LOW). Fixed via a fix chain: **F-A (HIGH)** resolved a contradiction where VP-578-013 §3 mandated exit-64 for ANY empty `:id=`/`:name=`/`:asset=` value, but BC-3.4.028/029 ("server is SOLE validator, ZERO client-side matching") and ADR-0019 §2(b) require empty `:id=`/`:name=` to PASS THROUGH verbatim -- new EC-3.4.028-3/EC-3.4.029-3 (pass-through), BC-3.4.031 EC-2 rescoped so ONLY `:asset=` empty is a client-side structural exit-64 (new EC-8/EC-9 cross-referencing the pass-through ECs), VP-578-013 rewritten + its `prop_oneof!` strategy extended to generate all four kinds (adds the previously-omitted `:name`) with per-kind classification. **F-MED-1** pinned `parse_field_kv`'s own exit-64 as step 2a in the Platform-Path Guard Ordering SSOT (the pre-existing D2 collision guard renumbered 2a->2b). **F-MED-2** corrected BC-X.14.001's H1 title from unbracketed `--type <T> --project <P>` to bracketed `--type <T> [--project <P>]` (matching M2's actual flag-OR-profile-default parity, ADR-0019 § Amendment D1) -- **state-manager propagated the matching BC-INDEX.md title-row edit this burst** (the ONLY BC-INDEX content change; no count field touched). **F-C** added BC-3.4.031 EC-2d (`:asset=W:Y:Z` extra-colon case, a message DISTINCT from EC-3's generic "objectId must be numeric"; catalog description corrected "three sub-cases"->"four"), VP-578-012 §2 aligned with a dedicated `"W:Y:Z"` regression pin. **F-B (architect-decided)**: `FieldOption.id`/`.label` changed `String`->`Option<String>` (a Jira option can arrive missing an id or a label on the wire) -- new never-drop invariant EC-X.14.001-7, table rendering uses `"--"` (missing id) / `"(unnamed)"` (missing label), JSON emits `null` with no substitution; BC-X.14.001/003 amended, VP-580-005 §2 strengthened (entry-count preservation + exact `None`->`null` shape + pinned table strings) and VP-580-008 gains sub-point (d). Several LOWs applied directly (message widening, `add:X`->`--component X` example fix, JSM cascading `>` edge cases, missing-`=` edge case, createmeta 400 taxonomy row, prd-delta count-narration cleanup). No BC change (719 stays). VP total stays **30** (all four fixes are amendments to existing VPs -- VP-578-012, VP-578-013, VP-580-005, VP-580-008 -- no new VP id minted). 106 holdouts unchanged. VP-580-012's inline BC-X.14.004 declaration was re-checked and confirmed present (grep-verified; the verifier's earlier note about a "pending back-fill" was stale from round-2, already closed by round-2's PO back-fill step -- no action needed this round).

**Guard scripts re-verified post-burst by state-manager:** `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). VP-total surface check: only STATE.md carries a standalone VP-count figure -- BC-INDEX.md and CANONICAL-COUNTS.md carry BC counts only (no VP-total field to update); individual `VP-NNN-NNN` citations inside BC bodies are not count surfaces.

**Convergence counter -- CRITICAL for resume:** clean-pass streak is **still 0/3** -- Pass 3's CLEAN verdict this round does NOT carry forward into a new streak attempt; the mandatory rule requires 3 CONSECUTIVE clean passes, and a streak that includes any NOT-CLEAN pass must restart at 0. This is the third consecutive fresh-streak attempt within this session's history to fail to reach 3/3 CLEAN, though this round produced the first CLEAN individual pass. **ON RESUME:** run a fresh adversary pass on the now-triply-fixed delta, starting the streak count at 0/3; do not assume convergence without three REAL, CONSECUTIVE CLEAN verdicts. Continue until achieved, then proceed to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate).

**Decisions of record:** DEC-310 (reverses DEC-188; proposed, propagation complete) -- still needs formal registration at cycle close. ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26 D1/D2/D3 + F-B).

**Process-gap follow-ups owed at cycle close:**
1. **Register DEC-310** formally (supersedes the "Register DEC-307" item -- DEC-307 turned out to already be allocated to a cycle-001 decision). Propagation of the renumber is CLOSED; only the formal registration step remains.
2. **DEC-namespace disambiguation question (still open):** spec-authored DECs (e.g. DEC-188, DEC-310) and cycle-gate DECs (e.g. DEC-309, cycle-001's F7 closure) currently share one flat `DEC-NNN` prefix with no central registry -- this is what made the DEC-307 collision possible even with a correct survey scope. Needs a cycle-close decision: split the namespaces, or stand up a single authoritative `DECISIONS-INDEX.md`.
3. No guard exists on CANONICAL-COUNTS ADR-count prose (drifted once already, fixed pass-19).
4. No guard exists on the amended-BC roster prose across its 5 surfaces (recurring stragglers, passes 12-17).
5. Need a reversal-propagation checklist for the PO/state-manager workflow -- reversing a DEC (or renumbering one) has a predictable propagation set that keeps getting missed piecemeal.
6. **DEC-survey-scope gap:** any future "next sequential DEC number" survey MUST scan the whole `.factory/` tree (STATE.md + `cycles/` included), not just `specs/`.
7. **NEW (round-3):** no guard exists tying BC-INDEX.md's title-row prose to its corresponding BC body's H1 -- this round's F-MED-2 (unbracketed vs bracketed `--project`) drifted silently between the two surfaces until an adversary pass caught it. Candidate for a future spec-guard script.

**Pending human decision:** F2 human gate (after convergence -- 3/3 clean), then F3-F7.

**In flight / uncommitted at this checkpoint:** none -- this round's touched files (`phase-f2-spec-evolution/architecture-delta-field-dx.md`, `phase-f2-spec-evolution/prd-delta-field-dx.md`, `phase-f2-spec-evolution/verification-delta-field-dx.md`, `specs/prd/bc-3-issue-write.md`, `specs/prd/cross-cutting.md`, `specs/prd/BC-INDEX.md`, `sidecar-learning.md`) and this STATE.md, plus `cycles/cycle-002/burst-log.md` and `cycles/cycle-002/session-checkpoints.md`, are committed to `factory-artifacts` together as part of this session's commit.

**Resume command:** `/vsdd-factory:next-step` (or resume the F2 adversarial convergence loop directly -- run a fresh adversary pass first, starting the streak count at 0/3; do not assume the prior round's CLEAN pass carries forward).

**Superseded checkpoint:** the round-2 fresh-streak checkpoint (v3.09, 2026-08-26) is archived verbatim to `cycles/cycle-002/session-checkpoints.md`. The round-1 fresh-streak checkpoint (v3.08, 2026-08-26) and the WRAP-F2-CONVERGENCE-PAUSE checkpoint (v3.06, 2026-08-26) remain archived there. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1 = round-1 fresh streak; Burst 2 = round-2 fresh streak; Burst 3 = round-3 fix chain) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE + F2-ROUND2-FRESH-STREAK archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**Resolved this session (2026-08-26):**
- `DEC-307-TO-DEC-310-PROPAGATION-INCOMPLETE` (was MEDIUM) -- CLOSED. product-owner corrected the 35 residual `DEC-307` occurrences across the 6 flagged files; guards re-verified PASS.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry; this is what allowed the DEC-307 collision. See Session Resume Checkpoint process-gap follow-up #2.
- `CLEAN-STREAK-REPEATED-RESET` (WATCH, observational) -- this is now the THIRD consecutive fresh-streak attempt within this session where the F2 convergence streak failed to reach 3/3 CLEAN, but round-3 produced the first individual CLEAN pass recorded this session (Pass 3), and finding severity/volume has shrunk each round (round-1: 6 MED+~9 LOW; round-2: 5 MED+2 LOW; round-3: 1 HIGH+3 MED+several LOW, with 1/3 passes clean). The "frozen delta" framing between attempts continues to be unreliable in practice; each resume should default-assume un-converged until a fresh pass proves otherwise. Treat the appearance of a CLEAN pass as a positive signal that convergence may be close, not as partial credit toward the 3-in-a-row requirement.
- `BC-INDEX-TITLE-ROW-DRIFT-RISK` (NEW, LOW, round-3) -- BC-X.14.001's title row drifted out of sync with its BC body's H1 (F-MED-2) until an adversary pass caught it; no automated guard ties BC-INDEX.md prose to BC-body H1 text. See Session Resume Checkpoint process-gap follow-up #7.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
