---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-07-29T14:25:17Z
phase: 3
pipeline: PAUSED
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "SOH-DX-1 F2 CONVERGED 3/3 ARTIFACT-BACKED — D-chain cite D-191 latest brownfield — F2 HUMAN GATE READY (2026-07-29). Window = pass-76 CLEAN (ADV-P76-LOW-001 IN-DELTA LOW ledgered; 1/3), pass-77 CLEAN (P77-001 OUT-OF-DELTA LOW ledgered; independence COMPROMISED; 2/3), pass-78 CLEAN 0 findings HARD-ISOLATED (3/3). pass-75 RETRO-LOGGED from fix trail (6 findings; NOT window-eligible; AX23-001 OUT-OF-DELTA PENDING HUMAN RATIFICATION). FOUR GATE DISCLOSURES. spec v1.3.163; BC-INDEX v6.75. trajectory-tail →6→1→1→0. Next: F2 human gate."
trajectory_tail: "→6→1→1→0"
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

<!--
STATE.md SIZE BUDGET (2026-07-29 SOH-DX-1 F2 convergence window artifact-backed burst):
255 lines (wc-l) — prior: 255 lines; net delta: 0 lines.
Soft-target 200 (+55-line margin from soft-target); margin from actual to hard cap 500 = 245 lines.
-->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →6→1→1→0 (pass-75=6 retro; pass-76/77/78 CLEAN 3/3 ARTIFACT-BACKED; ADV-P76-LOW-001 IN-DELTA + P77-001 OUT-OF-DELTA ledgered) |
| **Last Updated** | 2026-07-29: SOH-DX-1 F2 convergence window artifact-backed burst — pass-75 RETRO-LOGGED, pass-76/77/78 ARTIFACT-BACKED CLEAN; CONVERGED 3/3 DEC-191; 5 new drift items; PHANTOM-CONVERGENCE-EVIDENCE CLOSED; trajectory-tail →6→1→1→0. |
| **Current Phase** | Feature Mode SOH-DX-1 **F2 CONVERGED 3/3 ARTIFACT-BACKED — F2 HUMAN GATE READY**. Window = pass-76 (ADV-P76-LOW-001 IN-DELTA LOW), pass-77 (P77-001 OUT-OF-DELTA LOW; independence COMPROMISED), pass-78 (ZERO findings HARD-ISOLATED). pass-75 RETRO-LOGGED (NOT window-eligible). FOUR DISCLOSURES: (a) DEC-190 substitute basis; (b) pass-77 independence COMPROMISED; (c) AX23-001 OUT-OF-DELTA PENDING RATIFICATION; (d) .factory/policies.yaml absent. spec v1.3.163; BC-INDEX v6.75. |
| **Next Phase** | F2 human gate: ratify AX23-001 out-of-delta ruling + review four disclosures. On F2 approval, F3 story decomposition: update S-639-1, draft S-627-1, draft S-626-1, update stale S-383; carry SHA blocking AC `fa04a1451ff1842e2626ccb99004d0195b455a88` in S-626-1; P71-003 do-not-remove constraint for `rustup target add` steps. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; FIX-E2E-EGRESS DELIVERED; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Archived rows: see cycles/cycle-001/burst-log.md (rounds 67, 68-70 archived 2026-07-29; LEDGER-BURST-71-72, DEC-191-BURST, F2-CONVERGENCE-BURST, pass-73/74/73b/74b archived this burst 2026-07-29) -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **SOH-DX-1 F2 pass-75 RETRO-LOG + spec fix burst (2026-07-29): six-axis review (commit 13f015da) findings reconstructed from spec-changelog fix trail [1.3.161/162/163]. 6 findings: AX23-001 (GAP/LOW; OUT-OF-DELTA per orchestrator ruling PENDING HUMAN RATIFICATION), AX-001 (REFINEMENT/MEDIUM), AX-002/P73-001/RS-001 (REFINEMENT/LOW), ADR-LOCATION-FIX-001. NOT window-eligible under DEC-191.** | RETRO-LOGGED from fix trail | 2026-07-29 | NOT window-eligible | spec v1.3.163; BC-INDEX v6.75. | →1H→6 |
| pass-76/pass-77/pass-78 — F2 adversary convergence window (ARTIFACT-BACKED 2026-07-29 under DEC-191; pass-76 CLEAN 1 IN-DELTA REFINEMENT/LOW ADV-P76-LOW-001 ledgered 1/3; pass-77 CLEAN 1 OUT-OF-DELTA REFINEMENT/LOW P77-001 ledgered independence COMPROMISED 2/3; pass-78 CLEAN ZERO findings HARD-ISOLATED 3/3 CONVERGED). DEC-190 substitute basis: all 3 window passes ran as consistency-validator. FOUR GATE DISCLOSURES: (a) DEC-190 substitute basis; (b) pass-77 independence COMPROMISED; (c) AX23-001 out-of-delta ruling PENDING HUMAN RATIFICATION; (d) .factory/policies.yaml absent. | ARTIFACT-BACKED CLEAN 3/3 CONVERGED | 2026-07-29 | F2 HUMAN GATE READY | spec v1.3.163; BC-INDEX v6.75; STORY-INDEX v1.5.42. | →1→1→0 |

## Current Phase Steps

<!-- Archived rows: see cycles/cycle-001/burst-log.md (SESSION-WRAP + LEDGER-BURST-71-72 archived 2026-07-29; DEC-191-BURST + F2-CONVERGENCE-BURST archived this burst 2026-07-29) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **SOH-DX-1 F2 CONVERGENCE BURST (2026-07-29): pass-75 RETRO-LOGGED from spec-changelog fix trail (6 findings; NOT window-eligible). pass-76 CLEAN 1 IN-DELTA LOW refinement (ADV-P76-LOW-001). pass-77 CLEAN 1 OUT-OF-DELTA LOW refinement (P77-001; independence COMPROMISED). pass-78 CLEAN ZERO findings HARD-ISOLATED. CONVERGED 3/3 DEC-191 ARTIFACT-BACKED. PHANTOM-CONVERGENCE-EVIDENCE CLOSED. 5 new drift items added. STATE.md + convergence-trajectory.md + burst-log.md + blocking-issues-resolved.md + pass-76/77/78 artifacts committed atomically.** | state-manager | COMPLETED | spec v1.3.163 (unchanged); BC-INDEX v6.75; STORY-INDEX v1.5.42; factory-artifacts committed and pushed to origin/factory-artifacts. |

## Decisions Log

| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-001..DEC-155 | Phase 0/1/2/3 + Wave + Feature Mode + all prior cycles. All CYCLE CLOSED. | See cycles/cycle-001/burst-log.md | Phase 0 to 3 / 2026-05-04 to 2026-07-07 | archived |
| DEC-156..163 | CITATION-GUARDS (PR #572/#592; BC-X.13.001..006) FULLY COMPLETE + ADF-CODE-MARK-EXCLUSIVITY (PR #593/#594; v0.6.0-dev.8 @ 159e1be) FULLY COMPLETE. | Human closed both cycles. | Feature Mode 2026-07-07 to 2026-07-08 | 2026-07-07/08 |
| DEC-164 | SESSION-REVIEW IP-571 DISPOSITION (2026-07-08): 13 proposals routed to drbothen/vsdd-factory (#576-#584). | Human ruled proposals belong in engine repo. | Post-cycle / session-review | 2026-07-08 |
| DEC-165..DEC-167 | SOH-BUGS-1: F1 gate approved; delivery PRs #597-#603; F7-lite 7/7 PASS; release v0.6.0-dev.9 @ b2ce3169. Issues #589/#590/#582 CLOSED. | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-BUGS-1 | 2026-07-09 |
| DEC-168..DEC-177 | SOH-COMMENT-CRUD-1: F1-F7 complete; 13 delivery PRs #610-#623; release v0.6.0-dev.10 @ 56d5126; S-7.02 SATISFIED; issue #577 CLOSED. | Human closed all phases; bundle released; session review complete. | Feature Mode / SOH-COMMENT-CRUD-1 | 2026-07-09 to 2026-07-15 |
| DEC-178 | ALL-DEPENDABOT SOAK BROADENED: 7-day soak extends to ALL dependabot PRs (cargo included). | Human triage: cargo dependabot PRs carry same soak requirement. | Steady-state burst / PR triage | 2026-07-15 |
| DEC-179..DEC-185 | SOH-ATTACHMENTS-1 F1-F3: F1 gate approved (issues #576+#585; 5 stories; security-reviewer REQUIRED); scope expansion (DEC-180); F2 gate at v1.3.79 (DEC-184); F3 gate at v1.3.94 (DEC-185). | Human gated all phases; security posture upgraded at F2 gate. | Feature Mode / SOH-ATTACHMENTS-1 | 2026-07-15 to 2026-07-19 |
| DEC-186 | SOH-ATTACHMENTS-1 F7 DELTA CONVERGENCE APPROVED: 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED; release v0.6.0-dev.11 authorized. | Human closed bundle at convergence gate + authorized release. | Feature Mode / SOH-ATTACHMENTS-1 F7 | 2026-07-25 |
| DEC-187 | DEC-133 SOAK SCOPE RULING: 7-day soak applies uniformly to ALL Actions bumps including first-party; soak measured from UPSTREAM RELEASE DATE, not Dependabot PR date. | Human triage: first-party Actions carry same supply-chain risk. | Steady-state / Dependabot triage | 2026-07-25 |
| DEC-188 | SOH-DX-1 F1 GATE APPROVED: 3-story bundle ratified; --on-behalf-of/--field flip to pre-flight exit-64; MSRV false-green fix; factory-artifacts prose revert; version train bumps 0.6→0.7. | 3 validation probes + migration research; fresh-context audit 2 findings folded. | Feature Mode SOH-DX-1 F1 | 2026-07-25 |
| DEC-189 | F2 convergence criterion: STRICT — 3 consecutive CLEAN adversary passes required; any delta-attributable finding resets window. SUPERSEDED by DEC-191 (2026-07-28). | Human STRICT ruling; grinding to convergence. | Feature Mode SOH-DX-1 F2 | 2026-07-25 |
| DEC-190 | SUBSTITUTE-PASS RATIFICATION: human "keep grinding to 3 strict" ratifies consistency-validator dispatches as window-eligible. DEC-190 basis MUST be disclosed at F2 gate. Root cause of ADVERSARY-AGENT-NONFUNCTIONAL re-attributed to platform defect #47936. NUDGE-TWICE-BEFORE-VOID added. | Human ratified substitutes; root cause now platform defect. | Feature Mode SOH-DX-1 F2 | 2026-07-27 (updated 2026-07-28) |
| DEC-191 | F2 CONVERGENCE CRITERION AMENDED: VSDD doctrine (gap-vs-refinement) supersedes DEC-189. (a) CONVERGENCE = novelty decay (refinements, not gaps). (b) THRESHOLD = 3 consecutive CLEAN. (c) LOW refinements LEDGERED, non-resetting. (d) ESCALATION CEILING = max 10 passes before escalating to human. DEC-190 remains in force. | Human ruling 2026-07-28 after doctrine review. | Feature Mode SOH-DX-1 F2 | 2026-07-28 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI per-AC demos: Yes — adapted. See cycles/cycle-001/burst-log.md.

## Blocking Issues

None open.

## Drift Items (open / tracked)

<!-- 10 items archived 2026-07-25; 8 closed items archived to cycles/cycle-001/blocking-issues-resolved.md: ZERO-HTTP-PROOF-VERIFIED, ADVERSARY-AGENT-NONFUNCTIONAL, SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING, PHANTOM-ADR-0017, CANONICAL-COUNTS-STALE-ADR-LOCATIONS, STRICT-WINDOW-NO-FIXED-POINT, SPEC-INLINE-REVERT-SIGNAL (2026-07-29); PHANTOM-CONVERGENCE-EVIDENCE archived this burst 2026-07-29 -->
| ID | Area | Severity | Status |
|----|------|----------|--------|
| SIX-AXIS-REVIEW-UNLOGGED | spec integrity | LOW | OPEN — trajectory reconstructed from fix trail; six-axis review (commit 13f015da) findings retro-logged as pass-75 (6 findings; NOT window-eligible). AX23-001 (phantom test name in VP-571-003) classified OUT-OF-DELTA by orchestrator ruling per P72-001 precedent; PENDING HUMAN RATIFICATION at F2 gate. ENGINE-ADVERSARY-TWO-BUGS (a) root cause. |
| STALE-FACTORY-ARTIFACTS-BRANCH | branch hygiene | LOW | OPEN — needs human review before deletion. Branch factory-artifacts-fix-citations is 3 ahead / 10 behind factory-artifacts; last commit 2026-07-19; unique SHAs a92930a1/8a0a2422/0e7093c6. |
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
| CITATION-FORM-DISCIPLINE | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. F65-001 recurrence (2026-07-28). | LOW | DEFERRED |
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
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | F1 perimeter scan must include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. P16-001 + pass-52 datapoints. | LOW | OPEN — codification pending |
| BC-INDEX-9TH-SURFACE | BC-INDEX.md coverage statistics not covered by check-bc-cumulative-counts.sh. RECURRENCE COUNT: 10. First mechanical audit pass-63 VERIFIED ACCURATE. Guard-extension OPEN; priority downgrade recommended. | LOW | OPEN — guard-extension candidate |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | Guard 1 does not enforce single-line Trace/Source fields. | LOW | OPEN — follow-up story candidate |
| BC-X5008-STALE-LINE-CITE | BC-X.5.008 Source cites stale line range. DEC-146. | LOW | OPEN — LOW BC-metadata fix candidate |
| PF-008-ASSET-ID-RESULT-HARDENING | Result-propagation hardening at src/api/assets/linked.rs + src/cli/issue/list.rs. | LOW | OPEN — tracked deferral |
| RA-001-JRACLOUD-PAGINATION-DOC | JRACLOUD (user pagination fixed-window, bug ref 27893) load-bearing but not cited in CLAUDE.md Gotchas. | LOW | OPEN |
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
| FACTORY-DISPATCHER-HOOK-TIMEOUT | factory-dispatcher PostToolUse hook fired fail-closed on spec edits. Severity escalated LOW to MEDIUM (recurrence). 4th+ recovery datapoint (v1.3.156 burst, 2026-07-28): every Edit triggers fail-closed PostToolUse timeout at ~295ms; edits persist and are grep-verified each time. | MEDIUM | OPEN — engine-side fix increasingly urgent |
| SPEC-CHANGELOG-RESYNC | spec-changelog.md goes stale across F2 fix rounds. RECURRENCE COUNT: 3. Mitigation: PO self-administers changelog-sync check per fix round. | LOW | OPEN — F2-skill template update candidate |
| TWIN-ARTIFACT-SWEEP | Fix rounds must propagate spec changes to ALL mirroring artifacts. RECURRENCE COUNT: 20. Mechanical-grep dispatch now in effect. | LOW | OPEN — F2-skill template update candidate |
| FOOTER-FRONTMATTER-CONVENTION-MISS | bc-3-issue-write.md convention updates the footer "Last updated" block AND frontmatter trail on every version bump. v1.3.145 shipped without footer update (missed by CV re-verification AND orchestrator direct check). Backfilled in v1.3.146. No CI guard enforces footer-version parity. | LOW | OPEN — PO per-round checklist standing obligation |
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
| SOH-DX-1-PG-012 | Mechanical replace_all on spec artifacts has no guard against sweeping immutable historical version-trail entries. | LOW | OPEN — guard-extension candidate |
| TRAIL-ORDER-ANOMALY-BC3 | bc-3-issue-write.md frontmatter trail is ascending through v1.3.112 then descending from v1.3.145; newest entry buried mid-file. | LOW | OPEN |
| TRAJECTORY-TAIL-STALE-DUP | FIXED this burst (orphaned duplicate of p121 trajectory line deleted). Root cause: no guard on trajectory-append correctness. | LOW | FIXED — guard gap OPEN |
| AGENT-IDLE-NO-REPORT | Root cause = platform defect GitHub issue #47936 (background subagents 14-30% fail mid-work; no result block). NUDGE-TWICE-BEFORE-VOID standing rule; amended VOID threshold (>15 min passes need longer quiet period). Four false-VOID corrections in convergence burst. See cycles/cycle-001/lessons.md for full amendment history. | MEDIUM | OPEN — route to Anthropic (platform defect #47936) |
| PO-REPORT-FIDELITY | product-owner reported fabricated changelog-count line (CV-FALSE-POSITIVE-CLOSURE class). Second datapoint: ran wrong guard script but reported full coverage. | LOW | OPEN — dispatch-discipline |
| VP-INDEX-ARTIFACT-ABSENT | VP-INDEX is a canonical VSDD artifact owned by architect.md:41; inline-only tracking is non-conformant. Fold into VSDD-CONFORMANCE-GAP-4-ARTIFACTS bundle. Pending human ratification. | LOW | OPEN — pending VSDD-CONFORMANCE-GAP-4-ARTIFACTS bundle |
| INPUT-HASH-DRIFT-BACKLOG-56 | 56 artifacts stale on input-hash across closed cycles (SOH-ATTACHMENTS-1, SOH-COMMENT-CRUD-1, cycle-001 bookkeeping, S-383). Zero F2-attributable. Route to maintenance sweep. | MEDIUM | OPEN — maintenance-sweep candidate |
| INPUT-HASH-MALFORMED-INPUTS-3 | Three artifacts declare unresolvable inputs: GitHub URL input, path-traversal input, never-produced inputs. Unresolvable inputs silently drop files out of drift detection. | LOW | OPEN — frontmatter fix candidate |
| APERTURE-CLASS-LESSON | Internal-consistency review cannot detect false factual claims. Reality-check passes immediately produced substantive findings. Codify: F2/F5 checklists MUST include reality-check dimension. | MEDIUM | OPEN — engine/skill-template candidate |
| AC-NEGATIVE-SUBSTRING-SPECIFICITY | AC negative assertions can pin a contract using a substring shared with unrelated contracts' messages (F57-001 class). No guard detects this. | LOW | OPEN — guard-extension candidate |
| README-SIBLING-COUNT-DRIFT-3 | README.md rows bc-2/bc-5/bc-7 show definitional_count instead of total_bcs. NOT fixed (scope bc-3 only in v1.3.153). | LOW | OPEN — bc-2/5/7 correction candidate |
| HOLDOUT-H-018-ABSENT | Bare-H holdout scenarios span H-001..H-047 but only 46 exist — H-018 is absent. Total (100) guard-consistent; intent unverified. | LOW | OPEN — verify retirement intent |
| RANGE-TERMINUS-INFERENCE | Any range-notation claim must have its maximum verified by enumeration, never inferred from membership. | MEDIUM | OPEN — engine/checklist candidate |
| UPSTREAM-COMPLETENESS-APERTURE | Internal-consistency review cannot detect upstream-phase obligation gaps. GATE OBLIGATIONS REGISTER prescribed. Two instances in eight passes. Route upstream to drbothen/vsdd-factory. | MEDIUM | OPEN — route upstream to drbothen/vsdd-factory |
| ORCHESTRATOR-ERROR-INJECTION-RATE | Fix instructions must enumerate expected post-state counts and name full paths; treat as reviewable output. Four self-corrections this session recorded. See cycles/cycle-001/burst-log.md for detail. | MEDIUM | OPEN — orchestrator discipline |
| VSDD-CONFORMANCE-GAP-4-ARTIFACTS | jira-cli lacks four canonical VSDD artifacts: VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md. Three adversary review axes have NEVER been able to run across 72 F2 passes. Own bundle; pending human ratification. | MEDIUM | OPEN — own bundle candidate |
| PLUGIN-ACTIVATION-VERSION-DRIFT | .claude/settings.local.json vsdd-factory.activated_plugin_version = 1.0.0-rc.20 vs installed 1.0.0-rc.23. | LOW | OPEN — verify on next session resume |
| ENGINE-ADVERSARY-TWO-BUGS | Two engine bugs in adversary.md HEAD source. (a) §Output Format L121 mandates writing findings to .factory/cycles/<current>/adversarial-reviews/ but tools grant no Write. (b) Partial-Fix Regression Discipline axis requires prior-pass findings that L22 forbids reading. Route to drbothen/vsdd-factory. | MEDIUM | OPEN — route to drbothen/vsdd-factory |
| NUDGE-TWICE-BEFORE-VOID | Standing rule: never record VOID until nudged twice via SendMessage. Amended: long-running analytical passes (>15 min) need substantially longer quiet period or explicit NO ANALYSIS COMPLETED reply. | LOW | OPEN — update dispatch procedures |
| STATE-WRITE-TIMESTAMP-COMPLIANCE | verify-state-timestamp-refresh (PreToolUse hook) blocks any STATE.md write whose proposed content does not advance timestamp:. Compliance = advance timestamp: in written content. No deadlock or mtime race; hook cannot touch the file. | LOW | OPEN — agent-discipline |
| LOCAL-BASH-WRITE-GUARD-INSTALLED | .claude/hooks/guard-state-bash-write.sh (gitignored) blocks Bash-based writes to STATE.md. Machine-local only. Durable fix: register upstream Bash-matching sibling for STATE.md validators in engine. | LOW | OPEN — route upstream to drbothen/vsdd-factory |
| ADVERSARY-ARTIFACT-WRITE-MITIGATION | adversary process | LOW | OPEN — route upstream. Adversary agents confirmed to have no Write tool (ENGINE-ADVERSARY-TWO-BUGS §(a)). Artifact writing for passing-clean passes falls to state-manager. Mitigation in place: orchestrator manually routes artifact writes. No automated guard. |
| REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED | adversary process | MEDIUM | OPEN — first datapoint. pass-77 reviewer read pass-76 intermediate draft before pass-76 artifact was finalized; independence COMPROMISED. No mechanical isolation guard exists in current engine. Disclose at F2 gate. |
| VERIFICATION-NONGOAL-UNSCRUTINIZED | spec integrity | MEDIUM | OPEN — flagged for F2 gate. pass-78 verification-adequacy aperture first ran across all 78 F2 passes. VSDD-CONFORMANCE-GAP-4-ARTIFACTS (VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md absent) constrained the aperture. Disclose at F2 gate. |
| ADV-P76-LOW-001 | spec quality | LOW | OPEN — ledgered (IN-DELTA REFINEMENT). pass-76 finding: reality-check dimension uncovered a spec restatement imprecision. IN-DELTA; non-resetting per DEC-191(c). Ledgered for F3 spec-steward. |
| P77-001 | spec quality | LOW | OPEN — ledgered (OUT-OF-DELTA REFINEMENT). pass-77 finding: delta-completeness revealed a minor AC-falsifiability pattern gap applicable broadly. OUT-OF-DELTA per orchestrator ruling; non-resetting per DEC-191(c). Ledgered for F3/maintenance. |

## Convergence Status

BC-INDEX v6.75 / VPs tracked inline in BC bodies (no index artifact) / STORY-INDEX v1.5.42 / ARCH-INDEX v0.16

SOH-DX-1 F2 CONVERGED 3/3 ARTIFACT-BACKED under DEC-191 (2026-07-29): window = pass-76 CLEAN (ADV-P76-LOW-001 IN-DELTA LOW ledgered), pass-77 CLEAN (P77-001 OUT-OF-DELTA LOW ledgered; independence COMPROMISED), pass-78 CLEAN ZERO findings HARD-ISOLATED. pass-75 RETRO-LOGGED from spec-changelog fix trail [1.3.161/162/163] (6 findings; NOT window-eligible). AX23-001 (GAP, LOW — phantom test name in VP-571-003) classified OUT-OF-DELTA per orchestrator ruling PENDING HUMAN RATIFICATION. DEC-190 substitute basis: all three window passes ran as consistency-validator. FOUR GATE DISCLOSURES: (a) DEC-190 substitute basis; (b) pass-77 independence COMPROMISED; (c) AX23-001 out-of-delta ruling PENDING HUMAN RATIFICATION; (d) .factory/policies.yaml absent.

SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED 2026-07-25 (DEC-186; F5 STRICT 14r/8 fix PRs; F6 4-dims green; F7 5/5 PASS; v0.6.0-dev.11 @ 34d2f795).
Prior cycles FULLY COMPLETE: ADF-CODE-MARK-EXCLUSIVITY (DEC-163, v0.6.0-dev.8), SOH-BUGS-1 (DEC-167, v0.6.0-dev.9), SOH-COMMENT-CRUD-1 (DEC-176, v0.6.0-dev.10). See cycles/cycle-001/convergence-trajectory.md.

## Concurrent Cycles

| Cycle | Status | Notes |
|-------|--------|-------|
| ADF-CODE-MARK-EXCLUSIVITY (issue #571) | FULLY COMPLETE (2026-07-08) — DEC-163. Release v0.6.0-dev.8 @ 159e1be. | PR #593 @ 7ba4cf4; fix-PR #594 @ d7875e6; issue #571 CLOSED; F7 5/5 PASS. |
| SOH-BUGS-1 (issues #589+#590/#582) | FULLY COMPLETE (2026-07-09, DEC-167). Release v0.6.0-dev.9 @ b2ce3169 (PR #603; run 29051718553). | PRs #597/#601/#602/#603. Issues #589/#590/#582 CLOSED. |
| SOH-COMMENT-CRUD-1 (issue #577) | FULLY COMPLETE + RELEASED (DEC-176, 2026-07-15). v0.6.0-dev.10 @ 56d5126. Session-review loop CLOSED (D-177). | PRs #610-#623 (13 PRs); F5 window p3/p4/p5 CLEANx3; session-review IP-577 11/11 ROUTED-UPSTREAM. |
| SOH-ATTACHMENTS-1 (issues #576+#585) | FULLY COMPLETE + RELEASED (DEC-186, 2026-07-25). v0.6.0-dev.11 @ 34d2f795. Session-review loop CLOSED (2026-07-25; 6 IPs routed). | 6 stories + FIX-576-DL + FIX-E2E-EGRESS; PRs #630..654; pipeline IDLE. trajectory-tail →0→0→0→0 |
| SOH-DX-1 (issues #639+#627+#626) | F2 CONVERGED 3/3 ARTIFACT-BACKED — F2 HUMAN GATE READY (2026-07-29). spec v1.3.163; BC-INDEX v6.75; STORY-INDEX v1.5.42. FOUR GATE DISCLOSURES: (a) DEC-190 substitute basis; (b) pass-77 independence COMPROMISED; (c) AX23-001 out-of-delta ruling PENDING HUMAN RATIFICATION; (d) .factory/policies.yaml absent. | 3 stories: S-639-1 (HIGH/breaking), S-627-1 (LOW), S-626-1 (LOW/MED). v0.7.0-dev.1 target. |
| S-POL-11-GUARD-FALSE-GREEN | PR #661 OPEN — "fix(guard): close false-green gaps in check-spec-counts and claude_md_citations (POL-11)". Branch fix/guard-false-green @ c13df96b. Worktree /Users/zious/Documents/GITHUB/jira-cli/.worktrees/FIX-GUARD-FALSEGREEN (clean). Diff: 2 files +34/-1. 15/15 CI checks GREEN. | Review artifact: code-delivery/S-POL-11-GUARD-FALSE-GREEN/pr-review.md — APPROVE, no blocking findings, 3 non-blocking suggestions. AWAITING HUMAN MERGE per DEC-173. |

## Session Resume Checkpoint

| Field | Value |
|-------|-------|
| Date | 2026-07-29 SOH-DX-1 F2 CONVERGENCE WINDOW ARTIFACT-BACKED BURST. Feature Mode SOH-DX-1 F2 CONVERGED 3/3 ARTIFACT-BACKED — F2 HUMAN GATE READY. Spec v1.3.163 (six-axis review remediation; commit 13f015da); changelog through [1.3.163]; BC-INDEX v6.75; STORY-INDEX v1.5.42. BC counts unchanged (657 cumulative; bc-3 140/111). All four guard scripts green. develop @ e72b0166 (local = origin/develop; in sync). |
| Convergence | CONVERGED 3/3 ARTIFACT-BACKED under DEC-191: pass-76 CLEAN (ADV-P76-LOW-001 IN-DELTA LOW ledgered; 1/3); pass-77 CLEAN (P77-001 OUT-OF-DELTA LOW ledgered; independence COMPROMISED; 2/3); pass-78 CLEAN ZERO findings HARD-ISOLATED (3/3 CONVERGED). pass-75 RETRO-LOGGED from fix trail [1.3.161/162/163] (6 findings; NOT window-eligible). AX23-001 classified OUT-OF-DELTA by orchestrator ruling PENDING HUMAN RATIFICATION. DEC-190 substitute basis: all three window passes ran as consistency-validator — must disclose at gate. FOUR GATE DISCLOSURES: (a) DEC-190 substitute basis; (b) pass-77 independence COMPROMISED; (c) AX23-001 out-of-delta ruling PENDING HUMAN RATIFICATION; (d) .factory/policies.yaml absent. |
| This session | SOH-DX-1 F2 convergence window artifact-backed burst. pass-75 retro-logged to convergence-trajectory.md (NOT window-eligible). pass-76/77/78 artifact pass sections appended (ARTIFACT-BACKED). PHANTOM-CONVERGENCE-EVIDENCE CLOSED to blocking-issues-resolved.md. 5 new drift items added (ADVERSARY-ARTIFACT-WRITE-MITIGATION LOW, REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED MEDIUM, VERIFICATION-NONGOAL-UNSCRUTINIZED MEDIUM, ADV-P76-LOW-001 LOW, P77-001 LOW). SIX-AXIS-REVIEW-UNLOGGED downgraded MEDIUM→LOW (trajectory reconstructed; AX23-001 ruling pending). burst-log.md + convergence-trajectory.md + blocking-issues-resolved.md updated atomically. |
| In flight | S-POL-11-GUARD-FALSE-GREEN worktree at /Users/zious/Documents/GITHUB/jira-cli/.worktrees/FIX-GUARD-FALSEGREEN (clean; branch fix/guard-free @ c13df96b). PR #661 OPEN and reviewed APPROVE. Product repo has two PRE-EXISTING untracked paths not created by this session: .claude/pr-reviews/ and .claude/spec-config.json. |
| Pending human decisions | (1) F2 HUMAN GATE — CONVERGED 3/3 ARTIFACT-BACKED; four gate disclosures attached; human ratification of AX23-001 out-of-delta ruling required. (2) PR #661 merge (reviewed APPROVE, 15/15 CI green, per DEC-173). (3) Adversary agent fix path — platform defect #47936 to Anthropic; ENGINE-ADVERSARY-TWO-BUGS to drbothen/vsdd-factory. (4) Input-hash drift disposition (56 stale + 3 malformed, pre-existing closed-cycle). (5) STALE-FACTORY-ARTIFACTS-BRANCH review + delete decision. PR queue: #661 (ready to merge), #645 (soak met 2026-07-27, ELIGIBLE), #655/#656/#657/#658/#659/#660 (soaking per DEC-178/187), #628 (soak), #574 (CONFLICTING). DO NOT close #429. |
| Blockers | None blocking F2 gate (CONVERGED 3/3). Pending human ratification: AX23-001 out-of-delta ruling. MEDIUM open items: AGENT-IDLE-NO-REPORT (platform defect #47936), ENGINE-ADVERSARY-TWO-BUGS (engine), VSDD-CONFORMANCE-GAP-4-ARTIFACTS, REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED, VERIFICATION-NONGOAL-UNSCRUTINIZED. |
| Resume command | Open fresh session → run /vsdd-factory:next-step. Immediate next action: F2 human gate decision — review four disclosures, ratify AX23-001 out-of-delta ruling, open F3 if approved. trajectory-tail →6→1→1→0. |

## RESUME PLAN (cold-start, self-contained)

Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Then read .factory/STATE.md (this file).

Step 2 — Verify position: origin/develop = local develop @ e72b0166 (in sync; fast-forward complete). v0.6.0-dev.11 released (tag @ 34d2f795). SOH-DX-1 F2 CONVERGED 3/3 ARTIFACT-BACKED under DEC-191 — F2 HUMAN GATE READY: window = pass-76/77/78 all CLEAN (ADV-P76-LOW-001 IN-DELTA LOW + P77-001 OUT-OF-DELTA LOW ledgered; pass-77 independence COMPROMISED). FOUR GATE DISCLOSURES: (a) DEC-190 substitute basis; (b) pass-77 independence COMPROMISED; (c) AX23-001 out-of-delta ruling PENDING HUMAN RATIFICATION; (d) .factory/policies.yaml absent. spec v1.3.163; BC-INDEX v6.75. S-POL-11-GUARD-FALSE-GREEN worktree mounted; PR #661 AWAITING HUMAN MERGE. Counters: BC 657, NFR 42, ADR 17, Stories 117, Holdouts 100, VP 35, AC 85 (AC-1..21).

Step 3 — F2 HUMAN GATE READY. CONVERGED 3/3 ARTIFACT-BACKED under DEC-191. Disclose four items to human: (a) DEC-190 substitute basis — all three window passes (76/77/78) ran as consistency-validator dispatches per DEC-190; (b) pass-77 independence COMPROMISED — reviewer read pass-76 intermediate draft; (c) AX23-001 out-of-delta ruling — orchestrator classified AX23-001 (phantom test name in VP-571-003, post-convergence six-axis review) as OUT-OF-DELTA per P72-001 precedent; PENDING HUMAN RATIFICATION; (d) .factory/policies.yaml absent — no per-project policy document. On F2 approval: F3 story decomposition: update S-639-1, draft S-627-1, draft S-626-1, update stale S-383; carry SHA blocking AC `fa04a1451ff1842e2626ccb99004d0195b455a88` in S-626-1; P71-003 do-not-remove constraint for `rustup target add` steps.

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
