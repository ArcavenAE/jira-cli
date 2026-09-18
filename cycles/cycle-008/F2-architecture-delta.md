---
document_type: phase-f2-architecture-delta
cycle: cycle-008
title: "OAuth surface correctness — F2 architecture delta summary"
adr: ADR-0026
inputs:
  - .factory/cycles/cycle-008/F1-delta-analysis.md
  - .factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md
  - .factory/cycles/cycle-008/verification-delta.md
date: 2026-09-17
status: awaiting-f2-gate
input-hash: "ade2012"
---

# Cycle-008 F2 Architecture Delta — Reference Note

Single-page reference for the product-owner (BC delta) and story-writer (F3), summarizing the
architecture-side decisions made this phase and exactly which files/functions each approved
workstream touches. Scope is locked at DEC-368 (F1 gate): **deliver S1/S2/S3/S4/S5. S6 = spike
only. S7 deferred.** No `src/` changes were made in this pass — architecture/spec artifacts only.

## New artifacts this phase

| Artifact | Path |
|---|---|
| ADR-0026 | `.factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md` |
| ARCH-INDEX row | `.factory/specs/architecture/ARCH-INDEX.md` (ADR-0026 row appended after ADR-0025) |
| Verification delta | `.factory/cycles/cycle-008/verification-delta.md` (VP-OAUTH-GW-001/002/003) |
| Backlink notes (pre-existing ADRs) | **DEFERRED to the cycle-008 F4 implementation PR, not yet applied.** `docs/adr/0009-handle-open-instance-url.md`, `docs/adr/0006-embedded-jr-oauth-app.md`, `docs/adr/0013-pkce-deferral.md` do NOT yet carry a backlink to ADR-0026 — an earlier working-tree edit adding these three backlinks directly was reverted, since `docs/adr/` lives in the product repo's `develop` tree and is out of scope for a `.factory`-only spec-evolution burst; it can only be edited through the normal PR flow. See ADR-0026's own "Bidirectional backlink note" for the full rationale. |

## Workstream → files/functions → VP → BC-delta owner map

### S1 — `jsm-servicedeskapi-oauth-routing` (Workstream A)

| File | Function | Change | VP |
|---|---|---|---|
| `src/api/jsm/servicedesks.rs` | `list_service_desks` | `get_from_instance` → `get` | VP-OAUTH-GW-001 |
| `src/api/jsm/request_types.rs` | `list_request_types` | `get_from_instance` → `get` | VP-OAUTH-GW-001 |
| `src/api/jsm/request_types.rs` | `get_request_type_fields` | `get_from_instance` → `get` | VP-OAUTH-GW-001 |
| `src/api/jsm/queues.rs` | `list_queues` | `get_from_instance` → `get` | VP-OAUTH-GW-001 |
| `src/api/jsm/queues.rs` | `get_queue_issue_keys` | `get_from_instance` → `get` | VP-OAUTH-GW-001 |
| `src/api/jsm/requests.rs` | `create_jsm_request` | `post_to_instance` → `post` | VP-OAUTH-GW-001 |

No payload/body changes. Command surface: `jr requesttype list/fields`, `jr queue list/view`,
`jr issue create --request-type`. BC-delta owner: product-owner confirms BC-X.8.004-010 /
BC-X.12.001-008 (`cross-cutting.md`) need NO shape change (payload/caching contracts
unaffected, per F1 §3) — verify via regression test only, do not edit those BC bodies unless a
routing cross-reference note is judged useful.

### S2 — `agile-oauth-scope-gap` (Workstream B)

| File | Change | VP |
|---|---|---|
| `src/api/auth.rs` (`DEFAULT_OAUTH_SCOPES`) | Add all 8 new scopes: the 7 granular jira-software Agile scopes PLUS the classic `manage:jira-project` scope (see ADR-0026 Decision 2 + Decision 2a) | VP-OAUTH-GW-002 |
| `src/cli/auth/tests/mod.rs` (`default_oauth_scopes_pins_the_full_set_with_offline_access`) | Update pinned string in same commit | VP-OAUTH-GW-002 |
| `CHANGELOG.md` (`[Unreleased]`) | Add re-consent note | — |

**BC-delta owner: product-owner MUST amend `BC-1.3.023`** (`bc-1-auth-identity.md`) — update the
pinned `DEFAULT_OAUTH_SCOPES` literal string in the Behavior section. No other BC in this file
changes shape.

**Release gate (non-code, human/app-owner action):** Atlassian Developer Console app-permission
update MUST land before this ships, or OAuth login/refresh hard-fails `invalid_scope` for ALL
users. The Console update must add **all 8 new scopes in one pass** — do not ship only the Agile
subset:
- 7 granular jira-software Agile scopes: `read:board-scope:jira-software`,
  `read:board-scope.admin:jira-software`, `read:sprint:jira-software`,
  `write:board-scope:jira-software`, `read:project:jira`, `read:issue-details:jira`,
  `read:jql:jira`.
- PLUS the classic `manage:jira-project` scope (ADR-0026 Decision 2a) — required separately for
  `jr component create/edit/delete/rename`; omitting it leaves component-write commands
  unauthorized under OAuth even though the Agile scope-mismatch (S4) is otherwise fixed.

This is the standing release-gate item `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE`. Flag explicitly at
the F2/F6 human gates as a release-blocking checklist item, not a follow-up task. See ADR-0026
Decision 2 + 2a and its Consequences section for the authoritative "all eight" scope list; CHANGELOG
`[Unreleased]`'s release-gate note also enumerates all 8.

### S3 — `assets-workspace-oauth-routing` (Workstream C)

| File | Function | Change | VP |
|---|---|---|---|
| `src/api/assets/workspace.rs` | `get_or_fetch_workspace_id` | `get_from_instance` → `get` | VP-OAUTH-GW-001 |

No change to `src/api/assets/objects.rs`, `linked.rs`, `schemas.rs`, `tickets.rs` (already
gateway-correct). **BC-delta owner: product-owner AMENDS `BC-4.2.001`** (`bc-4-assets-cmdb.md`)
to add the base-URL/gateway clause. `BC-4.2.002`–`BC-4.2.005` are NO CHANGE.

### S4 — `agile-scope-mismatch-error-mapping` (Workstream E)

| File | Change | VP |
|---|---|---|
| `src/cli/board.rs` | New call-site rewrite (auth-scheme-conditional, modeled on `require_service_desk`) | VP-OAUTH-GW-003 |
| `src/cli/sprint.rs` | New call-site rewrite (same pattern) | VP-OAUTH-GW-003 |

`src/error.rs` and its two construction sites in `src/api/client.rs` (`send_inner`,
`parse_error`) are **NOT modified** — the shared `InsufficientScope` Display template stays
exactly as pinned by BC-1.6.042. **BC-delta owner: product-owner adds a NEW BC** under
`bc-5-boards-sprints.md` or `cross-cutting.md`, modeled on the BC-X.8.006/BC-X.8.007 template
(the existing `require_service_desk` BCs), plus a cross-reference note on `BC-5.1.001`
(routing is correct there; the 401 it currently exhibits under OAuth is a scope problem, fixed
by S2, not a routing problem). Recommended sequencing: land AFTER S2 (needs the real
Agile-scope-mismatch case to exist/be testable against, though it can be built against a mocked
401 independently).

### S5 — `jsm-attachments-oauth-verification` (Workstream A dependency, no code change)

No file changes. Hard dependency on S1 (the `serviceDeskId` resolution chain
`resolve_service_desk_id` → `get_or_fetch_project_meta` → `list_service_desks` must be fixed
first). Verification-only: add a regression test proving `src/api/jsm/attachments.rs`'s two-step
JSM upload flow succeeds end-to-end once S1 lands. No new VP — covered transitively by
VP-OAUTH-GW-001's fix to `list_service_desks`.

### S6 (SPIKE, non-delivery) — `teams-graphql-oauth-replatform-spike` (Workstream D)

No file changes this cycle. ADR-0026 §Deferred/Context records the open questions the spike must
resolve: Teams host model (new `api.atlassian.com/graphql` host vs. auth-scheme fork),
`get_org_metadata`/`jr init` exposure, API-token host preservation, and the exact
`view:team:teams`/`view:membership:teams` scope strings (UNCERTAIN per research). **No BC/VP
delta for S6 in this pass** — BC-X.6.002/003/004 remain untouched until Workstream D's scope is
separately approved (do not let a future pass touch these without re-reading ADR-0026's
Deferred/Context section first).

### S7 (conditional, deferred) — `teams-graphql-oauth-replatform`

Not started. Depends on S6's findings. No architecture artifact exists for this yet.

## Files confirmed NOT touched (regression baseline, unchanged from F1 §8)

Reproduced here for convenience — do not let any story in this cycle touch these:
`src/api/jira/issues.rs`, `users.rs`, `projects.rs`, `boards.rs`, `statuses.rs`, `resolutions.rs`,
`links.rs`, `worklogs.rs`, `fields.rs`, `bulk.rs`, `attachments.rs` (platform, distinct from
`src/api/jsm/attachments.rs`), `components.rs`, `tenant.rs`, `sprints.rs` itself (only the OAuth
scope it needs changes, in `auth.rs`); `src/api/assets/objects.rs`, `linked.rs`, `schemas.rs`,
`tickets.rs`; `src/api/jsm/attachments.rs` (no code change, verification only per S5);
`src/api/client.rs`'s `get`/`post`/`get_from_instance`/`post_to_instance`/`get_assets`/
`post_assets`/`send_inner`/`parse_error` *definitions* (S4 adds new call sites elsewhere, does
not modify these); `src/cli/auth/login.rs` (`resolve_oauth_scopes`, `build_authorize_url` call
site — already correct); `src/error.rs` (type/Display definitions unchanged); everything in
`src/cli/issue/` (JSM-create's existing rewrite in `jsm_create.rs` is untouched);
`src/config.rs`, `src/cache.rs`, `src/profile.rs`, `src/adf.rs`, `src/duration.rs`,
`src/output.rs`, `src/jql.rs`, `src/partial_match.rs`.

## Open items for the human at the F2 gate

1. **Confirm DEC-368 scope is still correct** — this architecture pass did not change the F1
   gate's scope decision (S1-S5 deliver, S6 spike, S7 deferred); it only designed the delta
   within that already-approved boundary.
2. **Developer Console release-gate acknowledgment** — recommend the human explicitly
   acknowledge (not just note) that the Console app-permission update is a hard pre-release
   blocker for S2, given F1's own risk assessment rates this the single highest operational risk
   in the cycle.
3. **BC-home choice for S4's new BC** — ADR-0026/verification-delta leave open whether the new
   Agile-401 BC lives in `bc-5-boards-sprints.md` or `cross-cutting.md`; product-owner should
   decide during the BC delta pass (F1 suggested either is acceptable, mirroring the
   BC-X.8.006/007 precedent either way).
4. **No decision needed on Teams (S6/S7) at this gate** — ADR-0026 deliberately leaves this
   fully open; the spike itself is the next action, not a design decision.
