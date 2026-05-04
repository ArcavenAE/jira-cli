# Adversarial Review — Phase 1d Pass 3

**Reviewer**: adversary (fresh-context)
**Date**: 2026-05-04
**Scope**: full Phase 1 spec package post Pass 2 fixes
**Convergence trajectory**: Pass 1 = 30 → Pass 2 = 15 → Pass 3 = 9

## §1: Findings — 9 total (1 CRITICAL / 3 HIGH / 3 MEDIUM / 2 LOW)

### CRITICAL

**ADV-P3-001 — BC-6.3.001 site count contradicts (11 vs 12+ vs 14) [content-defect]**
Narrative says "11 hot-path read sites" but table beneath enumerates 14 entries. ADR-0007 says "12+ sites"; risk register R-C1 says "12+ read sites"; NFR-R-D says "12+"; BC-INDEX says "14 sites".
- Action: pick canonical (14, since the table is most concrete) and propagate to all 4 sibling docs.

### HIGH

**ADV-P3-002 — ADR-0007 self-contradicts on fallback [content-defect]**
§Context line 21 says "falling back to global.fields for migration compatibility"; §Decision/§Consequences say "NO fallback". Context paragraph stale.
- Action: strike "falling back" clause from §Context, or move to "rejected sub-option".

**ADV-P3-003 — extract_error_message chain still diverges [content-defect]**
architecture/cross-cutting.md and prd/error-taxonomy.md describe incompatible 7-level chains:
- Priority 1: arch=None+status-derived; PRD=literal "<empty response body>"
- Priority 4: arch=`errors.field.messages[]`; PRD=does not exist
- Priority 6: arch=`errorDescription`; PRD=`errorMessage`
PRD line 75 explicitly refutes arch's priorities 4 and 6. Pass 2's fix did not propagate to arch.
- Action: replace arch §1 chain with corrected PRD version verbatim, or replace with "see PRD error-taxonomy.md §2 — canonical".

**ADV-P3-004 — NFR catalog count drift across docs [content-defect]**
PRD README: "44 NFR (1C/4H/16M/22L)". NFR catalog: "41 (1C/5H/15M/20L)". BC-INDEX: "45 NFR items". Three different totals.
- Action: update PRD README + BC-INDEX to "41 (1C/5H/15M/20L)" matching catalog.

### MEDIUM

**ADV-P3-005 — Edge-case-catalog mis-anchors (3+) [content-defect]**
- EC-AUTH-002 cites BC-1.2.015 (auth refresh --help); should be BC-1.1.006 (auth remove active)
- EC-AUTH-003 cites BC-6.1.003 (file-only baseline); should be BC-6.1.002 (idempotency)
- EC-AUTH-004 cites BC-6.1.002 (idempotency); should be BC-1.1.012 (malformed TOML)
- Action: re-resolve all 50+ EC-* anchors against BC-INDEX.

**ADV-P3-006 — Total BC count 541 vs 542 [content-defect]**
PRD README: "541". BC-INDEX frontmatter: "542". BC-INDEX coverage stats: "541 + 1 NEW = 542".
- Action: update PRD README to 542.

**ADV-P3-007 — Risk register R-H6 (cargo-deny supply chain) is orphan [content-defect]**
R-H6 has no NFR ID and no BC anchor. NFR catalog never mentions it. While NFR catalog has 5 HIGH NFRs, risk register has 7 HIGH risks.
- Action: add NFR row "NFR-S-Supply-Chain" with BC-INDEX anchor, OR downgrade R-H6, OR fold into existing NFR.

### LOW

**ADV-P3-008 — H-022 missing BC-1.6.045 anchor [content-defect]**
- Action: append BC-1.6.045 to H-022 BC refs.

**ADV-P3-009 — NFR-R-NEW-1 severity may be MEDIUM [unstated-assumption]**
LOW vs MEDIUM mapping subjective. Optional re-evaluation.

## §2: Strengths

1. MUST-FIX BC anchors are precise and rigorously cross-linked.
2. State machines (SM-1..SM-5) have source-pinned line numbers.
3. Holdout count is internally consistent (48).
4. Profile-fence soft-convention BC-6.2.015 is testable with grep pattern.

## §3: Routing

product-owner: ADV-P3-001 (CRITICAL), ADV-P3-004 (HIGH), ADV-P3-005 (MEDIUM), ADV-P3-006 (MEDIUM), ADV-P3-007 (MEDIUM, shared), ADV-P3-008 (LOW), ADV-P3-009 (LOW).
architect: ADV-P3-002 (HIGH), ADV-P3-003 (HIGH), ADV-P3-007 (shared).

## §4: Verdict

FINDINGS — 1 CRITICAL / 3 HIGH / 3 MEDIUM / 2 LOW = 9. Convergence trajectory linear decay (30 → 15 → 9). Pass 4 needed; expect ≤4 findings.

## §5: Follow-ups

1. Codify "count consistency" lint for spec stack
2. Single-source extract_error_message table in PRD; arch links via reference
3. Re-resolve all EC-* anchors programmatically against BC-INDEX

Phase 1d adversary Pass 3 complete.
