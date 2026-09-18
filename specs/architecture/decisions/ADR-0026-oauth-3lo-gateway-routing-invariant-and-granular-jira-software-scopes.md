---
document_type: adr
adr_id: ADR-0026
status: accepted
date: 2026-09-17
subsystems_affected: [SS-02, SS-03, SS-04, SS-05, SS-06, SS-08]
supersedes: null
superseded_by: null
---

# ADR-0026: OAuth 3LO Gateway Routing Invariant and Granular Jira-Software Scopes

> **Cycle:** cycle-008 "oauth-surface-correctness" (Feature-Mode F2, delta-only).
> **Inputs:** `.factory/cycles/cycle-008/F1-delta-analysis.md` (approved scope, DEC-368),
> `.factory/cycles/cycle-008/research-oauth-endpoints.md` (Perplexity deep-research + WebFetch verification).
> **Approved F1 scope (DEC-368):** DELIVER Workstreams A/B/C/E (S1/S2/S3/S4/S5 below).
> Workstream D (Teams) = SPIKE ONLY this cycle (S6) — see §Deferred/Context.
> **F2 gate finalization inputs:** `.factory/cycles/cycle-008/oauth-scope-matrix.md` (per-endpoint
> scope audit against all 82 inventoried endpoints; FINAL recommended `DEFAULT_OAUTH_SCOPES` set,
> full-parity option chosen by the human at the F2 gate) and
> `.factory/cycles/cycle-008/oauth-endpoint-inventory.md` (the 82-endpoint code-grounded inventory
> the matrix cross-references). These finalize Decision 2 below; they do not alter Decisions 1, 3,
> or 4.

## Context

`jr` supports two authentication schemes against Jira Cloud: API-token (Basic auth against the
site's own host) and OAuth 2.0 3LO (bearer tokens that must be routed through Atlassian's API
gateway, `https://api.atlassian.com/ex/jira/{cloudId}/...`). `JiraClient` (`src/api/client.rs`)
exposes two parallel families of HTTP helpers to support this split: `get`/`post` (address
`base_url`, the gateway/API host) and `get_from_instance`/`post_to_instance` (address
`instance_url`, the site's own host — reserved for browser-facing URLs, per ADR-0009).

Live use under an OAuth profile surfaced widespread 401s across the JSM (`jr queue`,
`jr requesttype`, `jr issue create --request-type`), Assets (`jr assets *`), and Agile
(`jr board`, `jr sprint`) command families, plus a misleading, unconditional error message on
Agile scope-mismatch 401s. Cycle-008's F1 delta analysis (code-audited, not just brief-derived)
confirmed the root causes are three independent, narrowly-scoped defects:

1. Six JSM call sites and one Assets call site call `get_from_instance`/`post_to_instance`
   (targeting `instance_url`, the site host) where they should call `get`/`post` (targeting
   `base_url`, the gateway) — under OAuth these are different hosts; under API-token they resolve
   to the same URL, which is exactly why the bug was invisible until live OAuth use and why every
   existing wiremock test (constructed via `JiraClient::new_for_test`, which sets
   `base_url == instance_url`) cannot detect this class of defect.
2. `DEFAULT_OAUTH_SCOPES` (`src/api/auth.rs`) holds only classic scopes
   (`read:jira-work`/`write:jira-work`/etc.). Atlassian's Jira Software (Agile) REST API
   (`/rest/agile/1.0/...`) does not accept classic scopes at all — it requires a disjoint set of
   granular `*:jira-software`/`*:jira` scopes, confirmed by official Atlassian docs
   ("Jira Software doesn't support classic scopes. Use granular scopes instead.").
3. `JrError::InsufficientScope`'s Display template (`src/error.rs`) is a single, unconditional,
   POST-framed message. It is correct for the one call site it was originally written for
   (`jr issue create --request-type`'s JSM POST path) but is misleading when it leaks through for
   an Agile GET scope-mismatch, because `jr board`/`jr sprint` have no call-site rewrite at all
   today (unlike JSM, which already has one in `require_service_desk`).

This ADR also inherits an explicitly unresolved fourth area — Teams (`src/api/jira/teams.rs`) —
which F1 found to be architecturally distinct (a host re-platform, not a routing swap) and too
uncertain to fix this cycle. It is recorded here as deferred context, not decided.

## Decision

**1. OAuth 3LO gateway-routing invariant (inverse of ADR-0009).** Under an OAuth (3LO) auth
profile, every Jira Cloud REST call `jr` makes — platform (`/rest/api/3/...`),
JSM/servicedeskapi (`/rest/servicedeskapi/...`), and Assets workspace discovery
(`/rest/servicedeskapi/assets/workspace`) — MUST be addressed via `base_url`
(`https://api.atlassian.com/ex/jira/{cloudId}/...`), never via `instance_url`. This is the
mirror image of ADR-0009: ADR-0009 established that `instance_url` exists *only* for
browser-facing `/browse/{key}` URLs (`handle_open`) and must never be used for an API call;
this ADR closes the opposite-direction gap — API calls must never use `instance_url` either.
Together, ADR-0009 and this ADR fully partition the two host variables' legitimate uses: API
calls → `base_url`; browser URLs → `instance_url`; nothing else is a valid use of either.

The fix is a mechanical method swap, not a payload or routing-logic change, at exactly seven
call sites:

| File::Symbol | Change |
|---|---|
| `src/api/jsm/servicedesks.rs::list_service_desks` | `get_from_instance` → `get` |
| `src/api/jsm/request_types.rs::list_request_types` | `get_from_instance` → `get` |
| `src/api/jsm/request_types.rs::get_request_type_fields` | `get_from_instance` → `get` |
| `src/api/jsm/queues.rs::list_queues` | `get_from_instance` → `get` |
| `src/api/jsm/queues.rs::get_queue_issue_keys` | `get_from_instance` → `get` |
| `src/api/jsm/requests.rs::create_jsm_request` | `post_to_instance` → `post` |
| `src/api/assets/workspace.rs::get_or_fetch_workspace_id` | `get_from_instance` → `get` |

`src/api/jsm/attachments.rs` requires **no code change** — it already builds URLs from
`client.base_url()` directly (confirmed correct by F1 code audit) — but it is **transitively
dependent** on the `servicedesks.rs` fix, because the `serviceDeskId` it needs is resolved via
`resolve_service_desk_id` → `get_or_fetch_project_meta` → `list_service_desks`, which 401s
under OAuth today before `attachments.rs` is ever reached. `src/api/assets/objects.rs` and
`client.rs::get_assets`/`post_assets` (AQL/object/schema paths) require **no change** — they are
already unconditionally gateway-routed via `assets_base_url` and are confirmed correct.

The invariant that makes this swap provably safe is: under API-token auth, `base_url() ==
instance_url()` (both resolve to the site URL), so `get_from_instance`/`get` (and
`post_to_instance`/`post`) are indistinguishable today for API-token profiles — the swap is a
no-op for API-token and a fix for OAuth. `JiraClient::new_for_test_with_instance_url`
(`src/api/client.rs`, an existing test seam, previously used only by `tests/issue_open.rs` /
`tests/issue_commands.rs` for the ADR-0009 browser-URL class) is the correct, already-existing
primitive for proving each fixed call site now targets `base_url` — the more commonly used
`JiraClient::new_for_test` cannot distinguish the two hosts and therefore cannot prove this fix.

**2. Full-parity OAuth scope set (FINALIZED at the cycle-008 F2 human gate).** At the F2 gate,
presented with the endpoint-by-endpoint audit in `oauth-scope-matrix.md` (cross-referencing all
82 endpoints in `oauth-endpoint-inventory.md`), the human selected the **full-parity** option over
a narrower Agile-only expansion (see Alternatives Considered). `DEFAULT_OAUTH_SCOPES`
(`src/api/auth.rs`, the `concat!` constant) grows from its current 8 scopes to the following
finalized 16-scope set — 8 existing scopes unchanged, 8 new scopes added:

```
# --- Platform issue/user/field CRUD (existing, unchanged) ---
read:jira-work
write:jira-work
read:jira-user

# --- Component administration (NEW — closes the component-write gap, Decision 2a below) ---
manage:jira-project

# --- JSM (existing, unchanged) ---
read:servicedesk-request
write:servicedesk-request

# --- Assets/CMDB (existing, unchanged) ---
read:cmdb-object:jira
read:cmdb-schema:jira

# --- Agile / Jira Software (NEW — granular scopes mandatory; classic scopes do not apply) ---
read:board-scope:jira-software        # board list/view
read:board-scope.admin:jira-software  # board view --config (co-required with read:project:jira below, per oauth-scope-matrix.md #53)
read:sprint:jira-software             # sprint list/current, board→sprint
write:board-scope:jira-software       # sprint add/remove (move issues to/from backlog)
read:project:jira                     # board list project filter
read:issue-details:jira               # sprint issue fetch
read:jql:jira                         # sprint issue JQL filter

# --- Refresh token (existing, unchanged) ---
offline_access
```

> **Note on ordering:** the grouping/ordering of the scope-block above is illustrative
> (grouped by API family for readability). It is NOT the authoritative wire-order — the
> pinned literal string in `BC-1.3.023` (`bc-1-auth-identity.md`), which mirrors the exact
> `concat!` order in `src/api/auth.rs`'s `DEFAULT_OAUTH_SCOPES` constant, is authoritative
> for both content and order. Implementers must match `BC-1.3.023`'s literal, not this
> block's grouping.

`write:board-scope:jira-software` was not in the original research candidate list — it was
added by this cycle's own code audit of `sprints.rs` (`add_issues_to_sprint`,
`move_issues_to_backlog`), both of which are existing, already-correct POST paths that need this
scope to function under OAuth. Teams scopes (`view:team:teams`, `view:membership:teams`) remain
explicitly **excluded** from this edit — they belong to the deferred Workstream D (Decision 4) and
must not be bundled into `DEFAULT_OAUTH_SCOPES` until that workstream is separately approved.

No change is required to the auth-URL builder (`resolve_oauth_scopes` in
`src/cli/auth/login.rs`, `build_authorize_url` in `src/api/auth.rs`) — both already always emit
the full scope-union string with `prompt=consent` hardcoded (confirmed by F1 code audit), which
satisfies Atlassian's "a new consent overrides the previous grant's scopes; always request the
full intended union" requirement without any code change; this holds regardless of the scope
set's final size, so the component-administration addition (Decision 2a) required no further
auth-URL work either.

**2a. Component-write scope gap (NEW finding, F2 deep audit; folded into the same
scope-constant edit).** The F2 audit (`oauth-scope-matrix.md` headline verdict 2;
`oauth-endpoint-inventory.md` rows #41/#42/#44) discovered a second, independent OAuth scope gap
adjacent to the bulk-API investigation: `POST
/rest/api/3/component` (create), `PUT /rest/api/3/component/{id}` (edit/rename), and `DELETE
/rest/api/3/component/{id}` (delete) — backing `jr component create`/`edit`/`rename`/`delete` —
require the classic **`manage:jira-project`** scope, **not** `write:jira-work`. This is confirmed
against the official Atlassian project-components API reference, not inferred. Unlike the
JSM/Assets/Agile defects Decision 1 and the rest of Decision 2 address, these three endpoints
already route correctly (`base_url`/gateway) and require **no routing change** — they are, and
were, silently OAuth-broken purely because the correct scope was never granted; fixing them is
scope-addition-only. `jr component list` (`GET /rest/api/3/project/{key}/components`, inventory
#39) and `jr component delete`'s disposition-safety pre-check (`GET
/rest/api/3/component/{id}/relatedIssueCounts`, inventory #40) are read-only and are already
correctly covered by the held `read:jira-work` scope — only the three write paths were gapped.
This gap was surfaced *adjacent to* the F2 audit's bulk-issue-operations investigation (see the
"Confirmed findings (not to be re-litigated)" subsection under Consequences for the bulk-API
verdict, which required no scope change).

Three companion obligations attach to this scope-constant edit — both the component and Agile
additions travel together as one edit — all of which must land in the same change set (per
CLAUDE.md's own documented `DEFAULT_OAUTH_SCOPES` procedure and BC-1.3.023's Maintainer
Coordination clause):
- Update `default_oauth_scopes_pins_the_full_set_with_offline_access`
  (`src/cli/auth/tests/mod.rs`) to the new 16-scope string, in the same commit.
- Add a CHANGELOG `[Unreleased]` entry describing the re-consent prompt users will see, covering
  BOTH the Agile and component-administration scope additions — not Agile alone.
- Update the embedded `jr` OAuth app's permissions in the Atlassian Developer Console **before**
  the release ships, adding **all eight** new scopes (`manage:jira-project` plus the seven
  granular Agile scopes listed above) — this is a human/app-owner action outside this pipeline's
  automation, and is treated as a hard release gate (see Consequences).

**3. Error-taxonomy: call-site rewrite, not template widening.** `JrError::InsufficientScope`'s
Display template in `src/error.rs` (constructed at `src/api/client.rs`'s `send_inner` pre-refresh
401 check and `parse_error`'s post-401 fallback) is **left unchanged**. It remains correct for
its proven use at `src/cli/issue/jsm_create.rs`'s JSM-create POST path (BC-3.8.015). This ADR
does not modify `src/error.rs` and does not touch BC-1.6.042's pinned Display contract.

Instead, a new call-site rewrite is added for `jr board`/`jr sprint` — today
`src/cli/board.rs`/`src/cli/sprint.rs` contain zero scope/InsufficientScope-handling code
(confirmed by grep) — modeled on the existing, proven pattern in
`src/api/jsm/servicedesks.rs::require_service_desk`, which rewrites the generic
`InsufficientScope`/`NotAuthenticated` into an auth-scheme-conditional (OAuth vs. Basic) hint
before it reaches the user. The general architectural pattern this decision establishes: 401
ambiguity is always resolved by a **call-site rewrite** close to the failing operation, never by
widening the shared Display template to cover every caller — a call site is expected to
disambiguate between three 401 classes before choosing (or declining) a rewrite:

  (i) **wrong-host-401** — the routing bug this ADR's Decision 1 fixes; once fixed, this class
      should no longer occur for the seven corrected call sites;
  (ii) **genuine insufficient OAuth scope** — needs the granular-scope-aware hint this ADR's
       Decision 2 makes satisfiable;
  (iii) **expired/invalid token** — must continue to route to the existing auto-refresh path
        (`src/api/refresh_coordinator.rs`), never surface as `InsufficientScope`.

**4. Deferred/Context — Teams re-platform (NOT decided by this ADR).** Workstream D (Teams,
`src/api/jira/teams.rs`) is explicitly out of scope for cycle-008 beyond a spike (S6). This ADR
records, without deciding, the following open questions the S6 spike must resolve before any
Workstream D implementation:

- Whether `jr`'s Teams GraphQL/REST calls should move to `https://api.atlassian.com/graphql`
  (`teamSearchV2`) for OAuth profiles while API-token profiles keep the site-local
  `/gateway/api/graphql` — an **auth-scheme fork** via the existing `is_oauth_auth()` predicate,
  qualitatively different from the mechanical `base_url`/`instance_url` swap this ADR performs
  for Decisions 1–3. Research confirms OAuth clients use a *different host entirely*
  (`api.atlassian.com/graphql`, no `/ex/jira/{cloudId}` prefix), not simply `base_url` vs.
  `instance_url` — this would be a **third host family** this codebase does not yet model.
- Whether `get_org_metadata` (`src/api/jira/teams.rs`, used by `jr init`'s org/cloud-ID
  resolution — a *different function* from `list_teams`) is also affected. Getting this wrong
  risks breaking `jr init` under OAuth, a materially worse regression than the status-quo-broken
  `jr team list`.
- That the Teams *public REST* endpoint (`/gateway/api/public/teams/v1/org/{orgId}/teams`) is
  confirmed unreachable under OAuth by any base-URL swap (Atlassian docs: "Forge and OAuth2 apps
  cannot access this REST resource") and must be replaced by a GraphQL query entirely, not
  routed differently.

This ADR flags, as a known gap it does **not** close: the routing invariant in Decision 1
(`base_url` for API calls, `instance_url` for browser URLs, per ADR-0009) may need a documented
**exception or amendment** once Teams work resumes, since Teams may require a third host class
outside that binary partition. A follow-on ADR (or an amendment to this one) is expected at that
time, not before.

## Rationale

- **Mechanical-swap-first, host-abstraction-unchanged**: F1's code audit confirmed the existing
  `get`/`get_from_instance` split is the *correct* abstraction for platform calls today — the
  bug is that seven call sites used the wrong one of the two already-correct methods, not that
  the two-method design itself is flawed. Fixing the call sites (Decision 1) is lower-risk and
  more surgical than introducing a new auto-selecting host helper (see Alternatives).
- **Scope change is unavoidable, not a design choice**: Atlassian's own documentation is explicit
  that Jira Software's Agile API rejects classic scopes outright; there is no code-only
  workaround. `write:board-scope:jira-software`'s inclusion is justified by F1's own audit of
  `sprints.rs`'s existing (already-shipped, already-correct) POST paths — omitting it would leave
  `jr sprint remove` broken under OAuth even after this cycle.
- **Call-site rewrite preserves a proven, working pattern** (`require_service_desk`) rather than
  risking regression of the one call site (`jsm_create.rs`) where the generic Display template is
  demonstrably correct today (BC-3.8.015, confirmed via `.factory/specs/prd/cross-cutting.md`).
  Widening the shared template would require re-deriving correctness for every existing caller,
  not just adding a new one.
- **Deferring Teams satisfies the regression-risk assessment in F1 §4**: Workstream D is rated
  HIGH risk (new host, new query shape, uncertain scopes, and a live open question about whether
  `jr init` is affected) versus LOW–MEDIUM for Decisions 1–3. Bundling it would gate three
  well-understood, testable fixes behind one poorly-understood one.

## Consequences

### Positive

- Fixes `jr queue`, `jr requesttype`, `jr issue create --request-type`, `jr issue attachment
  upload/download/delete --public/--internal` (transitively), `jr assets *` (workspace
  discovery), `jr board`, `jr sprint`, and — via the Decision 2a scope addition, not a routing
  change — `jr component create`/`edit`/`delete`/`rename` under OAuth, with **zero behavior
  change under API-token auth** (provable no-op per the `base_url() == instance_url()` invariant
  for that auth scheme).
- Every fixed call site is testable today using an existing seam
  (`JiraClient::new_for_test_with_instance_url`) — no new test infrastructure required.
- Error-mapping fix is additive (new call sites only); it does not touch or risk regressing the
  shared `InsufficientScope` Display template or the one call site (`jsm_create.rs`) already
  proven correct against it.
- Narrow, auditable blast radius: 7 call-site swaps + 1 `const` string + 1 new call-site rewrite
  module, all independently revertible.

### Negative / Trade-offs

- **Release-process risk (highest-severity item this cycle)**: if the Developer Console
  app-permission update is not landed *before* the `DEFAULT_OAUTH_SCOPES` change ships, every
  OAuth login/refresh — not just Agile or component commands — hard-fails with `invalid_scope`.
  The Console update must add **all eight** new scopes in one pass: `manage:jira-project` AND the
  seven granular Agile scopes (`read:board-scope:jira-software`,
  `read:board-scope.admin:jira-software`, `read:sprint:jira-software`,
  `write:board-scope:jira-software`, `read:project:jira`, `read:issue-details:jira`,
  `read:jql:jira`) — adding only the Agile subset would ship with `jr component
  create`/`edit`/`delete`/`rename` still silently OAuth-broken. The auth-URL builder already
  emits the full scope union unconditionally (Decision 2 — confirmed by F1/F2 code audit, no code
  change needed there), so the sole remaining action is the Console-side app-permission update;
  every existing OAuth user will see a re-consent (`prompt=consent`) prompt on next login/refresh
  as a result. This must be a hard, explicit pre-release checklist gate, not a follow-up task or a
  CHANGELOG-only note.
- `jr team list` (and the rest of Workstream D) remains broken under OAuth exactly as it is
  today — this is accepted status-quo, not a regression, but it is a known, unresolved user-facing
  gap this ADR does not close.
- The routing invariant stated in Decision 1 is a clean binary partition (`base_url` vs.
  `instance_url`) that does not yet account for a possible third host class
  (`api.atlassian.com/graphql`, no gateway prefix) that Teams work may require — this ADR
  explicitly does not attempt to generalize the invariant preemptively for a workstream that
  hasn't been designed yet.

### Confirmed findings (not to be re-litigated)

- **Classic-vs-granular coexistence — CONFIRMED, no forced migration.** Adding the granular
  `*-software`/`*:jira` Agile scopes to `DEFAULT_OAUTH_SCOPES` does not invalidate or require
  migrating the classic `read:jira-work`/`write:jira-work`/`read:jira-user` scopes for platform
  REST v3 endpoints. There is no "once granular, granular everywhere" rule — Atlassian's own
  guidance is to use classic scopes wherever they are available and reach for granular/other
  classic scopes only where the default classic pair is rejected outright (Jira Software for
  granular; component administration for the `manage:jira-project` classic exception). Re-confirmed
  during the F2 deep audit (`oauth-scope-matrix.md` §(e)); should not be re-investigated in a
  future cycle.
- **Bulk API — CONFIRMED no scope gap.** `POST /rest/api/3/bulk/issues/fields`, `POST
  /rest/api/3/bulk/issues/transition`, and `GET /rest/api/3/bulk/queue/{taskId}` (backing `jr
  issue edit`/`jr issue move`'s bulk paths) are fully covered by the classic
  `write:jira-work`/`read:jira-work` scopes already held — there is no dedicated bulk-API scope,
  and the bulk endpoints are available to 3LO/OAuth apps despite the "Connect apps cannot access"
  marker in Atlassian's docs (which does not bar OAuth 2.0 apps specifically). This resolves the
  `oauth-endpoint-inventory.md` #20-22 NEEDS-RESEARCH flags as a non-issue (re-classified OK in
  `oauth-scope-matrix.md` Family 1); no `DEFAULT_OAUTH_SCOPES` change is warranted for bulk
  operations, and this should not be re-investigated in a future cycle.

### Status as of 2026-09-17

Decision 2 (the OAuth scope set, including sub-decision 2a) is **FINALIZED**: at the cycle-008 F2
human gate, the human reviewed the full endpoint-by-endpoint audit (`oauth-scope-matrix.md`) and
selected the full-parity 16-scope set documented above, resolving both the Agile scope gap and
the newly-discovered component-write (`manage:jira-project`) gap in a single decision. Decisions
1, 3, and 4 (the routing invariant, the error-taxonomy call-site rewrite, and the deferred Teams
workstream) are unaffected by this finalization and remain as stated above. This ADR remains a
specification artifact only — no `src/` changes have been made under it. Implementation is
scoped to stories S1 (Workstream A), S2 (Workstream B), S3 (Workstream C), S4 (Workstream E), and
S5 (Workstream A dependency verification) per the F1 delta analysis §7 story-decomposition
preview.

**Amendment note (2026-09-17, adversary finding F1 residual, product-owner mechanical
consistency-propagation sweep):** the Decision 2 scope-list's `read:board-scope.admin:jira-software`
comment (`# board view --config`) is clarified as co-required with `read:project:jira` per
`oauth-scope-matrix.md` #53 (`get_board_config` requires BOTH scopes, not the admin scope alone).
No scope-set change (still the finalized 16-scope union already listed above, where
`read:project:jira` is already present) — wording-accuracy only, matching the same correction
already applied to BC-X.15.001 in `cross-cutting.md`.

**Amendment note (2026-09-17, wave-level finding F-WG-1, human-approved scope amendment, ruling =
EXPAND, product-owner burst):** Decision 3's call-site-rewrite coverage is EXTENDED beyond the
originally-named `jr board`/`jr sprint` boundary (and beyond the same-day F1 amendment above, which
stayed within that same boundary by adding internal `board.rs`/`sprint.rs` resolution helpers). The
human ruled that the SAME 401-disambiguation pattern must also cover the identical Agile HTTP calls
made by two other command families this ADR's original F1 delta analysis did not audit:
- `src/cli/issue/list.rs::handle_list`'s board-resolution/board-based-JQL path (its
  `get_board_config` call, and its `list_sprints` call when the resolved board is scrum-type) —
  same hints as the `board.rs`/`sprint.rs` sites that make the identical underlying calls
  (`oauth-scope-matrix.md` #53 and #55 respectively).
- `src/cli/init.rs::handle`'s per-project setup prompt (`list_boards` call) — same hint as
  `jr board list`/`resolve_board_id` (`oauth-scope-matrix.md` #52).
No new scope strings are introduced (the finalized 16-scope `DEFAULT_OAUTH_SCOPES` set above is
unchanged) and no new detection rule is introduced — this is a call-site-count extension of the
existing Decision 3 pattern, not a new architectural decision. Full disposition, the mechanical
hint mapping, and the amended acceptance criteria are recorded in `BC-X.15.001`
(`.factory/specs/prd/cross-cutting.md`) and in the amended
`S-cycle8-agile-scope-mismatch-error-mapping` story (v1.4, AC-013..AC-015).

### Status as of 2026-09-18 (F7 close — supersedes the section above)

Phase F5 scoped adversarial review CONVERGED (3 clean passes on the whole delta `0793b9c5`..`fc608cd3`,
novelty 0.10; FIX-F5-001 merged `develop@fc608cd3`, PR #844). Phase F6 targeted hardening COMPLETE
(`HARDENED_WITH_RESIDUALS`, no BLOCKING findings — `cycles/cycle-008/phase-f6-hardening/hardening-record.md`).
Per the human's explicit F7-gate instruction ("fix examine_globs first, then close"), FIX-F7-001
(PR #845, `develop@0834c9f0`) landed first, closing the `CYCLE-008-F6-MUTANTS-EXAMINE-GLOBS-GAP`
residual for 6 of the 7 delta files (the 7th, `src/cli/init.rs`, deferred with documented
rationale — `CYCLE-008-INIT-MUTATION-COVERAGE-SEAM`). Phase F7 delta-convergence then reached all
5 convergence dimensions PASS with a CONSISTENT audit
(`.factory/cycles/cycle-008/phase-f7-convergence/delta-convergence-report.md`). The human F7 gate
**APPROVED** the close on that basis. **This ADR's `status:` field is flipped from `proposed` to
`accepted` in this same burst** (DEC-371). cycle-008 (`oauth-surface-correctness`) is **CLOSED** —
shipped on `develop @ 0834c9f0`, **NO immediate release cut** (`CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE`,
the Atlassian Developer Console scope registration, remains the sole open human-owned pre-release
blocker; this cycle's content rolls into a later dev release once that step completes, same
deferred-release pattern as cycle-005/cycle-012's F7 close). `activation_head`/`activation_version`
stay unchanged at `aa557050`/`v0.7.0-dev.7`.

## Alternatives Considered

- **Option: unify all `instance_url`/`base_url` call sites into a single auto-selecting helper
  keyed off `is_oauth_auth()`.** Rejected/deferred: the existing `get`/`get_from_instance` split
  already encodes the correct routing rule for every platform call site; the defect is that seven
  call sites invoked the wrong one of two already-correct methods, not that the two-method
  abstraction is wrong. Introducing a new auto-selecting helper would touch far more call sites
  than the bug requires and would not by itself have prevented this class of defect (a
  correctly-designed but incorrectly-invoked API is a call-site bug, not an API-design bug).
- **Option: widen `JrError::InsufficientScope`'s Display template to be method/host/scope-aware
  for every caller.** Rejected in favor of the call-site-rewrite pattern already established by
  `require_service_desk`, specifically to avoid having to re-verify correctness for the one
  existing caller (`jsm_create.rs`) that is already correct against the current unconditional
  template (BC-3.8.015). A single shared template trying to serve every caller's context is the
  root cause of the misleading-message defect this ADR fixes for Agile commands; repeating that
  pattern more broadly would reproduce the same defect class elsewhere.
- **Option: bundle Teams (Workstream D) into this cycle to close the OAuth surface completely in
  one pass.** Rejected per F1's own recommendation (§6a): Workstream D's exact scope-string set
  is UNCERTAIN pending live Developer Console verification, it surfaces two new open questions
  (`get_org_metadata`/`jr init` exposure, API-token host preservation) that cannot be resolved
  from static code + docs research alone, and it is architecturally distinct (host re-platform)
  from the other three workstreams (mechanical routing/scope fixes). Bundling risks delaying
  three low-risk, high-confidence fixes behind one high-uncertainty one.
- **Option: ship a minimal/Agile-only scope expansion at the F2 gate and defer the component-write
  gap (`manage:jira-project`) to a later cycle.** Rejected at the F2 human gate in favor of
  full parity: the F2 deep audit found the component-write gap to be an equally real,
  already-shipped-and-broken OAuth defect — not a new feature request — discovered adjacent to
  the same investigation that resolved the bulk-API NEEDS-RESEARCH question (see Consequences,
  "Confirmed findings"). Deferring it would let a cycle explicitly framed as "OAuth surface
  correctness" ship with a known, precisely-characterized gap in the component-management command
  family. Both scope additions travel in the same `DEFAULT_OAUTH_SCOPES` edit and the same
  Console-update/re-consent release gate (Decision 2a), so bundling them added no meaningful
  incremental risk beyond what the Agile-only change already required.

## Source / Origin

- `.factory/cycles/cycle-008/F1-delta-analysis.md` §1 (Root Cause Confirmation), §2.1–§2.5
  (Impact Boundary Per Workstream), §6 (Open Decisions, DEC-368 gate) — code-audited, not
  brief-derived; every symbol cited in Decision 1's table is sourced from this document's §2.1
  and §2.3 tables.
- `.factory/cycles/cycle-008/research-oauth-endpoints.md` Q1–Q5 — Perplexity `sonar-deep-research`
  + one direct WebFetch verification of `developer.atlassian.com`'s Teams GraphQL intro page;
  source for the granular Jira-Software scope set (Q3) and the Teams host-split finding (Q4).
- `.factory/cycles/cycle-008/oauth-scope-matrix.md` — F2 deep audit finalizing
  `DEFAULT_OAUTH_SCOPES`; authoritative source for the finalized 16-scope full-parity set
  (Decision 2), the component-write `manage:jira-project` gap discovery (Decision 2a), the
  bulk-API no-gap confirmation, and the classic/granular coexistence confirmation (both recorded
  under Consequences, "Confirmed findings").
- `.factory/cycles/cycle-008/oauth-endpoint-inventory.md` — 82-endpoint code-grounded inventory
  underlying the F2 audit; source for endpoint rows #41/#42/#44 (component writes) and #20-22
  (bulk API).
- `docs/adr/0009-handle-open-instance-url.md` — the inverse-direction ADR this decision mirrors
  (`instance_url` reserved for browser URLs; this ADR closes the matching gap for API calls).
- `docs/adr/0006-embedded-jr-oauth-app.md` — origin of `DEFAULT_OAUTH_SCOPES` and the embedded
  OAuth app / Developer Console coordination procedure this ADR's Decision 2 extends.
- `docs/adr/0013-pkce-deferral.md` — sibling OAuth-3LO-flow ADR; cross-referenced for
  completeness. This ADR does not touch the authorization-code/PKCE flow itself, only scopes and
  request routing, so ADR-0013's reactivation-trigger reasoning is unaffected.
- Code as-built: `src/api/client.rs` (`get`/`post`/`get_from_instance`/`post_to_instance`,
  `new_for_test`/`new_for_test_with_instance_url`), `src/api/jsm/servicedesks.rs`
  (`list_service_desks`, `require_service_desk`), `src/api/jsm/request_types.rs`,
  `src/api/jsm/queues.rs`, `src/api/jsm/requests.rs`, `src/api/jsm/attachments.rs`,
  `src/api/assets/workspace.rs`, `src/api/assets/objects.rs`, `src/api/auth.rs`
  (`DEFAULT_OAUTH_SCOPES`), `src/cli/auth/login.rs::resolve_oauth_scopes`, `src/error.rs`
  (`JrError::InsufficientScope`), `src/cli/board.rs`, `src/cli/sprint.rs`,
  `src/api/jira/sprints.rs`, `src/api/jira/teams.rs`, `src/cli/issue/jsm_create.rs`.

## Related ADRs

- **ADR-0009** (`docs/adr/0009-handle-open-instance-url.md`) — inverse case. ADR-0009: browser
  URLs must use `instance_url`, never `base_url`. ADR-0026 (this ADR): API calls must use
  `base_url`, never `instance_url`. Read together, they fully specify the legitimate use of both
  host variables.
- **ADR-0006** (`docs/adr/0006-embedded-jr-oauth-app.md`) — origin of `DEFAULT_OAUTH_SCOPES` and
  the embedded-app/Developer-Console coordination procedure. ADR-0026 extends the scope set
  defined there; it does not change the embedded-app credential model itself.
- **ADR-0013** (`docs/adr/0013-pkce-deferral.md`) — sibling OAuth 3LO decision. ADR-0026 does not
  affect the authorization-code/PKCE flow; both ADRs concern the same OAuth 3LO surface but at
  different layers (flow vs. scopes/routing).

> **Bidirectional backlink note:** the forward-reference backlinks from
> `docs/adr/0009-handle-open-instance-url.md`, `docs/adr/0006-embedded-jr-oauth-app.md`, and
> `docs/adr/0013-pkce-deferral.md` to this ADR **WERE APPLIED via PR #833 (S1, commit `4afc5aa5`),
> fulfilling S1's AC-009 — no longer deferred.** `docs/adr/` is the pre-VSDD-factory ADR track
> (ADR-0001–0016) and lives in the product repo's `develop` tree, not under `.factory/`; it was out
> of scope for the `.factory`-only F2 spec-evolution burst and could only be edited through the
> normal PR flow against `develop` — which is exactly the path S1/PR #833 took when it landed. All
> three files now carry a short forward-reference note in their own "Related ADRs" section pointing
> at ADR-0026. The `.factory`-side cross-references in this ADR's own "Related ADRs" section above,
> and in ARCH-INDEX.md, remain real and in place — both directions are now applied. (Corrected
> 2026-09-18, F7 pre-gate consistency reconcile; this note previously said the backlinks were
> deferred/reverted, which was stale.)
