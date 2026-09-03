# Research: `/_edge/tenant_info` as a cloudId source for the API-token login path

- **Type:** general (technology / API validation)
- **Cycle / Story:** cycle-004 — `cloud_id-correctness`
- **Date:** 2026-09-03
- **Related issues:** #759, #760 (API-token profiles lack `cloud_id` → Assets/CMDB fail "Cloud ID not configured"); A-PA-LOW-001 (stale cloud_id survives oauth→api_token mechanism switch)
- **Scope:** Validate `GET https://<site>.atlassian.net/_edge/tenant_info` as a cloudId source for the Basic-auth (email + API token) login path; compare official alternatives; recommend the soundest A-PA-LOW-001 fix. Research only — no code changes.

---

## TL;DR / Synthesis

- **Question A — CONFIRM.** `GET https://<site>.atlassian.net/_edge/tenant_info` returns `{"cloudId":"<uuid>"}`. The **only verified field is `cloudId`** (lowerCamelCase, UUID string). `baseUrl`/`activation`/`edition` were **NOT verified** for this endpoint — parse `cloudId` and ignore unknown fields.
- **Question B — CONFIRM (unauthenticated, per-site).** Atlassian's own docs publish a bare `curl` with no auth header. It is per-site (hostname → one cloudId). CORS blocks *browser* `fetch` but is irrelevant to a server-side CLI. **Do NOT append query parameters** (a cache-buster `?_r=…` has been observed to 403). No endpoint-specific rate limit is documented — cache the value.
- **Question C — CONFIRM documented, but PARTIAL on "supported API".** It appears in multiple **official Atlassian support KB + developer guides** (Open DevOps, Automation, Capacity Planning, Backup, Migration) and one Atlassian employee called the URL "supported." It is **NOT** a versioned Jira REST v3 / OpenAPI operation (no schema, error model, rate-limit contract, or deprecation promise). Long operational track record (2020→2026). Risk: **low-to-moderate** — reliable in practice, no contractual SLA. `atlassian-python-api` does **not** use it (verified absence); MeltanoLabs `tap-jira` and many third-party connectors do.
- **Question D — Recommend `/_edge/tenant_info` as primary for the API-token path**, with `accessible-resources` explicitly rejected (OAuth-only) and `serverInfo` rejected (does **not** return cloudId). Fallback: honor explicit `--cloud-id`, and surface a clear actionable error if the fetch fails.
- **Question E — Recommend BOTH (i) clear/refresh cloud_id on mechanism switch AND (ii) guard gateway base-URL selection by auth method — but with a MAJOR correction to a false assumption (see below).**

### ⚠️ False assumption uncovered (affects A-PA-LOW-001 framing)

The A-PA-LOW-001 premise is that "Basic auth to the OAuth `api.atlassian.com/ex/jira/{cloudId}` gateway → 401." **As of 2026 this is only true for CLASSIC/unscoped API tokens.** Atlassian has shipped **scoped API tokens** that authenticate over **HTTP Basic** *at that very gateway* — `curl --user email:scoped-token https://api.atlassian.com/ex/jira/{cloudId}/rest/api/3/myself` is a documented call that returns **200** when correctly scoped. Notably, **this repo's own issue [Zious11/jira-cli#185] is cited by the research** as reproducing `GET /ex/jira/{cloudId}/rest/api/3/myself` returning 200 with a Basic scoped token (with some write ops returning `401 scope does not match`). So the gateway is **not** categorically Basic-hostile; the failure mode is token-type- and scope-dependent. This does not change the recommendation (jr's own tokens are classic today), but the fix should be justified on *"Basic classic-token callers belong on the site URL"* grounds, not on *"the gateway always rejects Basic."*

---

## Per-question findings

### A. Does `/_edge/tenant_info` return the site's cloudId? Exact JSON shape? — **CONFIRM**

Verified response shape (Atlassian support KB + Open DevOps developer guide):

```json
{"cloudId": "c68adbe0-2b09-4add-b08e-eb5797b31bc9"}
```

- Field name is exactly `cloudId` (lowerCamelCase); value is normally a UUID string.
- Atlassian's Open DevOps guide parses only `.cloudId`:
  ```bash
  export CLOUD_ID=$(curl "${JIRA_BASE_URL}/_edge/tenant_info" | jq --raw-output '.cloudId')
  ```
- **Fields NOT verified for this endpoint:** `baseUrl`, `activation`, `edition`, or any other key. Every current verified example is a **single-key object**. The `baseUrl`/`edition` fields the question asked about appear in *other* Atlassian structures (Connect install payload, Confluence system-info, the unrelated Jira Server `TenantInfo` Java class) and must not be conflated with this endpoint.
- **Implication for jr:** deserialize into a struct with only `cloud_id: String` and `#[serde(...)]` tolerance for unknown fields (serde ignores unknown fields by default). Do not depend on any second field.

Sources: Atlassian support KB "Retrieve my Atlassian site's cloud ID" (support.atlassian.com/jira/kb/retrieve-my-atlassian-sites-cloud-id/); Atlassian Open DevOps guide (developer.atlassian.com/cloud/jira/software/getting-started-open-devops/); Atlassian Community 3218463, 2387064.

### B. Truly unauthenticated, per-site? CORS/CSRF/rate-limit for a CLI caller? — **CONFIRM (unauthenticated, per-site)**

| Constraint | Finding for a server-side CLI |
|---|---|
| Authentication | Bare unauthenticated GET is the documented normal usage — Atlassian's own example sends no `Authorization`, cookie, or CSRF token. The returned cloudId is not a secret. |
| Per-site | Yes — hostname `https://<site>.atlassian.net/_edge/tenant_info` returns that one site's cloudId (does not enumerate all sites for a user). |
| CORS | Browser `fetch` is unreliable (one report: direct/backend worked, browser `fetch` blocked by CORS). **Irrelevant to a CLI** — CORS is browser-enforced only. |
| CSRF | No CSRF token needed (read-only GET; Atlassian's bare-curl example supplies none). No explicit CSRF contract published, but empirically none required. |
| Query params | **Avoid them.** A community report saw `AP.context()` append `?_r=<ts>` → **403**; bare URL worked. Use the exact path, no query string. |
| Rate limits | **No endpoint-specific limit documented.** Do not infer a numeric quota. Cache the cloudId; retry 429/5xx conservatively. |
| Methods | Only GET evidenced; `Accept: application/json` sensible but not required. Handle redirects, 401/403/404 for suspended/moved/invalid hostnames. |

Recommended CLI call shape (adapt to reqwest):
```
GET https://<site>.atlassian.net/_edge/tenant_info
Accept: application/json
# no Authorization header, no query string, short timeout
```
Do **not** attach the API token — it is unnecessary and needlessly exposes the credential to an endpoint that does not need it.

Sources: Atlassian Open DevOps guide; Atlassian Community 2575181 (403-on-query-param, CORS report), 3218463; Nexla connector docs (states auth unnecessary).

### C. Officially documented or internal? Who uses it? Long-term risk? — **CONFIRM documented / PARTIAL on "supported public API"**

- **Official Atlassian coverage (multiple):** support KB "Retrieve my … cloud ID"; Open DevOps developer guide (uses it programmatically); Automation API base-paths guide; Capacity Planning auth guide; Backup Management guide; Migration/update-links guide. An Atlassian Team member on the Community called it a "supported URL."
- **Not a versioned REST API:** no OpenAPI operation, schema, documented status/error model, endpoint-specific rate limit, changelog, or deprecation contract. Some (non-employee) community posts call it "outside the supported API" and prefer OAuth `accessible-resources` — reconcile as: *Atlassian documents & recommends it as a lookup mechanism, but has not made it a conventional versioned public REST API.*
- **Third-party usage:** MeltanoLabs `tap-jira` documents + uses it (shows the one-field response); numerous vendor connectors (Ambientia, DX, Nexla, ServiceNow, Elastic, Google Cloud) repeat the same lookup. **`atlassian-python-api` does NOT use it** (verified: no `tenant_info`/`cloudId`/`cloud_id`/`accessible-resources` matches in its REST client source). Forge exposes `context.cloudId` natively so Forge apps rarely need it.
- **Stability track record:** referenced since May 2020; in Atlassian docs since ~2021; still published across support + developer pages in 2026. Good operational longevity, no contractual guarantee.
- **Risk assessment: LOW-to-MODERATE.** Practically reliable and Atlassian-documented; the residual risk is the absence of a versioned-API stability promise. Mitigate by: (a) treating a failed/changed response as a soft failure with an actionable error + `--cloud-id` fallback, (b) parsing defensively (only `cloudId`, ignore unknown fields), (c) caching per profile.

Sources: as above, plus Atlassian Community 3218463 (employee "supported URL" vs non-employee "unsupported" debate); github.com/MeltanoLabs/tap-jira; github.com/atlassian-api/atlassian-python-api (verified absence).

### D. Official alternatives for the API-token path — comparison & recommendation

| Candidate | Auth required | Auth type | Officially documented? | Returns cloudId? | Verdict |
|---|---|---|---|---|---|
| `api.atlassian.com/oauth/token/accessible-resources` | Yes | **OAuth 2.0 Bearer only** | Yes (as an OAuth op) | Yes, as `id` (array of sites) | **REJECT for API-token path** — Basic auth not supported/documented; requires an OAuth access token jr's API-token profiles don't have. |
| `<site>.atlassian.net/rest/api/3/serverInfo` | No (anonymous) | None | Yes (v3 reference) | **No** — returns `baseUrl`, version/build, locale, times, title; **no cloudId** | **REJECT** — does not carry cloudId (confirmed by official schema + community report). |
| `<site>.atlassian.net/_edge/tenant_info` | No | None | Yes (KB + dev guides; not versioned REST) | **Yes**, `{"cloudId":…}` directly | **RECOMMEND (primary)** — maps known hostname → exactly one cloudId, no OAuth, no credentials, returns the field directly. |
| `/rest/api/3/tenantInfo` (hypothetical REST op) | — | — | **No such operation exists** | — | **N/A** — not in Jira REST v3. |

**Recommendation for the API-token path:** use `GET https://<site>.atlassian.net/_edge/tenant_info`, parse `.cloudId`, persist it into `ProfileConfig.cloud_id`.

**Fallback chain (ordered):**
1. Explicit `--cloud-id <uuid>` flag (highest precedence, already honored).
2. `/_edge/tenant_info` fetch during `auth login` (API-token path) and during `jr init`.
3. On fetch failure: do **not** hard-fail login (login should still succeed for core Jira ops on the site URL). Persist no cloud_id, and have Assets/CMDB commands emit the existing "Cloud ID not configured — run `jr auth refresh` or pass `--cloud-id`" style actionable error.

This directly resolves #759/#760: the API-token login path currently only honors an explicit `--cloud-id` and never fetches, so Assets/CMDB fail. Adding the `/_edge/tenant_info` fetch on the Basic-auth login path (mirroring what OAuth login gets from `accessible-resources`) closes the gap.

Sources: developer.atlassian.com Jira REST v3 server-info group (serverInfo schema, no cloudId); developer.atlassian.com OAuth "making calls to api" (accessible-resources is Bearer); Atlassian Community 2575181; the A-question sources for tenant_info.

### E. A-PA-LOW-001 — stale cloud_id after oauth→api_token switch → recommended fix

**The bug:** a profile that switched from OAuth to API-token retains the OAuth-era `cloud_id`, so the client keeps selecting the `api.atlassian.com/ex/jira/{cloudId}` gateway base URL and sends **Basic** auth to it → failure for a classic token.

**Critical fact affecting the framing (verified, and a correction to the ticket's premise):**
- The `api.atlassian.com/ex/jira/{cloudId}` gateway is **NOT** OAuth-Bearer-only as of 2026. Atlassian supports **scoped API tokens over HTTP Basic** at that gateway (`curl --user email:scoped-token .../rest/api/3/myself` → 200 when scoped correctly). **This repo's issue #185 is cited as an in-the-wild reproduction** of a Basic scoped token returning 200 at the gateway (some writes → `401 scope does not match`).
- **Classic/unscoped API tokens** (what jr issues/stores today) are documented to use the **site URL** (`<site>.atlassian.net/rest/api/3/...`), and Atlassian does **not** guarantee classic-token auth at the gateway. So for jr's current token type, the site URL is the correct target; the gateway would be wrong.
- Therefore the observed 401 is real for jr's classic-token case, but the *reason* is "classic Basic tokens belong on the site URL," not "the gateway categorically rejects Basic." Do not encode the false blanket assumption into code or comments.

**Recommended fix: BOTH (i) and (ii) — defense in depth.**

- **(ii) Guard the base-URL selection by auth method (primary, most robust).** The gateway base URL (`api.atlassian.com/ex/jira/{cloudId}`) should be selected **only when `auth_method == oauth`**. For the API-token/Basic path, route Jira REST v3 through the **site URL** regardless of whether a `cloud_id` happens to be present. This makes a stale cloud_id inert for the request path and is correct for jr's classic tokens today. This is the load-bearing guard — it fixes the symptom deterministically even if state cleanup is imperfect.
- **(i) Clear/refresh cloud_id on mechanism switch (secondary, keeps state honest).** On an oauth→api_token switch, either clear `cloud_id` and re-fetch it via `/_edge/tenant_info` (Question D), or refresh it. This keeps Assets/CMDB working after the switch (they need a valid cloud_id for the workspace-scoped `api.atlassian.com/.../jsm/assets/...` calls — see below) and avoids a stale OAuth-tenant value lingering. Prefer **refresh over bare-clear** so Assets keeps functioning: fetch the fresh cloudId for the site during the switch.

**Important nuance for Assets/CMDB (do not over-apply guard (ii)):**
- Assets/CMDB is a genuine exception: even for **Basic API-token** auth, the actual Assets object/schema/AQL calls are documented on the **gateway** — `https://api.atlassian.com/ex/jira/{cloudId}/jsm/assets/workspace/{workspaceId}/v1/...` (older docs also show `api.atlassian.com/jsm/insight/workspace/{workspaceId}/v1/...`). Workspace-ID discovery uses the **site URL** (`<site>.atlassian.net/rest/servicedeskapi/assets/workspace`). So Assets legitimately needs a valid `cloud_id` **and** reaches `api.atlassian.com` even on the API-token path.
- Consequence: guard (ii) should scope "gateway only when OAuth" to the **core Jira REST v3** base-URL selection, **not** to the Assets base URL. Assets must continue to use the gateway with a *correct, fresh* cloud_id under Basic auth — which is exactly why fix (i) (refresh, not just clear) matters: clearing cloud_id without re-fetching would break Assets on API-token profiles.

Net recommendation: **(ii)** to make core-Jira requests immune to a stale/absent cloud_id, plus **(i) as refresh** to keep Assets/CMDB working and state accurate after the switch.

Sources: support.atlassian.com/atlassian-account/docs/manage-api-tokens (scoped tokens Basic at gateway); support.atlassian.com/atlassian-cloud/kb/401-unauthorized-error-when-service-account… (myself → 200 with scoped Basic); developer.atlassian.com Jira REST v3 intro (Basic → site URL, OAuth → gateway); developer.atlassian.com/cloud/assets/assets-rest-api-guide/workflow/ (Assets Basic auth + gateway calls + site-URL workspace discovery); community.developer.atlassian.com 98624 (scoped-token URL correction); github.com/Zious11/jira-cli/issues/185.

---

## Assumptions that turned out false / need correction

1. **"Basic auth to `api.atlassian.com/ex/jira/{cloudId}` always 401" — FALSE in general (TRUE only for classic/unscoped tokens).** Scoped API tokens authenticate over Basic at the gateway (200 on `/myself`). jr uses classic tokens today, so the site URL is still correct for jr, but justify the fix on token-type grounds, not a blanket gateway rule.
2. **"`serverInfo` might give cloudId" — FALSE.** `serverInfo` returns `baseUrl`/version/locale, never `cloudId`.
3. **"`accessible-resources` could work for API-token users" — FALSE.** It is OAuth-Bearer-only; unusable on the Basic path.
4. **"`/_edge/tenant_info` returns baseUrl/activation/edition too" — UNVERIFIED.** Only `cloudId` is confirmed. Parse only that field.
5. **"Assets can be reached entirely via the site URL with an API token" — FALSE.** Workspace discovery is site-URL, but the actual Assets data calls are gateway-hosted (`api.atlassian.com/.../jsm/assets/...`) even under Basic auth.

## Unverifiable / flagged

- Exact HTTP status `/_edge/tenant_info` returns for suspended/moved/deleted/enterprise-auth-gated sites (handle 401/403/404/redirect defensively).
- Any endpoint-specific rate limit for `/_edge/tenant_info` (none documented; cache).
- Whether classic/unscoped tokens are *guaranteed to fail* at the gateway (Atlassian neither guarantees nor prohibits; treat as unsupported → use site URL).
- Presence of any second field in the `/_edge/tenant_info` payload (none found; do not depend on one).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | (1) tenant_info shape/auth/CORS/documentation status & tooling adoption; (2) cloudId-source comparison for Basic-auth (accessible-resources vs serverInfo vs tenant_info); (3) gateway auth for API tokens (classic vs scoped), correct base URLs, Assets/CMDB base URLs — the A-PA-LOW-001 core facts |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 1 area | General Atlassian auth model framing only; every load-bearing claim is sourced to web findings above and flagged where unverified. |

**Total MCP tool calls:** 3 (all `perplexity_research`, high depth)
**Training data reliance:** low — verdicts rest on Atlassian official docs (support KB, developer guides, REST v3 reference) and cross-checked community/GitHub sources; unverifiable items are explicitly flagged.
