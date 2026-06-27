# External Validation: ADF / Markdown Behavioral Contracts

**Date:** 2026-06-27
**Scope:** Corroborate or refute the externally-verifiable claims in newly-authored
behavioral contracts (BC-7.2.013, BC-7.2.014, cross-check BC-7.2.009) that characterize
how `jr` converts Markdown → Atlassian Document Format (ADF). These BCs will anchor
holdout/wiremock tests that POST ADF to the real Jira Cloud REST API, so a divergence
from Atlassian's actual contract would produce a wrong holdout.
**Authoritative sources prioritized:** developer.atlassian.com (ADF docs), CommonMark spec,
GFM spec (github.github.com/gfm), pulldown-cmark docs/source.

---

## Verdict Summary

| # | Claim | Verdict | Confidence |
|---|-------|---------|------------|
| 1 | ADF has NO native footnote node; map `[^1]` → plain `[1]` marker + appended section after `rule` (BC-7.2.013) | **CORROBORATED** | High |
| 2 | Jira REST API does NOT auto-linkify bare plain-text URLs in submitted ADF (BC-7.2.014) | **CORROBORATED** (empirical/inferential, not a single doc sentence) | Medium-High |
| 3 | Restrict autolinking to explicit `http(s)://`; www-hosts and bare emails out of scope; GFM-derived trailing-punct/paren rules (BC-7.2.014) | **CORROBORATED as a defensible conservative subset** — one factual divergence noted | High |
| 4 | ADF `link` mark = `{type:"link",attrs:{href:...}}`; five portable panelTypes info/note/success/warning/error (BC-7.2.014 / BC-7.2.009) | **CORROBORATED** | High |
| 5 | No 2025–2026 ADF change (footnote support, etc.) affecting claims 1–4 | **CORROBORATED** (no footnote node added; only feature-flagged "custom panel" experiment) | High |

No claim is refuted. One **risk flag** is raised under Claim 2 (renderer-vs-stored-ADF nuance) and one **factual divergence** under Claim 3 (`ftp://`). Details below.

---

## Claim 1 — ADF has no native footnote node — CORROBORATED

**What the BC asserts:** ADF defines no footnote node, so a markdown footnote reference
`[^1]` is preserved as a plain *unmarked* `[1]` text marker, and definitions are flushed
into an appended section after a `rule` divider.

**Findings (authoritative):**
- The official ADF node/mark inventory on developer.atlassian.com contains **no `footnote`
  node and no `footnote` mark** at any level. The complete documented sets are:
  - **Top-level block nodes:** `blockquote`, `bodiedSyncBlock`, `bulletList`, `codeBlock`,
    `expand`, `heading`, `mediaGroup`, `mediaSingle`, `orderedList`, `panel`, `paragraph`,
    `rule`, `syncBlock`, `table`, `multiBodiedExtension`.
  - **Child block nodes:** `blockTaskItem`, `extensionFrame`, `listItem`, `media`,
    `nestedExpand`, `tableCell`, `tableHeader`, `tableRow`.
  - **Inline nodes:** `date`, `emoji`, `hardBreak`, `inlineCard`, `mention`, `status`,
    `text`, `mediaInline`.
  - **Marks:** `backgroundColor`, `code`, `em`, `link`, `strike`, `strong`, `subsup`,
    `textColor`, `underline`.
  - None is `footnote`/`footnoteReference`. Atlassian docs publish one page per node/mark;
    there is no "Node – footnote" page.
- The closest construct, the `subsup` mark, is **purely visual** (super/subscript) and
  carries no reference→note linkage semantics. There is no schema-level way to bind a
  reference marker to a note body.
- Third-party tooling that needs footnotes (e.g. Sphinx Confluence Builder) treats them as
  a *workaround* — superscript references + bottom paragraphs — explicitly **because ADF has
  no footnote construct**, confirming the gap from the integration side.

**Assessment of our mapping:** "Preserve as a plain-text marker + appended definition
section" is exactly the class of workaround the ecosystem uses (generic nodes only). It is
schema-valid (uses `paragraph`, `rule`, plain `text`) and will not be rejected by Jira.
There is no Atlassian-recommended canonical footnote encoding to diverge from. **The BC
characterization is correct and holdout-safe.**

**Caveat (not a refutation):** Because the marker is plain unmarked text, a round-trip
through any ADF→other-format tool cannot recover footnote semantics — already acknowledged
in CLAUDE.md as a deliberate, accepted limitation. No action needed.

**Sources:**
- ADF structure / node-mark taxonomy: https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/
- Node – doc (lists supported nodes, last-updated 2026-03): https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/doc/
- ADF document viewer (schema, last-updated 2026-04): https://developer.atlassian.com/cloud/jira/platform/apis/document/viewer/
- Footnote-as-workaround corroboration (Sphinx Confluence Builder ADF handling).

---

## Claim 2 — Jira REST does NOT auto-linkify bare URLs in ADF — CORROBORATED (empirical)

**What the BC asserts:** Smart-link / auto-linkification is a browser-editor compose-time
feature only. A bare `http(s)://` URL submitted as plain text in an ADF body is not
clickable unless the caller applies an explicit `link` mark. This is the load-bearing
justification for the `autolink_bare_urls` pass.

**Findings (authoritative + community):**
- The Atlaskit editor's auto-conversion of typed/pasted URLs into `link` marks or Smart
  Link cards (`inlineCard`/`blockCard`/`embedCard`) is documented and discussed strictly as
  a **client-side, compose-time editor behavior**, governed by user link preferences,
  undoable with Ctrl/Cmd-Z, and configurable per-domain. None of this involves the REST API.
- The clearest direct evidence: developers POSTing issue descriptions via the v3 REST API
  with a bare (Figma) URL report it renders as a **regular/plain link, not a Smart Link**,
  and the accepted resolution is to **explicitly construct an `inlineCard` node in the ADF**.
  The server does not synthesize link structures from URL-shaped text.
- Atlassian's own developer docs **never state** that the REST API scans ADF text for URLs
  and adds `link` marks. The v3 API validates ADF structure and stores it as-is; malformed
  ADF is rejected (e.g. "Comment body is not valid!"), confirming the server's role is
  validate-and-store, not semantic enrichment.

**Important nuance / RISK FLAG for the holdout:**
The conclusion that **stored ADF is not mutated** is strong. However, sources note a
*renderer-level* possibility: a Jira view *might* visually linkify URL-shaped plain text at
display time in some surfaces, independent of the stored marks. This is a display heuristic,
not an ADF mutation.

→ **Implication for a wiremock/holdout that POSTs to real Jira and then GETs the issue:**
Assert on the **stored ADF structure returned by the API** (i.e. that `jr`'s submitted
`link` mark is present / round-trips), **not** on whether the URL "looks clickable" in a
browser. The BC's justification ("URL is unclickable without our mark") is correct at the
*document/structure* level, which is the level a holdour should test. Do not write a holdout
assertion that depends on Jira *adding* a link mark to a bare URL we submit — it won't, and
that is exactly why our pass exists. Conversely, do not assert that a bare URL we submit
without a mark is "not clickable in the UI," because renderer heuristics are undocumented and
could make that assertion flaky.

**Confidence:** Medium-High. The negative ("REST does not auto-linkify") is established by
the absence of any documentation to the contrary **plus** consistent positive evidence that
Smart Links require explicit nodes. It is inferential, not a single quotable sentence. For a
holdout, the safe and fully-supported assertion is the structural round-trip of our own
applied `link` mark.

**Sources:**
- ADF structure (link mark / smart-link node model): https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/
- "Create smart links via Jira API" — must use `inlineCard`; bare URL renders as regular link: https://community.developer.atlassian.com/t/create-smart-links-via-jira-api/46820 (and /46820/2)
- v3 description must be ADF: https://community.developer.atlassian.com/t/jira-rest-api-description-field/60902 ; https://community.developer.atlassian.com/t/post-html-issue-description-with-jira-rest-api-v3/38482
- v3 comment must be valid ADF (validate-and-store): https://community.atlassian.com/forums/Jira-questions/Jira-Cloud-REST-API-Unable-to-add-comment-via-ADF-receiving-quot/qaq-p/2808955
- Smart Links as editor/UI feature + link preferences: https://community.atlassian.com/forums/Jira-Service-Management/Clickable-link-in-free-text-field/qaq-p/1721062 ; https://jira.atlassian.com/browse/JRACLOUD-72429

---

## Claim 3 — Explicit-scheme-only autolinking is a defensible GFM subset — CORROBORATED (one divergence)

**What the BC asserts:** Autolinking is restricted to explicit `http(s)://` scheme only;
www-prefixed hosts and bare emails are out of scope; boundary and trailing-punctuation-trim
/ paren-balancing rules are GFM-derived.

**Findings vs the GFM "autolinks (extension)" spec (github.github.com/gfm):**
- GFM defines three categories of bare (non-angle-bracket) autolinks:
  1. **Extended www autolinks** — `www.` + valid domain; GFM auto-inserts `http` scheme.
  2. **Extended URL autolinks** — text begins with `http://`, `https://`, **or `ftp://`** + valid domain.
  3. **Extended email autolinks** — constrained local-part + domain pattern, recognized
     within *any* text (no leading-boundary restriction).
- **Boundary rule (corroborates our "start" rule):** extended www and URL autolinks may
  only **start at the beginning of a line, after whitespace, or after a defined set of
  delimiter characters**. (Our `*_~(`+whitespace+start "before" set is within this; our
  deliberate omission of `[` is a narrowing, documented in CLAUDE.md.)
- **Trailing-punctuation trim (corroborates):** GFM's "extended autolink path validation"
  trims trailing punctuation such as `? ! . , : * _ ~` from the end of the link.
- **Parenthesis-balancing (corroborates):** a trailing `)` is excluded only when the
  closing parens are **unmatched/unbalanced** within the link; balanced parens
  (e.g. `.../search?q=Markup+(business)`) are kept. This matches our "drop trailing `)`
  only when unbalanced" rule.

**Divergences from full GFM (all narrowing / conservative — defensible):**
1. **`www.`-prefixed hosts:** GFM links them (inferring `http`); **we do not.** Documented
   divergence; reduces false positives in prose. Defensible.
2. **Bare emails:** GFM links them (extended email autolink); **we do not.** Defensible.
3. **`ftp://`:** *(FACTUAL CORRECTION TO THE MENTAL MODEL, not a refutation)* GFM's extended
   URL autolinks recognize **`http://`, `https://`, AND `ftp://`**. The BC/CLAUDE.md says
   "explicit http(s):// scheme only," which **omits `ftp://`**. This is a further narrowing
   — still a valid conservative subset — but the phrase "GFM-derived" should not be read to
   imply we cover GFM's full URL-scheme set. If a holdout fixture ever includes an `ftp://`
   URL expecting a link, it would (correctly, per our design) NOT be linked. Recommended:
   note in the BC that `ftp://` is intentionally excluded so a future test author doesn't
   file it as a bug.

**Defensibility:** Every divergence is a *subset* (we link strictly fewer things than GFM).
CommonMark itself is "intentionally conservative" and does not autolink bare `www.`/emails;
our behavior sits between CommonMark (angle-bracket only) and full GFM, biased toward fewer
false positives — which is the right bias because an applied `link` mark permanently writes
a link into the user's issue. **The BC characterization is correct; recommend only the
`ftp://` clarification.**

**Sources:**
- GFM autolinks extension (schemes, www, email, path validation, trailing punctuation, paren balancing, starting boundaries): GFM spec §6.9 "Autolinks (extension)", https://github.github.com/gfm/#autolinks-extension-
- CommonMark autolinks (angle-bracket form, conservative scheme set) §6.5: https://spec.commonmark.org/

---

## Claim 4 — link-mark shape + portable panelTypes — CORROBORATED

**`link` mark shape:**
- ADF `link` is a **mark** (not a node), attached to inline nodes (typically `text`) via the
  `marks` array. Minimal shape is exactly `{"type":"link","attrs":{"href":"..."}}`.
- **`href` is the only required attr.** `title` is optional; other attrs (`id`, etc.) are
  implementation-specific and not part of the portable surface. This matches `@atlaskit/adf-utils`
  usage `link({href:'...'})(text('...'))`. **Our shape is correct.**

**panelType portability:**
- The Node – panel docs enumerate `attrs.panelType` as required and one of exactly:
  **`info`, `note`, `warning`, `success`, `error`.** These are the five portable values.
- **`tip` and `custom` are NOT documented Cloud values.** `custom` exists in Atlaskit's
  full schema but is **feature-flagged and not part of the public Cloud REST API surface**;
  `tip` is a legacy wiki-markup panel style with no documented ADF `panelType`. Using either
  risks schema validation errors / non-portability. **Our five-value portable set
  (info/note/success/warning/error) and our avoidance of tip/custom are correct.**
- Minor note: Node – panel docs say panel `heading`/`paragraph` content should carry **no
  marks**. CLAUDE.md already reflects this (`normalize_panel_content` strips node-level
  marks). Consistent.

**Sources:**
- ADF structure (mark model, link mark): https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/
- Node – panel (panelType enum + content constraints): https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/panel/
- `@atlaskit/adf-utils` link builder usage (community).

---

## Claim 5 — 2025–2026 ADF schema recency — CORROBORATED (no impact on claims 1–4)

- Core node/mark inventory has been **stable since the 2023 ADF overview**; node pages and
  the document viewer carry 2026 update timestamps and show the **same** node set — **no
  `footnote` node added, no deprecations** of the nodes/marks our claims rely on.
- ADF is still **version 1** (`doc.version == 1`); no v2 schema.
- The only relevant in-flight change is a **feature-flagged "custom panel"** in Atlaskit's
  full schema — **not** in the documented Cloud REST surface. This *reinforces* Claim 4's
  advice to stick to the five portable panelTypes; it does not change any claim.
- No footnote support introduced in any 2025–2026 update.

**Sources:** Node – doc (updated 2026-03), ADF document viewer (updated 2026-04),
`@atlaskit/adf-utils` changelog (custom-panel feature flag).

---

## Cross-cutting: the load-bearing pulldown-cmark premise — VERIFIED

CLAUDE.md states pulldown-cmark "has no autolink extension (`ENABLE_GFM` adds only alert
blockquotes, NOT GFM extended autolinks)," which is *why* the `autolink_bare_urls` post-pass
is required (claims 2+3 only matter if the parser doesn't already linkify).

**Verified:** pulldown-cmark 0.13.x does **not** implement GFM extended autolinks — bare
`https://example.com` does not become a link event regardless of options. `ENABLE_GFM`
currently gates only GitHub alert blockquotes (`[!NOTE]` etc.) and Obsidian-style wikilinks,
not autolinks. So the post-`finish()` autolink pass is genuinely necessary; the BC premise
holds.

**Sources:** https://docs.rs/pulldown-cmark/latest/pulldown_cmark/struct.Options.html ;
https://github.com/pulldown-cmark/pulldown-cmark ;
https://github.com/raphlinus/pulldown-cmark/issues/507

---

## Actionable recommendations before finalizing the BCs

1. **BC-7.2.014 — add an explicit `ftp://` exclusion note.** GFM's extended URL autolinks
   cover `http://`, `https://`, *and* `ftp://`. Our scope is `http(s)://` only. State this is
   a deliberate narrowing so a future test author doesn't treat an unlinkified `ftp://` URL
   as a defect, and so "GFM-derived" isn't misread as "GFM-complete."
2. **BC-7.2.014 — frame the holdout assertion at the ADF-structure level.** Assert that
   `jr`'s submitted `link` mark round-trips through `POST` + `GET` (the structure Jira stores
   and returns). Do NOT assert that Jira adds a link mark to a bare URL (it won't), and do NOT
   assert UI "clickability" of an unmarked URL (renderer heuristics are undocumented → flaky).
3. **BC-7.2.013 — no change needed.** Footnote-as-plain-marker + appended `rule` section is a
   schema-valid, ecosystem-standard workaround; there is no canonical ADF footnote encoding to
   diverge from. The lossy round-trip is already an accepted limitation.
4. **BC-7.2.009 / BC-7.2.014 — no change needed** for the five portable panelTypes or the
   link-mark shape; both match the authoritative Cloud schema. Keep avoiding `tip`/`custom`.

No claim is refuted; the BCs are safe to finalize with the `ftp://` clarification (rec. 1) and
the holdout-assertion framing guidance (rec. 2).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | (1) ADF node/mark inventory + footnote absence + link-mark shape + panelType portability + 2025–2026 recency (claims 1,4,5); (2) Jira REST auto-linkification of bare URLs in ADF (claim 2); (3) GFM autolinks extension — www/email scope, trailing-punct/paren rules, conservative-subset defensibility (claim 3) |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 1 | Single factual confirm: pulldown-cmark 0.13.x has no GFM autolink extension; ENABLE_GFM = alerts only (load-bearing premise) |
| Context7 | 0 | — (Perplexity research already returned authoritative Atlaskit/`adf-utils` detail; not needed) |
| Tavily (all) | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 0 areas | Not relied upon for any claim — all verdicts cite web-retrieved authoritative sources |

**Total MCP tool calls:** 4 (3× perplexity_research at reasoning_effort=high, 1× perplexity_ask)
**Training data reliance:** low — every verdict is grounded in retrieved Atlassian docs, the GFM/CommonMark specs, or pulldown-cmark docs/source; training data was used only to frame queries, not to source conclusions.
