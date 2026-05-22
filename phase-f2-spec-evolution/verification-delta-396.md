---
document_type: verification-delta
issue: "#396"
title: "Verification properties for issue edit --field NAME=VALUE"
date: "2026-05-22"
phase: F2
new_vps:
  - VP-396-001
  - VP-396-002
  - VP-396-003
  - VP-396-004
  - VP-396-005
  - VP-396-006
  - VP-396-007
  - VP-396-008
  - VP-396-009
  - VP-396-010
  - VP-396-011
  - VP-396-012
related_bcs:
  - BC-3.4.015
  - BC-3.4.016
  - BC-3.4.017
---

# Verification Delta — Issue #396: `--field` Verification Properties

## New Verification Properties

### VP-396-001: String/number `--field` value appears in `changed_fields` echo (table and JSON)

**Description**: When `jr issue edit KEY --field CUSTOMFIELD=VALUE` succeeds with a
string or number field type, the field name and resolved value must appear in the
`changed_fields` output on both the table-mode (stderr) and JSON-mode (stdout)
success paths. The key in `changed_fields` is the human field name (or the
`customfield_NNNNN` literal for bypass invocations), never the raw field id.

**Applies to**:
- BC-3.4.015: string/number `--field` on `issue edit` single-key success path
- BC-3.4.012 (via shared `changed_fields` BTreeMap — new `--field` entries appear
  alongside existing flag entries in alphabetical field-name order)
- BC-3.4.013 (via shared `changed_fields` BTreeMap — JSON mode)

**Test strategy**:

1. Mock `GET /rest/api/3/field` returning a field with `id: "customfield_10001"` and
   `name: "Severity"`. Mock `GET /rest/api/3/issue/KEY/editmeta` returning that field
   with `schema.type: "string"`. Mock `PUT /rest/api/3/issue/KEY` returning 204.
2. Run `jr issue edit KEY --field Severity=Critical` in table mode.
3. Assert stderr contains `  Severity → Critical` (two leading spaces, unicode arrow).
4. Assert exit code 0.
5. Run the same command with `--output json`.
6. Parse JSON. Assert `changed_fields["Severity"] == "Critical"`.
7. Assert `changed_fields` does NOT contain a key `"customfield_10001"` (human name
   used as key, not the internal ID).

**`customfield_NNNNN` literal bypass sub-case**:

1. Run `jr issue edit KEY --field customfield_10001=Critical` (literal ID, no name
   lookup). Mock `GET /rest/api/3/issue/KEY/editmeta` returning `customfield_10001`
   with `schema.type: "string"`. Mock PUT 204.
2. `list_fields()` mock MUST NOT be mounted — confirm it is NOT called (the bypass
   skips Step 2 of the resolution algorithm).
3. Assert `changed_fields["customfield_10001"] == "Critical"` (literal ID used as key
   when name lookup is bypassed).

**Suggested test names**:
- `test_BC_3_4_015_field_string_value_appears_in_table_echo`
- `test_BC_3_4_015_field_string_value_appears_in_json_changed_fields`
- `test_BC_3_4_015_customfield_literal_bypass_skips_list_fields`

---

### VP-396-002: Single-select `option` field resolves value to option id on wire; echo shows human label

**Description**: When `--field NAME=VALUE` targets an `option`-type field, the wire
payload to Jira must use `{"id": "<optionId>"}`, but the `changed_fields` entry (both
table-mode echo and JSON) must show the human-readable option label (not the id). This
tests the round-trip: human value in → id on wire → human label in echo.

**Applies to**:
- BC-3.4.016: single-select `--field` on `issue edit` single-key success path
- BC-3.4.012, BC-3.4.013 (shared `changed_fields` BTreeMap)

**Test strategy**:

1. Mock `GET /rest/api/3/field` returning `id: "customfield_10176"`, `name: "Urgency"`.
2. Mock `GET /rest/api/3/issue/KEY/editmeta` returning `customfield_10176` with
   `schema.type: "option"` and `allowedValues: [{"id": "10286", "value": "High"},
   {"id": "10287", "value": "Medium"}, {"id": "10288", "value": "Low"}]`.
3. Mock `PUT /rest/api/3/issue/KEY` — mount with body match requiring the exact
   wire payload `{"fields": {"customfield_10176": {"id": "10286"}}}`.
4. Run `jr issue edit KEY --field Urgency=High --output json`.
5. Assert exit code 0.
6. Parse JSON. Assert `changed_fields["Urgency"] == "High"` (human label, NOT `"10286"`).
7. Assert the PUT mock was matched (confirming `{"id": "10286"}` was on the wire).

**Case-insensitive option resolution sub-case**:

1. Same setup. Run `jr issue edit KEY --field Urgency=high` (lowercase).
2. Assert `changed_fields["Urgency"] == "High"` (stored-casing from `allowedValues`,
   not the user's query casing).
3. Assert PUT body contains `{"id": "10286"}`.

**Option id bypass sub-case**:

1. Run `jr issue edit KEY --field Urgency=10286` (numeric id literal).
2. Assert PUT body contains `{"id": "10286"}`.
3. Assert `changed_fields["Urgency"] == "10286"` (the literal value is echoed as-is
   when the id-bypass path fires — no reverse lookup to the label).

Note: for the id-bypass case, the echo shows the raw `VALUE` rather than the matched
label because no `allowedValues[].value` lookup occurred. This is the same pattern as
the `customfield_NNNNN` bypass not resolving to a human name.

**Suggested test names**:
- `test_BC_3_4_016_option_field_resolves_to_id_on_wire_and_label_in_echo`
- `test_BC_3_4_016_option_field_case_insensitive_resolution`
- `test_BC_3_4_016_option_field_id_bypass`

---

### VP-396-003: Field absent from `editmeta` → exit 64 with Edit-screen actionable hint

**Description**: When a requested field is not on the issue's Edit screen (absent from
`editmeta.fields`), the error message must be actionable — it must tell the user to
ask a project admin to add the field to the Edit screen. This is the most common
real-world failure for JSM fields (Urgency/Impact are not on the agent Edit screen by
default).

**Applies to**:
- BC-3.4.015: EC-3.4.015-3 (field absent from editmeta)
- BC-3.4.015: EC-3.4.015-8 (`customfield_NNNNN` literal also absent from editmeta)

**Test strategy**:

1. Mock `GET /rest/api/3/field` returning a field with `id: "customfield_20001"`,
   `name: "MyField"`.
2. Mock `GET /rest/api/3/issue/KEY/editmeta` returning a response that does NOT contain
   `customfield_20001`.
3. Mount NO `PUT` mock (the PUT must NOT be called).
4. Run `jr issue edit KEY --field MyField=SomeValue`.
5. Assert exit code 64.
6. Assert stderr contains a substring referencing the Edit screen (e.g., "Edit screen")
   and an admin action ("admin" or "project admin").
7. Assert PUT mock was NOT called.

**`customfield_NNNNN` literal sub-case**:

1. Same setup. Run `jr issue edit KEY --field customfield_20001=SomeValue`.
2. Assert exit code 64. Assert stderr references the Edit screen. Assert PUT not called.
3. Assert `list_fields()` was NOT called (literal bypass: no `GET /rest/api/3/field` mock needed).

**Suggested test names**:
- `test_BC_3_4_015_field_absent_from_editmeta_exits_64_with_hint`
- `test_BC_3_4_015_customfield_literal_absent_from_editmeta_exits_64`

---

### VP-396-004: Unsupported field types (`array`, `any`) → exit 64 with hint

**Description**: When `editmeta` reports a field type not supported in v1 (`array`,
`any`, or any unknown type string), `jr` must exit 64 with a message that names the
unsupported type and tells the user what to do (e.g., use the Jira UI, or open an
issue for v2 support). No PUT must be issued.

**Applies to**:
- BC-3.4.015: EC-3.4.015-5 (unsupported schema type)

**Test strategy**:

1. Mock `GET /rest/api/3/field` returning `id: "customfield_30001"`, `name: "Labels"`.
2. Mock `GET /rest/api/3/issue/KEY/editmeta` returning `customfield_30001` with
   `schema.type: "array"`.
3. Mount NO `PUT` mock.
4. Run `jr issue edit KEY --field Labels=bug`.
5. Assert exit code 64.
6. Assert stderr mentions the unsupported type (e.g., `"array"`) and provides an
   actionable hint.
7. Assert PUT not called.

**`any` type sub-case**:

1. Repeat with `schema.type: "any"`.
2. Assert exit code 64. Assert hint. Assert PUT not called.

**Suggested test names**:
- `test_BC_3_4_015_array_type_field_exits_64_with_hint`
- `test_BC_3_4_015_any_type_field_exits_64_with_hint`

---

### VP-396-005: `--field` rejection guards — multi-key, `--jql` multi-issue, and flag overlap

**Description**: Three enforcement gates must fire before any HTTP call. This VP
validates all three gates in BC-3.4.017.

**Applies to**:
- BC-3.4.017: Gate A (multi-key/`--jql` multi-issue rejection)
- BC-3.4.017: Gate B (flag-overlap hard error)

**Test strategy (Gate A — multi-key rejection)**:

1. Mount NO mocks (no HTTP should occur).
2. Run `jr issue edit KEY1 KEY2 --field Urgency=High`.
3. Assert exit code 64.
4. Assert stderr references `--field` and the bulk-rejection pattern ("doesn't yet
   support: --field" or equivalent).
5. Assert no HTTP was issued (no `list_fields()`, no `editmeta`, no PUT).

**Test strategy (Gate A — `--jql` resolving to 2+ issues)**:

1. Mock JQL search returning 2 issue keys.
2. Mount NO `editmeta` mock, NO `PUT` mock.
3. Run `jr issue edit --jql "project = FOO" --field Urgency=High`.
4. Assert exit code 64. Assert no PUT issued.

**Test strategy (Gate B — flag overlap: summary)**:

1. Mount NO mocks.
2. Run `jr issue edit KEY --summary "New title" --field summary=Other title`.
3. Assert exit code 64.
4. Assert stderr contains a substring referencing the conflict (e.g., "set by both"
   or `"--summary"` and `"--field"`).
5. Assert no HTTP was issued.

**Test strategy (Gate B — flag overlap: description)**:

1. Mount NO mocks.
2. Run `jr issue edit KEY --description "text" --field description=other`.
3. Assert exit code 64. Assert conflict message. Assert no HTTP.

**Test strategy (Gate B — flag overlap: issuetype / --type)**:

1. Mount NO mocks.
2. Run `jr issue edit KEY --type Bug --field issuetype=Task`.
3. Assert exit code 64. Assert conflict message. Assert no HTTP.

**Note on Gate B scope**: The overlap guard does NOT cover `--team` or `--points` (those
use dynamically-resolved custom field IDs; the guard cannot be applied without an API
call, which would violate the "no HTTP before the guard" invariant). Only `summary`,
`description`, `issuetype`, and `priority` are in scope for v1.

**Suggested test names**:
- `test_BC_3_4_017_field_multi_key_rejected_exit_64`
- `test_BC_3_4_017_field_jql_multi_issue_rejected_exit_64`
- `test_BC_3_4_017_field_summary_overlap_exits_64_no_http`
- `test_BC_3_4_017_field_description_overlap_exits_64_no_http`
- `test_BC_3_4_017_field_issuetype_overlap_exits_64_no_http`

---

### VP-396-006: Warm `fields.json` cache prevents `GET /rest/api/3/field` HTTP call

**Description**: When a non-stale `fields.json` cache exists for the active profile,
the `resolve_edit_fields` function must NOT issue `GET /rest/api/3/field`. Field-name
resolution and the subsequent PUT must still succeed. This proves the cache is
correctly read and used before the API fallback, reducing latency for repeated
`--field` invocations within the 7-day TTL window.

**Applies to**:
- BC-3.4.015: EC-3.4.015-14 (cache hit path)
- BC-3.4.016: inherits the same cache-first behavior for field-name resolution

**Test strategy**:

1. Pre-populate `~/.cache/jr/v1/<test_profile>/fields.json` (or the test-equivalent
   cache path) with a serialized `FieldsCache` entry containing
   `fields: [("customfield_10001", "Severity")]` and `fetched_at` set to the current
   time (definitely within the 7-day TTL window).
2. Mount `GET /rest/api/3/field` as a **NOT-EXPECTED** mock (wiremock: mount with zero
   expected calls, or simply verify the stub is never hit after the test).
3. Mount `GET /rest/api/3/issue/KEY/editmeta` returning `customfield_10001` with
   `schema.type: "string"`. Mount `PUT /rest/api/3/issue/KEY` returning 204.
4. Run `jr issue edit KEY --field Severity=Critical`.
5. Assert exit code 0.
6. Assert `GET /rest/api/3/field` was NOT called (the pre-populated cache was used).
7. Assert PUT was called with `{"fields": {"customfield_10001": "Critical"}}`.
8. Assert stderr (table mode) contains `  Severity → Critical`.

**Implementation note for test authors**: the cache path in integration tests is
controlled by the test's `XDG_CACHE_HOME` override (consistent with how other cache
tests isolate their state via `tempdir()`). Pre-populate the `fields.json` file in
the temp dir before invoking the handler.

**Cache-write verification sub-case** (EC-3.4.015-15, cold cache):

1. Do NOT pre-populate `fields.json`.
2. Mount `GET /rest/api/3/field` returning a list with `customfield_10001 / Severity`.
   Mount `editmeta` and PUT as above.
3. Run `jr issue edit KEY --field Severity=Critical`.
4. Assert exit code 0. Assert `GET /rest/api/3/field` was called EXACTLY ONCE.
5. Assert `fields.json` now exists in the cache path with a `fetched_at` timestamp
   within the last few seconds (confirming the cache was written after the fetch).
6. Run the same command again without clearing the cache.
7. Assert exit code 0. Assert `GET /rest/api/3/field` was NOT called on the second
   run (cache hit after first-run write).

**Suggested test names**:
- `test_BC_3_4_015_warm_fields_cache_skips_field_list_http`
- `test_BC_3_4_015_cold_cache_fetches_and_populates_fields_cache`

---

### VP-396-007: Cache-write failure is swallowed; resolution and PUT succeed

**Description**: When `write_fields_cache` encounters a disk I/O error (e.g., disk
full, permission denied), the best-effort writer must emit a `warning:` line to
stderr and return `Ok(())`. The `resolve_edit_fields` call must proceed with the
fetched field list and complete successfully — the cache-write failure must NOT
propagate as an error or affect the exit code.

**Applies to**:
- BC-3.4.015: EC-3.4.015-16 (cache-write failure)
- BC-3.4.015: invariant 7 (best-effort writer)

**Test strategy**:

1. Do NOT pre-populate `fields.json`. Mount `GET /rest/api/3/field` returning a field
   `id: "customfield_10001"`, `name: "Severity"`. Mount `editmeta` returning `customfield_10001`
   with `schema.type: "string"`. Mount PUT returning 204.
2. Make the cache path unwritable (e.g., `chmod 000` on the test cache directory, or
   inject a mock `write_fields_cache` that returns `Err(io::Error::new(PermissionDenied))`).
3. Run `jr issue edit KEY --field Severity=Critical`.
4. Assert exit code 0.
5. Assert stderr contains `"warning: failed to write fields cache"`.
6. Assert PUT was called with `{"fields": {"customfield_10001": "Critical"}}`.
7. Assert `changed_fields["Severity"] == "Critical"` in JSON mode.
8. Assert `fields.json` does NOT exist (or is still unwritable — the write failure
   did not create a partial file).

**`--output json` stdout-unpolluted assertion** (P2-007):

Run the same cache-write-failure scenario with `--output json` to pin profile-4
channel separation:

1. Same setup (unwritable cache path, `GET /rest/api/3/field` returning the field list,
   `editmeta` and PUT 204 mocked).
2. Run `jr issue edit KEY --field Severity=Critical --output json`.
3. Assert exit code 0.
4. Assert stdout is valid JSON and does NOT contain the substring `"warning"` — the
   `warning:` line is on stderr only; it must never appear on stdout.
5. Assert stderr contains `"warning: failed to write fields cache"`.

This pins the output-channel separation invariant: best-effort writer warnings go to
stderr regardless of `--output` mode. Stdout remains the clean structured-data channel.

**Implementation note**: The cleanest test approach is a unit test that calls
`write_fields_cache` with a path in a non-existent directory or a path where the
parent is read-only. The integration-test approach requires injecting a failing
cache writer or making the cache directory read-only before invoking the binary.

**Suggested test names**:
- `test_BC_3_4_015_cache_write_failure_warns_and_exits_0`
- `test_BC_3_4_015_cache_write_failure_warning_on_stderr_not_stdout`
- `test_write_fields_cache_swallows_io_error_and_returns_ok`

---

### VP-396-008: `--field` + `--dry-run` — exit 0 on success; read-only HTTP runs; resolution failure exits 64

**Description**: The existing `--dry-run` path in `handle_edit` emits a planned-changes
preview (exit 0) without issuing the PUT. When `--field NAME=VALUE` is combined with
`--dry-run`, the gate checks (Gate A, Gate B) still fire before any HTTP. If the gates
pass, the read-only calls (`list_fields()` / cache + `editmeta`) execute so the preview
can include the resolved `--field` entries. The PUT is NOT issued. Critically, resolution
failures (zero-match, ambiguous, unsupported type, editmeta-absent, operations missing
"set") still exit 64 under `--dry-run` — the dry-run flag does not suppress errors.

Exit code source: `src/cli/issue/create.rs:707` — `return Ok(());` at the end of the
dry-run block (confirmed — this is exit 0).

**Applies to**:
- BC-3.4.015: EC-3.4.015-18 (`--dry-run` × `--field`, success path, exit 0)
- BC-3.4.015: EC-3.4.015-19 (resolution failure under `--dry-run`, exit 64)
- BC-3.4.017: `--dry-run` behavior under gate conditions
- BC-3.4.012: EC-3.4.012-9 (existing `--dry-run` behaviour)

**Test strategy (success path)**:

1. Mock `GET /rest/api/3/field` returning `id: "customfield_10001"`, `name: "Severity"`.
2. Mock `GET /rest/api/3/issue/KEY/editmeta` returning `customfield_10001` with
   `schema.type: "string"` and `operations: ["set"]`.
3. Mount NO `PUT` mock (PUT must NOT be called).
4. Run `jr issue edit KEY --field Severity=Critical --dry-run`.
5. Assert exit code **0** (pinned — `Ok(())` from the dry-run block).
6. Assert PUT mock was NOT called.
7. Assert the planned-changes preview includes `Severity → Critical`.

**Gate still fires under `--dry-run` sub-case**:

1. Mount NO mocks.
2. Run `jr issue edit KEY1 KEY2 --field Urgency=High --dry-run`.
3. Assert exit code 64 (Gate A fires before any HTTP).
4. Assert no HTTP calls were made.

**Resolution failure under `--dry-run` sub-case** (EC-3.4.015-19):

1. Mock `GET /rest/api/3/field` returning a field list that does NOT include `"UnknownField"`.
2. Mock `editmeta` — may or may not be called depending on where resolution fails.
3. Mount NO `PUT` mock.
4. Run `jr issue edit KEY --field UnknownField=Value --dry-run`.
5. Assert exit code **64** (resolution error, not suppressed by `--dry-run`).
6. Assert stderr contains a message about the unknown field.
7. Assert no planned-changes preview is emitted to stdout.

**Suggested test names**:
- `test_BC_3_4_015_field_dry_run_exits_0_no_put`
- `test_BC_3_4_015_field_dry_run_resolution_failure_exits_64`
- `test_BC_3_4_017_gate_a_fires_under_dry_run`

---

### VP-396-009: Multi-`--field` partial-failure and PUT-failure discard `changed_fields`

**Description**: `resolve_edit_fields` is all-or-nothing: if any `--field` pair fails
resolution, no PUT is attempted and `changed_fields` is never emitted. Additionally,
if a valid `--field` triggers a PUT that returns a non-204 status, the server error
surfaces normally and `changed_fields` is discarded (not echoed).

**Applies to**:
- BC-3.4.015: EC-3.4.015-12 (partial-failure: any `--field` pair fails, zero PUT)
- BC-3.4.015: EC-3.4.015-12a (valid `--field`, PUT returns non-204 → no echo)
- BC-3.4.015: invariant 4 (map emitted only post-204)

**Test strategy (partial-failure sub-case)**:

1. Mock `GET /rest/api/3/field` returning `customfield_10001 / A_OK` (one valid field).
2. Mock `editmeta` returning `customfield_10001`. Mount NO PUT.
3. Run `jr issue edit KEY --field A_OK=val --field UnknownField=val`.
4. Assert exit code 64 (zero-match for `UnknownField`).
5. Assert PUT mock was NOT called.
6. Assert stderr contains NO `→` echo lines (changed_fields not emitted).

**Test strategy (PUT-failure sub-case)**:

1. Mock `GET /rest/api/3/field` returning `customfield_10001 / Severity`.
2. Mock `editmeta` returning `customfield_10001` with `schema.type: "string"`.
3. Mock PUT returning 400 with a Jira error body.
4. Run `jr issue edit KEY --field Severity=Critical --output json`.
5. Assert exit code non-zero.
6. Assert stdout JSON does NOT contain `changed_fields.Severity` (key absent or
   `changed_fields` key absent entirely).
7. Assert table mode stderr contains NO `  Severity → Critical` echo line.

**Suggested test names**:
- `test_BC_3_4_015_field_partial_resolution_failure_no_put`
- `test_BC_3_4_015_field_put_failure_discards_changed_fields`

---

### VP-396-010: Number field `f64` wire serialization preserves integer form

**Description**: When `--field NAME=5` targets a `number`-type field, the wire JSON
body must contain the integer `5` (not `5.0`). When `VALUE = "5e3"`, the wire body
must contain `5000` (not `5000.0` or `"5e3"`). This pins the `serde_json::Number`
integer-preservation behavior for the `--field` number path.

**Applies to**:
- BC-3.4.015: EC-3.4.015-4a (number field integer representation)
- BC-3.4.015: invariant 5 (`f64` parsing)

**Test strategy**:

1. Mock `GET /rest/api/3/field` returning `id: "customfield_20001"`, `name: "StoryPoints"`.
2. Mock `editmeta` returning `customfield_20001` with `schema.type: "number"`.
3. Mock PUT — mount with body match requiring `{"fields": {"customfield_20001": 5}}` (integer,
   NOT `5.0`).
4. Run `jr issue edit KEY --field StoryPoints=5`.
5. Assert exit code 0. Assert PUT mock was matched (proving integer form on wire).

**`5e3` sub-case**:

1. Same setup. Mock PUT body match requiring `{"fields": {"customfield_20001": 5000}}`.
2. Run `jr issue edit KEY --field StoryPoints=5e3`.
3. Assert exit code 0. Assert PUT mock was matched.

**NaN/Inf rejection sub-case**:

1. Mock `GET /rest/api/3/field` and `editmeta` as above. Mount NO PUT.
2. Run `jr issue edit KEY --field StoryPoints=inf`.
3. Assert exit code 64. Assert stderr mentions the parse error. Assert PUT not called.

**Suggested test names**:
- `test_BC_3_4_015_number_field_integer_wire_form`
- `test_BC_3_4_015_number_field_scientific_notation_wire_form`
- `test_BC_3_4_015_number_field_nan_rejected_exit_64`

---

### VP-396-011: `user`-type wire shape `{"accountId": VALUE}` and `date`/`datetime` bare-string pass-through

**Description**: The BC-3.4.015 Step 4 specifies three pass-through field types whose
wire serialization is claimed but never verified by any other VP. `user`-type fields must
produce `{"accountId": VALUE}` on the wire. `date` and `datetime`-type fields must produce
a bare JSON string (the value is passed through to Jira without client-side validation).
This VP exercises all three pass-through types.

**Applies to**:
- BC-3.4.015: Step 4 (`user` → `{"accountId": VALUE}`; `date`/`datetime` → bare string)

**Test strategy (`user` type)**:

1. Mock `GET /rest/api/3/field` returning `id: "customfield_10050"`, `name: "Reporter"`.
2. Mock `editmeta` returning `customfield_10050` with `schema.type: "user"` and
   `operations: ["set"]`.
3. Mock PUT — mount with body match requiring:
   `{"fields": {"customfield_10050": {"accountId": "abc123"}}}`.
4. Run `jr issue edit KEY --field Reporter=abc123`.
5. Assert exit code 0. Assert PUT mock was matched (confirming `{"accountId": ...}` shape).
6. Assert `changed_fields["Reporter"] == "abc123"` in JSON mode (raw accountId echoed).

**Test strategy (`date` type)**:

1. Mock `GET /rest/api/3/field` returning `id: "customfield_10060"`, `name: "DueDate"`.
2. Mock `editmeta` returning `customfield_10060` with `schema.type: "date"` and
   `operations: ["set"]`.
3. Mock PUT — mount with body match requiring:
   `{"fields": {"customfield_10060": "2026-12-31"}}` (bare string, no wrapping).
4. Run `jr issue edit KEY --field DueDate=2026-12-31`.
5. Assert exit code 0. Assert PUT mock was matched.

**`datetime` type sub-case**:

1. Same pattern with `schema.type: "datetime"` and value `"2026-12-31T23:59:59.000+0000"`.
2. Mock PUT body match requiring the bare string (no ISO 8601 validation or wrapping).
3. Assert PUT mock matched. Assert exit code 0.
4. **No-validation sub-case** (tests that junk passes through untouched): mount a
   separate PUT mock with body match requiring `{"fields": {"customfield_10070": "not-a-date"}}` —
   the exact junk string verbatim, no wrapping, no transformation. Run
   `jr issue edit KEY --field DueDatetime=not-a-date`. Assert PUT mock matched (proving
   the value was transmitted byte-for-byte). Assert exit code 0. This positively tests
   the "no client-side ISO 8601 validation" property — if the implementation were to
   reject the value client-side, the PUT mock would not be reached and the test would
   fail, catching the regression.

**Suggested test names**:
- `test_BC_3_4_015_user_field_wire_shape_account_id`
- `test_BC_3_4_015_date_field_bare_string_pass_through`
- `test_BC_3_4_015_datetime_field_bare_string_pass_through`

---

### VP-396-012: Field present in `editmeta` but `"set"` absent from `operations` → exit 64

**Description**: When `editmeta.fields[id].operations` does not contain `"set"`, Step 3b
of the resolution algorithm must exit 64 with a hint naming the field and its actual
operations list. No PUT must be issued. This guards against computed/read-only fields
that appear on the Edit screen but cannot be set via the API.

**Applies to**:
- BC-3.4.015: Step 3b (operations/"set" check, P3-LOW-002)
- BC-3.4.015: EC-3.4.015-20 (`operations` lacks `"set"`)

**Test strategy**:

1. Mock `GET /rest/api/3/field` returning `id: "customfield_10070"`, `name: "ComputedScore"`.
2. Mock `editmeta` returning `customfield_10070` with `schema.type: "number"` and
   `operations: ["transition"]` (does NOT include `"set"`).
3. Mount NO `PUT` mock.
4. Run `jr issue edit KEY --field ComputedScore=99`.
5. Assert exit code 64.
6. Assert stderr mentions the field name and the operations constraint (e.g.,
   `"ComputedScore"` and `"set"` absent or `"operations: [\"transition\"]"`).
7. Assert PUT mock was NOT called.

**Empty `operations` sub-case**:

1. Same setup with `operations: []` (empty list).
2. Assert exit code 64. Assert hint. Assert PUT not called.

**Suggested test names**:
- `test_BC_3_4_015_operations_lacks_set_exits_64`
- `test_BC_3_4_015_empty_operations_exits_64`

---

## VP to BC Mapping Summary

| VP ID | BC(s) Covered | Key Invariant |
|-------|---------------|---------------|
| VP-396-001 | BC-3.4.015, BC-3.4.012, BC-3.4.013 | String/number `--field` value appears in `changed_fields` echo (table and JSON); human name as key; `customfield_NNNNN` literal bypass skips field-list fetch entirely |
| VP-396-002 | BC-3.4.016, BC-3.4.012, BC-3.4.013 | Option field resolves to `{"id": ...}` on wire; echo shows human label, not id; case-insensitive match; option-id bypass |
| VP-396-003 | BC-3.4.015 | Field absent from `editmeta` exits 64 with Edit-screen actionable hint; no PUT issued |
| VP-396-004 | BC-3.4.015 | Unsupported field types (`array`, `any`) exit 64 with hint; no PUT issued |
| VP-396-005 | BC-3.4.017 | Multi-key/`--jql`-multi-issue rejection; flag-overlap hard error for `summary`, `description`, `issuetype`, `priority`; no HTTP before guards fire |
| VP-396-006 | BC-3.4.015, BC-3.4.016 | Warm `fields.json` cache (non-stale) → no `GET /rest/api/3/field` HTTP call; cold cache → exactly one fetch + cache populated for next run |
| VP-396-007 | BC-3.4.015 | Cache-write failure (`write_fields_cache` I/O error) → `warning:` stderr only (not stdout in `--output json` mode), exit 0, resolution and PUT succeed; best-effort swallow and channel separation positively tested |
| VP-396-008 | BC-3.4.015, BC-3.4.017 | `--field` + `--dry-run` → success path exits 0; Gates fire first; read-only HTTP executes for preview; PUT NOT issued; resolution failure still exits 64 |
| VP-396-009 | BC-3.4.015 | Multi-`--field` partial-failure → zero PUT; PUT-failure → `changed_fields` discarded; all-or-nothing invariant |
| VP-396-010 | BC-3.4.015 | Number field `f64` wire form: integer inputs produce `5` (not `5.0`); `5e3` → `5000`; NaN/Inf rejected with exit 64 |
| VP-396-011 | BC-3.4.015 | `user`-type wire shape `{"accountId": VALUE}`; `date`/`datetime` bare-string pass-through; no client-side ISO 8601 validation |
| VP-396-012 | BC-3.4.015 | Field in `editmeta` but `"set"` absent from `operations` → exit 64 with hint; no PUT (P3-LOW-002 correctness guard) |

## Project Convention Note

This project inlines Verification Properties directly in BC body files rather than
maintaining separate VP-INDEX, verification-architecture.md, or
verification-coverage-matrix.md files (those files do not exist in this repository).

**VP permanence decision (F-2, 2026-05-22)**: The `### VP-NNN` headings with full test
strategy detail that appear in this `verification-delta-396.md` file are intentionally
a **transient F2/F3 working artifact** consumed by the test-writer in F4. They are NOT
the permanent spec record. The permanent spec record for each VP is the one-line VP
citation in the corresponding BC body's `**Verification Properties**` section in
`bc-3-issue-write.md`. The test-writer uses the detailed `verification-delta-396.md`
strategies to author tests; once tests exist, the delta detail is superseded by the
test file itself. No migration of the `### VP-NNN` blocks to BC bodies is required or
intended — the BC body one-liners are the canonical long-term reference.

VP-396-001 through VP-396-012 are recorded as **Verification Properties subsections
within the BC bodies** in `.factory/specs/prd/bc-3-issue-write.md`:
- VP-396-001: present in BC-3.4.015 §Verification Properties.
- VP-396-002: present in BC-3.4.016 §Verification Properties.
- VP-396-003: present in BC-3.4.015 §Verification Properties.
- VP-396-004: present in BC-3.4.015 §Verification Properties.
- VP-396-005: present in BC-3.4.017 §Verification Properties.
- VP-396-006: present in BC-3.4.015 §Verification Properties AND BC-3.4.016 §Verification Properties.
- VP-396-007: present in BC-3.4.015 §Verification Properties.
- VP-396-008: present in BC-3.4.015 §Verification Properties AND BC-3.4.017 §Verification Properties.
- VP-396-009: present in BC-3.4.015 §Verification Properties.
- VP-396-010: present in BC-3.4.015 §Verification Properties.
- VP-396-011: present in BC-3.4.015 §Verification Properties.
- VP-396-012: present in BC-3.4.015 §Verification Properties.

No separate index propagation is required. All twelve VPs are verification artifacts
only — they do not affect BC count surfaces (total_bcs, definitional_count, BC-INDEX,
CANONICAL-COUNTS).

### Adversarial Pass 1 Resolution Summary (2026-05-22)

| Finding | Severity | Resolution |
|---------|----------|------------|
| HIGH-001 | HIGH | Fixed: EC-3.4.015-9 rewritten — empty NAME falls through to zero-match path (EC-3.4.015-1), not parse_field_kv |
| HIGH-002 | HIGH | Fixed: EC-3.4.015-18 added (`--dry-run` × `--field`); VP-396-008 added and cited in BC-3.4.015 and BC-3.4.017 |
| HIGH-003 | HIGH | Fixed: VP-396-006 added to BC-3.4.016 §Verification Properties; mapping table updated |
| HIGH-004 | HIGH | Fixed: VP-396-007 added (cache-write failure positively tested); cited in BC-3.4.015 §Verification Properties |
| MED-001 | MEDIUM | Fixed: canonical `resolve_edit_fields` signature documented in BC-3.4.015 (`&mut` form, `-> Result<()>`); F1 divergent form marked superseded |
| MED-002 | MEDIUM | Fixed: EC-3.4.017-10 (two `--field` same key → last-write-wins, no Gate B); EC-3.4.017-11 (`--field type=X` ≠ `issuetype`, no Gate B) added |
| MED-003 | MEDIUM | Fixed: EC-3.4.015-17 added — case-sensitive bypass documented as deliberate; rationale: Jira uses lowercase only; uppercase would mask typos |
| MED-004 | MEDIUM | Fixed: Gate A postcondition split into positional (no HTTP) and `--jql` (JQL executes, no list_fields/editmeta/PUT) sub-cases; EC-3.4.017-2 updated |
| MED-005 | MEDIUM | Fixed: EC-3.4.015-4a added (integer inputs → `5` not `5.0`; `5e3` → `5000`); VP-396-010 added |
| MED-006 | MEDIUM | Fixed: EC-3.4.015-12a added (PUT-failure discard); EC-3.4.015-12 updated with "all-or-nothing" note; VP-396-009 added |
| MED-007 | MEDIUM | Fixed: BC-3.4.017 invariant 1 rewritten (Gate B before Gate A; exactly one error message; ordering rationale); EC-3.4.017-12 added |
| LOW-001 | LOW | Fixed: EC-3.4.017-9 ref corrected from `EC-15-11` to `EC-3.4.015-11` |
| LOW-003 | LOW | Fixed: EC-3.4.016-4 note added — id-bypass wins when option id and label are numerically identical |
| LOW-002 | LOW | PASS — no action required |
| LOW-004 | LOW | Grandfathered — no action |
| LOW-005 | LOW | Process-gap follow-up — no action from product-owner |

### Adversarial Pass 2 Resolution Summary (2026-05-22)

| Finding | Severity | Resolution |
|---------|----------|------------|
| P2-001 | HIGH (count-surface drift) | Fixed: bc-3-issue-write.md end-of-file footer updated from "71 individually-bodied (cumulative 100 ...)" to "74 individually-bodied (cumulative 103 ...)". Footer surface added to prd-delta-396.md §11 count surfaces table. |
| P2-002 | HIGH (process-gap) | Fixed: `scripts/check-bc-cumulative-counts.sh` extended with Surface H — parses "## Total BCs in this file: N individually-bodied (cumulative M ...)" footer; asserts N == definitional_count AND M == total_bcs. Conditional (skip absent/non-standard footers). Script header updated to document 9 surfaces. Both guard scripts exit 0. |
| P2-003 | MEDIUM | Fixed: EC-3.4.017 edge cases reordered to numeric sequence (9, 10, 11, 12). No behavioral change. |
| P2-004 | MEDIUM | Fixed: VP-396-001 one-liner in BC-3.4.015 §Verification Properties restored to "String/number" (was "String" — omitted the number echo path). |
| P2-005 | MEDIUM | Fixed: False JSM parenthetical dropped from EC-3.4.015-9 — BC-3.8.008 does not specify empty-NAME behavior; citing it as a guarantee was incorrect. |
| P2-006 | MEDIUM (implementation-blocking) | Fixed: `resolve_edit_fields` canonical signature amended to add `profile: &str` as second arg (after `client`), per CLAUDE.md cache-boundary rule. prd-delta-396.md §9 call site updated to pass `&config.active_profile_name`. F1 divergent form (which also lacked `profile`) marked superseded. |
| P2-007 | MEDIUM | Fixed: VP-396-007 extended with `--output json` stdout-unpolluted assertion — warning line goes to stderr only; stdout contains clean JSON result. Profile-4 channel separation pinned. Mapping table row updated. |
| OBS-1 | Observation | Fixed: `resolve_edit_fields` placement in `src/cli/issue/helpers.rs` added to prd-delta-396.md §2 Locked Design Decisions, closing F1 open-question Q5. |
| OBS-5 | Observation | Fixed: EC-3.4.015-4 tightened — "non-numeric or non-finite" (two distinct failure modes: `f64` parse error vs `serde_json::Number::from_f64` returning None for NaN/Inf). |

### Adversarial Pass 3 Resolution Summary (2026-05-22)

| Finding | Severity | Resolution |
|---------|----------|------------|
| P3-MED-001 | MEDIUM | Fixed: prd-delta-396.md §7 stale enumerated table replaced with an authoritative-pointer section directing readers to BC-3.4.015/016/017 §Edge Cases. Prevents recurring drift. |
| P3-MED-002 | MEDIUM | Fixed: prd-delta-396.md §11 footnote added noting that BC-INDEX Coverage Statistics rows are hand-verified (not script-guarded by `check-bc-cumulative-counts.sh`). |
| P3-MED-003 | MEDIUM | Fixed: (a) EC-3.4.015-18 and VP-396-008 exit code pinned to **0** (sourced from `src/cli/issue/create.rs:707: return Ok(())`). (b) EC-3.4.015-19 added — resolution failure under `--dry-run` exits 64; dry-run does not suppress resolution errors. VP-396-008 extended with resolution-failure sub-case and updated description. |
| P3-LOW-001 | LOW | PASS — no action. |
| P3-LOW-002 | LOW | Fixed (option a): Step 3b added to BC-3.4.015 algorithm — if `"set"` ∉ `operations`, exit 64 with actionable hint naming the field and its actual operations list. EC-3.4.015-20 added. VP-396-012 added (operations check verified). prd-delta §5 updated to document that `operations` is actively used (no dead-code risk); `required` and `system` fields documented as parsed-but-future-use with guidance on clippy handling. |
| VP gap | Observation | Fixed: VP-396-011 added — `user`-type wire shape `{"accountId": VALUE}`, `date` bare-string, `datetime` bare-string pass-through, all positively tested. VP-396-012 added (as part of P3-LOW-002 resolution). Total VPs: 12. |

### Adversarial Pass 4 Resolution Summary (2026-05-22)

| Finding | Severity | Resolution |
|---------|----------|------------|
| F-1 | MEDIUM | Fixed: EC-3.4.017-10 rewritten — duplicate `--field` collapse happens AT PARSE TIME inside `parse_field_kv` via `map.insert(key, value)`; `resolve_edit_fields` receives a single-entry `HashMap<String, String>` and never sees both entries. The incorrect "both added to `fields` JSON object; second write-wins" language removed. prd-delta-396.md §9 call-site note updated to name `&HashMap<String, String>` type explicitly and cite BC-3.8.008. BC-3.4.015 canonical signature (applied in prior burst) already uses `&HashMap<String, String>`. |
| F-2 | MEDIUM | Fixed: Explicit VP permanence decision added to Project Convention Note in this file — `### VP-NNN` detail blocks are intentionally transient F2/F3 working artifacts consumed by test-writer in F4; BC body one-liners are the permanent spec record. No migration of detail blocks to BC bodies required. |
| F-3 | MEDIUM | Fixed: EC-3.4.015-19 and EC-3.4.015-20 reordered — EC-3.4.015-19 (resolution failure under `--dry-run`) now precedes EC-3.4.015-20 (`operations` lacks `"set"`), restoring numeric order (-18, -19, -20). No behavioral change. |
| F-4 | MEDIUM | Fixed (applied in prior burst): `option` arm added to BC-3.4.015 Step 4 type dispatch table — `option: → dispatch to BC-3.4.016 Step 4a`; arm must be handled BEFORE unknown→exit-64 arm. Full type matrix now visible in one place within `resolve_edit_fields`. |
| O-2 | Observation | Fixed: `AllowedValue.name` entry added to prd-delta-396.md §5 struct-field-usage block — justifies parsed-but-unused status (v1 matches `value` only; `name` retained for future cascade-select matching and to avoid `deny_unknown_fields` panics). Guidance on clippy suppression provided. |
| O-1, O-3, O-4 | Observations | No action required. |

**Final VP count**: 12 (VP-396-001 through VP-396-012) — unchanged.  
**Guard scripts**: `check-spec-counts.sh` exit 0; `check-bc-cumulative-counts.sh` exit 0 (583 total across 8 files; Surface H verified).

### Adversarial Pass 6 Resolution Summary (2026-05-22)

| Finding | Severity | Resolution |
|---------|----------|------------|
| F-1 | HIGH | Fixed: BC-3.4.015 invariant 10 added — `resolve_edit_fields` MUST be called INSIDE the `if dry_run { ... }` block (before `return Ok(())`), not after the short-circuit. EC-3.4.015-18 amended to state this explicitly and warn implementers. prd-delta §9 restructured into three sections: (1) common steps 1–3, (2) dry-run sub-path (resolve → render-preview → `return Ok(())`), (3) live sub-path (resolve → PUT → echo). Critical constraint paragraph added naming the three BCs/VPs violated by wrong placement. |
| F-2 | MEDIUM | Fixed: `_Last updated_` prose (bc-3-issue-write.md line below numeric footer) advanced from "2026-05-21 ... BC-3.4.012..014 ... 14 contracts" to "2026-05-22 (issue #396 F2) ... BC-3.4.015..017 ... 17 contracts". prd-delta §11 count surfaces table updated with new row tracking this prose surface; footnote extended noting this surface is unguarded by scripts (process-gap O-5). |
| O-5 | Observation | Process-gap acknowledged: `_Last updated_` prose is not validated by guard scripts. No script change required from product-owner. |

**Final VP count**: 12 (VP-396-001 through VP-396-012) — unchanged.  
**Guard scripts**: `check-spec-counts.sh` exit 0; `check-bc-cumulative-counts.sh` exit 0 (583 total across 8 files; Surface H verified).

### Adversarial Pass 7 Resolution Summary (2026-05-22)

Pass 7 was substantively CLEAN (0 CRITICAL/HIGH/MEDIUM). Clean pass count: 1 of 3.

| Finding | Severity | Resolution |
|---------|----------|------------|
| LOW-001 | LOW | Fixed: `BC-INDEX.md` `last_updated` frontmatter bumped from `2026-05-21` to `2026-05-22`. |
| LOW-002 | LOW | Fixed: `BC-INDEX.md last_updated` row added to prd-delta §11 count-surfaces table, making this surface visible to future delta authors. |
| O-1 | Cosmetic | Fixed: duplicated "Note on script coverage (P3-MED-002)" blockquote in prd-delta §11 deduplicated to a single consolidated note covering all three unguarded surfaces. |

**VP count**: 12 — unchanged. **Total BCs**: 583 — unchanged.  
**Guard scripts**: `check-spec-counts.sh` exit 0; `check-bc-cumulative-counts.sh` exit 0.

### Adversarial Pass 8 Resolution Summary (2026-05-22)

Pass 8 was substantively CLEAN (0 CRITICAL/HIGH/MEDIUM/LOW). 3 observations swept. Clean pass count: 2 of 3.

| Observation | Impact | Resolution |
|-------------|--------|------------|
| OBS-1 | Borderline-HIGH (runtime silent failure on all option fields) | `#[serde(rename = "allowedValues")]` added to `allowed_values` field in prd-delta §5 struct block. Full struct audited — all other fields confirmed correct. Serde rename audit note added below struct. |
| OBS-2 | Low (tautological test) | VP-396-011 datetime step 4 rewritten — now mounts a body-match PUT mock requiring the junk string verbatim and asserts the mock was matched, proving byte-for-byte pass-through rather than just asserting exit 0 against an unconditional-204 mock. |
| OBS-3 | Medium (wrong Trace anchor misleads implementer) | `src/api/jira/fields.rs::find_field_by_name` dropped from BC-3.4.015 Trace. `resolve_edit_fields` clarified as the spec-anchored orchestrator that owns exact-match-then-substring logic and all exit-64 ambiguity handling; internal helpers are implementation details not anchored in the BC Trace. |

**VP count**: 12 — unchanged. **Total BCs**: 583 — unchanged.  
**Guard scripts**: `check-spec-counts.sh` exit 0; `check-bc-cumulative-counts.sh` exit 0.

### Adversarial Pass 9 — Convergence Reached (2026-05-22)

VERDICT: CLEAN. 0 findings. 4 confirmatory observations (serde-safe customId omission; invariant-10 dual-arm verified; parse_field_kv citation consistent; FieldsCache faithful CmdbFieldsCache mirror). F2 adversarial convergence reached at pass 9 — three consecutive clean passes (7, 8, 9). Spec ready to advance to F3/F4.
