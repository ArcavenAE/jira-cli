---
document_type: engine-contribution-draft
target_repo: dark-factory (upstream — exact location TBD by maintainer)
sources:
  - .factory/research/drift-items-365-design-validation.md
related_drift_items: [PG-365-2, DRIFT-006]
related_cycle: 3-feature-search-issue-keys-dedupe-365
date: 2026-05-15
status: ready-for-upstream
---

# Engine Contribution Draft — DRIFT-006 + PG-365-2

Upstream-contribution proposals extracted from validated research in
`/Users/zious/Documents/GITHUB/jira-cli/.factory/research/drift-items-365-design-validation.md`.
These items require changes to the dark-factory engine, not to jira-cli.

Two self-contained proposals follow: Part A addresses DRIFT-006 (F5 multi-axis review
missed O(N²) complexity); Part B addresses PG-365-2 (F1d adversary citation-verification
scope). Part C provides a combined upstream PR strategy.

---

## Part A — DRIFT-006: F5 multi-axis review missed O(N²) complexity

### A.0 Problem statement

The F5 review panel (adversary, code-reviewer, security-reviewer) completed with all
reviewers passing. A subsequent Copilot review then caught an O(N²/page_size) bug: a
`Vec::retain` closure was rebuilding a `HashSet` on every retained element, producing
O(N*M) work where an O(N+M) pre-build-then-retain pattern was available. The gap is
structural: algorithmic complexity review is not an explicit, named axis in any of the
three reviewer prompts. The Google Engineering Practices guide lists "Complexity" as a
section but defines it as "is the code more complex than it should be?" with no
discussion of Big-O notation, asymptotic analysis, or per-iteration allocation. Industry
practice treats performance as an implicit sub-concern of "design" rather than a formal
checklist axis — meaning it falls through the cracks precisely when a change looks
locally simple (a retain + a set) but is globally quadratic. No existing clippy lint
detects "rebuild a HashSet inside a retain/filter closure" as an anti-pattern; clippy
operates on syntactic templates, not algorithmic complexity classes. The fix is additive:
four explicit perf-checklist items added to the existing F5 reviewer prompts, plus
verification that `cargo clippy -W clippy::perf` runs in CI.

---

### A.1 Add 4-item perf-checklist to F5 adversary skill prompt

**Where to insert:** inside the adversary's review checklist, under a new heading
`#### Performance / Complexity axis` (or appended to an existing axis section if one
exists).

**Exact text to insert (copy-paste-ready):**

```markdown
#### Performance / Complexity axis

For every changed loop, closure, or iteration construct, check all four items:

- [ ] **Loop / closure allocation:** Are `HashSet`, `HashMap`, `Vec`, or other collections
      created *inside* a loop body, `retain` closure, `filter`, `map`, `for_each`, or
      nested iteration? If yes, ask: can these be constructed once outside the loop and
      reused per element?
- [ ] **Big-O delta:** Compare the complexity class of each changed function before vs.
      after. Could the change make behavior O(N²), O(N*M), or O(page_size * N) where it
      was previously O(N) or O(N log N)? If yes, require refactor or an explicit
      complexity justification comment in the code.
- [ ] **Membership-test optimization:** If the code calls `contains` / `find` / `position`
      inside an iteration over the same or another collection, check whether a `HashSet`
      or `HashMap` can be pre-built once before the loop instead of performing O(N) inner
      work per element.
- [ ] **Retain / filter hot-path focus:** Treat `retain` and `filter` closures as hot
      paths — flag any heavy-setup work (I/O, allocations, large clones, nested
      iterations) executed once per element.
```

---

### A.2 Same 4-item checklist into code-reviewer skill prompt

**Where to insert:** inside the code-reviewer's review checklist, under the same heading
`#### Performance / Complexity axis`. The text is identical to A.1 — symmetric
instructions to both reviewer roles.

**Exact text to insert (copy-paste-ready):**

```markdown
#### Performance / Complexity axis

For every changed loop, closure, or iteration construct, check all four items:

- [ ] **Loop / closure allocation:** Are `HashSet`, `HashMap`, `Vec`, or other collections
      created *inside* a loop body, `retain` closure, `filter`, `map`, `for_each`, or
      nested iteration? If yes, ask: can these be constructed once outside the loop and
      reused per element?
- [ ] **Big-O delta:** Compare the complexity class of each changed function before vs.
      after. Could the change make behavior O(N²), O(N*M), or O(page_size * N) where it
      was previously O(N) or O(N log N)? If yes, require refactor or an explicit
      complexity justification comment in the code.
- [ ] **Membership-test optimization:** If the code calls `contains` / `find` / `position`
      inside an iteration over the same or another collection, check whether a `HashSet`
      or `HashMap` can be pre-built once before the loop instead of performing O(N) inner
      work per element.
- [ ] **Retain / filter hot-path focus:** Treat `retain` and `filter` closures as hot
      paths — flag any heavy-setup work (I/O, allocations, large clones, nested
      iterations) executed once per element.
```

---

### A.3 CI clippy::perf gate verification

**Exact CLI line (copy-paste-ready):**

```bash
cargo clippy --all-targets --all-features -- -D warnings -W clippy::perf
```

**Notes for maintainer:**

- The `-D warnings` flag is already standard if the project follows a zero-warnings
  policy. Adding `-W clippy::perf` explicitly opts the entire `perf` lint group in.
- Active perf-group lints as of 2026-05 include: `needless_collect`, `manual_retain`,
  `set_contains_or_insert` (added Rust 1.83), `iter_overeager_cloned`, `redundant_clone`.
- No clippy lint currently detects "rebuild HashSet inside a retain closure" as a
  syntactic anti-pattern. The checklist items in A.1/A.2 are the only systematic
  defense for that specific class.
- When the checklist flags a concern (new nested loop, allocation in retain/filter,
  repeated membership tests), the PR author either refactors or adds a `criterion`
  micro-benchmark with results attached to the PR description.

---

### A.4 Files to modify in dark-factory upstream

These are candidate paths. The maintainer should search the upstream repo for their
actual locations — file names may differ.

- `skills/adversarial-review/SKILL.md` — most likely home for the F5 adversary prompt
- `skills/phase-f5-scoped-adversarial/SKILL.md` — alternative if F5 has its own skill
- `agents/code-reviewer.md` — code-reviewer role definition
- `docs/FACTORY.md` or `AGENTS.md` — mention perf-axis as a named axis in F5

---

### A.5 Acceptance criteria for the upstream PR

The change is complete when all of the following are true:

- [ ] The F5 adversary skill prompt contains all four perf-checklist items verbatim (or
      equivalent with same coverage: loop/closure allocation, Big-O delta,
      membership-test optimization, retain/filter hot-path focus).
- [ ] The F5 code-reviewer skill prompt contains the same four items.
- [ ] `FACTORY.md` or `AGENTS.md` names "Performance / Complexity" as an explicit axis
      in the F5 phase description (not implicit under "design").
- [ ] At least one example behavioral contract (BC) or adversarial-review example in the
      engine docs demonstrates the checklist catching an O(N²) or per-iteration
      allocation pattern — concretely illustrating what DRIFT-006 would have caught.

---

## Part B — PG-365-2: F1d adversary citation-verification scope

### B.0 Problem statement

The F1d adversary skill is read-only by design: it has no `WebFetch` or search tool
access. When a spec cites an externally-validated claim (e.g., "Perplexity confirmed
that itertools::unique() preserves order"), the adversary can verify that a citation
exists in the spec's evidence record — but it cannot independently verify that the
underlying external claim is true. The current pipeline has no codified contract for
this trust boundary. The gap is documentation, not tooling: multi-agent pipeline
literature (Meiklejohn's MAS verification patterns, CiteAudit, Azure groundedness
detection, PROV-AGENT, Anviren's CrewAI trust-boundary guide) uniformly recommends
that the adversarial reviewer treat the structured evidence produced by the research
agent as session-level ground truth and verify only that spec text is semantically
entailed by that evidence — not that the evidence is correct in the external world. If
the adversary is allowed (implicitly or by prompt ambiguity) to reject claims on
"counterintuitive" grounds without evidence-level justification, it conflates the
research role with the review role and re-opens the trust boundary the pipeline was
designed to close. The fix is three additive documentation changes: a structured
evidence block format, a named trust-boundaries doc, and a four-item checklist in the
PR template and adversary prompt.

---

### B.1 `External Evidence` block format for spec templates

**Where to insert:** in the spec template (likely `templates/spec-template.md`), add a
section `### External Evidence` with instructions and a filled example. The format
enables the F1d adversary to check claim-ID linkage and semantic entailment without
re-querying.

**Exact format to add to spec template (copy-paste-ready):**

```markdown
### External Evidence

<!--
For each external factual claim in this spec (API behavior, protocol guarantees,
complexity bounds, library semantics), add one entry below and tag the claim in
the spec body with [C#] referring to the Claim ID here.
-->

- Claim ID: `C1`
  - Statement: <one-sentence factual claim exactly as used in the spec body>
  - Source tool: <Perplexity (sonar-pro) | Context7 | WebFetch | WebSearch>
  - Query: "<exact query string sent to the tool>"
  - Evidence snapshot:
    > "<direct quote or close paraphrase from the tool's response>"
  - URL / permalink: <URL if provided by tool, or "N/A (tool did not return URL)">
  - Retrieved at: <ISO-8601 timestamp, e.g. 2026-05-15T14:00Z>
  - Epistemic status: Assumed-true-within-session
  - Confidence: <high (multi-source) | high (single-source) | provisional>
```

**Usage convention for spec authors:**

- Every external factual claim in the spec body must carry a `[C#]` inline tag.
- Example in spec body: "itertools::unique() preserves input order [C1]."
- The F1d adversary verifies: (1) every `[C#]` tag resolves to an Evidence entry,
  (2) spec text is semantically entailed by the evidence snapshot (no over-generalization),
  (3) no two entries contradict each other.
- The adversary does NOT verify that the claim is true in the external world — only
  that the spec text is faithfully derived from the provided evidence.

---

### B.2 Trust-boundaries doc

**Target path:** `agents/trust-boundaries.md` (new file in the engine repo).

**Full text of the file (copy-paste-ready):**

```markdown
# Trust Boundaries — Dark-Factory Pipeline

This document codifies the trust contracts between agents in the pipeline. It is
normative: skills and agents MUST comply with these contracts.

---

## Trust Boundary: External Research Evidence

### Roles

- **Research Agent** — has access to external tools: Perplexity, Context7, WebFetch,
  WebSearch. Sole agent permitted to query the external world.
- **Adversarial Review Agent (F1d)** — read-only: file read and code search only.
  No WebFetch, no Perplexity, no WebSearch.

### Contract

The Research Agent retrieves external evidence and emits structured `External Evidence`
blocks with provenance, evidence snapshots, and confidence labels. These blocks are the
sole external-evidence record for one pipeline run.

The F1d Adversarial Review Agent:

**MUST:**
- Treat every `External Evidence` entry with `Epistemic status: Assumed-true-within-session`
  as correct for the duration of one pipeline run.
- Verify that every external factual claim in the spec body carries a `[C#]` Claim ID.
- Verify that each `[C#]` resolves to an entry in the spec's `External Evidence` section.
- Verify that spec text is semantically entailed by the linked evidence snapshot — flag
  over-generalization (claim broader than evidence), missing caveats, or expanded domains
  not present in the snippet.
- Verify that no two evidence entries internally contradict each other.
- Flag cases where spec text intentionally diverges from evidence (conservative stance,
  version caveat) and verify the divergence is explicitly noted in the spec.

**MUST NOT:**
- Invent new sources or cite external references not present in the evidence record.
- Re-query external services (Perplexity, WebFetch, WebSearch) to verify or refute a claim.
- Reject a claim solely on counterintuitive or contrary-to-training-data grounds without
  an evidence-level justification (evidence-misalignment is the only grounds for rejection).

### Rationale

If the adversarial agent re-queries the external world, it re-opens the trust boundary
it was designed to close: the inner trusted layer becomes exposed to the same
prompt-injection, retrieval-poisoning, and provenance-attribution risks as the outer
research agent. Keeping the adversary read-only makes the threat surface smaller and
the audit trail cleaner.

### Implication for post-mortems

If a bug was propagated through this pipeline because Perplexity returned incorrect
information, the audit trail answers in seconds: "was the error in the evidence, or in
the spec's derivation from the evidence?" If the evidence snapshot is faithfully quoted
and the spec text matches it, the pipeline functioned correctly — the error originated
upstream in the external tool, not in the review process.

---

## Trust Boundary: Agent-to-Agent Handoffs

Any artifact passed from one phase to the next (spec, BC file, holdout scenario list)
is treated as ground truth by the receiving agent for that phase. The receiving agent
validates structure, format, and internal consistency — not re-derives the artifact
from first principles.

---

## Adding New Trust Boundaries

When adding a new agent or phase that introduces a new trust boundary, add a section
to this file in the same PR as the agent/phase change. The section must specify:
- Roles (which agents sit on each side)
- Contract (MUST / MUST NOT obligations for each role)
- Rationale (why this boundary exists)
- Implication for post-mortems (how to diagnose failures at this boundary)
```

---

### B.3 Evidence-linkage checklist for PR template and F1d adversary prompt

**Where to insert:**
1. In the project's PR template (likely `.github/pull_request_template.md`), append
   a new section.
2. In the F1d adversary skill prompt (`skills/phase-1d-adversarial-spec-review/SKILL.md`
   or equivalent), add the same checklist as part of the review instructions.

**Exact text for both locations (copy-paste-ready):**

```markdown
### External Evidence / Adversarial Review Checklist

- [ ] All external factual claims (API behavior, complexity guarantees, protocol
      semantics, library behavior) in the spec body carry a `[C#]` Claim ID tag.
- [ ] Each `[C#]` Claim ID resolves to an entry in the spec's `External Evidence`
      section — no dangling references, no missing entries.
- [ ] Spec text does not exceed evidence scope — no "always", "never", or domains
      broader than those present in the evidence snapshot; if spec language is more
      conservative than the evidence, the conservative stance is explicitly noted.
- [ ] Where spec text intentionally diverges from evidence (e.g., a version caveat,
      a conservative stance, a known conflict between sources), the divergence is
      explicitly noted in the spec body adjacent to the `[C#]` tag.
```

---

### B.4 Files to modify in dark-factory upstream

These are candidate paths. The maintainer should search the upstream repo for their
actual locations — file names may differ.

- `skills/phase-1d-adversarial-spec-review/SKILL.md` — F1d adversary prompt (add B.3
  checklist; add a "Trust contract" section referencing `agents/trust-boundaries.md`)
- `skills/research-agent/SKILL.md` or `agents/research-agent.md` — research agent role
  definition (add obligation to emit structured `External Evidence` blocks per B.1 format)
- `templates/spec-template.md` — add the `External Evidence` section from B.1
- `agents/trust-boundaries.md` — NEW file; full text provided in B.2

---

### B.5 Acceptance criteria for the upstream PR

The change is complete when all of the following are true:

- [ ] `agents/trust-boundaries.md` exists with the "External Research Evidence" trust
      boundary section codifying the F1d contract (assume-true-within-session,
      verify-alignment-only, never re-query externally).
- [ ] The spec template includes an `External Evidence` section with the structured
      format from B.1 (Claim ID, source tool, query, evidence snapshot, URL,
      retrieved-at, epistemic status, confidence).
- [ ] The F1d adversary skill prompt references the trust-boundaries doc and includes
      the four-item evidence-linkage checklist from B.3.
- [ ] The research agent skill or role doc includes an obligation to emit structured
      `External Evidence` blocks for all external factual claims.
- [ ] The PR template includes the four-item evidence-linkage checklist from B.3.

---

## Part C — Combined upstream PR strategy

### Single vs split PR

These two changes (Part A — DRIFT-006 perf-checklist, Part B — PG-365-2 trust-boundary
docs) address different phases of the pipeline (F5 vs F1d) and touch different files.
They can be split into two PRs without dependency. However, a single PR is recommended
because:

- Both are additive-only (no behavior changes to any agent, no prompt deletions).
- Both stem from the same jira-cli cycle (#365 post-PR analysis) — a single PR keeps
  the provenance clean.
- Estimated scope is small enough (~5 file edits, ~150 lines of additions) to review
  in one pass.

### Suggested PR title

```
feat(skills): add F5 perf-checklist + F1d trust-boundary docs (jira-cli/issue#365 followup)
```

### Estimated scope

- Files changed: ~5 (adversarial skill, code-reviewer skill, spec template, PR template,
  new trust-boundaries doc)
- Net additions: ~150 lines
- Net deletions: 0 (all additive)
- Behavior change in any agent: none — checklist items and docs are advisory/structural

### Suggested PR description (draft body)

```markdown
## Summary

- Adds a 4-item Performance / Complexity axis checklist to the F5 adversary and
  code-reviewer prompts. Addresses a gap where the `Vec::retain` + per-iteration
  HashSet rebuild O(N²) pattern slipped past all three F5 reviewers (DRIFT-006,
  jira-cli cycle 3).
- Adds `agents/trust-boundaries.md` codifying the F1d adversary's trust contract:
  assume research-agent evidence as session-level ground truth, verify semantic
  alignment only, never re-query external services (PG-365-2).
- Adds structured `External Evidence` block format to the spec template so research-
  agent citations are machine-checkable by the F1d adversary.
- Adds the 4-item evidence-linkage checklist to the PR template and F1d adversary
  prompt.

## What changed

- `skills/phase-f5-scoped-adversarial/SKILL.md` (or equivalent): +4 perf-checklist items
- `agents/code-reviewer.md` (or equivalent): +4 perf-checklist items
- `templates/spec-template.md`: +`External Evidence` section
- `.github/pull_request_template.md`: +evidence-linkage checklist section
- `agents/trust-boundaries.md`: NEW — full trust-boundary contract for F1d

## Test plan

- [ ] Read through each modified skill prompt end-to-end; confirm new sections are
      grammatically consistent with surrounding text.
- [ ] Confirm `agents/trust-boundaries.md` renders correctly in GitHub markdown.
- [ ] Apply the evidence-linkage checklist to one existing spec file as a spot-check;
      confirm it is completable without ambiguity.
- [ ] No automated tests required — changes are documentation and prompt text only.
```

---

## Source traceability

All recommendations above are directly extracted from:
`/Users/zious/Documents/GITHUB/jira-cli/.factory/research/drift-items-365-design-validation.md`

Sections used:
- `## PG-365-2 — F1d adversary citation-verification scope` — full section (B.0 through B.5)
- `## DRIFT-006 — F5 multi-axis review missed O(N²) complexity` — full section (A.0 through A.5)

Sections intentionally NOT extracted (orchestrator-specific or jira-cli-internal):
- `## PG-365-1 — BC Trace field stale-test-count drift` — this item requires changes to
  jira-cli's own `.factory/specs/prd/bc-*.md` files and `scripts/`, not to the engine.
  It is out of scope for this upstream draft.
- `## Cross-cutting observations` — contextual notes for jira-cli maintainer; not
  actionable for the engine upstream.
- `## Research Methods` and `## Key Sources (verified)` — provenance metadata for the
  research run; informational only.
- The "cryptographic hash" pattern from PROV-AGENT and ConfMAD-style numeric confidence
  propagation — explicitly de-emphasized in the research as overkill for a single-
  maintainer project. Not included to avoid scope creep.
