---
document_type: pipeline-state
level: ops
version: "4.11"
status: active
producer: state-manager
timestamp: 2026-09-11T05:45:20Z
phase: "cycle-007 (auth-correctness-dx) OPEN, Feature Mode. Phase F1 (delta analysis) HUMAN GATE APPROVED 2026-09-10 (DEC-354) -- 6-issue scope (#784/#786/#787/#788/#790/#783); #785 DEFERRED (parked, not scheduled); #786 NARROWED (only the two src/api/auth.rs credential-absence sites reclassified to exit 2, unknown-profile stays exit 64 per BC-1.1.004 unchanged); #787+#788 share one auth_method-aware 'configured' vocabulary. Phase F2 (spec evolution) HUMAN GATE APPROVED 2026-09-10 (DEC-355) -- the spec delta (3 new BCs BC-1.6.048/049/050 + amendments to BC-1.4.032/033/034/BC-1.6.047, 6 new VPs VP-AUTHDX-024..029, spec version 2.2.0->2.3.0 MINOR) was approved, proceeding to F3. Phase F3 (incremental story decomposition) is now CONVERGED after 11 total adversary story-review passes (recurring findings across passes -- renderer purity/injection-seam boundary discipline, mutation-scope examine_globs exclude_re + auth.rs FIX-F6-A deferral, and existing pre-cycle-007 keyring-gated test reconciliation via Task 7a on S-cycle7-credential-absence-fix -- all resolved; pass 11 zero-novelty) but is explicitly NOT YET human-approved -- awaiting the human F3 gate before F4 delta implementation begins. 5 new stories: S-cycle7-credential-absence-fix (closes #784+#786), S-cycle7-auth-state-derivation (#788), S-cycle7-auth-status-json (#787, depends on auth-state-derivation), S-cycle7-oauth-help-text-fix (#790), S-cycle7-readme-migration-note (#783) -- 28 points total, 2 waves (Wave 1: A/B1/C/D = 20pts; Wave 2: B2 = 8pts), acyclic dependency graph (B1->B2 the only cross-story edge, Kahn-layering proof in dependency-graph-extended.md). total_stories 175->180. Core touch point src/api/auth.rs remains flagged HIGH regression risk (3rd consecutive cycle touching this file). Pipeline stays ACTIVE; all six prior cycles (001-006) remain CLOSED, historical."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-11, v4.11, state-manager -- CYCLE-007 F2 HUMAN GATE APPROVED (DEC-355) + F3 STORY DECOMPOSITION CONVERGED (awaiting human F3 gate): single atomic burst on factory-artifacts (TD-VSDD-053), per orchestrator instruction. Minted DEC-355 recording the human's F2 spec-evolution gate approval (2026-09-10 -- spec delta: 3 new BCs BC-1.6.048/049/050 + amendments to BC-1.4.032/033/034/BC-1.6.047, 6 new VPs VP-AUTHDX-024..029, spec 2.2.0->2.3.0 MINOR -- approved, proceeding to F3). Recorded F3 story-decomposition convergence: 5 new stories (S-cycle7-credential-absence-fix closes #784+#786, S-cycle7-auth-state-derivation #788, S-cycle7-auth-status-json #787, S-cycle7-oauth-help-text-fix #790, S-cycle7-readme-migration-note #783), 28 points total, 2 waves (Wave 1 A/B1/C/D = 20pts, Wave 2 B2 = 8pts), acyclic (B1->B2 only cross-story dependency, Kahn-layering proof in dependency-graph-extended.md), 11 total adversary story-review passes to convergence -- recurring findings (renderer purity/injection-seam boundary discipline, mutation-scope examine_globs exclusion + auth.rs FIX-F6-A deferral, existing pre-cycle-007 keyring-gated test reconciliation via Task 7a on S-cycle7-credential-absence-fix, points re-estimated 5->8) all resolved; pass 11 zero-novelty CONVERGED. F3 status: CONVERGED, awaiting human F3 gate -- explicitly NOT recorded as APPROVED this burst. Counts: total_stories 175->180 (+5); total_bcs 757, VP count 82, holdout scenarios 118 all UNCHANGED this burst (F3 story decomposition mints no new BCs/VPs/holdout-corpus entries; the wave-holdout-scenarios.md H-W1-*/H-W2-* entries are cycle-scoped wave-integration holdouts, not the tracked specs/prd/holdout-scenarios.md corpus, so the 118 count is correctly left unchanged). Committed the F3 artifact set: cycles/cycle-007/phase-f3-stories/{S-cycle7-credential-absence-fix,S-cycle7-auth-state-derivation,S-cycle7-auth-status-json,S-cycle7-oauth-help-text-fix,S-cycle7-readme-migration-note,dependency-graph-extended,wave-schedule,wave-holdout-scenarios}.md, plus stories/STORY-INDEX.md (already carrying the pass-7 fix-burst reconciliation: S-cycle7-credential-absence-fix points 5->8, wave-schedule.md Wave-1 total 17->20/grand-total 25->28, total_stories 180) and this STATE.md. Reconciled input-hash drift on 2 F3 artifacts whose listed `inputs:` changed after the pass-7 fix burst edited sibling files without a hash recompute: dependency-graph-extended.md (stored c775650 vs computed c6f8e19 -- its inputs include stories/STORY-INDEX.md, edited in the fix burst; updated via compute-input-hash --update to c6f8e19) and wave-holdout-scenarios.md (stored ffb6d6b vs computed f7d57aa -- its inputs include S-cycle7-credential-absence-fix.md and wave-schedule.md, both edited in the fix burst; updated to f7d57aa). The other 6 F3 artifacts (5 story files + wave-schedule.md) re-verified clean via --check, no drift. Pre-existing systemic 165-artifact input-hash drift (F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING) is accepted standing debt, unaffected by this burst, out of scope. Ran scripts/check-spec-counts.sh and scripts/check-bc-cumulative-counts.sh before committing -- both green (757 BCs across 9 files; unaffected by this F3-scoped burst, re-verified as a safety check per protocol). Left unrelated stray churn (regression-state.json, sidecar-learning.md, code-delivery/PR-800/, code-delivery/PR-801/) UNCOMMITTED per orchestrator instruction -- out of scope for this burst. Added Phase Progress row F3-STORY-DECOMPOSITION-CYCLE-007 (CONVERGED, awaiting human gate); updated the F2 row's Status cell in place to APPROVED (DEC-355); archived the oldest Phase Progress row (MAINTENANCE-CLAUDE-MD-COMPACTION-2026-09-10) to cycles/HISTORY-PHASE-PROGRESS.md to hold the live table at 7 rows. version: 4.10->4.11 (exactly one bump, no double-bump). pipeline stays ACTIVE. F3 explicitly NOT recorded as APPROVED -- that DEC lands at the human F3 gate. Noted the deferred FIX-F6-A follow-up (`.cargo/mutants.toml` examine_globs mutation-scope expansion for src/api/auth.rs and siblings, pre-existing in cycles/OPEN-STANDING-ITEMS.md as F6-MUTATION-EXAMINE-GLOBS-EXPANSION) as a still-open standing item, REAFFIRMED (not resolved, not newly opened) by this cycle's story decomposition -- S-cycle7-credential-absence-fix's own text explicitly defers it rather than paying it down."
current_step: "D-chain cite D-053, D-2026 latest brownfield. CYCLE-007 F2 APPROVED + F3 CONVERGED: state-manager recorded (1) DEC-355, the human's F2 spec-evolution gate approval (2026-09-10, spec delta: 3 new BCs + amendments + 6 new VPs, spec 2.2.0->2.3.0 MINOR, proceeding to F3), and (2) F3 story-decomposition convergence (5 new stories S-cycle7-credential-absence-fix/auth-state-derivation/auth-status-json/oauth-help-text-fix/readme-migration-note, 28 pts, 2 waves, acyclic B1->B2, 11 adversary passes to zero-novelty convergence) -- in a single atomic burst on factory-artifacts (TD-VSDD-053), per orchestrator instruction. F3 status: CONVERGED, awaiting human F3 gate -- explicitly NOT APPROVED this burst. Counts updated: total_stories 175->180 (+5); total_bcs 757, VP count 82, holdout scenarios 118 all unchanged (F3 mints no spec/holdout-corpus artifacts). current_cycle frontmatter updated to phase F3 (converged, awaiting human gate). Reconciled input-hash drift on dependency-graph-extended.md (c775650->c6f8e19) and wave-holdout-scenarios.md (ffb6d6b->f7d57aa); remaining 6 F3 artifacts already matched. version: 4.10->4.11 (exactly one bump, no double-bump). scripts/check-spec-counts.sh + scripts/check-bc-cumulative-counts.sh both re-verified green before commit (757 across 9 files, unaffected by F3 scope). trajectory-tail unchanged →1→3→0→2 (F3 story-decomposition adversarial review is a document-review loop, not the F5 code-review loop this counter tracks)."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-007-auth-correctness-dx (F1 APPROVED via DEC-354; F2 APPROVED via DEC-355; F3 story decomposition CONVERGED, awaiting human F3 gate)"
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

<!-- STATE.md SIZE BUDGET (2026-09-11, CYCLE-007-F3-CONVERGED checkpoint -- pipeline stays
     ACTIVE this burst, cycle-007 (auth-correctness-dx) is the sole OPEN cycle, now at Phase F3
     (incremental story decomposition) CONVERGED / awaiting human gate, with F1 and F2 both
     recorded APPROVED via DEC-354/DEC-355; all six prior cycles (001-006) remain CLOSED,
     historical; line count refreshed after this burst's Write):
     This is a PHASE-TRANSITION burst (state-manager, per orchestrator instruction -- records F2
     human-gate approval as DEC-355 and F3 story-decomposition convergence; explicitly does NOT
     record F3 as human-approved). `pipeline:` stays ACTIVE. `current_cycle:` frontmatter updated
     to reflect F1/F2 APPROVED, F3 CONVERGED awaiting gate. `phase:`/`current_step:`/
     `last_amended:` rewritten via the verbatim-strict chain (each field's prior chained value is
     NOT nested inside the new one -- overwritten per the last_amended write-path discipline),
     preserving `D-chain cite D-053, D-2026 latest brownfield.` and trajectory-tail `→1→3→0→2`
     (unchanged -- F3 story-decomposition adversarial review is a document-review loop, not the F5
     code-review loop this counter tracks). `version:` 4.10 -> 4.11 (exactly one bump, no
     double-bump).
     Added ONE new Phase Progress row (`F3-STORY-DECOMPOSITION-CYCLE-007`, status
     `CONVERGED (awaiting human gate)`) and updated the existing `F2-SPEC-EVOLUTION-CYCLE-007`
     row's Status cell in place to `APPROVED (DEC-355)` (mirroring how the F1 row was updated
     in place at the prior burst) rather than archiving it immediately, so the F1->F2->F3
     progression stays visible on one screen; archived the table's oldest row
     (`MAINTENANCE-CLAUDE-MD-COMPACTION-2026-09-10`) to `cycles/HISTORY-PHASE-PROGRESS.md` to
     hold the live table at 7 rows per the "recent 7" convention. The F2 row will itself be
     archived on a future burst once F3 closes.
     Counts: total_stories 175->180 (+5: S-cycle7-credential-absence-fix, S-cycle7-auth-state-
     derivation, S-cycle7-auth-status-json, S-cycle7-oauth-help-text-fix, S-cycle7-readme-
     migration-note); total_bcs 757, VP count 82, holdout scenarios 118 all UNCHANGED this burst
     (F3 story decomposition mints no new spec or tracked-holdout-corpus artifacts -- the 16
     wave-integration holdout scenarios in `wave-holdout-scenarios.md` (H-W1-*/H-W2-*) are
     cycle-scoped cross-story integration checks, NOT members of the tracked
     `specs/prd/holdout-scenarios.md` corpus, so 118 correctly stays unchanged). All count
     surfaces re-verified consistent via `scripts/check-spec-counts.sh` +
     `scripts/check-bc-cumulative-counts.sh`, both green (757 total across 9 files) before this
     commit -- unaffected by F3 scope, re-run as a safety check per protocol.
     Minted DEC-355 (F2 human-gate approval, 2026-09-10) in the Decisions Log -- the placeholder
     "no DEC yet" row from the prior burst is replaced with the real decision record; a new
     placeholder row is added for the pending F3 gate decision, mirroring the same pattern.
     input-hash reconciliation this burst: `cycles/cycle-007/phase-f3-stories/
     dependency-graph-extended.md` showed drift (stored `c775650` vs computed `c6f8e19` -- its
     `inputs:` list includes `stories/STORY-INDEX.md`, edited by the pass-7 adversary fix burst
     without a hash recompute); updated via `compute-input-hash --update` to `c6f8e19`.
     `wave-holdout-scenarios.md` showed drift (stored `ffb6d6b` vs computed `f7d57aa` -- its
     `inputs:` list includes `S-cycle7-credential-absence-fix.md` and `wave-schedule.md`, both
     edited by the same fix burst); updated to `f7d57aa`. The remaining 6 F3 artifacts (5 story
     files + `wave-schedule.md`) re-verified clean via `--check`, zero drift. The pre-existing
     systemic 165-artifact drift (`F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING`) is unaffected,
     accepted standing debt, out of scope for this burst.
     Left unrelated stray churn (`regression-state.json`, `sidecar-learning.md`,
     `code-delivery/PR-800/`, `code-delivery/PR-801/`) UNCOMMITTED per orchestrator instruction --
     explicitly out of scope for this burst, not an omission.
     soft target 200 lines; hard cap 500 lines. 250 lines (wc-l) (this file, this Write) -- up
     from 238 lines pre-burst net of the DEC-355 mint, the new F3-STORY-DECOMPOSITION-CYCLE-007
     Phase Progress row, the F2 row's in-place status update, and the input-hash reconciliation
     narrative added to this banner.
     margin from soft-target = 250 - 200 (OVER the soft target; acceptable one-burst transient per
     the extract-history/keep-live-state principle -- a future `/compact-state` pass will
     re-condense once cycle-007 has run a few more bursts).
     margin from actual = 500 - 250 (headroom remains before the hard cap).
     RECOVERY CONTEXT: no crash this burst -- a planned phase-transition event, verified via a
     fresh read of this file before writing (still v4.10/F2-converged-awaiting-gate/no-F3-
     artifacts-committed, prior state intact) -- this Write/commit is the first and only landing
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
| **Pipeline Status** | **ACTIVE** -- cycle-007 (`auth-correctness-dx`) OPEN, Feature Mode; Phase F1 APPROVED (DEC-354, 2026-09-10); Phase F2 (spec evolution) APPROVED (DEC-355, 2026-09-10); Phase F3 (incremental story decomposition) CONVERGED, awaiting human gate (F3->F4). All six prior cycles (001-006) remain CLOSED -- see `cycles/CYCLE-SUMMARY.md` |
| **trajectory-tail** | →1→3→0→2 (unchanged -- F3 story-decomposition convergence is a document-review adversarial loop, not the F5 code-review loop this counter tracks) |
| **Last Updated** | 2026-09-11, cycle-007 F2 gate APPROVED (DEC-355) and F3 story decomposition CONVERGED, awaiting human F3 gate. trajectory-tail →1→3→0→2 (unchanged). Full prior per-cycle history: `cycles/CYCLE-SUMMARY.md` |
| **Current Phase** | cycle-007 (`auth-correctness-dx`) F3 (incremental story decomposition) -- **CONVERGED, awaiting human scope gate (F3->F4).** 5 new stories (28 points, 2 waves): `S-cycle7-credential-absence-fix` (closes #784+#786), `S-cycle7-auth-state-derivation` (#788), `S-cycle7-auth-status-json` (#787, depends on auth-state-derivation), `S-cycle7-oauth-help-text-fix` (#790), `S-cycle7-readme-migration-note` (#783). Wave 1 (A/B1/C/D, 20pts) + Wave 2 (B2, 8pts), acyclic (B1->B2 only cross-story edge). 11 total adversary story-review passes to convergence; `total_stories` 175->180. Core touch point `src/api/auth.rs` remains HIGH regression risk (3rd consecutive cycle). Detail: `cycles/cycle-007/phase-f3-stories/`. cycle-001 through cycle-006 all CLOSED, historical -- see `cycles/CYCLE-SUMMARY.md`. |
| **Activation HEAD** | `a9168212` (unchanged -- no release tag cut; `develop`'s real tip is `14e695ae`) |

## Phase Progress (recent 7; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **E2E-CI-DYNAMIC-TESTS-DELIVERED-2026-09-10** | **COMPLETE** | 2026-09-10 | Bookkeeping only, no quality gate | Resolved `E2E-CI-DYNAMIC-TESTS-WIP-UNVERIFIED`: branch `test/e2e-dynamic-parent-editfield` @ `6bfc2a0a` rebased, verified green, MERGED to `develop` @ `3a874d90` via PR #798. New follow-up: `E2E-DISCOVER-SAFE-EDIT-FIELD-VALIDATED-SUBTYPE` (see `cycles/OPEN-STANDING-ITEMS.md`). | counts unchanged; no DEC minted |
| **MUTANTS-NIGHTLY-REBALANCE-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Nightly mutation run `34478602590` ended `cancelled` (4/16 shards, PARTIAL data). Fix via PR #799 (merged @ `78aeb86c`): rebalanced N=16->24 shards + timeout 240->300 + completion-sentinel guard. New follow-up: `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` (see Drift/Standing Items below). | counts unchanged; no DEC minted |
| **STATE-MD-COMPACT-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping (`/compact-state` skill), state-manager-executed, no quality gate | Extracted historical content (frontmatter cycle-status prose, SIZE BUDGET banner, 2 oldest Phase Progress rows, full Current-Phase-Steps checklist, Decisions-Log narrative notes, resolved+open Drift/Standing-Items detail, cycle-002/003/004 Skip Log rows, verbose Historical-Content descriptions, full live Session-Resume-Checkpoint text) into `cycles/` files -- nothing deleted, every pointer resolves. STATE.md 447->196 lines, single full-content Write. `STATE-MD-OVER-SOFT-TARGET` marked RESOLVED. | counts unchanged (754/76/118/175); no DEC minted -- maintenance event |
| **MAINTENANCE-SWEEP-2026-09-10** | **COMPLETE, FULLY CLOSED** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Human-requested maintenance sweep CLOSED in one atomic burst (TD-VSDD-053): 2 read-only scans (dependency audit -- `develop` dependency-clean, 0 RUSTSEC advisories, 1 actionable LOW: `chacha20` 0.10.0 yanked; doc drift -- PR #797 compaction verified clean, 8 findings) + open-PR triage (10 open PRs, `auto_merge=false`). Fix PR #800 (`chacha20` 0.10.0->0.10.2) + doc-sync PR #801 opened. 3 factory doc-hygiene items (`CYCLE5-F7-DOC-1`, `CYCLE5-F7-DOC-2`, `CYCLE5-STEP45-LOW-1`) RESOLVED same commit. 5 cargo Dependabot PRs (syn) re-confirmed correctly held; `#792`/`#628` deferred by human. **CLOSING UPDATE (same day):** all 4 merges (`#800`, `#801`, `#779`, `#754`) subsequently MERGED to `develop` by human action; `develop` tip advanced `78aeb86c` -> `14e695ae` (`#779`=`211ae959`, `#754`=`d4760cd5`, `#800`=`522f9ba2`, `#801`=`14e695ae`). Sweep is now fully closed, zero outstanding actions. Full report: `maintenance/sweep-report-2026-09-10.md`. | counts unchanged (754/76/118/175); no DEC minted |
| **F1-DELTA-ANALYSIS-CYCLE-007** | **APPROVED (DEC-354)** | 2026-09-10 | Feature Mode F1 human scope gate | architect's delta analysis for the 7-issue auth bundle HUMAN GATE APPROVED 2026-09-10: 6-issue scope (#784/#786/#787/#788/#790/#783); #785 DEFERRED (parked); #786 NARROWED (only the two `src/api/auth.rs` credential-absence sites -> exit 2, unknown-profile stays 64, BC-1.1.004 unchanged); #787+#788 share one auth_method-aware "configured" vocabulary. Core touch point `src/api/auth.rs` (HIGH regression risk, 3rd consecutive cycle). Detail: `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`. | counts unchanged (754/76/118/175) at F1; DEC-354 minted |
| **F2-SPEC-EVOLUTION-CYCLE-007** | **APPROVED (DEC-355)** | 2026-09-10 | Feature Mode F2 human scope gate | product-owner + formal-verifier's spec delta for the 6-issue scope HUMAN GATE APPROVED 2026-09-10: 3 new BCs (BC-1.6.048/049/050) + amendments to BC-1.4.032/033/034 + BC-1.6.047, 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 (MINOR); 10 adversary passes total, 3 consecutive CLEAN (8/9/10) to convergence prior to the gate. Detail: `phase-f2-spec-evolution/cycle-007-prd-delta.md`, `phase-f2-spec-evolution/cycle-007-verification-delta.md`. | counts: BCs 754->757, VPs 76->82 (set at F2); DEC-355 minted |
| **F3-STORY-DECOMPOSITION-CYCLE-007** | **CONVERGED (awaiting human gate)** | 2026-09-11 | Feature Mode F3, 11-pass adversarial story convergence, human gate PENDING | story-writer decomposed the F2-approved spec delta into 5 new stories (`S-cycle7-credential-absence-fix` closes #784+#786, `S-cycle7-auth-state-derivation` #788, `S-cycle7-auth-status-json` #787 depends-on auth-state-derivation, `S-cycle7-oauth-help-text-fix` #790, `S-cycle7-readme-migration-note` #783), 28 points, 2 waves (Wave 1 A/B1/C/D=20pts, Wave 2 B2=8pts), acyclic (B1->B2 only cross-story edge, Kahn-layering proof). 11 total adversary story-review passes to convergence; recurring findings (renderer purity/injection-seam boundary discipline, mutation-scope `examine_globs` exclude_re + `src/api/auth.rs` FIX-F6-A deferral, existing pre-cycle-007 keyring-gated test reconciliation via Task 7a on `S-cycle7-credential-absence-fix` -- points re-estimated 5->8) all resolved; pass 11 zero-novelty. Detail: `cycles/cycle-007/phase-f3-stories/`. | 5 stories/28pts/2 waves; story count 175->180. DEC-355 minted (F2 gate); this row's own F3 gate DEC pending |

## Current Phase Steps

**cycle-007 (`auth-correctness-dx`) is now at Phase F3, CONVERGED.** F1 (delta analysis) was HUMAN GATE APPROVED 2026-09-10 as DEC-354 -- 6-issue scope (#784/#786-narrowed/#787/#788/#790/#783), #785 deferred. F2 (spec evolution) was then HUMAN GATE APPROVED 2026-09-10 as DEC-355 -- 3 new BCs (BC-1.6.048/049/050) + amendments to BC-1.4.032/033/034/BC-1.6.047, 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 (MINOR); 10 adversary passes total (3 consecutive CLEAN 8/9/10) preceded the gate. F3 (incremental story decomposition) then ran, reaching convergence at 11 total adversary story-review passes (zero-novelty at pass 11): story-writer authored 5 new stories under `cycles/cycle-007/phase-f3-stories/` (`S-cycle7-credential-absence-fix.md`, `S-cycle7-auth-state-derivation.md`, `S-cycle7-auth-status-json.md`, `S-cycle7-oauth-help-text-fix.md`, `S-cycle7-readme-migration-note.md`), plus `dependency-graph-extended.md` (acyclic proof, B1->B2 the only cross-story edge), `wave-schedule.md` (2 waves, Wave 1 A/B1/C/D=20pts, Wave 2 B2=8pts), and `wave-holdout-scenarios.md` (cross-story integration holdouts, cycle-scoped -- not the tracked `specs/prd/holdout-scenarios.md` corpus). `stories/STORY-INDEX.md` updated to `total_stories: 180` (+5), including the pass-7 adversary fix-burst reconciliation (`S-cycle7-credential-absence-fix` points re-estimated 5->8, propagated to `wave-schedule.md`'s totals). **F3 is NOT yet human-approved** -- next step is the human scope gate (F3->F4); do not proceed to delta implementation until that approval lands. No other phase is currently mid-execution. The last completed pipeline-phase checklist before this cycle was cycle-005 Burst 13 (F7 delta convergence, cycle CLOSE) -- its full 15-step checklist is preserved at `cycles/cycle-005/burst-log.md` (Appendix). MAINTENANCE-SWEEP-2026-09-10's steps are summarized in the Phase Progress row above and `maintenance/sweep-report-2026-09-10.md`.

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| *(none yet for cycle-007 F3)* | F3 story decomposition is CONVERGED (11 total adversary passes, pass 11 zero-novelty) but explicitly NOT human-approved this burst -- no DEC minted for F3 yet. The next DEC will record the human's F3 scope-gate decision (approve/adjust/reject) once made. | -- | F3 (pending gate) | -- | -- |
| DEC-355 | cycle-007 (`auth-correctness-dx`) Phase F2 (spec evolution) **HUMAN GATE APPROVED**, 2026-09-10 -- the human reviewed the F2 spec delta (3 new BCs BC-1.6.048/049/050 + amendments to BC-1.4.032/033/034 + BC-1.6.047 in `specs/prd/bc-1-auth-identity.md`, 6 new VPs VP-AUTHDX-024..029, spec version 2.2.0->2.3.0 MINOR) and approved it, authorizing the pipeline to proceed to Phase F3 (incremental story decomposition). | Human reviewed the F2 PRD delta (`phase-f2-spec-evolution/cycle-007-prd-delta.md`) and verification delta (`phase-f2-spec-evolution/cycle-007-verification-delta.md`), both already CONVERGED via 10 adversary passes (3 consecutive CLEAN 8/9/10) prior to the gate, and made an explicit approval ruling | F2 (gate) | 2026-09-10 | human (explicit F2-gate approval) |
| DEC-354 | cycle-007 (`auth-correctness-dx`) Phase F1 (delta analysis) **HUMAN GATE APPROVED**, 2026-09-10 -- 6-issue scope: #784, #786 (narrowed), #787, #788, #790, #783. **#785** (headless `JR_EMAIL`/`JR_API_TOKEN` credential resolution) **DEFERRED** ("skip for now", parked, not scheduled into any cycle). **#786 NARROWED**: only the two `src/api/auth.rs` credential-absence sites (`load_api_token`'s no-stored-credentials and incomplete-pair branches) reclassify from `JrError::UserError`/exit 64 to `JrError::NotAuthenticated`/exit 2; the unrelated `auth status --profile <unknown>` unknown-profile site (BC-1.1.004) stays exit 64, unchanged -- the two failure classes are categorically distinct (profile has no credentials vs. profile doesn't exist). **#787 + #788 share one auth_method-aware "configured" vocabulary** -- a single shared BC (BC-1.6.048) defines the `unset`/`no-credentials`/`configured` state taxonomy that both `auth list`'s STATUS column (#788, BC-1.6.049) and `auth status --output json` (#787, BC-1.6.050) consume, rather than each issue growing its own ad hoc classification. | Human reviewed the architect's F1 delta-analysis report (`phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`) and the 3 open scope questions recorded at its §5, and made an explicit scope-gate ruling on each | F1 (gate) | 2026-09-10 | human (explicit F1-gate approval) |
| DEC-353 | cycle-005 (`adf-mentions`, GitHub #674) Phase F7 (delta convergence) **HUMAN GATE APPROVED / cycle CLOSED**, 2026-09-09, **NO RELEASE**. 5-dimensional delta convergence PASS: (1) Spec -- F2 approved (DEC-346); (2) Story/Test -- F3 approved (DEC-347), all 15+17 ACs realized; (3) Implementation -- merged to `develop @ cef4a021` (Wave 1 PR #778 @ `708c8b32`, Wave 2 PR #794 @ `0eaf4268`, F5 fix FIX-F5-001 PR #795 @ `cef4a021`); (4) Verification -- F6 HARDENED, 20/21 VPs covered, sharded mutation gate ran clean in-line on both product PRs; (5) Regression -- full CI green on `develop @ cef4a021`. **NO RELEASE CUT** -- feature ships on `develop`, unreleased; tag deferred to a future release riding cycle-005 + cycle-006 | Human reviewed the complete 5-dimensional delta-convergence evidence package and explicitly approved closing the cycle without cutting a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| (359 older decisions) | DEC-352 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-09 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**cycle-007 decisions detail (Bursts 1-3, F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 CONVERGED awaiting gate):** full F1 delta-analysis report at `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`; issue triage sources at `phase-f1-delta-analysis/issue-triage-{auth,enhancement}-cluster-2026-09-10.md`; F2 PRD delta at `phase-f2-spec-evolution/cycle-007-prd-delta.md`; F2 verification delta at `phase-f2-spec-evolution/cycle-007-verification-delta.md`; F3 stories + dependency graph + wave schedule + wave holdout scenarios at `cycles/cycle-007/phase-f3-stories/`.

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

**NONE OPEN.** Zero Blocking Issues remain open anywhere in the factory. cycle-007 is OPEN at F3 (converged, awaiting human gate, not yet blocked on anything); all six prior tracked cycles are CLOSED. Resolved items (`F-PE-MED-001`, `R-F2`, `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`, `E2E-CI-DYNAMIC-TESTS-WIP-UNVERIFIED`, `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1`, `STATE-MD-OVER-SOFT-TARGET`): `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking standing debt (not gate-blocking): `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) is OPEN at Phase F3 (incremental story decomposition) -- CONVERGED (11 total adversary story-review passes, pass 11 zero-novelty), awaiting human scope gate; F1 APPROVED via DEC-354, F2 APPROVED via DEC-355. All six prior tracked cycles (001-006) are CLOSED. cycle-002 RELEASED as `v0.7.0-dev.3`; cycle-003 RELEASED as `v0.7.0-dev.4`; cycle-004 RELEASED as `v0.7.0-dev.5`; cycle-005 (`adf-mentions`, GitHub #674) and cycle-006 (`mutants-ci-sharding`) both CLOSED with NO release cut (ship on `develop @ cef4a021` / `a9168212`, tag deferred to a future release riding both, likely alongside cycle-007). Full per-cycle convergence detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Seven tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) OPEN** at Phase F3 (CONVERGED, awaiting human gate; F1 APPROVED via DEC-354, F2 APPROVED via DEC-355). `develop`'s real tip is `14e695ae` (all 4 MAINTENANCE-SWEEP-2026-09-10 merges landed: #779, #754, #800, #801); `activation_head` frontmatter stays `a9168212` -- no release tag cut. Pipeline ACTIVE. Live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) remains DEFERRED, a human-owned post-close standing follow-up from cycle-005. Full per-cycle detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative (cycle-005/006 CLOSE + earlier F1-F7 detail, the SESSION-WRAP PAUSE account, the MUTANTS-NIGHTLY-REBALANCE narrative, cycle-004 maintenance items, PROCESS-GAP items, and Standing items) is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim, nothing deleted: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing in this section is currently blocking. cycle-007's own constraint (F1 HIGH regression risk on `src/api/auth.rs`, 3rd consecutive cycle touching this file, reaffirmed by F3's `S-cycle7-credential-absence-fix` and `S-cycle7-auth-state-derivation`) is carried in the Phase Progress row and `cycles/cycle-007/phase-f3-stories/`, not duplicated here.

## Session Resume Checkpoint

**Date:** 2026-09-11. **Pipeline: ACTIVE** (cycle-007 `auth-correctness-dx`, F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 CONVERGED this burst). **Position:** cycle-007 is the sole OPEN cycle, at Phase F3 (incremental story decomposition) -- CONVERGED (11 total adversary story-review passes, pass 11 zero-novelty), **awaiting the human scope gate (F3->F4)**. All six prior tracked cycles (001-006) remain CLOSED. **NEXT** = present the F3 story decomposition (`cycles/cycle-007/phase-f3-stories/`: 5 new stories, `dependency-graph-extended.md`, `wave-schedule.md`, `wave-holdout-scenarios.md`) to the human for the F3 scope-gate decision; do not begin F4 delta implementation before that approval lands.

**Convergence counter:** F3 story-decomposition adversarial loop reached convergence at pass 11 (zero-novelty). The trajectory-tail frontmatter field (`→1→3→0→2`) tracks a DIFFERENT counter (F5 code-review loop) and is unaffected -- no code exists yet for cycle-007 (F4 not started).

**In-flight work:** cycle-007 F3 story decomposition, converged and awaiting human gate. MAINTENANCE-SWEEP-2026-09-10 remains fully CLOSED (unrelated, zero outstanding actions). No stories mid-TDD; no PRs open for cycle-007 yet (F4 delta implementation has not started).

**Pending human decisions / open follow-ups:** **cycle-007 F3 scope-gate approval** (new, this burst -- review the 5 new stories, dependency graph, and wave schedule and either approve to proceed to F4, or request adjustments). Also unchanged from before: `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` (awaiting a scheduled nightly to confirm all 24 shards complete + a real kill rate), `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` (engine follow-up, tracked in the vsdd-factory repo, not jira-cli), and `FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION` (deferred, reaffirmed not resolved by F3 -- see Drift/Standing Items). Four issue bundles remain PARKED pending future human go-ahead: cycle-008 (issue-io-quickwins), cycle-009 (bulk-by-jql), cycle-010 (read-index-lag), cycle-011 (filter-grammar) -- see Drift/Standing Items below.

**WIP branch list:** none.

**Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

**Counts:** total_bcs 757 (unchanged this burst); VP count 82 (unchanged this burst); holdout scenarios 118 (unchanged -- F3 added none to the tracked corpus); total_stories 180 (+5 this burst: S-cycle7-credential-absence-fix, S-cycle7-auth-state-derivation, S-cycle7-auth-status-json, S-cycle7-oauth-help-text-fix, S-cycle7-readme-migration-note). Prior checkpoint (STATE.md v4.10): archived to `cycles/cycle-007/session-checkpoints.md`.

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
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | see `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` for the full per-cycle path list |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`CYCLE-007-F3-SCOPE-GATE-PENDING`** -- new, this burst (supersedes the resolved `CYCLE-007-F2-SCOPE-GATE-PENDING`). cycle-007 F3 story decomposition is CONVERGED (11 total adversary passes, pass 11 zero-novelty) but explicitly NOT human-approved. Review `cycles/cycle-007/phase-f3-stories/` (5 new stories, dependency graph, wave schedule, wave holdout scenarios) for the F3 scope-gate decision. `src/api/auth.rs` remains flagged HIGH regression risk (3rd consecutive cycle touching this file, after cycle-003 and cycle-004; touched again by F3's `S-cycle7-credential-absence-fix` and `S-cycle7-auth-state-derivation`). Blocks F4 delta implementation until resolved.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking, still open (pre-existing since cycle-004, tracked verbatim in `cycles/OPEN-STANDING-ITEMS.md` under "cycle-004 maintenance items"). `.cargo/mutants.toml`'s `examine_globs` omits `src/api/auth.rs` and siblings (`src/cli/auth/login.rs`, `src/api/auth_windows_store.rs`) from in-scope mutation coverage. cycle-007 F3's `S-cycle7-credential-absence-fix` explicitly REAFFIRMS this as a deferred follow-up (its own text cites `mutation-results.md §5, FIX-F6-A` and states the story does not pay it down) rather than closing it -- noted here so the deferral is visible at the cycle-007 level, not just buried in the maintenance backlog. Target: a future SELF-IMPROVEMENT/maintenance cycle or a dedicated mutation-hardening effort.
- **`CYCLE-007-PARKED-BUNDLES`** -- same-day issue triage (2026-09-10) also disposed of the broader backlog: GitHub **#674 CLOSED** (already shipped, cycle-005, no further action); **#387 DEFERRED** (destructive history-rewrite -- a standalone repo-ops decision, out of Feature Mode scope, not scheduled into any cycle); 4 further bundles **PARKED** pending a future human go-ahead -- **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). None of the four are scheduled or scoped -- triaged and named only. Full triage: `phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md` and `phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap: vsdd-factory has no `compact-claude-md` capability mirroring `compact-state`; candidate follow-up in the vsdd-factory repo, NOT jira-cli.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. The mutants-nightly rebalance fix (N=16->24 shards, `timeout-minutes` 240->300, completion-sentinel guard; PR #799 @ `78aeb86c`) is statically validated only (actionlint/shellcheck/YAML-parse + local code-reviewer). A manual `workflow_dispatch` run, or the next scheduled 08:00 UTC nightly, must confirm all 24 shards complete within the 300-min cap and produce a real full-scope kill rate -- the true kill-rate-vs-90% posture is unknown until then.
- `STATE-MD-OVER-SOFT-TARGET` -- **RESOLVED 2026-09-10** (STATE-MD-COMPACT-2026-09-10 burst, `/compact-state`; STATE.md reduced 447->196 lines). Subsequent bursts (SESSION-WRAP-PAUSE-2026-09-10 formalization, MAINTENANCE-SWEEP-2026-09-10 STARTED/COMPLETE/MERGES-LANDED, cycle-007-OPEN, F2-convergence, F2-gate-approval + F3-convergence) have each re-added a small transient overage -- tracked, not re-opened as a distinct item; a future `/compact-state` pass will re-condense once cycle-007 has run a few more bursts.

**RESOLVED this burst:** `CYCLE-007-F2-SCOPE-GATE-PENDING` -- F2 approved via DEC-355, 2026-09-10.

**RESOLVED prior bursts (moved to `cycles/RESOLVED-DRIFT-ITEMS.md`):** `MAINTENANCE-SWEEP-2026-09-10-MERGES-PENDING` -- all 4 human-gated merges landed on `develop` 2026-09-10. `CYCLE-007-F1-SCOPE-GATE-PENDING` -- F1 approved via DEC-354, 2026-09-10.

All other standing debt -- full text preserved, nothing deleted: OPEN items (cycle-005/006 close deferrals, cycle-002/003/004 LOW items, process-gaps, `PR-REVIEW-SELF-APPROVE-HOOK-LOOP`, Dependabot PRs, `VP-COUNT-RECONCILIATION`, the S-PG-* backlog, etc.) at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items and historical narrative at `cycles/RESOLVED-DRIFT-ITEMS.md`.
