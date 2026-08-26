---
document_type: pipeline-state
level: ops
version: "3.11"
status: active
producer: state-manager
timestamp: 2026-08-26T18:47:00Z
phase: F2
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). F2-ROUND4-FIX-CHAIN (2026-08-26): a FOURTH fresh 3-pass adversary streak was run against the field-dx delta (attempt #4 overall to reach 3/3 CLEAN), run alongside a consistency-validator sweep that confirmed the finding list was complete -- Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, Pass 3 CLEAN (the second round in a row to produce at least one CLEAN pass; findings continue to decay: round-1 6 MED+~9 LOW -> round-2 5 MED+2 LOW -> round-3 1 HIGH+3 MED+several LOW -> round-4 5 MEDIUM-class+several LOW, all partial-fix propagation residuals of this session's own D1/D2/D3/F-B fixes, no new defect classes). Fixed via a fix chain (architect for D4 + one targeted ADR-0019 note -> product-owner -> verifier -> product-owner back-fill): MED-1/F-3 made the platform-vs-JSM D2 collision-guard scope explicit across five BC bodies (BC-3.4.029 EC-3.4.029-2, BC-3.4.017, BC-3.3.010/011, BC-3.4.014) with BC-3.8.008 gaining a justification paragraph for JSM's retained last-wins behavior -- extending D2 to JSM is explicitly flagged DEFERRED, owed at the F2 human gate as a product decision. MED-2 (state-manager, this burst): BC-INDEX.md's BC-X.14.001 row prose corrected from stale \"REQUIRED for M2, OPTIONAL for M3\" to \"companion for M2 (flag OR profile/config default), companion for M3\" -- the ONLY BC-INDEX content change this round, no count field touched. MED-3 realized VP-578-013's per-kind split (`:option` empty->is_err, `:id`/`:name` empty->is_ok pass-through, `:asset` empty->is_err structural). F-1 reconciled BC-X.14.002's `--value` filter with F-B's `Option<String>` fields (None skipped not panicked, never-drop preserved, `--value \"\"` matches even a fully-degenerate entry) via VP-580-007 (g)/(h)/(i). F-2/D4 (architect-decided): non-cascading `>`-collision now detected structurally (new BC-3.4.027 EC-3.4.027-7 + `AllowedValue.children` type note) and the bare form treats `>` as literal (new BC-3.4.015 note) -- new VP-578-023 minted and back-filled. LOWs: `:asset=:`/`:asset=:Y:Z` check-order pinned deterministic, M3 numeric-bypass edge documented, ADR-0019 SS1 gains a superseded pointer. NO BC change -- total_bcs stays 719 (bc-3 123/152, cross-cutting 89/155). VP total **30 -> 31** (VP-578-023 newly minted; VP-578-001..023 = 23 + VP-580-005..012 = 8). Holdouts 106 unchanged. Both guard scripts re-verified PASS post-burst. Clean-pass streak REMAINS 0/3 -- Pass 3's CLEAN verdict does not carry into a new streak attempt; the mandatory rule requires 3 CONSECUTIVE clean passes starting fresh. trajectory-tail →1→3→0→2 (unchanged). Pipeline stays ACTIVE (loop in progress). Full detail in Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE, F2 adversarial spec-convergence loop RESUMED this session (0/3 clean streak, in progress, FOURTH fresh-streak attempt this session, round-4 again got a CLEAN pass mid-streak but streak did not close)); see current_step + Session Resume Checkpoint"
activation_head: "00df3823"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, F2-ROUND4-FIX-CHAIN burst):
     186 lines (wc-l). soft-target 200; hard cap 500.
     margin from soft-target = 200 - 186 = 14 lines of headroom remain before the soft target of 200.
     margin from actual (hard cap) = 500 - 186 = 314 lines of headroom remain before the hard cap of 500.
     This burst updated frontmatter (version/timestamp/current_step), added one Phase Progress
     row, added one Current Phase Steps row (archived the oldest superseded row's detail to
     burst-log Burst 4), updated the Convergence Status paragraph, and replaced the Session
     Resume Checkpoint (round-3's checkpoint archived verbatim to
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
| **Last Updated** | F2-ROUND4-FIX-CHAIN (2026-08-26): a fourth fresh 3-pass adversary streak attempt this session, run alongside a consistency-validator sweep -- Pass 1/2 NOT-CLEAN, Pass 3 CLEAN (second round in a row with a CLEAN pass; findings decaying: 6 MED+~9 LOW -> 5 MED+2 LOW -> 1 HIGH+3 MED+several LOW -> 5 MEDIUM-class+several LOW, all propagation residuals). Fixed via architect->PO->verifier->PO chain: MED-1/F-3 platform-vs-JSM D2 guard scope made explicit (JSM extension DEFERRED to F2 human gate); MED-2 BC-INDEX.md BC-X.14.001 prose fixed by state-manager (only BC-INDEX change); MED-3 VP-578-013 per-kind split; F-1 `--value` filter × `Option<String>` reconciled; F-2/D4 (architect) non-cascading `>`-collision + bare-form literal, VP-578-023 minted. trajectory-tail →1→3→0→2 (unchanged). 719 BCs unchanged; VP 30→31 (VP-578-023 new); 106 holdouts unchanged. Both guards re-verified PASS. Clean-streak still 0/3 (a mid-streak CLEAN pass does not persist across streak resets). v3.10->v3.11. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- Phase F2 (spec evolution), ACTIVE inside the mandatory adversarial spec-convergence loop (streak 0/3, fourth fresh-streak attempt this session got 1/3 CLEAN but did not close). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 00df3823 (`develop` tip; `v0.7.0-dev.2`) -- UNCHANGED this cycle (F2 is spec-only; no develop merges yet) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| DEC-307-TO-DEC-310-PROPAGATION-SWEEP | COMPLETE | 2026-08-26 | state-manager commit | product-owner closed the owed follow-up: 35 residual DEC-307 refs corrected to DEC-310 across 6 flagged spec files. Both guards re-verified PASS (719 BCs / 29 VPs / 106 holdouts unchanged). | trajectory-tail →1→3→0→2 (unchanged); streak still 0/3 -- sweep is bookkeeping, not an adversary pass |
| F2-ROUND2-FRESH-STREAK | SUPERSEDED (round-2) | 2026-08-26 | fix-chain (PO->verifier->PO back-fill) | A second fresh 3-pass streak (post-sweep), ALL NOT-CLEAN: 5 MEDIUM+2 LOW fixed -- VP-580-006 3-bool rewrite, `:asset` cold-cache taxonomy widened to 3 call sites, new `--project` 404 row + VP-580-012 minted, `:`-split MUST, objectId ASCII-only fix, guard-ordering pin, dangling path citation fixed. 719 BCs unchanged; VP 29->30; 106 holdouts unchanged. Superseded by round-3. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINED 0/3 |
| F2-ROUND3-FIX-CHAIN | SUPERSEDED (round-3) | 2026-08-26 | fix-chain (architect->PO->verifier) | A THIRD fresh 3-pass streak attempt -- Pass 1/2 NOT-CLEAN, Pass 3 CLEAN (first CLEAN verdict this session). 1 HIGH+3 MEDIUM+several LOW fixed: F-A empty `:id=`/`:name=` pass-through vs `:asset=` structural exit-64, F-MED-1 `parse_field_kv` SSOT ordering pin, F-MED-2 BC-X.14.001 H1 bracket fix + BC-INDEX.md title-row propagated, F-C `:asset=W:Y:Z` distinct message, F-B (architect) `FieldOption.id`/`.label`->`Option<String>` never-drop invariant. 719 BCs unchanged; VP stays 30; 106 holdouts unchanged. Superseded by round-4 below. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINED 0/3 |
| F2-ROUND4-FIX-CHAIN | ACTIVE (loop in progress) | 2026-08-26 | fix-chain (architect->PO->verifier->PO) | A FOURTH fresh 3-pass streak attempt, run alongside a consistency-validator sweep -- Pass 1/2 NOT-CLEAN, **Pass 3 CLEAN** (second round in a row with a CLEAN pass). 5 MEDIUM-class+several LOW fixed, all propagation residuals: MED-1/F-3 platform-vs-JSM D2 guard scope explicit (JSM extension DEFERRED to F2 human gate, DEC-namespace item); MED-2 BC-INDEX.md BC-X.14.001 prose fixed (state-manager, only BC-INDEX change); MED-3 VP-578-013 per-kind split; F-1 `--value` filter × `Option<String>` reconciled; F-2/D4 (architect) non-cascading `>`-collision + bare-form literal, VP-578-023 minted+back-filled. 719 BCs unchanged; VP 30->31; 106 holdouts unchanged. Both guard scripts re-verified PASS post-burst. | trajectory-tail →1→3→0→2 (unchanged); streak REMAINS 0/3 -- mid-streak CLEAN does not persist across a streak reset |

## Current Phase Steps (cycle-002, phase F2; last 5)

| Step | Status | Notes |
|------|--------|-------|
| F2 mandatory adversarial spec-convergence loop -- round-3 fix chain (superseded) | SUPERSEDED | Third fresh 3-pass streak, Pass 3 CLEAN but streak did not close (1 HIGH+3 MED+LOWs fixed). Full detail in `cycles/cycle-002/burst-log.md` Burst 3. Superseded by round-4 below. |
| F2 mandatory adversarial spec-convergence loop -- round-4 fix chain | ACTIVE (0/3 clean) | Fourth fresh-streak attempt, run alongside a consistency-validator sweep: Pass 1/2 NOT-CLEAN, Pass 3 CLEAN. 5 MEDIUM-class+several LOW propagation-residual findings fixed via architect->PO->verifier->PO chain -- see `cycles/cycle-002/burst-log.md` Burst 4. Clean-pass streak REMAINS 0/3 -- 3 CONSECUTIVE CLEAN passes are still required before F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate). |
| BC-INDEX.md BC-X.14.001 row prose fixed (MED-2) | COMPLETE | Corrected "REQUIRED for M2, OPTIONAL for M3" -> "companion for M2 (flag OR profile/config default), companion for M3" at BC-INDEX.md line ~861, matching D1 + the already-corrected bracketed H1 synopsis in cross-cutting.md. Only BC-INDEX content change this burst; no count field touched. |
| VP total reconciled 30 -> 31 | COMPLETE | VP-578-023 (D4/F-2 realization, minted by verifier, back-filled by product-owner into `bc-3-issue-write.md`) is the one new VP id this round; grep-confirmed VP-578-001..023 (23 ids) + VP-580-005..012 (8 ids) = 31. Only STATE.md carries a standalone VP-total surface. |
| Guard scripts re-verified | PASS | `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files)"). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered; propagation sweep completed 2026-08-26) | product-owner (proposed); orchestrator/state-manager to register formally at cycle close |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>`; § Amendment F-B: `FieldOption.id`/`.label` are `Option<String>` (never-drop invariant); § Amendment D4: non-cascading `>`-collision detected structurally + bare-form `>` is literal | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; `>` avoids collision with field names; F-B closes a HIGH-risk silent-drop gap; D4 closes a structural-detection + bare-form-asymmetry gap | F1/F2 | 2026-08-25 (Accepted); § Amendment 2026-08-26 (D1/D2/D3, F-B round-3, D4 round-4) | architect |
| (pending) | D2 collision-guard extension to the JSM create path (dedicated flags that ARE merged onto the wire: `--summary`/`--description`/`--priority`/`--label`) -- DEFERRED, not decided either way this round | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform (several flags silently IGNORED, not merged) so the platform-shaped collision does not identically arise; needs explicit product judgment | F2 | 2026-08-26 (flagged round-4, MED-1/F-3) | owed at F2 human gate |
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
| (none currently open) | -- the DEC-namespace disambiguation question, formal DEC-310 registration, and the newly-DEFERRED D2-extension-to-JSM product decision (F-3, round-4) are tracked debt, not hard blockers -- they must close before F2 Step 5/cycle close but do not block resuming the adversary loop | -- | -- | -- | -- |

## Convergence Status

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): all five convergence dimensions plus Regression are PASS (MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized 2026-08-24) -- historical, unchanged this burst.

`cycle-002` (`field-dx`) is mid F2's mandatory adversarial spec-convergence loop. After round-1 (all NOT-CLEAN, 6 MEDIUM+~9 LOW fixed), the DEC-307->DEC-310 propagation sweep, round-2 (all NOT-CLEAN, 5 MEDIUM+2 LOW fixed), and round-3 (1 HIGH+3 MEDIUM+several LOW fixed, Pass 3 CLEAN), a FOURTH fresh 3-pass streak was run this session -- run alongside a consistency-validator sweep confirming the finding list was complete -- **Pass 1 and Pass 2 returned NOT-CLEAN, but Pass 3 returned CLEAN**, the second consecutive round to produce a CLEAN verdict. Findings this round were all partial-fix propagation residuals of this session's own D1/D2/D3/F-B fixes, not new defect classes: MED-1/F-3 (the platform-vs-JSM D2 collision-guard scope was implicit rather than explicit across five BC bodies -- now explicit everywhere, with the JSM-extension question DEFERRED to the F2 human gate as an open product decision) + MED-2 (BC-INDEX.md's BC-X.14.001 row prose was stale pre-D1 wording -- corrected by state-manager, the only BC-INDEX content change) + MED-3 (VP-578-013's per-kind proptest split realized) + F-1 (BC-X.14.002's `--value` filter reconciled with F-B's `Option<String>` fields) + F-2/D4 (architect-decided: non-cascading `>`-collision now detected structurally, bare-form `>` confirmed literal, new VP-578-023 minted and back-filled) + several LOWs (check-order pin, M3 numeric-bypass doc, ADR-0019 superseded pointer). Counts: 719 BCs unchanged; VP total **30 → 31** (VP-578-023, one new id); 106 holdouts unchanged. **Mandatory rule unchanged: 3 CONSECUTIVE clean adversary passes are still required before F2 Step 5/8 -- the streak remains 0/3.** A single CLEAN pass inside an otherwise-NOT-CLEAN streak does not count toward the 3-in-a-row requirement; the next resume must start a fresh streak at Pass 1. See Drift/Standing Items for the recurring-pattern watch item, now updated with a second consecutive positive convergence signal.

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE at F2, adversarial spec-convergence loop in progress (streak 0/3, fourth fresh-streak attempt this session got a CLEAN pass again but did not close the streak). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>` -- enumerate custom-field options) + #578 (`--field` value-kind hint syntax `:option`/`:id`/`:name`/`:asset` + non-JSM `issue create --field`). 2-story bundle, full F1-F7 lifecycle, DTU not required.

**Position:** Phase F2 (spec evolution), inside the MANDATORY adversarial spec-convergence loop. Pipeline ACTIVE -- loop in progress this session, not paused.

**F1:** COMPLETE + human-approved (unchanged this burst). See `phase-f1-delta-analysis/delta-analysis-field-dx.md`.

**F2 authoring:** COMPLETE (unchanged this burst) plus round-1's fix-burst amendments, the DEC propagation sweep, round-2's fix-chain, round-3's fix chain, and this round's (round-4) fix chain. 12 new BCs (`§X.14` Field Option Discovery + BC-3.3.010/011 + BC-3.4.026-031), ADR-0019 (Accepted 2026-08-25, § Amendment 2026-08-26 D1/D2/D3 + round-3's F-B + round-4's D4), BC-3.8.012 reversed (governance flag **DEC-310**, fully propagated). Counts: **719 total BCs** (BC-INDEX v6.82), **31 VPs** (VP-578-023 new this round), **106 holdout scenarios**.

**This session's work (2026-08-26, round-4):** a fourth fresh 3-pass adversary streak was run against the delta (attempting the required 3/3 CLEAN), run alongside a comprehensive consistency-validator sweep against round-1/2/3's amendments that confirmed the finding list was complete -- Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, **Pass 3 CLEAN** (the second consecutive round to produce a CLEAN verdict; findings continue to decay in kind if not strictly in count: round-1 6 MED+~9 LOW -> round-2 5 MED+2 LOW -> round-3 1 HIGH+3 MED+several LOW -> round-4 5 MEDIUM-class+several LOW, all propagation residuals of this same session's own fixes rather than new defect classes). Fixed via a fix chain: **MED-1/F-3** made the platform-vs-JSM D2 collision-guard scope EXPLICIT everywhere it was previously implicit -- EC-3.4.029-2 (`bc-3-issue-write.md`) gained an explicit "PLATFORM (non-JSM) CREATE path" qualifier plus a cross-reference stating the JSM path does NOT get this guard; BC-3.4.017 (Gate B) and its EC-3.4.017-16 cross-reference, BC-3.3.010 Invariant 5, BC-3.3.011's error-taxonomy row, and BC-3.4.014's echo bullet all gained matching explicit platform-only qualifiers; BC-3.8.008 gained a new paragraph explicitly justifying JSM's retained last-wins behavior (JSM's dedicated-flag semantics already diverge -- several flags are silently IGNORED, not merged onto the wire) -- **extending the D2 guard to the JSM flags that ARE wire-merged (`--summary`/`--description`/`--priority`/`--label`) is explicitly flagged as an OPEN, DEFERRED product decision, owed at the F2 human gate, not silently decided either way.** **MED-2** (state-manager, this burst): BC-INDEX.md's BC-X.14.001 row prose corrected from stale "REQUIRED for M2, OPTIONAL for M3" to "companion for M2 (flag OR profile/config default), companion for M3" -- the ONLY BC-INDEX content change this round, no count field touched. **MED-3** realized VP-578-013's per-kind proptest split: `:option` empty -> `is_err()` (downstream `allowedValues` match-miss, EC-3.4.016-2) vs `:id`/`:name` empty -> `is_ok()` pass-through vs `:asset` empty -> `is_err()` structural. **F-1** reconciled BC-X.14.002's `--value` filter with F-B's `Option<String>` fields -- a new "Filtering against `Option<String>` fields" paragraph (a `None` field is skipped as a match source, never panics, never itself drops the entry) plus a reconciled `--value ""` IDENTITY claim (unconditional match INCLUDING a fully-`{id:None,label:None}` entry, preserving never-drop through the filter); VP-580-007 gained sub-points (g)/(h)/(i). **F-2/D4 (architect-decided)**: the `>` split stays UNCONDITIONAL (confirms D3); a non-cascading-field collision (matched parent's `children` collection empty) is now detected STRUCTURALLY, never via a `schema.type` lookup -- new BC-3.4.027 EC-3.4.027-7 (pinned message substrings `"is not a cascading select"` + `"remove the"`) plus a Trace update citing `AllowedValue.children: Vec<AllowedValue>` (`#[serde(default)]`) as a new type dependency on `src/types/jira/editmeta.rs`; the bare form (`--field cf=Parent>Child`, no `:option` hint) treats `>` as a LITERAL character -- new BC-3.4.015 note, falls through to the existing EC-3.4.016-2 shape. **New VP-578-023 minted** (sibling to VP-578-008) realizing both D4 assertions; its inline BC-body anchor (BC-3.4.027 + BC-3.4.015) was back-filled by product-owner this round, closing the verifier's flagged pending-back-fill item. Several LOWs applied directly: `:asset=:`/`:asset=:Y:Z` intra-composer check order pinned deterministic (EC-2c empty-workspace evaluated BEFORE EC-2b/EC-3/EC-2d objectId-segment checks, BC-3.4.030 Parsing rule 2 + BC-3.4.031 EC-2c cross-referenced); M3's inherited `jr requesttype fields` all-ASCII-digit numeric-bypass edge documented for `jr field options` (new BC-X.14.001 paragraph); ADR-0019 §1's `has_project` note gained an inline `[superseded 2026-08-26 — see Amendment D1]` pointer (one targeted line only, Amendment section untouched). No BC change (719 stays). VP total **30 -> 31** (VP-578-023 is the ONE new id this round; VP-578-001..023 = 23 ids + VP-580-005..012 = 8 ids = 31). 106 holdouts unchanged.

**Guard scripts re-verified post-burst by state-manager:** `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). VP-total surface check: only STATE.md carries a standalone VP-count figure -- BC-INDEX.md and CANONICAL-COUNTS.md carry BC counts only (no VP-total field to update); individual `VP-NNN-NNN` citations inside BC bodies are not count surfaces.

**Convergence counter -- CRITICAL for resume:** clean-pass streak is **still 0/3** -- Pass 3's CLEAN verdict this round does NOT carry forward into a new streak attempt; the mandatory rule requires 3 CONSECUTIVE clean passes, and a streak that includes any NOT-CLEAN pass must restart at 0. This is the fourth consecutive fresh-streak attempt within this session's history to fail to reach 3/3 CLEAN, and the second round IN A ROW to produce an individual CLEAN pass (rounds 3 and 4 both got Pass 3 CLEAN). **ON RESUME:** run a fresh adversary pass on the now-quadruply-fixed delta, starting the streak count at 0/3; do not assume convergence without three REAL, CONSECUTIVE CLEAN verdicts. Continue until achieved, then proceed to F2 Step 5 (spec version bump + changelog) and Step 8 (F2 human gate).

**Decisions of record:** DEC-310 (reverses DEC-188; proposed, propagation complete) -- still needs formal registration at cycle close. ADR-0019 (Accepted 2026-08-25; § Amendment 2026-08-26 D1/D2/D3 + F-B + D4). NEW this round: the D2-collision-guard-extension-to-JSM question (F-3) is DEFERRED, owed as a product decision at the F2 human gate -- see Decisions Log's `(pending)` row.

**Process-gap follow-ups owed at cycle close:**
1. **Register DEC-310** formally (supersedes the "Register DEC-307" item). Propagation of the renumber is CLOSED; only the formal registration step remains.
2. **DEC-namespace disambiguation question (still open):** spec-authored DECs and cycle-gate DECs currently share one flat `DEC-NNN` prefix with no central registry. Needs a cycle-close decision: split the namespaces, or stand up a single authoritative `DECISIONS-INDEX.md`.
3. No guard exists on CANONICAL-COUNTS ADR-count prose (drifted once already, fixed pass-19).
4. No guard exists on the amended-BC roster prose across its 5 surfaces (recurring stragglers, passes 12-17).
5. Need a reversal-propagation checklist for the PO/state-manager workflow.
6. **DEC-survey-scope gap:** any future "next sequential DEC number" survey MUST scan the whole `.factory/` tree, not just `specs/`.
7. No guard exists tying BC-INDEX.md's title-row prose to its corresponding BC body's H1 -- round-3's F-MED-2 drifted silently until an adversary pass caught it. Candidate for a future spec-guard script.
8. **NEW (round-4):** D2-collision-guard extension to the JSM create path (F-3) is a DEFERRED product decision, owed at the F2 human gate -- extending platform's "same wire key, two sources" collision guard to JSM's dedicated flags that ARE wire-merged (`--summary`/`--description`/`--priority`/`--label`).

**Pending human decision:** F2 human gate (after convergence -- 3/3 clean); will also need to decide item #8 above (D2-extension-to-JSM). Then F3-F7.

**In flight / uncommitted at this checkpoint:** none -- this round's touched files (`phase-f2-spec-evolution/architecture-delta-field-dx.md`, `phase-f2-spec-evolution/prd-delta-field-dx.md`, `phase-f2-spec-evolution/verification-delta-field-dx.md`, `specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md`, `specs/prd/bc-3-issue-write.md`, `specs/prd/cross-cutting.md`, `specs/prd/BC-INDEX.md`, `sidecar-learning.md`) and this STATE.md, plus `cycles/cycle-002/burst-log.md` and `cycles/cycle-002/session-checkpoints.md`, are committed to `factory-artifacts` together as part of this session's commit.

**Resume command:** `/vsdd-factory:next-step` (or resume the F2 adversarial convergence loop directly -- run a fresh adversary pass first, starting the streak count at 0/3; do not assume the prior round's CLEAN pass carries forward).

**Superseded checkpoint:** the round-3 fresh-streak checkpoint (v3.10, 2026-08-26) is archived verbatim to `cycles/cycle-002/session-checkpoints.md`. The round-2 checkpoint (v3.09), round-1 checkpoint (v3.08), and the WRAP-F2-CONVERGENCE-PAUSE checkpoint (v3.06) remain archived there. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Burst 1 = round-1 fresh streak; Burst 2 = round-2 fresh streak; Burst 3 = round-3 fix chain; Burst 4 = round-4 fix chain) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE + F2-ROUND2-FRESH-STREAK + F2-ROUND3-FIX-CHAIN archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**Resolved this session (2026-08-26):**
- `DEC-307-TO-DEC-310-PROPAGATION-INCOMPLETE` (was MEDIUM) -- CLOSED. product-owner corrected the 35 residual `DEC-307` occurrences across the 6 flagged files; guards re-verified PASS.
- `BC-INDEX-TITLE-ROW-DRIFT-RISK` (was LOW) -- the specific instance (BC-X.14.001's stale companion-flag arity prose) is CORRECTED this round (MED-2). The underlying guard gap (no automated check tying BC-INDEX.md prose to BC-body H1/text) remains open -- see process-gap follow-up #7.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry. See Session Resume Checkpoint process-gap follow-up #2.
- `CLEAN-STREAK-REPEATED-RESET` (WATCH, observational) -- this is now the FOURTH consecutive fresh-streak attempt within this session where the F2 convergence streak failed to reach 3/3 CLEAN, but rounds 3 AND 4 both produced an individual CLEAN pass (Pass 3 each time), and finding severity/volume has continued to shrink or flatten each round (round-1: 6 MED+~9 LOW; round-2: 5 MED+2 LOW; round-3: 1 HIGH+3 MED+several LOW; round-4: 5 MEDIUM-class+several LOW, all propagation residuals rather than new defect classes). Two consecutive CLEAN-pass rounds is a stronger positive signal than one; each resume should still default-assume un-converged until a fresh pass proves otherwise.
- `BC-INDEX-GUARD-GAP` (LOW, unchanged) -- no automated guard ties BC-INDEX.md prose to BC-body H1/text; the specific round-3 drift instance is fixed (see Resolved above) but the class of defect remains possible. See process-gap follow-up #7.
- `D2-JSM-EXTENSION-DEFERRED` (NEW, LOW/product-decision, round-4) -- MED-1/F-3 flagged extending the D2 collision guard to JSM's wire-merged dedicated flags as an open product decision, not yet made either way. Owed at the F2 human gate. See process-gap follow-up #8.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md.
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
