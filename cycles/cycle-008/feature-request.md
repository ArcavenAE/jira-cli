---
document_type: feature-request
title: "OAuth surface correctness -- JSM/Teams/Assets routing + Agile scope gap"
requested_by: "human (live OAuth E2E testing session)"
date: 2026-09-17
priority: high
---

# Feature Request: OAuth surface correctness -- JSM/Teams/Assets routing + Agile scope gap

## Problem

`jr`'s OAuth (3LO) support works for platform commands (`issue list`, `project list`,
`user list`, `api` passthrough, `/myself`) but a large part of the CLI is unusable
under OAuth. Two independent root causes were live-confirmed on 2026-09-17 against
the `e2e` (oauth) profile (all read-only investigation; **no live mutations were
performed**).

Atlassian 3LO bearer tokens are **only** valid against the API gateway base
`https://api.atlassian.com/ex/jira/<cloud-id>/...` (jr's `base_url`) -- **not**
against the direct site URL `https://<site>.atlassian.net/...` (jr's
`instance_url`). Under api-token auth, `base_url == instance_url` (both resolve to
the direct site), which is exactly why these defects were never caught by existing
(api-token-only) test coverage.

> Redaction note: all real org identifiers (cloud ID, site name, email, accountId)
> observed during live testing are intentionally omitted from this brief and
> replaced with placeholders (`<cloud-id>`, `<site>.atlassian.net`, `<account-id>`,
> `<email>`) -- `.factory/` is pushed to `origin`.

## Proposed Solution

Fix OAuth-surface routing so that every JSM, Teams, and Assets command that works
under api-token auth also works under OAuth, and close the Agile OAuth scope gap so
`jr board`/`jr sprint` work under OAuth. Sharpen the error message emitted on an
Agile OAuth scope-mismatch 401 so it no longer misattributes the failure to the
granular-PAT-on-POST quirk. From the user's perspective: authenticating via
`jr auth login` (OAuth) should unlock the same command surface as an api-token
profile, modulo the Agile-scope re-consent this fix will require.

## Scope

### In Scope

- **Defect 1 -- instance-URL routing bug (jr code, 9 call sites).** Nine call sites
  use `get_from_instance`/`post_to_instance` (build against `instance_url`,
  `client.rs:1072`/`:1085`) instead of `get`/`post` (build against `base_url`,
  `client.rs:285`/`:336`). Under OAuth every one 401s ("Not authenticated"). Under
  api-token auth these are currently masked because `base_url == instance_url`.
  Affected call sites:
  - JSM: `src/api/jsm/servicedesks.rs:22` (`list_service_desks` -- the discovery
    step every JSM command hits first), `src/api/jsm/request_types.rs:46` and
    `:73`, `src/api/jsm/queues.rs:24` and `:67`, `src/api/jsm/requests.rs:28`
    (`post_to_instance` -- the JSM `issue create --request-type` WRITE path).
    Breaks `jr requesttype list/fields`, `jr queue list/view`,
    `jr issue create --request-type`.
  - Teams: `src/api/jira/teams.rs:19` (`post_to_instance` `/gateway/api/graphql`)
    and `:43` (`get_from_instance`). Breaks `jr team list`.
  - Assets: `src/api/assets/workspace.rs:26` (`get_from_instance`
    `/rest/servicedeskapi/assets/workspace` -- workspace discovery). Breaks all
    `jr assets *` (search/view/schemas/linked).
  - Fix hypothesis: route these servicedeskapi/GraphQL/workspace-discovery calls
    through `get`/`post` (base_url/gateway) instead. **Must verify api-token auth
    still resolves correctly post-swap** (its `base_url == instance_url`, so the
    swap should be a no-op for that auth mode -- confirm this explicitly, including
    the GraphQL `/gateway/api/graphql` host and the assets workspace path). Note
    the ADR-0009 context: `instance_url` is for BROWSER urls (`/browse/`),
    `base_url` is for API calls -- this defect is the inverse of the class ADR-0009
    documents (a case where an API call was wrongly routed through the
    browser/instance URL).
- **Defect 2 -- OAuth Agile scope gap (config, not routing).** `jr board list` and
  `jr sprint current` 401 with "scope does not match" even though the URL is
  correctly gateway-routed (`/ex/jira/<cloud-id>/rest/agile/1.0/board`). Root
  cause: `DEFAULT_OAUTH_SCOPES` (`src/api/auth.rs:83-86`) = `read:jira-work
  write:jira-work read:jira-user read:servicedesk-request
  write:servicedesk-request ...` contains **no** Agile scopes. The Agile API
  (`/rest/agile/1.0/*`) needs granular Agile scopes (e.g.
  `read:board-scope:jira-software`, `read:sprint:jira-software`, and likely
  related scopes). Confirmed live: raw `jr api /rest/agile/1.0/board` also 401s
  "scope does not match" against the same gateway base as the working `/myself`
  call, proving this is a token-scope gap, not a routing gap. Fix hypothesis: add
  the required Agile read scopes to `DEFAULT_OAUTH_SCOPES`. Per CLAUDE.md, changing
  `DEFAULT_OAUTH_SCOPES` requires (a) updating the embedded `jr` OAuth app's
  permissions in the Atlassian Developer Console before release, and (b) a
  CHANGELOG note about the resulting re-consent prompt. **F1/F2 investigation
  should determine the exact minimal Agile scope set** (do not over-grant).
- **Defect 3 (minor) -- misleading error message.** On the Agile scope-mismatch
  401, `jr` currently prints "The Atlassian API gateway rejects granular-scoped
  personal tokens on POST requests (while PUT/GET succeed)" -- this is the wrong
  hint for a genuine OAuth GET scope-mismatch. The error-mapping layer should
  distinguish an actual OAuth insufficient-scope response from the
  granular-PAT-on-POST case it currently assumes.
- **Testing gap.** There is currently no OAuth E2E coverage for JSM/Teams/Assets/
  Agile -- the existing `tests/e2e_live.rs` suite runs under api-token auth only.
  This cycle should add OAuth-path coverage, at minimum unit/integration
  assertions that the fixed call sites build requests against `base_url` (not
  `instance_url`), since a live-OAuth CI harness may not be feasible within this
  cycle.

### Out of Scope

- Any change to commands already confirmed working under OAuth (regression guard
  -- see Constraints below): `jr project list`, `jr issue list` (JQL search),
  `jr user list`, `jr api` passthrough, `/myself`.
- Any change to api-token auth behavior beyond confirming it is unaffected by the
  Defect 1 routing swap.
- Building a full live-OAuth CI harness (may be infeasible; F1/F2 should scope the
  minimally-sufficient test strategy instead -- e.g. unit assertions on which
  client method/base a call site invokes).
- Re-registering or renaming the embedded OAuth app, or changing the fixed
  callback port (ADR-0006) -- unrelated to this defect class.
- PKCE reactivation (ADR-0013) -- unrelated.

## Constraints

- **Technical:** Fix must not alter request bodies/payload shapes -- only the
  base URL a request is built against (`get`/`post` vs.
  `get_from_instance`/`post_to_instance`). Must preserve every existing
  behavioral contract for the 9 affected call sites under api-token auth.
- **Regression guard:** Do NOT touch or regress the OAuth-working command set:
  `jr project list`, `jr issue list` (JQL search), `jr user list`, `jr api`
  passthrough, `/myself` -- all correctly gateway-routed via `base_url` today.
- **Compatibility:** `DEFAULT_OAUTH_SCOPES` change (Defect 2) is a breaking
  UX event for existing OAuth users -- it forces a re-consent prompt on next
  login/refresh-token mint. Must follow the documented CLAUDE.md procedure:
  update the embedded app's Developer Console permissions before release, and add
  a CHANGELOG entry calling out the re-consent prompt.
- **Security:** No change to token storage, keychain namespacing, or the
  refresh-coordinator's single-flight semantics is in scope; this is a routing +
  scope-declaration fix only.
- **No live mutations:** All investigation and verification this cycle must
  continue to be read-only against any live Jira instance, consistent with how
  Defects 1-3 were originally discovered.

## Success Criteria

| Criterion | Measurable Target |
|-----------|------------------|
| JSM commands work under OAuth | `jr requesttype list/fields`, `jr queue list/view` succeed (no 401) against an OAuth profile |
| JSM write path works under OAuth | `jr issue create --request-type` succeeds (no 401) against an OAuth profile |
| Teams command works under OAuth | `jr team list` succeeds (no 401) against an OAuth profile |
| Assets commands work under OAuth | `jr assets search/view/schemas` (and linked-asset lookups) succeed (no 401) against an OAuth profile |
| Agile commands work under OAuth | `jr board list`, `jr sprint current` succeed (no scope-mismatch 401) against an OAuth profile with re-consented scopes |
| Error message accuracy | The Agile OAuth scope-mismatch case no longer emits the granular-PAT-on-POST hint; it emits a hint accurate to an OAuth insufficient-scope 401 |
| api-token regression-free | Every one of the 9 fixed call sites, plus `board`/`sprint`, produces byte-identical request behavior under api-token auth pre- vs. post-fix |
| OAuth regression-free | `jr project list`, `jr issue list`, `jr user list`, `jr api` passthrough, `/myself` continue to work unchanged under OAuth |
| Test coverage added | New unit/integration tests assert the 9 fixed call sites build requests against `base_url`, not `instance_url` |
| Re-consent documented | CHANGELOG entry added noting the OAuth scope change and resulting re-consent prompt, per `DEFAULT_OAUTH_SCOPES` change procedure |

## Discovery Context

Discovered via live OAuth E2E testing on 2026-09-17 against the `e2e` (oauth)
profile. All testing was read-only; no live mutations were performed. This feature
request captures the F1 (delta analysis) input for cycle-008.

## Example: Task Priority Feature

Not applicable to this feature request -- this section is retained only for
structural conformance with `feature-request-template.md`, which documents a
generic filled-in example (task-priority feature) unrelated to this bug fix. See
the template file itself for that reference example; the real content for
cycle-008 is captured in full above (Problem / Proposed Solution / Scope /
Constraints / Success Criteria).
