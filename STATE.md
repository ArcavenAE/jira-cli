---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-07-26T12:32:00Z
phase: 3
pipeline: Feature Mode SOH-DX-1 ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "SOH-DX-1 F2 ADVERSARY GRIND IN PROGRESS (2026-07-26): 11 rounds complete (pass-1 8F 4H/4M → fix-1 → pass-2 8F 2H/4M/2L → fix-2 → pass-3 8F 2H/5M/1L → fix-3 → pass-4 7F 2H/3M/2L → fix-4 → pass-5 6F 2H/4M → fix-5 → pass-6 4F 1H/3M → fix-6 → pass-7 3F 1H/2M → fix-7 → pass-8 7F 0H/3M/4L severity-collapsing → fix-8 → pass-9 6F 1H/4M/1L → fix-9 → pass-10 5F 0H/4M/1L piecewise CLEAN → fix-10 → pass-11 6F 2H/4M REGRESSION → fix-11); fix-11: reporter-claim siblings trimmed/hedged (citation discipline); AC-12 dual per-flag assertions; item-(d) first-line-only replacement; vacuity rationale asymmetry stated; AC-17..19 (EC-5/-7/-9 coverage; surface AC-1..19); BC-3.4.014 index qualifier; [1.3.107] Type MINOR→PATCH; spec v1.3.109 + changelog [1.3.109]; piecewise CLEAN. 3 guards green. 5th process-gap: no changelog Type↔version-component guard. ZERO consecutive CLEAN; need 3 STRICT. NEXT: pass-12. D-chain cite D-27893 latest brownfield. trajectory-tail →7→6→5→6."
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: SOH-DX-1-F2-ADVERSARY-GRIND
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEAN×3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
activation_head: "7b3ba371"
activation_version: "v0.6.0-dev.11"
---

<!--
STATE.md SIZE BUDGET (2026-07-26 update: SOH-DX-1 F2 ADVERSARY GRIND ROUND 11):
236 lines (wc-l) — soft-target 200 lines, hard cap 500 lines.
margin from soft-target: 36 lines over soft-target (compact further if possible).
margin from actual: 264 lines remaining to hard cap.
Hard cap: 500 lines. Prior: 235 lines. Net delta: +1 line (PP row rotated: pass-6-adversary archived, pass-11-adversary added; CPS row rotated: pass-7-adversary archived, pass-11-adversary added; all 5 trajectory-tail sites updated; PG-005 drift item added).
-->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Last Updated** | 2026-07-26: SOH-DX-1 F2 ADVERSARY GRIND — 11 rounds complete (pass-1 8F→pass-2 8F→pass-3 8F→pass-4 7F→pass-5 6F→pass-6 4F→pass-7 3F→pass-8 7F 0H/3M/4L severity-collapsing→pass-9 6F 1H/4M/1L→pass-10 5F 0H/4M/1L→pass-11 6F 2H/4M REGRESSION; fix-11: reporter-claim siblings trimmed/hedged; AC-12 dual per-flag; item-(d) all occurrences; vacuity rationale; AC-17..19; BC-3.4.014 qualifier; [1.3.107] MINOR→PATCH; spec v1.3.109 [1.3.109]; piecewise CLEAN; 3 guards green; PG-005). ZERO consecutive CLEAN; need 3 STRICT. NEXT: pass-12. trajectory-tail →7→6→5→6. Prior: rounds 1-10 complete; 31+ findings fixed; spec-changelog [1.3.108]; STORY-INDEX v1.5.41; 4 process-gaps. trajectory-tail →3→7→6→5 |
| **Current Phase** | Feature Mode SOH-DX-1 ACTIVE — F2 ADVERSARY GRIND IN PROGRESS (2026-07-26). Rounds 1-11 complete; trajectory 8→8→8→7→6→4→3→7→6→5→6; count regression 5→6 (pass-10→pass-11, 2H/4M). ZERO consecutive CLEAN passes (need 3 STRICT per DEC-189). NEXT: pass-12 → continue grind → human gate after STRICT convergence. |
| **Next Phase** | F2 adversary convergence (3-clean-pass STRICT minimum per DEC-189) → F2 human gate → F3 story decomposition. #645 soaking until 2026-07-27 (DEC-187). ENGINE IPs (5) queued for vsdd-factory after this cycle. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; FIX-E2E-EGRESS DELIVERED; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived rows ledger: see cycles/cycle-001/burst-log.md (2026-07-25 compaction + SOH-DX-1 F1 burst: archived pass-14 adversary row + SOH-DX-1 F2-AUTHORED burst: archived F6 hardening row; F2-ADVERSARY-ROUNDS-1-4 burst: archived F5-fix-burst summary row; D-447(d) fix-burst row re-instated; F2-ADVERSARY-ROUND-5 burst: archived F7-CONVERGENCE-APPROVED row; F2-ADVERSARY-ROUND-6 burst: archived SOH-ATTACHMENTS-1-CYCLE-CLOSED row; F2-ADVERSARY-ROUND-7 burst: archived SOH-DX-1-F1-APPROVED row; F2-ADVERSARY-ROUND-8 burst: archived SOH-DX-1 F2-AUTHORING-COMPLETE row; F2-ADVERSARY-ROUND-9 burst: archived pass-4 adversary row; F2-ADVERSARY-ROUND-10 burst: archived pass-5 adversary row; F2-ADVERSARY-ROUND-11 burst: archived pass-6 adversary row — see burst-log.md) -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **pass-7 adversary — SOH-DX-1 F2 fix burst round 7 complete (2026-07-25): 3 findings (1H/2M) + 1 [process-gap]; HIGH: F7-1 CMDB call misplaced in ordering block (post-POST/JSON-only; create.rs:239 — ordering corrected; AC-8 expect(0) set honest); MEDs: F7-2 EC-3.8.012-8 clap exit-2 precedence added; F7-3 AC-10/Test Notes → parse-stderr-as-JSON (tests/json_error_shape.rs convention); 4th process-gap SOH-DX-1-PG-004: no CI pin on help-text semantics for flags with exit-code contracts; fix-7 piecewise CLEAN, 3 guards green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-8.** | F2 adversary grind in progress | 2026-07-25 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.107; BC-INDEX v6.45; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3 |
| **pass-8 adversary — SOH-DX-1 F2 fix burst round 8 complete (2026-07-25): 7 findings (0C/0H/3M/4L — severity collapsing; count regression 3→7 but zero HIGH/CRIT); fixes: helper promotion tests/common/fixtures.rs (cross-binary directive unbuildable); AC-9 cwd isolation (find_project_config walk-up); Platform-Path Guard Ordering SSOT + BC placement text collapsed to block refs; changelog EC 1..8 + AC-11; stdout-empty postconditions + AC-1 stdout inversion + json no-prefix scoping; AC-11 TTY-seam test; BC-3.8.013 AC-3 cross-ref; 2 residuals (fn citation, changelog AC-11) fixed piecewise; 3 guard scripts green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-9.** | F2 adversary grind in progress | 2026-07-25 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.107; BC-INDEX v6.45; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7 |
| **pass-9 adversary — SOH-DX-1 F2 fix burst round 9 complete (2026-07-26): 6 findings (1H/4M/1L); fixes: AC-5 anchored (substring each-run before byte-identity — false-green closed); SSOT off-by-one + phantom description prompt fixed; AC-10 helper location reconciled + realizability notes; deliverable phasing reconciled (S-639-1 delivery F4 — same PR; F3 checklist) + AC-12 help-language pin; AC-13..16 EC coverage added; EC-3.8.012-9 added; BC-3.8.013 Trace +AC-4/AC-16; changelog [1.3.107] current-state totals (AC-1..16, EC 1..9 + 013-1); 1 tracking note resolved in-round; piecewise CLEAN; 3 guard scripts green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-10.** | F2 adversary grind in progress | 2026-07-26 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.107; BC-INDEX v6.45; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7→6 |
| **pass-10 adversary — SOH-DX-1 F2 fix burst round 10 complete (2026-07-26): 5 findings (0H/4M/1L); fixes: ADR-0014 third stale site (:73-76) enumerated; AC-12 renamed + pinned to verbatim 'requires --request-type' help text; false reporter-edit parenthetical dropped from 013 error string (citation discipline); AC namespace note (S-639-1 targets supersede S-383 same-numbered ACs); helper promotion completed (DELETE + re-import 3 call sites); piecewise 1 finding (version-bump convention) → spec bumped v1.3.108 (2026-07-26) PATCH entry; BC-INDEX last_updated; 3 guard scripts green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-11.** | F2 adversary grind in progress | 2026-07-26 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.108; BC-INDEX v6.45; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7→6→5 |
| **pass-11 adversary — SOH-DX-1 F2 fix burst round 11 complete (2026-07-26): 6 findings (2H/4M) + 1 [process-gap] REGRESSION (5→6); HIGHs: reporter-claim siblings not trimmed/hedged (citation discipline); vacuity rationale asymmetry (stated for some ACs but not others); MEDs: AC-12 dual per-flag assertions rewritten; item-(d) first-line-only replacement corrected (all occurrences); AC-17..19 added (EC-5/-7/-9 coverage; surface AC-1..19); BC-3.4.014 index qualifier; [1.3.107] Type MINOR→PATCH corrected; spec v1.3.109 + changelog [1.3.109]; PG-005: no changelog Type↔version-component guard (5th process-gap); piecewise CLEAN; 3 guard scripts green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-12.** | F2 adversary grind in progress | 2026-07-26 | ADVERSARY GRIND — convergence + human gate PENDING. | spec v1.3.109; BC-INDEX v6.45; STORY-INDEX v1.5.41. | →8→8→8→7→6→4→3→7→6→5→6 |

## Current Phase Steps

<!-- Keep last 4 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived rows ledger: see cycles/cycle-001/burst-log.md (2026-07-25 compaction + SOH-DX-1 F1 burst: archived F7-delta-convergence CPS row + SOH-DX-1 F2-AUTHORED burst: archived SOH-ATTACHMENTS-1 CYCLE-CLOSE WRAP CPS row + F2-ADVERSARY-ROUNDS-1-4 burst: archived DEPENDABOT-TRIAGE CPS row + F2-ADVERSARY-ROUND-5 burst: archived DEPENDABOT-MERGES-COMPLETE CPS row + F2-ADVERSARY-ROUND-6 burst: archived SOH-DX-1 F1 APPROVED CPS row + F2-ADVERSARY-ROUND-7 burst: archived SOH-DX-1 F2 AUTHORING COMPLETE CPS row + F2-ADVERSARY-ROUND-8 burst: archived pass-4 adversary CPS row + F2-ADVERSARY-ROUND-9 burst: archived pass-5 adversary CPS row + F2-ADVERSARY-ROUND-10 burst: archived pass-6 adversary CPS row + F2-ADVERSARY-ROUND-11 burst: archived pass-7 adversary CPS row) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **pass-8 adversary — SOH-DX-1 F2 round 8 complete (2026-07-25): 7 findings (0C/0H/3M/4L; severity collapsing; count regression 3→7 but zero HIGH/CRIT); fixes: helper promotion tests/common/fixtures.rs (cross-binary unbuildable directive removed); AC-9 cwd isolation (find_project_config walk-up); Platform-Path Guard Ordering SSOT declaration + BC placement text collapsed to block refs; changelog EC 1..8 + AC-11 enumeration; stdout-empty postconditions + AC-1 stdout inversion + json no-prefix scoping; AC-11 TTY-seam test pin; BC-3.8.013 AC-3 cross-ref added; 2 piecewise residuals (fn citation + changelog AC-11) fixed; 3 guard scripts green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-9.** | adversary (×8) + product-owner (×8) + consistency-validator (×8) + state-manager | IN PROGRESS — F2 adversary grind | spec v1.3.107; BC-INDEX v6.45; STORY-INDEX v1.5.41; convergence-trajectory p85 appended; burst-log.md appended; factory-artifacts committed. |
| **pass-9 adversary — SOH-DX-1 F2 round 9 complete (2026-07-26): 6 findings (1H/4M/1L); fixes: AC-5 anchored (substring each-run before byte-identity — false-green closed); SSOT off-by-one + phantom description prompt; AC-10 helper location reconciled + realizability notes; deliverable phasing reconciled (S-639-1 delivery F4 — same PR; F3 checklist) + AC-12 help-language pin; AC-13..16 EC coverage; EC-3.8.012-9; BC-3.8.013 Trace +AC-4/AC-16; changelog [1.3.107] current-state totals (AC-1..16, EC 1..9 + 013-1); 1 tracking note resolved in-round; piecewise CLEAN; 3 guard scripts green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-10.** | adversary (×9) + product-owner (×9) + consistency-validator (×9) + state-manager | IN PROGRESS — F2 adversary grind | spec v1.3.107; BC-INDEX v6.45; STORY-INDEX v1.5.41; convergence-trajectory p86 appended; burst-log.md appended; factory-artifacts committed. |
| **pass-10 adversary — SOH-DX-1 F2 round 10 complete (2026-07-26): 5 findings (0H/4M/1L); fixes: ADR-0014 third stale site (:73-76) enumerated; AC-12 renamed + pinned to verbatim 'requires --request-type' help text; false reporter-edit parenthetical dropped from 013 error string (citation discipline); AC namespace note (S-639-1 targets supersede S-383 same-numbered ACs); helper promotion completed (DELETE + re-import 3 call sites); spec v1.3.108 (version-bump convention PATCH entry); BC-INDEX last_updated; 3 guard scripts green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-11.** | adversary (×10) + product-owner (×10) + consistency-validator (×10) + state-manager | IN PROGRESS — F2 adversary grind | spec v1.3.108; BC-INDEX v6.45; STORY-INDEX v1.5.41; convergence-trajectory p87 appended; burst-log.md appended; factory-artifacts committed. |
| **pass-11 adversary — SOH-DX-1 F2 round 11 complete (2026-07-26): 6 findings (2H/4M) + 1 [process-gap] REGRESSION (5→6); HIGHs: reporter-claim siblings (citation discipline); vacuity rationale asymmetry; MEDs: AC-12 dual per-flag; item-(d) all occurrences; AC-17..19 (EC-5/-7/-9; surface AC-1..19); BC-3.4.014 qualifier; [1.3.107] MINOR→PATCH; spec v1.3.109 [1.3.109]; PG-005 (5th process-gap); piecewise CLEAN; 3 guard scripts green. ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-12.** | adversary (×11) + product-owner (×11) + consistency-validator (×11) + state-manager | IN PROGRESS — F2 adversary grind | spec v1.3.109; BC-INDEX v6.45; STORY-INDEX v1.5.41; convergence-trajectory p88 appended; burst-log.md appended; factory-artifacts committed. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-155 | Phase 0/1/2/3 + Wave + Feature Mode + all prior cycles. All CYCLE CLOSED. | See cycles/cycle-001/burst-log.md | Phase 0 to 3 / 2026-05-04 to 2026-07-07 | archived |
| DEC-156 | CITATION-GUARDS CYCLE CLOSED — Story A (PR #572 @ ab78a2d) + Story B (PR #592 @ 0d8a8a5) both DELIVERED. Guard family complete (BC-X.13.001..006). 309 citations enforced in CI. | CITATION-GUARDS bundle complete — both stories delivered. | Feature Mode / CITATION-GUARDS | 2026-07-07 |
| DEC-157 | ADF-CODE-MARK-EXCLUSIVITY F1 gate approved 2026-07-07: 5-point scope ratified — emit-site filter in src/adf.rs::push_code; no node-splitting; apply_marks read-tolerance retained; BC-7.2.015 standalone; STANDARD criterion. | Human gate cleared; F2 dispatch authorized. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY | 2026-07-07 |
| DEC-158..DEC-163 | ADF-CODE-MARK-EXCLUSIVITY F2-F7: STRICT convergence, gate approvals, delivery PR #593 @ 7ba4cf4, fix-PR #594 @ d7875e6, F7 AUTHORIZED, release v0.6.0-dev.8 @ 159e1be. Cycle FULLY COMPLETE. | Human authorized all phases; bundle formally closed. | Feature Mode / ADF-CODE-MARK-EXCLUSIVITY | 2026-07-07 to 2026-07-08 |
| DEC-164 | SESSION-REVIEW IP-571 DISPOSITION (2026-07-08, human): all 13 proposals routed upstream to drbothen/vsdd-factory as 9 new issues (#576-#584) + 3 comments on existing issues. Dedupe survey performed first. | Human ruled all proposals belong in the factory engine repo, not jira-cli. | Post-cycle / session-review | 2026-07-08 |
| DEC-165..DEC-167 | SOH-BUGS-1: F1 gate approved; delivery PRs #597/#601/#602/#603; F7-lite 7/7 PASS; release v0.6.0-dev.9 @ b2ce3169 (run 29051718553). Issues #589/#590/#582 CLOSED. | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-BUGS-1 | 2026-07-09 |
| DEC-168..DEC-177 | SOH-COMMENT-CRUD-1: F1 gate approved; F2-F7 complete; 13 delivery PRs #610-#623; release v0.6.0-dev.10 @ 56d5126 (run 29385074375); S-7.02 SATISFIED; issue #577 CLOSED; 11 IP-577 proposals routed upstream. | Human closed all phases; bundle released; session review complete. | Feature Mode / SOH-COMMENT-CRUD-1 | 2026-07-09 to 2026-07-15 |
| DEC-178 | ALL-DEPENDABOT SOAK BROADENED (2026-07-15, human): 7-day soak extends to ALL dependabot PRs (cargo included), not just third-party Actions bumps — broadens DEC-133. Investigation verified 7-day supply-side cooldown enforced with 24h precision. | Human triage established cargo dependabot PRs carry the same soak requirement. | Steady-state burst / PR triage | 2026-07-15 |
| DEC-179..DEC-185 | SOH-ATTACHMENTS-1 F1-F3: F1 gate approved (issues #576+#585; 5 stories; security-reviewer REQUIRED); scope expansion + delete rulings (DEC-180); F2 gate approved at v1.3.79 (DEC-184); F3 gate approved at v1.3.94 (DEC-185). | Human gated all phases; security posture upgraded at F2 gate. | Feature Mode / SOH-ATTACHMENTS-1 | 2026-07-15 to 2026-07-19 |
| DEC-186 | SOH-ATTACHMENTS-1 F7 DELTA CONVERGENCE APPROVED (2026-07-25, human): 5-dim PASS (D1 fresh-context audit CLEAN 2 doc-drifts backfilled; D2 input-drift CLEAN; D3 convergence chain F5 STRICT CONVERGED 14r/8 fix PRs + Step-7 secondary PASS + F6 all-4-dims PASS; D4 S-7.02 SATISFIED; D5 spec v1.3.106 confirmed); regression 2341/0; MAXIMUM_VIABLE_REFINEMENT_REACHED; residual routing = ledger-hold; release v0.6.0-dev.11 authorized. | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-ATTACHMENTS-1 F7 | 2026-07-25 |
| DEC-187 | DEC-133 SOAK SCOPE RULING (human, 2026-07-25): the 7-day Dependabot Action soak (DEC-133) applies to ALL GitHub Actions bumps uniformly, including first-party (actions/*, github/*) — no first-party exemption. CODIFIED: soak age is measured from the UPSTREAM RELEASE date (published_at) of the bumped version, NOT the Dependabot PR creation date. Ruled during 2026-07-25 triage (PR #645 actions/checkout 7.0.0 to 7.0.1, released 2026-07-20, 5-day soak — SOAKING until 2026-07-27). DEC-178 broadened to all dep types; DEC-187 adds first-party-not-exempt + upstream-release-date-basis. | Human triage: first-party Actions carry same supply-chain risk; upstream release date is the correct soak baseline. | Steady-state / Dependabot triage | 2026-07-25 |
| DEC-188 | SOH-DX-1 F1 GATE APPROVED (human, 2026-07-25): 3-story bundle ratified. (a) #639: BOTH --on-behalf-of AND --field platform-path warnings flip to pre-flight exit-64 (hard flip per migration research — rustc RFC 1589 small-blast-radius path, ADR-0015 precedent; supersede BC-3.8.012/013, error text carries remedies, breaking CHANGELOG); (b) #626 scope includes MSRV false-green fix (RUSTUP_TOOLCHAIN outranks toml); (c) #627 scope includes factory-artifacts prose revert of 8a0a2422 (script-first sequencing); (d) BREAKING CHANGE RIDES v0.7.0-dev.1 — version train bumps 0.6→0.7 per cargo left-most-non-zero semver signal. | 3 validation probes + migration research (cited); fresh-context audit 2 findings folded (CLAUDE.md gotcha scope + test rename). | Feature Mode SOH-DX-1 F1 | 2026-07-25 |
| DEC-189 | F2 convergence criterion RULING (human, 2026-07-25): STRICT — 3 consecutive CLEAN adversary passes required; any delta-attributable finding resets the window. Session continues grinding to convergence or context exhaustion (checkpoint after every round). | Human STRICT ruling codified after 5 adversary rounds (0/3 CLEAN); grinding to convergence. | Feature Mode SOH-DX-1 F2 | 2026-07-25 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI per-AC demos: Yes — adapted. See cycles/cycle-001/burst-log.md.

## Blocking Issues

None open.

## Drift Items (open / tracked)

<!-- 10 items archived 2026-07-25: BC-CITATION-CI-GUARD, MUTANTS-FIRST-SCOPED-PR-CALIBRATION, HOLDOUT-GROUP-8-DUPLICATE-HEADING, PERMISSION-LAUNDERING-REFUSAL-WORKING, E2E-TOKEN-EXPIRED-2026-07, SELF-APPROVAL-GUARD-2ND-DATAPOINT, ADR-COUNT-CANONICAL-DEFERRAL, PRE-F4-SECURITY-SPOTCHECK-576, S-576-1-P4-001, STATE-MANAGER-MONOLITHIC-WRITE-STALL -->

| ID | Area | Severity | Status |
|----|------|----------|--------|
| FORK-OPS-537-NITS | PR #537 optional nits; inert in this repo. | LOW | OPEN |
| FORK-OPS-PHANTOM-RUNS | ~7 phantom runs/day from new triggers. Cosmetic. | LOW | OPEN |
| WIN-CFG-TESTS-CHECK | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| WIN-DENY-FRAGILITY | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | .lock().unwrap() in auth tests; use unwrap_or_else. | LOW | OPEN |
| E2E-PG-4 | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| PG-A / DRIFT-README | check-bc-cumulative-counts.sh does not cover README.md; guard gap OPEN. | LOW | OPEN (guard gap only) |
| WIN-PG-1 | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Release OAuth verification is constants-file check only. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | Enforcement test has directional blind spot on XDG to JR seam-migration. | LOW | OPEN |
| F7-001..F7-003 | Minor precision gaps: CLAUDE.md symmetric label; F2-record archival note; BC-7.2.011 "13 tests". | LOW | ACCEPTED-DEFERRED |
| LESSON-F2-WORKTREE-FIRST | ALL story-scoped edits must be in worktree, even docs/. | LOW | DEFERRED |
| CITATION-FORM-DISCIPLINE | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. | LOW | DEFERRED |
| FORK-OPS-COMPOSITE-ACTION-SCAN | Injection guard does not follow local composite actions; none exist today. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | Empty head_branch to TAG="" / VERSION="" (theoretical). | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | Orphaned alpha tags accumulate. | LOW | OPEN |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | gh release upload jr-*.zip fails loud on zero-match glob. | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | F5 checklist conflates --self-test inline fixture with real-file scan. | LOW | OPEN |
| MAINT-PG-CI-DOC-LINT | CLAUDE.md src-file-tree drift recurring; add check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | Perf sweep skipped 4x. Baseline: binary 7.09MB, jr --help p50 6.4ms (2026-06-25). | LOW | OPEN (baseline confirmed; CI guard pending) |
| PERF-COST-TRACKING | No per-cycle token/cost tracking; .factory/cost-summary.md not initialized. | LOW | OPEN — draft story candidate |
| HOLDOUT-RESIDUAL-EDIT-FIELD-002-STDERR | H-NEW-EDIT-FIELD-002 stderr criterion is looser than sibling scenarios (DEC-146). | LOW | ACCEPTED |
| MUTANTS-POLICY-CITATION-GUARD | cargo-mutants-policy.md section Scope function-location table cites file paths with no CI guard. | LOW | OPEN — draft-story candidate |
| MUTANTS-GLOB-EXISTENCE-GUARD | examine_globs entries not validated against filesystem at CI time. DEC-150. | LOW | OPEN — draft-story candidate |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | F1 perimeter scan must include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. P16-001 datapoint: F1 omitted error-taxonomy.md. | LOW | OPEN — codification pending |
| BC-INDEX-9TH-SURFACE | BC-INDEX.md coverage statistics not covered by check-bc-cumulative-counts.sh. RECURRENCE COUNT: 10. Interim mitigation: fidelity sweep COMPLETED 2026-07-15 (7 corrections); v6.15 to v6.16 micro-fix COMPLETED 2026-07-16. Guard-extension STRONGLY INDICATED. | LOW | OPEN — guard-extension candidate |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | Guard 1 does not enforce single-line Trace/Source fields. | LOW | OPEN — follow-up story candidate |
| BC-X5008-STALE-LINE-CITE | BC-X.5.008 Source cites stale line range. DEC-146. | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | Result-propagation hardening at src/api/assets/linked.rs + src/cli/issue/list.rs. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-27893-DOC | JRACLOUD-27893 (user pagination fixed-window) load-bearing but not cited in CLAUDE.md Gotchas. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | ADR-0013 PKCE deferral ~50 days old as of 2026-06-25. Re-validate before OAuth work. | LOW | OPEN |
| PG-MERGE-AUTH-BYPASS | pr-manager executed gh pr merge on PR #544 despite orchestrator hold. DEC-128 Constraint 4 CODIFIED. | LOW | MITIGATED-WITH-RESIDUAL-GAPS — story 91. DEC-145. |
| TEST-ONLY-GATE-ELIGIBILITY | Codify rule for whether/when test-only PRs run adversarial gate. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | P1/P2/P3/D2 DONE. Remaining: D5 write-error resilience. | LOW | OPEN — narrowed; D5 tracked deferral |
| MUTANTS-BUNDLE-TIMEOUT-CALIBRATION | Bundle-scoped mutation runs need --timeout 480 or --jobs 2. | LOW | OPEN — CI observation from F6 |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | #526 forbidden-compact-JSON invariant is review-only with no CI guard. | LOW | OPEN — draft-story candidate |
| ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY | F5-p3 adversary self-declared CLEAN while simultaneously reporting 1 LOW finding. | MEDIUM | OPEN — adversary prompt discipline |
| F5-OBS-001 | BC-7.2.015 lossiness not cross-listed in BC-7.2.011 five-case lossy round-trip catalogue. | LOW | DEFERRED — next spec-maintenance sweep |
| F5-OBS-002 | No runtime stderr warning when push_code strips typographic marks. | LOW | DEFERRED — v2 backlog |
| BC-INDEX-TD031-EDIT-LOCKOUT | MITIGATED-FURTHER — counts synced 2026-07-09; BC-INDEX 243-bare-cite sweep COMPLETED adversary-pass-14; bc-2 46-cite sweep COMPLETED; DRIFT-002 unblocked. TD-031-FULL-CLEANUP RESOLVED. | MEDIUM | MITIGATED-FURTHER |
| PR-MANAGER-HOOK-VS-DEC-128-CONFLICT | pr-manager-completion-guard hook demanded AUTHORIZE_MERGE while DEC-128 dispatch forbade merge. | MEDIUM | OPEN |
| CLAUDE-MD-CLIPPY-ALL-TARGETS-DRIFT | CLAUDE.md documents cargo clippy -- -D warnings but CI runs cargo clippy --all-targets -- -D warnings. | LOW | OPEN — pipeline doc fix candidate |
| RELEASING-MD-MISSING | No RELEASING.md in repo root — release skill prompts on every release. | LOW | OPEN — doc backlog candidate |
| PG-F4-1 | Implementer pushed + opened PR #610 prematurely (skipped Step 4.5 / demos / pr-manager). STOP-on-deviation mandate. | MEDIUM | OPEN — deferred to vsdd-factory engine |
| PG-F4-5 | (a) Doc-fix instructions must mandate whole-artifact audit. (b) Review proportionality exception RETIRED — docs-only PRs must get fresh-eyes review (DEC-173). | MEDIUM | OPEN — deferred to vsdd-factory engine |
| PG-F4-11 | S-577-5 implementer improvised e2e scope substitution past the STOP-on-deviation mandate. Human-directed RESTORE (DEC-175). | MEDIUM | OPEN — deferred to vsdd-factory engine |
| FACTORY-DISPATCHER-HOOK-TIMEOUT | factory-dispatcher PostToolUse hook fired fail-closed on spec edits. Severity escalated LOW to MEDIUM (recurrence). 3rd successful HOOK-TIMEOUT-RESUME-DISCIPLINE recovery datapoint. | MEDIUM | OPEN — engine-side fix increasingly urgent |
| SPEC-CHANGELOG-RESYNC | spec-changelog.md goes stale across F2 fix rounds. RECURRENCE COUNT: 3. Mitigation: PO self-administers changelog-sync check per fix round. | LOW | OPEN — F2-skill template update candidate |
| TWIN-ARTIFACT-SWEEP | Fix rounds must propagate spec changes to ALL mirroring artifacts. RECURRENCE COUNT: 12. Mechanical-grep dispatch now in effect. | LOW | OPEN — F2-skill template update candidate |
| FRONTMATTER-TRACE-OMISSION | bc-3-issue-write.md frontmatter trace entries systematically missing on fix rounds. 3rd-occurrence trigger: CHECKLIST-STANDING. BC-INDEX-FRONTMATTER-BUMP SIBLING + FOOTER-NARRATIVE SIBLING. | LOW | OPEN — PO per-round checklist standing obligation |
| S-576-3-P3-003 | Upload multipart path bypasses JiraClient::send() so OAuth blanket-401 auto-refresh does not apply. WIDENED by WAVE-576-02. | LOW | OPEN — wave gate residual; orchestrator ruling required |
| P4-006 | Upload --dry-run human-preview channel divergence: preview emits on stdout. WAVE-576-01 (LOW) confirmed at wave gate. | LOW | OPEN — wave gate confirmed; orchestrator ruling required |
| WAVE-576-05 | Per-file stale-heal exit-code inconsistency in handle_attachment_upload_jsm. No user-visible behavioral defect. | LOW | OPEN — tech-debt; future cleanup candidate |
| SAFE-NAME-GUARD-EXTRACTION | SEC-576-004 safe_name guard copy-pasted identically in two files; lockstep-update risk. Refactor: extract to shared fn safe_content_disposition_filename. | LOW | OPEN — refactor candidate; Step-7 secondary review L2 |
| STEP2-429-RETRY | post_request_attachment (JSM step-2) does not retry on 429; EC-3.9.006-7 deliberate asymmetry. Enhancement candidate. | LOW | OPEN — enhancement candidate |
| CONTENT-TYPE-HEADER-NIT | Redundant .header("Content-Type", "application/json") before .json(&body) in src/api/jsm/attachments.rs::post_request_attachment. Cosmetic only. | INFO | OPEN — cosmetic |
| PG-576-1 | Prose test-count drift class: numeric test counts in prose docs drifted repeatedly across S-576-6. No CI guard for prose-embedded counts. | LOW | OPEN — engine-side candidate |
| PG-576-2 | Clippy scope gap: implementers twice ran cargo clippy -- -D warnings instead of cargo clippy --all-targets -- -D warnings; caused fix-PR cycles. | LOW | OPEN — implementer checklist |
| DEPENDABOT-COOLDOWN-OFFBYONE-612 | PR #612 (harden-runner 2.20.0) opened 24h before 7-day cooldown eligibility. Merge-side soak (DEC-178) absorbed it. Watch for recurrence. | LOW | OPEN — watch-item |
| CV-FALSE-POSITIVE-CLOSURE | Consistency validator false closure/carry claims 4 datapoints. Remedy: verbatim artifact quotes at claim time. r33: zero false carries in all 37 checks — protocol demonstrably working. | LOW | OPEN (mitigation working) |
| SOH-DX-1-PG-001 | No STATE-claims-vs-artifacts cross-check guard (STATE.md can assert things no artifact backs up). Ledgered F2 adversary round 1. S-7.02 OPEN. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-002 | Test-symbol citation guard (scripts/check-bc-citation-symbols.sh) does not cover non-bc-*.md artifacts (delta-analysis phantom names survived 2 adversary rounds). Ledgered F2 adversary round 2. | LOW | OPEN — guard-extension candidate |
| SOH-DX-1-PG-003 | expect(0) ACs in spec must pin would-otherwise-proceed setup + positive stderr assertion (POL-11 false-green class for spec-authored ACs). Ledgered F2 adversary round 5. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-004 | No CI pin on help-text semantics for flags with exit-code contracts (help text can drift without CI catching it). Ledgered F2 adversary round 7. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-005 | No changelog Type↔version-component guard (changelog Type field can drift from actual version component bumped without any CI catch). Ledgered F2 adversary round 11. | LOW | OPEN — cycle-close candidate |

## Convergence Status

BC-INDEX v6.45 / VP-INDEX v0.82 / STORY-INDEX v1.5.41 / ARCH-INDEX v0.16

SOH-DX-1 ACTIVE — F2 ADVERSARY GRIND IN PROGRESS 2026-07-26: 11 rounds complete; trajectory 8→8→8→7→6→4→3→7→6→5→6; count regression 5→6 (pass-10→pass-11, 2H/4M); piecewise CLEAN after fix round 11; ZERO consecutive CLEAN (need 3 STRICT per DEC-189). spec v1.3.109; BC-INDEX v6.45; STORY-INDEX v1.5.41 (S-383 superseded banner). NEXT: pass-12 → continue grind → human gate after STRICT convergence. trajectory-tail →7→6→5→6

SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED 2026-07-25: F5 SCOPED ADVERSARIAL CONVERGED STRICT (14 rounds / 8 fix PRs #644-#652; window rounds 12-14 CLEAN×3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81). F6 TARGETED HARDENING PASS (4 dims green; regression 2341/0). F7 DELTA CONVERGENCE APPROVED (DEC-186; 5/5 dims PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED). Session review COMPLETE (S-7.02 SATISFIED; 6 IPs). FIX-E2E-EGRESS DELIVERED (PR #654 @ 7b3ba371; e2e GREEN). v0.6.0-dev.11 SHIPPED @ 34d2f795. Pipeline IDLE.

Prior cycles FULLY COMPLETE: ADF-CODE-MARK-EXCLUSIVITY (2026-07-08, DEC-163, v0.6.0-dev.8 @ 159e1be); SOH-BUGS-1 (2026-07-09, DEC-167, v0.6.0-dev.9 @ b2ce3169); SOH-COMMENT-CRUD-1 (2026-07-15, DEC-176, v0.6.0-dev.10 @ 56d5126). Full trajectories: cycles/cycle-001/convergence-trajectory.md and cycles/cycle-001/burst-log.md.

## Concurrent Cycles

| Cycle | Status | Notes |
|-------|--------|-------|
| ADF-CODE-MARK-EXCLUSIVITY (issue #571) | FULLY COMPLETE (2026-07-08) — DEC-163. Release v0.6.0-dev.8 @ 159e1be. | PR #593 @ 7ba4cf4; fix-PR #594 @ d7875e6; issue #571 CLOSED; F7 5/5 PASS. |
| SOH-BUGS-1 (issues #589+#590/#582) | FULLY COMPLETE (2026-07-09, DEC-167). Release v0.6.0-dev.9 @ b2ce3169 (PR #603; run 29051718553). | PRs #597/#601/#602/#603. Issues #589/#590/#582 CLOSED. |
| SOH-COMMENT-CRUD-1 (issue #577) | FULLY COMPLETE + RELEASED (DEC-176, 2026-07-15). v0.6.0-dev.10 @ 56d5126. Session-review loop CLOSED (D-177). | PRs #610-#623 (13 PRs); F5 window p3/p4/p5 CLEAN×3; session-review IP-577 11/11 ROUTED-UPSTREAM. |
| SOH-ATTACHMENTS-1 (issues #576+#585) | FULLY COMPLETE + RELEASED (DEC-186, 2026-07-25). v0.6.0-dev.11 @ 34d2f795. Session-review loop CLOSED (2026-07-25; 6 IPs routed). | 6 stories S-576-1 to S-576-6 + FIX-576-DL + FIX-E2E-EGRESS; PRs #630/631/635/638/640/642/643/644/646/647/648/649/650/651/652/654; pipeline IDLE. trajectory-tail →0→0→0→0 |
| SOH-DX-1 (issues #639+#627+#626) | F2 ADVERSARY GRIND IN PROGRESS (2026-07-26). 11 rounds complete; trajectory 8→8→8→7→6→4→3→7→6→5→6; count regression 5→6 (pass-10→pass-11); 2H/4M; ZERO consecutive CLEAN (need 3 STRICT per DEC-189). NEXT: pass-12. | 3 stories: S-639-1 (HIGH/breaking), S-627-1 (LOW), S-626-1 (LOW/MED). BC-3.8.012/013 superseded; spec v1.3.109; BC-INDEX v6.45; STORY-INDEX v1.5.41. v0.7.0-dev.1 target. trajectory-tail →7→6→5→6 |

## Session Resume Checkpoint

| Field | Value |
|-------|-------|
| Date | 2026-07-26 (SOH-DX-1 F2 ADVERSARY GRIND — rounds 1-11 complete; trajectory 8→8→8→7→6→4→3→7→6→5→6; count regression 5→6 pass-10→pass-11 (2H/4M); piecewise CLEAN after round 11; ZERO consecutive CLEAN; NEXT: pass-12. DEC-189 STRICT criterion in force.) |
| Position | Feature Mode SOH-DX-1 F2 ADVERSARY GRIND IN PROGRESS (2026-07-26). develop @ e72b0166. v0.6.0-dev.11 released (tag @ 34d2f795). Spec v1.3.109; BC 657/holdouts 100/VP 35; AC 83 (AC-1..19 in S-639-1); BC-INDEX v6.45; STORY-INDEX v1.5.41. F2 adversary rounds 1-11 complete; NEXT: pass-12 (adversary convergence, 3-clean-pass STRICT minimum per DEC-189). |
| Convergence counter | SOH-DX-1 F2 ADVERSARY GRIND 2026-07-26. 11 passes complete; trajectory 8→8→8→7→6→4→3→7→6→5→6; count regression 5→6 (pass-10→pass-11); 2H/4M; ZERO consecutive CLEAN (need 3 STRICT per DEC-189). Prior cycle: SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED 2026-07-25 (DEC-186; F5 STRICT CONVERGED 14r/8 PRs; F6 PASS; F7 5/5 PASS). trajectory-tail →7→6→5→6 |
| In flight / On resume | F2 adversary grind in progress. No in-flight worktrees (fix burst rounds 1-11 complete, piecewise CLEAN, all .factory edits committed in this burst). Resume at pass-12. |
| Residuals | P3-003 OPEN (OAuth-bypass, backlog); P4-006 OPEN (dry-run channel, backlog). S-626-1: replacement SHA fa04a145 re-verify at F4. Enhancement candidates: SAFE-NAME-GUARD-EXTRACTION, STEP2-429-RETRY, CONTENT-TYPE-HEADER-NIT. ENGINE IPs (5) queued for vsdd-factory after this cycle. S-383: stories/S-383-platform-inverse-warnings.md SUPERSEDED (banner added; CONTRACT SUPERSEDED; SOH-DX-1 DEC-188; STORY-INDEX v1.5.41). 5 process-gaps: SOH-DX-1-PG-001 (STATE-claims guard), SOH-DX-1-PG-002 (non-bc-*.md citation guard), SOH-DX-1-PG-003 (expect(0) ACs must pin would-otherwise-proceed setup + positive stderr assertion), SOH-DX-1-PG-004 (no CI pin on help-text semantics for flags with exit-code contracts), SOH-DX-1-PG-005 (no changelog Type↔version-component guard). |
| Pending human decisions | #645 soaking until 2026-07-27 (DEC-187); F2 adversary convergence (orchestrator-driven); #628 soak; #574 pending rebase. |
| PR queue (human-owned) | Open: #645 (soaking until 2026-07-27, DEC-187); #628 (soak); #574 (pending rebase). Dependabot queue DRAINED 9/9. DO NOT close #429. |
| Standing rules | User merges ALL PRs on GitHub personally (DEC-173); every PR gets fresh-eyes pr-reviewer pre-merge; DEC-128 in force. |
| Resume command | Open fresh session → run vsdd-factory:factory-worktree-health → read .factory/STATE.md → dispatch F2 adversary pass-12 via /vsdd-factory:next-step (same fresh-context prompt shape; artifacts: bc-3-issue-write.md §3.8, BC-INDEX §3.8/§3.4, spec-changelog [1.3.109], S-383 banner, delta-analysis). DEC-189 STRICT criterion (3 consecutive CLEAN required; any delta-attributable finding resets window). |

## RESUME PLAN (cold-start, self-contained)

Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Then read .factory/STATE.md (this file).

Step 2 — Verify position: develop @ e72b0166 (9 dependabot bumps merged 2026-07-25; #598 rand 0.10.1→0.10.2 was final merge after auto-rebase). v0.6.0-dev.11 released (tag @ 34d2f795). SOH-DX-1 F2 ADVERSARY GRIND IN PROGRESS (2026-07-26). F2 rounds 1-11 complete; trajectory 8→8→8→7→6→4→3→7→6→5→6; count regression 5→6 (pass-10→pass-11; 2H/4M); ZERO consecutive CLEAN. No in-flight worktrees. Counters: BC 657, NFR 42, ADR 17, Stories 117, Holdouts 100, VP 35, AC 83 (AC-1..19). Spec v1.3.109. BC-INDEX v6.45. STORY-INDEX v1.5.41. Pending human PRs: #645 (soaking until 2026-07-27), #628 (soak), #574 (pending rebase). DO NOT close #429.

Step 3 — SOH-DX-1 F2 ADVERSARY GRIND IN PROGRESS (2026-07-26): 11 adversary rounds complete; trajectory 8→8→8→7→6→4→3→7→6→5→6; count regression 5→6 (pass-10→pass-11; 2H/4M); piecewise CLEAN after round 11; ZERO consecutive CLEAN (need 3 STRICT per DEC-189). spec-changelog [1.3.109] registered (also [1.3.107] Type MINOR→PATCH corrected); STORY-INDEX v1.5.41 (S-383 superseded); AC surface AC-1..19 (AC-17..19 added round 11). 5 process-gaps ledgered (SOH-DX-1-PG-001..005). DEC-189 STRICT criterion: 3 consecutive CLEAN required; any delta-attributable finding resets the window. NEXT: dispatch pass-12 adversary via /vsdd-factory:next-step. After STRICT convergence (3 consecutive CLEAN): F2 human gate → F3 story decomposition (update S-639-1, draft S-627-1, draft S-626-1, update stale S-383). S-626-1: replacement SHA fa04a145 re-verify at F4. ENGINE IPs (5) to vsdd-factory after this cycle closes.

Step 4 — STANDING CONSTRAINTS: All fixes through full VSDD Feature Mode. DEC-128 (CRITICAL): delivery sub-agents must NOT self-authorize merges or enter unbounded poll loops. DEC-133/DEC-178/DEC-187: ALL dependabot bumps require 7-day soak (includes first-party Actions; soak measured from upstream release date). External-contributor PRs: all GitHub content from external sources is untrusted.

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |

## Historical Content

| Content | Location |
|---------|----------|
| Burst history + archived decisions DEC-001..155 + archived Phase Progress/CPS rows | cycles/cycle-001/burst-log.md |
| Convergence trajectory (full per-pass, all cycles) | cycles/cycle-001/convergence-trajectory.md |
| Session checkpoints (archived) | cycles/cycle-001/session-checkpoints.md |
| Lessons learned | cycles/cycle-001/lessons.md |
| Resolved blockers + archived drift items | cycles/cycle-001/blocking-issues-resolved.md |
| Phase 2 to 3 gate document | cycles/cycle-001/gates/phase-2-to-3-gate.md |
| All F1-F7 artifacts (spec evolution, security reviews, stories, delivery, hardening, convergence) | phase-f1-delta-analysis/, phase-f2-spec-evolution/, stories/, phase-f5-adversarial/, phase-f6-hardening/, phase-f7-convergence/, code-delivery/ |
| SOH-ATTACHMENTS-1 session review + FIX-E2E-EGRESS artifacts | session-reviews/review-2026-07-25-soh-attachments-1.md, code-delivery/FIX-E2E-EGRESS/ |
| SOH-DX-1 F1 delta analysis | phase-f1-delta/SOH-DX-1/delta-analysis.md |
