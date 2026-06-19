---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-19T12:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "Feature Mode active — S-FORK-OPS-BACKFILL bundle. F5 CONVERGED 2026-06-19 (3 passes; M4 fixed FIX-F5-001/PR #540 @ 83a141ad). develop @ 83a141ad. F6 (Formal Hardening) starting."
current_cycle: "cycle-001"
feature_mode_bundle: "S-FORK-OPS-BACKFILL"
feature_mode_phase: "F6"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "45ddf7a"
activation_version: "v0.6.0-dev.4"
---
<!-- SIZE BUDGET: <200 lines. Historical content → cycle files. Run /vsdd-factory:compact-state if over 200. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-19: S-FORK-OPS-BACKFILL F5 CONVERGED (3 passes; M4 fixed FIX-F5-001/PR #540 @ 83a141ad). F6 starting. |
| **Current Phase** | Phase 3 — Feature Mode active (S-FORK-OPS-BACKFILL, F6 active). develop @ 83a141ad. BC 599. NFR 42. ADR 16. Stories 83. |
| **Next Phase** | F6: Formal Hardening (targeted; CI-only bundle) |
| **Activation HEAD** | 45ddf7a (v0.6.0-dev.4 tag; v0.5.0 STABLE shipped 2026-06-12) |

## Phase Progress

| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| 0: Codebase Ingestion | COMPLETE | 2026-05-04 | Phase A+B+B.5+B.6+C APPROVED | |
| 1: Spec Crystallization | COMPLETE | 2026-05-04 | PASSED — DEC-006/007/008 | |
| 1d: Adversarial Spec Review | COMPLETE — 3/3 CONVERGED Pass 28 | 2026-05-04 | FULL CONVERGENCE | 30→15→…→0→0→0 |
| 2: Story Decomposition | COMPLETE | 2026-05-06 | 31 stories; F1–F7 COMPLETE | 14→5→…→1→0→1→0 CONVERGED |
| Phase 2 gate | APPROVED | 2026-05-07 | APPROVED by human | |
| 3: TDD Implementation | IN_PROGRESS — Feature Mode active | — | Wave 0/1/2/3 ALL COMPLETE (32/32) | Wave adversarial: GATE-CLOSED 2026-05-08; Feature Mode ongoing |
| Feature cycles #110..#499 + #492 + #522 + maintenance (19+ cycles, 2026-05-11..2026-06-17) | ALL CYCLE CLOSED + MERGED | 2026-06-17 | F1–F7 each | develop BC 583→599. See `cycles/cycle-001/burst-log.md`. |
| S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + v0.6.0-dev.4 + fork-ops PRs #528-530 | CYCLE CLOSED + MERGED | 2026-06-18 | F1–F7 COMPLETE | PRs #533/#535/#536/#528-530. develop @ 45ddf7a == v0.6.0-dev.4 tag. Stories 79→81. |
| S-FORK-OPS-BACKFILL F1+F2+F3 | COMPLETE — human-approved 2026-06-18 | 2026-06-18 | APPROVED by human | 3 adv passes CONVERGED; consistency audit 2 MAJOR caught+fixed; spec 1.3.23→1.3.24; 2 stories 81→83. |
| **S-FORK-OPS-BACKFILL F4** | **COMPLETE** | **2026-06-19** | **PR #539+#538 MERGED** | **S-FORK-OPS-BACKFILL-1 → 2756050; S-FORK-OPS-GITLEAKS-DOC-1 → f85647b. 1866 tests. DEC-124.** |
| **S-FORK-OPS-BACKFILL F5** | **CONVERGED** | **2026-06-19** | **3 passes; M4 fixed FIX-F5-001/PR #540 @ 83a141ad** | Trajectory: `2→0→0`. M2 accepted; O3+timeout tracked. develop @ 83a141ad. |
| 4: Holdout Evaluation | not-started | | | |
| 6: Formal Hardening (F6) | IN_PROGRESS — starting | — | — | Targeted; CI-only bundle |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **S-FORK-OPS-BACKFILL F4 COMPLETE** — both stories squash-merged 2026-06-19. S-FORK-OPS-BACKFILL-1 → PR #539 (2756050): WIN parity + safe upsert + 11 tests. S-FORK-OPS-GITLEAKS-DOC-1 → PR #538 (f85647b): GITLEAKS_DISABLED docs. DEC-124: local review caught CRITICAL `shell: bash` defect. 1866 tests / 0 failing. | state-manager | F4 COMPLETE | develop @ f85647b. 2 ahead of v0.6.0-dev.4 tag. |
| **FIX-F5-001 / PR #540 MERGED** — Fixed `test_backfill_release_job_zip_in_both_upsert_branches`: anchored zip assertion to distinct branches instead of counting ≥2 anywhere (vacuous assertion). M4 from F5 Pass 1. develop @ 83a141ad. | state-manager | FIX-F5-001 MERGED | PR #540 @ 83a141ad. 3 ahead of v0.6.0-dev.4. |
| **S-FORK-OPS-BACKFILL F5 CONVERGED** — 3 passes (novelty 0.35→0.08→LOW). 0 CRIT/HIGH. M4 fixed (FIX-F5-001/PR #540); M2 accepted (zip-glob fail-loud); O3+timeout tracked as drift items. Advancing to F6 (Formal Hardening). | state-manager | F5 CONVERGED | develop @ 83a141ad. F6 active. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-119 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + maintenance decisions. All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-17 | archived |
| DEC-120 | S-TESTTOOL-1 full VSDD for a test/CI-config micro-change. F5 caught coverage-regression HIGH + C-1. Validates: full VSDD is not bureaucratic overhead on "trivial" changes. | Feature Mode / S-TESTTOOL-1 | Phase 3 | 2026-06-18 |
| DEC-121 | S-FORK-OPS-SIGN-1 full VSDD Feature Mode on a CI-workflow-only security fix. F5 caught a CRITICAL guard false-negative: structural-scope rewrite found 23 injection sites vs 5 in hardcoded scope. Reinforces DEC-120. | Feature Mode / S-FORK-OPS-SIGN-1 | Phase 3 | 2026-06-18 |
| DEC-122 | S-FORK-OPS-BACKFILL 2-story grouping by file to avoid worktree conflicts; parallel delivery gate. Full F1–F7 per DEC-120/121 precedent. | Feature Mode / S-FORK-OPS-BACKFILL F1 | Phase 3 | 2026-06-18 |
| DEC-123 | Fresh-context consistency audit at F2 gate caught 2 MAJOR cross-document defects that 3 adversarial passes missed. Validates consistency-validator at every gate. | Feature Mode / S-FORK-OPS-BACKFILL F2 | Phase 3 | 2026-06-18 |
| DEC-124 | Local pre-PR code review caught a CRITICAL Windows-build defect (`shell: bash` missing on Build step) that all 9 Red-Gate tests missed — coverage gap closed with a new guard test. Reinforces "clean local review before PR" + full VSDD on infra changes (cf DEC-120/121). | Feature Mode / S-FORK-OPS-BACKFILL F4 | Phase 3 | 2026-06-19 |

## Skip Log

All 7 S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 per-AC demos: **Yes — adapted**. CI-config / infra / docs / test-only / platform-cfg stories. See `cycles/cycle-001/burst-log.md`.

## Blocking Issues

<!-- No open blocking issues as of 2026-06-19. -->

## Drift Items

<!-- OPEN and actively-watched items only. RESOLVED items archived to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| MAINT-2026-06-17-SC-03 | ADR location | SC-03: docs/adr/ vs .factory/architecture/adr/ convention discrepancy. | LOW | DEFERRED |
| MAINT-HOLDOUT-H007-DRIFT | Holdout H-007 | H-007 mechanism stale (reactive fallback, not proactive as per ADR-0015). Batch with H-027/H-044. | LOW | OPEN |
| FORK-OPS-BACKFILL-DESTRUCTIVE | release-gap-fill.yml | gh release delete+recreate can clobber curated notes. | MED | IMPLEMENTED-ON-DEVELOP — fully closes at F7/release |
| FORK-OPS-PHANTOM-RUNS | Phantom workflow runs | ~7 phantom runs/day from new triggers. Cosmetic; decide suppress or accept. | LOW | OPEN |
| FORK-OPS-GITLEAKS-DOC | GITLEAKS_DISABLED | Secret-scan opt-out variable undocumented in CLAUDE.md/spec. | MED | IMPLEMENTED-ON-DEVELOP — fully closes at F7/release |
| FORK-OPS-BACKFILL-WIN-TARGET | backfill-release.yml | Windows target absent → backfilled releases lack Windows binary. | MED | IMPLEMENTED-ON-DEVELOP — fully closes at F7/release |
| WIN-CFG-TESTS-CHECK | Cross-compile | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME | Not debug-gated unlike JR_BASE_URL/JR_AUTH_HEADER. | LOW | OPEN |
| WIN-DENY-FRAGILITY | deny.toml | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK poison | .lock().unwrap() in auth tests; use unwrap_or_else. | LOW | OPEN |
| E2E-PG-4 | E2E coverage gap | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| DRIFT-331-PAGINATION | get_issue_types_for_project | Inline reimplementation; target: reuse OffsetPage<T>. | LOW | OPEN |
| PG-A / DRIFT-README | Count guards | check-bc-cumulative-counts.sh misses README.md; Document Map total stale. | LOW | OPEN |
| SEC-001 | CWE-674 recursion | Uncontrolled recursion in adf.rs normalize/assign_local_ids/render_node. | LOW | OPEN |
| WIN-PG-1 | No BC-count CI guard | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Story template | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Windows OAuth probe | Release OAuth verification is constants-file check only; no runtime jr auth status. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | XDG→JR seam-migration | Enforcement test has directional blind spot. | LOW | OPEN |
| F7-001..F7-003 | Minor precision gaps | CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests". | LOW | ACCEPTED-DEFERRED |
| #492-TEST-HARNESS-COUPLING | process-gap | Handler-level block-HTML tests couple to push_text shape. | LOW | TRACKED DEFERRAL |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. | LOW | TRACKED DEFERRAL |
| LESSON-F2-WORKTREE-FIRST | process-gap C-1 | ALL story-scoped edits in worktree, even docs/. Codified in lessons.md. | LOW | DEFERRED |
| KEYRING-GUARD-IDIOM-DRIFT | process-gap | Three co-existing keyring-gate guard idioms; no meta-test enforces canonical form. | LOW | DEFERRED |
| CITATION-FORM-DISCIPLINE | process-gap | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| F7-COSMETIC-ATTR-ORDER | cosmetic | Story Architecture Rule 3 says #[ignore] before #[test]; code uses #[test] first. | LOW | ACCEPTED-COSMETIC |
| #532-COVERAGE-FOLLOW-UP | coverage-gap | Login/Refresh/Logout global-`--profile` fallback ungated — issue #532 opened. | LOW | OPEN — issue #532 |
| FORK-OPS-COMPOSITE-ACTION-SCAN | sign-and-publish.yml | Injection guard does not follow local composite actions; none exist today. F5 OBS-1. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | sign-and-publish.yml | Empty head_branch → TAG=""/VERSION="" (theoretical CWE-74). Future story. | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | sign-and-publish.yml | Orphaned alpha tags from failed runs accumulate. Future housekeeping story. | LOW | OPEN |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | backfill-release.yml | `gh release upload jr-*.zip` fails loud on zero-match glob (accepted; guarded by needs:build + matrix-parity test; parity with release.yml). | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | process-gap | F5 checklist conflates `--self-test` inline fixture with real-file scan; wording could mislead. | LOW | OPEN |
| FORK-OPS-BACKFILL-TIMEOUT-PARITY | backfill-release.yml | backfill build job lacks `timeout-minutes` (release.yml=60); minor housekeeping. | LOW | OPEN |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-19] S-FORK-OPS-BACKFILL F5 CONVERGED — 3 passes, novelty 0.35→0.08→LOW. M4 fixed (FIX-F5-001/PR #540); M2 accepted; O3+timeout tracked. develop @ 83a141ad (3 ahead of v0.6.0-dev.4). F6 (Formal Hardening) starting.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-19 |
| **Position** | Feature Mode ACTIVE — S-FORK-OPS-BACKFILL bundle. F5 CONVERGED 2026-06-19 (3 passes). FIX-F5-001/PR #540 merged. develop @ 83a141ad. F6 (Formal Hardening) starting. Stories 83. |
| **develop HEAD** | origin/develop = **83a141ad** (test fix: FIX-F5-001; 3 commits ahead of v0.6.0-dev.4 tag). |
| **Activation** | v0.6.0-dev.4 @ 45ddf7a. develop = 83a141ad (3 ahead). v0.5.0 STABLE shipped 2026-06-12. |
| **Counters** | BC **599**. NFR **42**. ADR **16**. Stories **83** (authoritative). |
| **Active worktree** | None (F5 complete). .factory on factory-artifacts mounted. |
| **jira-e2e env** | JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |
| **Standing constraints** | Do NOT close #429 (DEC-029). All fixes through full VSDD Feature Mode pipeline (DEC-120/121/124). LESSON-F2-WORKTREE-FIRST: ALL story-scoped edits (including docs/) in story worktree. Fork signing UNBLOCKED but INERT (DEC-104 pending). LESSON-F1-SIBLING-CASE. LESSON-CENTRALIZATION-AC-GREP. LESSON-CITATION-SIBLING-PROPAGATION. CHANGELOG-per-PR hygiene. LESSON-F2-PIECEWISE. **MERGE PRE-AUTHORIZATION (standing):** User pre-authorized merging all remaining within-bundle F5/F6 fix-PRs to develop without per-PR human prompts. F7 public release remains explicit human gate. |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: Feature Mode ACTIVE — S-FORK-OPS-BACKFILL bundle, F5 CONVERGED, F6 starting. develop @ 83a141ad (3 ahead of v0.6.0-dev.4). No active feature worktrees. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md`.

**Step 2:** Confirm Feature Mode ACTIVE — S-FORK-OPS-BACKFILL bundle. develop @ **83a141ad** (3 ahead of v0.6.0-dev.4 tag). F5 CONVERGED (3 passes, 2026-06-19). FIX-F5-001/PR #540 merged. Stories **83** (authoritative). Spec 1.3.24. F6 (Formal Hardening) active. Delta: `.factory/phase-f1-delta-analysis/delta-analysis-fork-ops-backfill-1.md`. F5 artifacts: `.factory/phase-f5-adversarial/S-FORK-OPS-BACKFILL/`. DEC-122/123/124. If develop shows different HEAD, run `git fetch origin`.

**Step 3 — F6 Formal Hardening.** Run `/vsdd-factory:phase-f6-targeted-hardening`. Targeted scope: CI-only bundle (backfill-release.yml + workflow changes). Expected: light pass. Focus: mutation test gate, cargo deny check, security scan on CI yaml.

**Step 4 — STANDING CONSTRAINTS (survive session clear):**
- Do NOT close #429 (DEC-029, human-deferred).
- All fixes through full VSDD Feature Mode pipeline (DEC-120/121/124: full pipeline is NOT overhead on infra-only changes).
- Fork signing UNBLOCKED (DEC-104 still pending human + Apple secrets — no code work remaining).
- LESSON-F2-WORKTREE-FIRST: ALL story-scoped file edits (including docs/) in the story worktree, not main checkout.
- LESSON-F1-SIBLING-CASE, LESSON-CENTRALIZATION-AC-GREP, LESSON-CITATION-SIBLING-PROPAGATION, LESSON-F2-PIECEWISE.
- CHANGELOG-per-PR hygiene: keep CHANGELOG `[Unreleased]` populated as PRs merge.
- 3 FORK-OPS-BACKFILL-* drift items are IMPLEMENTED-ON-DEVELOP; they fully close at F7/release.
- **MERGE PRE-AUTHORIZATION (standing):** User pre-authorized merging all remaining within-bundle F5/F6 fix-PRs to develop without per-PR human prompts. F7 public release remains explicit human gate.

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
