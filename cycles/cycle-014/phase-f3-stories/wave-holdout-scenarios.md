---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-014
feature: issue-triage-quickfixes
status: draft
producer: story-writer
created: 2026-09-26
inputs:
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-user-list-project-resolution.md"
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-api-query-param.md"
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-field-options-name-label.md"
  - ".factory/cycles/cycle-014/phase-f3-stories/wave-schedule.md"
  - ".factory/cycles/cycle-014/phase-f2-spec-evolution/verification-delta.md"
  - ".factory/specs/prd/cross-cutting.md"
  - "src/api/jira/fields.rs"
  - "src/api/jira/issues.rs"
  - "src/api/jira/users.rs"
  - "src/api/jsm/servicedesks.rs"
  - "src/api/pagination.rs"
  - "src/cli/api.rs"
  - "src/cli/field.rs"
  - "src/cli/mod.rs"
  - "src/config.rs"
  - "src/main.rs"
  - "src/types/jira/editmeta.rs"
  - "src/types/jira/user.rs"
  - "src/types/jsm/request_type.rs"
  - "src/types/jsm/servicedesk.rs"
traces_to: "BC-X.7.002; BC-X.16.001/002; BC-X.14.001/003/004; VP-USER-LIST-PROJECT-001; VP-API-QP-001..006; VP-580-013"
input-hash: "7e67e59"
---

# Wave Holdout Scenarios -- `issue-triage-quickfixes` (cycle-014)

Per-wave cross-story integration scenarios and full-cycle regression scenarios on existing
`jr user list`, `jr api`, and `jr field options` behavior, per the F3 workflow's requirement for
holdout coverage beyond each story's own ACs. Because delivery is strictly serial (D-381) and each
wave contains exactly one story, no SAME-wave cross-story composition exists to test (unlike
cycle-008's parallel Wave 1). Two scenarios below -- H-CYCLE14-W2-INT-002 and
H-CYCLE14-W3-INT-003 -- are deliberate WAVE-BOUNDARY cross-story compositions: each exercises a
prior wave's story running on top of a later wave's landed changes, proving the earlier story's
behavior survives the later story's shared-file edits (`cli/mod.rs`/`main.rs` for W2-INT-002; the
shared `Config::project_key` resolution pattern for W3-INT-003).

---

## Wave 1 (Story A: `S-cycle14-user-list-project-resolution`, #862)

### H-CYCLE14-W1-INT-001 -- `--project` resolution composes correctly with `--profile` and `--all`

**Setup:** Hermetic per verification-delta.md §2 (`JR_CONFIG_DIR`/`JR_CACHE_DIR` pointed at a
fresh `TempDir`; `JR_BASE_URL` pointed at the wiremock server; `JR_AUTH_HEADER` supplies auth;
ambient `JR_*` cleared except those four seams) -- clean cwd with no `.jr.toml` in it or any
ancestor. Two profiles configured (in the `JR_CONFIG_DIR`-rooted config file, mirroring
VP-USER-LIST-PROJECT-001(c)'s EC-X.7.002-5 setup, `.factory/specs/prd/cross-cutting.md`
~L881-884): `default` with its own default `project = "DEF"`, and `alt` with its own default
`project = "ALT"`. No local/global `--project` flag. Run `jr --profile alt user list --all`
against `GET /rest/api/3/user/assignable/multiProjectSearch`
(`search_assignable_users_by_project_all`, `src/api/jira/users.rs` ~L202-227; page size fixed at
`USER_PAGE_SIZE = 100`), matched on the query params below:
1. `startAt=0&maxResults=100&projectKeys=ALT` (plus `query=`, empty, since `handle_list` passes
   `""`) -- `.expect(1)` -- returns one user, a SHORT but non-empty page: `[{"accountId": "acc-1",
   "displayName": "Alice"}]` (`accountId`/`displayName` are `User`'s only non-`Option` members,
   `src/types/jira/user.rs`). Per JRACLOUD-71293 (CLAUDE.md Gotchas), a short non-empty page is NOT
   end-of-data, so a second page must still be requested.
2. `startAt=100&maxResults=100&projectKeys=ALT` -- `.expect(1)` -- returns an empty array `[]`,
   the only reliable end-of-data signal, terminating the loop at iteration 2 (well inside the
   15-iteration `USER_PAGINATION_SAFETY_CAP`).
3. A counter-mock on the same path matching `projectKeys=DEF` (the `default` profile's own
   configured project) -- `.expect(0)` -- proving no request is ever sent for the `default`
   profile's project. A second, catch-all counter-mock matching any OTHER `projectKeys` value (or
   the param omitted entirely) -- `.expect(0)` -- covers an unresolved-project fallback.

**Expectation:** Every page of the resulting `--all` pagination carries `projectKeys=ALT` (never
`projectKeys=DEF`, the `default` profile's own configured project) -- proving
`resolve_user_list_project`'s configured-default fallback (Postcondition 3) and the `--all`
pagination path (Postcondition 5) compose correctly, and that `handle`/`handle_list` genuinely use
the passed `&Config` rather than reloading it. Note this is NOT a "silent fallback to `default`"
proof: `Config::load_with`'s strict-mode profile-existence check (`src/config.rs` ~L354-364)
returns `JrError::UserError: unknown profile: ...` for any active-profile name absent from
`[profiles]`, so with only `alt` configured a reload bug would fail loudly, not silently resolve
`"default"`. Configuring a real `default` profile (with its own distinct project `DEF`) alongside
`alt`, as above, is what makes this scenario a genuine proof of `&Config` reuse: a reload bug
would now silently succeed against `default`'s `DEF` project instead of erroring out, and the
`projectKeys=DEF` counter-mock's `.expect(0)` is what catches that.

**MUST-PASS.**

---

## Wave 1 -- Regression Scenarios (Existing `jr user list` Behavior Unchanged)

### H-CYCLE14-W1-REG-001 -- `jr user search` and `jr user view` are untouched

**Setup:** Run the existing (pre-cycle-014, unmodified) test suites for `jr user search <query>`
and `jr user view <accountId>` against the post-cycle-014 binary.

**Expectation:** Both subcommands behave byte-for-byte identically -- this story's scope is
`UserCommand::List.project` only; `UserCommand::Search` and `UserCommand::View` have no `project`
field and are structurally untouched.

**MUST-PASS. Regression-critical.**

### H-CYCLE14-W1-REG-002 -- `jr user list`'s non-`--project` flags (`--limit`, `--all`) are unaffected

**Setup:** Run the existing `--limit`/`--all` local-cap and pagination tests for `jr user list`
against the post-cycle-014 binary. These existing tests
(`tests/user_pagination.rs::user_list_all_cli_paginates`,
`tests/user_pagination.rs::user_list_all_cli_emits_safety_cap_warning`,
`tests/all_flag_behavior.rs::user_list_default_caps_at_thirty`) all pass `--project` explicitly on
the command line -- none of them resolves the project via `.jr.toml` or the configured-profile
default. The configured-default `--all` path is a NEW cell, not a pre-existing one: it is covered
by STORY-A's new AC-007 (`S-cycle14-user-list-project-resolution.md`), whose Task 5 adds a second
`--all` pagination test in `tests/user_pagination.rs` specifically for the configured-default
variant (RED-at-stub).

**Expectation:** `--limit` capping and `--all` pagination behavior (result count, page-advance
logic per BC-X.2.005) are unchanged for the explicit-`--project` invocations these existing tests
exercise -- only the project-resolution step upstream of the HTTP call changes.

**MUST-PASS. Regression-critical.**

---

## Wave 2 (Story C: `S-cycle14-api-query-param`, #583)

### H-CYCLE14-W2-INT-001 -- `-q` composes correctly with `-H`/`--header` and `-d`/`--data`

**Setup:** Hermetic per verification-delta.md §2 (`JR_CONFIG_DIR`/`JR_CACHE_DIR` pointed at a
fresh `TempDir`, ambient `JR_*` cleared except the seams) -- clean cwd with no `.jr.toml` in it or
any ancestor. Run `jr api /rest/api/3/search -X POST -d '{"jql":"project=FOO"}' -H "X-Custom: 1"
-q maxResults=50 -q fields=summary,status` against a `jr api` passthrough mock on `POST
/rest/api/3/search` returning any 200 JSON body (e.g. `{}`) -- `jr api` writes the raw response
bytes straight through and this scenario asserts only the OUTGOING request, so the response body
carries no structural requirement.

**Expectation:** The received request has: the POST method; body exactly `{"jql":"project=FOO"}`
(unaffected by `-q`); the `X-Custom: 1` header (unaffected by `-q`); and a query string of exactly
`maxResults=50&fields=summary%2Cstatus` (two pairs, comma preserved as literal VALUE content in
the second, per EC-X.16.001-13). This is the direct end-to-end proof that `-q`'s new pre-flight
step (inserted between `normalize_path` and `resolve_body`/`parse_header`) does not disturb the
existing body/header assembly it now runs ahead of.

**MUST-PASS.**

### H-CYCLE14-W2-INT-002 -- After Wave 2, the global `--project` flag stays correctly scoped: it does not leak into `jr api`, and Story A's `user list` still resolves it

**Setup:** Hermetic per verification-delta.md §2 (`JR_CONFIG_DIR`/`JR_CACHE_DIR` pointed at a
fresh `TempDir`, ambient `JR_*` cleared except the seams) -- clean cwd with no `.jr.toml` in it or
any ancestor. After Wave 2 (Story C) lands on top of Wave 1 (Story A), against a profile with no
configured default project, run two read-only commands: (1) `jr --project FOO api
/rest/api/3/myself -q x=1`, against a `jr api` passthrough mock on `GET /rest/api/3/myself`
returning any 200 JSON body (e.g. `{}`); (2) `jr --project FOO user list`, against a mock on `GET
/rest/api/3/user/assignable/multiProjectSearch` matched on query params `query=` (empty) and
`projectKeys=FOO` -- `user list` with no `--all` calls `search_assignable_users_by_project`
(`src/api/jira/users.rs` ~L144-165), the single-page variant, which sends no `startAt`/`maxResults`
params at all -- returning `[{"accountId": "acc-2", "displayName": "Bob"}]` (`accountId`/
`displayName` are `User`'s only non-`Option` members, `src/types/jira/user.rs`).

**Expectation:** For (1), the received request's query string is exactly `x=1` and the command
exits 0 -- the global `--project FOO` value is NOT appended to, injected into, or otherwise
reflected in the `jr api` request's path, query string, or body. This is structurally guaranteed,
not incidental: `src/cli/api.rs`'s `handle_api` and its helpers (`normalize_path`, `parse_header`,
`resolve_body`, and Story C's new `append_query_params`/`parse_query_param`) never reference
`project` at all, and `src/main.rs::run`'s `Command::Api` dispatch arm (~L493-503) does not pass
`cli.project` to `cli::api::handle_api` -- unlike sibling arms such as `Command::Queue` or
`Command::Component`, which do thread `cli.project.as_deref()` through. For (2), the request
carries `projectKeys=FOO` and succeeds exactly as it did immediately after Wave 1 -- proving Story
C's `cli/api.rs` dispatch changes and its `cli/mod.rs`/`main.rs` flag-wiring edits (adding
`-q`/`--query-param` to the `jr api` subcommand) did not perturb `UserCommand::List`'s clap wiring
or `resolve_user_list_project`'s call site. This is a genuine cross-story composition at the wave
boundary, distinct from EC-X.7.002-2's own cell (VP-USER-LIST-PROJECT-001(c), which exercises the
same "global `--project` only" input but scoped to `user list` alone, before Story C ever lands):
neither that cell nor VP-API-QP-001..006 (scoped to `jr api` in isolation, never exercised
alongside a global `--project` flag) proves that the global flag remains correctly scoped -- live
for the command that reads it, inert for the one that doesn't -- once both stories' shared
dispatch-file edits have landed together. Per the standing holdout convention, this uses read-only
commands only, no live mutations, and no real Jira keys/URLs.

**MUST-PASS.**

---

## Wave 2 -- Regression Scenarios (Existing `jr api` Behavior Unchanged)

### H-CYCLE14-W2-REG-001 -- Zero-`-q` invocations are byte-identical to pre-cycle-014 `jr api`

**Setup:** Run the existing (pre-cycle-014, unmodified) `jr api` tests -- both (a) the inline
`#[cfg(test)] mod tests` unit tests in `src/cli/api.rs` (~L185-354: `normalize_path`
trimming/slash/URL-rejection cells, `parse_header` cells, `resolve_body` cells for
`@file`/`@-`/inline JSON) and (b) the genuine `assert_cmd`-driven integration tests in
`tests/cli_handler.rs` covering raw-response passthrough (BC-X.1.007) and method
case-insensitivity (BC-X.1.011, the `-X delete`/`-X Delete`/`-X DELETE` cells) -- against the
post-cycle-014 binary, supplying no `-q`/`--query-param` flag at all.

**Expectation:** Every existing test passes unmodified -- the path handed to the request is
byte-identical to `normalize_path`'s own output (`append_query_params(p, &[]) == p`), and no
existing `jr api` behavior (body resolution, header parsing, raw response passthrough, method
case-insensitivity) is altered by this story's additions.

**MUST-PASS. Regression-critical.**

### H-CYCLE14-W2-REG-002 -- `jr api` with `-q` plus `--output json`: success-path output unchanged

**Setup:** Hermetic per verification-delta.md §2 (`JR_CONFIG_DIR`/`JR_CACHE_DIR` pointed at a
fresh `TempDir`, ambient `JR_*` cleared except the seams) -- clean cwd with no `.jr.toml` in it or
any ancestor. Run `jr api /rest/api/3/myself -q expand=groups --output json` against a `jr api`
passthrough mock on `GET /rest/api/3/myself` returning a normal 200 JSON body (e.g. `{"accountId":
"acc-1"}` -- any JSON is acceptable, since this is a `jr api` passthrough mock).

**Expectation:** `jr api` writes the raw response bytes straight to stdout via `std::io::stdout()
.write_all(&body_bytes)` (`src/cli/api.rs` ~L162) on every success-path response -- it never routes
through `output::render_json`/`output::print_output`, and `--output json` has no effect on this
command's success-path output at all. The bytes written are therefore byte-for-byte identical
between `jr api /rest/api/3/myself -q expand=groups --output json` and `jr api
/rest/api/3/myself -q expand=groups` (no `--output json`), and both are byte-for-byte identical to
what `jr api /rest/api/3/myself` (no `-q` at all) would write for the same mocked body -- proving
the new `-q` pre-flight step only affects the OUTGOING request path (`append_query_params`) and
that `jr api`'s raw-passthrough success-path output is orthogonal to both `-q` and `--output json`.
Neither VP-API-QP-003(e) (the `--help` text pin) nor the other VP-API-QP cells prove the
query-param feature leaves this raw-passthrough behavior undisturbed.

**MUST-PASS.**

---

## Wave 3 (Story B: `S-cycle14-field-options-name-label`, #861)

### H-CYCLE14-W3-INT-001 -- A real `priority`-shaped fixture round-trips through `--type`, `--value`, and `--output json`

**Setup:** Hermetic per verification-delta.md §2 (`JR_CONFIG_DIR`/`JR_CACHE_DIR` pointed at a
fresh `TempDir`, ambient `JR_*` cleared except the seams) -- so the per-profile fields cache starts
cold. Run `jr field options Priority --type Task --project FOO --value high --output json` against
three mocks, in call order:
1. `GET /rest/api/3/field` (`resolve_field_id`'s cache-miss fallback to `list_fields()`,
   `src/cli/field.rs` ~L136) -- `Priority` is not a `customfield_NNNNN` literal, so this call fires
   unconditionally on the cold cache. Concrete mock body (a bare array -- `list_fields()`
   deserializes `Vec<Field>` directly, no envelope): `[{"id": "priority", "name": "Priority"}]`.
   `id`/`name` are `Field`'s only non-`Option` members (`src/api/jira/fields.rs::Field` ~L7-12 --
   `custom`/`schema` are both `Option`, omitted here).
2. `GET /rest/api/3/issue/createmeta/FOO/issuetypes` (`get_issue_types_for_project`,
   `src/api/jira/issues.rs` ~L1072) -- the mock's `issueTypes` array must contain an entry named
   `Task` (case-insensitive match) with its own `id`, which the next call's URL then uses.
   Concrete mock body: `{"issueTypes": [{"id": "10001", "name": "Task"}]}`. `IssueTypeEntry`
   requires `id` and `name` (`src/api/jira/issues.rs` ~L1273-1277, both non-`Option`);
   `CreatemetaIssueTypesResponse.total` is `#[serde(default)]` (`src/api/jira/issues.rs`
   ~L1288-1296), so it is safely omitted. `10001` is the `<Task-issue-type-id>` the next mock's
   URL uses.
3. `GET /rest/api/3/issue/createmeta/FOO/issuetypes/10001` (`get_createmeta_fields`,
   `src/api/jira/issues.rs` ~L1156) -- returning a `fields` array containing the `priority` field
   whose `allowedValues` entries carry `name` (e.g. `"High"`, `"Highest"`) but no `value`, per the
   original scenario. Concrete mock body: `{"fields": [{"fieldId": "priority", "name": "Priority",
   "schema": {"type": "priority"}, "allowedValues": [{"name": "High"}, {"name": "Highest"}]}]}`.
   `CreateMetaField` requires `fieldId`, `name`, and `schema` (`src/api/jira/issues.rs`
   ~L1234-1245); `schema` is `EditMetaFieldSchema`, whose only non-`Option` member is `type`
   (`src/types/jira/editmeta.rs` ~L54-62 -- `system`/`custom` are both `Option`, omitted here).
   `allowedValues` entries have no required fields at all (`AllowedValue`, `src/types/jira/
   editmeta.rs` ~L79-96 -- `id`/`value`/`name` are all `Option`, `children` defaults to `[]`).
   `CreateMetaFieldsResponse.total` is likewise `#[serde(default)]` (`src/api/jira/issues.rs`
   ~L1257-1263) and safely omitted; the top-level key is `fields` (`results` is also accepted via
   `#[serde(alias = "results")]`, but this literal uses the primary key).

No fourth mock is needed for project resolution itself: `--project FOO` is passed explicitly, so
`resolve_m2_project` calls `config.project_key(Some("FOO"))`, which returns the flag override;
zero HTTP.

**Expectation:** The JSON output's `label` field for each matching entry is the real name string
(e.g. `"High"`, `"Highest"`), not `null` -- and `--value high` matches BOTH `"High"` and
`"Highest"` (case-insensitive substring, per EC-X.14.001-13's own noted caveat) -- proving the
label fallback (AC-001) and the unmodified `--value` filter (AC-003) compose correctly end-to-end
through the full M2 dispatch path, not just at the unit level of `normalize_from_allowed_values_at_depth`
in isolation.

**MUST-PASS.**

### H-CYCLE14-W3-INT-002 -- The fallback does not leak into the M3 (`--request-type`) dispatch path

**Setup:** Hermetic per verification-delta.md §2 (`JR_CONFIG_DIR`/`JR_CACHE_DIR` pointed at a
fresh `TempDir`, ambient `JR_*` cleared except the seams) -- so the per-profile fields cache and
the `get_or_fetch_project_meta` project-meta cache both start cold. Run `jr field options Urgency
--request-type "Get IT Help" --project FOO --output json` against five mocks, in call order:
1. `GET /rest/api/3/field` (`resolve_field_id`'s cache-miss fallback to `list_fields()`,
   `src/cli/field.rs` ~L136) -- `Urgency` is not a `customfield_NNNNN` literal, so this call fires
   unconditionally on the cold cache. Concrete mock body (bare array, `list_fields()`
   deserializes `Vec<Field>` directly): `[{"id": "customfield_10050", "name": "Urgency"}]` --
   `id`/`name` are `Field`'s only non-`Option` members (`src/api/jira/fields.rs::Field` ~L7-12);
   `id` matches the `fieldId` used in mock 5's `validValues`-bearing field descriptor below.
2. `GET /rest/api/3/project/FOO` (`get_or_fetch_project_meta`'s cache-miss fetch, called from
   `servicedesks::require_service_desk`, `src/api/jsm/servicedesks.rs` ~L41-52) -- this call
   deserializes to a raw `serde_json::Value`, not a typed struct, so no field is structurally
   required by serde; a `projectTypeKey` other than `"service_desk"` short-circuits
   `require_service_desk` with an exit-64 UserError before any further mock is consulted, so its
   VALUE is load-bearing even though its PRESENCE isn't type-enforced. Concrete mock body:
   `{"projectTypeKey": "service_desk", "id": "1000"}`.
3. `GET /rest/servicedeskapi/servicedesk` (`list_service_desks`, called because step 2's
   `project_type == "service_desk"`, `src/api/jsm/servicedesks.rs` ~L12-32) -- deserializes to
   `ServiceDeskPage<ServiceDesk>` (`src/api/pagination.rs::ServiceDeskPage` ~L88-98), which
   requires `size`, `start`, `limit`, and `isLastPage` (`values` defaults to `[]`); `ServiceDesk`
   (`src/types/jsm/servicedesk.rs` ~L4-9) requires `id`, `projectId`, `projectName` -- all
   non-`Option`. Concrete mock body: `{"size": 1, "start": 0, "limit": 50, "isLastPage": true,
   "values": [{"id": "2000", "projectId": "1000", "projectName": "FOO"}]}`. `projectId` (`1000`)
   matches mock 2's `id`, so `get_or_fetch_project_meta` resolves `service_desk_id == "2000"`.
4. `GET /rest/servicedeskapi/servicedesk/2000/requesttype` (`resolve_request_type_id` ->
   `list_request_types`, `src/cli/field.rs` ~L540; fires because `"Get IT Help"` is not
   all-ASCII-digit and so is not treated as a numeric request-type id) -- also a
   `ServiceDeskPage<T>` envelope, this time of `RequestType` (`src/types/jsm/request_type.rs`
   ~L22-29), which requires `id` and `name` (`description`/`helpText`/`issueTypeId` are `Option`,
   `groupIds` defaults to `[]`). Concrete mock body: `{"size": 1, "start": 0, "limit": 50,
   "isLastPage": true, "values": [{"id": "3000", "name": "Get IT Help"}]}` -- `"Get IT Help"` is
   what `partial_match::partial_match` resolves exactly.
5. `GET /rest/servicedeskapi/servicedesk/2000/requesttype/3000/field`
   (`get_request_type_fields`) -- deserializes to `RequestTypeFieldsResponse`
   (`src/types/jsm/request_type.rs` ~L59-63), which requires `canRaiseOnBehalfOf` and
   `canAddRequestParticipants` (both plain `bool`, no default) plus `requestTypeFields` (a `Vec`
   with no `#[serde(default)]`, so the key itself is required); each `RequestTypeField`
   (`src/types/jsm/request_type.rs` ~L35-54) requires `fieldId`, `name`, `required` (bool), and
   `jiraSchema` (`visible` defaults to `false`; `description`/`defaultValues`/`validValues`/
   `autoCompleteUrl` are all `Option`). Concrete mock body: `{"canRaiseOnBehalfOf": false,
   "canAddRequestParticipants": false, "requestTypeFields": [{"fieldId": "customfield_10050",
   "name": "Urgency", "required": false, "jiraSchema": {"type": "option"}, "validValues":
   [{"id": "1", "value": "high", "label": "High", "name": "High Priority"}, {"id": "2", "value":
   "medium", "name": "Medium Priority"}]}]}` -- the `validValues` array carries exactly two
   entries: the first (a `label`-bearing entry that ALSO happens to carry a `name`, and an `id`
   distinct from its `value`) and the second (a `{value, name}`-only entry with NO `label` key at
   all).

**Expectation:** The JSON output is exactly:
```json
[
  {"id": "high", "label": "High", "children": []},
  {"id": "medium", "label": null, "children": []}
]
```
`FieldOption.id` comes from the wire's `value` key, NOT its `id` key (`normalize_from_valid_values`,
`src/cli/field.rs` ~L684: `let id = v.get("value").and_then(|x| x.as_str()).map(str::to_string);`)
-- so the fixture's wire-level `"id": "1"`/`"id": "2"` fields are dead weight the code never reads;
they are included only to prove they are ignored. The first entry's `label` is `Some("High")` --
read from the wire's `label` field, with the sibling `name: "High Priority"` field ignored
entirely. The second entry's `label` is `null` -- `normalize_from_valid_values` has no `name`
fallback (unlike M1/M2's `normalize_from_allowed_values`), so a `{value, name}`-only entry with no
`label` degrades to `None`/`null` exactly as pre-cycle-014, even though `name` is present on the
wire. This proves this story's read-side fix, applied to `normalize_from_allowed_values_at_depth`
(M1/M2 only), has zero effect on `normalize_from_valid_values` (M3), end-to-end through the real
`--request-type` dispatch fork, not just AC-004's isolated unit regression.

**MUST-PASS.**

### H-CYCLE14-W3-INT-003 -- `jr --profile alt field options …` resolves `--project` from the same per-profile default Story A's `user list` fix relies on, and Story B's name-only label fallback fires on that request

**Setup:** Hermetic per verification-delta.md §2 (`JR_CONFIG_DIR`/`JR_CACHE_DIR` pointed at a
fresh `TempDir`, ambient `JR_*` cleared except the seams) -- so the per-profile fields cache starts
cold, independent of the profile-default-project setup below. A profile `alt` configured with its
own default `project = "ALT"`, no `.jr.toml` in cwd or any ancestor, and no local/global
`--project` flag. After Wave 3 lands, run `jr --profile alt field options Priority --type Task
--output json` against three mocks, in call order:
1. `GET /rest/api/3/field` (`resolve_field_id`'s cache-miss fallback to `list_fields()`,
   `src/cli/field.rs` ~L136) -- `Priority` is not a `customfield_NNNNN` literal, so this call fires
   unconditionally on the cold cache. Concrete mock body (bare array): `[{"id": "priority", "name":
   "Priority"}]` -- `id`/`name` are `Field`'s only non-`Option` members (`src/api/jira/
   fields.rs::Field` ~L7-12).
2. `GET /rest/api/3/issue/createmeta/ALT/issuetypes` (`get_issue_types_for_project`,
   `src/api/jira/issues.rs` ~L1072) -- the mock's `issueTypes` array must contain an entry named
   `Task` (case-insensitive match) with its own id, which the next call's URL then uses. Concrete
   mock body: `{"issueTypes": [{"id": "10002", "name": "Task"}]}` -- `IssueTypeEntry` requires
   `id` and `name` (`src/api/jira/issues.rs` ~L1273-1277); `10002` is the `<Task-issue-type-id>`
   the next mock's URL uses.
3. `GET /rest/api/3/issue/createmeta/ALT/issuetypes/10002` (`get_createmeta_fields`,
   `src/api/jira/issues.rs` ~L1156) -- the resolution-target createmeta response, whose `priority`
   field's `allowedValues` entries carry `name` only, no `value` key at all (the real-world
   `priority` shape, EC-X.14.001-8, that Story B's fix targets). Concrete mock body: `{"fields":
   [{"fieldId": "priority", "name": "Priority", "schema": {"type": "priority"}, "allowedValues":
   [{"id": "1", "name": "Highest"}, {"id": "2", "name": "High"}]}]}` -- `CreateMetaField` requires
   `fieldId`, `name`, and `schema` (`src/api/jira/issues.rs` ~L1234-1245); `schema` is
   `EditMetaFieldSchema`, whose only non-`Option` member is `type` (`src/types/jira/editmeta.rs`
   ~L54-62).

**Expectation:** M2's `resolve_m2_project(cli_project, config)` (`src/cli/field.rs` ~L617-619,
`pub(crate) fn resolve_m2_project(cli_project: Option<&str>, config: &Config) -> Option<String> {
config.project_key(cli_project) }`) resolves `cli_project: None` to `config.project_key(None) ==
Some("ALT")` -- the SAME `Config::project_key` per-profile-default fallback Story A's
`resolve_user_list_project` wraps for `user list`. This resolution is a pure config read with zero
HTTP; the project key `ALT` it produces is what mocks 2 and 3 above (`get_issue_types_for_project`
and `get_createmeta_fields`) are addressed to. The command therefore issues its
`GET …/rest/api/3/issue/createmeta/ALT/issuetypes/10002` createmeta request with
project key `ALT`, and the JSON output's `label` field for each entry is the real `name` string
(`"Highest"`, `"High"`), not `null` -- proving Story B's `normalize_from_allowed_values_at_depth`
fallback (`value.or(name)`) fires correctly on a request whose project came entirely from Story
A's shared `Config::project_key` accessor, with no `--project` flag and no `.jr.toml` present.
This is a genuine cross-story, cross-wave composition -- the exact scenario neither
VP-USER-LIST-PROJECT-001 (unit-scoped to `resolve_user_list_project`) nor VP-580-013 (scoped to
`field options`'s label-fallback fix in isolation) exercises together: both `user list` and `field
options` read the SAME `Config::project_key` accessor, and this proves Story A's clap-arity change
(which touches only `UserCommand::List.project` in `src/cli/mod.rs` and the `Command::User` arm in
`src/main.rs` ~L434-439) leaves M2's independent `resolve_m2_project` call site (a different
dispatch arm entirely) unperturbed, while simultaneously proving Story B's read-side fallback
fires on that profile-resolved request. This scenario does NOT claim `field options` "never reads
project off `Config`" -- it does, via `resolve_m2_project` -- nor that the two commands share one
dispatch path; they are separate `main.rs` match arms that happen to read the same `Config`
accessor.

**MUST-PASS.**

---

## Wave 3 -- Regression Scenarios (Existing `jr field options` Behavior Unchanged)

### H-CYCLE14-W3-REG-001 -- Custom select fields (the pre-#861 use case) are unaffected

**Setup:** Run the existing (pre-cycle-014, unmodified) `jr field options` test suite for a
CUSTOM select field whose `allowedValues` entries carry `value` only (not `name`) -- the original
S-580-1 use case, covered by the tests that consume the `tests/field_options.rs::createmeta_field_10084`
fixture builder (both entries carry `"value"` alongside an explicit `"name": null`):
`test_bc_x_14_001_m2_resolves_via_profile_default_project`,
`test_bc_x_14_001_m2_type_resolution_reused_from_s331`,
`test_bc_x_14_001_get_createmeta_fields_paginates_all_pages`,
`test_bc_x_14_001_get_createmeta_fields_continues_pagination_when_total_absent`, and
`test_bc_x_14_001_get_createmeta_fields_empty_page_terminates_not_infinite_loop` (all in
`tests/field_options.rs`; `createmeta_field_10084` itself is a fixture builder, not a test) --
and the "neither field present" case, covered
by `src/cli/field.rs::test_bc_x_14_001_normalizer_never_drops_degenerate_entries`'s fourth fixture
entry (`id: None, value: None, name: None`).

**Expectation:** Every existing test passes unmodified -- `label` resolves to `value` for the
value-only entries exactly as before (the pre-existing base contract), and to `None` for the
neither-field entry (EC-X.14.001-10, unchanged). This story only changes the behavior for the
`name`-only, no-`value` case (EC-X.14.001-8 -- the real-world `priority` shape), which did not
previously exist as a passing custom-field scenario (it degraded to `null`/`"(unnamed)"`
pre-fix). The `value`-and-`name`-BOTH-populated case (EC-X.14.001-9 -- proving `value` wins over
`name` per the strict first-match-wins `.or_else` order) is NOT exercised by this pre-existing
suite: no fixture in `src/cli/field.rs` or `tests/field_options.rs` ever populates `name` at all
pre-cycle-014 -- `AllowedValue.name` was parsed but "unused in v1 resolution logic"
(`src/types/jira/editmeta.rs` ~L83-86). EC-X.14.001-9 is owned by VP-580-013(1) / STORY-B test
1a's value-only/name-only/both/neither matrix, not by this regression scenario.

**MUST-PASS. Regression-critical.**

### H-CYCLE14-W3-REG-002 -- `--type`/`--request-type`/`--issue` mode-selector arity and error taxonomy are unaffected

**Setup:** Run the existing BC-X.14.001/004 mode-selector arity tests (none/multiple mode flags,
empty `<field>`, ambiguous/zero-match field-name resolution) against the post-cycle-014 binary.

**Expectation:** All exit-64 arity and error-taxonomy behavior (BC-X.14.004) is unchanged -- this
story's edit is confined to the label-resolution step inside the M1/M2 normalizer, downstream of
every mode-selector and field-name-resolution guard.

**MUST-PASS. Regression-critical.**

### H-CYCLE14-W3-REG-003 -- The test being renamed by AC-007 still exercises the same behavior under its new name

**Setup:** `tests/field_options.rs::test_bc_x_14_001_field_name_human_name_resolves_via_partial_match`
(currently at ~L1534, pre-cycle-014, unmodified) is the OLD name AC-007 renames FROM, not a
preview of the new name -- AC-007 (`S-cycle14-field-options-name-label.md`, § "AC-007") specifies
**[CORRECTED pass-9, ADV-C14-F3-P9-010: cited by `~L401-402`, which pointed at the Narrative, not
AC-007 -- story files change often and are cited by heading, never by line, per the standing
convention]**
only that the corrected name must reflect `search_field_list` (the actual resolution algorithm),
not a literal target string. After the AC-007 rename lands, run the renamed test (under whichever
new name the implementer chooses per that description).

**Expectation:** The test's ASSERTIONS are unchanged (only its name and doc comment are
corrected) -- it still proves a human-name `<field>` resolves via `search_field_list`'s
exact-then-substring algorithm. A diff review confirms zero assertion-line changes, name/comment
lines only, and that the OLD name
(`test_bc_x_14_001_field_name_human_name_resolves_via_partial_match`) no longer appears in
`tests/field_options.rs` after the rename.

**SHOULD-PASS** (a process-discipline check on the rename's scope, not a new runtime behavioral
proof in its own right).

---

## Full-Cycle Regression Scenario (All Three Waves Combined)

### H-CYCLE14-REG-FULL -- The full pre-existing test suite passes after all three stories land

**Setup:** After Wave 3 (B) merges, run the complete `cargo test` suite (unit, integration,
proptest, snapshot) on `develop`.

**Expectation:** 100% pass, zero regressions across the entire `jr` CLI surface -- not just the
three touched command families (`user`, `api`, `field`). This is the final full-cycle gate before
F5 (scoped adversarial review) begins.

**MUST-PASS. Regression-critical. Gates F5 dispatch.**
