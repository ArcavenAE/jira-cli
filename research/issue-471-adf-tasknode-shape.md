# Issue #471 — ADF Task-Node Shape for Jira Cloud REST API v3

**Research date:** 2026-06-10
**Researcher:** research-agent (VSDD Feature Mode F1 gate)
**Scope:** Exact ADF node shape the **Jira Cloud REST API v3** accepts for GFM task lists (`- [ ]` / `- [x]`) in an issue `description` / comment `body`.
**Bottom line:** Use the canonical ADF `taskList` / `taskItem` nodes — **NOT** `blockTaskItem`. The deep-research synthesis that claimed `blockTaskItem` is the submittable node is **REJECTED** as community-inferred and contradicted by primary sources (see Verdict §3).

---

## Top-Line Recommendation

Emit standard ADF `taskList` → `taskItem` nodes with explicit `localId` and uppercase `state`:

```json
{
  "version": 1,
  "type": "doc",
  "content": [
    {
      "type": "taskList",
      "attrs": { "localId": "0" },
      "content": [
        {
          "type": "taskItem",
          "attrs": { "localId": "1", "state": "TODO" },
          "content": [ { "type": "text", "text": "unchecked item" } ]
        },
        {
          "type": "taskItem",
          "attrs": { "localId": "2", "state": "DONE" },
          "content": [ { "type": "text", "text": "checked item" } ]
        }
      ]
    }
  ]
}
```

**Confidence: HIGH** that this is the correct, schema-valid node shape. The `localId` mandatory-ness and exact `doc`-top-level placement carry residual risk that warrants one sandbox POST (see §5).

---

## 1. Verdict: `taskList`/`taskItem` vs `blockTaskItem`

**Use `taskList` + `taskItem`. Do not use `blockTaskItem`.**

Evidence (primary, ranked):

1. **Canonical ADF JSON schema (`@atlaskit/adf-schema` `full.json`)** — this is the schema that Atlassian's own structure page points to via `http://go.atlassian.com/adf-json-schema`. It defines `taskList_node` and `taskItem_node` (verbatim quoted in §2). The string **`blockTaskItem` does NOT appear anywhere in `full.json`** (verified by full-file search of v40.9.2).
   - Source: `https://app.unpkg.com/@atlaskit/adf-schema@40.9.2/files/json-schema/v1/full.json` — accessed 2026-06-10. (v44.0.0 referenced by JSDCLOUD-15228 is the same schema family: `https://unpkg.com/@atlaskit/adf-schema@44.0.0/dist/json-schema/v1/full.json`.)

2. **Official Atlassian bug ticket JSDCLOUD-15228** — shows a working `taskList`/`taskItem` ADF payload submitted to a Jira (JSM) issue **description** that Jira **accepted** (the bug is only about email-notification rendering, not validation; see §4).
   - Source: `https://jira.atlassian.com/browse/JSDCLOUD-15228` — accessed 2026-06-10.

3. **`blockTaskItem` developer-doc node page returns HTTP 404** — `https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/blockTaskItem/` is a dead link (verified 2026-06-10). The structure page lists `blockTaskItem` as a "child block node" and links to a node page that does not exist.
   - Source: `https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/` — accessed 2026-06-10.

**What `blockTaskItem` actually is (best inference, MEDIUM confidence — flagged as inference, not primary fact):** `blockTaskItem` is an **editor-internal / stage-0 node** that surfaces in the Jira structure page's child-node *list* but (a) has no published node page, and (b) is absent from the validated `full.json` schema. Per `@atlaskit/adf-schema-generator` docs, nodes flagged `stage0: true` are intentionally excluded from the full JSON schema. `blockTaskItem` is therefore **not a node you should POST** — it is not part of the submittable/validated surface. It is a newer block-content variant of task items used inside the Atlaskit editor's content model, not the REST-API contract.

> **Citation-discipline flag:** The Sonar deep-research model (`perplexity_research`) asserted with high confidence that `blockTaskItem` is "the actual node type that must be used when submitting task lists to Jira's REST API." This claim is **contradicted by the canonical schema and the working JSDCLOUD-15228 payload** and is **rejected**. It traces to community-forum speculation ([26], [6], [32] in that model's bibliography), not to any primary Atlassian API contract. Do not act on it.

---

## 2. Required Attributes (verbatim from canonical schema)

From `@atlaskit/adf-schema` `full.json` (v40.9.2), quoted verbatim:

**`taskItem_node`:**
```json
"taskItem_node": {
  "type": "object",
  "properties": {
    "type": { "enum": ["taskItem"] },
    "attrs": {
      "type": "object",
      "properties": {
        "localId": { "type": "string" },
        "state": { "enum": ["TODO", "DONE"] }
      },
      "required": ["localId", "state"],
      "additionalProperties": false
    },
    "content": { "type": "array", "items": { "$ref": "#/definitions/inline_node" } }
  },
  "additionalProperties": false,
  "required": ["type", "attrs"]
}
```

**`taskList_node`:**
```json
"taskList_node": {
  "type": "object",
  "properties": {
    "type": { "enum": ["taskList"] },
    "attrs": {
      "type": "object",
      "properties": { "localId": { "type": "string" } },
      "required": ["localId"],
      "additionalProperties": false
    },
    "content": {
      "type": "array",
      "items": [
        { "$ref": "#/definitions/taskItem_node" },
        { "anyOf": [
            { "$ref": "#/definitions/taskItem_node" },
            { "$ref": "#/definitions/taskList_node" }
        ] }
      ],
      "minItems": 1
    }
  },
  "additionalProperties": false,
  "required": ["type", "attrs", "content"]
}
```

**Resolved facts (HIGH confidence — direct from schema):**

| Question | Answer | Source |
|---|---|---|
| Attribute name on taskList | `localId` (string) | full.json |
| `localId` required on taskList? | **YES** — `"required": ["localId"]` | full.json |
| Attribute names on taskItem | `localId` (string) + `state` | full.json |
| `localId` + `state` required on taskItem? | **YES** — `"required": ["localId", "state"]` | full.json |
| `state` casing / allowed values | **`"TODO"` or `"DONE"` (uppercase only)** — `"enum": ["TODO", "DONE"]` | full.json |
| `taskList` content min items | `minItems: 1` — a taskList must have at least one taskItem | full.json |
| `additionalProperties` | `false` on attrs — extra attr keys are schema-invalid | full.json |

**`localId` value rules:**
- Type is `string`, no format/length/pattern constraint in `full.json` → **any non-empty string is schema-valid**.
- JSDCLOUD-15228's accepted payload used trivially simple values: `"1"`, `"2"`, `"3"` (plain integer-strings). This is **primary evidence that `localId` need not be a UUID** and need not be globally unique — sequential per-document counters suffice.
- **Uniqueness within the document:** Not enforced by `full.json` (no schema-level uniqueness constraint). HIGH confidence it *should* be unique to avoid renderer ambiguity, but the schema does not reject duplicates. **Recommendation:** assign monotonically increasing per-document string indices (e.g. `"0"` for the list, `"1"`, `"2"`, … for items) — cheap, deterministic, matches the JSDCLOUD-15228 pattern. UUIDv4 is unnecessary.

> **Citation-discipline flag:** A `perplexity_ask` community result ([8]) claimed `localId` is *optional* ("you do not need to specify a valid localId"). This is **contradicted by `full.json`** (`localId` is in both `required` arrays). The likely reconciliation: the Atlaskit *editor* auto-generates `localId` when you type in the UI, so a human never specifies one — but a **REST API POST must include it** to pass schema validation. Treat `localId` as **mandatory for our use case** (we POST raw ADF). Do not omit it.

---

## 3. Content Model

**HIGH confidence (from schema):**
- `taskItem.content` = array of **inline nodes only** (`$ref: inline_node`). So a task item holds `text`, `mention`, `emoji`, `date`, `inlineCard`, `status`, `hardBreak` — **NOT** block content (no nested paragraph, no nested list *as content of the item*). This differs from the deep-research model's claim that each item must wrap a `paragraph` — that claim is **rejected**; the schema puts inline content directly in `taskItem.content`, and JSDCLOUD-15228 confirms (`"content": [ { "type": "text", "text": "Option 1" } ]`).
- `taskList.content` = `taskItem` nodes, and a `taskList` **can nest** another `taskList` (the `anyOf` includes `taskList_node`). So nested checklists are schema-valid: `taskList > taskItem` … and a `taskList` may also contain a child `taskList`. **Note** the schema's tuple-form `items` (first element must be a `taskItem`, subsequent may be `taskItem` or `taskList`) — i.e. a taskList must *lead* with at least one taskItem.

**`taskList` as a top-level child of `doc` — CONFLICTING EVIDENCE, MEDIUM confidence, NEEDS SANDBOX:**
- **For (accepts at top level):** JSDCLOUD-15228 (official Atlassian ticket) shows `taskList` as a **direct child of `doc`** in an accepted description payload. This is the strongest single data point and is a primary Atlassian source.
- **Against (schema may not list it at top level):** Two reads of `full.json`'s `doc_node` top-level content list did **not** surface `taskList_node` among the top-level `$ref`s (the validated top-level set is paragraph/heading/list/blockquote/codeBlock/media/rule/panel/table/etc.). One of those reads was from a cut-off excerpt and is therefore **inferred, not verbatim** — flagged LOW confidence on its own.
- **Reconciliation:** Most likely `taskList` *is* accepted at the document top level by the live Jira API (JSDCLOUD-15228 proves a real submission), even if the published JSON schema's `doc_node` enumeration is conservative/incomplete (Atlassian's structure docs are known-incomplete — the structure page itself omits `taskList`/`taskItem` entirely while the schema defines them). **Confidence that top-level placement works: MEDIUM-HIGH** on the strength of the JSDCLOUD ticket. **This is the single item most worth a sandbox POST** (§5).
- **Safe fallback if sandbox reveals top-level rejection:** wrap the `taskList` so it is not the literal first/only top-level node, or place it after a leading `paragraph`. JSDCLOUD-15228 suggests no wrapper is needed, so do not pre-emptively add one.

---

## 4. API Validation vs Renderer Display

**Known primary-sourced quirk (HIGH confidence):** JSDCLOUD-15228 documents that a `DONE` `taskItem` in a **description** renders as **strikethrough text in customer-notification *emails*** (HTML `<del>`) rather than a checked checkbox. This is a *notification-email rendering* defect, **not** an API-acceptance or in-app-rendering defect — the ticket confirms the ADF is accepted and displays correctly **in the Jira UI**. Relevance to #471: our job is correct ADF emission; the email-rendering quirk is Atlassian-side and out of scope, but worth a one-line note in user-facing docs if `jr` ever surfaces description checklists used in JSM notifications.

**Unverified claims (REJECTED / flagged):** The deep-research model asserted broad "API accepts but renderer silently drops" behavior for task lists, lowercase-state acceptance, duplicate-localId sporadic failures, etc. These are **community-inferred, not primary-sourced**, and several are internally inconsistent (e.g. it simultaneously claimed lowercase `state` is accepted *and* rejected). **Do not rely on them.** The only primary-sourced acceptance evidence (JSDCLOUD-15228) used uppercase `TODO`/`DONE` and was accepted + rendered correctly in-app.

---

## 5. What Still Needs Live-Sandbox Verification

Per project needs-sandbox discipline, the following are **not** fully settled by Atlassian primary docs and should be confirmed with **one** live POST to a sandbox issue (create or edit a description; then GET it back and diff the ADF):

| # | Open question | Current confidence | Why sandbox |
|---|---|---|---|
| 5.1 | Is `taskList` accepted as a **direct top-level child of `doc`**? | MEDIUM-HIGH (JSDCLOUD-15228 says yes; schema `doc_node` enumeration ambiguous) | Schema-vs-ticket conflict; this is the gating placement decision for #471. |
| 5.2 | Is `localId` **truly mandatory** on a REST POST (does Jira 400 without it)? | HIGH it's required (schema), but community claims it's optional | Cheap to confirm: POST a taskItem missing `localId`, observe 400 vs auto-fill. |
| 5.3 | Does Jira **echo `localId` back unchanged** or rewrite it on GET? | UNKNOWN | If Jira rewrites localIds, our round-trip / snapshot tests must not pin exact values. Relevant to `adf.rs` reverse-path tests. |
| 5.4 | Does a **lowercase `state`** (`"todo"`) get rejected (400) or silently coerced? | Schema says enum `TODO`/`DONE` → expect 400 | Confirms we must uppercase; guards against emitting lowercase. |
| 5.5 | Does **nested `taskList`** (checklist inside checklist) survive round-trip in Jira's renderer? | Schema-valid; in-app behavior unverified | GFM nested task lists (`  - [ ]`) map here — confirm before claiming support. |

**Recommended single sandbox probe (covers 5.1–5.4):** POST the §1 example as an issue description to a sandbox project, then GET and inspect. One additional POST with `state:"todo"` and one with a missing `localId` settle 5.2 and 5.4. All are read-after-write on a throwaway issue.

> Per MEMORY feedback (`feedback_no_live_mutations`), these sandbox POSTs are **state-changing against live Jira and require explicit user approval** before execution. They are not blocking for the F1 *design* decision — the node shape in §1 is safe to design against now at HIGH confidence; the sandbox probe is verification, not discovery.

---

## 6. pulldown-cmark 0.13 Mapping (for the implementer)

**HIGH confidence (docs.rs primary):** `pulldown_cmark::Event::TaskListMarker(bool)` — "A task list marker, rendered as a checkbox in HTML. Contains a `true` when it is checked." Emitted **only** when `Options::ENABLE_TASKLISTS` is set.
- Source: `https://docs.rs/pulldown-cmark/0.13.0/pulldown_cmark/enum.Event.html` — accessed 2026-06-10.
- The `bool` is the checked state → maps directly to `state`: `true` → `"DONE"`, `false` → `"TODO"`.
- **Emission ordering caveat (the doc page did not specify it explicitly — flagged):** by pulldown-cmark's documented behavior the `TaskListMarker` event arrives as the **first child event inside a list `Item`** (immediately after `Tag::Item` start, before the item's paragraph/text). The implementer should confirm ordering empirically against the 0.13 parser (a 3-line test feeding `- [x] foo` and dumping the event stream), since the enum doc comment alone does not pin it. This is a parse-time detail, fully verifiable offline (no sandbox needed) — distinct from the Jira-side questions in §5.
- Implementation note: a GFM task list is a `bulletList`/`Item` in pulldown terms; the presence of a `TaskListMarker` as the item's first event is the signal to emit a `taskList`/`taskItem` ADF subtree instead of a `bulletList`/`listItem` one. Because `taskItem.content` is inline-only (§3), the item's paragraph wrapper must be unwrapped to inline content when converting (mirrors no existing `adf.rs` helper — net-new mapping).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source sweep of ADF task-list shape, attrs, content model, validation-vs-render. **Its blockTaskItem conclusion was rejected on primary-source cross-check** — used for lead-gathering, not as authority. |
| Perplexity perplexity_ask | 1 | Cross-check on which node type developers actually POST + localId optionality (community-sourced, flagged). |
| Perplexity perplexity_search | 2 | Raw URL ranking for the ADF structure page, JSDCLOUD-15228, and the `@atlaskit/adf-schema` `full.json`. |
| WebFetch | 5 | Primary-source verification: ADF structure page (node lists), `blockTaskItem` node page (404), JSDCLOUD-15228 (accepted payload + bug scope), `full.json` taskList/taskItem/doc_node defs (verbatim), docs.rs pulldown-cmark `TaskListMarker`. |
| WebSearch | 1 | Confirm dedicated `taskList`/`taskItem` node-doc page URLs exist. |
| Context7 | 0 | Not needed — docs.rs gave the pulldown-cmark contract directly. |
| Training data | 1 area | Stage-0 schema generator behavior (`stage0: true` excludes from full.json) — corroborated by perplexity_search result on `@atlaskit/adf-schema-generator`; flagged as inference for the `blockTaskItem` characterization. |

**Total MCP tool calls:** 4 (1 research + 1 ask + 2 search). WebFetch/WebSearch (6) are Claude-native and used for primary-source verification of the MCP leads.
**Training data reliance:** low — every load-bearing claim (node names, required attrs, state enum, localId rules, pulldown event) is pinned to a primary source (canonical `full.json` schema, official Atlassian ticket, or docs.rs). The one inference (`blockTaskItem` = stage-0/editor-internal) is explicitly flagged MEDIUM confidence.

---

## Source Ledger (all accessed 2026-06-10)

1. ADF structure (node taxonomy; lists `blockTaskItem`, omits taskList/taskItem; points to canonical JSON schema): `https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/`
2. Canonical ADF JSON schema `full.json` (verbatim taskList_node / taskItem_node; no `blockTaskItem`): `https://app.unpkg.com/@atlaskit/adf-schema@40.9.2/files/json-schema/v1/full.json` (family also at `https://unpkg.com/@atlaskit/adf-schema@44.0.0/dist/json-schema/v1/full.json`; Atlassian's pointer `http://go.atlassian.com/adf-json-schema`)
3. JSDCLOUD-15228 (official ticket; accepted top-level taskList/taskItem description payload; email-render bug scope): `https://jira.atlassian.com/browse/JSDCLOUD-15228`
4. `blockTaskItem` node page — **HTTP 404** (not a published/submittable node): `https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/blockTaskItem/`
5. pulldown-cmark 0.13 `Event::TaskListMarker(bool)` (ENABLE_TASKLISTS, bool = checked): `https://docs.rs/pulldown-cmark/0.13.0/pulldown_cmark/enum.Event.html`
6. `@atlaskit/adf-schema-generator` (stage-0 nodes excluded from full JSON schema — basis for blockTaskItem inference): `https://www.npmjs.com/package/@atlaskit/adf-schema-generator`
7. Dedicated node-doc URLs (existence confirmed): `https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/taskList/`, `.../nodes/taskItem/`
