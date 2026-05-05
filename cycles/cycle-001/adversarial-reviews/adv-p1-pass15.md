# Adversarial Review — Phase 1d Pass 15

**Convergence trajectory**: 30 → 15 → 9 → 5 → 10 → 5 → 4 → 3 → 4 → 0 → 2 → 0 → 3 → 0 → 2
**Counter regression**: 1/3 → 0/3

## §1: Findings — 2 (1 HIGH / 1 MEDIUM)

### HIGH

**ADV-P15-001 — bc-3-issue-write.md body BC count contradicts frontmatter + CANONICAL-COUNTS**
- bc-3-issue-write.md:483 says "Total BCs in this file: 40 (representative; BC-INDEX.md carries all 77)"
- Frontmatter total_bcs: 77; definitional_count: 48
- CANONICAL-COUNTS confirms: 48 individually-bodied
- Action: replace "40" with "48 individually-bodied BCs (cumulative 77 incl. range-collapsed)"

### MEDIUM

**ADV-P15-002 — bc-3-issue-write.md subdomain enumeration mismatch**
- Body line 16-17 claims "7 subdomains" but lists 8 (Assign, Move/Transition, Create, Edit, Open, Comment, Links, Remote links)
- "3.4-bug-fix" is not a valid subdomain ID; section header is "### 3.4 Edit and Open" (combined)
- Action: pick one — combine Edit + Open under 3.4 (7 subdomains) OR split (8 subdomains)

## §2: Routing
product-owner: ADV-P15-001, ADV-P15-002

## §3: Verdict — FINDINGS (2)

Counter regress 1/3 → 0/3. Pass 14's clean didn't audit body subdomain text and in-body count assertions.

Phase 1d adversary Pass 15 complete.
