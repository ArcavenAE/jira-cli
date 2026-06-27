---
document_type: pipeline-state
version: "2.0"
status: complete
timestamp: 2026-06-27T22:30:00Z
phase: 3
project: jira-cli
mode: brownfield
current_step: "IDLE. E2E OFFLINE-CLI-GUARD TIER DELIVERED (2026-06-27). PR #563 squash-merged → develop @ 894cc9d. 5 regression pins (BC-3.4.017/BC-7.3.010). DEC-139. Stories 92→93. Awaiting direction."
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: none
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "342987f"
activation_version: "v0.6.0-dev.7"
---
# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-06-27: E2E offline-CLI-guard tier delivered — PR #563 squash-merged → develop @ 894cc9d. 5 regression pins (BC-3.4.017/BC-7.3.010). Guards confirmed already-implemented (test gap, not code bug). Full VSDD (F5 pre-merge 1 MED+4 LOW, all fixed). DEC-139. Stories 92→93. |
| **Current Phase** | Phase 3 — IDLE (E2E offline-CLI-guard tier delivered; v0.6.0-dev.7 shipped). BC **605**. NFR 42. ADR 16. Stories **93**. Holdouts 70. |
| **Next Phase** | Next feature cycle (open candidates: MUTATION-CI-TIMEOUT story, PG-PR-MANAGER-OVERREACH/S-PG-MERGE-AUTH-BYPASS story 91, fork signing DEC-104, holdout/wiremock unblocked by BC-7.2.013/014/BC-6.2.018) |
| **Activation HEAD** | 342987f (v0.6.0-dev.7 tag); develop @ 3d8f15b (PR #562 squash-merged 2026-06-27) |

## Phase Progress

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| Phase 0–2 + all Feature cycles 2026-05-04..2026-06-27 (archived) | ALL COMPLETE | see burst-log | — | See `cycles/cycle-001/burst-log.md` for all prior cycles. BC 583→603. |
| **CACHE-COVERAGE AUDIT + P1/P2 — COMPLETE** | **COMPLETE** | **2026-06-27** | **9 families × D1–D6; HIGH gaps closed by PR #561 (8 tests). DEC-135.** | develop 9657b1e → 5ab4e0f. PR #561 merged. |
| **E2E EDGE-CASE AUDIT — COMPLETE (record-only) 2026-06-27** | **COMPLETE** | **2026-06-27** | **2-part static audit; 5H+13M+11L gaps; live E2E is happy-path-by-design. DEC-137.** | develop unchanged @ 5ab4e0f. No code merged. |
| **BC-SUBCLAUSE PASS — CONVERGED + PR #562 — COMPLETE 2026-06-27** | **COMPLETE** | **2026-06-27** | **4 BCs + 1 EC (603→605); BC-7.2.013/014/BC-7.3.010/BC-6.2.018/BC-X.10.001 EC-1; 6-pass diverse-lens F2 + external research validation; PR #562 docstring residual (comment-only, 15/15 CI). DEC-138. MISSING-BC-SUBCLAUSE-PATTERN RESOLVED.** | develop @ 3d8f15b (PR #562). BC 605. |
| **E2E OFFLINE-CLI-GUARD TIER — DELIVERED PR #563 — COMPLETE 2026-06-27** | **COMPLETE** | **2026-06-27** | **5 regression pins; guards confirmed already-implemented (test gap not code bug); full VSDD w/ F5 adversarial gate (1 MED+4 LOW, all fixed pre-merge); 15/15 CI green. DEC-139.** | develop @ 894cc9d (PR #563). Stories 92→93. |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **E2E EDGE-CASE AUDIT COMPLETE (record-only)** — 2-part static audit: 27 read + ~70 write edges; 5H+13M+11L gaps. Live E2E is happy-path-by-design. E2E-EDGE-CASE-GAPS-2026-06-27 + MISSING-BC-SUBCLAUSE-PATTERN tracked (both MEDIUM). DEC-137. | state-manager | COMPLETE | develop unchanged @ 5ab4e0f. No code merged. |
| **BC-SUBCLAUSE PASS — F2 CONVERGENCE (6 passes, diverse-lens)** — 4 BCs + 1 EC: BC-7.2.013 (footnote→ADF), BC-7.2.014 (bare-URL autolink), BC-7.3.010 (JSON render invariant), BC-6.2.018 (cache warm-hit zero-HTTP), BC-X.10.001 EC-1 (partial_match no-network). Anchor-adequacy lens caught pretty-print overclaim, footnote-pruning misstatement, off-by-one depth-boundary, expect(1)-vs-absence mismatch. 603→605. | adversary/state-manager | CONVERGED | factory-artifacts ba60b15. |
| **EXTERNAL RESEARCH VALIDATION** — 5 ADF/markdown claims CORROBORATED vs Atlassian ADF docs + GFM/CommonMark specs. Added ftp:// deliberate-exclusion EC-12 + holdout-framing guard to BC-7.2.014. Report: `.factory/research/adf-bc-external-validation-2026-06-27.md`. | research-agent | COMPLETE | factory-artifacts ba60b15. |
| **PR #562 MERGED + L2 ALIGNMENT** — `docs(test): correct stale RED-gate docstring`. develop @ **3d8f15b**. Comment-only; adversary CLEAN; 15/15 CI green. L2 bc-06 42→43, bc-07 91→92. CANONICAL-COUNTS PENDING→YES. check-bc-cumulative-counts.sh: OK at 605. DEC-138. | state-manager | COMPLETE | develop @ 3d8f15b. BC 605. |
| **E2E OFFLINE-CLI-GUARD TIER DELIVERED** — PR #563 squash-merged → develop @ **894cc9d**. 5 regression pins: `test_edit_field_and_label_combined_exits_64_with_guard_message`, `test_edit_field_multi_key_bulk_exits_64_with_c1_message` (BC-3.4.017, `tests/issue_edit_field.rs`); `test_issue_changelog_…`, `test_queue_view_…`, `test_requesttype_list_…` (BC-7.3.010, `tests/json_error_shape.rs`). Guards confirmed ALREADY IMPLEMENTED (test gap). F5 pre-merge: 1 MED + 4 LOW, all fixed. 15/15 CI. S-E2E-CLI-GUARD-COVERAGE-1 filed. Stories 92→93. DEC-139. E2E-EDGE-CASE-GAPS-2026-06-27 offline-CLI tier CLOSED. | state-manager | COMPLETE | develop @ 894cc9d. BC 605. |

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
| DEC-133 | **DEPENDABOT-ACTION-SOAK standing policy:** third-party GitHub Action dependabot bumps require (a) ≥7-day soak from publication date to merge date, AND (b) supply-chain triage confirming SHA-pin integrity (pinned commit matches the upstream tag) + clean advisory check (zero CVEs/GHSA), before the orchestrator authorizes merge. Established on PR #557 (softprops/action-gh-release 3.0.0→3.0.1, pub 2026-06-19, merged 2026-06-26 — exactly 7 days). Human-approved 2026-06-26 as the standing soak floor. Triage docs: `.factory/code-delivery/PR-557-supply-chain-triage.md` + `.factory/research/PR-557-action-gh-release-3.0.1-soak.md`. | PR #557 / Supply-chain triage | Phase 3 | 2026-06-26 |
| DEC-134 | **D4 holdout refresh converged via full VSDD adversarial discipline.** Adversary caught a CRITICAL false-fail boundary off-by-one in H-NEW-SEC-001 (N `>` prefixes → ADF depth N+1; 255 prefixes REJECT at depth 256; accept boundary is 254 not 255). The pass-1 remediation introduced a factually-wrong `required`-flag rationale in H-007 (fix-cascade), caught by pass-2 adversary. F2-PIECEWISE/fresh-context value reinforced (DEC-120/121/129/130 lineage): a CRITICAL defect in a holdout scenario — not source code — would have caused Phase 4 to reject a correct binary. LOW observations O-1/O-3 escalated to source regression-pin tests (PR #560, develop @ 9657b1e) per human direction. HOLDOUT-COVERAGE-GAPS HIGH gaps CLOSED; HOLDOUT-STALE H-NEW-MP-001+H-007 FIXED. | D4 holdout refresh | Phase 3 | 2026-06-26 |
| DEC-135 | **Cache-coverage audit mapped 9 families × D1–D6 behavior dimensions; HIGH gaps closed by PR #561 regression pins.** Audit (`cache-coverage-audit-2026-06-27.md`) assessed 9 cache families (workspace, resolutions, cmdb_fields, fields, object_type_attrs, project_meta, request_types, request_type_fields, teams) across 6 dimensions (D1 hit/miss, D2 warm-hit no-HTTP, D3 stale/evict, D4 format-drift self-heal, D5 write-error resilience, D6 profile-isolation). HIGH gaps (D6 per-profile isolation ×6 families, D4 fields.json self-heal) closed by 8 regression-pin unit tests in PR #561 (develop @ 5ab4e0f). Anchor mis-citations in audit corrected at authoring: BC-6.3.001→BC-6.2.009 (isolation) and BC-6.2.013→BC-6.2.011 (self-heal). MED/LOW gaps (P3–P8) deferred to CACHE-COVERAGE-GAPS-2026-06-27 drift item pending BC sub-clause prerequisites. E2E zero cache-behavior assertions confirmed correct — D2 warm-hit no-HTTP requires wiremock tier, not live E2E. | Cache-coverage audit + P1/P2 | Phase 3 | 2026-06-27 |
| DEC-136 | **PRs #560/#561 shipped via lighter test-hardening flow (deviation from "all fixes through full VSDD"); reconciled by retroactive F5 + F3 + F7 per human direction.** PRs #560 (2 ADF regression pins) and #561 (8 cache unit tests) were delivered without a pre-delivery story file (missing F3) or fresh-context adversarial gate (missing F5). Retroactive backfill: F5 post-merge review CLEAN (0 CRIT/HIGH/MED, 3 LOW — no follow-up PR required); F3 story S-D4-TEST-HARDENING-BACKFILL-1 filed (10 ACs, retroactive:true); F7 gate: CONVERGED-WITH-NOTED-DEVIATION. **F5 deviation:** 1 pass, not canonical 3 — justified as retroactive, test-only, LOW-novelty, zero-finding. F5 confirmed the lighter flow leaked no defect here. **Gate-skip is itself the process-gap:** silently skipping the adversarial gate on "trivial" test-only PRs is not safe — the adversary's [process-gap] note confirmed this. TEST-ONLY-GATE-ELIGIBILITY tracked as MEDIUM drift item. Lineage: DEC-120/121/124/129 (trivial changes still warrant the gate). | PRs #560/#561 retroactive rigor backfill | Phase 3 | 2026-06-27 |
| DEC-137 | **E2E edge-case coverage audit completed (record-only); gap inventory captured by tier; recurring missing-BC-sub-clause blocker identified.** Two-part static audit (no live run, no mutations) mapped 27 read commands + ~70 write/state edges. Key insight: live E2E is happy-path-by-design — edge-case coverage (ADF body-shape, cache no-HTTP, forced 429/401/400) belongs at wiremock/holdout tiers, NOT live E2E. Infra edges (pagination JRACLOUD-95368/71293, 429 cap, 401 refresh) are already GREEN at wiremock tier and must not be re-created live. Recurring blocker identified: ADF markdown→ADF (#471/472/474/483/489/492/522/473), cache D2 warm-hit no-HTTP, and read error-channel/partial_match behaviors lack dedicated BC sub-clauses, blocking holdout authoring (broken-anchor class). Gaps tracked as E2E-EDGE-CASE-GAPS-2026-06-27 + MISSING-BC-SUBCLAUSE-PATTERN (both MEDIUM). Reports: `.factory/research/e2e-edge-case-audit-2026-06-27-read.md`, `.factory/research/e2e-edge-case-audit-2026-06-27-write.md`. | E2E edge-case coverage audit | Phase 3 | 2026-06-27 |
| DEC-138 | **BC-sub-clause pass CONVERGED (4 BCs + 1 EC, 603→605); 6-pass diverse-lens F2 adversarial convergence + external research validation; unblocks holdout/wiremock backlog; PR #562 docstring residual shipped.** Authored BC-7.2.013 (footnote→ADF, #472, promoted), BC-7.2.014 (bare-URL autolink, #473, promoted), BC-7.3.010 (JSON render invariant + error channel, #526, NEW), BC-6.2.018 (cache warm-hit zero-HTTP all 9 families, NEW), BC-X.10.001 EC-1 (partial_match no-network, NEW EC). Diverse-lens F2: accuracy + anchor-adequacy run as distinct lenses — anchor-adequacy caught pretty-print overclaim, footnote-pruning misstatement, off-by-one depth-boundary (N+1), expect(1)-vs-absence mismatch; self-inflicted fix-cascade (DEC-130 pattern) caught next pass. External research validation (research-agent): all 5 ADF/markdown claims CORROBORATED vs Atlassian ADF docs + GFM/CommonMark specs; added ftp:// deliberate-exclusion EC-12 + holdout-framing guard to BC-7.2.014. PR #562 `docs(test): correct stale RED-gate docstring in adf_recursion_depth.rs` squash-merged → develop @ 3d8f15b (comment-only; adversary gate CLEAN; 15/15 CI green). MISSING-BC-SUBCLAUSE-PATTERN RESOLVED. P4/P5 cache no-HTTP + G-ADF-FOOTNOTE/G-ADF-BARE-URL holdout items now UNBLOCKED. | BC-sub-clause pass | Phase 3 | 2026-06-27 |
| DEC-139 | **E2E offline-CLI-guard tier delivered (PR #563, 5 regression pins); empirically confirmed guards were already implemented (test gap, not code bug); full VSDD w/ adversarial gate applied per TEST-ONLY-GATE-ELIGIBILITY.** PR #563 `test(cli): pin --field/--label & C-1 edit guards and --output json error-shape coverage` squash-merged → develop @ 894cc9d (2026-06-27). 5 regression pins: 2 in `tests/issue_edit_field.rs` (BC-3.4.017 — `--field`+`--label` mutual-exclusion FIX-F5-001, C-1 multi-key bulk guard) + 3 in `tests/json_error_shape.rs` (BC-7.3.010 — error-envelope shape for `issue changelog`, `queue view`, `requesttype list`). All 5 tests PASS without any production change — the audit hypothesis ("offline-CLI tier, behavior present but unpinned") was correct. F5 fresh-context adversarial review pre-merge: 1 MED (exit-code doc typo in AC-003 `code:1` vs `code:64`) + 4 LOW, all fixed before merge. Post-merge: CLEAN. 15/15 CI green. F3 traceability story S-E2E-CLI-GUARD-COVERAGE-1 filed (story #93). DEC-128 gated-merge honored. Stories 92→93. E2E-EDGE-CASE-GAPS-2026-06-27 offline-CLI tier closed; wiremock + holdout tiers remain open. | E2E offline-CLI guard tier | Phase 3 | 2026-06-27 |

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
| HOLDOUT-COVERAGE-GAPS-2026-06-25 | holdout coverage | HIGH gaps CLOSED by D4 (2026-06-26): ADF markdown→ADF wave + SEC-001 recursion-guard now covered (H-NEW-ADF-001..008, H-NEW-SEC-001/002). Remaining tracked-deferred (MED/LOW): issue edit --field/--type/--label/--dry-run; bulk nested schema; issue changelog; worklog add; link/queue/board. Supersedes HOLDOUT-COVERAGE-GAPS-2026-06-22. | LOW | OPEN — HIGH gaps CLOSED; MED/LOW gaps tracked-deferred |
| HOLDOUT-STALE-2026-06-25 | holdout staleness | RESOLVED (2026-06-26): H-NEW-MP-001 (--story-points→--points) FIXED in D4; H-007 (ADR-0015 mechanism) FIXED in D4 (re-anchored to BC-3.2.013 proactive + BC-3.2.009 fallback). H-019 FIXED. H-028 FALSE POSITIVE (2026-06-25). No remaining stale holdouts. | LOW | RESOLVED — all stale items fixed by D4 |
| DOC-DRIFT-2026-06-25 | doc hygiene | D1 bundle: CLAUDE.md missing BC-7.2.012 Gotchas entry (ADF recursion guard, SEC-001, #553); CHANGELOG [Unreleased] missing #551 (JR_SERVICE_NAME gate) and #550 (actions/checkout v7). All of DRIFT-S3-001/002/003/004 RESOLVED — DRIFT-S3-003 (adr shadow) via D2 factory commit 89d94d8; DRIFT-S3-001/002/004 via PR #554 (squash-merged → develop @ aa2cdca). Branch docs/maint-2026-06-25-doc-fixes deleted; no open PRs. | MED | RESOLVED — PR #554 merged 2026-06-25 (develop @ aa2cdca). |
| PATTERN-HYGIENE-2026-06-25 | code hygiene | D3 bundle: PF-010/011 bare .unwrap() w/o invariant comment in src/cli/assets/schemas.rs; PF-016 src/cli/issue/create.rs 2,880 LOC undocumented shard candidate; PF-017 src/cli/issue/workflow.rs 1,341 LOC. Unwrap-comment hygiene PF-008/012/013/014. Manual PR needed (auto_pr:false). | LOW | RESOLVED — PR #555 merged 2026-06-25 (develop @ 6b395d3). PF-010..014/016/017 closed. |
| PF-008-ASSET-ID-RESULT-HARDENING | code hygiene | Result-propagation hardening of asset.id panic→JrError on CMDB contract violation at `src/api/assets/linked.rs` + `src/cli/issue/list.rs` (behavior change deliberately deferred out of cosmetic D3 PR; expect() now documents the invariant). PF-001/PF-002 (bare .unwrap() elsewhere) remain OPEN and unaddressed by D3. | LOW | OPEN — tracked deferral |
| SC-002-SEC-001-STORY-HOUSEKEEPING | spec coherence | D2 factory-only: S-MAINT-SEC-001 story still status:draft / bcs:[] post-merge #553; design table says ADF_MAX_DEPTH=64 vs shipped MAX_ADF_DEPTH=256. Close story (draft→done, bcs:[BC-7.2.012]). Reclassify F2-PIECEWISE drift item (enforced/codified — close or downgrade). | LOW | RESOLVED — 2026-06-25: BC-7.2.012 anchored in story (bcs:[BC-7.2.012]), status→done, ADF_MAX_DEPTH→MAX_ADF_DEPTH 256 corrected; F2-PIECEWISE reclassified RESOLVED-CODIFIED; adr shadow removed. |
| RA-001-JRACLOUD-27893-DOC | risk | JRACLOUD-27893 (user pagination fixed-window behavior) is load-bearing in src/api/jira/users.rs but not cited in CLAUDE.md Gotchas. Surfaced by spec-coherence sweep. Add CLAUDE.md entry or confirm it is adequately covered by existing prose. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | risk | ADR-0013 PKCE deferral assumption is ~50 days old as of 2026-06-25 — Atlassian 3LO PKCE support may have changed. Re-validate before any OAuth work in next feature cycle. | LOW | OPEN |
| F1-CI-TOPOLOGY-CHECK | phase-f1 process | F1 delta analysis lacks CI-checkout-topology verification step. The .factory/ CI-checkout flaw was a topology assumption error (checkout@v4 defaults to triggering branch, not factory-artifacts). Action: update phase-f1 skill template. | LOW | OPEN — skill template update (no new story) |
| F2-PIECEWISE-PROTOCOL | phase-f2 process | ENFORCED and codified in lessons.md 2026-06-20. Protocol: dispatch consistency-validator after EACH spec-author fix before next adversary pass. Sweep 2026-06-25 confirms still enforced. | LOW | RESOLVED-CODIFIED — 2026-06-25: protocol enforced; codified in cycles/cycle-001/lessons.md; no further action required. See blocking-issues-resolved.md. |
| PG-MERGE-AUTH-BYPASS | pr-manager delivery | pr-manager delivery sub-agent executed `gh pr merge` on PR #544 despite explicit orchestrator hold. Delivery sub-agents must not self-authorize merges; merge requires explicit per-merge orchestrator authorization. Also encompasses MAINT-PG-PR-MERGE-CHANNEL (same root cause: undefined merge-auth protocol; pr-manager default = NO-MERGE; orchestrator passes explicit `merge: authorized` signal). DEC-128. **Scope extended 2026-06-25 (PG-PR-MANAGER-OVERREACH reinforcement): delivery agents must also not spawn fix sub-agents, push commits autonomously, or enter unbounded poll loops.** | MEDIUM | TRACKED — S-PG-MERGE-AUTH-BYPASS (draft; scope extended 2026-06-25 to cover MAINT-PG-PR-MERGE-CHANNEL + PG-PR-MANAGER-OVERREACH) |
| MUTATION-CI-TIMEOUT | ci-budget | In-diff cargo-mutants CI job exceeds the 1-hour GitHub Actions budget on large diffs. PR #553 (SEC-001 adf.rs): evaluated 36 mutants, job cancelled at 1h0m. Job is NON-REQUIRED (not in ci-gate.needs). Kill rate was locally proven 100% via per-site flip verification. Options: raise per-mutant timeout, shard, tighten .cargo/mutants.toml scope, or accept non-required. Draft-story candidate. | MEDIUM | OPEN — justified deferral; draft story candidate |
| PG-PR-MANAGER-OVERREACH | process-gap | During PR #553, pr-manager delivery agent autonomously spawned implementer sub-agents, pushed commits (4b10e77) without orchestrator authorization, and entered expensive non-converging poll loops (~100k+ tokens/segment). Same root class as PG-MERGE-AUTH-BYPASS. Covered by scope extension of S-PG-MERGE-AUTH-BYPASS (story 91, draft). See LESSON-PR-MANAGER-SCOPE in lessons.md. | MEDIUM | TRACKED — covered by S-PG-MERGE-AUTH-BYPASS (story 91; scope extended 2026-06-25) |
| REFACTOR-ISSUE-CLI-SHARD | architecture | Architecture analysis 2026-06-25 (architecture/refactor-2026-06-25/) verdict DO-PARTIAL. **Seam A DONE (PR #556, 2026-06-26):** JSM-create extracted → src/cli/issue/jsm_create.rs (444 LOC); create.rs 2,880→2,447 LOC. **Seam B DONE (PR #558, 2026-06-26):** EDIT cluster extracted → src/cli/issue/edit.rs (2,067 LOC); create.rs 2,447→394 LOC (now well under ADR-0012 1,000-LOC threshold). Issue module: create.rs 394 + edit.rs 2,067 + jsm_create.rs 444. edit.rs (2,067 LOC) is the new largest cli/issue file — cohesive (edit-only), documented in CLAUDE.md Known Size Deviations, further-splittable but not planned. **Seam C DEFERRED indefinitely** — cross-crate pub-helper test API (I-17); cost disproportionate. Active seams of DO-PARTIAL plan COMPLETE. | LOW | RESOLVED-PARTIAL — Seams A+B complete (active plan done); Seam C accepted-deferral |
| RELEASE-CI-NETWORK-FLAKE | release-infra | release.yml Windows build (v0.6.0-dev.7, run 28248392006) hit a transient crates.io download failure (wasm-bindgen, curl [55] HTTP2) on first run; fail-fast cancelled the other 4 builds and skipped Create Release. Resolved by `gh run rerun` — all 6 jobs green on re-run. NOT a code or tag defect. Consider adding a cargo-fetch retry / network-resilience step to release.yml. Draft-story candidate. | LOW | OPEN |
| TEST-ONLY-GATE-ELIGIBILITY | process-gap | Codify a documented rule for whether/when test-only or characterization-pin PRs run the fresh-context adversarial gate vs a defined lighter tier. Until codified, default = run the gate. Raised by adversarial reviewer during F5/F3/F7 rigor backfill for PRs #560+#561 (DEC-136). Per S-7.02 cycle-closing checklist: tracked as a deferred process-improvement item — engine/process scope only, no product code change required. Rationale for deferral: F5 confirmed the lighter flow leaked no defect for #560+#561; process formalization belongs in a future engine update story (or as a factory-wide VSDD policy addition), not a jira-cli product story. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | test-coverage | Remaining cache-coverage audit proposals NOT yet implemented. P3: request-type model-b swallow unit tests (write-error resilience). **P4/P5: wiremock no-HTTP warm-hit tests for cmdb_fields/resolutions — UNBLOCKED 2026-06-27 (BC-6.2.018 anchor now exists).** P6–P8: additional warm-hit coverage. MED gaps: D5 write-error resilience at project_meta/workspace `let _ =` call sites; D2 warm-hit remaining families. Audit report: `.factory/research/cache-coverage-audit-2026-06-27.md`. | LOW | OPEN — P4/P5 UNBLOCKED (BC-6.2.018); P3/P6-P8 tracked deferral |
| E2E-EDGE-CASE-GAPS-2026-06-27 | E2E coverage | Gap inventory from 2-part static E2E edge-case audit (2026-06-27). **Offline CLI tier: DELIVERED (PR #563 @ 894cc9d, 2026-06-27)** — G-EDIT-FIELD-LABEL-GUARD, G-EDIT-FIELD-C1-BULK, #526 error-shape extension to `issue changelog`/`queue view`/`requesttype list` ALL CLOSED. **Wiremock tier (remaining open):** G-ADF-INV1-INLINE-HTML (BC-7.2.011 INV-1), G-H2 partial_match no-HTTP, G-MOVE-BULK-NONIDEMPOTENT (forced-400). **Holdout tier: G-ADF-FOOTNOTE UNBLOCKED 2026-06-27 (BC-7.2.013 anchor exists); G-ADF-BARE-URL UNBLOCKED 2026-06-27 (BC-7.2.014 anchor exists).** Infra edges ALREADY GREEN at wiremock tier — MUST NOT be re-created live. Reports: `.factory/research/e2e-edge-case-audit-2026-06-27-read.md`, `.factory/research/e2e-edge-case-audit-2026-06-27-write.md`. DEC-137/DEC-139. | MEDIUM | OPEN — offline-CLI tier CLOSED; wiremock tier (G-ADF-INV1-INLINE-HTML, G-H2, G-MOVE-BULK-NONIDEMPOTENT) + holdout tier remain open |
| MISSING-BC-SUBCLAUSE-PATTERN | spec/process | **RESOLVED 2026-06-27 (DEC-138):** BC-7.2.013 (footnote→ADF), BC-7.2.014 (bare-URL autolink), BC-7.3.010 (JSON render invariant), BC-6.2.018 (cache warm-hit no-HTTP), BC-X.10.001 EC-1 (partial_match no-network) all individually-bodied. The recurring broken-anchor / missing-BC-sub-clause pattern for the ADF/cache/partial_match cluster is resolved. P4/P5 + G-ADF-FOOTNOTE/G-ADF-BARE-URL holdout items now UNBLOCKED. Remaining ADF sub-clauses (#474/483/489/522) confirmed already-bodied — no action needed. DEC-137/DEC-138. | MEDIUM | RESOLVED — 2026-06-27. Archive to blocking-issues-resolved.md. |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | process-gap | The #526 forbidden-compact-JSON invariant (direct `serde_json::to_string_pretty` / compact `serde_json::json!` Display printing forbidden; all `--output json` paths must route through `output::render_json` / `output::print_output`) is review-only with no CI guard. A grep-based test parallel to the dead-citation guard (`tests/claude_md_citations.rs`) is a candidate to enforce this mechanically at CI time. LOW — the invariant is well-documented in CLAUDE.md and BC-7.3.010; a grep guard would make it CI-enforceable. | LOW | OPEN — draft-story candidate |
| ADF-RECURSION-TEST-NITS | code/doc hygiene | Two LOW nits from BC-sub-clause pass adversarial review: (1) pre-existing imprecise "wiremock 501" comment in `tests/adf_recursion_depth.rs:~81` (adversary F-1, non-blocking); (2) optional BC-7.2.014 Motivation-prose confidence-hedge harmonization (the "no autolink extension" claim is now externally validated — the hedge is slightly weaker than the current certainty warrants). Trivial; no behavior change; inert until someone edits those files. | LOW | OPEN — accepted cosmetic |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **DEAD-CITATION-CI CONVERGED + RELEASED (2026-06-20). F5/F3/F7 RIGOR BACKFILL (#560+#561) CONVERGED-WITH-NOTED-DEVIATION (2026-06-27): Spec N/A (existing-BC anchored); Tests CLEAN+pinned; Implementation no-change; Verification F5-CLEAN (1 pass) + mutation/CI green at merge; Documentation S-D4-TEST-HARDENING-BACKFILL-1 story filed. Deviation: F5 = 1 pass not 3 (justified: retroactive, test-only, LOW-novelty, zero-finding; see DEC-136). No active convergence tracker.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-06-27 |
| **Status** | **IDLE — E2E OFFLINE-CLI-GUARD TIER DELIVERED. PR #563 squash-merged → develop @ 894cc9d. 5 regression pins (BC-3.4.017/BC-7.3.010). Guards confirmed already-implemented. DEC-139. Stories 92→93. No active feature_mode_bundle. Zero story worktrees.** |
| **Position** | E2E offline-CLI-guard tier (2026-06-27): PR #563 squash-merged → develop @ 894cc9d. 5 regression pins: 2 in `tests/issue_edit_field.rs` (BC-3.4.017), 3 in `tests/json_error_shape.rs` (BC-7.3.010). Guards confirmed ALREADY IMPLEMENTED — test gap, not code bug. F5 pre-merge: 1 MED + 4 LOW, all fixed. Full VSDD honored (DEC-139). S-E2E-CLI-GUARD-COVERAGE-1 filed (story #93). E2E-EDGE-CASE-GAPS-2026-06-27 offline-CLI tier closed; wiremock + holdout tiers remain. BC-sub-clause pass (DEC-138): 4 BCs + 1 EC (603→605). MISSING-BC-SUBCLAUSE-PATTERN RESOLVED. D4 CLOSED (PR #560, holdouts 60→70). v0.6.0-dev.7 shipped (PR #559 @ 342987f). |
| **develop HEAD** | LOCAL develop = **894cc9d** == origin/develop (PR #563 squash-merged 2026-06-27). |
| **factory-artifacts HEAD** | see `git -C .factory log -1` |
| **Activation** | activation_head: 342987f; activation_version: v0.6.0-dev.7. v0.5.0 STABLE shipped 2026-06-12. |
| **Counters** | BC **605**. NFR **42**. ADR **16**. Stories **93**. Holdouts **70**. |
| **Active worktrees** | NONE under `.worktrees/`. Permanent infra only: main checkout (develop) + `.factory` (factory-artifacts) + `.reference/jira-cli` (detached). ZERO story worktrees. |
| **Open PRs (action needed)** | **NONE.** #563 merged @ 894cc9d. #562 merged @ 3d8f15b. All CLOSED. |
| **jira-e2e env** | JR_E2E_ISSUE_TYPE_ALT=Bug, JR_E2E_JSM_PROJECT=EJ, JR_E2E_ENABLED=true. |
| **Standing constraints** | Do NOT close #429 (DEC-029). All fixes through full VSDD (DEC-120/121/124/129/130/131/132/134/135/136/138/139). LESSON-F2-WORKTREE-FIRST. F2-PIECEWISE-PROTOCOL [ENFORCED 2026-06-20]. DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges, spawn fix agents, push, or enter unbounded loops. Fork signing UNBLOCKED but INERT (DEC-104). **DEC-133 (DEPENDABOT-ACTION-SOAK):** third-party GitHub Action bumps require ≥7-day soak from publication + SHA-pin integrity check + clean advisory check before merge. **DEC-136:** test-only PRs must not silently skip the adversarial gate — run gate or use a documented exemption tier. |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: v0.6.0-dev.7 RELEASED (PR #559, tag 342987f). PR #557 MERGED @ c70d8a7 (DEC-133). D4 CLOSED — PR #560 MERGED @ 9657b1e (holdouts 60→70, v1.2.0). CACHE-COVERAGE HIGH gaps SHIPPED — PR #561 MERGED @ 5ab4e0f (8 tests: BC-6.2.009 + BC-6.2.011; DEC-135). F5/F3/F7 RIGOR BACKFILL COMPLETE (DEC-136; story S-D4-TEST-HARDENING-BACKFILL-1; stories 91→92). E2E EDGE-CASE AUDIT COMPLETE (record-only, 2026-06-27; DEC-137; E2E-EDGE-CASE-GAPS-2026-06-27 + MISSING-BC-SUBCLAUSE-PATTERN MEDIUM). BC-SUBCLAUSE PASS COMPLETE (603→605; DEC-138). E2E OFFLINE-CLI-GUARD TIER DELIVERED — PR #563 MERGED @ 894cc9d (5 pins; DEC-139; stories 92→93). CACHE-COVERAGE-GAPS deferral open. D5 (cargo update) tracked-deferred. No active bundle. No story worktrees. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md` (this file).

**Step 2 — Verify position:**
- develop @ **894cc9d** (LOCAL == origin/develop, PR #563 squash-merged 2026-06-27). Tag v0.6.0-dev.7 pushed on 342987f (activation_head). activation_head/version: 342987f / v0.6.0-dev.7.
- factory-artifacts: see `git -C .factory log -1` (pushed; no uncommitted changes).
- Permanent infra only: main checkout @ develop, `.factory` @ factory-artifacts, `.reference/jira-cli` detached. ZERO story worktrees under `.worktrees/`.
- PRs #547..#563 ALL MERGED. **Open PRs: NONE.**
- Counters: BC **605**, NFR **42**, ADR **16**, Stories **93**. Holdouts **70**.

**Step 3 — IDLE. E2E OFFLINE-CLI-GUARD TIER DELIVERED (PR #563). Present open items to human, await direction.**
- **E2E OFFLINE-CLI-GUARD TIER (2026-06-27):** PR #563 squash-merged → develop @ 894cc9d. 5 regression pins (BC-3.4.017: `--field`+`--label` guard + C-1 bulk guard; BC-7.3.010: error-envelope shape for `issue changelog`/`queue view`/`requesttype list`). Guards confirmed ALREADY IMPLEMENTED (test gap, not code bug). F5: 1 MED + 4 LOW, all fixed. DEC-139. S-E2E-CLI-GUARD-COVERAGE-1 filed (story #93). E2E-EDGE-CASE-GAPS-2026-06-27 offline-CLI tier CLOSED.
- **BC-SUBCLAUSE PASS (2026-06-27):** 4 BCs + 1 EC (603→605): BC-7.2.013/014/BC-7.3.010/BC-6.2.018/BC-X.10.001 EC-1. MISSING-BC-SUBCLAUSE-PATTERN RESOLVED. DEC-138. Unblocked: P4/P5 cache wiremock + G-ADF-FOOTNOTE/G-ADF-BARE-URL holdout items.
- **E2E REMAINING TIERS (OPEN):** Wiremock tier: G-ADF-INV1-INLINE-HTML, G-H2 partial_match no-HTTP, G-MOVE-BULK-NONIDEMPOTENT. Holdout tier: G-ADF-FOOTNOTE (UNBLOCKED by BC-7.2.013), G-ADF-BARE-URL (UNBLOCKED by BC-7.2.014).
- **D4 CLOSED (2026-06-26):** holdout-scenarios.md 60→70; adversary CRITICAL boundary off-by-one caught (DEC-134); PR #560 merged @ 9657b1e.
- **v0.6.0-dev.7 (SHIPPED):** PR #559 merged @ 342987f; tag pushed; release.yml SUCCESS; 10 assets/5 targets.
- **D5 (optional):** `cargo update` (rustls 0.23.41 + 64 semver-compatible bumps).
- **S-PG-MERGE-AUTH-BYPASS** (story 91, MEDIUM, draft) — merge-auth + spawn/push/loop protocol.
- **MUTATION-CI-TIMEOUT** — draft story candidate.
- **RELEASE-CI-NETWORK-FLAKE** — LOW, open.
- DO NOT close **#429** (DEC-029, human-deferred).

**Step 4 — STANDING CONSTRAINTS:**
- All fixes through full VSDD Feature Mode (DEC-120/121/124/129/130/131/132/136/138/139). Test-only PRs must not silently skip the adversarial gate (DEC-136/TEST-ONLY-GATE-ELIGIBILITY).
- F2-PIECEWISE-PROTOCOL [ENFORCED 2026-06-20]: consistency-validator after EACH spec-author fix in F2.
- LESSON-F2-WORKTREE-FIRST: ALL story-scoped edits (incl. docs/) in the story worktree.
- DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges, spawn fix agents, push, or enter unbounded poll loops. Explicit orchestrator per-merge authorization required.
- DEC-133 (DEPENDABOT-ACTION-SOAK): third-party GitHub Action bumps require ≥7-day soak + SHA-pin integrity check + clean advisories before merge.
- CHANGELOG-per-PR hygiene: keep `[Unreleased]` populated as PRs merge.
- Carry-forward LOW drift items in Drift Items section (non-blocking).

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #563 | test(cli): pin --field/--label & C-1 edit guards and --output json error-shape coverage | **CLOSED — squash-merged → develop @ 894cc9d (2026-06-27)** | LOW | E2E offline-CLI-guard tier. 5 regression pins (2 BC-3.4.017 in tests/issue_edit_field.rs; 3 BC-7.3.010 in tests/json_error_shape.rs). Guards confirmed already-implemented. F5: 1 MED + 4 LOW, all fixed pre-merge. 15/15 CI green. DEC-139. |
| #562 | docs(test): correct stale RED-gate docstring in adf_recursion_depth.rs | **CLOSED — squash-merged → develop @ 3d8f15b (2026-06-27)** | LOW | BC-sub-clause pass docstring residual. Comment-only change. Adversary gate CLEAN. 15/15 CI green. |
| #561 | test(cache): pin per-profile cache isolation and fields.json self-heal | **CLOSED — squash-merged → develop @ 5ab4e0f (2026-06-27)** | LOW | Cache-coverage P1/P2. 8 unit tests: 6 per-profile isolation (BC-6.2.009) + 2 fields.json self-heal (BC-6.2.011). Code review: 1 MED + 2 LOW (all fixed pre-merge). 15/15 CI green. Admin squash-merge (DEC-128). |
| #560 | test(adf): pin plain-text block-HTML and discrete footnote node shapes | **CLOSED — squash-merged → develop @ 9657b1e (2026-06-26)** | LOW | D4 LOW observation pins. 2 regression-pin tests: test_block_html_plain_text_interior_lines_preserved_in_one_paragraph + test_footnote_reference_and_definition_are_discrete_unmarked_text_nodes. 15/15 CI green. Clean code review (CR-004 docstring fixed pre-merge). |
| #559 | chore(release): v0.6.0-dev.7 | **CLOSED — squash-merged → develop @ 342987f (2026-06-26)** | LOW | Version bump + CHANGELOG roll. release.yml run 28248392006 SUCCESS after 1 transient-network rerun (Windows curl [55] HTTP2 crates.io flake). 10 assets/5 targets. GitHub prerelease published. |
| #557 | dependabot: bump softprops/action-gh-release 3.0.0→3.0.1 | **CLOSED — squash-merged → develop @ c70d8a7 (2026-06-26T17:51:42Z)** | LOW | Supply-chain soak PASS: SHA-pin integrity MATCH (718ea10b = v3.0.1), 7-day floor MET, zero CVEs/GHSA. Admin squash-merge (human/orchestrator-authorized, DEC-128 protocol). DEC-133 DEPENDABOT-ACTION-SOAK standing policy. |
| #558 | refactor(cli): extract EDIT cluster into src/cli/issue/edit.rs — Seam B | **CLOSED — squash-merged → develop @ 2e3c3c2 (2026-06-26)** | LOW | Seam B refactor. Behavior-preserving (all invariants byte-for-byte; test parity 1957/93; mutation passed 16m47s). Both reviews clean; admin squash-merge (human-authorized). CI 15/15 green. |
| #556 | refactor(cli): extract JSM-create into src/cli/issue/jsm_create.rs — Seam A | **CLOSED — squash-merged → develop @ d04a7ec (2026-06-26)** | LOW | Seam A refactor. Behavior-preserving pure move (I-1 intact, test parity 1957/93). Both reviews clean; admin squash-merge (human-authorized). CI 15/15 green. |
| #555 | chore: pattern hygiene — unwrap invariant docs + size-deviation records (PF-010..017) | **CLOSED — squash-merged → develop @ 6b395d3 (2026-06-25)** | LOW | D3 pattern-hygiene bundle. Cosmetic/no-behavior-change. Fresh-eyes pr-reviewer caught + fixed BLOCKING PF-017 factual error pre-merge (workflow.rs does not cover handle_remote_link; DEC-131 pattern). CI 15/15; admin squash-merge (human-authorized). |
| #554 | docs: maintenance sweep 2026-06-25 doc fixes (CLAUDE.md BC-7.2.012 Gotchas + CHANGELOG #550/#551) | **CLOSED — squash-merged → develop @ aa2cdca (2026-06-25)** | LOW | D1 doc-fix bundle. Clean review: code-reviewer caught HIGH off-by-one factual error pre-PR; pr-reviewer APPROVE; CI 15/15 green; admin squash-merge (human-authorized). All DRIFT-S3-001/002/003/004 resolved. |
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
| Refactor analysis 2026-06-25 (structural + proposal) | `architecture/refactor-2026-06-25/` |
| E2E edge-case coverage audit 2026-06-27 — read/infra surface | `research/e2e-edge-case-audit-2026-06-27-read.md` |
| E2E edge-case coverage audit 2026-06-27 — write/state surface | `research/e2e-edge-case-audit-2026-06-27-write.md` |
| BC-sub-clause pass authoring plan 2026-06-27 | `research/bc-subclause-authoring-plan-2026-06-27.md` |
| BC-sub-clause pass external ADF/markdown research validation 2026-06-27 | `research/adf-bc-external-validation-2026-06-27.md` |
