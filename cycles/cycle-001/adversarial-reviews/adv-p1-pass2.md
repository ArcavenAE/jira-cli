# Adversarial Review — Phase 1d Pass 2

**Reviewer**: adversary (fresh-context)
**Date**: 2026-05-04
**Scope**: full Phase 1 spec package post Pass 1 fixes
**Information asymmetry**: adversary did NOT see Pass 1 review or prior fixes

## §1: Findings — 15 total (0 CRITICAL / 6 HIGH / 6 MEDIUM / 3 LOW)

### CRITICAL/HIGH (treated as HIGH)

**ADV-P2-001 — `extract_error_message` chain has 3-way contradiction across canonical docs** [content-defect]
- error-taxonomy.md §2 header says "6-Level Precedence Chain" but body has 7 rows.
- bc-7-output-render.md BC-7.3.001 step 1 says "Empty body → literal `<empty response body>`" — directly contradicted by BC-7.3.005 (line 174) which says extract_error_message returns None for empty body. Step 6 says "errorMessage" while error-taxonomy.md step 6 says "errorDescription".
- architecture/cross-cutting.md line 32 says "7-level" matching error-taxonomy table content (correct).
- BC-INDEX.md line 462 says "6-level" — wrong header quote.
- Recommended action: product-owner — pick ONE canonical chain, fix all 4 documents.

### HIGH

**ADV-P2-002 — Holdout BC anchors widely incorrect (≥11 of 48)** [content-defect]
H-002, H-008, H-009, H-010, H-011, H-015, H-016, H-020, H-023, H-025, H-029, H-047 all point to wrong BCs in BC-INDEX.md after rebuild.
- Recommended: product-owner re-audit every holdout BC ref against BC-INDEX semantic content (not just ID format).

**ADV-P2-003 — NFR-R-NEW-1 referenced but does not exist in NFR Catalog** [content-defect]
References at cross-cutting.md:254, 265, 267 and BC-INDEX.md:547 cite NFR-R-NEW-1 but nfr-catalog.md only has NFR-R-NEW-2 and NFR-P-NEW-1.
- Recommended: product-owner add NFR-R-NEW-1 to catalog OR rename references.

**ADV-P2-004 — NFR-S-E severity-routing trio disagree (LOW vs CRITICAL)** [content-defect]
- nfr-catalog.md:79 — NFR-S-E rated LOW with FIX-IN-PHASE-3
- cicd-setup.md:175 — GAP-1 rated CRITICAL with explicit OAuth secret exposure rationale
- risk-register.md — does NOT include NFR-S-E
- Recommended: architect + product-owner reconcile severity to one canonical rating.

**ADV-P2-005 — NFR catalog count fields disagree four ways** [content-defect]
- frontmatter total_nfrs: 45
- prose: "44 unique NFR concerns"
- severity totals: 1C/4H/16M/22L = 43
- routing summary: 8+3+3+14+17 = 45
- counting clarification: "39 enumerated + 5 collapsed = 44"
- Actual table count: 40 rows (1 CRIT + 4 HIGH + 15 MED + 20 LOW)
- Recommended: product-owner recount and propagate single number.

**ADV-P2-006 — DTU assessment cites 47 holdouts vs canonical 48** [content-defect]
dtu-assessment.md §5 line 168 says "47 holdout candidates"; canonical holdout-scenarios.md says 48.
- Recommended: architect update to 48.

### MEDIUM

**ADV-P2-007** — BC-X.4.003..008 jump in cross-cutting.md without inline range-collapsed marker.
**ADV-P2-008** — BC-7.3.001 self-contradicts BC-7.3.005 on empty-body level-1 behavior.
**ADV-P2-009** — SD-001/002/003 lack scheduled deadlines [process-gap].
**ADV-P2-010** — BC-INDEX traceability gap table claims 0 unresolved gaps; ADV-P2-003 creates one.
**ADV-P2-011** — BC-6.3.001 spec contract uses pseudo-formal language; ADR-0007's accessor not cross-referenced.
**ADV-P2-012** — Section 2 header/body count drift in NFR catalog (already covered by ADV-P2-005 partly).

### LOW

**ADV-P2-013** — BC-X.4.009 numbering implies BC-X.4.003..008 exist; future contributor collision risk.
**ADV-P2-014** — Holdout H-014 cites BC-X.7.004 absorbing 3 Pass 3 BCs; intentional collapse but surprising.
**ADV-P2-015** — Architecture cross-cutting.md "canonical source of truth" pointer disagrees with source's section header (resolved by ADV-P2-001 fix).

## §2: Strengths Noted

1. MUST-FIX BCs are internally well-formed (BC-6.3.001, BC-X.5.002, BC-3.4.001, BC-4.3.001 all have site evidence + ADR cross-references)
2. State machine SM-1 anchors are correct (BC-1.5.031..041 all exist with precise source pins)
3. SD-NNN security drafts are substantive (concrete options A/B/C with code-impact estimates)

## §3: Routing Summary

| Target | Count | IDs |
|---|---|---|
| product-owner | 9 | 001, 002, 003, 005, 007, 008, 010, 012, 013 |
| architect | 2 | 006, 011 |
| architect + product-owner | 1 | 004 |
| orchestrator | 1 | 009 |
| resolved by another | 1 | 015 |
| no action / pending intent | 1 | 014 |

## §4: Verdict

**FINDINGS** — 0 CRITICAL / 6 HIGH / 6 MEDIUM / 3 LOW = 15 total

Convergence trend: Pass 1 = 30 findings; Pass 2 = 15 findings. **Trend favorable.** No CRITICAL findings — Pass 1's 4 CRITICALs all resolved.

Two systemic issues remain: count drift (NFR catalog 4-way; DTU 47/48; holdouts mis-anchored), and `extract_error_message` chain consistency.

## §5: Suggested Follow-ups for Pass 3

1. Re-audit every holdout's BC ref against BC-INDEX semantic content
2. Re-verify extract_error_message chain against src/api/client.rs:440-490; propagate one canonical version
3. Reconcile NFR-S-E severity across 3 docs
4. Re-count NFR catalog table physically; propagate to all 4 totals
5. Verify NFR-R-NEW-1 — add or rename

Phase 1d adversary Pass 2 complete.
