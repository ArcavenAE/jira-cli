---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-17T14:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "FACTORY IDLE — Issue #522 CYCLE CLOSED+MERGED (PR #523 → develop @ 53f6d98). No active worktree. Awaiting next work item. PRE-SESSION-CLEAR CHECKPOINT durable."
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
| **Last Updated** | 2026-06-17: (1) Issue #522 CYCLE CLOSED + MERGED. PR #523 squash-merged → develop @ 53f6d98 (#522 auto-closed). Full F1–F7: F5 caught HIGH CR-01 (bare \n Other-ctx via multi-line inline HTML → Jira 400); F6/F7 PASS. BC-7.2.011 v1.11.0. S-522 19 ACs HIGH. DEC-119. Factory idle — awaiting next work. (2) Bundle B maintenance sweep COMMITTED (GREEN): SC-01 bc_count frontmatter, SC-02 Document Map 573→598, SC-04 ADR-0016 CI-Gate paragraph, SC-06 risk-register + S-3.07 JRACLOUD-95368, SC-07 risk-register RESOLVED annotations. SC-05 DEFERRED; SC-03 DEFERRED. |
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
| DEC-107..119 | 2026-06-16..17: Issue #492 F5–F7+CYCLE-CLOSE (DEC-107..109) + Issue #522 full F1–F7+CYCLE-CLOSE (DEC-110..119). All CYCLE CLOSED. See `cycles/cycle-001/burst-log.md` "Archived Decisions DEC-107..119". | Feature Mode / #492+#522 | Phase 3 | 2026-06-16..17 |

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
| MAINT-2026-06-17-SC-05 | STORY-INDEX.md 77-count invariant | SC-05: STORY-INDEX.md total count not verified vs authoritative 77 stories in STATE.md. Deferred pending decision on whether STORY-INDEX.md is canonical or derived. | LOW | DEFERRED — no action taken in Bundle B |
| MAINT-2026-06-17-SC-03 | ADR location convention | SC-03: docs/adr/ vs .factory/architecture/adr/ convention discrepancy. Not actioned in Bundle B sweep. | LOW | DEFERRED — tracked for future CLAUDE.md/docs cleanup |
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
| **Position** | FACTORY IDLE between cycles. Last completed: Issue #522 (ADF CR/LF normalization, BC-7.2.011 v1.11.0) CYCLE CLOSED+MERGED via PR #523. No active worktree. Awaiting next work item. |
| **develop HEAD** | origin/develop = **53f6d98** (PR #523 squash-merged 2026-06-17). Note: local working checkout may still show 3ba8ea2 — run `git fetch origin` before any work. |
| **Activation** | v0.6.0-dev.2 @ 4258202. v0.5.0 STABLE shipped 2026-06-12. |
| **Counters** | BC **598**. NFR **42**. ADR **16**. Stories **77** (authoritative). |
| **Active worktree** | NONE — S-522 cleaned up. .factory worktree on factory-artifacts is mounted. |
| **jira-e2e env** | JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |
| **Standing constraints** | Do NOT close #429 (DEC-029). All fixes through full VSDD Feature Mode pipeline. Fork-release-ops INERT by default (enablement blocked on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE HIGH). |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: FACTORY IDLE. #522 CYCLE CLOSED+MERGED. No active worktree. develop @ 53f6d98. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md`.

**Step 2:** Confirm factory is IDLE — no in-flight cycle, no active worktree, develop @ 53f6d98, #522 CLOSED. If develop shows different HEAD, run `git fetch origin` first.

**Step 3 — Determine next work.** OPEN BACKLOG (priority order, all LOW unless noted):
- Fork-release-ops enablement PENDING (DEC-104; gated on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE HIGH — see Drift Items).
- **#429** jr_isolated crypto-random suffix — DO NOT close autonomously (DEC-029, human-deferred).
- **#400** Story B + engine items.
- **#372** cargo-mutants partial baseline.
- **#387/#368** git-history-rewrite/open-PR (force-push needed, deferred).
- **#209/#210** backlog.
- If human brings new feature/bug: run Feature Mode (F1–F7) per `workflows/feature.lobster`.

**Step 4 — STANDING CONSTRAINTS (survive session clear):**
- Do NOT close #429 (DEC-029, human-deferred).
- All fixes through full VSDD Feature Mode pipeline (orchestrator delegates, never hand-edits).
- Fork-release-ops workflows INERT by default (repo-variable gates unset) — enablement blocked on FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE (HIGH) in Drift Items.
- OQ-5, E2E-PG-4, SEC-001 LOW deferrals remain open.
- LESSON-F1-SIBLING-CASE: next Feature Mode F1 MUST enumerate sibling control-char/invariant cases at any normalization chokepoint.

Durable follow-ups: see Drift Items section.

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
| Burst history + archived decisions DEC-027..119 + archived phase rows + archived drift items + archived closed issues | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
