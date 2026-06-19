---
document_type: pipeline-state
version: "2.0"
status: in_progress
timestamp: 2026-06-20T12:00:00Z
phase: 3
project: jira-cli
mode: brownfield
current_step: "F3 CONVERGED + human-approved; F4 TDD implementation starting"
current_cycle: "cycle-001"
feature_mode_bundle: "DEAD-CITATION-CI"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "71f33c6"
activation_version: "v0.6.0-dev.5"
---
<!-- SIZE BUDGET: <200 lines. Historical content → cycle files. Run /vsdd-factory:compact-state if over 200. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-20: DEAD-CITATION-CI F3 CONVERGED (3 adv passes + 2 consistency audits; story S-MAINT-DEAD-CITATION-CI registered; human-approved). F4 starting. |
| **Current Phase** | Phase 3 — Feature Mode ACTIVE (DEAD-CITATION-CI). develop @ 6bdb251, 1 commit ahead of v0.6.0-dev.5 tag. BC 599. NFR 42. ADR 16. Stories 90. |
| **Next Phase** | F1 Delta Analysis → F2 Spec Evolution → F3 Stories → F4 Implementation → F5 Adversarial → F6 Hardening → F7 Convergence |
| **Activation HEAD** | 71f33c6 (v0.6.0-dev.5 tag); develop now @ 6bdb251 (1 commit ahead) |

## Phase Progress

| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| Phase 0–2 + Wave 0/1/2/3 + Feature cycles 2026-05-04..2026-06-17 | ALL COMPLETE | 2026-06-17 | F1–F7 each | BC 583→599; 19+ feature cycles. See `cycles/cycle-001/burst-log.md`. |
| S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + v0.6.0-dev.4 | CYCLE CLOSED | 2026-06-18 | F1–F7 COMPLETE | PRs #533/#535/#536. develop @ 45ddf7a == v0.6.0-dev.4. Stories 79→81. |
| S-FORK-OPS-BACKFILL F1–F7 + RELEASED v0.6.0-dev.5 | CYCLE CLOSED | 2026-06-19 | F1–F7 COMPLETE + human auth | PR #539/#538/#540/#542. develop @ 71f33c6. Stories 81→83. DEC-122/123/124. See `cycles/cycle-001/burst-log.md`. |
| 4: Holdout Evaluation | not-started | | | |
| **DEAD-CITATION-CI F1+F2** | **CONVERGED** | **2026-06-20** | **F1: delta analysis; F2: 10 adv passes + 5 consistency; ROOT_FILES amendment; human-approved** | DEC-125/126 |
| **DEAD-CITATION-CI F3** | **CONVERGED** | **2026-06-20** | **3 adv passes + 2 consistency; story S-MAINT-DEAD-CITATION-CI (12 AC, 3 holdouts); human-approved** | DEC-127: F-1 HIGH fixed by Vec<(String,usize)> provenance |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **2026-06-19 PR #543 MERGE CLOSE-OUT** — 5 drift items RESOLVED+ARCHIVED. Count guards: all 3 exit 0. | state-manager | COMPLETE | develop @ 6bdb251 (1 ahead of v0.6.0-dev.5). IDLE. |
| **DEAD-CITATION-CI FEATURE CYCLE INITIALIZED** — bundle DEAD-CITATION-CI. F1 Delta Analysis started 2026-06-20. DEC-125 logged. MAINT-PG-DEAD-CITATION-CI → IN-PROGRESS. Maintenance sweeps PAUSED. | state-manager | F1 STARTED | develop @ 6bdb251. Feature Mode ACTIVE. |
| **DEAD-CITATION-CI F2 GATE CLOSE** — F2 spec CONVERGED after 10 adversarial passes + 5 consistency audits. ROOT_FILES amendment added. Human-approved. DEC-126 logged. | state-manager | F2 CONVERGED | develop @ 6bdb251. F3 next. |
| **DEAD-CITATION-CI F3 GATE CLOSE** — Story S-MAINT-DEAD-CITATION-CI registered (90 total; 12 AC, 3 holdouts, 3 SP, BC-X.13.001/002/003). 3 adv passes + 2 consistency audits CONVERGED. DEC-127 logged. Human-approved. | state-manager | F3 CONVERGED | develop @ 6bdb251. F4 next. |
| **STATE.md COMPACTED** — Phase Progress rows archived to cycles/cycle-001/burst-log.md. Historical content extracted. STATE.md under 180 lines. | state-manager | COMPACTED | factory-artifacts. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-119 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + maintenance decisions. All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-17 | archived |
| DEC-120 | S-TESTTOOL-1 full VSDD for a test/CI-config micro-change. F5 caught coverage-regression HIGH + C-1. Validates: full VSDD is not bureaucratic overhead on "trivial" changes. | Feature Mode / S-TESTTOOL-1 | Phase 3 | 2026-06-18 |
| DEC-121 | S-FORK-OPS-SIGN-1 full VSDD Feature Mode on a CI-workflow-only security fix. F5 caught a CRITICAL guard false-negative: structural-scope rewrite found 23 injection sites vs 5 in hardcoded scope. Reinforces DEC-120. | Feature Mode / S-FORK-OPS-SIGN-1 | Phase 3 | 2026-06-18 |
| DEC-122 | S-FORK-OPS-BACKFILL 2-story grouping by file to avoid worktree conflicts; parallel delivery gate. Full F1–F7 per DEC-120/121 precedent. | Feature Mode / S-FORK-OPS-BACKFILL F1 | Phase 3 | 2026-06-18 |
| DEC-123 | Fresh-context consistency audit at F2 gate caught 2 MAJOR cross-document defects that 3 adversarial passes missed. Validates consistency-validator at every gate. | Feature Mode / S-FORK-OPS-BACKFILL F2 | Phase 3 | 2026-06-18 |
| DEC-124 | Local pre-PR code review caught a CRITICAL Windows-build defect (`shell: bash` missing on Build step) that all 9 Red-Gate tests missed — coverage gap closed with a new guard test. Reinforces "clean local review before PR" + full VSDD on infra changes (cf DEC-120/121). | Feature Mode / S-FORK-OPS-BACKFILL F4 | Phase 3 | 2026-06-19 |
| DEC-125 | Full VSDD Feature Mode applied to DEAD-CITATION-CI guard (CI check that CLAUDE.md "Detail:"/"See:" file-path citations resolve to real on-disk files). Origin: 2026-06-19 maintenance sweep process-gap MAINT-PG-DEAD-CITATION-CI; research recommends Rust `#[test]` over bash per `.factory/research/maint-pg-dead-citation-ci-approach.md`. Consistent with DEC-120/121 precedent (full VSDD on CI-config/test changes). | Feature Mode / DEAD-CITATION-CI F1 | Phase 3 | 2026-06-20 |
| DEC-126 | DEAD-CITATION-CI F2 spec took 6 iterations / 10 adversarial passes to converge — the loop caught 6 distinct real defects (.factory/ CI-checkout flaw, count drift, message contradiction, over-engineered-fix regression, line-ref+punct false-negative, renumber fallout) before any code was written. Strong DEC-120/121 reinforcement. | Feature Mode / DEAD-CITATION-CI F2 | Phase 3 | 2026-06-20 |
| DEC-127 | F3 story review caught F-1 (HIGH) — the canonical error message's literal '(line N)' placeholder was non-actionable; fixed by carrying line provenance (Vec<(String,usize)>) so the guard reports the real line number. A story-altitude adversary catch that 10 F2 passes accepted — validates fresh-context review at every phase gate. | Feature Mode / DEAD-CITATION-CI F3 | Phase 3 | 2026-06-20 |

## Skip Log

All 7 S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 per-AC demos: **Yes — adapted**. CI-config / infra / docs / test-only / platform-cfg stories. See `cycles/cycle-001/burst-log.md`.

## Blocking Issues

<!-- No open blocking issues as of 2026-06-19. -->

## Drift Items

<!-- OPEN and actively-watched items only. RESOLVED items archived to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| MAINT-2026-06-17-SC-03 | ADR location | SC-03: docs/adr/ vs .factory/architecture/adr/ convention discrepancy. | LOW | DEFERRED |
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
| MAINT-PG-PR-MERGE-CHANNEL | process-gap | Maintenance-sweep PR merge-authorization path not codified; pr-manager refuses coordinator-relayed approval, forcing orchestrator-direct merge. Action: codify merge-auth path in maintenance workflow doc so human approval flows directly to pr-manager. | LOW | DEFERRED |
| MAINT-PG-CI-DOC-LINT | process-gap | CLAUDE.md src-file-tree drift (DRIFT-D15/D16 class) recurring across 2 sweeps; catchable by a CI script comparing src/ files vs CLAUDE.md tree. Action: new story to add scripts/check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| MAINT-PG-DEAD-CITATION-CI | process-gap | CLAUDE.md "Detail:"/"See:" path citations to non-existent files recurring (DRIFT-D13/D9 class). Action: scripts/check-claude-md-citations.sh verifying each cited path exists on disk, wired into ci-gate.needs. | LOW | IN-PROGRESS — DEAD-CITATION-CI feature cycle (DEC-125, 2026-06-20) |
| PERF-BASELINE-ABSENT | coverage-gap | Sweep 5 (perf) skipped for 4th consecutive sweep due to no benchmark baseline. Action: register draft story to establish minimal hyperfine baseline stored in .factory/perf/. | LOW | DEFERRED |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-19] S-FORK-OPS-BACKFILL CYCLE CLOSED + RELEASED v0.6.0-dev.5 — F5: 3 passes, novelty `2→0→0`. F6: PASS (CI-only, no src/ delta). F7: 5/5 PASS. PR #542 → develop @ 71f33c6 == v0.6.0-dev.5 tag. 3 LOW carry-forwards. IDLE.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-20 |
| **Position** | DEAD-CITATION-CI F3 CONVERGED (human-approved). Story S-MAINT-DEAD-CITATION-CI registered (90 total). DEC-125/126/127 logged. Maintenance sweeps PAUSED. develop @ 6bdb251. F4 TDD implementation next. |
| **develop HEAD** | origin/develop = **6bdb251** (docs: 2026-06-19 maintenance sweep accuracy fixes (#543); 1 commit ahead of v0.6.0-dev.5 tag 71f33c6). |
| **Activation** | v0.6.0-dev.5 @ 71f33c6. develop @ 6bdb251 (1 ahead). v0.5.0 STABLE shipped 2026-06-12. |
| **Counters** | BC **599**. NFR **42**. ADR **16**. Stories **90** (authoritative). |
| **Active worktree** | None. .factory on factory-artifacts mounted. |
| **jira-e2e env** | JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |
| **Standing constraints** | Do NOT close #429 (DEC-029). All fixes through full VSDD Feature Mode pipeline (DEC-120/121/124/125/126/127). LESSON-F2-WORKTREE-FIRST: ALL story-scoped edits (including docs/) in story worktree. Fork signing UNBLOCKED but INERT (DEC-104 pending). LESSON-F1-SIBLING-CASE. LESSON-CENTRALIZATION-AC-GREP. LESSON-CITATION-SIBLING-PROPAGATION. CHANGELOG-per-PR hygiene. LESSON-F2-PIECEWISE. Carry-forward drift items: FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING (accepted), FORK-OPS-F5-SELFTEST-CHECKLIST (deferred). |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: DEAD-CITATION-CI F3 CONVERGED. F4 starting 2026-06-20. develop @ 6bdb251 (1 ahead of v0.6.0-dev.5 tag). -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md`.

**Step 2:** DEAD-CITATION-CI feature cycle ACTIVE (DEC-125/126/127, 2026-06-20). F3 CONVERGED (3 adv passes + 2 consistency audits; story S-MAINT-DEAD-CITATION-CI registered; human-approved). F4 TDD implementation starting. Maintenance sweeps PAUSED. develop @ **6bdb251** (1 commit ahead of v0.6.0-dev.5 tag 71f33c6). Counters: BC **599**, NFR **42**, ADR **16**, Stories **90**. If develop shows different HEAD, run `git fetch origin`. Active worktrees: main checkout + `.factory` (factory-artifacts) only — no story worktrees open.

**Step 3 — Current feature cycle: DEAD-CITATION-CI.** F3 CONVERGED. Next steps: F4 Implementation (S-MAINT-DEAD-CITATION-CI: tests/claude_md_citations.rs + doc-fallout note) → F5 Adversarial → F6 Hardening → F7 Convergence. Spec canonical: BC-X.13.001/002/003 + error-taxonomy.md §8 CI-CITE-001. Story file: `.factory/stories/S-MAINT-DEAD-CITATION-CI.md`. After DEAD-CITATION-CI closes, open next-work candidates: **#532** (S-MAINT-532), Bundle D draft stories (S-MAINT-CR-005/CR-008/CR-009/SEC-001/SEC-JR-SERVICE-NAME-GATE), fork-ops signing enablement (DEC-104), **#429** (DO NOT close — DEC-029).

**Step 4 — STANDING CONSTRAINTS (survive session clear):**
- Do NOT close #429 (DEC-029, human-deferred).
- All fixes through full VSDD Feature Mode pipeline (DEC-120/121/124: full pipeline is NOT overhead on infra-only changes).
- Fork signing UNBLOCKED (DEC-104 still pending human + Apple secrets — no code work remaining).
- LESSON-F2-WORKTREE-FIRST: ALL story-scoped file edits (including docs/) in the story worktree, not main checkout.
- LESSON-F1-SIBLING-CASE, LESSON-CENTRALIZATION-AC-GREP, LESSON-CITATION-SIBLING-PROPAGATION, LESSON-F2-PIECEWISE.
- CHANGELOG-per-PR hygiene: keep CHANGELOG `[Unreleased]` populated as PRs merge.
- Merge/release agents require explicit human authorization. If an instance dead-locks on relayed approval, route via a fresh agent (not a nested relay).
- Subagents work in worktree paths (not main checkout) — LESSON-F2-WORKTREE-FIRST.
- Carry-forward LOW drift items remain OPEN/deferred (non-blocking, tracked in Drift Items). FORK-OPS-BACKFILL-TIMEOUT-PARITY RESOLVED (PR #543).

Durable follow-ups: see Drift Items section.

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md. -->

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
