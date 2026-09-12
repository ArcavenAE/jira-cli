---
document_type: delta-analysis-report
feature_name: "ADF auto-conversion for --field on ADF-backed fields (edit + create)"
created: 2026-09-12
spec_version_at_analysis: "2.3.0"
status: SUPERSEDED
superseded_by: "e2e-edit-field-adf-heuristic-delta-analysis-v3.md"
superseded_reason: "Adversarial review found C1 (empty value 400), H1 (single-fix-site claim false), H2 (create-path detection unverified), M1-M5 issues. v3 addresses all findings."
intent: "feature"
feature_type: "backend"
scope: "standard"
severity: "N/A"
cycle_proposed: "cycle-012-field-adf-autoconvert (PROPOSED — state-manager must formalize number)"
supersedes: "e2e-edit-field-adf-heuristic-delta-analysis.md (test-infra-only scope; superseded by Route B human decision 2026-09-12)"
standing_item_ref: "E2E-EDIT-FIELD-ADF-HEURISTIC"
---

# Delta Analysis Report: ADF Auto-Conversion for `--field` on ADF-Backed Fields

> **SUPERSEDES** `e2e-edit-field-adf-heuristic-delta-analysis.md` (test-infra-only Route A scope).
> The human selected Route B (2026-09-12): fix the product, not just the test.
> The test-only artifact is retained for record with `status: SUPERSEDED`.

## Feature Request

- **Brief:** `jr issue edit --field NAME=VALUE` and `jr issue create --field NAME=VALUE`
  currently send the value as a plain JSON string for all `schema.type == "string"` fields.
  Jira Cloud REST v3 requires an ADF object on write for certain fields — specifically
  `environment` (system field), `description` (system field, though collision-guarded upstream),
  and custom fields with `schema.custom == "com.atlassian.jira.plugin.system.customfieldtypes:textarea"`.
  Today the CLI returns `API error (400): … Operation value must be an Atlassian Document`.
  The fix: detect ADF-backed fields from editmeta/createmeta schema metadata and auto-convert
  the user's plain-string value to ADF before writing.
- **Requested by:** Human, Route B decision, 2026-09-12.
- **Research basis:** `.factory/research/e2e-environment-adf-field-2026-09-11.md` (complete;
  all four research questions answered with HIGH confidence).
- **Pre-existing failure evidence:** `test_e2e_issue_edit_custom_field` panics
  `API error (400): environment: Operation value must be an Atlassian Document`
  on `develop` tip `30bb1a18` — confirmed on E2E runs 34588420715 and 34534019457.

## Classifications

### Intent Classification

**Classified intent:** `feature`

**Rationale:** The request adds new product behavior — auto-converting `--field` values to ADF
for ADF-backed fields. This is not fixing broken behavior within the spec (the spec
previously said `schema.type == "string"` → plain-string, which is correct for most fields);
it is extending the spec to handle a new class of fields. Detection signals: "must AUTO-CONVERT",
"actually works instead of returning API error". The bug manifests as a 400 but the root cause
is a missing capability, not an implementation regression.

### Feature Type Classification

**Classified type:** `backend`

**Rationale:** Change is in `src/cli/issue/field_resolve.rs::dispatch_field_value` (shared
Rust backend logic) and supporting types. No new CLI flags, no UX surface change, no config
change. The behavior change is in the API-write path. Test change in `tests/e2e_live.rs`.

### Trivial Scope Classification

- [x] Impact boundary: NOT single file — touches `field_resolve.rs` (core logic), possibly `editmeta.rs` type (already has `custom`/`system` fields, likely no change needed), and `e2e_live.rs` (test update)
- [ ] No new BCs needed — **FALSE**: new behavior requires at least 3–5 new BCs (edit path, create path, error paths)
- [ ] No architecture change — **FALSE**: adds a new dispatch branch to `dispatch_field_value`; `editmeta.rs` `custom`/`system` fields promoted from "parsed but not used" to load-bearing
- [x] No new external dependencies — true; existing `adf.rs` machinery reused
- [ ] Regression risk LOW — **FALSE**: `field_resolve.rs` backs BOTH edit AND create `--field` on the platform path; MEDIUM regression risk

**Classified scope:** `standard`

**Route:** Full Feature Mode F1 through F7. No quick-dev compression.

### Severity Classification

**Classified severity:** `N/A` (feature intent, not bug-fix)

## Research Synthesis (Key Findings from `.factory/research/e2e-environment-adf-field-2026-09-11.md`)

| Question | Finding | Confidence |
|----------|---------|------------|
| Q1: Are `environment`/`description` ADF on v3 despite `schema.type == "string"`? | YES — universal on REST v3; v2 accepted plain strings; v3 requires ADF | HIGH |
| Q2: Does editmeta/createmeta expose a machine-readable ADF discriminator? | NO generic signal; no `richText`/`adf` flag; JRACLOUD-75814 Won't Fix | HIGH |
| Q3: How to reliably pick ADF-backed fields? | `schema.custom == "...:textarea"` → ADF; `schema.system == "environment"` → ADF; `...:textfield` → plain string | HIGH |
| Q4: Is `--field plain-string` correct for `schema.type == "string"` in general? | Yes, for the general case; ADF requirement on `environment`/`textarea` is undocumented metadata | HIGH |

### Reliable ADF Detection Set (for `dispatch_field_value`)

| Condition | ADF? | Source |
|-----------|------|--------|
| `meta_field.schema.system == Some("environment")` | YES | Official v3 docs; JRACLOUD-75814 |
| `meta_field.schema.custom == Some("com.atlassian.jira.plugin.system.customfieldtypes:textarea")` | YES | Official v3 docs (textarea custom type) |
| `meta_field.schema.system == Some("description")` | YES (but collision-guarded upstream on both edit and create) | Official v3 docs |
| `meta_field.schema.custom == Some("com.atlassian.jira.plugin.system.customfieldtypes:textfield")` | NO — plain string | Official v3 docs |
| `meta_field.schema.field_type == "string"` (no other signal) | UNKNOWN — default to plain string (current behavior, safe for most fields) | Research Q2 |

Note: third-party/Connect/Forge app fields that may require ADF are NOT generically inferable;
they fall through to the existing `Value::String` path unchanged (safe: unknown fields stay
as-is, same as today). This is explicit by design.

## Design Questions (F1 Frames; Final Decisions in F2)

### DQ-1: Conversion function — `text_to_adf` vs `markdown_to_adf`?

`edit.rs` already handles `--description` with `markdown_to_adf`/`text_to_adf` selection
gated on the `--markdown` flag. The question: does `--markdown` also apply to ADF-backed
`--field` values?

**Option A (recommended for F2):** `--field` ADF values always use `text_to_adf` (plain text
→ ADF). `--markdown` remains a modifier on `--description`/`--description-stdin` only.
Rationale: simplest change; backward-compatible; users who need markdown in `environment`
can use the `:option` hint system's future extension or file a feature request. Consistent
with the thin-client design idiom.

**Option B:** Thread `--markdown` flag into `dispatch_field_value` so
`--field environment="## Heading" --markdown` converts as markdown. Requires adding a
`markdown: bool` parameter to `dispatch_field_value` (today it takes no flag-state).
More powerful but higher risk — changes `dispatch_field_value`'s signature, affecting
all callers.

**Flag for F2 decision:** which option? Recommendation: Option A (plain text only) for
this cycle; Option B is a follow-on enhancement.

### DQ-2: JSM create path (`jsm_create.rs`) — in scope or not?

`jsm_create.rs::handle_jsm_create` builds the JSM request payload directly (mirroring
`field_resolve.rs`'s L2-resolves/L4-wraps split by comment, but NOT going through
`dispatch_field_value`). JSM service desks also run on Jira Cloud v3 and have the same
ADF requirement on textarea/environment fields.

**Flag for F2 decision:** Is the JSM `--field` path in scope for ADF auto-conversion in
this cycle, or deferred to a follow-on? Recommendation: DEFER for this cycle (scope
control); note the gap and record it as a follow-on standing item.

### DQ-3: Error path for ADF conversion failure

`text_to_adf` is infallible (returns `Value`). `markdown_to_adf_*` can fail only on
MAX_ADF_DEPTH (BC-7.2.012, exit 64). If Option A (plain text) is chosen, the conversion
is always infallible. If Option B (markdown) is chosen, the existing MAX_ADF_DEPTH error
propagates naturally via `?`. Flag for F2: confirm error semantics.

### DQ-4: `discover_safe_edit_field` in `tests/e2e_live.rs` — change needed?

**With the product fix:** `discover_safe_edit_field` can continue returning `Environment` as
the preferred field. The CLI will now auto-convert the plain string to ADF → Jira accepts it
→ the test passes for the right reason. **The test-infra-only heuristic fix is MOOT.**

However, the fresh-GET verification in `test_e2e_issue_edit_custom_field` (lines 5320+)
currently compares the written value as a plain string. For ADF fields, the read-back
`GET /rest/api/3/issue/{key}` returns the ADF object, not the plain string. The assertion
must be updated to accept an ADF-valued read-back (e.g., check the field is non-null/non-empty,
or verify the ADF object's text content via `adf_to_text` comparison, or simply assert no
400 error + `updated == true`).

**Flag for F2/story:** update `test_e2e_issue_edit_custom_field`'s fresh-GET assertion to
handle ADF-valued reads. `discover_safe_edit_field`'s field-selection heuristic itself needs
NO change — the product fix makes it correct as-is.

## Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements | 0 new specs sections; ~4–6 new BCs | New BCs in BC-3.4.* (edit `--field` ADF) and BC-3.3.* (create `--field` ADF); spec MINOR version bump 2.3.0 → 2.4.0 |
| Architecture | 1 component modified | `dispatch_field_value` in `field_resolve.rs`: adds ADF detection + conversion branch within the `"string"/"text"` arm of the `field_type` match. `EditMetaFieldSchema.custom`/`.system` promoted from "parsed but not used in v1" to load-bearing. |
| UX Screens | 0 | `jr` is CLI-only; no new flags, no new UI surface |
| Stories | 1–2 stories estimated | Story 1: product ADF auto-conversion logic + unit tests. Story 2: E2E test update (may fold into Story 1). |
| Existing Tests | Tests in `field_resolve.rs` (unit), `tests/e2e_live.rs` (E2E nightly) | `dispatch_field_value` unit tests (all `"string"` arm tests in `field_resolve.rs`); `test_e2e_issue_edit_custom_field` needs fresh-GET assertion update |
| Verification Properties | 1–2 new VPs | VP for `dispatch_field_value` ADF-field predicate correctness (property: `schema.custom == "...:textarea"` → wire value is ADF doc node, never plain string) |

## Files Changed

### New Files

None.

### Modified Files

| File Path | Change Type | Risk | Symbols Affected |
|-----------|------------|------|-----------------|
| `src/cli/issue/field_resolve.rs` | Internal logic extension | MEDIUM | `dispatch_field_value` — add ADF detection + `text_to_adf` conversion in the `"string"/"text"` arm; add `ADF_SYSTEM_FIELDS` or `ADF_CUSTOM_TYPES` constant(s); `EditMetaFieldSchema.custom`/`.system` now consumed |
| `tests/e2e_live.rs` | Test assertion update | LOW | `test_e2e_issue_edit_custom_field` — update fresh-GET assertion to accept ADF-valued read-back; `discover_safe_edit_field` field-selection heuristic needs NO change |

### Dependent Files (unchanged but depend on modified code)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `src/cli/issue/edit.rs` | `field_resolve.rs::resolve_edit_fields` → `dispatch_field_value` | MEDIUM — must continue to pass all existing `--field` tests; especially the `"string"` arm for `...:textfield` fields (must NOT be ADF-converted) |
| `src/cli/issue/create.rs` | `field_resolve.rs::resolve_against_createmeta` → `dispatch_field_value` | MEDIUM — same; create path shares `dispatch_field_value` via AC-008 |
| `src/types/jira/editmeta.rs` | `EditMetaFieldSchema.custom`/`.system` now load-bearing | LOW — type already deserializes these fields; no struct change expected; rustdoc update to remove "not used in v1 resolution" language |

### Files Explicitly NOT Changed

- `src/cli/issue/jsm_create.rs` — JSM create path is OUT OF SCOPE for this cycle (DQ-2 above)
- `src/cli/issue/edit.rs` — call site is unchanged; `dispatch_field_value` is the fix site
- `src/cli/issue/create.rs` — call site is unchanged
- `src/adf.rs` — no new exports needed; `text_to_adf` is already `pub`
- All `src/api/` files — no API-layer change
- All `src/types/` files except potentially `editmeta.rs` rustdoc — no struct changes
- `.factory/specs/architecture/` — no architecture section changes
- `.github/workflows/` — no CI changes

## Files NOT Changed (Regression Baseline)

All existing behavior for non-ADF `"string"` fields (`...:textfield`, `summary`, etc.) must
continue to produce `Value::String(value)` wire values. This is the primary regression risk:
the new ADF detection predicate must be strictly additive (only convert fields explicitly
identified as ADF-backed; fall through to existing behavior for everything else).

Key regression baseline:
- All `dispatch_field_value` tests for `"string"` arm (unit tests in `field_resolve.rs`)
- All `issue edit --field` integration tests (plain text fields: pass-through unchanged)
- All `issue create --field` tests (same)
- BC-3.4.015 through BC-3.4.032 (all existing edit `--field` BCs — none may regress)
- BC-3.3.010 through BC-3.3.012 (all existing create `--field` BCs)
- E2E: all 106 currently-passing tests

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | MEDIUM | `dispatch_field_value` is the shared dispatch core for BOTH `issue edit --field` AND `issue create --field` on the platform path. Adding a detection branch inside the `"string"/"text"` arm has the potential to mis-classify a plain-string field as ADF-backed if the detection predicate is too broad. The predicate must be exact: ONLY `schema.custom == "...:textarea"` or `schema.system IN {"environment", "description"}` trigger ADF conversion. All other `"string"` fields must fall through unchanged. Full regression suite (unit + integration + E2E) required before merge. |
| Architecture | LOW | The change is within `dispatch_field_value`'s `"string"/"text"` arm — an additive branch, not a structural refactor. AC-008 (shared dispatch) is preserved: no second implementation of ADF detection is created. `EditMetaFieldSchema` already has `.custom` and `.system` fields; promoting them from "parsed but not used" to load-bearing is a semantic change but no struct change. |
| Security | NONE | No new network calls, no new credentials, no new deserialization surfaces. `text_to_adf` is already used in production (edit `--description`). |
| Performance | NONE | ADF detection is a field lookup in an already-deserialized struct (`meta_field.schema.custom`/`.system`). `text_to_adf` is O(N) in text length, same as the existing `--description` path. No additional HTTP calls. |

## Regression Baseline

- **Total BC count:** 757 (unchanged until F2 adds new BCs)
- **Total E2E tests:** 107 (`tests/e2e_live.rs`); 106/107 currently pass
- **Tests in regression risk zone:**
  - `field_resolve.rs` unit tests (all `dispatch_field_value` tests, especially `"string"` arm)
  - `tests/` integration tests exercising `issue edit --field` and `issue create --field`
  - `tests/e2e_live.rs::test_e2e_issue_edit_custom_field` (the target test)
- **E2E validation:** nightly live-Jira run (non-blocking CI); confirms product behavior on a real Jira instance
- **Default CI (blocking):** `cargo test` + `ci-gate` suite; covers unit + integration tests; confirms no `...:textfield` or plain-string-field regressions

## Affected BCs and VPs

### New BCs Required (F2 will draft these)

Next available: BC-3.4.033, BC-3.3.013

Estimated new BCs (~4–6 total):

| ID | Surface | Description |
|----|---------|-------------|
| BC-3.4.033 | `issue edit --field` | ADF auto-conversion: a `--field NAME=VALUE` targeting a `...:textarea` custom field sends the value as `text_to_adf(value)` (ADF doc node), not a plain string |
| BC-3.4.034 | `issue edit --field` | ADF auto-conversion: a `--field environment=VALUE` sends the value as ADF (system field denylist) |
| BC-3.4.035 | `issue edit --field` | Error path: if ADF conversion somehow fails (future-proofing for Option B markdown path), clear actionable error; for Option A (`text_to_adf`, infallible) this BC may be merged into BC-3.4.033 |
| BC-3.3.013 | `issue create --field` | ADF auto-conversion: same detection + conversion on the create path (shared via `dispatch_field_value` per AC-008) |
| BC-3.3.014 | `issue create --field` | `environment` system-field on create path sends ADF |

*Exact BC numbering and subdivision confirmed in F2. Count estimates: 4–6 BCs.*

### Modified BCs (existing, semantic annotation only)

`BC-3.4.015` (Step 4 type dispatch `"string"` arm) — behavior annotation updated to note that
`...:textarea` and `schema.system == "environment"` are subsumed by new BC-3.4.033/034 handling
BEFORE the plain-string fallthrough. No postcondition change for plain-text fields.

### New VPs Required (F2 will draft these)

Estimated 1–2 new VPs:

| VP ID (proposed) | Module | Tool | Description |
|-----------------|--------|------|-------------|
| VP-FIELD-ADF-001 | `field_resolve.rs::dispatch_field_value` | proptest | For any `EditMetaField` with `schema.custom == "...:textarea"`, the wire value produced by `dispatch_field_value` is a JSON object `{type: "doc", ...}` (ADF), never a `Value::String` |
| VP-FIELD-ADF-002 | `field_resolve.rs::dispatch_field_value` | proptest | For any `EditMetaField` with `schema.custom == "...:textfield"` or any other non-ADF custom type, the wire value is a `Value::String` (regression invariant — non-ADF fields not accidentally converted) |

*Exact VP IDs assigned in F2 after VP-INDEX update.*

### Spec Version

Current: 2.3.0 → New: 2.4.0 (MINOR bump; new BCs added, no existing BCs removed or changed in postcondition).

## Story Decomposition Sketch

### Story 1: ADF auto-conversion in `dispatch_field_value` (~3–5 pts)

**Scope:** `src/cli/issue/field_resolve.rs` only (+ `src/types/jira/editmeta.rs` rustdoc update)

**Key changes:**
1. Add constant(s) for known ADF system fields and ADF custom types:
   ```rust
   const ADF_SYSTEM_FIELDS: &[&str] = &["environment", "description"];
   const ADF_CUSTOM_FIELD_TYPE: &str =
       "com.atlassian.jira.plugin.system.customfieldtypes:textarea";
   ```
2. Add `is_adf_field` predicate inside `dispatch_field_value` (or as a small standalone helper):
   ```rust
   fn is_adf_field(schema: &EditMetaFieldSchema) -> bool {
       schema.system.as_deref().map_or(false, |s| ADF_SYSTEM_FIELDS.contains(&s))
           || schema.custom.as_deref() == Some(ADF_CUSTOM_FIELD_TYPE)
   }
   ```
3. In the `"string" | "text"` arm of `dispatch_field_value`, branch on `is_adf_field`:
   - ADF → `wire_value = text_to_adf(&value)` (infallible; `text_to_adf` is already `pub` in `adf.rs`)
   - Non-ADF → `wire_value = Value::String(value.clone())` (current behavior, unchanged)
4. Update `src/types/jira/editmeta.rs` rustdoc: `custom` and `system` are no longer "not used in v1 resolution".
5. Unit tests (TDD, in `field_resolve.rs` `#[cfg(test)]`):
   - `test_dispatch_field_value_textarea_custom_sends_adf`
   - `test_dispatch_field_value_environment_system_sends_adf`
   - `test_dispatch_field_value_textfield_custom_sends_plain_string` (regression pin)
   - `test_dispatch_field_value_unknown_string_type_sends_plain_string` (regression pin)

**AC (sketch):**
- AC-1: `dispatch_field_value` with `schema.custom == "...:textarea"` sends `text_to_adf(value)` as wire value (not `Value::String`)
- AC-2: `dispatch_field_value` with `schema.system == "environment"` sends `text_to_adf(value)`
- AC-3: `dispatch_field_value` with `schema.custom == "...:textfield"` sends `Value::String(value)` unchanged (regression)
- AC-4: `dispatch_field_value` with `schema.field_type == "string"` and no `custom`/`system` ADF signal sends `Value::String(value)` unchanged (regression)
- AC-5: Hinted dispatch (`:option`, `:id`, `:name`, `:asset`) is UNAFFECTED — hinted path exits before the `field_type` match

### Story 2: E2E test assertion update (~1–2 pts) — may fold into Story 1

**Scope:** `tests/e2e_live.rs` only

**Key changes:**
1. Update `test_e2e_issue_edit_custom_field`'s fresh-GET assertion: when `wire_key == "environment"`, the returned field value is an ADF object, not a plain string. Assert the field is non-null and the ADF object is valid (type == "doc"), OR use `adf_to_text` to verify the round-trip text content matches.
2. `discover_safe_edit_field` heuristic: NO CHANGE to field-selection logic. `Environment` continues to be preferred. The product fix makes it correct.
3. Update the file-header doc comment at line 51–53 (`JR_E2E_EDIT_FIELD` note): optionally drop "(e.g. `Environment`)" if that parenthetical is stale after the product fix.

**AC (sketch):**
- AC-1: `test_e2e_issue_edit_custom_field` passes on the live Jira site (ES project, nightly) with `Environment` as the dynamically-discovered field
- AC-2: The fresh-GET assertion correctly validates an ADF-valued read-back
- AC-3: `discover_safe_edit_field` produces the same `("Environment", "environment")` tuple as today

### Story decomposition decision

**Recommended for F3:** 2 stories (~4–7 pts total). Story 1 is the product change with unit
test coverage. Story 2 is the E2E test update that provides live-Jira validation. They can
be delivered sequentially (Story 1 first; Story 2 is the E2E acceptance test).

**If scope is reduced:** Stories 1+2 can be merged into a single story (~4–5 pts) since the
change volume is small.

## Scope Recommendation

- **Mode:** Feature Mode, full F1–F7 pipeline
- **Estimated new stories:** 2 (Story 1: product logic + unit tests ~3–5 pts; Story 2: E2E assertion update ~1–2 pts; may be merged to 1 story)
- **Estimated effort:** 4–7 points total
- **Can parallelize:** No — Story 2 (E2E assertion) depends on Story 1 (product fix) being merged first
- **Release type:** MINOR (new BCs added; spec 2.3.0 → 2.4.0)
- **Cycle number:** cycle-012 (proposed; state-manager to formalize)

## Proposed Cycle Identity

**Name:** `field-adf-autoconvert`
**Proposed number:** `cycle-012`
**Flag for state-manager:** Parked bundles occupy cycle-008 through cycle-011. `cycle-012` is
the next available number. **State-manager must formalize the cycle number** when opening the
cycle record. This analysis uses the proposed identity for artifact naming only.

## Full Pipeline (F1–F7)

This is NOT quick-dev scope. Full Feature Mode applies:

| Phase | Status | Notes |
|-------|--------|-------|
| F1 Delta Analysis | **THIS DOCUMENT** | Human gate required |
| F2 Spec Evolution | Required | Add BC-3.4.033/034/035, BC-3.3.013/014; add VP-FIELD-ADF-001/002; spec 2.3.0 → 2.4.0 MINOR |
| F3 Story Decomposition | Required | 2 stories (~4–7 pts); adversarial review of story specs |
| F4 Implementation | Required | Story 1 (product logic + unit tests), Story 2 (E2E test update); TDD per-story; PRs to develop |
| F5 Scoped Adversarial | Required | Scoped to `dispatch_field_value` change; focus on regression risk (non-ADF fields not mis-converted) |
| F6 Targeted Hardening | Required | proptest for VP-FIELD-ADF-001/002; mutation testing on `is_adf_field` predicate; security scan (clean expected) |
| F7 Delta Convergence | Required | 5-dim convergence: spec + code + tests + VP + E2E nightly |
| Release | PATCH or MINOR | test-infra-only stories → PATCH; with BC additions → MINOR. Confirm in F7. |

## Relationship to cycle-007

cycle-007 (`auth-correctness-dx`) stays PAUSED at F4 (Wave-2 integration gate PENDING). This
cycle-012 analysis is a separate concern. cycle-007 resumes independently after this cycle
completes (or concurrently if the human elects). The two cycles share no code overlap
(`auth.rs`/`auth/` vs `field_resolve.rs`/`edit.rs`/`create.rs`).

## Out-of-Scope Statement

1. **`--markdown` support for `--field` ADF values** — deferred to a follow-on. `text_to_adf`
   (plain text only) is the conversion function for this cycle. Users who need markdown in
   `environment`/textarea fields can use `--description --markdown` (for the `description` field,
   already handled) or wait for the follow-on.
2. **JSM create path (`jsm_create.rs`)** — `handle_jsm_create` is out of scope. It does not
   route through `dispatch_field_value` and would require a separate analysis. Record as a
   follow-on standing item.
3. **Third-party/Connect/Forge ADF fields** — not generically detectable from metadata;
   `--field NAME:option=VALUE` hint syntax remains the escape hatch for special cases.
4. **`edit.rs` or `create.rs` call-site changes** — none required; `dispatch_field_value` is
   the sole fix site per AC-008.
5. **`discover_safe_edit_field` field-selection heuristic in `tests/e2e_live.rs`** — NO change
   to field selection is needed. The product fix makes `Environment` correct to select.

## Open Questions for Human Gate

1. **`--markdown` for `--field` ADF values (DQ-1):** Confirm Option A (plain text only) is
   acceptable. If yes, this cycle is cleanly scoped. If Option B (markdown support) is also
   wanted, story estimates increase by ~2 pts and `dispatch_field_value`'s signature changes.

2. **JSM create path (DQ-2):** Confirm JSM `--field` ADF conversion is OUT OF SCOPE for
   this cycle. The JSM path has its own request-building logic in `jsm_create.rs` that does
   not route through `dispatch_field_value`.

3. **E2E fresh-GET assertion strategy (DQ-4):** When `Environment` is written as ADF and
   read back, the GET response returns an ADF object. Acceptable verification strategies:
   (a) assert `json["fields"]["environment"]` is non-null and `type == "doc"` (structural check);
   (b) use `adf_to_text` to verify round-trip text content; (c) drop the fresh-GET assertion
   for the ADF path and rely on `updated == true`. Recommendation: (a) — clean, no round-trip
   dependency.
