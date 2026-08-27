---
document_type: story
level: ops
story_id: "S-578-2"
epic_id: "none"
title: "issue edit --field hint-kind dispatch (:option/:id/:name/:asset) + cascading select + dry-run preview"
wave: feature-followup
status: ready
intent: feature
feature_type: backend-cli
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 13
priority: P1
tdd_mode: strict
producer: story-writer
timestamp: "2026-08-26T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-field-dx.md"
input-hash: "a79cf31"
traces_to: "src/cli/issue/field_resolve.rs::resolve_edit_fields"
cycle: field-dx
bundle: field-dx
estimated_effort: large
estimated_days: 4
target_module: src/cli/issue/field_resolve.rs
subsystems: ["SS-02", "SS-05"]
depends_on: [S-578-1]
blocks: []
behavioral_contracts:
  [BC-3.4.015, BC-3.4.016, BC-3.4.021, BC-3.4.027, BC-3.4.028, BC-3.4.029, BC-3.4.030, BC-3.4.031]
verification_properties:
  [VP-578-007, VP-578-008, VP-578-009, VP-578-010, VP-578-011, VP-578-012, VP-578-022, VP-578-023, VP-578-024]
holdout_anchors: []
nfr_anchors: []
adr_refs: [ADR-0019]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-3-issue-write.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 19
assumption_validations: []
risk_mitigations: []
created: "2026-08-26"
version: "1.1"
last_updated: "2026-08-26"
breaking_change: false
retroactive: false
origin: >
  Feature Mode cycle field-dx, issues #580/#578 — part 3 of field-dx bundle (#580, #578).
  Extends `resolve_edit_fields` (src/cli/issue/field_resolve.rs, 914 LOC) with a hinted-bypass
  dispatch branch (reading FieldValueSpec.kind) that runs BEFORE the existing editmeta
  type-dispatch, which remains the kind==None bare-form path, byte-for-byte unchanged. Adds
  cascading-select composition (:option, > delimiter, str::split_once), the :id/:name
  verbatim-wrap bypasses, the :asset Assets object-reference composer (workspace-id resolved
  here at L2, never inside JsmRequestBuilder::build()), and the dry-run plannedChanges
  hint-preview amendment (BC-3.4.021). This is one of THREE call sites asserting VP-578-022
  (:asset cold-cache failure taxonomy) — S-578-2 (edit), S-578-3 (JSM), S-578-4 (create) each
  carry their own independent assertion of this VP at their own call site; do not treat it as
  already covered by another story.
changelog:
  - "1.0 (2026-08-26): Initial story authored; F2 gate convergence; bundle field-dx (issues #580/#578), wave 2."
  - "1.1 (2026-08-26): Propagated PO-approved BC-level clarifications from bc-3-issue-write.md: added AC-019 for EC-3.4.027-1's entry-point schema.type gate (two message sub-cases, Invariant 7 orthogonality with AC-004); reworded AC-007 to require byte-identical wire OUTPUT for :name/priority (Invariant 2 correction — independent/duplicated code paths acceptable); softened AC-009's HTTP-ordering claim to \"before any workspace-discovery GET or PUT/POST\" per VP-578-012's P1-005 scope correction (field-resolution editmeta GET already fired). acceptance_criteria_count 18 -> 19. No code/tests/BC files touched."
---

> **tdd_mode:** strict — Red Gate required. Write all tests in `tests/issue_field_hint_kinds.rs`
> (new) first — they MUST fail because `resolve_edit_fields` has no hinted-bypass branch yet.
> Also run the FULL existing `tests/issue_edit_field.rs` suite (64 pre-existing test functions)
> before and after this change — it MUST stay green throughout; the hinted-bypass branch must
> not perturb any existing unhinted-input test. Red Gate: new tests FAIL → all tests (new +
> existing 64) PASS.

> **Execute:** `/vsdd-factory:deliver-story S-578-2`

# S-578-2: `issue edit --field` Hint-Kind Dispatch + Cascading Select + Dry-Run Preview

**Bundle**: field-dx (issues #580, #578) — part 3 of 5
**GitHub issue**: #578 (item 1)
**BC anchors**: BC-3.4.015 (amended — bare-form back-compat note), BC-3.4.016 (amended — three
explicit modes vs bare auto-detect), BC-3.4.021 (amended — dry-run `plannedChanges` hint-preview
shape), BC-3.4.027 (`:option`, cascading), BC-3.4.028 (`:id`), BC-3.4.029 (`:name`), BC-3.4.030
(`:asset`), BC-3.4.031 (edit-path EC exercise, regression only)
**VPs**: VP-578-007, VP-578-008, VP-578-009, VP-578-010, VP-578-011, VP-578-012, VP-578-022 (1
of 3 shared call sites), VP-578-023, VP-578-024
**Routing**: standard feature, Wave 2
**Sequencing**: `depends_on: [S-578-1]` — this story threads `FieldValueSpec` (built by S-578-1)
through `resolve_edit_fields`'s call site at `edit.rs` line ~77; it cannot compile without
S-578-1 merged first. No dependency on S-580-1 (separate module, no shared code — this story
does NOT call `get_createmeta_fields`).

**Subsystem anchor justification**: `subsystems: ["SS-02", "SS-05"]` — SS-02 (CLI Layer) owns
this story's scope because `field_resolve.rs` and `edit.rs` are both CLI-layer modules. SS-05
(Assets/CMDB) is touched because the `:asset` hint's workspace-id resolution introduces a NEW
`cli::issue::field_resolve → api::assets::workspace` (L4) edge, per
`architecture-delta-field-dx.md` §3 ("cli::issue::field_resolve → api::assets::workspace (L4)
[NEW, get_or_fetch_workspace_id REUSED read-only — edit path, BC-3.4.030 primary site]").

**Dependency anchor justification**: `depends_on: [S-578-1]` because `resolve_edit_fields`'s
signature change (`field_pairs: &HashMap<String, FieldValueSpec>`, superseding the pre-existing
`&HashMap<String, String>`) requires `FieldValueSpec`/`FieldValueKind` to already exist.
`blocks: []` — no downstream story in this bundle depends on this story's own code (S-578-4
depends on S-580-1 and S-578-2 per the bundle's cross-story dispatch-pattern precedent, but has
no COMPILE dependency on this story's files).

---

## Narrative

- **As a** `jr` CLI user editing an issue's custom select, id-addressable, name-addressable, or
  Assets object-reference field via `--field`
- **I want** explicit `:option`/`:id`/`:name`/`:asset` hint kinds that bypass
  `resolve_edit_fields`'s fuzzy-match heuristics, plus cascading-select (`Parent>Child`)
  composition and a `--dry-run` preview that shows the exact wire shape each hint would send
- **So that** I never have to guess which of Jira's several incompatible custom-field wire
  conventions (`{"id":...}` vs `{"name":...}` vs an Assets object-reference array vs a
  cascading `{"value":...,"child":{"value":...}}` shape) applies to my field, and I can validate
  the composed shape before issuing a live PUT

---

## Behavioral Contracts

| BC | Summary | Clauses Covered |
|----|---------|-----------------|
| BC-3.4.015 | (amended) `--field` bare-form dispatch is UNCHANGED and PERMANENT; `>` is a LITERAL character in the bare form — no split ever attempted | "Hint-syntax interaction" amendment, ">is a LITERAL character..." amendment (D4) |
| BC-3.4.016 | (amended) Bare-form label→id auto-detect for `option`-schema fields UNCHANGED, PERMANENT; `:id` is the explicit, UNCONDITIONAL superset of Step 1's numeric-gated id-bypass | "Hint-syntax interaction" amendment |
| BC-3.4.021 | (amended) `--dry-run` `plannedChanges` per-hint-kind wire-shape preview; `:asset` cold-cache side effect reachable under `--dry-run` | Postconditions — Common item 6, `--output json` item 3 (F-NEW-2 scope note), Invariant 1/2/3, EC-3.4.021-6 |
| BC-3.4.027 | `--field NAME:option=VALUE` — explicit opt-in to bare-form dispatch; cascading `Parent>Child` composition; non-cascading-field collision (D4) | Description, Cascading-select composition, Multibyte-safety MUST (D3), Non-cascading-field collision (D4), Preconditions/Postconditions, Invariants 5/6, EC-3.4.027-1..7 |
| BC-3.4.028 | `--field NAME:id=VALUE` — verbatim `{"id":"<VALUE>"}`, zero `allowedValues` lookup | Description, Postconditions, Invariants 1/2, EC-3.4.028-1..3 |
| BC-3.4.029 | `--field NAME:name=VALUE` — verbatim `{"name":"<VALUE>"}`; `--field priority:name=Medium` ≡ `--priority Medium` byte-for-byte | Description, Postconditions, Invariants 1–3, EC-3.4.029-1/3 |
| BC-3.4.030 | `--field NAME:asset=WORKSPACE:OBJECTID` — Assets object-reference array composition; `str::split_once(':')` MUST; cold-cache workspace-discovery error taxonomy | Parsing rules 1–4, Postconditions, Invariants 1–4, Error taxonomy table, EC-3.4.030-1..6 |
| BC-3.4.031 | Malformed-hint edge cases exercised at THIS call site (regression pass; the parser itself is S-578-1's) | EC-6/7/8/9 regression at the edit call site |

---

## Acceptance Criteria

### AC-001: Hinted-bypass dispatch runs BEFORE the existing editmeta type-dispatch
(traces to BC-3.4.015 "Hint-syntax interaction" amendment)

`resolve_edit_fields` (`src/cli/issue/field_resolve.rs`) reads each `--field` entry's
`spec.kind` and takes the hinted-bypass branch for that field BEFORE falling through to the
EXISTING `schema.type` match when `spec.kind == None`. The bare-form dispatch (Steps 1–6,
BC-3.4.015/016) is UNCHANGED and PERMANENT — this story's hinted branch is strictly additive.

**Test**: `test_bc_3_4_015_hinted_bypass_runs_before_bare_dispatch` in
`tests/issue_field_hint_kinds.rs`.

---

### AC-002: `:option` non-cascading — byte-identical to bare-form auto-detect
(traces to BC-3.4.027 Description, VP-578-007)

`--field NAME:option=VALUE` on a non-cascading `option`-schema field is semantically IDENTICAL
to today's bare `--field NAME=VALUE` dispatch (BC-3.4.016) — human display-value → `allowedValues[].id`
lookup, id-bypass, ambiguity/empty errors all unchanged. Wire output is byte-identical to the
bare form for the same NAME/VALUE.

**Test**: `test_bc_3_4_027_option_hint_non_cascading_byte_identical_to_bare` (VP-578-007) in
`tests/issue_field_hint_kinds.rs`.

---

### AC-003: `:option` cascading — `str::split_once('>')`, `{"value":..,"child":{"value":..}}` wire shape
(traces to BC-3.4.027 "Cascading-select composition", VP-578-008)

For a `schema.type == "option-with-child"` field, `VALUE` MAY contain a single `>` separating
parent and child: `--field 'cf:option=Parent>Child'`. The split MUST use `str::split_once('>')`
(never a char-index-based or fixed-byte-offset scheme — the FIX-F6-LRE-1 panic class, #734).
Resolve the parent segment against `allowedValues[].value` (BC-3.4.016 Step 2 logic); resolve
the child segment against the matched parent entry's `children[].value`. A value with a second
`>` treats everything after the first delimiter as the verbatim child value (Jira's cascading
model has exactly two levels). A bare `VALUE` with no `>` against a cascading field resolves the
parent only. Wire shape: `{"customfield_NNNNN": {"value":"<parent>","child":{"value":"<child>"}}}`.
`changed_fields` echo: `"<parent> > <child>"` (both matched labels, `>`-joined, stored casing).

**Test**: `test_bc_3_4_027_cascading_split_once_wire_shape` (VP-578-008) +
`prop_cascading_split_no_panic` (proptest, D3 multibyte MUST) in `tests/issue_field_hint_kinds.rs`.

---

### AC-004: Non-cascading-field `>`-collision — structural `children`-empty detection, distinct exit-64
(traces to BC-3.4.027 "Non-cascading-field collision" (D4), Invariant 6, EC-3.4.027-7, VP-578-023)

`--field cf:option=A>B` where `A` resolves against a PLAIN (non-cascading) `option` field's
`allowedValues[].value`, `B` is non-empty, and the matched parent's `children` collection is
EMPTY → exit 64 with a message DISTINCT from EC-3.4.027-3's "list allowed child values" shape.
Detected via the structural `children`-empty check (NOT a `schema.type` lookup) at the SAME
point EC-3.4.027-3's existing "unresolvable child" check inspects `children`. Load-bearing
substrings: `"is not a cascading select"` and `"remove the"`. Requires extending
`types::jira::editmeta::AllowedValue` (`src/types/jira/editmeta.rs`, currently `{id, value,
name}`) with `#[serde(default)] pub children: Vec<AllowedValue>` — `Vec`, NOT
`Option<Vec<AllowedValue>>` (wire-absent and wire-empty-array carry the identical "no cascading
children" semantic here).

**Orthogonality with AC-019 (Invariant 7):** this structural `children`-empty check (Question 2:
"among fields already confirmed option/option-with-child, is THIS matched parent entry cascading
or plain?") is a DIFFERENT question from AC-019's entry-point `schema.type` membership gate
(Question 1: "is this an option field AT ALL?"), asked in strict sequence — Question 1 fires
first; this check fires only for fields that already passed it, per matched entry. Neither check
conflicts with, or is redundant with, the other.

**Test**: `test_bc_3_4_027_ec7_non_cascading_collision_distinct_message` (VP-578-023) in
`tests/issue_field_hint_kinds.rs`.

---

### AC-019: EC-3.4.027-1 entry-point `:option` type gate — two distinct exit-64 message sub-cases, runs before any `allowedValues`/`children` inspection
(traces to BC-3.4.027 EC-3.4.027-1, Invariant 7)

`--field NAME:option=VALUE` on a resolved field whose `schema.type` is NOT `"option"` and NOT
`"option-with-child"` → exit 64, via an ENTRY-POINT type gate that MUST run immediately after
`schema.type` is known and BEFORE the `:option` composer inspects `allowedValues` or `children`
at all — i.e. before this BC's own EC-3.4.027-2/3/6/7 checks, which all presuppose `schema.type`
already passed this gate. Two sub-cases, each with a DIFFERENT message content — this split is
itself load-bearing and MUST NOT be collapsed into one generic message, because the two have
different actionable remediation:

- **`schema.type` is `array` or `any`** (a type BC-3.4.015/BC-3.4.016 already treat as wholesale
  unsupported by `--field`, hinted or not) → the `:option` composer MUST call the SAME code path
  BC-3.4.015 Step 4 already uses for this case — reuse EC-3.4.015-5's exact message/exit
  behavior, not a re-derived one. Load-bearing: stderr contains the literal `schema.type` string
  (`"array"` / `"any"`).
- **`schema.type` is anything else the bare form DOES support** (`string`/`number`/`date`/
  `datetime`/`user`, or any future scalar type BC-3.4.016 Step 4 dispatches on) → a DISTINCT
  message from EC-3.4.015-5 (do NOT reuse "unsupported type" wording, which would misleadingly
  imply the field can't be set at all — only the `:option` hint is inapplicable, not the field).
  Load-bearing substrings: `"is not an option field"` and the literal resolved `schema.type`
  string (e.g. `"schema type 'string'"`), naming both the field and its actual type, with a hint
  to drop `:option` and use the bare form instead.

**Non-goal, explicitly:** this gate is a closed-set `schema.type` membership check only — it
never inspects `allowedValues` content or `children`. An `option`/`option-with-child` field with
empty/null `allowedValues` is NOT caught here (that is EC-3.4.016's existing "no configured
option values" case) and must not be conflated with it.

**Orthogonality with AC-004 (Invariant 7):** this entry-point gate (Question 1) and AC-004's
structural `children.is_empty()` D4 check (Question 2) are two DIFFERENT questions asked in
strict sequence and do NOT conflict. Question 1 (this AC) is answered ONCE via a `schema.type`
closed-set membership check, before any `allowedValues`/`children` inspection. Question 2
(AC-004) is answered structurally, on a per-matched-parent-entry basis, NEVER by a second
`schema.type` lookup — precisely because Question 1 already settled the field-level type
question; re-deriving it from `schema.type` at Question 2's point would be redundant, not merely
non-idiomatic. AC-004's "not a `schema.type` lookup" language describes ONLY how Question 2 is
answered — it says nothing about, and does not preclude, this gate's own `schema.type` check
running first.

**Test**: `test_bc_3_4_027_ec1_array_type_reuses_ec_3_4_015_5_message` +
`test_bc_3_4_027_ec1_scalar_type_distinct_is_not_an_option_field_message` +
`test_bc_3_4_027_ec1_gate_runs_before_allowed_values_children_inspection` in
`tests/issue_field_hint_kinds.rs`.

---

### AC-005: `>` is a LITERAL character in the bare form — no split ever attempted (D4)
(traces to BC-3.4.015 "`>` is a LITERAL character..." amendment, VP-578-023 sibling assertion)

A bare `--field cf=Parent>Child` against a cascading (`option-with-child`) field is resolved
EXACTLY as BC-3.4.015's existing algorithm resolves any bare value (Step 4's `option` dispatch,
delegating to BC-3.4.016 Step 4a) — the ENTIRE string `"Parent>Child"` is matched as one opaque
candidate against `allowedValues[].value`. This whole-string match fails and falls through to
the EXISTING EC-3.4.016-2 "unresolvable value, list allowed values" error — NOT
EC-3.4.027-7's distinct message. A cascading field's child value can ONLY be set via the
explicit `--field cf:option=Parent>Child` form.

**Test**: `test_bc_3_4_015_bare_form_greater_than_is_literal_falls_through_to_ec_3_4_016_2`
(VP-578-023 sibling assertion) in `tests/issue_field_hint_kinds.rs`.

---

### AC-006: `:id` — bypasses `allowedValues` lookup entirely, sends `{"id":"<VALUE>"}` verbatim
(traces to BC-3.4.028 Description, Postconditions, VP-578-009)

`--field NAME:id=VALUE` sends `VALUE` verbatim as `{"id": "<VALUE>"}` on the wire — NO
`allowedValues` lookup, NO label matching, NO ambiguity detection. Field-existence and
Edit-screen gating (BC-3.4.015 Step 3) still apply — `:id` bypasses ONLY the `allowedValues`
lookup, not the field-presence check. `changed_fields` echo: `VALUE` (the raw id literal, no
reverse lookup). Works even for an EMPTY `allowedValues` array (wiremock asserts wire body
regardless of `allowedValues` content).

**Test**: `test_bc_3_4_028_id_hint_bypasses_allowed_values_lookup` (VP-578-009) in
`tests/issue_field_hint_kinds.rs`.

---

### AC-007: `:name` — sends `{"name":"<VALUE>"}` verbatim; byte-identical to `--priority <VALUE>`
(traces to BC-3.4.029 Description, Postconditions, Invariant 2, VP-578-010)

`--field NAME:name=VALUE` sends `VALUE` verbatim as `{"name": "<VALUE>"}`. For `priority`
specifically (the one system field also reachable via a dedicated named flag), `--field
priority:name=Medium` MUST produce BYTE-IDENTICAL wire output to `--priority Medium`. Per
BC-3.4.029 Invariant 2 (corrected 2026-08-26, F2 adversary-convergence Pass 1, P1-006), this is a
consistency guarantee on OUTPUT, not an implementation-technique mandate: `--priority`'s
dedicated-flag path and `--field NAME:name=VALUE`'s hint-composer path MAY compose the identical
`{"name": "<VALUE>"}` shape via independent, textually-duplicated code — the dedicated flag's
wire-composition function does NOT need to be shared/reused — PROVIDED the two resulting JSON
bodies are byte-for-byte equal. The test asserts OUTPUT equality at the wire boundary, not any
shared-function implementation detail.

**Test**: `test_bc_3_4_029_name_hint_priority_byte_identical_to_dedicated_flag` (VP-578-010) in
`tests/issue_field_hint_kinds.rs`.

---

### AC-008: `:asset` — composes `[{workspaceId,id,objectId}]` from `WORKSPACE:OBJECTID`
(traces to BC-3.4.030 Parsing rules, Postconditions, VP-578-011)

`--field NAME:asset=WORKSPACE:OBJECTID` composes
`[{"workspaceId": "<resolved>", "id": "<workspaceId>:<objectId>", "objectId": "<objectId>"}]`.
`VALUE` split on the FIRST `:` via `str::split_once(':')` (MUST, mirrors D3's `>` MUST — never a
char-index-based scheme). If a `:` is present: left segment = explicit `workspaceId`, right
segment = `objectId`. If NO `:` is present: the entire `VALUE` is the `objectId`, and
`workspaceId` is resolved via the EXISTING cached `get_or_fetch_workspace_id` (per-profile,
7-day TTL, BC-4.2.001) — the SAME cache `jr assets search` already warms; ZERO additional HTTP
calls on a warm cache. `objectId` MUST be non-empty and match ASCII-only `[0-9]+` (NOT Unicode
`\d`). `get_or_fetch_workspace_id` is called AT MOST ONCE per invocation regardless of how many
`:asset` hints are present. This resolution happens at THIS L2 call site — `field_resolve.rs`
resolves the workspace id itself; it does NOT call into any JSM-layer function.

**Test**: `test_bc_3_4_030_asset_bare_form_warm_cache_zero_http` (VP-578-011) +
`test_bc_3_4_030_asset_explicit_workspace_form` in `tests/issue_field_hint_kinds.rs`.

---

### AC-009: `:asset` composer safety — malformed shapes exit 64 before any workspace-discovery GET or PUT/POST, never malformed JSON
(traces to BC-3.4.030 Error taxonomy / BC-3.4.031 EC-2a/b/c/d/EC-3, VP-578-012)

**Scope correction (2026-08-26, F2 adversary-convergence Pass 1, P1-005):** this is NOT a
"before any HTTP call" claim — the field-resolution `editmeta`/`createmeta` `GET` (BC-3.4.015
Step 3, required to confirm the field is on the Edit screen) has ALREADY occurred by the time
these malformed-shape checks run. What is guaranteed is that the value-shape check fires and
exits 64 BEFORE the `:asset`-specific `get_or_fetch_workspace_id` discovery `GET`
(`GET /rest/servicedeskapi/assets/workspace`) and BEFORE any field-write `PUT`/`POST` — never
before the issue's own field-resolution `GET`, which is unavoidable on this call site regardless
of hint kind. The property test's wiremock server MUST still receive that field-resolution `GET`
and MUST assert zero calls to the workspace-discovery endpoint and zero `PUT`/`POST`.

- `--field cf:asset=` (empty value) → exit 64, "asset reference cannot be empty" (EC-2a).
- `--field cf:asset=ws:` (objectId segment empty) → exit 64, same message as EC-3.4.030-3 (EC-2b).
- `--field cf:asset=:12345` (workspace segment empty, colon present) → exit 64, "workspace
  segment cannot be empty when ':' is present; omit the workspace prefix entirely to use the
  cached workspace id" (EC-2c). This check runs BEFORE the objectId-segment checks — an input
  matching BOTH conditions (e.g. `:asset=:`) ALWAYS surfaces EC-2c's message.
- `--field cf:asset=W:Y:Z` (a second colon inside the value) → the FIRST `:` splits `workspaceId
  = "W"`, remainder `"Y:Z"` fails the ASCII `[0-9]+` check → exit 64 with a message naming the
  extra-colon mistake specifically (e.g. `"unexpected extra ':' in :asset value — expected
  WORKSPACE:OBJECTID"`), NOT the generic "objectId must be numeric" text (EC-2d).
- `--field cf:asset=abc` or `--field cf:asset=ws:abc` (non-numeric objectId, including
  Arabic-Indic/fullwidth digit scripts) → exit 64, "objectId must be numeric" (ASCII `[0-9]+`
  only) (EC-3).

Property test: no panic over arbitrary UTF-8 input across ALL malformed shapes, including the
`WORKSPACE:OBJECTID` first-colon split's own no-panic corpus (mirrors VP-578-008's D3
extension).

**Test**: `test_bc_3_4_031_ec2a_empty_asset_value_exits_64` +
`test_bc_3_4_031_ec2b_empty_objectid_exits_64` +
`test_bc_3_4_031_ec2c_empty_workspace_segment_precedence` +
`test_bc_3_4_031_ec2d_extra_colon_distinct_message` +
`test_bc_3_4_031_ec3_non_ascii_numeric_objectid_exits_64` +
`prop_asset_composer_no_malformed_json_ever` (VP-578-012) in `tests/issue_field_hint_kinds.rs`.

---

### AC-010: `:asset` cold-cache workspace-discovery failure taxonomy — edit-path call site
(traces to BC-3.4.030 Error taxonomy table, VP-578-022 — 1 of 3 shared call sites)

On a cold workspace-id cache, `get_or_fetch_workspace_id`'s GET
(`GET /rest/servicedeskapi/assets/workspace`) can fail. Four rows, exercised at THIS
(`field_resolve.rs`, edit-path) call site independently of S-578-3's JSM-path assertion and
S-578-4's create-path assertion:

| Condition | Behavior |
|---|---|
| 403 or 404 | `JrError::UserError`: "Assets is not available on this Jira site. Assets requires Jira Service Management Premium or Enterprise." → exit 64 |
| 200 + zero workspace entries | `JrError::UserError`: "No Assets workspace found on this Jira site. Assets requires Jira Service Management Premium or Enterprise." → exit 64 |
| 401 | Standard `JrError::NotAuthenticated`/`InsufficientScope` mapping (auto-refresh applies identically to any other 401) |
| 5xx / network error | Standard `JrError::ApiError`/`NetworkError` mapping |

None of these four outcomes is client-side pre-validated — this is a genuine HTTP round-trip on
a cold cache (warm-cache reads never reach this code path, per VP-578-011).

**Test**: `test_bc_3_4_030_edit_path_asset_cold_cache_403_404_assets_unavailable` +
`test_bc_3_4_030_edit_path_asset_cold_cache_empty_workspace` +
`test_bc_3_4_030_edit_path_asset_cold_cache_401_standard_auth_mapping` +
`test_bc_3_4_030_edit_path_asset_cold_cache_5xx_network_standard_mapping` (VP-578-022) in
`tests/issue_field_hint_kinds.rs`.

---

### AC-011: `AllowedValue.children` field extension (D4)
(traces to BC-3.4.027 "Non-cascading-field collision" type-level prerequisite)

`src/types/jira/editmeta.rs::AllowedValue` gains `#[serde(default)] pub children: Vec<AllowedValue>`.
Serde-round-trip test: wire-absent `children` key and wire-present-but-empty `"children": []`
both deserialize to `Vec::new()` (identical semantic — no information loss).

**Test**: `test_allowed_value_children_field_serde_default` in
`src/types/jira/editmeta.rs`'s inline `#[cfg(test)]` module.

---

### AC-012: Dry-run `plannedChanges` — per-hint-kind composed wire shape, NOT display-value string
(traces to BC-3.4.021 amended Postconditions — `--output json` item 3 scope note, VP-578-024)

Under `issue edit --dry-run`, `plannedChanges`'s per-field entry for a HINTED `--field` shows
the SAME composed wire shape the live PUT would send, per kind — `:id` → `{"id": "<VALUE>"}`;
`:name` → `{"name": "<VALUE>"}`; `:option` non-cascading → `{"id": "<optionId>"}`; `:option`
cascading → `{"value":"<parent>","child":{"value":"<child>"}}`; `:asset` →
`[{"workspaceId":..,"id":..,"objectId":..}]` — NOT the bare-form display-value string
BC-3.4.021's general rule uses for unhinted fields. `PUT` is never called (`.expect(0)`). This
per-kind composed-shape rule is a documented EXCEPTION to BC-3.4.021's general "simplified,
non-byte-identical preview" posture (Invariant 1's qualifier).

**Test**: `test_bc_3_4_021_dry_run_id_hint_preview_shape` +
`test_bc_3_4_021_dry_run_name_hint_preview_shape` +
`test_bc_3_4_021_dry_run_option_hint_non_cascading_preview_shape` +
`test_bc_3_4_021_dry_run_option_hint_cascading_preview_shape` +
`test_bc_3_4_021_dry_run_asset_hint_preview_shape` (VP-578-024) in
`tests/issue_field_hint_kinds.rs`.

---

### AC-013: `:asset` cold-cache side effect reachable under `--dry-run`, can exit 64 before preview
(traces to BC-3.4.030 "Dry-run preview shape and side effect" Postconditions, VP-578-024)

Resolving a bare `:asset=<objectId>` form under `--dry-run` still requires
`get_or_fetch_workspace_id`, and this resolution runs UNCONDITIONALLY inside the `--dry-run`
block, exactly as bare-form editmeta resolution does (BC-3.4.021 Postconditions — Common item
3). On a COLD workspace-id cache, `--field cf:asset=<objectId> --dry-run` fires the REAL `GET
/rest/servicedeskapi/assets/workspace` HTTP call and CAN exit 64 from this BC's own cold-cache
error taxonomy (AC-010 above) BEFORE any `plannedChanges` output is emitted. This is NOT a new
error taxonomy — it is the SAME cold-cache taxonomy, now pinned as reachable from `--dry-run`
too.

**Test**: `test_bc_3_4_030_dry_run_asset_cold_cache_exits_64_before_preview` (VP-578-024) in
`tests/issue_field_hint_kinds.rs`.

---

### AC-014: Malformed-hint edge cases — regression pass at the edit call site (EC-6/7/8/9)
(traces to BC-3.4.031, regression only — parser itself is S-578-1's)

`--field cf:option=High:Priority` (colon in VALUE, EC-6) resolves normally at this call site
(not misparsed). `--field "Region: EMEA:bogus=X"` (EC-7) fires the unknown-kind error from
`parse_field_kv` — this call site never reaches its own dispatch logic. `--field cf:id=`/`--field
cf:name=` (EC-8/9) pass through to `{"id": ""}`/`{"name": ""}` on the wire — server 400s,
surfaced verbatim, not a client-side exit-64 at this call site either.

**Test**: `test_ec6_ec7_ec8_ec9_regression_at_edit_call_site` in `tests/issue_field_hint_kinds.rs`.

---

### AC-015: Full existing `tests/issue_edit_field.rs` suite (64 tests) stays green
(traces to S-396 Previous Story Intelligence obligation)

The hinted-bypass branch introduced by this story MUST NOT perturb ANY existing unhinted-input
test in `tests/issue_edit_field.rs`. Full regression run required, not a subset.

**Test**: `cargo test --test issue_edit_field` — all 64 pre-existing test functions PASS
unmodified.

---

### AC-016: `--field` and `--dry-run` combined — Gate A/B still fire; resolution runs inside dry-run block
(traces to BC-3.4.015 Invariant 10, EC-3.4.015-18, unchanged — regression pin at this call site)

`--field NAME=VALUE --dry-run` still evaluates Gate A/Gate B (BC-3.4.017) before any HTTP,
including under `--dry-run`. `resolve_edit_fields` (with hinted dispatch) is called INSIDE the
`--dry-run` block, before the `return Ok(())` short-circuit — this obligation is UNCHANGED by
this story and MUST NOT regress for hinted `--field` pairs.

**Test**: `test_bc_3_4_015_dry_run_hinted_field_resolution_runs_inside_dry_run_block` in
`tests/issue_field_hint_kinds.rs`.

---

### AC-017: `changed_fields`/echo conventions preserved for every hint kind
(traces to BC-3.4.027/028/029/030 Postconditions "changed_fields echo")

`:option` non-cascading → matched label; cascading → `"<parent> > <child>"`. `:id` → raw literal.
`:name` → `VALUE` verbatim. `:asset` → `"<workspaceId>:<objectId>"` composite string (not a
resolved object name — no extra `GET .../object/<oid>` round-trip).

**Test**: `test_changed_fields_echo_per_hint_kind` in `tests/issue_field_hint_kinds.rs`.

---

### AC-018: `field_resolve.rs` file size does not exceed the ADR-0019 §2 ~100 LOC narrow-touch guidance for `edit.rs`
(traces to `architecture-delta-field-dx.md` §2(b) "edit.rs shard determination")

The dense dispatch/type-matching logic this bundle grows lives in `field_resolve.rs` (already
914 LOC, well under the ADR-0012 1,000-LOC threshold), NOT in `edit.rs` itself. `edit.rs`'s own
diff for this story (threading `FieldValueSpec` through the existing `parse_field_kv` call site
at line ~77, plus the dry-run preview assembly amendment) is expected to be a narrow, <~100 LOC
touch to the already-3,187-LOC DOCUMENT-AS-IS file. If the actual diff exceeds ~100 LOC, flag to
the architect before merging rather than deciding unilaterally.

**Test**: manual diff-size check at PR time (not an automated test) — implementer records the
actual `edit.rs` diff line count in the PR description.

---

## Architecture Mapping

| Component | File | Pure/Effectful | Notes |
|-----------|------|-----------------|-------|
| Hinted-bypass dispatch branch | `src/cli/issue/field_resolve.rs` (MODIFIED) | Effectful shell | Reads `spec.kind`, dispatches before bare-form Step 4 |
| Cascading `>` split composer | `src/cli/issue/field_resolve.rs` (MODIFIED) | Pure core (composer logic) | `str::split_once('>')`, D3 MUST |
| `:asset` `WORKSPACE:OBJECTID` composer | `src/cli/issue/field_resolve.rs` (MODIFIED) | Effectful shell (calls `get_or_fetch_workspace_id`) | `str::split_once(':')`, D3-sibling MUST |
| `AllowedValue.children` | `src/types/jira/editmeta.rs` (MODIFIED) | Pure core (data type) | `#[serde(default)] Vec<AllowedValue>` |
| `resolve_edit_fields` call-site threading | `src/cli/issue/edit.rs` (MODIFIED, narrow) | Effectful shell | Thread `FieldValueSpec` instead of `String` at line ~77 |
| Dry-run `plannedChanges` per-hint-kind preview | `src/cli/issue/edit.rs` (MODIFIED, narrow) | Effectful shell (read-only) | BC-3.4.021 amendment |
| `get_or_fetch_workspace_id` (REUSED) | `src/api/assets/workspace.rs` | Effectful shell | Per-profile, 7-day TTL, no new cache family |

**File Structure Requirements** references `architecture/module-decomposition.md` and
`architecture/dependency-graph.md` — the two architecture-context files this story relies on per
DF-021 discipline; do NOT load the full `architecture/` directory.

---

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-3.4.027-1 | `:option` on a resolved field whose `schema.type` ∉ {`option`, `option-with-child`} — ENTRY-POINT gate, runs BEFORE any `allowedValues`/`children` inspection (Invariant 7) | Two sub-cases, both exit 64: (a) `schema.type` is `array`/`any` → REUSES EC-3.4.015-5's exact message (load-bearing: literal type string `"array"`/`"any"`); (b) `schema.type` is `string`/`number`/`date`/`datetime`/`user` (bare-form-supported) → DISTINCT message, load-bearing substrings `"is not an option field"` + resolved type string (e.g. `"schema type 'string'"`) |
| EC-3.4.027-2 | Cascading unresolvable parent | exit 64, lists allowed parent values |
| EC-3.4.027-3 | Cascading resolvable parent, unresolvable child | exit 64, lists that parent's allowed child values |
| EC-3.4.027-4 | Literal `>` inside a non-cascading option label, under `:option` | misparsed as parent/child split; escape hatch is `:id=` |
| EC-3.4.027-5 | Multibyte scalar preceding `>` (e.g. `Pré>Bñ`) | resolves normally, never panics (D3) |
| EC-3.4.027-6 | Empty child (`Parent>`) or empty parent (`>Child`) | exit 64, same shape as EC-3.4.027-2/3 respectively |
| EC-3.4.027-7 | `A>B` against a plain option field, parent resolves, `children` empty | exit 64, `"is not a cascading select"` + `"remove the"` (D4) |
| EC-3.4.028-1 | `:id` non-numeric VALUE | no client-side check; server 400 surfaced verbatim |
| EC-3.4.028-2 | `:id` on a field absent from `allowedValues` (plain string field) | field-presence check still gates; PUT attempted, server 400s if shape rejected |
| EC-3.4.028-3 | `:id=` empty VALUE | passes through as `{"id": ""}`, server-validated, NOT client exit-64 |
| EC-3.4.029-1 | `:name` on a field expecting `{"id":...}` | server 400s, surfaced verbatim |
| EC-3.4.029-3 | `:name=` empty VALUE | passes through as `{"name": ""}`, server-validated, NOT client exit-64 |
| EC-3.4.030-1 | Bare `:asset=12345` | resolves `workspaceId` via cache (warm) or cold-cache GET |
| EC-3.4.030-2 | Explicit `workspaceId` that mismatches the active profile's actual workspace | passed through verbatim — deliberate escape hatch for multi-workspace tenants |
| EC-3.4.030-4 | `:asset` on a field whose `schema.custom` isn't the CMDB type | not client-side schema-gated; server 400s |
| EC-3.4.030-5 | Bare `:asset` on cold cache, no Assets workspace provisioned | exit 64, "No Assets workspace found" |
| EC-3.4.030-6 | Multibyte scalar preceding `:` in `WORKSPACE:OBJECTID` | resolves normally, never panics (D3-sibling) |
| EC-3.4.015-18 | `--field NAME=VALUE --dry-run` | Gate A/B fire; resolution runs inside the dry-run block |
| EC-3.4.015-19 | Resolution failure under `--dry-run` | exit 64, no preview rendered |

---

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/cli/issue/field_resolve.rs::resolve_edit_fields` | effectful-shell (unchanged classification) | Already-classified effectful handler; hint-syntax support is new call patterns within an already-effectful module, not a reclassification |
| Cascading `>`/`:asset` `:` split composer logic | pure-core (composer functions) | The comparison/split itself is pure, same class as the rest of the resolution logic |
| `types::jira::editmeta::AllowedValue` | pure-core (data type) | Serde struct, no I/O |

---

## Token Budget Estimate

| Item | Est. Tokens |
|------|------------|
| Story spec (this file) | ~11 k |
| BC-3.4.015/016/021/027/028/029/030/031 (bc-3-issue-write.md relevant sections) | ~18 k |
| ADR-0019 §2/§3 + Amendments D3/D4 | ~5 k |
| `src/cli/issue/field_resolve.rs` (existing, 914 LOC) | ~10 k |
| `src/cli/issue/edit.rs` (narrow diff context only, ~100 LOC touch) | ~2 k |
| `src/types/jira/editmeta.rs` (existing) | ~1 k |
| `tests/issue_field_hint_kinds.rs` (new) | ~10 k |
| `tests/issue_edit_field.rs` (64 existing tests — regression run, not full read) | ~3 k |
| **Total** | **~60 k** |

Well under 30% of a 200k context window; the largest story in the bundle — if actual
implementation context exceeds this materially, flag to the architect per Task 18's diff-size
check rather than silently absorbing scope creep.

---

## Tasks

**Red Gate protocol**: Write all 18 ACs as tests in `tests/issue_field_hint_kinds.rs` first —
they MUST fail (no hinted-bypass branch exists). Run the full `tests/issue_edit_field.rs` suite
BEFORE starting implementation to capture a baseline; it MUST remain 64/64 green throughout.

### Task 0 — Read source context

Read:
- `src/cli/issue/field_resolve.rs` in full (914 LOC) — the existing `resolve_edit_fields`
  Steps 1–6 this story extends
- `src/cli/issue/edit.rs` — the `--dry-run` block (~lines 431–559) and the `parse_field_kv` call
  site at ~line 77
- `src/types/jira/editmeta.rs::AllowedValue` — current `{id, value, name}` shape to extend
- `.factory/stories/S-396-issue-edit-field-flag.md` — origin story, read the AC-BC-test mapping
  precedent for this exact function
- `.factory/stories/S-578-1-field-value-kind-hint-parser.md` — the `FieldValueSpec`/
  `FieldValueKind` shape this story consumes verbatim
- `src/api/assets/workspace.rs::get_or_fetch_workspace_id` — reused read-only
- BC-3.4.015/016/021/027/028/029/030/031 in full (`bc-3-issue-write.md`) — read the actual BC
  bodies, not summaries; ADR-0019 §2/§3 + Amendments D3/D4 in full

### Task 1 — Write tests/issue_field_hint_kinds.rs (Red Gate)

Write all 18 ACs. Confirm they fail against the current (unhinted) `resolve_edit_fields`.

### Task 2 — Extend `AllowedValue` with `children`

`#[serde(default)] pub children: Vec<AllowedValue>` on `src/types/jira/editmeta.rs::AllowedValue`.

### Task 3 — Implement hinted-bypass dispatch in `resolve_edit_fields`

Read `spec.kind` first; dispatch to `:option`/`:id`/`:name`/`:asset` before falling through to
the bare-form Step 4 match on `kind: None`.

### Task 4 — Implement `:option` cascading composer + non-cascading collision guard (D4)

`str::split_once('>')`; structural `children`-empty check.

### Task 5 — Implement `:id`/`:name` verbatim wrappers

### Task 6 — Implement `:asset` composer + cold-cache error taxonomy

`str::split_once(':')`; `get_or_fetch_workspace_id` at this L2 call site (never inside a JSM
function).

### Task 7 — Thread `FieldValueSpec` through `edit.rs`'s `parse_field_kv` call site

Narrow diff — see AC-018.

### Task 8 — Implement dry-run `plannedChanges` per-hint-kind preview

Per BC-3.4.021's F-NEW-2 amendment; the `:asset` cold-cache side effect must fire inside the
dry-run block.

### Task 9 — Confirm all new tests pass + full regression

```bash
cargo test --test issue_field_hint_kinds -- --nocapture
cargo test --test issue_edit_field -- --nocapture   # 64/64 MUST stay green
cargo clippy -- -D warnings
```

### Task 10 — PR creation

Create PR to `develop`:
- Title: `feat(issue): issue edit --field hint-kind dispatch + cascading select (#578 part 3)`
- Reference #578; include the `edit.rs` diff-line-count note per AC-018; note full
  `tests/issue_edit_field.rs` regression evidence (64/64)

---

## Previous Story Intelligence

**S-578-1** (`.factory/stories/S-578-1-field-value-kind-hint-parser.md`) is the origin of
`FieldValueSpec`/`FieldValueKind` and the `parse_field_kv` extension this story consumes
verbatim. Do NOT redefine or diverge the type — import it as-is.

**S-396** (`.factory/stories/S-396-issue-edit-field-flag.md`) is the origin story for
BC-3.4.015/016's editmeta-driven machinery this story extends. Its `resolve_edit_fields`
canonical signature, cache-first field-list contract, and `fields.json` cache are the
foundation this story's hinted-bypass branch is layered on top of — the hinted-bypass branch
MUST NOT perturb ANY existing unhinted-input test in `tests/issue_edit_field.rs` (64 existing
test functions — full regression run required, per AC-015).

**S-639-1** (`.factory/stories/S-639-1.md`) is the DEC-188 origin story for the platform-create
`--field` guard this bundle's S-578-4 partially reverses. Not directly relevant to this
edit-path story's own scope, but read it for context on the SSOT Platform-Path Guard Ordering
block's discipline before writing S-578-4 (a later story in this bundle).

---

## Architecture Compliance Rules

(Extracted from ADR-0019 §2/§3/Amendments D3/D4, `architecture-delta-field-dx.md` §3/§4)

1. **Bare-form dispatch is UNCHANGED and PERMANENT.** Never modify BC-3.4.015/016's existing
   Steps 1–6 logic — the hinted-bypass branch is purely additive, gated on `spec.kind !=
   None`.
2. **`str::split_once('>')` and `str::split_once(':')` are MANDATORY** at their respective
   split sites — never a char-index-based or fixed-byte-offset scheme. This is an
   implementation-TECHNIQUE obligation, not merely "must not panic" — a proptest alone is
   insufficient per D3's own rationale (a proptest can pass by accident against a corpus that
   happens not to include a multibyte scalar adjacent to the delimiter).
3. **`get_or_fetch_workspace_id` resolution happens at THIS L2 call site, never inside a
   sibling L4 module.** No `api::jsm::requests` → `api::assets::workspace` edge — that
   shortcut is explicitly forbidden per `architecture-delta-field-dx.md` §3/§5.
4. **`AllowedValue.children` is `Vec<AllowedValue>`, NEVER `Option<Vec<AllowedValue>>`** —
   wire-absent and wire-empty-array carry the identical "no cascading children" semantic.
5. **`edit.rs`'s own diff for this story is expected to stay under ~100 LOC** (ADR-0019 §2(b)
   recommendation) — the dense dispatch logic belongs in `field_resolve.rs`. If the actual diff
   materially exceeds this, reopen the shard question with the architect rather than deciding
   unilaterally.
6. **VP-578-022 is asserted independently at THIS call site** (AC-010) — do not treat it as
   "already covered" by S-578-3 or S-578-4's own assertions of the same VP at their own call
   sites.

---

## Library & Framework Requirements

| Library | Version | Constraint |
|---------|---------|------------|
| serde | current (workspace) | `#[serde(default)]` on `AllowedValue.children` |
| proptest | current (workspace, dev-dep) | Cascading `>` split + `:asset` `:` split no-panic proptests |
| wiremock | 0.6 | Cold-cache workspace-discovery taxonomy mocks (FIFO ordering — use `mount_as_scoped` where an earlier-registered mock could otherwise win) |
| (no new crate) | N/A | No new third-party dependency |

---

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `src/cli/issue/field_resolve.rs` | MODIFY | Hinted-bypass dispatch, cascading `>` composer, `:asset` composer, D4 collision guard |
| `src/cli/issue/edit.rs` | MODIFY (narrow, <~100 LOC) | Thread `FieldValueSpec` at the `parse_field_kv` call site (line ~77); dry-run preview assembly amendment |
| `src/types/jira/editmeta.rs` | MODIFY | `AllowedValue.children: Vec<AllowedValue>` (`#[serde(default)]`) |
| `tests/issue_field_hint_kinds.rs` | CREATE | All 18 ACs |

**Files that MUST NOT change:**
- `src/cli/issue/create.rs` — S-578-1's/S-578-4's scope (the `parse_field_kv` definition itself
  is S-578-1's; the platform-create dispatch is S-578-4's)
- `src/cli/issue/jsm_create.rs`, `src/api/jsm/requests.rs` — S-578-3's scope
- `src/cli/field.rs`, `src/api/jira/issues.rs` — S-580-1's scope, no code overlap
- Any `.factory/specs/prd/` BC file
