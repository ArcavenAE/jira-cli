---
document_type: pipeline-state
version: "2.0"
status: idle
timestamp: 2026-06-17T23:30:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "Maintenance sweep 2026-06-17 COMPLETE. Bundle A MERGED (PR #524 → ca24200). Bundle B COMMITTED (factory-artifacts @ 20d2441). Bundle C MERGED: #526 (PR #527 → d56dcfc) + #525 (PR #531 → 6f24748). develop HEAD 6f24748. BC 599. Stories 79. S-7.02 checklist SATISFIED. IDLE — no active worktree."
current_cycle: "cycle-001"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "4258202"
activation_version: "v0.6.0-dev.2"
---
<!-- SIZE BUDGET: <200 lines. Historical content → cycle files. Run /vsdd-factory:compact-state if over 200. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-17: Maintenance sweep COMPLETE. Bundle A MERGED (PR #524 → ca24200). Bundle B factory-artifacts @ 20d2441 (SC-01/02/04/06/07). Bundle C MERGED: #526 (PR #527 → d56dcfc) + #525 (PR #531 → 6f24748). develop HEAD 6f24748. BC 599. Stories 79. S-7.02 checklist SATISFIED. IDLE. |
| **Current Phase** | Phase 3 — IDLE. Maintenance sweep 2026-06-17 COMPLETE. develop @ 6f24748. BC 599. NFR 42. ADR 16. Stories 79. |
| **Next Phase** | Phase 4: Holdout Evaluation (not started) |
| **Activation HEAD** | 4258202 (v0.6.0-dev.2 released 2026-06-14; develop HEAD 6f24748; v0.5.0 STABLE shipped 2026-06-12) |

## Phase Progress

| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| 0: Codebase Ingestion | COMPLETE | 2026-05-04 | Phase A+B+B.5+B.6+C APPROVED | |
| 1: Spec Crystallization | COMPLETE | 2026-05-04 | PASSED — DEC-006/007/008 | |
| 1d: Adversarial Spec Review | COMPLETE — 3/3 CONVERGED Pass 28 | 2026-05-04 | 3/3 FULL CONVERGENCE | 30→15→9→5→10→5→4→3→4→0→2→0→3→0→2→0→3→0→3→5→3→4→5→5→5→2→0→0→0 |
| 2: Story Decomposition | COMPLETE | 2026-05-06 | 31 stories; F1–F7 COMPLETE | 2-adv: CONVERGED Pass 13 CLEAN; 14→5→5→5→4→5→4→4→4→1→0→1→0 |
| Phase 2 gate | APPROVED | 2026-05-07 | APPROVED by human | |
| 3: TDD Implementation | IN_PROGRESS — Feature Mode active | — | Wave 0/1/2/3 ALL COMPLETE (32/32) | Wave adversarial: GATE-CLOSED 2026-05-08; Feature Mode ongoing |
| Feature cycles #110..#499 (19 cycles, 2026-05-11..2026-06-11) | ALL CYCLE CLOSED + MERGED | 2026-06-11 | F1–F7 each | develop BC 583→594. See `cycles/cycle-001/burst-log.md` "Archived Phase Progress Rows". |
| Issue #492 block-HTML hardBreak (BC-7.2.011) | **CYCLE CLOSED + MERGED** | 2026-06-16 | F1–F7 ALL COMPLETE — CONVERGED | PR #521 → develop @ 3ba8ea2. BC-7.2.011 v1.9.6. |
| Issue #522 ADF CR/newline normalization (EC-11+EC-12+CR-01) | **CYCLE CLOSED + MERGED** | 2026-06-17 | F1–F7 ALL COMPLETE — CONVERGED | PR #523 → develop @ 53f6d98. BC-7.2.011 v1.11.0. HIGH CR-01 caught by F5. DEC-110..119. |
| Maintenance sweep 2026-06-17 | **COMPLETE** | 2026-06-17 | ALL BUNDLES DELIVERED | Bundle A: PR #524 → ca24200. Bundle B: factory-artifacts @ 20d2441. Bundle C: #526 PR #527 → d56dcfc + #525 PR #531 → 6f24748. S-7.02 SATISFIED. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| Bundle A DELIVERED+MERGED: PR #524 squash-merged → develop @ ca24200. Doc-accuracy fixes (DRIFT-D1..D12, CR-003/004, OQ-5/NFR-O-N, CLAUDE.md arch tree, README). CI 13/13 GREEN. Bundle B COMMITTED: factory-artifacts @ 20d2441 (SC-01/02/04/06/07). | orchestrator + state-manager | **A MERGED / B COMMITTED** | develop @ ca24200. factory-artifacts @ 20d2441. |
| #526 (Bundle C Story 2) F7 CONVERGED 5/5. PR #527 MERGED → d56dcfc. CI GREEN. 2 compact→pretty behavior changes disclosed. | orchestrator | **MERGED** | develop @ d56dcfc. |
| #525 (Bundle C Story 1) F7 CONVERGED 5/5. PR #531 MERGED → 6f24748. CI GREEN. LESSON-CITATION-SIBLING-PROPAGATION codified. | orchestrator | **MERGED** | develop @ 6f24748. |
| Maintenance sweep 2026-06-17 COMPLETE. Session review written. S-7.02 checklist SATISFIED. 2 new drift items added (MAINT-MUTANTS-GLOBS-01, MAINT-HOLDOUT-H007-DRIFT). cycle-001 maintenance sub-cycle CLOSED. | state-manager | **IDLE** | develop @ 6f24748. factory-artifacts committed. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-063 | Phase 0/1/2 + Wave + Feature Mode decisions (multiple issues + dev releases). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-02 | archived |
| DEC-064..DEC-078 | JSM E2E (064..066), #471 taskList ADF F1..F6 (067..071), leading-dash fix (072), #475 E2E (073..076), v0.5.0-dev.14 + v0.5.0 STABLE releases (077..078). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 3 / 2026-06-02..12 | archived |
| DEC-079..092 | Windows-build F1..F4 decisions. All archived. | See `cycles/cycle-001/burst-log.md` | Phase 3 | 2026-06-12..13 |
| DEC-093..106 | Windows-build F4–F7 + fork-release-ops integration + #492 F1–F2/F5 cycle decisions (all CYCLE CLOSED). | See `cycles/cycle-001/burst-log.md` | Phase 3 | 2026-06-14..16 |
| DEC-107..119 | 2026-06-16..17: Issue #492 F5–F7+CYCLE-CLOSE (DEC-107..109) + Issue #522 full F1–F7+CYCLE-CLOSE (DEC-110..119). All CYCLE CLOSED. See `cycles/cycle-001/burst-log.md` "Archived Decisions DEC-107..119". | Feature Mode / #492+#522 | Phase 3 | 2026-06-16..17 |

## Skip Log

All 7 S-WIN-1..6 + #475 per-AC demos: **Yes — adapted**. All are CI-config / infra / docs / test-only / platform-cfg stories with no user-visible runtime behavior on the macOS dev host. See `cycles/cycle-001/burst-log.md` for per-story justification rows.

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|
<!-- No open blocking issues as of 2026-06-17 maintenance sweep COMPLETE. -->

## Drift Items

<!-- OPEN and actively-watched items only. DEFERRED/LOW archived to cycles/cycle-001/burst-log.md "Archived Drift Items". -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| MAINT-2026-06-17-SC-03 | ADR location convention | SC-03: docs/adr/ vs .factory/architecture/adr/ convention discrepancy. Not actioned in Bundle B sweep. | LOW | DEFERRED — tracked for future CLAUDE.md/docs cleanup |
| MAINT-MUTANTS-GLOBS-01 | mutants.toml examine_globs | `.cargo/mutants.toml` examine_globs does not cover `src/api/jira/issues.rs` or `src/cache.rs` (highest-risk pagination files). Diff-scoped `--in-diff` path works correctly for PRs; baseline full-repo scan has a blind spot. Fix: add those globs (2-line config change; quick-dev route). | LOW | OPEN — process-gap, untracked until this sweep |
| MAINT-HOLDOUT-H007-DRIFT | Holdout H-007 mechanism drift | H-007 documents the reactive POST-400 resolution-enforcement flow which is now the FALLBACK (ADR-0015/BC-3.2.013 made enforcement proactive). Substring assertion still passes but mechanism description is stale. Batch with H-027/H-044 prose fixes. | LOW | OPEN — doc gap, untracked until this sweep |
| FORK-OPS-SIGN-INJECTION | `sign-and-publish.yml` shell injection | `workflow_run.head_branch` written unsanitized into shell with Apple secrets (CWE-77, SEC-001/CR-001). Blocks signing enablement. | HIGH | OPEN — gates signing |
| FORK-OPS-ALPHA-RACE | Alpha-tag read-then-create race | Non-atomic alpha tag in `sign-and-publish.yml`. Blocks signing enablement. | HIGH | OPEN — gates signing |
| FORK-OPS-BACKFILL-DESTRUCTIVE | `release-gap-fill.yml` blast radius | `gh release delete`+recreate can clobber curated notes. Blocks gap-fill enable. | MED | OPEN — gates gap-fill |
| FORK-OPS-PHANTOM-RUNS | ~7 phantom workflow runs/day | New schedule/push triggers create skipped runs on canonical. Cosmetic; decide suppress or accept. | LOW | OPEN — decide |
| FORK-OPS-GITLEAKS-DOC | `GITLEAKS_DISABLED` undocumented | Secret-scan opt-out variable added to ci.yml but not documented in CLAUDE.md or spec. | MED | OPEN — doc gap |
| FORK-OPS-BACKFILL-WIN-TARGET | `backfill-release.yml` missing Windows | `x86_64-pc-windows-msvc` target absent → backfilled releases lack Windows binary. | MED | OPEN — fix before enabling |
| WIN-CFG-TESTS-CHECK | Cross-compile must use --tests, not --lib | `cargo check --lib` excludes #[cfg(test)] blocks — use `--tests`. | LOW | OPEN — process-gap |
| SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME env var not debug-gated | Unlike JR_BASE_URL/JR_AUTH_HEADER, readable in release builds. | LOW | OPEN — follow-up |
| WIN-DENY-FRAGILITY | deny.toml canonical-un-skipped-version has no CI guard | 17-entry skip set topology-dependent; future windows-sys update could silently break N-1 invariant. | LOW | OPEN — tracked process-gap |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK uses .lock().unwrap() in auth tests | Latent poison-cascade risk. Apply .unwrap_or_else(|e| e.into_inner()) uniformly. | LOW | OPEN — follow-up |
| E2E-PG-4 | E2E coverage gap | REMAINING: remote-link round-back (no `jr remote-link read`). | LOW | OPEN |
| DRIFT-331-PAGINATION | get_issue_types_for_project pagination | Inline reimplementation; target: reuse OffsetPage<T>. Deferred. | LOW | OPEN |
| PG-A / DRIFT-README | Count guards + README.md stale | check-bc-cumulative-counts.sh misses README.md; Document Map grand total 573 vs canonical 587. Deferred. | LOW | OPEN |
| SEC-001 | CWE-674 deep-nesting recursion in adf.rs | Uncontrolled recursion in normalize/assign_local_ids/render_node. Deferred. | LOW | OPEN |
| WIN-PG-1 | No CI guard for inline-PROSE BC counts | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Story-template lacks presence-only-test disclosure field | Anchoring aspect resolved by LESSON-PRESENCE-ANCHOR; template-field disclosure remains open. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Windows release OAuth verification is constants-file check only | Unix `jr auth status` runtime probe not yet ported to Windows. Accepted in ADR-0016 Decision 5c amendment (DEC-098). | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | XDG→JR seam-migration enforcement test has directional blind spot | Narrow, documented. | LOW | OPEN — tracked process-gap |
| #526-F6-KEYRING-GATE | auth_profiles::global_profile_flag_targets_auth_status not gated behind JR_RUN_KEYRING_TESTS | Can hang under Keychain contention. Quick-dev route candidate. | LOW | OPEN — follow-up |
| F7-001 | CLAUDE.md 'symmetric' wording | Minor precision gap noted in F7 consistency audit. Non-blocking cosmetic. | LOW | ACCEPTED-DEFERRED |
| F7-002 | F2-record archival note | cycles/cycle-001/issue-492/f2-convergence.md archival notation note. No functional gap. | LOW | ACCEPTED-DEFERRED |
| F7-003 | BC-7.2.011 "13 tests" phrasing | Acceptable per check-bc-no-numeric-test-counts.sh qualitative policy. | LOW | ACCEPTED-DEFERRED |
| #492-TEST-HARNESS-COUPLING | process-gap (F-P1-003) | Handler-level block-HTML tests couple to push_text accumulation shape; re-validate on push_text refactor. | LOW | TRACKED DEFERRAL |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. Must be PHASE-AWARE. | LOW | TRACKED DEFERRAL |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-17] Maintenance sweep COMPLETE. #525 MERGED → 6f24748. #526 MERGED → d56dcfc. #522 CYCLE CLOSED → 53f6d98. #492 CYCLE CLOSED → 3ba8ea2.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-17 |
| **Position** | IDLE. Maintenance sweep 2026-06-17 COMPLETE. All bundles delivered and merged. S-7.02 checklist SATISFIED. cycle-001 maintenance sub-cycle CLOSED. |
| **develop HEAD** | origin/develop = **6f24748** (PR #531 squash-merged 2026-06-17). |
| **Activation** | v0.6.0-dev.2 @ 4258202. v0.5.0 STABLE shipped 2026-06-12. |
| **Counters** | BC **599**. NFR **42**. ADR **16**. Stories **79** (authoritative). |
| **Active worktree** | None (S-525 and S-526 worktrees cleaned up). .factory on factory-artifacts is mounted. |
| **jira-e2e env** | JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |
| **Standing constraints** | Do NOT close #429 (DEC-029). All fixes through full VSDD Feature Mode pipeline (except quick-dev-route for test-hygiene micro-fixes per Rec 3 from session review). Fork-release-ops INERT (blocked on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE HIGH). LESSON-F1-SIBLING-CASE: enumerate sibling control-char cases at any normalization chokepoint. LESSON-CENTRALIZATION-AC-GREP: centralization ACs must use enumeration or multiline-aware scanning, never single-line grep negation. LESSON-CITATION-SIBLING-PROPAGATION: when removing a misattributed citation, grep ALL sibling occurrences symmetrically. |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: IDLE. Maintenance sweep COMPLETE. develop @ 6f24748. No active worktrees. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md`.

**Step 2:** Confirm IDLE. develop @ 6f24748. No active feature worktrees. Maintenance sweep 2026-06-17 COMPLETE. If develop shows different HEAD, run `git fetch origin`.

**Step 3 — Determine next work.** OPEN (priority order):
- Fork-release-ops enablement PENDING (DEC-104; gated on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE HIGH — see Drift Items).
- Quick-dev-route items: MAINT-MUTANTS-GLOBS-01 (add 2 globs to mutants.toml), #526-F6-KEYRING-GATE (add `#[ignore]` guard to test).
- **#429** jr_isolated crypto-random suffix — DO NOT close autonomously (DEC-029, human-deferred).
- **#400** Story B + engine items.
- **#372** cargo-mutants partial baseline.
- **#387/#368** git-history-rewrite/open-PR (force-push needed, deferred).
- **#209/#210** backlog.
- If human brings new feature/bug: run Feature Mode (F1–F7) per `workflows/feature.lobster`.

**Step 4 — STANDING CONSTRAINTS (survive session clear):**
- Do NOT close #429 (DEC-029, human-deferred).
- All fixes through full VSDD Feature Mode pipeline (except quick-dev-route for test-hygiene micro-fixes: no production src/ code, 1-file diff, no BC impact — PR + pr-reviewer + CI gate only).
- Fork-release-ops workflows INERT by default — enablement blocked on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE (HIGH) in Drift Items.
- E2E-PG-4, SEC-001 LOW deferrals remain open.
- LESSON-F1-SIBLING-CASE: next Feature Mode F1 MUST enumerate sibling control-char/invariant cases at any normalization chokepoint.
- LESSON-CENTRALIZATION-AC-GREP: centralization ACs must use enumeration or multiline-aware scanning, never single-line grep negation.
- LESSON-CITATION-SIBLING-PROPAGATION: grep ALL sibling occurrences when removing any misattributed external-tracker citation.

Durable follow-ups: see Drift Items section.

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #525 | fix: list_comments anti-stall guard (CR-001) + cache write-error alignment (CR-007) | **MERGED** (PR #531 → develop @ 6f24748, 2026-06-17; auto-closed) | MED | LESSON-CITATION-SIBLING-PROPAGATION codified. F6 1853/0 mut 6/6. F7 5/5. |
| #526 | fix: 24-site JSON-render unification (CR-002) | **MERGED** (PR #527 → develop @ d56dcfc, 2026-06-17; auto-closed) | MED | LESSON-CENTRALIZATION-AC-GREP codified. F6 1309/0 mut 5/5. F7 5/5. |
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | #387: deferred; force-push needed. |
| #209/#210 | (backlog) | OPEN | — | |
| #520 | ci: opt-in release ops (fork-friendly) | MERGED @ 2cb219b (develop). Inert by default. | LOW | Enablement decision PENDING — see DEC-104 + research file. |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-027..119 + archived phase rows + archived drift items + archived closed issues | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
| Maintenance sweep 2026-06-17 session review | `maintenance/2026-06-17/session-review.md` |
