---
document_type: adversarial-review-index
level: ops
version: "1.2"
status: in-review
producer: adversary
timestamp: 2026-07-30T21:15:53Z
phase: "5"
pass: 3
inputs: [.factory/stories/S-626-1.md, .github/workflows/ci.yml, src/cli/board.rs, src/cli/issue/list.rs, src/cli/auth/keychain.rs]
traces_to: .factory/stories/S-626-1.md
total_findings: 28
severity_distribution: { CRIT: 0, HIGH: 0, MED: 11, LOW: 10, INFO: 7 }
story: S-626-1
cycle: cycle-001
feature_head: 15597e84b0f5e3994c5620edbcf1caf83766d2b7
pr: 667
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute)
convergence: 0 of 3
---

# Adversarial Review Index — S-626-1 (SOH-DX-1) Passes 1 + 2 + 3

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

---

## Pass 3 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P3-MEDIUM-001 | MEDIUM | GAP · in-delta | Documented root-cause mechanism is factually false in CLAUDE.md and CHANGELOG.md | FIXED on 64cdb59b | Gotcha title+body+CHANGELOG.md ### Fixed corrected; SHA-swap load-bearing note added |
| ADV-P3-MEDIUM-002 | MEDIUM | GAP · in-delta · Partial-Fix Regression · [process-gap] | M-003 F4 assessment reached right decision from false premise | FIXED in story v1.6 | F4 assessment corrected: root cause confirmed, comments correct, S-641-1 re-scoped |
| ADV-P3-MEDIUM-003 | MEDIUM | GAP · in-delta | Defect 1 mis-framed; real defect larger (version-branch wrong-toolchain across 6 jobs) | FIXED in story v1.6 | Defect 1 expanded; load-bearing SHA-swap consequence documented; blast-radius bounded |
| ADV-P3-LOW-004 | LOW | REFINEMENT · in-delta · Partial-Fix Regression | AC-5 v1.5 table row for release.yml asserts E0463 comment that does not exist | FIXED in story v1.6 | Row corrected to "no comment; bare step name only"; line refs ~:43-45 |
| ADV-P3-LOW-005 | LOW | REFINEMENT · in-delta · Partial-Fix Regression | tests/team_column_parity.rs marked CREATE; it is a MODIFY (487 lines pre-PR) | FIXED in story v1.6 | CREATE → MODIFY |
| ADV-P3-LOW-006 | LOW | REFINEMENT · in-delta | CHANGELOG comfy-table entry omits mandated user-impact line | FIXED on 64cdb59b | User-impact line added to ### Changed comfy-table entry |
| ADV-P3-INFO-007 | INFO | — | CLAUDE.md precedence list correct but omits proximity-to-cwd exception | FIXED on 64cdb59b | Proximity-to-cwd clause added; taken by orchestrator |
| ADV-P3-INFO-008 | INFO | — | Pre-existing: fmt/clippy/test/deny install no toolchain; bounds what pin protects | OPEN | Out of delta; context only |

## Pass 3 Preflight Note

**The orchestrator's embedded `feature-HEAD-SHA` was fabricated.** The dispatch supplied `15597e8455ba4b4b5e5c7f4a0e0e0b3e8c9d1f2a`; the actual HEAD is `15597e84b0f5e3994c5620edbcf1caf83766d2b7`. Only the 8-character prefix matched — the remaining 32 hex characters were invented. The adversary detected this via its own `git rev-parse HEAD` check. The Worktree-Identity Preflight worked exactly as designed. Also: the adversary's pass-2 count of 4 `"7.2.1"` occurrences was low; the orchestrator's count of 7 was correct.

## Pass 3 Process Gap

| ID | Description | Status |
|----|-------------|--------|
| PG-ADV-SHA-FABRICATION | Orchestrator dispatch supplied fabricated 40-char SHA (only 8-char prefix correct). Adversary detected via own git rev-parse. Worktree-Identity Preflight effective. | DETECTED + RECORDED — orchestrator-discipline datapoint |
| PG-ADV-P2-001-FALSE-PREMISE | P71-001 classified old SHA as "per-version-branch commit (expected behavior)" and stopped. Never asked: what does a version branch's action.yml actually do? This unasked question is the common root of MEDIUM-001, -002, and -003. Provenance verification that classifies a pin without reading the pinned artifact is incomplete. | RECORDED — codified in story v1.6 Previous Story Intelligence |

## Pass 3 Summary

- **Verdict:** NOT CLEAN — root-cause mechanism falsified; 3 MEDIUM GAPs
- **Post-capture routing:** MEDIUM-001/LOW-006/INFO-007 fixed on 64cdb59b; story v1.5→v1.6 (MEDIUM-001/002/003/LOW-004/005); S-641-1 v0.2→v0.3 re-scoped
- **Convergence:** 0 of 3 — three passes, three NOT CLEAN; each distinct layer (code / spec-artifact / causal-model)
- **Orchestrator-attributable findings:** 3 of 8 (MEDIUM-002 + LOW-004 + LOW-005 introduced by orchestrator's own v1.5 fix instructions); fabricated HEAD SHA in dispatch
- **Detail artifact:** `s-626-1-adversary-pass-3.md`

---

## Dependency Graph

```text
ADV-P1-MEDIUM-003 --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P1-MEDIUM-004 --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P1-LOW-003    --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P2-MEDIUM-003 --routed--> S-641-1 (same guard story as ADV-P1-M004/M005)
ADV-P2-INFO-001   --sharpens--> ADV-P1-MEDIUM-004
ADV-P3-MEDIUM-001 --supersedes--> ADV-P1-MEDIUM-002/ADV-P2-MEDIUM-003 root-cause framing
ADV-P3-MEDIUM-002 --informs--> S-641-1 (re-scoped: comments correct, only present-tense stale)
ADV-P3-MEDIUM-003 --sharpens--> ADV-P1-MEDIUM-002/ADV-P2-MEDIUM-003 (version-branch finding)
[All other findings are independent]
```

## Convergence Trajectory

| Pass | Verdict | MEDIUM | LOW | INFO | [process-gap] | Window |
|------|---------|--------|-----|------|----------------|--------|
| 1 | NOT CLEAN | 5 (3 GAP, 2 REF) | 5 (3 GAP, 2 REF) | 3 | 1 | RESET |
| 2 | NOT CLEAN | 3 (3 GAP) | 2 (1 GAP, 1 REF) | 2 | 2 | NOT CLEAN — pass 3 required |
| 3 | NOT CLEAN | 3 (3 GAP) | 3 (3 REF) | 2 | 2 | NOT CLEAN — 3 passes, 3 layers; round-3 dispositions committed |

**Overall convergence: 0 of 3 (window NOT CLEAN)**
