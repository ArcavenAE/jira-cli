# Research: Issue #396 — JSM Request-Type Fields on `issue edit`

**Date:** 2026-05-22
**Type:** general (technology / API capability validation)
**Scope:** Validate whether `jr issue edit --field` can set JSM request-type-scoped
fields (Request Type, Urgency, Impact, other portal select fields) on an issue
that **already exists**. The `issue create` side is already implemented (`--request-type`
dispatches to `POST /rest/servicedeskapi/request`); this research covers the OPEN part:
post-creation editing.

---

## TL;DR Verdict Table

| # | Question | Verdict | Endpoint / Mechanism |
|---|----------|---------|----------------------|
| Q1 | `servicedeskapi` update/PATCH endpoint for existing-request fields? | **NO** | No such endpoint exists. `servicedeskapi/request` is create-only (POST). Updates documented as out-of-scope; tracked by JSDCLOUD-4609 ("Gathering Interest", open since 2016). |
| Q2 | Urgency / Impact editable via platform `PUT /rest/api/3/issue/{key}`? | **YES** (conditional) | `PUT /rest/api/3/issue/{key}` with `fields: { customfield_NNNNN: { id: "<optionId>" } }`. They are ordinary single-select custom fields. **Condition:** field must be on the issue's Edit screen. |
| Q3 | "Request Type" of an existing issue changeable via API? | **NO** (not reliably) | No supported API path. Platform `PUT` of the Customer Request Type field is reported to 500 / be rejected. Only ScriptRunner DB hacks or the JSM UI work. |
| Q4 | Does platform `PUT` require the field on the Edit screen? `editmeta` behavior? | **YES** | `PUT /rest/api/3/issue` only accepts fields present in `GET .../editmeta`. JSM request-type portal fields are NOT on the agent Edit screen by default — they must be added there by a project admin first. |
| Q5 | Documented reliable CLI way to set urgency/impact non-interactively? | **PARTIAL** | Yes for Urgency/Impact via platform `PUT` (treated as plain custom fields) — same path `jr issue edit --field` already uses. No tool (incl. `ankitpokhrel/jira-cli`, `acli`) has a JSM-specific path; they all just use platform issue-edit. No reliable way for Request Type itself. |

**Bottom line for #396:** `jr issue edit --field NAME=VALUE` for JSM fields is
**technically possible for Urgency / Impact / other request-type select fields**
via the platform endpoint `PUT /rest/api/3/issue/{key}` — the **same endpoint
`issue edit` already uses**. No new JSM-specific code path is required for these.
The blocker is environmental, not technical: the fields must be on the agent
**Edit screen**. **Changing the Request Type itself is NOT reliably possible** via
any supported API and should be declared out of scope.

---

## Q1 — Is `servicedeskapi/request` create-only? Any update/PATCH route?

**Verdict: NO** — there is no `servicedeskapi` endpoint to update fields of an
existing customer request.

The Jira Service Management Cloud REST API (`/rest/servicedeskapi/`) exposes
`POST /rest/servicedeskapi/request` for **creating** requests, plus read endpoints
(`GET .../request/{id}`, `.../comment`, `.../participant`, `.../approval`,
`.../sla`, etc.) and a few sub-resource POSTs (add comment, add participant,
transition). There is **no `PUT` / `PATCH` on `/rest/servicedeskapi/request/{id}`**
for editing field values such as urgency, impact, or request-type custom fields.

- Atlassian Support KB explicitly states the recommended pattern is **two-step**:
  "first use Service Desk REST API to create a ticket, then update the created
  issue with [the platform] Jira REST API" — confirming `servicedeskapi` itself
  has no update capability.
- The feature request for this capability, **[JSDCLOUD-4609 "Ability to update
  Customer request via REST API"](https://jira.atlassian.com/browse/JSDCLOUD-4609)**,
  is **still open** ("Gathering Interest", created Dec 2016, ~174 votes as of
  May 2026 — never implemented).

**Sources:**
- [Jira Service Management Cloud REST API — servicedesk group](https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-servicedesk/) (verified web)
- [JSDCLOUD-4609 — Ability to update Customer request via REST API](https://jira.atlassian.com/browse/JSDCLOUD-4609) (verified web, status "Gathering Interest")

---

## Q2 — Urgency / Impact editable via platform `PUT /rest/api/3/issue/{key}`?

**Verdict: YES (conditionally)** — Urgency and Impact are **ordinary single-select
custom fields**, not special portal-only constructs. They are editable via the
standard platform endpoint `PUT /rest/api/3/issue/{issueIdOrKey}` by passing their
`customfield_NNNNN` IDs in the `fields` object.

Key facts:
- Atlassian Community confirms (accepted answers, multiple threads) that **Urgency
  and Impact are custom fields** managed like any other single-select field — they
  have field contexts and option lists editable through normal custom-field admin.
- The correct `PUT` payload for a single-select JSM custom field uses the **option
  id**, not `value` or an `update` wrapper:
  ```json
  PUT /rest/api/3/issue/{key}
  { "fields": { "customfield_10176": { "id": "10286" } } }
  ```
  (A common failure mode is sending `{"update": {...}}` or `{"value": "..."}` —
  rejected; `{"id": "<optionId>"}` is the working shape.)
- They are **not** portal-only. JSM "ships" Urgency and Impact as standard custom
  fields; they are merely *associated with* incident-type request types via the
  request-type field configuration. Under the hood they behave identically to any
  other custom field on the platform API.

**Condition (see Q4):** the field must appear on the issue's **Edit screen** for
the `PUT` to accept it; otherwise it is rejected with a field-validation error.

**Sources:**
- [Atlassian Community — How to edit with Jira service management fields with api](https://community.atlassian.com/forums/Jira-Service-Management/How-to-edit-with-Jira-service-management-fields-with-api/qaq-p/2334676) (verified web — accepted answer shows the `{"id": "..."}` payload)
- [Atlassian Community — Change Impact and Urgency Field Values](https://community.atlassian.com/forums/Jira-Service-Management/Change-Impact-and-Urgency-Field-Values/qaq-p/1969532) (verified web — accepted answer confirms they are custom fields)
- [Jira Cloud platform REST API — Issues group](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/) (verified web — `PUT /rest/api/3/issue/{issueIdOrKey}`)

---

## Q3 — Can the "Request Type" of an existing JSM issue be changed via API?

**Verdict: NO** — there is no supported, reliable API to change the Request Type
of an issue after creation.

The Request Type is backed by the system custom field of schema type
`sd-customerrequesttype` (commonly seen as `customfield_NNNNN`, e.g.
`customfield_17801` in one reported instance). Its value is a special composite
key formatted as `lowercaseprojectkey/<uuid>` (e.g. `tst/33e5ca1a-54e2-...`),
not a plain id or name.

Findings:
- Even though `editmeta` may list a `set` operation for the field, attempting to
  edit it via `PUT /rest/api/3/issue` is **reported to return HTTP 500** and is
  considered unsupported. Accepted Community answer: *"when you try to edit the
  Request Type it has a notification that there is no API for editing the request
  type."*
- The Atlassian-supported way to change Request Type retrospectively is **UI-only**:
  a project admin adds the Request Type field to the agent Edit screen, then an
  agent changes it manually (or via Jira Automation, which uses an internal
  mechanism — not the public REST API).
- The only programmatic workaround found is a **ScriptRunner custom endpoint that
  manipulates the Jira database directly** — explicitly *"the standard API lacks
  support for updating Customer Request Type fields"*. This is not viable for a
  CLI tool.

**Recommendation for #396:** treat "change Request Type on an existing issue" as
**out of scope / not supported**. Document it as a deliberate non-goal, mirroring
the existing `requesttype fields` numeric-bypass and other documented JSM
limitations in `CLAUDE.md`.

**Sources:**
- [Atlassian Community — How to set Request Type when editing or transition an issue via REST API](https://community.atlassian.com/forums/Jira-questions/How-to-set-Request-Type-when-editing-or-transition-an-issue-via/qaq-p/1760976) (verified web — accepted answer: no API for editing request type; 500 on PUT)
- [Atlassian Community — How can I change the request type retrospectively?](https://community.atlassian.com/forums/Jira-Service-Management/How-can-I-change-the-request-type-retrospectively/qaq-p/3060543) (verified web — accepted answer: UI Edit-screen only)
- [Atlassian Community article — DIY REST API to update Customer Request Type](https://community.atlassian.com/forums/Jira-Service-Management-articles/DIY-REST-API-to-update-Customer-Request-Type-for-issue/ba-p/2163424) (verified web — confirms only a ScriptRunner+DB hack works)
- [Atlassian Support KB — Set the Request Type when creating an issue using REST API in JSM Cloud](https://support.atlassian.com/jira/kb/set-the-request-type-when-creating-an-issue-using-rest-api-in-jsm-cloud/) (verified web — Request-Type key format `projectkey/uuid`)

---

## Q4 — Does `PUT /rest/api/3/issue` require the field on the Edit screen? What does `editmeta` report?

**Verdict: YES** — the platform edit endpoint enforces Edit-screen membership.

- Atlassian's own documentation: *"The fields that can be updated can be determined
  using the `/rest/api/2/issue/{issueIdOrKey}/editmeta` resource. If a field is not
  configured to appear on the edit screen, then it will not be in the editmeta, and
  a field validation error will occur if it is submitted."*
- `GET /rest/api/3/issue/{key}/editmeta` is **discovery only** — it returns the set
  of fields editable on this issue and their allowed operations (`set`, `add`,
  `remove`) and `allowedValues`. It is not itself a write endpoint.
- **JSM request-type / portal fields (Urgency, Impact, request-type custom selects)
  are surfaced on the customer-portal request form, NOT automatically on the agent
  Edit screen.** A project admin must explicitly add them to the Edit (or
  Edit/View) screen for them to appear in `editmeta` and be acceptable to `PUT`.
- Practical consequence for `jr`: a `PUT` of `customfield_NNNNN` for a JSM field
  will succeed **only if** the field is on the Edit screen of that issue's
  project/issue-type. Otherwise the field is silently ignored or the request is
  rejected with a `400` field-validation error.

**Recommended `jr` behavior:** before/after a failed JSM `--field` edit, call
`GET .../editmeta` and, if the field is absent, emit an actionable hint:
"field <NAME> is not on the Edit screen for this project — ask a project admin to
add it to the request type's Edit screen". This matches the project's
"errors always suggest what to do next" convention.

**Sources:**
- [Atlassian Support KB — Set the Request Type when creating an issue using REST API in JSM Cloud](https://support.atlassian.com/jira/kb/set-the-request-type-when-creating-an-issue-using-rest-api-in-jsm-cloud/) (verified web — editmeta / edit-screen rule)
- [Atlassian Developer — Updating an Issue via the JIRA REST APIs](https://developer.atlassian.com/server/jira/platform/updating-an-issue-via-the-jira-rest-apis-6848604/) (verified web — editmeta is read-only discovery; un-SET-able fields are ignored)
- [Customize the fields of a request type — JSM Cloud](https://support.atlassian.com/jira-service-management-cloud/docs/customize-the-fields-of-a-request-type/) (verified web — request-type fields configured on portal form, separate from agent screens)

---

## Q5 — Documented reliable way for a CLI to set urgency/impact non-interactively? What do other tools do?

**Verdict: PARTIAL.**

- **Urgency / Impact (and other request-type select fields): YES, reliably** —
  via the platform `PUT /rest/api/3/issue/{key}` with
  `fields: { customfield_NNNNN: { id: "<optionId>" } }`. This is the **same
  endpoint and field-setting mechanism `jr issue edit --field` already uses** for
  platform custom fields. No JSM-specific code path is needed. The only added
  requirements are: (a) resolve the field name → `customfield_NNNNN` id, and
  (b) resolve a select value → option `id` (the `editmeta` `allowedValues` array
  gives both). The field must be on the Edit screen (Q4).
- **Request Type: NO** — no reliable non-interactive path (Q3).
- **Other tools:**
  - `ankitpokhrel/jira-cli` has **no JSM-specific edit path**. Its issue-edit
    commands target the standard platform issue-edit API; JSM custom fields are
    set the same way any custom field is (it has no special urgency/impact
    handling). It does not attempt to change Request Type.
  - Atlassian's official `acli` and the platform REST API likewise treat
    Urgency/Impact as ordinary custom fields edited via the platform issue API;
    none expose a `servicedeskapi`-based update (because none exists — Q1).
  - No mainstream tool offers a supported way to change Request Type
    post-creation; all rely on the JSM UI or ScriptRunner.

**Sources:**
- [ankitpokhrel/jira-cli — Releases](https://github.com/ankitpokhrel/jira-cli/releases) (verified web — feature set; no JSM-specific edit path)
- [Atlassian Community — How to edit with Jira service management fields with api](https://community.atlassian.com/forums/Jira-Service-Management/How-to-edit-with-Jira-service-management-fields-with-api/qaq-p/2334676) (verified web — platform PUT with `{"id": ...}` is the working method)
- [Jira Cloud platform REST API — Issues group](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/) (verified web)

---

## Recommendation for Issue #396 Implementation

1. **Scope `issue edit` for JSM fields to Urgency / Impact / request-type select
   fields ONLY** — explicitly exclude changing the Request Type itself.
2. **No new endpoint is required.** Route JSM field edits through the **existing
   platform path `PUT /rest/api/3/issue/{key}`** that `issue edit` already uses.
   Do NOT attempt a `servicedeskapi` update path — none exists.
3. **Value resolution:** JSM single-select fields need the option **`id`**, sent
   as `{"customfield_NNNNN": {"id": "<optionId>"}}`. `jr` should resolve
   `--field NAME=VALUE` by reading `GET .../editmeta` `allowedValues` to map the
   human value → option id. (This may justify a `--field` value-resolution
   enhancement; today `--field` on the JSM create path sends raw values to
   `servicedeskapi`, which resolves them differently.)
4. **Edit-screen precondition:** detect "field not on Edit screen" via `editmeta`
   and emit an actionable hint (Q4). This is the most likely real-world failure
   and is environmental (admin config), not a `jr` bug.
5. **Document the Request-Type limitation** in `CLAUDE.md` Gotchas, citing
   JSDCLOUD-4609 and the "no API for editing request type" finding, consistent
   with the project's external-citation discipline.

**Confidence:** High for Q1, Q2, Q3, Q5. High for Q4 (corroborated by Atlassian's
own KB plus developer docs). The one area requiring instance-level verification is
the exact `editmeta` output for a *specific* customer's Urgency/Impact field —
this depends on that project's screen configuration and cannot be determined
without testing against a live JSM project.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity perplexity_ask | 0 | (MCP Perplexity tools not invoked this session — see reliance note) |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_research | 0 | — |
| Perplexity perplexity_reason | 0 | — |
| Context7 | 0 | Not applicable — question is about a hosted REST API, not a library |
| Tavily | 0 | — |
| WebSearch | 4 | servicedeskapi update capability; urgency/impact editmeta editing; retrospective request-type change; ankitpokhrel/jira-cli JSM handling |
| WebFetch | 7 | JSDCLOUD-4609 status; Request Type KB; 5 Atlassian Community / docs threads (edit JSM fields, change impact/urgency, retrospective request type, edit-via-API request type, DIY ScriptRunner endpoint) |
| Training data | 1 area | General shape of `PUT /rest/api/3/issue` payloads — flagged; all load-bearing claims cross-checked against verified web sources above |

**Total external retrieval calls:** 11 (4 WebSearch + 7 WebFetch)
**Training data reliance:** low — every verdict is backed by at least one verified
Atlassian source (developer docs, support KB, official issue tracker, or accepted
Community answers). Q2/Q3 each corroborated by 2+ independent sources.

**Caveat:** The MCP Perplexity/Tavily servers were not exercised this session;
findings rest on Atlassian first-party documentation plus accepted Community
answers, which are authoritative for this API-capability question. If deeper
cross-validation is desired, re-run the same queries through `perplexity_research`.
