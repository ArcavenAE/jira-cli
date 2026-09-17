---
document_type: story
level: ops
story_id: "S-cycle8-agile-scope-mismatch-error-mapping"
epic_id: "OAUTH-SURFACE-CORRECTNESS-1"
title: "jr board/jr sprint 401 call-site rewrite: disambiguate scope-mismatch vs expired-token vs wrong-host"
wave: 1
status: draft
intent: bug-fix
feature_type: correctness
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
producer: story-writer
timestamp: "2026-09-17T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-008/F1-delta-analysis.md"
  - ".factory/cycles/cycle-008/F2-architecture-delta.md"
  - ".factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md"
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/prd/bc-5-boards-sprints.md"
  - "src/cli/board.rs"
  - "src/cli/sprint.rs"
  - "src/api/jsm/servicedesks.rs"
  - "src/error.rs"
input-hash: "c333e12"
traces_to: "ADR-0026 Decision 3; BC-X.15.001"
cycle: cycle-008-oauth-surface-correctness
estimated_effort: medium
estimated_days: 2.5
target_module: "src/cli/board.rs, src/cli/sprint.rs"
subsystems: ["SS-02"]
# SS-02 (CLI Layer, src/cli/) owns this story's entire scope -- both files
# this story edits (board.rs, sprint.rs) are command handlers under
# src/cli/, and the new call-site rewrite is additive CLI-layer logic that
# consumes (but does not modify) the shared error type in src/error.rs
# (SS-08) and the reference pattern in src/api/jsm/servicedesks.rs (SS-05) --
# neither of those files is edited by this story, so neither subsystem is
# listed as an owner, only as a read-only reference per the Architecture
# Compliance Rules below.
depends_on: []
blocks: []
# No cycle-008 story hard-depends on this one, and this story does not
# hard-depend on any other cycle-008 story either. F1 delta-analysis.md's
# story-decomposition preview (§7) recommends sequencing this AFTER
# S-cycle8-agile-oauth-scope-gap ("needs the real Agile-scope-mismatch case
# to exist/be testable against") -- this is captured as a sequencing note in
# the Previous Story Intelligence section below, not a depends_on edge,
# because this story's own tests construct the 401 body directly via
# wiremock (mocking the exact "scope does not match" substring) rather than
# needing the real DEFAULT_OAUTH_SCOPES constant to have changed first.
behavioral_contracts:
  - BC-X.15.001
bcs:
  - BC-X.15.001
verification_properties:
  - VP-OAUTH-GW-003
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0026"]
sd_refs: []
priority: P1
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-008/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: MEDIUM
points: 8
acceptance_criteria_count: 12
assumption_validations: []
risk_mitigations: []
created: "2026-09-17"
version: "1.2"
last_updated: "2026-09-17"
breaking_change: false
retroactive: false
origin: >
  cycle-008 oauth-surface-correctness, Wave 1, no deps, no blocks. F1
  delta-analysis (.factory/cycles/cycle-008/F1-delta-analysis.md §2.5)
  located the root cause precisely: JrError::InsufficientScope's Display
  template is a single, unconditional, POST-framed message, correct for its
  one proven call site (jsm_create.rs) but misleading when it leaks through
  for an Agile GET scope-mismatch, because jr board/jr sprint have zero
  scope-handling code today (confirmed by grep). ADR-0026 Decision 3
  establishes the general architectural pattern: 401 ambiguity is always
  resolved by a call-site rewrite close to the failing operation, never by
  widening the shared Display template -- this story adds that rewrite,
  modeled on the proven require_service_desk pattern
  (src/api/jsm/servicedesks.rs), for two command families' full internal
  call graphs (not just their top-level handlers). BC-X.15.001 (new,
  cross-cutting.md) authored at F2 to govern this story's ACs.
  UPDATED 2026-09-17 (v1.1, same-day F1 human-approved scope expansion):
  EXPANDED to cover every Agile HTTP call reachable within a jr board/jr
  sprint invocation, not only the 4 originally-named handlers -- adds
  AC-009..AC-012 for board.rs::resolve_board_id, board.rs::handle_view's
  unconditional get_board_config call, handle_view's scrum-branch
  list_sprints/get_sprint_issues calls, sprint.rs::resolve_scrum_board, and
  SprintCommand::Add{current}'s list_sprints lookup, all reusing the same
  shared rewrite_agile_scope_error helper. Also fixes a stale "jr board view
  --config" label (no such flag exists) to "jr board view" throughout, and
  records the F4 ruling to KEEP the grouped jr sprint list/current hint as
  spec-conformant (EC-X.15.001-4). BC-X.15.001's id and the corpus's total
  BC count are unchanged -- this is a coverage clarification, not a new BC.
---

> **tdd_mode:** `strict` — this story introduces new, non-trivial branching
> logic (a 3-way 401 classification: scope-mismatch / expired-token /
> wrong-host-regression-guard) that must be scaffolded with `todo!()` bodies
> and proven RED before GREEN. `module_criticality: MEDIUM` — the blast
> radius is two CLI command handlers, additive at the 401 branch only, with
> no effect on successful-response handling or on the shared
> `InsufficientScope` Display template other callers depend on.

> **Execute:** `/vsdd-factory:deliver-story S-cycle8-agile-scope-mismatch-error-mapping`

# S-cycle8-agile-scope-mismatch-error-mapping — jr board/jr sprint 401 disambiguation

## Narrative

- **As a** `jr board`/`jr sprint` user authenticated via OAuth (3LO) whose token lacks a required
  granular Jira-Software scope
- **I want to** see an actionable message naming the missing scope and directing me to
  `jr auth login` to re-consent, instead of a generic, POST-framed `InsufficientScope` message
  that references an irrelevant issue-#185 POST scenario
- **So that** I can self-diagnose and fix an OAuth scope-mismatch without filing a support ticket
  or misreading the error as a routing bug

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-X.15.001 | PRIMARY (new; Behavior clause 1 coverage CLARIFIED/WIDENED at F1, 2026-09-17 — same BC id, no new contract) | All 4 Behavior clauses (scope-mismatch rewrite — now spanning all 8 call sites listed in clause 1's mapping, not only the 4 originally-named top-level handlers — expired-token fall-through, wrong-host regression-guard boundary, Basic-auth short-circuit) and its 4 documented Edge Cases (EC-X.15.001-1..4) |
| BC-5.1.001 | CROSS-REFERENCE (unchanged) | The cross-reference note added at F2 pointing readers debugging `jr board list`'s 401 at BC-X.15.001 and BC-1.3.023 rather than suspecting a routing bug |

**Anchor justification:** BC-X.15.001 is a NEW BC authored specifically for this workstream at the
cycle-008 F2 spec-evolution pass (`cross-cutting.md` §X.15, definitional_count 93→94), modeled on
the BC-X.8.006/BC-X.8.007 template for `require_service_desk`. This story is that BC's sole
implementation vehicle — no other story in this cycle touches `src/cli/board.rs`/`src/cli/sprint.rs`.
Its scope was clarified/widened by an F1 human ruling on 2026-09-17 (same BC id, same total BC
count — a call-site coverage widening, not a new contract) to explicitly cover 4 additional
internal board/sprint resolution call sites (AC-009..AC-012) alongside the originally-named 4
top-level command handlers (AC-001).

## Acceptance Criteria

### AC-001 (traces to BC-X.15.001 Behavior clause 1 — genuine scope-mismatch rewrite)
For a `jr board`/`jr sprint` command handler receiving a 401 whose body carries the case-insensitive
`"scope does not match"` substring (the same detection rule BC-X.3.005/BC-1.6.044 already use)
while the active auth scheme is OAuth (`client.is_oauth_auth() == true`), the call site rewrites the
error to `JrError::NotAuthenticated { hint }` — NOT `InsufficientScope` — with a hint naming the
missing granular scope(s) for the specific failing command:
- `jr board list` → `read:board-scope:jira-software` + `read:project:jira`
- `jr board view` (its unconditional `get_board_config` call — there is no `--config` flag; this
  call fires for every `jr board view` invocation regardless of board type) →
  `read:board-scope.admin:jira-software`
- `jr sprint list`/`jr sprint current` → `read:sprint:jira-software` + `read:issue-details:jira` +
  `read:jql:jira`
- `jr sprint add`/`jr sprint remove` → `write:board-scope:jira-software`

> **F3 correction (2026-09-17):** an earlier draft of this AC and of BC-X.15.001 referred to a
> nonexistent `jr board view --config` flag. `jr board view` takes no `--config` flag — `handle_view`
> (`src/cli/board.rs`) calls `client.get_board_config(board_id)` unconditionally, on every
> invocation, before branching on board type. The label is corrected to plain `jr board view`
> throughout this story and in BC-X.15.001.

The hint also directs the user to `jr auth login` to re-consent (mirroring BC-X.8.007's
"`jr auth refresh` alone cannot add missing scopes" framing).
**Test:** one wiremock test per command family listed above (4 tests minimum), each mounting a 401
response with a `"scope does not match"` body under an OAuth-constructed client
(`JiraClient::new_for_test` with an OAuth-shaped auth header/`is_oauth_auth()` returning true —
confirm the exact test-construction primitive for `is_oauth_auth()` during Task 1), asserting the
stderr hint names the exact scope string(s) listed above and directs to `jr auth login`.

### AC-002 (traces to BC-X.15.001 Behavior clause 2 — expired-token fall-through, regression guard)
A 401 whose body carries Atlassian's generic expired/invalid-token shape (no scope-mismatch
substring) is left UNCHANGED to fall through to the existing auto-refresh coordinator
(`src/api/refresh_coordinator.rs`) exactly as it does today for every other OAuth-authenticated
command family. This story's rewrite MUST NOT intercept this class.
**Test:** `test_bc_x_15_001_board_401_without_scope_substring_falls_through_to_refresh` (and a
`sprint` sibling) — mounts a 401 body WITHOUT the scope-mismatch substring, asserts the existing
refresh-coordinator retry path is exercised (or, if full refresh-flow mocking is out of scope for
this unit-level test, asserts at minimum that the new call-site rewrite does NOT fire — i.e. the
error surfacing this test observes is NOT the new `NotAuthenticated{hint}` variant with a
granular-scope hint).

### AC-003 (traces to BC-X.15.001 Behavior clause 3 — wrong-host regression-guard, documentation only)
This story adds NO code to detect or handle a wrong-host-401 class at these two call sites — `jr
board`/`jr sprint` were never among the 7 ADR-0026 Decision 1 routing call sites (both already use
`client.get(...)`/`base_url` correctly, per F1 code audit), so this class should never be OBSERVED
here, pre- or post-ADR-0026.
**Test:** N/A (documentation-only clause); confirmed by the Architecture Compliance Rules table's
regression-baseline entry — no test asserts a wrong-host branch because none exists.

### AC-004 (traces to BC-X.15.001 Behavior clause 4 — Basic/API-token short-circuit) **[CORRECTED, adversary finding OBS-1, 2026-09-17: narrative reworded to distinguish the scope-mismatch vs. non-scope-mismatch Basic-auth sub-cases, matching this AC's own Test column, which was already correct — no AC/test/BC-id change]**
`is_oauth_auth() == false` short-circuits the new rewrite entirely, so `jr board`/`jr sprint`
never route a Basic-auth 401 through it. What that unaffected 401 surfaces as still depends on
the body, per `client.rs::send_inner`'s PRE-EXISTING, auth-scheme-agnostic pre-refresh scope
check (frozen by AC-007, not introduced by this story): a Basic-auth 401 body WITH a
scope-mismatch substring surfaces the generic `InsufficientScope` (issue #185) template — NOT the
BC-X.3.002 (`Not authenticated` + `jr auth login`, exit 2) path — because that pre-refresh check
fires regardless of auth scheme and this story's rewrite (Basic-auth short-circuited) never gets
a chance to rephrase it. A Basic-auth 401 body WITHOUT a scope-mismatch substring is the case that
continues to surface via the universal BC-X.3.002 path, unchanged.
**Test:** `test_bc_x_15_001_board_401_under_api_token_unaffected` (and a `sprint` sibling) —
constructs an API-token-shaped client, mounts the same `"scope does not match"` 401 body used in
AC-001, asserts the OLD (pre-this-story) generic `InsufficientScope` (#185) path fires — NOT
`NotAuthenticated`/BC-X.3.002 — and NOT the new rewrite.

### AC-005 (traces to BC-X.15.001 EC-X.15.001-1 — composite/malformed body precedence)
A 401 with BOTH a scope-mismatch substring AND an expired-token substring in the same body (a
hypothetical malformed/composite Atlassian error body) → the scope-mismatch substring check wins
(same precedence BC-X.3.005 already establishes for the generic detection rule this BC's call site
reuses) — the rewrite fires, producing the scope hint, not the auto-refresh path.
**Test:** `test_bc_x_15_001_board_401_composite_body_scope_mismatch_wins` — mounts a 401 body
containing both substrings, asserts the scope-hint rewrite fires.

### AC-006 (traces to BC-X.15.001 EC-X.15.001-3 — unrecognized body)
A 401 with neither substring (an unrecognized/malformed body) falls through unchanged to whatever
the pre-existing generic 401 handling does today (the shared `InsufficientScope`/`NotAuthenticated`
construction sites in `client.rs`, unmodified by this story).
**Test:** `test_bc_x_15_001_board_401_unrecognized_body_falls_through_unchanged` — mounts a 401
body with neither substring, asserts the new rewrite does NOT fire.

### AC-007 (regression guard, traces to BC-X.15.001 "Explicitly NOT changed by this BC")
`src/error.rs`'s `JrError::InsufficientScope` Display template and its two construction sites
(`send_inner`'s pre-refresh 401 check, `parse_error`'s post-401 fallback) are BYTE-FOR-BYTE
UNCHANGED. `src/cli/issue/jsm_create.rs`'s existing OAuth `InsufficientScope` rewrite (BC-3.8.015)
is UNCHANGED and its own test suite passes unmodified.
**Test:** diff review confirms zero lines changed in `src/error.rs` or the two named `client.rs`
construction sites; full `cargo test --test jsm_request_api` (or wherever BC-3.8.015's tests live)
green with zero edits.

### AC-008 (traces to CLAUDE.md conventions — CHANGELOG delivery task)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Fixed` entry describing: `jr board`/`jr sprint`
now surface an actionable, scope-specific hint on an OAuth granular-scope-mismatch 401 instead of
the generic POST-framed `InsufficientScope` message; no change to Basic-auth (API-token) error
behavior or to any other command family's 401 handling.
**Test:** N/A (doc artifact); presence check via PR review.

### AC-009 (**[NEW, F1 scope expansion, 2026-09-17]** — traces to BC-X.15.001 clause 1, widened — `resolve_board_id`'s internal `list_boards` call)
`src/cli/board.rs::resolve_board_id`'s auto-discovery branch (reached when neither `--board` nor a
configured `board_id` is supplied) issues its own `client.list_boards(...)` call. This helper is
shared by `board.rs::handle_view` AND, transitively, by `sprint.rs::resolve_scrum_board` (every
`sprint list`/`current`/`add`/`remove` invocation that needs board auto-discovery). A 401 from THIS
call, under OAuth with the `"scope does not match"` substring, is rewritten via the same shared
`rewrite_agile_scope_error` helper used by AC-001, with the SAME hint `jr board list` uses:
`read:board-scope:jira-software` + `read:project:jira` (same underlying HTTP call, same missing
scope, regardless of which command reached it).
**Test:** `test_bc_x_15_001_resolve_board_id_401_scope_mismatch_rewrite` (exercised via a `board
view` invocation with no `--board`/`board_id` configured) and
`test_bc_x_15_001_sprint_resolve_board_id_401_scope_mismatch_rewrite` (exercised via a `sprint
list` invocation reaching the same helper transitively) — both mount a `list_boards` 401 with the
scope-mismatch substring, assert the `read:board-scope:jira-software`/`read:project:jira` hint.

### AC-010 (**[NEW, F1 scope expansion, 2026-09-17]** — traces to BC-X.15.001 clause 1, widened — `board.rs::handle_view`'s unconditional `get_board_config` call)
`src/cli/board.rs::handle_view` calls `client.get_board_config(board_id)` unconditionally, BEFORE
branching on board type — this fires for every `jr board view` invocation, kanban or scrum. A 401
from this call, under OAuth with the scope-mismatch substring, is rewritten with the hint
`read:board-scope.admin:jira-software` naming the admin-scope requirement. (Note: this corrects the
F3 finding — there is no `--config` flag; this call is unconditional, not flag-gated.)
**Test:** `test_bc_x_15_001_board_view_get_board_config_401_scope_mismatch_rewrite` — mounts a
`get_board_config` 401 with the scope-mismatch substring during a `jr board view` invocation,
asserts the `read:board-scope.admin:jira-software` hint.

### AC-011 (**[NEW, F1 scope expansion, 2026-09-17]** — traces to BC-X.15.001 clause 1, widened, and EC-X.15.001-4 — `board.rs::handle_view`'s scrum-branch `list_sprints`/`get_sprint_issues` calls)
`src/cli/board.rs::handle_view`'s scrum branch (board type resolves to `"scrum"`) calls
`client.list_sprints(...)` then `client.get_sprint_issues(...)`. A 401 from EITHER call, under
OAuth with the scope-mismatch substring, is rewritten with the SAME grouped hint `jr sprint
list`/`jr sprint current` use: `read:sprint:jira-software` + `read:issue-details:jira` +
`read:jql:jira` (EC-X.15.001-4 ruling: grouped/over-inclusive-by-design, reused verbatim here for
consistency rather than deriving a narrower per-call-site hint).
**Test:** `test_bc_x_15_001_board_view_scrum_list_sprints_401_scope_mismatch_rewrite` and
`test_bc_x_15_001_board_view_scrum_get_sprint_issues_401_scope_mismatch_rewrite` — mount a 401 with
the scope-mismatch substring on each of the two calls in turn (against a scrum board fixture),
assert the grouped sprint-scope hint in both cases.

### AC-012 (**[NEW, F1 scope expansion, 2026-09-17]** — traces to BC-X.15.001 clause 1, widened, and EC-X.15.001-4 — `sprint.rs`'s two remaining internal call sites: `resolve_scrum_board`'s `get_board_config` call, and `SprintCommand::Add { current: true, .. }`'s `list_sprints` lookup)
(a) `src/cli/sprint.rs::resolve_scrum_board` calls `client.get_board_config(board_id)` to verify the
resolved board is scrum-type — shared by `sprint list`/`current`/`add`/`remove`. A 401 from this
call is rewritten with `read:board-scope.admin:jira-software` (same hint as AC-010's `board view`
call — same underlying HTTP call).
(b) `SprintCommand::Add { current: true, .. }`'s active-sprint-id resolution calls
`client.list_sprints(board_id, Some("active"))` — a SEPARATE call from `resolve_scrum_board`'s
`get_board_config` call earlier in the same command invocation. A 401 from THIS call is rewritten
with the same grouped sprint-scope hint as AC-011/EC-X.15.001-4:
`read:sprint:jira-software` + `read:issue-details:jira` + `read:jql:jira`.
**Test:** `test_bc_x_15_001_resolve_scrum_board_get_board_config_401_scope_mismatch_rewrite`
(exercised via `sprint list`, `sprint current`, AND `sprint add --current`, confirming the shared
helper's hint is identical across all three call paths) and
`test_bc_x_15_001_sprint_add_current_list_sprints_401_scope_mismatch_rewrite` (exercised via
`sprint add --current`, mounting the 401 on the SECOND call — i.e. `get_board_config` succeeds,
`list_sprints` 401s — asserting the grouped sprint-scope hint fires here too, distinct from (a)'s
admin-scope hint).

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| New 401 call-site rewrite (board, top-level + internal `resolve_board_id`/`handle_view` call sites) | `src/cli/board.rs` | Effectful (consumes an `Err(JrError)` from an already-issued HTTP call; itself performs no I/O) |
| New 401 call-site rewrite (sprint, top-level + internal `resolve_scrum_board`/`SprintCommand::Add{current}` call sites) | `src/cli/sprint.rs` | Effectful (same) |
| Reference pattern (read-only) | `src/api/jsm/servicedesks.rs::require_service_desk` | Effectful (existing, unmodified) |
| Shared error type (read-only) | `src/error.rs::JrError` | N/A (unmodified; this story constructs existing variants, adds no new variant) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-X.15.001-1 | 401 body with both scope-mismatch and expired-token substrings | Scope-mismatch wins (AC-005) |
| EC-X.15.001-2 | OAuth token both expired AND missing a granular scope | Auto-refresh coordinator's retry-after-refresh 401 is what this call site ultimately observes; if THAT retry's body still carries the scope-mismatch substring, the rewrite fires on the post-refresh attempt, not the pre-refresh one — this story's call site is stateless per-invocation and does not need special handling for this sequencing, since it only ever sees the final 401 the refresh coordinator hands back |
| EC-X.15.001-3 | 401 body with neither substring | Falls through unchanged (AC-006) |
| EC-X.15.001-4 (**[NEW, F4 ruling, 2026-09-17]**) | `jr sprint list`'s hint (and every other `list_sprints`-calling internal site added by this widening: AC-011's `board view` scrum branch, AC-012(b)'s `sprint add --current`) names `read:sprint:jira-software` + `read:issue-details:jira` + `read:jql:jira`, even where the failing call is `list_sprints` alone (which strictly only needs `read:sprint:jira-software`) | RULING: KEEP the grouped hint — spec-conformant, over-inclusion is benign (re-consent with the extra scopes still fixes the problem), and reusing one hint string across all `list_sprints` call sites is simpler than deriving a minimal-but-different hint per site. Not re-litigated (see BC-X.15.001 EC-X.15.001-4 for the full rationale). |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| New 401 call-site rewrite (`src/cli/board.rs`, `src/cli/sprint.rs`) | effectful-shell | Consumes an `Err(JrError)` from an already-issued HTTP call and writes to stderr; command-handler layer |
| `src/api/jsm/servicedesks.rs::require_service_desk` (read-only reference) | effectful-shell | Existing, unmodified reference pattern |
| `src/error.rs::JrError` (read-only reference) | pure-core | Enum/Display definitions; unmodified by this story |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~3,900 |
| Referenced code (`src/cli/board.rs`, `src/cli/sprint.rs` full files; `src/api/jsm/servicedesks.rs::require_service_desk` as reference pattern; `src/error.rs` variant definitions; `client.rs`'s `is_oauth_auth`/`send_inner`/`parse_error`) | ~6,000 |
| Test files (new test module covering 8 call sites, not 4; existing `tests/board_commands.rs`/`tests/sprint_commands.rs` relevant sections) | ~6,000 |
| Tool output overhead | ~1,800 |
| **Total** | **~17,700** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~9%** |

## Tasks

1. [ ] Read `src/api/jsm/servicedesks.rs::require_service_desk` in full to confirm the exact
   auth-scheme-conditional rewrite pattern and the `is_oauth_auth()` test-construction primitive
   used by its own existing tests — `test-writer`
2. [ ] Write failing tests AC-001 (4 command-family variants), AC-002, AC-004, AC-005, AC-006 —
   `test-writer`
2b. [ ] **[NEW, F1 scope expansion]** Write failing tests for AC-009, AC-010, AC-011, AC-012 — the
    4 internal-resolution call sites (`board.rs::resolve_board_id`, `board.rs::handle_view`'s
    unconditional `get_board_config` call, `board.rs::handle_view`'s scrum-branch
    `list_sprints`/`get_sprint_issues` calls, `sprint.rs::resolve_scrum_board`'s `get_board_config`
    call, and `sprint.rs`'s `SprintCommand::Add { current: true, .. }` `list_sprints` lookup) —
    `test-writer`
3. [ ] Verify Red Gate: all new tests (including the AC-009..AC-012 additions) fail against current
   code (no rewrite exists yet; `jr board`/`jr sprint` currently surface the raw generic
   `InsufficientScope`/fall-through path for every 401 shape, at every call site)
4. [ ] Implement the new call-site rewrite helper (`rewrite_agile_scope_error`, shared by
   `board.rs`/`sprint.rs`, or duplicated per-file if a shared helper would cross a module boundary
   awkwardly — implementer's choice, document the choice in the PR), gated on `is_oauth_auth()` +
   the scope-mismatch substring check (AC-001, AC-004, AC-005, AC-006) — `implementer`
5. [ ] Wire the rewrite into each of the 4 originally-named top-level command handlers in
   `board.rs`/`sprint.rs` (AC-001) — `implementer`
5b. [ ] **[NEW, F1 scope expansion]** Wire the SAME shared rewrite helper into the 4 internal
    resolution call sites (AC-009, AC-010, AC-011, AC-012) — `board.rs::resolve_board_id`'s
    `list_boards` call; `board.rs::handle_view`'s unconditional `get_board_config` call;
    `board.rs::handle_view`'s scrum-branch `list_sprints`/`get_sprint_issues` calls;
    `sprint.rs::resolve_scrum_board`'s `get_board_config` call; and
    `sprint.rs::SprintCommand::Add { current: true, .. }`'s `list_sprints` lookup — each site uses
    the hint matching its underlying HTTP call per BC-X.15.001 Behavior clause 1's mapping table,
    reusing the grouped sprint-scope hint per EC-X.15.001-4 where applicable — `implementer`
6. [ ] Confirm Green Gate: all new tests pass, including AC-009..AC-012
7. [ ] Run full existing `tests/board_commands.rs`/`tests/sprint_commands.rs` — confirm zero
   regressions to successful-response handling or non-401 error paths
8. [ ] Diff review + full `cargo test --test jsm_request_api` (or BC-3.8.015's actual test
   location) confirming `src/error.rs` and `jsm_create.rs`'s existing rewrite are untouched
   (AC-007) — `implementer`
9. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` (AC-008), before creating the PR — update
   the entry text to reflect the widened coverage (all Agile HTTP calls reachable within `jr
   board`/`jr sprint`, not only the 4 top-level command handlers)
10. [ ] Run full `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all -- --check`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-cycle8-agile-oauth-scope-gap (Wave 1, sibling) | Finalizes the exact granular scope strings this story's hints must name | RECOMMENDED sequencing: land this story's implementation AFTER S-cycle8-agile-oauth-scope-gap so the scope strings named in AC-001's hints are drawn from the already-landed `DEFAULT_OAUTH_SCOPES` constant rather than a value that could still change — this is a sequencing recommendation (F1 §7), not a `depends_on` edge, since this story's tests mock the 401 body directly and do not need the real constant to exist first | None yet — S2 has not been delivered as of this story's authorship |
| S-cycle8-jsm-servicedeskapi-oauth-routing (Wave 1, sibling) | Established the reference pattern this story models its rewrite on (`require_service_desk`) | Read `require_service_desk`'s auth-scheme-conditional rewrite shape before implementing (Task 1) | None applicable — no file overlap; `board.rs`/`sprint.rs` are not touched by the JSM story |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| 401 ambiguity is resolved by a call-site rewrite close to the failing operation, never by widening the shared `InsufficientScope` Display template | ADR-0026 Decision 3 | AC-007's diff-review + regression-suite-green requirement on `src/error.rs` and `client.rs`'s two construction sites |
| Do NOT modify `src/cli/issue/jsm_create.rs`'s existing OAuth rewrite (BC-3.8.015) — it is the one call site where the generic template's POST-specific framing is genuinely correct as-is | F1 §2.5; ADR-0026 Decision 3 rationale | AC-007's regression-suite-green requirement |
| `jr board`/`jr sprint` were never among the 7 ADR-0026 Decision 1 routing call sites — no wrong-host-401 detection code is added here | ADR-0026 Decision 3, BC-X.15.001 clause 3 | AC-003 (documentation-only, no test asserts a branch that does not exist) |
| The new rewrite is additive at the 401 branch only — no change to successful-response handling or payload construction in `board.rs`/`sprint.rs` | BC-X.15.001 "Explicitly NOT changed by this BC" | Task 7's full existing-suite regression pass |

## Library & Framework Requirements

No new dependency is added by this story. `wiremock` (existing, unchanged) is used to mount the
various 401 body shapes each AC requires.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/board.rs` | modify | New 401 call-site rewrite wired into `list`/`view` (both branches' unconditional `get_board_config` call), `resolve_board_id` (internal, `list_boards`), and `handle_view`'s scrum branch (`list_sprints`/`get_sprint_issues`) (AC-001, AC-002, AC-004, AC-005, AC-006, AC-009, AC-010, AC-011) |
| `src/cli/sprint.rs` | modify | New 401 call-site rewrite wired into `list`/`current`/`add`/`remove`, plus the internal `resolve_scrum_board` (`get_board_config`) and `SprintCommand::Add { current: true, .. }`'s `list_sprints` lookup (AC-001, AC-002, AC-004, AC-005, AC-006, AC-009, AC-012) |
| `tests/board_commands.rs` | modify/add | New 401-classification test cases |
| `tests/sprint_commands.rs` | modify/add | New 401-classification test cases |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry (AC-008) |
