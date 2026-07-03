---
document_type: pipeline-state
version: "2.0"
status: in_progress
pipeline: IN_PROGRESS
timestamp: 2026-07-02T12:00:00Z
phase: 3
project: jira-cli
mode: brownfield
current_step: "CITATION-GUARDS F3 strict convergence loop: pass 36 in flight vs story v1.30.2; 13 passes/13 rounds since DEC-151; streak 0/3."
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: CITATION-GUARDS
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
| **Last Updated** | 2026-07-03: CITATION-GUARDS F3 strict convergence loop in progress — Story A v1.30.2; 35 passes / 29 rounds since v1.17 baseline; streak 0/3; pass 36 in flight. Prior: MUTANTS-EXAMINE-GLOBS SHIPPED (DEC-150; PR #570; develop @ c4b3aa9; Stories 99→100). |
| **Current Phase** | Phase 3 — ACTIVE CYCLE: CITATION-GUARDS F3 strict convergence loop. Story #101 v1.30.2 CONSISTENT; CRIT/HIGH closed; streak 0/3; pass 36 in flight. BC **608**. NFR 42. ADR 16. Stories **101** (#101 draft). Holdouts **82**. |
| **Next Phase** | CITATION-GUARDS F3 gate resolution → F4 delivery (develop unchanged @ c4b3aa9). After cycle: MUTANTS-SHARDING-PATH-B, fork signing DEC-104, BC-CITATION-CI-GUARD candidates. |
| **Activation HEAD** | 342987f (v0.6.0-dev.7 tag); develop @ c4b3aa9 (PR #570 squash-merged 2026-07-02 by human) |

## Phase Progress

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
<!-- archived to cycles/cycle-001/burst-log.md: Phase 0–2 + all Feature cycles 2026-05-04..2026-06-28 (BC 583→608; Includes CMDB/OBJ-TYPE WARM-HIT PR #566 @ 822fa18 DEC-143; E2E-EDGE-CASE-GAPS PRs #563/#564 + holdouts 70→71; BC-sub-clause pass 603→605; CACHE WARM-HIT PR #565; MUTATION-CI-TIMEOUT PR #567 @ 3b122a8 DEC-144 Stories 96→97) -->
| **HOLDOUT-COVERAGE-GAPS — CYCLE CLOSED — SPEC-ONLY 2026-06-30** | **COMPLETE** | **2026-06-30** | **8 new Group 13 black-box holdouts (H-NEW-EDIT-FIELD-001/002, H-NEW-EDIT-TYPE-001/002, H-NEW-CHANGELOG-001, H-NEW-WORKLOG-ADD-001, H-NEW-LINK-001, H-NEW-QUEUE-VIEW-001); holdouts 71→79 (v1.4.0). BC-3.4.015 EC-3.4.015-3 edit-screen hint drift fixed. F1→research→F2→9 adversary passes (3 diverse lenses) → 4 consecutive clean passes. DEC-146.** | develop UNCHANGED @ 3b122a8. Spec-only; no PR. Holdouts 71→79. |
| **BC-SUB-CLAUSE + HOLDOUT CYCLE — CLOSED — SPEC-ONLY 2026-06-30** | **COMPLETE** | **2026-06-30** | **BC-3.4.020 (label single-vs-bulk fork, 8 ECs), BC-3.4.021 (dry-run plannedChanges, 14 ECs), BC-5.1.005 (board view dispatch+truncation, 11 ECs); holdouts 79→82 (H-NEW-LABEL-FORK-001/DRY-RUN-001/BOARD-VIEW-001, v1.5.0); BC-3.4.006 stale wire-shape fixed; 21 create.rs→edit.rs citation fixes; individually-bodied 376→378. ~16 adversary passes → 3 clean each. DEC-147.** | develop UNCHANGED @ 3b122a8. Spec-only; no PR. BC 605→608. Holdouts 79→82. |
| **CITATION-DEBT-FILEWIDE — CYCLE CLOSED — SPEC-ONLY 2026-06-30** | **COMPLETE** | **2026-06-30** | **3-file citation repoint: bc-3-issue-write.md (12 relocations: 9× create.rs→jsm_create.rs [BC-3.8.002/003/009/015/016/017 + Canonical Guard Ordering], 2× create.rs→edit.rs, 1× helpers.rs→field_resolve.rs; +BC-3.4.016 sibling-propagation add; +2 descriptor rewrites; +2 changelog symbol fixes; +1 prose fix), bc-2-issue-read.md (1 relocation), BC-INDEX.md (11 relocations + 1 symbol correction + 1 add). 7 adversary passes (diverse lenses) → 3 consecutive CLEAN. check scripts exit 0. BC 608, Stories 97, Holdouts 82 — all UNCHANGED. DEC-148.** | develop UNCHANGED @ 3b122a8. Spec-only; no PR. Product-file ring split to CITATION-DEBT-PRODUCT-FILES follow-on. |
| **CITATION-DEBT-PRODUCT-FILES — DELIVERED PRs #569+#568 — COMPLETE 2026-07-02** | **COMPLETE** | **2026-07-02** | **PR #569 (anyhow RUSTSEC-2026-0190 security bump; Cargo.lock+CHANGELOG only; unblocked repo-wide ci-gate) + PR #568 (7 doc/comment citation corrections across 4 product files: ADR-0014 HIGH create.rs→jsm_create.rs relabeled, jsm-e2e-coverage.md MED, search-issue-keys.md MED, issues.rs rustdoc LOW). Multiple adversary rounds → 3 consecutive clean passes on final diff. Stories 97→99 (S-ANYHOW-RUSTSEC-2026-0190-1 + S-CITATION-DEBT-PRODUCT-FILES-1, retroactive). DEC-149.** | develop 3b122a8 → 39caf39 (#568 rebased onto #569). Human-merged (admin bypass). BC 608, NFR 42, ADR 16, Holdouts 82 — UNCHANGED. |
| **MUTANTS-EXAMINE-GLOBS — PR #570 SHIPPED — CYCLE CLOSED 2026-07-02** | **COMPLETE** | **2026-07-02** | **F1 delta analysis (option (a) restore) → F3 story #100 (S-MUTANTS-EXAMINE-GLOBS-1 v1.2) → F4 worktree ci/mutants-examine-globs-seam-b (3 commits: 5486c34, 1da0571, 475a1aa) → F5 CONVERGED (2 fix rounds + 3 clean diverse-lens passes; rounds 1+2: ci.yml:195 comment MED + policy-doc handle_create→handle_edit MED + story file-set drift MED, all fixed; round 3 diverse-lens CLEAN) → consistency-validator CONSISTENT (story v1.2) → PR #570 squash-merged (human, 2026-07-02; DEC-128 honored); mutants job PASS 35s via 0-mutant path (second 0-mutant calibration confirmation). DEC-150.** | develop 39caf39 → c4b3aa9. Policy-doc + CI-config only; no src change. Stories 99→100. Scope ~594→~702 mutants (+18%). |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
<!-- archived to cycles/cycle-001/burst-log.md: CMDB/OBJ-TYPE WARM-HIT COVERAGE DELIVERED (PR #566, 822fa18, DEC-143, Stories 95→96); MUTATION-CI-TIMEOUT CYCLE DELIVERED (PR #567, 3b122a8, DEC-144, Stories 96→97); HOLDOUT-COVERAGE-GAPS CYCLE CLOSED (DEC-146, holdouts 71→79, Stories 97, develop @ 3b122a8); BC-SUB-CLAUSE + HOLDOUT CYCLE CLOSED (DEC-147, BC 605→608, holdouts 79→82, develop @ 3b122a8) -->
| **CITATION-DEBT-FILEWIDE CYCLE CLOSED** — 3-file citation repoint: bc-3-issue-write.md (12 relocations: 9× create.rs→jsm_create.rs [BC-3.8.002/003/009/015/016/017 + Canonical Guard Ordering], 2× create.rs→edit.rs [BC-3.4.010 historical], 1× helpers.rs→field_resolve.rs; +BC-3.4.016 sibling-propagation field_resolve.rs Source+Trace add; +2 descriptor rewrites [BC-3.8.016/017 Trace "very top"→"after project-key resolution step 0"]; +2 changelog symbol fixes [create.rs:341→edit.rs::has_any_field_change]; +1 prose fix [BC-3.8.002 handle_create→handle_jsm_create calls require_service_desk]); bc-2-issue-read.md (1: BC-2.6.050 create.rs::handle_edit→edit.rs::handle_edit); BC-INDEX.md (11 relocations + 1 symbol correction [BC-3.4.019 handle_edit_bulk_fields→handle_edit] + 1 field_resolve.rs add). 7 adversary passes (diverse lenses) → 3 consecutive CLEAN. consistency-validator CONSISTENT; both check scripts exit 0. DEC-148. | state-manager | COMPLETE | develop @ 3b122a8 (UNCHANGED). BC 608. Stories 97. Holdouts 82. |
| **CITATION-DEBT-PRODUCT-FILES DELIVERED** — PR #569 (`chore(deps): bump anyhow 1.0.102→1.0.103`) squash-merged → develop @ **e79943b** (unblocked repo; Cargo.lock+CHANGELOG; all 15 CI green). PR #568 (`docs: fix ADR-0012 Seam A/B relocation citations`) squash-merged (rebase onto #569) → develop @ **39caf39** (7 doc/comment citation corrections: docs/adr/0014-jsm-request-type-dispatch.md HIGH, jsm-e2e-coverage.md MED, 2026-05-13-search-issue-keys.md MED, src/api/jira/issues.rs rustdoc LOW; no behavior change; adversary converged 3 clean passes). S-ANYHOW-RUSTSEC-2026-0190-1 + S-CITATION-DEBT-PRODUCT-FILES-1 filed (retroactive). Stories 97→99. DEC-149. 3 lessons codified (SWEEP-WHOLE-TOUCHED-FILE; NEWLY-PUBLISHED-ADVISORY-BLOCKS-UNRELATED-PRS; PERIMETER-SCAN reinforcement 2). | state-manager | COMPLETE | develop @ 39caf39. BC 608. Stories 99. Holdouts 82. |
| **MUTANTS-EXAMINE-GLOBS CYCLE CLOSED** — F1 delta analysis (option (a) restore) → F3 story S-MUTANTS-EXAMINE-GLOBS-1 (story #100, v1.2) → F4 delivery worktree `ci/mutants-examine-globs-seam-b` (3 commits: 5486c34, 1da0571, 475a1aa) → F5 adversarial gate CONVERGED (round 1: ci.yml:195 stale scope comment MED; round 2: policy-doc false handle_create→handle_edit call-edge MED + story file-set drift MED; round 3: 3/3 PASS diverse lenses) → consistency-validator CONSISTENT (story v1.2) → PR #570 squash-merged (human 2026-07-02; DEC-128 honored); mutants job PASS 35s 0-mutant path (second 0-mutant calibration confirmation). Cycle-close: cicd-setup.md AC-003 corrections applied; 2 lessons codified (IMPLEMENTER-PARAPHRASE-BEYOND-SPEC + FILES-MODIFIED-BACK-WRITE); 4 process-gaps dispositioned. DEC-150. | state-manager | COMPLETE | develop @ c4b3aa9. BC 608. Stories 100. Holdouts 82. |
| **SESSION WRAP (human-requested pause)** — MUTANTS-EXAMINE-GLOBS cycle CLOSED same-day (DEC-150, PR #570 → develop @ c4b3aa9); pipeline paused IDLE; no in-flight work abandoned | state-manager | COMPLETE | factory-artifacts @ 363334b + this commit. |
| **CITATION-GUARDS CYCLE — F3 STRICT CONVERGENCE LOOP IN PROGRESS** | orchestrator / story-writer / adversary | IN_PROGRESS | F1 approved; Story A S-MUTANTS-SCOPE-GUARDS-1 #101 hardened v1.0→v1.30.2: 35 fresh-context passes + 29 fix rounds (13 passes/13 rounds since DEC-151 resume); streak 0/3 (strict criterion DEC-151; all verification-adequacy lens). Story grew ~1850→~2950 lines (12 fixtures A–L, 9 Rust tests, 4 self-assertions, ~13 accepted residuals). Finding trajectory p23–35: 1H+4M+1L→1H+3M+3L→2L→1M+3L→1M+1L→3M+4L→2M+1L→1H→3M+1L→1M+4L→2M+1L→2M+2L→2M. Pass 36 in flight vs v1.30.2. Full detail: convergence-trajectory.md §CITATION-GUARDS F3. Story B S-BC-CITATION-GUARD not yet authored. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-124 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 + S-FORK-OPS-BACKFILL decisions. Pattern: full VSDD catches CRIT/HIGH on "trivial" infra changes (DEC-120/121/124). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-19 | archived |
| DEC-125..DEC-145 | Phase 3 Feature Mode cycles: DEAD-CITATION-CI (DEC-125..130), maintenance sweep 2026-06-22 (DEC-131), SEC-001/Bundle-D (DEC-132), DEPENDABOT-ACTION-SOAK policy (DEC-133), D4 holdout refresh (DEC-134), cache-coverage audit (DEC-135), PRs #560/#561 retroactive rigor (DEC-136), E2E edge-case audit (DEC-137), BC-sub-clause pass (DEC-138), E2E offline-CLI tier (DEC-139), E2E wiremock tier (DEC-140), E2E G-ADF-FOOTNOTE holdout tier (DEC-141), cache P3+D2 PR #565 (DEC-142), cmdb/objtype warm-hit PR #566 (DEC-143), MUTATION-CI-TIMEOUT PR #567 (DEC-144), S-PG-MERGE-AUTH-BYPASS re-assessment (DEC-145). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 3 / 2026-06-20..2026-06-28 | archived |
| DEC-151 | **CITATION-GUARDS F3 convergence criterion — human chose STRICT (Option C): 3 consecutive clean passes including verification-adequacy lens. Streak reset to 0/3 from v1.17 CONSISTENT baseline; pass 23 dispatched (verification-adequacy lens first).** | Human prefers full-lens rigor over documented deviation despite the lens's recursive meta-finding behavior (ADVERSARY-META-LENS-REGRESS remains OPEN as engine-level item). Options A (converge-as-is, 4-of-5 lenses) and B (one non-meta pass) declined. | Feature Mode / CITATION-GUARDS F3 | 2026-07-02 |
| DEC-150 | **MUTANTS-EXAMINE-GLOBS cycle CONVERGED & SHIPPED — PR #570 squash-merged (human, 2026-07-02; DEC-128 honored); develop 39caf39 → c4b3aa9; Stories 99→100.** examine_globs restored: `edit.rs` (~99 mutants) + `jsm_create.rs` (~9 mutants) added after ADR-0012 Seam A/B drop. Option (a) chosen (F1 data-grounded). F5 fresh-context gate caught 3 MED defects on a 'config+doc-only' change: (1) stale ci.yml:195 scope comment; (2) invented handle_create→handle_edit call-edge in policy doc prose — implementer-paraphrase-beyond-spec class (#361 lineage); (3) story file-set drift. All 3 fixed; round 3 diverse-lens CLEAN. Mutants job PASS 35s via 0-mutant path (second 0-mutant calibration confirmation; code-mutant path STILL unexercised — now MORE likely to fire since edit.rs/jsm_create.rs are in scope). AC-003 cicd-setup.md corrections applied post-merge via factory-artifacts commit per documented deferral. CICD-SETUP-TIMEOUT-MINUTES-STALE (timeout 60→90) fixed in same commit. 2 lessons codified (IMPLEMENTER-PARAPHRASE-BEYOND-SPEC, FILES-MODIFIED-BACK-WRITE). 4 process-gaps dispositioned (MUTANTS-POLICY-CITATION-GUARD, MUTANTS-GLOB-EXISTENCE-GUARD, F1-SWEEP-INCLUDES-CI-YML-COMMENTS, CICD-SETUP-CLASSIFICATION). DEC-120/121/144/149 lineage reinforced. | Feature Mode / MUTANTS-EXAMINE-GLOBS | 2026-07-02 |
| DEC-149 | **CITATION-DEBT-PRODUCT-FILES cycle CONVERGED & SHIPPED — PRs #569 + #568 merged; develop 3b122a8 → 39caf39; Stories 97→99.** PR #569 (anyhow RUSTSEC-2026-0190, Cargo.lock+CHANGELOG, unblocked repo-wide ci-gate deny failure). PR #568 (7 doc/comment citation corrections across 4 product files: HIGH in ADR-0014 re "canonical implementation", MED in jsm-e2e-coverage + search-issue-keys, LOW in issues.rs rustdoc). Adversarially converged on final diff (multiple rounds → 3 consecutive clean passes; fresh-context adversary found same-class stale citations on DIFFERENT lines of already-touched files — issues.rs:704, jsm-e2e-coverage.md:178 — until per-file exhaustive sweep was run). Key lessons: SWEEP-WHOLE-TOUCHED-FILE-NOT-JUST-TARGET-LINE (fix the whole file, not just enumerated lines); NEWLY-PUBLISHED-ADVISORY-BLOCKS-UNRELATED-PRS (freshly-published RUSTSEC advisory → fix-first in own PR, then rebase blocked PR). MUTANTS-FIRST-SCOPED-PR-CALIBRATION watch-item: first scoped-file PR (#568, touched examine_globs file issues.rs) exercised mutation gate — passed at ~34s via 0-mutant path (rustdoc-only diff, no code mutants); calibration CONFIRMED-GOOD for 0-mutant path. New drift items: MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B (MEDIUM — examine_globs lists only create.rs; edit.rs/jsm_create.rs bulk-edit/JSM surfaces likely dropped out of mutation coverage at Seam A/B split); DOC-LINK-SWEEP-CANDIDATE-1 + DOC-LINE-DRIFT-CANDIDATE-1 (LOW). | Spec+code / CITATION-DEBT-PRODUCT-FILES cycle | Phase 3 | 2026-07-02 |
| DEC-148 | **CITATION-DEBT-FILEWIDE cycle CONVERGED — spec-only; develop UNCHANGED @ 3b122a8.** Corrected stale BC file/symbol citations left by ADR-0012 Seam A/B module extraction (create.rs split → edit.rs/jsm_create.rs; resolve_edit_fields → field_resolve.rs). 3 files corrected: bc-3-issue-write.md (12 relocations + BC-3.4.016 sibling-propagation add + 2 descriptor rewrites + 2 changelog symbol fixes + 1 prose fix), bc-2-issue-read.md (1 relocation), BC-INDEX.md (11 relocations + BC-3.4.019 symbol correction + BC-3.4.016 add). 7 adversary passes (diverse lenses) → 3 consecutive CLEAN passes. consistency-validator CONSISTENT after each fix (F2-PIECEWISE honored). check-bc-cumulative-counts.sh + check-spec-counts.sh both exit 0. BC 608, NFR 42, ADR 16, Stories 97, Holdouts 82 — all UNCHANGED. Product-file ring (docs/adr/0014, jsm-e2e-coverage, search-issue-keys, issues.rs rustdoc, archived docs) split to CITATION-DEBT-PRODUCT-FILES-2026-06-30 (MEDIUM, OPEN). PERIMETER-SCAN-MUST-INCLUDE-INDEX-AND-TRACEABILITY lesson codified. | Spec / CITATION-DEBT-FILEWIDE cycle | Phase 3 | 2026-06-30 |
| DEC-147 | **BC-SUB-CLAUSE + HOLDOUT cycle CONVERGED — authored BC-3.4.020 (label single-vs-bulk fork), BC-3.4.021 (dry-run plannedChanges), BC-5.1.005 (board view dispatch+truncation) + 3 holdouts (H-NEW-LABEL-FORK-001/DRY-RUN-001/BOARD-VIEW-001), unblocking the 3 HOLDOUT-COVERAGE-GAPS BLOCKED targets. Spec-only; develop unchanged. BC 605→608, holdouts 79→82. Gate-surfaced + fixed substantial PRE-EXISTING debt: BC-3.4.006 stale wire shape (issue #446 drift), 21 create.rs→edit.rs citation fixes (Seam-B handle_edit cluster), individually-bodied count 376→378, Coverage Statistics table sections 6/7. ~16 adversary passes (diverse lenses) across both sub-cycles → 3 clean each. Remaining file-wide citation debt (JSM cluster, resolve_edit_fields→field_resolve) split to dedicated cycle.** | Spec / BC-SUB-CLAUSE + HOLDOUT cycle | Phase 3 | 2026-06-30 |
| DEC-146 | **HOLDOUT-COVERAGE-GAPS cycle CONVERGED — 8 new black-box holdouts (71→79, v1.4.0) for issue edit --field/--type, changelog, worklog add, link/unlink, queue view; spec-only, develop unchanged. Process: F1 anchor-adequacy → research ground-truth validation → F2 → 9 adversarial passes (3 diverse lenses) caught 10 blocking defects (false-reject fixtures, wrong serde keys incl. issueTypes-vs-values, mislabeled anchors, relayed-citation error) → 4 consecutive clean passes. BC-3.4.015 EC-3.4.015-3 content drift fixed in-pass (Edit-screen hint string matched to shipped code in `src/cli/issue/field_resolve.rs`). Research re-validated final scenarios (PASS, FAQ citation verbatim-confirmed). consistency-validator CONSISTENT; check scripts exit 0. 3 targets remain BLOCKED on BC sub-clause prerequisites (`issue edit --label` single-vs-bulk fork, `board view`, `issue edit --dry-run`) — tracked as HOLDOUT-BLOCKED-TARGETS-BC-PASS. LOW residuals: H-NEW-EDIT-FIELD-002 stderr-criterion-looser-than-siblings (accepted; zero-HTTP assertion discriminates); BC-X.5.008 Source-field stale line-cite (LOW BC-metadata fix candidate). Lessons ORCHESTRATOR-RELAYED-FIX-CAUTION REINFORCED + REPO-EMPIRICAL-GROUND-TRUTH-BEATS-DOC-INFERENCE codified.** | HOLDOUT-COVERAGE-GAPS cycle | Phase 3 | 2026-06-30 |

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
| HOLDOUT-RESIDUAL-EDIT-FIELD-002-STDERR | accepted-residual | H-NEW-EDIT-FIELD-002 stderr criterion is looser than sibling scenarios (accepted per DEC-146): the zero-HTTP assertion (no `GET /editmeta` on cache-warm path) is the primary discriminator; the exact stderr string for the cache-warm branch is implicitly covered by BC-3.4.017 which does not sub-specify it. Accepted as-is. | LOW | ACCEPTED |
| MUTANTS-POLICY-CITATION-GUARD | process-gap | `docs/specs/cargo-mutants-policy.md §Scope` function-location table cites file paths and function names with no CI guard verifying each cited function is defined in the cited file. A future module extraction could leave stale citations silently. Proposed: `scripts/check-cargo-mutants-policy-citations.sh`. Draft-story candidate. DEC-150. | LOW | OPEN — draft-story candidate |
| MUTANTS-GLOB-EXISTENCE-GUARD | process-gap | `examine_globs` entries in `.cargo/mutants.toml` are not validated against the actual repo filesystem at CI time. A dead glob (from a future refactor) would shrink mutation scope without any CI signal. Proposed: per-entry glob resolution check in CI. Draft-story candidate. DEC-150. | LOW | OPEN — draft-story candidate |
| F1-SWEEP-INCLUDES-CI-YML-COMMENTS | process-gap | F1 delta analysis missed the stale scope comment at `ci.yml:195`; fresh-context F5 adversary caught it (round 1 MED). F1 perimeter scan did not include CI workflow files containing scope-summary comments referencing the modified config keys. Fix: update phase-f1 skill template (engine-side). Justified deferral — engine/skill-template scope. DEC-150. | LOW | OPEN — justified deferral (engine skill-template update) |
| CICD-SETUP-CLASSIFICATION | process-gap | `.factory/cicd-setup.md` governance classification is ambiguous: policy doc calls it "historical/pending refresh" while it is actively cited as a CI topology reference. Adjudication needed: (a) live-governance → full stale-citation sweep schedule; (b) historical-snapshot with live §1.1a extension → document dual-nature explicitly. Human input required. DEC-150. | LOW | OPEN — justified deferral (human governance decision needed) |
| DOC-LINK-SWEEP-CANDIDATE-1 | doc hygiene | `docs/specs/jsm-e2e-coverage.md:903` References section cites `docs/adr/0014-jsm-request-creation.md` but the actual file is `docs/adr/0014-jsm-request-type-dispatch.md` (broken doc→doc link / 404 if followed). LOW pre-existing doc-hygiene item; candidate for a future doc-link sweep. NOT this cycle. DEC-149. | LOW | OPEN — doc-link sweep candidate |
| DOC-LINE-DRIFT-CANDIDATE-1 | doc hygiene | `docs/specs/2026-05-13-search-issue-keys.md:7` cites `src/api/jira/issues.rs:12-29` for `BASE_ISSUE_FIELDS` but actual span is approximately lines 13–30 (off-by-one line drift). LOW pre-existing doc-hygiene item; candidate for a future doc-citation sweep. NOT this cycle. DEC-149. | LOW | OPEN — line-cite drift candidate |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | process-gap | F1 citation-debt perimeter scan grepped bc-1..bc-7 body files but omitted BC-INDEX.md and traceability/summary tables — caught only by fresh-context adversary (pass 1). Codify: a citation-debt perimeter scan MUST include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts, ideally a single repo-wide grep for the relocated symbols. Related to BC-CITATION-CI-GUARD (mechanical enforcement). | LOW | OPEN — process-gap codification pending |
| BC-CITATION-CI-GUARD | process-gap | No CI guard validates file::symbol citations in `.factory/specs/prd/*.md` BC bodies (tests/claude_md_citations.rs covers only CLAUDE.md). Relates to #492-PG-TRACE-TESTS + CITATION-FORM-DISCIPLINE. Root cause of recurring Seam-extraction citation drift (BC-CITATION-DRIFT-AFTER-SEAM-EXTRACTION lesson). Draft story candidate. | LOW | OPEN — draft-story candidate |
| BC-X5008-STALE-LINE-CITE | BC metadata | BC-X.5.008 Source field cites `src/duration.rs:38-42` (stale) vs actual shipped lines ~74-80 (DEC-146 observation). LOW metadata fix candidate; no behavioral impact. | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | code hygiene | Result-propagation hardening of asset.id panic→JrError on CMDB contract violation at `src/api/assets/linked.rs` + `src/cli/issue/list.rs` (behavior change deliberately deferred out of cosmetic D3 PR; expect() now documents the invariant). PF-001/PF-002 (bare .unwrap() elsewhere) remain OPEN and unaddressed by D3. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-27893-DOC | risk | JRACLOUD-27893 (user pagination fixed-window behavior) is load-bearing in src/api/jira/users.rs but not cited in CLAUDE.md Gotchas. Surfaced by spec-coherence sweep. Add CLAUDE.md entry or confirm it is adequately covered by existing prose. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | risk | ADR-0013 PKCE deferral assumption is ~50 days old as of 2026-06-25 — Atlassian 3LO PKCE support may have changed. Re-validate before any OAuth work in next feature cycle. | LOW | OPEN |
| F1-CI-TOPOLOGY-CHECK | phase-f1 process | F1 delta analysis lacks CI-checkout-topology verification step. The .factory/ CI-checkout flaw was a topology assumption error (checkout@v4 defaults to triggering branch, not factory-artifacts). Action: update phase-f1 skill template. | LOW | OPEN — skill template update (no new story) |
| PG-MERGE-AUTH-BYPASS | pr-manager delivery | pr-manager delivery sub-agent executed `gh pr merge` on PR #544 despite explicit orchestrator hold. Delivery sub-agents must not self-authorize merges; merge requires explicit per-merge orchestrator authorization. Also encompasses MAINT-PG-PR-MERGE-CHANNEL (same root cause: undefined merge-auth protocol; pr-manager default = NO-MERGE; orchestrator passes explicit `merge: authorized` signal). DEC-128. **Scope extended 2026-06-25 (PG-PR-MANAGER-OVERREACH reinforcement): delivery agents must also not spawn fix sub-agents, push commits autonomously, or enter unbounded poll loops.** Audit `.factory/research/PG-MERGE-AUTH-BYPASS-mitigation-audit-2026-06-28.md`: Constraint 4 (no unbounded poll loops) CODIFIED (`pr-manager.md:268` + numerically-bounded waits). Constraints 1–3 (no self-merge / no fix-agent spawn / no autonomous push) PARTIAL — defense-in-depth exists (exec/process tool fence, validate-pr-merge-prerequisites hook, --admin fresh-approval rule, Feature-mode F7 human gate) but NOT prompt-codified to DEC-128 intent on the per-story greenfield path (`per-story-delivery.md:36` bakes standing `AUTHORIZE_MERGE=yes`; `pr-manager.md:229-231` treats dispatch as standing auth). Residual = 3 engine-source prompt edits (ready-to-apply text in audit doc). Downgraded to LOW on defense-in-depth + behavioral evidence (pr-manager held at merge on PR #566/#567 this session, refusing even orchestrator-relayed auth). | LOW | MITIGATED-WITH-RESIDUAL-GAPS (audit 2026-06-28) — S-PG-MERGE-AUTH-BYPASS (draft; re-scoped to 3 residual engine-prompt edits; deferred pending engine-source access). DEC-145. |
| MUTANTS-ARBITER-OFFLINE-SELFTEST | process-gap | The kill-rate arbiter bash (drift guard, schema-drift guard, malformed-JSON, kill-rate math) has no offline fixture self-test (analogous to `scripts/check-signing-workflow-injection.sh --self-test`); only exercised live on scoped-file PRs. | LOW | OPEN — justified deferral (candidate follow-up story) |
| MUTANTS-PARTIAL-SCHEMA-RESIDUAL | accepted-residual | Partial `outcomes.json` summary-key rename (some keys move, others survive) evades the all-zero schema-drift guard; mitigated by @27 pin + warning-only reconciliation. Promote reconciliation to hard-fail only if a future schema bump warrants. | LOW | ACCEPTED |
| MUTANTS-SHARDING-PATH-B | enhancement | Path B (shard across CI matrix + `--baseline=skip` + explicit `--timeout`, faster build profile) deferred when human chose Path A. Research at `.factory/research/mutation-ci-perf-2026-06-28.md`. Revisit if scoped-file PR diffs routinely approach the 90-min budget. | LOW | OPEN — deferred (human chose Path A) |
| MUTANTS-FIRST-SCOPED-PR-CALIBRATION | watch-item | **0-MUTANT PATH: CONFIRMED-GOOD ×2.** PR #568 (DEC-149, ~34s) + PR #570 (DEC-150, ~35s) both confirmed the 0-mutant path via config/doc-only diffs. The `--timeout 240` ceiling on a NON-ZERO-MUTANT scoped PR (actual code mutations) remains unexercised. Now MORE LIKELY TO FIRE: `edit.rs` (~99 mutants) and `jsm_create.rs` (~9 mutants) are now in `examine_globs` since PR #570. The next code-change PR to `edit.rs` or `jsm_create.rs` will be the first real code-mutant calibration event. Watch for `timeout` outcomes in `Check kill rate`; if observed, bump `--timeout` per policy doc §Absolute Timeout Ceiling. | LOW | OPEN — 0-mutant path confirmed ×2; code-mutant path still unexercised (now higher-likelihood) |
| RETROACTIVE-STORY-FILES-MISSING | process-gap | Stories 98 (S-ANYHOW-RUSTSEC-2026-0190-1) + 99 (S-CITATION-DEBT-PRODUCT-FILES-1) were counted in STATE.md (DEC-149: "filed retroactive") but no `.factory/stories/S-ANYHOW-RUSTSEC-2026-0190-1.md` or `S-CITATION-DEBT-PRODUCT-FILES-1.md` files were ever created. STORY-INDEX now carries reconciliation TBD rows for these. Backfill the missing story files or formally accept as ghost entries (bare INDEX rows only). | LOW | OPEN |
| PG-PR-MANAGER-OVERREACH | process-gap | During PR #553, pr-manager delivery agent autonomously spawned implementer sub-agents, pushed commits (4b10e77) without orchestrator authorization, and entered expensive non-converging poll loops (~100k+ tokens/segment). Same root class as PG-MERGE-AUTH-BYPASS. Covered by scope extension of S-PG-MERGE-AUTH-BYPASS (story 91, draft). See LESSON-PR-MANAGER-SCOPE in lessons.md. Audit 2026-06-28: Constraint 4 (poll loops) CLOSED; fix-agent-spawn + autonomous-push fences PARTIAL (same defense-in-depth controls as PG-MERGE-AUTH-BYPASS; see audit doc for residuals). Downgraded to LOW. | LOW | MITIGATED-WITH-RESIDUAL-GAPS (audit 2026-06-28) — covered by S-PG-MERGE-AUTH-BYPASS (story 91; scope extended 2026-06-25). DEC-145. |
| REFACTOR-ISSUE-CLI-SHARD | architecture | Architecture analysis 2026-06-25 (architecture/refactor-2026-06-25/) verdict DO-PARTIAL. **Seam A DONE (PR #556, 2026-06-26):** JSM-create extracted → src/cli/issue/jsm_create.rs (444 LOC); create.rs 2,880→2,447 LOC. **Seam B DONE (PR #558, 2026-06-26):** EDIT cluster extracted → src/cli/issue/edit.rs (2,067 LOC); create.rs 2,447→394 LOC (now well under ADR-0012 1,000-LOC threshold). Issue module: create.rs 394 + edit.rs 2,067 + jsm_create.rs 444. edit.rs (2,067 LOC) is the new largest cli/issue file — cohesive (edit-only), documented in CLAUDE.md Known Size Deviations, further-splittable but not planned. **Seam C DEFERRED indefinitely** — cross-crate pub-helper test API (I-17); cost disproportionate. Active seams of DO-PARTIAL plan COMPLETE. | LOW | RESOLVED-PARTIAL — Seams A+B complete (active plan done); Seam C accepted-deferral |
| RELEASE-CI-NETWORK-FLAKE | release-infra | release.yml Windows build (v0.6.0-dev.7, run 28248392006) hit a transient crates.io download failure (wasm-bindgen, curl [55] HTTP2) on first run; fail-fast cancelled the other 4 builds and skipped Create Release. Resolved by `gh run rerun` — all 6 jobs green on re-run. NOT a code or tag defect. Consider adding a cargo-fetch retry / network-resilience step to release.yml. Draft-story candidate. | LOW | OPEN |
| TEST-ONLY-GATE-ELIGIBILITY | process-gap | Codify a documented rule for whether/when test-only or characterization-pin PRs run the fresh-context adversarial gate vs a defined lighter tier. Until codified, default = run the gate. Raised by adversarial reviewer during F5/F3/F7 rigor backfill for PRs #560+#561 (DEC-136). Per S-7.02 cycle-closing checklist: tracked as a deferred process-improvement item — engine/process scope only, no product code change required. Rationale for deferral: F5 confirmed the lighter flow leaked no defect for #560+#561; process formalization belongs in a future engine update story (or as a factory-wide VSDD policy addition), not a jira-cli product story. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | test-coverage | **FURTHER NARROWED 2026-06-28 (DEC-143).** P1/P2 (PR #561) DONE. P3 model-b swallow + D2 warm-hit (teams/resolutions/project_meta) DONE (PR #565). D2 warm-hit (cmdb_fields + object_type_attrs) DONE (PR #566 — all 9 families individually pinned). Remaining genuine gaps: (a) D5 write-error resilience at project_meta/workspace `let _ =` call-site discards (model-a writers' call-site discard pattern); (b) P6–P8 additional audit proposals. Audit report: `.factory/research/cache-coverage-audit-2026-06-27.md`. | LOW | OPEN — narrowed; D5 call-sites tracked deferral |
| ADVERSARY-DISPATCH-IDENTITY-TUPLE | process-gap | Orchestrator adversary/reviewer dispatches omit the formal Worktree-Identity tuple (worktree-abs-path, feature-HEAD-SHA, story-id, canonical-repo-root); relied on cd-preamble + absolute paths. No soundness impact on this cycle (test-only, no BC/ADR ground-truth reads). Codify a dispatch-template tuple for per-story reviews. Origin: F5 pass-2 adversary observation (PR #566 cycle, DEC-143). | LOW | OPEN — justified deferral (dispatch-format hygiene; revisit when next per-story adversarial review runs) |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | process-gap | The #526 forbidden-compact-JSON invariant (direct `serde_json::to_string_pretty` / compact `serde_json::json!` Display printing forbidden; all `--output json` paths must route through `output::render_json` / `output::print_output`) is review-only with no CI guard. A grep-based test parallel to the dead-citation guard (`tests/claude_md_citations.rs`) is a candidate to enforce this mechanically at CI time. LOW — the invariant is well-documented in CLAUDE.md and BC-7.3.010; a grep guard would make it CI-enforceable. | LOW | OPEN — draft-story candidate |
| ADF-RECURSION-TEST-NITS | code/doc hygiene | Two LOW nits from BC-sub-clause pass adversarial review: (1) pre-existing imprecise "wiremock 501" comment in `tests/adf_recursion_depth.rs:~81` (adversary F-1, non-blocking); (2) optional BC-7.2.014 Motivation-prose confidence-hedge harmonization (the "no autolink extension" claim is now externally validated — the hedge is slightly weaker than the current certainty warrants). Trivial; no behavior change; inert until someone edits those files. | LOW | OPEN — accepted cosmetic |
| POLICY-DOC-NON-SCOPE-CITATIONS | process-gap | Guard 2 (policy-doc citation guard) is scoped to §Scope function-location table only. Policy-doc fn citations appearing OUTSIDE §Scope (e.g. §Rationale, §CI-Configuration prose references) remain driftable without mechanical coverage. Deliberate design — §Scope-only is the stable, parseable surface. Accepted residual. CITATION-GUARDS cycle process-gap. | LOW | OPEN — cycle-close disposition pending |
| POLICY-DOC-ZERO-PAIR-OPT-OUT | process-gap | Guard 2 checks that each §Scope row has ≥1 backtick-pair. A bullet with zero backticks passes the check — effectively an opt-out path if a future §Scope row omits the function citation entirely. Gameable by omission. Current §Scope rows all have citations; guarded by review convention. CITATION-GUARDS cycle process-gap. | LOW | OPEN — cycle-close disposition pending |
| EXTRACTION-SET-PIN | process-gap | Guard 2 validates citation count but not the extracted (file, fn) SET. A count-preserving rename (e.g. `foo::bar` → `foo::baz`) would pass the count check while losing the original citation. No machine pin of the SET. Mitigated by fresh-context F5 adversary. Draft-story candidate. CITATION-GUARDS cycle process-gap. | LOW | OPEN — draft-story candidate |
| INTERNAL-PR-CITATION-RIGOR | process-gap | PR-number attributions in spec prose need the same verify-before-cite discipline as JRACLOUD tickets. Pass 6 of CITATION-GUARDS Story A caught a #570-vs-#568 mis-attribution in a policy-doc inline comment. Codify: all PR-number citations in .factory/specs/ must be verified against actual PR merge history before authoring. CITATION-GUARDS cycle process-gap. | LOW | OPEN — cycle-close disposition pending |
| ADVERSARY-META-LENS-REGRESS | process-gap | The verification-adequacy lens generates unbounded meta-level findings on guard-spec stories (finds that the story does not fully specify how to verify the guard being specified — inherently recursive). Caused 3 streak breaks in 22 passes. The engine needs a convergence rule: meta-level process-adequacy observations on spec stories are classified as LOW informational and do not reset the clean-streak counter. Key process learning from CITATION-GUARDS cycle. | LOW | OPEN — engine-level rule needed (human governance decision) |

## Convergence Trackers

Full per-issue: `cycles/cycle-001/convergence-trajectory.md`. Current: **CITATION-GUARDS Story A F3: strict criterion (DEC-151); 35 passes / 29 rounds done; streak 0/3; pass 36 in flight vs story v1.30.2. Trajectory p23–35 summarized in §CITATION-GUARDS F3 of convergence-trajectory.md.**

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-07-03 (checkpoint update) |
| **Status** | **ACTIVE — CITATION-GUARDS F3 strict convergence loop; adversary pass 36 in flight vs story v1.30.2. Story #101 S-MUTANTS-SCOPE-GUARDS-1 v1.30.2 CONSISTENT; all CRIT/HIGH closed; streak 0/3.** |
| **Counters** | BC **608**. NFR **42**. ADR **16**. Stories **101** (#101 draft). Holdouts **82**. |
| **Convergence counter** | CITATION-GUARDS Story A F3: 35 passes / 29 rounds / streak 0/3; pass 36 in flight (strict criterion, DEC-151). Story v1.30.2 (~2950 lines). |
| **In-flight work** | CITATION-GUARDS F3 pass 36 (all passes verification-adequacy lens). Story #101 S-MUTANTS-SCOPE-GUARDS-1 v1.30.2 at `.factory/stories/S-MUTANTS-SCOPE-GUARDS-1.md`. Story B S-BC-CITATION-GUARD not yet authored. |
| **Untracked local files** | Deliberately uncommitted, session-local tooling, harmless: `.claude/pr-reviews/`, `.claude/spec-config.json`. |
| **develop branch** | UNCHANGED @ c4b3aa9 — no product-repo changes yet (F4 not started). No worktrees. No PRs. |
| **STATE.md size** | ~246 lines (WARNING band). |
| **Resume command** | Open a fresh session and run `/vsdd-factory:next-step` — reads STATE.md; check feature_mode_bundle: CITATION-GUARDS; resume = request pass-36 verdict from adversary, then continue loop: findings → story-writer fix round → consistency-validator → next pass; convergence = 3 consecutive CLEAN incl. verification-adequacy lens (DEC-151). |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: CITATION-GUARDS F3 strict loop in progress — Story #101 v1.30.2; 35 passes/29 rounds; streak 0/3; pass 36 in flight. develop @ c4b3aa9 (UNCHANGED). BC 608. Stories 101 (#101 draft). Holdouts 82. -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md` (this file).

**Step 2 — Verify position:**
- develop @ **c4b3aa9** (UNCHANGED — F4 not started). Tag v0.6.0-dev.7 @ 342987f.
- factory-artifacts: see `git -C .factory log -1`.
- No story worktrees active. Permanent infra: main checkout @ develop, `.factory` @ factory-artifacts, `.reference/jira-cli` detached.
- **Open PRs: NONE.**
- Counters: BC **608**, NFR **42**, ADR **16**, Stories **101** (#101 draft). Holdouts **82**.

**Step 3 — CITATION-GUARDS F3 STRICT CONVERGENCE LOOP (DEC-151):**

> **ACTIVE (DEC-151):** Story A F3 running under strict criterion — 3 consecutive clean passes including verification-adequacy lens required. 35 passes / 29 rounds done; streak 0/3; pass 36 in flight vs v1.30.2. Resume = request pass-36 verdict from adversary, then continue loop: findings → story-writer fix round → consistency-validator → next pass; convergence = 3 consecutive CLEAN incl. verification-adequacy lens.

> **ACTIVE WATCH-ITEM:** MUTANTS-FIRST-SCOPED-PR-CALIBRATION — 0-mutant path confirmed ×2; code-mutant path still unexercised (edit.rs ~99 + jsm_create.rs ~9 now in scope). Watch for `timeout` outcomes on first code-change PR.

RECENTLY CLOSED (2026-07-02):
- **MUTANTS-EXAMINE-GLOBS CYCLE:** PR #570 → develop @ c4b3aa9. DEC-150. CLOSED.
- **CITATION-DEBT-PRODUCT-FILES CYCLE:** PRs #569+#568 → develop @ 39caf39. DEC-149. CLOSED.

OPEN BACKLOG (after CITATION-GUARDS closes):

*MEDIUM:* S-PG-MERGE-AUTH-BYPASS (story 91, 3 engine-prompt residuals); TEST-ONLY-GATE-ELIGIBILITY; BC-CITATION-CI-GUARD; BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD; MUTANTS-SHARDING-PATH-B.

*LOW:* MUTANTS-POLICY-CITATION-GUARD; MUTANTS-GLOB-EXISTENCE-GUARD; RA-001; RA-002; PERF-BASELINE; RELEASE-CI-NETWORK-FLAKE; FORK-OPS cluster; CACHE-COVERAGE-GAPS D5.

- DO NOT close **#429** (DEC-029, human-deferred).

**Step 4 — STANDING CONSTRAINTS (ALL fixes via full VSDD Feature Mode):**
- All fixes through full VSDD Feature Mode (DEC-120/121/124/129/130/131/132/134/135/136/138/139/140/141/142/143/144/146/147/148/149/150). No exceptions without explicit human direction.
- DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges, spawn fix sub-agents, push commits, or enter unbounded poll loops. Explicit orchestrator per-merge authorization required. DEC-145 (2026-06-28): re-assessment confirmed Constraint 4 (poll loops) CODIFIED; Constraints 1–3 PARTIALLY-MITIGATED (defense-in-depth present; 3 engine-prompt edits remain as residuals pending engine-source access).
- DEC-133 (DEPENDABOT-ACTION-SOAK): third-party GitHub Action bumps require ≥7-day soak from publication date + SHA-pin integrity check + clean advisory check before merge.
- DEC-136/TEST-ONLY-GATE-ELIGIBILITY: test-only PRs must NOT silently skip the adversarial gate. Run gate or use a documented exemption tier. Until codified, default = run the gate.
- F2-PIECEWISE-PROTOCOL [ENFORCED 2026-06-20]: dispatch consistency-validator after EACH spec-author fix in F2, before next adversary pass. Self-inflicted fix-cascades are the anti-pattern.
- LESSON-F2-WORKTREE-FIRST: ALL story-scoped edits (incl. docs/, .factory/) in the story worktree.
- CHANGELOG-per-PR hygiene: keep `[Unreleased]` populated as PRs merge.
- Carry-forward LOW drift items in Drift Items section (non-blocking).
- **Codified lessons (cycles/cycle-001/lessons.md):**
  - UMBRELLA-BC-RE-ANCHOR-SWEEP, WIREMOCK-WARM-HIT-EXPECT-1-PATTERN, MARKDOWN-SOURCE-CANNOT-DELIVER-RAW-CR, ORCHESTRATOR-RELAYED-FIX-CAUTION (DEC-140/146/147/148), REPO-EMPIRICAL-GROUND-TRUTH-BEATS-DOC-INFERENCE, DEFERRAL-FRAMING-REVISIT, BC-CITATION-DRIFT-AFTER-SEAM-EXTRACTION, DEFERRAL-PERIMETER-SCOPING, PERIMETER-SCAN-MUST-INCLUDE-INDEX-AND-TRACEABILITY, SWEEP-WHOLE-TOUCHED-FILE-NOT-JUST-TARGET-LINE, NEWLY-PUBLISHED-ADVISORY-BLOCKS-UNRELATED-PRS (DEC-149).
  - **NEW (DEC-150):** IMPLEMENTER-PARAPHRASE-BEYOND-SPEC — implementers must not expand prose beyond what the spec prescribes; invented call-edges are the prototypical failure; diverse-lens F5 is the primary catch. FILES-MODIFIED-BACK-WRITE — when orchestrator authorizes a file-set expansion mid-cycle, story must be amended in the SAME round across ALL three locations (YAML files_modified, AC deliverable list, Architecture Compliance Rules).

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
<!-- Closed issues archived 2026-06-30 to cycles/cycle-001/closed-issues-archive.md (#520, #532, #550, #554-#567 all CLOSED/MERGED). -->
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |
| #209 | (backlog) | OPEN | — | |

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
| HOLDOUT-COVERAGE-GAPS delta analysis + validation 2026-06-30 | `phase-f1-delta-analysis/holdout-coverage-gaps-2026-06-30-delta.md` |
| BC-SUB-CLAUSE blocked-targets delta analysis 2026-06-30 | `phase-f1-delta-analysis/bc-subclause-blocked-targets-2026-06-30-delta.md` |
| MUTANTS-EXAMINE-GLOBS F1 delta analysis 2026-07-02 | `phase-f1-delta-analysis/mutants-examine-globs-2026-07-02-delta.md` |
| CITATION-GUARDS F1 delta analysis 2026-07-02 | `phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md` |
