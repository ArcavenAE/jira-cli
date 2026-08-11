---
document_type: adversarial-review-index
level: ops
version: "2.18"
status: closed-merged
producer: adversary
timestamp: 2026-08-11T06:15:00Z
phase: "5"
pass: 61
inputs: [.factory/stories/S-626-1.md, .factory/stories/S-CIGATE-1-ci-gate-aggregator.md, .factory/stories/S-CIGATE-2-skipped-status-false-green.md, .factory/stories/S-640-1.md, .factory/stories/S-641-1.md, .factory/stories/S-MUTANTS-EXAMINE-GLOBS-1.md, .factory/stories/S-TRAIL-DERIVATION-GUARD-1.md, .factory/stories/STORY-INDEX.md, .factory/specs/prd/cross-cutting.md, .github/workflows/ci.yml, tests/ci_gate_completeness.rs, tests/cli_handler.rs, tests/common/yaml.rs, tests/mutants_glob_existence.rs, scripts/check-ci-gate.sh, docs/specs/cargo-mutants-policy.md, CLAUDE.md, Cargo.toml, CHANGELOG.md, live CI run 30465686049, live CI run 31406705091 (pass-57/58/59 fix-round CI-break), live CI run 31432422878 (develop post-merge), live CI run 31450052302 (develop post-PR675-merge), branch protection API, PyYAML 6.0.3 (pass-55 differential), standalone rustc reproductions (pass-56/57), Ruby Psych (pass-57), sibling ci.yml re-indent sweep (pass-57), scratch-tree per-mutation rebuilds (pass-58), 7 mutated ci.yml copies replayed against real pin extractors (pass-59), delta `1381af17..5ca51bc2` (pass-60/61), PR #675 diff `a5e1d087..d55bedf7` (ADV-P675, CLAUDE.md + scripts/check-ci-gate.sh comment/prose only), research/ci-gate-shell-trust-assumptions-2026-08-10.md (ADV-P675 primary-source cross-check)]
traces_to: .factory/stories/S-626-1.md
total_findings: 488
severity_distribution: { CRIT: 0, HIGH: 36, MED: 143, LOW: 175, INFO: 134 }
story: S-626-1
cycle: cycle-001
feature_head: 5ca51bc2 (last commit reviewed by any adversarial pass before merge; merge commit is `a5e1d087` on `develop`, squash of 48 commits; feature branch progression this burst's review scope: `1381af17`→`a17939e2`(pass-57/58/59 class sweep)→`f2bea32e`(CI-BREAK-1 fix)→`5ca51bc2`(DEC-261 doc corrections, reviewed by pass-60/61)→PR #667 squash-merged to `develop` as `a5e1d087`)
pr: 667 (MERGED to develop as `a5e1d087` 2026-08-10T21:08:10Z, closes #626; remote branch `ci/fix-toolchain-sha-msrv` auto-deleted)
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute)
convergence: 0 of 3 FINAL — Step 4.5 window closed permanently at 0/3 (DEC-262 authorized merge on code grounds without ever reaching 3/3 CLEAN, after ten windows and 61 total adversary passes). Window 57/58/59 CLOSED 0/3 — pass-57 NOT CLEAN (1H+2M+2L+4I), pass-58 NOT CLEAN (0H+2M+3L+3I), pass-59 NOT CLEAN (0H+0M+1L+5I); three deliberately-varied inspection frontiers, human-approved before dispatch per DEC-254 (C1-lexer differential conformance, C5-falsifiability census of the new pins, C3-side-channels — inter-step side channels inside `ci-gate`, a frontier never probed in 56 prior passes) against frozen head `1381af17`; TENTH consecutive window without 3/3 since window 30/31/32; all 23 findings closed same-burst as a single class sweep, commit `a17939e2` (DEC-255), which itself broke CI (DEC-257, fixed by `f2bea32e`) rather than a fix round against a frozen head. **Passes 60/61 (this update) were TARGETED DELTA REVIEWS, not a STRICT Step-4.5 window** — dispatched because the human asked whether #667 was fully reviewed rather than whether CI was green; they covered `1381af17..5ca51bc2` (1,024 insertions no prior pass had seen) and found/closed 3 HIGH + 3 LOW findings pre-merge. Not counted toward Step 4.5's 3/3 window arithmetic. See Passes 60/61 Summary below. **ADV-P675 (2026-08-11) was a further TARGETED CLAIM-ACCURACY REVIEW, also not a Step-4.5 window** — dispatched pre-merge against PR #675 (`a5e1d087..d55bedf7`, doc-only correction of the S-626-1 trust-layer record), on the reasoning that a doc comment IS the operative control for several recorded residuals in this repository. 0H/2M/2L/1I, NOT CLEAN; all 4 actionable findings amended in `d2430a8a` before merge. See Pass ADV-P675 section below. Window 54/55/56's own convergence detail (pass-54/55/56 verdicts, frontiers, isolation notes) is preserved unchanged further down in this file.
void_spawns: 6 (passes 6/7/8 first-attempt background subagents; pass-9 isolation breach; pass-11 isolation breach; pass-22 isolation breach)
not_run: 2 (passes 16/17 — superseded by round-5 ruling per DEC-209; see s-626-1-adversary-pass-16.md and s-626-1-adversary-pass-17.md)
superseded: 1 (pass-20 — superseded per DEC-216; window 18/19/20 CLOSED 0/2)
not_dispatched: 6 (passes 22/23 of window 21/22/23 — superseded when pass-21 returned NOT CLEAN; passes 23/24 of window 22/23/24 — superseded when pass-22 returned VOID+NOT CLEAN; passes 24/25 of window 23/24/25 — superseded when pass-23 returned NOT CLEAN; passes 24/25/26 subsequently dispatched under fresh window DEC-223 and ran)
---

# Adversarial Review Index — S-626-1 (SOH-DX-1) Passes 1..38

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

## Pass 30 Finding Catalog (Fresh Window DEC-227: NOT CLEAN)

Pass-30 opened window 30/31/32 NOT CLEAN, run against frozen head `1e696128`. ELIGIBLE per DEC-224 (self-disclosed external reads: pinned `action.yml` fetch, `~/.cargo/registry` crate sources). Reviewer was told up front about the ISOLATION-WHITELIST-LEAKS-FINDING-IDS defect and instructed to treat story-changelog finding IDs as scope declarations only. One MEDIUM + four LOW substantive findings; two INFO-severity disclosed-limitation entries.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P30-MED-001 | MEDIUM | spec-citation/mis-anchor | `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` anchored to AC-10/BC-X.13.007 at three sites (banner ~:952, docstring ~:956, panic ~:995); both cover the `test` job, not `msrv`. BC-X.13.007's Invariants explicitly fence it to the `test` job; its VP-CIGATE-001 names only the other test. Correct anchor is AC-3. Mis-anchor was user-visible in CI failure output. | FIXED — fix round 13 (`c2093a73` retargeted all three to AC-3; v1.19 added AC-3 verification vehicle) | Concurs ADV-P32-MED-001 |
| ADV-P30-LOW-001 | LOW | `[process-gap]` authorization-trail-incomplete | `ci_gate_completeness.rs` trail listed 4 commits; 5 actual at that head; FSR Purpose named only one test fn | FIXED — fix round 13 (v1.19, all 8 commits at both sites) | |
| ADV-P30-LOW-002 | LOW | undeclared-scope | Three undeclared surfaces: `CLAUDE.md:163` Conventions "No let-chains" bullet; `ci.yml` msrv ~:169-179 scope-rationale comment block; `CHANGELOG.md` 3 entries delivered vs 1 declared by Task 7c | FIXED — fix round 13 (v1.19 AC-6/AC-9 + FSR rows) | Concurs ADV-P31-LOW-002/ADV-P32-LOW-001 |
| ADV-P30-LOW-003 | LOW | `[process-gap]` stale-evidence | Story states 2345 passed; measured 2346 at frozen head. Figure previously corrected four times (2341→2343→2344→2345) | FIXED — fix round 13 (v1.19 → 2346, now platform- and commit-anchored) | Concurs ADV-P31-LOW-003/ADV-P32-LOW-002 |
| ADV-P30-LOW-004 | LOW | self-falsifying-docstring | Docstring claims `grep -rn "RUSTUP_TOOLCHAIN" tests/*.rs` returns zero hits; returns 6, all in that same file — the asserting sentence is itself a hit | FIXED — fix round 13 (`c2093a73` re-tensed, command parenthetical dropped) | Concurs ADV-P31-LOW-001/ADV-P32-LOW-003 |
| ADV-P30-INFO-001 | INFO | guard-assertion-precision | 4 of 8 assertions in `test_verify_test_job_has_zero_test_floor` are echo/comment-satisfiable; docstring discloses this accurately | OPEN — disclosed, guard carries its weight | Concurs ADV-P31-INFO-003/ADV-P32-INFO-002 |
| ADV-P30-INFO-002 | INFO | disclosed-limitation | MSRV floor excludes `src/` inline `#[cfg(test)]` and all `tests/`; blocked by wiremock 0.6.5 needing ≥1.88 | OPEN — disclosed in `ci.yml` + `CLAUDE.md` | Concurs ADV-P32-INFO-001 |

## Pass 30 Isolation Note

**ELIGIBLE.** Self-disclosed letter-of-rule deviations, same class as passes 27/28/29: (1) pinned `action.yml` fetch; (2) reads of third-party crate sources under `~/.cargo/registry`. Reviewer was told up front about the ISOLATION-WHITELIST-LEAKS-FINDING-IDS defect and instructed to treat story-changelog finding IDs as scope declarations only. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 30 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 4 LOW + 2 INFO (0 CLOSED, 2 OPEN); ELIGIBLE; src/ 0-defect TWENTIETH consecutive pass
- **Post-capture routing:** 5 substantive findings (1 MED + 4 LOW) FIXED fix round 13; 2 INFO OPEN as disclosed limitations
- **Convergence:** window 30/31/32 opens NOT CLEAN
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 31 Finding Catalog (Fresh Window DEC-227: NOT CLEAN)

Pass-31 continued window 30/31/32 NOT CLEAN, run against frozen head `1e696128`. ELIGIBLE, same class as pass-30 (self-disclosed pinned `action.yml` fetch + `~/.cargo/registry` reads; whitelist-leak defect disclosed up front). Three LOW + three INFO findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P31-LOW-001 | LOW | self-falsifying-docstring | Same as P30-LOW-004; verified 6 hits at lines 968/972/977/1010/1012/1014 | FIXED — fix round 13 (`c2093a73`) | Concurs ADV-P30-LOW-004 |
| ADV-P31-LOW-002 | LOW | undeclared-scope | `CLAUDE.md:163` Conventions bullet (normative repo-wide policy) + `ci.yml:171-180` scope-rationale block; both correct in substance (verified wiremock let-chain at `matchers.rs:215`) but unauthorized by AC-6/AC-3/AC-4 or the FSR rows | FIXED — fix round 13 (v1.19) | Concurs ADV-P30-LOW-002 |
| ADV-P31-LOW-003 | LOW | stale-evidence | 2345 → 2346 at three sites (AC-9, Task 7d, AC-10 acceptance check) | FIXED — fix round 13 (v1.19) | Concurs ADV-P30-LOW-003 |
| ADV-P31-INFO-001 | INFO | `[process-gap]` overstated-rationale | AC-3 + CHANGELOG claim `--locked` reinforces the exact `comfy-table = "=7.2.1"` pin; with an exact `=` pin cargo cannot re-resolve that crate with or without `--locked`. Real value is preventing re-resolution of other/transitive deps | FIXED — fix round 13 (`c2093a73` CHANGELOG + v1.19 AC-3) | |
| ADV-P31-INFO-002 | INFO | ci-validation-gap | Frozen head `1e696128` had NO CI run; the 15/15 green belonged to parent `e49230a7`. Branch was ahead-1 unpushed | RESOLVED — fix round 13 (branch pushed; head `0adcae34` CI 15/15 green, 0 pending, 0 failed, mergeStateStatus CLEAN) | |
| ADV-P31-INFO-003 | INFO | guard-assertion-precision | 3 of 7 assertions echo-satisfiable; docstring accurate; load-bearing ones confirmed by perturbation | OPEN — disclosed | Concurs ADV-P30-INFO-001/ADV-P32-INFO-002 |

## Pass 31 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as pass-30. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 31 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 3 LOW + 3 INFO (2 FIXED/RESOLVED, 1 OPEN); ELIGIBLE; src/ 0-defect TWENTIETH consecutive pass (concurring with pass-30)
- **Post-capture routing:** 3 LOW + 2 INFO FIXED/RESOLVED fix round 13; 1 INFO OPEN
- **Convergence:** window 30/31/32 remains NOT CLEAN at this point
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 32 Finding Catalog (Fresh Window DEC-227: NOT CLEAN — Window CLOSED 0/3)

Pass-32 closed window 30/31/32 at 0/3, run against frozen head `1e696128` — the worst window of the cycle. ELIGIBLE, same class as passes 30/31. Two MEDIUM + three LOW + three INFO findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P32-MED-001 | MEDIUM | spec-citation/mis-anchor | Same as P30-MED-001; verified by grepping BC-X.13.007's body for `msrv\|rustup\|1\.85\|toolchain` → zero matches | FIXED — fix round 13 (`c2093a73`) | Concurs ADV-P30-MED-001 |
| ADV-P32-MED-002 | MEDIUM | undeclared-scope/freeze-commit | The freeze commit shipped behavior outside every declared surface: (a) `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` appeared nowhere in the story; (b) `ci_gate_completeness.rs` modified by 6 branch commits, trail listed 4; (c) CHANGELOG delivered 3 entries, Task 7c declared 1. Reviewer noted this is the identical class FIX ROUND 12 declared swept, recurring inside the commit that closed that round | FIXED — fix round 13 (v1.19: AC-3 vehicle, 8-commit trail, CHANGELOG row widened) | |
| ADV-P32-LOW-001 | LOW | undeclared-scope | `CLAUDE.md:163` Conventions bullet + three in-code comments (`board.rs:231`, `list.rs:523`, `keychain.rs:50`); AC-6 authorizes only a Gotchas entry, AC-9 authorizes the rewrite not commentary | FIXED — fix round 13 (v1.19) | Concurs P30-LOW-002/P31-LOW-002 |
| ADV-P32-LOW-002 | LOW | stale-evidence | 2345 → 2346 | FIXED — fix round 13 | Concurs P30-LOW-003/P31-LOW-003 |
| ADV-P32-LOW-003 | LOW | self-falsifying-docstring | Same | FIXED — fix round 13 | Concurs P30-LOW-004/P31-LOW-001 |
| ADV-P32-INFO-001 | INFO | disclosed-limitation | MSRV scope excludes inline `#[cfg(test)]`/`tests/` | OPEN | Concurs P30-INFO-002 |
| ADV-P32-INFO-002 | INFO | guard-assertion-precision | 3 of 7 echo-satisfiable, disclosed | OPEN | Concurs P30-INFO-001/P31-INFO-003 |
| ADV-P32-INFO-003 | INFO | `[process-gap]` missing-verification-vehicle | AC-3 had no declared verification vehicle, and its own text hedged the `with: {toolchain}` claim as "routed, not verified against action.yml" — a claim all three reviewers independently verified TRUE by fetching the pinned `action.yml` (`toolchain: required: true`, explicit `exit 1` on empty, `actions/runner#1070`) | FIXED — fix round 13 (v1.19: vehicle added, hedge discharged) | |

## Pass 32 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as passes 30/31. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 32 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 2 MEDIUM + 3 LOW + 3 INFO (1 FIXED, 2 OPEN); ELIGIBLE; src/ 0-defect TWENTIETH consecutive pass (concurring with passes 30/31); window 30/31/32 CLOSED 0/3
- **Post-capture routing:** 5 substantive findings (2 MED + 3 LOW) FIXED fix round 13; 2 INFO OPEN
- **Convergence:** window 30/31/32 CLOSED 0/3 (pass-30 NOT CLEAN; pass-31 NOT CLEAN; pass-32 NOT CLEAN) — worst window of the cycle (window trajectory 24/25/26=2/3 → 27/28/29=1/3 → 30/31/32=0/3)
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Window 30/31/32 Summary

- **Result:** CLOSED 0/3, BROKEN. Zero CLEAN verdicts — worst window of the cycle. Window trajectory: 24/25/26 = 2/3 → 27/28/29 = 1/3 → 30/31/32 = 0/3. Pass-30 NOT CLEAN (1M+4L+2I); pass-31 NOT CLEAN (0M+3L+3I); pass-32 NOT CLEAN (2M+3L+3I). 21 new findings total (0H + 3M + 10L + 8I).
- **INFO tally:** 8 INFO findings fully itemized. 3 FIXED/RESOLVED by fix round 13 (ADV-P31-INFO-001, ADV-P31-INFO-002, ADV-P32-INFO-003); 5 OPEN (ADV-P30-INFO-001/002, ADV-P31-INFO-003, ADV-P32-INFO-001/002) as disclosed limitations or accurately-documented residuals.
- **src/ defects:** zero. src/ 0-defect streak extends to TWENTIETH consecutive pass.
- **Cross-pass concurrences:** mis-anchor P30↔P32 (both MEDIUM); stale count P30↔P31↔P32 (all three); self-falsifying docstring P30↔P31↔P32 (all three); undeclared CLAUDE.md/ci.yml P30↔P31↔P32 (all three); trail incomplete P30↔P32; echo-satisfiable assertions P30↔P31↔P32.
- **Fix round 13:** applied. Product head `1e696128` → `c2093a73` → `0adcae34` (branch pushed; PR #667 head is now `0adcae34`, CI 15/15 green). Spec side: S-626-1 v1.18→v1.19 (AC-3 verification vehicle + `--locked` correction + hedge discharged; 8-commit authorization trail at both sites; CLAUDE.md Conventions bullet + 3 in-code comments declared; ci.yml scope-rationale block declared; CHANGELOG row widened to 3 entries; test count → 2346, anchored to platform and commit). No tests added, removed, or renamed; independently measured at `0adcae34`: 103 binaries / 2346 passed / 0 failed / 100 ignored.
- **Disposition:** 3 MEDIUM + 10 LOW all FIXED by round 13. Of 8 INFO: 3 FIXED/RESOLVED (P31-INFO-001, P31-INFO-002, P32-INFO-003), 5 OPEN (P30-INFO-001, P30-INFO-002, P31-INFO-003, P32-INFO-001, P32-INFO-002) — all disclosed limitations or accurately-documented residuals.
- **Fresh window:** passes 33/34/35 against frozen head `0adcae34` (DEC-228), designated but not yet dispatched, pending human go-ahead. Step 4.5 remains 0/3. PR #667 remains HELD per DEC-202.

---

## CORRECTION to ADV-P32-MED-002 disposition (recorded ADVERSARY-33-34-35+FIX-ROUND-14 burst, 2026-08-05)

**The disposition recorded above for `ADV-P32-MED-002` — "FIXED — fix round 13 (v1.19: AC-3 vehicle, 8-commit trail, CHANGELOG row widened)" — is PARTIALLY FALSE.** The "CHANGELOG row widened" clause did not happen in fix round 13. The orchestrator's round-13 disposition listed it as fixed, but the fix-round-13 instructions never actually included the CHANGELOG File Structure Requirements row as an edit target — it was omitted from the work orchestrated, not merely missed by the agent doing the work. As a direct result, the row still read "Dependency pin entry per Task 7c" (singular) against three delivered CHANGELOG entries all the way through frozen head `0adcae34`, and three independent reviewers in window 33/34/35 (`ADV-P33-LOW-002`, `ADV-P34-LOW-002`, `ADV-P35-LOW-001`) caught the same gap. The row was genuinely widened only in fix round 14 (v1.20), at product commit `d848d9a5`.

**Attribution:** this error belongs to the orchestrator's round-13 disposition-writing, not to any fix-round-13 agent — the agents were never instructed to make the CHANGELOG edit, so they cannot have failed to make it. The `1cbcc3b8` burst commit that recorded the false disposition is NOT rewritten (history is preserved as delivered); this entry is the correcting record and is the current authoritative status for `ADV-P32-MED-002`. The `AC-3 vehicle` and `8-commit trail` clauses of the original `1cbcc3b8` disposition were true and remain uncorrected.

---

## Pass 33 Finding Catalog (Fresh Window DEC-228: NOT CLEAN)

Pass-33 opened window 33/34/35 NOT CLEAN, run against frozen head `0adcae34`. ELIGIBLE per DEC-224. One MEDIUM + two LOW + four INFO findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P33-MED-001 | MEDIUM | declaration-integrity | `tests/team_column_parity.rs` trail claimed 3 commits (`b51fc26a`+`c88374b4`+`6d73b3ef`); actual 4 — `148a9489` missing. v1.16 asserted "All three branch commits… verified against `git log`" — a false completeness claim. Survived prior audits because `148a9489` is +2/−2 net-zero, so the 487→655 = 168 line arithmetic still balanced | FIXED — fix round 14 (v1.20, 4-commit set at all sites; v1.16 claim corrected as superseded) | |
| ADV-P33-LOW-001 | LOW | stale-diagnostic | msrv test's first assert message described a `rust-toolchain.toml` fallback that cannot occur at the pinned SHA; contradicted by CLAUDE.md and AC-3 v1.19 | FIXED — fix round 14 (`d848d9a5`) | |
| ADV-P33-LOW-002 | LOW | undeclared-scope | `CHANGELOG.md` FSR row declares 1 entry; 3 delivered | FIXED — fix round 14 (v1.20) | |
| ADV-P33-INFO-001 | INFO | verification-coverage | AC-3's third requirement `--locked` had no regression pin; AC-2/4/5/7 likewise unpinned (one-shot delivery criteria, disclosed, not misstated) | PARTIALLY FIXED — fix round 14 (`d848d9a5` pinned `--locked`) | |
| ADV-P33-INFO-002 | INFO | guard-assertion-precision | 3 of 7 assertions echo/comment-satisfiable; docstring discloses accurately | OPEN — disclosed | |
| ADV-P33-INFO-003 | INFO | framing | `mutants_glob_existence.rs` docstring described the removed count as one that "would rot"; it had already rotted (16 globs vs stated 11) | OPEN | |
| ADV-P33-INFO-004 | INFO | symmetry-note | 3 branch commits touched the `src/` files; AC-9 cites only `cc7f6da5`. Story makes no completeness claim for `src/`, so not a defect | OPEN — recorded for symmetry | |

## Pass 33 Isolation Note

**ELIGIBLE.** Reviewer told up front about the ISOLATION-WHITELIST-LEAKS-FINDING-IDS defect and instructed to treat story-changelog finding IDs as scope declarations only. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 33 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 2 LOW + 4 INFO (0 CLOSED, 4 OPEN/PARTIAL); ELIGIBLE; src/ 0-defect TWENTY-FIRST consecutive pass
- **Post-capture routing:** 3 substantive findings (1 MED + 2 LOW) FIXED fix round 14; 1 INFO PARTIALLY FIXED; 3 INFO OPEN
- **Convergence:** window 33/34/35 opens NOT CLEAN
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 34 Finding Catalog (Fresh Window DEC-228: NOT CLEAN)

Pass-34 continued window 33/34/35 NOT CLEAN, run against frozen head `0adcae34`. ELIGIBLE, same class as pass-33. Three LOW + four INFO findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P34-LOW-001 | LOW | declaration-integrity | `team_column_parity.rs` trail 3 vs 4; explains the net-zero-arithmetic survival mechanism | FIXED — fix round 14 | Concurs ADV-P33-MED-001 |
| ADV-P34-LOW-002 | LOW | cross-surface-drift | Architecture Mapping omits `--locked`, the ci.yml msrv scope-rationale comment, the CLAUDE.md Conventions bullet, and the three in-code comments — all declared on FSR/AC surfaces | FIXED — fix round 14 (v1.20) | |
| ADV-P34-LOW-003 | LOW | missing-regression-pin | `--locked` unpinned; `grep -rn -- '--locked' tests/` returned zero | FIXED — fix round 14 (`d848d9a5`, proven red on removal / green on restore) | |
| ADV-P34-INFO-001 | INFO | citation-convention | The three S-626-1 CHANGELOG entries cite the story ID but not issue `#626`, unlike comparable prior entries | FIXED — fix round 14 (`d848d9a5`) | |
| ADV-P34-INFO-002 | INFO | disclosed-limitation | MSRV enforcement excludes `src/` inline `#[cfg(test)]` and `tests/` | OPEN — disclosed | |
| ADV-P34-INFO-003 | INFO | guard-assertion-precision | 3 of 7 echo-satisfiable, disclosed; load-bearing ones verified by perturbation | OPEN | Concurs ADV-P33-INFO-002 |
| ADV-P34-INFO-004 | INFO | unverifiable-citation | `ci.yml:60-62` cites "TD-VSDD-057 / prism PR #127" — a cross-project reference resolvable only inside factory artifacts, in a public workflow file | OPEN | |

## Pass 34 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as pass-33. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 34 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 3 LOW + 4 INFO (4 FIXED, 3 OPEN); ELIGIBLE; src/ 0-defect TWENTY-FIRST consecutive pass (concurring with pass-33)
- **Post-capture routing:** 3 LOW + 1 INFO FIXED fix round 14; 3 INFO OPEN
- **Convergence:** window 33/34/35 remains NOT CLEAN at this point
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 35 Finding Catalog (Fresh Window DEC-228: NOT CLEAN — Window CLOSED 0/3)

Pass-35 closed window 33/34/35 at 0/3, run against frozen head `0adcae34`. ELIGIBLE, same class as passes 33/34. One MEDIUM + one LOW + three INFO findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P35-MED-001 | MEDIUM | declaration-integrity | `team_column_parity.rs` trail 3 vs 4 | FIXED — fix round 14 | Concurs ADV-P33-MED-001, ADV-P34-LOW-001 |
| ADV-P35-LOW-001 | LOW | undeclared-scope | `CHANGELOG.md` under-declared: entry (1) acknowledged only inside a `risk_mitigations` audit note (a finding record, not a declaration); entry (3) on no surface at all | FIXED — fix round 14 (v1.20) | Concurs ADV-P33-LOW-002 |
| ADV-P35-INFO-001 | INFO | guard-assertion-precision | 3 of 7 echo-satisfiable, disclosed | OPEN | Concurs ADV-P33-INFO-002/ADV-P34-INFO-003 |
| ADV-P35-INFO-002 | INFO | pre-existing-slack | `mutants_glob_existence.rs` `FLOOR = 11` vs 16 live globs | OPEN — pre-existing, outside story scope | |
| ADV-P35-INFO-003 | INFO | `[process-gap]` missing-BC-anchor | AC-3 carries no behavioral-contract anchor; story states this explicitly and routes to team-lead | OPEN — routed | |

## Pass 35 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as passes 33/34. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 35 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 1 LOW + 3 INFO (2 FIXED, 3 OPEN); ELIGIBLE; src/ 0-defect TWENTY-FIRST consecutive pass (concurring with passes 33/34); window 33/34/35 CLOSED 0/3
- **Post-capture routing:** 2 substantive findings (1 MED + 1 LOW) FIXED fix round 14; 3 INFO OPEN
- **Convergence:** window 33/34/35 CLOSED 0/3 (pass-33 NOT CLEAN; pass-34 NOT CLEAN; pass-35 NOT CLEAN) — window trajectory 24/25/26=2/3 → 27/28/29=1/3 → 30/31/32=0/3 → 33/34/35=0/3
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Window 33/34/35 Summary

- **Result:** CLOSED 0/3, BROKEN. Zero CLEAN verdicts. Window trajectory: 24/25/26 = 2/3 → 27/28/29 = 1/3 → 30/31/32 = 0/3 → 33/34/35 = 0/3. Pass-33 NOT CLEAN (1M+2L+4I); pass-34 NOT CLEAN (0M+3L+4I); pass-35 NOT CLEAN (1M+1L+3I). 19 new findings total (0H + 2M + 6L + 11I).
- **INFO tally:** 11 INFO findings fully itemized. 2 FIXED/PARTIALLY FIXED by fix round 14 (ADV-P33-INFO-001 partial, ADV-P34-INFO-001 fixed); 9 OPEN (ADV-P33-INFO-002/003/004, ADV-P34-INFO-002/003/004, ADV-P35-INFO-001/002/003) as disclosed limitations, pre-existing slack, or routed items. **Reconciliation note (RESOLVED):** the burst-briefing disposition text originally stated "3 FIXED/partially fixed, 8 OPEN" for this tally — a summary-line arithmetic error by the orchestrator (both 3+8 and 2+9 sum to 11, which is what let the error survive being written down). Per-finding itemization in the three pass tables above supports only 2 FIXED/PARTIALLY FIXED and 9 OPEN. Team-lead confirmed by independent recount against the same itemization: 2/9 is authoritative. No individual finding's status was changed — only this summary line was corrected.
- **src/ defects:** zero. src/ 0-defect streak extends to TWENTY-FIRST consecutive pass.
- **Cross-pass concurrences:** team_column_parity trail P33↔P34↔P35 (all three); CHANGELOG under-declaration P33↔P35; echo-satisfiable assertions P33↔P34↔P35 (all three); `--locked` pin P33↔P34.
- **Fix round 14 (two-stage: code, then exhaustive declaration audit, then spec):** applied. Product head `0adcae34` → `d848d9a5`, pushed. PR #667 head = `d848d9a5`, CI 15/15 SUCCESS, 0 pending, 0 failed, mergeStateStatus CLEAN (validated on ubuntu/macos/windows). Stage 1 code: added a third assertion to `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` pinning `cargo check --all-features --locked`; reworded the toolchain-pin panic message; added `#626` to the three CHANGELOG entries. No test function added, removed, or renamed; independently measured at `d848d9a5`: 103 binaries / 2346 passed / 0 failed / 100 ignored. Stage 2: a dedicated exhaustive-declaration auditor (no fixing authority) enumerated every declaration surface × all 17 files, re-derived every commit trail from `git log`, measured every recorded number, and resolved every citation — found 7 gaps, 3 of which four consecutive adversarial windows had never surfaced (including two on `STORY-INDEX.md`, outside the adversary review whitelist); it also empirically reproduced the story's central causal claim by compiling comfy-table 7.2.2 in an isolated scratch crate under Rust 1.85.0, hitting the exact `E0658` let-chain error at two sites. Stage 3 spec: S-626-1 v1.19→v1.20 (FIX ROUND 14 entry; AC-3 verification vehicle extended to three assertions + panic-message correction; `ci_gate_completeness.rs` trail → 9 commits; `team_column_parity.rs` trail → 4 commits; v1.16's false completeness claim recorded as superseded; CHANGELOG FSR row + Delivery Checklist expanded to 3 entries; Architecture Mapping gained 6 rows).
- **Disposition:** 2 MEDIUM + 6 LOW all FIXED by round 14. Of 11 INFO: 2 FIXED/partially fixed, 9 OPEN (all disclosed limitations, pre-existing slack, or routed items) — confirmed authoritative per the Reconciliation note above.
- **Fresh window:** passes 36/37/38 against frozen head `d848d9a5` (DEC-229), designated but not yet dispatched, pending human go-ahead. Step 4.5 remains 0/3. PR #667 remains HELD per DEC-202.

---

## Pass 36 Finding Catalog (Fresh Window DEC-229: NOT CLEAN)

Pass-36 opened window 36/37/38, run against frozen head `d848d9a5`. ELIGIBLE, same class as prior windows. Four LOW + four INFO findings — the first pass in the cycle with zero MEDIUM findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P36-LOW-001 | LOW | citation-unresolvable | `BC-X.13.007` "postcondition 1" cited at 3 sites; that BC's postconditions are unnumbered/about exit codes — the glossed content is Behavior items 1–3 | FIXED — fix round 15 (v1.21, all sites → `Behavior items 1–3`) | Concurs ADV-P38-LOW-002 |
| ADV-P36-LOW-002 | LOW | undeclared-scope | `c88374b4` added a `.not()` assertion to pre-existing `team_column_parity.rs::sprint_current_falls_back_to_uuid_when_team_not_cached`, pinning `src/cli/sprint.rs::handle_current`; undeclared on FSR/Architecture Mapping/AC-9/BC-5.3.003 while the identical `cli_handler.rs` change IS declared | FIXED — fix round 15 (v1.21, wording mirrored from canonical BC) | Concurs ADV-P37-LOW-001, ADV-P38-LOW-001 |
| ADV-P36-LOW-003 | LOW | cross-surface-drift | Tasks section stale on 4 counts: no task covers AC-10; Task 3 omits `--locked`; Task 5 omits the Conventions bullet; Task 7c still singular after round 14's own GAP-4 widened FSR + Delivery Checklist and left it behind | FIXED — fix round 15 (v1.21, plus Task 7d in-code comments — a 5th point found by audit) | |
| ADV-P36-LOW-004 | LOW | incomplete-enumeration | AC-10/Architecture Mapping/FSR claim the POL-11 guard step came from 3 commits; 5 touched it (`14416fd9`, `e49230a7` comment-only) | FIXED — fix round 15 (v1.21, scoped per-hunk to the step) | Concurs ADV-P37-LOW-002 |
| ADV-P36-INFO-001 | INFO | imprecision | AC-6 bullet 1 says `rust-toolchain.toml` outranks the action's toolchain input; the input governs *installation*, not selection. Delivered `CLAUDE.md` states the accurate mechanism — the AC text is the inaccurate artifact | OPEN | |
| ADV-P36-INFO-002 | INFO | citation-form | ci.yml FSR row cites `(~:171-180)` raw line range after v1.13 migrated ci.yml citations to anchor form; accurate at head, cosmetic | OPEN | |
| ADV-P36-INFO-003 | INFO | cross-surface-drift | Purity Classification lists 4 of 17 files — the identical 6-file gap Architecture Mapping had, fixed in v1.20 and never mirrored here | FIXED — fix round 15 (v1.21, +6 rows) | Orchestrator initially deprioritized as INFO; audit rated MEDIUM and was correct |
| ADV-P36-INFO-004 | INFO | disclosure | AC-10's count is platform-caveated to macOS; ubuntu/windows figures still anchored to a pre-`1e696128` commit | OPEN — disclosed | |

## Pass 36 Isolation Note

**ELIGIBLE.** Reviewer told up front about the ISOLATION-WHITELIST-LEAKS-FINDING-IDS defect and instructed to treat story-changelog finding IDs as scope declarations only. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 36 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 4 LOW + 4 INFO (2 FIXED, 2 OPEN/disclosed); ELIGIBLE; src/ 0-defect TWENTY-SECOND consecutive pass. First pass in the cycle with zero MEDIUM findings.
- **Post-capture routing:** 4 LOW + 1 INFO FIXED fix round 15; 3 INFO OPEN
- **Convergence:** window 36/37/38 opens NOT CLEAN under the conservative DEC-191(c) reading (LOW/INFO-only, zero MEDIUM)
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 37 Finding Catalog (Fresh Window DEC-229: NOT CLEAN)

Pass-37 continued window 36/37/38 NOT CLEAN, run against frozen head `d848d9a5`. ELIGIBLE, same class as pass-36. Four LOW + three INFO findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P37-LOW-001 | LOW | undeclared-scope | sprint-site `.not()` assertion pinning `src/cli/sprint.rs::handle_current` | FIXED — fix round 15 | Concurs ADV-P36-LOW-002, ADV-P38-LOW-001 |
| ADV-P37-LOW-002 | LOW | incomplete-enumeration | POL-11 guard-step commit count (3 claimed vs 5 actual) | FIXED — fix round 15 | Concurs ADV-P36-LOW-004 |
| ADV-P37-LOW-003 | LOW | disproven-example | AC-3 + CHANGELOG cite `wiremock` as the `--locked` risk example; `wiremock` is a dev-dependency the msrv job's lib+bins-only `cargo check` never compiles, so it could never be affected | FIXED — fix round 15 (`c2d7a215` CHANGELOG → `dirs`, verified non-dev via `cargo tree`; v1.21 AC-3 + FSR row) | |
| ADV-P37-LOW-004 | LOW | miscount | Guard docstring says "the remaining three assertions" — the test has 8; 3 were unclassified | FIXED — fix round 15 (`c2d7a215`, reclassified 2 operative-only + 3 echo-satisfiable + 3 newly classified; also corrected an adjacent overclaiming inline comment) | |
| ADV-P37-INFO-001 | INFO | false-absence-claim | msrv guard docstring said "nothing else in the tree referenced `RUSTUP_TOOLCHAIN`"; `CLAUDE.md` and `CHANGELOG.md` both did | FIXED — fix round 15 (`c2d7a215`, narrowed to "nothing in CI or the test suite asserted on") | Concurs ADV-P38-LOW-003 |
| ADV-P37-INFO-002 | INFO | declared-deferral | E0463 comments in `sign-and-publish.yml`/`backfill-release.yml` are historically stale in present tense; explicitly assessed and routed to S-641-1 | OPEN — declared deferral | |
| ADV-P37-INFO-003 | INFO | by-design | `mutants_glob_existence.rs` `FLOOR = 11` vs 16 live globs; a lower bound, correctly left alone | OPEN — pre-existing | |

## Pass 37 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as pass-36. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 37 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 4 LOW + 3 INFO (5 FIXED, 2 OPEN); ELIGIBLE; src/ 0-defect TWENTY-SECOND consecutive pass (concurring with pass-36)
- **Post-capture routing:** 4 LOW + 1 INFO FIXED fix round 15; 2 INFO OPEN
- **Convergence:** window 36/37/38 remains NOT CLEAN under the conservative reading at this point (LOW/INFO-only, zero MEDIUM)
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 38 Finding Catalog (Fresh Window DEC-229: NOT CLEAN — Window CLOSED 0/3 conservative, 3/3 lenient)

Pass-38 closed window 36/37/38, run against frozen head `d848d9a5`. ELIGIBLE, same class as passes 36/37. Three LOW + five INFO findings. Zero MEDIUM across all three passes — the first time severity has decayed to zero MEDIUM for a full window in the cycle.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P38-LOW-001 | LOW | undeclared-scope | sprint-site assertion; test's own comment says "This assertion pins the sprint.rs render site" | FIXED — fix round 15 | Concurs ADV-P36-LOW-002, ADV-P37-LOW-001 |
| ADV-P38-LOW-002 | LOW | citation-unresolvable | `BC-X.13.007` "postcondition 1" plus the story's BC title being a third independent paraphrase matching neither `cross-cutting.md` nor `BC-INDEX.md` | FIXED — fix round 15 (v1.21; title now BC-INDEX canonical per the v1.11 ruling) | Concurs ADV-P36-LOW-001 |
| ADV-P38-LOW-003 | LOW | false-absence-claim | `RUSTUP_TOOLCHAIN` absence claim | FIXED — fix round 15 (`c2d7a215`) | Concurs ADV-P37-INFO-001 |
| ADV-P38-INFO-001 | INFO | classification-imprecision | Purity Classification marks the three `src/` files `pure-logic (minimal)` under a "Module" header; those modules do network I/O, cache reads, and env reads. The Justification cell makes clear the classification describes the *rewrites*, not the modules, so intent is recoverable | OPEN | |
| ADV-P38-INFO-002 | INFO | stale-count | Previous Story Intelligence says "all 34 form-B hits in `src/` are plain boolean continuations"; at the frozen head the count is 26. Entry is version-anchored to v1.7 and its conclusion is independently true — reviewer ran a two-line-aware detector across all of `src/` including inline `#[cfg(test)]` modules and found zero let-chain continuations | OPEN | |
| ADV-P38-INFO-003 | INFO | `[process-gap]` SHARED-WORKTREE CONTAMINATION | Twice during the pass the shared worktree was transiently mutated by another concurrent reviewer's perturbation probe: (a) a read of `ci.yml` returned `FOO: "1.85.0"` where HEAD has `RUSTUP_TOOLCHAIN: "1.85.0"` — another reviewer mid-restore; (b) `cargo clippy --all-targets --all-features -- -D warnings` returned exit 101 once and exit 0 on immediate re-run against a verified-clean tree. Reviewer self-mitigated by switching all content measurement to `git show HEAD:<path>` blobs and simulating perturbations in a scratchpad | OPEN — new drift item SHARED-WORKTREE-REVIEWER-CONTAMINATION | |
| ADV-P38-INFO-004 | INFO | unrecorded-provenance | AC-10's "negative path (simulated test-binary orphaning)" asserts a simulation was run but cites no artifact. Reviewer re-derived it independently and it holds — only provenance is unrecorded | OPEN | |
| ADV-P38-INFO-005 | INFO | isolation-boundary | AC-1's cited source `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` is outside the reviewer whitelist, so the "recorded there" clause is unverifiable in-perimeter; reviewer verified the SHA's substance against GitHub instead | OPEN | |

## Pass 38 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as passes 36/37, plus a self-mitigated shared-worktree contamination episode (ADV-P38-INFO-003, new SHARED-WORKTREE-REVIEWER-CONTAMINATION drift item). Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 38 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 3 LOW + 5 INFO (3 FIXED, 5 OPEN); ELIGIBLE; src/ 0-defect TWENTY-SECOND consecutive pass (concurring with passes 36/37); window 36/37/38 CLOSED 0/3 conservative, 3/3 lenient
- **Post-capture routing:** 3 LOW FIXED fix round 15; 5 INFO OPEN
- **Convergence:** window 36/37/38 CLOSED — 0/3 under the DEC-191(c) conservative reading (a NOT CLEAN LOW/INFO-only pass resets), 3/3 under the DEC-191(c) lenient reading (LOW refinements are ledgered, non-resetting). DEC-204 remains UNADJUDICATED and is now outcome-determining for this window.
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Window 36/37/38 Summary

- **Result:** CLOSED 0/3 conservative / 3/3 lenient under DEC-191(c) (DEC-204 UNADJUDICATED, now outcome-determining). Severity decayed to zero MEDIUM across all three passes for the first time in the cycle. Window trajectory: 24/25/26 = 2/3 → 27/28/29 = 1/3 → 30/31/32 = 0/3 → 33/34/35 = 0/3 → 36/37/38 = 0/3 conservative / 3/3 lenient. Pass-36 NOT CLEAN (0M+4L+4I); pass-37 NOT CLEAN (0M+4L+3I); pass-38 NOT CLEAN (0M+3L+5I). 23 new findings total (0H + 0M + 11L + 12I).
- **LOW tally:** 11 LOW findings fully itemized, all 11 FIXED by fix round 15.
- **INFO tally (RECONCILED):** 12 INFO findings fully itemized. Per-finding itemization above supports 2 FIXED (ADV-P36-INFO-003, ADV-P37-INFO-001) and 10 OPEN. **Reconciliation note:** the burst-briefing disposition text originally stated "4 FIXED (P36-INFO-003, P37-INFO-001, and the two folded into code fixes), 8 OPEN" — the "two folded into code fixes" clause does not correspond to any INFO-severity item marked FIXED in the itemization above; the code-fix-adjacent items (ADV-P37-LOW-003, ADV-P37-LOW-004, ADV-P38-LOW-003) are all LOW severity, already counted in the 11-LOW-all-FIXED tally. This is the same class of summary-line arithmetic error recorded and corrected in the window 33/34/35 burst (see this file's Reconciliation note under Window 33/34/35 Summary, round 14). Per-finding itemization is authoritative: 2 FIXED, 10 OPEN. No individual finding's status was changed — only this summary line was corrected.
- **src/ defects:** zero. src/ 0-defect streak extends to TWENTY-THIRD consecutive pass.
- **Cross-pass concurrences:** sprint-site assertion P36↔P37↔P38 (all three); POL-11 enumeration P36↔P37; BC-X.13.007 citation P36↔P38; `RUSTUP_TOOLCHAIN` absence claim P37↔P38.
- **Fix round 15 (code → exhaustive audit → spec):** applied. Product head `d848d9a5` → `c2d7a215`, pushed. PR #667 head = `c2d7a215`, CI validated on ubuntu/macos/windows. Stage 1 code: CHANGELOG `--locked` rationale example corrected `wiremock` → `dirs` (verified non-dev via `cargo tree --depth 1 -e normal`; `dirs`, `figment`, `urlencoding` all lack `rust-version`); guard docstring assertion classification corrected (8 total: 2 operative-only, 3 echo-satisfiable, 3 newly classified) plus an adjacent overclaiming inline comment; `RUSTUP_TOOLCHAIN` absence claim narrowed. No test added, removed, or renamed; independently measured at `c2d7a215`: 103 binaries / 2346 passed / 0 failed / 100 ignored. Stage 2: a second application of the exhaustive declaration-integrity audit methodology found 11 gaps, 3 new, and read every Task body in full (the prior audit had listed Tasks as enumerated without reading them, and had wrongly assumed `ci.yml` carried no commit claim from its format); identified a structural root cause — the story's "frozen head" has lagged live HEAD by one commit at every audit boundary because it is captured at briefing time rather than re-derived at write time (v1.19 said `0adcae34` vs `d848d9a5`; v1.20 said `d848d9a5` vs `c2d7a215`); self-caught and reported a false positive of its own; one of its two forks never returned, leaving `CLAUDE.md`, the three `src/` files, AC-5 line ranges, and the `ci.yml` scope comment unverified by this pass, stated explicitly under coverage limits. Stage 3 spec: S-626-1 v1.20→v1.21, all 11 gaps applied — `c2d7a215` declared; `ci_gate_completeness.rs` trail extended to 10 commits (re-derived independently via `git log`); POL-11 enumeration → 5; `wiremock` → `dirs` (correct usages deliberately preserved); Purity Classification +6 rows; `BC-X.13.007` → `Behavior items 1–3`; BC title → BC-INDEX canonical; Tasks 3/5/7c/7d fixed; Delivery Checklist gained an AC-10 item; Edge Cases EC-8/EC-9 discontinuity annotated as unexplained (agent searched the story's history, found nothing, declined to invent a reason); agent also caught and fixed a YAML-escaping defect it introduced, validated via `yaml.safe_load`, and recommends a CI frontmatter-parseability check. STORY-INDEX v1.5.64→v1.5.65.
- **Disposition:** 11 LOW all FIXED by round 15. Of 12 INFO: 2 FIXED, 10 OPEN (all disclosed limitations, pre-existing slack, declared deferrals, or process-gap disclosures) — see Reconciliation note above.
- **New drift items opened:** SHARED-WORKTREE-REVIEWER-CONTAMINATION (HIGH) — concurrent perturbation testing in a shared worktree can inject false findings into independent reviewers' passes; corrective adopted for all future dispatches (read via `git show HEAD:<path>` blobs, simulate perturbations in a scratchpad, never mutate the shared worktree). STORY-FROZEN-HEAD-LAGS-LIVE-HEAD (MEDIUM) — the story's recorded frozen head has lagged live HEAD by one commit at every audit boundary; corrective applied this round (spec agent re-derived HEAD itself and confirmed `c2d7a215`). FRONTMATTER-YAML-PARSEABILITY-UNGUARDED (LOW) — a story file whose YAML frontmatter is broken by unescaped quotes or literal `\n` in a block scalar still renders correctly as Markdown, so the defect is silent; caught this round only because the spec agent voluntarily round-tripped through `yaml.safe_load`.
- **Fresh window:** passes 39/40/41 against frozen head `c2d7a215` (DEC-230), designated but not yet dispatched, pending human go-ahead. This is the first window to satisfy the DEC-191(c) reading under the lenient interpretation; DEC-204 remains UNADJUDICATED and is now outcome-determining. Step 4.5 remains 0/3. PR #667 remains HELD per DEC-202.

---

## Pass 39 Finding Catalog (Fresh Window DEC-230: NOT CLEAN)

Pass-39 opened window 39/40/41, run against frozen head `c2d7a215`. ELIGIBLE, same class as prior windows. Two LOW + five INFO findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P39-LOW-001 | LOW | unverified-justification | The `CARGO_TERM_COLOR: never` override is documented on four surfaces as guarding a realized failure mode; empirically it cannot occur. Reviewer ran `CARGO_TERM_COLOR=always cargo test … \| cat -v`: cargo's own `Finished`/`Running` lines are ANSI-wrapped but libtest's `test result:` line is plain ASCII — cargo does not forward colour to the harness, so the anchored grep cannot be zeroed. Asserted as fact in `ci.yml`'s step comment, AC-10 item 1, BC-X.13.007's Preconditions, and the test docstring | FIXED — fix round 16 (`eb0d7cdd` re-tensed `ci.yml`'s step comment + the test docstring; BC-X.13.007 Preconditions reworded; v1.22 fixed AC-10 item 1 and Task 7e item 1) | |
| ADV-P39-LOW-002 | LOW | misclassification | Purity Classification row 4 classifies the three `src/` files `pure-logic (minimal)`; all three are effectful, and the table's own row 1 classifies workflow YAML `effectful-shell` on weaker grounds | FIXED — fix round 16 (v1.22 → `effectful-io`, justification separating the syntax-only rewrite from the non-pure code being rewritten) | |
| ADV-P39-INFO-001 | INFO | dead-reference | AC-4's v1.6 coverage-aim note refers to "`ci.yml`'s stable job"; no job named `stable` exists — the `# stable`-commented step is in the `coverage` job. AC-2 and Architecture Mapping use the correct anchor | OPEN | |
| ADV-P39-INFO-002 | INFO | form-divergence | AC-8 and Task 7a specify an "inline comment"; delivered is a five-line block comment above the pin. Substance fully satisfied (cites `#626`, no `.factory/` path) | OPEN | Concurs ADV-P41-INFO-001 |
| ADV-P39-INFO-003 | INFO | surface-inconsistency | Delivery Checklist items 1 and 2 remain `[ ]` while item 3 is `[x]`, at a head where both unchecked items are demonstrably satisfiable (reviewer executed both AC-10 proof directions). Pre-merge state is a legitimate reason; the mixed state is still a surface inconsistency | OPEN | |
| ADV-P39-INFO-004 | INFO | stale-but-truthful | AC-9/AC-10 record the per-platform CI triple `2345/2345/2340`, explicitly caveated as pre-`1e696128`. At the frozen head CI run `31026156032` reports `2346/2346/2341` across 103 binaries — exactly +1, consistent with the caveat. The recorded claim is truthful; the current triple simply is not written down | OPEN | |
| ADV-P39-INFO-005 | INFO | isolation-boundary | AC-1, `input-hash`, and the "F1 delta analysis §" traces cite `.factory/phase-f1-delta/…`, outside the reviewer whitelist — unverifiable in-perimeter. Reviewer verified the SHA independently against the live action instead | OPEN | Concurs ADV-P38-INFO-005 |

## Pass 39 Isolation Note

**ELIGIBLE.** Reviewer told up front about the ISOLATION-WHITELIST-LEAKS-FINDING-IDS defect and instructed to treat story-changelog finding IDs as scope declarations only. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 39 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 2 LOW + 5 INFO (2 FIXED, 5 OPEN); ELIGIBLE; src/ 0-defect TWENTY-THIRD consecutive pass.
- **Post-capture routing:** 2 LOW FIXED fix round 16; 5 INFO OPEN
- **Convergence:** window 39/40/41 opens NOT CLEAN under the conservative DEC-191(c) reading (LOW/INFO-only, zero MEDIUM)
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 40 Finding Catalog (Fresh Window DEC-230: NOT CLEAN)

Pass-40 continued window 39/40/41 NOT CLEAN, run against frozen head `c2d7a215`. ELIGIBLE, same class as pass-39. One LOW + four INFO findings.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P40-LOW-001 | LOW | certainty-overclaim | The docstring's "TWO of the assertions … can ONLY appear in the operative command, never in a prose comment" and VP-CIGATE-001's "cannot be satisfied by documentation text alone" are structurally false: `extract_job_block` returns a raw YAML slice including comments and every assertion is a plain `str::contains`, so a future comment quoting the floor expression would satisfy it with the operative line deleted. Concrete claims true today; modality wrong. Commit `c2d7a215` had softened the identical claim for the pipefail pair but left the two stronger ones absolute | FIXED — fix round 16 (`eb0d7cdd` softened the docstring + a downstream corollary sentence; VP-CIGATE-001 reworded — two overclaims found there, "immune to" plus a lead-in "can only appear") | |
| ADV-P40-INFO-001 | INFO | wording-precision | BC-INDEX's title and BC-X.13.007 Behavior item 2 specify the canary must have *"reported results"*; the implementation greps for the substring anywhere in captured output, matching cargo's `Running …` line — a proxy for "ran". AC-10 and the `ci.yml` diagnostic both say "did not run", matching the implementation; only the BC wording overreaches. No practical false-green | OPEN | |
| ADV-P40-INFO-002 | INFO | drifting-criterion | AC-1 requires confirming "`behind_by: 0`". Verified live: `ahead_by: 0, behind_by: 3` — the commit **is** a master ancestor (`ahead_by: 0` proves it), but `behind_by` increments as master advances, so the criterion as written is already unsatisfiable and will read as a failed check to any re-verifier. Commit date and title match AC-1 exactly | OPEN — suggest stating the durable invariant and marking `behind_by: 0` an F2-time snapshot | |
| ADV-P40-INFO-003 | INFO | prescriptive-drift | Task 7c and the Delivery Checklist prescribe wording the delivered CHANGELOG omits: the "internal dependency change; not a breaking change" qualifier, and `S-640-1` anonymized to "a dedicated follow-up story" while the same entry cites `S-626-1`. Checklist item marked "satisfied as amended" | OPEN | Concurs ADV-P41-INFO-002 |
| ADV-P40-INFO-004 | INFO | build-state-anomaly | A full `cargo test --all-features` terminated after 28 of 103 binaries while the shell reported exit 0; a clean re-run produced all 103. Reported as an anomaly per the no-mutation briefing rather than as a finding | OPEN — evidence the shared-worktree corrective is working as intended | |

## Pass 40 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as pass-39. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 40 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 1 LOW + 4 INFO (1 FIXED, 4 OPEN); ELIGIBLE; src/ 0-defect TWENTY-THIRD consecutive pass (concurring with pass-39)
- **Post-capture routing:** 1 LOW FIXED fix round 16; 4 INFO OPEN
- **Convergence:** window 39/40/41 remains NOT CLEAN under the conservative reading at this point (LOW/INFO-only, zero MEDIUM)
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 41 Finding Catalog (Fresh Window DEC-230: CLEAN — Window CLOSED 1/3 conservative, 3/3 lenient)

Pass-41 closed window 39/40/41, run against frozen head `c2d7a215`. ELIGIBLE, same class as passes 39/40. Zero LOW + three INFO findings — the first fully CLEAN pass of the cycle under the conservative DEC-191(c) reading.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P41-INFO-001 | INFO | form-divergence | AC-8 requires an "inline" comment; delivered is a five-line block comment preceding the pin. Substantive requirements fully met | OPEN — suggest rewording AC-8 "inline" → "adjacent" | Concurs ADV-P39-INFO-002 |
| ADV-P41-INFO-002 | INFO | prescriptive-drift | Two declared prose details absent from the delivered comfy-table CHANGELOG entry: the `S-640-1` ID (dropped, though the same entry carries `S-626-1`) and Task 7c's Cause clause placement. Substance delivered in richer form; checklist marked "satisfied as amended" | OPEN | Concurs ADV-P40-INFO-003 |
| ADV-P41-INFO-003 | INFO | `[process-gap]` review-history-in-spec | AC-10 asserts the pin assertions "were independently audited SOUND across adversary passes 21–26 (six consecutive sound audits; 8/8 PASS each time)" — a claim about prior review-process outcomes, unverifiable from any whitelisted surface, embedding review-ledger state into a spec artifact meant to be independently readable. Reviewer independently verified the underlying *technical* claim (all 8 assertions exist and pass; classification accurate) but not the audit history | OPEN — suggest keeping the technical statement and moving the pass-history attribution to the review ledger | |

## Pass 41 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as passes 39/40. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 41 Summary

- **Verdict:** CLEAN — 0 HIGH + 0 MEDIUM + 0 LOW + 3 INFO (0 FIXED, 3 OPEN); ELIGIBLE; src/ 0-defect TWENTY-FOURTH consecutive pass; first fully CLEAN pass of the cycle under the conservative DEC-191(c) reading.
- **Post-capture routing:** 3 INFO OPEN (no fix required for a CLEAN verdict)
- **Convergence:** window 39/40/41 CLOSED — 1/3 under the conservative reading (pass-41 CLEAN), 3/3 under the lenient reading (LOW refinements ledgered, non-resetting, and pass-39/40's LOW findings were both fixed). DEC-204 remains UNADJUDICATED.
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Window 39/40/41 Summary

- **Result:** CLOSED 1/3 conservative / 3/3 lenient under DEC-191(c) (DEC-204 UNADJUDICATED, now outcome-determining). Pass-41 is the first fully CLEAN pass of the cycle under the conservative reading. Novelty decay is now measurable and monotonic: LOW counts across the last six passes (36/37/38/39/40/41) = 4 → 4 → 3 → 2 → 1 → 0, with six consecutive passes at 0 HIGH + 0 MEDIUM. Window trajectory: 24/25/26 = 2/3 → 27/28/29 = 1/3 → 30/31/32 = 0/3 → 33/34/35 = 0/3 → 36/37/38 = 0/3 conservative (3/3 lenient) → 39/40/41 = 1/3 conservative (3/3 lenient). Pass-39 NOT CLEAN (0M+2L+5I); pass-40 NOT CLEAN (0M+1L+4I); pass-41 CLEAN (0M+0L+3I). 15 new findings total (0H + 0M + 3L + 12I). DEC-191(a) defines convergence as novelty decay; that has now occurred by that definition, though DEC-204 remains UNADJUDICATED and outcome-determining for whether this window satisfies Step 4.5.
- **LOW tally:** 3 LOW findings fully itemized, all 3 FIXED by fix round 16.
- **INFO tally:** 12 INFO findings fully itemized. 0 FIXED, 12 OPEN (all disclosed limitations, form divergences, or routed process-gaps).
- **src/ defects:** zero. src/ 0-defect streak extends to TWENTY-FOURTH consecutive pass.
- **Cross-pass concurrences:** AC-8 inline-vs-block form divergence P39↔P41; CHANGELOG prescriptive drift P40↔P41; isolation-boundary P39-INFO-005↔P38-INFO-005 (prior window).
- **Fix round 16 (code → exhaustive audit → spec):** applied. Product head `c2d7a215` → `eb0d7cdd`, pushed. PR #667 head = `eb0d7cdd`, CI 15/15 SUCCESS, 0 pending, 0 failed, mergeStateStatus CLEAN. Stage 1 code: re-tensed the `CARGO_TERM_COLOR` justification in `ci.yml`'s step comment and the test docstring to defensive framing (override retained as legitimate hardening, not a defense against a realized failure mode); softened the "can ONLY / never" modality plus a downstream corollary sentence the agent found unprompted. No test added, removed, or renamed; independently measured at `eb0d7cdd`: 103 binaries / 2346 passed / 0 failed / 100 ignored. Stage 2: `BC-X.13.007` Preconditions bullet 2 reworded from an asserted corruption risk to a stated assumption; `VP-CIGATE-001` reworded — the agent found and fixed **two** overclaims where the brief reported one; both reproduced the `CARGO_TERM_COLOR` evidence and read `extract_job_block` themselves rather than relying on the brief. Guards exit 0; BC total unchanged at 658. Stage 3 (exhaustive audit, third application): found 6 gaps, two of them new classes, and correctly identified the frozen-head lag as root cause of two others; flagged the test count as its own largest unverified claim rather than assuming it (the orchestrator had measured it independently). Stage 4 (spec): S-626-1 v1.21→v1.22 — `eb0d7cdd` declared (22 refs); `tests/ci_gate_completeness.rs` trail extended 10→11 commits; POL-11 guard-step commit enumeration corrected 5→6 at four sites; AC-10 item 1 and Task 7e item 1 re-tensed; Purity Classification row 4 → `effectful-io`; GAP-C citations converted to anchor/symbol form. STORY-INDEX v1.5.65→v1.5.66.
- **Disposition:** 3 LOW all FIXED by round 16. Of 12 INFO: 0 FIXED, 12 OPEN (all disclosed limitations, form divergences, or routed process-gaps).
- **New drift items opened:** LINE-RANGE-CITATIONS-DRIFT-SILENTLY (MEDIUM, `[process-gap]`) — a commit that only expands a comment can shift every subsequent line and silently invalidate an exact-line citation elsewhere in the story, at a distance, with nothing checking it; raised by the human operator after three exhaustive audits and eighteen reviewers had treated individual instances as one-off defects (one reviewer called it "cosmetic"); corrective applied — range/bare-line citations converted to anchor/symbol form; class narrowed, not eliminated. FIX-PASS-CATCHES-MORE-THAN-REVIEW-PASS (INFO) — twice this round a fix agent told to re-scan its own edit found overclaims the review passes had missed; worth generalising into fix-agent briefs.
- **Fresh window:** passes 42/43/44 against frozen head `eb0d7cdd` (DEC-231), designated but not yet dispatched, pending human go-ahead. Step 4.5 remains 0/3. PR #667 remains HELD per DEC-202.

---

## Pass 42 Finding Catalog (Fresh Window DEC-231: NOT CLEAN — this window reverses the six-pass zero-MEDIUM run)

Pass-42 opened window 42/43/44, run against frozen head `eb0d7cdd`. ELIGIBLE, same self-disclosed letter-of-rule deviations as prior windows; zero banned content used to bias the review. This window's brief asked whether anything was **unasserted** — a different inspection frontier than prior windows' "do the existing assertions fire correctly" — and immediately surfaced a real, previously-unpinned guard hole.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P42-MED-001 | MEDIUM | missing-verification-vehicle | `test_verify_test_job_has_zero_test_floor`'s docstring claimed "the assertions below pin all operative parts" — false: the zero-test floor `if [ "${total}" -eq 0 ]` had no assertion. Reviewer deleted the entire block from a scratchpad copy and all 8 assertions stayed green (`FAIL (POL-11)` and `exit 1` still satisfied by the binary-floor and canary branches). Covers BC-X.13.007 Behavior item 3, the only gate item covering "≥90 binaries ran but 0 tests passed" | FIXED r17 (`c0b3f5c8` added `"${total}" -eq 0`, red/green proven; docstring rewritten to enumerate what is and is not pinned) | |
| ADV-P42-LOW-001 | LOW | asserted-failure-mode-that-does-not-exist | Docstring and `ci.yml` comment claimed "Removing either bracket reintroduces the Defect 2 false-abort class". True for the opening `set +o pipefail`; false for the closing `set -o pipefail`, whose removal is strictly more permissive and never aborts. The "so real I/O errors are not silently swallowed" rationale has no operative effect — nothing after the restore is a pipeline | FIXED r17 (`c0b3f5c8` split the claim in both places) | Concurs P43-LOW-001 |
| ADV-P42-LOW-002 | LOW | broken-anchor | The v1.22 anchor `§ "Required: needs:"` matched zero occurrences; source text carries a backtick (`` Required: `needs: ``). This was the one citation round 16 converted from a bare line number specifically to make it resolvable; the other three anchors from that conversion were verified unique and do resolve | FIXED r17 (v1.23 corrected; verified 1 occurrence, unique). **Orchestrator-caused** — the orchestrator directed the anchor text and mandated uniqueness verification, then supplied a string that does not exist | |
| ADV-P42-INFO-001 | INFO | wrong-command-named | `ci.yml` comment said "awk and `wc -l` always exit 0"; the `binaries` pipeline ends in `tr -d ' '`. Conclusion holds | FIXED r17 (`c0b3f5c8`) | |
| ADV-P42-INFO-002 | INFO | stale-count | msrv guard docstring says "Both asserted strings…"; the test has three assertions since `d848d9a5` | FIXED r17 (`c0b3f5c8` extended to three and classified the third) | |
| ADV-P42-INFO-003 | INFO | form-divergence | Task 7a specifies an inline trailing comment; delivered is a five-line block comment above the pin. AC-8's substantive requirements met | OPEN | Concurs P43-INFO-002, P44-INFO-003 |
| ADV-P42-INFO-004 | INFO | `[process-gap]` index-self-contradiction | `STORY-INDEX.md` frontmatter `total_stories: 123` and prose "Final totals: 123" vs manifest footer "Total rows: 122 (matches `total_stories: 122`)" | OPEN — state-manager surface | |

## Pass 42 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as prior windows. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 42 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 2 LOW + 4 INFO (5 FIXED [1 MED + 2 LOW + 2 INFO], 2 OPEN); ELIGIBLE; src/ 0-defect TWENTY-FIFTH consecutive pass
- **Post-capture routing:** 1 MEDIUM + 2 LOW + 2 INFO FIXED fix round 17; 2 INFO OPEN
- **Convergence:** window 42/43/44 NOT CLEAN at this point — this pass alone reverses the prior six-pass zero-MEDIUM run
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 43 Finding Catalog (Fresh Window DEC-231, continued: NOT CLEAN — DEMONSTRATED FALSE-GREEN)

Pass-43 continued window 42/43/44, run against frozen head `eb0d7cdd`. ELIGIBLE, same class as pass-42. Two MEDIUM findings, one of which is a directly reproduced false-green.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P43-MED-001 | MEDIUM | DEMONSTRATED FALSE-GREEN | `set -euo pipefail` — the sole mechanism propagating a genuine `cargo test` failure through `… \| tee` — had no assertion. Reviewer proved the consequence: mutate to `set -eu`, and a `cargo test` exiting 101 produces `Check passed: … across 103 test binaries` and step exit 0, with all 8 assertions still passing. This is precisely the false-green class the story exists to close, asserted as closed by AC-10 item 2 and BC-X.13.007's Behavior and Invariants — none of which had a verification vehicle | FIXED r17 (`c0b3f5c8` added `set -euo pipefail\n`; implementer independently reproduced the false-green with a mock `cargo` before fixing, then proved red/green with byte-identical restore) | |
| ADV-P43-MED-002 | MEDIUM | false-frontmatter-claim | `verification_properties: []` with comment "VP registry absent — not an oversight". `VP-CIGATE-001` exists, was minted by this story (v1.18) and edited by it three times; siblings `S-577-5` and `S-576-5` populate this field under the identical no-registry condition | FIXED r17 (v1.23 → `["VP-CIGATE-001"]`, comment corrected, cited in AC-10's Traces-to) | Concurs P44-MED-001 |
| ADV-P43-LOW-001 | LOW | asserted-failure-mode | "Removing either bracket" | FIXED r17 | Concurs P42-LOW-001 |
| ADV-P43-LOW-002 | LOW | stale-count | msrv docstring "Both" vs three assertions; notes the third's comment-satisfiability is a live question the docstring leaves unanswered given the job's 10-line scope comment | FIXED r17 (`c0b3f5c8`) | |
| ADV-P43-INFO-001 | INFO | bookkeeping | AC-10 "Both proof directions execute cleanly" vs the Delivery Checklist item covering it being unchecked. Reviewer independently confirmed both directions work by replaying the guard's shell logic against real and synthetic output | FIXED r17 (v1.23 reworded to distinguish CI-verified positive path from manually-reproduced negative path) | Concurs P44-LOW-002 |
| ADV-P43-INFO-002 | INFO | form-divergence | AC-8/Task 7a inline vs block comment | OPEN | |
| ADV-P43-INFO-003 | INFO | wrong-command-named | `wc -l` vs `tr` | FIXED r17 | |
| ADV-P43-INFO-004 | INFO | line-wrapped-anchor | The `ci.yml :: mutants § "grep -c '' exits 1 on empty match"` citation is line-wrapped in source so the quoted string is not contiguous; the step name and `else` branch both resolve | OPEN | |
| ADV-P43-INFO-005 | INFO | isolation-boundary | AC-1/Task 0's `delta-analysis.md`, `input-hash`, `traces_to`, and the reciprocal `depends_on` for `blocks:` all lie outside the whitelist; `cargo mutants --in-diff` not run (AC-9's zero-mutants claim inferred from `examine_globs` exclusion, which entails it) | OPEN — note: `input-hash: "95fbaf9"` was subsequently confirmed by the round-17 audit to match `delta-analysis.md`'s md5sum, closing a blind spot carried since v1.20 | |

## Pass 43 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as pass-42. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 43 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 2 MEDIUM + 2 LOW + 5 INFO (6 FIXED [2 MED + 2 LOW + 2 INFO], 3 OPEN); ELIGIBLE; src/ 0-defect TWENTY-SIXTH consecutive pass
- **Post-capture routing:** 2 MEDIUM + 2 LOW + 2 INFO FIXED fix round 17; 3 INFO OPEN
- **Convergence:** window 42/43/44 NOT CLEAN — second consecutive MEDIUM-bearing pass, including a directly demonstrated false-green
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 44 Finding Catalog (Fresh Window DEC-231, closing: NOT CLEAN — Window 42/43/44 CLOSED 0/3)

Pass-44 closed window 42/43/44, run against frozen head `eb0d7cdd`. ELIGIBLE, same class as passes 42/43.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P44-MED-001 | MEDIUM | false-frontmatter-claim | `verification_properties: []` | FIXED r17 | Concurs P43-MED-002 |
| ADV-P44-LOW-001 | LOW | undeclared-mechanism | `shell: bash` and the `2>&1` capture appear on none of the six declaration surfaces. Load-bearing: the `test` job is a 3-OS matrix and GitHub defaults `run:` to pwsh on `windows-latest`, where `set -euo pipefail` is invalid syntax. Impact bounded — removal yields a loud red, not a false-green — hence LOW | FIXED r17 (v1.23 added to AC-10, Task 7e, and the ci.yml FSR row) | |
| ADV-P44-LOW-002 | LOW | unsupported-provenance | AC-10's negative path records no command, output, commit, or method, while the Delivery Checklist item created to verify it is unchecked — the two surfaces disagree about whether it was ever executed | FIXED r17 (v1.23) | |
| ADV-P44-LOW-003 | LOW | stale-figures | AC-9/AC-10 cite `2345/2345/2340`; at the frozen head CI reports `2346/2346/2341` across 103 binaries. Three consecutive rounds listed this as an unresolved blind spot | FIXED r17 (v1.23 → `2346/2346/2341`, measured at `c0b3f5c8` with CI 15/15 green including Windows) | |
| ADV-P44-INFO-001 | INFO | fabricated-quotation | AC-3's `(CLAUDE.md ~:219 — "routed, not verified against action.yml")` presents as a quotation a string that never existed in `CLAUDE.md` — reviewer checked every commit touching it on this branch plus `origin/develop`. It is the story's own v1.11 annotation formatted as a quote. Substantively harmless; the current fact is stated correctly | OPEN | |
| ADV-P44-INFO-002 | INFO | wording-precision | BC-X.13.007 Behavior item 2 says the canary fails if the binary "did not report results"; the implementation greps for a substring satisfied by cargo's `Running …` line — "was launched", not "emitted a `test result:` line". The two coincide for the targeted orphaning class | OPEN | Concurs P40-INFO-001 (prior window) |
| ADV-P44-INFO-003 | INFO | form-divergence | Task 7a inline vs block comment | OPEN | Concurs P42-INFO-003, P43-INFO-002 |
| ADV-P44-INFO-004 | INFO | `[process-gap]` index-self-contradiction | `STORY-INDEX.md` 123 vs 122 | OPEN | Concurs P42-INFO-004 |

## Pass 44 Isolation Note

**ELIGIBLE.** Same self-disclosed letter-of-rule deviations as passes 42/43. Zero banned content used to bias the review. Per DEC-224: ELIGIBLE.

## Pass 44 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 3 LOW + 4 INFO (4 FIXED [1 MED + 3 LOW], 4 OPEN); ELIGIBLE; src/ 0-defect TWENTY-SEVENTH consecutive pass
- **Post-capture routing:** 1 MEDIUM + 3 LOW FIXED fix round 17; 4 INFO OPEN
- **Convergence:** window 42/43/44 CLOSED — 0/3, all three passes NOT CLEAN
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Window 42/43/44 Summary

- **Result:** CLOSED 0/3 — all three passes NOT CLEAN, against frozen head `eb0d7cdd`. This window reverses the six-pass zero-MEDIUM run of windows 36/37/38 and 39/40/41. **Methodological finding (most important of the cycle):** prior windows' briefs asked whether the *existing* assertions fire correctly; this window's brief asked whether anything was **unasserted**. Moving that inspection frontier immediately surfaced two real, previously-unpinned holes (ADV-P42-MED-001, ADV-P43-MED-001 — the latter a directly demonstrated false-green). The decay curve 4→4→3→2→1→0 across the prior six passes measured reviewers exhausting the questions being asked, not the artifact running out of defects. See DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE drift item.
- **Finding count:** 24 new findings total, itemized individually above with zero range-collapsed entries: pass-42 = 0H+1M+2L+4I (7); pass-43 = 0H+2M+2L+5I (9); pass-44 = 0H+1M+3L+4I (8); 7+9+8 = 24.
- **MEDIUM tally:** 4 MEDIUM findings itemized (P42-MED-001, P43-MED-001, P43-MED-002, P44-MED-001), 3 distinct (P43-MED-002 ≡ P44-MED-001, a cross-pass concurrence on the same `verification_properties` gap). All 4 FIXED by fix round 17.
- **LOW tally:** 7 LOW findings itemized (P42-LOW-001/002, P43-LOW-001/002, P44-LOW-001/002/003), 5 distinct (P42-LOW-001 ≡ P43-LOW-001; P42-LOW-002 ≡ P43-LOW-002). All 7 FIXED by fix round 17.
- **INFO tally (independently re-derived from the itemization above, not copied from the dispatch brief):** 13 INFO findings itemized. **4 FIXED** (P42-INFO-001, P42-INFO-002, P43-INFO-001, P43-INFO-003), **9 OPEN** (P42-INFO-003, P42-INFO-004, P43-INFO-002, P43-INFO-004, P43-INFO-005, P44-INFO-001, P44-INFO-002, P44-INFO-003, P44-INFO-004). **Disclosure:** the burst dispatch brief stated "5 FIXED, 8 OPEN" for INFO; re-scanning the itemization line-by-line against each row's own Status column gives 4 FIXED / 9 OPEN. Per the standing "use yours and report" instruction, this file records the independently re-derived 4/9 split as authoritative; the discrepancy is noted, not silently corrected without disclosure.
- **src/ defects:** zero across all three passes. src/ 0-defect streak extends to TWENTY-SEVENTH consecutive pass.
- **Cross-pass concurrences:** `verification_properties` false-claim P43↔P44 (both MEDIUM); "Removing either bracket" asserted-failure-mode P42↔P43; msrv "Both" stale-count P42↔P43; Task 7a inline-vs-block form divergence P42↔P43↔P44; STORY-INDEX 123-vs-122 self-contradiction P42↔P44; AC-10 proof-direction bookkeeping P43↔P44.
- **Fix round 17 (code → BC → exhaustive audit → spec).** Stage 1 (code): product head `eb0d7cdd` → `c0b3f5c8`, pushed. PR #667 head = `c0b3f5c8`, CI 15/15 SUCCESS including `Test (windows-latest)`, mergeStateStatus CLEAN. Added two assertions to `test_verify_test_job_has_zero_test_floor` (8→10): `set -euo pipefail\n` and `"${total}" -eq 0`; both verified to occur exactly once in operative position, and `set -o pipefail\n` confirmed not a substring of `set -euo pipefail\n`. Implementer independently reproduced the false-green before fixing (mock `cargo` printing ~103 passing result lines then exiting 101: original → exit 101, no "Check passed"; mutated → exit 0 with `Check passed: 2264 tests executed across 103 test binaries`), then proved both new assertions turn the test RED under mutation with byte-identical restore. Docstring rewritten to grade all ten assertions and explicitly enumerate what is NOT pinned. Corrected the "Removing either bracket", "Both asserted strings", and `wc -l`/`tr` inaccuracies. No test added/removed/renamed. Independently measured at `c0b3f5c8`: 103 binaries / 2346 passed / 0 failed / 100 ignored. Stage 2 (BC): `VP-CIGATE-001` (`specs/prd/cross-cutting.md`) rewritten for ten assertions across four graded tiers (variable/command-bound; exact standalone line; literal substring; weakest), with a separate labelled "Not pinned" paragraph. The agent corrected the orchestrator's arithmetic (brief said 8→9; actual is 8→10, verified by counting `assert!(` at `c0b3f5c8~1` and `c0b3f5c8`). Confirms BC-X.13.007's Behavior item 4 and matching Invariant now have a genuine verification vehicle. A third hole was identified and deliberately not faked: neither the `cargo test --all-features 2>&1 \| tee …` invocation nor the `total=`/`binaries=` computation pipelines are pinned — only their usages — a structural limit of a substring guard over a raw YAML slice, recorded in both the docstring and `VP-CIGATE-001` rather than papered over (candidate follow-up story; see SUBSTRING-GUARD-CANNOT-VERIFY-COMPUTED-VALUES drift item). Stage 3 (exhaustive audit, fourth application): found 8 gaps including one nobody had reported (the File Structure Requirements row's stale "8 assertions total" and its 8-count taxonomy); positively confirmed `input-hash: "95fbaf9"` matches `delta-analysis.md`'s md5sum — a blind spot carried unverified since v1.20; stated its own coverage limits explicitly, including that Tasks 0–6 bodies and the full Edge Cases table were not read this round. Stage 4 (spec): S-626-1 v1.22→v1.23 — `c0b3f5c8` declared (32 refs); `tests/ci_gate_completeness.rs` trail 11→12 commits; POL-11 guard-step trail 6→7 commits; assertion count and taxonomy updated to ten mirroring `VP-CIGATE-001`; `verification_properties: ["VP-CIGATE-001"]`; CI figures → `2346/2346/2341`; `shell: bash` + `2>&1` declared on AC-10, Task 7e, and the `ci.yml` FSR row; AC-10's proof-direction claim reworded to distinguish the CI-verified positive path from the manually-reproduced negative path; the broken anchor corrected and verified unique. STORY-INDEX v1.5.66→v1.5.67.
- **New drift items opened:** DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE (HIGH, `[process-gap]`) — a declining finding count is evidence of convergence only if the inspection frontier is held constant; each round's brief was sharpened toward the previous round's findings, so the 4→4→3→2→1→0 decay was partly an artifact of the questions asked, not the artifact's defect density; corrective: deliberately vary the inspection frontier before treating decay as convergence. SUBSTRING-GUARD-CANNOT-VERIFY-COMPUTED-VALUES (MEDIUM) — `test_verify_test_job_has_zero_test_floor` pins the presence of gate expressions but cannot verify the values feeding them are correctly computed; `binaries=999; total=999` would defeat all ten assertions; closing it requires executing the guard script against synthetic cargo output rather than substring-matching YAML; candidate follow-up story.
- **Existing drift items updated:** ORCHESTRATOR-SHIPPED-DEFECTIVE-GUARD (HIGH) — prior downgrade recommendation WITHDRAWN: twenty-one confirmations verified the assertions which exist fire correctly; none asked what was missing, and two operative parts were unpinned, one reachably (P43-MED-001). The guard is now materially stronger (ten assertions, both holes closed, red/green proven) and its residual limit is documented, but the confirmation count was measuring the wrong property; re-assess only after a window that probes absence returns clean. STORY-FROZEN-HEAD-LAGS-LIVE-HEAD (MEDIUM) — seventh consecutive recurrence; the v1.23 spec agent re-derived HEAD itself and matched `c0b3f5c8`; recommend promoting the re-derive-at-write-time step into the standing fix-round dispatch template. LINE-RANGE-CITATIONS-DRIFT-SILENTLY (MEDIUM) — the round-16 anchor conversion itself produced one broken anchor (`§ "Required: needs:"`, zero matches) alongside three correct ones; fixed in v1.23 and verified unique; anchor conversion must include a resolve-and-uniqueness check on the converted string, not only the ones that happen to work. SHARED-WORKTREE-REVIEWER-CONTAMINATION (HIGH → recommend MEDIUM) — corrective held for a second window; no contamination-derived findings. FRONTMATTER-YAML-PARSEABILITY-UNGUARDED (LOW) — `STORY-INDEX.md`'s frontmatter was found unparseable and fixed (`c7a93fb8`, block-literal scalar, content diffed character-for-character); root cause is structural (`last_updated` accumulates unbounded prose with no schema constraint) so it will recur; candidate follow-up story: CI guard plus a schema constraint on that field. AGENT-BACKGROUND-RUN-DEADLOCK — no occurrence this round. MIXED-SET-DASH-ARM-UNPINNED — unchanged, OPEN per DEC-226.
- **Fresh window:** passes 45/46/47 against frozen head `c0b3f5c8` (DEC-232), designated but not yet dispatched, pending human go-ahead. Continuing AUTHORIZED breach of DEC-191(d) ceiling. Step 4.5 remains 0/3. PR #667 remains HELD per DEC-202.

---

## Pass 45 Finding Catalog (Fresh Window DEC-233, dispatched: NOT CLEAN — distinct inspection frontier: guard efficacy / false-green)

Pass-45 opened window 45/46/47, run against frozen head `fc9ad59b`. ELIGIBLE. Frontier deliberately distinct from the prior window per DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE — this pass asked whether the CI structural guards (`ci-gate`, `msrv`) could be defeated by a mutation their own assertions do not reach, not merely whether the assertions that exist fire.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P45-HIGH-001 (F-01) | HIGH | UNPINNED-CRITICAL-BODY | The `ci-gate` job's `run:` step body was unpinned — only "a `run:` step exists" was checked, not its content. `ci-gate` is THE single required branch-protection status check (per CLAUDE.md's CI Gate convention); replacing its body with `echo "..."` would have left it permanently green while all nine other structural assertions in `test_ci_gate_pass_fail_semantics_are_structurally_placed` continued to pass | FIXED r19 (`e076e96b`; independently re-proved RED by the orchestrator: mutation → assertion failed with the correct diagnostic while the other 8 assertions in the function still passed → restore verified byte-identical, sha256 `63701d18…810cce`; now pinned by exact trimmed-line equality `l.trim() == "run: exit 1"`) | |
| ADV-P45-MED-001 (F-02) | MEDIUM | PLACEMENT-NOT-PINNED | `msrv` job's `RUSTUP_TOOLCHAIN` env override was verified by presence anywhere in the job block, not by placement on the specific `cargo check --all-features --locked` step; relocating the env var to an unrelated step in the same job would silently revert MSRV validation to whatever `stable` resolves to at build time while the presence-only assertion kept passing | FIXED r19 (`e076e96b`; `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` 3→4 assertions, the new one same-step-scoped) | |
| ADV-P45-MED-002 (F-03) | MEDIUM | INCOMPLETE-PATTERN-COVERAGE | `test_ci_gate_needs_jobs_have_no_event_conditional_if`'s no-job-level-`if:` guard matched only a `github.event_name`-substring pattern, missing (a) YAML folded-scalar escapes (`if: >-`) and (b) non-event-referencing conditionals (`if: false`) that would still add an unintended job-level gate on one of the eight required `needs` members | FIXED r19 (`e076e96b`; broadened to flag ANY job-level `if:` key on the seven unconditionally-run `needs` members, confirmed by reading the function body) | |
| ADV-P45-LOW-001 (F-04) | LOW | vacuous-pass-on-parse-failure | `tests/ci_gate_completeness.rs::test_ci_gate_excludes_advisory_and_secret_scan_jobs` used `parse_needs_set(gate_block).unwrap_or_default()`; an empty set trivially satisfies both `!needs.contains(...)` assertions. Every sibling test panics on `None`. A wrapped inline `needs:` array returns `None` → test passes while `security`/`coverage` ARE in needs. Contained (a sibling test panics on the same input) | FIXED r19 (`unwrap_or_else` replacing the last `unwrap_or_default` call site) | |
| ADV-P45-LOW-002 (F-05) | LOW | name-promises-unchecked-guarantee | `::test_ci_gate_job_exists_with_correct_shell` asserted `name:`, `runs-on:`, and job-level `if:` containing `always()`; nothing about a shell | FIXED r19 by rename to `test_ci_gate_job_exists_with_required_metadata`, authorized by the round-19 test-naming-convention carve-out | |
| ADV-P45-LOW-003 (F-06) | LOW | stale-count-in-load-bearing-reasoning | `§ "AC-003 — ci-gate.needs is exactly the required six-job set"` (set is **eight**); `::test_ci_gate_fails_on_failed_or_cancelled_need § "skipped is not possible for the six unconditionally-run jobs"` (there are **seven**). Both are push-event-safety reasoning, not incidental prose | FIXED r19 | |
| ADV-P45-LOW-004 (F-07) | LOW | coverage-map-omits-branch-delta | `§ "Test coverage map"` listed 7 of 9 functions. Missing `test_verify_test_job_has_zero_test_floor` (AC-10/BC-X.13.007) and `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` (AC-3) — the entire S-626-1 delta to the file | FIXED r19 (coverage map extended to all 9) | |
| ADV-P45-INFO-001 (I-01) | INFO | job-hardening-asymmetry | `.github/workflows/ci.yml :: ci-gate` is the only job with no `timeout-minutes:` and the only one with no `step-security/harden-runner` step; all eight others carry both | OPEN — recommend follow-up (hardening gap on the single required check) | |
| ADV-P45-INFO-002 (I-02) | INFO | coverage-floor-slack | `tests/mutants_glob_existence.rs::assert_examine_globs_coverage_floor § "const FLOOR: usize = 11"` against 17 `examine_globs` entries in `.cargo/mutants.toml`; six could be deleted without tripping it | CONFIRMED, not a defect — matches its stated lower-bound contract, no action implied | |

## Pass 45 Isolation Note

**ELIGIBLE.** Dispatched against frozen head `fc9ad59b` per DEC-233/DEC-234's predecessor designation. Per DEC-224: ELIGIBLE.

## Pass 45 Summary

- **Verdict:** NOT CLEAN — 1 HIGH + 2 MEDIUM + 4 LOW + 2 INFO (3 FIXED [1 HIGH + 2 MEDIUM] verified in fix round 19; LOW/INFO disposition not individually captured at burst time); ELIGIBLE; src/ 0-defect (test-file-only fixes)
- **Frontier:** guard efficacy / false-green — "can a mutation defeat this guard without any existing assertion catching it?"
- **Convergence:** window 45/46/47 opened NOT CLEAN — first HIGH finding in six passes (since pass-19), reversing an apparent convergence trend
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 46 Finding Catalog (Fresh Window DEC-233, continued: NOT CLEAN — distinct inspection frontier: spec↔implementation fidelity)

Pass-46 continued window 45/46/47, run against frozen head `fc9ad59b`. ELIGIBLE, distinct frontier from pass-45 — this pass asked whether the story/BC spec's own claims about what each Canonical Test Vector scenario proves match what the underlying script/test actually does, rather than probing the guard's code-level defeatability.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P46-MED-001 (M-1) | MEDIUM | false-spec-claim | The Delivery Checklist's AC-10 negative-path bullet claimed EC-CIGATE-003 and EC-CIGATE-004 "both correctly trip `FAIL (POL-11): ...` + `exit 1`" — only EC-CIGATE-004 (the pipefail-propagation mock-`cargo` exercise) actually drove the shell guard; EC-CIGATE-003's exercise deleted the Rust-side `if [ "${total}" -eq 0 ]` block and re-ran the regression test in `tests/ci_gate_completeness.rs`, proving the text-pin was necessary, not that the shell logic fires | FIXED r19 (stage 3, story) — no script executed for EC-CIGATE-003 that emitted `FAIL (POL-11)` or `exit 1`; checklist bullet corrected, no sibling overclaim found in that paragraph | |
| ADV-P46-MED-002 (M-2) | MEDIUM | propagation-gap | The Verification Status row for "AC-10 negative path — zero-test floor (EC-CIGATE-003)" still read `MANUAL, weaker than it appears`; `cross-cutting.md`'s own EC-CIGATE-003 entry already graded this NONE (downgraded there in FIX ROUND 18) but the downgrade never propagated to the story's own table | FIXED r19 (stage 3; corrected to NONE, noted the row also self-contradicted the table's own legend — MANUAL requires "verified once by a human", which never happened for this scenario either) | |
| ADV-P46-MED-003 (M-3) | MEDIUM | false-spec-claim | The AC-2 Verification Status row made two false claims: (a) `read_ci_yml` was said to be the only `tests/` helper touching any of the 6 workflow files (false — `tests/release_yml_windows_matrix.rs` and `tests/backfill_matrix_parity.rs` also read workflow files); (b) no test was said to assert the new `toolchain:` input in any of the 6 files (false for `ci.yml` — `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` does) | FIXED r19 (stage 3; status corrected NONE→PARTIAL: SHA replacement stays NONE across all 6 files, `toolchain:` input COVERED for `ci.yml :: msrv`, NONE for the other 5) | |
| ADV-P46-LOW-001 (LOW-1) | LOW | false-spec-claim | `S-626-1.md § "AC-5 (3 rustup target add steps preserved)"` claimed no test references those steps "or the files". Step half true; file half false for `release.yml`/`backfill-release.yml` | FIXED r19 (evidence statement corrected; NONE status survives) | |
| ADV-P46-LOW-002 (LOW-2) | LOW | unreconcilable-stale-tally | `§ "COVERED 19 · PARTIAL 15 · MANUAL 9 · NONE 21"`: no enumeration of 64 sub-claims exists; cannot be reconciled with the 16 rows beneath it; stale because EC-CIGATE-003 moved MANUAL→NONE after the tally was struck | FIXED r19 (replaced with the table's own reconcilable tally: COVERED 3 · PARTIAL 3 · MANUAL 4 · NONE 7, 17 grades across 16 rows) | |
| ADV-P46-LOW-003 (LOW-3) | LOW | false-spec-claim | `§ "AC-6"` and `§ "Deliberately unverified"` claimed citations "resolve to real files/**symbols**". `tests/claude_md_citations.rs::extract_path_citations` strips the `::symbol` suffix and asserts only file existence; its own failure message says symbol-form tokens are auto-excluded. A dead symbol in a live file passes | FIXED r19 (both sites corrected to "real files" only) | |
| ADV-P46-LOW-004 (LOW-4) | LOW | false-spec-claim | `§ "The pin entry in Cargo.toml carries an inline comment citing"` and `§ "Task 7a"` describe a trailing inline comment; what shipped is a five-line block comment ABOVE the pin (`Cargo.toml § "Pinned to 7.2.1: 7.2.2 uses let-chains"`), pin line bare | FIXED r19 (both sites corrected to describe the actual block-comment form; substantive postconditions unaffected) | |
| ADV-P46-LOW-005 (LOW-5) | LOW | misattributed-count | `§ "CI run 31046151473 green, 15/15 checks"`; that run has **14** jobs. PR-level 15 is correct; the 15th (`dependency-review`) belongs to run `31046152112` | FIXED r19 for the two current-tense sites; two historical `risk_mitigations` mentions deliberately left per this story's no-rewrite-history convention | |
| ADV-P46-INFO-001 (INFO-1) | INFO | ambiguous-clause-scope | `CLAUDE.md § "**No let-chains.**"` ends without a "(tracked as S-640-1)" story-ID clause the story text implies. Reviewer read the parenthetical as identifying the story rather than mandating the prose, and noted an internal story ID in a published repo doc would itself be questionable | OPEN — deliberately not scored; recorded so a future pass does not re-derive it | |
| ADV-P46-INFO-002 (INFO-2) | INFO | perimeter-verified-accurate | Everything else in the perimeter independently confirmed, not transcribed: the 12 assertions in `test_verify_test_job_has_zero_test_floor` mapping onto the 3+4+2+3 taxonomy in both story and `cross-cutting.md`; the 13-commit `ci_gate_completeness.rs` trail; 4-commit `team_column_parity.rs` trail; 7-commit POL-11 guard-step trail; `git show fc9ad59b --stat` = one file 84+/10− (independently confirming the round-18 PART 4 CORRECTION); `files_modified` (17) matching the branch diff with no undeclared file; all AC-2/AC-5 `~NN` citations exact; `ci-gate.needs` exactly 8; zero `c93f4f9c` matches (AC-7); BC titles verbatim vs BC-INDEX; the three AC-9 rewrites semantically equivalent; `cross-cutting.md`'s BC-X.13.007 "Verified by" column honest throughout | CONFIRMED, not a defect | |

## Pass 46 Isolation Note

**ELIGIBLE.** Same frozen head as pass-45. Per DEC-224: ELIGIBLE.

## Pass 46 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 3 MEDIUM + 5 LOW + 2 INFO (3 MEDIUM FIXED, confirmed via story v1.25 changelog; LOW/INFO most-likely-corresponding to 5 documented spec-fidelity fixes in the same changelog, not verbatim-confirmed); ELIGIBLE; src/ 0-defect (spec-only findings)
- **Frontier:** spec↔implementation fidelity — "does the spec's claim about what a scenario proves match what actually happened?"
- **Convergence:** window 45/46/47 still NOT CLEAN after two passes
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 47 Finding Catalog (Fresh Window DEC-233, closing: CLEAN — distinct inspection frontier: source-side correctness, executed not reasoned)

Pass-47 closed window 45/46/47, run against frozen head `fc9ad59b`. ELIGIBLE, distinct frontier from passes 45/46 — this pass executed rather than reasoned: a real Rust 1.85.0 toolchain build, a scratch crate proving the `comfy-table = "=7.2.1"` pin load-bearing, the full test suite, clippy, and fmt, all run directly rather than inferred from reading source.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P47-INFO-001 (I-1) | INFO | inert-untested-branch | `src/cli/board.rs::handle_view § "} else {"` and the `list.rs` equivalent JSON-mode outer `else` has no dedicated test — pinned only for `sprint.rs`. Not rewrite-introduced (byte-identical to the pre-rewrite arm) and behaviorally inert (`output::print_output` ignores `rows` under `OutputFormat::Json`) | CONFIRMED gap, not a defect — no action implied | |
| ADV-P47-INFO-002 (I-2) | INFO | pin-guarded-by-ci-not-test | The `=7.2.1` pin is guarded by CI, not by a test: `Cargo.lock` v4 records resolved versions and requirement strings, not requirement ranges; relaxing `=7.2.1`→`"7"` without touching the lock leaves `cargo check --locked` green at 1.85.0 since locked 7.2.1 still satisfies `^7`. Detection arrives at the next lock-moving PR — loud and correctly attributed, but delayed. Pin DOES bind at HEAD | CONFIRMED — derived from Cargo semantics rather than execution, flagged as such by the reviewer | |
| ADV-P47-INFO-003 (I-3) | INFO | rewrite-robust-by-construction | In `board.rs::handle_view` and `list.rs::handle_list`, `else { Vec::new() }` appears three times, so any misattribution of an `else` during the rewrite would still have been behavior-preserving. Bounds the residual risk class for this edit shape | CONFIRMED — the equivalence result is stronger than "the author got it right" | |
| ADV-P47-INFO-004 (I-4) | INFO | relative-terminology-not-imprecision | "inner"/"outer" in BC-5.3.002 is a relative label: post-rewrite `board.rs`/`list.rs` have three `Vec::new()` arms; BC-5.3.002 governs two and calls the field-configured gate "outer", while BC-5.3.001 calls the Table gate "outermost". Exact for `sprint.rs` (two levels). Reviewer considered LOW and rejected it: all six line citations correct and each labelled with its triggering condition | CONFIRMED — terminology, not imprecision; no action implied | |

## Pass 47 Isolation Note

**ELIGIBLE, with a disclosed near-miss.** Same frozen head as passes 45/46. Pass-47 deviated from pure read-only-from-the-worktree-path: it executed builds (real 1.85.0 `cargo check`, a scratch crate compiling comfy-table 7.2.2 to `E0658`, the full suite, clippy, fmt) and read spec artifacts via `git show factory-artifacts:<path>` rather than exclusively via HEAD blob reads. Both deviations were disclosed unprompted, and a scratch `CARGO_TARGET_DIR` was used for all builds. The orchestrator independently verified the worktree afterward: clean, at `fc9ad59b`, 0/0 diff vs origin — no contamination reached the shared worktree. Near-miss on SHARED-WORKTREE-REVIEWER-CONTAMINATION; the scratch-target-dir mitigation is recorded as effective. Per DEC-224 (contamination-actually-surfaced is the operative test, not letter-of-rule path syntax): ELIGIBLE.

## Pass 47 Summary

- **Verdict:** CLEAN — 0 HIGH + 0 MEDIUM + 0 LOW + 4 INFO (all 4 INFO are executed-verification confirmations, not defects); ELIGIBLE; src/ 0-defect
- **Frontier:** source-side correctness, executed rather than reasoned — direct compilation, dependency-resolution, and test-suite execution rather than static reading
- **Convergence:** window 45/46/47 CLOSED 1/3 conservative (pass-47 is the only CLEAN pass of the window)
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Window 45/46/47 Summary

- **Result:** CLOSED 1/3 — pass-45 NOT CLEAN (1H+2M+4L+2I), pass-46 NOT CLEAN (0H+3M+5L+2I), pass-47 CLEAN (0H+0M+0L+4I), against frozen head `fc9ad59b`. **Methodological finding:** each of the three passes was dispatched against a deliberately distinct inspection frontier (guard efficacy/false-green; spec↔implementation fidelity; source-side executed correctness) — a direct response to DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE. The frontier change worked exactly as the drift item predicted: after six consecutive passes (39-44 minus the reversal, then the apparent stabilization implied by round 18's spec-only remediation) that had not surfaced a HIGH, varying the question immediately surfaced ADV-P45-HIGH-001 — a defect that had been present in the guard the entire time, simply never asked about.
- **Finding count:** 23 new findings total across the three passes: pass-45 = 1H+2M+4L+2I (9); pass-46 = 0H+3M+5L+2I (10); pass-47 = 0H+0M+0L+4I (4); 9+10+4 = 23.
- **HIGH:** 1 (ADV-P45-HIGH-001, the `ci-gate` job's unpinned `run:` body). FIXED r19, independently re-proved RED by the orchestrator with byte-identical restore verified via sha256.
- **MEDIUM:** 5 itemized (ADV-P45-MED-001/002, ADV-P46-MED-001/002/003), all distinct, all FIXED r19.
- **LOW:** 9 itemized and distinct (ADV-P45-LOW-001..004 [F-04..F-07]; ADV-P46-LOW-001..005 [LOW-1..5]), all FIXED r19; none remain OPEN.
- **INFO:** 8 itemized (ADV-P45-INFO-001..002 [I-01/I-02]; ADV-P46-INFO-001..002 [INFO-1/INFO-2]; ADV-P47-INFO-001..004 [I-1..I-4]). 2 OPEN (ADV-P45-INFO-001 hardening-asymmetry recommendation, ADV-P46-INFO-001 deliberately-not-scored clause), 6 CONFIRMED/not-a-defect.
- **Itemization backfill (2026-08-05, follow-up to this burst):** the initial version of this index recorded the 9 LOW + 8 INFO findings as aggregate counts with an explicit disclosure rather than fabricated text, because the burst dispatch had handed this state-persistence pass full detail only for the HIGH and 5 MEDIUM findings. The orchestrator supplied the missing itemization in a follow-up message; this index was corrected in place with the verbatim finding text above. Total reconciles: 1H + 5M + 9L + 8I = 23, unchanged from the original burst's aggregate count — the backfill added detail, not new findings. Recorded per the same "do not fabricate, disclose instead" practice that produced the original placeholders — the correction is itself evidence the practice worked as intended (`ORCHESTRATOR-FALSE-FABRICATION-ACCUSATION` / `ORCHESTRATOR-DISPOSITION-DRIFTS-FROM-ITEMIZATION`).
- **Pass-47 near-miss (recorded at backfill time):** pass-47 disclosed executing real builds (Rust 1.85.0 `cargo check`, a scratch crate, full suite, clippy, fmt) and reading spec artifacts via `git show factory-artifacts:<path>` rather than exclusively via HEAD blob reads, both against the standing perturbation-testing convention. A scratch `CARGO_TARGET_DIR` was used throughout; the orchestrator independently verified the shared worktree afterward — clean, at `fc9ad59b`, 0/0 diff vs origin. No contamination reached the shared worktree. See the amended Pass 47 Isolation Note and the SHARED-WORKTREE-REVIEWER-CONTAMINATION drift item.
- **Fix round 19 (four stages: code → docs → BC → spec).** Stage 1 (code, `e076e96b`): product head `fc9ad59b` → `e076e96b`, closing all three pass-45 findings (F-01/F-02/F-03) in `tests/ci_gate_completeness.rs` — 159 insertions / 22 deletions, single file, `ci.yml` itself NOT modified. `test_ci_gate_pass_fail_semantics_are_structurally_placed` 7→8 assertions; `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` 3→4 assertions; `test_ci_gate_needs_jobs_have_no_event_conditional_if` broadened; `test_ci_gate_excludes_advisory_and_secret_scan_jobs`'s vacuous-pass path closed (`unwrap_or_else` replacing `unwrap_or_default` on the last remaining call site); two stale job-count doc comments corrected; the coverage map extended to all 9 test functions; `test_ci_gate_job_exists_with_correct_shell` renamed to `test_ci_gate_job_exists_with_required_metadata` (old name asserted a `shell:` guarantee its body never checked). `test_verify_test_job_has_zero_test_floor` confirmed 12→12, untouched — BC-X.13.007/`VP-CIGATE-001` unaffected by this round. Stage 2 (docs, `51c7aa54`): a naming-policy carve-out added to `docs/specs/test-naming-convention.md` (a test name asserting a guarantee its body doesn't check is a defect, not a style deviation, and may be corrected independently of the "existing no-prefix names are not renamed" rule) plus reconciliation of `CLAUDE.md`'s Test naming bullet, which had disagreed with the spec on scope ("with no-prefix names" vs. unqualified) — this carve-out is what authorizes the stage-1 rename without triggering the story's own no-drive-by-rename discipline. Stage 3 (BC): `specs/prd/cross-cutting.md` gained a 21-line Invariants bullet and `trace:` entry stating BC-X.13.007 does NOT govern the `ci-gate`/`msrv` structural guards fixed this round — those are pinned at the S-CIGATE-1/S-626-1 story-AC layer (AC-001/002/003/AC-3/M1/M2) with no corresponding BC or VP in this PRD; no BC added, count unchanged at 658; both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` independently re-run and confirmed exit 0. Stage 4 (spec): S-626-1 v1.24→v1.25 — all 8 story-fidelity findings from pass-46 applied (M-1/M-2/M-3 plus 5 LOW), the Verification Status tally reconciled from a stale unenumerated `COVERED 19 · PARTIAL 15 · MANUAL 9 · NONE 21` to a table-derived `COVERED 3 · PARTIAL 3 · MANUAL 4 · NONE 7` (17 grade-instances across 16 rows, AC-9b/AC-9c carrying two), and round 19's own code/docs deltas declared with independent re-verification against the worktree rather than transcription from the fix-round brief. STORY-INDEX v1.5.68→v1.5.69.
- **Immutability decision:** `.factory/code-delivery/S-CIGATE-1/pr-description.md` was deliberately NOT edited (verified: 0 diff lines, all 5 old-name occurrences intact) — it is a pasted verbatim runner log from a real run at commit `e9b2269`; editing it would make the text something the process never emitted while still labelled as its output. Grounded in ISO 15489 authenticity/integrity + annotation-rule research and the 21 CFR 11 §11.10(e) "shall not obscure previously recorded information" principle. Precedent for editing the *story* spec post-delivery (as opposed to the frozen runner-log artifact) exists at commit `31b9ee0d`.
- **New drift items opened:** `BC-COVERAGE-GAP-FOR-CI-GATE-GUARDS` (HIGH) — the five `ci-gate`/`msrv` guard tests, including the one now closing F-01, had zero behavioral-contract coverage before this round; their only spec anchor is a closed story; the repo's single required status check is governed by no living contract. `AGENT-IDLE-WITHOUT-DELIVERY` (MEDIUM) — 5 of 5 subagents this session went idle without delivering, each requiring an explicit prompt; mitigation: dispatch briefs must name `SendMessage(to: "team-lead", …)` as the delivery mechanism up front. `SCOPED-GREP-CLAIM-EXCEEDS-EVIDENCE` (LOW) — stage 1b reported "zero matches anywhere in the repo" for the renamed symbol from a cwd containing no `.factory/`; 9 occurrences in fact remained; work was correct, the claim was overstated — same shape as the defect class this session exists to fix. `SPEC-CITATIONS-UNGUARDED-FOR-TEST-SYMBOLS` (MEDIUM) — the F-05 rename silently broke 9 `.factory/` citations; no CI guard validates `.factory/` spec citations against real test symbols (`tests/claude_md_citations.rs` covers only CLAUDE.md file paths and strips symbols). `S-CIGATE-1-TABLE-CELL-DEFECT` (LOW) — `stories/S-CIGATE-1-ci-gate-aggregator.md:~97` has 6 pipes vs. a 4-column header, predating this session (commit `4dfca9a4`, 2026-06-15); flagged for a separate sweep, not fixed this round. `PR-518-ANNOTATION-DEFERRED` (INFO) — research recommended a post-merge annotation on PR #518 recording an old→new mapping; the human declined for this round; deferred, not rejected.
- **Existing drift items updated:** `ORCHESTRATOR-DISPOSITION-DRIFTS-FROM-ITEMIZATION` (lessons.md, codified lesson) — fifth datapoint: the orchestrator's stage-2 brief asserted BC-level count changes (7→8, 3→4) that do not exist at the BC layer; those deltas live in sibling test functions BC-X.13.007 does not govern; caught by the BC-layer agent re-deriving governance from source before writing. `DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE` (HIGH) — reinforced a third consecutive time: varying the frontier across passes 45/46/47 surfaced a HIGH that six passes of the old frontier had not. `LINE-RANGE-CITATIONS-DRIFT-SILENTLY` (MEDIUM) — extended: symbol renames (the F-05 rename) drift citations the same way line-number citations do, and nothing guards it either. `TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE` (HIGH) — nineteen rounds, no window has yet closed 3/3.
- **Fresh window:** passes 48/49/50 against frozen head `51c7aa54` (DEC-234, supersedes DEC-233), designated but not yet dispatched, pending human go-ahead. Continuing AUTHORIZED breach of DEC-191(d) ceiling. Step 4.5 remains 0/3. PR #667 remains HELD per DEC-202.

---

## Pass 48 Finding Catalog (Fresh Window DEC-234, dispatched: NOT CLEAN — distinct inspection frontier: did fix round 19 introduce defects?)

Pass-48 opened window 48/49/50, run against frozen head `51c7aa54`. ELIGIBLE. Frontier deliberately distinct from every prior window — this pass ran 6 real mutations via a Python re-implementation of the predicates, asking specifically whether round 19's own fix introduced new defects. Confirmed `ci.yml` was NOT modified by round 19 (`git log fc9ad59b..51c7aa54 -- .github/workflows/ci.yml` empty).

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P48-MED-001 | MEDIUM | first-occurrence-anchor-fragility | `tests/ci_gate_completeness.rs::test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env § "F-02 (round 19): pin PLACEMENT"` uses `msrv_block.find(anchor)` (**first** occurrence). The msrv job carries a 10-line scope comment above the run step; if a future edit quotes `cargo check --all-features --locked` verbatim there, the slice cuts at the wrong boundary and the assertion **fails on a correct config**. Fails safe (red, never green) — hence MEDIUM. Fix: anchor on `"- run: cargo check --all-features --locked"` or use `rfind`. Sub-note: the `after_anchor[1..]` comment documents a hazard that cannot occur (`anchor_pos` lands mid-line, so the `[1..]` is a no-op) while the real hazard goes unmentioned | OPEN | |
| ADV-P48-LOW-001 | LOW | stale-symbol-name | `::test_ci_gate_needs_jobs_have_no_event_conditional_if`: round 19 broadened the body to "no job-level `if:` key at all" and updated banner, docstring and inline comment, but **not the function name**, which still says `no_event_conditional_if`. Same defect class as the F-05 rename, introduced by the very commit pair that codified the rule against it. Risk: a maintainer reads the name, judges the predicate over-reaching, and re-adds the `github.event_name` filter — reopening both escapes | OPEN | |
| ADV-P48-LOW-002 | LOW | header-story-mismatch | `§ "Test coverage map (→ S-CIGATE-1 AC)"` header declares S-CIGATE-1 but the two rows round 19 added point at **S-626-1** ACs. Two stories' AC namespaces merged under a header naming only one. Padding also inconsistent (`AC-001` vs `AC-10`/`AC-3`) | OPEN | |
| ADV-P48-LOW-003 | LOW | one-sided-tradeoff-doc | `::test_ci_gate_pass_fail_semantics_are_structurally_placed § "Assertion 4 (F-01, round 19)"`: the exact-trimmed-line tradeoff is **correct** (proved: substring is defeated by `run: exit 100`) but documented one-sidedly — two legitimate reformats, `run: |` with `exit 1` on a continuation line and `run: "exit 1"`, both fail the predicate; the docstring never states that cost | OPEN | |
| ADV-P48-INFO-001 | INFO | dead-conjunct | Dead conjunct `!line.starts_with("        ")` in the M1 predicate is unreachable-false; pre-existing, carried through unexamined | CONFIRMED, not a defect | |
| ADV-P48-INFO-002 | INFO | guard-stronger-than-hazard | M1 is deliberately stronger than the hazard (would flag a harmless `if: always()`); intentional per its docstring, diagnostic is useful, no currently-valid shape rejected | CONFIRMED, not a defect | |
| ADV-P48-INFO-003 | INFO | doc-agreement-verified | CLAUDE.md and the naming spec genuinely agree and the exception is properly scoped. Two asymmetries, neither a contradiction: CLAUDE.md omits the spec's "update live references / don't edit historical records" obligation but links to it; the spec's Migration-policy first sentence still reads flat "Existing tests are NOT renamed" while CLAUDE.md reads "NOT renamed for style alone", with the carve-out seven lines later | CONFIRMED, not a defect | |
| ADV-P48-INFO-004 | INFO | precise-but-marginal | F-04's panic hardening is correct; its message would be marginally imprecise for a scalar `needs: fmt`, but it is verbatim the sibling's and that shape fails the exact-set test anyway | CONFIRMED, not a defect | |

## Pass 48 Isolation Note

**ELIGIBLE.** Dispatched against frozen head `51c7aa54` per DEC-234. Per DEC-224: ELIGIBLE.

## Pass 48 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 1 MEDIUM + 3 LOW + 4 INFO (all OPEN at burst time; no fix round applied this window — see Window 48/49/50 Summary); ELIGIBLE; src/ untouched (test-file/spec-doc findings only)
- **Frontier:** did fix round 19 introduce defects? — 6 real mutations run via a Python re-implementation of the predicates; confirmed `ci.yml` untouched by round 19
- **Convergence:** window 48/49/50 opened NOT CLEAN
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 49 Finding Catalog (Fresh Window DEC-234, continued: NOT CLEAN — distinct inspection frontier: orphans and broken traceability, both directions)

Pass-49 continued window 48/49/50, run against frozen head `51c7aa54`. ELIGIBLE, distinct frontier from pass-48 — this pass checked citation/traceability integrity in both directions: dead citations FROM specs TO code, and shipped behavior CONTRADICTING an open spec.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P49-HIGH-001 | HIGH | dead-citation-two-sites | `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` cites `tests/ci_gate_completeness.rs::test_ci_gate_excludes_pr_only_jobs` at **two live sites** (AC-004 item 3; test-matrix row 4). **That function does not exist** — renamed to `test_ci_gate_excludes_advisory_and_secret_scan_jobs` by commit `3b122a8f` (PR #567). Orchestrator independently confirmed: zero `fn` matches. Aggravating: round 19's own `3867899f` edited that same file to record a *different* rename, complete with SHA, and left this sibling dead name untouched. Nothing in CI validates `.factory/` symbol citations | OPEN — see Cycle-Closing Checklist (spec-only follow-up, deferred not dropped) | |
| ADV-P49-HIGH-002 | HIGH | closed-story-contradicts-shipped-behavior | Same file, `§ AC-003`: asserts *"`security` and `mutants` MUST NOT appear in `ci-gate.needs`"*, and its "Pinned by" claims the needs set is six jobs. **Reality:** `needs` is eight and includes `mutants`; `tests/ci_gate_completeness.rs::test_mutants_is_in_ci_gate_needs` asserts the **opposite** of AC-003. The only spec establishing the shipped behavior is `S-MUTATION-CI-TIMEOUT-1` (**status: done, closed**); the live owner (`S-CIGATE-1`, **status: draft, open**) asserts its negation, reinforced by an "Out of Scope" clause. A maintainer trusting the open story would remove `mutants` from the gate and de-gate mutation testing | OPEN — root-cause chain informing S-CIGATE-2's fix; S-CIGATE-1 reconciliation scoped OUT of S-CIGATE-2 per human direction, deferred per Cycle-Closing Checklist | |
| ADV-P49-MED-001 | MEDIUM | undeclared-file-modification | `docs/specs/test-naming-convention.md` was modified by `51c7aa54` (+2) but is **undeclared** on every S-626-1 surface: `files_modified` (18 real vs 17 declared), File Structure Requirements, Architecture Mapping, Purity Classification, and the MUST-NOT-change fence. The v1.25 `risk_mitigations` entry names only `CLAUDE.md` — describing half its own commit. Fifth recurrence of this class (v1.13 F-05, v1.17 F1, v1.20 GAP 1, and now) | OPEN | |
| ADV-P49-MED-002 | MEDIUM | authorization-trail-short-by-one | The `tests/ci_gate_completeness.rs` authorization trail is stated as 13 commits at two sites (File Structure Requirements row; MUST-NOT-change exception list); re-derived actual at this head is **14** — `e076e96b` missing at both. **Fifth consecutive round short by exactly one.** Pattern: content gets narrated in `risk_mitigations` while the authorization sites lag. The story's own fence therefore does not permit the round-19 edit it describes | OPEN | |
| ADV-P49-MED-003 | MEDIUM | incomplete-guard-list | `.factory/specs/prd/cross-cutting.md § BC-X.13.007 § Invariants`: the sibling-guard bullet added by round 19 names **5 of 8** guards. Omitted: `test_ci_gate_excludes_advisory_and_secret_scan_jobs`, `test_mutants_is_in_ci_gate_needs`, `test_ci_gate_fails_on_failed_or_cancelled_need`. Self-inconsistent: the same paragraph describes a "panic-on-missing-`needs:` fix" that landed in a test its own list omits. `S-MUTATION-CI-TIMEOUT-1` is never named as an anchoring story anywhere in the PRD | OPEN | |
| ADV-P49-LOW-001 | LOW | false-design-premise | `S-CIGATE-1` stale "six" counts at four sites, one carrying a **false design premise**: *"all six `needs` jobs run unconditionally on both push and PR events, so `skipped` is not possible for them."* False at this head — `mutants` is in `needs` and is PR-only. The design holds for a different reason (`skipped` is neither `failure` nor `cancelled`), stated correctly only in the test file | OPEN | |
| ADV-P49-INFO-001 | INFO | vp-registry-decision-superseded-not-recorded | `VP-CIGATE-001` has no registry entry; it exists only as prose inside BC-X.13.007. The story's v1.8 `risk_mitigations` records the opposite decision ("verification_properties left empty… no VP registry exists") and was never superseded when the field was populated. Substantively accurate though: 12 assertions verified by direct count, and siblings verified at 4 and 8, matching v1.25 | OPEN — recorded, not actioned | |
| ADV-P49-INFO-002 | INFO | extensive-verified-clean | Extensive verified-clean list: all 22 code symbols cited across S-626-1, `bc-5-boards-sprints.md`, `BC-INDEX.md` and `cross-cutting.md` resolve; BC-5.3.002's `~NN` citations land within `~`-tolerance; AC-9d/AC-9e claims hold; the Verification Status tally reconciles exactly; all 17 declared `files_modified` appear in the real diff (declared-but-absent direction clean) | CONFIRMED, not a defect | |

## Pass 49 Isolation Note

**ELIGIBLE.** Same frozen head as pass-48. Per DEC-224: ELIGIBLE.

## Pass 49 Summary

- **Verdict:** NOT CLEAN — 2 HIGH + 3 MEDIUM + 1 LOW + 2 INFO (all OPEN at burst time); ELIGIBLE; src/ untouched (spec-integrity findings only)
- **Frontier:** orphans and broken traceability, both directions — dead citations FROM spec TO code, and shipped behavior CONTRADICTING an open spec
- **Convergence:** window 48/49/50 still NOT CLEAN after two passes; two HIGH in a single pass, both spec-integrity, not source-code defects
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 50 Finding Catalog (Fresh Window DEC-234, closing: NOT CLEAN — distinct inspection frontier: real GitHub Actions event/runner semantics)

Pass-50 closed window 48/49/50, run against frozen head `51c7aa54`. ELIGIBLE, distinct frontier from passes 48/49 — this pass checked real GitHub Actions event/runner semantics against the gate's assumptions, using live run history and the GitHub API rather than static source reading alone.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P50-HIGH-001 | HIGH | skipped-status-false-green | `.github/workflows/ci.yml :: ci-gate § "Fail if any required job failed or was cancelled"` handles only `failure` and `cancelled`; **`skipped` is unhandled**, so a skipped need yields a green required check. **Empirically confirmed, run `30465686049`** (push→develop): `Mutation testing` skipped, `Secret Scan` skipped, `CI Gate` **success** — and `mutants` **is** in `ci-gate.needs`. Branch protection: sole context `["CI Gate"]`, `strict: false`, `enforce_admins: false`. Structural: the other seven needs jobs are unskippable only incidentally; four ordinary edits (repo-variable gate — a pattern already in use on `security`; `paths:` filter; empty `fromJSON` matrix; cascading skip) each produce a silent green. Root-cause chain: `S-CIGATE-1` line ~150 explicitly predicted this (*"they emit `skipped` on push events, which would poison push-triggered `ci-gate` runs"*), PR #567 added `mutants` to `needs` anyway, and the gate was never taught about `skipped`. **The cycle's most consequential finding** | OPEN — **Story S-CIGATE-2 created** (`.factory/stories/S-CIGATE-2-skipped-status-false-green.md`); urgent standalone fix ahead of S-626-1 per human direction | |
| ADV-P50-MED-001 | MEDIUM | fail-open-on-partial-schema-drift | `ci.yml :: mutants § "Check kill rate"` schema-drift guard is fail-**open** on *partial* drift: the FAIL requires `_outcomes_len > 0 && _sum_check == 0 && total_mutants == 0`; if a future `outcomes.json` nests the counters but keeps `total_mutants` top-level and non-zero, the third conjunct is false, control reaches a non-fatal `::warning::`, then `total_outcomes -eq 0` exits 0 — job green, 90% kill-rate gate never evaluated. Plausible trigger: bumping `cargo-mutants@27`→`@28` (the pin's own comment names schema change as its risk) | OPEN | |
| ADV-P50-MED-002 | MEDIUM | strict-false-merge-window | `strict: false` on both protected branches (verified via API): a PR whose green gate was computed against an older `develop` may merge unchanged, so the merged tree is not the tree that was tested. `CLAUDE.md § "Protected branches"` says only "require CI to pass" and records no note of this tradeoff | OPEN | |
| ADV-P50-LOW-001 | LOW | gitleaks-not-gating | `security` (gitleaks) is outside `ci-gate.needs`, so a detected secret does not block merge and `vars.GITLEAKS_DISABLED='true'` removes the scan with zero gate effect. CLAUDE.md documents the opt-out but not that the job never gated anything | OPEN — related to pre-existing GITLEAKS-NOT-IN-CI-GATE-NEEDS drift item | |
| ADV-P50-LOW-002 | LOW | canary-proves-invocation-not-execution | The `grep -q "ci_gate_completeness"` canary in `ci.yml :: test` proves the **binary was invoked**, not that its assertions ran: `cargo test` prints the `Running …` line before execution, so marking the file `#[ignore]` or adding an env gate (a pattern used in ≥4 places in this repo) leaves all three floors satisfied at `0 passed`. Not reachable at head (0 `#[ignore]`, 20 `#[test]`). Also verified not spuriously satisfiable | OPEN | |
| ADV-P50-LOW-003 | LOW | no-timeout-on-ci-gate | `ci-gate` has no `timeout-minutes` (every other job sets one); inherits the 360-minute default. Cannot false-green — a pending required check blocks merge — so imprecision, not risk | OPEN | |
| ADV-P50-INFO-001 | INFO | no-merge-group-trigger | No `merge_group` trigger and no queue enabled (fail-safe, but enablement would be silent) | CONFIRMED, not a defect | |
| ADV-P50-INFO-002 | INFO | required-check-identity-sound | Required-check identity is sound and the DEC-096/097 matrix-rename mitigation holds (static `name: CI Gate`, no `strategy:`, `needs.<id>.result` aggregates matrix legs) | CONFIRMED, not a defect | |
| ADV-P50-INFO-003 | INFO | spec-guard-scripts-no-vacuous-pass | No vacuous-pass path in the six spec-guard scripts | CONFIRMED, not a defect | |
| ADV-P50-INFO-004 | INFO | fork-pr-cannot-abuse-secrets | Fork PRs cannot skip or fail a gated job via secret restriction (no `needs` job consumes a secret; no `pull_request_target` anywhere) | CONFIRMED, not a defect | |
| ADV-P50-INFO-005 | INFO | enforce-admins-false-enables-high-001 | `enforce_admins: false` is what makes ADV-P50-HIGH-001's direct-push scenario reachable | CONFIRMED — contributing factor to ADV-P50-HIGH-001, not a separate defect | |
| ADV-P50-INFO-006 | INFO | harden-runner-audit-only | `harden-runner` is `egress-policy: audit` everywhere and contributes nothing to gate correctness either way | CONFIRMED, not a defect | |

## Pass 50 Isolation Note

**ELIGIBLE.** Same frozen head as passes 48/49. Per DEC-224: ELIGIBLE.

## Pass 50 Summary

- **Verdict:** NOT CLEAN — 1 HIGH + 2 MEDIUM + 3 LOW + 6 INFO; ELIGIBLE; src/ untouched (workflow-file + spec findings only)
- **Frontier:** real GitHub Actions event/runner semantics — live run history and API state, not static source reading alone
- **Convergence:** window 48/49/50 CLOSED 0/3 — worst window since window 30/31/32
- **Correction recorded (post-burst, caught by the story-writer):** pass-50 initially claimed "zero cancelled `ci.yml` runs in the last 200 to sample." **False** — four exist (`29736816386`, `29735639851`, `29701963083`, `29699658785`), all PR-triggered, and `CI Gate` **correctly failed** in all four. The `cancelled` path is sound; only the narrower question (a job cancelled *before it ever started*) remains open, now EC-004 in S-CIGATE-2. Recorded as an **orchestrator relay error** (the orchestrator relayed the false claim without verifying it), distinct from the reviewer's original error — see `ORCHESTRATOR-DISPOSITION-DRIFTS-FROM-ITEMIZATION`.
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Window 48/49/50 Summary

- **Result:** CLOSED 0/3 — pass-48 NOT CLEAN (0H+1M+3L+4I), pass-49 NOT CLEAN (2H+3M+1L+2I), pass-50 NOT CLEAN (1H+2M+3L+6I), against frozen head `51c7aa54`. **Methodological finding:** each of the three passes was given a distinct, previously-unused frontier ("did fix round 19 introduce defects?"; "orphans and broken traceability, both directions"; "real GitHub Actions event/runner semantics") — the strongest confirmation yet of DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE: round 19 ended pass-47 at 0H, and these three fresh frontiers immediately produced 3H, including a live repo-wide false-green (ADV-P50-HIGH-001) that 47 prior passes had missed. Passes 49 and 50 independently converged on the **same underlying defect** — `mutants` sitting in `ci-gate.needs` and reporting `skipped` on push — from opposite directions (pass-49 HIGH-002: an open spec forbids what shipped; pass-50 HIGH-001: here is the live green run proving it), with neither pass able to see the other's findings; recorded as corroborating evidence, not duplication.
- **Finding count:** 28 new findings total across the three passes: pass-48 = 0H+1M+3L+4I (8); pass-49 = 2H+3M+1L+2I (8); pass-50 = 1H+2M+3L+6I (12); 8+8+12 = 28.
- **HIGH:** 3 — ADV-P49-HIGH-001 (dead citation, two sites), ADV-P49-HIGH-002 (closed-story-contradicts-shipped-behavior), ADV-P50-HIGH-001 (skipped-status false-green — the cycle's most consequential finding). ADV-P50-HIGH-001 → **new story S-CIGATE-2 created**, human-directed as an urgent standalone fix ahead of S-626-1. ADV-P49-HIGH-001/002 → routed to a spec-only follow-up, recorded as an explicit deferral (see Cycle-Closing Checklist), not silently dropped.
- **MEDIUM:** 6 itemized (ADV-P48-MED-001; ADV-P49-MED-001/002/003; ADV-P50-MED-001/002), all distinct, all OPEN.
- **LOW:** 7 itemized and distinct (ADV-P48-LOW-001/002/003; ADV-P49-LOW-001; ADV-P50-LOW-001/002/003), all OPEN.
- **INFO:** 12 itemized (ADV-P48-INFO-001..004; ADV-P49-INFO-001/002; ADV-P50-INFO-001..006). 10 CONFIRMED/not-a-defect, 1 recorded-not-actioned (ADV-P49-INFO-001), 1 contextual (ADV-P50-INFO-005, a contributing factor to HIGH-001 rather than an independent finding).
- **No fix round applied this burst.** S-626-1 Step 4.5 remains 0/3 — the window closed 0/3, and DEC-235 pauses S-626-1 pending S-CIGATE-2 delivery per human direction (urgent standalone fix ahead of S-626-1). PR #667 remains HELD (DEC-202) at `51c7aa54`, CI 15/15, mergeStateStatus CLEAN — CLEAN merge state is not merge authorization; DEC-128 merge authority is the human's.
- **New story:** **S-CIGATE-2** (`.factory/stories/S-CIGATE-2-skipped-status-false-green.md`), v1.0: 7 ACs each with a verification vehicle, Red Gate mandated (AC-005: every new assertion proven RED against pre-fix `ci.yml`), specifying two candidate fixes in full: Option A (allowlist inversion, ~1-line diff, lower implementation risk) and Option B (skipped-safe gate condition + step-level restructure, recommended for architectural uniformity, conditional on AC-002/AC-003 shipping together — a locally-identified trap: `Check kill rate` already runs `if: always()` and branches on an outcome that becomes `skipped` under step-level gating, so an incomplete Option B converts today's false-green into a false-red on every push; must land as three atomic edits or not at all). **Superseded within the same burst window** (2026-08-06, v1.0→v2.0): a dedicated research pass rejected both options — Option A fails open on a forgotten allowlist entry; Option B's edit surface was re-derived at 5 steps (not 3), plus wasted runner time and an inverted "Mutation testing ✓" signal on push. **Option C — human-approved:** a fail-closed `scripts/check-ci-gate.sh` evaluator, restrictive `ALLOWED_SKIPS` allowlist (`mutants` only), default-fail arm for any unrecognized result value, wired into `spec-guard` (not `ci-gate` — a gate cannot depend on itself); `mutants` job left byte-identical (AC-006). Story revised to v2.0, 9 ACs, 8 points.
- **New drift items opened:** `CI-GATE-SKIPPED-FALSE-GREEN` (**HIGH**) — live repo-wide defect, empirically confirmed; S-CIGATE-2 opened. `CLOSED-STORY-CONTRADICTS-SHIPPED-BEHAVIOR` (**HIGH**) — an open story asserts a MUST NOT that shipped behavior and a test both contradict, with the establishing spec closed; generalizes the prior BC-COVERAGE-GAP class — not merely unowned, actively mis-owned; needs a spec-only follow-up story, human scoped this reconciliation as separate (deferral recorded per Cycle-Closing Checklist, not silently dropped). `FILES-MODIFIED-UNDECLARED` (**MEDIUM**) — fifth recurrence. `AUTHORIZATION-TRAIL-LAGS-CONTENT-NARRATIVE` (**MEDIUM**) — fifth consecutive round, always short by exactly one; mechanism identified (content narrated in `risk_mitigations`, authorization sites not extended).
- **Existing drift items updated:** `AGENT-IDLE-WITHOUT-DELIVERY` — **MITIGATION CONFIRMED EFFECTIVE**: 3/3 passes delivered unprompted this round vs 0/5 last round, sole change was naming `SendMessage(to: "team-lead", …)` as the first instruction in each brief; promoted from proposed to confirmed. Deferred ordering nuance folded in for future STATE.md writes: an agent's sense of "I already did that" does not reliably distinguish work completed from work completed *after being asked*, across idle boundaries — verify the tree after every "done" report, not only after findings. `DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE` — strongest confirmation yet: round 19 ended at 0H; three new frontiers immediately produced 3H, including a live repo-wide false-green 47 prior passes missed; the independent convergence of passes 49/50 on the same defect from opposite directions recorded as corroborating evidence. `TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE` — empirically confirmed by a pass designed to test it: round 19's own fix introduced pass-48 MED-001. `SPEC-CITATIONS-UNGUARDED-FOR-TEST-SYMBOLS` — second instance (pass-49 HIGH-001), in a file edited that same round. `ORCHESTRATOR-DISPOSITION-DRIFTS-FROM-ITEMIZATION` (lessons.md) — sixth datapoint: the orchestrator relayed pass-50's unverified "zero cancelled runs" claim without independent verification.
- **New decision:** **DEC-235** — window 48/49/50 CLOSED 0/3; S-626-1 Step 4.5 remains 0/3; PR #667 remains HELD (DEC-202) at `51c7aa54`, CI 15/15, merge CLEAN. S-626-1 PAUSED pending S-CIGATE-2 delivery.
- **Cycle-closing checklist (S-7.02) — SATISFIED.** Every process-gap finding from this window has either a follow-up story or an explicit justified deferral: `CI-GATE-SKIPPED-FALSE-GREEN` → S-CIGATE-2 (created, not deferred). `CLOSED-STORY-CONTRADICTS-SHIPPED-BEHAVIOR` → explicit deferral with a named next step (spec-only correction to `S-CIGATE-1-ci-gate-aggregator.md` AC-003, its Architecture Compliance Rules table, its Test Coverage Summary row, and its Edge Cases table — scoped OUT of S-CIGATE-2 per human direction, recorded here so it is not silently lost). `FILES-MODIFIED-UNDECLARED` / `AUTHORIZATION-TRAIL-LAGS-CONTENT-NARRATIVE` → tracked as recurring process-gap classes; no new story warranted at a fifth recurrence absent a distinct proposed fix.

---

## Pass 51 Finding Catalog (Fresh Window DEC-242, opening: NOT CLEAN — distinct inspection frontier: vacuous satisfaction — can an assertion pass while the property it protects is broken)

Pass-51 opened window 51/52/53, run against frozen head `ada50a34`. ELIGIBLE — no isolation breaches, no read of `.factory/cycles/`. This pass asked whether the CI-gate guard family's assertions can be satisfied while the property they protect is actually broken. Root cause identified: every anti-neutering control built for `ci-gate` (step-level `if:` ban, `continue-on-error` ban, env key-set pin, byte-for-byte run-line pin) stops at the `ci-gate` job block, while `test` — the `needs` member whose failure signal is the entire point of the gate — is guarded only by 15 order-free, position-free substring checks. **Characterization, recorded explicitly: none of these are live defects.** CI at `ada50a34` is correct; `set +o pipefail` currently sits in the safe position, and no `if:` or `continue-on-error` is present on the `test` step. These are guard-STRENGTH gaps — the pins do not prevent the regressions.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P51-HIGH-001 | HIGH | vacuous-satisfaction-skipped-step | `test_verify_test_job_has_zero_test_floor` is fully satisfied by a step that never executes. Adding `if: false` to `ci.yml :: test / "Run tests (zero-test floor, POL-11)"` skips the step; the job concludes `success`; `CI Gate` goes green with zero tests executed. All 15 assertions stay green because the edit only ADDS text. The test's own comment claims "removing the guard entirely fails this test" — that claim is false. `test_ci_gate_needs_jobs_have_no_job_level_if` does not catch it (8-space indent ≠ its 4-space match); M2-d's step-level-`if:` ban is scoped to `gate_block` only | OPEN | |
| ADV-P51-HIGH-002 | HIGH | continue-on-error-neutralizes-exit-gates | `continue-on-error: true` on the same step neutralizes all four `exit 1` gates AND a genuine `cargo test` failure. The ban exists for `ci-gate` (M2-j) but was never propagated to `test`. `ci.yml :: mutants` already uses `continue-on-error: true`, so the construct is visually normalized in this exact file. Same gap on `msrv`, `spec-guard`, `deny`, `fmt`, `clippy` | OPEN | |
| ADV-P51-HIGH-003 | HIGH | pipefail-position-blind-assertion | Highest impact: the three `set … pipefail` assertions are order-blind, and the suite MANDATES THE EXISTENCE OF THE TOKEN THAT DEFEATS THEM — it asserts `set +o pipefail\n` exists with no constraint on position. Moving the existing `set +o pipefail` up ~13 lines (net line count unchanged; reads as "consolidated the pipefail bracket") makes `cargo test --all-features 2>&1 \| tee` yield tee's always-0 status, so `set -e` never fires. A genuinely failing suite still prints result lines, so every floor and the canary pass — CI green with red tests. **This fires on ordinary test breakage, not a deliberate bypass.** Reopens the round-17 CRITICAL by a different construction | OPEN | |
| ADV-P51-MED-001 | MEDIUM | single-unqualified-exit1-substring | `contains("exit 1")` is a single unqualified check against four mutually-masking branches; changing the binary-count floor's `exit 1` to `exit 0` (one character) disables that gate and skips the remaining three, all 15 assertions still green | OPEN | |
| ADV-P51-MED-002 | MEDIUM | unpinned-open-env-key-set | The `test` step's `env:` mapping is an unpinned open set — round 12's `PINNED_GATE_ENV_KEYS`/`PINNED_WORKFLOW_ENV_KEYS` fix was never propagated. A `BASH_ENV:` sibling plus a shim bypasses the whole guard script | OPEN | |
| ADV-P51-LOW-001 | LOW | unreachable-fallback-branch | Instrument 2c's stated rationale describes an unreachable branch — under `set -e` with pipefail restored, a no-match `grep` aborts the shell before the `if [ -z "${_canary_running_line}" ]` fallback can run, so that branch is dead code and the documented Windows failure mode would actually have been a bare message-less exit 1. Lands on the pin added earlier today in `ada50a34`. Fail-closed direction, not a false-green | OPEN | |
| ADV-P51-INFO-001 | INFO | unanchored-string-find-latent | `tests/common/yaml.rs::extract_job_block` uses unanchored `str::find`; comment-satisfiability of all 15 pins checked and currently latent, not live (each pinned literal verified to occur exactly once, operative) | CONFIRMED, not a defect | |
| ADV-P51-INFO-002 | INFO | sibling-guards-reverified-clean | The two sibling structural guards (8 and 4 assertions, on `msrv` and the needs-set check respectively) were re-counted directly against source and found unchanged from their FIX-ROUND-20 baseline — no drift, no additional vacuous-satisfaction vector found in either | CONFIRMED, not a defect | |

## Pass 51 Isolation Note

**ELIGIBLE.** Dispatched against frozen head `ada50a34` per DEC-242. No isolation breach; no read of `.factory/cycles/`.

## Pass 51 Summary

- **Verdict:** NOT CLEAN — 3 HIGH + 2 MEDIUM + 1 LOW + 2 INFO; ELIGIBLE; all findings are guard-strength gaps, not live defects — CI at `ada50a34` is correct
- **Frontier:** vacuous satisfaction — can an assertion pass while the property it protects is broken
- **Convergence:** window 51/52/53 opened NOT CLEAN
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 52 Finding Catalog (Fresh Window DEC-242, continued: NOT CLEAN — distinct inspection frontier: reconciliation seams — what did merging two stories' edits leave inconsistent)

Pass-52 continued window 51/52/53, run against frozen head `ada50a34`. ELIGIBLE, distinct frontier from pass-51 — this pass checked whether the S-CIGATE-2/S-626-1 merge left any false-green vector, and separately whether the two stories' narrative surfaces stayed consistent with each other and with shipped `ci.yml`. **Significant negative result, recorded explicitly: the merge left NO false-green vector.** Every decision-path pin attacked is consistent with shipped `ci.yml`; every disagreement found fails closed. `PINNED_GATE_JOB_KEYS` (incl. round 20's `timeout-minutes`), `PINNED_GATE_STEP_KEY_SETS`, `PINNED_GATE_ENV_KEYS`, `PINNED_WORKFLOW_ENV_KEYS`, `PINNED_GATE_RUN_LINE`, `PINNED_GATE_IF_EXPR`, `PINNED_GATE_NEEDS_JSON_LINE` all byte-match. `EXPECTED_FIXTURES=13` matches 13 `check_fixture` calls. F-01's pin correctly not reinstated. Binary-floor accounting exact (104 `tests/**/*.rs` − 4 in `tests/common/` = 100 targets vs the `< 90` floor). Its finding is instead narrative drift: Line B retargeted docstrings but not the assertion messages, test names, in-code comments, and downstream docs beside them.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P52-MED-001 | MEDIUM | diagnostic-instructs-reintroducing-defect | M2-c's panic message instructs putting `contains(needs.*.result, …)` on a step-level `if:` — which M2-d forbids 20 lines later and `test_ci_gate_fails_on_failed_or_cancelled_need` also rejects. M2-c is reachable as a FALSE-RED on a correct `if:` (raw `job_if_line` contains the substring where the normalized comparison strips a trailing comment), emitting instructions that break the build in two other places if followed | OPEN | |
| ADV-P52-MED-002 | MEDIUM | test-name-no-longer-checks-what-it-claims | `test_ci_gate_fails_on_failed_or_cancelled_need` asserts a guarantee its retargeted body no longer checks; the module coverage map still credits it with AC-002. Grep-verified: NO Rust test in the 4,723-line file ever synthesizes a `failure` or `cancelled` result — that property is proven solely by `check-ci-gate.sh --self-test` fixtures 2/5/6 in `spec-guard`. Coverage is intact end-to-end; this is a naming/traceability defect. But `cargo test` locally gives zero signal on the gate's core failure semantics despite a test named for it, and the sibling test was renamed in round 20 for exactly this class while this one was not | OPEN | |
| ADV-P52-MED-003 | MEDIUM | stale-comment-tells-maintainer-no-allowlist-needed | `test_ci_gate_needs_exactly_the_required_jobs` — both the in-array comment on `"mutants"` and the `extra`-branch failure message state the retired mechanism as live, telling a maintainer a PR-only job needs no allowlist entry. Post-merge, `mutants` is safe only via `ALLOWED_SKIPS` + a matching `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` entry. The most likely future edit here lands a change that turns develop's sole required check red on every push | OPEN | |
| ADV-P52-MED-004 | MEDIUM | claude-md-propagated-rename-not-semantics | Worktree `CLAUDE.md` CI-Gate bullet propagated the round-20 RENAME but not the SEMANTICS — it still describes the narrower `github.event_name`-substring, line-scoped predicate that round 19's F-03 fix deliberately abandoned. CLAUDE.md is now the authority supplying the mistaken justification for re-narrowing it | OPEN | |
| ADV-P52-MED-005 | MEDIUM | policy-doc-states-false-green-as-rationale | `docs/specs/cargo-mutants-policy.md` §"Push-Event Safety" states the false-green itself as the safety rationale ("ci-gate checks failure or cancelled only — skipped is neither, so ci-gate passes on push"). `ALLOWED_SKIPS`/`check-ci-gate.sh` appear nowhere in that document | OPEN | |
| ADV-P52-MED-006 | MEDIUM | policy-doc-budget-150-minutes-off | `docs/specs/cargo-mutants-policy.md` pins the `mutants` budget at 90 minutes in SIX places (twice as an explicit "Do NOT increase beyond 90" prohibition) while `ci.yml :: mutants` ships `timeout-minutes: 240`. Its whole §F-2 cancelled-job analysis is computed 150 minutes off. A maintainer enforcing the doc would create the very `cancelled` results that now hard-block merge | OPEN | |
| ADV-P52-MED-007 | MEDIUM | s626-1-historical-entries-lack-supersession-marker | `S-626-1.md`'s own `risk_mitigations` entries predating the S-CIGATE-2 merge (rounds ≤18) still describe `ci-gate`'s decision path via the retired inline `contains(needs.*.result, …)` mechanism as the live implementation. Each entry is dated and technically a historical record, but none carries an explicit "superseded by Option C" pointer the way the round-20 and round-23 entries do — a reader skimming chronologically outward from the most recent entry has no in-file signal marking where the described mechanism stopped being true. Same class as the six findings above, extended into the story's own historical narrative | OPEN | |
| ADV-P52-LOW-001 | LOW | jq-fallback-unreachable-contradicts-own-header | `ci.yml :: mutants / "Check kill rate"` — the `command -v jq` fallback branch is unreachable (an earlier unguarded `jq empty` call exits 127 first), so a missing-jq runner is misdiagnosed as corrupt tool output; and `check-ci-gate.sh`'s `# TOOLING CHOICE` header cites this exact step as proof `jq` is an assumed dependency, contradicted by the fallback beside it | OPEN | |
| ADV-P52-LOW-002 | LOW | step-arity-claim-unenforced | `test_mutants_job_structure_unchanged_by_cigate2_option_c` claims step-arity enforcement ("no steps added, removed, or reordered") its six `contains` presence checks cannot deliver. Round 11 replaced exactly this weakness for `ci-gate` with `PINNED_GATE_STEP_KEY_SETS`; `mutants` was left on the weaker mechanism. Flagged pending intent verification | OPEN | |
| ADV-P52-INFO-001 | INFO | dangling-symbol-reference | Dangling symbol — a docstring references `parse_allowed_skips_from_script` as "retired below"; repo-wide grep finds it nowhere | OPEN — cosmetic | |
| ADV-P52-INFO-002 | INFO | fixture-count-reverified-independent-method | `EXPECTED_FIXTURES=13` re-counted directly against `check-ci-gate.sh --self-test`'s actual fixture definitions a second time, via an independent counting method (grep vs manual enumeration) — both methods agree, closing any residual doubt from the primary count method alone | CONFIRMED, not a defect | |

## Pass 52 Isolation Note

**ELIGIBLE.** Same frozen head as pass-51. No isolation breach; no read of `.factory/cycles/`.

## Pass 52 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 7 MEDIUM + 2 LOW + 2 INFO; ELIGIBLE; **significant negative result: the S-CIGATE-2/S-626-1 merge left no false-green vector — every decision-path pin checked is consistent with shipped `ci.yml`**, all findings are narrative/documentation drift, not decision-logic defects
- **Frontier:** reconciliation seams — what did merging two stories' edits leave inconsistent
- **Convergence:** window 51/52/53 still NOT CLEAN after two passes; zero HIGH this pass, all seven MEDIUM are doc/narrative-lag findings
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Pass 53 Finding Catalog (Fresh Window DEC-242, closing: NOT CLEAN — distinct inspection frontier: spec-to-shipped-behavior — which spec claims are false at this head)

Pass-53 closed window 51/52/53, run against frozen head `ada50a34`. ELIGIBLE, distinct frontier from passes 51/52 — this pass checked S-CIGATE-1, S-626-1, and cross-cutting.md's BC-X.13.007 against the actual shipped test assertions and workflow file, in the spec-to-shipped-behavior direction. **Pass 53 also verified and listed a substantial set of claims as SOUND — AC-2/3/4/5/6/7/8/9, VP-CIGATE-001's fifteen assertions, `check-ci-gate.sh`'s `EXPECTED_FIXTURES=13` / `ALLOWED_SKIPS=("mutants")` / spec-guard wiring — recorded here because it is what makes the negative findings below credible, not a blanket-suspicion result.**

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P53-HIGH-001 | HIGH | spec-asserts-inverse-of-shipped-assertion | S-CIGATE-1 AC-004 item 6 and its Test Coverage row 6 state the test pins a step-level `contains(needs.*.result,'failure'/'cancelled')` condition; the shipped assertion M2-d asserts the exact INVERSE (`!has_step_level_if`), and a sibling asserts the `contains(` string is absent entirely. A false verification-status claim in the worst direction — a maintainer "restoring" it would reopen the false-green S-CIGATE-2 fixed. Unlabeled and present-tense; AC-004 carries none of the correction blockquotes attached to AC-002/AC-003 | OPEN | |
| ADV-P53-HIGH-002 | HIGH | needs-list-stale-at-four-sites | The six-job `ci-gate.needs` list appears as current fact at four unlabeled sites (AC-001, AC-003 "Pinned by", AC-004 item 2, the FSR row); shipped is eight and the cited test builds its expected set from all eight. AC-001 is the canonical structural definition of the repo's sole required check | OPEN | |
| ADV-P53-MED-001 | MEDIUM | ac002-pinned-by-inverted | AC-002's "Pinned by" describes a positive grep for the retired condition where the shipped test asserts its absence | OPEN | |
| ADV-P53-MED-002 | MEDIUM | three-dead-citations-renamed-test | Three dead citations to `test_ci_gate_needs_jobs_have_no_event_conditional_if` (renamed round 20) whose stale description is the NARROWER predicate F-03 deliberately abandoned | OPEN | |
| ADV-P53-MED-003 | MEDIUM | mandated-comment-does-not-exist | AC-002 mandates an `always()` rationale comment in `ci.yml` that does not exist | OPEN | |
| ADV-P53-MED-004 | MEDIUM | purity-classification-omits-subprocess-spawn | The Purity Classification calls `ci_gate_completeness.rs` pure with "no script execution" while it spawns `bash` as a subprocess (three tests are `#[cfg(unix)]`-gated precisely because they do) | OPEN | |
| ADV-P53-MED-005 | MEDIUM | invariants-list-includes-nonexistent-construct | BC-X.13.007's Invariants enumeration includes a step-level `contains(...)` construct that does not exist — an inaccurate member inside an otherwise-accurate list, reinforcing the same false picture from a second independent document | OPEN | |
| ADV-P53-LOW-001 | LOW | ac10-internally-inconsistent-gate-count | S-626-1 AC-10 item 5 enumerates "Three independent gate checks" while four `exit 1` gates ship (AC-10 is internally inconsistent with its own commit-trail paragraph) | OPEN | |
| ADV-P53-LOW-002 | LOW | fsr-and-tasks-prescribe-retired-body | S-CIGATE-1's FSR and Tasks still prescribe the retired gate-step body as the required implementation | OPEN | |
| ADV-P53-LOW-003 | LOW | frontmatter-status-draft-despite-shipped | S-CIGATE-1's frontmatter reads `status: draft` despite all deliverables shipped and five follow-on stories | OPEN | |
| ADV-P53-INFO-001 | INFO | size-estimates-internally-contradictory | S-CIGATE-1's size estimates internally contradictory (~30 lines vs ~450 LOC vs ~4,700 actual) | OPEN — cosmetic | |

**Pass 53 root-cause finding, recorded verbatim in the drift ledger:** "Because prior correction rounds were driven by individually-reported findings rather than a sweep of every occurrence, the selective-correction pattern is itself the defect." Corrections propagated only to sites where a blockquote was manually attached; every unmarked site retains pre-migration text, and two now assert the logical inverse of shipped behavior. **This independently confirms TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE from a pass with no access to the drift register.**

## Pass 53 Isolation Note

**ELIGIBLE.** Same frozen head as passes 51/52. No isolation breach; no read of `.factory/cycles/`.

## Pass 53 Summary

- **Verdict:** NOT CLEAN — 2 HIGH + 5 MEDIUM + 3 LOW + 1 INFO; ELIGIBLE; a substantial confirmed-SOUND set is on record alongside the negative findings, which is what makes the negative findings credible rather than a blanket-suspicion sweep
- **Frontier:** spec-to-shipped-behavior — which spec claims are false at this head
- **Convergence:** window 51/52/53 CLOSED 0/3 — all three passes NOT CLEAN
- **Detail artifact:** not yet captured as a standalone file at burst time

---

## Window 51/52/53 Summary

- **Result:** CLOSED 0/3 — pass-51 NOT CLEAN (3H+2M+1L+2I), pass-52 NOT CLEAN (0H+7M+2L+2I), pass-53 NOT CLEAN (2H+5M+3L+1I), against frozen head `ada50a34`. Three deliberately-varied inspection frontiers, human-approved before dispatch per the DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE caution: (51) vacuous satisfaction — can an assertion pass while the property it protects is broken; (52) reconciliation seams — what did merging two stories' edits leave inconsistent; (53) spec-to-shipped-behavior — which spec claims are false at this head. All three ELIGIBLE — no isolation breaches reported; no pass read `.factory/cycles/`.
- **Finding count:** 30 new findings total across the three passes: pass-51 = 3H+2M+1L+2I (8); pass-52 = 0H+7M+2L+2I (11); pass-53 = 2H+5M+3L+1I (11); 8+11+11 = 30.
- **HIGH:** 5 — ADV-P51-HIGH-001/002/003 (vacuous-satisfaction guard-strength gaps in `test`: skip-step, `continue-on-error`, order-blind pipefail assertion), ADV-P53-HIGH-001/002 (S-CIGATE-1 spec claims falsified by shipped behavior — one asserting the logical inverse of the shipped assertion, one citing a stale six-job `needs` list at four sites). **IMPORTANT CHARACTERIZATION for pass-51's HIGH findings, recorded explicitly: none are live defects. CI at `ada50a34` is correct** — these are guard-STRENGTH gaps (the pins do not prevent the regressions), not regressions themselves.
- **MEDIUM:** 14 itemized (ADV-P51-MED-001/002; ADV-P52-MED-001..007; ADV-P53-MED-001..005), all distinct, all OPEN.
- **LOW:** 6 itemized and distinct (ADV-P51-LOW-001; ADV-P52-LOW-001/002; ADV-P53-LOW-001/002/003), all OPEN.
- **INFO:** 5 itemized (ADV-P51-INFO-001/002; ADV-P52-INFO-001/002; ADV-P53-INFO-001). 4 CONFIRMED/not-a-defect or cosmetic, 1 (ADV-P52-INFO-001) OPEN as a cosmetic cleanup item.
- **No fix round applied this burst.** S-626-1 Step 4.5 remains 0/3 — the window closed 0/3, and the orchestrator has recommended AGAINST another targeted round against this window's MEDIUM/LOW narrative-drift findings, putting the methodology question to the human instead. PR #667 remains HELD (DEC-202) at `ada50a34`, CI 15/15, mergeStateStatus CLEAN — CLEAN merge state is not merge authorization; DEC-128 merge authority is the human's.
- **New drift items opened:** `ANTI-NEUTERING-CONTROLS-STOP-AT-CI-GATE` (**HIGH**) — every structural control hardened for `ci-gate` across 20 fix rounds was never propagated to `test`, `msrv`, or the other `needs` members; `test` carries the entire regression suite and is defended only by order-free substring checks. `GUARD-MANDATES-ITS-OWN-DEFEAT-TOKEN` (**HIGH**) — a presence assertion that requires a disabling construct to exist, without constraining its position, guarantees the defeat token is always available (instance: the `set +o pipefail` pin); generalize before fixing. `DIAGNOSTIC-INSTRUCTS-REINTRODUCING-THE-DEFECT` (**MEDIUM**) — assertion messages and in-code comments retained pre-migration remediation advice after the mechanism changed; two instances instruct reconstructing exactly the shape S-CIGATE-2 retired. `DOWNSTREAM-DOCS-EXCLUDED-FROM-CORRECTION-PERIMETER` (**MEDIUM**) — `docs/specs/cargo-mutants-policy.md` was never in any correction perimeter: it states the false-green as its safety rationale and pins a 90-minute budget against a shipped 240; correction perimeters have been scoped to `.factory/` artifacts plus `CLAUDE.md`, excluding `docs/specs/`.
- **Existing drift items updated:** `TARGETED-FIX-ROUNDS-DO-NOT-CONVERGE` — independently confirmed by pass 53 with no drift-register access; verbatim root-cause sentence recorded: "Because prior correction rounds were driven by individually-reported findings rather than a sweep of every occurrence, the selective-correction pattern is itself the defect." `CLOSED-STORY-CONTRADICTS-SHIPPED-BEHAVIOR` (reopened last burst) — six further instances this window, two of which assert the logical inverse of shipped behavior. `DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE` — reinforced a FIFTH time, and this time by construction: three deliberately-varied frontiers each found material no prior frontier had, on a tree that passes 15/15 CI. `SPEC-CITATIONS-UNGUARDED-FOR-TEST-SYMBOLS` — third instance (ADV-P53-MED-002, three dead citations to a round-20-renamed test symbol in `.factory/stories/*.md`), no CI guard validates `tests/`-symbol citations there the way `check-bc-citation-symbols.sh` does for `src/` symbols in BC files; tracked as a process-gap needing a follow-up story or a justified deferral per S-7.02 — recorded as a natural scope extension of the already-drafted `S-TRAIL-DERIVATION-GUARD-1`, not a new independent story.
- **New decision:** **DEC-242** — WINDOW 51/52/53 CLOSED 0/3 (2026-08-07). Three deliberately-varied inspection frontiers, human-approved before dispatch per the DECAY-CURVE-MEASURES-QUESTION-EXHAUSTION-NOT-CONVERGENCE caution: (51) vacuous satisfaction — can an assertion pass while the property it protects is broken; (52) reconciliation seams — what did merging two stories' edits leave inconsistent; (53) spec→shipped behavior — which spec claims are false at this head. All three NOT CLEAN. 30 findings: 5 HIGH, 14 MEDIUM, 6 LOW, 5 INFO. Step 4.5 remains 0/3.
- **Cycle-closing checklist (S-7.02) — PARTIALLY APPLIED, pending human ruling.** `SPEC-CITATIONS-UNGUARDED-FOR-TEST-SYMBOLS`'s third instance is tracked as a natural scope extension of `S-TRAIL-DERIVATION-GUARD-1` (satisfies the follow-up-story requirement by extension, not a new story). The two new HIGH drift items (`ANTI-NEUTERING-CONTROLS-STOP-AT-CI-GATE`, `GUARD-MANDATES-ITS-OWN-DEFEAT-TOKEN`) and the fourteen MEDIUM/LOW narrative-drift findings are explicitly NOT authorized for a fix round this burst — the orchestrator's recommendation and the open methodology question (DEC-204) are recorded in STATE.md's Session Resume Checkpoint and Pending Human Decisions, not resolved here.

---

## Pass 54 Finding Catalog (Fresh Window DEC-248, frontier C1: bootstrap trust — dispatched against head `0e61a2dc`)

Pass-54 opened window 54/55/56 against the two guards landed directly this burst (`0e61a2dc`) plus everything already shipped. Frontier: does the guard apparatus's own bootstrapping (its self-tests, fixture counts, and self-referential pins) actually earn the trust the rest of the suite places in it, or does some of that trust rest on an assumption never itself verified.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P54-MED-001 | MEDIUM | key-detect-value-reparse-swallow | `0e61a2dc`'s new sibling-workflow guard detects the `name:` key with `extract_key_name_at_indent` but re-reads its value with a bare `strip_prefix`, swallowing a quoted/space-before-colon spelling | CLOSED on `910b8ab0` | DUPLICATE of `ADV-P56-MED-001` (same instance, independently found) — closed together by the class sweep, not as two separate point fixes |
| ADV-P54-MED-002 | MEDIUM | key-detect-value-reparse-swallow | Guard A's `extract_job_display_name` accepts a raw source-byte comparison for quoted `name:` values instead of routing through the same reject-don't-parse idiom used elsewhere in the file | CLOSED on `910b8ab0` | Twin of `ADV-P55-MED-002` — independently found in a different clone of the same defect class; both closed by the same commit |
| ADV-P54-MED-003 | MEDIUM | no-fixed-denominator-self-check | This file has no fixed-denominator self-check on its own `#[test]` count (unlike `check-ci-gate.sh --self-test`'s `EXPECTED_FIXTURES`); POL-11's canary only requires a non-zero passed count, so a silently deleted test trips nothing here | CLOSED on `910b8ab0` | Closed by new `EXPECTED_GUARD_TEST_COUNT = 27` + `test_this_file_test_count_matches_expected_denominator` — this finding's own text is quoted verbatim in that test's panic message |
| ADV-P54-LOW-001 | LOW | review-scope-understated | CLAUDE.md's CI Gate scope summary reads as though `ci.yml` alone is the review surface; `scripts/check-ci-gate.sh` and `tests/ci_gate_completeness.rs` are equally PR-supplied and equally on the decision path | CLOSED on `910b8ab0` | CLAUDE.md gains an explicit "review scope is three files, not one" note |
| ADV-P54-INFO-001 | INFO | cosmetic | `matrix_needs_members`'s hardcoded `["clippy", "test"]` iteration list will silently miss a third matrix job added later without a code change flagging it | CLOSED on `910b8ab0` | Closed by deriving the iteration list from `ci-gate.needs` directly |

## Pass 54 Isolation Note

**ELIGIBLE.** Fresh window against head `0e61a2dc`; no isolation breach; no read of `.factory/cycles/`.

## Pass 54 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 3 MEDIUM + 1 LOW + 1 INFO; ELIGIBLE; frontier C1 (bootstrap trust) found the first instance of this window's converged root cause (key-detect/value-reparse swallow), independently from pass-55 and pass-56.
- **Frontier:** C1 — bootstrap trust: does the guard apparatus's own self-tests and fixed-denominator pins earn the trust placed in them.
- **Convergence:** window 54/55/56 opens NOT CLEAN.

---

## Pass 55 Finding Catalog (Window 54/55/56, frontier C2: differential lexer conformance — dispatched against head `0e61a2dc`)

Pass-55 ported the file's line-based extractor functions to Python and ran them differentially against PyYAML 6.0.3 over a battery of synthesized YAML fixtures (quoted keys, space-before-colon, flow-style, node properties, non-LF line breaks) — executed, not merely reasoned about from reading the Rust source.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P55-HIGH-001 | HIGH | depth-erasing-line-match-false-green | `parse_needs_set` locates the gate job's own `needs:` line via `line.trim()` (no depth anchor); a decoy `needs:`-shaped line planted inside the gate step's own unpinned `with:` block is read as the job's real needs set — verified false-green with seven jobs failing simultaneously | CLOSED on `910b8ab0` | Closed by depth-anchoring via `extract_key_name_at_indent` at indent 4 (new `PINNED_GATE_NEEDS_LINE` / `extract_and_normalize_sole_needs_line`, M2-p) + a hard panic on a duplicate job-level `needs:` key |
| ADV-P55-MED-001 | MEDIUM | key-detect-value-reparse-swallow | `list_job_ids_in_workflow` matches the `jobs:` anchor and per-job-id detection via line-equality/`endswith(':')` instead of `extract_key_name_at_indent`/`collect_mapping_key_set` — a flow-style job entry is invisible | CLOSED on `910b8ab0` | Both `list_job_ids_in_workflow` and `list_all_ci_yml_job_names` rerouted through the quote-aware matchers |
| ADV-P55-MED-002 | MEDIUM | key-detect-value-reparse-swallow | Guard B's `os:` value re-read `unwrap_or("")`s an unparseable-but-detected key instead of failing loudly, trivially certifying a matrix as static when the value is actually a block-sequence form | CLOSED on `910b8ab0` | Twin of `ADV-P54-MED-002` — independently found; both closed together. Guard B now reads block-sequence `os:` forms explicitly and panics on anything else unparseable |
| ADV-P55-MED-003 | MEDIUM | silent-continue-on-disagreement | Guard A's `extract_job_block`-vs-`list_job_ids_in_workflow` disagreement silently `continue`s past the mismatched job instead of failing | CLOSED on `910b8ab0` | Now a hard panic naming the file and job id |
| ADV-P55-MED-004 | MEDIUM | overstated-key-coverage-claim | CLAUDE.md's round-9 claim that `test_ci_gate_needs_jobs_have_no_job_level_if` matches "ANY job-level `if:` key… regardless of shape or content" overstates KEY-spelling coverage — the underlying match was a bare `line.starts_with("    if:")`, missing `"if":`/`'if':`/`if :` | CLOSED on `910b8ab0` | Both the test and `is_job_level_if_line` rerouted through `extract_key_name_at_indent`; CLAUDE.md's claim corrected in place (this is `ADV-P55-LOW-001`'s CLAUDE.md correction, cross-referenced) |
| ADV-P55-LOW-001 | LOW | overstated-key-coverage-claim | Same underlying gap as `ADV-P55-MED-004`, filed independently against the CLAUDE.md prose itself rather than the code | CLOSED on `910b8ab0` | DUPLICATE of `ADV-P56-LOW-003` (same instance, independently found in a different clone) |
| ADV-P55-LOW-002 | LOW | fixture-lacks-discriminating-assertion | `check-ci-gate.sh` fixture 10 (malformed-json) lacks a discriminating 4th-argument substring the way fixture 9 already has, weakening what a fixture-10 regression would actually prove | CLOSED on `910b8ab0` | Fixture 10 gains a discriminating substring matching fixture 9's precedent |
| ADV-P55-INFO-001 | INFO | cosmetic | `docs/specs/cargo-mutants-policy.md` does not state plainly that `tests/`/`scripts/`/`ci.yml`/`check-ci-gate.sh` are structurally unreachable by any Rust mutation tool | CLOSED on `910b8ab0` | New Scope subsection added |

## Pass 55 Isolation Note

**ELIGIBLE.** Same head as pass-54 (`0e61a2dc`); no isolation breach; no read of `.factory/cycles/`.

## Pass 55 Summary

- **Verdict:** NOT CLEAN — 1 HIGH + 4 MEDIUM + 2 LOW + 1 INFO; ELIGIBLE; frontier C2 (differential lexer conformance, executed via Python ports + PyYAML 6.0.3, not reasoned about from source alone) found an independent live false-green (`ADV-P55-HIGH-001`) in addition to further instances of this window's converged root cause.
- **Frontier:** C2 — differential lexer conformance: does every line-based extractor in this file agree with a real YAML parser on every reachable spelling.
- **Convergence:** window 54/55/56 still NOT CLEAN after two passes; one HIGH — a verified false-green, not a guard-strength gap.

---

## Pass 56 Finding Catalog (Window 54/55/56, frontier C5: falsifiability census — dispatched against head `0e61a2dc`)

Pass-56 built standalone `rustc` reproductions of this file's individual extractor functions (no external crates, minimal structurally-faithful excerpts) and ran them directly against hand-crafted YAML spellings, closing the window with the third and largest finding set — confirming, not merely re-asserting, pass-54's and pass-55's shared root-cause diagnosis via independent tooling.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P56-HIGH-001 | HIGH | key-detect-value-reparse-swallow | Guard A's `name:` value re-read defeats detection identically to `ADV-P55-HIGH-001`'s needs-line finding, reproduced independently via standalone `rustc` | CLOSED on `910b8ab0` | Panics loudly instead of `?`-propagating `None` on an unparseable-but-detected key |
| ADV-P56-HIGH-002 | HIGH | key-detect-value-reparse-swallow | Guard B's `os:` value re-read defeats detection identically, reproduced independently via standalone `rustc` | CLOSED on `910b8ab0` | Panics loudly on the same class of unparseable-but-detected key |
| ADV-P56-MED-001 | MEDIUM | key-detect-value-reparse-swallow | Sibling-workflow guard's `name:` value re-read swallow, reproduced independently via standalone `rustc` | CLOSED on `910b8ab0` | DUPLICATE of `ADV-P54-MED-001` — same instance, independently found; closed together |
| ADV-P56-LOW-001 | LOW | line-splitting-residual-not-newly-closed | `extract_and_normalize_if_expr`'s `is_job_level_if_line` closure duplicated the same bare-spelling gap `ADV-P55-MED-004`/`ADV-P55-LOW-001` found in the test-level matcher | CLOSED on `910b8ab0` | Closed by the same reroute through `extract_key_name_at_indent` |
| ADV-P56-LOW-002 | LOW | fixture-lacks-discriminating-assertion | Independently re-found `ADV-P55-LOW-002` (fixture 10 discriminating-assertion gap) via the standalone reproduction harness | CLOSED on `910b8ab0` | Closed together with `ADV-P55-LOW-002` |
| ADV-P56-LOW-003 | LOW | overstated-key-coverage-claim | Independently re-found the CLAUDE.md overstated-coverage-claim gap | CLOSED on `910b8ab0` | DUPLICATE of `ADV-P55-LOW-001` — same instance, independently found in a different clone |
| ADV-P56-LOW-004 | LOW | matrix-iteration-list-hardcoded | Independently re-found `ADV-P54-INFO-001`'s hardcoded `["clippy", "test"]` iteration-list gap, assessed LOW rather than INFO by this pass | CLOSED on `910b8ab0` | Closed by `matrix_needs_members`; severity divergence from `ADV-P54-INFO-001` recorded, not reconciled — both entries kept on record as independently assessed |
| ADV-P56-INFO-001 | INFO | cosmetic | `docs/specs/cargo-mutants-policy.md` Scope gap, independently re-found | CLOSED on `910b8ab0` | Closed together with `ADV-P55-INFO-001` |
| ADV-P56-INFO-002 | INFO | cosmetic | `check-ci-gate.sh --self-test`'s spec-guard step self-test invocation had two substring checks each independently satisfiable by the step's other two `--self-test` invocations | CLOSED on `910b8ab0` | Closed by new `PINNED_CI_GATE_SELF_TEST_RUN_LINE` byte-pinning the step's own `run:` line |
| ADV-P56-INFO-003 | INFO | cosmetic | `test_ci_yml_contains_no_non_lf_yaml_line_breaks` scans `ci.yml` only, not the sibling workflow files the round-16-era sibling-workflow guard newly makes reachable | CLOSED on `910b8ab0` | Now scans every sibling workflow file via `list_workflow_files` |
| ADV-P56-INFO-004 | INFO | falsifiability-census-negative-result | Census of every set-equality pin in the file found no further instance of the key-detect/value-reparse swallow beyond the sites already found by pass-54/55/56 and the three sites `0e61a2dc` itself introduced — the 25 pre-existing extractors are unaffected | CLOSED on `910b8ab0` | Recorded as the census's own closing negative result — what makes the positive findings above credible as a complete class sweep rather than a partial one |

## Pass 56 Isolation Note

**ELIGIBLE.** Same head as pass-54/pass-55 (`0e61a2dc`); no isolation breach; no read of `.factory/cycles/`.

## Pass 56 Summary

- **Verdict:** NOT CLEAN — 2 HIGH + 1 MEDIUM + 4 LOW + 4 INFO; ELIGIBLE; frontier C5 (falsifiability census, executed via standalone `rustc` reproductions) closes window 54/55/56 with independent confirmation of the shared root cause plus a closing negative-result census (`ADV-P56-INFO-004`) that bounds the defect class's actual extent.
- **Frontier:** C5 — falsifiability census: for every set-equality pin in the file, is there a concrete construction that defeats it, and if not, is that absence itself demonstrated rather than assumed.
- **Convergence:** window 54/55/56 CLOSED 0/3 — all three passes NOT CLEAN.

---

## Window 54/55/56 Summary

- **Result:** CLOSED 0/3 — pass-54 NOT CLEAN (0H+3M+1L+1I), pass-55 NOT CLEAN (1H+4M+2L+1I), pass-56 NOT CLEAN (2H+1M+4L+4I), against head `0e61a2dc`. Three deliberately-varied Family-C inspection frontiers, human-approved before dispatch per DEC-248 after a documented exhaustion survey found the prior Family-C frontiers (passes 30-41) verbatim repeats: (54) C1 bootstrap trust; (55) C2 differential lexer conformance (executed via Python ports + PyYAML 6.0.3); (56) C5 falsifiability census (executed via standalone `rustc` reproductions). All three ELIGIBLE — no isolation breaches reported; no pass read `.factory/cycles/`. **Ninth consecutive window without 3/3 since window 30/31/32.**
- **Finding count:** 24 new findings total across the three passes: pass-54 = 0H+3M+1L+1I (5); pass-55 = 1H+4M+2L+1I (8); pass-56 = 2H+1M+4L+4I (11); 5+8+11 = 24. Deduplicates to roughly 16 distinct underlying findings — three explicit dedupe pairs/twins on record: `ADV-P54-MED-001` ≡ `ADV-P56-MED-001`; `ADV-P55-LOW-001` ≡ `ADV-P56-LOW-003`; `ADV-P54-MED-002` and `ADV-P55-MED-002` are twins independently found in different clones of the same underlying defect. **Zero rediscoveries of any finding from passes 1-53.**
- **HIGH:** 3 — `ADV-P55-HIGH-001` (depth-erasing `needs:` line match, verified false-green with seven jobs failing) and `ADV-P56-HIGH-001`/`ADV-P56-HIGH-002` (Guard A/B value-reread swallows, independently confirmed via standalone `rustc`). **All three are live defects introduced by `0e61a2dc` this same burst, not pre-existing guard-strength gaps** — distinct in kind from prior windows' HIGH findings, which mostly characterized gaps in otherwise-correct guards.
- **MEDIUM:** 8 itemized (`ADV-P54-MED-001/002/003`; `ADV-P55-MED-001/002/003/004`; `ADV-P56-MED-001`), with the dedupe/twin relationships noted above.
- **LOW:** 7 itemized (`ADV-P54-LOW-001`; `ADV-P55-LOW-001/002`; `ADV-P56-LOW-001/002/003/004`), including one severity divergence (`ADV-P54-INFO-001` vs. `ADV-P56-LOW-004` — same underlying gap assessed at two different severities by two different passes; both entries kept on record, not reconciled).
- **INFO:** 6 itemized (`ADV-P54-INFO-001`; `ADV-P55-INFO-001`; `ADV-P56-INFO-001/002/003/004`).
- **All 24 findings CLOSED on `910b8ab0` — a single class sweep, not 24/16 point fixes.** Root cause: `0e61a2dc` detected a YAML key via the file's own quote/whitespace-aware `extract_key_name_at_indent` matcher, then re-read that key's VALUE via a bare `strip_prefix`/`starts_with`, silently swallowing quoted/space-before-colon spellings — at three new call sites. Fixed by applying the file's own established reject-don't-parse idiom (`Err`/panic, never silent `None`/empty-string) at every new call site. `ADV-P55-HIGH-001`'s independent finding (depth-erasing `.trim()` match on `parse_needs_set`) closed via a new depth-anchored `PINNED_GATE_NEEDS_LINE` pin (M2-p). Every fix RED-proven; CI FINAL 15/15 PASS, mergeStateStatus CLEAN at `910b8ab0`. Full narrative: `cycles/cycle-001/burst-log.md` § "RESUME+WINDOW-54-55-56+CLASS-SWEEP".
- **New drift items opened:** `DEC-246-OVERCLAIMED-CONFIRMS` (MEDIUM), `SIBLING-WORKFLOW-FRONTIER-UNRETIRED` (MEDIUM), `EXTRACT-JOB-BLOCK-RAW-ANCHOR-WIDENED` (LOW), `DENOMINATOR-GUARD-USES-EXACT-LINE-MATCH` (LOW), `BURST-LOG-DEFEATS-PLAIN-GREP` (LOW), `ADVERSARY-PASSES-27-53-HAVE-NO-DETAIL-FILE` (LOW), plus three process-gap items each closed via an S-7.02 deferral this burst: `MEASUREMENT-METHOD-PRODUCES-FALSE-CLAIM` (MEDIUM), `RED-PROOF-NEEDS-SPELLING-VARIANTS` (HIGH), `RESEARCH-ARTIFACTS-NOT-PERSISTED` (MEDIUM). Full text: STATE.md Drift Items table.
- **New decisions:** **DEC-248** (frontiers approved), **DEC-249** (DEC-246 research reconstructed, found overclaimed), **DEC-250** (sibling-workflow + zero-leg-matrix guards landed directly), **DEC-251** (window findings closed as class sweep), **DEC-252** (PR #667 hold reaffirmed), **DEC-253** (next priority is S-CIGATE-3, not a tenth window).
- **Cycle-closing checklist (S-7.02) — SATISFIED.** All three process-gap drift items carry an explicit inline deferral (reason + target) in STATE.md's Drift Items table; none required a new STORY-INDEX entry this burst. No fix round left un-actioned this burst — unlike window 51/52/53, window 54/55/56's entire finding set was closed same-burst by the class sweep.

---

## Pre-Window Catch-Up: `1381af17` (previously unrecorded)

Before window 57/58/59 was dispatched, a prior working session landed `1381af17`
("test(ci): close pass-54/55/56 LOW residuals + Guard B docstring") closing three items
deliberately deferred at the close of window 54/55/56 — none of which had yet been marked
CLOSED in this index or in STATE.md's Drift Items table. Recorded here for the trail, not as a
new pass: `ADV-P56-INFO-004`'s underlying `extract_job_block` job-header search is now
line-anchored (a candidate match must start at byte 0 or immediately follow `\n`) and panics on
multiple line-anchored occurrences instead of silently taking the first — closing drift item
`EXTRACT-JOB-BLOCK-RAW-ANCHOR-WIDENED`; the `#[test]` count guard now matches lines whose
trimmed text STARTS WITH `#[test]` rather than lines equal to it, closing the same-line evasion
`#[test] fn foo() {}` — closing drift item `DENOMINATOR-GUARD-USES-EXACT-LINE-MATCH`; and Guard
B's docstring is corrected to state precisely that a static literal `os:` list cannot expand to
zero legs while `strategy.matrix.exclude:` is a second, independent, still-UNVERIFIED path to the
same question, with a new decidable source-level assertion that neither matrix job declares an
`exclude:` key today — this is treated as closing drift item `SIBLING-WORKFLOW-FRONTIER-UNRETIRED`
(the frontier itself is now backed by a source-level assertion rather than resting on
absence-of-demonstration alone; see DEC-256). All three CLOSED on `1381af17`. Window 57/58/59
below was dispatched against this head.

---

## Pass 57 Finding Catalog (Window 57/58/59, frontier C1-lexer: differential lexer conformance against the code added by `910b8ab0`/`1381af17` — dispatched against head `1381af17`)

Pass-57 ported this file's line-based extractors to Python and cross-checked them differentially
against PyYAML 6.0.3, Ruby Psych, and `actionlint`; verbatim Rust was also extracted into
standalone `rustc` binaries; the full 27-test suite was run against mutated copies; and a
systematic re-indent sweep was run across all 11 `ci.yml` jobs — executed, not merely reasoned
about from reading the Rust source.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P57-HIGH-001 | HIGH | positional-assumption-axis | `extract_key_name_at_indent`'s hardcoded 4-space job-child indent is assumed, never checked; two new `0e61a2dc`/`910b8ab0`-era consumers (`extract_job_display_name`/Guard A, `matrix_needs_members`/Guard B) treat "no key at the assumed indent" as a valid answer rather than unparseable input — a sibling workflow with a legal 6-space job body carrying `name: CI Gate` leaves the suite at 27 passed, 0 failed, bypassing Guard A entirely (the sole automated control for the DEC-246 duplicate-check-name vector) | CLOSED on `a17939e2` | Closed via new `assert_job_block_uses_4_space_child_indent`, wired into both Guard A and Guard B; RED-proven across 3/6/8-space indent variants, not just the one construction that found it |
| ADV-P57-MED-001 | MEDIUM | positional-assumption-axis | Guard B (`matrix_needs_members`) defeats detection identically to `ADV-P57-HIGH-001` on a non-4-space matrix-job body — independently found via the same differential-lexer method, a second instance of the same new axis | CLOSED on `a17939e2` | Twin of `ADV-P57-HIGH-001`, different call site; closed by the same `assert_job_block_uses_4_space_child_indent` wiring |
| ADV-P57-MED-002 | MEDIUM | vacuous-satisfaction | Guard B's matrix-job-count check was `!is_empty()`, not an exact arity pin — losing one of the two matrix jobs (e.g. to a re-indent or a typo'd job id) was invisible to a non-empty check | CLOSED on `a17939e2` | Widened to `PINNED_MATRIX_NEEDS_MEMBER_COUNT`, an exact-arity pin |
| ADV-P57-LOW-001 | LOW | key-detect-value-reparse-swallow | `extract_job_display_name` compared a job's `name:` value as literal text against the pinned `"CI Gate"` constant without rejecting YAML alias/anchor/tag forms (`*name`/`&name`/`!!str`) first — a node-property-prefixed value could defeat the literal-text comparison | CLOSED on `a17939e2` | Now rejects alias/anchor/tag forms outright instead of comparing their literal text |
| ADV-P57-LOW-002 | LOW | silent-continue-on-disagreement | `matrix_needs_members`'s `extract_job_block` miss silently excluded the job from the matrix-needs set instead of failing loudly, mirroring the class `ADV-P55-MED-003` closed at a different call site | CLOSED on `a17939e2` | Now panics, matching Guard A's established precedent |
| ADV-P57-INFO-001 | INFO | differential-lexer-negative-result | Full differential run (Python ports vs. PyYAML 6.0.3, Ruby Psych, `actionlint`) over the file's other ~25 pre-existing extractors found no further instance of the positional-assumption axis beyond the two sites above and the three sites `0e61a2dc` introduced (already closed on `910b8ab0`) | CLOSED on `a17939e2` | Recorded as this pass's own closing negative result, bounding the new axis's extent — mirrors `ADV-P56-INFO-004`'s role for the value-reparse axis |
| ADV-P57-INFO-002 | INFO | cosmetic | `extract_and_normalize_if_expr` and `extract_and_normalize_sole_needs_line` silently collapsed an unparseable value re-read to `""` → `Ok(None)` instead of `Err`, discovered via the same Python-port differential but distinct from the positional-assumption axis (this is the value-reparse axis, reopened at two more call sites `0e61a2dc`/`910b8ab0` did not reach) | CLOSED on `a17939e2` | DUPLICATE-CLASS of `ADV-P58-LOW-003`/`ADV-P59-LOW-001` — same underlying gap, independently found via three different frontiers/tools; all three closed together |
| ADV-P57-INFO-003 | INFO | falsifiability-census-negative-result | Systematic re-indent sweep of all 11 `ci.yml` jobs (3/6/8-space child indents, one job at a time) found the positional-assumption axis reachable only via Guard A/Guard B (the two sites above) — no third call site defeated by the sweep | CLOSED on `a17939e2` | Confirms the class sweep's scope claim independently of the Python/PyYAML differential |
| ADV-P57-INFO-004 | INFO | cosmetic | `docs/specs/cargo-mutants-policy.md` does not yet distinguish the positional-assumption axis from the value-reparse axis in its Scope section, understating that hand-rolled line-based extraction has (at least) two independently-defeatable failure shapes | CLOSED on `a17939e2` | Scope subsection extended |

## Pass 57 Isolation Note

**ELIGIBLE.** Head `1381af17`; no isolation breach; no read of `.factory/cycles/`.

## Pass 57 Summary

- **Verdict:** NOT CLEAN — 1 HIGH + 2 MEDIUM + 2 LOW + 4 INFO; ELIGIBLE; frontier C1-lexer
  (differential lexer conformance, executed via Python ports cross-checked against PyYAML 6.0.3 +
  Ruby Psych + `actionlint`, standalone `rustc` reproductions, and a systematic re-indent sweep —
  not reasoned about from source alone) found a NEW failure axis distinct from every prior
  window's value-reparse class: a hard-coded, never-validated indent assumption.
- **Frontier:** C1-lexer — differential lexer conformance: does every line-based extractor in this
  file agree with a real YAML parser on every reachable indent, not just every reachable spelling.
- **Convergence:** window 57/58/59 opens NOT CLEAN after one pass; one HIGH — a verified live
  bypass of Guard A, the DEC-246 duplicate-check-name control.

---

## Pass 58 Finding Catalog (Window 57/58/59, frontier C5-falsifiability: falsifiability census of the pins `0e61a2dc`/`910b8ab0`/`1381af17` added — dispatched against head `1381af17`)

Pass-58 built a scratch tree, applied one mutation at a time, rebuilt, and ran `cargo test` plus
`scripts/check-ci-gate.sh --self-test` per mutation — executed against a real rebuild each time,
not inferred from reading the pin definitions.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P58-MED-001 | MEDIUM | value-pinned-keys-open | `spec-guard`'s self-test step body was byte-pinned (`PINNED_CI_GATE_SELF_TEST_RUN_LINE`, `910b8ab0`) but the STEP's key set was not — a decoy step with the same `name:` inserted earlier in the job satisfied `find_sole_step_by_name`'s first-match lookup, reading the decoy's (mutated) body instead of the real one, a live per-mutation-rebuild reproduction, not a hypothetical | CLOSED on `a17939e2` | New `PINNED_CI_GATE_SELF_TEST_STEP_KEYS` + `find_sole_step_by_name` now rejects >1 matching step name outright |
| ADV-P58-MED-002 | MEDIUM | denominator-guard-incomplete | `EXPECTED_GUARD_TEST_COUNT`/`test_this_file_test_count_matches_expected_denominator` pins the `#[test]` attribute COUNT only — a per-mutation rebuild adding `#[ignore]` to an existing test, or gating one behind a non-`#[cfg(unix)]` conditional, left the count (and the suite) green while silently changing what actually runs in CI | CLOSED on `a17939e2` | Denominator guard extended to also assert zero `#[ignore]` attributes and that every `#[cfg(...)]` gating a `#[test]` is the one legitimate form (`#[cfg(unix)]`) |
| ADV-P58-LOW-001 | LOW | trust-boundary-gap | `resolve_trusted_jq()` (pre-`a17939e2`: no such function existed — this pass's own mutation was prepending a malicious `jq` shim onto `$GITHUB_PATH` ahead of the gate step) had no jq-provenance check at all; a per-mutation rebuild with a `$GITHUB_PATH`-prepended shim drove `check-ci-gate.sh` to a fabricated all-green record undetected | CLOSED on `a17939e2`, hardened on `f2bea32e` (CI-BREAK-1) | `a17939e2` introduced `resolve_trusted_jq()` pinned strictly to `/usr/bin/jq` under `GITHUB_ACTIONS=true` — correct for `ubuntu-latest`, but wrong for `macos-latest`'s real Homebrew `jq`, breaking CI for real (run 31406705091); `f2bea32e` replaced the single-path pin with a per-`RUNNER_OS` trusted-directory allowlist. See CI-BREAK-1 below — this finding's own fix is what broke, and then fixed, CI this burst |
| ADV-P58-LOW-002 | LOW | anchor-collision | `extract_job_block`'s anchor search was not bounded to at-or-after the top-level `jobs:` key — a per-mutation rebuild adding a top-level sibling key whose value textually collided with a job id (e.g. `on: {push: ...}` colliding with a job literally named `push`) produced a false-red, matching the wrong block | CLOSED on `a17939e2` | Anchor search now bounded to at-or-after `jobs:` |
| ADV-P58-LOW-003 | LOW | key-detect-value-reparse-swallow | `extract_and_normalize_if_expr`/`extract_and_normalize_sole_needs_line` collapse an unparseable value re-read to `""` → `Ok(None)` instead of `Err`, reproduced via a per-mutation `--self-test` rebuild rather than source reading | CLOSED on `a17939e2` | DUPLICATE-CLASS of `ADV-P57-INFO-002`/`ADV-P59-LOW-001`; all three closed together — now `Err` loudly, naming the likely quoted-key cause |
| ADV-P58-INFO-001 | INFO | falsifiability-census-negative-result | Per-mutation rebuild census of the remaining pins introduced by `910b8ab0` (M2-n/M2-o/M2-p and the workflow/env key-set pins) found no mutation that defeated them within this pass's mutation budget | CLOSED on `a17939e2` | Recorded as a negative result — these pins remain sound |
| ADV-P58-INFO-002 | INFO | cosmetic | `check-ci-gate.sh --self-test`'s summary line did not yet distinguish the fixture self-test (`EXPECTED_FIXTURES`) from the (not-yet-existing, pre-`f2bea32e`) jq-trust self-test in its printed denominator, a minor legibility gap surfaced while designing this pass's mutation harness | CLOSED on `f2bea32e` | `f2bea32e` adds a distinct `run_jq_trust_self_test` summary line with its own `EXPECTED_JQ_TRUST_CHECKS=13` denominator, separate from `EXPECTED_FIXTURES=13` |
| ADV-P58-INFO-003 | INFO | cosmetic | `docs/specs/cargo-mutants-policy.md` Scope section does not state that `scripts/check-ci-gate.sh`'s `GITHUB_ACTIONS=true`-gated strict branches are unreachable by any local `cargo mutants` run or local `--self-test` invocation without explicitly forcing the gate variable | CLOSED on `f2bea32e` | Scope subsection extended; ties directly to drift item `GUARD-MODE-UNREACHABLE-LOCALLY` |

## Pass 58 Isolation Note

**ELIGIBLE.** Head `1381af17`; no isolation breach; no read of `.factory/cycles/`.

## Pass 58 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 2 MEDIUM + 3 LOW + 3 INFO; ELIGIBLE; frontier C5-falsifiability
  (falsifiability census, executed via scratch-tree per-mutation rebuilds + `cargo test` +
  `--self-test`, not reasoned about from the pin definitions alone) found the trust-boundary gap
  (`ADV-P58-LOW-001`) that later became this burst's real CI break once `a17939e2`'s own fix for
  it shipped a wrong-for-`macos-latest` pin.
- **Frontier:** C5-falsifiability — falsifiability census: for every pin `0e61a2dc`/`910b8ab0` and
  its predecessors added, is there a concrete per-mutation-rebuild construction that defeats it.
- **Convergence:** window 57/58/59 still NOT CLEAN after two passes; zero HIGH this pass, but the
  window's cumulative HIGH count (from pass-57) still blocks CLEAN.

---

## Pass 59 Finding Catalog (Window 57/58/59, frontier C3-side-channels: inter-step side channels inside `ci-gate` — a frontier never probed in 56 prior passes — dispatched against head `1381af17`)

Pass-59 replayed this file's real pin extractors (not ports or reproductions) directly against
seven mutated copies of `ci.yml`, each mutation exercising a distinct inter-step side channel
(`$GITHUB_ENV`, `$GITHUB_PATH`, `$GITHUB_OUTPUT`, step-`outputs:`, `continue-on-error` at a
non-gate step, an upstream `uses:` step, and a workflow-level `env:` override reachable only from
an earlier job) — executed against the real extractor functions, not a description of them.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P59-LOW-001 | LOW | key-detect-value-reparse-swallow | M2-a/b/c/d and the `ALLOWED_SKIPS` conditional check matched job-level `if:` lines via a raw `starts_with` rather than `extract_key_name_at_indent` — M2-a's "no `if:` line" diagnostic misfired on a quoted `"if":` key, reproduced by replaying the real extractor against one of the seven mutated `ci.yml` copies | CLOSED on `a17939e2` | DUPLICATE-CLASS of `ADV-P57-INFO-002`/`ADV-P58-LOW-003`; all three closed together. M2-a/b/c/d and the `ALLOWED_SKIPS` check now route through `extract_key_name_at_indent`; M2-d's message now points at M2-l as the operative default-deny backstop |
| ADV-P59-INFO-001 | INFO | side-channel-census-negative-result | Of the seven inter-step side channels probed, six (`$GITHUB_ENV`, `$GITHUB_OUTPUT`, step-`outputs:`, `continue-on-error` at a non-gate step, the upstream `uses:` steps, and the workflow-level `env:` override) are already closed by round-11/12/13 guards (`PINNED_GATE_JOB_KEYS`/`PINNED_GATE_STEP_KEY_SETS`, the `outputs:`-declaration guard, `continue-on-error` rejection, and the workflow/gate-env key-set pins) — none reopened by this pass's replay | CLOSED (pre-existing guards; no new fix required) | Recorded as this pass's own closing negative result — bounds the side-channel surface actually probed |
| ADV-P59-INFO-002 | INFO | side-channel-census-finding | The seventh channel, `$GITHUB_PATH`, is the one this window's `ADV-P58-LOW-001` (jq trust-boundary gap) already independently surfaced — pass-59 confirms it via the inter-step-side-channel frontier rather than the falsifiability-census frontier, a second independent route to the same underlying gap | CLOSED on `a17939e2`/`f2bea32e` | DUPLICATE of `ADV-P58-LOW-001` — same instance, independently found via a different frontier; both entries kept on record per this project's dedupe/twin convention, not reconciled into one |
| ADV-P59-INFO-003 | INFO | cosmetic | `CLAUDE.md`'s S-CIGATE-2 narrative did not yet name inter-step side channels as a class of bypass distinct from the value-reparse and positional-assumption axes this burst found | CLOSED on `f2bea32e`-era CLAUDE.md update | CLAUDE.md gotcha entry extended (see this burst's CLAUDE.md diff) |
| ADV-P59-INFO-004 | INFO | falsifiability-census-negative-result | The seven mutated `ci.yml` copies were also replayed against `PINNED_GATE_IF_EXPR`, `PINNED_GATE_ENV_KEYS`, and `PINNED_WORKFLOW_ENV_KEYS` (round-11/12 pins) directly, not just described — all three held under every mutation tried | CLOSED (pre-existing guards; no new fix required) | Independent re-confirmation of round-11/12 pins via a fifth distinct tool/method (following Python ports, standalone `rustc`, scratch-tree rebuilds, and now real-extractor replay) |
| ADV-P59-INFO-005 | INFO | falsifiability-census-negative-result | Census closing note: across all three passes of window 57/58/59 (Python/PyYAML/Psych/actionlint differential, scratch-tree per-mutation rebuilds, and real-extractor replay against mutated `ci.yml` copies), no defeat of any pin was found that is NOT an instance of one of the two named axes (positional-assumption, value-reparse) or the one pre-existing trust-boundary gap (jq) — bounding this window's finding set as complete relative to the three frontiers actually run, not proof no further axis exists | CLOSED (recorded as this window's own closing census) | What makes the window's 23 findings credible as a bounded set rather than a partial one, mirroring `ADV-P56-INFO-004`'s role for window 54/55/56 |

## Pass 59 Isolation Note

**ELIGIBLE.** Head `1381af17`; no isolation breach; no read of `.factory/cycles/`.

## Pass 59 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 0 MEDIUM + 1 LOW + 5 INFO; ELIGIBLE; frontier C3-side-channels
  (inter-step side channels inside `ci-gate`, never probed in 56 prior passes, executed via real
  pin extractors replayed against seven mutated `ci.yml` copies) closes window 57/58/59 with a
  bounding census rather than a large new finding set — six of seven probed channels were already
  closed by pre-existing guards; the seventh independently confirms `ADV-P58-LOW-001`.
- **Frontier:** C3-side-channels — inter-step side channels: can one step in the `ci-gate` job (or
  an earlier job) influence a later step's outcome or the gate's own record through a channel
  other than the `needs:`/`if:`/`run:` surface every prior window inspected directly.
- **Convergence:** window 57/58/59 CLOSED 0/3 — all three passes NOT CLEAN.

---

## Window 57/58/59 Summary

- **Result:** CLOSED 0/3 — pass-57 NOT CLEAN (1H+2M+2L+4I), pass-58 NOT CLEAN (0H+2M+3L+3I),
  pass-59 NOT CLEAN (0H+0M+1L+5I), against head `1381af17`. Three deliberately-varied inspection
  frontiers, human-approved before dispatch per DEC-254: (57) C1-lexer — differential lexer
  conformance against the code added by `910b8ab0`/`1381af17`; (58) C5-falsifiability — census of
  the new pins; (59) C3-side-channels — inter-step side channels inside `ci-gate`, a frontier
  never probed in 56 prior passes. All three ELIGIBLE — no isolation breaches reported; no pass
  read `.factory/cycles/`. **Tenth consecutive window without 3/3 since window 30/31/32.**
- **Finding count:** 23 new findings total across the three passes: pass-57 = 1H+2M+2L+4I (9);
  pass-58 = 0H+2M+3L+3I (8); pass-59 = 0H+0M+1L+5I (6); 9+8+6 = 23. Deduplicates to roughly 20
  distinct underlying findings — one explicit dedupe/twin group on record spanning all three
  passes (`ADV-P57-INFO-002` ≡ `ADV-P58-LOW-003` ≡ `ADV-P59-LOW-001`, the value-reparse axis
  reopened at the M2-a/b/c/d and `extract_and_normalize_if_expr`/`sole_needs_line` call sites) and
  one two-pass twin (`ADV-P58-LOW-001` ≡ `ADV-P59-INFO-002`, the jq trust-boundary gap,
  independently found via the falsifiability-census and side-channel frontiers). **Zero
  rediscoveries of any finding from passes 1-56.**
- **HIGH:** 1 — `ADV-P57-HIGH-001`, a NEW failure axis distinct from every prior window's
  value-reparse class: `extract_key_name_at_indent`'s hard-coded 4-space job-child indent is
  assumed, never checked, and a legal 6-space job body bypasses Guard A (the sole automated
  control for the DEC-246 duplicate-check-name vector) with the full suite green.
- **MEDIUM:** 4 itemized (`ADV-P57-MED-001/002`; `ADV-P58-MED-001/002`).
- **LOW:** 6 itemized (`ADV-P57-LOW-001/002`; `ADV-P58-LOW-001/002/003`; `ADV-P59-LOW-001`),
  including the two dedupe/twin groups noted above.
- **INFO:** 12 itemized (`ADV-P57-INFO-001/002/003/004`; `ADV-P58-INFO-001/002/003`;
  `ADV-P59-INFO-001/002/003/004/005`).
- **All 23 findings CLOSED — 12 scoped items fixed as a single class sweep (`a17939e2`), not 23
  point fixes.** Root cause: TWO independent new axes, both distinct from window 54/55/56's
  value-reparse-only diagnosis — (1) a positional-assumption axis (`extract_key_name_at_indent`'s
  hard-coded indent, never validated) and (2) a trust-boundary gap (no jq provenance check),
  discovered by frontiers this project had never run before (C1-lexer, C3-side-channels). Every
  fix RED-proven across BOTH the spelling axis (`"key":`/`'key':`/`key :`) AND the indent axis
  (3/6/8-space job bodies) — closing the gap `RED-PROOF-NEEDS-SPELLING-VARIANTS` (window
  54/55/56's own root-cause finding) had left open. **Deliberately NOT fixed:** `a17939e2` refused
  to change `ci.yml`'s POL-11 canary to an exact-count equality (`EXPECTED_GUARD_TEST_COUNT == 27`
  as a literal in the workflow itself) — the `test` job runs a 2-OS matrix and 4 of the file's 27
  tests are `#[cfg(unix)]`-gated, so a literal `27` in the YAML would red every Windows leg on an
  otherwise-green tree; a Rust-side-only fix (the denominator guard extension, `ADV-P58-MED-002`)
  was judged correct instead (see DEC-255). Full narrative:
  `cycles/cycle-001/burst-log.md` § "WINDOW-57-58-59+SWEEP-2+CI-BREAK".
- **CI-BREAK-1 (real, not synthesized).** `a17939e2`'s own fix for `ADV-P58-LOW-001` (jq
  trust-boundary gap) shipped `resolve_trusted_jq()` pinned strictly to `/usr/bin/jq` under
  `GITHUB_ACTIONS=true` — correct for `ubuntu-latest`, wrong for `macos-latest`'s real Homebrew jq
  (`/opt/homebrew/bin/jq` or `/usr/local/bin/jq`). Live CI run 31406705091 on `a17939e2`:
  `Test (macos-latest)` genuinely FAILED (two `#[cfg(unix)]` subprocess tests panicked, `Exit
  code: Some(2) (expected Some(1))`); `Test (ubuntu-latest)` and `Test (windows-latest)` were
  CANCELLED by matrix fail-fast, not independently failing (drift item
  `MATRIX-FAIL-FAST-MASKS-SCOPE`); `CI Gate` correctly FAILED downstream of the real upstream
  failure — the first end-to-end evidence this cycle of the gate behaving correctly on a genuine
  failure rather than a synthesized payload. Fixed by `f2bea32e`: a per-`RUNNER_OS` trusted
  directory allowlist (`trusted_jq_dirs_for`/`is_trusted_jq_dir`), fail-closed when `RUNNER_OS` is
  unset under `GITHUB_ACTIONS=true`, plus a new `run_jq_trust_self_test` (13 checks, own
  denominator pin `EXPECTED_JQ_TRUST_CHECKS=13`) closing the "guard branch unreachable from a
  local test run" gap that let the wrong pin ship unnoticed in the first place (drift item
  `GUARD-MODE-UNREACHABLE-LOCALLY`). Re-verified locally this burst (not merely re-read from the
  commit message): `scripts/check-ci-gate.sh --self-test` → `13/13 jq-trust checks run, 0
  mismatch(es)` plus the pre-existing `EXPECTED_FIXTURES=13` fixture self-test, both PASS; `gh pr
  view 667` confirms `headRefOid f2bea32e…`, `mergeStateStatus CLEAN`, `mergeable MERGEABLE`. See
  DEC-257 (break) and the CI-BREAK-1 fix-round entry in `S-626-1.md`.
- **New drift items opened:** `GUARD-MODE-UNREACHABLE-LOCALLY` (HIGH, new class — an
  environment-gated guard branch has, by construction, no local test coverage until a test forces
  the gate variable; closed for this instance by `f2bea32e`'s `run_jq_trust_self_test`, the
  general rule is the drift item), `POSITIONAL-ASSUMPTION-AXIS` (HIGH — second distinct axis of
  the line-based-extraction defect class, now evidence-backed argument for S-CIGATE-3),
  `MATRIX-FAIL-FAST-MASKS-SCOPE` (LOW — a reader of the check list would conclude three platforms
  broke when only one genuinely did). Two existing drift items UPDATED rather than duplicated:
  `MEASUREMENT-METHOD-PRODUCES-FALSE-CLAIM` (second instance — an in-flight jq fix was
  mischaracterized as "worse than the break" by running `GITHUB_ACTIONS=true` without `RUNNER_OS`,
  mistaking correct fail-closed behavior for breakage, hours after the first instance's corrective
  was logged) and `RED-PROOF-NEEDS-SPELLING-VARIANTS` (now confirmed TWO-AXIS — spelling AND
  indent variants both required, per `ADV-P57-HIGH-001`). Three prior drift items CLOSED this
  burst (via the pre-window `1381af17` catch-up, above): `EXTRACT-JOB-BLOCK-RAW-ANCHOR-WIDENED`,
  `DENOMINATOR-GUARD-USES-EXACT-LINE-MATCH`, `SIBLING-WORKFLOW-FRONTIER-UNRETIRED`. Full text:
  STATE.md Drift Items table.
- **New decisions:** **DEC-254** (frontiers C1-lexer/C5-falsifiability/C3-side-channels approved),
  **DEC-255** (window findings closed as class sweep `a17939e2`, extends DEC-243/244; POL-11
  exact-count change refused with documented reason), **DEC-256** (sibling-workflow exposure +
  Q4/Q8 treated as handled via guards, not re-spent as frontiers, extends DEC-250), **DEC-257**
  (CI-BREAK-1 recorded — real `Test (macos-latest)` failure on `a17939e2`, fixed by `f2bea32e`),
  **DEC-258** (PR #667 hold STANDS, DEC-202 reaffirmed, after `ADV-P57-HIGH-001`'s verified Guard A
  bypass), **DEC-259** (next priority remains S-CIGATE-3, not an eleventh window).
- **Cycle-closing checklist (S-7.02) — SATISFIED.** All four process-gap drift items from this
  burst (`GUARD-MODE-UNREACHABLE-LOCALLY`, `POSITIONAL-ASSUMPTION-AXIS`,
  `MEASUREMENT-METHOD-PRODUCES-FALSE-CLAIM` 2nd instance, `RED-PROOF-NEEDS-SPELLING-VARIANTS`
  two-axis) carry an explicit inline deferral (reason + target — three route to S-CIGATE-3, one is
  closed-for-this-instance with the general rule retained as a standing checklist item) in
  STATE.md's Drift Items table; none required a new STORY-INDEX entry this burst. Three lessons
  codified to `cycles/cycle-001/lessons.md`, tagged `[codified]`.

---

## Pass 60 / Pass 61 Finding Catalog (TARGETED DELTA REVIEWS, not a STRICT Step-4.5 window —
dispatched to answer whether PR #667 was fully reviewed, not whether CI was green; scope
`1381af17..5ca51bc2`, the 1,024 insertions no prior pass had seen)

Pass-60 reviewed the Rust delta (684 lines: `tests/ci_gate_completeness.rs` changes across
`a17939e2`/`f2bea32e`/`5ca51bc2`). Pass-61 reviewed the shell delta (422 lines:
`scripts/check-ci-gate.sh` changes across the same range). Both executed end-to-end reproductions
against the actual scripts/tests, not source reading alone — matching this file's established
verification discipline (per-mutation rebuilds, scratch-tree execution, real-extractor replay).

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P60-HIGH-001 | HIGH | doc-claims-guard-that-does-not-exist | `a17939e2`'s own commit message and STATE.md narrative documented `#[ignore]`/`#[cfg]` enforcement added to `test_ci_gate_pass_fail_semantics_are_structurally_placed` (carrying pins M2-a..p) — the test body was found to have exactly ONE assertion, not the documented set; `#[ignore]`-ing the test left the suite at `26 passed; 1 ignored`, clippy clean, `EXPECTED_GUARD_TEST_COUNT` denominator intact, POL-11 canary satisfied — a guard the file claimed existed did not | CLOSED on `f656f873` | Reproduced directly: prior verification (this project's own orchestrator, at burst-close time) checked the METRIC the mechanism reports on (`#[test]` count = 27, denominator = 27) rather than whether the asserted mechanism itself existed — a doc-only change passes that check identically. Drift item `DOC-CLAIMS-A-GUARD-THAT-DOES-NOT-EXIST` opened (see STATE.md Drift Items) |
| ADV-P60-HIGH-002 | HIGH | fix-instruction-caused-regression | The `- `-marker strip added at the orchestrator's own request (`ADV-P57-INFO-004`, framed as a small consistency fix) regressed `extract_job_display_name` from a fail-closed panic to a fail-open silent miss; reproduced with a sibling workflow using ordinary 4-space `steps:` indentation and `name: CI Gate` — full suite `27 passed, 0 failed`, Guard A blind to the exact name-collision it exists to catch. Legal per PyYAML, Ruby Psych, AND `actionlint` (not a hypothetical construction) | CLOSED on `f656f873` | The requested change was framed as cosmetic; it silently flipped the extractor's failure direction. Drift item `ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION` opened (see STATE.md Drift Items) |
| ADV-P60-LOW-001 | LOW | line-based-extraction-defect | `common::yaml::extract_job_block`'s `jobs:` mapping bound is START-only (`yaml.find("\njobs:\n")`) — no END bound, so a job id colliding with an unrelated same-named 2-space key declared AFTER `jobs:` (e.g. a `push` job vs. `on.push`) still double-anchors; separately, a file where `jobs:` is the literal first line (byte offset 0, no preceding `\n` to match) goes undetected entirely and silently falls through to `unwrap_or(0)` — no bound in either direction. The function's own panic text overclaimed "excluded by construction" | CLOSED on `f656f873` | Verified directly against `tests/common/yaml.rs::extract_job_block`; both gaps (missing end bound, byte-0 `jobs:`) fixed same commit as ADV-P60-LOW-002/003 |
| ADV-P60-LOW-002 | LOW | doc-attribution-error | Guard B's ~130-line rationale docstring sat BETWEEN `PINNED_MATRIX_NEEDS_MEMBER_COUNT`'s declaration and the `#[test] fn` it actually explains — rustdoc attached the whole docstring to the constant, not the test, leaving the test itself undocumented; a later pass-60-adjacent change to the block above repeated the same misattribution rather than correcting it | CLOSED on `f656f873` | Verified in `tests/ci_gate_completeness.rs` near `PINNED_MATRIX_NEEDS_MEMBER_COUNT`; docstring moved to attach to the constant, Guard B's own rationale now documents the test |
| ADV-P60-LOW-003 | LOW | misleading-error-message | `find_sole_step_by_name`'s doc comment and both `Err` messages claimed the match was against "the literal line `      - name: {step_name}`, 6-space step-marker indent" — overstated; the code has always been indent-agnostic (`l.trim_start() == name_needle`). Not a false green (actual behavior is STRICTER than the wording implied — matches at ANY indent), but the old wording would send a debugger chasing a nonexistent indent requirement | CLOSED on `f656f873` | Verified in `tests/ci_gate_completeness.rs::find_sole_step_by_name`; doc comment and both `Err` texts corrected to state the actual `trim_start()`-based behavior |
| ADV-P60-INFO-001 | INFO | census · incidental-coverage | `assert_job_block_uses_4_space_child_indent`'s sweep over all `ci-gate.needs` members is INCIDENTAL — a side effect of Guard B's own loop, not a designed assertion; narrowing that loop later would silently delete the coverage with no test failing | OPEN (informational) | No fix action required; recorded as a standing review-checklist caution |
| ADV-P60-INFO-002 | INFO | census · deliberate-tradeoff | The same assert false-REDs on any sibling-workflow job with 3/6/8-space children even when that job declares no `CI Gate` name — deliberate reject-don't-parse behavior, cost recorded rather than fixed | OPEN (informational) | No fix action required; documented tradeoff, not a defect |
| ADV-P60-INFO-003 | INFO | census · process-note | Worktree hygiene: a concurrent agent's uncommitted changes were present in the working tree during this review (expected, given parallel dispatch); the two in-scope files (`tests/ci_gate_completeness.rs`, `tests/common/yaml.rs`) were independently verified byte-identical to `5ca51bc2` throughout the review | OPEN (informational) | No fix action required; isolation confirmed clean |
| ADV-P61-HIGH-001 | HIGH | trust-path-not-closable-by-directory-check | `resolve_trusted_jq()` (the CI-BREAK-1 fix, `f2bea32e`) validated jq's directory by resolving it via `dirname` — `dirname` is itself a PATH-resolved binary, so a second shim ahead of it on `$PATH` defeats the whole check. Reproduced: on a payload where `fmt`/`clippy`/`test` all genuinely FAILED, the compromised trust check still reported `OK fmt/clippy/test = success`, exit 0. Originally rated MEDIUM-001 by the reviewer; **the orchestrator independently re-rated it to HIGH** after reproducing the false-green with the guard engaged, meeting DEC-245's HIGH definition — the reviewer had explicitly flagged the call as one it would not make unilaterally | CLOSED on `736fea28`+`23ace476` | Fixed via pure-bash `dirname` (no external binary in the trust-check path) plus pinning every other PATH-shimmable binary reachable on the decision path. `resolve_trusted_jq`'s own comment cites this ID verbatim (`scripts/check-ci-gate.sh` ~line 449) |
| ADV-P61-MEDIUM-002 | MEDIUM | environment-gate-attacker-writable | The guard's strict-mode enable condition (`GITHUB_ACTIONS = "true"`) is environment-controlled and, per follow-up research, very likely attacker-writable from an earlier step in the same job via `$GITHUB_ENV` (no `GITHUB_*`/`RUNNER_*` prefix filter on `actions/runner`'s write blocklist) — unset / `false` / `TRUE` (or a forged `true`) each skip or force the strict branch | CLOSED on `736fea28`+`23ace476` | Re-keyed on `RUNNER_OS` alone, which is CONFIRMED regenerated by the runner's own context machinery every step (no override path found) — verified in `resolve_trusted_jq`'s "WHY RUNNER_OS, NOT GITHUB_ACTIONS" comment block, `scripts/check-ci-gate.sh` ~line 318 |
| ADV-P61-LOW-003 | LOW | doc-claims-a-check-that-does-not-exist | `resolve_trusted_jq`'s comment claimed "only an absolute, existing path is required" outside strict mode — no such check existed; a relative path like `./jq` from cwd was accepted and executed unconditionally | CLOSED on `736fea28`+`23ace476` | Verified in `scripts/check-ci-gate.sh::resolve_trusted_jq` (~line 338, ~line 410): the absolute+executable check now applies in EVERY mode, making the comment's claim true instead of weakening it to match the gap; regression-pinned by check 15 (`reject-relative-path-jq-regardless-of-mode`) in `run_jq_trust_self_test` |
| ADV-P61-LOW-004 | LOW | self-test-hard-fails-on-legitimate-host | Check 13 (`accept-real-host-jq-in-trusted-dir`) of `run_jq_trust_self_test` calls `resolve_trusted_jq()` against WHATEVER jq is genuinely first on the running host's own `PATH`, under `GITHUB_ACTIONS=true`/`RUNNER_OS=<host OS>`, and unconditionally asserts the outcome is `pass`. The trusted-directory allowlist (`/usr/bin`, `/bin`, `/usr/local/bin`, `/opt/homebrew/bin`) does not cover a nix profile, mise/asdf shim, `~/.local/bin`, or Linux Homebrew (`/home/linuxbrew/.linuxbrew/bin`) jq install — `--self-test` hard-FAILs on any of those hosts even though the tree itself is correct, reading as a security failure rather than an environment mismatch | **OPEN — verified UNFIXED against the committed code at this HEAD (4ee308fb)** | Verified two ways: (1) direct read of `run_jq_trust_self_test`'s check-13 block (`scripts/check-ci-gate.sh` ~line 945-980) — no allowlist-membership pre-check or skip branch exists before the unconditional `record_resolve_check "accept-real-host-jq-in-trusted-dir" ... "pass"` call; (2) empirical reproduction: symlinked this machine's real `jq` into a throwaway untrusted directory, prepended it to `PATH`, and re-ran `bash scripts/check-ci-gate.sh --self-test` — real process exit code `1`, output `[FAIL] accept-real-host-jq-in-trusted-dir ... (expected=pass, actual=fail:2)` and `17/17 jq-trust checks run, 1 mismatch(es)`. This finding was explicitly flagged by the dispatching team-lead as optional/unconfirmed disposition; this recording pass resolves that flag to OPEN based on direct code verification, not team-lead say-so |
| ADV-P61-INFO-005 | INFO | pre-existing-fixed-anyway | `main()`'s stdin read used `json="$(cat)"` — `cat` is itself an untrusted PATH binary; a `cat` shim alone (producing a fabricated payload) drove the decision, independent of the jq-trust checks entirely. Pre-existing / outside the `1381af17..5ca51bc2` delta proper, but fixed anyway in the same burst | CLOSED on `736fea28` | Verified: `json="$(</dev/stdin)"` replaces the `cat` invocation; regression-pinned by check 17 (`reject-cat-shim-for-main-stdin-read`) in `run_jq_trust_self_test`, `scripts/check-ci-gate.sh` ~line 689 |
| ADV-P61-INFO-006 | INFO | shell-scoping-defect | `readonly EXPECTED_JQ_TRUST_CHECKS` (and `EXPECTED_FIXTURES`) were declared from INSIDE `run_self_test()`/`run_jq_trust_self_test()` without `local` — a bare `readonly NAME=val` inside a bash function still creates a GLOBAL readonly variable; a second invocation of either function in the same shell would abort on the second `readonly` assignment under `set -e` | CLOSED on `23ace476` | Verified: both constants moved to file scope (`scripts/check-ci-gate.sh` ~line 88-104), assigned exactly once when the file is parsed regardless of call count |

**Reconciliation note — CORRECTED (2026-08-10, post-close arithmetic fix; supersedes the
"+10 (442→452)" note this section previously carried):** the two passes produced **14** raw
finding observations, not 10. P60 = 2H + 0M + 3L + 3I = 8. P61 = 0H + 2M + 2L + 2I = 6 at
dispatch (the orchestrator's independent re-rating of `ADV-P61-HIGH-001` from MEDIUM to HIGH
after reproduction changes its SEVERITY, not the finding COUNT — P61 is still 6 distinct
findings post-rerate: 1H + 1M + 2L + 2I). 8 + 6 = **14**. The prior recorded delta of +10
(442→452) undercounted by 4 — specifically, it silently dropped `ADV-P61-LOW-003` and
`ADV-P61-LOW-004` entirely (0 LOW ever recorded for P61 in the original table, though 2 existed)
and folded the reconciliation's own arithmetic into a total that didn't sum to its own stated
parts (see STATE.md Drift Items, `MEASUREMENT-METHOD-PRODUCES-FALSE-CLAIM`, third instance).
`total_findings` is corrected from **442+10=452 (wrong)** to **442+14=456 (correct)**, and
`severity_distribution` from `{0,35,130,155,132}` to the arithmetically-verified
`{CRIT:0, HIGH:35, MED:131, LOW:157, INFO:133}` (0+35+131+157+133 = 456). Of the 14, **9 are
actionable (non-INFO)**: P60 contributes 5 (2H+3L), P61 contributes 4 (1H+1M+2L). **8 of the 9
actionable findings are CLOSED**; `ADV-P61-LOW-004` is the sole exception — see its row above,
verified OPEN against the committed code at this HEAD, not merely left as a placeholder. All ID
assignments in the catalog above (including the non-sequential-per-severity `ADV-P61-LOW-003`/
`-LOW-004`/`-INFO-005`/`-INFO-006` numbering) were cross-checked against `scripts/check-ci-gate.sh`'s
own in-code citations of these IDs (e.g. its "S-626-1 ADV-P61-LOW-003" and "S-626-1
ADV-P61-INFO-006" comments) rather than invented by this recording pass — the code is the
authoritative source for which IDs are real.

## Pass 60 / Pass 61 Isolation Note

**ELIGIBLE.** Reviewed committed range `1381af17..5ca51bc2` on the PR #667 branch, pre-merge; no
isolation breach reported; no read of `.factory/cycles/`.

## Pass 60 / Pass 61 Summary

- **Verdict:** BOTH NOT CLEAN. Pass-60 (Rust delta): 2 HIGH + 0 MEDIUM + 3 LOW + 3 INFO = 8. Pass-61
  (shell delta): 0 HIGH + 2 MEDIUM + 2 LOW + 2 INFO = 6 at dispatch, re-rated by the orchestrator to
  1 HIGH + 1 MEDIUM + 2 LOW + 2 INFO after independent end-to-end reproduction of the false green
  (still 6 findings — the re-rating changes one finding's severity label, not the count). 8 + 6 =
  **14 total**, corrected from the originally-recorded 10 (see Reconciliation note above).
- **Not a Step 4.5 window pass.** These were targeted delta reviews of the specific commit range
  no prior pass had seen (`1381af17..5ca51bc2`), dispatched off-cycle because the human asked
  whether #667 was *fully reviewed* — not whether CI was green. Not counted toward Step 4.5's 3/3
  arithmetic; Step 4.5 remains permanently 0/3 at merge time (DEC-262).
- **Three HIGHs, all verified end-to-end** (not reasoned about from source alone) against code CI
  had called green four times — see catalog above. All three fixed pre-merge, all CI-green:
  `736fea28`+`23ace476` (shell) and `f656f873` (Rust).
- **8 of 9 actionable findings (5 from P60 + 4 from P61) CLOSED.** `ADV-P61-LOW-004` (check 13 of
  `run_jq_trust_self_test` hard-fails `--self-test` on any host whose ambient jq sits outside the
  hardcoded `/usr/bin`, `/bin`, `/usr/local/bin`, `/opt/homebrew/bin` allowlist — nix, mise/asdf,
  `~/.local/bin`, Linux Homebrew) is confirmed **OPEN** against the committed code at this HEAD
  (`4ee308fb`), verified both by direct code reading and by empirical reproduction (a real
  `--self-test` invocation with a shimmed untrusted-directory jq exits 1). 5 INFO findings recorded,
  all itemized in the catalog above with real content (not placeholders) — see Reconciliation note.
- **Process-gap findings routed to STATE.md Drift Items, not this index's severity ledger:**
  `ADV-P60-HIGH-001` and `ADV-P60-HIGH-002` are BOTH process-gap findings about the factory's own
  prior verification/instruction discipline (a doc-only change passing a metric-based check; a
  requested "consistency fix" flipping an extractor's failure direction) as much as they are code
  defects — see STATE.md drift items `DOC-CLAIMS-A-GUARD-THAT-DOES-NOT-EXIST` and
  `ORCHESTRATOR-FIX-INSTRUCTION-CAUSED-REGRESSION`, each S-7.02-dispositioned.
- **PR #667 MERGED same-burst**, squash commit `a5e1d087` on `develop`, closes #626. `develop` CI
  on `a5e1d087` (run 31432422878): SUCCESS, 12 success + 2 skipped (`Mutation testing` +
  `Secret Scan`, both `pull_request`-only) — `CI Gate` correctly reported success with `mutants`
  skipped, the first production confirmation of the `ALLOWED_SKIPS` mechanism (S-CIGATE-2).
- **New decision:** **DEC-262** (merge authorized on code grounds with Step 4.5 at 0/3 after ten
  windows and 61 total adversary passes; convergence bar never met, merge accepted that).
- **Full narrative:** `cycles/cycle-001/burst-log.md` § "S-626-1-MERGE+ADV-P60-P61+BURST-CLOSE".

---

## Pass ADV-P675 — PR #675 Claim-Accuracy Review (TARGETED, not a Step-4.5 window;
PR #675 is docs-only — `CLAUDE.md` + `scripts/check-ci-gate.sh` comment/prose corrections,
zero non-comment lines changed, `a5e1d087..d55bedf7`)

Dispatched before merge on the reasoning that in this repository a doc comment IS the operative
control for several recorded residuals (e.g. `resolve_trusted_jq`'s `HONEST SCOPE` comment, the
round-13 `uses:`-pinning scope note) — so a false comment is a real defect, not cosmetic drift.
PR #675 itself was a correction of the S-626-1/DEC-263 trust-layer record to match the shipped
code from the SHELL-TRUST-ASSUMPTIONS research pass.

| ID | Severity | Classification | Title | Status | Notes |
|----|----------|----------------|-------|--------|-------|
| ADV-P675-MEDIUM-001 | MEDIUM | claim-accuracy · false-premise-through-citation-chain | Comment claimed Ubuntu 24.04 is "the first LTS with usrmerge," CONFIRM-labelled against Canonical/Debian docs — false: Ubuntu shipped merged-`/usr` for new installs since 18.10 Cosmic, so 20.04/22.04 LTS were already usrmerged; the cited Rockcraft page does say it, but scoped to Ubuntu as a base system inside rocks/container images, not installations generally | CLOSED on `d2430a8a` | The operative conclusion (one physical directory, no canonicalization) was true and unaffected; the false premise misled toward MORE apparent risk, not less. The error propagated through a citation chain — Rockcraft's scoped claim → the research artifact quoted it correctly but dropped the scope → this PR generalized it further and added a CONFIRM label. Amended by explicit retraction (not silent deletion), so the error cannot be re-derived from the same source; CONFIRM re-anchored to the merged-`/usr`-since-18.10 property. Drift item `SCOPED-SOURCE-GENERALIZED-THROUGH-CITATION-CHAIN` opened (see STATE.md Drift Items) |
| ADV-P675-MEDIUM-002 | MEDIUM | claim-accuracy · unlabelled-inconclusive-claim | PR asserted as settled fact that `/usr/bin`/`/bin` "require root," unlike the paths above — this is Q1b, INCONCLUSIVE-on-primary-sources / INFERRED per `research/ci-gate-shell-trust-assumptions-2026-08-10.md`, and is the single open question bearing on the decision path | CLOSED on `d2430a8a` | Two aggravating factors: unrequested drift (the dispatch asked only for the `/opt/homebrew/bin` sentence) and internal inconsistency (~70 lines later the same PR correctly labelled lower-stakes claims INFERRED). Amended by labelling only. Drift item `CORRECTION-PR-INTRODUCED-NEW-FALSE-CLAIMS` opened (see STATE.md Drift Items) |
| ADV-P675-LOW-001 | LOW | citation-fidelity | C# snippet quoting `ScriptHandler.cs` elided the line that BINDS `runtimeContext`, presented as a full quotation — as printed, the inner loop referenced an undeclared identifier, directly under the word "UNCONDITIONALLY" | CLOSED on `d2430a8a` | Amended by restoring the binding line |
| ADV-P675-LOW-002 | LOW | stale-claim-not-updated | Two untouched comment blocks still claimed strict mode engages on `GITHUB_ACTIONS=true`, contradicting the DEC-263 re-key to `RUNNER_OS` | CLOSED on `d2430a8a` | Pre-existing, not a regression introduced by this PR, but left the file worse than uniformly-stale after the re-key landed elsewhere in the same file |

**Reconciliation note (5th finding, INFO):** the dispatch's own severity tally is 0H/2M/2L/1I = 5,
and `total_findings` is incremented by 5 accordingly (461, up from 456) — but the dispatch brief
that produced this recording pass itemized only the four actionable findings above; the INFO
finding's title and detail were not supplied. Per this project's standing rule against estimating
what should be derived (`MEASUREMENT-METHOD-PRODUCES-FALSE-CLAIM`, three prior instances), this
entry records the tally contribution honestly rather than inventing plausible-sounding INFO
content — `ADV-P675-INFO-001` is reserved but not itemized pending its source detail.

## Pass ADV-P675 Isolation Note

**ELIGIBLE.** Reviewed PR #675's committed diff (`a5e1d087..d55bedf7`) pre-merge; no isolation
breach reported.

## Pass ADV-P675 Verified-Clean (no finding)

Confirmed correct, no defect: comment detachment (the `ADV-P60-LOW-002` failure mode, checked
against the assembled file, not the diff); the `CLAUDE.md` sudo sentence (verbatim quote, correct
placement, correctly refuses the overclaim); the macOS compatibility-not-security framing and its
scope claim (independently re-verified against `ci.yml`: `ci-gate` and `spec-guard` both
`ubuntu-latest`); the "second, independent channel" wording; the `ScriptHandler.cs`
write-ordering citation (confirmed across four primary-source fetches); the "don't cite the docs'
non-overwrite sentence" note.

## Pass ADV-P675 Summary

- **Verdict:** NOT CLEAN — 0 HIGH + 2 MEDIUM + 2 LOW + 1 INFO = 5. Recommendation: merge with
  amendments.
- **Not a Step 4.5 window pass; not counted toward Step 4.5's 3/3 arithmetic** — a targeted
  claim-accuracy review of a documentation-only PR, dispatched because a doc comment is the
  operative control for several recorded residuals in this repository.
- **All 4 actionable findings CLOSED**, amended in `d2430a8a` before merge, independently
  re-verified in the committed text. 1 INFO finding counted in the tally but not itemized in the
  dispatch brief — see Reconciliation note above.
- **PR #675 MERGED same-burst**, squash commit `d55bedf7` on `develop`, 2026-08-11T01:40:55Z.
  `develop` CI on `d55bedf7` (run 31450052302): SUCCESS, 12 success + 2 legitimately-skipped
  (`Mutation testing` + `Secret Scan`, both `pull_request`-only); `CI Gate` correctly green.
  `Scorecard` and `E2E (Live Jira)` also passed on the merge commit.
- **New decision:** **DEC-264** (PR #675 merged after adversarial claim-accuracy review and four
  amendments; reviewing a documentation-only PR found two MEDIUMs, justifying the practice).
- **Full narrative:** `cycles/cycle-001/burst-log.md` § "PR675-MERGE+ADV-P675-CLOSE".

---

# Adversarial Review Index — S-CIGATE-3 (Feature Mode SOH-DX-1 F4 follow-up) Passes 1..6

<!-- Added 2026-08-11 by the S-CIGATE-3-IMPLEMENTED bookkeeping burst. These 6 passes are a
     STORY-SCOPED adversarial window for S-CIGATE-3 (durable YAML-parser fix), run during that
     story's own implementation session on worktree `.worktrees/S-CIGATE-3`, branch
     `test/ci-gate-real-yaml-parser`. They are DISTINCT from S-626-1's 61 Step-4.5-eligible
     passes recorded above — not counted toward Step 4.5's 3/3 window arithmetic, not governed
     by the SOH-DX-1 F4 Step 4.5 process (this is a new, separate story, not a continuation of
     S-626-1). The same DEC-245 CLEAN criterion (zero HIGH + zero MEDIUM + zero LOW) was applied
     by human ruling (DEC-265b) for consistency across stories. No per-finding-ID detail file
     exists for this window (unlike some of S-626-1's early passes); this section's per-pass
     rows are derived from the closing summary table supplied to this bookkeeping burst, with the
     per-pass finding COUNTS independently re-verified by direct summation (6+7+3+2+5+4=27) —
     the closing summary's prose total of "29" did not match its own per-pass table and is NOT
     used here. See drift item `RECURRING-DEFECT-RELOCATES-NOT-CLOSES` and the four `[codified]`
     lessons in `lessons.md` for the process findings from this same window. -->

## S-CIGATE-3 Summary

| Field | Value |
|-------|-------|
| Story | S-CIGATE-3 (durable YAML-parser fix; `.factory/stories/S-CIGATE-3-ci-yml-real-yaml-parser.md`) |
| Worktree / branch | `.worktrees/S-CIGATE-3`, `test/ci-gate-real-yaml-parser`, branched from `develop` @ `d55bedf7` |
| Commits | 17, `8af710f8`..`aeeebe01` (re-derived via `git rev-list --count develop..test/ci-gate-real-yaml-parser`; NOT pushed, no PR opened — DEC-128) |
| Passes | 6, all NOT CLEAN; window ends PERMANENTLY at 0/3 (no CLEAN pass reached), mirroring the DEC-262 shape |
| Total findings | 27 (re-derived by direct summation of the per-pass table below; all 27 fixed pre-close) |
| Severity distribution (this window only) | `{ CRIT: 0, HIGH: 1, MED: 10, LOW: 16, INFO: 0 }` |
| Basis | TRUE ADVERSARY AGENT, fresh context per pass (no prior-pass visibility) |
| Convergence | 0 of 3 FINAL — DEC-265b (human ruled to keep running the window past pass-3's HIGH rather than pausing); ends permanently at 0/3 after 6 passes |

## S-CIGATE-3 Per-Pass Findings

| Pass | Verdict | Findings | Frontier | Disposition |
|------|---------|----------|----------|-------------|
| ADV-SC3-P1 | NOT CLEAN | 4 MEDIUM + 2 LOW (6) | Parser fidelity + new API root frontier | All 6 FIXED, incl. `wf.rs`'s zero-own-test-coverage gap (MED-001) closed by adding 20 tests |
| ADV-SC3-P2 | NOT CLEAN | 2 MEDIUM + 5 LOW (7) | The fix commits themselves (self-referential review of pass-1's fixes) | All 7 FIXED |
| ADV-SC3-P3 | NOT CLEAN | 1 HIGH + 1 MEDIUM + 1 LOW (3) | Historical coverage replay (24 of 27 documented S-626-1-era attacks re-run against the new model) | All 3 FIXED; human ruled to keep running the window rather than pause after this pass's HIGH (DEC-265b) |
| ADV-SC3-P4 | NOT CLEAN | 1 MEDIUM + 1 LOW (2) | Guard lifecycle, composite attacks, pin-maintenance load | Both FIXED; first instance of the "exactly one step by NAME" defect shape (see class-sweep note below) |
| ADV-SC3-P5 | NOT CLEAN | 1 MEDIUM + 4 LOW (5) | White-box attacker + previously-unseen YAML | All 5 FIXED; second/third instances of the same defect shape, restated by `run:` KEY then `run:` VALUE |
| ADV-SC3-P6 | NOT CLEAN | 1 MEDIUM + 3 LOW (4) | Ambiguity discipline + protection asymmetry | All 4 FIXED via a class-level sweep ("the selected step actually RUNS") after the fourth restatement of the same shape — see `RECURRING-DEFECT-RELOCATES-NOT-CLOSES` |

**Arithmetic check:** 6+7+3+2+5+4 = **27**. HIGH: 1 (pass 3 only). MEDIUM: 4+2+1+1+1+1 = 10. LOW:
2+5+1+1+4+3 = 16. 1+10+16 = 27. Confirms the total above; the dispatch instruction's prose claim
of "29 findings" did not match its own supplied per-pass table.

## S-CIGATE-3 Notable Findings Closed

- **Round-16 node-property residual** (`&x shell:` / `!!str shell:` prefixing a mapping key) —
  previously CLAUDE.md-documented as UNGUARDED with code review as the sole control. Closed two
  independent ways: key-set pins on the new event-stream model, plus a dedicated
  `find_key_node_properties` check (AC-007).
- **`POSITIONAL-ASSUMPTION-AXIS`** (HIGH drift item, deferred from S-626-1 window 57/58/59) —
  closed by construction (tree membership, not indent arithmetic).
- **`RED-PROOF-NEEDS-SPELLING-VARIANTS`** (HIGH drift item, deferred from S-626-1 window
  57/58/59) — closed via two-axis (spelling × indent/position) RED proofs across every
  rewritten guard (AC-008).
- **`ADV-P55-MED-002`** (flow-style job entries, S-626-1-era finding) — closed by construction.
- Job-level `defaults: run: shell: cat {0}` — previously unguarded on 5 always-run jobs; now
  covered.
- `msrv` job — previously had NO key-set pin of any kind; now pinned at both job and step level.
- A decoy step could previously silently skip the entire Rust test suite — closed.
- `if: false` / `shell: cat {0}` on a guard step — closed (4th relocation of the recurring
  defect shape; see `RECURRING-DEFECT-RELOCATES-NOT-CLOSES`).
- Duplicate mapping keys, duplicate job ids, and multi-document YAML streams — all now refused
  by the new event-stream model.

## S-CIGATE-3 Human Rulings This Window

- **DEC-265a:** fix the two pre-existing bypasses (round-16 node-property residual;
  `POSITIONAL-ASSUMPTION-AXIS`/`RED-PROOF-NEEDS-SPELLING-VARIANTS`) inside this story's own
  scope rather than deferring them again.
- **DEC-265b:** keep running the window past pass-3's HIGH finding rather than pausing to
  re-scope, under the same DEC-245 CLEAN criterion S-626-1's ten windows used.

## S-CIGATE-3 Open Items (human ruling pending, not resolved by this window)

1. AC-006's rationale in the story spec file is FALSE (claims the exact-version pin protects
   the `msrv` CI job; `msrv` only checks lib+bins, `saphyr-parser` is a dev-dependency) — the
   `Cargo.toml` comment was corrected in-branch (`80a872e4`); the story file's AC-006 text was
   not, per explicit instruction to this bookkeeping burst. See drift item
   `AC-006-FALSE-RATIONALE-UNCORRECTED`.
2. Value-side anchor gap (`run: &x cmd` — `resolve_value` discards `anchor_id`) — documented,
   not closed; no exploit constructible against any currently-pinned guard. See drift item
   `VALUE-SIDE-ANCHOR-GAP-UNCLOSED`.
3. Whether the `ScalarStyle::Plain` fidelity mandate (an implementer judgment call made under
   AC-004) should become a formal decision record.
4. Whether to instantiate `.factory/policies.yaml` — absent in this project; all six passes ran
   on baseline rubric only. See drift item `POLICIES-YAML-NOT-INSTANTIATED`.
5. **Merge decision:** the window ended 0/3, never converged — the same DEC-262 shape (merge on
   code grounds with convergence explicitly unmet) is available as precedent but was NOT
   exercised by this bookkeeping burst; merge authority is the human's (DEC-128). The story
   branch remains unpushed with no PR opened.

---
