---
document_type: pipeline-state
level: ops
version: "3.13"
status: active
producer: state-manager
timestamp: 2026-08-26T21:07:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). F2-ROUND6-FIX-CHAIN (2026-08-26): a SIXTH fresh 3-pass adversary streak was run against the field-dx delta -- Pass 1 NOT-CLEAN (one genuine MEDIUM), Pass 2 CLEAN, Pass 3 CLEAN (the first time in this session that TWO passes in one streak came back clean -- the delta's defect surface is at the floor). Fixed via a fix chain (architect + product-owner + verifier, run in parallel on disjoint files): M-1 (MEDIUM) corrected a count-arithmetic contradiction in round-5's own D2 create-path collision-guard fix -- round-5 reported the governed set as \"nine\" wire-key targets, but `--points`->story_points customfield id and `--team`->team customfield id are TWO DISTINCT `customfield_NNNNN` wire keys, wrongly collapsed into one \"resolved-id category\" by round-5 to force the total to read nine. Corrected to TEN = 5 original + 3 static (`labels`/`parent`/`assignee`) + 2 distinct resolved-id keys, propagated consistently across ADR-0019 § \"D2 correction\" (rows 9a/9b split into distinct rows 9/10), `architecture-delta-field-dx.md` §9, `bc-3-issue-write.md` (10 sites: BC-3.3.010 Invariant 5/EC-3.3.010-6a, BC-3.3.011 error-taxonomy, BC-3.4.014/017/029), and VP-578-021 (property 2 = 8 static cases, property 3 = 2 separate resolved-id cases, negative regression pin retained; also fixed a latent 5+4+2=11 scratch-math error found alongside). Grep-verified: all active contract surfaces now say TEN; remaining \"nine\" strings are intentional correction-narration only. 4 LOWs folded in: BC-3.8.008 EC-3.8.008-3 (JSM malformed `--field` hint exit-64-pre-POST, now explicitly pinned); BC-X.14.001 gains an M1-vs-M3 field-set divergence caveat; BC-3.4.021 Invariant 1 gains an F-NEW-2 exception qualifier (round-5's dry-run wire-shape pin is an exception, not an extension); VP-578-005 gains a colon-in-field-name coverage note (verifier). NO BC change -- total_bcs stays 719 (bc-3 123/152, cross-cutting 89/155). VP total stays **32** (VP-578-021 amended, not newly minted -- no new VP id this round). Holdouts 106 unchanged. Both guard scripts re-verified PASS post-burst. Clean-pass streak REMAINS 0/3 -- Pass 1's NOT-CLEAN verdict resets the streak even though Passes 2 and 3 were both CLEAN; the mandatory rule requires 3 CONSECUTIVE clean passes starting fresh. trajectory-tail →1→3→0→2 (unchanged). Pipeline stays ACTIVE (loop in progress). Full detail in Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE, F2 adversarial spec-convergence loop RESUMED this session (0/3 clean streak, in progress, SIXTH fresh-streak attempt this session, round-6 got TWO clean passes (Pass 2 + Pass 3) -- the first time this session -- but Pass 1's one genuine MEDIUM still reset the streak); see current_step + Session Resume Checkpoint"
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, F2-ROUND6-FIX-CHAIN burst):
     194 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 194 = 6 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 194 = 306 lines of headroom remain before the hard cap of 500.
     This burst updated frontmatter (version/timestamp/current_step/cycle_002_status), superseded
     the round-5 Phase Progress row and added a round-6 row, refreshed Current Phase Steps (last 5
     rows, older detail archived to burst-log Burst 6), updated the Convergence Status paragraph,
     and replaced the Session Resume Checkpoint (round-5's checkpoint archived to
     cycles/cycle-002/session-checkpoints.md, along with a reconstructed round-4 checkpoint that
     had been missing from that file despite a prior claim it was archived -- flagged, not
     otherwise investigated, out of scope for this focused burst) -- no new H2 sections added,
     one full-content Write, no Edit chain (DEC-247).
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
| **Last Updated** | F2-ROUND6-FIX-CHAIN (2026-08-26): a sixth fresh 3-pass adversary streak attempt this session -- Pass 1 NOT-CLEAN (one genuine MEDIUM), Pass 2 CLEAN, Pass 3 CLEAN (first time two passes in one streak came back clean this session). Fixed via architect+PO+verifier fix chain (parallel, disjoint files): M-1 corrected round-5's own D2 create-path collision-guard count from a wrongly-collapsed "nine" to the arithmetically correct TEN (`--points`/`--team` are two distinct wire keys, not one); propagated across ADR-0019, architecture-delta, bc-3-issue-write.md (10 sites), VP-578-021. 4 LOWs folded in (BC-3.8.008 EC pin, BC-X.14.001 M1-vs-M3 caveat, BC-3.4.021 exception qualifier, VP-578-005 coverage note). trajectory-tail →1→3→0→2 (unchanged). 719 BCs unchanged; VP stays 32 (amendment only, no new id); 106 holdouts unchanged. Both guards re-verified PASS. Clean-streak still 0/3 (one NOT-CLEAN pass resets the streak regardless of how many CLEAN passes surround it). v3.12->v3.13. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- Phase F2 (spec evolution), ACTIVE inside the mandatory adversarial spec-convergence loop (streak 0/3, sixth fresh-streak attempt this session got 2/3 CLEAN passes but did not close -- Pass 1's MEDIUM reset it). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2 is spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F2-ROUND4-FIX-CHAIN | SUPERSEDED (round-4) | 2026-08-26 | fix-chain (architect->PO->verifier->PO) | A FOURTH fresh 3-pass streak attempt, run alongside a consistency-validator sweep -- Pass 1/2 NOT-CLEAN, Pass 3 CLEAN (second round in a row with a CLEAN pass). 5 MEDIUM-class+several LOW fixed: platform-vs-JSM D2 guard scope explicit, BC-INDEX.md prose fixed, VP-578-013 per-kind split, `--value` filter x `Option<String>` reconciled, non-cascading `>`-collision + bare-form literal (VP-578-023 minted). 719 BCs unchanged; VP 30->31; 106 holdouts unchanged. Superseded by round-5. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINED 0/3 -- mid-streak CLEAN does not persist across a streak reset |
| F2-ROUND5-FIX-CHAIN | SUPERSEDED (round-5) | 2026-08-26 | fix-chain (architect->PO->verifier->consistency-sweep->PO) | A FIFTH fresh 3-pass streak attempt -- Pass 1/2 NOT-CLEAN, Pass 3 CLEAN (third round in a row -- rounds 3/4/5 -- with a CLEAN pass; no HIGH/CRITICAL since round-3). 4 MEDIUM-class+several LOW fixed, all propagation-stragglers/peripheral-seam gaps: F-NEW-1 create-path D2 collision-guard governed set corrected 5->9 (later found itself wrong -- see round-6); F-NEW-2 dry-run per-kind wire-shape pinned (VP-578-024 minted); MED-1 VP-578-013 EC-2d miscitation fixed; MED-2 VP-578-023 back-fill reconciled. 719 BCs unchanged; VP 31->32; 106 holdouts unchanged. Superseded by round-6 below. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINED 0/3 |
| F2-ROUND6-FIX-CHAIN | ACTIVE (loop in progress) | 2026-08-26 | fix-chain (architect+PO+verifier, parallel/disjoint) | A SIXTH fresh 3-pass streak attempt -- Pass 1 NOT-CLEAN (one genuine MEDIUM), **Pass 2 CLEAN, Pass 3 CLEAN** (first time this session two passes in one streak came back clean). M-1 (MEDIUM) corrected round-5's own D2 create-path collision-guard count 9->10 (arithmetic error: `--points`/`--team` are two distinct wire keys, round-5 had wrongly collapsed them into one to force "nine"); propagated across ADR-0019, architecture-delta §9, bc-3-issue-write.md (10 sites), VP-578-021 (property 2/3 split). 4 LOWs folded in. 719 BCs unchanged; VP stays 32 (amendment, no new id); 106 holdouts unchanged. Both guard scripts re-verified PASS post-burst. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINS 0/3 -- one NOT-CLEAN pass resets the streak regardless of surrounding CLEAN passes |

## Current Phase Steps (cycle-002, phase F2; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F2 mandatory adversarial spec-convergence loop -- round-5 fix chain (superseded) | SUPERSEDED | Fifth fresh 3-pass streak, Pass 3 CLEAN but streak did not close (4 MEDIUM-class+LOWs fixed, including a count error later found wrong in round-6). Full detail in `cycles/cycle-002/burst-log.md` Burst 5. Superseded by round-6 below. |
| F2 mandatory adversarial spec-convergence loop -- round-6 fix chain | ACTIVE (0/3 clean) | Sixth fresh-streak attempt: Pass 1 NOT-CLEAN (one genuine MEDIUM), Pass 2 CLEAN, Pass 3 CLEAN -- first two-clean-pass streak this session. M-1 + 4 LOWs fixed via a parallel architect+PO+verifier fix chain on disjoint files -- see `cycles/cycle-002/burst-log.md` Burst 6. Clean-pass streak REMAINS 0/3 -- 3 CONSECUTIVE CLEAN passes are still required before F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). |
| D2 create-path collision-guard governed set corrected 9->10 (M-1) | COMPLETE | ADR-0019 § "D2 correction" amended: round-5's "nine"-member set had wrongly collapsed `--points`/`--team` into one "resolved-id category" -- they are two distinct `customfield_NNNNN` wire keys. Corrected to 5 original + 3 static (`labels`/`parent`/`assignee`) + 2 distinct resolved-id keys = 10. Propagated to BC-3.3.010/011, BC-3.4.014/017/029; VP-578-021 property 2/3 split (no new VP). |
| VP total confirmed unchanged at 32 | COMPLETE | VP-578-021 was amended (property 2/3 split to reflect the 10-member set), not newly minted -- no new VP id this round. Grep-confirmed VP-578-001..024 (24 ids) + VP-580-005..012 (8 ids) = 32, same as after round-5. Only STATE.md carries a standalone VP-total surface. |
| Guard scripts re-verified | PASS | `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered; propagation sweep completed 2026-08-26) | product-owner (proposed); orchestrator/state-manager to register formally at cycle close |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>`; § Amendment F-B: `FieldOption.id`/`.label` are `Option<String>` (never-drop invariant); § Amendment D4: non-cascading `>`-collision detected structurally + bare-form `>` is literal; § "D2 correction": create-path collision-guard governed set corrected 5->9 (round-5), then 9->10 (round-6, `--points`/`--team` are two distinct wire keys) | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; `>` avoids collision with field names; F-B closes a HIGH-risk silent-drop gap; D4 closes a structural-detection + bare-form-asymmetry gap; D2 correction closes an under-scoped guard, then a count-arithmetic error in that same fix | F1/F2 | 2026-08-25 (Accepted); § Amendment 2026-08-26 (D1/D2/D3, F-B round-3, D4 round-4, D2 correction round-5, D2 count fix round-6) | architect |
| (pending) | D2 collision-guard extension to the JSM create path (dedicated flags that ARE merged onto the wire: `--summary`/`--description`/`--priority`/`--label`) -- DEFERRED, not decided either way | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform (several flags silently IGNORED, not merged) so the platform-shaped collision does not identically arise; needs explicit product judgment | F2 | 2026-08-26 (flagged round-4, MED-1/F-3; unchanged round-5/round-6) | owed at F2 human gate |
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
| (none currently open) | -- the DEC-namespace disambiguation question, formal DEC-310 registration, and the DEFERRED D2-extension-to-JSM product decision (F-3, round-4) are tracked debt, not hard blockers -- they must close before F2 Step 5/cycle close but do not block resuming the adversary loop | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): all five convergence dimensions plus Regression are PASS (MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized 2026-08-24) -- historical, unchanged this burst.

`cycle-002` (`field-dx`) is mid F2's mandatory adversarial spec-convergence loop. After round-1 (all NOT-CLEAN, 6 MEDIUM+~9 LOW fixed), the DEC-307->DEC-310 propagation sweep, round-2 (all NOT-CLEAN, 5 MEDIUM+2 LOW fixed), round-3 (1 HIGH+3 MEDIUM+several LOW fixed, Pass 3 CLEAN), round-4 (5 MEDIUM-class+several LOW fixed, Pass 3 CLEAN), and round-5 (4 MEDIUM-class+several LOW fixed, Pass 3 CLEAN), a SIXTH fresh 3-pass streak was run this session -- **Pass 1 returned NOT-CLEAN with one genuine MEDIUM, but Pass 2 AND Pass 3 both returned CLEAN**, the first time in this session's history that two passes within the same streak came back clean. The single MEDIUM was itself a count-arithmetic contradiction discovered in round-5's own fix: M-1 found that round-5's D2 create-path collision-guard governed set, reported as "nine" wire-key targets, was arithmetically wrong -- `--points`->story_points customfield id and `--team`->team customfield id are TWO DISTINCT `customfield_NNNNN` wire keys, which round-5 had wrongly collapsed into one "resolved-id category" to force the total to read nine. Corrected to TEN = 5 original + 3 static (`labels`/`parent`/`assignee`) + 2 distinct resolved-id keys, propagated consistently across ADR-0019 § "D2 correction" (rows 9a/9b split into distinct rows 9/10), `architecture-delta-field-dx.md` §9, `bc-3-issue-write.md` (10 sites: BC-3.3.010 Invariant 5/EC-3.3.010-6a, BC-3.3.011's error-taxonomy, BC-3.4.014/017/029), and VP-578-021 (property 2 = 8 static-key cases, property 3 = 2 separate resolved-id cases rather than one merged case, negative regression pin retained; a latent 5+4+2=11 scratch-math error was also fixed alongside). Grep-verified: every active contract surface now says TEN; the only remaining "nine" strings are intentional correction-narration (this round's and round-5's own historical prose), not live counts. 4 LOWs were folded in alongside M-1: BC-3.8.008 EC-3.8.008-3 (JSM malformed `--field` hint exits 64 pre-POST, now explicitly pinned), BC-X.14.001 (gains a caveat distinguishing M1's field set from M3's, previously unremarked), BC-3.4.021 Invariant 1 (gains an explicit F-NEW-2 exception qualifier -- round-5's dry-run wire-shape pin is an exception to the general invariant, not an extension of it), and VP-578-005 (gains a coverage note for the colon-in-field-name case, closing a silent gap Pass 1 also flagged). Fixed via a fix chain run in parallel on disjoint files this round (architect + product-owner + verifier, rather than the strictly sequential architect->PO->verifier chain of prior rounds), then reconciled by state-manager. Counts: 719 BCs unchanged; VP total stays **32** (VP-578-021 amended, not newly minted -- no new id this round); 106 holdouts unchanged. **Mandatory rule unchanged: 3 CONSECUTIVE clean adversary passes are still required before F2 Step 5/8 -- the streak remains 0/3.** A single NOT-CLEAN pass resets the streak regardless of how many CLEAN passes surround it -- the next resume must start a fresh streak at Pass 1. This round's trajectory is a strong positive signal (2 of 3 passes clean, the delta's defect surface reads as near the floor -- only a count-arithmetic slip from the prior round's own fix broke it), logged as a [process-gap] lesson in `cycles/cycle-002/lessons.md`: a count-discrepancy reconciliation must verify the semantically correct count, not force consistency onto whichever number appeared first.

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at F2, adversarial spec-convergence loop in progress (streak 0/3, sixth fresh-streak attempt this session got two clean passes (2 & 3) but did not close the streak). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase F2 (spec evolution), inside the MANDATORY adversarial spec-convergence loop. Pipeline ACTIVE -- loop in progress this session, not paused.

**F1:** COMPLETE + human-approved (unchanged this burst). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2 authoring:** COMPLETE (unchanged this burst) plus round-1's fix-burst amendments, the DEC propagation sweep, round-2's fix-chain, round-3's fix chain, round-4's fix chain, round-5's fix chain, and this round's (round-6) fix chain. 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25, § Amendment 2026-08-26 D1/D2/D3 + round-3's F-B + round-4's D4 + round-5's D2 correction + round-6's D2 count fix), BC-3.8.012 reversed (governance flag **DEC-310**, fully propagated). Counts: **719 total BCs** (BC-INDEX v6.82), **32 VPs** (unchanged this round -- VP-578-021 amended, not newly minted), **106 holdout scenarios**.

**This session's work (2026-08-26, round-6):** a sixth fresh 3-pass adversary streak was run against the delta (attempting the required 3/3 CLEAN) -- Pass 1 NOT-CLEAN (one genuine MEDIUM), **Pass 2 CLEAN, Pass 3 CLEAN** (the first round in this session where two passes within the same streak both came back clean; no HIGH/CRITICAL findings, consistent with rounds 4/5). Fixed via a fix chain (architect + product-owner + verifier dispatched in PARALLEL on disjoint files, a change from the strictly sequential chain used in rounds 3-5, since M-1's fix required no cross-agent dependency): **M-1** (MEDIUM, architect-decided count correction): round-5's D2 create-path collision-guard fix (F-NEW-1) had corrected the governed set from 5 to what it called a "nine"-member set, but that arithmetic was itself wrong. `--points` resolves to the story-points customfield id and `--team` resolves to the team customfield id -- these are TWO DISTINCT `customfield_NNNNN` wire keys, not interchangeable, and round-5 had wrongly collapsed them into a single "resolved-id category" specifically to make the total read "nine" (matching a prior round-5 narrative expectation) rather than deriving the count from the actual distinct entities being guarded. ADR-0019's "D2 correction" section is amended: the create-path governed set is corrected to **TEN** wire-key targets -- 5 original (`summary`/`description`/`issuetype`/`priority`/`components`) + 3 static keys (`labels`/`parent`/`assignee`, zero-HTTP, unchanged from round-5) + 2 SEPARATE resolved-id keys (`--points`->story-points customfield id, `--team`->team customfield id; both detected ONLY via the `--field customfield_NNNNN=` bypass form, never a human display name -- the same documented, bounded residual from round-5 still applies to each independently). Rows 9a/9b in ADR-0019's enumeration are split into distinct rows 9 (`--points`) and 10 (`--team`). Propagated to: `architecture-delta-field-dx.md` §9 (mirrors the ADR split); `bc-3-issue-write.md` at all 10 sites -- BC-3.3.010 Invariant 5 + EC-3.3.010-6a (full 10-member enumeration), BC-3.3.011's error-taxonomy row, BC-3.4.014/017/029 (arithmetic and enumeration corrected everywhere "nine"/"5+3+1" was cited); and `verification-delta-field-dx.md`'s VP-578-021, which is EXTENDED (not newly minted) -- its "property 2" now covers the 8 static-flag cases (5 original zero-HTTP fields + 3 new static keys) and a new, separate "property 3" covers the 2 resolved-id cases individually (`--points` collision, `--team` collision) rather than one merged case; the existing negative regression pin (`--points 5 --field "Story Points"=8` does NOT trip the guard) is retained unchanged, since it was already correctly scoped to the bypass-form residual. Alongside this fix, the verifier found and corrected a latent, unrelated scratch-arithmetic error in the verification-delta's own working notes (a stray "5+4+2=11" that should have read the corrected count) -- fixed in the same pass. All active contract surfaces were grep-verified to say TEN after propagation; any surviving "nine" string is confirmed to be intentional round-5/round-6 correction-narration prose, not a live count. **4 LOWs folded into the same fix-chain pass:** (1) BC-3.8.008 gains explicit EC-3.8.008-3, pinning that a malformed `--field` hint on the JSM create path exits 64 before any POST is attempted (previously implied by the general malformed-hint rule but not spelled out for the JSM fork specifically); (2) BC-X.14.001 gains a caveat noting that M1 (`jr field options`)'s field set and M3 (`jr requesttype fields`)'s field set diverge and should not be assumed identical -- previously unremarked, flagged by Pass 1; (3) BC-3.4.021 Invariant 1 gains an explicit qualifier that round-5's F-NEW-2 dry-run wire-shape pin is an EXCEPTION to the general invariant (the invariant states plannedChanges never triggers a live write; F-NEW-2 clarifies plannedChanges' CONTENT mirrors the wire shape without contradicting that) rather than reading as an unexplained extension; (4) VP-578-005 (verifier-authored) gains a coverage note documenting the colon-in-field-name case explicitly, closing a silent gap Pass 1 also independently flagged. No BC change (719 stays). VP total **stays 32** (no new id minted this round -- VP-578-021's amendment is a scope correction, not a new property). 106 holdouts unchanged.

**Guard scripts re-verified post-burst by state-manager:** `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). VP-total surface check: only STATE.md carries a standalone VP-count figure -- BC-INDEX.md and CANONICAL-COUNTS.md carry BC counts only (no VP-total field to update); individual `VP-NNN-NNN` citations inside BC bodies are not count surfaces; no VP-total edit was needed anywhere this round since the count itself did not change (32 -> 32).

**Convergence counter -- CRITICAL for resume:** clean-pass streak is **still 0/3** -- Pass 2 and Pass 3's CLEAN verdicts this round do NOT carry forward into a new streak attempt, because Pass 1 was NOT-CLEAN; the mandatory rule requires 3 CONSECUTIVE clean passes, and a streak that includes any NOT-CLEAN pass must restart at 0. This is the sixth consecutive fresh-streak attempt within this session's history to fail to reach 3/3 CLEAN, but it is the FIRST round where two passes within one streak (Pass 2 and Pass 3) both came back CLEAN, and no HIGH/CRITICAL finding has surfaced since round-3. **ON RESUME:** run a fresh adversary pass on the now-sextuply-fixed delta, starting the streak count at 0/3; do not assume convergence without three REAL, CONSECUTIVE CLEAN verdicts -- and do not assume that a fix from a PRIOR round (like round-5's D2 correction) is itself correct without independent re-derivation, per this round's process-gap lesson. Continue until achieved, then proceed to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate).

**Decisions of record:** DEC-310 (reverses DEC-188; proposed, propagation complete) -- still needs formal registration at cycle close. ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26 D1/D2/D3 + F-B + D4 + D2 correction + D2 count fix). UNCHANGED this round: the D2-collision-guard-extension-to-JSM question (F-3, round-4) remains DEFERRED, owed as a product decision at the F2 human gate -- see Decisions Log's `(pending)` row.

**Process-gap follow-ups owed at cycle close:**
1. **Register DEC-310** formally (supersedes the "Register DEC-307" item). Propagation of the renumber is CLOSED; only the formal registration step remains.
2. **DEC-namespace disambiguation question (still open):** spec-authored DECs and cycle-gate DECs currently share one flat `DEC-NNN` prefix with no central registry. Needs a cycle-close decision: split the namespaces, or stand up a single authoritative `DECISIONS-INDEX.md`.
3. No guard exists on CANONICAL-COUNTS ADR-count prose (drifted once already, fixed pass-19).
4. No guard exists on the amended-BC roster prose across its 5 surfaces (recurring stragglers, passes 12-17).
5. Need a reversal-propagation checklist for the PO/state-manager workflow.
6. **DEC-survey-scope gap:** any future "next sequential DEC number" survey MUST scan the whole `.factory/` tree, not just `specs/`.
7. No guard exists tying BC-INDEX.md's title-row prose to its corresponding BC body's H1 -- round-3's F-MED-2 drifted silently until an adversary pass caught it. Candidate for a future spec-guard script.
8. D2-collision-guard extension to the JSM create path (F-3, round-4) is a DEFERRED product decision, owed at the F2 human gate -- extending platform's "same wire key, two sources" collision guard to JSM's dedicated flags that ARE wire-merged (`--summary`/`--description`/`--priority`/`--label`).
9. The repeated pattern of "a guard/rule's own scope is under-derived from first principles and instead copy-pasted from a sibling guard" (round-5's F-NEW-1) is a candidate for an explicit spec-authoring checklist item.
10. **NEW (round-6):** a sibling failure mode to #9 -- "a count-discrepancy reconciliation forces consistency onto whichever number appeared first, instead of re-deriving the semantically correct count from the underlying distinct entities" (M-1: round-5 collapsed `--points`/`--team` into one category to preserve a prior "nine" narrative). Logged as a [process-gap] lesson in `cycles/cycle-002/lessons.md`; candidate for the same future spec-authoring checklist item as #9.

**Pending human decision:** F2 human gate (after convergence -- 3/3 clean); will also need to decide item #8 above (D2-extension-to-JSM). Then F3-F7.

**In flight / uncommitted at this checkpoint:** none -- this round's touched files (`phase-f2-spec-evolution/architecture-delta-field-dx.md`, `phase-f2-spec-evolution/prd-delta-field-dx.md`, `phase-f2-spec-evolution/verification-delta-field-dx.md`, `specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md`, `specs/prd/bc-3-issue-write.md`, `specs/prd/cross-cutting.md`, `sidecar-learning.md`) and this STATE.md, plus `cycles/cycle-002/burst-log.md`, `cycles/cycle-002/lessons.md` (new), and `cycles/cycle-002/session-checkpoints.md`, are committed to `factory-artifacts` together as part of this session's commit.

**Resume command:** `/vsdd-factory:next-step` (or resume the F2 adversarial convergence loop directly -- run a fresh adversary pass first, starting the streak count at 0/3; do not assume the prior round's clean passes carry forward).

**Superseded checkpoint:** the round-5 fresh-streak checkpoint (v3.12, 2026-08-26) is archived to `cycles/cycle-002/session-checkpoints.md`. This round also reconstructed and archived a round-4 checkpoint entry there that had been missing from that file (a pre-existing gap from a prior burst, flagged but not otherwise investigated). The round-3 checkpoint (v3.10), round-2 checkpoint (v3.09), round-1 checkpoint (v3.08), and the WRAP-F2-CONVERGENCE-PAUSE checkpoint (v3.06) remain archived there. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1 = round-1 fresh streak; Burst 2 = round-2 fresh streak; Burst 3 = round-3 fix chain; Burst 4 = round-4 fix chain; Burst 5 = round-5 fix chain; Burst 6 = round-6 fix chain) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE + F2-ROUND2-FRESH-STREAK + F2-ROUND3-FIX-CHAIN + F2-ROUND4-FIX-CHAIN + F2-ROUND5-FIX-CHAIN archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-002 lessons learned | `cycles/cycle-002/lessons.md` (new this round -- round-6's [process-gap] count-reconciliation lesson) |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**Resolved this session (2026-08-26):**
- `DEC-307-TO-DEC-310-PROPAGATION-INCOMPLETE` (was MEDIUM) -- CLOSED. product-owner corrected the 35 residual `DEC-307` occurrences across the 6 flagged files; guards re-verified PASS.
- `BC-INDEX-TITLE-ROW-DRIFT-RISK` (was LOW) -- the specific instance (BC-X.14.001's stale companion-flag arity prose) was corrected round-4 (MED-2). The underlying guard gap (no automated check tying BC-INDEX.md prose to BC-body H1/text) remains open -- see process-gap follow-up #7.
- `VP-578-023-BACKFILL-STALE-CLAIM` (LOW, round-5) -- CLOSED. The verification-delta's "sole pending back-fill" claim was stale (the product-owner had already back-filled BC-3.4.015 round-4); reconciled by round-5's consistency-sweep + product-owner wording fix (MED-2).
- `D2-CREATE-GUARD-COUNT-ARITHMETIC-ERROR` (MEDIUM, round-6) -- CLOSED. Round-5's D2 create-path collision-guard governed set was reported as "nine," but `--points`/`--team` are two distinct wire keys, not one collapsed category; corrected to TEN across all 5 contract surfaces. See process-gap follow-up #10.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry. See Session Resume Checkpoint process-gap follow-up #2.
- `CLEAN-STREAK-REPEATED-RESET` (WATCH, observational) -- this is now the SIXTH consecutive fresh-streak attempt within this session where the F2 convergence streak failed to reach 3/3 CLEAN, but rounds 3, 4, AND 5 each produced an individual CLEAN pass (Pass 3 every time), and round-6 is the first round where TWO passes (Pass 2 and Pass 3) in the same streak came back CLEAN -- a stronger positive signal than any prior round. No HIGH/CRITICAL finding has surfaced since round-3; findings remain propagation-stragglers/peripheral-seam gaps (round-6's M-1 being a count-arithmetic slip in a PRIOR round's own fix, not a newly-discovered defect class). Each resume should still default-assume un-converged until a fresh pass proves otherwise.
- `BC-INDEX-GUARD-GAP` (LOW, unchanged) -- no automated guard ties BC-INDEX.md prose to BC-body H1/text; the specific round-3 drift instance is fixed (see Resolved above) but the class of defect remains possible. See process-gap follow-up #7.
- `D2-JSM-EXTENSION-DEFERRED` (LOW/product-decision, round-4, unchanged round-5/round-6) -- MED-1/F-3 flagged extending the D2 collision guard to JSM's wire-merged dedicated flags as an open product decision, not yet made either way. Owed at the F2 human gate. See process-gap follow-up #8.
- `GUARD-SCOPE-COPY-PASTE-PATTERN` (LOW/process, round-5, unchanged round-6) -- round-5's F-NEW-1 is the second instance within this delta of a guard's scope being copy-pasted from a sibling site rather than re-derived from first principles for its own call site. Candidate spec-authoring checklist item. See process-gap follow-up #9.
- `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` (NEW, LOW/process, round-6) -- round-6's M-1 is a sibling failure mode to `GUARD-SCOPE-COPY-PASTE-PATTERN`: a count-discrepancy reconciliation forced consistency onto a prior round's cited number ("nine") instead of re-deriving the semantically correct count from the underlying distinct entities (the actual answer was ten). Logged as a [process-gap] lesson in `cycles/cycle-002/lessons.md`. See process-gap follow-up #10.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
