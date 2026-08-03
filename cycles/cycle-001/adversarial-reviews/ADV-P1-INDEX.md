---
document_type: adversarial-review-index
level: ops
version: "1.6"
status: in-review
producer: adversary
timestamp: 2026-08-03T08:30:00Z
phase: "5"
pass: 14
inputs: [.factory/stories/S-626-1.md, .github/workflows/ci.yml, CLAUDE.md, src/cli/board.rs, src/cli/issue/list.rs, src/cli/auth/keychain.rs]
traces_to: .factory/stories/S-626-1.md
total_findings: 139
severity_distribution: { CRIT: 0, HIGH: 17, MED: 58, LOW: 52, INFO: 12 }
story: S-626-1
cycle: cycle-001
feature_head: c88374b41ee4ea30bc2406e1def90cedf3686275
pr: 667
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute)
convergence: 0 of 3 (Step 4.5 window — DEC-199 GRIND to 3/3 CLEAN; DEC-207 ceiling breach authorized toward 17; window 12/13/14 = 0/3 NOT CLEAN; ZERO HIGH across all three; severity decay 4H→0H confirmed)
void_spawns: 5 (passes 6/7/8 first-attempt background subagents; pass-9 isolation breach; pass-11 isolation breach)
---

# Adversarial Review Index — S-626-1 (SOH-DX-1) Passes 1..14

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
| VOID-6A/7A/8A | N/A — NOT COUNTED | — | — | — | — | — | — | VOID — not window-eligible (background subagent dispatch failures) |
| 6 | NOT CLEAN | 3 | 3 | 2 | 2 | 2 | NO | RESET — HIGH findings after fix round; step 4.5 window 0/3 |
| 7 | NOT CLEAN | 3 | 4 | 5 | 1 | 2 | NO | 0/3 — F-03 UNIQUE: stale demo FALSE-GREEN GENERATOR confirmed and fixed |
| 8 | NOT CLEAN | 1 | 1 | 3 | 0 | 1 (obs) | NO | 0/3 — fix round applied 2026-07-31; fresh window required on amended state |
| 9 (VOID-9A) | VOID | 4 | 7 | 4 | 0 | 0 | NO | VOID — isolation breach; [Mm]utation-detecting grep leaked STATE.md:119; per DEC-206 findings valid, pass window-ineligible |
| 10 | NOT CLEAN | 4 | 11 | 3 | 0 | 4 ([pg]) | NO | 0/3 — WINDOW-ELIGIBLE (clean isolation); 5 novel findings; fix-round-partial-propagation meta-pattern; fix round 3 applied |
| 11 (VOID-11A) | VOID | 2 | 8 | 3 | 0 | 0 | NO | VOID — isolation breach; two root greps leaked STATE.md + spec-changelog.md; per DEC-206 findings valid, pass window-ineligible |
| 12 | NOT CLEAN | 0 | 5 | 5 | 0 | 0 | NO | WINDOW-ELIGIBLE (clean isolation); ZERO HIGH — severity decay from window 9/10/11 (4H each); window 12/13/14 = 1/3 |
| 13 | NOT CLEAN | 0 | 4 | 6 | 0 | 0 | NO | WINDOW-ELIGIBLE (clean isolation); ZERO HIGH — second consecutive zero-HIGH; window 12/13/14 = 2/3 |
| 14 | NOT CLEAN | 0 | 4 | 5 | 0 | 0 | NO | WINDOW-ELIGIBLE (clean isolation); ZERO HIGH — third consecutive zero-HIGH; window 12/13/14 COMPLETE = 0/3 CLEAN |

**Overall convergence: 0 of 3 (Step 4.5 — 14 recorded passes; 5 VOID [3 dispatch + 2 isolation]; DEC-199: GRIND to 3/3 CLEAN; DEC-207: ceiling breach authorized toward 17; window 12/13/14 = 0/3 CLEAN; ZERO HIGH across all three; severity decay 4H→0H confirmed)**

**SEVERITY DECAY RECORDED:** Window 9/10/11 carried 4 HIGH each (isolation issues, but findings valid). Window 12/13/14 carries ZERO HIGH, ceiling MEDIUM across all three passes. Code is 0-defect across nine consecutive passes (6–14, minus VOID passes 9+11). Two passes in window 12/13/14 independently caught and corrected their own broken ampersand-escaped grep patterns before trusting a zero result — GREP-HYGIENE CORRECTIVE VERIFIED EFFECTIVE (3/3 passes cleanly isolated, vs 2/3 breached in prior window).

**META-PATTERN REFINED:** All three passes in window 12/13/14 independently split round 4 the same way: greppable classes FULLY swept; per-artifact re-derivation classes NOT swept; 4 new defects introduced in new prose. Two passes (13 + 14) independently recommended mechanical B−A+1 line-count check and byte-diff for transcript artifacts.

**Findings accumulator (running total):**
- Passes 1–5: 36 total (HIGH: 0, MED: 11, LOW: 16, INFO: 9)
- Pass 6 adds: +10 (HIGH: 3, MED: 3, LOW: 2, INFO: 2)
- Pass 7 adds: +13 (HIGH: 3, MED: 4, LOW: 5, INFO: 1) [F-13 pre-existing; +1 MED]
- Pass 8 adds: +5 (HIGH: 1, MED: 1, LOW: 3, INFO: 0) [observations not counted in totals]
- Pass 9 adds: +15 (HIGH: 4, MED: 7, LOW: 4, INFO: 0) [VOID for window; findings counted]
- Pass 10 adds: +18 (HIGH: 4, MED: 11, LOW: 3, INFO: 0) [WINDOW-ELIGIBLE]
- Pass 11 adds: +13 (HIGH: 2, MED: 8, LOW: 3, INFO: 0) [VOID for window; findings counted]
- Pass 12 adds: +10 (HIGH: 0, MED: 5, LOW: 5, INFO: 0) [WINDOW-ELIGIBLE; ZERO HIGH]
- Pass 13 adds: +10 (HIGH: 0, MED: 4, LOW: 6, INFO: 0) [WINDOW-ELIGIBLE; ZERO HIGH]
- Pass 14 adds: +9 (HIGH: 0, MED: 4, LOW: 5, INFO: 0) [WINDOW-ELIGIBLE; ZERO HIGH]
- **Grand total: 139 findings (CRIT: 0, HIGH: 17, MED: 58, LOW: 52, INFO: 12)**

---

## VOID Spawns — Five VOID Passes (NOT window-eligible, NOT counted in trajectory)

Five passes are recorded as VOID for window eligibility. Three early background subagent dispatches (passes 6/7/8 first attempts) produced no retrievable output and were superseded by re-dispatched synchronous passes. Two later passes (9 and 11) had isolation breaches that disqualified them from window eligibility per DEC-206. All five are recorded here for audit completeness only.

**They are NOT window-eligible and NOT counted in the convergence trajectory.**

**Cause (VOID-6A/7A/8A):** Named background subagents spawned but never delivered final reports. `TaskList` returned empty. Only unnamed synchronous dispatches returned output reliably. See NAMED-BACKGROUND-SUBAGENT-REPORT-LOSS drift item.

**Cause (VOID-9A/11A):** Orchestrator dispatch defect — greps issued at `.factory/` root rather than scoped to named subdirectories. Both passes leaked banned-path content (STATE.md lines and spec-changelog.md). Pass-9 leaked via `[Mm]utation-detecting` pattern match returning STATE.md:119. Pass-11 leaked via two root-level greps returning STATE.md (5 lines) and spec-changelog.md (1 line). Per DEC-206, isolation-breach passes are VOID for window eligibility; findings remain valid for fix-round tracking. Tracked as ORCHESTRATOR-GREP-HYGIENE-INSUFFICIENT drift item.

| Void ID | Intended Pass | Cause | Disposition |
|---------|---------------|-------|-------------|
| VOID-6A | 6 (first attempt) | Named background; no report delivered | Superseded by synchronous re-dispatch |
| VOID-7A | 7 (first attempt) | Named background; no report delivered | Superseded by synchronous re-dispatch |
| VOID-8A | 8 (first attempt) | Named background; no report delivered | Superseded by synchronous re-dispatch |
| VOID-9A | 9 | Isolation breach — grep at `.factory/` root leaked STATE.md:119 | Pass findings valid; window-eligibility VOID per DEC-206 |
| VOID-11A | 11 | Isolation breach — two root greps leaked STATE.md (5 lines) + spec-changelog.md (1 line) | Pass findings valid; window-eligibility VOID per DEC-206 |

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

## Pass 9 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P9-HIGH-001 | HIGH | GAP · in-delta | S-640-1 subsystems incomplete — only SS-02 listed; target_module: src/ contradicted | FIXED — S-640-1 v0.4 | SS-01..SS-09 with per-subsystem justification |
| ADV-P9-HIGH-002 | HIGH | GAP · in-delta | S-576-5 subsystems wrong — SS-11 phantom; SS-02/SS-04 missing; target_module self-contradicted | FIXED — S-576-5 v1.47 | SS-02/SS-04 added; SS-03/SS-09 retained (F-02 pass-11 found residual) |
| ADV-P9-HIGH-003 | HIGH | GAP · in-delta | BC-5.3.003 `Source:` mis-anchors to view.rs; correct owner is INV-READ-009 / list.rs | FIXED — bc-5 + BC-INDEX | BC-5.3.003 retitled; anchor corrected to list.rs (unique P9 finding) |
| ADV-P9-HIGH-004 | HIGH | GAP · in-delta | Demo AC-008.txt certifies PASS on stale `.factory/research/` reference (AC-8 forbids it) | FIXED — AC-008.txt regenerated | Cold-cache cold-build at HEAD 64e2a4bc |
| ADV-P9-MED-001 | MEDIUM | GAP · in-delta | AC-006.txt stale; records superseded mechanism claim as CONFIRMED | FIXED — AC-006.txt regenerated | |
| ADV-P9-MED-002 | MEDIUM | GAP · in-delta | STORY-INDEX S-626-1 row contradicts story file on status and blocks | FIXED — STORY-INDEX v1.5.53 | |
| ADV-P9-MED-003 | MEDIUM | GAP · in-delta | SS-11 sweep updated subsystems but STORY-INDEX rows for S-640-1/S-576-5 not refreshed | FIXED — STORY-INDEX v1.5.53 | |
| ADV-P9-MED-004 | MEDIUM | GAP · in-delta | S-626-1 v1.8 "mutation-detecting" persists in File Structure Requirements row | FIXED — S-626-1 v1.9 | |
| ADV-P9-MED-005 | MEDIUM | GAP · pre-existing | keychain coverage gap — `resolve_credential` rewrite has no test pinning three credential-resolution paths | OPEN | Unique P9 finding; tracked as KEYCHAIN-CREDENTIAL-PATH-UNCOVERED drift item |
| ADV-P9-MED-006 | MEDIUM | PROCESS-GAP | Citation guard (`check-bc-citation-symbols.sh`) scopes src/ only; .factory/stories/*.md BC citations unvalidated | OPEN | Unique P9 finding; tracked as CITATION-GUARD-SRC-ONLY drift item |
| ADV-P9-MED-007 | MEDIUM | GAP · in-delta | BC-5.3.001 in bcs: but no AC traces to it; positive path uncovered | FIXED — S-626-1 v1.9 | AC trace added |
| ADV-P9-LOW-001 | LOW | REFINEMENT · spec artifact | AC-004.txt cites ci.yml line numbers that don't match delivered file | FIXED — AC-004.txt regenerated | |
| ADV-P9-LOW-002 | LOW | GAP · spec artifact | INDEX.md claims head 64e2a4bc for full artifact set; 6 artifacts not regenerated at that head | FIXED — all 11 artifacts regenerated; Regeneration Log added | |
| ADV-P9-LOW-003 | LOW | REFINEMENT · spec artifact | INV-READ-009 MSRV note is an un-listed cleanup site not in CLAUDE.md:163 obligation | FIXED — marked self-identifying-temporary | |
| ADV-P9-LOW-004 | LOW | REFINEMENT · spec artifact | AC-9 and Task 7d state test count 2341; demo shows 2343 | FIXED — S-626-1 v1.9 | 2341→2343 at both sites |

## Pass 9 Isolation Note

**VOID — ORCHESTRATOR DISPATCH DEFECT.** `grep -r "[Mm]utation-detecting" .factory/` at `.factory/` root surfaced STATE.md:119 containing convergence trajectory data. Reviewer had access to banned-path content prior to completing analysis. Per DEC-206, isolation-breach passes are disqualified from step-4.5 window eligibility. Findings remain valid.

## Pass 9 Summary

- **Verdict:** NOT CLEAN — 4 HIGH + 7 MEDIUM + 4 LOW; zero code defects; pass VOID for window
- **Post-capture routing:** HIGH-001..004 + MED-001..004 + MED-007 + LOW-001..004 → fix round 3 (.factory/ + product-repo); MED-005 (keychain coverage gap) → KEYCHAIN-CREDENTIAL-PATH-UNCOVERED drift item; MED-006 (citation-guard src-only) → CITATION-GUARD-SRC-ONLY drift item
- **Convergence:** 0/3 — pass VOID for window (isolation breach, DEC-206); 3 unique findings (H-003 BC-5.3.003 mis-anchor; M-005 keychain coverage gap; M-006 citation-guard src-only)
- **Detail artifact:** `s-626-1-adversary-pass-9.md`

---

## Pass 10 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P10-HIGH-001 | HIGH | GAP · in-delta | AC-008.txt certifies PASS on Cargo.toml state that VIOLATES AC-8 (.factory/research path) | FIXED — AC-008.txt regenerated fix round 3 | |
| ADV-P10-HIGH-002 | HIGH | GAP · in-delta | AC-006.txt stale; records superseded factually-incorrect precedence text as CONFIRMED | FIXED — AC-006.txt regenerated fix round 3 | |
| ADV-P10-HIGH-003 | HIGH | GAP · in-delta | S-640-1 subsystems materially incomplete — SS-02 only; target_module: src/ contradicted | FIXED — S-640-1 v0.4 | Third independent confirmation |
| ADV-P10-HIGH-004 | HIGH | GAP · in-delta | S-576-5 subsystems omit SS-02/SS-04; SS-03 is false anchor; contradicts own target_module | FIXED — S-576-5 v1.47 | Third independent confirmation |
| ADV-P10-MED-001 | MEDIUM | GAP · in-delta | AC-004.txt cites ci.yml line numbers that don't match delivered file | FIXED — AC-004.txt regenerated | |
| ADV-P10-MED-002 | MEDIUM | PROCESS-GAP | Demo regeneration has no completeness assertion; INDEX.md claims head for unrefreshed artifacts | FIXED — all 11 artifacts regenerated; Regeneration Log added | Root-cause diagnosis (unique P10 finding) |
| ADV-P10-MED-003 | MEDIUM | GAP · in-delta | `issue list` test anchored into BC-5 Boards & Sprints; real owner INV-READ-009 | FIXED — re-homed; INV-READ-009 Source updated | |
| ADV-P10-MED-004 | MEDIUM | GAP · spec artifact | AC-009.txt claims both guard conditions pinned; outer Table-gate mutant survives both tests | FIXED — false coverage claim corrected; outer-gate gap remains open | |
| ADV-P10-MED-005 | MEDIUM | GAP · spec artifact | STORY-INDEX S-626-1 row contradicts story file on status and blocks; three-way disagreement | FIXED — S-626-1 v1.9 + STORY-INDEX v1.5.53 | |
| ADV-P10-MED-006 | MEDIUM | GAP · spec artifact | SS-11 sweep bumped S-640-1/S-576-5 but STORY-INDEX rows not refreshed | FIXED — STORY-INDEX v1.5.53 | |
| ADV-P10-MED-007 | MEDIUM | GAP · spec artifact | v1.8 "mutation-detecting" correction propagated to AC-9 but not File Structure Requirements | FIXED — S-626-1 v1.9 | |
| ADV-P10-MED-008 | MEDIUM | GAP · spec artifact | BC-5.3.001 in bcs: but no AC traces to it | FIXED — AC trace added | |
| ADV-P10-MED-009 | MEDIUM | GAP · spec artifact | bc-5 §5.3 header says "(7 contracts)"; BC-INDEX says "(4 BCs)"; count inconsistency | FIXED — §5.3 count removed | Unique P10 finding; guard extension tracked as drift item |
| ADV-P10-MED-010 | MEDIUM | GAP · spec artifact | S-641-1 AC-1/AC-2 mutually inconsistent on version granularity; AC-2 guard fails on correct tree | FIXED — S-641-1 v0.6 | |
| ADV-P10-MED-011 | MEDIUM | PROCESS-GAP | SS-09 file set doesn't cover scripts/, tests/, .github/dependabot.yml; S-641-1 exclusivity contradicted | PARTIAL — S-641-1 rationale corrected; ARCH-INDEX extension tracked | Unique P10 finding |
| ADV-P10-LOW-001 | LOW | REFINEMENT · spec artifact | release.yml MUST-NOT protection cites range that excludes the line it protects | FIXED — S-626-1 v1.9 | Unique P10 finding |
| ADV-P10-LOW-002 | LOW | REFINEMENT · spec artifact | INV-READ-009 new MSRV note is un-listed cleanup site | FIXED — marked self-identifying-temporary | |
| ADV-P10-LOW-003 | LOW | REFINEMENT · spec artifact | AC-9 and Task 7d state test-count target as 2341; demo shows 2343 | FIXED — 2341→2343 | Unique P10 finding |

## Pass 10 Isolation Note

**CLEAN.** Every grep scoped to named subdirectory; never `.factory/` root. Three banned-path filenames incidentally visible as quoted text inside in-perimeter files (disclosed). No banned-path content read; all findings independently re-derived from primary artifacts.

## Pass 10 Summary

- **Verdict:** NOT CLEAN — 4 HIGH + 11 MEDIUM + 3 LOW; zero code defects; **WINDOW-ELIGIBLE** (clean isolation); policy rubric ABSENT (baseline applied)
- **Post-capture routing:** All 18 findings → fix round 3 (except MED-004 outer-gate gap remains open; MED-011 ARCH-INDEX tracked as drift item)
- **Convergence:** 0/3 — WINDOW-ELIGIBLE; NOT CLEAN; mis-anchoring findings (F-03/F-05/F-06) block convergence unconditionally; 5 novel findings; fix-round-partial-propagation meta-pattern identified
- **Detail artifact:** `s-626-1-adversary-pass-10.md`

---

## Pass 11 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P11-HIGH-001 | HIGH | GAP · fix-introduced | S-640-1 Task 0 bare-7.2.1 circular gate — spec artifacts contain the forbidden string; gate would block on its own deliverables | FIXED — Task 0 scope corrected; S-641-1 MSRV prose normalized | Unique P11 finding |
| ADV-P11-HIGH-002 | HIGH | GAP · fix-residual | S-576-5 retains SS-03/SS-09 as false anchors after fix round 3 added SS-02/SS-04 | FIXED — SS-03/SS-09 removed | Fix-round-partial-propagation shape |
| ADV-P11-MED-001 | MEDIUM | GAP · spec artifact | S-640-1 ARCH-INDEX Task 11 listed as deliverable but SS-11 registry entry still absent | FIXED — tracked as ARCH-INDEX-REGISTRY-COVERAGE-GAP drift item | |
| ADV-P11-MED-002 | MEDIUM | GAP · fix-residual | BC-5.3.003 BC-INDEX row updated but bc-5 body title not swept; two surfaces disagree | FIXED — bc-5 heading updated | Fix-round-partial-propagation shape |
| ADV-P11-MED-003 | MEDIUM | GAP · fix-residual | BC-INDEX §5.3 prose description still carries BC-5.3.003 old title post-retitling | FIXED | Fix-round-partial-propagation shape |
| ADV-P11-MED-004 | MEDIUM | GAP · fix-residual | INV-READ-009 re-anchor applied to origin but cross-subsystem source in BC-5.3.002 not removed | FIXED — source removed from BC-5.3.002 | Fix-round-partial-propagation shape |
| ADV-P11-MED-005 | MEDIUM | GAP · spec artifact | S-641-1 `blocks:` missing reverse edge to S-640-1 | FIXED — blocks: ["S-640-1"] | Unique P11 finding |
| ADV-P11-MED-006 | MEDIUM | COVERAGE-GAP | BC-5.3.001 scope extended to `jr issue list` but no positive-path test added (POL-11) | OPEN — outer-gate test added; positive-path gap remains | |
| ADV-P11-MED-007 | MEDIUM | PROCESS-GAP | ARCH-INDEX SS-09 scope mismatch: tests/ and scripts/ unregistered; S-641-1 rationale still contradicts test_files: | PARTIAL — S-641-1 corrected; ARCH-INDEX extension tracked | |
| ADV-P11-MED-008 | MEDIUM | GAP · spec artifact | S-627-1 SS-09 best-fit assignment undisclosed in STORY-INDEX row | FIXED — STORY-INDEX disclosure note added | Fix-round-partial-propagation shape |
| ADV-P11-LOW-001 | LOW | REFINEMENT · spec artifact | release.yml MUST-NOT updated at line 698 but not in blockquote at :101 or STORY-INDEX:500 | FIXED | Fix-round-partial-propagation shape |
| ADV-P11-LOW-002 | LOW | REFINEMENT · spec artifact | full-suite.txt / AC-009.txt pre-date fix-round-3 test additions; anticipated drift | NOTED — will require re-capture after fix-round-3 PR lands | |
| ADV-P11-LOW-003 | LOW | REFINEMENT · spec artifact | STORY-INDEX `last_updated:` dates for S-640-1/S-576-5 not refreshed despite version bumps | FIXED | Fix-round-partial-propagation shape |

## Pass 11 Isolation Note

**VOID — ORCHESTRATOR DISPATCH DEFECT.** Two greps issued at `.factory/` root (not scoped to named subdirectory) leaked STATE.md (5 result lines) and spec-changelog.md (1 result line). Per DEC-206, isolation-breach passes are disqualified from step-4.5 window eligibility. Findings remain valid. Meta-pattern noted: 8 of 13 findings are the fix-round-partial-propagation shape.

## Pass 11 Summary

- **Verdict:** NOT CLEAN — 2 HIGH + 8 MEDIUM + 3 LOW; zero code defects; pass VOID for window (isolation breach, DEC-206); 8 of 13 findings are fix-round-partial-propagation shape
- **Post-capture routing:** All findings → fix round 3 (except MED-006 outer-gate gap; MED-007 ARCH-INDEX tracked); MED-001 tracked as ARCH-INDEX-REGISTRY-COVERAGE-GAP drift item
- **Convergence:** 0/3 — pass VOID; FIX-ROUND-PARTIAL-PROPAGATION meta-pattern identified and tracked as drift item
- **Detail artifact:** `s-626-1-adversary-pass-11.md`

---

---

## Pass 12 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P12-MED-001 | MEDIUM | GAP · spec artifact | BC-5.3.001 Behavior claims sprint.rs and board.rs gates are "identical" — sprint.rs adds `!is_kanban` check; gates differ | OPEN — routed to fix round 4 | Unique P12 finding; persists across P13/P14 |
| ADV-P12-MED-002 | MEDIUM | GAP · spec artifact | S-641-1 AC-2 item 8 lists two incompatible `rustup-toolchain-install-master` patterns; correct form is one | OPEN — routed to fix round 4 (S-641-1 v0.7) | Confirmed P13 LOW-001 |
| ADV-P12-MED-003 | MEDIUM | GAP · spec artifact | AC-009 BEFORE block claims 10 lines but actual line count is 17 (B−A+1 arithmetic off) | OPEN — routed to fix round 4 | Confirmed P13 LOW-002 via route |
| ADV-P12-MED-004 | MEDIUM | GAP · spec artifact | AC-009 AFTER block claims 22 lines but actual line count is 21 (B−A+1 arithmetic off) | OPEN — routed to fix round 4 | Confirmed P13 LOW-002 via route |
| ADV-P12-MED-005 | MEDIUM | GAP · spec artifact | S-576-5 File Structure Requirements table has no SS-04 row despite SS-04 in subsystems: | OPEN — routed to fix round 4 (S-576-5 v1.48) | Confirmed P13 LOW-002 |
| ADV-P12-LOW-001 | LOW | REFINEMENT · spec artifact | AC-005.txt BEFORE block missing blank-line separator between step groups (first occurrence) | OPEN — routed to fix round 4 | Transcript fidelity class |
| ADV-P12-LOW-002 | LOW | REFINEMENT · spec artifact | AC-005.txt BEFORE block missing blank-line separator between step groups (second occurrence) | OPEN — routed to fix round 4 | Transcript fidelity class |
| ADV-P12-LOW-003 | LOW | REFINEMENT · spec artifact | AC-008.txt condition uses ≥ (Unicode ≥) where test code uses >= (ASCII) — byte-mismatch | OPEN — routed to fix round 4 | Transcript fidelity class |
| ADV-P12-LOW-004 | LOW | REFINEMENT · spec artifact | full-suite.txt attributes test to "Task 7d" but story calls it "Task 7c" | OPEN — routed to fix round 4 | Transcript fidelity class |
| ADV-P12-LOW-005 | LOW | REFINEMENT · spec artifact | INDEX.md summary says "both files" for a three-file delivery section | OPEN — routed to fix round 4 | Transcript fidelity class |

## Pass 12 Isolation Note

**CLEAN.** All greps scoped to named subdirectories under `.factory/cycles/` or specific file paths. No banned-path content accessed. Two ampersand-escaped grep patterns self-corrected before trusting zero result — grep-hygiene protocol effective.

## Pass 12 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 5 MEDIUM + 5 LOW; **ZERO HIGH** (severity decay from windows 9/10/11); zero code defects
- **Post-capture routing:** All 10 findings → fix round 4 (ADV-P1-INDEX → demos/, bc-5, S-641-1, S-576-5, stories/)
- **Convergence:** 0/3 — window 12/13/14 open; ZERO HIGH; code 0-defect across passes 6–12 minus VOIDs; grep-hygiene corrective verified effective (first clean isolation since window 10)
- **Detail artifact:** `s-626-1-adversary-pass-12.md`

---

## Pass 13 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P13-MED-001 | MEDIUM | GAP · spec artifact | BC-5.3.001 Source field references only board.rs tests; sprint.rs tests covering the identical-gate claim are absent | OPEN — routed to fix round 4 | Fix-round-partial-propagation shape; sprint.rs Source gap |
| ADV-P13-MED-002 | MEDIUM | GAP · spec artifact | BC-5.3.003 no-suffix path (bare `jr board`) uncovered by any listed test; AC trace present but no covering test | OPEN — routed to fix round 4 | Unique P13 finding; persists in P14 MED-002 |
| ADV-P13-MED-003 | MEDIUM | GAP · spec artifact | AC-005 BEFORE block missing third release.yml site — only two of three sites captured | OPEN — routed to fix round 4 | Transcript fidelity class (third-site gap) |
| ADV-P13-MED-004 | MEDIUM | GAP · spec artifact | S-576 family status drift — 4 story files carry "ready" status while STORY-INDEX carries "completed" for same entries | OPEN — routed to S-MAINT-576-HYG-1 (DEC-208) | S-576 family subsystem pattern; STORY-INDEX drift |
| ADV-P13-LOW-001 | LOW | REFINEMENT · spec artifact | S-641-1 AC-2 item 8 incompatible patterns (confirmation of P12-MED-002) | OPEN — routed to fix round 4 | Confirmation finding |
| ADV-P13-LOW-002 | LOW | REFINEMENT · spec artifact | S-576-5 File Structure Requirements table missing SS-04 row (confirmation of P12-MED-005) | OPEN — routed to fix round 4 | Confirmation finding |
| ADV-P13-LOW-003 | LOW | REFINEMENT · spec artifact | ci.yml citation in S-626-1 at ~:98 (three occurrences) should be ~:112 post-fix-round-3 | OPEN — routed to fix round 4 (S-626-1 v1.10) | Line-drift class |
| ADV-P13-LOW-004 | LOW | REFINEMENT · spec artifact | sign-and-publish.yml citation in S-626-1 at ~:64 should be ~:65 | OPEN — routed to fix round 4 (S-626-1 v1.10) | Line-drift class |
| ADV-P13-LOW-005 | LOW | REFINEMENT · spec artifact | backfill-release.yml citation in S-626-1 at ~:79 should be ~:80 | OPEN — routed to fix round 4 (S-626-1 v1.10) | Line-drift class |
| ADV-P13-LOW-006 | LOW | REFINEMENT · spec artifact | BC-5.3.001 and BC-5.3.003 Source fields missing cli_handler.rs integration test coverage (partial) | OPEN — routed to fix round 4 | Partial-coverage disclosure |

## Pass 13 Isolation Note

**CLEAN.** Grep-hygiene self-correction demonstrated: two patterns with broken ampersand escaping caught and re-issued before trusting results. No banned-path files accessed. VOID-9A/11A pattern NOT repeated — all greps scoped to named subdirectories.

## Pass 13 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 4 MEDIUM + 6 LOW; **ZERO HIGH** (second consecutive); zero code defects
- **Post-capture routing:** MED-001..003 → fix round 4 (.factory/ artifacts); MED-004 → S-MAINT-576-HYG-1 (DEC-208); LOW-001..006 → fix round 4
- **Convergence:** 0/3 — window 12/13/14 = 2/3; ZERO HIGH second consecutive; grep-hygiene corrective confirmed effective
- **Detail artifact:** `s-626-1-adversary-pass-13.md`

---

## Pass 14 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P14-MED-001 | MEDIUM | GAP · spec artifact | BC-5.3.001 Behavior claims sprint.rs and board.rs gates identical (third independent confirmation) | OPEN — routed to fix round 4 | Three-pass confirmation; see P12-MED-001 |
| ADV-P14-MED-002 | MEDIUM | GAP · spec artifact | BC-5.3.003 Source field missing symbol citations for no-suffix path tests (confirmation of P13-MED-002) | OPEN — routed to fix round 4 | Fix-round-partial-propagation shape |
| ADV-P14-MED-003 | MEDIUM | GAP · spec artifact (ACCEPTED) | AC-005 release.yml third site format inconsistency — BEFORE block format differs from first two sites | ACCEPTED — current format accepted as sufficient | Transcript fidelity; accepted inconsistency |
| ADV-P14-MED-004 | MEDIUM | GAP · spec artifact | S-641-1 AC-2 item 6 partial-version predicate `~^=\d+\.\d+` admits `=7.2` (two-component); should be three-component `~^=\d+\.\d+\.\d+` | OPEN — routed to fix round 4 (S-641-1 v0.7) | Predicate precision gap |
| ADV-P14-LOW-001 | LOW | REFINEMENT · spec artifact | BC-5.3.001 Source confirms board.rs tests (citation confirmation) | CONFIRMED — no action | Confirmation finding |
| ADV-P14-LOW-002 | LOW | REFINEMENT · spec artifact | S-626-1 line citations confirmed stale at ~:98/~:64/~:79 (confirmation of P13-LOW-003..005) | CONFIRMED — routed to fix round 4 | Confirmation finding |
| ADV-P14-LOW-003 | LOW | REFINEMENT · spec artifact | BC-5.3.001 and BC-5.3.003 Source symbols confirmed partially absent (confirmation of P13-LOW-006) | CONFIRMED — routed to fix round 4 | Confirmation finding |
| ADV-P14-LOW-004 | LOW | REFINEMENT · spec artifact | S-576 family drift routing to S-MAINT-576-HYG-1 confirmed appropriate (DEC-208) | CONFIRMED — DEC-208 routing acknowledged | Confirmation finding |
| ADV-P14-LOW-005 | LOW | REFINEMENT · spec artifact (ACCEPTED) | Cargo.lock cross-check phrasing in S-641-1 ambiguous between "verify unchanged" and "must regenerate" semantics | ACCEPTED — ambiguity accepted; semantic intent clear from context | Accepted phrasing ambiguity |

## Pass 14 Isolation Note

**CLEAN.** Third consecutive clean isolation. Ampersand-escaped grep patterns verified before use. No banned-path content accessed. Grep-hygiene corrective verified effective across all three passes in window 12/13/14.

## Pass 14 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 4 MEDIUM + 5 LOW; **ZERO HIGH** (third consecutive); zero code defects; window 12/13/14 COMPLETE = 0/3 CLEAN
- **Post-capture routing:** MED-001..002 + MED-004 + LOW-002..003 → fix round 4; MED-003/LOW-005 accepted; DEC-208 confirmed; LOW-004 DEC-208 routing acknowledged
- **Convergence:** 0/3 — window 12/13/14 complete; severity decay 4H→0H confirmed; code 0-defect nine consecutive passes; fix-round-introduces-defects-in-new-prose meta-pattern identified; DEMO-TRANSCRIPT-FIDELITY-NO-MECHANICAL-GUARD new drift item
- **Detail artifact:** `s-626-1-adversary-pass-14.md`

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
