# Research: Bare-URL Autolink Scope for `markdown_to_adf` (issue #473)

**Date:** 2026-06-09
**Type:** general (technology / implementation scoping)
**Status:** complete
**Question:** Which bare-URL forms should `markdown_to_adf` (src/adf.rs, pulldown-cmark 0.13) detect and convert to ADF `link` marks via a post-processing pass?

---

## TL;DR Recommendation

**Adopt scope (A): `http://` / `https://` explicit-scheme only.** Add `www.` (scope B) only if you also handle the http-vs-https ambiguity, and treat bare-email (scope C) as out of scope for v1.

The decision pivots on **Finding #3**, which is **CONFIRMED**: when ADF is submitted via the Jira Cloud REST API (`POST /rest/api/3/issue`, `description`/comment body), Jira does **NOT** auto-linkify a bare URL sitting as plain text inside a `text` node with no `link` mark. The mark is **required** for the URL to be clickable. So this feature is genuinely needed (not redundant) — but precisely *because* it's needed, the false-positive cost is real: any over-match permanently writes a wrong/ugly link into the user's issue. That argues for the **narrowest scope that covers the common case** (someone pasting `https://…` into a description), which is explicit-scheme.

---

## Finding 1 — GFM "Autolinks (extension)" exact rules

Source: GFM spec §6.9 "Autolinks (extension)" (github.github.com/gfm) and the micromark reference implementation. [1][2][3]

**(a) Schemes / prefixes linkified.** Three autolink classes:
- **Extended URL autolink:** one of `http://`, `https://`, or `ftp://`, followed by a *valid domain*, then zero or more non-space, non-`<` characters. [1][3]
- **Extended www autolink:** literal `www.` followed by a *valid domain* (no scheme in source). [1][3]
- **Extended email autolink:** a bare email address recognized in any text node. [1][3]
- NOT linkified: bare domains with no scheme and no `www.` (e.g. `example.com`), scheme-relative `//example.com`, relative URLs. [1][3]

**(b) Trailing-punctuation trimming.** Trailing `?`, `!`, `.`, `,`, `:`, `*`, `_`, `~` are **excluded** from the autolink (they may appear in the *interior*). [1] Parenthesis balancing: a trailing `)` is excluded **if** there is no matching unclosed `(` earlier in the link — i.e. count `(` vs `)`; a final `)` is kept only when it balances an opening `(` inside the URL (so `https://en.wikipedia.org/wiki/Foo_(bar)` keeps the `)`, but `(see https://example.com)` drops it). [1]

**(c) Boundary / preceding char.** An extended autolink is recognized only at the **start of a line, after whitespace, or after one of `*`, `_`, `~`, `(`**. [1] (micromark's `wwwAutolinkBefore` also admits `[`, `]`, eof, eol, tab. [2]) A hyphen or other letter immediately before does **not** start an autolink (`text-http://x` → no link; `prefixhttp://x` → no link). [1][2]

**(d) `www.` scheme + valid-domain constraint.** A `www.` autolink gets **`http://`** prepended (NOT https — historical default). [1][2] *Valid domain* = segments of alphanumerics, `_`, and `-` separated by `.`; **at least one `.` required**; **no `_` in the last two segments**. So `www.commonmark.org` → `http://www.commonmark.org`; `wwwlocalhost` (no dot) is not a www autolink. [1]

**(e) Email autolink form + href.** Recognizes a bare email; generated href is **`mailto:` + address**, visible text stays bare. [1][2] Constraints (HTML5-derived): local part allows alphanumerics + `.`, `-`, `_`, `+`; domain must contain `.`; the last char before `@` and the final domain char have restrictions; a domain label may not end in `-` or `_`. Trailing-punctuation and boundary rules apply equally. [1][2] **INCONCLUSIVE:** the GFM spec text does not publish the full regex; the exact email pattern is inferred from micromark/HTML5, not quoted verbatim. Treat the email pattern as the highest-risk class to re-implement.

---

## Finding 2 — Bare-URL linkification BY DEFAULT in mainstream converters

What users *expect* depends heavily on which tool/platform shaped their habits. Default behavior (NO extension/option enabled): [4]

| Converter | Bare `http(s)://` linkified by default? | `www.` | Bare email | How to turn on |
|-----------|------------------------------------------|--------|------------|----------------|
| **CommonMark reference** | **No** — only `<…>` angle-bracket autolinks | No | No | n/a (not in core spec) [4] |
| **remark / unified (mdast)** | **No** (follows CommonMark) | No | No | `remark-gfm` adds GFM autolink literals [4] |
| **markdown-it** | **No** by default | No | No | `linkify: true` (uses `linkify-it`); off by default [4] |
| **Pandoc** | Dialect-dependent: `autolink_bare_uris` extension; **on for `gfm`**, **off for strict `commonmark`** | via ext | via ext | `-f markdown+autolink_bare_uris` [4] |
| **pulldown-cmark 0.13** | **No** — no autolink-literal flag at all | No | No | Not supported; must post-process [5][6] |

**Takeaway:** "plain" Markdown (CommonMark, remark core, markdown-it default, pulldown-cmark) does **not** linkify bare URLs. The expectation that it *should* comes almost entirely from **GitHub/GFM** and from chat apps (Slack/Discord). Since `jr` users are pasting into a Jira issue and likely think "GitHub-style," they expect at least `https://…` to become a link; `www.` is a weaker expectation; bare emails weaker still. [4]

---

## Finding 3 — Jira Cloud ADF rendering of bare URLs (THE decisive finding)

**CONFIRMED: an explicit `link` mark is REQUIRED. Jira does NOT auto-linkify plain-text URLs in ADF submitted via the REST API.**

Evidence:
- Atlassian developer-community thread on creating issue descriptions via REST API: the working solution is a `text` node carrying a `marks: [{ "type": "link", "attrs": { "href": "https://website.com" } }]`. Plain text does not become a link; you must supply the mark. [7]
- Atlassian's own ADF docs treat `link` as a mark you apply, and `inlineCard` (smart link) as a *separate node* you must construct — neither is derived automatically from plain text on the API path. [Atlassian ADF structure/inlineCard docs, via 7]
- **Smart-links / auto-unfurl are a browser-editor composition-time feature only.** Multiple Atlassian community/Jira-issue sources describe the conversion happening *as you type/paste* in the editor, reversible with Cmd/Ctrl+Z, and governed by per-user "Link preferences" — i.e. client-side, not a server render-time pass. [8][9] None of that machinery runs on ADF JSON arriving through `/rest/api/3/issue`.
- Corroborating community report: Figma links posted *via the Jira API* render as "just a regular link," not smart links — confirming the API path does no smart-link upgrade. [10]

**Implications for #473:**
1. The feature is **not redundant** — without our mark, a pasted `https://…` in a description stays dead text. Implementing the post-process pass is justified.
2. **Low double-linking risk** on the API path: since Jira does not linkify plain text server-side, our `link` mark won't collide with a Jira-applied one. The smart-link/inlineCard upgrade path is an *interactive editor* behavior; it does not retro-fit marks we submit. A user who later *edits* the issue in the browser may see Jira offer to upgrade our `link` to a smart card, but that's user-initiated, not a conflict we create.
3. **CAVEAT (single-line vs multi-line / field-type variance):** JRACLOUD-76802 documents that *in the editor*, only `http/https/ftp/mailto` schemes render as links and behavior differs between single-line and multi-line fields. [11] This is editor-render behavior, not the API ADF-mark path, but it reinforces that sticking to `http/https` (the universally-rendered schemes) is the safe set.

---

## Finding 4 — False-positive risk of broad matching

Documented pitfalls of regex URL/`www.`/email detection in prose: [1][4][6]
- **Sentence-ending domains / abbreviations:** `e.g.`, `i.e.`, `etc.`, `vs.` — a naive `\w+\.\w+` matches these as domains. The GFM `www.`-prefix requirement and "valid domain needs a real TLD-ish segment" rule exist precisely to suppress this, but a bare-domain matcher would fire on all of them.
- **Version strings:** `1.2.3`, `v0.13.0`, `pulldown-cmark 0.13` — match as `domain.tld` under loose rules. (Directly relevant: this very codebase writes version-like strings in descriptions.)
- **File paths / module paths:** `src/adf.rs`, `a.b.c`, `foo.bar()` — dotted tokens that look domain-ish.
- **Trailing punctuation:** `see https://example.com.` must not eat the `.`; `(https://example.com)` must not eat the `)` — requires the GFM trimming + paren-balancing logic, not a greedy `\S+`.
- **Boundary leakage:** matching `http://` mid-word (`xhttp://`) or inside already-formed `[text](url)` / `<url>` autolinks → double-wrapping. The pass MUST skip text that is already inside a `link` mark (angle-bracket autolinks and `[](…)` already produce marks in our converter — re-matching them would double-link).
- **Email over-match:** `user@host` with no dot, `@mention` handles, `a@b` — the email class is the noisiest; restricting to `local@domain.tld` still catches code like `@param`-adjacent text in some prose.

**Scope that minimizes false positives while covering the common case:** require an **explicit `http://`/`https://` scheme**. A literal scheme is an unambiguous, intentional signal — almost nobody types `https://` except to mean a URL. This eliminates the `e.g.` / version-string / file-path classes entirely (none carry a scheme). `www.` reintroduces moderate risk (still gated by the valid-domain dot rule); bare email reintroduces the most.

---

## Finding 5 — Recommendation

**Recommended scope: (A) `http://` / `https://` explicit-scheme only** for v1, with a clean extension path to (B).

Rationale weighted by the three axes:

| Axis | (A) http(s):// only | (B) + www. | (C) + bare email |
|------|--------------------|-----------|-----------------|
| Covers common Jira-paste case | **Yes** (pasted full URLs are ~always schemed) | Yes + bare `www.` | Yes + emails |
| False-positive risk | **Lowest** (scheme is intentional) | Moderate (needs valid-domain + dot rule; risks `e.g.`-class if implemented loosely) | **Highest** (email regex is the noisiest; GFM doesn't even publish it — Finding 1e INCONCLUSIVE) |
| Implementation complexity | **Lowest** — match `https?://…`, apply GFM trailing-trim + paren-balance, skip text already under a `link` mark | +www scheme-insertion (`http://` per GFM) + valid-domain check | +email pattern you must source/verify yourself |
| Needs the mark at all? (Finding #3) | **Yes** — Jira won't linkify it otherwise | Yes | Yes |
| Round-trip / reverse path (`adf_to_text`) | Trivial — `link` mark href == text, emits bare URL back | Same | `mailto:` prefix must be stripped on reverse to round-trip |

**Why not go straight to GFM parity (B/C):**
- The marginal user benefit of `www.`/email is small for a CLI whose dominant input is full pasted URLs.
- `www.` forces a product decision GFM made in 2014 that's now wrong: GFM prepends **`http://`**, not `https://` [1]. Shipping http-by-default links into 2026 Jira issues is a footgun (mixed-content warnings, redirects). If you do (B), **deviate from GFM and prepend `https://`** — but document the deviation, because it breaks GFM parity and your round-trip can't recover the original `www.` form.
- The email class is the highest false-positive risk *and* the one place the GFM spec is **INCONCLUSIVE** (no published regex). Re-implementing it correctly is disproportionate effort for a CLI.

**Concrete implementation guidance (regardless of A/B):**
1. Run the pass over **already-produced ADF text nodes**, and **skip any text node already carrying a `link` mark** — angle-bracket `<…>` autolinks and `[text](url)` already become marks upstream; do not re-match them (prevents double-linking; Finding 4).
2. Apply GFM trailing-punctuation trimming (`?!.,:*_~`) and the parenthesis-balancing rule (Finding 1b) — do NOT use a greedy `\S+`.
3. Honor GFM boundary rules: only start a match at line-start, after whitespace, or after `*_~(` (Finding 1c) to avoid mid-word `xhttp://` matches.
4. For scope (A), a defensible matcher is scheme-anchored: `https?://` + non-space run, then trim. Avoid the loose `((https?|ftp)://|www.)…` regex floated in pulldown issue #494 [6] — its bare `www.` arm and unescaped `.` widen the false-positive surface.
5. Set the `link` mark `attrs.href` to the trimmed URL; leave the visible text as the trimmed URL (matches GFM and keeps `adf_to_text` round-trip lossless for scope A).
6. Add property/snapshot tests for the false-positive classes in Finding 4 (`e.g.`, `1.2.3`, `src/adf.rs`, sentence-final URL with `.`, balanced/unbalanced parens, URL already inside `[](…)`).

**Defer / out of scope for v1:** bare `www.` (scope B) and bare email (scope C). Revisit `www.` if users report it; keep email out until there's demand, given the spec-inconclusive pattern and high noise.

---

## Confidence & Open Items

- Finding 1 (GFM rules): **High** — quoted from the GFM spec, except the **email regex (1e) is INCONCLUSIVE** (spec doesn't publish it; inferred from micromark/HTML5).
- Finding 2 (converter defaults): **High** — consistent across official docs for all five tools.
- Finding 3 (Jira API needs the mark; no double-link risk): **High** — multiple independent Atlassian developer-community + Jira-issue sources agree; smart-links are editor-only.
- Finding 4 (false positives): **High** — well-documented, directly observable in this codebase's own content.
- Finding 5 (recommendation): **High** confidence in (A); the `https://`-vs-`http://` deviation note for (B) is a product call, flagged not decided.

---

## References

1. GFM spec §6.9 Autolinks (extension) — https://github.github.com/gfm/#autolinks-extension- (mirror: https://www.uv.es/hmr/pruebas/pruwiki/markdown/gfm_spec.wiki)
2. micromark-extension-gfm-autolink-literal — https://github.com/micromark/micromark-extension-gfm-autolink-literal
3. mdast-util-gfm-autolink-literal — https://github.com/syntax-tree/mdast-util-gfm-autolink-literal
4. Converter-default behavior synthesis (CommonMark spec; remark-gfm; markdown-it `linkify`; Pandoc `autolink_bare_uris`; pulldown-cmark) — per Perplexity deep-research run 2026-06-09 citing https://spec.commonmark.org/ , https://github.com/remarkjs/remark-gfm , https://github.com/markdown-it/markdown-it , https://pandoc.org/MANUAL.html#extension-autolink_bare_uris
5. pulldown_cmark::Options (0.13) — https://docs.rs/pulldown-cmark/latest/pulldown_cmark/struct.Options.html (ENABLE_GFM = blockquote alert tags only; no autolink-literal flag)
6. pulldown-cmark issue #494 "Automatic links?" — https://github.com/pulldown-cmark/pulldown-cmark/issues/494 ("not supported by pulldown directly … exercise in text search")
7. Post HTML Issue Description with JIRA REST API v3 (link mark required; ADF example) — https://community.developer.atlassian.com/t/post-html-issue-description-with-jira-rest-api-v3/38482
8. Clickable link in free text field (smart-link is editor-side; Cmd/Ctrl+Z reverts) — https://community.atlassian.com/forums/Jira-Service-Management/Clickable-link-in-free-text-field/qaq-p/1721062
9. JSWCLOUD-21494 user Link preferences (smart-link default is interactive-insert behavior) — https://jira.atlassian.com/browse/JSWCLOUD-21494
10. Create smart links via Jira API (Figma links via API render as plain links, no smart-link upgrade) — https://community.developer.atlassian.com/t/create-smart-links-via-jira-api/46820
11. JRACLOUD-76802 (only http/https/ftp/mailto schemes render as links in editor; single- vs multi-line variance) — https://jira.atlassian.com/browse/JRACLOUD-76802

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | (1) Jira Cloud ADF bare-URL rendering / smart-link API behavior [Finding 3]; (2) full GFM autolinks-extension spec rules [Finding 1]; (3) mainstream converter default bare-URL behavior [Finding 2] |
| Perplexity perplexity_search | 2 | Cross-validation of Finding 3 (Jira API link-mark requirement) and Finding 5/pulldown-cmark 0.13 autolink flag absence |
| Context7 | 0 | — (pulldown 0.13 Options confirmed via docs.rs in search results) |
| Tavily | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 1 area | Background framing of regex false-positive classes (Finding 4) — corroborated against cited sources, not relied on for any version/spec claim |

**Total MCP tool calls:** 5 (3 perplexity_research + 2 perplexity_search)
**Training data reliance:** low — every load-bearing claim (GFM rules, converter defaults, Jira API behavior, pulldown 0.13 flag set) is cited to a primary or community source; training data only framed the false-positive narrative, which is independently corroborated.
