---
document_type: adversarial-review-index
level: ops
version: "1.0"
status: in-review
producer: adversary
timestamp: 2026-07-30T19:17:32Z
phase: "5"
pass: 1
inputs: [.factory/stories/S-626-1.md, .github/workflows/ci.yml, src/cli/board.rs, src/cli/issue/list.rs, src/cli/auth/keychain.rs]
traces_to: .factory/stories/S-626-1.md
total_findings: 13
severity_distribution: { CRIT: 0, HIGH: 0, MED: 5, LOW: 5, INFO: 3 }
story: S-626-1
cycle: cycle-001
feature_head: 148a9489f3d0f213ed402caf4522ce04ea5ffad3
pr: 667
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute) — first adversary application in this bundle
---

# Adversarial Review Index — S-626-1 (SOH-DX-1) Pass 1

## Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P1-MEDIUM-001 | MEDIUM | REFINEMENT · in-delta | CLAUDE.md gotcha inverts rustup precedence order | FIXED on 20d533e4 | Resolved pre-merge |
| ADV-P1-MEDIUM-002 | MEDIUM | REFINEMENT · in-delta | CLAUDE.md gotcha and CHANGELOG assert pre-fix history that never happened | FIXED on 20d533e4 | Resolved pre-merge |
| ADV-P1-MEDIUM-003 | MEDIUM | GAP · in-delta | msrv gate resolves deps at run time instead of validating committed lock | ROUTED | Routed to new guard story |
| ADV-P1-MEDIUM-004 | MEDIUM | GAP · in-delta | msrv job produces no evidence of which compiler actually ran | ROUTED | Routed to new guard story |
| ADV-P1-MEDIUM-005 | MEDIUM | GAP · in-delta | MSRV floor asserted at 8+ string sites with no drift guard | ROUTED | Routed to new guard story |
| ADV-P1-LOW-001 | LOW | REFINEMENT · in-delta | F3 half-remediated: Cargo.toml still cites internal .factory story ID | FIXED on 20d533e4 | Resolved pre-merge |
| ADV-P1-LOW-002 | LOW | GAP · in-delta | No in-code marker at three rewrite sites explaining why not let-chains | FIXED on 20d533e4 | Resolved pre-merge |
| ADV-P1-LOW-003 | LOW | GAP · in-delta | =7.2.1 pin has no dependabot ignore entry | ROUTED | Routed to new guard story |
| ADV-P1-LOW-004 | LOW | REFINEMENT · in-delta | AC-9 table contradicts story narrative and implementation | ROUTED | Routed to story-metadata correction |
| ADV-P1-LOW-005 | LOW | REFINEMENT · in-delta | Version-form citation in msrv scope comment will drift | FIXED on 20d533e4 | Resolved pre-merge (with ADV-P1-INFO-001) |
| ADV-P1-INFO-001 | INFO | — | msrv scope comment says --all-targets pulls in benches (crate has none) | FIXED on 20d533e4 | Resolved pre-merge (with ADV-P1-LOW-005) |
| ADV-P1-INFO-002 | INFO | — | --all-features retained for explicitness when no [features] table exists | OPEN | Accepted informational; no fix action |
| ADV-P1-INFO-003 | INFO | — | Mutation testing check gave zero signal on this PR | OPEN | Pre-existing scope exclusion; informational only |

## Process Gap

| ID | Description | Status |
|----|-------------|--------|
| PG-ADV-DISPATCH-001 | Adversary dispatch told to "return as chat text" — not visible to orchestrator; recommend "return via SendMessage". Genuine upstream item for drbothen/vsdd-factory. | OPEN — route upstream |

## Dependency Graph

```text
ADV-P1-MEDIUM-003 --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P1-MEDIUM-004 --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P1-LOW-003    --informs--> ADV-P1-MEDIUM-005 (guard story scope)
[All other findings are independent]
```

## Category Groups

| Category | Finding IDs | Can Triage in Parallel? |
|----------|------------|------------------------|
| doc-accuracy | ADV-P1-MEDIUM-001, ADV-P1-MEDIUM-002, ADV-P1-LOW-001, ADV-P1-LOW-005, ADV-P1-INFO-001 | Yes — all fixed on 20d533e4 |
| verification-gap | ADV-P1-MEDIUM-003, ADV-P1-MEDIUM-004 | Yes — both routed to guard story |
| drift-guard-absent | ADV-P1-MEDIUM-005, ADV-P1-LOW-003 | Yes after MEDIUM-003/004 resolved |
| in-code-marker | ADV-P1-LOW-002 | Yes — fixed on 20d533e4 |
| spec-metadata | ADV-P1-LOW-004 | Yes — independent |
| informational | ADV-P1-INFO-002, ADV-P1-INFO-003 | Yes — no action items |

## Pass Summary

- **Verdict:** NOT CLEAN — 3 in-delta GAPs present at capture time
- **Post-capture routing:** 6 fixed on 20d533e4; 4 routed to new guard story; 1 routed to story-metadata correction
- **Step 4.5 window:** RESET — in-delta GAPs require fresh confirming pass
- **Adversary statement:** "I would not treat pass 1 as converged."
- **Detail artifact:** `s-626-1-adversary-pass-1.md`
