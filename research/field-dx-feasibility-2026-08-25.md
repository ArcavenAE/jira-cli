---
document_type: research
cycle: field-dx
topic: Feasibility validation for GitHub issues #580 and #578 (Field DX bundle)
producer: architect (research pass, feasibility re-validation against codebase)
timestamp: 2026-08-25
status: complete
---

# Research: Field DX Bundle Feasibility (#580, #578)

## Headline verdict

**#580 must pivot from the endpoint it literally proposes.** The issue's own
workaround (`GET /rest/api/3/field/{id}/context/{ctx}/option`) requires
`manage:jira-configuration` scope **and** Administer-Jira permission — it fails
outright for an ordinary (non-admin) 3LO OAuth user, which is `jr`'s typical
user population (confirmed against current Atlassian REST v3 docs and the
OAuth 3LO scope model). **PIVOT: enumerate via `GET
/rest/api/3/issue/{key}/editmeta`'s `allowedValues`** — scope `read:jira-work`,
no admin gate. `jr` already owns this exact call and its typed response shape.

**#578 is fully feasible as specified**, no pivot required. All four
`--field NAME:kind=VALUE` hint forms and the non-JSM `--field` extension are
reachable with `write:jira-work` under standard OAuth 3LO, no admin scope.

## Verdicts by claim

| # | Claim | Verdict | Basis |
|---|---|---|---|
| 1 | `GET /field/{id}/context/{ctx}/option` requires `manage:jira-configuration` + Administer Jira | **CONFIRM** | Atlassian REST v3 docs, "Issue custom field options (apps)" / "context" endpoint family — admin-gated by design (it's a configuration-surface endpoint, not a data-read endpoint). Non-admin 3LO tokens receive 403. |
| 2 | `GET /issue/{key}/editmeta` `fields[].allowedValues` is a working substitute for option enumeration | **CONFIRM** | Scope `read:jira-work`, no admin permission gate. `jr` already calls this endpoint (`JiraClient::get_editmeta`, `src/cli/issue/field_resolve.rs`) and already parses `allowedValues` into `Vec<AllowedValue>` (`src/types/jira/editmeta.rs`) for `issue edit --field` (BC-3.4.015/016). Reuse is direct, not merely analogous. |
| 3 | editmeta is issue-scoped, not field-scoped in isolation | **CONFIRM (design constraint, not a blocker)** | editmeta requires an existing issue key (it reflects that issue's Edit screen for its current issue type/project). `jr field options <field>` therefore needs either (a) a required/resolvable issue key, or (b) a pivot to `GET /issue/createmeta/{projectKey}/issuetypes/{id}?expand=fields` (also `read:jira-work`, no admin gate, and does NOT require an existing issue — it reflects the *Create* screen instead). `jr` already calls a sibling createmeta endpoint (`GET /issue/createmeta/{projectKey}/issuetypes` — issue-type list only, no `expand=fields`) for issue-type name resolution (S-331, `src/api/jira/issues.rs::get_issue_types_for_project`), so the createmeta family is an established, non-admin-gated pattern in this codebase — not virgin territory. **This is a genuine F2 design fork, flagged for business-analyst/architect resolution in Phase F2, not resolved here.** |
| 4 | Name→fieldId resolution via `GET /rest/api/3/field` is non-admin-accessible | **CONFIRM** | Scope `read:jira-work`. `jr` already calls this (`JiraClient::list_fields`, `src/api/jira/fields.rs`) for story-points/CMDB/team field discovery. `partial_match.rs` already provides case-insensitive substring + duplicate-name disambiguation, reusable as-is for "resolve by human name (nice-to-have)". |
| 5 | Single-select accepts both `{"value":...}` and `{"id":...}` | **CONFIRM** | Standard Jira Cloud custom-field wire contract for `option`-type fields; `jr` already emits both forms today (`resolve_edit_fields`'s id-bypass vs. value-match branches, `src/cli/issue/field_resolve.rs`). |
| 6 | Cascading-select wire shape is `{"value":parent,"child":{"value":child}}` | **CONFIRM** | Standard Jira Cloud cascading-select contract. **Not currently implemented anywhere in `jr`** — `resolve_edit_fields`'s "option" branch has no cascading arm. Not one of the four explicit hint kinds (`:option`/`:id`/`:name`/`:asset`) enumerated in #578's acceptance criteria — flagged as an open scope question for F2 (in scope of #578, or deferred). |
| 7 | Assets object-ref array `[{"workspaceId","id","objectId"}]` is settable via standard `PUT /issue/{key}` | **CONFIRM** | No separate Assets write API exists for issue custom fields; the CMDB object-reference custom field type accepts this array shape through the ordinary issue-fields PUT/POST body. `jr` already resolves and caches `workspaceId` per-profile (`get_or_fetch_workspace_id`, `src/api/assets/workspace.rs`, 7-day TTL) — the only new work is composing the array (parsing the user's `:asset=<objectId>` or `<workspaceId>:<objectId>` hint value into the three-key object) and mapping `id` to the `"{workspaceId}:{objectId}"` composite convention `jr` already reads in `LinkedAsset` (`src/types/assets/linked.rs`). |
| 8 | Non-JSM custom fields work via `POST /rest/api/3/issue` subject to createmeta screen eligibility | **CONFIRM** | Standard Jira behavior — any field on the target issue type's Create screen is settable; a field absent from that screen 400s. Recommendation: surface Jira's own "not on screen"/"cannot be set" error text rather than pre-validating client-side against createmeta before every create call (avoids adding a mandatory extra HTTP round-trip to the create hot path; matches `jr`'s existing pattern of surfacing server 400s for out-of-band fields rather than replicating screen-config logic client-side). |
| 9 | All of the above are reachable under standard OAuth 3LO scopes jr already requests | **CONFIRM** | `read:jira-work` (list_fields, editmeta, createmeta) and `write:jira-work` (issue PUT/POST) are both already in `DEFAULT_OAUTH_SCOPES`; no new scope, no re-consent prompt, no Atlassian Developer Console change needed for this bundle. |

## Key synergy (headline for the delta report)

With the pivot in claim 2/3, **both #580 and #578 center on the same
editmeta/createmeta `allowedValues` foundation `jr` already owns** —
`src/types/jira/editmeta.rs` (`EditMeta`/`EditMetaField`/`AllowedValue`),
`JiraClient::get_editmeta` (`src/api/jira/issues.rs`), and the existing
option-resolution dispatch in `resolve_edit_fields`
(`src/cli/issue/field_resolve.rs`). #580 is a **read-only, thinner** consumer
of that exact data; #578's four hint kinds are, by contrast, a **pure
client-side syntactic transform** on `--field`'s value and need **no**
editmeta/createmeta HTTP call at all for the hinted forms (the user is
declaring the wire shape explicitly, bypassing the fuzzy-match heuristics
`resolve_edit_fields` uses for the unhinted case). The two stories therefore
touch overlapping types/modules but for different reasons — #580 reads the
same metadata #578's *unhinted* path already reads; #578's *hinted* path
skips metadata entirely.

## Open design questions carried to F2 (not resolved here)

1. **editmeta-vs-createmeta pivot for `jr field options`** (claim 3): does the
   command require `--issue <KEY>`, or does it resolve via
   `--project`/config + a default/first issue type through createmeta
   `?expand=fields`? The latter avoids needing a live issue but is a new API
   surface (`jr` has never called createmeta with `expand=fields`); the former
   is zero new API-layer code but is a DX regression relative to the issue's
   proposed `jr field options customfield_10084` (no issue argument).
2. **Cascading-select scope** (claim 6): in scope of #578 or deferred to a
   follow-up? Not one of the four explicit hint kinds in the acceptance
   criteria.
3. **`--field` NAME-side hint-syntax parsing owner**: `parse_field_kv`
   (`src/cli/issue/create.rs`, shared by `create.rs`, `edit.rs`, and
   `jsm_create.rs`) currently returns `HashMap<String, String>` with no room
   for a kind tag. Introducing `:option=`/`:id=`/`:name=`/`:asset=` requires a
   signature/return-type change that ripples to all three call sites plus
   `resolve_edit_fields` (`field_resolve.rs`) and `JsmRequestBuilder::build`
   (`src/api/jsm/requests.rs`, which today unconditionally wire-serializes
   every extra field as a raw string). This is the single highest-fan-out
   change in the bundle — flagged for architecture attention in F2, not a
   blocker.

## Sources

- Atlassian REST API v3 documentation (issue custom field options / context
  endpoints; editmeta; createmeta; issue fields).
- OAuth 2.0 (3LO) scope reference (`read:jira-work`, `write:jira-work`,
  `manage:jira-configuration`).
- In-repo precedent: `src/cli/issue/field_resolve.rs`,
  `src/types/jira/editmeta.rs`, `src/api/jira/fields.rs`,
  `src/api/jira/issues.rs` (`get_issue_types_for_project`, S-331),
  `src/api/assets/workspace.rs`, `src/types/assets/linked.rs`,
  `src/api/jsm/requests.rs`, `src/cli/issue/create.rs`,
  `src/cli/issue/jsm_create.rs`.
