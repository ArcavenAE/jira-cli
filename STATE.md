---
document_type: pipeline-state
level: ops
version: "2.0"
status: active
producer: state-manager
timestamp: 2026-07-25T23:55:00Z
phase: 3
pipeline: IDLE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "DEPENDABOT-QUEUE-DRAINED (2026-07-25): 9/9 merged; develop @ e72b0166 (#598 rand 0.10.1→0.10.2 merged by human after auto-rebase + fresh CI green); #645 soaks to 2026-07-27; pipeline IDLE. NEXT: route ENGINE IPs (5) to vsdd-factory; REPO backlog. D-chain cite D-27893 latest brownfield. trajectory-tail →0→0→0→0."
maintenance_run: CLOSED
current_cycle: "cycle-001"
feature_mode_bundle: SOH-ATTACHMENTS-1-CLOSED
dtu_required: false
phase_2_status: APPROVED
phase_2_approved_at: 2026-05-07
phase_3_status: SOH-ATTACHMENTS-1 F5 SCOPED ADVERSARIAL CONVERGED 2026-07-24 STRICT (14 rounds; window pass-12/pass-13/pass-14 CLEAN×3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81) + F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5-dim PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED) + CYCLE FULLY CLOSED 2026-07-25
activation_head: "7b3ba371"
activation_version: "v0.6.0-dev.11"
---

<!--
STATE.md SIZE BUDGET (2026-07-25 update: dependabot queue drained 9/9):
225 lines (wc-l) — soft-target 200 lines, hard cap 500 lines.
margin from soft-target: 25 lines over soft-target (compact further if possible).
margin from actual: 275 lines remaining to hard cap.
Hard cap: 500 lines. Prior: 424 lines / ~81k tokens. This compaction extracted Phase Progress archived-row comment + F5 SCOPED/F5 FULLY CLOSED rows + CPS archived-row comment + F5 SCOPED CPS/Step-7 SECONDARY REVIEW rows + Convergence Status verbose paragraphs to cycles/cycle-001/burst-log.md (2026-07-25). Archived 10 CLOSED/RESOLVED/SUPERSEDED drift items. Compressed Historical Content 77 to 15 rows.
-->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **Last Updated** | 2026-07-25: DEPENDABOT-QUEUE-DRAINED 9/9 — #598 (rand 0.10.1→0.10.2) merged @ e72b0166 by human after auto-rebase + fresh CI green; post-merge develop CI #636/#637 SUCCESS, #598 run in-flight. Prior: 8/8 merged to develop @ a15ffe24 (DEC-173); #645 soaking until 2026-07-27 (DEC-187). SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED — v0.6.0-dev.11 SHIPPED (tag @ 34d2f795); FIX-E2E-EGRESS DELIVERED (PR #654 @ 7b3ba371; e2e GREEN); pipeline IDLE. trajectory-tail →0→0→0→0 |
| **Current Phase** | Phase 3 — SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED 2026-07-25. v0.6.0-dev.11 SHIPPED (tag @ 34d2f795). FIX-E2E-EGRESS DELIVERED (PR #654 @ 7b3ba371). PIPELINE IDLE. Spec v1.3.106. Stories 117. develop @ e72b0166 (dependabot queue DRAINED 9/9, 2026-07-25). BC 657. Holdouts 100. VP 35. BC-INDEX v6.44. STORY-INDEX v1.5.40. |
| **Next Phase** | Pipeline IDLE. Route ENGINE IPs (5) to vsdd-factory. REPO backlog: RELEASING-MD-MISSING; NETWORK-ERROR-TAXONOMY; P3-003/P4-006 (ledger-hold); enhancement candidates SAFE-NAME-GUARD-EXTRACTION/STEP2-429-RETRY/CONTENT-TYPE-HEADER-NIT. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; FIX-E2E-EGRESS DELIVERED; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Keep last 5 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived rows ledger: see cycles/cycle-001/burst-log.md (2026-07-25 compaction) -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| pass-14 adversary — SOH-ATTACHMENTS-1 F5 STRICT CONVERGED (2026-07-24): final window 3 consecutive CLEAN passes (global rounds 12-14 of 14 total). 8 fix bursts (#644-#652). Window pass-3 of 3. | F5 adversary pass-3 STRICT CONVERGED (14 rounds total) | 2026-07-24 | PASS STRICT; window pass-3 of 3 (rounds 12-14). | spec v1.3.99 to v1.3.106; develop @ db207b81. Full trajectory: cycles/cycle-001/convergence-trajectory.md. pass-14 trajectory-tail →0→0→0→0 | →0→0→0→0 |
| **SOH-ATTACHMENTS-1 F5 fix burst summary (2026-07-21 to 2026-07-24): 8 fix bursts dispatched across 14 adversary passes; PRs #644-#652 merged to develop.** | F5 fix burst complete | 2026-07-21 to 2026-07-24 | 8 fix bursts merged. | PRs #644-#652; full burst narratives in cycles/cycle-001/burst-log.md. | — |
| **SOH-ATTACHMENTS-1 F6 TARGETED HARDENING PASS (2026-07-25): D1 5/5 VPs green; D2 fuzz-substitute 49152 inputs 0 crashes; D3 mutation 27/27 viable 100%; D4 cargo-audit 0 vulns; regression 2341/0 +22 tests.** | F6 hardening PASS | 2026-07-25 | PASS; all 4 dimensions green. | BC 657; holdouts 100; VP 35; spec v1.3.106; BC-INDEX v6.44. | — |
| **SOH-ATTACHMENTS-1 F7 DELTA CONVERGENCE APPROVED (2026-07-25): DEC-186 human APPROVED; 5/5 dimensions PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED; residuals ledgered. Release v0.6.0-dev.11 authorized.** | F7 convergence APPROVED | 2026-07-25 | PASS; DEC-186 APPROVED; MAXIMUM_VIABLE_REFINEMENT_REACHED. | BC 657; holdouts 100; VP 35; spec v1.3.106; BC-INDEX v6.44. | — |
| **SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED (2026-07-25): v0.6.0-dev.11 SHIPPED (tag @ 34d2f795); FIX-E2E-EGRESS DELIVERED (PR #654 @ 7b3ba371; e2e GREEN); session review COMPLETE (S-7.02 SATISFIED; 6 IPs); pipeline IDLE.** | CYCLE CLOSED; pipeline IDLE | 2026-07-25 | CYCLE FULLY CLOSED; NEXT: route ENGINE IPs + REPO backlog. | BC 657; holdouts 100; VP 35; spec v1.3.106; BC-INDEX v6.44; develop @ 7b3ba371. | — |

## Current Phase Steps

<!-- Keep last 4 rows only. Archive older rows to cycles/cycle-001/burst-log.md. -->
<!-- archived rows ledger: see cycles/cycle-001/burst-log.md (2026-07-25 compaction) -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **SOH-ATTACHMENTS-1 F7 DELTA CONVERGENCE APPROVED (2026-07-25): DEC-186; 5/5 dims PASS; fresh-context consistency audit CLEAN 2 doc-drifts backfilled; convergence chain F5 STRICT 14r/8 PRs + Step-7 secondary PASS + F6 all-4-dims confirmed; S-7.02 SATISFIED; spec v1.3.106; regression 2341/0; MAXIMUM_VIABLE_REFINEMENT_REACHED; residuals ledgered.** | state-manager | COMPLETE — F7 DELTA CONVERGENCE APPROVED | DEC-186; Session Resume Checkpoint updated; burst-log.md updated; factory-artifacts committed. NEXT: release v0.6.0-dev.11. |
| **SOH-ATTACHMENTS-1 CYCLE-CLOSE WRAP (2026-07-25): v0.6.0-dev.11 SHIPPED (tag @ 34d2f795; workflow 30164729267; 10 assets); session review COMPLETE (S-7.02 SATISFIED; 6 IPs: 5 ENGINE/1 REPO; 2 lessons codified); FIX-E2E-EGRESS DELIVERED (PR #654 @ 7b3ba371; e2e verify 30166373893 GREEN). Pipeline IDLE.** | state-manager | COMPLETE — CYCLE FULLY CLOSED | sprint-state.yaml updated; burst-log.md updated; session-checkpoints.md archived; factory-artifacts committed. Pipeline IDLE. |
| **DEPENDABOT-TRIAGE (2026-07-25): 8 PRs soak-complete READY for human merge: #599 #612 #632 #633 #634 #636 #637 #641. PR #645 actions/checkout 7.0.0 to 7.0.1 released 2026-07-20 SOAKING until 2026-07-27 — DEC-187: first-party Actions NOT exempt from 7-day soak; soak measured from upstream RELEASE DATE (published_at). DEC-133/DEC-178/DEC-187 uniform posture confirmed.** | state-manager | COMPLETE — DEPENDABOT-TRIAGE; 8 READY / 1 SOAKING | DEC-187 recorded; Session Resume Checkpoint updated; STATE.md compacted (2026-07-25); burst-log.md appended; factory-artifacts committed. |
| **DEPENDABOT-MERGES-COMPLETE (2026-07-25): all 8 soak-complete PRs MERGED to develop by human (DEC-173): #612 @ 0ef90609 (harden-runner 2.20.0), #633 @ 79d78f9d (cargo-deny-action 2.1.1), #634 @ 5a412975 (action-gh-release 3.0.2), #641 @ 60e6c9bb (codeql-action 4.37.1), #599 @ 2006c0d8 (clap_complete 4.6.7), #632 @ 1f6241e7 (open 5.4.0), #636 @ aeae722f (sha1 0.11.0), #637 @ a15ffe24 (toml 1.1.3). develop @ a15ffe24. Post-merge develop CI in-flight at record time (per-PR CI Gate was green pre-merge). Note: pr-manager merged #612 under explicit human authorization; remaining 7 merged by human directly on GitHub. ADDENDUM: #598 (rand 0.10.1→0.10.2) MERGED @ e72b0166 by human after dependabot auto-rebase + fresh CI green — queue fully drained 9/9. Post-merge develop CI: #636/#637 runs SUCCESS; #598 run in-flight at record time.** | pr-manager + human + state-manager | COMPLETE — DEPENDABOT-QUEUE-DRAINED 9/9 | develop @ e72b0166; STATE.md updated; factory-artifacts committed. |

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

## Convergence Status

BC-INDEX v6.44 / VP-INDEX v0.82 / STORY-INDEX v1.5.40 / ARCH-INDEX v0.16

SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED 2026-07-25: F5 SCOPED ADVERSARIAL CONVERGED STRICT (14 rounds / 8 fix PRs #644-#652; window rounds 12-14 CLEAN×3; spec v1.3.99 to v1.3.106; BC-INDEX v6.38 to v6.44; develop @ db207b81). F6 TARGETED HARDENING PASS (4 dims green; regression 2341/0). F7 DELTA CONVERGENCE APPROVED (DEC-186; 5/5 dims PASS; MAXIMUM_VIABLE_REFINEMENT_REACHED). Session review COMPLETE (S-7.02 SATISFIED; 6 IPs). FIX-E2E-EGRESS DELIVERED (PR #654 @ 7b3ba371; e2e GREEN). v0.6.0-dev.11 SHIPPED @ 34d2f795. Pipeline IDLE.

Prior cycles FULLY COMPLETE: ADF-CODE-MARK-EXCLUSIVITY (2026-07-08, DEC-163, v0.6.0-dev.8 @ 159e1be); SOH-BUGS-1 (2026-07-09, DEC-167, v0.6.0-dev.9 @ b2ce3169); SOH-COMMENT-CRUD-1 (2026-07-15, DEC-176, v0.6.0-dev.10 @ 56d5126). Full trajectories: cycles/cycle-001/convergence-trajectory.md and cycles/cycle-001/burst-log.md.

## Concurrent Cycles

| Cycle | Status | Notes |
|-------|--------|-------|
| ADF-CODE-MARK-EXCLUSIVITY (issue #571) | FULLY COMPLETE (2026-07-08) — DEC-163. Release v0.6.0-dev.8 @ 159e1be. | PR #593 @ 7ba4cf4; fix-PR #594 @ d7875e6; issue #571 CLOSED; F7 5/5 PASS. |
| SOH-BUGS-1 (issues #589+#590/#582) | FULLY COMPLETE (2026-07-09, DEC-167). Release v0.6.0-dev.9 @ b2ce3169 (PR #603; run 29051718553). | PRs #597/#601/#602/#603. Issues #589/#590/#582 CLOSED. |
| SOH-COMMENT-CRUD-1 (issue #577) | FULLY COMPLETE + RELEASED (DEC-176, 2026-07-15). v0.6.0-dev.10 @ 56d5126. Session-review loop CLOSED (D-177). | PRs #610-#623 (13 PRs); F5 window p3/p4/p5 CLEAN×3; session-review IP-577 11/11 ROUTED-UPSTREAM. |
| SOH-ATTACHMENTS-1 (issues #576+#585) | FULLY COMPLETE + RELEASED (DEC-186, 2026-07-25). v0.6.0-dev.11 @ 34d2f795. Session-review loop CLOSED (2026-07-25; 6 IPs routed). | 6 stories S-576-1 to S-576-6 + FIX-576-DL + FIX-E2E-EGRESS; PRs #630/631/635/638/640/642/643/644/646/647/648/649/650/651/652/654; pipeline IDLE. trajectory-tail →0→0→0→0 |

## Session Resume Checkpoint

| Field | Value |
|-------|-------|
| Date | 2026-07-25 (DEPENDABOT-QUEUE-DRAINED: 9/9 PRs merged to develop @ e72b0166; #598 (rand 0.10.1→0.10.2) merged by human after auto-rebase + fresh CI green; #645 soaking until 2026-07-27 (DEC-187). Pipeline IDLE.) |
| Position | Phase 3 / Feature Mode SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED. develop @ e72b0166 (#598 rand 0.10.1→0.10.2 merged, dependabot queue DRAINED 9/9). v0.6.0-dev.11 released (tag @ 34d2f795). Spec v1.3.106; BC 657/holdouts 100/VP 35; AC 80; BC-INDEX v6.44; STORY-INDEX v1.5.40. Pipeline IDLE. NEXT: human decides #645 merge (soak to 2026-07-27); then route ENGINE IPs to vsdd-factory or new intake. |
| Convergence counter | SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED. F7 DELTA CONVERGENCE APPROVED 2026-07-25 (DEC-186; 5/5 dims PASS). F6 TARGETED HARDENING PASS (4 dims green). F5 STRICT CONVERGED (14 rounds / 8 fix PRs #644-#652; window rounds 12-14 CLEAN×3). All stories + FIX-576-DL + FIX-E2E-EGRESS delivered. Full trajectory: cycles/cycle-001/convergence-trajectory.md. trajectory-tail →0→0→0→0 |
| In flight / On resume | PIPELINE IDLE. #598 develop CI run in-flight (low risk; pre-merge CI green); #645 soak. |
| Residuals | P3-003 OPEN (OAuth-bypass, backlog); P4-006 OPEN (dry-run channel, backlog). EGRESS-ALLOWLIST-NARROWING tracked (soak in progress). Enhancement candidates ledgered: SAFE-NAME-GUARD-EXTRACTION, STEP2-429-RETRY, CONTENT-TYPE-HEADER-NIT. |
| Pending human decisions | #645 soaking until 2026-07-27; #628 soak; #574 pending rebase. No blocking decisions. |
| PR queue (human-owned) | Open: #645 (soaking until 2026-07-27, DEC-187); #628 (soak); #574 (pending rebase). Dependabot queue DRAINED 9/9. DO NOT close #429. |
| Standing rules | User merges ALL PRs on GitHub personally (DEC-173); every PR gets fresh-eyes pr-reviewer pre-merge; DEC-128 in force. |
| Resume command | Open fresh session to run vsdd-factory:factory-worktree-health to read .factory/STATE.md to run /vsdd-factory:next-step. |

## RESUME PLAN (cold-start, self-contained)

Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Then read .factory/STATE.md (this file).

Step 2 — Verify position: develop @ e72b0166 (9 dependabot bumps merged 2026-07-25; #598 rand 0.10.1→0.10.2 was final merge after auto-rebase). v0.6.0-dev.11 released (tag @ 34d2f795). No in-flight worktrees or story branches. Pipeline IDLE. Counters: BC 657, NFR 42, ADR 17, Stories 117, Holdouts 100, VP 35, AC 80. Spec v1.3.106. BC-INDEX v6.44. STORY-INDEX v1.5.40. Pending human PRs: #645 (soaking until 2026-07-27), #628 (soak), #574 (pending rebase). DO NOT close #429.

Step 3 — DEPENDABOT-QUEUE-DRAINED (2026-07-25) COMPLETE: all 9 PRs merged to develop; develop @ e72b0166. First 8 merged earlier 2026-07-25 (develop @ a15ffe24). FINAL: PR #598 (rand 0.10.1→0.10.2, open since 2026-07-09) merged @ e72b0166 after dependabot auto-rebase + fresh CI green. PR #645 (actions/checkout 7.0.0 to 7.0.1; released 2026-07-20) SOAKING until 2026-07-27 (DEC-187). Post-merge develop CI: #636/#637 runs SUCCESS; #598 run in-flight (low risk). AFTER dependabot: Route ENGINE IPs (5) to drbothen/vsdd-factory. Session review doc: session-reviews/review-2026-07-25-soh-attachments-1.md.

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
