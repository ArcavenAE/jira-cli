---
document_type: pipeline-state
level: ops
version: "2.3"
status: active
producer: state-manager
timestamp: 2026-08-04T08:40:00Z
phase: 3
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "ADVERSARY-21+FIX-ROUND-8 2026-08-04: S-626-1 pass-21 NOT CLEAN (0H+3M+3L+1I; isolation CLEAN; THIRTEENTH zero-src/-defect; window 0/1 of 21/22/23; DEC-217+218+219; fix round 8 applied 84ab32ac; LOW-003 DEFERRED); ADV-P1-INDEX v2.0 (181 findings). trajectory-tail →0→0→2→0 D-1..D-13 (exhaustive). Prior: PRE-WINDOW-PREP 2026-08-04: S-MUTANTS-EXAMINE-GLOBS-1 v1.2→v1.3; demos/S-626-1 negative-path; STORY-INDEX v1.5.58; DEC-216. Prior: ADVERSARY-19+FIX-ROUND-7 2026-08-04: pass-19 NOT CLEAN (2H+6M+1L; DEC-213+214+215). trajectory-tail →0→0→0→2 D-1..D-12 (exhaustive)."
trajectory_tail: "→0→0→2→0"
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: SOH-DX-1-F4-DELIVERY
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
activation_head: "7b3ba371"
activation_version: "v0.6.0-dev.11"
---

<!-- STATE.md SIZE BUDGET (2026-08-04 ADVERSARY-21+FIX-ROUND-8): 289 lines (wc-l) — prior: 283; delta: +6. Soft-target 200; margin from soft-target = +89; margin from actual to hard cap 500 = 211. New: +1 CPS row (ADVERSARY-21+FIX-ROUND-8); -1 CPS row (ADVERSARY-15+FIX-ROUND-5 archived); +3 DEC rows (DEC-217/218/219); +2 drift items (GUARD-BYPASSED-BY-TOOL-SUBSTITUTION, PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES); +1 drift item (CHECK-SPEC-COUNTS-COVERAGE-SCOPE); 5 drift items updated in-place; STORY-TEMPLATE-DRIFT-BLOCKS-EDITS SUPERSEDED in-place; Session Resume Checkpoint replaced. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →0→0→2→0 (HIGH findings per pass: P15=0H [NOT-CLEAN], P18=0H [NOT-CLEAN], P19=2H [NOT-CLEAN], P21=0H [NOT-CLEAN]; passes 16/17 NOT RUN; **S-626-1 pass-21 NOT CLEAN (window 0/1 of 21/22/23; THIRTEENTH zero-src/-defect); ZERO HIGH — 3M+3L+1I all documentation class; passes 22/23 NOT DISPATCHED; fresh STRICT window passes 22/23/24 (DEC-219)**; 18 recorded passes + 5 VOID + 2 NOT RUN + pass-20 SUPERSEDED; window 21/22/23 CLOSED 0/1; **fresh STRICT window passes 22/23/24 (DEC-219), 0/3, not yet dispatched**; Step 4.5 = 0/3) |
| **Last Updated** | trajectory-tail →0→0→2→0 ADVERSARY-21+FIX-ROUND-8 2026-08-04: S-626-1 pass-21 NOT CLEAN (0H+3M+3L+1I; isolation CLEAN); **THIRTEENTH zero-src/-defect pass**; all findings documentation/citation class; "correct change, false claim" pattern named; fix round 8 applied (84ab32ac: AC-9 heading+BC Source+test name+job count+ci comment+pipefail assertion+bc-count sweep); DEC-217+218+219; ADV-P1-INDEX v2.0 (181 findings). Prior: PRE-WINDOW-PREP 2026-08-04: S-MUTANTS-EXAMINE-GLOBS-1 v1.3; STORY-INDEX v1.5.58; DEC-216 (window 18/19/20 CLOSED 0/2; new window passes 21/22/23). |
| **Current Phase** | Feature Mode SOH-DX-1 **F4 DELIVERY IN PROGRESS**. F2 APPROVED (DEC-196), F3 APPROVED (DEC-197). **S-626-1 DELIVERED** — PR #667 open, feature HEAD 84ab32ac (product commit closes pass-21 MED-001/002/003+LOW-001/002+INFO-001; LOW-003 DEFERRED per DEC-217), branch ci/fix-toolchain-sha-msrv; **HELD per DEC-202** (fresh 3-pass window required). Adversary: 18 recorded passes; 5 VOID (3 dispatch + 2 isolation); 2 NOT RUN (passes 16/17 per DEC-209); pass-20 SUPERSEDED (DEC-216); window 21/22/23 CLOSED 0/1; **fresh STRICT window passes 22/23/24 (DEC-219), 0/3, not yet dispatched**; Step 4.5 = **0/3**. AX23-001 PENDING RATIFICATION. |
| **Next Phase** | Adversary passes 22/23/24 (head 84ab32ac; DEC-219; STRICT; all 3 must return CLEAN). Maintain scoped greps. PR #667 HELD until 3/3 CLEAN window. Then S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; FIX-E2E-EGRESS DELIVERED; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Archived rows: see cycles/cycle-001/burst-log.md (rounds 67, 68-70; LEDGER-BURST-71-72; DEC-191-BURST; F2-CONVERGENCE-BURST; passes 75-78; DEC-192 spec fix burst; F2-CONVERGENCE-BURST final rows archived SOH-DX-1-F3-DECOMP-BURST 2026-07-29; F2-CONVERGENCE-BURST final rows archived DEC-197-BURST 2026-07-30; DEC-198-LEDGER rows archived POST-ADVERSARY-PERSISTENCE-BURST 2026-07-30; pass-84 PP row + PASS-4-PERSISTENCE-BURST CPS archived SESSION-WRAP-BURST 2026-07-30; SESSION-WRAP-BURST PP row + SESSION-WRAP-BURST CPS archived PASS-5-PERSISTENCE-BURST 2026-07-31; PASS-5-PERSISTENCE-BURST PP row archived ADV-6-7-8-FIX-BURST 2026-07-31; ADV-6-7-8-FIX-BURST PP row archived ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03; ADVERSARY-9-10-11+FIX-ROUND-3 PP row archived ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03; ADVERSARY-12-13-14+FIX-ROUND-4 PP row archived ADVERSARY-15+FIX-ROUND-5 2026-08-03; ADVERSARY-15+FIX-ROUND-5 PP row archived ADVERSARY-18+FIX-ROUND-6 2026-08-03; ADVERSARY-18+FIX-ROUND-6 PP row archived ADVERSARY-19+FIX-ROUND-7 2026-08-04; ADVERSARY-19+FIX-ROUND-7 PP row archived ADVERSARY-21+FIX-ROUND-8 2026-08-04) -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **ADVERSARY-21+FIX-ROUND-8 (2026-08-04): S-626-1 pass-21 (NOT CLEAN; 0H+3M+3L+1I; isolation CLEAN; THIRTEENTH zero-src/-defect; all documentation class; "correct change, false claim" pattern named) — ADV-P1-INDEX v2.0 (181 findings); fix round 8 applied 84ab32ac; DEC-217+218+219; LOW-003 DEFERRED. STORY-INDEX v1.5.58.** | PAUSED | 2026-08-04 | — | Window 21/22/23 CLOSED 0/1 (passes 22/23 NOT DISPATCHED). Fresh STRICT window: passes 22/23/24 (DEC-219). PR #667 HELD (DEC-202). AX23-001 PENDING. | →0→0→2→0 |

## Current Phase Steps

<!-- Archived rows: see cycles/cycle-001/burst-log.md (SESSION-WRAP; LEDGER-BURST-71-72; DEC-191-BURST; F2-CONVERGENCE-BURST; F2-CONVERGENCE-WINDOW-BURST; DEC-192 corrective; F2-CONVERGENCE-BURST final; SOH-DX-1-F3-DECOMP-BURST 2026-07-29; DEC-197-GATE-APPROVAL-RETARGET-BURST 2026-07-30; DEC-198-LEDGER-CORRECTION-BURST 2026-07-30; POST-ADVERSARY-PERSISTENCE-BURST 2026-07-30; PASS-2-PERSISTENCE-BURST 2026-07-30; PASS-3-PERSISTENCE-BURST 2026-07-30; PASS-4-PERSISTENCE-BURST 2026-07-30; SESSION-WRAP-BURST 2026-07-30; PASS-5-PERSISTENCE-BURST 2026-07-31; ADV-6-7-8-FIX-BURST CPS archived ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03; ADVERSARY-9-10-11+FIX-ROUND-3 CPS archived ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03; ADVERSARY-12-13-14+FIX-ROUND-4 CPS archived ADVERSARY-15+FIX-ROUND-5 2026-08-03; ADVERSARY-12-13-14+FIX-ROUND-4 CPS archived ADVERSARY-18+FIX-ROUND-6 2026-08-03; CORRECTIVE-VERDICT-LABEL-AMBIGUITY CPS archived ADVERSARY-19+FIX-ROUND-7 2026-08-04; ADVERSARY-15+FIX-ROUND-5 CPS archived ADVERSARY-21+FIX-ROUND-8 2026-08-04) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **ADVERSARY-18+FIX-ROUND-6 (2026-08-03): S-626-1 pass-18 (NOT CLEAN; 0H+7M+3L; isolation CLEAN; F-07 FIXED IN-CYCLE 9312f11f; DEC-211) + ADV-P1-INDEX v1.8 (164 total findings) + fix round 6 + DEC-212. 3 new drift items.** | state-manager | COMPLETED | S-626-1 pass-18 + fix round 6 + STATE.md committed to factory-artifacts. Next: S-626-1 passes 19/20. |
| **ADVERSARY-19+FIX-ROUND-7 (2026-08-04): S-626-1 pass-19 (NOT CLEAN; 2H+6M+1L; isolation CLEAN; 4 CI-as-code defects in 9312f11f; DEC-213+214+215) + ADV-P1-INDEX v1.9 (174 total findings) + fix round 7 + anchor migration CLASS-ELIMINATING. 4 new drift items.** | state-manager | COMPLETED | S-626-1 pass-19 + fix round 7 + STATE.md committed to factory-artifacts. |
| **INPUT-HASH-BYPASS-RESOLVED (2026-08-04): bc-02-issue-read.md input-hash bypass marker resolved; product-brief.md removed from inputs:; hash updated to 86f53a7; class-wide sweep clean; 2 drift items added. No convergence value altered.** | state-manager | COMPLETED | Factory-artifacts committed. Awaiting S-626-1 pass-20. |
| **PRE-WINDOW-PREP (2026-08-04): S-MUTANTS-EXAMINE-GLOBS-1 v1.2→v1.3 (template conformance + anchor migration; hook unblocked). demos/S-626-1 negative-path evidence added (INFO-01 closed). STORY-INDEX v1.5.57→v1.5.58. DEC-216: window 18/19/20 CLOSED 0/2 (pass-20 SUPERSEDED); new STRICT window passes 21/22/23 not yet dispatched.** | state-manager | COMPLETED | Factory-artifacts committed. Dispatching S-626-1 passes 21/22/23 (DEC-216). |
| **ADVERSARY-21+FIX-ROUND-8 (2026-08-04): S-626-1 pass-21 (NOT CLEAN; 0H+3M+3L+1I; isolation CLEAN; THIRTEENTH zero-src/-defect; all documentation class; passes 22/23 NOT DISPATCHED) + ADV-P1-INDEX v2.0 (181 total findings) + fix round 8 (84ab32ac) + DEC-217+218+219. 3 new drift items; 5 drift items updated; STORY-TEMPLATE-DRIFT-BLOCKS-EDITS SUPERSEDED.** | state-manager | COMPLETED | S-626-1 pass-21 + fix round 8 + STATE.md committed to factory-artifacts. Next: S-626-1 passes 22/23/24 (DEC-219). |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-155 | Phase 0/1/2/3 + Wave + Feature Mode + all prior cycles. All CYCLE CLOSED. | See cycles/cycle-001/burst-log.md | Phase 0 to 3 / 2026-05-04 to 2026-07-07 | archived |
| DEC-156..163 | CITATION-GUARDS (PR #572/#592; BC-X.13.001..006) FULLY COMPLETE + ADF-CODE-MARK-EXCLUSIVITY (PR #593/#594; v0.6.0-dev.8 @ 159e1be) FULLY COMPLETE. | Human closed both cycles. | Feature Mode 2026-07-07 to 2026-07-08 | 2026-07-07/08 |
| DEC-164 | SESSION-REVIEW IP-571 DISPOSITION (2026-07-08): 13 proposals routed to drbothen/vsdd-factory (#576-#584). | Human ruled proposals belong in engine repo. | Post-cycle / session-review | 2026-07-08 |
| DEC-165..DEC-167 | SOH-BUGS-1: F1 gate approved; delivery PRs #597-#603; F7-lite 7/7 PASS; release v0.6.0-dev.9 @ b2ce3169. Issues #589/#590/#582 CLOSED. | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-BUGS-1 | 2026-07-09 |
| DEC-168..DEC-177 | SOH-COMMENT-CRUD-1: F1-F7 complete; 13 delivery PRs #610-#623; release v0.6.0-dev.10 @ 56d5126; S-7.02 SATISFIED; issue #577 CLOSED. | Human closed all phases; bundle released; session review complete. | Feature Mode / SOH-COMMENT-CRUD-1 | 2026-07-09 to 2026-07-15 |
| DEC-178+DEC-179..DEC-185 | DEC-178: ALL-DEPENDABOT SOAK BROADENED. DEC-179..185: SOH-ATTACHMENTS-1 F1-F3 complete. | Human triage + human gated all phases. | Steady-state + Feature Mode / SOH-ATTACHMENTS-1 | 2026-07-15 to 2026-07-19 |
| DEC-186+DEC-187 | DEC-186: SOH-ATTACHMENTS-1 F7 APPROVED; release v0.6.0-dev.11 authorized. DEC-187: 7-day soak applies to ALL Actions bumps. | Human closed bundle; triage ruling. | Feature Mode + Steady-state | 2026-07-25 |
| DEC-188+DEC-189 | DEC-188: SOH-DX-1 F1 GATE APPROVED. DEC-189: F2 STRICT criterion. SUPERSEDED by DEC-191. **DEC-188(d) SUPERSEDED by DEC-197**. | Fresh-context audit 2 findings folded; STRICT ruling. | Feature Mode SOH-DX-1 F1+F2 | 2026-07-25 |
| DEC-190 | SUBSTITUTE-PASS RATIFICATION (amended 2026-07-30: factual premise false — adversary was usable; malformed dispatch caused failures; prior window rulings stand with disclosure). | Human ratified; basis false per amendment. | Feature Mode SOH-DX-1 F2 | 2026-07-27 (amended 2026-07-30) |
| DEC-191 | F2 CONVERGENCE CRITERION AMENDED: (a) CONVERGENCE = novelty decay. (b) THRESHOLD = 3 consecutive CLEAN. (c) LOW refinements LEDGERED, non-resetting. (d) ESCALATION CEILING = max 10 passes. | Human ruling 2026-07-28. | Feature Mode SOH-DX-1 F2 | 2026-07-28 |
| DEC-192 | **SOH-DX-1 F2 GATE REJECTED; HOLDOUT COVERAGE REQUIRED.** Zero holdout scenarios for #639 is structural absence. | Human domain knowledge. | Feature Mode SOH-DX-1 F2 gate | 2026-07-29 |
| DEC-193 | **PASS-83 GAP RECLASSIFICATION RATIFIED.** ADV-P83-MEDIUM-001 and ADV-P83-LOW-001 are pre-implementation state of F4 deliverable S-626-1. | Human domain knowledge. | Feature Mode SOH-DX-1 F2 | 2026-07-29 |
| DEC-194 | **CLAUDE.md DOC-FIX STORY SCHEDULED.** Three items: profile-4 wording defect; #661 doc staleness; POL-11-RESIDUAL guard. | Human ruling after pass-79 CRITICAL detection. | Feature Mode SOH-DX-1 / post-F2 | 2026-07-29 |
| DEC-195 | **VSDD-CONFORMANCE-GAP-4-ARTIFACTS scheduled as own bundle.** | Human ruling: scope separation. | Post SOH-DX-1 / own bundle | 2026-07-29 |
| DEC-196 | **SOH-DX-1 F2 GATE APPROVED.** 3/3 CONVERGED window (passes 82/83/84, artifact-backed) at spec v1.3.166. Four disclosures on record. | Human domain knowledge. | Feature Mode SOH-DX-1 F2 gate | 2026-07-29 |
| DEC-197 | **SOH-DX-1 F3 GATE APPROVED; BREAKING CHANGE RETARGETED TO v0.6.0-dev.12.** | Human domain knowledge; v0.6.0 stable never released. | Feature Mode SOH-DX-1 F3 gate | 2026-07-29 |
| DEC-199..DEC-203 | (a) DEC-199: Step 4.5 GRIND to literal 3/3 CLEAN WINDOW. (b) DEC-200: SS-11 PHANTOM ANCHOR is MIS-ANCHOR. (c) DEC-201: FIX SCOPE AUTHORIZED for four classes. (d) DEC-202: PR #667 HELD until fixes land and fresh window opens. (e) DEC-203: AX23-001 KEPT PENDING. | Human ruling 2026-07-31. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-07-31 |
| DEC-204 | **OPEN QUESTION:** DEC-191(d) ceiling = 10; 8 recorded + 3-pass window = 11 > 10. ESCALATION REQUIRED. Also: LOW findings in passes 4+5 classified as GAPs reset the window under DEC-191(c) — ruling pending. | Pending human adjudication. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-07-31 |
| DEC-205 | **CEILING BREACH AUTHORIZED (human, 2026-08-03).** DEC-191(d) ceiling of 10 passes breached. Human authorized continued grinding to passes 12/13/14. DEC-199 GRIND mandate continues. | Human authorized past ceiling given active fix rounds and convergence progress. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-206 | **VOID PROTOCOL FOR ISOLATION BREACHES (human, 2026-08-03).** Adversary passes where orchestrator dispatch defects leak banned-path content are VOID for step-4.5 window eligibility; findings remain valid. Applied to pass-9 (VOID-9A) and pass-11 (VOID-11A). | Human ruling on isolation protocol. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-207 | **ROUND 4 + PASSES 15/16/17 AUTHORIZED (2026-08-03).** Window 12/13/14 = 0/3 NOT CLEAN; severity decay 4H→0H confirmed; grep-hygiene corrective verified effective. | Human authorized continued grinding given zero-HIGH severity decay. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-208 | **S-576 FAMILY DRIFT ROUTED AS S-MAINT-576-HYG-1 (2026-08-03).** ADV-P13-MED-004 status drift routed to new maintenance story S-MAINT-576-HYG-1. | Scope separation: S-576 family hygiene is maintenance work. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-209 | **ROUND 5 + PASSES 18/19/20 AUTHORIZED (2026-08-03).** Passes 16/17 deliberately NOT RUN. Continuing AUTHORIZED breach of DEC-191(d) ceiling, never a re-baseline. | Human authorized continued grinding despite trend reversal. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-210 | **BC-5.3.003 DECLARED IN S-626-1 (2026-08-03).** BC-5.3.003 added to S-626-1 bcs:/behavioral_contracts:/AC-9 trace. | Resolves delivered-but-undeclared coverage question. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-211 | **F-07 FIXED IN-CYCLE ON HUMAN RULING (2026-08-03).** Zero-test floor empirically confirmed reachable; product commit 9312f11f. | Empirically reachable real product-CI defect; immediate fix in-cycle. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-212 | **PASSES 19/20 AUTHORIZED (2026-08-03).** Continuing AUTHORIZED breach of DEC-191(d) ceiling. | Human authorized continued grinding after pass-18 NOT CLEAN. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-213 | **ANCHOR-FORM CITATION MIGRATION AUTHORIZED (2026-08-04).** `ci.yml :: <job-id> / "<step>"` notation adopted. Eliminates citation-ripple class (three sweeps: +39, +54, +93 cumulative). Historical records preserved as line numbers. | CLASS-ELIMINATING structural fix; first such fix in six rounds. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-214 | **F-05 ORCHESTRATOR SCOPE BREACH CLOSED (2026-08-04).** `tests/ci_gate_completeness.rs` and `tests/cli_handler.rs` declared at all four spec surfaces in S-626-1 v1.13. | Scope breach by orchestrator; legitimate deliverables declared, not reverted. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-215 | **F-09 ROUTED, NOT FIXED (2026-08-04).** `fmt`/`clippy` positive-coverage gap deferred. Tracked as FMT-CLIPPY-NO-POSITIVE-COVERAGE drift item. | Fourth product-CI change not authorized in this round. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-216 | **STRICT WINDOW RESET: passes 21/22/23 (human ruling 2026-08-04 "proceed with 3 strict clean").** Prior window 18/19/20 CLOSED 0/2 (pass-20 SUPERSEDED-NOT-DISPATCHED). Concurrency disclosed — three independent reads of one frozen state. Continuing AUTHORIZED breach of DEC-191(d) ceiling. | Human ruling. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-217 | **F-06 DEFERRED — S-BC-CITATION-GUARD-1.md raw line citations (ADV-P21-LOW-003).** Placeholder/stub approach DECLINED: would introduce false-claim drift worse than the citation drift it attempts to fix. Deferred pending template-compliant full rewrite. PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES drift item opened. | Template drift blocks correctness fix; placeholder approach rejected. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-218 | **DOMAIN-SPEC COUNT CLASS SWEEP DIRECTED (ADV-P21-INFO-001).** bc-02-issue-read.md bc_count drift (94/92 vs actual 106) triggered class sweep. Sweep found bc-03 also drifted (120→140). Both fixed in fix round 8. check-spec-counts.sh catches frontmatter-vs-body mismatch but NOT body-count-vs-actual; class sweep is the only coverage for the latter. | INFO-001 domain-spec count drift class; sweep-to-class mandate. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-219 | **FRESH STRICT WINDOW = PASSES 22/23/24.** Passes 22/23 of window 21/22/23 NOT DISPATCHED (pass-21 NOT CLEAN made them window-moot). Fresh STRICT window: passes 22/23/24 against feature HEAD 84ab32ac. DEC-191(c) conservative reading applies (DEC-204 UNADJUDICATED). Continuing AUTHORIZED breach of DEC-191(d) ceiling. | Pass-21 NOT CLEAN closed window 21/22/23 at 0/1; new window resets. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI + S-626-1 per-AC demos: Yes — adapted (S-626-1: 11 artifacts at `.factory/demos/S-626-1/`). See cycles/cycle-001/burst-log.md.

## Blocking Issues

None open.

## Drift Items (open / tracked)

<!-- 10 items archived 2026-07-25; 22 items archived through 2026-07-29 (see blocking-issues-resolved.md); 5 ACCEPTED/MITIGATED/FIXED items archived SOH-DX-1-F3-DECOMP-BURST 2026-07-29. ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03: 6 new items added. ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03: 4 items updated; 2 new items. CORRECTIVE-VERDICT-LABEL-AMBIGUITY 2026-08-03: 2 new items. ADVERSARY-15+FIX-ROUND-5 2026-08-03: 1 new item; 4 updated. ADVERSARY-18+FIX-ROUND-6 2026-08-03: 3 new items; 3 updated. ADVERSARY-19+FIX-ROUND-7 2026-08-04: 4 new items; 4 updated. INPUT-HASH-BYPASS-RESOLVED 2026-08-04: 2 new items; 1 updated. PRE-WINDOW-PREP 2026-08-04: 3 updated; 1 new INFO CLOSED. ADVERSARY-21+FIX-ROUND-8 2026-08-04: 3 new items (GUARD-BYPASSED-BY-TOOL-SUBSTITUTION MEDIUM, PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES MEDIUM, CHECK-SPEC-COUNTS-COVERAGE-SCOPE INFO); 5 updated (FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE, FIX-ROUND-PARTIAL-PROPAGATION, CITATION-GUARD-SRC-ONLY, CI-YML-LINE-CITATION-RIPPLE, STORY-TEMPLATE-DRIFT-BLOCKS-EDITS SUPERSEDED). -->
| ID | Area | Severity | Status |
|----|------|----------|--------|
| SIX-AXIS-REVIEW-UNLOGGED | spec integrity | LOW | OPEN — AX23-001 PENDING HUMAN RATIFICATION. |
| STALE-FACTORY-ARTIFACTS-BRANCH | branch hygiene | LOW | OPEN — RECOMMENDATION: safe to delete — human decides. |
| FORK-OPS-537-NITS | PR #537 optional nits; inert. | LOW | OPEN |
| FORK-OPS-PHANTOM-RUNS | ~7 phantom runs/day. Cosmetic. | LOW | OPEN |
| WIN-CFG-TESTS-CHECK | cargo check --lib excludes #[cfg(test)]; use --tests. | LOW | OPEN |
| WIN-DENY-FRAGILITY | Canonical-un-skipped-version has no CI guard. | LOW | OPEN |
| WIN-AUTH-ENVLOCK-POISON | .lock().unwrap() in auth tests. | LOW | OPEN |
| E2E-PG-4 | remote-link round-back (no jr remote-link read). | LOW | OPEN |
| PG-A / DRIFT-README | check-bc-cumulative-counts.sh does not cover README.md. | LOW | OPEN (guard gap only) |
| WIN-PG-1 | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. | LOW | OPEN |
| WIN-PG-2 | Presence-only-test disclosure field missing from story template. | LOW | OPEN |
| WIN-RUNTIME-OAUTH-PROBE | Release OAuth verification is constants-file check only. | LOW | OPEN — accepted per ADR-0016 |
| WIN-AC004-DIRECTIONAL | Enforcement test has directional blind spot on XDG to JR seam-migration. | LOW | OPEN |
| LESSON-F2-WORKTREE-FIRST | ALL story-scoped edits must be in worktree, even docs/. | LOW | OPEN — ESCALATED from DEFERRED (2nd recurrence 2026-07-29). |
| CITATION-FORM-DISCIPLINE | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. Third instance. | LOW | OPEN |
| FORK-OPS-COMPOSITE-ACTION-SCAN | Injection guard does not follow local composite actions; none exist today. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | Empty head_branch to TAG="" / VERSION="" (theoretical). | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | Orphaned alpha tags accumulate. | LOW | OPEN — accepted |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | gh release upload jr-*.zip fails loud on zero-match glob. | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | F5 checklist conflates --self-test inline fixture with real-file scan. | LOW | OPEN |
| MAINT-PG-CI-DOC-LINT | CLAUDE.md src-file-tree drift recurring; add check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | Perf sweep skipped 4x. Baseline: binary 7.09MB, jr --help p50 6.4ms (2026-06-25). | LOW | OPEN (baseline confirmed; CI guard pending) |
| PERF-COST-TRACKING | No per-cycle token/cost tracking; .factory/cost-summary.md not initialized. | LOW | OPEN — draft story candidate |
| MUTANTS-POLICY-CITATION-GUARD | cargo-mutants-policy.md section Scope function-location bulleted list against src/. | LOW | OPEN — draft-story candidate |
| MUTANTS-GLOB-EXISTENCE-GUARD | examine_globs entries not validated against filesystem at CI time. AC-9 multi-pass confirmation. | LOW | OPEN — draft-story candidate |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | F1 perimeter scan must include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. | LOW | OPEN — codification pending |
| BC-INDEX-9TH-SURFACE | BC-INDEX.md coverage statistics not covered by check-bc-cumulative-counts.sh. RECURRENCE COUNT: 10. | LOW | OPEN — guard-extension candidate |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | Guard 1 does not enforce single-line Trace/Source fields. | LOW | OPEN — follow-up story candidate |
| BC-X5008-STALE-LINE-CITE | BC-X.5.008 Source cites stale line range. DEC-146. | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | Result-propagation hardening at src/api/assets/linked.rs + src/cli/issue/list.rs. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-PAGINATION-DOC | JRACLOUD user pagination fixed-window load-bearing but not cited in CLAUDE.md Gotchas. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | ADR-0013 PKCE deferral ~50 days old as of 2026-06-25. Re-validate before OAuth work. | LOW | OPEN |
| TEST-ONLY-GATE-ELIGIBILITY | Codify rule for whether/when test-only PRs run adversarial gate. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | P1/P2/P3/D2 DONE. Remaining: D5 write-error resilience. | LOW | OPEN — narrowed; D5 tracked deferral |
| MUTANTS-BUNDLE-TIMEOUT-CALIBRATION | Bundle-scoped mutation runs need --timeout 480 or --jobs 2. | LOW | OPEN — CI observation from F6 |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | #526 forbidden-compact-JSON invariant is review-only with no CI guard. | LOW | OPEN — draft-story candidate |
| ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY | F5-p3 adversary self-declared CLEAN while simultaneously reporting 1 LOW finding. 2nd datapoint: pass-83. | MEDIUM | OPEN — adversary prompt discipline |
| F5-OBS-001 | BC-7.2.015 lossiness not cross-listed in BC-7.2.011 five-case lossy round-trip catalogue. | LOW | DEFERRED — next spec-maintenance sweep |
| F5-OBS-002 | No runtime stderr warning when push_code strips typographic marks. | LOW | DEFERRED — v2 backlog |
| PR-MANAGER-HOOK-VS-DEC-128-CONFLICT | pr-manager-completion-guard hook demanded AUTHORIZE_MERGE while DEC-128 dispatch forbade merge. | MEDIUM | OPEN |
| CLAUDE-MD-CLIPPY-ALL-TARGETS-DRIFT | CLAUDE.md documents cargo clippy -- -D warnings but CI runs cargo clippy --all-targets -- -D warnings. | LOW | OPEN — pipeline doc fix candidate |
| RELEASING-MD-MISSING | No RELEASING.md in repo root. | LOW | OPEN — doc backlog candidate |
| PG-F4-1 | Implementer pushed + opened PR #610 prematurely. STOP-on-deviation mandate. | MEDIUM | OPEN — deferred to vsdd-factory engine |
| PG-F4-5 | Doc-fix instructions must mandate whole-artifact audit. | MEDIUM | OPEN — deferred to vsdd-factory engine |
| PG-F4-11 | S-577-5 implementer improvised e2e scope substitution. | MEDIUM | OPEN — deferred to vsdd-factory engine |
| FACTORY-DISPATCHER-HOOK-TIMEOUT | factory-dispatcher PostToolUse hook fired fail-closed on spec edits. 5th+ recurrence. | MEDIUM | OPEN — engine-side fix increasingly urgent |
| SPEC-CHANGELOG-RESYNC | spec-changelog.md goes stale across fix rounds. RECURRENCE COUNT: 3. | LOW | OPEN — F2-skill template update candidate |
| TWIN-ARTIFACT-SWEEP | Fix rounds must propagate spec changes to ALL mirroring artifacts. RECURRENCE COUNT: 20. | LOW | OPEN — F2-skill template update candidate |
| FOOTER-FRONTMATTER-CONVENTION-MISS | bc-3-issue-write.md footer + frontmatter trail parity. No CI guard. | LOW | OPEN — PO per-round checklist |
| S-576-3-P3-003 | Upload multipart path bypasses JiraClient::send() so OAuth blanket-401 auto-refresh does not apply. | LOW | OPEN — wave gate residual |
| P4-006 | Upload --dry-run human-preview channel divergence. | LOW | OPEN — wave gate confirmed |
| WAVE-576-05 | Per-file stale-heal exit-code inconsistency. | LOW | OPEN — tech-debt |
| SAFE-NAME-GUARD-EXTRACTION | SEC-576-004 safe_name guard copy-pasted identically in two files; lockstep-update risk. | LOW | OPEN — refactor candidate |
| STEP2-429-RETRY | post_request_attachment (JSM step-2) does not retry on 429. | LOW | OPEN — enhancement candidate |
| CONTENT-TYPE-HEADER-NIT | Redundant .header("Content-Type") in post_request_attachment. | INFO | OPEN — cosmetic |
| PG-576-1 | Prose test-count drift class. | LOW | OPEN — engine-side candidate |
| PG-576-2 | Clippy scope gap (--all-targets). | LOW | OPEN — implementer checklist |
| DEPENDABOT-COOLDOWN-OFFBYONE-612 | PR #612 opened 24h early. | LOW | OPEN — watch-item |
| CV-FALSE-POSITIVE-CLOSURE | Consistency validator false closure/carry claims: 5 datapoints. Mitigation working. | LOW | OPEN (mitigation working) |
| SOH-DX-1-PG-001 | No STATE-claims-vs-artifacts cross-check guard. SECOND DATAPOINT. | MEDIUM | OPEN — cycle-close candidate |
| SOH-DX-1-PG-002 | Test-symbol citation guard does not cover non-bc-*.md artifacts. | LOW | OPEN — guard-extension candidate |
| SOH-DX-1-PG-003 | expect(0) ACs must pin would-otherwise-proceed setup + positive stderr assertion. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-004 | No CI pin on help-text semantics for flags with exit-code contracts. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-005 | No changelog Type↔version-component guard. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-006 | EC-field symbol citations in spec not guarded by check-bc-citation-symbols.sh. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-007 | Citation guard skips AC continuation lines. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-008 | Falsifiability rule for ACs is prose-only; no CI guard. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-009 | prd/README.md is an unguarded 9th count surface. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-010 | Foreign-handler-negative heuristic codified only in prose. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-011 | Trace continuation-line guard blind spot. | LOW | OPEN — guard-extension candidate |
| SOH-DX-1-PG-012 | Mechanical replace_all on spec artifacts has no immutable-entry guard. **MITIGATION PATTERN CODIFIED 2026-07-29.** | LOW | MITIGATED — pattern codified; CI guard still open |
| TRAIL-ORDER-ANOMALY-BC3 | bc-3-issue-write.md frontmatter trail ordering anomaly. | LOW | OPEN |
| AGENT-IDLE-NO-REPORT | platform defect #47936 (background subagents 14-30% fail mid-work). NOTE (DEC-198): adversary-specific failures re-attributed to orchestrator malformed dispatch. | MEDIUM | OPEN — route to Anthropic |
| PO-REPORT-FIDELITY | product-owner reported fabricated changelog-count line. | LOW | OPEN — dispatch-discipline |
| VP-INDEX-ARTIFACT-ABSENT | VP-INDEX is canonical VSDD artifact. Fold into VSDD-CONFORMANCE-GAP-4-ARTIFACTS. DEC-195. | LOW | OPEN — pending DEC-195 bundle |
| INPUT-HASH-DRIFT-BACKLOG-56 | 56 artifacts stale on input-hash across closed cycles. | MEDIUM | OPEN — maintenance-sweep candidate. Spec-steward confirmed OPEN and out of scope for this fix; bc-02-issue-read.md resolved separately. |
| INPUT-HASH-MALFORMED-INPUTS-3 | Three artifacts declare unresolvable inputs. | LOW | OPEN — frontmatter fix candidate |
| APERTURE-CLASS-LESSON | Internal-consistency review cannot detect false factual claims. Two-dimension falsification prescription codified. | MEDIUM | OPEN — engine/skill-template candidate |
| AC-NEGATIVE-SUBSTRING-SPECIFICITY | AC negative assertions can pin a contract using a shared substring. | LOW | OPEN — guard-extension candidate |
| README-SIBLING-COUNT-DRIFT-3 | README.md rows bc-2/bc-5/bc-7 show definitional_count instead of total_bcs. | LOW | OPEN — bc-2/5/7 correction candidate |
| HOLDOUT-H-018-ABSENT | H-018 absent from bare-H holdout scenarios. | LOW | OPEN — verify retirement intent |
| RANGE-TERMINUS-INFERENCE | Any range-notation claim must have its maximum verified by enumeration. | MEDIUM | OPEN — engine/checklist candidate |
| UPSTREAM-COMPLETENESS-APERTURE | Internal-consistency review cannot detect upstream-phase obligation gaps. | MEDIUM | OPEN — route upstream to drbothen/vsdd-factory |
| ORCHESTRATOR-ERROR-INJECTION-RATE | Fix instructions must enumerate expected post-state counts. Multiple datapoints. | MEDIUM | OPEN — orchestrator discipline |
| VSDD-CONFORMANCE-GAP-4-ARTIFACTS | jira-cli lacks four canonical VSDD artifacts: VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md. | MEDIUM | OPEN — DEC-195 scheduled as own bundle |
| PLUGIN-ACTIVATION-VERSION-DRIFT | .claude/settings.local.json vsdd-factory.activated_plugin_version = 1.0.0-rc.20 vs installed 1.0.0-rc.23. | LOW | OPEN — verify on next session resume |
| NUDGE-TWICE-BEFORE-VOID | Standing rule: never record VOID until nudged twice. | LOW | OPEN — update dispatch procedures |
| STATE-WRITE-TIMESTAMP-COMPLIANCE | verify-state-timestamp-refresh blocks STATE.md writes that don't advance timestamp:. | LOW | OPEN — agent-discipline |
| LOCAL-BASH-WRITE-GUARD-INSTALLED | .claude/hooks/guard-state-bash-write.sh blocks Bash-based writes to STATE.md. | LOW | OPEN — route upstream |
| ADVERSARY-ARTIFACT-WRITE-MITIGATION | adversary agents have no Write tool by design. Mitigation: orchestrator manually routes artifact writes. 5 datapoints. | LOW | OPEN — route upstream |
| REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED | adversary process | MEDIUM | OPEN — mitigation EFFECTIVE across windows 12/13/14, pass-15, pass-18, pass-19, and pass-21 (7/7 isolation CLEAN). Grep-hygiene corrective verified effective. No mechanical isolation guard exists; behavioral corrective sufficient. |
| VERIFICATION-NONGOAL-UNSCRUTINIZED | spec integrity | MEDIUM | OPEN — flagged for F2 gate. Three adversary review axes NEVER ran across 78 F2 passes. |
| ADV-P76-LOW-001 | spec quality | LOW | OPEN — ledgered (IN-DELTA REFINEMENT). |
| P77-001 | spec quality | LOW | OPEN — ledgered (OUT-OF-DELTA REFINEMENT). |
| POL-11-RESIDUAL-OPTIONAL-FILE-BRANCHES | guard hygiene | MEDIUM | OPEN — follow-up story candidate. |
| POL-11-GUARD-NO-SELFTEST | guard hygiene | LOW | OPEN — follow-up story candidate. |
| CHECK-SPEC-COUNTS-SILENT-EXIT1 | guard hygiene | LOW | OPEN — follow-up story candidate. |
| FACTORY-READ-AFTER-WRITE-UNRELIABLE | factory process | MEDIUM | OPEN — mitigation: settle delay or re-read before concluding. |
| TRAJECTORY-TAIL-SEVERITY-LOSS | factory process | LOW | OPEN — engine/hook candidate. |
| CLAUDE-MD-PROFILE-TAXONOMY-DEFECT | doc quality | MEDIUM | OPEN — scheduled DEC-194. |
| ADV-P83-MEDIUM-001 | CI/F4 | LOW | OPEN — ledgered. Reclassified per DEC-193. |
| ADV-P83-LOW-001 | CI/F4 | LOW | OPEN — ledgered. Reclassified per DEC-193. |
| P79-003 | spec quality | LOW | OPEN — ledgered (pre-window, OUT-OF-DELTA). |
| P79-004 | spec quality | LOW | OPEN — ledgered (pre-window, OUT-OF-DELTA). |
| P80-002 | spec quality | LOW | OPEN — ledgered (pre-window, OUT-OF-DELTA). |
| PLATFORM-BASH-CLASSIFIER-OUTAGE | platform/tooling | LOW | OPEN — rule codified: report gap rather than substituting inference. |
| ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE | adversary process | MEDIUM | OPEN (all 18 passes + 2 NOT RUN stubs now captured; pass-20 SUPERSEDED noted; pass-21 captured in ADVERSARY-21+FIX-ROUND-8 burst 2026-08-04). |
| ANCHOR-RESOLUTION-AXIS-NOT-APPLIED | spec integrity | MEDIUM | OPEN — FIXED in ADV-6-7-8-FIX-BURST (S-626-1 v1.8 added bcs:["BC-5.3.001","BC-5.3.002"]). Root cause: no CI guard checks story frontmatter anchor completeness. Recurrence risk HIGH. |
| NAMED-BACKGROUND-SUBAGENT-REPORT-LOSS | platform/tooling | MEDIUM | OPEN — passes 6/7/8 first dispatches were named background subagents; all spawned but never delivered final reports. |
| ORCHESTRATOR-PREMATURE-DEAD-AGENT-CONCLUSION | orchestrator process | MEDIUM | OPEN — orchestrator twice declared a background subagent "dead" before sufficient quiet time. |
| MSRV-JOB-NO-POSITIVE-COVERAGE | CI/F4 | MEDIUM | OPEN — three independent confirmations (passes 6/7/8). Routed to S-641-1 AC-1/AC-2/AC-3. |
| GITLEAKS-NOT-IN-CI-GATE-NEEDS | CI governance | MEDIUM | OPEN — intentional asymmetry (licensing complexity for forks). Tracked as acknowledged governance gap. |
| ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT | adversary process | MEDIUM | OPEN — CORRECTIVE VERIFIED EFFECTIVE (7/7 passes in windows 12/13/14 + pass-15 + pass-18 + pass-19 + pass-21 cleanly isolated). BEHAVIORAL corrective achieved; no mechanical guard yet. |
| FIX-ROUND-PARTIAL-PROPAGATION | spec process | HIGH | OPEN — SEVENTH CONSECUTIVE ROUND. Round-7 anchor migration is CLASS-ELIMINATING (first structural fix). Round-8: symbol-corpus sweep found exactly ONE broken citation (F-01 dead symbol at one site), bounding CITATION-GUARD-SRC-ONLY exposure. Domain-spec count class sweep (DEC-218) caught bc-03 simultaneously. Non-ci.yml surfaces still manually swept; anchor migration confirmed working (+3 ci.yml shift affected only demo transcripts). |
| CITATION-GUARD-SRC-ONLY | spec integrity | MEDIUM | OPEN — UPDATED (round 8): pass-21 LOW-003 shows S-BC-CITATION-GUARD-1.md itself carries raw `"live ci.yml line 111"` citations; template drift blocks the fix (DEC-217 DEFERRED). Guard must cover citation-guard story artifacts AND must be executable on template-noncompliant files (or template conformance must be prerequisite). Scope extends further than previously thought. |
| ARCH-INDEX-REGISTRY-COVERAGE-GAP | spec integrity | MEDIUM | OPEN — ARCH-INDEX.md SS-01..SS-09 registry does not cover `scripts/`, `tests/`, or `.github/dependabot.yml`. Three independent adversary passes identified the gap. Registry extension story needed. |
| S-576-FAMILY-SUBSYSTEM-PATTERN | spec integrity | MEDIUM | OPEN — ROUTED to S-MAINT-576-HYG-1 (DEC-208, 2026-08-03). S-MAINT-576-HYG-1 v1.0 corrected per fix round 5. |
| KEYCHAIN-CREDENTIAL-PATH-UNCOVERED | test coverage | MEDIUM | OPEN — ADV-P9-MED-005 unique finding. `src/cli/auth/keychain.rs::resolve_credential` three-path resolution chain has no per-path pin test. Coverage story needed before S-640-1 ships. |
| FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE | spec process | MEDIUM | OPEN — UPDATED (round 8): 3 MEDIUM findings injected as false claims in documentation: wrong test name + job count in pin (MED-001); false step comment about test count (MED-002); docstring claimed pipefail assertion existed when none did (MED-003). Pattern now named by pass-21 reviewer: "a correct change landed alongside a false claim about it." Injection rate non-zero across SEVENTH consecutive round. |
| DEMO-TRANSCRIPT-FIDELITY-NO-MECHANICAL-GUARD | spec process | MEDIUM | OPEN — UPDATED (PRE-WINDOW-PREP 2026-08-04): pack now records BOTH guard paths (positive + negative); evidence asymmetry that hid unreachable diagnostic CLOSED. DEC-213 anchor migration working (+3 ci.yml shift from fix round 8 affected only demo transcripts). Still no automated guard. |
| STATE-VERDICT-LABEL-AMBIGUITY | state integrity | MEDIUM | OPEN — corrected in CORRECTIVE-VERDICT-LABEL-AMBIGUITY burst 2026-08-03. No mechanical guard exists. ROUTE upstream. |
| PASS-NUMBERING-COLLIDES-ACROSS-CYCLES | state integrity | LOW | OPEN — corrective applied: qualify pass references with cycle/story (e.g. `S-626-1 pass-19`) going forward. |
| BC-BEHAVIOR-FIELD-SYSTEMIC-ABSENCE | spec completeness | MEDIUM | OPEN — NEW (2026-08-03). ~60 of 111 BCs in bc-3-issue-write.md, 5 of 33 in bc-6-config-cache.md, and 6 in bc-5-boards-sprints.md lack `Behavior` fields. ROUTE as own story. |
| ORCHESTRATOR-PROPAGATED-FALSE-JUSTIFICATION | spec process | HIGH | OPEN — (2026-08-03). Orchestrator authored false "test-only delta, no src/ changes" justification dispatched to demo-recorder; false (--all-targets consumes tests/). F-05 FIXED in round 6. Route: PROCESS — dispatch MUST NOT include non-verified justifications. |
| TEST-JOB-ZERO-TEST-FLOOR | CI integrity | LOW | CLOSED IN-CYCLE — (2026-08-03). FIXED IN-CYCLE by product commit 9312f11f (DEC-211). |
| STORY-TEMPLATE-DRIFT-BLOCKS-EDITS | spec process | MEDIUM | SUPERSEDED by PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES (2026-08-04; broader class). First instance (S-MUTANTS-EXAMINE-GLOBS-1.md) RESOLVED 2026-08-04. Second instance (S-BC-CITATION-GUARD-1.md) DEFERRED per DEC-217. |
| ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD | orchestrator discipline | HIGH | OPEN — NEW (2026-08-04). Orchestrator shipped inert POL-11 guard (9312f11f) with false rationale. Four real CI-as-code defects caught only by adversary pass-19. PROCESS: orchestrator MUST independently execute negative proof before authorizing any guard commit. |
| ORCHESTRATOR-UNVERIFIED-BREAK-SPECULATION | orchestrator discipline | LOW | OPEN — NEW (2026-08-04). Orchestrator asserted F-03 "would have matched zero lines in CI." CI ran SUCCESS for 9312f11f, refuting the speculation. |
| CI-YML-LINE-CITATION-RIPPLE | citation hygiene | MEDIUM | CLOSED-STRUCTURALLY — UPDATED (round 8): fix round 8 caused +3 line shift; shift affected only demo transcripts (not anchor-migrated story surfaces), confirming DEC-213 migration working as designed. Retained as evidence. |
| FMT-CLIPPY-NO-POSITIVE-COVERAGE | CI integrity | MEDIUM | OPEN — ROUTED per DEC-215. Follow-up story candidate. |
| INPUT-HASH-BYPASS-MARKERS-SILENTLY-SKIP-VALIDATION | guard hygiene | MEDIUM | OPEN — `validate-input-hash.sh` `exit 0`s unconditionally on sentinel values `[pending-recompute]` and `[live-state]`; gap is no inventory or expiry for `[pending-recompute]`. ROUTE upstream to drbothen/vsdd-factory. |
| BC-02-INPUT-LINEAGE-IMPRECISE | spec provenance | LOW | OPEN — bc-02-issue-read.md inputs: now names research/RESEARCH-INDEX.md (real, checkable), but semantic lineage remains approximate. |
| AGENT-DECLINED-TO-INVENT-FRONTMATTER | process quality | INFO | CLOSED — positive datapoint (2026-08-04). Epic_id/cycle set to null with in-frontmatter comments rather than fabricated values. Evidence that "write no justification you have not verified" instruction works. |
| GUARD-BYPASSED-BY-TOOL-SUBSTITUTION | guard hygiene | MEDIUM | OPEN — NEW (2026-08-04). validate-input-hash PostToolUse hook fires on Write but NOT on Edit; using Edit tool to update just the `input-hash:` field bypasses the full-file hash recomputation guard. Observed this burst: pass-21 initial Write blocked (hash mismatch); Edit used to correct hash field directly. Edit was correct but mechanism has no integrity guarantee. ROUTE upstream. |
| PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES | spec process | MEDIUM | OPEN — NEW (2026-08-04). Pre-existing template drift (missing required frontmatter fields, missing required sections) blocks correctness fixes. First instance S-MUTANTS-EXAMINE-GLOBS-1.md RESOLVED 2026-08-04. Second instance S-BC-CITATION-GUARD-1.md DEFERRED per DEC-217. SUPERSEDES STORY-TEMPLATE-DRIFT-BLOCKS-EDITS. Route: template-compliant backfill must precede any correctness fix on template-noncompliant files. |
| CHECK-SPEC-COUNTS-COVERAGE-SCOPE | guard coverage | INFO | OPEN — NOTE (DEC-218, 2026-08-04). check-spec-counts.sh catches frontmatter bc_count vs body section-count mismatch. It does NOT catch body count vs actual BC enumeration when both frontmatter and body were set incorrectly (bc-02-issue-read.md: frontmatter 94, body 92, actual 106; bc-03: frontmatter 120, body prose 120, actual 140). Class sweep is the only coverage for the latter; no CI guard exists for domain-spec bc_count accuracy. Draft guard story candidate. |

## Convergence Status

BC-INDEX v6.75 / STORY-INDEX v1.5.58 / ARCH-INDEX v0.16. SOH-DX-1 F2 APPROVED (DEC-196, 2026-07-29): passes 82/83/84 CLEAN 3/3 at v1.3.166. F3 APPROVED (DEC-197, 2026-07-29): spec v1.3.169; BC 657; holdouts 106. S-626-1 adversary: 18 recorded passes (5 VOID + 2 NOT RUN + pass-20 SUPERSEDED per DEC-216); all NOT CLEAN; 181 total findings; window 21/22/23 CLOSED 0/1 (passes 22/23 NOT DISPATCHED); **fresh STRICT window = S-626-1 passes 22/23/24 (0/3, not yet dispatched; DEC-219); against frozen head 84ab32ac; all 3 must return CLEAN**; src/ 0-defect THIRTEENTH consecutive. AX23-001 PENDING RATIFICATION.

SOH-ATTACHMENTS-1 + prior cycles FULLY CLOSED. See cycles/cycle-001/convergence-trajectory.md.

## Concurrent Cycles

<!-- Prior completed cycles archived to burst-log: ADF-CODE-MARK-EXCLUSIVITY (DEC-163, v0.6.0-dev.8), SOH-BUGS-1 (DEC-167, v0.6.0-dev.9), SOH-COMMENT-CRUD-1 (DEC-176, v0.6.0-dev.10), SOH-ATTACHMENTS-1 (DEC-186, v0.6.0-dev.11). See cycles/cycle-001/convergence-trajectory.md. -->
| Cycle | Status | Notes |
|-------|--------|-------|
| SOH-DX-1 (issues #639+#627+#626) | F4 DELIVERY IN PROGRESS — **S-626-1 DELIVERED** (PR #667, feature HEAD 84ab32ac, **HELD — DEC-202**) | 3 stories: S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1, S-626-1 (DELIVERED). S-626-1 adversary: 18 passes (5 VOID + 2 NOT RUN per DEC-209; pass-20 SUPERSEDED per DEC-216); window 21/22/23 CLOSED 0/1; fresh STRICT window passes 22/23/24 (DEC-219, 0/3); 181 findings; THIRTEENTH zero-src/-defect. AX23-001 PENDING. |

## Session Resume Checkpoint
| Field | Value |
|-------|-------|
| Position | Feature Mode SOH-DX-1 F4 delivery. F2 APPROVED (DEC-196), F3 APPROVED (DEC-197). **S-626-1 DELIVERED** — PR #667 open, feature HEAD 84ab32ac (product commit closes pass-21 MED-001/002/003+LOW-001/002+INFO-001; LOW-003 DEFERRED per DEC-217), branch ci/fix-toolchain-sha-msrv. **HELD per DEC-202** pending fresh 3-pass window. Pass-21 NOT CLEAN (0H+3M+3L+1I; isolation CLEAN; all documentation class; THIRTEENTH zero-src/-defect). ADV-P1-INDEX v2.0 (181 findings). **DEC-219: window 21/22/23 CLOSED 0/1 (passes 22/23 NOT DISPATCHED); fresh STRICT window = S-626-1 passes 22/23/24, 0/3, not yet dispatched.** |
| Convergence | S-626-1 Step 4.5 = 0/3. 18 recorded passes (5 VOID: 3 dispatch + 2 isolation) + 2 NOT RUN (passes 16/17, DEC-209) + pass-20 SUPERSEDED (DEC-216). 181 total findings. Window 21/22/23 CLOSED 0/1. src/ 0-defect THIRTEENTH consecutive. **Fresh STRICT window: passes 22/23/24 against head 84ab32ac. All 3 must return CLEAN (DEC-191(c) conservative reading; DEC-204 UNADJUDICATED).** |
| Not yet done | (1) S-626-1 passes 22/23/24 STRICT window (DEC-219; head 84ab32ac; scoped greps; all 3 must be CLEAN). (2) S-640-1 handoff: on MSRV ≥1.88, delete `No let-chains` from CLAUDE.md Conventions AND in-code comments at `src/cli/board.rs :: handle_view`, `src/cli/issue/list.rs :: handle_list`, `src/cli/auth/keychain.rs :: resolve_credential`. (3) S-MAINT-576-HYG-1 needs scheduling. DEC-204 UNADJUDICATED. AX23-001 PENDING. |
| In flight | develop @ acdad174 (PR #667 HELD — DEC-202; head 84ab32ac). .factory @ factory-artifacts. Worktree: .worktrees/S-626-1 (branch S-626-1). Product repo untracked: .claude/hooks/, .claude/pr-reviews/, .claude/settings.local.json.bak, .claude/spec-config.json (pre-existing). |
| Pending human decisions | (1) DEC-219 fulfilled (fresh STRICT window passes 22/23/24). (2) AX23-001 out-of-delta ratification (non-blocking). (3) DEC-204 UNADJUDICATED (DEC-191(d) ceiling ruling). PR queue: #667 (HELD — DEC-202), #662 (MERGEABLE), #655-#659 (soaking), #628/#574. DO NOT close #429. |
| Resume command | Open fresh session → /vsdd-factory:next-step. Dispatch S-626-1 passes 22/23/24 concurrently (head 84ab32ac; DEC-219; scoped greps; all 3 must return CLEAN for Step 4.5 = 3/3). ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD HIGH drift item — orchestrator MUST independently execute negative proof before authorizing any guard commit. GUARD-BYPASSED-BY-TOOL-SUBSTITUTION MEDIUM — prefer Write over Edit for factory artifacts when hook validation is required. PR #667 HELD. AX23-001 PENDING. |

## RESUME PLAN (cold-start)
Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Read this file.
Step 2 — Dispatch S-626-1 passes 22/23/24 concurrently (head 84ab32ac; DEC-219; scoped greps; all 3 must return CLEAN for Step 4.5 = 3/3). If any NOT CLEAN: dispatch fix round 9. Also pending: S-640-1 handoff, S-MAINT-576-HYG-1, S-639-1 (BREAKING/v0.6.0-dev.12). PR #667 HELD until 3/3. AX23-001 PENDING. DEC-204 UNADJUDICATED.

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |

## Historical Content

See `cycles/cycle-001/`: burst-log.md, convergence-trajectory.md, session-checkpoints.md, lessons.md, blocking-issues-resolved.md.
