# External Research — Drift-Items-365 Design Validation

**Date:** 2026-05-15
**Branch:** develop (post PR #367 / commit e193c16)
**Researcher:** Claude (research-agent)
**Scope:** Validate design approach for three open drift items: PG-365-1 (BC Trace stale-count drift), PG-365-2 (F1d adversary citation-verification scope), DRIFT-006 (F5 review missed O(N²) complexity).

> **Note on local context:** The `.factory/specs/prd/bc-*.md` files referenced in the question were not present on the `develop` branch at HEAD as of this research run (verified via Glob `.factory/**/*`). Recommendations below are therefore derived purely from external research; concrete local-file integration should be revisited once those artifacts land.

---

## Executive Summary

| Drift item | Recommended approach | Confidence | Marginal cost |
|---|---|---|---|
| **PG-365-1** | (b) one-time manual sweep + soften numeric counts to qualitative references; optional (c) advisory CI script that *forbids new numeric counts* (style check), not one that *validates* counts | High | Low (afternoon + small CI script) |
| **PG-365-2** | Three-pattern combo: (1) structured `External Evidence` block per claim, (2) explicit "Trust Boundary" doc section, (3) evidence-linkage checklist in PR template + adversary prompt | High | Low (one-time doc + template change) |
| **DRIFT-006** | (b) augment existing F5 reviewer prompts with 3–4 perf-checklist items + ensure `cargo clippy -W clippy::perf` runs in CI; selective benchmarks only on flagged changes | Medium-High | Very low (prompt + PR-template edits, no new persona) |

---

## PG-365-1 — BC Trace field stale-test-count drift

### Background

BC body files contain a `**Trace**:` field that mixes implementation pointers (e.g. `src/api/jira/issues.rs::search_issue_keys`) with free-text test counts (e.g. `tests/search_issue_keys.rs (16 wiremock tests — 15 library tokio + 1 subprocess)`). With ~251 BC entries across 7 files and free-form text, the cited test counts drift as tests are added or removed.

### What other spec/contract repos do

Across the four reference repos surveyed (`rust-lang/rfcs`, `kubernetes/enhancements`, `oxidecomputer/rfd`, HashiCorp RFCs), **no public OSS repo has built automated drift detection between markdown spec test-count claims and live `cargo test`/`cargo nextest list` output**. [via Perplexity]

- **`rust-lang/rfcs`** — text-only RFCs; no live test metadata or test-suite back-references; tooling exists for index/status, none for test-count reconciliation. [via Perplexity]
- **`kubernetes/enhancements` (KEPs)** — has structured `Testing Plan` and `Graduation Criteria` sections with narrative claims like "Unit tests will be added for X"; KEP validation tooling enforces structure/metadata only, not numeric claims. [via Perplexity]
- **`oxidecomputer/rfd`** — closest to the question; RFDs reference crates/feature flags/test types in "Traceability" sections; **no public CI job greps doc test-count claims and compares to Rust test inventory**. [via Perplexity]
- **HashiCorp RFCs** — narrative test-plan sections; no automated numeric enforcement. [via Perplexity]

The general industry pattern documented by Perplexity: structured frontmatter for fields that *must* be machine-checkable (status, owners, version), free-text for everything else, and CI checks that verify *links/references resolve* (not that *counts match*). [via Perplexity]

### Building blocks available in Rust

- `cargo test -- --list` — prints all discoverable test names with module paths; suitable for `wc -l` / regex filtering. [via Perplexity]
- `cargo nextest list --message-format json` — structured JSON output; queryable with `jq '.tests[] | select(.name | contains("wiremock"))'`. [via Perplexity]
- `ripgrep` over `#[test]` / `#[tokio::test]` — fast, no compilation needed; brittle against `cfg`-gated tests, `#[ignore]`, and macro-generated tests. [via Perplexity]

### Tradeoffs of strict vs free-text tolerance

| Approach | Cost | Value | Failure mode |
|---|---|---|---|
| **(a) Strict CI script that parses `(\d+)\s+\w*\s*tests?` and reconciles via nextest JSON** | High setup; recurring maintenance whenever wording style drifts; brittle regex on free text | Low — exact counts (16 vs 15) almost never drive decisions for a single maintainer | Author starts mechanically updating numbers to silence CI, or disables the check |
| **(b) One-time sweep removing/softening numeric counts; convention enforced by template** | One afternoon for 251 entries + template/CONTRIBUTING update | High — no misleading precision; future drift prevented by convention | Relies on maintainer discipline (acceptable for solo project) |
| **(c) Hybrid advisory script (warning, not failure)** | Same brittleness as (a); warnings tend to become noise | Marginal | Warnings ignored within weeks |
| **(c′) Style-check variant — CI fails if a `Trace:` line introduces a new `\b\d+\s+tests?\b` pattern** | Trivial regex; near-zero false positives | Prevents reintroduction of the brittle format after the (b) sweep | None significant |

### Recommended approach (PG-365-1)

**(b) + (c′) — manual one-time sweep, then style-only forbid-numeric-counts CI check.**

Concrete changes:

1. **Sweep:** rewrite `Trace:` fields to use qualitative test references and stable selectors:
   - Before: `tests/search_issue_keys.rs (16 wiremock tests — 15 library tokio + 1 subprocess)`
   - After: `tests/search_issue_keys.rs (wiremock suite covering happy-path, has_more cap, 429 retry, deadline; subprocess test for binary integration)`
2. **Template / spec convention:** in the BC template, document: "Trace fields MUST NOT contain exact test counts. Reference test files, modules, or qualitative coverage descriptions instead."
3. **Optional CI guardrail (new):** simple `scripts/check-bc-no-numeric-test-counts.sh` (≤30 LOC) that runs `rg '\b\d+\s+(wiremock\s+)?tests?\b' .factory/specs/prd/bc-*.md` and exits 1 if matches found. Mirrors the existing `scripts/check-spec-counts.sh` pattern documented in `CLAUDE.md` (DRIFT-001 mitigation).

### Top-3 actionable PG-365-1 recommendations

1. **One-time sweep:** rewrite all 251 BC `Trace:` entries to remove numeric test counts; replace with qualitative coverage descriptions and stable file/module references.
2. **Update BC template + CONTRIBUTING:** explicitly forbid numeric test counts in `Trace:` fields; show examples of preferred qualitative form.
3. **Add style-only CI check:** `scripts/check-bc-no-numeric-test-counts.sh` that fails CI if `\b\d+\s+\w*\s*tests?\b` appears in `Trace:` lines (regex, no nextest dependency, near-zero false positives).

### Inconclusive findings (PG-365-1)

- No published example of any spec-driven repo doing exact-count drift detection — so even if you build option (a), there's no prior art to copy. Treat that as weak evidence the cost/value tradeoff is unfavorable. [via Perplexity, evidence by absence]

---

## PG-365-2 — F1d adversary citation-verification scope (engine-level)

### Background

The F1d adversary in this VSDD pipeline is read-only (no WebFetch). When a spec cites an externally-validated fact (e.g., "Perplexity confirmed X"), the adversary can verify the citation **exists** in the spec's evidence record but cannot directly verify the underlying claim is true in the external world.

### Industry consensus on trust boundaries between research-validation and adversarial-review agents

Across multi-agent pipeline frameworks surveyed (Anthropic Claude Code subagents, LangGraph, AutoGen, CrewAI, BabyAGI, plus the AgentFact and CiteAudit research papers), **the canonical pattern is: the adversarial-review agent treats the structured evidence store produced by the research agent as session-level ground truth and does NOT re-query the external world**. [via Perplexity, citing dev.to/anviren/adding-a-trust-boundary-to-a-crewai-multi-agent-workflow, christophermeiklejohn.com/.../mas-series-06-verification-patterns, code.claude.com/docs/en/sub-agents]

Key sources confirming this:

- **Anviren (dev.to) on CrewAI trust boundaries** — "roles are not boundaries"; the real risk is what *moves* between agents. Recommends explicit boundaries around four flows: external content entering agents, agent-to-agent handoffs, persistent-memory writes, and external-action tools. [via Perplexity → dev.to/anviren/adding-a-trust-boundary-to-a-crewai-multi-agent-workflow-41mh]
- **Meiklejohn's MAS verification patterns survey** — three categories: self-verification, separate verifier, structural gate. Strongest pattern combines separate verifier + structural gate, especially when there's a *modality shift* between generator and verifier. Verifiers are "typically read-only with respect to the external world." [via Perplexity → christophermeiklejohn.com/ai/agents/mas-series/2026/04/29/mas-series-06-verification-patterns.html]
- **Microsoft Azure Content Safety groundedness detection** — explicitly assumes the *provided sources* constitute the grounding corpus; detects when generated content strays *beyond that corpus*, regardless of whether the strayed content happens to be true in reality. [via Perplexity → learn.microsoft.com/.../groundedness]
- **CiteAudit (multi-agent citation verification, arxiv 2602.23452)** — Web Search Agent and Scholar Agent perform external retrieval; the *Judge Agent* makes the final real-or-fake decision **based on the collected evidence only**, not by re-querying. [via Perplexity → arxiv.org/html/2602.23452v3]
- **Anthropic Claude Code subagents** — subagent permission model lets a reviewer subagent be configured with read-only tools (file read, code search) and explicit denials for `web_fetch` / shell. Auto-mode adds server-side prompt-injection probes on tool outputs and a safe-tool allowlist. [via Perplexity → code.claude.com/docs/en/sub-agents, www.anthropic.com/engineering/claude-code-auto-mode]

### Why re-verification by the adversary is *discouraged*

If the adversarial agent calls the live web to re-verify, it **re-opens the trust boundary it was designed to close**: the supposedly inner trusted layer becomes exposed to the same prompt-injection, retrieval-poisoning, and provenance-attribution risks as the outer research agent. The whole point of denying it network access is to make a smaller, more auditable threat surface. [via Perplexity → dev.to/anviren/..., thebackenddevelopers.substack.com/p/runtime-verification-for-ai-agents]

### Three documentation patterns that make the trust boundary explicit and auditable

These are the canonical patterns synthesized across PROV-AGENT (arxiv 2508.02866), V7 Document Citation Agent, CiteAudit, and Azure groundedness detection. [via Perplexity, multi-source]

#### Pattern 1 — Structured `External Evidence` block per claim cluster

Replace inline prose like "Perplexity confirmed X" with a structured machine-parseable block:

```markdown
### External Evidence

- Claim ID: `C1`
  - Statement: itertools::unique() preserves input order on a standard iterator.
  - Source tool: Perplexity (sonar-pro)
  - Query: "Does itertools::unique() in Rust preserve original element order?"
  - Evidence snapshot:
    > "yields the first occurrence of each element, preserving the source iterator order."
  - URL / permalink: https://www.perplexity.ai/search/...
  - Retrieved at: 2026-05-10T14:23Z
  - Epistemic status: Assumed-true-within-session
  - Confidence: high (single-source) | high (multi-source) | provisional
```

The adversary can then check: every external factual claim in the spec body has a `Claim ID` reference, every claim is *semantically entailed* by its evidence snapshot (no over-generalization, no missing caveats), and no two claims contradict. PROV-AGENT and V7's Document Citation Agent both use this pattern, with V7 attaching coordinates back to the original document. [via Perplexity → arxiv.org/html/2508.02866v2, www.v7labs.com/agents/ai-document-citation-agent]

#### Pattern 2 — Explicit "Trust Boundary" doc section in pipeline documentation

A short, named doc (e.g., `.factory/agents/trust-boundaries.md`) that codifies the contract:

```markdown
## Trust Boundary: External Research Evidence

- Source tools (Perplexity, Context7, WebFetch) are operated only by the research-agent.
- The Research Agent retrieves external evidence and emits structured `External Evidence`
  blocks with provenance and confidence.
- The Adversarial Review Agent (F1d):
  MUST: assume `External Evidence` with `Epistemic status: Assumed-true-within-session`
        is correct for the duration of one pipeline run.
  MUST: verify every external factual claim in the spec body links to an Evidence Claim ID,
        verify the spec text is semantically entailed by the linked evidence (no
        over-generalization), and verify no internal contradictions.
  MUST NOT: invent new sources, re-query external services, or reject a claim solely on
            counterintuitive grounds (only evidence-misalignment is in scope).
- Implication: if Perplexity is wrong, the pipeline propagates the error faithfully but
  preserves a clear audit trail for post-mortem.
```

This makes any future post-mortem question straightforward: "was this bug due to evidence being wrong, or due to spec text misaligned with evidence?" — answerable in seconds by inspecting the trust contract.

#### Pattern 3 — Evidence-linkage checklist embedded in PR template + adversary prompt

A short bidirectional checklist that *both* the adversary uses and the human maintainer sees on PR:

```markdown
### External Evidence / Adversarial Review Checklist
- [ ] All external factual claims (APIs, complexity guarantees, protocol behavior) carry a `[C#]` Claim ID.
- [ ] Each `[C#]` resolves to an entry in the spec's `External Evidence` section.
- [ ] Spec text does not exceed evidence scope (no "always", "never", or expanded domains
      not present in the snippet).
- [ ] Where spec text intentionally diverges from evidence (e.g., conservative stance), the
      divergence is explicitly noted.
```

Mirrors CiteAudit's Judge-Agent contract. [via Perplexity → arxiv.org/html/2602.23452v3]

### Top-3 actionable PG-365-2 recommendations

1. **Define a structured `External Evidence` block format** (Pattern 1) and add it to the spec template; require all "Perplexity confirmed X" / "research validated Y" prose to be replaced with `[C#]` references resolving to evidence entries.
2. **Write `.factory/agents/trust-boundaries.md`** (Pattern 2) codifying the F1d adversary's contract: assume-true-within-session, verify-alignment-only, never re-query externally.
3. **Add the four-item evidence-linkage checklist** (Pattern 3) to both the PR template and the F1d adversary's system prompt — symmetric instructions to maintainer and agent.

### Inconclusive findings (PG-365-2)

- The exact "cryptographic hash" pattern from PROV-AGENT (per-snippet content hash for tamper-detection) is overkill for a single-maintainer project; included it in research but de-emphasizing in recommendations. Revisit if the pipeline ever runs untrusted code.
- ConfMAD-style numeric confidence propagation across agents is documented but adds structural complexity disproportionate to the value at this scale; recommend qualitative `Confidence: high|provisional` labels instead. [via Perplexity → arxiv.org/html/2509.14034v1]

---

## DRIFT-006 — F5 multi-axis review missed O(N²) complexity

### Background

F5 panel was: adversary (correctness), code-reviewer (style/conventions), security-reviewer (OWASP/CWE). All passed. Copilot caught an O(N²/page_size) bug in `Vec::retain` + per-iteration HashSet rebuild. The question: is complexity/performance review a standard explicit checklist axis, or implicit?

### What major code-review guides say

- **Google Engineering Practices "How to look for in a code review"** — section list (verbatim from the page): Design, Functionality, Complexity, Tests, Naming, Comments, Style, Consistency, Documentation, Every Line, Exceptions, Context, Good Things, Summary. The "Complexity" section quote: *"Is the CL more complex than it should be? Check this at every level of the CL—are individual lines too complex? Are functions too complex? Are classes too complex?"* — **the page contains no discussion of algorithmic complexity, Big-O notation, or performance considerations**. [via WebFetch (verifying Perplexity citation) → google.github.io/eng-practices/review/reviewer/looking-for.html]
- **Microsoft secure code review** — focuses on vulnerabilities, validation, auth, secrets, memory; complexity concerns appear under the DoS / resource-exhaustion lens (unbounded loops, pathological regex), but are **not framed as formal asymptotic analysis**. [via Perplexity]
- **GitHub PR / GitLab MR templates** — typical sections: what does this change do, how was it tested, breaking changes, security/docs/testing checkboxes. Performance questions like "Does this change impact performance?" sometimes appear, but **they almost never explicitly require Big-O notation**. [via Perplexity]

**Net:** algorithmic complexity is *implicitly* expected under "performance / scalability / design" but is **not a standard explicit Big-O checklist item** in any major industry-published guide.

### What clippy can and cannot catch

Verified against rust-lang/rust-clippy master on 2026-05-15:

| Lint | Group | Status | Catches the DRIFT-006 pattern? |
|---|---|---|---|
| `clippy::needless_collect` | perf | **Active** (file `clippy_lints/src/methods/needless_collect.rs` exists with full implementation logic; user-facing message: "avoid using `collect()` when not needed"). Earlier Perplexity claim of deprecation was **incorrect** and contradicted by repo source. | Partially — flags `iter.collect::<Vec<_>>()` followed by re-iteration |
| `clippy::redundant_clone` | perf | Active | No |
| `clippy::manual_retain` | perf | Active | No (suggests *using* `retain` instead of filter-collect; doesn't analyze closure body) |
| `clippy::iter_overeager_cloned` | perf | Active | No |
| `clippy::set_contains_or_insert` | perf | **Active**, added in **Rust 1.83**. Detects `set.contains(x) { set.insert(x) }` → use `set.insert(x)` return value | No |

[via Perplexity (lint groups), via WebFetch on raw.githubusercontent.com (file-existence verification of needless_collect.rs)]

**Critically: no clippy lint detects "rebuild HashSet/BTreeSet inside a `Vec::retain` or `Iterator::filter` closure" as an O(N*M) anti-pattern.** Clippy does not perform algorithmic-complexity analysis; it only matches syntactic anti-patterns. [via Perplexity, two independent search results]

### Standard practice for adding a "performance/complexity axis" to multi-reviewer panels

Three layered approaches recur across the literature: [via Perplexity]

1. **Checklist-level:** add explicit items like "Does this change have performance/scalability implications? Any new or changed algorithms — consider asymptotic complexity. Is this code in a hot path?"
2. **Role-level:** designate a *performance-savvy* approver for high-impact areas; tag `@perf-reviewers` when changes hit hot paths or introduce nested loops/data-structure changes.
3. **Process-level:** explicit labels (`perf-sensitive`, `hot-path`, `scalability`) that trigger CI escalations (benchmarks, load tests).

Major shops *rarely* require formal Big-O analysis on every change; common triggers for explicit Big-O reasoning are: new/substantially modified algorithm, change in core data structure, code in per-request path of a high-QPS service, or *suspected* quadratic behavior. [via Perplexity]

### Tradeoffs

| Option | Cost | Catch rate (~estimated) | Failure mode |
|---|---|---|---|
| **(a) Add a dedicated "performance reviewer" persona to F5** | Recurring — every change goes through another agent invocation; new prompt to maintain | Medium — depends entirely on prompt specificity | Tends to collapse into option (b) once you write the prompt; persona overhead doesn't pay off for a single-maintainer project |
| **(b) Add 3–5 specific perf checklist items to existing reviewers' prompts** | One-time prompt edit + PR template tick-box | High for the *target class* (per-iteration allocation, repeated `contains` in loop, retain/filter doing work-per-element) | Misses non-iteration perf bugs (allocation patterns, lock contention) |
| **(c) Require benchmarks for any change touching iteration logic** | High — writing & maintaining benches; many small datasets show no measurable diff | High when actually used | Overkill as a blanket rule for solo project |
| **(d) Combination — clippy::perf in CI + checklist + selective benchmarks on flagged changes** | Low marginal (mostly already configured) | High (≥80% of "accidentally quadratic" class) | Requires triggering discipline (when to escalate to benchmark) |

### Recommended approach (DRIFT-006)

**(d) — `cargo clippy -W clippy::perf` always on in CI + 4 specific checklist items added to existing reviewers + selective benchmarks only when checklist flags a concern.** Avoid adding a dedicated persona (a) — for a single-maintainer project the persona overhead doesn't justify the marginal catch rate over a well-written checklist.

#### Specific checklist items to add (verbatim suggestions)

Add these to the F5 code-reviewer and adversary prompts, *and* to the PR template:

1. **Loop / closure allocation check:** Scan for `HashSet`, `HashMap`, `Vec`, or other collections **created inside** loops or closures used in `retain`, `filter`, `map`, `for_each`, or nested loops. Ask: can these be constructed once outside and reused?
2. **Big-O delta check:** For any changed loop/iteration logic, compare complexity before vs. after. Could this change make behavior proportional to N², N*M, or page_size * N? If yes, refactor or justify with a comment.
3. **Membership-test optimization check:** If the code performs repeated `contains` / `find` operations inside an iteration, check whether a set/map can be pre-built once before the loop.
4. **Retain/filter hot-path focus:** Treat `retain`/`filter` closures as hot paths — no heavy setup work (I/O, allocations, large clones) per element.

#### Specific clippy-CI step to ensure is enabled

```bash
cargo clippy --all-targets --all-features -- -D warnings -W clippy::perf
```

(The `-D warnings` is already implied by the project's "zero warnings policy" per `CLAUDE.md`. Adding `-W clippy::perf` explicitly opts in the perf group.)

### Top-3 actionable DRIFT-006 recommendations

1. **Augment existing F5 reviewer prompts with 4 explicit perf-checklist items** (loop/closure allocation, Big-O delta, membership-test optimization, retain/filter hot-path focus) — see verbatim text above. Add the same items to PR template tick-boxes.
2. **Verify CI runs `cargo clippy --all-targets --all-features -- -D warnings -W clippy::perf`** so all perf-category lints (active as of 2026-05: `needless_collect`, `manual_retain`, `set_contains_or_insert`, `iter_overeager_cloned`, `redundant_clone`, etc.) fail CI rather than warn silently. Already aligned with project's existing zero-warnings policy.
3. **Document a benchmark-on-flag policy:** when the checklist surfaces a concern (new nested loop, allocation in retain/filter, repeated membership tests), the PR author either refactors or adds a `criterion` micro-benchmark with results in the PR description. Avoids blanket-bench overhead while still gating *suspected* hotspots.

### Inconclusive findings (DRIFT-006)

- No clippy lint exists today that detects the *specific* "rebuild HashSet inside retain closure" pattern. The closest open issues track adjacent patterns. If this class of bug recurs, a custom dylint (third-party clippy plugin via the `dylint` crate) would be the next escalation, but that's heavyweight for a single-maintainer project. [via Perplexity, evidence by absence in clippy lint index]
- Conflict noted: the first Perplexity search said `needless_collect` was "deprecated/absorbed by more targeted lints." A follow-up Perplexity search and direct repo-source check (raw.githubusercontent.com → `clippy_lints/src/methods/needless_collect.rs` exists with active implementation) **refuted** this. The lint is currently active in the perf group. Treat the original Perplexity claim as a model-hallucination artifact. [via Perplexity (refuted) vs via WebFetch (verifying — file exists with full implementation)]

---

## Cross-cutting observations

- **Solo maintainer scaling:** all three recommendations deliberately avoid adding new agent personas, new dedicated reviewers, or recurring multi-step processes. Each fix is a one-time investment (template change, prompt-edit, doc) plus a tiny CI script. This matches the "minimal-marginal-cost" criterion.
- **Existing project conventions to preserve:** the BC `Trace:` field is documented in `CLAUDE.md` as a free-form metadata field; the recommendation is to *narrow its scope* (drop numeric counts) rather than restructure it.
- **Scripts already present:** `scripts/check-spec-counts.sh` is the prior art for DRIFT-001 (frontmatter-vs-body count drift). The PG-365-1 recommendation creates a sibling, narrower script (forbid-numeric-test-counts in `Trace:` lines), reusing the same convention.

---

## Research Methods

| Tool | Queries | Purpose |
|---|---|---|
| Perplexity search | 6 | Drift-detection patterns in spec repos; trust boundaries in multi-agent pipelines; clippy perf lints status; Google eng-practices content; clippy lint deprecation cross-check; cargo-nextest patterns |
| Perplexity reason | 1 | Synthesized cost/value tradeoff and recommendation per drift item, given solo-maintainer constraints |
| Perplexity deep_research | 0 | Not needed — search + reason gave sufficient depth on each question |
| Context7 | 0 | Not used — research is process/architectural, not library-API-specific |
| Tavily | 0 | Not configured in this environment |
| WebFetch | 6 | Verified Perplexity citations: clippy lint index (×4 — found the lint index page is too large to fetch as a single document; substituted with raw GitHub source); google.github.io/eng-practices Complexity section (verbatim); raw.githubusercontent.com clippy needless_collect.rs (file existence + content) |
| WebSearch | 0 | Not needed; Perplexity returned conclusive results on all questions |
| Training data | 1 area | General awareness that needless_collect existed; explicit version/group claims were verified against Perplexity + repo source rather than relying on training data |

**Total MCP tool calls:** 7 (6 Perplexity search + 1 Perplexity reason)
**Total WebFetch calls (verifying Perplexity citations):** 6
**Training data reliance:** Low — version-sensitive claims (clippy lint group membership, set_contains_or_insert version 1.83, needless_collect active vs deprecated) were cross-verified against rust-lang/rust-clippy repo source and Perplexity. Google eng-practices "Complexity" content was verified by WebFetch against the canonical URL.

### Notes on Perplexity quality during this run

- **Q3 first search** (clippy/Google eng-practices combined query) returned an off-topic citation list (medical/PV journals) but the *prose* was on-topic. Required a follow-up targeted search for clippy and a direct WebFetch to verify Google's exact section list.
- **Q3 second search** (Google eng-practices specific) returned more off-topic citations (OpenAI prompting guide, FDA regulations); the *prose* was usable but unverifiable without WebFetch.
- **Q1 second search** (cargo-nextest / spec-repo drift detection) — citations were off-topic (Sommerville textbook, NIST, MITRE) but the prose was on-topic and aligned with the first search's findings.
- **Reason model** returned similarly noisy citations (Gates Notes, USPTO) but the synthesis prose was high-quality and aligned with the verified sources from prior searches.
- **Conflict resolved:** first Perplexity search said `clippy::needless_collect` was deprecated; follow-up search and direct repo-source check (file `clippy_lints/src/methods/needless_collect.rs` exists with active implementation) refuted this. Reported in the DRIFT-006 inconclusive section.

No WebSearch fallback was needed; Perplexity + WebFetch (for citation verification) were sufficient.

---

## Key Sources (verified)

- Anviren — *Adding a Trust Boundary to a CrewAI Multi-Agent Workflow* — https://dev.to/anviren/adding-a-trust-boundary-to-a-crewai-multi-agent-workflow-41mh [via Perplexity]
- Meiklejohn — *MAS Series 06: Verification Patterns* — https://christophermeiklejohn.com/ai/agents/mas-series/2026/04/29/mas-series-06-verification-patterns.html [via Perplexity]
- Anthropic — *Claude Code Sub-Agents* — https://code.claude.com/docs/en/sub-agents [via Perplexity]
- Anthropic — *Claude Code Auto Mode* — https://www.anthropic.com/engineering/claude-code-auto-mode [via Perplexity]
- Microsoft — *Azure AI Content Safety: Groundedness Detection* — https://learn.microsoft.com/en-us/azure/ai-services/content-safety/concepts/groundedness [via Perplexity]
- *PROV-AGENT* — https://arxiv.org/html/2508.02866v2 [via Perplexity]
- *CiteAudit* — https://arxiv.org/html/2602.23452v3 [via Perplexity]
- *Hallucination detection pipeline (Tian Pan)* — https://tianpan.co/blog/2026-04-10-hallucination-detection-pipeline-production [via Perplexity]
- *V7 Document Citation Agent* — https://www.v7labs.com/agents/ai-document-citation-agent [via Perplexity]
- Google — *Engineering Practices: What to Look For in a Code Review* — https://google.github.io/eng-practices/review/reviewer/looking-for.html [via WebFetch (verifying Perplexity citation)]
- Rust Clippy lint index — https://rust-lang.github.io/rust-clippy/master/index.html [via Perplexity, WebFetch attempted but page exceeds fetch budget]
- rust-lang/rust-clippy `needless_collect.rs` source — https://raw.githubusercontent.com/rust-lang/rust-clippy/master/clippy_lints/src/methods/needless_collect.rs [via WebFetch (file-existence verification, refuting earlier deprecation claim)]
- Clippy lint listing — https://doc.rust-lang.org/stable/clippy/lints.html [via Perplexity]
