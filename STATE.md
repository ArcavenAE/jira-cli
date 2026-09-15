---
document_type: pipeline-state
level: ops
version: "4.33"
status: active
producer: state-manager
timestamp: 2026-09-15T00:37:15Z
phase: "ACTIVE 2026-09-15. cycle-012 Phase F5 (scoped adversarial refinement) CONVERGED -- adversary 3/3 consecutive CLEAN (Passes A/B/C, VERDICT CLEAN NITPICK_ONLY, zero CRIT/HIGH/MED) on the post-fix delta, plus an initial pre-fix Pass 1 that surfaced OBS-1 (adversary, human-ruled) + H-1/M-1/M-3 (code-reviewer). Security-reviewer CLEAN throughout (0 CRIT/HIGH/MED; SEC-001 LOW pre-existing debug-only cache guard, not reachable via cycle-012 paths). Fix PR #813 (fix/cycle012-f5-findings) resolved all four Pass-1 findings and MERGED to develop as squash commit 80bb4215 (2026-09-15T00:14:11Z, --admin); fresh-eyes pr-reviewer APPROVE, CI 21/21 green incl. CI Gate, security review CLEAN. develop: 2a0b0fae -> 80bb4215. Worktree/branch cleaned up. NEXT = Feature Mode F6 (targeted hardening) [IN PROGRESS] -> F7 (delta convergence + human gate). cycle-007 PAUSED at F4 IMPL COMPLETE (Wave-2 gate pending)."
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
last_amended: "2026-09-15, v4.32->v4.33, state-manager -- cycle-012 Phase F5 CONVERGED (adversary 3/3 CLEAN Passes A/B/C; code-reviewer findings H-1/M-1/M-3 + adversary OBS-1 resolved; security CLEAN); fix PR #813 MERGED @ 80bb4215; develop 2a0b0fae->80bb4215. New LOW debt: M-2/OBS-A/OBS-3. NEXT = F6 targeted hardening (in progress) -> F7."
current_step: "CYCLE-012-F5-CONVERGED-2026-09-15: Phase F5 scoped adversarial refinement CONVERGED (adversary 3/3 CLEAN + code-review resolved + security CLEAN); fix PR #813 MERGED @ 80bb4215. NEXT = Feature Mode F6 (targeted hardening) [IN PROGRESS] -> F7 (delta convergence + human gate). D-chain cite D-2026 latest brownfield. trajectory-tail →1→3→0→2."
trajectory_tail: "→1→3→0→2"
maintenance_run:
  status: COMPLETE
  date: 2026-09-10
  trigger: manual (human request)
  findings_count: 8
  fixes_applied: 7
  fixes_pending: 0
  pr: "#800,#801 fix PRs MERGED; #779,#754 Dependabot bumps MERGED"
current_cycle: "cycle-012-field-adf-autoconvert (F5 CONVERGED -- adversary 3/3 CLEAN + code-review resolved + security CLEAN; fix PR #813 MERGED @ 80bb4215). NEXT = F6 targeted hardening (IN PROGRESS) -> F7 delta convergence + human gate. cycle-007 auth-correctness-dx PAUSED: F4 IMPL COMPLETE, Wave-2 gate PENDING, develop@80bb4215."
feature_mode_bundle: "field-adf-autoconvert: addresses E2E-EDIT-FIELD-ADF-HEURISTIC / test_e2e_issue_edit_custom_field pre-existing defect (confirmed pre-cycle-007 @ 14e695ae). Wave 1 COMPLETE + E2E-VERIFIED (PR #809 @ e926cb70; AC-014 strengthened PR #811 @ 67b3939a). Wave 2 (S-cycle12-jsm-adf-autoconvert, 13pts) COMPLETE -- MERGED PR #812 @ 2a0b0fae. F4 COMPLETE. F5 scoped adversarial CONVERGED -- fix PR #813 MERGED @ 80bb4215 (OBS-1/H-1/M-1/M-3 resolved). NEXT: F6 targeted hardening."
cycle_012_status: "field-adf-autoconvert -- ACTIVE, Feature Mode, F5 CONVERGED. Story 1 (S-cycle12-platform-adf-autoconvert) MERGED PR #809 @ e926cb70; AC-014 strengthened PR #811 @ 67b3939a. Story 2 (S-cycle12-jsm-adf-autoconvert, 13pts) MERGED PR #812 @ 2a0b0fae; Wave 2 COMPLETE; F4 COMPLETE. Phase F5 (scoped adversarial refinement): adversary Pass 1 (pre-fix) surfaced OBS-1 (changed_fields --output json scope-leak, human-ruled: narrow to ADF fields only) + code-reviewer H-1 (jsm_create.rs missing from CLAUDE.md Known Size Deviations) + M-1 (field_resolve.rs size entry stale) + M-3 (stale isAdfRequest comment); all four resolved in fix PR #813 (fix/cycle012-f5-findings). Re-review Passes A/B/C: 3/3 consecutive CLEAN (VERDICT CLEAN NITPICK_ONLY, zero CRIT/HIGH/MED) -- F5 CONVERGED. Security-reviewer CLEAN throughout (SEC-001 LOW pre-existing, not reachable via cycle-012 paths). PR #813 MERGED squash @ 80bb4215 (2026-09-15T00:14:11Z, --admin); fresh-eyes pr-reviewer APPROVE, CI 21/21 green incl. CI Gate, security CLEAN; worktree/branch cleaned up. New LOW debt registered: M-2 (triplicated --markdown+--field-description guard predicate), OBS-A (environment changed_fields arm lacks non-gated regression test), OBS-3 (EC-3.8.019-4 supersession case untested). F1 APPROVED DEC-357, F2 APPROVED DEC-358 (DEC-359), F3 APPROVED DEC-360. NEXT = F6 targeted hardening (formal verification, fuzz/mutation testing scoped to the delta) -> F7 delta convergence + human gate. total_bcs 769, VPs 86, total_stories 182."
cycle_007_status: "auth-correctness-dx -- PAUSED at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@80bb4215). F1 APPROVED DEC-354, F2 APPROVED DEC-355, F3 APPROVED DEC-356. All 5 stories merged (PRs #803/805/804/806/#807). Resumable after cycle-012 closes."
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

<!-- STATE.md SIZE BUDGET (2026-09-15, CYCLE-012-F5-CONVERGED v4.33):
     cycle-012 Phase F5 scoped adversarial refinement CONVERGED (3/3 CLEAN); fix PR #813 MERGED. v4.32->v4.33.
     soft target 200 lines; hard cap 500 lines. 210 lines (wc-l). margin from soft-target = -10 (10 lines over); margin from actual = 290. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Pipeline Status** | **ACTIVE** -- cycle-012 (`field-adf-autoconvert`) Phase F5 (scoped adversarial refinement) **CONVERGED**: adversary 3/3 consecutive CLEAN (Passes A/B/C, zero CRIT/HIGH/MED) on the post-fix delta; code-reviewer findings (H-1/M-1/M-3) + adversary OBS-1 resolved in fix PR #813 (`fix/cycle012-f5-findings`), squash-merged @ `80bb4215` (2026-09-15T00:14:11Z, `--admin`); security-reviewer CLEAN throughout. `develop`: `2a0b0fae` -> `80bb4215`. NEXT = Feature Mode F6 (targeted hardening) IN PROGRESS -> F7 (delta convergence + human gate). cycle-007 (`auth-correctness-dx`) **PAUSED** at F4 IMPL COMPLETE (Wave-2 gate PENDING). |
| **trajectory-tail** | →1→3→0→2 (cycle-012 F2 CLOSED, 33 passes, MAXIMUM_VIABLE_REFINEMENT_REACHED) |
| **Last Updated** | 2026-09-15, CYCLE-012-F5-CONVERGED: v4.32->v4.33; F5 scoped adversarial CONVERGED (adversary 3/3 CLEAN + code-review resolved + security CLEAN); fix PR #813 MERGED @ 80bb4215. NEXT = F6 targeted hardening (in progress) -> F7. trajectory-tail →1→3→0→2. |
| **Current Phase** | cycle-012 Phase F5 CONVERGED -- Phase F6 (targeted hardening) IN PROGRESS. cycle-007 Phase F4 IMPL COMPLETE (PAUSED). |
| **Activation HEAD** | `a9168212` (unchanged; `develop`'s real tip is `80bb4215`) |

## Phase Progress (recent 10; full history: `cycles/HISTORY-PHASE-PROGRESS.md` + `cycles/cycle-00{1..6}/burst-log.md` + factory-artifacts@43f4a5e3)

| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **SESSION-WRAP-PAUSE-2026-09-13** | **COMPLETE** | 2026-09-13 | Bookkeeping only, session wrap; no quality gate | STATE.md v4.24->v4.25, pipeline ACTIVE->PAUSED at cycle-012 F4-start. sidecar-learning.md committed. | counts unchanged (769/86/118/182) |
| **CYCLE-012-F4-STARTED-2026-09-13** | **COMPLETE** | 2026-09-13 | per-story TDD delivery | global STORY-INDEX 180->182 registered; pipeline ACTIVE; CI/CD gate PASS (develop@`30bb1a18`); Story 1 delivery starting. v4.25->v4.26. | 769 BCs / 86 VPs / 118 holdout / 182 stories |
| **CYCLE-012-STORY1-DELIVERED-2026-09-14** | **COMPLETE** | 2026-09-14 | Story 1 per-story TDD delivery + merge | S-cycle12-platform-adf-autoconvert MERGED PR #809 @ `e926cb70` (squash, `develop`). Step 4.5 CONVERGED 3 consecutive CLEAN (7 passes total). 8 BCs (BC-3.3.013/014/015, BC-3.4.033-037) + 4 VPs (VP-FIELD-ADF-001/002/003/004). rustls RUSTSEC-2026-0285 cleared (PR #810 @ `71d98800`). develop: `30bb1a18`->`71d98800`->`e926cb70`. Wave 1 COMPLETE; Wave 2 ELIGIBLE. v4.26->v4.27. | 769 BCs / 86 VPs / 118 holdout / 182 stories |
| **CYCLE-012-STORY1-E2E-VERIFIED-2026-09-14** | **COMPLETE** | 2026-09-14 | E2E live-Jira verification; AC-014 adaptive read-back strengthened (PR #811) | `test_e2e_issue_edit_custom_field` PASSED live Jira (run `34881320608` @ `develop@67b3939a`). PR #811 MERGED (`67b3939a`, squash) -- ADF-aware assertion. E2E-EDIT-FIELD-ADF-HEURISTIC RESOLVED/VERIFIED. E2E-COMPONENT-FILTER-SEARCH-INDEX-FLAKE registered (LOW). L-007 added. develop: `71d98800`->`e926cb70`->`67b3939a`. v4.27->v4.28. | counts unchanged (769/86/118/182) |
| **SESSION-WRAP-PAUSE-2026-09-14** | **COMPLETE** | 2026-09-14 | Bookkeeping only, session wrap; no quality gate | pipeline ACTIVE->PAUSED at cycle-012 Wave-1-complete/E2E-verified boundary; v4.28->v4.29; session wrap | counts unchanged (769/86/118/182) |
| **CYCLE-012-WAVE2-F4-STARTED-2026-09-14** | **COMPLETE** | 2026-09-14 | per-story TDD delivery start | pipeline PAUSED->ACTIVE. Local develop fast-forwarded to `67b3939a` (was `30bb1a18`); Main-Checkout Sync Protocol pre-check ran CLEAN. Worktree created: `.worktrees/S-cycle12-jsm-adf-autoconvert`, branch `feat/cycle12-jsm-adf-autoconvert`, base `67b3939a`. Story 2 (`S-cycle12-jsm-adf-autoconvert`, 13pts, strict TDD) delivery starting; Red Gate about to begin. v4.29->v4.30. | counts unchanged (769/86/118/182) |
| **CYCLE-012-STORY2-CONVERGED-2026-09-14** | **COMPLETE** | 2026-09-14 | Step 4.5 3/3 CLEAN + demo skip | S-cycle12-jsm-adf-autoconvert Step 4.5 CONVERGED -- 3 consecutive CLEAN adversary passes, zero CRIT/HIGH/MED (bar: DEC-360 precedent). OBS-P3-2 (CHANGELOG JSM assembly-order gap) RESOLVED, doc-only, no re-convergence. 4 BCs (BC-3.8.019-022) + 3 VPs (VP-FIELD-ADF-001/003/004). Demo recording SKIPPED (human decision). Implementation COMPLETE + GREEN: lib jsm 31/0, issue_create_jsm 113/0, clippy+fmt clean. L-008/L-009 added. v4.30->v4.31. | 769 BCs / 86 VPs / 118 holdout / 182 stories |
| **CYCLE-012-STORY2-MERGED-WAVE2-COMPLETE-2026-09-14** | **COMPLETE** | 2026-09-14 | Story 2 per-story TDD delivery + merge; Wave 2 complete; F4 complete | S-cycle12-jsm-adf-autoconvert MERGED PR #812 @ `2a0b0fae` (squash, `--admin`, 2026-09-14T22:57:09Z). develop: `67b3939a`->`2a0b0fae`. All quality gates PASS: Red Gate verified; GREEN; Step 4.5 3/3 CLEAN; security CLEAN; CI 24/24 green incl. CI Gate + 8 mutation shards; fresh-eyes pr-reviewer APPROVE; dependency gate satisfied; demo SKIPPED (human decision). cycle-012 F4 COMPLETE (both waves delivered). NEXT = Wave 2 integration gate -> F5. v4.31->v4.32. | 769 BCs / 86 VPs / 118 holdout / 182 stories |
| **CYCLE-012-F5-CONVERGED-2026-09-15** | **COMPLETE** | 2026-09-15 | F5 scoped adversarial: adversary 3/3 CLEAN + code-review resolved + security CLEAN; fix PR #813 merged | Adversary Pass 1 (pre-fix) surfaced OBS-1 (`changed_fields --output json` scope-leak, human-ruled: narrow to ADF fields only) + code-reviewer H-1 (`jsm_create.rs` missing from CLAUDE.md Known Size Deviations) + M-1 (`field_resolve.rs` size entry stale, refreshed to 2,269 LOC) + M-3 (stale `isAdfRequest` comment). All four resolved in fix PR #813 (`fix/cycle012-f5-findings`). Re-review Passes A/B/C: 3/3 consecutive CLEAN (`VERDICT CLEAN NITPICK_ONLY`, zero CRIT/HIGH/MED) -- F5 CONVERGED. Security-reviewer CLEAN throughout (SEC-001 LOW pre-existing, not reachable via cycle-012 paths). PR #813 MERGED squash @ `80bb4215` (2026-09-15T00:14:11Z, `--admin`); fresh-eyes pr-reviewer APPROVE; CI 21/21 green incl. CI Gate; security review CLEAN. `develop`: `2a0b0fae`->`80bb4215`. Worktree/branch cleaned up. New LOW debt: M-2, OBS-A, OBS-3. NEXT = F6 targeted hardening. v4.32->v4.33. Trajectory: `4→0→0→0`. | 769 BCs / 86 VPs / 118 holdout / 182 stories |

## Current Phase Steps

**cycle-012 (`field-adf-autoconvert`) Phase F5 (scoped adversarial refinement) CONVERGED as of 2026-09-15.** Ran against the full cycle-012 delta (both waves: PR #809/#811 platform path + PR #812 JSM path) after the Wave 2 integration gate cleared. Adversary Pass 1 (pre-fix, 2026-09-14) surfaced OBS-1 (adversary, human-ruled -- Story 1's `changed_fields --output json` lowercase-key remapping had broadened beyond its intended ADF-field scope to also affect non-ADF system fields on `issue edit`; narrowed to `description`/`environment` only, regression test added) plus three code-reviewer findings: H-1 (`src/cli/issue/jsm_create.rs` missing from `CLAUDE.md`'s Known Size Deviations despite crossing the ADR-0012 threshold), M-1 (`field_resolve.rs`'s Known Size Deviations entry stale, refreshed to 2,269 LOC), M-3 (stale `isAdfRequest`-referencing comment in the JSM create path). Security-reviewer ran CLEAN from the start (0 CRIT/HIGH/MED; SEC-001 LOW pre-existing debug-only cache guard, confirmed not reachable via any cycle-012 code path). All four Pass-1 findings routed to fix PR #813 (`fix/cycle012-f5-findings`); re-review Passes A/B/C on the fix-PR delta were `VERDICT CLEAN NITPICK_ONLY` each time, zero CRIT/HIGH/MED -- 3/3 consecutive CLEAN reached at Pass C (2026-09-15), converging per the standard bar (DEC-360 precedent). PR #813 merged: fresh-eyes pr-reviewer APPROVE, CI 21/21 green incl. CI Gate, security review CLEAN -- squash-merged to `develop` with `--admin` @ `80bb4215` (2026-09-15T00:14:11Z). `develop`: `2a0b0fae` -> `80bb4215`. Worktree + branch cleaned up. Three new LOW, non-blocking debt items registered (`M-2` shared-helper extraction candidate, `OBS-A` `environment` regression-test gap, `OBS-3` EC-3.8.019-4 coverage nit) -- see Drift / Standing Items and `cycles/OPEN-STANDING-ITEMS.md`. Full per-pass detail: `cycles/cycle-012/convergence-trajectory.md`. **cycle-007 (`auth-correctness-dx`) PAUSED at F4** -- Wave-2 gate PENDING (develop@`80bb4215`). **NEXT** = Feature Mode F6 (targeted hardening: formal verification, fuzz testing, mutation testing scoped to the delta; full regression + security scans on the full tree) **IN PROGRESS** -> F7 (delta convergence + human gate).

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-360 | cycle-012 F3 **HUMAN GATE APPROVED** 2026-09-13 -- 2-story decomposition (S-cycle12-platform-adf-autoconvert 13pts Wave 1; S-cycle12-jsm-adf-autoconvert 13pts Wave 2; 26 pts total, acyclic S1->S2), full BC/VP/section-5 coverage, two-checkbox F4 gate on Story 2. F3 adversarial story convergence 3 consecutive CLEAN (passes 8/9/10 of 10; no-CRIT/HIGH/MED bar), consistency-validator CONSISTENT, zero input-hash drift. Human confirmed sequential S1->S2 critical path (no parallelism) acceptable. total_stories 180->182. | Human reviewed F3 story decomposition (CONVERGED 3 consecutive CLEAN passes) and made explicit approval ruling. Sequential critical path (S1->S2) accepted; no parallelism risk. | F3 (gate) | 2026-09-13 | human (explicit F3-gate approval) |
| DEC-359 | cycle-012 F2-gate uniform-exit-64: `--markdown` + `--field description=` (raw key `description`, case-sensitive, no-trim) UNIFORMLY exits 64 across platform `issue create` (NET-NEW guard step 2c), platform `issue edit` (guard extension), and JSM `create --request-type` (pre-existing BC-3.8.017). Message MUST contain pinned substring `cannot be combined with --markdown` + remediation "Pass --description with --markdown, or omit --markdown". | Human F2-gate qualifier "consistent with all of jr" caught that create was silently lenient while edit+JSM exited 64. Codebase analysis confirmed CLI-wide principle. Scoped adversary re-verified CLEAN. Supersedes DQ-1-Option-A silent-ignore framing. | F2 (gate) | 2026-09-13 | human (F2-gate qualifier) |
| DEC-358 | cycle-012 F2 **HUMAN GATE APPROVED** 2026-09-13 -- twelve new BCs + 4 VPs + ADR-0024, spec 2.3.0->2.4.0; adversarial spec-convergence MAXIMUM_VIABLE_REFINEMENT_REACHED after 33 passes. | Human reviewed F2 PRD delta + verification delta; applied F2-gate qualifier (DEC-359); explicitly approved proceeding to F3. | F2 (gate) | 2026-09-13 | human (explicit F2-gate approval) |
| DEC-357 | cycle-012 F1 **HUMAN GATE APPROVED** 2026-09-12 -- scope: ADF auto-convert `--field NAME=VALUE` for rich-text fields on `jr issue edit`, `jr issue create` (platform), AND `jr issue create --request-type` (JSM, explicitly included). | Human reviewed F1 delta v4 after research + fresh-context adversarial review (1 CRITICAL/2 HIGH/5 MEDIUM all resolved in v4) + 2 live-Jira read-only probes; made explicit scope-gate approval including JSM path. DQ-6 noted. | F1 (gate) | 2026-09-12 | human (explicit F1-gate approval) |
| (362 older decisions) | DEC-356 through DEC-309 and earlier -- unchanged this burst | -- | F1-F7/historical | 2026-08-24...2026-09-11 | various -- see `cycles/cycle-004/burst-log.md` Bursts 1-22, `cycles/cycle-005/burst-log.md`, `cycles/cycle-006/burst-log.md` |

**No new DEC minted this burst** -- F5 convergence + fix-PR merge is a standard pipeline-phase outcome (adversarial convergence + code-review resolution), not a human-gate scope decision.

**cycle-012 F1 artifacts:** `phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md` (OPERATIVE). **cycle-012 F2 artifacts:** `phase-f2-spec-evolution/cycle-012-verification-delta.md`, `specs/architecture/decisions/ADR-0024-adf-autoconversion-for-field-on-richtext-fields.md`, `specs/prd/bc-3-issue-write.md`. **cycle-012 F3 artifacts:** `cycles/cycle-012/phase-f3-stories/`. **cycle-012 F4 artifacts:** Story 1 convergence `cycles/cycle-012/adversarial-reviews/story-S-cycle12-platform-adf-autoconvert-convergence.md`; Story 2 convergence `cycles/cycle-012/adversarial-reviews/story-S-cycle12-jsm-adf-autoconvert-convergence.md`; both red-gate-logs under `cycles/cycle-012/S-cycle12-*/implementation/red-gate-log.md`. **E2E verification:** run `34881320608` @ `develop@67b3939a`; PR #811 (`67b3939a`). **cycle-012 F5 artifacts:** `cycles/cycle-012/convergence-trajectory.md` (Passes 1/A/B/C full detail); PR review evidence `code-delivery/cycle012-f5/pr-review.md`, `code-delivery/FIX-cycle012-f5/pr-review.md`; fix PR #813 (`fix/cycle012-f5-findings`) squash-merged @ `80bb4215`.

## Skip Log

<!-- Full cycle-002/003/004 rows archived to cycles/HISTORY-SKIP-LOG.md; only the 2 most recent cycles rows are kept inline. -->

| Step | Skipped? | Justification |
|------|----------|----------------|
| DTU creation (cycle-005) | yes | `dtu_required: false` -- targets Jiras own REST API surface, not a cloned third-party service. |
| UX Spec (cycle-005) | yes | `jr` is CLI-only; no new UI surface -- `adf-mentions` is a write-path conversion feature only. |
| Demo recording (cycle-005, Wave 2) | yes | Human decision: demos skipped for `S-cycle5-mention-resolution-wiring` (backend/no-UI CLI). |
| F6 Kani formal verification (cycle-005) | yes | Not set up in repo; proptest substitution justified. 0-GAP. |
| F6 cargo-fuzz (cycle-005) | yes | Not set up in repo; proptest arbitrary-input substitution justified. 0-GAP. |
| F6 DTU adversarial testing / accessibility re-check (cycle-005) | yes | `dtu_required: false`; write-path ADF conversion, no UI surface. |
| DTU creation (cycle-006) | yes | `dtu_required: no` -- `mutants-ci-sharding` is CI-tooling only. |
| UX Spec (cycle-006) | yes | `jr` is CLI-only; CI-workflow/policy-doc change with no product UI surface. |
| F5/F6 dedicated artifact subdirectory (cycle-006) | not skipped, folded | Feature-mode F5/F6 evidence folded into F7s 5-dimensional convergence record (DEC-351). |
| Demo recording (cycle-007, Story A) | yes | Human decision: small two-branch error-classification / exit-code CLI change, no UI surface; cycle-005 backend/no-UI-CLI precedent. |
| Demo recording (cycle-007, Story B1) | yes | Human decision: `auth list` STATUS behavior exhaustively unit-tested + snapshot-pinned; multi-profile keychain-state demo setup impractical on Gatekeeper-fragile dev host. |
| Demo recording (cycle-007, Story B2) | yes | Human decision: output-only CLI change (`auth status --output json`); covered by default-CI success-path test + keyring-gated AC tests. |
| Demo recording (cycle-012, Story 1) | yes | Human decision: `S-cycle12-platform-adf-autoconvert` is a backend/no-UI write-path CLI change, exhaustively covered by wiremock/CLI + proptest suite; consistent with cycle-005/007 precedent. |
| Demo recording (cycle-012, Story 2) | yes | Human decision (explicit): `S-cycle12-jsm-adf-autoconvert` is a backend/no-UI JSM write-path CLI change, no per-field echo surface, exhaustively covered by wiremock/CLI + unit tests + gated live-E2E. |

**NOT a skip (human-owned post-close):** Live-Jira E2E round-trip acceptance (`H-NEW-MENTION-009`, AC-017) is **DEFERRED by human decision**, not skipped -- see `cycles/OPEN-STANDING-ITEMS.md`.

Older rows (cycle-001 through cycle-004, historical): `cycles/HISTORY-SKIP-LOG.md`.

## Blocking Issues

**NONE OPEN.** Zero Blocking Issues remain open. cycle-012 ACTIVE, F5 CONVERGED; F6 targeted hardening IN PROGRESS next. cycle-007 PAUSED at F4 IMPL COMPLETE (Wave-2 gate PENDING). All six prior cycles (001-006) CLOSED. Resolved items: `cycles/RESOLVED-DRIFT-ITEMS.md`. Still-open LOW/non-blocking: `cycles/OPEN-STANDING-ITEMS.md`.

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| *(none open)* | | | | | |

## Convergence Status

cycle-007 (`auth-correctness-dx`) PAUSED, F4 IMPL COMPLETE. Wave-2 integration gate PENDING on resume. cycle-012 (`field-adf-autoconvert`) ACTIVE, Phase F5 (scoped adversarial refinement) **CONVERGED**: adversary 3/3 consecutive CLEAN (Passes A/B/C, `VERDICT CLEAN NITPICK_ONLY`, zero CRIT/HIGH/MED) on the post-fix delta; trajectory `4→0→0→0`; code-reviewer findings (H-1/M-1/M-3) + adversary OBS-1 resolved in fix PR #813, MERGED @ `80bb4215`; security-reviewer CLEAN throughout. NEXT = Feature Mode F6 targeted hardening (IN PROGRESS). Full detail: `cycles/cycle-012/convergence-trajectory.md`, `cycles/CYCLE-SUMMARY.md`.

## Concurrent Cycles

Nine tracked cycles total: cycle-001 through cycle-006 CLOSED; **cycle-007 (`auth-correctness-dx`) PAUSED** at F4 IMPL COMPLETE (Wave-2 gate PENDING, develop@`80bb4215`); **cycle-012 (`field-adf-autoconvert`) ACTIVE** at Phase F5 **CONVERGED** (fix PR #813 merged; F6 targeted hardening next). Cycles 008-011 PARKED (not yet started). `activation_head` stays `a9168212`. Full detail: `cycles/CYCLE-SUMMARY.md`.

## Constraints Carried Forward

All prior per-cycle constraints narrative is either historical/resolved or duplicated in Drift/Standing Items below. Full text preserved verbatim: `cycles/RESOLVED-DRIFT-ITEMS.md` (resolved/historical) and `cycles/OPEN-STANDING-ITEMS.md` (still-open debt). Nothing currently blocking. cycle-007 host constraint (`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`: nextest unusable on dev host) carries forward.

## Session Resume Checkpoint

**Date & position:** 2026-09-15. cycle-012 (`field-adf-autoconvert`), Feature Mode. Phase F5 (scoped adversarial refinement) **CONVERGED** -- adversary 3/3 consecutive CLEAN (Passes A/B/C); code-reviewer findings (H-1/M-1/M-3) + adversary OBS-1 resolved; security-reviewer CLEAN throughout. Fix PR #813 MERGED squash @ `80bb4215` (2026-09-15T00:14:11Z, `--admin`). Worktree + branch cleaned up. NEXT = Feature Mode F6 (targeted hardening) IN PROGRESS -> F7 (delta convergence + human gate).

**Convergence counter:** F5 scoped adversarial CONVERGED (3/3, trajectory `4→0→0→0`); no convergence counter currently active (F6 not yet begun a formal convergence track).

**In-flight work:** cycle-012 Phase F6 (targeted hardening: formal verification, fuzz testing, mutation testing scoped to the delta; full regression + security scans on the full tree) IN PROGRESS, just starting. F7 not yet started.

**Pending human decisions / blockers:** none open. LOW standing items: `E2E-COMPONENT-FILTER-SEARCH-INDEX-FLAKE` (non-blocking, pre-existing); new F5 debt `M-2`/`OBS-A`/`OBS-3` (all LOW, non-blocking, see Drift/Standing Items). cycle-007 Wave-2 integration gate still PENDING (resume after cycle-012 closes).

**WIP branch list:** none open -- `fix/cycle012-f5-findings` MERGED (PR #813 @ `80bb4215`); worktree + branch cleaned up.

**Resume command:** `/vsdd-factory:run-phase phase-f6-targeted-hardening` (pipeline already ACTIVE; no rehydrate needed this session).

**Counts:** total_bcs 769 (unchanged); VP count 86 (unchanged); holdout scenarios 118 (unchanged); total_stories 182 (unchanged). Prior checkpoint (STATE.md v4.32): archived to `cycles/cycle-012/session-checkpoints.md`.

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
| cycle-007 F1-F4 artifacts, burst log, session checkpoints, lessons | `phase-f1-delta-analysis/cycle-007-*.md`, `phase-f2-spec-evolution/cycle-007-*.md`, `cycles/cycle-007/` (`phase-f3-stories/`, `burst-log.md` Bursts 1-5, `adversarial-reviews/story-{A,C,D,B1,B2}-convergence.md`, `session-checkpoints.md`, `lessons.md`) |
| cycle-012 F1 operative delta analysis | `phase-f1-delta-analysis/e2e-edit-field-adf-heuristic-delta-analysis-v4.md` (v1/v2/v3 SUPERSEDED) |
| cycle-012 F2 spec evolution | `phase-f2-spec-evolution/cycle-012-verification-delta.md`, `specs/architecture/decisions/ADR-0024-adf-autoconversion-for-field-on-richtext-fields.md`, `specs/prd/bc-3-issue-write.md` |
| cycle-012 F3 stories + wave artifacts | `cycles/cycle-012/phase-f3-stories/` |
| cycle-012 burst history | `cycles/cycle-012/burst-log.md` (Bursts 1-3) |
| cycle-012 session checkpoints | `cycles/cycle-012/session-checkpoints.md` |
| cycle-012 lessons (L-001..L-010) | `cycles/cycle-012/lessons.md` |
| cycle-012 F4 Story 1/Story 2 convergence + red-gate-logs | `cycles/cycle-012/adversarial-reviews/story-S-cycle12-{platform,jsm}-adf-autoconvert-convergence.md`, `cycles/cycle-012/S-cycle12-*/implementation/red-gate-log.md` |
| cycle-012 F5 convergence trajectory (Passes 1/A/B/C) + PR review evidence | `cycles/cycle-012/convergence-trajectory.md`, `code-delivery/cycle012-f5/pr-review.md`, `code-delivery/FIX-cycle012-f5/pr-review.md` |
| cycle-012 F1 + E2E design research + live-Jira probes | `research/field-adf-autoconvert-design-research-2026-09-12.md`, `research/e2e-environment-adf-field-2026-09-11.md`, `research/createmeta-schema-probe-2026-09-12.md`, `research/jsm-requesttype-fields-adf-probe-2026-09-12.md`, `research/createmeta-fields-endpoint-verification-2026-09-14.md`, `research/jira-adf-field-readback-shape-2026-09-14.md` |
| cycle-005/006 F1-F7 spec/story/delivery artifacts | `phase-f1-delta-analysis/`, `phase-f2-spec-evolution/`, `cycles/<cycle>/phase-f3-stories/`, `phase-f6-hardening/cycle-005/`, `cycles/cycle-006/blocking-issues-resolved.md` |
| cycle-001..004 spec/story/delivery artifacts | `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| Session checkpoints (all cycles) | `cycles/<cycle>/session-checkpoints.md` |
| CLAUDE.md compaction / E2E-CI dynamic-tests / mutants-nightly rebalance evidence | PR #797 @ `a1f37995`, PR #798 @ `3a874d90`, PR #799 @ `78aeb86c` -- detail: `cycles/HISTORICAL-CONTENT-INDEX-DETAIL.md` |
| MAINTENANCE-SWEEP-2026-09-10 evidence | `maintenance/sweep-report-2026-09-10.md`, `maintenance/dependency-audit-raw-2026-09-10.log`, `maintenance/dependency-audit-raw-summary-2026-09-10.md`, `maintenance/dependency-audit-analysis-2026-09-10.md`, `maintenance/doc-drift-findings-2026-09-10.md` |
| Pre-2026-08-25 compaction history | factory-artifacts commit `43f4a5e3` |

## Drift / Standing Items

**OPEN -- headline follow-ups (kept visible per compaction policy):**

- **`BC-CITE-001 ZERO-TOLERANCE (CODIFIED, L-001)`** -- POLICY. `scripts/check-bc-citation-symbols.sh` exits 1 on ANY backtick-wrapped pending `src/...::symbol` token in BC Trace/Source. Codified in `cycles/cycle-012/lessons.md` (L-001).
- **`INPUT-HASH-DRIFT-STALE-ARTIFACTS`** -- LOW, non-blocking. Input-hash scan shows 209 STALE + 4 UNRESOLVABLE artifacts, ALL from prior closed cycles. Pre-existing repo-wide condition.
- **`AUTH-REFRESH-APITOKEN-DOC-OVERCLAIM`** -- LOW, non-blocking. `jr auth refresh --api-token` doc comment has latent unconditional-notice overclaim. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`AUTH-REMEDIATION-EQUALS-FORM-BROADER`** -- LOW, non-blocking. Broader remediation remains. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`FIX-F6-A` / `F6-MUTATION-EXAMINE-GLOBS-EXPANSION`** -- LOW, non-blocking (pre-existing since cycle-004). DEC-356 EXPLICITLY ACCEPTED deferral. Target: future maintenance cycle.
- **`CYCLE-007-PARKED-BUNDLES`** -- 4 bundles PARKED: **cycle-008** (`issue-io-quickwins`), **cycle-009** (`bulk-by-jql`), **cycle-010** (`read-index-lag`), **cycle-011** (`filter-grammar`). Full triage: `phase-f1-delta-analysis/issue-triage-*.md`.
- `VSDD-FACTORY-COMPACT-CLAUDE-MD-GAP` -- engine gap; candidate follow-up in vsdd-factory repo.
- **`MUTANTS-NIGHTLY-VERIFY-FULL-RUN`** -- LOW, non-blocking. Nightly 34858140987 CANCELLED (user decision); last two nightlies FAILED. Cron unchanged; next nightly attempt pending.
- **`E2E-EDIT-FIELD-ADF-HEURISTIC`** -- **RESOLVED/VERIFIED** (cycle-012, route B product fix). `test_e2e_issue_edit_custom_field` PASSED on live Jira (run `34881320608` @ `develop@67b3939a`). Formal cycle-012 closure at F7 approval.
- **`E2E-COMPONENT-FILTER-SEARCH-INDEX-FLAKE`** -- LOW, non-blocking, pre-existing, unrelated to cycle-012. `test_e2e_issue_list_component_filter_grammar` intermittently fails on live Jira search-index lag. Candidate fix: poll/retry helper. Relates to PARKED cycle-010 `read-index-lag` bundle.
- **`HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`** -- LOW, non-blocking, dev-host-only. `cargo-nextest` UNUSABLE for full suite. NOT a CI issue. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`VP-FIELD-ADF-001-TEXTAREA-ANCHOR`** -- LOW, non-blocking residual. VP-FIELD-ADF-001 lacks a non-canonical `:textarea`-prefix positive anchor test. Candidate for a future maintenance sweep (L-005/L-006, `cycles/cycle-012/lessons.md`).
- **`CYCLE-012-STORY2-AC-012-OUTPUT-CHANNEL-WORDING`** -- LOW, non-blocking. `S-cycle12-jsm-adf-autoconvert` AC-012 story text names stdout for the field-conversion notice; actual/correct channel is stderr (jr's Symmetric output-channel convention). Test correctly asserts stderr. Fix story-text wording in a future doc sweep / at F7 close (L-008, `cycles/cycle-012/lessons.md`).
- **`CYCLE-012-F5-M-2-SHARED-GUARD-HELPER`** -- LOW, non-blocking. The `--markdown` + `--field description=` conflict predicate is triplicated verbatim across `create.rs`/`edit.rs`/`jsm_create.rs`; extract a shared `field_pairs_raw_key_matches` helper into `field_resolve.rs`. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`CYCLE-012-F5-OBS-A-ENVIRONMENT-REGRESSION-TEST-GAP`** -- LOW, non-blocking. The `environment` `changed_fields` lowercase-key arm has no non-gated CI regression test (only gated E2E covers it); pre-existing Wave-1 gap. Candidate: mirror `test_obs_1` for `environment`. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.
- **`CYCLE-012-F5-OBS-3-EC38019-4-COVERAGE-NIT`** -- LOW, non-blocking. EC-3.8.019-4's supersession case has no dedicated test; code path identical to the tested case, not a viable mutation target. Full detail: `cycles/OPEN-STANDING-ITEMS.md`.

**RESOLVED this burst (2026-09-15, v4.33):** cycle-012 Phase F5 (scoped adversarial refinement) CONVERGED -- adversary 3/3 consecutive CLEAN (Passes A/B/C, `VERDICT CLEAN NITPICK_ONLY`, zero CRIT/HIGH/MED) on the post-fix delta, following an initial pre-fix Pass 1 that surfaced OBS-1 (adversary, human-ruled) + H-1/M-1/M-3 (code-reviewer); security-reviewer CLEAN throughout (SEC-001 LOW pre-existing, not reachable via cycle-012 paths). Fix PR #813 (`fix/cycle012-f5-findings`) resolved all four Pass-1 findings and MERGED to `develop` as squash commit `80bb4215` (2026-09-15T00:14:11Z, `--admin`); fresh-eyes pr-reviewer APPROVE, CI 21/21 green incl. CI Gate, security review CLEAN. `develop`: `2a0b0fae`->`80bb4215`. Worktree + branch cleaned up. New LOW debt registered: `M-2`, `OBS-A`, `OBS-3` (all in `cycles/OPEN-STANDING-ITEMS.md`). L-010 lesson recorded (F5 integration-scope pass catches cross-story side effects per-story convergence structurally cannot see). STATE.md v4.32->v4.33; `CYCLE-012-F5-CONVERGED-2026-09-15` phase progress row appended (oldest row `CYCLE-012-F3-APPROVED-2026-09-13` archived out to keep the table at 10 rows).

**RESOLVED prior burst (2026-09-14, v4.32):** cycle-012 F4 Wave 2 Story 2 (`S-cycle12-jsm-adf-autoconvert`) DELIVERED + MERGED PR #812 @ `2a0b0fae` (squash, `--admin`, 2026-09-14T22:57:09Z); Wave 2 COMPLETE; cycle-012 F4 COMPLETE (both waves delivered: Story 1 PR #809, Story 2 PR #812). All quality gates PASS. `develop`: `67b3939a`->`2a0b0fae`. STATE.md v4.31->v4.32; `CYCLE-012-STORY2-MERGED-WAVE2-COMPLETE-2026-09-14` phase progress row appended.

All other standing debt -- full text preserved, nothing deleted: OPEN items at `cycles/OPEN-STANDING-ITEMS.md`; RESOLVED/CLOSED items at `cycles/RESOLVED-DRIFT-ITEMS.md`.
