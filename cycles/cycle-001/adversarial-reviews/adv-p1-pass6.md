# Adversarial Review — Phase 1d Pass 6

**Convergence trajectory**: 30 → 15 → 9 → 5 → 10 → 5

## §1: Findings — 5 (0 CRITICAL / 1 HIGH / 3 MEDIUM / 1 LOW)

### HIGH

**ADV-P6-001 — MatchResult variants fabricated in arch cross-cutting.md**
- arch cross-cutting.md:156-160 lists `Exact, Unique, Ambiguous, None`
- Source partial_match.rs:1-13 defines `Exact, ExactMultiple, Ambiguous, None`
- PRD error-taxonomy.md:127-132 correct
- Architecture invented `Unique` variant; omitted `ExactMultiple`
- Action: replace block with correct enum

### MEDIUM

**ADV-P6-002 — cross-cutting.md self-contradicts on duplication**
Line 36 claims "Architecture does not duplicate the table"; lines 38-46 literally duplicate. Either delete table or remove disclaimer.

**ADV-P6-003 — NFR-R-NEW-1/2 misplaced under ### MEDIUM section but tagged LOW**
nfr-catalog.md:43 ### MEDIUM section; lines 49-50 NFR-R-NEW-1/2 with severity LOW.

**ADV-P6-004 — R-H3 (HIGH risk) maps to NFR-S-C (MEDIUM)**
risk-register.md:26 R-H3 in HIGH section maps to NFR-S-C; nfr-catalog.md:75 NFR-S-C is MEDIUM. Either demote R-H3 or promote NFR-S-C with rationale.

### LOW

**ADV-P6-005 — arch README arithmetic wrong**
README:24 "12 R1-NEW + 14 broad-pass + 1 reclassified" = 27 only if conflated with Pass-2 addition. Risk register says "11 R1-NEW + 14 broad-pass + 1 reclassified-CRITICAL + 1 Pass-2 addition". README's R1-NEW count (12) is wrong.

## §2: Strengths

1. Pass-5 critical fixes propagated cleanly (14 sites everywhere, EC-OUT-005 literal string)
2. bc-6 frontmatter ↔ body alignment good
3. NFR-INDEX arithmetic 1+6+15+20=42 reconciles

## §3: Routing

architect: ADV-P6-001, ADV-P6-002, ADV-P6-005
architect + product-owner: ADV-P6-004
product-owner: ADV-P6-003

## §4: Verdict — FINDINGS (5)

Convergence counter does NOT advance. Trajectory regresses then partially recovers (10 → 5).

## §5: Follow-ups [process-gap]

Severity-cross-reference axis: All risk-register entries should assert risk severity ≤ underlying NFR severity OR justified promotion note.

Phase 1d adversary Pass 6 complete.
