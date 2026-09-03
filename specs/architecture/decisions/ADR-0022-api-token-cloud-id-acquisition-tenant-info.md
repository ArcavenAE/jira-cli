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
(`src/api/client.rs::from_config`) is likewise already correctly scoped: it derives the Assets
gateway URL from `profile.cloud_id` alone, with **no** `auth_method` gate — which is *correct*,
not a bug, because Assets/CMDB genuinely reaches `api.atlassian.com/ex/jira/{cloudId}/jsm/
assets/...` under Basic auth too (research Question E, "Important nuance for Assets/CMDB").
This ADR's remaining scope is therefore narrower than originally framed: only the *acquisition*
half (fetch-and-persist a fresh `cloud_id` for API-token profiles) is unimplemented.

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
pub async fn fetch_cloud_id(site_url: &str) -> anyhow::Result<String> {
    #[derive(serde::Deserialize)]
    struct TenantInfo {
        #[serde(rename = "cloudId")]
        cloud_id: String,
    }
    let url = format!("{}/_edge/tenant_info", site_url.trim_end_matches('/'));
    let client = reqwest::Client::builder()
        .timeout(std::time::Duration::from_secs(10))
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
- Assets/CMDB, which does need a *valid* `cloud_id` under Basic auth regardless of
  `auth_method`, is strictly better served by a possibly-stale-but-present value than by an
  unconditional clear that would guarantee Assets breaks even when the stale value happens to
  still be correct (the common case — a site's `cloudId` essentially never changes for a fixed
  hostname in practice).

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
`assets_base_url`'s deliberate NON-gating by `auth_method` (§ Context) is likewise correct
as-is.

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
  already-inert (core Jira, confirmed) or still probably-correct (Assets, in practice).
- **Confirming `base_url()`'s existing guard rather than re-implementing it** avoids introducing
  a second, redundant auth-method check that could drift from the first — a well-known source of
  the exact "two implementations of one invariant silently diverge" bug class this codebase's
  own history (ADR-0007) explicitly warns against.

## Consequences

### Positive
- API-token profiles gain a working `cloud_id` acquisition path, closing #760's cross-cutting
  observation and the amplification #759's fix (ADR-0021) creates by pushing more users onto
  this path.
- A-PA-LOW-001 closes with a smaller diff than its original framing implied — half the fix
  (the gateway guard) is discovered to already exist; only the acquisition half is new work.
- Reuses the existing `--cloud-id` flag's plumbing (already present, already documented in
  `src/cli/mod.rs`) rather than inventing a second flag or config key.

### Negative / Trade-offs
- `/_edge/tenant_info` is documented across multiple official Atlassian sources but is **not** a
  versioned REST v3 operation with a schema/error-model/rate-limit/deprecation contract
  (research Question C). `jr` now has a soft runtime dependency on an endpoint Atlassian could
  change without the usual API-versioning notice — mitigated by soft-fail (a broken endpoint
  degrades Assets discovery, not core functionality) and by parsing only the one confirmed field.
- One additional unauthenticated HTTP round-trip on every `jr auth login`/`jr init` API-token
  invocation (mitigated: 10-second timeout, soft-fail, and the value is cached in
  `ProfileConfig.cloud_id` thereafter — not re-fetched on every command).
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
  rejected in favor of refresh-with-fallback (§3) — a bare clear would guarantee an Assets
  regression even in the common case where the stale value is still correct, for no benefit
  over refresh (core Jira is already unaffected by the existing `base_url()` guard either way).
- **Re-implementing the `auth_method`-scoped gateway guard as new code**: rejected — the guard
  already exists in `Config::base_url()`, verified during this pass; adding a second
  implementation would only create a duplicate-invariant drift risk (see Rationale).

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
</content>
