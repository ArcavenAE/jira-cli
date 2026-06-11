---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-11T08:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "description-leading-dash cycle CLOSED + MERGED — PR #496 squash-merged → develop @ 45ceae6 (2026-06-11). allow_hyphen_values on 7 free-text write args. BC 594. NFR 41. Stories 67. No active worktrees."
current_cycle: "cycle-001"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "15bf305"
activation_version: "v0.5.0-dev.11"
---
<!-- SIZE BUDGET: <200 lines. Historical content → cycle files. Run /vsdd-factory:compact-state if over 200. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-11 — description-leading-dash cycle (PR #496 @ 45ceae6) CLOSED + MERGED. allow_hyphen_values on 7 write args. BC 594. NFR 41. Stories 67. No active worktrees. |
| **Current Phase** | Phase 3 — TDD Implementation IN PROGRESS — Feature Mode active. BC 594. NFR 41. Stories 67. |
| **Next Phase** | Phase 4: Holdout Evaluation (not started) |
| **Activation HEAD** | 15bf305 (v0.5.0-dev.11) — develop HEAD now 45ceae6 |

## Phase Progress

| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| 0: Codebase Ingestion | COMPLETE | 2026-05-04 | Phase A+B+B.5+B.6+C APPROVED | |
| 1: Spec Crystallization | COMPLETE | 2026-05-04 | PASSED — DEC-006/007/008 | |
| 1d: Adversarial Spec Review | COMPLETE — 3/3 CONVERGED Pass 28 | 2026-05-04 | 3/3 FULL CONVERGENCE | 30→15→9→5→10→5→4→3→4→0→2→0→3→0→2→0→3→0→3→5→3→4→5→5→5→2→0→0→0 |
| 2: Story Decomposition | COMPLETE | 2026-05-06 | 31 stories; F1–F7 COMPLETE | 2-adv: CONVERGED Pass 13 CLEAN; 14→5→5→5→4→5→4→4→4→1→0→1→0 |
| Phase 2 gate | APPROVED | 2026-05-07 | APPROVED by human | |
| 3: TDD Implementation | IN_PROGRESS — Feature Mode active | — | Wave 0/1/2/3 ALL COMPLETE (32/32) | Wave adversarial: GATE-CLOSED 2026-05-08; Feature Mode ongoing |
| Pre-#471 ADF era (issues #110..#493, 18 cycles) | ALL CYCLE CLOSED + MERGED | 2026-05-11..2026-06-10 | F1–F7 each | develop progressed 15bf305→8b639c1. BC 583→593. See `cycles/cycle-001/burst-log.md` "Archived Phase Progress Rows". |
| GFM task lists → ADF (issue #471 / BC-7.2.010) | **CYCLE CLOSED + MERGED** | 2026-06-11 | F1–F7 ALL COMPLETE — CONVERGED | PR #494 → develop @ 4c9b069. BC 594 (+1). EC-17. 210 adf::tests; 1746/0; 97.3% mutation kill. F5: 16-pass adversary; F6: proptest 512 cases (found 17th bug). DEC-067/068/069/070/071. |
| ADF E2E coverage loop-back (#471/#474/#483/#489) | **CYCLE CLOSED + MERGED** | 2026-06-11 | CYCLE CLOSED | PR #495 → develop @ bfb723f. 5 gated live E2E tests. NO src change. BC 594 unchanged. First live-verify pending (nightly e2e.yml). |
| CLI leading-dash values (issue #471 e2e / description-leading-dash) | **CYCLE CLOSED + MERGED** | 2026-06-11 | F1–F7 ALL COMPLETE — CONVERGED | PR #496 → develop @ 45ceae6. `allow_hyphen_values = true` on 7 free-text write args. BC 594 unchanged. +17 hermetic parse tests (tests/cli_smoke.rs, 44 total). F5: 8 passes / 3-clean-pass CONVERGED. F6: 1763/0, clippy/fmt/deny clean, mutation zero-in-scope. F7: 5-dimension consistency CLEAN. DEC-072. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->

| Step | Agent | Status | Output |
|------|-------|--------|--------|
| #473 bare-URL autolink E2E — PR #493 → develop @ 8b639c1 (2026-06-10). test_e2e_markdown_bare_url_produces_link_mark. PG-REVIEW-1 + PG-E2E-1 codified. | state-manager | CYCLE CLOSED + MERGED | BC 593 / NFR 41 / Stories 66. |
| #471 GFM task lists → ADF — PR #494 → develop @ 4c9b069 (2026-06-11). BC-7.2.010 + EC-17. 1746/0. Worktree cleaned. | state-manager | CYCLE CLOSED + MERGED | BC 594 / NFR 41 / Stories 67. develop HEAD: 4c9b069. |
| ADF E2E loop-back — PR #495 → develop @ bfb723f (2026-06-11). 5 gated tests. Worktree cleaned. #475 partially addressed. | state-manager | CYCLE CLOSED + MERGED | BC 594 / NFR 41 / Stories 67. develop HEAD: bfb723f. |
| description-leading-dash — PR #496 → develop @ 45ceae6 (2026-06-11). allow_hyphen_values on 7 write args. +17 hermetic parse tests. F5 8-pass converged. Worktree cleaned. DEC-072. | state-manager | CYCLE CLOSED + MERGED | BC 594 / NFR 41 / Stories 67. develop HEAD: 45ceae6. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-063 | Phase 0/1/2 + Wave + Feature Mode decisions (multiple issues + dev releases). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-02 | archived |
| DEC-064..DEC-066 | JSM E2E expansion, S-JSM-E2E-1 AC orphans, JSM resolution enforcement (ADR-0015). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` "Archived Decisions DEC-064..066" | Phase 3 / 2026-06-02..03 | archived |
| DEC-067 | 2026-06-10: #471 F1 gate — (1) localId counter-based strings; (2) mixed list → whole container promoted to taskList; (3) taskItem inline-only, UPPERCASE TODO/DONE; (4) live sandbox deferred. Research: `.factory/research/issue-471-adf-tasknode-shape.md`. | F1 human gate | Phase 3 / #471 | 2026-06-10 |
| DEC-068 | 2026-06-10: #471 F2 CONVERGED. BC-7.2.010 authored (593→594). 8-pass adversary (P5/6/7/8 clean). Blockquote dependency closed at spec time via pulldown-cmark 0.13.3 source-read. Human gate APPROVED. | F2 convergence | Phase 3 / #471 | 2026-06-10 |
| DEC-069 | 2026-06-10: #471 F3 CONVERGED. S-471 (67 stories), 18 ACs, 19 named tests. Key catches: stale count; taskItem structural-empty branch; EC-16 flatten ordering; DFS-preorder localId (AC-018). PG-471-1 → lessons.md. | F3 story decomposition | Phase 3 / #471 | 2026-06-10 |
| DEC-070 | 2026-06-10: #471 F4+F5 CONVERGED — 16 adversary passes / 8 fix iterations. ~15 genuine bugs (MULTIPLE CRITICAL invalid-ADF Jira-400). Root fixes: typed EndResult::WithHoists; reclassify_as_task_list / split_stray_blocks_end_result helpers; recursive normalize nesting; tight/loose symmetry. Systemic guard: 100-input structural-validity corpus + proptest. LESSON: structural-validity corpus + proptest are load-bearing guards. | F4+F5 convergence | Phase 3 / #471 | 2026-06-10 |
| DEC-071 | 2026-06-10: #471 F6 — proptest found 17th bug (panel-wrapped plain-item → invalid taskList>taskList; tuple-lead violation). Mutation: 97.3% (72/74; 2 documented equivalent). SEC-002 fixed → debug_assert. Full suite 1746/0. | F6 hardening | Phase 3 / #471 | 2026-06-10 |
| DEC-072 | 2026-06-11: description-leading-dash — trivial-scope clap ergonomics fix. Scope expanded from `--description` to all 7 free-text write-command args (`issue create/edit --summary`+`--description`, `issue comment` positional message, `issue remote-link --title`, `worklog add --message`) with human approval at F4→F5 boundary. Adjacent F5 findings F-01 (`--summary`) and F-02 (worklog `--message`) RESOLVED in this PR (not deferred). `issue comment` + `remote-link --title` added during F5 for completeness. F5-P5-01 (flag-binding pinned only in nightly e2e) RESOLVED by adding 17 hermetic parse tests to tests/cli_smoke.rs. F-H1 (F1↔implementation scope-reconciliation manual, no automated gate) DEFERRED — handled manually this cycle; revisit if recurs 3+ times. | Feature Mode / description-leading-dash | Phase 3 | 2026-06-11 |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|---------------|

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|

## Drift Items

<!-- OPEN and actively-watched items only. DEFERRED/LOW archived to cycles/cycle-001/burst-log.md "Archived Drift Items". -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| OQ-5 | CLAUDE.md NFR-O-N stale | `auth status --output json` documents JSON arm but src/cli/auth/status.rs has none. File GitHub issue before next auth touch. | LOW | OPEN — doc drift |
| E2E-PG-4 | E2E coverage gap | All label/link/priority/worklog/unassign/issueType/assign DONE. REMAINING: remote-link round-back (blocked: no `jr remote-link read`). | LOW | OPEN — 1 sub-gap |
| DRIFT-331-PAGINATION | get_issue_types_for_project pagination | Reimplements offset pagination inline; target: reuse OffsetPage<T>. Deferred per human 2026-06-01. | LOW | OPEN — tracking |
| PG-A | check-bc-cumulative-counts.sh misses README.md | Extend guard to cover README.md grand-total line. | LOW | OPEN — deferred 2026-06-08 |
| DRIFT-README | .factory/specs/prd/README.md Document Map stale | Grand total 573 vs canonical 587; multiple per-section drifts. Pre-existing ~13 cycles. Dedicated reconciliation pass needed. | LOW | OPEN — deferred 2026-06-08 |
| DEFER-469 | Dependabot PR #469 (gitleaks-action 3.0 MAJOR) | Intentional hold — major-version GitHub Action; extended soak. Revisit at maintainer discretion. | LOW | OPEN — intentional hold |
| SEC-001 | CWE-674 deep-nesting recursion in adf.rs | Uncontrolled recursion in normalize_list_item_content / normalize_blockquote_content / assign_local_ids_walk / render_node. File-wide sweep target. | LOW | OPEN — deferred 2026-06-10 |
| DEFERRED-ADF-E2E | ADF live E2E remaining gaps | #470 (listItem-normalization live test) + #475 Gap 1 (ADF→text read path via `issue view` human mode). #473/#471/#474/#483/#489 DONE. `test_e2e_markdown_task_list_produces_task_items` UNBLOCKED by PR #496 (allow_hyphen_values fix). Verify against next nightly/post-merge e2e run. | LOW | PARTIALLY RESOLVED — #470+#475 Gap 1 remain; task-list E2E UNBLOCKED |
| F-H1 | F1↔F4 scope-reconciliation manual | F1→F4 handoff has no enforced consistency gate; scope expansion can silently supersede F1 doc. Handled manually this cycle (DEC-072). Revisit if recurs 3+ times. Detail: cycles/cycle-001/lessons.md F-H1. | LOW | DEFERRED — revisit at 3+ recurrences |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-11] description-leading-dash CLOSED + MERGED — PR #496 → develop @ 45ceae6. allow_hyphen_values on 7 write args. F5: 8 passes / 3-clean-pass CONVERGED. BC 594 / NFR 41 / Stories 67 UNCHANGED. No active worktrees.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-11 |
| **Position** | **description-leading-dash CYCLE CLOSED + MERGED.** PR #496 squash-merged → develop @ 45ceae6 (2026-06-11). Branch fix/cli-leading-dash-values deleted; worktree removed. Fix: `allow_hyphen_values = true` on 7 free-text write-command clap args in `src/cli/mod.rs` (`issue create/edit --summary`+`--description`, `issue comment` positional message, `issue remote-link --title`, `worklog add --message`). Fixes #471 task-list creation failure surfaced by nightly e2e run 27318191693. Scope expanded from `--description` to all 7 args with human approval. F5: 8 passes / 3-clean-pass CONVERGED. F6: 1763/0, clippy/fmt/cargo-deny clean, mutation zero-in-scope. F7: 5-dimension consistency CLEAN. +17 hermetic parse tests in tests/cli_smoke.rs (44 total). F5-P5-01 RESOLVED (hermetic tests added). F-H1 DEFERRED (manual scope-reconciliation; threshold 3+). DEC-072. `test_e2e_markdown_task_list_produces_task_items` UNBLOCKED — verify on next nightly e2e run. |
| **develop HEAD** | origin/develop = **45ceae6**. BC 594. NFR 41. Stories 67. No active worktrees. |
| **Convergence counter** | BC: **594**. NFR: **41**. Stories: **67**. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. No active worktrees. |
| **Next / Pending** | (1) NIGHTLY E2E LIVE-VERIFY: task-list E2E (`test_e2e_markdown_task_list_produces_task_items`) UNBLOCKED by PR #496; also verify 5 ADF E2E tests (EC-17/subsup/panel) from PR #495. (2) #475 OPEN: Gap 1 (ADF→text read path via `issue view` human mode) + #470 listItem-normalization live test. (3) SEC-001 (CWE-674 deep-nesting recursion in adf.rs, LOW) deferred. (4) Deferred: #400 Story B + engine items; #372 cargo-mutants. (5) Standing: do NOT close #429 (DEC-029 human deferral); #492 OPEN; OQ-5 + E2E-PG-4 remote-link open; DEFER-469 gitleaks 3.0 hold. F-H1 deferred drift item logged. |
| **Resume prompt** | `Read .factory/STATE.md. DATE: 2026-06-11. POSITION: description-leading-dash CLOSED + MERGED. PR #496 → develop @ 45ceae6. allow_hyphen_values on 7 write args; +17 hermetic parse tests (tests/cli_smoke.rs 44 total). BC 594 / NFR 41 / Stories 67 UNCHANGED. No active worktrees. DEC-072. F-H1 DEFERRED (logs: cycles/cycle-001/lessons.md). F5-P5-01 RESOLVED. DEFERRED-ADF-E2E: task-list E2E UNBLOCKED by this fix; verify on next nightly. #475 OPEN (Gap 1 + #470 remain). STANDING: do NOT close #429 (DEC-029); #492 OPEN; OQ-5 open; E2E-PG-4 remote-link open; DEFER-469 hold; SEC-001 LOW deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #492 | fix(adf): block-HTML raw-\n invariant | **OPEN** — needs-sandbox. Filed 2026-06-09. Raw-\n in literal-text paragraphs may not survive Jira REST round-trip. | LOW | No active cycle. |
| #475 | ADF read-path / remaining E2E gaps | **OPEN** — Gap 1 (ADF→text `issue view` human mode) + #470 listItem live-E2E remain. PR #495 addressed #471/#474/#483/#489. | LOW | Partial. |
| #210 | (backlog) | OPEN | — | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | Filed 2026-05-22. |
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | #387: deferred; force-push needed. |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-027..066 + archived phase rows + archived drift items + archived closed issues | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
