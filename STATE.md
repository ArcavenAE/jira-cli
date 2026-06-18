---
document_type: pipeline-state
version: "2.0"
status: idle
timestamp: 2026-06-18T18:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "arcaven fork-ops PRs #528/#529/#530 reviewed + merged → develop @ 99f212d. IDLE."
current_cycle: "cycle-001"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "99f212d"
activation_version: "v0.6.0-dev.3"
---
<!-- SIZE BUDGET: <200 lines. Historical content → cycle files. Run /vsdd-factory:compact-state if over 200. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-18: arcaven fork-ops PRs #528/#529/#530 reviewed + squash-merged → develop @ 99f212d. IDLE. |
| **Current Phase** | Phase 3 — IDLE. develop @ 99f212d (v0.6.0-dev.3 + 3 fork-ops commits). BC 599. NFR 42. ADR 16. Stories 80. |
| **Next Phase** | Phase 4: Holdout Evaluation (not started) |
| **Activation HEAD** | 99f212d (develop HEAD 2026-06-18; 3 fork-ops commits ahead of v0.6.0-dev.3 tag @ 8aca89f; v0.5.0 STABLE shipped 2026-06-12) |

## Phase Progress

| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| 0: Codebase Ingestion | COMPLETE | 2026-05-04 | Phase A+B+B.5+B.6+C APPROVED | |
| 1: Spec Crystallization | COMPLETE | 2026-05-04 | PASSED — DEC-006/007/008 | |
| 1d: Adversarial Spec Review | COMPLETE — 3/3 CONVERGED Pass 28 | 2026-05-04 | 3/3 FULL CONVERGENCE | 30→15→9→5→10→5→4→3→4→0→2→0→3→0→2→0→3→0→3→5→3→4→5→5→5→2→0→0→0 |
| 2: Story Decomposition | COMPLETE | 2026-05-06 | 31 stories; F1–F7 COMPLETE | 2-adv: CONVERGED Pass 13 CLEAN; 14→5→5→5→4→5→4→4→4→1→0→1→0 |
| Phase 2 gate | APPROVED | 2026-05-07 | APPROVED by human | |
| 3: TDD Implementation | IN_PROGRESS — Feature Mode active | — | Wave 0/1/2/3 ALL COMPLETE (32/32) | Wave adversarial: GATE-CLOSED 2026-05-08; Feature Mode ongoing |
| Feature cycles #110..#499 (19 cycles, 2026-05-11..2026-06-11) | ALL CYCLE CLOSED + MERGED | 2026-06-11 | F1–F7 each | develop BC 583→594. See `cycles/cycle-001/burst-log.md`. |
| Issue #492 block-HTML hardBreak (BC-7.2.011) | CYCLE CLOSED + MERGED | 2026-06-16 | F1–F7 ALL COMPLETE — CONVERGED | PR #521 → develop @ 3ba8ea2. |
| Issue #522 ADF CR/newline normalization (EC-11+EC-12+CR-01) | CYCLE CLOSED + MERGED | 2026-06-17 | F1–F7 ALL COMPLETE — CONVERGED | PR #523 → develop @ 53f6d98. HIGH CR-01 caught by F5. |
| Maintenance sweep 2026-06-17 | COMPLETE | 2026-06-17 | ALL BUNDLES DELIVERED | PR #524→ca24200; PR #527→d56dcfc; PR #531→6f24748. S-7.02 SATISFIED. |
| S-TESTTOOL-1 test-tooling hardening | CYCLE CLOSED + MERGED | 2026-06-18 | F1–F7 ALL COMPLETE — CONVERGED | PR #533 → develop @ b4a470f. F5 caught HIGH + C-1. Stories 79→80. |
| arcaven fork-ops PRs #528/#529/#530 reviewed + merged | COMPLETE | 2026-06-18 | APPROVE / APPROVE-WITH-NITS; no CRITICAL/HIGH | #528→5d0d9a3 (docs sync); #529→2aae5ce (ci: rustup target add hardening); #530→99f212d (ci: Gatekeeper+hardened-runtime verify — closes #210). develop @ 99f212d. Signing still INERT. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| v0.6.0-dev.3 release: PR #534 squash-merged → develop @ 8aca89f. release.yml 27775233196 SUCCESS — 5-target build, 10 assets. Tag v0.6.0-dev.3. | orchestrator | RELEASED | develop @ 8aca89f. v0.6.0-dev.3 tag. |
| arcaven fork-ops PRs #528/#529/#530: security-reviewed (#529/#530) + pr-reviewed (#528); all APPROVE/APPROVE-WITH-NITS. Squash-merged #528→#529→#530. #530 closes #210 Gatekeeper gap. 3 new LOW nits → Drift Items. | orchestrator | COMPLETE | develop @ 99f212d. Signing INERT. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-119 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + maintenance decisions. All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-17 | archived |
| DEC-120 | S-TESTTOOL-1 full VSDD for a test/CI-config micro-change. F5 caught coverage-regression HIGH + C-1 (F2 edits in main checkout vs worktree). Validates: full VSDD is not bureaucratic overhead on "trivial" changes. | Feature Mode / S-TESTTOOL-1 | Phase 3 | 2026-06-18 |

## Skip Log

All 7 S-WIN-1..6 + #475 per-AC demos: **Yes — adapted**. CI-config / infra / docs / test-only / platform-cfg stories. See `cycles/cycle-001/burst-log.md`.

## Blocking Issues

<!-- No open blocking issues as of 2026-06-18. -->

## Drift Items

<!-- OPEN and actively-watched items only. RESOLVED items archived to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| MAINT-2026-06-17-SC-03 | ADR location | SC-03: docs/adr/ vs .factory/architecture/adr/ convention discrepancy. | LOW | DEFERRED |
| MAINT-HOLDOUT-H007-DRIFT | Holdout H-007 | H-007 mechanism stale (reactive fallback, not proactive as per ADR-0015). Batch with H-027/H-044. | LOW | OPEN |
| FORK-OPS-SIGN-INJECTION | sign-and-publish.yml | workflow_run.head_branch unquoted in shell with Apple secrets (CWE-77). Blocks signing. | HIGH | OPEN — gates signing |
| FORK-OPS-ALPHA-RACE | Alpha-tag race | Non-atomic alpha tag creation in sign-and-publish.yml. Blocks signing. | HIGH | OPEN — gates signing |
| FORK-OPS-BACKFILL-DESTRUCTIVE | release-gap-fill.yml | gh release delete+recreate can clobber curated notes. Blocks gap-fill. | MED | OPEN |
| FORK-OPS-PHANTOM-RUNS | Phantom workflow runs | ~7 phantom runs/day from new triggers. Cosmetic; decide suppress or accept. | LOW | OPEN |
| FORK-OPS-GITLEAKS-DOC | GITLEAKS_DISABLED | Secret-scan opt-out variable undocumented in CLAUDE.md/spec. | MED | OPEN — doc gap |
| FORK-OPS-BACKFILL-WIN-TARGET | backfill-release.yml | Windows target absent → backfilled releases lack Windows binary. | MED | OPEN |
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
| F7-001 | CLAUDE.md 'symmetric' | Minor precision gap in F7 consistency audit. | LOW | ACCEPTED-DEFERRED |
| F7-002 | F2-record archival | cycles/cycle-001/issue-492/f2-convergence.md archival note. | LOW | ACCEPTED-DEFERRED |
| F7-003 | BC-7.2.011 "13 tests" | Acceptable per check-bc-no-numeric-test-counts.sh qualitative policy. | LOW | ACCEPTED-DEFERRED |
| #492-TEST-HARNESS-COUPLING | process-gap F-P1-003 | Handler-level block-HTML tests couple to push_text shape; re-validate on refactor. | LOW | TRACKED DEFERRAL |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. | LOW | TRACKED DEFERRAL |
| LESSON-F2-WORKTREE-FIRST | process-gap C-1 | F2 spec edits to docs/ were in main checkout, not story worktree → stranded off PR. Rule: ALL story-scoped edits in worktree, even docs/. | LOW | DEFERRED — codified in lessons.md |
| KEYRING-GUARD-IDIOM-DRIFT | process-gap | Three co-existing keyring-gate guard idioms; no meta-test enforces canonical form. | LOW | DEFERRED |
| CITATION-FORM-DISCIPLINE | process-gap | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| F7-COSMETIC-ATTR-ORDER | cosmetic | Story Architecture Rule 3 says #[ignore] before #[test]; code uses #[test] first. Semantically irrelevant. | LOW | ACCEPTED-COSMETIC |
| #532-COVERAGE-FOLLOW-UP | coverage-gap | Login/Refresh/Logout global-`--profile` fallback ungated — issue #532 opened. | LOW | OPEN — issue #532 |
| FORK-OPS-NIT-USECROSS-GUARD | sign-and-publish.yml | `rustup target add` step lacks `if: !matrix.use_cross` guard present in backfill-release.yml (CWE-670). Cosmetic; bundle with fork-ops hardening. | LOW | OPEN |
| FORK-OPS-NIT-TMP-PREDICTABLE | sign-and-publish.yml | #530 verify steps use predictable /tmp/cs.out + /tmp/spctl.out paths; switch to mktemp (CWE-377/362). Theoretical on ephemeral runners. | LOW | OPEN |
| FORK-OPS-NIT-PIPEFAIL | sign-and-publish.yml | #530 verify steps use `set -e` without `set -o pipefail` on `codesign \| tee` chains (CWE-390). | LOW | OPEN |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-18] arcaven fork-ops #528/#529/#530 reviewed + merged → 99f212d. #210 CLOSED. develop 3 commits ahead of v0.6.0-dev.3 tag. IDLE.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-18 |
| **Position** | IDLE. arcaven fork-ops PRs #528/#529/#530 reviewed + merged → develop @ 99f212d. #210 CLOSED. 3 LOW nits added to Drift Items. v0.6.0-dev.3 tag @ 8aca89f; develop is 3 fork-ops commits ahead (not yet released). |
| **develop HEAD** | origin/develop = **99f212d** (arcaven #530 squash-merged 2026-06-18; 3 commits ahead of v0.6.0-dev.3 tag @ 8aca89f). |
| **Activation** | v0.6.0-dev.3 @ 8aca89f. develop now 3 fork-ops commits ahead of tag. v0.5.0 STABLE shipped 2026-06-12. |
| **Counters** | BC **599**. NFR **42**. ADR **16**. Stories **80** (authoritative). |
| **Active worktree** | None. .factory on factory-artifacts mounted. |
| **jira-e2e env** | JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |
| **Standing constraints** | Do NOT close #429 (DEC-029). All fixes through full VSDD Feature Mode pipeline. LESSON-F2-WORKTREE-FIRST: F2 spec edits to docs/ must be in the story worktree, not main checkout. Fork-release-ops INERT (blocked on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE HIGH). LESSON-F1-SIBLING-CASE: enumerate sibling control-char cases at any normalization chokepoint. LESSON-CENTRALIZATION-AC-GREP: centralization ACs must use enumeration or multiline-aware scanning, never single-line grep negation. LESSON-CITATION-SIBLING-PROPAGATION: grep ALL sibling occurrences when removing any misattributed citation. CHANGELOG-per-PR hygiene: keep [Unreleased] populated as PRs merge. |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: IDLE. arcaven fork-ops #528/#529/#530 merged. develop @ 99f212d (3 ahead of v0.6.0-dev.3 tag). No active worktrees. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md`.

**Step 2:** Confirm IDLE. develop @ **99f212d** (arcaven fork-ops #530 squash-merged 2026-06-18; develop is 3 fork-ops commits ahead of v0.6.0-dev.3 tag @ 8aca89f — NOT yet released). Activation v0.6.0-dev.3. No active feature worktrees. S-TESTTOOL-1 CYCLE CLOSED + MERGED (PR #533 → b4a470f). arcaven PRs #528/#529/#530 reviewed + merged. #210 CLOSED. If develop shows different HEAD, run `git fetch origin`.

**Step 3 — Determine next work.** OPEN (priority order):
- Fork-release-ops enablement PENDING (DEC-104; gated on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE HIGH — see Drift Items).
- **#532** Login/Refresh/Logout global-`--profile` fallback ungated coverage — LOW, follow-up from S-TESTTOOL-1 F5.
- **#429** jr_isolated crypto-random suffix — DO NOT close autonomously (DEC-029, human-deferred).
- **#400** Story B + engine items.
- **#372** cargo-mutants partial baseline.
- **#387/#368** git-history-rewrite/open-PR (force-push needed, deferred).
- **#209/#210** backlog.
- If human brings new feature/bug: run Feature Mode (F1–F7) per `workflows/feature.lobster`.

**Step 4 — STANDING CONSTRAINTS (survive session clear):**
- Do NOT close #429 (DEC-029, human-deferred).
- All fixes through full VSDD Feature Mode pipeline (S-TESTTOOL-1 proved this catches real regressions on "trivial" changes).
- Fork-release-ops workflows INERT — enablement blocked on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE (HIGH).
- LESSON-F2-WORKTREE-FIRST: ALL story-scoped file edits (including docs/) in the story worktree, not main checkout — stranding off PR branch is a C-1 orchestration error.
- LESSON-F1-SIBLING-CASE: enumerate sibling control-char/invariant cases at any normalization chokepoint.
- LESSON-CENTRALIZATION-AC-GREP: centralization ACs must use enumeration or multiline-aware scanning, never single-line grep negation.
- LESSON-CITATION-SIBLING-PROPAGATION: grep ALL sibling occurrences when removing any misattributed external-tracker citation.
- CHANGELOG-per-PR hygiene: keep CHANGELOG `[Unreleased]` populated as PRs merge — do not let it drift empty across merges.
- E2E-PG-4, SEC-001 LOW deferrals remain open; FORK-OPS-* items tracked in Drift Items.

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
| #210 | ci(sign): verify Gatekeeper + hardened runtime after notarize | CLOSED — merged via #530 (99f212d) 2026-06-18 | — | Literal gap now closed. Signing still INERT pending FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE. |
| #520 | ci: opt-in release ops (fork-friendly) | MERGED @ 2cb219b. Inert by default. Enablement decision PENDING — DEC-104. | LOW | |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-001..119 + archived phase rows + closed issues | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items (incl. MAINT-MUTANTS-GLOBS-01 + #526-F6-KEYRING-GATE) | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
| Maintenance sweep 2026-06-17 session review | `maintenance/2026-06-17/session-review.md` |
