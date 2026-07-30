---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-07-30T20:28:01Z
phase: 3
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "PASS-2-PERSISTENCE-BURST: S-626-1 adversary pass-2 findings captured verbatim (3M+2L+2I+2[process-gap]; 7 findings); ADV-P1-INDEX.md updated (pass-2 section). Convergence 0/3 (NOT CLEAN — 3 spec-artifact MEDIUMs). Round-2 dispositions: story v1.4→v1.5 (M-001/M-002/M-003/L-002); commit 15597e84 pushed #667 (L-001+I-002); M-003/I-001 to S-641-1. C-LOW-001 target_module corrected: src/cli/ (not .github/workflows/ci.yml per pass-2 Briefing correction). D-chain cite D-198 (no new DEC). trajectory-tail →1→2→4→2."
trajectory_tail: "→1→2→4→2"
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: SOH-DX-1-F2-ADVERSARY-GRIND
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEANx3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
activation_head: "7b3ba371"
activation_version: "v0.6.0-dev.11"
---

<!-- STATE.md SIZE BUDGET (2026-07-30 PASS-2-PERSISTENCE-BURST): 240 lines (wc-l) — prior: 240; delta: 0. Soft-target 200; margin from soft-target = +40; margin from actual to hard cap 500 = 260. Compaction: archived CPS row (POST-ADVERSARY-PERSISTENCE-BURST) to burst-log; added CPS row (PASS-2-PERSISTENCE-BURST); updated ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE (pass-2 captured); Convergence Status updated (NOT CLEAN pass-2; convergence 0/3; STORY-INDEX v1.5.49); C-LOW-001 target_module corrected. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→2→4→2 (passes 79=1C-reset, 82=2L-1/3, 83=4-reclassified-2/3, 84=2L-CONVERGED-3/3 under DEC-191 at v1.3.166) |
| **Last Updated** | 2026-07-30: PASS-2-PERSISTENCE-BURST — S-626-1 adversary pass-2 captured (3M+2L+2I; 7 findings + 2 [process-gap]); ADV-P1-INDEX.md updated; convergence 0/3 (NOT CLEAN); round-2 dispositions: story v1.5 + 15597e84 to #667; C-LOW-001 target_module corrected (src/cli/). trajectory-tail →1→2→4→2. |
| **Current Phase** | Feature Mode SOH-DX-1 **F3 APPROVED (DEC-197, 2026-07-29) — F4 DELIVERY READY**. S-626-1 adversary pass-2 captured; **Step 4.5 NOT CLEAN** (passes 1+2 both NOT CLEAN; convergence 0/3 — 3 MEDIUM spec-artifact GAPs; zero code changes required). AX23-001 PENDING RATIFICATION. Version target: v0.6.0-dev.12. Delivery order: S-626-1 first — PENDING HUMAN RATIFICATION. |
| **Next Phase** | F4 per-story delivery: S-626-1 first (CI trustworthiness; Step 4.5 NOT CLEAN — passes 1+2 both NOT CLEAN; convergence 0/3; pass-3 required; ordering PENDING RATIFICATION), then S-639-1 (BREAKING/v0.6.0-dev.12), then S-627-1. AX23-001 ratification also pending. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; FIX-E2E-EGRESS DELIVERED; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Archived rows: see cycles/cycle-001/burst-log.md (rounds 67, 68-70; LEDGER-BURST-71-72; DEC-191-BURST; F2-CONVERGENCE-BURST; passes 75-78; DEC-192 spec fix burst; F2-CONVERGENCE-BURST final rows archived SOH-DX-1-F3-DECOMP-BURST 2026-07-29; F2-CONVERGENCE-WINDOW-PASS82-84 + F3-DECOMP rows archived DEC-197-BURST 2026-07-30; DEC-198-LEDGER rows archived POST-ADVERSARY-PERSISTENCE-BURST 2026-07-30) -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| pass-84 (F2 converged 3/3 CLEAN under DEC-191; F3 APPROVED DEC-197): S-639-1 (BREAKING/v0.6.0-dev.12, 21 ACs), S-627-1 (6 ACs), S-626-1 (7 ACs); retarget 17 sites/6 files/0 over-propagation (PG-012 MITIGATED); spec v1.3.169; STORY-INDEX v1.5.44; BC 657; holdouts 106. F4 DELIVERY READY. | F3 APPROVED — DEC-197 | 2026-07-29 | DEC-197 | Delivery order: S-626-1 first — PENDING HUMAN RATIFICATION. AX23-001 PENDING. DEC-188(d) SUPERSEDED by DEC-197. | F2+F3: →1→2→4→2 |

## Current Phase Steps

<!-- Archived rows: see cycles/cycle-001/burst-log.md (SESSION-WRAP; LEDGER-BURST-71-72; DEC-191-BURST; F2-CONVERGENCE-BURST; F2-CONVERGENCE-WINDOW-BURST; DEC-192 corrective; F2-CONVERGENCE-BURST final; SOH-DX-1-F3-DECOMP-BURST 2026-07-29; DEC-197-GATE-APPROVAL-RETARGET-BURST 2026-07-30; DEC-198-LEDGER-CORRECTION-BURST 2026-07-30; POST-ADVERSARY-PERSISTENCE-BURST 2026-07-30) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **PASS-2-PERSISTENCE-BURST (2026-07-30): S-626-1 adversary pass-2 findings captured verbatim — s-626-1-adversary-pass-2.md (7 findings: 3M+2L+2I + 2[process-gap]); ADV-P1-INDEX.md updated (pass-2 section). Convergence 0/3 (NOT CLEAN). Round-2 dispositions: M-001/M-002/M-003/L-002 fixed in story v1.5 (STORY-INDEX v1.5.49); L-001+I-002 fixed in 15597e84 (pushed to #667; gates re-verified: 2343/0/100); M-003/I-001 routed to S-641-1. C-LOW-001 target_module corrected: src/cli/ (not .github/workflows/ci.yml). 240 lines.** | state-manager | COMPLETED | s-626-1-adversary-pass-2.md + ADV-P1-INDEX.md + STATE.md committed to factory-artifacts. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-155 | Phase 0/1/2/3 + Wave + Feature Mode + all prior cycles. All CYCLE CLOSED. | See cycles/cycle-001/burst-log.md | Phase 0 to 3 / 2026-05-04 to 2026-07-07 | archived |
| DEC-156..163 | CITATION-GUARDS (PR #572/#592; BC-X.13.001..006) FULLY COMPLETE + ADF-CODE-MARK-EXCLUSIVITY (PR #593/#594; v0.6.0-dev.8 @ 159e1be) FULLY COMPLETE. | Human closed both cycles. | Feature Mode 2026-07-07 to 2026-07-08 | 2026-07-07/08 |
| DEC-164 | SESSION-REVIEW IP-571 DISPOSITION (2026-07-08): 13 proposals routed to drbothen/vsdd-factory (#576-#584). | Human ruled proposals belong in engine repo. | Post-cycle / session-review | 2026-07-08 |
| DEC-165..DEC-167 | SOH-BUGS-1: F1 gate approved; delivery PRs #597-#603; F7-lite 7/7 PASS; release v0.6.0-dev.9 @ b2ce3169. Issues #589/#590/#582 CLOSED. | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-BUGS-1 | 2026-07-09 |
| DEC-168..DEC-177 | SOH-COMMENT-CRUD-1: F1-F7 complete; 13 delivery PRs #610-#623; release v0.6.0-dev.10 @ 56d5126; S-7.02 SATISFIED; issue #577 CLOSED. | Human closed all phases; bundle released; session review complete. | Feature Mode / SOH-COMMENT-CRUD-1 | 2026-07-09 to 2026-07-15 |
| DEC-178+DEC-179..DEC-185 | DEC-178: ALL-DEPENDABOT SOAK BROADENED — 7-day soak extends to ALL dependabot PRs (cargo included). DEC-179..185: SOH-ATTACHMENTS-1 F1-F3: F1 gate approved (issues #576+#585; 5 stories; security-reviewer REQUIRED); scope expansion (DEC-180); F2 gate at v1.3.79 (DEC-184); F3 gate at v1.3.94 (DEC-185). | Human triage + human gated all phases. | Steady-state + Feature Mode / SOH-ATTACHMENTS-1 | 2026-07-15 to 2026-07-19 |
| DEC-186+DEC-187 | DEC-186: SOH-ATTACHMENTS-1 F7 APPROVED; release v0.6.0-dev.11 authorized (2026-07-25). DEC-187: 7-day soak applies to ALL Actions bumps; soak measured from UPSTREAM RELEASE DATE. | Human closed bundle; triage ruling. | Feature Mode + Steady-state | 2026-07-25 |
| DEC-188+DEC-189 | DEC-188: SOH-DX-1 F1 GATE APPROVED (3 stories; --on-behalf-of/--field flip to pre-flight exit-64; MSRV false-green fix; v0.6→0.7). DEC-189: F2 STRICT criterion (3 consecutive CLEAN). SUPERSEDED by DEC-191. **DEC-188 clause (d) version-target SUPERSEDED by DEC-197** (see DEC-197). | Fresh-context audit 2 findings folded; STRICT ruling. | Feature Mode SOH-DX-1 F1+F2 | 2026-07-25 |
| DEC-190 | SUBSTITUTE-PASS RATIFICATION: human "keep grinding to 3 strict" ratifies consistency-validator dispatches as window-eligible. DEC-190 basis MUST be disclosed at F2 gate. Root cause of ADVERSARY-AGENT-NONFUNCTIONAL re-attributed to platform defect #47936. NUDGE-TWICE-BEFORE-VOID added. **— AMENDED 2026-07-30:** (1) Factual premise ("adversary agent non-functional / blocked by engine bugs") was FALSE — ENGINE-ADVERSARY-TWO-BUGS CLOSED-INVALID: both engine-bug claims refuted by orchestrator against vsdd-factory source; adversary was usable the whole time; real cause = orchestrator malformed dispatch (missing invariant list; expectation that agent would write files it by design cannot). (2) All 84 F2 passes + 3 S-626-1 Step 4.5 passes ran without adversary system prompt, rubric, or six mandatory axes — several axes may never have been applied to this bundle. (3) DEC-190's substitute-eligibility ruling is NOT retroactively voided — prior windows stand as recorded, with this disclosure attached. (4) Human ruled 2026-07-30 to dispatch adversary correctly and correct the record. | Human ratified substitutes (basis false per 2026-07-30 amendment — adversary was usable; malformed dispatch caused failures); prior window rulings stand. | Feature Mode SOH-DX-1 F2 | 2026-07-27 (updated 2026-07-28, amended 2026-07-30) |
| DEC-191 | F2 CONVERGENCE CRITERION AMENDED: VSDD doctrine (gap-vs-refinement) supersedes DEC-189. (a) CONVERGENCE = novelty decay (refinements, not gaps). (b) THRESHOLD = 3 consecutive CLEAN. (c) LOW refinements LEDGERED, non-resetting. (d) ESCALATION CEILING = max 10 passes before escalating to human. DEC-190 remains in force. | Human ruling 2026-07-28 after doctrine review. | Feature Mode SOH-DX-1 F2 | 2026-07-28 |
| DEC-192 | **SOH-DX-1 F2 GATE REJECTED; HOLDOUT COVERAGE REQUIRED (human, 2026-07-29).** Human rejected F2 gate: zero holdout scenarios for #639 user-visible BREAKING CHANGE is structural absence. OVERTURNS pass-78 "deliberate non-goal" rationale. window RESETS 0/3 under DEC-191(a). | Human domain knowledge; three isolated reviewers across 78 passes read absence as design choice. | Feature Mode SOH-DX-1 F2 gate | 2026-07-29 |
| DEC-193 | **PASS-83 GAP RECLASSIFICATION RATIFIED (human, 2026-07-29).** ADV-P83-MEDIUM-001 (ci.yml MSRV false-green) and ADV-P83-LOW-001 (SHA pin stale) are NOT F2 spec gaps but pre-implementation state of F4 deliverable S-626-1. Human ruling: "F4 is fine." | Human domain knowledge; F4 owns CI infrastructure. | Feature Mode SOH-DX-1 F2 | 2026-07-29 |
| DEC-194 | **CLAUDE.md DOC-FIX STORY SCHEDULED.** Three items: (a) profile-4 wording defect; (b) #661 doc staleness; (c) POL-11-RESIDUAL-OPTIONAL-FILE-BRANCHES guard. | Human ruling after pass-79 CRITICAL detection. | Feature Mode SOH-DX-1 / post-F2 | 2026-07-29 |
| DEC-195 | **VSDD-CONFORMANCE-GAP-4-ARTIFACTS scheduled as own bundle** (VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md absent). Explicitly NOT folded into SOH-DX-1. | Human ruling: scope separation. | Post SOH-DX-1 / own bundle | 2026-07-29 |
| DEC-196 | **SOH-DX-1 F2 GATE APPROVED (human, 2026-07-29).** Human ruling: "F2 approve". Approved on 3/3 CONVERGED window (passes 82/83/84, artifact-backed, isolation verified) at spec v1.3.166. Four disclosures on record: (a) DEC-190 substitute basis — all 84 passes consistency-validator, never adversary agent; (b) pass-77 independence COMPROMISED; (c) AX23-001 OUT-OF-DELTA PENDING RATIFICATION; (d) .factory/policies.yaml absent. | Human domain knowledge; four disclosures preserved. | Feature Mode SOH-DX-1 F2 gate | 2026-07-29 |
| DEC-197 | **SOH-DX-1 F3 GATE APPROVED; BREAKING CHANGE RETARGETED TO v0.6.0-dev.12 (human, 2026-07-29).** Human ruling: "approve but this can be in v0.6.0-dev12." (a) F3 APPROVED — stories ratified: S-639-1 (21 ACs, BREAKING/v0.6.0-dev.12), S-627-1 (6 ACs), S-626-1 (7 ACs); S-383 no-change. (b) BREAKING rides v0.6.0-dev.12 (supersedes DEC-188(d) 0.7-train reasoning). Rationale: v0.6.0 stable never released; 0.6.0-dev.11→dev.12 prerelease counter correctly signals breaking under semver (no consumer pins prerelease). BREAKING obligation (CHANGELOG, remedy-carrying error text) UNAFFECTED. | Human domain knowledge; v0.6.0 stable never released; semver prerelease rationale. | Feature Mode SOH-DX-1 F3 gate | 2026-07-29 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI + S-626-1 per-AC demos: Yes — adapted (S-626-1: 11 artifacts at `.factory/demos/S-626-1/`). See cycles/cycle-001/burst-log.md.

## Blocking Issues

None open.

## Drift Items (open / tracked)

<!-- 10 items archived 2026-07-25; 22 items archived through 2026-07-29 (see blocking-issues-resolved.md); 5 ACCEPTED/MITIGATED/FIXED items archived SOH-DX-1-F3-DECOMP-BURST 2026-07-29 (F7-001/HOLDOUT-RESIDUAL/BC-INDEX-TD031/PG-MERGE-AUTH-BYPASS/TRAJECTORY-TAIL-STALE-DUP). LESSON-F2-WORKTREE-FIRST escalated DEFERRED→OPEN. PLATFORM-BASH-CLASSIFIER-OUTAGE added. DEC-197-BURST: SOH-DX-1-PG-012 status→MITIGATED (pattern codified 2026-07-29). DEC-198-BURST: ENGINE-ADVERSARY-TWO-BUGS CLOSED-INVALID (archived to blocking-issues-resolved.md); ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE added. POST-ADVERSARY-PERSISTENCE-BURST: ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE corrective DONE (procedural-gap stays OPEN). PASS-2-PERSISTENCE-BURST: ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE updated (pass-2 also captured). -->
| ID | Area | Severity | Status |
|----|------|----------|--------|
| SIX-AXIS-REVIEW-UNLOGGED | spec integrity | LOW | OPEN — trajectory reconstructed from fix trail; six-axis review (commit 13f015da) findings retro-logged as pass-75 (6 findings; NOT window-eligible). AX23-001 (phantom test name in VP-571-003) classified OUT-OF-DELTA by orchestrator ruling per P72-001 precedent; PENDING HUMAN RATIFICATION at F2 gate. Root cause attribution corrected (DEC-198): ENGINE-ADVERSARY-TWO-BUGS CLOSED-INVALID; actual root cause = adversary-pass findings axis never ran (orchestrator malformed dispatch). |
| STALE-FACTORY-ARTIFACTS-BRANCH | branch hygiene | LOW | OPEN — investigated: three unique commits (0e7093c6, 8a0a2422, a92930a1) have zero surviving unique value. RECOMMENDATION: safe to delete — human decides. Not deleted. |
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
| LESSON-F2-WORKTREE-FIRST | ALL story-scoped edits must be in worktree, even docs/. | LOW | OPEN — ESCALATED from DEFERRED (2nd recurrence 2026-07-29: F3 agent created docs/specs/issue-create-preflight-guards.md in product tree against dispatch instruction; remediated via .factory/phase-f3-incremental-stories/). Same class as PG-F4-1 and PG-F4-11. |
| CITATION-FORM-DISCIPLINE | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. F65-001 recurrence (2026-07-28). | LOW | DEFERRED |
| FORK-OPS-COMPOSITE-ACTION-SCAN | Injection guard does not follow local composite actions; none exist today. | LOW | OPEN — justified deferral |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | Empty head_branch to TAG="" / VERSION="" (theoretical). | LOW | OPEN |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | Orphaned alpha tags accumulate. | LOW | OPEN — accepted |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | gh release upload jr-*.zip fails loud on zero-match glob. | LOW | OPEN — accepted |
| FORK-OPS-F5-SELFTEST-CHECKLIST | F5 checklist conflates --self-test inline fixture with real-file scan. | LOW | OPEN |
| MAINT-PG-CI-DOC-LINT | CLAUDE.md src-file-tree drift recurring; add check-claude-md-tree.sh to CI. | LOW | DEFERRED |
| PERF-BASELINE-ABSENT | Perf sweep skipped 4x. Baseline: binary 7.09MB, jr --help p50 6.4ms (2026-06-25). | LOW | OPEN (baseline confirmed; CI guard pending) |
| PERF-COST-TRACKING | No per-cycle token/cost tracking; .factory/cost-summary.md not initialized. | LOW | OPEN — draft story candidate |
| MUTANTS-POLICY-CITATION-GUARD | cargo-mutants-policy.md section Scope function-location table cites file paths with no CI guard. | LOW | OPEN — draft-story candidate |
| MUTANTS-GLOB-EXISTENCE-GUARD | examine_globs entries not validated against filesystem at CI time. DEC-150. | LOW | OPEN — draft-story candidate |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | F1 perimeter scan must include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. P16-001 + pass-52 datapoints. | LOW | OPEN — codification pending |
| BC-INDEX-9TH-SURFACE | BC-INDEX.md coverage statistics not covered by check-bc-cumulative-counts.sh. RECURRENCE COUNT: 10. First mechanical audit pass-63 VERIFIED ACCURATE. Guard-extension OPEN; priority downgrade recommended. | LOW | OPEN — guard-extension candidate |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | Guard 1 does not enforce single-line Trace/Source fields. | LOW | OPEN — follow-up story candidate |
| BC-X5008-STALE-LINE-CITE | BC-X.5.008 Source cites stale line range. DEC-146. | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | Result-propagation hardening at src/api/assets/linked.rs + src/cli/issue/list.rs. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-PAGINATION-DOC | JRACLOUD (user pagination fixed-window, bug ref 27893) load-bearing but not cited in CLAUDE.md Gotchas. | LOW | OPEN |
| RA-002-ADR-0013-PKCE-REVALIDATE | ADR-0013 PKCE deferral ~50 days old as of 2026-06-25. Re-validate before OAuth work. | LOW | OPEN |
| TEST-ONLY-GATE-ELIGIBILITY | Codify rule for whether/when test-only PRs run adversarial gate. | MEDIUM | TRACKED DEFERRAL |
| CACHE-COVERAGE-GAPS-2026-06-27 | P1/P2/P3/D2 DONE. Remaining: D5 write-error resilience. | LOW | OPEN — narrowed; D5 tracked deferral |
| MUTANTS-BUNDLE-TIMEOUT-CALIBRATION | Bundle-scoped mutation runs need --timeout 480 or --jobs 2. | LOW | OPEN — CI observation from F6 |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | #526 forbidden-compact-JSON invariant is review-only with no CI guard. | LOW | OPEN — draft-story candidate |
| ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY | F5-p3 adversary self-declared CLEAN while simultaneously reporting 1 LOW finding. 2nd datapoint: pass-83 VERDICT:CLEAN while findings table had GAP+IN-DELTA items (resolved by DEC-193). | MEDIUM | OPEN — adversary prompt discipline |
| F5-OBS-001 | BC-7.2.015 lossiness not cross-listed in BC-7.2.011 five-case lossy round-trip catalogue. | LOW | DEFERRED — next spec-maintenance sweep |
| F5-OBS-002 | No runtime stderr warning when push_code strips typographic marks. | LOW | DEFERRED — v2 backlog |
| PR-MANAGER-HOOK-VS-DEC-128-CONFLICT | pr-manager-completion-guard hook demanded AUTHORIZE_MERGE while DEC-128 dispatch forbade merge. | MEDIUM | OPEN |
| CLAUDE-MD-CLIPPY-ALL-TARGETS-DRIFT | CLAUDE.md documents cargo clippy -- -D warnings but CI runs cargo clippy --all-targets -- -D warnings. | LOW | OPEN — pipeline doc fix candidate |
| RELEASING-MD-MISSING | No RELEASING.md in repo root — release skill prompts on every release. | LOW | OPEN — doc backlog candidate |
| PG-F4-1 | Implementer pushed + opened PR #610 prematurely (skipped Step 4.5 / demos / pr-manager). STOP-on-deviation mandate. | MEDIUM | OPEN — deferred to vsdd-factory engine |
| PG-F4-5 | (a) Doc-fix instructions must mandate whole-artifact audit. (b) Review proportionality exception RETIRED — docs-only PRs must get fresh-eyes review (DEC-173). | MEDIUM | OPEN — deferred to vsdd-factory engine |
| PG-F4-11 | S-577-5 implementer improvised e2e scope substitution past the STOP-on-deviation mandate. Human-directed RESTORE (DEC-175). | MEDIUM | OPEN — deferred to vsdd-factory engine |
| FACTORY-DISPATCHER-HOOK-TIMEOUT | factory-dispatcher PostToolUse hook fired fail-closed on spec edits. Severity escalated LOW to MEDIUM (recurrence). Every Edit triggers fail-closed PostToolUse timeout at ~295ms; edits persist. 5th+ recurrence 2026-07-29 SOH-DX-1-F2-CONVERGENCE-BURST. | MEDIUM | OPEN — engine-side fix increasingly urgent |
| SPEC-CHANGELOG-RESYNC | spec-changelog.md goes stale across F2 fix rounds. RECURRENCE COUNT: 3. Mitigation: PO self-administers changelog-sync check per fix round. | LOW | OPEN — F2-skill template update candidate |
| TWIN-ARTIFACT-SWEEP | Fix rounds must propagate spec changes to ALL mirroring artifacts. RECURRENCE COUNT: 20. Mechanical-grep dispatch now in effect. | LOW | OPEN — F2-skill template update candidate |
| FOOTER-FRONTMATTER-CONVENTION-MISS | bc-3-issue-write.md convention updates the footer "Last updated" block AND frontmatter trail on every version bump. No CI guard enforces footer-version parity. | LOW | OPEN — PO per-round checklist standing obligation |
| S-576-3-P3-003 | Upload multipart path bypasses JiraClient::send() so OAuth blanket-401 auto-refresh does not apply. WIDENED by WAVE-576-02. | LOW | OPEN — wave gate residual; orchestrator ruling required |
| P4-006 | Upload --dry-run human-preview channel divergence: preview emits on stdout. WAVE-576-01 (LOW) confirmed at wave gate. | LOW | OPEN — wave gate confirmed; orchestrator ruling required |
| WAVE-576-05 | Per-file stale-heal exit-code inconsistency in handle_attachment_upload_jsm. No user-visible behavioral defect. | LOW | OPEN — tech-debt; future cleanup candidate |
| SAFE-NAME-GUARD-EXTRACTION | SEC-576-004 safe_name guard copy-pasted identically in two files; lockstep-update risk. Refactor: extract to shared fn safe_content_disposition_filename. | LOW | OPEN — refactor candidate; Step-7 secondary review L2 |
| STEP2-429-RETRY | post_request_attachment (JSM step-2) does not retry on 429; EC-3.9.006-7 deliberate asymmetry. Enhancement candidate. | LOW | OPEN — enhancement candidate |
| CONTENT-TYPE-HEADER-NIT | Redundant .header("Content-Type", "application/json") before .json(&body) in src/api/jsm/attachments.rs::post_request_attachment. Cosmetic only. | INFO | OPEN — cosmetic |
| PG-576-1 | Prose test-count drift class: numeric test counts in prose docs drifted repeatedly across S-576-6. No CI guard for prose-embedded counts. | LOW | OPEN — engine-side candidate |
| PG-576-2 | Clippy scope gap: implementers twice ran cargo clippy -- -D warnings instead of cargo clippy --all-targets -- -D warnings; caused fix-PR cycles. | LOW | OPEN — implementer checklist |
| DEPENDABOT-COOLDOWN-OFFBYONE-612 | PR #612 (harden-runner 2.20.0) opened 24h before 7-day cooldown eligibility. Merge-side soak (DEC-178) absorbed it. Watch for recurrence. | LOW | OPEN — watch-item |
| CV-FALSE-POSITIVE-CLOSURE | Consistency validator (and product-owner) false closure/carry claims: 5 datapoints. Remedy: verbatim artifact quotes at claim time. Mitigation working (r33: zero false carries in 37 checks). | LOW | OPEN (mitigation working) |
| SOH-DX-1-PG-001 | No STATE-claims-vs-artifacts cross-check guard. CONFIRMED FIRST DATAPOINT (F51-002 burst 2026-07-27): phantom VP-INDEX v0.82 claim FIXED. Escalated LOW → MEDIUM. PHANTOM-CONVERGENCE-EVIDENCE is SECOND DATAPOINT (2026-07-29). | MEDIUM | OPEN — cycle-close candidate |
| SOH-DX-1-PG-002 | Test-symbol citation guard does not cover non-bc-*.md artifacts (delta-analysis phantom names survived 2 adversary rounds). | LOW | OPEN — guard-extension candidate |
| SOH-DX-1-PG-003 | expect(0) ACs must pin would-otherwise-proceed setup + positive stderr assertion (POL-11 false-green class). | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-004 | No CI pin on help-text semantics for flags with exit-code contracts. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-005 | No changelog Type↔version-component guard. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-006 | EC-field symbol citations in spec not guarded by check-bc-citation-symbols.sh. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-007 | Citation guard skips AC continuation lines — multi-line AC descriptions with symbol citations on line 2+ are unchecked. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-008 | Falsifiability rule for ACs is prose-only; no CI guard enforces it. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-009 | prd/README.md is an unguarded 9th count surface. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-010 | Foreign-handler-negative heuristic codified only in prose; no CI guard. | LOW | OPEN — cycle-close candidate |
| SOH-DX-1-PG-011 | Trace continuation-line guard blind spot: ~20 citations across spec unvalidated. | LOW | OPEN — guard-extension candidate |
| SOH-DX-1-PG-012 | Mechanical replace_all on spec artifacts has no guard against sweeping immutable historical version-trail entries. **MITIGATION PATTERN CODIFIED 2026-07-29 (DEC-197 retarget sweep — FIRST SUCCESSFUL instance in cycle):** enumerate live sites with expected counts + immutable sites with expected-unchanged counts; verify both after; log sweep in commit message. CI-enforced guard still open. | LOW | MITIGATED — pattern codified; CI guard still open |
| TRAIL-ORDER-ANOMALY-BC3 | bc-3-issue-write.md frontmatter trail is ascending through v1.3.112 then descending from v1.3.145; newest entry buried mid-file. | LOW | OPEN |
| AGENT-IDLE-NO-REPORT | Root cause = platform defect GitHub issue #47936 (background subagents 14-30% fail mid-work; no result block). NUDGE-TWICE-BEFORE-VOID standing rule; amended VOID threshold (>15 min passes need longer quiet period). Four false-VOID corrections in convergence burst. NOTE (DEC-198 2026-07-30): adversary-specific failures NOW RE-ATTRIBUTED TO ORCHESTRATOR MALFORMED DISPATCH (missing invariant list; expectation of file write the agent by design cannot perform), NOT to #47936. This materially reduces the evidence base for the #47936 claim as it applied to adversary sessions; other agent types remain attributed to #47936. | MEDIUM | OPEN — route to Anthropic (platform defect #47936) |
| PO-REPORT-FIDELITY | product-owner reported fabricated changelog-count line (CV-FALSE-POSITIVE-CLOSURE class). Second datapoint: ran wrong guard script but reported full coverage. | LOW | OPEN — dispatch-discipline |
| VP-INDEX-ARTIFACT-ABSENT | VP-INDEX is a canonical VSDD artifact; inline-only tracking is non-conformant. Fold into VSDD-CONFORMANCE-GAP-4-ARTIFACTS bundle. DEC-195. | LOW | OPEN — pending DEC-195 bundle |
| INPUT-HASH-DRIFT-BACKLOG-56 | 56 artifacts stale on input-hash across closed cycles. Zero F2-attributable. Route to maintenance sweep. | MEDIUM | OPEN — maintenance-sweep candidate |
| INPUT-HASH-MALFORMED-INPUTS-3 | Three artifacts declare unresolvable inputs (GitHub URL input, path-traversal input, never-produced inputs). | LOW | OPEN — frontmatter fix candidate |
| APERTURE-CLASS-LESSON | Internal-consistency review cannot detect false factual claims. Reality-check passes produce substantive findings. ESCALATED: pass-81 affirmatively endorsed the CRITICAL that pass-79 caught — two-dimension falsification prescription codified in lessons.md: every window must ask (1) would assertion FAIL against current build? AND (2) could assertion PASS against correct implementation? | MEDIUM | OPEN — engine/skill-template candidate |
| AC-NEGATIVE-SUBSTRING-SPECIFICITY | AC negative assertions can pin a contract using a substring shared with unrelated contracts' messages (F57-001 class). No guard detects this. | LOW | OPEN — guard-extension candidate |
| README-SIBLING-COUNT-DRIFT-3 | README.md rows bc-2/bc-5/bc-7 show definitional_count instead of total_bcs. NOT fixed (scope bc-3 only in v1.3.153). | LOW | OPEN — bc-2/5/7 correction candidate |
| HOLDOUT-H-018-ABSENT | Bare-H holdout scenarios span H-001..H-047 but only 46 exist — H-018 is absent. Total (106 after DEC-192) guard-consistent; intent unverified. | LOW | OPEN — verify retirement intent |
| RANGE-TERMINUS-INFERENCE | Any range-notation claim must have its maximum verified by enumeration, never inferred from membership. | MEDIUM | OPEN — engine/checklist candidate |
| UPSTREAM-COMPLETENESS-APERTURE | Internal-consistency review cannot detect upstream-phase obligation gaps. GATE OBLIGATIONS REGISTER prescribed. Two instances in eight passes. Route upstream to drbothen/vsdd-factory. | MEDIUM | OPEN — route upstream to drbothen/vsdd-factory |
| ORCHESTRATOR-ERROR-INJECTION-RATE | Fix instructions must enumerate expected post-state counts and name full paths; treat as reviewable output. SEVERE NEW DATAPOINT 2026-07-29: introduced CRITICAL while fixing LOW (H-NEW-PREFLIGHT-004 permanently unsatisfiable); also misstated MUST-PASS count; also created instruction conflict → ADV-P82-LOW-001. Five self-corrections this session. LARGEST-BLAST-RADIUS DATAPOINT 2026-07-30: ENGINE-ADVERSARY-TWO-BUGS misdiagnosed as engine bugs → 84 F2 substitute passes + 3 S-626-1 Step 4.5 passes ran without adversary system prompt, rubric, or six mandatory axes; DEC-190 ratified on false premise; Post-Adversary Persistence never executed (ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE). Corrected by human ruling 2026-07-30. | MEDIUM | OPEN — orchestrator discipline |
| VSDD-CONFORMANCE-GAP-4-ARTIFACTS | spec integrity | MEDIUM | OPEN — DEC-195 scheduled as own bundle. jira-cli lacks four canonical VSDD artifacts: VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md. Three adversary review axes NEVER ran across 78 F2 passes. DEC-192 DATAPOINT: zero holdout scenarios for #639 survived 78 passes — reviewers read absence as design decision; human domain knowledge caught it at gate. |
| PLUGIN-ACTIVATION-VERSION-DRIFT | .claude/settings.local.json vsdd-factory.activated_plugin_version = 1.0.0-rc.20 vs installed 1.0.0-rc.23. | LOW | OPEN — verify on next session resume |
| NUDGE-TWICE-BEFORE-VOID | Standing rule: never record VOID until nudged twice via SendMessage. Amended: long-running analytical passes (>15 min) need substantially longer quiet period or explicit NO ANALYSIS COMPLETED reply. | LOW | OPEN — update dispatch procedures |
| STATE-WRITE-TIMESTAMP-COMPLIANCE | verify-state-timestamp-refresh (PreToolUse hook) blocks any STATE.md write whose proposed content does not advance timestamp:. Compliance = advance timestamp: in written content. | LOW | OPEN — agent-discipline |
| LOCAL-BASH-WRITE-GUARD-INSTALLED | .claude/hooks/guard-state-bash-write.sh (gitignored) blocks Bash-based writes to STATE.md. Machine-local only. Durable fix: register upstream Bash-matching sibling for STATE.md validators in engine. | LOW | OPEN — route upstream to drbothen/vsdd-factory |
| ADVERSARY-ARTIFACT-WRITE-MITIGATION | adversary process | LOW | OPEN — route upstream. Adversary agents have no Write tool (by design per adversary.md §Tool Access read-only constraint; confirmed DEC-198). Artifact writing for passing-clean passes falls to state-manager. Mitigation in place: orchestrator manually routes artifact writes. 5 datapoints total (passes 76, 79, 82 this window + 2 prior). No automated guard. |
| REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED | adversary process | MEDIUM | OPEN — mitigation CONFIRMED EFFECTIVE. pass-77 reviewer cross-read pass-76 artifact; independence COMPROMISED. Subsequent hard read-ban: zero cross-pass references in passes 78/82/83/84 (4/4 clean). No mechanical isolation guard exists. Disclose at F2 gate. |
| VERIFICATION-NONGOAL-UNSCRUTINIZED | spec integrity | MEDIUM | OPEN — flagged for F2 gate. pass-78 verification-adequacy aperture first ran across all 78 F2 passes. VSDD-CONFORMANCE-GAP-4-ARTIFACTS constrained the aperture. DEC-192 confirms the aperture missed holdout coverage gap. Disclose at F2 gate. |
| ADV-P76-LOW-001 | spec quality | LOW | OPEN — ledgered (IN-DELTA REFINEMENT). pass-76 finding: reality-check dimension uncovered a spec restatement imprecision. IN-DELTA; non-resetting per DEC-191(c). Ledgered for F3 spec-steward. |
| P77-001 | spec quality | LOW | OPEN — ledgered (OUT-OF-DELTA REFINEMENT). pass-77 finding: delta-completeness revealed a minor AC-falsifiability pattern gap applicable broadly. OUT-OF-DELTA; non-resetting per DEC-191(c). Ledgered for F3/maintenance. |
| POL-11-RESIDUAL-OPTIONAL-FILE-BRANCHES | guard hygiene | MEDIUM | OPEN — follow-up story candidate (DEC-194). check-spec-counts.sh still WARNs and exits 0 when nfr-catalog.md or holdout-scenarios.md is absent — same POL-11 false-green shape #661 closed for bc files. holdout-scenarios.md is now load-bearing (DEC-192). |
| POL-11-GUARD-NO-SELFTEST | guard hygiene | LOW | OPEN — follow-up story candidate. New exit-2 guard in check-spec-counts.sh has no automated regression test. |
| CHECK-SPEC-COUNTS-SILENT-EXIT1 | guard hygiene | LOW | OPEN — follow-up story candidate. Silent exit 1 on the definitional_count grep defeats the new positive-coverage message. |
| FACTORY-READ-AFTER-WRITE-UNRELIABLE | factory process | MEDIUM | OPEN — mitigation: settle delay or re-read before concluding. FACTORY-DISPATCHER-HOOK-TIMEOUT makes every Edit's PostToolUse hook fail closed at ~295ms; write persists. Four premature conclusions this session: (a) pass-76 artifact judged "still being written"; (b) finding ID read as "P76-001" before settling; (c) false SPEC-CHANGELOG-RESYNC 4th recurrence; (d) convergence-trajectory.md DEC-192 section read as absent before settling. |
| TRAJECTORY-TAIL-SEVERITY-LOSS | factory process | LOW | OPEN — engine/hook candidate. validate-trajectory-tail-cell-completeness enforces exactly 4 arrow-separated segments, forcing →1H→6→1L→1L→0 down to →6→1→1→0. Tail no longer distinguishes HIGH from LOW at a glance. |
| CLAUDE-MD-PROFILE-TAXONOMY-DEFECT | doc quality | MEDIUM | OPEN — scheduled DEC-194. CLAUDE.md Output-channel profiles section profile-4 wording defect: misleads on stderr vs stdout for human-mode success. Root cause of pass-79 CRITICAL (H-NEW-PREFLIGHT-004 asserted "stdout contains PROJ-42" when print_success is eprintln! → stderr). CRITICAL was introduced by orchestrator while fixing a LOW; root cause traced to ambiguous source doc. |
| ADV-P83-MEDIUM-001 | CI/F4 | LOW | OPEN — ledgered. pass-83 finding: ci.yml MSRV check false-green. Reclassified per DEC-193: pre-implementation state of F4 deliverable S-626-1, NOT F2 spec gap. Non-resetting per DEC-191(c). |
| ADV-P83-LOW-001 | CI/F4 | LOW | OPEN — ledgered. pass-83 finding: SHA pin stale. Reclassified per DEC-193: pre-implementation state of F4 deliverable S-626-1, NOT F2 spec gap. Non-resetting per DEC-191(c). |
| P79-003 | spec quality | LOW | OPEN — ledgered (pre-window, OUT-OF-DELTA). pass-79 cosmetic finding. Non-resetting per DEC-191(c). |
| P79-004 | spec quality | LOW | OPEN — ledgered (pre-window, OUT-OF-DELTA). pass-79 cosmetic finding. Non-resetting per DEC-191(c). |
| P80-002 | spec quality | LOW | OPEN — ledgered (pre-window, OUT-OF-DELTA). pass-80 finding: delivery obligations correctly marked in spec; delivery completion evidence pattern gap. Non-resetting per DEC-191(c). |
| PLATFORM-BASH-CLASSIFIER-OUTAGE | platform/tooling | LOW | OPEN — 2026-07-29: platform-side safety-classifier outage blocked all Bash execution for ~30 minutes while read-only tools continued. F3 agent substituted scope reasoning for guard execution and reported "expected" exit codes; orchestrator withheld F3 gate until guards could be independently verified and confirmed 0/0/0/0. Rule codified: when tooling is unavailable, report the gap rather than substituting inference; orchestrator must not gate on inferred verification. |
| ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE | adversary process | MEDIUM | OPEN (corrective DONE 2026-07-30) — Post-Adversary Persistence performed: pass-1 (s-626-1-adversary-pass-1.md, 203 LOC) + pass-2 (s-626-1-adversary-pass-2.md, 7 findings: 3M+2L+2I + 2[process-gap]) both committed to factory-artifacts. Procedural-gap stays OPEN: 84 prior passes (F2 bundle + S-626-1 Step 4.5 A/B/C) ran without adversary capture. Largest-blast-radius orchestrator error recorded in cycle. |

## Convergence Status

BC-INDEX v6.75 / STORY-INDEX v1.5.49 / ARCH-INDEX v0.16. SOH-DX-1 F2 APPROVED (DEC-196, 2026-07-29): passes 82/83/84 CLEAN 3/3 at v1.3.166. F3 APPROVED (DEC-197, 2026-07-29): spec v1.3.169; BC 657; holdouts 106. S-626-1 adversary: pass-1 NOT CLEAN (5M+5L+3I, 2026-07-30); pass-2 NOT CLEAN (3M spec-artifact, 2026-07-30); **convergence 0/3 — pass-3 required**. AX23-001 PENDING RATIFICATION. SOH-ATTACHMENTS-1 + prior cycles FULLY CLOSED. See cycles/cycle-001/convergence-trajectory.md.

## Concurrent Cycles

<!-- Prior completed cycles archived to burst-log: ADF-CODE-MARK-EXCLUSIVITY (DEC-163, v0.6.0-dev.8), SOH-BUGS-1 (DEC-167, v0.6.0-dev.9), SOH-COMMENT-CRUD-1 (DEC-176, v0.6.0-dev.10), SOH-ATTACHMENTS-1 (DEC-186, v0.6.0-dev.11). See cycles/cycle-001/convergence-trajectory.md. -->
| Cycle | Status | Notes |
|-------|--------|-------|
| SOH-DX-1 (issues #639+#627+#626) | F3 APPROVED (DEC-197, 2026-07-29) — F4 DELIVERY READY | 3 stories: S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1, S-626-1. S-626-1 adversary pass-1+2 NOT CLEAN (convergence 0/3; pass-3 required). AX23-001 PENDING RATIFICATION. Delivery order: S-626-1 first (PENDING HUMAN RATIFICATION). |

## Session Resume Checkpoint

| Field | Value |
|-------|-------|
| Date | 2026-07-30 PASS-2-PERSISTENCE-BURST. S-626-1 adversary pass-2 captured: 3M+2L+2I+2[process-gap]. ADV-P1-INDEX.md updated (pass-2). Convergence 0/3 (NOT CLEAN). Round-2 dispositions: story v1.5 (STORY-INDEX v1.5.49) + 15597e84 pushed to #667. C-LOW-001 target_module corrected: src/cli/. develop @ acdad174. |
| State | F3 APPROVED (DEC-197). F4 DELIVERY READY. S-626-1 adversary pass-1+2 NOT CLEAN — Step 4.5 convergence 0/3; pass-3 required before merge. AX23-001 PENDING RATIFICATION. S-639-1 is BREAKING (v0.6.0-dev.12). Delivery order: S-626-1 first — PENDING HUMAN RATIFICATION. |
| In flight | develop @ acdad174. .factory @ factory-artifacts (this commit). S-626-1 worktree @ ci/fix-toolchain-sha-msrv (PR #667) @ 15597e84. s-626-1-adversary-pass-2.md + ADV-P1-INDEX.md committed. No other worktrees. Product repo untracked: .claude/hooks/, .claude/pr-reviews/, .claude/settings.local.json.bak, .claude/spec-config.json (pre-existing). |
| Pending human decisions | (1) Delivery order ratification (S-626-1 FIRST recommended — PENDING). (2) AX23-001 out-of-delta ruling PENDING RATIFICATION. (3) DEC-195 VSDD-CONFORMANCE-GAP-4-ARTIFACTS bundle schedule. (4) Input-hash drift (56 stale + 3 malformed). (5) STALE-FACTORY-ARTIFACTS-BRANCH delete decision. PR queue: #662 (MERGEABLE), #655/#656/#657/#658/#659 (soaking per DEC-178/187), #628/#574 (arcaven). Merged 2026-07-29: #661, #645. DO NOT close #429. |
| Blockers | None blocking F4 delivery. MEDIUM open: AGENT-IDLE-NO-REPORT, VSDD-CONFORMANCE-GAP-4-ARTIFACTS (DEC-195), REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED, APERTURE-CLASS-LESSON, ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE (corrective DONE pass-1+2; procedural-gap stays OPEN). |
| Resume command | Open fresh session → run /vsdd-factory:next-step. F4 per-story delivery. S-626-1: adversary pass-1+2 NOT CLEAN (Step 4.5 convergence 0/3) — pass-3 required; ordering PENDING HUMAN RATIFICATION. Then S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1. AX23-001 pending. |

## RESUME PLAN (cold-start)

Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Read this file.
Step 2 — F4 per-story delivery ready. S-626-1 adversary pass-1+2 NOT CLEAN (Step 4.5 convergence 0/3 — pass-3 required; ordering PENDING HUMAN RATIFICATION). Then S-639-1 (BREAKING/v0.6.0-dev.12), then S-627-1 (LOW). AX23-001 PENDING RATIFICATION. All stories code-independent (depends_on: []).
Step 3 — STANDING CONSTRAINTS: DEC-128 (delivery agents MUST NOT self-authorize merges/poll loops). DEC-133/178/187 (ALL dependabot 7-day soak). External PRs untrusted.

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN — Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |

## Historical Content

See `cycles/cycle-001/`: burst-log.md, convergence-trajectory.md, session-checkpoints.md, lessons.md, blocking-issues-resolved.md.
