---
document_type: story
level: ops
story_id: "S-580-1"
epic_id: "none"
title: "jr field options <field> command — M1/M2/M3 context-mechanism resolution + option enumeration"
wave: feature-followup
status: ready
intent: feature
feature_type: backend-cli
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 8
priority: P1
tdd_mode: strict
producer: story-writer
timestamp: "2026-08-26T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/cross-cutting.md"
  - ".factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md"
  - ".factory/phase-f2-spec-evolution/architecture-delta-field-dx.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-field-dx.md"
input-hash: "5699eaa"
traces_to: "src/cli/field.rs"
cycle: field-dx
bundle: field-dx
estimated_effort: large
estimated_days: 3
target_module: src/cli/field.rs
subsystems: ["SS-02", "SS-04"]
depends_on: []
blocks: [S-578-4]
behavioral_contracts:
  [BC-X.14.001, BC-X.14.002, BC-X.14.003, BC-X.14.004]
verification_properties:
  [VP-580-005, VP-580-006, VP-580-007, VP-580-008, VP-580-009, VP-580-010, VP-580-011, VP-580-012]
holdout_anchors: []
nfr_anchors: []
adr_refs: [ADR-0019]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/cross-cutting.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 14
assumption_validations: []
risk_mitigations: []
created: "2026-08-26"
version: "1.0"
last_updated: "2026-08-26"
breaking_change: false
retroactive: false
origin: >
  Feature Mode cycle field-dx, issues #580/#578 — part 1 of field-dx bundle (#580, #578).
  New top-level `jr field options <field>` command family (issue #580) enumerating a custom
  select field's allowed options with their machine option ids, so a caller can look up an
  id (e.g. for `--field NAME:id=<id>`, BC-3.4.028) BEFORE creating or editing a ticket,
  without an admin-gated API call. This is the FOUNDATION story of the bundle: it builds
  `get_createmeta_fields` in `src/api/jira/issues.rs`, which S-578-4 (platform `issue
  create --field`) reuses VERBATIM — do not let S-578-4 re-implement a second
  createmeta-fields fetcher. BC-X.14.005 (requesttype auto-expand nice-to-have) does not
  exist as an authored BC in `cross-cutting.md` §X.14 (only BC-X.14.001..004 are present) —
  it is explicitly OPTIONAL/deferred per F1 and is NOT built by this story.
changelog:
  - "1.0 (2026-08-26): Initial story authored; F2 gate convergence; bundle field-dx (issues #580/#578), wave 1."
---

> **tdd_mode:** strict — Red Gate required. Write all tests in `tests/field_options.rs`
> (new) first — they MUST fail because `src/cli/field.rs` does not exist yet. Then scaffold
> `Command::Field`/`FieldCommand` in `src/cli/mod.rs` + `src/main.rs` dispatch, then
> `resolve_field_context`/`resolve_m2_project` (pure, proptested), then
> `get_createmeta_fields` in `src/api/jira/issues.rs`, then the M1/M2/M3 handler dispatch,
> then the `FieldOption` normalizer + `--value` filter + table/JSON rendering. Red Gate:
> all tests FAIL → all tests PASS.

> **Execute:** `/vsdd-factory:deliver-story S-580-1`

# S-580-1: `jr field options <field>` — Context-Mechanism Resolution + Option Enumeration

**Bundle**: field-dx (issues #580, #578) — part 1 of 5
**GitHub issue**: #580
**BC anchors**: BC-X.14.001 (resolution + normalized `{id,label,children}` model), BC-X.14.002
(`--value` client-side filter), BC-X.14.003 (table/JSON output shape), BC-X.14.004 (error
taxonomy + graceful degradation)
**VPs**: VP-580-005, VP-580-006, VP-580-007, VP-580-008, VP-580-009, VP-580-010, VP-580-011,
VP-580-012
**Routing**: standard feature, Wave 1
**Sequencing**: no story dependencies; **blocks S-578-4** — S-578-4's `issue create --field`
platform-path resolution reuses `get_createmeta_fields` (built here) verbatim, per BC-3.3.010's
own Trace ("reuses `src/api/jira/issues.rs::get_createmeta_fields`... same `GET
.../createmeta/{proj}/issuetypes/{itid}` call, one implementation for both stories"). S-578-1
and S-578-2 have no code dependency on this story and are scheduled in parallel (S-578-1 in
Wave 1, S-578-2 in Wave 2).

**Subsystem anchor justification**: `subsystems: ["SS-02","SS-04"]` — SS-02 (CLI Layer) owns
this story's scope because it introduces the new top-level command module `src/cli/field.rs`
(dispatch, arg parsing, table/JSON rendering) per ADR-0019 §Context ("everything fits SS-02
(CLI Layer) and SS-04 (Jira API Resources)"). SS-04 (Jira API Resources) owns this story's
scope because it introduces the new `get_createmeta_fields` method on `src/api/jira/issues.rs`.
SS-05 (Assets/CMDB), also listed in ADR-0019's `subsystems_affected`, is NOT touched by this
story — the `:asset` hint's Assets reuse belongs to S-578-2/S-578-3/S-578-4, not `jr field
options` (which never composes an Assets object-reference array).

**Dependency anchor justification**: `depends_on: []` — this story is Wave 1 with no
prerequisite story; it only reuses existing, already-merged `jr` functions (`get_editmeta`,
`list_fields`, `get_issue_types_for_project`, `require_service_desk`,
`get_or_fetch_project_meta`, JSM request-type-fields plumbing). `blocks: [S-578-4]` — S-578-4
depends on `get_createmeta_fields` existing (built by this story) before it can resolve
`issue create --field` via createmeta; S-578-4's own story explicitly forbids re-implementing
a second createmeta-fields fetcher.

---

## Narrative

- **As a** `jr` CLI user preparing to create or edit a Jira issue that has a custom
  select/option field
- **I want** `jr field options <field>` to enumerate the field's allowed options together
  with their machine option ids, before I create or edit any ticket
- **So that** I can discover the exact option id or name to pass to `--field
  NAME:id=<id>` (BC-3.4.028) or `--field NAME:option=<value>` (BC-3.4.027) without guessing,
  hand-authoring JSON, or hitting the admin-gated `GET /field/{id}/context/{ctx}/option`
  endpoint that requires `manage:jira-configuration` + Administer Jira

---

## Behavioral Contracts

| BC | Summary | Clauses Covered |
|----|---------|-----------------|
| BC-X.14.001 | `jr field options <field> (--type <T> [--project <P>] \| --request-type <RT> [--project <P>] \| --issue <KEY>)` — exactly-one-mode-selector arity, per-mode resolution (M1 editmeta / M2 createmeta / M3 requesttype-fields), normalized `FieldOption{id,label,children}` model | Preconditions, Postconditions, Invariants 1–4, EC-X.14.001-1..7 |
| BC-X.14.002 | `--value <substring>` client-side case-insensitive filter against id/label; cascading children filtered independently | Inputs/Outputs/Errors, VP-580-007/011 |
| BC-X.14.003 | Table output (ID, Label columns, cascading indentation) / `--output json` normalized array; degenerate-entry rendering (`NULL_GLYPH`/`"(unnamed)"` table-mode only, raw `null` in JSON) | Behavior, Postconditions, degenerate-entry rendering block |
| BC-X.14.004 | Error taxonomy (mode-selector arity, incomplete-M2, unknown/ambiguous `--type`/`--request-type`/field name, project-not-found 404, field-absent-from-context) + graceful degradation (no enumerable options → exit 0 with hint) | Error taxonomy table, Precedence rules, Graceful degradation, EC-X.14.004-1..7 |

**BC-X.14.005 is explicitly out of scope.** `cross-cutting.md` §X.14 authors only
BC-X.14.001..004 — there is no BC-X.14.005 text to implement. Per the F1 delta analysis, a
"requesttype auto-expand" nice-to-have was considered and deferred; do not build any
auto-expand behavior into this story.

---

## Acceptance Criteria

### AC-001: Mode-selector mutual exclusion is a pure function, evaluated before any HTTP
(traces to BC-X.14.001 Invariant 1 postcondition, VP-580-006)

`resolve_field_context(has_type: bool, has_request_type: bool, has_issue: bool) ->
Result<Mode, ArityError>` is a pure function over the three mode-selector booleans ONLY —
`has_project`/`--project` is NOT a parameter. Exactly one of `--type`/`--request-type`/`--issue`
present → `Ok(Mode::{Createmeta,RequestType,Editmeta})`. Zero present → `Err`. Two or more
present → `Err`. Proptested exhaustively over the 3-boolean flag-presence space. Wiremock
integration confirms zero HTTP requests fire on any reject path.

**Test**: `test_bc_x_14_001_resolve_field_context_arity_proptest` (inline proptest) +
`test_bc_x_14_001_zero_mode_selectors_exits_64_zero_http` in `tests/field_options.rs`.

---

### AC-002: Zero mode selectors → exit 64 "specify exactly one of --type, --request-type, --issue"
(traces to BC-X.14.004 error taxonomy row "Zero mode selectors", VP-580-004 supplementary)

`jr field options customfield_10084` (no `--type`/`--request-type`/`--issue`) → exit 64;
stderr contains `"specify exactly one of --type, --request-type, --issue"`. A BARE `--project`
supplied alone (no mode selector at all) hits this SAME row, not the incomplete-M2 row —
`--project` is never counted as a mode selector.

**Test**: `test_bc_x_14_004_zero_mode_selectors_message` +
`test_bc_x_14_004_bare_project_no_mode_selector_is_zero_mode_error` in `tests/field_options.rs`.

---

### AC-003: Two or more mode selectors → exit 64, same message, listing conflicting flags
(traces to BC-X.14.001 Invariant 1 / BC-X.14.004 "Two or more mode selectors" row)

`jr field options customfield_10084 --issue FOO-1 --request-type "IT Help"` → exit 64; stderr
contains `"specify exactly one of --type, --request-type, --issue"`.

**Test**: `test_bc_x_14_001_two_mode_selectors_exits_64` in `tests/field_options.rs`.

---

### AC-004: M2 post-arity project resolution — flag OR profile/config default; neither → exit 64
(traces to BC-X.14.001 "M2 project resolution step", VP-580-010)

`resolve_m2_project(cli_project: Option<&str>, config: &Config) -> Option<String>` is a
SEPARATE, sibling pure function to `resolve_field_context`, invoked only after M2 is selected.
Resolves: explicit `--project <P>` flag, OR the active profile/config default (same source as
BC-3.3.010's create-path project resolution). `jr field options FOO --type Bug` with a
profile-default project configured → resolves without requiring the flag. `jr field options FOO
--type Bug` with NEITHER a flag NOR a configured default → exit 64, stderr contains `"--type
needs a resolvable project — pass --project <P> or configure a default"`.

**Test**: `test_bc_x_14_001_resolve_m2_project_flag_wins` +
`test_bc_x_14_001_resolve_m2_project_falls_back_to_config_default` +
`test_bc_x_14_004_m2_no_resolvable_project_exits_64_widened_message` in `tests/field_options.rs`.

---

### AC-005: M2 `--type` name→issueTypeId resolution reuses `get_issue_types_for_project` (S-331)
(traces to BC-X.14.001 "M2 issue-type name→id resolution step", BC-X.14.004 EC-X.14.004-4)

`get_createmeta_fields` needs a numeric `issueTypeId`; M2 resolves `--type <T>` to an id via the
SAME project-scoped, case-insensitive `get_issue_types_for_project` (S-331,
`src/api/jira/issues.rs`) `jr` already uses for bulk `--type`/`issue create --field`. Fires AT
MOST ONCE per invocation, ONLY on the M2 path. Unknown or ambiguous `--type` name → exit 64
listing valid issue types for the resolved project, BEFORE `get_createmeta_fields` is called —
zero calls to the createmeta fields endpoint on this failure path.

**Test**: `test_bc_x_14_001_m2_type_resolution_reused_from_s331` +
`test_bc_x_14_004_ec_x_14_004_4_unknown_type_exits_64_before_createmeta` in
`tests/field_options.rs`.

---

### AC-006: M3 `--request-type [--project <P>]` reuses `jr requesttype fields` plumbing verbatim
(traces to BC-X.14.001 "M3 service-desk resolution step", VP-580-009)

`--project` is an OPTIONAL companion on M3 — `--project --request-type` together is a VALID
invocation (M3 with an explicit service-desk project), NOT a pairing error (regression pin
against the superseded pairing-error framing, adversary pass-20 M1). When `--project` is
absent, the ambient profile/config-default project supplies it via
`require_service_desk`/`get_or_fetch_project_meta` — the SAME functions and 7-day
`project_meta.json` cache `jr requesttype fields <NAME|ID> --project <KEY>` already uses. A
resolved non-JSM project → exit 64 via `require_service_desk`'s call-site-specific message
(BC-X.8.004). This resolution call fires AT MOST ONCE per invocation, ONLY on the M3 path.

**Test**: `test_bc_x_14_001_m3_project_request_type_together_is_valid` (VP-580-009, realized
within the VP-580-006 proptest/wiremock pair) +
`test_bc_x_14_001_m3_non_jsm_project_exits_64_require_service_desk` in `tests/field_options.rs`.

---

### AC-007: M1 `--issue <KEY>` reuses `get_editmeta` verbatim; `--project` not consulted
(traces to BC-X.14.001 "FALLBACK / convenience" M1 description)

`jr field options customfield_10084 --issue FOO-1` reuses `JiraClient::get_editmeta` verbatim
(zero new API-layer code for M1). A stray `--project` alongside `--issue` is harmlessly ignored,
never rejected — `--project` is "not consulted", not "prohibited". `--issue <KEY>` not found
(404) → exit 64, "issue not found or not accessible" (EC-3.4.015-7 parallel).

**Test**: `test_bc_x_14_001_m1_issue_reuses_get_editmeta` +
`test_bc_x_14_001_m1_stray_project_harmlessly_ignored` +
`test_bc_x_14_004_m1_issue_not_found_exits_64` in `tests/field_options.rs`.

---

### AC-008: `get_createmeta_fields` (NEW) offset-paginates internally
(traces to BC-X.14.001 Postconditions "exactly one of the three enumeration MECHANISMS fires";
BC-3.3.010 Postconditions cross-referenced identically)

`JiraClient::get_createmeta_fields(project_key, issue_type_id)` in `src/api/jira/issues.rs`
calls `GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` (Atlassian's
current, non-deprecated createmeta pair — the deprecated `createmeta?expand=` form MUST NOT be
used), offset-paginated internally (`startAt`/`maxResults`/`total`) — one GET per page until all
field pages are collected. A target field on fields-page ≥2 (two-page wiremock fixture:
`maxResults` fields on page 1, target field on page 2, `total` spanning both) is collected and
resolves, NOT dropped with a spurious "not on the Create screen" error. Response types
(`CreateMetaField`, `CreateMetaFieldsResponse`) are defined inline in `issues.rs`, reusing
`types::jira::editmeta::{AllowedValue, EditMetaFieldSchema}` rather than duplicating them.

**Test**: `test_bc_x_14_001_get_createmeta_fields_paginates_all_pages` in
`tests/field_options.rs` (mirrors VP-578-020(a), realized here as the shared foundation
S-578-4 later reuses without re-testing).

---

### AC-009: Normalized `FieldOption{id,label,children}` model — degenerate entries never dropped
(traces to BC-X.14.001 `FieldOption` contract amendment (ADR-0019 §Amendment F-B), EC-X.14.001-7,
VP-580-005)

```rust
struct FieldOption {
    id: Option<String>,
    label: Option<String>,
    children: Vec<FieldOption>,   // cascading-select children; empty for non-cascading
}
```

`id`/`label` are `Option<String>` — a faithful pass-through of the already-optional
`AllowedValue.id`/`.value` shape one layer below. Both normalizers
(`normalize_from_allowed_values` for M1/M2, `normalize_from_valid_values` for M3) MUST emit
EXACTLY ONE `FieldOption` per source item regardless of which fields that item carries — a
missing `id`/`label` degrades that entry's OWN field(s) to `None`; it MUST NEVER cause the entry
to be dropped from the returned `Vec<FieldOption>`. A fixture mixing well-formed and degenerate
(missing id/label/both) entries proves entry-count preservation (source item count ==
`FieldOption` count).

**Test**: `test_bc_x_14_001_normalizer_never_drops_degenerate_entries` (VP-580-005 entry-count
preservation) in `tests/field_options.rs`.

---

### AC-010: Cascading `children[]` — both M1/M2 and M3 wire shapes normalize identically
(traces to BC-X.14.001 read-side cascading paragraph, EC-X.14.001-4)

Cascading fields (`option-with-child` / JSM `children[]`) nest child options under their
parent's `children` array, recursively — both M1/M2's `allowedValues[].children[]` (per-child
`id`) and M3's `validValues[].children` (per-child `value`) are read into the SAME normalized
shape. A non-cascading field always has `children: []` (never `null`/absent).

**Test**: `test_bc_x_14_001_cascading_children_round_trip_m1_m2` +
`test_bc_x_14_001_cascading_children_round_trip_m3` in `tests/field_options.rs`.

---

### AC-011: `<field>` resolution reuses `customfield_NNNNN` bypass + `fields.json` cache verbatim
(traces to BC-X.14.001 Behavior paragraph / Postconditions "GET /rest/api/3/field is NOT
called...")

`<field>` accepts EITHER a `customfield_NNNNN` literal (bypasses name lookup, same
regex/case-sensitivity convention as BC-3.4.015 Step 1) OR a human field name resolved via
`list_fields()` (same cache-first `fields.json` contract as BC-3.4.015 Step 2/2b — shared
cache, shared function, no new cache family) followed by `partial_match` (BC-X.10.001) for
case-insensitive exact→substring disambiguation. Zero matches / multiple matches → exit 64
(EC-X.14.001-2/3 parallels of EC-3.4.015-1/2), before any enumeration HTTP call.

**Test**: `test_bc_x_14_001_customfield_bypass_skips_list_fields` +
`test_bc_x_14_001_field_name_ambiguous_exits_64` in `tests/field_options.rs`.

---

### AC-012: `--value <substring>` client-side filter correctness
(traces to BC-X.14.002 Behavior, VP-580-007)

Filter applies AFTER the full fetch (no server-side filtering exists for any of the three
mechanisms). Case-insensitive; matches when EITHER `label` OR `id` contains the substring. A
child matching `--value` is retained under its parent (parent retained as context) even when
the parent's own label/id doesn't match; a parent matching `--value` retains ALL its children
unfiltered. Zero matches → empty result, exit 0 (BC-X.12.002 empty-result precedent, never an
error). `--value` absent → full list unchanged. `--value ""` (explicit empty string) is the
IDENTITY filter — matches every entry unconditionally, INCLUDING a degenerate `{id: None,
label: None}` entry (bypasses the per-field `None`-is-not-a-match-source rule when the
substring itself is empty). A degenerate entry with `id: None`/`label: None` is excluded from
the result for any NON-EMPTY substring (no match source exists) but IS included when `--value`
is `""` or absent.

**Test**: `test_bc_x_14_002_value_filter_case_insensitive_id_or_label` +
`test_bc_x_14_002_value_filter_cascading_child_retains_parent_context` +
`test_bc_x_14_002_value_empty_string_is_identity_filter_including_degenerate` +
`test_bc_x_14_002_value_nonempty_excludes_fully_degenerate_entry` in `tests/field_options.rs`.

---

### AC-013: Output shape — table (ID, Label, cascading indentation) / `--output json`
(traces to BC-X.14.003 Behavior, degenerate-entry rendering block, VP-580-008)

Default table output has exactly two columns, **ID** and **Label**; cascading children render
as additional rows indented under their parent (table mode only — JSON mode preserves nested
`children[]` verbatim, no flattening). `--output json` returns
`[{id: "<str>"|null, label: "<str>"|null, children: [...]}, ...]`, pretty-printed via
`output::render_json` (JSON render invariant #526) — no direct `serde_json::to_string_pretty` or
compact `json!` Display call. Degenerate-entry rendering: table mode missing `id` →
`NULL_GLYPH` (`"—"`, reused from `changelog.rs`/`user.rs`/`requesttype.rs`, not a new glyph);
table mode missing `label` → literal `"(unnamed)"` (never a fallback to the entry's own `id`).
JSON mode performs NO substitution for either field — emits raw `Option::None` as JSON `null`.
stderr is empty on the ordinary success path (output-channel profile 2, Read-only).

**Test**: `test_bc_x_14_003_table_two_columns_cascading_indent` +
`test_bc_x_14_003_json_array_shape_render_json_invariant` +
`test_bc_x_14_003_degenerate_entry_table_glyphs` +
`test_bc_x_14_003_degenerate_entry_json_emits_null_not_glyph` in `tests/field_options.rs`.

---

### AC-014: Error taxonomy + graceful degradation
(traces to BC-X.14.004 Error taxonomy table, Graceful degradation block, EC-X.14.004-1..7,
VP-580-005, VP-580-012)

Every taxonomy-table row (mode-selector arity, incomplete-M2, unknown/ambiguous `--type`, no
resolvable M3 project, unresolved `<field>`, field-absent-from-context, project 404,
issue-not-found, HTTP 401/403/5xx) exits 64 (or the standard `JrError` HTTP mapping) BEFORE the
enumeration HTTP call or in its own failure path — zero mutating HTTP under any invocation
(Invariant 2). Mode-selector arity is evaluated FIRST, before `--project`'s companion role.
`--project NONEXISTENT` (404, not 401) on M2 or M3 → exit 64, "project not found or not
accessible" (VP-580-012). **Graceful degradation (exit 0, not an error)**: when the resolved
field's `allowedValues`/`validValues` is absent or empty, `jr` inspects `schema.custom`
(M1/M2)/`jiraSchema` (M3) and prints one of three hints — Assets/CMDB (`schema.custom` =
`com.atlassian.jira.plugins.cmdb:cmdb-object-cftype`) → "no enumerable options — this field
uses Assets" pointing to `jr assets search`; user-picker/suggestion-backed → "no enumerable
options (dynamic/lookup field)" + `autoCompleteUrl` if present; free-text/number/date → "no
enumerable options (this field type has no fixed value set)". M3 Assets fields return
`validValues: []` unconditionally (JSDCLOUD-15551) — treated identically to the Assets-degrade
case, never as a misconfiguration message. `--output json` graceful-degrade → `[]` on stdout,
hint text on stderr (never folded into the JSON payload).

**Test**: `test_bc_x_14_004_each_taxonomy_row_exit_64_zero_http` (table-driven) +
`test_bc_x_14_004_project_404_exits_64_message` (VP-580-012) +
`test_bc_x_14_004_graceful_degrade_assets_field` +
`test_bc_x_14_004_graceful_degrade_userpicker_field` +
`test_bc_x_14_004_graceful_degrade_freetext_field` +
`test_bc_x_14_004_graceful_degrade_json_mode_empty_array_stderr_hint` +
`test_bc_x_14_004_m3_assets_empty_validvalues_is_degrade_not_misconfig` in
`tests/field_options.rs`.

---

## Architecture Mapping

| Component | File | Pure/Effectful | Notes |
|-----------|------|-----------------|-------|
| `Command::Field { command: FieldCommand }` | `src/cli/mod.rs` (MODIFIED) | N/A (clap enum) | New top-level command, structurally identical to the existing `RequestType` variant |
| Dispatch arm | `src/main.rs` (MODIFIED) | Effectful (dispatch) | New arm, mirrors `RequestType` dispatch |
| `FieldCommand::Options` handler (`handle_field_options`) | `src/cli/field.rs` (NEW) | Effectful shell | HTTP + cache reads (M3 path) + stdout/stderr |
| `resolve_field_context` | `src/cli/field.rs` (NEW) | Pure core | 3-boolean arity check, no `has_project` param |
| `resolve_m2_project` | `src/cli/field.rs` (NEW) | Pure core | Sibling pure fn to `resolve_field_context`; reads already-loaded `Config` |
| `normalize_from_allowed_values` / `normalize_from_valid_values` | `src/cli/field.rs` (NEW) | Pure core | No I/O; M1/M2 and M3 → `FieldOption` |
| `FieldOption` | `src/cli/field.rs` (NEW) | Pure core (data type) | CLI-local, not under `types::jira::`/`types::jsm::` (jr-synthesized normalization shape, not a wire mirror) |
| `get_createmeta_fields` | `src/api/jira/issues.rs` (NEW) | Effectful shell | Offset-paginated HTTP; reuses `types::jira::editmeta::{AllowedValue, EditMetaFieldSchema}` |
| `CreateMetaField` / `CreateMetaFieldsResponse` | `src/api/jira/issues.rs` (NEW) | Pure core (data types) | Serde structs, inline per the existing createmeta-family precedent |
| `get_issue_types_for_project` | `src/api/jira/issues.rs` (REUSED, S-331) | Effectful shell | M2 `--type` name→id resolution |
| `get_editmeta` | `src/api/jira/issues.rs` (REUSED) | Effectful shell | M1 |
| `list_fields` | `src/api/jira/fields.rs` (REUSED) | Effectful shell | `<field>` name resolution only, cache-first |
| M3 request-type-fields plumbing | `src/api/jsm/request_types.rs` (REUSED) | Effectful shell | Single non-paginated `GET` (`get_request_type_fields`) |
| `require_service_desk` / `get_or_fetch_project_meta` | `src/api/jsm/servicedesks.rs` (REUSED) | Effectful shell | M3 `--project`/ambient-default resolution |
| `partial_match` | (REUSED, BC-X.10.001) | Pure core | `<field>` name disambiguation |
| `output::render_json` / `output::print_output` | (REUSED) | Effectful shell | JSON render invariant #526 |

---

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-X.14.001-1 | `customfield_10084` literal | bypasses `list_fields()`/`partial_match` entirely |
| EC-X.14.001-2 | Human name unambiguous exact match | resolves via cache-first `list_fields()` + `partial_match` |
| EC-X.14.001-3 | Human name ambiguous (multiple candidates) | exit 64 naming candidates + `customfield_NNNNN` ids |
| EC-X.14.001-4 | Cascading field | `children[]` populated; non-cascading always `children: []` (never `null`/absent) |
| EC-X.14.001-5 | `<field>` globally resolves but absent from selected context's field set | exit 64, per-context message |
| EC-X.14.001-6 | M3-specific: field enumerable in `validValues` but not in global `GET /field` list | resolvable ONLY via `customfield_NNNNN` bypass |
| EC-X.14.001-7 | Source entry missing `id`/`label` | NEVER dropped — `FieldOption{id:None, label:None, children:[]}` still emitted |
| EC-X.14.004-1 | Assets/CMDB field via M3 | graceful-degrade Assets hint, NOT generic "no fixed value set" |
| EC-X.14.004-2 | `--output json` graceful-degrade | `[]` on stdout, hint on stderr |
| EC-X.14.004-3 | Field absent from selected context (vs. present-but-no-options) | exit 64 BEFORE `allowedValues`/`validValues` is read (distinct from graceful-degrade) |
| EC-X.14.004-4 | M2 unknown/ambiguous `--type` | exit 64 listing valid issue types, BEFORE `get_createmeta_fields` |
| EC-X.14.004-5 | M3 no resolvable ambient project | `require_service_desk` "project required" error |
| EC-X.14.004-6 | `--project NONEXISTENT` (404) on M2/M3 | exit 64, "project not found or not accessible" |
| EC-X.14.004-7 | M2 `issueTypeId` resolves then `get_createmeta_fields` 400s (TOCTOU) | propagated `JrError` (exit 1, NOT 64) |

---

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/cli/field.rs::FieldOption` | pure-core (data type) | Plain data carrier, no I/O |
| `src/cli/field.rs::{resolve_field_context, resolve_m2_project}` | pure-core (functions) | No I/O; two sibling pure functions per ADR-0019 §Amendment D1 |
| `src/cli/field.rs::{normalize_from_allowed_values, normalize_from_valid_values}` | pure-core (functions) | No I/O; pure transforms, same class as `config::validate_profile_name` |
| `src/cli/field.rs::handle*` | effectful-shell | HTTP + cache reads (M3) + stdout |
| `src/api/jira/issues.rs::get_createmeta_fields` | effectful-shell | HTTP via `JiraClient`, offset-paginated |
| `src/api/jira/issues.rs::{CreateMetaField, CreateMetaFieldsResponse}` | pure-core (data types) | Serde structs, no I/O |

---

## Token Budget Estimate

| Item | Est. Tokens |
|------|------------|
| Story spec (this file) | ~9 k |
| BC-X.14.001-004 (cross-cutting.md relevant sections) | ~10 k |
| ADR-0019 §1 + Amendment D1 | ~4 k |
| `src/cli/requesttype.rs` (structural reference for new `field.rs`) | ~2 k |
| `src/api/jira/issues.rs` (existing createmeta-family methods + editmeta) | ~3 k |
| `src/types/jira/editmeta.rs` (`AllowedValue`, `EditMetaFieldSchema` reuse) | ~1 k |
| `tests/field_options.rs` (new, ~14 ACs) | ~8 k |
| **Total** | **~37 k** |

Well under 20% of a 200k context window.

---

## Tasks

**Red Gate protocol**: Write all 14 ACs as tests in `tests/field_options.rs` first; they MUST
fail to compile/run (no `Command::Field` variant exists, `src/cli/field.rs` does not exist).
Then scaffold clap wiring, then the pure functions (proptested independently), then
`get_createmeta_fields`, then the full handler + normalizer + filter + renderer.

### Task 0 — Read source context

Read:
- `src/cli/requesttype.rs` (structural mirror for the new `field.rs` module)
- `src/api/jira/issues.rs` — existing `get_issue_types_for_project`, `get_editmeta`, and the
  createmeta-family precedent (`IssueTypeEntry`/`CreatemetaIssueTypesResponse`)
- `src/types/jira/editmeta.rs::{AllowedValue, EditMetaFieldSchema}` — types to reuse, not
  duplicate
- `src/api/jsm/request_types.rs` and `src/api/jsm/servicedesks.rs::{require_service_desk,
  get_or_fetch_project_meta}` — M3 plumbing to reuse verbatim
- `src/cache.rs::{read_fields_cache, write_fields_cache}` — cache-first contract to reuse
- `src/partial_match.rs` — BC-X.10.001 disambiguation contract
- `cross-cutting.md` BC-X.14.001..004 (read in full — do not work from summaries)
- ADR-0019 §1 and §Amendment D1 in full

### Task 1 — Write tests/field_options.rs (Red Gate)

Write all 14 ACs' tests. Confirm they fail (compile error — `Command::Field` doesn't exist yet).

### Task 2 — Scaffold `Command::Field`/`FieldCommand` + dispatch

`src/cli/mod.rs`: add `Command::Field { command: FieldCommand }`; `FieldCommand::Options {
field: String, r#type: Option<String>, request_type: Option<String>, issue: Option<String>,
project: Option<String>, value: Option<String> }`. `src/main.rs`: add the dispatch arm.

### Task 3 — Implement `resolve_field_context` + `resolve_m2_project` (pure, proptested)

Exactly per ADR-0019 §Amendment D1's two-sibling-pure-function split. Proptest
`resolve_field_context` exhaustively over the 3-boolean space.

### Task 4 — Implement `get_createmeta_fields` in `src/api/jira/issues.rs`

Offset-paginated (`startAt`/`maxResults`/`total`), reusing `AllowedValue`/`EditMetaFieldSchema`.
Mirror the existing `get_issue_types_for_project` pagination shape.

### Task 5 — Implement M1/M2/M3 dispatch + `FieldOption` normalizers

`normalize_from_allowed_values` (M1/M2), `normalize_from_valid_values` (M3). Never-drop
degenerate entries (F-B). Cascading `children[]` recursion.

### Task 6 — Implement `--value` filter + table/JSON rendering

Pure filter function; table renderer with `NULL_GLYPH`/`"(unnamed)"` glyphs; JSON via
`output::render_json`.

### Task 7 — Implement error taxonomy + graceful degradation

All BC-X.14.004 rows; per-schema-type degrade hints.

### Task 8 — Confirm all tests pass

```bash
cargo test --test field_options -- --nocapture
cargo test --lib field  # proptests
cargo clippy -- -D warnings
```

### Task 9 — PR creation

Create PR to `develop`:
- Title: `feat(field): jr field options command — M1/M2/M3 context resolution (#580 part 1)`
- Reference #580; note this is the foundation for S-578-4's platform-create `--field`
  resolution (shared `get_createmeta_fields`)

---

## Previous Story Intelligence

N/A — first story in the field-dx bundle (Wave 1, no `depends_on`). Useful precedent from
elsewhere in the codebase (not a blocking dependency):

- **`src/cli/requesttype.rs`** is the direct structural template for the new `src/cli/field.rs`
  module (per ADR-0019's own note: "mirrors `src/cli/requesttype.rs` structurally").
- **S-396** (`.factory/stories/S-396-issue-edit-field-flag.md`) is the origin of the
  `fields.json` cache-first contract (`read_fields_cache`/`write_fields_cache`, 7-day TTL,
  best-effort writer) and the `customfield_NNNNN` bypass regex this story reuses verbatim for
  `<field>` resolution — do not reimplement either.
- **S-331** is the origin of `get_issue_types_for_project`, reused verbatim for M2's `--type`
  name→id resolution.

---

## Architecture Compliance Rules

(Extracted from CLAUDE.md ADR-0012, ADR-0019 §1/§Amendment D1, `architecture-delta-field-dx.md`
§3/§4)

1. **Layering: `cli::field` (L2) → `api::jira::issues`/`api::jira::fields` (L4), →
   `api::jsm::request_types` (L4), → `cache` (L6, M3 path only), → `partial_match` (L6), →
   `output` (L6).** No new `api::jira::issues` → `cli::*` edge (upward). No `cli::field` →
   `cli::issue::*` edge — this story never imports from `create.rs`/`edit.rs`/`jsm_create.rs`.
2. **`get_createmeta_fields` reuses `types::jira::editmeta::{AllowedValue,
   EditMetaFieldSchema}`** — do NOT define a second, duplicate set of types for the createmeta
   response. This is the one new L4→L5 edge this story introduces.
3. **`resolve_field_context` MUST NOT take `has_project` as a parameter.** Per ADR-0019
   §Amendment D1, project resolvability is a separate, post-arity, M2-only step
   (`resolve_m2_project`), never folded into the arity check itself.
4. **Zero mutating HTTP under any invocation** (BC-X.14.001 Invariant 2). This command is
   strictly read-only.
5. **No new cache family.** M3 reuses the existing `project_meta.json`/request-type-fields
   caches verbatim; M1/M2 introduce no cache at all.
6. **`FieldOption` stays CLI-local** (`src/cli/field.rs`), NOT under `types::jira::`/
   `types::jsm::` — it is a jr-synthesized normalization shape reconciling three different wire
   shapes (M1/M2's `allowedValues[].id` vs. M3's `validValues[].value`), not a mirror of any
   single API response.
7. **The M2 `--type` name→id lookup (`get_issue_types_for_project`) and the M2 field
   enumeration (`get_createmeta_fields`) are DISTINCT calls** — do not conflate them into one
   function. Both are independently offset-paginated.

---

## Library & Framework Requirements

| Library | Version | Constraint |
|---------|---------|------------|
| clap | current (workspace) | New `Command::Field`/`FieldCommand` variants, mirrors `RequestType` |
| serde / serde_json | current (workspace) | `CreateMetaField`/`CreateMetaFieldsResponse`, `FieldOption` |
| proptest | current (workspace, dev-dep) | `resolve_field_context` exhaustive arity proptest |
| wiremock | 0.6 | `MockServer`, per-mechanism mocks for M1/M2/M3 |
| tokio | current | `#[tokio::test]` on async integration tests |
| (no new crate) | N/A | No new third-party dependency — all HTTP/JSON/cache/partial-match infra is pre-existing `jr` capability |

---

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `src/cli/field.rs` | CREATE | New command module — dispatch, `resolve_field_context`, `resolve_m2_project`, normalizers, `--value` filter, table/JSON rendering |
| `src/cli/mod.rs` | MODIFY | `Command::Field { command: FieldCommand }` + `FieldCommand` enum |
| `src/main.rs` | MODIFY | New dispatch arm for `Command::Field` |
| `src/api/jira/issues.rs` | MODIFY | NEW `get_createmeta_fields` + `CreateMetaField`/`CreateMetaFieldsResponse` types; reuses existing `get_issue_types_for_project` |
| `tests/field_options.rs` | CREATE | All 14 ACs |

**Files that MUST NOT change:**
- `src/cli/issue/create.rs`, `src/cli/issue/edit.rs`, `src/cli/issue/jsm_create.rs`,
  `src/cli/issue/field_resolve.rs` — those belong to S-578-1/2/3/4
- `src/api/jsm/requests.rs` — belongs to S-578-3
- `src/types/jira/editmeta.rs` — reused read-only; the `children` field extension belongs to
  S-578-2 (D4)
- Any `.factory/specs/prd/` BC file
