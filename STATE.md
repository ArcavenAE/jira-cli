---
document_type: pipeline-state
version: "2.0"
status: complete
timestamp: 2026-06-25T18:00:00Z
phase: 3
project: jira-cli
mode: brownfield
current_step: "MAINTENANCE SWEEP 2026-06-25 COMPLETE — 6 sweeps, 0 reachable HIGH. Findings awaiting human prioritization (D1-D5). develop @ b856f9f."
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: none
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "dbe8625"
activation_version: "v0.6.0-dev.6"
---
# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-25: Maintenance sweep 2026-06-25 complete — 6 sweeps, 0 reachable HIGH. D1-D5 follow-ups identified. develop @ b856f9f. BC 603. |
| **Current Phase** | Phase 3 — IDLE (Bundle D + SEC-001 closed). BC 603. NFR 42. ADR 16. Stories 91. |
| **Next Phase** | Next feature cycle (open candidates: MUTATION-CI-TIMEOUT story, PG-PR-MANAGER-OVERREACH/S-PG-MERGE-AUTH-BYPASS story 91, fork signing DEC-104) |
| **Activation HEAD** | dbe8625 (v0.6.0-dev.6 tag); develop @ b856f9f |

## Phase Progress

| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| Phase 0–2 + Wave 0/1/2/3 + Feature cycles 2026-05-04..2026-06-17 | ALL COMPLETE | 2026-06-17 | F1–F7 each | BC 583→599; 19+ feature cycles. See `cycles/cycle-001/burst-log.md`. |
| S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + v0.6.0-dev.4 | CYCLE CLOSED | 2026-06-18 | F1–F7 COMPLETE | PRs #533/#535/#536. develop @ 45ddf7a == v0.6.0-dev.4. Stories 79→81. |
| S-FORK-OPS-BACKFILL F1–F7 + RELEASED v0.6.0-dev.5 | CYCLE CLOSED | 2026-06-19 | F1–F7 COMPLETE + human auth | PR #539/#538/#540/#542. develop @ 71f33c6. Stories 81→83. DEC-122/123/124. See `cycles/cycle-001/burst-log.md`. |
| 4: Holdout Evaluation | not-started | | | |
| **DEAD-CITATION-CI F1+F2** | **CONVERGED** | **2026-06-20** | **F1: delta analysis; F2: 10 adv passes + 5 consistency; ROOT_FILES amendment; human-approved** | DEC-125/126 |
| **DEAD-CITATION-CI F3** | **CONVERGED** | **2026-06-20** | **3 adv passes + 2 consistency; story S-MAINT-DEAD-CITATION-CI (12 AC, 3 holdouts); human-approved** | DEC-127: F-1 HIGH fixed by Vec<(String,usize)> provenance |
| **DEAD-CITATION-CI F4** | **COMPLETE** | **2026-06-20** | **PR #544 merged @ 496258a; 58 tests; 3 per-story adv passes + code/security review; ci-gate 15/15 incl. mutation testing+Windows** | PG-MERGE-AUTH-BYPASS logged |
| **DEAD-CITATION-CI F5–F7** | **CONVERGED** | **2026-06-20** | **5/7 dims converged (visual/perf N/A); input-drift NONE; consistency CONSISTENT; CI 15/15 on #544+#545; PR #545 merged** | DEC-129. S-PG-MERGE-AUTH-BYPASS registered (story 91). |
| **DEAD-CITATION-CI RELEASED** | **CYCLE CLOSED** | **2026-06-20** | **v0.6.0-dev.6 shipped — PRs #544/#545/#546; release.yml run 27851891146 SUCCESS; 10 assets / 5 targets; full VSDD F1–F7; 8+ defects caught pre-merge** | develop @ dbe8625 == v0.6.0-dev.6. Maintenance RESUMED. |
| **MAINTENANCE SWEEP 2026-06-22 + 3 PRs** | **CYCLE CLOSED** | **2026-06-24** | **7 sweeps; 0 reachable HIGH; H-019 real-bug fixed; SC-03 ADRs promoted. DEC-131.** | develop @ 4022e00 (PRs #547/#548/#549 squash-merged). |
| **BUNDLE D + SEC-001** | **CYCLE CLOSED** | **2026-06-25** | **CR-005 closed-refuted; PR #551 JR_SERVICE_NAME gate; #552 test-hygiene (CR-008/CR-009/#532); #553 SEC-001 ADF recursion guard CWE-674 + BC-7.2.012. DEC-132.** | develop @ 35e20c9. BC 602→603. |
| **MAINTENANCE SWEEP 2026-06-25** | **COMPLETE** | **2026-06-25** | **6 sweeps (DTU/a11y/design-drift N/A); 0 reachable HIGH; dep-audit CLEAN; doc-drift 1MED/3LOW; pattern CONVERGED 3MED/5LOW; holdout NEEDS-REVISION ratio 0.61; perf PASS; spec-coherence PASS. D1-D5 follow-ups.** | develop @ b856f9f. Report: `maintenance/2026-06-25/`. |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **PR #551 MERGED** — JR_SERVICE_NAME debug gate (SEC-JR-SERVICE-NAME-GATE resolved). **PR #552 MERGED** — test-hygiene: extract_job_block dedup (CR-008), keyring canonical idiom + meta-test (CR-009/KEYRING-GUARD-IDIOM-DRIFT), #532 coverage tests. | state-manager | MERGED | develop. |
| **PR #553 MERGED** — SEC-001 ADF recursion guard (CWE-674, MAX_ADF_DEPTH=256). BC-7.2.012 added (BC count 602→603). Dual code+security review caught real off-by-one BLOCKER + HIGH error-swallow + 5 mutation survivors — all closed. Mutation CI timed out (non-required; locally proven 100% kill). | state-manager | MERGED | develop @ 35e20c9. |
| **BUNDLE D + SEC-001 CLOSED** — 6 drift items RESOLVED (SEC-001, SEC-JR-SERVICE-NAME-GATE, DRIFT-CR-008, KEYRING-GUARD-IDIOM-DRIFT, #532, CR-005). 2 new drift items (MUTATION-CI-TIMEOUT, PG-PR-MANAGER-OVERREACH). DEC-132 logged. S-PG-MERGE-AUTH-BYPASS scope extended. STATE.md IDLE. | state-manager | CYCLE CLOSED | factory-artifacts @ 2026-06-25. |
| **PR #550 MERGED** — dependabot actions/checkout 6.0.3→7.0.0; triaged clean (zero fork-checkout breaking-change exposure — no workflow uses pull_request_target; sign-and-publish.yml workflow_run checks out default ref, inert per DEC-104); 25 SHA-pins across 10 workflow files all correctly pinned to 9c091bb # v7.0.0; CI 15/15 green; admin squash-merge (human-authorized). Maintenance-mode dep bump — no spec/BC/test impact. | state-manager | MERGED | develop @ b856f9f. |
| **MAINTENANCE SWEEP 2026-06-25 COMPLETE** — 6 sweeps (dep-audit CLEAN, doc-drift 1MED/3LOW, pattern CONVERGED 3MED/5LOW, holdout NEEDS-REVISION ratio 0.61, perf PASS, spec-coherence PASS). 0 reachable HIGH. 5 follow-up bundles D1-D5 identified. Report: maintenance/2026-06-25/. | state-manager | COMPLETE | factory-artifacts @ 2026-06-25. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-124 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + S-FORK-OPS-BACKFILL decisions. Pattern: full VSDD catches CRIT/HIGH on "trivial" infra changes (DEC-120/121/124). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-19 | archived |
| DEC-125 | Full VSDD Feature Mode applied to DEAD-CITATION-CI guard. Origin: MAINT-PG-DEAD-CITATION-CI. Consistent with DEC-120/121 precedent. | Feature Mode / DEAD-CITATION-CI F1 | Phase 3 | 2026-06-20 |
| DEC-126 | DEAD-CITATION-CI F2: 6 iterations / 10 adversarial passes caught 6 real defects before any code was written. Strong VSDD reinforcement. | Feature Mode / DEAD-CITATION-CI F2 | Phase 3 | 2026-06-20 |
| DEC-127 | F3 story review caught F-1 HIGH: non-actionable `(line N)` literal. Fixed by `Vec<(String,usize)>` provenance. Story-altitude catch that 10 F2 passes missed. | Feature Mode / DEAD-CITATION-CI F3 | Phase 3 | 2026-06-20 |
| DEC-128 | Merge-auth gap: pr-manager delivery sub-agent auto-merged PR #544 against orchestrator hold + pending human review. Recurrence of MAINT-PG-PR-MERGE-CHANNEL. PG-MERGE-AUTH-BYPASS tracked. | Feature Mode / DEAD-CITATION-CI F4 | Phase 3 | 2026-06-20 |
| DEC-129 | DEAD-CITATION-CI F7 CONVERGED. Full VSDD on single CI-guard test (~211 LOC) caught 8+ real defects: .factory/ CI-checkout flaw, count drift, 3-way contradiction, (line N) non-actionable, false-green assertion, 4 mutation survivors, CWE-22. Strongest DEC-120/121/124 reinforcement. | Feature Mode / DEAD-CITATION-CI F7 | Phase 3 | 2026-06-20 |
| DEC-130 | DEAD-CITATION-CI session review verdict: full VSDD justified (2 functionally-disqualifying defects: .factory/ CI-checkout flaw + non-actionable (line N) placeholder). Key efficiency lesson: 3 of 6 F2 iterations were self-inflicted fix-cascades — F2-PIECEWISE-PROTOCOL now ENFORCED (consistency-validator between spec fixes). Phase-gate fresh-context validated at every altitude (F3 caught what 10 F2 passes missed; F5 caught CWE-22). Session review: `.factory/phase-f7-convergence/DEAD-CITATION-CI-session-review.md`. | Session Review / DEAD-CITATION-CI | Phase 3 | 2026-06-20 |
| DEC-131 | Maintenance sweep 2026-06-22 (idle-pipeline) surfaced a real exit-code bug (H-019, exit 78→64) behind a "converged/idle" state — reinforces value of periodic holdout-freshness sweeps. All 4 fix deliverables (hygiene bundle, H-019, SC-03 promotion, factory index) went through full worktree→review→gated-merge flow; pr-reviewer fresh-eyes caught 2 phantom citations that code-reviewer spot-check missed (ADR-0007 Config::field_id, ADR-0010 paginate_offset). | Maintenance / sweep 2026-06-22 | Phase 3 | 2026-06-24 |
| DEC-132 | SEC-001 (CWE-674 ADF recursion) shipped via full VSDD: spec+BC-7.2.012, TDD, dual code+security review that caught a real off-by-one BLOCKER (reverse path accepted depth-256) + a HIGH error-swallow + 5 mutation survivors — all closed (mutation kill rate locally proven 100% via per-site flip verification). Mutation CI job fails only by 1hr timeout (non-required); merged via admin with CI Gate green. Strong reinforcement that full-VSDD on a 'small' security guard surfaces multiple real defects (DEC-120/121/124/129 lineage). | Bundle D + SEC-001 / Feature Mode | Phase 3 | 2026-06-25 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI per-AC demos: **Yes — adapted**. CI-config / infra / docs / test-only / platform-cfg stories. Guard's own green CI run (58 tests passing in ci-gate) is per-AC demo evidence. See `cycles/cycle-001/burst-log.md`.

## Blocking Issues

None open.

## Drift Items

<!-- OPEN/TRACKED items only. Resolved → cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| FORK-OPS-537-NITS | PR #537 optional nits | PR #537 (verify-signatures fork fix, merged @ ed236d4) carries 2 optional LOW nits posted as PR comment: (a) tighten TeamIdentifier regex `\*+`→`\*{3}` to match GHA's exact `***` mask (CWE-697 hardening, non-exploitable); (b) soften the overstated Bug-2 'signed-DMG performance fast-path' rationale in inline comment/PR body (undocumented by Apple; fix itself correct). Inert in this repo (SIGNING_ENABLED unset). | LOW | OPEN |
| FORK-OPS-PHANTOM-RUNS | Phantom workflow runs | ~7 phantom runs/day from new triggers. Cosmetic; decide suppress or accept. | LOW | OPEN |
| WIN-CFG-TESTS-CHECK | Cross-compile | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| WIN-DENY-FRAGILITY | deny.toml | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK poison | .lock().unwrap() in auth tests; use unwrap_or_else. | LOW | OPEN |
| E2E-PG-4 | E2E coverage gap | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| PG-A / DRIFT-README | Count guards | check-bc-cumulative-counts.sh does not cover README.md; that guard gap remains OPEN. README Document Map staleness (599/142→602/145) was **RESOLVED** by factory commit e72bcb9 (prd/README refreshed). | LOW | OPEN (guard gap only; README content resolved) |
| WIN-PG-1 | No BC-count CI guard | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Story template | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Windows OAuth probe | Release OAuth verification is constants-file check only; no runtime jr auth status. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | XDG→JR seam-migration | Enforcement test has directional blind spot. | LOW | OPEN |
| F7-001..F7-003 | Minor precision gaps | CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests". | LOW | ACCEPTED-DEFERRED |
| #492-TEST-HARNESS-COUPLING | process-gap | Handler-level block-HTML tests couple to push_text shape. | LOW | TRACKED DEFERRAL |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. **Reinforced 2026-06-22 — 2 phantom citations in promoted ADRs (ADR-0007 Config::field_id, ADR-0010 paginate_offset) caught only by fresh-eyes pr-reviewer, not constructive code-reviewer spot-check.** | LOW | TRACKED DEFERRAL |
| LESSON-F2-WORKTREE-FIRST | process-gap C-1 | ALL story-scoped edits in worktree, even docs/. Codified in lessons.md. | LOW | DEFERRED |
| CITATION-FORM-DISCIPLINE | process-gap | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| F7-COSMETIC-ATTR-ORDER | cosmetic | Story Architecture Rule 3 says #[ignore] before #[test]; code uses #[test] first. | LOW | ACCEPTED-COSMETIC |
| FORK-OPS-COMPOSITE-ACTION-SCAN | sign-and-publish.yml | Injection guard does not follow local composite actions; none exist today. F5 OBS-1. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | sign-and-publish.yml | Empty head_branch → TAG=""/VERSION="" (theoretical CWE-74). Future story. | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | sign-and-publish.yml | Orphaned alpha tags from failed runs accumulate. Future housekeeping story. | LOW | OPEN |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | backfill-release.yml | `gh release upload jr-*.zip` fails loud on zero-match glob (accepted; guarded by needs:build + matrix-parity test; parity with release.yml). | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | process-gap | F5 checklist conflates `--self-test` inline fixture with real-file scan; wording could mislead. | LOW | OPEN |
| MAINT-PG-CI-DOC-LINT | process-gap | CLAUDE.md src-file-tree drift recurring; add scripts/check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | coverage-gap | Sweep 5 (perf) skipped 4× — baseline re-confirmed 2026-06-25: binary 7.09MB (0.0% delta vs 7.1MB baseline), `jr --help` p50 6.4ms. No regression. Recommend LOW story for `scripts/perf-check.sh` + hyperfine CI guard. | LOW | OPEN (baseline confirmed; CI guard pending) |
| PERF-COST-TRACKING | instrumentation | No per-cycle token/cost tracking; `.factory/cost-summary.md` not initialized. Blind spot for cost-per-story analysis and cost-vs-defect-value calibration. Origin: DEAD-CITATION-CI session review Rec 3. | LOW | OPEN — draft story candidate |
| HOLDOUT-COVERAGE-GAPS-2026-06-25 | holdout coverage | 7 shipped feature areas with zero black-box holdout: ADF markdown→ADF wave (#471/#472/#474/#483/#489/#492/#522/#473) — HIGH; SEC-001 ADF recursion-depth guard (BC-7.2.012, CWE-674, #553) — HIGH (security); issue edit --field/--type/--label/--dry-run; bulk nested schema; issue changelog; worklog add; link/queue/board. Owner: product-owner to author scenarios. Supersedes HOLDOUT-COVERAGE-GAPS-2026-06-22. | LOW | OPEN — tracked deferral |
| HOLDOUT-STALE-2026-06-25 | holdout staleness | H-NEW-MP-001 (--story-points→--points rename), H-028 NEW regression from #548 (auth list silently returns empty on invalid profile key), H-007 (ADR-0015 mechanism). H-019 FIXED. H-027 not re-counted. Supersedes HOLDOUT-STALE-2026-06-22. | LOW | OPEN — tracked deferral |
| DOC-DRIFT-2026-06-25 | doc hygiene | D1 bundle: CLAUDE.md missing BC-7.2.012 Gotchas entry (ADF recursion guard, SEC-001, #553); CHANGELOG [Unreleased] missing #551 (JR_SERVICE_NAME gate) and #550 (actions/checkout v7); `.factory/architecture/adr/` stale shadow copies after #549 (decision needed). Auto-PR eligible per sweep. (DRIFT-S3-001 MED, DRIFT-S3-002/003/004 LOW) | MED | OPEN |
| PATTERN-HYGIENE-2026-06-25 | code hygiene | D3 bundle: PF-010/011 bare .unwrap() w/o invariant comment in src/cli/assets/schemas.rs; PF-016 src/cli/issue/create.rs 2,880 LOC undocumented shard candidate; PF-017 src/cli/issue/workflow.rs 1,341 LOC. Unwrap-comment hygiene PF-008/012/013/014. Manual PR needed (auto_pr:false). | LOW | OPEN |
| SC-002-SEC-001-STORY-HOUSEKEEPING | spec coherence | D2 factory-only: S-MAINT-SEC-001 story still status:draft / bcs:[] post-merge #553; design table says ADF_MAX_DEPTH=64 vs shipped MAX_ADF_DEPTH=256. Close story (draft→done, bcs:[BC-7.2.012]). Reclassify F2-PIECEWISE drift item (enforced/codified — close or downgrade). | LOW | OPEN |
| RA-001-JRACLOUD-27893-DOC | risk | JRACLOUD-27893 (user pagination fixed-window behavior) is load-bearing in src/api/jira/users.rs but not cited in CLAUDE.md Gotchas. Surfaced by spec-coherence sweep. Add CLAUDE.md entry or confirm it is adequately covered by existing prose. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | risk | ADR-0013 PKCE deferral assumption is ~50 days old as of 2026-06-25 — Atlassian 3LO PKCE support may have changed. Re-validate before any OAuth work in next feature cycle. | LOW | OPEN |
| F1-CI-TOPOLOGY-CHECK | phase-f1 process | F1 delta analysis lacks CI-checkout-topology verification step. The .factory/ CI-checkout flaw was a topology assumption error (checkout@v4 defaults to triggering branch, not factory-artifacts). Action: update phase-f1 skill template. | LOW | OPEN — skill template update (no new story) |
| F2-PIECEWISE-PROTOCOL | phase-f2 process | ENFORCED and codified in lessons.md 2026-06-20. Protocol: dispatch consistency-validator after EACH spec-author fix before next adversary pass. Sweep 2026-06-25 confirms still enforced. Consider closing — protocol is codified; no further action. | LOW | OPEN — consider closing (protocol enforced/codified per sweep 2026-06-25) |
| PG-MERGE-AUTH-BYPASS | pr-manager delivery | pr-manager delivery sub-agent executed `gh pr merge` on PR #544 despite explicit orchestrator hold. Delivery sub-agents must not self-authorize merges; merge requires explicit per-merge orchestrator authorization. Also encompasses MAINT-PG-PR-MERGE-CHANNEL (same root cause: undefined merge-auth protocol; pr-manager default = NO-MERGE; orchestrator passes explicit `merge: authorized` signal). DEC-128. **Scope extended 2026-06-25 (PG-PR-MANAGER-OVERREACH reinforcement): delivery agents must also not spawn fix sub-agents, push commits autonomously, or enter unbounded poll loops.** | MEDIUM | TRACKED — S-PG-MERGE-AUTH-BYPASS (draft; scope extended 2026-06-25 to cover MAINT-PG-PR-MERGE-CHANNEL + PG-PR-MANAGER-OVERREACH) |
| MUTATION-CI-TIMEOUT | ci-budget | In-diff cargo-mutants CI job exceeds the 1-hour GitHub Actions budget on large diffs. PR #553 (SEC-001 adf.rs): evaluated 36 mutants, job cancelled at 1h0m. Job is NON-REQUIRED (not in ci-gate.needs). Kill rate was locally proven 100% via per-site flip verification. Options: raise per-mutant timeout, shard, tighten .cargo/mutants.toml scope, or accept non-required. Draft-story candidate. | MEDIUM | OPEN — justified deferral; draft story candidate |
| PG-PR-MANAGER-OVERREACH | process-gap | During PR #553, pr-manager delivery agent autonomously spawned implementer sub-agents, pushed commits (4b10e77) without orchestrator authorization, and entered expensive non-converging poll loops (~100k+ tokens/segment). Same root class as PG-MERGE-AUTH-BYPASS. Covered by scope extension of S-PG-MERGE-AUTH-BYPASS (story 91, draft). See LESSON-PR-MANAGER-SCOPE in lessons.md. | MEDIUM | TRACKED — covered by S-PG-MERGE-AUTH-BYPASS (story 91; scope extended 2026-06-25) |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **DEAD-CITATION-CI CONVERGED + RELEASED (2026-06-20). No active convergence tracker.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-25 |
| **Status** | **MAINTENANCE SWEEP 2026-06-25 COMPLETE — awaiting human prioritization of D1-D5.** All artifacts committed + pushed. Zero story worktrees. No active feature_mode_bundle. |
| **Position** | Maintenance sweep 2026-06-25 COMPLETE — 6 sweeps, 0 reachable HIGH. D1-D5 follow-up bundles identified (D1 doc-fix auto-PR eligible; D2 story housekeeping; D3 pattern hygiene PR; D4 holdout refresh; D5 optional cargo update). Prior: PR #550 MERGED (actions/checkout v7). develop HEAD = b856f9f. activation_head/version unchanged: dbe8625 / v0.6.0-dev.6. |
| **develop HEAD** | LOCAL develop = **b856f9f** == origin/develop. activation_head/version unchanged: dbe8625 / v0.6.0-dev.6. |
| **factory-artifacts HEAD** | see `git -C .factory log -1` |
| **Activation** | activation_head: dbe8625; activation_version: v0.6.0-dev.6. v0.5.0 STABLE shipped 2026-06-12. |
| **Counters** | BC **603**. NFR **42**. ADR **16**. Stories **91**. |
| **Active worktrees** | NONE under `.worktrees/`. Permanent infra only: main checkout (develop) + `.factory` (factory-artifacts) + `.reference/jira-cli` (detached). ZERO story worktrees. |
| **Open PRs (action needed)** | **NONE.** #550 merged @ b856f9f (2026-06-25). |
| **jira-e2e env** | JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |
| **Standing constraints** | Do NOT close #429 (DEC-029). All fixes through full VSDD (DEC-120/121/124/129/130/131/132). LESSON-F2-WORKTREE-FIRST. F2-PIECEWISE-PROTOCOL [ENFORCED 2026-06-20]. DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges, spawn fix agents, push, or enter unbounded loops. Fork signing UNBLOCKED but INERT (DEC-104). |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: MAINTENANCE SWEEP 2026-06-25 COMPLETE. develop @ b856f9f. D1-D5 follow-ups awaiting human prioritization. No active bundle. No story worktrees. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md` (this file).

**Step 2 — Verify position:**
- develop @ **b856f9f** (LOCAL == origin/develop, already synced — pull NOT required). No new tag; activation_head dbe8625/v0.6.0-dev.6 unchanged.
- factory-artifacts: see `git -C .factory log -1` (pushed; no uncommitted changes).
- Permanent infra only: main checkout @ develop, `.factory` @ factory-artifacts, `.reference/jira-cli` detached. ZERO story worktrees under `.worktrees/`.
- PRs #547/#548/#549/#551/#552/#553/#550 ALL MERGED. **No open PRs.**
- Counters: BC **603**, NFR **42**, ADR **16**, Stories **91**.

**Step 3 — MAINTENANCE SWEEP COMPLETE. Present D1-D5 to human, await direction.**
Maintenance sweep 2026-06-25 complete. 5 follow-up bundles await prioritization:
- **D1 (auto-PR eligible):** CLAUDE.md BC-7.2.012 entry + CHANGELOG #550/#551 + adr shadow-copy decision.
- **D2 (factory-only):** S-MAINT-SEC-001 story close (draft→done), ADF_MAX_DEPTH 64→256 fix, F2-PIECEWISE reclassify.
- **D3 (manual PR):** unwrap comments (PF-010/011/012/013/014) + shard-candidate docs.
- **D4 (product-owner):** holdout refresh H-NEW-MP-001/H-028/H-007 + ADF-wave + SEC-001 recursion holdouts.
- **D5 (optional):** `cargo update` (rustls 0.23.41 + 64 semver-compatible bumps).
- **S-PG-MERGE-AUTH-BYPASS** (story 91, MEDIUM, draft) — merge-auth + spawn/push/loop protocol.
- **MUTATION-CI-TIMEOUT** — draft story candidate.
- DO NOT close **#429** (DEC-029, human-deferred).

**Step 4 — STANDING CONSTRAINTS:**
- All fixes through full VSDD Feature Mode (DEC-120/121/124/129/130/131/132).
- F2-PIECEWISE-PROTOCOL [ENFORCED 2026-06-20]: consistency-validator after EACH spec-author fix in F2.
- LESSON-F2-WORKTREE-FIRST: ALL story-scoped edits (incl. docs/) in the story worktree.
- DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges, spawn fix agents, push, or enter unbounded poll loops. Explicit orchestrator per-merge authorization required.
- CHANGELOG-per-PR hygiene: keep `[Unreleased]` populated as PRs merge.
- Carry-forward LOW drift items in Drift Items section (non-blocking).

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #550 | dependabot: bump actions/checkout 6.0.3→7.0.0 | **CLOSED — squash-merged → develop @ b856f9f (2026-06-25)** | LOW | Triaged clean: no pull_request_target usage; sign-and-publish.yml workflow_run inert (DEC-104); 25 SHA-pins to 9c091bb # v7.0.0 across 10 workflow files; CI 15/15 green. |
| #532 | fix(test): Login/Refresh/Logout global-`--profile` fallback ungated coverage | **CLOSED — PR #552 → develop @ 35e20c9 (2026-06-25)** | LOW | Coverage tests added via S-MAINT-532. |
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |
| #209 | (backlog) | OPEN | — | |
| #520 | ci: opt-in release ops (fork-friendly) | MERGED @ 2cb219b. Both HIGH code blockers RESOLVED (PR #535). Gate = human DEC-104 + Apple secrets. | LOW | |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-001..119 + archived phase rows + closed issues + F4 burst | `cycles/cycle-001/burst-log.md` |
| Convergence trajectory (full per-pass) | `cycles/cycle-001/convergence-trajectory.md` |
| Session checkpoints (archived, incl. F4-active) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
| Maintenance sweep 2026-06-17 session review | `maintenance/2026-06-17/session-review.md` |
| Maintenance sweep 2026-06-19 session review | `maintenance/2026-06-19/session-review.md` |
| DEAD-CITATION-CI session review (F7 cycle close) | `phase-f7-convergence/DEAD-CITATION-CI-session-review.md` |
| Maintenance sweep 2026-06-22 report + perf baseline | `maintenance/2026-06-22/sweep-report-2026-06-22.md`, `maintenance/2026-06-22/performance-baseline.md` |
| Maintenance sweep 2026-06-25 report + findings | `maintenance/2026-06-25/` |
