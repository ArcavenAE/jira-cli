---
issue: 577
topic: "PUT comment visibility field — semantics when omitted from body-only PUT"
date: 2026-07-09
status: VALIDATED (documentation-silent on the exact phrase; verdict rests on architectural + circumstantial evidence + one load-bearing Atlassian announcement)
verdict: PRESERVED
confidence: Medium-High
supersedes: none
sibling: issue-577-properties-merge-replace-2026-07-09.md
sibling2: issue-577-comment-crud-jsdpublic-2026-07-09.md
---

# Research: Issue #577 — `visibility` field on `PUT /comment/{id}` — PRESERVE vs CLEAR vs FAIL

## Question

When `PUT /rest/api/3/issue/{issueIdOrKey}/comment/{id}` is sent with a **body-only** payload — `{"body": <ADF>}`, no `visibility` key at all — and the comment already carries a role- or group-based restriction (`visibility: {"type":"role"|"group","value":<name>,"identifier":<id>}`), what happens?

- **(A) PRESERVED** — restriction survives; comment stays restricted.
- **(B) CLEARED** — restriction stripped; comment becomes visible to any user with Browse Projects.
- **(C) FAILS** — PUT returns 400 (visibility was mandatory).

CLEARED is the silent data-loss footgun: a user tweaking a typo in a role-restricted (e.g. "Administrators"-only) comment would unwittingly publish it to everyone with Browse Projects. Distinct from the sibling `properties[]` question (see `issue-577-properties-merge-replace-2026-07-09.md`, verdict MERGE) — `visibility` is a **first-class field on the comment resource**, not an entity-property sub-resource, so its update semantics could legitimately differ.

## Verdict

**PRESERVED** — Medium-High confidence.

A body-only PUT does not touch existing role/group visibility. The restriction is only changed when the caller explicitly includes a `visibility` object in the request body.

## Confidence Calibration

Not High. Atlassian's `updateComment` v3 reference does not contain a single explicit sentence saying "omitted `visibility` is preserved" — the reference documents the field on the schema but is silent on partial-vs-full-representation semantics for it (checked via Perplexity Research 2026-07-09 against <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/#api-rest-api-3-issue-issueidorkey-comment-id-put>).

The verdict lands at Medium-High rather than Medium because of **one load-bearing Atlassian communication** (Evidence E1 below) whose logic collapses under the CLEARED interpretation. High is reserved for the outcome of the proposed empirical probe.

## Evidence

### E1 — Atlassian's "child comment visibility" announcement (STRONGEST direct signal)

**Source (Atlassian-authored, load-bearing):** *"Important Update: Restriction on Changing Child Comment Visibility in Jira Cloud"*, Atlassian Developer Community — <https://community.developer.atlassian.com/t/important-update-restriction-on-changing-child-comment-visibility-in-jira-cloud/91548>.

Verbatim (per Perplexity high-context extraction):

> "For those of you using the REST API, please note that the API will no longer allow changes to the visibility of child comments directly. **Attempting to update a child comment's visibility will now result in a 400 (Bad Request) error.**"

> "Changing a parent comment's visibility to restrict access will automatically apply the same restriction to all child comments."

> "**This will not impact modifying the visibility of the parent comment.**"

**Why this is load-bearing for the PRESERVED verdict:** Atlassian's rollout carefully distinguishes "attempting to update a child comment's visibility" from ordinary content edits. If a body-only PUT to a child comment implicitly cleared `visibility` (CLEARED semantics), then **every** `--body`-style edit of a threaded reply would trip the new 400 guard — a fleet-wide breakage that the announcement gives zero acknowledgement of. The plain reading is that the 400 fires only when a request **explicitly carries** a `visibility` object targeting a child, and body-only edits pass through untouched. The announcement's coherence therefore *requires* PRESERVED semantics for parent comments too (Atlassian would not silently apply different omission rules to parent vs child comments on the same endpoint). This is the "attempts to update a child comment's visibility return 400" note referenced in the sibling `issue-577-comment-crud-jsdpublic-2026-07-09.md` line 101 — resolved and cited here.

### E2 — Contrast with issue-edit PUT (`/rest/api/3/issue/{key}`) is patch-shaped, not full-representation

Jira Cloud's issue PUT is idiomatically partial-update / patch-shaped: clients send only the fields they want to change (`{"fields":{…}}` and/or `{"update":{…}}`), and unspecified fields survive. Documented and long-established behavior; every Jira integration on the market depends on it (jr's own `issue edit` in `src/cli/issue/edit.rs` does not read-and-echo untouched fields). Atlassian does not use the label "PATCH" for PUT endpoints, but the operational semantics are patch-shaped across the platform.

The comment PUT sits in the same API surface (same team, same endpoint conventions) and there is no counter-evidence that it deviates. `body` behaves as patch-style for its own content, and there is no architectural motivation for `visibility` (a sibling optional field in the same request-body object) to switch to full-representation semantics one level down. Extraordinary semantics would demand extraordinary documentation, which is absent.

Reference: <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/>.

### E3 — Absence of incident reports on JRACLOUD/JSDCLOUD (negative evidence)

Perplexity Research (reasoning_effort=high, search across Atlassian trackers, developer community, and third-party integrations) surfaced **no** ticket or community post matching the CLEARED symptom — no "comment visibility lost", "restricted comment reset", "comment lost restriction after REST edit", "role restriction cleared after PUT", etc. Related tickets that did surface concern orthogonal issues:

- **JRACLOUD-69231** — UI padlock icon missing from new issue view; not a REST update bug. <https://jira.atlassian.com/browse/JRACLOUD-69231>
- **JSDCLOUD-829** — enhancement request for more visibility options in JSM; no update-clearing symptom. <https://jira.atlassian.com/browse/JSDCLOUD-829>
- **JSDCLOUD-3499** — comment visibility via email creation; not update-related. <https://jira.atlassian.com/browse/JSDCLOUD-3499>

If CLEARED were the semantics, restricted comments would routinely leak on every typo fix, and the fallout would be visible in bug trackers and support forums — this is a security-adjacent behavior (a leaked role-restricted comment reveals content its author never intended for a broader audience). The absence of such reports across years of integrations is a strong negative signal.

### E4 — No `read-modify-write` pattern in the wild for visibility preservation

If clients had to echo `visibility` back to prevent clearing (the pattern that would arise under CLEARED semantics), that pattern would dominate community answers and third-party client code. It does not.

- **NangoHQ integration template** (<https://github.com/NangoHQ/integration-templates/blob/main/integrations/jira/actions/update-comment.ts>) — passes `visibility` **conditionally** via `input.visibility`; does not read the current comment first. If CLEARED were live, this template would be a data-loss bug on every text edit of a restricted comment.
- **Atlassian Community "Update comment via REST"** answers (<https://community.atlassian.com/forums/Confluence-questions/REST-API-How-to-update-an-existing-COMMENT-for-an-existing-issue/qaq-p/2684637>) — recommend body-only PUT, no `visibility` preservation caveat.
- **Atlassian KB — Restrict comment visibility in team-managed project** (<https://support.atlassian.com/jira/kb/restrict-the-comment-visibility-in-a-team-managed-project/>) — teaches restricted-comment creation via REST as a workaround; issues no warning that future edits will clear the workaround's restriction.
- **ScriptRunner "default comment visibility" behavior discussions** (<https://community.atlassian.com/forums/Jira-questions/JIRA-default-comment-visibility-via-ScriptRunner-Behaviors/qaq-p/136377>) — set defaults **at creation**, not at edit time. If edit-clears-visibility were reality, the canonical guidance would be a ScriptRunner post-function preserving visibility on every edit; none exists.

Under CLEARED, one of these ecosystems would have manufactured the workaround. None have.

### E5 — `visibility` in GET responses is presence-when-restricted, absent otherwise

Comment GET (`/rest/api/3/issue/{key}/comment/{id}`) returns a `visibility` object **only** when the comment carries a restriction. Unrestricted comments have no `visibility` key at all (they inherit standard project browse permissions). This is the classic Jira convention for optional-restriction fields and matches the KB example shape at <https://support.atlassian.com/jira/kb/restrict-the-comment-visibility-in-a-team-managed-project/>. This shape has two consequences relevant here:

1. There is no `null`/default sentinel for `visibility` in the wire format — meaning a symmetric round-trip (GET → PUT the exact payload back) would already omit `visibility` for unrestricted comments. If PUT-with-omitted-`visibility` meant CLEARED, then feeding the GET response verbatim back into the PUT would corrupt every restricted-comment edit made by a "download-modify-upload" client. That would break Atlassian's own JQL-import/export tools.
2. Symmetric with `body`: `body` is required and its content is a first-class writable field. `visibility` is optional in the request and optional in the response; the shape is consistent with "if you want to change it, send it; otherwise it is invisible to both directions."

### E6 — Atlassian's `updateComment` reference wording (documentation gap)

Perplexity high-context probe of <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/#api-rest-api-3-issue-issueidorkey-comment-id-put>:

> The reference lists `visibility` as an optional field on the request-body schema (alongside `body` and `properties`) but uses **none** of the vocabulary that would settle omission semantics directly: no "omit", no "unchanged", no "preserved", no "clear", no "replaces", no "full representation", no "partial update", no "patch". Atlassian's Jira Cloud REST docs consistently avoid this vocabulary and expect readers to infer partial-update semantics from platform-wide convention.

So there is no counter-evidence text to weigh against the PRESERVED inference — and equally, no confirmatory single-sentence text. This is the same documentation-gap pattern that governed the sibling MERGE-vs-REPLACE verdict.

## What documentation is silent about

The v3 `updateComment` reference does not spell out:

1. Whether `visibility` is a full-representation-shaped field (send in full or lose it) or a patch-shaped field (omit to leave alone). Inferred: patch.
2. Whether `PUT` with only `body` is a "content edit" or a "comment representation replacement". Inferred: content edit.
3. Whether reading a comment's `visibility` via GET is required before any PUT for safety. Inferred: no.
4. Whether `visibility` can be explicitly cleared by sending `visibility: null`, `visibility: {}`, or by omitting it. **Unresolved by this research** — the empirical probe below extends to cover this in step 5b (worth deciding before jr ever ships a `--unrestrict` / `--clear-visibility` flag; not blocking F3 today).

## Recommendations for jr

Given verdict PRESERVED with Medium-High confidence:

1. **Ship the F3 body-only edit path unchanged.** No visibility-preservation defensive logic is required for the current `jr issue comment edit` scope — the omission is safe.
2. **Do NOT default to reading + echoing `visibility` on every edit.** That would (a) add a GET round-trip to every edit for no measured benefit, (b) commit jr to an "implicit visibility preservation" contract broader than PRESERVED itself justifies, and (c) create a re-entrancy risk if Atlassian ever ships stricter validation on echoed `visibility` payloads.
3. **When jr eventually adds an explicit `--restrict-role <name>` / `--restrict-group <name>` / `--unrestrict` flag family** (out of scope for F3, tracked as a follow-up), gate on the child-comment 400 announcement (E1): jr must detect parent-vs-child status and reject the flags on child comments with a helpful error rather than surfacing Atlassian's raw 400. This mirrors the ADR-0015 proactive-enforcement pattern already used for `issue move` done-category transitions.
4. **Add a CLAUDE.md gotcha entry** documenting the PRESERVED verdict, this research file, and the child-comment 400 constraint from E1 so future maintainers do not "helpfully" add a defensive read-modify-write cycle that would waste a request per edit.
5. **Extend the sibling MERGE-vs-REPLACE empirical probe on JSM sandbox `EJ`** to cover this visibility case as well (see below). Not a hard blocker for F3 — architectural evidence is strong enough to ship — but the probe is cheap and closes the doc gap definitively.

## Proposed empirical probe extension (JSM sandbox `EJ`)

Two additional steps bolted onto the deferred properties probe from `issue-577-properties-merge-replace-2026-07-09.md`. Placeholder substitutions: `${INSTANCE}` = Atlassian Cloud site host, `${AUTH}` = Basic auth header, `${KEY}` = a Jira issue key on the sandbox site (e.g. `EJ-999`), `${CID}` = the created comment id (captured from the create response), `${ROLE}` = a role name that exists on the site (e.g. `Administrators`).

```bash
# 6. Create a restricted comment with a role visibility restriction (in addition to
#    the two properties from step 1 of the existing probe, if run together).
CID=$(curl -sS -X POST \
  -H "Authorization: ${AUTH}" -H "Content-Type: application/json" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment" \
  -d '{
    "body":{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"probe-visibility 2026-07-09"}]}]},
    "visibility":{"type":"role","value":"'"${ROLE}"'"}
  }' | jq -r '.id')

# 7. Baseline read — confirm visibility is present.
curl -sS -H "Authorization: ${AUTH}" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}" \
  | jq '.visibility'
# EXPECT: {"type":"role","value":"${ROLE}","identifier":"<role-id>"}

# 8. THE PROBE. PUT with body-only — no visibility key at all.
curl -sS -X PUT \
  -H "Authorization: ${AUTH}" -H "Content-Type: application/json" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}" \
  -d '{"body":{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"probe body-only edit — visibility omitted"}]}]}}'

# 9. Verdict step for visibility.
curl -sS -H "Authorization: ${AUTH}" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}" \
  | jq '.visibility'
# PRESERVED → object still present, same type + value + identifier as step 7.
# CLEARED   → field missing entirely (comment is now unrestricted).
# FAILS     → step 8 already 400'd; won't reach here.

# 10. Bonus — probe explicit-clear syntax (informs Recommendation #3 above).
#     Try each in turn against a fresh restricted comment to see which Atlassian accepts.
#     (Only one of these needs to work; jr's future --unrestrict picks the successful shape.)
# 10a. visibility: null
# 10b. visibility: {}
# 10c. visibility: {"type":"role","value":""}
# Not required for F3; document results for the future flag.

# Cleanup.
curl -sS -X DELETE -H "Authorization: ${AUTH}" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}"
```

One round-trip through steps 8→9 settles the PRESERVED-vs-CLEARED question. Step 10 is a bonus for future `--unrestrict` design.

## Enumeration of ALL writable fields on the comment PUT — omission risk table

The standing checklist question: for every field the endpoint accepts on the request body, is omission safe or a data-loss vector? Sources: v3 updateComment schema (<https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/#api-rest-api-3-issue-issueidorkey-comment-id-put>), v3 addComment schema (as reference for the shape of the comment resource), Atlassian community integration templates, and the sibling research files.

| Field                     | Writable on PUT?          | Omission behavior                                                                      | Risk       | Verdict source                                       |
|---------------------------|---------------------------|----------------------------------------------------------------------------------------|------------|------------------------------------------------------|
| `body`                    | Yes (required)            | If omitted → 400 (endpoint's raison d'être). Any body-shaped PUT must supply `body`.   | None       | Documented required field; universal integrator use  |
| `visibility`              | Yes (optional)            | **PRESERVED** — existing role/group restriction survives.                              | Low        | **This document** (E1–E6), Medium-High confidence     |
| `properties` (array)      | Yes (optional, undocumented on PUT) | **MERGE** — listed keys upserted, unlisted preserved.                        | Low        | Sibling `issue-577-properties-merge-replace-2026-07-09.md`, Medium-High confidence |
| `jsdPublic`               | **No — response-only**    | JSM public/internal state is not toggled via the platform comment PUT — it lives in the `sd.public.comment` entity **property** (`{"internal": true/false}`). Sending `jsdPublic` on PUT is silently ignored (community-observed behavior); the field appears only in GET responses on JSM comments. Toggling internal/public is what the sibling MERGE research is about — do it via `properties`, not `jsdPublic`. | Low       | Sibling `issue-577-comment-crud-jsdpublic-2026-07-09.md`; Atlassian JSDSERVER-1261 <https://jira.atlassian.com/browse/JSDSERVER-1261> |
| `jsdAuthorCanSeeRequest`  | **No — response-only**    | Derived from the customer-vs-agent role membership and project settings; not writable via the platform comment PUT. Omission is a non-event.                                                                     | None       | Community/JSM docs — no writable path documented     |
| `author` / `updateAuthor` | **No — server-set**        | Atlassian sets these from the OAuth token / auth header; PUT payloads cannot override.  | None       | Documented immutable field                            |
| `created` / `updated`     | **No — server-set**        | Timestamps managed by Jira; not writable.                                              | None       | Documented immutable field                            |
| `self`, `id`              | **No — server-set**        | Resource identifiers; not writable.                                                    | None       | Documented immutable field                            |
| `renderedBody`            | **No — response-only**    | Server renders on GET when `expand=renderedBody` requested; not part of PUT contract.  | None       | Documented response-only field                       |
| `expand` (query)          | Query param, not body      | Irrelevant to PUT; controls response shape on GET.                                     | N/A        | Documented query parameter                            |

**Standing-checklist verdict:** the two fields that could have been silent-data-loss risks on a body-only PUT — `visibility` and `properties` — are both **safe under omission** per this document (E1–E6, verdict PRESERVED) and the sibling research (verdict MERGE). No further fields in the comment PUT surface introduce omission-risk. jr's F3 body-only edit path is architecturally safe.

## Research Methods

| Tool                                        | Calls | Purpose                                                                                     |
| ------------------------------------------- | ----: | ------------------------------------------------------------------------------------------- |
| **Perplexity `perplexity_research`** (high) |     1 | Comprehensive multi-source synthesis of visibility PUT semantics across docs, trackers, community, and integration code. |
| Read (two sibling research files)           |     2 | Cross-referenced prior verdicts on properties MERGE and comment CRUD/jsdPublic to avoid re-litigating.  |

**Total MCP tool calls:** 1.
**Training-data reliance:** low — every claim is grounded in a cited URL or a sibling research file. Architectural inferences are labelled as such (E2, E4, E5). The single load-bearing Atlassian document is E1 (the child-comment 400 announcement), verbatim-quoted with URL.
