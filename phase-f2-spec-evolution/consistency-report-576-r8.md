---
report: consistency-report-576-r8
feature: SOH-ATTACHMENTS-1
spec_version: v1.3.45
bc_count: 657
holdout_count: 95
round: R8
date: 2026-07-15
validator: vsdd-factory:consistency-validator (fresh context, no prior round memory)
verdict: GAPS-FOUND
new_finding_count: 1
new_finding_severity_breakdown: "INFO×1"
r7_closure: all_4_resolved
---

# SOH-ATTACHMENTS-1 F2 Consistency Report — Round R8

**Verdict: GAPS-FOUND** — 1 INFO new finding. No CRITICAL, HIGH, MEDIUM, or LOW findings. All R7 items confirmed resolved.

## 1. Scope

Fresh-context round-8 pass over the full SOH-ATTACHMENTS-1 F2 spec package at spec version 1.3.45 (657 BCs, 95 holdouts), post R7-polish. Independent findings formed before reading R7 report.

Surface set covered:
- `.factory/specs/prd/bc-2-issue-read.md` (sections 2.7)
- `.factory/specs/prd/bc-3-issue-write.md` (section 3.9)
- `.factory/specs/prd/cross-cutting.md` (BC-X.8.010)
- `.factory/specs/prd/holdout-scenarios.md` (Group 19, H-NEW-ATTACHMENT-001..007)
- `.factory/specs/prd/BC-INDEX.md`
- `.factory/specs/prd/CANONICAL-COUNTS.md`
- `.factory/spec-changelog.md`
- `.factory/phase-f2-spec-evolution/prd-delta-576.md`
- `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md`
- `.factory/phase-f2-spec-evolution/security-review-576.md`
- `.factory/phase-f1-delta-analysis/impact-boundary-576.md`
- `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`
- `.factory/specs/architecture/ARCH-INDEX.md`
- `.factory/architecture/adr-index.md`

## 2. New Findings (R8)

### FINDING-R8-001 — INFO

**File:** `.factory/specs/prd/CANONICAL-COUNTS.md`
**Location:** Line 128 (Holdout Scenarios section, Group 19 entry)
**Description:** The Group 19 entry reads:

> H-NEW-ATTACHMENT-001..H-NEW-ATTACHMENT-007 (BC-3.9.015..020; issues #576 #585) — +7

The BC citation `(BC-3.9.015..020)` covers only the round B new BCs (the trigger BCs). However, `holdout-scenarios.md` frontmatter trace shows the Group 19 holdouts collectively pin a broader set: BC-2.7.001, BC-2.7.007, BC-2.7.008/010/011, BC-3.9.001/015..020 plus individual entries referencing BC-2.7.011, BC-3.9.017/018/019/020 specifically.

By convention, Group 15 (the most recent group before Group 19) lists all primary BCs the holdouts in that group pin — e.g., `(BC-3.5.005/008/004/010/003)`. Group 19 should follow the same convention.

**Root cause:** The R7-002 fix added the Group 19 entry using only the round B trigger BCs (BC-3.9.015..020) rather than deriving all primary BC references from the holdout bodies themselves — inconsistent with the Group 15 convention.

**Impact:** Cosmetic only. No correctness impact on holdout traceability, count surfaces, or implementation-readiness. The holdouts themselves carry correct individual BC citations; this is solely a CANONICAL-COUNTS.md entry completeness gap.

**Suggested fix:** Update Group 19 BC citation to `(BC-2.7.001/007/008/010/011 + BC-3.9.001/015..020; issues #576 #585)` or a compact equivalent that matches the full primary BC set from holdout-scenarios.md frontmatter trace. Non-blocking.

---

## 3. R7 Closure Table

| Finding | Severity | Description | Closure Status | Verification |
|---------|----------|-------------|----------------|--------------|
| FINDING-R7-001 | LOW | CANONICAL-COUNTS.md "Total individually-bodied" said 421, should be 427 | RESOLVED | Line 30: `\| **Total individually-bodied** \| **427** \|` ✓ |
| FINDING-R7-002 | LOW | CANONICAL-COUNTS.md holdout section said 88; Group 19 entry absent | RESOLVED | Line 111: `**Canonical holdout total: 95**`; Group 19 entry present; reconciliation note "Last reconciled: 2026-07-15" ✓ |
| FINDING-R7-003 | INFO | CANONICAL-COUNTS.md BC-X.4.009 note referenced 651 and 650 (stale; should be 657/656) | RESOLVED | Lines 64-65: "in the **657 sum**" and "NOT add +1 beyond the **656**" ✓ |
| FINDING-R7-004 | INFO | BC-INDEX.md SOH-COMMENT-CRUD-1 body-note date said "2026-07-11..14" | RESOLVED | Line 794: "added **2026-07-09**" confirmed ✓ |

Prior-round regressions: none detected. R6 findings R6-001..R6-004 remain resolved; R6-005 (impact-boundary-576.md §1.1 missing `get_attachment_metadata` function) remains expected-open as a story S4 authoring note.

---

## 4. Count Surface Verification

| Surface | Checked value | Status |
|---------|--------------|--------|
| bc-2-issue-read.md frontmatter `total_bcs` | 106 | ✓ |
| bc-2-issue-read.md frontmatter `definitional_count` | 64 | ✓ |
| bc-3-issue-write.md frontmatter `total_bcs` | 140 | ✓ |
| bc-3-issue-write.md frontmatter `definitional_count` | 111 | ✓ |
| cross-cutting.md frontmatter `total_bcs` | 150 | ✓ |
| cross-cutting.md frontmatter `definitional_count` | 84 | ✓ |
| BC-INDEX.md frontmatter `total_bcs` | 657 | ✓ |
| BC-INDEX.md `index_version` | v6.14 | ✓ |
| BC-INDEX.md Section 2.7 header | "12 BCs: BC-2.7.001..012" | ✓ |
| BC-INDEX.md Section 3.9 header | "20 BCs: BC-3.9.001..020" | ✓ |
| BC-INDEX.md Section X.8 header | "10 BCs: BC-X.8.001..010" | ✓ |
| BC-INDEX.md Coverage Statistics Total | 657 / 427 | ✓ |
| BC-INDEX.md SOH-COMMENT-CRUD-1 body-note date | "2026-07-09" | ✓ (R7-004 applied) |
| CANONICAL-COUNTS.md "Total individually-bodied" table row | 427 | ✓ (R7-001 applied) |
| CANONICAL-COUNTS.md per-file `total_bcs` Sum row | 657 | ✓ |
| CANONICAL-COUNTS.md Grand total | 657 | ✓ |
| CANONICAL-COUNTS.md breakdown prose "427 of 657" | matches | ✓ |
| CANONICAL-COUNTS.md holdout section total | 95 | ✓ (R7-002 applied) |
| CANONICAL-COUNTS.md Group 19 entry BC citation | "(BC-3.9.015..020)" | GAP — FINDING-R8-001 (INFO: incomplete vs. Group 15 convention) |
| CANONICAL-COUNTS.md BC-X.4.009 note values | 657, 656 | ✓ (R7-003 applied) |
| CANONICAL-COUNTS.md ADR count | 17 (ADR-0001..0017) | ✓ |
| holdout-scenarios.md frontmatter `total_holdouts` | 95 | ✓ |
| holdout-scenarios.md Group 19 (H-NEW-ATTACHMENT-001..007) | 7 scenarios present | ✓ |
| prd-delta-576.md frontmatter `bc_count_after` / `holdout_count_after` | 657 / 95 | ✓ |
| spec-changelog.md [1.3.45] bc/holdout deltas | 651→657 / 88→95 | ✓ |
| ADR-0017 status | Accepted 2026-07-15 | ✓ |
| ARCH-INDEX.md ADR-0017 entry | present | ✓ |
| adr-index.md ADR-0017 entry | "Accepted (2026-07-15; gate DEC-179 item 7)" | ✓ |

---

## 5. Full Check-Class Results

| Check class | Result |
|-------------|--------|
| Design/research contradictions | CLEAN. P2-3c INCONCLUSIVE correctly flagged in BC-3.9.007/011. OQ-9 silent no-op rule correctly implemented in BC-3.9.004. PHASE-DOC-RETRO-ANNOTATION markers in impact-boundary-576.md correctly preserve audit trail for OQ-9 and BC-3.9.012 corrections. |
| Index-vs-body fidelity | CLEAN. BC-INDEX Sections 2.7/3.9/X.8 rows consistent with body content. Source citations consistently reference the pending `src/api/jira/attachments.rs` family (story S1-S5). |
| Citation targets | CLEAN. All BC body citations reference valid, present BCs. No dangling forward or backward references detected. |
| INCONCLUSIVE-figure leaks | CLEAN. P2-3c properly contained to BC-3.9.007 and BC-3.9.011 with explicit S5 delivery obligations. No INCONCLUSIVE figures appear outside their designated containment BCs. |
| Dangling IDs | CLEAN. All BC-3.9.015..020 IDs referenced in holdout bodies and BC-INDEX rows. No orphaned or forward-only IDs. |
| Stale markers | CLEAN. Round B "DELIVERED" annotation in prd-delta-576.md Scope Note is correct. No stale "TODO", "PENDING", or draft markers remain. |
| Count surfaces (prose/narrative) | ONE GAP (FINDING-R8-001, INFO). All 8 guarded numerical surfaces at 657. Group 19 CANONICAL-COUNTS.md entry BC citation incomplete vs. Group 15 convention. |
| Date consistency | CLEAN. All 2026-07-15 dates for SOH-ATTACHMENTS-1 artifacts consistent across prd-delta-576.md, spec-changelog.md, ADR-0017, ARCH-INDEX.md, adr-index.md, BC-INDEX.md `last_updated`, CANONICAL-COUNTS.md `last_verified`. SOH-COMMENT-CRUD-1 date now 2026-07-09 in BC-INDEX body-note (R7-004 applied). |
| JSON-shape ordering | CLEAN. BTreeMap alphabetical ordering verified for all attachment command JSON shapes: delete single (`deleted` < `issue_key`), delete bulk (`cancelled` < `deleted` < `issue_key`), delete cancel (`cancelled` < `deleted`), dry-run preview (`attachments` < `dry_run` < `issue_key`), upload array. R6-003 fix confirmed intact. |
| Exit-code consistency | CLEAN. BC-3.9.016 and BC-3.9.019 correctly specify exit 2 (clap `requires` constraint violation). R6-004 fix confirmed intact. |
| Holdout-BC asymmetry | CLEAN (with FINDING-R8-001 cosmetic note). All 7 Group 19 holdouts trace to existing, correctly-numbered BCs. Individual holdout BC citations in holdout-scenarios.md body are correct and complete. No orphaned holdout BC refs. The asymmetry vs. CANONICAL-COUNTS.md Group 19 entry is cosmetic (FINDING-R8-001). |
| ADR claims | CLEAN. ADR-0017 Accepted 2026-07-15 confirmed in both ARCH-INDEX.md and adr-index.md. prd-delta-576.md §ADR Reference section cites correct file path and date. |

---

## 6. Prior-Round Regression Check

| Prior finding | Last status | Regression in R8? |
|---------------|-------------|-------------------|
| FINDING-R6-001 (BC-INDEX 3.9 header) | RESOLVED R6 | No |
| FINDING-R6-002 (spec-changelog [1.3.45] ADR ref) | RESOLVED R6 | No |
| FINDING-R6-003 (JSON shape alphabetical order) | RESOLVED R6 | No |
| FINDING-R6-004 (exit 2 vs. 64 for BC-3.9.016/019) | RESOLVED R6 | No |
| FINDING-R6-005 (impact-boundary §1.1 missing fn) | DEFERRED INFO (non-blocking S4 note) | No — still expected-open |
| FINDING-R7-001 (CANONICAL-COUNTS "Total" row) | RESOLVED R7 | No |
| FINDING-R7-002 (CANONICAL-COUNTS holdout 88→95 + Group 19) | RESOLVED R7 | No |
| FINDING-R7-003 (CANONICAL-COUNTS BC-X.4.009 stale values) | RESOLVED R7 | No |
| FINDING-R7-004 (BC-INDEX SOH-COMMENT-CRUD-1 date) | RESOLVED R7 | No |

---

## 7. Summary

**Verdict: GAPS-FOUND** (1 INFO). No CRITICAL, HIGH, MEDIUM, or LOW findings.

The single finding is localized to CANONICAL-COUNTS.md Group 19 BC citation scope — a cosmetic convention gap with no correctness impact on traceability, count surfaces, or implementation-readiness. All R7 findings are closed. The spec package is implementation-ready at v1.3.45.

| Severity | Count | Blocking implementation? |
|----------|-------|--------------------------|
| CRITICAL | 0 | N/A |
| HIGH | 0 | N/A |
| MEDIUM | 0 | N/A |
| LOW | 0 | N/A |
| INFO | 1 | No — cosmetic convention gap |
