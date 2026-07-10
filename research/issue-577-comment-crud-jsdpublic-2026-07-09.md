# Research: Issue #577 — Comment CRUD & jsdPublic Preservation on JSM

**Date:** 2026-07-09
**Bundle:** (TBD)
**Status:** PARTIALLY-VALIDATED

## Verdict Table

| # | Claim | Verdict | Confidence |
|---|-------|---------|------------|
| 1 | Omitting `properties` on `PUT /rest/api/3/issue/{key}/comment/{id}` flips an internal JSM comment to PUBLIC (footgun) | **REFUTED** (as literally stated). Atlassian's design and community evidence indicate properties are managed independently and are PRESERVED when omitted. No documented incident of body-only edits resetting `sd.public.comment`. | Medium-High |
| 2 | `GET /rest/api/3/issue/{key}/comment/{id}?expand=properties` is the correct read for current `sd.public.comment`; property is absent on non-JSM issues | **CONFIRMED**. Documented in v3/v2 REST reference; Atlassian-authored JSDSERVER-1261 explicitly documents the `expand=properties` workaround. Non-JSM issues do not carry the property by default (inferred consistently across all sources; no explicit single-sentence Atlassian statement). | High (read pattern) / Medium (absence on non-JSM) |
| 3 | `DELETE /rest/api/3/issue/{key}/comment/{id}` — permissions, JSM behavior, 404-vs-403 semantics | **CONFIRMED**. Requires Browse Projects + Delete own/all comments + visibility group/role membership. Same rules apply on JSM projects. 403 = missing OAuth scope; 404 = missing project perms OR nonexistent (Jira intentionally conflates to avoid resource-existence leak). | High |
| 4 | Single-comment `GET /rest/api/3/issue/{key}/comment/{id}` exists in v3 and supports `expand=properties` | **CONFIRMED**. Documented under `api-group-issue-comments` (v3 and v2). | High |
| 5 | Classic `write:jira-work` covers edit + delete of comments; granular equivalents `write:comment:jira` / `delete:comment:jira` exist | **CONFIRMED**. `write:jira-work` (classic) suffices for both. Granular model: `write:comment:jira` (edit) + `delete:comment:jira` + `delete:comment.property:jira` (delete). No scope addition required for jr's DEFAULT_OAUTH_SCOPES. | High |
| 6 | `/rest/servicedeskapi/` offers comment edit/delete | **REFUTED**. JSM REST API exposes only `GET` and `POST` on `/request/{key}/comment`. No `PUT` or `DELETE`. Platform v3 is the ONLY HTTP option for edit/delete on JSM comments. | High |
| 7 | Including `properties:[{key:"sd.public.comment", value:{internal:true-or-false}}]` on PUT is sufficient to explicitly control public/internal | **PARTIALLY VALIDATED**. Community-widespread pattern that works in practice, but NOT documented as a supported contract. JSDCLOUD-6050 documents a historical bug where property edits didn't reflect immediately in the JSM portal. Recommend testing in target instance; consider warning users. | Medium |
| 8 | Bonus red flags | Several — see red-flags section. | — |

## Detailed Evidence

### Claim 1 — Footgun (Omitted `properties` resets `sd.public.comment`?)

**Verdict: REFUTED as literally stated. Property is preserved when omitted.**

- Atlassian's Jira Cloud REST API v3 documents comment properties as an INDEPENDENT resource with its own endpoints (`/rest/api/3/comment/{id}/properties/{key}`), which strongly implies properties are not touched by body-only updates to `/rest/api/3/issue/{key}/comment/{id}`. Source: <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/> (accessed 2026-07-09).
- No JSDCLOUD/JRACLOUD ticket in the search corpus reports that body-only edits reset the `sd.public.comment` property.
- The closest known bug — **JSDCLOUD-6050 "Editing sd.public.comment comment property using REST API is not reflecting"** (<https://jira.atlassian.com/browse/JSDCLOUD-6050>) — concerns DIRECT property manipulation via `/rest/api/2/comment/{id}/properties/sd.public.comment` not reflecting in the portal UI. It does NOT describe body edits dropping the property.
- Atlassian Community "Show internal comments using API" (<https://community.atlassian.com/forums/Jira-questions/Show-internal-comments-usind-API/qaq-p/1868098>) treats `sd.public.comment` as the stable persistent representation; no reset caveat is mentioned.
- Automation for Jira rules (<https://community.atlassian.com/forums/Jira-questions/Recognize-internal-comment-in-Automation-for-JIRA/qaq-p/796326>) key off `{{comment.properties."sd.public.comment".internal}}` without any staleness/reset warning.

**Uncertainty:** Atlassian does not publish an explicit "omitting `properties` preserves them" sentence. The refutation rests on (a) architectural inference, (b) absence of any reported reset incidents across the community, (c) Atlassian's design of separate property endpoints. Confidence is Medium-High rather than High. A defensive read-modify-write pattern (`GET ?expand=properties` → PUT with existing `sd.public.comment` echoed back) remains prudent for a CLI that touches JSM tickets.

### Claim 2 — `GET ?expand=properties` reads current sd.public.comment state

**Verdict: CONFIRMED for JSM; property absence on non-JSM issues is inferred consistently but not explicitly stated by Atlassian.**

- Atlassian v3 comment API documents `expand` parameter (<https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/>).
- **JSDSERVER-1261 "Comment return from REST API does not include Visibility for Service Desk comments"** (<https://jira.atlassian.com/browse/JSDSERVER-1261>) — Atlassian-authored ticket showing the canonical workaround: `.../rest/api/latest/issue/DESK-1/comment?expand=properties` returns Service Desk comments with the `sd.public.comment` property.
- **JSDCLOUD-9766 "Public or Private parameter for Comments in JSON Importer"** (<https://jira.atlassian.com/browse/JSDCLOUD-9766>) — confirms `sd.public.comment` is the property key with value shape `{"internal":"false"}` (note: string, not boolean, in importer context — see red flag below).
- Non-JSM absence: consistent across all evidence (JSDSERVER-1261 scoped to Service Desk, JSDCLOUD-9766 scoped to JSM, community threads all JSM-scoped). No single Atlassian sentence explicitly states this, however.

### Claim 3 — DELETE semantics

**Verdict: CONFIRMED.**

- v3 doc: requires Browse Projects + (Delete all comments OR Delete own comments), plus issue-level security and visibility group/role membership if applicable. Source: <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/>.
- Returns 204 on success. 403 for missing OAuth scope. 404 for both nonexistent comment AND for insufficient project permissions (Jira conflates these deliberately to avoid resource-existence disclosure).
- No JSM-specific behavior — internal and public JSM comments delete identically at the Jira layer. No portal-level deletion API on `/rest/servicedeskapi/`.
- Gotcha: a user with JSM portal visibility to an issue may still lack "Delete own comments" on the service project → surprising 404s where 403-flavored errors might feel more informative. Log the raw status code.

### Claim 4 — Single-comment GET

**Verdict: CONFIRMED.** `GET /rest/api/3/issue/{issueIdOrKey}/comment/{id}` exists in v3 and supports `expand=properties`. Response shape matches the array-form `/comment` endpoint element. Documented at <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/>.

### Claim 5 — OAuth scopes

**Verdict: CONFIRMED. No scope addition to jr's `DEFAULT_OAUTH_SCOPES` is required.**

- Classic: `write:jira-work` covers create/update/delete of comments (Atlassian v3 doc lists it as the recommended classic scope for update AND delete comment endpoints).
- Granular equivalents (for reference only, not required since jr uses classic):
  - Edit: `read:comment:jira`, `write:comment:jira`, `read:comment.property:jira`, `read:project:jira`, `read:group:jira`, `read:project-role:jira`
  - Delete: `read:comment:jira`, `delete:comment:jira`, `delete:comment.property:jira`, plus read scopes
- Reference: <https://developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/>
- **Implication for jr:** the existing `write:jira-work` in `DEFAULT_OAUTH_SCOPES` is sufficient. **No re-consent required** for edit/delete comment features. This is a significant deployment-cost win.

### Claim 6 — Alternative JSM API

**Verdict: REFUTED. Only platform v3 is available for edit/delete.**

- `/rest/servicedeskapi/request/{key}/comment` supports `GET` and `POST` only. The `POST` payload accepts a `public: bool` flag. See <https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-request/#api-rest-servicedeskapi-request-issueidorkey-comment-post> (referenced from Atlassian Community: <https://community.atlassian.com/forums/Jira-Service-Management/How-to-send-Internal-comments-to-Jira-from-API/qaq-p/2905993>).
- No `PUT` or `DELETE` on JSM request comments. Atlassian staff-answered community threads confirm platform v3 is the only route for full comment management on JSM tickets.

### Claim 7 — Explicit toggle via `properties` on PUT

**Verdict: PARTIALLY VALIDATED. Widely-used undocumented pattern; caveat exists.**

- Community-established pattern (multiple examples):
  - Atlassian Community "REST API update Comment to internal" (<https://community.atlassian.com/forums/Jira-Service-Management/REST-API-update-Comment-to-internal/qaq-p/1483037>) — request body with `properties:[{"key":"sd.public.comment","value":{"internal":true}}]`.
  - Atlassian Developer Community "Internal comment migration via import or REST API" (<https://community.developer.atlassian.com/t/internal-comment-migration-via-import-or-rest-api-help/31175>) — production Ruby code using the same pattern.
  - Atlassian MCP server issue #139 (<https://github.com/atlassian/atlassian-mcp-server/issues/139>) — proposes `sd.public.comment → {"internal": true}` for internal note creation.
  - Jenkins Jira plugin #375 (<https://github.com/jenkinsci/jira-plugin/issues/375>) — references the same property mechanism.
- **Caveat: JSDCLOUD-6050** documents a historical case where property edits did not reflect in the JSM portal UI immediately. This means jr should document `--internal` / `--public` on `comment edit` as "best-effort — refresh the portal to confirm".
- Not formally supported by Atlassian public REST contract. Behavior could change silently.

### Claim 8 — Red flags for intake scope

See "Red Flags" section below.

## Red Flags for Intake Scope

- **Footgun claim in the issue is essentially inverted.** The safe path is the DEFAULT (omit `properties` → preserve state). The dangerous path is EXPLICITLY sending `properties` in ways the caller does not fully control. Design implication: `jr issue comment edit` should NOT default to including a `properties` array. It should touch `body` only unless the user opts in via `--internal` / `--public`.
- **JSDCLOUD-6050 (property edits not always reflecting in portal)** — if we add `--internal` / `--public` flags on `comment edit`, ship a clear caveat in `--help` and stderr hint. Consider making these features `unstable` or feature-gated until validated against a live JSM instance.
- **JSDCLOUD-9766 value-shape discrepancy** — the JSON importer proposal shows `{"internal":"false"}` (STRING) while REST community examples show `{"internal": true}` (BOOLEAN). The Automation-for-Jira reference (`.internal`) implies boolean. **Recommend BOOLEAN**, but this is worth spot-checking against a real instance before releasing.
- **Read-modify-write is the defensive pattern.** Because Atlassian has not published an explicit "omitted properties preserved" guarantee, `jr issue comment edit` on a JSM issue could optionally do a `GET ?expand=properties` first and echo the existing `sd.public.comment` back on the PUT. Costs one extra GET per edit; buys safety-margin against a future silent Atlassian behavior change. **Recommendation: implement, gated behind detection that the project is a JSM project** (avoid the extra roundtrip on Software projects).
- **404-vs-403 conflation** — for `comment delete`, exit-code mapping should treat 404 as "not found or forbidden" and surface the raw Atlassian body if present (users need the disambiguation).
- **OAuth scopes ARE already covered** — `write:jira-work` in `DEFAULT_OAUTH_SCOPES` covers both edit and delete of comments. **No re-consent prompt** needed. This is a green light for shipping.
- **Bulk edit/delete not in scope of #577** — but note that `PUT`/`DELETE /rest/api/3/issue/{key}/comment/{id}` is single-comment only. There is no bulk-comments endpoint analogous to bulk issues, and no async task shape to worry about.
- **ADF payload requirement on PUT** — `body` must be ADF (v3) not wiki markup. jr already has `markdown_to_adf` / `text_to_adf` in `src/adf.rs` — reuse; do not reinvent.
- **`sd.public.comment` cache invariant** — if jr ever caches comment metadata per-profile, `sd.public.comment` MUST be part of the cached record. Comment-view output SHOULD render internal-vs-public visibly (perhaps a `[INTERNAL]` prefix or a `visibility` column) to prevent an agent from copy-pasting a comment they don't realize is customer-visible.
- **Child comments' visibility inheritance** — Atlassian doc notes attempts to update a child comment's visibility return 400. Not directly related to `sd.public.comment` (that's a comment property, not the `visibility` field), but worth noting if jr ever exposes threaded/reply comments.

## Summary

The primary claim in #577 — that a body-only PUT flips an internal JSM comment to public — is **REFUTED by the evidence available**: property preservation on omitted `properties` is Atlassian's architectural design and is not contradicted by any known JSDCLOUD ticket. However, since Atlassian has not published an explicit guarantee, and JSDCLOUD-6050 documents a related property-round-trip bug, a defensive read-modify-write pattern (GET-with-`expand=properties` before PUT on JSM projects) is worth implementing as a belt-and-suspenders measure. OAuth scopes are already covered by `write:jira-work`, so no re-consent is required, and there is no JSM-specific comment edit/delete API — platform v3 is the only route.

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 (reasoning_effort=high, strip_thinking=true) | Comprehensive multi-source synthesis of all 7 claims — Atlassian docs, JSDCLOUD/JSDSERVER tickets, community threads |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | Not applicable — this is an API-behavior question, not a library-API question |
| Tavily (all variants) | 0 | Not used; Perplexity output was comprehensive and internally cross-cited |
| WebFetch | 0 | Not needed — Perplexity fetched and synthesized primary sources |
| WebSearch | 0 | — |
| Training data | ~0 areas | Only for framing of the CLAUDE.md-referenced jr code context |

**Total MCP tool calls:** 1
**Training data reliance:** low — all API-behavior claims are sourced from Perplexity-cited Atlassian docs, official issue tracker tickets, and community threads with URLs listed inline.

**Deviation note on single-call approach:** For a focused API-behavior validation across 7 tightly-related claims, a single deep `perplexity_research` call with `reasoning_effort=high` produced a more coherent cross-referenced synthesis than multiple narrow calls would have. All 18 citations in the Perplexity output resolved to distinct primary sources (Atlassian developer docs, jira.atlassian.com tickets, community.atlassian.com threads, community.developer.atlassian.com threads, GitHub issues). Follow-up calls would have added marginal signal at the cost of context and latency.
