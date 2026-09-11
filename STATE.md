---
document_type: pipeline-state
level: ops
version: "4.10"
status: active
producer: state-manager
timestamp: 2026-09-11T02:43:22Z
phase: "cycle-007 (auth-correctness-dx) OPEN, Feature Mode. Phase F1 (delta analysis) HUMAN GATE APPROVED 2026-09-10 (DEC-354) -- 6-issue scope (#784/#786/#787/#788/#790/#783); #785 DEFERRED (parked, not scheduled); #786 NARROWED (only the two src/api/auth.rs credential-absence sites reclassified to exit 2, unknown-profile stays exit 64 per BC-1.1.004 unchanged); #787+#788 share one auth_method-aware 'configured' vocabulary. Phase F2 (spec evolution) is now CONVERGED after 10 adversary passes total (3 consecutive CLEAN passes 8/9/10) but is explicitly NOT YET human-approved -- awaiting the human F2 gate before F3 story decomposition begins. 3 new BCs minted (BC-1.6.048/049/050) plus in-place amendments to BC-1.4.032/033/034 and BC-1.6.047; 6 new VPs (VP-AUTHDX-024..029); spec version 2.2.0->2.3.0 (MINOR). Core touch point src/api/auth.rs remains flagged HIGH regression risk (3rd consecutive cycle touching this file). Pipeline stays ACTIVE; all six prior cycles (001-006) remain CLOSED, historical."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-10, v4.10, state-manager -- CYCLE-007 F2 SPEC EVOLUTION CONVERGED (awaiting human F2 gate), F1 gate retroactively recorded as DEC-354: single atomic burst on factory-artifacts (TD-VSDD-053). Minted DEC-354 recording the human's F1 scope-gate approval (2026-09-10, 6-issue scope, #785 deferred, #786 narrowed, #787+#788 share one auth_method-aware vocabulary). Recorded F2 convergence: 10 adversary passes total, 3 consecutive CLEAN passes (8/9/10) to convergence, spec 2.2.0->2.3.0 (MINOR). Counts: total_bcs 754->757 (+3: BC-1.6.048/049/050), VP count 76->82 (+6: VP-AUTHDX-024..029), holdout scenarios 118 unchanged (none added in F2), total_stories 175 unchanged (F3 not started). Committed the F2 artifact set: specs/prd/bc-1-auth-identity.md, BC-INDEX.md, CANONICAL-COUNTS.md, edge-case-catalog.md, error-taxonomy.md, spec-changelog.md, phase-f2-spec-evolution/cycle-007-{prd,verification}-delta.md. Reconciled input-hash drift on cycle-007-verification-delta.md (stored 6f67438 vs computed fc636d3 -- inputs list grew during F2 authoring without a hash recompute; updated to fc636d3 via compute-input-hash --update). cycle-007-prd-delta.md's stored hash (edce8e8) already matched computed -- no drift. The other 6 committed F2 artifacts (bc-1-auth-identity.md, BC-INDEX.md, CANONICAL-COUNTS.md, edge-case-catalog.md, error-taxonomy.md, spec-changelog.md) carry no input-hash frontmatter field by their own template shape -- not applicable, not drifted. Pre-existing systemic 165-artifact input-hash drift (F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING) is accepted standing debt, unaffected by this burst, out of scope. Ran scripts/check-spec-counts.sh and scripts/check-bc-cumulative-counts.sh before committing -- both green (757 total across 9 files). Added Phase Progress row F2-SPEC-EVOLUTION-CYCLE-007 (CONVERGED, awaiting human gate); archived the oldest Phase Progress row to cycles/HISTORY-PHASE-PROGRESS.md to hold the live table at 7 rows. F1's row remains inline this burst (now reads APPROVED via DEC-354) alongside the new F2 row -- next burst will archive it once F2 closes. version: 4.09->4.10 (exactly one bump). pipeline stays ACTIVE. F2 explicitly NOT recorded as APPROVED -- that DEC lands at the human F2 gate."
current_step: "D-chain cite D-053, D-2026 latest brownfield. CYCLE-007 F2 CONVERGED: state-manager recorded (1) DEC-354, the human's F1 scope-gate approval (2026-09-10, 6-issue scope: #784/#786/#787/#788/#790/#783; #785 deferred; #786 narrowed to the two src/api/auth.rs sites; #787+#788 share one auth_method-aware vocabulary), and (2) F2 spec convergence (10 adversary passes, 3 consecutive CLEAN 8/9/10, spec 2.2.0->2.3.0 MINOR) -- in a single atomic burst on factory-artifacts (TD-VSDD-053), per orchestrator instruction. F2 status: CONVERGED, awaiting human F2 gate -- explicitly NOT APPROVED this burst. Counts updated: total_bcs 754->757, VP count 76->82, holdout scenarios 118 unchanged, total_stories 175 unchanged. current_cycle frontmatter updated to phase F2 (converged, awaiting human gate). Reconciled input-hash drift on cycle-007-verification-delta.md (6f67438->fc636d3); cycle-007-prd-delta.md already matched (edce8e8). version: 4.09->4.10 (exactly one bump, no double-bump). scripts/check-spec-counts.sh + scripts/check-bc-cumulative-counts.sh both re-verified green before commit. trajectory-tail unchanged →1→3→0→2 (F2 spec convergence is a document-review loop, not the F5 adversarial code-review loop this counter tracks)."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-007-auth-correctness-dx (F1 APPROVED via DEC-354; F2 spec evolution CONVERGED, awaiting human F2 gate)"
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

<!-- STATE.md SIZE BUDGET (2026-09-10, CYCLE-007-F2-CONVERGED checkpoint -- pipeline stays
     ACTIVE this burst, cycle-007 (auth-correctness-dx) is the sole OPEN cycle, now at Phase F2
     (spec evolution) CONVERGED / awaiting human gate, with F1 retroactively recorded APPROVED via
     DEC-354; all six prior cycles (001-006) remain CLOSED, historical; line count refreshed after
     this burst's Write):
     This is a PHASE-TRANSITION burst (state-manager, per orchestrator instruction -- records F1
     human-gate approval as DEC-354 and F2 spec convergence; explicitly does NOT record F2 as
     human-approved). `pipeline:` stays ACTIVE. `current_cycle:` and `feature_mode_bundle:`
     frontmatter updated to the F1-gate-approved 6-issue scope (#784/#786-narrowed/#787/#788/#790/
     #783; #785 deferred). `phase:`/`current_step:`/`last_amended:` rewritten via the
     verbatim-strict chain (each field's prior chained value is NOT nested inside the new one --
     overwritten per the last_amended write-path discipline), preserving `D-chain cite D-053,
     D-2026 latest brownfield.` and trajectory-tail `→1→3→0→2` (unchanged -- F2 spec convergence is
     a document-review adversarial loop, not the F5 code-review loop this counter tracks).
     `version:` 4.09 -> 4.10 (exactly one bump, no double-bump).
     Added ONE new Phase Progress row (`F2-SPEC-EVOLUTION-CYCLE-007`, status
     `CONVERGED (awaiting human gate)`) and archived the table's oldest row
     (`SESSION-WRAP-PAUSE-2026-09-10`) to `cycles/HISTORY-PHASE-PROGRESS.md` to hold the live table
     at 7 rows per the "recent 7" convention. The `F1-DELTA-ANALYSIS-CYCLE-007` row from the prior
     burst is KEPT inline this burst (its Status cell updated to reflect DEC-354 approval) rather
     than archived immediately, so the F1->F2 transition is visible in one screen; it will be
     archived on the NEXT burst once F2 itself closes.
     Counts: total_bcs 754->757 (+3: BC-1.6.048/049/050, bc-1-auth-identity.md 80->83 cumulative,
     69->72 individually-bodied); VP count 76->82 (+6: VP-AUTHDX-024..029); holdout scenarios 118
     unchanged (F2 added none); total_stories 175 unchanged (F3 not started). All count surfaces
     (STATE.md frontmatter/body, BC-INDEX.md, CANONICAL-COUNTS.md) re-verified consistent via
     `scripts/check-spec-counts.sh` + `scripts/check-bc-cumulative-counts.sh`, both green (757
     total across 9 files) before this commit.
     Minted DEC-354 (F1 human-gate approval, 2026-09-10) in the Decisions Log -- the placeholder
     "no DEC yet" row from the prior burst is replaced with the real decision record.
     input-hash reconciliation this burst: `phase-f2-spec-evolution/cycle-007-verification-delta.md`
     showed drift (stored `6f67438` vs computed `fc636d3` -- its `inputs:` list grew mid-authoring
     without a hash recompute); updated via `compute-input-hash --update` to `fc636d3`.
     `phase-f2-spec-evolution/cycle-007-prd-delta.md`'s stored hash (`edce8e8`) already matched
     computed -- no drift, no action. The other 6 committed F2 artifacts carry no `input-hash`
     frontmatter field at all by their own template shape (BC-INDEX/CANONICAL-COUNTS/edge-case-
     catalog/error-taxonomy/spec-changelog/bc-1-auth-identity are not `inputs:`-hashed artifact
     types) -- not applicable, not drifted. The pre-existing systemic 165-artifact drift
     (`F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING`) is unaffected, accepted standing debt,
     out of scope for this burst.
     soft target 200 lines; hard cap 500 lines. 238 lines (wc-l) (this file, this Write) -- up
     from 232 lines pre-burst net of the DEC-354 mint, the new F2-SPEC-EVOLUTION-CYCLE-007 Phase
     Progress row, and the input-hash reconciliation narrative added to this banner.
     margin from soft-target = 238 - 200 (OVER the soft target; acceptable one-burst transient per
     the extract-history/keep-live-state principle -- a future `/compact-state` pass will
     re-condense once cycle-007 has run a few more bursts).
     margin from actual = 500 - 238 (headroom remains before the hard cap).
     RECOVERY CONTEXT: no crash this burst -- a planned phase-transition event, verified via a
     fresh read of this file before writing (still v4.09/F1-analysis-complete/no-F2-artifacts-
     committed, prior state intact) -- this Write/commit is the first and only landing of this
     event.
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
| **Pipeline Status** | **ACTIVE** -- cycle-007 (`auth-correctness-dx`) OPEN, Feature Mode; Phase F1 APPROVED (DEC-354, 2026-09-10); Phase F2 (spec evolution) CONVERGED, awaiting human gate (F2->F3). All six prior cycles (001-006) remain CLOSED -- see `cycles/CYCLE-SUMMARY.md` |
| **trajectory-tail** | →1→3→0→2 (unchanged -- F2 spec convergence is a document-review adversarial loop, not the F5 code-review loop this counter tracks) |
| **Last Updated** | 2026-09-10, cycle-007 F1 gate APPROVED (DEC-354) and F2 spec evolution CONVERGED, awaiting human F2 gate. trajectory-tail →1→3→0→2 (unchanged). Full prior per-cycle history: `cycles/CYCLE-SUMMARY.md` |
| **Current Phase** | cycle-007 (`auth-correctness-dx`) F2 (spec evolution) -- **CONVERGED, awaiting human scope gate (F2->F3).** 6-issue F1-gate-approved scope (#784/#786-narrowed/#787/#788/#790/#783; #785 deferred); core touch point `src/api/auth.rs` (HIGH regression risk, 3rd consecutive cycle); 10 adversary passes total, 3 consecutive CLEAN (8/9/10); 3 new BCs (BC-1.6.048/049/050) + amendments to BC-1.4.032/033/034 + BC-1.6.047; 6 new VPs (VP-AUTHDX-024..029); spec 2.2.0->2.3.0 (MINOR). Detail: `phase-f2-spec-evolution/cycle-007-prd-delta.md`, `phase-f2-spec-evolution/cycle-007-verification-delta.md`. cycle-001 through cycle-006 all CLOSED, historical -- see `cycles/CYCLE-SUMMARY.md`. |
| **Activation HEAD** | `a9168212` (unchanged -- no release tag cut; `develop`'s real tip is `14e695ae`) |

## Phase Progress (recent 7; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **MAINTENANCE-CLAUDE-MD-COMPACTION-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Root `CLAUDE.md` compacted, MERGED to `develop` @ `a1f37995` via PR #797. Size 163,850->89,634 bytes (-45%); 458->397 lines. Detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md`. | counts unchanged; no DEC minted |
| **E2E-CI-DYNAMIC-TESTS-DELIVERED-2026-09-10** | **COMPLETE** | 2026-09-10 | Bookkeeping only, no quality gate | Resolved `E2E-CI-DYNAMIC-TESTS-WIP-UNVERIFIED`: branch `test/e2e-dynamic-parent-editfield` @ `6bfc2a0a` rebased, verified green, MERGED to `develop` @ `3a874d90` via PR #798. New follow-up: `E2E-DISCOVER-SAFE-EDIT-FIELD-VALIDATED-SUBTYPE` (see `cycles/OPEN-STANDING-ITEMS.md`). | counts unchanged; no DEC minted |
| **MUTANTS-NIGHTLY-REBALANCE-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Nightly mutation run `34478602590` ended `cancelled` (4/16 shards, PARTIAL data). Fix via PR #799 (merged @ `78aeb86c`): rebalanced N=16->24 shards + timeout 240->300 + completion-sentinel guard. New follow-up: `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` (see Drift/Standing Items below). | counts unchanged; no DEC minted |
| **STATE-MD-COMPACT-2026-09-10** | **COMPLETE** | 2026-09-10 | Maintenance bookkeeping (`/compact-state` skill), state-manager-executed, no quality gate | Extracted historical content (frontmatter cycle-status prose, SIZE BUDGET banner, 2 oldest Phase Progress rows, full Current-Phase-Steps checklist, Decisions-Log narrative notes, resolved+open Drift/Standing-Items detail, cycle-002/003/004 Skip Log rows, verbose Historical-Content descriptions, full live Session-Resume-Checkpoint text) into `cycles/` files -- nothing deleted, every pointer resolves. STATE.md 447->196 lines, single full-content Write. `STATE-MD-OVER-SOFT-TARGET` marked RESOLVED. | counts unchanged (754/76/118/175); no DEC minted -- maintenance event |
| **MAINTENANCE-SWEEP-2026-09-10** | **COMPLETE, FULLY CLOSED** | 2026-09-10 | Maintenance bookkeeping, no quality gate | Human-requested maintenance sweep CLOSED in one atomic burst (TD-VSDD-053): 2 read-only scans (dependency audit -- `develop` dependency-clean, 0 RUSTSEC advisories, 1 actionable LOW: `chacha20` 0.10.0 yanked; doc drift -- PR #797 compaction verified clean, 8 findings) + open-PR triage (10 open PRs, `auto_merge=false`). Fix PR #800 (`chacha20` 0.10.0->0.10.2) + doc-sync PR #801 opened. 3 factory doc-hygiene items (`CYCLE5-F7-DOC-1`, `CYCLE5-F7-DOC-2`, `CYCLE5-STEP45-LOW-1`) RESOLVED same commit. 5 cargo Dependabot PRs (syn) re-confirmed correctly held; `#792`/`#628` deferred by human. **CLOSING UPDATE (same day):** all 4 merges (`#800`, `#801`, `#779`, `#754`) subsequently MERGED to `develop` by human action; `develop` tip advanced `78aeb86c` -> `14e695ae` (`#779`=`211ae959`, `#754`=`d4760cd5`, `#800`=`522f9ba2`, `#801`=`14e695ae`). Sweep is now fully closed, zero outstanding actions. Full report: `maintenance/sweep-report-2026-09-10.md`. | counts unchanged (754/76/118/175); no DEC minted |
| **F1-DELTA-ANALYSIS-CYCLE-007** | **APPROVED (DEC-354)** | 2026-09-10 | Feature Mode F1 human scope gate | architect's delta analysis for the 7-issue auth bundle HUMAN GATE APPROVED 2026-09-10: 6-issue scope (#784/#786/#787/#788/#790/#783); #785 DEFERRED (parked); #786 NARROWED (only the two `src/api/auth.rs` credential-absence sites -> exit 2, unknown-profile stays 64, BC-1.1.004 unchanged); #787+#788 share one auth_method-aware "configured" vocabulary. Core touch point `src/api/auth.rs` (HIGH regression risk, 3rd consecutive cycle). Detail: `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`. | counts unchanged (754/76/118/175) at F1; DEC-354 minted |
| **F2-SPEC-EVOLUTION-CYCLE-007** | **CONVERGED (awaiting human gate)** | 2026-09-10 | Feature Mode F2, 3-clean adversarial convergence; human gate PENDING | 3 new BCs (BC-1.6.048/049/050) + amendments to BC-1.4.032/033/034 + BC-1.6.047, VP 76->82 (+6: VP-AUTHDX-024..029), spec 2.2.0->2.3.0 (MINOR), 10 adversary passes total / 3 consecutive CLEAN (8/9/10) to convergence. Notable caught-and-fixed defects across rounds: auth_method-aware probe correctness (BC-1.6.049), `Result<bool>`->`bool` realizability fix, 3-channel-parity narrowed to text-projection scope, NFR-O-N retirement deferred to F4 (activation, not spec), propagation sweeps across BC-INDEX/CANONICAL-COUNTS/error-taxonomy/edge-case-catalog. Detail: `phase-f2-spec-evolution/cycle-007-prd-delta.md`, `phase-f2-spec-evolution/cycle-007-verification-delta.md`. | counts: BCs 754->757, VPs 76->82; DEC-354 minted at F1 gate (this row's own F2 gate DEC pending) |

## Current Phase Steps

**cycle-007 (`auth-correctness-dx`) is now at Phase F2, CONVERGED.** F1 (delta analysis) was HUMAN GATE APPROVED 2026-09-10 as DEC-354 -- 6-issue scope (#784/#786-narrowed/#787/#788/#790/#783), #785 deferred. F2 (spec evolution) then ran 10 total adversary passes, reaching 3 consecutive CLEAN passes (8/9/10) to convergence: product-owner authored `phase-f2-spec-evolution/cycle-007-prd-delta.md` (3 new BCs BC-1.6.048/049/050 + amendments to BC-1.4.032/033/034/BC-1.6.047 in `specs/prd/bc-1-auth-identity.md`, plus propagation to `BC-INDEX.md`/`CANONICAL-COUNTS.md`/`error-taxonomy.md`/`edge-case-catalog.md`/`spec-changelog.md`); formal-verifier authored `phase-f2-spec-evolution/cycle-007-verification-delta.md` (6 new VPs VP-AUTHDX-024..029). **F2 is NOT yet human-approved** -- next step is the human scope gate (F2->F3); do not proceed to story decomposition until that approval lands. No other phase is currently mid-execution. The last completed pipeline-phase checklist before this cycle was cycle-005 Burst 13 (F7 delta convergence, cycle CLOSE) -- its full 15-step checklist is preserved at `cycles/cycle-005/burst-log.md` (Appendix). MAINTENANCE-SWEEP-2026-09-10's steps are summarized in the Phase Progress row above and `maintenance/sweep-report-2026-09-10.md`.

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| *(none yet for cycle-007 F2)* | F2 spec evolution is CONVERGED (10 passes, 3 consecutive CLEAN) but explicitly NOT human-approved this burst -- no DEC minted for F2 yet. The next DEC will record the human's F2 scope-gate decision (approve/adjust/reject) once made. | -- | F2 (pending gate) | -- | -- |
| DEC-354 | cycle-007 (`auth-correctness-dx`) Phase F1 (delta analysis) **HUMAN GATE APPROVED**, 2026-09-10 -- 6-issue scope: #784, #786 (narrowed), #787, #788, #790, #783. **#785** (headless `JR_EMAIL`/`JR_API_TOKEN` credential resolution) **DEFERRED** ("skip for now", parked, not scheduled into any cycle). **#786 NARROWED**: only the two `src/api/auth.rs` credential-absence sites (`load_api_token`'s no-stored-credentials and incomplete-pair branches) reclassify from `JrError::UserError`/exit 64 to `JrError::NotAuthenticated`/exit 2; the unrelated `auth status --profile <unknown>` unknown-profile site (BC-1.1.004) stays exit 64, unchanged -- the two failure classes are categorically distinct (profile has no credentials vs. profile doesn't exist). **#787 + #788 share one auth_method-aware "configured" vocabulary** -- a single shared BC (BC-1.6.048) defines the `unset`/`no-credentials`/`configured` state taxonomy that both `auth list`'s STATUS column (#788, BC-1.6.049) and `auth status --output json` (#787, BC-1.6.050) consume, rather than each issue growing its own ad hoc classification. | Human reviewed the architect's F1 delta-analysis report (`phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`) and the 3 open scope questions recorded at its §5, and made an explicit scope-gate ruling on each | F1 (gate) | 2026-09-10 | human (explicit F1-gate approval) |
| DEC-353 | cycle-005 (`adf-mentions`, GitHub #674) Phase F7 (delta convergence) **HUMAN GATE APPROVED / cycle CLOSED**, 2026-09-09, **NO RELEASE**. 5-dimensional delta convergence PASS: (1) Spec -- F2 approved (DEC-346); (2) Story/Test -- F3 approved (DEC-347), all 15+17 ACs realized; (3) Implementation -- merged to `develop @ cef4a021` (Wave 1 PR #778 @ `708c8b32`, Wave 2 PR #794 @ `0eaf4268`, F5 fix FIX-F5-001 PR #795 @ `cef4a021`); (4) Verification -- F6 HARDENED, 20/21 VPs covered, sharded mutation gate ran clean in-line on both product PRs; (5) Regression -- full CI green on `develop @ cef4a021`. **NO RELEASE CUT** -- feature ships on `develop`, unreleased; tag deferred to a future release riding cycle-005 + cycle-006 | Human reviewed the complete 5-dimensional delta-convergence evidence package and explicitly approved closing the cycle without cutting a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| DEC-352 | cycle-005 (`adf-mentions`) Wave-1 story `S-cycle5-mention-pure-conversion` (PR #778) **MERGED to `develop` via the >120-mutation escape-hatch ADMIN-BYPASS**, human-authorized, 2026-09-09. Squash-merge commit `708c8b32`. PR #778's `src/adf.rs` diff generated **281 in-diff mutants** (> the 120-mutant escalation threshold), so the cycle-006 sharded mutation gate correctly **ESCALATED** -- the FIRST real production exercise of the escape hatch. Local `cargo mutants --in-diff` safety-net run showed 66 caught / **0 missed** / 21 timeout (environmental) / 9 unviable | Human judged the risk of merging a >120-mutant diff acceptable via admin-bypass rather than splitting or deferring | F4 (delivery) | 2026-09-09 | human (explicit admin-bypass authorization) |
| (358 older decisions) | DEC-351 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-09 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**cycle-007 decisions detail (Bursts 1-2, F1 APPROVED via DEC-354, F2 CONVERGED awaiting gate):** full F1 delta-analysis report at `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`; issue triage sources at `phase-f1-delta-analysis/issue-triage-{auth,enhancement}-cluster-2026-09-10.md`; F2 PRD delta at `phase-f2-spec-evolution/cycle-007-prd-delta.md`; F2 verification delta at `phase-f2-spec-evolution/cycle-007-verification-delta.md`.

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

**NONE OPEN.** Zero Blocking Issues remain open anywhere in the factory. cycle-007 is OPEN at F2 (converged, awaiting human gate, not yet blocked on anything); all six prior tracked cycles are CLOSED. Resolved items (`F-PE-MED-001`, `R-F2`, `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`, `E2E-CI-DYNAMIC-TESTS-WIP-UNVERIFIED`, `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1`, `STATE-MD-OVER-SOFT-TARGET`): `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking standing debt (not gate-blocking): `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) is OPEN at Phase F2 (spec evolution) -- CONVERGED (10 adversary passes total, 3 consecutive CLEAN 8/9/10), awaiting human scope gate; F1 APPROVED via DEC-354. All six prior tracked cycles (001-006) are CLOSED. cycle-002 RELEASED as `v0.7.0-dev.3`; cycle-003 RELEASED as `v0.7.0-dev.4`; cycle-004 RELEASED as `v0.7.0-dev.5`; cycle-005 (`adf-mentions`, GitHub #674) and cycle-006 (`mutants-ci-sharding`) both CLOSED with NO release cut (ship on `develop @ cef4a021` / `a9168212`, tag deferred to a future release riding both, likely alongside cycle-007). Full per-cycle convergence detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Seven tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) OPEN** at Phase F2 (CONVERGED, awaiting human gate; F1 APPROVED via DEC-354). `develop`'s real tip is `14e695ae` (all 4 MAINTENANCE-SWEEP-2026-09-10 merges landed: #779, #754, #800, #801); `activation_head` frontmatter stays `a9168212` -- no release tag cut. Pipeline ACTIVE. Live-Jira E2E round-trip (`H-NEW-MENTION-009`, AC-017) remains DEFERRED, a human-owned post-close standing follow-up from cycle-005. Full per-cycle detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative (cycle-005/006 CLOSE + earlier F1-F7 detail, the SESSION-WRAP PAUSE account, the MUTANTS-NIGHTLY-REBALANCE narrative, cycle-004 maintenance items, PROCESS-GAP items, and Standing items) is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim, nothing deleted: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing in this section is currently blocking. cycle-007's own constraint (F1 HIGH regression risk on `src/api/auth.rs`, 3rd consecutive cycle) is carried in the Phase Progress row and `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`, not duplicated here.

## Session Resume Checkpoint

**Date:** 2026-09-10. **Pipeline: ACTIVE** (cycle-007 `auth-correctness-dx`, F1 APPROVED via DEC-354, F2 CONVERGED this burst). **Position:** cycle-007 is the sole OPEN cycle, at Phase F2 (spec evolution) -- CONVERGED (10 adversary passes total, 3 consecutive CLEAN 8/9/10), **awaiting the human scope gate (F2->F3)**. All six prior tracked cycles (001-006) remain CLOSED. **NEXT** = present the F2 spec delta (`phase-f2-spec-evolution/cycle-007-prd-delta.md`, `phase-f2-spec-evolution/cycle-007-verification-delta.md`) to the human for the F2 scope-gate decision; do not begin F3 story decomposition before that approval lands.

**Convergence counter:** F2 spec-evolution adversarial loop reached convergence at pass 10 (3 consecutive CLEAN passes 8/9/10). The trajectory-tail frontmatter field (`→1→3→0→2`) tracks a DIFFERENT counter (F5 code-review loop) and is unaffected -- no code exists yet for cycle-007 (F4 not started).

**In-flight work:** cycle-007 F2 spec evolution, converged and awaiting human gate. MAINTENANCE-SWEEP-2026-09-10 remains fully CLOSED (unrelated, zero outstanding actions). No stories mid-TDD; no PRs open for cycle-007 yet (F3 story decomposition has not started).

**Pending human decisions / open follow-ups:** **cycle-007 F2 scope-gate approval** (new, this burst -- review the PRD delta and verification delta and either approve to proceed to F3, or request adjustments). Also unchanged from before: `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` (awaiting a scheduled nightly to confirm all 24 shards complete + a real kill rate) and `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` (engine follow-up, tracked in the vsdd-factory repo, not jira-cli). Four issue bundles remain PARKED pending future human go-ahead: cycle-008 (issue-io-quickwins), cycle-009 (bulk-by-jql), cycle-010 (read-index-lag), cycle-011 (filter-grammar) -- see Drift/Standing Items below.

**WIP branch list:** none.

**Resume command:** `/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`.

**Counts:** total_bcs 757 (+3 this burst: BC-1.6.048/049/050); VP count 82 (+6 this burst: VP-AUTHDX-024..029); holdout scenarios 118 (unchanged -- F2 added none); total_stories 175 (unchanged -- F3 not started). Prior checkpoint (STATE.md v4.09): archived to `cycles/cycle-007/session-checkpoints.md`.

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
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | see `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` for the full per-cycle path list |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`CYCLE-007-F2-SCOPE-GATE-PENDING`** -- new, this burst (supersedes the resolved `CYCLE-007-F1-SCOPE-GATE-PENDING`). cycle-007 F2 spec evolution is CONVERGED (10 adversary passes, 3 consecutive CLEAN 8/9/10) but explicitly NOT human-approved. Review `phase-f2-spec-evolution/cycle-007-prd-delta.md` + `phase-f2-spec-evolution/cycle-007-verification-delta.md` for the F2 scope-gate decision. `src/api/auth.rs` remains flagged HIGH regression risk (3rd consecutive cycle touching this file, after cycle-003 and cycle-004). Blocks F3 story decomposition until resolved.
- **`CYCLE-007-PARKED-BUNDLES`** -- same-day issue triage (2026-09-10) also disposed of the broader backlog: GitHub **#674 CLOSED** (already shipped, cycle-005, no further action); **#387 DEFERRED** (destructive history-rewrite -- a standalone repo-ops decision, out of Feature Mode scope, not scheduled into any cycle); 4 further bundles **PARKED** pending a future human go-ahead -- **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). None of the four are scheduled or scoped -- triaged and named only. Full triage: `phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md` and `phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap: vsdd-factory has no `compact-claude-md` capability mirroring `compact-state`; candidate follow-up in the vsdd-factory repo, NOT jira-cli.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. The mutants-nightly rebalance fix (N=16->24 shards, `timeout-minutes` 240->300, completion-sentinel guard; PR #799 @ `78aeb86c`) is statically validated only (actionlint/shellcheck/YAML-parse + local code-reviewer). A manual `workflow_dispatch` run, or the next scheduled 08:00 UTC nightly, must confirm all 24 shards complete within the 300-min cap and produce a real full-scope kill rate -- the true kill-rate-vs-90% posture is unknown until then.
- `STATE-MD-OVER-SOFT-TARGET` -- **RESOLVED 2026-09-10** (STATE-MD-COMPACT-2026-09-10 burst, `/compact-state`; STATE.md reduced 447->196 lines). Subsequent bursts (SESSION-WRAP-PAUSE-2026-09-10 formalization, MAINTENANCE-SWEEP-2026-09-10 STARTED/COMPLETE/MERGES-LANDED, cycle-007-OPEN, and this F2-convergence burst) have each re-added a small transient overage -- tracked, not re-opened as a distinct item; a future `/compact-state` pass will re-condense once cycle-007 has run a few more bursts.

**RESOLVED this burst:** `CYCLE-007-F1-SCOPE-GATE-PENDING` -- F1 approved via DEC-354, 2026-09-10.

**RESOLVED prior bursts (moved to `cycles/RESOLVED-DRIFT-ITEMS.md`):** `MAINTENANCE-SWEEP-2026-09-10-MERGES-PENDING` -- all 4 human-gated merges landed on `develop` 2026-09-10.

All other standing debt -- full text preserved, nothing deleted: OPEN items (cycle-005/006 close deferrals, cycle-002/003/004 LOW items, process-gaps, `PR-REVIEW-SELF-APPROVE-HOOK-LOOP`, Dependabot PRs, `VP-COUNT-RECONCILIATION`, the S-PG-* backlog, etc.) at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items and historical narrative at `cycles/RESOLVED-DRIFT-ITEMS.md`.
