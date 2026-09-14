# Research: Jira Cloud REST API v3 — On-Read JSON Shape of ADF-Backed Fields

**Date:** 2026-09-14
**Type:** general (technology / API contract verification)
**Question:** Is asserting `fetched["fields"]["environment"]["type"] == "doc"` a correct, robust check for a freshly-written non-empty rich-text value on a normal (non-rendered) `GET /rest/api/3/issue/{key}`?

---

## Verdict (TL;DR)

**(a) YES — asserting `fetched["fields"]["environment"]["type"] == "doc"` is CORRECT and ROBUST for a freshly-written, non-empty value on Jira Cloud REST API v3.**

On the v3 API, `environment` is an officially-documented ADF-backed field. A non-null value in the `fields` object is always an ADF document whose root `doc` node requires `type: "doc"`, `version: 1`, and a `content` array. This is guaranteed by two independent official sources: the v3 intro's field list and the ADF `doc` node spec. There is **no documented condition** under which `fields.environment` comes back as a raw JSON string on `/rest/api/3/...`.

**(b) Edge cases where the assertion could false-fail** (all avoidable, and none apply to a test that writes-then-reads a non-empty value on v3):

1. **Empty / unset value returns `null`, not an ADF object.** If the field is unset (or was cleared), `fields.environment` is `null`, and `null["type"]` fails. Only assert `type == "doc"` on a value you *just wrote* as non-empty. This is the single realistic false-fail vector.
2. **Wrong API version.** Against `/rest/api/2/...`, `environment` comes back as a wiki-markup **string**, not ADF. The assertion must run against a v3 client. (This repo's `JiraClient` targets `/rest/api/3/` — safe.)
3. **`customfield_NNNNN` type confusion.** A *single-line* text custom field (schema `custom` ending `:textfield`) is a plain string, NOT ADF. Only `:textarea` ("Paragraph (supports rich text)") is ADF. Irrelevant for the built-in `environment` field but worth pinning if the test is later parametrized over custom fields.
4. **Field absent from response.** If the field isn't selected (e.g. a `fields=` projection that omits it) or isn't on the screen, the key may be missing entirely — `fetched["fields"]["environment"]` would be absent rather than `"doc"`. A default `GET` with no `fields` filter returns all fields, so this doesn't apply to the default request.

`expand=renderedFields` does **not** affect the assertion — it adds a *separate* top-level `renderedFields` object containing HTML strings; `fields.environment` itself stays ADF whether or not the expand is present.

---

## Detailed Findings

### 1. Shape of ADF-backed fields on a normal (non-rendered) GET

Confirmed against the **official v3 intro page** (developer.atlassian.com/cloud/jira/platform/rest/v3/intro/), which lists the fields that support Atlassian Document Format:

- `body` in comments (issue, issue-link, transition resources)
- `comment` in worklogs
- **`description` and `environment` fields in issues**
- **`textarea`-type custom fields** (multi-line "Paragraph (supports rich text)")

And it explicitly states: *"Single line custom fields (`textfield`) accept a string and don't handle Atlassian Document Format content."*

| Field | Non-null value in `fields` (v3 GET) | Top-level `type` == `"doc"`? | Doc strength |
|-------|-------------------------------------|------------------------------|--------------|
| `fields.environment` | `{"type":"doc","version":1,"content":[...]}` | **Yes** | v3 intro explicitly lists `environment` as ADF-backed |
| `fields.description` | `{"type":"doc","version":1,"content":[...]}` | **Yes** | v3 intro lists it AND the Get-issue 200 example shows `description` as a `doc` object |
| `fields.customfield_NNNNN` (`:textarea`) | `{"type":"doc","version":1,"content":[...]}` | **Yes** | v3 intro lists `textarea` custom fields as ADF-backed |

The ADF `doc` node spec (developer.atlassian.com/cloud/jira/platform/apis/document/nodes/doc/ and .../apis/document/structure/) is unambiguous: every ADF document's root is a `doc` node requiring `type` = `"doc"`, `version` = `1`, and `content` as an array of zero-or-more nodes.

### 2. Can a v3 ADF-backed field ever return a plain string?

| Condition | Raw string on v3 `fields`? | Basis |
|-----------|----------------------------|-------|
| Ordinary non-rendered `GET /rest/api/3/issue/...` | **No** | v3 intro + v3 Get-issue example |
| `expand=renderedFields` absent | **No** | Absence doesn't select a string representation |
| `expand=renderedFields` present | **No** | Adds separate `renderedFields` HTML object; does not mutate/replace `fields.<name>` |
| Wiki vs plain-text renderer mode | **No documented v3 exception** | Forge UI-modification renderer modes are not the REST v3 Get-issue contract |
| Field hidden by field configuration | **Not a string** (null in Jira-expressions, not a string) | Jira-expressions type reference; not a Get-issue response contract per se |
| Unset / null field | **No — returns `null`**, not `""` | Jira response convention (see §3) |
| Single-line `:textfield` custom field | **Yes — but that's not one of the three fields in scope** | v3 intro explicitly: `textfield` accepts a string, not ADF |
| `/rest/api/2/issue/...` (v2) | **Yes — v2 returns a wiki-markup string** | v2 Get-issue example shows `"description": "..."` as a string |

**Bottom line for the specific worry:** `fields.environment` will **not** come back as a raw string from `/rest/api/3/issue/...` when it holds a value. The parse-relevant possibilities are: an ADF object, `null` (unset), or the key being absent (not selected). Not a raw text string.

### 3. Empty / unset ADF-backed field on GET

| State | GET value | Doc status |
|-------|-----------|------------|
| Genuinely unset / no stored value | `null` | Jira response convention; the v3 Get-issue reference does not spell out a per-field nullability rule, but unset issue fields serialize as `null` |
| ADF document exists but has no content nodes | `{"type":"doc","version":1,"content":[]}` | Explicitly a *valid* ADF document ("the simplest document in ADF"); `doc` permits zero content nodes |
| Whether Jira preserves a submitted empty doc vs normalizes to unset | **Not specified** by the cited REST contract | Ambiguous — the ADF spec proves an empty doc is valid but does not promise Jira storage distinguishes it from unset on subsequent GETs |

**Safe rule:** expect `null` for unset; expect an ADF object (possibly the valid empty document `content:[]`) for any represented value. Do **not** treat `{"type":"doc",...,"content":[]}` as a guaranteed sentinel for "unset" — Atlassian documents it only as a valid empty ADF doc, not as Jira's unset serialization.

### Practical implication for the test assertion

- The assertion `fetched["fields"]["environment"]["type"] == "doc"` is correct **provided the test wrote a non-empty value immediately before reading**, and the client is v3.
- Hardening options (defensive, not required): additionally assert `version == 1` and `content` is an array; and/or first assert the value is non-null before indexing `["type"]` so a regression that clears the field yields a clear "was null" failure rather than a type/index panic.
- Do not add `expand=renderedFields` expecting it to change `fields` — it won't; if you want the HTML, read the separate `renderedFields.environment`.

### Ambiguities / limits of documentation

- The v3 Get-issue *example* concretely shows only `description` as a `doc` object; it does not show `environment`, a textarea custom field, an unset field, or a full `renderedFields` example. The `environment == doc` conclusion rests on the v3 intro's explicit field list (strong) rather than a worked example (would be stronger).
- Per-field nullability is not enumerated in the v3 Get-issue reference; `null`-for-unset is the operational convention, not a spelled-out per-field contract.
- Whether an explicitly-submitted empty ADF doc is preserved vs normalized to unset is not documented.

---

## Sources (official Atlassian, developer.atlassian.com)

- REST API v3 intro (ADF field list; `textfield` = string): https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/ — **verified via direct domain-filtered lookup**
- ADF document structure: https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/
- ADF `doc` node spec (root `type:"doc"`, `version:1`, `content` array): https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/doc/
- v3 Get-issue reference (example shows `fields.description` as `doc` object): https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/
- v2 Get-issue reference (example shows `description` as a string): https://developer.atlassian.com/cloud/jira/platform/rest/v2/api-group-issues/
- v2 intro (v3 adds ADF support): https://developer.atlassian.com/cloud/jira/platform/rest/v2/intro/
- Jira-expressions type reference (hidden field → null): https://developer.atlassian.com/cloud/jira/platform/jira-expressions-type-reference/

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source synthesis of v3 ADF field shape, v2-vs-v3, renderedFields, empty/unset behavior against developer.atlassian.com |
| Perplexity perplexity_ask | 1 | Targeted confirmation (domain-filtered to developer.atlassian.com) of the exact ADF field list on the v3 intro page — verifying `environment` is explicitly listed |
| WebFetch | 1 | Attempted direct fetch of v3 intro page (returned no usable content; superseded by domain-filtered perplexity_ask) |
| Training data | 1 area | General ADF/Jira REST familiarity used only to frame queries, not as an evidence source |

**Total MCP tool calls:** 2 (1 perplexity_research + 1 perplexity_ask)
**Training data reliance:** low — the load-bearing claim (`environment` is ADF on v3, returns `type:"doc"`) is grounded in the official v3 intro field list, cross-checked via a domain-restricted second query.
