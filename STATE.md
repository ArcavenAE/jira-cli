---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-08-03T20:30:00Z
phase: 3
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "CORRECTIVE-VERDICT-LABEL-AMBIGUITY 2026-08-03: terminology fix — S-626-1 pass-12/13/14 verdict labels corrected from (CLEAN; 0H) shorthand to (NOT CLEAN; 0H; isolation CLEAN) throughout STATE.md; STATE-VERDICT-LABEL-AMBIGUITY + PASS-NUMBERING-COLLIDES-ACROSS-CYCLES drift items added. ADV-P1-INDEX confirmed NOT CLEAN ×3, window 0/3 — no changes needed. No substantive change. Prior step: ADVERSARY-12-13-14+FIX-ROUND-4 (ADV-P1-INDEX v1.6, 139 findings, fix round 4, DEC-207+208, product commit c88374b4). trajectory-tail →2→0→0→0 D-1..D-33 (exhaustive)."
trajectory_tail: "→2→0→0→0"
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

<!-- STATE.md SIZE BUDGET (2026-08-03 CORRECTIVE-VERDICT-LABEL-AMBIGUITY): 261 lines (wc-l) — prior: 258; delta: +3. Soft-target 200; margin from soft-target = +61; margin from actual to hard cap 500 = 239. Compaction: none. Added CORRECTIVE-VERDICT-LABEL-AMBIGUITY CPS row (+1). Added STATE-VERDICT-LABEL-AMBIGUITY + PASS-NUMBERING-COLLIDES-ACROSS-CYCLES drift items (+2). Updated REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED terminology (isolation CLEAN qualified). -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →2→0→0→0 (HIGH findings per pass: P11=2H [VOID], P12=0H [NOT-CLEAN], P13=0H [NOT-CLEAN], P14=0H [NOT-CLEAN]; Step 4.5 = 0/3; 14 recorded passes + 5 VOID; DEC-207: ceiling breach authorized — grind to 15/16/17; SEVERITY DECAY CONFIRMED 4H→0H) |
| **Last Updated** | trajectory-tail →2→0→0→0 CORRECTIVE-VERDICT-LABEL-AMBIGUITY 2026-08-03: relabeled S-626-1 pass-12 (NOT CLEAN; 0H+5M+5L; isolation CLEAN), S-626-1 pass-13 (NOT CLEAN; 0H+4M+6L; isolation CLEAN), S-626-1 pass-14 (NOT CLEAN; 0H+4M+5L; isolation CLEAN); 2 drift items added. Prior: ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03 — window 12/13/14 COMPLETE = 0/3 NOT CLEAN; ZERO HIGH three consecutive; code 0-defect nine consecutive passes (6–14 minus VOID 9+11); fix round 4 applied (demos/ 11 artifacts, bc-5, S-641-1 v0.7, S-576-5 v1.48, S-626-1 v1.10, STORY-INDEX v1.5.54, S-MAINT-576-HYG-1 new); ADV-P1-INDEX v1.6 (139 findings); DEC-207+208; grep-hygiene corrective VERIFIED EFFECTIVE (3/3 passes isolation CLEAN). |
| **Current Phase** | Feature Mode SOH-DX-1 **F4 DELIVERY IN PROGRESS**. F2 APPROVED (DEC-196), F3 APPROVED (DEC-197). **S-626-1 DELIVERED** — PR #667 open, feature HEAD c88374b4, branch ci/fix-toolchain-sha-msrv; **HELD per DEC-202** (fresh 3-pass window required). Adversary: 14 passes recorded; 5 VOID (3 dispatch + 2 isolation); window 12/13/14 COMPLETE = **0/3 NOT CLEAN**; Step 4.5 = **0/3**; DEC-207 CEILING BREACH AUTHORIZED — grind to passes 15/16/17. Fix round 4 applied 2026-08-03. AX23-001 PENDING RATIFICATION. |
| **Next Phase** | Adversary passes 15/16/17 (fresh window on amended state per DEC-202 + DEC-207). Grep-hygiene corrective verified effective — maintain scoped greps. PR #667 HELD until 3/3 CLEAN window. Then S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; FIX-E2E-EGRESS DELIVERED; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Archived rows: see cycles/cycle-001/burst-log.md (rounds 67, 68-70; LEDGER-BURST-71-72; DEC-191-BURST; F2-CONVERGENCE-BURST; passes 75-78; DEC-192 spec fix burst; F2-CONVERGENCE-BURST final rows archived SOH-DX-1-F3-DECOMP-BURST 2026-07-29; F2-CONVERGENCE-BURST final rows archived DEC-197-BURST 2026-07-30; DEC-198-LEDGER rows archived POST-ADVERSARY-PERSISTENCE-BURST 2026-07-30; pass-84 PP row + PASS-4-PERSISTENCE-BURST CPS archived SESSION-WRAP-BURST 2026-07-30; SESSION-WRAP-BURST PP row + SESSION-WRAP-BURST CPS archived PASS-5-PERSISTENCE-BURST 2026-07-31; PASS-5-PERSISTENCE-BURST PP row + PASS-5-PERSISTENCE-BURST CPS archived ADV-6-7-8-FIX-BURST 2026-07-31; ADV-6-7-8-FIX-BURST PP row archived ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03; ADVERSARY-9-10-11+FIX-ROUND-3 PP row archived ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03) -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **ADVERSARY-12-13-14+FIX-ROUND-4 (2026-08-03): S-626-1 pass-12 (NOT CLEAN; 0H+5M+5L; isolation CLEAN; grep-hygiene EFFECTIVE), S-626-1 pass-13 (NOT CLEAN; 0H+4M+6L; isolation CLEAN), S-626-1 pass-14 (NOT CLEAN; 0H+4M+5L; isolation CLEAN) — ADV-P1-INDEX v1.6 (139 findings); window 12/13/14 COMPLETE = 0/3 NOT CLEAN; ZERO HIGH three consecutive; fix round 4 applied; DEC-207+208; FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE + DEMO-TRANSCRIPT-FIDELITY-NO-MECHANICAL-GUARD new drift items. STORY-INDEX v1.5.54.** | PAUSED | 2026-08-03 | — | Passes 15/16/17 next (maintain scoped greps). PR #667 HELD (DEC-202). AX23-001 PENDING. | →2→0→0→0 |

## Current Phase Steps

<!-- Archived rows: see cycles/cycle-001/burst-log.md (SESSION-WRAP; LEDGER-BURST-71-72; DEC-191-BURST; F2-CONVERGENCE-BURST; F2-CONVERGENCE-WINDOW-BURST; DEC-192 corrective; F2-CONVERGENCE-BURST final; SOH-DX-1-F3-DECOMP-BURST 2026-07-29; DEC-197-GATE-APPROVAL-RETARGET-BURST 2026-07-30; DEC-198-LEDGER-CORRECTION-BURST 2026-07-30; POST-ADVERSARY-PERSISTENCE-BURST 2026-07-30; PASS-2-PERSISTENCE-BURST 2026-07-30; PASS-3-PERSISTENCE-BURST 2026-07-30; PASS-4-PERSISTENCE-BURST 2026-07-30; SESSION-WRAP-BURST 2026-07-30; PASS-5-PERSISTENCE-BURST 2026-07-31; ADV-6-7-8-FIX-BURST CPS archived ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03; ADVERSARY-9-10-11+FIX-ROUND-3 CPS archived ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **ADVERSARY-12-13-14+FIX-ROUND-4 (2026-08-03): S-626-1 pass-12 (NOT CLEAN; 0H+5M+5L; isolation CLEAN; input-hash addcd09) + S-626-1 pass-13 (NOT CLEAN; 0H+4M+6L; isolation CLEAN; input-hash addcd09) + S-626-1 pass-14 (NOT CLEAN; 0H+4M+5L; isolation CLEAN; input-hash addcd09) + ADV-P1-INDEX v1.6 (139 total findings) + fix round 4 + product commit c88374b4 recorded + STATE.md committed to factory-artifacts. DEC-207+208. 2 new drift items.** | state-manager | COMPLETED | passes 12+13+14 + fix round 4 + STATE.md committed to factory-artifacts. Next: passes 15/16/17 (maintain scoped greps). |
| **CORRECTIVE-VERDICT-LABEL-AMBIGUITY (2026-08-03): S-626-1 pass-12/13/14 verdict labels corrected from (CLEAN; 0H) shorthand to (NOT CLEAN; 0H; isolation CLEAN) throughout STATE.md. ADV-P1-INDEX confirmed NOT CLEAN ×3, 0/3 window — no changes required. STATE-VERDICT-LABEL-AMBIGUITY + PASS-NUMBERING-COLLIDES-ACROSS-CYCLES drift items added. REVIEW-ISOLATION isolation labels qualified. 261 lines.** | state-manager | COMPLETED | Terminology fix only. No substantive change. Next: S-626-1 passes 15/16/17 (maintain scoped greps). |

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
| DEC-205 | **CEILING BREACH AUTHORIZED (human, 2026-08-03).** DEC-191(d) ceiling of 10 passes breached (11 recorded including VOIDs). Human authorized continued grinding to passes 12/13/14 to achieve the required 3/3 CLEAN window. DEC-199 GRIND mandate continues in force. Window still requires 3 consecutive WINDOW-ELIGIBLE CLEAN passes. | Human authorized past ceiling given active fix rounds and convergence progress. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-206 | **VOID PROTOCOL FOR ISOLATION BREACHES (human, 2026-08-03).** Adversary passes where orchestrator dispatch defects leak banned-path content are VOID for step-4.5 window eligibility; findings remain valid and must be tracked for fix-round purposes. Applied to pass-9 (VOID-9A) and pass-11 (VOID-11A). Root cause tracked as ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT. | Human ruling on isolation protocol; findings not discarded, window-eligibility voided. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-207 | **ROUND 4 + PASSES 15/16/17 AUTHORIZED (2026-08-03).** DEC-191(d) ceiling of 10 was 14 recorded passes ago; window 12/13/14 = 0/3 NOT CLEAN; severity decay 4H→0H confirmed; grep-hygiene corrective verified effective. Human authorized grind to window 15/16/17 after fix round 4 is applied. DEC-199 GRIND mandate continues. | Human authorized continued grinding given zero-HIGH severity decay and effective grep-hygiene corrective. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-208 | **S-576 FAMILY DRIFT ROUTED AS S-MAINT-576-HYG-1 (2026-08-03).** ADV-P13-MED-004 status drift (4 S-576 story files carry "ready" status while STORY-INDEX carries "completed" for same entries) is NOT in-delta for S-626-1; routed to new maintenance story S-MAINT-576-HYG-1 (retroactive S-576 family hygiene: status drift, subsystem corrections, delivered/completed convention). | Scope separation: S-576 family hygiene is maintenance work, not part of SOH-DX-1 F4 delivery. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI + S-626-1 per-AC demos: Yes — adapted (S-626-1: 11 artifacts at `.factory/demos/S-626-1/`). See cycles/cycle-001/burst-log.md.

## Blocking Issues

None open.

## Drift Items (open / tracked)

<!-- 10 items archived 2026-07-25; 22 items archived through 2026-07-29 (see blocking-issues-resolved.md); 5 ACCEPTED/MITIGATED/FIXED items archived SOH-DX-1-F3-DECOMP-BURST 2026-07-29. ADVERSARY-9-10-11+FIX-ROUND-3 2026-08-03: 6 new items added. ADVERSARY-12-13-14+FIX-ROUND-4 2026-08-03: ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT updated (CORRECTIVE VERIFIED EFFECTIVE); FIX-ROUND-PARTIAL-PROPAGATION refined; S-576-FAMILY-SUBSYSTEM-PATTERN updated (ROUTED to S-MAINT-576-HYG-1 DEC-208); REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED updated; 2 new items added. CORRECTIVE-VERDICT-LABEL-AMBIGUITY 2026-08-03: REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED terminology qualified (isolation CLEAN); 2 new items (STATE-VERDICT-LABEL-AMBIGUITY, PASS-NUMBERING-COLLIDES-ACROSS-CYCLES). -->
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
| AGENT-IDLE-NO-REPORT | platform defect #47936 (background subagents 14-30% fail mid-work). NOTE (DEC-198): adversary-specific failures re-attributed to orchestrator malformed dispatch; other agent types remain attributed to #47936. | MEDIUM | OPEN — route to Anthropic |
| PO-REPORT-FIDELITY | product-owner reported fabricated changelog-count line. | LOW | OPEN — dispatch-discipline |
| VP-INDEX-ARTIFACT-ABSENT | VP-INDEX is canonical VSDD artifact. Fold into VSDD-CONFORMANCE-GAP-4-ARTIFACTS. DEC-195. | LOW | OPEN — pending DEC-195 bundle |
| INPUT-HASH-DRIFT-BACKLOG-56 | 56 artifacts stale on input-hash across closed cycles. | MEDIUM | OPEN — maintenance-sweep candidate |
| INPUT-HASH-MALFORMED-INPUTS-3 | Three artifacts declare unresolvable inputs. | LOW | OPEN — frontmatter fix candidate |
| APERTURE-CLASS-LESSON | Internal-consistency review cannot detect false factual claims. Two-dimension falsification prescription codified. | MEDIUM | OPEN — engine/skill-template candidate |
| AC-NEGATIVE-SUBSTRING-SPECIFICITY | AC negative assertions can pin a contract using a shared substring. | LOW | OPEN — guard-extension candidate |
| README-SIBLING-COUNT-DRIFT-3 | README.md rows bc-2/bc-5/bc-7 show definitional_count instead of total_bcs. | LOW | OPEN — bc-2/5/7 correction candidate |
| HOLDOUT-H-018-ABSENT | H-018 absent from bare-H holdout scenarios. | LOW | OPEN — verify retirement intent |
| RANGE-TERMINUS-INFERENCE | Any range-notation claim must have its maximum verified by enumeration. | MEDIUM | OPEN — engine/checklist candidate |
| UPSTREAM-COMPLETENESS-APERTURE | Internal-consistency review cannot detect upstream-phase obligation gaps. | MEDIUM | OPEN — route upstream to drbothen/vsdd-factory |
| ORCHESTRATOR-ERROR-INJECTION-RATE | Fix instructions must enumerate expected post-state counts. Multiple datapoints. LARGEST-BLAST-RADIUS: ENGINE-ADVERSARY-TWO-BUGS misdiagnosis. PASS-3 DATAPOINTS: 3 of 8 pass-3 findings are orchestrator-introduced regressions. | MEDIUM | OPEN — orchestrator discipline |
| VSDD-CONFORMANCE-GAP-4-ARTIFACTS | jira-cli lacks four canonical VSDD artifacts: VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md. | MEDIUM | OPEN — DEC-195 scheduled as own bundle |
| PLUGIN-ACTIVATION-VERSION-DRIFT | .claude/settings.local.json vsdd-factory.activated_plugin_version = 1.0.0-rc.20 vs installed 1.0.0-rc.23. | LOW | OPEN — verify on next session resume |
| NUDGE-TWICE-BEFORE-VOID | Standing rule: never record VOID until nudged twice. | LOW | OPEN — update dispatch procedures |
| STATE-WRITE-TIMESTAMP-COMPLIANCE | verify-state-timestamp-refresh blocks STATE.md writes that don't advance timestamp:. | LOW | OPEN — agent-discipline |
| LOCAL-BASH-WRITE-GUARD-INSTALLED | .claude/hooks/guard-state-bash-write.sh blocks Bash-based writes to STATE.md. | LOW | OPEN — route upstream |
| ADVERSARY-ARTIFACT-WRITE-MITIGATION | adversary agents have no Write tool by design. Mitigation: orchestrator manually routes artifact writes. 5 datapoints. | LOW | OPEN — route upstream |
| REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED | adversary process | MEDIUM | OPEN — mitigation EFFECTIVE across window 12/13/14 (3/3 isolation CLEAN). Pass-9: VOID-9A; Pass-10: isolation CLEAN; Pass-11: VOID-11A. **S-626-1 passes 12/13/14: ALL isolation CLEAN (3/3). Grep-hygiene corrective verified effective — two patterns self-corrected before trusting zero result across two passes.** Two VOID passes in window 9-11 — ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT. No mechanical isolation guard exists; behavioral corrective sufficient for window 12/13/14. |
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
| ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE | adversary process | MEDIUM | OPEN (all 14 passes now captured) — passes 1..11 captured in prior bursts. **Passes 12+13+14 captured in ADVERSARY-12-13-14+FIX-ROUND-4 burst 2026-08-03.** All 14 adversary passes now captured. VOID-9A/11A (isolation breaches) recorded per DEC-206. Procedural-gap stays OPEN: 84 prior F2 passes ran without adversary capture. |
| ANCHOR-RESOLUTION-AXIS-NOT-APPLIED | spec integrity | MEDIUM | OPEN — FIXED in ADV-6-7-8-FIX-BURST (S-626-1 v1.8 added bcs:["BC-5.3.001","BC-5.3.002"]). Root cause: no CI guard checks story frontmatter anchor completeness. Recurrence risk HIGH. |
| NAMED-BACKGROUND-SUBAGENT-REPORT-LOSS | platform/tooling | MEDIUM | OPEN — passes 6/7/8 first dispatches were named background subagents; all spawned but never delivered final reports. Three VOID spawns (VOID-6A/7A/8A). |
| ORCHESTRATOR-PREMATURE-DEAD-AGENT-CONCLUSION | orchestrator process | MEDIUM | OPEN — orchestrator twice declared a background subagent "dead" before sufficient quiet time. |
| MSRV-JOB-NO-POSITIVE-COVERAGE | CI/F4 | MEDIUM | OPEN — three independent confirmations (passes 6/7/8). Routed to S-641-1 AC-1/AC-2/AC-3. |
| GITLEAKS-NOT-IN-CI-GATE-NEEDS | CI governance | MEDIUM | OPEN — intentional asymmetry (licensing complexity for forks). Tracked as acknowledged governance gap. |
| ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT | adversary process | MEDIUM | OPEN — CORRECTIVE VERIFIED EFFECTIVE (3/3 passes in window 12/13/14 cleanly isolated; two patterns self-corrected; vs 2/3 breached in prior window). Original: passes 9+11 ran root-level `.factory/` greps, producing VOIDs. Required: all adversary greps MUST be scoped to a named subdirectory. BEHAVIORAL corrective achieved; no mechanical guard yet. |
| FIX-ROUND-PARTIAL-PROPAGATION | spec process | HIGH | OPEN — REFINED: round 4 confirms pattern. Round 4 greppable classes FULLY swept (all three passes confirmed zero greppable residue); per-artifact re-derivation classes NOT swept (line counts, Unicode chars, label names, transcript attribution not re-verified from source). Four new defects introduced in new prose across fix round 4. Two passes (13+14) independently recommended mechanical B−A+1 line-count check + byte-diff for transcript artifacts as remedy. |
| CITATION-GUARD-SRC-ONLY | spec integrity | MEDIUM | OPEN — `check-bc-citation-symbols.sh` scopes `src/` only; `.factory/stories/*.md` BC citations and symbol anchors are not machine-validated. ADV-P9-MED-006 unique finding. Guard extension story needed. |
| ARCH-INDEX-REGISTRY-COVERAGE-GAP | spec integrity | MEDIUM | OPEN — ARCH-INDEX.md SS-01..SS-09 registry does not cover `scripts/`, `tests/`, or `.github/dependabot.yml`. Three independent adversary passes identified the gap. Registry extension story needed. |
| S-576-FAMILY-SUBSYSTEM-PATTERN | spec integrity | MEDIUM | OPEN — ROUTED to S-MAINT-576-HYG-1 (DEC-208, 2026-08-03). Status drift (4 story files "ready" vs STORY-INDEX "completed") + subsystem mis-anchoring addressed as maintenance story. S-MAINT-576-HYG-1 draft created (302 lines, v0.1). |
| KEYCHAIN-CREDENTIAL-PATH-UNCOVERED | test coverage | MEDIUM | OPEN — ADV-P9-MED-005 unique finding. `src/cli/auth/keychain.rs::resolve_credential` three-path resolution chain has no per-path pin test. Coverage story needed before S-640-1 ships. |
| FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE | spec process | MEDIUM | OPEN — NEW (2026-08-03, window 12/13/14). Each fix round sweeps greppable defect classes but introduces ~4 new defects in newly-written prose (line counts, char encoding, task labels, attribution not re-verified from source). Three consecutive windows independently identified this class. Mechanical remedies: B−A+1 line-count check for transcript BEFORE/AFTER ranges; byte-diff for Unicode chars; structured self-review checklist for all new prose in fix rounds. |
| DEMO-TRANSCRIPT-FIDELITY-NO-MECHANICAL-GUARD | spec process | MEDIUM | OPEN — NEW (2026-08-03, window 12/13/14). No automated verification that demo transcript content (line counts, char encoding, task labels, attribution) matches source artifacts at the time of capture. Three consecutive windows found transcript-fidelity class. Guard story needed: transcript-validator script that re-derives B−A+1, checks for non-ASCII chars against ASCII source, and verifies task label citations. |
| STATE-VERDICT-LABEL-AMBIGUITY | state integrity | MEDIUM | OPEN — STATE.md briefly rendered three NOT-CLEAN adversary passes (S-626-1 passes 12/13/14) as "(CLEAN; 0H)" labels, a terminology collision between isolation-clean/zero-HIGH shorthand and the adversary verdict. A resuming session or /next-step could read three "CLEAN" labels and conclude 3/3 window satisfied and Step 4.5 converged. It did not: all three passes were NOT CLEAN and the window is 0/3. Detected by orchestrator on read-back; substantive fields (artifact verdicts, Convergence Status, checkpoint, cycles row) were correct throughout, so no decision was taken on the bad label. Corrected in CORRECTIVE-VERDICT-LABEL-AMBIGUITY burst 2026-08-03. No mechanical guard exists — a validator could assert that any STATE.md pass-label matches its artifact's `verdict:` field. ROUTE upstream to drbothen/vsdd-factory. |
| PASS-NUMBERING-COLLIDES-ACROSS-CYCLES | state integrity | LOW | OPEN — pass numbers are cycle-scoped but recorded unqualified in STATE.md, so SOH-ATTACHMENTS-1 pass-12/pass-13/pass-14 (CLEANx3, converged 2026-07-24, in phase_3_status) and SOH-DX-1 S-626-1 pass-12/pass-13/pass-14 (all NOT CLEAN, 0/3) coexist with opposite verdicts. Historical text left intact for auditability. Corrective: qualify pass references with their cycle/story (e.g. `S-626-1 pass-12`) going forward; applied in CORRECTIVE-VERDICT-LABEL-AMBIGUITY burst. |

## Convergence Status

BC-INDEX v6.75 / STORY-INDEX v1.5.54 / ARCH-INDEX v0.16. SOH-DX-1 F2 APPROVED (DEC-196, 2026-07-29): passes 82/83/84 CLEAN 3/3 at v1.3.166. F3 APPROVED (DEC-197, 2026-07-29): spec v1.3.169; BC 657; holdouts 106. S-626-1 adversary: 14 recorded passes (5 VOID); all NOT CLEAN; 139 total findings; window 12/13/14 COMPLETE = 0/3; ZERO HIGH three consecutive; severity decay 4H→0H confirmed; fix round 4 applied 2026-08-03. **DEC-207 authorized: grind to passes 15/16/17.** AX23-001 PENDING RATIFICATION.

SOH-ATTACHMENTS-1 + prior cycles FULLY CLOSED. See cycles/cycle-001/convergence-trajectory.md.

## Concurrent Cycles

<!-- Prior completed cycles archived to burst-log: ADF-CODE-MARK-EXCLUSIVITY (DEC-163, v0.6.0-dev.8), SOH-BUGS-1 (DEC-167, v0.6.0-dev.9), SOH-COMMENT-CRUD-1 (DEC-176, v0.6.0-dev.10), SOH-ATTACHMENTS-1 (DEC-186, v0.6.0-dev.11). See cycles/cycle-001/convergence-trajectory.md. -->
| Cycle | Status | Notes |
|-------|--------|-------|
| SOH-DX-1 (issues #639+#627+#626) | F4 DELIVERY IN PROGRESS — **S-626-1 DELIVERED** (PR #667, feature HEAD c88374b4, **HELD — DEC-202**) | 3 stories: S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1, S-626-1 (DELIVERED). S-626-1 adversary: 14 passes (5 VOID: 3 dispatch + 2 isolation); Step 4.5 = 0/3; 139 findings; window 12/13/14 COMPLETE = 0/3 NOT CLEAN; ZERO HIGH three consecutive; fix round 4 applied 2026-08-03; DEC-207 authorized grind to passes 15/16/17. AX23-001 PENDING RATIFICATION. |

## Session Resume Checkpoint
| Field | Value |
|-------|-------|
| Position | Feature Mode SOH-DX-1 F4 delivery. F2 APPROVED (DEC-196), F3 APPROVED (DEC-197). **S-626-1 DELIVERED** — PR #667 open, feature HEAD c88374b41ee4ea30bc2406e1def90cedf3686275, branch ci/fix-toolchain-sha-msrv. **HELD per DEC-202** pending fresh 3-pass window on amended state. Fix round 4 applied 2026-08-03 (demos/S-626-1/ 11 artifacts corrected; S-626-1 v1.10, S-641-1 v0.7, S-576-5 v1.48; STORY-INDEX v1.5.54; bc-5, edge-case-catalog updated; S-MAINT-576-HYG-1 new draft). |
| Convergence | S-626-1 Step 4.5 = 0/3. 14 recorded passes (5 VOID: 3 dispatch + 2 isolation). 139 total findings. Window 12/13/14 COMPLETE = 0/3 NOT CLEAN. ZERO HIGH three consecutive passes. Severity decay 4H→0H confirmed. FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE + DEMO-TRANSCRIPT-FIDELITY-NO-MECHANICAL-GUARD new drift items. **DEC-207 authorized: grind to passes 15/16/17.** |
| Not yet done | (1) Passes 15/16/17 dispatch: maintain scoped greps (ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT corrective effective — continue). (2) S-640-1 handoff: on MSRV ≥1.88, delete `No let-chains` from CLAUDE.md Conventions AND in-code comments at `src/cli/board.rs` ~:231, `src/cli/issue/list.rs` ~:523, `src/cli/auth/keychain.rs` ~:50. (3) S-MAINT-576-HYG-1 needs review before scheduling. DEC-204 UNADJUDICATED. |
| In flight | develop @ c88374b4 (PR #667 HELD — DEC-202). .factory @ factory-artifacts (this commit). No other open worktrees. Product repo untracked: .claude/hooks/, .claude/pr-reviews/, .claude/settings.local.json.bak, .claude/spec-config.json (pre-existing). |
| Pending human decisions | (1) DEC-207 authorized — grind to passes 15/16/17 confirmed. (2) AX23-001 out-of-delta ratification (non-blocking). (3) DEC-204 UNADJUDICATED (DEC-191(d) ceiling ruling). PR queue: #667 (HELD — DEC-202), #662 (MERGEABLE), #655-#659 (soaking), #628/#574. DO NOT close #429. |
| Resume command | Open fresh session → /vsdd-factory:next-step. Dispatch S-626-1 passes 15/16/17 (scoped greps verified effective). Then S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1 after 3/3 CLEAN window. PR #667 HELD. AX23-001 pending. |

## RESUME PLAN (cold-start)
Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Read this file.
Step 2 — Dispatch S-626-1 pass-15 (first of target 15/16/17 window on amended state per DEC-207). Maintain scoped greps — behavioral corrective verified effective across window 12/13/14 (3/3 isolation CLEAN). PR #667 HELD until window passes. Then S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1. AX23-001 PENDING. DEC-204 UNADJUDICATED.

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |

## Historical Content

See `cycles/cycle-001/`: burst-log.md, convergence-trajectory.md, session-checkpoints.md, lessons.md, blocking-issues-resolved.md.
