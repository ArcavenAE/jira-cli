# Adversarial Review — Phase 1d Pass 7

**Convergence trajectory**: 30 → 15 → 9 → 5 → 10 → 5 → 4

## §1: Findings — 4 (0 CRITICAL / 0 HIGH / 3 MEDIUM / 1 LOW)

### MEDIUM

**ADV-P7-001 — BC total count off-by-one (541 actual vs 542 claimed)**
PRD README:51 + BC-INDEX:4 claim 542. Per-section frontmatter sum: 57+91+77+32+35+39+80+130 = 541.
- Action: recount and reconcile. Either update claim to 541 OR identify missing BC.

**ADV-P7-002 — NFR-S-D and NFR-O-K duplicate concern**
- nfr-catalog line 80: NFR-S-D — "Profile name validation regex doesn't distinguish length (>64) from charset"
- nfr-catalog line 110: NFR-O-K — "Profile name validation error message doesn't distinguish length (>64 chars) from charset"
- Same site (src/config.rs:113-140), same routing (DOCUMENT-AS-IS), same fix (2 LOC).
- Action: merge to single ID; recount totals.

**ADV-P7-003 — cross-cutting.md definitional_count mismatch**
cross-cutting.md frontmatter `definitional_count: 63`. BC-INDEX line 15 says `64 individually-bodied`. BC-INDEX preamble says body files win.
- Action: grep `^#### BC-` count to determine canonical; align both.

### LOW

**ADV-P7-004 — MatchResult::ExactMultiple description misleading in arch**
arch cross-cutting.md:147 "used for disambiguation". Source partial_match.rs:6-7 + PRD error-taxonomy.md:130: "first wins, no disambiguation".
- Action: rewrite arch line to match source/PRD.

## §2: Strengths

1. MUST-FIX/14-sites consistency strong (PRD README, nfr-catalog NFR-R-D, risk-register R-C1, BC-6.3.001 body)
2. extract_error_message canonical-source discipline holds
3. Holdout-to-BC anchor integrity solid (5 spot-checks all resolve)

## §3: Routing

product-owner: ADV-P7-001, P7-002, P7-003
architect: ADV-P7-004

## §4: Verdict — FINDINGS (4)

Counter does not advance. Trajectory continues to refine but small-blast-radius drifts persist.

## §5: Follow-ups

After fixes, re-verify 542 → 541 (or +1) ripple to README + BC-INDEX. After NFR merge, recount severity totals.

Phase 1d adversary Pass 7 complete.

---

## §6: Resolution (applied at Pass 7 fix burst)

**ADV-P7-001 — CLOSED (no change needed)**
Independent recount: BC-INDEX table sums 541 from sections; plus BC-X.4.009 (one new BC) explicitly called out at BC-INDEX line 648 = 542. The 542 claim is arithmetically correct. Finding was a false alarm — adversary miscounted by ignoring the +1 new BC note.

**ADV-P7-002 — FIXED**
NFR-O-K (Observability/LOW) merged into NFR-S-D (Security/LOW). NFR-O-K row removed from dimension body table and Summary Table. Cross-reference note added to NFR-S-D. Routing summary DOCUMENT-AS-IS count updated 14→13. Total NFR count 42→41; severity breakdown 1C/6H/15M/19L=41.

**ADV-P7-003 — FIXED**
Actual `#### BC-` heading count in cross-cutting.md = 64. Frontmatter `definitional_count` updated 63→64. BC-INDEX already showed 64 individually-bodied — now in sync.

**ADV-P7-004 — FIXED**
Architecture cross-cutting.md line 147 rewritten: "multiple case-variant matches; carries the first matching candidate (no disambiguation triggered; first wins)."
