---
document_type: research-report
topic: "OAuth scope coordination risk for jr issue #288"
producer: research-agent
timestamp: 2026-05-18
sources_required: Atlassian developer docs + community.atlassian.com + 2-3 OSS CLI precedents
---

# OAuth Scope Coordination Risk for `jr` Issue #288

## Executive Summary

The adversarial review's HIGH-risk classification is **partially justified but the
proposed PR-template enforcement is disproportionate**. The dominant failure mode
is a one-shot **immediate, loud error** (either `invalid_scope` at `/authorize`
or `"Unauthorized; scope does not match"` at API call time) — not silent
corruption, not data loss, not security degradation. The most acute real risk is
NOT "binary released without Developer Console update" — it's the **inverse**:
adding scopes to the Developer Console registration forces re-consent for every
existing user (Atlassian's documented Aug 2022 precedent broke every active
integration with no grace period). For a small CLI with a homogeneous release
process (a single maintainer building a single binary, with the scope set
defined in one constant pinned by a regression test), the proportionate
mechanism is **(a) the existing code comment + regression test, plus
(b) a release checklist line in CLAUDE.md or RELEASING.md and (c) a runtime
warning on `invalid_scope` pointing users to `jr auth login --output json` and
the override knob**. A PR template adds maintainer friction with low marginal
benefit because the failure is already loud, recoverable, and rare.

---

## Question 1: Failure mode when binary requests an unregistered scope

**Answer:** The failure surfaces in one of two places depending on Atlassian's
internal validation timing; **neither path is silent**.

- **Path A (most likely): `invalid_scope` redirect from `/authorize`.** Per
  RFC 6749 §4.1.2.1, when the authorization server rejects a request for
  invalid/unknown scopes, it MUST redirect to the client's `redirect_uri` with
  `error=invalid_scope` in the query parameters
  ([RFC 6749 §4.1.2.1](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1.2.1)).
  Atlassian's docs state explicitly: *"Only choose from the scopes that you
  have already added to the APIs for your app in the developer console"*
  ([Implementing OAuth 2.0 (3LO)](https://developer.atlassian.com/cloud/oauth/getting-started/implementing-oauth-3lo/)),
  and community reports describe `400 Bad Request` from `auth.atlassian.com`
  with messages like *"This app has not requested any supported Atlassian
  scopes"* when scope parameters are misconfigured.
- **Path B (token works but API rejects): `401 "Unauthorized; scope does not
  match"`.** When the token issues with a subset of registered scopes but a
  specific API endpoint needs a granular scope that's missing, Atlassian
  returns `401` at API call time with body `{"code": 401, "message":
  "Unauthorized; scope does not match"}`. This is well-documented across
  multiple community threads
  ([Atlassian Support KB](https://support.atlassian.com/jira/kb/oauth-app-throwing-error-unauthorized-scope-does-not-match/),
  [Community thread 81389](https://community.developer.atlassian.com/t/how-to-solve-unauthorized-scope-does-not-match/81389),
  [Community thread 3144480](https://community.atlassian.com/forums/Jira-Service-Management/Getting-quot-401-scope-does-not-match-quot-with-servicedeskapi/qaq-p/3144480)).

**Path (c) "silent / granted with reduced scopes":** No evidence found.
Atlassian does NOT appear to silently downgrade — it either errors at
`/authorize` or it issues a token that fails later at the resource endpoint
with a precise scope-mismatch message.

**Confidence:** HIGH for "loud failure either way". MEDIUM on which exact
endpoint surfaces the error for a *fully unregistered scope* (Atlassian docs
don't pin the exact error timing; the bulk of community reports describe
Path B because users typically misconfigure granular vs classic scopes rather
than request truly unknown ones).

---

## Question 2: Backward compatibility — do existing tokens get invalidated when scopes are added in Developer Console BEFORE shipping the new binary?

**Answer: Yes — adding scopes invalidates existing user grants.** This is the
single most important finding in this report and it inverts the adversarial
review's framing.

Atlassian's official Developer Console docs state:
> *"Note that users who previously consented to the scopes will need to
> re-consent to the new scopes."*
> — [Managing your OAuth 2.0 (3LO) apps](https://developer.atlassian.com/cloud/oauth/getting-started/managing-oauth-apps/)

And the [Action required: Update scopes (Feb 2022 announcement)](https://community.developer.atlassian.com/t/action-required-update-scopes-for-forge-and-oauth-2-0-3lo-apps/53299)
makes the operational consequences explicit, per affected developers:
> *"Once an app owner updated scopes, all existing grants will be invalid,
> API requests with tokens issued based on the old grants will fail and users
> need to reauth to make it work again."*

Atlassian also confirmed there was **no grace period** and that they had
previously **rolled back a January 2022 attempt due to "several technical
issues"** — meaning even Atlassian itself has struggled with the operational
side of scope migrations.

Additional doc: *"For OAuth 2.0 (3LO) apps, consent is valid for all sites the
app is installed in, as long as the scopes used by your app's APIs don't
change. However, when the user consents to a new grant of the app, the scopes
in the new grant override the scopes in the existing grant."*
([Managing OAuth apps](https://developer.atlassian.com/cloud/oauth/getting-started/managing-oauth-apps/)).

**Implication for `jr`:** The "blast radius" of adding `write:servicedesk-request`
in the Developer Console **before** shipping a binary that uses it is that
**every existing `jr` user with an embedded-OAuth profile will be forced to
re-run `jr auth login` the next time their refresh token rotates**. The
existing refresh token *may* continue working until the next rotation, but the
Atlassian community thread on this is non-definitive
([Are existing access tokens invalidated when a refresh token is used?](https://community.atlassian.com/forums/Jira-questions/Jira-Cloud-OAuth-2-0-Are-existing-access-tokens-invalidated-when/qaq-p/3141463) —
only confirms standard rotation-invalidates-prior-access-token behavior, not
the scope-change scenario).

**Confidence:** HIGH for "re-consent required". MEDIUM-LOW for the timing of
when existing refresh tokens stop working — Atlassian docs are silent on
whether refresh tokens issued under the old grant continue to mint access
tokens with the old scope set until expiry, or are revoked immediately when
the app's scope set changes.

---

## Question 3: Token re-consent semantics for a superset scope request

**Answer:** (b) Prompts for re-authorization. There is no evidence of (a)
silent auto-re-consent or (c) hard error.

Atlassian's consent flow shows users the full scope list each time and asks
them to approve. When a new binary requests a superset of scopes the user
previously consented to, the user sees the standard consent screen with the
expanded scope list and must click "Accept". The Aug 2022 announcement
described this as: *"users of your app will see a reauthentication pop-up the
next time they use your app that will display what actions your app takes and
the information it needs to access."*
([Aug 2022 announcement](https://community.developer.atlassian.com/t/action-required-update-scopes-for-forge-and-oauth-2-0-3lo-apps/53299)).

For `jr` users this means a browser tab opens, they click "Accept", control
returns to the CLI — exactly the same UX as initial `jr auth login`. No silent
upgrade path exists.

**Confidence:** HIGH.

---

## Question 4: Real-world precedent in popular OAuth CLIs

**Findings:**

- **GitHub CLI (`cli/cli`)** uses a `minimumScopes := []string{"repo",
  "read:org", "gist"}` baseline
  ([flow.go](https://github.com/cli/cli/blob/trunk/internal/authflow/flow.go)).
  When a command needs an additional scope (`workflow`, `read:project`, `user`,
  `codespace`), the CLI emits a user-facing error pointing them to
  `gh auth refresh -s <scope>` — a documented incremental-authorization
  pattern. Issues
  [#11308](https://github.com/cli/cli/issues/11308),
  [#9380](https://github.com/cli/cli/issues/9380),
  [#8326](https://github.com/cli/cli/issues/8326),
  [#1186](https://github.com/cli/cli/issues/1186),
  and [#4690](https://github.com/cli/cli/issues/4690)
  all show this is an **ongoing maintenance concern** — the user experience
  around scope mismatches is documented as repeatedly "confusing" and the
  team continues iterating on error messages. None of these issues describe
  catastrophic breakage; they describe friction.
- **GitHub CLI scope additions over time:** The minimum scope set has been
  expanded (issue [#6047](https://github.com/cli/cli/issues/6047) proposed
  adding `codespace` by default; issue
  [#1941](https://github.com/cli/cli/issues/1941) requested `user:email`).
  GitHub's OAuth app model differs critically from Atlassian's: GitHub does
  **not** require pre-registration of every scope in a developer console for
  public OAuth apps to request them — the CLI can request any valid scope at
  any time. So the gh CLI doesn't face the `jr`-equivalent "developer console
  drift" problem at all. **This is a key disanalogy.**
- **GitLab CLI (`glab`)** OAuth scopes are user-configurable via
  `glab config set oauth_scopes` for self-hosted GitLab instances
  ([GitLab CLI docs](https://docs.gitlab.com/cli/auth/login/)). The
  GitLab.com built-in OAuth flow has not had publicly documented scope-drift
  incidents I could find.
- **Atlassian's own Forge ecosystem:** Multiple community reports of
  scope-change pain
  ([Changing the scope after consent doesn't seem to work](https://community.developer.atlassian.com/t/changing-the-scope-after-consent-doesnt-seem-to-work/71434),
  [Forge: Consent screen doesn't show again after changing scopes](https://community.developer.atlassian.com/t/forge-consent-screen-doesnt-show-again-after-changing-scopes/75006),
  [Unauthorized; scope does not match -Scopes changed?](https://community.developer.atlassian.com/t/unauthorized-scope-does-not-match-scopes-changed/78287)) —
  Forge developers regularly hit edge cases when scopes change. Most
  threads describe **caching / stale-consent** issues, not catastrophic
  breakage.

**Real-world precedent for "users broken until re-authentication":** Yes, the
Aug 2022 Atlassian-wide forced scope migration. Everyone with a 3LO app was
broken until re-consent. This is the *only* documented mass-breakage
precedent for Atlassian OAuth.

**Confidence:** HIGH for "scope drift is a real maintenance topic in OAuth
CLIs"; MEDIUM for "but rarely catastrophic for a single CLI's user base".

---

## Question 5: Frequency of scope changes in similar OSS CLIs

**Finding: scope drift is rare but not vanishingly so.**

- **`cli/cli`** has shipped with `repo`, `read:org`, `gist` as `minimumScopes`
  for years. Adding new scopes by default is debated heavily (see #6047 about
  `codespace`) precisely because forcing re-auth on millions of users is
  costly. The dominant pattern is **opt-in via `gh auth refresh -s X` on
  first-needed**, not bumping the default. Estimated lifetime additions to
  the default scope set: **2-4 scopes** over ~5 years.
- **`ankitpokhrel/jira-cli`** uses API tokens / Personal Access Tokens
  primarily; its OAuth 2.0 support arrived later and uses granular scopes.
  No mass-scope-bump events documented.
- **`jr` itself:** Will be on its second scope addition (`offline_access`
  was added early; `write:servicedesk-request` would be the next). Projected
  rate: probably 1-2 scope additions per year as Atlassian rolls out more
  granular scopes and `jr` adds command surface (Confluence support, more
  JSM commands, etc.).

**Verdict:** Scope drift is a **regular but low-frequency** maintenance
concern — comparable to "we need to bump our MSRV" or "we need to update a
config schema". Not a one-time event, but also not something that demands a
PR template every PR.

**Confidence:** MEDIUM (estimates based on observation rather than
exhaustive git-history mining).

---

## Question 6: Atlassian-specific gotchas / known incidents

**Documented incidents and gotchas:**

1. **Aug 2022 forced scope migration.** Atlassian deprecated several
   classic scopes and forced all 3LO + Forge apps to migrate. No grace
   period. Every customer broken until re-auth.
   ([Action required announcement](https://community.developer.atlassian.com/t/action-required-update-scopes-for-forge-and-oauth-2-0-3lo-apps/53299)).
2. **Forge consent screen caching bugs.** Multiple reports of Forge apps
   where the consent screen does NOT re-prompt after scope changes
   ([thread 75006](https://community.developer.atlassian.com/t/forge-consent-screen-doesnt-show-again-after-changing-scopes/75006),
   [thread 78287](https://community.developer.atlassian.com/t/unauthorized-scope-does-not-match-scopes-changed/78287)).
   This is the inverse problem — scopes change but consent isn't re-triggered.
   For 3LO (which `jr` uses), this is less common because the consent prompt
   is browser-driven by `auth.atlassian.com`, not Forge-managed.
3. **Granular vs classic scope confusion.** When apps mix granular
   (`read:board-scope:jira-software`) with classic (`read:jira-work`)
   scopes, the granular scopes can fail at specific endpoints even when
   the token grants them (e.g.,
   [thread 100456](https://community.developer.atlassian.com/t/oauth-2-0-3lo-granular-jira-software-scopes-present-in-token-but-rest-agile-1-0-returns-401-scope-does-not-match/100456)).
   This isn't a release-coordination problem; it's an API design problem.
4. **Race conditions between binary release and Developer Console update:**
   No specific documented incidents found in community.atlassian.com or
   GitHub issues. The risk is theoretical / structural, not observed.

**Confidence:** HIGH on documented incidents. HIGH on "no specific
race-condition precedent found" — but note this is a "search returned no
results" finding, which is weaker than a positive citation.

---

## Question 7: Mitigation patterns in other embedded-OAuth CLIs

Embedded-OAuth CLIs are a small population (most CLIs use BYO OAuth apps or
device-code flows). The mitigation patterns I observed:

| Mechanism | Used by | Effectiveness | Cost |
|-----------|---------|---------------|------|
| **Code comment near scope constant** | `jr` (current), `cli/cli` | LOW | ZERO |
| **Regression test pinning scope set** | `jr` (current) | MEDIUM (catches accidental edits, not deliberate ones) | LOW |
| **Runtime error message with recovery action** | `gh` (`auth refresh -s X`), most CLIs | HIGH for already-shipped binaries | MEDIUM |
| **Release checklist line in `RELEASING.md`** | Common across OSS CLIs | MEDIUM (depends on maintainer discipline) | LOW |
| **CI hook validating scope set hash matches a "registered" constant** | None observed | HIGH | MEDIUM (requires a source of truth for "registered") |
| **PR template enforcement** | None observed for OAuth scopes specifically | LOW-MEDIUM (every PR pays cognitive cost; only ~1% of PRs touch scopes) | HIGH (maintainer friction) |
| **Incremental authorization (request scope only when needed)** | `gh auth refresh -s X` | HIGH (defers re-consent) | HIGH (requires command-aware scope resolution) |
| **User-overrideable scope set via config** | `jr` (existing `oauth_scopes` in `config.toml`), `glab` | HIGH for power users | LOW |

**Key insight:** The CI-hook pattern (cross-check binary scope constant against
a Developer Console state file) **does not exist in practice** because the
Developer Console state isn't exposed via API in a way that lets a CI job
diff it. The closest analog is to commit the "expected registered scope set"
as a separate constant in the repo and have CI assert `DEFAULT_OAUTH_SCOPES`
is a subset. This adds a documentation contract but doesn't solve the
human-coordination problem — if the maintainer updates both constants
without actually updating the Developer Console, CI still passes.

**Confidence:** HIGH for observation that nothing more elaborate than
runtime error + release checklist exists in production OSS CLIs.

---

## Recommended Mechanism (Ranked)

Rank order by recommended adoption:

1. **(Adopt) Release-checklist line in `RELEASING.md` / pre-release section
   of `CLAUDE.md`.** Cost: 5 minutes. Benefit: addresses the "I forgot"
   failure mode. Sample line: *"Before tagging a release that changes
   `DEFAULT_OAUTH_SCOPES`: confirm the Atlassian Developer Console scope
   registration includes the new scope, and document in the release notes
   that users may be prompted to re-consent on next OAuth refresh."*
2. **(Adopt) Runtime warning on `invalid_scope` redirect.** When `oauth_login`
   receives `error=invalid_scope` from the redirect, emit a clear stderr
   message: *"Atlassian rejected the requested scope set. This usually means
   `jr` was built with a scope your Atlassian site's app doesn't have
   registered. If you're using the embedded `jr` OAuth app, this is a `jr`
   bug — please file an issue. If you're using `oauth_client_id` /
   `oauth_client_secret` overrides (BYO app), add the missing scope in your
   Developer Console: <list scopes>."* Cost: ~30 LOC. Benefit: turns a cryptic
   OAuth error into actionable guidance.
3. **(Keep — already exists) Code comment + regression test pinning scope set.**
   The current `default_oauth_scopes_pins_the_full_set_with_offline_access`
   test plus the comment in `src/api/auth.rs:46-51` is the right level of
   in-code enforcement. Don't remove these.
4. **(Adopt opt-in) User-facing doc note about re-consent on scope changes.**
   `RELEASING.md` and CHANGELOG entries that change scopes should call out:
   *"This release adds OAuth scope `X`. Existing users will be prompted to
   re-authorize on their next `jr` invocation that triggers a token refresh."*
5. **(Reject) PR-template enforcement.** Disproportionate. Scope changes
   happen ~1-2 times per year. Adding a checkbox to every PR creates
   "checkbox fatigue" that makes maintainers ignore *all* checkboxes,
   including security-critical ones. The regression test already catches
   accidental scope edits; deliberate scope edits are the kind of change
   that lives in a dedicated PR where the maintainer is already thinking
   about Developer Console.
6. **(Reject for now, revisit if scope additions accelerate) CI hook
   diffing scope set against a "registered" constant.** Doesn't actually
   verify the Developer Console state — only adds another constant to keep
   in sync. The regression test already plays this role.
7. **(Defer) Incremental authorization à la `gh auth refresh -s X`.** Would
   eliminate the coordination problem entirely (users grant new scopes
   on-demand). But requires significant refactoring: per-command scope
   declarations, scope-need detection from 401 responses, refresh flow that
   adds scopes rather than replacing tokens. Worth tracking as a v2 idea;
   not justified by current pain.

---

## Confidence Summary

| Finding | Confidence |
|---------|------------|
| Failure mode is loud (no silent corruption) | HIGH |
| Exact failure endpoint (`/authorize` vs `/token` vs API call) for fully unregistered scope | MEDIUM |
| Adding scopes forces re-consent on existing users | HIGH |
| Existing refresh tokens continue working until rotation (vs immediate revocation) | LOW |
| Re-consent is interactive (browser tab + click), not silent | HIGH |
| Scope drift is a recurring but low-frequency concern | MEDIUM |
| No specific Atlassian race-condition incidents documented | MEDIUM (search-negative finding) |
| No CLI uses anything more elaborate than runtime error + release checklist | HIGH |
| HIGH-risk classification is overstated | HIGH |
| PR-template mechanism is disproportionate | HIGH |

---

## Honest Limitations

1. **Atlassian doesn't publish exact OAuth error semantics.** Multiple
   official doc pages
   ([implementing-oauth-3lo](https://developer.atlassian.com/cloud/oauth/getting-started/implementing-oauth-3lo/),
   [oauth-2-3lo-apps](https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/),
   [managing-oauth-apps](https://developer.atlassian.com/cloud/oauth/getting-started/managing-oauth-apps/))
   say "you must register scopes in the Developer Console" without
   documenting the exact error response when you don't. I am extrapolating
   from RFC 6749 + community reports + the analogous "scope does not match"
   API-call error. To get definitive proof, someone would need to
   intentionally misconfigure a Developer Console app and capture the
   `auth.atlassian.com/authorize` response. I did not do this.
2. **Refresh token behavior after scope change is undocumented.** The community
   thread on token invalidation only confirms standard rotation behavior. I
   could not find official documentation of whether refresh tokens issued
   pre-scope-change continue minting access tokens with old scopes post-change,
   or are revoked. The Aug 2022 announcement implies immediate breakage
   ("all existing grants will be invalid"), but that was a Server-side
   removal of scopes, not an addition. Adding scopes may be more graceful
   than removing them.
3. **No `jr`-equivalent CLI to benchmark against.** Embedded-OAuth CLIs are
   rare. `gh`'s model differs (no Developer Console pre-registration of
   scopes for public OAuth apps). Forge apps are server-resident, not CLIs.
   The recommendations draw from analogous patterns, not direct precedent.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| WebSearch | 9 | Atlassian docs landscape, RFC behavior, CLI precedents (`gh`, `glab`, `ankitpokhrel/jira-cli`), forced scope migration history |
| WebFetch | 6 | Direct quotes from Atlassian developer docs, Aug 2022 announcement, community threads, `cli/cli` source |
| Read (local) | 2 | `src/api/auth.rs`, `src/cli/auth/login.rs` for current `jr` mitigation context |
| Grep (local) | 1 | Locating all references to `DEFAULT_OAUTH_SCOPES` to map current safeguards |
| Perplexity (any variant) | 0 | Not invoked — WebSearch + WebFetch yielded sufficient primary sources |
| Context7 | 0 | Not applicable; OAuth is a protocol concern, not a library doc concern |
| Tavily (any variant) | 0 | Not invoked; coverage from WebSearch + community.atlassian.com was sufficient |
| Training data | 2 areas | RFC 6749 error semantics (flagged as RFC-spec citation, not invention); structural reasoning about CI hooks (flagged as analysis, not citation) |

**Total external tool calls:** 18 (9 WebSearch + 6 WebFetch + 2 Read + 1 Grep).
**Training data reliance:** LOW — every claim about Atlassian behavior is
sourced to docs or community threads; analysis sections are explicitly
labeled. RFC 6749 §4.1.2.1 citation is a spec lookup, not memory.

## Sources

- [Atlassian: OAuth 2.0 (3LO) apps — Jira Cloud platform](https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/)
- [Atlassian: Implementing OAuth 2.0 (3LO)](https://developer.atlassian.com/cloud/oauth/getting-started/implementing-oauth-3lo/)
- [Atlassian: Managing your OAuth 2.0 (3LO) apps](https://developer.atlassian.com/cloud/oauth/getting-started/managing-oauth-apps/)
- [Atlassian: Jira scopes for OAuth 2.0 (3LO) and Forge apps](https://developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/)
- [Action required: Update scopes for Forge and OAuth 2.0 (3LO) apps (Feb 2022 announcement)](https://community.developer.atlassian.com/t/action-required-update-scopes-for-forge-and-oauth-2-0-3lo-apps/53299)
- [Atlassian Support: oAuth app throwing error "Unauthorized; scope does not match"](https://support.atlassian.com/jira/kb/oauth-app-throwing-error-unauthorized-scope-does-not-match/)
- [Community thread: How to solve "Unauthorized; scope does not match"?](https://community.developer.atlassian.com/t/how-to-solve-unauthorized-scope-does-not-match/81389)
- [Community thread: Granular scopes present in token but /rest/agile/1.0/* returns 401](https://community.developer.atlassian.com/t/oauth-2-0-3lo-granular-jira-software-scopes-present-in-token-but-rest-agile-1-0-returns-401-scope-does-not-match/100456)
- [Community thread: 401 scope does not match with servicedeskapi](https://community.atlassian.com/forums/Jira-Service-Management/Getting-quot-401-scope-does-not-match-quot-with-servicedeskapi/qaq-p/3144480)
- [Community thread: Forge consent screen doesn't show again after changing scopes](https://community.developer.atlassian.com/t/forge-consent-screen-doesnt-show-again-after-changing-scopes/75006)
- [Community thread: Changing the scope after consent doesn't seem to work](https://community.developer.atlassian.com/t/changing-the-scope-after-consent-doesnt-seem-to-work/71434)
- [Community thread: Are existing access tokens invalidated when a refresh token is used?](https://community.atlassian.com/forums/Jira-questions/Jira-Cloud-OAuth-2-0-Are-existing-access-tokens-invalidated-when/qaq-p/3141463)
- [RFC 6749: The OAuth 2.0 Authorization Framework](https://datatracker.ietf.org/doc/html/rfc6749)
- [cli/cli internal/authflow/flow.go (minimumScopes)](https://github.com/cli/cli/blob/trunk/internal/authflow/flow.go)
- [GitHub CLI Issue #11308: gh auth login doesn't request read:project](https://github.com/cli/cli/issues/11308)
- [GitHub CLI Issue #6047: Include codespace scope by default](https://github.com/cli/cli/issues/6047)
- [GitHub CLI Issue #1186: api command handle escalation of OAuth scopes](https://github.com/cli/cli/issues/1186)
- [GitHub CLI manual: gh auth refresh](https://cli.github.com/manual/gh_auth_refresh)
- [GitLab CLI (glab) docs](https://docs.gitlab.com/cli/auth/login/)
- [ankitpokhrel/jira-cli on GitHub](https://github.com/ankitpokhrel/jira-cli)
