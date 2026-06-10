---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-10T12:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "#471 GFM task lists → ADF — Feature Mode F1/F2/F3 COMPLETE, awaiting F3 human approval gate before F4 TDD. BC-7.2.010 authored (corpus 593→594). Story S-471 created (Stories 66→67, 18 ACs, 19 named tests, net +18 adf::tests, baseline 155). F2 converged 8 passes (5/6/7/8 clean); F3 story converged (6/7/8 clean). F4-conditional blockquote dependency RESOLVED at spec time via research (pulldown-cmark 0.13.3 emits blockquote>taskList → normalization arm unconditional). No code yet."
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
| **Repository** | /Users/zious/Documents/GITHUB/jira-cli |
| **Mode** | BROWNFIELD |
| **Language** | Rust |
| **Target Workspace** | develop → main |
| **Started** | 2026-05-04 |
| **Last Updated** | 2026-06-10 — #471 GFM task lists → ADF Feature Mode F1/F2/F3 COMPLETE, awaiting F3 human gate. BC-7.2.010 authored (BC 593→594). S-471 story created (Stories 66→67, 18 ACs, 19 named tests). F2 8-pass adversarial convergence (clean 5/6/7/8). F3 8-pass story convergence (clean 6/7/8). F4-conditional blockquote dependency resolved at spec time. No code yet. DEC-067/068/069. |
| **Current Phase** | Phase 3 — TDD Implementation IN PROGRESS — Feature Mode active. #471 F1/F2/F3 COMPLETE, awaiting F3 human gate before F4. BC 594. NFR 41. Stories 67. |
| **Next Phase** | Phase 4: Holdout Evaluation (not started) |
| **Activation HEAD** | 15bf305 (v0.5.0-dev.11) |

## Pipeline Goal

Goal 1c: **Harden v0.5 + feature delivery** — formalize existing codebase with VSDD specs, holdouts, and verification; AND use VSDD pipeline for all post-v0.5.0 feature work.

## Phase Progress

| Phase | Status | Completed | Gate | Finding Progression |
|-------|--------|-----------|------|---------------------|
| pre-pipeline: Setup | COMPLETE | 2026-05-04 | env-preflight | |
| 0: Codebase Ingestion | COMPLETE | 2026-05-04 | Phase A+B+B.5+B.6+C+gate APPROVED | |
| 1: Spec Crystallization | COMPLETE | 2026-05-04 | PASSED — DEC-006/007/008, gate APPROVE | |
| 1d: Adversarial Spec Review | COMPLETE — 3/3 CONVERGED at Pass 28 | 2026-05-04 | 3/3 FULL CONVERGENCE | 30→15→9→5→10→5→4→3→4→0→2→0→3→0→2→0→3→0→3→5→3→4→5→5→5→2→0→0→0 |
| 1-gate-prep: Consistency Validation | COMPLETE | 2026-05-06 | DEC-006/007/008 resolved; ADR-0013 created | CV: 4H/1M; all fixed |
| 2: Story Decomposition | COMPLETE | 2026-05-06 | 31 stories; Phase 2-adv pending | |
| 2-adv: Adversarial Story Review | CONVERGED — Pass 13 CLEAN | 2026-05-07 | 3/3 FULL CONVERGENCE | 14→5→5→5→4→5→4→4→4→1→0→1→0 |
| Phase 2 gate | APPROVED | 2026-05-07 | APPROVED by human | |
| 3: TDD Implementation | IN_PROGRESS — Wave 0/1/2/3 ALL COMPLETE (32/32). Feature Mode active. | — | — | Wave cadence complete; Feature Mode ongoing |
| 3-adv: Wave Adversarial Reviews | WAVE 2 GATE CLOSED 2026-05-08 | 2026-05-08 | GATE-PASSES (consistency pass-02 `8ae5511`) | adv pass-01: 12 findings; fix-PRs A+B+WV2-SEC-01+pass-02 |
| Feature Mode issues #110/#332..#346/#350..#367/#369..#373/#382..#388/#392/#396..#399/#407 | ALL COMPLETE | 2026-05-26 | F1–F7 ALL COMPLETE — CYCLE CONVERGED | F5: 3/3 CLEAN at P4. F6: 100% mutation kill. Regression 1483/0. |
| issue-331 (issueType bulk-edit wire schema fix — PR #453 + live-fix #454+#455) | CYCLE CLOSED + LIVE-GREEN — PR #455 → develop @ f418bf5; run 26779732719 66/0; #331 CLOSED | 2026-06-01 | F1–F7 ALL COMPLETE — CYCLE CONVERGED + LIVE-VALIDATED | F5: 3/3 CLEAN (P5/P6/P7; 7 findings fixed). F6: 91.7% mutation. Regression 1568/0. Live run 26777755130 (65/1) caught createmeta schema defect → fixed #454+#455 → live run 26779732719 (66/0) GREEN. |
| E2E fork-safe CI enablement (`JR_E2E_ENABLED` repo-var gate + README badge) — S-E2E-FORK-1 | **CYCLE CLOSED + LIVE-GREEN** — PR #459 → develop @ afa12570; run 26793560680 = 67/0 (2026-06-02). JR_E2E_ENABLED=true repo variable set. 7 files: e2e.yml, e2e-sweeper.yml, README.md, CLAUDE.md, CHANGELOG.md, docs/specs/e2e-fork-safe-ci-enablement.md, e2e-live-jira-testing.md. | 2026-06-02 | F1–F7 ALL COMPLETE — CYCLE CONVERGED + LIVE-GREEN (DEC-063) | F5: sibling-omission→fix→off-branch-spec→fix→polish-idiom-drift→sweep→CLEAN×3. VER-E2E-FORK-1..4 all confirmed. BC: 585 unchanged. NFR: 41 unchanged. No formal VP-NNN (zero Rust). |
| JSM E2E coverage expansion — S-JSM-E2E-1 | CYCLE CLOSED + LIVE-VALIDATED (2026-06-02). PR #460 → develop @ 04b6b2c. 7 JSM scenarios live-green (run 26839267723). JR_E2E_JSM_PROJECT=EJ ACTIVE. | F1–F7 COMPLETE | DEC-064/065. BC: 585. |
| JSM teardown fix — S-JSM-E2E-2 | CYCLE CLOSED + MERGED (2026-06-02). PR #464 → develop @ 176215e. jsm_self_close dynamic close-transition. | F1–F7 COMPLETE | BC: 585. |
| JSM resolution enforcement (SRC) — S-JSM-RESOLUTION-REQUIRED | CYCLE CLOSED + MERGED + LIVE-GREEN (2026-06-03). PR #465 → develop @ 8ec9527. BC-3.2.013. F6: 27/27 killed. Live: 73/0. | F1–F7 COMPLETE | DEC-066. BC: 585. |
| ADF listItem content-model — issue #470 / BC-7.2.006 | CYCLE CLOSED + MERGED (2026-06-08). PR #477 → develop @ aa602a1. BC-7.2.006. | F1–F7 COMPLETE | BC: 587 (+1). |
| ADF minor constructs — issue #474 / BC-7.2.007+008 | CYCLE CLOSED + MERGED (2026-06-09). PR #486 → develop @ 56226b4. subsup + heading-attr. | F1–F7 COMPLETE | BC: 592 (+2). |
| GFM alerts → ADF panel — issue #483 / BC-7.2.009 | CYCLE CLOSED + MERGED (2026-06-09). PR #487 → develop @ 87a15ad. BC-7.2.009. 18 tests; 132 adf::tests. | F1–F7 COMPLETE | BC: 593 (+1). |
| ADF unit-test gap fill — issue #476 (test-only) | CYCLE CLOSED + MERGED (2026-06-09). PR #488 → develop @ d0bbb70. 3 pinning tests (127→130). Zero src. | CYCLE CLOSED | BC 593 / NFR 41 / Stories 66. |
| ADF block-level HTML — issue #489 (bug fix) | CYCLE CLOSED + MERGED (2026-06-10). PR #490 → develop @ 13978ce. NodeKind::HtmlBlock: literal-text paragraph. 3 tests (130→132). | CYCLE CLOSED | BC 593 unchanged. |
| bare-URL autolink E2E coverage — issue #473 follow-up (PR #493) | CYCLE CLOSED + MERGED (2026-06-10). PR #493 → develop @ 8b639c1. test_e2e_markdown_bare_url_produces_link_mark + adf_has_linked_url. PG-REVIEW-1 + PG-E2E-1 codified. | CYCLE CLOSED | BC 593 / NFR 41 / Stories 66 UNCHANGED. |
| GFM task lists → ADF taskList node — issue #471 / BC-7.2.010 | **F1/F2/F3 COMPLETE — awaiting F3 human gate** (2026-06-10). F1 delta analysis: 12 ECs (EC-1..12 subset; BC body authoritative at EC-1..16). F2 spec evolution: BC-7.2.010 authored; 8-pass adversary convergence (P1: 1C/4H/4M/3L → P2: 1C/6H/4M/1L new schema-validity errors caught → P3: 4M/4L → P4: 3M/1L → P5/6/7/8 clean); blockquote-taskList dependency resolved via pulldown-cmark 0.13.3 source-read (spec-changelog [1.3.5]). F3 story: S-471 (Stories 66→67), 18 ACs traced to BC-7.2.010, 19 named tests, net +18 adf::tests baseline-155; story adversary 8 passes (P6/7/8 clean). Key F3 catches: F-001 stale count (derive at impl time); F-P2-001 taskItem structural-empty-inline branch; F-P2-002 EC-16 flatten ordering inside TaskItem arm; F-004 DFS-preorder localId (AC-018 added); F-P4-001 AC-010 UUID-era wording corrected. DEC-067/068/069. No code merged; spec/story artifacts on factory-artifacts only. | F1/F2/F3 COMPLETE — F3 HUMAN GATE PENDING | BC 594 (+1). NFR 41. Stories 67 (+1). develop HEAD: 8b639c1 (no code yet). |
| S-QUEUE-BC-1 — queue BCs (BC-X.8.008/009) | CYCLE CLOSED + MERGED (2026-06-08). PR #478 → develop @ e3a14de. BC corpus 589 (+2). 10-pass convergence (3 clean). | F5 CONVERGED | BC: 589. NFR 41. |
| E2E feature (S-E2E-1..5) | F7 CONVERGED + LIVE-GREEN (CYCLE CLOSED 2026-05-31). PR #440+#441+#442 → develop @ fef44bd; live run 26719160283 57/0. | F1–F7 COMPLETE | BC 585. Stories 56. |
| issue-327 (Dependabot rand 0.9→0.10) | CYCLE CONVERGED — PR #413 | 2026-05-26 | F1–F7 COMPLETE | |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->

| Step | Agent | Status | Output |
|------|-------|--------|--------|
| #489 ADF block-level HTML preservation CYCLE CLOSED + MERGED 2026-06-10 — PR #490 → develop @ 13978ce; issue #489 CLOSED; branch deleted. NodeKind::HtmlBlock: block HTML → literal-text paragraph. 3 tests (130→132 adf::tests). CI 11/11 GREEN. | state-manager | CYCLE CLOSED + MERGED | BC 593 / NFR 41 / Stories 66. develop HEAD: 13978ce. |
| #473 bare-URL autolink E2E coverage CYCLE CLOSED + MERGED 2026-06-10 — PR #493 → develop @ 8b639c1; issue #473 CLOSED; branch deleted. test_e2e_markdown_bare_url_produces_link_mark + adf_has_linked_url; Gemini caught href.contains over-permissiveness → fixed; F5 CLEAN. PG-REVIEW-1 + PG-E2E-1 codified. | state-manager | CYCLE CLOSED + MERGED | BC 593 / NFR 41 / Stories 66. develop HEAD: 8b639c1. |
| #471 GFM task lists → ADF F1/F2/F3 COMPLETE 2026-06-10 — BC-7.2.010 authored (593→594). S-471 created (Stories 66→67, 18 ACs, 19 named tests, baseline 155). F2 8-pass adversary convergence (5/6/7/8 clean). F3 8-pass story convergence (6/7/8 clean). Blockquote-taskList dependency closed at spec time. DEC-067/068/069. No code yet. Awaiting F3 human gate. | state-manager | F1/F2/F3 COMPLETE — F3 HUMAN GATE PENDING | BC 594 / NFR 41 / Stories 67. develop HEAD: 8b639c1 (no code). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date | Made By |
|----|----------|-----------|-------|------|---------|
| DEC-001..DEC-016 | Phase 0/1/2 + Wave-2/3 spec-pivot decisions. Archived to `cycles/cycle-001/burst-log.md`. | Full text in burst-log.md | Phase 0→3 | 2026-05-04..10 | human + orchestrator |
| DEC-018..DEC-049 | Closed-cycle Feature Mode decisions (multiple issues + dev releases dev.11/dev.12/dev.13). All CYCLE CLOSED. Full text in `cycles/cycle-001/burst-log.md`. Key open: DEC-029 = #429 WONTFIX deferred to human. | All CYCLE CLOSED | Phase 3 / 2026-05-11..31 | see cycle archive |
| DEC-050..DEC-063 | Closed-cycle decisions: E2E-PG-4 label/link/priority/assign coverage, #331 issueType fix chain, dev releases, Dependabot batch, S-E2E-FORK-1, assign-by-query. All CYCLE CLOSED + LIVE-GREEN. Full text: `cycles/cycle-001/burst-log.md`. | All CYCLE CLOSED | Phase 3 / 2026-06-01..02 | see cycle archive |
| DEC-064 | 2026-06-02: JSM E2E expansion (project EJ) — 7 scenarios, self-close teardown, dynamic RT id, zero-src. JR_E2E_JSM_PROJECT=EJ in jira-e2e env. | F1 human gate | Phase 3 / JSM E2E | 2026-06-02 | human + orchestrator |
| DEC-065 | 2026-06-02: S-JSM-E2E-1 AC-001/003 deliberately un-contracted orphans. Queue BCs deferred to S-QUEUE-BC-1. PG-JSM-E2E-1 logged. | F5 adversarial resolution | Phase 3 / JSM E2E | 2026-06-02 | orchestrator + adversary |
| DEC-066 | 2026-06-03: S-JSM-RESOLUTION-REQUIRED F1 gate. Proactive resolution enforcement on done-category transitions. ADR-0015. --no-resolution opt-out. Bulk excluded. | F1 human gate | Phase 3 / JSM SRC | 2026-06-03 | human + orchestrator |
| DEC-067 | 2026-06-10: #471 F1 gate locked. (1) localId = counter-based 1-based strings, NO uuid; (2) mixed list → whole container promoted to taskList, plain items TODO; (3) taskItem.content inline-only, UPPERCASE TODO/DONE, NO blockTaskItem; (4) live sandbox deferred (needs-sandbox). Research: `.factory/research/issue-471-adf-tasknode-shape.md`. | F1 human gate — 4 decisions approved | Phase 3 / #471 F1 | 2026-06-10 | human + orchestrator |
| DEC-068 | 2026-06-10: #471 F2 CONVERGED. BC-7.2.010 authored (593→594). 8-pass adversary convergence (P5/6/7/8 clean). Blockquote dependency closed at spec time via pulldown-cmark 0.13.3 source-read (spec-changelog [1.3.5]). Human gate APPROVED. | F2 convergence | Phase 3 / #471 F2 | 2026-06-10 | orchestrator + adversary |
| DEC-069 | 2026-06-10: #471 F3 CONVERGED. S-471 (Stories 66→67), 18 ACs, 19 named tests, net +18 adf::tests derive-at-impl (baseline 155). Story converged P6/7/8 clean. Key catches: stale count → derive at impl; taskItem structural-empty-inline branch; EC-16 flatten ordering; DFS-preorder localId (AC-018); AC-010 UUID-era wording. PG-471-1 logged to lessons.md. | F3 story decomposition converged | Phase 3 / #471 F3 | 2026-06-10 | orchestrator + adversary |

## Skip Log

| Step | Skipped? | Justification |
|------|----------|---------------|

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|----------------|-------|------------|

## Drift Items

<!-- Populated during Phase 0 codebase ingestion. RESOLVED/CLOSED rows → cycles/cycle-001/blocking-issues-resolved.md -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| DRIFT-001 | Pass 21+ propagation (recurring) | Count/chain-length fixes require downstream grep sweep. P21 missed H-044+L2; P23-001 reaffirms; ADV-P24-001 is third recurrence. Codify as S-7.01. Every count/chain-length change must trigger grep sweep. | MEDIUM | process-gap recurring (S-3.06 codification story in Wave 3) |
| DRIFT-003 | STORY-INDEX → WAVE-PLAN sibling propagation gap | Recurred P1/P2/P3/P4/P7/P8/P9/P12 of Phase 2-adv. Structural pattern. S-3.06 scope should include WAVE-PLAN↔STORY-INDEX↔frontmatter triple-sync verification. | MEDIUM | process-gap (S-3.06 scope expansion needed) |
| DRIFT-004 | STORY-INDEX BC IDs not validated against canonical bc-N-*.md | P6 surfaced BC-6.4.* dangling (since corpus inception). Fix authors must open canonical BC file. | HIGH | process-gap (verify every BC ID against canonical bc-N-*.md) |
| R1-001 | JiraClient::new_for_test_with_instance_url ergonomics | DEFERRED — 2026-05-07 — takes (base_url, instance_url) where one concept might suffice. Test-infra only; no correctness impact. Target: bundle into next workflow.rs/client.rs touch. | LOW | DEFERRED |
| R1-002 | Stale doc comment in workflow.rs handle_open | DEFERRED — 2026-05-07 — referenced "base URL" pre-fix; one-line text fix. Target: assign to next implementer touching workflow.rs. | LOW | DEFERRED |
| S-0.03-S1 | Missing integration test for effective_wid fallback path at list.rs:464-470 | DEFERRED — 2026-05-07 — raw_wid empty → fallback_wid lookup branch has no integration test. Logic correct; coverage gap. Target: bundle into next list.rs/CMDB-related touch. | LOW | DEFERRED |
| S-0.05-F1 | Cosmetic typo "JiaClient" → "JiraClient" in test doc comment | DEFERRED — 2026-05-07 | LOW | DEFERRED |
| S-0.05-F2 | Stale doc comment in renamed test | LOW | TO_VERIFY — 2026-05-07 |
| S-0.05-F3..S-1.04-DEFER-03, S-2.03-DOC-01..S-2.07-DEFER-02 | 14 LOW cosmetic/doc DEFERRED items (Wave 1+2 era) | LOW | DEFERRED — bundle into next relevant touch. Full details: `cycles/cycle-001/blocking-issues-resolved.md` section "Drift Items". |
| WV2-FIX-A-FOLLOWUP-01/02 | auth_output_json.rs BC citation fixes (11 docstrings BC-7.3.004→7.4.013-016; 2 test names bc_6_2_013→bc_6_2_006) | LOW | DEFERRED — bundle into next develop touch |
| WV2-CV-03 | STORY-INDEX Wave 0/1 rows show `draft` status | DRIFT | DEFERRED — S-3.06 sweep |
| WV2-CV-11, WV2-CV-12 | NITs: H-018 annotation + S-0.05-F2 TO_VERIFY target | NIT | DEFERRED |
| DRIFT-005..DRIFT-009, PG-365-2 | Process-gap/drift items (doc-fallout, chore-mode, check-spec-counts scope, L2 propagation, engine-level citation scope) | LOW | process-gap codified; Owner: orchestrator. Target: v0.6 / engine. |
| PG-01..04 | Process gaps from pr4-dispatch adversary passes | LOW | DEFERRED — engine-scope. |
| S-288-pr2-PG group | 13 DEFERRED process-gap items from S-288-pr2 cycle (PG-1a..1g, PG-2a/2b, PG-3a/3b, PG-F1, PG-1b/1c/1e/1f). PG-2c RESOLVED (see blocking-issues-resolved.md). | LOW | DEFER → post-S-288 self-improvement epic. Full details: `cycles/cycle-001/drift-items-deferred-S-288.md`. |
| F1-AUDIT-MISCOUNT-410 | F1 architect undercounted tests in `multi_cloudid_disambiguation.rs` by 1 (claimed 11, actual 12). Reviewer caught during PR. Future: F1 audits of test files should cross-check by counting `^async fn test_\|^fn test_` matches against the explicit per-test table row count before sign-off. | LOW | DEFERRED — single instance, low recurrence risk, codified informally in L-410-1 (lessons.md). Target: next maintenance sweep. No follow-up story created (per PG-NNN precedent for single-occurrence process gaps). |
| L-428-2-PG | Story-writer AC verification greps drift from as-built code. Greps should anchor on stable code-arm patterns, validated against actual code, not speculative implementations. Consider whether story-writer agent prompt should require this. | LOW | DEFERRED — target: next maintenance sweep; reason: low-severity doc-mechanics gap, no runtime impact. No follow-up story created. |
| DI-E2E-F5-1 | S-E2E-1 F5 LOW: AC-006 grep text imprecise (matches doc comments; executable code correct). | LOW | DEFERRED — doc/runbook-level. |
| OQ-5 | CLAUDE.md NFR-O-N line stale: "`auth status --output json` covers single-profile JSON" but `src/cli/auth/status.rs` has no JSON arm and makes no API call. Recommend filing separate GitHub follow-up issue: either implement a JSON arm calling /myself, or remove the inaccurate NFR-O-N claim. Out-of-scope for S-E2E-1 (zero src/ change feature). | LOW | DEFERRED — doc drift. File GitHub issue before next auth touch. |
| S-382-FLAKE-01 | tests/multi_cloudid_disambiguation.rs keychain contention (macOS) | LOW | PRE-EXISTING — future test-infra cleanup. |
| PG-388-4, PG-384-1/2, PG-385-1..7, PG-398-1..5 | Process gaps from issues #388/#384/#385/#398 cycles (checklists, template gaps, spec-guard gaps, worktree-path class) | LOW | CODIFIED in lessons.md / TRACKED IN #400. |
| E2E-PG-4 | E2E label/link/priority/worklog/unassign/issueType/assign coverage. Label: DONE #447-#450. Link/unlink/remote-link smoke: DONE PR #445. Priority single+multi-key bulk: DONE PR #452. Worklog+unassign: DONE PR #452. issueType bulk: DONE PR #453+#454+#455 (run 26779732719 66/0). assign-by-query (--to): DONE PR #458 (run 26790203429 67/0; DEC-061). REMAINING OPEN sub-gap: remote-link round-back (blocked: no `jr remote-link read`). | remote-link round-back future | test-infra / e2e-coverage | **partially-addressed — OPEN (1 sub-gap remains; assign-specific-user RESOLVED via #458)** |
| PG-331-1 | [process-gap] CLI surface guard direction gap: the `tests/e2e_cli_surface_guard.rs` guard only validates used-flags ⊆ listed-flags (test invocations reference only flags that exist in `--help`). The reverse direction — listed-flags ⊆ used-flags (every `--help` flag gets a test invocation) — is not enforced. Tagged as I-3 from F5 P1. | LOW | DEFERRED — engine/test-infra scope; target: maintenance sweep. No follow-up story created (engine-scope process gap, low recurrence risk given the existing guard handles the primary failure class). |
| PG-331-2 | [process-gap] Adversary dispatch wrong-tree misread: adversary reviewed main-repo develop instead of the worktree twice (original P1 + original P5 dispatch). Root cause: dispatch prompt lacked a diff attachment and HEAD self-check requirement. Mitigation (per DEC-056): feed captured diff as explicit context + require adversary self-check line. | LOW | DEFERRED / CODIFIED-AS-LESSON — cycles/cycle-001/lessons.md; target: engine-level adversary dispatch prompt template. No follow-up story (codified as lesson; low recurrence risk now mitigation is applied). |
| PG-458-1/2 | [process-gap] Surface guard gaps: (1) does not validate POSITIONAL ARITY per subcommand — C-1 bare-positional survived offline guard and 3 adversarial passes (L-458-1); (2) no reverse flag-completeness check and no `conflicts_with` assertion. Both pre-existing; target: maintenance sweep. No follow-up story. | LOW | DEFERRED — engine/test-infra scope. |
| PG-459-1 | [process-gap] No CI lint (actionlint or similar) for GitHub Actions workflow YAML + embedded shell. The gate/preflight in e2e.yml and e2e-sweeper.yml are validated only by human adversarial review. Target: maintenance sweep. No follow-up story (engine/test-infra scope, same justification class as PG-331-1). | LOW | DEFERRED — engine/test-infra scope. |
| PG-459-2 | [process-gap] No spec-vs-workflow drift check (fenced bash/yaml in `docs/specs/*.md` vs `.github/workflows/*.yml`). The `${VAR:?}`→collect-all idiom drift in S-E2E-FORK-1 survived into the same-PR new spec until caught by adversary. Target: maintenance sweep. No follow-up story (same justification class as PG-331-1). | LOW | DEFERRED — engine/test-infra scope. |
| PG-JSM-E2E-1 | [process-gap] No guard cross-checks test-docstring `Traces to: BC-*` against story/spec anchors — surfaced in S-JSM-E2E-1 F5 Pass H: a test docstring can declare a BC trace that does not match the story's bc_anchors or the feature spec's VER-N annotation, and it will survive all offline checks. Folded into S-QUEUE-BC-1 scope (re-anchoring step). Cycle-Closing Checklist S-7.02 satisfied: process-gap → tracked follow-up. | LOW | TRACKED → S-QUEUE-BC-1 scope (re-anchor step). |
| DRIFT-331-PAGINATION | `get_issue_types_for_project` in `src/api/jira/issues.rs` reimplements offset pagination inline (advances by returned page_len) rather than reusing `OffsetPage<T>` from `src/api/pagination.rs`. Advancing by returned-count vs page-size is theoretically vulnerable to the JRACLOUD-71293 fixed-window-overlap class (advancing by returned-count would overlap windows). Practically moot for issue types (single page of ≤200 entries). DEFERRED per human decision 2026-06-01 — log only, no GitHub issue. Owner: maintainer. Target: next pagination/createmeta touch — reuse `OffsetPage<T>` + advance by maxResults. | LOW | OPEN — tracking only (deferred 2026-06-01). |
| PG-A | [process-gap] `scripts/check-bc-cumulative-counts.sh` does NOT cover `.factory/specs/prd/README.md` Document Map / "Total BCs in PRD" line, nor present-tense "current canonical is N" totals in archived historical notes. Root cause of two adversary findings in #470 cycle (M-3/F-1 stale 583, and OBS-1 README drift). Follow-up: extend guard to cover README.md + assert any `current canonical is \d+` equals canonical total — OR a dedicated doc-reconciliation pass. Deferred to self-improvement epic; out of #470 scope. | LOW | OPEN — deferred (2026-06-08). |
| DRIFT-README | `.factory/specs/prd/README.md` Document Map is stale: grand total 573 vs canonical 587; bc-3 93 vs 106; bc-7 84 vs 85; ADF 54 vs 52; holdout 55 vs 57. Pre-existing systemic drift across ~13 cycles (since ~#384), NOT introduced by #470. Deferred to a dedicated doc-reconciliation pass; out of #470 scope. No count-bearing guard covers README.md (see PG-A). | LOW | OPEN — deferred (2026-06-08). |
| PG-QUEUE-1 | [process-gap] A 10th unguarded count surface exists: the CANONICAL-COUNTS.md `_Historical note_` parenthetical previously embedded a live "current canonical is N" value. Caught at Pass 3 of S-QUEUE-BC-1 adversarial review; fixed + reworded to "see Sum row above" in that pass. Follow-up: extend `scripts/check-bc-cumulative-counts.sh` to grep `current canonical is (\d+)` (and similar live-value-in-prose patterns) and compare to Sum row. Defer to a self-improvement story; reason: tooling enhancement, not blocking. | LOW | DEFERRED — tooling enhancement; target: self-improvement epic. No follow-up story yet (2026-06-08). |
| PG-QUEUE-2 | [process-gap] Pre-existing "empty table" miscitation in 3 BC-X.12 (requesttype) BCs in cross-cutting.md (lines ~806/808/837): they claim empty output "renders an empty table" but `output::print_output` prints the dimmed `No results found.` line. Out of S-QUEUE-BC-1 scope (those are requesttype BCs). Defer as a document-as-is correction follow-up; reason: pre-existing, separate BC family. | LOW | DEFERRED — pre-existing requesttype BC prose correction; target: next cross-cutting.md touch. No follow-up story (2026-06-08). |
| DEFER-469 | Dependabot PR #469 (gitleaks-action 2.3.9 → 3.0.0, MAJOR version bump) intentionally held open for extended soak period before merge. Maintainer decision 2026-06-08: major-version GitHub Action upgrade warrants longer observation window before adopting on protected branches. No target date; revisit at maintainer discretion. | LOW | OPEN — intentional hold (2026-06-08). No follow-up story. |

## Convergence Trackers

Full per-issue narratives: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-10] #471 GFM task lists → ADF F1/F2/F3 COMPLETE — BC-7.2.010 authored (BC 593→594). S-471 story (Stories 66→67). F2 8-pass adversary convergence (P1→P4 findings fixed; P5/6/7/8 clean). F3 8-pass story convergence (P6/7/8 clean). Blockquote-taskList dependency resolved at spec time. No code yet. Awaiting F3 human gate. DEC-067/068/069.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->
| Field | Value |
|-------|-------|
| **Date** | 2026-06-10 |
| **Position** | **#471 GFM task lists → ADF — Feature Mode F1/F2/F3 COMPLETE, awaiting F3 human approval gate before F4 TDD.** BC-7.2.010 authored (corpus 593→594). Story S-471 created (Stories 66→67, 18 ACs, 19 named tests, net +18 adf::tests, baseline 155). F2 converged 8 passes (P5/6/7/8 clean); F3 story converged 8 passes (P6/7/8 clean). F4-conditional blockquote dependency RESOLVED at spec time via research (pulldown-cmark 0.13.3 emits blockquote>taskList → normalization arm unconditional). No code yet. develop HEAD remains 8b639c1. |
| **Convergence counter** | BC: 594. NFR: 41. Stories: 67. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. No active worktrees. |
| **Standing context** | JR_E2E_ENABLED=true repo var set. DEC-067/068/069 (F1/F2/F3 #471). DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. #492 OPEN (block-HTML raw-\n). E2E-PG-4 remote-link round-back open. PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. PG-471-1 logged to lessons.md. PG-REVIEW-1 + PG-E2E-1 codified in lessons.md. |
| **Next step** | Await F3 human gate approval, then dispatch F4 TDD implementation for #471. |
| **Resume prompt** | `Read .factory/STATE.md. #471 GFM task lists → ADF Feature Mode F1/F2/F3 COMPLETE (2026-06-10), awaiting F3 human gate before F4 TDD. BC-7.2.010 authored (BC 593→594). S-471 story (Stories 66→67; 18 ACs, 19 named tests, baseline 155, net +18 adf::tests at impl time). F2 8-pass adversary convergence (P5/6/7/8 clean). F3 8-pass story convergence (P6/7/8 clean). Blockquote-taskList dependency resolved at spec time. No code yet; develop HEAD 8b639c1. DEC-067 (F1 gate), DEC-068 (F2 convergence), DEC-069 (F3 story). DEC-066 retained. Do NOT close #429 (DEC-029). OQ-5 open. #492 OPEN (block-HTML raw-\n). E2E-PG-4 remote-link round-back open. PG-471-1 in lessons.md (4th ADF stale-baseline recurrence; derive at impl time). PG-A + DRIFT-README + PG-QUEUE-1 + PG-QUEUE-2 + DEFER-469 deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ. Awaiting F3 human gate; upon approval dispatch F4.` |

## Open Issues Tracker (post-#288)

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #489 | fix(adf): block-level HTML silently dropped | **CLOSED + MERGED** — PR #490 squash-merged → develop @ 13978ce (2026-06-10T00:11:01Z). NodeKind::HtmlBlock: block HTML → literal-text paragraph; 3 tests; adf::tests 130→132. CI 11/11 GREEN. | MEDIUM → RESOLVED | Discovered #476 cycle; fix delivered #490. |
| #473 | feat(adf): bare-URL autolink + E2E coverage | **CLOSED + MERGED** — feature PR #491 squash-merged → develop (prior); E2E follow-up PR #493 squash-merged → develop @ 8b639c1 (2026-06-10). test_e2e_markdown_bare_url_produces_link_mark + adf_has_linked_url helper in e2e_live.rs; Gemini caught href.contains over-permissiveness → fixed; CI 11/11 GREEN. | MEDIUM → RESOLVED | Delivered via full VSDD delta cycle F1→F7. PG-REVIEW-1 + PG-E2E-1 codified. |
| #492 | fix(adf): block-HTML raw-\n invariant (follow-up from #489 F5) | **OPEN** — needs-sandbox live Jira verification. Filed 2026-06-09 from #489 F5 retrospective. Raw-newline handling inside literal-text paragraphs may not survive Jira REST round-trip. | LOW | Needs-sandbox. No active cycle. |
| #210 | (backlog) | OPEN | — | |
| #331 | issueType bulk-edit wire schema fix | **CLOSED + LIVE-GREEN** — PR #453 + PR #454+#455 → develop @ f418bf5 (2026-06-01). Issue #331 CLOSED. | HIGH | Full VSDD F1–F7 COMPLETE (DEC-057). Live-fix chain: first live run 26777755130 (65/1, createmeta schema defect) → Perplexity+OpenAPI re-research → PR #454 (e2e wiring) + PR #455 (issueTypes/offset fix) → live run 26779732719 (66/0 ALL GREEN) (DEC-058). BC-3.4.018/019 (585 BCs). DRIFT-E2E-ALT RESOLVED. DRIFT-331-PAGINATION tracked (deferred). |
| S-JSM-RESOLUTION-REQUIRED | jr issue move proactive resolution enforcement | **CLOSED + MERGED + LIVE-GREEN** — PR #465 squash-merged → develop @ 8ec9527 (2026-06-03T20:01:51Z). Post-merge e2e.yml run 26909701606 SUCCESS: JSM suite 73/0 (110.55s); test_e2e_jsm_resolution_enforcement PASSED LIVE. | HIGH | BC-3.2.013 + ADR-0015. --no-resolution opt-out; bulk excluded; reactive 400 backstop retained. First live proof of proactive resolution gate. DEC-066 retained. |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #400 | Test-hardening + process-gap follow-ups from #398 | OPEN | LOW | Filed 2026-05-22. Story A (TH-398-1..4) MERGED PR #431 @ 9d4a65b (2026-05-28). Story B (PG-398-1 count-guard extension) + engine items (PG-398-4/5) remain open. |
| #429 | jr_isolated() crypto-random JR_SERVICE_NAME suffix to prevent keychain contention across parallel subprocess tests | OPEN | LOW | Filed 2026-05-28. Alternative root-cause fix to #428's approach. Now that #428 merged, #429's mechanism is superseded for tests #4/#5/#6. WONTFIX decision deferred to human (DEC-029). Do NOT close autonomously. |
| #387/#368 | git history rewrite demo-evidence blobs / open PR | OPEN | LOW | #387: deferred; force-push needed. #368: see backlog. |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history (all bursts + extracted Phase Progress narratives + Post-Cycle Housekeeping 2026-05-19) | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass + extracted convergence narratives) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
