---
document_type: f1-delta-analysis
phase: phase-f1-delta-analysis
producer: architect
issue: 396
status: draft
created: 2026-05-22
project: jira-cli
mode: BROWNFIELD
intent: enhancement
bundled_fix: false
feature_type: backend
trivial_scope: false
scope: standard
regression_risk: medium
severity: N/A
inputs:
  - ".factory/research/issue-396-jsm-fields-validation.md"
  - "src/cli/issue/create.rs"
  - "src/cli/mod.rs"
  - "src/api/jira/issues.rs"
  - "src/api/jira/fields.rs"
  - "src/cli/issue/helpers.rs"
  - ".factory/phase-f1-delta-analysis/issue-398/delta-analysis.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
---

# F1 Delta Analysis — Issue #396

## Feature

- **Name:** `issue edit --field NAME=VALUE` — arbitrary custom field editing via editmeta
- **Issue link:** https://github.com/Zious11/jira-cli/issues/396
- **Research source:** `.factory/research/issue-396-jsm-fields-validation.md` (all five
  research questions answered at HIGH confidence)
- **Closest precedent:** Issue #398 (`issue edit` changed-fields echo) — same file, same
  single-key success path in `handle_edit`

---

## Problem Statement

`jr issue edit` has no mechanism to set arbitrary custom fields — including JSM request-type
fields like Urgency and Impact — on an existing issue. The dedicated flags (--summary,
--type, --priority, --team, --points, --parent, --description) cover first-party Jira
fields only. Any custom field, including JSM select fields surfaced in service-desk
projects, is unreachable via `jr issue edit` today.

The core blocker is not API capability — the platform `PUT /rest/api/3/issue/{key}` already
accepts arbitrary `customfield_NNNNN` values, which is exactly how `jr issue edit` sets team
and story-points fields internally. The missing pieces are:

1. A `--field NAME=VALUE` flag on the `Edit` clap subcommand (currently only on `Create`).
2. Resolution of a human field name (e.g., "Urgency") to its `customfield_NNNNN` ID, using
   `GET /rest/api/3/field` (already available via `list_fields()`).
3. Resolution of a select option value (e.g., "High") to its numeric option `id`, using
   `GET /rest/api/3/issue/{key}/editmeta` (currently unused anywhere in the codebase).
4. Type-aware wire-format construction (string → bare string, single-select → `{id: "..."}`,
   number → raw number, etc.).
5. Actionable error when a field is absent from the issue's Edit screen (not in `editmeta`).

---

## Scope

### In scope (approved)

- Add `--field NAME=VALUE` flag (repeatable, `ArgAction::Append`) to the `Edit` clap
  subcommand in `src/cli/mod.rs`. Flag behavior mirrors the existing `Create` flag: first
  `=` splits, last-value-wins on duplicates, empty value is legal.
- **Single-key path only**: `--field` is added to the C-1 `rejected_in_bulk` set — it
  errors clearly on multi-key positional or `--jql` resolving to multiple issues.
- Field-name resolution: human name (case-insensitive substring, `list_fields()` global
  list) → `customfield_NNNNN` id. When the name is already a `customfield_NNNNN` literal,
  bypass lookup (mirrors BC-3.8.008 create-path behaviour).
- `editmeta` fetch: `GET /rest/api/3/issue/{key}/editmeta` called at resolve time to
  validate that the field is on the Edit screen and to retrieve `allowedValues` for
  single-select resolution.
- Type-aware value serialisation (see Section 6).
- Actionable error when the field is absent from `editmeta` ("field X is not on the Edit
  screen for this project — ask a project admin to add it").
- `changed_fields` echo: each successfully resolved `--field` pair is inserted into the
  existing `changed_fields: BTreeMap<String, String>` in `handle_edit`, using the human
  field name as the key and the resolved value as the value, consistent with BC-3.4.012 /
  BC-3.4.013.
- CLAUDE.md Gotcha entry: document the Request-Type-change non-goal, citing JSDCLOUD-4609
  and the known 500-on-PUT finding.

### Out of scope (non-goals — all user-approved)

- **Changing the Request Type of an existing issue.** No reliable Jira Cloud API exists
  for this (JSDCLOUD-4609, open since Dec 2016, "Gathering Interest"). Attempting to PUT
  `customfield_NNNNN` for the `sd-customerrequesttype` system field is known to return
  HTTP 500 (Atlassian Community accepted answer; see research Q3). Declared non-goal;
  documented in CLAUDE.md.
- `--field` on multi-key / `--jql` resolving multiple issues. The Bulk API does not
  support arbitrary custom field writes; adding this would require a separate design
  pass. C-1 guard rejects it with a clear error message.
- `--field` on the `issue create` platform path. Currently emits a warning and is dropped
  (BC-3.8.012). This cycle does NOT change that behaviour.
- `--field` on the JSM create path (`handle_jsm_create`). Already fully implemented
  (S-288-pr4 / BC-3.8.008). No changes to `handle_jsm_create`.
- `--field` on multi-value field types (multi-select arrays, user arrays, version arrays).
  v1 covers a minimal type set; unsupported types get a clear error message.
- Interactive `allowedValues` picker. `--no-input` is the default for non-TTY; the flag
  must have a fully non-interactive path.
- Caching of `editmeta` responses. The `editmeta` API is called once per `issue edit`
  invocation when `--field` is set. Future caching is left for a later cycle.

---

## Intent and Classification

| Dimension | Value |
|-----------|-------|
| Intent | Enhancement — new flag on existing command |
| Feature type | Backend (API integration, type resolution) |
| Trivial scope | No |
| Regression risk | Medium — extends the single-key path in `handle_edit`, which already carries BC-3.4.003..014 tests |
| Bundled fix | No |

---

## Affected Files

### New files (to be created)

| Path | Purpose |
|------|---------|
| `tests/issue_edit_field.rs` | Integration tests for `--field` on `issue edit` (single-key path): field absent from editmeta (actionable error), field present + string type, field present + single-select (name→id resolution), `customfield_NNNNN` literal bypass, --field with --jql/multi-key rejection, conflict with dedicated flags, changed_fields echo in table + JSON modes |

### Modified files

| Path | What changes |
|------|-------------|
| `src/cli/mod.rs` | Add `field: Vec<String>` to `IssueCommand::Edit` variant (matching the existing `Create` field definition) |
| `src/cli/issue/create.rs` | `handle_edit`: (1) destructure `field` from `IssueCommand::Edit`, (2) add `field_pairs.is_some()` to `has_any_field_change` guard, (3) add `field_pairs` to C-1 `unsupported` multi-key rejection block, (4) after the existing field-resolution block, resolve each `--field` pair via `resolve_edit_fields()` and merge into `fields` json object and `changed_fields` BTreeMap |
| `src/api/jira/issues.rs` | Add `get_editmeta(key)` → `GET /rest/api/3/issue/{key}/editmeta` returning new `EditMeta` type |
| `src/api/jira/fields.rs` | Add `find_field_by_name(fields, name)` pure helper that case-insensitively matches a human name against the global `list_fields()` result, returning `Option<Field>` |
| `src/types/jira/mod.rs` (or new `src/types/jira/editmeta.rs`) | New Serde structs: `EditMeta`, `EditMetaField`, `EditMetaFieldSchema`, `AllowedValue` |
| `src/cli/issue/helpers.rs` OR new `src/cli/issue/field_resolve.rs` | `resolve_edit_fields(client, key, field_pairs) -> Result<(Value, Vec<(String, String)>)>` — orchestrates the full field-name → customfield-id → editmeta-lookup → value-serialize pipeline; returns the merged `fields` JSON fragment and a vec of `(human_name, resolved_value_string)` for `changed_fields` insertion |
| `CLAUDE.md` | New Gotcha entry: `--field` on `issue edit` / Request-Type non-goal |

### No changes required

- `src/cli/issue/json_output.rs` — `edit_response` already accepts `&BTreeMap<String, String>` for `changed_fields`; no signature change needed.
- `src/api/jsm/` — No JSM path changes.
- `src/cli/issue/create.rs` / `handle_jsm_create` — No changes to the JSM create path.
- `src/api/auth.rs`, `src/cache.rs` — No auth or cache changes.

---

## New API Surface

### `GET /rest/api/3/issue/{key}/editmeta`

**New method in `src/api/jira/issues.rs`:**

```rust
pub async fn get_editmeta(&self, key: &str) -> Result<EditMeta>
```

Path: `/rest/api/3/issue/{key}/editmeta`  
Method: GET  
Auth: same bearer/basic as all other `JiraClient` calls  
Response shape (relevant excerpt):
```json
{
  "fields": {
    "customfield_10176": {
      "required": false,
      "schema": { "type": "option", "custom": "...", "customId": 10176 },
      "name": "Urgency",
      "key": "customfield_10176",
      "hasDefaultValue": false,
      "operations": ["set"],
      "allowedValues": [
        { "self": "...", "value": "High",   "id": "10286" },
        { "self": "...", "value": "Medium", "id": "10287" },
        { "self": "...", "value": "Low",    "id": "10288" }
      ]
    },
    "summary": {
      "required": true,
      "schema": { "type": "string", "system": "summary" },
      "name": "Summary",
      "operations": ["set"]
    }
  }
}
```

**New Serde structs (new file `src/types/jira/editmeta.rs` or inline in `issues.rs`):**

```rust
pub struct EditMeta {
    pub fields: HashMap<String, EditMetaField>,
}

pub struct EditMetaField {
    pub name: String,
    pub schema: EditMetaFieldSchema,
    pub allowed_values: Option<Vec<AllowedValue>>,
    pub operations: Vec<String>,
    pub required: bool,
}

pub struct EditMetaFieldSchema {
    #[serde(rename = "type")]
    pub field_type: String,        // "string", "number", "option", "array", "date", "datetime", "user"
    pub system: Option<String>,    // present for system fields ("summary", "description", etc.)
    pub custom: Option<String>,    // present for custom fields
}

pub struct AllowedValue {
    pub id: String,
    pub value: Option<String>,     // present for "option" type select fields
    pub name: Option<String>,      // present for some field types (e.g., priority, user)
}
```

---

## Field-Name Resolution Algorithm

Resolution proceeds in this exact order for each `--field NAME=VALUE` pair:

### Step 1: Detect `customfield_NNNNN` literal bypass

If `NAME` matches `customfield_\d+` (case-sensitive regex), skip all name-lookup steps and
proceed directly to Step 3 using `NAME` as the field ID. This is the same bypass used by
`parse_field_kv` on the JSM create path (BC-3.8.008). Rationale: avoids a `list_fields()`
round-trip for agents/scripts that already know the ID.

### Step 2: Resolve human name to `customfield_NNNNN`

Call `list_fields()` (→ `GET /rest/api/3/field`). Perform a **case-insensitive exact name
match** first; if no exact match, perform case-insensitive **substring** match.

- Zero matches → `JrError::UserError` ("unknown field name 'X'. Use `jr project fields`
  or `jr project types` to list available fields, or supply `customfield_NNNNN` directly.")
  Exit 64.
- Multiple matches → `JrError::UserError` ("field name 'X' is ambiguous — found: A
  (customfield_1), B (customfield_2). Supply `customfield_NNNNN` directly.") Exit 64.
- Single match → proceed with its `id`.

**Human gate question Q1:** Should this use `partial_match::match_single` (same as team
resolution) or a bespoke matcher? Recommendation: bespoke for fields — the existing
`partial_match` module targets entities with display names and multi-word disambiguation
prompts; field resolution needs deterministic non-interactive behaviour since field IDs
never overlap. Use a simple `Iterator::filter` + exact-first rank.

### Step 3: Fetch `editmeta`

Call `get_editmeta(key)`. If the resolved field ID is absent from
`editmeta.fields`:
- Emit actionable error: "field 'NAME' (customfield_NNNNN) is not on the Edit screen for
  issue KEY. Ask a project admin to add it to the Edit screen for this project/issue type."
  Exit 64 (`JrError::UserError`).

### Step 4: Type-aware value serialisation

Read `editmeta.fields[id].schema.type` and serialise `VALUE` accordingly:

| schema.type | Wire format | Notes |
|-------------|-------------|-------|
| `string` | `json!(VALUE)` bare string | Also applies to `text` |
| `number` | `json!(VALUE.parse::<f64>()?)` | Error if not parseable |
| `option` | `json!({"id": resolve_option_id(VALUE, &allowed_values)})` | Single-select |
| `date` | `json!(VALUE)` bare string | Validate ISO 8601 format? (see Q2) |
| `datetime` | `json!(VALUE)` bare string | Validate ISO 8601 format? (see Q2) |
| `user` | `json!({"accountId": VALUE})` | Caller supplies accountId |
| `array` | Unsupported in v1 — UserError exit 64 | Multi-select, label arrays |
| `any` / unknown | Unsupported in v1 — UserError exit 64 | Includes CMDB object fields |

### Step 4a: Select option resolution (type = `option`)

If `VALUE` matches an `allowedValues[].id` exactly (numeric string) → use `id` as-is.
Otherwise perform case-insensitive exact match on `allowedValues[].value`, then substring
match.

- Zero matches → `JrError::UserError` ("invalid value 'X' for field 'NAME'. Allowed
  values: A, B, C.") Exit 64.
- Multiple substring matches → `JrError::UserError` ("value 'X' is ambiguous for field
  'NAME'. Allowed values: A (id=1), B (id=2). Specify the exact value.") Exit 64.
- Single match → use its `id`.

### Step 5: Build wire fragment

The resolved `(id, value_json)` pair is merged into the `fields` JSON object under key
`id`. This is then passed to `client.edit_issue(key, fields)` at the existing call site.

### Step 6: `changed_fields` insertion

After successful resolution, insert `(human_name_or_id, resolved_display_value)` into
`changed_fields`. For string/number fields, `resolved_display_value` is the raw `VALUE`
string. For single-select fields, `resolved_display_value` is the matched `allowedValues[].value`
(the human label, not the option `id`). This keeps the `changed_fields` echo human-readable
(BC-3.4.012) and the JSON output informative (BC-3.4.013).

---

## Field-Type Coverage Decision (v1)

### Recommended v1 supported types

| Type | Supported | Rationale |
|------|-----------|-----------|
| `string` | YES | Covers Summary (if set via `--field` for edge cases), description (not recommended, already has dedicated flag), text custom fields |
| `number` | YES | Story-point-style number fields outside the dedicated --points flag |
| `option` (single-select) | YES | Core use case: Urgency, Impact, any JSM/Jira custom select field |
| `date` | YES (pass-through) | ISO date string; Jira rejects malformed dates server-side |
| `datetime` | YES (pass-through) | ISO datetime string; same server-side validation |
| `user` | YES (pass-through, caller supplies accountId) | Simple; no user-lookup added in v1 |
| `array` (multi-select, labels) | NO (exit 64 with hint) | Requires array-of-objects payload; already handled for labels via `--label` |
| `any` / CMDB object | NO (exit 64 with hint) | CMDB fields have their own lookup path; out of scope |
| Unknown schema types | NO (exit 64 with hint) | Safe default |

**Human gate question Q2:** Should `date`/`datetime` receive client-side ISO 8601 format
validation (reject obviously invalid strings before the HTTP call)? Recommendation: defer
to server-side; Jira's error message is readable, and adding a regex here is fragile to
Jira Cloud's date format variations.

**Human gate question Q3 (critical for human gate):** For the `user` type — should
`--field Assignee=me` resolve "me" to `self.current_user().account_id`? The `resolve_user`
helper in `helpers.rs` already supports "me" for `--to`. Including this would be
convenient but adds an extra API call on a relatively rare use case. Recommendation:
defer "me" resolution for user fields to a follow-up; v1 requires the caller to supply the
raw `accountId`.

---

## Error and Edge Cases

### EC-396-001: `--field` with multi-key positional or `--jql`-resolved set

When `--field` is provided alongside 2+ positional keys, or when `--jql` resolves to 2+
issues, the C-1 rejection block fires: "Multi-key bulk edit doesn't yet support: --field.
Use a single key, or open an issue if this matters for your workflow." Exit 64. No HTTP
calls are made. This is identical to how `--parent`, `--team`, `--description` are
rejected in bulk today.

### EC-396-002: `--field` with `--jql` resolving to exactly one issue

When `--jql` resolves to exactly one issue (the single-match `--jql` fast path at line 758
of `create.rs`), `--field` proceeds normally on the single-key path. This is consistent
with how `--team` behaves today.

### EC-396-003: Field name not found in `list_fields()`

UserError exit 64 with name and hint (see Section 6 Step 2).

### EC-396-004: Field name resolves to a non-editable system field

If the user writes `--field Summary=New Title`, the field is found in `list_fields()` and
in `editmeta` (Summary is always on the Edit screen). Wire format is string; Jira accepts
it. There is no special treatment for this case — `--field Summary=X` is valid, though
users should prefer `--summary X`. However, if the user writes `--field Summary=X
--summary Y`, both will attempt to set `fields["summary"]` — last-write-wins in the JSON
merge. **Human gate question Q4:** Should overlapping `--field KEY=VALUE` and dedicated
flag (e.g., `--summary`) be detected as a UserError? Recommendation: detect and reject
with exit 64 to prevent surprising overwrites. Affected dedicated flags: `summary`,
`description`, `issuetype`, `priority` (and their field-id variants).

### EC-396-005: Field absent from `editmeta` (not on Edit screen)

UserError exit 64 with the actionable message from Section 6 Step 3. This is the most
likely real-world failure for JSM fields (Urgency/Impact are not on the agent Edit screen
by default).

### EC-396-006: `allowedValues` empty for `option`-type field

No `allowedValues` means the field has no configured options (unusual but possible).
UserError exit 64: "field 'NAME' has no configured option values. Confirm the field is
set up correctly in your Jira project admin."

### EC-396-007: Unknown select option value

UserError exit 64 with the allowed-values list (see Section 6 Step 4a).

### EC-396-008: `--field` with empty value (`--field NAME=`)

Allowed — same behaviour as on JSM create path (BC-3.8.008): empty string. The empty
string is sent to Jira; Jira rejects it server-side for required fields. For optional
string fields, an empty value effectively clears the field on many Jira instances (Jira
Cloud behaviour; not guaranteed). No special `jr`-side validation.

### EC-396-009: Number field with non-numeric value

`VALUE.parse::<f64>()` fails → UserError exit 64 with parse error.

### EC-396-010: `list_fields()` API failure

On 401/403/5xx from `GET /rest/api/3/field`, propagate as-is (`?` operator). The error
surfaces as a standard auth-or-API error with the existing error-hint infrastructure (
`API_TOKEN_EXPIRY_HINT` on 401, raw API message on other statuses).

### EC-396-011: `get_editmeta` API failure

Same propagation as EC-396-010. A 404 here means the issue key itself does not exist; the
error message from Jira is surfaced unchanged.

### EC-396-012: `--field` `customfield_NNNNN` literal with no `editmeta` entry

Even the literal-bypass path must pass through the `editmeta` lookup (Step 3). If
`customfield_NNNNN` is absent from `editmeta.fields`, emit the same actionable error as
EC-396-005 (using `customfield_NNNNN` as the field name in the message).

---

## Resolution Order and Execution Sequence

The `resolve_edit_fields` helper runs AFTER all existing single-key field resolutions (team,
points, parent, description, etc.) and BEFORE `client.edit_issue(key, fields)`. The merged
result is folded into the same `fields` json object used by all other flags.

Rationale for running after other flags: the `editmeta` call is only made when `--field` is
present; adding it unconditionally would add a latency hit to every `issue edit` invocation.

Execution sequence within `handle_edit` single-key path (updated):
1. Guard: `has_any_field_change` (updated to include `!field_pairs.is_empty()`).
2. C-1 multi-key rejection (updated to include `--field`).
3. Existing field resolutions (description, summary, issue_type, priority, team, points,
   no_points, parent, no_parent).
4. NEW: `resolve_edit_fields(client, key, &field_pairs, &mut fields, &mut changed_fields).await?`
5. `client.edit_issue(key, fields).await` (unchanged).
6. Success echo (unchanged shape, now includes `--field` entries in `changed_fields`).

---

## Behavioral Contracts Required

### New BCs (to be added to `bc-3-issue-write.md` Section 3.4)

**BC-3.4.015** (proposed): `issue edit KEY --field NAME=VALUE` (single-key, string/number
field) — resolves `NAME` to `customfield_NNNNN`, confirms field is on Edit screen via
`editmeta`, serialises `VALUE` per schema type, PUTs the field; success echoes
`  NAME → VALUE` in table mode and includes `{"NAME": "VALUE"}` in
`changed_fields` in JSON mode. `customfield_NNNNN` literal in `NAME` bypasses name
resolution. Exit 0.

**BC-3.4.016** (proposed): `issue edit KEY --field NAME=VALUE` (single-key, single-select
`option` field) — resolves the select option value to its `allowedValues[].id`; wire
payload is `{"customfield_NNNNN": {"id": "<optionId>"}}`. Table echo shows the human
option value (not the id). JSON `changed_fields` shows the human option value. Exit 0.
Error cases: field absent from `editmeta` (exit 64, actionable hint), unknown option value
(exit 64, allowed-values list in message), type unsupported in v1 (exit 64).

**BC-3.4.017** (proposed): `--field` with multi-key or `--jql` multi-issue set — rejected
by C-1 guard, exit 64, same error message pattern as existing bulk-rejection flags.

These three BCs raise `bc-3` `definitional_count` from 71 to 74 and `total_bcs` from 100
to 103. `CANONICAL-COUNTS.md` grand total rises from 580 to 583.

---

## Regression Risk Analysis

### High-risk surface: `handle_edit` single-key path (lines 778-982)

This path carries BC-3.4.003..014 contracts plus new BC-3.4.015..017. The `fields` JSON
object manipulation is shared with existing flag handling — an incorrect merge could
corrupt an otherwise valid field update. The risk is mitigated by:
- `resolve_edit_fields` runs after all existing flag blocks, never overwriting the shared
  `fields` object for keys already set (unless the user explicitly passes a `--field` pair
  that overlaps a dedicated flag — EC-396-004, caught by the overlap guard).
- `editmeta` validation confirms the field is on the Edit screen before the PUT is
  attempted, avoiding opaque 400s from Jira.

### Medium-risk surface: `has_any_field_change` guard expansion

Adding `!field_pairs.is_empty()` to the guard ensures `--field` alone (without other
flags) satisfies the "at least one change" requirement. The guard is covered by the
existing compile-time membership test (the `SELECTORS` / `BULK_SUPPORTED` /
`REJECTED_IN_BULK` partition test in `create.rs:1435+`). The new flag must be added to
`REJECTED_IN_BULK` and the C-1 rejection block in lockstep or a test assertion fires at
compile time.

### Low-risk surface: clap `IssueCommand::Edit` variant

Adding a `field: Vec<String>` member to the `Edit` variant affects the exhaustive
destructure in `handle_edit`. Rust will fail to compile if the destructure is not updated,
making this risk purely compile-time.

### Existing tests unaffected

- `tests/issue_edit_echo.rs` — No mock for `GET .../editmeta`; no `--field` flag. Unaffected.
- `tests/issue_edit_no_parent.rs` — Tests `--no-parent` + `--type` error paths. No `--field`. Unaffected.
- `tests/issue_edit_type_errors.rs` — Error paths for `--type`. No `--field`. Unaffected.
- `tests/issue_commands.rs` — Client-level unit tests on wire body shape; no handler-level dispatch. Unaffected.
- `tests/cli_handler.rs` — Uses `handle_edit` fixture indirectly via `jr_cmd`; no `--field`. Unaffected as long as the destructure compiles.

### `parse_field_kv` reuse

`parse_field_kv` is already `pub(crate)` (it is used by `handle_jsm_create`). It can be
called unchanged from `resolve_edit_fields` to parse the raw `Vec<String>` flag values
into `HashMap<String, String>`. No signature change needed.

---

## Module Placement Decision

**Human gate question Q5 (architectural):** Where should `resolve_edit_fields` live?

Two options:
- **Option A (preferred):** New function in `src/cli/issue/helpers.rs`. Already hosts
  `resolve_team_field`, `resolve_story_points_field_id`, and the full `resolve_user` /
  `resolve_assignee` stack. Field resolution is the same "CLI-level orchestration"
  concern. `helpers.rs` is 833 LOC — adding ~80-120 LOC keeps it below 1,000.
- **Option B:** New file `src/cli/issue/field_resolve.rs`. Justified if the function
  grows to include sub-helpers (allowed-value resolution, type-dispatch) that would push
  `helpers.rs` toward the documented deviation threshold. The split could be deferred to
  the implementation phase.

Recommendation: Option A for initial implementation; extract to `field_resolve.rs` if
helpers.rs exceeds 1,000 LOC after the addition.

---

## `editmeta` API Call Timing and Latency

Calling `GET .../editmeta` adds one HTTP round-trip to every single-key `issue edit`
invocation that includes `--field`. It is NOT called when `--field` is absent. Existing
edit invocations without `--field` are byte-for-byte unchanged in behaviour and latency.

The `editmeta` response can be 10-100 KB for issues with many custom fields. No client-side
caching is planned for v1 (the Edit screen configuration is mutable; stale cache could
produce wrong allowed-value IDs). The round-trip adds ~100-500 ms in typical Atlassian
Cloud latency — acceptable for a CLI command.

---

## CLAUDE.md Update Required

A new Gotcha entry must be added to `CLAUDE.md` covering:
1. `--field` on `issue edit` is single-key only (rejected in bulk with C-1 guard).
2. Changing the **Request Type** of an existing JSM issue is NOT supported via any Jira
   Cloud API. `jr issue edit --field` does NOT support the `sd-customerrequesttype` system
   field. Source: JSDCLOUD-4609 (open since 2016, "Gathering Interest"); PUT of this field
   is known to return HTTP 500. The field will be rejected by the `editmeta` absent-field
   guard or produce a 500 API error regardless.
3. JSM Urgency/Impact and other request-type select fields CAN be set via
   `jr issue edit --field NAME=VALUE` provided the field is on the issue's agent Edit
   screen. By default, these fields are on the portal request form only; an admin must
   add them to the Edit screen.
4. `--field` on `issue edit` uses `editmeta` to validate the field and resolve
   `allowedValues`. The `GET .../editmeta` call adds one HTTP round-trip when `--field`
   is set; it is skipped when `--field` is absent.

---

## Open Questions for Human Gate

| # | Question | Recommendation | Blocking? |
|---|----------|---------------|-----------|
| Q1 | Should field-name resolution use `partial_match::match_single` or a bespoke matcher? | Bespoke (deterministic, no interactive prompt on ambiguity) | No — implement bespoke; can be revisited |
| Q2 | Should `date`/`datetime` values receive client-side ISO 8601 validation? | No — defer to Jira server-side validation | No |
| Q3 | Should `--field Assignee=me` resolve "me" to current user's accountId? | No — v1 requires raw accountId; "me" in v2 | No |
| Q4 | Should `--field Summary=X --summary Y` (overlapping flags) be a UserError? | YES — detect and reject (exit 64) to prevent silent overwrite | YES — affects implementation design |
| Q5 | Where should `resolve_edit_fields` live: `helpers.rs` or new `field_resolve.rs`? | Option A (`helpers.rs`) unless LOC would exceed ~1,000 | No |
| Q6 | Should the `list_fields()` result be fetched once per `issue edit` invocation (even if multiple `--field` pairs) or once per pair? | Once per invocation (all pairs share the same global field catalog) | No — implement once-per-invocation |
| Q7 | Should `--field` overlap guard (Q4) cover ALL dedicated flags or just first-party string-keyed fields (summary, description, issuetype, priority)? | All four first-party Jira field keys that map 1:1 to a `customfield_NNNNN` or system field key. Team and points use a dynamically resolved field id; overlap detection for these would require resolving the team/points field id first — defer to v2. | No |

---

## Summary for Human Gate

This is a **standard enhancement** with medium regression risk. The core value is enabling
`jr issue edit --field Urgency=High` and similar patterns for any custom field that appears
on the issue's agent Edit screen — including JSM request-type fields like Urgency and
Impact — without any JSM-specific code path. The feature builds on the existing
`parse_field_kv` function (already used by the JSM create path), the existing
`list_fields()` method, and the existing `edit_issue()` method. The only new API call is
`GET .../editmeta`, which is used for field-presence validation and `allowedValues`
resolution.

The critical open question for the gate is **Q4**: whether `--field Summary=X --summary Y`
(overlapping flags) should be a UserError. The recommended answer is YES; this affects how
`resolve_edit_fields` orders its conflict checks.

**Recommended field-type coverage for v1:** string, number, option (single-select), date,
datetime, user (pass-through). Array and CMDB types error with a clear message. This covers
the stated motivating use case (Urgency, Impact, and comparable JSM/Jira select fields)
completely.
