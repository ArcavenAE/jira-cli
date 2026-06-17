---
document_type: pipeline-state
version: "2.0"
status: active
timestamp: 2026-06-16T14:00:00Z
phase: phase-3-tdd-implementation
project: jira-cli
mode: BROWNFIELD
current_step: "Issue #492 bug-fix cycle CLOSED — PR #521 squash-merged → develop @ 3ba8ea2; #492 closed. Follow-up #522 open (pre-existing lone-CR). No active feature. DEC-109."
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
| **Last Updated** | 2026-06-16: Issue #492 cycle CLOSED — PR #521 squash-merged → develop @ 3ba8ea2 (14/14 CI green incl CI Gate; #492 auto-closed). Follow-up #522 open (pre-existing lone-CR). BC 598 / NFR 42 / ADR 16 / Stories 75. DEC-109. |
| **Current Phase** | Phase 3 — TDD Implementation IN PROGRESS — no active feature. develop @ 3ba8ea2. BC 598. NFR 42. ADR 16. Stories **75** (authoritative). |
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
| Issue #492 cycle CLOSED. PR #521 squash-merged → develop @ 3ba8ea2 (14/14 CI green incl CI Gate; #492 auto-closed). Follow-up #522 filed (pre-existing lone-CR OOS defect, pulldown-cmark CR-normalization gap in heading/codeBlock via Event::Text path). Worktree .worktrees/S-492 removed; local branch fix/adf-block-html-hardbreak-492 deleted. S-7.02 cycle-closing checklist complete (see cycles/cycle-001/lessons.md). DEC-109. | Agent state-manager | CYCLE CLOSED | develop @ 3ba8ea2. BC 598 / NFR 42 / ADR 16 / Stories 75. |

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
| PRE-EXISTING-LONE-CR | heading+codeBlock raw `\r` survival | pulldown-cmark CR-normalization gap: lone `\r` (no `\n`) passes through `Event::Text → push_text` into heading/codeBlock text nodes. JSON-level hazard. NOT introduced by #492 (Algorithm B path proven CR-free). Pinned: `#[ignore]`d `test_lone_cr_survives_pre_existing_492_oos`. **Follow-up issue #522 FILED + OPEN.** | MED | OPEN — tracked as #522 |
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

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **[2026-06-16] Issue #492 CYCLE CLOSED — PR #521 squash-merged → develop @ 3ba8ea2 (DEC-109). F5: 15-pass/3-clean CONVERGED (0 code defects; all findings doc/spec precision). F6: proptest 150k/5-invariant + 100% effective mutation. F7: 5/5 DELTA_CONVERGED. BC-7.2.011 v1.9.6 FINAL. Follow-up #522 open (OOS lone-CR). Stories 75. BC 598.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-16 |
| **Position** | **Issue #492 CYCLE CLOSED. PR #521 squash-merged → develop @ 3ba8ea2 (DEC-109). No active feature. BC-7.2.011 v1.9.6 FINAL. Follow-up #522 open (pre-existing lone-CR OOS).** |
| **develop HEAD** | origin/develop = **3ba8ea2** (PR #521 #492 bug-fix). activation v0.6.0-dev.2. BC **598**. NFR **42**. ADR **16**. Stories **75** (authoritative). |
| **Convergence counter** | BC: **598**. NFR: **42**. ADR: **16**. Stories: **75** authoritative. jira-e2e env: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. No active worktree. |
| **Next / Pending** | No active feature. Fork-release-ops enablement PENDING (DEC-104). #522 open (lone-CR OOS). Standing drift: WIN-DENY-FRAGILITY (LOW), SEC-JR-SERVICE-NAME-GATE (LOW), WIN-AUTH-ENVLOCK-POISON (LOW), WIN-RUNTIME-OAUTH-PROBE (LOW, accepted ADR-0016), WIN-AC004-DIRECTIONAL (LOW), #492-TEST-HARNESS-COUPLING (LOW, deferred), #492-PG-TRACE-TESTS (LOW, deferred). Open issues: #522 (OPEN), #429 (DNC), #400 Story B, #372. |
| **Resume prompt** | `Read .factory/STATE.md. Issue #492 CYCLE CLOSED — PR #521 → develop @ 3ba8ea2 (DEC-109). BC-7.2.011 v1.9.6 FINAL. No active feature. Follow-up #522 open (pre-existing lone-CR OOS). STANDING: do NOT close #429 (DEC-029); OQ-5 open; E2E-PG-4 open; SEC-001 LOW deferred. Fork-release-ops enablement PENDING (DEC-104). jira-e2e: JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true.` |

## RESUME PLAN (cold-start, self-contained)

### State snapshot

- Issue #492 CYCLE CLOSED: PR #521 squash-merged → develop @ 3ba8ea2 (14/14 CI green incl CI Gate; #492 auto-closed; DEC-109). BC-7.2.011 v1.9.6 FINAL. No active feature. No active worktree.
- Follow-up #522 OPEN: pre-existing lone-CR OOS defect (pulldown-cmark CR-normalization gap; heading/codeBlock Event::Text path). Pinned: `#[ignore]`d test. S-7.02 cycle-closing checklist complete (cycles/cycle-001/lessons.md). LESSON-RESUME-STATE-RECONCILE codified.
- develop @ 3ba8ea2. BC 598 / NFR 42 / ADR 16 / Stories 75. Fork-release-ops enablement PENDING (DEC-104; read `.factory/research/fork-release-ops-integration.md`).

### Durable follow-ups (tracked Drift Items)

WIN-AUTH-ENVLOCK-POISON (LOW), WIN-DENY-FRAGILITY (LOW), SEC-JR-SERVICE-NAME-GATE (LOW), WIN-RUNTIME-OAUTH-PROBE (LOW, accepted ADR-0016), WIN-AC004-DIRECTIONAL (LOW), #492-TEST-HARNESS-COUPLING (LOW, deferred), #492-PG-TRACE-TESTS (LOW, deferred). Standing (non-Windows): #429 do-not-close, OQ-5, E2E-PG-4, #400 Story B, #372, #522.

### Process note

Full-VSDD run caught 3 classes invisible to the prior gate each time — pre-F4 research (windows-sys 0.60 / Compress-Archive), the integration gate (real jr.exe Windows stack-overflow prod bug), and repo-settings drift (branch protection). Lessons codified: LESSON-PRESENCE-ANCHOR, LESSON-WIN-CI-CHECKLIST, LESSON-INTEGRATION-GATE-PROD, LESSON-MATRIX-BRANCH-PROTECTION, LESSON-ADVERSARY-CHECKOUT-RACE, LESSON-RESUME-STATE-RECONCILE. #492: single Algorithm B path proven correct across 15 F5 passes (M→L→0 severity decay); F6 proptest 150k cases + 100% effective mutation; F6 surfaced pre-existing lone-CR OOS defect → #522.

## Open Issues Tracker

<!-- OPEN issues only. Closed rows archived to cycles/cycle-001/burst-log.md "Archived Open Issues Tracker Closed Rows". -->

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #522 | fix(adf): lone-CR survival in heading/codeBlock (pre-existing OOS from #492 F6) | OPEN | LOW/MED | Pre-existing lone-CR defect (pulldown-cmark CR-normalization gap in Event::Text path). Surfaced by #492 F6 proptest. Pinned: `#[ignore]`d test. NOT a #492 regression. DEC-109. |
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
