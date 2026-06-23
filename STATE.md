---
document_type: pipeline-state
version: "2.0"
status: complete
timestamp: 2026-06-22T00:00:00Z
phase: 3
project: jira-cli
mode: brownfield
current_step: "MAINTENANCE SWEEP 2026-06-22 STARTED. Sweeps 1-5,7,8 dispatched (DTU/a11y N/A). Read-only scans in progress."
maintenance_run: STARTED
current_cycle: "cycle-001"
feature_mode_bundle: none
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "dbe8625"
activation_version: "v0.6.0-dev.6"
---
# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-19: PR queue cleared — #541 MERGED @ 1c703d6, #519 MERGED @ c8e34ca (post-rebase CI 15/15 run 27853301753), #537 MERGED @ ed236d4 (external fork; DEC-128 authorized; 2 LOW nits → FORK-OPS-537-NITS). ZERO open PRs. develop HEAD = ed236d4. |
| **Current Phase** | Phase 3 — IDLE (maintenance mode). BC 602. NFR 42. ADR 16 (ADR-0014 written). Stories 91. |
| **Next Phase** | Next feature cycle (open candidates: #532, Bundle D drafts, fork signing DEC-104) |
| **Activation HEAD** | dbe8625 (v0.6.0-dev.6 tag); develop @ dbe8625 |

## Phase Progress

| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| Phase 0–2 + Wave 0/1/2/3 + Feature cycles 2026-05-04..2026-06-17 | ALL COMPLETE | 2026-06-17 | F1–F7 each | BC 583→599; 19+ feature cycles. See `cycles/cycle-001/burst-log.md`. |
| S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + v0.6.0-dev.4 | CYCLE CLOSED | 2026-06-18 | F1–F7 COMPLETE | PRs #533/#535/#536. develop @ 45ddf7a == v0.6.0-dev.4. Stories 79→81. |
| S-FORK-OPS-BACKFILL F1–F7 + RELEASED v0.6.0-dev.5 | CYCLE CLOSED | 2026-06-19 | F1–F7 COMPLETE + human auth | PR #539/#538/#540/#542. develop @ 71f33c6. Stories 81→83. DEC-122/123/124. See `cycles/cycle-001/burst-log.md`. |
| 4: Holdout Evaluation | not-started | | | |
| **DEAD-CITATION-CI F1+F2** | **CONVERGED** | **2026-06-20** | **F1: delta analysis; F2: 10 adv passes + 5 consistency; ROOT_FILES amendment; human-approved** | DEC-125/126 |
| **DEAD-CITATION-CI F3** | **CONVERGED** | **2026-06-20** | **3 adv passes + 2 consistency; story S-MAINT-DEAD-CITATION-CI (12 AC, 3 holdouts); human-approved** | DEC-127: F-1 HIGH fixed by Vec<(String,usize)> provenance |
| **DEAD-CITATION-CI F4** | **COMPLETE** | **2026-06-20** | **PR #544 merged @ 496258a; 58 tests; 3 per-story adv passes + code/security review; ci-gate 15/15 incl. mutation testing+Windows** | PG-MERGE-AUTH-BYPASS logged |
| **DEAD-CITATION-CI F5–F7** | **CONVERGED** | **2026-06-20** | **5/7 dims converged (visual/perf N/A); input-drift NONE; consistency CONSISTENT; CI 15/15 on #544+#545; PR #545 merged** | DEC-129. S-PG-MERGE-AUTH-BYPASS registered (story 91). |
| **DEAD-CITATION-CI RELEASED** | **CYCLE CLOSED** | **2026-06-20** | **v0.6.0-dev.6 shipped — PRs #544/#545/#546; release.yml run 27851891146 SUCCESS; 10 assets / 5 targets; full VSDD F1–F7; 8+ defects caught pre-merge** | develop @ dbe8625 == v0.6.0-dev.6. Maintenance RESUMED. |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **STATE.md COMPACTED** — Phase Progress rows archived to cycles/cycle-001/burst-log.md. Historical content extracted. STATE.md under 180 lines. | state-manager | COMPACTED | factory-artifacts. |
| **DEAD-CITATION-CI F4 COMPLETE** — PR #544 merged @ 496258a. 58 tests (tests/claude_md_citations.rs). 3 per-story adv passes + code/security review. ci-gate 15/15 incl. mutation testing + Windows. PG-MERGE-AUTH-BYPASS + DEC-128 logged. F5 starting. | state-manager | F4 COMPLETE | develop @ 496258a. Story 90 DELIVERED. |
| **DEAD-CITATION-CI CYCLE CLOSED + RELEASED** — PRs #544/#545 merged; PR #546 (release) merged. develop @ dbe8625 == v0.6.0-dev.6 tag. release.yml run 27851891146 SUCCESS; 10 assets / 5 targets. S-7.02 satisfied: PG-MERGE-AUTH-BYPASS TRACKED (S-PG-MERGE-AUTH-BYPASS story 91); lessons.md codified. ADR-0014 written. Maintenance RESUMED. IDLE. | state-manager | CYCLE CLOSED | factory-artifacts. |
| **PR TRIAGE COMPLETE — open-PR queue cleared: #541 (insta) @ 1c703d6, #519 (codecov v7, non-breaking, post-rebase CI green run 27853301753) @ c8e34ca, #537 (fork verify-signatures fix; pr-reviewer MERGE-WITH-CHANGES + security-reviewer APPROVE; 2 LOW nits → FORK-OPS-537-NITS) @ ed236d4 == develop HEAD. All DEC-128-authorized. IDLE. SESSION WRAPPED — SAFE TO CLEAR.** | state-manager | PR TRIAGE COMPLETE | develop @ ed236d4. ZERO open PRs. Local develop synced. |
| **MAINTENANCE SWEEP 2026-06-22 STARTED** — maintenance-config.yaml created. maintenance/2026-06-22/ directory initialized. Sweeps 1-5,7,8 dispatched (DTU=N/A dtu_required:false; a11y=N/A CLI-only). Read-only scan agents in progress. | state-manager | IN_PROGRESS | factory-artifacts. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-124 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + S-FORK-OPS-BACKFILL decisions. Pattern: full VSDD catches CRIT/HIGH on "trivial" infra changes (DEC-120/121/124). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-19 | archived |
| DEC-125 | Full VSDD Feature Mode applied to DEAD-CITATION-CI guard. Origin: MAINT-PG-DEAD-CITATION-CI. Consistent with DEC-120/121 precedent. | Feature Mode / DEAD-CITATION-CI F1 | Phase 3 | 2026-06-20 |
| DEC-126 | DEAD-CITATION-CI F2: 6 iterations / 10 adversarial passes caught 6 real defects before any code was written. Strong VSDD reinforcement. | Feature Mode / DEAD-CITATION-CI F2 | Phase 3 | 2026-06-20 |
| DEC-127 | F3 story review caught F-1 HIGH: non-actionable `(line N)` literal. Fixed by `Vec<(String,usize)>` provenance. Story-altitude catch that 10 F2 passes missed. | Feature Mode / DEAD-CITATION-CI F3 | Phase 3 | 2026-06-20 |
| DEC-128 | Merge-auth gap: pr-manager delivery sub-agent auto-merged PR #544 against orchestrator hold + pending human review. Recurrence of MAINT-PG-PR-MERGE-CHANNEL. PG-MERGE-AUTH-BYPASS tracked. | Feature Mode / DEAD-CITATION-CI F4 | Phase 3 | 2026-06-20 |
| DEC-129 | DEAD-CITATION-CI F7 CONVERGED. Full VSDD on single CI-guard test (~211 LOC) caught 8+ real defects: .factory/ CI-checkout flaw, count drift, 3-way contradiction, (line N) non-actionable, false-green assertion, 4 mutation survivors, CWE-22. Strongest DEC-120/121/124 reinforcement. | Feature Mode / DEAD-CITATION-CI F7 | Phase 3 | 2026-06-20 |
| DEC-130 | DEAD-CITATION-CI session review verdict: full VSDD justified (2 functionally-disqualifying defects: .factory/ CI-checkout flaw + non-actionable (line N) placeholder). Key efficiency lesson: 3 of 6 F2 iterations were self-inflicted fix-cascades — F2-PIECEWISE-PROTOCOL now ENFORCED (consistency-validator between spec fixes). Phase-gate fresh-context validated at every altitude (F3 caught what 10 F2 passes missed; F5 caught CWE-22). Session review: `.factory/phase-f7-convergence/DEAD-CITATION-CI-session-review.md`. | Session Review / DEAD-CITATION-CI | Phase 3 | 2026-06-20 |

## Skip Log

All 7 S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 per-AC demos: **Yes — adapted**. CI-config / infra / docs / test-only / platform-cfg stories. See `cycles/cycle-001/burst-log.md`.

S-MAINT-DEAD-CITATION-CI per-AC demos: **Yes — adapted**. CI/test-only story; no user-visible behavior. The guard's own green test run (58 tests passing in ci-gate) is the evidence for per-AC demo compliance.

## Blocking Issues

None open.

## Drift Items

<!-- OPEN/TRACKED items only. Resolved → cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| MAINT-2026-06-17-SC-03 | ADR location | SC-03: docs/adr/ vs .factory/architecture/adr/ convention discrepancy. | LOW | DEFERRED |
| FORK-OPS-537-NITS | PR #537 optional nits | PR #537 (verify-signatures fork fix, merged @ ed236d4) carries 2 optional LOW nits posted as PR comment: (a) tighten TeamIdentifier regex `\*+`→`\*{3}` to match GHA's exact `***` mask (CWE-697 hardening, non-exploitable); (b) soften the overstated Bug-2 'signed-DMG performance fast-path' rationale in inline comment/PR body (undocumented by Apple; fix itself correct). Inert in this repo (SIGNING_ENABLED unset). | LOW | OPEN |
| FORK-OPS-PHANTOM-RUNS | Phantom workflow runs | ~7 phantom runs/day from new triggers. Cosmetic; decide suppress or accept. | LOW | OPEN |
| WIN-CFG-TESTS-CHECK | Cross-compile | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME | Not debug-gated unlike JR_BASE_URL/JR_AUTH_HEADER. | LOW | TRACKED — S-MAINT-SEC-JR-SERVICE-NAME-GATE (draft, security P2, 2026-06-19) |
| WIN-DENY-FRAGILITY | deny.toml | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK poison | .lock().unwrap() in auth tests; use unwrap_or_else. | LOW | OPEN |
| E2E-PG-4 | E2E coverage gap | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| DRIFT-331-PAGINATION | get_issue_types_for_project | Inline reimplementation; target: reuse OffsetPage<T>. | LOW | TRACKED — S-MAINT-CR-005 (draft, 2026-06-19) |
| PG-A / DRIFT-README | Count guards | check-bc-cumulative-counts.sh misses README.md; Document Map total stale. | LOW | OPEN |
| SEC-001 | CWE-674 recursion | Uncontrolled recursion in adf.rs normalize/assign_local_ids/render_node. | LOW | TRACKED — S-MAINT-SEC-001 (draft, security P2, 2026-06-19) |
| WIN-PG-1 | No BC-count CI guard | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Story template | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Windows OAuth probe | Release OAuth verification is constants-file check only; no runtime jr auth status. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | XDG→JR seam-migration | Enforcement test has directional blind spot. | LOW | OPEN |
| F7-001..F7-003 | Minor precision gaps | CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests". | LOW | ACCEPTED-DEFERRED |
| #492-TEST-HARNESS-COUPLING | process-gap | Handler-level block-HTML tests couple to push_text shape. | LOW | TRACKED DEFERRAL |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. | LOW | TRACKED DEFERRAL |
| LESSON-F2-WORKTREE-FIRST | process-gap C-1 | ALL story-scoped edits in worktree, even docs/. Codified in lessons.md. | LOW | DEFERRED |
| KEYRING-GUARD-IDIOM-DRIFT | process-gap | Three co-existing keyring-gate guard idioms; no meta-test enforces canonical form. | LOW | TRACKED — S-MAINT-CR-009 (draft, 2026-06-19) |
| CITATION-FORM-DISCIPLINE | process-gap | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| F7-COSMETIC-ATTR-ORDER | cosmetic | Story Architecture Rule 3 says #[ignore] before #[test]; code uses #[test] first. | LOW | ACCEPTED-COSMETIC |
| #532-COVERAGE-FOLLOW-UP | coverage-gap | Login/Refresh/Logout global-`--profile` fallback ungated — issue #532 opened. | LOW | TRACKED — S-MAINT-532 (draft, 2026-06-19) |
| FORK-OPS-COMPOSITE-ACTION-SCAN | sign-and-publish.yml | Injection guard does not follow local composite actions; none exist today. F5 OBS-1. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | sign-and-publish.yml | Empty head_branch → TAG=""/VERSION="" (theoretical CWE-74). Future story. | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | sign-and-publish.yml | Orphaned alpha tags from failed runs accumulate. Future housekeeping story. | LOW | OPEN |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | backfill-release.yml | `gh release upload jr-*.zip` fails loud on zero-match glob (accepted; guarded by needs:build + matrix-parity test; parity with release.yml). | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | process-gap | F5 checklist conflates `--self-test` inline fixture with real-file scan; wording could mislead. | LOW | OPEN |
| DRIFT-CR-008 | test-helper dedup | extract_job_block / block-extraction helpers duplicated across test files. | LOW | TRACKED — S-MAINT-CR-008 (draft, 2026-06-19) |
| MAINT-PG-CI-DOC-LINT | process-gap | CLAUDE.md src-file-tree drift recurring; add scripts/check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | coverage-gap | Sweep 5 (perf) skipped 4× — no hyperfine baseline. Draft story: .factory/perf/ baseline. | LOW | DEFERRED |
| PERF-COST-TRACKING | instrumentation | No per-cycle token/cost tracking; `.factory/cost-summary.md` not initialized. Blind spot for cost-per-story analysis and cost-vs-defect-value calibration. Origin: DEAD-CITATION-CI session review Rec 3. | LOW | OPEN — draft story candidate |
| F1-CI-TOPOLOGY-CHECK | phase-f1 process | F1 delta analysis lacks CI-checkout-topology verification step. The .factory/ CI-checkout flaw was a topology assumption error (checkout@v4 defaults to triggering branch, not factory-artifacts). Action: update phase-f1 skill template. | LOW | OPEN — skill template update (no new story) |
| F2-PIECEWISE-PROTOCOL | phase-f2 process | Promote LESSON-F2-PIECEWISE to ENFORCED F2 protocol: dispatch consistency-validator after EACH spec-author fix, before the next adversary pass. Would cut F2 from 6 to ~3 iterations. Codified [enforced] in lessons.md 2026-06-20. | MEDIUM | OPEN — workflow change; codified in lessons.md |
| PG-MERGE-AUTH-BYPASS | pr-manager delivery | pr-manager delivery sub-agent executed `gh pr merge` on PR #544 despite explicit orchestrator hold. Delivery sub-agents must not self-authorize merges; merge requires explicit per-merge orchestrator authorization. Also encompasses MAINT-PG-PR-MERGE-CHANNEL (same root cause: undefined merge-auth protocol; pr-manager default = NO-MERGE; orchestrator passes explicit `merge: authorized` signal). DEC-128. | MEDIUM | TRACKED — S-PG-MERGE-AUTH-BYPASS (draft; scope extended to cover MAINT-PG-PR-MERGE-CHANNEL; 2026-06-20) |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **DEAD-CITATION-CI CONVERGED + RELEASED (2026-06-20). No active convergence tracker.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-20 |
| **Status** | **IDLE. SAFE TO CLEAR.** PR-triage session fully wrapped: all merges DEC-128-authorized, all artifacts committed + pushed, both worktrees clean. No active feature_mode_bundle. No active story worktrees. |
| **Position** | DEAD-CITATION-CI feature cycle CLOSED + RELEASED v0.6.0-dev.6 (PRs #544/#545/#546). PR triage complete: #541 MERGED @ 1c703d6; #519 MERGED @ c8e34ca (post-rebase CI run 27853301753, 15/15); #537 MERGED @ ed236d4 (external fork; DEC-128 authorized; 2 LOW nits → FORK-OPS-537-NITS). ZERO open PRs remaining. |
| **develop HEAD** | LOCAL develop = **ed236d4** == origin/develop (already synced — pull NOT required on cold resume). activation_head/version unchanged: dbe8625 / v0.6.0-dev.6. |
| **factory-artifacts HEAD** | see `git -C .factory log -1` (this burst advances it from ae944d2) |
| **Activation** | activation_head: dbe8625; activation_version: v0.6.0-dev.6. v0.5.0 STABLE shipped 2026-06-12. |
| **Counters** | BC **602**. NFR **42**. ADR **16** (ADR-0014 written). Stories **91** (S-PG-MERGE-AUTH-BYPASS = story 91, draft). |
| **Active worktrees** | NONE under `.worktrees/`. Permanent infra only: main checkout (develop) + `.factory` (factory-artifacts) + `.reference/jira-cli` (detached). No story worktrees in-flight. |
| **Open PRs (action needed)** | **NONE** — all three triaged PRs merged (#541, #519, #537). |
| **jira-e2e env** | JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |
| **Standing constraints** | Do NOT close #429 (DEC-029). All fixes through full VSDD (DEC-120/121/124/129/130). LESSON-F2-WORKTREE-FIRST. F2-PIECEWISE-PROTOCOL [ENFORCED 2026-06-20]: consistency-validator after EACH spec-author fix in F2. DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges. Fork signing UNBLOCKED but INERT (DEC-104). |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: IDLE. DEAD-CITATION-CI CYCLE CLOSED + RELEASED v0.6.0-dev.6. PR queue cleared: #541/#519/#537 all MERGED. develop @ ed236d4 (no new tag). Maintenance RESUMED. No active bundle. No story worktrees. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md` (this file).

**Step 2 — Verify position:**
- develop @ **ed236d4** (LOCAL == origin/develop, already synced — pull NOT required). No new tag; activation_head dbe8625/v0.6.0-dev.6 unchanged.
- factory-artifacts: see `git -C .factory log -1` (pushed; no uncommitted changes).
- Permanent infra only: main checkout @ develop, `.factory` @ factory-artifacts, `.reference/jira-cli` detached. ZERO story worktrees under `.worktrees/`.
- PRs #544/#545/#546 merged. #541/#519/#537 ALL MERGED. ZERO open PRs.
- Counters: BC **602**, NFR **42**, ADR **16**, Stories **91**.

**Step 3 — IDLE. Present status to human, await direction.**
Nothing is in-progress. Next-work candidates (orchestrator's choice or await human):
- **S-PG-MERGE-AUTH-BYPASS** (story 91, MEDIUM, draft) — merge-auth protocol story; PG-MERGE-AUTH-BYPASS + MAINT-PG-PR-MERGE-CHANNEL unified.
- **Bundle D** draft stories: S-MAINT-CR-005/CR-008/CR-009/SEC-001/SEC-JR-SERVICE-NAME-GATE.
- **#532** / S-MAINT-532 (profile-fallback coverage gap, LOW).
- Fork signing enablement (DEC-104, pending human + Apple secrets).
- DO NOT close **#429** (DEC-029, human-deferred).

**Step 4 — STANDING CONSTRAINTS:**
- All fixes through full VSDD Feature Mode (DEC-120/121/124/129/130).
- F2-PIECEWISE-PROTOCOL [ENFORCED 2026-06-20]: consistency-validator after EACH spec-author fix in F2.
- LESSON-F2-WORKTREE-FIRST: ALL story-scoped edits (incl. docs/) in the story worktree.
- DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges. Explicit orchestrator per-merge authorization required.
- CHANGELOG-per-PR hygiene: keep `[Unreleased]` populated as PRs merge.
- Carry-forward LOW drift items in Drift Items section (non-blocking).

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #532 | fix(test): Login/Refresh/Logout global-`--profile` fallback ungated coverage | OPEN — LOW follow-up; opened 2026-06-18 | LOW | Deferred from S-TESTTOOL-1 F5. No blocking impact. |
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |
| #209 | (backlog) | OPEN | — | |
| #520 | ci: opt-in release ops (fork-friendly) | MERGED @ 2cb219b. Both HIGH code blockers RESOLVED (PR #535). Gate = human DEC-104 + Apple secrets. | LOW | |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-001..119 + archived phase rows + closed issues + F4 burst | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived, incl. F4-active) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
| Maintenance sweep 2026-06-17 session review | `maintenance/2026-06-17/session-review.md` |
| Maintenance sweep 2026-06-19 session review | `maintenance/2026-06-19/session-review.md` |
| DEAD-CITATION-CI session review (F7 cycle close) | `phase-f7-convergence/DEAD-CITATION-CI-session-review.md` |
