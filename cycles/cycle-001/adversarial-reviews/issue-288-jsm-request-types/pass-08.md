---
document_type: adversarial-pass
phase: F1d
pass: 08
cycle: 3-feature-jsm-request-types-288
target: "issue-288 F2 spec delta — pass-07 risk-register fix + fresh review"
model: "Opus 4.7 (1M)"
timestamp: 2026-05-18
verdict: CLEAN-PASS
counts:
  blocking: 0
  concern: 0
  nit: 0
counter_status: "1/3 (first CLEAN-PASS; 2 more required for convergence)"
pass_07_disposition: "1 ADDRESSED (F48); 3 no-action NITs (F49 false-positive, F50 substring intent, F51 pending intent)"
---

# F1d Pass 08 — Issue #288 — CLEAN-PASS

**Target**: F2 spec delta for issue #288 (JSM request type support) — pass-07 risk-register fix + fresh review
**Verdict**: CLEAN-PASS — 0 BLOCKING, 0 CONCERN, 0 NIT. Counter: 1/3 (first CLEAN-PASS of the run).

Pass-07 F48 was the final actionable finding: risk-register.md lines 5–6 now read "Total risks: 36"
with breakdown "1C/7H/11M/17L", reconciling the header with its own Risk Summary table (line 119)
and with CANONICAL-COUNTS. DRIFT-010 CLOSED. The three pass-07 NITs (F49–F51) were reviewed as
no-action: F49 was a false-positive (symbol exists in current codebase), F50 reflects deliberate
substring-match intent documented in spec, F51 is a tracked-pending intent already in DRIFT-008.
All 18 mandates are CLEAR. Comprehensive Mode B sweep finds zero stale counts, zero stale BC
ranges, zero non-existent symbol references. 2 more consecutive CLEAN-PASSes required for
full convergence.

---

## Pass-07 Disposition Summary

| Finding | ID | Verdict | Notes |
|---------|----|---------|-------|
| risk-register.md header self-contradicts body Summary | F48 | ADDRESSED | Lines 5–6 now "Total risks: 36 (1C/7H/11M/17L)" — matches body Risk Summary table and CANONICAL-COUNTS. Source: risk-register.md:5-6. |
| NIT (false-positive) | F49 | NO-ACTION | Symbol verified to exist in current codebase; false-positive at time of review. |
| NIT (substring intent) | F50 | NO-ACTION | Deliberate substring-match behavior; intent documented in spec. Not a defect. |
| NIT (pending intent) | F51 | NO-ACTION | Tracked pending intent already within scope of DRIFT-008. No new action needed. |

---

## Mode B Comprehensive Sweep

All sweep checks executed against the full #288 F2 spec delta corpus.

```
# Count and BC-range sweep
grep -r "35 risks\|34 risks\|33 risks" \
  .factory/specs/ .factory/stories/ .factory/STATE.md 2>/dev/null
# Result: 0 matches — no stale risk counts

grep -r "BC-3\.8\.00[1-9]\.\.00[89]\b" \
  .factory/specs/ .factory/stories/ 2>/dev/null
# Result: 0 matches — no stale BC ranges

grep -r "BC-3\.8\.001\.\.009\b" \
  .factory/specs/prd/ .factory/stories/ 2>/dev/null
# Result: 0 matches — bc-3 frontmatter trace: updated to BC-3.8.001..010 in pass-06

# Cross-doc count agreement
# CANONICAL-COUNTS risks: 36 (1C/7H/11M/17L) — VERIFIED
# risk-register.md header: 36 (1C/7H/11M/17L) — VERIFIED (pass-07 F48 fix)
# risk-register.md body Risk Summary table: 36 — VERIFIED

# Non-existent symbol reference sweep
grep -r "R-H288-2\b" .factory/ 2>/dev/null
# Result: 0 matches — ADR-0014 related[] corrected in pass-06 (F44 ADDRESSED)

grep -r "BC-3\.8\.006\b.*raiseOnBehalfOf\|raiseOnBehalfOf.*BC-3\.8\.006\b" \
  .factory/specs/ 2>/dev/null
# Result: 0 matches — verification-delta mis-anchor corrected in pass-06 (F47 ADDRESSED)

# Stale count propagation sweep
grep -r "28 risks\|total_risks: 28\|total_risks: 34\|total_risks: 35" \
  .factory/specs/ .factory/stories/ .factory/STATE.md 2>/dev/null
# Result: 0 matches

# README supplement-index holdout count
grep -r "48 holdout\|53 holdout\|54 holdout" .factory/specs/ .factory/stories/ 2>/dev/null
# Result: 0 matches — holdout count at 55 in all canonical locations
```

**Sweep result: CLEAN.** Zero stale counts, zero stale BC ranges, zero non-existent symbol
references. All cross-doc counts agree.

---

## Per-Mandate Audit

All 18 mandates from the F1d mandate register are CLEAR.

| Mandate | Description | Status |
|---------|-------------|--------|
| M-01 | Count arithmetic: BC totals (BCs/risks/holdouts) | CLEAR — all counts reconciled across CANONICAL-COUNTS, risk-register.md header, bc-INDEX, holdout-scenarios.md |
| M-02 | Intra-BC consistency: Behavior↔Outputs/Effects↔Errors | CLEAR — BC-3.8.001..010 and BC-X.12.001..006 fields internally consistent |
| M-03 | Frontmatter↔body coherence | CLEAR — bc-3 trace: BC-3.8.001..010, ADR-0014 related: R-M288-1, all frontmatter cites verified |
| M-04 | ADR/BC consistency: ADR-0014 implementation decision refs | CLEAR — ADR-0014 cites BC-3.8.001..010 correctly |
| M-05 | JSON output stability: --output json shapes for queue and request-type commands | CLEAR — BC-X.12.* output shapes spec'd with exact field names |
| M-06 | --no-input parity: all interactive prompts have flag equivalents | CLEAR — spec documents --service-desk, --request-type flags for non-interactive use |
| M-07 | OAuth scope coordination: JSM APIs require correct Jira scopes | CLEAR — spec cites read:servicedesk-request scope; OAuth scope section verified |
| M-08 | Error message accuracy: error strings match JrError enum variants | CLEAR — error strings in BC Errors sections verified against JrError enum |
| M-09 | Cache invalidation: JSM cache TTL policy aligned with other caches | CLEAR — 7-day TTL for request-type cache aligned with existing cache.rs policy |
| M-10 | Holdout setup: all H-NEW-JSM-* holdouts have implementation notes | CLEAR — H-NEW-JSM-RT-001..005 all have wire-shape mock cardinality specs |
| M-11 | Wire shape: request-type list response fields match Atlassian REST API | CLEAR — wire fields (id, name, description, helpText, issueTypeId) verified against Atlassian JSM API docs |
| M-12 | BC-3.8.010 wiring: queue-list paginates correctly | CLEAR — BC-3.8.010 specifies offset pagination matching JSM /queues endpoint behavior |
| M-13 | BC-3.8.009 accountId precedent: user resolution follows existing pattern | CLEAR — accountId resolution spec consistent with BC-2.6.051 precedent |
| M-14 | Call-site label contract: jr queue vs jr request-type namespacing | CLEAR — CLI label contracts in BC-X.12.* consistent with main.rs dispatch |
| M-15 | Delta-doc self-consistency: prd-delta.md internal references | CLEAR — prd-delta.md cross-references to BC sections verified; Open Questions emptied to §Validated |
| M-16 | README index family: supplement-index, feature-index, BC-INDEX agree | CLEAR — README.md supplement index shows 55 holdouts; BC-INDEX shows correct BC ranges |
| M-17 | Verification-delta BC cross-references: traces_to citations exist | CLEAR — verification-delta.md BC citations verified against canonical bc-N-*.md (pass-06 F47 fix confirmed) |
| M-18 | Header-vs-body coherence: risk-register.md header = body total | CLEAR — pass-07 F48 fix: header 36 = body Summary 36 = CANONICAL-COUNTS 36 |

---

## Convergence Trajectory

| Pass | Blocking | Concern | Nit | Counter | Delta |
|------|----------|---------|-----|---------|-------|
| 01 | 4 | 6 | 3 | 0/3 | — |
| 02 | 0 | 3 | 4 | 0/3 (reset) | −4B |
| 03 | 0 | 4 | 6 | 0/3 (reset) | +1C |
| 04 | 0 | 2 | 5 | 0/3 (reset) | −2C |
| 05 | 0 | 2 | 3 | 0/3 (reset) | =C |
| 06 | 0 | 2 | 3 | 0/3 (reset) | =C |
| 07 | 0 | 1 | 3 | 0/3 (reset) | −1C |
| **08** | **0** | **0** | **0** | **1/3** | **−1C (CLEAN)** |

Trajectory shorthand: `4B/6C/3N → 0B/3C/4N → 0B/4C/6N → 0B/2C/5N → 0B/2C/3N → 0B/2C/3N → 0B/1C/3N → 0B/0C/0N (CLEAN 1/3)`

---

## Convergence Counter Status

**1/3 — First CLEAN-PASS of the run.**

Per F1d convergence rules: 3 consecutive CLEAN-PASSes required for full convergence. This is
pass 1 of 3. Pass-09 will be the next adversarial pass. If pass-09 is also CLEAN, counter
advances to 2/3. If pass-09 introduces any finding (B/C/N), counter resets to 0/3 and the
finding(s) must be remediated before the next pass.

---

## Verdict

**CLEAN-PASS** — 0 BLOCKING / 0 CONCERN / 0 NIT.

All 18 mandates CLEAR. Comprehensive Mode B sweep clean. Pass-07 F48 ADDRESSED. Counter 1/3.
2 more consecutive CLEAN-PASSes required for full convergence.
