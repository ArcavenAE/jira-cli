# Red Gate Log — S-cycle12-jsm-adf-autoconvert

**Cycle:** cycle-012 (Wave 2)
**Story:** S-cycle12-jsm-adf-autoconvert
**Branch:** feat/cycle12-jsm-adf-autoconvert

## Stub Step (Red Gate a)

- **Stub Architect commit:** `d78c5af2` on `feat/cycle12-jsm-adf-autoconvert`.
- **DQ-6 decision:** Option (b) — parallel `resolved_adf_values: BTreeMap<String, serde_json::Value>` map + `is_adf_request: bool` added to `JsmRequestBuilder`; new `JsmAdfFieldResolution` struct; `FieldValueSpec.value` stays `String` (Option a rejected to avoid rippling into verify-only `field_resolve.rs`). Rationale documented at `JsmAdfFieldResolution` rustdoc in `src/cli/issue/jsm_create.rs`.
- **New signatures:**
  - `JsmAdfFieldResolution` struct.
  - `resolve_jsm_adf_extra_fields(client, profile, service_desk_id, request_type_id, extra_fields) -> JsmAdfFieldResolution` (async, `todo!()`).
  - `jsm_adf_empty_omit_guard_applies(kind: Option<FieldValueKind>) -> bool` (real body: `kind.is_none()`).
  - `JsmRequestBuilder` fields: `resolved_adf_values`, `is_adf_request`.
- **cargo check:** PASS (verified by orchestrator; only dead-code/unused warnings).

## Failing-Tests Step (Red Gate b)

- **Test Writer commit:** `4fc34265` on `feat/cycle12-jsm-adf-autoconvert`.
- **Tests authored:** 16 story-named tests across AC-002/004/006/007/008/009/012/013/015/016 + Axis f, plus AC-010 ABSENT-check strictness fixes at BOTH locations (`src/api/jsm/requests.rs` proptest + `tests/issue_create_jsm.rs::test_jsm_create_plain_description_absent_when_no_description_flag`) in the same commit.
- **AC-011 triage:** all 52 bare-form `--field` occurrences audited across ~48 test fns; NONE required a wiremock stub or assertion change — all target non-ADF field_ids and self-heal under fail-open. No follow-up needed.
- **RED verification (independently verified by orchestrator at HEAD `4fc34265`):**
  - `cargo test --no-run` compiles clean (0 errors).
  - `cargo test --lib jsm`: 25 passed, 6 FAILED (RED). Resolution-layer tests panic via `not yet implemented` at `jsm_create.rs:659`; AC-006 assembly-order test fails via genuine assertion (`self.description` "text X" must supersede extra-field "Y"; got "Y").
  - `cargo test --test issue_create_jsm`: 99 passed, 14 FAILED (RED) — 6 new AC tests + 8 pre-existing bare-form fixtures, all via the same `todo!()` panic (expected; self-heal to fail-open after implementation).
  - GREEN-by-design (acceptable per story): AC-002 pure predicate test, AC-009 pure gate test, AC-013 I-2 regression pin.
- **RED GATE:** VERIFIED — all new behavior tests fail for the right reason (unimplemented behavior / genuine bug-assertion), not compile errors.
