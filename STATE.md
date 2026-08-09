---
document_type: pipeline-state
level: ops
version: "2.29"
status: active
producer: state-manager
timestamp: 2026-08-09T14:05:00Z
phase: 3
pipeline: ACTIVE
inputs: []
input-hash: "[live-state]"
traces_to: ""
project: jira-cli
mode: brownfield
current_step: "COMPACTION (2026-08-09): STATE.md compacted from 372 lines / 112,071 bytes (v2.28) to this file, via the sanctioned single full-content Write path (DEC-247). The prior SESSION WRAP burst (2026-08-09) recorded STATE.md as having no working write path, on the false premise that compaction requires exactly the large write that was failing -- guard-state-bash-write.sh's own error text names the sanctioned path verbatim (a full-content Write that advances timestamp:); the failures were an output-size limit at 112KB, not a blocked path. Compacted with NO hook disabled: 168 open drift items' full narrative bodies moved verbatim to cycles/cycle-001/drift-items-open-detail.md (compact one-line index retained here, same 168-item count verified before/after); 20 closed drift items moved verbatim to cycles/cycle-001/drift-items-closed.md; 56 settled decision rows moved verbatim to cycles/cycle-001/decisions-archive.md (6 still-governing decisions retained here in full: DEC-128, DEC-202, DEC-206, DEC-224, DEC-245, DEC-246, plus new DEC-247 recorded this burst); the two rows not yet archived elsewhere (both from burst DEC-246-U1-CLOSED) appended verbatim to cycles/cycle-001/burst-log.md. No pipeline work occurred otherwise this burst -- not a fix burst, not a new adversary pass -- Step 4.5 remains 0/3 (50 passes; no pass has reviewed 9d34f354), PR #667 remains OPEN/HELD (DEC-202) at head 9d34f354, CI FINAL 15/15 PASS, mergeStateStatus CLEAN, develop @ df203233. Next action: seek human approval of three replacement inspection frontiers for a fresh S-626-1 STRICT 3-pass window (pass-54/pass-55/pass-56) against head 9d34f354 -- the previously-proposed pass-56 frontier was answered by research (DEC-246), not tested, and must be replaced."
trajectory_tail: "→1→3→0→2"
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

<!-- STATE.md SIZE BUDGET (2026-08-09 COMPACTION): 320 lines (wc-l, verified) -- prior
     (v2.28 pre-burst): 372 lines / 112,071 bytes; this burst extracted 168 open drift items'
     full text to drift-items-open-detail.md, 20 closed drift items to drift-items-closed.md, and
     56 of 60 Decisions Log rows to decisions-archive.md (compact one-line index / 6 retained
     decisions kept here), reducing this file to 320 lines. Soft-target 200; margin from
     soft-target ~= +120 (over soft target); margin from actual to hard cap 500 ~= 180. Decisions
     Log and Drift Items were the dominant size contributors and are now the dominant EXTRACTION
     target for this burst only -- superseding, for these two sections only, the 2026-08-04/
     2026-08-08 housekeeping-preservation stance (which still applies to every other section: no
     byte dropped, only relocated). See cycles/cycle-001/{decisions-archive,drift-items-closed,
     drift-items-open-detail,burst-log,session-checkpoints,lessons}.md for everything relocated
     out of this file. -->

# Pipeline State: jira-cli

## Project Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (Jira CLI) |
| **Mode** | BROWNFIELD / Rust |
| **Target Workspace** | develop to main |
| **trajectory-tail** | →1→3→0→2 (unchanged this burst -- no new adversary pass ran; this was a compaction burst, not a fix burst) |
| **Last Updated** | COMPACTION 2026-08-09: STATE.md slimmed 372→320 lines; no pipeline state changed. See `current_step` above and Historical Content below. |
| **Current Phase** | Feature Mode SOH-DX-1 **F4 DELIVERY PAUSED** -- DEC-204 fully ADJUDICATED (DEC-245); U1 (needs-set completeness gap) closed at `9d34f354` (DEC-246). F2 APPROVED (DEC-196), F3 APPROVED (DEC-197). **S-CIGATE-2 DELIVERED AND MERGED** (PR #671, `df203233`). **S-626-1 DELIVERED** -- PR #667 open, feature HEAD **`9d34f354`**, branch `ci/fix-toolchain-sha-msrv`; **HELD per DEC-202**; CI FINAL 15/15 PASS, mergeStateStatus CLEAN. Adversary: 50 recorded passes; 6 VOID; 2 NOT RUN (DEC-209); pass-20 SUPERSEDED (DEC-216). Step 4.5 remains **0/3, PAUSED** -- no pass has yet reviewed `9d34f354`, `7f8723a5`, `3ad496eb`, or `ada50a34`; next window is pass-54/pass-55/pass-56 pending frontier approval. STORY-INDEX v1.5.76 (127 stories). AX23-001 PENDING RATIFICATION. |
| **Next Phase** | Pending human decisions, in order: (1) three replacement inspection frontiers for a fresh STRICT 3-pass window (pass-54/pass-55/pass-56) against head `9d34f354`; (2) whether PR #667 can merge on code grounds independently of Step 4.5; (3) second independent required CI check for GUARD-APPARATUS-HAS-SINGLE-POINT-OF-FAILURE; (4) zero-leg matrix empirical test; (5) gitleaks blocking / enforce_admins / `strict: false` config half; (6) perimeter extension -- `docs/demo-evidence/` and/or `.factory/cycles/`; (7) two unresolved story statuses (`S-MAINT-CR-008`, `S-TRAIL-DERIVATION-GUARD-1`). Then: S-CIGATE-3 implementation, S-TRAIL-DERIVATION-GUARD-1, `.worktrees/S-CIGATE-2` cleanup, AX23-001, S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1. |
| **Activation HEAD** | 7b3ba371 (PR #654 squash-merged 2026-07-25; SOH-ATTACHMENTS-1 CYCLE FULLY CLOSED; activation_version v0.6.0-dev.11) |

## Phase Progress

<!-- Full per-burst history through DEC-246-U1-CLOSED: cycles/cycle-001/burst-log.md (this
     burst's own displaced row appended there as "## COMPACTION (archived rows from STATE.md
     2026-08-09)"). -->
| Phase | Status | Completed | Gate | Notes | Finding Progression |
|-------|--------|-----------|------|-------|---------------------|
| **COMPACTION (2026-08-09): STATE.md compacted 372→320 lines; Decisions Log and Drift Items extracted to cycles/cycle-001/ (see Historical Content). Not a fix burst, no new adversary pass ran -- no pipeline state changed. Step 4.5 remains 0/3, PR #667 HELD (DEC-202) at `9d34f354`; next window is pass-54/pass-55/pass-56, pending human approval of three replacement inspection frontiers.** | PAUSED | 2026-08-09 | -- | Factory paused, pipeline ACTIVE. Pending human approval of replacement inspection frontiers for pass-54/pass-55/pass-56 against `9d34f354`, plus six research-surfaced CI-governance items (second required check, zero-leg matrix test, gitleaks/enforce_admins ruling). PR #667 HELD (DEC-202). AX23-001 PENDING. | →1→3→0→2 |

## Current Phase Steps

<!-- Full step-by-step burst history: cycles/cycle-001/burst-log.md. All five rows live in
     STATE.md at v2.28 compaction time (ADVERSARY-51-52-53, PILE-1-GUARD-STRENGTH,
     CLASS-LEVEL-STALE-CLAIM-SWEEP, DEC-204-ADJUDICATED, DEC-246-U1-CLOSED) are archived there
     verbatim -- the first four already existed under their own burst-log.md headers; the fifth
     (DEC-246-U1-CLOSED) was appended this burst under "## COMPACTION (archived rows from
     STATE.md 2026-08-09)". -->
| Step | Agent | Status | Output |
|------|-------|--------|--------|
| **COMPACTION (2026-08-09): state-manager ran /vsdd-factory:compact-state on STATE.md v2.28 (372 lines / 112,071 bytes) per human-approved dispatch. Extracted: 168 open drift items (full text, count verified unchanged before/after) → drift-items-open-detail.md; 20 closed drift items → drift-items-closed.md; 56 settled decisions → decisions-archive.md (6 still-governing decisions + new DEC-247 retained in STATE.md). Two previously-unarchived rows (DEC-246-U1-CLOSED's Phase Progress and Current Phase Steps rows) → burst-log.md. One prior checkpoint marked [ARCHIVED] with a supersession note; one lesson logged tagged [codified]. Not a fix burst, no adversary pass dispatched this burst.** | state-manager | COMPLETED | STATE.md v2.28→v2.29 (372→320 lines) + 3 new cycle files + burst-log.md/session-checkpoints.md/lessons.md appended + DEC-247 recorded, committed to factory-artifacts. Next: human approval of three replacement inspection frontiers for a fresh S-626-1 STRICT 3-pass window (pass-54/pass-55/pass-56) against `9d34f354`. |

## Decisions Log

<!-- Full Decisions Log (DEC-001 through DEC-246, 60 rows) extracted to
     cycles/cycle-001/decisions-archive.md during the 2026-08-09 COMPACTION burst. Retained here,
     in full, are only the decisions that still GOVERN behavior today. -->
| ID | Decision | Rationale | Phase | Date |
|----|----------|-----------|-------|------|
| DEC-128 | **MERGE AUTHORITY IS THE HUMAN'S (CRITICAL).** Delivery sub-agents must NOT self-authorize merges, spawn fix agents, push, or enter unbounded loops. CI green / mergeStateStatus CLEAN is not merge authorization. *(Original ruling is inside the collapsed DEC-001..DEC-155 range in decisions-archive.md, which has no separate DEC-128 row of its own; this entry restates the standing citation form used verbatim throughout this project's history -- e.g. `session-checkpoints.md:1164/1182/1200`.)* | Foundational merge-safety constraint; cited at every subsequent merge-adjacent decision (DEC-234, DEC-235, DEC-238, DEC-243...). | Phase 0-3 (original); standing | archived origin; standing |
| DEC-202 | **PR #667 HELD until fixes land and a fresh window opens.** *(Extracted clause from the combined DEC-199..DEC-203 ruling; full combined row in decisions-archive.md.)* | Human ruling 2026-07-31, reaffirmed at every subsequent window close through DEC-246. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-07-31 |
| DEC-206 | **VOID PROTOCOL FOR ISOLATION BREACHES.** Adversary passes where orchestrator dispatch defects leak banned-path content are VOID for step-4.5 window eligibility; findings remain valid. | Human ruling on isolation protocol. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-03 |
| DEC-224 | **ISOLATION ELIGIBILITY PRINCIPLE.** A pass is ELIGIBLE (not VOID) when a letter-of-rule isolation deviation occurred but zero banned content actually surfaced; VOID applies only when banned content actually became visible. Self-disclosure without surfacing is a POSITIVE signal. Applied and held across every subsequent window through 51/52/53. | Principled distinction: the rule prevents contamination, not path syntax deviation. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-04 |
| DEC-245 | **DEC-204 ADJUDICATED -- CONSERVATIVE READING RULED.** A pass is CLEAN only with zero HIGH, zero MEDIUM and zero LOW findings; INFO-only findings still count as CLEAN; LOW findings reset the window regardless of GAP-vs-refinement classification. Step 4.5 remains 0/3, confirmed by ruling. | Lenient reading would have stopped the cycle before discovering ADV-P50-HIGH-001, pass-51's three HIGH findings, and pass-53's two HIGH findings -- the conservative criterion has been expensive but a productive defect finder. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-08 |
| DEC-246 | **U1 CLOSED.** External research validated 8 GitHub Actions gating-semantics questions against primary sources (all CONFIRMS), then found U1: a needs-set completeness gap no adversarial pass surfaced in 50 passes. Fixed via `PINNED_GATE_EXCLUDED_JOBS` + two new tests, commit `9d34f354`. | Every pass reasoned within the project's model of GitHub's semantics; none tested the model itself -- research closed that blind spot. | Feature Mode SOH-DX-1 F4 Step 4.5 | 2026-08-08 |
| DEC-247 | **STATE.md WRITE-PATH DEADLOCK RESOLVED (2026-08-09).** The prior SESSION WRAP burst recorded no working write path for STATE.md, concluding "compaction requires exactly the large write that is failing." That conclusion was false. `guard-state-bash-write.sh`'s own error text names the sanctioned path verbatim: a full-content `Write` that advances `timestamp:`. `Write` is the BLESSED path, not a blocked one -- it failed only because the v2.28 payload was 112,071 bytes, exceeding an output-size limit unrelated to the guard. Compaction's final write is a slim file, well within limits. Extraction writes go to `.factory/cycles/cycle-001/*.md`, which carry no guard hooks. Compaction was executed with **no hook disabled, moved, renamed, chmod'd, or edited**; no Bash write targeting STATE.md; no Edit on STATE.md. Reusable engine-level lesson, also logged to `cycles/cycle-001/lessons.md` tagged `[codified]` per S-7.02. | A deadlocked write path blocks the whole factory; the fix was recognizing the sanctioned path already existed, not disabling a guard. | Factory process / engine-level | 2026-08-09 |

## Skip Log

All S-WIN-1..6 + #475 + S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 + S-MAINT-DEAD-CITATION-CI + S-626-1 per-AC demos: Yes -- adapted (S-626-1: 11 artifacts at `.factory/demos/S-626-1/`). See cycles/cycle-001/burst-log.md.

## Blocking Issues

None open.

## Drift Items (open / tracked)

<!-- COMPACTED 2026-08-09: this table is now a compact one-line-per-item index. Full narrative
     bodies for all 168 OPEN items are in cycles/cycle-001/drift-items-open-detail.md -- update
     the row there and this index together. The 20 CLOSED/SUPERSEDED/RESOLVED rows removed from
     this table are in cycles/cycle-001/drift-items-closed.md. Open-item count verified: 168
     before this burst's index compaction, 168 after (no item dropped). Per-burst new/updated/
     closed drift-item ledger through this burst: cycles/cycle-001/burst-log.md. -->
| ID | Severity | Summary |
|----|----------|---------|
| SIX-AXIS-REVIEW-UNLOGGED | LOW | spec integrity |
| STALE-FACTORY-ARTIFACTS-BRANCH | LOW | branch hygiene |
| FORK-OPS-537-NITS | LOW | PR #537 optional nits; inert. |
| FORK-OPS-PHANTOM-RUNS | LOW | ~7 phantom runs/day. Cosmetic. |
| WIN-CFG-TESTS-CHECK | LOW | cargo check --lib excludes #[cfg(test)]; use --tests. |
| WIN-DENY-FRAGILITY | LOW | Canonical-un-skipped-version has no CI guard. |
| WIN-AUTH-ENVLOCK-POISON | LOW | .lock().unwrap() in auth tests. |
| E2E-PG-4 | LOW | remote-link round-back (no jr remote-link read). |
| PG-A / DRIFT-README | LOW | check-bc-cumulative-counts.sh does not cover README.md. |
| WIN-PG-1 | LOW | 3rd recurrence of JR_* test-seam doc-fallout without CI parity check. |
| WIN-PG-2 | LOW | Presence-only-test disclosure field missing from story template. |
| WIN-RUNTIME-OAUTH-PROBE | LOW | Release OAuth verification is constants-file check only. |
| WIN-AC004-DIRECTIONAL | LOW | Enforcement test has directional blind spot on XDG to JR seam-migration. |
| LESSON-F2-WORKTREE-FIRST | LOW | ALL story-scoped edits must be in worktree, even docs/. |
| CITATION-FORM-DISCIPLINE | LOW | Bare file:NN citations recur vs #408 symbol-form convention; no CI guard. Third instance. |
| FORK-OPS-COMPOSITE-ACTION-SCAN | LOW | Injection guard does not follow local composite actions; none exist today. |
| FORK-OPS-HEADBRANCH-EMPTY-GUARD | LOW | Empty head_branch to TAG="" / VERSION="" (theoretical). |
| FORK-OPS-ALPHA-ORPHAN-CLEANUP | LOW | Orphaned alpha tags accumulate. |
| FORK-OPS-BACKFILL-ZIP-GLOB-COUPLING | LOW | gh release upload jr-*.zip fails loud on zero-match glob. |
| FORK-OPS-F5-SELFTEST-CHECKLIST | LOW | F5 checklist conflates --self-test inline fixture with real-file scan. |
| MAINT-PG-CI-DOC-LINT | LOW | CLAUDE.md src-file-tree drift recurring; add check-claude-md-tree.sh to CI. |
| PERF-BASELINE-ABSENT | LOW | Perf sweep skipped 4x. Baseline: binary 7.09MB, jr --help p50 6.4ms (2026-06-25). |
| PERF-COST-TRACKING | LOW | No per-cycle token/cost tracking; .factory/cost-summary.md not initialized. |
| MUTANTS-POLICY-CITATION-GUARD | LOW | cargo-mutants-policy.md section Scope function-location bulleted list against src/. |
| MUTANTS-GLOB-EXISTENCE-GUARD | LOW | examine_globs entries not validated against filesystem at CI time. AC-9 multi-pass confirmation. |
| PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY | LOW | F1 perimeter scan must include BC-INDEX.md + CANONICAL-COUNTS + traceability artifacts. |
| BC-INDEX-9TH-SURFACE | LOW | BC-INDEX.md coverage statistics not covered by check-bc-cumulative-counts.sh. RECURRENCE COUNT: 10. |
| COMPANION-LINT-CHECK-BC-SINGLE-LINE-TRACE | LOW | Guard 1 does not enforce single-line Trace/Source fields. |
| BC-X5008-STALE-LINE-CITE | LOW | BC-X.5.008 Source cites stale line range. DEC-146. |
| PF-008-ASSET-ID-RESULT-HARDENING | LOW | Result-propagation hardening at src/api/assets/linked.rs + src/cli/issue/list.rs. |
| RA-001-JRACLOUD-PAGINATION-DOC | LOW | JRACLOUD user pagination fixed-window load-bearing but not cited in CLAUDE.md Gotchas. |
| RA-002-ADR-0013-PKCE-REVALIDATE | LOW | ADR-0013 PKCE deferral ~50 days old as of 2026-06-25. Re-validate before OAuth work. |
| TEST-ONLY-GATE-ELIGIBILITY | MEDIUM | Codify rule for whether/when test-only PRs run adversarial gate. |
| CACHE-COVERAGE-GAPS-2026-06-27 | LOW | P1/P2/P3/D2 DONE. Remaining: D5 write-error resilience. |
| MUTANTS-BUNDLE-TIMEOUT-CALIBRATION | LOW | Bundle-scoped mutation runs need --timeout 480 or --jobs 2. |
| BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD | LOW | #526 forbidden-compact-JSON invariant is review-only with no CI guard. |
| ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY | MEDIUM | F5-p3 adversary self-declared CLEAN while simultaneously reporting 1 LOW finding. 2nd datapoint: pass-83. |
| F5-OBS-001 | LOW | BC-7.2.015 lossiness not cross-listed in BC-7.2.011 five-case lossy round-trip catalogue. |
| F5-OBS-002 | LOW | No runtime stderr warning when push_code strips typographic marks. |
| PR-MANAGER-HOOK-VS-DEC-128-CONFLICT | MEDIUM | pr-manager-completion-guard hook demanded AUTHORIZE_MERGE while DEC-128 dispatch forbade merge. |
| CLAUDE-MD-CLIPPY-ALL-TARGETS-DRIFT | LOW | CLAUDE.md documents cargo clippy -- -D warnings but CI runs cargo clippy --all-targets -- -D warnings. |
| RELEASING-MD-MISSING | LOW | No RELEASING.md in repo root. |
| PG-F4-1 | MEDIUM | Implementer pushed + opened PR #610 prematurely. STOP-on-deviation mandate. |
| PG-F4-5 | MEDIUM | Doc-fix instructions must mandate whole-artifact audit. |
| PG-F4-11 | MEDIUM | S-577-5 implementer improvised e2e scope substitution. |
| FACTORY-DISPATCHER-HOOK-TIMEOUT | MEDIUM | factory-dispatcher PostToolUse hook fired fail-closed on spec edits. RECURRENCE COUNT: 22+. |
| SPEC-CHANGELOG-RESYNC | LOW | spec-changelog.md goes stale across fix rounds. RECURRENCE COUNT: 3. |
| TWIN-ARTIFACT-SWEEP | LOW | Fix rounds must propagate spec changes to ALL mirroring artifacts. RECURRENCE COUNT: 20. |
| FOOTER-FRONTMATTER-CONVENTION-MISS | LOW | bc-3-issue-write.md footer + frontmatter trail parity. No CI guard. |
| S-576-3-P3-003 | LOW | Upload multipart path bypasses JiraClient::send() so OAuth blanket-401 auto-refresh does not apply. |
| P4-006 | LOW | Upload --dry-run human-preview channel divergence. |
| WAVE-576-05 | LOW | Per-file stale-heal exit-code inconsistency. |
| SAFE-NAME-GUARD-EXTRACTION | LOW | SEC-576-004 safe_name guard copy-pasted identically in two files; lockstep-update risk. |
| STEP2-429-RETRY | LOW | post_request_attachment (JSM step-2) does not retry on 429. |
| CONTENT-TYPE-HEADER-NIT | INFO | Redundant .header("Content-Type") in post_request_attachment. |
| PG-576-1 | LOW | Prose test-count drift class. |
| PG-576-2 | LOW | Clippy scope gap (--all-targets). |
| DEPENDABOT-COOLDOWN-OFFBYONE-612 | LOW | PR #612 opened 24h early. |
| CV-FALSE-POSITIVE-CLOSURE | LOW | Consistency validator false closure/carry claims: 5 datapoints. Mitigation working. |
| SOH-DX-1-PG-001 | MEDIUM | No STATE-claims-vs-artifacts cross-check guard. THIRD DATAPOINT. |
| SOH-DX-1-PG-002 | LOW | Test-symbol citation guard does not cover non-bc-*.md artifacts. |
| SOH-DX-1-PG-003 | LOW | expect(0) ACs must pin would-otherwise-proceed setup + positive stderr assertion. |
| SOH-DX-1-PG-004 | LOW | No CI pin on help-text semantics for flags with exit-code contracts. |
| SOH-DX-1-PG-005 | LOW | No changelog Type↔version-component guard. |
| SOH-DX-1-PG-006 | LOW | EC-field symbol citations in spec not guarded by check-bc-citation-symbols.sh. |
| SOH-DX-1-PG-007 | LOW | Citation guard skips AC continuation lines. |
| SOH-DX-1-PG-008 | LOW | Falsifiability rule for ACs is prose-only; no CI guard. |
| SOH-DX-1-PG-009 | LOW | prd/README.md is an unguarded 9th count surface. |
| SOH-DX-1-PG-010 | LOW | Foreign-handler-negative heuristic codified only in prose. |
| SOH-DX-1-PG-011 | LOW | Trace continuation-line guard blind spot. |
| SOH-DX-1-PG-012 | LOW | Mechanical replace_all on spec artifacts has no immutable-entry guard. MITIGATION PATTERN CODIFIED. |
| TRAIL-ORDER-ANOMALY-BC3 | LOW | bc-3-issue-write.md frontmatter trail ordering anomaly. |
| AGENT-IDLE-NO-REPORT | MEDIUM | platform defect #47936 (background subagents 14-30% fail mid-work). |
| PO-REPORT-FIDELITY | LOW | product-owner reported fabricated changelog-count line. |
| VP-INDEX-ARTIFACT-ABSENT | LOW | VP-INDEX is canonical VSDD artifact. Fold into VSDD-CONFORMANCE-GAP-4-ARTIFACTS. DEC-195. |
| INPUT-HASH-DRIFT-BACKLOG-56 | MEDIUM | 56+ artifacts stale on input-hash across closed cycles. |
| INPUT-HASH-MALFORMED-INPUTS-3 | LOW | Three artifacts declare unresolvable inputs. |
| APERTURE-CLASS-LESSON | MEDIUM | Internal-consistency review cannot detect false factual claims. |
| RANGE-TERMINUS-INFERENCE | MEDIUM | Any range-notation claim must have its maximum verified by enumeration. |
| UPSTREAM-COMPLETENESS-APERTURE | MEDIUM | Internal-consistency review cannot detect upstream-phase obligation gaps. |
| ORCHESTRATOR-ERROR-INJECTION-RATE | MEDIUM | Fix instructions must enumerate expected post-state counts. Multiple datapoints. |
| VSDD-CONFORMANCE-GAP-4-ARTIFACTS | MEDIUM | jira-cli lacks four canonical VSDD artifacts: VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md. |
| PLUGIN-ACTIVATION-VERSION-DRIFT | LOW | .claude/settings.local.json vsdd-factory.activated_plugin_version drift vs installed. |
| NUDGE-TWICE-BEFORE-VOID | LOW | Standing rule: never record VOID until nudged twice. |
| STATE-WRITE-TIMESTAMP-COMPLIANCE | LOW | verify-state-timestamp-refresh blocks STATE.md writes that don't advance timestamp:. |
| LOCAL-BASH-WRITE-GUARD-INSTALLED | LOW | .claude/hooks/guard-state-bash-write.sh blocks Bash-based writes to STATE.md. |
| ADVERSARY-ARTIFACT-WRITE-MITIGATION | LOW | adversary agents have no Write tool by design. Mitigation: orchestrator manually routes artifact writes. |
| REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED | MEDIUM | adversary process |
| VERIFICATION-NONGOAL-UNSCRUTINIZED | MEDIUM | spec integrity |
| ADV-P76-LOW-001 | LOW | spec quality |
| P77-001 | LOW | spec quality |
| POL-11-RESIDUAL-OPTIONAL-FILE-BRANCHES | MEDIUM | guard hygiene |
| POL-11-GUARD-NO-SELFTEST | LOW | guard hygiene |
| CHECK-SPEC-COUNTS-SILENT-EXIT1 | LOW | guard hygiene |
| FACTORY-READ-AFTER-WRITE-UNRELIABLE | MEDIUM | factory process |
| TRAJECTORY-TAIL-SEVERITY-LOSS | LOW | factory process |
| CLAUDE-MD-PROFILE-TAXONOMY-DEFECT | MEDIUM | doc quality |
| ADV-P83-MEDIUM-001 | LOW | CI/F4 |
| ADV-P83-LOW-001 | LOW | CI/F4 |
| P79-003 | LOW | spec quality |
| P79-004 | LOW | spec quality |
| P80-002 | LOW | spec quality |
| PLATFORM-BASH-CLASSIFIER-OUTAGE | LOW | platform/tooling |
| ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE | MEDIUM | adversary process |
| ANCHOR-RESOLUTION-AXIS-NOT-APPLIED | MEDIUM | spec integrity |
| NAMED-BACKGROUND-SUBAGENT-REPORT-LOSS | MEDIUM | platform/tooling |
| ORCHESTRATOR-PREMATURE-DEAD-AGENT-CONCLUSION | MEDIUM | orchestrator process |
| MSRV-JOB-NO-POSITIVE-COVERAGE | MEDIUM | CI/F4 |
| GITLEAKS-NOT-IN-CI-GATE-NEEDS | MEDIUM | CI governance |
| ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT | MEDIUM | adversary process |
| FIX-ROUND-PARTIAL-PROPAGATION | HIGH | spec process |
| CITATION-GUARD-SRC-ONLY | MEDIUM | spec integrity |
| ARCH-INDEX-REGISTRY-COVERAGE-GAP | MEDIUM | spec integrity |
| S-576-FAMILY-SUBSYSTEM-PATTERN | MEDIUM | spec integrity |
| KEYCHAIN-CREDENTIAL-PATH-UNCOVERED | MEDIUM | test coverage |
| FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE | MEDIUM | spec process |
| DEMO-TRANSCRIPT-FIDELITY-NO-MECHANICAL-GUARD | MEDIUM | spec process |
| STATE-VERDICT-LABEL-AMBIGUITY | MEDIUM | state integrity |
| PASS-NUMBERING-COLLIDES-ACROSS-CYCLES | LOW | state integrity |
| BC-BEHAVIOR-FIELD-SYSTEMIC-ABSENCE | MEDIUM | spec completeness |
| ORCHESTRATOR-PROPAGATED-FALSE-JUSTIFICATION | HIGH | spec process |
| ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD | HIGH | orchestrator discipline |
| ORCHESTRATOR-UNVERIFIED-BREAK-SPECULATION | LOW | orchestrator discipline |
| FMT-CLIPPY-NO-POSITIVE-COVERAGE | MEDIUM | CI integrity |
| INPUT-HASH-BYPASS-MARKERS-SILENTLY-SKIP-VALIDATION | MEDIUM | guard hygiene |
| BC-02-INPUT-LINEAGE-IMPRECISE | LOW | spec provenance |
| GUARD-BYPASSED-BY-TOOL-SUBSTITUTION | MEDIUM | guard hygiene |
| PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES | MEDIUM | spec process |
| CHECK-SPEC-COUNTS-COVERAGE-SCOPE | INFO | guard coverage |
| MIXED-SET-DASH-ARM-UNPINNED | MEDIUM | test coverage |
| WRONG-FILE-MIS-ANCHORS-IN-TESTS | LOW | citation hygiene |
| ISOLATION-WHITELIST-LEAKS-FINDING-IDS | MEDIUM | adversary process |
| HOOK-REGEX-FALSE-POSITIVE-CLASS | MEDIUM | factory tooling |
| AGENT-BACKGROUND-RUN-DEADLOCK | LOW → recommend MEDIUM | factory tooling |
| TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE | HIGH | convergence process |
| SHARED-WORKTREE-REVIEWER-CONTAMINATION | HIGH → recommend MEDIUM | review methodology |
| STORY-FROZEN-HEAD-LAGS-LIVE-HEAD | MEDIUM | spec process |
| FRONTMATTER-YAML-PARSEABILITY-UNGUARDED | LOW | factory tooling |
| LINE-RANGE-CITATIONS-DRIFT-SILENTLY | MEDIUM | spec citation hygiene |
| FIX-PASS-CATCHES-MORE-THAN-REVIEW-PASS | INFO | process observation |
| DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE | HIGH | convergence methodology |
| SUBSTRING-GUARD-CANNOT-VERIFY-COMPUTED-VALUES | MEDIUM | verification design |
| SPEC-CLAIMS-LACK-VERIFICATION-DISCLOSURE | MEDIUM | spec design |
| HONESTY-FIXES-CAN-BE-INCOMPLETE | MEDIUM | remediation process |
| ORCHESTRATOR-FALSE-FABRICATION-ACCUSATION | MEDIUM | orchestrator process |
| BC-COVERAGE-GAP-FOR-CI-GATE-GUARDS | HIGH | spec integrity |
| AGENT-IDLE-WITHOUT-DELIVERY | MEDIUM | process quality |
| SCOPED-GREP-CLAIM-EXCEEDS-EVIDENCE | LOW | process observation |
| SPEC-CITATIONS-UNGUARDED-FOR-TEST-SYMBOLS | MEDIUM | guard coverage |
| S-CIGATE-1-TABLE-CELL-DEFECT | LOW | spec quality |
| PR-518-ANNOTATION-DEFERRED | INFO | process quality |
| CLOSED-STORY-CONTRADICTS-SHIPPED-BEHAVIOR | HIGH | spec integrity |
| ORCHESTRATOR-CONCURRENT-WRITER-COLLISIONS | HIGH | orchestrator process |
| RED-PROOF-REQUIRES-FOUR-CONDITIONS | HIGH | verification methodology |
| STALE-ARTIFACT-PRODUCES-FALSE-CLAIM | HIGH | verification integrity |
| LOCAL-VERIFICATION-MISSES-PLATFORM-MATRIX | MEDIUM → recommend HIGH | CI/review process |
| EXTRACTOR-UNDER-REPORT-FAILS-OPEN | HIGH | verification design |
| SILENT-MERGE-CONCATENATION-DEFEATS-CONFLICT-DETECTION | HIGH | merge/reconciliation integrity |
| TRAIL-DERIVATION-UNGUARDED | MEDIUM | spec process |
| STORY-ROUND-COUNTER-DIVERGES-FROM-STATE | LOW | process/state integrity |
| PER-BRANCH-PINS-PARTIALLY-RED-PROVEN | LOW | guard integrity |
| PARTIAL-EDIT-LOOKS-COMPLETE | MEDIUM | remediation process |
| GUARD-APPARATUS-HAS-SINGLE-POINT-OF-FAILURE | HIGH | CI governance |
| ZERO-LEG-MATRIX-RESULT-UNDOCUMENTED | MEDIUM | CI governance |
| SECRET-SCAN-NOT-A-MERGE-BLOCKER | MEDIUM | CI governance |
| DUPLICATE-CHECK-NAME-BEHAVIOR-UNDOCUMENTED | LOW | CI governance |
| ADMIN-BYPASS-POSTURE-UNRECORDED | LOW | CI governance |
| REQUIRED-CHECK-NAME-UNPINNED | LOW | CI governance |

## Convergence Status

**COMPACTION (2026-08-09):** STATE.md compacted from 372 to 320 lines; no pipeline state changed this burst. Full trajectory detail: cycles/cycle-001/convergence-trajectory.md.

BC-INDEX v6.75 / STORY-INDEX v1.5.76 (127 stories) / ARCH-INDEX v0.16. SOH-DX-1 F2 APPROVED (DEC-196, 2026-07-29). F3 APPROVED (DEC-197, 2026-07-29): spec v1.3.169; BC 658 (unchanged); holdouts 106. S-626-1 adversary: 50 recorded passes (6 VOID: 3 dispatch + 3 isolation; pass-20 SUPERSEDED per DEC-216); 395 total findings (unchanged this burst -- a compaction burst, not a new pass). PR #667 remains OPEN and HELD per DEC-202, head `9d34f354`, CI FINAL 15/15 PASS, mergeStateStatus CLEAN. src/ 0-defect THIRTY-THIRD consecutive (unchanged). S-CIGATE-2 remains DELIVERED AND MERGED (PR #671, `df203233`); S-CIGATE-3 v1.1/P2/draft; S-CIGATE-4 remains done; S-TRAIL-DERIVATION-GUARD-1 remains draft/P2. AX23-001 PENDING RATIFICATION.

SOH-ATTACHMENTS-1 + prior cycles FULLY CLOSED. See cycles/cycle-001/convergence-trajectory.md.

## Concurrent Cycles

<!-- Prior completed cycles archived to burst-log: ADF-CODE-MARK-EXCLUSIVITY (DEC-163, v0.6.0-dev.8), SOH-BUGS-1 (DEC-167, v0.6.0-dev.9), SOH-COMMENT-CRUD-1 (DEC-176, v0.6.0-dev.10), SOH-ATTACHMENTS-1 (DEC-186, v0.6.0-dev.11). See cycles/cycle-001/convergence-trajectory.md. -->
| Cycle | Status | Notes |
|-------|--------|-------|
| SOH-DX-1 (issues #639+#627+#626) | F4 DELIVERY PAUSED -- DEC-204 fully ADJUDICATED (DEC-245); U1 closed (DEC-246) at `9d34f354`. **S-626-1 DELIVERED** (PR #667, feature HEAD **`9d34f354`**; **HELD -- DEC-202**, CI FINAL 15/15 PASS, mergeStateStatus CLEAN); Step 4.5 = 0/3 -- 50 passes, no pass has yet reviewed `9d34f354`. **S-CIGATE-2 DELIVERED AND MERGED** (PR #671 squash-merged `df203233`); **S-CIGATE-3** (v1.1, P2/draft); **S-CIGATE-4** (done) unchanged; **S-TRAIL-DERIVATION-GUARD-1** (P2/draft, status unresolved) unchanged. No drift items or decisions changed this burst (compaction only). | 3 stories: S-639-1 (BREAKING/v0.6.0-dev.12), S-627-1, S-626-1 (DELIVERED, PAUSED). Plus S-CIGATE-2 (DELIVERED/MERGED), S-CIGATE-3 (P2, draft), S-CIGATE-4 (P1, done), S-TRAIL-DERIVATION-GUARD-1 (P2, draft, status unresolved). S-626-1 adversary: 50 passes; 395 findings (unchanged); THIRTY-THIRD zero-src/-defect consecutive. AX23-001 PENDING. |

## Session Resume Checkpoint
| Field | Value |
|-------|-------|
| Position | Feature Mode SOH-DX-1, phase F4. COMPACTION burst (2026-08-09): STATE.md slimmed from 372 lines / 112,071 bytes to 320 lines via the sanctioned single full-content Write (DEC-247 resolves the prior SESSION WRAP burst's false "no write path" conclusion). No pipeline state changed -- not a fix burst, no adversary pass dispatched. PR #667 remains OPEN, HELD (DEC-202) at head `9d34f354`, CI 15/15 FINAL PASS, mergeStateStatus CLEAN. develop @ `df203233` (unchanged). |
| Convergence | Step 4.5 remains 0/3 -- 50 passes; no adversarial pass has reviewed `9d34f354`, `7f8723a5`, `3ad496eb`, or `ada50a34`. 395 total findings (unchanged). src/ 0-defect THIRTY-THIRD consecutive. The pass-56 frontier proposed before this burst was answered by research (DEC-246), not tested, and must be replaced with three genuinely new frontiers before the next window (pass-54/pass-55/pass-56) dispatches. |
| Not yet done | (1) Three replacement inspection frontiers for a fresh S-626-1 STRICT 3-pass window (pass-54/pass-55/pass-56) against head `9d34f354`. (2) Whether PR #667 can merge on code grounds independently of Step 4.5. (3) Second independent required CI check for GUARD-APPARATUS-HAS-SINGLE-POINT-OF-FAILURE. (4) Zero-leg matrix empirical test (ZERO-LEG-MATRIX-RESULT-UNDOCUMENTED). (5) Gitleaks blocking / enforce_admins / `strict: false` config-half ruling. (6) Perimeter extension -- `docs/demo-evidence/` and/or `.factory/cycles/`. (7) Two unresolved story statuses: `S-MAINT-CR-008`, `S-TRAIL-DERIVATION-GUARD-1`. Carried forward: S-CIGATE-3 implementation, S-TRAIL-DERIVATION-GUARD-1 tooling-approach evaluation, S-640-1 handoff, S-MAINT-576-HYG-1 scheduling, MIXED-SET-DASH-ARM-UNPINNED test story, ISOLATION-WHITELIST-LEAKS-FINDING-IDS ruling, SHARED-WORKTREE-REVIEWER-CONTAMINATION downgrade ruling, BC-COVERAGE-GAP-FOR-CI-GATE-GUARDS follow-up story, `.worktrees/S-CIGATE-2` cleanup (verified merged via squash PR #671, remote branch already deleted). |
| In flight | develop @ `df203233` (unchanged). PR #667 OPEN, head `9d34f354`, CI 15/15 FINAL PASS, mergeStateStatus CLEAN -- HELD DEC-202 regardless; DEC-128 merge authority is the human's. .factory @ factory-artifacts, this burst's commit is the head. Worktree: `.worktrees/S-626-1` (branch ci/fix-toolchain-sha-msrv, at `9d34f354`); `.worktrees/S-CIGATE-2` merged, still mounted -- cleanup candidate. No factory lock held. |
| Pending human decisions | Same seven items as "Not yet done" above, in the same order, plus: trail-guard tooling for S-TRAIL-DERIVATION-GUARD-1, AX23-001 out-of-delta ratification, MIXED-SET-DASH-ARM-UNPINNED scheduling, ISOLATION-WHITELIST-LEAKS-FINDING-IDS ruling, SHARED-WORKTREE-REVIEWER-CONTAMINATION downgrade, BC-COVERAGE-GAP-FOR-CI-GATE-GUARDS follow-up BC/VP-minting authorization. |
| Resume command | Open fresh session → `/vsdd-factory:next-step`. **COMPACTION is complete -- STATE.md is now 320 lines; the write-path deadlock (DEC-247) is resolved.** Recommended first step: seek human approval of three replacement inspection frontiers (the pass-56 frontier was answered by research, not tested) for a fresh S-626-1 STRICT 3-pass window (pass-54/pass-55/pass-56) against head `9d34f354`. Also pending: whether PR #667 is mergeable on code grounds independently of Step 4.5; six new CI-governance drift items from research (second required check, zero-leg matrix test, gitleaks/enforce_admins ruling). PR #667 HELD (DEC-202), head `9d34f354`, CI 15/15 FINAL PASS, mergeStateStatus CLEAN. AX23-001 PENDING. |

## RESUME PLAN (cold-start)
Step 1 (BLOCKING): Run vsdd-factory:factory-worktree-health. Read this file.
Step 2 -- **COMPACTION is complete: STATE.md slimmed 372→320 lines (DEC-247 resolves the write-path deadlock).** No pipeline state changed. Step 4.5 remains 0/3 -- 50 passes, no pass has yet reviewed `9d34f354`. Seek human approval, in order: (1) three replacement inspection frontiers for a fresh STRICT window (pass-54/pass-55/pass-56) against `9d34f354` (the pass-56 frontier was answered by research, not tested); (2) whether PR #667 can merge on code grounds; (3) second independent required CI check (GUARD-APPARATUS-HAS-SINGLE-POINT-OF-FAILURE); (4) zero-leg matrix empirical test; (5) gitleaks blocking / enforce_admins / `strict: false` config half; (6) whether to extend the perimeter to `docs/demo-evidence/` and/or `.factory/cycles/`; (7) the two unresolved story statuses (`S-MAINT-CR-008`, `S-TRAIL-DERIVATION-GUARD-1`). S-CIGATE-3 implementation and S-TRAIL-DERIVATION-GUARD-1 remain available as alternative priorities.
Step 3 -- Once the fresh-window frontiers are approved: dispatch the STRICT window (pass-54/pass-55/pass-56) against head `9d34f354` under the ruled criterion (DEC-245). Also pending: S-640-1 handoff, S-MAINT-576-HYG-1, S-639-1 (BREAKING/v0.6.0-dev.12). PR #667 HELD until 3/3 CLEAN under the ruled criterion -- CI is CLEAN but that is not merge authorization. MIXED-SET-DASH-ARM-UNPINNED test story to schedule. ISOLATION-WHITELIST-LEAKS-FINDING-IDS ruling needed; SHARED-WORKTREE-REVIEWER-CONTAMINATION downgrade ruling needed; BC-COVERAGE-GAP-FOR-CI-GATE-GUARDS needs a follow-up-story ruling. **Dispatch discipline reminder (standing):** state-manager runs LAST in a burst; never dispatch two agents writing to a shared artifact concurrently; verify count/trail claims against the derivation command, not a recorded number (PARTIAL-EDIT-LOOKS-COMPLETE); frontier variety, not pass count, is what makes a CLEAN verdict meaningful (DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE); re-derive live-state claims from source at every session resume, not just at capture time (STALE-ARTIFACT-PRODUCES-FALSE-CLAIM); when STATE.md needs compaction, use the Write tool with content that advances `timestamp:` -- that is the sanctioned path, not a blocked one (DEC-247).

## Open Issues Tracker

| Issue | Title | Status | Priority | Notes |
|-------|-------|--------|----------|-------|
| #429 | jr_isolated() crypto-random suffix | OPEN | LOW | DEC-029 deferred to human. Do NOT close autonomously. |
| #400 | Test-hardening + process-gap follow-ups | OPEN -- Story A MERGED PR #431. Story B + engine items remain. | LOW | |
| #372 | cargo-mutants partial baseline | OPEN | LOW | Follow-up from #346 |
| #387/#368 | git history rewrite / open PR | OPEN | LOW | Force-push needed. Deferred. |

## Historical Content

See `cycles/cycle-001/`: burst-log.md, convergence-trajectory.md, session-checkpoints.md, lessons.md, blocking-issues-resolved.md, decisions-archive.md, drift-items-closed.md, drift-items-open-detail.md.
