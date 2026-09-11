---
document_type: pipeline-state
level: ops
version: "4.17"
status: active
producer: state-manager
timestamp: 2026-09-11T22:14:16Z
phase: "ACTIVE 2026-09-11. cycle-007 (auth-correctness-dx) OPEN, Feature Mode. F1 APPROVED 2026-09-10 (DEC-354) -- 6-issue scope (#784/#786-narrowed/#787/#788/#790/#783); #785 DEFERRED. F2 APPROVED 2026-09-10 (DEC-355) -- 3 new BCs BC-1.6.048/049/050 + amendments, 6 new VPs VP-AUTHDX-024..029, spec 2.2.0->2.3.0 MINOR. F3 HUMAN GATE APPROVED 2026-09-11 (DEC-356) -- 5 new stories (S-cycle7-credential-absence-fix closes #784+#786, S-cycle7-auth-state-derivation #788, S-cycle7-auth-status-json #787, S-cycle7-oauth-help-text-fix #790, S-cycle7-readme-migration-note #783), 28 points, 2 waves (Wave 1 A/B1/C/D=20pts, Wave 2 B2=8pts), acyclic (B1->B2 only cross-story edge). F4 (delta implementation) IN PROGRESS -- Story A (S-cycle7-credential-absence-fix) MERGED via PR #803 to develop @ 08021685 (stale-verdict PASSED @ 5a3fc8be; ci-gate PASS 25 checks; pr-reviewer APPROVE 0 findings; security-reviewer CLEAN 0 blocking; 3 CI fix cycles; demo skipped human decision). #784 auto-closed; #786 flagged for manual close (develop not main; confirm repo Zious11/jira-cli vs drbothen/... before closing). NEXT: B1/C/D Wave-1 in parallel (B1 rebase onto 08021685 needed); then Wave 2 = B2 (auth-status-json). All six prior cycles (001-006) CLOSED. Full prior narrative: F1/F2/F3 Phase Progress rows + cycles/cycle-007/session-checkpoints.md."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-11, v4.17, state-manager -- STORY-A-MERGED: PR #803 squash-merged to develop @ 08021685 (stale-verdict PASSED, covered_sha 5a3fc8be; ci-gate PASS 25 checks; pr-reviewer APPROVE 0 findings; security-reviewer CLEAN 0 blocking; 3 CI fix cycles). Demo skipped (human decision, cycle-005 precedent). #784 auto-closed; #786 manual-close action item recorded. develop tip 14e695ae->08021685. New NEXT = B1/C/D Wave-1 in parallel; Wave 2 = B2. v4.16 checkpoint archived. Counts unchanged: total_bcs 757, VP 82, holdout 118, total_stories 180."
current_step: "D-chain cite D-053, D-2026 latest brownfield. F4-WAVE-1-IN-PROGRESS. trajectory-tail →1→3→0→2 (Story A merged to develop; F5 code-review loop not yet started for remaining stories). develop tip advanced to 08021685 (PR #803 squash-merge). Wave-1 remaining: B1 .worktrees/S-cycle7-auth-state-derivation / feat/cycle7-auth-state-derivation (rebase onto 08021685 needed); C .worktrees/S-cycle7-oauth-help-text-fix / fix/cycle7-oauth-help-text; D .worktrees/S-cycle7-readme-migration-note / docs/cycle7-readme-migration-note. NEXT: B1/C/D in parallel (rebase B1 onto 08021685 first), then Wave 2 = B2."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-007-auth-correctness-dx (F1 APPROVED via DEC-354; F2 APPROVED via DEC-355; F3 APPROVED via DEC-356; F4 delta implementation IN PROGRESS -- Story A MERGED PR #803 @ develop@08021685; B1/C/D Wave-1 in parallel next; Wave 2 = B2 after B1 merge)"
feature_mode_bundle: "auth-correctness-dx: GitHub issues #784, #786 (narrowed), #787, #788, #790, #783 (6-issue F1-gate-approved scope); #785 DEFERRED"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: "SOH-ATTACHMENTS-1 CONVERGED + CLOSED 2026-07-25 (DEC-186, 5-dim PASS, MAXIMUM_VIABLE_REFINEMENT_REACHED); full text: cycles/CYCLE-SUMMARY.md#phase_3_status"
cycle_001_status: "list-read-ergonomics -- CLOSED (DEC-309), historical; see cycles/cycle-001/"
cycle_002_status: "field-dx -- CLOSED + RELEASED 2026-09-01 as v0.7.0-dev.3 (DEC-311). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_002_status"
cycle_003_status: "auth-profile-dx -- CLOSED + RELEASED 2026-09-03 as v0.7.0-dev.4 (PR #767). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_003_status"
cycle_004_status: "windows-correctness -- CLOSED + RELEASED 2026-09-06 as v0.7.0-dev.5 (DEC-343, PR #777). F1-F7 complete; full text: cycles/CYCLE-SUMMARY.md#cycle_004_status"
cycle_005_status: "adf-mentions -- CLOSED, NO RELEASE, 2026-09-09 (DEC-353; closes GitHub #674; ships on develop @ cef4a021, tag deferred). F1-F7 all APPROVED; full text: cycles/CYCLE-SUMMARY.md#cycle_005_status"
cycle_006_status: "mutants-ci-sharding -- CLOSED, NO RELEASE, 2026-09-09 (DEC-348/349/350/351; CI-infra-only). F1-F7 all APPROVED; PR #791 merged to develop @ a9168212; full text: cycles/CYCLE-SUMMARY.md#cycle_006_status"
activation_head: "a9168212"
activation_version: "v0.7.0-dev.5"
---

<!-- STATE.md SIZE BUDGET (2026-09-11, STORY-A-MERGED v4.17):
     Story A MERGED via PR #803 to develop @ 08021685. Skip Log +1 row (demo recording, Story A).
     Phase Progress rotated: F1-DELTA-ANALYSIS row evicted (oldest), STORY-A-MERGED-2026-09-11 added.
     Session Resume Checkpoint replaced (v4.16 archived). #786-MANUAL-CLOSE action item added.
     version: 4.16->4.17. soft target 200 lines; hard cap 500 lines.
     204 lines (wc-l). margin from soft-target = 200 - 204 = -4 (4 over). margin from actual = 500 - 204 = 296 (296 headroom). -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **ACTIVE** -- cycle-007 (`auth-correctness-dx`) OPEN, Feature Mode; Phase F4 (delta implementation) IN PROGRESS. Story A (`S-cycle7-credential-absence-fix`) **MERGED** via PR #803 to `develop` @ `08021685` (stale-verdict PASSED @ `5a3fc8be`; ci-gate PASS 25 checks; 3 CI fix cycles; demo skipped human decision). `develop` tip `14e695ae` → `08021685`. B1/C/D Wave-1 + Wave 2 (B2) pending. F1/F2/F3 all APPROVED (DEC-354/355/356). |
| **trajectory-tail** | →1→3→0→2 (Story A merged; F5 code-review loop not yet started for remaining stories) |
| **Last Updated** | 2026-09-11, STORY-A-MERGED: PR #803 squash-merged to `develop` @ `08021685` (stale-verdict PASSED @ `5a3fc8be`). trajectory-tail →1→3→0→2 (unchanged). demo skipped. #784 auto-closed; #786 manual close needed. Prior: STORY-A-STEP-4.5-CONVERGED. Full history: `cycles/CYCLE-SUMMARY.md` |
| **Current Phase** | cycle-007 (`auth-correctness-dx`) Phase F4 (delta implementation) -- **IN PROGRESS**. Story A MERGED (PR #803 @ `08021685`). B1 (`S-cycle7-auth-state-derivation`, needs rebase onto `08021685`) / C (`S-cycle7-oauth-help-text-fix`) / D (`S-cycle7-readme-migration-note`) Wave-1 in parallel; Wave 2 = B2 (`S-cycle7-auth-status-json`, depends on B1 merge). |
| **Activation HEAD** | `a9168212` (unchanged -- no release tag cut; `develop`'s real tip is `08021685`) |

## Phase Progress (recent 8; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **F2-SPEC-EVOLUTION-CYCLE-007** | **APPROVED (DEC-355)** | 2026-09-10 | Feature Mode F2 human scope gate | 3 new BCs (BC-1.6.048/049/050) + amendments, 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 MINOR; 10 adversary passes (3 consecutive CLEAN). Detail: `phase-f2-spec-evolution/`. | counts: BCs 754->757, VPs 76->82; DEC-355 minted |
| **F3-STORY-DECOMPOSITION-CYCLE-007** | **APPROVED (DEC-356)** | 2026-09-11 | Feature Mode F3, 11-pass adversarial convergence, human gate APPROVED | 5 new stories (28 points, 2 waves, acyclic B1->B2). **HUMAN GATE APPROVED 2026-09-11 (DEC-356)** -- A->B1 auth.rs merge-order note honored; `FIX-F6-A` deferral accepted. Detail: `cycles/cycle-007/phase-f3-stories/`. | 5 stories/28pts; story count 175->180. DEC-356 minted |
| **SESSION-WRAP-PAUSE-2026-09-11** | **COMPLETE** | 2026-09-11 | Session-lifecycle pause checkpoint, no quality gate | Paused cycle-007 at F4-start; F4 regression-baseline sub-agent was in-flight and was cleanly abandoned (re-runnable read-only, no worktrees/code). `pipeline:` ACTIVE -> PAUSED. | counts unchanged; DEC-356 minted (same burst) |
| **BOOKKEEPING-BURST-E2E-ADF-HEURISTIC-2026-09-11** | **COMPLETE** | 2026-09-11 | Bookkeeping only, no quality gate | Recorded `E2E-EDIT-FIELD-ADF-HEURISTIC` (LOW/non-blocking; `tests/e2e_live.rs::discover_safe_edit_field` ADF-field heuristic defect; deferred to next maintenance sweep). Detail: `cycles/OPEN-STANDING-ITEMS.md`. | counts unchanged; no DEC minted |
| **F4-BASELINE-GREEN-WAVE-1-STARTED-CYCLE-007** | **IN PROGRESS** | 2026-09-11 | Feature Mode F4 delta implementation; no gate yet | Resumed cycle-007 (PAUSED->ACTIVE). F4 regression baseline GREEN @ develop@`14e695ae`: 5,267 total / 5,091 pass / 0 fail / 176 ignored; clippy PASS; fmt PASS. Wave-1 worktrees created off develop@`14e695ae`: A/B1/C/D. Story A delivery started. | counts unchanged (757/82/118/180) |
| **PASS4-F2-SPEC-SWEEP-BOOKKEEPING-2026-09-11** | **COMPLETE** | 2026-09-11 | Bookkeeping only, no quality gate | Committed pass-4 F-2 spec sweep: `bc-1-auth-identity.md` equals-form propagation (BC-1.4.032/033/034 hints + BC-1.6.048 Inv-3 + BC-1.6.050 EC-4 + VP-AUTHDX-005/007/008/027 oracles); `spec-changelog.md` F-2 paragraph appended. `AUTH-REMEDIATION-EQUALS-FORM-BROADER` (LOW/non-blocking) recorded. | counts unchanged (757/82/118/180); no DEC minted |
| **STORY-A-STEP-4.5-CONVERGED-2026-09-11** | **CONVERGED** | 2026-09-11 | Step 4.5 per-story adversarial convergence | Story A (`S-cycle7-credential-absence-fix`) per-story adversarial review CONVERGED: 9 total passes (passes 7/8/9 CLEAN -> 3 consecutive CLEAN), final HEAD `67609600` on `fix/cycle7-credential-absence`. Scope: only `load_api_token` credential-absence branches + tests + CHANGELOG + in-scope rustdoc; `load_oauth_tokens`/`status.rs` zero-diff verified. 4 process-gaps codified in `cycles/cycle-007/lessons.md` (PG-A1..A4). | counts unchanged (757/82/118/180); no DEC minted |
| **STORY-A-MERGED-2026-09-11** | **MERGED** | 2026-09-11 | PR #803 squash-merge to `develop` @ `08021685` | Story A (`S-cycle7-credential-absence-fix`) PR #803 squash-merged. Stale-verdict PASSED (covered_sha `5a3fc8be`). CI ci-gate PASS (25 checks). pr-reviewer APPROVE (0 findings). security-reviewer CLEAN (0 blocking). 3 CI fix cycles. Demo skipped (human decision, cycle-005 precedent). #784 auto-closed; #786 manual close needed (`Zious11/jira-cli`). `develop` tip `14e695ae` → `08021685`. NEXT: B1/C/D Wave-1 in parallel. | counts unchanged (757/82/118/180); no DEC minted |

## Current Phase Steps

**cycle-007 (`auth-correctness-dx`) Phase F4 (delta implementation) IN PROGRESS.** Story A (`S-cycle7-credential-absence-fix`) **MERGED** via PR #803 (squash-merge to `develop` @ `08021685`, stale-verdict PASSED @ `5a3fc8be`; ci-gate 25 checks PASS; pr-reviewer APPROVE; security CLEAN; 3 CI fix cycles). Demo skipped (human decision, small CLI exit-code change, no UI surface, cycle-005 precedent). **#784 auto-closed.** **#786: manual close required** (merged to `develop` not `main`; confirm repo `Zious11/jira-cli` before closing). **NEXT: B1 (`S-cycle7-auth-state-derivation`) + C (`S-cycle7-oauth-help-text-fix`) + D (`S-cycle7-readme-migration-note`) Wave-1 in parallel; B1 must rebase onto `develop@08021685` first (carries `AUTH-REMEDIATION-EQUALS-FORM-BROADER` follow-up); Wave 2 = B2 (`S-cycle7-auth-status-json`) after B1 merge.** F4 discipline: targeted `cargo test` only for inner TDD loop; full regression serial at story end; NEVER `cargo nextest` -- see `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`.

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-356 | cycle-007 F3 (incremental story decomposition) **HUMAN GATE APPROVED**, 2026-09-11 -- 5-story decomposition (28 points, 2 waves, acyclic B1->B2) approved; proceeding to F4 as standard 2-wave plan -- A->B1 auth.rs merge-order honored; `FIX-F6-A` deferral accepted. | Human reviewed F3 story-decomposition package (5 stories, dependency graph, wave schedule, wave holdout scenarios), already CONVERGED via 11 adversary passes (pass 11 zero-novelty), and made explicit approval ruling | F3 (gate) | 2026-09-11 | human (explicit F3-gate approval) |
| DEC-355 | cycle-007 F2 (spec evolution) **HUMAN GATE APPROVED**, 2026-09-10 -- 3 new BCs (BC-1.6.048/049/050) + amendments + 6 new VPs (VP-AUTHDX-024..029), spec 2.2.0->2.3.0 MINOR; authorized proceeding to F3. | Human reviewed F2 PRD delta and verification delta (CONVERGED via 10 adversary passes, 3 consecutive CLEAN) and made explicit approval ruling | F2 (gate) | 2026-09-10 | human (explicit F2-gate approval) |
| DEC-354 | cycle-007 F1 (delta analysis) **HUMAN GATE APPROVED**, 2026-09-10 -- 6-issue scope: #784, #786 (narrowed), #787, #788, #790, #783; #785 DEFERRED. #786 NARROWED: two `src/api/auth.rs` credential-absence sites exit 64->2; unknown-profile stays 64. #787+#788 share auth_method-aware "configured" vocabulary (BC-1.6.048). | Human reviewed architect's F1 delta-analysis report and made explicit scope-gate ruling on each open question | F1 (gate) | 2026-09-10 | human (explicit F1-gate approval) |
| DEC-353 | cycle-005 (`adf-mentions`, GitHub #674) F7 (delta convergence) **HUMAN GATE APPROVED / cycle CLOSED**, 2026-09-09, **NO RELEASE**. 5-dimensional delta convergence PASS. Feature ships on `develop`; tag deferred. | Human reviewed complete 5-dimensional delta-convergence evidence package and explicitly approved closing cycle without cutting a release | F7 (gate) | 2026-09-09 | human (explicit approval) |
| (359 older decisions) | DEC-352 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-09 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**cycle-007 decisions detail (F1 APPROVED via DEC-354, F2 APPROVED via DEC-355, F3 APPROVED via DEC-356, F4 IN PROGRESS):** F1 delta-analysis report: `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`; F2 PRD delta: `phase-f2-spec-evolution/cycle-007-prd-delta.md`; F3 stories + wave artifacts: `cycles/cycle-007/phase-f3-stories/`; archived session checkpoints: `cycles/cycle-007/session-checkpoints.md`; F4 burst log: `cycles/cycle-007/burst-log.md`.

**cycle-005/006 decisions detail (Bursts 1-13 each, CLOSED 2026-09-09):** full per-burst narrative at `cycles/cycle-005/burst-log.md` and `cycles/cycle-006/burst-log.md` (both with Appendix).

## Skip Log

<!-- Full cycle-002/003/004 rows archived to cycles/HISTORY-SKIP-LOG.md; only the 2 most recent cycles' rows are kept inline. -->

| Step | Skipped? | Justification |
|------|----------|----------------|
| DTU creation (cycle-005) | yes | `dtu_required: false` -- targets Jira's own REST API surface, not a cloned third-party service. |
| UX Spec (cycle-005) | yes | `jr` is CLI-only; no new UI surface -- `adf-mentions` is a write-path conversion feature only. |
| Demo recording (cycle-005, Wave 2) | yes | Human decision: demos skipped for `S-cycle5-mention-resolution-wiring` (backend/no-UI CLI). |
| F6 Kani formal verification (cycle-005) | yes | Not set up in repo; proptest substitution justified. 0-GAP. |
| F6 cargo-fuzz (cycle-005) | yes | Not set up in repo; proptest arbitrary-input substitution justified. 0-GAP. |
| F6 DTU adversarial testing / accessibility re-check (cycle-005) | yes | `dtu_required: false`; write-path ADF conversion, no UI surface. |
| DTU creation (cycle-006) | yes | `dtu_required: no` -- `mutants-ci-sharding` is CI-tooling only. |
| UX Spec (cycle-006) | yes | `jr` is CLI-only; CI-workflow/policy-doc change with no product UI surface. |
| F5/F6 dedicated artifact subdirectory (cycle-006) | not skipped, folded | Feature-mode F5/F6 evidence folded into F7's 5-dimensional convergence record (DEC-351). |
| Demo recording (cycle-007, Story A) | yes | Human decision: small two-branch error-classification / exit-code CLI change, no UI surface; cycle-005 backend/no-UI-CLI precedent. |

**NOT a skip (human-owned post-close):** Live-Jira E2E round-trip acceptance (`H-NEW-MENTION-009`, AC-017) is **DEFERRED by human decision**, not skipped -- see `cycles/OPEN-STANDING-ITEMS.md`.

Older rows (cycle-001 through cycle-004, historical): `cycles/HISTORY-SKIP-LOG.md`.

## Blocking Issues

**NONE OPEN.** Zero Blocking Issues remain open. cycle-007 OPEN, ACTIVE at F4 (Story A MERGED; B1/C/D + Wave 2 pending); all six prior tracked cycles CLOSED. Resolved items: `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking: `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) OPEN, **ACTIVE**, F4 (delta implementation) IN PROGRESS. Story A MERGED (PR #803 @ `develop@08021685`). B1/C/D Wave-1 + Wave 2 (B2) pending. F1 APPROVED via DEC-354, F2 via DEC-355, F3 via DEC-356 (11 adversary story-review passes). Full detail: `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Seven tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) OPEN, ACTIVE** at F4 IN PROGRESS. Story A MERGED (PR #803 @ `develop@08021685`); B1/C/D + Wave 2 (B2) pending. `develop`'s real tip is `08021685`; `activation_head` stays `a9168212`. **Pipeline ACTIVE** -- F4 Wave-1 delivery in progress (B1/C/D remaining). Full detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing currently blocking. cycle-007 constraint (F1 HIGH regression risk on `src/api/auth.rs`, 3rd consecutive cycle; nextest unusable on dev host per `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`) carried in the Phase Progress row above.

## Session Resume Checkpoint

**Date:** 2026-09-11. **Pipeline: ACTIVE** (cycle-007 `auth-correctness-dx`, F4 delta implementation IN PROGRESS). **Position:** Story A (`S-cycle7-credential-absence-fix`) MERGED via PR #803 to `develop` @ `08021685` (stale-verdict PASSED @ `5a3fc8be`; ci-gate PASS 25 checks; pr-reviewer APPROVE 0 findings; security CLEAN 0 blocking; 3 CI fix cycles). Demo skipped (human decision). #784 auto-closed; #786 needs manual close (confirm repo `Zious11/jira-cli`). B1 (`S-cycle7-auth-state-derivation`), C (`S-cycle7-oauth-help-text-fix`), D (`S-cycle7-readme-migration-note`) pending Wave-1 delivery; Wave 2 = B2 (`S-cycle7-auth-status-json`, depends on B1 merge). All six prior cycles (001-006) CLOSED.

**NEXT** = B1 + C + D Wave-1 in parallel (B1 must rebase onto `develop@08021685` first per auth.rs merge-order; C and D from existing worktrees). Wave 2 = B2 after B1 merge.

**Open action item:** #786 -- NOT auto-closed by PR #803 merge to `develop` (keyword routes to `main` only). Close manually after confirming correct repo URL (`Zious11/jira-cli`, NOT the `drbothen/...` URL cited by pr-manager).

**Convergence counter:** Story A MERGED (demo skipped; Step-4.5 previously CONVERGED 9 passes). trajectory-tail (`→1→3→0→2`) unchanged -- F5 code-review loop for remaining stories not yet started.

**In-flight work:** `feat/cycle7-auth-state-derivation` (B1, needs rebase onto `08021685`), `fix/cycle7-oauth-help-text` (C), `docs/cycle7-readme-migration-note` (D) -- all Wave-1 worktrees off develop@`14e695ae` (B1 rebase before PR).

**Pending human decisions / open follow-ups:** #786 manual close (action item above); `AUTH-REMEDIATION-EQUALS-FORM-BROADER` (fold into B1/B2); `MUTANTS-NIGHTLY-VERIFY-FULL-RUN`, `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP`, `FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`. Prior: `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`, `E2E-EDIT-FIELD-ADF-HEURISTIC`. Four issue bundles PARKED: cycle-008 through cycle-011.

**WIP branch list:** `feat/cycle7-auth-state-derivation` (B1, needs rebase@`08021685`), `fix/cycle7-oauth-help-text` (C), `docs/cycle7-readme-migration-note` (D) -- all Wave-1 worktrees.

**Resume command:** `/vsdd-factory:next-step` (B1/C/D Wave-1 in parallel -- rebase B1 onto `08021685` first).

**Counts:** total_bcs 757 (unchanged); VP count 82 (unchanged); holdout scenarios 118 (unchanged); total_stories 180 (unchanged). Prior checkpoint (STATE.md v4.16): archived to `cycles/cycle-007/session-checkpoints.md`.

## Historical Content

Burst logs, adversary pass details, session checkpoints, and per-burst narrative for every cycle are in cycle files. Full inline descriptions: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md`.

| Content | Location |
|---------|----------|
| cycle-001 burst history | `cycles/cycle-001/burst-log.md` |
| cycle-002 burst history | `cycles/cycle-002/burst-log.md` (Bursts 1-20) |
| cycle-003 burst history | `cycles/cycle-003/burst-log.md` (Bursts 1-22) |
| cycle-004 burst history | `cycles/cycle-004/burst-log.md` (Bursts 1-22) |
| cycle-005 burst history | `cycles/cycle-005/burst-log.md` (Bursts 1-13 + Appendix) |
| cycle-006 burst history | `cycles/cycle-006/burst-log.md` (Bursts 1-13 + Appendix) |
| cycle-007 F1 delta analysis + issue triage | `phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md`, `phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md`, `phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md` |
| cycle-007 F2 spec evolution (PRD delta + verification delta) | `phase-f2-spec-evolution/cycle-007-prd-delta.md`, `phase-f2-spec-evolution/cycle-007-verification-delta.md` |
| cycle-007 F3 incremental stories (5 new stories + dependency graph + wave schedule + wave holdout scenarios) | `cycles/cycle-007/phase-f3-stories/` |
| cycle-007 F4 regression baseline | `phase-f4-implementation/regression-baseline.md` |
| cycle-007 session checkpoints | `cycles/cycle-007/session-checkpoints.md` |
| cycle-007 F4 burst log | `cycles/cycle-007/burst-log.md` |
| cycle-007 Story A Step-4.5 convergence detail | `cycles/cycle-007/adversarial-reviews/story-A-convergence.md` |
| cycle-007 lessons (process-gaps PG-A1..A4) | `cycles/cycle-007/lessons.md` |
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` (full per-cycle path list) |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |
| E2E ADF-field heuristic research | `research/e2e-environment-adf-field-2026-09-11.md` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`#786-MANUAL-CLOSE`** -- ACTION REQUIRED. PR #803 merged to `develop` (not `main`); GitHub's `Closes #786` keyword did not auto-close the issue. Close manually. Confirm correct repo URL (`Zious11/jira-cli`, NOT `drbothen/jira-cli` as cited by pr-manager) before closing.
- **`AUTH-REMEDIATION-EQUALS-FORM-BROADER`** -- LOW, non-blocking. `jr auth login --profile=<name>` equals-form (EC-1.4.032-6) applies beyond Story A: `load_oauth_tokens` stale-keyring + `auth logout` remediation strings still emit SPACE form. BC-1.6.048 Inv-3 + BC-1.6.050 EC-4 citations updated; B1/B2 implementations MUST emit equals-form. Candidate fix: fold into cycle-007 B1/B2 or a dedicated follow-up before F7. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking, still open (pre-existing since cycle-004). `.cargo/mutants.toml`'s `examine_globs` omits `src/api/auth.rs` and siblings. DEC-356 EXPLICITLY ACCEPTED the deferral. Target: a future SELF-IMPROVEMENT/maintenance cycle.
- **`CYCLE-007-PARKED-BUNDLES`** -- 2026-09-10 issue triage: #674 CLOSED; #387 DEFERRED; 4 bundles PARKED: **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). Full triage: `phase-f1-delta-analysis/issue-triage-*.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap: vsdd-factory has no `compact-claude-md` capability; candidate follow-up in the vsdd-factory repo, NOT jira-cli.
- `MUTANTS-NIGHTLY-VERIFY-FULL-RUN` -- LOW, non-blocking. PR #799's rebalance fix (N=16->24 shards, timeout 240->300) is statically validated only. A scheduled nightly must confirm.
- **`E2E-EDIT-FIELD-ADF-HEURISTIC`** -- LOW, non-blocking, test-infrastructure defect only. `tests/e2e_live.rs::discover_safe_edit_field` picks `environment` (ADF rich-text field) -> Jira 400; 106/107 E2E pass. Deferred to next maintenance sweep.
- **`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`** -- LOW, non-blocking, dev-host-only. macOS `syspolicyd` wedged after ~56-day uptime. `cargo-nextest` UNUSABLE for full suite. Serial `cargo test` reliable (~95 min). NOT a CI issue. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- `STATE-MD-OVER-SOFT-TARGET` -- **RESOLVED 2026-09-10**. Subsequent bursts re-added transient overage -- tracked, not re-opened; future `/compact-state` will re-condense.

**RESOLVED this burst:** none (STORY-A-MERGED bookkeeping only).

**RESOLVED prior burst:** `CYCLE-007-F4-BASELINE-RERUN-PENDING` -- F4 regression baseline re-run successfully GREEN @ develop@`14e695ae`.

**RESOLVED prior bursts (moved to `cycles/RESOLVED-DRIFT-ITEMS.md`):** `MAINTENANCE-SWEEP-2026-09-10-MERGES-PENDING`, `CYCLE-007-F1-SCOPE-GATE-PENDING`, `CYCLE-007-F2-SCOPE-GATE-PENDING`.

All other standing debt -- full text preserved, nothing deleted: OPEN items at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items and historical narrative at `cycles/RESOLVED-DRIFT-ITEMS.md`.
