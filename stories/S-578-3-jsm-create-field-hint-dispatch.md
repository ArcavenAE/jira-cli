---
document_type: story
level: ops
story_id: "S-578-3"
epic_id: "none"
title: "JSM issue create --field hint-kind uniformity — JsmRequestBuilder::build() kind-aware extra_fields serialization"
wave: feature-followup
status: ready
intent: feature
feature_type: backend-cli
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
points: 8
priority: P1
tdd_mode: strict
producer: story-writer
timestamp: "2026-08-26T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-field-dx.md"
  - ".factory/phase-f1-delta-analysis/delta-analysis-field-dx.md"
input-hash: "9725334"
traces_to: "src/api/jsm/requests.rs::JsmRequestBuilder::build"
cycle: field-dx
bundle: field-dx
estimated_effort: medium
estimated_days: 3
target_module: src/api/jsm/requests.rs
subsystems: ["SS-02", "SS-04", "SS-05"]
depends_on: [S-578-1]
blocks: []
behavioral_contracts:
  [BC-3.8.008]
verification_properties:
  [VP-578-015, VP-578-016, VP-578-022]
holdout_anchors: []
nfr_anchors: []
adr_refs: [ADR-0019]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-3-issue-write.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 10
assumption_validations: []
risk_mitigations: []
created: "2026-08-26"
version: "1.3"
last_updated: "2026-08-26"
breaking_change: false
retroactive: false
origin: >
  Feature Mode cycle field-dx, issues #580/#578 — part 4 of field-dx bundle (#580, #578).
  Extends `JsmRequestBuilder::build()` (src/api/jsm/requests.rs) to dispatch on
  `FieldValueSpec.kind` when serializing `extra_fields` into `requestFieldValues`, replacing
  the current unconditional string-wrap. `jsm_create.rs` gains the L2-side workspace-id
  resolution for the `:asset` hint's bare form (build() never calls
  get_or_fetch_workspace_id itself — pure array-wrapping only, mirroring S-578-2's
  L2-resolves/L4-wraps split). This is one of THREE call sites asserting VP-578-022 (:asset
  cold-cache failure taxonomy) — its own independent assertion, not "already covered"
  by S-578-2 or S-578-4. VP-578-016's :id/:name/:asset requestFieldValues wire shapes are
  UNVERIFIED/parity-PENDING per the spec itself (deferred to F4 live-JSM validation) — this
  story implements them by analogy to the platform-path shapes, per BC-3.8.008's own explicit
  caveat, and does NOT overstate them as firmly asserted at this phase.
changelog:
  - "1.0 (2026-08-26): Initial story authored; F2 gate convergence; bundle field-dx (issues #580/#578), wave 2."
  - "1.1 (2026-08-26): AC-003 body text and the EC-3.8.008-1 Edge Cases table row corrected to
    match the PO-approved BC-3.8.008 correction (STRING_WRAP decision): the JSM `:option`
    requestFieldValues wire shape for a cascading-shaped `Parent>Child` literal is bare-parity
    `{\"cf\": \"Parent>Child\"}`, not the object-wrap `{\"cf\": {\"value\": \"Parent>Child\"}}`
    the story previously (incorrectly) documented. No AC added or removed; AC-002/AC-008 were
    already correct and untouched. Propagates the BC-3.8.008 amendment correction, the
    EC-3.8.008-1 correction, and BC-3.4.027's corrected reciprocal-asymmetry note into this
    story only — no code, tests, or BC files changed."
  - "1.2 (2026-08-26): AC-005 corrected per adversary Pass-1 finding ADV-S578-3-P1-003. The prior
    text asserted that malformed-`:asset` VALUE-shape rejection was \"a direct consequence of
    `parse_field_kv` running as a single, request-type-agnostic parse pass\" and that \"no
    separate JSM-specific pre-flight check is needed\" — FALSE: `parse_field_kv`
    (`src/cli/issue/create.rs`) validates only the `:kind` TAG, never the `:asset` VALUE's
    `WORKSPACE:OBJECTID` shape. On the platform path that validation lives at the L2 call site
    (the `:asset` composer in `field_resolve.rs`, S-578-2), not inside the parser. AC-005 now
    states that this story's own JSM-path L2 call site (`jsm_create.rs`/`handle_jsm_create`,
    the same site AC-006 resolves the workspace id at) MUST perform the equivalent
    `WORKSPACE:OBJECTID` value-shape validation BEFORE `get_or_fetch_workspace_id`, and adds
    four required exit-64 cases (empty value / empty workspace segment / extra colon /
    non-numeric objectId, per BC-3.4.030 EC-3.4.030-3 + BC-3.4.031 EC-2a/EC-2b/EC-2d) with
    named tests. `acceptance_criteria_count` unchanged at 10 — this is a prose/scope correction
    to the existing AC-005, not a new standalone AC. BC-3.4.030/031 themselves are unchanged
    (already correct) — no code, tests, or BC files changed by this edit."
  - "1.3 (2026-08-26): Two corrections per adversary Pass-2 findings ADV-S578-3-P2-003 and
    ADV-S578-3-P2-004. (P2-003, scope reconciliation) File Structure Requirements previously
    listed `src/cli/issue/create.rs` under \"Files that MUST NOT change\", but S-578-3
    legitimately edits it: deletion of the now-unused `reject_unsupported_hint_kinds` interim
    guard helper, since S-578-3 is its LAST caller after S-578-2 already removed the edit.rs
    call-site, and the platform `handle_create` never called it (rejects `--field` via the
    DEC-188 preflight instead) — grep-confirmed zero dangling call sites, so removal introduces
    no silent hint-drop. `create.rs` moved from the MUST-NOT-change list to the File Structure
    Requirements table as a narrow, scoped MODIFY entry (delete the helper only; `parse_field_kv`
    and all other `create.rs` logic untouched); the rest of the MUST-NOT-change list
    (`field_resolve.rs`, `edit.rs`, `field.rs`, `api/jira/issues.rs`, `tests/jsm_request_api.rs`,
    BC files) is unchanged. (P2-004, test-name citation drift) AC-005's cited test symbol names
    had drifted from the landed function names: `test_ec_3_8_008_3_asset_empty_value_exits_64_zero_post`
    corrected to the landed `test_ec_3_8_008_asset_empty_value_exits_64_zero_post` (no `_3_`
    infix), and similarly for the empty-workspace-segment, extra-colon, and non-numeric-objectId
    citations; `test_ec_3_8_008_3_unknown_kind_tag_exits_64_zero_post_on_jsm_path` corrected to
    the landed `test_ec_3_8_008_3_malformed_hint_exits_64_zero_post_on_jsm_path`. Verified against
    `tests/issue_create_jsm.rs` on the S-578-3 worktree. No separately-named
    `..._empty_objectid_...` test exists as of this correction (the P2-001 concurrent fix); a
    note was added instead of a hard citation, since `test_ec_3_8_008_asset_non_numeric_objectid_exits_64_zero_post`
    already covers both the bare and explicit non-numeric-objectId forms. `acceptance_criteria_count`
    unchanged at 10 — both are citation/scope corrections, not new or removed ACs. No code,
    tests, or BC files changed by this edit."
---

> **tdd_mode:** strict — Red Gate required. Write all tests in
> `tests/issue_create_jsm.rs` (extending the existing suite, 59 pre-existing test functions)
> first — they MUST fail because `JsmRequestBuilder.extra_fields` is still `&'a
> HashMap<String, String>` with an unconditional string-wrap. Run the FULL existing
> `tests/issue_create_jsm.rs` suite before and after this change — it MUST stay green
> throughout (MEDIUM-HIGH regression risk per the F1 delta analysis §4). Red Gate: new tests
> FAIL → all tests (new + existing 59) PASS.

> **Execute:** `/vsdd-factory:deliver-story S-578-3`

# S-578-3: JSM `issue create --field` Hint-Kind Uniformity

**Bundle**: field-dx (issues #580, #578) — part 4 of 5
**GitHub issue**: #578 (item 1)
**BC anchors**: BC-3.8.008 (amended — "Hint-kind uniformity" section)
**VPs**: VP-578-015 (aligns_with — bare/`:option` parity, already-shipped behavior, relative
claim), VP-578-016 (aligns_with — `:id`/`:name`/`:asset` wire shapes UNVERIFIED/parity-PENDING,
deferred to F4/live-JSM validation), VP-578-022 (JSM call site — 1 of 3 shared call sites for
`:asset` cold-cache failure taxonomy)
**Routing**: standard feature, Wave 2
**Sequencing**: `depends_on: [S-578-1]` — `JsmRequestBuilder.extra_fields` must change from
`&'a HashMap<String, String>` to `&'a HashMap<String, FieldValueSpec>`, which requires
`FieldValueSpec` to exist. No dependency on S-578-2 (edit path) or S-580-1 (field options
command) — this story touches only `src/api/jsm/requests.rs` and
`src/cli/issue/jsm_create.rs`, disjoint files from both.

**Subsystem anchor justification**: `subsystems: ["SS-02", "SS-04", "SS-05"]` — SS-02 (CLI
Layer) owns `jsm_create.rs`'s L2-side workspace-id resolution call site. SS-04 (Jira API
Resources) owns `src/api/jsm/requests.rs::JsmRequestBuilder::build`. SS-05 (Assets/CMDB) is
touched because this story introduces a NEW `cli::issue::jsm_create → api::assets::workspace`
(L4) edge, per `architecture-delta-field-dx.md` §3 ("cli::issue::jsm_create →
api::assets::workspace (L4) [NEW, same reuse — JSM path, BC-3.8.008 amendment]").

**Dependency anchor justification**: `depends_on: [S-578-1]` because `build()`'s
`extra_fields` parameter type change requires `FieldValueSpec`/`FieldValueKind` to already
exist. `blocks: []` — no story in this bundle has a compile dependency on this story's own
files (`src/api/jsm/requests.rs`, `src/cli/issue/jsm_create.rs` are touched by no other story
in the bundle).

---

## Narrative

- **As a** `jr` CLI user creating a JSM service-desk request via `issue create --request-type`
  and setting custom fields via `--field`
- **I want** the SAME `:option`/`:id`/`:name`/`:asset` hint-kind syntax available on the
  platform path (BC-3.4.026-030) to work identically on the JSM path
- **So that** I don't have to remember two different `--field` conventions depending on
  whether I'm creating a platform issue or a JSM request — the hint syntax "applies wherever
  `--field` is accepted" (BC-3.4.026 Postconditions)

---

## Behavioral Contracts

| BC | Summary | Clauses Covered |
|----|---------|-----------------|
| BC-3.8.008 | `--field NAME=VALUE` (repeatable) maps NAME → `requestFieldValues`; `customfield_NNNNN` literal bypasses lookup; only first `=` splits key; empty value allowed; duplicate NAME → last wins — AMENDED with "Hint-kind uniformity" section | Behavior (unchanged bare-form contract), "Hint-kind uniformity" amendment, "D2 collision guard does NOT apply on this (JSM) path" note, EC-3.8.008-1/2/3, Verification Properties VP-578-015/016 |

---

## Acceptance Criteria

### AC-001: `JsmRequestBuilder.extra_fields` type change — `&'a HashMap<String, FieldValueSpec>`
(traces to BC-3.8.008 "Hint-kind uniformity" amendment, wire-target substitution note)

`JsmRequestBuilder.extra_fields: &'a HashMap<String, String>` (`src/api/jsm/requests.rs`)
becomes `&'a HashMap<String, FieldValueSpec>`. The SAME shared `parse_field_kv` parser
(BC-3.4.026, built by S-578-1) produces this map regardless of call site — this resolves the F1
research/BA open question on whether hint syntax is edit-path-only: it is NOT; it applies
wherever `--field` is accepted.

**Test**: `test_bc_3_8_008_extra_fields_type_is_field_value_spec_map` in
`tests/issue_create_jsm.rs`.

---

### AC-002: `build()`'s `extra_fields` loop — kind-aware match replaces unconditional string-wrap
(traces to BC-3.8.008 "Hint-kind uniformity" amendment)

`build()`'s loop replaces its unconditional `rfv.insert(k.clone(),
serde_json::Value::String(v.clone()))` with a match on `spec.kind`:
- `kind: None` / `Some(Option)` → today's string-wrap behavior — `{"cf": "V"}` (bare/`:option`
  parity, VP-578-015)
- `Some(Id)` → `{"cf": {"id": "V"}}`
- `Some(Name)` → `{"cf": {"name": "V"}}`
- `Some(Asset)` → receives an ALREADY-RESOLVED array (or a pre-qualified `WORKSPACE:OBJECTID`
  pair with `workspaceId` never absent) from the L2 caller and performs PURE WRAPPING ONLY —
  `build()` never calls `get_or_fetch_workspace_id` itself; it cannot reach it (per ADR-0019 §2
  and the architecture delta, `build()` is not a new I/O boundary — the L4 Assets cache/API sits
  behind a boundary `build()` [SS-05/L4] is forbidden from crossing; no L4→L4 edge).

The `customfield_NNNNN` bypass, first-`=`-split, empty-value-allowed, and
duplicate-NAME-last-wins behaviors are UNCHANGED for both bare and hinted pairs.

**Test**: `test_bc_3_8_008_build_kind_aware_dispatch_id` +
`test_bc_3_8_008_build_kind_aware_dispatch_name` +
`test_bc_3_8_008_build_kind_aware_dispatch_option_bare_parity` in `tests/issue_create_jsm.rs`.

---

### AC-003: `:option` on JSM — non-cascading only, NOT extended with cascading composition
(traces to BC-3.8.008 "Hint-kind uniformity" amendment cascading exclusion note, EC-3.8.008-1)

`--request-type <RT> --field cf:option=Parent>Child` is treated as an OPAQUE literal string —
there is NO `>`-split site anywhere in the JSM dispatch (BC-3.4.027's cascading-select
composition is explicitly NOT extended to JSM this cycle; `parse_field_kv` itself never
performs the `>` split — that split lives only at the platform-path call sites, per ADR-0019 §
Amendment D3). Consequence: the entire `"Parent>Child"` substring, `>` included, is wrapped
verbatim by the `Some(Option)` non-cascading dispatch arm — which sits in the SAME shared arm as
`kind: None` (AC-002) — producing `{"cf": "Parent>Child"}` (a plain JSON string, bare-parity with
the unhinted form, NOT an object-wrap) on `requestFieldValues`. `jr` does NOT client-side detect
or reject this shape — best case is a server-side 400 or silent no-match. This limitation is
tracked as an open design question, NOT a defect requiring a fix this cycle.

**Test**: `test_ec_3_8_008_1_cascading_greater_than_treated_as_opaque_literal_on_jsm` in
`tests/issue_create_jsm.rs`.

---

### AC-004: `:option` with NO `=` at all is the pre-existing "missing `=`" error, not a hint-parse case
(traces to BC-3.8.008 EC-3.8.008-2)

`--field cf:option` (no `=` at all) — `parse_field_kv`'s step 1 (split on the first `=`) fails
to find any `=`, so the pair never reaches step 2's `:kind` extraction. This resolves to the
SAME pre-existing "missing `=`" exit-64 BC-3.8.008's own Errors line documents (`"invalid field
format: expected NAME=VALUE"`) — NOT a hint-syntax parse error, and NOT BC-3.4.031's catalog.
Applies identically on the platform path.

**Test**: `test_ec_3_8_008_2_missing_equals_is_preexisting_error_not_hint_parse_error` in
`tests/issue_create_jsm.rs`.

---

### AC-005: Malformed-hint catalog (BC-3.4.031) fires on the JSM path BEFORE any POST — `:asset` value-shape validation is an L2 call-site responsibility, NOT an emergent property of `parse_field_kv`
(traces to BC-3.8.008 EC-3.8.008-3, Errors line amendment)

**Correction (this version) — the previous draft of this AC misstated WHERE validation
lives.** `parse_field_kv` (`src/cli/issue/create.rs`) validates ONLY the `:kind` TAG (its
closed set: `option`/`id`/`name`/`asset`) — it never inspects the `:asset` VALUE's
`WORKSPACE:OBJECTID` shape at all. A malformed `:kind` TAG (e.g. `--field cf:bogus=X`) IS
rejected by `parse_field_kv`'s own closed-set check, identically on both paths, before any call
site is reached — that part of the original claim was correct. But malformed-`:asset`
VALUE-SHAPE rejection (empty value, empty workspace segment, extra colon, non-numeric objectId)
is a SEPARATE responsibility that `parse_field_kv` does not and cannot perform (it has no
kind-specific value logic at all). On the platform path this validation lives at the L2 call
site — the `:asset` `WORKSPACE:OBJECTID` composer in `field_resolve.rs` (S-578-2), invoked
before `get_or_fetch_workspace_id`. On the JSM path, this story's own L2 call site —
`jsm_create.rs`/`handle_jsm_create` (the same site AC-006 resolves the workspace id at) — MUST
perform the equivalent `WORKSPACE:OBJECTID` value-shape validation BEFORE calling
`get_or_fetch_workspace_id`, mirroring the platform sibling composer. This is new logic this
story must implement, not an emergent consequence of `parse_field_kv`'s single-pass parsing —
the original AC-005 premise that "no separate JSM-specific pre-flight check is needed" was
FALSE and led to the validation being omitted; it IS needed, at this story's own L2 call site.

Required exit-64 cases (per BC-3.4.030 EC-3.4.030-3 + BC-3.4.031 EC-2a/EC-2b/EC-2d — the
deterministic check order from BC-3.4.030 Parsing rule 2 applies here too, so an input matching
two conditions at once always surfaces the earlier-checked message — applied to the JSM path via
the BC-3.8.008 "shared malformed-hint exit-64 catalog" amendment), each firing with ZERO HTTP
POST and ZERO workspace-discovery GET (validation precedes the L2 `get_or_fetch_workspace_id`
call):
- `--field cf:asset=` (empty value entirely) → exit 64, "asset reference cannot be empty"
  (EC-2a).
- `--field cf:asset=:777` (workspace segment empty, colon present — treated as a malformed
  EXPLICIT-workspace form, not the bare-objectId form) → exit 64, "workspace segment cannot be
  empty when ':' is present; omit the workspace prefix entirely to use the cached workspace id"
  (EC-2c, the sub-case BC-3.4.031's EC-2b/EC-2c enumeration maps this shape to).
- `--field cf:asset=WS:OBJ:X` (extra colon inside the value) → exit 64, a message naming the
  extra-colon mistake specifically (e.g. `"unexpected extra ':' in :asset value — expected
  WORKSPACE:OBJECTID"`), NOT the generic "objectId must be numeric" text (EC-2d).
- `--field cf:asset=abc` (bare form, non-numeric) / `--field cf:asset=WS:abc` (explicit form,
  non-numeric objectId segment) → exit 64, "objectId must be numeric" — ASCII `[0-9]+` only per
  BC-3.4.030 Parsing rule 3; non-ASCII digit scripts also reject (EC-3).

**Test**: `test_ec_3_8_008_3_malformed_hint_exits_64_zero_post_on_jsm_path` (unchanged
parser-level behavior — kind-tag validation only) + `test_ec_3_8_008_asset_empty_value_exits_64_zero_post`
+ `test_ec_3_8_008_asset_empty_workspace_segment_exits_64_zero_post` +
`test_ec_3_8_008_asset_extra_colon_exits_64_zero_post` +
`test_ec_3_8_008_asset_non_numeric_objectid_exits_64_zero_post` in
`tests/issue_create_jsm.rs` (the last of these covers both the bare non-numeric-objectId form
and the explicit `WS:abc` form in one test function; no separately-named
`..._empty_objectid_...` test exists as of this correction — the empty-value and
empty-workspace-segment cases above are the closest landed analogues, and no gap is asserted
here beyond what those two already cover).

---

### AC-006: `:asset` bare-form workspace-id resolution — L2-side, in `jsm_create.rs`
(traces to BC-3.8.008 "Hint-kind uniformity" amendment `Some(Asset)` arm description)

`jsm_create.rs` (`handle_jsm_create`) resolves `:asset` workspace id via
`get_or_fetch_workspace_id` BEFORE calling `build()`, mirroring `edit.rs`/`create.rs` on the
platform path (S-578-2's BC-3.4.030 site). Where `:asset`'s value carries an EXPLICIT
`WORKSPACE:OBJECTID` form (a `:` present), the L2 handler composes the array directly from the
two supplied segments — no cache lookup needed, `build()`'s wrapping is the only step involved.
Where the BARE `<objectId>` form is used (no `:`), the L2 handler calls
`get_or_fetch_workspace_id` FIRST to obtain `workspaceId` before the array can be composed —
`build()` never sees a bare `:asset` value, only the L2-resolved, fully-composed result.
`get_or_fetch_workspace_id` is called AT MOST ONCE per invocation on this path (mirrors the
platform-path invariant).

**Test**: `test_bc_3_8_008_asset_explicit_workspace_l2_composes_no_cache_lookup` +
`test_bc_3_8_008_asset_bare_form_l2_resolves_workspace_before_build` in
`tests/issue_create_jsm.rs`.

---

### AC-007: `:asset` cold-cache workspace-discovery failure taxonomy — JSM-path call site
(traces to BC-3.4.030 Error taxonomy table, VP-578-022 — 1 of 3 shared call sites)

Four rows, exercised at THIS (`jsm_create.rs`) call site independently of S-578-2's edit-path
assertion and S-578-4's create-path assertion:

| Condition | Behavior |
|---|---|
| 403 or 404 | `JrError::UserError`: "Assets is not available on this Jira site..." → exit 64 |
| 200 + zero workspace entries | `JrError::UserError`: "No Assets workspace found on this Jira site..." → exit 64 |
| 401 | Standard `JrError::NotAuthenticated`/`InsufficientScope` mapping |
| 5xx / network error | Standard `JrError::ApiError`/`NetworkError` mapping |

**Test**: `test_bc_3_4_030_jsm_path_asset_cold_cache_403_404_assets_unavailable` +
`test_bc_3_4_030_jsm_path_asset_cold_cache_empty_workspace` +
`test_bc_3_4_030_jsm_path_asset_cold_cache_401_standard_auth_mapping` +
`test_bc_3_4_030_jsm_path_asset_cold_cache_5xx_network_standard_mapping` (VP-578-022) in
`tests/issue_create_jsm.rs`.

---

### AC-008: Bare-form byte-identity regression pin — VP-578-015
(traces to BC-3.8.008 Verification Properties, VP-578-015)

A bare (unhinted) `--field NAME=VALUE` on the JSM create path produces BYTE-IDENTICAL
`requestFieldValues` wire output before and after this amendment — the kind-aware dispatch is
purely additive for `kind: None`. Regression pin against `tests/issue_create_jsm.rs`'s existing
`--field` wire-shape assertions (BC-3.8.005..007's `summary`/`description`/`priority`/`labels`
keys, which sit in the SAME `rfv` map, are UNTOUCHED by this amendment).

**Test**: `test_vp_578_015_bare_field_byte_identical_pre_post_amendment` in
`tests/issue_create_jsm.rs`.

---

### AC-009: `:id`/`:name`/`:asset` JSM wire shapes — implemented by analogy, explicitly flagged UNVERIFIED (VP-578-016)
(traces to BC-3.8.008 Verification Properties, VP-578-016, downgraded status)

`:id`/`:name`/`:asset` hints on the JSM path produce PARALLEL wire shapes to their platform-path
counterparts (BC-3.4.028/029/030), targeting `requestFieldValues` instead of `fields` — this
parity is NOT research-confirmed for any of the three kinds. Research CONFIRMed ONLY the
platform-path `fields` wire contract for these kinds; it never verified the `requestFieldValues`
shape specifically for ANY of the four kinds, `:option` included. `:asset` in particular is at
least as likely to diverge as `:option` — Assets attribute payloads are the least standardized
of the four across Atlassian's JSM vs platform surfaces. This story's tests assert the
IMPLEMENTED shape (by analogy) with wiremock, and MUST document in the test module doc comment
that VP-578-016 is parity-PENDING until F4/live-JSM validation runs — do NOT read the wiremock
green as a settled guarantee.

**Test**: `test_vp_578_016_id_name_asset_jsm_wire_shapes_by_analogy_flagged_unverified` (wiremock
assertion against the IMPLEMENTED shape, with an explicit doc-comment caveat) in
`tests/issue_create_jsm.rs`.

---

### AC-010: Full existing `tests/issue_create_jsm.rs` suite (59 tests) + `tests/jsm_request_api.rs` wire-shape assertions stay green
(traces to F1 delta analysis §4 regression-risk classification)

This change touches `JsmRequestBuilder::build`'s `extra_fields` loop — a MEDIUM-HIGH regression
risk per the F1 delta analysis, since `tests/jsm_request_api.rs`'s wire-shape assertions are the
backstop for the untouched `rfv` keys (`summary`/`description`/`priority`/`labels`). Full
regression run required, not a subset.

**Test**: `cargo test --test issue_create_jsm` (59 pre-existing + new) and
`cargo test --test jsm_request_api` — ALL PASS unmodified for the untouched keys.

---

## Architecture Mapping

| Component | File | Pure/Effectful | Notes |
|-----------|------|-----------------|-------|
| `JsmRequestBuilder.extra_fields` type | `src/api/jsm/requests.rs` (MODIFIED) | Pure core (data-carrying field) | `&'a HashMap<String, FieldValueSpec>` |
| `JsmRequestBuilder::build`'s `extra_fields` loop | `src/api/jsm/requests.rs` (MODIFIED) | Effectful shell (unchanged classification) | Kind-aware match replaces unconditional string-wrap; `Some(Asset)` arm is PURE wrapping only |
| `:asset` L2 workspace-id resolution | `src/cli/issue/jsm_create.rs` (MODIFIED, line ~282) | Effectful shell | Calls `get_or_fetch_workspace_id` BEFORE `build()`, never inside it |

---

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-3.8.008-1 | Cascading `>` on JSM `:option` path | Opaque literal, `{"cf": "Parent>Child"}` (bare-parity string-wrap), best-case server 400 |
| EC-3.8.008-2 | `--field cf:option` (no `=`) | Pre-existing "missing `=`" error, NOT a hint-parse case |
| EC-3.8.008-3 | Malformed hint (BC-3.4.031 catalog) on JSM path | exit 64 zero HTTP POST, identical to platform-path shape |
| (BC-3.4.030 taxonomy) | `:asset` cold-cache 403/404/empty-workspace/401/5xx | Same 4-row taxonomy as platform path, asserted independently here |

---

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/api/jsm/requests.rs::JsmRequestBuilder::build` | effectful-shell (unchanged classification) | Already a JSON-assembly function called from an effectful path; kind-aware dispatch is additive logic within the same function, not a new I/O boundary |
| `src/cli/issue/jsm_create.rs::handle_jsm_create` (modified) | effectful-shell (unchanged classification) | Already-classified effectful handler; `:asset` workspace-id resolution is a new call pattern within an already-effectful module |

---

## Token Budget Estimate

| Item | Est. Tokens |
|------|------------|
| Story spec (this file) | ~9 k |
| BC-3.8.008 (bc-3-issue-write.md, full amendment section) | ~7 k |
| ADR-0019 §2 "L2 resolves, build() only wraps" split | ~2 k |
| `src/api/jsm/requests.rs` (existing `JsmRequestBuilder::build`) | ~2 k |
| `src/cli/issue/jsm_create.rs` (existing, line ~282 context) | ~2 k |
| `tests/issue_create_jsm.rs` (59 existing tests — regression baseline, not full read) | ~4 k |
| New tests | ~6 k |
| **Total** | **~32 k** |

Well under 20% of a 200k context window.

---

## Tasks

**Red Gate protocol**: Write all 10 ACs as tests in `tests/issue_create_jsm.rs` first — they
MUST fail (the type is still `HashMap<String, String>` with unconditional string-wrap). Run the
full existing 59-test suite BEFORE starting to capture a baseline.

### Task 0 — Read source context

Read:
- `src/api/jsm/requests.rs::JsmRequestBuilder` in full — current `extra_fields` field and
  `build()`'s loop
- `src/cli/issue/jsm_create.rs::handle_jsm_create` (~line 282 area) — the `--field` call site
- `.factory/stories/S-578-1-field-value-kind-hint-parser.md` — the `FieldValueSpec` shape this
  story consumes verbatim
- `.factory/stories/S-578-2-edit-field-hint-dispatch.md` — the L2-resolves/L4-wraps split
  precedent for `:asset` (mirror it, don't reinvent it)
- BC-3.8.008 in full (`bc-3-issue-write.md`) — read the actual BC body, not a summary
- `tests/issue_create_jsm.rs` and `tests/jsm_request_api.rs` — existing wire-shape assertions
  that must not regress

### Task 1 — Write tests/issue_create_jsm.rs additions (Red Gate)

Write all 10 ACs. Confirm they fail against the current unconditional string-wrap.

### Task 2 — Change `JsmRequestBuilder.extra_fields` type

`&'a HashMap<String, String>` → `&'a HashMap<String, FieldValueSpec>`.

### Task 3 — Implement kind-aware `build()` dispatch

`None`/`Some(Option)` → string-wrap (unchanged); `Some(Id)` → `{"id":...}`; `Some(Name)` →
`{"name":...}`; `Some(Asset)` → pure wrap of an already-resolved value.

### Task 4 — Implement `:asset` L2 resolution in `jsm_create.rs`

Explicit `WORKSPACE:OBJECTID` → compose directly, no cache lookup. Bare `<objectId>` →
`get_or_fetch_workspace_id` first.

### Task 5 — Confirm all tests pass + full regression

```bash
cargo test --test issue_create_jsm -- --nocapture   # 59+new MUST stay green
cargo test --test jsm_request_api -- --nocapture     # untouched keys MUST stay green
cargo clippy -- -D warnings
```

### Task 6 — PR creation

Create PR to `develop`:
- Title: `feat(issue): JSM issue create --field hint-kind uniformity (#578 part 4)`
- Reference #578; note VP-578-016's parity-pending status explicitly in the PR description —
  do not claim live-JSM verification this cycle; include full regression evidence (59/59 +
  `jsm_request_api.rs`)

---

## Previous Story Intelligence

**S-578-1** (`.factory/stories/S-578-1-field-value-kind-hint-parser.md`) is the origin of
`FieldValueSpec`/`FieldValueKind` this story consumes verbatim.

**S-578-2** (`.factory/stories/S-578-2-edit-field-hint-dispatch.md`) is the FIRST story in this
bundle to implement the "L2 resolves, L4/`build()` only wraps" split for `:asset` — mirror its
exact pattern for `jsm_create.rs`'s own workspace-id resolution call site (do not
independently re-derive the split; this story's `Some(Asset)` arm must be as pure as S-578-2's
composer, receiving an already-resolved value).

**N/A — first story to touch `src/api/jsm/requests.rs` in this bundle.** The MEDIUM-HIGH
regression risk classification is from `.factory/phase-f1-delta-analysis/delta-analysis-field-dx.md`
§4 (`tests/issue_create_jsm.rs`, 59 existing tests, full regression required); `tests/jsm_request_api.rs`
wire-shape assertions are the backstop for untouched `rfv` keys — read both files before
touching `build()`'s loop.

---

## Architecture Compliance Rules

(Extracted from ADR-0019 §2, `architecture-delta-field-dx.md` §3/§4/§5)

1. **`build()`'s `Some(Asset)` arm MUST perform PURE array-wrapping ONLY.** It MUST NEVER call
   `get_or_fetch_workspace_id` or otherwise reach into `api::assets::*` — the L4 Assets
   cache/API sits behind a boundary `build()` (SS-05/L4) is forbidden from crossing (no L4→L4
   edge, per the Layer Isolation Summary: L4 imports from L3 client/L5 types/L6 cache/error
   only, never a sibling L4).
2. **Workspace-id resolution is owned EXCLUSIVELY by `jsm_create.rs` (L2)** — the SAME
   `get_or_fetch_workspace_id` reuse pattern S-578-2 established for the edit path, mirrored
   here, not reinvented.
3. **Cascading `:option` composition is explicitly NOT extended to JSM this cycle.** Do not
   add a `>`-split anywhere in `src/api/jsm/`. `parse_field_kv` itself never performs this
   split regardless of call site — confirm this remains true after your change.
4. **VP-578-016 is parity-PENDING, not firmly asserted.** Test module doc comments and PR
   description language MUST reflect this — do not claim live-JSM verification.
5. **VP-578-022 is asserted independently at THIS call site** (AC-007) — do not treat it as
   "already covered" by S-578-2 or S-578-4's own assertions of the same VP at their own call
   sites.

---

## Library & Framework Requirements

| Library | Version | Constraint |
|---------|---------|------------|
| wiremock | 0.6 | FIFO ordering for cold-cache workspace-discovery mocks; use `mount_as_scoped` where an earlier-registered mock could otherwise win, per `BC-3.9.006`'s existing convention |
| (no new crate) | N/A | No new third-party dependency |

---

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `src/api/jsm/requests.rs` | MODIFY | `JsmRequestBuilder.extra_fields` type change + kind-aware `build()` dispatch |
| `src/cli/issue/jsm_create.rs` | MODIFY | `:asset` workspace-id resolution at the `--field` call site (line ~282) |
| `tests/issue_create_jsm.rs` | MODIFY | All 10 new ACs; existing 59 tests untouched (regression baseline) |
| `src/cli/issue/create.rs` | MODIFY (narrow) | Delete the now-unused `reject_unsupported_hint_kinds` helper — S-578-3 is its LAST caller (S-578-2 already removed its own call-site). The platform `handle_create` never called it and rejects `--field` via the DEC-188 preflight, so removal introduces no silent hint-drop. Do NOT change `parse_field_kv` or any other `create.rs` logic. |

**Files that MUST NOT change:**
- `src/cli/issue/edit.rs`, `src/cli/issue/field_resolve.rs` — S-578-2's scope
- `src/cli/field.rs`, `src/api/jira/issues.rs` — S-580-1's scope, no code overlap
- `tests/jsm_request_api.rs` — the untouched-keys backstop; assert against it, do not modify it
  unless a genuine regression is found (in which case flag it explicitly in the PR)
- Any `.factory/specs/prd/` BC file
