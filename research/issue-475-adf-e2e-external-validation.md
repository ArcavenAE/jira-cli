# Issue #475 — ADF Read-Path E2E: External Jira-API Assumption Validation

**Type:** external-assumption validation (test-only spec delta)
**Scope:** Jira Cloud REST API v3 / Atlassian Document Format (ADF) assumptions underpinning the F2 spec delta for issue #475 (ADF read-path E2E coverage)
**Validated by:** research-agent (Perplexity `sonar-deep-research` + `sonar-pro`, official `developer.atlassian.com` docs via WebFetch)
**Access date for all citations:** 2026-06-11
**Verdict scale:** CONFIRMED / REFUTED / INCONCLUSIVE

> Citation discipline note (per CLAUDE.md "Citation discipline for external-tracker IDs" + #361 retrospective): every external API claim below carries a source URL accessed 2026-06-11. Where two sources conflicted (claim #2), the conflict is recorded and resolved against the **primary official schema reference**, not community inference.

---

## Acceptance-criteria recap (what the assumptions support)

- **AC-1** — create issue with rich Markdown description (→ ADF), fetch via `GET /rest/api/3/issue/{key}` (the `jr issue view --output json` path) AND render via `adf_to_text`; assert rendered text.
- **AC-2** — description with a blockquote nested inside a list item; `jr` normalizes `listItem.content` to drop the nested blockquote (ADF `listItem` forbids `blockquote`); assert Jira accepts (no HTTP 400) and returned ADF has no blockquote inside listItem.
- **AC-3** — add comment via `POST /rest/api/3/issue/{key}/comment` (markdown → ADF), read back via `GET .../comment` (the `jr issue comments` path), render via `adf_to_text`.

---

## Claim 1 — ADF round-trip fidelity (description returned as ADF object in v3)

**Verdict: CONFIRMED**

When an ADF document is submitted via `POST /rest/api/3/issue` or `PUT /rest/api/3/issue/{key}` and the issue is then fetched with default fields via `GET /rest/api/3/issue/{key}`, Jira Cloud returns `fields.description` as an **ADF JSON object** (`{version, type, content, …}`) — NOT a flattened string and NOT rendered HTML. HTML is only produced when the caller explicitly adds `?expand=renderedFields`. The v2 REST API (`/rest/api/2/`) by contrast uses wiki-markup / string for the description field; ADF support is the headline difference introduced in v3.

- The v3 intro doc states v3 "provides support for the Atlassian Document Format (ADF) in `body` in comments … [and] `description` … in issues," framing this as the key v2→v3 difference. — https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/ (accessed 2026-06-11)
- Default GET returns raw ADF; `?expand=renderedFields` adds the HTML representation alongside (so raw-vs-rendered is opt-in). — https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/ ; corroborated by https://community.developer.atlassian.com/t/is-it-posible-to-get-the-body-comment-as-plain-text/41858 (accessed 2026-06-11)
- v2 returns wiki/text/html string formats; v3 requires/returns ADF — cross-confirmed by community reference. — https://community.developer.atlassian.com/t/what-are-the-differences-in-rest-apis-between-jira-data-center-and-jira-cloud/78178 (accessed 2026-06-11)

**Implication for AC-1:** The inspection channel (`jr issue view --output json` reading `fields.description` as ADF) is sound. The test must NOT pass `expand=renderedFields` if it wants the ADF object — confirm `jr`'s view path does not inject that expand.

---

## Claim 2 — ADF `listItem` content model forbids `blockquote`

**Verdict: CONFIRMED** (`blockquote` is NOT a permitted direct child of `listItem`; the normalization in AC-2 is required).

> **Source conflict recorded and resolved.** The deep-research (`sonar-deep-research`) pass returned an *indirect, community-inferred* answer claiming blockquote-in-listItem is permitted — but it explicitly self-flagged that conclusion as based on conversion-tool/community examples rather than the schema, noting "the official Atlassian Document Format reference doesn't explicitly enumerate every permitted child relationship." That inference is **REFUTED** by the primary schema reference, which I fetched directly and cross-checked with a second targeted query. The official `listItem` node reference wins.

Per the official ADF `listItem` node reference, the `content` array **must contain at least one of**:
- `bulletList`
- `codeBlock` (with no marks)
- `mediaSingle`
- `orderedList`
- `paragraph` (with no marks)

`blockquote` is absent from that allowed set → forbidden as a direct child of `listItem`.

- Primary, authoritative: https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/listItem/ (fetched directly + verbatim content constraint "`content` must contain at least one of the following nodes:", accessed 2026-06-11)
- Second independent confirmation (Perplexity `sonar-pro` reading the same node reference): same five-node allow-list, blockquote excluded. — https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/listItem/ (accessed 2026-06-11)

**Implication for AC-2:** `jr`'s unwrap-blockquote-in-listItem normalization is genuinely required to avoid invalid ADF. The test's premise (submit normalized form → Jira accepts, no blockquote inside listItem in the returned tree) is well-founded. See Claim 3 for what to assert.

---

## Claim 3 — server-side ADF normalization risk (assert node-types, not exact tree)

**Verdict: CONFIRMED that risk exists → INCONCLUSIVE on a precise, documented mutation list** (Atlassian does not publish exact normalization rules).

Evidence that Jira Cloud DOES apply server-side normalization on ADF store (so an exact-tree assertion would be flaky):
- The official ADF *structure* reference documents NO normalization/`localId`-injection contract — i.e. the round-trip is **not contractually guaranteed to be byte-identical**, and behavior is undocumented. — https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/ (fetched directly; "contains no mention of these topics", accessed 2026-06-11)
- Community-reported, undocumented server-side mutations include: mark reordering/consolidation, collapsing of adjacent same-type nodes (e.g. consecutive paragraphs within a listItem merged), enrichment with attributes such as `localId`, and **silent dropping** of unsupported/invalid nodes rather than a 400. Multiple developers report "breaking behavior changes in the Jira Cloud API without any obvious contract/versioning signal." — https://community.atlassian.com/forums/Jira-questions/Jira-Cloud-API-breaking-behavior-changes-without-contract/qaq-p/3219419 ; synthesized in Perplexity deep-research pass (sources collated 2026-06-11)
- The ADF renderer/Forge tooling can "replace node types that are unsupported … with replacement content, or remove them entirely," indicating Atlassian's broader pattern of transforming rather than rejecting ADF. — https://developer.atlassian.com/platform/forge/ui-kit/components/adf-renderer/ (accessed 2026-06-11)

Why INCONCLUSIVE on specifics: Atlassian publishes **no canonical list** of store-time normalizations. The exact set (does it inject `localId` on *these* node types? does it always merge adjacent paragraphs?) is empirically observed and version-drifting, not contractual. Treat it as: "normalization happens; the precise transforms are not guaranteed."

**Implication (the key design guidance for the spec):**
- ✅ SAFE to assert: **structural invariants / node-type presence-or-absence** — e.g. "a `heading` node exists in the returned description," "no `blockquote` node appears as a child of any `listItem`," "a `panel`/`codeBlock` of the expected type exists." These survive normalization.
- ✅ SAFE to assert: rendered-text output of `adf_to_text` for content that does not depend on mutated attrs/ordering (AC-1/AC-3 assert on *rendered text*, which is robust to attr injection like `localId` and to mark reordering, provided the text/structure content is stable).
- ❌ AVOID asserting: the **exact returned ADF tree** (byte/JSON-equality) — would be flaky against `localId` injection, mark reordering, paragraph coalescing, and undocumented future drift.
- ⚠️ For AC-2 specifically: assert the **negative structural invariant** ("walk the returned ADF; assert no `blockquote` node is a direct child of a `listItem`") and that the create call returned a 2xx (no HTTP 400). Do NOT assert the rest of the list subtree byte-for-byte.

---

## Claim 4 — comment ADF round-trip (comment `body` returned as ADF object in v3)

**Verdict: CONFIRMED**

`POST /rest/api/3/issue/{key}/comment` accepts an ADF `body`, and `GET /rest/api/3/issue/{key}/comment` returns each comment's `body` as an **ADF JSON object** by default (HTML only via `?expand=renderedBody`). ADF is the documented storage format for issue-comment text.

- v3 intro: ADF support applies to `body` in comments. — https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/ (accessed 2026-06-11)
- ADF structure ref: "in Jira Cloud platform, the text in issue comments … is stored as ADF." — https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/ (fetched directly, accessed 2026-06-11)
- Default GET returns raw ADF body; `?expand=renderedBody` adds HTML. — https://community.developer.atlassian.com/t/is-it-posible-to-get-the-body-comment-as-plain-text/41858 ; https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/ (accessed 2026-06-11)

**Implication for AC-3:** The `jr issue comments` read path inspecting `body` as ADF and rendering via `adf_to_text` is sound. Same Claim-3 caveat applies (assert rendered text / node-types, not exact tree). Ensure the comments read path does not inject `expand=renderedBody` if it expects the ADF object.

---

## Claim 5 — recency: v3 / ADF changes in the last ~12 months (2025–2026)

**Verdict: CONFIRMED (no breaking change to the relied-upon contract)** — with one adjacent item to monitor.

No deprecation or breaking change in the last ~12 months alters how `GET issue` / `GET comment` return ADF for description/comment bodies, nor the `POST/PUT /rest/api/3/issue` create/get contract. The core ADF representation in v3 responses has remained stable; examples from early 2025 continue to work in mid-2026.

Adjacent / monitor-only items surfaced (none break the #475 E2E path):
- **Classic API tokens → fine-grained scoped tokens for JPD GraphQL operations, effective 2026-11-01.** This targets **GraphQL**, not the REST v3 issue/comment endpoints used here. Not a blocker for the E2E path, but relevant to the broader CI service-account auth strategy. — https://developer.atlassian.com/cloud/jira/platform/changelog/ (accessed 2026-06-11)
- **JQL operates on most-recent 1,000 items per issue / group- & asset-based functions over 10,000 items will not run.** Affects JQL filtering of comment history, NOT direct `GET .../comment` pagination, which still returns full ADF bodies. Irrelevant to AC-1/2/3 (they create and read back a single fresh issue/comment). — https://developer.atlassian.com/cloud/jira/platform/changelog/ (accessed 2026-06-11)
- GDPR/user-privacy processing can alter user-mention rendering based on the requesting account's permissions. Only relevant if a test description/comment embeds `@mentions` — recommend the #475 fixtures avoid user mentions to keep assertions deterministic. — https://developer.atlassian.com/cloud/jira/platform/deprecation-notice-user-privacy-api-migration-guide/ (accessed 2026-06-11)

---

## Overall ASSESSMENT

**The F2 spec delta's external Jira-API assumptions are sound enough to proceed to F3/F4**, with one mandatory design constraint and three guardrails the spec must encode.

| Claim | Verdict | Blocks F3/F4? |
|-------|---------|----------------|
| 1 — description returned as ADF object (v3) | CONFIRMED | No |
| 2 — `listItem` forbids `blockquote` (normalization required) | CONFIRMED | No |
| 3 — server-side normalization risk | CONFIRMED risk; INCONCLUSIVE on exact transforms | No — drives assertion strategy |
| 4 — comment `body` returned as ADF object (v3) | CONFIRMED | No |
| 5 — recency (no breaking change) | CONFIRMED | No |

**Mandatory design constraint (from Claim 3):** the spec MUST assert **structural invariants and `adf_to_text` rendered output**, NOT exact returned-ADF-tree equality. Specifically:
1. **AC-1:** assert on `adf_to_text(...)` rendered text and/or presence of expected node *types* (heading, list, code block). Do not snapshot the raw `fields.description` JSON for equality.
2. **AC-2:** assert (a) create returned 2xx / no HTTP 400, and (b) the **negative structural invariant** — no `blockquote` is a direct child of any `listItem` in the returned tree. Do not equality-check the list subtree (paragraph coalescing / `localId` injection would make it flaky).
3. **AC-3:** assert on `adf_to_text(...)` of the returned comment `body`; do not snapshot raw comment ADF JSON.

**Guardrails the spec should encode:**
- Read the ADF object WITHOUT `?expand=renderedFields` / `?expand=renderedBody` (verify the `jr issue view` / `jr issue comments` paths don't inject those expands; if they do, the test inspects HTML, not ADF).
- Avoid `@mentions` and other user-identity nodes in #475 fixtures — GDPR/privacy processing makes them non-deterministic across accounts (Claim 5).
- Treat the returned ADF as authoritative-but-normalized: tolerate injected attrs (`localId`), reordered marks, and coalesced adjacent paragraphs. Build a small "find node of type X under parent of type Y" tree-walk helper rather than comparing trees.

**Residual uncertainty (flagged, not blocking):** the *exact* set of Jira store-time ADF normalizations is undocumented and version-drifting (Claim 3 INCONCLUSIVE). This is precisely why the node-type/rendered-text assertion strategy is mandated — it makes the tests robust to that uncertainty rather than dependent on resolving it.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source sweep of all 5 claims (v2/v3 ADF contract, listItem schema, server-side normalization, comment ADF, recency/changelog). `reasoning_effort: high`. |
| Perplexity perplexity_ask | 2 | (a) `listItem` permitted-child enumeration from official node ref; (b) confirm default GET returns ADF object for description+comment and expand→HTML behavior. ≤2-sentence factual lookups. |
| WebFetch | 3 | Direct fetch of official `listItem` node ref (verbatim content constraint), ADF `structure` ref (normalization/ADF-storage statements), and an attempted comment-group ref (truncated — superseded by perplexity_ask #2). |
| Training data | 0 areas | All external API claims sourced to web/official docs; none rest on model knowledge alone. |

**Total MCP tool calls:** 3 (1 research + 2 ask) — plus 3 WebFetch.
**Training data reliance:** low — every CONFIRMED/REFUTED verdict is anchored to an official `developer.atlassian.com` URL accessed 2026-06-11; the one source conflict (Claim 2) was resolved against the primary schema reference rather than community inference.

### Source conflict log (transparency, per #361 discipline)
- **Claim 2:** `sonar-deep-research` inferred (from conversion tools / community examples) that blockquote-in-listItem is permitted, while self-flagging the evidence as indirect. The official `listItem` node reference (https://developer.atlassian.com/cloud/jira/platform/apis/document/nodes/listItem/) enumerates exactly five allowed children, excluding `blockquote`. Resolution: official schema authoritative → blockquote FORBIDDEN, deep-research inference REFUTED. `jr`'s normalization is required.
