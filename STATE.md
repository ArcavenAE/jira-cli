---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-14T18:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "2026-06-14: S-WIN-5 (FINAL Windows-build story — ci.yml Windows job + 37-file XDG→seam migration) implementation CONVERGED — Step-4.5 3-clean after 4 fix rounds (each caught a distinct Windows-failure class: config/in-process half-migration, separator assertion, CRLF yaml read, unix-binary subprocess). Full Unix suite 1793/0; cross-compile --tests clean; clippy/fmt clean. Branch feat/win-5-ci-yml-windows-job @ f40c310. Next: S-WIN-5 PR (its windows-latest CI run is the AC-005/007 integration gate). develop bc69c625."
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
| **Last Updated** | 2026-06-14: S-WIN-5 (FINAL story) impl CONVERGED — Step-4.5 3-clean after 4 fix rounds (each a distinct Windows-failure class). Branch feat/win-5-ci-yml-windows-job @ f40c310. Awaiting PR (windows CI = integration gate). develop bc69c625. DEC-094. LESSON-WIN-CI-CHECKLIST codified. |
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
| Windows build (x86_64-pc-windows-msvc) | **F4 IN PROGRESS — S-WIN-2/3/1/4/6 MERGED (5/6); S-WIN-5 impl CONVERGED (awaiting PR — its windows CI is the integration gate); then F5/F6/F7 cycle close** | 2026-06-12 (F2) / 2026-06-13 (F3 APPROVED + S-WIN-2/3/1/4 MERGED) / 2026-06-14 (S-WIN-6 MERGED; S-WIN-5 CONVERGED) | F3 human gate APPROVED 2026-06-13; DEC-082 RE-CONVERGED + RE-AFFIRMED 2026-06-13 (DEC-084) | 8-pass F3 trajectory 6→5→2→2→2→0→0→0; S-WIN-3 Step-4.5 3-clean; Stories 68→74 authoritative; ADR-0016 Decisions 2/3/5b amended; DEC-079..094. PR #504 MERGED (develop a7da775). S-WIN-2 MERGED PR #505 (develop 1b84feb). S-WIN-3 MERGED PR #506 (develop 2b13596). S-WIN-1 MERGED PR #507 (develop 219debc). S-WIN-4 MERGED PR #508 (develop b49dc08). S-WIN-6 MERGED PR #509 (develop bc69c625; 2026-06-14; docs fallout; WIN-O-3/O-4/SEC-WCM-DOC closed). S-WIN-5 impl CONVERGED @ f40c310 (2026-06-14; Step-4.5 3-clean; 4 fix rounds; LESSON-WIN-CI-CHECKLIST; DEC-094). |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->

| Step | Agent | Status | Output |
|------|-------|--------|--------|
| S-WIN-6 F4 delivery: Windows docs fallout (CLAUDE.md JR_CONFIG_DIR/JR_CACHE_DIR + %APPDATA%/%LOCALAPPDATA% paths + WCM gotcha + ADR-0016 Key Decisions; docs/adr/0016 materialized verbatim incl 5b/5c) + 5 CI-safe section-anchored tests. Red-Gate caught AC-005 reading unreachable .factory adr-index → re-scoped to product CLAUDE.md Key Decisions (spec-steward v1.3.13). Step-4.5 3-clean (doc accuracy verified vs merged S-WIN-1/2/3). WIN-O-3 closed (CANONICAL-COUNTS Windows path). cargo test green; clippy/fmt clean. | Agent multi | S-WIN-6 CONVERGED — PR created | Source on feat branch. develop b49dc08. BC 597 / Stories 74. |
| S-WIN-6 PR #509 created → develop (docs fallout). CI 11/11 PASS. AI PR review APPROVE (1 cycle, 0 blocking — 2 nits: WCM gotcha lacks BC citation, ADR retains .factory refs inherent to verbatim-copy). Security APPROVE 0 CRIT/HIGH/MED (2 LOW informational). PAUSED before merge. | Agent pr-manager | S-WIN-6 PR #509 OPEN — READY TO MERGE (paused, human gate) | PR #509. CI 11/11. develop b49dc08. |
| S-WIN-6 PR #509 squash-MERGED → develop @ bc69c625; remote branch feat/win-6-windows-docs-fallout deleted; worktree cleanup dispatched. 5/6 Windows-build stories shipped (docs fallout; WIN-O-3/O-4/SEC-WCM-DOC closed). develop b49dc08→bc69c625. | Agent pr-manager+state-manager | S-WIN-6 MERGED (5/6) — S-WIN-5 final next | develop @ bc69c625. BC 597 / Stories 74. |
| S-WIN-5 (FINAL story) F4 delivery: ci.yml windows test+clippy matrix + .gitattributes eol=lf + 37-file XDG→JR seam migration + F-WIN2-C-101 scrub + AC-004 per-call-site guard. Step-4.5 per-story CONVERGED after 4 fix rounds (config/in-process half-migration → separator → CRLF-yaml/grep), final 3-clean. Migration call-site-exact; full suite 1793/0; cross-compile --tests clean. LESSON-WIN-CI-CHECKLIST codified. | Agent multi | S-WIN-5 CONVERGED — awaiting PR (integration gate) | Source on feat branch. develop bc69c625. BC 597 / Stories 74. |

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
| DEC-087 | 2026-06-13: S-WIN-3 (keyring windows-native + transitive deny skip set, 17 entries) MERGED → develop @ 2b13596 via squash PR #506 (human-approved). 2/6 Windows-build stories shipped. CI 11/11 (incl. all-target deny job), AI APPROVE, security 0 CRIT/HIGH (2 MEDIUM tracked follow-ups). Tracked follow-ups: SEC-WCM-DOC + SEC-JR-SERVICE-NAME-GATE (LOW, → S-WIN-6 docs / future story) + WIN-DENY-FRAGILITY (LOW). develop 1b84feb→2b13596. | Feature Mode / Windows-build F4 / S-WIN-3 | Phase 3 | 2026-06-13 |
| DEC-088 | 2026-06-13: S-WIN-1 (per-OS #[cfg(windows)] path resolution: global_config_dir→%APPDATA% Roaming, cache_root→%LOCALAPPDATA% Local, via dirs crate; Unix arm byte-identical; seam-first preserved; XDG ignored on Windows; v1/<profile> preserved) F4 implementation CONVERGED. BC-6.1.014/6.2.016/6.2.004. Step-4.5 per-story 3-clean (final). Key improvement: extracted pure platform-agnostic config_appdata_fallback/cache_localappdata_fallback helpers so the EC-1 fallback tests call production code + run on macOS (killing the empty-filter mutant on every platform, not just Windows CI) — resolves the recurring tautological-test finding all 3 reviewers flagged. Seam-scrub (JR_CONFIG_DIR/JR_CACHE_DIR) added to #[cfg(windows)] tests. #[cfg(windows)] behavioral tests run on Windows CI (S-WIN-5); cross-compile type-check zero Rust errors; macOS suite 907 green. No spec change (impl matched spec). Demo adapted-skip (path-resolution behavior is Windows-only, unobservable on macOS; evidence = cross-compile + macOS suite + Windows CI via S-WIN-5). Counts unchanged. | Feature Mode / Windows-build F4 / S-WIN-1 | Phase 3 | 2026-06-13 |
| DEC-089 | 2026-06-13: S-WIN-1 (per-OS #[cfg(windows)] AppData path resolution) MERGED → develop @ 219debc via squash PR #507 (human-approved). 3/6 Windows-build stories shipped. CI 11/11; AI APPROVE (cycle 3 — caught E0425 the Step-4.5 missed, WIN-CFG-TESTS-CHECK codified); security CLEAR. develop 2b13596→219debc. | Feature Mode / Windows-build F4 / S-WIN-1 | Phase 3 | 2026-06-13 |
| DEC-090 | 2026-06-13: S-WIN-4 (release.yml Windows target — PowerShell Compress-Archive packaging [ADR-0016 Decision 2 / C-V3], Checksum bash sha256sum, smoke gated off Windows, x86_64-pc-windows-msvc matrix row, jr-*.zip globs) F4 implementation CONVERGED. YAML-only + presence-assertion test; H-WIN-6 (Release-page inspection) the named real gate; actionlint clean. Step-4.5 per-story 3-clean after 3 anchoring rounds (smoke-gate non-unique grep → AC-004/005 aliasing + AC-002 C-V3 negative → step_block boundary helper). Codified LESSON-PRESENCE-ANCHOR (anchor presence-greps to owning step unless token file-unique) — resolves the recurring pattern from S-WIN-3/4; apply to S-WIN-5/6. Demo adapted-skip (CI-config infra; no user-visible behavior; H-WIN-6 live gate). No spec change (impl matched converged spec). Counts unchanged. | Feature Mode / Windows-build F4 / S-WIN-4 | Phase 3 | 2026-06-13 |
| DEC-091 | 2026-06-13: S-WIN-4 (release.yml Windows target — Compress-Archive .zip packaging per C-V3) MERGED → develop @ b49dc08 via squash PR #508 (human-approved). 4/6 Windows-build stories shipped. CI 11/11; AI APPROVE (1 cycle 0 blocking); security 0 CRIT/HIGH. H-WIN-6 (live release-page inspection) is the post-all-merge correctness gate. develop 219debc→b49dc08. | Feature Mode / Windows-build F4 / S-WIN-4 | Phase 3 | 2026-06-13 |
| DEC-092 | 2026-06-13: S-WIN-6 (Windows docs fallout) F4 implementation CONVERGED. CLAUDE.md gains JR_CONFIG_DIR/JR_CACHE_DIR JR_* table entries + Windows %APPDATA%\jr (Roaming config) / %LOCALAPPDATA%\jr (Local cache) path docs + WCM same-user-session isolation gotcha (closes SEC-WCM-DOC) + ADR-0016 Key Decisions line; docs/adr/0016-windows-build-target.md materialized verbatim (incl. Decisions 5b/5c). Closes WIN-O-4 + SEC-WCM-DOC. Red-Gate defect caught: AC-005 test read unreachable ../../.factory/architecture/adr-index.md (would fail product CI) → re-scoped to product-repo CLAUDE.md §Key Decisions (the real product ADR registry, was missing ADR-0016); spec reconciled + governed (spec-changelog v1.3.13, DEC-083-style doc-target reconciliation, no behavioral re-gate). Step-4.5 per-story 3-clean (doc accuracy line-by-line vs merged S-WIN-1/2/3; ADR byte-for-byte; CI-safe section-anchored tests per LESSON-PRESENCE-ANCHOR). WIN-O-3 (CANONICAL-COUNTS Windows cache path) CLOSED directly (was wrongly tracked as S-WIN-6-closed; actually out-of-scope per story → closed via factory-doc edit here). Demo adapted-skip (docs-only; no behavior). Counts unchanged BC 597 / NFR 42 / ADR 16 / Stories 74. | Feature Mode / Windows-build F4 / S-WIN-6 | Phase 3 | 2026-06-13 |
| DEC-093 | 2026-06-14: S-WIN-6 (Windows docs fallout) MERGED → develop @ bc69c625 via squash PR #509 (human-approved). 5/6 Windows-build stories shipped. CI 11/11; AI APPROVE (1 cycle 0 blocking); security 0 CRIT/HIGH. Closed WIN-O-3/WIN-O-4/SEC-WCM-DOC. Only S-WIN-5 (ci.yml Windows job) remains. develop b49dc08→bc69c625. | Feature Mode / Windows-build F4 / S-WIN-6 | Phase 3 | 2026-06-14 |
| DEC-094 | 2026-06-14: S-WIN-5 (FINAL Windows-build story — ci.yml windows-latest test matrix + separate windows clippy matrix [ADR-0016 Decision 3] + .gitattributes *.snap/*.yml eol=lf + 37-file XDG→JR_CONFIG_DIR/JR_CACHE_DIR seam migration [value=XDG.join('jr'), BC-6.2.017] + F-WIN2-C-101 scrub-list closed + AC-004 per-call-site count guard) F4 implementation CONVERGED. This CI job runs S-WIN-1/2's #[cfg(windows)] tests on windows-latest for the first time. Step-4.5 per-story 3-clean after 4 fix rounds, each catching a DISTINCT Windows-failure class the prior round's guard missed: (R1) multi_cloudid config-seam half-migration → guard per-var; (R2) worklog in-process cache-seam half-migration → guard per-call-site count; (R3) issue_create_jsm separator assertion contains('/jr/v1/') → HIGH Windows-fail → separator-agnostic + Step-5b sweep; (R4) ci_yml_windows_matrix CRLF ':\n' anchor on CRLF-checked-out yaml → CRITICAL → CRLF-normalize + *.yml eol=lf, and grep subprocess → in-process fs walk. F-WIN2-C-101 (deferred from S-WIN-2) CLOSED. Codified LESSON-WIN-CI-CHECKLIST (6-point Windows-CI-readiness checklist). AC-005/AC-007 = integration gates (the windows-latest CI run in the PR). Demo adapted-skip (CI-config infra). Tracked follow-up WIN-SRC-UNITTEST-SEAM (src/cache.rs with_temp_cache sets XDG not JR_CACHE_DIR → touches real %LOCALAPPDATA%\jr on Windows; root-agnostic so passes, R-W5 hygiene; out of tests/-only migration scope). No src/* production change. Counts unchanged BC 597 / NFR 42 / ADR 16 / Stories 74. | Feature Mode / Windows-build F4 / S-WIN-5 | Phase 3 | 2026-06-14 |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|---------------|
| F4 per-AC video demo (#475) | Yes — adapted | Test-only story, NO production behavior change. No offline-runnable live demo; evidence = offline hermetic verification + nightly e2e.yml live run. Same handling as prior test-only E2E cycles (#493/#495). |
| S-WIN-2 per-AC demo | Yes — adapted | Debug/infra path-isolation seam; no user-visible behavior change. Evidence = hermetic test suite green (7 AC tests + dual-site release gate) + clippy/fmt. Same handling as test/infra-only stories DEC-075/076. |
| S-WIN-3 per-AC demo | Yes — adapted | Config/CI-manifest infra story; no user-visible behavior change. Evidence = cargo deny check EXIT 0 + AC-001/002 tests green + full cargo test + clippy/fmt. Same handling as infra/test-only stories (DEC-081 S-WIN-2). |
| S-WIN-1 per-AC demo | Yes — adapted | Windows-only path-resolution behavior (#[cfg(windows)]); unobservable on the macOS dev host. Evidence = cross-compile type-check (zero Rust errors) + macOS full suite green (907, incl. un-gated fallback helper tests) + Windows-CI runtime validation via S-WIN-5. Same handling as cfg-gated platform stories. |
| S-WIN-4 per-AC demo | Yes — adapted | release.yml CI-config infra; no user-visible behavior. Evidence = actionlint clean + 5 step-anchored presence tests + cargo test green; real correctness gate is H-WIN-6 (human inspection of the GitHub Release page after a live tag). Same handling as CI/manifest infra stories (S-WIN-3). |
| S-WIN-6 per-AC demo | Yes — adapted | Docs-only story (CLAUDE.md + docs/adr materialization); no user-visible runtime behavior. Evidence = 5 CI-safe section-anchored presence tests + cargo test green + doc-accuracy adversarial verification vs merged impl. |
| S-WIN-5 per-AC demo | Yes — adapted | CI-config infra (ci.yml + .gitattributes + test-helper migration); no user-visible runtime behavior. Evidence = full Unix suite 1793/0 + 7 ci.yml/migration guard tests + cross-compile --tests clean; AC-005/007 correctness gate = the windows-latest CI run in the PR. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|

## Drift Items

<!-- OPEN and actively-watched items only. DEFERRED/LOW archived to cycles/cycle-001/burst-log.md "Archived Drift Items". -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| WIN-CFG-TESTS-CHECK | Cross-compile verification of #[cfg(windows)] code must use --tests, not --lib | `cargo check --target x86_64-pc-windows-msvc --lib` excludes #[cfg(test)] blocks, so #[cfg(windows)] TEST code is NOT type-checked — a compile error (E0425) in windows-gated tests slips past both the Step-4.5 adversary (read-only, no compile) and the implementer's --lib cross-check; only the PR gate / a Windows runner catches it. RULE: verify cfg(windows) test code with `cargo check --target x86_64-pc-windows-msvc --tests`. Surfaced by S-WIN-1 PR #507 (2 review-fix cycles). | LOW | OPEN — process-gap (apply to S-WIN-5 + future cfg-gated work) |
| SEC-WCM-DOC | Windows Credential Manager isolation model undocumented | WCM secrets are accessible to any process in the same user session (inherent to WCM, same posture as gh/git-credential-manager). Document in CLAUDE.md Gotchas. Surfaced by S-WIN-3 security review (SEC-001). | LOW | **CLOSED** — S-WIN-6 WCM gotcha added to CLAUDE.md (2026-06-13; DEC-092) |
| SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME env var not debug-gated | Unlike JR_BASE_URL/JR_AUTH_HEADER (debug-only release-gated, SD-002), JR_SERVICE_NAME is readable in release builds. Pre-existing. Candidate follow-up story: add #[cfg(debug_assertions)] gate + release-gate test. Surfaced by S-WIN-3 security review (SEC-002). | LOW | OPEN — follow-up story candidate |
| WIN-DENY-FRAGILITY | deny.toml canonical-un-skipped-version invariant has no proactive CI guard | 17-entry windows skip set is topology-dependent; future windows-sys/targets version-set change could silently break the N-1 canonical invariant. Documented in deny.toml comment + architecture-delta §10. | LOW | OPEN — tracked process-gap |
| F-WIN2-C-101 | Integration-test scrub lists omit JR_CONFIG_DIR/JR_CACHE_DIR | S-WIN-2 seam makes ambient JR_CONFIG_DIR/JR_CACHE_DIR shadow XDG in integration tests; env_remove scrub lists + jr_isolated() must add both vars. S-WIN-5 scope obligation. | MEDIUM | **CLOSED** — S-WIN-5 migration closed all tests/ call sites; per-call-site count guard enforces parity (2026-06-14; DEC-094) |
| WIN-SRC-UNITTEST-SEAM | src/ unit tests (with_temp_cache) isolate via XDG only, not the JR seam | src/cache.rs with_temp_cache (~611) + similar src/ unit tests set XDG_CACHE_HOME but not JR_CACHE_DIR; on Windows XDG is ignored so they touch the real %LOCALAPPDATA%\jr (root-agnostic → tests pass, but violates R-W5 'no test writes real profile'). Out of S-WIN-5's tests/-only migration scope. Follow-up: migrate src/ unit-test isolation to the JR seam. | LOW | OPEN — follow-up (out of S-WIN-5 scope) |
| OQ-5 | CLAUDE.md NFR-O-N stale | `auth status --output json` documents JSON arm but src/cli/auth/status.rs has none. File GitHub issue before next auth touch. | LOW | OPEN — doc drift |
| E2E-PG-4 | E2E coverage gap | REMAINING: remote-link round-back (blocked: no `jr remote-link read`). | LOW | OPEN — 1 sub-gap |
| DRIFT-331-PAGINATION | get_issue_types_for_project pagination | Reimplements offset pagination inline; target: reuse OffsetPage<T>. Deferred per human 2026-06-01. | LOW | OPEN — tracking |
| PG-A | check-bc-cumulative-counts.sh misses README.md | Extend guard to cover README.md grand-total line. | LOW | OPEN — deferred 2026-06-08 |
| DRIFT-README | .factory/specs/prd/README.md Document Map stale | Grand total 573 vs canonical 587; multiple per-section drifts. Pre-existing ~13 cycles. | LOW | OPEN — deferred 2026-06-08 |
| SEC-001 | CWE-674 deep-nesting recursion in adf.rs | Uncontrolled recursion in normalize_list_item_content / normalize_blockquote_content / assign_local_ids_walk / render_node. File-wide sweep target. | LOW | OPEN — deferred 2026-06-10 |
| WIN-O-3 | CANONICAL-COUNTS "Cache Types" prose path is Unix-only | Add Windows `%LOCALAPPDATA%\jr\v1\<profile>\` path entry during F4 implementation. F4 obligation from DEC-079. | LOW | **CLOSED** — CANONICAL-COUNTS Windows %LOCALAPPDATA% cache path added 2026-06-13 (DEC-092) |
| WIN-O-4 | CLAUDE.md Windows paths not documented | Add JR_CONFIG_DIR/JR_CACHE_DIR to CLAUDE.md "AI Agent Notes" JR_* table; update cache/config path docs for Windows. F4 obligation from DEC-079. | LOW | **CLOSED** — S-WIN-6 CLAUDE.md JR_* table + Windows path docs added (2026-06-13; DEC-092) |
| WIN-PG-1 | No CI guard for inline-PROSE BC counts | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. Codify or justify deferral before cycle close. | LOW | OPEN — process-gap |
| WIN-PG-2 | Story-template lacks presence-only-test disclosure field | Across 5+ S-WIN stories non-integration ACs are source-text greps (presence-only). Anchoring sub-aspect RESOLVED via LESSON-PRESENCE-ANCHOR (codified 2026-06-13; step_block exemplar from S-WIN-4). Template-field disclosure aspect remains open — codify or justify-defer before cycle close. | LOW | OPEN — template-field aspect (anchoring aspect resolved by LESSON-PRESENCE-ANCHOR) |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-14] S-WIN-5 (FINAL story) impl CONVERGED — Step-4.5 3-clean after 4 Windows-failure-class fix rounds; migration call-site-exact; LESSON-WIN-CI-CHECKLIST codified. Branch @ f40c310. Awaiting PR (windows CI = integration gate). develop bc69c625. DEC-094.** Prior: [2026-06-14] S-WIN-6 MERGED → develop @ bc69c625 (PR #509; 5/6). FINAL story S-WIN-5 (Wave 3 ci.yml Windows job) next. develop bc69c625. DEC-093. Prior: [2026-06-13] S-WIN-6 PR #509 OPEN → develop: CI 11/11 GREEN, AI APPROVE (1 cycle 0 blocking), security 0 CRIT/HIGH. PAUSED before merge. READY TO MERGE — 5/6 on merge, then final S-WIN-5. Prior: [2026-06-13] S-WIN-6 impl CONVERGED (Step-4.5 3-clean; AC-005 Red-Gate re-scope to product CLAUDE.md Key Decisions, spec v1.3.13; WIN-O-3/O-4/SEC-WCM-DOC closed). Branch @ 6558de2. Awaiting PR (last Wave 2). develop b49dc08. DEC-092.

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-14 |
| **Position** | **F4 NEARLY COMPLETE. S-WIN-2/3/1/4/6 MERGED (5/6). S-WIN-5 (FINAL story) impl CONVERGED on branch feat/win-5-ci-yml-windows-job @ f40c310 — Step-4.5 3-clean (4 fix rounds), full Unix suite 1793/0, demo adapted-skip. NOT yet PR'd. NEXT: create S-WIN-5 PR — its windows-latest test+clippy CI run is the AC-005/007 integration gate (first real Windows execution of S-WIN-1/2's #[cfg(windows)] tests; if windows jobs fail, fix per the failure). On merge (6/6): Windows-build feature F5 (scoped adversarial) / F6 (targeted hardening) / F7 (delta convergence + human gate) cycle close; H-WIN-6 live release-page gate (push a release tag, confirm jr-*-x86_64-pc-windows-msvc.zip on the Release page). develop bc69c625.** |
| **develop HEAD** | origin/develop = **bc69c625** (S-WIN-6 merged). activation v0.6.0-dev.1. BC **597**. NFR **42**. ADR **16**. Stories **74** (authoritative). |
| **Convergence counter** | BC: **597**. NFR: **42**. ADR: **16**. Stories: **74** authoritative. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. 1 active worktree: .worktrees/S-WIN-5 @ f40c310. |
| **Next / Pending** | (1) S-WIN-5 PR then human merge (6/6 — completes Windows-build F4); (2) Windows-build F5/F6/F7 cycle close + human gate; (3) H-WIN-6 live release-page gate; (4) tracked LOW: WIN-DENY-FRAGILITY, SEC-JR-SERVICE-NAME-GATE, WIN-SRC-UNITTEST-SEAM; standing items unchanged. |
| **Resume prompt** | `Read .factory/STATE.md. DATE 2026-06-14; S-WIN-5 impl CONVERGED @ f40c310 on feat/win-5-ci-yml-windows-job (NOT yet PR'd); BC 597 / Stories 74; NEXT: (1) create S-WIN-5 PR (windows-latest CI run is the AC-005/007 integration gate — first real #[cfg(windows)] execution) → (2) human merge (6/6) → (3) H-WIN-6 live release-page gate → (4) Windows-build F5/F6/F7 cycle close; jira-e2e env JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #509 | S-WIN-6 Windows docs fallout (CLAUDE.md + ADR-0016 materialization) | **MERGED → develop @ bc69c625** (squash PR #509; 2026-06-14; human-approved). Remote branch deleted. 5/6 Windows-build stories shipped. | — | DEC-093. WIN-O-3/O-4/SEC-WCM-DOC closed. |
| #508 | S-WIN-4 release.yml Windows target (Compress-Archive .zip) | **MERGED → develop @ b49dc08** (squash PR #508; 2026-06-13; human-approved). Remote branch deleted. H-WIN-6 = live release-page gate post-all-merge. | — | DEC-091. 4/6 Windows-build stories shipped. |
| #507 | S-WIN-1 per-OS #[cfg(windows)] AppData path resolution | **MERGED → develop @ 219debc** (squash PR #507; 2026-06-13; human-approved). Remote branch deleted. | — | DEC-089. 3/6 Windows-build stories shipped. |
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
