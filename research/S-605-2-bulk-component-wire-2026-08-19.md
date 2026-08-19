# Research: S-605-2 bulk component-edit wire shape — pre-implementation validation

**Date:** 2026-08-19
**Type:** general (technology/API implementation)
**Scope:** Jira Cloud REST API v3 Bulk Operations — validates the 8 wire-shape claims that gate S-605-2 (DEC-280, BC-3.4.023) BEFORE implementation
**Method:** READ-ONLY doc/community/source research. No live Jira API calls, no state changes.
**Author:** research-agent

> Source-quality convention: **[PRIMARY]** = developer.atlassian.com / docs.atlassian.com / support.atlassian.com (Atlassian-authored). **[SECONDARY]** = Atlassian Community threads, third-party schema mirrors (apidog, withone.ai). **[REPO]** = this repo's own already-live-validated code (issue #446 bulk labels/type path). Verdicts: CONFIRM / REFUTE / INCONCLUSIVE.

This extends (does not repeat) `.factory/research/component-delete-and-bulk-wire-2026-08-15.md` §Q2. That file established the shape from docs; this pass **re-validates each claim against current (2026-08) primary sources**, cross-checks against the repo's own live-proven bulk machinery, and hunts specifically for a `FIX-BULK-TRANSITION-001`-class doc-vs-wire divergence.

---

## Summary verdict table

| # | Claim | Verdict | Source strength |
|---|-------|---------|-----------------|
| 1 | Endpoint is `POST /rest/api/3/bulk/issues/fields` | **CONFIRM** | PRIMARY + REPO (already live-proven) |
| 2 | `selectedActions: ["components"]` (lowercase field id) | **CONFIRM** | PRIMARY (metadata) — component-specific live run not observed |
| 3 | `editedFieldsInput.multiselectComponents` is a SINGLE OBJECT (not array, not `componentsFields`) `{"fieldId":"components","components":[{"componentId":10001}],"bulkEditMultiSelectFieldOption":"ADD"}` | **CONFIRM** | PRIMARY verbatim example + 2 SECONDARY schema mirrors |
| 4 | `componentId` is a JSON INTEGER (int64), never string, never `{"name":...}` | **CONFIRM** (OpenAPI contract) | PRIMARY example (`2154`, unquoted) + SECONDARY schema ("componentId (required, integer)") — no live triple-comparison |
| 5 | `bulkEditMultiSelectFieldOption` enum = `ADD \| REMOVE \| REPLACE \| REMOVE_ALL` | **CONFIRM** | PRIMARY verbatim (GET response for Components) |
| 6 | Mixed add+remove needs TWO sequential POSTs (one option per POST); cannot coalesce | **CONFIRM** | PRIMARY (structural: singleton object) + SECONDARY live evidence for analogous labels field |
| 7 | Single-request cap = 1000 issues | **CONFIRM** | PRIMARY (endpoint doc + FAQ) — also 200 fields/request |
| 8 | Async: returns a taskId, poll a task endpoint | **CONFIRM** | PRIMARY (`201` + `taskId`, poll `GET /rest/api/3/bulk/queue/{taskId}`) + REPO (already implemented) |

**Zero REFUTE findings.** Every claim in BC-3.4.023 / the story's "Behavior Summary" is corroborated by current primary Atlassian documentation. The single residual is that **no source shows a live successful run against the *system Components field specifically*** — exactly the gap AC-010's live smoke test exists to close. Details below.

---

## Per-claim detail

### Claim 1 — Endpoint `POST /rest/api/3/bulk/issues/fields` — CONFIRM

The endpoint index on the current v3 Bulk Operations page lists `POST /rest/api/3/bulk/issues/fields` alongside `GET /rest/api/3/bulk/issues/fields` (field discovery) and `GET /rest/api/3/bulk/queue/{taskId}` (task polling). [PRIMARY, updated 2026-08-14]

**Repo corroboration [REPO]:** `src/api/jira/bulk.rs::bulk_edit_fields` (line 271) already POSTs to this exact path and is live-validated via the issue #446 bulk-labels/type path. No new endpoint work required.

Source: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ (accessed 2026-08-19)

### Claim 2 — `selectedActions: ["components"]` (lowercase) — CONFIRM (metadata)

The `GET /rest/api/3/bulk/issues/fields` response lists the system Components field with `"id": "components"` and `"type": "components"`. `selectedActions` is documented as "List of field IDs to bulk edit," so the entry is the lowercase field id `"components"` — not `"Components"` and not `"multiselectComponents"`. [PRIMARY]

Caveat: I found no recent community post showing `selectedActions: ["components"]` in a *successful component* run specifically. The analogous live labels/versions/type runs use the field-id convention (`["labels"]`, `["fixVersions"]`, `["issuetype","priority"]`), so the pattern is well-established — but the components-specific live confirmation is deferred to AC-010.

Source: https://developer.atlassian.com/cloud/jira/platform/bulk-operation-additional-examples-and-faqs/ (labels/issuetype/priority worked example, accessed 2026-08-19); GET fields example on the endpoint page above.

### Claim 3 — `multiselectComponents` single object, not array, not `componentsFields` — CONFIRM

Verbatim from the Atlassian POST request example (`editedFieldsInput`):
```json
"multiselectComponents": {
  "bulkEditMultiSelectFieldOption": "ADD",
  "components": [{"componentId": 2154}],
  "fieldId": "<string>"
}
```
This is a **singleton object** (contrast the sibling array-typed properties `labelsFields[]`, `multipleVersionPickerFields[]`, `multipleGroupPickerFields[]`). No `componentsFields` key exists anywhere in the request model. Corroborated by three independent renderings:
- [PRIMARY] Atlassian endpoint doc example (above).
- [SECONDARY] apidog schema mirror (`"multiselectComponents": {"bulkEditMultiSelectFieldOption":"ADD","components":["componentId": 0],"fieldId":"string"}`), dated 2025-07-16.
- [SECONDARY] withone.ai schema-derived reference (2026-02-25): "`multiselectComponents` | object | `fieldId` (required, string), `bulkEditMultiSelectFieldOption` (required...), `components` (required array of `{ componentId (required, integer) }`)."

The camelCase/lowercase asymmetry (`selectedActions:"components"` lowercase vs `editedFieldsInput.multiselectComponents` camelCase-different-word, with nested `fieldId:"components"`) is confirmed and is the same asymmetry class as `labels`/`labelsFields` and `issuetype`/`issueType` already documented in CLAUDE.md.

Sources: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ ; https://krevt8mwkh.apidog.io/bulk-edit-issues-19180025e0 ; https://www.withone.ai/knowledge/jira/conn_mod_def::GJ4qWNqZBJo::svqahY4TRvGC7dnYFi06tg (all accessed 2026-08-19)

### Claim 4 — `componentId` is a JSON integer — CONFIRM (OpenAPI contract)

The Atlassian example sends `"componentId": 2154` **unquoted** (JSON integer). The withone.ai schema-derived reference states `componentId (required, integer)`; the swagger-v3 artifact types it as integer/int64. So send `{"componentId": 10001}`, never `{"componentId": "10001"}` and never `{"name": "Backend"}`.

This confirms the story's mandated `String`→`u64` parse step (AC-003) and the per-path asymmetry vs. the single-issue `update`-verb path (which uses `{"name":...}`/`{"id":...}` objects, S-605-1).

Marked **not independently live-verified**: no source runs the integer-vs-string-vs-name comparison against the live system Components field. Given `FIX-BULK-TRANSITION-001`, treat as normative-schema confirmation pending AC-010.

Sources: Atlassian endpoint doc (example `2154`); https://www.withone.ai/knowledge/jira/conn_mod_def::GJ4qWNqZBJo::svqahY4TRvGC7dnYFi06tg ; https://dac-static.atlassian.com/cloud/jira/platform/swagger-v3.v3.json (snapshot 2026-08-11) (accessed 2026-08-19)

### Claim 5 — enum `ADD | REMOVE | REPLACE | REMOVE_ALL` — CONFIRM

The `GET /rest/api/3/bulk/issues/fields` response lists, verbatim for the Components field:
```json
"multiSelectFieldOptions": ["ADD", "REMOVE", "REPLACE", "REMOVE_ALL"]
```
Exactly those four, in that order. `jr` emits only `ADD`/`REMOVE` (BC-3.4.023 scope; `set:`/`clear:` = #607, out of scope). [PRIMARY]

Source: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ (accessed 2026-08-19)

### Claim 6 — mixed add+remove = TWO sequential POSTs (the critical divergence) — CONFIRM

**Structural proof [PRIMARY]:** `multiselectComponents` is a *single object* carrying exactly one `bulkEditMultiSelectFieldOption`. There is no array slot in which to place a second (REMOVE) operation for the same field in one POST. This is stronger than the labels case: `labelsFields` is an *array*, so one could naively attempt two entries — yet even there it does not coalesce (below). For components, coalescing is not merely unsupported, it is **structurally unrepresentable**.

**Analogous live evidence [SECONDARY]:** A community user attempting a REMOVE + ADD on the *labels* field in one call reported "It does not work in 1 call"; separate REMOVE and ADD calls worked. (Thread posted 2024-12-17, updated 2026-07-10.) This is user live-run evidence for the sibling multi-select field, not an Atlassian staff guarantee and not components-specific.

This **confirms the pass-14 correction** in BC-3.4.023 Postcondition 3: ADD POST (fully polled) then REMOVE POST (fully polled). Do NOT copy `handle_edit_bulk_labels`'s single-POST coalescing — the story is correct to call this out as the key divergence.

Source: https://community.developer.atlassian.com/t/bulk-edit-issue-not-working-properly/87213/2 (accessed 2026-08-19)

### Claim 7 — 1000-issue cap — CONFIRM

"A single request can accommodate a maximum of 1000 issues (including subtasks) and 200 fields." Stated on both the endpoint page and the Bulk Operation FAQ (updated 2026-08-18), and independently echoed by the withone.ai reference. The "**including subtasks**" clause is worth noting for AC-007/AC-008 chunking: if a resolved key set expands with subtasks server-side, the effective count matters — but `jr` chunks on the *explicit* key set it POSTs, so a 1000-key chunk is the correct client-side boundary. [PRIMARY]

Sources: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ ; https://developer.atlassian.com/cloud/jira/platform/bulk-operation-additional-examples-and-faqs/ (accessed 2026-08-19)

### Claim 8 — async, poll a task — CONFIRM

Successful submit returns HTTP **201** with a `SubmittedBulkOperation` body, e.g. `{"taskId":"10641"}`. Poll `GET /rest/api/3/bulk/queue/{taskId}`; documented statuses: `ENQUEUED`, `RUNNING`, `COMPLETE`, `FAILED`, `CANCEL_REQUESTED`, `CANCELLED`, `DEAD`. Task progress retained ~14 days. [PRIMARY]

**Repo corroboration [REPO]:** `src/api/jira/bulk.rs` already implements exactly this: `bulk_edit_fields` returns the taskId (line 273); `await_bulk_task` polls `GET /rest/api/3/bulk/queue/{task_id}` (lines 308–332) with the existing `JR_BULK_AWAIT_TIMEOUT_SECS` timeout and unknown-status grace. The story's assumption "reuse existing `await_bulk_task`" is sound and the poll endpoint matches the docs byte-for-byte. No new polling mechanism needed.

Source: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ (accessed 2026-08-19)

---

## What the story may have MISSED (surfaced items)

1. **`sendBulkNotification` — the existing reused code OMITS it, and that path is already live-proven.** The BC-3.4.023 example body shows `"sendBulkNotification": false`, but the method the components branch reuses — `bulk_edit_fields` — builds `BulkEditRequest` with only three fields (`selectedIssueIdsOrKeys`, `selectedActions`, `editedFieldsInput`) and **does not send `sendBulkNotification` at all**. That omission is already live-validated by the issue #446 bulk labels/type path. `sendBulkNotification` is documented **optional** ([PRIMARY] — not in the required set; required = `editedFieldsInput`, `selectedActions`, `selectedIssueIdsOrKeys`). **Recommendation:** reuse `bulk_edit_fields` as-is; do NOT add `sendBulkNotification` to the components body just to match the BC example — doing so would diverge from the live-proven path. (Note: `bulk_transition` *does* send `false` explicitly, but that is a different struct/endpoint.) Optionally, align the BC example prose to note that omission is the implemented, live-proven behavior.
   - **Default conflict, flagged:** withone.ai (SECONDARY, 2026-02-25) says `sendBulkNotification` default is `true`; Perplexity's reading of Atlassian's own schema says **no default is declared**. Since the reused code omits the field entirely and #446 passed, the effective server behavior on omission is already proven acceptable for `jr`'s purposes — but if notification-suppression is ever a product requirement, send `false` explicitly rather than relying on the (conflicting) documented default.

2. **Permissions/scope.** Bulk edit requires **Browse Projects** AND **Edit Issues** permission in *every* project containing the selected issues [SECONDARY withone.ai, corroborating Atlassian]. OAuth: classic `write:jira-work` (or the granular edit scopes). The cross-project guard (AC-005) is orthogonal to permissions — it fires client-side before the POST regardless. Worth a test note that a 403 from insufficient permission surfaces via the existing `await_bulk_task`/submit error path, not a new branch.

3. **Rate-limit / async posture.** No per-minute numeric rate limit is documented for this endpoint beyond the size caps (1000 issues / 200 fields). It is inherently throttled by being async + size-capped. `jr`'s chunk-sequential design (each chunk fully polled before the next POST, AC-007/008) is congruent with this and avoids hammering. Task state is retained ~14 days, so a poll timeout is recoverable via `jr api /rest/api/3/bulk/queue/{taskId}` (the existing error hint at bulk.rs line 511 already points there).

4. **Dynamic field eligibility (`unavailableMessage`).** `components` appears in the GET-fields allowlist **only when the selected issues' project actually has components** (`unavailableMessage`: "The project of the selected issue(s) does not have any components."). `jr` does not GET-check eligibility before POSTing; a components edit against a project with zero components may return a task-level failure. This is acceptable (surfaces via `await_bulk_task`), but the live smoke test (AC-010) should run against a project that *has* components to avoid a false-negative.

5. **No bulk-component-specific JRACLOUD bug found.** The one community thread that puts objects into `multiselectComponents` and fails (`community.developer.atlassian.com/t/bulk-issue-update/95268`, 2025-09-11) is a **CMDB/Assets custom field misuse** (sends `objectId`/`workspaceId`/`id` entries under a `custom_field_123` selector), **not** a refutation of the system Components shape. `JRACLOUD-98992` (ordinary Components add/remove writes issue history, with a `component -> None` display quirk) concerns the single-issue field path, not the bulk cascade. Nothing found that would change the S-605-2 wire shape.

---

## Gaps for the live smoke test (AC-010)

These are the *only* residual uncertainties; all are the "documented + triple-corroborated but not observed on the live wire for the system Components field" class — the exact `FIX-BULK-TRANSITION-001` risk the gate exists for:

- **G1 (highest value):** No source shows a *successful live* `POST /bulk/issues/fields` for the **system Components field** with the integer-`componentId` `multiselectComponents` payload. All live evidence is for sibling fields (labels, fixVersions, issuetype) or is CMDB-custom-field misuse. → Smoke test MUST assert an ADD lands and a REMOVE lands, against ≥2 real issues in one project **that has components**.
- **G2:** Integer-vs-string `componentId` was not live-differentiated. The smoke test should send the integer form (per Claim 4) and confirm success; if it fails, retry a numeric-string to characterize the true contract before correcting the BC.
- **G3:** The two-sequential-POST requirement for mixed add/remove (Claim 6) is structurally certain for components but live-confirmed only for labels. Smoke test should run one ADD POST then one REMOVE POST and confirm both terminal-COMPLETE (already AC-002 + AC-010 shape).
- **G4:** `REMOVE_ALL`/`REPLACE` are out of `jr` scope (#607) — no need to smoke-test them for S-605-2.

If the live run contradicts any documented shape, **correct BC-3.4.023 to the observed truth first** (do not patch around it), per the DEC-280 / #446 precedent.

---

## Sources

All accessed 2026-08-19.

**Primary (Atlassian):**
- Bulk Operations v3 endpoint (POST/GET fields, queue/{taskId}, 1000/200 caps, enum, multiselectComponents example, taskId/201, statuses): https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ (page updated 2026-08-14)
- Bulk Operation APIs — Additional Examples and FAQs (labels/issuetype/priority worked example; 1000-issue limit; running-task example): https://developer.atlassian.com/cloud/jira/platform/bulk-operation-additional-examples-and-faqs/ (updated 2026-08-18)
- Swagger v3 OpenAPI artifact (componentId int64): https://dac-static.atlassian.com/cloud/jira/platform/swagger-v3.v3.json (snapshot 2026-08-11)

**Secondary:**
- withone.ai schema-derived reference (permissions: Browse Projects + Edit Issues; required body fields; `componentId (required, integer)`; `sendBulkNotification` default `true` [conflicts with Atlassian schema]): https://www.withone.ai/knowledge/jira/conn_mod_def::GJ4qWNqZBJo::svqahY4TRvGC7dnYFi06tg (2026-02-25)
- apidog schema mirror (multiselectComponents shape, componentId): https://krevt8mwkh.apidog.io/bulk-edit-issues-19180025e0 (2025-07-16)
- Community — labels REMOVE+ADD "does not work in 1 call" (Claim 6 analog): https://community.developer.atlassian.com/t/bulk-edit-issue-not-working-properly/87213/2 (2024-12-17, upd. 2026-07-10)
- Community — fixVersions bulk edit live success (field-id convention): https://community.developer.atlassian.com/t/bulk-edit-issues-fix-version-via-rest/89939 (2025-03-05)
- Community — `multiselectComponents` misuse for CMDB/Assets field (NOT a refutation): https://community.developer.atlassian.com/t/bulk-issue-update/95268 (2025-09-11)

**Repo (already-live-validated code):**
- `src/api/jira/bulk.rs::bulk_edit_fields` (POST /bulk/issues/fields, generic `selected_actions` + `edited_fields`), `::await_bulk_task` (poll /bulk/queue/{taskId}), `BulkEditRequest` (omits sendBulkNotification) — live-proven via issue #446.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source validation of all 8 claims + sendBulkNotification against current Atlassian primary docs + community, with explicit live-wire-vs-doc flagging |
| Perplexity perplexity_search | 1 | Raw-source cross-validation: verbatim Atlassian POST example (`multiselectComponents`/`componentId 2154`), GET-fields enum, withone.ai schema, apidog mirror, community threads |
| Read | 3 | Existing story spec, prior DEC-280 research (§Q2), RESEARCH-INDEX |
| Grep/Read (repo) | 3 | Confirm `bulk.rs` already POSTs `/bulk/issues/fields`, polls `/bulk/queue/{taskId}`, and that `bulk_edit_fields` is generic + omits `sendBulkNotification` (reuse feasibility) |
| Training data | 0 areas | Not relied upon for any factual claim; all verdicts tied to cited sources or repo code |

**Total MCP tool calls:** 2 (1 research + 1 search)
**Training data reliance:** low — every verdict is tied to a current Atlassian primary source, a labeled secondary source, or the repo's own live-validated code.
