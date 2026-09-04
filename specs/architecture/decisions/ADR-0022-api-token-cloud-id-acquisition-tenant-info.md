---
document_type: adr
adr_id: ADR-0022
status: Accepted
date: 2026-09-03
subsystems_affected: ["SS-02", "SS-03", "SS-04", "SS-08"]
supersedes: null
superseded_by: null
related: ["ADR-0005", "ADR-0020"]
---

# ADR-0022: API-Token `cloud_id` Acquisition via `/_edge/tenant_info`, and the A-PA-LOW-001 Guard

## Status

**Accepted** (2026-09-03). Gate: F2 spec evolution for the `windows-correctness` bundle
(Feature Mode cycle-004; issue #760's cross-cutting `cloud_id` observation, F1 delta analysis
§11; the previously-tracked `A-PA-LOW-001` finding). Scope per the F1 human gate: this ADR
covers BOTH the documentation-caveat framing from #760 AND the underlying fetch-and-persist
fix, since the F1 delta analysis flagged them as materially entangled (#759's fix pushes more
Windows users onto the API-token path, amplifying #760's `cloud_id` gap) and the fetch
mechanism is small, well-scoped, additive work with no dependency on ADR-0021.

## Context

An API-token (`auth_method = "api_token"`) profile never acquires a `cloud_id`. The OAuth login
flow (`oauth_login`, `src/api/auth.rs`) discovers it for free via the
`accessible-resources` step and persists it into `ProfileConfig.cloud_id`
(`src/cli/auth/login.rs::login_oauth`); `login_token` has no equivalent step and never touches
`cloud_id` at all. Every Assets/CMDB command against an API-token profile therefore fails with
the existing, otherwise-correct `"Cloud ID not configured. Run \"jr init\" to set up your
instance."` error (`src/api/client.rs::get_assets`/`post_assets`) — even immediately after a
"successful" `jr auth login`. #759's fix (ADR-0021) makes this worse in practice, not better: it
forces more Windows users who previously hit the OAuth-login bug onto the very API-token path
that has always had this gap.

Research (`.factory/research/edge-tenant-info-cloudid-2026-09-03.md`) confirms
`GET https://<site>.atlassian.net/_edge/tenant_info` returns `{"cloudId": "<uuid>"}`,
requires **no authentication**, is **per-site**, and is documented across multiple official
Atlassian support/developer guides (not a versioned REST v3 operation, but with a stable
multi-year operational track record — Question C, "CONFIRM documented / PARTIAL on 'supported
public API'"). `accessible-resources` (OAuth-Bearer-only) and `serverInfo` (no `cloudId` field
at all) are both confirmed unusable for the Basic-auth path (Question D).

The research also surfaces, and corrects, the premise behind `A-PA-LOW-001` (a stale `cloud_id`
surviving an oauth→api_token mechanism switch): the failure this finding names is real, but the
underlying claim — "the `api.atlassian.com/ex/jira/{cloudId}` gateway rejects Basic auth
categorically" — is **false as stated**. Atlassian's scoped API tokens authenticate over Basic
at that same gateway; this repository's own issue **#185** is cited by the research as an
in-the-wild reproduction of exactly that (`GET /ex/jira/{cloudId}/rest/api/3/myself` → 200 with
a Basic scoped token). `jr` issues/stores **classic** tokens today, for which the site URL is
the documented, correct target — so the practical fix is unchanged, but must be justified as
"classic Basic tokens belong on the site URL," never as a blanket "gateway rejects Basic" rule,
so this reasoning is not later encoded into code comments or user-facing text as a falsehood.

**Pass-1 adversarial-review correction (2026-09-03, Finding #1) — the Assets/CMDB claim, scoped
honestly.** The gateway-Basic-auth confirmation above (issue #185, `/myself` → 200) is evidenced
for a **scoped** API token only. The research does **not** independently confirm that a
**classic** token — the type `jr` issues and stores today — succeeds at the gateway for ANY
endpoint, Assets/CMDB included. The research's "Important nuance for Assets/CMDB" paragraph
(`.factory/research/edge-tenant-info-cloudid-2026-09-03.md` §E, and Assumption #5 in that same
document's "Assumptions that turned out false / need correction" list) states that Assets data
calls are gateway-hosted under "Basic API-token auth" **generically**, without distinguishing
classic from scoped — that is the research's own unverified generalization, not a confirmed
classic-token result. Atlassian documents classic tokens as belonging on the site URL and does
**not** guarantee classic-token Basic auth anywhere on `api.atlassian.com`.

**Consequence, stated plainly:** acquiring a `cloud_id` for an API-token profile has exactly ONE
**guaranteed** benefit — closing A-PA-LOW-001 by ensuring a correct, fresh `cloud_id` is
persisted, so core Jira REST v3 stays unaffected either way (via the confirmed
`auth_method == "oauth"` guard, below) and any Assets/CMDB attempt is tied to the right tenant
instead of a stale/wrong one, producing either a genuine response or a clean, cloud_id-specific
error rather than a silent wrong-tenant misdirection. It is explicitly **NOT** a guarantee that
Assets/CMDB succeeds under `jr`'s classic-token Basic auth at the gateway — that remains
unverified. Neither this ADR nor the BC layer built on it (BC-1.2.054) may present the
Assets-succeeds path as settled or correct; see §4 and Consequences below for how this reframes
the ADR's own claims, and the companion `architecture-delta.md`'s "Pass-1 architect guidance for
product-owner" section for the required BC-1.2.054 rescoping.

A second, load-bearing correction: `Config::base_url()` (`src/config.rs`), read during this F2
pass, **already implements** the auth-method-scoped gateway guard research Question E
recommends:

```rust
if let Some(cloud_id) = &profile.cloud_id {
    if profile.auth_method.as_deref() == Some("oauth") {
        return Ok(format!("https://api.atlassian.com/ex/jira/{cloud_id}"));
    }
}
Ok(url.trim_end_matches('/').to_string())
```

A stale `cloud_id` on an `api_token`-method profile is therefore **already inert** for core
Jira REST v3 base-URL selection — this half of A-PA-LOW-001's recommended fix requires **no
new code**. `JiraClient::from_config`'s `assets_base_url` computation
(`src/api/client.rs::from_config`) derives the Assets gateway URL from `profile.cloud_id` alone,
with **no** `auth_method` gate — this remains the *architecturally* correct shape (Assets has no
site-URL alternative for its object/schema/AQL calls; those are gateway-hosted regardless of auth
type per research §D/§E), but **whether that gateway call actually succeeds under `jr`'s
classic-token Basic auth is unconfirmed** (see the Pass-1 correction above). "No `auth_method`
gate" is correct architecture — the gate would need to be an all-or-nothing block on Assets for
API-token profiles, which would be strictly worse — but it is not itself a correctness guarantee
for classic tokens. This ADR's remaining scope is therefore narrower than originally framed: only
the *acquisition* half (fetch-and-persist a fresh `cloud_id` for API-token profiles) is
unimplemented, and its value is scoped to A-PA-LOW-001 closure, not an Assets-success guarantee.

## Decision

### 1. New module: `src/api/jira/tenant.rs`

A single function, following the existing product-namespaced `api/jira/` convention
(mirrors `api/jira/teams.rs`'s role for OAuth's GraphQL-based `cloudId`/`orgId` discovery,
ADR-0005 — this is the API-token-path sibling of that discovery mechanism, for a different
endpoint):

```rust
/// Fetch the cloudId for a Jira Cloud site via the unauthenticated,
/// per-site `/_edge/tenant_info` endpoint. Used by the API-token login
/// path, which has no `accessible-resources`-equivalent discovery step
/// (that endpoint is OAuth-Bearer-only).
///
/// No Authorization header is attached — the endpoint does not need one,
/// and attaching a credential here would needlessly expose it to a
/// lookup that doesn't require it. No query string is appended (a
/// trailing `?_r=...` cache-buster has been observed to 403 — research
/// doc §B). Only the `cloudId` field is parsed; any other field in the
/// response is ignored (serde default — do not add strict/deny-unknown
/// deserialization here).
///
/// **Pass-4 adversarial-review correction (2026-09-03, Finding #4) — HTTPS
/// is required.** `site_url` must start with `https://` (case-insensitive)
/// or the lookup is skipped without making any network call, returning an
/// `Err` that flows into the identical soft-fail path as any other fetch
/// failure (§2 step 3). Without this, an `http://`-configured profile
/// would send this GET in plaintext, letting an on-path attacker return a
/// well-formed `{"cloudId": "<attacker-chosen-uuid>"}` that gets
/// persisted — a wrong-tenant Assets/CMDB misdirection. Impact was already
/// bounded (`cloud_id` is non-secret, and `Config::base_url()`'s
/// `auth_method == "oauth"` guard makes a stale/wrong value inert for core
/// Jira REST v3 on an api_token profile — see Context/§4), but there is no
/// cost to closing it outright: every real Jira Cloud site is `https://`,
/// so this check never fires in normal operation.
pub async fn fetch_cloud_id(site_url: &str) -> anyhow::Result<String> {
    if !site_url.trim().to_ascii_lowercase().starts_with("https://") {
        anyhow::bail!("tenant_info lookup skipped: site URL does not use https://");
    }
    #[derive(serde::Deserialize)]
    struct TenantInfo {
        #[serde(rename = "cloudId")]
        cloud_id: String,
    }
    let url = format!("{}/_edge/tenant_info", site_url.trim_end_matches('/'));
    let client = reqwest::Client::builder()
        .timeout(std::time::Duration::from_secs(10))
        .redirect(reqwest::redirect::Policy::none())
        .build()?;
    let response = client.get(&url).send().await?;
    if !response.status().is_success() {
        anyhow::bail!("tenant_info lookup failed: HTTP {}", response.status());
    }
    let info: TenantInfo = response.json().await?;
    Ok(info.cloud_id)
}
```

This is a plain `reqwest` call, not routed through `JiraClient` — mirroring `oauth_login`'s own
direct-`reqwest` calls to `accessible-resources` in `src/api/auth.rs`, since a `JiraClient`
cannot yet be constructed at login time (no `cloud_id`/auth header exists yet for the profile
being created).

**No-redirect policy, explicit (Finding #12, Pass-1 review).** `reqwest::Client`'s default
redirect policy follows up to 10 cross-host 3xx hops transparently. For an unauthenticated,
per-site lookup like this one, that default is a real risk: a redirect from
`<site>.atlassian.net/_edge/tenant_info` to an attacker- or third-party-controlled host could
deliver a well-formed `{"cloudId": "<uuid>"}` that `fetch_cloud_id` would then persist as if it
were the caller's own tenant's ID, silently pointing subsequent Assets/CMDB (and, transitively,
any future OAuth-gateway) calls at the wrong tenant. `fetch_cloud_id` therefore disables
redirects entirely (`redirect::Policy::none()`); a 3xx response is then just a non-2xx status,
which the existing `!response.status().is_success()` check already turns into the ordinary
soft-fail path (§2 step 3) — no separate redirect-detection branch is needed. This is a same-host
concern only for the redirect target; it does not restrict `site_url` itself, which is already
the profile's own configured, user-supplied instance URL.

**Proxy/TLS-config divergence, accepted explicitly (Finding #14, Pass-1 review).**
`fetch_cloud_id`'s bare `reqwest::Client::builder()` (timeout and redirect policy only) does not
inherit any proxy or custom-CA configuration `JiraClient` may apply elsewhere in the codebase.
This is **not a new divergence** this ADR introduces — `oauth_login`'s pre-existing direct-
`reqwest` call to `accessible-resources` (the precedent this design deliberately mirrors, above)
has the identical property, since neither call site can construct a `JiraClient` before a
`cloud_id`/auth header exists for the profile being created. **Consequence, stated explicitly:**
in a proxy or custom-CA environment where authenticated Jira REST calls succeed (because
`JiraClient` is correctly configured for that environment) but this bare client is not,
`fetch_cloud_id` will silently soft-fail (§2 step 3) — the user sees no `cloud_id` acquired and
no proxy/CA-specific diagnostic, only the pre-existing "Cloud ID not configured" message if they
later attempt Assets. **Accepted for this cycle** on consistency-with-precedent grounds:
introducing a one-off proxy/CA-aware client for this single call site would be a larger,
differently-scoped change than this cycle covers, and would leave `oauth_login`'s existing call
still divergent. The underlying gap — no shared, reusable HTTP-client-configuration builder for
pre-auth call sites — is a tracked follow-up for a future cycle, not resolved here, and applies
equally to both call sites.

### 2. Fallback chain, wired into `login_token`

`src/cli/auth/login.rs::login_token` gains the fetch as a **best-effort, non-blocking** step,
matching the ordered fallback chain the research recommends:

1. **Explicit `--cloud-id <uuid>`** (highest precedence). The `--cloud-id` flag already exists
   on the shared `Login`/`Refresh` CLI variant (`src/cli/mod.rs`) and is already wired to
   `login_oauth`'s `cloud_id_override` parameter — it is currently **silently ignored** on the
   API-token branch (`handle_login` calls `login_token(&target, args.email, args.token,
   args.no_input)`, dropping `args.cloud_id` entirely). `login_token` gains a
   `cloud_id_override: Option<&str>` parameter, symmetric with `login_oauth`'s, and
   `handle_login`'s dispatch is updated to pass `args.cloud_id.as_deref()` through on both
   branches.

   **Call-site inventory, corrected (Pass-3 adversarial review, Finding #2, refresh.rs is an
   unlisted `login_token` caller).** `login_token` gaining a new parameter is a compile-forcing
   signature change — EVERY existing call site must be updated, and this ADR's original text
   named only `handle_login`. A second, direct call site exists: `src/cli/auth/refresh.rs::
   refresh_credentials` (~line 177: `login_token(&target, args.email, args.token,
   args.no_input).await`). `RefreshArgs` (`src/cli/auth/refresh.rs`) has no `cloud_id` field and
   `auth refresh` wires no `--cloud-id` override to either flow today — its existing sibling call
   on the very same function, `login_oauth(&target, args.client_id, args.client_secret, None,
   args.no_input)`, already hardcodes `None` for `login_oauth`'s own `cloud_id_override`
   parameter. `refresh_credentials`'s updated `login_token` call follows the identical, already-
   established precedent: `login_token(&target, args.email, args.token, None,
   args.no_input).await` — a hardcoded `None`, no new `RefreshArgs` field, no CLI change. This
   keeps `--cloud-id` override support symmetric across both flows on `auth refresh` (neither
   supports it today; neither gains it here) rather than adding override capability to only one.
2. **`/_edge/tenant_info` fetch**, using the profile's `url` (already resolved by
   `prepare_login_target` before `login_token` runs — see the existing comment at
   `login_token`'s call site). Runs only when no explicit override was supplied.
3. **Soft-fail.** On fetch failure (network error, non-2xx, malformed body): `login_token`
   does **not** abort the login. It emits a single `eprintln!` diagnostic (human mode only,
   matching the Output-channels convention — never on stdout) and leaves `p.cloud_id` as
   whatever it already was (`None` for a brand-new profile; the prior value untouched for an
   existing one — see §3 below for why "untouched," not "cleared," is correct here). The
   existing `"Cloud ID not configured. Run \"jr init\" to set up your instance."` error at
   Assets/CMDB call sites remains the user's actionable path if Assets is ever attempted.

**Decision: `jr auth refresh` on an api_token profile DOES trigger the tenant_info fetch, on
every invocation — intentional, not an oversight (Pass-3 adversarial review, Finding #2).**
Because `refresh_credentials` calls `login_token` directly (same function as `handle_login`, no
bypass parameter, per the call-site fix above), and `login_token`'s fallback chain always
attempts the fetch when no override is supplied, every `jr auth refresh` on an api_token profile
now performs one `/_edge/tenant_info` GET, identical in shape to `auth login`/`jr init`. Reasons
this is the correct behavior, not a gap to close:
- It is the design §3 below already depends on. The A-PA-LOW-001 refresh-not-clear fix relies on
  `login_token` re-acquiring `cloud_id` on **every** invocation it participates in, not only
  brand-new-profile creation — carving out `refresh` as a fetch-skipping special case would
  require a new bypass parameter threaded through `login_token` purely to distinguish "this call
  came from `refresh`" from "this call came from `login`/a mechanism switch," reintroducing the
  named-switch-detection complexity §3's design deliberately avoids, for a different call site.
- The cost is bounded and already priced into this ADR's accepted trade-offs (see Consequences,
  updated below): a 10-second-timeout, soft-fail, no-redirect lookup. `auth refresh` is an
  explicit, user-invoked, low-frequency credential-rotation command — comparable in call frequency
  to `auth login`, not a per-command hot path — so extending the existing accepted cost to it is
  consistent, not an expansion in kind.
- A freshly-fetched `cloud_id` is never worse than the value refresh would otherwise leave in
  place, for the same reason ADR-0022 §3 already gives for the mechanism-switch case: core Jira
  REST v3 is unaffected either way (`Config::base_url()`'s `auth_method == "oauth"` guard), and a
  fresh value is Assets/CMDB's best available shot regardless of whether the gateway ultimately
  accepts the token (§4/Context).

No additional code is required beyond the call-site fix above — `refresh_credentials`'s direct
`login_token` call gets this behavior for free once it compiles against the new parameter. See the
companion `architecture-delta.md`'s "Pass-3 architect guidance for product-owner and
formal-verifier" section for the required BC-1.2.052 Invariant 3 wording (it currently enumerates
only `auth login`/`jr init` as fetch trigger sites and omits `auth refresh`).

`jr init`'s interactive picker (`src/cli/init.rs`) invokes the same `login_token`/`fetch_cloud_id`
plumbing for its API-token branch — it must not grow a second, independent tenant_info call
site. The exact wiring inside `init.rs` (which today calls into the same login helpers used by
`jr auth login`) is an F3/F4 story-authoring detail, not re-derived here; the constraint this
ADR fixes is "one fetch function, one set of fallback rules, called from both entry points."

### 3. A-PA-LOW-001 — refresh, not bare-clear, on an oauth→api_token mechanism switch

Because `login_token` now unconditionally attempts the tenant_info fetch (or honors an explicit
`--cloud-id`) on **every** invocation — not only brand-new-profile creation — the "stale
cloud_id after a mechanism switch" defect is closed as a direct consequence of §2's wiring, with
no separate switch-detection code needed: `handle_login`'s existing mechanism-switch dispatch
(`src/cli/auth/login.rs::handle_login`, the `switching`/`current_auth_method` logic that already
calls `login_token` on the incoming leg of an oauth→api_token switch) now always re-acquires
`cloud_id` for the target profile as part of that same call. On fetch success, the fresh value
overwrites whatever the profile held before (including a stale OAuth-era value). On fetch
failure, the **prior** value is left in place — deliberately a refresh-with-fallback-to-existing,
never a bare clear:
- The existing value cannot make anything *worse* than it already was: `Config::base_url()`'s
  `auth_method == "oauth"` guard (confirmed already in place, see Context) already makes a
  stale `cloud_id` inert for core Jira REST v3 on an `api_token`-method profile.
- Assets/CMDB requires a *correct* `cloud_id` to even attempt its gateway calls, regardless of
  `auth_method` — whether those calls then succeed under classic-token Basic auth at the gateway
  is a separate, unconfirmed question (see Context's Pass-1 correction). A fresh `cloud_id` is a
  strict precondition for any chance of Assets working and is never worse than a stale one: a
  possibly-stale-but-present value is at least as good as an unconditional clear, which would
  guarantee Assets cannot even attempt its calls. A site's `cloudId` essentially never changes for
  a fixed hostname in practice, so refresh rarely differs from the prior value — but "rarely
  differs" is not "confirmed to work."

No new "mechanism switch" detection code is added to `client.rs` or `config.rs` — the fix lives
entirely in `login_token` gaining the fetch step, called at the point mechanism switches
already flow through.

### 4. `Config::base_url()`'s existing auth-method guard is confirmed correct and unchanged

Verified directly against `src/config.rs::base_url` during this F2 pass (see Context, quoted
inline): the gateway URL (`https://api.atlassian.com/ex/jira/{cloud_id}`) is already selected
**only** when `profile.auth_method.as_deref() == Some("oauth")`; any other `auth_method`
(including `api_token`, and including an unset/`None` `auth_method`, which defaults to
api-token elsewhere per `JiraClient::from_config`'s `unwrap_or("api_token")`) falls through to
the site URL, `cloud_id` or not. **No change to this function is part of this ADR's scope.**
This ADR's contribution is documenting this as a deliberately-verified invariant (so it is not
mistakenly "fixed" a second time by a future pass that hasn't read this ADR) and confirming
`assets_base_url`'s deliberate NON-gating by `auth_method` (§ Context) remains the correct
*architectural* shape — Assets has no site-URL alternative for its data calls, so gating it by
`auth_method` would only ever make things worse. This is **not** a claim that Assets calls
succeed under classic-token Basic auth at that gateway; that remains unconfirmed (Pass-1
correction, Context, and Consequences below).

## Rationale

- **`/_edge/tenant_info` over the alternatives** is the only candidate that is unauthenticated,
  per-site, and returns `cloudId` directly — `accessible-resources` requires an OAuth Bearer
  token the API-token path structurally does not have, and `serverInfo` does not carry
  `cloudId` at all (research Question D, both REJECTed explicitly).
- **Soft-fail, never hard-fail, on fetch failure** — core Jira operations (issue list/view/
  comment, etc.) do not need `cloud_id` at all; blocking a successful Basic-auth login on an
  ancillary Assets-enablement lookup would regress every user who doesn't touch Assets/CMDB, for
  a lookup this ADR's own research flags as undocumented-as-a-versioned-API (LOW-to-MODERATE
  risk, not zero).
- **Refresh-not-clear on mechanism switch** directly serves DEC-334's family of decisions in the
  companion ADR-0021: minimize collateral breakage from a fix, prefer "the previous value stays
  usable" over "guarantee a regression to force correctness," since the previous value is either
  already-inert (core Jira, confirmed) or no worse than the fresh value for Assets — whose actual
  success under classic-token Basic auth at the gateway is unconfirmed either way; refresh cannot
  make that worse, and gives Assets its best available shot at a correct `cloud_id`.
- **Confirming `base_url()`'s existing guard rather than re-implementing it** avoids introducing
  a second, redundant auth-method check that could drift from the first — a well-known source of
  the exact "two implementations of one invariant silently diverge" bug class this codebase's
  own history (ADR-0007) explicitly warns against.
- **Requiring `https://` for the tenant_info lookup (Pass-4 review, Finding #4)** closes a real,
  if bounded, on-path plaintext tenant-misdirection vector at zero cost in normal operation —
  every real Jira Cloud site is already `https://`, so the check is a no-op for every legitimate
  user and only ever fires for a misconfigured or deliberately-downgraded `site_url`.

## Consequences

### Positive
- API-token profiles gain a working `cloud_id` acquisition path, closing #760's cross-cutting
  observation and the amplification #759's fix (ADR-0021) creates by pushing more users onto
  this path.
- A-PA-LOW-001 closes with a smaller diff than its original framing implied — half the fix
  (the gateway guard) is discovered to already exist; only the acquisition half is new work.
- Reuses the existing `--cloud-id` flag's plumbing (already present, already documented in
  `src/cli/mod.rs`) rather than inventing a second flag or config key.
- Closes a plaintext on-path tenant-misdirection vector for the tenant_info lookup itself by
  requiring `https://`, at zero cost to any real Jira Cloud user (Pass-4 review, Finding #4).

### Negative / Trade-offs
- **This ADR does NOT establish that Assets/CMDB succeeds for `jr`'s classic API tokens at the
  gateway.** The guaranteed benefit of `cloud_id` acquisition is closing A-PA-LOW-001 — a
  correct, fresh value persisted; core-Jira requests unaffected either way per the confirmed
  `auth_method == "oauth"` guard. Whether the Assets gateway
  (`api.atlassian.com/ex/jira/{cloudId}/jsm/assets/...`) accepts classic-token Basic auth at all
  is **unconfirmed** — the research's supporting evidence (issue #185) is for a **scoped** token
  only (`.factory/research/edge-tenant-info-cloudid-2026-09-03.md` §E, Assumption #5). If Assets
  genuinely requires a scoped token, acquiring `cloud_id` alone delivers zero Assets benefit for
  `jr`'s current token type. The BC/story layer must not describe Assets success as an expected
  outcome of this fix. (Pass-1 adversarial review, Finding #1.)
- `/_edge/tenant_info` is documented across multiple official Atlassian sources but is **not** a
  versioned REST v3 operation with a schema/error-model/rate-limit/deprecation contract
  (research Question C). `jr` now has a soft runtime dependency on an endpoint Atlassian could
  change without the usual API-versioning notice — mitigated by soft-fail (a broken endpoint
  degrades Assets discovery, not core functionality) and by parsing only the one confirmed field.
- One additional unauthenticated HTTP round-trip on every `jr auth login`/`jr init` API-token
  invocation, **and on every `jr auth refresh` invocation against an api_token profile** (Pass-3
  adversarial review, Finding #2 — an intentional consequence of `refresh_credentials` calling
  `login_token` directly, not a separate gap) — mitigated: 10-second timeout, soft-fail,
  no-redirect policy (Finding #12) — and the value is cached in `ProfileConfig.cloud_id`
  thereafter — not re-fetched on ordinary (non-auth-mutating) Jira commands.
- `fetch_cloud_id` does not share `JiraClient`'s proxy/custom-CA configuration, so it can
  silently soft-fail in environments where authenticated Jira calls otherwise work — accepted for
  consistency with `oauth_login`'s pre-existing identical limitation; see §1's Finding #14 note.
  Tracked as a future-cycle follow-up (shared HTTP-client-config builder for pre-auth call
  sites), not resolved here.
- The mechanism-switch fix (§3) is now implicit in `login_token`'s general behavior rather than
  a named, independently-testable "switch" code path — this trades a slightly less obvious
  code-reading story for zero duplicated logic; the product-owner's BC-authoring pass should
  still write an explicit BC/EC covering the switch scenario so it has its own test, even though
  the implementation has no dedicated branch for it.

### Status as of this ADR (2026-09-03, cycle-004 F2)
**Accepted, not yet implemented.** No `src/` file has changed. `src/config.rs::base_url`'s
auth-method guard was READ and confirmed correct as-is during this pass; it is explicitly
out of this ADR's implementation scope. This ADR is the design F4's `cloud-id-api-token-
autodiscovery` story (if the human confirms this scope at the F2 gate — F1 §13 Q2) implements
against.

## Alternatives Considered

- **`GET /oauth/token/accessible-resources`**: rejected — OAuth-Bearer-only, structurally
  unusable on the Basic-auth path (research Question D).
- **`GET <site>/rest/api/3/serverInfo`**: rejected — anonymous and site-scoped like
  `tenant_info`, but its response schema does not carry a `cloudId` field at all (confirmed
  against the official schema and a community report, research Question D).
- **A hard-fail on tenant_info fetch failure** (block `jr auth login` entirely if `cloud_id`
  can't be acquired): rejected — would regress every API-token user who never touches
  Assets/CMDB, for a best-effort convenience lookup with no documented SLA.
- **Bare-clear `cloud_id` on every oauth→api_token switch** (the original A-PA-LOW-001 framing):
  rejected in favor of refresh-with-fallback (§3) — a bare clear would guarantee Assets cannot
  even attempt its gateway calls, for no benefit over refresh (core Jira is already unaffected
  by the existing `base_url()` guard either way, and whether Assets' attempt would then succeed
  under classic-token Basic auth is unconfirmed regardless of clear-vs-refresh — see the Pass-1
  correction in Context/Consequences).
- **Re-implementing the `auth_method`-scoped gateway guard as new code**: rejected — the guard
  already exists in `Config::base_url()`, verified during this pass; adding a second
  implementation would only create a duplicate-invariant drift risk (see Rationale).
- **Accept-and-document the plaintext `http://` scheme for `fetch_cloud_id`** (Pass-4 review,
  Finding #4): rejected in favor of requiring `https://` outright — the bounded-but-real
  on-path tenant-misdirection risk is avoidable at zero cost (every real Jira Cloud site is
  already `https://`), so there is no trade-off to document-and-accept; requiring the scheme is
  strictly better with no downside for any legitimate configuration.

## Source / Origin

- `.factory/research/edge-tenant-info-cloudid-2026-09-03.md` — primary evidence base (endpoint
  shape/auth/CORS/rate-limit findings; alternative-source comparison; the classic-vs-scoped
  API-token gateway-auth correction; the Assets/CMDB gateway nuance).
- `.factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md` §11 — the cross-cutting
  `cloud_id` observation this ADR resolves the scope question for (F1 §13 Q2).
- `src/config.rs::Config::base_url` — read directly during this F2 pass; the existing
  `auth_method == "oauth"` gateway guard this ADR confirms is already correct.
- `src/api/client.rs::JiraClient::from_config` — the `assets_base_url` computation confirmed
  already correctly un-gated by `auth_method`.
- `src/cli/auth/refresh.rs::refresh_credentials` — read directly during Pass-3 review; the
  second, previously-unlisted direct `login_token` caller (compile-forcing on the new
  `cloud_id_override` parameter), and the source of the `login_oauth(..., None, ...)` precedent
  §2's call-site fix mirrors.
- `src/cli/auth/login.rs::login_token`, `::login_oauth`, `::handle_login` — the functions this
  ADR modifies/wires into; `login_oauth`'s existing `cloud_id_override` parameter is the
  template `login_token`'s new parameter mirrors.
- `src/cli/mod.rs` (the `Login`/`Refresh` CLI variant's existing `--cloud-id` flag) — reused,
  not re-invented.
- `src/api/jira/teams.rs`, ADR-0005 — the existing OAuth-side `cloudId`/`orgId` discovery
  mechanism this ADR's API-token-side sibling parallels (different endpoint, same
  product-namespaced `api/jira/` module placement convention).
- ADR-0020 — the most recent auth-subsystem ADR; this ADR's `login_token` changes build on
  ADR-0020's per-profile credential/config model without altering it.
- Pass-1 adversarial review (cycle-004 F2, 2026-09-03) — Findings #1, #12, #14 incorporated
  above: the classic-vs-scoped-token Assets-claim correction (Context, §4, Consequences), the
  `fetch_cloud_id` no-redirect policy (§1), and the accepted proxy/TLS-config divergence (§1,
  Consequences). See the companion `architecture-delta.md`'s "Pass-1 architect guidance for
  product-owner" section for the resulting BC-1.2.054 rescoping instruction.
- Pass-3 adversarial review (cycle-004 F2, 2026-09-03) — Finding #2 incorporated above:
  `refresh.rs` added to the `login_token` call-site inventory (§2, hardcoded `None` for
  `cloud_id_override`, mirroring the existing sibling `login_oauth` call), and the explicit
  decision that `auth refresh` DOES trigger the tenant_info fetch on every invocation (§2,
  Consequences). See the companion `architecture-delta.md`'s "Pass-3 architect guidance for
  product-owner and formal-verifier" section for the required BC-1.2.052 Invariant 3 wording.
- Pass-4 adversarial review (cycle-004 F2, 2026-09-03) — Finding #4 incorporated above:
  `fetch_cloud_id` (§1) now requires `site_url` to start with `https://`, skipping the lookup
  (no network call) and soft-failing identically to any other fetch failure otherwise — closing
  a bounded, on-path plaintext tenant-misdirection vector at zero cost to any real Jira Cloud
  user. See the companion `architecture-delta.md`'s "Pass-4 architect guidance for product-owner
  and formal-verifier" section for the required BC-1.2.052 wording.
</content>
