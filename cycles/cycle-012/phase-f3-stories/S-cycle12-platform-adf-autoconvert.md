---
document_type: story
level: ops
story_id: "S-cycle12-platform-adf-autoconvert"
epic_id: "FIELD-ADF-AUTOCONVERT"
title: "Platform ADF auto-conversion for --field on rich-text fields (edit + create paths)"
wave: 1
status: draft
intent: bugfix
feature_type: correctness
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
producer: story-writer
timestamp: "2026-09-13T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/phase-f2-spec-evolution/cycle-012-verification-delta.md"
  - ".factory/specs/architecture/decisions/ADR-0024-adf-autoconversion-for-field-on-richtext-fields.md"
  - "src/cli/issue/field_resolve.rs"
  - "src/cli/issue/edit.rs"
  - "src/cli/issue/create.rs"
  - "src/adf.rs"
  - "src/types/jira/editmeta.rs"
input-hash: "9fe3a72"
traces_to: ".factory/phase-f2-spec-evolution/cycle-012-verification-delta.md §4 VP-FIELD-ADF-001/002/003/004"
cycle: cycle-012-field-adf-autoconvert
estimated_effort: large
estimated_days: 5
target_module: "src/cli/issue/field_resolve.rs"
subsystems: ["SS-02", "SS-04", "SS-08"]
depends_on: []
blocks: ["S-cycle12-jsm-adf-autoconvert"]
behavioral_contracts:
  - BC-3.3.013
  - BC-3.3.014
  - BC-3.3.015
  - BC-3.4.033
  - BC-3.4.034
  - BC-3.4.035
  - BC-3.4.036
  - BC-3.4.037
bcs:
  - BC-3.3.013
  - BC-3.3.014
  - BC-3.3.015
  - BC-3.4.033
  - BC-3.4.034
  - BC-3.4.035
  - BC-3.4.036
  - BC-3.4.037
verification_properties:
  - VP-FIELD-ADF-001
  - VP-FIELD-ADF-002
  - VP-FIELD-ADF-003
  - VP-FIELD-ADF-004  # Axes h1/h2 ONLY: platform-path --markdown+--field description= exit-64 guards (AC-006 NET-NEW create guard / AC-007 edit guard-extension); JSM axes (a)-(g) are Story 2's scope
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0024"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-012/phase-f3-stories/dependency-graph.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: HIGH
points: 13
acceptance_criteria_count: 15
assumption_validations: []
risk_mitigations: []
created: "2026-09-13"
version: "1.0"
last_updated: "2026-09-13"
breaking_change: false
retroactive: false
origin: >
  cycle-012 field-adf-autoconvert, Wave 1, depends_on: [] because this story
  introduces the shared ADF detection predicate (is_adf_schema, is_adf_field,
  is_adf_field_value) and all platform-path ADF conversion logic that Story 2
  (JSM) depends on. Blocks S-cycle12-jsm-adf-autoconvert: that story calls
  is_adf_field_value from jsm_create.rs, which is defined in field_resolve.rs
  and first implemented here.
---

> **tdd_mode:** `strict` — Full TDD Iron Law enforced. This story introduces the
> shared ADF detection predicate and the field_markers side-channel plumbing,
> both of which require confirmed RED before GREEN. The empty-value guard
> asymmetry (edit → clear-doc, create → omit) is a load-bearing behavioral
> distinction that must be proven by failing tests before the guard code lands.
> Every proptest (VP-FIELD-ADF-001/002) must be authored and red before the
> `is_adf_field` branch in `dispatch_field_value` is written.

> **Execute:** `/vsdd-factory:deliver-story S-cycle12-platform-adf-autoconvert`

# S-cycle12-platform-adf-autoconvert — Platform ADF auto-conversion for `--field` on rich-text fields

## Narrative

- **As a** `jr` user running `jr issue edit` or `jr issue create` with `--field`
- **I want** `--field environment=VALUE`, `--field description=VALUE` (without the
  dedicated `--description` flag), and `--field TEXTAREA_FIELD=VALUE` to succeed
  instead of always returning a 400 API error
- **So that** I can set ADF-backed rich-text fields via `--field` without needing to
  hand-craft ADF JSON, and empty-value edits clear the field cleanly without
  triggering the JRACLOUD-79318 empty-text-node 400

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-3.4.033 | PRIMARY | Detection predicate fires on `:textarea` custom fields; non-empty edit → `text_to_adf`; `(adf)` echo; dry-run JSON `planned_preview` = ADF object; dry-run TABLE `(adf)` from `field_markers` |
| BC-3.4.034 | PRIMARY | `environment` system field detection (`schema.system == "environment"`); behavior flip 400→exit-0 |
| BC-3.4.035 | PRIMARY | `description` via `--field` alone (load-bearing M3 path); behavior flip 400→exit-0; table shows `(adf)` NOT `(updated)` |
| BC-3.4.036 | PRIMARY | Empty edit → clear-doc `{"type":"doc","version":1,"content":[]}`; dry-run JSON = clear-doc; dry-run TABLE = `(adf-clear)` from `field_markers`; live JSON = raw empty input |
| BC-3.4.037 | PRIMARY | `customfield_NNNNN` bypass form for `:textarea` field still fires `is_adf_field` (M4 regression pin) |
| BC-3.3.013 | PRIMARY | Platform create `:textarea` detection + `text_to_adf`; create-path echo `(adf)` |
| BC-3.3.014 | PRIMARY | Platform create `description`/`environment` system field detection; adapted `EditMetaFieldSchema.system`/`custom` fidelity; NET-NEW `--markdown + --field description=` exit-64 guard (EC-3.3.014-5) |
| BC-3.3.015 | PRIMARY | Platform create empty ADF-backed field → OMIT from POST body (not clear-doc) |

**Create-path `is_adf_field_value` note:** `is_adf_field_value(&serde_json::Value)` is
implemented in this story (in `field_resolve.rs`) because it shares the same `is_adf_schema`
core as `is_adf_field`. It will be called from `jsm_create.rs` in Story 2. It MUST be
declared at least `pub(super)` or `pub(crate)`; `is_adf_schema` and `is_adf_field` remain
module-private.

## Acceptance Criteria

### AC-001: ADF detection helpers + VP-FIELD-ADF-001 proptest (traces to BC-3.4.033 precondition, VP-FIELD-ADF-001)

A private `is_adf_schema` function in `src/cli/issue/field_resolve.rs` holds the
three-arm allowlist exclusively. `is_adf_field(&EditMetaFieldSchema)` and
`is_adf_field_value(&serde_json::Value)` are delegating entry points over it; neither
contains the allowlist logic. The predicate is risk-symmetric: it returns `true` IFF the
schema satisfies exactly one of: `system == "description"`, `system == "environment"`,
or `custom` ends with `":textarea"`.

VP-FIELD-ADF-001 proptest `prop_bc_3_4_033_is_adf_field_fires_only_on_allowlist` generates
arbitrary `Option<String>` `system`/`custom` pairs and asserts the two-sided property
(fires IFF allowlist match). VP-FIELD-ADF-001 example-based test
`test_bc_3_4_033_is_adf_field_allowlist_positive_and_negative_anchors` covers all anchor
rows (`:textarea` true, `:textfield` false, `summary` false, empty schema false,
`description` true, `environment` true, `customfield_NNNNN` bypass true).

**Test method: DEFAULT CI** (proptest + example-based; pure functions, no network).

### AC-002: Platform edit + create non-empty ADF conversion (traces to BC-3.4.033/034/035/037 postconditions, BC-3.3.013/014 postconditions, VP-FIELD-ADF-002)

When `dispatch_field_value` processes a non-empty bare ADF-backed `--field NAME=VALUE`:
(a) the wire value is an ADF document object (NOT `Value::String`); satisfies
`value["type"] == "doc"`, `value["version"] == 1`, non-empty `content` array with ≥1
`"paragraph"` node (VP-FIELD-ADF-002 Properties 1/2); (b) no `text` node anywhere in the
content tree contains a raw `\n` or `\r` (INV-1, VP-FIELD-ADF-002 Property 3);
(c) applies on the platform EDIT path (`resolve_against_editmeta` call site) AND on the
platform CREATE path (`resolve_against_createmeta` call site); (d) fires for all three
allowlist variants: `:textarea` custom (BC-3.4.033/BC-3.3.013), `environment` system
(BC-3.4.034), `description` system via `--field` alone (BC-3.4.035), and
`customfield_NNNNN` bypass for `:textarea` (BC-3.4.037).

VP-FIELD-ADF-002 proptest `prop_bc_3_4_033_dispatch_field_value_adf_backed_returns_adf_object`
covers Properties 1/2/3 for arbitrary non-empty inputs including multi-line (INV-1 path).
Example tests cover single-line, multi-line (hardBreak path), system field, and
`customfield_NNNNN` bypass. Tests for the CREATE path also confirm
`test_bc_3_3_013_014_createmeta_adaptation_preserves_system_custom_for_adf_detection`
(item 10 / §5 of verification delta): a wiremock-stubbed createmeta response with BOTH
a `:textarea` custom field AND a `description`/`environment` system field; asserts
`is_adf_field` fires for EACH (output is ADF object, not `Value::String`) — pinning
lossless `system`/`custom` deserialization (`None` not `""`).

**Test method: DEFAULT CI** (proptest + example-based, pure; wiremock for createmeta-fidelity test).

### AC-003: `field_markers` side-channel + table-emit loop priority (traces to BC-3.4.033/036 postconditions, VP-FIELD-ADF-002/003 table-mode axes; §5 item 9)

`FieldResolutionOutputs` in `src/cli/issue/field_resolve.rs` gains a `field_markers`
map (implementer's type choice, keyed by `human_name` display name). Two PLATFORM-PATH
sites populate it: (a) `dispatch_field_value`'s ADF branch → inserts `"(adf)"` for a
non-empty bare ADF-backed field; (b) `resolve_against_editmeta`'s empty-clear pre-check
→ inserts `"(adf-clear)"` for an empty/whitespace bare ADF-backed field on the edit
path. Neither `jsm_create.rs` nor any JSM code path populates `field_markers`.

The `edit.rs` and `create.rs` table-emit loops read `field_markers[human_name]` FIRST
— before the legacy `if field == "description" { "(updated)" }` hard-code — and render
the marker when present. `changed_fields` is NEVER written the marker string (JSON
channel remains the raw input per #398 invariant). The same priority rule applies in
the dry-run path.

**Test method: DEFAULT CI** for the plumbing shape; wiremock for table-emit loop ordering.

### AC-004: Empty-value path-specific semantics + bare-form gate (traces to BC-3.4.036/BC-3.3.015 postconditions, VP-FIELD-ADF-003 Axes A/B/D platform sub-case)

Platform EDIT, empty/whitespace bare ADF-backed `--field NAME=`: `resolve_against_editmeta`
sets `fields[field_id]` to the clear-doc `{"type":"doc","version":1,"content":[]}` and
does NOT call `dispatch_field_value`. Platform CREATE, same input: `resolve_against_createmeta`
skips the `fields` insert entirely. The path-specific distinction (clear-doc vs omit) is
preserved — a mutant unifying both is caught.

The empty pre-check fires ONLY when `spec.kind.is_none()` (bare form). A hinted-kind
value (`:option`, `:id`, `:name`, `:asset`) bypasses the ADF empty guard and routes to
the hint-composer path (VP-FIELD-ADF-003 Axis D, platform sub-case).

F4 must extract the `kind.is_none() && is_adf_schema(...) && value.trim().is_empty()`
gate condition into pure, network-free code so VP-FIELD-ADF-003 Axis D is authorable as
a unit test without a MockServer (exact decomposition is F4's choice).

**Tests:** `test_bc_3_4_036_edit_empty_adf_field_resolves_to_clear_doc` (Axis A),
`test_bc_3_3_015_create_empty_adf_field_omitted` (Axis B),
`test_adf_empty_guard_fires_only_on_bare_form_not_hinted_platform` (Axis D).

**Test method: DEFAULT CI** (pure no-network code after F4 extraction obligation is met).

### AC-005: VP-FIELD-ADF-003 Axis G — platform-create POST-body empty-omit wiremock (traces to BC-3.3.015 postcondition, VP-FIELD-ADF-003 Axis G; §5 item 16)

A wiremock/CLI-level integration test drives `jr issue create --field <ADF-BACKED-FIELD>=`
(empty value) through `resolve_against_createmeta` with a wiremock-stubbed createmeta
response. The intercepted POST body `fields` map must contain NO key for the ADF-backed
field (absent, not `null`, not `""`, not a clear-doc). An optional non-empty sub-assertion
confirms the conditional: `--field environment=hello` IS present as an ADF doc, verifying
the omit logic is conditional on empty, not unconditional.

`test_bc_3_3_015_create_empty_adf_field_omitted_from_post_body`.

**Test method:** wiremock/CLI-level (`JiraClient::new_for_test` + `MockServer`).

### AC-006: NET-NEW platform create exit-64 guard: `--markdown + --field description=VALUE` (traces to BC-3.3.014 EC-3.3.014-5; VP-FIELD-ADF-004 Axis h1; §5 item 18)

`src/cli/issue/create.rs::handle_create` gains a step 2c guard (after the D2 collision
guard, before step 4b createmeta resolution): when `--markdown` is set AND any `--field`
token's raw key (substring before the first `=`, case-sensitive, no-trim) equals exactly
`"description"`, exit 64 with a message containing `"cannot be combined with \`--markdown\`"`,
followed by remediation. Zero HTTP calls (guard fires before createmeta). This guard does
NOT currently exist; it is NET-NEW.

`test_bc_3_3_014_5_markdown_field_description_conflict_exits_64_create`: drives
`jr issue create --project P --type T --summary S --field description=X --markdown`
(no `--description`); asserts exit code 64, `stderr.contains("cannot be combined with
\`--markdown\`")`, and empty stdout.

**Currently RED** — the guard does not exist; the command proceeds to createmeta resolution.
**Test method: DEFAULT CI** (CLI subprocess, zero mocks needed).

### AC-007: Extended platform edit exit-64 guard: `--markdown + --field description=VALUE` (traces to BC-3.4.035 EC-3.4.035-3; VP-FIELD-ADF-004 Axis h2; §5 item 18)

`src/cli/issue/edit.rs::handle_edit` EXTENDS its guard to fire for the combination of
`--markdown` + a `--field` token whose raw key equals `"description"` — BEFORE the
existing `--markdown`-requires-description guard. The extended guard message contains
`"cannot be combined with \`--markdown\`"` (not the existing guard's message).

`test_bc_3_4_035_3_markdown_field_description_conflict_exits_64_edit`: drives
`jr issue edit KEY --field description=X --markdown` (no `--description`); asserts exit
code 64, `stderr.contains("cannot be combined with \`--markdown\`")`, and empty stdout.

**Currently RED** — `edit.rs` currently exits 64 with the pre-existing guard's message
`"--markdown requires --description or --description-stdin"`, NOT the required
`"cannot be combined with \`--markdown\`"` substring.
**Test method: DEFAULT CI** (CLI subprocess, zero mocks needed).

### AC-008: Dry-run JSON `planned_preview` shape (traces to BC-3.4.033/036 postconditions, VP-FIELD-ADF-002 dry-run JSON axis, VP-FIELD-ADF-003 Axis E)

For `--dry-run --output json` on the platform edit path:
(a) **Non-empty ADF-backed field:** `planned_preview[human_name]` is the wire ADF
`serde_json::Value` object — `{"type":"doc","version":1,"content":[...]}` —
NOT a display string (deliberate special-case deviation from the general bare-form
display-string rule). `test_bc_3_4_033_dry_run_planned_preview_contains_adf_object_keyed_by_human_name`.
(b) **Empty ADF-backed field (edit-clear):** `planned_preview[human_name]` is the
clear-doc `{"type":"doc","version":1,"content":[]}` — NOT absent, NOT a display string.
`test_bc_3_4_036_dry_run_planned_preview_contains_clear_doc_keyed_by_human_name`.

Both keys are `human_name` (display name), NOT `field_id`.

**Test method:** wiremock/CLI-level (requires editmeta HTTP stub).

### AC-009: Dry-run TABLE `(adf)` / `(adf-clear)` sentinels from `field_markers` (traces to BC-3.4.033/036 dry-run postconditions, VP-FIELD-ADF-002 table-mode axis, VP-FIELD-ADF-003 Axis H; §5 item 17)

For `--dry-run` on the platform edit path, the table-emit loop renders `(adf)` for a
non-empty ADF-backed field and `(adf-clear)` for an empty-value ADF-backed field. Both
markers come from `field_markers[human_name]` — NOT from inspecting the `planned_preview`
content shape (M-3 anti-pattern rejected).

`test_bc_3_4_033_dry_run_table_shows_adf_marker` (VP-002 table-mode axis).
`test_bc_3_4_036_dry_run_table_shows_adf_clear_sentinel_from_field_markers` (VP-003 Axis H).

A mutant that skips `field_markers` population on the dry-run path, or that renders from
`planned_preview` content-shape inspection, fails RED on one or both tests.

**Test method:** wiremock/CLI-level (same class as AC-008; full `issue edit` pipeline
including editmeta HTTP fetch).

### AC-010: Live edit echo channels (traces to BC-3.4.033/035/036 postconditions, VP-FIELD-ADF-002 live-echo axes, VP-FIELD-ADF-003 Axis F)

For a LIVE (non-dry-run) `issue edit` with a non-empty ADF-backed `--field NAME=VALUE`:
- JSON channel (`--output json`): `changed_fields[human_name]` carries the **raw
  user-supplied input string** — not the ADF object, not `"(adf)"`.
- Table channel: the field row shows `"(adf)"` — not the ADF object, not the raw string.

For a LIVE `issue edit` with an empty/whitespace ADF-backed `--field NAME=`:
- JSON channel: `changed_fields[human_name]` carries the raw empty/whitespace string —
  not the clear-doc JSON, not `"(adf-clear)"`.
- Table channel: the field row shows `"(adf-clear)"` — not the raw empty string.

Both channel asymmetries are intentional (#398 invariant applied to ADF fields) and
MUST NOT be unified.

Required tests: `test_bc_3_4_033_live_edit_json_changed_fields_raw_input_not_adf_object`,
`test_bc_3_4_033_live_edit_table_shows_adf_marker_not_raw_value`,
`test_bc_3_4_036_live_edit_json_changed_fields_raw_empty_input_not_clear_doc`.

**Test method:** wiremock/CLI-level (requires editmeta HTTP stub + issue PUT stub).

### AC-011: `--field description=VALUE` table shows `(adf)` NOT `(updated)` (traces to BC-3.4.035 postcondition, VP-FIELD-ADF-002 live-echo axis; §5 item 8 M-2)

On a LIVE `issue edit KEY --field description=VALUE` (bare form — no `--description`
flag), the table cell for `description` shows `(adf)`, NOT `(updated)`. The `(updated)`
marker fires ONLY for the dedicated `--description` flag path, which does not populate
`field_markers`. The emit loop MUST consult `field_markers` BEFORE the legacy
`if field == "description" { "(updated)" }` hard-code.

`test_bc_3_4_035_live_edit_field_description_shows_adf_not_updated`: drives `jr issue
edit KEY --field description=VALUE` through a wiremock editmeta stub where
`description` has `schema.system == "description"`. Asserts: (a) table cell = `"(adf)"`,
NOT `"(updated)"`; (b) `changed_fields["description"]` = raw input string (lossless).

The existing `test_bc_3_4_033_live_edit_table_shows_adf_marker_not_raw_value` targets a
`:textarea` custom field (`field != "description"`) — this test specifically targets the
`description` field name to make the priority ordering a live discriminator.

**Test method:** wiremock/CLI-level.

### AC-012: Create-path table shows `(adf)` marker (traces to BC-3.3.013/014 postconditions, VP-FIELD-ADF-002; §5 item 8)

On a LIVE `issue create --field NAME=VALUE` for an ADF-backed field, the create-path
table-mode success echo shows `(adf)` as the value for that field — NOT the ADF JSON
object and NOT the raw input string. The create path has no `changed_fields` key; the
`(adf)` marker is the complete platform-create echo for ADF-backed fields.

`test_bc_3_3_013_create_table_shows_adf_marker`.

**Test method:** wiremock/CLI-level (requires createmeta + issue POST stubs).

### AC-013: Createmeta adaptation fidelity (`system`/`custom` preserved) + VP-FIELD-ADF-003 Axis G (traces to BC-3.3.013/014 preconditions, VP-FIELD-ADF-003 Axis G; §5 items 10/16)

(a) **Createmeta fidelity** (§5 item 10): a wiremock-stubbed `GET .../createmeta` response
contains BOTH a `:textarea` custom field (`"schema":{"type":"string","custom":"…:textarea"}`)
AND a `description`/`environment` system field (`"schema":{"type":"string","system":"environment"}`).
After calling `resolve_against_createmeta`, `is_adf_field` must have fired for EACH —
i.e., the output value for each is an ADF object, not `Value::String`. Pinned by
`test_bc_3_3_013_014_createmeta_adaptation_preserves_system_custom_for_adf_detection`.
A lossy deserialization that maps absent `system` to `""` (not `None`) causes
`is_adf_field` to return `false` for the system-field sub-case — this test kills that mutant.

(b) **VP-FIELD-ADF-003 Axis G** (§5 item 16): a wiremock-stubbed create call with
`--field environment=` (empty) asserts the constructed POST `fields` map contains NO key
for `environment` (absent, not `null`, not `""`, not a clear-doc). Pinned by
`test_bc_3_3_015_create_empty_adf_field_omitted_from_post_body` (also listed in AC-005;
these are the same test — this AC cross-references it as the Axis G realization).

**Test method:** wiremock/CLI-level for both sub-cases.

### AC-014: E2E `:textarea` create-path smoke (traces to BC-3.3.013; §5 item 3 H2 residual)

`test_e2e_issue_edit_custom_field` (or a companion create-path test) attempts an
adaptive read-back assertion on a `:textarea` field via the create path on the live E2E
instance. Clean-skips if no `:textarea` field is available on the E2E instance (per §M1
of the F1 delta analysis). This test is gated on `JR_RUN_E2E` + `#[ignore]`.

**Test method:** Live E2E (gated `JR_RUN_E2E=1`).

### AC-015: Mutants.toml coverage confirmed + CHANGELOG entry (traces to BC-3.4.034 Behavior item 4; §5 items 1/2)

Before this PR merges, confirm that `src/cli/issue/field_resolve.rs` and the other
files modified by this story are already covered by whole-file `examine_globs` entries
in `.cargo/mutants.toml`. Per §5 items 1/2, no `.cargo/mutants.toml` edit is needed
for this feature — only a confirmation that the existing entries cover the new
`is_adf_field`/`is_adf_schema` helpers and the ADF branches.

The combined `### Fixed` CHANGELOG entry (one entry for ALL 400→exit-0 behavior flips
+ empty-value clear/omit + assembly-order determinism across platform edit, platform
create, and JSM create paths) is added under `[Unreleased] > Fixed` before the PR is
opened, per BC-3.4.034 Behavior item 4 (canonical combined-entry definition). This
single entry covers: `jr issue edit --field environment=VALUE` / `--field description=VALUE`
/ `--field <TEXTAREA>=VALUE`; `jr issue create --field description/environment/<TEXTAREA>=VALUE`;
empty-value `--field NAME=` for ADF-backed fields on both paths; assembly-order
determinism on the JSM path (listed here for the combined entry, realized in Story 2).

**Test method:** N/A (doc artifact verified by PR review; mutants.toml grep confirmed as
a PR-time check).

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `is_adf_schema` / `is_adf_field` / `is_adf_field_value` (detection predicates) | `src/cli/issue/field_resolve.rs` | Pure |
| `dispatch_field_value` (ADF conversion branch) | `src/cli/issue/field_resolve.rs` | Pure (no stderr; effectful callers own stderr) |
| `resolve_against_editmeta` (empty-clear pre-check + resolution loop) | `src/cli/issue/field_resolve.rs` | Effectful (network, `get_editmeta`) |
| `resolve_against_createmeta` (empty-omit pre-check + resolution loop) | `src/cli/issue/field_resolve.rs` | Effectful (network, `get_createmeta_fields`) |
| `handle_edit` (table-emit loop, `--markdown` guard) | `src/cli/issue/edit.rs` | Effectful (CLI handler) |
| `handle_create` (step 2c guard, table-emit loop) | `src/cli/issue/create.rs` | Effectful (CLI handler) |
| `text_to_adf` (ADF conversion) | `src/adf.rs` | Pure |
| `get_editmeta` | `src/api/jira/issues.rs` | Effectful (network) |
| `get_createmeta_fields` / `get_issue_types_for_project` | `src/api/jira/issues.rs` | Effectful (network) |

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | Bare empty `--field NAME=` (whitespace) for ADF-backed field on edit path | Clear-doc `{"type":"doc","version":1,"content":[]}` sent; `field_markers[name] = "(adf-clear)"` (BC-3.4.036, AC-004) |
| EC-002 | Bare empty `--field NAME=` for ADF-backed field on create path | Omit from POST `fields` map entirely (BC-3.3.015, AC-005) |
| EC-003 | `--markdown + --field description=VALUE` on create path | Exit 64 via `JrError::UserError`; zero HTTP (BC-3.3.014 EC-3.3.014-5, AC-006) |
| EC-004 | `--markdown + --field description=VALUE` on edit path | Exit 64 via `JrError::UserError`; correct message (BC-3.4.035 EC-3.4.035-3, AC-007) |
| EC-005 | `customfield_NNNNN` bypass form for ADF-backed (`:textarea`) field | `is_adf_field` still fires via `is_adf_schema`; wire value is ADF object (BC-3.4.037, AC-002) |
| EC-006 | JRACLOUD-79318: empty text node 400 — `text_to_adf("")` produces empty text node | Empty-value pre-check MUST fire BEFORE `text_to_adf` call; prevents 400 on Jira side (AC-004, AC-005) |
| EC-007 | `--field description=VALUE` on edit path via `--field`-alone M3 path | Resolves via `editmeta`; fires `is_adf_field`; wire value is ADF object (BC-3.4.035, AC-002, AC-011) |

## Purity Classification

| Function/Site | Pure/Effectful | Rationale |
|--------------|----------------|-----------|
| `is_adf_schema` | Pure | Three-arm allowlist check; no I/O, deterministic |
| `is_adf_field` | Pure | Thin delegator over `is_adf_schema`; no I/O |
| `is_adf_field_value` | Pure | Thin delegator over `is_adf_schema` for `serde_json::Value` schema; no I/O |
| `dispatch_field_value` (ADF branch) | Pure | No `eprintln!`; returns wire value; callers own stderr (Architecture Compliance Rule 5) |
| `text_to_adf` | Pure | Deterministic ADF doc from plain text; no I/O |
| `resolve_against_editmeta` | Effectful | Issues `get_editmeta` HTTP call; owns empty-clear pre-check and `field_markers` population |
| `resolve_against_createmeta` | Effectful | Issues `get_createmeta_fields` HTTP call; owns empty-omit pre-check |
| `handle_edit` / `handle_create` (guard + table-emit) | Effectful | CLI entry points; read `field_markers`; emit table output |

## Previous Story Intelligence

N/A — first story in the `FIELD-ADF-AUTOCONVERT` epic.

Pre-existing context relevant to F4 implementer:
- `dispatch_field_value` in `src/cli/issue/field_resolve.rs` already handles the
  `"string"/"text"` arm for non-ADF fields — the new ADF branch is inserted BEFORE the
  existing `Value::String(value)` fallback in that arm.
- `resolve_against_editmeta` already issues `client.get_editmeta(key).await?` (mandatory
  HTTP) before reaching field dispatch — the empty-clear pre-check belongs BEFORE
  `dispatch_field_value` is called, in the same post-fetch resolution loop.
- The `FieldResolutionOutputs` struct (`changed_fields`, `planned_preview`) currently
  has no marker side-channel — `field_markers` is net-new to this story.
- The legacy `if field == "description" { "(updated)" }` hard-code in `edit.rs`'s
  table-emit loop must be consulted AFTER `field_markers`, not before.
- `create.rs::handle_create` currently has no step 2c guard for `--markdown + --field
  description=`. The D2 collision guard (step 2b) already exists; step 2c is inserted
  immediately after it.

## Architecture Compliance Rules

From ADR-0024:

1. **Single allowlist core** (AC-008 ADR-0024): `is_adf_schema` holds the three-arm
   allowlist exclusively. `is_adf_field` and `is_adf_field_value` are thin delegating
   entry points. No duplication of the allowlist in two places.
2. **No `dispatch_field_value` on the JSM create path** (ADR-0024 §Decision): the JSM
   resolution layer (`jsm_create.rs`) uses `is_adf_field_value` directly and performs
   its own conversion — it does NOT call `dispatch_field_value`. This story's changes to
   `dispatch_field_value` are platform-path only.
3. **`is_adf_field_value` must be `pub(super)` or `pub(crate)`** (VP-FIELD-ADF-001
   §4): it is called from `jsm_create.rs` (a sibling in the same module). `is_adf_schema`
   and `is_adf_field` remain module-private.
4. **`field_markers` populated ONLY at two PLATFORM-PATH sites** (§5 item 9): both
   in `field_resolve.rs`. `jsm_create.rs` never populates `field_markers` (no per-field
   echo surface on the JSM create path per BC-3.8.001 — JSM create shows only
   `Created request <KEY>`).
5. **`dispatch_field_value` does not call `eprintln!`** (pure-core boundary): any
   warning emission belongs in the effectful caller (`resolve_against_editmeta` /
   `resolve_against_createmeta`).
6. **JSON render invariant (#526)**: all `--output json` output routes through
   `output::render_json`, never direct `serde_json::to_string_pretty`.
7. **Exit code 64 via `JrError::UserError`** for both new guards (AC-006, AC-007) —
   not clap exit 2.

## Library & Framework Requirements

| Library | Version | Purpose |
|---------|---------|---------|
| `serde_json` | as pinned in `Cargo.toml` | ADF doc output as `serde_json::Value`; `planned_preview` and `changed_fields` values |
| `proptest` | as pinned in `Cargo.toml` | VP-FIELD-ADF-001/002 property-based tests over `EditMetaFieldSchema` generators |
| `wiremock` | as pinned in `Cargo.toml` | Createmeta and editmeta HTTP stub for wiremock-level tests |
| `tokio` | as pinned in `Cargo.toml` | Async test runtime (`#[tokio::test]`) |

Do NOT add new dependencies. All required libraries are already in `Cargo.toml`.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/issue/field_resolve.rs` | MODIFY | Add `is_adf_schema`, `is_adf_field`, `is_adf_field_value`; ADF branch in `dispatch_field_value`; empty-clear pre-check in `resolve_against_editmeta`; empty-omit pre-check in `resolve_against_createmeta`; `field_markers` in `FieldResolutionOutputs` |
| `src/cli/issue/edit.rs` | MODIFY | Extended `--markdown + --field description=` exit-64 guard (AC-007); table-emit loop reads `field_markers` before legacy description hard-code (AC-003) |
| `src/cli/issue/create.rs` | MODIFY | NET-NEW step 2c guard for `--markdown + --field description=` (AC-006); create-path table-emit reads `field_markers` (AC-003) |
| `src/types/jira/editmeta.rs` | VERIFY | `EditMetaFieldSchema.system` and `.custom` are `Option<String>` (not `String`); absent API key maps to `None`, not `""` — needed for AC-013 createmeta fidelity (schema reuse on create path) |
| `tests/issue_edit_field.rs` | MODIFY/CREATE | VP-FIELD-ADF-001/002/003 tests: proptest, example-based, wiremock for edit-path ACs |
| `tests/issue_create_field.rs` | MODIFY/CREATE | VP-FIELD-ADF-001/002/003 tests: create-path wiremock ACs, createmeta fidelity, empty-omit Axis G |
| `tests/e2e_live.rs` | MODIFY | AC-014 E2E `:textarea` smoke (gated `JR_RUN_E2E`) |
| `CHANGELOG.md` | MODIFY | Combined `### Fixed` entry under `[Unreleased]` before PR (AC-015) |

## Tasks

1. **Read** `src/cli/issue/field_resolve.rs` in full — understand `FieldResolutionOutputs`,
   `dispatch_field_value`, `resolve_against_editmeta`, `resolve_against_createmeta`.
2. **Author RED tests first (proptest + example-based)** for VP-FIELD-ADF-001
   (`is_adf_field`/`is_adf_schema` detection) and VP-FIELD-ADF-002 (non-empty ADF
   conversion) — confirm RED before any implementation.
3. **Author RED unit tests** for VP-FIELD-ADF-003 Axes A/B/D (empty-value semantics
   and bare-form gate) — requires extracting the gate condition into pure, network-free
   code first (F4 choice for exact decomposition).
4. **Implement `is_adf_schema` + entry points** in `field_resolve.rs`; confirm VP-001
   proptest + example tests turn GREEN.
5. **Implement ADF branch in `dispatch_field_value`** for non-empty ADF-backed fields;
   also populate `field_markers[human_name] = "(adf)"` in the same branch; write ADF
   object to `planned_preview[human_name]` (not display string) — confirm VP-002 turns GREEN.
6. **Add `field_markers` field to `FieldResolutionOutputs`** and update all construction
   sites to include the new field.
7. **Implement empty-clear pre-check in `resolve_against_editmeta`**: populate
   `field_markers[human_name] = "(adf-clear)"` and `planned_preview[human_name]` with
   clear-doc on the empty path; extract the gate condition into pure code for Axis D —
   confirm VP-003 Axes A/E/D platform sub-case turn GREEN.
8. **Implement empty-omit pre-check in `resolve_against_createmeta`**: skip `fields.insert`
   on empty ADF-backed field; extract gate condition for Axis D — confirm VP-003 Axes B/D
   platform sub-case turn GREEN.
9. **Update `edit.rs` table-emit loop**: read `field_markers[human_name]` FIRST, before
   the legacy `description → (updated)` hard-code. Update dry-run table-emit loop to do
   the same.
10. **Update `create.rs` table-emit loop**: read `field_markers[human_name]` first.
11. **Author wiremock tests** for ACs 008–013 (dry-run JSON/TABLE shapes; live echo;
    `--field description=` shows `(adf)` not `(updated)`; create-path `(adf)` marker;
    createmeta fidelity; VP-003 Axis G empty-omit POST-body).
12. **Implement NET-NEW step 2c guard** in `create.rs::handle_create` (AC-006);
    author `test_bc_3_3_014_5_markdown_field_description_conflict_exits_64_create`;
    confirm RED before guard code, then GREEN after.
13. **Extend guard in `edit.rs::handle_edit`** (AC-007); author
    `test_bc_3_4_035_3_markdown_field_description_conflict_exits_64_edit`; confirm RED
    (wrong message), then GREEN after extension.
14. **Add or update E2E test** for `:textarea` create-path smoke (AC-014), gated on
    `JR_RUN_E2E`.
15. **Add CHANGELOG entry** under `[Unreleased] > Fixed` (combined entry per
    BC-3.4.034 item 4; includes JSM path behaviors from Story 2 for a single combined
    entry — coordinate with Story 2 implementer to avoid duplicate entries).
16. **Confirm `.cargo/mutants.toml` coverage** (AC-015): grep that `field_resolve.rs`
    and modified files are in existing `examine_globs` entries; no edit needed.
17. **Run `scripts/check-spec-counts.sh`** and `scripts/check-bc-cumulative-counts.sh`
    if touching any BC frontmatter (these scripts should not need to be run for code-only
    changes, but run them as a safeguard if any BC file was edited during implementation).
18. **Open PR** targeting `develop`; ensure all non-E2E tests pass under `cargo test`.

## Token Budget Estimate

| Component | Estimated Tokens |
|-----------|-----------------|
| Story spec (this file) | ~8 000 |
| `src/cli/issue/field_resolve.rs` (~1 635 LOC) | ~6 000 |
| `src/cli/issue/edit.rs` (~3 187 LOC) | ~12 000 |
| `src/cli/issue/create.rs` (~1 253 LOC) | ~5 000 |
| `src/adf.rs` (text_to_adf) | ~5 000 |
| `src/types/jira/editmeta.rs` | ~2 000 |
| New/modified test files | ~8 000 |
| Verification delta §4 VP-001/002/003 | ~6 000 |
| **Total** | **~52 000** |

~52 000 / 200 000 = **26%** of agent context window — within the 20–30% budget.
