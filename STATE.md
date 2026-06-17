---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-17T00:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "Issue #522 CYCLE CLOSED + MERGED — PR #523 squash-merged → develop @ 53f6d98 (#522 auto-closed). Full F1–F7: F5 caught HIGH CR-01; F6/F7 PASS. BC-7.2.011 v1.11.0. Factory idle — awaiting next work."
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
| **Last Updated** | 2026-06-17: Issue #522 CYCLE CLOSED + MERGED. PR #523 squash-merged → develop @ 53f6d98 (#522 auto-closed). Full F1–F7: F5 caught HIGH CR-01 (bare \n Other-ctx via multi-line inline HTML → Jira 400); F6/F7 PASS. BC-7.2.011 v1.11.0. S-522 19 ACs HIGH. DEC-119. Factory idle — awaiting next work. |
| **Current Phase** | Phase 3 — Feature Mode; #522 CYCLE CLOSED + MERGED. develop @ 53f6d98. BC 598. NFR 42. ADR 16. Stories 77. |
| **Next Phase** | Phase 4: Holdout Evaluation (not started) |
| **Activation HEAD** | 4258202 (v0.6.0-dev.2 released 2026-06-14; develop HEAD 3ba8ea2; v0.5.0 STABLE shipped 2026-06-12) |

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
| Issue #492 block-HTML hardBreak (BC-7.2.011) | **CYCLE CLOSED + MERGED** | 2026-06-16 | F1–F7 ALL COMPLETE — CONVERGED | PR #521 → develop @ 3ba8ea2. BC-7.2.011 v1.9.6. 5/5 F7 dims; 150k proptest; 100% mutation; 0 code defects. Follow-up #522 (lone-CR OOS). DEC-109. |
| Issue #522 ADF CR/newline normalization (EC-11+EC-12+CR-01) | **CYCLE CLOSED + MERGED** | 2026-06-17 | F1–F7 ALL COMPLETE — CONVERGED | PR #523 → develop @ 53f6d98. BC-7.2.011 v1.11.0. HIGH CR-01 caught by F5 adversarial. DEC-110..119. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| F5 final pass-set R4 (3 fresh perspective-diverse passes over full EC-11+EC-12+F5-R2 delta @ c7103b7→6d87bb6): doc count "Three"→"Four" asymmetries tidied (6d87bb6). ALL 3 PASSES PASS-CLEAN — zero blocking findings. Only non-actionable cosmetic observations. 3 consecutive clean = CONVERGED. F5 COMPLETE. DEC-115. | Agent adversary + state-manager | **F5 CONVERGED — 3/3 CLEAN** | worktree .worktrees/S-522 @ 6d87bb6 (LOCAL ONLY). BC-7.2.011 v1.11.0. S-522 19 ACs HIGH. 248 lib tests. Next: F6. |
| BC-INDEX.md last_updated bumped 2026-06-12→2026-06-17 (stale timestamp for BC-7.2.011 v1.11.0 update flagged by F5 Pass-B cosmetic; count guards green). STATE.md advanced to F5 CONVERGED. F6 next. | Agent state-manager | BURST COMMITTED | factory-artifacts updated. |
| F6 targeted hardening PASS: full regression 1850 green / 0 failed / 91 ignored; PROPTEST_CASES=100k release — prop_text_to_adf_holds_inv1 + prop_markdown_to_adf_html_chars_holds_inv1 (CR-01 catcher) + prop_492_* — NO counterexample; diff-scoped mutation 21 mutants → 16 caught + 5 hand-verified-equivalent + 2 killing tests added (test_text_to_adf_three_lines_produce_two_interior_hardbreaks + test_markdown_image_alt_text_is_dropped_by_sink_guard); cargo audit 346 deps 0 advisories; cargo deny ok; clippy/fmt clean. No production-logic change. Code @ 0ed1395. DEC-116. Surfaced MUTANTS-ADF-GLOB tooling gap. Next: F7. | Agent formal-verifier + state-manager | **F6 PASS** | worktree .worktrees/S-522 @ 0ed1395. |
| Issue #522 CYCLE CLOSED + MERGED. PR #523 squash-merged → develop @ 53f6d98 (#522 auto-closed). CI Gate PASS; pr-reviewer + security APPROVE. Remote branch fix/adf-push-text-cr-normalization-522 deleted; worktree .worktrees/S-522 cleaned up. S-7.02 checklist complete. LESSON-F1-SIBLING-CASE codified. DEC-119. Factory idle. | state-manager | **CYCLE CLOSED** | develop @ 53f6d98. BC-7.2.011 v1.11.0. BC 598. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-063 | Phase 0/1/2 + Wave + Feature Mode decisions (multiple issues + dev releases). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-02 | archived |
| DEC-064..DEC-078 | JSM E2E (064..066), #471 taskList ADF F1..F6 (067..071), leading-dash fix (072), #475 E2E (073..076), v0.5.0-dev.14 + v0.5.0 STABLE releases (077..078). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 3 / 2026-06-02..12 | archived |
| DEC-079..092 | Windows-build F1..F4 decisions (F1+F2 gate, F3 CONVERGED, Pre-F4 research, VSDD-closure, F3 re-gate, S-WIN-2 MERGED; S-WIN-3/S-WIN-1/S-WIN-4/S-WIN-6 F4 per-story CONVERGED+MERGED). All archived. | See `cycles/cycle-001/burst-log.md` "Archived Decisions DEC-079..085" + "DEC-086..092" | Phase 3 | 2026-06-12..13 |
| DEC-093..106 | Windows-build F4–F7 + fork-release-ops integration + #492 F1–F2/F5 cycle decisions (all CYCLE CLOSED). | See `cycles/cycle-001/burst-log.md` "Archived Decisions DEC-093..106" | Phase 3 | 2026-06-14..16 |
| DEC-107 | 2026-06-16: Issue #492 F5 scoped adversarial CONVERGED. 15 fresh-context passes / 6 fix rounds / final 3 clean (Pass 13 deep cross-consistency, Pass 14 holistic+traceability+counts, Pass 15 robustness+completeness) on frozen 8062b78 + BC-7.2.011 v1.9.6 @ factory-artifacts 87e3c53. ZERO production-code defects — single Algorithm B path proven correct ~12x across all lenses; all findings were doc/spec precision (severity decayed M→L→0). BC version trail: v1.9.1→v1.9.2→v1.9.3→v1.9.4→v1.9.5→v1.9.6. PR #521 pushed. Next: F6 targeted hardening. | Feature Mode / #492 F5 | Phase 3 | 2026-06-16 |
| DEC-108 | 2026-06-16: Issue #492 F6 hardening COMPLETE (proptest 5-invariant suite, 150k cases; mutation 100% effective, 3 equivalent; cargo audit 346 deps 0 advisories; cargo deny ok; full suite 222 adf green) + F7 DELTA_CONVERGED 5/5 (consistency audit PASS-WITH-NOTES, 3 non-blocking deferred; input-drift PASS for #492 perimeter). Human-authorized merge of PR #521 @ 72fbcb9 (pending CI green). F6 surfaced pre-existing OOS lone-CR defect (heading/codeBlock via generic Event::Text path; pulldown-cmark CR-normalization gap) — follow-up issue filed, #[ignore]d test test_lone_cr_survives_pre_existing_492_oos pinned. NOT a #492 regression. | Feature Mode / #492 F6+F7 | Phase 3 | 2026-06-16 |
| DEC-109 | 2026-06-16: Issue #492 bug-fix cycle CLOSED. PR #521 squash-merged → develop @ 3ba8ea2 (14/14 CI green incl CI Gate; #492 auto-closed). Full Feature-Mode pipeline: F4 TDD → F5 15-pass/3-clean scoped-adversarial CONVERGED (zero code defects; all findings doc/spec precision) → F6 hardening (proptest 5-invariant 150k-case suite + 100% effective mutation) → F7 5/5 DELTA_CONVERGED + consistency PASS-WITH-NOTES + input-drift PASS. BC-7.2.011 v1.9.6. F6 surfaced pre-existing OOS lone-CR defect → follow-up #522 filed. S-7.02 checklist complete (cycles/cycle-001/lessons.md). LESSON-RESUME-STATE-RECONCILE codified. | Feature Mode / #492 CYCLE CLOSE | Phase 3 | 2026-06-16 |
| DEC-110 | 2026-06-16: Issue #522 bug-fix cycle OPENED. F1 COMPLETE: chokepoint = AdfBuilder::push_text + push_code in src/adf.rs; blast radius uniformly safe (all generic-path block types; Algorithm B from #492 normalizes independently, no double-normalization). F2 COMPLETE: BC-7.2.011 extended to v1.9.7 with EC-11 (INV-push-text-cr) — push_text/push_code normalize \r\n→\n then lone \r→\n for ALL block types; no new BC; total_bcs 598 unchanged; spec-changelog + BC-INDEX updated; 3 count guards green. F3 COMPLETE: S-522 story (7 ACs anchored to BC-7.2.011/EC-11); STORY-INDEX 76→77 (feature_followup 41→42); sprint-state.yaml S-522 added (ready/F3/leaf). F4 TDD next. | Feature Mode / #522 bug-fix | Phase 3 | 2026-06-16 |
| DEC-113 | 2026-06-17: Issue #522 F5 round-2 scoped-adversarial (3 fresh passes, perspective-diverse: correctness/coherence/completeness) surfaced a genuine HIGH end-to-end-reachable INV-1 bug (CR-01): push_text/push_code only normalized on \r-present, so a bare \n in Other context survived into a text node — reachable via multi-line inline HTML (Event::InlineHtml carries raw \n) in user --description/comment → Jira 400. Pre-existing defect missed by F1–F4 (and by #492/EC-11/EC-12 scoping — sibling \n case of the \r fix). Fixed: bare \n→space in Other/push_code, codeBlock preserves \n; BC-7.2.011→v1.11.0 (EC-11 behavior table, COMP-1 Unicode scope exclusion); S-522 14→19 ACs severity HIGH. 5 LOW also fixed (CR-02 inline-HTML fuzz proptest, COMP-1/2/3, OBS-1 AC-014 form). Red cb299d7 → green 182a93d, 244 lib green. F5 counter reset 0/3; re-running 3 fresh passes. PROCESS-GAP: F1 Impact Boundary again missed a sibling control-char case (\n alongside \r) on the SAME chokepoint — reinforces the Step-7 'enumerate sibling cases sharing a target invariant' lesson; F5 perspective-diverse fan-out (3 lenses) is what caught it. | Feature Mode / #522 F5-R2 | Phase 3 | 2026-06-17 |
| DEC-114 | 2026-06-17: Issue #522 F5 round-2 second pass-set (3 fresh perspective-diverse lenses over 182a93d) found ZERO new production-code defects — correctness lens fully clean, code proven correct under exhaustive hand-trace. Findings were doc/test/spec completeness only: MED F-522-01 (block→hardBreak vs inline→space HTML-newline asymmetry was a sound but undocumented product decision; now documented in docs/specs/adf-block-html.md with BC-7.2.011 EC-11 reference), LOW F-522-02 (added deterministic 3-line + CRLF inline-HTML regression cases), LOW F-OBS-1 (AC-014 illustrative snippet form cosmetic: cases 2048→1000, prop_map wrapper dropped). All fixed @ c7103b7; 244 lib green. Severity decay HIGH(CR-01)→MED(doc)→LOW — converging. Next: 3 fresh passes over c7103b7 for final clean-pass set, then F6. | Feature Mode / #522 F5-R2 follow-up | Phase 3 | 2026-06-17 |
| DEC-115 | 2026-06-17: Issue #522 F5 scoped-adversarial CONVERGED. 4 fresh-context rounds (perspective-diverse: correctness/coherence/completeness lenses). R2 found a genuine HIGH end-to-end-reachable INV-1 bug (CR-01: bare \n survived push_text/push_code Other context via multi-line inline HTML) that F1–F4 + #492/EC-11/EC-12 scoping all missed — vindicates F5. Severity decayed HIGH→MED(doc)→LOW→0-blocking; final 3 consecutive passes all PASS-CLEAN. Outcome: BC-7.2.011 v1.11.0 (EC-11 bare-\n rows + COMP-1 Unicode scope note), S-522 19 ACs severity HIGH, block-vs-inline HTML newline asymmetry documented (docs/specs/adf-block-html.md), 248 lib tests, full suite green. Code @ 6d87bb6 LOCAL. Next: F6 hardening. PROCESS-GAP [process-gap]: F1 Impact Boundary again missed a sibling control-char case (\n alongside \r) on the SAME chokepoint — reinforces Step-7 lesson 'F1 must enumerate sibling cases sharing a target invariant'; F5 3-lens fan-out is what caught it. | Feature Mode / #522 F5 CONVERGED | Phase 3 | 2026-06-17 |
| DEC-116 | 2026-06-17: Issue #522 F6 targeted hardening PASS. Full regression 1850 green / 0 failed / 91 ignored (gated suites). PROPTEST_CASES=100k (release): prop_text_to_adf_holds_inv1, prop_markdown_to_adf_html_chars_holds_inv1 (CR-01 catcher), prop_492_arbitrary_string_holds_core_invariants, prop_492_block_html_holds_core_invariants — NO counterexample; INV-1 held under 100k-case stress. Diff-scoped mutation (src/adf.rs): 21 mutants → 16 caught + 5 hand-verified-equivalent (text_to_adf hardBreak-index variants removed by trim; push_text Sink-guard redundant with append_child guard; needs_norm &&→|| only adds no-op replace); 2 killing tests added (test_text_to_adf_three_lines_produce_two_interior_hardbreaks, test_markdown_image_alt_text_is_dropped_by_sink_guard). cargo audit 346 deps 0 advisories. cargo deny ok. clippy/fmt clean. No production-logic change (F5-converged); no correctness bug surfaced. Code @ 0ed1395. Surfaced tooling gap: .cargo/mutants.toml examine_globs omits src/adf.rs → canonical `cargo mutants --in-diff` false-greens ADF deltas; workaround used `--file src/adf.rs`. Tracked MUTANTS-ADF-GLOB. Next: F7 (5-dim delta convergence + fresh consistency-validator + input-drift) then PR → develop. | Feature Mode / #522 F6 | Phase 3 | 2026-06-17 |
| DEC-117 | 2026-06-17: Issue #522 F7 DELTA_CONVERGED. Fresh-context consistency-validator: 5/5 dimensions PASS (spec/tests/impl/verification/docs), count guards 0, full suite 1850/0, clippy/fmt clean, CR-01 reachable-HIGH bug confirmed closed, no blocking cross-doc drift, input-drift PASS (manual perimeter — no hash registry, as #492). 3 non-blocking: CLAUDE.md gotcha deferred post-merge per story scope; MUTANTS-ADF-GLOB tracked; CANONICAL-COUNTS last_verified timestamp fixed this commit. Branch ready for PR→develop pending human merge gate. | Feature Mode / #522 F7 | Phase 3 | 2026-06-17 |
| DEC-118 | 2026-06-17: Issue #522 — human (AskUserQuestion gate) approved "Create PR but fold in follow-ups first". Folded into fix branch @ 5a0b7d8: (a) root CLAUDE.md gotcha for the #522 push_text/push_code/text_to_adf INV-1 chokepoint + block-vs-inline HTML newline asymmetry + CR-01 HIGH-bug note + Unicode-OOS; (b) .cargo/mutants.toml examine_globs += src/adf.rs — canonical diff-scoped mutation now lists 21 adf.rs mutants (was 0; MUTANTS-ADF-GLOB false-green eliminated). 246 adf tests green, clippy/fmt clean. Both drift items RESOLVED. Next: pr-manager creates PR fix/adf-push-text-cr-normalization-522 → develop; merge human-gated. | Feature Mode / #522 follow-ups | Phase 3 | 2026-06-17 |
| DEC-119 | 2026-06-17: Issue #522 bug-fix cycle CLOSED + MERGED. PR #523 squash-merged → develop @ 53f6d98 (#522 auto-closed; CI Gate PASS, pr-reviewer + security APPROVE). Full Feature-Mode F1–F7: F4 TDD → F5 4-round/3-lens scoped-adversarial CONVERGED (caught genuine HIGH end-to-end-reachable INV-1 bug CR-01: bare \n survived push_text/push_code Other context via multi-line inline HTML → Jira 400, missed by F1-F4 and all prior ADF work) → F6 hardening (1850/0, 100k proptest, mutation 16-caught/5-equivalent+2 killing tests, audit/deny clean) → F7 5/5 DELTA_CONVERGED. BC-7.2.011 v1.11.0 (EC-11 bare-\n rows + COMP-1 Unicode scope note), S-522 19 ACs HIGH, block-vs-inline HTML newline asymmetry documented. 2 follow-ups folded into PR (CLAUDE.md gotcha + mutants.toml adf.rs scope — both drift RESOLVED). S-7.02 checklist complete: LESSON-F1-SIBLING-CASE codified (2nd recurrence of F1 sibling-case-enumeration gap) — justified deferral, no follow-up story required (process-discipline lesson, documented for next cycle's F1). | Feature Mode / #522 CYCLE CLOSE | Phase 3 | 2026-06-17 |
| DEC-112 | 2026-06-17: Issue #522 F5 Pass-1 LOW findings F-1/F-2/F-3 remediated before re-running adversarial passes. F-1 proptest \n-coverage gap closed (both proptests dotall-charset `"[\r\n\t a-zA-Z0-9]{0,64}"`, code c70f07d) + AC-014 prose harmonized byte-for-byte; F-2 BC-7.2.011 EC-12 table count corrected 13→12 (true=12); F-3 empty-paragraph shape positively pinned (2 new tests `test_text_to_adf_empty_string_shape`+`test_text_to_adf_all_newlines_shape`, 235→237 adf green). F5 counter reset 0/3; next: 3 fresh-context scoped-adversarial passes over full EC-11+EC-12 delta. Code LOCAL @ c70f07d. | Feature Mode / #522 F5 remediation | Phase 3 | 2026-06-17 |
| DEC-111 | 2026-06-17: Issue #522 cycle EXPANDED mid-cycle (user approval) to TWO chokepoints — EC-11 (push_text/push_code markdown path, original) + EC-12 (text_to_adf plain-text path, sibling defect discovered during F5 traceability pass). F1-ext complete: issue-522-text-to-adf-extension.md. F2 expanded: BC-7.2.011 v1.9.8→v1.9.9→v1.10.0 (EC-11 context-aware contract + EC-12 INV-1-plain-text). F3 expanded: S-522 7→14 ACs. F4 COMPLETE both paths: 235 adf tests green; cargo test green; clippy clean; fmt clean. Code LOCAL ONLY on branch fix/adf-push-text-cr-normalization-522 @ b999d97 (6 commits: baf2a42→0d7775d→7968d66→514d364→35d81bb→b999d97). F5 expanded-delta Pass-1 COMPLETE — CLEAN (1/3); 3 LOW findings (F-1/F-2/F-3) to fix before re-running. Pre-session-clear checkpoint committed to factory-artifacts branch. | Feature Mode / #522 EXPANDED | Phase 3 | 2026-06-17 |

## Skip Log

All 7 S-WIN-1..6 + #475 per-AC demos: **Yes — adapted**. All are CI-config / infra / docs / test-only / platform-cfg stories with no user-visible runtime behavior on the macOS dev host. Evidence per story: hermetic test suite green + cross-compile + CI gate (AC-005/007 for S-WIN-5 = the windows-latest CI run itself). See `cycles/cycle-001/burst-log.md` for per-story justification rows.

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|
<!-- No open blocking issues for #522. F5 CONVERGED. F6 in progress. -->

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
| PRE-EXISTING-LONE-CR | heading+codeBlock raw `\r` survival + bare `\n` Other-ctx (CR-01) | **RESOLVED — shipped in PR #523 @ 53f6d98 (DEC-119)**. EC-11+EC-12+CR-01 fix; F5 CONVERGED; F6 PASS; F7 5/5 PASS. Archived to cycles/cycle-001/blocking-issues-resolved.md. | HIGH | **RESOLVED** — archived |
| F7-001 | CLAUDE.md 'symmetric' wording | CLAUDE.md description-echo section uses 'symmetric'/'asymmetric' wording with minor precision gap noted in F7 consistency audit. Non-blocking cosmetic. Deferred to next CLAUDE.md edit. | LOW | ACCEPTED-DEFERRED (F7 non-blocking) |
| F7-002 | F2-record archival note | cycles/cycle-001/issue-492/f2-convergence.md archival notation note from F7 audit. No functional gap; reference file exists. | LOW | ACCEPTED-DEFERRED (F7 non-blocking) |
| F7-003 | BC-7.2.011 "13 tests" phrasing | BC-7.2.011 body uses "13 tests" — acceptable per check-bc-no-numeric-test-counts.sh qualitative policy (PG-365-1); no change required. | LOW | ACCEPTED-DEFERRED (F7 non-blocking) |
| #492-TEST-HARNESS-COUPLING | process-gap (F-P1-003) | Handler-level block-HTML tests (EC-6/7/8/9/10) construct AdfBuilder directly and couple to push_text accumulation shape; re-validate if that accumulation path is refactored. Adversary verdict: process-gap, no code change required. | LOW | TRACKED DEFERRAL — no follow-up story required; re-validate on push_text refactor |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. Must be PHASE-AWARE (pre-impl BCs legitimately cite not-yet-created tests) to avoid false-positives on in-flight BCs. Candidate: scripts/check-bc-trace-tests-exist.sh gated on cycle status. | LOW | TRACKED DEFERRAL — pre-existing; no CI check yet |
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

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-17] #522 CYCLE CLOSED → develop @ 53f6d98 (DEC-119). Prior: #492 CYCLE CLOSED → develop @ 3ba8ea2 (DEC-109).**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-17 |
| **Position** | **Issue #522 CYCLE CLOSED + MERGED. PR #523 squash-merged → develop @ 53f6d98 (#522 auto-closed). CI Gate PASS; pr-reviewer + security APPROVE. No active worktree (S-522 cleaned up). Factory idle — awaiting next work item.** |
| **develop HEAD** | origin/develop = **53f6d98** (PR #523 #522 fix). activation v0.6.0-dev.2. BC **598**. NFR **42**. ADR **16**. Stories **77** (authoritative). |
| **Convergence counter** | BC: **598**. NFR: **42**. ADR: **16**. Stories: **77** authoritative. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. No active worktree. |
| **Next / Pending** | Factory idle — awaiting next work item. Open backlog: #429 DNC (DEC-029), #400 Story B, #372, #387/#368, #209/#210. Fork-release-ops enablement PENDING (DEC-104). |
| **Resume prompt** | Read .factory/STATE.md. Issue #522 CYCLE CLOSED + MERGED. PR #523 squash-merged → develop @ 53f6d98 (#522 auto-closed). BC-7.2.011 v1.11.0. BC 598. No active worktree. Factory idle — awaiting next work item. Open backlog: #429 DNC (DEC-029), #400 Story B, #372, #387/#368, #209/#210. Fork-release-ops enablement PENDING (DEC-104). STANDING: do NOT close #429 (DEC-029); OQ-5 open; E2E-PG-4 open; SEC-001 LOW deferred. jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: Issue #522 CYCLE CLOSED + MERGED. PR #523 → develop @ 53f6d98. No active worktree. Factory idle. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read STATE.md.

**Step 2 (idle — no active worktree):** Issue #522 CYCLE CLOSED. develop @ 53f6d98. BC-7.2.011 v1.11.0. BC 598. No active worktree. Consult open backlog: #429 DNC (DEC-029), #400 Story B, #372, #387/#368, #209/#210. Fork-release-ops enablement PENDING (DEC-104).

Durable follow-ups: see Drift Items section (WIN-AUTH-ENVLOCK-POISON, WIN-DENY-FRAGILITY, SEC-JR-SERVICE-NAME-GATE, WIN-RUNTIME-OAUTH-PROBE, WIN-AC004-DIRECTIONAL, #492-TEST-HARNESS-COUPLING, #492-PG-TRACE-TESTS, #429-DNC, OQ-5, E2E-PG-4, #400-Story-B, #372).

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #522 | fix(adf): ADF CR/newline normalization — EC-11+EC-12+CR-01 | **CLOSED + MERGED** (PR #523 → develop @ 53f6d98, 2026-06-17; auto-closed) | HIGH | Archived to cycles/cycle-001/closed-issues-archive.md. DEC-119. |
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | #387: deferred; force-push needed. |
| #209/#210 | (backlog) | OPEN | — | |
| #520 | ci: opt-in release ops (fork-friendly) | MERGED @ 2cb219b (develop). Integrates #503. Inert by default. | LOW | Enablement decision PENDING — see DEC-104 + research file. |
| #503 | External fork contribution by @ArcavenAE | CLOSED (integrated via #520; Co-authored-by credit in squash commit; credit comment left on PR #503). | — | CLOSED — no further action. |
| Merged: #521/518/517/510/509/508/507/475 | MERGED or CLOSED | Archived | — | See `cycles/cycle-001/closed-issues-archive.md` (#492/#521 + prior) + `cycles/cycle-001/blocking-issues-resolved.md` (#510) |

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
