---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-16T12:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "Issue #492: F6 COMPLETE + F7 DELTA_CONVERGED (5/5). PR #521 @ 72fbcb9 HUMAN-AUTHORIZED merge (pending CI-green). Follow-up issue for pre-existing lone-CR defect being filed. DEC-108."
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
| **Last Updated** | 2026-06-16: Issue #492 F6 COMPLETE + F7 DELTA_CONVERGED (5/5). PR #521 @ 72fbcb9 human-authorized merge pending CI-green (DEC-108). Pre-existing lone-CR OOS defect pinned. BC 598 / NFR 42 / ADR 16 / Stories 75. |
| **Current Phase** | Phase 3 — TDD Implementation IN PROGRESS — #492 F7 CONVERGED / merge-pending. BC 598. NFR 42. ADR 16. Stories **75** (authoritative). |
| **Next Phase** | Phase 4: Holdout Evaluation (not started) |
| **Activation HEAD** | 4258202 (v0.6.0-dev.2 released 2026-06-14; v0.5.0 STABLE shipped 2026-06-12) |

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
| Windows build (x86_64-pc-windows-msvc) | **CYCLE CLOSED** — v0.6.0-dev.2 released + H-WIN-6 PASS | 2026-06-14 (F4+F5+F6+F7+RELEASE) | F4–F7 ALL COMPLETE; H-WIN-6 PASS; DEC-101 | develop @ 4258202 (#517). 14-pass F5; 9/9 mutants; 9 props; 0 vulns; 1808 green. jr-v0.6.0-dev.2-x86_64-pc-windows-msvc.zip + checksum verified. Smoke test ✓ windows-latest. |
| Issue #492 block-HTML hardBreak (BC-7.2.011) | **F6 COMPLETE + F7 CONVERGED — merge-pending** | F1–F7 ALL COMPLETE 2026-06-16 | 5/5 dims; 150k proptest cases; 100% mutation; 0 code defects | BC-7.2.011 v1.9.6; PR #521 @ 72fbcb9; human-authorized (pending CI-green); DEC-108 |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->

| Step | Agent | Status | Output |
|------|-------|--------|--------|
| S-CIGATE-1 (ci-gate aggregator) DELIVERED F1–F7. PR #518 squash-merged → develop @ e9b2269. ci-gate GREEN on PR+push CI run 27551871837 (live holdout proof). Step 4.5 4-pass CONVERGED (3 clean). F7 DELTA_CONVERGED. DEC-102. Stories 74→75. CIGATE-BRANCH-PROTECTION-SWAP pending human. | Agent state-manager | DELIVERED | develop @ e9b2269. BC 597 / NFR 42 / ADR 16 / Stories 75. |
| S-CIGATE-1 branch-protection swap COMPLETE + verified (develop+main now require single `CI Gate` context, app_id 15368; safe 2-step add-before-remove; user-executed). WIN-CI-GATE-AGGREGATOR CLOSED. Feature cycle CLOSED. DEC-103. | Agent state-manager | CYCLE CLOSED | develop @ e9b2269. BC 597 / NFR 42 / ADR 16 / Stories 75. |
| Fork-friendly-release-ops integrated: PR #520 squash-merged → develop @ 2cb219b (integrates closed #503 by @ArcavenAE, credited). 17 files inert-by-default; ci.yml Windows-matrix+ci-gate+gitleaks-v3 preserved; 14/14 CI GREEN incl CI Gate. 4-lens review done. Enablement decision PENDING (backfill/gap-fill/signing/suppress-phantom-runs — each needs fixes first). Full plan → `.factory/research/fork-release-ops-integration.md`. DEC-104. | Agent state-manager | PENDING-DECISION | develop @ 2cb219b. BC 597 / NFR 42 / ADR 16 / Stories 75. |
| Issue #492 bug-fix cycle OPENED (F1 delta analysis pending). DEC-105. Cycle artifacts: `cycles/cycle-001/issue-492/`. | Agent state-manager | OPEN | develop @ 2cb219b. |
| Issue #492: F6 targeted hardening COMPLETE (proptest prop_492_* — 3 properties, 150k executions, 5 invariants hold; mutation 7 total: 4 caught + 3 proven-equivalent = 100% effective; cargo audit 346 deps 0 advisories; cargo deny ok; 222 adf tests green; 1 OOS lone-CR defect pinned as #[ignore]d). F7 DELTA_CONVERGED 5/5 (consistency audit PASS-WITH-NOTES, 3 non-blocking deferred; input-drift PASS for #492 perimeter). PR #521 @ 72fbcb9 HUMAN-AUTHORIZED merge (pending CI-green). DEC-108. | Agent state-manager | F6+F7 CONVERGED | PR #521 OPEN @ 72fbcb9. merge-pending (human-authorized). BC 598 / NFR 42 / ADR 16 / Stories 75. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-063 | Phase 0/1/2 + Wave + Feature Mode decisions (multiple issues + dev releases). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-02 | archived |
| DEC-064..DEC-078 | JSM E2E (064..066), #471 taskList ADF F1..F6 (067..071), leading-dash fix (072), #475 E2E (073..076), v0.5.0-dev.14 + v0.5.0 STABLE releases (077..078). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 3 / 2026-06-02..12 | archived |
| DEC-079..085 | Windows-build F1..F4/S-WIN-2 decisions (F1+F2 gate, F3 CONVERGED, Pre-F4 research, VSDD-closure, F3 re-gate, S-WIN-2 MERGED). All archived. | See `cycles/cycle-001/burst-log.md` "Archived Decisions DEC-079..085" | Phase 3 | 2026-06-12..13 |
| DEC-086..092 | Windows-build F4 per-story decisions: S-WIN-3 CONVERGED+MERGED (deny.toml 17 entries), S-WIN-1 CONVERGED+MERGED (AppData paths), S-WIN-4 CONVERGED+MERGED (release.yml Compress-Archive), S-WIN-6 CONVERGED (docs fallout; WIN-O-3/O-4/SEC-WCM-DOC closed). All archived. | See `cycles/cycle-001/burst-log.md` "Archived Decisions DEC-086..092" | Phase 3 | 2026-06-13 |
| DEC-093 | 2026-06-14: S-WIN-6 MERGED → develop @ bc69c625 via squash PR #509. 5/6 stories shipped. Closed WIN-O-3/WIN-O-4/SEC-WCM-DOC. | Feature Mode / Windows-build F4 / S-WIN-6 | Phase 3 | 2026-06-14 |
| DEC-094 | 2026-06-14: S-WIN-5 F4 impl CONVERGED — 37-file XDG→JR seam migration, ci.yml windows test+clippy matrix, .gitattributes eol=lf, AC-004 per-call-site count guard. Step-4.5 3-clean after 4 fix rounds (R1 config/cache half-migration, R2 worklog, R3 separator, R4 CRLF+yaml). LESSON-WIN-CI-CHECKLIST codified. Counts unchanged. | Feature Mode / Windows-build F4 / S-WIN-5 | Phase 3 | 2026-06-14 |
| DEC-095 | 2026-06-14: S-WIN-5 windows-latest CI integration gate MET (ALL 13 GREEN). Caught real jr.exe Windows stack-overflow prod bug → .cargo/config.toml /STACK:8388608 fix. 4 CI iterations. LESSON-INTEGRATION-GATE-PROD + WIN-STACK codified. PR #510 READY TO MERGE (6/6). | Feature Mode / Windows-build F4 / S-WIN-5 | Phase 3 | 2026-06-14 |
| DEC-096 | 2026-06-14: PR #510 ALL 13 GREEN but BLOCKED — branch-protection drift: clippy→matrix rename made required context `Clippy` unsatisfiable (now `Clippy (ubuntu-latest)`/`(windows-latest)`). User-approved fix: PATCH develop+main required_status_checks to matrixed names + Test(windows-latest); repo-admin action (harness-blocked). Research: `.factory/research/branch-protection-matrix-required-checks.md`. LESSON-MATRIX-BRANCH-PROTECTION codified. | Feature Mode / Windows-build F4 / S-WIN-5 | Phase 3 | 2026-06-14 |
| DEC-097 | 2026-06-14: branch-protection drift RESOLVED — PATCH develop+main required_status_checks to matrixed contexts (app_id 15368: Format, Clippy (ubuntu-latest), Clippy (windows-latest), Test (ubuntu-latest), Test (macos-latest), Test (windows-latest), MSRV (1.85.0), Deny (licenses + vulnerabilities)); stale `Clippy` removed; require_code_owner_reviews preserved (scoped endpoint). PR #510 mergeStateStatus BLOCKED → CLEAN; SQUASH-MERGED → develop @ 4bd83c7. Windows-build F4 COMPLETE (6/6). WIN-BRANCH-PROTECTION RESOLVED. Archived to cycles/cycle-001/blocking-issues-resolved.md. | Feature Mode / Windows-build F4 / S-WIN-5 | Phase 3 | 2026-06-14 |
| DEC-098 | 2026-06-14: Windows-build F5 CONVERGED at develop 2f96543 after 14 adversary passes (R1–R14, fresh-context, distinct lenses) + 5 fix PRs (#511–#515). Security perimeter (path-injection/token-redirection via JR_CONFIG_DIR/JR_CACHE_DIR + figment re-entry) provably closed and machine-guarded (test_global_config_struct_has_no_path_override_field). R6-002 figment re-entry invariant RESOLVED. 3 clean passes: R12 (regression/spec), R13 (completeness), R14 (security/guard, with "confirm HEAD SHA" protocol). R11 VOID (checkout-race; LESSON-ADVERSARY-CHECKOUT-RACE codified). Counts unchanged: BC 597 / NFR 42 / ADR 16 / Stories 74. Residual LOWs accepted: WIN-RUNTIME-OAUTH-PROBE, WIN-AC004-DIRECTIONAL. Next: F6 targeted hardening. | Feature Mode / Windows-build F5 | Phase 3 | 2026-06-14 |
| DEC-099 | 2026-06-14: Windows-build F6 COMPLETE — FIX-F6-001 MERGED → develop @ fac555f41d via squash PR #516. Proptest property suite (9 properties, 2048 cases each, ~10k generated inputs) formally verifies BC-6.1.014 EC-1/EC-3 + BC-6.2.016 EC-1/EC-4 invariants on pure path-fallback helpers. Kani OOM on PathBuf equality — proptest substituted (tractability probe recorded). Security review APPROVED (0 CRIT/HIGH/MEDIUM/LOW). AI review APPROVED cycle 1. 13/13 CI GREEN (including Test (windows-latest)). Mutation 100% kill on delta. Test-only, no production code changes. Counts unchanged: BC 597 / NFR 42 / ADR 16 / Stories 74. Next: F7 convergence check. | Feature Mode / Windows-build F6 | Phase 3 | 2026-06-14 |
| DEC-100 | 2026-06-14: Windows-build F7 (delta convergence) CONVERGED + HUMAN-AUTHORIZED at develop fac555f. 5/5 dimensions pass: Dim1 Spec (F5 14-pass CONVERGED, novelty→0; ADR-0016/PRD/CHANGELOG synced); Dim2 Test (100% delta mutation kill 9/9; R5-001+R8-001 guard tests; +9-property suite #516); Dim3 Impl (0 CRIT/HIGH since R2; all findings resolved via PRs #511–#516; adversary findings were real); Dim4 Verif (9 proptest props PASS; Kani justified-skip OOM; fuzz justified-skip; cargo audit 0 vulns; cargo deny ok; purity boundaries intact); Dim5 Holdout PASS-on-automatable (windows-latest CI green; release.yml smoke + OAuth-verify; /STACK:8388608 prod-crash fix); H-WIN-6 live release-page holdout deferred to post-release. Zero regressions (1808/0 on fac555f). Consistency CLEAN (FINDING-001 fixed @ ba1fc1a). OBS-001 LOW deferred: 6 S-WIN stories still status:ready — optional hygiene, matches project convention. Next: release (version bump via branch+PR; suggest v0.6.0-dev.2 dev release to validate release.yml Windows matrix first-time) → H-WIN-6 live holdout. | Feature Mode / Windows-build F7 | Phase 3 | 2026-06-14 |
| DEC-101 | 2026-06-14: Windows-build feature cycle CLOSED. v0.6.0-dev.2 released (#517 squash-merged → develop @ 4258202; release.yml run 27519999184 SUCCESS). H-WIN-6 live holdout PASS: jr-v0.6.0-dev.2-x86_64-pc-windows-msvc.zip on GitHub Release page; local checksum verify = OK; smoke test `.\jr.exe --version` PASS on windows-latest (/STACK:8388608 fix validated, no stack overflow); Embedded OAuth verification PASS (Windows). S-7.02 cycle-closing checklist complete: 1 lesson codified (LESSON-ADVERSARY-CHECKOUT-RACE), 6 items deferred with rationale (WIN-RUNTIME-OAUTH-PROBE, WIN-AC004-DIRECTIONAL, WIN-DENY-FRAGILITY, SEC-JR-SERVICE-NAME-GATE, WIN-CI-GATE-AGGREGATOR, OBS-001), 1 resolved confirmed (R6-002 figment re-entry). No active feature. Awaiting next directive. | Feature Mode / Windows-build CYCLE CLOSE | Phase 3 | 2026-06-14 |
| DEC-102 | 2026-06-15: WIN-CI-GATE-AGGREGATOR delivered via S-CIGATE-1 quick-dev (PR #518 @ e9b2269). ci-gate aggregator job (`name: CI Gate`; `needs: [fmt, clippy, test, msrv, deny, spec-guard]`; `if: ${{ always() }}`; step fails on `contains(needs.*.result,'failure'/'cancelled')`) is the durable fix for the matrix-rename branch-protection fragility class (DEC-096/097). Code shipped: `.github/workflows/ci.yml` ci-gate job + `tests/ci_gate_completeness.rs` (6 drift tests) + CLAUDE.md Conventions bullet + ADR-0016 Decision 3 note. REMAINING: human/repo-admin branch-protection swap to make `CI Gate` (app_id 15368) the single required context on develop+main (precondition met: ci-gate green on develop push). | Feature Mode / S-CIGATE-1 / ci-infra | Phase 3 | 2026-06-15 |
| DEC-103 | 2026-06-15: WIN-CI-GATE-AGGREGATOR cycle CLOSED. Branch-protection swapped to single `CI Gate` context on develop+main (app_id 15368; safe 2-step add-before-remove; user-executed; verified). The matrix-rename fragility class (DEC-096/097) is now structurally eliminated — required-check membership lives in `ci-gate.needs` in ci.yml, not in repo settings. spec-guard promoted to a blocking check via the aggregator (user decision). S-CIGATE-1 feature cycle CLOSED. | Feature Mode / S-CIGATE-1 / ci-infra | Phase 3 | 2026-06-15 |
| DEC-104 | 2026-06-15: Integrated @ArcavenAE's fork-friendly release-ops (PR #503→#520 @ 2cb219b). Merged from canonical (fork unpushable; Co-authored-by credit added). Machinery inert by default (all new jobs gated on unset repo vars; ~7 phantom workflow runs/day accepted). 4-lens review done (security/code/consistency/adversary; first adversary pass discarded as confabulated, re-run fresh). Enablement of selected pieces deferred — each requires its security/quality fixes first. Full plan + findings: `.factory/research/fork-release-ops-integration.md`. | ci-infra / external-contribution | Phase 3 | 2026-06-15 |
| DEC-105 | 2026-06-15: Opened VSDD Feature-Mode bug-fix cycle for issue #492 (block-HTML raw-\\n violates adf.rs file-wide newline-free invariant; F5-retrospective finding from #489/#490). Routes as bug-fix: fix story + mandatory regression test + scoped holdout + compressed F5/F6/F7 → PATCH. Core F-1 decision (hardBreak-split vs collapse-to-space vs sandbox-confirm) deferred to F1/F2 + human gate. Artifacts: `cycles/cycle-001/issue-492/`. | Feature Mode / #492 bug-fix | Phase 3 | 2026-06-15 |
| DEC-106 | 2026-06-16: Issue #492 F2 spec evolution CONVERGED. BC-7.2.011 (block-HTML→ADF hardBreak interior-newline mapping) evolved v1.2.0→v1.9.1 across ~12 fresh-context adversarial passes (multi-lens parallel: algorithm/EC, code-drift, consistency/implementer). Substantive findings burned down: CRITICAL algorithm A→B ambiguity; HIGH impossible href autolink example + CRLF split double-count; MED count-prose drift + byte-identity reverse-trim_end overclaim (FRESH-02) + byte-identity forward trailing-newline overclaim (FRESH-04); plus LOW wording/annotation polish to a fully-harmonized 6-EC byte-identity annotation set. Byte-identity round-trip claim made EXHAUSTIVE (5 conditions; forward-path: CR-normalize/step3, leading-trim/step5b, trailing-newline/step2, autolink/post-pass; reverse-path: final-whitespace/finish-trim_end) — completeness confirmed exhaustive (no 6th mechanism) by multiple passes. Final scoped pass on frozen v1.9.1 (634cb88) = CLEAN. Counts unchanged: BC 598 / bc-7 90/44 / Stories 75. Human-approved fix direction = Option a (hardBreak split). Cycle artifacts: cycles/cycle-001/issue-492/. | Feature Mode / #492 F2 spec | Phase 3 | 2026-06-16 |
| DEC-107 | 2026-06-16: Issue #492 F5 scoped adversarial CONVERGED. 15 fresh-context passes / 6 fix rounds / final 3 clean (Pass 13 deep cross-consistency, Pass 14 holistic+traceability+counts, Pass 15 robustness+completeness) on frozen 8062b78 + BC-7.2.011 v1.9.6 @ factory-artifacts 87e3c53. ZERO production-code defects — single Algorithm B path proven correct ~12x across all lenses; all findings were doc/spec precision (severity decayed M→L→0). BC version trail: v1.9.1→v1.9.2→v1.9.3→v1.9.4→v1.9.5→v1.9.6. PR #521 pushed. Next: F6 targeted hardening. | Feature Mode / #492 F5 | Phase 3 | 2026-06-16 |
| DEC-108 | 2026-06-16: Issue #492 F6 hardening COMPLETE (proptest 5-invariant suite, 150k cases; mutation 100% effective, 3 equivalent; cargo audit 346 deps 0 advisories; cargo deny ok; full suite 222 adf green) + F7 DELTA_CONVERGED 5/5 (consistency audit PASS-WITH-NOTES, 3 non-blocking deferred; input-drift PASS for #492 perimeter). Human-authorized merge of PR #521 @ 72fbcb9 (pending CI green). F6 surfaced pre-existing OOS lone-CR defect (heading/codeBlock via generic Event::Text path; pulldown-cmark CR-normalization gap) — follow-up issue filed, #[ignore]d test test_lone_cr_survives_pre_existing_492_oos pinned. NOT a #492 regression. | Feature Mode / #492 F6+F7 | Phase 3 | 2026-06-16 |

## Skip Log

All 7 S-WIN-1..6 + #475 per-AC demos: **Yes — adapted**. All are CI-config / infra / docs / test-only / platform-cfg stories with no user-visible runtime behavior on the macOS dev host. Evidence per story: hermetic test suite green + cross-compile + CI gate (AC-005/007 for S-WIN-5 = the windows-latest CI run itself). See `cycles/cycle-001/burst-log.md` for per-story justification rows.

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|
| *(no open blocking issues)* | — | — | — |

## Drift Items

<!-- OPEN and actively-watched items only. DEFERRED/LOW archived to cycles/cycle-001/burst-log.md "Archived Drift Items". -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| WIN-CI-GATE-AGGREGATOR | ci-gate aggregator job | CLOSED — CODE SHIPPED (PR #518 @ e9b2269) AND ACTIVATED (branch-protection swap 2026-06-15; single `CI Gate` required check on develop+main; app_id 15368; DEC-103). Matrix-rename fragility class structurally eliminated. | LOW | CLOSED — DEC-103 |
| FORK-OPS-SIGN-INJECTION | `sign-and-publish.yml` shell injection | `workflow_run.head_branch` written unsanitized into shell with Apple secrets (CWE-77, SEC-001/CR-001). Validate `^v…` pattern before any shell step. Blocks signing enablement. | HIGH | OPEN — gates signing |
| FORK-OPS-ALPHA-RACE | Alpha-tag read-then-create race | `sign-and-publish.yml` non-atomic alpha tag: reads current then creates — concurrent runs make duplicates (CR-002). Use `git rev-parse --short HEAD`. Blocks signing enablement. | HIGH | OPEN — gates signing |
| FORK-OPS-BACKFILL-DESTRUCTIVE | `release-gap-fill.yml` blast radius | `gh release delete`+recreate can clobber curated notes if enabled on wrong repo/tag. Add "existing release?" guard + `github.repository==` check. Blocks gap-fill enable. | MED | OPEN — gates gap-fill |
| FORK-OPS-PHANTOM-RUNS | ~7 phantom workflow runs/day | New schedule/push triggers create skipped runs on canonical (~7/day). Cosmetic; decide suppress or accept. | LOW | OPEN — decide |
| FORK-OPS-GITLEAKS-DOC | `GITLEAKS_DISABLED` undocumented | Secret-scan opt-out variable added to ci.yml but not documented in CLAUDE.md or spec. | MED | OPEN — doc gap |
| FORK-OPS-BACKFILL-WIN-TARGET | `backfill-release.yml` missing Windows | `x86_64-pc-windows-msvc` target absent → backfilled releases lack Windows binary. Fix before using. | MED | OPEN — fix before enabling |
| WIN-CFG-TESTS-CHECK | Cross-compile must use --tests, not --lib | `cargo check --lib` excludes #[cfg(test)] blocks — use `--tests`. Surfaced by S-WIN-1 PR #507. | LOW | OPEN — process-gap |
| SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME env var not debug-gated | Unlike JR_BASE_URL/JR_AUTH_HEADER, readable in release builds. Follow-up story candidate. | LOW | OPEN — follow-up |
| WIN-DENY-FRAGILITY | deny.toml canonical-un-skipped-version has no CI guard | 17-entry skip set topology-dependent; future windows-sys update could silently break N-1 invariant. | LOW | OPEN — tracked process-gap |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK uses .lock().unwrap() in auth tests | Latent poison-cascade risk. Apply .unwrap_or_else(|e| e.into_inner()) uniformly. | LOW | OPEN — follow-up |
| #492-F4-IMPL | F4 implementation carry-forward | RESOLVED — F4 COMPLETE (Algorithm B, 13 block-HTML tests, docs/specs/adf-block-html.md, PR #521 @ 8062b78). | n/a | RESOLVED — F4 DONE |
| PRE-EXISTING-LONE-CR | heading+codeBlock raw `\r` survival | pulldown-cmark CR-normalization gap: lone `\r` (no `\n`) passes through `Event::Text → push_text` into heading/codeBlock text nodes. JSON-level hazard. NOT introduced by #492 (Algorithm B path proven CR-free). Pinned: `#[ignore]`d `test_lone_cr_survives_pre_existing_492_oos`. Follow-up issue filed (human-authorized). | MED | OPEN — follow-up issue filed |
| F7-001 | CLAUDE.md 'symmetric' wording | CLAUDE.md description-echo section uses 'symmetric'/'asymmetric' wording with minor precision gap noted in F7 consistency audit. Non-blocking cosmetic. Deferred to next CLAUDE.md edit. | LOW | ACCEPTED-DEFERRED (F7 non-blocking) |
| F7-002 | F2-record archival note | cycles/cycle-001/issue-492/f2-convergence.md archival notation note from F7 audit. No functional gap; reference file exists. | LOW | ACCEPTED-DEFERRED (F7 non-blocking) |
| F7-003 | BC-7.2.011 "13 tests" phrasing | BC-7.2.011 body uses "13 tests" — acceptable per check-bc-no-numeric-test-counts.sh qualitative policy (PG-365-1); no change required. | LOW | ACCEPTED-DEFERRED (F7 non-blocking) |
| #492-TEST-HARNESS-COUPLING | process-gap (F-P1-003) | Handler-level block-HTML tests (EC-6/7/8/9/10) construct AdfBuilder directly and couple to push_text accumulation shape; re-validate if that accumulation path is refactored. Adversary verdict: process-gap, no code change required. | LOW | OPEN — cycle-close codification candidate |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. Must be PHASE-AWARE (pre-impl BCs legitimately cite not-yet-created tests) to avoid false-positives on in-flight BCs. Candidate: scripts/check-bc-trace-tests-exist.sh gated on cycle status. | LOW | OPEN — cycle-close codification candidate |
| OQ-5 | CLAUDE.md NFR-O-N stale | auth status --output json documented but not implemented in src. | LOW | OPEN — doc drift |
| E2E-PG-4 | E2E coverage gap | REMAINING: remote-link round-back (no `jr remote-link read`). | LOW | OPEN |
| DRIFT-331-PAGINATION | get_issue_types_for_project pagination | Inline reimplementation; target: reuse OffsetPage<T>. Deferred. | LOW | OPEN |
| PG-A / DRIFT-README | Count guards + README.md stale | check-bc-cumulative-counts.sh misses README.md; Document Map grand total 573 vs canonical 587. Deferred. | LOW | OPEN |
| SEC-001 | CWE-674 deep-nesting recursion in adf.rs | Uncontrolled recursion in normalize/assign_local_ids/render_node. Deferred. | LOW | OPEN |
| WIN-PG-1 | No CI guard for inline-PROSE BC counts | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Story-template lacks presence-only-test disclosure field | Anchoring aspect resolved by LESSON-PRESENCE-ANCHOR; template-field disclosure remains open. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Windows release OAuth verification is constants-file check only | Unix `jr auth status` runtime probe not yet ported to Windows. Documented & accepted in ADR-0016 Decision 5c amendment (DEC-098). Follow-up candidate. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | XDG→JR seam-migration enforcement test has directional blind spot | ci_yml_windows_matrix.rs test uses count-equality for in-process set_var; subprocess .env() sites have looser presence-only check. Narrow, documented. | LOW | OPEN — tracked process-gap |
| Closed: SEC-WCM-DOC / F-WIN2-C-101 / WIN-SRC-UNITTEST-SEAM / WIN-O-3 / WIN-O-4 / WIN-BRANCH-PROTECTION / R6-002 (figment re-entry) | CLOSED in S-WIN-5/6 / DEC-097 / F5 #514 | See `cycles/cycle-001/blocking-issues-resolved.md` | — | CLOSED |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-16] Issue #492 F6 COMPLETE + F7 DELTA_CONVERGED 5/5. proptest 150k cases (5 invariants hold); mutation 100% effective; cargo audit/deny clean; 222 adf green. Consistency audit PASS-WITH-NOTES (3 non-blocking deferred). Input-drift PASS for #492 perimeter. PR #521 @ 72fbcb9 human-authorized merge (pending CI-green). DEC-108.** Prior: F5 CONVERGED DEC-107 (15 passes / 3 clean / 0 code defects). Stories 75. BC 598.

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-16 |
| **Position** | **Issue #492 at F7-CONVERGED / merge-pending. PR #521 @ 72fbcb9 HUMAN-AUTHORIZED (pending CI-green). BC-7.2.011 v1.9.6. develop @ 2cb219b. Worktree .worktrees/S-492 @ 72fbcb9 (branch fix/adf-block-html-hardbreak-492).** |
| **develop HEAD** | origin/develop = **2cb219b** (fork-release-ops PR #520). activation v0.6.0-dev.2. BC **598**. NFR **42**. ADR **16**. Stories **75** (authoritative). |
| **Convergence counter** | BC: **598**. NFR: **42**. ADR: **16**. Stories: **75** authoritative. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. Active worktree: .worktrees/S-492 @ 72fbcb9. |
| **Next / Pending** | Await CI-green on PR #521 → human merge → close #492 → clean worktree. Pre-existing lone-CR follow-up issue pending filing. Fork-release-ops enablement PENDING (DEC-104). Standing drift: WIN-DENY-FRAGILITY (LOW), SEC-JR-SERVICE-NAME-GATE (LOW), WIN-AUTH-ENVLOCK-POISON (LOW), WIN-RUNTIME-OAUTH-PROBE (LOW, accepted ADR-0016), WIN-AC004-DIRECTIONAL (LOW), #492-TEST-HARNESS-COUPLING (LOW), PRE-EXISTING-LONE-CR (MED). Open issues: #492 (merge-pending), #429 (DNC), #400 Story B, #372. |
| **Resume prompt** | `Read .factory/STATE.md. Issue #492 F6+F7 CONVERGED (DEC-108). PR #521 @ 72fbcb9 HUMAN-AUTHORIZED merge (pending CI-green). BC-7.2.011 v1.9.6. develop @ 2cb219b. Worktree .worktrees/S-492 @ 72fbcb9. On CI-green: merge #521 → close #492 → clean worktree. Pre-existing lone-CR OOS follow-up issue pending. STANDING: do NOT close #429 (DEC-029); OQ-5 open; E2E-PG-4 open; SEC-001 LOW deferred. Fork-release-ops enablement PENDING (DEC-104). jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## RESUME PLAN (cold-start, self-contained)

### State snapshot

- Issue #492: F1–F7 ALL COMPLETE. F6 COMPLETE (proptest 5-inv suite 150k cases; mutation 100% effective; audit/deny clean). F7 DELTA_CONVERGED 5/5 (consistency audit PASS-WITH-NOTES; 3 non-blocking deferred; input-drift PASS for #492 perimeter). DEC-108. PR #521 @ 72fbcb9 HUMAN-AUTHORIZED (pending CI-green). develop @ 2cb219b. Worktree .worktrees/S-492 @ 72fbcb9 active.
- Pre-existing OOS lone-CR defect surfaced by F6 — pinned as #[ignore]d test; follow-up issue being filed.
- Prior: Fork-release-ops PR #520 squash-merged → develop @ 2cb219b (integrates closed #503 by @ArcavenAE; DEC-104). Machinery inert by default. BC 598 / NFR 42 / ADR 16 / Stories 75.
- Next: await CI-green → merge #521 → close #492 → clean worktree. Then: fork-release-ops enablement decision (read `.factory/research/fork-release-ops-integration.md`).

### Durable follow-ups (tracked Drift Items)

WIN-AUTH-ENVLOCK-POISON (LOW), WIN-DENY-FRAGILITY (LOW), SEC-JR-SERVICE-NAME-GATE (LOW), WIN-RUNTIME-OAUTH-PROBE (LOW, accepted ADR-0016), WIN-AC004-DIRECTIONAL (LOW), #492-TEST-HARNESS-COUPLING (LOW, cycle-close codification candidate), PRE-EXISTING-LONE-CR (MED, follow-up issue filed). Standing (non-Windows): #429 do-not-close, OQ-5, E2E-PG-4, #400 Story B, #372.

### Process note

Full-VSDD run caught 3 classes invisible to the prior gate each time — pre-F4 research (windows-sys 0.60 / Compress-Archive), the integration gate (real jr.exe Windows stack-overflow prod bug), and repo-settings drift (branch protection). Lessons codified: LESSON-PRESENCE-ANCHOR, LESSON-WIN-CI-CHECKLIST, LESSON-INTEGRATION-GATE-PROD, LESSON-MATRIX-BRANCH-PROTECTION, LESSON-ADVERSARY-CHECKOUT-RACE. #492: single Algorithm B path proven correct across 15 F5 passes (M→L→0 severity decay); F6 proptest 150k cases + 100% effective mutation; F6 also surfaced pre-existing lone-CR OOS defect (pinned #[ignore]d).

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #492 | fix(adf): block-HTML raw-\n invariant | OPEN — F6+F7 CONVERGED; PR #521 @ 72fbcb9 merge-pending (human-authorized, pending CI-green). | LOW | DEC-108. Cycle: cycles/cycle-001/issue-492/. |
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | #387: deferred; force-push needed. |
| #209/#210 | (backlog) | OPEN | — | |
| #520 | ci: opt-in release ops (fork-friendly) | MERGED @ 2cb219b (develop). Integrates #503. Inert by default. | LOW | Enablement decision PENDING — see DEC-104 + research file. |
| #503 | External fork contribution by @ArcavenAE | CLOSED (integrated via #520; Co-authored-by credit in squash commit; credit comment left on PR #503). | — | CLOSED — no further action. |
| Merged: #518/517/510/509/508/507/475 | MERGED or CLOSED | Archived | — | See `cycles/cycle-001/blocking-issues-resolved.md` (#510) + `cycles/cycle-001/burst-log.md` "Archived Open Issues" (rest) |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-027..092 + archived phase rows + archived drift items + archived closed issues | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
