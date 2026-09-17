# OAuth Endpoint Inventory — `jr` CLI (cycle-008 decision support)

**Purpose:** Exhaustive, code-grounded inventory of every HTTP endpoint `jr` calls, with
base-URL routing, read/write classification, and per-endpoint OAuth-impact verdict. This
exists so cycle-008 can make OAuth surface-correctness decisions from *certainty*, not from
the subset of commands already tested.

**Method:** Full scan of `src/api/client.rs`, `src/api/auth.rs`, `src/api/pagination.rs`,
`src/api/rate_limit.rs`, `src/api/refresh_coordinator.rs`, `src/api/jira/*`, `src/api/jsm/*`,
`src/api/assets/*`, plus endpoint construction / command tracing in `src/cli/`. Every call
that issues an HTTP request is captured (all `get`/`post`/`put`/`delete` helpers, the
`*_instance` variants, `get_assets`/`post_assets`, raw `reqwest_client()` multipart/stream
sites, `send_raw`, and the direct `reqwest::Client` calls in `auth.rs` and `tenant.rs`).

Analysis is grounded in code as of this scan; nothing here is inferred from training data
except the external Atlassian scope facts, which are cited inline in the summary.

---

## Routing primitives (verified in `src/api/client.rs`)

| Helper | URL composed | Target | OAuth verdict for routing |
|---|---|---|---|
| `get` / `post` / `put` / `put_json` / `post_no_content` / `delete` / `get_bounded` / `get_raw_response` / `request` / `send_raw` | `{base_url}{path}` | `base_url` = `config.base_url()` → OAuth gateway `https://api.atlassian.com/ex/jira/{cloudId}` for OAuth profiles | **OAuth-correct** |
| `get_from_instance` / `post_to_instance` | `{instance_url}{path}` | `instance_url` = site `https://<site>.atlassian.net` (always the raw site, even under OAuth — client.rs:1066) | **OAuth-BROKEN** |
| `get_assets` / `post_assets` | `{assets_base_url}/workspace/{wid}/v1/{path}` | `assets_base_url` = `https://api.atlassian.com/ex/jira/{cloudId}/jsm/assets` (client.rs:95-100) | **OAuth-correct** (gateway-prefixed — verified; both `/ex/jira/{cloudId}/jsm/assets/...` and `/jsm/assets/...` are documented-valid OAuth bases) |
| `reqwest_client()` + `base_url()` (multipart/JSON, attachments) | `{base_url()}{path}` composed manually | gateway | **OAuth-correct** |
| direct `reqwest::Client` in `auth.rs` | absolute `auth.atlassian.com` / `api.atlassian.com/oauth` URLs | OAuth IdP | **OAuth-correct** (this *is* the OAuth flow) |
| direct `reqwest::Client` in `tenant.rs` | `{site}/_edge/tenant_info` | raw site, **no bearer** | **N/A — unauthenticated, pre-auth by design** |

**`DEFAULT_OAUTH_SCOPES` (verified verbatim, `auth.rs:83-88`):**
```
read:jira-work write:jira-work read:jira-user
read:servicedesk-request write:servicedesk-request
read:cmdb-object:jira read:cmdb-schema:jira
offline_access
```
Matches the set stated in the task exactly. No `*-software` (Agile) scopes; no `read:project:jira`;
no bulk-API granular scopes; no teams/graphql scope.

---

## Family 1 — Platform `/rest/api/3` (base_url gateway; routing OK)

| # | Method + path | Helper | Command(s) | R/W | Scope | Verdict |
|---|---|---|---|---|---|---|
| 1 | POST /rest/api/3/search/jql | post | issue list / view resolution / edit --jql / sprint filters | READ | read:jira-work | OK |
| 2 | POST /rest/api/3/search/approximate-count | post | issue list (count) | READ | read:jira-work | OK |
| 3 | GET /rest/api/3/issue/{key}?fields=… | get | issue view/edit/move/comment/etc. | READ | read:jira-work | OK |
| 4 | GET /rest/api/3/issue/{key}?fields=project | get | project resolution for issue ops | READ | read:jira-work | OK |
| 5 | POST /rest/api/3/issue | post | issue create (platform path) | WRITE | write:jira-work | OK |
| 6 | PUT /rest/api/3/issue/{key} | put | issue edit (fields/labels/type), single-key | WRITE | write:jira-work | OK |
| 7 | GET /rest/api/3/issue/{key}/editmeta | get | issue edit --field | READ | read:jira-work | OK |
| 8 | GET /rest/api/3/issue/{key}/transitions | get | issue transitions / move | READ | read:jira-work | OK |
| 9 | GET /rest/api/3/issue/{key}/transitions?expand=transitions.fields | get | issue move (resolution enforcement, ADR-0015) | READ | read:jira-work | OK |
| 10 | POST /rest/api/3/issue/{key}/transitions | post_no_content | issue move | WRITE | write:jira-work | OK |
| 11 | PUT /rest/api/3/issue/{key}/assignee | put | issue assign | WRITE | write:jira-work | OK |
| 12 | POST /rest/api/3/issue/{key}/comment | post | issue comment add | WRITE | write:jira-work | OK |
| 13 | DELETE /rest/api/3/issue/{key}/comment/{id} | delete | issue comment delete | WRITE | write:jira-work | OK |
| 14 | PUT /rest/api/3/issue/{key}/comment/{id} | put | issue comment edit (+visibility merge) | WRITE | write:jira-work | OK |
| 15 | GET /rest/api/3/issue/{key}/comment/{id}?expand=properties | get | issue comment view | READ | read:jira-work | OK |
| 16 | GET /rest/api/3/issue/{key}/changelog | get | issue changelog | READ | read:jira-work | OK |
| 17 | GET /rest/api/3/issue/{key}/comment | get | issue comments list | READ | read:jira-work | OK |
| 18 | GET /rest/api/3/issue/createmeta/{proj}/issuetypes | get | issue create/edit --field / --type | READ | read:jira-work | OK |
| 19 | GET /rest/api/3/issue/createmeta/{proj}/issuetypes/{itid} | get | issue create --field createmeta resolve | READ | read:jira-work | OK |
| 20 | POST /rest/api/3/bulk/issues/fields | post | issue edit (bulk fields/labels/type) | WRITE | write:jira-work? | **NEEDS-RESEARCH** (new bulk API) |
| 21 | POST /rest/api/3/bulk/issues/transition | post | issue move (bulk) | WRITE | write:jira-work? | **NEEDS-RESEARCH** (new bulk API) |
| 22 | GET /rest/api/3/bulk/queue/{taskId} | get / get_bounded | bulk task poll (edit/move bulk) | READ | read:jira-work? | **NEEDS-RESEARCH** (new bulk API) |
| 23 | POST /rest/api/3/issueLink | post_no_content | issue link | WRITE | write:jira-work | OK |
| 24 | DELETE /rest/api/3/issueLink/{id} | delete | issue unlink | WRITE | write:jira-work | OK |
| 25 | GET /rest/api/3/issueLinkType | get | issue link-types | READ | read:jira-work | OK |
| 26 | POST /rest/api/3/issue/{key}/remotelink | post | issue remote-link | WRITE | write:jira-work | OK |
| 27 | GET /rest/api/3/myself | get | user (self), e2e, mention self-target | READ | read:jira-user | OK |
| 28 | GET /rest/api/3/user/search | get | user search/list | READ | read:jira-user | OK |
| 29 | GET /rest/api/3/user/assignable/search | get | issue assign (single project) | READ | read:jira-user | OK |
| 30 | GET /rest/api/3/user/assignable/multiProjectSearch | get | assignable users (multi-project) | READ | read:jira-user | OK |
| 31 | GET /rest/api/3/user?accountId={id} | get | user view, mention bracket-form validation | READ | read:jira-user | OK |
| 32 | GET /rest/api/3/field | get | field discovery / story-points+CMDB field / project fields | READ | read:jira-work | OK |
| 33 | GET /rest/api/3/status | get | statuses (project fields) | READ | read:jira-work | OK |
| 34 | GET /rest/api/3/priority | get | project fields (priorities) | READ | read:jira-work | OK |
| 35 | GET /rest/api/3/resolution | get | issue resolutions / move enforcement | READ | read:jira-work | OK |
| 36 | GET /rest/api/3/project/{key} | get | project details / JSM project-meta / issue create | READ | read:jira-work | OK |
| 37 | GET /rest/api/3/project/{key}/statuses | get | project fields (statuses) | READ | read:jira-work | OK |
| 38 | GET /rest/api/3/project/search | get | project list | READ | read:jira-work | OK |
| 39 | GET /rest/api/3/project/{key}/components | get | component list | READ | read:jira-work | OK |
| 40 | GET /rest/api/3/component/{id}/relatedIssueCounts | get | component delete (disposition safety) | READ | read:jira-work | OK |
| 41 | POST /rest/api/3/component | post | component create | WRITE | write:jira-work | OK |
| 42 | PUT /rest/api/3/component/{id} | put_json | component edit/rename | WRITE | write:jira-work | OK |
| 43 | GET /rest/api/3/component/{id} | get | component get (edit/delete resolve) | READ | read:jira-work | OK |
| 44 | DELETE /rest/api/3/component/{id}[?moveIssuesTo=…] | delete | component delete | WRITE | write:jira-work | OK |
| 45 | POST /rest/api/3/issue/{key}/worklog | post | worklog add | WRITE | write:jira-work | OK |
| 46 | GET /rest/api/3/issue/{key}/worklog | get | worklog list | READ | read:jira-work | OK |
| 47 | GET /rest/api/3/issue/{key}?fields=attachment | get | attachment list | READ | read:jira-work | OK |
| 48 | GET /rest/api/3/attachment/{id} | get | attachment metadata (download/delete gate) | READ | read:jira-work | OK |
| 49 | POST /rest/api/3/issue/{key}/attachments | reqwest_client()+base_url() multipart | attachment upload (platform) | WRITE | write:jira-work | OK (routing) |
| 50 | DELETE /rest/api/3/attachment/{id} | delete | attachment delete (targeted + bulk) | WRITE | write:jira-work | OK |
| 51 | GET /rest/api/3/attachment/content/{id} | get_raw_response (stream) | attachment download | READ | read:jira-work | OK |

Platform verdict: all routing OK; scope OK for classic read:/write:jira-work / read:jira-user
**except** the three new-bulk-API endpoints (#20-22) — see NEEDS-RESEARCH.

---

## Family 2 — Agile `/rest/agile/1.0` (base_url gateway; routing OK, **SCOPE-GAP**)

| # | Method + path | Helper | Command(s) | R/W | Scope needed | Verdict |
|---|---|---|---|---|---|---|
| 52 | GET /rest/agile/1.0/board | get | board list | READ | read:board-scope:jira-software (+ read:project:jira) | **SCOPE-GAP** |
| 53 | GET /rest/agile/1.0/board/{id}/configuration | get | board view | READ | read:board-scope:jira-software | **SCOPE-GAP** |
| 54 | GET /rest/agile/1.0/board/{id}/sprint | get | sprint list / current | READ | read:sprint:jira-software / read:board-scope:jira-software | **SCOPE-GAP** |
| 55 | GET /rest/agile/1.0/sprint/{id}/issue | get | sprint current / view | READ | read:sprint:jira-software / read:board-scope:jira-software | **SCOPE-GAP** |
| 56 | POST /rest/agile/1.0/sprint/{sprintId}/issue | post_no_content | **sprint add** | WRITE | write:board-scope:jira-software | **SCOPE-GAP** |
| 57 | POST /rest/agile/1.0/backlog/issue | post_no_content | **sprint remove** | WRITE | write:board-scope:jira-software | **SCOPE-GAP** |

Routing is correct (gateway); the gap is purely missing granular `*-software` scopes in
`DEFAULT_OAUTH_SCOPES`. Classic `read:jira-work`/`write:jira-work` are **not** documented as
covering these endpoints (Atlassian's Jira Software scope pages list only granular scopes;
plus the historical "OAuth 2.0 is not enabled for this method" class of failures on agile).

---

## Family 3 — JSM `servicedeskapi` (MIXED base — the core cycle-008 finding)

| # | Method + path | Helper | Command(s) | R/W | Scope | Verdict |
|---|---|---|---|---|---|---|
| 58 | GET /rest/servicedeskapi/servicedesk | get_from_instance | queue/requesttype/JSM-create service-desk resolution | READ | read:servicedesk-request | **BROKEN-ROUTING** |
| 59 | GET /rest/servicedeskapi/servicedesk/{sid}/queue | get_from_instance | queue list/view | READ | read:servicedesk-request | **BROKEN-ROUTING** |
| 60 | GET /rest/servicedeskapi/servicedesk/{sid}/queue/{qid}/issue | get_from_instance | queue view | READ | read:servicedesk-request | **BROKEN-ROUTING** |
| 61 | GET /rest/servicedeskapi/servicedesk/{sid}/requesttype | get_from_instance | requesttype list / field / JSM create | READ | read:servicedesk-request | **BROKEN-ROUTING** |
| 62 | GET /rest/servicedeskapi/servicedesk/{sid}/requesttype/{rtId}/field | get_from_instance | requesttype fields / field options / JSM create ADF | READ | read:servicedesk-request | **BROKEN-ROUTING** |
| 63 | POST /rest/servicedeskapi/request | post_to_instance | **issue create --request-type** (JSM) | WRITE | write:servicedesk-request | **BROKEN-ROUTING** |
| 64 | GET /rest/servicedeskapi/assets/workspace | get_from_instance | Assets workspace-ID discovery (**prereq for ALL assets ops**) | READ | read:servicedesk-request | **BROKEN-ROUTING** |
| 65 | GET /rest/api/3/project/{key} (JSM project-meta) | get | JSM create project-type gate | READ | read:jira-work | OK (uses `get` → gateway) |
| 66 | POST /rest/servicedeskapi/servicedesk/{sid}/attachTemporaryFile | reqwest_client()+**base_url()** multipart | attachment upload (JSM `--public`/`--internal`) | WRITE | write:servicedesk-request | **OK (routing)** |
| 67 | POST /rest/servicedeskapi/request/{key}/attachment | reqwest_client()+**base_url()** JSON | attachment upload (JSM step 2) | WRITE | write:servicedesk-request | **OK (routing)** |

**Critical asymmetry within the JSM family:** every discovery/create call (58-64) uses
`*_instance` → site URL (BROKEN under OAuth), but the two JSM *attachment* calls (66-67)
were built with `reqwest_client()+base_url()` → gateway (OK). Result: under OAuth,
`jr issue attachment upload --public` on a JSM issue can route correctly while
`jr issue create --request-type` cannot — an inconsistency worth reconciling.

---

## Family 4 — Assets / CMDB (assets_base_url = gateway `/ex/jira/{cloudId}/jsm/assets`; routing OK)

| # | Method + path | Helper | Command(s) | R/W | Scope | Verdict |
|---|---|---|---|---|---|---|
| 68 | POST …/v1/object/aql | post_assets | assets search; issue list `--component`; issue create/edit `:asset` field | READ | read:cmdb-object:jira | OK* |
| 69 | GET …/v1/object/{id}?includeAttributes= | get_assets | asset view / resolve key | READ | read:cmdb-object:jira | OK* |
| 70 | GET …/v1/object/{id}/attributes | get_assets | asset view attributes | READ | read:cmdb-object:jira | OK* |
| 71 | GET …/v1/objecttype/{id}/attributes | get_assets | schema attribute discovery | READ | read:cmdb-object:jira | OK* |
| 72 | GET …/v1/objectschema/list | get_assets | assets schemas | READ | read:cmdb-schema:jira | OK* |
| 73 | GET …/v1/objectschema/{id}/objecttypes/flat | get_assets | assets types | READ | read:cmdb-schema:jira | OK* |
| 74 | GET …/v1/objectconnectedtickets/{id}/tickets | get_assets | assets tickets (connected) | READ | read:cmdb-object:jira | OK* |

`*` The Assets object/schema calls are individually gateway-routed and their scopes ARE in
the default set. **However every one is gated behind the workspace-ID discovery step (#64),
which is BROKEN-ROUTING.** Net effect: the entire `jr assets *` surface (and the
`issue list --component`/`--field :asset` asset paths) is OAuth-broken in practice — not
because of the AQL calls, but because the mandatory prerequisite is sent to the site URL.
This directly answers the task's assets question: the AQL path *does* carry the
`/ex/jira/{cloudId}` prefix and is NOT itself a broken-routing site; its prerequisite is.

---

## Family 5 — Teams / GraphQL `/gateway/*` (instance_url; **BROKEN-ROUTING**)

| # | Method + path | Helper | Command(s) | R/W | Scope | Verdict |
|---|---|---|---|---|---|---|
| 75 | POST /gateway/api/graphql | post_to_instance | team list, init, points/team resolution (org metadata: cloudId+orgId) | READ | none in default set (GraphQL org API) | **BROKEN-ROUTING** (+ scope-unavailable) |
| 76 | GET /gateway/api/public/teams/v1/org/{orgId}/teams | get_from_instance | team list, init | READ | none in default set (Teams public API) | **BROKEN-ROUTING** (+ scope-unavailable) |

Teams is *doubly* broken: wrong base **and** no covering scope in the default set even if
re-routed. Needs its own scope decision if teams support is to work under OAuth.

---

## Family 6 — tenant_info (site direct, unauthenticated; pre-auth)

| # | Method + path | Helper | Command(s) | R/W | Verdict |
|---|---|---|---|---|---|
| 77 | GET {site}/_edge/tenant_info | direct reqwest (`redirect::none`, 10s, no bearer) | auth login (cloudId discovery, ADR-0022) | READ | **N/A — unauthenticated by design; NOT an OAuth impact.** Must hit the site directly; there is no cloudId yet. |

---

## Family 7 — OAuth flow (auth.atlassian.com / api.atlassian.com/oauth)

| # | Method + path | Helper | Command(s) | R/W | Verdict |
|---|---|---|---|---|---|
| 78 | GET https://auth.atlassian.com/authorize?… | browser open (`build_authorize_url`) | auth login --oauth | n/a | OK (the flow itself) |
| 79 | POST https://auth.atlassian.com/oauth/token (authorization_code) | direct reqwest | auth login --oauth | WRITE (token mint) | OK |
| 80 | GET https://api.atlassian.com/oauth/token/accessible-resources | direct reqwest (bearer) | auth login --oauth (cloudId disambiguation) | READ | OK |
| 81 | POST https://auth.atlassian.com/oauth/token (refresh_token) | direct reqwest (via refresh_coordinator single-flight) | auto-refresh on 401 / auth refresh | WRITE (token mint) | OK |

Note (client.rs docstring, ~line 903): the refresh POST in `refresh_oauth_token_with_url`
uses a fresh `reqwest::Client::new()` with **no timeout** — unbounded; a 401-near-deadline
can overshoot. Not an OAuth-*correctness* issue but flagged for completeness.

---

## Family 8 — `jr api` passthrough

| # | Method + path | Helper | Command | R/W | Verdict |
|---|---|---|---|---|---|
| 82 | {base_url}{user-supplied path} | request() + send_raw | `jr api` | ARBITRARY | Routing OK (gateway); scope depends entirely on the user's path. A user can hit an agile/servicedeskapi/graphql path and inherit the same scope/routing gaps as families 2/3/5. |

---

# Summary

**Total distinct endpoints inventoried: 82.**

Verdict counts:
- **OK: 62** (Platform 1-19, 23-51, 65; JSM attachments 66-67; Assets 68-74*; tenant_info 77; OAuth flow 78-81; `jr api` 82 routing)
- **BROKEN-ROUTING: 9** (58, 59, 60, 61, 62, 63, 64, 75, 76)
- **SCOPE-GAP: 6** (52, 53, 54, 55, 56, 57 — Agile)
- **NEEDS-RESEARCH: 3** (20, 21, 22 — new bulk API scopes)

(*) Assets OK-routed endpoints are functionally blocked under OAuth by the broken workspace
prerequisite (#64) — counted OK on their own merits but see caveat.

### (a) All BROKEN-ROUTING sites (uses instance_url / site URL under OAuth)
1. `jira/teams.rs:19` — POST /gateway/api/graphql (`get_org_metadata`)
2. `jira/teams.rs:38-43` — GET /gateway/api/public/teams/v1/org/{orgId}/teams (`list_teams`)
3. `jsm/servicedesks.rs:22` — GET /rest/servicedeskapi/servicedesk (`list_service_desks`)
4. `jsm/queues.rs:12` — GET /rest/servicedeskapi/servicedesk/{sid}/queue (`list_queues`)
5. `jsm/queues.rs:47` — GET /rest/servicedeskapi/servicedesk/{sid}/queue/{qid}/issue (`get_queue_issues`)
6. `jsm/request_types.rs:28` — GET …/servicedesk/{sid}/requesttype (`list_request_types`)
7. `jsm/request_types.rs:69` — GET …/servicedesk/{sid}/requesttype/{rtId}/field (`get_request_type_fields`)
8. `jsm/requests.rs:28` — POST /rest/servicedeskapi/request (`create_jsm_request`) — the JSM issue-create write
9. `assets/workspace.rs:26` — GET /rest/servicedeskapi/assets/workspace (`get_or_fetch_workspace_id`) — prereq for the whole Assets surface

All 9 fall within the previously-flagged "JSM / Teams / Assets" set — **no NEW broken-routing site discovered.** (Corroborated by repo issue #831, "OAuth profiles send JSM calls to the site URL instead of the OAuth gateway".)

### (b) All SCOPE-GAP sites and the specific scope needed
All are Agile `/rest/agile/1.0`, routing correct, missing scope:
- GET board (list) → `read:board-scope:jira-software` **and** `read:project:jira` (board list needs the extra project scope)
- GET board/{id}/configuration → `read:board-scope:jira-software`
- GET board/{id}/sprint → `read:sprint:jira-software` (or board-scope)
- GET sprint/{id}/issue → `read:sprint:jira-software` (or board-scope)
- POST sprint/{sprintId}/issue → `write:board-scope:jira-software`
- POST backlog/issue → `write:board-scope:jira-software`

Minimal Agile scope set to add: `read:board-scope:jira-software`, `read:sprint:jira-software`,
`write:board-scope:jira-software`, and `read:project:jira` (for board list).
Note also the JSM/Teams broken-routing endpoints have a *latent* scope dimension: even if
re-routed to the gateway, the two `/gateway/*` teams endpoints (75, 76) have **no covering
scope** in the default set (org/teams GraphQL is not a jira-work scope) — teams needs a
scope decision, not just a routing fix.

### (c) All NEEDS-RESEARCH items
- **New bulk-operations API** (`/rest/api/3/bulk/issues/fields`, `/rest/api/3/bulk/issues/transition`,
  `/rest/api/3/bulk/queue/{taskId}` — bulk.rs). Routing is gateway (OK). The 2023+ bulk API
  may require granular scopes (e.g. `write:issue:jira`, `read:issue:jira`) rather than classic
  `write:jira-work`/`read:jira-work`. Reached by `jr issue edit` (bulk) and `jr issue move` (bulk).
  Verify against a live granular-scoped OAuth token before declaring OK. If it needs granular
  scopes, this is a SECOND scope gap beyond Agile.
- **Assets gateway base variant:** jr composes `…/ex/jira/{cloudId}/jsm/assets/workspace/{wid}/v1/…`.
  Docs show both this form and the `…/jsm/assets/workspace/{wid}/v1/…` (no `/ex/jira/{cloudId}`)
  form as valid; jr's form is documented-valid, but this is the one Assets routing detail that
  should get a live-token confirmation given the Assets surface is otherwise blocked by #64.

### (d) Exact list of Agile WRITE operations `jr` performs
Only **two** Agile writes exist in the codebase:
1. `add_issues_to_sprint` → **POST /rest/agile/1.0/sprint/{sprintId}/issue** — command `jr sprint add` (`sprints.rs:90-93`)
2. `move_issues_to_backlog` → **POST /rest/agile/1.0/backlog/issue** — command `jr sprint remove` (`sprints.rs:98-101`)

Both require **`write:board-scope:jira-software`**. There is **no** board write, no sprint
create/update, no other agile mutation. Everything else touching agile (board list/view,
sprint list/current/view) is READ-only. Therefore: adding `write:board-scope:jira-software`
is genuinely required *iff* `jr sprint add`/`jr sprint remove` must work under OAuth; the
read agile scopes are required for `jr board *` and `jr sprint list/current` regardless.
(`jr issue move` is a platform workflow transition, NOT an agile write — do not conflate it.)

### (e) Newly-discovered OAuth impact not previously flagged
1. **Bulk-operations API scope uncertainty (#20-22)** — the only endpoints outside the known
   JSM/Teams/Assets/Agile set with a plausible OAuth-scope problem. Not previously flagged.
   Highest-value new finding for cycle-008: `jr issue edit`/`move` bulk paths could silently
   fail on granular-scoped OAuth tokens.
2. **JSM intra-family routing asymmetry** — JSM *attachment* writes (66-67) already route via
   `base_url()` (gateway, OK) while every other JSM call routes via `*_instance` (broken). Any
   "fix JSM routing" change must NOT blanket-rewrite JSM to a single base; two endpoints are
   already correct and would regress. Not previously called out as a divergence.
3. **Assets breakage is prerequisite-driven, not AQL-driven** — the object/schema/AQL calls are
   all correctly gateway-routed; the whole feature is nonetheless OAuth-broken solely because
   `get_or_fetch_workspace_id` (#64) is instance-routed. Fixing just that one call repairs the
   entire Assets surface. This precise localization was not previously stated.
4. **Teams is doubly-broken (routing + no scope)** — re-routing the two `/gateway/*` teams
   endpoints to the gateway is necessary but NOT sufficient; the default scope set contains no
   org/teams scope, so teams needs a scope addition too.
5. **Board list needs a second scope (`read:project:jira`)** beyond `read:board-scope:jira-software`
   — easy to miss when adding only the board scope.
6. **`jr api` inherits all gaps** — arbitrary user paths through the gateway can still hit
   servicedeskapi/agile/graphql surfaces and manifest the same scope failures.
7. **tenant_info clarification** — `{site}/_edge/tenant_info` is unauthenticated/pre-auth and
   is explicitly NOT an OAuth impact, despite hitting the site URL directly. Documented so it
   isn't mistaken for a broken-routing site in cycle-008.
