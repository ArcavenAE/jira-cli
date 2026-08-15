# Research: Component DELETE safety + multi-key bulk component-edit wire shape

**Date:** 2026-08-15
**Type:** general (technology/API implementation)
**Scope:** Jira Cloud REST API v3 — feeds `jr component delete` design (Q1) and #605 Wave 2 bulk component edit (Q2)
**Method:** READ-ONLY doc/community research. No live API calls, no state changes.
**Author:** research-agent

> Source-quality convention used below: **[PRIMARY]** = developer.atlassian.com / docs.atlassian.com / support.atlassian.com (Atlassian-authored). **[SECONDARY]** = Atlassian Community, community.developer.atlassian.com, apidog/third-party mirrors, other CLIs. Verdicts are CONFIRMED / REFUTED / INCONCLUSIVE.

---

## Question 1 — Component DELETE safety semantics

Endpoint (confirmed): `DELETE /rest/api/3/component/{id}?moveIssuesTo={id}`
- Returns **204 No Content** on success.
- Permissions: *Administer projects* (project-scoped) OR *Administer Jira* (global). Granular OAuth scope `delete:project.component:jira`; Connect scope `PROJECT_ADMIN`.
- `moveIssuesTo` is an **optional query string** = the ID of the replacement component.

Source [PRIMARY]: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-components/#api-rest-api-3-component-id-delete

### Q1.1 — Effect on affected issues (with vs without `moveIssuesTo`) — **CONFIRMED**

| Form | Effect on affected issues |
|------|---------------------------|
| `DELETE …?moveIssuesTo={replacementId}` | Component `{id}` is deleted; the replacement component is applied to every issue that referenced the deleted one. Other components already on those issues are untouched. Issues are **not** deleted. |
| `DELETE …` (no `moveIssuesTo`) | Component `{id}` is deleted **and the association is simply removed from the related issues.** No replacement is made. Other components on those issues remain. Issues are **not** deleted. |

The "without" case is **CONFIRMED** to remove the component from those issues (not delete the issues). The clearest wording is on the Data Center / legacy REST reference, whose contract matches Cloud:

> `moveIssuesTo` — "The new component applied to issues whose 'id' component will be deleted. **If this value is null, then the 'id' component is simply removed from the related issues.**"

- [PRIMARY] https://docs.atlassian.com/software/jira/docs/api/REST/9.14.0/ (DELETE /rest/api/2/component/{id})
- [PRIMARY] https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-components/
- [SECONDARY] apidog mirror: https://apidog.com/apidoc/project-345971/api-3933314 ("If this value is null no replacement is made.")

> Note: the current v3 rendered page shows a blank description for `moveIssuesTo` (a doc-rendering deficiency); the parameter is still listed as optional and the contract is unchanged from the legacy reference above.

### Q1.2 — Recoverability — **CONFIRMED: immediate and permanent (no component trash/undo)**

There is **no documented component trash, soft-delete, archive, restore endpoint, or undo window** for an individually deleted component. Treat it as immediate and permanent on the live site.

Important distinctions (they do **not** help component recovery):
- **Projects/spaces** have a 60-day trash (restored as a unit). Does not cover a component deleted from an active project. [PRIMARY] https://support.atlassian.com/jira-cloud-administration/docs/trash-for-jira-cloud-projects/
- **Issues** have a recoverable *archive*, but issue *deletion* is itself permanent (no issue recycle bin). [PRIMARY] https://support.atlassian.com/jira-software-cloud/docs/archive-an-issue/
- Recreating a component makes a **new** component with a **new ID**; it does not restore the old ID or its issue associations.
- Only route back is an external backup/export restored elsewhere — a recovery procedure, not an undo. [PRIMARY] https://support.atlassian.com/jira/kb/restore-deleted-work-items-in-jira-cloud-using-local-backup-files/

Source [PRIMARY]: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-components/ (documents only create/get/update/delete — no archive/restore/undelete).

### Q1.3 — Does the delete-cascade write a per-issue changelog entry? — **INCONCLUSIVE (leans YES)**

Prior research left this open; pushing harder still does not yield a contractual guarantee, but the balance of evidence leans **yes, the removal is visible in issue history**:

- [SECONDARY] Atlassian Community: after removing a component it is gone from the issues but "You will still find it in the history of course." https://community.atlassian.com/forums/Jira-questions/If-I-remove-a-component-from-a-project-dies-it-remove-from/qaq-p/269503 — old thread, not Cloud-v3-specific, no REST changelog payload shown.
- [PRIMARY-adjacent] Public Cloud bug `JRACLOUD-98992` shows that **ordinary** Components-field add/remove **does** generate issue-history entries (with a known display quirk: a removal can render as `component -> None` even when another component remains). https://jira.atlassian.com/browse/JRACLOUD-98992 — but this reproduces via an issue-field update, **not** the `DELETE /component/{id}` cascade specifically.
- [PRIMARY] The component-delete endpoint documentation says **nothing** about history/changelog/event attribution/one-record-per-issue.

**Verdict: INCONCLUSIVE.** No Atlassian source contractually guarantees that the *delete cascade* writes one changelog entry per affected issue. Normal Components-field removals are demonstrably changelogged, so it is *likely* the cascade is too, but this is not confirmed for the endpoint.

**Recommendation (unchanged from prior research):** Do not rely on per-issue changelogs as the recovery/audit trail. **Snapshot the component→issue associations before delete** (e.g. `GET /rest/api/3/component/{id}/relatedIssueCounts` for the count, and a JQL `component = <name>` search to capture the affected issue keys) so the operation is reconstructable regardless of changelog behavior. This snapshot doubles as the data needed to show the user what will be affected (see Q1.6).

### Q1.4 — Confirmation parameter / destructiveness — **CONFIRMED: single unguarded destructive call**

- No `confirm`/`yes`/`force`/`dry-run`/idempotency-token parameter is documented. Only `id` (path, required) and `moveIssuesTo` (query, optional).
- `moveIssuesTo` is **not** a safety acknowledgment — it is a data-migration instruction; omitting it explicitly means "remove from issues, no replacement."
- The only guard is authorization (Administer projects / Administer Jira). One authorized DELETE performs the deletion immediately — no prepare/confirm handshake, no grace period, no soft-delete.

Source [PRIMARY]: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-components/#api-rest-api-3-component-id-delete

### Q1.5 — Destructive-delete convention scan (comparable CLIs) — **CONFIRMED (norm = prompt + `--yes`)**

| CLI | Op | Confirmation convention | Safety flag |
|-----|----|------------------------|-------------|
| GitHub `gh` | `gh issue delete` | Prompts by default; `--yes` skips | `--yes`; no move-to |
| GitHub `gh` | `gh repo delete` | Prompts by default; **and** if no repo arg given, `--yes` is ignored and it still prompts (explicit-target safeguard) | `--yes` + explicit target |
| GitHub `gh` | `gh release delete` | Prompts by default; `-y/--yes` skips | `--yes` |
| Atlassian `acli` | `acli jira workitem delete` | Prompts by default; `-y/--yes` = "Confirm delete without prompting" | `--yes`; no move-to |
| Atlassian `acli` | `acli jira project delete` | Doc lists only `--key`/`--help`; runtime confirm behavior **not documented** (doc gap) | none documented |
| `ankitpokhrel/jira-cli` | `jira issue delete` | **No yes/no safety confirm.** Interactive prompt only collects the missing issue key, then deletes immediately. `--cascade` handles subtasks. | none (no `--yes`, no move-to) |

Sources: gh — https://cli.github.com/manual/gh_issue_delete , https://cli.github.com/manual/gh_repo_delete , https://cli.github.com/manual/gh_release_delete ; acli — https://developer.atlassian.com/cloud/acli/reference/commands/jira-workitem-delete/ , https://developer.atlassian.com/cloud/acli/reference/commands/jira-project-delete/ ; ankitpokhrel — https://github.com/ankitpokhrel/jira-cli (source: internal/cmd/issue/delete/delete.go).

**Norm:** prompt interactively by default + explicit `--yes` for unattended deletion (`gh` and `acli`). `gh repo delete` adds an explicit-target safeguard for the highest-blast-radius op. `ankitpokhrel/jira-cli` is the laggard (no confirm) — not a model to copy.

### Q1.6 — RECOMMENDATION for `jr component delete`

**Recommended default: option (b) — layered guardrails.** Component delete is irreversible (Q1.2), single-call destructive (Q1.4), and its audit trail is not guaranteed (Q1.3). It has a larger blast radius than `comment delete` (it silently mutates every issue carrying the component), so it warrants the strongest guardrail tier `jr` uses — comparable to `gh repo delete`.

Concrete design, consistent with existing `jr` conventions:

1. **Require an explicit disposition for affected issues.** Refuse to run unless the caller chooses one of:
   - `--move-to <NAME|ID>` — reassign affected issues to a replacement component (maps to `moveIssuesTo`); the safe, non-destructive-to-issues path, **or**
   - `--orphan` — explicitly opt into "remove the component from all affected issues" (the `moveIssuesTo`-absent path).
   With neither flag → exit 64 with a message naming both flags and (ideally) the count of affected issues from `relatedIssueCounts`. This mirrors the `issue move` done-category pattern (require `--resolution` OR `--no-resolution`; ADR-0015) — never guess a destructive disposition.

2. **Additionally require confirmation for the irreversible `--orphan` path.** Interactive: `dialoguer` confirm showing the affected-issue count. Non-interactive (`--no-input` or non-TTY): require `--yes`, else exit 64 with a hint. This matches the existing `--yes` convention (comment delete, `issue comment delete --yes`) and the `gh`/`acli` norm. `--move-to` may proceed without `--yes` (it is not destructive to issue data — issues keep a component), but gating both behind `--yes` for non-interactive use is a defensible stricter choice; recommend gating **only `--orphan`** to avoid friction on the safe path.

3. **Snapshot before delete (Q1.3 mitigation).** Before the DELETE, capture the affected issue keys (JQL `component = <id/name>`), and surface the count in the confirmation prompt / `--output json`. This gives the user a reconstructable record independent of Jira's changelog behavior and powers the "N issues affected" prompt.

4. **Idempotency:** a 404 on delete (component already gone) should exit 0 in spirit of jr's idempotent state-changing commands — but note the endpoint also returns 404 if the *replacement* component is missing, so distinguish the two before treating 404 as "already deleted."

5. **`--output json`** returns a structured result (e.g. `{"deleted": <id>, "movedIssuesTo": <id|null>, "affectedIssueCount": N}`) via `output::render_json`, per the JSON render invariant.

---

## Question 2 — Multi-key BULK component-edit wire shape

Endpoint: `POST /rest/api/3/bulk/issues/fields` (async — returns a task id to poll, same family as bulk label/type edits). Companion discovery endpoint: `GET /rest/api/3/bulk/issues/fields` ("Get bulk editable fields"; **paginated, 50 fields/page**, cursor params `startingAfter`/`endingBefore`).
Limits: **max 1000 issues** (incl. subtasks) and **200 fields** per request.

Source [PRIMARY]: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/

### Q2.1 — Is `components` on the bulk-edit allowlist? — **CONFIRMED**

Yes. The GET "bulk editable fields" response example lists it verbatim:

```json
{
  "id": "components",
  "isRequired": false,
  "multiSelectFieldOptions": ["ADD", "REMOVE", "REPLACE", "REMOVE_ALL"],
  "name": "Components",
  "type": "components",
  "unavailableMessage": "{0}NOTE{1}: The project of the selected issue(s) does not have any components."
}
```

The allowlist is **dynamic** — GET returns fields eligible for the *specific* issues + current user + field config. Components appears only when the selected issues' project actually has components (hence the `unavailableMessage`). So a robust client should GET-check eligibility (or handle the "unavailable" case) rather than assume.

Sources [PRIMARY]: doc quoted verbatim in https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/ ; UI parity ("Change Component/s") https://support.atlassian.com/jira-software-cloud/docs/edit-multiple-issues/

### Q2.2 — EXACT request JSON — **CONFIRMED (per docs; see live-verification caveat in Q2.4)**

Confirmed by three independent renderings of the same schema:
- [PRIMARY] Atlassian bulk-operations doc (POST example body), quoted verbatim.
- [SECONDARY] apidog mirror https://krevt8mwkh.apidog.io/bulk-edit-issues-19180025e0 (`"components": [ "componentId": 0 ]`, same shape).
- [SECONDARY] swagger-v3 OpenAPI (`JiraMultiSelectComponentField` / `JiraComponentField`, `componentId` = `integer`/`int64`) cited by deep research.

Key facts:
- `selectedActions` entry: **`"components"`** (lowercase field id).
- Property under `editedFieldsInput`: **`"multiselectComponents"`** — a **single object, NOT an array**, and **NOT `componentsFields`**. (Contrast: `labelsFields`, `multipleVersionPickerFields` are arrays; `multiselectComponents`, `issueType`, `priority`, `status` are single objects.)
- Nested `fieldId`: **`"components"`**.
- Per-value object: **`{"componentId": <integer>}`** — an integer id. **NOT** `{"name": ...}` and **NOT** `{"id": ...}`.
- Operation enum `bulkEditMultiSelectFieldOption`: **`ADD` | `REMOVE` | `REPLACE` | `REMOVE_ALL`**. All three inner props (`fieldId`, `components`, `bulkEditMultiSelectFieldOption`) are required.

**ADD** (add components, keep existing):
```json
{
  "selectedActions": ["components"],
  "selectedIssueIdsOrKeys": ["PROJ-101", "PROJ-102"],
  "editedFieldsInput": {
    "multiselectComponents": {
      "fieldId": "components",
      "components": [{"componentId": 10001}, {"componentId": 10002}],
      "bulkEditMultiSelectFieldOption": "ADD"
    }
  },
  "sendBulkNotification": false
}
```

**REMOVE** (remove listed, keep others): same body, `"bulkEditMultiSelectFieldOption": "REMOVE"`.

**REPLACE** (overwrite full component set on every issue): same body with the new set and `"bulkEditMultiSelectFieldOption": "REPLACE"`.

**REMOVE_ALL** (clear the field): `"components": []` + `"bulkEditMultiSelectFieldOption": "REMOVE_ALL"` (documented clearing form).

Verbatim doc fragment (Atlassian POST example):
```json
"multiselectComponents": {
  "bulkEditMultiSelectFieldOption": "ADD",
  "components": [{"componentId": 2154}],
  "fieldId": "<string>"
}
```

### Q2.3 — camelCase/lowercase asymmetry class — **CONFIRMED (present, and stronger than for labels/type)**

There **is** an analogous asymmetry, and it is more pronounced than the `labels`/`issuetype` cases:

```
selectedActions entry:                "components"          (lowercase field id)
editedFieldsInput property:           "multiselectComponents"   (camelCase, DIFFERENT WORD)
multiselectComponents.fieldId:        "components"
multiselectComponents.components[]:   { "componentId": <int> }
```

It is **NOT** any of: `componentsFields`, `multiSelectComponents` (capital-S), `editedFieldsInput.components`.

Parallels the known repo cases:
- labels: `selectedActions:"labels"` vs `editedFieldsInput.labelsFields[]` (array) with values `{"name":...}`.
- issue type: `selectedActions:"issuetype"` (lowercase) vs `editedFieldsInput.issueType` (camelCase) with `{"issueTypeId":...}`.
- components: `selectedActions:"components"` vs `editedFieldsInput.multiselectComponents` (**object**, not `componentsFields`) with `{"componentId":<int>}`.

**Extra gotcha for this repo:** the **bulk** value shape uses an **integer `componentId`**, whereas the **single-issue `update`-verb** shape (already in jr) uses **`{"name": ...}` or `{"id": ...}`** objects (e.g. `"components":[{"add":{"name":"Engine"}}]`). This is a genuine per-path asymmetry — bulk requires resolving component names to **numeric ids** first, unlike the single-issue add/remove path. Same class as the `labelsFields` bare-string-vs-object and bulk-transition nested-shape surprises this repo has already hit.
- [PRIMARY] single-issue verb shape: https://developer.atlassian.com/server/jira/platform/jira-rest-api-example-edit-issues-6291632/ (`{"update":{"components":[{"add":{"name":"Engine"}}]}}`).

### Q2.4 — Source clarity + fallback recommendation — **Documented clearly; live-run NOT yet observed**

**Clearly documented** (unlike bulk transitions, whose flat OpenAPI shape was wrong):
- The Atlassian bulk-operations doc **itself** renders a populated `multiselectComponents` example with an integer `componentId` (search-confirmed verbatim, not only the raw swagger). This is stronger than the bulk-transition situation, where the doc/OpenAPI shape was flat and only the community + a live run revealed the nested `bulkTransitionInputs` truth.
- Corroborated across 3 independent renderings (Atlassian doc, apidog mirror, swagger schema).

**Caveat / not-yet-confirmed:**
- No **live-run** confirmation exists in the sources (contrast bulk transitions, confirmed via live run 27156639337). The doc is internally consistent, but this repo's own history (`FIX-BULK-TRANSITION-001`: "the flat top-level shape documented in the Atlassian OpenAPI JSON is wrong … live Jira rejects it") is a standing reminder that Atlassian's bulk-ops docs have shipped wrong shapes before.
- One community post attempting `multiselectComponents` got "Invalid request payload" — but that was misuse (a **CMDB object custom field**, not the system Components field, with malformed non-object array entries), **not** a refutation of the real components shape. https://community.developer.atlassian.com/t/bulk-issue-update/95268
- GET eligibility is dynamic and paginated; `components` only appears when the project has components.

**Recommendation for #605 Wave 2:** The bulk shape is well-enough documented to **implement against `multiselectComponents` + integer `componentId` + ADD/REMOVE/REPLACE/REMOVE_ALL** — do **not** default to single-key-only out of doc-uncertainty (that was the right call for bulk transitions because the doc was actually wrong; here the doc example is correct-looking and triple-corroborated). **However, gate the bulk path behind a real live-Jira smoke test before shipping** (mirror the bulk-transition and #446 label-bulk validation discipline): one live ADD, one REMOVE, one REPLACE against ≥2 issues in one project, asserting the async task reports success and the components landed. Because the endpoint is async (poll a task), reuse the existing bulk poll/timeout machinery (`JR_BULK_AWAIT_TIMEOUT_SECS`, unknown-grace). Resolve component **names → numeric ids** client-side before building the payload (createmeta/project components lookup), since bulk rejects name/id-string objects. If the live smoke test contradicts the documented shape, fall back to documenting single-key-only for this cycle and record the true shape (as `FIX-BULK-TRANSITION-001` did).

---

## Cross-cutting: rate-limit / pagination / deprecation notes

- **Bulk edit is async + rate-limited by size:** 1000 issues / 200 fields per request cap. Batch large sets; reuse jr's bulk poll loop.
- **GET bulk-editable-fields is paginated** (50/page, cursor `startingAfter`/`endingBefore`) — a full field enumeration needs cursor iteration.
- **`moveIssuesTo` v3 doc description is currently blank** (rendering bug) — contract unchanged; cite the legacy/DC reference for the authoritative wording.
- **Single-issue component `update` verbs quirk:** community reports the `add`/`remove` verbs have been flaky historically, with `set` (send full list) being the reliable path — relevant if jr's single-key component edit ever sees 400s. https://community.developer.atlassian.com/t/removing-component-from-issue-via-rest-api/49653
- **No deprecation signals** found on either the component CRUD or bulk-operations endpoints as of 2026-08-15.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 2 | Q1 full safety picture (delete semantics, recoverability, changelog, confirmation, CLI convention scan); Q2 bulk component shape + asymmetry + source clarity |
| Perplexity perplexity_search | 2 | Cross-validation: independent corroboration of bulk `multiselectComponents`/`componentId` shape (Atlassian doc + apidog + community); component-delete `moveIssuesTo` null semantics + changelog evidence |
| WebFetch | 2 | Attempted direct re-verification of the bulk-operations doc page and swagger JSON (both JS-rendered/too-large to parse — noted as a limitation; superseded by perplexity_search which surfaced the verbatim doc fragment) |
| Training data | 0 areas | Not relied upon for any factual claim; all claims sourced to cited URLs |

**Total MCP tool calls:** 4 (2 research + 2 search)
**Training data reliance:** low — every verdict is tied to a cited Atlassian primary or clearly-labeled secondary source. The two WebFetch attempts failed to parse (JS rendering / file size) but the same facts were recovered verbatim via perplexity_search, so no gap resulted.

### Verdict summary

**Q1:** 1 CONFIRMED (with/without moveIssuesTo effect) · 2 CONFIRMED (permanent, no trash) · 3 **INCONCLUSIVE, leans yes** (delete-cascade changelog not contractually guaranteed → snapshot before delete) · 4 CONFIRMED (single unguarded destructive call) · 5 CONFIRMED (norm = prompt + `--yes`) · 6 recommend layered guardrails (require `--move-to` OR `--orphan`; `--yes`/confirm on the irreversible `--orphan` path).

**Q2:** 1 CONFIRMED (components on allowlist, dynamic) · 2 CONFIRMED per docs (`multiselectComponents` object + `{"componentId": <int>}` + ADD/REMOVE/REPLACE/REMOVE_ALL) · 3 CONFIRMED (asymmetry present; bulk uses integer `componentId` vs single-issue name/id) · 4 documented clearly + triple-corroborated, but **no live-run yet** → implement against the documented shape but gate behind a live smoke test before shipping.
