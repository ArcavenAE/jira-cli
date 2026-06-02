# Research: Behavioral-Contract Anchoring for the JSM E2E Queue Tests

**Date:** 2026-06-02
**Type:** general (methodology / requirements-traceability validation)
**Decision under review:** How should live E2E tests for `queue list` / `queue view` (a test-only, zero-production-change story) trace to behavioral contracts, given that those commands shipped in an earlier cycle with NO behavioral contract, and the acceptance criteria currently mis-anchor to a `requesttype` contract (BC-X.12.001)?

---

## TL;DR Recommendation

**Adopt a refined Option B (tracked-deferral) — do NOT keep Option C, and do NOT bundle Option A into the test-only story.**

Concretely:
1. **Drop the wrong anchor immediately** (BC-X.12.001 → queue tests). Reusing a `requesttype` contract to "cover" `queue` behavior is a recognized traceability anti-pattern (false/over-claimed coverage, "traceability pollution"). This is the one unambiguous "must do now."
2. **Mark the queue E2E tests as tracing to no contract** — explicitly, in the test file and acceptance criteria — i.e. an *explicitly-logged* orphan, not a silent one.
3. **Open a TRACKED follow-up** to author "document-as-is" BCs for the queue command family in a dedicated spec cycle (the same way `requesttype` got contracts when it was added). Record it where your other deferrals live (CLAUDE.md "Known Size Deviations"/NFR-style deferral list + a GitHub issue).

This keeps the test-only change minimal (single-responsibility / minimal-diff), removes the false-coverage defect now, and converts a hidden traceability gap into a *visible, tracked* one — which the literature treats as the acceptable interim state.

**Confidence: High** on rejecting Option C and on "fix the mis-anchor now." **Medium-High** on "B over A for THIS story" — it rests on a software-engineering change-management principle (separation of concerns / minimal-diff) that is practitioner-grade consensus, not a hard standards mandate. See Caveats.

---

## The Three Options Mapped to the Evidence

| Option | What it is | Verdict | Why |
|--------|-----------|---------|-----|
| **A** | Author document-as-is BCs for queue NOW, inside the test-only story | Defensible but mis-scoped here | Correct *destination*, wrong *vehicle*. Bundling spec-corpus authoring + cumulative-count bookkeeping into a deliberately test-only change violates separation-of-concerns / minimal-diff. Brownfield guidance favors incremental "as-is" specs *scoped to the change being made* — but here the change is tests, and the spec work is a separable concern that warrants its own review. |
| **B** | Drop wrong anchor; mark tests as un-contracted; tracked deferral to author BCs later | **Recommended (refined)** | Removes the false-coverage defect now; an *explicitly-logged* orphan + tracked remediation is the accepted interim state in non-safety-critical contexts; preserves the minimal-diff intent of the story. |
| **C** | Keep the `requesttype` anchor for queue tests | **Reject** | Semantically-invalid traceability link = anti-pattern. Creates "false coverage" / "traceability pollution"; standards (DO-178C, ISO 26262, CMMI REQM) require link *correctness*, not just link *existence*. The worst of the three because it actively hides the gap. |

---

## Findings by Research Question

### Q1 — Orphan test (real behavior, no contract): author a contract, or log a tracked gap?

The literature splits by **criticality**, and that split is the key to your decision:

- **Safety-critical standards (DO-178C, ISO 26262, CMMI REQM.SP 1.4)** treat an orphan test as a *defect requiring remediation* — verification evidence must trace backward to a documented requirement; permanent gaps are non-compliant. DO-178C mandates "requirements-based testing" (every test verifies a documented requirement); ISO 26262 mandates "complete, consistent, and demonstrable" bidirectional traceability; CMMI REQM.SP 1.4 requires bidirectional traceability so every work product traces to a valid source.
- **General (non-safety-critical) software practice** (BDD, specification-by-example, technical-debt literature) treats an orphan test as **manageable "specification debt"**: acceptable *as an explicitly tracked, temporary state*, prioritized by business impact — **not** acceptable as a silent permanent condition. NASA's handbook frames stray "orphan" artifacts (design elements with no source requirement) as discoverable items to *investigate and remediate*, not ignore.

**Net for Q1:** An orphan test is acceptable **only if explicitly logged with a tracked path to remediation.** A *silent* orphan is a defect. Your project is a developer CLI, not DO-178C/ISO-26262 — so the tracked-deferral state (Option B) is legitimately available to you; it would not be in an avionics/automotive certification context.

### Q2 — Reusing an unrelated requirement ID to "cover" a different behavior (Option C)?

Unambiguous across every source class: **this is a traceability anti-pattern.** Named effects in the literature:

- **"False coverage" / "over-claimed coverage"** — traceability metrics report the behavior as verified when it is not genuinely tied to any contract describing it.
- **"Traceability pollution"** — accumulating semantically-invalid links degrades the whole RTM's trustworthiness until teams stop believing it.
- Standards check **link correctness, not just existence**: DO-178C certification reviewers examine whether a test actually verifies the *associated* requirement ("verification theater" is explicitly called out); ISO 26262 requires links reflect *actual* validation relationships; CMMI requires links support *meaningful* completeness verification.
- "Atomic traceability" / single-behavior scenarios (BDD, specification-by-example) reinforce that a link must represent one genuine requirement↔verification relationship.

**Net for Q2:** Option C is the *most harmful* of the three — worse than a transparent gap — because it masks the deficiency. Reject it outright.

### Q3 — Brownfield "as-is" specs: incremental-when-touched vs. batch? And scope discipline?

Two findings, both relevant:

1. **Incremental "as-is" specification is the preferred pattern over comprehensive batch reverse-specification** for legacy/brownfield code. Comprehensive upfront reverse-spec "probably may not be the best use of time"; the recommended move is characterization tests + specs **scoped to the localized area being changed**. This *seems* to argue for Option A ("a test touches queue → write the queue spec now").

2. **But the same brownfield guidance is bounded by separation-of-concerns / minimal-diff.** The literature explicitly warns against *expanding the scope of an unrelated change* to do specification work: "Specification work for unrelated functionality should be handled in separate changes, with clear rationale and review, rather than being bundled." Spec-kit-style flows scope the spec to *the change being made* and get it independently reviewed.

The tension resolves on **what the change actually is.** In this story the change is *tests*, not a modification of queue *behavior*. The queue commands are not being touched; you are adding verification around already-shipped behavior. The "incremental when touched" pattern is strongest when you are *modifying the behavior itself* and need a characterization safety net. Authoring full document-as-is BCs (with cumulative-count bookkeeping across BC-INDEX / CANONICAL-COUNTS, per this repo's DRIFT-001/002 machinery) is a *separable concern* that deserves its own reviewed change — exactly the scope-creep the guidance warns against.

**Net for Q3:** Brownfield practice supports document-as-is BCs *as the eventual destination* (favoring incremental over batch), but the scope-discipline principle says do that authoring in its **own** change, not stapled onto a test-only story.

### Q4 — Net: A or B for THIS situation (minimal test-only change surfacing a pre-existing gap)?

**B (refined), for this specific change.** Decision chain:

- C is excluded (Q2).
- Between A and B, the deciding principle is **separation of concerns / minimal-diff in change management**, combined with the fact that **the requirement gap is pre-existing, not introduced by this story.** The test-only story didn't create the gap; it merely *surfaced* it. The disciplined response to a surfaced-but-pre-existing gap is: remove the incorrect artifact (the mis-anchor) now, make the gap *visible and tracked*, and remediate the root cause (missing BCs) in a properly-scoped follow-up.
- This also matches how the repo already handles pre-existing gaps: documented NFR-style deferrals (`DOCUMENT-AS-IS`, "Known Size Deviations") with a tracked path — the project's own established pattern is itself a precedent for Option B.

A is not *wrong* (its destination is correct); it's just the wrong *time/place*. If your team would rather pay the spec-authoring cost immediately and your change-review culture tolerates a test-story that also edits the spec corpus, A is defensible — but B is the better fit for a story explicitly framed as minimal/test-only.

---

## Key Deciding Principles (the "why")

1. **Link correctness > link existence.** A semantically-wrong trace (C) is worse than an honest absence — it manufactures false coverage. (DO-178C, ISO 26262, CMMI, BDD all converge here.)
2. **Orphan tests are acceptable only when explicitly logged + tracked.** Silent orphan = defect; tracked orphan = managed specification debt (legitimate outside safety-critical certification).
3. **Separation of concerns / minimal-diff.** Don't expand an unrelated (test-only) change to absorb separable spec-authoring work; give the spec work its own reviewed change.
4. **Surfaced ≠ caused.** A minimal change that *reveals* a pre-existing gap is not obligated to *close* it inline; it is obligated not to *hide* it (which is why C and silent-skip both fail).

---

## Recommended Concrete Actions

1. **Now (in this story):** delete the BC-X.12.001 anchor from the queue acceptance criteria/tests. Replace with an explicit "traces to: none (un-contracted behavior — see deferral DEFER-QUEUE-BC)" note in the test file and the spec.
2. **Now:** add a tracked deferral entry (mirroring existing `DOCUMENT-AS-IS` / NFR-O-style entries) and open a GitHub issue: "Author document-as-is behavioral contracts for `queue list` / `queue view` (parity with `requesttype` BCs)."
3. **Later (dedicated cycle):** author the queue BCs document-as-is, run `scripts/check-bc-cumulative-counts.sh` + `scripts/check-spec-counts.sh`, then re-anchor the queue E2E tests to the new BCs and close the deferral. This is where Option A's work belongs.

---

## Caveats / Confidence Boundaries

- **Criticality assumption.** The "tracked orphan is acceptable" conclusion depends on `jr` being non-safety-critical. If you ever treat the BC corpus as a *certification* artifact (you don't today), the calculus flips toward Option A / mandatory remediation-before-merge.
- **A vs. B is a judgment call, not a standards mandate.** No standard says "thou shalt not author specs inside a test PR." The preference for B rests on separation-of-concerns/minimal-diff, which is strong practitioner consensus (spec-kit, agile change-management) but not a hard normative rule. A team that values immediate gap-closure over diff minimalism could rationally pick A. The evidence makes C indefensible and makes *silent* skipping indefensible; it makes A-vs-B a *scoping* preference.
- **Don't let the deferral rot.** The literature's acceptance of tracked orphans is explicitly *temporary*. The recommendation only holds if the follow-up is real and bounded — an indefinitely-deferred "tracked" gap eventually becomes the silent gap the literature condemns.
- **Source mix.** Q1/Q2 are backed by formal standards (29148, DO-178C, ISO 26262, CMMI) + practitioner sources. Q3/Q4 lean more on practitioner sources (spec-kit walkthrough, BDD/SbE, brownfield talks) because standards are largely silent on commit-scoping for spec work. Flagged accordingly above.

---

## Top Citations

- ISO/IEC/IEEE 29148:2018 (requirements engineering; traceability definition, TBD/TBR) — https://drkasbokar.com/wp-content/uploads/2024/09/29148-2018-ISOIECIEEE.pdf
- DO-178C requirements-based testing & traceability (Parasoft) — https://www.parasoft.com/learning-center/do-178c/requirements-traceability/
- Automating requirements-based testing for DO-178C (QA Systems) — https://www.qa-systems.com/wp-content/uploads/2020/12/automating-requirements-based-testing-for-do-178c.pdf
- DO-178C common gaps to close (AFuzion) — https://afuzion.com/178c-common-gaps-close/
- ISO 26262 testing best practices / bidirectional traceability (QA Systems) — https://www.qa-systems.com/blog/iso-26262-testing-best-practices/
- Maintaining ISO 26262 traceability across suppliers (SodiusWillert) — https://www.sodiuswillert.com/en/blog/maintaining-iso-26262-traceability-across-automotive-suppliers
- CMMI REQM.SP 1.4 — maintain bidirectional traceability (wibas) — https://www.wibas.com/cmmi/reqmsp-14-maintain-bidirectional-traceability-of-requirements
- Bidirectional traceability (Jama Software) — https://www.jamasoftware.com/requirements-management-guide/requirements-traceability/bidirectional-traceability/
- NASA SWE handbook — "orphan" design elements with no source requirement — https://swehb.nasa.gov/plugins/viewsource/viewpagesrc.action?pageId=215777306
- Specification by Example, 10 years on (Gojko Adzic) — https://gojko.net/2020/03/17/sbe-10-years.html
- Better requirements by harnessing examples (Cucumber/BDD) — https://cucumber.io/blog/bdd/better-requirements-by-harnessing-the-power-of-exa/
- Introducing BDD (Dan North) — https://dannorth.net/blog/introducing-bdd/
- BDD 101: Writing good Gherkin (single-behavior scenarios) — https://automationpanda.com/2017/01/30/bdd-101-writing-good-gherkin/
- Spec-kit walkthrough (incremental/just-in-time spec, scope discipline) — https://matsen.fhcrc.org/general/2026/02/10/spec-kit-walkthrough.html
- Technical debt (Atlassian) — https://www.atlassian.com/agile/software-development/technical-debt
- How to analyse test coverage / coverage gaps ("false coverage") — https://aqua-cloud.io/how-to-analyse-test-coverage/
- Requirements traceability matrix (6sigma.us) — https://www.6sigma.us/six-sigma-in-focus/requirements-traceability-matrix-rtm/

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source synthesis (high reasoning_effort) across ISO/IEC/IEEE 29148, DO-178C, ISO 26262, CMMI, BDD/specification-by-example, and brownfield reverse-spec practice — all four research questions in one investigation (~28 sources). |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 1 area | Mapping the (externally-sourced) principles onto this repo's specific BC-corpus mechanics (DRIFT-001/002 count checks, NFR `DOCUMENT-AS-IS` deferral pattern) — flagged explicitly; the principles are sourced, the repo-fit is judgment. |

**Total MCP tool calls:** 1 (single high-effort `perplexity_research` covering ~28 distinct sources)
**Training data reliance:** low — all four research questions answered from web-grounded sources with citations; training data used only to map findings onto this repo's existing conventions.
