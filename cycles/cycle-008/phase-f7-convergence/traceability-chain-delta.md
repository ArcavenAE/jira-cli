---
document_type: f7-traceability-chain-delta
cycle: cycle-008-oauth-surface-correctness
phase: F7
producer: orchestrator (F7 delta-convergence synthesis)
timestamp: "2026-09-18T21:00:00Z"
merged_tip: "0834c9f0f8c2b8e039778f9e00c07de7e19c9948"
---

# Traceability Chain Delta — `cycle-008` (`oauth-surface-correctness`)

Every link below was independently re-derived during F7 close: each cited test function name was
grep-confirmed to exist verbatim in the named source or test file at `develop@0834c9f0` (the
merged tip, post-FIX-F7-001). Source line numbers are approximate (`~`) per this repo's citation
convention; symbol names are the stable anchor. This document is an **append** — it extends the
traceability chain first established across the F1→F6 artifacts (`cycles/cycle-008/*.md`); it
does not replace or restate them.

---

## BC-4.2.001 — `assets search`/JSM/Teams: OAuth profiles MUST target the API gateway host

**BC home:** `.factory/specs/prd/bc-4-assets-cmdb.md` (AMENDED in place, COUNT-NEUTRAL, F2 gate
D-369). **VP:** `VP-OAUTH-GW-001` (`cycles/cycle-008/verification-delta.md`).
**ADR:** ADR-0026 Decision 1 (7-site gateway-routing invariant).

| Call site | Test (verified present) | Code |
|---|---|---|
| `get_or_fetch_workspace_id` | `test_bc_4_2_001_get_or_fetch_workspace_id_targets_base_url_under_oauth` (`tests/assets.rs:~1855`) | `src/api/assets/workspace.rs::get_or_fetch_workspace_id` |
| `list_service_desks` | `test_bc_4_2_001_list_service_desks_targets_base_url_under_oauth` (`tests/jsm_request_api.rs:~432`) | `src/api/jsm/servicedesks.rs::list_service_desks` |
| `list_request_types` | `test_bc_4_2_001_list_request_types_targets_base_url_under_oauth` (`tests/jsm_request_api.rs:~490`) | `src/api/jsm/request_types.rs::list_request_types` |
| `get_request_type_fields` | `test_bc_4_2_001_get_request_type_fields_targets_base_url_under_oauth` (`tests/jsm_request_api.rs:~555`) | `src/api/jsm/request_types.rs::get_request_type_fields` |
| `list_queues` | `test_bc_4_2_001_list_queues_targets_base_url_under_oauth` (`tests/jsm_request_api.rs:~616`) | `src/api/jsm/queues.rs::list_queues` |
| `get_queue_issue_keys` | `test_bc_4_2_001_get_queue_issue_keys_targets_base_url_under_oauth` (`tests/jsm_request_api.rs:~681`) | `src/api/jsm/queues.rs::get_queue_issue_keys` |
| `create_jsm_request` | `test_bc_4_2_001_create_jsm_request_targets_base_url_under_oauth` (`tests/jsm_request_api.rs:~748`) | `src/api/jsm/requests.rs::create_jsm_request` |

All 7 tests construct the client via `JiraClient::new_for_test_with_instance_url(base_url,
instance_url, auth_header)` with `base_url != instance_url`, point a wiremock server at
`base_url` only, and assert the mocked gateway endpoint received the request with a `.expect(0)`
negative control on the `instance_url` mock — per VP-OAUTH-GW-001's proof strategy.

**F5 adversary passes:** all 7 sites confirmed unchanged/correct across 3 clean whole-delta
passes (`cycles/cycle-008/phase-f5-adversarial/convergence-summary.md`). **F6 hardening:**
`src/api/jsm/queues.rs` and `src/api/assets/workspace.rs` (2 of the 7 sites) were part of the
`CYCLE-008-F6-MUTANTS-EXAMINE-GLOBS-GAP` residual — CLOSED via FIX-F7-001 (PR #845,
`develop@0834c9f0`), both files now in `.cargo/mutants.toml` `examine_globs`.

---

## BC-X.15.001 — OAuth Agile-command 401 error-mapping (scope-mismatch vs. expired-token vs. wrong-host)

**BC home:** `.factory/specs/prd/cross-cutting.md` `## BC-X.15` (NEW, F2 gate D-369; wave-level
finding F-WG-1 EXPANDED call-site coverage 2026-09-17). **VP:** `VP-OAUTH-GW-003`.
**ADR:** ADR-0026 Decision 3.

| Call site | Test (verified present) | Code |
|---|---|---|
| `jr board list` | `test_bc_x_15_001_board_list_401_scope_mismatch_names_missing_scopes` (`tests/board_commands.rs:~45`) | `src/cli/board.rs::is_insufficient_scope_error` + `rewrite_agile_scope_error` |
| `jr board view` (`get_board_config`) | `test_bc_x_15_001_board_view_401_scope_mismatch_names_admin_scope` (`tests/board_commands.rs:~114`) | `src/cli/board.rs::resolve_board_id` |
| composite-body precedence | `test_bc_x_15_001_board_401_composite_body_scope_mismatch_wins` (`tests/board_commands.rs:~175`) | `src/api/client.rs::classify_401_body` |
| Basic-auth (API-token) unaffected | `test_bc_x_15_001_board_401_under_api_token_unaffected` (`tests/board_commands.rs:~227`) | `src/cli/board.rs` (auth-scheme-conditional gate) |
| unrecognized body falls through | `test_bc_x_15_001_board_401_unrecognized_body_falls_through_unchanged` (`tests/board_commands.rs:~289`) | `src/api/client.rs::classify_401_body` |
| expired-token falls through to refresh | `test_bc_x_15_001_board_401_without_scope_substring_falls_through_to_refresh` (`tests/board_commands.rs:~356`) | `src/api/refresh_coordinator.rs` (unchanged path) |
| `resolve_board_id` rewrite | `test_bc_x_15_001_resolve_board_id_401_scope_mismatch_rewrite` (`tests/board_commands.rs:~466`) | `src/cli/board.rs::resolve_board_id` |
| `jr board view` scrum → `list_sprints` (F-WG-1 widened) | `test_bc_x_15_001_board_view_scrum_list_sprints_401_scope_mismatch_rewrite` (`tests/board_commands.rs:~529`) | `src/cli/board.rs` |
| `jr board view` scrum → `get_sprint_issues` (F-WG-1 widened) | `test_bc_x_15_001_board_view_scrum_get_sprint_issues_401_scope_mismatch_rewrite` (`tests/board_commands.rs:~603`) | `src/cli/board.rs` |
| `jr sprint list` | `test_bc_x_15_001_sprint_list_401_scope_mismatch_names_missing_scopes` (`tests/sprint_commands.rs:~38`) | `src/cli/sprint.rs` |
| `jr sprint remove` | `test_bc_x_15_001_sprint_remove_401_scope_mismatch_names_missing_scope` (`tests/sprint_commands.rs:~111`) | `src/cli/sprint.rs` |
| `jr sprint` Basic-auth unaffected | `test_bc_x_15_001_sprint_401_under_api_token_unaffected` (`tests/sprint_commands.rs:~164`) | `src/cli/sprint.rs` |
| `jr sprint` expired-token fall-through | `test_bc_x_15_001_sprint_401_without_scope_substring_falls_through_to_refresh` (`tests/sprint_commands.rs:~221`) | `src/cli/sprint.rs` |
| `jr sprint`'s `resolve_board_id` rewrite | `test_bc_x_15_001_sprint_resolve_board_id_401_scope_mismatch_rewrite` (`tests/sprint_commands.rs:~317`) | `src/cli/sprint.rs` |
| `jr sprint`'s `resolve_scrum_board`/`get_board_config` rewrite | `test_bc_x_15_001_resolve_scrum_board_get_board_config_401_scope_mismatch_rewrite` (`tests/sprint_commands.rs:~385`) | `src/cli/sprint.rs::resolve_scrum_board` |
| `jr sprint add/current`'s `list_sprints` rewrite | `test_bc_x_15_001_sprint_add_current_list_sprints_401_scope_mismatch_rewrite` (`tests/sprint_commands.rs:~461`) | `src/cli/sprint.rs` |
| `jr sprint add` | `test_bc_x_15_001_sprint_add_401_scope_mismatch_names_missing_scope` (`tests/sprint_commands.rs:~1079`) | `src/cli/sprint.rs` |
| `jr issue list` board-resolution path (F-WG-1 widened) | `test_issue_list_board_config_401_scope_mismatch_names_admin_scope` (`tests/issue_list_oauth_scope.rs:~59`) | `src/cli/issue/list.rs::handle_list` |
| `jr issue list` scrum → `list_sprints` (F-WG-1 widened) | `test_issue_list_sprints_401_scope_mismatch_names_grouped_scopes` (`tests/issue_list_oauth_scope.rs:~128`) | `src/cli/issue/list.rs::handle_list` |
| `jr init`'s board-selection prompt (F-WG-1 widened) | `test_init_list_boards_401_scope_mismatch_names_missing_scopes` (`tests/init_oauth_scope.rs:~129`) | `src/cli/init.rs::handle` |

**Pure-fn unit coverage (`src/cli/board.rs`, inline `#[cfg(test)]`):**
`test_rewrite_agile_scope_error_passes_through_non_insufficient_scope_jrerror_unchanged`,
`test_rewrite_agile_scope_error_passes_through_non_jrerror_unchanged`,
`test_rewrite_agile_scope_error_fires_through_context_wrapped_chain`,
`test_rewrite_agile_scope_error_fires_for_init_list_boards_scope_string` — all present,
confirming `rewrite_agile_scope_error`'s chain-aware downcast (FIX-F5-001's fix) is non-vacuous.

**`classify_401_body` pure-fn coverage (`src/api/client.rs`, inline `#[cfg(test)]`):**
`test_classify_401_body_returns_insufficient_scope_for_scope_mismatch_message`,
`test_classify_401_body_returns_insufficient_scope_for_real_wire_message`,
`test_classify_401_body_scope_mismatch_match_is_case_insensitive`,
`test_classify_401_body_not_authenticated_carries_login_hint_verbatim`,
`test_classify_401_body_not_authenticated_carries_refresh_hint_verbatim`,
`test_classify_401_body_returns_not_authenticated_for_empty_message`,
`test_classify_401_body_returns_not_authenticated_for_near_miss_substrings` — all present. These
are the pure-fn tests F6's Kani/fuzz JUSTIFIED-SKIP rationale rests on (total-by-construction,
unit-covered) and the same tests `CYCLE-008-F6-PUREFN-MUTATION-HOST-DEFERRED`'s deferred
empirical mutation-confirmation targets once nightly/CI mutation runs against the now-widened
`examine_globs` (FIX-F7-001).

**F5 adversary passes:** Pass 1 found F1 (`init.rs`'s scope-hint not chain-aware) and F3 (LOW),
both FIXED via FIX-F5-001 (PR #844, `develop@fc608cd3`) — added
`test_rewrite_agile_scope_error_fires_for_init_list_boards_scope_string` and the chain-aware
downcast in `rewrite_agile_scope_error`. Passes 2-3 CLEAN, novelty 0.10.
**F6 hardening:** `src/cli/board.rs`, `src/cli/sprint.rs`, `src/cli/issue/list.rs` were 3 of the
`CYCLE-008-F6-MUTANTS-EXAMINE-GLOBS-GAP` residual's 7 files — CLOSED via FIX-F7-001. `src/cli/init.rs`
remains deferred (`CYCLE-008-INIT-MUTATION-COVERAGE-SEAM`, new follow-up minted at this close):
zero default-CI mutation coverage on `handle()`, same whole-file-flooding class as the
pre-existing `auth.rs`/`login.rs` deferral — not actioned this cycle, tracked for a future
mutation-hardening pass.

---

## BC-1.3.023 — `DEFAULT_OAUTH_SCOPES` includes granular Jira-Software/Agile scopes + `manage:jira-project`

**BC home:** `.factory/specs/prd/bc-1-auth-identity.md` (AMENDED in place, COUNT-NEUTRAL, F2 gate
D-369, full-parity 16-scope decision). **VP:** `VP-OAUTH-GW-002`.
**ADR:** ADR-0026 Decision 2 + Decision 2a (`manage:jira-project` component-write gap).

| AC | Test (verified present) | Code |
|---|---|---|
| AC-001..004 (full 16-scope pin, incl. 7 new Agile scopes) | `default_oauth_scopes_pins_the_full_set_with_offline_access` (`src/cli/auth/tests/mod.rs:~366`) | `src/api/auth.rs::DEFAULT_OAUTH_SCOPES` |
| AC-003 (`manage:jira-project`, component-write gap) | same test, `manage:jira-project` assertion (`~382`) | `src/api/auth.rs::DEFAULT_OAUTH_SCOPES` |
| Total-count canary (exactly 16, no drift) | same test, count assertion (`~400`) | `src/api/auth.rs::DEFAULT_OAUTH_SCOPES` |
| Negative control (Teams scopes explicitly excluded) | same test, `assert!(!scopes.contains(...))` for `view:team:teams`/`view:membership:teams` per VP-OAUTH-GW-002 | `src/api/auth.rs::DEFAULT_OAUTH_SCOPES` |

This is a pure pinning test (`&str` substring/count checks, no I/O) — the simplest VP class in
this delta, per `verification-delta.md`'s own TRIVIAL feasibility rating. RED-GATE-tagged in its
own doc-comment (`S-cycle8-agile-oauth-scope-gap`, test-writer, BC-5.38.001 discipline): the test
was written to fail against the pre-fix 8-scope constant before the implementation edit landed.

**F5 adversary passes:** unaffected across all 3 whole-delta passes — no finding touched this
BC's test or the constant. **F6 hardening:** `VP-OAUTH-GW-002` coverage confirmed adequate by
inspection (hardening-record.md's VP-coverage table) — TRIVIAL feasibility class, no mutation
residual (the constant is not itself in `examine_globs`' file-glob scope; the pinning test's
string-literal assertions are not the kind of logic mutation testing targets).

---

## Cross-cutting: F5/F6 evidence index

- **F5 scoped adversarial (3 clean passes, novelty 0.10):** `cycles/cycle-008/phase-f5-adversarial/convergence-summary.md`.
- **F6 targeted hardening (HARDENED_WITH_RESIDUALS → residual now 6/7 resolved):** `cycles/cycle-008/phase-f6-hardening/hardening-record.md` + `mutants.log` + `mutants_libscope.log` + `deny.log` + `audit.log` + `regression.log`.
- **F7 close remediation (FIX-F7-001, PR #845, `develop@0834c9f0`):** `.cargo/mutants.toml` (25→31 `examine_globs` entries, 5 new anchored `exclude_re`), `docs/specs/cargo-mutants-policy.md` (§Scope updated, `src/cli/init.rs` deferral documented).
- **Convergence report:** `cycles/cycle-008/phase-f7-convergence/delta-convergence-report.md`.
