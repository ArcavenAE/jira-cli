---
issue: 577
topic: "Comment `visibility` object identifier-vs-value shape — schema support and identifier-only GET responses"
date: 2026-07-10
status: MIXED — Q1 VALIDATED (High), Q2 INCONCLUSIVE-LEANING-VALIDATED (Low-Medium), Q3 SPLIT (docs REFUTED / runtime INCONCLUSIVE)
sibling: issue-577-visibility-put-semantics-2026-07-09.md
sibling2: issue-577-properties-merge-replace-2026-07-09.md
sibling3: issue-577-comment-crud-jsdpublic-2026-07-09.md
---

# Research: Issue #577 — Comment `visibility` object shape (`value` vs `identifier`) and identifier-only GET response behavior

## Question

An adversarial spec review made a compound claim about the Jira Cloud REST API v3 comment `visibility` object:

> "The Jira Cloud comment `visibility` object supports two mutually-exchangeable identifier shapes: `{\"type\":\"role\",\"value\":\"<name>\"}` and `{\"type\":\"role\",\"identifier\":\"<id>\"}` (same for `\"group\"`). Jira DOES RETURN the identifier-only form (no `value` key, or value absent) on some GET code paths — notably when the restriction was set by id, or when the role/group was renamed/deleted."

Decomposed into three questions:

1. **Q1 — Schema.** Does the official Jira Cloud REST v3 comment response schema document `visibility.identifier` alongside `visibility.value`?
2. **Q2 — GET-response reality.** Can a GET response's `visibility` object contain `identifier` WITHOUT `value` (value absent/null) in practice — e.g., group-by-id (GDPR groupId migration) restrictions, renamed/deleted groups or roles?
3. **Q3 — Role-type value guarantee.** Is `value` documented as always-present for role-type visibility, or can roles also come back identifier-only?

## Verdicts

| Q  | Topic                                                    | Verdict            | Confidence  |
| -- | -------------------------------------------------------- | ------------------ | ----------- |
| Q1 | Schema documents `identifier` alongside `value`          | **VALIDATED**      | High        |
| Q2 | GET responses can carry `identifier` without `value`     | **INCONCLUSIVE — leans toward supported but rare** | Low-Medium |
| Q3 | Docs guarantee `value` always present for role visibility | **Docs claim: REFUTED. Runtime shape for role identifier-only: INCONCLUSIVE.** | Medium (docs) / Low (runtime) |

The first part of the compound claim (both shapes are supported) is well-substantiated. The second part ("Jira DOES RETURN identifier-only") is a stronger factual assertion than the evidence carries — no concrete GET-response example showing `identifier` without `value` was found in Atlassian documentation, bug tickets, or community discussion. The claim survives as *plausible* (allowed by the schema, encouraged by GDPR migration) but not *demonstrated*.

## Evidence

### E1 — Atlassian's groupID migration announcement (STRONGEST direct signal, Atlassian-authored)

**Source (Atlassian Developer Community, Atlassian staff-authored, load-bearing):** *"Adding support for groupID field in Jira REST APIs, expressions types"* — <https://community.developer.atlassian.com/t/adding-support-for-groupid-field-in-jira-rest-apis-expressions-types/61045> (posted 2022-08-29).

The announcement uses **comment visibility as its canonical example** of the migration pattern:

Old behavior (request payload):
```json
"comment": {
  "visibility": {
    "type": "group",
    "value": "jira-software-users"
  }
}
```

New behavior (request payload):
```json
"comment": {
  "visibility": {
    "identifier": "276f955c-63d7-42c8-9520-92d01dca0625",
    "type": "group",
    "value": "jira-software-users"
  }
}
```

Load-bearing quotes:

> "Jira Cloud is moving towards using `groupID` s as unique identifier for groups instead of group `name` s."
>
> "As you may know, Jira does not offer the functionality to rename groups. To enable that, we want groups to be identified by an identifier with is immutable. Currently, group `name` is used as an identifier, which is inherently mutable. Thus, we need to remove the use of group `name` as the identifier."
>
> "We will be **removing** the support for group `name` field from such Jira Public APIs starting **February 28 2023**."

This announcement (a) confirms the Visibility schema formally supports `identifier` alongside `value` (**Q1 → VALIDATED**), (b) declares intent to *remove* group `name` support after 2023-02-28 — which, if fully executed, would produce identifier-only responses for group-type visibility (relevant to **Q2**).

**Caveat — soft- vs hard-deprecation:** The threatened February 2023 removal appears to have soft-deprecated rather than hard-removed. Every real-world response example located in the field-level Atlassian docs, staff-answered community threads (E2 below), and third-party client documentation continues to show *both* `identifier` and `value` co-present. The stated deprecation timeline does not appear to have shipped as originally announced; no follow-up changelog entry marking the deprecation as complete was found. This is the reason Q2 is INCONCLUSIVE rather than VALIDATED.

**Follow-up thread (2023-01-25, community developer, page 2 of same thread):**

> "The first endpoint allows the following syntax for the attribute `visibility`: `visibility { type: \"group\", identifier: groupId };`. I.e. we can omit `value`."

This developer report is a request-side confirmation (identifier-only requests are accepted); it does not confirm the corresponding GET response shape.

### E2 — Atlassian schema examples consistently show BOTH fields co-present

Every located Atlassian-hosted response example that renders `visibility` includes both `identifier` and `value`, using identical strings for role-type visibility:

- **Jira Cloud REST v3 issue-search reference** — <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/> — sample response body: `"visibility": { "identifier": "Administrators", "type": "role", "value": "Administrators" }`
- **Jira Software Cloud REST board reference** — <https://developer.atlassian.com/cloud/jira/software/rest/api-group-board/> — same shape: `"visibility": { "identifier": "Administrators", "type": "role", "value": "Administrators" }`
- **Community.developer.atlassian.com — Inconsistency between response and schema** — <https://community.developer.atlassian.com/t/inconsistency-between-the-response-and-the-schema-definition/89818> — cites the doc excerpt of a GET-issue response containing `"visibility": { "identifier": "Administrators", "type": "role", "value": "Administrators" }`.

The pattern in every published Atlassian example is **both fields present, both carrying the role name**. No example was located that shows a GET response omitting `value`. For role-type visibility specifically, `identifier` in every doc example holds the role *name* (not a numeric role id) — this is the design pattern noted in `.factory/research/issue-577-visibility-put-semantics-2026-07-09.md` step 7 of the empirical probe.

### E3 — Atlassian Swagger schema formally defines the `Visibility` bean

**Source:** <https://dac-static.atlassian.com/cloud/jira/platform/swagger.v3.json?_v=1.8516.27>

The swagger spec references a `#/components/schemas/Visibility` component from the `Comment` schema (`"visibility":{"allOf":[{"$ref":"#/components/schemas/Visibility"}],"description":"The group or role to which this comment is visible."`). The Visibility bean contains `type`, `value`, and `identifier` — third-party OpenAPI reproductions (E5) render the field descriptions as:

- `visibility.type` — enum `group` | `role`
- `visibility.value` — "The name of the group or role. (Group names are mutable; use identifier to reliably identify a group.)"
- `visibility.identifier` — "The ID of the group or the name of the role that visibility is restricted to."

The description for `identifier` is significant: it explicitly documents an asymmetry between groups and roles. For groups, `identifier` is an ID (an opaque UUID like `276f955c-…`, per E1). For roles, `identifier` is the role *name*. This is corroborated by every response example in E2 where role-type `identifier` matches `value` string-for-string.

### E4 — Atlassian bug AUTO-766: `value` and `identifier` are mutually exclusive in requests

**Source (Atlassian bug tracker):** <https://jira.atlassian.com/browse/AUTO-766>

Atlassian's own analysis of the bug:

> "The body parameters 'value' and 'identifier' are mutually exclusive."

The example request that fails carries both keys: `"visibility": { "identifier": "Contributor", "type": "role", "value": "Contributor" }`. The workaround is to remove one field.

**Interpretation for Q3 (docs claim):** AUTO-766 documents that request payloads must supply exactly one of `value`/`identifier` — implying role visibility can be legitimately set via `identifier` alone. Combined with the schema description in E3 (`identifier` for roles holds the role name), a comment created with identifier-only role visibility *should* be storable server-side. Whether the eventual GET response echoes only `identifier` or synthesizes `value` from it is not documented and no example was found — hence the split verdict on Q3.

**Interpretation for Q2:** AUTO-766 confirms the API can accept identifier-only visibility inputs, which is a necessary precondition for identifier-only GET responses to occur. It does not by itself confirm they occur.

### E5 — Third-party OpenAPI reproductions (corroborative, non-authoritative)

Multiple third-party sources reproduce Atlassian's schema descriptions verbatim from the OpenAPI spec, which validates that both fields are formally defined:

- **WithOne.ai Jira connector docs** — <https://www.withone.ai/knowledge/jira/conn_mod_def::GJ4qWx3Kb1o::0bZJGMHBTVmw0g2nMGkVYA> — lists `visibility.identifier`, `visibility.type`, `visibility.value` with the field descriptions quoted above.
- **Leena.ai Jira connector docs** — <https://docs.leena.ai/docs/jira-cloud> — same three fields with identical descriptions.
- **vinu/jira-cloud-rest-api (community OpenAPI reproduction)** — <https://github.com/vinu/jira-cloud-rest-api/blob/master/docs/Comment.md> — Comment schema documents `visibility` as `AllOfCommentVisibility` and marks it optional on create/update.
- **ankitpokhrel/jira-cli issue #994** — <https://github.com/ankitpokhrel/jira-cli/issues/994> — "On Jira Cloud, identifier and value are mutually exclusive in visibility" — matches AUTO-766.

None of these third-party docs asserts anything about GET response shape beyond what Atlassian documents. They collectively confirm the formal schema (Q1) but add no independent runtime evidence.

### E6 — Stale-identifier scenario in the wild: Atlassian KB on invisible comments

**Source (Atlassian Support KB, Atlassian-authored):** *"Resolving Invisible Comments Issue in Jira Due to Incorrect Group Level Settings"* — <https://support.atlassian.com/jira/kb/resolving-invisible-comments-issue-in-jira-due-to-incorrect-group-level-settings/>

The KB documents a real customer symptom where comments have `grouplevel = '00000000-0000-0000-0000-000000000000'` — a valid-format UUID pointing to a non-existent group in the Jira database. The remediation is a `UPDATE jiraaction SET grouplevel = null` SQL statement.

**What this evidence proves:** Stale/orphaned group identifiers can and do persist in Jira Cloud's comment-visibility data at the database level. A comment can carry a `grouplevel` that no longer resolves to any real group.

**What this evidence does NOT prove:** The KB describes an internal database column (`jiraaction.grouplevel`), not the REST API's `visibility` JSON response shape. The bridge from "stale grouplevel in DB" to "REST GET returns `{ type: 'group', identifier: '<stale-uuid>' }` with no `value` field" is not stated in the KB and no other source located confirms that translation. This is the mechanism-level *support* for the identifier-only hypothesis but not a *demonstration* of it.

### E7 — What could NOT be found (negative evidence)

Explicit examples looked for but not located:

- **No Atlassian changelog entry** at <https://developer.atlassian.com/changelog/> confirming that the February 2023 group-name removal actually shipped for comment visibility.
- **No published GET response example** — in developer docs, changelog, bug tracker, or community — showing a `visibility` object with `identifier` present and `value` absent/null.
- **No JRACLOUD or JSDCLOUD ticket** describing a "value-missing" or "identifier-only" comment-visibility symptom observed by a customer or integrator.
- **No community post** describing a client crash or parsing failure caused by an unexpectedly missing `value` field in a comment `visibility` object.
- **No `groupId` field distinct from `identifier`** in the visibility bean — Atlassian folded the group-ID migration into the existing `identifier` field (rather than adding a separate `groupId` sibling as they did on the Group bean per E1's "Response type" example).

The absence of #3 and #4 is a soft negative signal: if identifier-only GET responses were widespread, clients relying on `value` for display would produce visible symptoms.

## Answers to the three questions

### Q1 — Does the schema formally document `identifier` alongside `value`?

**VALIDATED — High confidence.**

Load-bearing source: **E1** — Atlassian's own 2022-08-29 groupID migration announcement, which uses comment `visibility` as its canonical example and explicitly shows the three-field shape `{ identifier, type, value }`. Corroborated by:

- E3 (Atlassian swagger.v3.json defines the `Visibility` component referenced by `Comment.visibility`)
- E2 (three Atlassian-hosted response examples all render both fields)
- E4 (Atlassian bug AUTO-766 discusses both fields as first-class body parameters)
- E5 (four independent OpenAPI reproductions render the same field descriptions)

### Q2 — Can a GET response's `visibility` object contain `identifier` WITHOUT `value` in practice?

**INCONCLUSIVE — leans toward supported-but-rare; Low-Medium confidence.**

Load-bearing source: **E1** — the groupID migration announcement declares Atlassian's intent to remove `name`-based support for groups starting 2023-02-28, which would produce identifier-only responses for group-type visibility. The mechanism is documented; the actual shipped state is not confirmed.

The claim's plausibility is supported by:

- E1 (announced deprecation of group-name; identifier-only requests explicitly allowed per page-2 developer confirmation)
- E4 (mutual exclusivity of `value`/`identifier` in requests means at least one legitimate write path stores identifier alone server-side)
- E6 (the KB proves stale/orphaned group identifiers persist in Jira Cloud data — providing a mechanism whereby a GET could plausibly emit an identifier with no resolvable name)

The claim's factual demonstration is NOT supported by any Atlassian-authoritative or community-observed GET-response example. Every documented sample shows both fields co-present (E2). The originally-announced 2023-02-28 removal does not appear to have shipped as a hard cutover; no follow-up changelog was found (E7).

**Recommended stance for jr:** treat identifier-only GET responses as a **possible but undocumented shape**. Parsers should tolerate an absent `value` (fallback to `identifier` for display) rather than assume both are always present. This is the same defensive-parsing recommendation E1's design intent implies. Do NOT bake in the assumption that Jira "does" return identifier-only forms as a common case — the evidence for "does" is thinner than the claim asserts.

### Q3 — Is `value` documented as always present for role-type visibility, or can roles also come back identifier-only?

**Split verdict:**

- **Documentation-claim (`value` guaranteed for role): REFUTED — Medium confidence.** No Atlassian documentation was found asserting that `value` is guaranteed present for role-type visibility in GET responses. On the contrary, the schema (E3) treats `identifier` and `value` as parallel fields for both group and role types, and AUTO-766 (E4) allows role-type requests to send `identifier` alone. There is no textual guarantee.
- **Runtime-behavior (role visibility identifier-only in GET): INCONCLUSIVE — Low confidence.** Every located GET-response example for role-type visibility (E2) shows both fields co-present, with `identifier` and `value` carrying the same role-name string. No example was located showing role visibility with only `identifier` and no `value`. For roles the practical asymmetry between the two fields is minimal (both carry the role name), so the identifier-only shape is architecturally supported but has no observed instances.

Load-bearing source: **E3** (schema describes `identifier` as "The ID of the group or the **name of the role** that visibility is restricted to" — establishing that for roles, `identifier` holds the same value as `value`, making an identifier-only response semantically equivalent to a value-only response). Contrasted with E2 (every documented role-visibility example has both).

## Implications for jr

Given the three verdicts:

1. **Parse defensively.** Any code path that parses `comment.visibility` from a GET response must NOT assume `value` is always present. Prefer `identifier ?? value` (identifier-first, since it is the migration-preferred stable key per E1); fall back to `value` only when `identifier` is missing. This is a low-cost guard — the mainline case (both present) works unchanged.
2. **On writes, honor mutual exclusivity (E4/AUTO-766).** When jr eventually ships `--restrict-role <name>` / `--restrict-group <name-or-id>` flags (out of scope for F3), the client must send *either* `value` *or* `identifier`, never both. Sending both currently returns a 400 for automation and would return the same for jr. If a user supplies a UUID-shaped argument to `--restrict-group`, prefer `identifier`; otherwise use `value`. Consider `--restrict-group-id` as an explicit form.
3. **Do not add a citation to the "identifier-only GET" scenario in error messages or CLAUDE.md gotchas until it is empirically observed.** The evidence supports the *possibility* but not the *observed occurrence*. Overclaiming would violate the citation-discipline rule (`CLAUDE.md` — "before citing … in anything a user sees, Perplexity-validate the source actually documents the symptom"). The current sibling `issue-577-visibility-put-semantics-2026-07-09.md` correctly assumes the GET-response shape includes both fields (step 7 EXPECT line); that assumption remains the empirically-documented case.
4. **Extend the empirical probe.** The sibling probe (`issue-577-visibility-put-semantics-2026-07-09.md` steps 6–10) captures the baseline GET after creating a role-restricted comment with `visibility.value`. A one-line variant would settle Q2 for jr's purposes:

```bash
# Companion probe — create a role-restricted comment using IDENTIFIER (not value),
#                    then GET to observe the response shape.
CID=$(curl -sS -X POST \
  -H "Authorization: ${AUTH}" -H "Content-Type: application/json" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment" \
  -d '{
    "body":{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"probe-visibility-identifier 2026-07-10"}]}]},
    "visibility":{"type":"role","identifier":"'"${ROLE}"'"}
  }' | jq -r '.id')

curl -sS -H "Authorization: ${AUTH}" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment/${CID}" \
  | jq '.visibility'
# Q2 verdict:
#   BOTH fields present in response → Jira echoes value from identifier → Q2 REFUTED for the fresh-write path
#   ONLY identifier present         → Jira really does emit identifier-only → Q2 VALIDATED
#   ONLY value present              → Jira canonicalizes to value → surprising; documentation gap larger than thought
```

One request-response round-trip settles the fresh-write branch. The stale-role branch (Q2's "renamed/deleted role" sub-claim) requires an additional teardown step (create → restrict → rename-or-delete-role → re-GET) and is best deferred until it becomes load-bearing for a specific jr feature.

## Research Methods

| Tool                                        | Calls | Purpose                                                                                          |
| ------------------------------------------- | ----: | ------------------------------------------------------------------------------------------------ |
| **Perplexity `perplexity_research` (high)** |     1 | Comprehensive multi-source synthesis across Atlassian docs, bug tracker, community, third-party clients (E1–E5, most of E7). |
| Perplexity `perplexity_search`              |     2 | Targeted follow-up: (a) confirm schema/Visibility-bean shape; (b) surface groupID/GDPR migration announcement and Atlassian KB on invisible comments (E1, E6). |
| WebFetch                                    |     1 | Direct extraction of the Atlassian developer community groupID-migration announcement to confirm verbatim request/response examples for comment visibility (E1). |
| Read (sibling research file)                |     1 | Read `issue-577-visibility-put-semantics-2026-07-09.md` to align format, tone, evidence-labeling scheme, and to avoid re-litigating the PUT-omission verdict. |

**Total MCP tool calls:** 3 (1 perplexity_research + 2 perplexity_search).
**Training-data reliance:** low — every claim is grounded in a cited URL (E1–E6). The one architectural inference (Q2 leans-toward-supported because the mechanism is documented even though the outcome is not observed) is labelled as such in the verdict text. The single load-bearing Atlassian document is E1 (the groupID migration announcement), quoted verbatim with URL.
