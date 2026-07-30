---
document_type: adversarial-review-index
level: ops
version: "1.1"
status: in-review
producer: adversary
timestamp: 2026-07-30T20:28:01Z
phase: "5"
pass: 2
inputs: [.factory/stories/S-626-1.md, .github/workflows/ci.yml, src/cli/board.rs, src/cli/issue/list.rs, src/cli/auth/keychain.rs]
traces_to: .factory/stories/S-626-1.md
total_findings: 20
severity_distribution: { CRIT: 0, HIGH: 0, MED: 8, LOW: 7, INFO: 5 }
story: S-626-1
cycle: cycle-001
feature_head: 20d533e45e42eaf08b4f2d172fe8b86a8490fb44
pr: 667
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute)
convergence: 0 of 3
---

# Adversarial Review Index — S-626-1 (SOH-DX-1) Passes 1 + 2

## Pass 1 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P1-MEDIUM-001 | MEDIUM | REFINEMENT · in-delta | CLAUDE.md gotcha inverts rustup precedence order | FIXED on 20d533e4 | Resolved pre-merge |
| ADV-P1-MEDIUM-002 | MEDIUM | REFINEMENT · in-delta | CLAUDE.md gotcha and CHANGELOG assert pre-fix history that never happened | FIXED on 20d533e4 | Resolved pre-merge |
| ADV-P1-MEDIUM-003 | MEDIUM | GAP · in-delta | msrv gate resolves deps at run time instead of validating committed lock | FIXED on 20d533e4 | --locked added; verified run 30573809646 |
| ADV-P1-MEDIUM-004 | MEDIUM | GAP · in-delta | msrv job produces no evidence of which compiler actually ran | ROUTED | Routed to new guard story (S-641-1) |
| ADV-P1-MEDIUM-005 | MEDIUM | GAP · in-delta | MSRV floor asserted at 8+ string sites with no drift guard | ROUTED | Routed to new guard story (S-641-1) |
| ADV-P1-LOW-001 | LOW | REFINEMENT · in-delta | F3 half-remediated: Cargo.toml still cites internal .factory story ID | FIXED on 20d533e4 | Resolved pre-merge |
| ADV-P1-LOW-002 | LOW | GAP · in-delta | No in-code marker at three rewrite sites explaining why not let-chains | FIXED on 20d533e4 | Resolved pre-merge |
| ADV-P1-LOW-003 | LOW | GAP · in-delta | =7.2.1 pin has no dependabot ignore entry | ROUTED | Routed to new guard story (S-641-1) |
| ADV-P1-LOW-004 | LOW | REFINEMENT · in-delta | AC-9 table contradicts story narrative and implementation | FIXED in story v1.4 | Routed to story-metadata correction; resolved |
| ADV-P1-LOW-005 | LOW | REFINEMENT · in-delta | Version-form citation in msrv scope comment will drift | FIXED on 20d533e4 | Resolved pre-merge (with ADV-P1-INFO-001) |
| ADV-P1-INFO-001 | INFO | — | msrv scope comment says --all-targets pulls in benches (crate has none) | FIXED on 20d533e4 | Resolved pre-merge (with ADV-P1-LOW-005) |
| ADV-P1-INFO-002 | INFO | — | --all-features retained for explicitness when no [features] table exists | OPEN | Accepted informational; no fix action |
| ADV-P1-INFO-003 | INFO | — | Mutation testing check gave zero signal on this PR | OPEN | Pre-existing scope exclusion; informational only |

## Pass 1 Process Gap

| ID | Description | Status |
|----|-------------|--------|
| PG-ADV-DISPATCH-001 | Adversary dispatch told to "return as chat text" — not visible to orchestrator; recommend "return via SendMessage". Genuine upstream item for drbothen/vsdd-factory. | FIXED — pass 2 delivered via SendMessage on first attempt; confirmed PG-ADV-DISPATCH-001 was sole cause |

## Pass 1 Summary

- **Verdict:** NOT CLEAN — 3 in-delta GAPs present at capture time
- **Post-capture routing:** 6 fixed on 20d533e4; 4 routed to guard story (S-641-1); 1 routed to story-metadata correction (resolved in v1.4)
- **Step 4.5 window:** RESET — in-delta GAPs require fresh confirming pass
- **Detail artifact:** `s-626-1-adversary-pass-1.md`

---

## Pass 2 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P2-MEDIUM-001 | MEDIUM | GAP · in-delta (spec artifact) | Story's literal pin syntax is caret range; would reintroduce the bug | FIXED in story v1.5 | All 7 occurrences → =7.2.1; EC-10 extended |
| ADV-P2-MEDIUM-002 | MEDIUM | GAP · in-delta · Partial-Fix Regression | Fixing ADV-P1-LOW-001 stripped a citation AC-8 still mandates | FIXED in story v1.5 | AC-8 requirement inverted — research path must NOT appear |
| ADV-P2-MEDIUM-003 | MEDIUM | GAP · pre-existing + newly aggravated · [process-gap] | Three workflow comments assert an unvalidated mechanism | ROUTED to S-641-1 | Keep steps; comment rewrite deferred; AC-5 extended for release.yml fourth site |
| ADV-P2-LOW-001 | LOW | REFINEMENT · in-delta | Pinned action makes `toolchain` hard-required; gotcha doesn't capture this | FIXED in 15597e84 | CLAUDE.md clause added on fail-fast behavior |
| ADV-P2-LOW-002 | LOW | GAP · in-delta | `tests/` modified despite MANDATORY "MUST NOT change: tests/" | FIXED in story v1.5 | Prohibition amended; tests/team_column_parity.rs authorised by AC-9 |
| ADV-P2-INFO-001 | INFO | — | msrv job rust-cache key derived under stable, not 1.85.0 | OPEN | Sharpens ADV-P1-MEDIUM-004; routed to S-641-1 |
| ADV-P2-INFO-002 | INFO | — | msrv scope comment omits inline #[cfg(test)] modules | FIXED in 15597e84 | ci.yml scope comment updated |

## Pass 2 Process Gap

| ID | Description | Status |
|----|-------------|--------|
| ADV-P2-BRIEFING-CORRECTION | Orchestrator dispatch stated `target_module: .github/workflows/ci.yml`; actual value at factory-artifacts HEAD is `target_module: src/cli/`. C-LOW-001 ledger entry corrected in STATE.md and story v1.5. | FIXED — corrected in this burst |

## Pass 2 Summary

- **Verdict:** NOT CLEAN — 3 MEDIUM GAPs (all spec-artifact; zero code changes required)
- **Post-capture routing:** M-001/M-002/L-002 fixed in story v1.5; L-001+I-002 fixed in commit 15597e84 (pushed to #667); M-003/I-001 routed to S-641-1
- **Convergence:** 0 of 3 — passes 1 and 2 both NOT CLEAN; pass 3 required
- **Note:** Pass 1 found code defects; pass 2 found only spec-artifact defects (downward trend)
- **Detail artifact:** `s-626-1-adversary-pass-2.md`

## Dependency Graph

```text
ADV-P1-MEDIUM-003 --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P1-MEDIUM-004 --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P1-LOW-003    --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P2-MEDIUM-003 --routed--> S-641-1 (same guard story as ADV-P1-M004/M005)
ADV-P2-INFO-001   --sharpens--> ADV-P1-MEDIUM-004
[All other findings are independent]
```

## Convergence Trajectory

| Pass | Verdict | MEDIUM | LOW | INFO | [process-gap] | Window |
|------|---------|--------|-----|------|----------------|--------|
| 1 | NOT CLEAN | 5 (3 GAP, 2 REF) | 5 (3 GAP, 2 REF) | 3 | 1 | RESET |
| 2 | NOT CLEAN | 3 (3 GAP) | 2 (1 GAP, 1 REF) | 2 | 2 | NOT CLEAN — pass 3 required |

**Overall convergence: 0 of 3 (window NOT CLEAN)**
