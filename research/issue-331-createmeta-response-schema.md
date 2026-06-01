# Issue #331 — `createmeta/{projectIdOrKey}/issuetypes` Response Schema Verification

**Date:** 2026-06-01
**Trigger:** Live-Jira E2E failure — `Error: missing field \`values\` at line 1 column 1725`
**Endpoint:** `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes` (Jira Cloud REST API v3)
**Response object:** `PageOfCreateMetaIssueTypes`
**Verdict confidence:** HIGH — confirmed by 4 independent authoritative sources (Atlassian OpenAPI-derived TypeScript client + 3 Perplexity queries citing developer.atlassian.com).

---

## Verdict

| Question | Answer |
|----------|--------|
| **1. Array field name** | **`issueTypes`** — NOT `values`. (Secondary alias `createMetaIssueType` also exists in the generated client; `issueTypes` is the canonical/populated field.) |
| **2. Pagination model** | **Offset-style: `startAt` / `maxResults` / `total`. There is NO `isLast` field.** Terminate when `startAt + page_len >= total`, or when the returned page is empty. |
| **3. Element fields** | `IssueTypeIssueCreateMetadata`: `id` (string), `name` (string) both present. Full list: `self`, `id`, `description`, `iconUrl`, `name`, `subtask` (bool), `avatarId` (number), `entityId`, `hierarchyLevel` (number), `scope`, `expand`, `fields`. All optional in the schema. |
| **5. Endpoint currency** | `/issue/createmeta/{projectIdOrKey}/issuetypes` is the **CURRENT, non-deprecated** endpoint. The combined `/issue/createmeta` was deprecated Dec 2023 (CHANGE-1304). We are on the right endpoint. |

**The error "missing field `values`" is confirmed and explained:** our struct required a top-level `values` key that does not exist in this schema. The array is `issueTypes`. Additionally our `isLast`-based loop termination is wrong — `isLast` is not part of `PageOfCreateMetaIssueTypes`; it relied on a `#[serde(default = "default_true")]` fallback that made every page look like the last page (the loop only "worked" by accident on single-page projects, and would under-paginate large type schemes silently — a latent correctness bug independent of the deserialize failure).

---

## Source corroboration

The two initial Perplexity searches **conflicted**: one claimed `values` (by analogy to the generic Jira `PageBean` pattern), the other and the deeper `reason` analysis claimed `issueTypes`. This is exactly the "generic paged-response pattern" trap — many Jira `PageBean<T>` types DO use `values` + `isLast`, but the specialized `PageOf...` types do not. The runtime error ("missing field `values`") plus the OpenAPI-derived client resolve the conflict definitively in favor of **`issueTypes`**.

**Authoritative tiebreaker — Atlassian OpenAPI-generated TypeScript client (`jira.js`):**
`https://raw.githubusercontent.com/MrRefactoring/jira.js/master/src/version3/models/pageOfCreateMetaIssueTypes.ts`
```typescript
export interface PageOfCreateMetaIssueTypes {
  createMetaIssueType?: IssueTypeIssueCreateMetadata[];
  issueTypes?: IssueTypeIssueCreateMetadata[];
  maxResults?: number;
  startAt?: number;
  total?: number;
}
```
→ Array field is `issueTypes`. No `values`. No `isLast`. Pagination = `maxResults`/`startAt`/`total`. This file is generated 1:1 from the Atlassian v3 OpenAPI spec, so it reflects official field names. **Official OpenAPI wins on field names, and it agrees with the deep Perplexity analysis.**

**Element schema — `jira.js`:**
`https://raw.githubusercontent.com/MrRefactoring/jira.js/master/src/version3/models/issueTypeIssueCreateMetadata.ts`
→ `self, id, description, iconUrl, name, subtask, avatarId, entityId, hierarchyLevel, scope, expand, fields` (all optional). `id` and `name` confirmed present.

---

## Real example JSON (representative; no real org data)

```json
{
  "maxResults": 50,
  "startAt": 0,
  "total": 3,
  "issueTypes": [
    {
      "self": "https://your-domain.atlassian.net/rest/api/3/issuetype/10001",
      "id": "10001",
      "name": "Task",
      "description": "A task that needs to be done.",
      "iconUrl": "https://your-domain.atlassian.net/...",
      "subtask": false,
      "avatarId": 10318,
      "hierarchyLevel": 0
    },
    {
      "self": "https://your-domain.atlassian.net/rest/api/3/issuetype/10002",
      "id": "10002",
      "name": "Sub-task",
      "description": "A small piece of work that's part of a larger task.",
      "subtask": true,
      "hierarchyLevel": -1
    }
  ]
}
```
Note: **no `values` key, no `isLast` key.** Top-level keys are `maxResults`, `startAt`, `total`, `issueTypes` (and optionally `self` / `expand` per the generic page wrapper — treat as optional).

---

## Implementation fix — `src/api/jira/issues.rs`

### 1. `struct CreametaIssueTypesResponse` (currently lines ~717-729)

Replace the `values` + `isLast` struct with `issueTypes` + offset fields. Drop `default_true()` and the `is_last` field entirely.

```rust
/// Response wrapper for `GET /rest/api/3/issue/createmeta/{projectKey}/issuetypes`.
///
/// `PageOfCreateMetaIssueTypes` uses OFFSET pagination: `{issueTypes, startAt,
/// maxResults, total}`. There is NO `values` field and NO `isLast` field — those
/// belong to the generic `PageBean<T>` family, NOT to the specialized `PageOf...`
/// types. Termination is `startAt + issueTypes.len() >= total` (or an empty page).
/// Verified against the Atlassian OpenAPI-derived `jira.js` client and
/// developer.atlassian.com (issue #331; see
/// `.factory/research/issue-331-createmeta-response-schema.md`).
#[derive(Debug, serde::Deserialize)]
struct CreametaIssueTypesResponse {
    #[serde(rename = "issueTypes", default)]
    pub issue_types: Vec<IssueTypeEntry>,
    /// Total number of issue types across all pages. Defaults to 0 if absent
    /// (defensive — drives the offset-termination check).
    #[serde(default)]
    pub total: u32,
}
```
- `#[serde(rename = "issueTypes")]` maps the real field name.
- `#[serde(default)]` on `issue_types` guards against a page that omits the array (empty project).
- `total` is the offset-termination driver; `#[serde(default)]` → 0 means "stop after first page" defensively.
- **Delete** the `default_true()` fn (lines ~727-729) — no longer referenced.

### 2. Pagination loop in `get_issue_types_for_project` (currently lines ~677-693)

Switch from `isLast` to offset termination using `total`:

```rust
loop {
    let response: CreametaIssueTypesResponse = self
        .get(&format!(
            "/rest/api/3/issue/createmeta/{}/issuetypes?startAt={}&maxResults={}",
            urlencoding::encode(project_key),
            start_at,
            page_size,
        ))
        .await?;
    let total = response.total;
    let page_len = response.issue_types.len() as u32;
    all.extend(response.issue_types);
    // Offset termination: stop on empty page or once we've consumed `total`.
    // (`PageOfCreateMetaIssueTypes` has no `isLast`; total drives the loop.)
    if page_len == 0 || start_at + page_len >= total {
        break;
    }
    start_at += page_len;
}
Ok(all)
```
Also update the rustdoc on `get_issue_types_for_project` (line ~657): change "paginates until `isLast` is `true`" to "paginates by offset until `startAt + page_len >= total` (or an empty page)".

### 3. Tests

- Update any unit test that constructs `CreametaIssueTypesResponse { values: ..., is_last: ... }` to use `{ issue_types: ..., total: ... }`.
- Add/adjust a deserialize test with a real-shaped fixture (top-level `issueTypes` + `total`, NO `values`/`isLast`) to regression-pin the field name — this is the exact defect that escaped to live E2E.
- Add a multi-page pagination test (e.g., `total: 3`, `maxResults: 2`) to pin offset termination, since the prior `isLast`-default-true loop never actually paginated.

---

## Remaining ambiguity / optional tiebreaker

None material. The OpenAPI-derived client and the Perplexity deep analysis agree on every field. The only minor note: the generated client exposes BOTH `issueTypes` and a `createMetaIssueType` alias array — real Jira Cloud responses populate `issueTypes` (consistent with the live error pointing only at the missing `values`, and with developer.atlassian.com examples). If you want belt-and-suspenders against a tenant that ever returns `createMetaIssueType`, add `#[serde(alias = "createMetaIssueType")]` to the `issue_types` field — low cost, no downside.

**Optional read-only confirmation probe** (no mutation, safe):
```
jr issue list ... # not applicable; use a raw GET via the existing e2e harness:
GET /rest/api/3/issue/createmeta/<E2E_PROJECT>/issuetypes?maxResults=1
```
Inspect the top-level keys — expect `issueTypes`, `startAt`, `maxResults`, `total`; expect NO `values`, NO `isLast`. This is purely confirmatory; the fix above is already validated by sources and the live error.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity perplexity_search | 3 | (a) array field + pagination model; (b) element fields / PageOfCreateMetaIssueTypes shape; (c) endpoint deprecation status |
| Perplexity perplexity_reason | 1 | Deep analysis resolving the `values` vs `issueTypes` conflict; confirmed `issueTypes` + no `isLast` + offset pagination |
| WebFetch | 5 | Atlassian docs page (truncated x2), swagger-v3.v3.json (too large to scan x2), jira.js generated TS models (SUCCESS x2) |
| Training data | 0 areas | Not relied upon — every claim sourced to OpenAPI-derived client or Perplexity-cited Atlassian docs |

**Total external tool calls:** 9 (4 Perplexity + 5 WebFetch)
**Training data reliance:** low — the verdict rests on the Atlassian OpenAPI-generated `jira.js` client (definitive on field names) cross-confirmed by Perplexity citing developer.atlassian.com.

### Source URLs

- https://raw.githubusercontent.com/MrRefactoring/jira.js/master/src/version3/models/pageOfCreateMetaIssueTypes.ts (definitive: `issueTypes`, no `values`, no `isLast`)
- https://raw.githubusercontent.com/MrRefactoring/jira.js/master/src/version3/models/issueTypeIssueCreateMetadata.ts (element fields)
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ (endpoint group; deprecation status)
- https://community.developer.atlassian.com/t/create-issue-meta-endpoint-deprecation/75413 (CHANGE-1304 deprecation timeline)

### Source conflict (resolved)

Perplexity search #1 initially claimed the array field is `values` (by analogy to the generic `PageBean<T>` pattern). This was **REFUTED** by: (a) the live runtime error "missing field `values`", (b) the OpenAPI-derived `jira.js` client, and (c) Perplexity's own deeper `reason` analysis and targeted PageOfCreateMetaIssueTypes search. Official OpenAPI-derived schema wins: **`issueTypes`**, no `isLast`.
