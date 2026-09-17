---
document_type: verification-delta
cycle: cycle-008
title: "OAuth surface correctness — Verification Property delta"
adr: ADR-0026
inputs:
  - .factory/cycles/cycle-008/F1-delta-analysis.md
  - .factory/cycles/cycle-008/research-oauth-endpoints.md
  - .factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md
date: 2026-09-17
status: awaiting-f2-gate
input-hash: "bd88f47"
---

# Cycle-008 Verification-Property Delta

## Registration convention (repo-specific — read before registering)

This codebase has **no separate `verification-properties/` corpus or `VP-INDEX.md`**
(confirmed absent by both this pass and the F1 delta analysis §3). Verification Properties in
`jr` are inline `VP-<slug>-NNN` labels embedded directly in two places:

1. A BC body's `Trace`/`Source`/dedicated VP-reference line in `.factory/specs/prd/bc-*.md`
   (e.g. `VP-AUTHDX-017`, `VP-FIELD-ADF-004`, `VP-576-005`).
2. The corresponding test's doc-comment / name, cross-referencing the BC and VP id (e.g. a test
   named `test_bc_x_y_z_...` with a `/// VP-<slug>-NNN` doc-comment above it).

There is **no central index file to update**. Each VP below is written as an inline-label
candidate: the product-owner (F2 BC-delta pass) attaches it to the BC it traces to, and
the test-writer (F4) creates the pinning test carrying the matching doc-comment. This document
is the single authoring point; nothing here needs propagation to a `VP-INDEX.md` because none
exists in this repo — do not create one (would diverge from the established convention).

Slug chosen: `OAUTH-GW` (OAuth Gateway), following the existing `AUTHDX`/`FIELD-ADF`/bare-numeric
slug conventions already in use for auth- and field-resolution-related VPs.

---

## VP-OAUTH-GW-001 — OAuth-gateway routing invariant (JSM + Assets discovery target `base_url`)

**Statement:** For every one of the 7 call sites listed in ADR-0026 Decision 1, the HTTP request
built under an OAuth (3LO) `JiraClient` targets `base_url`
(`https://api.atlassian.com/ex/jira/{cloudId}/...`), never `instance_url`
(`https://{site}.atlassian.net/...`).

**Target modules/functions:**
- `src/api/jsm/servicedesks.rs::list_service_desks`
- `src/api/jsm/request_types.rs::list_request_types`
- `src/api/jsm/request_types.rs::get_request_type_fields`
- `src/api/jsm/queues.rs::list_queues`
- `src/api/jsm/queues.rs::get_queue_issue_keys`
- `src/api/jsm/requests.rs::create_jsm_request`
- `src/api/assets/workspace.rs::get_or_fetch_workspace_id`

**Proof/test strategy:** Integration test, not formal proof (this is an effectful-shell HTTP
client concern, not pure-core logic). Construct the client via the EXISTING seam
`JiraClient::new_for_test_with_instance_url(base_url, instance_url, auth_header)`
(`src/api/client.rs`) with `base_url != instance_url` (e.g. `base_url =
"https://gateway.example/ex/jira/CLOUD"`, `instance_url = "https://site.example"`), point a
wiremock server at `base_url` only, and assert the mocked gateway endpoint receives the request
(a mock at `instance_url` receiving anything is a hard test failure). One test case per call
site — 7 new/adapted test cases total. This is the primitive the F1 delta analysis explicitly
identifies (§5) as already existing and sufficient; no new test infrastructure is required.

**Negative-control requirement:** Each test must also assert the OLD behavior would have failed
under this construction (i.e., run the test against pre-fix code once, expect it to hit
`instance_url` and fail) — or, more practically, keep one always-on assertion that the
`instance_url` mock received zero requests, so a future accidental revert to
`get_from_instance`/`post_to_instance` at any of these 7 sites re-fails the test immediately.

**Feasibility:** HIGH — mechanical, uses an existing seam, no new abstractions needed.

**Registers into:**
- `BC-4.2.001` (`bc-4-assets-cmdb.md`) — for the `get_or_fetch_workspace_id` case specifically
  (this BC is already flagged AMEND in F1 §3 to add the base-URL clause).
- A new or amended BC under `cross-cutting.md` (BC-X.8.xxx family, JSM servicedesk/queue/
  requesttype/create routing) for the 6 JSM call sites — product-owner to determine exact BC
  home; F1 §3 confirms BC-X.8.004-010 and BC-X.12.001-008 need NO shape change (payload/caching
  contracts unaffected) but may need a routing-clause cross-reference note, similar to
  BC-5.1.001's treatment below.

---

## VP-OAUTH-GW-002 — `DEFAULT_OAUTH_SCOPES` contains the required Agile granular-scope set

**Statement:** `DEFAULT_OAUTH_SCOPES` (`src/api/auth.rs`) contains, as substrings, all of:
`read:board-scope:jira-software`, `read:project:jira`, `read:sprint:jira-software`,
`read:issue-details:jira`, `read:jql:jira`, `read:board-scope.admin:jira-software`,
`write:board-scope:jira-software` — in addition to every classic scope already present
(`offline_access`, `read:jira-user`, `read:jira-work`, `write:jira-work`,
`read:servicedesk-request`, `write:servicedesk-request`, `read:cmdb-object:jira`,
`read:cmdb-schema:jira`). Explicitly does NOT contain `view:team:teams` or
`view:membership:teams` (Teams scopes are out of scope this cycle — a companion negative
assertion, not just an omission).

**Target module:** `src/api/auth.rs` (`DEFAULT_OAUTH_SCOPES` constant).

**Proof/test strategy:** Pure pinning test (string-substring assertions) — this is the simplest
class of VP in this delta, pure-core (a `const &str`, no I/O). Update the EXISTING test
`default_oauth_scopes_pins_the_full_set_with_offline_access`
(`src/cli/auth/tests/mod.rs`) in place rather than adding a parallel test — per CLAUDE.md's own
`DEFAULT_OAUTH_SCOPES` procedure and BC-1.3.023's Maintainer Coordination clause, this update
MUST land in the same commit as the constant edit. Add explicit `assert!(!scopes.contains(...))`
negative assertions for `view:team:teams` / `view:membership:teams` so a future accidental
Workstream-D-scope leak into this constant (before Workstream D is actually approved) is caught.

**Feasibility:** TRIVIAL — string containment checks on a compile-time constant.

**Registers into:** `BC-1.3.023` (`bc-1-auth-identity.md`) — already flagged AMEND in F1 §3 to
update the pinned scope-string literal in the Behavior section. This VP is the pinning-test half
of that BC amendment.

---

## VP-OAUTH-GW-003 — Agile-command 401 error-mapping distinguishes the three 401 classes

**Statement:** For a 401 response received by `jr board` / `jr sprint` handlers, the emitted
`JrError` variant and user-facing message differ correctly across three input classes:
(i) a scope-mismatch 401 under OAuth → `InsufficientScope`-derived message naming the missing
granular Jira-Software scope(s), NOT the generic POST-framed template; (ii) a 401 with an
Atlassian expired/invalid-token body shape → routes to the existing auto-refresh path
(`src/api/refresh_coordinator.rs`) and does not surface `InsufficientScope` at all; (iii) (regression
guard only, not new behavior) a 401 caused by wrong-host routing (pre-ADR-0026 defect class) no
longer occurs post-fix for the 7 corrected call sites — this sub-case is covered by
VP-OAUTH-GW-001, not re-tested here.

**Target modules/functions:** New call-site rewrite in `src/cli/board.rs` and
`src/cli/sprint.rs` (function names not yet assigned — implementer's choice at F4, modeled on
`src/api/jsm/servicedesks.rs::require_service_desk`'s auth-scheme-conditional rewrite pattern).

**Proof/test strategy:** Integration test with a mocked 401 response body (wiremock), asserting
on the rendered error message / exit code for each of classes (i) and (ii) above, for both
`jr board list` and `jr sprint list` (minimum 4 new test cases: 2 commands × 2 classes). Must
also include a REGRESSION assertion that the existing `jsm_create.rs` call site's message is
UNCHANGED (byte-for-byte) — this VP's rewrite is additive only and must not alter the one call
site (BC-3.8.015) already proven correct against the generic template.

**Feasibility:** MEDIUM — requires care to scope the rewrite narrowly (Agile call sites only,
per F1 §2.5's explicit warning against "the same 'shared template used somewhere it doesn't fit'
mistake this defect already represents once"). Auth-scheme-conditional branching
(`is_oauth_auth()`) is an established pattern in this codebase (used by `require_service_desk`),
so the implementation technique itself is low-risk; the main risk is over-broadening scope.

**Registers into:** A NEW BC, per F1 §3's explicit recommendation: add under
`bc-5-boards-sprints.md` or `cross-cutting.md`, modeled on the BC-X.8.006/BC-X.8.007 template
(the `require_service_desk` BCs). Do NOT touch BC-1.6.042/043/044/045 (generic
`InsufficientScope` construction rule — orthogonal, unchanged) or BC-3.8.015 (JSM-create POST
path — must remain byte-for-byte correct, covered by this VP's regression assertion). Also add a
cross-reference note to `BC-5.1.001` (`bc-5-boards-sprints.md`) per F1 §3, since that BC's
existing routing-correct GET currently 401s under OAuth for SCOPE reasons (fixed by
VP-OAUTH-GW-002), not routing reasons — a reader debugging via BC-5.1.001 alone would otherwise
wrongly suspect a routing bug.

---

## Summary table

| VP ID | Statement (short) | Target | Registers into | Feasibility |
|---|---|---|---|---|
| VP-OAUTH-GW-001 | 7 call sites target `base_url` under OAuth, never `instance_url` | `src/api/jsm/*.rs` (6 sites), `src/api/assets/workspace.rs` (1 site) | BC-4.2.001 (amend); new/amended JSM routing BC under `cross-cutting.md` | HIGH |
| VP-OAUTH-GW-002 | `DEFAULT_OAUTH_SCOPES` contains the 7 required granular Agile scopes, excludes Teams scopes | `src/api/auth.rs` | BC-1.3.023 (amend) | TRIVIAL |
| VP-OAUTH-GW-003 | Agile 401s disambiguate scope-mismatch vs. expired-token vs. (regression) wrong-host | `src/cli/board.rs`, `src/cli/sprint.rs` (new rewrite) | NEW BC under `bc-5-boards-sprints.md`/`cross-cutting.md`; cross-ref note on BC-5.1.001; regression guard on BC-3.8.015 | MEDIUM |

## Explicitly out of scope for this VP delta

No VP is defined for Workstream D (Teams). Per ADR-0026 §Deferred/Context, Workstream D is a
spike (S6) this cycle, not a delivery story — a VP naming specific Teams-related modules/scopes
would be premature and would need to be re-derived once the S6 spike resolves the open questions
in ADR-0026 (host model, `get_org_metadata` scope, API-token host preservation).
