# Demo Evidence — S-578-1: `--field NAME:kind=VALUE` Hint-Syntax Parser

Story: `S-578-1` — `--field NAME:kind=VALUE` hint-syntax parser (`FieldValueSpec`/`FieldValueKind`,
`parse_field_kv` extension). BCs: BC-3.4.026, BC-3.4.031.

## Scope note (why most evidence is tests, not recordings)

S-578-1 delivers the **parser** (`parse_field_kv` → `HashMap<String, FieldValueSpec>`) plus an
**interim guard** (`reject_unsupported_hint_kinds`) wired into the two existing `--field` call
sites (`issue edit`, JSM `issue create`). Real `:kind` wire dispatch is deferred to S-578-2/3/4.
Per CLAUDE.md TDD conventions the parser itself is pure and exhaustively covered by unit +
proptest; it has no CLI-visible surface of its own. The only CLI-visible behavior added by this
story is the interim guard's exit-64 rejection (and its converse: bare `NAME=VALUE` continuing to
work unaffected). Recordings below cover exactly that CLI-visible surface; everything internal to
the parser is covered by named passing tests, cited per AC.

## Recordings (CLI-visible surface)

All three recordings run the actual worktree debug binary (`cargo build`, `target/debug/jr`) via
VHS terminal recording. No live Jira instance was used or required to reach exit 64.

| Recording | Command demonstrated | Result |
|---|---|---|
| `AC-006-edit-hinted-field-rejected.{gif,webm}` | `jr issue edit SOME-1 --field cf:id=10042 --no-input` | exit 64, guard message, **no HTTP call** (guard fires before any network access — confirmed via a fake `JR_BASE_URL`-less config; no server needed) |
| `AC-006-jsm-create-hinted-field-rejected.{gif,webm}` | `jr issue create --project DEMO --request-type 'Get IT Help' --summary Demo --field cf:id=10042 --no-input` | exit 64, guard message, **after** service-desk/request-type discovery GETs succeed against a local mock server (`mock_jsm_server.py`) and **before** any POST — the mock intentionally implements no request-creation endpoint, so if the guard failed to fire the recording would show a 501 from the mock instead |
| `AC-004-bare-field-not-rejected.{gif,webm}` | `jr issue edit SOME-1 --field cf=10042 --no-input` | exit 1 (network error against a fake host) — **no "not yet supported" message appears**, proving the bare (unhinted) form is not affected by the guard and proceeds past it to the HTTP stage |

Supporting files in this directory:
- `*.tape` — VHS scripts (source of truth for each recording; re-run with `vhs <file>.tape` from
  the worktree root to reproduce)
- `setup-edit.sh` — shared hidden setup (fake profile config + auth header + `PATH`) used by the
  edit-path recordings; sourced inside each tape's `Hide` block
- `fixtures/config.toml` — the fake `jr` profile config used by `setup-edit.sh`
- `mock_jsm_server.py` — minimal GET-only Jira/JSM mock (project meta, service-desk list,
  request-type list) used only by the JSM create recording, so `require_service_desk` can succeed
  without a real Jira instance; it deliberately serves no mutating endpoint

### Why the JSM create demo needed a mock server (and the edit demo did not)

`issue edit`'s `--field` guard (`reject_unsupported_hint_kinds`) is called immediately after
`parse_field_kv`, before any HTTP call (`src/cli/issue/edit.rs`) — a fake, unreachable profile
URL is sufficient to demonstrate it, since the guard never gets far enough to dial out.
`issue create --request-type`'s JSM path resolves the service desk (`require_service_desk`, an
HTTP GET) **before** reaching the same guard (`src/cli/issue/jsm_create.rs`) — so a real GET
response was needed to get past that resolution step and actually observe the guard firing,
rather than observing an earlier, unrelated network failure. The task brief anticipated this
("if it needs config/auth that isn't present, capture whatever error stage is reachable and note
it") — a lightweight local mock was used instead so the guard itself could be shown firing, which
is the more informative demonstration.

## AC → Evidence mapping

| AC | Summary | Evidence |
|---|---|---|
| AC-001 | `parse_field_kv` return type → `HashMap<String, FieldValueSpec>` | Test: `test_bc_3_4_026_parse_field_kv_returns_field_value_spec_map` (`src/cli/issue/create.rs::field_value_kind_tests`) — PASS |
| AC-002 | Parse rule: first `=` then last `:` before `=` | Tests: `test_bc_3_4_026_first_equals_then_last_colon_split`, `test_bc_3_4_026_multi_colon_name_isolates_kind_from_last_colon` (same module) — PASS |
| AC-003 | Multibyte-safety (Unicode-scalar-safe splitting, no panic) | Test: `prop_field_hint_split_no_panic` (`src/cli/issue/create.rs::parse_field_kv_proptests`, proptest, VP-578-005) — PASS. Also `test_field_hint_multibyte_kind_and_value_no_panic` (unit) — PASS |
| AC-004 | Map key is always the bare field name, never composite | Test: `test_bc_3_4_026_last_wins_across_kinds_single_map_entry` (VP-578-006) — PASS. **Also demonstrated live**: `AC-004-bare-field-not-rejected.{gif,webm}` shows a bare `--field cf=10042` pair passing through unaffected by the guard (no "not yet supported" message; fails only at the network stage) |
| AC-005 | All three call sites consume the same `HashMap<String, FieldValueSpec>` shape | N/A per story spec ("this story's own tests assert only `parse_field_kv`'s own contract in isolation"). Indirect confirmation: the interim guard (`reject_unsupported_hint_kinds`) is wired into both existing call sites (`edit.rs`, `jsm_create.rs`) against the identical `FieldValueSpec` type, and both call sites compile + their own integration tests pass (see AC-006 below and `cargo test --test issue_edit_field`, `cargo test --test issue_create_jsm`, both green) |
| AC-006 | EC-1: unknown kind → exit 64, lists 4 valid kinds | Test: `test_bc_3_4_031_ec1_unknown_kind_exits_64` — PASS. **Also demonstrated live** via the interim-guard recordings: `AC-006-edit-hinted-field-rejected.{gif,webm}` and `AC-006-jsm-create-hinted-field-rejected.{gif,webm}` (both show the "field-value kind hints (:option/:id/:name/:asset) are not yet supported on this command" exit-64 message; the guard subsumes any `Some(kind)`, exercised here with the valid kind `id` rather than an invalid one, since the story's own guard fires on any hint regardless of validity) |
| AC-007 | EC-5: empty `:kind` segment treated as EC-1 | Test: `test_bc_3_4_031_ec5_empty_kind_segment_treated_as_unknown_kind` — PASS |
| AC-008 | EC-6/EC-7 regression pins (colon-in-VALUE / multi-colon-NAME) | Tests: `test_bc_3_4_031_ec6_colon_in_value_resolves_normally`, `test_bc_3_4_031_ec7_multi_colon_name_fires_unknown_kind_not_other_error` — PASS |
| AC-009 | EC-8/EC-9: empty `:id`/`:name` value passes through | Tests: `test_bc_3_4_031_ec8_empty_id_value_passes_through_parser`, `test_bc_3_4_031_ec9_empty_name_value_passes_through_parser` — PASS |
| AC-010 | Kind validation is case-sensitive, lowercase-only | Test: `test_bc_3_4_026_kind_validation_case_sensitive_lowercase_only` — PASS |

### Interim guard (this story's actual CLI-visible delivery — beyond the 10 parser ACs)

| Guard behavior | Evidence |
|---|---|
| `issue edit --field NAME:kind=VALUE` rejected, exit 64, before any HTTP call | Recording: `AC-006-edit-hinted-field-rejected.{gif,webm}`. Test: `test_edit_field_kind_hint_exits_64_pending_dispatch_s578_1` (`tests/issue_edit_field.rs`) — PASS |
| JSM `issue create --field NAME:kind=VALUE` rejected, exit 64, after service-desk/request-type discovery, before POST | Recording: `AC-006-jsm-create-hinted-field-rejected.{gif,webm}`. Test: `test_jsm_create_field_kind_hint_exits_64_pending_dispatch_s578_1` (`tests/issue_create_jsm.rs`) — PASS |
| Bare `--field NAME=VALUE` unaffected by the guard on both call sites | Recording: `AC-004-bare-field-not-rejected.{gif,webm}` (edit path). Test: `test_jsm_create_field_bare_pair_unaffected_by_kind_hint_guard_s578_1` (`tests/issue_create_jsm.rs`) — PASS |

## Test run confirmation

```
$ cargo test --lib field_value_kind_tests
running 15 tests
test result: ok. 15 passed; 0 failed; 0 ignored; 0 measured; 1153 filtered out

$ cargo test --lib parse_field_kv_proptests
running 7 tests
test result: ok. 7 passed; 0 failed; 0 ignored; 0 measured; 1161 filtered out

$ cargo test --test issue_edit_field test_edit_field_kind_hint_exits_64_pending_dispatch_s578_1
running 1 test
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 89 filtered out

$ cargo test --test issue_create_jsm test_jsm_create_field
running 5 tests
test test_jsm_create_field_kind_hint_exits_64_pending_dispatch_s578_1 ... ok
test test_jsm_create_field_missing_equals_exits_64 ... ok
test test_jsm_create_field_first_equals_split_and_duplicate_last_wins ... ok
test test_jsm_create_field_bare_pair_unaffected_by_kind_hint_guard_s578_1 ... ok
test test_jsm_create_field_summary_overrides_summary_flag ... ok
test result: ok. 5 passed; 0 failed; 0 ignored; 0 measured; 82 filtered out
```

## Coverage confirmation

All 10 story ACs have at least one evidence reference (a named passing test, a recorded demo, or
both). No AC is left without evidence.
