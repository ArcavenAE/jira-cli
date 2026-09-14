---
document_type: story
level: ops
story_id: "S-cycle12-jsm-adf-autoconvert"
epic_id: "FIELD-ADF-AUTOCONVERT"
title: "JSM ADF auto-conversion for --field on rich-text fields (JSM create path)"
wave: 2
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
  - "src/cli/issue/jsm_create.rs"
  - "src/api/jsm/requests.rs"
  - "src/cli/issue/field_resolve.rs"
  - "src/types/jsm/request_type.rs"
input-hash: "db6d150"
traces_to: ".factory/phase-f2-spec-evolution/cycle-012-verification-delta.md §4 VP-FIELD-ADF-001/003/004"
cycle: cycle-012-field-adf-autoconvert
estimated_effort: large
estimated_days: 6
target_module: "src/cli/issue/jsm_create.rs"
subsystems: ["SS-02", "SS-05", "SS-08"]
depends_on: ["S-cycle12-platform-adf-autoconvert"]
blocks: []
behavioral_contracts:
  - BC-3.8.019
  - BC-3.8.020
  - BC-3.8.021
  - BC-3.8.022
bcs:
  - BC-3.8.019
  - BC-3.8.020
  - BC-3.8.021
  - BC-3.8.022
verification_properties:
  - VP-FIELD-ADF-001
  - VP-FIELD-ADF-003
  - VP-FIELD-ADF-004
# regression_verification_properties: VPs not owned by this cycle but audited/narrowed here.
# VP-578-015 scope is narrowed in AC-011 (bare-form JSM fixtures need RT-fields stubs).
# Do NOT add to verification_properties or bcs — this cycle does not own VP-578-015.
regression_verification_properties:
  - VP-578-015
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
acceptance_criteria_count: 17
assumption_validations: []
risk_mitigations: []
created: "2026-09-13"
version: "1.0"
last_updated: "2026-09-13"
breaking_change: false
retroactive: false
origin: >
  cycle-012 field-adf-autoconvert, Wave 2, depends_on:
  [S-cycle12-platform-adf-autoconvert] because the JSM resolution layer
  calls is_adf_field_value from field_resolve.rs, which is first implemented
  in Story 1. This story adds ADF detection and conversion to the JSM create
  path (jsm_create.rs resolution layer + api/jsm/requests.rs build()
  assembly-order fix). Blocks: [] (no downstream stories depend on JSM-specific
  ADF plumbing in this cycle).
---

> **tdd_mode:** `strict` — Full TDD Iron Law enforced. The DQ-6 type/signature
> decision gates VP-FIELD-ADF-004 axes (b)-(f) tests AND VP-FIELD-ADF-003 Axis C;
> only Axis (a), Axis (g), and VP-FIELD-ADF-003 Axis D-JSM are authorable
> immediately after Story 1 merges. VP-FIELD-ADF-003 Axis C IS DQ-6-gated — it
> targets the `jsm_create.rs` resolution layer (the ADF empty-omit path) and shares
> the same DQ-6 test-harness dependency as VP-FIELD-ADF-004 Axes (b)-(f) (delta
> lines 87, 691, 699 + story AC-007). All DQ-6-gated tests must be RED before the
> resolution-layer ADF branch is implemented. The `build()` assembly-order fix
> (Axis g) is a code change with a corresponding RED test — the test must be
> authored and confirmed RED before the source reorder is applied.

> **Execute:** `/vsdd-factory:deliver-story S-cycle12-jsm-adf-autoconvert`

# S-cycle12-jsm-adf-autoconvert — JSM ADF auto-conversion for `--field` on rich-text fields

## Narrative

- **As a** `jr` user running `jr issue create --request-type RT --field description=VALUE`
  or `--field <TEXTAREA_FIELD>=VALUE` or `--field environment=VALUE`
- **I want** ADF-backed `--field` values to be automatically converted to ADF before
  being submitted to `POST /rest/servicedeskapi/request`, with `"isAdfRequest": true`
  reflected in the POST body, and empty ADF-backed fields omitted (not sent as empty
  strings or clear-docs)
- **So that** JSM create requests with rich-text field values succeed instead of returning
  400 errors, and the ADF contract is correctly upheld for all three allowlist variants
  (`description` system, `environment` system, `:textarea` custom)

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-3.8.019 | PRIMARY | JSM `description`/`environment` extra fields detected as ADF-backed via `jira_schema.system`; non-empty → ADF object in `requestFieldValues`; `isAdfRequest` accumulated; fail-open on metadata fetch failure |
| BC-3.8.020 | PRIMARY | JSM `:textarea` extra fields detected as ADF-backed via `jira_schema.custom`; non-empty → ADF object; `isAdfRequest` accumulated; `isAdfRequest` ABSENT (not `false`) when no ADF conversion |
| BC-3.8.021 | PRIMARY | Empty ADF-backed JSM extra field → OMIT from `requestFieldValues`; `isAdfRequest` NOT accumulated for omitted field |
| BC-3.8.022 | PRIMARY | `isAdfRequest: true` accumulated and reflected in POST body whenever ANY extra field is ADF-converted |

**DQ-6 layer boundary (SETTLED by ADR-0024):** ADF detection/conversion/`isAdfRequest`
accumulation all belong in the `jsm_create.rs` resolution layer, NOT in
`JsmRequestBuilder::build()`. `build()` ONLY reflects the pre-computed boolean it
receives — it NEVER inspects value types to decide whether `isAdfRequest` should be set.

**`is_adf_field_value` usage:** This story calls `field_resolve::is_adf_field_value` (the
`pub(crate)` function from Story 1). No new detection logic is authored here. The
`is_adf_field_value` function receives `&rt_field.jira_schema` DIRECTLY (the inner schema
block from `RequestTypeField`), NOT wrapped in `{"jiraSchema": ...}` double-nesting.

## Acceptance Criteria

### AC-001: DQ-6 type/signature decision + `isAdfRequest` as pre-computed bool (traces to BC-3.8.022 precondition, VP-FIELD-ADF-004 axis b; §5 item F4-DQ6)

F4 begins by making the DQ-6 type/signature decision: either (a) widen
`FieldValueSpec.value` from `String` to `serde_json::Value` (so an ADF-converted value
can be held in the existing `extra_fields` map), or (b) add a parallel
`resolved_adf_values: BTreeMap<String, serde_json::Value>` alongside `extra_fields` (no
change to `FieldValueSpec.value`). The choice is architectural preference; either is
correct. The decision gates VP-FIELD-ADF-004 axes (b)-(f) test authoring.

`JsmRequestBuilder::build()` receives `isAdfRequest` as an explicit `bool` parameter
(or field). It NEVER derives the flag by inspecting `requestFieldValues` entries or
checking whether values are objects vs. strings. The `is_adf_request` boolean is
accumulated ONLY in the resolution layer (jsm_create.rs), not in `build()`.

This constraint is enforced by VP-FIELD-ADF-004 Axis (c)'s "ABSENT-check strictness"
test: it verifies the key is ABSENT (not `false`) when no ADF conversion occurred —
a derivation-in-`build()` implementation cannot pass this assertion because it would
have to inspect values (which may be empty strings, not ADF objects) to decide.

### AC-002: `is_adf_field_value` call — no double-nesting (traces to BC-3.8.019 precondition, VP-FIELD-ADF-004 Axis a, VP-FIELD-ADF-001 (shared `is_adf_schema` predicate — transitive); §5 item F4-OBS1-1)

`handle_jsm_create` (or the resolution function it delegates to) calls
`field_resolve::is_adf_field_value(&rt_field.jira_schema)` — passing the INNER schema
block directly. `rt_field.jira_schema` IS the inner schema. The caller MUST NOT wrap it
in another `serde_json::json!({"jiraSchema": rt_field.jira_schema})` before passing
it (the double-nesting anti-pattern that produced `is_adf_field_value` returning `false`
for all inputs before this fix).

`test_bc_3_8_019_is_adf_field_value_receives_inner_schema_not_double_nested`: a unit
test constructing a `RequestTypeField` with `jira_schema` having
`schema.type = "string"`, `schema.system = "description"` (allowlist match); calls
`is_adf_field_value(&rt_field.jira_schema)` directly and asserts `true`; calls
`is_adf_field_value(&json!({"jiraSchema": rt_field.jira_schema}))` and asserts `false`
(demonstrating the double-nesting produces a wrong result — this is Axis (a) as a
two-sided example test).

**Test method: DEFAULT CI** (pure function, no network).

### AC-003: JSM metadata acquisition (traces to BC-3.8.019 precondition; §5 F4 integration path)

`handle_jsm_create` calls `get_request_type_fields` when ≥1 `--field` token has a BARE
form (`kind.is_none()`). The call is wrapped in a cache lookup (cache hit → no HTTP).
On ANY fetch failure (network error, non-200 status, deserialization error): (a) emit
a single `"warning: …"` line to stderr (one line, not per-field), (b) fall back to
treating ALL bare `--field` tokens as plain `Value::String(value)`, (c) NEVER exit 64
on this code path (fail-open). Hinted-kind tokens (`:option`, `:id`, `:name`, `:asset`)
bypass the RT-fields fetch and are unaffected by fetch failure.

The single global warning format is tested (Axis (e) test) — the exact wording is F4's
choice, but it MUST appear exactly once on stderr regardless of how many bare fields
triggered the code path.

### AC-004: Non-empty ADF-backed extra field — ADF conversion + accumulation (traces to BC-3.8.019/020/022 postconditions, VP-FIELD-ADF-004 Axes b-e; §5 F4 DQ-6-gated ACs; OBS-1 items 1-4)

**DQ-6-GATED — these ACs require the type/signature decision from AC-001 before tests
can be authored.**

For a non-empty bare `--field NAME=VALUE` where `NAME`'s `RequestTypeField` has a
`jira_schema` that `is_adf_field_value` returns `true` for:
(a) `requestFieldValues[NAME]` is an ADF document object with `"type": "doc"`, `"version": 1`, non-empty `"content"` array — NOT `Value::String(VALUE)`.
(b) No `text` node in the content tree contains a raw `\n` or `\r` (INV-1, multi-line → hardBreak nodes).
(c) The `is_adf_request` boolean accumulates `true` for this field.
(d) The assembled POST body's `"isAdfRequest"` key is `true`.
(e) These apply for all three allowlist variants: `system == "description"` (BC-3.8.019), `system == "environment"` (BC-3.8.019), `custom` ends with `":textarea"` (BC-3.8.020).

Required tests (DQ-6-gated):
- `test_bc_3_8_019_jsm_description_extra_field_adf_converted` (Axis b)
- `test_bc_3_8_020_jsm_textarea_extra_field_adf_converted` (Axis b)
- `test_bc_3_8_022_is_adf_request_accumulated_for_adf_field` (Axis c)
- `test_bc_3_8_020_is_adf_request_absent_when_no_adf_field_present` (Axis c ABSENT-check — plain strings, required but NOT sufficient alone; see I-2 below)
- `test_bc_3_8_022_is_adf_request_absent_with_hinted_object_field_no_adf` (Axis c I-2 discriminator-precision regression)

**Axis c I-2 discriminator-precision regression scenario
(`test_bc_3_8_022_is_adf_request_absent_with_hinted_object_field_no_adf`):**
This test is the ONLY scenario that kills the mutant class "derive `isAdfRequest` from
`self.extra_fields.values().any(|v| v.is_object())` in `build()` rather than from the
explicit accumulated boolean passed by the resolution layer."

Scenario: construct a JSM create with ONE hinted `:id` (or `:name`) extra field and NO
ADF-backed extra field. A hinted `:id`/`:name` token is resolved by the hint-composer
path (not ADF-converted) and serializes to a JSON **object** in `requestFieldValues`.
Because no ADF conversion took place, `isAdfRequest` must be ABSENT (`body.get("isAdfRequest").is_none()`).

Why the plain-string ABSENT test (`test_bc_3_8_020_is_adf_request_absent_when_no_adf_field_present`)
does NOT kill this mutant: that test supplies only plain-string extra fields (zero objects
in `requestFieldValues`). The faithful `is_object()` derivation-in-`build()` mutant sees
zero objects → derives `false` → omits the key → `.is_none()` passes → mutant SURVIVES.

The I-2 test supplies a hinted-object extra field (non-zero objects in `requestFieldValues`)
but with NO ADF backing. The `is_object()` mutant incorrectly emits `"isAdfRequest": true`
(sees the hinted-object value) while the correct behavior is ABSENT → `.is_none()` FAILS
the mutant. This test is therefore REQUIRED in addition to the plain-string ABSENT test.

The I-2 test is NOT DQ-6-gated: a hinted `:id`/`:name` token produces an object value
regardless of the DQ-6 type/signature decision (that decision governs how ADF values are
stored, not how hinted values are stored). Author this test as soon as the DQ-6 shape is
settled and the ADF accumulation logic skeleton exists.

**ABSENT-check strictness:** ALL Axis (c) ABSENT tests MUST use
`body.get("isAdfRequest").is_none()`, NOT `.unwrap_or(false)`. Two pre-existing tests
in the JSM test suite use `.unwrap_or(false)` — these MUST be replaced with `.is_none()`
(VP-FIELD-ADF-004 pass-14 M-1 finding). `.unwrap_or(false)` passes on both absent and
`false` values — it cannot kill a mutant inserting `"isAdfRequest": false`.

**Test method: DEFAULT CI** (resolution-layer unit tests, DQ-6-gated shape).

### AC-005: OBS-1 verbatim — F4 Story 2 gate checklist (traces to VP-FIELD-ADF-004 §4 OBS-1 obligation)

**This AC must appear verbatim in the F4 Story 2 delivery as a named, numbered item
that the orchestrator and gate reviewers tick off independently.**

"VP-FIELD-ADF-004 axes (b)–(e) [DQ-6-gated] and (f) [resolution-layer, authorable once
DQ-6 type/signature shape lands] are not yet authored. Before closing Story 2: (1) make
the DQ-6 type/signature decision (option a or b); (2) author VP-FIELD-ADF-004 axes
(b)–(e) unit tests targeting the decided shape; (3) author Axis (f) unit test
(resolution-layer test — I-1 regression pin — which shares the same DQ-6 test-harness
dependency as Axes (b)–(e)); (4) confirm all VP-FIELD-ADF-004 axes (a–g) pass GREEN
(Axis (h1)/(h2) are platform-path guards tracked separately in §5 item 18 — NOT part of
Story 2's OBS-1 gate); (5) author and confirm GREEN VP-FIELD-ADF-003 Axis D sub-cases —
BOTH platform (`test_adf_empty_guard_fires_only_on_bare_form_not_hinted_platform`) AND
JSM (`test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm`) — these tests target
the extracted pure gate code for the `kind.is_none()` ADF-guard condition (F4 extraction
obligation) directly, NOT the `jsm_create.rs` resolution layer; the exact decomposition
is F4's choice; they do NOT share the DQ-6 test-harness dependency; author them as soon
as the pure gate code is extracted at F4 (independent of the DQ-6 type/signature
decision — authorable before Story 2's DQ-6 axes); (6) confirm that the Axis (e) test
(`test_jsm_adf_field_metadata_unavailable_emits_warning`) includes the pass-21 M-1
sub-assertion: for a bare empty `--field NAME=` targeting an allowlist field_id under
the fail-open path, assert (i) `requestFieldValues[NAME] == Value::String("")` (present,
NOT omitted), and (ii) `isAdfRequest` ABSENT (key not emitted)."

**F4 gate instructions:** This AC text must appear as "Checkbox A" in the F4 Story 2
completion gate checklist. OBS-1 items (1)-(6) above must each be individually verifiable.
Axis (h1) and (h2) (platform-path guards) are tracked via Story 1, NOT this checkbox.

> **NOTE (Axis-D platform ownership):** The platform Axis-D sub-case test (`test_adf_empty_guard_fires_only_on_bare_form_not_hinted_platform`) is AUTHORED/OWNED by Story 1 (S1 AC-004); Story 2's gate RE-CONFIRMS it GREEN (does not re-author it).

### AC-006: Checkbox B — `build()` assembly-order fix (traces to BC-3.8.019 EC-3.8.019-4 assembly-order postcondition, VP-FIELD-ADF-004 Axis g; §5 item 5a)

**Checkbox B is INDEPENDENTLY REQUIRED — it is NOT satisfied by Checkbox A (OBS-1)
alone. A gate reviewer must tick BOTH checkboxes separately at F4 close.**

(a) **Author test** `test_bc_3_8_019_build_description_supersedes_extra_field_description_entry`:
- Construct a `JsmRequestBuilder` with `self.description = Some("text X")`.
- Inject via `extra_fields["description"]` a `FieldValueSpec { value: "Y".into(), kind: None }` (loop string-wraps to `Value::String("Y")` in `requestFieldValues`; `kind: None` reaches the string-wrap branch).
- Call `build()`.
- Assert `requestFieldValues["description"]` is an ADF doc (has `"type": "doc"`) produced from `"text X"`, NOT `Value::String("Y")`.
- This test is pure — no network, no `RequestTypeField` metadata.
- **Currently RED** — the existing `build()` writes `self.description`'s ADF BEFORE the `for (k, spec) in self.extra_fields` loop, so the loop overwrites it with `Value::String("Y")`.

(b) **Apply source reorder** in `src/api/jsm/requests.rs::JsmRequestBuilder::build`:
- Move the `rfv.insert("description", adf_body)` call (BC-3.8.006 channel) to AFTER the `for (k, spec) in self.extra_fields` loop.
- ONLY the description insert moves — `summary`, `priority`, `labels`, and all other dedicated-flag inserts STAY BEFORE the loop (preserving their last-wins behavior per BC-3.8.008).
- **Scope constraint:** Moving the entire dedicated-flag block would invert last-wins for non-description keys; the Axis (g) regression assertion (`--request-type RT --summary A --field summary=B` → `requestFieldValues["summary"] == "B"`) catches this mistake.

(c) Confirm Axis (g) turns GREEN after the reorder.

**Axis (g) sub-case 2 (ADF-object pre-seed, DQ-6-gated) is NOT part of Checkbox B:**
Delta §4 Axis (g) describes two sub-cases: (sub-case 1) `Value::String(Y)` fail-open
form [covered above in (a)/(b)/(c)] and (sub-case 2) ADF-object pre-seed (where
`extra_fields["description"]` already holds an ADF object before the loop runs).
Sub-case 2 is DQ-6-gated and is NOT required by Checkbox B or OBS-1 this cycle. Its
omission from this AC is documented-intentional, not an accidental gap.

### AC-007: VP-FIELD-ADF-003 Axis C — JSM empty ADF-backed field omitted, `isAdfRequest` NOT accumulated (traces to BC-3.8.021 postcondition, VP-FIELD-ADF-003 Axis C; §5 VP-003 Axis C)

For a bare `--field NAME=` (empty or whitespace) where `NAME`'s `RequestTypeField`
indicates an ADF-backed field: (a) `requestFieldValues` does NOT contain an entry for
`NAME` (absent, not `null`, not `""`, not a clear-doc); (b) `isAdfRequest` is NOT
accumulated for the omitted field — `is_adf_request` stays `false` for this field's
contribution.

This is DISTINCT from the platform behavior: the EDIT path sends a clear-doc; the JSM
CREATE path OMITS. Do NOT unify.

The empty-omit guard fires ONLY when the resolution layer HAS ADF metadata AND detects
the field as ADF-backed. Under fail-open (EC-3.8.021-3 — metadata fetch failed), the
empty-omit logic is NOT reached; an empty bare value falls back to `Value::String("")`
(present in body, not omitted) and `isAdfRequest` is ABSENT.

`test_bc_3_8_021_jsm_empty_adf_field_omitted_isadfrequest_not_accumulated` (Axis C, DQ-6-gated).

**Test method: DEFAULT CI** (DQ-6-gated).

### AC-008: Fail-open path — global warning + bare values as plain strings (traces to BC-3.8.019 EC-3.8.019-2, VP-FIELD-ADF-004 Axis e; §5 VP-004 Axis e)

When the `get_request_type_fields` fetch FAILS (any error):
(a) Exactly one `"warning: …"` line emitted to stderr — one line total, not per-field.
(b) ALL bare `--field` tokens degrade to `Value::String(value)` (including empty values).
(c) `isAdfRequest` key is ABSENT from the POST body (key omitted — NOT explicit `false`).
(d) The command does NOT exit 64 on this code path.
(e) The Axis (e) test includes the pass-21 M-1 sub-assertion: for a bare empty `--field NAME=` targeting an allowlist field_id, assert (i) `requestFieldValues[NAME] == Value::String("")` (present, NOT omitted), and (ii) `isAdfRequest` ABSENT.

`test_jsm_adf_field_metadata_unavailable_emits_warning` (Axis e, DQ-6-gated).

**Test method: DEFAULT CI** (DQ-6-gated — resolution-layer test).

### AC-009: VP-FIELD-ADF-003 Axis D — JSM sub-case: bare-form gate for empty guard (traces to VP-FIELD-ADF-003 Axis D JSM sub-case; §5 OBS-1 item 5)

The `kind.is_none()` ADF-guard condition for the empty-omit path must be extracted into
pure, network-free code (F4 extraction obligation — exact decomposition is F4's choice).
Once extracted, `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm` asserts:
a hinted-kind `--field NAME[:option]=""` (or `:id`/`:name`/`:asset`) BYPASSES the ADF
empty-omit guard and routes to the hint-composer path.

This test is NOT DQ-6-gated — it targets the pure gate code directly, not the
`jsm_create.rs` resolution layer. It MUST be authored as soon as the gate code is
extracted at F4, independent of the DQ-6 type/signature decision.

`test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm` (Axis D JSM sub-case).

**Test method: DEFAULT CI** (pure no-network after F4 extraction).

### AC-010: VP-578-015 carve-out — ABSENT-check strictness fix in pre-existing tests at BOTH locations (traces to BC-3.8.020, VP-FIELD-ADF-004 pass-14 M-1 finding; §5 item 13)

Before implementing the ADF accumulation logic, fix BOTH pre-existing ABSENT-enforcement
locations that carry the lax `.unwrap_or(false)` form — these are the **complete set**
of existing-code ABSENT-enforcement targets (delta §5 item 13):

**Location 1 — `src/api/jsm/requests.rs` ~lines 335–338 (proptest):**
Replace:
```rust
let is_adf = body.get("isAdfRequest").and_then(Value::as_bool).unwrap_or(false);
prop_assert!(!is_adf, "... absent/false ...");
```
With:
```rust
prop_assert!(
    body.get("isAdfRequest").is_none(),
    "isAdfRequest must be ABSENT (NOT explicit false) when no ADF value is present"
);
```

**Location 2 — `tests/issue_create_jsm.rs` ~lines 823–831, integration test
`test_jsm_create_plain_description_absent_when_no_description_flag`:**
Replace:
```rust
let is_adf = body.get("isAdfRequest").and_then(Value::as_bool).unwrap_or(false);
assert!(!is_adf, "BC-3.8.006: isAdfRequest must be absent or false when --description not set; …");
```
With:
```rust
assert!(
    body.get("isAdfRequest").is_none(),
    "BC-3.8.006: isAdfRequest must be ABSENT (NOT explicit false) when --description not set; …"
);
```

Both replacements MUST be in the same commit. The stale "absent/false" / "absent or false"
wording must be updated to "ABSENT (NOT explicit false)" in BOTH locations.

The positive-case assertion (`isAdfRequest == true`) uses `.and_then(Value::as_bool).unwrap_or(false)`
and is correct for the positive case — only the negative case requires `.is_none()`.

### AC-011: VP-578-015 scope narrowing — bare-form JSM fixtures need RT-fields wiremock stubs (traces to BC-3.8.019, VP-578-015 carve-out; §5 VP-578-015)

VP-578-015 (pre-existing) verified that `JsmRequestBuilder::build()` serializes
`requestFieldValues` correctly. Its scope is NARROWED in cycle-012: bare-form JSM
fixtures that previously ran WITHOUT wiremocking the `GET .../requesttype/{id}/field`
call will now trigger the new `get_request_type_fields` call in `handle_jsm_create`.

**(a) Field-id allowlist audit (delta §5 item 11(a)):** For each bare-form VP-578-015
fixture, confirm the fixture's `--field NAME=VALUE` token's `NAME` (resolved to a
`field_id`) is NOT in the ADF allowlist (i.e., `jira_schema.system` is NOT
`"description"` or `"environment"`, and `jira_schema.custom` does NOT end with
`":textarea"`). Document this per-fixture check as a named assertion or PR comment.

**(b) ADF-backed fixture update (delta §5 item 11(b)):** If any bare-form VP-578-015
fixture DOES target an ADF-backed `field_id` (allowlist match found in step (a)),
update that fixture to assert ADF doc output (`requestFieldValues[NAME]` is an ADF
object with `"type": "doc"`) instead of a plain-string assertion. This changes the
fixture from a plain-string regression-check to an ADF-correctness check. The fixture
must also gain a wiremock stub for `GET .../requesttype/{id}/field` that returns the
ADF-backed field's schema.

**(c) Non-ADF byte-identity carve-out (delta §5 item 11(c) / delta §7):** For each
VP-578-015 fixture whose `field_id` is confirmed NOT in the ADF allowlist (step (a)
found no allowlist match), assert that `requestFieldValues[NAME]` remains byte-identical
to the original input string. ADF conversion is strictly limited to allowlist field_ids;
non-ADF fields MUST pass through verbatim regardless of the new `get_request_type_fields`
call.

**(d) Path assignment for fixtures triggering the new RT-fields fetch (delta §5 item 11(d)):**
Each bare-form fixture that would now trigger `get_request_type_fields` must follow one of
two paths:

(i) Provide a wiremock stub for `GET .../requesttype/{id}/field` so the call succeeds
    cleanly. For each fixture on this path: audit every `.expect(N)` and exact-request-count
    assertion in that fixture for invalidation by the injected fields-fetch call; update any
    count that was computed without the new call. Do NOT silently remove or weaken any
    ADF-output or JSON-key assertion while performing this update.

(ii) Rely on the fail-open path (no stub; fetch yields an error → single global warning
     emitted; bare fields degrade to `Value::String`). For each fixture on this path: audit
     every `stderr-clean` or "no warnings" assertion; remove or narrow any such assertion
     now INVALIDATED by the fail-open `warning:` line. Do NOT silently weaken any ADF-output
     or JSON-key assertion while doing so.

VP-578-015 tests that ONLY use hinted-kind tokens (`:option`, `:id`, `:name`, `:asset`)
are UNAFFECTED — hinted-kind tokens bypass the RT-fields fetch entirely.

The test author must audit all VP-578-015 tests for bare-form tokens and apply
(a)-(c) and (d)(i)/(d)(ii) as needed before closing this story.

### AC-012: JSM create success output — no per-field echo (traces to BC-3.8.001 postcondition — context/regression-only, not a Story-2-owned implementation BC; §5 JSM output invariant)

On a successful `jr issue create --request-type RT --field <ADF-BACKED>=VALUE`, the
success output is `Created request <KEY>` — no per-field echo, no `(adf)` marker, no
table row for the ADF-backed field. The `field_markers` side-channel from Story 1 is
NOT populated by `jsm_create.rs` (Story 1's Architecture Compliance Rule 4 confirmed
it). The JSM create path has no per-field table output surface.

**BC-3.8.001 is cited here as a context/regression reference** (JSM key-only output must
not regress); it is NOT a Story-2-owned implementation BC and MUST NOT be added to
`bcs:` frontmatter.

`test_bc_3_8_019_jsm_create_output_is_key_only_no_adf_marker`: drives a wiremock
JSM create call with an ADF-backed `--field`; asserts stdout matches
`"Created request <KEY>\n"` (no field echo); asserts `(adf)` does NOT appear in stdout.

**Test method:** wiremock/CLI-level (requires RT-fields HTTP stub + request POST stub).

### AC-013: `build()` does not inspect value types to set `isAdfRequest` (traces to BC-3.8.022 invariant, VP-FIELD-ADF-004 Axis b constraint; §5 DQ-6 layer-boundary invariant)

`JsmRequestBuilder::build()` receives the `is_adf_request` bool as input from the
resolution layer. It NEVER iterates `self.extra_fields` or `requestFieldValues` to
count ADF objects or inspect value shapes. A mutant removing the explicit bool parameter
and replacing it with a `self.extra_fields.values().any(|v| v.is_object())` derivation
in `build()` MUST be killed by the Axis (c) I-2 regression test.

**Correction from pass-3 adversarial review:** the plain-string ABSENT test
(`test_bc_3_8_020_is_adf_request_absent_when_no_adf_field_present`) alone is NOT
sufficient to kill this mutant class. When `extra_fields` contains only plain-string
values (zero objects), the faithful `is_object()` derivation-in-`build()` sees zero
objects, derives `false`, omits the key, and `.is_none()` passes — the mutant SURVIVES.

The required discriminator-precision scenario is the Axis (c) I-2 test (delta §4 VP-FIELD-ADF-004
Axis (c) I-2, lines ~1030-1038): a JSM create with a hinted `:id`/`:name` extra field
present (which serializes to a JSON **object** in `requestFieldValues`) AND **no**
ADF-backed extra field. The `is_object()` mutant incorrectly emits `"isAdfRequest": true`
(it sees the hinted-object value), but the correct behavior is ABSENT — `.is_none()` FAILS
the mutant. This I-2 test (`test_bc_3_8_022_is_adf_request_absent_with_hinted_object_field_no_adf`)
is required and is included in AC-004's Required tests list. Together, the plain-string
ABSENT test and the I-2 regression test cover the two mutant classes; neither alone is
sufficient.

### AC-014: CHANGELOG entry (traces to BC-3.4.034 Behavior item 4 — context/regression-only, not a Story-2-owned implementation BC; §5 CHANGELOG obligation)

The combined `### Fixed` CHANGELOG entry for the full ADF autoconvert feature was
added in Story 1 (S-cycle12-platform-adf-autoconvert AC-015). This story's F4 PR MUST
NOT add a second, duplicate entry for JSM create behavior. Instead, F4 must VERIFY the
Story 1 CHANGELOG entry covers JSM create behavior and extend it minimally if the JSM
behaviors are not already enumerated. The combined entry is one row under
`[Unreleased] > Fixed`, covering: platform edit ADF-backed fields, platform create
ADF-backed fields, empty-value clear/omit semantics, and JSM create ADF-backed fields.

**BC-3.4.034 is cited here as a context/regression reference** (the combined CHANGELOG
entry is owned by Story 1); it is NOT a Story-2-owned implementation BC and MUST NOT be
added to `bcs:` frontmatter.

If Story 1 has already merged and its CHANGELOG entry already covers JSM create, no
CHANGELOG edit is needed in this story's PR. Verify before opening PR.

### AC-015: RT-fields GET fires IFF ≥1 bare `--field` pair; warm cache skips HTTP; 401 emits mandatory warning without `write:servicedesk-request` hint (traces to BC-3.8.019 precondition, VP-FIELD-ADF-004; §5 item 7 FIRM-MUST)

The following three wiremock behaviors MUST each have a named test. None is covered by
the VP-FIELD-ADF-004 unit tests — each is the ONLY mutation-killer for its path
(delta §5 item 7):

**(a) GET fires IFF ≥1 BARE pair — including negative assertion:**
`test_jsm_adf_rt_fields_get_fires_iff_bare_field_present`:
- A bare `--field NAME=VALUE` JSM create → `GET .../requesttype/{id}/field` fires exactly once.
- A JSM create with NO `--field` pairs → NO `GET .../requesttype/{id}/field` call issued.
- A JSM create with ONLY hinted `--field` pairs (e.g. `--field cf:id=5`) → NO `GET .../requesttype/{id}/field` call issued.
All three sub-cases MUST be individually asserted (per delta §5 item 6 M-2 gate correction, pass-19).

**(b) Warm cache → NO HTTP on next same-key create:**
`test_jsm_adf_rt_fields_cache_warm_skips_http`:
- First bare-form create triggers `GET .../requesttype/{id}/field`; response cached via `write_request_type_fields_cache`.
- A second identical create (same profile/sid/rtId) issues NO `GET .../requesttype/{id}/field` HTTP call (wiremock: stub registered once, assert call count ≤ 1 across both creates).

**(c) 401 on fields-fetch → mandatory global warning line present; `write:servicedesk-request` hint ABSENT:**
`test_jsm_adf_rt_fields_fetch_401_emits_global_warning_not_write_scope_hint`:
- Wiremock returns 401 on `GET .../requesttype/{id}/field`.
- Asserts: `stderr` contains the mandatory warning prefix `"warning: could not fetch request type fields"`.
- Asserts: `stderr` does NOT contain `"write:servicedesk-request"` (the write-scope hint is reserved for the create POST itself, NOT the read-only fields-fetch endpoint — delta §5 item 6 finding I-5).
- The command does NOT exit 64 (fail-open; continues to POST).

**Test method:** wiremock/CLI-level for all three sub-cases (`JiraClient::new_for_test` + `MockServer`).

### AC-016: JSM ADF live-E2E smoke — `--field description=VALUE` sends ADF and reads back as ADF object (traces to BC-3.8.019 postcondition; §5 item 4 non-deferrable F4 obligation)

Extend `test_e2e_jsm_create_request_roundtrip` (or add a companion test
`test_e2e_jsm_create_adf_field_description_roundtrip`) in `tests/e2e_live.rs` to verify:
- `jr issue create --request-type RT --field description=VALUE` via the bare form
  (non-empty VALUE) produces a JSM create request where `requestFieldValues["description"]`
  is sent as an ADF document object (not a plain string).
- Read back the created request's `description` field via `jr issue view <KEY> --output json`
  and assert the `description` value is an ADF object (not a plain string).

Gated on `JR_E2E_JSM_PROJECT` + `JR_RUN_E2E=1` + `#[ignore]`.
Clean-skip when `JR_E2E_JSM_PROJECT` is unset.
Self-close the created request on teardown (via `jsm_self_close`, per CLAUDE.md).

**Test method:** Live E2E (gated `JR_RUN_E2E=1`; `tests/e2e_live.rs`).

### AC-017: `.cargo/mutants.toml` coverage confirmed for JSM files (traces to BC-3.8.019/020; §5 items 1/2)

Before this story's PR merges, confirm that `src/cli/issue/jsm_create.rs` and
`src/api/jsm/requests.rs` are already covered by whole-file `examine_globs` entries in
`.cargo/mutants.toml`. Per delta §5 items 1/2, no scope edit is required — these entries
already exist (verified: `jsm_create.rs` at line 21 and `requests.rs` at line 26 of
`.cargo/mutants.toml`). Confirm only; no edit needed.

**Test method:** N/A (grep-confirmed during PR review; no code change required).

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `handle_jsm_create` (metadata acquire + resolution loop) | `src/cli/issue/jsm_create.rs` | Effectful (network, cache, stderr) |
| `is_adf_field_value` (shared predicate) | `src/cli/issue/field_resolve.rs` | Pure |
| `JsmRequestBuilder::build()` (pure assembler) | `src/api/jsm/requests.rs` | Pure |
| `text_to_adf` (ADF conversion) | `src/adf.rs` | Pure |
| `read_request_type_fields_cache` / `write_request_type_fields_cache` | `src/cache.rs` | Effectful (disk) |
| `get_request_type_fields` | `src/api/jsm/request_types.rs` | Effectful (network) |

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | RT-fields fetch fails with any error (network, 401, 403, 404, 500) | Fail-open: single global stderr warning; all bare `--field` values degrade to `Value::String`; command continues to POST (BC-3.8.019 EC-3.8.019-2, BC-3.8.020 EC-3.8.020-5, AC-008) |
| EC-002 | Bare empty `--field NAME=` for ADF-backed field, metadata available | Omit from `requestFieldValues`; `isAdfRequest` NOT accumulated (BC-3.8.021, AC-007) |
| EC-003 | Bare empty `--field NAME=` for ADF-backed field, metadata unavailable (fail-open path) | `requestFieldValues[NAME] == Value::String("")` (present, NOT omitted); `isAdfRequest` ABSENT (EC-3.8.021-3, AC-008(e)) |
| EC-004 | `--field NAME=VALUE` where NAME absent from successfully-fetched RT field list | String-wrap verbatim, no warning, `isAdfRequest` unchanged (I-1 rule, VP-FIELD-ADF-004 Axis (f), AC-005 OBS-1 item 3) |
| EC-005 | `--markdown + --field description=VALUE` on JSM create path | Already guarded: BC-3.8.017 exits 64 (pre-existing test `test_jsm_create_markdown_field_description_conflict_exits_64`); no Story 2 implementation needed |
| EC-006 | Hinted `--field cf:id=5` only (no bare pairs) | No RT-fields fetch issued; hinted pairs bypass ADF conversion entirely (AC-015(a)) |
| EC-007 | Warm cache hit on second JSM create with same (profile/sid/rtId) | No HTTP for fields-fetch GET (AC-015(b)) |
| EC-008 | `--description X` + `--field description=Y` simultaneous | `self.description` deterministically supersedes the extra-field entry per assembly-order after the build() reorder (EC-3.8.019-4, AC-006) |

## Purity Classification

| Function/Site | Pure/Effectful | Rationale |
|--------------|----------------|-----------|
| `is_adf_field_value` | Pure | Deterministic predicate over `serde_json::Value` schema; no I/O |
| `is_adf_schema` (shared core in `field_resolve.rs`) | Pure | Three-arm allowlist; no I/O |
| `text_to_adf` | Pure | Deterministic ADF doc generation; no I/O |
| ADF detection/conversion loop in `jsm_create.rs` | Effectful | Calls `get_request_type_fields` (network/cache) and emits `warning:` on fail-open |
| `JsmRequestBuilder::build()` | Pure | Pure assembler — receives pre-computed values; no network, no stderr (EXEMPT: pre-existing `self.description` ADF channel) |
| `get_request_type_fields` | Effectful | HTTP call to Jira REST API |
| Cache read/write | Effectful | Disk I/O |

## Token Budget Estimate

| Component | Estimated Tokens |
|-----------|-----------------|
| Story spec (this file) | ~10 000 |
| `src/cli/issue/jsm_create.rs` (est. ~1 200 LOC) | ~5 000 |
| `src/api/jsm/requests.rs` (est. ~600 LOC) | ~3 000 |
| `src/cli/issue/field_resolve.rs` reference (~1 635 LOC, read-only) | ~6 000 |
| `src/types/jsm/request_type.rs` | ~2 000 |
| `src/adf.rs` (text_to_adf reference) | ~5 000 |
| New/modified test files | ~8 000 |
| Verification delta §4 VP-003/004 | ~8 000 |
| **Total** | **~47 000** |

~47 000 / 200 000 = **24%** of agent context window — within the 20–30% budget.

## Tasks

1. **Confirm Story 1 has merged** and `is_adf_field_value` is available as `pub(crate)`
   in `field_resolve.rs`.
2. **Make the DQ-6 type/signature decision** (AC-001): choose option (a) widening
   `FieldValueSpec.value` to `serde_json::Value` OR option (b) parallel
   `resolved_adf_values` map. Document the choice in a code comment before implementing.
3. **Author RED tests first** (before any implementation):
   - Axis (a): `test_bc_3_8_019_is_adf_field_value_receives_inner_schema_not_double_nested`
   - Axis (g): `test_bc_3_8_019_build_description_supersedes_extra_field_description_entry` (RED — assembly-order bug)
   - VP-FIELD-ADF-003 Axis C: `test_bc_3_8_021_jsm_empty_adf_field_omitted_isadfrequest_not_accumulated` (DQ-6-gated; author RED before step 8)
   - Axis (c) ABSENT: `test_bc_3_8_020_is_adf_request_absent_when_no_adf_field_present` (DQ-6-gated; use `.is_none()`)
4. **Fix ABSENT-check strictness** (AC-010): replace `.unwrap_or(false)` with `.is_none()`
   at BOTH locations (Location 1: proptest in `src/api/jsm/requests.rs` ~lines 335–338;
   Location 2: `tests/issue_create_jsm.rs::test_jsm_create_plain_description_absent_when_no_description_flag`
   ~lines 823–831) in the SAME commit.
5. **Apply `build()` assembly-order fix** (AC-006 Checkbox B): move `rfv.insert("description", adf_body)`
   to after the `extra_fields` loop in `requests.rs::build`. Confirm Axis (g) turns GREEN.
6. **Extract the `kind.is_none() && is_adf_schema(...) && value.trim().is_empty()` gate
   condition** into pure code (F4 extraction obligation for Axis D). Author
   `test_adf_empty_guard_fires_only_on_bare_form_not_hinted_jsm` and confirm GREEN
   (does NOT require DQ-6 decision).
7. **Implement `get_request_type_fields` call** in `handle_jsm_create` (AC-003): cache
   lookup first; on miss, fetch; on error, fail-open with single global warning.
8. **Implement the ADF resolution loop** in `jsm_create.rs` (AC-004): for each bare
   `--field` token, fetch `RequestTypeField` from the fetched list, call
   `is_adf_field_value(&rt_field.jira_schema)`, on ADF match:
   - Non-empty: convert via `text_to_adf(value)`, store as `serde_json::Value`,
     set `is_adf_request = true`.
   - Empty/whitespace: omit from output (AC-007 Axis C), do NOT set `is_adf_request`.
9. **Author DQ-6-gated and I-2 regression tests** (ACs 004, 007, 008): Axes (b)-(e);
   Axis (c) ABSENT (plain-string, `test_bc_3_8_020_is_adf_request_absent_when_no_adf_field_present`);
   Axis (c) I-2 discriminator-precision regression (`test_bc_3_8_022_is_adf_request_absent_with_hinted_object_field_no_adf`
   — hinted `:id`/`:name` object-valued field present, no ADF backing; see AC-004 I-2 note and AC-013);
   Axis C (empty-omit); Axis (e) fail-open + M-1 sub-assertion. Confirm all RED before
   implementing the accumulation logic, then confirm GREEN. NOTE: the I-2 test is NOT
   strictly DQ-6-gated (hinted values produce objects regardless of the DQ-6 decision) —
   author it as soon as the accumulation logic skeleton exists.
10. **Author Axis (f)** (resolution-layer I-1 regression pin, suggested
    `test_jsm_adf_field_name_absent_from_fetched_list_falls_through_verbatim`): RT-fields
    fetch SUCCEEDED but `NAME` does NOT match any `RequestTypeField.field_id` in the
    returned list → `Value::String(VALUE)` verbatim, ZERO warning lines, `isAdfRequest`
    unchanged. Discriminates from Axis (e) (fires only when the fetch itself failed —
    conflating the two is the mutant this pins). DQ-6-gated.
11. **Add wiremock stub for bare-form VP-578-015 tests** (AC-011): for any existing VP-578-015
    test with bare-form `--field` tokens, add `GET .../requesttype/{id}/field` stub or
    assert fail-open behavior.
12. **Author AC-012 test** (`test_bc_3_8_019_jsm_create_output_is_key_only_no_adf_marker`).
13. **Author AC-015 wiremock tests** (§5 item 7 FIRM-MUST behaviors):
    - `test_jsm_adf_rt_fields_get_fires_iff_bare_field_present` (sub-cases: bare fires, no-field no-fire, hinted-only no-fire)
    - `test_jsm_adf_rt_fields_cache_warm_skips_http`
    - `test_jsm_adf_rt_fields_fetch_401_emits_global_warning_not_write_scope_hint`
14. **Author AC-016 JSM ADF live-E2E test** (`test_e2e_jsm_create_adf_field_description_roundtrip`
    or extend `test_e2e_jsm_create_request_roundtrip`) in `tests/e2e_live.rs`, gated on
    `JR_RUN_E2E` + `JR_E2E_JSM_PROJECT`.
15. **Verify CHANGELOG** (AC-014): check Story 1's entry covers JSM create behaviors;
    extend with a sub-bullet if not.
16. **Confirm `.cargo/mutants.toml` coverage** (AC-017): grep that `jsm_create.rs` (line 21)
    and `requests.rs` (line 26) are in existing `examine_globs` entries; no edit needed.
17. **Open PR** targeting `develop`; confirm all non-E2E tests pass under `cargo test`;
    confirm Checkbox A (OBS-1) and Checkbox B (item 5a) can each be independently ticked.

## Previous Story Intelligence

**Predecessor:** S-cycle12-platform-adf-autoconvert (Story 1, Wave 1)

Key carry-forwards:
- `is_adf_field_value` is implemented in `field_resolve.rs` and is `pub(crate)`. Call
  it as `field_resolve::is_adf_field_value(&rt_field.jira_schema)` — do NOT re-implement
  the detection logic in `jsm_create.rs`.
- `field_markers` exists on `FieldResolutionOutputs` as of Story 1 but is NOT populated
  by `jsm_create.rs` (JSM has no per-field echo surface).
- Story 1 implemented AC-006 (NET-NEW step 2c guard) and AC-007 (extended edit guard)
  in `create.rs` and `edit.rs` respectively. These guard `--markdown + --field
  description=` for the PLATFORM paths. The JSM path (`jr issue create --request-type`)
  already has an equivalent guard: BC-3.8.017 implements `--markdown + --field
  description=VALUE` → exit 64, pinned by the pre-existing test
  `tests/issue_create_jsm.rs::test_jsm_create_markdown_field_description_conflict_exits_64`
  (delta §5 item 18 / delta line ~1135 confirm the guard is already implemented and tested).
  NO Story 2 guard implementation is required — F4 must only verify the pre-existing
  test still passes (no regression).
- The `ABSENT-check strictness` finding (AC-010) was identified in the verification
  delta during adversarial pass-14. Story 1's tests use `.is_none()` correctly. This
  story must fix the JSM-specific pre-existing tests at BOTH locations (Location 1:
  proptest in `src/api/jsm/requests.rs` ~lines 335–338; Location 2:
  `tests/issue_create_jsm.rs::test_jsm_create_plain_description_absent_when_no_description_flag`
  ~lines 823–831).

## Architecture Compliance Rules

From ADR-0024:

1. **`build()` never detects** (ADR-0024 §Decision, AC-001/013): All ADF detection,
   conversion, and `isAdfRequest` accumulation belong in `jsm_create.rs` (resolution
   layer). `build()` in `api/jsm/requests.rs` only reflects the pre-computed boolean.
2. **No second copy of `is_adf_schema`**: The three-arm allowlist lives exclusively in
   `field_resolve.rs::is_adf_schema`. `jsm_create.rs` calls `is_adf_field_value` —
   never reimplements the allowlist.
3. **`is_adf_field_value` receives the inner schema block** (Axis a): `rt_field.jira_schema`
   IS the inner schema. No double-nesting.
4. **Fail-open on metadata fetch** (BC-3.8.019 EC-3.8.019-2): `get_request_type_fields`
   failure → single global warning + plain-string fallback. NEVER exit 64.
5. **`isAdfRequest` ABSENT, not `false`** (pass-14 M-1): The key must be omitted from
   the POST body when no ADF conversion occurred. Explicit `false` is a behavioral bug
   caught by mutation testing.
6. **Only `description` insert moves** in `build()` assembly-order fix (AC-006): All
   other dedicated-flag inserts remain before the `extra_fields` loop.
7. **JSON render invariant (#526)**: all `--output json` output routes through
   `output::render_json`, never direct `serde_json::to_string_pretty`.
8. **Exit code 64 via `JrError::UserError`** for any user-facing validation errors — not
   clap exit 2.

## Library & Framework Requirements

| Library | Version | Purpose |
|---------|---------|---------|
| `serde_json` | as pinned in `Cargo.toml` | ADF doc output as `serde_json::Value`; `requestFieldValues` |
| `proptest` | as pinned in `Cargo.toml` | Not required for JSM-specific ACs; VP-FIELD-ADF-001 proptest lives in Story 1 |
| `wiremock` | as pinned in `Cargo.toml` | RT-fields HTTP stub and request POST stub for ACs 012/015 |
| `tokio` | as pinned in `Cargo.toml` | Async test runtime (`#[tokio::test]`) |

Do NOT add new dependencies.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/issue/jsm_create.rs` | MODIFY | Add `get_request_type_fields` call (AC-003); ADF detection/conversion loop using `is_adf_field_value` (AC-004); empty-omit guard (AC-007); `is_adf_request` accumulation (AC-004); fail-open warning (AC-008) |
| `src/api/jsm/requests.rs` | MODIFY | Move `rfv.insert("description", adf_body)` to AFTER the extra-fields loop in `JsmRequestBuilder::build()` (AC-006, Axis g fix); replace `.unwrap_or(false)` with `.is_none()` in the ABSENT-check proptest at ~lines 335–338 (AC-010 Location 1) |
| `src/cli/issue/field_resolve.rs` | VERIFY ONLY | Confirm `is_adf_field_value` is `pub(crate)` (from Story 1); no new logic added here |
| `tests/issue_create_jsm.rs` (existing JSM integration test file) | MODIFY/CREATE | VP-FIELD-ADF-003 Axis C, VP-FIELD-ADF-004 all axes, ABSENT-check strictness fixes (AC-010 Location 2), VP-578-015 bare-form stub additions (AC-011), AC-012/015 wiremock tests |
| `tests/e2e_live.rs` | MODIFY | AC-016 JSM ADF live-E2E test (gated `JR_RUN_E2E` + `JR_E2E_JSM_PROJECT`) |
| `CHANGELOG.md` | VERIFY/EXTEND | Confirm Story 1's combined entry covers JSM create; extend minimally if not (AC-014) |
