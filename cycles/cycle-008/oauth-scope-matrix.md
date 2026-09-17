# OAuth 2.0 (3LO) Endpoint → Scope Matrix — `jr` CLI (cycle-008 final)

**Date:** 2026-09-17
**Purpose:** Definitive, per-endpoint OAuth scope matrix to finalize `DEFAULT_OAUTH_SCOPES`
for cycle-008. Every scope claim is cross-referenced to the 82-endpoint inventory
(`oauth-endpoint-inventory.md`) and cited to official `developer.atlassian.com` docs.
This is the "make sure we're calculating ALL the places this impacts" pass.
**Method:** Perplexity deep-research (`sonar-deep-research`) over official Atlassian REST
reference + scope-catalog pages, plus a targeted confirmation lookup for the component
scope. Confidence tags: **CONFIRMED** (official docs) / **UNCERTAIN** (verify live).

**Current `DEFAULT_OAUTH_SCOPES` (verbatim, `auth.rs:83-88`):**
```
read:jira-work write:jira-work read:jira-user
read:servicedesk-request write:servicedesk-request
read:cmdb-object:jira read:cmdb-schema:jira
offline_access
```

---

## Headline verdicts (read this first)

1. **BULK API — NO SCOPE GAP. Classic scopes already cover it.** `POST /rest/api/3/bulk/issues/fields`
   and `POST /rest/api/3/bulk/issues/transition` are covered by classic **`write:jira-work`**;
   `GET /rest/api/3/bulk/queue/{taskId}` by classic **`read:jira-work`**. No bulk-specific scope
   exists; the endpoints ARE available to 3LO apps. `jr issue edit`/`move` bulk paths work under
   OAuth with the scopes `jr` already holds. **CONFIRMED.** (The inventory's `#20-22`
   NEEDS-RESEARCH flags are resolved — clear, no action.)

2. **NEW GAP DISCOVERED — Component WRITES need `manage:jira-project`, NOT `write:jira-work`.**
   `POST/PUT/DELETE /rest/api/3/component[/{id}]` (inventory `#41/#42/#44`, backing
   `jr component create/edit/delete/rename`) require the classic **`manage:jira-project`** scope.
   `jr` holds neither `manage:jira-project` nor an equivalent granular scope. **These commands
   fail under OAuth today**, and would STILL fail after cycle-008's planned Agile-scope + routing
   fixes unless `manage:jira-project` is added. **CONFIRMED.** This is the single most important
   new finding of this pass — a scope gap *beyond* Agile that the inventory mis-classified as OK.

3. **CLASSIC + GRANULAR COEXIST — no forced migration.** Adding granular `*-software` scopes to
   the same app does NOT invalidate classic `read:jira-work`/`write:jira-work` for platform
   endpoints. There is no "once granular, granular everywhere" rule. **CONFIRMED.**

---

## (a) Per-endpoint-family scope table (cross-referenced to the inventory)

### Family 1 — Platform `/rest/api/3` (routing OK)

| Inv # | Endpoint family | R/W | Required classic scope | Held? | Verdict |
|---|---|---|---|---|---|
| 1-2 | search/jql, approximate-count | R | `read:jira-work` | ✅ | OK — CONFIRMED |
| 3-4,7-9,15-19 | issue get / editmeta / transitions / comment-read / createmeta | R | `read:jira-work` | ✅ | OK — CONFIRMED |
| 16-17 | changelog, comments list | R | `read:jira-work` | ✅ | OK — CONFIRMED |
| 5-6,10-14 | issue create / edit / transition / assign / comment CRUD | W | `write:jira-work` | ✅ | OK — CONFIRMED |
| 23-24,26 | issueLink create/delete, remotelink | W | `write:jira-work` | ✅ | OK — CONFIRMED |
| 25 | issueLinkType | R | `read:jira-work` | ✅ | OK — CONFIRMED |
| 27-31 | myself, user search, assignable, user lookup | R | `read:jira-user` | ✅ | OK — CONFIRMED |
| 32-38 | field, status, priority, resolution, project get/search/statuses | R | `read:jira-work` | ✅ | OK — CONFIRMED |
| 39 | GET project/{key}/components | R | `read:jira-work` | ✅ | OK — CONFIRMED |
| 40 | GET component/{id}/relatedIssueCounts | R | `read:jira-work` | ✅ | OK — CONFIRMED (classic still works post-2023 deprecation; granular alt is `read:field:jira`+`read:project.component:jira`) |
| 43 | GET component/{id} | R | `read:jira-work` | ✅ | OK — CONFIRMED |
| **41** | **POST /component (create)** | **W** | **`manage:jira-project`** | ❌ | **GAP — CONFIRMED** |
| **42** | **PUT /component/{id} (edit/rename)** | **W** | **`manage:jira-project`** | ❌ | **GAP — CONFIRMED** |
| **44** | **DELETE /component/{id}** | **W** | **`manage:jira-project`** (granular `delete:project.component:jira`) | ❌ | **GAP — CONFIRMED** |
| 45-46 | worklog add/list | W/R | `write:jira-work` / `read:jira-work` | ✅ | OK — CONFIRMED |
| 47-51 | attachment list/meta/upload/delete/download | R/W | `read:jira-work` / `write:jira-work` | ✅ | OK — CONFIRMED |
| **20** | **POST /bulk/issues/fields** | **W** | **`write:jira-work`** (granular alt `write:issue:jira`+`read:issue:jira`) | ✅ | **OK — CONFIRMED (was NEEDS-RESEARCH)** |
| **21** | **POST /bulk/issues/transition** | **W** | **`write:jira-work`** (granular alt `write:issue:jira`+`read:issue:jira`) | ✅ | **OK — CONFIRMED (was NEEDS-RESEARCH)** |
| **22** | **GET /bulk/queue/{taskId}** | **R** | **`read:jira-work`** (granular alt `read:issue:jira`) | ✅ | **OK — CONFIRMED (was NEEDS-RESEARCH)** |

### Family 2 — Agile `/rest/agile/1.0` (routing OK; **classic scopes do NOT work — granular MANDATORY**)

| Inv # | Endpoint | R/W | Required granular scope(s) | Held? | Verdict |
|---|---|---|---|---|---|
| 52 | GET /board (list) | R | `read:board-scope:jira-software` + `read:project:jira` | ❌ | GAP — CONFIRMED |
| 53 | GET /board/{id}/configuration | R | `read:board-scope.admin:jira-software` + `read:project:jira` | ❌ | GAP — CONFIRMED |
| 54 | GET /board/{id}/sprint | R | `read:sprint:jira-software` | ❌ | GAP — CONFIRMED |
| 55 | GET /sprint/{id}/issue | R | `read:sprint:jira-software` + `read:issue-details:jira` + `read:jql:jira` | ❌ | GAP — CONFIRMED |
| 56 | POST /sprint/{id}/issue (sprint add) | W | `write:board-scope:jira-software` | ❌ | GAP — CONFIRMED |
| 57 | POST /backlog/issue (sprint remove) | W | `write:board-scope:jira-software` | ❌ | GAP — CONFIRMED |

**Jira Software page states verbatim: "Jira Software doesn't support classic scopes. Use granular
scopes instead."** — CONFIRMED. This is why `read:jira-work` cannot cover Agile.

### Family 3 — JSM `servicedeskapi` (routing broken today — scopes already held once re-routed)

| Inv # | Endpoint | R/W | Required scope | Held? | Verdict |
|---|---|---|---|---|---|
| 58,61,62 | servicedesk / requesttype / requesttype-field | R | `read:servicedesk-request` | ✅ | scope OK — CONFIRMED (routing fix = S3/S4) |
| 59,60 | queue / queue issues | R | **`read:jira-work`** (NOT `read:servicedesk-request`) | ✅ | scope OK — CONFIRMED (queues document classic `read:jira-work`; also requires agent membership) |
| 63 | POST /request (JSM create) | W | `write:servicedesk-request` | ✅ | scope OK — CONFIRMED |
| 64 | GET /assets/workspace (Assets prereq) | R | `read:servicedesk-request` | ✅ | scope OK — CONFIRMED |
| 66-67 | attachTemporaryFile / request attachment | W | `write:servicedesk-request` | ✅ | scope OK + routing already OK — CONFIRMED |

No JSM scope change needed. Every JSM gap is a **routing** problem (`*_instance` → gateway), not a
scope problem.

### Family 4 — Assets / CMDB (routing OK; blocked only by prereq #64 routing)

| Inv # | Endpoint | R/W | Required scope | Held? | Verdict |
|---|---|---|---|---|---|
| 68-71,74 | object/aql, object get, attributes, connected tickets | R | `read:cmdb-object:jira` | ✅ | scope OK — CONFIRMED |
| 72-73 | objectschema list, objecttypes/flat | R | `read:cmdb-schema:jira` | ✅ | scope OK — CONFIRMED |

No Assets scope change needed. Entire Assets surface is functional under OAuth once the workspace
prereq (#64, JSM routing) is fixed. (If `jr` later adds type/attribute *write* or deeper discovery,
`read:cmdb-type:jira` / `read:cmdb-attribute:jira` may be needed — not required for current calls.)

### Family 5 — Teams / GraphQL (routing broken + scope-unavailable; spike S6)

| Inv # | Endpoint | R/W | Required scope | Held? | Verdict |
|---|---|---|---|---|---|
| 75 | POST /gateway/api/graphql → migrate to `POST https://api.atlassian.com/graphql` | R | `view:team:teams` (+ `view:membership:teams` for member data) | ❌ | GAP — routing + scope; **UNCERTAIN** whether scope is addable to a Jira 3LO app in the Console (verify live) |
| 76 | GET /gateway/api/public/teams/... (public REST) | R | **none — "Forge and OAuth2 apps cannot access this REST resource"** | ❌ | **UNFIXABLE via scope — must migrate to GraphQL** — CONFIRMED |

### Families 6-8 — tenant_info / OAuth flow / `jr api`

No scope decision: tenant_info is unauthenticated pre-auth (#77); the OAuth flow endpoints (#78-81)
are the flow itself; `jr api` (#82) inherits whatever scope the user's path requires.

---

## (b) FINAL recommended minimal `DEFAULT_OAUTH_SCOPES` set

Each scope justified with the endpoints that require it. This is the complete union covering every
`jr` endpoint that should work over OAuth.

```
# --- Platform issue/user/field CRUD (keep — all CONFIRMED covering) ---
read:jira-work                       # platform reads #1-4,7-9,15-19,25,32-40,43,46-48,51; JSM queues #59-60; BULK reads #22
write:jira-work                      # platform writes #5-6,10-14,23-24,26,45,49-50; BULK writes #20-21
read:jira-user                       # user endpoints #27-31

# --- Component administration (ADD — NEW gap, CONFIRMED) ---
manage:jira-project                  # component create/edit/delete/rename #41,#42,#44 (write:jira-work does NOT cover these)

# --- JSM (keep — CONFIRMED covering once routing fixed) ---
read:servicedesk-request            # JSM discovery/create-meta #58,61,62,64
write:servicedesk-request           # JSM create + attachments #63,66,67

# --- Assets/CMDB (keep — CONFIRMED covering once #64 routing fixed) ---
read:cmdb-object:jira               # AQL/object reads #68-71,74
read:cmdb-schema:jira               # schema reads #72-73

# --- Agile (ADD — granular MANDATORY, classic does NOT work, CONFIRMED) ---
read:board-scope:jira-software       # board list/config, sprint list #52,53,54
read:board-scope.admin:jira-software # board configuration #53 (jr board view config path)
read:sprint:jira-software            # sprint list/current/issues #54,55
write:board-scope:jira-software      # sprint add/remove #56,57
read:project:jira                    # required companion for board list/config #52,53
read:issue-details:jira              # sprint issues #55
read:jql:jira                        # sprint issues #55

# --- Refresh token (keep) ---
offline_access                       # refresh-token minting

# --- Teams (DEFER to S6 spike — DO NOT add in cycle-008 until console-addability + GraphQL routing confirmed) ---
# view:team:teams                    # teamSearchV2 (UNCERTAIN addable to Jira 3LO app; requires routing migration to api.atlassian.com/graphql first)
# view:membership:teams              # only if member data rendered
```

**Count:** 16 active scopes (well under Atlassian's ~50 recommended ceiling). Teams' 2 scopes are
commented out pending S6.

---

## (c) Endpoints that would STILL FAIL under OAuth after cycle-008's planned S1-S5 fixes

Assuming S1-S5 deliver the JSM/Assets/Teams routing fixes + Agile granular scopes:

1. **`jr component create` / `edit` / `delete` / `rename` (#41/#42/#44)** — **STILL BROKEN** unless
   `manage:jira-project` is added to the scope set. This is a **scope gap beyond Agile and beyond
   the bulk API**, and the highest-value new finding of this pass. It is NOT fixed by any routing
   change (routing is already OK) and NOT fixed by the Agile scopes. Must be folded into the scope
   expansion step. `jr component list` (#39) and delete's `relatedIssueCounts` safety check (#40)
   are read-only and work with `read:jira-work` — only the writes fail.

2. **`jr team list` / `jr init` team cache / points-team resolution (#75/#76)** — **STILL BROKEN**
   after S1-S5 if Teams is left to the S6 spike. #76 (public-teams REST) is *unfixable via scope*
   (OAuth apps are explicitly barred) and must migrate to GraphQL (`POST api.atlassian.com/graphql`,
   `teamSearchV2`); #75 needs both the GraphQL host migration AND `view:team:teams`, whose
   addability to a Jira 3LO app is UNCERTAIN and must be verified live in the Developer Console.

**Everything else** (platform CRUD incl. bulk, JSM, Assets, Agile) is fully covered by the
recommended scope set once the planned routing fixes land.

---

## (d) Recommendation on the bulk-API scopes

**Do NOT expand S2 for the bulk API. No action required.** The bulk endpoints are covered by the
classic `write:jira-work`/`read:jira-work` scopes `jr` already holds, are available to 3LO apps, and
carry only the "Connect apps cannot access" marker (which does not bar OAuth 2.0 apps). The
inventory's `#20-22` NEEDS-RESEARCH concern is resolved as a non-issue. `jr issue edit` (bulk) and
`jr issue move` (bulk) work under OAuth today.

**However, DO expand the scope step (S2) to add `manage:jira-project`** for component writes — this
is the real, newly-discovered scope gap that the bulk investigation surfaced adjacent to. Treat it
with the same priority as the Agile scope additions: without it, an entire documented command family
(`jr component create/edit/delete/rename`) is silently OAuth-broken.

---

## (e) Classic-vs-granular coexistence verdict

**CONFIRMED: classic and granular scopes coexist on one 3LO app with no forced migration.**

- Adding granular `*-software` (Agile) scopes does **not** cause `read:jira-work`/`write:jira-work`
  to stop satisfying platform REST v3 endpoints. There is no documented "once you add a granular
  scope, you must use granular everywhere" rule. Atlassian's guidance is the opposite: use classic
  scopes where available, granular only where classic cannot be used (Jira Software, Teams).
- Classic `read:jira-work` covers **all** platform read endpoints `jr` uses; `write:jira-work`
  covers all platform issue/link/worklog/attachment writes; `read:jira-user` covers all user
  endpoints — all CONFIRMED against the platform scope catalog.
- **The two classic-scope exceptions** are (1) **components** — a *different classic* scope
  (`manage:jira-project`), still not granular; and (2) **Jira Software** — granular-only. The
  2023-2024 six-endpoint deprecation did **not** strip `read:jira-work` from any platform endpoint
  `jr` calls (it changed granular *alternatives* for `mypermissions`, `permissions/check`,
  `relatedIssueCounts`, etc., but classic still works; the only granular-only member was
  `GET /rest/agile/1.0/board`, which is Jira Software).
- **Operational rule (CONFIRMED):** a new consent OVERRIDES the prior grant's scopes, so the
  authorization URL must always emit the **entire union** of `DEFAULT_OAUTH_SCOPES` (not just added
  scopes). Adding scopes in the Console + re-consent are required; existing tokens keep old scopes
  until re-auth (a refresh-token mint alone does NOT widen scope). This matches `jr`'s existing
  CLAUDE.md gotcha.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 2 | (1) Bulk-operations API scopes — the primary open question; (2) classic-vs-granular coexistence + full platform read/write scope audit |
| Perplexity perplexity_ask | 1 | Targeted confirmation of component create/delete scope (`manage:jira-project`) after WebFetch truncation |
| WebFetch | 1 | Attempted direct fetch of the project-components API reference (truncated — superseded by the perplexity_ask confirmation) |
| Context7 | 0 | N/A — Atlassian OAuth/scope docs are not a Context7-indexed library; official developer.atlassian.com pages via Perplexity were authoritative |
| Training data | 0 areas | No verdict rests on model knowledge; every claim sourced to developer.atlassian.com or flagged UNCERTAIN |

**Total MCP tool calls:** 4 (2 perplexity_research + 1 perplexity_ask + 1 WebFetch).
**Training data reliance:** low — all scope verdicts sourced to official Atlassian REST reference /
scope-catalog pages; the two UNCERTAIN items (Teams scope addability; exact Teams GraphQL scope
strings) are explicitly flagged for live Console/Explorer verification rather than filled from memory.

**Primary sources:**
- Issue bulk operations: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/
- Project components: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-components/
- Jira Platform scopes: https://developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/
- Jira Software scopes: https://developer.atlassian.com/cloud/jira/software/scopes-for-oauth-2-3LO-and-forge-apps/
- 6-endpoint deprecation: https://community.developer.atlassian.com/t/deprecation-notice-updated-oauth-2-0-scope-requirements-for-6-jira-cloud-rest-endpoints/75109
- Determining scopes: https://developer.atlassian.com/cloud/oauth/getting-started/determining-scopes/
- Making calls / grant override: https://developer.atlassian.com/cloud/oauth/getting-started/making-calls-to-api/
