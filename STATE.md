---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-14T00:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "2026-06-13: S-WIN-2 PR #505 MERGED → develop @ 1b84feb (squash; first Windows-build story shipped to develop). F4 continues: S-WIN-3 (Wave 1, keyring windows-native + REQUIRED windows-sys 0.60 deny skip) starting. develop HEAD 1b84feb."
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
| **Last Updated** | 2026-06-13: S-WIN-2 impl CONVERGED (5-pass Step-4.5, TDD green, cargo test green). Branch feat/win-2-config-cache-dir-seam @ b958e60. PR #504 MERGED (develop a7da775). DEC-081. |
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
| Windows build (x86_64-pc-windows-msvc) | **F4 IN PROGRESS — S-WIN-2 MERGED (1/6); S-WIN-3 starting (Wave 1)** | 2026-06-12 (F2) / 2026-06-13 (F3 APPROVED + RE-AFFIRMED + S-WIN-2 MERGED) | F3 human gate APPROVED 2026-06-13; DEC-082 RE-CONVERGED + RE-AFFIRMED 2026-06-13 (DEC-084) | 8-pass trajectory 6→5→2→2→2→0→0→0; Stories 68→74 authoritative; ADR-0016 Decisions 2/3/5b amended; DEC-079/080/081/082/083/084/085. PR #504 MERGED (develop a7da775). S-WIN-2 MERGED via PR #505 (develop 1b84feb). S-WIN-3 starting. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->

| Step | Agent | Status | Output |
|------|-------|--------|--------|
| S-WIN-2 PR #505 created → develop (branch feat/win-2-config-cache-dir-seam, commits 7ddfab4/be6ecbc/b958e60). CI 11/11 PASS (clippy/coverage/deny/fmt/MSRV/mutation/secret-scan/spec-guards/test-macos/test-ubuntu/dep-review). AI PR review APPROVE (2 LOW non-blocking: source-adjacency grep brittleness, XDG-not-restored-in-closure). Security review no CRITICAL/HIGH (SEC-001 CLAUDE.md deferral pre-disclosed→S-WIN-6; release-gate empirically verified: --release compile fails E0080 proving seam excluded). PAUSED before merge per human (review-first). | Agent pr-manager | S-WIN-2 PR #505 OPEN — READY TO MERGE (paused, human gate) | PR #505. CI 11/11. develop a7da775. Recommend squash-merge. |
| DEC-082 corrections governed + RE-CONVERGED 2026-06-13 (spec-steward v1.3.11 + 3-clean adversarial A/B/C on S-WIN-3/S-WIN-4). Full-VSDD closure of post-convergence spec change. Awaiting F3 re-gate. DEC-083. | Agent state-manager+specialists | FULL-VSDD CLOSURE COMPLETE — awaiting re-gate | S-WIN-3/4 specs locked. S-WIN-2 unaffected. develop a7da775. |
| F3 re-gate human RE-AFFIRMED 2026-06-13 (human chose Re-affirm F3): accepted DEC-082 corrections (Compress-Archive packaging; required windows-sys 0.60 deny skip). Full-VSDD closure COMPLETE — spec-steward governance v1.3.11 + 3-clean adversarial re-convergence (A/B/C) + human re-gate. S-WIN-3/S-WIN-4 specs locked for F4. | Agent state-manager | F3 RE-AFFIRMED — F4 continues | BC 597/NFR 42/ADR 16/Stories 74. develop a7da775. S-WIN-2 PR #505 open. |
| S-WIN-2 PR #505 squash-MERGED → develop @ 1b84feb (2026-06-13T16:55:26Z); remote branch feat/win-2-config-cache-dir-seam deleted; worktree cleanup dispatched. First of 6 Windows-build stories shipped. develop a7da775→1b84feb. | Agent pr-manager+state-manager | S-WIN-2 MERGED (1/6) — S-WIN-3 next | develop @ 1b84feb. BC 597/Stories 74. |

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

| DEC-081 | 2026-06-13: PR #504 (ADR-0003 docs) MERGED → develop @ a7da775 (was OPEN do-not-merge; human merged). S-WIN-2 (Windows debug path-isolation seam) F4 implementation CONVERGED: TDD on branch feat/win-2-config-cache-dir-seam off a7da775; 7 tests pin AC-001..008 (BC-6.2.017); 5-pass Step-4.5 per-story adversarial convergence; security dual-site #[cfg(debug_assertions)] gate verified (B: all 6 mutations killed); F-WIN2-C-102 (LOW env-leak-on-panic) fixed via with_env_var catch_unwind helper; full cargo test green. Demo adapted-skip per test/infra-seam precedent (DEC-075/076): no user-visible behavior, evidence = hermetic test green + release-gate proof. Deferred: F-WIN2-C-101 (MEDIUM cross-story) → S-WIN-5 must add JR_CONFIG_DIR/JR_CACHE_DIR to integration-test env_remove scrub lists + jr_isolated(). | Feature Mode / Windows-build F4 / S-WIN-2 | Phase 3 | 2026-06-13 |

| DEC-083 | 2026-06-13: Full-VSDD closure of the DEC-082 post-F3-convergence spec change. (1) spec-steward governance pass: spec-changelog PATCH v1.3.11, dates reconciled, traceability chain (research→ADR→stories→STORY-INDEX→DEC-082) verified, change-record spec-change-record-DEC-082.md, all 3 CI count scripts green (BC 597/NFR 42/ADR 16/Stories 74 unchanged — governance metadata only). (2) Adversarial RE-CONVERGENCE on materially-changed S-WIN-3/S-WIN-4: 3 fresh-context passes (A traceability/scope, B mechanical-correctness, C integration/cross-story) all CLEAN — 3-clean converged. Confirms windows-sys 0.60 skip mechanically makes cargo deny pass; Compress-Archive YAML sound end-to-end to published Release; no stale references; cross-story consistent. (3) F3 re-gate (human re-affirmation) pending. Rationale: VSDD requires versioning + re-convergence + re-gate when converged specs change; the earlier focused-1-pass propagation check was abbreviated — this closes it properly. S-WIN-2 (already delivered, PR #505) unaffected. | Feature Mode / Windows-build F3 re-convergence | Phase 3 | 2026-06-13 |

| DEC-084 | 2026-06-13: F3 re-gate RE-AFFIRMED by human after the DEC-082/DEC-083 full-VSDD closure (spec-steward v1.3.11 + 3-clean re-convergence). Human accepted: (1) S-WIN-4 PowerShell Compress-Archive as locked Windows packaging mechanism; (2) S-WIN-3 windows-sys 0.60 deny skip REQUIRED (same commit as windows-native); (3) corrections scoped to S-WIN-3/S-WIN-4 + ADR-0016 only, S-WIN-2/others unaffected. F3 remains CONVERGED with corrections folded in. F4 delivery continues per agreed pacing (PR-then-pause). Process lesson reaffirmed: post-convergence spec changes require versioning + re-convergence + re-gate (closed here). | Feature Mode / Windows-build F3 re-gate | Phase 3 | 2026-06-13 |

| DEC-085 | 2026-06-13: S-WIN-2 (Windows debug path-isolation seam, BC-6.2.017) MERGED to develop @ 1b84feb via squash PR #505 (human-approved). First Windows-build cycle story shipped. CI 11/11, AI APPROVE, security clean, release-gate empirically verified. Deferred-to-S-WIN-5: F-WIN2-C-101 integration-test scrub-list. Deferred-to-S-WIN-6: CLAUDE.md JR_* table doc-fallout. develop a7da775→1b84feb. | Feature Mode / Windows-build F4 / S-WIN-2 | Phase 3 | 2026-06-13 |

| DEC-082 | 2026-06-13: Pre-F4 external-claim verification (research-agent; primary sources: docs.rs/dirs 6, keyring 3.6.3 Cargo.toml, reqwest 0.13 Cargo.toml, actions/runner-images manifest, MSYS2 index, Rust 2024 edition guide). 6 claims checked (C-V1..C-V6). CONFIRMED: C-V1 (dirs config_dir→%APPDATA%/Roaming, cache_dir→%LOCALAPPDATA%/Local, no XDG on Windows), C-V2a (keyring windows-native→Credential Manager), C-V4 (separate Windows clippy job genuinely required — cfg(windows) stripped on Linux host), C-V5 (reqwest rustls pulls rustls-platform-verifier 0.6 + aws-lc-rs → Windows cert store; RE-CONFIRMS F2 C4 correction; webpki-roots misconception inoculated), C-V6 (Rust 2024 set_var/remove_var unsafe). 2 BLOCKERS: C-V2(b) REFUTED — keyring windows-native pulls windows-sys 0.60, NOT covered by existing deny.toml skips (0.45/0.61) → cargo deny would FAIL → S-WIN-3 now mandates a REQUIRED [[bans.skip]] for windows-sys 0.60 + pinning test; C-V3 PARTIALLY-CONFIRMED — Unix zip NOT on windows-latest PATH (sha256sum IS) → REFUTES the F3 F-WIN-F3-003 ADR-0016 Decision 2 amendment (Git Bash zip primary) → re-amended to PowerShell Compress-Archive primary (pwsh) + separate sha256sum bash step; S-WIN-4 packaging updated. Corrections propagated to ADR-0016 (Decision 2 superseded, Decision 5b amended), adr-index, architecture-delta §3.3/§5.3/R-W1, S-WIN-3, S-WIN-4, S-WIN-6 (stale adr-index quote genericized). Focused adversarial propagation check: initially 4 residual stale-0.61/if-needed leaks (architecture-delta §5.3, ADR Decision 5b, R-W1, S-WIN-6 AC-005) — ALL FIXED + grep-confirmed clean. LESSON: externally-grounded version/runtime facts are invisible to internal-consistency adversarial review; a research-agent primary-source verification gate before F4 implementation catches deny-fail and release-artifact-fail blockers. Perplexity deep-research returned 2 confidently-FALSE answers this run, both caught by primary-source WebFetch — do not trust LLM prose for version-exact claims. total_stories unchanged (74). | Feature Mode / Windows-build F4 preflight | Phase 3 | 2026-06-13 |

| DEC-080 | 2026-06-13: Windows-build F3 story decomposition CONVERGED. 6 stories S-WIN-1..6 (total_stories 68→74 authoritative). 8-pass adversarial story review, 3-clean-pass convergence P6/P7/P8 (trajectory 6→5→2→2→2→0→0→0). Key catch: F-WIN-F3-001 CRITICAL — ADR-0016 Decision 3 carried a factually false premise (claimed Windows clippy folded into the test job; live ci.yml has separate clippy/test jobs) → architect amended Decision 3 to the separate-clippy-matrix [ubuntu,windows] approach + cross-ref delta §4.1 + adr-index annotation. F-WIN-F3-003 MEDIUM — ADR Decision 2 amended: Git Bash zip primary (windows-latest ships Git for Windows zip+sha256sum), Compress-Archive alternative, EC-002 risk accepted LOW. ADR 15→16 unchanged in count (ADR-0016 amended in place, not new). Counts: BC 597 / NFR 42 / Stories 74. STORY-INDEX status complete v1.4.38. Process-gaps tracked: WIN-PG-2 (presence-only source-text test template field), STORY-INDEX-NARRATIVE-PG (manifest changelog has no consistency gate). Next: F3 human gate → F4. | Feature Mode / Windows-build F3 | Phase 3 | 2026-06-13 |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|---------------|
| F4 per-AC video demo (#475) | Yes — adapted | Test-only story, NO production behavior change (adds gated E2E coverage for existing converters). No offline-runnable live demo; evidence = offline hermetic verification (compile + gate guards + full suite green + --list) and nightly e2e.yml live run. Same handling as prior test-only E2E cycles (#493/#495). |
| S-WIN-2 per-AC demo | Yes — adapted | Debug/infra path-isolation seam; no user-visible behavior change (release builds ignore the seam). Evidence = hermetic test suite green (7 AC tests + dual-site release gate) + clippy/fmt. Same handling as test/infra-only stories DEC-075/076. |

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|

## Drift Items

<!-- OPEN and actively-watched items only. DEFERRED/LOW archived to cycles/cycle-001/burst-log.md "Archived Drift Items". -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| F-WIN2-C-101 | Integration-test scrub lists omit JR_CONFIG_DIR/JR_CACHE_DIR | S-WIN-2 seam makes ambient JR_CONFIG_DIR/JR_CACHE_DIR shadow XDG in integration tests; env_remove scrub lists + jr_isolated() must add both vars. CI risk nil (never set in CI). S-WIN-5 scope obligation. | MEDIUM | OPEN — wave-gate obligation (S-WIN-5) |
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
| F4-RESEARCH-GATE | Pre-implementation external-claim verification | C-V2(b)+C-V3 blockers found post-F3-convergence by research-agent; both fixed in spec before F4. Process lesson: add a primary-source research verification step before F4 on any cross-platform/infra cycle. | LOW | CODIFIED — DEC-082 lesson |
| WIN-PG-1 | No CI guard for inline-PROSE BC counts | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. Codify or justify deferral before cycle close. | LOW | OPEN — process-gap |
| WIN-PG-2 | Story-template lacks presence-only-test disclosure field | Across 5+ S-WIN stories non-integration ACs are source-text greps (presence-only); S-WIN-4/5 now self-disclose + name runtime gate, but no template field mandates the disclosure. Codify or justify-defer before cycle close. | LOW | OPEN — process-gap |
| STORY-INDEX-NARRATIVE-PG | STORY-INDEX Story Manifest changelog narrative has no consistency gate | Secondary changelog drifts independently of authoritative total_stories (was stale 58→59, fixed to 74 in F-WIN-F3-502). Codify only if recurs 3+ times. | LOW | DEFERRED — revisit at 3+ recurrences |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-13] F3 re-gate RE-AFFIRMED — DEC-082 corrections accepted; full-VSDD closure COMPLETE (v1.3.11 + 3-clean + re-gate). DEC-084. Pending: S-WIN-2 PR #505 merge decision, then S-WIN-3.** Prior: [2026-06-13] DEC-082 corrections RE-CONVERGED — spec-steward v1.3.11 + 3-clean adversarial (A/B/C) on S-WIN-3/S-WIN-4. Full-VSDD closure. Awaiting F3 re-gate. DEC-083. Prior: [2026-06-13] S-WIN-2 PR #505 OPEN → develop: CI 11/11 GREEN, AI review APPROVE, security no-blocking; release-gate empirically verified (--release E0080). PAUSED before merge per human. READY TO MERGE. Prior: [2026-06-13] Pre-F4 research verification: 2 BLOCKERS caught (C-V2b windows-sys 0.60 deny skip REQUIRED; C-V3 Compress-Archive not zip) + 4 propagation leaks, all fixed + re-verified clean. 4 claims + 2 prior corrections CONFIRMED. S-WIN-3/4/6 + ADR-0016 corrected. S-WIN-2 unaffected. DEC-082. Prior: [2026-06-13] S-WIN-2 impl CONVERGED (5-pass Step-4.5 per-story, security gate verified, cargo test green). Branch feat/win-2-config-cache-dir-seam @ b958e60. DEC-081. Prior: [2026-06-13] Windows-build F3 story-decomposition CONVERGED — 8-pass adversarial, 3-clean-pass P6/7/8 (6→5→2→2→2→0→0→0). Stories 74 authoritative. ADR-0016 Decisions 2/3 amended. DEC-080. [2026-06-12] Windows-build F1+F2 COMPLETE — BC 597 (+3) / NFR 42 (+1) / ADR 16 (+1). F2 adversary 14-pass 3-clean-pass. DEC-079.

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-13 |
| **Position** | **Windows-build F4 IN PROGRESS. F3 fully re-affirmed after DEC-082 closure (spec-steward v1.3.11 + 3-clean re-convergence + human re-gate). TWO pending human/next actions: (A) S-WIN-2 PR #505 merge decision (paused for review; CI 11/11, AI APPROVE, security clean → READY TO MERGE); (B) on merge: cleanup worktree + deliver S-WIN-3 (Wave 1, REQUIRED deny windows-sys 0.60 skip per DEC-082) → Wave 2 {S-WIN-1, S-WIN-4 [Compress-Archive], S-WIN-6} → Wave 3 {S-WIN-5; closes F-WIN2-C-101 scrub-list + WIN-O-3/O-4}. develop a7da775; S-WIN-2 branch feat/win-2-config-cache-dir-seam @ b958e60; active worktree .worktrees/S-WIN-2.** |
| **develop HEAD** | origin/develop = **a7da775** (PR #504 MERGED). activation v0.6.0-dev.1. BC **597**. NFR **42**. ADR **16**. Stories **74** (authoritative). 1 active worktree: .worktrees/S-WIN-2 (feat/win-2-config-cache-dir-seam @ b958e60). PR #505 OPEN. |
| **Convergence counter** | BC: **597**. NFR: **42**. ADR: **16**. Stories: **74** authoritative. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. 1 active worktree: .worktrees/S-WIN-2 (feat/win-2-config-cache-dir-seam @ b958e60). |
| **Next / Pending** | (1) S-WIN-2 PR #505 human merge decision; (2) then S-WIN-3 (deny 0.60 skip REQUIRED); (3) S-WIN-4 Compress-Archive; (4) S-WIN-5 closes F-WIN2-C-101; standing items unchanged. |
| **Resume prompt** | `Read .factory/STATE.md. DATE 2026-06-13; F3 RE-AFFIRMED (DEC-084, full-VSDD closure COMPLETE); PR #505 READY TO MERGE (human gate); S-WIN-3 next with REQUIRED [[bans.skip]] for windows-sys 0.60; S-WIN-4 Compress-Archive; develop a7da775; do NOT reintroduce zip-primary or if-needed deny skip; Stories 74; jira-e2e env JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #505 | S-WIN-2 JR_CONFIG_DIR/JR_CACHE_DIR debug seam (BC-6.2.017) | **MERGED → develop @ 1b84feb (squash, 2026-06-13). First Windows-build story shipped.** | — | Closed. |
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
