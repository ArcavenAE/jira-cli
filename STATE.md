---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-13T00:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "2026-06-13: Windows-build F3 story-decomposition DRAFTS created (S-WIN-1..6; STORY-INDEX 68→74 v1.4.37 incl. F3-audit reconcile) and committed to factory-artifacts. F3 adversarial story-convergence gate NOT yet run — that is the resume step. BC 597 / NFR 42 / ADR 16 / Stories 74 (PROVISIONAL, pending adv-review). develop HEAD 587206e. PR #504 OPEN (ADR-0003 docs)."
current_cycle: "cycle-001"
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "587206e"
activation_version: "v0.6.0-dev.1"
---
<!-- SIZE BUDGET: <200 lines. Historical content → cycle files. Run /vsdd-factory:compact-state if over 200. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-12: Windows-build feature F1+F2 COMPLETE + F2 human gate APPROVED. BC 597 (+3) / NFR 42 (+1) / ADR 16 (+1). Entering F3. PR #504 OPEN (ADR-0003 docs). |
| **Current Phase** | Phase 3 — TDD Implementation IN PROGRESS — Feature Mode active. BC 597. NFR 42. ADR 16. Stories 68. |
| **Next Phase** | Phase 4: Holdout Evaluation (not started) |
| **Activation HEAD** | 587206e (v0.6.0-dev.1; v0.5.0 STABLE shipped 2026-06-12) |

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
| ADF E2E coverage loop-back (#471/#474/#483/#489) | **CYCLE CLOSED + MERGED** | 2026-06-11 | CYCLE CLOSED | PR #495 → develop @ bfb723f. 5 gated live E2E tests. NO src change. BC 594 unchanged. Live-verified GREEN — e2e run 27352373680 (89/0) on develop @ 45ceae6, 2026-06-11. |
| CLI leading-dash values (issue #471 e2e / description-leading-dash) | **CYCLE CLOSED + MERGED** | 2026-06-11 | F1–F7 ALL COMPLETE — CONVERGED | PR #496 → develop @ 45ceae6. `allow_hyphen_values = true` on 7 free-text write args. BC 594 unchanged. +17 hermetic parse tests (tests/cli_smoke.rs, 44 total). F5: 8 passes / 3-clean-pass CONVERGED. F6: 1763/0, clippy/fmt/deny clean, mutation zero-in-scope. F7: 5-dimension consistency CLEAN. DEC-072. |
| ADF E2E read-path coverage (issue #475) | **CYCLE CLOSED + MERGED** | 2026-06-11 | F1–F7 ALL COMPLETE — CONVERGED | PR #499 → develop @ 418a392e. Test-only (no src change). BC 594 / NFR 41 / Stories 68 unchanged. DEC-073/074/075/076. |
| Windows build (x86_64-pc-windows-msvc) | **F3 DRAFTS COMPLETE — adv-convergence PENDING** | 2026-06-12 (F2) / 2026-06-13 (F3 drafts) | F3 adversarial story-convergence gate NOT yet run (3 clean passes required) | BC 594→597 (+3), NFR 41→42 (+1), ADR 15→16 (+1). Stories 68→74 PROVISIONAL (pending adv-review). F2 adversary: 14 passes, 3-clean-pass convergence P12/13/14. DEC-079. PR #504 OPEN. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->

| Step | Agent | Status | Output |
|------|-------|--------|--------|
| #475 ADF E2E read-path — F5–F7 CONVERGED + PR #499 squash-merged → develop @ 418a392e (2026-06-11). 5-dimension delta convergence + full-tree regression all green. CI 11/11 green, security APPROVE, code review APPROVE 0-blocking, full cargo test clean, cargo deny ok. Fresh-context F7 consistency audit CONSISTENT. Input-drift: no #475 drift (11 pre-existing unrelated). Spec-example synced multi-word→single-token (spec v1.3.10). DEC-076. Process-gap checklist (F-1b, O1-TABLE-ASSERT, DEC-075 LESSON) codified in lessons.md. | state-manager | CYCLE CLOSED + MERGED | BC 594 / NFR 41 / Stories 68. develop HEAD: 418a392e. No active worktrees. |
| v0.5.0-dev.14 dev release: PR #500 (Cargo.toml→dev.14 + CHANGELOG finalized, 31 commits since dev.13) squash-merged → develop @ a0f45cc; tag v0.5.0-dev.14 pushed → release.yml success (run 27383452695, 4/4 platform builds); GitHub pre-release published 2026-06-11. | devops-engineer | RELEASE PUBLISHED | BC 594 / NFR 41 / Stories 68. develop HEAD: a0f45cc. |
| v0.5.0 STABLE released 2026-06-12T15:27:54Z: PR #501 "chore: release v0.5.0" (release/v0.5.0) squash-merged → main. Tag v0.5.0 pushed. GitHub Release v0.5.0 graduated to 'Latest'. First STABLE shipping full ADF markdown-conversion feature set + BC-3.2.013 resolution enforcement (breaking). DEC-078. | state-manager | STABLE RELEASED | BC 594 / NFR 41 / Stories 68. main HEAD: v0.5.0. |
| develop bumped to 0.6.0-dev.1 2026-06-12T15:31:57Z: PR #502 "chore: sync main → develop + bump to v0.6.0-dev.1" squash-merged → develop @ 587206e. Cargo.toml version 0.6.0-dev.1. 0.6.0 dev cycle open. No active worktrees. DEC-078. | state-manager | 0.6.0 CYCLE OPEN | BC 594 / NFR 41 / Stories 68. develop HEAD: 587206e. |
| INTERRUPTED-SESSION RECOVERY 2026-06-13: Windows-build F3 story drafts (S-WIN-1..6, ~1997 LOC) + STORY-INDEX 68→74 (v1.4.37, F3-audit reconcile fixed Σ=58≠74: added cycle-3 wave-plan row + corrected feature-followup 26→39) + bc-6/architecture-delta/ADR-0016 edits committed to factory-artifacts for durability. F3 adversarial story-convergence (3 clean passes) NOT yet run — resume there. | state-manager | DURABLE CHECKPOINT — F3 adv-review PENDING | BC 597 / NFR 42 / Stories 74 PROVISIONAL. develop HEAD 587206e. No active worktrees. |

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
| DEC-073 | 2026-06-11: #475 F1+F2 — test-only ADF E2E read-path coverage. F1 gate: ONE story, RENAME misnomer test (human overrode annotate-only), AC-3 (comments read path) IN SCOPE. F2 CONVERGED — fresh adversary caught CRITICAL (AC-3 negative assertions were guaranteed live-failure: `adf_to_text` re-emits markdown, `src/adf.rs:2255`). Research-validated all 5 external Jira-API assumptions (`developer.atlassian.com` 2026-06-11): GET issue v3 returns ADF object; `listItem` forbids `blockquote` child (normalization required); Jira silently rewrites ADF server-side → spec mandates structural/rendered assertions not exact-tree snapshots. No BC/NFR change (594/41). Spec v1.3.6→1.3.9. | Feature Mode / #475 ADF E2E read-path | Phase 3 | 2026-06-11 |
| DEC-074 | 2026-06-11: #475 F3 CONVERGED. ONE story S-475-adf-e2e-readpath (Stories 67→68), 4 ACs traced to BC-7.2.003/004/006, leaf node. Fresh adversary caught F1 (comfy-table cell-wrap fragility — multi-word AC-1 substring assertions could break on cell wrap) → fixed via single-token assertions; F2 (STORY-INDEX prose count drift 67/32) → fixed. R2 0/0/0 converged. Process-gap O1 (no shared assert_table_contains/de-wrap helper for human-mode E2E stdout — this is the first such test) DEFERRED as drift item O1-TABLE-ASSERT, single-token approach sufficient this cycle; revisit if recurs. | Feature Mode / #475 F3 story decomposition | Phase 3 | 2026-06-11 |
| DEC-075 | 2026-06-11: #475 F4 CONVERGED. Per-story Step-4.5 fresh-context review caught HIGH false-green: new test was async, silently escaping the gate-guard meta-test (matched only `fn test_`). Root-fix: de-async (no .await existed). Hardened guard to recognize `async fn test_` (F-1b process-gap). LESSON: implementer hermetic 'PASS' on a guard can be a false green when the guard's own pattern excludes the new construct — fresh-context review on the diff is load-bearing. Demo: justified adapted-skip for test-only no-behavior-change story. | Feature Mode / #475 F4 delta implementation | Phase 3 | 2026-06-11 |
| DEC-076 | 2026-06-11: #475 F7 CONVERGED + MERGED (PR #499 → develop @ 418a392e). 5-dimension delta convergence + full-tree regression all green (CI 11/11, security APPROVE, code review APPROVE 0-blocking, full cargo test clean, cargo deny ok). Fresh-context F7 consistency audit CONSISTENT (counts agree across 8 surfaces; CLAUDE.md no change). Input-drift: no #475 drift (11 pre-existing cycles/bookkeeping stale, unrelated). Post-merge: spec-example synced multi-word→single-token (spec v1.3.10). Demo: adapted-skip (test-only, no production behavior change). Issue #475 stays CLOSED (no Closes keyword). Cycle-closing checklist SATISFIED: F-1b FIXED + codified; O1-TABLE-ASSERT DEFERRED (justified); DEC-075 LESSON codified. | Feature Mode / #475 F7 delta convergence + merge | Phase 3 | 2026-06-11 |
| DEC-077 | 2026-06-11: v0.5.0-dev.14 dev release cut via branch+PR (#500) per release-workflow rule (no direct develop commits). Tag-triggered release.yml (run 27383452695) built 4 targets (x86_64/aarch64 × darwin/linux) + sha256 checksums + published GitHub pre-release. First release to ship the full ADF markdown-conversion feature set (task lists/panel/subsup/bare-URL/footnotes/block-HTML/listItem-normalization) + BC-3.2.013 resolution enforcement (breaking) + gitleaks-action v3 MAJOR. develop HEAD a0f45cc. | Release workflow | Phase 3 | 2026-06-11 |
| DEC-078 | 2026-06-12: v0.5.0 STABLE released (PR #501 → main @ 2026-06-12T15:27:54Z; tag v0.5.0; GitHub Release graduated to 'Latest'). First STABLE release shipping full ADF markdown-conversion feature set + BC-3.2.013 proactive resolution enforcement (breaking; ADR-0015). Develop then bumped to 0.6.0-dev.1 via PR #502 (squash-merged → develop @ 587206e; 2026-06-12T15:31:57Z). 0.6.0 dev cycle open. BC 594 / NFR 41 / Stories 68 unchanged. | Release milestone | Phase 3 | 2026-06-12 |
| DEC-079 | 2026-06-12: Windows-build (x86_64-pc-windows-msvc) F1+F2 COMPLETE, F2 human gate APPROVED. F1 locked decisions: target x86_64-pc-windows-msvc only (aarch64 deferred); artifact .zip; add Windows job to ci.yml (full regression); idiomatic %APPDATA%(config)/%LOCALAPPDATA%(cache) via #[cfg(windows)]; keyring windows-native (Windows Credential Manager); OAuth embedded-creds smoke step gated off on Windows v1; ADR-0016 recorded. F2 artifacts: ADR-0016 (.factory/architecture/adr/0016-windows-build-target.md + adr-index); architecture-delta (.factory/cycles/cycle-001/windows-build/architecture-delta.md); 3 NEW BCs (BC-6.1.014 Windows config path, BC-6.2.016 Windows cache path, BC-6.2.017 JR_CONFIG_DIR/JR_CACHE_DIR debug path seam) + 1 UPDATED (BC-6.2.004 platform-conditional cache root); 1 NEW NFR (NFR-P-W1 Supported Platforms). Counts: BC 594→597 (+3), NFR 41→42 (+1), ADR 15→16 (+1). F2 adversary: 14 passes / 6→5→1→2→2→1→0→1→0→0→0→0→0→0 — 3-clean-pass convergence (P12/13/14). Fresh-context consistency audit: CONSISTENT. Research-validated C1–C7 (Perplexity + primary sources, 2026-06-12): C4 PARTIALLY REFUTED → rationale corrected (rustls-platform-verifier not webpki-roots); C2 corrected (no colon sanitization needed). ADR-0003 docs fix PR #504 OPEN (branch docs/adr-0003-rustls-0.13-platform-verifier, commit 15dc7da). F4 obligations: O-3 (CANONICAL-COUNTS Unix-only cache path), O-4 (JR_CONFIG_DIR/JR_CACHE_DIR in CLAUDE.md), ADR-0016↔ADR-0003 cross-ref to add during F4. Process-gap follow-ups: (1) no CI guard for inline-PROSE BC counts; (2) no NFR cross-surface count guard; (3) 3rd JR_* doc-fallout recurrence. | Windows-build F1+F2 | Phase 3 | 2026-06-12 |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|---------------|
| F4 per-AC video demo (#475) | Yes — adapted | Test-only story, NO production behavior change (adds gated E2E coverage for existing converters). No offline-runnable live demo; evidence = offline hermetic verification (compile + gate guards + full suite green + --list) and nightly e2e.yml live run. Same handling as prior test-only E2E cycles (#493/#495). |

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
| SEC-001 | CWE-674 deep-nesting recursion in adf.rs | Uncontrolled recursion in normalize_list_item_content / normalize_blockquote_content / assign_local_ids_walk / render_node. File-wide sweep target. | LOW | OPEN — deferred 2026-06-10 |
| DEFERRED-ADF-E2E | ADF live E2E remaining gaps | #470 (listItem-normalization live test) DELIVERED via PR #499 (AC-2). #475 Gap 1 (read-path adf_to_text) DELIVERED via PR #499 (AC-1+AC-3+AC-4). #473/#471/#474/#483/#489 DONE. task-list E2E VERIFIED GREEN — e2e run 27352373680 (89/0), 2026-06-11. All tracked sub-gaps now DONE. | LOW | FULLY RESOLVED — all sub-gaps delivered (PR #499 @ 418a392e). No remaining items. |
| F-H1 | F1↔F4 scope-reconciliation manual | F1→F4 handoff has no enforced consistency gate; scope expansion can silently supersede F1 doc. Handled manually this cycle (DEC-072). Revisit if recurs 3+ times. Detail: cycles/cycle-001/lessons.md F-H1. | LOW | DEFERRED — revisit at 3+ recurrences |
| O1-TABLE-ASSERT | No shared de-wrap/assert_table_contains helper for human-mode (table) E2E stdout assertions | S-475 is the first human-mode E2E test; mitigated via single-token assertions (wrap-safe). Codify a shared helper before more human-mode E2E tests land. DEC-074. | LOW | DEFERRED — revisit if recurs |
| WIN-O-3 | CANONICAL-COUNTS "Cache Types" prose path is Unix-only | Add Windows `%LOCALAPPDATA%\jr\v1\<profile>\` path entry during F4 implementation. F4 obligation from DEC-079. | LOW | OPEN — F4 obligation |
| WIN-O-4 | CLAUDE.md Windows paths not documented | Add JR_CONFIG_DIR/JR_CACHE_DIR to CLAUDE.md "AI Agent Notes" JR_* table; update cache/config path docs for Windows. F4 obligation from DEC-079. | LOW | OPEN — F4 obligation |
| WIN-PG-1 | No CI guard for inline-PROSE BC counts | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. Codify or justify deferral before cycle close. | LOW | OPEN — process-gap |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-13] Windows-build F3 drafts created + made durable; adversarial story convergence PENDING; Stories 74 PROVISIONAL.** Prior: [2026-06-12] Windows-build F1+F2 COMPLETE — F2 human gate APPROVED. BC 597 (+3) / NFR 42 (+1) / ADR 16 (+1) / Stories 68 (unchanged). F2 adversary: 14 passes / 6→5→1→2→2→1→0→1→0→0→0→0→0→0 (3-clean-pass P12/13/14). DEC-079.

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-13 |
| **Position** | **Windows-build Feature Mode F3 story-decomposition DRAFTS COMPLETE but NOT adversarially converged.** 6 story files S-WIN-1..S-WIN-6 created (status: ready); STORY-INDEX bumped 68→74 (v1.4.37) including an F3-audit reconcile (fixed wave-count Σ=58≠74 by adding cycle-3 row + correcting feature-followup 26→39); bc-6-config-cache / architecture-delta / ADR-0016 touched. ALL committed to factory-artifacts as a durability checkpoint. **NEXT STEP: run F3 adversarial story convergence (3 clean passes minimum) via the adversary agent on the 6 S-WIN stories + STORY-INDEX, then F3 human gate.** No source changes on develop yet (still 587206e). |
| **develop HEAD** | origin/develop = **587206e**. activation v0.6.0-dev.1. BC **597**. NFR **42**. ADR **16**. Stories **74** (PROVISIONAL — pending F3 adv-review). No active worktrees. |
| **Convergence counter** | BC: **597**. NFR: **42**. ADR: **16**. Stories: **74** (PROVISIONAL — pending F3 adv-review). jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. No active worktrees. |
| **Next / Pending** | (1) Windows-build: run F3 adversarial story convergence on S-WIN-1..6 + STORY-INDEX (3 clean passes), then F3 human gate; only then mark Stories 74 authoritative. (2) PR #504 OPEN (ADR-0003 docs) — do NOT mark merged. (3) F4 obligations WIN-O-3 + WIN-O-4 (in Drift Items). (4) SEC-001 LOW deferred. (5) Standing: do NOT close #429 (DEC-029); #492 OPEN; OQ-5; E2E-PG-4 remote-link; F-H1 DEFERRED; O1-TABLE-ASSERT DEFERRED. |
| **Resume prompt** | `Read .factory/STATE.md. DATE: 2026-06-13. POSITION: Windows-build F3 drafts created + committed, adversarial story convergence is the next step. BC 597 / NFR 42 / ADR 16 / Stories 74 PROVISIONAL (pending F3 adv-review). develop HEAD: 587206e (v0.6.0-dev.1; no source changes). PR #504 OPEN (ADR-0003 docs; do NOT mark merged). F4 obligations: WIN-O-3 + WIN-O-4 in Drift Items. STANDING: do NOT close #429 (DEC-029); #492 OPEN; OQ-5; E2E-PG-4 remote-link open; SEC-001 LOW deferred; F-H1 DEFERRED; O1-TABLE-ASSERT DEFERRED. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #492 | fix(adf): block-HTML raw-\n invariant | **OPEN** — needs-sandbox. Filed 2026-06-09. Raw-\n in literal-text paragraphs may not survive Jira REST round-trip. | LOW | No active cycle. |
| #475 | ADF read-path / E2E coverage | **CLOSED — CYCLE CLOSED + MERGED** (PR #499 → develop @ 418a392e, 2026-06-11). Gap 1 (read-path adf_to_text via issue view/comments) DELIVERED. Gap 2 (#470 listItem live assert) DELIVERED. Issue was already CLOSED; no Closes keyword in PR. | LOW | CYCLE CLOSED. DEFERRED-ADF-E2E: both sub-gaps now DONE — see drift item update. |
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
