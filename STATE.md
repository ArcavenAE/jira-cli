---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-07-11T09:15:00Z
phase: 3
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "SOH-COMMENT-CRUD-1 F3 adversarial convergence IN PROGRESS — pass-13 1 finding (1L tautological verification grep) fixed in round 14 (CV verified). Awaiting F3 adversary pass 14. STRICT; streak 0/3; F3 trajectory →8→10→9→5→4→4→2→3→2→2→1→1→1 (three consecutive single-LOW passes — noise floor)."
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: SOH-COMMENT-CRUD-1
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: IN_PROGRESS
activation_head: "b2ce3169"
activation_version: "v0.6.0-dev.9"
---

<!--
  STATE.md SIZE BUDGET (per D-421(c)):
  Hard cap (500 lines) margin from soft-target = 500 - 313 = 187; margin from actual = 500 - 313 = 187 (D-446(c) dual-margin form). 313 lines (wc-l).
  Hard cap: 500 lines.
-->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop → main |
| **Last Updated** | 2026-07-11: F3 pass-13 (1L) fixed round 14 — row-marker greps. Pass 14 next. |
| **Current Phase** | Phase 3 — **SOH-COMMENT-CRUD-1 F3 adversary loop (2026-07-11)**. Spec v1.3.40. Stories **111**. F3 adversary loop. Trajectory tail →1→1→1. Pass-14 next. BC **624**. Holdouts **88**. VP **30**. |
| **Next Phase** | CV targeted verify → adversary pass-33 → Full STRICT target (3 consecutive zero-finding passes) → F2 human gate → F3 stories. |
| **Activation HEAD** | b2ce3169 (PR #603 squash-merged 2026-07-09; SOH-BUGS-1 FULLY COMPLETE; release v0.6.0-dev.9; issues #589/#590/#582 CLOSED) |

## Phase Progress

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived: Phase 0–2 + Feature cycles 2026-05-04..2026-07-07 + CITATION-GUARDS rows + F1 GATE APPROVED row + F2 SPEC DELTA row + pass-5 adversary row + fix burst 4 row + DEC-158 row + F2 passes 6-16 row (archived F4 DELIVERED burst) + F2 passes 17-19 row (archived F6 hardening burst) + F3 adversary 1-7 row (archived F7 evidence burst) + F4 DELIVERED row (archived F7-AUTHORIZED burst) + F5 CONVERGED row (archived session-review burst) + F6 TARGETED HARDENING row (archived IP-571 disposition burst) + F7 AUTHORIZED row (archived external-PR review burst) + RELEASE v0.6.0-dev.8 COMPLETE row (archived SOH-BUGS-1 intake burst) + SESSION RESUME + SESSION-REVIEW COMPLETE row (archived SOH-BUGS-1 F1 gate burst) + SESSION-REVIEW PROPOSALS ROUTED UPSTREAM row (archived S-SOH-590-1 DELIVERED burst) + EXTERNAL-PR REVIEW BURST row + SOH-BUGS-1 INTAKE row (archived SOH-BUGS-1 DELIVERY CLOSE burst) + SOH-BUGS-1 F1 APPROVED row (archived fix-round-38 burst) + S-SOH-590-1 DELIVERED row (archived passes-33-34 fix-round-39 burst) + S-SOH-589-1 DELIVERED row (archived pass-35 fix-round-40 burst) + SOH-BUGS-1 CLOSED row (archived pass-36 fix-round-41 burst) + SOH-COMMENT-CRUD-1 INTAKE+F1 row (archived pass-37 fix-round-42 burst) + pass-32 fix-round-38 row (archived checkpoint-DEC-169 burst) + passes-33-34 fix-round-39 row (archived pass-39 fix-round-44 burst) + pass-35 fix-round-40 row (archived pass-40 fix-round-45 burst) + pass-36 fix-round-41 row (archived pass-41 fix-round-46 burst) + pass-37 fix-round-42 row (archived pass-42 CLEAN burst) + checkpoint-DEC-169+pass-38 fix-round-43 row (archived pass-44 fix-round-47 burst) + pass-39 fix-round-44 row (archived pass-45 fix-round-48 burst) + pass-40 fix-round-45 row (archived pass-46 CLEAN burst) + pass-41 fix-round-46 row (archived pass-48 CONVERGED burst) + passes-42+43 CLEAN row (archived F2-gate-approved burst) + pass-44 fix-round-47 row (archived F3-stories-created burst) -->
| Phase | Status | Completed | Gate | Notes |
|-------|--------|-----------|------|-------|
| **SOH-COMMENT-CRUD-1 F2 pass 45 + fix round 48 (2026-07-11) — 1L (setup-note mis-cite) fixed; spec v1.3.39.** | **COMPLETE** | **2026-07-11** | **adversary + product-owner + consistency-validator.** | `adversarial-review/pass-45-577.md`; `specs/prd/bc-3-issue-write.md` v1.3.39; `spec-changelog.md`. |
| **SOH-COMMENT-CRUD-1 F2 passes 46+47 CLEAN (2026-07-11) — 0 findings each; STRICT streak 2/3 (second window); spec v1.3.39 unchanged.** | **COMPLETE** | **2026-07-11** | **adversary (CLEAN ×2).** | `adversarial-review/pass-46-577.md`; `adversarial-review/pass-47-577.md`. |
| **SOH-COMMENT-CRUD-1 F2 STRICT CONVERGED (2026-07-11) — window p46/p47/p48 CLEAN×3; 48 passes / 48 fix rounds; spec v1.3.39.** | **COMPLETE** | **2026-07-11** | **adversary (CONVERGED).** | `phase-f2-spec-evolution/f2-convergence-record-577.md`; `adversarial-review/pass-48-577.md`. |
| **SOH-COMMENT-CRUD-1 F2 GATE APPROVED (DEC-170, 2026-07-11) — v1.3.40 items h+i; consistency-audit gaps folded; F3 stories AUTHORIZED.** | **COMPLETE** | **2026-07-11** | **human gate.** | `phase-f2-spec-evolution/f2-convergence-record-577.md`; `specs/prd/bc-3-issue-write.md` v1.3.40. |
| **SOH-COMMENT-CRUD-1 F3 pass 13 + fix round 14 (2026-07-11) — 1L fixed (AC-009 tautological grep → row-marker greps; +1 cosmetic pre-empted); CV verified.** | **COMPLETE** | **2026-07-11** | **adversary + consistency-validator.** | `adversarial-review/f3-pass-13-577.md`; stories updated. |

## Current Phase Steps

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived: CITATION-GUARDS rows + F1 GATE APPROVED + SPEC DELTA row + PASSES 1-5 row + DEC-158 row + PASSES 6-16 row + PASSES 17-19 row + DEC-159 row (archived F4 DELIVERED burst) + F3 story v1.7 row (archived F6 hardening burst) + F3 adversary passes 1-7 row (archived F7 evidence burst) + F3 adversary passes 8-10 row (archived F7-AUTHORIZED burst) + F5 CONVERGED row (archived session-wrap pause burst) + F6 TARGETED HARDENING row (archived session-review burst) + F7 AUTHORIZED row (archived IP-571 disposition burst) + RELEASE IN PROGRESS row (archived external-PR review burst) + RELEASE v0.6.0-dev.8 TAGGED row (archived SOH-BUGS-1 intake burst) + SESSION WRAP/PAUSE row (archived SOH-BUGS-1 F1 gate burst) + SESSION RESUME + SESSION-REVIEW COMPLETE row (archived S-SOH-590-1 DELIVERED burst) + SESSION-REVIEW PROPOSALS ROUTED UPSTREAM row + EXTERNAL-PR REVIEW BURST row + INTAKE row (archived SOH-BUGS-1 DELIVERY CLOSE burst) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **S-SOH-589-1 DELIVERED (2026-07-09) — PR #601 @ 081187ae (DEC-128 honored); fix-PR #602 @ bf3b3382 (clippy 1.97 unblock, APPROVE cycle 2). Step-4.5 STRICT: 7 passes / 4 fix rounds; trajectory 3→4→0→1→0→0→0; window p5/p6/p7 CLEAN×3. 6/6 AC demos (local). 2016/0/93. DEC-166.** | implementer + pr-manager + state-manager | COMPLETE | `cycles/cycle-001/S-SOH-589-1/implementation/red-gate-log.md`; `cycles/cycle-001/S-SOH-589-1/implementation/step-4-5-convergence.md`; `stories/S-SOH-589-1.md` updated to completed; `sprint-state.yaml` updated. |
| **SOH-BUGS-1 CLOSED (2026-07-09) — release v0.6.0-dev.9 SHIPPED @ b2ce3169 (run 29051718553, 10 assets); issues #589/#590/#582 CLOSED. DEC-167. RELEASING-MD-MISSING drift recorded.** | state-manager | COMPLETE | PR #603 @ b2ce3169; tag v0.6.0-dev.9; workflow run 29051718553 SUCCESS; 10 assets. |
| **SESSION WRAP (2026-07-10) — human /wrap after SOH-BUGS-1 completion + v0.6.0-dev.9 release + e2e repair (run 29055766599). Pipeline PAUSED. Resume intent: issues intake.** | state-manager | COMPLETE | Pipeline PAUSED per human /wrap. E2E repaired. RESUME INTENT: issues-intake (sackofhacks P1 #575/#576/#577). |
| **SOH-COMMENT-CRUD-1 INTAKE + F1 APPROVED (2026-07-09) — DEC-168. F2 spec evolution next: product-owner BC delta per 4 rulings → consistency-validator → security-reviewer → adversary ≥3 clean.** | architect + research-agent + state-manager | COMPLETE | `phase-f1-delta-analysis/delta-analysis-577-comment-crud.md`; `research/issue-577-comment-crud-jsdpublic-2026-07-09.md`. |
| **SESSION WRAP (2026-07-10) — human /wrap during F2 adversarial convergence. Pipeline PAUSED. Pass-32 verdict received at wrap (1H+3L, filed to adversarial-review/pass-32-577.md); fix round 38 deferred to resume.** | state-manager | COMPLETE | STATE.md checkpoint; WIP chain 18f24cc..aa6a5c7 pushed. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-124 | Phase 0/1/2/3 + Wave + Feature Mode + #492 + #522 + S-TESTTOOL-1 + S-FORK-OPS-SIGN-1 decisions. All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 0→3 / 2026-05-04..2026-06-19 | archived |
| DEC-125..DEC-145 | DEAD-CITATION-CI (DEC-125..130), maint sweep 2026-06-22 (DEC-131), SEC-001 (DEC-132), DEPENDABOT-SOAK (DEC-133), D4 holdout refresh (DEC-134), cache audit (DEC-135), PRs #560/#561 (DEC-136), E2E edge-case (DEC-137), BC-sub-clause (DEC-138), E2E offline (DEC-139), E2E wiremock (DEC-140), E2E G-ADF-FOOTNOTE (DEC-141), cache P3+D2 PR #565 (DEC-142), cmdb/objtype PR #566 (DEC-143), MUTATION-CI-TIMEOUT PR #567 (DEC-144), S-PG-MERGE-AUTH-BYPASS re-assessment (DEC-145). All CYCLE CLOSED. | See `cycles/cycle-001/burst-log.md` | Phase 3 / 2026-06-20..2026-06-28 | archived |
| DEC-156 | **CITATION-GUARDS CYCLE CLOSED — Story A (PR #572 @ ab78a2d) + Story B (PR #592 @ 0d8a8a5) both DELIVERED. Guard family complete (BC-X.13.001..006). 309 citations enforced in CI.** | CITATION-GUARDS bundle complete — both stories delivered. | Feature Mode / CITATION-GUARDS | 2026-07-07 |
| DEC-157 | **ADF-CODE-MARK-EXCLUSIVITY F1 gate approved 2026-07-07: 5-point scope ratified — emit-site filter in `src/adf.rs::push_code`; no node-splitting; apply_marks read-tolerance retained; BC-7.2.015 standalone; STANDARD criterion.** | Human gate cleared; F2 dispatch authorized. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY | 2026-07-07 |
| DEC-158 | **F2 convergence criterion STRICT + scope rulings (2026-07-07, human): STRICT — any delta-attributable LOW resets; VA-informational exempt per DEC-153. Opportunistic pre-existing repairs ride cycle. BC-INDEX-9TH-SURFACE guard-extension candidate.** | Human ratified mid-cycle checkpoint #2 after 11 uncommitted F2 rounds. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY F2 | 2026-07-07 |
| DEC-159 | **ADF-CODE-MARK-EXCLUSIVITY F2 CONVERGED (STRICT, 2026-07-07, human-approved): 19 passes / 13 fix rounds; clean window 17+18+19. Final: BC-7.2.015 + BC-7.2.007 EC-2 + H-NEW-ADF-010 + VP-571-001..005 + PANEL-ANCHOR. BC 612, holdouts 83, spec v1.3.25. F3 criterion: STRICT.** | F2 gate closed; STRICT convergence confirmed; F3 dispatched. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY F2 | 2026-07-07 |
| DEC-160 | **ADF-CODE-MARK F3 CONVERGED (STRICT) — S-ADF-CODE-MARK-1 (#103) v1.7: 10 passes / 6 fix rounds + 2 preemptive catches. Window 8+9+10 CLEAN. HELD at F3 human gate pending authorization. Criterion-comparison: F3 STRICT = 10 passes.** | F3 STRICT convergence confirmed; HELD for human authorization. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY F3 | 2026-07-08 |
| DEC-161 | **ADF-CODE-MARK F4 DELIVERY RECORD (2026-07-08, human merge, DEC-128 honored): PR #593 @ 7ba4cf4. Story #103 v1.9 delivered. 8 commits. Step 4.5 CONVERGED STRICT (window F4-p2/F4-p3/F4-p4). 992 lib + 49 integration + 256-case proptest. Mutation gate PASS 5m32s (FIRST real code-diff exercise — calibration validated; MUTANTS-FIRST-SCOPED-PR-CALIBRATION RESOLVED). Security 1 LOW (SEC-001). pr-reviewer APPROVE cycle 1. 12/12 AC demos. Issue #571 closed. F5 DISPATCHED: p1 CLEAN, p2 CLEAN, p3 1 LOW MISSING-CHANGELOG-ENTRY (fix-PR #594 review COMPLETE — APPROVE, HELD for human squash-merge DEC-128; streak 0/3 STRICT). 1024-case proptest stress PASS. New drift: STORY-TEMPLATE-CHANGELOG-TASK, ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY.** | F4 delivery + process ledger + F5 state for ADF-CODE-MARK-EXCLUSIVITY. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY F4 | 2026-07-08 |
| DEC-162 | **ADF-CODE-MARK F5 CONVERGENCE RECORD (2026-07-08, STRICT, human-approved). Fix-PR #594 @ d7875e6 (DEC-128 honored; worktrees/.branches cleaned up). 6 passes: p1 CLEAN (post-merge), p2 CLEAN, p3 1 LOW MISSING-CHANGELOG-ENTRY (fixed via #594), p4 CLEAN, p5 CLEAN (informational obs spec-changelog range-shift verified NON-DEFECT per factory commit b5c0f6c), p6 CLEAN. Window p4/p5/p6 CLEAN×3. No [process-gap] findings any pass — checklist step 2/3 satisfied vacuously. Deferral F5-OBS-001 (BC-7.2.015 lossiness not cross-listed in BC-7.2.011 five-case catalogue; documented in BC-7.2.007 EC-2 + CLAUDE.md; target: next spec-maintenance sweep). Deferral F5-OBS-002 (no runtime stderr warning on push_code typographic-mark strip; silent strip correct product call vs pre-fix HTTP 400; target: v2 backlog). F6 DISPATCHED.** | F5 STRICT convergence record for ADF-CODE-MARK-EXCLUSIVITY. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY F5 | 2026-07-08 |
| DEC-163 | **ADF-CODE-MARK-EXCLUSIVITY F7 AUTHORIZED (2026-07-08, human) — 5/5 dimensions PASS, bundle CONVERGED AND CLOSED. Cycle-closing checklist S-7.02 SATISFIED: zero [process-gap] findings across F5 p1-p6; both LOW deferrals (F5-OBS-001/002) already in Drift Items. Release routing: v0.6.0-dev.8 PR #596 (chore/bump-v0.6.0-dev.8 → develop) opened; Cargo.toml 0.6.0-dev.7→0.6.0-dev.8; local gates green (clippy/fmt/test). PR #596 squash-merged by human @ 159e1be; annotated tag v0.6.0-dev.8 pushed on develop @ 159e1be; workflow run 28969465350 SUCCESS (10 assets); bump branch cleaned up local+remote. ADF-CODE-MARK-EXCLUSIVITY cycle FULLY COMPLETE.** | Human authorized F7; bundle formally closed; release tagged and complete. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY F7 + Release | 2026-07-08 |
| DEC-164 | **SESSION-REVIEW IP-571 DISPOSITION (2026-07-08, human): all 13 proposals adjudicated engine-side; routed upstream to drbothen/vsdd-factory as 9 new issues (#576-#584) + 3 comments on existing issues (#507 peer-artifact sweep / #428 changelog attestation / #298 adversary tool profile). Dedupe survey of all 364 upstream issues performed first. No proposals deferred or rejected. First session review for this project complete; pattern DB + benchmarks seeded.** | Human ruled all proposals belong in the factory engine repo, not jira-cli. | Post-cycle / session-review | 2026-07-08 |
| DEC-165 | **SOH-BUGS-1 F1 GATE (2026-07-09, human): scope approved as recommended — #589 minimum-viable (AllowedValue.id Option<String> only, 7 sites, EC-3.4.016-8, VP-589-001) standard bug-fix route; #590/#582 quick-dev with optional micro-BC X.1.011 post-fix. Both bugs externally reported (sackofhacks), validated pre-intake (research + offline repro). EC numbering deviation from delta analysis (-5 → -8) per append-only rule.** | Human gate cleared; validated external bug reports; two stories, two PRs. | Feature Mode / SOH-BUGS-1 F1 | 2026-07-09 |
| DEC-166 | **SOH-BUGS-1 DELIVERY RECORD (2026-07-09, human merges, DEC-128 honored ×3): S-SOH-590-1 (story 104, quick-dev) PR #597 @ 4f3960e0; S-SOH-589-1 (story 105, standard route) PR #601 @ 081187ae — Red Gate verified, Step 4.5 STRICT 7 passes/4 fix rounds window p5/p6/p7, pr-reviewer APPROVE cycle 1, security clean, 6/6 AC demos (local per .gitignore), suite 2016/0/93. Reactive fix-PR #602 (Rust 1.97 lints: useless_borrows_in_formatting ×2 + question_mark ×1) @ bf3b3382, review converged cycle 2 — unblocked ALL PR CI. TD-031 BC-INDEX lockout mitigated via sanctioned shell edit @ 909ce10 (DRIFT-002 unblocked; 243-cite cleanup still open). BC 613. Stories 105.** | Bundle delivery + reactive CI unblock record. | Feature Mode / SOH-BUGS-1 | 2026-07-09 |
| DEC-167 | **SOH-BUGS-1 CONVERGED AND CLOSED + RELEASE v0.6.0-dev.9 (2026-07-09, human): F7-lite 7/7 PASS (holdout 1.00 6/6 wire-level; consistency CONSISTENT, gaps G1-G3 fixed; S-7.02 SATISFIED). Release per dev.8 precedent: PR #603 @ b2ce3169 (DEC-128 honored ×4 this bundle), tag v0.6.0-dev.9, run 29051718553 SUCCESS, 10 assets. Issues #589 CLOSED, #590 CLOSED, #582 CLOSED (all verified 2026-07-09). RELEASING.md absent — backlog candidate RELEASING-MD-MISSING recorded.** | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-BUGS-1 F7 + Release | 2026-07-09 |
| DEC-168 | **SOH-COMMENT-CRUD-1 F1 GATE (2026-07-09, human): issue #577 approved. Research REFUTED footgun — Jira PRESERVES sd.public.comment on body-only PUT (JSDCLOUD-6050 caveat on explicit writes; 404/403 conflated on DELETE; write:jira-work covers edit+delete, no re-consent). Rulings: (1) edit default = body-only PUT, no properties array; --internal/--public explicit opt-in (supersedes architect GET-preserve-PUT draft BC-3.5.005/006); (2) CLI Option A clean break: comment → add/delete/edit/view subgroup, old flat form errors with hint, CHANGELOG breaking entry; (3) delete 404 → exit 64 + surface Jira body (no silent idempotency); (4) scope: standard route ~7 stories ~21pts, supersede DEFERRED P2, PF-017 interactions.rs shard IN, handle_open OUT, security-reviewer REQUIRED at F2.** | Human gate cleared with research-informed design corrections to external feature request. | Feature Mode / SOH-COMMENT-CRUD-1 F1 | 2026-07-09 |
| DEC-169 | **SOH-COMMENT-CRUD-1 mid-F2 checkpoint (2026-07-11, human): (1) Full STRICT confirmed 3rd time at pass-38 (trajectory 0,2,6,4,4,3 — no HIGH since p35); (2) F-A4 --yes-without---public RATIFIED as silent no-op (EC-3.5.008-4 + VP-577-028; research 9/9 CLIs LENIENT incl. ankitpokhrel/jira-cli, house precedents --no-resolution/--no-input; `research/issue-577-yes-flag-noop-convention-2026-07-11.md`); (3) stderr-hint recorded as follow-up story candidate (house-wide pattern for --yes/--no-resolution/--no-input); (4) feature shape ratified (default+--internal prompt-free, --public y/N-gated, --yes script bypass).** | Human checkpoint per pass-6/pass-14 precedent. | Feature Mode / SOH-COMMENT-CRUD-1 F2 | 2026-07-11 |
| DEC-170 | **SOH-COMMENT-CRUD-1 F2 GATE APPROVED (2026-07-11, human): (1) F2 spec package v1.3.39 approved at STRICT convergence (48 passes/48 rounds, window p46/p47/p48); F3 incremental stories AUTHORIZED. (2) Consistency-audit gaps (json-output-shapes registry + comment-crud.md feature spec) folded into EC-3.5.012-5 as delivery obligations (h)+(i) via scoped round 49 (v1.3.40), mirroring items (f)/(g) — no full re-convergence (mechanical mirror of ratified pattern). (3) Input-drift: bump cycles/* bookkeeping hashes only; point-in-time snapshots (security-review-577, closed-cycle records) left intentionally stale as historical records. Round-49 CV caught orchestrator false-premise on comment-add shape (corrected: current full-Comment serialization registered as-is, byte-identical per EC-3.5.012-2).** | Human gate per F2 protocol; structured questions answered. | Feature Mode / SOH-COMMENT-CRUD-1 F2 gate | 2026-07-11 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI per-AC demos: **Yes — adapted**. See `cycles/cycle-001/burst-log.md`.

## Blocking Issues

None open.

## Drift Items

<!-- OPEN/TRACKED items only. Resolved → cycles/cycle-001/blocking-issues-resolved.md. -->

| ID | Area | Description | Severity | Status |
|----|------|-------------|----------|--------|
| FORK-OPS-537-NITS | PR #537 optional nits | PR #537 carries 2 optional LOW nits. Inert in this repo. | LOW | OPEN |
| FORK-OPS-PHANTOM-RUNS | Phantom workflow runs | ~7 phantom runs/day from new triggers. Cosmetic. | LOW | OPEN |
| WIN-CFG-TESTS-CHECK | Cross-compile | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| WIN-DENY-FRAGILITY | deny.toml | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | ENV_LOCK poison | .lock().unwrap() in auth tests; use unwrap_or_else. | LOW | OPEN |
| E2E-PG-4 | E2E coverage gap | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| PG-A / DRIFT-README | Count guards | check-bc-cumulative-counts.sh does not cover README.md; guard gap OPEN. README content resolved by factory commit e72bcb9. | LOW | OPEN (guard gap only) |
| WIN-PG-1 | No BC-count CI guard | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Story template | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Windows OAuth probe | Release OAuth verification is constants-file check only. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | XDG→JR seam-migration | Enforcement test has directional blind spot. | LOW | OPEN |
| F7-001..F7-003 | Minor precision gaps | CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests". | LOW | ACCEPTED-DEFERRED |
| #492-TEST-HARNESS-COUPLING | process-gap | Handler-level block-HTML tests couple to push_text shape. | LOW | TRACKED DEFERRAL |
| #492-PG-TRACE-TESTS | process-gap | No CI check that BC Source/Trace-cited test symbols resolve to real #[test] fns. | LOW | TRACKED DEFERRAL |
| LESSON-F2-WORKTREE-FIRST | process-gap C-1 | ALL story-scoped edits in worktree, even docs/. | LOW | DEFERRED |
| CITATION-FORM-DISCIPLINE | process-gap | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| F7-COSMETIC-ATTR-ORDER | cosmetic | Story Architecture Rule 3: #[ignore] before #[test]; code uses #[test] first. | LOW | ACCEPTED-COSMETIC |
| FORK-OPS-COMPOSITE-ACTION-SCAN | sign-and-publish.yml | Injection guard does not follow local composite actions; none exist today. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | sign-and-publish.yml | Empty head_branch → TAG=""/VERSION="" (theoretical). | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | sign-and-publish.yml | Orphaned alpha tags accumulate. | LOW | OPEN |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | backfill-release.yml | `gh release upload jr-*.zip` fails loud on zero-match glob. | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | process-gap | F5 checklist conflates `--self-test` inline fixture with real-file scan. | LOW | OPEN |
| MAINT-PG-CI-DOC-LINT | process-gap | CLAUDE.md src-file-tree drift recurring; add check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | coverage-gap | Sweep 5 (perf) skipped 4×. Baseline re-confirmed 2026-06-25: binary 7.09MB, `jr --help` p50 6.4ms. | LOW | OPEN (baseline confirmed; CI guard pending) |
| PERF-COST-TRACKING | instrumentation | No per-cycle token/cost tracking; `.factory/cost-summary.md` not initialized. | LOW | OPEN — draft story candidate |
| HOLDOUT-RESIDUAL-EDIT-FIELD-002-STDERR | accepted-residual | H-NEW-EDIT-FIELD-002 stderr criterion is looser than sibling scenarios (DEC-146). | LOW | ACCEPTED |
| MUTANTS-POLICY-CITATION-GUARD | process-gap | `cargo-mutants-policy.md §Scope` function-location table cites file paths with no CI guard. | LOW | OPEN — draft-story candidate |
| MUTANTS-GLOB-EXISTENCE-GUARD | process-gap | `examine_globs` entries not validated against filesystem at CI time. DEC-150. | LOW | OPEN — draft-story candidate |
| F1-SWEEP-INCLUDES-CI-YML-COMMENTS | process-gap | F1 delta missed stale scope comment at `ci.yml:195`. DEC-150. | LOW | OPEN — justified deferral |
| CICD-SETUP-CLASSIFICATION | process-gap | `.factory/cicd-setup.md` governance classification is ambiguous. | LOW | OPEN — justified deferral |
| DOC-LINK-SWEEP-CANDIDATE-1 | doc hygiene | `docs/specs/jsm-e2e-coverage.md:903` cites stale ADR-0014 filename. | LOW | OPEN — doc-link sweep candidate |
| DOC-LINE-DRIFT-CANDIDATE-1 | doc hygiene | `docs/specs/2026-05-13-search-issue-keys.md:7` cites stale line range. | LOW | OPEN — line-cite drift candidate |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | process-gap | F1 perimeter scan must include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. | LOW | OPEN — codification pending |
| BC-CITATION-CI-GUARD | process-gap | No CI guard validates file::symbol citations in BC bodies. | LOW | CLOSED — Guard 1 delivered (PR #592, DEC-156). |
| BC-INDEX-9TH-SURFACE | process-gap | BC-INDEX.md coverage statistics not covered by check-bc-cumulative-counts.sh. RECURRENCE COUNT: 3. | LOW | OPEN — guard-extension candidate |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | process-gap | Guard 1 does not enforce single-line Trace/Source fields. | LOW | OPEN — follow-up story candidate |
| BC-X5008-STALE-LINE-CITE | BC metadata | BC-X.5.008 Source cites stale line range. DEC-146. | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | code hygiene | Result-propagation hardening at `src/api/assets/linked.rs` + `src/cli/issue/list.rs`. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-27893-DOC | risk | JRACLOUD-27893 (user pagination fixed-window) load-bearing but not cited in CLAUDE.md Gotchas. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | risk | ADR-0013 PKCE deferral ~50 days old as of 2026-06-25. Re-validate before OAuth work. | LOW | OPEN |
| F1-CI-TOPOLOGY-CHECK | phase-f1 process | F1 delta analysis lacks CI-checkout-topology verification step. | LOW | OPEN — skill template update |
| PG-MERGE-AUTH-BYPASS | pr-manager delivery | pr-manager executed `gh pr merge` on PR #544 despite orchestrator hold. DEC-128. Audit 2026-06-28: Constraint 4 CODIFIED; 1–3 PARTIALLY-MITIGATED. | LOW | MITIGATED-WITH-RESIDUAL-GAPS — S-PG-MERGE-AUTH-BYPASS (story 91). DEC-145. |
| MUTANTS-ARBITER-OFFLINE-SELFTEST | process-gap | Kill-rate arbiter bash has no offline fixture self-test. | LOW | OPEN — justified deferral |
| MUTANTS-PARTIAL-SCHEMA-RESIDUAL | accepted-residual | Partial `outcomes.json` summary-key rename evades all-zero schema-drift guard. | LOW | ACCEPTED |
| MUTANTS-SHARDING-PATH-B | enhancement | Path B (shard across CI matrix) deferred when human chose Path A. | LOW | OPEN — deferred |
| MUTANTS-FIRST-SCOPED-PR-CALIBRATION | watch-item | **CLOSED 2026-07-08:** F4 mutation gate PASS 5m32s (PR #593, first code-diff scan). Calibration validated. Predicted survivors limited to 2 spec-accepted classes. See DEC-161. | LOW | CLOSED — CONFIRMED-GOOD (F4 PR #593, DEC-161) |
| RETROACTIVE-STORY-FILES-MISSING | process-gap | Stories 98 + 99 counted in STATE.md but no story files ever created. | LOW | OPEN |
| PG-PR-MANAGER-OVERREACH | process-gap | pr-manager autonomously spawned sub-agents + pushed commits during PR #553. Covered by story 91. | LOW | MITIGATED-WITH-RESIDUAL-GAPS — covered by story 91. DEC-145. |
| REFACTOR-ISSUE-CLI-SHARD | architecture | Seam A+B DONE (PRs #556+#558). Seam C DEFERRED. | LOW | RESOLVED-PARTIAL |
| RELEASE-CI-NETWORK-FLAKE | release-infra | release.yml Windows build hit transient crates.io failure; resolved by `gh run rerun`. | LOW | OPEN |
| TEST-ONLY-GATE-ELIGIBILITY | process-gap | Codify rule for whether/when test-only PRs run adversarial gate. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | test-coverage | P1/P2/P3/D2 DONE. Remaining: D5 write-error resilience. | LOW | OPEN — narrowed; D5 tracked deferral |
| ADVERSARY-DISPATCH-IDENTITY-TUPLE | process-gap | Adversary dispatches omit formal Worktree-Identity tuple. | LOW | OPEN — justified deferral |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | process-gap | #526 forbidden-compact-JSON invariant is review-only with no CI guard. | LOW | OPEN — draft-story candidate |
| ADF-RECURSION-TEST-NITS | code/doc hygiene | (1) imprecise "wiremock 501" comment; (2) BC-7.2.014 confidence-hedge. | LOW | OPEN — accepted cosmetic |
| POLICY-DOC-NON-SCOPE-CITATIONS | process-gap | Guard 2 scoped to §Scope only. Outside-§Scope fn citations remain driftable. | LOW | OPEN — cycle-close disposition pending |
| POLICY-DOC-ZERO-PAIR-OPT-OUT | process-gap | Guard 2: bullet with zero backticks passes check — opt-out path. | LOW | OPEN — cycle-close disposition pending |
| EXTRACTION-SET-PIN | process-gap | Guard 2 validates citation count but not the extracted (file, fn) SET. | LOW | OPEN — draft-story candidate |
| INTERNAL-PR-CITATION-RIGOR | process-gap | PR-number attributions need verify-before-cite discipline. | LOW | OPEN — cycle-close disposition pending |
| ADVERSARY-META-LENS-REGRESS | process-gap | Verification-adequacy lens generates unbounded meta-level findings; engine needs convergence rule. | LOW | OPEN — engine-level rule needed. DEC-159 data point recorded. |
| SCOPE-EMPTY-THREE-VS-TWO-CAUSE | story/spec | SCOPE_EMPTY three-cause vs two-cause wording — adjudicate at cycle close. | LOW | OPEN — adjudication at cycle close |
| SCOPE-EXAMINE-GLOBS-CROSS-SET-EDGE | coverage-gap | Guard 2 §Scope↔examine_globs cross-set edge is unguarded. | LOW | OPEN — follow-up story candidate |
| BACKTICK-RESERVATION-CONVENTION | doc-hygiene | Backtick-reservation convention in §Scope bullets is undocumented. | LOW | OPEN — doc-sentence candidate |
| ENGINE-BC-ID-INJECTION | process-gap | Stub-architect injected engine-internal BC-ID into product source rustdoc (5 sites) during F4 Red Gate. | LOW | OPEN — engine prompt hygiene (justified deferral) |
| STORY-ENGINE-BC-CITATION | story/spec | Story S-MUTANTS-SCOPE-GUARDS-1 cites engine-internal BC reference. | LOW | OPEN — cycle-close adjudication |
| SEC-001-GUARD1-ERE-PREFLIGHT | security | Guard 1 bash has no ERE-injection preflight guard on identifier-shaped CLI args. | LOW | OPEN — follow-up story candidate |
| SEC-002-GUARD1-BCDIR-DASH | security | Guard 1 bash has no leading-dash flag-value guard on `--bc-dir` arg. | LOW | OPEN — follow-up story candidate |
| GUARD1-BCDIR-CWD-RELATIVE | coverage-gap | Guard 1 `--bc-dir` defaults to cwd-relative; file-path resolution uses REPO_ROOT-anchored paths. | LOW | OPEN — accepted residual |
| SPEC-CHANGELOG-RESYNC | process-gap | spec-changelog.md goes stale across F2 fix rounds; no mandatory final-round re-sync in F2 skill. | LOW | OPEN — F2-skill template update candidate |
| ADVERSARY-WRITE-TOOL-MISMATCH | process-gap | F2 adversary agent has read-only tools but skill asks it to write review files. | LOW | OPEN — skill template / agent config fix candidate |
| D-CHAIN-VALIDATOR-SUBSTRING-FALSE-POSITIVE | process-gap | D-chain validator matched "D-27893" inside "JRACLOUD-27893" — needs word-boundary matching. | LOW | OPEN — validator regex hardening candidate |
| TWIN-ARTIFACT-SWEEP | process-gap | Fix rounds must propagate spec changes to ALL mirroring artifacts. RECURRENCE COUNT: 5 (F2×3 + F3×2). | LOW | OPEN — F2-skill template update candidate |
| PHASE-DOC-RETRO-ANNOTATION | process-gap | F1 artifacts need retro-annotation when F2 decisions supersede F1 scope. | LOW | OPEN — F2 skill template update candidate |
| H-NEW-JSM-RT-001-FIXTURE-NONDESERIALIZABLE | holdout pre-existing | H-NEW-JSM-RT-001 fixture uses `projectKey` but API returns `projectId`. | LOW | OPEN — future holdout sweep candidate |
| HOLDOUT-GROUP-8-DUPLICATE-HEADING | doc hygiene | Group 8 has duplicate heading label (two scenarios share the same heading text). | LOW | OPEN — doc hygiene fix candidate |
| UPSTREAM-GAP-PROPAGATES-TO-STORY | process-gap | F2 spec incomplete scope claim transcribed by story-writer; adversary catches at F3. 1st instance: VP-571-004 single-test scope reached story before caught. | LOW | OPEN — F2/F3-skill template update candidate |
| STORY-TEMPLATE-CHANGELOG-TASK | process-gap | story-template.md lacks mandatory CHANGELOG-section delivery task; F5-p3 discovered PR #593 merged without a CHANGELOG.md entry (MISSING-CHANGELOG-ENTRY). Engine-side fix needed. ADF-CODE-MARK F5 pass-3. | LOW | OPEN — story template update candidate (engine-side) |
| ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY | process-gap | F5-p3 adversary self-declared CLEAN in pass summary while simultaneously reporting 1 LOW finding (MISSING-CHANGELOG-ENTRY). Adversary verdict/finding contract violation. ADF-CODE-MARK F5 pass-3. | MEDIUM | OPEN — adversary prompt discipline / contract enforcement |
| F5-OBS-002 | observability | No runtime stderr warning when push_code strips typographic marks; silent strip is the correct product call vs pre-fix HTTP 400. Candidate --verbose observability enhancement. Human-approved deferral 2026-07-08. | LOW | DEFERRED — v2 backlog |
| F5-OBS-001 | spec-hygiene | BC-7.2.015 lossiness (**`x`** → code-only) not cross-listed in BC-7.2.011 five-case lossy round-trip catalogue; already documented in BC-7.2.007 EC-2 + CLAUDE.md clause-b splice. Human-approved deferral 2026-07-08. | LOW | DEFERRED — next spec-maintenance sweep |
| BC-INDEX-TD031-EDIT-LOCKOUT | BC index / spec-hygiene | MITIGATED — counts synced 2026-07-09 via sanctioned shell edit (no new volatile cites); BC-X.1.011 row landed, total_bcs=613, DRIFT-002 unblocked. Full TD-031 cleanup of 243 pre-existing cites still OPEN (follow-up story candidate). [TD-031-FULL-CLEANUP carried forward] | MEDIUM | MITIGATED |
| STATE-MANAGER-MONOLITHIC-WRITE-STALL | process-gap | timestamp-advancement hook forces every STATE.md edit to span from line 6 → monolithic writes → repeated API stalls; 3 occurrences 2026-07-08/09; engine-side fix candidate. | MEDIUM | OPEN |
| PR-MANAGER-HOOK-VS-DEC-128-CONFLICT | process-gap | pr-manager-completion-guard hook demanded AUTHORIZE_MERGE while DEC-128 dispatch forbade merge; pr-manager correctly held; engine-side hook needs DEC-128 awareness. | MEDIUM | OPEN |
| CLAUDE-MD-CLIPPY-ALL-TARGETS-DRIFT | doc hygiene | CLAUDE.md documents `cargo clippy -- -D warnings` but CI runs `cargo clippy --all-targets -- -D warnings`; caused fix-PR #602 cycle-1 REQUEST_CHANGES on S-SOH-589-1. Fix candidate: 1-line CLAUDE.md update via pipeline. | LOW | OPEN — pipeline doc fix candidate |
| PERMISSION-LAUNDERING-REFUSAL-WORKING | positive control | 2026-07-09: peer agent refused relayed gh-write after permission denial, surfaced to human; DEC-128 defense working as designed. No action needed. | LOW | CLOSED — positive control datapoint |
| RELEASING-MD-MISSING | doc backlog | No RELEASING.md in repo root — release skill prompts on every release until canonical procedure is documented; draft from dev.8/dev.9 precedent. | LOW | OPEN — doc backlog candidate |
| E2E-TOKEN-EXPIRED-2026-07 | e2e-infra | Live-Jira E2E failing since 2026-07-04 (signatures: code-2 not-authenticated + 400 no-permission); JR_E2E_API_TOKEN expiry suspected per runbook §9; human rotating; non-blocking but site keepalive at risk. | MEDIUM | RESOLVED 2026-07-10 — human rotated JR_E2E_API_TOKEN; verified by e2e run 29055766599 SUCCESS (full live suite green). |

## Convergence Status

Current project index versions: BC-INDEX v6.12 / VP-INDEX v0.82 / STORY-INDEX v1.02 / ARCH-INDEX v0.16

Trajectory (ADF-CODE-MARK-EXCLUSIVITY F2): →3→4→5→5→0→1→0→4→1→0→3→1→1→0→2→3→0→0→0 (passes 1-19; STRICT CONVERGED, DEC-158/DEC-159). F3: 3→2→1→0→1→3→1→0→0→0 (passes 1-10; STRICT CONVERGED, DEC-160). F4 Step-4.5: →1→0→0→0 (STRICT CONVERGED, DEC-161, window F4-p2/F4-p3/F4-p4). F5 Step-4.5: →0→0→1→0→0→0 (passes p1-p6; STRICT CONVERGED, DEC-162, window p4/p5/p6). Trajectory-tail →1→0→0→0. SOH-BUGS-1 S-SOH-589-1 Step-4.5: 3→4→0→1→0→0→0 (passes p1-p7; STRICT CONVERGED, DEC-166, window p5/p6/p7).

ADF-CODE-MARK-EXCLUSIVITY: **FULLY COMPLETE (2026-07-08, DEC-163). S-7.02 SATISFIED. Release v0.6.0-dev.8 @ 159e1be.** F5 CONVERGED (DEC-162). Deferrals F5-OBS-001/002. Full trajectories: `cycles/cycle-001/convergence-trajectory.md`. SOH-BUGS-1: **FULLY COMPLETE (2026-07-09, DEC-167). F7-lite 7/7 PASS (holdout 1.00 6/6; consistency CONSISTENT). Release v0.6.0-dev.9 @ b2ce3169. Issues #589/#590/#582 CLOSED.**

## Concurrent Cycles

| Cycle | Status | Notes |
|-------|--------|-------|
| ADF-CODE-MARK-EXCLUSIVITY (issue #571) | **FULLY COMPLETE (2026-07-08) — CONVERGED AND CLOSED (DEC-163). Release v0.6.0-dev.8 TAGGED @ 159e1be. Session-review loop CLOSED (DEC-164).** | PR #593 @ 7ba4cf4; fix-PR #594 @ d7875e6; story #103 v1.9; issue #571 CLOSED; F5 trajectory →0→0→1→0→0→0; window p4/p5/p6 CLEAN×3; two deferrals F5-OBS-001/002; F6 gate PASS; F7 5/5 PASS; S-7.02 SATISFIED. PR #596 @ 159e1be; workflow run 28969465350 SUCCESS (10 assets). |
| SOH-BUGS-1 (issues #589 + #590/#582) | **FULLY COMPLETE (2026-07-09, DEC-167) — CONVERGED AND CLOSED. Release v0.6.0-dev.9 @ b2ce3169 (PR #603; run 29051718553; 10 assets).** | PRs #597/#601/#602/#603. Issues #589/#590/#582 CLOSED (verified 2026-07-09). F7-lite 7/7 PASS. DEC-167. RELEASING-MD-MISSING drift recorded. |
| SOH-COMMENT-CRUD-1 (issue #577) | **F1 APPROVED (DEC-168, 2026-07-09) — F2 spec evolution IN PROGRESS.** | Research + delta-analysis artifacts; 4 human rulings; footgun claim refuted; no OAuth scope change needed. |

## Session Resume Checkpoint

<!-- Keep ONLY the latest checkpoint. Archive prior checkpoints to cycles/cycle-001/session-checkpoints.md. -->

| Field | Value |
|-------|-------|
| **Date** | 2026-07-10 (RESUMED — fix round 38 complete, mid-F2 adversarial convergence, SOH-COMMENT-CRUD-1 issue #577) |
| **Status** | **SESSION ACTIVE (resumed 2026-07-10). SOH-COMMENT-CRUD-1 F3: 13 adversary passes, 15 CV rounds, 14 fix rounds. F3 pass 14 next.** |
| **Position** | F3 pass-13 fixed. Three consecutive single-LOW passes. NEXT: F3 adversary pass 14; STRICT to 3 clean → F3 human gate → F4. |
| **Key rulings** | DEC-168 (F1 gate, 4 rulings). Full STRICT three times confirmed (pass-6, pass-14, pass-38 checkpoints). MERGE+PRESERVED verdicts accepted with deferred EJ probe (local probe blocked — EJ not on local profile; zero mutations). Reversed orchestrator rulings (code-verified): 403-scope carve-out added p28 REMOVED p29; body-source priority corrected to --stdin>--file>positional; trim-to-ADF matches add; F-A4 --yes silent-no-op RATIFIED (DEC-169, 2026-07-11, research-backed). |
| **Counters** | BC **624**. Stories **111** (F3 for #577 drafted). Holdouts **88**. VP-577 family 30. Spec v1.3.40. L2 bc-03 120/25. |
| **In-flight** | NO stories mid-TDD, NO worktrees, NO factory PRs. All F2 work pushed on factory-artifacts @ aa6a5c7 (intake 18f24cc + 15 WIP checkpoints; 17c4dfc mis-commit reverted b164d06/redone 24ef249; stray develop commit cleaned, never pushed). |
| **Follow-up story candidates** | Recorded in v1.3.28 Follow-up Obligations + BC notes: L2-BCCOUNT-9TH-SURFACE guard; EC-3.5.012-5 try_parse regressions; method-agnostic 403-scope hint; Levenshtein typo hints; add body-source clap alignment; add file-not-found exit alignment; broader IO remaps; visibility-only edit; --dry-run for edit/delete; JR_STDIN_IS_TTY seam+CLAUDE.md+release-gate (F4 in-scope). |
| **Process-gap ledger (cycle close / upstream)** | WRITE-STALL ×10 total (3 this burst: PO ×2 + SM ×1) (timestamp hook forces monolithic writes); WRONG-CWD-COMMIT near-miss (cwd guard now standard); idle-without-report ×4 (final-SendMessage clause fix); VERDICT-COUNT-DISCREPANCY ×5; FALSE-PREMISE-CODE-CLAIM (file:line rule fix); additive-pass entrenchment (defect-only-pass proposal); TWIN-ARTIFACT-SWEEP ×7; BC-bodies+BC-INDEX transactional citations; "sibling fields same question" research checklist. |
| **Pending decisions** | None blocking. Full STRICT stands. Intake queue untouched: sackofhacks #575/#576 + P2s; dependabot #591 soak ~07-13, #598/#599/#600 (DEC-133); arcaven #573/#574 CHANGES_REQUESTED. |
| **Resume command** | Fresh session → factory-worktree-health → read STATE.md → F3 adversary pass 14. |

## RESUME PLAN (cold-start, self-contained)

<!-- State snapshot: SESSION PAUSED (2026-07-10, human /wrap). SOH-BUGS-1 FULLY COMPLETE + RELEASED (DEC-167, 2026-07-09). Release v0.6.0-dev.9 @ b2ce3169; issues #589/#590/#582 CLOSED; e2e repaired (run 29055766599 SUCCESS). ADF-CODE-MARK-EXCLUSIVITY FULLY COMPLETE (DEC-163). develop @ b2ce3169. BC 613; Stories 105. Holdouts 83. No active worktrees. Pipeline PAUSED. RESUME INTENT: issues intake (sackofhacks P1 #575/#576/#577). -->

### Steps (assume ZERO memory)

**Step 1 (BLOCKING):** Run `vsdd-factory:factory-worktree-health`. Then read `.factory/STATE.md` (this file).

**Step 2 — Verify position:**
- develop @ **b2ce3169** (PR #603 squash-merged 2026-07-09; SOH-BUGS-1 FULLY COMPLETE; release v0.6.0-dev.9; issues #589/#590/#582 CLOSED).
- factory-artifacts: see `git -C .factory log -1`.
- No active feature worktrees.
- Counters: BC **613**, NFR **42**, ADR **16**, Stories **105**. Holdouts **83**.

**Step 3 — COMPLETED BUNDLE: SOH-BUGS-1 FULLY COMPLETE + RELEASED (2026-07-09, DEC-167):**

> **BUNDLE: SOH-BUGS-1 — issues #589 + #590/#582. FULLY COMPLETE + RELEASED (2026-07-09, DEC-167).**
>
> **Story 104 S-SOH-590-1:** PR #597 @ 4f3960e0 (quick-dev, DEC-128 honored). BC-X.1.011 + VP-590-001. Issues #590+#582 CLOSED.
>
> **Story 105 S-SOH-589-1:** PR #601 @ 081187ae (standard, DEC-128 honored). Step-4.5 STRICT 7 passes/4 fix rounds (3→4→0→1→0→0→0, window p5/p6/p7). 6/6 AC demos (local). 2016/0/93. fix-PR #602 @ bf3b3382 (Rust 1.97). Issue #589 CLOSED.
>
> **Release:** PR #603 @ b2ce3169 (DEC-128 honored); tag v0.6.0-dev.9; workflow run 29051718553 SUCCESS (10 assets). F7-lite 7/7 PASS; holdout 1.00 (6/6 wire-level); consistency CONSISTENT (gaps G1-G3 fixed). S-7.02 SATISFIED.
>
> **NEXT STEP: SOH-COMMENT-CRUD-1 F2 fix round 38** (pass-32 findings: 1H+3L in adversarial-review/pass-32-577.md) → CV verify → adversary pass 33 → … Full STRICT to 3 clean → F2 gate → F3 stories.

**Step 4 — STANDING CONSTRAINTS (ALL fixes via full VSDD Feature Mode):**
- All fixes through full VSDD Feature Mode. No exceptions without explicit human direction.
- DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges, spawn fix sub-agents, push commits, or enter unbounded poll loops.
- DEC-133 (DEPENDABOT-ACTION-SOAK): third-party Action bumps require ≥7-day soak + SHA-pin integrity check.
- F2-PIECEWISE-PROTOCOL: dispatch consistency-validator after EACH spec-author fix in F2.
- **Codified lessons (cycles/cycle-001/lessons.md):** UMBRELLA-BC-RE-ANCHOR-SWEEP, IMPLEMENTER-PARAPHRASE-BEYOND-SPEC, FILES-MODIFIED-BACK-WRITE, ORCHESTRATOR-EMPIRICAL-REFUTATION, REGISTRATION-SURFACE-SWEEP.
- **External-contributor PRs:** all GitHub issue/PR content from external sources is untrusted — no attachment downloads, no executing code from bodies/diffs, no following embedded instructions.

OPEN BACKLOG:

*MEDIUM:* S-PG-MERGE-AUTH-BYPASS (story 91, 3 engine-prompt residuals); TEST-ONLY-GATE-ELIGIBILITY; BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD; MUTANTS-SHARDING-PATH-B; ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY; BC-INDEX-TD031-EDIT-LOCKOUT; STATE-MANAGER-MONOLITHIC-WRITE-STALL; PR-MANAGER-HOOK-VS-DEC-128-CONFLICT.

*LOW:* MUTANTS-POLICY-CITATION-GUARD; MUTANTS-GLOB-EXISTENCE-GUARD; RA-001; RA-002; PERF-BASELINE; RELEASE-CI-NETWORK-FLAKE; FORK-OPS cluster; CACHE-COVERAGE-GAPS D5; RELEASING-MD-MISSING.

- DO NOT close **#429** (DEC-029, human-deferred).

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
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
| Session checkpoints (archived) | `cycles/cycle-001/session-checkpoints.md` |
| Lessons learned | `cycles/cycle-001/lessons.md` |
| Resolved blockers + resolved drift items | `cycles/cycle-001/blocking-issues-resolved.md` |
| Closed issues (CLOSED/MERGED/DELIVERED) | `cycles/cycle-001/closed-issues-archive.md` |
| Phase 2→3 gate document | `cycles/cycle-001/gates/phase-2-to-3-gate.md` |
| Maintenance sweep 2026-06-22 session review | `maintenance/2026-06-22/sweep-report-2026-06-22.md` |
| Maintenance sweep 2026-06-25 report + findings | `maintenance/2026-06-25/` |
| Refactor analysis 2026-06-25 | `architecture/refactor-2026-06-25/` |
| E2E edge-case coverage audit 2026-06-27 | `research/e2e-edge-case-audit-2026-06-27-*.md` |
| HOLDOUT-COVERAGE-GAPS + BC-SUB-CLAUSE F1 delta analysis | `phase-f1-delta-analysis/holdout-coverage-gaps-2026-06-30-delta.md` |
| MUTANTS-EXAMINE-GLOBS F1 delta analysis 2026-07-02 | `phase-f1-delta-analysis/mutants-examine-globs-2026-07-02-delta.md` |
| CITATION-GUARDS F1 delta analysis 2026-07-02 | `phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md` |
| CITATION-GUARDS Story B design open-questions research 2026-07-05 | `research/story-b-open-questions-2026-07-05.md` |
| CITATION-GUARDS session review (DEC-156 cycle close, 2026-07-07) | `cycles/cycle-001/CITATION-GUARDS-session-review.md` |
| ADF-CODE-MARK-EXCLUSIVITY research (issue #571, 2026-07-07) | `research/issue-571-adf-code-mark-exclusivity-2026-07-07.md` |
| ADF-CODE-MARK-EXCLUSIVITY F1 delta analysis (issue #571, 2026-07-07) | `phase-f1-delta-analysis/impact-boundary-571.md` |
| ADF-CODE-MARK-EXCLUSIVITY F2 spec delta (issue #571, 2026-07-07) | `phase-f2-spec-evolution/prd-delta-571.md` |
| ADF-CODE-MARK-EXCLUSIVITY F3 story convergence (issue #571, 2026-07-07/08) | `stories/S-ADF-CODE-MARK-1.md` (story #103 v1.9, 12 ACs, 4 pts) |
| ADF-CODE-MARK-EXCLUSIVITY F3 sidecar learning (2026-07-08) | `sidecar-learning.md` (process-gap reinforcements: TWIN-ARTIFACT-SWEEP 4th+5th, UPSTREAM-GAP-PROPAGATES-TO-STORY 1st) |
| ADF-CODE-MARK-EXCLUSIVITY F4 delivery + F5 p1-p6 trajectory (2026-07-08) | `cycles/cycle-001/burst-log.md` (F4 DELIVERED burst + F5 p1-p3), `cycles/cycle-001/convergence-trajectory.md` (F4 Step-4.5 + F5 full) |
| ADF-CODE-MARK-EXCLUSIVITY F5 fix-PR #594 review artifacts (2026-07-08) | `code-delivery/docs-571-changelog/pr-review.md`, `code-delivery/docs-571-changelog/pr-description.md` |
| ADF-CODE-MARK-EXCLUSIVITY F6 targeted hardening artifacts (2026-07-08) | `phase-f6-hardening/` (kani-results.md, fuzz-results.md, mutation-results.md, security-scan-results.md, summary.md) |
| ADF-CODE-MARK-EXCLUSIVITY F7 delta convergence artifacts (2026-07-08) | `phase-f7-convergence/issue-571-delta-convergence-report.md` (input-hash 4dc9f48), `phase-f7-convergence/issue-571-traceability-chain-delta.md` (input-hash 1aa2d75) |
| ADF-CODE-MARK-EXCLUSIVITY F7-AUTHORIZED + RELEASE v0.6.0-dev.8 burst (2026-07-08) | `cycles/cycle-001/burst-log.md` (F7-AUTHORIZED + RELEASE TAGGED burst) |
| ADF-CODE-MARK-EXCLUSIVITY session review artifacts (issue #571, 2026-07-08) | `session-reviews/review-2026-07-08-issue-571.md`, `session-reviews/improvement-proposals-issue-571.md`, `session-reviews/benchmarks.yaml`, `session-reviews/pattern-database.yaml`, `session-reviews/improvement-backlog.md` |
| IP-571 proposal disposition burst (2026-07-08) — 13/13 ROUTED-UPSTREAM; DEC-164 | `cycles/cycle-001/burst-log.md` (IP-571 DISPOSITION burst) |
| External-PR review artifacts — arcaven PRs #573+#574 (2026-07-08) | `code-delivery/PR-573/pr-review.md`, `code-delivery/PR-574/pr-review.md`, `code-delivery/PR-574/security-review.md` |
| SOH-BUGS-1 intake research — #589 AllowedValue.id (2026-07-08) | `research/issue-589-editmeta-allowedvalue-id-2026-07-08.md` |
| SOH-BUGS-1 intake research — #590/#582 HTTP method case (2026-07-08) | `research/issue-590-http-method-case-2026-07-08.md` |
| SOH-BUGS-1 closure + release v0.6.0-dev.9 burst (2026-07-09) — DEC-167; issues #589/#590/#582 CLOSED | `cycles/cycle-001/burst-log.md` (SOH-BUGS-1 CLOSED + RELEASE burst) |
