---
issue: 577
topic: "PUT comment properties[] — MERGE vs REPLACE semantics"
date: 2026-07-09
status: VALIDATED (documentation-silent; verdict rests on architectural + circumstantial evidence)
verdict: MERGE
confidence: Medium-High
supersedes: none
sibling: issue-577-comment-crud-jsdpublic-2026-07-09.md
---

# Research: Issue #577 — `properties[]` on `PUT /comment/{id}` — MERGE vs REPLACE

## Question

When `PUT /rest/api/3/issue/{issueIdOrKey}/comment/{id}` is sent with

```json
"properties": [{"key": "sd.public.comment", "value": {"internal": true}}]
```

what happens to OTHER entity properties already attached to the comment but NOT
listed in the submitted array? Are they:

- **(A) MERGE** — listed keys upserted; unlisted existing properties preserved intact.
- **(B) REPLACE** — the submitted array is the full authoritative property set; unlisted existing properties are dropped.

REPLACE is a silent data-loss footgun: JSM comments in the wild carry
`sd.public.comment`, `sd.rich.text.formatting`, and third-party integration app
properties (Slack/Teams/Halp/ScriptRunner) simultaneously.

## Verdict

**MERGE** — Medium-High confidence.

The submitted `properties` array is applied as per-key upserts. Unlisted
existing comment entity properties are preserved.

## Confidence Calibration

Not High. Atlassian's public documentation is **silent** on the semantics on
two levels:

1. The v3 `updateComment` reference (<https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/>) doesn't document a `properties` field on the PUT request body at all — only `body` is described. The field is accepted in practice per community-widespread pattern, but its wire contract is undocumented (Perplexity Ask verification 2026-07-09).
2. There is no explicit prose (in either the comment endpoint or the entity-properties overview at <https://developer.atlassian.com/cloud/jira/platform/jira-entity-properties/>) using the words "merge", "replace", "overwrite", "preserve", or "upsert" for this specific interaction.

So the verdict rests on **architectural inference + absence-of-incidents**
rather than a single load-bearing sentence. Medium-High is the highest
confidence honestly available without an empirical probe (which is proposed
below).

## Evidence

### E1 — Independent CRUD on the property resource (strongest structural signal)

Comment properties are a first-class resource with per-key CRUD:

- `GET /rest/api/3/comment/{commentId}/properties` — list keys.
- `GET /rest/api/3/comment/{commentId}/properties/{propertyKey}` — read one value.
- `PUT /rest/api/3/comment/{commentId}/properties/{propertyKey}` — "creates or updates the value of a property" (per-key upsert).
- `DELETE /rest/api/3/comment/{commentId}/properties/{propertyKey}` — remove one key.

Sources:
- <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comment-properties/>
- <https://developer.atlassian.com/cloud/jira/platform/rest/v2/api-group-issue-comment-properties/>

If comment updates silently replaced the entire property set, this dedicated
per-key resource would be pointless — every partial edit through the parent
endpoint would sabotage state that only the property resource could restore.
Atlassian's design commits to per-key semantics; the parent endpoint's
`properties` array is the shortcut form of the same per-key operation, not a
distinct wholesale-replace lane.

### E2 — Contrasting design: issue properties DO expose bulk semantics explicitly

The issue-properties resource explicitly exposes **bulk update and bulk delete**:

- <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-properties/>
- `POST /rest/api/3/issue/properties` — bulk update.
- `DELETE /rest/api/3/issue/properties` — bulk delete.

Atlassian's pattern: when they intend bulk / replace-all semantics for
properties, they build a dedicated endpoint and document it. Comment
properties have **no such endpoint**. Building a covert bulk-replace via
overloading the parent `PUT` — with data-loss potential — would be
inconsistent with Atlassian's own design pattern one endpoint group over.

### E3 — Atlassian entity-properties conceptual doc positions properties as app-owned KV stores

The generic Jira entity-properties doc
(<https://developer.atlassian.com/cloud/jira/platform/jira-entity-properties/>)
describes properties as key-value stores attached to entities for **apps to
persist their own state**. The design intent is clearly stability: an app
plants its property and expects it to survive routine user actions (edits,
transitions) unless explicitly removed. A parent-PUT that indiscriminately
wipes app-installed properties whenever a user retitles a comment would
violate the contract the entity-properties feature exists to provide.

### E4 — Community pattern uses partial `properties[]` unwarned

The canonical community answer for setting a JSM comment internal via REST is:

- <https://community.atlassian.com/forums/Jira-Service-Management/REST-API-update-Comment-to-internal/qaq-p/1483037>

The pattern is:

```json
PUT /rest/api/3/issue/{key}/comment/{id}
{
  "body": <ADF>,
  "properties": [{"key": "sd.public.comment", "value": {"internal": true}}]
}
```

Nowhere in the community thread — nor in the derivative examples cited in
the sibling research doc (Atlassian Developer Community "Internal comment
migration via import or REST API help", Atlassian MCP server issue #139,
Jenkins Jira plugin #375) — does anyone caveat that this destroys unlisted
`sd.rich.text.formatting` or integration-app properties. This pattern has
been used in production for years. If REPLACE were the semantics, the
resulting cascade of integration-app data loss would be visible in bug
trackers.

Sources:
- <https://community.atlassian.com/forums/Jira-Service-Management/REST-API-update-Comment-to-internal/qaq-p/1483037>
- <https://community.developer.atlassian.com/t/internal-comment-migration-via-import-or-rest-api-help/31175>
- <https://github.com/atlassian/atlassian-mcp-server/issues/139>
- <https://github.com/jenkinsci/jira-plugin/issues/375>

### E5 — Absence of incident reports (negative evidence)

Searched Atlassian's public tracker (JSDCLOUD, JRACLOUD, JSWCLOUD) via
Perplexity Research (reasoning_effort=high) for terms like "comment
properties deleted", "comment property lost", "sd.public.comment reset",
"entity properties replaced", "comment update overwrites properties". No
tickets surfaced describing property loss caused by a REST comment PUT.
The nearest ticket — **JSDCLOUD-6050 "Editing sd.public.comment comment
property using REST API is not reflecting"** — concerns direct property-endpoint
PUT results not reflecting in the JSM portal UI (a rendering/read-back bug on the
happy path), NOT collateral loss of other properties (verified: the ticket text
describes a single-property PUT that fails to reflect, not any deletion side
effect). Source: <https://jira.atlassian.com/browse/JSDCLOUD-6050>.

Given the volume of JSM installations with third-party integrations that
rely on comment entity properties, silent property loss on a routine
"toggle internal" REST call would be a headline-grade support burden. The
absence isn't proof, but for a shipped-for-years endpoint on a
heavily-integrated platform, it's a strong negative signal.

### E6 — Atlassian's PUT is idiomatically patch-shaped

Atlassian's Jira Cloud REST APIs consistently use PUT with partial-update
semantics — clients need only send the fields being changed, and unspecified
fields survive. This is documented behavior for the issue-edit PUT (the
`{"update":{…},"fields":{…}}` schema is opt-in per-field) and is the model
the comment PUT follows for `body`. If `body` is partial-update-shaped,
`properties` sitting next to it in the same request body being wholesale-replace-shaped
would be a jarring inconsistency — not impossible, but requires positive evidence,
and none exists.

## What documentation is silent about

Confirmed via Perplexity Ask 2026-07-09 (search_context_size=high) against the
v3 comment API reference page:

> "The v3 `updateComment` reference page is silent on merge-vs-replace
> semantics for comment `properties`. It provides no verbatim wording for
> a `properties` field on the request body for `PUT /rest/api/3/issue/{issueIdOrKey}/comment/{id}`."

So there is no counter-evidence text to weigh against the MERGE inference —
and equally, no confirmatory text. This is a documentation gap Atlassian
has never closed.

## Recommendations for jr

Given verdict MERGE with Medium-High (not High) confidence:

1. **Ship `--internal` / `--public` on `jr issue comment edit` using the direct-array pattern.** Do NOT default to including a `properties` array when neither flag is passed (matches sibling research recommendation).
2. **Belt-and-suspenders — cheap defensive read-modify-write on JSM issues (RECOMMENDED, not required).** When `--internal`/`--public` is used AND the target is a JSM project, do one `GET .../comment/{id}?expand=properties` first, then echo ALL existing property keys back in the PUT with `sd.public.comment` updated. Cost: one extra GET per JSM comment edit. Benefit: eliminates the residual risk from the doc gap. Skip the extra GET on non-JSM (Software) projects — those comments carry fewer/no properties.
3. **Add a CLAUDE.md gotcha entry** documenting the MERGE verdict, this research file, and the recommended defensive pattern for future maintainers.
4. **Do NOT run an empirical probe as a hard blocker for F3** — the architectural evidence is strong enough to ship the direct-array pattern. But schedule the probe below as a follow-up E2E validation (JSM sandbox `EJ`), and if the probe ever refutes MERGE, add the defensive read-modify-write unconditionally.

## Proposed empirical probe (JSM sandbox `EJ`)

The definitive test. All five steps against a real JSM instance. Placeholder
substitutions: `${INSTANCE}` = Atlassian Cloud site host, `${AUTH}` = Basic
auth header, `${KEY}` = a JSM issue key in `EJ` (e.g. `EJ-999`), `${CID}` =
the created comment id (captured from step 1's response).

```bash
# 1. Create a JSM comment with TWO properties: sd.public.comment=internal AND jr.test.marker=alpha.
CID=$(curl -sS -X POST \
  -H "Authorization: ${AUTH}" -H "Content-Type: application/json" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment" \
  -d '{
    "body":{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"probe-2026-07-09"}]}]},
    "properties":[
      {"key":"sd.public.comment","value":{"internal":true}},
      {"key":"jr.test.marker","value":{"phase":"alpha"}}
    ]
  }' | jq -r '.id')

# 2. Baseline read — confirm BOTH properties present.
curl -sS -H "Authorization: ${AUTH}" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}?expand=properties" \
  | jq '.properties'
# EXPECT: both sd.public.comment and jr.test.marker.

# 3. PUT with body-only (no properties key at all). Sibling research already established
# this preserves everything; re-run here for a clean baseline against step 4.
curl -sS -X PUT \
  -H "Authorization: ${AUTH}" -H "Content-Type: application/json" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}" \
  -d '{"body":{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"probe body-only edit"}]}]}}'
curl -sS -H "Authorization: ${AUTH}" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}?expand=properties" \
  | jq '.properties'
# EXPECT: both properties still present.

# 4. THE PROBE. PUT with properties array containing ONLY sd.public.comment. If MERGE,
# jr.test.marker survives; if REPLACE, jr.test.marker is silently deleted.
curl -sS -X PUT \
  -H "Authorization: ${AUTH}" -H "Content-Type: application/json" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}" \
  -d '{
    "body":{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"probe partial-properties edit"}]}]},
    "properties":[{"key":"sd.public.comment","value":{"internal":false}}]
  }'

# 5. Verdict — does jr.test.marker survive?
curl -sS -H "Authorization: ${AUTH}" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}?expand=properties" \
  | jq '.properties'
# MERGE  → array contains BOTH sd.public.comment (now internal:false) AND jr.test.marker (still {"phase":"alpha"}).
# REPLACE → array contains ONLY sd.public.comment. jr.test.marker is gone.

# Cleanup — delete the probe comment.
curl -sS -X DELETE -H "Authorization: ${AUTH}" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}"
```

One round-trip through steps 4→5 settles it. If MERGE (expected), the
verdict lands at High confidence and Recommendation #2 becomes optional
(pure defense-in-depth). If REPLACE (unexpected), F3 must ship
Recommendation #2's read-modify-write as mandatory before shipping
`--internal`/`--public`.

## Research Methods

| Tool                                       | Calls | Purpose                                                                                     |
| ------------------------------------------ | ----: | ------------------------------------------------------------------------------------------- |
| **Perplexity `perplexity_research`** (high) |     1 | Comprehensive multi-source synthesis of MERGE-vs-REPLACE across docs, trackers, community.  |
| **Perplexity `perplexity_ask`** (high ctx)  |     1 | Verbatim quote hunt on the v3 updateComment reference for `properties` semantics language.  |
| WebFetch                                    |     1 | Attempted direct fetch of the v3 comment reference (truncated; superseded by Perplexity).   |
| Read (sibling research file)                |     1 | Cross-referenced prior verdicts on Claims 1 and 7 to avoid re-litigating settled ground.    |

**Total MCP tool calls:** 2.
**Training-data reliance:** low — every claim is grounded in a cited URL or the sibling research file. Architectural inferences are labelled as such.
