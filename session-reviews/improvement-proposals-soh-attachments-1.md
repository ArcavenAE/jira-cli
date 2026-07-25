---
document_type: improvement-proposals
producer: session-reviewer
timestamp: 2026-07-25
cycle: SOH-ATTACHMENTS-1
issues: "#576 + #585"
review_source: review-2026-07-25-soh-attachments-1.md
status: pending-adjudication
---

# Improvement Proposals: SOH-ATTACHMENTS-1 (issues #576 + #585)

**72h review window opens 2026-07-25. Adjudication by human; routing to drbothen/vsdd-factory per DEC-164 precedent.**

All proposals are classified as ENGINE (vsdd-factory prompt templates, skill checklists, agent configs), REPO (jira-cli product repo backlog), or LESSON (lessons.md codification already done; routing for awareness only). None of the ENGINE proposals require product source changes.

**Deduplication survey:** All 6 proposals verified against IP-571-01..13 (routed 2026-07-08) and IP-577-01..11 (routed 2026-07-15).
- IP-576-01 (cost tracking) extends IP-571-01 (same gap; 4th cycle; no implementation yet).
- IP-576-04 (STATE-MANAGER-MONOLITHIC-WRITE-STALL) directly extends IP-577-05 (routed to vsdd-factory #649; 5th data point, not yet fixed).
- All others are new.

| ID | Category | Routing | Summary | Evidence | Priority |
|----|----------|---------|---------|----------|----------|
| IP-576-01 | cost | ENGINE | Cost tracking initialization — state-manager initializes `cost-summary.md` at F1 gate | PERF-COST-TRACKING open; 4th consecutive cycle with no cost data | HIGH |
| IP-576-02 | quality | ENGINE | Secondary review tier (Step-7) as standing step for bundles with >5 F5 rounds | SAFE-NAME-GUARD-EXTRACTION: cross-model unique finding in 1 pass after 14 primary rounds missed it | HIGH |
| IP-576-03 | convergence | ENGINE | SHARED-FN-CALLER-AUDIT-ON-FIX checklist step in F5 orchestrator | r3 HIGH fix-authored by r1 over-reach on shared fn; added one full PR + one adversary round | HIGH |
| IP-576-04 | workflow | ENGINE | STATE-MANAGER-MONOLITHIC-WRITE-STALL fix (5th data point) | Extends IP-577-05 (vsdd-factory #649); Bash-python workaround now load-bearing in every bundle | HIGH |
| IP-576-05 | convergence | ENGINE | EC-CODIFICATION-EARLY discipline: codify accepted behavioral edges as spec ECs in same burst they are dispositioned | Rounds 4–9 (6 rounds) were doc-fallout; EC at r11/r12 closed loop; early codification at r5/r7 would have saved ~3 rounds | MEDIUM |
| IP-576-06 | workflow | REPO | RELEASING.md doc backlog — draft from dev.8/dev.9/dev.10/dev.11 precedent | RELEASING-MD-MISSING open since 2026-07-09; 3 release cycles later still absent | LOW |

---

## Detailed Proposals

### IP-576-01: Cost Tracking Initialization (ENGINE)

**Category:** cost
**Priority:** HIGH
**Evidence:** PERF-COST-TRACKING has been an open Drift Item since at least the ADF-CODE-MARK-EXCLUSIVITY cycle. This is the fourth consecutive feature bundle with no cost data. The F7 convergence report could only provide rough qualitative estimates (~4–6M tokens for wave-gate → F7 arc; ~18–24M for full feature arc including F2 adversary passes). Without per-phase actuals it is impossible to benchmark F5 round efficiency, detect runaway loops early by cost signal, or compare feature vs. bug-fix arc costs.

**Recommendation:** State-manager initializes `.factory/cost-summary.md` at F1 gate with token-budget estimates by phase (F2: N passes × est. K tokens/pass; F4: M stories × est. J tokens/story; F5: STRICT budget). Orchestrator appends actuals at each phase close. Template should match the prior-cycle benchmarks table in the session review.

**Affected components:** STATE.md, `cost-summary.md` (new template), orchestrator F1-gate prompt, orchestrator F7-close prompt.

**Dedup:** extends IP-571-01 (same gap class; routed to vsdd-factory; not yet implemented after 3 cycles).

**Risk:** Token counting is approximate; per-provider differences make exact accounting difficult. Qualitative phase-relative comparisons (F2 vs. F5 cost ratio) are more stable than absolute numbers.

---

### IP-576-02: Secondary Review Tier (Step-7) as Standing Step (ENGINE)

**Category:** quality
**Priority:** HIGH
**Evidence:** SOH-ATTACHMENTS-1 is the first feature bundle to include a formal Step-7 secondary review with a fresh-context adversary using a different model. The secondary reviewer identified SAFE-NAME-GUARD-EXTRACTION (copy-pasted SEC-576-004 CRLF/NUL/`"`/`\` guard in `upload_attachments` and `attach_temporary_file`) on first read — a finding that never appeared in 14 primary adversary rounds. The guard had been extended twice in lockstep during F5 (r1 added `"`, r2 added `\`), demonstrating a real maintenance risk that repeated single-model iteration could not surface.

Additionally, the secondary reviewer provided a dissent on EC-3.9.006-7 (STEP2-429-RETRY) that strengthens the future-bundle brief: the ADR-0017 multipart constraint does not apply to the trivially-rebuildable JSON step-2 body. Ruling stands, but the dissent document provides better context for the next bundle than a plain ledger entry.

**Recommendation:** Add Step-7 secondary review as a mandatory step in all feature-mode bundles where F5 ran ≥5 rounds under STRICT criterion. Use a model different from the primary adversary (confirmed to provide non-redundant coverage in this cycle). The secondary review scope: all new/modified source files in the bundle delta, plus the corresponding test files. Dissent pattern (record disagreement with ruling, do not override) should be codified in the Step-7 prompt.

**Affected components:** orchestrator feature-sequence prompt (Step 7 addition); F5 convergence template (secondary-review section).

**Dedup:** new proposal; no prior IP covers secondary review tier.

**Risk:** Adds one adversary-round cost per qualifying bundle. If secondary findings are all duplicates of primary findings, the tier is still net-positive (confirms primary completeness); if zero duplicates, confirms cross-model blind spot exists in the primary model.

---

### IP-576-03: SHARED-FN-CALLER-AUDIT-ON-FIX Checklist Step (ENGINE)

**Category:** convergence
**Priority:** HIGH
**Evidence:** The r1 fix direction for F5-R1-004 (404 parity) targeted `get_attachment_metadata` without checking that BC-2.7.012 mandates canonical-only error semantics for this function on single-key download 404. The fix changed the function's error return path in a way that broke BC-2.7.012. The r3 adversary caught this as a HIGH (BC-2.7.012 canonical-only restoration). This added one full fix PR (#647 FIX-F5-008) plus one adversary round — both preventable with a per-caller BC audit at r1 fix time.

The pattern: orchestrator issues a fix direction for finding X targeting function F; function F is also anchored in BC Y by a different caller; fix direction silently changes F's semantics in a way that violates BC Y.

**Recommendation:** Add a mandatory pre-fix-direction check to the F5 orchestrator prompt: "If the fix direction targets a function name that appears in any BC's `**Trace**:` or `**Source**:` field other than the finding's BC, enumerate ALL BCs that anchor this function before issuing the fix direction. Confirm that the proposed change does not break any anchored BC's invariant."

This is a grep-checkable precondition: `grep -r "function_name" .factory/specs/prd/bc-*.md`. Orchestrator should run this check before issuing any fix direction that modifies a function with multiple usages.

**Affected components:** orchestrator F5 fix-direction prompt; F5 template.

**Dedup:** new proposal; covered as Process Observation (a) in F5 convergence-summary but not yet in engine prompts.

**Risk:** Adds per-fix-direction overhead. Should only fire when the function name appears in ≥2 BCs. The grep is fast; the cost of skipping it has been demonstrated (one fix-authored HIGH).

---

### IP-576-04: STATE-MANAGER-MONOLITHIC-WRITE-STALL Fix (ENGINE)

**Category:** workflow
**Priority:** HIGH
**Evidence:** 5th occurrence across 3 consecutive bundles (SOH-BUGS-1: 1; SOH-COMMENT-CRUD-1: 4–5; SOH-ATTACHMENTS-1: 1). The timestamp-advancement hook requires every STATE.md edit to span from line 6 (timestamp field), forcing monolithic writes that trigger repeated API stalls. The Bash-python workaround (use Bash-python for non-Edit writes to bypass the PreToolUse per-edit gate) is now load-bearing in every orchestrator burst that touches STATE.md.

This is the same item as IP-577-05 (routed to vsdd-factory #649 on 2026-07-15). The 5th data point confirms the fix has not yet been implemented.

**Recommendation:** Engine-side: increase PostToolUse hook timeout for Write tool on STATE.md, or restructure the timestamp-advancement hook to fail-open (emit warning to stderr, do not block) when count propagation cannot be verified within the budget. The data shows the workaround is reliable — the hook's hard-block adds cost with no quality benefit.

**Affected components:** vsdd-factory hook configuration; state-manager role definition.

**Dedup:** extends IP-577-05 (vsdd-factory #649); new data point count = 5.

**Risk:** Fail-open on count validation could allow count drift through undetected. Mitigation: the consistency-validator (CV) round in subsequent adversary passes catches any drift. The hard-block's protection is redundant with CV.

---

### IP-576-05: EC-CODIFICATION-EARLY Discipline (ENGINE)

**Category:** convergence
**Priority:** MEDIUM
**Evidence:** In SOH-ATTACHMENTS-1 F5, rounds 4–9 (6 rounds) were predominantly doc-fallout of fix commits, with limited novel behavioral content. The loop closed at round 12 after EC-3.9.006-7 (deliberate 429 asymmetry) was codified at r7 and EC-X.8.010-2 (per-command stale-heal scope DOCUMENT-AS-IS) was codified at r11. These EC codifications immediately collapsed the adversary's finding space. If both ECs had been codified when the behaviors were first accepted (r5 for EC-3.9.006-7, wave gate for EC-X.8.010-2), rounds 4–9 would likely have been clean, saving approximately 3 rounds and 2 fix PRs.

**Recommendation:** Add to the F5 orchestrator disposition prompt: "When a finding is dispositioned as 'accepted behavior', 'by-design', or 'deliberate asymmetry', add an EC clause to the spec body in the SAME fix-round burst. Do not defer EC-codification to a subsequent pass. The EC must: (1) name the specific behavior, (2) state the rationale (e.g., ADR reference), and (3) appear in the spec section corresponding to the affected BC."

**Affected components:** orchestrator F5 disposition prompt; fix-direction template.

**Dedup:** new proposal; covered as Process Observation (c) in F5 convergence-summary but not yet in engine prompts.

**Risk:** EC clauses written hastily mid-loop may be imprecisely scoped and require a subsequent correction. This is lower-cost than a full rediscovery round. Imprecise ECs can be corrected by the next adversary pass; missing ECs regenerate findings indefinitely.

---

### IP-576-06: RELEASING.md (REPO)

**Category:** workflow
**Priority:** LOW
**Evidence:** RELEASING-MD-MISSING has been an open Drift Item since SOH-BUGS-1 closed on 2026-07-09 (DEC-167). Four subsequent releases (dev.8, dev.9, dev.10, dev.11) ran using an undocumented procedure reconstructed from DEC precedents each time. The release skill prompts interactively on every release precisely because no repo-level procedure document exists.

**Recommendation:** Write `RELEASING.md` at the jira-cli repo root. Content: synthesize the dev.8 through dev.11 precedent flows from DEC-162/163/167/176/186 into a canonical step-by-step procedure. Include: (1) bump branch naming convention, (2) Cargo.toml version update, (3) PR target branch, (4) tag format and push command, (5) CI workflow check, (6) GitHub release assets expected. Can be done as a docs-only story in the next maintenance sweep.

**Affected components:** `RELEASING.md` (new file, jira-cli repo root).

**Dedup:** new proposal for REPO; no prior IP targets jira-cli RELEASING.md specifically (IP-571..577 were all engine-side).

**Risk:** Low. Documentation only; no code change. If the release procedure evolves, RELEASING.md needs updating — but that is always true for procedure docs.

---

## Processing Instructions

After 72h review window closes (2026-07-28):
- APPROVE → route ENGINE proposals to drbothen/vsdd-factory (new issue or comment on existing per dedup notes above); route REPO proposal to jira-cli backlog story
- REJECT → record reason in Notes column; archive here
- DEFER → move to `improvement-backlog.md` with priority and target cycle

**Routing map:**

| ID | On APPROVE: Target |
|----|-------------------|
| IP-576-01 | vsdd-factory — comment on #649 (STATE cost tracking) or new issue (cost tracking family) |
| IP-576-02 | vsdd-factory — new issue (secondary review tier standing step) |
| IP-576-03 | vsdd-factory — new issue (SHARED-FN-CALLER-AUDIT-ON-FIX orchestrator checklist) |
| IP-576-04 | vsdd-factory — comment on existing #649 (5th data point; escalation note) |
| IP-576-05 | vsdd-factory — new issue or comment on F5 convergence template issue |
| IP-576-06 | jira-cli — docs-only backlog story; target: next maintenance sweep |
