---
document_type: adversarial-review-index
level: ops
version: "1.4"
status: in-review
producer: adversary
timestamp: 2026-07-31T08:00:00Z
phase: "5"
pass: 8
inputs: [.factory/stories/S-626-1.md, .github/workflows/ci.yml, CLAUDE.md, src/cli/board.rs, src/cli/issue/list.rs, src/cli/auth/keychain.rs]
traces_to: .factory/stories/S-626-1.md
total_findings: 64
severity_distribution: { CRIT: 0, HIGH: 7, MED: 19, LOW: 26, INFO: 12 }
story: S-626-1
cycle: cycle-001
feature_head: 64e2a4bcde44ec20bc1f64d80eb402ca8aebc406
pr: 667
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute)
convergence: 0 of 3 (Step 4.5 window — DEC-199 GRIND to 3/3 CLEAN)
void_spawns: 3 (passes 6/7/8 first-attempt background subagents; re-dispatched synchronously)
---

# Adversarial Review Index — S-626-1 (SOH-DX-1) Passes 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8

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

## Pass 4 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P4-LOW-001 | LOW | GAP · in-delta | Three in-tree comments cite a CLAUDE.md gotcha that does not contain the cited constraint; no convention forbids let-chains | FIXED on 4223ea09 | `No let-chains` entry added to CLAUDE.md Conventions; three comments re-pointed at it |
| ADV-P4-LOW-002 | LOW | GAP · in-delta | ci.yml scope comment's final warning names an unreachable failure mode | FIXED on 4223ea09 | Warning rewritten to accurate "outside MSRV floor's enforceable scope" framing |
| ADV-P4-LOW-003 | LOW | GAP · spec artifact | Story's Delivery Checklist mandates a CHANGELOG sentence that is false as written; implementation correctly omitted it | ROUTED to .factory/ | Checklist wording amended to be jr-scoped; provenance rule generalised from SHA pins to version pins |
| ADV-P4-LOW-004 | LOW | REFINEMENT · pre-existing pattern touched in-delta | dtolnay pin trailing comments name a toolchain where every other pin names the action version | ROUTED → S-641-1 | S-641-1 already touches those lines |
| ADV-P4-INFO-005 | INFO | [process-gap] | Stated let-chain detection method (`grep '&& let'`) misses the let-first form | ROUTED → S-641-1 | Invariant corrected; S-641-1 AC-2 guard must use complete form set |

## Pass 4 Preflight Note

Tuple verified with no mismatch — `git rev-parse HEAD` → `64cdb59ba04d7547a3708f1bf643ae5bb5ee6e7b`, 11 commits over merge-base `acdad17427a057d1e022669303cb80d5f48449c9`; factory HEAD `d0f334d077c15c8de80417e690f90506d5424ce0`. Every tuple element checked out. (Contrast pass 3, where the orchestrator's embedded SHA was fabricated beyond its 8-char prefix.)

## Pass 4 Process Gap

| ID | Description | Status |
|----|-------------|--------|
| PG-ADV-P4-VERSION-PIN-RULE | Provenance rule (v1.6: "classifying a pin without reading the pinned artifact is incomplete") was codified for SHA pins. ADV-P4-LOW-003 [process-gap] confirms the rule applies identically to version pins. Generalise rule in story rather than logging a second instance. | RECORDED — generalisation routed to .factory/ via LOW-003 disposition |

## Pass 4 Summary

- **Verdict:** NOT CLEAN — 4 LOW + 1 INFO; zero MEDIUM+; zero code defects
- **Post-capture routing:** LOW-001/LOW-002 fixed on 4223ea09 (pushed to #667); LOW-003 routed to .factory/ (checklist + provenance rule); LOW-004/INFO-005 routed to S-641-1
- **Convergence:** 0 of 3 — four passes, four NOT CLEAN; severity ceiling fell MEDIUM → LOW; code defects zero for three rounds
- **Orchestrator-attributable findings:** 0 of 5 (no fix-round regressions introduced by orchestrator in pass 4)
- **Detail artifact:** `s-626-1-adversary-pass-4.md`

---

## Pass 5 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P5-LOW-001 | LOW | RESIDUE · in-delta (introduced by fix-round commit `4223ea09`) | CLAUDE.md `No let-chains` citation pointer resolves to wrong gotcha | FIXED on 64e2a4bc | Pointer corrected to `ci.yml msrv scope comment`; scope widened to include `tests/` |
| ADV-P5-LOW-002 | LOW | GAP · in-delta (introduced by fix-round commit `4223ea09`) | `No let-chains` convention has no expiry clause; will deadlock with `No lint suppression` after MSRV raise | FIXED on 64e2a4bc | Expiry clause added: "Temporary — delete when MSRV raised to ≥1.88" |
| ADV-P5-INFO-003 | INFO | RESIDUE · in-delta (introduced by fix-round commit `4223ea09`) | ci.yml scope warning overstates impossibility with "cannot be closed until…" | FIXED on 64e2a4bc | Modal softened to cost/benefit framing; downgrade-pin acknowledged as unevaluated option |

## Pass 5 Preflight Note

*Not reconstructable.* This artifact is a post-hoc reconstruction (see artifact disclosure in `s-626-1-adversary-pass-5.md`). Pass-5 ran against HEAD `4223ea091ad2c295a086269357b2442399d3b3e8`. The adversary's original preflight checks are not available in the surviving record.

## Pass 5 Summary

- **Verdict:** NOT CLEAN — 2 LOW + 1 INFO; zero MEDIUM+; zero code defects; **3/3 residue (all-residue / self-feeding signature)**
- **Post-capture routing:** All three fixed in commit `64e2a4bc` (pushed to #667); no spec-artifact or story changes required
- **Convergence:** 0 of 3 — five passes, five NOT CLEAN; severity ceiling LOW (two consecutive); zero code defects four consecutive passes; pass-5 all-residue is a possible convergence breakpoint
- **Orchestrator-attributable findings:** 3 of 3 (all three introduced by orchestrator's own `4223ea09` fix-round commit)
- **Reconstruction disclosure:** POST-HOC artifact — no verbatim adversary transcript; reconstructed from STATE.md + `git show 64e2a4bc`
- **Detail artifact:** `s-626-1-adversary-pass-5.md`

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
ADV-P4-LOW-003    --generalises--> ADV-P3-MEDIUM-002/[process-gap] (version pins same as SHA pins)
ADV-P4-LOW-004    --routed--> S-641-1 (comment convention)
ADV-P4-INFO-005   --informs--> S-641-1 AC-2 (complete let-chain detection form set)
[All other findings are independent]
```

## Convergence Trajectory

| Pass | Verdict | HIGH | MEDIUM | LOW | INFO | [process-gap] | Code Defects | Window |
|------|---------|------|--------|-----|------|----------------|--------------|--------|
| 1 | NOT CLEAN | 0 | 5 (3 GAP, 2 REF) | 5 (3 GAP, 2 REF) | 3 | 1 | YES | RESET |
| 2 | NOT CLEAN | 0 | 3 (3 GAP) | 2 (1 GAP, 1 REF) | 2 | 2 | NO | NOT CLEAN — pass 3 required |
| 3 | NOT CLEAN | 0 | 3 (3 GAP) | 3 (3 REF) | 2 | 2 | NO | NOT CLEAN — 3 passes, 3 layers |
| 4 | NOT CLEAN | 0 | 0 | 4 (3 GAP, 1 REF) | 1 | 2 | NO | NOT CLEAN — severity ceiling fell to LOW |
| 5 | NOT CLEAN | 0 | 0 | 2 (1 GAP, 1 RES) | 1 | 0 | NO | NOT CLEAN — **3/3 all-residue (RECONSTRUCTED)** |
| VOID-6A/7A/8A | N/A — NOT COUNTED | — | — | — | — | — | — | VOID — not window-eligible |
| 6 | NOT CLEAN | 3 | 3 | 2 | 2 | 2 | NO | RESET — HIGH findings after fix round; step 4.5 window 0/3 |
| 7 | NOT CLEAN | 3 | 4 | 5 | 1 | 2 | NO | 0/3 — F-03 UNIQUE: stale demo FALSE-GREEN GENERATOR confirmed and fixed |
| 8 | NOT CLEAN | 1 | 1 | 3 | 0 | 1 (obs) | NO | 0/3 — fix round applied 2026-07-31; fresh window required on amended state |

**Overall convergence: 0 of 3 (Step 4.5 — 8 recorded passes + 3 VOID; DEC-199: GRIND to 3/3 CLEAN; DEC-191(d) ceiling = 10; ceiling breach at 11 if 3-pass window starts now — ESCALATION REQUIRED)**

**Findings accumulator (running total):**
- Passes 1–5: 36 total (HIGH: 0, MED: 11, LOW: 16, INFO: 9)
- Pass 6 adds: +10 (HIGH: 3, MED: 3, LOW: 2, INFO: 2)
- Pass 7 adds: +13 (HIGH: 3, MED: 4, LOW: 5, INFO: 1) [F-13 pre-existing; +1 MED]
- Pass 8 adds: +5 (HIGH: 1, MED: 1, LOW: 3, INFO: 0) [observations not counted in totals]
- **Grand total: 64 findings (CRIT: 0, HIGH: 7, MED: 19, LOW: 26, INFO: 12)**

---

## VOID Spawns — Three Background Subagent Dispatches (NOT window-eligible, NOT counted in trajectory)

Three earlier background adversary spawns (intended to be passes 6, 7, and 8) produced no retrievable output and were superseded by re-dispatched synchronous passes. These are recorded here for audit completeness only.

**They are NOT window-eligible and NOT counted in the convergence trajectory.** Counting them would inflate the pass count on a bookkeeping artifact.

**Cause:** Named background subagents in this session spawned but never delivered their final report. `TaskList` returned empty. Only unnamed synchronous dispatches returned output reliably. See NAMED-BACKGROUND-SUBAGENT-REPORT-LOSS drift item.

| Void ID | Intended Pass | Agent Name | Disposition |
|---------|---------------|------------|-------------|
| VOID-6A | 6 (first attempt) | adv-pass6 | Named background; no report delivered; superseded by synchronous re-dispatch |
| VOID-7A | 7 (first attempt) | adv-pass7 | Named background; no report delivered; superseded by synchronous re-dispatch |
| VOID-8A | 8 (first attempt) | adv-pass8 | Named background; no report delivered; superseded by synchronous re-dispatch |

**Additional consequence:** The failed background subagents also caused a DUPLICATE dispatch of the product-owner and demo-recorder agents, resulting in two agents concurrently writing the same demo files. Final state verified coherent (`cargo clean` variant won; no interleaving artifacts).

---

## Pass 6 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P6-HIGH-001 | HIGH | GAP · in-delta | Story anchors zero BCs/VPs while rewriting BC-5.3.001/002 production code | FIXED — S-626-1 v1.8 | bcs: ["BC-5.3.001","BC-5.3.002"]; verification_properties: [] with DEC-195 rationale |
| ADV-P6-HIGH-002 | HIGH | GAP · in-delta | `subsystems: ["SS-11"]` dangling — registry stops at SS-09; 5-story blast radius | FIXED — 5 stories | ["SS-11"] → ["SS-02","SS-09"] across S-626-1, S-627-1, S-640-1, S-641-1, S-576-5 |
| ADV-P6-HIGH-003 | HIGH | PROCESS-GAP · in-delta | MSRV job has no positive-coverage assertion; deleting RUSTUP_TOOLCHAIN exits 0 | ROUTED → S-641-1 | AC-1/AC-2 scope per pass-8 Obs-1 adjudication; DEC-199 routing |
| ADV-P6-MED-001 | MEDIUM | GAP · in-delta | CLAUDE.md:219 asserts GitHub validates hard-required inputs (platform does not enforce) | NOTED | Accepted; consequence benign per pass-8 Obs-2; CLAUDE.md claim inaccuracy noted |
| ADV-P6-MED-002 | MEDIUM | REFINEMENT · in-delta | `# 1.85.0`/`# stable` comments denote toolchain not action version — 7 sites | ROUTED → S-641-1 | Already in S-641-1 LOW-004 |
| ADV-P6-MED-003 | MEDIUM | PROCESS-GAP · in-delta | "No let-chains" unenforced over `#[cfg(test)]` and `tests/` | OPEN | Acknowledged gap in enforcement scope; no compensating control added |
| ADV-P6-LOW-001 | LOW | GAP · spec artifact | AC-9 "mutation-detecting" claim false — files not in examine_globs | FIXED — S-626-1 v1.8 | "mutation-detecting" → "regression-detecting integration coverage" |
| ADV-P6-LOW-002 | LOW | REFINEMENT · spec artifact | BC-5.3.004 Source citation displaced +108 lines; all four BC-5.3.00x in line-number form | FIXED — bc-5 + BC-INDEX | Symbol-form citations (::fn_name) for all four BC-5.3.00x |
| ADV-P6-INFO-001 | INFO | — | rust-cache keys on 1.85.0 under RUSTUP_TOOLCHAIN → cache dilution only, not false-green | OPEN | Accepted informational |
| ADV-P6-INFO-002 | INFO | — | --locked on msrv cargo check undeclared by any AC but correct | OPEN | Noted; no fix action; S-641-1 covers this area |

## Pass 6 Isolation Note

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed.

## Pass 6 Summary

- **Verdict:** NOT CLEAN — 3 HIGH + 3 MEDIUM + 2 LOW + 2 INFO; zero code defects; policy rubric ABSENT (baseline applied)
- **Post-capture routing:** HIGH-001 (BC/VP anchoring), HIGH-002 (SS-11→SS-02+SS-09), LOW-001 (AC-9 wording), LOW-002 (symbol citations) → .factory/ fix round; HIGH-003 → S-641-1; MED-002 → S-641-1 LOW-004
- **Window:** RESET — HIGH-class findings require fresh confirming pass
- **Detail artifact:** `s-626-1-adversary-pass-6.md`

---

## Pass 7 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P7-HIGH-001 | HIGH | GAP · in-delta | SS-11 phantom anchor (same class as P6-HIGH-002) | FIXED — 5 stories | Independently confirmed; same fix applied |
| ADV-P7-HIGH-002 | HIGH | PROCESS-GAP · in-delta | MSRV job no positive-coverage assertion (same class as P6-HIGH-003) | ROUTED → S-641-1 | Independently confirmed; S-641-1 AC-1/AC-2 scope |
| ADV-P7-HIGH-003 | HIGH | GAP · in-delta | **UNIQUE: Demo evidence stale vs delivered HEAD — FALSE-GREEN GENERATOR** | FIXED — demos/ regenerated | AC-009.txt filter matched 0 tests (false-green); INDEX.md Head stale; 5 files regenerated at HEAD 64e2a4bc |
| ADV-P7-MED-001 | MEDIUM | GAP · in-delta | Headline AC-8/AC-9 proof is 0.19s no-op with zero Compiling lines (warm cache) | FIXED — demos/ regenerated | `cargo clean -p jr` + cold recompile added to evidence; `Compiling jr` line confirmed |
| ADV-P7-MED-002 | MEDIUM | GAP · pre-existing exacerbated | INV-READ-009 still prescribes deleted let-chain; directly contradicts CLAUDE.md convention | FIXED — bc-02-issue-read.md | INV-READ-009 restated behaviorally; let-chain prescription removed; MSRV note added |
| ADV-P7-MED-003 | MEDIUM | GAP · in-delta | Empty BC/VP anchors traceability gap (same class as P6-HIGH-001) | FIXED — S-626-1 v1.8 | Independently confirmed; same fix |
| ADV-P7-MED-004 | MEDIUM | PROCESS-GAP · in-delta | No-let-chains unenforced over `#[cfg(test)]`/tests/ (same class as P6-MED-003) | OPEN | Independently confirmed; acknowledged gap |
| ADV-P7-LOW-001 | LOW | GAP · spec artifact | AC-9 mutation claim false (same class as P6-LOW-001) | FIXED — S-626-1 v1.8 | Independently confirmed |
| ADV-P7-LOW-002 | LOW | GAP · pre-existing | comfy-table =7.2.1 pin has no dependabot ignore entry | ROUTED → S-641-1 | S-641-1 AC-3 scope |
| ADV-P7-LOW-003 | LOW | REFINEMENT · in-delta | CLAUDE.md action-input claim unverifiable (same as P6-MED-001) | NOTED | Consequence benign per pass-8 Obs-2 |
| ADV-P7-LOW-004 | LOW | REFINEMENT · pre-existing | SHA comments name toolchain not action version — 7 sites (same as P6-MED-002) | ROUTED → S-641-1 | LOW-004 already in S-641-1 |
| ADV-P7-LOW-005 | LOW | REFINEMENT · pre-existing | check-bc-no-numeric-test-counts.sh hardcoded pass line, no computed count | OPEN | Pre-existing; noted |
| ADV-P7-INFO-001 | INFO | — | Three undeclared-but-beneficial deliverables (--locked, user-impact line, in-code comments) | OPEN | Accepted informational |
| ADV-P7-MED-005 | MEDIUM | PROCESS-GAP · pre-existing | `security` (gitleaks) job absent from ci-gate.needs; secret-scan failure cannot block merge | OPEN (GITLEAKS-NOT-IN-CI-GATE-NEEDS) | Pre-existing; CI-governance story recommended (not folded into SOH-DX-1) |
| ADV-P7-LOW-006 | LOW | REFINEMENT · spec artifact | BC-5.3.00x Source/Trace citations in line-number form (same as P6-LOW-002) | FIXED — bc-5 + BC-INDEX | Symbol-form applied |

## Pass 7 Isolation Note

**PARTIAL.** Broad grep for `team_column_parity` scoped at `.factory/` surfaced ~8 one-line incidental matches from banned paths (pass 1–5 artifacts, ADV-P1-INDEX, spec-changelog). Reviewer did NOT open any banned file; self-disclosed unprompted. Finding F-03 (stale demos) and F-04 (warm cache) are novel findings not derived from banned-path content.

## Pass 7 Summary

- **Verdict:** NOT CLEAN — 3 HIGH + 4 MEDIUM + 5 LOW + 1 INFO; zero code defects; F-03 MOST CONSEQUENTIAL (FALSE-GREEN GENERATOR)
- **Post-capture routing:** HIGH-003 (demo regen) + MED-001 (cold-cache proof) + MED-002 (INV-READ-009) → .factory/ fix round; HIGH-001/003+MED-003/LOW-001/006 same fixes as pass-6; HIGH-002/MED-004+LOW-002/004 → S-641-1; MED-005 → new GITLEAKS drift item
- **Convergence:** 0 of 3 — two passes post-fix, both NOT CLEAN
- **Detail artifact:** `s-626-1-adversary-pass-7.md`

---

## Pass 8 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P8-HIGH-001 | HIGH | GAP · in-delta | SS-11 phantom anchor (third independent confirmation) | FIXED — 5 stories | Human ruling: MIS-ANCHOR per DEC-200 |
| ADV-P8-MED-001 | MEDIUM | GAP · in-delta | Empty BC/VP anchors traceability gap; grounded in X.13/X.11 BC families | FIXED — S-626-1 v1.8 | Third confirmation; MEDIUM not HIGH (S-641-1 remediates) |
| ADV-P8-LOW-001 | LOW | GAP · pre-existing | comfy-table =7.2.1 pin no dependabot ignore entry (third confirmation) | ROUTED → S-641-1 | S-641-1 AC-3 |
| ADV-P8-LOW-002 | LOW | GAP · spec artifact | AC-9 mutation claim false (third confirmation) | FIXED — S-626-1 v1.8 | |
| ADV-P8-LOW-003 | LOW | GAP · spec artifact | STORY-INDEX S-641-1 row stale: v0.2 in INDEX vs v0.4 in story | FIXED — STORY-INDEX v1.5.52 | Row updated to v0.5 (current after fix round) |
| ADV-P8-OBS-001 | OBS | PROCESS-GAP demoted | msrv positive-coverage gap demoted from HIGH — S-641-1 AC-1/AC-2/AC-3 already specify the missing guard | ROUTED → S-641-1 | AC-1/AC-2/AC-3 scope; residual: S-626-1 ACs lack forward ref to S-641-1 routing |
| ADV-P8-OBS-002 | OBS | — | CLAUDE.md action-input claim consequence benign (RUSTUP_TOOLCHAIN on check step) | NOTED | |
| ADV-P8-OBS-003 | OBS | — | rust-cache dilution; not false-green | NOTED | |
| ADV-P8-OBS-004 | OBS | — | gitleaks absence from ci-gate.needs pinned by ci_gate_completeness.rs; deliberate | NOTED | GITLEAKS-NOT-IN-CI-GATE-NEEDS already in Drift |
| ADV-P8-OBS-005 | OBS | — | --locked undeclared; noted in S-641-1 LOW-004 | NOTED | |
| ADV-P8-OBS-006 | OBS | — | SHA comment semantics; S-641-1 LOW-004 | NOTED | |

## Pass 8 Isolation Note

**PARTIAL.** Banned filenames surfaced as path-only metadata from `files_with_matches` grep; no content read; self-disclosed. Reviewer read STORY-INDEX.md, S-641-1.md, BC-INDEX.md, ARCH-INDEX.md (not banned). Reading S-641-1.md materially changed severity calls (msrv gap demoted from HIGH to observation).

## Pass 8 Summary

- **Verdict:** NOT CLEAN — 1 HIGH + 1 MEDIUM + 3 LOW + 6 observations; zero code defects
- **Post-capture routing:** HIGH-001 (SS-11), MED-001 (BC/VP), LOW-002 (AC-9), LOW-003 (STORY-INDEX) → .factory/ fix round (applied 2026-07-31); LOW-001/OBS-001 → S-641-1; OBS-002..006 accepted
- **Key adjudication:** msrv gap DEMOTED from HIGH to Obs-1 (S-641-1 ACs provide remedy); SS-11 confirmed as MIS-ANCHOR per DEC-200
- **Convergence:** 0 of 3 — three passes post-scope-decision, all NOT CLEAN; fix round applied; fresh window required
- **Detail artifact:** `s-626-1-adversary-pass-8.md`

---

## Updated Dependency Graph

```text
ADV-P1-MEDIUM-003 --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P1-MEDIUM-004 --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P1-LOW-003    --informs--> ADV-P1-MEDIUM-005 (guard story scope)
ADV-P2-MEDIUM-003 --routed--> S-641-1 (same guard story as ADV-P1-M004/M005)
ADV-P2-INFO-001   --sharpens--> ADV-P1-MEDIUM-004
ADV-P3-MEDIUM-001 --supersedes--> ADV-P1-MEDIUM-002/ADV-P2-MEDIUM-003 root-cause framing
ADV-P3-MEDIUM-002 --informs--> S-641-1 (re-scoped: comments correct, only present-tense stale)
ADV-P3-MEDIUM-003 --sharpens--> ADV-P1-MEDIUM-002/ADV-P2-MEDIUM-003 (version-branch finding)
ADV-P4-LOW-003    --generalises--> ADV-P3-MEDIUM-002/[process-gap] (version pins same as SHA pins)
ADV-P4-LOW-004    --routed--> S-641-1 (comment convention)
ADV-P4-INFO-005   --informs--> S-641-1 AC-2 (complete let-chain detection form set)
ADV-P6-HIGH-001   --fixed-by--> S-626-1.md v1.8 (bcs: ["BC-5.3.001","BC-5.3.002"])
ADV-P6-HIGH-002   --fixed-by--> 5 story files SS-11→SS-02+SS-09 (DEC-200: MIS-ANCHOR)
ADV-P6-HIGH-003   --routed--> S-641-1 AC-1/AC-2 (positive-coverage assertion)
ADV-P7-HIGH-003   --fixed-by--> demos/ regenerated at HEAD 64e2a4bc with cold-cache evidence
ADV-P7-MED-002    --fixed-by--> bc-02-issue-read.md INV-READ-009 behavioral restatement
ADV-P6-HIGH-003 == ADV-P7-HIGH-002 == ADV-P8-OBS-001 (same gap; pass-8 demoted via S-641-1 ACs)
[All other pass 6/7/8 findings corroborate or extend prior passes]
```
