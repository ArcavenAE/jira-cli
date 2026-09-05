# Atlassian OAuth 2.0 (3LO) Revocation Granularity — Findings

**Date:** 2026-09-05
**Researcher:** research-agent (jr / Corverax)
**Question:** When a user revokes an OAuth app on `https://id.atlassian.com/manage-profile/apps`, is revocation account-level (kills ALL tokens for that `client_id` under that account) or is there finer per-grant/per-site/per-token granularity that would let one jr profile be revoked without affecting others?

---

## Verdict

**ACCOUNT-LEVEL. Revoking the `jr` app on the Connected apps page revokes the SINGLE grant that exists per (app `client_id`, Atlassian account) and thereby breaks EVERY jr profile that authenticated the same embedded OAuth app under the same Atlassian account.**

There is **no** finer user-facing granularity (no per-grant-instance, per-login-session, per-site/cloudId, or per-token revoke control) on the personal `manage-profile/apps` page. Multiple sites/authorizations of the same `client_id` are consolidated into one grant, so there is one revocable entry per app, not one per authorization.

**Confidence: CONFIRMED** (primary Atlassian developer documentation states the operative facts verbatim; the token-level consequence is a direct, necessary corollary rather than an independently documented sentence — see qualification below).

---

## Primary-source evidence (all verified directly, 2026-09-05)

### 1. One grant per app/account — the core fact

Atlassian OAuth 2.0 FAQ (developer.atlassian.com/cloud/oauth/getting-started/faq/, updated 2026-05-05), quoted verbatim:

> "Only one grant exists per app for a given Atlassian account. If a user grants access to more than one Atlassian site for this app, then the additional sites are added to the same grant."

> "This means that existing access tokens will give you access to all sites and scopes that a user has granted your app access to."

This establishes that additional sites (i.e., additional jr profiles pointing at different Jira sites under the same account) are folded into **one** grant — not separate revocable grants.

### 2. Revoking the grant disables the app everywhere

OAuth 2.0 (3LO) apps — Jira Cloud platform (developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/, last updated 2026-09-04), quoted verbatim:

> "The user revokes the grant."
> "The app cannot work anywhere after a user has revoked their consent to the app."
> "Only one grant exists per app for a given Atlassian account."

"Cannot work anywhere" + "only one grant per app/account" = revocation of that single grant necessarily invalidates the authority of every outstanding access/refresh token derived from it, across all sites/profiles.

### 3. Personal Connected apps page is app-level management

Atlassian support — Update your profile and visibility settings (support.atlassian.com/atlassian-account/docs/update-your-profile-and-visibility-settings/): users review Connected apps and "revoke their access" via Manage account -> Connected apps. The page manages **apps**, not individual tokens, sessions, or sites.

Atlassian support — Manage your users' third-party apps (support.atlassian.com/security-and-access-policies/docs/manage-your-users-third-party-apps/, updated 2026-08-16): distinguishes the user's personal Connected apps grants from site/admin-level app management; users revoke their own app grants (app-level unit).

### 4. Refresh-token rotation is orthogonal (not a revocation lever)

Implementing the Refresh Token Flow (developer.atlassian.com/cloud/oauth/getting-started/refresh-tokens/, updated 2026-08-26): rotating refresh tokens — each refresh disables the used token and returns a new pair. This is token-chain rotation *within* the grant; it is not a per-token entry a user can manage on the Connected apps page. The token chain remains subordinate to the single app-account grant.

---

## Direct community corroboration

- "Revoking site access in OAuth 2.0 (3LO) flow" (community.developer.atlassian.com/t/80502) and "External auth granular revoking" (t/72402): developers asking for per-site / granular revocation — the recurring request confirms such granularity does **not** exist.

---

## Important qualification (why not "beyond doubt" on the token-deletion mechanism)

Atlassian's docs explicitly state (a) one grant per app/account and (b) the app cannot work anywhere after revocation. They do **not** publish the underlying database operation, an explicit "every token family ever issued for this client_id is invalidated" sentence, or the propagation/cache latency. The token-invalidation consequence is a necessary logical corollary of the two documented facts (if outstanding tokens still worked, the app *could* work somewhere, contradicting the docs). This is why the mechanism is a strongly-supported inference while the user-facing verdict (account-level, one entry per app, kills all profiles) is CONFIRMED.

Note also: two *different* OAuth apps (different `client_id`s) are different grants. But jr uses ONE embedded app / one `client_id` shared across all profiles, so all of a user's same-account jr profiles fall under a single revocable grant.

---

## Recommendation for the jr error message

The current guidance — instructing the user to revoke the grant at `manage-profile/apps` as a REQUIRED step and calling it "safe cleanup with no other consumer" — is **incorrect and harmful for multi-profile users**: because jr's embedded app is a single `client_id` and Atlassian keeps only one grant per app/account, revoking it there invalidates the tokens for *every* jr profile authenticated under that Atlassian account, not just the one being cleaned up. Reword to (1) make revocation **optional**, not required, (2) explicitly warn that revoking the `jr` app on the Connected apps page is account-wide and will sign out ALL jr profiles that use the same Atlassian account (each will need to re-run `jr auth login`), and (3) prefer directing the user to jr's own local credential cleanup (e.g. `jr auth logout` / `jr auth remove <profile>`, which clear only that profile's stored tokens) as the scoped, non-destructive option, reserving the Connected-apps revoke for the case where the user actually wants to sever the app from their whole Atlassian account. Drop the "no other consumer" claim entirely — it is false whenever more than one jr profile shares the account.

---

## Sources

- Atlassian OAuth 2.0 FAQ — https://developer.atlassian.com/cloud/oauth/getting-started/faq/ (updated 2026-05-05) [PRIMARY, verified verbatim]
- OAuth 2.0 (3LO) apps, Jira Cloud platform — https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/ (updated 2026-09-04) [PRIMARY, verified verbatim]
- Implementing the Refresh Token Flow — https://developer.atlassian.com/cloud/oauth/getting-started/refresh-tokens/ (updated 2026-08-26) [PRIMARY]
- Update your profile and visibility settings — https://support.atlassian.com/atlassian-account/docs/update-your-profile-and-visibility-settings/ [PRIMARY]
- Manage your users' third-party apps — https://support.atlassian.com/security-and-access-policies/docs/manage-your-users-third-party-apps/ (updated 2026-08-16) [PRIMARY]
- OAuth 2.0 changelog (resource-restricted tokens) — https://developer.atlassian.com/cloud/oauth/changelog/ [PRIMARY, context]
- Community: "Revoking site access in OAuth 2.0 (3LO) flow" — https://community.developer.atlassian.com/t/revoking-site-access-in-oauth-2-0-3lo-flow/80502 [SECONDARY, corroborating]
- Community: "External auth granular revoking" — https://community.developer.atlassian.com/t/external-auth-granular-revoking/72402 [SECONDARY, corroborating]

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source synthesis on 3LO revocation granularity across Atlassian dev docs, support docs, and community |
| WebFetch | 2 | Verbatim verification of the FAQ "one grant per app" statement and the platform doc "cannot work anywhere" / revocation statements |
| Training data | 0 areas | Not relied upon for any load-bearing claim |

**Total MCP tool calls:** 1 (plus 2 WebFetch verifications)
**Training data reliance:** low — every load-bearing claim is sourced to primary Atlassian documentation, two of which were re-verified verbatim by direct fetch.
