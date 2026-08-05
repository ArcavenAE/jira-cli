---
document_type: adversarial-review-index
level: ops
version: "2.4"
status: in-review
producer: adversary
timestamp: 2026-08-05T07:00:00Z
phase: "5"
pass: 29
inputs: [.factory/stories/S-626-1.md, .factory/stories/S-640-1.md, .factory/stories/S-641-1.md, .factory/stories/S-MUTANTS-EXAMINE-GLOBS-1.md, .factory/stories/STORY-INDEX.md, .github/workflows/ci.yml, tests/ci_gate_completeness.rs, tests/cli_handler.rs, tests/mutants_glob_existence.rs, CLAUDE.md, Cargo.toml, CHANGELOG.md]
traces_to: .factory/stories/S-626-1.md
total_findings: 212
severity_distribution: { CRIT: 0, HIGH: 19, MED: 84, LOW: 80, INFO: 29 }
story: S-626-1
cycle: cycle-001
feature_head: 1e696128 (fix-round-12 product commit; passes 27/28/29 ran against e49230a7 (DEC-225); fix round 12 1e696128 closed all pass-27/28/29 substantive findings)
pr: 667
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute)
convergence: 0 of 3 (Step 4.5 window — DEC-199 GRIND to 3/3 CLEAN; window 27/28/29 CLOSED 1/3 (pass-27 CLEAN + pass-28 NOT CLEAN + pass-29 NOT CLEAN; BROKEN); DEC-224 ISOLATION ELIGIBILITY PRINCIPLE held — all three ELIGIBLE; 26 recorded passes; src/ 0-defect NINETEENTH consecutive; CI floor SOUND (nine independent confirmations passes 21-29); fix round 12 applied 1e696128; fresh STRICT window = passes 30/31/32 (DEC-227, designated, not yet dispatched))
void_spawns: 6 (passes 6/7/8 first-attempt background subagents; pass-9 isolation breach; pass-11 isolation breach; pass-22 isolation breach)
not_run: 2 (passes 16/17 — superseded by round-5 ruling per DEC-209; see s-626-1-adversary-pass-16.md and s-626-1-adversary-pass-17.md)
superseded: 1 (pass-20 — superseded per DEC-216; window 18/19/20 CLOSED 0/2)
not_dispatched: 6 (passes 22/23 of window 21/22/23 — superseded when pass-21 returned NOT CLEAN; passes 23/24 of window 22/23/24 — superseded when pass-22 returned VOID+NOT CLEAN; passes 24/25 of window 23/24/25 — superseded when pass-23 returned NOT CLEAN; passes 24/25/26 subsequently dispatched under fresh window DEC-223 and ran)
---

# Adversarial Review Index — S-626-1 (SOH-DX-1) Passes 1..29

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
| 15 | NOT CLEAN | 0 | 6 | 9 | 0 | 0 | NO | WINDOW-ELIGIBLE (isolation CLEAN); ZERO HIGH — tenth consecutive; **TREND REVERSAL 9→15 findings (8 round-4-attributable)**; window 0/1; passes 16/17 NOT RUN per DEC-209 |
| 16 | NOT RUN | — | — | — | — | — | — | NOT RUN — superseded by round-5 ruling (DEC-209); stub at s-626-1-adversary-pass-16.md |
| 17 | NOT RUN | — | — | — | — | — | — | NOT RUN — superseded by round-5 ruling (DEC-209); stub at s-626-1-adversary-pass-17.md |
| 18 | NOT CLEAN | 0 | 7 | 3 | 0 | 1 ([process-gap]) | NO | WINDOW-ELIGIBLE (isolation CLEAN); ZERO HIGH — ELEVENTH consecutive; F-07 FIXED IN-CYCLE 9312f11f (DEC-211); 7 of 10 round-5-attributable; window 0/1 of 18/19/20; passes 19/20 authorized (DEC-212) |
| 19 | NOT CLEAN | 2 | 6 | 1 | 1 | 1 ([pg]) | NO | WINDOW-ELIGIBLE (isolation CLEAN); 2H — FIRST PASS WITH HIGH IN WINDOW 18/19/20; FOUR REAL CI-AS-CODE DEFECTS in orchestrator-shipped POL-11 guard (HIGH-001+MED-001/002/003 all closed by a247a343); src/ 0-defect TWELFTH consecutive; HIGH-002 scope breach + MED-004/005 closed fix round 7; MED-006 ROUTED DEC-215; window 0/2 of 18/19/20; anchor migration ends citation-ripple class |
| 20 | SUPERSEDED | — | — | — | — | — | — | SUPERSEDED per DEC-216 — window 18/19/20 CLOSED 0/2 (pass-20 not dispatched); new STRICT window opens at passes 21/22/23 |
| 21 | NOT CLEAN | 0 | 3 | 3 | 1 | 0 | NO | WINDOW-ELIGIBLE (isolation CLEAN); ZERO HIGH — THIRTEENTH consecutive zero-src/-defect; **CI floor AUDITED SOUND (all four dimensions at a247a343)**; recurring pattern: "correct change + false claim alongside it"; window 0/1 of 21/22/23; passes 22/23 NOT DISPATCHED; fix round 8 applied; fresh STRICT window passes 22/23/24 |
| 22 (VOID-22A) | VOID | 0 | 1 | 2 | 0 | 0 | NO | VOID — isolation breach; root-scoped `.factory/` grep leaked ADV-P1-INDEX.md + passes 9/10/15/18/21; self-disclosed; DEC-220; FOURTEENTH consecutive zero-src/-defect; CI floor AUDITED SOUND (all SEVEN dimensions); window 22/23/24 CLOSED 0/1; fix round 9 applied 7798b1bf; fresh STRICT window passes 23/24/25 |
| 23 | NOT CLEAN | 0 | 1 | 1 | 0 | 0 | NO | WINDOW-ELIGIBLE (isolation CLEAN — PRE-FLIGHT CHECK corrective VERIFIED EFFECTIVE; first pass under revised corrective); ZERO HIGH — FIFTEENTH consecutive zero-src/-defect; CI floor pin 8/8 assertions non-comment-satisfiable; window 23/24/25 CLOSED 0/1; fix round 10 applied 14416fd9; fresh STRICT window passes 24/25/26 (DEC-223) |
| 24 | **CLEAN** | 0 | 0 | 1 | 0 | 0 | NO | **FIRST CLEAN VERDICT IN THE CYCLE** — ELIGIBLE (isolation: two self-disclosed deviations; zero banned content surfaced; DEC-224 ISOLATION ELIGIBILITY PRINCIPLE ESTABLISHED); ZERO HIGH — SIXTEENTH consecutive zero-src/-defect; CI floor 8/8 assertions non-comment-satisfiable (fourth independent confirmation); window 24/25/26 = 1/3 |
| 25 | **CLEAN** | 0 | 0 | 3 | 2 | 0 | NO | **SECOND CONSECUTIVE CLEAN** — ELIGIBLE (isolation: three Globs anchored at whitelisted subdirs); ZERO HIGH — SEVENTEENTH consecutive zero-src/-defect; CI floor 8/8 non-comment-satisfiable (fifth independent confirmation); found three things pass-24 missed; window 24/25/26 = 2/3 |
| 26 | NOT CLEAN | 0 | 1 | 2 | 2 | 0 | NO | ELIGIBLE (isolation: one deviation returned zero results); ZERO HIGH — EIGHTEENTH consecutive zero-src/-defect; CI floor 8/8 non-comment-satisfiable (sixth independent confirmation); F-02 MED: authorization trail incomplete for tests/team_column_parity.rs (third exception-list file; FIX-ROUND-PARTIAL-PROPAGATION instance); F-04 LOW pre-existing ROUTED; window 24/25/26 BROKEN 2/3; fix round 11 applied e49230a7; fresh STRICT window passes 27/28/29 |

**Overall convergence: 0 of 3 (Step 4.5 — 23 recorded passes + 2 NOT RUN (16/17) + 1 SUPERSEDED (pass-20, DEC-216) + 6 NOT DISPATCHED (passes 22/23 of window 21/22/23; passes 23/24 of window 22/23/24; passes 24/25 of window 23/24/25 — all 6 historical; passes 24/25/26 subsequently dispatched under fresh window DEC-223); 6 VOID [3 dispatch + 3 isolation]; DEC-199: GRIND to 3/3 CLEAN; DEC-223: window 24/25/26 CLOSED 2/3 (pass-24 CLEAN + pass-25 CLEAN + pass-26 NOT CLEAN; BROKEN); DEC-224: ISOLATION ELIGIBILITY PRINCIPLE ESTABLISHED; FIRST CLEAN VERDICTS: passes 24 and 25; ZERO HIGH — EIGHTEENTH consecutive zero-src/-defect; CI floor pin 8/8 assertions non-comment-satisfiable (six consecutive independent confirmations); fix round 11 applied e49230a7; fresh STRICT window = passes 27/28/29 (0/3, not yet dispatched))**

**SEVERITY DECAY RECORDED (THEN REVERSED, THEN 2H IN WINDOW, THEN ZERO HIGH AGAIN, THEN FIRST CLEAN VERDICTS):** Window 9/10/11 carried 4 HIGH each. Window 12/13/14 carries ZERO HIGH. Passes 15 and 18 carry ZERO HIGH but 15 was a TREND REVERSAL (9→15). Pass-19 carries 2 HIGH — the first HIGH findings in the 18/19/20 window — but both are non-src/ defects (CI-as-code + spec scope breach). Pass-21 returns to ZERO HIGH (pass-20 SUPERSEDED). Pass-22 VOID (isolation breach) but ZERO HIGH. Pass-23 ZERO HIGH; isolation CLEAN — first pass under PRE-FLIGHT CHECK corrective. Pass-24 ZERO HIGH; isolation ELIGIBLE; **FIRST CLEAN VERDICT IN THE CYCLE**. Pass-25 ZERO HIGH; isolation ELIGIBLE; **SECOND CONSECUTIVE CLEAN**. Pass-26 ZERO HIGH; isolation ELIGIBLE; NOT CLEAN (1M+2L+2INFO); window BROKEN 2/3. Code is 0-defect across EIGHTEEN consecutive passes (6–15+18+19+21+22+23+24+25+26, minus VOID passes 9+11+22). **THREE CONSECUTIVE REVIEWERS (passes 13, 14, 15) independently prescribed the same mechanical remedy: a STORY-INDEX coherence guard and a BC sub-element citation guard.** Fix round 5 applied; pass-18 confirmed 15 of 15 pass-15 findings FIXED but added 10 new findings (7 round-5-attributable). Fix round 7 applied; pass-19 found 10 new findings, 4 of which were REAL CI-AS-CODE DEFECTS in the orchestrator-shipped POL-11 guard. Fix round 8 applied; pass-21 found 7 findings, all documentation/citation-accuracy defects, none in src/. Fix round 9 applied; pass-22 found 3 findings: F-01 MEDIUM (pin prose-satisfiable), F-02/F-03 LOW (demo residue + provenance trail incomplete). CI floor mechanism audited SOUND on all SEVEN dimensions. Fix round 10 applied; pass-23 found 2 findings: F-01 MEDIUM (stale anchor in ci.yml self-comment), F-02 LOW (BC-5.3.001 "both conditions" vs three). Fix round 11 applied (e49230a7); passes 24/25 CLEAN; pass-26 found 5 findings: F-02 MED (team_column_parity.rs authorization trail incomplete — third exception-list file, FIX-ROUND-PARTIAL-PROPAGATION), F-01/F-04 LOW (count-in-prose + wrong-file mis-anchor pre-existing ROUTED), F-03/F-05 INFO (pass-25 concurrences). **ISOLATION ELIGIBILITY PRINCIPLE (DEC-224) ESTABLISHED:** passes 24/25/26 all ELIGIBLE despite self-disclosed path deviations — rule is contamination prevention, not path-syntax enforcement; key test is whether banned content surfaced.

**META-PATTERN SEVENTH TIME + RECURRING PATTERN NAMED + PIN-PROSE-SATISFIABLE CLASS:** Pass-21 reviewer named the recurring pattern precisely: *"a correct change landed alongside a false claim about it."* Pass-22 refined the class further: a regression pin can have a FALSE-GREEN when a bare `contains()` assertion is satisfied by a COMMENT containing the pinned string rather than the command. The corrective (command-unique form, discrimination proof by removing command while leaving comment) is now encoded as `PIN-ASSERTIONS-PROSE-SATISFIABLE` drift item. **Round-7's anchor-form migration remains CLASS-ELIMINATING for ci.yml citations.** The third isolation breach (pass-22) used the same root-scoped `.factory/` grep mechanism as passes 9 and 11; behavioral corrective effective for 10 consecutive passes (12-21) before this recurrence.

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
- Pass 15 adds: +15 (HIGH: 0, MED: 6, LOW: 9, INFO: 0) [WINDOW-ELIGIBLE; ZERO HIGH; TREND REVERSAL]
- Passes 16/17: +0 (NOT RUN — superseded by round-5 ruling per DEC-209)
- Pass 18 adds: +10 (HIGH: 0, MED: 7, LOW: 3, INFO: 0) [WINDOW-ELIGIBLE; ZERO HIGH; F-07 FIXED IN-CYCLE]
- Pass 19 adds: +10 (HIGH: 2, MED: 6, LOW: 1, INFO: 1) [WINDOW-ELIGIBLE; 2H FIRST IN WINDOW; four CI-as-code defects all closed by a247a343]
- Pass 20: +0 (SUPERSEDED — DEC-216; window 18/19/20 CLOSED 0/2)
- Pass 21 adds: +7 (HIGH: 0, MED: 3, LOW: 3, INFO: 1) [WINDOW-ELIGIBLE; ZERO HIGH; THIRTEENTH zero-src/-defect; CI floor SOUND; passes 22/23 NOT DISPATCHED]
- Pass 22 adds: +3 (HIGH: 0, MED: 1, LOW: 2, INFO: 0) [VOID isolation breach; FOURTEENTH zero-src/-defect; CI floor SOUND seven dimensions; window 22/23/24 CLOSED 0/1]
- Pass 23 adds: +2 (HIGH: 0, MED: 1, LOW: 1, INFO: 0) [WINDOW-ELIGIBLE; isolation CLEAN — PRE-FLIGHT CHECK corrective VERIFIED EFFECTIVE; FIFTEENTH zero-src/-defect; pin 8/8 non-comment-satisfiable; window 23/24/25 CLOSED 0/1]
- Pass 24 adds: +1 (HIGH: 0, MED: 0, LOW: 1, INFO: 0) [**CLEAN — FIRST CLEAN VERDICT IN CYCLE**; ELIGIBLE; SIXTEENTH zero-src/-defect; CI floor 8/8 fourth independent confirmation; window 24/25/26 = 1/3]
- Pass 25 adds: +5 (HIGH: 0, MED: 0, LOW: 3, INFO: 2) [**CLEAN — SECOND CONSECUTIVE**; ELIGIBLE; SEVENTEENTH zero-src/-defect; found three things pass-24 missed; window 24/25/26 = 2/3]
- Pass 26 adds: +5 (HIGH: 0, MED: 1, LOW: 2, INFO: 2) [NOT CLEAN; ELIGIBLE (deviation returned zero results); EIGHTEENTH zero-src/-defect; F-02 MED authorization trail incomplete; F-04 LOW pre-existing ROUTED; window 24/25/26 BROKEN 2/3]
- **Grand total: 197 findings (CRIT: 0, HIGH: 19, MED: 83, LOW: 77, INFO: 18)**

---

## Pass 15 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P15-MED-001 | MEDIUM | GAP · fix-introduced | S-626-1 AC-3 claims omitting EITHER with: block OR env override is silent — only env override is | FIXED — fix round 5 (S-626-1 v1.11) | Round-4-introduced |
| ADV-P15-MED-002 | MEDIUM | GAP · partial-propagation | Blockquote `~:73-79` excludes line 80 (the `run: rustup target add` statement); 4 of 6 sites unfixed | FIXED — fix round 5 (S-626-1 v1.11, S-641-1 v0.7) | Round-4 fixed 2, left 4 |
| ADV-P15-MED-003 | MEDIUM | MIS-ANCHOR | AC-9 anchor `handle_board_view` — symbol does not exist; correct is `handle_view` | FIXED — fix round 5 (S-626-1 v1.11) | Round-4 wrote correct in BC prose, left story wrong |
| ADV-P15-MED-004 | MEDIUM | GAP · fix-introduced | STORY-INDEX arithmetic: frontmatter `total_stories: 123` vs body "122"; changelog gap; wave label wrong | FIXED — fix round 5 (STORY-INDEX v1.5.55) | Round-4 updated frontmatter only |
| ADV-P15-MED-005 | MEDIUM | GAP · spec artifact | S-641-1 AC-2 item 2 three-component normalization rule fails on correct README badge `MSRV-1.85` | FIXED — fix round 5 (S-641-1 v0.7) | Badge carve-out added |
| ADV-P15-MED-006 | MEDIUM | MIS-ANCHOR · trace-unfalsifiable | AC-9 traces to "BC-5.3.001 postcondition 1" / "BC-5.3.002 postcondition 1" — neither BC had Postconditions block; BC-5.3.002 had no Behavior field | FIXED — fix round 5 (bc-5-boards-sprints.md) | Postconditions + Behavior ADDED to BC-5.3.001/002/003 |
| ADV-P15-LOW-001 | LOW | REFINEMENT · propagation-miss | STORY-INDEX S-576-5 row "story v1.47" vs file v1.48; S-576-3 v1.45 vs v1.46 | FIXED — fix round 5 (S-MAINT-576-HYG-1 v1.0) | Version row drift |
| ADV-P15-LOW-002 | LOW | REFINEMENT · fix-introduced | AC-005.txt claimed "All three E0463 comments" — only two exist; release.yml has step at :46 but no comment | FIXED — fix round 5 (demos/) | Round-4-introduced count error |
| ADV-P15-LOW-003 | LOW | REFINEMENT · fix-introduced | INDEX.md Regeneration Log logged `sed -n '40,52p'` for AC-005 release.yml; artifact uses `'38,52p'` | FIXED — fix round 5 (demos/INDEX.md) | Round-4-introduced sed range mismatch |
| ADV-P15-LOW-004 | LOW | GAP · fix-introduced | S-MAINT-576-HYG-1 ARCH-INDEX coverage claimed tests/ covered (wrong); omitted Cargo.toml/build.rs/deny.toml | FIXED — fix round 5 (S-MAINT-576-HYG-1 v1.0) | New story authored by round 4 |
| ADV-P15-LOW-005 | LOW | GAP · fix-introduced | S-MAINT-576-HYG-1 states SS-03 has 8 files; own AC-3 and ARCH-INDEX say 6 | FIXED — fix round 5 (S-MAINT-576-HYG-1 v1.0) | New story internal inconsistency |
| ADV-P15-LOW-006 | LOW | GAP · fix-introduced | S-MAINT-576-HYG-1 `tdd_mode: strict` with `test_files: []` and MUST-NOT forbidding tests/ — unsatisfiable | FIXED — fix round 5 (S-MAINT-576-HYG-1 v1.0) | `tdd_mode: standard`; MUST-NOT removed |
| ADV-P15-LOW-007 | LOW | GAP · fix-introduced | S-MAINT-576-HYG-1 Task 4 instructs 122→123 increment already applied by round 4 (double-increment risk) | FIXED — fix round 5 (S-MAINT-576-HYG-1 v1.0) | Task 4 re-scoped to VERIFY |
| ADV-P15-LOW-008 | LOW | GAP · fix-introduced | S-641-1 AC-2 "three-step" algorithm body enumerates four steps; step 4 missing surrounding quotes | FIXED — fix round 5 (S-641-1 v0.7) | "four-step"; quotes aligned |
| ADV-P15-LOW-009 | LOW | REFINEMENT · drift | S-626-1 BC-table Title column carries enrichment absent from canonical BC-INDEX row and BC H1 | FIXED — fix round 5 (S-626-1 v1.11) | Enrichment moved Title→Scope |
| ADV-P15-LOW-010 | LOW | GAP · test-coverage-claim | Test comment at c88374b4 claimed .not() guards board.rs/list.rs/sprint.rs; observes only sprint.rs; board.rs had NO no-suffix pin | FIXED — product commit 6d73b3ef adds `test_board_view_falls_back_to_uuid_when_team_not_cached`; BC-5.3.003 added to S-626-1 (v1.11) | Test count 2343→2344 |

## Pass 15 Isolation Note

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. Incidental exposure: banned-path filenames (`ci.yml:212-214`, `demos/S-626-1/AC-001.txt:7-8`) appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

## Pass 15 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 6 MEDIUM + 9 LOW; **ZERO HIGH** (tenth consecutive); zero code defects; **TREND REVERSAL 9→15 findings**; 8 of 15 round-4-attributable
- **Post-capture routing:** All 15 findings → fix round 5 (bc-5, S-626-1 v1.11, S-641-1 v0.7 in-version, S-MAINT-576-HYG-1 v1.0 in-version, STORY-INDEX v1.5.55, demos/ re-stamped to 6d73b3ef); product commit 6d73b3ef adds BC-5.3.003 test
- **Convergence:** 0/3 — new window 0/1; passes 16/17 NOT RUN per DEC-209; next window at passes 18/19/20 against head 6d73b3ef
- **BC-5.3.003 DECLARED IN S-626-1:** on product-owner recommendation, BC-5.3.003 added to bcs:/behavioral_contracts:/AC-9 trace (DEC-210)
- **Reviewer recommendation (third consecutive):** STORY-INDEX coherence guard and BC sub-element citation guard would have caught F-03, F-04, F-06, F-07, and F-11 mechanically
- **Detail artifact:** `s-626-1-adversary-pass-15.md`

---

## Passes 16 and 17 — NOT RUN

**Passes 16 and 17 were deliberately NOT RUN.** After pass-15 found 15 findings (trend reversal), the human authorized round 5 and ruled that the next evaluation window should open at passes 18/19/20 against the round-5-amended state. Passes 16 and 17 were superseded before dispatch.

These entries exist to make the numbering gap (15 → 18) explicitly documented, preventing future misreading of the gap as missing or lost artifacts.

| Pass | Status | Reason | Governing Decision |
|------|--------|--------|-------------------|
| 16 | NOT RUN | Superseded by round-5 ruling | DEC-209 (ROUND 5 + PASSES 18/19/20 AUTHORIZED) |
| 17 | NOT RUN | Superseded by round-5 ruling | DEC-209 (ROUND 5 + PASSES 18/19/20 AUTHORIZED) |

**Stub artifacts:** `s-626-1-adversary-pass-16.md`, `s-626-1-adversary-pass-17.md` — NOT window-eligible; NOT counted in convergence trajectory.

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

---

## Pass 18 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P18-MED-001 | MEDIUM | GAP · partial-fix-normative-surface | S-MAINT-576-HYG-1 AC-4 still mandates total_stories re-increment that Task 4 was re-scoped to VERIFY | OPEN — pending fix round 7 | Normative surface conflict; AC-4 overrides Task 4 note |
| ADV-P18-MED-002 | MEDIUM | GAP · sweep-to-class miss | BC-5.3.003 Source field omits new board-view test; AC-9 heading trace omits BC-5.3.003 | OPEN — pending fix round 7 | Fix round 5 swept BC-5.3.002 but missed BC-5.3.003 |
| ADV-P18-MED-003 | MEDIUM | GAP · sweep-to-class miss | STORY-INDEX S-626-1 row left at v1.10; no BC-5.3.003 anchor recorded | FIXED — fix round 6 (STORY-INDEX v1.5.56; S-626-1 v1.12 backfilled; BC-5.3.003 anchor) | |
| ADV-P18-MED-004 | MEDIUM | GAP · version-bump omission | Round-5 edits to S-641-1 and S-MAINT-576-HYG-1 not version-bumped; two disjoint change-sets under one version | OPEN — pending fix round 7 | S-641-1 v0.7 carries two disjoint rounds |
| ADV-P18-MED-005 | MEDIUM | evidence-integrity · orchestrator-authored false justification | Demo clippy/fmt justification "test-only delta, no src/ changes" — false (--all-targets consumes tests/) | FIXED — fix round 6 (demos/ re-stamped at 9312f11f; false justification deleted; genuine re-run output captured) | ORCHESTRATOR-CAUSED |
| ADV-P18-MED-006 | MEDIUM | GAP · partial-file-list · persistent | S-641-1 files_modified omits Cargo.toml; AC-3 + Architecture Mapping + File Structure Requirements all modify it | OPEN — pending fix round 7 (survived four rounds) | |
| ADV-P18-MED-007 | MEDIUM | CI-integrity · [process-gap] | ci.yml test job exits 0 when zero tests discovered — no floor asserted (MOST CONSEQUENTIAL) | FIXED IN-CYCLE — product commit 9312f11f (DEC-211) | POL-11; empirically confirmed reachable |
| ADV-P18-LOW-001 | LOW | GAP · prose-defect · round-5-injected | BC-5.3.003 scope row in S-626-1 claims AC-9 "rewrote" unwrap_or_else — byte-identical except rustfmt re-indentation | OPEN — pending fix round 7 | |
| ADV-P18-LOW-002 | LOW | GAP · prose-defect · round-5-injected | S-641-1 AC-2 README-badge carve-out unanchored on right — substring match admits MSRV-1.85.3 | OPEN — pending fix round 7 | |
| ADV-P18-LOW-003 | LOW | evidence-integrity · transcript-fidelity | INDEX.md Per-AC summary row for AC-9 states "2 new tests" — three other sites say three | OPEN — pending fix round 7 | |

## Pass 18 Isolation Note

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. Incidental exposure: banned-path filenames appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

## Pass 18 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 7 MEDIUM + 3 LOW; **ZERO HIGH** (ELEVENTH consecutive); zero code defects; F-07 FIXED IN-CYCLE (DEC-211); 7 of 10 round-5-attributable; window 0/1 of 18/19/20
- **Post-capture routing:** F-07 (MED-007) FIXED IN-CYCLE product commit 9312f11f; F-05 (MED-005) FIXED fix round 6; F-03 (MED-003) FIXED fix round 6; F-01/F-02/F-04/F-06/F-08/F-09/F-10 OPEN — pending fix round 7
- **Convergence:** 0/3 — window 0/1; passes 19/20 authorized (DEC-212); sweep-to-class failure FIFTH consecutive round; FIRST EVIDENCE OF IMPROVEMENT (grep-derived sweep caught S-640-1 + S-MUTANTS-EXAMINE-GLOBS-1 unprompted)
- **Detail artifact:** `s-626-1-adversary-pass-18.md`

---

## Pass 19 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P19-HIGH-001 | HIGH | CI-integrity / PROCESS-GAP · [process-gap] | POL-11 floor `> 0` is INERT — inline src/ tests keep total above 0 even when all tests/ binaries orphaned | FIXED — fix round 7 (a247a343: binary-count floor -lt 90 + named canary) | ORCHESTRATOR-CAUSED; 4 of 4 CI-as-code defects in 9312f11f |
| ADV-P19-HIGH-002 | HIGH | spec-fidelity / scope-breach · orchestrator-authored | tests/ci_gate_completeness.rs and tests/cli_handler.rs in diff; absent from files_modified, test_files, FSR, STORY-INDEX row | FIXED — fix round 7 (S-626-1 v1.13: all four surfaces updated; DEC-214) | ORCHESTRATOR-CAUSED SCOPE BREACH |
| ADV-P19-MED-001 | MEDIUM | CI-integrity / product-defect | `FAIL (POL-11)` diagnostic UNREACHABLE under set -o pipefail + set -e; binaries var gets two-line value | FIXED — fix round 7 (a247a343: script restructured; diagnostic now reachable) | Part of 4-defect cluster in 9312f11f floor script |
| ADV-P19-MED-002 | MEDIUM | CI-integrity / fragility | Unhardened text parse under CARGO_TERM_COLOR: always — ANSI codes would zero anchored regex [LATENT — NOT a live break] | FIXED — fix round 7 (a247a343: CARGO_TERM_COLOR: never added to step) | Speculation of confirmed CI breakage refuted (9312f11f CI ran SUCCESS) |
| ADV-P19-MED-003 | MEDIUM | CI-integrity / under-specified-pin | Pin asserts only contains("FAIL (POL-11)") — not -eq 0, not exit 1, not Check passed: positive-coverage line | FIXED — fix round 7 (a247a343: pin extended to cover floor, canary, exit 1, positive-coverage) | Part of 4-defect cluster in 9312f11f floor script |
| ADV-P19-MED-004 | MEDIUM | spec-process / PROCESS-GAP · sweep-to-class miss | Round-6 sweep corrected 7 sites in S-MUTANTS-EXAMINE-GLOBS-1.md but missed line ~82 | PARTIALLY CLOSED — 1 site corrected before template-compliance hook blocked; 4 remaining sites BLOCKED; needs conform-to-template | File NOT version-bumped; reported as gap |
| ADV-P19-MED-005 | MEDIUM | spec-fidelity / version-staleness | STORY-INDEX S-641-1 row reads v0.2→v0.6; file was at v0.7 — stale by TWO revisions | FIXED — fix round 7 (STORY-INDEX v1.5.57; S-641-1 v0.7→v0.8; DEC-F07-CLOSED) | |
| ADV-P19-MED-006 | MEDIUM | CI-integrity / PROCESS-GAP · [process-gap] | fmt and clippy jobs share identical orphaning exposure as test job; neither emits runtime count | ROUTED per DEC-215 — real parallel gap; not fixed (would be fourth product-CI change) | Tracked as FMT-CLIPPY-NO-POSITIVE-COVERAGE drift item |
| ADV-P19-LOW-001 | LOW | spec-fidelity / stale-line-cite | S-640-1 cited RUSTUP_TOOLCHAIN ~16 lines from actual location; conflates two distinct steps | FIXED — fix round 7 (S-640-1 v0.5→v0.6: anchor-form migration; two steps cited separately; DEC-213) | |
| ADV-P19-INFO-001 | INFO | evidence-completeness | Floor negative-path proof absent from demo pack at pass-19 dispatch | NOTED — demo pack updated at a247a343 in fix round 7 | Accepted informational |

## Pass 19 Isolation Note

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. Incidental exposure: banned-path filenames appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

## Pass 19 Summary

- **Verdict:** NOT CLEAN — 2 HIGH + 6 MEDIUM + 1 LOW + 1 INFO; **TWELFTH zero-src/-defect pass**; FOUR REAL CI-AS-CODE DEFECTS in orchestrator-shipped POL-11 guard (all closed by a247a343); window 0/2 of 18/19/20
- **Post-capture routing:** HIGH-001+MED-001/002/003 FIXED product commit a247a343; HIGH-002 FIXED fix round 7 (S-626-1 v1.13; DEC-214); MED-005 FIXED fix round 7 (STORY-INDEX v1.5.57; S-641-1 v0.8); LOW-001 FIXED fix round 7 (S-640-1 v0.6; DEC-213); MED-004 PARTIALLY CLOSED (template block); MED-006 ROUTED (DEC-215); INFO-001 NOTED
- **Convergence:** 0/3 — window 0/2; pass-20 pending (head a247a343); anchor migration CLASS-ELIMINATING (DEC-213); ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD + ORCHESTRATOR-UNVERIFIED-BREAK-SPECULATION new drift items
- **Detail artifact:** `s-626-1-adversary-pass-19.md`

---

## Pass 20 — SUPERSEDED

Pass-20 was superseded per DEC-216 before dispatch. Window 18/19/20 CLOSED at 0/2 (required 3/3 CLEAN). No findings. No artifact. DEC-216 opened fresh STRICT window 21/22/23.

---

## Pass 21 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P21-MED-001 | MEDIUM | spec-accuracy / false-claim-in-prose | tests/ci_gate_completeness.rs pin names wrong test + wrong job count (test_ci_gate_named_canary_check DNE; 9-job wrong, correct 8) | FIXED — fix round 8 (84ab32ac) | "correct change, false claim" pattern |
| ADV-P21-MED-002 | MEDIUM | spec-accuracy / false-comment | ci.yml step comment "1 lib + ~54 integration + ~1 doc" sums to 56, not 103 actual test count | FIXED — fix round 8 (84ab32ac) | Comment injected by fix round 7 immediately stale |
| ADV-P21-MED-003 | MEDIUM | spec-accuracy / missing-assertion | Pin docstring claimed `set +o pipefail` was verified; no assert existed — claim was aspirational | FIXED — fix round 8 (84ab32ac) | False docstring; pipefail assertion now present |
| ADV-P21-LOW-001 | LOW | spec-fidelity / sweep-miss | BC-5.3.003 Source field omits `test_board_view_falls_back_to_uuid_when_team_not_cached` | FIXED — fix round 8 (84ab32ac) | Pass-18 MED-002 prescribed sweep; still missed |
| ADV-P21-LOW-002 | LOW | spec-fidelity / count-mismatch | S-626-1 AC-9 heading "adds 2 behavioral contracts"; footer traces 3 BCs | FIXED — fix round 8 (84ab32ac) | BC-5.3.003 added between heading and footer authoring |
| ADV-P21-LOW-003 | LOW | ci-citation / template-drift | S-BC-CITATION-GUARD-1.md contains "live ci.yml line 111" raw line citations | DEFERRED — DEC-217 (template drift blocks edits; placeholder approach DECLINED) | Would require template-compliant full rewrite |
| ADV-P21-INFO-001 | INFO | spec-accuracy / bc-count-drift | bc-02-issue-read.md `bc_count: 94` frontmatter and body "92 BCs" both wrong (correct: 106) | FIXED — fix round 8 (84ab32ac); class sweep caught bc-03 (120→140) simultaneously | Domain-spec count class; DEC-218 directed sweep |

## Pass 21 Isolation Note

**CLEAN.** No banned-path file read. No prior adversary pass artifacts accessed. Incidental exposure: banned-path filenames appeared as quoted text INSIDE in-perimeter files; no content read. Self-disclosed.

## Pass 21 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 3 MEDIUM + 3 LOW + 1 INFO; **ZERO HIGH (THIRTEENTH consecutive zero-src/-defect pass)**; all findings documentation/citation-accuracy class; no src/ code defects; window 0/1 of 21/22/23 (DEC-216 window); passes 22/23 NOT DISPATCHED (window moot after NOT CLEAN); DEC-219 fresh STRICT window = passes 22/23/24
- **Post-capture routing:** MED-001/002/003 + LOW-001/002 + INFO-001 FIXED fix round 8 (84ab32ac); LOW-003 DEFERRED (DEC-217); class sweep (DEC-218) also fixed bc-03 domain-spec count drift
- **Convergence:** 0/3 — fresh STRICT window 22/23/24 (DEC-219); CI floor SOUND all four dimensions; src/ 0-defect THIRTEENTH consecutive; "correct change, false claim" pattern named by reviewer
- **Detail artifact:** `s-626-1-adversary-pass-21.md`

---

## Pass 22 Finding Catalog (VOID — Isolation Breach)

**Pass-22 is VOID for window eligibility per DEC-220.** Findings valid and fixed in round 9 (`7798b1bf`).

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P22-MED-001 | MEDIUM | guard-integrity / pin-prose-satisfiable | POL-11 canary assertion `contains("ci_gate_completeness")` satisfied by COMMENT — not command-unique; threshold `contains("-lt 90")` not bound to `${binaries}` variable | FIXED — fix round 9 (7798b1bf: canary → `grep -q "ci_gate_completeness"` command form; threshold → `"${binaries}" -lt 90`; discrimination proven) | CI floor mechanism itself SOUND (seven dimensions); defect was in regression pin |
| ADV-P22-LOW-002 | LOW | spec-fidelity / stale-residue | Two Round-9 residues in INDEX.md: intro head still `a247a343`; Per-AC AC-003 command still `sed -n '152,179p'` | FIXED — fix round 9 (INDEX.md: intro → `7798b1bf`; AC-003 command → `sed -n '155,182p'`) | Three-surface inconsistency: INDEX head vs Regeneration Log intro vs Per-AC table |
| ADV-P22-LOW-003 | LOW | spec-fidelity / incomplete-audit | S-626-1 FSR + MUST-NOT + STORY-INDEX authorization trail for tests/ci_gate_completeness.rs listed only 2 of 4 commits (missing 84ab32ac + 7798b1bf) | FIXED — fix round 9 (S-626-1 v1.14→v1.15; STORY-INDEX v1.5.59→v1.5.60: 4-commit trail at both body sites + STORY-INDEX row) | Non-blocking (authorization held); incomplete audit record for MUST-NOT exception |

## Pass 22 Isolation Note

**VOID — ORCHESTRATOR DISPATCH DEFECT.** Root-scoped grep at `.factory/` leaked banned content from `ADV-P1-INDEX.md` and `s-626-1-adversary-pass-{9,10,15,18,21}.md`, including prior-pass finding IDs (`ADV-P15-MED-003`), verdicts, and finding tallies. Reviewer disclosed the leak verbatim and unprompted; argued containment (findings derived from primary artifacts BEFORE the grep; leaked material concerned `handle_board_view` and outer-gate coverage, neither cited nor relied on). Per DEC-220, VOID ruling applied on strictest precedent consistent with DEC-206 (passes 9 and 11). Third isolation breach; all three used root-scoped `.factory/` grep; all three self-disclosed unprompted.

## Pass 22 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 2 LOW; zero code defects; **VOID for window** (isolation breach, DEC-220); CI floor SOUND (seven dimensions); FOURTEENTH consecutive zero-src/-defect
- **Post-capture routing:** MED-001 + LOW-002 + LOW-003 FIXED fix round 9 (7798b1bf)
- **Convergence:** 0/3 — window 22/23/24 CLOSED 0/1 (pass-22 VOID); fresh STRICT window passes 23/24/25 (DEC-221); PIN-ASSERTIONS-PROSE-SATISFIABLE class established
- **Detail artifact:** `s-626-1-adversary-pass-22.md`

---

## Pass 23 Finding Catalog

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P23-MED-001 | MEDIUM | citation-hygiene / stale-anchor · orchestrator-scoping-error | ci.yml:~93 comment cites F2 range (~415-426) as "the mutants job F5 fix" — off by ~57 lines; actual F5 fix at ~471-484 | FIXED — fix round 10 (14416fd9: comment converted to structural form `ci.yml :: mutants / "Check kill rate" else branch`; DEC-222; 10-workflow sweep found zero other line-number citations) | Anchor migration stopped at .factory/ boundary; ci.yml's own self-citations omitted |
| ADV-P23-LOW-001 | LOW | spec-accuracy / internal-inconsistency | BC-5.3.001 Behavior reads "both conditions required" but enumerates three (Table mode AND configured field AND ≥1 populated UUID) | FIXED — this burst (bc-5-boards-sprints.md: "both conditions" → "all three conditions"; 6 other count-word sites verified correct; EC-OUT-001 in edge-case-catalog.md correctly left alone) | Carried over from before Table mode was added as third conjunct |

## Pass 23 Isolation Note

**CLEAN.** First pass under the revised PRE-FLIGHT CHECK corrective (replacing the general prohibition). The reviewer enumerated every search root before executing any grep. No call took `.factory` or `.factory/` as its path argument. All searches scoped to specific subdirectories or file paths. No banned content surfaced; nothing to disclose. Corrective verified effective.

## Pass 23 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 1 LOW; WINDOW-ELIGIBLE (isolation CLEAN); **FIFTEENTH consecutive zero-src/-defect pass**; isolation corrective PRE-FLIGHT CHECK VERIFIED EFFECTIVE; CI floor pin 8/8 assertions non-comment-satisfiable (exhaustive table; third independent arithmetic re-derivation)
- **Post-capture routing:** MED-001 FIXED product commit 14416fd9 (stale anchor → structural form; DEC-222); LOW-001 FIXED this burst (.factory/ bc-5-boards-sprints.md "all three conditions")
- **Convergence:** 0/3 — window 23/24/25 CLOSED 0/1 (pass-23 NOT CLEAN; passes 24/25 NOT DISPATCHED); DEC-223 fresh STRICT window passes 24/25/26; anchor-form convention extended to all workflow files (DEC-222)
- **Detail artifact:** `s-626-1-adversary-pass-23.md`

---

## Passes 24/25 — NOT DISPATCHED Within Window 23/24/25 (Historical Record)

Pass-23 (window 23/24/25, DEC-221) returned NOT CLEAN. The window closed at 0/1. Passes 24 and 25 were NOT DISPATCHED within the window 23/24/25 context — dispatching them would carry no convergence credit within that window. Per DEC-223, the fresh STRICT window is passes 24/25/26 (against head 14416fd9). **Passes 24/25/26 were subsequently dispatched under the fresh window DEC-223 and all three ran. See pass finding catalogs below.**

| Pass | Status in window 23/24/25 | Reason | Governing Decision | Subsequent fate |
|------|---------------------------|--------|--------------------|-----------------|
| 24 (of window 23/24/25) | NOT DISPATCHED | Pass-23 NOT CLEAN closed window | DEC-221 + DEC-223 | Dispatched as pass-24 of fresh window DEC-223; returned CLEAN |
| 25 (of window 23/24/25) | NOT DISPATCHED | Pass-23 NOT CLEAN closed window | DEC-221 + DEC-223 | Dispatched as pass-25 of fresh window DEC-223; returned CLEAN |

---

## Pass 24 Finding Catalog (Fresh Window DEC-223: CLEAN — FIRST CLEAN VERDICT)

**Pass-24 is the FIRST CLEAN verdict in the S-626-1 adversary cycle.** ELIGIBLE (two self-disclosed letter-of-rule deviations; zero banned content surfaced). **DEC-224 ISOLATION ELIGIBILITY PRINCIPLE ESTABLISHED.**

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P24-LOW-001 | LOW | documentation-accuracy / positional-description-error | INDEX.md Round-12 section misstates position of comment changed by 14416fd9 (said between binaries=$(…) and # Restore pipefail; actually before binaries=) | FIXED — fix round 11 (`e49230a7`: INDEX.md positional description corrected) | Load-bearing conclusion (GATESCRIPT needs no re-capture) independently verified TRUE; reviewer declined to escalate |

## Pass 24 Isolation Note

**ELIGIBLE.** Two self-disclosed letter-of-rule deviations: (1) Glob with `.factory` as path but NON-RECURSIVE `demos/S-626-1/*` pattern returning only 11 whitelisted artifacts; (2) repo-root grep where ripgrep's default dotted-directory skip returned only `src/` paths. Zero banned content surfaced in either case. Per DEC-224 ISOLATION ELIGIBILITY PRINCIPLE: ELIGIBLE — rule prevents contamination, not path syntax.

## Pass 24 Summary

- **Verdict:** CLEAN — **FIRST CLEAN VERDICT IN THE CYCLE**; isolation ELIGIBLE; SIXTEENTH consecutive zero-src/-defect pass; 1 LOW documentation finding explicitly declined to escalate
- **Post-capture routing:** LOW-001 FIXED fix round 11 (`e49230a7`: INDEX.md positional description corrected; re-stamped to `e49230a7`)
- **Convergence:** window 24/25/26 = 1/3; CI floor 8/8 non-comment-satisfiable (fourth independent confirmation); DEC-224 ISOLATION ELIGIBILITY PRINCIPLE ESTABLISHED
- **Detail artifact:** `s-626-1-adversary-pass-24.md`

---

## Pass 25 Finding Catalog (Fresh Window DEC-223: CLEAN — SECOND CONSECUTIVE)

**Pass-25 is the SECOND consecutive CLEAN verdict.** ELIGIBLE (three Globs anchored at whitelisted subdirs). Found three things pass-24 missed.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P25-LOW-001 | LOW | count-in-prose-drift | ci.yml:109 and mutants_glob_existence.rs:103 claim "17-entry" examine_globs whitelist; actual count is 16 | FIXED — fix round 11 (`e49230a7`: numeral removed from both live sites; three deliberately-retained sites documented) | COUNT-IN-PROSE-DRIFT-CLASS: corrective adopted — remove numeral rather than correct it |
| ADV-P25-LOW-002 | LOW | stale-line-citation / anchor-migration-gap | Rust pin docstring in ci_gate_completeness.rs still cites ci.yml:~124/ci.yml:~137 after anchor migration; ~137 inverted onto wrong command | FIXED — fix round 11 (`e49230a7`: all four ci.yml:~NN citations in docstrings converted to structural form; ~137 inversion corrected) | Anchor migration stopped at .factory/ boundary in round 10; test docstrings not swept |
| ADV-P25-LOW-003 | LOW | spec-accuracy / under-enumeration / test-coverage-gap | BC-5.3.001 Postcondition 1 enumerates TWO cell states while code produces THREE (None => "-" in mixed result set absent) | FIXED (spec) — this burst (bc-5-boards-sprints.md PC1 extended to all three states; BC-5.3.002/003/004 swept CLEAN); test ROUTED | MIXED-SET-DASH-ARM-UNPINNED drift item; test coverage DEC-226 |
| ADV-P25-INFO-001 | INFO | minor-annotation-drift | Stale line-delta annotation in ci_gate_completeness.rs docstring | FIXED — fix round 11 (`e49230a7`) | |
| ADV-P25-INFO-002 | INFO | minor-count-drift | STORY-INDEX embedded present-tense bracket contradicts authoritative count surfaces | FIXED — fix round 11 (STORY-INDEX v1.5.61) | |

## Pass 25 Isolation Note

**ELIGIBLE.** Three Globs used repo root but with patterns anchored at whitelisted subdirectories. No `.factory/`-root file reachable. Zero banned content surfaced; self-disclosed. Per DEC-224: ELIGIBLE.

## Pass 25 Summary

- **Verdict:** CLEAN — SECOND CONSECUTIVE; isolation ELIGIBLE; SEVENTEENTH consecutive zero-src/-defect pass; 3 LOW + 2 INFO; found three things pass-24 missed; LOW-003 most substantive (BC Postcondition under-enumeration)
- **Post-capture routing:** LOW-001/002 + INFO-001 FIXED fix round 11 (`e49230a7`); LOW-003 FIXED (spec) this burst + ROUTED (test, DEC-226); INFO-002 FIXED (STORY-INDEX v1.5.61)
- **Convergence:** window 24/25/26 = 2/3; CI floor 8/8 non-comment-satisfiable (fifth independent confirmation); multi-pass window value concretely demonstrated
- **Detail artifact:** `s-626-1-adversary-pass-25.md`

---

## Pass 26 Finding Catalog (Fresh Window DEC-223: NOT CLEAN — Window BROKEN 2/3)

**Pass-26 broke the window at 2/3.** ELIGIBLE (one deviation returned zero results). F-02 is the substantive finding (authorization trail for third exception-list file). F-04 is pre-existing ROUTED. Forecast: "Expect the next pass to be clean."

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P26-LOW-001 | LOW | count-in-prose-drift / independent-confirmation | "17-entry" examine_globs count confirmed stale — independently confirming pass-25 | FIXED — fix round 11 (`e49230a7`; same fix as P25-LOW-001) | Two of three window passes confirmed this finding |
| ADV-P26-MED-001 | MEDIUM | spec-fidelity / incomplete-audit / partial-propagation | tests/team_column_parity.rs authorization trail names only 1 of 3 commits; line-delta stale (claimed 108; actual 168) | FIXED — fix round 11 (S-626-1 v1.15→v1.16: delta corrected to 168; trail to all 3 commits; STORY-INDEX v1.5.61) | Orchestrator brief wrongly listed 148a9489; story-writer verified and corrected it (self-caught) |
| ADV-P26-INFO-001 | INFO | stale-line-citation / concurrence | ci_gate_completeness.rs docstring ci.yml:~124/~137 citations — concurring with pass-25 | FIXED — fix round 11 (`e49230a7`; same fix as P25-LOW-002) | |
| ADV-P26-LOW-002 | LOW | citation-hygiene / wrong-file-mis-anchor / pre-existing | tests/issue_view_errors.rs:142 cites list.rs:947 for string at view.rs:264/269; tests/team_object_shape.rs cites list.rs:983 for call at ~528 | ROUTED — pre-existing, outside S-626-1 diff | WRONG-FILE-MIS-ANCHORS-IN-TESTS drift item; spec layer correct; test comments are unswept siblings |
| ADV-P26-INFO-002 | INFO | minor-count-drift / concurrence | STORY-INDEX embedded stale count — concurring with pass-25 | FIXED — fix round 11 (STORY-INDEX v1.5.61; same fix as P25-INFO-002) | |

## Pass 26 Isolation Note

**ELIGIBLE.** One self-disclosed deviation: repo-root grep with exclusion pattern returned **"No matches found"** — zero results, no content read. Zero banned content surfaced. Per DEC-224: ELIGIBLE.

## Pass 26 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 2 LOW + 2 INFO; ELIGIBLE; EIGHTEENTH consecutive zero-src/-defect pass; window 24/25/26 BROKEN 2/3; F-02 (authorization trail incomplete) closes with fix round 11; F-04 (pre-existing wrong-file mis-anchor) ROUTED
- **Post-capture routing:** MED-001 + LOW-001 + INFO-001/002 FIXED fix round 11 (`e49230a7`); LOW-002 ROUTED (WRONG-FILE-MIS-ANCHORS-IN-TESTS drift item)
- **Convergence:** 0/3 — fresh STRICT window = passes 27/28/29 (0/3, not yet dispatched); CI floor 8/8 non-comment-satisfiable (sixth independent confirmation); forecast: next pass CLEAN
- **Detail artifact:** `s-626-1-adversary-pass-26.md`

---

## Window 27/28/29 Overview (Fresh Window DEC-225, against frozen head `e49230a7`)

Three concurrent independent reviewers dispatched against the same frozen head. Result: **CLOSED 1/3, BROKEN** (pass-27 CLEAN; pass-28 NOT CLEAN; pass-29 NOT CLEAN). All three ELIGIBLE per DEC-224 — each self-disclosed the same two letter-of-rule isolation deviations (a WebFetch of the pinned `dtolnay/rust-toolchain` `action.yml`, and reads of third-party crate sources under `~/.cargo/registry`), both outside the four whitelisted search roots but neither a banned path; zero banned content (prior-pass verdicts, finding tallies) surfaced in any of the three. PRE-FLIGHT CHECK verified effective for a **seventh consecutive pass**. All 15 new findings are spec-declaration class — **zero `src/` defects** (src/ 0-defect NINETEENTH consecutive). Full itemization: 1 MEDIUM + 3 LOW substantive findings, plus 11 INFO-severity findings fully itemized below (4 CLOSED by fix round 12, 7 OPEN as disclosed limitations or deferred observations). Three cross-pass concurrences are called out where they occur: P27-INFO-003 ↔ P29-INFO-001 (MSRV scope limitation), P27-INFO-002 ↔ P28-INFO-001 (docstring overclaim), P28-INFO-004 ↔ P29-INFO-003 (`--locked`).

## Pass 27 Finding Catalog (Fresh Window DEC-225: CLEAN)

**Pass-27 returned CLEAN — the window's only CLEAN verdict.** ELIGIBLE (two self-disclosed letter-of-rule deviations; zero banned content surfaced). Zero MEDIUM/LOW findings; four INFO-severity confirmation/concurrence entries.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P27-INFO-001 | INFO | ci-config/cache-efficiency | `ci.yml` msrv job: `Swatinem/rust-cache` runs before the step-scoped `RUSTUP_TOOLCHAIN` takes effect, so its cache key derives from `rust-toolchain.toml` (stable) while `cargo check` builds under 1.85.0; pre-fix both were stable, the fix newly desynchronizes them | OPEN — no action; cache-hit-rate cost only, no correctness impact (cargo's fingerprint includes rustc version; rust-cache key includes job id) | Noted for any future msrv-job-runtime investigation |
| ADV-P27-INFO-002 | INFO | guard-assertion-precision | `test_verify_test_job_has_zero_test_floor`: two of eight assertions (`FAIL (POL-11)` 3×, `exit 1` 3×) match multi-occurrence substrings and are in principle comment-satisfiable; the other six occur exactly once in operative position so the guard holds | CLOSED — fix round 12 (`1e696128`: docstring scoped; `exit 1` deliberately left coarse with reasoning documented inline) | Concurs with ADV-P28-INFO-001 |
| ADV-P27-INFO-003 | INFO | disclosed-limitation | MSRV floor is enforceable only over lib+bins; a let-chain in an inline `#[cfg(test)]` module in `src/` or anywhere in `tests/` is not caught. Alternative blocked — `--all-targets` fails at 1.85 on `wiremock 0.6.5` | OPEN — accurately disclosed in both `ci.yml` and `CLAUDE.md`; limitation, not defect | Concurs with ADV-P29-INFO-001 |
| ADV-P27-INFO-004 | INFO | `[process-gap]` orchestrator-dispatch | Orchestrator briefing described `tests/ci_gate_completeness.rs` as "new, 186 lines"; it is a MODIFY (+186 to a pre-existing 937-line file on origin/develop), derived from `git diff --stat` without a base-branch existence check | OPEN — pass-27 scoped via `git diff` and was not misled; no pass affected | Recorded as drift item BRIEFING-DERIVED-FROM-DIFFSTAT-MISCLASSIFIES-FILES |

## Pass 27 Isolation Note

**ELIGIBLE.** Two self-disclosed letter-of-rule deviations: (1) a WebFetch of the pinned `dtolnay/rust-toolchain` `action.yml`; (2) reads of third-party crate sources under `~/.cargo/registry`. Both outside the four whitelisted search roots but neither a banned path. Zero banned content surfaced. Per DEC-224: ELIGIBLE.

## Pass 27 Summary

- **Verdict:** CLEAN — 0 HIGH + 0 MEDIUM + 0 LOW + 4 INFO (1 CLOSED, 3 OPEN); ELIGIBLE; NINETEENTH consecutive zero-src/-defect pass; PRE-FLIGHT CHECK effective for a seventh consecutive pass
- **Post-capture routing:** 4 of 11 window INFO findings CLOSED by fix round 12 (P27-002, P28-001, P28-004, P29-003); 7 remain OPEN (P27-001, P27-003, P27-004, P28-002, P28-003, P29-001, P29-002). This pass: INFO-002 CLOSED fix round 12 (docstring scoping); INFO-001/003 OPEN as disclosed limitations; INFO-004 OPEN as BRIEFING-DERIVED-FROM-DIFFSTAT-MISCLASSIFIES-FILES drift item
- **Convergence:** window 27/28/29 = 1/3 at this point; CI floor soundness independently reconfirmed (contributes to nine-total confirmations)
- **Detail artifact:** `s-626-1-adversary-pass-27.md` (not yet captured as a standalone file at burst time)

---

## Pass 28 Finding Catalog (Fresh Window DEC-225: NOT CLEAN — Window BROKEN)

**Pass-28 broke the window at 1/3.** ELIGIBLE (same two self-disclosed deviations as pass-27). One substantive LOW finding; four INFO-severity confirmation/concurrence entries. Pass-28 additionally extracted the guard's shell logic and ran it in isolation against synthetic and empty capture files, independently proving the `set +o pipefail` bracket is load-bearing (contributes to the ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD confirmation tally).

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P28-LOW-001 | LOW | test-coverage-gap / regression-pin-absent | msrv job's `RUSTUP_TOOLCHAIN` env override had no regression pin — nothing in the tree previously failed if `ci.yml`'s msrv job dropped it, though it is the load-bearing half of the fix that makes the job compile at 1.85.0 instead of silently falling through to `rust-toolchain.toml`'s stable channel | FIXED — fix round 12 (product commit `1e696128`: added `tests/ci_gate_completeness.rs::test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env`; proven RED on removal of the block, GREEN on exact restore, `ci.yml` byte-identical after) | |
| ADV-P28-INFO-001 | INFO | guard-docstring-overclaim | `test_verify_test_job_has_zero_test_floor` docstring claimed "every assertion targets a form that can ONLY appear in the operative command"; three of its own assertions (`FAIL (POL-11)`, `Check passed:`, `exit 1`) do not meet that bar | CLOSED — fix round 12 (`1e696128`: scoped to "TWO of the assertions below"; the three coarser pins now explicitly named) | Concurs with ADV-P27-INFO-002 |
| ADV-P28-INFO-002 | INFO | comment-accuracy | `ci.yml` `test` job `CARGO_TERM_COLOR: never` comment (~:57) and mirrored docstring (~:780) assert a concrete break that would not occur — libtest emits the summary as a plain `"\ntest result: "` prefix and colorizes only the following token, so the anchored grep holds even under `--color=always` | OPEN — override is harmless and defensively reasonable; suggested rewording to defensive-hardening framing, not applied in round 12 | |
| ADV-P28-INFO-003 | INFO | dead-code | `tests/ci_gate_completeness.rs` ~:533-534, ~:610, ~:614: three dead sub-conditions — `starts_with("    if:") && !starts_with("        ")` (and the `"    steps:"` variant) is unconditionally true in its second conjunct; `step_if_indent` (~:680) is a `let mut` only ever assigned constant `8` | OPEN — harmless; implies a distinction the code is not making; not applied in round 12 | |
| ADV-P28-INFO-004 | INFO | spec-declaration | `ci.yml` msrv job gained `--locked` undeclared; AC-2/AC-3 specified only the SHA swap, `with: {toolchain}`, and `env: {RUSTUP_TOOLCHAIN}` | CLOSED — fix round 12 (declared in AC-3 tied to AC-8; ci.yml File Structure row extended; CHANGELOG line added) | Corroborated independently by ADV-P29-INFO-003 — cross-pass concurrence is why an INFO was promoted into the fix round |

## Pass 28 Isolation Note

**ELIGIBLE.** Two self-disclosed letter-of-rule deviations, same class as pass-27: (1) WebFetch of the pinned `dtolnay/rust-toolchain` `action.yml`; (2) reads of third-party crate sources under `~/.cargo/registry`. Zero banned content surfaced. Per DEC-224: ELIGIBLE.

## Pass 28 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 1 LOW + 4 INFO (2 CLOSED, 2 OPEN); ELIGIBLE; NINETEENTH consecutive zero-src/-defect pass (concurring with pass-27)
- **Post-capture routing:** 4 of 11 window INFO findings CLOSED by fix round 12 (P27-002, P28-001, P28-004, P29-003); 7 remain OPEN (P27-001, P27-003, P27-004, P28-002, P28-003, P29-001, P29-002). This pass: LOW-001 + INFO-001 + INFO-004 FIXED/CLOSED fix round 12 (`1e696128`); INFO-002 OPEN (rewording suggested, not applied); INFO-003 OPEN (dead-code, not applied)
- **Convergence:** window 27/28/29 BROKEN at 1/3 as of this pass; CI floor soundness independently reconfirmed via isolated shell-logic testing (eighth of nine total confirmations)
- **Detail artifact:** `s-626-1-adversary-pass-28.md` (not yet captured as a standalone file at burst time)

---

## Pass 29 Finding Catalog (Fresh Window DEC-225: NOT CLEAN — Window CLOSED 1/3)

**Pass-29 closed the window at 1/3.** ELIGIBLE (same two self-disclosed deviations as passes 27/28). One MEDIUM + two LOW substantive findings; three INFO-severity confirmation/concurrence entries.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P29-MED-001 | MEDIUM | spec-declaration / undeclared-file-modification | `tests/mutants_glob_existence.rs` was modified (commit `e49230a7`: stale hard-coded count corrected, `all 11 current examine_globs entries` → `all current examine_globs entries`) but undeclared on all four story surfaces (`files_modified`, `test_files`, File Structure Requirements, MUST-NOT-change exception list), violating the story's own MUST-NOT clause | FIXED — this burst (S-626-1 v1.16→v1.17: declared on all four surfaces following the same pattern used for `tests/ci_gate_completeness.rs`/`tests/cli_handler.rs` in v1.13) | |
| ADV-P29-LOW-001 | LOW | spec-completeness / uncovered-behavior | The ~120-line POL-11 test-job guard in `ci.yml`'s `test` job (product commits `9312f11f`+`a247a343`+`84ab32ac`) is the largest single behavioral change in the delta, gates the required `ci-gate` check, and had no acceptance criterion | FIXED — this burst (S-626-1 v1.17: new AC-10 covering the binary-count floor, named canary, zero-test floor, `CARGO_TERM_COLOR: never` override, and pipefail-bracketing mechanics; `acceptance_criteria_count` 9→10; BC-X.13.007 minted and anchored in v1.18 closing the AC-10 BC-anchoring gap) | |
| ADV-P29-LOW-002 | LOW | citation-hygiene / dangling-citation | `F-07` citation in `ci_gate_completeness.rs`'s docstring pointed at nothing resolvable | FIXED — fix round 12 (product commit `1e696128`: citation re-pointed to AC-10 / BC-X.13.007; docstring overclaim scoped to the 2 of 5 assertions that are genuinely comment-proof) | |
| ADV-P29-INFO-001 | INFO | disclosed-limitation | MSRV floor genuinely unenforceable for `src/` inline `#[cfg(test)]` modules and all of `tests/`; confirmed empirically — `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-targets --all-features --locked` fails `error[E0658]` at `wiremock-0.6.5/src/matchers.rs:214`/`:215` | OPEN — accurately disclosed | Concurs with ADV-P27-INFO-003 |
| ADV-P29-INFO-002 | INFO | pre-existing-guard-slack | `tests/mutants_glob_existence.rs::assert_examine_globs_coverage_floor`: `FLOOR = 11` against 16 live `examine_globs` entries in `.cargo/mutants.toml` — tolerates 5 silent removals before firing | OPEN — pre-existing, not introduced by this delta; noted only because the same commit touched the file; candidate for follow-up | |
| ADV-P29-INFO-003 | INFO | spec-declaration | `ci.yml` msrv `--locked` undocumented; AC-3 specified only the `env:` addition and neither CHANGELOG nor CLAUDE.md mentioned it | CLOSED — fix round 12 | Concurrence with ADV-P28-INFO-004 |

## Pass 29 Isolation Note

**ELIGIBLE.** Two self-disclosed letter-of-rule deviations, same class as passes 27/28: (1) WebFetch of the pinned `dtolnay/rust-toolchain` `action.yml`; (2) reads of third-party crate sources under `~/.cargo/registry`. Reviewer additionally encountered prior adversary finding IDs (M-001, LOW-003, F-05, F-01/02/03) while reading `.factory/stories/S-626-1.md`'s `risk_mitigations` version trail — a whitelisted path — and self-disclosed using them only for scope declarations, not to bias severity. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE. **New drift item opened: ISOLATION-WHITELIST-LEAKS-FINDING-IDS (the whitelist itself carries prior finding IDs through an explicitly allowed path — structural, will recur every window; orchestrator-caused, does not invalidate the pass).**

## Pass 29 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 2 LOW + 3 INFO (1 CLOSED, 2 OPEN); ELIGIBLE; NINETEENTH consecutive zero-src/-defect pass (concurring with passes 27/28); window 27/28/29 CLOSED 1/3
- **Post-capture routing:** 4 of 11 window INFO findings CLOSED by fix round 12 (P27-002, P28-001, P28-004, P29-003); 7 remain OPEN (P27-001, P27-003, P27-004, P28-002, P28-003, P29-001, P29-002). This pass: MED-001 + LOW-001 FIXED this burst (spec-side); LOW-002 + INFO-003 FIXED/CLOSED fix round 12 (`1e696128`); INFO-001 OPEN (disclosed MSRV-scope limitation); INFO-002 OPEN (pre-existing coverage-floor tolerance)
- **Convergence:** window 27/28/29 CLOSED 1/3 (pass-27 CLEAN; pass-28 NOT CLEAN; pass-29 NOT CLEAN). Fresh STRICT window = passes 30/31/32 (DEC-227) against frozen head `1e696128`, designated but not yet dispatched, pending human go-ahead. CI floor 8/8 non-comment-satisfiable (ninth and final independent confirmation this window)
- **Detail artifact:** `s-626-1-adversary-pass-29.md` (not yet captured as a standalone file at burst time)

---

## Window 27/28/29 Summary

- **Result:** CLOSED 1/3, BROKEN. Pass-27 CLEAN/ELIGIBLE; pass-28 NOT CLEAN/ELIGIBLE (1 LOW); pass-29 NOT CLEAN/ELIGIBLE (1 MEDIUM + 2 LOW). 15 new findings total (0H + 1M + 3L + 11I).
- **INFO tally:** 11 INFO findings fully itemized. 4 CLOSED by fix round 12 (ADV-P27-INFO-002, ADV-P28-INFO-001, ADV-P28-INFO-004, ADV-P29-INFO-003); 7 OPEN (ADV-P27-INFO-001/003/004, ADV-P28-INFO-002/003, ADV-P29-INFO-001/002) as disclosed limitations, deferred observations, or routed process-gap drift items. Three cross-pass concurrences: P27-INFO-003 ↔ P29-INFO-001 (MSRV scope limitation, independently confirmed empirically by pass-29); P27-INFO-002 ↔ P28-INFO-001 (docstring overclaim, same defect independently found); P28-INFO-004 ↔ P29-INFO-003 (`--locked` undeclared, two independent reviewers — the reason it was promoted into the fix round despite INFO severity).
- **src/ defects:** zero. All four substantive findings are spec-declaration class (undeclared file modification, uncovered behavior/missing AC, dangling citation, missing regression pin) — none touch `src/`. src/ 0-defect streak extends to NINETEENTH consecutive pass.
- **Fix round 12:** applied. Product head `e49230a7` → `1e696128` (two commits touching only `CHANGELOG.md` + `tests/ci_gate_completeness.rs`). Spec side: S-626-1 v1.16→v1.18 (AC-10 added + declared surfaces + BC-X.13.007 minted/anchored); BC totals 657→658.
- **Fresh window:** passes 30/31/32 against frozen head `1e696128` (DEC-227), designated but not yet dispatched, pending human go-ahead.

---
