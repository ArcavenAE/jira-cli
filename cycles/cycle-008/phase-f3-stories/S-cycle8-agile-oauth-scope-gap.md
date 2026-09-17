---
document_type: story
level: ops
story_id: "S-cycle8-agile-oauth-scope-gap"
epic_id: "OAUTH-SURFACE-CORRECTNESS-1"
title: "DEFAULT_OAUTH_SCOPES full-parity finalization: +manage:jira-project +7 granular Jira-Software scopes (16-scope set)"
wave: 1
status: draft
intent: bug-fix
feature_type: correctness
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
producer: story-writer
timestamp: "2026-09-17T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-008/F1-delta-analysis.md"
  - ".factory/cycles/cycle-008/F2-architecture-delta.md"
  - ".factory/cycles/cycle-008/oauth-scope-matrix.md"
  - ".factory/cycles/cycle-008/oauth-endpoint-inventory.md"
  - ".factory/specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - "src/api/auth.rs"
  - "src/cli/auth/tests/mod.rs"
input-hash: "611fb6d"
traces_to: "ADR-0026 Decision 2 + Decision 2a (finalized, F2 human gate); BC-1.3.023"
cycle: cycle-008-oauth-surface-correctness
estimated_effort: xsmall
estimated_days: 1
target_module: "src/api/auth.rs, src/cli/auth/tests/mod.rs"
subsystems: ["SS-03", "SS-02"]
# SS-03 (HTTP Client Core, src/api/auth.rs) owns this story's primary scope
# because DEFAULT_OAUTH_SCOPES lives there per ARCH-INDEX's own subsystem
# boundary. SS-02 (CLI Layer) is a secondary touch because the pinning test
# lives at src/cli/auth/tests/mod.rs -- a test-only, same-commit companion
# edit, not a CLI-behavior change.
depends_on: []
blocks: []
# No hard code dependency on any other cycle-008 story: the scope constant
# edit is self-contained. S-cycle8-agile-scope-mismatch-error-mapping (S4) is
# RECOMMENDED to land after this story (F1 delta-analysis.md S1-preview table:
# "Best sequenced AFTER S2 -- needs the real Agile-scope-mismatch case to
# exist/be testable against") but that is a sequencing recommendation, not a
# depends_on edge -- S4's error-mapping rewrite can be built and tested against
# a mocked 401 body independently of whether this story has landed yet.
behavioral_contracts:
  - BC-1.3.023
bcs:
  - BC-1.3.023
verification_properties:
  - VP-OAUTH-GW-002
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0026"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-008/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: facade
module_criticality: HIGH
points: 3
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-09-17"
version: "1.0"
last_updated: "2026-09-17"
breaking_change: true
retroactive: false
origin: >
  cycle-008 oauth-surface-correctness, Wave 1, no deps, no blocks (code-level).
  F1 delta-analysis (.factory/cycles/cycle-008/F1-delta-analysis.md §2.2)
  identified the Agile granular-scope gap; the F2 deep audit
  (.factory/cycles/cycle-008/oauth-scope-matrix.md) additionally discovered the
  component-write manage:jira-project gap adjacent to the bulk-API
  investigation. At the F2 human gate the human selected the FULL-PARITY
  16-scope option over a narrower Agile-only expansion (ADR-0026 Decision 2 as
  finalized; BC-1.3.023 amended a second time same day). This story implements
  that already-finalized decision -- it does not re-litigate the scope
  selection itself.
---

> **tdd_mode:** `facade` — this story is a single `const`/string-literal edit
> (`DEFAULT_OAUTH_SCOPES`) plus its companion pinning-test update and a
> CHANGELOG entry. There is no new runtime logic to scaffold with `todo!()`
> bodies; the pinning test IS the verification mechanism, mirroring the
> `tdd_mode: facade` precedent set by `S-cycle13-msrv-cargo-ci-atomic-bump`
> for config/constant-only stories. `module_criticality: HIGH` (not LOW)
> because a mismatch between this constant and the Developer Console
> registration hard-fails OAuth login for every user (see Architecture
> Compliance Rules and the RELEASE GATE note below).

> **Execute:** `/vsdd-factory:deliver-story S-cycle8-agile-oauth-scope-gap`

# S-cycle8-agile-oauth-scope-gap — DEFAULT_OAUTH_SCOPES full-parity finalization (16-scope set)

## Narrative

- **As a** `jr` user authenticated via OAuth (3LO)
- **I want to** have `jr board`, `jr sprint`, and `jr component create/edit/delete/rename` request
  the granular Jira-Software scopes and the `manage:jira-project` scope on login/refresh
- **So that** these two command families stop 401-ing under OAuth for a scope-mismatch reason,
  with zero change to the scopes already held (classic and granular scopes coexist on one app)

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-1.3.023 | PRIMARY (amended a second time, F2 gate finalization) | The finalized 16-scope `DEFAULT_OAUTH_SCOPES` literal, its per-scope justification table, the Teams-exclusion clause, the pinning-test obligation, and the RELEASE GATE clause |

**Anchor justification:** BC-1.3.023 is the sole BC governing `DEFAULT_OAUTH_SCOPES` in this spec
corpus (`bc-1-auth-identity.md`). It was already amended twice on 2026-09-17 by the F2 spec
evolution pass to record the finalized 16-scope set; this story is the F4 implementation of that
already-approved amendment, not a new spec decision.

## Acceptance Criteria

### AC-001 (traces to BC-1.3.023 Behavior — finalized 16-scope literal)
`src/api/auth.rs`'s `DEFAULT_OAUTH_SCOPES` `concat!` literal (`~L59`) reads exactly:
```
read:jira-work write:jira-work read:jira-user read:servicedesk-request write:servicedesk-request read:cmdb-object:jira read:cmdb-schema:jira offline_access manage:jira-project read:board-scope:jira-software read:board-scope.admin:jira-software read:sprint:jira-software write:board-scope:jira-software read:project:jira read:issue-details:jira read:jql:jira
```
16 space-separated scopes, no double spaces, no trailing/leading whitespace, exact ordering as
given (8 pre-existing scopes unchanged in position, followed by `manage:jira-project`, followed by
the 7 granular Agile scopes in the order listed in BC-1.3.023's Behavior section).
**Test:** `default_oauth_scopes_pins_the_full_set_with_offline_access` (rewritten, AC-002) asserts
the exact string.

### AC-002 (traces to BC-1.3.023 Behavior — pinning-test lockstep obligation)
`src/cli/auth/tests/mod.rs::default_oauth_scopes_pins_the_full_set_with_offline_access` is updated
in the SAME commit as AC-001 to assert the complete 16-scope union (not merely a subset), asserts
no double spaces, and gains two new `assert!(!scopes.contains(...))` negative assertions:
`!scopes.contains("view:team:teams")` and `!scopes.contains("view:membership:teams")`.
**Test:** the test itself, run green; a temporary local mutation re-inserting either Teams scope
string makes the negative assertions fail (manually verified during implementation, not a
permanent test fixture).

### AC-003 (traces to BC-1.3.023 Behavior — component-write scope, NEW)
`manage:jira-project` is present in the scope string (subset of AC-001) and is NOT
`write:jira-work` — i.e. this AC exists to make explicit that the component-write gap
(`oauth-scope-matrix.md` headline verdict 2; inventory #41/#42/#44) is closed by this addition,
distinct from and in addition to the Agile scopes.
**Test:** covered by AC-002's exact-string assertion; no separate test beyond confirming the
literal substring `manage:jira-project` is present exactly once.

### AC-004 (traces to BC-1.3.023 Behavior — Teams scopes explicitly excluded)
`view:team:teams` and `view:membership:teams` are NOT present anywhere in
`DEFAULT_OAUTH_SCOPES` — Workstream D (Teams) is deferred to the S6 spike and is not approved to
land in this constant this cycle.
**Test:** AC-002's two negative assertions.

### AC-005 (traces to BC-1.3.023 "No change is required to the auth-URL builder" clause — regression guard)
`src/cli/auth/login.rs::resolve_oauth_scopes` and `src/api/auth.rs::build_authorize_url` are
UNCHANGED by this story — both already emit the full scope-union string with `prompt=consent`
hardcoded (confirmed by F1/F2 code audit), which already satisfies Atlassian's "always request the
full intended union" requirement regardless of the scope set's size.
**Test:** diff review confirms zero lines changed in `login.rs`/the `build_authorize_url` function
itself; existing `tests/oauth_help_text.rs` / `tests/oauth_flow_holdouts.rs` assertions about the
authorize-URL shape pass unmodified except for any literal scope-string comparison they may embed
(if any such test asserts the OLD 8-scope string verbatim, it is updated in the same commit as
AC-001/AC-002 — confirmed via `grep -rn "DEFAULT_OAUTH_SCOPES\|read:jira-work write:jira-work" tests/`
before implementation begins).

### AC-006 (traces to CLAUDE.md's own `DEFAULT_OAUTH_SCOPES` procedure + BC-1.3.023 Maintainer Coordination)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Changed` entry stating: (a) OAuth scope set grows
from 8 to 16 scopes, adding `manage:jira-project` and 7 granular Jira-Software/Agile scopes; (b)
existing OAuth users will see a re-consent (`prompt=consent`) prompt on next login or token
refresh; (c) this unblocks `jr board`/`jr sprint`/`jr component create/edit/delete/rename` under
OAuth (pending the routing/error-mapping fixes in the sibling stories of this cycle where
applicable); (d) explicit note that the Atlassian Developer Console app-permission update for the
embedded `jr` OAuth app MUST land before this release ships, naming all 8 new scopes.
**Test:** N/A (doc artifact); presence check via PR review.

### AC-007 (traces to F1 §6b / ADR-0026 Consequences "Negative" — RELEASE GATE, non-code)
The PR description for this story explicitly calls out, as a checklist item requiring human
sign-off before merge-to-release (not before merge-to-`develop` — this story may land on `develop`
ahead of the Console update, but MUST NOT ship in a tagged release without it): the Atlassian
Developer Console registration for the embedded `jr` OAuth app has been updated to include ALL 8
new scopes (`manage:jira-project` + the 7 granular Agile scopes), or `invalid_scope` will hard-fail
every OAuth login/refresh for every user, not just Agile/component-command users.
**Test:** N/A (process gate, not a code test); PR description review confirms the checklist item
is present and explicit.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `DEFAULT_OAUTH_SCOPES` | `src/api/auth.rs` | Pure (const string literal, no I/O) |
| `default_oauth_scopes_pins_the_full_set_with_offline_access` | `src/cli/auth/tests/mod.rs` | Pure (string assertion test) |
| `resolve_oauth_scopes` / `build_authorize_url` | `src/cli/auth/login.rs`, `src/api/auth.rs` | Effectful (unchanged by this story — regression guard only, AC-005) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-1 | Existing OAuth user with a token minted under the OLD 8-scope grant, no re-login yet | Continues to work for endpoints covered by the 8 old scopes; a call to a newly-scope-gated endpoint (Agile/component-write) still 401s until the user re-authenticates — this is expected, not a defect (Atlassian does not retroactively widen an existing token's scope) |
| EC-2 | Console update NOT yet landed, this constant already shipped | `jr auth login --oauth` hard-fails `invalid_scope` for ALL users, not just Agile/component users — this is the single highest-severity release-process risk this cycle identifies; AC-007 exists specifically to prevent this |
| EC-3 | A future cycle accidentally re-adds `view:team:teams`/`view:membership:teams` to this constant before Workstream D is separately approved | AC-002's negative assertions fail immediately, catching the leak at CI time |
| EC-4 | API-token (Basic auth) profile | Entirely unaffected — `DEFAULT_OAUTH_SCOPES` is only consulted by the OAuth login/refresh flow, never by Basic-auth request construction |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `src/api/auth.rs` (`DEFAULT_OAUTH_SCOPES`) | pure-core | Const string literal, no I/O |
| `src/cli/auth/tests/mod.rs` | pure-core | String assertion test, no I/O |
| `src/cli/auth/login.rs::resolve_oauth_scopes` / `src/api/auth.rs::build_authorize_url` | effectful-shell | Unchanged by this story; consumes the constant and constructs a URL for a browser redirect |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,200 |
| Referenced code (`src/api/auth.rs` `DEFAULT_OAUTH_SCOPES` region + doc comment, `src/cli/auth/tests/mod.rs` pinning test, `src/cli/auth/login.rs::resolve_oauth_scopes`, `build_authorize_url`) | ~2,500 |
| Test files (`tests/oauth_help_text.rs`, `tests/oauth_flow_holdouts.rs` — grep-scoped, not full-file reads) | ~1,500 |
| Tool output overhead | ~1,000 |
| **Total** | **~7,200** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~4%** |

## Tasks

1. [ ] `grep -rn "DEFAULT_OAUTH_SCOPES\|read:jira-work write:jira-work" tests/` to find every test
   file with a literal scope-string assertion beyond `src/cli/auth/tests/mod.rs` — `test-writer`
2. [ ] Update `default_oauth_scopes_pins_the_full_set_with_offline_access` to assert the new
   16-scope union + no-double-spaces + the two Teams negative assertions (AC-002) — `test-writer`
3. [ ] Confirm Red Gate: the updated pinning test fails against the current 8-scope constant
4. [ ] Edit `src/api/auth.rs`'s `DEFAULT_OAUTH_SCOPES` `concat!` literal to the finalized 16-scope
   string, in the exact order given in AC-001 (AC-001, AC-003, AC-004) — `implementer`
5. [ ] Confirm Green Gate: the pinning test passes
6. [ ] Update any other test file found in Task 1 with a stale literal scope-string assertion, in
   the SAME commit — `implementer`
7. [ ] Diff-confirm zero lines changed in `src/cli/auth/login.rs::resolve_oauth_scopes` or
   `src/api/auth.rs::build_authorize_url` (AC-005) — `implementer`
8. [ ] Add a CHANGELOG entry under `[Unreleased] > Changed` (AC-006), before creating the PR
9. [ ] PR description includes the explicit Developer Console RELEASE GATE checklist item (AC-007)
10. [ ] Run full `cargo test`, `cargo clippy -- -D warnings`, `cargo fmt --all -- --check`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-cycle8-jsm-servicedeskapi-oauth-routing (Wave 1, sibling) | Established the `JiraClient::new_for_test_with_instance_url` seam for this cycle's routing fixes | N/A for this story (this story is a scope-only edit, no routing call sites) | None applicable — no file overlap with this story |

This is a Wave 1 story with no cycle-008 predecessor whose output this story consumes; it is
sequenced in parallel with S1/S3/S4.

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| Classic and granular OAuth scopes coexist on one 3LO app with no forced migration — do not remove or "simplify" the pre-existing 8 classic/CMDB scopes when adding the granular Agile set | ADR-0026 Consequences "Confirmed findings" | AC-001's exact-string assertion preserves all 8 pre-existing scopes unchanged in position |
| A new OAuth consent always overrides the prior grant's scopes; the authorize URL must emit the FULL union, never an incremental diff | ADR-0026 Decision 2; Atlassian OAuth docs | AC-005 confirms the pre-existing `resolve_oauth_scopes`/`build_authorize_url` plumbing already satisfies this — no new code needed |
| Teams scopes (`view:team:teams`, `view:membership:teams`) MUST NOT land in `DEFAULT_OAUTH_SCOPES` until Workstream D (S6 spike, S7 conditional) is separately approved | ADR-0026 Decision 2 / Decision 4 | AC-002's negative assertions; AC-004 |
| `DEFAULT_OAUTH_SCOPES` changes require a Developer Console update as a hard pre-release gate, not a follow-up task | CLAUDE.md OAuth Gotcha section; BC-1.3.023 RELEASE GATE clause | AC-007's explicit PR-description checklist item |

## Library & Framework Requirements

No new dependency is added by this story. No version pins change.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/auth.rs` | modify | `DEFAULT_OAUTH_SCOPES` literal update (AC-001, AC-003, AC-004) |
| `src/cli/auth/tests/mod.rs` | modify | `default_oauth_scopes_pins_the_full_set_with_offline_access` rewrite (AC-002) |
| Any test file surfaced by Task 1's grep (e.g. `tests/oauth_help_text.rs`, `tests/oauth_flow_holdouts.rs`) | modify (conditional) | Update any stale literal 8-scope string assertion, only if one exists |
| `CHANGELOG.md` | modify | `[Unreleased] > Changed` entry (AC-006) |
