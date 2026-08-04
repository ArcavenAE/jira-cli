---
document_type: pipeline-state
level: ops
version: "2.6"
status: active
producer: state-manager
timestamp: 2026-08-04T21:15:00Z
phase: 3
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "ADVERSARY-24-25-26+FIX-ROUND-11 2026-08-04: S-626-1 passes 24/25/26 (P24 CLEAN/ELIGIBLE/FIRST-CLEAN; P25 CLEAN/ELIGIBLE/SECOND-CONSECUTIVE; P26 NOT CLEAN 0H+1M+2L+2I/ELIGIBLE; window 24/25/26 BROKEN 2/3; DEC-224+225+226; fix round 11 e49230a7); ADV-P1-INDEX v2.3 (197 findings). trajectory-tail →0→0→0→0. Prior: ADVERSARY-23+FIX-ROUND-10 2026-08-04: pass-23 NOT CLEAN (0H+1M+1L; FIFTEENTH zero-src/-defect; fix round 10 14416fd9); ADV-P1-INDEX v2.2 (186 findings). trajectory-tail →2→0→0→0."
trajectory_tail: "→0→0→0→0"
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

<!-- STATE.md SIZE BUDGET (2026-08-04 ADVERSARY-24-25-26+FIX-ROUND-11): 300 lines (wc-l) — prior: 294; delta: +6. Soft-target 200; margin from soft-target = +100; margin from actual to hard cap 500 = 200. New: +1 CPS row (ADVERSARY-24-25-26+FIX-ROUND-11); -1 CPS row (INPUT-HASH-BYPASS-RESOLVED archived); +3 DEC rows (DEC-224/225/226); +3 drift items (MIXED-SET-DASH-ARM-UNPINNED, WRONG-FILE-MIS-ANCHORS-IN-TESTS, COUNT-IN-PROSE-DRIFT-CLASS); 5 drift items updated in-place; Session Resume Checkpoint replaced. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →0→0→0→0 (HIGH findings per pass: P23=0H [NOT-CLEAN], P24=0H [CLEAN/FIRST-CLEAN], P25=0H [CLEAN/SECOND-CONSECUTIVE], P26=0H [NOT-CLEAN]; **S-626-1 passes 24/25/26 complete: DEC-224 ISOLATION ELIGIBILITY PRINCIPLE; P24 FIRST CLEAN VERDICT; P25 SECOND CONSECUTIVE CLEAN; P26 NOT CLEAN (MED-001 authorization trail partial propagation + 4 others); WINDOW 24/25/26 BROKEN 2/3; fresh STRICT window passes 27/28/29 (DEC-225); CI floor pin 8/8 non-comment-satisfiable SIX independent confirmations; fix round 11 applied e49230a7**; 23 recorded passes + 6 VOID + 2 NOT RUN + pass-20 SUPERSEDED; Step 4.5 = 0/3) |
| **Last Updated** | trajectory-tail →0→0→0→0 ADVERSARY-24-25-26+FIX-ROUND-11 2026-08-04: passes 24/25 CLEAN (FIRST+SECOND consecutive; ELIGIBLE); pass-26 NOT CLEAN (0H+1M+2L+2I; ELIGIBLE; window BROKEN 2/3); DEC-224 (ISOLATION ELIGIBILITY PRINCIPLE), DEC-225 (fresh STRICT window passes 27/28/29), DEC-226 (None-arm test deferred); fix round 11 e49230a7 (S-626-1 v1.16: trail corrected to 3 commits; STORY-INDEX v1.5.61: embedded bracket removed; bc-5-boards-sprints.md PC1 extended to three cell states; INDEX.md Round-12 positional corrected; ci.yml stale-docstring structural form; 17-entry numeral removed; demos re-stamped); ADV-P1-INDEX v2.3 (197 findings). Prior: ADVERSARY-23+FIX-ROUND-10 2026-08-04. |
| **Current Phase** | Feature Mode SOH-DX-1 **F4 DELIVERY IN PROGRESS**. F2 APPROVED (DEC-196), F3 APPROVED (DEC-197). **S-626-1 DELIVERED** — PR #667 open, feature HEAD e49230a7 (fix round 11), branch ci/fix-toolchain-sha-msrv; **HELD per DEC-202** (fresh 3-pass window required). Adversary: 23 recorded passes; 6 VOID (3 dispatch + 3 isolation); 2 NOT RUN (passes 16/17 per DEC-209); pass-20 SUPERSEDED (DEC-216); window 24/25/26 BROKEN 2/3 (P24 CLEAN, P25 CLEAN, P26 NOT CLEAN); **fresh STRICT window passes 27/28/29 (DEC-225), 0/3, not yet dispatched**; Step 4.5 = **0/3**. AX23-001 PENDING RATIFICATION. |
| **Next Phase** | Adversary passes 27/28/29 (head e49230a7; DEC-225; STRICT; all 3 must return CLEAN). Maintain scoped greps with PRE-FLIGHT CHECK. PR #667 HELD until 3/3 CLEAN window. Then S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; FIX-E2E-EGRESS DELIVERED; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Archived rows: see cycles/cycle-001/burst-log.md (rounds 67, 68-70; LEDGER-BURST-71-72; DEC-191-BURST; F2-CONVERGENCE-BURST; passes 75-78; DEC-192 spec fix burst; F2-CONVERGENCE-BURST final rows archived SOH-DX-1-F3-DECOMP-BURST 2026-07-29; F2-CONVERGENCE-BURST final rows archived DEC-197-BURST 2026-07-30; DEC-198-LEDGER rows archived POST-ADVERSARY-PERSISTENCE-BURST 2026-07-30; pass-84 PP row + PASS-4-PERSISTENCE-BURST CPS archived SESSION-WRAP-BURST 2026-07-30; SESSION-WRAP-BURST PP row + SESSION-WRAP-BURST CPS archived PASS-5-PERSISTENCE-BURST 2026-07-31; PASS-5-PERSISTENCE-BURST PP row archived ADV-6-7-8-FIX-BURST 2026-07-31; ADV-6-7-8-FIX-BURST PP row archived ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03; ADVERSARY-9-10-11+FIX-ROUND-3 PP row archived ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03; ADVERSARY-12-13-14+FIX-ROUND-4 PP row archived ADVERSARY-15+FIX-ROUND-5 2026-08-03; ADVERSARY-15+FIX-ROUND-5 PP row archived ADVERSARY-18+FIX-ROUND-6 2026-08-03; ADVERSARY-18+FIX-ROUND-6 PP row archived ADVERSARY-19+FIX-ROUND-7 2026-08-04; ADVERSARY-19+FIX-ROUND-7 PP row archived ADVERSARY-21+FIX-ROUND-8 2026-08-04; ADVERSARY-21+FIX-ROUND-8 PP row archived ADVERSARY-22+FIX-ROUND-9 2026-08-04; ADVERSARY-22+FIX-ROUND-9 PP row archived ADVERSARY-23+FIX-ROUND-10 2026-08-04; ADVERSARY-23+FIX-ROUND-10 PP row archived ADVERSARY-24-25-26+FIX-ROUND-11 2026-08-04) -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **ADVERSARY-24-25-26+FIX-ROUND-11 (2026-08-04): S-626-1 passes 24/25/26 (P24 CLEAN/ELIGIBLE/FIRST; P25 CLEAN/ELIGIBLE/SECOND; P26 NOT CLEAN 0H+1M+2L+2I/ELIGIBLE; window 24/25/26 BROKEN 2/3; DEC-224+225+226) — ADV-P1-INDEX v2.3 (197 findings); fix round 11 applied e49230a7; STORY-INDEX v1.5.61.** | PAUSED | 2026-08-04 | — | Window 24/25/26 BROKEN 2/3 (P24+P25 CLEAN; P26 NOT CLEAN). Fresh STRICT window: passes 27/28/29 (DEC-225) against e49230a7. PR #667 HELD (DEC-202). AX23-001 PENDING. | →0→0→0→0 |

## Current Phase Steps

<!-- Archived rows: see cycles/cycle-001/burst-log.md (SESSION-WRAP; LEDGER-BURST-71-72; DEC-191-BURST; F2-CONVERGENCE-BURST; F2-CONVERGENCE-WINDOW-BURST; DEC-192 corrective; F2-CONVERGENCE-BURST final; SOH-DX-1-F3-DECOMP-BURST 2026-07-29; DEC-197-GATE-APPROVAL-RETARGET-BURST 2026-07-30; DEC-198-LEDGER-CORRECTION-BURST 2026-07-30; POST-ADVERSARY-PERSISTENCE-BURST 2026-07-30; PASS-2-PERSISTENCE-BURST 2026-07-30; PASS-3-PERSISTENCE-BURST 2026-07-30; PASS-4-PERSISTENCE-BURST 2026-07-30; SESSION-WRAP-BURST 2026-07-30; PASS-5-PERSISTENCE-BURST 2026-07-31; ADV-6-7-8-FIX-BURST CPS archived ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03; ADVERSARY-9-10-11+FIX-ROUND-3 CPS archived ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03; ADVERSARY-12-13-14+FIX-ROUND-4 CPS archived ADVERSARY-15+FIX-ROUND-5 2026-08-03; ADVERSARY-12-13-14+FIX-ROUND-4 CPS archived ADVERSARY-18+FIX-ROUND-6 2026-08-03; CORRECTIVE-VERDICT-LABEL-AMBIGUITY CPS archived ADVERSARY-19+FIX-ROUND-7 2026-08-04; ADVERSARY-15+FIX-ROUND-5 CPS archived ADVERSARY-21+FIX-ROUND-8 2026-08-04; ADVERSARY-18+FIX-ROUND-6 CPS archived ADVERSARY-22+FIX-ROUND-9 2026-08-04; ADVERSARY-19+FIX-ROUND-7 CPS archived ADVERSARY-23+FIX-ROUND-10 2026-08-04; INPUT-HASH-BYPASS-RESOLVED CPS archived ADVERSARY-24-25-26+FIX-ROUND-11 2026-08-04) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **PRE-WINDOW-PREP (2026-08-04): S-MUTANTS-EXAMINE-GLOBS-1 v1.2→v1.3 (template conformance + anchor migration; hook unblocked). demos/S-626-1 negative-path evidence added (INFO-01 closed). STORY-INDEX v1.5.57→v1.5.58. DEC-216: window 18/19/20 CLOSED 0/2 (pass-20 SUPERSEDED); new STRICT window passes 21/22/23 not yet dispatched.** | state-manager | COMPLETED | Factory-artifacts committed. Dispatching S-626-1 passes 21/22/23 (DEC-216). |
| **ADVERSARY-21+FIX-ROUND-8 (2026-08-04): S-626-1 pass-21 (NOT CLEAN; 0H+3M+3L+1I; isolation CLEAN; THIRTEENTH zero-src/-defect; all documentation class; passes 22/23 NOT DISPATCHED) + ADV-P1-INDEX v2.0 (181 total findings) + fix round 8 (84ab32ac) + DEC-217+218+219. 3 new drift items; 5 drift items updated; STORY-TEMPLATE-DRIFT-BLOCKS-EDITS SUPERSEDED.** | state-manager | COMPLETED | S-626-1 pass-21 + fix round 8 + STATE.md committed to factory-artifacts. Next: S-626-1 passes 22/23/24 (DEC-219). |
| **ADVERSARY-22+FIX-ROUND-9 (2026-08-04): S-626-1 pass-22 (VOID — isolation breach; NOT CLEAN 0H+1M+2L; FOURTEENTH zero-src/-defect; CI floor SOUND seven dim; fix round 9 7798b1bf) + ADV-P1-INDEX v2.1 (184 total findings) + DEC-220+221. 1 new drift item (PIN-ASSERTIONS-PROSE-SATISFIABLE MEDIUM CLOSED); 3 drift items updated.** | state-manager | COMPLETED | S-626-1 pass-22 + fix round 9 + STATE.md committed to factory-artifacts. Next: S-626-1 passes 23/24/25 (DEC-221). |
| **ADVERSARY-23+FIX-ROUND-10 (2026-08-04): S-626-1 pass-23 (NOT CLEAN; 0H+1M+1L; isolation CLEAN; PRE-FLIGHT CHECK VERIFIED EFFECTIVE; FIFTEENTH zero-src/-defect; CI floor pin 8/8 non-comment-satisfiable; fix round 10 14416fd9) + ADV-P1-INDEX v2.2 (186 total findings) + DEC-222+223. 0 new drift items; 5 drift items updated.** | state-manager | COMPLETED | S-626-1 pass-23 + fix round 10 + STATE.md committed to factory-artifacts. Next: S-626-1 passes 24/25/26 (DEC-223). |
| **ADVERSARY-24-25-26+FIX-ROUND-11 (2026-08-04): S-626-1 passes 24 (CLEAN/ELIGIBLE/FIRST), 25 (CLEAN/ELIGIBLE/SECOND), 26 (NOT CLEAN 0H+1M+2L+2I/ELIGIBLE; window 24/25/26 BROKEN 2/3) + ADV-P1-INDEX v2.3 (197 total findings) + DEC-224+225+226 + fix round 11 e49230a7. 3 new drift items (MIXED-SET-DASH-ARM-UNPINNED MED, WRONG-FILE-MIS-ANCHORS-IN-TESTS LOW, COUNT-IN-PROSE-DRIFT-CLASS LOW CLOSED); 5 drift items updated.** | state-manager | COMPLETED | S-626-1 passes 24/25/26 + fix round 11 + STATE.md committed to factory-artifacts. Next: S-626-1 passes 27/28/29 (DEC-225). |

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
| DEC-220 | **PASS-22 VOIDED FOR ISOLATION BREACH (2026-08-04).** S-626-1 pass-22 dispatch used root-scoped grep at `.factory/`; leaked banned content from ADV-P1-INDEX.md and prior pass files. Third isolation breach; all three self-disclosed unprompted; all three root-scoped `.factory/` grep. VOID for window eligibility per DEC-206. Findings valid (1M+2L); all fixed in fix round 9 (7798b1bf). CI floor mechanism SOUND on seven dimensions. | Third isolation breach; DEC-206 VOID protocol applied; findings retained and fixed. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-221 | **FRESH STRICT WINDOW = PASSES 23/24/25 (2026-08-04).** Window 22/23/24 CLOSED 0/1 (pass-22 VOID+NOT CLEAN; passes 23/24 NOT DISPATCHED). Fresh STRICT window: passes 23/24/25 against feature HEAD 7798b1bf. DEC-191(c) conservative reading applies (DEC-204 UNADJUDICATED). Continuing AUTHORIZED breach of DEC-191(d) ceiling. | Pass-22 VOID closed window 22/23/24 at 0/1; new window resets. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-222 | **ANCHOR-FORM CONVENTION EXTENDED TO WORKFLOW FILES (2026-08-04).** `ci.yml :: <job-id> / "<step>"` structural-form notation extended to cover ci.yml's own self-citations (ADV-P23-MED-001 root cause: anchor migration stopped at .factory/ boundary). 10-workflow-file sweep confirmed zero other line-number citations. Eliminates residual citation-ripple vector in workflow files. | Pass-23 found stale ci.yml self-citation proving migration boundary was too narrow; sweep-to-class extended scope. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-223 | **FRESH STRICT WINDOW = PASSES 24/25/26 (2026-08-04).** Window 23/24/25 CLOSED 0/1 (pass-23 NOT CLEAN; passes 24/25 NOT DISPATCHED). Fresh STRICT window: passes 24/25/26 against feature HEAD 14416fd9. DEC-191(c) conservative reading applies (DEC-204 UNADJUDICATED). Continuing AUTHORIZED breach of DEC-191(d) ceiling. | Pass-23 NOT CLEAN closed window 23/24/25 at 0/1; new window resets against updated head. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-224 | **ISOLATION ELIGIBILITY PRINCIPLE ESTABLISHED (2026-08-04).** A pass is ELIGIBLE (not VOID) when a letter-of-rule isolation deviation occurred but zero banned content actually surfaced. VOID applies only when banned content (prior-pass verdicts, finding IDs, tallies, STATE.md/ADV-P1-INDEX.md content) actually became visible to the reviewer and could contaminate the review. Self-disclosure without surfacing is a POSITIVE signal. Applied retroactively to passes 24/25/26 (all ELIGIBLE). | Principled distinction: the rule prevents contamination, not path syntax deviation. Three consecutive ELIGIBLE passes validate the principle. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-225 | **FRESH STRICT WINDOW = PASSES 27/28/29 (2026-08-04).** Window 24/25/26 CLOSED 2/3 (pass-24 CLEAN/ELIGIBLE, pass-25 CLEAN/ELIGIBLE, pass-26 NOT CLEAN/ELIGIBLE; window BROKEN). Fresh STRICT window: passes 27/28/29 against feature HEAD e49230a7 (fix round 11). DEC-191(c) conservative reading applies (DEC-204 UNADJUDICATED). Continuing AUTHORIZED breach of DEC-191(d) ceiling. **NOTE: window 24/25/26 is the FIRST window to produce CLEAN verdicts in the entire S-626-1 cycle.** | Pass-26 NOT CLEAN closed window 24/25/26 at 2/3; new window resets against updated head. Fix round 11 closes P26-MED-001 (authorization trail) + P24-LOW-001 + P25-LOW-001/002+INFO-001/002 + P26 concurrences; P26-LOW-002 (wrong-file mis-anchor) ROUTED. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-226 | **MIXED-SET-DASH-ARM TEST DEFERRED (2026-08-04; ADV-P25-LOW-003).** BC-5.3.001 Postcondition 1 spec FIXED this burst (bc-5-boards-sprints.md: three-state cell enumeration — (a) resolved name, (b) raw UUID on cache miss, (c) literal "-" when team_id=None mixed-set). Test coverage for the None arm (MIXED-SET-DASH-ARM-UNPINNED drift item) deferred to a follow-up story. The spec fix alone closes the LOW finding; test coverage is a separate engineering task. | Scope principle: spec accuracy fix and test coverage fix are separable; spec fix unblocks the window. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI + S-626-1 per-AC demos: Yes — adapted (S-626-1: 11 artifacts at `.factory/demos/S-626-1/`). See cycles/cycle-001/burst-log.md.

## Blocking Issues

None open.

## Drift Items (open / tracked)

<!-- 10 items archived 2026-07-25; 22 items archived through 2026-07-29 (see blocking-issues-resolved.md); 5 ACCEPTED/MITIGATED/FIXED items archived SOH-DX-1-F3-DECOMP-BURST 2026-07-29. ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03: 6 new items added. ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03: 4 items updated; 2 new items. CORRECTIVE-VERDICT-LABEL-AMBIGUITY 2026-08-03: 2 new items. ADVERSARY-15+FIX-ROUND-5 2026-08-03: 1 new item; 4 updated. ADVERSARY-18+FIX-ROUND-6 2026-08-03: 3 new items; 3 updated. ADVERSARY-19+FIX-ROUND-7 2026-08-04: 4 new items; 4 updated. INPUT-HASH-BYPASS-RESOLVED 2026-08-04: 2 new items; 1 updated. PRE-WINDOW-PREP 2026-08-04: 3 updated; 1 new INFO CLOSED. ADVERSARY-21+FIX-ROUND-8 2026-08-04: 3 new items; 5 updated. ADVERSARY-22+FIX-ROUND-9 2026-08-04: 1 new item; 3 updated. ADVERSARY-23+FIX-ROUND-10 2026-08-04: 0 new items; 5 updated. ADVERSARY-24-25-26+FIX-ROUND-11 2026-08-04: 3 new items (MIXED-SET-DASH-ARM-UNPINNED MED, WRONG-FILE-MIS-ANCHORS-IN-TESTS LOW, COUNT-IN-PROSE-DRIFT-CLASS LOW CLOSED-BY-REMOVAL); 5 updated (ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD, FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE, FIX-ROUND-PARTIAL-PROPAGATION, REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED, ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT). -->
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
| REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED | adversary process | MEDIUM | OPEN — UPDATED (2026-08-04 passes 24/25/26). Passes 24/25/26 all ELIGIBLE (three letter-of-rule deviations; zero banned content surfaced; DEC-224 ISOLATION ELIGIBILITY PRINCIPLE). PRE-FLIGHT CHECK corrective VERIFIED EFFECTIVE for four consecutive passes (23/24/25/26). Mechanical guard still needed. ROUTE upstream. |
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
| ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE | adversary process | MEDIUM | OPEN (all 23 passes + 2 NOT RUN stubs now captured through pass-26; pass-20 SUPERSEDED noted; pass-22 VOID + pass-23 NOT CLEAN + passes 24/25 CLEAN + pass-26 NOT CLEAN captured in ADVERSARY-24-25-26+FIX-ROUND-11 burst 2026-08-04). |
| ANCHOR-RESOLUTION-AXIS-NOT-APPLIED | spec integrity | MEDIUM | OPEN — FIXED in ADV-6-7-8-FIX-BURST (S-626-1 v1.8 added bcs:["BC-5.3.001","BC-5.3.002"]). Root cause: no CI guard checks story frontmatter anchor completeness. Recurrence risk HIGH. |
| NAMED-BACKGROUND-SUBAGENT-REPORT-LOSS | platform/tooling | MEDIUM | OPEN — passes 6/7/8 first dispatches were named background subagents; all spawned but never delivered final reports. |
| ORCHESTRATOR-PREMATURE-DEAD-AGENT-CONCLUSION | orchestrator process | MEDIUM | OPEN — orchestrator twice declared a background subagent "dead" before sufficient quiet time. |
| MSRV-JOB-NO-POSITIVE-COVERAGE | CI/F4 | MEDIUM | OPEN — three independent confirmations (passes 6/7/8). Routed to S-641-1 AC-1/AC-2/AC-3. |
| GITLEAKS-NOT-IN-CI-GATE-NEEDS | CI governance | MEDIUM | OPEN — intentional asymmetry (licensing complexity for forks). Tracked as acknowledged governance gap. |
| ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT | adversary process | MEDIUM | OPEN — UPDATED (2026-08-04 passes 24/25/26). General prohibition held for passes 12-23 (12/12 isolation CLEAN or ELIGIBLE) and passes 24/25/26 (three ELIGIBLE per DEC-224). PRE-FLIGHT CHECK + explicit search-root whitelist corrective VERIFIED EFFECTIVE for FOUR consecutive passes (23/24/25/26). Durable fix is in corrective text; mechanical isolation guard still needed. ROUTE upstream. |
| FIX-ROUND-PARTIAL-PROPAGATION | spec process | HIGH | OPEN — EIGHTH CONSECUTIVE ROUND. Round-11: ADV-P26-MED-001 authorization trail named only 1 of 3 commits (textbook partial propagation: fix applied to trail entry but sweep stopped before verifying all three sibling files). Fixed fix round 11 (S-626-1 v1.16: trail corrected to 3 commits; 148a9489 false commit removed — self-caught by story-writer during verification). Round-7 anchor migration CLASS-ELIMINATING; rounds 8-11 each found one new instance in documentation-class artifacts. |
| CITATION-GUARD-SRC-ONLY | spec integrity | MEDIUM | OPEN — UPDATED (round 8): pass-21 LOW-003 shows S-BC-CITATION-GUARD-1.md itself carries raw `"live ci.yml line 111"` citations; template drift blocks the fix (DEC-217 DEFERRED). Guard must cover citation-guard story artifacts AND must be executable on template-noncompliant files (or template conformance must be prerequisite). Scope extends further than previously thought. |
| ARCH-INDEX-REGISTRY-COVERAGE-GAP | spec integrity | MEDIUM | OPEN — ARCH-INDEX.md SS-01..SS-09 registry does not cover `scripts/`, `tests/`, or `.github/dependabot.yml`. Three independent adversary passes identified the gap. Registry extension story needed. |
| S-576-FAMILY-SUBSYSTEM-PATTERN | spec integrity | MEDIUM | OPEN — ROUTED to S-MAINT-576-HYG-1 (DEC-208, 2026-08-03). S-MAINT-576-HYG-1 v1.0 corrected per fix round 5. |
| KEYCHAIN-CREDENTIAL-PATH-UNCOVERED | test coverage | MEDIUM | OPEN — ADV-P9-MED-005 unique finding. `src/cli/auth/keychain.rs::resolve_credential` three-path resolution chain has no per-path pin test. Coverage story needed before S-640-1 ships. |
| FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE | spec process | MEDIUM | OPEN — UPDATED (round 11): fix round 11 injected zero new defects (pass-26 findings are pre-existing or prior-round residuals; P26-LOW-002 pre-existing wrong-file mis-anchor is outside S-626-1 diff). Injection rate: rounds 4-9: 6/3/4/2/1/0; rounds 10-11: 0/0. THREE consecutive zero-injection rounds. Class shift confirmed: all recent findings are pre-existing defects, not fix-round regressions. |
| DEMO-TRANSCRIPT-FIDELITY-NO-MECHANICAL-GUARD | spec process | MEDIUM | OPEN — UPDATED (PRE-WINDOW-PREP 2026-08-04): pack now records BOTH guard paths (positive + negative); evidence asymmetry that hid unreachable diagnostic CLOSED. DEC-213 anchor migration working. Still no automated guard. |
| STATE-VERDICT-LABEL-AMBIGUITY | state integrity | MEDIUM | OPEN — corrected in CORRECTIVE-VERDICT-LABEL-AMBIGUITY burst 2026-08-03. No mechanical guard exists. ROUTE upstream. |
| PASS-NUMBERING-COLLIDES-ACROSS-CYCLES | state integrity | LOW | OPEN — corrective applied: qualify pass references with cycle/story (e.g. `S-626-1 pass-19`) going forward. |
| BC-BEHAVIOR-FIELD-SYSTEMIC-ABSENCE | spec completeness | MEDIUM | OPEN — NEW (2026-08-03). ~60 of 111 BCs in bc-3-issue-write.md, 5 of 33 in bc-6-config-cache.md, and 6 in bc-5-boards-sprints.md lack `Behavior` fields. ROUTE as own story. |
| ORCHESTRATOR-PROPAGATED-FALSE-JUSTIFICATION | spec process | HIGH | OPEN — (2026-08-03). Orchestrator authored false "test-only delta, no src/ changes" justification dispatched to demo-recorder; false (--all-targets consumes tests/). F-05 FIXED in round 6. Route: PROCESS — dispatch MUST NOT include non-verified justifications. |
| TEST-JOB-ZERO-TEST-FLOOR | CI integrity | LOW | CLOSED IN-CYCLE — (2026-08-03). FIXED IN-CYCLE by product commit 9312f11f (DEC-211). |
| STORY-TEMPLATE-DRIFT-BLOCKS-EDITS | spec process | MEDIUM | SUPERSEDED by PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES (2026-08-04; broader class). First instance (S-MUTANTS-EXAMINE-GLOBS-1.md) RESOLVED 2026-08-04. Second instance (S-BC-CITATION-GUARD-1.md) DEFERRED per DEC-217. |
| ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD | orchestrator discipline | HIGH | OPEN — UPDATED (2026-08-04 passes 24/25/26). SIX independent sound audits of POL-11 pin assertions across passes 21/22/23/24/25/26; all confirm non-comment-satisfiable (8/8 PASS). Three consecutive fix rounds (10/11/12-pending) producing zero pin-regression findings. Recommend downgrade to MEDIUM at next gate if passes 27/28/29 confirm. |
| ORCHESTRATOR-UNVERIFIED-BREAK-SPECULATION | orchestrator discipline | LOW | OPEN — NEW (2026-08-04). Orchestrator asserted F-03 "would have matched zero lines in CI." CI ran SUCCESS for 9312f11f, refuting the speculation. |
| CI-YML-LINE-CITATION-RIPPLE | citation hygiene | MEDIUM | CLOSED-STRUCTURALLY — UPDATED (round 10): closure was INCOMPLETE at round 8 because anchor migration stopped at the .factory/ boundary. Pass-23 caught the stale ci.yml self-citation. Fixed by round 10 (DEC-222). 10-workflow-file sweep confirmed zero remaining line-number citations. Class fully closed across both .factory/ and ci.yml surfaces. |
| FMT-CLIPPY-NO-POSITIVE-COVERAGE | CI integrity | MEDIUM | OPEN — ROUTED per DEC-215. Follow-up story candidate. |
| INPUT-HASH-BYPASS-MARKERS-SILENTLY-SKIP-VALIDATION | guard hygiene | MEDIUM | OPEN — `validate-input-hash.sh` `exit 0`s unconditionally on sentinel values `[pending-recompute]` and `[live-state]`; gap is no inventory or expiry for `[pending-recompute]`. ROUTE upstream to drbothen/vsdd-factory. |
| BC-02-INPUT-LINEAGE-IMPRECISE | spec provenance | LOW | OPEN — bc-02-issue-read.md inputs: now names research/RESEARCH-INDEX.md (real, checkable), but semantic lineage remains approximate. |
| AGENT-DECLINED-TO-INVENT-FRONTMATTER | process quality | INFO | CLOSED — positive datapoint (2026-08-04). Epic_id/cycle set to null with in-frontmatter comments rather than fabricated values. |
| GUARD-BYPASSED-BY-TOOL-SUBSTITUTION | guard hygiene | MEDIUM | OPEN — NEW (2026-08-04). validate-input-hash PostToolUse hook fires on Write but NOT on Edit; using Edit tool to update just the `input-hash:` field bypasses the full-file hash recomputation guard. ROUTE upstream. |
| PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES | spec process | MEDIUM | OPEN — NEW (2026-08-04). Pre-existing template drift blocks correctness fixes. First instance S-MUTANTS-EXAMINE-GLOBS-1.md RESOLVED 2026-08-04. Second instance S-BC-CITATION-GUARD-1.md DEFERRED per DEC-217. SUPERSEDES STORY-TEMPLATE-DRIFT-BLOCKS-EDITS. |
| CHECK-SPEC-COUNTS-COVERAGE-SCOPE | guard coverage | INFO | OPEN — NOTE (DEC-218, 2026-08-04). check-spec-counts.sh catches frontmatter bc_count vs body section-count mismatch but NOT body count vs actual BC enumeration. Class sweep is the only coverage for the latter. |
| PIN-ASSERTIONS-PROSE-SATISFIABLE | guard integrity | MEDIUM | CLOSED — ADV-P22-MED-001: fixed fix round 9 (7798b1bf). Pass-23 independently verified all 8 assertions non-comment-satisfiable (8/8 PASS). Passes 24/25/26 each independently confirmed (SIX total confirmations). |
| MIXED-SET-DASH-ARM-UNPINNED | test coverage | MEDIUM | OPEN — NEW (2026-08-04; ADV-P25-LOW-003). BC-5.3.001 Postcondition 1 now enumerates three cell states (spec fixed this burst). The None arm (team_id=None in mixed result set → literal "-") has no dedicated pin test. Test coverage deferred per DEC-226. Draft test story candidate. |
| WRONG-FILE-MIS-ANCHORS-IN-TESTS | citation hygiene | LOW | OPEN — NEW (2026-08-04; ADV-P26-LOW-002). `tests/issue_view_errors.rs:142` cites `list.rs:947` for a string at `view.rs:264/269`; `tests/team_object_shape.rs` cites `list.rs:983` for a call at `~528`. Pre-existing outside S-626-1 diff; spec layer correct; test comment docstrings are unswept siblings. Sweep needed. |
| COUNT-IN-PROSE-DRIFT-CLASS | spec process | LOW | CLOSED-BY-REMOVAL — NEW (2026-08-04; ADV-P25-LOW-001 + ADV-P26-LOW-001). "17-entry" examine_globs numeral cited in two live sites. Corrective: remove numeral rather than correct it. Fix round 11 applied. CLASS LESSON: prefer structural assertions over prose count claims. |

## Convergence Status

BC-INDEX v6.75 / STORY-INDEX v1.5.61 / ARCH-INDEX v0.16. SOH-DX-1 F2 APPROVED (DEC-196, 2026-07-29): passes 82/83/84 CLEAN 3/3 at v1.3.166. F3 APPROVED (DEC-197, 2026-07-29): spec v1.3.169; BC 657; holdouts 106. S-626-1 adversary: 23 recorded passes (6 VOID: 3 dispatch + 3 isolation; pass-20 SUPERSEDED per DEC-216); 6 NOT CLEAN; 2 CLEAN (passes 24/25); pass-26 NOT CLEAN; 197 total findings; window 24/25/26 BROKEN 2/3 (P24 CLEAN/ELIGIBLE, P25 CLEAN/ELIGIBLE, P26 NOT CLEAN/ELIGIBLE); **fresh STRICT window = S-626-1 passes 27/28/29 (0/3, not yet dispatched; DEC-225); against frozen head e49230a7 (fix round 11); all 3 must return CLEAN**; src/ 0-defect EIGHTEENTH consecutive; CI floor pin 8/8 assertions non-comment-satisfiable SIX independent confirmations; FIRST CLEAN VERDICTS IN CYCLE at passes 24/25; DEC-224 ISOLATION ELIGIBILITY PRINCIPLE established. AX23-001 PENDING RATIFICATION.

SOH-ATTACHMENTS-1 + prior cycles FULLY CLOSED. See cycles/cycle-001/convergence-trajectory.md.

## Concurrent Cycles

<!-- Prior completed cycles archived to burst-log: ADF-CODE-MARK-EXCLUSIVITY (DEC-163, v0.6.0-dev.8), SOH-BUGS-1 (DEC-167, v0.6.0-dev.9), SOH-COMMENT-CRUD-1 (DEC-176, v0.6.0-dev.10), SOH-ATTACHMENTS-1 (DEC-186, v0.6.0-dev.11). See cycles/cycle-001/convergence-trajectory.md. -->
| Cycle | Status | Notes |
|-------|--------|-------|
| SOH-DX-1 (issues #639+#627+#626) | F4 DELIVERY IN PROGRESS — **S-626-1 DELIVERED** (PR #667, feature HEAD e49230a7 fix round 11, **HELD — DEC-202**) | 3 stories: S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1, S-626-1 (DELIVERED). S-626-1 adversary: 23 passes (6 VOID + 2 NOT RUN per DEC-209; pass-20 SUPERSEDED per DEC-216); window 24/25/26 BROKEN 2/3 (P24+P25 CLEAN; P26 NOT CLEAN); fresh STRICT window passes 27/28/29 (DEC-225, 0/3); 197 findings; EIGHTEENTH zero-src/-defect. AX23-001 PENDING. |

## Session Resume Checkpoint
| Field | Value |
|-------|-------|
| Position | Feature Mode SOH-DX-1 F4 delivery. F2 APPROVED (DEC-196), F3 APPROVED (DEC-197). **S-626-1 DELIVERED** — PR #667 open, feature HEAD e49230a7 (fix round 11: S-626-1 v1.16 authorization trail corrected; STORY-INDEX v1.5.61; bc-5-boards-sprints.md PC1 three cell states; INDEX.md Round-12 positional fix; ci.yml stale-docstring structural form; 17-entry numeral removed; demos re-stamped), branch ci/fix-toolchain-sha-msrv. **HELD per DEC-202** pending fresh 3-pass window. Passes 24/25 CLEAN (ELIGIBLE; FIRST+SECOND consecutive clean verdicts). Pass-26 NOT CLEAN (0H+1M+2L+2I; ELIGIBLE; P26-MED-001 authorization trail fixed; P26-LOW-002 ROUTED). Window 24/25/26 BROKEN 2/3. ADV-P1-INDEX v2.3 (197 findings). **DEC-225: fresh STRICT window = S-626-1 passes 27/28/29, 0/3, not yet dispatched.** DEC-224 ISOLATION ELIGIBILITY PRINCIPLE established. |
| Convergence | S-626-1 Step 4.5 = 0/3. 23 recorded passes (6 VOID: 3 dispatch + 3 isolation) + 2 NOT RUN (passes 16/17, DEC-209) + pass-20 SUPERSEDED (DEC-216). 197 total findings. Window 24/25/26 BROKEN 2/3. src/ 0-defect EIGHTEENTH consecutive. **Fresh STRICT window: passes 27/28/29 against head e49230a7. All 3 must return CLEAN (DEC-191(c) conservative reading; DEC-204 UNADJUDICATED).** |
| Not yet done | (1) S-626-1 passes 27/28/29 STRICT window (DEC-225; head e49230a7; scoped greps with PRE-FLIGHT CHECK; all 3 must be CLEAN). (2) S-640-1 handoff: on MSRV >=1.88, delete `No let-chains` from CLAUDE.md Conventions AND in-code comments at `src/cli/board.rs :: handle_view`, `src/cli/issue/list.rs :: handle_list`, `src/cli/auth/keychain.rs :: resolve_credential`. (3) S-MAINT-576-HYG-1 needs scheduling. (4) MIXED-SET-DASH-ARM-UNPINNED test story needed (DEC-226). DEC-204 UNADJUDICATED. AX23-001 PENDING. |
| In flight | develop @ acdad174 (PR #667 HELD — DEC-202; head e49230a7). .factory @ factory-artifacts. Worktree: .worktrees/S-626-1 (branch S-626-1). Product repo untracked: .claude/hooks/, .claude/pr-reviews/, .claude/settings.local.json.bak, .claude/spec-config.json (pre-existing). |
| Pending human decisions | (1) DEC-225: fresh STRICT window passes 27/28/29 now ready to dispatch. (2) AX23-001 out-of-delta ratification (non-blocking). (3) DEC-204 UNADJUDICATED (DEC-191(d) ceiling ruling). PR queue: #667 (HELD — DEC-202), #662 (MERGEABLE), #655-#659 (soaking), #628/#574. DO NOT close #429. |
| Resume command | Open fresh session → /vsdd-factory:next-step. Dispatch S-626-1 passes 27/28/29 concurrently (head e49230a7; DEC-225; scoped greps with PRE-FLIGHT CHECK; all 3 must return CLEAN for Step 4.5 = 3/3). DEC-224 ISOLATION ELIGIBILITY PRINCIPLE: ELIGIBLE (not VOID) when nothing surfaced. ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD HIGH — six independent sound audits (recommend downgrade if passes 27/28/29 all confirm). PR #667 HELD. AX23-001 PENDING. |

## RESUME PLAN (cold-start)
Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Read this file.
Step 2 — Dispatch S-626-1 passes 27/28/29 concurrently (head e49230a7; DEC-225; scoped greps with PRE-FLIGHT CHECK; all 3 must return CLEAN for Step 4.5 = 3/3). If any NOT CLEAN: dispatch fix round 12. Also pending: S-640-1 handoff, S-MAINT-576-HYG-1, S-639-1 (BREAKING/v0.6.0-dev.12). PR #667 HELD until 3/3. AX23-001 PENDING. DEC-204 UNADJUDICATED. MIXED-SET-DASH-ARM-UNPINNED test story (DEC-226) to schedule.

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |

## Historical Content

See `cycles/cycle-001/`: burst-log.md, convergence-trajectory.md, session-checkpoints.md, lessons.md, blocking-issues-resolved.md.
