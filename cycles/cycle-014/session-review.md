---
document_type: session-review
level: ops
version: "1.1"
status: complete
producer: session-reviewer
timestamp: 2026-10-05T00:00:00Z
date: 2026-10-05
run_id: cycle-014-issue-triage-quickfixes
path: 4
path_name: feature
product: jr (jira-cli)
duration: "2026-09-24 (F1 open) to 2026-10-05 (F7 gate D-410 + release 0.8.0-dev.2), 12 calendar days; per-phase wall time not recorded (see Proposal 9)"
total_cost: "n/a — not tracked (see proposal 9); no .factory/cost-summary.md exists"
stories_delivered: 3
cycle: "cycle-014-issue-triage-quickfixes"
stories: [S-cycle14-user-list-project-resolution, S-cycle14-api-query-param, S-cycle14-field-options-name-label]
proposals_adjudicated: "pending — human review window 72h (opened 2026-10-05); NONE of the proposals below has been applied"
inputs: [STATE.md, cycles/cycle-014/cycle-manifest.md, cycles/cycle-014/phase-f5-adversarial/F5-convergence-report.md, cycles/cycle-014/phase-f6-hardening/F6-report.md, cycles/cycle-014/phase-f7-convergence/delta-convergence-report.md, cycles/cycle-014/process-gaps.md, cycles/cycle-014/engine-handoff-vsdd-factory.md, cycles/cycle-014/lessons.md, cycles/OPEN-STANDING-ITEMS.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Session Review: jr (jira-cli) — feature — 2026-10-05

**Cycle:** cycle-014 (`issue-triage-quickfixes`), 2026-09-24 to 2026-10-05.
**Delivered:** 3 stories (16 points: STORY-A #862 3 pts BREAKING, STORY-C #583 8 pts, STORY-B #861 5 pts), plus 15 fix PRs (#891..#910), released as dev pre-release `0.8.0-dev.2` (PR #911 merged as `fb9d015c`; annotated tag `v0.8.0-dev.2` pushed; `release.yml` run 37324389051 succeeded).
**Gates:** F1 D-379, F2 D-384, F3 D-390 (after D-389 closed convergence at pass 33), F5 converged 3/3 (passes 12-14), F6 PASS (116 mutants, 0 missed), F7 converged after 4 cycles, human F7 gate D-410.
**Review is read-only. Nothing here is applied automatically; the human ratifies each proposal (72h window). The lessons L-007..L-015 below are NOT yet in `lessons.md`; they are pending the same human review.**

## Executive Summary

The code and tests were strong and stable throughout (no code defect after F5 Pass 4; F6 mutation 0 missed; security PASS), but a 16-point quickfix cycle consumed roughly 47 counted adversarial passes, 5 uncounted rehearsals, 15 fix PRs and 4 F7 cycles. The cost came from three causes: a review bar above the factory's own (F3, 33 passes, 0 clean), absorption of a pre-existing cross-cutting finding (SEC-001) into F5 that grew the delta about 2.5x, and prose claims becoming the dominant defect surface. The top recommendations are a scope-triage gate for pre-existing findings (Proposal 1), a delta-sized adversarial-pass budget declared at F1 (Proposal 2), and a doc-only fix lane (Proposal 3). Cost and wall-clock could not be assessed because neither is recorded (Proposal 9).

## Run Overview

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| Total cost | n/a — not tracked (see proposal 9) | n/a — no cost baseline exists | DATA GAP |
| Duration | 12 calendar days (2026-09-24 to 2026-10-05); per-phase wall time not recorded | n/a — no baseline | DATA GAP |
| Stories delivered | 3 (16 points, 31 ACs) | — | — |
| Adversarial rounds | ~47 counted (33 F3 + 14 F5), plus 5 uncounted F5 rehearsals and F3-side Step 4.5 per-story loops | n/a — no per-path average recorded; cycle-001 CITATION-GUARDS: STANDARD 15 vs STRICT 44 F3 passes | HIGH for 16 points |
| PR review rounds | not recorded per story; 15 fix PRs each through fix-pr-delivery review | n/a — not tracked | DATA GAP |
| Gate failures | F5 passes 1-11 NOT CLEAN; F7 cycles 1-3 NOT ALL CONVERGED (bookkeeping findings only); F3 0 clean in 33 passes | n/a — no baseline | HIGH |
| Human interventions | Gates D-379, D-384, D-390, D-410; policy decisions D-389, D-403, D-406, D-407, D-408, D-409; every one of 18 story and fix PR merges hand-merged (harness classifier denied autonomous merge) | n/a — no baseline | HIGH |
| Holdout satisfaction | not recorded for this cycle (118 holdout scenarios LOCKED; no cycle-014 evaluation score in the reviewed artifacts) | >=0.85 | DATA GAP |
| Mutation kill rate | 100% of non-equivalent, viable mutants (107 killed / 0 missed; 116 total incl. 7 unviable, 2 equivalent) | >=90% | PASS |

---

## 1. Cost Analysis

**Not assessable from artifacts.** No `.factory/cost-summary.md` exists and per-phase or per-agent tokens and dollars are not recorded. What can be said is volume, not cost: the cycle ran ~47 counted passes, 5 uncounted rehearsals (R12, R12B, R12C, R13, R14, none costed), 15 fix PRs each with reviewer (and, for the non-doc-only ones, security) passes, and 4 F7 re-runs each including the 1627-test lib suite and all integration suites, for 16 story points. Without a dispatch ledger, Proposals 1-3 cannot be prioritised by value. **Recommendation:** Proposal 9 (dispatch ledger, including uncounted rehearsals).

## 2. Timing Analysis

**Not assessable beyond merge timestamps.** Recorded: STORY-A merged 2026-09-29, STORY-C 2026-09-30, STORY-B 2026-09-30; F5 fix PRs #891..#910 merged 2026-10-01 to 2026-10-04; F6 and F7 on 2026-10-05; release PR #911 merged (`fb9d015c`), tag `v0.8.0-dev.2` pushed, prerelease published 2026-10-05T14:29:10Z. No wall-clock per phase or per agent. The human merge interruptions (18 PRs) are the visible latency contributor. **Recommendation:** Proposal 9; Proposal 3 (batch doc fixes) and Proposal 11 (merge-policy reality check) address the interruption count.

## 3. Convergence Analysis

### 3.1 Headline numbers

| Measure | Value | Observation |
|---|---|---|
| F3 story-review passes | 33 (D-389 closed it, human override) | 0 clean passes across 33; reviewer bar was stricter than the factory's own (D-389 research) |
| F5 counted passes | 14 (cap raised 10 -> 15, D-403) | 11 NOT CLEAN, then 3 clean |
| F5 uncounted rehearsals | 5 (R12, R12B, R12C, R13, R14) | Not costed |
| F5 delta size | ~25 files, ~7.5k lines | F4 gate delta was 19 files; SEC-001 and its siblings roughly doubled the delta |
| F7 cycles | 4 | Every finding bookkeeping (F7C1-005, F7C2-001..005, F7C3-001, F7C4-001) |
| Adversarial passes total | ~47 counted (33 F3 + 14 F5), plus F3-side Step 4.5 per-story loops and 5 rehearsals | For 16 story points |
| Code defects after F5 pass 4 | 0 | Per the convergence report: passes 5-14 were doc/spec drift (plus accepted security residuals) |

### 3.2 What was costly

1. **F3 (33 passes, 0 clean).** The single largest avoidable cost of the cycle. Three small stories were reviewed to a bar (strict 3-consecutive-clean, then D-386 bind-by-reference, D-387 line-span coverage, D-388, O/N/U labelling) that exceeded the factory's own VSDD.md bar. Each added mechanism created new surface for the next pass to find drift in (clause maps drifted from AC citations, so D-387 deleted them; revision notes contradicted bodies, so they were split into `*.revision-history.md`). D-389 ended it by returning to factory rules. This is the same finding the cycle-001 CITATION-GUARDS review made (strict criterion = ~3x the passes, STANDARD leaked nothing); the recommendation was never adopted as a default, so it recurred.
2. **F5 (14 counted passes + 5 rehearsals + 15 fix PRs).** Pass 1-2 had real findings. Passes 3-11 were ~all doc/spec drift in a delta that had grown to ~7.5k lines. Each drift fix was itself a PR with Step-4.5-style review plus security review, then a re-review pass that found drift in the fix. Three same-pass-class loops are visible: (a) `field.rs::handle` rustdoc drifted three passes running (P12-001, #909 NB-1, P13-001/CR13-001) until it was simplified (L-006); (b) completeness claims (P9-001, P11-002, P11-003); (c) BC-INDEX vs BC H1 (P11-001, 240 baseline mismatches, guard still deferred #906).
3. **F7 (4 cycles, all bookkeeping).** Each cycle re-ran the full 7-dimension consistency validation including the 1627-test lib suite and every integration suite, to find bookkeeping wording. The F7 cycles also produced their own findings: writing the F7 report (F7C2-004), the stale "in flight" label on the F6 report (F7C2-001), stale STATE position labels (F7C4-001). The loop is partially self-feeding.

### 3.3 Root causes of churn (ranked)

| # | Root cause | Evidence | Already tracked? |
|---|---|---|---|
| RC-1 | **Review bar > factory bar; "clean" undefined.** Adversary prompt discourages clean passes; strict 3-consecutive rule is non-convergent at this delta size (PG#13/#27/#31). | F3 33 passes; F5 8 passes to hit the 10-cap | Engine handoff C (PG 13, 27, 31). Not re-proposed. Recurrence note only: cycle-001 review made the same recommendation. |
| RC-2 | **Scope absorption.** A pre-existing, codebase-wide MEDIUM finding (SEC-001, surfaced at the F4 gate, not caused by this cycle's stories) was fixed INSIDE F5 of a 16-point quickfix cycle (D-392). Its sibling sinks then widened scope three times (D-393/394/395) and spawned 15 fix PRs and the long doc tail. The delta under adversarial review became ~2.5x the original. | SEC-001-triage.md; D-392..D-395; F5 report "~7.5k-line, 25-file delta" | PG#40/#41 cover scope growth *within one PR*, not the decision to host the finding in this cycle. NEW (Proposal 1). |
| RC-3 | **Prose is the defect surface.** Once code was clean, every spec sentence, rustdoc enumeration, CLAUDE.md size-deviation entry, and index row was an independently-falsifiable claim. Defects after Pass 4 were all claim-vs-reality. Volume of prose per fix (spec-delta files FIX-P5-001..013, BC edits, ADR amendments, CLAUDE.md edits) outran any mechanical check. | L-001..L-006; pass 8-11 MEDIUMs | Partially: L-002/L-006, D-401..D-405. No mechanism that *limits prose volume* or *checks claim words*. NEW (Proposals 4, 5). |
| RC-4 | **Doc-only fixes run the code pipeline.** No lighter path for comment/rustdoc/help-only PRs. | 5 of 15 PRs | NEW (Proposal 3). |
| RC-5 | **Self-referential closure artifacts.** STATE.md, cycle-manifest, F6 report, F7 report all describe the position they are part of; partial Edits left stale labels; each F7 cycle's fixes created new description-vs-position drift. | F7C2-001/002, F7C4-001, STATE "F7C4-001" rewrite discipline | STATE convention exists (F7C4-001 note). No engine guard. NEW (Proposal 6). |
| RC-6 | **Unverified orchestrator-supplied facts.** The orchestrator passed numbers to a subagent that were not derived from the artifacts; F7C3-001 shows the stated drift ("11 files, shared hash `c3fc19a` vs `70d1caa`") was wrong (actual: 10 DRIFT files, two stored hashes, plus one file with no `inputs:`). PG#39 records the same class for a spec literal ("one orchestrator-supplied literal"). | F7C3-001; process-gaps.md | PG#47 (dispatch labels) is adjacent but about intent, not facts. NEW (Proposal 7). |
| RC-7 | **Large factory files + hook fuel cap.** | STATE.md ~75 KB; OPEN-STANDING-ITEMS ~195 KB | Engine side tracked (PG#3/#44). jr-side file-size reduction NEW (Proposal 8). |

## 4. Agent Behavior Analysis

1. **Fix-PR overhead on trivial changes.** Five comment/doc-only PRs each went through the full fix-pr-delivery path and a human merge (the harness classifier denied autonomous merge every time despite D-391). D-407(b) ("fix NITs now in tiny PRs so confirming passes review shipped code") is sound but multiplies this overhead (Proposal 3, Proposal 11).
2. **Orchestrator-supplied facts treated as verified** (RC-6; F7C3-001, PG#39): Proposal 7.
3. **Adversary behaviour**: the uncounted rehearsal (D-406(c)) measurably worked, converting "adversary discovers drift on the record" into "adversary discovers drift off the record" (Passes 12-14 were the first three consecutive clean counted passes after adoption). Late-pass adversary lens recursed into "claims about claims" (completeness, mirrored), see dimension 8.
4. **Hook/tooling friction.** `FUEL_EXHAUSTED` (PG#3/#44, left as-is by D-410(d)), hook false positives (PG#10/#11/#48/#51), input-hash structural staleness on closed artifacts (PG#12; 265 of 298 STALE at F2, still 10 pre-cycle-014 `S-PG-*` files drifting). Large factory files are the common trigger: STATE.md ~75 KB, `OPEN-STANDING-ITEMS.md` ~195 KB, `cycle-manifest.md` ~59 KB, `process-gaps.md` ~50 KB (Proposal 8).

## 5. Gate Outcome Analysis

- F1 D-379, F2 D-384, F3 D-390 (after D-389 closed adversarial convergence at pass 33 by human override), F4 complete (3/3 stories), combined wave integration gate PASSED (all 6 checks, `204b1fb5..2ee422e0`), F5 CONVERGED (Passes 12, 13, 14 CLEAN, 3/3; D-407 NIT-only counts clean), F6 PASS, F7 CONVERGED after 4 cycles, human F7 gate D-410.
- **Per-wave gate skipped** on serial one-story waves (PG#37), compensated by one combined gate. Cost was a deviation record, not a defect.
- Convergence-policy decisions were made on evidence, not fatigue: D-389 (research showing the cycle's bar exceeded the factory's own), D-403 (cap raise with the strict rule kept), D-407 (NIT-only defined as clean) each carried a written rationale and a bounded scope.
- F7 gates 1-3 were not-all-converged purely on bookkeeping; Proposal 10 targets this.

## 6. Wall Integrity Analysis

No wall-integrity violation (cross-story or holdout information leak) is recorded in the reviewed artifacts. The relevant integrity observations are about scope and process walls: (a) the scope wall between "delta introduced by the stories" and "pre-existing finding" was not enforced (RC-2, Proposal 1); (b) the per-wave gate was skipped on serial one-story waves with a combined gate substituting (PG#37); (c) the harness classifier wall against autonomous merges held on every merge, contradicting the D-391 standing policy text (Proposal 11). Holdout-evaluator isolation was not examined in this review (evidence gap).

## 7. Quality Signal Analysis

### 7.1 What worked

1. **Code and test quality were strong and stable.** No code defect after F5 Pass 4; F6 formal PASS (VPs proven, 136 lib proptests at 2048 cases), mutation 0 missed (116 mutants: 107 killed, 7 unviable, 2 equivalent), security PASS with no findings. Late security INFO notes (SEC14-N1..N3) were policy-class residuals, not defects.
2. **The SEC-001 fix was a good architectural call.** One chokepoint (`output::sanitize_table_cell`, `render_table`) instead of per-call-site sweeps; D-396 moved the `--no-color` gate into the styled-table API so future `StyledCell` callers inherit it structurally. D-399/D-400 stopped per-pass extension of the invisible-character policy by making it category-based and recording accepted residuals EC-23/EC-24. That is the correct response to an open-ended adversary.
3. **Anti-drift conventions were codified quickly** (D-401..D-406, L-001..L-006) and the sink-inventory completeness claim was finally audited mechanically (D-404: 306 grep hits -> 97 interpolating sites).
4. **Process-gap capture was disciplined.** 53 gaps recorded, split by owner (D-408), with the engine items in one hand-off file. This is the best-run part of the cycle.

### 7.2 Quality metrics

| Measure | Value | Observation |
|---|---|---|
| Product work | 3 stories / 16 pts / 31 ACs | Small by design (a "quickfix" cycle) |
| Fix PRs | 15 (#891..#910), every one hand-merged | 5 of 15 comment/doc/help-only (#903, #905, #908, #909, #910) |
| Mutation (F6) | 116 mutants: 107 killed, 0 missed, 7 unviable, 2 equivalent | Code quality was never the problem |

## 8. Pattern Detection

Cross-run comparison (dimension 8):

| Pattern | Earlier evidence | This cycle | Status |
|---|---|---|---|
| Strict clean criterion inflates passes | cycle-001 CITATION-GUARDS: strict 44 vs standard 15 F3 passes | F3 33 passes; F5 non-converging until D-407 | RECURRING; recommendation not adopted as a default |
| Registration-surface / index drift (BC-INDEX, CANONICAL-COUNTS) | CITATION-GUARDS: 3 fix rounds for same class | P11-001, F7C1-001 (VP tally) | RECURRING; guards deferred (#906, PG#2/#6) |
| Adversary meta-lens recursion on guard specs | CITATION-GUARDS: VA lens | Pass 8-11 "claims about claims" (completeness, mirrored) | RECURRING in a new form |
| Count-pin errors | CITATION-GUARDS: off-by-one | VP total 98 vs 100 (F7C1-001) | RECURRING |
| Adversary factual error resolved by orchestrator | CITATION-GUARDS F4 pass 1 | P3 false positive noted in pass 3 | recurring, low cost |

Bootstrap note: `.factory/session-reviews/benchmarks.yaml` and `pattern-database.yaml` exist but were not part of this review's requested source list; they should receive this cycle's rows (passes per point, fix PRs per point, doc-only fraction, F7 cycles) so cycle-015 has a baseline.

## 9. Governance Policy Audit

Evidence limit: this review read only the artifacts listed in `inputs`; the registry-policy checks below were not individually audited, except where the artifacts give direct evidence.

- `bc_h1_is_title_source_of_truth`: direct evidence of stale BC-INDEX titles vs BC H1s (P11-001: 240 baseline mismatches of 528; instances fixed in spec 2.8.8; mechanical guard still deferred as #906). Strengthening candidate, see Proposal 12.
- `bc_array_changes_propagate_to_body_and_acs` / `vp_index_is_vp_catalog_source_of_truth`: F7C1-001 (VP total 98 recorded vs 100 actual, two VPs minted in FIX-P5-004/005 never counted) is a count-propagation instance of the same family.
- `state_manager_runs_last`: not assessed in this review.
- `append_only_numbering`, `lift_invariants_to_bcs`, `semantic_anchoring_integrity`, `creators_justify_anchors`, `architecture_is_subsystem_name_source_of_truth`: not assessed in this review (no evidence in the listed artifacts either way).

**New policy candidates (drift recurring across 3+ bursts or 2+ adversarial passes):**
1. Claim-vs-reality drift in prose ("complete", "only", "every", "mirrored", enumerated effect lists): recurred across passes 8-14 (P9-001, P11-002/003, P12-001, P13-001, CR13-001). Proposed statement: any universal-quantifier claim in changed rustdoc/spec/CLAUDE.md lines must carry a recorded verification or be scoped down (Proposal 4). Failing agents: story/fix authors; detection fell to the adversary.
2. Stale position labels in self-describing closure artifacts: F7C2-001/002/004 and F7C4-001 (3 of 4 F7 cycles). Proposed statement: every current-tense position surface moves in one write, validated by a cross-surface check (Proposal 6).

---

## Improvement Proposals

Priority = expected cycle-cost reduction / risk. Items already in `engine-handoff-vsdd-factory.md` (PG numbers) or the Drift Items table are referenced, not repeated: PG#3/#44 fuel cap, #10 regex, #11/#48/#51 staging hook, #12 input-hash staleness, #13/#27/#31 clean definition, #26 F3 loop definitions, #28 invariants vs fresh context, #29 adversary model family, #30 pass-cap counter, #32 identity tuple, #36 merge classifier, #37 per-wave gates, #40/#41 sink inventory, #42 hang timeout, #46 fix-PR convergence record, #47 dispatch labels, PG#50/#52/#53 and `BC-INDEX-H1-SYNC-GUARD`, `SPEC-QUALIFIER-PROPAGATION-GUARD`, `MUTANTS-*` items.

**These proposals are PENDING HUMAN REVIEW (72h). None has been applied.**

### Proposal 1: Scope-triage gate for findings that predate the cycle
- **Category:** workflow (engine)
- **Priority:** HIGH
- **Evidence:** RC-2. A pre-existing cross-cutting finding found at the F4/F5 boundary was absorbed into the open cycle's F5 and expanded its delta from 19 files to ~25 / ~7.5k lines (SEC-001-triage.md "pre-existing and codebase-wide", D-392..D-395). Expected save: most of passes 3-11 and ~10 of the 15 fix PRs.
- **Recommendation:** F5 (and the F4 wave gate) gets an explicit classification step for each non-blocking finding: `INTRODUCED-BY-DELTA` (fix in cycle) vs `PRE-EXISTING` (default: separate fix-cycle or tracked item with its own F1-F7 slice, unless the human explicitly opts in with a recorded delta-size ceiling). If the human opts in, record the delta-size ceiling (files, lines) in the decision; crossing it forces a re-scope checkpoint, not another silent widening. Impact: removes the single biggest driver of F5 length; would likely have kept F5 in the 3-5 pass range.
- **Affected files:** vsdd-factory F5/wave-gate skills and orchestrator feature-sequence; jr `STATE.md` decision template.
- **Risk:** a real vulnerability can sit in standing items; mitigate by requiring a target cycle and severity-based deadline on the deferral. Human decision: yes (this is a governance rule).

### Proposal 2: Make the adversary's bar and cap budget an F1-declared, delta-sized budget (extends PG#13/#27/#30/#31)
- **Category:** convergence (engine)
- **Priority:** HIGH
- **Evidence:** PG#30 asks for a counter forcing a human checkpoint at 10/20/30, which reacts after the spend. This cycle's F3 hit 33 and F5 hit 14 for 16 points. Cross-run pattern: the cycle-001 CITATION-GUARDS review recommended STANDARD as the default criterion and escalation to STRICT only for meta stories; that was never made the default.
- **Recommendation:** At F1, from the delta-analysis size (files, LOC, ACs), the orchestrator writes an adversarial-pass budget per phase (e.g. F3 ~8, F5 ~8) and an expected clean bar. Budget exhaustion is a hard human checkpoint with a written options list (accept residuals / lower bar per D-389 style / re-scope per Proposal 1). Track `passes per story point` in the cycle manifest. Separately, the human can adopt the STANDARD default as a jr-side standing decision immediately (no engine change needed) so cycle-015 does not repeat F3. Impact: converts D-389/D-403-style rescues from ad hoc to routine, and makes the cost visible (Proposal 9).
- **Affected files:** vsdd-factory orchestrator feature-sequence and adversarial-review skill; jr `cycles/<cycle>/cycle-manifest.md` template (passes-per-point row); jr STATE Decisions Log (standing decision).
- **Risk:** a budget set too low forces premature human checkpoints; mitigate by making the budget a checkpoint, not a hard stop.

### Proposal 3: Doc-only fix lane with batched PRs
- **Category:** workflow (engine)
- **Priority:** HIGH
- **Evidence:** RC-4. 5 of 15 fix PRs (#903, #905, #908, #909, #910) were comment/doc/help-only, each through full fix-pr-delivery + review + human merge. About 5 PRs, 5 human merge interruptions and 5 reviewer cycles saved this cycle.
- **Recommendation:** In `fix-pr-delivery`, define a `DOC-ONLY` lane: a diff that touches only comments, rustdoc, `*.md`, clap help strings (no behavior), verified mechanically (e.g. `cargo test --lib` plus a check that non-comment tokens are unchanged, `git diff -w` comment-stripped, or `cargo doc`/snapshot of `--help`). That lane gets one fresh code-reviewer pass (no separate security-reviewer unless a spec-claimed security surface changed), no per-fix adversary convergence record, and batching of all NIT and doc fixes from a pass (and the rehearsal that follows it) into ONE PR. Reconciles with D-407(b): still "fix NITs before the confirming passes", just one PR per pass-cycle instead of one per finding group.
- **Affected files:** vsdd-factory `fix-pr-delivery` skill and pr-manager agent.
- **Risk:** a "doc-only" mislabel hiding a code change; mitigate with the mechanical check (hash of the comment-stripped source).

### Proposal 4: Claims ledger and a changed-lines claim-word lint (extends L-002, D-404)
- **Category:** quality (jr-repo)
- **Priority:** HIGH
- **Evidence:** RC-3. The recurring drift class is a prose claim ("complete", "only", "every", "mirrored", "M2-only", an enumerated effect list) that stops being true; detection currently depends on a fresh LLM adversary reading prose (passes 9-11 MEDIUMs, P12-001, P13-001).
- **Recommendation:** (a) a small script in `scripts/` run in the `spec-guard` job (or locally in the fix-PR checklist) that greps changed lines of `src/**/*.rs` rustdoc, `CLAUDE.md`, and `.factory/specs/**` for the claim words (`only`, `every`, `all`, `always`, `never`, `complete`, `mirror`, `identical`, `exactly`) and requires each hit to carry an adjacent `claim-verified:` note (command or test) or be removed; (b) a `claims-ledger.md` row per surviving claim: statement, verification command, last-verified commit. The ledger lives in the same file as the Canonical Sink Inventory pattern (single source). Impact: converts the pass 9-11 MEDIUM class into a mechanical check, so the adversary spends passes elsewhere. Cheap: one shell script plus one guard test following the existing `scripts/check-*.sh` pattern.
- **Affected files:** new `scripts/check-claim-words.sh`, `.github/workflows/ci.yml` spec-guard job (touches the ci-gate review scope), new claims-ledger file under `.factory/specs/`.
- **Risk:** noise on legitimate uses of "all"; start advisory (warn, not fail), tighten after one cycle.

### Proposal 5: Prose-volume budget on fix PRs
- **Category:** quality (jr-repo)
- **Priority:** MEDIUM
- **Evidence:** RC-3. Each fix added spec-delta, BC prose, ADR amendments and CLAUDE.md text, enlarging the falsifiable surface for the next pass (e.g. the CLAUDE.md BC-7.1.006 bullet is now a multi-hundred-word paragraph restating inventory, which L-002/D-401 told us not to restate).
- **Recommendation:** adopt a rule for fix PRs: net spec/CLAUDE.md/rustdoc lines added must be justified in the PR; prefer deletions and pointers ("see BC-7.1.006 Canonical Sink Inventory") over restatement; a quarterly CLAUDE.md compaction sweep that moves the long Gotchas paragraphs into `docs/specs/*` with a one-line pointer (the `claude_md_citations` test already guards paths). The BC-7.1.006 gotcha is the first candidate. Impact: shrinks the surface that drifts; also reduces the context size every session pays.
- **Affected files:** jr `CLAUDE.md`, PR template / fix-PR checklist, `docs/specs/*`.
- **Risk:** moving content out of CLAUDE.md can hide guidance from agents that only read CLAUDE.md; mitigate with one-line pointers kept in place.

### Proposal 6: Position-surface consistency check and single-write STATE (RC-5)
- **Category:** workflow (engine)
- **Priority:** MEDIUM
- **Evidence:** stale labels in STATE.md and cycle artifacts (F7C2-001/002/004, F7C4-001) after partial Edits; the jr-side convention (full Write, F7C4-001 note, MEMORY `feedback_statemd_full_write`) is a human-memory fix. Removes the "stale label" finding class from F7 dims 6/7 (3 of the 4 F7 cycles' findings).
- **Recommendation:** (a) extend `check-state-health` with a cross-surface assertion: the phase/status token set (frontmatter, Pipeline Status, Current Phase Steps, Blocking Issues, Convergence Status, Session Resume Checkpoint, size-budget comment) must agree; run it as the last step of every state-burst. (b) Prefer a structured `position:` frontmatter block that the other surfaces are rendered from, so one edit moves all. (c) Fold the cycle-manifest `status:` and F6/F7 report headers into the same check.
- **Affected files:** vsdd-factory `check-state-health` skill, `state-burst` skill, state-template.md.
- **Risk:** a rendered-surface scheme changes the STATE template for every project; stage it as an opt-in check first.

### Proposal 7: "Supplied facts" discipline in dispatch (RC-6)
- **Category:** agent (engine)
- **Priority:** MEDIUM
- **Evidence:** the orchestrator gave a subagent specific numbers that were not verified (F7C3-001; PG#39 notes an orchestrator-supplied example literal never executed). Distinct from PG#47 (intent labels).
- **Recommendation:** orchestrator dispatch template gets a `## Supplied facts` section; each fact is either (a) `VERIFIED: <command and output>` or (b) `UNVERIFIED: re-derive before use`. Subagents (state-manager, story-writer) must re-derive any `UNVERIFIED` fact and report divergence rather than transcribe it. Add to the state-manager prompt: "numbers in a Drift row must come from a command you ran this session". Impact: removes the F7C3-class finding at its source; cheap.
- **Affected files:** vsdd-factory orchestrator dispatch template, state-manager agent prompt, story-writer agent prompt.
- **Risk:** extra dispatch verbosity; low.

### Proposal 8: Reduce factory file size to stay under the hook fuel cap
- **Category:** workflow (jr-repo)
- **Priority:** MEDIUM
- **Evidence:** RC-7. The engine fix (PG#3/#44) is outside this repo's control and D-410(d) left the workaround as-is; the trigger is file size, which jr controls (STATE.md ~75 KB, `OPEN-STANDING-ITEMS.md` ~195 KB, `cycle-manifest.md` ~59 KB with ~30 dated progress notes, `process-gaps.md` ~50 KB).
- **Recommendation:** run `compact-state` on STATE.md (target the documented <200-line slim form); split `cycles/OPEN-STANDING-ITEMS.md` into per-status files (`open/`, `resolved/` already partly exists as `RESOLVED-DRIFT-ITEMS.md`); archive `process-gaps.md` and `cycle-manifest.md` progress notes. Add a size budget line to `check-state-health` runs (warn at 50 KB for any single factory file). Impact: fewer `FUEL_EXHAUSTED` content-block false alarms, shorter reads for every agent, faster bursts.
- **Affected files:** `.factory/STATE.md`, `.factory/cycles/OPEN-STANDING-ITEMS.md`, `cycles/cycle-014/process-gaps.md`, `cycles/cycle-014/cycle-manifest.md`.
- **Risk:** compaction rewrites historical files; do it as its own reviewed burst (human judgement).

### Proposal 9: Capture cost and time per phase (assessment gap)
- **Category:** cost (engine)
- **Priority:** MEDIUM
- **Evidence:** this review could not assess cost or wall time; `cost-summary.md` is absent and per-agent tokens are not recorded. The cycle ran ~47 counted passes, 5 uncounted rehearsals, 15 fix PRs with reviewer and security passes, 4 F7 re-runs, with no measure of what they cost. Without that, Proposals 1-3 cannot be prioritised by value.
- **Recommendation:** state-manager appends one row per subagent dispatch (agent, phase, tokens in/out, wall seconds, verdict) to `cycles/<cycle>/dispatch-ledger.csv`; session-review reads it. Include uncounted rehearsals. Impact: enables cost-per-finding and cost-per-clean-pass trend (dimension 8) from cycle-015 on.
- **Affected files:** vsdd-factory state-manager agent, session-review skill; new `cycles/<cycle>/dispatch-ledger.csv` and `.factory/cost-summary.md`.
- **Risk:** token counts may not be exposed to the orchestrator in every harness; fall back to wall seconds and dispatch counts.

### Proposal 10: F7 deterministic pre-flight, then targeted re-verification of bookkeeping fixes
- **Category:** gate (engine)
- **Priority:** MEDIUM
- **Evidence:** four full LLM consistency-validator cycles, each re-running the entire test suite, for 11 bookkeeping findings (all LOW or wording).
- **Recommendation:** (a) before F7 cycle 1 run a deterministic bookkeeping pre-flight script: `check-state-health`, `compute-input-hash --check`, the four count guards, grep for stale-status phrases ("in flight", "in progress", `status: f5-*`), cycle-manifest/F6/F7 header currency, and open-PR claims (`gh pr list`). Fix findings before the validator runs. (b) If a cycle's only findings are dims 6/7 and the product tip is unchanged, the re-verification is the pre-flight plus a diff-scoped re-check of the touched dimension, not a fresh 7-dimension and full-suite run. Record the product tip SHA in each F7 cycle to make "unchanged" provable (the cycle-4 report already states `3fb4cf3b`). Impact: F7 collapses from 4 cycles to 1-2.
- **Affected files:** vsdd-factory phase-f7-delta-convergence skill, consistency-validator agent; new pre-flight script.
- **Risk:** weakening F7; mitigate by keeping a full re-run if any product SHA or spec lock count changed.

### Proposal 11: Merge-policy reality check (jr-side companion to PG#36) [lower priority]
- **Category:** gate (jr-repo)
- **Priority:** LOW (low-to-medium)
- **Evidence:** D-391 standing policy says pr-manager MAY merge once gates pass; the harness classifier denied every cycle-014 autonomous merge, so all 15 fix PRs and 3 stories needed a human merge. The policy text in STATE.md (a long Drift paragraph) describes behavior that did not occur.
- **Recommendation (human decision):** either (a) add a scoped permission rule (project `.claude/settings.json`, only the human can add it) letting the pr-manager run `gh pr merge --squash` on PRs targeting `develop` once required checks are green, or (b) rewrite D-391 to say "pr-manager prepares merge-ready PRs; the human merges", and delete the dead-letter exception text. Option (b) costs nothing and removes a misleading standing rule.
- **Affected files:** jr `STATE.md` (D-391 text, Blocking Issues operating note), optionally `.claude/settings.json`.
- **Risk:** (a) grants autonomy; the human has stated `strict: false` and merge-strategy sensitivities, so (b) is the safe default.

### Proposal 12: Unify the deferred guards into one story [lower priority]
- **Category:** workflow (jr-repo)
- **Priority:** LOW
- **Evidence:** the three jr-side guards the cycle repeatedly wished for are already deferred standing items (`BC-INDEX-H1-SYNC-GUARD` #906, `SPEC-QUALIFIER-PROPAGATION-GUARD`, `MUTANTS-EXCLUDE-RE-ANCHOR-GUARD`) plus PG#1/#2/#6/#8. D-406(b) noted each guard individually triggers the CI-gate review scope.
- **Recommendation:** schedule them as ONE "spec-guard consolidation" story at the next maintenance sweep (single script family, one CI review of the six ci-gate-scope files rather than four). Choose the baseline-vs-sweep for #906 before starting (240 baseline mismatches). Impact: one review of the CI-gate files instead of several.
- **Affected files:** `scripts/check-*.sh` family, `.github/workflows/ci.yml` spec-guard job, `tests/ci_gate_completeness.rs`, `tests/common/wf.rs`, `scripts/check-ci-gate.sh`, `scripts/lib/trusted-jq.sh`, `scripts/mutants-aggregate.sh`.
- **Risk:** a bundled guard story is larger to review; mitigate by shipping the guards in advisory mode first.

---

## Lessons Not Yet Codified in `lessons.md` (PENDING HUMAN REVIEW; not appended)

`lessons.md` L-001..L-006 are all F5-drift lessons. The following are NOT in it (some live only as STATE conventions or in process-gaps.md). They are recorded here only; appending L-007..L-015 to `lessons.md` awaits the human's 72h review.

- **L-007 — A review bar above the factory's own bar does not converge; it multiplies mechanisms.** F3: 33 passes, 0 clean, each new mechanism (D-386 bind-by-reference, D-387 line-span coverage, D-388, O/N/U labels) created fresh drift surface until D-389 returned to factory rules. Before adopting a stricter bar, compare against VSDD.md and the prior cycles' review recommendation (cycle-001 CITATION-GUARDS: default STANDARD, escalate only for meta stories). Source: D-385..D-389, process-gaps #13/#27/#31. (Proposed `[codified]` via D-389; add the pointer.)
- **L-008 — Do not host a pre-existing cross-cutting finding inside a bug-fix cycle without a delta ceiling.** SEC-001 (found at the F4 gate, not introduced by the stories) widened F5 from the 19-file F4 delta to ~25 files / ~7.5k lines and drove 15 fix PRs. Classify INTRODUCED vs PRE-EXISTING, and record a size ceiling if the human opts in (see Proposal 1).
- **L-009 — Past the first few passes, defects are claim-vs-reality, not code.** No code defect after Pass 4; passes 5-14 were documentation. The reviewer lens that finds them is "which sentence is false?"; an authoring-side mitigation (fewer, shorter, pointer-based sentences) beats reviewer effort (Proposals 4, 5).
- **L-010 — Partial Edits to a self-describing state file leave stale position labels.** STATE.md has a convention (F7C4-001 rewrite discipline) but it is not a lesson: frontmatter, Pipeline Status, Current Phase Steps, Blocking Issues, Convergence Status, Session Resume Checkpoint and the size-budget comment must move together in one full Write. F7C2-001/002/004 and F7C4-001 are the evidence.
- **L-011 — Orchestrator-supplied numbers are claims.** F7C3-001 (wrong drift counts and hashes) and process-gap #39's unexecuted literal show a verbatim-restated number is treated as verified. Label every supplied fact VERIFIED (with command) or UNVERIFIED (Proposal 7).
- **L-012 — Closure artifacts feed their own validators.** Creating the F7 report, updating the cycle manifest and rewriting STATE each create new description-vs-position claims; four F7 cycles reached a fixed point only when the last STATE rewrite described the final position. Do the position rewrite once, last, after a deterministic pre-flight (Proposal 10).
- **L-013 — A doc-only fix still costs a full PR lifecycle unless a lane says otherwise.** 5 of 15 PRs (Proposal 3). Batch per pass and verify "doc-only" mechanically.
- **L-014 — Uncounted work needs accounting.** Rehearsals (5), per-story Step 4.5 loops and F7 re-runs were uncounted and uncosted, so the true spend is unknowable and the next cycle cannot budget (Proposals 2, 9).
- **L-015 — Process observation that worked: change the review order, not just the review count.** Rehearse off the record, then count. Consider making the same move for F3 (a cheap uncounted story rehearsal against the template-compliance and coverage checks before the first counted pass), since the same story-template drift classes recurred (PG#14, #16, #18-#24).

## Evidence Gaps and Self-Assessment

Read-only analysis from the listed artifacts only. Claims about root cause are inferences from the pass records, convergence report, and decisions log; no pass file's per-finding text was re-audited. Not assessable: cost, per-phase wall time, holdout satisfaction for this cycle, per-story PR review rounds, holdout-evaluator isolation, and most registry-policy checks in the Governance Policy Audit. The session-reviewer's own cost is not recorded.

---

## Metrics for Next Run

To validate the proposals if adopted, measure in cycle-015:
- Adversarial passes per story point per phase (F3, F5), against the F1-declared budget (Proposals 2, 9). Baseline this cycle: F3 33 passes and F5 14 counted passes for 16 points.
- Fraction of fix PRs that are doc-only, and PR count per F5 pass-cycle (Proposal 3). Baseline: 5 of 15.
- Number of F5 findings classified `PRE-EXISTING` vs `INTRODUCED-BY-DELTA`, and the F4-to-F5 delta size in files and lines (Proposal 1). Baseline: 19 files at F4, ~25 files / ~7.5k lines at F5.
- Number of F7 cycles to converge and the share of F7 findings that are stale-label or count-propagation class (Proposals 6, 10). Baseline: 4 cycles; 3 of 4 cycles' findings stale-label class.
- Claim-vs-reality findings per counted F5 pass after Pass 4 (Proposals 4, 5). Baseline: passes 5-14 all doc/spec drift.
- Dispatch ledger rows per phase and total cost, once recorded (Proposal 9).
- Whether any `FUEL_EXHAUSTED` skip-log entries recur after file-size reduction (Proposal 8). Baseline: 2 Skip Log rows (v5.47, v5.51).
- Add this cycle's rows to `.factory/session-reviews/benchmarks.yaml` and `pattern-database.yaml` (bootstrap note, dimension 8).
