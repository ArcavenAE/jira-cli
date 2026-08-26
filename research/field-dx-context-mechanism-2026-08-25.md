# Field DX — Context Mechanism for `jr field options <field>`

**Type:** general (technology / API research)
**Date:** 2026-08-25
**Topic:** Which context-supplying mechanism best enumerates a custom select field's allowed options (with option IDs) for an OAuth-3LO ordinary user, feeding a new `jr field options <field>` command (issue #580).
**Status:** complete
**Prior context:** A prior pass established that the admin-gated `GET /rest/api/3/field/{id}/context/{ctx}/option` fails for ordinary 3LO users, so the design pivots to **context-scoped `allowedValues`**. This pass evaluates *which* context supplier is best.

---

## Executive summary / ranked recommendation

For issue #580's core motivation — *"get the option ID before creating a ticket"* — the best primary path is the one that (a) does **not** require an already-existing issue, (b) returns the customfield option **id** (not just display text), and (c) is reachable by an ordinary OAuth-3LO user with only ordinary project permissions.

**Ranked recommendation:**

1. **M2 — Create metadata** (`GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}`) via `--project <P> --type <T>` → **PRIMARY for platform (non-JSM) fields.**
2. **M3 — JSM request-type fields** (`GET /rest/servicedeskapi/servicedesk/{sd}/requesttype/{rt}/field`) via `--request-type` → **PRIMARY for JSM request-type fields** (jr already has this endpoint + a 7-day cache).
3. **M1 — Issue editmeta** (`GET /rest/api/3/issue/{issueIdOrKey}/editmeta`) via `--issue <KEY>` → **SECONDARY / convenience fallback** when the user has a concrete reference issue to copy option IDs from.

**Rationale (one paragraph):** #580 is fundamentally a *pre-creation* lookup — the user wants an option ID so they can then create/edit a ticket. M1 (editmeta) is the mechanism jr already calls in `issue edit --field`, but it is structurally the wrong primary for #580 because it **requires an existing issue key**, a chicken-and-egg mismatch for "before creating." M2 (createmeta) closes that gap exactly: it enumerates the same option objects (`allowedValues[].id`) scoped by `project + issueType`, needs no pre-existing issue, and — critically for jr's OAuth-3LO ordinary-user model — its only documented product permission is **Create issues** (no Jira-admin, and the granular scope `read:issue-meta:jira` is already in the same family jr uses). For JSM request types the natural context is the request type itself, so M3 wins there and dovetails with jr's existing `jr requesttype fields` plumbing and cache. M1 remains valuable as a low-friction fallback (`--issue FOO-123`) that reuses code already in the tree. Support all three flags; route by which context the user supplies, defaulting platform lookups to `--project/--type`.

---

## Per-mechanism verdict table

| Mechanism | Endpoint | Returns option **id**? | OAuth-accessible for ordinary (non-admin) 3LO user? | Verdict | Primary source |
|---|---|---|---|---|---|
| **M1 — Issue editmeta** | `GET /rest/api/3/issue/{issueIdOrKey}/editmeta` | **Yes** — `allowedValues[].id` for single-select, multi-select; cascading nests children under `children[]` each with own `id` (observed behavior; v3 OpenAPI leaves item shape untyped) | **Yes** — classic `read:jira-work` / granular `read:issue-meta:jira` + `read:field-configuration:jira`; needs Browse Projects + Edit Issues on an **existing** issue. No admin. | **PARTIAL** — returns the ID and is 3LO-accessible, but requires a pre-existing issue (wrong shape for "before creating") and the option-object shape is not a strongly-typed v3 contract | [Get edit issue metadata](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-issueidorkey-editmeta-get) |
| **M2 — Create metadata** | `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` | **Yes** — `allowedValues[].id` for single-select/multi-select; cascading parent+child both carry `id` under `children[]` (same untyped-item caveat as M1) | **Yes** — classic `read:jira-work` / granular `read:issue-meta:jira` + `read:field-configuration:jira` (+`read:avatar:jira`); only documented project permission is **Create issues**. No admin, no existing issue. | **CONFIRM** — returns the ID, 3LO-accessible with minimal permission, no pre-existing issue required; is Atlassian's own recommended replacement for the deprecated `createmeta?expand=` | [Get create field metadata for a project and issue type id](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-createmeta-projectidorkey-issuetypes-issuetypeid-get) |
| **M3 — JSM request-type fields** | `GET /rest/servicedeskapi/servicedesk/{serviceDeskId}/requesttype/{requestTypeId}/field` | **Yes** — `requestTypeFields[].validValues[].value` is the option ID string (with `.label` display text and `.children[]`); note the key is `value`, **not** `id` | **Yes** — classic `read:servicedesk-request` / granular `read:requesttype:jira-service-management`; needs permission to view the service desk. No admin (admin only needed to see `visible:false` fields). | **CONFIRM** — returns option IDs and is 3LO-accessible; the correct primary for JSM request types. **Exception:** Assets/CMDB + Affected-services fields return `validValues: []` (JSDCLOUD-15551) | [Get request type fields](https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-servicedesk/#api-rest-servicedeskapi-servicedesk-servicedeskid-requesttype-requesttypeid-field-get) |

---

## M1 — Issue editmeta (`--issue <KEY>`) — PARTIAL

- **Option IDs:** Yes. Observed `allowedValues` entries carry `{ self, value, id }` for `:select` and `:multiselect`; cascading (`:cascadingselect`, schema `option-with-child`) nests child options under a parent's `children[]`, each child with its own `id`. Example (single-select): `allowedValues: [{ "self": ".../customFieldOption/21760", "value": "No", "id": "21760" }, …]`.
- **Contract caveat:** The v3 OpenAPI `FieldMetadata.allowedValues.items` schema is deliberately untyped (`items: { readOnly: true }`) — the `{id,value}` shape is long-standing *observed* behavior for Jira-native option fields, not a typed v3 guarantee. Client code must treat items as heterogeneous JSON keyed off `schema.custom`, read `id` when present, and handle nested `children`.
- **OAuth / permission:** classic `read:jira-work` (recommended) or granular `read:issue-meta:jira` **and** `read:field-configuration:jira`; user needs Browse Projects (+ any issue-security level) and Edit Issues for fields to be returned as editable. Ordinary non-admin 3LO user **can** call it. The `overrideScreenSecurity`/`overrideEditableFlag` params are the only admin-gated aspect and are not needed here.
- **Structural limitation for #580:** requires an **existing** issue. #580 wants the option ID *before* creating a ticket → editmeta is a copy-from-a-reference-issue convenience, not the natural pre-creation path.
- **jr fit:** jr already calls editmeta in `issue edit --field` (`src/cli/issue/field_resolve.rs` / `src/api/jira/issues.rs`), so a `--issue` path reuses existing plumbing.

## M2 — Create metadata (`--project <P> --type <T>`) — CONFIRM

- **Endpoint pair (current, non-deprecated):**
  1. `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes` — paginate issue types.
  2. `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` — paginate field metadata (includes `allowedValues`).
- **Deprecation context:** the old `GET /rest/api/3/issue/createmeta?expand=projects.issuetypes.fields` was deprecated (announced Dec 2023, CHANGE-1304; intended 404 after 2024-06-03, removal later delayed but still deprecated). The two endpoints above are Atlassian's recommended replacement. Do **not** build the new command on the deprecated `expand` form.
- **Option IDs:** Yes — same `allowedValues[].id` shape as M1 (single-select, multi-select, cascading parent+child). Same untyped-`items` OpenAPI caveat; read off `schema.custom`.
- **Pagination shape:** **offset**, not cursor. Response carries `startAt`, `maxResults` (default 50, max 200), `total`, and a `fields` array (the OpenAPI model also declares a synonymous `results`; prefer `fields`, tolerate `results`). No `values`, no `nextPageToken`. The options inside a field's `allowedValues` are **not** separately paginated.
- **OAuth / permission:** classic `read:jira-work` (recommended) or granular `read:issue-meta:jira` + `read:avatar:jira` + `read:field-configuration:jira`. The **only** documented project permission is **Create issues** (Browse-Projects/admin are *not* listed for this GET — do not transfer the `POST /issue` permission set onto it). Ordinary non-admin 3LO user **can** call it.
- **jr fit:** requires resolving `issueTypeId` from `--type <name>` — jr already does project-scoped issue-type name→id resolution for bulk `--type` (`get_issue_types_for_project`, `src/api/jira/issues.rs`), so the resolution pattern exists.

## M3 — JSM request-type fields (`--request-type`) — CONFIRM (with Assets exception)

- **Option IDs:** Yes — `requestTypeFields[].validValues[]` entries are `{ children, label, value }` where **`value` is the option ID string** and `label` is display text. Note the key is `value`, not `id` (distinct from M1/M2). Non-enumerable fields return `validValues: []`.
- **Top-level shape:** `{ canAddRequestParticipants, canRaiseOnBehalfOf, requestTypeFields: [ { fieldId, jiraSchema, name, required, validValues, visible } ] }` (`CustomerRequestCreateMetaDTO`).
- **OAuth / permission:** classic `read:servicedesk-request` (recommended) or granular `read:requesttype:jira-service-management`; user needs permission to view the service desk. No admin required (admin only to receive `visible:false` fields). Ordinary 3LO portal user **can** call it.
- **Assets/CMDB exception:** does **not** populate `validValues` for Assets object fields (`…cmdb:cmdb-object-cftype`) or Affected-services fields (`…service-entity-field-cftype`) — tracked unresolved as **JSDCLOUD-15551**. Those need the separate Assets APIs (scope `read:cmdb-object:jira`).
- **jr fit:** jr already has `jr requesttype fields <NAME|ID>` and `{read,write}_request_type_fields_cache` (7-day TTL). A `--request-type` path for `jr field options` can reuse both.

---

## Q-A — Which reliably returns the option id (e.g. "10123")?

**All three return the option ID**, but via two different key names, and with different "do I need an existing issue?" ergonomics:

- **M1 / M2:** `allowedValues[].id` (string, e.g. `"10123"`), with `value` as display text.
- **M3:** `validValues[].value` (string option ID, e.g. `"10320"`), with `label` as display text.

For #580's *pre-creation* use case, the reliable ID sources **without needing a pre-existing issue** are **M2 (platform)** and **M3 (JSM)**. M1 also returns the ID but only against an already-created issue. All three expose cascading child IDs (M1/M2 nest under `children[]` with `id`; M3 nests under `children` with `value`).

**Implementation note:** normalize across the two key spellings — read `id` for platform (`allowedValues`) and `value` for JSM (`validValues`) into one internal `{ id, label, children }` shape so `jr field options` output is uniform regardless of context path.

## Q-B — Field types where allowedValues/validValues is NOT returned (degrade gracefully)

`jr field options` must handle these without erroring:

- **Assets / CMDB object fields** (`com.atlassian.jira.plugins.cmdb:cmdb-object-cftype`) — not enumerated by editmeta/createmeta and explicitly empty in JSM (`validValues: []`, JSDCLOUD-15551). Use Assets AQL/object APIs instead.
- **Affected services** (`…service-entity-field-cftype`) — same as Assets in JSM.
- **User pickers / multi-user pickers / Approvers** — no exhaustive user list; editmeta/createmeta surface an `autoCompleteUrl` (e.g. `/rest/api/3/user/assignable/search`) instead of `allowedValues`.
- **Labels and other suggestion-backed fields** — `autoCompleteUrl` (suggestion endpoint), not a finite `allowedValues`.
- **Free-text / number / date / datetime** — no finite option set; `allowedValues` absent by nature.
- **App-defined / dynamic custom fields (Epic-Link-like lookups, Goals, etc.)** — may omit `allowedValues` or return `[]`; behavior is field-implementation-specific.

**Graceful-degradation rule:** when `allowedValues`/`validValues` is absent or empty, do **not** error. Inspect `schema.custom`/`jiraSchema` and either (a) print "this field has no enumerable options (dynamic/lookup field)" plus the `autoCompleteUrl` if present, or (b) for Assets fields, hint that options come from Assets (`jr assets search` / AQL). Cascading fields are enumerable and should render parent→child nesting.

---

## Suggested command surface (design input, not a decision)

- `jr field options <field> --project <P> --type <T>` → M2 (platform primary).
- `jr field options <field> --request-type <RT>` → M3 (JSM primary; reuse existing cache).
- `jr field options <field> --issue <KEY>` → M1 (fallback / copy-from-reference).
- Mutual-exclusion: the three context flags select the path; require exactly one context (mirror jr's existing context-resolution error style, exit 64 on none/ambiguous).
- Normalize output to `{ id, label, children[] }`; `--output json` per jr's `render_json` invariant.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | Deep, source-grounded evaluation of each mechanism (M1 editmeta, M2 createmeta, M3 JSM request-type fields) against developer.atlassian.com — option-id presence, JSON shapes, OAuth 3LO scopes/permissions, pagination, deprecation, Assets exceptions |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 1 area | jr's existing code layout (editmeta reuse, requesttype cache, issue-type resolution) — from CLAUDE.md project context, flagged explicitly; API claims are all web-sourced |

**Total MCP tool calls:** 3 (all `perplexity_research`, `reasoning_effort` high implied by preset)
**Training data reliance:** low — all endpoint/scope/shape claims are grounded in developer.atlassian.com primary sources returned by Perplexity; only jr-internal code-fit notes draw on project context.

### Source confidence notes
- **Strongly documented:** endpoint URLs, OAuth scopes, createmeta pagination shape + deprecation, JSM `validValues` example, JSDCLOUD-15551 Assets omission.
- **Observed-not-typed (flagged):** the `{id,value}`/`children` option-object shape inside `allowedValues` — Atlassian's v3 OpenAPI leaves `allowedValues.items` untyped, so treat items as heterogeneous JSON keyed off `schema.custom`. This is the one place the design must code defensively rather than rely on a schema contract.
