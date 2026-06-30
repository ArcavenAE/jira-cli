---
document_type: research-validation
title: "Holdout Coverage Gaps — External Behavioral-Ground-Truth Validation"
date: 2026-06-30
validates: holdout-coverage-gaps-2026-06-30-delta.md
author: research-agent
api_versions_verified:
  - "Jira Cloud Platform REST API v3 (developer.atlassian.com/cloud/jira/platform/rest/v3)"
  - "Jira Software Cloud Agile REST API 1.0 (developer.atlassian.com/cloud/jira/software/rest)"
  - "Jira Service Management Cloud REST API (developer.atlassian.com/cloud/jira/service-desk/rest)"
---

# Holdout Coverage Gaps — External Behavioral-Ground-Truth Validation

**Date**: 2026-06-30
**Validates**: `.factory/phase-f1-delta-analysis/holdout-coverage-gaps-2026-06-30-delta.md`
**Scope**: 10 behavioral claims (7 authorable-now targets + 3 blocked targets) checked against
authoritative Atlassian REST documentation and credible Atlassian-ecosystem sources.

**API versions in play (verified current, not training-data):** Jira Cloud Platform REST API **v3**,
Jira Software Cloud **Agile REST API 1.0** (`/rest/agile/1.0`), Jira Service Management Cloud REST API
(`/rest/servicedeskapi`). All three are the stable, current generations as documented on
developer.atlassian.com at validation time. No registry version pin is relevant — these are Atlassian
server-side API surfaces, not client libraries; the `jr` client (reqwest-based) targets these paths directly.

---

## Claim-by-Claim Verdicts

### Claim 1 — `edit --field`: editmeta is the authoritative source of settable fields; field absent → reject pre-flight, no PUT

**Verdict: CORROBORATED.**

The Jira Cloud Platform v3 "Issues" resource group documents `GET /rest/api/3/issue/{issueIdOrKey}/editmeta`
("Get edit issue metadata") as a dynamic per-issue, per-user descriptor of "the editing capabilities available
for a particular issue in the current context." The reference for the "Edit issue" operation itself links
editmeta to the edit payload: clients are expected to invoke editmeta first to discover the set of fields that
can be included in an edit request and the constraints on their values. A field absent from the editmeta
`fields` map is not on the issue's edit screen and is therefore not settable through the standard edit path.

This makes the `jr` behavior (field absent from editmeta → exit 64 + Edit-screen hint, zero PUT) a faithful
client implementation of the documented contract, and it is the only behavior consistent with the API: a PUT
that includes a field absent from editmeta would be rejected server-side. Pre-flight rejection is correct and
spec-grounded.

**Sources:**
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ (editmeta + Edit issue operations)
- https://community.developer.atlassian.com/t/allowedvalues-of-get-edit-issue-metadata-service-response/51384

**Justification:** Editmeta is documented as the per-issue editability descriptor and is tied to the Edit-issue
payload; H-NEW-EDIT-FIELD-001's pre-flight-reject + zero-PUT assertion is sound.

---

### Claim 2 — `edit --type` bulk camelCase/lowercase asymmetry: `selectedActions:["issuetype"]` (lowercase) vs `editedFieldsInput:{"issueType":{"issueTypeId":...}}` (camelCase)  — HIGHEST VALUE

**Verdict: CORROBORATED (asymmetry confirmed; documented implicitly via schema, not narrative prose).**

The v3 "Issue bulk operations" reference defines the `POST /rest/api/3/bulk/issues/fields` request body with
four top-level members: `selectedIssueIdsOrKeys`, `selectedActions`, `editedFieldsInput`, `sendBulkNotification`.

- **`selectedActions`** entries are *field IDs* as returned by `GET /rest/api/3/bulk/issues/fields`. Jira's
  canonical field ID for issue type is the lowercase system key **`issuetype`** (same key used throughout the
  per-issue create/edit API under `fields.issuetype`). So the `selectedActions` entry for an issue-type change
  is the lowercase string `"issuetype"`.
- **`editedFieldsInput`** is a typed container whose keys are *not* field IDs. The issue-type edit container is
  the camelCase key **`issueType`**, an object whose inner property is **`issueTypeId`** (a string id), i.e.
  `editedFieldsInput.issueType.issueTypeId`. This is shown in the OpenAPI-derived schema mirrors (Apidog import
  of Atlassian's spec) and is consistent with multi-select containers (`labelsFields`, `multipleVersionPickerFields`).

The asymmetry is therefore real and matches the CLAUDE.md Gotcha exactly: lowercase `"issuetype"` in
`selectedActions`, camelCase `"issueType"` (with string `issueTypeId`) in `editedFieldsInput`. **Caveat for the
spec author:** Atlassian documents this asymmetry *implicitly* through the schema shape; there is **no narrative
sentence** in the official docs calling it out. This does not weaken the holdout (the wire shape is what is
asserted), but the BC body should attribute it to the schema/OpenAPI definition, not to an FAQ paragraph. The
CLAUDE.md phrase "verbatim per Atlassian Bulk Ops FAQ" slightly overstates the source form — recommend the spec
cite the bulk-operations *schema* (api-group-issue-bulk-operations) plus the live-run confirmation already on file.

**Sources:**
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ (request schema)
- https://community.developer.atlassian.com/t/bulk-edit-issues-fix-version-via-rest/89939 (`fixVersions` symmetric example)
- https://community.developer.atlassian.com/t/bulk-edit-issue-not-working-properly/87213 (`labelsFields` example)
- Apidog OpenAPI mirror: https://krevt8mwkh.apidog.io/bulk-edit-issues-19180025e0 (`editedFieldsInput.issueType.issueTypeId`)

**Justification:** Field-ID-vs-container-key distinction is documented; issue type's field ID is `issuetype`
(lowercase, like `fixVersions`/`labels`) while its container key is the camelCase `issueType` with `issueTypeId`.
H-NEW-EDIT-TYPE-002's wire assertion is correct. Reframe the BC *source citation* from "FAQ" to the schema.

---

### Claim 3 — bulk transition nested schema: `{"bulkTransitionInputs":[{"selectedIssueIdsOrKeys":[…],"transitionId":"…"}],…}` (NOT flat)

**Verdict: CORROBORATED.**

The v3 bulk-operations reference roots the `POST /rest/api/3/bulk/issues/transition` request body at
`bulkTransitionInputs`, an array of objects, each containing `selectedIssueIdsOrKeys` and `transitionId` and
corresponding to a *distinct workflow*. An Atlassian-staff community thread confirms the nested design via the
documented error "Every transition input must correspond to a distinct workflow," which only makes sense for the
nested array. There is no documented flat top-level `selectedIssueIdsOrKeys`+`transitionId` form. This matches
CLAUDE.md's FIX-BULK-TRANSITION-001 exactly (flat shape rejected with 400 "bulkTransitionInputs must not be empty").

**Sources:**
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/
- https://community.developer.atlassian.com/t/issue-with-the-bulk-transition-issue-statuses-api-endpoint/99169 (Atlassian-staff: distinct-workflow rule on `bulkTransitionInputs`)
- https://community.atlassian.com/forums/Enterprise-discussions/Introducing-the-Bulk-Transition-API-Simplify-Your-Workflow/td-p/2884971

**Justification:** Nested `bulkTransitionInputs` is the documented and only-supported schema.

---

### Claim 4 — `issue changelog`: `fromString`/`toString` and `author` can be null (system/automation/anonymous)

**Verdict: CORROBORATED (behavior), INCONCLUSIVE (explicit doc statement).**

The v3 "Issues" reference documents the changelog response structure but does **not** explicitly state that
`fromString`/`toString` are nullable, nor that `author` may be absent. Empirically (and per community threads),
these fields are *not* always populated: clearing a field can record a non-null `from`/`fromString` with a null
`to`/`toString`, and system/automation events can lack a human `author`. The deep-research synthesis was explicit
that this is "plausibly true in practice but not explicitly documented" — i.e., true behavior, no authoritative
sentence guaranteeing it.

**Impact on the holdout:** This does **not** block H-NEW-CHANGELOG-001. The holdout is a *client-serialization*
contract: given a wiremock fixture that returns `fromString:null`/`toString:null`/`author:null`, assert `jr`'s
`--output json` preserves them as explicit `null` (not absent keys, not `{}`). That is fully within the client's
control and is the load-bearing behavior in BC-2.5.046 — the holdout does not depend on Jira *guaranteeing* nulls,
only on `jr` round-tripping nulls the fixture supplies. **Recommendation:** the BC body / holdout rationale should
phrase the precondition as "when Jira returns null …" (observed behavior, fixture-supplied) rather than asserting
the API is *documented* to return nulls. Avoid citing a specific Atlassian doc line as guaranteeing nullability.

**Sources:**
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ (changelog structure; no nullability guarantee)
- https://community.atlassian.com/forums/Confluence-questions/Jira-API-api-3-issue-key-changelog-fromstring-done-to-done/qaq-p/1531034
- https://community.developer.atlassian.com/t/deprecation-of-fields-values-epic-link-and-parent-in-issue-history-changelogs/48993/25

**Justification:** Nulls occur in practice but are not a documented guarantee. Holdout survives because it pins
*client serialization of fixture-supplied nulls*, not an API contract — but reframe the precondition wording.

---

### Claim 5 — `worklog add`: `timeSpent` string (e.g. "1h30m") passed verbatim to `POST .../worklog`; Jira applies duration format

**Verdict: CORROBORATED (passthrough + format acceptance), INCONCLUSIVE (exact invalid-string grammar).**

The v3 "Issue worklogs" reference documents `timeSpent` as a human-readable duration string and `timeSpentSeconds`
as its numeric equivalent; either may be supplied and Jira derives the other using the instance's time-tracking
settings (workday/workweek length). Atlassian/Postman examples show valid forms like `"3h 20m"`; forms like
`"1h 30m"`, `"2d"`, `"1w"` are accepted in practice. The reference does **not** publish a formal grammar or an
exhaustive list of invalid strings. This validates the `jr` design (client-side `parse_duration_validate` is a
syntax gate; the string is forwarded verbatim as `timeSpent`; server applies normalization) and BC-X.5.009's
"verbatim passthrough; server normalizes" contract.

**Impact on H-NEW-WORKLOG-ADD-001:** Sound. Call A (verbatim `"1h30m"` in POST body) is correct — `jr` must NOT
client-normalize to `90m`/`5400s`. Call B (invalid duration → exit 64 before POST) is a *client-side* gate
(`jr`'s own parser), so the absence of an authoritative invalid-grammar list is irrelevant: the holdout asserts
`jr`'s parser rejects a chosen bad input, not that Jira would reject it. **Note:** `jr` passes `timeSpent`
(string), not `timeSpentSeconds` — both fields exist; the holdout asserts `timeSpent` is the carrier, which is
the documented human-readable form.

**Sources:**
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-worklogs/
- https://www.postman.com/cs-demo/atlassian/request/rkwzz54/get-worklogs (`timeSpent:"3h 20m"`, `timeSpentSeconds:12000`)
- https://community.atlassian.com/forums/Jira-questions/Is-it-possible-to-change-time-tracking-format-to-only-hours-no/qaq-p/1962209 (instance time-tracking settings affect normalization)

**Justification:** Verbatim `timeSpent` passthrough and duration-format acceptance are documented/example-backed;
invalid-grammar is client-gated, so INCONCLUSIVE on the API side does not affect the holdout.

---

### Claim 6 — `issue link` default type: "Relates" is a real default link type; `POST /rest/api/3/issueLink` + `GET /rest/api/3/issueLinkType`

**Verdict: CORROBORATED (product behavior), INCONCLUSIVE (REST-spec guarantee).**

`POST /rest/api/3/issueLink` (create link) and `GET /rest/api/3/issueLinkType` (discover types) are documented in
the v3 "Issue links" group. Link types are *runtime-discoverable and instance-configurable*. "Relates"
(directional "relates to"/"is related to") is a standard default link type in fresh Jira Cloud instances per
product documentation and ubiquitous practice — but the **REST API reference does not enumerate default link
types or guarantee "Relates" is present** (admins can rename/delete it). So "Relates is a real default link type"
is true as a product/configuration fact, not a REST-spec guarantee.

**Impact on H-NEW-LINK-001:** Sound, because the holdout supplies the link-type list via wiremock
(`GET /issueLinkType` returns `[{"name":"Relates"}, …]`) and asserts `jr` defaults to `"Relates"` when no
`--type` is given. The default-to-"Relates" behavior is a *client default in `jr`*, not an API guarantee — the
fixture provides the type, so the holdout does not depend on Jira shipping "Relates". The ambiguous-type branch
(`--type block` matching 3 types → exit 64, zero POST) is pure client partial-match logic. Both branches are
spec-grounded and fixture-driven. **Recommendation:** ensure the BC body frames "Relates" as `jr`'s *default
selection* (and recommends runtime discovery via `GET /issueLinkType`), not as an asserted Jira default.

**Sources:**
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-links/ (`POST /issueLink`)
- https://developer.atlassian.com/cloud/jira/platform/rest/v2/api-group-issue-link-types/ (`GET /issueLinkType`)

**Justification:** Endpoints + runtime discovery documented; "Relates" is a product default, not a REST guarantee;
holdout is fixture-driven so it holds regardless.

---

### Claim 7 — `queue view` ordering: JSM `GET /rest/servicedeskapi/servicedesk/{id}/queue/{qid}/issue` returns issues in queue order (not alphabetical)

**Verdict: INCONCLUSIVE (strongly-supported inference; no explicit doc sentence).**

The JSM queue-issues endpoint is documented to return "a page of issues inside a queue" with only the queue's
configured fields, paginated by `start`/`limit`. A queue is conceptually an *ordered* view (a JQL "Filter by"
plus an "Order by" / ORDER BY clause; Rank-based ordering is a documented technique). The endpoint exposes **no
sort parameter** and documents no alternative default ordering. The structure strongly implies the endpoint
preserves the queue's intrinsic order — but **Atlassian's REST reference contains no explicit sentence stating
"issues are returned in queue order."** The cleanest authoritative statements are server/Data-Center queue-group
docs; the Cloud overview uses the same language but is less granular.

**Impact on H-NEW-QUEUE-VIEW-001 (the reorder assertion is the primary regression target):** PROCEED WITH A
REFRAME. The holdout's actual `jr` behavior — `jr` fetches queue-ordered keys from the queue endpoint, then
batch-fetches issue detail via `/search`, then **reorders the batch back into queue-key order** — is a `jr`
*client* contract (BC-X.8.009 issue-fetch-pipeline step 4), NOT an assertion about JSM's ordering guarantee.
That makes the holdout valid: the wiremock returns queue keys `["FOO-2","FOO-1","FOO-3"]` and a `/search` reply
in a *different* order; the assertion is that `jr` re-emits queue order. This is entirely within `jr`'s control
and is the documented reason the reorder step exists (search does not preserve the caller's key order). The
INCONCLUSIVE verdict on the *upstream* queue-ordering guarantee does **not** weaken the holdout, because the
holdout pins `jr`'s reorder-to-supplied-key-order, not JSM's internal sort. **Recommendation:** the BC body
should frame the precondition as "`jr` requests issue detail by the queue-supplied key order and reorders the
search response to match" — which is the real, observable client behavior — rather than asserting "JSM returns
queue order." This keeps the holdout grounded in the client contract and immune to the upstream doc gap.

**Sources:**
- https://developer.atlassian.com/cloud/jira/service-desk/rest/ (Cloud JSM REST overview; queue group)
- https://developer.atlassian.com/server/jira-servicedesk/rest/v1006/api-group-queue/ (queue-issues path + "only configured fields")
- https://deviniti.com/blog/customer-it-service/create-queues-in-jira-service-management/ ("Order by" configuration)
- https://community.atlassian.com/forums/Jira-Service-Management/Reorder-issues-in-Service-Management/qaq-p/2251327 (ORDER BY / Rank ordering)

**Justification:** Queue ordering is intrinsic and almost certainly preserved, but undocumented explicitly. The
holdout's load-bearing assertion is `jr`'s *reorder-to-queue-key-order* step, which is a client contract — so the
scenario survives; reframe the precondition wording to the client behavior.

---

### Claim 8 — `edit --label` schema fork: single-key `PUT /issue/{key}` bare-string labels vs multi-key `POST /bulk/issues/fields` `{"name":…}` label objects

**Verdict: CORROBORATED (asymmetry is real and documented/example-backed).**

- **Single-issue** `PUT /rest/api/3/issue/{issueIdOrKey}`: the `update` block manipulates labels as **bare
  strings** inside operation objects, e.g. `{"update":{"labels":[{"add":"examplelabel"}]}}`. Documented +
  community-corroborated.
- **Bulk** `POST /rest/api/3/bulk/issues/fields`: labels live under `editedFieldsInput.labelsFields`, where each
  label is a **label object with a `name` property** (`{"name":"examplelabel"}`), alongside
  `bulkEditMultiSelectFieldOption` (ADD/REMOVE). The official bulk doc describes `editedFieldsInput` generically;
  the concrete `labelsFields` shape with `{"name":…}` is shown in OpenAPI-derived mirrors and community/third-party
  examples.

This exactly matches CLAUDE.md's BUG-LABEL-400 description and confirms the asymmetry is **not** a `jr` quirk but
an Atlassian-API reality. **However**, note the same caveat as Claim 2: the bulk `labelsFields` internal shape is
documented *implicitly* (schema/examples), not in a narrative sentence in the primary reference.

**Sources:**
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ (single-issue `update.labels` bare strings)
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ (bulk `editedFieldsInput`)
- https://community.atlassian.com/forums/Jira-questions/Is-there-a-way-to-append-multiple-labels-to-an-existing-issue/qaq-p/2147110 (bare-string single-issue example)
- https://www.withone.ai/knowledge/jira/conn_mod_def::GJ4qWNqZBJo::svqahY4TRvGC7dnYFi06tg (bulk `labelsFields` with `{"name":…}` objects)

**Justification:** The single-key-bare-string vs multi-key-`{"name":…}` asymmetry is externally documented
(schema + examples). **This is enough to support a future BC sub-clause pass** for Target 3 — the wire shapes
are authoritatively grounded, so authoring EC-3.4.006-extension would not require source-internal invention.

---

### Claim 9 — `edit --dry-run`: is `plannedChanges` an Atlassian concept, or a client-only `jr` construct?

**Verdict: CORROBORATED — purely client-side; no Atlassian-side dry-run concept.**

There is no `--dry-run`, `plannedChanges`, or preview/simulate mode in the Jira Cloud edit/bulk APIs. The edit
(`PUT /issue/{key}`) and bulk (`POST /bulk/issues/fields`) endpoints either mutate or error; there is no documented
no-op preview. (The bulk endpoints offer `sendBulkNotification`, but that controls notifications, not mutation.)
Therefore `jr`'s `--dry-run` and its `plannedChanges` output are entirely a `jr` construct: `jr` performs read-only
resolution (editmeta / createmeta / `--jql` search) and prints what it *would* send, without issuing the PUT/POST.

**Impact on Target 4 (BLOCKED):** The F1 plan's BLOCKED verdict is correct **for the right reason** — the block is
*not* an external-truth gap (external truth is clear: it's client-only), it's a *spec-internal* gap: no BC bodies
the `plannedChanges` JSON shape. Because `plannedChanges` is a `jr`-invented structure, **only the `jr` spec can
define it** — external research cannot supply the shape. **Recommendation:** Target 4 must remain blocked until a
BC sub-clause defines the `plannedChanges` schema from the implementation; do not expect external docs to unblock
it. This is the one target where "author-vs-expand" must resolve to *expand the spec first*.

**Sources:**
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ (no dry-run/preview on Edit issue)
- https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ (no dry-run; only `sendBulkNotification`)

**Justification:** No Atlassian dry-run primitive exists; `plannedChanges` is `jr`-only and must be spec-defined
internally. External validation cannot unblock Target 4.

---

### Claim 10 — `board view`: Agile API `GET /rest/agile/1.0/board/{id}/configuration` distinguishes scrum vs kanban + column structure

**Verdict: CORROBORATED (explicitly documented).**

The Jira Software Cloud Agile REST API documents `GET /rest/agile/1.0/board/{boardId}/configuration` as returning
a configuration object including `id`, `name`, `filter`, `location`, a **`type`** field (Scrum vs Kanban), a
**`columnConfig`** object (named columns each mapping to one or more statuses), and `subQuery` (Kanban-only — which
itself confirms type-dependent structure). This is explicitly documented, not inferred.

**Impact on Target 10 (BLOCKED):** The block is correct but is purely a *spec-internal* anchor gap (no
individually-bodied BC for truncation/hint + scrum-vs-kanban path), **not** an external-truth gap. External truth
is solid: the scrum/kanban distinction and column structure are authoritatively documented. A future BC-5.1.005
sub-clause pass is well-supported externally — the scrum-path-vs-kanban-path distinction (sprint endpoint vs JQL
search) and the board-config discriminator are real and citable.

**Sources:**
- https://developer.atlassian.com/cloud/jira/software/rest/api-group-board/ (board configuration: `type`, `columnConfig`, `subQuery` Kanban-only)
- https://developer.atlassian.com/cloud/jira/software/rest/

**Justification:** Board-config `type` + `columnConfig` are explicitly documented; supports a future BC pass.

---

## Summary Table

| # | Claim | Verdict | Holdout impact |
|---|-------|---------|----------------|
| 1 | editmeta authoritative; absent field → pre-flight reject, no PUT | **CORROBORATED** | H-NEW-EDIT-FIELD-001 sound |
| 2 | bulk `--type`: `selectedActions:["issuetype"]` vs `editedFieldsInput.issueType.issueTypeId` | **CORROBORATED** (schema-implicit) | H-NEW-EDIT-TYPE-002 sound; reframe source cite from "FAQ" → schema |
| 3 | bulk transition nested `bulkTransitionInputs` (not flat) | **CORROBORATED** | (infra) sound |
| 4 | changelog `fromString`/`toString`/`author` can be null | **CORROBORATED** (behavior) / **INCONCLUSIVE** (doc guarantee) | H-NEW-CHANGELOG-001 sound; reframe precondition to "when Jira returns null" |
| 5 | worklog `timeSpent` string verbatim passthrough | **CORROBORATED** (passthrough) / **INCONCLUSIVE** (invalid grammar) | H-NEW-WORKLOG-ADD-001 sound (invalid gate is client-side) |
| 6 | "Relates" default link type; `POST /issueLink` + `GET /issueLinkType` | **CORROBORATED** (product) / **INCONCLUSIVE** (REST guarantee) | H-NEW-LINK-001 sound (fixture-driven); frame "Relates" as jr default |
| 7 | JSM queue endpoint returns queue order | **INCONCLUSIVE** (strong inference) | H-NEW-QUEUE-VIEW-001 sound; reframe to jr's reorder-to-key-order client contract |
| 8 | `--label` fork: single bare-string PUT vs bulk `{"name":…}` objects | **CORROBORATED** | Target 3 externally grounded → supports BC sub-clause pass |
| 9 | `--dry-run`/`plannedChanges` is client-only | **CORROBORATED** (no Atlassian concept) | Target 4 stays blocked; external research cannot unblock — spec-internal only |
| 10 | board config distinguishes scrum/kanban + columns | **CORROBORATED** | Target 10 externally grounded → supports BC sub-clause pass |

---

## Misattributed-Tracker-ID Check (citation discipline)

- No JRACLOUD-/JSDCLOUD- tracker IDs are asserted in the validated claims that I could refute. JSDCLOUD-4609
  (`sd-customerrequesttype` unsupported via API) is referenced in the F1 plan only to scope a behavior OUT; I did
  not independently re-validate it because no proposed holdout depends on it (the plan correctly excludes it).
- **One source-form flag (not a misattribution, a citation-form risk):** CLAUDE.md and the F1 plan describe the
  camelCase/lowercase asymmetry (Claim 2) and the bulk `labelsFields` object shape (Claim 8) as "verbatim per
  Atlassian Bulk Ops FAQ." External validation found these documented **implicitly via the request schema / OpenAPI
  definition and community examples**, not in a narrative FAQ paragraph. The behavior is correct; the *source form*
  should be cited as the bulk-operations schema (api-group-issue-bulk-operations) rather than an "FAQ," to satisfy
  the project's citation-discipline rule (the cited source must actually document the symptom in the claimed form).

---

## Closing Recommendation

**No proposed AUTHORABLE-NOW scenario must be dropped.** All 8 are behaviorally sound. Three require a
**precondition-wording reframe** (not a redesign), because the underlying *Jira* guarantee is weaker than the
claim's surface phrasing — but in each case the holdout's load-bearing assertion is a **`jr` client contract**
(serialization of fixture-supplied nulls; client-side duration gate; client default link type; client
reorder-to-queue-key-order), which is exactly what black-box holdouts should pin and is immune to the upstream
doc gaps:

1. **H-NEW-CHANGELOG-001** — frame the null precondition as "when Jira returns null `fromString`/`toString`/`author`
   (fixture-supplied)," asserting `jr`'s `--output json` preserves explicit nulls. Do not cite an Atlassian line
   guaranteeing nullability.
2. **H-NEW-QUEUE-VIEW-001** — frame as "`jr` reorders the `/search` response back to the queue-supplied key order"
   (BC-X.8.009 step 4), not "JSM returns queue order." The reorder is the regression target and is a client contract.
3. **H-NEW-LINK-001** — frame "Relates" as `jr`'s default-type *selection* (fixture provides the type list), not as
   an asserted Jira default.

Additionally, **reframe the source citation** for the Claim-2 / Claim-8 wire asymmetries from "Atlassian Bulk Ops
FAQ" to the bulk-operations **schema** (`api-group-issue-bulk-operations`) + the existing live-run confirmation,
to keep citation discipline intact.

**Blocked targets — external-documentation sufficiency for a future BC sub-clause pass:**

- **Target 3 (`--label` fork): SUFFICIENT.** The single-key bare-string vs multi-key `{"name":…}` asymmetry is
  externally grounded (Claim 8 CORROBORATED). A BC sub-clause (EC-3.4.006-extension) can be authored with
  confidence; the wire shapes are real, not invented.
- **Target 10 (`board view`): SUFFICIENT.** Scrum-vs-kanban path distinction and column structure are explicitly
  documented (Claim 10 CORROBORATED). BC-5.1.005 (or expansion of 5.1.003/004) is externally supportable.
- **Target 4 (`--dry-run` / `plannedChanges`): NOT EXTERNALLY ANCHORABLE — and need not be.** `plannedChanges` is a
  pure `jr` construct with no Atlassian analogue (Claim 9 CORROBORATED). External research cannot and should not
  unblock it; the BC sub-clause must define the `plannedChanges` schema from the `jr` implementation itself. Keep
  it blocked pending an internal spec-shape pass, not further research.

**Net:** Proceed with all 8 AUTHORABLE-NOW scenarios after the three precondition-wording reframes + the Claim-2/8
source-citation correction. Two of three blocked targets (3, 10) are externally ready for a BC sub-clause pass;
the third (4) is correctly blocked and is an internal-spec task, not a research gap.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 4 | (a) bulk fields camelCase/lowercase asymmetry + bulk transition nested schema [Claims 2,3]; (b) editmeta authority + changelog nulls + worklog timeSpent + link types/"Relates" [Claims 1,4,5,6]; (c) JSM queue ordering + Agile board config scrum/kanban/columns [Claims 7,10]; (d) label single-vs-bulk schema asymmetry [Claim 8] |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily tavily_* | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 1 area | Cross-check that REST v3 / Agile 1.0 / servicedeskapi are the current stable API generations and that `jr` targets these paths (consistent with CLAUDE.md); all behavioral verdicts grounded in retrieved sources, not training data |

**Total MCP tool calls:** 4 (all `perplexity_research`, `reasoning_effort: high` for Claims 1–3, `medium` for 7/10 and 8)
**Training data reliance:** low — every claim verdict is tied to a retrieved developer.atlassian.com page or named
community/OpenAPI-mirror source; training data used only to confirm API-generation currency.

---

# Final Scenario Validation (pre-commit)

**Date:** 2026-06-30 (second pass)
**Validates:** the FINAL, converged text of the 8 Group-13 holdout scenarios in
`.factory/specs/prd/holdout-scenarios.md` (lines 1334–1647), as a pre-commit gate.
**Scope:** confirm the EXTERNAL / real-world Atlassian-API facts each converged scenario asserts —
at the *fixture* granularity (response-envelope key names, endpoint methods, wire shapes), not just
the broad behavioral claims already validated in the first pass above. These scenarios already passed
source-code adversarial review; this pass catches external-fact errors before commit.

**Method:** 2 fresh `perplexity_research` calls (`reasoning_effort: high`) over developer.atlassian.com,
1 verbatim `WebFetch` of the official Bulk Operations FAQ, plus cross-checks against the repo's own
empirically-grounded research files (`issue-331-issuetype-bulk-schema.md`,
`issue-331-createmeta-response-schema.md`) and source structs (`src/api/jira/issues.rs`).

## Per-scenario verdict table

| Scenario | External fact(s) asserted | Verdict | Source |
|----------|---------------------------|---------|--------|
| **H-NEW-EDIT-FIELD-001** | `GET .../editmeta` is the authoritative per-issue settable-field descriptor; a field absent from the `fields` map is not settable → pre-flight reject, zero `PUT`. Endpoints `GET /rest/api/3/field`, `GET .../{key}/editmeta`, `PUT .../issue/{key}` all exist. | **CORROBORATED** | First-pass Claim 1; [A1] |
| **H-NEW-EDIT-FIELD-002** | Multi-key `--field` rejected by client C-1 guard BEFORE any HTTP. Only external dependency is endpoint existence (editmeta GET, PUT) — both real. Guard itself is a `jr` client contract. | **CORROBORATED** (client contract; endpoints real) | [A1] |
| **H-NEW-EDIT-TYPE-001** | Cross-project bulk `--type` → exit 64 before `createmeta/{proj}/issuetypes` GET and `bulk/issues/fields` POST. issueTypeId is **project-scoped** (single id can't span projects); both endpoints exist. | **CORROBORATED** | issue-331 research; [A1] |
| **H-NEW-EDIT-TYPE-002** (HIGHEST VALUE) | Bulk POST body asymmetry: `selectedActions:["issuetype"]` (lowercase) vs `editedFieldsInput.issueType.issueTypeId` (camelCase key, **string** value); `createmeta/{proj}/issuetypes` fixture key = **`issueTypes`**; bulk-poll `GET /rest/api/3/bulk/queue/{taskId}` returns `status:"COMPLETE"`. | **CORROBORATED** | Verbatim FAQ fetch [A3]; issue-331-bulk-schema; issue-331-createmeta-schema; [A1] |
| **H-NEW-CHANGELOG-001** | `GET .../{key}/changelog` returns a PageBean envelope keyed **`values`** (correctly distinguished from the embedded-`histories` shape); `author`/`fromString`/`toString` can be JSON `null`; holdout pins `jr`'s client serialization of fixture-supplied nulls. | **CORROBORATED** (behavior + envelope) / first-pass INCONCLUSIVE on doc *guarantee* — correctly reframed in converged text | First-pass Claim 4; [A1] |
| **H-NEW-WORKLOG-ADD-001** | `POST .../{key}/worklog` accepts `timeSpent` as a verbatim human-readable string; server normalizes via instance time-tracking settings. Bad-duration rejection is a `jr` client-side gate. | **CORROBORATED** (passthrough) / client-gated invalid-grammar | First-pass Claim 5 |
| **H-NEW-LINK-001** | `POST /rest/api/3/issueLink` + `GET /rest/api/3/issueLinkType`; the type-list response key = **`issueLinkTypes`**; "Relates" framed as `jr`'s default *selection* (fixture-supplied), not an API guarantee. | **CORROBORATED** | [A1]; first-pass Claim 6 |
| **H-NEW-QUEUE-VIEW-001** | JSM PagedDTO envelope = `size`/`start`/`limit`/`isLastPage`/`values`; `ServiceDesk` carries `projectId`; queue-issue endpoint has no sort param (queue order intrinsic); `POST /rest/api/3/search/jql` exists and returns `issues`+`nextPageToken`. Reorder-to-queue-order is a `jr` client contract (correctly framed). | **CORROBORATED** | [A2]; [A1]; first-pass Claim 7 |

## Discrepancies flagged (observations — none are must-fix)

1. **`createmeta/issuetypes` envelope key — DOC-TRAP REPRODUCED, holdout is CORRECT.** My fresh
   `perplexity_research` call [A1] asserted that `GET /rest/api/3/issue/createmeta/{proj}/issuetypes`
   returns its array under `values` (reasoning by analogy to the generic `PageBean<T>` pattern). This is
   the **exact documentation trap the repo already encountered and refuted** in
   `issue-331-createmeta-response-schema.md`: a live-Jira E2E run failed with the literal error
   *"missing field `values`"*, and the Atlassian OpenAPI-derived `jira.js` client
   (`pageOfCreateMetaIssueTypes.ts`) shows the field is **`issueTypes`** (no `values`, no `isLast`,
   offset pagination). The repo source (`src/api/jira/issues.rs::CreatemetaIssueTypesResponse`) uses
   `#[serde(rename = "issueTypes")]` with a dedicated regression pin
   (`test_createmeta_response_deserializes_issuetypes_field`). **The converged H-NEW-EDIT-TYPE-002 fixture
   (`{"issueTypes": [...]}`) is therefore CORRECT and matches empirically-verified real Jira behavior.**
   Do NOT "fix" it to `values` — that would re-introduce the exact #331 live-E2E defect. This is the
   single most important observation in this pass: the repo's live-Jira empirical ground-truth wins over
   the doc-reading inference.

2. **H-NEW-EDIT-TYPE-002 FAQ citation is CORRECT — supersedes the first-pass "reframe to schema" note.**
   The first-pass report (Claim 2 / Misattribution check) recommended reframing the source citation from
   the "Atlassian Bulk Operations FAQ" to the "schema/OpenAPI," on the basis that the asymmetry was
   documented only *implicitly*. A **verbatim WebFetch this pass [A3]** of the official "Bulk operations:
   additional examples and FAQs" page confirms the page **literally contains the JSON example** showing
   `selectedActions:["labels","issuetype","priority"]` (lowercase `issuetype`) alongside
   `editedFieldsInput.issueType.issueTypeId:"10013"` (camelCase, string) with `priority` and
   `labelsFields` coexisting. The FAQ page IS an explicit source-of-record for the asymmetry. Per the
   orchestrator's CRITICAL instruction (ORCHESTRATOR-RELAYED-FIX-CAUTION) and consistent with
   `issue-331-issuetype-bulk-schema.md` (which fetched this same page verbatim as "the source of truth"),
   BC-3.4.018, and CLAUDE.md — **the converged holdout's FAQ citation is sound and must NOT be changed.**
   The first-pass "reframe to schema" recommendation is hereby superseded by the verbatim FAQ confirmation.

3. **`progressPercent` in the bulk-poll fixture is not Atlassian-documented (harmless).** Research [A1]
   confirmed `status:"COMPLETE"` is a documented field on `GET /rest/api/3/bulk/queue/{taskId}` but found
   no explicitly-advertised top-level `progressPercent` field. H-NEW-EDIT-TYPE-002's poll fixture includes
   `"progressPercent": 100` as an extra field — this is **harmless** (serde ignores unknown fields; the
   load-bearing field the binary keys off is `status`). Not a blocker; optional tidy-up only.

4. **`ServiceDesk.projectKey` exists in the API but is intentionally omitted from the `jr` struct.**
   Research [A2] confirms the live `ServiceDesk` resource carries `projectKey` in addition to `projectId`.
   H-NEW-QUEUE-VIEW-001's note that the `jr` `ServiceDesk` struct has no `projectKey` field and matches on
   `projectId` is an accurate statement about the *repo struct* (extra API fields are ignored on
   deserialize). Internally consistent; no conflict.

## Closing recommendation

**ALL 8 GROUP-13 SCENARIOS ARE EXTERNALLY SOUND AND SAFE TO COMMIT.** No scenario asserts an external
fact that is REFUTED. Every fixture-level wire shape, endpoint path, response-envelope key, and HTTP
method was either CORROBORATED against developer.atlassian.com / a verbatim FAQ fetch, or confirmed
against the repo's empirically-grounded (live-E2E) research where the public docs are misleading.

The three first-pass "precondition-wording reframes" (CHANGELOG null-framing, QUEUE reorder-as-client-
contract, LINK Relates-as-`jr`-default) are all present and correctly worded in the converged text. The
one external-fact risk that surfaced this pass — the `createmeta` `values`-vs-`issueTypes` trap — resolves
**in favor of the holdout** (it correctly uses `issueTypes`, backed by the repo's live-Jira failure). The
FAQ citation-of-record for the bulk `--type` asymmetry is verbatim-confirmed and must be kept as-is.

**Gate verdict: PASS — commit the 8 scenarios.** No must-fix. Two optional, non-blocking tidy-ups
(drop the undocumented `progressPercent` from the poll fixture; no action needed on citations).

## Research Methods (pre-commit pass)

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 2 | [A1] createmeta/issuetypes + issueLinkType + bulk-queue-poll + search/jql POST envelope keys (high effort); [A2] JSM PagedDTO envelope + queue-issue ordering + ServiceDesk fields (high effort) |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily tavily_* | 0 | — |
| WebFetch | 2 | [A3] verbatim Bulk Operations FAQ JSON (asymmetry confirmation — SUCCESS); api-group-issues page (truncated, no useful return) |
| Read (repo) | 3 | converged Group-13 scenario text; `issue-331-createmeta-response-schema.md`; `issue-331-issuetype-bulk-schema.md` |
| Grep (repo) | 2 | `CreatemetaIssueTypesResponse` serde struct + regression pin in `src/api/jira/issues.rs` |
| Training data | 0 areas | Not relied upon — every external verdict tied to a retrieved Atlassian page, the verbatim FAQ, or the repo's live-E2E-grounded research |

**Total MCP tool calls (this pass):** 2 `perplexity_research` + 2 `WebFetch` = 4 external (plus 5 repo Read/Grep).
**Training data reliance:** low — the one external-fact conflict (createmeta envelope key) was resolved against
the repo's live-Jira empirical evidence, not training data; the highest-value asymmetry was confirmed by a
verbatim fetch of the official FAQ page.

### Sources (this pass)
- [A1] `perplexity_research` over developer.atlassian.com — createmeta/issuetypes, issueLinkType (`issueLinkTypes`), bulk-queue-poll (`status:"COMPLETE"`), `POST /rest/api/3/search/jql` (`issues`+`nextPageToken`). NOTE: the call's `values`-for-createmeta claim is REFUTED (see Discrepancy 1).
- [A2] `perplexity_research` over developer.atlassian.com/cloud/jira/service-desk/rest — JSM PagedDTO (`size`/`start`/`limit`/`isLastPage`/`values`), queue-issue ordering (no sort param), `ServiceDesk` fields incl. `projectId`.
- [A3] WebFetch (verbatim) https://developer.atlassian.com/cloud/jira/platform/bulk-operation-additional-examples-and-faqs/ — confirmed `selectedActions:["…","issuetype",…]` lowercase + `editedFieldsInput.issueType.issueTypeId:"10013"` camelCase/string, with `priority` + `labelsFields` in the same example.
- Repo ground-truth: `.factory/research/issue-331-createmeta-response-schema.md` (live-E2E "missing field `values`" → key is `issueTypes`); `.factory/research/issue-331-issuetype-bulk-schema.md` (verbatim FAQ source-of-truth); `src/api/jira/issues.rs::CreatemetaIssueTypesResponse` (`#[serde(rename = "issueTypes")]` + regression pin).
