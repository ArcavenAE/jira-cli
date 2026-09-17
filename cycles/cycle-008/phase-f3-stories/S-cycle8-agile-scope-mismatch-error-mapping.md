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
input-hash: "ef3a57c"
traces_to: "ADR-0026 Decision 3; BC-X.15.001"
cycle: cycle-008-oauth-surface-correctness
estimated_effort: small
estimated_days: 1.5
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
points: 5
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
created: "2026-09-17"
version: "1.0"
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
  (src/api/jsm/servicedesks.rs), for exactly two command families. BC-X.15.001
  (new, cross-cutting.md) authored at F2 to govern this story's ACs.
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
| BC-X.15.001 | PRIMARY (new) | All 4 Behavior clauses (scope-mismatch rewrite, expired-token fall-through, wrong-host regression-guard boundary, Basic-auth short-circuit) and its 3 documented Edge Cases |
| BC-5.1.001 | CROSS-REFERENCE (unchanged) | The cross-reference note added at F2 pointing readers debugging `jr board list`'s 401 at BC-X.15.001 and BC-1.3.023 rather than suspecting a routing bug |

**Anchor justification:** BC-X.15.001 is a NEW BC authored specifically for this workstream at the
cycle-008 F2 spec-evolution pass (`cross-cutting.md` §X.15, definitional_count 93→94), modeled on
the BC-X.8.006/BC-X.8.007 template for `require_service_desk`. This story is that BC's sole
implementation vehicle — no other story in this cycle touches `src/cli/board.rs`/`src/cli/sprint.rs`.

## Acceptance Criteria

### AC-001 (traces to BC-X.15.001 Behavior clause 1 — genuine scope-mismatch rewrite)
For a `jr board`/`jr sprint` command handler receiving a 401 whose body carries the case-insensitive
`"scope does not match"` substring (the same detection rule BC-X.3.005/BC-1.6.044 already use)
while the active auth scheme is OAuth (`client.is_oauth_auth() == true`), the call site rewrites the
error to `JrError::NotAuthenticated { hint }` — NOT `InsufficientScope` — with a hint naming the
missing granular scope(s) for the specific failing command:
- `jr board list` → `read:board-scope:jira-software` + `read:project:jira`
- `jr board view --config` → `read:board-scope.admin:jira-software`
- `jr sprint list`/`jr sprint current` → `read:sprint:jira-software` + `read:issue-details:jira` +
  `read:jql:jira`
- `jr sprint add`/`jr sprint remove` → `write:board-scope:jira-software`

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

### AC-004 (traces to BC-X.15.001 Behavior clause 4 — Basic/API-token short-circuit)
`is_oauth_auth() == false` short-circuits the new rewrite entirely — a Basic-auth 401 on `jr
board`/`jr sprint` continues to surface via the universal BC-X.3.002 (`Not authenticated` + `jr
auth login`, exit 2) path, unchanged.
**Test:** `test_bc_x_15_001_board_401_under_api_token_unaffected` (and a `sprint` sibling) —
constructs an API-token-shaped client, mounts the same `"scope does not match"` 401 body used in
AC-001, asserts the OLD (pre-this-story) generic path fires, not the new rewrite.

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

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| New 401 call-site rewrite (board) | `src/cli/board.rs` | Effectful (consumes an `Err(JrError)` from an already-issued HTTP call; itself performs no I/O) |
| New 401 call-site rewrite (sprint) | `src/cli/sprint.rs` | Effectful (same) |
| Reference pattern (read-only) | `src/api/jsm/servicedesks.rs::require_service_desk` | Effectful (existing, unmodified) |
| Shared error type (read-only) | `src/error.rs::JrError` | N/A (unmodified; this story constructs existing variants, adds no new variant) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-X.15.001-1 | 401 body with both scope-mismatch and expired-token substrings | Scope-mismatch wins (AC-005) |
| EC-X.15.001-2 | OAuth token both expired AND missing a granular scope | Auto-refresh coordinator's retry-after-refresh 401 is what this call site ultimately observes; if THAT retry's body still carries the scope-mismatch substring, the rewrite fires on the post-refresh attempt, not the pre-refresh one — this story's call site is stateless per-invocation and does not need special handling for this sequencing, since it only ever sees the final 401 the refresh coordinator hands back |
| EC-X.15.001-3 | 401 body with neither substring | Falls through unchanged (AC-006) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| New 401 call-site rewrite (`src/cli/board.rs`, `src/cli/sprint.rs`) | effectful-shell | Consumes an `Err(JrError)` from an already-issued HTTP call and writes to stderr; command-handler layer |
| `src/api/jsm/servicedesks.rs::require_service_desk` (read-only reference) | effectful-shell | Existing, unmodified reference pattern |
| `src/error.rs::JrError` (read-only reference) | pure-core | Enum/Display definitions; unmodified by this story |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,800 |
| Referenced code (`src/cli/board.rs`, `src/cli/sprint.rs` full files; `src/api/jsm/servicedesks.rs::require_service_desk` as reference pattern; `src/error.rs` variant definitions; `client.rs`'s `is_oauth_auth`/`send_inner`/`parse_error`) | ~6,000 |
| Test files (new test module; existing `tests/board_commands.rs`/`tests/sprint_commands.rs` relevant sections) | ~4,000 |
| Tool output overhead | ~1,500 |
| **Total** | **~14,300** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~7%** |

## Tasks

1. [ ] Read `src/api/jsm/servicedesks.rs::require_service_desk` in full to confirm the exact
   auth-scheme-conditional rewrite pattern and the `is_oauth_auth()` test-construction primitive
   used by its own existing tests — `test-writer`
2. [ ] Write failing tests AC-001 (4 command-family variants), AC-002, AC-004, AC-005, AC-006 —
   `test-writer`
3. [ ] Verify Red Gate: all new tests fail against current code (no rewrite exists yet; `jr
   board`/`jr sprint` currently surface the raw generic `InsufficientScope`/fall-through path for
   every 401 shape)
4. [ ] Implement the new call-site rewrite helper (shared by `board.rs`/`sprint.rs`, or duplicated
   per-file if a shared helper would cross a module boundary awkwardly — implementer's choice,
   document the choice in the PR), gated on `is_oauth_auth()` + the scope-mismatch substring check
   (AC-001, AC-004, AC-005, AC-006) — `implementer`
5. [ ] Wire the rewrite into each of the 4 named command handlers in `board.rs`/`sprint.rs`
   (AC-001) — `implementer`
6. [ ] Confirm Green Gate: all new tests pass
7. [ ] Run full existing `tests/board_commands.rs`/`tests/sprint_commands.rs` — confirm zero
   regressions to successful-response handling or non-401 error paths
8. [ ] Diff review + full `cargo test --test jsm_request_api` (or BC-3.8.015's actual test
   location) confirming `src/error.rs` and `jsm_create.rs`'s existing rewrite are untouched
   (AC-007) — `implementer`
9. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` (AC-008), before creating the PR
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
| `src/cli/board.rs` | modify | New 401 call-site rewrite wired into `list`/`view --config` (AC-001, AC-002, AC-004, AC-005, AC-006) |
| `src/cli/sprint.rs` | modify | New 401 call-site rewrite wired into `list`/`current`/`add`/`remove` (AC-001, AC-002, AC-004, AC-005, AC-006) |
| `tests/board_commands.rs` | modify/add | New 401-classification test cases |
| `tests/sprint_commands.rs` | modify/add | New 401-classification test cases |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry (AC-008) |
