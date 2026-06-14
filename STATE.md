---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-14T00:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "Windows-build F5 CONVERGED at develop 2f96543 (14 passes / 5 fix PRs #511–#515; 3 clean: R12/R13/R14). Next: F6 targeted hardening."
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
| **Last Updated** | 2026-06-14: Windows-build F5 CONVERGED @ develop 2f96543 — 14 adversary passes (R1–R14), 5 fix PRs (#511–#515), 3 clean passes (R12/R13/R14). DEC-098. LESSON-ADVERSARY-CHECKOUT-RACE codified. Next: F6 targeted hardening. |
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
| Windows build (x86_64-pc-windows-msvc) | **F5 CONVERGED** (3 clean: R12/R13/R14 @ 2f96543) → next F6 | 2026-06-12 (F2) / 2026-06-13 (F3 gate) / 2026-06-14 (F4 COMPLETE + F5 CONVERGED) | F3 human gate APPROVED 2026-06-13; F4 COMPLETE (DEC-097); F5 CONVERGED (DEC-098) | develop @ 2f96543. F4: all 6 stories merged (#505–#510). F5: 14 passes / 5 fix PRs (#511–#515) / 0 CRIT/HIGH since R2 / LESSON-ADVERSARY-CHECKOUT-RACE (R11 VOID). Next: F6 (targeted hardening: formal-verify/fuzz/mutation scoped to Windows delta + security scan) → F7 → H-WIN-6. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->

| Step | Agent | Status | Output |
|------|-------|--------|--------|
| Windows-build F4 COMPLETE (6/6). PR #510 SQUASH-MERGED → develop @ 4bd83c7. Branch-protection drift RESOLVED (DEC-097). 0 active Windows worktrees. | Agent state-manager | F4 COMPLETE | develop @ 4bd83c7. BC 597 / Stories 74. |
| F5 R1–R5: 2 HIGHs (smoke step + Compress-Archive) → 2 findings (fail-closed + debug-gate) → 3 findings (OAuth verify + .gitattributes + deny.toml) → 0→0. Fix PRs #511, #512, #513 merged. | Agent adversary | R4+R5 CLEAN (2/3) | develop updated via #511/512/513. |
| F5 R6–R10: REGRESSION (CHANGELOG + figment guard) → 2 findings (ADR-0016 + OAuth guard) → 1 finding (OAuth -match) → 0→0. Fix PRs #514, #515 merged. | Agent adversary | R9+R10 CLEAN (2/3) | develop 2f96543 via #514/515. |
| F5 R11 VOID — checkout-race (concurrent git pull); reviewed stale code. LESSON-ADVERSARY-CHECKOUT-RACE codified. Re-run as R14. | Agent state-manager | VOID — re-run as R14 | develop 2f96543. |
| F5 R12 (regression/spec) CONVERGED + R13 (completeness) CONVERGED+COMPLETE + R14 (security/guard, "confirm HEAD SHA" guard) CONVERGED 0/0/0. Windows-build F5 CONVERGED. DEC-098. | Agent adversary | F5 CONVERGED (3/3 clean) | develop @ 2f96543. BC 597 / ADR 16. |

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

## Skip Log

All 7 S-WIN-1..6 + #475 per-AC demos: **Yes — adapted**. All are CI-config / infra / docs / test-only / platform-cfg stories with no user-visible runtime behavior on the macOS dev host. Evidence per story: hermetic test suite green + cross-compile + CI gate (AC-005/007 for S-WIN-5 = the windows-latest CI run itself). See `cycles/cycle-001/burst-log.md` for per-story justification rows.

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|

## Drift Items

<!-- OPEN and actively-watched items only. DEFERRED/LOW archived to cycles/cycle-001/burst-log.md "Archived Drift Items". -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| WIN-CI-GATE-AGGREGATOR | No ci-gate aggregator job | Add a single `ci-gate` job so future matrix changes never re-break branch protection. Follow-up story candidate (own PR). | LOW | OPEN — durable follow-up |
| WIN-CFG-TESTS-CHECK | Cross-compile must use --tests, not --lib | `cargo check --lib` excludes #[cfg(test)] blocks — use `--tests`. Surfaced by S-WIN-1 PR #507. | LOW | OPEN — process-gap |
| SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME env var not debug-gated | Unlike JR_BASE_URL/JR_AUTH_HEADER, readable in release builds. Follow-up story candidate. | LOW | OPEN — follow-up |
| WIN-DENY-FRAGILITY | deny.toml canonical-un-skipped-version has no CI guard | 17-entry skip set topology-dependent; future windows-sys update could silently break N-1 invariant. | LOW | OPEN — tracked process-gap |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK uses .lock().unwrap() in auth tests | Latent poison-cascade risk. Apply .unwrap_or_else(|e| e.into_inner()) uniformly. | LOW | OPEN — follow-up |
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

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-14] Windows-build F5 CONVERGED at develop 2f96543. 14 passes (R1–R14), 5 fix PRs (#511–#515), 3 clean: R12/R13/R14. Trajectory: 2→2→3→0→0→2(reset)→2→1→0→0→VOID→0→0→0. 0 CRIT/HIGH since R2. Security perimeter closed (figment re-entry machine-guarded). R11 VOID (checkout-race; LESSON-ADVERSARY-CHECKOUT-RACE codified). DEC-098. Next: F6 targeted hardening.** Prior: F4 COMPLETE (6/6) @ 4bd83c7; LESSON-MATRIX-BRANCH-PROTECTION (DEC-097).

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-14 |
| **Position** | **Windows-build F5 CONVERGED. develop @ 2f96543 (post-#515). 14 adversary passes (R1–R14, distinct lenses), 5 fix PRs (#511–#515). 3 clean: R12 (regression/spec), R13 (completeness+COMPLETE), R14 (security/guard 0/0/0 with confirm-HEAD-SHA protocol). R11 VOID (checkout-race; LESSON-ADVERSARY-CHECKOUT-RACE codified). Security perimeter (path-injection + figment re-entry) machine-guarded. DEC-098. 0 active worktrees (.worktrees/ empty).** |
| **develop HEAD** | origin/develop = **2f96543** (post-F5 fix PRs #511–#515). activation v0.6.0-dev.1. BC **597**. NFR **42**. ADR **16**. Stories **74** (authoritative). |
| **Convergence counter** | BC: **597**. NFR: **42**. ADR: **16**. Stories: **74** authoritative. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. 0 active worktrees (.factory + .reference only). |
| **Next / Pending** | (1) Windows-build F6 (targeted hardening: formal-verify/fuzz/mutation scoped to Windows delta + full-tree regression + security scan); (2) F7 (5-dim delta convergence + human gate); (3) H-WIN-6 live release-page holdout (push dev release tag, confirm jr-<ver>-x86_64-pc-windows-msvc.zip on GitHub Release page + runs on Windows); (4) WIN-CI-GATE-AGGREGATOR durable follow-up; (5) tracked LOWs: WIN-DENY-FRAGILITY, SEC-JR-SERVICE-NAME-GATE, WIN-AUTH-ENVLOCK-POISON, WIN-RUNTIME-OAUTH-PROBE (accepted ADR-0016), WIN-AC004-DIRECTIONAL; standing items. |
| **Resume prompt** | `Read .factory/STATE.md. Windows-build F5 CONVERGED at develop 2f96543 (DEC-098; 14 passes; 5 fix PRs #511–#515; 3 clean: R12/R13/R14). Security perimeter closed + machine-guarded. 0 active worktrees. Next: F6 targeted hardening (formal-verify/fuzz/mutation on Windows delta + security scan) → F7 (5-dim + human gate) → H-WIN-6 (release-page holdout). STANDING: do NOT close #429 (DEC-029); #492 OPEN; OQ-5 open; E2E-PG-4 open; SEC-001 LOW deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## RESUME PLAN (cold-start, self-contained)

### State snapshot

- Feature: Windows-build (cycle-001, Feature Mode F5 CONVERGED). All 6 stories MERGED to develop @ 2f96543 (post-F5 fix PRs #511–#515). F5: 14 passes, 5 fix PRs, 3 clean (R12/R13/R14), security perimeter closed. DEC-098. Counts BC 597 / NFR 42 / ADR 16 / Stories 74. 0 active worktrees.
- Next: Windows-build F6 → F7 (human gate) → H-WIN-6 holdout.

### STEP 3 — Windows-build cycle close

F5 CONVERGED (DEC-098). F6 (targeted hardening: formal-verify/fuzz/mutation scoped to the Windows delta + full-tree regression + security scan) → F7 (5-dimension delta convergence + final human gate).

### STEP 4 — H-WIN-6 holdout

Push a release tag (dev release via branch+PR per release-workflow rule), confirm jr-&lt;ver&gt;-x86_64-pc-windows-msvc.zip appears on the GitHub Release page AND runs on Windows (the .cargo/config.toml /STACK:8388608 fix means it won't stack-overflow).

### Durable follow-ups (tracked Drift Items)

WIN-CI-GATE-AGGREGATOR (add a single ci-gate aggregator job so matrix changes never re-break branch protection — own PR), WIN-AUTH-ENVLOCK-POISON (LOW), WIN-DENY-FRAGILITY (LOW), SEC-JR-SERVICE-NAME-GATE (LOW), SEC-WCM-DOC (CLOSED), WIN-SRC-UNITTEST-SEAM (CLOSED). Standing (non-Windows): #429 do-not-close, #492 OPEN, OQ-5, E2E-PG-4, F-H1, O1-TABLE-ASSERT, #400 Story B, #372.

### Process note

Full-VSDD run this cycle caught 3 classes invisible to the prior gate each time — pre-F4 research (windows-sys 0.60 / Compress-Archive), the integration gate (real jr.exe Windows stack-overflow prod bug), and repo-settings drift (branch protection). Lessons codified: LESSON-PRESENCE-ANCHOR, LESSON-WIN-CI-CHECKLIST, LESSON-INTEGRATION-GATE-PROD, LESSON-MATRIX-BRANCH-PROTECTION.

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #492 | fix(adf): block-HTML raw-\n invariant | OPEN — needs-sandbox. Raw-\n in literal-text paragraphs may not survive Jira REST round-trip. | LOW | No active cycle. |
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | #387: deferred; force-push needed. |
| #209/#210 | (backlog) | OPEN | — | |
| Merged: #510/509/508/507/475 | MERGED or CLOSED | Archived | — | See `cycles/cycle-001/blocking-issues-resolved.md` (#510) + `cycles/cycle-001/burst-log.md` "Archived Open Issues" (rest) |

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
