---
document_type: pipeline-state
level: ops
version: "4.12"
status: active
producer: state-manager
timestamp: 2026-09-11T12:47:09Z
phase: "PAUSED 2026-09-11. cycle-007 (auth-correctness-dx) OPEN, Feature Mode. Phase F1 (delta analysis) APPROVED 2026-09-10 (DEC-354) -- 6-issue scope (#784/#786-narrowed/#787/#788/#790/#783); #785 DEFERRED (parked). Phase F2 (spec evolution) APPROVED 2026-09-10 (DEC-355) -- 3 new BCs BC-1.6.048/049/050 + amendments to BC-1.4.032/033/034/BC-1.6.047, 6 new VPs VP-AUTHDX-024..029, spec 2.2.0->2.3.0 MINOR. Phase F3 (incremental story decomposition) HUMAN GATE APPROVED 2026-09-11 (DEC-356) -- 5 new stories (S-cycle7-credential-absence-fix closes #784+#786, S-cycle7-auth-state-derivation #788, S-cycle7-auth-status-json #787 depends-on auth-state-derivation, S-cycle7-oauth-help-text-fix #790, S-cycle7-readme-migration-note #783), 28 points, 2 waves (Wave 1 A/B1/C/D=20pts, Wave 2 B2=8pts), acyclic (B1->B2 only cross-story edge); 11 total adversary story-review passes to zero-novelty convergence preceded the gate. Phase F4 (delta implementation) STARTED then PAUSED at this session wrap -- the F4 regression-baseline sub-agent was IN-FLIGHT and was cleanly ABANDONED (a re-runnable read-only measurement with no committable state; no worktrees or code were produced). No worktrees/code/PRs exist for cycle-007 yet. Core touch point src/api/auth.rs remains flagged HIGH regression risk (3rd consecutive cycle touching this file). All six prior cycles (001-006) remain CLOSED, historical. Full prior narrative: F1/F2/F3 Phase Progress rows + cycles/cycle-007/session-checkpoints.md."
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-11, v4.12, state-manager -- SESSION-WRAP-PAUSE-2026-09-11: minted DEC-356 recording the human's F3 story-decomposition scope-gate approval (2026-09-11 -- 5 new stories, 28 points, 2 waves, acyclic B1->B2, proceeding to F4) and paused the pipeline at F4-start for session clear; the F4 regression-baseline sub-agent was in-flight and was cleanly abandoned (re-runnable, no committable state; re-run at F4 Step 1 on resume); zero worktrees/code/PRs exist for cycle-007. Archived the prior v4.11 Session Resume Checkpoint to cycles/cycle-007/session-checkpoints.md and wrote one new checkpoint. Updated the F3 Phase Progress row's Status cell in place (CONVERGED -> APPROVED (DEC-356)) and appended a new SESSION-WRAP-PAUSE-2026-09-11 row, archiving the oldest row (E2E-CI-DYNAMIC-TESTS-DELIVERED-2026-09-10) to cycles/HISTORY-PHASE-PROGRESS.md to hold the live table at 7 rows. Counts unchanged: total_bcs 757, VP count 82, holdout scenarios 118, total_stories 180. Committed the stray uncommitted churn present at wrap time (regression-state.json, sidecar-learning.md, code-delivery/PR-800/, code-delivery/PR-801/) in this same atomic commit per the wrap clean-tree requirement -- an explicit exception to the usual per-burst stray-churn-stays-uncommitted convention. version: 4.11->4.12 (exactly one bump, no double-bump)."
current_step: "D-chain cite D-053, D-2026 latest brownfield. SESSION-WRAP-PAUSE-2026-09-11: state-manager minted DEC-356 (the human's F3 story-decomposition scope-gate approval, 2026-09-11 -- 5 new stories, 28 points, 2 waves, acyclic B1->B2, proceeding to F4) and paused the pipeline at F4-start for session clear, in a single atomic burst on factory-artifacts (TD-VSDD-053). The F4 regression-baseline sub-agent was in-flight and was cleanly abandoned (re-runnable read-only measurement, no committable state; re-run at F4 Step 1 on resume). No worktrees, code, or PRs exist for cycle-007 yet. trajectory-tail →1→3→0→2 unchanged (no cycle-007 code exists; the F5 code-review loop this counter tracks has not started)."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-007-auth-correctness-dx (F1 APPROVED via DEC-354; F2 APPROVED via DEC-355; F3 APPROVED via DEC-356; F4 delta implementation STARTED then PAUSED at session wrap)"
feature_mode_bundle: "auth-correctness-dx: GitHub issues #784, #786 (narrowed), #787, #788, #790, #783 (6-issue F1-gate-approved scope); #785 DEFERRED"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: "SOH-ATTACHMENTS-1 CONVERGED + CLOSED 2026-07-25 (DEC-186, 5-dim PASS, MAXIMUM_VIABLE_REFINEMENT_REACHED); full text: cycles/CYCLE-SUMMARY.md#phase_3_status"
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 as v0.7.0-dev.3 (DEC-311). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_002_status"
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 as v0.7.0-dev.4 (PR #767). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_003_status"
cycle_004_status: "windows-correctness -- CLOSED + RELEASED 2026-09-06 as v0.7.0-dev.5 (DEC-343, PR #777). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_004_status"
cycle_005_status: "adf-mentions -- CLOSED, NO RELEASE, 2026-09-09 (DEC-353; closes GitHub #674; ships on develop @ cef4a021, tag deferred to a future release riding cycle-005+006). F1-F7 all APPROVED (DEC-344/345/346/347/352/353); full text: cycles/CYCLE-SUMMARY.md#cycle_005_status"
cycle_006_status: "mutants-ci-sharding -- CLOSED, NO RELEASE, 2026-09-09 (DEC-348/349/350/351; CI-infra-only, shipped binary byte-identical). F1-F7 all APPROVED; PR #791 merged to develop @ a9168212; full text: cycles/CYCLE-SUMMARY.md#cycle_006_status"
activation_head: "a9168212"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-11, SESSION-WRAP-PAUSE-2026-09-11 checkpoint -- this is the
     /vsdd-factory:wrap Step 4 checkpoint-write. `pipeline:` flips ACTIVE -> PAUSED this burst;
     cycle-007 (auth-correctness-dx) is the sole OPEN cycle, now with F1/F2/F3 all HUMAN GATE
     APPROVED (DEC-354/DEC-355/DEC-356) and Phase F4 (delta implementation) STARTED then PAUSED
     at this wrap; all six prior cycles (001-006) remain CLOSED, historical; line count refreshed
     after this burst's Write):
     This is a SESSION-LIFECYCLE PAUSE burst (state-manager, per orchestrator instruction -- mints
     DEC-356 recording the human's F3 scope-gate approval, then pauses the pipeline for session
     clear). `pipeline:` ACTIVE -> PAUSED. `current_cycle:` frontmatter updated to reflect F1/F2/F3
     all APPROVED and F4 STARTED-then-PAUSED. `phase:`/`current_step:`/`last_amended:` rewritten
     via the verbatim-strict chain (each field's prior chained value is NOT nested inside the new
     one -- overwritten per the last_amended write-path discipline), preserving `D-chain cite
     D-053, D-2026 latest brownfield.` and trajectory-tail `→1→3→0→2` (unchanged -- no cycle-007
     code exists yet; F4 has not produced any committable artifact). `version:` 4.11 -> 4.12
     (exactly one bump, no double-bump).
     Minted DEC-356 (F3 human-gate approval, 2026-09-11) in the Decisions Log -- the placeholder
     "no DEC yet for cycle-007 F3" row from the prior burst is replaced with the real decision
     record. Updated the `F3-STORY-DECOMPOSITION-CYCLE-007` Phase Progress row's Status cell in
     place (`CONVERGED` -> `APPROVED (DEC-356)`) and its Gate column (human gate PENDING ->
     APPROVED). Appended ONE new Phase Progress row (`SESSION-WRAP-PAUSE-2026-09-11`, status
     `COMPLETE`) recording the pause event itself; archived the table's oldest row
     (`E2E-CI-DYNAMIC-TESTS-DELIVERED-2026-09-10`) to `cycles/HISTORY-PHASE-PROGRESS.md` to hold
     the live table at 7 rows per the "recent 7" convention.
     Archived the prior (v4.11) `## Session Resume Checkpoint` to
     `cycles/cycle-007/session-checkpoints.md` (new file, session-checkpoints template, marked
     Superseded 2026-09-11) BEFORE writing the one new checkpoint below -- per the "only the
     LATEST checkpoint lives in STATE.md" rule.
     Counts: total_bcs 757, VP count 82, holdout scenarios 118, total_stories 180 -- ALL UNCHANGED
     this burst (a session-lifecycle pause checkpoint mints no spec/story/holdout-corpus
     artifacts; DEC-356 records a scope-gate approval, not a spec delta). All count surfaces
     re-verified consistent via `scripts/check-spec-counts.sh` + `scripts/check-bc-cumulative-
     counts.sh`, both green (757 total across 9 files) before this commit -- unaffected by this
     burst's scope, re-run as a safety check per protocol.
     CLEAN-TREE REQUIREMENT (wrap PC-12): per orchestrator instruction, this burst's commit
     includes ALL currently-uncommitted `.factory/` content, not just STATE.md -- the stray churn
     present at wrap time (`regression-state.json`, `sidecar-learning.md`,
     `code-delivery/PR-800/`, `code-delivery/PR-801/`) is committed in this same atomic commit so
     `git -C .factory status --porcelain` is EMPTY afterward. This is an explicit, one-burst
     exception to the usual per-burst convention of leaving unrelated stray churn uncommitted
     (durability + a clean tree across the session-clear boundary takes priority for a wrap).
     soft target 200 lines; hard cap 500 lines. 242 lines (wc-l) (this file, this Write) -- down
     from the pre-burst 250 lines (DEC-356 mint + new SESSION-WRAP-PAUSE-2026-09-11 row added
     length; archiving the oldest Phase Progress row + condensing the replacement Session Resume
     Checkpoint net-reduced the total).
     margin from soft-target = 242 - 200 (OVER the soft target; acceptable transient per the
     extract-history/keep-live-state principle -- a future `/compact-state` pass will re-condense
     once cycle-007 resumes and runs a few more bursts).
     margin from actual = 500 - 242 (headroom remains before the hard cap).
     RECOVERY CONTEXT: no crash this burst -- a planned, human-directed session-wrap pause event,
     verified via a fresh read of this file before writing (still v4.11/F3-converged-awaiting-
     gate/pipeline-ACTIVE, prior state intact) -- this Write/commit is the first and only landing
     of this event.
     Factory lock: no `factory_lock` frontmatter block is present in this STATE.md and the
     lock-write/verify-sha-currency scripts are not provisioned in this repo -- the renew/unlock
     step this burst is therefore a no-op (confirmed via `factory-lock-write.sh renew`, which
     printed "no factory_lock block present"), noted rather than fabricated. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **PAUSED** -- session-wrap pause 2026-09-11 (`/vsdd-factory:wrap` Step 4 checkpoint). cycle-007 (`auth-correctness-dx`) OPEN, Feature Mode; Phase F1 APPROVED (DEC-354, 2026-09-10); Phase F2 (spec evolution) APPROVED (DEC-355, 2026-09-10); Phase F3 (incremental story decomposition) HUMAN GATE APPROVED (DEC-356, 2026-09-11); Phase F4 (delta implementation) STARTED then PAUSED at this wrap -- the regression-baseline sub-agent was in-flight and was cleanly abandoned (re-run at resume). All six prior cycles (001-006) remain CLOSED -- see `cycles/CYCLE-SUMMARY.md` |
| **trajectory-tail** | →1→3→0→2 (unchanged -- no cycle-007 code exists yet; the F5 code-review loop this counter tracks has not started) |
| **Last Updated** | 2026-09-11, SESSION-WRAP-PAUSE-2026-09-11: cycle-007 F3 scope gate HUMAN GATE APPROVED (DEC-356), pipeline PAUSED at F4-start for session clear. trajectory-tail →1→3→0→2 (unchanged). Full prior per-cycle history: `cycles/CYCLE-SUMMARY.md` |
| **Current Phase** | cycle-007 (`auth-correctness-dx`) Phase F4 (delta implementation) -- **STARTED then PAUSED at session wrap.** F3 (incremental story decomposition) HUMAN GATE APPROVED via DEC-356 (2026-09-11): 5 new stories (28 points, 2 waves): `S-cycle7-credential-absence-fix` (closes #784+#786), `S-cycle7-auth-state-derivation` (#788), `S-cycle7-auth-status-json` (#787, depends on auth-state-derivation), `S-cycle7-oauth-help-text-fix` (#790), `S-cycle7-readme-migration-note` (#783). Wave 1 (A/B1/C/D, 20pts) + Wave 2 (B2, 8pts), acyclic (B1->B2 only cross-story edge). The F4 regression-baseline sub-agent (Step 1) was IN-FLIGHT at wrap and was cleanly ABANDONED (re-runnable read-only measurement, no committable state) -- resume by re-running it before creating any Wave-1 worktrees. Core touch point `src/api/auth.rs` remains HIGH regression risk (3rd consecutive cycle). Detail: `cycles/cycle-007/phase-f3-stories/`. cycle-001 through cycle-006 all CLOSED, historical -- see `cycles/CYCLE-SUMMARY.md`. |
| **Activation HEAD** | `a9168212` (unchanged -- no release tag cut; `develop`'s real tip is `14e695ae`) |

## Phase Progress (recent 7; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **MUTANTS-NIGHTLY-REBALANCE-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Nightly mutation run `34478602590` ended `cancelled` (4/16 shards, PARTIAL data). Fix via PR #799 (merged @ `78aeb86c`): rebalanced N=16->24 shards + timeout 240->300 + completion-sentinel guard. New follow-up: `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` (see Drift/Standing Items below). | counts unchanged; no DEC minted |
| **STATE-MD-COMPACT-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping (`/compact-state` skill), state-manager-executed, no quality gate | Extracted historical content (frontmatter cycle-status prose, SIZE BUDGET banner, 2 oldest Phase Progress rows, full Current-Phase-Steps checklist, Decisions-Log narrative notes, resolved+open Drift/Standing-Items detail, cycle-002/003/004 Skip Log rows, verbose Historical-Content descriptions, full live Session-Resume-Checkpoint text) into `cycles/` files -- nothing deleted, every pointer resolves. STATE.md 447->196 lines, single full-content Write. `STATE-MD-OVER-SOFT-TARGET` marked RESOLVED. | counts unchanged (754/76/118/175); no DEC minted -- maintenance event |
| **MAINTENANCE-SWEEP-2026-09-10** | **COMPLETE, FULLY CLOSED** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Human-requested maintenance sweep CLOSED in one atomic burst (TD-VSDD-053): 2 read-only scans (dependency audit -- `develop` dependency-clean, 0 RUSTSEC advisories, 1 actionable LOW: `chacha20` 0.10.0 yanked; doc drift -- PR #797 compaction verified clean, 8 findings) + open-PR triage (10 open PRs, `auto_merge=false`). Fix PR #800 (`chacha20` 0.10.0->0.10.2) + doc-sync PR #801 opened. 3 factory doc-hygiene items (`CYCLE5-F7-DOC-1`, `CYCLE5-F7-DOC-2`, `CYCLE5-STEP45-LOW-1`) RESOLVED same commit. 5 cargo Dependabot PRs (syn) re-confirmed correctly held; `#792`/`#628` deferred by human. **CLOSING UPDATE (same day):** all 4 merges (`#800`, `#801`, `#779`, `#754`) subsequently MERGED to `develop` by human action; `develop` tip advanced `78aeb86c` -> `14e695ae` (`#779`=`211ae959`, `#754`=`d4760cd5`, `#800`=`522f9ba2`, `#801`=`14e695ae`). Sweep is now fully closed, zero outstanding actions. Full report: `maintenance/sweep-report-2026-09-10.md`. | counts unchanged (754/76/118/175); no DEC minted |
| **F1-DELTA-ANALYSIS-CYCLE-007** | **APPROVED (DEC-354)** | 2026-09-10 | Feature Mode F1 human scope gate | architect's delta analysis for the 7-issue auth bundle HUMAN GATE APPROVED 2026-09-10: 6-issue scope (#784/#786/#787/#788/#790/#783); #785 DEFERRED (parked); #786 NARROWED (only the two `src/api/auth.rs` credential-absence sites -> exit 2, unknown-profile stays 64, BC-1.1.004 unchanged); #787+#788 share one auth_method-aware "configured" vocabulary. Core touch point `src/api/auth.rs` (HIGH regression risk, 3rd consecutive cycle). Detail: `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`. | counts unchanged (754/76/118/175) at F1; DEC-354 minted |
| **F2-SPEC-EVOLUTION-CYCLE-007** | **APPROVED (DEC-355)** | 2026-09-10 | Feature Mode F2 human scope gate | product-owner + formal-verifier's spec delta for the 6-issue scope HUMAN GATE APPROVED 2026-09-10: 3 new BCs (BC-1.6.048/049/050) + amendments to BC-1.4.032/033/034 + BC-1.6.047, 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 (MINOR); 10 adversary passes total, 3 consecutive CLEAN (8/9/10) to convergence prior to the gate. Detail: `phase-f2-spec-evolution/cycle-007-prd-delta.md`, `phase-f2-spec-evolution/cycle-007-verification-delta.md`. | counts: BCs 754->757, VPs 76->82 (set at F2); DEC-355 minted |
| **F3-STORY-DECOMPOSITION-CYCLE-007** | **APPROVED (DEC-356)** | 2026-09-11 | Feature Mode F3, 11-pass adversarial story convergence, human gate APPROVED | story-writer decomposed the F2-approved spec delta into 5 new stories (`S-cycle7-credential-absence-fix` closes #784+#786, `S-cycle7-auth-state-derivation` #788, `S-cycle7-auth-status-json` #787 depends-on auth-state-derivation, `S-cycle7-oauth-help-text-fix` #790, `S-cycle7-readme-migration-note` #783), 28 points, 2 waves (Wave 1 A/B1/C/D=20pts, Wave 2 B2=8pts), acyclic (B1->B2 only cross-story edge, Kahn-layering proof). 11 total adversary story-review passes to convergence; recurring findings (renderer purity/injection-seam boundary discipline, mutation-scope `examine_globs` exclude_re + `src/api/auth.rs` FIX-F6-A deferral, existing pre-cycle-007 keyring-gated test reconciliation via Task 7a on `S-cycle7-credential-absence-fix`) all resolved; pass 11 zero-novelty. **HUMAN GATE APPROVED 2026-09-11 (DEC-356)** -- human approved proceeding to F4 as a standard 2-wave plan, honoring the A->B1 `auth.rs` merge-order note and accepting the `FIX-F6-A` mutation-scope deferral. Detail: `cycles/cycle-007/phase-f3-stories/`. | 5 stories/28pts/2 waves; story count 175->180. DEC-356 minted (F3 gate) |
| **SESSION-WRAP-PAUSE-2026-09-11** | **COMPLETE** | 2026-09-11 | Session-lifecycle pause checkpoint, state-manager-executed, no quality gate | Paused cycle-007 at F4-start (F3 APPROVED via DEC-356 immediately prior in this same burst); the F4 regression-baseline sub-agent was in-flight and was cleanly abandoned (re-runnable read-only measurement, no committable state; re-run at F4 Step 1 on resume). No worktrees, code, or PRs exist for cycle-007. `pipeline:` ACTIVE -> PAUSED. Committed all stray uncommitted `.factory/` churn present at wrap time in this same commit (clean-tree requirement). | counts unchanged; DEC-356 minted (recorded on the row above, same burst) |

## Current Phase Steps

**cycle-007 (`auth-correctness-dx`) is now PAUSED at the start of Phase F4.** F1 (delta analysis) was HUMAN GATE APPROVED 2026-09-10 as DEC-354 -- 6-issue scope (#784/#786-narrowed/#787/#788/#790/#783), #785 deferred. F2 (spec evolution) was then HUMAN GATE APPROVED 2026-09-10 as DEC-355 -- 3 new BCs (BC-1.6.048/049/050) + amendments to BC-1.4.032/033/034/BC-1.6.047, 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 (MINOR). F3 (incremental story decomposition) then converged at 11 total adversary story-review passes (zero-novelty at pass 11): story-writer authored 5 new stories under `cycles/cycle-007/phase-f3-stories/` (`S-cycle7-credential-absence-fix.md`, `S-cycle7-auth-state-derivation.md`, `S-cycle7-auth-status-json.md`, `S-cycle7-oauth-help-text-fix.md`, `S-cycle7-readme-migration-note.md`), plus `dependency-graph-extended.md` (acyclic proof, B1->B2 the only cross-story edge), `wave-schedule.md` (2 waves, Wave 1 A/B1/C/D=20pts, Wave 2 B2=8pts), and `wave-holdout-scenarios.md` (cross-story integration holdouts, cycle-scoped). **The human then APPROVED the F3 scope gate 2026-09-11, minted this burst as DEC-356** -- honoring the A->B1 `auth.rs` merge-order note and accepting the `FIX-F6-A` mutation-scope deferral. F4 (delta implementation) STARTED immediately after: a regression-baseline sub-agent (F4 Step 1) was dispatched and was IN-FLIGHT when the session-wrap request arrived; it was cleanly ABANDONED (a re-runnable read-only measurement -- it produces no committable state, no worktrees, no code). **Pipeline is now PAUSED for session clear.** No worktrees, code, or PRs exist for cycle-007. **Next step on resume:** re-run the F4 regression baseline (F4 Step 1), then create Wave-1 worktrees and begin per-story delivery -- Story A (`S-cycle7-credential-absence-fix`) first per the auth.rs merge-order note, then B1 (`S-cycle7-auth-state-derivation`); C (`oauth-help-text-fix`) + D (`readme-migration-note`) are parallelizable in Wave 1; Wave 2 = B2 (`S-cycle7-auth-status-json`, depends on B1). The last completed pipeline-phase checklist before this cycle was cycle-005 Burst 13 (F7 delta convergence, cycle CLOSE) -- its full 15-step checklist is preserved at `cycles/cycle-005/burst-log.md` (Appendix). MAINTENANCE-SWEEP-2026-09-10's steps are summarized in the Phase Progress row above and `maintenance/sweep-report-2026-09-10.md`.

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-356 | cycle-007 (`auth-correctness-dx`) Phase F3 (incremental story decomposition) **HUMAN GATE APPROVED**, 2026-09-11 -- the human reviewed the 5-story decomposition (28 points, 2 waves, acyclic dependency graph B1->B2) plus `dependency-graph-extended.md` and `wave-schedule.md`, and approved proceeding to Phase F4 (delta implementation) as a standard 2-wave plan -- honoring the A->B1 `auth.rs` merge-order note (Story A `S-cycle7-credential-absence-fix` lands before Story B1 `S-cycle7-auth-state-derivation` to avoid conflicting `src/api/auth.rs` edits within the same wave) and explicitly accepting the mutation-scope `auth.rs` `examine_globs` deferral to `FIX-F6-A`. | Human reviewed the F3 story-decomposition package (5 stories, dependency graph, wave schedule, wave holdout scenarios), already CONVERGED via 11 adversary passes (pass 11 zero-novelty) prior to the gate, and made an explicit approval ruling | F3 (gate) | 2026-09-11 | human (explicit F3-gate approval) |
| DEC-355 | cycle-007 (`auth-correctness-dx`) Phase F2 (spec evolution) **HUMAN GATE APPROVED**, 2026-09-10 -- the human reviewed the F2 spec delta (3 new BCs BC-1.6.048/049/050 + amendments to BC-1.4.032/033/034 + BC-1.6.047 in `specs/prd/bc-1-auth-identity.md`, 6 new VPs VP-AUTHDX-024..029, spec version 2.2.0->2.3.0 MINOR) and approved it, authorizing the pipeline to proceed to Phase F3 (incremental story decomposition). | Human reviewed the F2 PRD delta (`phase-f2-spec-evolution/cycle-007-prd-delta.md`) and verification delta (`phase-f2-spec-evolution/cycle-007-verification-delta.md`), both already CONVERGED via 10 adversary passes (3 consecutive CLEAN 8/9/10) prior to the gate, and made an explicit approval ruling | F2 (gate) | 2026-09-10 | human (explicit F2-gate approval) |
| DEC-354 | cycle-007 (`auth-correctness-dx`) Phase F1 (delta analysis) **HUMAN GATE APPROVED**, 2026-09-10 -- 6-issue scope: #784, #786 (narrowed), #787, #788, #790, #783. **#785** (headless `JR_EMAIL`/`JR_API_TOKEN` credential resolution) **DEFERRED** ("skip for now", parked, not scheduled into any cycle). **#786 NARROWED**: only the two `src/api/auth.rs` credential-absence sites (`load_api_token`'s no-stored-credentials and incomplete-pair branches) reclassify from `JrError::UserError`/exit 64 to `JrError::NotAuthenticated`/exit 2; the unrelated `auth status --profile <unknown>` unknown-profile site (BC-1.1.004) stays exit 64, unchanged -- the two failure classes are categorically distinct (profile has no credentials vs. profile doesn't exist). **#787 + #788 share one auth_method-aware "configured" vocabulary** -- a single shared BC (BC-1.6.048) defines the `unset`/`no-credentials`/`configured` state taxonomy that both `auth list`'s STATUS column (#788, BC-1.6.049) and `auth status --output json` (#787, BC-1.6.050) consume, rather than each issue growing its own ad hoc classification. | Human reviewed the architect's F1 delta-analysis report (`phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`) and the 3 open scope questions recorded at its §5, and made an explicit scope-gate ruling on each | F1 (gate) | 2026-09-10 | human (explicit F1-gate approval) |
| DEC-353 | cycle-005 (`adf-mentions`, GitHub #674) Phase F7 (delta convergence) **HUMAN GATE APPROVED / cycle CLOSED**, 2026-09-09, **NO RELEASE**. 5-dimensional delta convergence PASS: (1) Spec -- F2 approved (DEC-346); (2) Story/Test -- F3 approved (DEC-347), all 15+17 ACs realized; (3) Implementation -- merged to `develop @ cef4a021` (Wave 1 PR #778 @ `708c8b32`, Wave 2 PR #794 @ `0eaf4268`, F5 fix FIX-F5-001 PR #795 @ `cef4a021`); (4) Verification -- F6 HARDENED, 20/21 VPs covered, sharded mutation gate ran clean in-line on both product PRs; (5) Regression -- full CI green on `develop @ cef4a021`. **NO RELEASE CUT** -- feature ships on `develop`, unreleased; tag deferred to a future release riding cycle-005 + cycle-006 | Human reviewed the complete 5-dimensional delta-convergence evidence package and explicitly approved closing the cycle without cutting a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| (359 older decisions) | DEC-352 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-09 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**cycle-007 decisions detail (F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 APPROVED via DEC-356, F4 STARTED then PAUSED for session wrap):** full F1 delta-analysis report at `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`; issue triage sources at `phase-f1-delta-analysis/issue-triage-{auth,enhancement}-cluster-2026-09-10.md`; F2 PRD delta at `phase-f2-spec-evolution/cycle-007-prd-delta.md`; F2 verification delta at `phase-f2-spec-evolution/cycle-007-verification-delta.md`; F3 stories + dependency graph + wave schedule + wave holdout scenarios at `cycles/cycle-007/phase-f3-stories/`; session-wrap-pause checkpoints at `cycles/cycle-007/session-checkpoints.md`.

**cycle-005 decisions detail (Bursts 1-13, DEC-344 through DEC-353, CLOSED 2026-09-09, NO RELEASE):** full per-burst narrative preserved verbatim at `cycles/cycle-005/burst-log.md` (Appendix).

**cycle-006 decisions detail (Bursts 1-13, DEC-348 through DEC-351, CLOSED, superseded by DEC-353 as the prior max ID):** full per-burst narrative preserved verbatim at `cycles/cycle-006/burst-log.md` (Appendix).

## Skip Log

<!-- Full cycle-002/003/004 rows archived to cycles/HISTORY-SKIP-LOG.md; only the 2 most recent cycles' rows are kept inline. -->

| Step | Skipped? | Justification |
|------|----------|----------------|
| DTU creation (cycle-005) | yes | `dtu_required: false` -- targets Jira's own REST API user-search/mention surface, not a cloned third-party service. |
| UX Spec (cycle-005) | yes | `jr` is CLI-only; F1/F2 both confirmed no new UI surface -- `adf-mentions` is a write-path conversion feature only. |
| Demo recording (cycle-005, Wave 2) | yes | Human decision: demos skipped for `S-cycle5-mention-resolution-wiring` (backend/no-UI CLI). |
| F6 Kani formal verification (cycle-005) | yes | Not set up in repo; proptest substitution justified -- VP-674-008/018 + VP-674-006's depth-guard proptest cover the universal properties Kani would prove. 0-GAP. |
| F6 cargo-fuzz (cycle-005) | yes | Not set up in repo; proptest arbitrary-input substitution justified (VP-674-018, VP-674-008). 0-GAP. |
| F6 DTU adversarial testing / accessibility re-check (cycle-005) | yes | `dtu_required: false`; write-path ADF conversion feature, no UI surface, no cloned third-party service. |
| DTU creation (cycle-006) | yes | `dtu_required: no` -- `mutants-ci-sharding` is CI-tooling only. |
| UX Spec (cycle-006) | yes | `jr` is CLI-only; CI-workflow/policy-doc change with no product UI surface. |
| F5/F6 dedicated artifact subdirectory (cycle-006) | not skipped, folded | Feature-mode F5/F6 have no separate human gate; evidence folded directly into F7's 5-dimensional convergence record (DEC-351). |

**NOT a skip (tracked standing follow-up, human-owned post-close):** Live-Jira E2E round-trip acceptance (`H-NEW-MENTION-009`, AC-017) is **DEFERRED by human decision**, not skipped -- see `cycles/OPEN-STANDING-ITEMS.md`.

Older rows (cycle-001 through cycle-004, all CLOSED + RELEASED, historical): `cycles/HISTORY-SKIP-LOG.md`.

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/<cycle>/blocking-issues-resolved.md. -->

**NONE OPEN.** Zero Blocking Issues remain open anywhere in the factory. cycle-007 is OPEN, PAUSED at the start of F4 (not blocked on anything -- F3 approved via DEC-356, resume requires only re-running the abandoned F4 regression baseline); all six prior tracked cycles are CLOSED. Resolved items (`F-PE-MED-001`, `R-F2`, `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`, `E2E-CI-DYNAMIC-TESTS-WIP-UNVERIFIED`, `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1`, `STATE-MD-OVER-SOFT-TARGET`): `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking standing debt (not gate-blocking): `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) is OPEN, **PAUSED** at the start of Phase F4 (delta implementation). F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 (incremental story decomposition) HUMAN GATE APPROVED via DEC-356, 2026-09-11 (11 total adversary story-review passes, pass 11 zero-novelty, preceded the gate). F4 started immediately after the gate; its regression-baseline sub-agent was in-flight at session-wrap and was cleanly abandoned (re-run on resume). All six prior tracked cycles (001-006) are CLOSED. cycle-002 RELEASED as `v0.7.0-dev.3`; cycle-003 RELEASED as `v0.7.0-dev.4`; cycle-004 RELEASED as `v0.7.0-dev.5`; cycle-005 (`adf-mentions`, GitHub #674) and cycle-006 (`mutants-ci-sharding`) both CLOSED with NO release cut (ship on `develop @ cef4a021` / `a9168212`, tag deferred to a future release riding both, likely alongside cycle-007). Full per-cycle convergence detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Seven tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) OPEN, PAUSED** at the start of Phase F4 (F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 APPROVED via DEC-356). `develop`'s real tip is `14e695ae` (all 4 MAINTENANCE-SWEEP-2026-09-10 merges landed: #779, #754, #800, #801); `activation_head` frontmatter stays `a9168212` -- no release tag cut. **Pipeline PAUSED** for session clear -- resume via `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`. Live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) remains DEFERRED, a human-owned post-close standing follow-up from cycle-005. Full per-cycle detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative (cycle-005/006 CLOSE + earlier F1-F7 detail, prior SESSION-WRAP-PAUSE accounts, the MUTANTS-NIGHTLY-REBALANCE narrative, cycle-004 maintenance items, PROCESS-GAP items, and Standing items) is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim, nothing deleted: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing in this section is currently blocking. cycle-007's own constraint (F1 HIGH regression risk on `src/api/auth.rs`, 3rd consecutive cycle touching this file, reaffirmed by F3's `S-cycle7-credential-absence-fix` and `S-cycle7-auth-state-derivation`) is carried in the Phase Progress row and `cycles/cycle-007/phase-f3-stories/`, not duplicated here.

## Session Resume Checkpoint

**Date:** 2026-09-11. **Pipeline: PAUSED** (cycle-007 `auth-correctness-dx`, F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 HUMAN GATE APPROVED via DEC-356 this burst). **Position:** cycle-007 is the sole OPEN cycle, at Phase F3 APPROVED / Phase F4 (delta implementation) STARTED then PAUSED at this session wrap -- the F4 regression-baseline sub-agent was IN-FLIGHT and was cleanly ABANDONED (a re-runnable read-only measurement, no committable state; no worktrees or code were produced). All six prior tracked cycles (001-006) remain CLOSED. **NEXT** = resume F4: re-run the regression baseline (F4 Step 1), then create Wave-1 worktrees and begin per-story delivery -- Story A (`S-cycle7-credential-absence-fix`) first per the auth.rs merge-order note, then B1 (`S-cycle7-auth-state-derivation`); C (`oauth-help-text-fix`) + D (`readme-migration-note`) are parallelizable in Wave 1; Wave 2 = B2 (`S-cycle7-auth-status-json`, depends on B1).

**Convergence counter:** N/A -- F3 converged and was approved (DEC-356); the F4 code-review/F5 adversarial loop has not started. trajectory-tail (`→1→3→0→2`) unchanged -- no cycle-007 code exists yet.

**In-flight work:** F4's regression-baseline sub-agent was IN-FLIGHT at session-wrap and was cleanly ABANDONED (read-only measurement, no committable state; re-run at F4 Step 1 on resume). No stories mid-TDD, no worktrees, no cycle-007 PRs.

**Pending human decisions / open follow-ups:** none blocking F4 (F3 approved via DEC-356). Standing, unchanged: `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` (awaiting a scheduled nightly to confirm all 24 shards complete + a real kill rate), `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` (engine follow-up, tracked in the vsdd-factory repo, not jira-cli), and `FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION` (`src/api/auth.rs` `examine_globs` expansion, deferred, reaffirmed not resolved by F3). Four issue bundles remain PARKED pending future human go-ahead: cycle-008 (`issue-io-quickwins`), cycle-009 (`bulk-by-jql`), cycle-010 (`read-index-lag`), cycle-011 (`filter-grammar`). GitHub #674 CLOSED (already shipped, cycle-005); #387 DEFERRED (destructive history-rewrite, out of Feature Mode scope). MAINTENANCE-SWEEP-2026-09-10 remains fully CLOSED, zero outstanding actions.

**WIP branch list:** none.

**Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

**Counts:** total_bcs 757 (unchanged this burst); VP count 82 (unchanged this burst); holdout scenarios 118 (unchanged); total_stories 180 (unchanged this burst -- F3's +5 was recorded at the prior burst). Prior checkpoint (STATE.md v4.11): archived to `cycles/cycle-007/session-checkpoints.md`.

## Historical Content

Burst logs, adversary pass details, session checkpoints, resolved/open standing debt, and full per-burst narrative for every cycle have been extracted to cycle files. This table lists file locations only; full per-burst inline descriptions previously carried inline here: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md`.

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-20) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Bursts 1-22) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Bursts 1-22) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Bursts 1-13 + Appendix) |
| cycle-006 burst history | `cycles/cycle-006/burst-log.md` (Bursts 1-13 + Appendix) |
| cycle-007 F1 delta analysis + issue triage | `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`, `phase-f1-delta-analysis/cycle-007-affected-files.txt`, `phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md`, `phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md` |
| cycle-007 F2 spec evolution (PRD delta + verification delta) | `phase-f2-spec-evolution/cycle-007-prd-delta.md`, `phase-f2-spec-evolution/cycle-007-verification-delta.md` |
| cycle-007 F3 incremental stories (5 new stories + dependency graph + wave schedule + wave holdout scenarios) | `cycles/cycle-007/phase-f3-stories/` |
| cycle-007 session-wrap-pause checkpoints | `cycles/cycle-007/session-checkpoints.md` |
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | see `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` for the full per-cycle path list |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`CYCLE-007-F4-BASELINE-RERUN-PENDING`** -- new, this burst. Phase F4 (delta implementation) STARTED then PAUSED for session wrap; its regression-baseline sub-agent (F4 Step 1) was IN-FLIGHT and was cleanly ABANDONED (a re-runnable read-only measurement -- no committable state, no worktrees/code produced). **Resume action:** re-run the regression baseline as the first step of F4 before creating any Wave-1 worktrees. Resolves on F4 resume once the baseline completes.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking, still open (pre-existing since cycle-004, tracked verbatim in `cycles/OPEN-STANDING-ITEMS.md` under "cycle-004 maintenance items"). `.cargo/mutants.toml`'s `examine_globs` omits `src/api/auth.rs` and siblings (`src/cli/auth/login.rs`, `src/api/auth_windows_store.rs`) from in-scope mutation coverage. cycle-007 F3's `S-cycle7-credential-absence-fix` explicitly REAFFIRMS this as a deferred follow-up (its own text cites `mutation-results.md §5, FIX-F6-A` and states the story does not pay it down) -- the human's DEC-356 F3-gate approval EXPLICITLY ACCEPTED this deferral. Target: a future SELF-IMPROVEMENT/maintenance cycle or a dedicated mutation-hardening effort.
- **`CYCLE-007-PARKED-BUNDLES`** -- same-day issue triage (2026-09-10) also disposed of the broader backlog: GitHub **#674 CLOSED** (already shipped, cycle-005, no further action); **#387 DEFERRED** (destructive history-rewrite -- a standalone repo-ops decision, out of Feature Mode scope, not scheduled into any cycle); 4 further bundles **PARKED** pending a future human go-ahead -- **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). None of the four are scheduled or scoped -- triaged and named only. Full triage: `phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md` and `phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap: vsdd-factory has no `compact-claude-md` capability mirroring `compact-state`; candidate follow-up in the vsdd-factory repo, NOT jira-cli.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. The mutants-nightly rebalance fix (N=16->24 shards, `timeout-minutes` 240->300, completion-sentinel guard; PR #799 @ `78aeb86c`) is statically validated only (actionlint/shellcheck/YAML-parse + local code-reviewer). A manual `workflow_dispatch` run, or the next scheduled 08:00 UTC nightly, must confirm all 24 shards complete within the 300-min cap and produce a real full-scope kill rate -- the true kill-rate-vs-90% posture is unknown until then.
- `STATE-MD-OVER-SOFT-TARGET` -- **RESOLVED 2026-09-10** (STATE-MD-COMPACT-2026-09-10 burst, `/compact-state`; STATE.md reduced 447->196 lines). Subsequent bursts (SESSION-WRAP-PAUSE formalizations, MAINTENANCE-SWEEP-2026-09-10 STARTED/COMPLETE/MERGES-LANDED, cycle-007-OPEN, F1/F2/F3-convergence + gate-approvals, and this pause) have each re-added a small transient overage -- tracked, not re-opened as a distinct item; a future `/compact-state` pass will re-condense once cycle-007 resumes and runs a few more bursts.

**RESOLVED this burst:** `CYCLE-007-F3-SCOPE-GATE-PENDING` -- F3 approved via DEC-356, 2026-09-11.

**RESOLVED prior bursts (moved to `cycles/RESOLVED-DRIFT-ITEMS.md`):** `MAINTENANCE-SWEEP-2026-09-10-MERGES-PENDING` -- all 4 human-gated merges landed on `develop` 2026-09-10. `CYCLE-007-F1-SCOPE-GATE-PENDING` -- F1 approved via DEC-354, 2026-09-10. `CYCLE-007-F2-SCOPE-GATE-PENDING` -- F2 approved via DEC-355, 2026-09-10.

All other standing debt -- full text preserved, nothing deleted: OPEN items (cycle-005/006 close deferrals, cycle-002/003/004 LOW items, process-gaps, `PR-REVIEW-SELF-APPROVE-HOOK-LOOP`, Dependabot PRs, `VP-COUNT-RECONCILIATION`, the S-PG-* backlog, etc.) at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items and historical narrative at `cycles/RESOLVED-DRIFT-ITEMS.md`.
