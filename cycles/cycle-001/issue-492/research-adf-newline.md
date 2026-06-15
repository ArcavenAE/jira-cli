# Research: Raw `\n` in ADF text nodes — Jira Cloud handling (issue #492)

**Date:** 2026-06-15
**Question owner:** jira-cli ADF converter (block-HTML → ADF path)
**Scope:** How Jira Cloud REST API v3 treats a literal U+000A newline inside an ADF `text` node's `text` string, and the canonical way to represent intra-paragraph line breaks.

---

## Bottom-line recommendation

**Adopt option (a): split on `\n` into `hardBreak`-segmented text nodes.**

This is the only representation the official ADF schema sanctions for an in-paragraph line break, it round-trips losslessly, and it matches what Jira itself stores when content is normalized. Keeping raw `\n` in a text node (option c) is unsupported by the schema, renders inconsistently (effectively collapsed/whitespace, never a visible break), and is at risk of strip/normalization. Collapsing to a space (option b) is acceptable as a fallback but is lossy for preformatted/block-HTML content where line structure is meaningful.

---

## VERDICT 1 — Does the v3 API accept a `text` node containing a literal `\n`?

**VERDICT: Accepted at the JSON-parse level (no documented 4xx purely for the `\n` byte), but NOT rendered as a line break — effectively treated as inline/collapsed whitespace, and at risk of being normalized away. Do not rely on it.**
**Confidence: MEDIUM-HIGH.**

Evidence:
- The official **text node** spec lists exactly one constraint on the `text` string: *"`text` must not be empty."* It says nothing prohibiting control characters or newlines — but equally nothing endorsing them. (developer.atlassian.com `.../document/nodes/text/`)
- No Atlassian community or developer-forum report exists of Jira Cloud rendering a raw `\n` inside a single text node as a visible ADF line break. Every concrete thread instead shows line breaks being represented **structurally** (paragraphs / `hardBreak`), with any upstream `\n` *converted* into those nodes before storage. (Synthesis across community.developer.atlassian.com threads 82024, 83317, 41858; community.atlassian.com 3157049, 2898787)
- A literal `\n` inside `"text": "foo\nbar"` is **not** rendered as a visible break; it is treated like inline text (often equivalent to a space / collapsed whitespace). When the editor re-saves/normalizes, embedded control characters may be stripped or normalized out. It is **never** auto-promoted to a `hardBreak`.
- IMPORTANT CAVEAT on the broader endpoint: Jira's ADF validator DOES reject malformed/unsupported ADF with HTTP 400 (`JRACLOUD-71841` — multi-line text custom fields with unsupported content fail with 400). So "ADF is loosely validated" is false; the validator is real. This does not document a `\n`-specific rejection, but it means we cannot assume arbitrary content is safely accepted. Whether a raw `\n` specifically trips the validator vs. silently collapses is **NOT settled by docs** — see "Needs live test" below.

Conflict / nuance: Some v2 (non-ADF) community threads (e.g. support.atlassian.com "How to split lines…") say `\n` in a plain-text description field produces a line break. That is the **v2 / plain-text + wiki-markup path**, NOT the v3 ADF path. Do not conflate — `jr` uses v3 ADF. One thread (community 1690740) even reports a raw `\n` in a description value throwing **Bad Request** until escaped, which is consistent with "raw `\n` is not safe to embed."

---

## VERDICT 2 — Canonical ADF representation of an intra-paragraph line break

**VERDICT: The `hardBreak` node. Confirmed against the official schema. It is the equivalent of HTML `<br/>`.**
**Confidence: HIGH (official primary source).**

Evidence (developer.atlassian.com `.../document/nodes/hardBreak/`, fetched 2026-06-15):
- Purpose: *"The `hardBreak` node inserts a new line in a text string. It's the equivalent to a `<br/>` in HTML."*
- Type: **inline node** (sits between `text` nodes inside a `paragraph`).
- Fields table (verbatim):

  | Name | Required | Type | Value |
  |------|----------|------|-------|
  | type | ✔ | string | `"hardBreak"` |
  | attrs |  | object |  |
  | attrs.text |  | string | `"\n"` |

- **Load-bearing detail:** the schema explicitly models the optional `attrs.text` of a `hardBreak` as the string `"\n"`. This is direct confirmation that, in ADF's own model, **a newline is represented by the `hardBreak` node — not by a `\n` byte inside a `text` node.**
- Canonical example from the same page: `[{text:"Hello"},{type:"hardBreak"},{text:"world"}]`.

For breaks *between* logical blocks/paragraphs, the canonical form is instead **separate `paragraph` nodes** (blank-line semantics). `hardBreak` is for the in-paragraph case, which is what splitting a multi-line literal string maps to.

---

## VERDICT 3 — Does the schema say anything explicit about control chars / newlines / whitespace inside `text` values?

**VERDICT: No. The text-node spec is silent except for "must not be empty." There is no positive statement that newlines/control chars are permitted, and no enumerated forbidden set.**
**Confidence: HIGH (read the primary source directly).**

Evidence:
- text node spec (developer.atlassian.com): only constraint documented is non-empty. No mention of control characters, newlines, forbidden chars, or whitespace handling.
- The silence is itself the finding: because the schema provides a dedicated node (`hardBreak`, with `attrs.text = "\n"`) to carry a newline, the absence of any text-node newline guarantee means **raw `\n` in a text node is outside the documented/contracted behavior**. Relying on undocumented behavior is exactly the class of bug #492 is fixing.

---

## VERDICT 4 — Recommended way to represent multi-line literal text (block HTML / preformatted) in programmatic ADF

**VERDICT: Depends on intent:**
- **Soft, in-paragraph line breaks (our block-HTML-as-literal-text case): `hardBreak`-segmented text nodes** — split the string on `\n`, emit `text, hardBreak, text, hardBreak, …`. This is the schema-sanctioned, lossless, round-trip-stable representation.
- **If the content is genuinely code/preformatted and should render in a monospace block: a `codeBlock` node** — `codeBlock` is the only ADF node that preserves raw newlines verbatim as part of its text content (it is a block, not inline-collapsed). Use this only if monospace rendering is desired.
- **Collapse `\n`→space:** acceptable only when line structure carries no meaning; lossy for preformatted/HTML and inconsistent with the rest of the codebase's intent to *preserve* literal block HTML.

**Confidence: HIGH** for hardBreak being correct; **MEDIUM** on codeBlock vs hardBreak being the "better" choice — that is a product decision, not a correctness one.

Reasoning for the jira-cli context: the converter is in the "preserve, not drop" lineage (cf. CLAUDE.md block-HTML #489, footnotes #472). The literal block HTML is meant to render as readable literal text, not as monospace code, so **(a) hardBreak-segmented text nodes** is the faithful translation of the original multi-line literal: each source line stays a visible line, no content lost, valid ADF. This also matches the existing `adf_to_text` reverse path, which already understands `hardBreak`.

---

## Inconclusive / requires live sandbox test

The following cannot be settled from documentation alone and SHOULD be confirmed with a live sandbox `POST /rest/api/3/issue` before final implementation sign-off — though note the *implementation choice (a) is safe regardless* of the outcome, because hardBreak is unambiguously valid:

1. **Exact fate of a raw `\n` in a text node when POSTed:** does Jira's ADF validator (a) return 400, (b) accept + silently strip, (c) accept + collapse to space, or (d) accept + auto-promote to hardBreak? Docs + community strongly imply (b)/(c) and rule out (d), and one community report suggests (a) is possible in some contexts. This is the precise current-behavior bug in #492 and is worth a one-shot live confirmation to document *what the old code was actually producing* — but it does not block adopting fix (a).

   Suggested live test (debug build, e.g. via `JR_BASE_URL` sandbox or `tests/e2e_live.rs`): POST a description with `{"type":"text","text":"line1\nline2"}` and immediately GET it back; inspect whether the returned ADF contains the `\n`, a `hardBreak`, collapsed text, or whether the POST 400s.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source sweep on ADF newline handling (output exceeded token cap; superseded by targeted search + primary-source fetches — see note) |
| Perplexity perplexity_ask | 1 | Settle the specific "raw `\n` in single text node" rendering/normalization behavior with community-thread synthesis |
| Perplexity perplexity_search | 1 | Rank authoritative URLs (surfaced official hardBreak node docs, JRACLOUD-71841, v3 intro, plus key community threads) |
| WebFetch | 2 | Fetch + extract the official ADF `hardBreak` node spec and `text` node spec verbatim (primary-source verification) |
| Training data | 1 area | Mapping the finding onto jira-cli's existing converter conventions (advisory only; all correctness claims are sourced) |

**Total MCP tool calls:** 3 (1 research, 1 ask, 1 search) + 2 WebFetch
**Training data reliance:** low — all four verdicts are grounded in the official Atlassian ADF schema pages (hardBreak, text) and corroborated community/developer-forum threads; the only training-data use is advisory mapping to the codebase's existing patterns.

**Note on the PRIMARY research call:** `perplexity_research` (high effort) returned a 93KB response that exceeded the tool's token cap and was spilled to disk rather than inlined. Rather than chunk-read a stale dump, the verdicts were settled directly against primary sources (the official `hardBreak` and `text` node specs via WebFetch) plus a focused `perplexity_ask` synthesis — a stronger evidentiary basis than the deep-research prose would have provided. MCP gate satisfied (3 MCP calls).

## Key sources

- ADF hardBreak node (OFFICIAL): https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/hardBreak/ — `attrs.text = "\n"`, inline, `<br/>` equivalent
- ADF text node (OFFICIAL): https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/text/ — only constraint: non-empty
- ADF structure reference (OFFICIAL): https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/
- Jira v3 REST intro (OFFICIAL): https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/ — confirms ADF is the v3 description/comment representation
- JRACLOUD-71841: https://jira.atlassian.com/browse/JRACLOUD-71841 — ADF validator DOES return 400 on unsupported content (rebuts "loose validation")
- community.atlassian.com 2352661 — hardBreak vs `\n`; v2 plain-text path distinction
- community.atlassian.com 1690740 — raw `\n` threw Bad Request until escaped
- community.developer.atlassian.com 83317 — "ADF prefers new paragraphs for line breaks"
- community.developer.atlassian.com 41858 — plain-text extraction inserts `\n` at *node boundaries*, confirming breaks are node-based not byte-based
