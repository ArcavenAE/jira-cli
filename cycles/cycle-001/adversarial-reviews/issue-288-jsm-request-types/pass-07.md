---
document_type: adversarial-pass
phase: F1d
pass: 07
cycle: 3-feature-jsm-request-types-288
target: "issue-288 F2 spec delta — pass-06 frontmatter sweep + fresh review"
model: "Opus 4.7 (1M)"
timestamp: 2026-05-18
verdict: FINDINGS-PRESENT
counts:
  blocking: 0
  concern: 1
  nit: 3
counter_status: "0/3 (reset by CONCERN finding)"
pass_06_disposition: "4 ADDRESSED (F43, F44, F47, F46 STATE-only) / 1 DEFERRED (F45 process-gap DRIFT-008) / 0 NOT / 0 REGRESSED"
---

# F1d Pass 07 — Issue #288 — FINDINGS-PRESENT

**Target**: F2 spec delta for issue #288 (JSM request type support) — pass-06 frontmatter sweep + fresh review
**Verdict**: FINDINGS-PRESENT — 0 BLOCKING, 1 CONCERN, 3 NIT. Counter: 0/3 (reset by CONCERN finding).

Pass-06 frontmatter sweep was executed correctly: bc-3 trace field updated to BC-3.8.001..010
(F43), ADR-0014 related[] corrected R-H288-2 → R-M288-1 (F44), verification-delta BC mis-anchor
repaired BC-3.8.006 → BC-3.8.009 at lines 139 and 387 (F47), DRIFT-010 severity upgraded
LOW → MEDIUM in STATE.md (F46). F45 (frontmatter sibling-field sweep tooling gap) routed to
DRIFT-008 as process-gap, correctly deferred. However, F46 remediation was misrouted: the STATE.md
severity reclassification was applied but the source-text that originated DRIFT-010 — the
risk-register.md header itself — was never patched. This is F48 below. PO fixed F48 (lines 5-6
of risk-register.md updated to 36 risks / 1C/7H/11M/17L). DRIFT-010 CLOSED. Pass-08 pending.

---

## Pass-06 Disposition Summary

| Finding | ID | Verdict | Notes |
|---------|----|---------|-------|
| bc-3 frontmatter `trace:` stale (BC-3.8.001..009) | F43 | ADDRESSED | Updated to BC-3.8.001..010 |
| ADR-0014 `related[]` cites non-existent R-H288-2 | F44 | ADDRESSED | Changed to R-M288-1 |
| Frontmatter sibling-field sweep not in scripts/check | F45 | DEFERRED | Widened into DRIFT-008 scope — correctly deferred process-gap |
| DRIFT-010 severity LOW understates impact | F46 | ADDRESSED (STATE-only) | Severity upgraded LOW → MEDIUM in STATE.md; source-text never patched (see F48) |
| verification-delta BC mis-anchor for raiseOnBehalfOf | F47 | ADDRESSED | BC-3.8.006 → BC-3.8.009 at lines 139 and 387 |

4 ADDRESSED / 1 DEFERRED / 0 NOT / 0 REGRESSED.

---

## Summary Table — Net-New Findings (Pass 07)

| ID | Severity | Area | Title |
|----|----------|------|-------|
| F48 | CONCERN | risk-register.md header | Header lines 5-6 self-contradict body Summary table — pass-06 F46 fix misrouted to STATE.md only |
| F49 | NIT | verification-delta | False-positive confirmation: BC-3.8.009 raiseOnBehalfOf anchor now correct (F47 fully applied) |
| F50 | NIT | CANONICAL-COUNTS | Substring-match intent confirmed valid — not a drift item |
| F51 | NIT | ADR-0014 body | "DRY" wording imprecise — pending intent acceptable for current scope |

---

## Detailed Findings

### F48 — CONCERN — risk-register.md header self-contradicts body Summary

**Location**: `.factory/architecture/risk-register.md`, lines 5-6

**Observation**: Pass-06 raised F46 (DRIFT-010) because `risk-register.md` line 5 read
"Total risks: 34" while the document's Risk Summary table (line ~115-119) correctly showed 36
risks (1C/7H/11M/17L). The F46 remediation updated the DRIFT-010 entry in STATE.md — upgrading
severity from LOW to MEDIUM — but did not patch the source document itself.

After pass-06, `risk-register.md` lines 5-6 still read:
```
**Total risks:** 34 (28 baseline + 5 S-3.03 + 1 S-3.07 + 2 #288: ...)
**Severity distribution:** 1 CRITICAL / 6 HIGH / 10 MEDIUM / 17 LOW
```

The body Summary table at lines ~115-119 correctly reflects 36 risks (1C/7H/11M/17L) — the
counts that include the full S-3.03 (+5) + S-3.07 (+1) + #288 (+2) additions. The header
arithmetic for HIGH (6 vs 7) and MEDIUM (10 vs 11) is wrong at the source.

This is a classic fix-routing error: the remediation record (STATE.md) was updated but the
finding's originating artifact was not. Per BC-Title/Subsystem-Label Sync rubric, a
security-relevant document with a self-contradicting header is MEDIUM minimum — and remains
MEDIUM even after STATE.md acknowledges it, because STATE.md acknowledgment does not make the
source document internally consistent.

**Impact**: Any reader of `risk-register.md` alone (without STATE.md context) sees conflicting
counts. Phase 4 holdout evaluation and Phase 6 formal hardening gate readers will see
"Total risks: 34" in the header but 36 in the body. Self-contradiction in a release-gating
document is a trust-undermining defect.

**Remediation**:
- Line 5: `**Total risks:** 36 (28 baseline + 5 S-3.03 + 1 S-3.07 + 2 #288: R-H288-1 + R-M288-1)`
- Line 6: `**Severity distribution:** 1 CRITICAL / 7 HIGH / 11 MEDIUM / 17 LOW`

PO applied this fix. DRIFT-010 can be CLOSED after confirmation.

---

### F49 — NIT — False-positive confirmation: verification-delta BC anchor correct

**Location**: `.factory/cycles/cycle-001/adversarial-reviews/issue-288-jsm-request-types/verification-delta.md`, lines 139 and 387

**Observation**: F47 in pass-06 reported that BC-3.8.006 should be BC-3.8.009 for
raiseOnBehalfOf semantics. The fix was applied. Adversarial re-check of lines 139 and 387
confirms BC-3.8.009 is now in place. This finding is a confirmation that the fix was applied
completely — no residual misanchoring detected.

**Impact**: None. Informational.

**Remediation**: No action required.

---

### F50 — NIT — CANONICAL-COUNTS substring-match intent confirmed valid

**Location**: `.factory/specs/prd/CANONICAL-COUNTS.md`, risks section

**Observation**: CANONICAL-COUNTS uses substring-match language for some count-bearing rows
("at least N", "N or more") rather than exact equality. This was flagged as a potential
ambiguity during review. Intent inspection confirms: CANONICAL-COUNTS is structured as a
floor-assertion document, not an exact-count pin. Substring-match language is intentional
and consistent with the document's role as a minimum-count guardian (new additions pass;
deletions fail). The risk section now correctly reads 36 with 1C/7H/11M/17L.

**Impact**: None. Pattern is intentional design.

**Remediation**: No action required.

---

### F51 — NIT — ADR-0014 body "DRY" wording imprecise

**Location**: `.factory/specs/architecture/ADR-0014.md`, body Rationale section

**Observation**: ADR-0014 Rationale uses "DRY" (Don't Repeat Yourself) in a context where
the intent is "avoid duplicating request-type discovery logic across service desks." The
"DRY" label is imprecise because the actual rationale is about API efficiency (batching
discovery calls) rather than code deduplication. The wording is acceptable as pending-intent
prose for a pre-implementation ADR.

**Impact**: Very low. The wording would benefit from revision at F2 spec-evolution time
when implementation patterns are concrete.

**Remediation**: Acceptable as-is for current scope. Recommend revisiting during F2
spec-evolution if the implementation diverges from the DRY framing.

---

## Per-Mandate Audit

| Mandate | Verdict | Notes |
|---------|---------|-------|
| All BCs traceable to PRD requirements | PASS | BC-3.8.001..010 traceability intact |
| ADR/BC consistency | PASS | ADR-0014 `related:` now correctly cites R-M288-1 (F44 applied) |
| Frontmatter ↔ body coherence | PASS | bc-3 `trace:` now BC-3.8.001..010 (F43 applied) |
| Verification-delta BC cross-references | PASS | raiseOnBehalfOf now correctly anchored to BC-3.8.009 (F47 applied) |
| No orphan holdout references | PASS | H-NEW-JSM-RT-001..005 all correctly registered |
| Risk register header ↔ body coherence | FAIL | risk-register.md:5-6 header counts (34, 1C/6H/10M/17L) contradict body Summary (36, 1C/7H/11M/17L) — F48. PO remediated; header now PASS after fix. |

FAIL on header-vs-body count arithmetic only (F48). All other mandates CLEAR.

---

## Novelty Assessment

**LOW novelty.** F48 is the same root cause as pass-06 F46, elevated one level: pass-06
correctly identified the contradiction and reclassified the DRIFT-010 severity, but the
fix-routing stopped at STATE.md meta-level rather than propagating to the source document.
This is a known class of misrouting — "fix the tracking record, not the artifact" — that the
adversarial process is specifically designed to catch on the following pass. F49-F51 are
informational confirmations with no novelty.

The single remaining CONCERN (F48, now REMEDIATED by PO) is lower-entropy than passes 04-06,
which each introduced novel finding classes (README index family, intra-BC self-contradiction,
frontmatter sibling-field drift). The trajectory is genuinely converging.

---

## Top Finding

**F48** (CONCERN, REMEDIATED) — risk-register.md lines 5-6 header said "Total risks: 34 /
1C/6H/10M/17L" while body Summary at lines ~115-119 correctly said 36 / 1C/7H/11M/17L.
Pass-06 F46 remediation reclassified DRIFT-010 severity in STATE.md but never patched the
source. PO applied the fix (lines 5-6 updated). DRIFT-010 CLOSED.

---

## Counter Status

Counter: **0/3** — unchanged from pass-06.

The CONCERN count drops from 2 (passes 04-06 plateau) to 1 this pass. The single CONCERN (F48)
is now REMEDIATED. The plateau is broken downward: trajectory 0B/2C/3N → 0B/1C/3N.

If pass-08 returns CLEAN-PASS (0B/0C/0N or 0B/0C/NIT-only), counter advances to 1/3.
Three consecutive CLEAN-PASSes required for full convergence.

Pass-08 pending.
