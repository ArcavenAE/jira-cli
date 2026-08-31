# Demo Evidence — S-578-4

`issue create --field` platform (non-JSM) path — createmeta resolution + DEC-188
guard reversal (DEC-310) + create-path collision guard (D2).

Product type: CLI (Rust, binary `jr`). Toolchain: VHS 0.11.0 (`.gif` + `.webm` per
recording). All recordings run against the debug build (`cargo build --bin jr`)
on this worktree's HEAD. Backend for the createmeta-resolution recordings is a
small local mock Jira server (`mock/mock_jira.py`, committed alongside these
recordings) — **not** a live Jira instance (per project policy: never run
state-changing commands against live Jira). `JR_BASE_URL` / `JR_AUTH_HEADER`
are the project's documented debug-only test seams (see `CLAUDE.md` "AI Agent
Notes"); every recording also isolates `JR_CONFIG_DIR`/`JR_CACHE_DIR` to a temp
directory so nothing touches a real profile or cache. 62/62 tests in
`tests/issue_create_field.rs` pass on this branch as of this recording.

## Coverage summary

| AC | Demonstrated via | Evidence |
|----|-------------------|----------|
| AC-001 | Live demo | `AC-001-malformed-field-hint.{gif,webm}` |
| AC-002 | Live demo (success + error pair) | `AC-002-005-006-013-field-resolves-success.{gif,webm}`, `AC-002-error-field-not-on-create-screen.{gif,webm}` |
| AC-003 | Live demo | `AC-003-004-on-behalf-of-guards.{gif,webm}` |
| AC-004 | Live demo | `AC-003-004-on-behalf-of-guards.{gif,webm}` |
| AC-005 | Live demo (partial — bypass form) + test citation (cache-first name path) | `AC-002-005-006-013-field-resolves-success.{gif,webm}` (customfield_NNNNN bypass); `AC-001-malformed-field-hint.{gif,webm}` and `AC-002-error-field-not-on-create-screen.{gif,webm}` (cache-first NAME resolution, both success and failure). Full unit coverage: `tests/issue_create_field.rs::test_bc_3_3_010_customfield_bypass_on_create`, `::test_bc_3_3_010_cache_first_field_name_resolution` |
| AC-006 | Live demo | `AC-002-005-006-013-field-resolves-success.{gif,webm}` (`--verbose` shows both createmeta GETs). Page-2 pagination edge case: test citation — `tests/issue_create_field.rs::test_bc_3_3_010_source_substitution_createmeta_not_editmeta`, `::test_vp_578_020a_field_on_createmeta_page_2_resolves` |
| AC-007 | Test citation (needs a large multi-page issuetypes fixture, impractical to hand-author against a live-shaped mock) | `tests/issue_create_field.rs::test_vp_578_020b_type_on_issuetypes_page_2_resolves` |
| AC-008 | Live demo (`:id` hint kind) + test citation (full hint-kind matrix) | `AC-001-malformed-field-hint.{gif,webm}` (second invocation, `:id` kind). Full matrix: `tests/issue_create_field.rs::test_bc_3_3_010_type_dispatch_shares_resolve_edit_fields_createmeta_source`, `::test_bc_3_3_010_hint_kinds_available_on_platform_create` |
| AC-009 | Test citation (requires Assets/CMDB workspace-discovery endpoints outside this demo's mock scope) | `tests/issue_create_field.rs::test_bc_3_4_030_create_path_asset_cold_cache_403_404_assets_unavailable`, `::test_bc_3_4_030_create_path_asset_cold_cache_empty_workspace`, `::test_bc_3_4_030_create_path_asset_cold_cache_401_standard_auth_mapping`, `::test_bc_3_4_030_create_path_asset_cold_cache_5xx_network_standard_mapping` |
| AC-010 | Test citation | `tests/issue_create_field.rs::test_vp_578_003_all_or_nothing_multi_field_failure` |
| AC-011 | Live demo (1 of 10 governed keys; zero-HTTP proof via `--verbose`) + test citation (full 10-member matrix) | `AC-011-d2-collision-guard.{gif,webm}`. Full matrix: `tests/issue_create_field.rs::test_vp_578_021_create_path_collision_5_original_static_keys`, `::test_vp_578_021_create_path_collision_labels_parent_assignee`, `::test_vp_578_021_create_path_collision_points_resolved_id`, `::test_vp_578_021_create_path_collision_team_resolved_id_configured`, `::test_vp_578_021_negative_pin_display_name_spelling_does_not_trip_guard` |
| AC-012 | Test citation (10-row table-driven test) | `tests/issue_create_field.rs::test_bc_3_3_011_error_taxonomy_all_10_rows` |
| AC-013 | Live demo | `AC-002-005-006-013-field-resolves-success.{gif,webm}` (echo line `customfield_10050 → VENDOR-REF-99` alongside `issue_type`/`summary`, alphabetically interleaved) |
| AC-014 | Test citation (JSON-mode assertion, not a visual difference to demo) | `tests/issue_create_field.rs::test_bc_3_4_014_json_mode_unchanged_no_changed_fields_key` |
| AC-015 | Live demo | `AC-002-005-006-013-field-resolves-success.{gif,webm}` (`--verbose` shows createmeta GETs firing only after project/type are already known, before the POST) |
| AC-016 | Live demo | `AC-016-help-text-reversal.{gif,webm}` |
| AC-017 | Not a `tests/` deliverable per the story itself ("manual verification... the actual rewrite... is a doc-fallout deliverable of this story's PR, not a `tests/` assertion") | N/A — out of Demo Recorder scope; verify against `.factory/specs/prd/holdout-scenarios.md` directly |
| AC-018 | Test citation | `tests/issue_create_field.rs::test_ec_3_8_012_5_markdown_field_description_no_longer_guarded` |
| AC-019 | No new test required per the story itself (regression non-change) | N/A |

## Recordings

### AC-016-help-text-reversal.{gif,webm}
No backend. `jr issue create --help | grep -E -- '--field|--on-behalf-of'` shows
`--field`'s help text now reads "...resolves against the project's Create screen
(createmeta); with --request-type set, resolves against the JSM request type's
fields" — no "requires --request-type" — while `--on-behalf-of`'s help text is
unchanged ("...JSM only; requires --request-type").

### AC-002-005-006-013-field-resolves-success.{gif,webm}
`jr issue create --project DEMO --type Task --summary 'New feature request'
--field customfield_10050=VENDOR-REF-99 --no-input --verbose` against the local
mock. `--verbose` (with `RUST_LOG=jr=debug` to scope out hyper/reqwest noise)
shows, in order: `GET .../createmeta/DEMO/issuetypes` (issue-type name→id,
S-331), `GET .../createmeta/DEMO/issuetypes/10001` (createmeta fields, S-580-1),
`POST .../issue` (the actual create). Exits 0 with `Created issue DEMO-42` and
the resolved field echoed (`customfield_10050 → VENDOR-REF-99`) interleaved
alphabetically with `issue_type`/`summary` — this invocation shape used to exit
64 under DEC-188 with `--field is only valid with --request-type`; that string
does not appear anywhere in this output.

### AC-002-error-field-not-on-create-screen.{gif,webm}
Same shape, but `--field 'Vendor Portal ID=XYZ'` where the mock's global field
list (`GET /rest/api/3/field`) knows the field by name but its createmeta
response omits it from the Create screen. Result: `Error: Field 'Vendor Portal
ID' (customfield_10099) is not on the Create screen for project 'DEMO' issue
type 'Task'. ...` — exit 64. Confirms the DEC-188 reversal cuts both ways: a
failing `--field` now fails with a specific, resolution-sourced error, never the
old removed guard string.

### AC-011-d2-collision-guard.{gif,webm}
`jr issue create --project DEMO --type Task --summary 'My Summary' --field
summary=Other --no-input --verbose` → `Error: summary is set by both --summary
and --field; use only one.`, exit 64. With `--verbose` on, zero `[verbose] GET`
or `[verbose] POST` lines appear anywhere in the output — visual, checkable
proof this fires before any HTTP call (project/type resolution, createmeta
lookups, and the POST are all skipped).

### AC-001-malformed-field-hint.{gif,webm}
Two invocations against a mock configured with an `Environment` option field
(`customfield_10060`, allowedValues Production/Staging): (1) `--field
'Environment:badkind=Production'` → `Error: Invalid --field value
'Environment:badkind=Production': unknown field-value kind 'badkind' — valid
kinds are: option, id, name, asset`, exit 64, fired at step 2a before project/
type resolution; (2) `--field 'Environment:id=20001'` → exits 0, `Created issue
DEMO-42` with `Environment → 20001` echoed — the `:id` hint kind's raw-id-
literal echo convention, doubling as AC-008 hint-kind-dispatch evidence.

### AC-003-004-on-behalf-of-guards.{gif,webm}
Two invocations: (1) `--on-behalf-of 712020:abc123` alone → exit 64 with
BC-3.8.013's verbatim guard string; (2) the same `--on-behalf-of` plus `--field
customfield_10050=X` together → the IDENTICAL error string, exit 64 — proving
`--field`'s presence no longer contributes to, alters, or pre-empts this error
(the old DEC-188 combined-check that used to fire a different, combined error
is gone; only BC-3.8.013's unchanged standalone guard remains, now firing in
both shapes).

## Reproducing these recordings

Each `.tape` file in this directory is self-contained and re-runnable from a
fresh checkout of this branch:

```bash
cd .factory/demos/S-578-4
vhs AC-016-help-text-reversal.tape
vhs AC-002-005-006-013-field-resolves-success.tape
vhs AC-002-error-field-not-on-create-screen.tape
vhs AC-011-d2-collision-guard.tape
vhs AC-001-malformed-field-hint.tape
vhs AC-003-004-on-behalf-of-guards.tape
```

Each backend-dependent tape starts its own instance of `mock/mock_jira.py` on a
dedicated loopback port (18571–18575) and polls it with `curl` until ready
before typing the demonstrated `jr` command — no fixed sleep races against
server startup. `mock/mock_jira.py` is a minimal, story-scoped stand-in for
three Jira endpoints (`createmeta/{proj}/issuetypes`, `createmeta/{proj}/
issuetypes/{id}`, `POST /issue`, plus `GET /field` for cache-first name
resolution) — it is not a general-purpose Jira mock and should not be reused
outside this story's demo recordings.
