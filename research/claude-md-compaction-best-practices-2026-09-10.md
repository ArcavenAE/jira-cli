# Research: Managing and Compacting Oversized CLAUDE.md Files

**Type:** general (technology / tooling practice)
**Date:** 2026-09-10
**Author:** Research agent (Corverax / jira-cli)
**Topic slug:** claude-md-compaction-best-practices

---

## Context: our specific situation

The `jira-cli` root `CLAUDE.md` is **~164 KB / 458 lines** (long lines; the byte count implies roughly 35,000–45,000 tokens, far above any recommended budget — see §1/§3). It mixes:

- **Operative content** — architecture map, conventions, gotchas, exit-code rules, output-channel profiles, `JR_*` env-var seam table, ADR pointers.
- **Large historical narrative** — most conspicuously the multi-page "CI Gate" section documenting ~20 adversarial-review rounds and the S-CIGATE-3 fix-burst history, plus deep per-bug narrative in many "Gotchas" bullets, describing work that is already **completed and landed**.

**Proposed approach:** extract the historical narrative into referenced docs under `docs/specs/*.md`, keep only concise operative rules plus one-line pointers in `CLAUDE.md`, preserve all citations and load-bearing knowledge, and do it via branch + PR.

**Verdict up front:** the proposed approach is squarely **best practice** and matches both official Anthropic guidance and the strongest community case studies. There are four refinements worth adopting (behavioral before/after probes, a reference-integrity CI check, a size tripwire, and careful handling of any "paused/temporary/disabled" state). Details and the one material risk are in §4 and the Verdict.

A note on evidence quality throughout: **official Anthropic guidance is explicitly labeled as such**; everything else is community/practitioner anecdote (blogs, GitHub issues, Reddit/HN) and is labeled accordingly. Where evidence is thin, it is flagged.

---

## 1. Is there consensus on a healthy CLAUDE.md size, and why?

### Official Anthropic guidance (authoritative)

- **Target under 200 lines per `CLAUDE.md` file.** Anthropic's memory documentation states the target directly and gives the reason: *"Longer files consume more context and reduce adherence."* This is a **soft target, not a truncation boundary.** [Claude Code Docs — "How Claude remembers your project," memory page, search-index last-updated 2026-09-10, https://docs.anthropic.com/en/docs/claude-code/memory ; mirror https://code.claude.com/docs/en/memory]
- **The only documented hard limit is 4 MiB** — a `CLAUDE.md` larger than 4 MiB is skipped entirely; up to 4 MiB it loads in full. 4 MiB is a failure boundary, **not** a recommended operating size. [memory page, same URL]
- **"Keep it concise."** The best-practices page frames the review test: if deleting a line would *not* cause Claude to make mistakes, delete it; bloated files cause the instructions that matter to be **ignored**. [Claude Code Docs — "Best practices," https://code.claude.com/docs/en/best-practices ; Anthropic Engineering — "Claude Code: Best practices for agentic coding," published 2025-04-18, https://www.anthropic.com/engineering/claude-code-best-practices]
- **The root file specifically should be "pointers and critical gotchas only; everything else drifts into noise."** [Anthropic (claude.com) — "How Claude Code works in large codebases," 2026-05-14, https://claude.com/blog/how-claude-code-works-in-large-codebases-best-practices-and-where-to-start]
- The "Extend Claude Code" features-overview page reiterates: keep `CLAUDE.md` under 200 lines and move reference content to skills or path-scoped rules. [https://docs.anthropic.com/en/docs/claude-code/features-overview]

Important caveat on citing Anthropic docs: **these pages do not display body-level publication dates.** The dates above are search-index "last updated" metadata, except the engineering blog post whose 2025-04-18 date is shown in Anthropic's engineering index. Treat the doc dates as "current as of retrieval on 2026-09-10," not as changelog timestamps.

### Community consensus (anecdote — converging but not rigorous)

There is **no agreed token/KB number**, but community numbers cluster tightly and now align with Anthropic's 200-line target:

| Range | Interpretation | Representative source |
|---|---|---|
| 20–60 lines | Aggressively minimal "router"/index | HumanLayer's own root file reported <60 lines [https://www.humanlayer.dev/blog/writing-a-good-claude-md, 2025-11-25] |
| 50–150 lines | Practical sweet spot for a root file | Reddit/HN threads [e.g. https://news.ycombinator.com/item?id=46256662, 2025-12-13] |
| **<200 lines** | Current mainstream ceiling, matches official target | [dev.to "Your CLAUDE.md is too long — the 200-line ceiling," 2026-06-05, https://dev.to/davekurian/your-claudemd-is-too-long-the-200-line-ceiling-that-actually-works-1fb0] |
| <300 lines | Older/permissive recommendation | [Builder.io, 2026-01-13, https://www.builder.io/blog/claude-md-guide ; Willow Voice, 2026-06-11, https://willowvoice.com/blog/10-essential-claude-code-best-practices] |
| ~2,000–3,000 tokens | Community token ceilings (not official) | [Community handbook, https://github.com/ThamJiaHe/claude-code-handbook/blob/main/docs/claude-md-guide.md] |

**Why smaller is favored (mechanisms, with evidence-strength labels):**

1. **Recurring token cost (strong; mechanically certain).** `CLAUDE.md` (plus ancestor/local/imported/unscoped-rules content) is loaded at session start and **stays in the conversation context on every subsequent turn** — a one-line question in an all-day session still incurs usage for the whole conversation. [Claude Code costs doc, https://code.claude.com/docs/en/costs] This is not opinion; it follows from how the context window works.
2. **Attention dilution / reduced adherence (plausible; official warning + indirect research).** Anthropic explicitly warns longer files reduce adherence; §3 covers the empirical backing (which is real but mostly measured on retrieval and instruction-count tasks, not `CLAUDE.md` specifically).
3. **Instruction interference (moderate).** More independent, potentially conflicting directives raise the chance one is missed. Anthropic warns Claude may resolve contradictions arbitrarily across concatenated scopes. [memory page]
4. **Staleness (strong; official + community).** Copied code, directory trees, and `file:line` citations drift after refactors; a stale pointer makes a compact file *actively misleading*. Both Anthropic and practitioners recommend pointing at the authoritative source rather than copying. [engineering best-practices; HumanLayer]

**The widely repeated "150–200 instructions" threshold is NOT established research.** It originates prominently from HumanLayer, which itself admits the evidence "is not especially rigorous" and cites no specific experiment. Do not treat it as a scientific Claude Code limit. [https://www.humanlayer.dev/blog/writing-a-good-claude-md]

---

## 2. Is "extract to external referenced docs + keep pointers" a recognized best practice? Alternatives?

**Yes — extracting detail and keeping concise pointers is explicitly recommended.** But there is a critical nuance that changes how our proposal should be executed: **not every "pointer" mechanism is lazy-loaded, and `@imports` do NOT save context.**

### The four load mechanisms (this is the load-bearing distinction)

| Mechanism | Syntax / location | Load behavior | Right use |
|---|---|---|---|
| **`@import`** | `@docs/file.md` in `CLAUDE.md` (outside code spans) | **EAGER** — expanded into context at session start; recursion max **4 hops**; relative paths resolve to the importing file | Organization/reuse only. **Does NOT reduce token/context cost.** [memory page] |
| **Plain pointer** | Backticked path + prose "read `docs/x.md` when …" | **On-demand** — Claude must *choose* to read it with file tools; not auto-expanded | Large reference/history where occasional retrieval is acceptable — **but must be retrieval-tested** |
| **Path-scoped rule** | `.claude/rules/*.md` with `paths:` frontmatter | **Conditional** — loads when Claude reads a file matching the glob (no `paths:` = always-on) | Language/dir/file-type-specific conventions [memory page] |
| **Nested `CLAUDE.md`** | `subdir/CLAUDE.md` | **Conditional** — descendant files load when Claude works in that directory; ancestors load at startup | Package/service-specific persistent rules [memory page] |

**Consequence for us:** the pattern "extract narrative to `docs/specs/*.md` and leave a one-line pointer" is correct **if** the pointer is a plain on-demand reference (backticked path + "read when …"), *not* an `@import`. Using `@import` for the extracted CI-Gate history would move bytes out of the file's line count while **keeping the same tokens in context** — defeating the purpose. This is the single most common mistake in the literature. [RuleStack, 2026-08-18, https://dev.to/rulestack/we-cut-our-claudemd-from-548kb-to-34kb-what-loads-when-measured-and-the-commit-gate-that-keeps-1kpk ; dev.to RuleStack imports explainer, https://dev.to/rulestack/claudemd-imports-how-paths-resolve-how-deep-they-go-and-why-yours-silently-did-not-load-2mgf ; GitHub issue #2766, https://github.com/anthropics/claude-code/issues/2766]

### Alternatives (all officially supported)

| Alternative | Best for | Context behavior | Status |
|---|---|---|---|
| **Skills** (`.claude/skills/<name>/SKILL.md`) | Procedures, runbooks, checklists, playbooks, occasional reference | Description present for discovery; **full body loads only when invoked** (progressive disclosure) | Officially recommended [https://docs.anthropic.com/en/docs/claude-code/skills] |
| **Slash / custom commands** (`.claude/commands/*.md`) | Explicitly triggered workflows (`/deploy`, `/review`) | Loaded on invocation | Supported; now merged into the skills system (legacy but working) |
| **Path-scoped rules** (`.claude/rules/*.md`) | Subsystem-specific coding rules | Loads on matching file read | Officially recommended [memory page] |
| **Nested `CLAUDE.md`** | Per-package/service rules | Conditional per directory | Officially supported [memory page] |
| **`docs/` tree** | Architecture, decision logs, history, schemas | No auto-load; Claude reads on demand or via a skill | Common community pattern; consistent with official "link to docs" advice (not a distinct Claude Code feature) [HumanLayer; Medium memory-mgmt] |
| **Subagents** (`.claude/agents/*.md`) | Broad research/exploration | Runs in isolated context; only a summary returns | Officially recommended for context isolation [https://docs.anthropic.com/en/docs/claude-code/sub-agents] |
| **Hooks / settings / permissions** | Non-negotiable enforcement (formatting, blocked paths, required checks) | Deterministic, outside the model; ~zero context cost | Officially recommended for hard constraints [memory page; features-overview] |

**Key architectural insight for our case:** the CI-Gate narrative is *history and rationale*, not an operative rule the agent applies every session — so it belongs in **`docs/` (on-demand pointer)**. The handful of genuinely operative CI rules ("`ci-gate` is the single required check; new required jobs go in `ci-gate.needs`, never branch protection"; "review scope is six files together"; "don't flip `strict: true` without human sign-off") should **stay** as concise bullets. Coding conventions that only apply to `tests/ci_gate_completeness.rs` are a candidate for a **path-scoped rule**. This tiered split is exactly what the strongest case studies did (§4).

---

## 3. Does long/oversized instruction context actually degrade instruction-following or increase cost? (Quantified where possible)

### Cost & latency (certain vs. modest)

- **Cost is exactly and predictably linear in input tokens.** A ~200-line file is estimated at ~1,500 tokens (practitioner estimate, not a sampled distribution). [Claude Code Handbook, 2026-03-30, https://joeyyu23.github.io/claude-code-handbook/en/book3-architect/benchmarks] Our ~164 KB file is far larger — plausibly 35K–45K tokens. **Measure exactly** with Anthropic's free token-counting endpoint (`messages.count_tokens()`) rather than estimating. [https://platform.claude.com/docs/en/build-with-claude/token-counting]
- Order-of-magnitude: a 1,500-token file across 100 uncached Sonnet-class requests adds roughly $0.30; cache reads (0.1× base) drop that ~10×. A 30K+ token always-loaded file is materially more, on **every turn of every session, forever.** [Anthropic pricing/costs docs, https://code.claude.com/docs/en/costs]
- **Latency:** for a few-thousand-token file the penalty is modest (input reduction on ordinary prompts may only move latency 1–5% per OpenAI's own guidance, https://developers.openai.com/api/docs/guides/latency-optimization). Prefill dominates time-to-first-token only at 100K+ tokens. [NVIDIA NIM metrics, https://docs.nvidia.com/nim/benchmarking/llm/latest/metrics.html] Prompt caching cuts repeat prefill cost/latency but **does not restore adherence quality** — the model still receives the same long logical context. [Anthropic prompt-caching announcement, 2024-08-14, https://www.anthropic.com/news/prompt-caching]

### Does instruction-following specifically degrade? (Real data exists — with confounds)

This is backed by **peer-reviewed benchmarks**, not just anecdote, though most do not test `CLAUDE.md` directly:

- **"Lost in the Middle" (Liu et al., TACL 2024; preprint 2023-07-06, https://arxiv.org/abs/2307.03172).** U-shaped performance: information near the start/end is used far more reliably than material in the middle. Measures **retrieval/QA, not persistent system-instruction compliance.**
- **RULER (Hsieh et al., COLM 2024, https://arxiv.org/abs/2404.06654).** Advertised context ≠ effective context; ~half of models claiming ≥32K degraded badly at 32K. Synthetic, task-accuracy-based.
- **NoLiMa (Modarressi et al., ICML 2025, https://arxiv.org/abs/2502.05167).** At 32K, 11/13 models fell below 50% of their short-context baseline; GPT-4o 99.3% → 69.7%. Especially relevant when an instruction and the request don't share keywords (e.g., a general repo rule applied implicitly).
- **Chroma "Context Rot" (2025-07-14, https://www.trychroma.com/research/context-rot).** 18 models, 194,480 calls; all degraded as input grew. Focused ~300-token prompts beat ~113K-token full prompts across the board. Large, reproducible, **but a vendor technical report, not peer-reviewed.**
- **Direct instruction-following evidence (the closest analogues):**
  - **AGENTIF (NeurIPS 2025).** Realistic agent instructions (mean 1,723 words, max 15,630). When instructions exceeded **6,000 words, every model's all-constraints success rate was near zero.** This is the nearest rigorous analogue to a large agent system prompt / `CLAUDE.md`. [https://proceedings.neurips.cc/paper_files/paper/2025/file/51bb3a8a33610a25aae074bfc51b1b1f-Paper-Datasets_and_Benchmarks_Track.pdf]
  - **IFScale (2025-07-15, https://arxiv.org/abs/2507.11538).** Even the best model hit only 68% per-instruction accuracy at 500 instructions; shows primacy bias and a finite "instruction budget."
  - **LIFBench (ACL 2025, https://arxiv.org/html/2411.07037v1)** and **Multi-IF (https://arxiv.org/abs/2410.15553):** instruction adherence/stability declines with length and across turns (o1-preview 0.877 → 0.707 turn 1→3).

**Honest limitations (do not overstate):**
- The canonical long-context literature measures **retrieval**, not standing system-prompt compliance.
- Instruction-following benchmarks **confound length with instruction count and difficulty** — none cleanly isolates "filler tokens alone."
- **"Every extra token hurts" is FALSE.** Relevant examples/clarifications improve performance; degradation is non-monotonic and model/task-dependent.
- **No published controlled trial** measures the effect of removing *historical narrative* from a `CLAUDE.md`. Anthropic's under-200-lines figure is sensible operational guidance, **not** a validated threshold.
- Precise viral figures like "98% compliance at 100 lines, 58% at 2,500 lines" are **practitioner-blog claims**; treat them as anecdote unless raw code/prompts/graders are published.

**Net:** the direction is well-supported — an oversized, mostly-historical always-loaded file is a real (not hypothetical) reliability and cost risk — but the *magnitude* for our specific edit is not precisely quantifiable from published data. That is a reason to **measure our own before/after behavior**, not to assume a number.

---

## 4. Failure modes of trimming a load-bearing memory file, and mitigations

This is the section most relevant to our risk profile, because `CLAUDE.md` here contains dense, load-bearing gotchas the pipeline depends on.

| Failure mode | What goes wrong | Mitigation | Source (all anecdote unless noted) |
|---|---|---|---|
| **Deleting a real invariant while "removing noise"** | An audit accidentally removed genuine rules (secrets handling, mock fallback, additive-schema, a config-cache gotcha) that *looked* narrow but were cross-cutting. | Never bulk-delete; **classify** each block; keep the old version in git; require human review of every deletion; recoverable via `git show`. | dev.to "We Audited Our Claude Code Setup," 2026-07-26, https://dev.to/pponali/we-audited-our-claude-code-setup-against-anthropics-own-context-engineering-rules-heres-what-we-3mme |
| **Preserving words, losing intent** ⚠️ | RuleStack diffed obligations and lost no *text*, yet a "pause this" instruction had been recorded too narrowly; a sibling scheduled mechanism later ran contrary to the owner's belief. **Structural diffs cannot detect semantic omission.** | Audit all "paused/disabled/temporary/frozen" prose with owners; move operational STATE into machine-readable config, not prose. | RuleStack, 2026-08-18 |
| **Broken references after moving content** | A pointer references a deleted/renamed doc or skill; or a doc exists but nothing points to it (silently unreachable). | **Bidirectional reference check in CI/pre-commit:** every pointer resolves to a real file, and every extracted doc has an entry point. | RuleStack, 2026-08-18 |
| **`@import` mistaken for compaction** | Splitting bytes into imported files leaves the same tokens in context. | Use plain on-demand pointers / skills / path-scoped rules for actual reduction (see §2). | memory page (official) |
| **Losing tribal knowledge / rationale** | Deleting completed-work narrative also deletes *why* a workaround exists. Git history is recoverable but poorly discoverable mid-task. | **Relocate, don't erase** — verbatim archive / decision log / topic doc, with a concise "read when …" pointer retained. | RuleStack; HumanLayer |
| **Extracted doc becomes undiscoverable** | Doc exists in `docs/` but is never read (weak pointer, no trigger). | Keep *trigger conditions* ("When touching CI gate, read `docs/specs/ci-gate-history.md`"), and **retrieval-test** with representative tasks. | HumanLayer; Glasswerks |
| **Hard rules remain merely advisory** | `CLAUDE.md` is context, not enforced policy — a concise rule can still be disobeyed. | Move zero-exception controls to hooks/CI/branch-protection/permissions; keep only the pointer/rationale in `CLAUDE.md`. | features-overview (official) |
| **Judging success by byte count alone** | Smaller file may still reduce compliance/retrieval. | **Before/after behavioral probes** in fresh sessions, including negative tests that tempt a prohibition; log repeated corrections for ~a week. | RuleStack; Unblocked |

⚠️ **The "preserving words, losing intent" failure is our single most important risk.** Our `CLAUDE.md` contains explicitly *stateful* prose — e.g., `ALLOWED_SKIPS` / `PINNED_ALLOWED_SKIP_IF_EXPRESSIONS` "currently EMPTY," `strict: false` "decision intentionally still pending," the WIN-STACK / DPAPI "verification pending" notes, and multiple "temporary — delete when MSRV ≥ 1.88" markers. A structural extraction that faithfully moves the *text* can still strip the *currency signal* if a reader later trusts a moved doc as history when it actually encodes live state. Treat every "currently / pending / temporary / not-yet-wired / DOCUMENT-AS-IS" phrase as **operative state that stays in `CLAUDE.md`**, not narrative to extract.

---

## 5. Recognized cadence / process for auditing and pruning

- **Official Anthropic:** review "periodically," prune "regularly," and review when behavior goes wrong — **no fixed calendar interval.** Tools: `/doctor` (proposes trims of codebase-derivable content), `/context` (verify what actually loaded), and the per-line test *"Would removing this cause Claude to make mistakes?"* Keep the file in git so the team contributes. [memory page; best-practices page]
- **Continuous mechanical control (strongest anecdotal evidence):** RuleStack runs an every-session size monitor (warn 45 KB, alert 60 KB) and a **commit gate** rejecting broken/orphan skill references and unscoped rule files. This is better-evidenced than any calendar cadence. [RuleStack, 2026-08-18]
- **Calendar/trigger cadences (community, weaker):**
  - Quarterly baseline; audit sooner if the same correction recurs twice in a week or `/context` shows a material context share; per-sprint for large fast-moving repos. [Unblocked, https://getunblocked.com/blog/audit-fix-bloated-claude-md/]
  - ~30 min per sprint dedicated slot. [community]
  - Re-audit after each major model release ("prune model-coaching as models improve") — but **never assume a newer model makes a project-specific gotcha obsolete without testing.** [https://news.ycombinator.com/item?id=46256662]
- **PR-review-driven growth (official + community):** the highest-value additions come from code review — when a PR reveals an undocumented convention, add it. Conversely, Anthropic's Code Review reads `CLAUDE.md` and **flags when a PR makes a `CLAUDE.md` statement outdated** (bidirectional). [https://code.claude.com/docs/en/code-review ; Builder.io]

**Practical synthesis:** lightweight checks every commit (size tripwire + reference integrity), investigate behavioral signals immediately, and a human semantic audit at least quarterly (or per-cycle given this repo's velocity), plus a model-release review.

---

## 6. Does our proposed approach match the recommended way — or is there something better?

### Point-by-point scoring of our proposal

| Our proposal element | Verdict | Basis |
|---|---|---|
| Extract historical narrative into `docs/specs/*.md` | ✅ Best practice | Official "move reference content out"; RuleStack moved glossaries/decisions/history to `docs/` + verbatim archive |
| Keep only concise operative rules + one-line pointers | ✅ Best practice | Official "root = pointers + critical gotchas only"; Willow-Voice tiered layering |
| Preserve all citations / load-bearing knowledge | ✅ Best practice, ⚠️ execution risk | "Relocate don't erase" is correct; but see §4 intent/state risk |
| Do it via branch + PR | ✅ Best practice | Official "check into git, review like code"; Dometrain/Builder.io |

### The closest documented precedents to our exact situation

- **RuleStack: 548 KB / 2,200+ lines → 34 KB.** Kept a priority table, hard prohibitions, session-critical decisions, and trigger rows naming the owning skill. Moved 9 runbooks → skills; conventions → path-scoped rules; glossaries/decisions/history → `docs/`; **archived the entire pre-migration text verbatim.** Explicitly rejected `@imports` as a compaction tool. Diffed old vs new obligations; commit gate caught a real dangling reference. **Strongest public account** — but self-reported, and its own pause-state incident proves diffs can't validate intent. [https://dev.to/rulestack/we-cut-our-claudemd-from-548kb-to-34kb-what-loads-when-measured-and-the-commit-gate-that-keeps-1kpk]
- **MTK / issue #9959: root 497 → 287 lines (42%)** plus five domain docs (~3,000 lines) with an **index saying when to consult each** — almost exactly our "extract + pointer index" shape. Weak validation (self-reported, no PR, issue closed "not planned"). [https://github.com/anthropics/claude-code/issues/9959]
- **Glasswerks: 329 → 162 lines**, ~170 lines moved to skills/commands. Kept identity, stack/commands, permissions, branch protection, and **rules whose violation would be irreversible.** Reported two real failures: vague skill descriptions left half the skills unused, and a *shared* rule change broke another project's build. [https://zenn.dev/glasswerks/articles/claudemd-skills-commands-pattern?locale=en]

Our approach is the same shape as all three. **We are not missing a fundamentally better strategy.**

### Four refinements to add (this is the "materially better" delta)

1. **Use on-demand pointers, NOT `@import`, for the extracted history.** Backticked path + "read `docs/specs/ci-gate-history.md` when modifying the CI gate." `@import` would keep the tokens loaded and defeat the exercise (§2). *(Highest-value change.)*
2. **Capture behavioral before/after probes.** Before merging, run a handful of fresh-session tasks that exercise the highest-value gotchas being relocated (e.g., "add a required CI job," "edit an attachment download path," "add a new `JR_*` seam"). Re-run them post-change and require equal-or-better behavior. Byte reduction alone is not success (§3, §4).
3. **Add a reference-integrity check + size tripwire to CI.** This repo already has `tests/claude_md_citations.rs` validating backtick-quoted file paths resolve — extend that discipline to the new `docs/specs/*` pointers (bidirectional: pointer→file exists, and each extracted doc is pointed at). Add a soft line/byte warning threshold. This matches RuleStack's commit-gate and fits this repo's existing guard culture.
4. **Do not extract live-state prose.** Everything phrased as "currently EMPTY / pending / temporary / not-yet-wired / DOCUMENT-AS-IS / verification pending" is operative state and **stays in `CLAUDE.md`** (§4 ⚠️). Extract only genuinely-completed narrative (the round-by-round CI-Gate *history*, per-bug post-mortems for landed fixes), leaving behind the concise operative rule + a pointer to the full history.

### What to keep vs. move (concrete guidance for this repo)

- **KEEP (operative, every session):** the architecture `src/` map (or slim it and point to a doc), Conventions, Output-channel profiles, exit-code semantics, the `JR_*` env-var seam table (it is a lookup the agent uses), the ADR *index* (one line each), and the *distilled* operative CI-gate rules. Keep all "currently/pending/temporary" state markers.
- **MOVE to `docs/specs/*.md` with on-demand pointers:** the full CI-Gate round-1-through-round-20 + S-CIGATE-3 fix-burst narrative; the long per-bug "Gotchas" post-mortems for already-landed work (ADF footnote/panel/task-list internals, attachment CWE narrative, bulk-schema war stories) — keep a one-line rule + "see `docs/specs/…`."
- **CONSIDER path-scoped rules:** conventions that only apply under `tests/` (e.g., CI-gate test-authoring rules) or `src/adf.rs`.
- **Preserve a verbatim archive** of today's `CLAUDE.md` (git history suffices, but a dated `docs/specs/claude-md-archive-2026-09-10.md` improves mid-task discoverability, per RuleStack).

---

## Verdict

**Our proposed approach IS best practice.** Extract-to-`docs/specs`, keep concise operative rules + pointers, preserve citations, execute via branch + PR — this matches official Anthropic guidance (root = pointers + critical gotchas, <200 lines, move reference content out, version-control and review like code) and the strongest community case studies (RuleStack 548 KB→34 KB, MTK 497→287, Glasswerks 329→162).

**Change/add these four things:**
1. Extracted history must be reached via **plain on-demand pointers, never `@import`** (or it saves no context).
2. Add **before/after behavioral probes** in fresh sessions; don't judge success by byte count.
3. Add a **reference-integrity check + size tripwire** to CI (extend the existing `tests/claude_md_citations.rs` discipline; mirror RuleStack's commit gate).
4. **Do not extract live-state prose** ("currently/pending/temporary/DOCUMENT-AS-IS") — that is operative state, not history; leaving it behind is the one failure mode a faithful text-move can still cause.

**Confidence:** High that the *direction* is correct and officially endorsed. Moderate on *magnitude* of benefit — no published controlled trial measures removing historical narrative from a `CLAUDE.md`, and the sharpest reduction figures are practitioner anecdote. That gap is exactly why refinement #2 (measure our own before/after) matters.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | (a) official + community size guidance, `@import`/nested/rules semantics, alternatives; (b) empirical evidence on long-context / instruction-following degradation + token/cost/latency; (c) trimming failure modes, audit cadence, and documented compaction case studies |
| Perplexity perplexity_search | 1 | Raw ranked URLs cross-validating the extract-to-docs + PR-review pattern (Builder.io, Willow Voice, Anthropic large-codebases blog, Dometrain, Code Review docs) |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not applicable — this is a practice/guidance topic, not a library API |
| Tavily (all) | 0 | Perplexity coverage was sufficient and self-cross-validating (official docs + multiple independent case studies agreed) |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 2 areas (flagged) | (1) General framing of context-window mechanics; (2) awareness that this repo already has `tests/claude_md_citations.rs` (verified against the provided CLAUDE.md, not asserted from training) |

**Total MCP tool calls:** 4 (3 `perplexity_research` at high depth + 1 `perplexity_search`)
**Training data reliance:** low — every substantive claim is tied to a dated URL; official Anthropic guidance is explicitly separated from community anecdote throughout, and thin/confounded evidence is flagged rather than overstated.

### Primary source index (most-cited)

- Anthropic — Claude Code memory doc (official): https://docs.anthropic.com/en/docs/claude-code/memory / https://code.claude.com/docs/en/memory
- Anthropic — Best practices (official): https://code.claude.com/docs/en/best-practices ; engineering post (2025-04-18): https://www.anthropic.com/engineering/claude-code-best-practices
- Anthropic — Large-codebases blog (2026-05-14): https://claude.com/blog/how-claude-code-works-in-large-codebases-best-practices-and-where-to-start
- Anthropic — features-overview / skills / sub-agents / costs / code-review / token-counting (official docs, retrieved 2026-09-10)
- RuleStack case study (2026-08-18): https://dev.to/rulestack/we-cut-our-claudemd-from-548kb-to-34kb-what-loads-when-measured-and-the-commit-gate-that-keeps-1kpk
- MTK issue #9959: https://github.com/anthropics/claude-code/issues/9959 ; Glasswerks: https://zenn.dev/glasswerks/articles/claudemd-skills-commands-pattern?locale=en
- Over-pruning failure case (2026-07-26): https://dev.to/pponali/we-audited-our-claude-code-setup-against-anthropics-own-context-engineering-rules-heres-what-we-3mme
- Unblocked audit process: https://getunblocked.com/blog/audit-fix-bloated-claude-md/ ; HumanLayer (2025-11-25): https://www.humanlayer.dev/blog/writing-a-good-claude-md
- Research: Lost in the Middle https://arxiv.org/abs/2307.03172 · RULER https://arxiv.org/abs/2404.06654 · NoLiMa https://arxiv.org/abs/2502.05167 · Chroma Context Rot https://www.trychroma.com/research/context-rot · AGENTIF (NeurIPS 2025) · IFScale https://arxiv.org/abs/2507.11538 · LIFBench https://arxiv.org/html/2411.07037v1 · Multi-IF https://arxiv.org/abs/2410.15553
