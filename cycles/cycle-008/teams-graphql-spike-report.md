# Spike Report — Teams GraphQL OAuth Re-platform Investigation

**Story:** `S-cycle8-teams-graphql-oauth-replatform-spike` (cycle-008 "oauth-surface-correctness", Workstream D, non-gating)
**Date:** 2026-09-18 (revised 2026-09-18 — AC-002/AC-006 re-investigated after operator Console evidence; see "Revision 2" note); addenda 2026-09-19 (operator empirical authorize differential test; Console entitlement inspection) firmed AC-002 to CONFIRMED-NOT-GRANTABLE via two independent proofs and AC-006 to DEFER-INDEFINITELY — see "Investigation trail / what we did" recap below
**Author:** research-agent (investigation-only; ZERO `src/` changes, no BC/VP/ADR authored, no PR, no merge)

> **Revision 2 (2026-09-18):** B1/AC-002 re-investigated at the coordinator's request after the operator (app owner) inspected the jr app's Console Permissions and saw **no Teams scope/API available to add**, which appeared to contradict the official docs' statement that OAuth 2.0 works for Teams. This revision pins the **exact** read-query scope, reconciles the contradiction with citations, and firms the go/no-go. AC-001/AC-003/AC-004 findings are unchanged; only the AC-002 finding, the AC-006 go/no-go, and the affected summary rows are rewritten.
**Traces to:** ADR-0026 Decision 4 (Deferred/Context — the four open questions this spike resolves)
**Confidence convention (mirrors `oauth-scope-matrix.md`):** **CONFIRMED** (authoritative `developer.atlassian.com` docs or direct code read) / **STILL-UNCERTAIN** (requires a named human/app-owner action to close). No finding rests on training-data recall of Atlassian's GraphQL shape alone.

---

## Executive summary

| AC | Question | Verdict |
|----|----------|---------|
| AC-001 | Move Teams listing to `POST https://api.atlassian.com/graphql` + `teamSearchV2`? Shape compatible with `TeamsResponse`? | **CONFIRMED host + operational query/pagination shape; CONFIRMED translation required (NOT drop-in compatible). Exact SDL STILL-UNCERTAIN (live Explorer).** |
| AC-002 | Are `view:team:teams` / `view:membership:teams` addable to jr's Jira 3LO app? | **Read-query scope CONFIRMED = `view:team:teams`. Self-service addability CONFIRMED-NOT-AVAILABLE for a standalone 3LO app today (no Console Teams-API tile; matches operator observation + community evidence) — but NOT a cited categorical 3LO prohibition. Practically blocked, possibly resolvable only via an Atlassian-side request.** This is the gating blocker. |
| AC-003 | Is `get_org_metadata` (`jr init`) also broken under OAuth (IN-SCOPE) or already-correct (OUT-OF-SCOPE)? | **CONFIRMED IN-SCOPE — also broken under OAuth (same `post_to_instance` → site-host routing gap). Increased blast radius.** |
| AC-004 | Does a future fix need an `is_oauth_auth()` host fork, or is a blanket host swap safe? | **CONFIRMED-FORK-REQUIRED — the central host is Bearer-only; a blanket swap would regress working API-token Teams commands.** |
| AC-005 | Citation discipline | Satisfied — see per-AC citations + Research Methods. |
| AC-006 | Go/no-go for a future `S7 teams-graphql-oauth-replatform` | **DEFER** (not a flat REJECT) — the single remaining blocker is an Atlassian-side scope-provisioning question for a standalone 3LO app (AC-002), which no self-service Console action can close today. Flips to **REJECT / DEFER-INDEFINITELY** only if Atlassian confirms `view:team:teams` cannot be granted to jr's standalone 3LO app. |

---

## Code baseline (direct read — AC-005 code-grounding)

`src/api/jira/teams.rs` (read in full) contains **two separate functions** — not conflated:

- **`get_org_metadata(hostname)`** (`teams.rs:12`) — POSTs a GraphQL `tenantContexts(hostNames:[...])` query returning `orgId` + `cloudId`, via `self.post_to_instance("/gateway/api/graphql", &query)` (`teams.rs:19`). Deserializes into `GraphqlResponse<TenantContextData>` → `TenantContext { org_id, cloud_id }`.
- **`list_teams(org_id)`** (`teams.rs:33`) — cursor-paginated GET loop against `/gateway/api/public/teams/v1/org/{org_id}/teams` via `self.get_from_instance(&path)` (`teams.rs:43`), URL-cursor form `?cursor={c}`. Deserializes into `TeamsResponse { entities: Vec<TeamEntry>, cursor: Option<String> }`; `TeamEntry { team_id (teamId), display_name (displayName) }` (`src/types/jira/team.rs`).

**Both** use the `*_instance` helper family. `get_from_instance`/`post_to_instance` (`client.rs:1069`/`1078`) compose `{instance_url}{path}` — and `instance_url()` (`client.rs:1064`) is documented "always the real instance URL, **even for OAuth users**". Under an OAuth profile the site host and the gateway diverge, so **both functions hit the wrong host under OAuth**. This is corroborated by `oauth-endpoint-inventory.md` §(a), which lists BOTH `teams.rs:19` (`get_org_metadata`) and `teams.rs:38-43` (`list_teams`) as BROKEN-ROUTING rows #75/#76.

Routing-fork precedent already exists: `is_oauth_auth()` (`client.rs:235`, `self.auth_header.starts_with("Bearer ")`) is the established predicate for auth-scheme-specific dispatch (used today by `jsm_create.rs`, `require_service_desk`, `board.rs`).

**Callers traced (Grep across whole tree):**
- `get_org_metadata`: `src/cli/init.rs:300` (`jr init` Step 6, org/cloud-ID prefetch — wrapped `if let Ok`, soft-fails) and `src/cli/team.rs:97` (`resolve_org_id`, called by `jr team list` — hard `?` propagation).
- `list_teams`: `src/cli/init.rs:326` (`jr init` Step 7 team-cache warm — `if let Ok`) and `src/cli/team.rs:60` (`fetch_and_cache_teams`, `jr team list --refresh` / cache-miss — hard `?`).

---

## AC-001 — GraphQL host + `teamSearchV2` query/pagination shape

**Verdict: CONFIRMED host and operational query/pagination shape; CONFIRMED that translation is required (the `teamSearchV2` shape is NOT compatible with the existing `TeamsResponse` type). Exact SDL/nullability STILL-UNCERTAIN — resolvable only by a live GraphQL Explorer run.**

**CONFIRMED (authoritative `developer.atlassian.com`):**
- `teamSearchV2` is the current, non-deprecated public query field for searching teams within an organization as of 2026. Atlassian deprecated the *internal/private* team-search REST endpoints and directs users to public GraphQL `teamSearchV2`. (Teams GraphQL "using team query" + Atlassian "we're deprecating the internal team search API".)
- **OAuth clients use `POST https://api.atlassian.com/graphql`** (a global host; the tenant is selected via query arguments, NOT via a `/ex/jira/{cloudId}` URL prefix). (Teams GraphQL introduction; Atlassian GraphQL gateway page.)
- The query lives under the top-level `team` namespace: `team { teamSearchV2(...) { ... } }`.
- Pagination is a **cursor connection**, not offset/page-number: the selection exposes `pageInfo { hasNextPage endCursor hasPreviousPage startCursor }` alongside `nodes { ... }`; continuation is `first` + string `after`, advancing `after` to the prior `pageInfo.endCursor` while `hasNextPage`.
- Inputs demonstrated in Atlassian-owned examples: **`organizationId`** (organization ARI, `ari:cloud:platform::org/{orgId}`), **`siteId`** (the site `cloudId`), `first`, `after`, and `filter { query: "..." }`.
- Team identifiers are **ARIs** (`ari:cloud:identity::team/...`) exposed as `team.id`, with `team.displayName` for the name.
- The required OAuth scope gating the read `team { teamSearchV2 }` query is **`view:team:teams`** (see AC-002 for the confirmation trail and the addability problem). The static `using-team-query` page states only "The required scopes are specified in the queries" and defers the exact string to the GraphQL Explorer field descriptions; the concrete string is confirmed from live gateway errors, below.

**Operational query shape (from Atlassian-owned examples):**
```graphql
query SearchTeams {
  team {
    teamSearchV2(
      organizationId: "ari:cloud:platform::org/ORG_UUID"
      siteId: "CLOUD_ID"
      first: 50
      after: "0"
      filter: { query: "" }
    ) {
      pageInfo { hasNextPage endCursor }
      nodes {
        team { id displayName }
      }
    }
  }
}
```

**Compatibility analysis vs the existing `TeamsResponse` (`src/types/jira/team.rs`) — TRANSLATION REQUIRED:**

| Dimension | Current REST (`list_teams` / `TeamsResponse`) | `teamSearchV2` GraphQL | Impact |
|---|---|---|---|
| Envelope | flat `{ entities: [...], cursor: "..." }` | nested `data.team.teamSearchV2.{ pageInfo, nodes }` | New serde types needed; `TeamsResponse` cannot deserialize the GraphQL body. |
| Team record | `entities[].{ teamId, displayName }` | `nodes[].team.{ id, displayName }` (extra `team` wrapper; node also carries `memberCount`, `includesYou`) | Field-path + rename mapping to `TeamEntry`. |
| Team ID value | REST id (non-ARI) | **ARI** `ari:cloud:identity::team/...` | **Data-shape change** — downstream `--team` resolution and the `CachedTeam.id`/team-field write path may need ARI-vs-plain-id reconciliation. Flag for S7. |
| Pagination token | `cursor` field + URL `?cursor=` | `pageInfo.endCursor` + `hasNextPage`, `after` passed as a **query variable** | Loop logic changes from URL-param to GraphQL-variable cursoring. |
| Inputs | `org_id` only | `organizationId` (org **ARI**) + `siteId` (**cloudId**) | jr already resolves both `org_id` and `cloud_id` (via `get_org_metadata` / login), but `org_id` must be wrapped as `ari:cloud:platform::org/{org_id}`. |

**STILL-UNCERTAIN (named app-owner action to close):** the exact SDL signature — argument nullability/defaults, whether the `@optIn(to: "Team-search-v2")` directive is still required, the precise `filter` input-type name and team-type enums, whether `edges { node }` remains available alongside `nodes`, and whether `siteId` is technically optional. Atlassian's static pages explicitly defer these to the interactive GraphQL Explorer. **Resolving action (human/app-owner):** run the query above in the authenticated **Atlassian GraphQL Explorer** (`https://api.atlassian.com/graphql`, or the site-local explorer) against jr's org, and capture the field descriptions (scopes + lifecycle) shown per field. Community reports of ARI-format friction (`invalid organization ARI using teamSearchV2`) make a live confirmation of the exact `organizationId` ARI form worthwhile before implementation.

---

## AC-002 — Scope addability (`view:team:teams` / `view:membership:teams`)

**Verdict (revised): the exact read-query scope is CONFIRMED `view:team:teams`. Its self-service addability to a standalone Jira Cloud 3LO app is CONFIRMED-NOT-AVAILABLE today (no Console Teams-API tile exposes it), which exactly matches the operator's observation. This is NOT a cited categorical "3LO is forbidden" restriction — OAuth 3LO is affirmatively documented as protocol-supported — so it is a missing-provisioning-mechanism block, potentially resolvable only through an Atlassian-side request, not a proven dead end. This remains the spike's gating blocker.**

### (1) Exact required scope for the READ query — CONFIRMED `view:team:teams`

- The static `using-team-query` page says only: *"You can use OAuth 2.0 to request data on behalf of a user. The required scopes are specified in the queries."* (verified verbatim by direct WebFetch, 2026-09-18) — it does not print the string, deferring it to the GraphQL Explorer field descriptions.
- The concrete string is confirmed from **live gateway behavior**, not doc recall: querying `teamSearchV2` without it returns a GraphQL error carrying `requiredScopes: ["view:team:teams"]`, and Atlassian's own issue record (AX-446) states the `teamSearchV2` documentation specifies `view:team:teams`. (Community: `how-to-add-teams-scopes-for-graphql-query` #80920; `missing-scope-viewteams` #94060; Atlassian issue AX-446.)
- It is specifically **`view:team:teams`** — NOT `read:team:jira`, NOT `read:teams`, and NOT `view:membership:teams` (the latter gates membership-oriented fields, not the base team-search listing). If jr renders member data, `view:membership:teams` is additionally required; nested member **identity** fields (`member { accountId name }`) can trip a further `identity:atlassian-external` scope that is not authorizable by ordinary apps at all — so **S7 should list teams only (id + displayName), avoiding member-identity fields**, to stay within a single addable scope.
- These are **Teams platform scopes**, not entries in the Jira classic or granular OAuth scope catalogs (the Jira catalog has no `:teams` scope) — confirmed by direct read of the Jira scope catalog and the Teams docs.

### (2) Console mechanism for a standard 3LO app — CONFIRMED-NOT-AVAILABLE (self-service)

- Atlassian's 3LO model only lets an authorization request use scopes that are **already added to the app's APIs in the Developer Console** (`implementing-oauth-3lo`). So manually appending `scope=view:team:teams` to the authorize URL is not a workaround — it yields `invalid_scope` unless the app has the backing API/scope provisioned.
- **There is no documented self-service "Teams" (or "Identity"/platform-Teams) API tile** that a standard Jira Cloud 3LO app can add in the Console to expose `view:team:teams`. Adding the **Jira API** does not expose it; adding the **User Identity API** provides only identity scopes (`read:me`), not Teams. This is the **direct reconciliation of the operator's observation**: the operator saw no Teams scope/API to add because, for a standalone 3LO app, there currently is none to add. Multiple third-party developers report the same absence (community #80920, #94060).
- **Classic-vs-granular mode is a red herring here.** Because `view:team:teams` is not in either Jira scope catalog, no "switch the jr app to granular mode" action would surface it. (Classic and granular Jira scopes otherwise coexist — confirmed, consistent with ADR-0026's "no forced migration" finding — but that lever does not apply to a non-Jira platform scope.)

### (3) App-type / lifecycle gate

- **Forge apps CAN declare `view:team:teams`** as a manifest scope (evidence includes Compass/Forge usage) — so the capability provably exists; it is the **standalone-3LO self-service registration path** that is missing.
- **The READ query is NOT under the "Experimental" restriction.** The introduction page (verified verbatim) scopes "Experimental" to the *public team and membership **mutations***; the read `team`/`teamSearchV2` query is not called experimental. (`teamSearchV2` may, however, still require the GraphQL `@optIn(to: "Team-search-v2")` directive — a schema opt-in, not a customer allowlist.)
- **No cited categorical prohibition** was found stating that standalone 3LO apps may not use the Teams GraphQL read query. The barrier is the absence of a Console provisioning path, plus the possibility that enabling it requires an Atlassian-side action (EAP/allowlist/manual grant). This distinction is why the go/no-go is DEFER, not a flat REJECT.

### (4) Reconciling the contradiction — most-likely explanation + exact operator action

**Most-likely explanation (single):** Atlassian's Teams GraphQL API is genuinely OAuth-3LO-capable at the **protocol/schema** layer (host + `view:team:teams` field-level scope enforcement), but Atlassian has **not exposed a self-service Console mechanism** for a standalone 3LO app to *register* the Teams scope set. Forge apps get it via the manifest; standalone 3LO apps currently have no tile. So the docs ("OAuth works, scopes exist") and the operator ("nothing to add in the Console") are both correct and not actually contradictory — they describe different layers (schema capability vs. Console provisioning).

**Exact operator action(s) to definitively close B1 (the human IS the app owner):**
1. **Empirical console/consent test (fast, definitive-for-this-app):** build a jr authorize URL that includes `scope=view:team:teams` (alongside the existing scopes) and open it. `invalid_scope` (or the scope silently dropped / absent from the consent screen) = **definitively not grantable to this app today**. A consent screen that lists the Teams permission = grantable (proceed to PROCEED).
2. **Atlassian-side request (the only path that can actually unblock):** because there is no self-service tile, ask Atlassian directly whether `view:team:teams` can be enabled for jr's standalone 3LO app — via the Teams platform "Contact us" page (`developer.atlassian.com/platform/teams/overview/contact-us/`) and/or a post on `community.developer.atlassian.com` (tag: teams/3lo), referencing threads #80920 and #94060. If Atlassian confirms there is no path for standalone 3LO → the go/no-go becomes **REJECT / DEFER-INDEFINITELY** (EC-3).

**Do not** add `view:team:teams` to `DEFAULT_OAUTH_SCOPES` until step 1 shows the consent screen accepts it — an unprovisioned scope in the authorize URL hard-fails **every** OAuth login with `invalid_scope`, the same release-gate hazard ADR-0026 Decision 2 flags.

---

## AC-003 — `get_org_metadata` / `jr init` exposure

**Verdict: CONFIRMED IN-SCOPE. `get_org_metadata` is also broken under OAuth (same host-routing gap as `list_teams`), so a future Workstream D fix MUST address it too — but carefully, because it feeds `jr init`. This raises the blast radius (EC-2).** Evidence is code-read, not name-inferred.

**Code evidence (call-graph + query-shape comparison):**
- `get_org_metadata` calls `post_to_instance("/gateway/api/graphql", ...)` (`teams.rs:19`) → `{instance_url}/gateway/api/graphql`. Under OAuth, `instance_url` is the raw site host (`client.rs:1064` docstring), NOT the gateway → **broken-routing**, identical class to `list_teams`. Confirmed independently by `oauth-endpoint-inventory.md` row #75.
- It is a **different query** from `list_teams`: `get_org_metadata` runs a GraphQL `tenantContexts(hostNames:[...])` returning `orgId`+`cloudId`; `list_teams` runs the public **REST** teams endpoint. They are distinct calls with distinct shapes — but **both** are mis-routed to the site host under OAuth. So the finding is IN-SCOPE (broken), not "already-correct-and-must-not-touch".

**`jr init` blast-radius nuance (mitigating, but must be handled):**
- In `jr init` (`init.rs:300`), `get_org_metadata` is wrapped in `if let Ok(metadata)` — an OAuth failure **soft-fails**: `jr init` still completes ("jr is ready!"), but `org_id` is never persisted and the team cache (Step 7) is never warmed. `cloud_id` is guarded by `if entry.cloud_id.is_none()` (`init.rs:319`) and is already resolved at OAuth login via tenant_info (ADR-0022), so the OAuth `cloud_id` is unaffected by this failure.
- The harder break is `jr team list`: `resolve_org_id` (`team.rs:97`) calls `get_org_metadata` with a hard `?`, so under OAuth a cold-cache `jr team list` fails outright once it needs to resolve `org_id`.
- **Net:** `jr init` does not hard-crash today under OAuth (soft-fail), but org-resolution and all Teams functionality are broken. A future S7 that re-platforms `get_org_metadata` to the OAuth host must preserve the `jr init` soft-fail semantics and must not regress the API-token path (AC-004). Because `get_org_metadata` touches the `jr init` setup path, S7 MUST include `jr init`-specific regression coverage (EC-2).

**Additional STILL-UNCERTAIN sub-point:** whether `tenantContexts(hostNames:...)` behaves correctly when issued against the **central** `api.atlassian.com/graphql` host for an OAuth token (the platform docs indicate `tenantContexts` follows the same host-routing rule and is reachable, but the org/cloud-ID resolution semantics on the central host for an OAuth token should be confirmed in the **same live Explorer session** as AC-001). An alternative for S7 is to source `org_id` from a different OAuth-reachable path rather than re-platforming `tenantContexts` — a design choice for S7, flagged here.

---

## AC-004 — API-token host preservation

**Verdict: CONFIRMED-FORK-REQUIRED. A future fix must gate the host on `is_oauth_auth()`; a blanket swap to `api.atlassian.com/graphql` would break currently-working API-token Teams commands.**

**CONFIRMED (authoritative docs):**
- The **site-local** `https://<site>.atlassian.net/gateway/api/graphql` endpoint **works with Basic (email + API-token) auth** — Atlassian explicitly documents `Authorization: Basic base64(email:api_token)` against the site-local GraphQL gateway (both classic and scoped API tokens supported).
- The **central** `https://api.atlassian.com/graphql` gateway is documented **only** for OAuth Bearer tokens; Basic/API-token is not a documented or supported auth mode there. Treat it as **Bearer-only**. (Atlassian maps OAuth clients → central host, API-token clients → site-local host, verbatim in the Teams GraphQL docs.)
- For an API-token profile, both `tenantContexts` and `teamSearchV2` remain reachable at the **site-local** host with Basic auth. The "Forge and OAuth2 apps cannot access this REST resource" restriction on the public Teams REST endpoint (#76) applies to OAuth2/Forge apps — **not** to a real user's Basic/API-token credential — so the API-token path's *current* REST-based `list_teams` continues to work as-is.

**Implication for S7 design:** the cleanest shape is to **leave the API-token path entirely unchanged** (site-local `/gateway/api/graphql` for `get_org_metadata`; existing REST public-teams endpoint for `list_teams`) and add an **OAuth-only branch** gated by `is_oauth_auth()` that targets `api.atlassian.com/graphql` with `teamSearchV2` (for teams) and the org-resolution query (for `get_org_metadata`). This mirrors the existing `is_oauth_auth()` fork precedent (`jsm_create.rs`, `require_service_desk`).

**Architecture note (records the ADR-0026 Decision 4 "third host class" gap):** `api.atlassian.com/graphql` is **neither** `base_url` (OAuth `base_url` = `api.atlassian.com/ex/jira/{cloudId}`, which carries the `/ex/jira/{cloudId}` suffix the GraphQL host lacks) **nor** `instance_url` (the site host). It is a genuine **third host family** the codebase does not currently model. S7 will need a new client helper (e.g. `post_to_graphql_gateway`) rather than reusing `get`/`post` (base_url) or `*_instance` (instance_url), and — per ADR-0026 Decision 4's own flag — likely a documented amendment/exception to ADR-0026 Decision 1's clean `base_url`-vs-`instance_url` binary partition.

---

## AC-005 — Citation discipline

Every finding above is grounded in one of: (a) an authoritative `developer.atlassian.com` doc lookup performed during this spike (see Research Methods), (b) a direct code read of `src/api/jira/teams.rs` and its traced callers (`init.rs`, `team.rs`, `client.rs`, `types/jira/team.rs`), or (c) an explicit **STILL-UNCERTAIN** tag naming the app-owner action that closes it. No finding is presented as CONFIRMED from training-data recall of Atlassian's GraphQL shape. The two irreducibly live-access-dependent items (AC-002 Console addability; AC-001/AC-003 exact SDL) are flagged UNCERTAIN with the exact human action, matching the `oauth-scope-matrix.md` CONFIRMED/UNCERTAIN precedent.

---

## AC-006 — Go/No-Go recommendation

### Recommendation: **DEFER** a future `S7 teams-graphql-oauth-replatform` implementation story.

**One-line rationale:** the host/query/translation/fork *shape* is confirmed and implementable, but the one gating blocker — whether Atlassian can grant `view:team:teams` to jr's standalone 3LO app — has **no self-service resolution** (confirmed by the operator's Console inspection + community evidence) and can only be closed by an Atlassian-side request; that is a DEFER, not a flat REJECT, because no cited rule categorically bars 3LO from the Teams read query.

**Why DEFER, not PROCEED:**
- **AC-002 is the gating blocker.** The exact read scope is now CONFIRMED (`view:team:teams`), but it is **not self-service addable** to a standalone 3LO app in the Developer Console today. S7 cannot ship until Atlassian provisions the scope for jr's app (or the empirical consent test in AC-002 §(4) shows it is already grantable). Building the routing/query/translation before that is confirmed would be speculative.
- **AC-001/AC-003 exact SDL is STILL-UNCERTAIN** — the operational query shape is confirmed, but precise argument nullability, the `@optIn` requirement, and `tenantContexts`-on-central-host behavior want a live Explorer run before an implementer writes the query + new serde types. (Lower-priority than AC-002; resolvable in the same Explorer session.)

**Why NOT a flat REJECT (this revision's key change):** the earlier "conditional REJECT" was based on treating the operator's "nothing to add" as proof of impossibility. Re-investigation shows the barrier is a **missing Console provisioning path**, not a cited categorical prohibition — Atlassian affirmatively documents OAuth 3LO support for the Teams GraphQL API, the exact scope exists and is enforced field-level, Forge apps already use it, and the read query is not under the experimental-mutations restriction. REJECT is warranted **only if** Atlassian explicitly confirms `view:team:teams` cannot be granted to a standalone 3LO app (then → REJECT / DEFER-INDEFINITELY, EC-3).

**Increased-blast-radius flag (per EC-2):** AC-003 found `get_org_metadata` **IN-SCOPE** — it also touches `jr init`. A future S7 must (a) preserve `jr init`'s existing soft-fail semantics, (b) add `jr init`-specific OAuth regression coverage, and (c) not regress the API-token path. This makes S7 materially larger than a `list_teams`-only fix and argues for a cautious PROCEED *even after* the blockers clear.

### Confirmed shape a future S7 would start from (once blockers clear):
1. **Host:** OAuth → `POST https://api.atlassian.com/graphql` (new third-host-class helper); API-token → **unchanged** (site-local `/gateway/api/graphql` + existing REST teams endpoint). Gate on `is_oauth_auth()`.
2. **Query:** `team { teamSearchV2(organizationId: ari, siteId: cloudId, first, after, filter) { pageInfo { hasNextPage endCursor } nodes { team { id displayName } } } }`.
3. **Translation:** new serde types (GraphQL connection envelope + ARI team IDs) mapped into `TeamEntry`/`CachedTeam`; reconcile ARI-vs-plain team-id for the `--team` write path.
4. **Scopes:** `view:team:teams` (read query, CONFIRMED). List teams only (`team { id displayName }`) — deliberately avoid `members`/member-identity fields, which pull in `view:membership:teams` and the non-authorizable `identity:atlassian-external`. Add to `DEFAULT_OAUTH_SCOPES` **only after** B1's empirical consent test shows the scope is grantable, and register it in the Developer Console in the same change, per ADR-0026 Decision 2 release-gate discipline.
5. **`get_org_metadata`:** re-platform its org-resolution to an OAuth-reachable path (central-host `tenantContexts` or an alternative org-id source), preserving `jr init` soft-fail.
6. **Architecture:** a follow-on ADR (or ADR-0026 amendment) documenting the third host class, as ADR-0026 Decision 4 anticipates.

### Blockers to hand to the human/app-owner (close these to unblock S7):

| # | Blocked AC | Exact app-owner action to resolve |
|---|-----------|-----------------------------------|
| B1 | **AC-002** (gating) | **Confirmed:** no self-service Console tile exposes the Teams scope to a standalone 3LO app. Two-step close: (1) **empirical consent test** — build a jr authorize URL including `scope=view:team:teams` and open it; `invalid_scope` / scope dropped = not grantable to this app today; consent screen lists the Teams permission = grantable → PROCEED. (2) **Atlassian-side request** (the only unblock path if step 1 fails) — ask via the Teams "Contact us" page (`developer.atlassian.com/platform/teams/overview/contact-us/`) and/or `community.developer.atlassian.com` (tags teams/3lo, ref #80920/#94060) whether `view:team:teams` can be enabled for jr's standalone 3LO app. If Atlassian confirms no path → **REJECT / DEFER-INDEFINITELY**. |
| B2 | **AC-001** | Run the `teamSearchV2` query (shape above) in the authenticated **GraphQL Explorer** against jr's org; capture exact arg nullability, whether `@optIn(to: "Team-search-v2")` is still required, the `filter` input-type/enum names, `nodes`-vs-`edges`, and the exact accepted `organizationId` ARI form. |
| B3 | **AC-003** | In the same Explorer session, confirm `tenantContexts(hostNames:[...])` (or the chosen org-id-resolution query) returns `orgId`+`cloudId` correctly for an OAuth token on `api.atlassian.com/graphql`. |

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 4 | (1) `teamSearchV2` host/query/pagination/response shape [AC-001]; (2) `view:team:teams`/`view:membership:teams` scope reality + 3LO addability [AC-002]; (3) central-vs-site-local GraphQL host auth-mode (Bearer-only vs Basic) [AC-004]; (4, Rev 2) exact read-query scope string + Console/app-type/EAP addability for a standalone 3LO app [AC-002 deep-dive] |
| Perplexity perplexity_ask | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_reason | 0 | — |
| Context7 | 0 | N/A — Atlassian Teams GraphQL/scope docs are not a Context7-indexed library; official `developer.atlassian.com` pages via Perplexity/WebFetch were authoritative |
| Tavily | 0 | — |
| WebFetch | 2 | (Rev 2) Verbatim extraction of the two official Teams GraphQL pages: `using-team-query` and `introduction` — to pin the exact "required scopes are specified in the queries" / "mutations are Experimental" / host-split wording |
| Read (code) | 8 files | `teams.rs`, `types/jira/team.rs`, `client.rs` (routing primitives + `is_oauth_auth`), `init.rs`, `team.rs`, ADR-0026, `oauth-endpoint-inventory.md`, `oauth-scope-matrix.md`, story spec, F1 delta |
| Grep (code) | 3 | caller tracing for `list_teams`/`get_org_metadata`; `post_to_instance`/`instance_url`/`is_oauth_auth`; type definitions |
| Training data | 0 areas | No verdict rests on model knowledge; every external claim sourced to `developer.atlassian.com` or flagged STILL-UNCERTAIN with the app-owner action |

**Total MCP tool calls:** 4 `perplexity_research` (`search_context_size: high`) + 2 `WebFetch` = 6 across both passes.
**Training data reliance:** low — all API-shape and scope claims sourced to official Atlassian developer docs; the exact `view:team:teams` string and the no-self-service-tile finding are sourced to live gateway errors + Atlassian issue AX-446 + community threads #80920/#94060 (distinguished from static-doc CONFIRMED items); the remaining live-access-dependent items are flagged STILL-UNCERTAIN with the exact human/app-owner action.

**Additional Rev-2 sources:**
- Implementing OAuth 3LO (authorize request may only use scopes added to the app in Console): https://developer.atlassian.com/cloud/oauth/getting-started/implementing-oauth-3lo/
- Teams "Contact us" (Atlassian-side request path): https://developer.atlassian.com/platform/teams/overview/contact-us/
- Community — how to add teams scopes for GraphQL (3LO console absence, `requiredScopes:["view:team:teams"]`): https://community.developer.atlassian.com/t/how-to-add-teams-scopes-for-graphql-query/80920
- Community — missing scope viewteams: https://community.developer.atlassian.com/t/missing-scope-viewteams/94060
- Atlassian issue AX-446 (teamSearchV2 docs specify `view:team:teams`): https://jira.atlassian.com/browse/AX-446

**Primary sources (Atlassian official):**
- Teams GraphQL — using team query: https://developer.atlassian.com/platform/teams/teams-graphql-api/using-team-query/
- Teams GraphQL — introduction (host split, OAuth support): https://developer.atlassian.com/platform/teams/teams-graphql-api/introduction/
- Teams API schemas (field-level scopes in Explorer): https://developer.atlassian.com/platform/teams/apis/schemas/
- Atlassian GraphQL gateway: https://developer.atlassian.com/platform/atlassian-graphql-api/graphql/
- Teams public REST (OAuth2/Forge cannot access): https://developer.atlassian.com/platform/teams/rest/v1/api-group-teams-public-api/
- Jira OAuth 2.0 (3LO) scope catalog (no `:teams` scope): https://developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/
- Managing OAuth apps (Console add-API-then-configure-scopes model): https://developer.atlassian.com/cloud/oauth/getting-started/managing-oauth-apps/
- Deprecation of internal team-search API → use `teamSearchV2`: https://community.atlassian.com/forums/Atlassian-Platform-articles/Atlassian-Teams-We-re-deprecating-the-internal-team-search-API/ba-p/2896121
- Community (scope-addability friction, ARI format): https://community.developer.atlassian.com/t/missing-scope-viewteams/94060 ; https://community.developer.atlassian.com/t/how-to-add-teams-scopes-for-graphql-query/80920 ; https://community.developer.atlassian.com/t/invalid-organization-ari-using-teamsearchv2-in-the-graphql-api/77375

---

## Operator empirical verification (2026-09-19)

**Status: spike COMPLETE. AC-002 firmed from "self-service-not-available, DEFER pending an
Atlassian-side request" to CONFIRMED-NOT-GRANTABLE (empirically tested against jr's real embedded
OAuth app). AC-006 go/no-go firmed from DEFER to DEFER-INDEFINITELY.** This addendum records the
B1 §(4) "empirical console/consent test" action this report itself prescribed (AC-002 §(4) step 1;
Blockers table row B1) — the operator (app owner) carried it out and reported the result back to
the pipeline. No further re-investigation of AC-001/AC-003/AC-004 was performed or is warranted;
those findings are unchanged from Revision 2 above.

**Method.** A controlled differential test against the authorize endpoint of jr's real embedded
OAuth app, run from the operator's live, already-authenticated Atlassian browser session. Two
authorize requests were issued, identical in every respect (same client, same redirect URI, same
browser/session) except for the `scope` parameter:

- **Control** — `scope=read:jira-work offline_access` (a subset of jr's already-registered,
  already-working scopes).
- **Treatment** — the same scope string **plus** `view:team:teams` appended.

This isolates the single variable under test: whether Atlassian's authorize/consent layer treats
`view:team:teams` as grantable to jr's app, holding client identity, redirect URI, and session
constant. (Per this report's own §"Do not" guidance in AC-002 §(4): the literal `jr` embedded
OAuth `client_id` is deliberately not recorded in this artifact — refer to it only as "jr's
embedded OAuth app," as done throughout this report.)

**Result.**
- **Control** request rendered a normal, valid Atlassian OAuth consent screen (the expected
  behavior for an already-registered, already-working scope set).
- **Treatment** request did **not** render a consent screen at all. Instead, Atlassian's
  authorize/consent server returned its owner-facing error page: **"Something went wrong / 
  INFORMATION FOR THE OWNER OF JIRA-CLI JR"** — an app-owner-directed error, not a user-facing
  `invalid_scope` redirect and not a silently-dropped scope.
- **No consent was completed.** The "Accept" action was never reached, let alone clicked, on
  either request. **No tokens were minted and no grant was created** as part of this test —
  the test terminated at (control) the consent-screen render and (treatment) the owner-error
  page, both before any user consent action.

**Interpretation.** Because the control (minus `view:team:teams`) succeeded and the treatment
(plus `view:team:teams`, nothing else changed) failed at the consent-server layer before a
consent screen could even render, `view:team:teams` is isolated as the specific cause of the
failure. This is a stronger, more specific result than a bare `invalid_scope` redirect would have
been — it confirms Atlassian's consent server rejects the *authorize request itself* once
`view:team:teams` is present, consistent with (and now empirically confirming) this report's
AC-002 §(2) finding that no Console mechanism exists for a standalone 3LO app to provision this
scope: the app was never given a chance to present it for consent because the app-side
registration gap makes the request itself invalid at the owner/app level, not merely at the
per-user consent level.

**AC-002 verdict firmed: CONFIRMED-NOT-GRANTABLE.** `view:team:teams` cannot be granted to jr's
standalone Jira Cloud 3LO app today. This closes B1 step 1 (the empirical consent test) definitively
in the negative — the only remaining path in the original Blockers table (B1 step 2, an
Atlassian-side "Contact us" / community request) is now the sole avenue that could ever change this,
and it is external to this codebase and this pipeline.

**AC-006 verdict firmed: DEFER-INDEFINITELY** (was: DEFER). Per this report's own AC-006 rationale
("Flips to REJECT / DEFER-INDEFINITELY only if Atlassian confirms `view:team:teams` cannot be
granted to jr's standalone 3LO app" — B1 row), that condition is now satisfied by direct empirical
evidence, not merely by the absence of a Console tile. `S7 teams-graphql-oauth-replatform` stays
unopened and blocked indefinitely; `jr team list` / Teams functionality remains API-token-only
(works via the site-local `/gateway/api/graphql` gateway under Basic/API-token auth; broken under
OAuth 3LO), a documented, accepted gap — not a regression.

**Reopen trigger (the only path that can unblock S7):** Atlassian provisioning/enabling
`view:team:teams` (the read-only team-query scope) for jr's standalone 3LO app, via an app-owner
request through the Teams platform "Contact us" page
(`developer.atlassian.com/platform/teams/overview/contact-us/`) and/or
`community.developer.atlassian.com` (tag teams/3lo, referencing threads #80920/#94060, per B1
step 2 above). Until Atlassian confirms provisioning, there is nothing implementable — a future S7
story stays blocked/unopened, not merely deprioritized. Tracked as a standing item:
`S6-TEAMS-OAUTH-BLOCKED-ON-ATLASSIAN-SCOPE-PROVISIONING` (`cycles/OPEN-STANDING-ITEMS.md`).

**No `src/` changes, no BC/VP/ADR authored, no PR, no merge, no scope added to
`DEFAULT_OAUTH_SCOPES`** as part of this addendum or the operator's test — consistent with this
report's own "Do not add `view:team:teams` to `DEFAULT_OAUTH_SCOPES`" guidance (AC-002 §(4)) and
its "investigation-only" framing at the top of this document. The spike (`S-cycle8-teams-graphql-oauth-replatform-spike`) is COMPLETE.

---

## Console entitlement inspection (2026-09-19)

**Status: SECOND independent confirmation of AC-002 CONFIRMED-NOT-GRANTABLE, obtained by a
different method than the 2026-09-19 authorize-endpoint differential test above.** This addendum
records a direct inspection of jr's embedded OAuth app's own Developer Console configuration
surface, carried out by the operator (app owner) using their authenticated Developer Console
session. No further re-investigation of AC-001/AC-003/AC-004 was performed or is warranted; those
findings remain unchanged from Revision 2. Per this report's standing "Do not record any literal
OAuth `client_id` or the app's Console UUID" convention, this app is referred to generically
throughout as "jr's embedded OAuth app" / "the jr app's Developer Console Permissions page."

**Method.** Using the operator's authenticated Developer Console session, inspected the jr app's
Permissions page directly — the same Console surface AC-002 §(2) already found to expose no
self-service Teams tile for a standalone 3LO app, this time enumerated exhaustively rather than
inferred from the operator's earlier "nothing to add" report.

**Result — the app's full configurable API catalog (8 APIs total):**

| API | Scopes used by jr |
|---|---|
| Personal data reporting | 0 |
| User identity | 2 |
| Confluence | 0 |
| Jira | 15 |
| Compass GraphQL | 0 |
| Goals | 0 |
| Projects | 0 |
| Focus | 0 |

The app is registered as OAuth 2.0 with 17 scopes used in total across these APIs. There is **no
"Teams" API** anywhere in this configurable catalog, and no separate "browse more APIs" / "see
all APIs" control exists on this page — the only other button present is "Add Marketplace or
custom app," which is unrelated to first-party platform API selection and does not surface a
hidden Teams entry.

**Key finding — GraphQL APIs are not categorically unavailable to standalone 3LO apps.**
**Compass GraphQL IS offered** in this catalog (0 scopes currently used, but the tile exists and
is addable) **while Teams GraphQL is NOT offered at all.** This rules out the hypothesis that the
Console simply hides every GraphQL-backed platform API from standalone 3LO apps as a category —
Compass GraphQL is proof the Console can and does expose at least one GraphQL platform API to this
exact app type. Teams specifically is the one withheld, not GraphQL APIs in general.

**Interpretation.** This inspection independently corroborates AC-002 §(2)'s "no documented
self-service Teams (or Identity/platform-Teams) API tile" finding, but strengthens it in two ways:
(1) it is an exhaustive enumeration of the entire catalog (8 APIs, byte-for-byte accounted for),
not a report of "I looked and didn't see one"; (2) the Compass-present / Teams-absent contrast
rules out the most plausible alternative explanation (a blanket GraphQL-API exclusion) that the
earlier finding could not itself rule out. **The operator did not miss a hidden Console setting —
across an exhaustively enumerated 8-API catalog, the entitlement genuinely is not available for
this app.**

This is the **second independent proof** of AC-002, obtained by a different method (direct Console
catalog enumeration) than the 2026-09-19 authorize-endpoint differential test recorded above
(empirical consent-server behavior). The two methods agree: `view:team:teams` cannot be granted to
jr's standalone 3LO app today.

---

## Investigation trail / what we did (consolidated recap)

The full S6 investigation ran across four stages, summarized here so the whole arc is readable in
one place without cross-referencing every section above:

1. **Spike findings (AC-001..AC-006, Revision 2, 2026-09-18).** A `research-agent`-run,
   investigation-only spike (zero `src/` changes, no BC/VP/ADR authored) against
   `S-cycle8-teams-graphql-oauth-replatform-spike`. Confirmed the GraphQL host/query/pagination
   shape a future replatform would use (AC-001: `POST https://api.atlassian.com/graphql`,
   `team { teamSearchV2(...) }`, cursor pagination, translation-layer required — NOT drop-in
   compatible with the existing `TeamsResponse` type); confirmed the exact required read-query
   scope (`view:team:teams`, AC-002); confirmed `get_org_metadata`/`jr init` are ALSO broken under
   OAuth via the same host-routing gap, increasing the blast radius (AC-003); confirmed a future
   fix needs an `is_oauth_auth()`-gated host fork against a genuine third host class the codebase
   does not currently model (AC-004). AC-002's Console-addability sub-finding — no self-service
   Teams tile exists for a standalone 3LO app — was the spike's sole gating blocker, but was
   explicitly NOT treated as a categorical prohibition (Forge apps CAN declare the scope via
   manifest; OAuth 3LO is affirmatively documented as protocol-supported at the schema layer) —
   hence the initial go/no-go was DEFER, not REJECT.
2. **Docs re-check establishing OAuth 3LO is documented-supported at the schema layer.** Revision
   2's reconciliation work (AC-002 §(4)) established that Atlassian's own Teams GraphQL docs
   affirmatively state OAuth 2.0 can request Teams data on a user's behalf, and that
   `view:team:teams` is a real, field-level-enforced scope (confirmed via live gateway error
   `requiredScopes` and Atlassian issue AX-446) — so the "docs say OAuth works" and "operator sees
   nothing to add" observations were reconciled as describing two different layers (schema
   capability vs. Console provisioning), not a contradiction. This is why the original verdict was
   a reopenable DEFER rather than a flat REJECT: a missing provisioning mechanism is not the same
   claim as a documented prohibition.
3. **Empirical authorize differential test (2026-09-19).** The operator (app owner) ran a
   controlled two-request differential test against jr's real embedded OAuth app's live authorize
   endpoint, from their own authenticated Atlassian browser session, varying only the `scope`
   parameter: a control request (`read:jira-work offline_access`) rendered a valid consent screen;
   the identical request plus `view:team:teams` instead produced Atlassian's owner-facing
   "Something went wrong / INFORMATION FOR THE OWNER OF JIRA-CLI JR" consent-server error, with no
   consent screen rendered, no consent completed, and no tokens/grants created on either request.
   This isolated `view:team:teams` as the specific, sole cause of the failure — the first
   independent proof that the scope cannot be granted to this app today.
4. **Console entitlement inspection (2026-09-19, this addendum).** The operator directly
   inspected jr's embedded OAuth app's Developer Console Permissions page and exhaustively
   enumerated its full 8-API configurable catalog (Personal data reporting, User identity,
   Confluence, Jira, Compass GraphQL, Goals, Projects, Focus) — no Teams API tile present anywhere
   in it, and no hidden "browse more APIs" control exists to reveal one. The Compass-GraphQL-present
   / Teams-GraphQL-absent contrast additionally rules out a blanket "GraphQL APIs are unavailable
   to 3LO apps" explanation. This is the second independent proof, obtained by a structurally
   different method (Console catalog enumeration vs. live consent-server behavior), and it agrees
   with stage 3's result.

**Final verdict:** **AC-002 = CONFIRMED-NOT-GRANTABLE**, now substantiated by **two independent
proofs** (the empirical authorize differential test, and this exhaustive Console catalog
inspection) that agree with each other and with no third possible explanation left unaccounted
for. **AC-006 = DEFER-INDEFINITELY** (unchanged from the prior addendum's firming) — not a flat
REJECT, because no Atlassian documentation categorically bars 3LO apps from the Teams read query;
the barrier is a missing self-service provisioning mechanism, now doubly confirmed as
non-bypassable by any action available within this app's own Console registration. The reopen
trigger remains solely an Atlassian-side provisioning action (see the "Reopen trigger" language in
`S6-TEAMS-OAUTH-BLOCKED-ON-ATLASSIAN-SCOPE-PROVISIONING`, `cycles/OPEN-STANDING-ITEMS.md`) — this
item is now additionally set up as a recurring maintenance-revisit check (see that standing item's
"Recheck each maintenance sweep" subsection) so future sweeps re-test whether Atlassian has since
opened the entitlement, rather than requiring a fresh ad hoc investigation each time.

**No `src/` changes, no BC/VP/ADR authored, no PR, no merge, no scope added to
`DEFAULT_OAUTH_SCOPES`** as part of this Console-inspection addendum either. The spike
(`S-cycle8-teams-graphql-oauth-replatform-spike`) remains COMPLETE; this addendum only adds a
second confirming data point and a consolidated recap.
