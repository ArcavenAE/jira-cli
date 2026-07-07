---
document_type: session-review
level: ops
version: "1.0"
status: complete
producer: session-reviewer
timestamp: 2026-07-07T00:00:00Z
cycle: "cycle-001"
bundle: CITATION-GUARDS
stories: [S-MUTANTS-SCOPE-GUARDS-1, S-BC-CITATION-GUARD-1]
inputs: [STATE.md, convergence-trajectory.md, lessons.md, research/story-b-*.md]
---

# CITATION-GUARDS Session Review (2026-07-02 – 2026-07-07)

**Stories delivered:** Story A (#101 S-MUTANTS-SCOPE-GUARDS-1, PR #572) + Story B (#102 S-BC-CITATION-GUARD-1, PR #592).  
**Guard family closed:** BC-X.13.001..003 (CLAUDE.md citations, Story A) + BC-X.13.004..006 (BC-body Trace/Source citations, Story B). 309 citations enforced in CI.

---

## 1. F3 Convergence Criterion Comparison (Priority Analysis)

### Observed data

| Loop | Story | Criterion | Passes | Fix rounds | Clean window |
|------|-------|-----------|--------|------------|--------------|
| Story A F3 | S-MUTANTS-SCOPE-GUARDS-1 | DEC-151 STRICT (VA lens streak-resetting) | 44 | 47 | 14 |
| Story A F4 | same | BC-5.39.001 per-story | 9 | 5 | 7/8/9 |
| Story B F3 | S-BC-CITATION-GUARD-1 | DEC-153 STANDARD (VA = LOW-INFO, non-resetting) | 15 | 9 | 13/14/15 |
| Story B F4 | same | BC-5.39.001 per-story | 4 | 2 | 2/3/4 |

The strict criterion generated **3× more F3 passes** for comparable story complexity. Both stories converged successfully.

### Did STANDARD leak anything STRICT would have caught?

The single F4 finding under STANDARD (Story B pass 1 F-01) was an **adversary factual error** — the claim that 4 of 5 `.snap` path citations were nonexistent was empirically refuted by the orchestrator in 30 seconds. The resolution was net-positive (two-tier shape guard EC-CITE-060 added .snap citations to file-existence tier). This is not a defect the strict criterion would have prevented; it is an adversary verification failure that the orchestrator's empirical-check discipline resolved.

Story A F3 STRICT did catch genuine late-cycle value: a Fixture H fixture-discipline gap at notional pass 30 of the DEC-151 run (total pass ~52) that would have been F4-breaking. However, this appeared well after the marginal-value inflection point. The draw-variance analysis in convergence-trajectory.md §Story A F3 notes that Option B (one non-meta pass after ~p29) would likely have converged the window 3 passes earlier — the strict run spent roughly 15 extra passes on meta-level verification-adequacy cycling after the substantive defect population was exhausted.

### Marginal value curve

Based on this cycle's data, the marginal finding rate per pass drops to near-zero after ~3 consecutive near-clean passes. For both stories:
- Passes 1–5: most CRIT/HIGH findings (high marginal value).
- Passes 6–12: MED finding tail, mostly fixture-mechanics and registration-surface drift (medium marginal value).
- Passes 13+: residual LOW and NITPICK, occasional true-positive regression from earlier fixes (low marginal value, high draw variance).

The verification-adequacy (VA) lens is inherently recursive on guard-spec stories: it generates findings about whether the spec adequately specifies how to verify the guard, which is the spec's own subject matter. This creates unbounded meta-level production. On non-guard-spec stories it behaves normally.

### Criterion Recommendation

**Default = STANDARD:** 3 consecutive diverse-lens clean passes; VA-lens observations classified as LOW-informational and non-streak-resetting. Supported by Story B outcome (no leaked defects in F4; 3× cost reduction).

**Escalate to STRICT when:**
1. The story is explicitly "meta" (a spec about specs, a guard about guards) **AND**
2. The PO or human explicitly opts in to bear the extra pass cost as a quality signal.

**Owner artifact (engine-side):** Update ADVERSARY-META-LENS-REGRESS drift item to CLOSED with this recommendation; add the default/escalation rule to the adversary-review skill template (`vsdd-factory:adversarial-review`). Human must ratify this as a governance decision.

---

## 2. Defect-Class Analysis Across All Four Loops

### Class distribution by severity

| Class | Where caught | Severity | Notes |
|-------|-------------|----------|-------|
| Spec-internal contradiction (jointly-unsatisfiable constraints) | Story B F3 pass 2 | CRIT | DEC-154: §-form strip + CamelCase branch couldn't coexist under old grammar; grammar extension required mid-loop research adjudication |
| Count-pin off-by-one | Story B F3 pass 4 | CRIT | BC-CITE-001 pin=3 should be 4; classic count-pin class |
| Token-pipeline single-pass → two-pass extractor | Story B F3 passes 2-3 | CRIT/HIGH | Single-pass regex silently dropped §-form and comma-space line-ref tokens (~11 tokens lost) |
| Registration-surface drift | Story B F3 passes 10-12 | MED × 3 | BC-INDEX/CANONICAL-COUNTS/STORY-INDEX counts not updated; 3 separate fix rounds for same class |
| Fixture H fixtures_run discipline | Story A F3 p52 | HIGH (F4-breaking) | Caught only under strict criterion at p52; would have broken F4 delivery |
| Engine-BC leakage into product source | Story A F4 pass 5 | MED | Stub-architect injected engine-internal BC-5.38.001 rustdoc reference at 5 sites |
| Adversary factual-claim error (.snap) | Story B F4 pass 1 | MED (REFUTED) | Adversary claimed .snap paths nonexistent; empirically refuted; net-positive resolution |
| PR-number mis-attribution | Story A F3 pass 6 | MED | #570-vs-#568 in policy-doc inline comment |
| Fixture-mechanics gaps | Both stories F3 | MED | Fixture kill-trace gaps, branch (d) anchor missing, strip-from-first-( subsumes bare `()` |

**F-01 implications for spec-only convergence claims:** Story B's 15-pass-converged spec still shipped a 3-way consistency issue (class-15 token pipeline) that was resolved DURING the F3 loop. However, the more important note is that Story B F4 pass 1's "finding" was adversary-side error, not a spec gap the convergence missed. The genuine risk is the F4-breaking gap from Story A (Fixture H at p52) — a spec-only convergence claim should NOT be treated as implementation-adequate without the per-story F4 adversarial gate.

**Lens effectiveness:** Coherence/ground-truth lenses caught spec-internal contradictions (DEC-154); fixture-mechanics lens caught implementation-breaking gaps (Fixture H); registration-surface lens caught count drift repeatedly. VA lens added value on Story A (p52 catch) but at high cost.

---

## 3. Process Incidents

| Incident | Story | Resolution | Lesson |
|----------|-------|------------|--------|
| story-writer ×2 API stalls (F2 authoring) | Story B | Manual retries; 3rd attempt succeeded | API-stall retry not automated; orchestrator must be patient |
| Adversary factual-claim refutation (.snap existence) | Story B F4 p1 | Orchestrator ran `find src/cli/auth/tests/snapshots/` — 30-second empirical check refuted the claim; net-positive two-tier spec amendment | ORCHESTRATOR-EMPIRICAL-REFUTATION codified (DEC-156) |
| Permission-classifier block on PR comment | Story B F4 | Surfaced to human; manual comment posted | Classifier boundary between review content and code-modification content needs clarification in agent prompts |
| Registration-surface drift: 3 consecutive fix rounds for same class | Story B F3 p10-12 | 3 separate passes needed to close all surfaces | REGISTRATION-SURFACE-SWEEP codified (DEC-156): grep all carrier files on FIRST count-staleness find |

---

## 4. Cost / Efficiency

No `.factory/cost-summary.md` exists (PERF-COST-TRACKING drift item OPEN). Token costs are untracked; this analysis uses pass counts as the efficiency proxy.

**Pass cost distribution:**

| Phase | Passes | Fraction | Assessment |
|-------|--------|----------|------------|
| Story A F3 DEC-151 strict | 44 | 58% | Dominant cost center; ~15 passes attributable to VA-lens meta-cycling beyond marginal-value cliff |
| Story A F4 per-story | 9 | 12% | Normal; caught engine-BC leakage and 4 MED findings |
| Story B F3 standard | 15 | 20% | Well-calibrated; 2 CRITs caught early (passes 2-4) |
| Story B F4 per-story | 4 | 5% | Fast; adversary factual error refuted, net-positive resolution |
| Research adjudications (×2) | ~2 | 3% | Both were essential (FLOOR calibration + grammar contradiction) |
| **Total** | **~74** | | |

**Three highest-leverage changes for the next cycle:**

1. **[engine-side] Adopt STANDARD as default F3 criterion** (ADVERSARY-META-LENS-REGRESS resolution). Estimated 15-20 pass reduction per guard-spec story. Artifact: adversarial-review skill template update. Owner: human governance ratification required.

2. **[engine-side] Add REGISTRATION-SURFACE-SWEEP to story-writer spec template.** When a story's counts change, the story-writer fix-round must run a corpus-wide grep for the old value across STATE.md, BC-INDEX.md, CANONICAL-COUNTS.md, ARCH-INDEX.md, and any recently-touched prd file before closing. Estimated 2-3 fix rounds saved per spec-heavy story. Artifact: create-story skill template. Owner: engine-side (no human governance needed).

3. **[project-side] BC-INDEX-9TH-SURFACE guard story.** The BC-INDEX.md coverage statistics section is not covered by `check-bc-cumulative-counts.sh`. This was the root structural gap enabling the 3-pass registration-surface leak class. Estimated benefit: prevents the entire class mechanically. Artifact: new story candidate on next-backlog. Owner: human backlog prioritization.

---

## 5. Recommendations (numbered, tagged)

1. **[engine-side] Ratify STANDARD as the default F3 convergence criterion** (ADVERSARY-META-LENS-REGRESS disposition). Three consecutive clean diverse-lens passes; VA observations = LOW non-resetting; STRICT opt-in only with PO sign-off on meta/guard-spec stories. _Artifact: adversarial-review + conformance-check skill templates. Owner: human governance decision._

2. **[engine-side] Add REGISTRATION-SURFACE-SWEEP procedure to story-writer fix-round discipline.** On any finding that stale a count, the mandatory next action is corpus-wide grep before declaring round closed. _Artifact: create-story + conformance-check skill templates. Owner: engine update (no human gate required)._

3. **[project-side] BC-INDEX-9TH-SURFACE guard — next story candidate.** Extend `check-bc-cumulative-counts.sh` to cover BC-INDEX.md coverage statistics section as a 9th validation surface. Directly prevents the dominant leak class from Story B F3. _Artifact: drift item BC-INDEX-9TH-SURFACE → story candidate. Owner: human backlog gate._

4. **[engine-side] ORCHESTRATOR-EMPIRICAL-REFUTATION procedure.** Before routing any adversary factual claim (file existence, function defined, test absent) as justification for a spec change, orchestrator must run a 30-second empirical check. _Artifact: orchestrator-per-story-delivery skill template. Owner: engine update (codified DEC-156; template update pending)._

5. **[project-side] Activate cost tracking** (PERF-COST-TRACKING drift item). Initialize `.factory/cost-summary.md` with per-cycle token/cost rows. This review is blind to actual token cost; the efficiency analysis relies on pass-count proxies only. _Artifact: cost-summary.md bootstrap. Owner: human authorization or next maintenance sweep._

---

## 6. Wall Integrity / Quality Signals / Patterns

**Wall integrity:** No evidence of information leakage across the F3/F4 asymmetry wall. Story B's F4 adversary did not reference F3 findings in its reasoning; the .snap factual-claim error shows the adversary was working from first principles (not borrowing from spec context).

**Quality signals:** Both PRs merged with CI 15/15 green. Security review returned 2 LOW advisories on Story B (SEC-001/SEC-002 — ERE-injection and leading-dash guard gaps in bash script), both deferred as follow-up story candidates. The self-test fixture mechanism (10/10 self-test PASS post-merge) provides strong regression coverage for the guard's extraction logic.

**Patterns vs prior cycles:** The SWEEP-WHOLE-TOUCHED-FILE lesson from DEC-149 (CITATION-DEBT-PRODUCT-FILES) recurred as REGISTRATION-SURFACE-SWEEP in Story B — same root cause, different surface. Three recurrences of the count-propagation class across the cycle (DEC-148, DEC-149, DEC-155) indicate this is a systemic pattern warranting the mechanical guard in Recommendation 3.

---

_Review complete. Evidence base: STATE.md (DEC-150..156), convergence-trajectory.md §Story A F3/F4 + §Story B F3/F4, lessons.md (ORCHESTRATOR-EMPIRICAL-REFUTATION + REGISTRATION-SURFACE-SWEEP), research/story-b-open-questions-2026-07-05.md, research/story-b-grammar-adjudication-2026-07-06.md._
