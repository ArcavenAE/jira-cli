# Cycle-008 Research — Atlassian OAuth 2.0 (3LO) Endpoint Routing & Scopes for `jr`

**Date:** 2026-09-17
**Purpose:** Feed cycle-008 (fixing OAuth support for JSM / Teams / Assets / Agile).
**Auth model in scope:** OAuth 2.0 authorization-code grant (3LO) with tokens routed through the
`https://api.atlassian.com/ex/jira/{cloudId}/...` gateway (except where noted).
**Method:** Perplexity deep-research (sonar-deep-research) over official `developer.atlassian.com`
pages + Atlassian community, plus a direct WebFetch of the Teams GraphQL intro page. All claims
tagged CONFIRMED (official docs) / INFERRED (documented rule applied) / UNCERTAIN.

---

## Current granted token scope set (from live-confirmed token, per task background)

```
offline_access
read:cmdb-object:jira
read:cmdb-schema:jira
read:jira-user
read:jira-work
read:servicedesk-request
write:jira-work
write:servicedesk-request
```

**Live-confirmed working today:** platform (`/ex/jira/{cloudId}/rest/api/3/...`) and JSM
(`/ex/jira/{cloudId}/rest/servicedeskapi/servicedesk`).

---

## Q1 — JSM Service Desk REST API over 3LO

**VERDICT: YES** — the full `/rest/servicedeskapi/*` surface `jr` uses is served through the
`api.atlassian.com/ex/jira/{cloudId}` gateway, and the classic `read:servicedesk-request` /
`write:servicedesk-request` scopes (already granted) cover the request/servicedesk/requesttype/
attachment operations. **One path correction and one scope nuance below.**

3LO base for all JSM calls (CONFIRMED):
```
https://api.atlassian.com/ex/jira/{cloudId}/rest/servicedeskapi/{resource}
```
(Endpoint reference shows the tenant-host `your-domain.atlassian.net` form; the 3LO intro doc
mandates the `/ex/jira/{cloudId}` gateway form. — CONFIRMED)

| Endpoint | Gateway? | Classic scope | Status |
|---|---|---|---|
| `POST /rest/servicedeskapi/request` (create) | Yes | `write:servicedesk-request` | CONFIRMED |
| `GET /rest/servicedeskapi/servicedesk` | Yes | `read:servicedesk-request` | CONFIRMED (live) |
| `GET /rest/servicedeskapi/servicedesk/{id}/requesttype` | Yes | `read:servicedesk-request` | CONFIRMED |
| `GET .../requesttype/{id}/field` | Yes | `read:servicedesk-request` | **PATH FLAG — see below** |
| `GET /rest/servicedeskapi/servicedesk/{id}/queue` | Yes | `read:jira-work` | CONFIRMED — **scope nuance** |
| `GET .../servicedesk/{id}/queue/{qid}/issue` | Yes | `read:jira-work` | CONFIRMED — **scope nuance** |
| `POST .../servicedesk/{id}/attachTemporaryFile` | Yes | `write:servicedesk-request` | CONFIRMED |
| `POST /rest/servicedeskapi/request/{id}/attachment` | Yes | `write:servicedesk-request` | CONFIRMED |

**PATH FLAG (request-type fields):** The deep-research pass reported the *documented* request-type-
field endpoint as the service-desk-scoped form
`GET /rest/servicedeskapi/servicedesk/{serviceDeskId}/requesttype/{requestTypeId}/field`, and flagged
a bare `/rest/servicedeskapi/requesttype/{id}/field` as "not the documented endpoint." **UNCERTAIN /
ACTION:** verify against `jr`'s actual call in `src/api/jsm/request_types.rs` — Atlassian's REST
reference does list a top-level `GET /rest/servicedeskapi/requesttype` group, so a bare form may
exist. Confirm the exact path `jr` sends before treating this as a bug. Both forms take
`read:servicedesk-request` regardless.

**SCOPE NUANCE (queues):** Queue read operations
(`/servicedesk/{id}/queue` and `.../queue/{qid}/issue`) document the **classic `read:jira-work`**
scope (NOT `read:servicedesk-request`), plus the acting user must be a JSM **agent** on that service
desk. `jr` already holds `read:jira-work`, so no scope change is needed — but if queue calls ever
401 with "scope does not match," `read:jira-work` presence (not `read:servicedesk-request`) is the
thing to check. `manage:servicedesk-customer` is **NOT** required for queues (that scope is only for
customer/organization management). — CONFIRMED

**Endpoints NOT on 3LO:** No current `servicedeskapi` operation in `jr`'s list is marked unavailable
to OAuth 2.0. The Atlassian-wide "unavailable to apps" marker is the literal warning *"Apps can't
access this REST resource"*; a *"Connect apps cannot access this REST resource"* warning does NOT bar
3LO (several JSM ops, incl. Assets workspace, carry the Connect-only marker yet expose OAuth scopes).
Historically `info`, `knowledgebase/article`, and the top-level all-request-types endpoint lacked
3LO; that gap (JSDCLOUD-9298) is now resolved Fixed. `GET /rest/servicedeskapi/info` is anonymous
(no scope listed). — CONFIRMED

**Sources:** developer.atlassian.com/cloud/jira/service-desk/rest/intro/,
.../rest/api-group-servicedesk/, .../rest/api-group-request/, .../rest/api-group-requesttype/,
.../scopes-for-oauth-2-3LO-and-forge-apps/, developer.atlassian.com/cloud/oauth/getting-started/determining-scopes/,
jira.atlassian.com/browse/JSDCLOUD-9298

---

## Q2 — Assets / CMDB over 3LO

**VERDICT: YES (both routings CONFIRMED)** — `jr`'s current scopes (`read:cmdb-object:jira`,
`read:cmdb-schema:jira`, `read:servicedesk-request`) are sufficient for workspace discovery + AQL +
schema reads. **Note the two DIFFERENT hosts/bases — Assets is split across two paths.**

**(a) Workspace-ID discovery** (INFERRED from documented 3LO rule; endpoint itself CONFIRMED):
```
GET https://api.atlassian.com/ex/jira/{cloudId}/rest/servicedeskapi/assets/workspace
Scope: read:servicedesk-request
```
The endpoint path `/rest/servicedeskapi/assets/workspace` is documented and requires
`read:servicedesk-request`; the reference prints the tenant-host form, and the 3LO routing rule
places JSM paths after `/ex/jira/{cloudId}`. `jr` currently calls `/rest/servicedeskapi/assets/workspace`
— **ACTION: confirm `jr` prepends the `/ex/jira/{cloudId}` gateway prefix** (it should, since platform
+ JSM calls already work). — CONFIRMED endpoint + scope / INFERRED full 3LO URL

**(b) AQL object queries** (CONFIRMED — full 3LO URL is documented, incl. the `/ex/jira/{cloudId}`
prefix, on the Assets object API reference):
```
POST https://api.atlassian.com/ex/jira/{cloudId}/jsm/assets/workspace/{workspaceId}/v1/object/aql
Body: { "qlQuery": "<AQL>" }
Scope: read:cmdb-object:jira
```
IMPORTANT ROUTING FACT: the AQL/object path is served under **`/jsm/assets/...` (NOT
`/rest/servicedeskapi/...`)**, but for 3LO it STILL sits behind the `/ex/jira/{cloudId}` gateway
prefix. So the historical "separate host `https://api.atlassian.com/jsm/assets/workspace/{wsId}/v1/...`"
(without `/ex/jira/{cloudId}`) is **NOT** the documented 3LO URL — the gateway prefix is required for
OAuth apps. Also avoid the deprecated `GET /aql/objects`; use `POST /object/aql`. — CONFIRMED

**Scopes (CONFIRMED, operation-specific — no single "Assets read" scope):**
- Workspace discovery → `read:servicedesk-request`
- AQL / ordinary object reads → `read:cmdb-object:jira`
- Schema list / get → `read:cmdb-schema:jira`
- (Other Assets ops may additionally need `read:cmdb-type:jira` / `read:cmdb-attribute:jira` — check
  per operation if `jr` expands Assets coverage.)

`jr` already holds all three needed scopes. **Gap to verify is routing, not scopes.**

**Sources:** developer.atlassian.com/cloud/jira/service-desk/rest/api-group-assets/,
developer.atlassian.com/cloud/assets/rest/api-group-object/,
developer.atlassian.com/cloud/assets/assets-rest-api-guide/scopes-for-oauth-2-3LO-and-forge-apps/,
developer.atlassian.com/cloud/assets/rest/api-group-objectschema/,
developer.atlassian.com/cloud/oauth/getting-started/making-calls-to-api/

---

## Q3 — Agile REST API over 3LO — **THE PRIMARY GAP**

**VERDICT: `read:jira-work` is NOT sufficient. Granular `jira-software` scopes are MANDATORY.**
This is the root cause of the live "scope does not match" 401 — `jr`'s token lacks every Agile scope.

CONFIRMED (official): **"Jira Software doesn't support classic scopes. Use granular scopes instead."**
The `/ex/jira/{cloudId}` gateway routing is correct (as the live test showed); the failure is purely
missing scopes.

3LO base (CONFIRMED, routing already correct in `jr`):
```
https://api.atlassian.com/ex/jira/{cloudId}/rest/agile/1.0/...
```

| Endpoint | Required granular scopes (CONFIRMED per operation) |
|---|---|
| `GET /rest/agile/1.0/board` | `read:board-scope:jira-software` + `read:project:jira` |
| `GET /rest/agile/1.0/board/{id}/configuration` | `read:board-scope.admin:jira-software` + `read:project:jira` |
| `GET /rest/agile/1.0/board/{id}/sprint` | `read:sprint:jira-software` |
| `GET /rest/agile/1.0/sprint/{id}/issue` | `read:sprint:jira-software` + `read:issue-details:jira` + `read:jql:jira` |
| `/rest/agile/1.0/backlog/issue` | **PATH FLAG — see below** |

**Minimal read-only scope set for board list + sprint list + sprint issues (CONFIRMED union):**
```
read:board-scope:jira-software
read:project:jira
read:sprint:jira-software
read:issue-details:jira
read:jql:jira
```
Add for board **configuration** (`jr board view` config path):
```
read:board-scope.admin:jira-software
```

**PATH FLAG (`backlog/issue`):** Deep research found **no documented `GET /rest/agile/1.0/backlog/issue`**.
That path is documented only as `POST /rest/agile/1.0/backlog/issue` (move issues to backlog,
`write:board-scope:jira-software`). The documented backlog *read* is
`GET /rest/agile/1.0/board/{boardId}/backlog` (deprecated) or its replacement
`GET /rest/software/1.0/board/{boardId}/backlog`, both needing
`read:board-scope:jira-software` + `read:issue-details:jira`. **ACTION:** verify what `jr` actually
calls for backlog and align the endpoint (and, if it does a POST-to-backlog write, it would also need
`write:board-scope:jira-software`).

**Note on scope-count discipline:** these granular scopes are all confirmed on candidate list.
Of the four candidates in the task, `read:board-scope:jira-software`, `read:sprint:jira-software`,
and `read:issue-details:jira` are confirmed required; `read:jira-work` is confirmed NOT usable for
Agile. Additionally `read:project:jira` and `read:jql:jira` are required and were not in the original
candidate list — do not omit them.

**Sources:** developer.atlassian.com/cloud/jira/software/scopes-for-oauth-2-3LO-and-forge-apps/,
developer.atlassian.com/cloud/jira/software/rest/api-group-board/, .../api-group-sprint/,
.../api-group-backlog/, .../api-group-issue/, developer.atlassian.com/cloud/jira/software/oauth-2-3lo-apps/,
community.developer.atlassian.com/t/deprecation-notice-updated-oauth-2-0-scope-requirements-for-6-jira-cloud-rest-endpoints/75109

---

## Q4 — Teams over 3LO — **HIGHEST UNCERTAINTY; `jr`'s current approach is WRONG for OAuth**

**VERDICT (split): Teams GraphQL over 3LO = YES (now officially supported).
Teams Public REST over 3LO = NO (explicitly prohibited). `jr`'s current hosts are both wrong for OAuth.**

`jr` today uses `POST /gateway/api/graphql` and `GET /gateway/api/public/teams/v1/org/{orgId}/teams`.
Neither is the correct OAuth path:

**(a) GraphQL team listing — SUPPORTED via a DIFFERENT host (CONFIRMED via direct WebFetch of the
official Teams GraphQL intro page, updated Sept 2026):**
```
POST https://api.atlassian.com/graphql          <-- OAuth clients use THIS host
```
The page states verbatim: *"OAuth clients use https://api.atlassian.com/graphql."* and *"The API
authorizes access at the field level ... The required OAuth scopes and lifecycle status are shown in
each field's description in the GraphQL explorer."* Team discovery uses the `teamSearchV2` query.
- Do **NOT** send an OAuth bearer token to `https://{site}.atlassian.net/gateway/api/graphql` — that
  route is documented for browser sessions / API-token (Basic) auth, not OAuth clients. `jr`'s current
  `/gateway/api/graphql` usage is therefore the wrong endpoint for a 3LO token.
- **Scopes:** field-level; official guidance is to read the required scope off each field in the
  GraphQL Explorer. Historically confirmed strings: `view:team:teams` (team search) and
  `view:membership:teams` (members); member identity fields have additionally required
  `identity:atlassian-external`. A Jira-only token (like `jr`'s current set) CANNOT list teams —
  it will 401 "scope does not match" on the Teams fields. — CONFIRMED that OAuth is supported;
  UNCERTAIN on the exact minimal scope string set (verify live via the GraphQL Explorer for the exact
  fields `jr` selects; treat `view:team:teams` as the primary candidate to add).

**(b) Teams Public REST (`.../public/teams/v1/org/{orgId}/teams`) — NOT available to 3LO
(CONFIRMED):** The operation reference states unambiguously *"Forge and OAuth2 apps cannot access this
REST resource."* No OAuth scope makes it reachable. (It is intended for Atlassian-account
API-token / Basic auth against the site gateway — a personal API token, distinct from the
org-admin API key.) `jr`'s `GET /gateway/api/public/teams/...` call will never work with a 3LO
token. Also the URL form `.../gateway/api/public/teams/...` is a non-documented hybrid; the reference
shows `https://api.atlassian.com/public/teams/v1/org/{orgId}/teams` (no `/gateway/api`) — but again,
not for OAuth.

**Recommendation for cycle-008:** migrate `jr`'s team listing from the REST public-teams endpoint +
`/gateway/api/graphql` to **`POST https://api.atlassian.com/graphql` with `teamSearchV2`**, and add
the Teams scope(s) (`view:team:teams`, plus `view:membership:teams` if member data is rendered).
An org-admin API key is NOT required for the GraphQL path — access follows the represented user's
permissions. Confirm the exact scope strings via the GraphQL Explorer before pinning them.

**CAVEAT / conflicting evidence:** Older (pre-2026) community threads report developers being UNABLE
to add `view:team:teams` to Jira 3LO apps and Atlassian staff stating Teams was not 3LO-accessible.
The official Teams docs were updated 2026-09-09..15 to explicitly document OAuth clients, which
supersedes those threads — but because this is a recent change and the exact addable-scope list in
the Developer Console for a Jira app is the unverified piece, **treat "can I actually add
`view:team:teams` to this specific app in the console" as a live verification step**, not a settled
fact.

**Sources:** developer.atlassian.com/platform/teams/teams-graphql-api/introduction/ (WebFetch,
verbatim quote), .../teams-graphql-api/using-team-query/,
developer.atlassian.com/platform/teams/rest/v1/api-group-teams-public-api/ (the "OAuth2 apps cannot
access" statement), developer.atlassian.com/platform/atlassian-graphql-api/graphql/,
community.developer.atlassian.com/t/how-to-add-teams-scopes-for-graphql-query/80920 (historical
`view:team:teams`), community.developer.atlassian.com/t/rest-api-call-for-fetching-teams/79521

---

## Q5 — Changing `DEFAULT_OAUTH_SCOPES` (operational requirements)

**VERDICT: YES on both operational requirements. Classic + granular scopes CAN coexist on one app.**

1. **Console update required (CONFIRMED):** New scopes must be added to the app at
   `https://developer.atlassian.com/console/myapps` → Permissions → Configure → Add, per API. An
   authorization request may only request scopes already added to the app's APIs in the console.

2. **Re-consent required; old tokens keep old scopes (CONFIRMED):** Official wording — *"users who
   previously consented to the scopes will need to re-consent to the new scopes."* Adding scopes in
   the console does not expand existing grants. The refresh-token exchange has **no `scope` parameter**
   and cannot widen a grant — new scopes require a fresh authorization-code flow with
   `prompt=consent`. Existing access/refresh tokens continue to work with their OLD scopes until the
   user re-authorizes. This matches `jr`'s CLAUDE.md gotcha ("existing access tokens continue working
   with old scopes until expiry; new logins and refresh-token mints trigger re-consent") — CONFIRMED,
   with one refinement: a *refresh-token mint* alone does NOT add new scopes; only a full re-auth does.

3. **CRITICAL GOTCHA — full-union re-authorization (CONFIRMED):** Atlassian keeps ONE grant per app
   per Atlassian account, and **a new consent OVERRIDES the previous grant's scopes**. The new
   authorization URL must request the **entire intended union** of scopes (old + new), not just the
   added ones — otherwise previously granted scopes are dropped. For `jr` this means the
   authorization URL builder must always emit the full `DEFAULT_OAUTH_SCOPES` set. Include
   `offline_access` again to keep getting a refresh token.

4. **Classic + granular coexistence (CONFIRMED):** No app-wide either/or requirement. Atlassian
   recommends classic scopes where they cover an endpoint and granular scopes only where classic
   can't be used; an app may hold both. Guidance: keep total under ~50 scopes; drop redundant granular
   scopes where a classic scope already covers the endpoint. The one hard rule: **Jira Software
   endpoints do not accept classic scopes** (Q3), so `jr` must carry the granular `jira-software`
   scopes alongside its classic `read:jira-work`/`read:servicedesk-request` — that mix is expected and
   allowed.

**Applied recommendation for `jr`'s new `DEFAULT_OAUTH_SCOPES`** (union of current + cycle-008 gaps):
```
# existing (keep)
offline_access
read:jira-user
read:jira-work
write:jira-work
read:servicedesk-request
write:servicedesk-request
read:cmdb-object:jira
read:cmdb-schema:jira
# add for Agile (Q3)
read:board-scope:jira-software
read:board-scope.admin:jira-software   # only if board config is used
read:sprint:jira-software
read:issue-details:jira
read:jql:jira
read:project:jira
# add for Teams GraphQL (Q4 — verify exact strings in GraphQL Explorer)
view:team:teams
view:membership:teams                  # only if member data is rendered
```
Per CLAUDE.md's own gotcha: when changing `DEFAULT_OAUTH_SCOPES`, update the embedded `jr` OAuth
app's permissions in the Developer Console before tagging, and add a CHANGELOG note about the
re-consent prompt.

**Sources:** developer.atlassian.com/cloud/oauth/getting-started/implementing-oauth-3lo/,
.../managing-oauth-apps/, .../refresh-tokens/, .../faq/, .../determining-scopes/,
developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/,
developer.atlassian.com/cloud/jira/software/scopes-for-oauth-2-3LO-and-forge-apps/

---

## Summary verdict table

| Q | Topic | Verdict | Key action for cycle-008 |
|---|---|---|---|
| 1 | JSM servicedeskapi over 3LO | YES — works; scopes already held | Verify requesttype-field path shape; note queues need `read:jira-work` (held), not `manage:servicedesk-customer` |
| 2 | Assets/CMDB over 3LO | YES — scopes already held | Verify routing: workspace via `/ex/jira/{cloudId}/rest/servicedeskapi/assets/workspace`; AQL via `/ex/jira/{cloudId}/jsm/assets/.../v1/object/aql` |
| 3 | Agile over 3LO | NO on classic — granular MANDATORY | Add `read:board-scope:jira-software`, `read:sprint:jira-software`, `read:issue-details:jira`, `read:jql:jira`, `read:project:jira` (+`read:board-scope.admin:jira-software` for board config); verify `backlog/issue` path |
| 4 | Teams over 3LO | GraphQL YES / REST NO | Move off `/gateway/api/graphql` + public-teams REST → `POST https://api.atlassian.com/graphql` (`teamSearchV2`); add `view:team:teams`; verify exact scopes in Explorer |
| 5 | Scope change ops | YES re-consent; classic+granular coexist | Emit full scope union in auth URL (new grant overrides old); update Console app + CHANGELOG |

## Confidence classification
- **CONFIRMED (official docs):** Q1 gateway routing + scopes; Q2 both routings + scopes; Q3 granular-
  mandatory + full scope union; Q4 GraphQL-OAuth-supported host + REST-3LO-prohibited; Q5 all four
  operational points.
- **INFERRED (documented rule applied, not shown as one literal example):** Q2(a) full workspace 3LO
  URL; Q1 full JSM 3LO URLs (reference shows tenant host).
- **UNCERTAIN / verify live before pinning:** exact minimal Teams GraphQL scope strings (Q4);
  whether `view:team:teams` is addable to this specific Jira app in the Console (Q4); exact
  request-type-field path `jr` sends (Q1); exact `backlog` endpoint `jr` calls (Q3); that `jr`'s
  Assets/workspace call already prepends `/ex/jira/{cloudId}` (Q2).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 4 | Agile scopes; Assets/CMDB 3LO routing+scopes; Teams 3LO (GraphQL+REST); JSM servicedeskapi surface+scopes; scope-change/re-consent ops (bundled into the 4 deep calls) |
| WebFetch | 1 | Verified verbatim OAuth-support statement + host on the official Teams GraphQL intro page |
| Context7 | 0 | Not used — Atlassian OAuth/scope docs are not a Context7-indexed library; `developer.atlassian.com` official pages via Perplexity/WebFetch were authoritative |
| Training data | 0 areas | No claim rests on model knowledge alone; every verdict is sourced to developer.atlassian.com or Atlassian community |

**Total MCP tool calls:** 5 (4 perplexity_research + 1 WebFetch).
**Training data reliance:** low — all verdicts sourced to official Atlassian docs; items not found in
docs are explicitly flagged UNCERTAIN rather than filled from memory.
