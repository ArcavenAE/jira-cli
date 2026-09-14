# General Research — Jira Cloud REST API v3 createmeta "fields" endpoint verification

- **Date:** 2026-09-14
- **Type:** general (technology / API contract verification)
- **Trigger:** A code change may have introduced a regression in `jr issue create --field` / `issue edit --field` createmeta resolution (`get_createmeta_fields`, `src/api/jira/issues.rs`; S-580-1, S-578-4). Need authoritative confirmation of the correct endpoint path and response shape.
- **Confidence:** HIGH — triangulated across the official REST v3 reference, the published OpenAPI schema, and Atlassian staff statements in the developer community.

---

## Verdict (crisp)

| Question | Answer | Source |
|---|---|---|
| Correct path for per-issue-type create FIELDS | `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` — **NO trailing `/fields`** | [1][2] |
| `.../issuetypes/{issueTypeId}/fields` | **Does NOT exist** as a documented endpoint. Not a real path. | [1][3] |
| Collection key | **`fields`** (array). The schema ALSO carries a `results` key pointing to the SAME value; use `fields`. Neither is `values`. | [4][2] |
| Pagination style | **Offset** — `startAt` / `maxResults` / `total`. **No** `isLast`, **no** `nextPageToken`. | [1][4] |
| Per-field entry shape | **Array of objects**: `fields: [{ "fieldId":.., "key":.., "name":.., "schema":.., "required":.., "operations":[..], "hasDefaultValue":.., "allowedValues":[..] }]` — NOT an object map keyed by field id. | [1][4] |

**Bottom line for the code path:** call `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}`, read the array from the top-level `fields` key, paginate with `startAt`/`maxResults` against `total`, and treat each element as an object exposing `fieldId`. If the code was changed to (a) append `/fields` to the path, (b) read a `values`/`results` key, (c) expect cursor pagination (`nextPageToken`), or (d) parse a field-id-keyed object map, that is a regression.

---

## 1. Which path is correct?

There are two granular endpoints, introduced when Atlassian deprecated the old bulk `GET /rest/api/3/issue/createmeta`:

| Operation | Documented path | Returns |
|---|---|---|
| Get create metadata issue types for a project | `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes` | Paginated list of issue types (no expanded field metadata) |
| Get create field metadata for a project and issue type id | `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` | A page of **field** metadata for one project + issue-type pair |

The candidate `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}/fields` is **not documented** anywhere in the REST v3 reference and is not the replacement path. The fields come back directly in the body of the `.../issuetypes/{issueTypeId}` response — there is no additional `/fields` segment. [1][3]

Reference anchors (developer.atlassian.com REST v3, Issues group):
- Issue types for a project: `#api-rest-api-3-issue-createmeta-projectidorkey-issuetypes-get`
- Fields for project + issue type: `#api-rest-api-3-issue-createmeta-projectidorkey-issuetypes-issuetypeid-get`

Note: the rendered reference page displays the titles/paths but not the literal OpenAPI `operationId` strings (`getCreateIssueMetaIssueTypes` / `getCreateIssueMetaIssueTypeFields`) in visible content; those identifiers come from the OpenAPI spec, not the rendered HTML.

## 2. Exact JSON response shape

Response model: **`PageOfCreateMetaIssueTypeWithField`**. Verified directly against the published OpenAPI schema [4], which lists exactly five top-level properties:

- `fields` — array of `FieldCreateMetadata` (read-only); "The collection of FieldCreateMetaBeans."
- `results` — array of `FieldCreateMetadata` (NOT read-only) — same items as `fields`.
- `startAt` — int64, "The index of the first item returned."
- `maxResults` — int32, "The maximum number of items to return per page."
- `total` — int64, "The total number of items in all pages."

There is **no** `isLast` and **no** `nextPageToken` in this schema → offset pagination, not cursor pagination. [4]

Atlassian's documented 200 example:

```json
{
  "fields": [
    {
      "fieldId": "assignee",
      "hasDefaultValue": false,
      "key": "assignee",
      "name": "Assignee",
      "operations": ["set"],
      "required": true
    }
  ],
  "maxResults": 1,
  "startAt": 0,
  "total": 1
}
```

Each element is a `FieldCreateMetadata` object with properties: `allowedValues`, `autoCompleteUrl`, `configuration`, `defaultValue`, `fieldId`, `hasDefaultValue`, `key`, `name`, `operations`, `required`, `schema`. [4] It is an ARRAY element, NOT an object map keyed by field id.

### `fields` vs `results` (important nuance)

The OpenAPI schema genuinely defines BOTH `fields` and `results` arrays. Atlassian staff (TrevorLao) explained in the deprecation thread: *"`results` is just a standard that all our existing paginated objects follow. In this case, they point to the same value. This could help in migrating to the new endpoint as `fields` was used in the old endpoint."* [5]

Practical guidance: **read `fields`** — it is the key shown in the official example and matches the legacy naming. `results` is a pagination-convention alias holding identical data. Do NOT switch to `values` (that key does not exist here) and do NOT rely solely on `results` — the concrete documented example emits `fields`.

### Contrast with the OLD (deprecated) bulk endpoint

The deprecated `GET /rest/api/3/issue/createmeta` returned a nested structure where fields were an **object map keyed by field id**:

```
projects[].issuetypes[].fields:
  { "customfield_10000": { "name":.., "schema":.. }, ... }   // OBJECT MAP (old)
```

The new granular endpoint uses an **array** instead:

```
fields: [ { "fieldId":.., "key":.., "name":.., "schema":.. }, ... ]   // ARRAY (new)
```

This array-vs-map difference is the single most likely regression trap if code was migrated or refactored.

## 3. Deprecation / changelog

- **CHANGE-1304 — "Create Issue Meta Endpoint Deprecation Notice."** Deprecated `GET /rest/api/3/issue/createmeta` ("Get create issue metadata"), replaced by the two granular operations above.
- Original announced deadline: *"deprecated 6 months from now, on Jun 3, 2024. After which, the endpoint will return a `404 - Not Found` error."* [5]
- **The June 2024 shutdown did NOT happen on schedule.** Atlassian staff acknowledged the old endpoint still had heavy traffic and are pursuing a lower-friction deprecation strategy. As of April 2025 posts in the thread, no firm new removal date exists; the old endpoint is described as on "borrowed time." [5]
- No replacement path ending in `/fields` was ever introduced. The issue-type-specific replacement is `.../issuetypes/{issueTypeId}`. [1][5]

Changelog anchor: `https://developer.atlassian.com/cloud/jira/platform/changelog/#CHANGE-1304` (note: the dynamically rendered changelog page did not expose CHANGE-1304's full body to retrieval tools; the Jun 3, 2024 wording is preserved verbatim in the Atlassian developer-community announcement [5]).

---

## Limitations / what could not be verified

- The literal OpenAPI `operationId` strings are not visible in the rendered reference HTML; they are inferred from the spec structure, not extracted from the page.
- Could not confirm from the public example whether every live tenant serializes BOTH `fields` and `results` simultaneously in a real response — the schema defines both, staff say they are equal, but the documented example shows only `fields`. Recommendation: parse `fields`, and if defensive, fall back to `results` only if `fields` is absent.
- The changelog page body for CHANGE-1304 was not directly retrievable (JS-rendered); deprecation wording is sourced from the developer-community thread that quotes it.

---

## Sources

1. Atlassian REST API v3 reference — Issues group (createmeta operations): https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/
2. Same reference, fields operation anchor: `#api-rest-api-3-issue-createmeta-projectidorkey-issuetypes-issuetypeid-get`
3. Same reference, issue-types operation anchor: `#api-rest-api-3-issue-createmeta-projectidorkey-issuetypes-get`
4. `PageOfCreateMetaIssueTypeWithField` OpenAPI schema (Atlassian spec mirror): https://apis.io/schemas/atlassian/atlassian-pageofcreatemetaissuetypewithfield/ ; item schema `FieldCreateMetadata`: https://apis.io/schemas/atlassian/atlassian-fieldcreatemetadata/
5. Atlassian developer community — "Create Issue Meta Endpoint Deprecation" (CHANGE-1304, staff statements on `results` vs `fields`, deadline slip): https://community.developer.atlassian.com/t/create-issue-meta-endpoint-deprecation/75413

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source synthesis of the two candidate createmeta paths, response shape, and CHANGE-1304 deprecation history |
| WebFetch | 2 | Direct verification of the `PageOfCreateMetaIssueTypeWithField` OpenAPI schema (property set, array-vs-map, pagination keys) and the Atlassian community deprecation thread (`results` vs `fields`, deadline) |
| WebFetch (failed) | 1 | Attempted direct fetch of the REST v3 reference anchor — page content truncated, not usable (compensated by schema-mirror fetch) |
| Training data | 0 areas | Not relied upon for the verdict — every load-bearing claim is web-sourced |

**Total MCP tool calls:** 1 (Perplexity research) + 3 WebFetch (2 successful, 1 truncated)
**Training data reliance:** low — endpoint path, response schema, and deprecation facts are all confirmed against official reference, the published OpenAPI schema, and Atlassian staff statements.
