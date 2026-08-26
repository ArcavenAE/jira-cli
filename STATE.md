---
document_type: pipeline-state
level: ops
version: "3.20"
status: active
producer: state-manager
timestamp: 2026-08-26T22:35:52Z
phase: F4
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "D-chain cite D-453 latest brownfield (unchanged). trajectory-tail →1→3→0→2 (unchanged this burst). F4 (delta implementation): WAVE 1 COMPLETE (unchanged). WAVE 2 PAUSED via human /wrap 2026-08-26: S-578-2 (`issue edit --field` hint dispatch) dispatch was initiated (Step 2, stub generation) then INTERRUPTED by /wrap during the read phase -- NO code changes landed. Worktree `.worktrees/S-578-2` (branch `feature/S-578-2-edit-field-dispatch`) exists at develop base `74221bbc`, CLEAN, 0 commits ahead. On resume: re-dispatch Step 2 (stub generation) for S-578-2. S-578-3 (JSM create --field dispatch) queued next in Wave 2, deliver SEQUENTIALLY after S-578-2 (both share the interim `reject_unsupported_hint_kinds` guard removal in create.rs). Wave 3 = S-578-4, blocked on Wave 2. Full detail: cycles/cycle-002/burst-log.md Burst 11 + Session Resume Checkpoint below."
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
cycle_002_status: "field-dx -- ACTIVE at F4 (delta implementation), PAUSED via human /wrap 2026-08-26. Wave 1 COMPLETE: S-578-1 (PR #739 @ 993de833) + S-580-1 (PR #740 @ 74221bbc) both delivered/merged. Wave 2 IN PROGRESS (paused): S-578-2 at Step 2 (stub-gen interrupted, no changes landed; worktree .worktrees/S-578-2 clean at 74221bbc); S-578-3 queued next, sequential. Wave 3 (S-578-4) blocked on Wave 2. Resume via /vsdd-factory:next-step."
activation_head: "74221bbc"
activation_version: "v0.7.0-dev.2"
---

<!-- STATE.md SIZE BUDGET (2026-08-26, WRAP-F4-WAVE2-PAUSE burst):
     Soft target: ≤200 lines; margin from soft-target and actual tracked at write time (D-446(c) dual-margin form).
     This burst records a human-requested /wrap during F4 Wave 2: S-578-2 (`issue edit --field`
     hint dispatch) dispatch reached Step 2 (stub generation) and was INTERRUPTED before any
     changes landed -- worktree `.worktrees/S-578-2` exists at develop base `74221bbc`, CLEAN,
     0 commits ahead. STATE.md changes: frontmatter pipeline ACTIVE->PAUSED, version/timestamp
     bump, current_step and cycle_002_status updated to the pause position, a new Phase Progress
     row (WRAP-F4-WAVE2-PAUSE), Current Phase Steps trimmed to the 5 most recent (oldest row
     archived -- already fully narrated in burst-log.md Burst 10), Session Resume Checkpoint
     replaced with the Wave-2-paused position (prior F4-WAVE-1-COMPLETE checkpoint archived to
     cycles/cycle-002/session-checkpoints.md). No BC/VP/holdout counts changed (719/32/106) --
     those guards are untouched by this burst. activation_head UNCHANGED at `74221bbc` (no merge
     occurred this burst). One full-content Write, no Edit chain (DEC-247). Pre-compaction
     (pre-2026-08-25) full history remains at factory-artifacts commit 43f4a5e3 and
     cycles/cycle-001/burst-log.md. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst -- a human /wrap pause is not a D-chain-touching burst) |
| **Last Updated** | WRAP-F4-WAVE2-PAUSE (2026-08-26): trajectory-tail →1→3→0→2 (unchanged this burst). Human `/wrap` invoked during F4 Wave 2 dispatch of S-578-2 (Step 2, stub generation) -- interrupted, no changes landed. Pipeline set to **PAUSED**. v3.19->v3.20. |
| **Current Phase** | Feature Mode cycle-002 (`field-dx`, GH #580 + #578) -- **Phase F4** (delta implementation), pipeline **PAUSED**. Wave 1 COMPLETE: S-578-1 (PR #739) + S-580-1 (PR #740) both delivered/merged. Wave 2 IN PROGRESS, PAUSED: S-578-2 at Step 2 (interrupted, no changes landed). cycle-001 (`list-read-ergonomics`) remains CLOSED, historical. |
| **Activation HEAD** | 74221bbc (`develop` tip after PR #740 merge; `v0.7.0-dev.2`) -- UNCHANGED this burst (no merge occurred) |

## Phase Progress (recent; full history in cycles/cycle-001/burst-log.md, cycles/cycle-002/burst-log.md, and factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| F3-STORY-DECOMPOSITION | **COMPLETE** | 2026-08-26 | story-writer (self-certified; state-manager sanity check) | 5 stories (S-580-1, S-578-1..4), all `status: ready`, acyclic 3-wave plan (wave1: S-580-1+S-578-1; wave2: S-578-2+S-578-3; wave3: S-578-4). 19 BCs + 32 VPs fully covered. `total_stories` 156->161. Full detail: `cycles/cycle-002/burst-log.md` Burst 9. | n/a -- decomposition, not an adversary pass |
| F4-WAVE-1-S-578-1 | **DELIVERED + MERGED** | 2026-08-26 | per-story-delivery pipeline (Red Gate + 3/3 adversary CLEAN) | S-578-1 (`--field` value-kind hint-syntax parser, BC-3.4.026/031). PR #739 squash-merged to `develop` @ `993de833`. Red Gate PASS; 3/3 per-story convergence CLEAN; interim guard; demos recorded; citation-fix detour resolved pre-merge, no scope change. Full detail: `cycles/cycle-002/burst-log.md` Burst 10. | 3/3 CONSECUTIVE CLEAN -- per-story converged |
| F4-WAVE-1-COMPLETE | **COMPLETE** | 2026-08-26 | per-story-delivery pipeline (5-round adversarial convergence) + pr-reviewer (PR #740) | S-580-1 (`jr field options <field>` command, BC-X.14.001-004). PR #740 squash-merged to `develop` @ `74221bbc`. 5-round convergence incl. a CWE-835 infinite-loop fix and a BC-3.3.010 citation-unblock detour. **Wave 1 now fully closed** -- both S-578-1 and S-580-1 merged. 6 NON-BLOCKING pr-reviewer follow-ups tracked as debt (see Drift/Standing Items). Full detail: `cycles/cycle-002/burst-log.md` Burst 11. | 29→24→21→7→4→3→0 (5-round converge to CLEAN) |
| WRAP-F4-WAVE2-PAUSE | **PAUSED** | 2026-08-26 | human (`/wrap`) | Human-requested session wrap during Wave 2 S-578-2 Step 2 (stub generation dispatched then interrupted during the read phase -- no changes landed). Wave 1 COMPLETE unaffected; `develop` remains @ `74221bbc`. Worktree `.worktrees/S-578-2` (branch `feature/S-578-2-edit-field-dispatch`) clean, 0 commits ahead of develop base. Full detail: Session Resume Checkpoint below. | n/a -- pause event, not an adversary pass |

## Current Phase Steps (cycle-002, phase F4; last 5)

| Step | Status | Notes |
|------|--------|-------|
| S-578-1 PR #739 merged | **MERGED @ 993de833** | Squash-merged to `develop`. `activation_head` advanced `00df3823` -> `993de833`. STORY-INDEX.md S-578-1 row set to `status: completed`. |
| Wave 1 story S-580-1 dispatched | **DELIVERED** | per-story-delivery pipeline; 5-round adversarial convergence (29->24->21->7->4->3->0 findings), CWE-835 infinite-loop fix, BC-3.3.010 citation-unblock detour resolved without scope change. |
| S-580-1 PR #740 merged | **MERGED @ 74221bbc** | Squash-merged to `develop`. `activation_head` advanced `993de833` -> `74221bbc`. STORY-INDEX.md S-580-1 row set to `status: completed`. |
| Wave 1 closure confirmed | **COMPLETE** | Both Wave 1 stories (`status: completed`, PRs merged) verified in `sprint-state.yaml` and `STORY-INDEX.md`. Wave 2 (S-578-2, S-578-3) unblocked for dispatch. |
| Wave 2 S-578-2 dispatch paused (human `/wrap`) | **PAUSED at Step 2** | Stub-generation step dispatched then interrupted by `/wrap` during the read phase; no changes landed. Worktree `.worktrees/S-578-2` (branch `feature/S-578-2-edit-field-dispatch`) exists at develop base `74221bbc`, CLEAN, 0 commits ahead. Resume: re-dispatch Step 2. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-310 | Reverses DEC-188: `--field` alone on the platform `issue create` path no longer exits 64 -- resolves via `createmeta` instead (BC-3.3.010/BC-3.8.012) | Non-JSM `--field` support was the point of issue #578; the DEC-188 guard predates that scope and now blocks it needlessly | F2 | 2026-08-25 (proposed as DEC-307, renumbered); **REGISTERED 2026-08-26 (human-approved at F2 gate)** | product-owner (authored); human (approved) |
| F-3 | D2 collision-guard extension to the JSM create path -- **RESOLVED: retain the pre-existing last-wins behavior**, no guard extension | BC-3.8.008's JSM dedicated-flag semantics already diverge from platform (several flags silently IGNORED, not merged) | F2 | 2026-08-26 (flagged round-4 as MED-1/F-3; resolved at the F2 human gate) | human (decided) |
| ADR-0019 | Context mechanism for `jr field options` is `createmeta` (PRIMARY platform) / requesttype-fields (PRIMARY JSM) / `editmeta` (FALLBACK); cascading-select delimiter is `>`; § Amendment F-B/D1-D4/D2-correction | Ranked recommendation from `research/field-dx-context-mechanism-2026-08-25.md`; closes several structural/silent-drop gaps | F1/F2 | 2026-08-25 (Accepted); amendments through round-6 | architect |
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

`cycle-001` (`list-read-ergonomics`) CLOSED at F7 (DEC-309): all five convergence dimensions plus Regression PASS (MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized 2026-08-24) -- historical, unchanged this burst.

`cycle-002` (`field-dx`) F2 CONVERGED (streak-6) and F2 human gate APPROVED 2026-08-26 (DEC-310 registered, F-3 resolved, spec v2.0.0 MAJOR applied). F3 (incremental stories) COMPLETE: 5 stories decomposed, acyclic 3-wave plan, full 19-BC + 32-VP coverage. F4 (delta implementation) Wave 1 is COMPLETE: both S-578-1 (PR #739 @ `993de833`) and S-580-1 (PR #740 @ `74221bbc`) delivered + merged, each with clean per-story adversary convergence. **Wave 2 dispatch of S-578-2 began this session (Step 2, stub generation) and was PAUSED via human `/wrap` before any changes landed** -- worktree clean, 0 commits ahead. No BC/VP/holdout counts changed (719/32/106).

## Concurrent Cycles

Two tracked cycles. `cycle-001` (`list-read-ergonomics`) is CLOSED, historical (see `cycles/cycle-001/`). `cycle-002` (`field-dx`) is ACTIVE, **F4 Wave 1 COMPLETE, Wave 2 IN PROGRESS and PAUSED** (human `/wrap`, S-578-2 at Step 2, no changes landed). No greenfield or other concurrent cycle is in flight.

## Session Resume Checkpoint

**Cycle:** Field DX Feature Mode cycle (`cycle-002`) -- GitHub issues #580 (`jr field options <field>`) + #578 (`--field` value-kind hint syntax + non-JSM `issue create --field`). 5-story decomposition, full F1-F7 lifecycle, DTU not required.

**Position:** Phase **F4** (delta implementation), pipeline **PAUSED** via human `/wrap` on 2026-08-26. Wave 1 of 3: **COMPLETE** (S-578-1 PR #739 @ `993de833`, S-580-1 PR #740 @ `74221bbc`, both merged). Wave 2 of 3: **IN PROGRESS, PAUSED** -- S-578-2 (`issue edit --field` hint dispatch) is at **Step 2** (stub generation): dispatched, then interrupted by `/wrap` during the read phase. **No changes landed** -- worktree `.worktrees/S-578-2` (branch `feature/S-578-2-edit-field-dispatch`) exists at develop base `74221bbc`, CLEAN (0 commits ahead). **On resume: re-dispatch Step 2 (stub generation) for S-578-2.**

**F1/F2/F3:** COMPLETE + human-approved (unchanged). Counts: 719 total BCs (BC-INDEX v6.82), 32 VPs, 106 holdout scenarios -- unchanged.

**F4 Wave status:**
- **Wave 1 -- COMPLETE (2026-08-26):** S-578-1 (field value-kind hint-syntax parser, BC-3.4.026/031, 5 pts, PR #739 @ `993de833`) + S-580-1 (`jr field options <field>` command, BC-X.14.001-004, 8 pts, PR #740 @ `74221bbc`, 5-round adversarial convergence + CWE-835 fix). `activation_head` = `74221bbc`.
- **Wave 2 -- IN PROGRESS, PAUSED:** S-578-2 (`issue edit --field` hint dispatch, 13 pts, `depends_on:[S-578-1]` satisfied) at Step 2, interrupted, no changes landed. S-578-3 (JSM `issue create --field` hint dispatch, 8 pts, same dependency) is next -- deliver **sequentially after S-578-2**, not in parallel, because both share the interim `reject_unsupported_hint_kinds` guard in `create.rs`.
- **Wave 3 -- blocked on Wave 2:** S-578-4 (platform `issue create --field` + DEC-188 reversal via DEC-310, 13 pts) reuses S-580-1's `get_createmeta_fields` verbatim.

**Guard-replacement Red-Gate strategy for S-578-2/S-578-3 (documented so resume doesn't re-derive it):** KEEP the interim `reject_unsupported_hint_kinds` guard (`create.rs`, called from `edit.rs` + `jsm_create.rs`) through each story's stub + test steps -- it is what makes the Red Gate meaningfully red without a fully-dispatched implementation. REMOVE its call-site and implement real `:kind` dispatch only in the IMPLEMENT step. S-578-2 removes the `edit.rs` guard call-site. S-578-3 removes the `jsm_create.rs` guard call-site AND the now-unused helper function itself (last caller). Update/rewrite S-578-1's interim guard tests (e.g. `test_edit_field_kind_hint_exits_64_pending_dispatch_s578_1`) as each dispatch lands -- they assert the OLD reject-64 behavior and must flip to asserting real dispatch behavior story-by-story, not be deleted wholesale.

**Tracked debt (unchanged + confirmed owed):**
1. DEC-namespace disambiguation question (open, tracked debt).
2. Reversal-propagation checklist for PO/state-manager workflow (not built).
3. `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` lesson (round-6, not yet actioned).
4. 4 residual LOW doc-hygiene items from streak-6 (see Drift/Standing Items) -- non-blocking, owed before/at cycle close.
5. 6 PR #740 pr-reviewer NON-BLOCKING follow-ups (S1 pagination page_size-vs-maxResults edge case; S2 `.or(project_override)` untested at unit level; S3 test-name mismatch; N1 `#[serde(alias="results")]` citation unverified; N2 CLAUDE.md `src/cli/` tree missing `field.rs`) -- see Drift/Standing Items; none block Wave 2/3.
6. `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE` -- now upgradeable to enforced symbol-form since S-580-1 implemented `get_createmeta_fields`. Not yet actioned.
7. Standing, pre-existing, NOT field-dx-scoped: `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` -- ~145 historical stale input-hash artifacts, factory-wide.

**Pending human decisions / blockers:** NONE new this pause. Full-autonomous-run mandate stands -- this pause is a human-initiated `/wrap`, not a blocked-on-decision state.

**In flight / uncommitted at this checkpoint:** `.worktrees/S-578-2` exists, CLEAN, 0 commits ahead of develop base `74221bbc` -- nothing to lose, nothing to commit. `STATE.md` and `sidecar-learning.md` are committed to `factory-artifacts` together as part of this wrap's commit. No product-repo (`jira-cli`) working-tree changes outside the worktree.

**Resume command:** `/vsdd-factory:next-step` (reads `STATE.md`, re-dispatches Step 2 of S-578-2 to continue Wave 2 delivery).

**Superseded checkpoint:** the F4-WAVE-1-COMPLETE checkpoint (v3.19, 2026-08-26) is archived to `cycles/cycle-002/session-checkpoints.md`. Rounds 2-6 checkpoints, the WRAP-F2-CONVERGENCE-PAUSE checkpoint, the F3-STORY-DECOMPOSITION-COMPLETE checkpoint, and the F4-WAVE-1-IN-PROGRESS checkpoint remain archived there. The `list-read-ergonomics` cycle-001 CLOSED-position checkpoint (v3.05, 2026-08-25) remains archived at `cycles/cycle-001/session-checkpoints.md`.

## Historical Content

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-6 = F2 adversary rounds 1-6; Burst 7 = streak-6 convergence-close; Burst 8 = F2 human gate APPROVED + DEC-310 registration + F2->F3 transition; Burst 9 = F3 story decomposition COMPLETE; Burst 10 = F4 Wave 1 S-578-1 delivered + merged; Burst 11 = F4 Wave 1 S-580-1 delivered + merged, WAVE 1 COMPLETE) |
| cycle-001 convergence trajectory | `cycles/cycle-001/convergence-trajectory.md` |
| cycle-001 session checkpoints | `cycles/cycle-001/session-checkpoints.md` |
| cycle-002 session checkpoints | `cycles/cycle-002/session-checkpoints.md` (WRAP-F2-CONVERGENCE-PAUSE + F2-ROUND2..6-FIX-CHAIN + F2-CONVERGENCE-CLOSE-STREAK-6 + F2-GATE-APPROVED-F3-TRANSITION + F3-STORY-DECOMPOSITION-COMPLETE + F4-WAVE-1-IN-PROGRESS + F4-WAVE-1-COMPLETE archived here) |
| cycle-001 lessons learned | `cycles/cycle-001/lessons.md` |
| cycle-002 lessons learned | `cycles/cycle-002/lessons.md` (round-6's [process-gap] count-reconciliation lesson) |
| cycle-001 resolved blockers | `cycles/cycle-001/blocking-issues-resolved.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**New (2026-08-26, PR #740 pr-reviewer NON-BLOCKING follow-ups):**
- `S-580-1-PR740-S1` (LOW) -- `get_createmeta_fields`: when the API returns a total-absent page with a short page (fewer results than `page_size`/`maxResults`), pagination may truncate early. Defensive-only; not observed live. Tracked debt.
- `S-580-1-PR740-S2` (LOW) -- the `.or(project_override)` fallback for the global `--project` override on `jr field options` is untested at the unit level; a mutation-testing survivor flagged it, though the full `cargo mutants` CI run passed. Tracked debt -- add a targeted unit test.
- `S-580-1-PR740-S3` (LOW, naming) -- a test name references `partial_match` but its body actually exercises `search_field_list`. Rename for accuracy. Tracked debt.
- `S-580-1-PR740-N1` (LOW, nit) -- the `#[serde(alias = "results")]` citation on a `FieldOption`-adjacent struct is unverified against the live Jira API shape. Tracked debt -- confirm or drop the alias.
- `S-580-1-PR740-N2` (LOW, doc) -- CLAUDE.md's `src/cli/` tree is missing `field.rs` / the `jr field` command family added by S-580-1. Tracked debt -- add to the architecture tree on next CLAUDE.md pass.
- `BC-3.3.010-CITATION-UPGRADE-ELIGIBLE` (LOW, spec-hygiene) -- BC-3.3.010's `get_createmeta_fields` citation was reworded to prose during S-578-1's CI unblock (the function did not exist yet). It now exists (implemented by S-580-1) and is eligible for upgrade back to enforced symbol-form. Tracked as a spec-hygiene follow-up, not blocking.

**Still open (unchanged from streak-6, LOW doc-hygiene, non-blocking -- do NOT block F4):**
- `PRD-DELTA-ROUND2-STEP2A-STALE-NARRATION` (LOW) -- `prd-delta-field-dx.md`'s round-2 step-2a narration is stale. Tracked for cycle close.
- `PLATFORM-ASSET-WIRE-SHAPE-UNVERIFIED` (LOW) -- the platform `:asset` wire-shape carries an UNVERIFIED note. Tracked for cycle close.
- `M1-EDITMETA-STATUS-PERMISSION-CAVEAT` (LOW) -- M1 (`jr field options`)'s editmeta FALLBACK path needs an explicit status/permission-dependency caveat. Tracked for cycle close.
- `PRD-DELTA-SUMMARY-AMENDED-BC-COUNT-STALE` (LOW) -- `prd-delta-field-dx.md`'s Summary section says "9 amended BCs" but should include BC-3.4.021/028/030. Tracked for cycle close.

**Still open (2026-08-26):**
- `DEC-NAMESPACE-COLLISION-RISK` (LOW, process question) -- spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` numbering prefix with no central registry. Remains tracked debt, revisit at a future cycle close.
- `BC-INDEX-GUARD-GAP` (LOW, unchanged) -- no automated guard ties BC-INDEX.md prose to BC-body H1/text; the specific round-3 drift instance is fixed.
- `GUARD-SCOPE-COPY-PASTE-PATTERN` (LOW/process, round-5, unchanged) -- candidate spec-authoring checklist item.
- `COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN` (LOW/process, round-6, unchanged) -- sibling failure mode to `GUARD-SCOPE-COPY-PASTE-PATTERN`. Logged in `cycles/cycle-002/lessons.md`.

**New (2026-08-25):**
- `HOLDOUT-COVERAGE-GAP-LIST-READ-ERGONOMICS-FLAGS` (LOW) -- maintenance sweep flagged missing holdout scenarios for the 4 new `list-read-ergonomics` flags.
- `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` (LOW) -- maintenance sweep flagged declared vs. actual story-file count drift in STORY-INDEX.md (pre-existing, unrelated to field-dx stories, which were verified consistent).
- Candidate: reactivate vsdd-factory plugin rc.20 to rc.23 (orphaned-version drift).

**Standing (unchanged):**
- 5 cargo Dependabot PRs held open pending `syn 2.0`-vs-`3.0` convergence.
- `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001` ratification.
- `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` hygiene sweep -- ~145 historical stale `input-hash` artifacts across closed cycles factory-wide; pre-existing systemic drift, standing debt, **not** a field-dx / cycle-002 item.
- 10-story SELF-IMPROVEMENT `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready`).
