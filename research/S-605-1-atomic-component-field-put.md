# S-605-1 — Atomic combined `update`+`fields` PUT for `jr issue edit` (components + other fields)

**Type:** general (technology / API-contract research)
**Date:** 2026-08-18
**Question owner:** `jr issue edit KEY --component add:X --priority High` code-design decision (one atomic PUT vs. two sequential PUTs)
**API version in scope:** Jira Cloud Platform REST API **v3** (`PUT /rest/api/3/issue/{issueIdOrKey}`). The edit semantics are shared with v2; the v3 reference and the (v2-labelled) "Updating an Issue" tutorial describe the **same** `update`/`fields` model — cited accordingly.

---

## TL;DR / Decision input

| Q | Answer | Confidence |
|---|--------|-----------|
| 1. Both `update` + `fields` in one PUT for distinct fields? | **Yes — officially supported and documented.** | High (primary source) |
| 2. Applied atomically (all-or-nothing)? | **Validation is all-fields-up-front → an invalid `priority` returns an error document and, per the documented validate-then-apply model, the whole edit does not apply.** BUT Atlassian **does not** publish an explicit "atomic/transactional/rollback" guarantee for Jira Cloud. | Medium — behavior strongly documented for *validation* failures; no contractual atomicity language exists |
| 3. Same-field-in-both rejected? Cross-field mixing OK? | **Same field in both `update` and `fields` is rejected.** Different fields using different mechanisms in one body is fine and is shown in official examples. | High (primary source) |
| 4. One PUT vs. two — official practice? | **Official examples combine multiple fields (incl. components + other fields) in ONE PUT.** No Atlassian doc specifies the browser UI's exact network call. | High for "one PUT is the intended model"; Inconclusive for "the UI does exactly this" |
| 5. Component `add` by numeric id? | **Yes** — components are identified by **Component Id or Name**; `{"update":{"components":[{"add":{"id":"10001"}}]}}` is the correct id form. | High (primary source) |

**Recommendation for the code decision:** Merging to a single PUT combining `{"update":{"components":[…]}}` and `{"fields":{"priority":…}}` is **supported** and **eliminates the documented partial-write window for the common failure mode you care about** (an invalid `priority` value → validation error → nothing applied, including no component change). This is a strict improvement over two sequential PUTs. However, because Atlassian publishes no explicit transactional/rollback guarantee, do **not** document it as "guaranteed atomic across all failure modes" — document it as "single request; validation failures reject the whole edit; no cross-mechanism partial-write window for field-validation errors." See "Caveats" below.

---

## Q1 — Combining `update` and `fields` in one PUT

**Supported and explicitly documented.** Your target shape is valid because `components` appears only in `update` and `priority` only in `fields`:

```json
{
  "update": { "components": [ { "add": { "name": "X" } } ] },
  "fields": { "priority": { "name": "High" } }
}
```

Primary-source wording (Atlassian, "Updating an Issue via the JIRA REST APIs", verbatim, confirmed via direct fetch):

> "You can have both \"fields\" and \"update\" in the one PUT, but a given field must appear only in one or the other." [1]

The v3 Edit-issue reference states the edit model is defined by both properties:

> "The edits to the issue's fields are defined using `update` and `fields`." [2]

**Documentation defect to avoid (not a blocker):** the auto-generated v3 Edit-issue *example* on the reference page has historically shown `summary` in **both** `fields` and `update`, which the OpenAPI schema itself forbids. Do not copy that overlap; the schema's same-field exclusion (Q3) is controlling. [2][3]

## Q2 — Atomicity / all-or-nothing

**What IS documented (primary source):**

> "If any of the implicit or explicit updates cause a validation error, an error document is returned, detailing the validation errors associated with each field." [1]

This is an **all-fields-validated-together** model: an invalid `priority` in `fields` produces a validation error document for the whole request. The server-side Jira `IssueService` architecture (Data Center docs, same edit engine lineage) is explicitly validate-then-do: the update "do" method cannot be invoked unless `updateValidationResult.isValid()` — i.e., validation precedes any mutation. [4]

**What is NOT documented (verified absence):** Direct fetch of the primary tutorial confirmed: *"The documentation contains no statements regarding atomicity, transactions, all-or-nothing behavior, or rollback procedures."* [1] Searches of the v3 REST reference, the OpenAPI/Swagger spec, and Cloud Automation docs did **not** surface the words "atomic," "transactional," "rollback," or "all-or-nothing" applied to this endpoint.

**Interpretation for the decision (stated conservatively, not inferred beyond evidence):**
- For the **specific failure mode you named** (invalid `priority` value): the documented validate-all-then-apply behavior means the request is rejected with a validation error and the component change is **not** applied. This is the mode a two-PUT design currently mishandles, and a single PUT closes it.
- For **arbitrary** failure modes (a custom-field post-function failing mid-apply, infrastructure failure, an app/automation reacting to a partial state, etc.): Atlassian gives **no** contractual atomicity guarantee. Do not claim rollback coverage for these.

**Flagged as INCONCLUSIVE:** an *explicit* Jira Cloud REST transactional/atomicity guarantee. It is not published. If strict all-failure-mode atomicity is business-critical, it must be verified empirically against the target tenant — the public contract does not assert it.

## Q3 — Same-field-in-both, cross-field mixing, and component field-type rules

**Same field in both sections → rejected.** The OpenAPI `IssueUpdateDetails` schema states, reciprocally, that fields in `fields` cannot appear in `update` and vice versa. [3] A real, observed Jira error for exactly this is:

> "Field 'components' cannot appear in both 'fields' and 'update'." [5]

**Different fields using different mechanisms in one body → fully supported.** This is the whole point of your design and is shown in official examples (components under `update` alongside `assignee`/`summary`). [6]

**Component field mechanics (primary source, verbatim table rows):**
- **Components** — verbs "Set, Add" (Remove is also supported per the tutorial's Fix/Affected-Versions pattern and the components add/remove example); value = **Component Id or Name**. [1][6]
- **Priority** — verb "Set"; value = **Priority Id or Name**. (Single-value field ⇒ SET only ⇒ correctly placed in `fields`.) [1]

General rule (primary source): *"single value fields support SET, whereas multi-value fields support SET, ADD and REMOVE, where SET replaces the field contents while ADD and REMOVE add or remove one or more values from the current list of values."* [6]

Because supported operations can depend on field config, the v3 reference directs callers to `GET /rest/api/3/issue/{issueIdOrKey}/editmeta`, whose per-field `operations` array is authoritative for what `add`/`remove` are actually available on a given issue. [2] (`editmeta` is read-only; it "does not work with PUT operations." [6])

## Q4 — One PUT vs. two; what official clients do

**Official examples combine multiple fields — including components with other fields — in one PUT.** The canonical Atlassian edit-issues example does exactly this:

```json
{
  "update": {
    "components": [ {"remove": {"name": "Trans/A"}}, {"add": {"name": "Trans/M"}} ],
    "assignee":  [ {"set": {"name": "harry"}} ],
    "summary":   [ {"set": "Big block Chevy"}} ]
  }
}
```
[6]

Atlassian's Cloud Automation "advanced field editing using JSON" doc likewise presents a single object mixing `update` (description, labels) and `fields` (summary) for one Edit-issue action, and states *"`fields` is a shortcut for calling `update` with the `set` operation."* [7]

**Inconclusive:** No Atlassian documentation describes the Jira Cloud **browser UI's** exact network payload, so I cannot assert "the UI does it in one PUT with this body." What is well-supported is that the *intended edit model* is one logical edit = one request with multiple field changes; per-field separate requests are not the documented norm and are only warranted when you need independent retry/error isolation.

## Q5 — Component `add` by numeric id

**Yes.** Components are identified by **Component Id or Name** [1], and the OpenAPI component bean exposes both string `id` and `name`. [3] The correct id form is a scalar object under `add`:

```json
{ "update": { "components": [ { "add": { "id": "10001" } } ] } }
```

**Gotcha (relevant to your wiring):** do **not** wrap the value in an extra array. The malformed shape
`{"update":{"components":[{"add":[{"id":"10001"}]}]}}`
triggers Atlassian's documented *"Could not find valid 'id' or 'name' in object"* error — `add`/`remove` take a **single** value, only `set` takes an array. [8] Your description says you wire numeric input as `{"id":...}` (scalar), which is correct.

A 2021 community post reported `add`/`remove` failing for both id and name while only `set` worked [9]; that report's error signature matches the extra-array mistake above and is contradicted by Atlassian's current documented `add` examples, so it should not override the current docs — but it is a reminder to keep an integration test asserting the exact `{"add":{"id":…}}` / `{"add":{"name":…}}` scalar shapes against live/wiremock Jira.

---

## Caveats & flags for the implementer

1. **Atomicity language:** ship the single-PUT merge, but in code comments / CLAUDE.md phrase it as *"single request; a field-validation error (e.g. invalid priority) rejects the whole edit so the component change is not applied — closing the two-PUT partial-write window"* — NOT as a blanket "atomic/transactional" guarantee. The guarantee Atlassian actually documents is scoped to validation errors returning an error document [1]; broader transactional rollback is undocumented (Q2, INCONCLUSIVE).
2. **Same-field guard:** if a future flag lets a user set components via a `fields`-style set AND an `update` add in the same invocation, you must ensure `components` is emitted in only one of the two top-level objects, or Jira returns "Field 'components' cannot appear in both 'fields' and 'update'." [5]
3. **`editmeta` before relying on `add`/`remove`:** operation availability is per-field/per-issue-config; `GET …/editmeta` is the authoritative source. [2]
4. **Scalar-not-array for add/remove:** keep the `{"add":{"id":…}}` scalar shape; the extra-array form fails. [8]
5. **Error-document parsing:** a combined-PUT failure returns a per-field validation error document [1]; the CLI's existing per-field error enrichment should map an invalid-priority rejection to a clear message and (importantly, now) reflect that **no** change — component or otherwise — was applied.

---

## Sources

- [1] Atlassian Developer — "Updating an Issue via the JIRA REST APIs" (edit model; both `update`+`fields` in one PUT; validation-error wording; field/verb table). https://developer.atlassian.com/server/jira/platform/updating-an-issue-via-the-jira-rest-apis-6848604/ — **verbatim quotes confirmed via direct fetch 2026-08-18.**
- [2] Atlassian Developer — Jira Cloud Platform REST API **v3**, Issues group / Edit issue (`PUT /rest/api/3/issue/{issueIdOrKey}`; "defined using `update` and `fields`"; editmeta pointer). https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/
- [3] Atlassian Jira Cloud OpenAPI (Swagger v3) — `IssueUpdateDetails` schema (fields-in-`fields` cannot appear in `update` and vice versa; component bean `id`+`name`). https://dac-static.atlassian.com/cloud/jira/platform/swagger-v3.v3.json
- [4] Atlassian Developer (Data Center) — "Performing issue operations" / `IssueService` validate-then-do model. https://developer.atlassian.com/server/jira/platform/performing-issue-operations/
- [5] Atlassian Community — observed "Field 'components' cannot appear in both 'fields' and 'update'" error. https://community.atlassian.com/forums/Jira-questions/Error-for-automation-scenario/qaq-p/1535419
- [6] Atlassian Developer — "JIRA REST API Example - Edit issues" (components add/remove; multi-field one-PUT example; SET/ADD/REMOVE rule; editmeta read-only). https://developer.atlassian.com/server/jira/platform/jira-rest-api-example-edit-issues-6291632/
- [7] Atlassian Support — Cloud Automation, "Advanced field editing using JSON" (`fields` = shortcut for `update`+`set`; combined object example). https://support.atlassian.com/cloud-automation/docs/advanced-field-editing-using-json/
- [8] Atlassian Support KB — "Could not find valid 'id' or 'name' in object when using the add operation for REST API" (add/remove take single value, not array). https://support.atlassian.com/jira/kb/could-not-find-valid-id-or-name-in-object-when-using-the-add-operation-for-rest-api/
- [9] Atlassian Developer Community — "Removing component from issue via REST API" (2021 report of add/remove failing; superseded/contradicted by current docs). https://community.developer.atlassian.com/t/removing-component-from-issue-via-rest-api/49653

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source synthesis of all five questions against official Atlassian docs + OpenAPI + community, with explicit found/not-found distinctions |
| Perplexity perplexity_search | 2 | Raw ranked URLs for the Atlassian edit-issue tutorial pages + "update vs fields" community threads (surfaced verbatim doc snippets) |
| WebFetch | 1 | Direct verification of the two load-bearing primary-source claims (both-in-one-PUT wording; validation-error/atomicity absence) on the canonical Atlassian tutorial page |
| Training data | 0 areas | Not relied upon for any claim — every claim is web-sourced |

**Total MCP tool calls:** 3 (1 research + 2 search) + 1 WebFetch
**Training data reliance:** low — all findings are grounded in fetched/cited Atlassian primary sources; the one explicit-absence claim (no documented atomicity guarantee) was double-confirmed by direct page fetch.
