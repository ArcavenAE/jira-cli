---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-14T04:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "2026-06-13: S-WIN-1 (per-OS #[cfg(windows)] AppData path resolution) implementation CONVERGED — Step-4.5 3-clean (after extracting pure fallback helpers + un-gating fallback tests + seam-scrub). macOS cargo test green (907); cross-compile zero Rust errors; clippy/fmt clean. Branch feat/win-1-per-os-path-resolution @ db175c6. Next: S-WIN-1 PR. develop 2b13596."
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
| **Last Updated** | 2026-06-13: S-WIN-3 (keyring windows-native + 17-entry deny skip set) MERGED → develop @ 2b13596 via squash PR #506. 2/6 Windows-build stories shipped. DEC-087. |
| **Current Phase** | Phase 3 — TDD Implementation IN PROGRESS — Feature Mode active. BC 597. NFR 42. ADR 16. Stories 74 (authoritative). |
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
| Windows build (x86_64-pc-windows-msvc) | **F4 IN PROGRESS — S-WIN-2 + S-WIN-3 MERGED (2/6); S-WIN-1 impl CONVERGED (awaiting PR); Wave 2 (S-WIN-4, S-WIN-6 remain)** | 2026-06-12 (F2) / 2026-06-13 (F3 APPROVED + S-WIN-2 MERGED + S-WIN-3 MERGED) | F3 human gate APPROVED 2026-06-13; DEC-082 RE-CONVERGED + RE-AFFIRMED 2026-06-13 (DEC-084) | 8-pass F3 trajectory 6→5→2→2→2→0→0→0; S-WIN-3 Step-4.5 3-clean; Stories 68→74 authoritative; ADR-0016 Decisions 2/3/5b amended; DEC-079..088. PR #504 MERGED (develop a7da775). S-WIN-2 MERGED PR #505 (develop 1b84feb). S-WIN-3 MERGED PR #506 (develop 2b13596). S-WIN-1 impl CONVERGED @ db175c6. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->

| Step | Agent | Status | Output |
|------|-------|--------|--------|
| S-WIN-2 PR #505 squash-MERGED → develop @ 1b84feb (2026-06-13T16:55:26Z); remote branch feat/win-2-config-cache-dir-seam deleted; worktree cleanup dispatched. First of 6 Windows-build stories shipped. develop a7da775→1b84feb. | Agent pr-manager+state-manager | S-WIN-2 MERGED (1/6) — S-WIN-3 next | develop @ 1b84feb. BC 597/Stories 74. |
| S-WIN-3 PR #506 created → develop (branch feat/win-3-keyring-windows-native, 4 commits). CI 11/11 PASS (incl. deny job all-target — validates 17 windows skips on ubuntu runner). AI PR review APPROVE 0-blocking. Security APPROVE 0 CRITICAL/HIGH (SEC-001 WCM inherent → doc follow-up; SEC-002 JR_SERVICE_NAME → follow-up story). PAUSED before merge per human pattern. | Agent pr-manager | S-WIN-3 PR #506 OPEN — READY TO MERGE (paused, human gate) | PR #506. CI 11/11. develop 1b84feb. Recommend squash-merge. |
| S-WIN-3 PR #506 squash-MERGED → develop @ 2b13596 (2026-06-13T18:27:29Z); remote branch feat/win-3-keyring-windows-native deleted; worktree cleanup dispatched. 2/6 Windows-build stories shipped (keyring windows-native + 17-entry deny skip set). develop 1b84feb→2b13596. | Agent pr-manager+state-manager | S-WIN-3 MERGED (2/6) — Wave 2 next | develop @ 2b13596. BC 597 / Stories 74. |
| S-WIN-1 F4 delivery: #[cfg(windows)] AppData branches (global_config_dir→%APPDATA%, cache_root→%LOCALAPPDATA%) + pure fallback helpers + 6 windows tests. Step-4.5 per-story CONVERGED (Pass1 clean; round found tautological-fallback-test + seam-scrub LOW → fixed via pure-helper extraction [db175c6]; final 3-clean, all 5 mutation classes killed). macOS cargo test 907 green; cross-compile zero Rust errors; clippy/fmt clean. No spec reconciliation needed. | Agent multi | S-WIN-1 CONVERGED — awaiting PR | Source on feat branch. develop 2b13596. BC 597 / Stories 74. |

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
| DEC-072 | 2026-06-11: description-leading-dash — trivial-scope clap ergonomics fix. Scope expanded from `--description` to all 7 free-text write-command args with human approval at F4→F5 boundary. F-H1 DEFERRED — handled manually; revisit if recurs 3+ times. | Feature Mode / description-leading-dash | Phase 3 | 2026-06-11 |
| DEC-073..076 | 2026-06-11: #475 ADF E2E read-path coverage — test-only story. F1+F2 CONVERGED (fresh adversary caught CRITICAL AC-3 negative assertion guaranteed live-failure). F3+F4 CONVERGED (async false-green caught; de-async fix + guard hardened). F7+MERGE PR #499 → develop @ 418a392e. See burst-log for detail. | Feature Mode / #475 | Phase 3 | 2026-06-11 |
| DEC-077 | 2026-06-11: v0.5.0-dev.14 dev release cut via branch+PR (#500). Tag-triggered release.yml built 4 targets + sha256. First release with full ADF feature set + BC-3.2.013 resolution enforcement. | Release workflow | Phase 3 | 2026-06-11 |
| DEC-078 | 2026-06-12: v0.5.0 STABLE released (PR #501 → main @ 2026-06-12T15:27:54Z; tag v0.5.0; graduated to 'Latest'). develop bumped to 0.6.0-dev.1 via PR #502 (develop @ 587206e). 0.6.0 dev cycle open. BC 594 / NFR 41 / Stories 68 unchanged. | Release milestone | Phase 3 | 2026-06-12 |
| DEC-079 | 2026-06-12: Windows-build F1+F2 COMPLETE, F2 human gate APPROVED. Locked: x86_64-pc-windows-msvc; artifact .zip; Windows ci.yml job; %APPDATA%/%LOCALAPPDATA% via #[cfg(windows)]; keyring windows-native; ADR-0016. BC 594→597 (+3), NFR 41→42 (+1), ADR 15→16 (+1). F2 adversary 14-pass 3-clean. Research-validated C1–C7 (C4 PARTIALLY REFUTED → rationale corrected). | Windows-build F1+F2 | Phase 3 | 2026-06-12 |
| DEC-080 | 2026-06-13: Windows-build F3 CONVERGED. 6 stories S-WIN-1..6 (Stories 68→74). 8-pass adversary, 3-clean P6/7/8 (6→5→2→2→2→0→0→0). F-WIN-F3-001 CRITICAL (Decision 3 false premise) + F-WIN-F3-003 MEDIUM (Decision 2 amended) fixed. | Feature Mode / Windows-build F3 | Phase 3 | 2026-06-13 |
| DEC-081 | 2026-06-13: PR #504 (ADR-0003 docs) MERGED → develop @ a7da775. S-WIN-2 F4 CONVERGED: TDD 7 tests (BC-6.2.017); 5-pass Step-4.5; dual-site #[cfg(debug_assertions)] gate verified; F-WIN2-C-102 fixed. Deferred F-WIN2-C-101 → S-WIN-5. | Feature Mode / Windows-build F4 / S-WIN-2 | Phase 3 | 2026-06-13 |
| DEC-082 | 2026-06-13: Pre-F4 research verification. 2 BLOCKERS: C-V2(b) REFUTED (windows-sys 0.60 deny skip REQUIRED); C-V3 PARTIALLY-CONFIRMED (Compress-Archive not zip). Corrections propagated to ADR-0016/arch-delta/S-WIN-3/4/6. Focused adversarial: 4 leaks found + fixed + grep-confirmed clean. LESSON: external primary-source verification before F4 on cross-platform/infra cycles. | Feature Mode / Windows-build F4 preflight | Phase 3 | 2026-06-13 |
| DEC-083 | 2026-06-13: Full-VSDD closure of DEC-082 spec change. Spec-steward governance v1.3.11; 3-clean adversarial re-convergence (A/B/C) on S-WIN-3/S-WIN-4. All CI count scripts green. F3 re-gate pending. | Feature Mode / Windows-build F3 re-convergence | Phase 3 | 2026-06-13 |
| DEC-084 | 2026-06-13: F3 re-gate RE-AFFIRMED by human after DEC-082/DEC-083 full-VSDD closure. Accepted: S-WIN-4 Compress-Archive; S-WIN-3 windows-sys 0.60 deny skip REQUIRED; corrections scoped to S-WIN-3/S-WIN-4 only. F3 CONVERGED with corrections folded in. | Feature Mode / Windows-build F3 re-gate | Phase 3 | 2026-06-13 |
| DEC-085 | 2026-06-13: S-WIN-2 MERGED → develop @ 1b84feb via squash PR #505 (human-approved). First Windows-build cycle story shipped. CI 11/11, AI APPROVE, security clean, release-gate empirically verified. Deferred F-WIN2-C-101 → S-WIN-5; CLAUDE.md JR_* doc-fallout → S-WIN-6. develop a7da775→1b84feb. | Feature Mode / Windows-build F4 / S-WIN-2 | Phase 3 | 2026-06-13 |
| DEC-086 | 2026-06-13: S-WIN-3 F4 CONVERGED. Key discovery: windows-native pulls windows-sys 0.60 → 17 [[bans.skip]] entries (not 1). Spec↔impl reconciled: F-102 (1→17), F-WIN3-RA-101 (8→7 arch / ~17→17 exact), F-WIN3-AR1 (deny.toml comment). PG-WIN3-001 + WIN-DENY-FRAGILITY codified. Step-4.5: Pass1 (4 findings) → 2 rounds → 3-clean. spec-changelog v1.3.12. Counts unchanged BC 597 / NFR 42 / ADR 16 / Stories 74. | Feature Mode / Windows-build F4 / S-WIN-3 | Phase 3 | 2026-06-13 |
| DEC-087 | 2026-06-13: S-WIN-3 (keyring windows-native + transitive deny skip set, 17 entries) MERGED → develop @ 2b13596 via squash PR #506 (human-approved). 2/6 Windows-build stories shipped. CI 11/11 (incl. all-target deny job), AI APPROVE, security 0 CRIT/HIGH. Tracked follow-ups: SEC-WCM-DOC + SEC-JR-SERVICE-NAME-GATE (LOW, → S-WIN-6 docs / future story) + WIN-DENY-FRAGILITY (LOW). develop 1b84feb→2b13596. | Feature Mode / Windows-build F4 / S-WIN-3 | Phase 3 | 2026-06-13 |
| DEC-088 | 2026-06-13: S-WIN-1 (per-OS #[cfg(windows)] path resolution: global_config_dir→%APPDATA% Roaming, cache_root→%LOCALAPPDATA% Local, via dirs crate; Unix arm byte-identical; seam-first preserved; XDG ignored on Windows; v1/<profile> preserved) F4 implementation CONVERGED. BC-6.1.014/6.2.016/6.2.004. Step-4.5 per-story 3-clean (final). Key improvement: extracted pure platform-agnostic config_appdata_fallback/cache_localappdata_fallback helpers so the EC-1 fallback tests call production code + run on macOS (killing the empty-filter mutant on every platform, not just Windows CI) — resolves the recurring tautological-test finding all 3 reviewers flagged. Seam-scrub (JR_CONFIG_DIR/JR_CACHE_DIR) added to #[cfg(windows)] tests. #[cfg(windows)] behavioral tests run on Windows CI (S-WIN-5); cross-compile type-check zero Rust errors; macOS suite 907 green. No spec change (impl matched spec). Demo adapted-skip (path-resolution behavior is Windows-only, unobservable on macOS; evidence = cross-compile + macOS suite + Windows CI via S-WIN-5). Counts unchanged. | Feature Mode / Windows-build F4 / S-WIN-1 | Phase 3 | 2026-06-13 |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|---------------|
| F4 per-AC video demo (#475) | Yes — adapted | Test-only story, NO production behavior change. No offline-runnable live demo; evidence = offline hermetic verification + nightly e2e.yml live run. Same handling as prior test-only E2E cycles (#493/#495). |
| S-WIN-2 per-AC demo | Yes — adapted | Debug/infra path-isolation seam; no user-visible behavior change. Evidence = hermetic test suite green (7 AC tests + dual-site release gate) + clippy/fmt. Same handling as test/infra-only stories DEC-075/076. |
| S-WIN-3 per-AC demo | Yes — adapted | Config/CI-manifest infra story; no user-visible behavior change. Evidence = cargo deny check EXIT 0 + AC-001/002 tests green + full cargo test + clippy/fmt. Same handling as infra/test-only stories (DEC-081 S-WIN-2). |
| S-WIN-1 per-AC demo | Yes — adapted | Windows-only path-resolution behavior (#[cfg(windows)]); unobservable on the macOS dev host. Evidence = cross-compile type-check (zero Rust errors) + macOS full suite green (907, incl. un-gated fallback helper tests) + Windows-CI runtime validation via S-WIN-5. Same handling as cfg-gated platform stories. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|

## Drift Items

<!-- OPEN and actively-watched items only. DEFERRED/LOW archived to cycles/cycle-001/burst-log.md "Archived Drift Items". -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| SEC-WCM-DOC | Windows Credential Manager isolation model undocumented | WCM secrets are accessible to any process in the same user session (inherent to WCM, same posture as gh/git-credential-manager). Document in CLAUDE.md Gotchas. Surfaced by S-WIN-3 security review (SEC-001). | LOW | OPEN — doc follow-up |
| SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME env var not debug-gated | Unlike JR_BASE_URL/JR_AUTH_HEADER (debug-only release-gated, SD-002), JR_SERVICE_NAME is readable in release builds. Pre-existing. Candidate follow-up story: add #[cfg(debug_assertions)] gate + release-gate test. Surfaced by S-WIN-3 security review (SEC-002). | LOW | OPEN — follow-up story candidate |
| WIN-DENY-FRAGILITY | deny.toml canonical-un-skipped-version invariant has no proactive CI guard | 17-entry windows skip set is topology-dependent; future windows-sys/targets version-set change could silently break the N-1 canonical invariant. Documented in deny.toml comment + architecture-delta §10. | LOW | OPEN — tracked process-gap |
| F-WIN2-C-101 | Integration-test scrub lists omit JR_CONFIG_DIR/JR_CACHE_DIR | S-WIN-2 seam makes ambient JR_CONFIG_DIR/JR_CACHE_DIR shadow XDG in integration tests; env_remove scrub lists + jr_isolated() must add both vars. S-WIN-5 scope obligation. | MEDIUM | OPEN — wave-gate obligation (S-WIN-5) |
| OQ-5 | CLAUDE.md NFR-O-N stale | `auth status --output json` documents JSON arm but src/cli/auth/status.rs has none. File GitHub issue before next auth touch. | LOW | OPEN — doc drift |
| E2E-PG-4 | E2E coverage gap | REMAINING: remote-link round-back (blocked: no `jr remote-link read`). | LOW | OPEN — 1 sub-gap |
| DRIFT-331-PAGINATION | get_issue_types_for_project pagination | Reimplements offset pagination inline; target: reuse OffsetPage<T>. Deferred per human 2026-06-01. | LOW | OPEN — tracking |
| PG-A | check-bc-cumulative-counts.sh misses README.md | Extend guard to cover README.md grand-total line. | LOW | OPEN — deferred 2026-06-08 |
| DRIFT-README | .factory/specs/prd/README.md Document Map stale | Grand total 573 vs canonical 587; multiple per-section drifts. Pre-existing ~13 cycles. | LOW | OPEN — deferred 2026-06-08 |
| SEC-001 | CWE-674 deep-nesting recursion in adf.rs | Uncontrolled recursion in normalize_list_item_content / normalize_blockquote_content / assign_local_ids_walk / render_node. File-wide sweep target. | LOW | OPEN — deferred 2026-06-10 |
| WIN-O-3 | CANONICAL-COUNTS "Cache Types" prose path is Unix-only | Add Windows `%LOCALAPPDATA%\jr\v1\<profile>\` path entry during F4 implementation. F4 obligation from DEC-079. | LOW | OPEN — F4 obligation |
| WIN-O-4 | CLAUDE.md Windows paths not documented | Add JR_CONFIG_DIR/JR_CACHE_DIR to CLAUDE.md "AI Agent Notes" JR_* table; update cache/config path docs for Windows. F4 obligation from DEC-079. | LOW | OPEN — F4 obligation |
| WIN-PG-1 | No CI guard for inline-PROSE BC counts | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. Codify or justify deferral before cycle close. | LOW | OPEN — process-gap |
| WIN-PG-2 | Story-template lacks presence-only-test disclosure field | Across 5+ S-WIN stories non-integration ACs are source-text greps (presence-only). Codify or justify-defer before cycle close. | LOW | OPEN — process-gap |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-13] S-WIN-1 impl CONVERGED (Step-4.5 3-clean; pure-helper extraction killed the fallback mutant cross-platform). Branch @ db175c6. Awaiting PR. develop 2b13596. DEC-088.** Prior: [2026-06-13] S-WIN-3 MERGED → develop @ 2b13596 (PR #506; 2/6). Wave 2 next (S-WIN-1, S-WIN-4, S-WIN-6). develop 2b13596. DEC-087. Prior: [2026-06-13] S-WIN-3 PR #506 OPEN → develop: CI 11/11 GREEN (deny job all-target), AI APPROVE, security 0 CRIT/HIGH (2 MEDIUM tracked follow-ups). PAUSED before merge. READY TO MERGE. develop 1b84feb. Prior: [2026-06-13] S-WIN-3 impl CONVERGED (Step-4.5 3-clean after F-102 reconciliation + count correction 8→7 arch / 17 exact + F-WIN3-AR1). 17-entry deny skip set, cargo deny EXIT 0. spec v1.3.12. Branch @ 63b981f. DEC-086. Prior: [2026-06-13] DEC-082 corrections RE-CONVERGED — spec-steward v1.3.11 + 3-clean adversarial (A/B/C) on S-WIN-3/S-WIN-4. Full-VSDD closure. Awaiting F3 re-gate. DEC-083. Prior: [2026-06-13] S-WIN-2 PR #505 OPEN → develop: CI 11/11 GREEN, AI review APPROVE, security no-blocking; release-gate empirically verified. PAUSED before merge per human. READY TO MERGE. Prior: [2026-06-13] Pre-F4 research verification: 2 BLOCKERS caught (C-V2b windows-sys 0.60 deny skip REQUIRED; C-V3 Compress-Archive not zip) + 4 propagation leaks, all fixed + re-verified clean. DEC-082.

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-13/14 |
| **Position** | **F4 IN PROGRESS. S-WIN-2 + S-WIN-3 MERGED (2/6). S-WIN-1 impl CONVERGED on branch feat/win-1-per-os-path-resolution @ db175c6 (per-OS AppData path resolution) — Step-4.5 3-clean, macOS cargo test 907 green, cross-compile zero Rust errors, demo adapted-skip. NOT yet PR'd. NEXT: create S-WIN-1 PR → human merge → then remaining Wave 2 {S-WIN-4 (release.yml Compress-Archive), S-WIN-6 (docs fallout + WIN-O-3/O-4 + SEC-WCM-DOC)} → Wave 3 {S-WIN-5 (ci.yml Windows job; runs the #[cfg(windows)] tests; closes F-WIN2-C-101)}. develop 2b13596.** |
| **develop HEAD** | origin/develop = **2b13596** (S-WIN-3 merged). activation v0.6.0-dev.1. BC **597**. NFR **42**. ADR **16**. Stories **74** (authoritative). |
| **Convergence counter** | BC: **597**. NFR: **42**. ADR: **16**. Stories: **74** authoritative. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. 1 active worktree: .worktrees/S-WIN-1 @ db175c6. |
| **Next / Pending** | (1) S-WIN-1 PR then human merge; (2) S-WIN-4 + S-WIN-6 (Wave 2); (3) Wave 3 S-WIN-5 closes F-WIN2-C-101; (4) tracked LOW: WIN-DENY-FRAGILITY, SEC-WCM-DOC, SEC-JR-SERVICE-NAME-GATE; standing items unchanged. |
| **Resume prompt** | `Read .factory/STATE.md. DATE 2026-06-13/14; S-WIN-1 impl CONVERGED @ db175c6 (per-OS #[cfg(windows)] AppData path resolution, Step-4.5 3-clean); NOT yet PR'd; develop 2b13596; BC 597 / Stories 74; next: S-WIN-1 PR → human merge → S-WIN-4 + S-WIN-6 (Wave 2) → Wave 3 S-WIN-5; jira-e2e env JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #506 | S-WIN-3 keyring windows-native + deny transitive skip set | **MERGED → develop @ 2b13596 (squash, 2026-06-13T18:27:29Z). 2/6 Windows-build stories shipped.** | — | Closed. |
| #505 | S-WIN-2 JR_CONFIG_DIR/JR_CACHE_DIR debug seam (BC-6.2.017) | **MERGED → develop @ 1b84feb (squash, 2026-06-13). First Windows-build story shipped.** | — | Closed. |
| #492 | fix(adf): block-HTML raw-\n invariant | **OPEN** — needs-sandbox. Filed 2026-06-09. Raw-\n in literal-text paragraphs may not survive Jira REST round-trip. | LOW | No active cycle. |
| #475 | ADF read-path / E2E coverage | **CLOSED — CYCLE CLOSED + MERGED** (PR #499 → develop @ 418a392e, 2026-06-11). All sub-gaps DONE. | LOW | CYCLE CLOSED. |
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
