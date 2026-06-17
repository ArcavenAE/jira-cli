---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-17T00:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "Issue #522 EXPANDED two-chokepoint cycle (EC-11 + EC-12): F1-F4 ALL COMPLETE (235 adf tests green @ b999d97). F5 IN PROGRESS over expanded delta. BC-7.2.011 v1.10.0 (EC-11+EC-12). S-522 14 ACs. Code LOCAL ONLY on fix/adf-push-text-cr-normalization-522. DEC-111. PRE-SESSION-CLEAR CHECKPOINT COMMITTED."
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
| **Last Updated** | 2026-06-17: Issue #522 EXPANDED to two chokepoints (EC-11 + EC-12). F1-F4 COMPLETE both paths (235 adf tests green). F5 IN PROGRESS over expanded delta. BC-7.2.011 v1.10.0. S-522 14 ACs. Code local-only @ b999d97. DEC-111. Pre-session-clear checkpoint committed. |
| **Current Phase** | Phase 3 — TDD Implementation IN PROGRESS — #522 two-chokepoint bug-fix (F5 in progress). develop @ 3ba8ea2. BC 598. NFR 42. ADR 16. Stories **77** (authoritative). |
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
| Issue #522 ADF CR normalization — EXPANDED two chokepoints (EC-11 + EC-12) | **IN PROGRESS** — F5 over expanded delta | — | F1+F2+F3+F4 ALL COMPLETE | F1: EC-11 (push_text/push_code) + F1-ext: EC-12 (text_to_adf). F2: BC-7.2.011 v1.10.0. F3: S-522 14 ACs. F4: 235 adf tests green @ b999d97 LOCAL. F5: 6 passes on EC-11 (3 clean); EC-12 F5 pass 1 IN FLIGHT — DISCARD. Re-run from scratch. DEC-110+DEC-111. |
| 4: Holdout Evaluation | not-started | | | |
| 5: Adversarial Refinement | not-started | | | |
| 6: Formal Hardening | not-started | | | |
| 7: Convergence | not-started | | | |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| Issue #492 cycle CLOSED. PR #521 squash-merged → develop @ 3ba8ea2 (14/14 CI green incl CI Gate; #492 auto-closed). Follow-up #522 filed (pre-existing lone-CR OOS defect). DEC-109. | Agent state-manager | CYCLE CLOSED | develop @ 3ba8ea2. BC 598. Stories 75. |
| Issue #522 F1+F2+F3 COMPLETE. F1: chokepoint push_text/push_code. F2: BC-7.2.011 v1.9.7 EC-11. F3: S-522 7 ACs. Stories 77. DEC-110. | Agent state-manager | F3 COMPLETE | develop @ 3ba8ea2. BC 598. Stories 77. |
| Issue #522 EXPANDED mid-cycle (user approval): F1-ext (text_to_adf EC-12 delta analysis). F2 expanded: BC-7.2.011 v1.9.8→v1.9.9→v1.10.0 (EC-11 context-aware fix + EC-12). S-522 expanded 7→14 ACs. F4 COMPLETE both paths (235 adf tests green; cargo test green; clippy clean; fmt clean). Code LOCAL ONLY on fix/adf-push-text-cr-normalization-522 @ b999d97 (6 commits). DEC-111. | Agent state-manager | F4 COMPLETE — F5 next (expanded delta) | worktree .worktrees/S-522 @ b999d97 (LOCAL ONLY). BC 598. Stories 77. |
| F5 EXPANDED-DELTA Pass-1 COMPLETE — CLEAN (1/3). Hand-traced text_to_adf all adversarial inputs (empty, "\n", "\r", "\r\n", "a\r\rb", "\n\n\n", leading/trailing, "a\nb\n\nc\nd") — ALL INV-1-safe; single-line fast-path byte-identical; empty-content guards present; BC-EC-12-story-AC coherent. No HIGH/MED. 3 LOW findings to fix before re-running (see Blocking Issues). EC-11 markdown-path prior history: 6 fresh passes, Pass-1 found INV-1 heading-\n bug (7968d66), Pass 2-3 swept stale prose, Pass 4-5 CLEAN, final round fixed 2 MED + surfaced EC-12 gap. DEC-111. | Agent state-manager | F5 1/3 CLEAN — 3 LOW FINDINGS TO FIX FIRST | Next: fix F-1/F-2/F-3 (see Blocking Issues), then 3 FRESH clean passes over full EC-11+EC-12 delta. |
| PRE-SESSION-CLEAR CHECKPOINT committed (DEC-111). All factory artifacts committed to factory-artifacts branch. Cold-start resume plan below. | Agent state-manager | CHECKPOINT COMMITTED | develop @ 3ba8ea2. BC 598. Stories 77. Worktree @ b999d97 LOCAL. |

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
| DEC-111 | 2026-06-17: Issue #522 cycle EXPANDED mid-cycle (user approval) to TWO chokepoints — EC-11 (push_text/push_code markdown path, original) + EC-12 (text_to_adf plain-text path, sibling defect discovered during F5 traceability pass). F1-ext complete: issue-522-text-to-adf-extension.md. F2 expanded: BC-7.2.011 v1.9.8→v1.9.9→v1.10.0 (EC-11 context-aware contract + EC-12 INV-1-plain-text). F3 expanded: S-522 7→14 ACs. F4 COMPLETE both paths: 235 adf tests green; cargo test green; clippy clean; fmt clean. Code LOCAL ONLY on branch fix/adf-push-text-cr-normalization-522 @ b999d97 (6 commits: baf2a42→0d7775d→7968d66→514d364→35d81bb→b999d97). F5 expanded-delta Pass-1 COMPLETE — CLEAN (1/3); 3 LOW findings (F-1/F-2/F-3) to fix before re-running. Pre-session-clear checkpoint committed to factory-artifacts branch. | Feature Mode / #522 EXPANDED | Phase 3 | 2026-06-17 |

## Skip Log

All 7 S-WIN-1..6 + #475 per-AC demos: **Yes — adapted**. All are CI-config / infra / docs / test-only / platform-cfg stories with no user-visible runtime behavior on the macOS dev host. Evidence per story: hermetic test suite green + cross-compile + CI gate (AC-005/007 for S-WIN-5 = the windows-latest CI run itself). See `cycles/cycle-001/burst-log.md` for per-story justification rows.

## Blocking Issues

<!-- Open issues only. Move resolved issues to cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Issue | Severity | Status |
|----|-------|----------|--------|
| F-1 [#522-F5-P1] | proptest `prop_text_to_adf_holds_inv1` strategy `".*"` does NOT match `\n` — LF/CRLF/\n\n paths not generatively covered; rustdoc + AC-014 overstate coverage. Fix: change to `string_regex("(?s).*")` or explicit charset. | LOW | OPEN — fix before F5 Pass-2 |
| F-2 [#522-F5-P1] | BC-7.2.011 v1.10.0 inline changelog + spec-changelog [1.3.21] state "13 rows" in EC-12 behavior table; actual count is 12. Correct prose to "12". | LOW | OPEN — fix before F5 Pass-2 |
| F-3 [#522-F5-P1] | `text_to_adf("")` and `text_to_adf("\n\n\n")` → empty-paragraph shape unpinned; `assert_no_raw_newline_in_text_nodes` trivially passes on empty. Add explicit positive `assert_eq!` on the `doc > [paragraph > [text("")]]` shape. | LOW | OPEN — fix before F5 Pass-2 |

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
| PRE-EXISTING-LONE-CR | heading+codeBlock raw `\r` survival | **IN PROGRESS as #522** — EC-11+EC-12 fix at .worktrees/S-522 @ b999d97. F5 1/3 CLEAN. | MED | IN PROGRESS — #522 |
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

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-17] Issue #522 IN PROGRESS — F5 1/3 CLEAN (expanded delta EC-11+EC-12). 3 LOW findings (F-1/F-2/F-3) to fix before re-running. BC-7.2.011 v1.10.0. S-522 14 ACs. Code LOCAL @ b999d97. BC 598. DEC-111. Prior: #492 CYCLE CLOSED → develop @ 3ba8ea2 (DEC-109).**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-17 |
| **Position** | **Issue #522 EXPANDED two-chokepoint cycle (EC-11 + EC-12): F1-F4 ALL COMPLETE. F5 1/3 CLEAN — 3 LOW findings to fix (F-1/F-2/F-3) before 3 fresh passes. BC-7.2.011 v1.10.0. S-522 14 ACs. Code LOCAL ONLY @ b999d97. DEC-111.** |
| **develop HEAD** | origin/develop = **3ba8ea2** (PR #521 #492 bug-fix). activation v0.6.0-dev.2. BC **598**. NFR **42**. ADR **16**. Stories **77** (authoritative). |
| **Convergence counter** | BC: **598**. NFR: **42**. ADR: **16**. Stories: **77** authoritative. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. Active worktree: .worktrees/S-522 @ b999d97 (LOCAL ONLY — not pushed). |
| **Next / Pending** | (1) Fix F-1 (proptest strategy dotall), F-2 (EC-12 table row count prose "13"→"12"), F-3 (empty-paragraph positive assert). (2) Run 3 FRESH clean adversarial passes over FULL EC-11+EC-12 delta. (3) F6 hardening. (4) F7 + PR. Fork-release-ops enablement PENDING (DEC-104). |
| **Resume prompt** | `Read .factory/STATE.md. Issue #522 IN PROGRESS — F5 1/3 CLEAN. Fix F-1/F-2/F-3 (see Blocking Issues) FIRST, then run 3 FRESH adversarial passes over FULL EC-11+EC-12 delta. Worktree: .worktrees/S-522 on fix/adf-push-text-cr-normalization-522 @ b999d97 (LOCAL ONLY). BC-7.2.011 v1.10.0. S-522 14 ACs. develop @ 3ba8ea2. DEC-111. STANDING: do NOT close #429 (DEC-029); OQ-5 open; E2E-PG-4 open; SEC-001 LOW deferred. Fork-release-ops PENDING (DEC-104). jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: see Session Resume Checkpoint above. Code: .worktrees/S-522 @ b999d97 LOCAL. BC-7.2.011 v1.10.0. S-522 14 ACs. F5 1/3 CLEAN. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read STATE.md.

**Step 2:** Verify worktree `.worktrees/S-522` exists on branch `fix/adf-push-text-cr-normalization-522` @ `b999d97`. Run `cargo test --lib adf` in worktree — expect 235 green. Run `cargo test` — expect 0 failures.

**Step 3 (BEFORE re-running F5):** Fix the 3 LOW findings from F5 Pass-1 (route to correct agents):
- **F-1** (test-writer): change `prop_text_to_adf_holds_inv1` strategy from `string_regex(".*")` to `string_regex("(?s).*")` or explicit `[\r\n\t a-z]{0,12}` charset so `\n` is generatively sampled. Same fix to `prop_492_arbitrary_string_holds_core_invariants` if it has the same gap. Also fix rustdoc + AC-014 prose that overstates proptest `\n` coverage.
- **F-2** (product-owner): BC-7.2.011 v1.10.0 inline spec-changelog entry + global spec-changelog [1.3.21] say "13 rows" in EC-12 behavior table — actual is 12. Correct prose.
- **F-3** (test-writer): add `assert_eq!` on the exact `doc > [paragraph > [text("")]]` JSON shape for `text_to_adf("")` and `text_to_adf("\n\n\n")` — positive pin, not just `assert_no_raw_newline` (which is trivially true for empty content).
After fixing all 3: run `cargo test --lib adf` (must pass) + count guards green.

**Step 4 (F5 continued):** Spawn 3 FRESH-CONTEXT adversary passes over the FULL expanded delta (EC-11 push_text/push_code + EC-12 text_to_adf). Require 3 CLEAN consecutive passes. Scrutiny priorities: (a) EC-12 empty-paragraph hazards (`""`, all-blank, all-newline → must NOT yield invalid empty-content paragraph); (b) single-line BYTE-IDENTICAL fast path for 5 call sites; (c) hardBreak trimming not leaving empty content arrays; (d) two-pass CRLF ordering; (e) code↔BC-EC-12↔story-AC-008..014 coherence. Pass-1 already consumed — re-run from Pass-2 (counter reset: need 3 CLEAN total).

**Step 5 (F6):** Proptest additions (`prop_text_to_adf_holds_inv1` with dotall + `prop_492_arbitrary_string_holds_core_invariants` updated) + cargo-mutants scoped to `push_text`/`push_code`/`text_to_adf` (diff scope) + cargo audit/deny.

**Step 6 (F7 + PR):** 5-dim delta convergence + fresh consistency-validator + input-drift check. Then PR via pr-manager (branch local — push first) targeting develop. Human merge gate.

**Step 7 (cycle close — S-7.02):** Codify TWO process gaps as lessons: (a) F5 partial-fix sweeps missed SIBLING stale CRLF doc sites repeatedly → add "same-document + cross-artifact + phase-input repro-sweep" checklist step to F5 AC-revision; (b) F1 Impact Boundary missed text_to_adf sibling path sharing INV-1 → F1 must enumerate sibling functions sharing a target invariant.

Durable follow-ups: see Drift Items section (WIN-AUTH-ENVLOCK-POISON, WIN-DENY-FRAGILITY, SEC-JR-SERVICE-NAME-GATE, WIN-RUNTIME-OAUTH-PROBE, WIN-AC004-DIRECTIONAL, #492-TEST-HARNESS-COUPLING, #492-PG-TRACE-TESTS, #429-DNC, OQ-5, E2E-PG-4, #400-Story-B, #372).

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #522 | fix(adf): ADF CR/newline normalization — EC-11 (push_text/push_code) + EC-12 (text_to_adf) | **IN PROGRESS — F5 1/3 CLEAN; fix F-1/F-2/F-3 before 3 fresh passes** | LOW/MED | F1-F4 ALL COMPLETE (235 adf tests green). Code LOCAL @ .worktrees/S-522 branch fix/adf-push-text-cr-normalization-522 @ b999d97. BC-7.2.011 v1.10.0 (EC-11+EC-12). S-522 14 ACs. DEC-110+DEC-111. |
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
