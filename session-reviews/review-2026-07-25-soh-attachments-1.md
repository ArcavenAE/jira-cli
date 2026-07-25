---
document_type: session-review
date: 2026-07-25
run_id: SOH-ATTACHMENTS-1 — develop @ db207b81 — release v0.6.0-dev.11 authorized (DEC-186)
path: 4
path_name: feature
product: jr (jira-cli)
duration: ~3 calendar days (2026-07-23 wave gate → 2026-07-25 F7 approved)
total_cost: unknown (PERF-COST-TRACKING open; estimate ~4–6M subagent tokens for wave-gate → F7 arc; full feature including F2 adversary passes estimated ~18–24M tokens)
stories_delivered: 7
status: complete
proposals_adjudicated: pending (72h window opens 2026-07-25)
proposals_outcome: pending — see improvement-proposals-soh-attachments-1.md
---

# Session Review: jr (jira-cli) — feature — 2026-07-25

**Cycle:** SOH-ATTACHMENTS-1 (issues #576 + #585)
**Mode:** Feature Mode (F1–F7), brownfield, Rust
**Dates:** 2026-07-23 (wave gate) → 2026-07-25 (F7 approved); full feature arc started 2026-07-15 (F1 gate)
**Release:** v0.6.0-dev.11 — AUTHORIZED (DEC-186)
**Reviewer model:** claude-sonnet-4-6 (session-reviewer agent, adversary tier)
**Prior review:** review-2026-07-15-issue-577.md (SOH-COMMENT-CRUD-1)

## Executive Summary

SOH-ATTACHMENTS-1 delivered the attachment CRUD surface (list/download/upload/delete) with JSM visibility two-step and live-Jira E2E coverage — 6 delivery stories plus 1 emergent fix, 33 new BCs, 22 new tests at F6, 5 VPs fully discharged. All F7 convergence dimensions PASS; holdout mean 1.00; mutation 100% fresh confirmation; S-7.02 SATISFIED; issues #576 and #585 CLOSED.

F5 ran 14 rounds under STRICT criterion, producing 8 fix PRs. The dominant quality event was a fix-authored HIGH at r3 — an r1 fix direction that modified a shared function without cross-checking all BC anchors, inadvertently breaking BC-2.7.012. The Step-7 secondary review tier caught a cross-model unique finding (SAFE-NAME-GUARD-EXTRACTION) that zero of 14 primary rounds surfaced, confirming the non-redundant value of secondary review with a different model. Windows CI caught a real P9-001/BC-2.7.012 cross-platform contract collision that no macOS gate had reached. The STATE-MANAGER-MONOLITHIC-WRITE-STALL problem accumulated its 5th data point (across the last two bundles), making it the highest-priority outstanding engine friction item.

## Run Overview

| Metric | Value | Benchmark (SOH-COMMENT-CRUD-1 baseline) | Status |
|--------|-------|----------------------------------------|--------|
| Total cost | unknown (~4–6M tokens wave-gate → F7 arc) | unknown (~8–12M for full F1→F7) | DATA GAP (PERF-COST-TRACKING open) |
| Duration (wave gate → F7) | ~3 calendar days | ~3 calendar days (F5+F6+F7 arc) | ON-PAR |
| Stories delivered | 7 (S-576-1..6 + FIX-576-DL) | 6 (S-577-1..6) | COMPARABLE |
| F5 rounds (STRICT) | **14** | 5 (#577) | **ELEVATED ×2.8** |
| F5 fix PRs | 8 (#644–#652 excl. #645) | 1 (#594 #577) | ELEVATED |
| Fix-authored HIGH findings | 1 (r3: BC-2.7.012 over-reach) | 0 | NEW PATTERN |
| Secondary review tier | PASS (0C/0H/0M; 1 cross-model unique) | not run (#577) | NEW |
| Process-gap Drift Items added | 3 (PG-576-1/2/3) + 2 confirmed (STATE-MANAGER-MONOLITHIC-WRITE-STALL 5th dp; hook-vs-DEC-173 3rd dp) | 13 (PG-F3/F4 family) | LOWER |
| PRs merged (delivery + F5) | 15 | 12 | COMPARABLE |
| Gate failures | 0 | 0 | PASS |
| Human interventions | 3 decisions (DEC-184..186) | 9 decisions (#577) | LOWER |
| Holdout satisfaction | mean 1.00 (12/12 MUST-PASS) | 1.00 (5/5 MUST-PASS) | PASS |
| Mutation kill rate (per-story CI) | 94–100% (all above 90% floor) | 100% adjudicated | PASS |
| F6 fresh mutation confirmation | 27/27 viable (100%) | adjudicated (not fresh run) | PASS |
| F6 fuzz inputs | 49,152; 0 crashes | not run (#577) | NEW |
| Regression at F7 | 2,341 pass / 0 fail | 2,102 / 0 | PASS (+239 baseline delta) |

---

## 1. Cost Analysis

**Status: DATA GAP — `.factory/cost-summary.md` MISSING (PERF-COST-TRACKING open — 4th consecutive cycle with no cost data)**

No per-cycle cost tracking was initialized. Key cost drivers for the wave-gate → F7 arc:

- F5 at 14 rounds (vs. 5 for #577) was the dominant cost driver. Eight fix PRs each required a human review + merge cycle (DEC-173 standing rule). The r3 HIGH caused by r1 over-reach added one full fix PR + one adversary round that would not have been needed with a per-caller BC audit at r1 fix time.
- Rounds 4–9 were predominantly doc-fallout of the loop's own fix commits (spec version range drift, trace inconsistencies). These rounds add cost with diminishing quality return. Early EC-codification of accepted behaviors is the lever that compresses this zone.
- F6 added two environmental load-abort attempts on the mutation confirmation run. The second fresh run on 2026-07-25 completed successfully (27/27 viable). No cost impact, but the environmental caveat adds re-run overhead.
- Step-7 secondary review added one adversary round cost; this was net-positive (cross-model unique HIGH-value finding found).

**Recommendation:** See Proposal 1. Cost tracking initialization is the highest-leverage single change for pipeline visibility. This is the fourth cycle lacking cost data.

---

## 2. Timing Analysis

**Cycle wall clock (wave gate → F7):** Approximately 3 calendar days (2026-07-23 wave gate → 2026-07-25 F7 approved).

| Phase | Duration | Notes |
|-------|----------|-------|
| Wave Gate (G1–G6) | ~4 hours (2026-07-23) | 6 gates; 3 residuals carried; PG-576-3 surfaced |
| F5 Scoped Adversarial | ~1 day (2026-07-24) | 14 rounds; 8 fix PRs; human merge on each (DEC-173) |
| F5 Step-7 Secondary Review | ~2 hours (2026-07-24) | fresh context; 1 cross-model unique finding |
| F6 Targeted Hardening | ~4 hours (2026-07-25 early) | D1–D4; 1 load-abort retry on D3; no source changes |
| F7 Delta Convergence | ~2 hours (2026-07-25) | 5 dims; 2 doc drifts found; 1 backfilled (DEC-186) |

**Bottleneck:** The human-merge-all-PRs standing rule (DEC-173) is the primary wall-clock constraint on F5. Eight PRs × human-review-and-merge latency is the irreducible minimum. For bundles with STRICT F5, the DEC-173 pattern should be expected to span a full calendar day for 6+ fix PRs.

**Positive:** F6 and F7 ran same-day once F5 converged, demonstrating that the verification and convergence phases are well-scoped for their task.

---

## 3. Convergence Analysis

**F5 ran 14 rounds under STRICT criterion (human ruling 2026-07-23); window r12/r13/r14 CLEAN×3.**

Novel-finding trajectory:

| Round | Novel Counts | Dominant Pattern |
|-------|-------------|-----------------|
| r1 | 6L/1C | Multi-finding burst; containment, RFC3339, quote guard, network taxonomy |
| r2 | 2L/1C | Fix-authored (backslash guard asymmetry from r1) + doc sync |
| r3 | **1H**/2L | **HIGH authored by r1 fix-direction over-reach** on shared function |
| r4 | 1L | Docstring accuracy |
| r5 | 1L/1I | Research-driven disk-error taxonomy; Windows P9-001 cross-platform |
| r6 | 1L/1I | Doc-fallout from r5 spec version range |
| r7 | 2L/1I | EC-3.9.006-7 trip-wire codification (spec gap, not code gap) |
| r8 | 1L dup | Dup of ledgered P8-001; no STRICT window reset per ruling |
| r9 | 1L novel + 1I dup | 1 novel; 1 dup of P4-006 excluded |
| r10 | 0 | Enhancement note only |
| r11 | 1L novel | Dead branch removal + SEC-576-001 consolidation guard |
| r12–r14 | 0 each | STRICT window; CONVERGED |

**Loop-exhaust pattern (rounds 4–9):** Doc-fallout of the loop's own fix commits dominated. Each fix round producing a new spec version created a new trace/doc sync target for the next adversary. This cycle was broken at r11–r12 by codifying accepted behavioral edges as spec ECs (EC-3.9.006-7, EC-X.8.010-2). The empirical lesson: codify accepted behaviors into spec ECs in the same burst they are dispositioned, not in a subsequent cleanup sweep.

**Duplicate-of-ledgered no-reset ruling:** Applied four times (r5, r8, r9, r12). Correct behavior — a finding that has been dispositioned and recorded in the ledger is evidence of known-open state, not a novel defect. Resetting STRICT on dups would create an unbounded loop for all accepted residuals.

**Secondary review (Step-7):** PASS — 0C/0H/0M/4L/3I. The L2 cross-model unique finding (SAFE-NAME-GUARD-EXTRACTION — copy-pasted SEC-576-004 guard in two upload functions, never flagged in 14 primary rounds) confirms that secondary review with fresh context and a different model provides non-redundant coverage. Enhancement candidate ledgered; no correctness impact on shipped behavior.

---

## 4. Agent Behavior Analysis

**Orchestrator fix-routing over-reach (r1 → r3 HIGH):** The orchestrator issued an r1 fix direction for F5-R1-004 (404 parity) that modified the shared `get_attachment_metadata` function without cross-checking BC-2.7.012. The fix changed error semantics in a way that broke the canonical-only download-404 requirement. The r3 adversary caught this as a HIGH. Pattern: when a fix direction targets a function with multiple callers, the orchestrator must enumerate ALL BC anchors for ALL callers before issuing the direction. This is Process Observation (a) in the F5 convergence summary.

**Windows CI cross-contract catch (r5 / P9-001):** F5-R5 research pass confirmed that the Windows permission-denied path form (`(os error 5)`) differs from Linux/macOS. The P9-001 interaction with BC-2.7.012 would have caused `classify_write_error` to produce the wrong canonical string on Windows. This was caught because the CI matrix includes a Windows runner. No macOS-local gate would have surfaced it.

**Step-7 cross-model blind spot confirmed:** Safe-name guard duplication (SAFE-NAME-GUARD-EXTRACTION) never appeared in 14 primary rounds. The secondary reviewer identified it as the highest-value refactor candidate on first read. This is a confirmed cross-model blind spot: the primary adversary's model consistently overlooked the copy-paste pattern across two sibling files. The guard was extended twice in lockstep during F5 (r1 added `"`, r2 added `\`), demonstrating the maintenance risk empirically.

**STATE-MANAGER-MONOLITHIC-WRITE-STALL (5th occurrence):** The timestamp-advancement hook forces monolithic STATE.md writes, causing repeated API stalls. The Bash-python workaround is now a de facto standard in this project. A 5th data point across two consecutive bundles (4–5 in SOH-COMMENT-CRUD-1, 1 additional here) escalates this to the highest-priority engine friction item.

**Hook vs. DEC-173 conflict (3rd occurrence):** `validate-pr-review-posted` hook demanded AUTHORIZE\_MERGE on PRs #648 and #651, while DEC-173 specifies human-merges-all. The hook cannot distinguish DEC-173 self-authored-PRs from a review bypass. Third occurrence; still unresolved engine-side.

**F6 verifier (environmental load):** F6 ran under heavy concurrent load (avg ~5, 14+ active agents). Two wiremock/subprocess tests exceeded subprocess timeouts. Verifier correctly identified this as environmental (not code faults) and re-ran successfully on the second attempt. Clean STOP-and-report behavior; no forced conclusions.

---

## 5. Gate Outcome Analysis

All 6 wave gates PASSED; no gate failures.

| Gate | Status | Unique contribution |
|------|--------|---------------------|
| G1 Test suite | PASS | Surfaced PG-576-3 (wave-gate skill prescribes `--release`, repo forbids it) |
| G2 DTU validation | SKIP | dtu\_required: false; correct skip |
| G3 Adversarial review | PASS | 3 new wave-scope originations (WAVE-576-01/02/05) not caught in any per-story pass |
| G4 Demo evidence | PASS | 7/7 deliverables with AC evidence |
| G5 Holdout evaluation | PASS | 12/12 MUST-PASS scored 1.00; offline vs mock |
| G6 State update | PASS | Sprint-state + STATE.md committed |

G3 wave adversary uniquely caught the integration-level issues (dry-run channel divergence across upload vs. delete, blanket-401 bypass in JSM step-2, per-file stale-heal taxonomy). These required the whole-wave view to become visible.

**F7 fresh-context audit (2 drifts):**
- DRIFT-1 (LOW): `spec-changelog.md` missing v1.3.104/105/106 entries. Backfilled same burst (non-blocking).
- DRIFT-2 (INFO): `prd-delta-576.md` frontmatter `spec_version_after: 1.3.98` stale vs. F5-final v1.3.106. Accepted-historical, phase-scoped artifact.

---

## 6. Wall Integrity Analysis

**DEC-128 (CRITICAL) — Sub-agents must not self-authorize merges.** All 8 F5 fix PRs merged by human (DEC-173 standing rule). No sub-agent attempted self-merge. DEC-128 wall intact.

**DEC-173 (standing) — Human merges all PRs.** Enforced throughout F5 and delivery phases. 15 PRs total, all human-merged. The human-merge gate is the primary wall preventing a sub-agent fix-PR loop from running uncontrolled.

**No permission-laundering attempts observed.** Consistent with the positive control pattern from SOH-COMMENT-CRUD-1.

**Worktree boundary respected.** No stray commits in the main repo from sub-agents operating in worktrees. PG-F4-8 (resume-prompt worktree identity guard from prior cycle) appears to have held.

---

## 7. Quality Signal Analysis

**Mutation kill rates (per-story CI):** S-576-1: 95%, S-576-2: 94%, S-576-3: 97%, S-576-4: 97%, S-576-5: 94%, FIX-576-DL: 100%. All above the 90% floor. The F6 fresh bounded confirmation run (2026-07-25) confirmed 27/27 viable mutants caught (100%).

**Fuzz (F6 D2):** 49,152 inputs across three security-sensitive functions (`sanitize_attachment_filename`, `display_sanitize_filename`, `safe_name`). Zero panics, zero crashes, zero timeouts. All three CWE invariants (CWE-22 disk path, CWE-116 display, CWE-93 Content-Disposition) held.

**VP discharge:** 5/5 VPs green at F6. VP-576-001 (proptest, 4,096 cases) confirmed path-traversal resistance. VP-576-003 (DELETE-before-POST ordering) requires wiremock subprocess interaction — this is the most environment-sensitive VP, confirmed green in CI even when local load caused intermittent timeouts.

**Test growth:** 2319 → 2341 (+22 tests, wave gate → F6). Five new test suites added (attachment\_list, attachment\_download, attachment\_upload, attachment\_delete, attachment\_jsm). The emergent FIX-576-DL (integer vs. string serde drift) was caught by live-Jira run 30031724733 and pinned by two named regression tests.

**Holdout coherence:** Group 19 (H-NEW-ATTACHMENT-001..012) fully satisfiable against shipped behavior. v1.3.102/103 disk-error string changes did not invalidate any Group 19 assertion (no holdout asserts specific error wording).

**Security coverage:** All six SEC claims (SEC-576-001..004, SEC-576-006, GHSA-9857-6MW7-FQ2M) have corresponding named tests. No orphan security claim.

---

## 8. Pattern Detection

**Cross-run: Fix-authored HIGH is a new pattern.** The r3 HIGH (BC-2.7.012 restoration) was authored by the r1 fix direction — not by the original implementation. This pattern did not appear in any prior cycle in this project. Root cause is orchestrator fix-routing over-reach on a shared function. If it recurs in a next bundle, it should trigger a mandatory per-caller BC audit checklist step in the F5 orchestrator prompt.

**Cross-run: Doc-fallout loop (rounds 4–9) mirrors prior cycles.** The pattern of spec-version-range drift and trace inconsistency propagating across fix rounds has appeared in every feature-mode bundle. The mechanism that breaks it is always the same: codify the accepted edge as a spec EC. The lesson has been stated; the question is whether it is applied earlier in future F5 cycles.

**Cross-run: STATE-MANAGER-MONOLITHIC-WRITE-STALL persistent.** This is the third consecutive bundle where the stall has occurred (SOH-BUGS-1, SOH-COMMENT-CRUD-1, SOH-ATTACHMENTS-1). Five data points total. The Bash-python workaround is now load-bearing in every orchestrator burst that touches STATE.md. Engine-side fix is overdue.

**Cross-run: Secondary review tier is net-positive.** SOH-ATTACHMENTS-1 is the first cycle to include a formal Step-7 secondary review. It found the highest-value refactor candidate in the bundle on first read. Recommend making the secondary review tier a standing step in all future feature-mode bundles.

**Cross-run: RELEASING.md still absent.** RELEASING-MD-MISSING has been an open Drift Item since SOH-BUGS-1 (2026-07-09). Three release cycles have run without it. The burden is low; the gap is persistent.

**Positive: Windows CI value confirmed.** P9-001 in this bundle + the STACK-WIN defect in SOH-COMMENT-CRUD-1 both produced genuine cross-platform contract collisions. Windows CI runners are providing real incremental value beyond redundancy.

---

## 9. Governance Policy Audit

**`append_only_numbering`:** No BC renumbering, no ID reuse, no filename slug changes. BC count 657 unchanged throughout F5. PASS.

**`lift_invariants_to_bcs`:** SEC-576-001..004, SEC-576-006 all have corresponding named BCs or EC clauses. CROSS-SHARD-INVARIANT-WIRING (codified in lessons.md from F2) was applied: BC-3.9.003 step-1 carries an inline cross-reference to SEC-576-006 self-heal. PASS.

**`state_manager_runs_last`:** State-manager committed factory-artifacts after each phase burst. PASS.

**`semantic_anchoring_integrity`:** FIX-576-DL (`deserialize_string_or_int_as_string`) is correctly scoped to `AttachmentMetadata.id` only; `AttachmentObject.id` (list path, string-only) unchanged. No anchor misapplication. PASS.

**`creators_justify_anchors`:** VP-576-001..005 each traced to named test function → src symbol → review evidence in F7 report D3. PASS.

**`bc_array_changes_propagate_to_body_and_acs`:** BC-INDEX v6.38 → v6.44 (8 versions across F5); all spec body changes propagated to BC-INDEX rows and allocation columns per twin-artifact sweep. PASS.

**New policy candidates:**

1. **SHARED-FN-CALLER-AUDIT-ON-FIX:** When an F5 fix direction targets a function that has multiple callers, the orchestrator must enumerate all BC anchors for all callers before issuing the direction. Triggered by the r3 HIGH (BC-2.7.012 restoration, fix-authored). This should become a mandatory per-fix-direction checklist step when the target function name appears in more than one BC's `**Trace**:` or `**Source**:` field. Proposed addition to orchestrator F5 prompt (engine-side).

2. **EC-CODIFICATION-EARLY:** Accepted behavioral asymmetries (deliberate 429 no-retry, per-command stale-heal scope, etc.) should be codified as spec ECs in the burst where they are first accepted, not deferred to a cleanup sweep. Each undocumented accepted behavior is a rediscovery target for every subsequent adversary pass. Triggered by r7/r11 closing the loop after rounds 4–9 of doc-fallout. Proposed addition to orchestrator F5 disposition prompt (engine-side).

---

## Improvement Proposals

See `improvement-proposals-soh-attachments-1.md` for full proposals with evidence and affected files.

Summary:

### Proposal 1: Cost Tracking Initialization
- **Category:** cost
- **Priority:** HIGH
- **Evidence:** 4th consecutive cycle with no cost data. Cannot benchmark F5 round efficiency, compare feature vs. bug-fix arc costs, or detect runaway loops by cost signal.
- **Recommendation:** State-manager initializes `cost-summary.md` at F1 gate with token-budget estimates by phase. Orchestrator appends actuals at each phase close.
- **Affected files:** STATE.md, cost-summary.md (new), orchestrator F1/F7 prompts
- **Risk:** Token counting is approximate; estimates may be misleading if model pricing changes.

### Proposal 2: Secondary Review Tier as Standing Step
- **Category:** quality
- **Priority:** HIGH
- **Evidence:** Step-7 caught SAFE-NAME-GUARD-EXTRACTION (cross-model unique, highest-value refactor candidate) in one pass after 14 primary rounds missed it.
- **Recommendation:** Add Step-7 secondary review as a mandatory step in all feature-mode bundles with >5 F5 rounds, using a different model than the primary adversary.
- **Affected files:** orchestrator feature-sequence prompt; F5 convergence template
- **Risk:** Adds one adversary-round cost per bundle. Secondary findings may duplicate primaries; the dissent-recording pattern (as done here for STEP2-429-RETRY) handles this correctly.

### Proposal 3: SHARED-FN-CALLER-AUDIT-ON-FIX Checklist Step
- **Category:** convergence
- **Priority:** HIGH
- **Evidence:** r1 fix-direction over-reach caused a fix-authored HIGH at r3 (BC-2.7.012 restoration), adding one full PR + one adversary round.
- **Recommendation:** Add a mandatory per-fix-direction check: if target function name appears in multiple BCs' Trace/Source, enumerate all caller BCs before issuing the fix direction.
- **Affected files:** orchestrator F5 prompt; fix-direction template
- **Risk:** Adds overhead to every fix round. Should only fire when the function is referenced in more than one BC (grep-checkable).

### Proposal 4: STATE-MANAGER-MONOLITHIC-WRITE-STALL (Engine Fix)
- **Category:** workflow
- **Priority:** HIGH
- **Evidence:** 5 data points across 3 bundles. Bash-python workaround is load-bearing. Blocks state-manager from completing bursts without human intervention or workaround.
- **Recommendation:** Engine-side: increase PostToolUse hook timeout for Write tool on STATE.md, or restructure the timestamp-advancement hook to fail-open (warn rather than block) when count propagation cannot be verified in time.
- **Affected files:** vsdd-factory hook configuration (engine-side, not product repo)
- **Risk:** Fail-open on count validation could allow count drift through undetected. Mitigation: keep the validation as a warning + subsequent CV round catches it.

### Proposal 5: EC-CODIFICATION-EARLY Discipline
- **Category:** convergence
- **Priority:** MEDIUM
- **Evidence:** Rounds 4–9 (6 rounds) were predominantly doc-fallout of fix commits. EC-codification at r11/r12 closed the loop. Early codification at r5/r7 would have collapsed this to ~4 rounds.
- **Recommendation:** When an adversary finding is dispositioned as "accepted/by-design" in an F5 fix round, the orchestrator must add an EC clause to the spec in the same burst. Do not defer EC-codification to a subsequent pass.
- **Affected files:** orchestrator F5 disposition prompt
- **Risk:** EC clauses written mid-loop may be imprecisely scoped; but imprecision can be corrected, while omission regenerates the finding.

### Proposal 6: RELEASING.md (Repo Doc Backlog)
- **Category:** workflow
- **Priority:** LOW
- **Evidence:** RELEASING-MD-MISSING has been open for 3 release cycles (since dev.8). Release skill prompts every time.
- **Recommendation:** Draft `RELEASING.md` from the dev.8/dev.9/dev.10/dev.11 precedent flows. Can be done as a docs-only story in the next maintenance sweep.
- **Affected files:** `RELEASING.md` (new, repo root)
- **Risk:** Low; documentation only.

---

## Metrics for Next Run

To validate improvements from this session:

1. **F5 round count:** If EC-CODIFICATION-EARLY is applied, doc-fallout rounds should decrease below 6. Target: rounds 4–9 zone collapses to ≤3 rounds.
2. **Fix-authored HIGH count:** With SHARED-FN-CALLER-AUDIT-ON-FIX applied, fix-authored HIGHs should be 0. Any occurrence is a checklist failure.
3. **Step-7 secondary review uniqueness rate:** Track findings unique to secondary review vs. duplicated from primary. If uniqueness rate exceeds 1 HIGH-equivalent per bundle, the tier is contributing. If all findings are duplicates, reconsider making it mandatory vs. optional.
4. **STATE-MANAGER-MONOLITHIC-WRITE-STALL occurrences:** If engine fix is applied, should be 0. Any occurrence means the fix was incomplete.
5. **Cost data availability:** If cost-summary.md initialization is implemented, report actual token cost for next bundle vs. estimate.
