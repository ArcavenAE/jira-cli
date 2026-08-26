---
document_type: pipeline-state
level: ops
version: "3.12"
status: active
producer: state-manager
timestamp: 2026-08-26T20:22:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). F2-ROUND5-FIX-CHAIN (2026-08-26): a FIFTH fresh 3-pass adversary streak was run against the field-dx delta (attempt #5 overall to reach 3/3 CLEAN) -- Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, Pass 3 CLEAN (the third round in a row -- rounds 3, 4, 5 -- to produce at least one CLEAN pass; no HIGH/CRITICAL findings, same as round-4; findings are now propagation-stragglers/peripheral-seam gaps in this session's own D1/D2/D3/D4 fixes, not new defect classes). Fixed via a fix chain (architect for the D2 correction -> product-owner -> verifier -> consistency-sweep -> product-owner for 2 tiny wording fixes): F-NEW-1 (MED) corrected the create-path D2 collision-guard governed set from 5 to 9 wire-key targets -- the original execution reused Gate B's five-member EDIT-derived set verbatim instead of re-deriving `issue create`'s own larger dedicated-flag surface (`--label`/`--team`/`--points`/`--parent`/`--to`/`--account-id` were all silently unguarded); corrected set = 5 original + 3 new static keys (`labels`/`parent`/`assignee`, zero-HTTP) + 1 resolved-id category (`--points`/`--team`, detected ONLY via the `--field customfield_NNNNN=` bypass form, never a display name); `labels` governed on CREATE but stays excluded on EDIT (BUG-LABEL-400 fork, documented per-path exception). Propagated to ADR-0019 (new SS \"D2 correction (adversary F-NEW-1)\"), BC-3.3.010/011, BC-3.4.014/017/029; VP-578-021 EXTENDED (not newly minted) with the 4 new static-flag cases + 2 resolved-id cases + a negative regression pin. F-NEW-2 (MED) pinned `--field` hint-kind x `issue edit --dry-run` preview shape across BC-3.4.021/027/028/029/030 (plannedChanges mirrors the live PUT wire object per kind, never the bare-form display string, PUT never called) -- new VP-578-024 minted, replacing the PO's VP-DRY-RUN-005 placeholder, also covering the `:asset` cold-cache dry-run side-effect exit-64-before-preview case. MED-1 fixed a miscitation: VP-578-013's enumeration had drifted to cite \"EC-2d,\" which belongs exclusively to VP-578-012, not VP-578-013 -- corrected to the accurate EC-2a/b/c set. MED-2: VP-578-023's inline BC-body anchor confirmed back-filled at BOTH sites (BC-3.4.027 + BC-3.4.015) -- the verification-delta's stale \"pending back-fill\" claim was reconciled (caught by the round's consistency-sweep), related_bcs gained BC-3.4.015/BC-3.4.021. LOWs: M2 sub-headings bracketed (parity with M3), a stale changelog line converted to a resolution-pointer, the round-4 \"four vs three new static keys\" count slip reconciled to the correct 9 = 5+3+1 arithmetic everywhere. NO BC change -- total_bcs stays 719 (bc-3 123/152, cross-cutting 89/155). VP total **31 -> 32** (VP-578-024 newly minted; VP-578-001..024 = 24 + VP-580-005..012 = 8). Holdouts 106 unchanged. Both guard scripts re-verified PASS post-burst. Clean-pass streak REMAINS 0/3 -- Pass 3's CLEAN verdict does not carry into a new streak attempt; the mandatory rule requires 3 CONSECUTIVE clean passes starting fresh. trajectory-tail →1→3→0→2 (unchanged). Pipeline stays ACTIVE (loop in progress). Full detail in Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE, F2 adversarial spec-convergence loop RESUMED this session (0/3 clean streak, in progress, FIFTH fresh-streak attempt this session, round-5 again got a CLEAN pass mid-streak -- third round in a row -- but streak did not close)); see current_step + Session Resume Checkpoint"
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, F2-ROUND5-FIX-CHAIN burst):
     189 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 189 = 11 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 189 = 311 lines of headroom remain before the hard cap of 500.
     This burst updated frontmatter (version/timestamp/current_step), superseded the round-4
     Phase Progress row and added a round-5 row, refreshed Current Phase Steps (last 5 rows,
     older detail archived to burst-log Burst 5), updated the Convergence Status paragraph,
     and replaced the Session Resume Checkpoint (round-4's checkpoint archived verbatim to
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
| **Last Updated** | F2-ROUND5-FIX-CHAIN (2026-08-26): a fifth fresh 3-pass adversary streak attempt this session -- Pass 1/2 NOT-CLEAN, Pass 3 CLEAN (third round in a row -- rounds 3/4/5 -- with a CLEAN pass; no HIGH/CRITICAL since round-3; findings are propagation-stragglers/peripheral-seams). Fixed via architect->PO->verifier->consistency-sweep->PO chain: F-NEW-1 create-path D2 collision guard governed set corrected 5->9 (3 new static keys + 1 resolved-id category, bypass-form only; VP-578-021 extended); F-NEW-2 `--field` hint-kind x `issue edit --dry-run` preview shape pinned, VP-578-024 minted; MED-1 VP-578-013 EC citation fixed (EC-2d -> EC-2a/b/c); MED-2 VP-578-023 back-fill reconciled at both sites (caught by consistency-sweep). trajectory-tail →1→3→0→2 (unchanged). 719 BCs unchanged; VP 31->32 (VP-578-024 new); 106 holdouts unchanged. Both guards re-verified PASS. Clean-streak still 0/3 (a mid-streak CLEAN pass does not persist across streak resets). v3.11->v3.12. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- Phase F2 (spec evolution), ACTIVE inside the mandatory adversarial spec-convergence loop (streak 0/3, fifth fresh-streak attempt this session got 1/3 CLEAN but did not close). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2 is spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| DEC-307-TO-DEC-310-PROPAGATION-SWEEP | COMPLETE | 2026-08-26 | state-manager commit | product-owner closed the owed follow-up: 35 residual DEC-307 refs corrected to DEC-310 across 6 flagged spec files. Both guards re-verified PASS (719 BCs / 29 VPs / 106 holdouts unchanged). | trajectory-tail →1→3→0→2 (unchanged); streak still 0/3 -- sweep is bookkeeping, not an adversary pass |
| F2-ROUND3-FIX-CHAIN | SUPERSEDED (round-3) | 2026-08-26 | fix-chain (architect->PO->verifier) | A THIRD fresh 3-pass streak attempt -- Pass 1/2 NOT-CLEAN, Pass 3 CLEAN (first CLEAN verdict this session). 1 HIGH+3 MEDIUM+several LOW fixed. 719 BCs unchanged; VP stays 30; 106 holdouts unchanged. Superseded by round-4. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINED 0/3 |
| F2-ROUND4-FIX-CHAIN | SUPERSEDED (round-4) | 2026-08-26 | fix-chain (architect->PO->verifier->PO) | A FOURTH fresh 3-pass streak attempt, run alongside a consistency-validator sweep -- Pass 1/2 NOT-CLEAN, Pass 3 CLEAN (second round in a row with a CLEAN pass). 5 MEDIUM-class+several LOW fixed: platform-vs-JSM D2 guard scope explicit, BC-INDEX.md prose fixed, VP-578-013 per-kind split, `--value` filter x `Option<String>` reconciled, non-cascading `>`-collision + bare-form literal (VP-578-023 minted). 719 BCs unchanged; VP 30->31; 106 holdouts unchanged. Superseded by round-5 below. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINED 0/3 -- mid-streak CLEAN does not persist across a streak reset |
| F2-ROUND5-FIX-CHAIN | ACTIVE (loop in progress) | 2026-08-26 | fix-chain (architect->PO->verifier->consistency-sweep->PO) | A FIFTH fresh 3-pass streak attempt -- Pass 1/2 NOT-CLEAN, **Pass 3 CLEAN** (third round in a row -- rounds 3/4/5 -- with a CLEAN pass; no HIGH/CRITICAL since round-3). 4 MEDIUM-class+several LOW fixed, all propagation-stragglers/peripheral-seam gaps: F-NEW-1 create-path D2 collision-guard governed set corrected 5->9 (VP-578-021 extended); F-NEW-2 dry-run per-kind wire-shape pinned across BC-3.4.021/027/028/029/030 (VP-578-024 minted); MED-1 VP-578-013 EC-2d miscitation fixed to EC-2a/b/c; MED-2 VP-578-023 back-fill reconciled at both anchor sites (caught by a consistency-sweep run after the verifier pass). 719 BCs unchanged; VP 31->32; 106 holdouts unchanged. Both guard scripts re-verified PASS post-burst. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINS 0/3 -- mid-streak CLEAN does not persist across a streak reset |

## Current Phase Steps (cycle-002, phase F2; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F2 mandatory adversarial spec-convergence loop -- round-4 fix chain (superseded) | SUPERSEDED | Fourth fresh 3-pass streak, Pass 3 CLEAN but streak did not close (5 MEDIUM-class+LOWs fixed). Full detail in `cycles/cycle-002/burst-log.md` Burst 4. Superseded by round-5 below. |
| F2 mandatory adversarial spec-convergence loop -- round-5 fix chain | ACTIVE (0/3 clean) | Fifth fresh-streak attempt, followed by a consistency-sweep: Pass 1/2 NOT-CLEAN, Pass 3 CLEAN. 4 MEDIUM-class+several LOW propagation-residual findings fixed via architect->PO->verifier->consistency-sweep->PO chain -- see `cycles/cycle-002/burst-log.md` Burst 5. Clean-pass streak REMAINS 0/3 -- 3 CONSECUTIVE CLEAN passes are still required before F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). |
| D2 create-path collision-guard governed set corrected 5->9 (F-NEW-1) | COMPLETE | ADR-0019 gains new SS "D2 correction (adversary F-NEW-1)": original 5-member set (reused verbatim from edit-path Gate B) was under-scoped for `issue create`'s own dedicated-flag surface; corrected to 5 original + 3 new static keys (`labels`/`parent`/`assignee`) + 1 resolved-id category (`--points`/`--team`, bypass-form only) = 9. Propagated to BC-3.3.010/011, BC-3.4.014/017/029; VP-578-021 extended. |
| VP total reconciled 31 -> 32 | COMPLETE | VP-578-024 (F-NEW-2 realization, dry-run per-kind wire-shape + `:asset` cold-cache side effect, minted by verifier, replacing the PO's `VP-DRY-RUN-005` placeholder in BC-3.4.021) is the one new VP id this round; grep-confirmed VP-578-001..024 (24 ids) + VP-580-005..012 (8 ids) = 32. Only STATE.md carries a standalone VP-total surface. |
| Guard scripts re-verified | PASS | `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered; propagation sweep completed 2026-08-26) | product-owner (proposed); orchestrator/state-manager to register formally at cycle close |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>`; § Amendment F-B: `FieldOption.id`/`.label` are `Option<String>` (never-drop invariant); § Amendment D4: non-cascading `>`-collision detected structurally + bare-form `>` is literal; § "D2 correction (adversary F-NEW-1)": create-path collision-guard governed set corrected 5->9 wire-key targets | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; `>` avoids collision with field names; F-B closes a HIGH-risk silent-drop gap; D4 closes a structural-detection + bare-form-asymmetry gap; D2 correction closes an under-scoped guard that silently left 5 of `issue create`'s own dedicated flags unguarded | F1/F2 | 2026-08-25 (Accepted); § Amendment 2026-08-26 (D1/D2/D3, F-B round-3, D4 round-4, D2 correction round-5) | architect |
| (pending) | D2 collision-guard extension to the JSM create path (dedicated flags that ARE merged onto the wire: `--summary`/`--description`/`--priority`/`--label`) -- DEFERRED, not decided either way | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform (several flags silently IGNORED, not merged) so the platform-shaped collision does not identically arise; needs explicit product judgment | F2 | 2026-08-26 (flagged round-4, MED-1/F-3; unchanged round-5) | owed at F2 human gate |
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

`cycle-002` (`field-dx`) is mid F2's mandatory adversarial spec-convergence loop. After round-1 (all NOT-CLEAN, 6 MEDIUM+~9 LOW fixed), the DEC-307->DEC-310 propagation sweep, round-2 (all NOT-CLEAN, 5 MEDIUM+2 LOW fixed), round-3 (1 HIGH+3 MEDIUM+several LOW fixed, Pass 3 CLEAN), and round-4 (5 MEDIUM-class+several LOW fixed, Pass 3 CLEAN), a FIFTH fresh 3-pass streak was run this session -- **Pass 1 and Pass 2 returned NOT-CLEAN, but Pass 3 returned CLEAN**, the third consecutive round (rounds 3, 4, 5) to produce a CLEAN verdict. Findings this round were all partial-fix propagation residuals or peripheral-seam gaps in this session's own D1/D2/D3/D4 fixes, not new defect classes, and (like round-4) contained no HIGH/CRITICAL findings: F-NEW-1 (the D2 create-path collision guard's governed field set was itself under-scoped -- corrected 5->9 wire-key targets, with `issue create`'s own larger dedicated-flag surface now fully covered, VP-578-021 extended) + F-NEW-2 (the `--field` hint-kind x `issue edit --dry-run` preview shape was unpinned -- now pinned per-kind across BC-3.4.021/027/028/029/030, new VP-578-024 minted, also covering the `:asset` cold-cache dry-run side effect) + MED-1 (VP-578-013's enumeration had drifted to miscite "EC-2d," corrected to the accurate EC-2a/b/c set) + MED-2 (VP-578-023's back-fill status was reconciled -- confirmed DONE at both anchor sites, a stale "pending" claim in the verification delta corrected) + several LOWs (M2 sub-headings bracketed, a stale changelog line converted to a resolution pointer, the round-4 "9 = 5+3+1" arithmetic slip reconciled everywhere). A consistency-sweep, run this round after the verifier pass and before the final adversary pass, is what caught MED-2's residual -- this is now the third consecutive round (3, 4, 5) to run a consistency-sweep alongside the streak to front-load residuals before they surface as adversary findings. Counts: 719 BCs unchanged; VP total **31 → 32** (VP-578-024, one new id); 106 holdouts unchanged. **Mandatory rule unchanged: 3 CONSECUTIVE clean adversary passes are still required before F2 Step 5/8 -- the streak remains 0/3.** A single CLEAN pass inside an otherwise-NOT-CLEAN streak does not count toward the 3-in-a-row requirement; the next resume must start a fresh streak at Pass 1. See Drift/Standing Items for the recurring-pattern watch item, now updated with a third consecutive positive convergence signal.

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at F2, adversarial spec-convergence loop in progress (streak 0/3, fifth fresh-streak attempt this session got a CLEAN pass again but did not close the streak). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase F2 (spec evolution), inside the MANDATORY adversarial spec-convergence loop. Pipeline ACTIVE -- loop in progress this session, not paused.

**F1:** COMPLETE + human-approved (unchanged this burst). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2 authoring:** COMPLETE (unchanged this burst) plus round-1's fix-burst amendments, the DEC propagation sweep, round-2's fix-chain, round-3's fix chain, round-4's fix chain, and this round's (round-5) fix chain. 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25, § Amendment 2026-08-26 D1/D2/D3 + round-3's F-B + round-4's D4 + round-5's D2 correction), BC-3.8.012 reversed (governance flag **DEC-310**, fully propagated). Counts: **719 total BCs** (BC-INDEX v6.82), **32 VPs** (VP-578-024 new this round), **106 holdout scenarios**.

**This session's work (2026-08-26, round-5):** a fifth fresh 3-pass adversary streak was run against the delta (attempting the required 3/3 CLEAN) -- Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, **Pass 3 CLEAN** (the third consecutive round -- rounds 3, 4, 5 -- to produce a CLEAN verdict; no HIGH/CRITICAL findings this round, same as round-4). Fixed via a fix chain: **F-NEW-1** (architect-decided): the D2 create-path collision guard's "Governed field set" bullet was itself under-scoped -- the original execution reused Gate B's five-member EDIT-derived set (`summary`/`description`/`issuetype`/`priority`/`components`) verbatim rather than re-deriving `issue create`'s own dedicated-flag surface, which is what D2's own qualifier ("restricted to whichever of those exist as a dedicated flag on issue create") actually called for. `handle_create` writes FIVE MORE dedicated-flag values into the same `fields` object `--field` merges into -- `--label`, `--team`, `--points`, `--parent`, and `--to`/`--account-id` -- none of which tripped the five-member guard, so e.g. `jr issue create --parent FOO-1 --field parent=BAR-2` silently double-wrote `fields.parent` from two unordered sources. ADR-0019 gains new section "D2 correction (adversary F-NEW-1)": the create-path governed set is corrected to **NINE** wire-key targets -- the original 5 + 3 new static-key members (`labels`/`parent`/`assignee`, same zero-HTTP static case-insensitive mechanism) + 1 resolved-id category covering `--points`/`--team`, detected ONLY via the `--field customfield_NNNNN=` bypass form (never a human display name -- resolving that would require hoisting general field-name resolution ahead of the create-path guard's zero-HTTP boundary, violating the step-2/2a/2b SSOT invariant; a caller writing `--points 5 --field "Story Points"=8` will NOT trip the guard -- a documented, bounded residual, not silently eliminated). `labels` is governed on CREATE (one unforked write path) but stays EXCLUDED on EDIT (BUG-LABEL-400's endpoint fork) -- a per-path exception with a documented reason. Propagated to BC-3.3.010 Invariant 5 + new EC-3.3.010-6a (full 9-member enumeration), BC-3.3.011's error-taxonomy row, and BC-3.4.029 EC-3.4.029-2 (spells out 5+3+1=9); **VP-578-021 EXTENDED** (not newly minted) to cover the 4 new static flags + 2 resolved-id cases + a NEGATIVE regression pin for the documented non-firing residual. **F-NEW-2**: `--field` hint-kind x `issue edit --dry-run` preview shape was unpinned across BC-3.4.021/027/028/029/030 -- now pinned: `plannedChanges` shows the SAME composed wire object the live PUT would send per hint kind (`:id`->`{"id":…}`, `:name`->`{"name":…}`, `:option` non-cascading->`{"id":…}`, `:option` cascading->`{"value":…,"child":{"value":…}}`, `:asset`->`[{workspaceId,id,objectId}]`), never the bare-form display-value string; PUT never called under `--dry-run`. **New VP-578-024 minted** (verifier), replacing the product-owner's `VP-DRY-RUN-005` placeholder in BC-3.4.021, also covering the `:asset` cold-cache side effect: a COLD `get_or_fetch_workspace_id` cache under `--dry-run` fires the real workspace-discovery HTTP call and CAN exit 64 from BC-3.4.030's cold-cache taxonomy BEFORE any `plannedChanges` output (mirrors VP-692-002/004's exit-64-before-preview shape). **MED-1** fixed a miscitation: VP-578-013's enumeration had drifted to cite "EC-2d," which belongs exclusively to VP-578-012's extra-colon message, not VP-578-013 -- corrected to the accurate EC-2a/b/c set (no delta edit required beyond the citation fix; VP-578-013 itself uses EC-2a for empty `:asset`). **MED-2**: a consistency-sweep (run this round after the verifier pass, before the final adversary pass) caught a stale claim in `verification-delta-field-dx.md` that VP-578-023's BC-body anchor still had a "sole pending back-fill" at BC-3.4.015 -- the product-owner had already back-filled it; reconciled, and `related_bcs` gained BC-3.4.015 (VP-578-023 Applies-to) + BC-3.4.021 (VP-578-024 owning BC). Several LOWs applied directly: M2 sub-headings bracketed (parity with M3's existing bracket convention); a stale changelog line converted to a resolution-pointer instead of duplicated prose; the round-4 "four vs three new static keys" count slip reconciled to the correct 9 = 5 (original) + 3 (new static) + 1 (resolved-id category) arithmetic everywhere it's cited. No BC change (719 stays). VP total **31 -> 32** (VP-578-024 is the ONE new id this round; VP-578-001..024 = 24 ids + VP-580-005..012 = 8 ids = 32). 106 holdouts unchanged.

**Guard scripts re-verified post-burst by state-manager:** `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). VP-total surface check: only STATE.md carries a standalone VP-count figure -- BC-INDEX.md and CANONICAL-COUNTS.md carry BC counts only (no VP-total field to update); individual `VP-NNN-NNN` citations inside BC bodies are not count surfaces; `verification-delta-field-dx.md`'s own internal narrative already carried the 31->32 arithmetic before this burst (product-owner/verifier's own bookkeeping), so no additional edit was needed there.

**Convergence counter -- CRITICAL for resume:** clean-pass streak is **still 0/3** -- Pass 3's CLEAN verdict this round does NOT carry forward into a new streak attempt; the mandatory rule requires 3 CONSECUTIVE clean passes, and a streak that includes any NOT-CLEAN pass must restart at 0. This is the fifth consecutive fresh-streak attempt within this session's history to fail to reach 3/3 CLEAN, and the third round IN A ROW to produce an individual CLEAN pass (rounds 3, 4, and 5 all got Pass 3 CLEAN), with no HIGH/CRITICAL findings in rounds 4 or 5. **ON RESUME:** run a fresh adversary pass on the now-quintuply-fixed delta, starting the streak count at 0/3; do not assume convergence without three REAL, CONSECUTIVE CLEAN verdicts. Continue until achieved, then proceed to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate).

**Decisions of record:** DEC-310 (reverses DEC-188; proposed, propagation complete) -- still needs formal registration at cycle close. ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26 D1/D2/D3 + F-B + D4 + D2 correction). UNCHANGED this round: the D2-collision-guard-extension-to-JSM question (F-3, round-4) remains DEFERRED, owed as a product decision at the F2 human gate -- see Decisions Log's `(pending)` row.

**Process-gap follow-ups owed at cycle close:**
1. **Register DEC-310** formally (supersedes the "Register DEC-307" item). Propagation of the renumber is CLOSED; only the formal registration step remains.
2. **DEC-namespace disambiguation question (still open):** spec-authored DECs and cycle-gate DECs currently share one flat `DEC-NNN` prefix with no central registry. Needs a cycle-close decision: split the namespaces, or stand up a single authoritative `DECISIONS-INDEX.md`.
3. No guard exists on CANONICAL-COUNTS ADR-count prose (drifted once already, fixed pass-19).
4. No guard exists on the amended-BC roster prose across its 5 surfaces (recurring stragglers, passes 12-17).
5. Need a reversal-propagation checklist for the PO/state-manager workflow.
6. **DEC-survey-scope gap:** any future "next sequential DEC number" survey MUST scan the whole `.factory/` tree, not just `specs/`.
7. No guard exists tying BC-INDEX.md's title-row prose to its corresponding BC body's H1 -- round-3's F-MED-2 drifted silently until an adversary pass caught it. Candidate for a future spec-guard script.
8. D2-collision-guard extension to the JSM create path (F-3, round-4) is a DEFERRED product decision, owed at the F2 human gate -- extending platform's "same wire key, two sources" collision guard to JSM's dedicated flags that ARE wire-merged (`--summary`/`--description`/`--priority`/`--label`).
9. **NEW (round-5):** the repeated pattern of "a guard/rule's own scope is under-derived from first principles and instead copy-pasted from a sibling guard" (F-NEW-1: create-path D2 governed set copied from edit-path Gate B rather than re-derived) is now a two-instance pattern within this delta (round-4's D2/D4 work and round-5's F-NEW-1) -- candidate for an explicit spec-authoring checklist item: "when extending a guard/rule to a new call site, re-derive its scope from that call site's own surface, do not reuse the origin site's set verbatim."

**Pending human decision:** F2 human gate (after convergence -- 3/3 clean); will also need to decide item #8 above (D2-extension-to-JSM). Then F3-F7.

**In flight / uncommitted at this checkpoint:** none -- this round's touched files (`phase-f2-spec-evolution/architecture-delta-field-dx.md`, `phase-f2-spec-evolution/prd-delta-field-dx.md`, `phase-f2-spec-evolution/verification-delta-field-dx.md`, `specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md`, `specs/prd/bc-3-issue-write.md`, `specs/prd/cross-cutting.md`, `sidecar-learning.md`) and this STATE.md, plus `cycles/cycle-002/burst-log.md`, are committed to `factory-artifacts` together as part of this session's commit.

**Resume command:** `/vsdd-factory:next-step` (or resume the F2 adversarial convergence loop directly -- run a fresh adversary pass first, starting the streak count at 0/3; do not assume the prior round's CLEAN pass carries forward).

**Superseded checkpoint:** the round-4 fresh-streak checkpoint (v3.11, 2026-08-26) is archived verbatim to `cycles/cycle-002/session-checkpoints.md`. The round-3 checkpoint (v3.10), round-2 checkpoint (v3.09), round-1 checkpoint (v3.08), and the WRAP-F2-CONVERGENCE-PAUSE checkpoint (v3.06) remain archived there. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1 = round-1 fresh streak; Burst 2 = round-2 fresh streak; Burst 3 = round-3 fix chain; Burst 4 = round-4 fix chain; Burst 5 = round-5 fix chain) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE + F2-ROUND2-FRESH-STREAK + F2-ROUND3-FIX-CHAIN + F2-ROUND4-FIX-CHAIN archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**Resolved this session (2026-08-26):**
- `DEC-307-TO-DEC-310-PROPAGATION-INCOMPLETE` (was MEDIUM) -- CLOSED. product-owner corrected the 35 residual `DEC-307` occurrences across the 6 flagged files; guards re-verified PASS.
- `BC-INDEX-TITLE-ROW-DRIFT-RISK` (was LOW) -- the specific instance (BC-X.14.001's stale companion-flag arity prose) was corrected round-4 (MED-2). The underlying guard gap (no automated check tying BC-INDEX.md prose to BC-body H1/text) remains open -- see process-gap follow-up #7.
- `VP-578-023-BACKFILL-STALE-CLAIM` (LOW, round-5) -- CLOSED. The verification-delta's "sole pending back-fill" claim was stale (the product-owner had already back-filled BC-3.4.015 round-4); reconciled by round-5's consistency-sweep + product-owner wording fix (MED-2).

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry. See Session Resume Checkpoint process-gap follow-up #2.
- `CLEAN-STREAK-REPEATED-RESET` (WATCH, observational) -- this is now the FIFTH consecutive fresh-streak attempt within this session where the F2 convergence streak failed to reach 3/3 CLEAN, but rounds 3, 4, AND 5 each produced an individual CLEAN pass (Pass 3 every time), and no HIGH/CRITICAL finding has surfaced since round-3 -- findings are now consistently propagation-stragglers/peripheral-seam gaps rather than new defect classes. Three consecutive CLEAN-pass rounds is a stronger positive signal than one or two; each resume should still default-assume un-converged until a fresh pass proves otherwise.
- `BC-INDEX-GUARD-GAP` (LOW, unchanged) -- no automated guard ties BC-INDEX.md prose to BC-body H1/text; the specific round-3 drift instance is fixed (see Resolved above) but the class of defect remains possible. See process-gap follow-up #7.
- `D2-JSM-EXTENSION-DEFERRED` (LOW/product-decision, round-4, unchanged round-5) -- MED-1/F-3 flagged extending the D2 collision guard to JSM's wire-merged dedicated flags as an open product decision, not yet made either way. Owed at the F2 human gate. See process-gap follow-up #8.
- `GUARD-SCOPE-COPY-PASTE-PATTERN` (NEW, LOW/process, round-5) -- round-5's F-NEW-1 is the second instance within this delta of a guard's scope being copy-pasted from a sibling site rather than re-derived from first principles for its own call site. Candidate spec-authoring checklist item. See process-gap follow-up #9.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
