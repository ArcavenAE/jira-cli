---
document_type: verification-delta
issue: "#589"
bundle: "SOH-BUGS-1"
title: "Verification properties for AllowedValue.id Option<String> fix"
date: "2026-07-09"
phase: F1
new_vps:
  - VP-589-001
amended_vps:
  - VP-396-002
  - VP-396-008
related_bcs:
  - BC-3.4.015
  - BC-3.4.016
  - BC-3.4.017
---

# Verification Delta — Issue #589: `AllowedValue.id` Option<String> Fix

## Context

`AllowedValue.id` in `src/types/jira/editmeta.rs` was typed as required `String`.
Jira's GDPR-era user/group picker fields carry `accountId` instead of `id`; serde
would fail to deserialize the entire `HashMap<String, EditMetaField>` on any editmeta
fetch touching such a field, blocking `--field` edits regardless of which field the user
targeted.

Fix: `AllowedValue.id` → `Option<String>`. Seven call sites in
`src/cli/issue/field_resolve.rs` made Option-aware. Entries with `id=None` are
excluded from the id-bypass path; matched entries with `id=None` on the label/value
path exit 64 with EC-3.4.016-8 message.

## New Verification Property

### VP-589-001: editmeta with id-absent allowedValues on non-targeted field — deserialization succeeds; targeted edit proceeds

**Description**: When the editmeta response contains an `allowedValues` entry that has
no `id` field on a field the user is NOT targeting, the response must deserialize
without a serde error. The targeted field edit (string-type example below) must
proceed normally through resolution, PUT, and echo.

This property specifically tests the before/after behavior: before the fix, any
id-absent `allowedValues` entry in ANY editmeta field caused a `"missing field 'id'"`
serde panic. After the fix (`AllowedValue.id: Option<String>`), the id-absent entry
is silently accepted.

**Applies to**:
- BC-3.4.015: `AllowedValue.id` typed `Option<String>` in `src/types/jira/editmeta.rs`
- BC-3.4.016: id-absent entries excluded from id-bypass; EC-3.4.016-8 fires for
  id-absent matched label/value entries

**Test strategy**:

1. Mock `GET /rest/api/3/field` returning two fields:
   - `id: "customfield_10001"`, `name: "Severity"` (the targeted field)
   - `id: "customfield_99001"`, `name: "Assignee"` (a non-targeted user-picker field)
2. Mock `GET /rest/api/3/issue/KEY/editmeta` returning BOTH fields. For
   `customfield_99001`, include `allowedValues` with an entry that has NO `"id"` key:
   ```json
   {
     "fields": {
       "customfield_10001": {
         "schema": {"type": "string"},
         "operations": ["set"],
         "allowedValues": []
       },
       "customfield_99001": {
         "schema": {"type": "user"},
         "operations": ["set"],
         "allowedValues": [
           {"accountId": "abc123", "displayName": "Alice"},
           {"accountId": "def456", "displayName": "Bob"}
         ]
       }
     }
   }
   ```
   The `allowedValues` entries for `customfield_99001` have `accountId` and
   `displayName` but NO `id` — this is the GDPR-era shape.
3. Mock `PUT /rest/api/3/issue/KEY` returning 204.
4. Run `jr issue edit KEY --field Severity=Critical`.
5. Assert exit code **0** (no serde error; deserialization succeeded despite id-absent
   entries on the non-targeted field).
6. Assert PUT was called with `{"fields": {"customfield_10001": "Critical"}}`.
7. Assert stderr (table mode) contains `  Severity → Critical`.

**Regression guard** (confirms id-present path still works):

The happy-path test from VP-396-001 (`test_bc_3_4_015_field_string_value_appears_in_table_echo`)
remains a valid regression guard — all pre-existing issue_edit_field tests in
`tests/issue_edit_field.rs` supply `allowedValues` entries WITH `"id"`, so they
collectively guard the id-present path.

**Suggested test names**:
- `test_bc_3_4_015_editmeta_idless_allowed_values_on_non_targeted_field_succeeds`

---

## Amended Verification Properties

### VP-396-002 Clarification: `{"id": ...}` wire form requires non-None id

The one-liner in BC-3.4.016 §Verification Properties has been updated to note:

> VP-396-002: Option field resolves to `{"id": ...}` on wire (requires the matched
> allowedValues entry to have a non-None id — EC-3.4.016-8 exits 64 when id is
> absent); `changed_fields` echo shows human label (not id); case-insensitive
> matching; option-id bypass.

**Additional test strategy for EC-3.4.016-8** (covers VP-396-002 clarification):

1. Mock `GET /rest/api/3/field` returning `id: "customfield_10176"`, `name: "Urgency"`.
2. Mock `GET /rest/api/3/issue/KEY/editmeta` returning `customfield_10176` with
   `schema.type: "option"` and `allowedValues` where the user-targeted entry has NO
   `"id"` key:
   ```json
   "allowedValues": [
     {"value": "High"},
     {"value": "Medium"},
     {"value": "Low"}
   ]
   ```
3. Mount NO `PUT` mock (PUT must not be called).
4. Run `jr issue edit KEY --field Urgency=High`.
5. Assert exit code **64**.
6. Assert stderr contains `"no machine-readable id"` (load-bearing substring).
7. Assert stderr contains `"--field"` (load-bearing substring).
8. Assert PUT mock was NOT called.

**Suggested test names**:
- `test_bc_3_4_016_option_idless_allowed_value_exits_64_with_actionable_message`

---

### VP-396-008 Extension: dry-run succeeds when editmeta has id-absent allowedValues on non-targeted fields

The one-liner in BC-3.4.015 §Verification Properties and BC-3.4.017 §Verification
Properties has been extended to cover the idless allowedValues dry-run sub-case:

> VP-396-008: `--field` + `--dry-run` → success path exits 0; read-only HTTP (cache,
> `editmeta`) fires; PUT NOT issued; resolution failure under `--dry-run` still exits 64;
> dry-run succeeds when editmeta contains allowedValues entries with absent `id` on
> non-targeted fields (AllowedValue.id is Option<String>; absent entries do not fail
> deserialization). See VP-589-001 for the standalone deserialization assertion.

**Additional test strategy sub-case** (idless allowedValues × dry-run):

1. Use the same mock setup as VP-589-001 test strategy steps 1–3.
2. Add `--dry-run` flag to the invocation: `jr issue edit KEY --field Severity=Critical --dry-run`.
3. Assert exit code **0** (dry-run succeeds; idless non-targeted allowedValues do not
   cause deserialization failure or exit-64 under --dry-run).
4. Assert PUT mock was NOT called.
5. Assert the planned-changes preview includes `Severity → Critical`.

**Suggested test names**:
- `test_bc_3_4_015_field_dry_run_idless_nontargeted_allowedvalues_exits_0`

---

## VP to BC Mapping Update

| VP ID | BC(s) Covered | Disposition |
|-------|---------------|-------------|
| VP-589-001 | BC-3.4.015 | NEW — deserialization success for id-absent allowedValues on non-targeted fields |
| VP-396-002 | BC-3.4.016 | CLARIFIED — `{"id":...}` wire form requires non-None id; EC-3.4.016-8 cited |
| VP-396-008 | BC-3.4.015, BC-3.4.017 | EXTENDED — dry-run succeeds sub-case for id-absent allowedValues |

## Project Convention Note

Per the permanence decision in `verification-delta-396.md`: the `### VP-NNN` detail
blocks in this file are transient F2/F3 working artifacts consumed by the test-writer
in F4. The permanent spec record for each VP is the one-line citation in the BC body's
`**Verification Properties**` section in `bc-3-issue-write.md`.

VP-589-001 permanent record: BC-3.4.015 §Verification Properties.
VP-396-002 permanent record (amended): BC-3.4.016 §Verification Properties.
VP-396-008 permanent record (amended): BC-3.4.015 §Verification Properties AND
BC-3.4.017 §Verification Properties.

[AMENDED 2026-07-09 TWIN-ARTIFACT-SWEEP: all 4 suggested test-name references lowercased to match actual implemented names (test_bc_3_4_015_* / test_bc_3_4_016_*) per test-naming-convention.md new-test rule]
[AMENDED 2026-07-09 COUNT-FREE: replaced stale numeric test count "44" with count-free phrasing "all pre-existing issue_edit_field tests" per BC-body Trace/Source convention (PG-365-1)]
