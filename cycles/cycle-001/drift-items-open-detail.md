---
document_type: drift-items-open-detail
level: ops
version: "1.0"
status: active
producer: state-manager
timestamp: 2026-08-09T00:00:00Z
cycle: "cycle-001"
inputs: [STATE.md]
input-hash: "[compaction-2026-08-09]"
traces_to: STATE.md
---

# Open Drift Items — Full Detail — cycle-001

<!-- Full narrative bodies of all 168 rows with Status = OPEN (or an OPEN-adjacent qualifier such
     as MITIGATED/TRACKED DEFERRAL/DEFERRED/ledgered, none of which are CLOSED/SUPERSEDED/RESOLVED)
     from STATE.md v2.28's Drift Items table, extracted verbatim during the 2026-08-09 COMPACTION
     burst. Original row order preserved. STATE.md itself now carries only a compact one-line-per-
     item index (id + severity + one-line summary + pointer to this file); this file is the
     canonical source of full text for every open item. Do not drop any item on future edits —
     update the row here, and correspondingly the one-line index in STATE.md, together. -->

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
| FACTORY-DISPATCHER-HOOK-TIMEOUT | factory-dispatcher PostToolUse hook fired fail-closed on spec edits. RECURRENCE COUNT: 22+ (DEC-204-ADJUDICATED 2026-08-08 hit it on this burst's own STATE.md write — Phase Progress section false-flagged as missing a `pass-N` row despite this being a decision-ruling burst with no new adversary pass, the same HOOK-REGEX-FALSE-POSITIVE-CLASS shape logged repeatedly this session; content verified via independent read to have applied correctly despite the block. A follow-up correction attempted via Edit was correctly BLOCKED by verify-state-timestamp-refresh, confirming the WRITE DISCIPLINE full-Write-only convention is load-bearing. PILE-1-GUARD-STRENGTH 2026-08-07 hit it three more times on burst-log.md/session-checkpoints.md/lessons.md edits — one a fail-closed plugin timeout, one an input-hash-drift false positive on a cycle file with no tracked input-hash; all content verified via independent read to have applied correctly despite the blocks. REGRESSION-PIN+EC+GUARD-STORY 2026-08-07 hit it repeatedly on STORY-INDEX.md/burst-log.md/lessons.md/session-checkpoints.md edits — count-propagation advisories expected mid-burst before STATE.md's own count catches up, plus several fail-closed plugin timeouts; all content verified via independent read to have applied correctly despite the blocks. SESSION-WRAP 2026-08-07 confirmed twice more on burst-log.md/session-checkpoints.md edits; RESUME+RECONCILE-667 2026-08-07 hit both validate-state-structure and verify-state-timestamp-refresh once each, both resolved by re-issuing a corrected full-content Write). | MEDIUM | OPEN — engine-side fix increasingly urgent |
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
| SOH-DX-1-PG-001 | No STATE-claims-vs-artifacts cross-check guard. THIRD DATAPOINT — RESUME+RECONCILE-667 2026-08-07 found STATE.md v2.20's own mergeStateStatus CLEAN claim had drifted from live GitHub state. | MEDIUM | OPEN — cycle-close candidate |
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
| INPUT-HASH-DRIFT-BACKLOG-56 | 56+ artifacts stale on input-hash across closed cycles. | MEDIUM | OPEN — maintenance-sweep candidate. |
| INPUT-HASH-MALFORMED-INPUTS-3 | Three artifacts declare unresolvable inputs. | LOW | OPEN — frontmatter fix candidate |
| APERTURE-CLASS-LESSON | Internal-consistency review cannot detect false factual claims. Two-dimension falsification prescription codified. | MEDIUM | OPEN — engine/skill-template candidate |
| RANGE-TERMINUS-INFERENCE | Any range-notation claim must have its maximum verified by enumeration. | MEDIUM | OPEN — engine/checklist candidate |
| UPSTREAM-COMPLETENESS-APERTURE | Internal-consistency review cannot detect upstream-phase obligation gaps. | MEDIUM | OPEN — route upstream to drbothen/vsdd-factory |
| ORCHESTRATOR-ERROR-INJECTION-RATE | Fix instructions must enumerate expected post-state counts. Multiple datapoints. | MEDIUM | OPEN — orchestrator discipline |
| VSDD-CONFORMANCE-GAP-4-ARTIFACTS | jira-cli lacks four canonical VSDD artifacts: VP-INDEX.md, invariants.md, verification-architecture.md, verification-coverage-matrix.md. | MEDIUM | OPEN — DEC-195 scheduled as own bundle |
| PLUGIN-ACTIVATION-VERSION-DRIFT | .claude/settings.local.json vsdd-factory.activated_plugin_version = 1.0.0-rc.20 vs installed 1.0.0-rc.23. | LOW | OPEN — verify on next session resume |
| NUDGE-TWICE-BEFORE-VOID | Standing rule: never record VOID until nudged twice. | LOW | OPEN — update dispatch procedures |
| STATE-WRITE-TIMESTAMP-COMPLIANCE | verify-state-timestamp-refresh blocks STATE.md writes that don't advance timestamp:. | LOW | OPEN — agent-discipline. **RE-CONFIRMED (2026-08-08, DEC-204-ADJUDICATED): an Edit-only correction to STATE.md's size-budget banner was correctly BLOCKED by this guard because Edit does not advance `timestamp:`; resolved by re-issuing a full Write with both the fix and an advanced timestamp. Confirms the WRITE DISCIPLINE convention (full Write only, never Edit, for STATE.md) is load-bearing, not merely stylistic.** |
| LOCAL-BASH-WRITE-GUARD-INSTALLED | .claude/hooks/guard-state-bash-write.sh blocks Bash-based writes to STATE.md. | LOW | OPEN — route upstream |
| ADVERSARY-ARTIFACT-WRITE-MITIGATION | adversary agents have no Write tool by design. Mitigation: orchestrator manually routes artifact writes. 5 datapoints. | LOW | OPEN — route upstream |
| REVIEW-ISOLATION-NOT-MECHANICALLY-ENFORCED | adversary process | MEDIUM | OPEN — PRE-FLIGHT CHECK corrective VERIFIED EFFECTIVE across all passes through 51/52/53 (minus VOID). Mechanical guard still needed. ROUTE upstream. |
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
| ORCHESTRATOR-SKIPPED-POST-ADVERSARY-PERSISTENCE | adversary process | MEDIUM | OPEN (all passes captured through this burst; pass-20 SUPERSEDED noted). |
| ANCHOR-RESOLUTION-AXIS-NOT-APPLIED | spec integrity | MEDIUM | OPEN — FIXED in ADV-6-7-8-FIX-BURST (S-626-1 v1.8 added bcs:["BC-5.3.001","BC-5.3.002"]). Root cause: no CI guard checks story frontmatter anchor completeness. Recurrence risk HIGH. |
| NAMED-BACKGROUND-SUBAGENT-REPORT-LOSS | platform/tooling | MEDIUM | OPEN — passes 6/7/8 first dispatches were named background subagents; all spawned but never delivered final reports. |
| ORCHESTRATOR-PREMATURE-DEAD-AGENT-CONCLUSION | orchestrator process | MEDIUM | OPEN — orchestrator twice declared a background subagent "dead" before sufficient quiet time. |
| MSRV-JOB-NO-POSITIVE-COVERAGE | CI/F4 | MEDIUM | OPEN — three independent confirmations (passes 6/7/8). Routed to S-641-1 AC-1/AC-2/AC-3. |
| GITLEAKS-NOT-IN-CI-GATE-NEEDS | CI governance | MEDIUM | OPEN — intentional asymmetry (licensing complexity for forks). Tracked as acknowledged governance gap. |
| ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT | adversary process | MEDIUM | OPEN — PRE-FLIGHT CHECK + explicit search-root whitelist corrective VERIFIED EFFECTIVE across all passes through 51/52/53 (minus VOID). Durable fix is in corrective text; mechanical isolation guard still needed. ROUTE upstream. |
| FIX-ROUND-PARTIAL-PROPAGATION | spec process | HIGH | OPEN — held; see TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE for the current governing record of this class. |
| CITATION-GUARD-SRC-ONLY | spec integrity | MEDIUM | OPEN — UPDATED (round 8): pass-21 LOW-003 shows S-BC-CITATION-GUARD-1.md itself carries raw citations; template drift blocks the fix (DEC-217 DEFERRED). |
| ARCH-INDEX-REGISTRY-COVERAGE-GAP | spec integrity | MEDIUM | OPEN — ARCH-INDEX.md SS-01..SS-09 registry does not cover `scripts/`, `tests/`, or `.github/dependabot.yml`. Three independent adversary passes identified the gap. Registry extension story needed. |
| S-576-FAMILY-SUBSYSTEM-PATTERN | spec integrity | MEDIUM | OPEN — ROUTED to S-MAINT-576-HYG-1 (DEC-208, 2026-08-03). |
| KEYCHAIN-CREDENTIAL-PATH-UNCOVERED | test coverage | MEDIUM | OPEN — ADV-P9-MED-005 unique finding. Coverage story needed before S-640-1 ships. |
| FIX-ROUND-INTRODUCES-DEFECTS-IN-NEW-PROSE | spec process | MEDIUM | OPEN — Ten consecutive zero-injection rounds (10-19) ended: round 19's own code fix introduced ADV-P48-MED-001. Directly corroborates TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE. |
| DEMO-TRANSCRIPT-FIDELITY-NO-MECHANICAL-GUARD | spec process | MEDIUM | OPEN — pack records BOTH guard paths; still no automated guard. |
| STATE-VERDICT-LABEL-AMBIGUITY | state integrity | MEDIUM | OPEN — corrected in CORRECTIVE-VERDICT-LABEL-AMBIGUITY burst 2026-08-03. No mechanical guard exists. ROUTE upstream. |
| PASS-NUMBERING-COLLIDES-ACROSS-CYCLES | state integrity | LOW | OPEN — corrective applied: qualify pass references with cycle/story going forward. |
| BC-BEHAVIOR-FIELD-SYSTEMIC-ABSENCE | spec completeness | MEDIUM | OPEN — ~60 of 111 BCs in bc-3-issue-write.md, 5 of 33 in bc-6-config-cache.md, and 6 in bc-5-boards-sprints.md lack `Behavior` fields. ROUTE as own story. |
| ORCHESTRATOR-PROPAGATED-FALSE-JUSTIFICATION | spec process | HIGH | OPEN — F-05 FIXED in round 6. Route: PROCESS — dispatch MUST NOT include non-verified justifications. |
| ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD | orchestrator discipline | HIGH | OPEN — UPDATED (2026-08-05, passes 45/46/47; not re-probed by window 48/49/50 or 51/52/53, which targeted different questions). The guard is materially stronger still: 15 assertions on the zero-test-floor path plus 8 and 4 on the two sibling structural guards, with the `ci-gate` body-content hole closed and independently re-proved RED — pass 51's `ANTI-NEUTERING-CONTROLS-STOP-AT-CI-GATE` finding (guard family coverage stopping at `ci-gate`) is now CLOSED via `3ad496eb`'s class sweep to `test`'s always-run peers. Re-assess for downgrade only after a window that specifically probes for absence, not just presence, returns fully clean. |
| ORCHESTRATOR-UNVERIFIED-BREAK-SPECULATION | orchestrator discipline | LOW | OPEN — Orchestrator asserted F-03 "would have matched zero lines in CI." CI ran SUCCESS for 9312f11f, refuting the speculation. |
| FMT-CLIPPY-NO-POSITIVE-COVERAGE | CI integrity | MEDIUM | OPEN — ROUTED per DEC-215. Follow-up story candidate. |
| INPUT-HASH-BYPASS-MARKERS-SILENTLY-SKIP-VALIDATION | guard hygiene | MEDIUM | OPEN — ROUTE upstream to drbothen/vsdd-factory. |
| BC-02-INPUT-LINEAGE-IMPRECISE | spec provenance | LOW | OPEN — bc-02-issue-read.md semantic lineage remains approximate. |
| GUARD-BYPASSED-BY-TOOL-SUBSTITUTION | guard hygiene | MEDIUM | OPEN — validate-input-hash PostToolUse hook fires on Write but NOT reliably on Edit. ROUTE upstream. |
| PRE-EXISTING-DRIFT-BLOCKS-CORRECTNESS-FIXES | spec process | MEDIUM | OPEN — SUPERSEDES STORY-TEMPLATE-DRIFT-BLOCKS-EDITS. Second instance (S-BC-CITATION-GUARD-1.md) DEFERRED per DEC-217. |
| CHECK-SPEC-COUNTS-COVERAGE-SCOPE | guard coverage | INFO | OPEN — check-spec-counts.sh catches frontmatter-vs-body mismatch but NOT body-count-vs-actual. |
| MIXED-SET-DASH-ARM-UNPINNED | test coverage | MEDIUM | OPEN — UNCHANGED (still OPEN per DEC-226). Test coverage deferred. Draft test story candidate. |
| WRONG-FILE-MIS-ANCHORS-IN-TESTS | citation hygiene | LOW | OPEN — Pre-existing outside S-626-1 diff; spec layer correct; test comment docstrings are unswept siblings. Sweep needed. |
| ISOLATION-WHITELIST-LEAKS-FINDING-IDS | adversary process | MEDIUM | OPEN — MITIGATED across every window through 51/52/53 via up-front disclosure. Structural fix (stripped story view for reviewers, or an explicit carve-out) still needed. ROUTE upstream. |
| HOOK-REGEX-FALSE-POSITIVE-CLASS | factory tooling | MEDIUM | OPEN — TWELFTH+ recurrence, DEC-204-ADJUDICATED 2026-08-08: `validate-state-structure` false-flagged this decision-ruling burst's Phase Progress row as "missing an adversary-pass row (no row containing 'pass-N')" -- the row legitimately has no reason to cite an individual pass number (no new adversary pass ran; this is a decision-ruling burst), the same class as every prior non-adversary-burst false positive. Not blocking on the write path (the first Write landed despite block_intent=true). PILE-1-GUARD-STRENGTH 2026-08-07 (three firings: two fail-closed plugin timeouts, one input-hash-drift false positive on a cycle file with no tracked hash — none blocked the underlying write). |
| AGENT-BACKGROUND-RUN-DEADLOCK | factory tooling | LOW → recommend MEDIUM | OPEN — no occurrence across passes 39-53. Corrective (read the output file directly, or run in foreground) remains effective. |
| TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE | convergence process | HIGH | OPEN — TWENTY-ONE fix rounds total (PILE-1-GUARD-STRENGTH is the twenty-first, targeted at pile 1 only); pile 2 (passes 52/53's 24 findings) remains untouched pending the pile-2/DEC-204 ruling — still no window has yet closed 3/3. **UPDATED (2026-08-07, PILE-1-GUARD-STRENGTH): this round's own scope — fixing pile 1 while explicitly declining to fix pile 2 point-by-point — is itself a live instance of the class this drift item names; the round's DEC-243 rationale (class-sweep, not point fixes) is the corrective applied at the individual-finding level, but the pile-1/pile-2 split is a targeted-round boundary at the burst level.** Pass 53's verbatim root-cause finding ("selective correction... is itself the defect") remains the governing record. **UPDATED (2026-08-07, CLASS-LEVEL-STALE-CLAIM-SWEEP): the 101-vs-18 ratio is the strongest evidence yet -- a discovery-first enumeration found 101 stale occurrences against 18 previously reported by review, meaning targeted fix rounds working strictly off reported findings correct roughly 18% of the real surface. Pile 1 and pile 2 are both now CLOSED via class sweeps, not point fixes -- this is the first burst to demonstrate a full exhaustive-sweep resolution rather than another targeted round.** **UPDATED (2026-08-08, DEC-204-ADJUDICATED): the ruling does not resolve this item. Twenty-one fix rounds, 50 passes, eight consecutive windows without 3/3 under the now-ruled criterion. Standing structural observation: `src/` has been 0-defect for 32 consecutive passes while essentially all findings live in the spec/narrative layer, and each fix round changes code which staleness-es the specs describing it -- a loop this session demonstrated three separate times. Whether the criterion terminates for a story of this scope is now an empirical question rather than an interpretive one.** |
| SHARED-WORKTREE-REVIEWER-CONTAMINATION | review methodology | HIGH → recommend MEDIUM | OPEN — Corrective held for a fifth consecutive window: passes 51/52/53 reported zero contamination-derived findings. Recommend downgrade to MEDIUM with the corrective recorded as standing practice — human ruling required. |
| STORY-FROZEN-HEAD-LAGS-LIVE-HEAD | spec process | MEDIUM | OPEN — Eighth recurrence remains the latest (round 18, in a decision record). No ninth recurrence this burst. |
| FRONTMATTER-YAML-PARSEABILITY-UNGUARDED | factory tooling | LOW | OPEN — Root cause confirmed structural (STORY-INDEX.md's `last_updated` field accumulates unbounded prose). Candidate follow-up story: CI guard plus a schema constraint. |
| LINE-RANGE-CITATIONS-DRIFT-SILENTLY | spec citation hygiene | MEDIUM | OPEN — Not fully closable by inspection alone. Symbol renames drift citations the same way line-number citations do, and nothing guards either class. See SPEC-CITATIONS-UNGUARDED-FOR-TEST-SYMBOLS. |
| FIX-PASS-CATCHES-MORE-THAN-REVIEW-PASS | process observation | INFO | OPEN — REINFORCED AGAIN (2026-08-07, PILE-1-GUARD-STRENGTH): implementing the pipefail-ordering RED proof surfaced the diagnostic value of showing what the OLD guard missed, a refinement not named by the original ADV-P51-HIGH-003 finding. See lessons.md RED-PROOF-SHOULD-EXPOSE-THE-OLD-GUARDS-BLIND-SPOT. |
| DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE | convergence methodology | HIGH | OPEN — **REINFORCED A FIFTH TIME (2026-08-07, window 51/52/53), this time by construction: three deliberately-varied frontiers, human-approved in advance, each found material no prior frontier had — 30 findings surfaced on a head three prior windows had already worked over, on a tree passing 15/15 CI.** No new instance this burst (a fix round, not an adversary pass). Corrective (unchanged): before treating any decay or CLEAN pass as convergence, confirm the frontier was genuinely novel relative to every prior pass — and before dispatching a window at all, confirm no known-open gap in the just-changed surface would trivially reproduce as a "new" finding. **UPDATED (2026-08-08, DEC-204-ADJUDICATED): under the ruled criterion, frontier variety is what determines whether a CLEAN verdict is meaningful. Any future window must use deliberately varied, previously-unused inspection frontiers, approved before dispatch.** |
| SUBSTRING-GUARD-CANNOT-VERIFY-COMPUTED-VALUES | verification design | MEDIUM | OPEN — Unchanged this round. Still a candidate follow-up story. |
| SPEC-CLAIMS-LACK-VERIFICATION-DISCLOSURE | spec design | MEDIUM | OPEN — No new instance this burst; MED-001's disclosed partial-RED-proof (PER-BRANCH-PINS-PARTIALLY-RED-PROVEN) is a direct application of the same discipline. |
| HONESTY-FIXES-CAN-BE-INCOMPLETE | remediation process | MEDIUM | OPEN — No new instance this round; the lesson continues to hold — this burst's explicit disclosure of MED-001's 2-of-4 RED-proof gap is a direct application. |
| ORCHESTRATOR-FALSE-FABRICATION-ACCUSATION | orchestrator process | MEDIUM | OPEN — Two datapoints stand from round 18; no third instance this round. |
| BC-COVERAGE-GAP-FOR-CI-GATE-GUARDS | spec integrity | HIGH | OPEN — UPDATED (2026-08-08, DEC-246-U1-CLOSED): the new needs-set partition guard (`PINNED_GATE_EXCLUDED_JOBS` + its two tests, +284/-33 in `tests/ci_gate_completeness.rs`) shipped with no BC or VP minted either -- the coverage gap grows with every guard-strengthening round. Recommend a follow-up story to mint BC(s) and a VP for this whole guard family, mirroring BC-X.13.007's treatment of the zero-test-floor guard. |
| AGENT-IDLE-WITHOUT-DELIVERY | process quality | MEDIUM | OPEN — **MITIGATION CONFIRMED EFFECTIVE (2026-08-06, window 48/49/50).** Held again this burst — the pile-1 fix implementer delivered unprompted. |
| SCOPED-GREP-CLAIM-EXCEEDS-EVIDENCE | process observation | LOW | OPEN — NEW (2026-08-05, round 19). No new instance this burst. |
| SPEC-CITATIONS-UNGUARDED-FOR-TEST-SYMBOLS | guard coverage | MEDIUM | OPEN — Third instance stands (2026-08-07, pass 53). No new instance this burst; the underlying guard-coverage gap remains open, tracked as a scope extension of `S-TRAIL-DERIVATION-GUARD-1`. |
| S-CIGATE-1-TABLE-CELL-DEFECT | spec quality | LOW | OPEN — NEW (2026-08-05, round 19, found not fixed). Unchanged this burst. Flagged for a separate table-hygiene sweep. |
| PR-518-ANNOTATION-DEFERRED | process quality | INFO | OPEN — NEW (2026-08-05, round 19). Deferred, not rejected. |
| CLOSED-STORY-CONTRADICTS-SHIPPED-BEHAVIOR | spec integrity | HIGH | OPEN — **REOPENED (2026-08-07, FIX-ROUND-20). UPDATED (2026-08-07, window 51/52/53, pass 53): six further instances found — S-CIGATE-1 AC-004 item 6 asserts the shipped test pins a step-level `contains(...)` condition where the shipped assertion is the exact inverse; the six-job `ci-gate.needs` list appears as current fact at four unlabeled sites where shipped is eight; two of the six assert the logical inverse of shipped behavior. No fix round authorized this burst for these narrative-drift instances — still pending the "pile 2" methodology ruling; unchanged by PILE-1-GUARD-STRENGTH, which fixed pass 51's guard-strength gaps only.** See lessons.md PREMATURE-DRIFT-CLOSURE for the generalized prescription: reserve full CLOSED status for drift items where the fix was structural or a systematic sweep confirmed the whole class clean, not just the triggering instance. **UPDATED (2026-08-07, CLASS-LEVEL-STALE-CLAIM-SWEEP, commit `7f8723a5`): the two HIGH instances from pass 53 (S-CIGATE-1 AC-004 item 6 asserting the inverse of shipped behavior, and the six-job needs list at four unlabeled sites) are now CLOSED, along with roughly sixteen further siblings the reviews never named -- 30 of S-CIGATE-1's occurrences target this drift item's class. First full class-level closure in this drift item's history; status remains OPEN pending confirmation no further sibling instances exist outside the swept perimeter.** |
| ORCHESTRATOR-CONCURRENT-WRITER-COLLISIONS | orchestrator process | HIGH | OPEN — FOUR distinct collisions in the S-CIGATE-2 delivery session, all orchestrator-caused. Mitigation, now standard: isolated `git worktree` + fresh `CARGO_TARGET_DIR` per agent, `strings <bin> \| grep <path>` binding verification, never dispatch a writer while another holds the same surface. No new collision this burst. |
| RED-PROOF-REQUIRES-FOUR-CONDITIONS | verification methodology | HIGH | OPEN — NEW (2026-08-07, S-CIGATE-2 delivery). A mutation-based RED proof is valid only when all four hold: LEGAL, APPLIED, INTENDED, NARROW. This burst's two RED proofs (default-deny allowlist; pipefail-ordering) both satisfy all four. Candidate follow-up: codify as a standing review checklist item. |
| STALE-ARTIFACT-PRODUCES-FALSE-CLAIM | verification integrity | HIGH | OPEN — SIXTH layer (2026-08-08, DEC-246-U1-CLOSED): research read a working copy 1 commit behind `origin/develop` and reported the S-CIGATE-2 false-green as "still live"; remediated via `git pull --ff-only`, orchestrator declined an earlier resume-health flag of the same staleness. Cure (reinforced): re-derive live-state claims (mergeStateStatus, CI status, branch currency) from source at every session resume, not just at capture time. |
| LOCAL-VERIFICATION-MISSES-PLATFORM-MATRIX | CI/review process | MEDIUM → recommend HIGH | OPEN — SECOND INSTANCE (2026-08-07, FIX-ROUND-20). Unchanged this burst — no new instance; this burst's CI FINAL was verified 15/15 including all three Test matrix legs before recording. Two instances in two days sharing the same root cause — recommend escalating to HIGH; human ruling pending. |
| EXTRACTOR-UNDER-REPORT-FAILS-OPEN | verification design | HIGH | OPEN — NEW (2026-08-07, S-CIGATE-2 delivery). Any check whose extractor can silently under-report its input fails open. Directly informs S-TRAIL-DERIVATION-GUARD-1's AC-005/AC-006. |
| SILENT-MERGE-CONCATENATION-DEFEATS-CONFLICT-DETECTION | merge/reconciliation integrity | HIGH | OPEN — NEW (2026-08-07, RESUME+RECONCILE-667). Cure: conflict markers are a lower bound on reconciliation risk, not a complete inventory — run the full test suite after every merge and audit function-by-function any file both branches touched. Resolved in `7f702bf6`; tracked deferral per S-7.02. |
| TRAIL-DERIVATION-UNGUARDED | spec process | MEDIUM | OPEN — Follow-up story registered: `S-TRAIL-DERIVATION-GUARD-1` (P2, 8 points, draft, 8 ACs) — satisfies the S-7.02 follow-up-story requirement. Now also carries the `SPEC-CITATIONS-UNGUARDED-FOR-TEST-SYMBOLS` third-instance process-gap and (2026-08-07, PILE-1-GUARD-STRENGTH) the `ASSERTION-COUNT-CITATIONS-LAG-CODE` process-gap as scope extensions — the same mechanically-derivable-count-across-artifacts shape, second occurrence in two bursts. **UPDATED (2026-08-07, CLASS-LEVEL-STALE-CLAIM-SWEEP): eighth instance, this one self-inflicted by the sweep commit itself -- `7f8723a5` touched `docs/specs/cargo-mutants-policy.md`, a file the branch had never modified, instantly staling S-626-1's `files_modified` (18→19) and both commit trails; byte-identical to ADV-P49-MED-001 closed the same day. Third demonstration in this session alone that dispatch ordering cannot close this class -- any commit landing after the story is written reopens the gap. Follow-up story `S-TRAIL-DERIVATION-GUARD-1` remains the durable fix, not yet dispatched.** **UPDATED (2026-08-08, DEC-246-U1-CLOSED): ninth instance -- commit `9d34f354` landed after S-626-1's trail was last derived, reopening the gap again. Follow-up story `S-TRAIL-DERIVATION-GUARD-1` remains the durable fix, still not dispatched.** |
| STORY-ROUND-COUNTER-DIVERGES-FROM-STATE | process/state integrity | LOW | OPEN — S-626-1's internal fix-round counter has diverged from STATE.md's burst numbering. Either reconcile the counters or document the mapping explicitly. |
| PER-BRANCH-PINS-PARTIALLY-RED-PROVEN | guard integrity | LOW | OPEN — NEW (2026-08-07, PILE-1-GUARD-STRENGTH). Two of four per-branch `exit 1` pins added in `3ad496eb` (closing ADV-P51-MED-001's `extract_if_block` helper) were RED-proven (binary-count floor, zero-test floor); the other two (the remaining branches) are asserted but unvalidated — small, cheap to finish, precisely the class this round was closing. |
| PARTIAL-EDIT-LOOKS-COMPLETE | remediation process | MEDIUM | OPEN -- NEW (2026-08-07, CLASS-LEVEL-STALE-CLAIM-SWEEP). An agent died mid-edit during this sweep leaving S-626-1 with its version bumped and a new file (`docs/specs/cargo-mutants-policy.md`) declared, but its commit trails still at pre-sweep numbers -- a state that reads as finished. Same hazard shape as selective correction: partial application that looks complete. Argues any future count/trail guard must verify against the derivation command rather than trust a recorded number, as `S-TRAIL-DERIVATION-GUARD-1`'s AC-002/003 already require. |
| GUARD-APPARATUS-HAS-SINGLE-POINT-OF-FAILURE | CI governance | HIGH | OPEN — NEW (2026-08-08, DEC-246-U1-CLOSED, research). All guard tests run in `test`, which blocks merge only via `ci-gate`; if `ci-gate` itself is skipped, GitHub reports Success and every pin evaporates at once -- circular mitigation. Second independent required check proposed; pending human ruling. |
| ZERO-LEG-MATRIX-RESULT-UNDOCUMENTED | CI governance | MEDIUM | OPEN — NEW (2026-08-08, DEC-246-U1-CLOSED, research). `needs.result` behavior for a zero-leg matrix is undocumented; `clippy`/`test` are matrices. Testable in one throwaway PR; do not resolve by inference. |
| SECRET-SCAN-NOT-A-MERGE-BLOCKER | CI governance | MEDIUM | OPEN — NEW (2026-08-08, DEC-246-U1-CLOSED, research). gitleaks sits outside `needs`; a PR tripping it can still merge. |
| DUPLICATE-CHECK-NAME-BEHAVIOR-UNDOCUMENTED | CI governance | LOW | OPEN — NEW (2026-08-08, DEC-246-U1-CLOSED, research). Required-check matching is by job `name:`, ignoring workflow file; all-vs-any behavior on a name collision is undocumented. |
| ADMIN-BYPASS-POSTURE-UNRECORDED | CI governance | LOW | OPEN — NEW (2026-08-08, DEC-246-U1-CLOSED, research). `enforce_admins` state is recorded nowhere; the sole CODEOWNER is also the sole admin. |
| REQUIRED-CHECK-NAME-UNPINNED | CI governance | LOW | OPEN — NEW (2026-08-08, DEC-246-U1-CLOSED, research). Branch-protection required-check string is the `name:` value, unpinned in any guard; drift is fail-safe but undetectable until a PR wedges. |
