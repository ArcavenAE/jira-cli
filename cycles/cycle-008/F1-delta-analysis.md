---
document_type: phase-f1-delta-analysis
cycle: cycle-008
title: "OAuth surface correctness — JSM/Teams/Assets routing + Agile scope gap"
tracked_issue: "#831 (Defect 1 / JSM routing only — validated correct on routing, INCORRECT on jsm/attachments.rs being affected)"
intent: bug-fix
severity: HIGH
trivial_scope: false
feature_type: backend
inputs:
  - .factory/cycles/cycle-008/feature-request.md
  - .factory/cycles/cycle-008/research-oauth-endpoints.md
date: 2026-09-17
status: awaiting-human-gate
input-hash: "aa42071"
---

# Phase F1 — Delta Analysis: cycle-008 "oauth-surface-correctness"

## 0. Classification

| Axis | Value | Rationale |
|---|---|---|
| **Intent** | `bug-fix` | Request language: "Fix OAuth-surface routing", root cause is a pre-existing latent defect, not new capability. |
| **Severity** | HIGH | Major functionality broken (all JSM commands, Teams, Assets, Agile/board/sprint) under OAuth, with a workaround (switch to api-token auth). Not CRITICAL — read-only discovery, no prod outage, no data loss, no security breach. |
| **Trivial scope?** | **NO** | Spans 4 independent workstreams, 9+ call sites across 3 modules, one `const` change with a breaking re-consent UX event, a Display-template/error-taxonomy change, and a possible architecture-level re-platform (Teams GraphQL host migration). Multiple BCs need amendment. Does not qualify for quick-dev routing (skill `feature-mode-scoping-rules` "single module / no new BCs / no architecture change" bar is exceeded by Workstream 4). |
| **Route** | Standard Feature-Mode F1→F7, NOT quick-dev. Workstream 4 (Teams) individually reviewed for spike/defer per the open decisions in §6. |

Bug-fix intent → per the phase-f1 skill, F2/F3 spec/story work is still required here (this is NOT a trivial one-file patch that skips straight to F4) because BCs are being amended and one workstream (Teams) may require new architecture. This is the standard bug-fix route (skip nothing structurally), not the CRITICAL-expedited route (severity is HIGH, not CRITICAL — full F1–F7 rigor applies, no skipped steps).

---

## 1. Root Cause Confirmation (code-audit, not just the brief)

Every call site named in the feature request was read directly. All confirmed as described, plus three material corrections/additions the brief and research doc did not have:

1. **`src/api/jsm/attachments.rs`** (both `attach_temporary_file` line 56 and `post_request_attachment` line 301) already builds URLs from `client.base_url()` directly — CONFIRMED correct, CONFIRMED excluded from Defect 1's fix list. However, it is **transitively broken today** because the `serviceDeskId` it receives comes from `resolve_service_desk_id` → `get_or_fetch_project_meta` → `client.list_service_desks()` (`src/api/jsm/servicedesks.rs:22`, currently `get_from_instance`) — under OAuth, that upstream call 401s before `attachments.rs` is ever reached. **Fixing `servicedesks.rs` is a hard prerequisite for JSM attachment upload working under OAuth**, even though `attachments.rs` itself needs zero code changes. This dependency must be captured in the story graph (do not schedule the JSM-attachments story independently of the JSM-routing story).
2. **`src/api/assets/objects.rs`** (`search_assets`/`get_asset`/`get_object_attributes`/`get_object_type_attributes`, all via `client.get_assets`/`post_assets`) is **already correctly gateway-routed for OAuth** — `JiraClient::assets_base_url` (`src/api/client.rs:91-101`) is built as `https://api.atlassian.com/ex/jira/{cloud_id}/jsm/assets` unconditionally (not auth-method-gated), so `get_assets`/`post_assets` (`client.rs:1096-1140`) produce `.../ex/jira/{cloud_id}/jsm/assets/workspace/{id}/v1/object/aql` — this is **byte-for-byte the URL research Q2(b) confirms as the documented 3LO AQL endpoint**. This resolves the feature request's "key open question" (§Defect 1 — Assets, item 2): **no fix needed for AQL/object routing.** Only workspace-ID *discovery* (`src/api/assets/workspace.rs:26`, `get_from_instance`) is broken.
3. **`src/api/jira/sprints.rs:99`** (`move_issues_to_backlog`, `POST /rest/agile/1.0/backlog/issue`) is **NOT the bug the research doc flagged**. Research Q3's "PATH FLAG" was about a hypothesized **GET** `backlog/issue` read path that doesn't exist in Atlassian's docs. The actual `jr` code at that line is a **POST** (issues → backlog, write operation) — which IS the documented endpoint (`POST /rest/agile/1.0/backlog/issue`, needs `write:board-scope:jira-software`). **No backlog-path code bug exists.** `jr` has no board/{id}/backlog GET call at all today (`jr sprint remove` moves issues to backlog by POST only; there is no `jr board backlog` read command). Conclusion for the human gate item (c): the backlog-path fix is **NOT applicable** — there is nothing to fix — but `write:board-scope:jira-software` must be added to `DEFAULT_OAUTH_SCOPES` for this existing POST to work under OAuth (this scope was in the research's candidate list only for board-config; it's actually needed for `sprint remove`/backlog too — see §2.2 gap).
4. **Auth-URL scope-emission (research Q5 concern) is CONFIRMED already correct** — `resolve_oauth_scopes` (`src/cli/auth/login.rs:27-34`) always resolves to either the profile's full override string or the full `DEFAULT_OAUTH_SCOPES` constant (never an incremental diff), and `build_authorize_url` (`src/api/auth.rs:2136`) encodes whatever full string it's given, with `&prompt=consent` hardcoded already. **No auth-URL-builder code change is needed for Q5's "must emit full union" concern** — editing the `DEFAULT_OAUTH_SCOPES` constant is sufficient; the plumbing already sends the whole thing every time.
5. **Existing test coverage cannot see this class of bug at all.** Every wiremock-backed test for the 9 call sites (`tests/assets.rs`, `tests/jsm_request_api.rs`, `tests/team_commands.rs`, `tests/board_commands.rs`, `tests/sprint_commands.rs`, `tests/attachment_jsm.rs`) constructs its client via `JiraClient::new_for_test(base_url, ...)`, which sets `instance_url == base_url` (`src/api/client.rs:147-159`) — so `get_from_instance` and `get` are indistinguishable in every existing test. Only `JiraClient::new_for_test_with_instance_url` (already exists, used today only by `tests/issue_open.rs`/`tests/issue_commands.rs` for the ADR-0009 browser-URL class) can actually prove a call site targets `base_url` vs `instance_url`. This confirms the feature request's "Testing gap" item precisely and gives the exact test-construction primitive to reuse.

---

## 2. Impact Boundary Per Workstream

### 2.1 Workstream A — Defect 1: JSM instance→base routing (6 call sites, 3 files)

| File:Line | Function | Change |
|---|---|---|
| `src/api/jsm/servicedesks.rs:22` | `list_service_desks` | `self.get_from_instance(&path)` → `self.get(&path)` |
| `src/api/jsm/request_types.rs:46` | `list_request_types` | same swap |
| `src/api/jsm/request_types.rs:73` | `get_request_type_fields` | same swap |
| `src/api/jsm/queues.rs:24` | `list_queues` | same swap |
| `src/api/jsm/queues.rs:67` | `get_queue_issue_keys` | same swap |
| `src/api/jsm/requests.rs:28` | `create_jsm_request` | `self.post_to_instance(...)` → `self.post(...)` |

No request body/payload shape changes anywhere in this workstream — pure base-URL swap, matching the Constraints section verbatim. `src/api/jsm/attachments.rs` is confirmed out-of-scope for code changes (item 1 in §1) but is in-scope for **test/verification** coverage of the dependency (item 1 dependency chain).

**Command surface affected:** `jr requesttype list/fields`, `jr queue list/view`, `jr issue create --request-type`, and transitively `jr issue attachment upload/download/delete --public/--internal` (JSM two-step path) and any command that calls `get_or_fetch_project_meta`/`require_service_desk` for a service-desk project (`jr queue`, `jr requesttype`, JSM attachments) — all currently reach `list_service_desks` on a project-meta cache miss.

### 2.2 Workstream B — Defect 2: Agile OAuth scope gap (config only, 1 file)

| File:Line | Change |
|---|---|
| `src/api/auth.rs:83-88` (`DEFAULT_OAUTH_SCOPES`) | Add granular Agile scopes to the existing `concat!` string |

Confirmed-required additions per research Q3 + this cycle's own code audit (item 3 above):
```
read:board-scope:jira-software     # board list/view (BC-5.1.001)
read:project:jira                  # board list (project filter)
read:sprint:jira-software           # sprint list/current, board→sprint
read:issue-details:jira            # sprint issue fetch
read:jql:jira                      # sprint issue JQL filter
read:board-scope.admin:jira-software  # board view --config (board configuration)
write:board-scope:jira-software    # sprint add/remove (add/move issues to sprint/backlog) — NOT in research's original candidate list; added by this cycle's code audit of sprints.rs (add_issues_to_sprint, move_issues_to_backlog)
```
Teams scopes (`view:team:teams`, `view:membership:teams`) are scoped to Workstream D (§2.4), not bundled into this constant edit unless Workstream D is approved to proceed in the same cycle — see §6(a).

**Companion obligations (per CLAUDE.md's own documented procedure, and BC-1.3.023's Maintainer Coordination clause):**
- Update the embedded `jr` OAuth app's Developer Console permissions before release (human/app-owner action, cannot be automated by this pipeline).
- Update `default_oauth_scopes_pins_the_full_set_with_offline_access` in `src/cli/auth/tests/mod.rs` in the same commit (BC-1.3.023 explicitly requires this).
- Add a CHANGELOG `[Unreleased]` entry calling out the re-consent prompt (`CHANGELOG.md`, `## [Unreleased]` section exists today).
- **No auth-URL-builder change needed** — confirmed in §1 item 4.

### 2.3 Workstream C — Assets workspace discovery (1 call site, 1 file)

| File:Line | Function | Change |
|---|---|---|
| `src/api/assets/workspace.rs:26` | `get_or_fetch_workspace_id` | `client.get_from_instance("/rest/servicedeskapi/assets/workspace")` → `client.get(...)` |

`src/api/assets/objects.rs` and `client.rs::get_assets`/`post_assets` (assets AQL/object/schema paths) require **no change** — confirmed already gateway-correct (§1 item 2). This narrows Workstream C to the single workspace-discovery call site, smaller than the feature request's framing suggested ("all `jr assets *`" is fixed by this one swap, not by touching the AQL layer).

### 2.4 Workstream D — Teams re-platform (HIGHEST uncertainty, largest blast radius)

Current code (`src/api/jira/teams.rs`):
| Line | Call | Problem per research Q4 |
|---|---|---|
| `:19` | `post_to_instance("/gateway/api/graphql", ...)` | Wrong **host** for OAuth, not just wrong base — even swapping to `self.post(...)` (base_url = `api.atlassian.com/ex/jira/{cloudId}`) would produce `.../ex/jira/{cloudId}/gateway/api/graphql`, which is **not** the documented OAuth GraphQL host (`https://api.atlassian.com/graphql`, no `/ex/jira/{cloudId}` prefix, no `/gateway/api`). This is **not** a same-shape routing swap like Workstreams A/C — the whole request-building logic (host, query shape via `teamSearchV2`, response parsing) changes. |
| `:43` | `get_from_instance("/gateway/api/public/teams/v1/org/{orgId}/teams")` | Research Q4(b): "Forge and OAuth2 apps cannot access this REST resource" — **CONFIRMED unreachable under OAuth by ANY base-URL swap.** There is no fix that keeps this REST call; it must be replaced entirely by a GraphQL `teamSearchV2` query. |

This is qualitatively different from Workstreams A/B/C: those are base-URL swaps (mechanical, low-risk, preserve request/response shape). Workstream D requires:
- A new GraphQL query (`teamSearchV2`) replacing the current `list_teams` REST call entirely — different response shape, different pagination model (needs verification: does `teamSearchV2` use the same cursor shape as `TeamsResponse`? Unconfirmed — no code audit possible without hitting the live GraphQL Explorer).
- `get_org_metadata` (line 12, already uses `post_to_instance` for a DIFFERENT GraphQL query — `tenantContexts`) is a **separate call** from `list_teams` and is used for cloud-ID/org-ID resolution during `jr init`, not team listing. Research Q4 did not evaluate whether `tenantContexts` also needs the `api.atlassian.com/graphql` host under OAuth, or whether it's a legitimate site-scoped GraphQL query that stays on `/gateway/api/graphql`. **This is an additional open question this F1 pass surfaces that neither the brief nor the research doc addressed** — `get_org_metadata` is NOT in the feature request's Defect-1 Teams bullet (which only names lines 19 and 43 — but line 19 is actually `get_org_metadata`, not `list_teams`'s POST; there is no POST in `list_teams` itself). Re-reading the file: **line 19's `post_to_instance` belongs to `get_org_metadata`** (tenantContexts query), not to team listing. `list_teams` (lines 33-54) only does the single `get_from_instance` at line 43. The feature request's line attribution (`teams.rs:19` and `:43`) is technically about two DIFFERENT functions, not two calls in one function — this must be disambiguated before implementation: **does `get_org_metadata` (used by `jr init`, not `jr team list`) need the same OAuth re-platform, or is it a different, already-scoped-correctly use of the site GraphQL endpoint?** Flagged as an open decision (§6).
- New/changed scopes (`view:team:teams`, possibly `view:membership:teams`) with UNCERTAIN exact string confirmation (research explicitly flags this UNCERTAIN — "verify live via GraphQL Explorer").
- Possible new architecture doc / ADR if the team-listing subsystem's host model changes (architecture currently documents `/gateway/api/*` as the pattern for org-metadata GraphQL — this would be the first Jira-adjacent Atlassian API `jr` calls that is NOT under the `{site}` or `{cloud-id}/ex/jira` gateway convention).

**Recommendation:** treat Workstream D as its own story (or its own spike) rather than folding it into this cycle's routing-swap work — see §6(a).

### 2.5 Workstream E — Defect 3: misleading error-mapping

Root cause located precisely: `src/error.rs`'s `JrError::InsufficientScope` `#[error(...)]` Display template (lines 21-29) is a **single, unconditional** message baked in at the type level — it always emits "The Atlassian API gateway rejects granular-scoped personal tokens on POST requests..." regardless of auth scheme, HTTP method, or actual failure cause. This template is constructed at two generic sites with no context-aware rewrite:
- `src/api/client.rs:773` (`send_inner`'s pre-refresh 401 body check)
- `src/api/client.rs:1045` (`parse_error`, the post-401 fallback)

Three call sites in the codebase **already** solve this correctly by rewriting the generic `InsufficientScope`/`NotAuthenticated` at the call site before it reaches the user (established pattern, do NOT reinvent):
- `src/api/jsm/servicedesks.rs:143-178` (`require_service_desk`) — rewrites to `NotAuthenticated` with an auth-scheme-conditional hint (OAuth vs Basic), used by `jr queue`/`jr requesttype`.
- `src/cli/issue/jsm_create.rs:385-433` — rewrites `InsufficientScope`/`NotAuthenticated` for the JSM POST create path, auth-scheme-conditional, and this is the ONE call site where the generic Display's POST-specific framing is genuinely correct-as-is (confirmed by `.factory/specs/prd/cross-cutting.md:935`: "this does NOT change BC-3.8.015 — the JSM POST OAuth InsufficientScope arm is genuinely the #185 POST scenario").
- `src/api/jira/attachments.rs:355-365` — has its own inline scope-mismatch → `InsufficientScope` construction, not yet call-site-rewritten (potential same-class residual, out of this cycle's stated scope but worth a footnote for the human).

**`jr board`/`jr sprint`/raw `jr api` have NO such rewrite** — a scope-mismatch 401 on any of these falls straight through to the raw, POST-framed `InsufficientScope` Display, which is precisely the bug the brief describes ("On the Agile scope-mismatch 401... wrong hint for a genuine OAuth GET scope-mismatch"). `src/cli/board.rs` and `src/cli/sprint.rs` contain **zero** scope/InsufficientScope-related code today (confirmed via grep) — there is no existing call-site rewrite to build on for Agile commands; a new one must be added, following the `require_service_desk` pattern (auth-scheme + ideally HTTP-method-aware).

**Spec conflict this surfaces:** `.factory/specs/prd/bc-1-auth-identity.md` BC-1.6.042 currently PINS the generic Display's POST-specific wording (`"5 required substrings"` including the literal `write:jira-work` default and issue #185 URL) as the CORRECT, unconditional contract for ANY `InsufficientScope`. This BC will need to either (a) stay as-is (it governs the *fallback* Display only, used correctly by the JSM-create POST path per cross-cutting.md's own note) while a NEW BC is added for the Agile-command call-site rewrite (mirroring BC-X.8.006/BC-X.8.007's shape for `require_service_desk`), or (b) be read together with a new BC that documents when call sites MUST rewrite rather than let the generic template surface. Recommend (a) — do not touch BC-1.6.042 itself (it is still correct for the POST case it documents); add new BC(s) under `bc-5-boards-sprints.md` (Agile/board/sprint scope-mismatch 401) or `cross-cutting.md` for the rewrite, following the BC-X.8.006/007 template exactly.

---

## 3. Affected Specs / BCs

| BC(s) | File | Disposition |
|---|---|---|
| BC-1.3.023 | `bc-1-auth-identity.md` | **AMEND** — `DEFAULT_OAUTH_SCOPES` literal string in "Behavior" must be updated to the new value; the "Maintainer coordination" paragraph already correctly describes the console-update + re-consent + CHANGELOG procedure needed — no change to that paragraph, only to the pinned scope string. |
| BC-1.6.042/043/044/045 | `bc-1-auth-identity.md` | **NO CHANGE** — these govern the generic `InsufficientScope` construction rule (client.rs body-substring detection), which is orthogonal to Workstream E's fix (call-site rewrite, not detection-rule change). |
| — (new) | `bc-5-boards-sprints.md` or `cross-cutting.md` | **NEW BC** needed for Workstream E: `jr board`/`jr sprint` OAuth scope-mismatch 401 → auth-scheme-aware rewrite, modeled on BC-X.8.006/BC-X.8.007. |
| BC-X.6.002 | `cross-cutting.md:607` | **MAJOR AMEND or SUPERSEDE** — currently pins `/gateway/api/public/teams/v1/org/<orgId>/teams` as the contract; Workstream D would replace this endpoint entirely. Do not touch until Workstream D scope is decided (§6a). |
| BC-X.6.003/004 | `cross-cutting.md:615,623` | Likely unaffected in shape (error paths, cache-first behavior) but Source/Behavior text referencing the REST endpoint would need updating if BC-X.6.002 changes. |
| BC-X.8.004/005/006/007/008/009/010 | `cross-cutting.md:828-1061` | **NO CHANGE** — these govern `require_service_desk`/queue/project-meta behavior at the HTTP-shape level (payload, caching, error text), which Workstream A does not alter (base-URL-only swap, per the Constraints section). Confirm via regression tests, not spec edits. |
| BC-X.12.001-008 | `cross-cutting.md:1221-1322` | **NO CHANGE** — `jr requesttype` behavior/payload/caching contracts unaffected by the base-URL swap; same confirm-via-test treatment. |
| BC-4.2.001 | `bc-4-assets-cmdb.md:26-33` | **AMEND** — Behavior text currently just says "GET `/rest/servicedeskapi/assets/workspace`"; should gain an explicit base-URL clause (base_url/gateway, not instance_url) mirroring how BC-1.2.054/EC-1.2.054-3 document the api-token vs OAuth base-URL distinction elsewhere in this spec corpus. |
| BC-4.2.002 through BC-4.2.005 | `bc-4-assets-cmdb.md` | **NO CHANGE** — confirmed already gateway-correct (§1 item 2); no code or spec change needed. |
| BC-5.1.001 | `bc-5-boards-sprints.md:26` | **NO CHANGE** to the routing clause (already `get`/base_url) — but a **cross-reference note** should be added pointing at the new scope-gap BC, since this BC's existing behavior (GET `/rest/agile/1.0/board`) is the one that currently 401s under OAuth for scope reasons, not routing reasons — a reader debugging via this BC alone would wrongly suspect a routing bug. |
| BC-3.8.001/005-009/014/015/019/022 | `bc-3-issue-write.md` | **NO CHANGE** to payload/body-construction contracts (`JsmRequestBuilder::build`, unaffected by the routing swap) — **confirm via regression test** that `create_jsm_request`'s base-URL swap doesn't alter BC-3.8.014/015's existing OAuth/Basic error-hint dispatch (it should not; the rewrite in `jsm_create.rs` operates on the `JrError` variant returned by `create_jsm_request`, independent of which URL produced the 401). |

No BC in `bc-2-issue-read.md`, `bc-6-config-cache.md`, `bc-7-output-render.md`, `bc-8-components.md` is affected — none of those files' subject areas overlap the 4 workstreams (confirmed by targeted grep for `instance_url`/`base_url`/routing terms; no hits).

### Verification properties (VP-NNN)
No dedicated `verification-properties/` directory was found under `.factory/specs/` for this project (VPs in this codebase are inline `VP-<slug>-NNN` labels embedded in BC bodies and test doc-comments, e.g. `VP-AUTHDX-017`, `VP-FIELD-ADF-004`, `VP-576-005` — there is no separate per-file VP corpus to extend). New unit/integration test additions (the "Testing gap" item) should follow this codebase's existing convention: name new pinning tests descriptively (e.g. `test_bc_x_y_z_...`) and cross-reference the amended/new BC in a doc comment, rather than minting a formal VP-NNN artifact.

---

## 4. Regression Risk Assessment

| Workstream | Risk Level | Rationale |
|---|---|---|
| A (JSM routing) | **MEDIUM** | Touches 5 functions across 3 files that are the entry point for the entire JSM command family (queue, requesttype, JSM create, transitively JSM attachments). All are currently exercised by wiremock tests using `new_for_test` (base_url==instance_url), so the swap is provably a no-op for api-token under existing test coverage — but those tests must be re-verified to still pass (mechanical, low individual risk) AND new `new_for_test_with_instance_url`-based tests must be added to prove the OAuth-path fix (net new coverage, not regression risk to existing behavior). Many dependents (`get_or_fetch_project_meta`, `require_service_desk`, `resolve_service_desk_id` all sit downstream of `list_service_desks`). |
| B (Agile scope gap) | **LOW** (code) / **MEDIUM** (release-process) | Single `const` string edit, zero logic change. Regression risk to code is near-zero. The release-process risk is real: forgetting the Developer Console update before tagging breaks OAuth login entirely (`invalid_scope` on the authorize call) for ALL new logins, not just Agile commands — this is the single highest-severity "silent breakage" vector in the whole cycle and must be a hard release gate (see §6b). |
| C (Assets workspace) | **LOW** | Single call site, isolated function, narrow blast radius (only fires on cache-miss workspace discovery; warm-cache paths are entirely unaffected). |
| D (Teams) | **HIGH** | Not a mechanical swap — new host, new query shape, new/uncertain scopes, ambiguity about whether `get_org_metadata` is in scope too (§2.4). Directly touches `jr init`'s org/cloud-ID resolution path if `get_org_metadata` turns out to be affected — that is a much higher-blast-radius surface than `jr team list` alone (breaking `jr init` would be severe). |
| E (Error mapping) | **LOW-MEDIUM** | Additive (new call-site rewrite), does not touch the shared `InsufficientScope` Display or `client.rs`'s detection logic that BC-1.6.042-045 and BC-3.8.015 depend on — but the new rewrite must be scoped precisely (Agile-command call sites ONLY) to avoid the same "shared template used somewhere it doesn't fit" mistake this defect already represents once. |

**Cross-cutting regression guard confirmed satisfiable:** the request's stated invariant — "base_url == instance_url under api-token auth, so the swap should be a no-op" — is **confirmed true by direct code read** for every host involved:
- JSM/servicedeskapi (`base_url`) — confirmed (`JiraClient::from_config`, `base_url` comes from `config.base_url()`, which for api-token profiles resolves to the site URL identically to `instance_url`).
- Teams GraphQL host (`/gateway/api/graphql`) — **only if Workstream D keeps `post_to_instance`/`get_from_instance` semantics for api-token and merely changes the OAuth branch**; if Workstream D unifies both auth modes onto `api.atlassian.com/graphql`, that is a **behavior change for api-token users too** (today api-token Teams calls hit the SITE's `/gateway/api/graphql`, which is a legitimate, working, different host from `api.atlassian.com/graphql`). This is a **new risk this F1 pass identifies that the brief did not raise**: research Q4 only evaluated the OAuth path; it did not confirm whether `api.atlassian.com/graphql` also works correctly for Basic/api-token auth, or whether the site-local `/gateway/api/graphql` must be RETAINED for api-token and only OAuth gets the new host (an auth-scheme branch, mirroring `is_oauth_auth()` branches already used elsewhere in this codebase for JSM error hints). **This must be resolved before Workstream D is implemented** — flagged in §6.
- Assets workspace discovery (`base_url`) — confirmed (assets_base_url and base_url both derive from the same cloud_id/profile-url resolution; under api-token, `base_url() == instance_url()`).

**OAuth-working command set (out-of-scope regression guard):** `jr project list`, `jr issue list`, `jr user list`, `jr api` passthrough, `/myself` — none of these call any of the 3 touched files (`jsm/*.rs`, `assets/workspace.rs`, `jira/teams.rs`) or the touched `error.rs` template's NEW call site (Workstream E only adds a NEW rewrite at board/sprint handlers, does not touch the shared Display or `client.rs` detection). Confirmed zero code overlap by file-level dependency read.

---

## 5. Existing Tests in the Regression-Risk Zone

| Test file | Covers | Needs update for this cycle? |
|---|---|---|
| `tests/jsm_request_api.rs` | JSM create request body/API | Re-run only (no `instance_url`/`base_url` distinction to prove — uses `new_for_test`); ADD new OAuth-routing-specific test(s) |
| `tests/attachment_jsm.rs` | JSM attachment two-step flow | Re-run only; already correct per §1 item 1 but exercise the dependency chain once `servicedesks.rs` changes |
| `tests/assets.rs`, `tests/assets_errors.rs` | Assets search/view/schema/workspace discovery | Re-run only for AQL/object paths (no change); ADD new OAuth-routing test for `get_or_fetch_workspace_id` |
| `tests/team_commands.rs`, `tests/team_column_parity.rs`, `tests/team_object_shape.rs` | Team listing, team-column rendering | `team_commands.rs` needs the most substantial rework if Workstream D proceeds (new host, new query shape); the other two are about rendering/column logic downstream of `list_teams`'s return type and are lower risk if the `TeamEntry`/`TeamsResponse` shape is preserved |
| `tests/board_commands.rs`, `tests/sprint_commands.rs`, `tests/boards_sprints_holdouts.rs` | Board/sprint list/view/add/remove | Re-run only (no routing change here); ADD new test(s) for Workstream E's error-mapping rewrite |
| `tests/oauth_flow_holdouts.rs`, `tests/oauth_help_text.rs`, `tests/oauth_refresh_integration.rs`, `tests/oauth_embedded_login.rs` | OAuth login/refresh flow, scope docs | `oauth_help_text.rs` and any test asserting the literal `DEFAULT_OAUTH_SCOPES` string (`src/cli/auth/tests/mod.rs::default_oauth_scopes_pins_the_full_set_with_offline_access`) MUST be updated in the same commit as the scope-constant edit (Workstream B) |
| `tests/auth_output_json.rs`, `tests/auth_status_json.rs` | `auth status`/`auth list` JSON | Unaffected — no scope-string assertions found in these files by name; confirm during F4 |
| **New test primitive required** | N/A | `JiraClient::new_for_test_with_instance_url(base_url, instance_url, auth_header)` (already exists, `src/api/client.rs:193-209`) is the correct, already-existing seam for the "assert the fixed call sites build requests against `base_url`, not `instance_url`" success criterion — no new test infrastructure needs to be built, only new test CASES using existing infrastructure. |

---

## 6. Open Decisions for the Human F1 Gate

**(a) Teams re-platform: proceed this cycle, spike, or defer?**
Recommend: **spike or defer Workstream D to a follow-on cycle.** Rationale: (1) research itself flags the exact scope-string set as UNCERTAIN pending live GraphQL Explorer verification — cannot be pinned today without a live check against a real Developer Console app; (2) this F1 pass surfaced a NEW open question (whether `get_org_metadata`/`jr init` is also affected, and whether api-token Teams calls must keep the site-local host while only OAuth moves to `api.atlassian.com/graphql`) that materially changes the risk profile and cannot be resolved from static code + docs research alone; (3) it is architecturally distinct from the other 3 workstreams (host re-platform vs mechanical base-URL swap) and bundling it risks delaying the other 3, lower-risk, higher-confidence fixes. If deferred, `jr team list` remains broken under OAuth exactly as it is today (no regression — status quo preserved) while Workstreams A/B/C/E ship independently.

**(b) `DEFAULT_OAUTH_SCOPES` change as a release gate.**
Recommend: treat the Developer-Console permission update as a **hard pre-release gate**, not a follow-up task — an OAuth login/refresh will hard-fail with `invalid_scope` for every user if the constant ships without the Console update landing first. This should be tracked as an explicit manual checklist item in the release/PR description (mirroring how CLAUDE.md already documents the procedure), and the CHANGELOG entry should be drafted in the same PR that changes the constant (F4/F6), not deferred to release time.

**(c) Backlog-path fix: in scope?**
**Resolved by this F1 pass: NOT applicable.** §1 item 3 shows the `move_issues_to_backlog` POST is already the correct, documented endpoint; the research doc's "PATH FLAG" concern was about a hypothesized GET read path that does not exist in `jr`'s code. No fix needed here beyond the `write:board-scope:jira-software` scope addition already folded into Workstream B (§2.2).

**(d) OAuth E2E coverage strategy.**
Recommend the feature request's own stated fallback: unit/integration assertions using the existing `new_for_test_with_instance_url` seam (proving each fixed call site targets `base_url`), NOT a live-OAuth CI harness (explicitly out of scope per the brief). This requires no new test infrastructure (§5) — only new test cases per touched call site (Workstreams A and C: 6 new/adapted assertions; Workstream E: 1-2 new assertions for the error-mapping rewrite; Workstream D, if it proceeds, would need its own new mock-based tests against the new host/query shape).

**(e) NEW — get_org_metadata scope ambiguity (surfaced by this F1 pass, not in the original brief).**
Needs an explicit human decision before Workstream D (if approved) begins: is `jr init`'s `get_org_metadata` (tenantContexts GraphQL query, currently `post_to_instance("/gateway/api/graphql", ...)`) in scope for the same re-platform as `list_teams`, or is it a legitimately different, already-correct use of the site-local GraphQL endpoint that must NOT be touched? Getting this wrong risks breaking `jr init` under OAuth, which is a materially worse regression than the status-quo-broken `jr team list`.

**(f) NEW — Teams host must not regress api-token users (surfaced by this F1 pass).**
If Workstream D proceeds, the implementation must brancj on `client.is_oauth_auth()` (existing predicate, already used for JSM error-hint dispatch) so that api-token profiles KEEP calling the site-local `/gateway/api/graphql` + `/gateway/api/public/teams/...` (confirmed working today, per the brief's own "Out of Scope" list implicitly assuming Teams commands currently work under api-token) while ONLY OAuth profiles switch to `api.atlassian.com/graphql` + `teamSearchV2`. This is NOT a simple base-URL swap like Workstreams A/C — it is an auth-scheme fork, a materially different code shape.

---

## 7. Recommended Story Decomposition Preview

| Candidate Story | Workstream(s) | Size | Depends on |
|---|---|---|---|
| S1 — `jsm-servicedeskapi-oauth-routing` | A | S (mechanical swap, 5 functions/3 files + new tests) | — |
| S2 — `agile-oauth-scope-gap` | B | XS (const edit + pinning-test update + CHANGELOG) | Independent of S1; should land alongside a Developer Console update task (human, non-code) |
| S3 — `assets-workspace-oauth-routing` | C | XS (1 call site + new test) | Independent |
| S4 — `agile-scope-mismatch-error-mapping` | E | S (new call-site rewrite in `board.rs`/`sprint.rs`, modeled on `require_service_desk`) | Best sequenced AFTER S2 (needs the real Agile-scope-mismatch case to exist/be testable against; can be built with a mocked 401 body independently, but validating the fix narrative is easier once S2's scopes are defined) |
| S5 — `jsm-attachments-oauth-verification` | A (dependency only, no code change) | XS (verification-only: confirm `attachments.rs` succeeds end-to-end once S1 lands; add a regression test proving the dependency chain) | Hard dependency on S1 |
| S6 (SPIKE, not a delivery story) — `teams-graphql-oauth-replatform-spike` | D | Spike-sized (research + live Developer-Console verification of `view:team:teams` addability + resolve open decisions e/f) | Independent; recommend running in parallel with S1-S5 but NOT gating this cycle's release on its outcome |
| S7 (conditional on S6's findings) — `teams-graphql-oauth-replatform` | D | M-L (new host, new query, new scope, api-token/OAuth fork, new tests, possible new BC/ADR) | S6 |

Estimated complexity: S1/S3 mechanical-low; S2 trivial-but-process-heavy (release gate); S4 small-medium (new error-mapping code, needs care to avoid over-broadening rewrite scope); S5 verification-only; S6/S7 the only workstream with real architectural uncertainty and unknown size until the spike resolves the open questions in §6(a/e/f).

---

## 8. Files NOT Changed (Regression Baseline)

Confirmed via code read — none of these are touched by any workstream and must produce byte-identical behavior pre/post this cycle:
- `src/api/jira/issues.rs`, `src/api/jira/users.rs`, `src/api/jira/projects.rs`, `src/api/jira/boards.rs`, `src/api/jira/statuses.rs`, `src/api/jira/resolutions.rs`, `src/api/jira/links.rs`, `src/api/jira/worklogs.rs`, `src/api/jira/fields.rs`, `src/api/jira/bulk.rs`, `src/api/jira/attachments.rs` (platform attachments — distinct file from `src/api/jsm/attachments.rs`), `src/api/jira/components.rs`, `src/api/jira/tenant.rs`
- `src/api/jira/sprints.rs` itself (no line in this file changes — `move_issues_to_backlog` is confirmed already correct; only the OAuth *scope* it needs changes, in `auth.rs`, not here)
- `src/api/assets/objects.rs`, `src/api/assets/linked.rs`, `src/api/assets/schemas.rs`, `src/api/assets/tickets.rs`
- `src/api/jsm/attachments.rs`, `src/api/jsm/servicedesks.rs` (this file: only `list_service_desks` line 22 changes; `get_or_fetch_project_meta`, `resolve_service_desk_id`, `require_service_desk` in the same file are unchanged)
- `src/api/client.rs` — no change to `get`/`post`/`get_from_instance`/`post_to_instance`/`get_assets`/`post_assets`/`send_inner`/`parse_error` definitions themselves (Workstream E adds a NEW call site elsewhere, doesn't modify these); `assets_base_url` computation unchanged (already correct)
- `src/cli/auth/login.rs` (`resolve_oauth_scopes`, `build_authorize_url`'s call site) — confirmed already correct, no change
- `src/error.rs` — the `InsufficientScope`/`NotAuthenticated` type definitions and `#[error(...)]` Display templates are UNCHANGED (Workstream E is additive at new call sites, not a Display-template edit)
- Everything in `src/cli/issue/` except no changes at all expected (JSM create's error-hint rewrite in `jsm_create.rs` is pre-existing and correct, confirmed not touched)
- `src/config.rs`, `src/cache.rs`, `src/profile.rs`, `src/adf.rs`, `src/duration.rs`, `src/output.rs`, `src/jql.rs`, `src/partial_match.rs` — no overlap with any workstream

---

## Summary for Human Gate

- **Scope confirmed narrower than the brief for Assets** (only workspace discovery, not AQL) and **confirmed a non-issue for the backlog path** — both resolved by direct code audit in this pass.
- **Scope confirmed WIDER than the brief for Teams** — two new open questions (`get_org_metadata` ambiguity, api-token-host-preservation requirement) that make Workstream D materially riskier than a routing swap.
- **Recommend shipping Workstreams A, B, C, E this cycle** (all mechanical-to-small, well-understood, testable with existing seams) and **spiking Workstream D separately** before committing to its implementation shape.
- **Single highest operational risk**: forgetting the Developer Console scope update before release (Workstream B) — recommend a hard release-gate checklist item, not just a CHANGELOG note.
