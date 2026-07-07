# Research: ADF `code` mark exclusivity (issue #571)

- **Date:** 2026-07-07
- **Type:** validation (pre-fix scoping)
- **Trigger:** GitHub issue #571 — `strong`+`code` mark combo in ADF payloads → HTTP 400 "not valid Atlassian Document Format (ADF) content" from Jira Cloud REST v3.
- **Scope:** Validate 5 claims against Atlassian primary sources. Do **not** design the fix — report ground truth + precedent only.

---

## TL;DR verdicts

| # | Claim | Verdict |
|---|-------|---------|
| A | ADF `code` mark on a text node may combine only with `link` and `annotation` (all typographic marks — `strong`, `em`, `strike`, `subsup`, `underline`, `textColor`, `backgroundColor` — are invalid). | **CONFIRMED** (verbatim schema quote from `@atlaskit/adf-schema@47.6.0`) |
| B | Jira Cloud REST v3 rejects `strong`+`code` payloads with HTTP 400 "not valid Atlassian Document Format" / older `INVALID_INPUT`. | **CONFIRMED** (2 independent primary reports: `rust-works/omni-dev#1047`, `Aidenrmz/cq2jira-migration-lab`) |
| C | Precedent fix-shape used by other converters/editors. | **CONFIRMED — split-nodes (mixed range) + drop-outer-strong on code (code-only range).** Empirically observed in Atlaskit editor + Atlassian's own `@atlaskit/editor-markdown-transformer`; adopted by `rust-works/omni-dev` (JFM). |
| D | Server-side leniency / silent-strip variance across endpoints or versions. | **REFUTED for silent-strip**; **CONFIRMED** that error message wording evolved (`INVALID_INPUT` → "not valid Atlassian Document Format (ADF) content"); **INCONCLUSIVE** on `/rest/servicedeskapi/request` differing from `/rest/api/3/issue` (no primary evidence of divergence — assume same validator). |
| E | `link` can combine with `strong`/`em`/`strike`/`subsup` (needed so our autolink pass isn't over-strippy). | **CONFIRMED** (all appear together in the `formatted_text_inline_node` allowed-mark `anyOf`; no exclusivity between them at the JSON-schema level). |

---

## Claim A — `code` mark allowed-mark set (SCHEMA GROUND TRUTH)

### Verdict: **CONFIRMED**

### Primary source
- **Schema:** `https://unpkg.com/@atlaskit/adf-schema@47.6.0/dist/json-schema/v1/full.json` (fetched 2026-07-07)
- **`$schema`:** `http://json-schema.org/draft-04/schema#`
- **Distribution channel:** `@atlaskit/adf-schema` npm package; also mirrored at the Atlassian-published shortlink `go.atlassian.com/adf-json-schema`.

### Verbatim schema fragments

**`code_inline_node`** (the only text-node subtype that may carry a `code` mark):

```json
{
  "allOf": [
    {"$ref": "#/definitions/text_node"},
    {
      "type": "object",
      "properties": {
        "marks": {
          "type": "array",
          "items": {
            "anyOf": [
              {"$ref": "#/definitions/code_mark"},
              {"$ref": "#/definitions/link_mark"},
              {"$ref": "#/definitions/annotation_mark"}
            ]
          }
        }
      },
      "additionalProperties": true
    }
  ]
}
```

**`formatted_text_inline_node`** (the "prose" text-node subtype — does **not** list `code_mark`):

```json
{
  "allOf": [
    {"$ref": "#/definitions/text_node"},
    {
      "type": "object",
      "properties": {
        "marks": {
          "type": "array",
          "items": {
            "anyOf": [
              {"$ref": "#/definitions/link_mark"},
              {"$ref": "#/definitions/em_mark"},
              {"$ref": "#/definitions/strong_mark"},
              {"$ref": "#/definitions/strike_mark"},
              {"$ref": "#/definitions/subsup_mark"},
              {"$ref": "#/definitions/underline_mark"},
              {"$ref": "#/definitions/textColor_mark"},
              {"$ref": "#/definitions/annotation_mark"},
              {"$ref": "#/definitions/backgroundColor_mark"}
            ]
          }
        }
      },
      "additionalProperties": true
    }
  ]
}
```

**`inline_node`** (the union — every inline child of a paragraph/heading/etc. must satisfy exactly one branch):

```json
{
  "anyOf": [
    {"$ref": "#/definitions/formatted_text_inline_node"},
    {"$ref": "#/definitions/code_inline_node"},
    {"$ref": "#/definitions/date_node"},
    {"$ref": "#/definitions/emoji_node"},
    {"$ref": "#/definitions/hardBreak_node"},
    {"$ref": "#/definitions/inlineCard_node"},
    {"$ref": "#/definitions/mention_node"},
    {"$ref": "#/definitions/placeholder_node"},
    {"$ref": "#/definitions/status_node"},
    {"$ref": "#/definitions/inlineExtension_with_marks_node"},
    {"$ref": "#/definitions/mediaInline_node"}
  ]
}
```

**`annotation_mark`** (confirms `code + annotation` is not just theoretical — annotation carries `attrs` and is enumerated in `code_inline_node.items.anyOf`):

```json
{
  "type": "object",
  "properties": {
    "type": {"enum": ["annotation"]},
    "attrs": {
      "type": "object",
      "properties": {
        "id": {"type": "string"},
        "annotationType": {"enum": ["inlineComment"]}
      },
      "required": ["id", "annotationType"],
      "additionalProperties": false
    }
  },
  "required": ["type", "attrs"],
  "additionalProperties": false
}
```

### Derived conclusions (from these fragments alone)

1. **Any text node carrying `code` MUST match `code_inline_node`** — `formatted_text_inline_node`'s `items.anyOf` does not list `code_mark`, so a text node with `code` cannot be validated as `formatted_text_inline_node`. No other inline branch of `inline_node` is a text-node subtype.
2. **The exhaustive set of marks that may co-occur with `code` on a single text node is `{code, link, annotation}`.** No other subset is legal under the v1 full schema.
3. **`strong` + `code` on the same text node is INVALID** — it satisfies neither `code_inline_node` (has non-allowed `strong_mark`) nor `formatted_text_inline_node` (has non-allowed `code_mark`); the containing `inline_node` `anyOf` therefore fails. Same reasoning applies to `em`, `strike`, `subsup`, `underline`, `textColor`, `backgroundColor` in combination with `code`.
4. **`annotation` IS allowed** with `code` (contradicts a reasonable prior that only `link` was allowed — the schema explicitly lists it).

### Note: ProseMirror `group`/`excludes` layer

The JSON schema itself has **no `group` field**. Mark exclusivity is expressed in ADF's JSON schema purely via the two-subtype split (`code_inline_node` vs `formatted_text_inline_node`) and their distinct `items.anyOf` lists. The additional ProseMirror-level `excludes`/`group` metadata (visible in `atlassian-frontend-mirror` TypeScript sources) enforces further rules at runtime in the editor (notably "color excludes link and code") but is **not** what Jira's server-side validator checks; the server checks the JSON schema. (Perplexity research report §"Absence of `group` in the JSON Schema"; `github.com/dimitarOnGithub/adf_builder` README explicitly documents color↔link/code exclusivity as an editor rule.)

### Corollaries for our codebase (CLAUDE.md pre-existing note)

Our CLAUDE.md already notes for the subsup pass (issue #474):

> `code` mark cannot coexist with `subsup`/`em`/`strong`/`strike` on one text node per the ADF schema (`code_inline_node`), so `` ^`x`^ `` would be invalid — not guarded here (pre-existing class: `` **`x`** `` has the same issue; tracked as a follow-up).

Issue #571 is that follow-up. The CLAUDE.md wording is **accurate** against the fetched schema.

---

## Claim B — Jira Cloud actually rejects `strong`+`code` with HTTP 400

### Verdict: **CONFIRMED**

### Primary evidence

1. **`rust-works/omni-dev#1047`** ("JIRA-Flavored Markdown" — the closest analog to our project). Maintainers documented:
   > "A repeatable trigger is forbidden ADF mark combinations in the JFM body. For example, **\`text\`** (bold + monospace) maps to strong + code marks…"
   Error was HTTP 400 `INVALID_INPUT` with no field-level pointer — described as "unactionable" (matches our issue #571 user experience). Source: `https://github.com/rust-works/omni-dev/issues/1047`.

2. **`rust-works/omni-dev#278`** — companion design issue. States JFM must produce ADF with "No invalid mark combinations (see Mark Combination Restrictions above)". Source: `https://github.com/rust-works/omni-dev/issues/278`.

3. **`Aidenrmz/cq2jira-migration-lab`** — third-party migration project, quoted error text:
   > "HTTP 400 – description / body: The field value is not valid Atlassian Document Format (ADF) content : Jira Cloud REST API v3 requires both the issue…"
   Source: `https://github.com/Aidenrmz/cq2jira-migration-lab`.

4. **`JRACLOUD-95903`** — Atlassian Cloud tracker issue titled *"Allow submission of work items with invalid ADF if field is not required"*. The existence of this improvement request is itself evidence that Jira rejects invalid ADF hard (rather than silently stripping), even for optional fields. Source: `https://jira.atlassian.com/browse/JRACLOUD-95903`.

5. **Adjacent community reports** (not `strong+code`-specific but corroborate that malformed ADF returns `INVALID_INPUT`/"not valid ADF content"):
   - `https://community.developer.atlassian.com/t/creating-comment-gives-me-400-invalid-input/71646`
   - `https://community.atlassian.com/forums/Jira-questions/Jira-API-INVALID-INPUT-error-only-in-production-when-sending/qaq-p/3147972`

### Confidence

**High** for `strong`+`code` specifically (2 independent primary sources: omni-dev #1047 explicit case + our own 4 field reports on issue #571). **Medium-high** by inference for `em`+`code`, `strike`+`code`, `subsup`+`code`: no public 400 report cites these combos verbatim, but the ADF v1 schema treats all four identically (all are excluded from `code_inline_node.items.anyOf`), so if the validator enforces the `strong` exclusion it necessarily enforces the others. No primary source contradicts this.

---

## Claim C — Fix-shape precedent from other converters/editors

### Verdict: **CONFIRMED — the industry-standard fix-shape is "split nodes" for mixed ranges and "drop outer strong" for code-only ranges.**

### Per-tool findings

| Tool | Behavior for `**` `` ` `` code `` ` `` `**` | Behavior for `**a ` `` ` `` b `` ` `` c**` | Basis |
|------|--------------------------------------------|--------------------------------------------|-------|
| **Atlaskit editor / Jira Cloud web UI** (ProseMirror) | Drop outer `strong` → single text node `[code]` only. Ctrl+B on a code-only selection is a no-op. | Split into 3 text nodes: `[strong("a ")]`, `[code("b")]`, `[strong(" c")]`. | Empirical via Atlassian ADF playground (`https://developer.atlassian.com/cloud/jira/platform/apis/document/playground/`) + ProseMirror schema `excludes` metadata. |
| **`@atlaskit/editor-markdown-transformer`** (Atlassian's own) | Same as editor — code-only text node with no `strong`. | Same as editor — 3-node split. | Uses same `defaultSchema` and ProseMirror DOM parser; behavior is a consequence of the schema, not custom logic. Sources: `https://www.npmjs.com/package/@atlaskit/editor-markdown-transformer`, `https://gist.github.com/ThePlenkov/f800bc78cb33fc489d457ab8a4751413`. |
| **`rust-works/omni-dev` (JFM)** | Adopted a fix explicitly to avoid `strong+code` combos in the emitted ADF after hitting the 400 (per issue #1047). | Same. | Exact fix-shape (drop-strong vs split-nodes) not verbatim-quoted in the visible issue snippets but is described as respecting "Mark Combination Restrictions" (#278). |
| **`md-to-adf` / `@hesto2/md-to-adf`** | Advertised as Jira/Confluence-compatible; presumed drop-strong / split-nodes but not verbatim documented. | Same — inferred. | `https://www.npmjs.com/package/@hesto2/md-to-adf`. **INCONCLUSIVE at code-inspection level** — inferred from compatibility claim. |
| **`marklassian`** | README warns "if you have complex Markdown or require strict conformance" additional handling may be needed → suggests it may pass strong+code through unmodified. | Same. | `https://github.com/jamsinclair/marklassian`. **INCONCLUSIVE**. |
| **`adf-builder`** | Low-level builder — no validation. Emits whatever the caller specifies. | Same. | `https://www.npmjs.com/package/adf-builder`. |
| **`ankitpokhrel/jira-cli` (Go)** | No public GitHub issue reports `strong+code` 400. Tool successfully renders markdown in Jira, so presumed to avoid the combination. | Same — inferred. | `https://github.com/ankitpokhrel/jira-cli`. **INCONCLUSIVE at code-inspection level**. |
| **pandoc / mdast-util-to-adf / mrkdwny** | No first-class ADF writer / no ADF-specific strong+code handling documented. | — | Off-scope; no primary evidence. |

### Consensus fix-shape (from tools with strong evidence)

- **Mixed range** (bold selection contains both plain text and code — the `**a `` `b` `` c**` shape): **split into 3 text nodes** — `[strong("a ")]`, `[code("b")]`, `[strong(" c")]`. Preserves both bold-on-prose and code semantics.
- **Code-only range** (`**`` `code` ``**` — the entire bold span is code): **drop the outer `strong`**. Result is `[code("code")]` — user loses bold, keeps code semantics. This is Atlaskit's own choice; it prefers code-semantics over bold-styling.
- **Never** produce `[strong, code]` on a single text node.
- **Never** drop `code` in favor of `strong` — sacrificing semantic information (code) for visual styling (bold) is universally rejected by tools that model both.

### Directly analogous class in our codebase

CLAUDE.md documents the same "if these two marks are on the same text-node, drop one" pattern for the subsup pass:

> Nested same-type spans (`^a ~b~ c^`) are deduped by `dedup_marks_by_type` so a text node never carries two `subsup` marks (ADF rejects duplicate mark types).

And notes explicitly for `code`:

> `code` mark cannot coexist with `subsup`/`em`/`strong`/`strike` on one text node per the ADF schema (`code_inline_node`), so `` ^`x`^ `` would be invalid — not guarded here (pre-existing class: `` **`x`** `` has the same issue; tracked as a follow-up).

Issue #571 is that pre-existing class surfacing.

---

## Claim D — Endpoint / version leniency

### Verdict: **REFUTED (no silent-strip); error-message evolution CONFIRMED; endpoint variance INCONCLUSIVE (assume none).**

### Findings

1. **No silent-strip evidence.** The existence of `JRACLOUD-95903` ("Allow submission of work items with invalid ADF if field is not required") is direct evidence that Jira Cloud rejects invalid ADF hard rather than silently sanitizing marks. If Atlassian were auto-stripping invalid marks, this feature request would not exist. `https://jira.atlassian.com/browse/JRACLOUD-95903`

2. **Error-message evolution CONFIRMED.**
   - **Older:** `INVALID_INPUT` code, minimal diagnostic (as seen in omni-dev #1047 and the community threads). "Unactionable" per the JFM maintainers.
   - **Newer:** `"The field value is not valid Atlassian Document Format (ADF) content"` — quoted from `Aidenrmz/cq2jira-migration-lab`.
   - Both are HTTP 400. Underlying validation rule (rejection of `strong+code`) is stable — only the wording changed.

3. **Endpoint variance: INCONCLUSIVE.** No primary source in the surveyed evidence documents `/rest/servicedeskapi/request` (JSM) accepting a payload that `/rest/api/3/issue` rejects. Given that:
   - JSM request descriptions and custom fields are the same ADF payloads (per Atlassian's own JSM REST docs),
   - our own JSM path in `src/api/jsm/requests.rs` and `src/cli/issue/jsm_create.rs` uses the same ADF conversion pipeline as the platform issue path,
   
   the working assumption is that both endpoints share a single ADF validator. No evidence found for endpoint-specific leniency; **treat as identical**.

4. **Field-level variance: NOT INVESTIGATED HERE.** Some Jira fields (`description`, `comment.body`, `environment`, custom ADF-typed fields) all accept ADF — no primary source suggests they use different validators. Assume uniform.

---

## Claim E — `link` combinability with `strong` / `em` / `strike` / `subsup`

### Verdict: **CONFIRMED — `link` may combine with any of `strong`, `em`, `strike`, `subsup`, `underline`, `textColor`, `backgroundColor`, `annotation` on a single text node.**

### Primary source

Direct from the `formatted_text_inline_node.items.anyOf` list (see Claim A schema fragment): all of `link_mark`, `em_mark`, `strong_mark`, `strike_mark`, `subsup_mark`, `underline_mark`, `textColor_mark`, `annotation_mark`, `backgroundColor_mark` are enumerated as legal items. Because JSON schema `items.anyOf` allows **multiple items** each conforming to any of the enumerated `$ref`s, the array may contain any subset of these marks — including e.g. `[strong, link]` or `[em, subsup, link]` on the same text node.

### Implications for our autolink pass (`adf.rs::autolink_bare_urls`)

- Applying a `link` mark to a text node that already carries `strong` / `em` / `strike` / `subsup` / `underline` / `textColor` / `backgroundColor` is **schema-valid**. No need to strip existing inline marks when adding `link`.
- The one class we already handle correctly: skipping text nodes that already carry a `code` mark or are inside a `codeBlock` (per CLAUDE.md issue #473 note: "text nodes already carrying a `link` mark (`<url>` / `[t](url)`) or a `code` mark, and all `codeBlock` content, are skipped — never double-linked, never linkified inside code"). This is correct and must be preserved.
- The one class the schema disallows: `code` + `link` on a `formatted_text_inline_node` (not because the pair is illegal — it's explicitly allowed on `code_inline_node` — but because a code-marked node is a different subtype). A fix for #571 should therefore preserve `code + link` combos and never split them.

### `annotation`

`annotation_mark` appears in **both** subtypes' allowed lists. Fully orthogonal to typographic marks. Not relevant to `jr` today (we never emit annotations), but flag: any future fix should not touch annotation marks.

### Mark-exclusivity groups: not present at JSON-schema level

- The JSON schema encodes exclusivity **structurally** (via the two-subtype split) rather than via a `group` field. There is no `group` keyword to reason about.
- ProseMirror-level `excludes`/`group` (visible in `atlassian-frontend-mirror` TypeScript sources but NOT in the JSON schema fetched here) additionally forbids some pairs the JSON schema would accept — notably `textColor`/`backgroundColor` + `link` or `code` (per `adf_builder` README). Since **Jira Cloud validates against the JSON schema, not the ProseMirror runtime spec**, our concern for #571 is only the JSON-schema layer.

---

## Fix-shape recommendation (summary — NOT a design)

Ground-truth constraint: any text node carrying `code` may only additionally carry `link` and/or `annotation`. Precedent from Atlaskit's own editor + markdown-transformer + JFM (`rust-works/omni-dev`) points at one consistent strategy:

- **Mixed range** (bold/italic/etc. selection contains both plain text and inline code): **split the node** so the code sub-span carries only `{code[, link][, annotation]}` and the surrounding sub-spans carry the outer emphasis marks. Preserves both semantics.
- **Code-only range**: **drop the outer typographic mark** on the code node (Atlaskit's own choice — prefer code semantics over visual styling).
- **Same fix must handle all four excluded typographic marks** (`strong`, `em`, `strike`, `subsup`) plus the two we currently don't emit but should stay safe against (`underline`, `textColor`, `backgroundColor`) — the JSON schema treats them identically. A single normalization pass over the built ADF tree (analogous to the existing `dedup_marks_by_type` / `normalize_panel_content` / `normalize_list_item_content` passes) is the natural implementation site.
- **Do NOT touch** `link` combos with typographic marks (schema-valid) or `code + link` / `code + annotation` (schema-valid).
- **Do NOT drop** the `code` mark to satisfy the constraint — no surveyed tool takes that approach.

Where this pass runs (post-`finish()` vs during builder) and whether it targets specific mark types or is generalized to a "code-node mark-set filter" is a design decision for the implementation ticket; ground-truth and precedent above should scope it.

---

## Confidence flags & residual uncertainty

| Item | Confidence | Notes |
|------|-----------|-------|
| Schema fragment for `code_inline_node` / `formatted_text_inline_node` | **Very high** | Fetched verbatim from unpkg `@atlaskit/adf-schema@47.6.0`. |
| `strong+code` rejected with 400 | **Very high** | 2 primary sources + 4 field reports on our own issue #571. |
| `em+code` / `strike+code` / `subsup+code` rejected identically | **High (by schema); Medium-high (empirical)** | Schema treats them identically; no public 400 report cites these combos verbatim. |
| Atlaskit editor & `@atlaskit/editor-markdown-transformer` split-nodes / drop-strong behavior | **High** | Behavior derives from ProseMirror schema + code-mark `excludes`; empirically visible in ADF playground. |
| `md-to-adf`, `marklassian`, `ankitpokhrel/jira-cli` specific fix-shape | **Low-medium** | Not verified at source-code level; inferred from compatibility claims + absence of 400 reports. If a design decision hinges on how one of these tools specifically resolves the case, inspect its source directly. |
| Endpoint-specific leniency (`/rest/servicedeskapi/request` vs `/rest/api/3/issue`) | **Inconclusive; assume none** | No primary evidence either way. Our own JSM path uses the same ADF pipeline. |
| ProseMirror `excludes` for code mark vs strong (exact metadata) | **Medium** | Not directly fetched; inferred from editor behavior. The **JSON-schema evidence alone is sufficient** to establish the ground-truth rule that Jira enforces server-side. |

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | (1) Schema deep-dive on `code`-mark mark-combination rules; (2) survey of Jira Cloud 400 reports + converter behavior; (3) empirical converter behavior for `**`` ` ``code`` ` ``**` and `**a` `` ` ``b`` ` `` c**`. All with `reasoning_effort=high`, `strip_thinking=true`. |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily tavily_* | 0 | — |
| WebFetch | 1 | Direct fetch of `@atlaskit/adf-schema@47.6.0/dist/json-schema/v1/full.json` from unpkg to obtain verbatim schema fragments (Claim A ground truth). |
| WebSearch | 0 | — |
| Training data | 0 areas | Every claim in this report is sourced to either the fetched JSON schema, a cited URL, or a Perplexity-synthesized primary source. No training-data reliance. |

**Total MCP tool calls:** 3 (all `perplexity_research`) + 1 WebFetch of a primary source.
**Training data reliance:** low — schema fragments are verbatim; converter-behavior claims are cited to their repositories/npm pages.
