# Jira Cloud REST API v3 Write-Path Capability Research — Issue Triage

**Date:** 2026-08-21
**Type:** general (technology/implementation)
**Consumer:** `jr` feature triage for issues #674, #673, #578, #580
**Method:** Perplexity `perplexity_research` (sonar-deep-research), primary sources = developer.atlassian.com
**Verdict legend:** CONFIRM / REFUTE / INCONCLUSIVE, per question, with primary-source citations.

> All findings are "as of 2026-08-21". The Jira Cloud REST v3 landscape shifts; re-verify
> before shipping if this sits for more than a quarter. Where the developer reference does
> not make an explicit promise, the verdict is downgraded accordingly and the gap is named.

---

## Q1 (issue #674 — ADF mentions) — VERDICT: **CONFIRM** (with one INCONCLUSIVE sub-point)

**Sub-question breakdown:**

### 1a. Exact ADF `mention` node schema — **CONFIRM**
Per the ADF node reference (`developer.atlassian.com/cloud/jira/platform/apis/document/nodes/mention/`):

- `type`: `"mention"` (required)
- `attrs.id`: **required** — for an individual Jira Cloud user this is the Atlassian **accountId**
  (schema formally allows "Atlassian Account ID or collection name" so non-individual mentions
  are representable).
- `attrs.text`: **optional** — the rendered display text *including the leading `@`*
  (e.g. `"@Mia Krystof"`). Presentation only; identity comes from `attrs.id`.
- `attrs.userType`: **optional** — allowed values `DEFAULT`, `SPECIAL`, `APP`. Atlassian's own
  doc example uses `"APP"`, which is NOT appropriate for a human user — omit it or use `DEFAULT`.
- `attrs.accessLevel`: **optional** — allowed values `NONE`, `SITE`, `APPLICATION`, `CONTAINER`.

**Minimal valid node** (schema-minimum for a user mention):
```json
{ "type": "mention", "attrs": { "id": "5b10a2844c20165700ede21g" } }
```
**Recommended node for `jr`** (include `text` so Jira has the intended textual form):
```json
{ "type": "mention", "attrs": { "id": "5b10a2844c20165700ede21g", "text": "@Mia Krystof" } }
```
Do NOT emit `userType`/`accessLevel` unless there's a specific reason; neither is documented
as necessary for an ordinary user mention. This maps cleanly onto `jr`'s existing `src/adf.rs`
inline-node emission.

### 1b. Does a REST-POSTed mention actually fire the "you were mentioned" notification? — **CONFIRM (inferred, not verbatim)**
A valid `mention` node in an ADF comment body POSTed to `/rest/api/3/issue/{key}/comment` is a
**real Jira mention, not styled text**, and triggers Jira's normal mention-notification path:
- a direct/in-app notification (explicit mentions are classified as direct notifications), and
- a mention email if the recipient has that email enabled (personal setting labeled
  "You're mentioned in a comment").

**Caveat / INCONCLUSIVE sub-point:** Atlassian's REST v3 *Add Comment* reference page does **not**
contain a single verbatim sentence promising "POSTing this ADF node fires the standard mention
email + in-app notification." The CONFIRM is synthesized from (1) the REST contract accepting ADF,
(2) ADF semantics (`mention` = a user mention), and (3) Jira's documented mention behavior. There
is **no `notifyUsers` switch** documented for Add Comment (unlike some other write endpoints), so
`jr` cannot suppress/force the notification at the comment endpoint. Practical recommendation:
validate end-to-end against a live instance (an E2E test in `tests/e2e_live.rs`) before making a
notification guarantee in user-facing docs.

### 1c. Additional requirement — recipient must have access — **CONFIRM**
The mentioned user must be able to **view the issue**: normally **Browse Projects** permission
plus membership in any applicable issue-security level. Without it, no email is sent and the
mention can't usefully link the recipient. (The *poster* separately needs Browse Projects + Add
Comments + issue-security access.) Delivery can also be defeated by the recipient disabling
activity/mention emails, or a malformed/plain-text mention.

### 1d. Resolving name/email → accountId — **CONFIRM**
Use `GET /rest/api/3/user/search?query={urlencoded name or email}` and take the selected result's
`accountId`. Requires the **Browse users and groups** global permission (otherwise returns an
empty list). Results only cover users found within the first ~1,000-user search range. `query`
may be an email, display name, or other user attribute — but Atlassian does **not** promise an
exact or unique match, so `jr` should disambiguate when multiple results return (mirrors the
existing `partial_match.rs` disambiguation pattern). Note `jr` already has user-search plumbing
in `src/api/jira/users.rs`.

### 1e. GDPR-era caveats — **CONFIRM**
- Cloud identity must use `accountId` — legacy `username`/`name`/`key`/`userKey` are gone.
- `displayName` may be the account's **public** name, not full name.
- Email may be **omitted** from search results (hidden by profile visibility) — `jr` must not
  assume email is returned; searching *by* email still works but a match isn't guaranteed.
- `accountId` is stable and not hidden by profile-visibility controls.

**Primary sources:** ADF mention node ref [nodes/mention/]; REST v3 issue/comment ref
[rest/v3/]; user-search ref [rest/v3/api-group-user-search/]; user-privacy migration guide
[deprecation-notice-user-privacy-api-migration-guide]; profile-visibility
[platform/profile-visibility/]; notification-scheme/browse-permission support docs.

**`jr` implementation notes:** clean fit. Add a `--mention <name|email|accountId>` resolution
step (reuse user-search + disambiguation), emit the `mention` inline node via `adf.rs`. Cannot
promise the notification fires without a live E2E check; document the Browse-permission
precondition in help text.

---

## Q2 (issue #673 — set reporter on create) — VERDICT: **CONFIRM** (single-call works; behavior is permission- and screen-gated)

### 2a. One-call create vs follow-up PUT — **CONFIRM**
`fields.reporter` CAN be set directly in `POST /rest/api/3/issue` in a **single call**:
```json
{ "fields": { "project": {"key":"PROJ"}, "issuetype": {"id":"10001"},
              "summary": "…", "reporter": { "accountId": "5b10a2844c20165700ede21g" } } }
```
A follow-up `PUT /rest/api/3/issue/{key}` is only a **workaround** when the project config doesn't
permit reporter on the create screen — it is not the prescribed normal sequence.
- Documentation gap: the current v3 create-operation *example* shows `reporter.id`, not
  `reporter.accountId`; the `accountId` form is confirmed by the privacy migration guide (Cloud
  users identified by accountId) + community-verified successful creates. Use `accountId`.

### 2b. Governing permission — **CONFIRM**
- **Company-managed (classic):** the **Modify Reporter / Modify reporters** project permission.
- **Team-managed (next-gen):** the equivalent is named **Edit reporters**.
- The **authenticating actor** (not the target reporter) must hold it, in addition to create
  permission. A missing grant is the most common cause of failure.

### 2c. createmeta exposure + failure mode — **CONFIRM**
`GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` (the current,
paginated endpoint; the broad `GET /rest/api/3/issue/createmeta` is **deprecated**) exposes
`reporter` as a field with `fieldId: "reporter"` and an `operations` array containing `"set"`
**when it is available to that caller for that project/type**.
- If `reporter` is **absent** from createmeta → treat as **not create-settable**.
- Setting it anyway does **NOT silently succeed/ignore** — it normally returns **HTTP 400** with:
  `errors.reporter = "Field 'reporter' cannot be set. It is not on the appropriate screen, or unknown."`
- INCONCLUSIVE detail: no official v3 reference sentence promises that exact 400 body verbatim,
  but the error text is community-reproduced consistently. This matches `jr`'s existing editmeta
  pre-flight pattern — do a createmeta check and surface a clear "add Reporter to the create
  screen or grant Modify Reporter" hint on 400 rather than a raw API error.

### 2d. Company-managed vs team-managed vs JSM — **CONFIRM (no PUT-only rule for team-managed)**
- No current Atlassian doc says company-managed accepts create-time reporter while team-managed
  requires a second PUT. Same platform endpoint + metadata contract applies to both; only the
  permission name differs (Modify Reporter vs Edit reporters) and fields are configured per
  project/work type in team-managed.
- **JSM:** for a *true customer request*, prefer `POST /rest/servicedeskapi/request` and set the
  requester via top-level **`raiseOnBehalfOf`** (NOT `reporter` in `requestFieldValues`).
  Customer-only users cannot use `raiseOnBehalfOf`; check `canRaiseOnBehalfOf` in request-type
  field metadata. The generic platform `POST /rest/api/3/issue` can still create in a JSM project
  (subject to screen/permission rules) but lacks full customer-request semantics.
  INCONCLUSIVE: the JSM reference types `raiseOnBehalfOf` only as `string` and does not clearly
  state whether it must be accountId vs email — community examples use accountId. `jr` already
  has a JSM create fork (`jsm_create.rs`, ADR-0014) + `--on-behalf-of` flag; align there.

**Primary sources:** REST v3 issues ref [rest/v3/api-group-issues/]; privacy migration guide;
work-item-permissions support doc [jira-cloud-administration/docs/work-item-permissions/];
team-managed permissions [next-gen-permissions]; "cannot modify reporter" KB; JSM request ref
[service-desk/rest/api-group-request/] + `raiseOnBehalfOf`.

**`jr` implementation notes:** feasible in one create call. Add `--reporter <name|email|accountId>`
(resolve via user-search, same as Q1). Pre-flight createmeta for `reporter` with `set` op; if
absent OR on 400, emit an actionable hint (permission vs screen). On the JSM fork, route reporter
intent to `raiseOnBehalfOf` (already partially present as `--on-behalf-of`).

---

## Q3 (issue #578 — custom-field value semantics via editmeta) — VERDICT: **CONFIRM** (select + cascading); **CONFIRM-with-caveat** (Assets: editmeta is NOT sufficient)

### 3a. Single-select dropdown — **CONFIRM**
Write API accepts **either** `{"value":"<display text>"}` **or** `{"id":"<optionId>"}`.
- The v3 create-issue example itself uses the `value` form (`"customfield_80000": {"value":"red"}`).
- For normal Jira-managed select fields, `editmeta`/`createmeta` `allowedValues` entries in
  practice contain **both** `id` and `value` (e.g. `{"self":"…/customFieldOption/10331","value":"Assignee","id":"10331"}`),
  so a CLI CAN accept human display text and map it to an id.
- **Caveat (INCONCLUSIVE at the spec level):** the formal v3 reference types `allowedValues`
  loosely and some illustrative examples show plain strings, not `{id,value}` objects. So `jr`
  should **validate the runtime shape** rather than assume both keys always exist. Stronger
  fallback = the context-options endpoint (Q4), which reliably returns both `id` and `value`.

### 3b. Cascading select — **CONFIRM**
Exact write shapes (both documented):
```json
// by display value
{ "fields": { "customfield_X": { "value": "parent", "child": { "value": "child" } } } }
// by option id (preferred after resolution — display values can repeat across parents)
{ "fields": { "customfield_X": { "id": "10112", "child": { "id": "10115" } } } }
```
`child` is **nested inside** the parent selection — do NOT flatten to separate fields. Resolve
parent first, then a child belonging to that parent. In the `update`/`set` form:
`{"update":{"customfield_X":[{"set":{"id":"10112","child":{"id":"10115"}}}]}}`.
Option discovery: `allowedValues` nests children under parents; the context-options endpoint
(Q4) returns a flat list where child options carry `optionId` = parent id.

### 3c. Assets/CMDB object custom field — **CONFIRM shape; REFUTE "editmeta is sufficient"**
Documented Cloud write value is an **array of object descriptors** under `update.customfield_X[].set`:
```json
{ "update": { "customfield_X": [ { "set": [ {
  "workspaceId": "f1668d0c-…",
  "id": "f1668d0c-…:88",          // global id = <workspaceId>:<objectId>
  "objectId": "88"
} ] } ] } }
```
- `editmeta` is **NOT enough** to build this. An Assets field's editmeta entry has
  `schema.custom = "com.riadalabs.jira.plugins.insight:rlabs-customfield-default-object"`,
  `operations: [add,set,remove]`, and **no `allowedValues`** — it identifies the field as an
  Assets object field but supplies neither the workspace nor candidate objects.
- Required discovery path (which `jr` already largely has in `src/api/assets/`):
  1. workspaceId via `GET /rest/servicedeskapi/assets/workspace` (`api/assets/workspace.rs`)
  2. AQL search `POST …/jsm/assets/workspace/{wsId}/v1/object/aql` (`api/assets/objects.rs`)
  3. build the descriptor from returned `workspaceId`, `globalId`, object `id`.
- The direct `fields` (non-`update`) form is plausible but Atlassian's KB explicitly demonstrates
  only the `update`/`set` form — prefer `update`/`set` for edit for max documentation backing.

**Primary sources:** REST v3 issues ref [rest/v3/api-group-issues/]; JSM field-input-formats
[service-desk/rest/intro/]; context-options ref [rest/v3/api-group-issue-custom-field-options/];
Assets payload KB [jira/kb/format-the-payload-to-update-assets-custom-fields-via-rest-api/];
Assets object REST [cloud/assets/rest/api-group-object/].

**`jr` implementation notes:** select + cascading are a good fit for editmeta-driven mapping
(`jr` already does editmeta for `--field`). For select, accept display text, map to id from
`allowedValues`, but guard against the loose shape (fall back to context-options). Assets needs
the existing AQL/workspace machinery, not editmeta — reuse `api/assets/`.

---

## Q4 (issue #580 — field option enumeration) — VERDICT: **CONFIRM**

### 4a. Enumerate options for a context — **CONFIRM**
`GET /rest/api/3/field/{fieldId}/context/{contextId}/option` returns a paginated
`PageBeanCustomFieldContextOption` with **all options for that context** (parents first, then
cascading children in display order). Each entry has `id` and `value`; cascading children also
carry `optionId` (parent id). Covers checkbox/radio/single/multi/cascading Jira-created options.
Requires **Administer Jira** (or applicable Edit Workflow) permission. App-owned field options
use the separate "Issue custom field options (apps)" APIs.

### 4b. Discover the contextId — **CONFIRM**
`GET /rest/api/3/field/{fieldId}/context` returns all contexts in `values[]`; each `id` is a
`contextId`. Fields flagged `isGlobalContext` / `isAnyIssueType`. **Do not blindly pick the first
context** if multiple exist — resolve the one that applies to the relevant project + issue type
via `POST /rest/api/3/field/{fieldId}/context/mapping` with `{projectId, issueTypeId}` pairs
(response gives applicable `contextId` or `null`). `.../projectmapping` and `.../issuetypemapping`
GETs can also inspect assignments.

### 4c. Simpler single-call path — **CONFIRM (context-scoped, not authoritative inventory)**
For a *specific issue or create context* you can get `allowedValues` in **one call**:
- existing issue: `GET /rest/api/3/issue/{key}/editmeta`
- create: `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}`
These are conditioned on the issue/screen/workflow/user, and omit fields not
editable/visible — so use them for "what may this user select **here**", but use the
context+option path for the full administrative option inventory. There is **no** simpler
context-free "list all options for a field" endpoint (`GET /rest/api/3/customFieldOption/{id}`
fetches only one already-known option by id).

### 4d. Pagination — **CONFIRM (with an undocumented-cap caveat)**
Both context and option endpoints accept integer `startAt` + `maxResults`; responses include
`startAt`, `maxResults`, `total`, `isLast`, `values`. Loop until `isLast == true`, advancing
`startAt += returned maxResults`. **The v3 reference does NOT publish an explicit default or
contractual max `maxResults`** for these two operations (examples show `maxResults: 100`, but an
example is not a contract). Operational evidence (a Jira ticket) reports the context-option
endpoint caps at **100**. Best practice: request a large `maxResults`, then trust the smaller
returned value as the effective cap. This matches `jr`'s existing offset-pagination helper in
`src/api/pagination.rs` — reuse it, drive on `isLast`.

**Primary sources:** issue-custom-field-options ref [rest/v3/api-group-issue-custom-field-options/];
issue-custom-field-contexts ref [rest/v3/api-group-issue-custom-field-contexts/];
issues/editmeta+createmeta ref [rest/v3/api-group-issues/]; v3 intro [rest/v3/intro/].

**`jr` implementation notes:** two-step (context → options) is the authoritative path; the
`context/mapping` POST resolves ambiguity when a field has multiple contexts. For a `jr`
"list field options" command, drive pagination on `isLast` via `pagination.rs`, and offer the
editmeta/createmeta one-call view as a fast path for issue-scoped selection.

---

## Cross-cutting notes for `jr`

- **accountId resolution is shared infra** across Q1 (mention) and Q2 (reporter/on-behalf-of):
  one `resolve user → accountId` helper (user-search + disambiguation) serves both. Already
  partially present in `src/api/jira/users.rs` + `src/cli/issue/helpers.rs`.
- **editmeta/createmeta pre-flight is the existing `jr` idiom** (used for `--field`). Q2, Q3,
  Q4 all lean on it. The recurring caveat: `allowedValues` shape is not spec-guaranteed to carry
  both `id` and `value` — validate at runtime, fall back to context-options.
- **Notification behavior (Q1b) and exact 400 bodies (Q2c) are the only INCONCLUSIVE-at-spec
  items** — both are community-consistent but not verbatim in the v3 reference. Gate any
  user-facing guarantee behind a live E2E check (`tests/e2e_live.rs`).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 4 | Deep multi-source synthesis, one per question (ADF mention schema+notifications; create-time reporter; custom-field write shapes via editmeta; field-option enumeration endpoints). All grounded on developer.atlassian.com primary sources. |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 0 areas | Not relied upon for any verdict; all claims sourced to Atlassian docs/community via Perplexity citations. |

**Total MCP tool calls:** 4 (all `perplexity_research`, `reasoning_effort` default/high for architecture-feeding depth)
**Training data reliance:** low — every verdict is backed by Atlassian primary-source citations
returned by the research tool; the two INCONCLUSIVE sub-points (Q1b notification wording, Q2c 400
body) are explicitly flagged as community-consistent but not verbatim in the developer reference.
