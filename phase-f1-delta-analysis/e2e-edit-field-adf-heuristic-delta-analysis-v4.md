---
document_type: delta-analysis-report
feature_name: "ADF auto-conversion for --field on ADF-backed fields (edit + create + JSM create)"
created: 2026-09-12
spec_version_at_analysis: "2.3.0"
status: draft
intent: "feature"
feature_type: "backend"
scope: "standard"
severity: "N/A"
cycle_proposed: "cycle-012-field-adf-autoconvert (PROPOSED — state-manager must formalize number)"
supersedes: "e2e-edit-field-adf-heuristic-delta-analysis-v3.md (v3 — JSM path out of scope; SUPERSEDED)"
adversarial_review_incorporated: true
h2_probe_status: "CONFIRMED-for-system-fields + low-residual-for-textarea-custom-on-create (see §H2 Precondition; research/createmeta-schema-probe-2026-09-12.md)"
jsm_discriminator_status: "CONFIRMED — jiraSchema inner keys identical to platform schema; shared allowlist predicate viable (see §JSM-DISC; research/jsm-requesttype-fields-adf-probe-2026-09-12.md)"
standing_item_ref: "E2E-EDIT-FIELD-ADF-HEURISTIC"
---

# Delta Analysis Report v4: ADF Auto-Conversion for `--field` on ADF-Backed Fields (Platform + JSM)

> **SUPERSEDES** v1 (test-infra Route A), v2 (Route B first pass), and v3 (platform path
> only; JSM path out of scope in v3).
> All prior files are retained with `status: SUPERSEDED`.
>
> **Adversarial review findings incorporated (all from v3, unchanged):** C1, H1, H2, M1,
> M2, M3, M4, M5, O5, O6.
>
> **New in v4:** JSM create path (`--request-type --field`) added to scope; JSM
> discriminator confirmed via live probe; shared `is_adf_field` helper design; Story 2
> decomposition; revised total estimate.
>
> **Research basis (all):**
> - `.factory/research/e2e-environment-adf-field-2026-09-11.md` (platform ADF taxonomy)
> - `.factory/research/field-adf-autoconvert-design-research-2026-09-12.md` (full design Q&A)
> - `.factory/research/createmeta-schema-probe-2026-09-12.md` (H2: create-path parity, CONFIRMED)
> - `.factory/research/jsm-requesttype-fields-adf-probe-2026-09-12.md` (JSM discriminator, CONFIRMED)

## Feature Request

`jr issue edit --field NAME=VALUE` and `jr issue create --field NAME=VALUE` currently send
the value as a plain JSON string for all `schema.type == "string"` fields. Jira Cloud REST
v3 requires an ADF object on write for `environment`, `description`, and
`...:textarea` custom fields. Today these paths return
`API error (400): … Operation value must be an Atlassian Document`.

`jr issue create --request-type RT --field NAME=VALUE` (JSM create path) has the same gap:
the `extra_fields` loop in `JsmRequestBuilder::build()` sends `Value::String(spec.value)` for
bare/None kind, with no ADF conversion. JSM also rejects plain strings for ADF-backed fields.

**Pre-existing failure evidence:** `test_e2e_issue_edit_custom_field` fails deterministically
on `develop` tip `30bb1a18` with the exact 400 above (platform edit path).

---

## Classifications

**Intent:** `feature` — adds new product capability (ADF auto-conversion).

**Feature type:** `backend` — Rust product logic, no new CLI flags, no UX surface.

**Scope:** `standard` — full F1–F7 pipeline. NOT quick-dev.

**Spec version bump:** 2.3.0 → 2.4.0 (MINOR; new BCs added across two BC families).

---

## H2 PRECONDITION — RESOLVED (Platform Create-Path Schema Parity)

**Status: CONFIRMED-for-system-fields + low-residual-for-`:textarea`-custom-on-create.**
Full evidence: `.factory/research/createmeta-schema-probe-2026-09-12.md`.

Createmeta and editmeta return `schema.custom`/`schema.system` **identically** for every
tested field. `environment` and `description` (system fields) confirmed on both paths.
`:textarea` custom field on create is inferred at HIGH confidence from `:textfield` parity;
AC-13 in Story 1 closes this in F4.

**Key implementation detail — absent key vs None:** On system fields, the `custom` JSON key
is **entirely absent** (not `null`, not `""`). On custom fields, the `system` key is absent.
Both fields are `Option<String>` in `EditMetaFieldSchema` — missing key → `None` via serde
default. No struct change needed. Predicate uses `.as_deref()` against `Option<String>`.

---

## JSM-DISC: JSM Discriminator — CONFIRMED

**Status: CONFIRMED — same allowlist predicate as platform path.**
Full evidence: `.factory/research/jsm-requesttype-fields-adf-probe-2026-09-12.md`.

**Live probe method:** All 9 request types in the EJ service desk probed via
`GET /rest/servicedeskapi/servicedesk/1/requesttype/<N>/field`. Read-only.

**Wrapper key difference:** JSM uses `jiraSchema` as the outer key (platform uses `schema`).
Inner sub-keys (`type`, `system`, `custom`, `customId`, `items`) are structurally identical.

**Key finding — no generic ADF flag:** `description` (ADF-backed) and `summary` (plain text)
are both `jiraSchema.type == "string"` — indistinguishable by type alone. No `isADF`,
`renderedType`, `jsonType`, or equivalent flag exists. The allowlist is required.

**Reliable JSM discriminator:**

| Condition | ADF needed? | Status |
|---|:---:|---|
| `jiraSchema.system == "description"` | YES | Directly confirmed in probe |
| `jiraSchema.system == "environment"` | YES | Inferred (not in these JSM RTs; confirmed ADF on platform) |
| `jiraSchema.custom` suffix `:textarea` | YES | Inferred (no such field in test instance; follows from platform cross-path parity) |
| `jiraSchema.system == "summary"` | NO | Directly confirmed |
| `jiraSchema.custom` suffix `:textfield` | NO | Directly confirmed |
| Other `type: "option"`, `"date"`, `"array"` | NO | Not string, not ADF |

**Shared-helper design consequence:** A single `is_adf_field(schema_inner: &serde_json::Value) -> bool`
function that accepts the inner schema object works for BOTH paths. Platform callers extract
from `field.schema` (already typed as `EditMetaFieldSchema`); JSM callers extract
`field.jira_schema["jiraSchema"]` (untyped `serde_json::Value`, use `.get("system")` etc.).
This preserves AC-008 (shared detection logic) across code paths even though `jsm/requests.rs`
is a separate write path.

**`isAdfRequest` impact:** Currently `is_adf_request` is set to `true` only when `description`
is `Some` (line ~182 in `src/api/jsm/requests.rs`). After the fix, whenever any extra field
in `requestFieldValues` is ADF-converted, `isAdfRequest: true` MUST also be set — the JSM API
requires it for ANY ADF value in the body. The `JsmRequestBuilder::build()` method must
accumulate a flag: `is_adf_request |= any_extra_field_was_adf_converted`.

---

## ADF Detection Set (Platform + JSM — Unified)

| Condition | ADF-backed? | Source |
|-----------|-------------|--------|
| `schema.system.as_deref() == Some("environment")` | YES | Official v3 docs; JRACLOUD-75814 |
| `schema.system.as_deref() == Some("description")` | YES (LOAD-BEARING — see M3) | Official v3 docs |
| `schema.custom.as_deref()` ends with `":textarea"` | YES | Official v3 docs; platform + JSM inference |
| `schema.custom.as_deref()` ends with `":textfield"` | NO — plain string | Official v3 docs; JSM probe |
| Any other `schema.type == "string"` field | UNKNOWN — fall through to plain string | Research Q2 |

Note: for the JSM path, "schema" above refers to the inner `jiraSchema` sub-object extracted
from `RequestTypeField.jira_schema`. The predicate logic is identical.

---

## C1: Empty-Value Guard (CRITICAL — Top Priority)

**Finding:** `text_to_adf("")` emits an empty `text` node — Jira rejects this with 400
(JRACLOUD-79318). Auto-wrap MUST NOT route empty/whitespace values through `text_to_adf`.

**Required behavior:**
- Empty/whitespace on the **platform edit** path → send `{"type":"doc","version":1,"content":[]}`
  (the valid "clear field" ADF doc).
- Empty/whitespace on the **platform create** path → **omit the field entirely**.
- Empty/whitespace on the **JSM create** path → **omit the field entirely** (create-omit
  semantics; same as platform create).

This asymmetry (edit-clear vs create-omit) cannot be expressed in `dispatch_field_value` alone — see H1.

---

## H1: Redesigned Fix Surface (Route-Specific Pre-Check)

**Finding:** `dispatch_field_value` has no edit-vs-create context. The chosen redesign is
**route-specific pre-check (Option A — minimal signature change)**.

**Platform path (unchanged from v3):**

```
resolve_against_editmeta (EDIT path):
    if is_adf_field(&meta.schema) && value.trim().is_empty() {
        fields[field_id] = empty_adf_doc();   // clear the field
        continue;                              // skip dispatch
    }

resolve_against_createmeta (CREATE path):
    if is_adf_field(&adapted.schema) && value.trim().is_empty() {
        continue;  // omit the field entirely
    }

dispatch_field_value "string"/"text" arm (SHARED for platform):
    if is_adf_field(&meta_field.schema) {
        wire_value = text_to_adf(&value);  // value is guaranteed non-empty here
    } else {
        wire_value = Value::String(value.clone());
    }
```

**JSM path:**

```
JsmRequestBuilder::build() extra_fields loop:
    for (k, spec) in self.extra_fields {
        let wire_value = match spec.kind {
            None | Some(FieldValueKind::Option) => {
                let inner_schema = get_rt_field_schema(&self.rt_fields, &k);  // new lookup
                if is_adf_field_value(&inner_schema) {
                    if spec.value.trim().is_empty() {
                        continue;  // omit empty — same as platform create
                    }
                    is_adf_request = true;  // accumulate flag
                    text_to_adf(&spec.value)
                } else {
                    Value::String(spec.value.clone())  // unchanged
                }
            }
            // Id/Name/Asset arms: unchanged (never ADF)
            ...
        };
        rfv.insert(k.clone(), wire_value);
    }
```

where `is_adf_field_value(schema: &serde_json::Value) -> bool` is the JSM-facing thin wrapper
that calls the same allowlist logic as `is_adf_field(schema: &EditMetaFieldSchema) -> bool`
on the platform path. Both can delegate to a shared inner fn.

**Impact on AC-008:** ADF conversion logic shared; empty-value routing in route-specific
callers where context is available. AC-008 preserved.

---

## M3: `description` via `--field` Alone Is Load-Bearing (Platform + JSM)

On the platform path, `--field description=VALUE` without `--description` passes both
guards and reaches `dispatch_field_value`. ADF conversion must fire. This also applies on the
JSM path: `--request-type RT --field description=VALUE` must send ADF, not a plain string.

---

## M4: `customfield_NNNNN` Bypass Regression Pin (Platform)

The literal `customfield_NNNNN` bypass form for a `:textarea` field must fire ADF conversion
because field_id lookup reaches the adapted schema with `custom` populated. Requires a
regression AC pinning this behavior.

---

## M1: Adaptive E2E Read-Back Assertion (Platform)

`test_e2e_issue_edit_custom_field` must use an adaptive assertion:

```
if raw.is_string() {
    // plain-string textfield fallback
    assert_eq!(raw.as_str(), Some(expected_value));
} else if raw.is_object() {
    // ADF-backed field: structural check
    assert_eq!(raw["type"].as_str(), Some("doc"));
} else {
    panic!("Unexpected field read-back shape: {raw}");
}
```

## M2: Single Story Per Path — Product Fix + E2E Together

Story 1 (platform) and Story 2 (JSM) each ship their product fix and E2E assertion update
in the same PR. Splitting test updates into a separate story would leave the E2E suite broken
between merges.

---

## Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements | ~11 new BCs | BC-3.4.033–037 (edit path); BC-3.3.013–015 (create path); BC-3.8.019–022 (JSM path) |
| Architecture | 3 files | `field_resolve.rs` (3 functions + 1 new helper); `jsm/requests.rs` (extra-fields loop + isAdfRequest accumulation); `editmeta.rs` rustdoc |
| UX Screens | 0 | No new flags |
| Stories | 2 stories | Story 1: platform path (7 pts); Story 2: JSM path (2–4 pts) |
| Existing Tests | `dispatch_field_value` string-arm tests; `test_e2e_issue_edit_custom_field`; `test_e2e_jsm_create_request_roundtrip` | Full regression suite required |
| Verification Properties | 3–4 new VPs | VPs for ADF detection predicate, non-ADF regression, empty-guard, JSM ADF conversion |

## Files Changed

### New Files

None.

### Modified Files

| File Path | Change Type | Risk | Functions Affected |
|-----------|------------|------|--------------------|
| `src/cli/issue/field_resolve.rs` | Logic extension (3 functions + 1 new helper) | MEDIUM-HIGH | `dispatch_field_value` (ADF branch), `resolve_against_editmeta` (empty pre-check), `resolve_against_createmeta` (empty-omit pre-check), new `is_adf_field` helper |
| `src/api/jsm/requests.rs` | Logic extension (extra-fields loop + isAdfRequest accumulation) | MEDIUM | `JsmRequestBuilder::build()` extra_fields loop; `is_adf_request` flag accumulation |
| `tests/e2e_live.rs` | Test assertion updates | LOW | `test_e2e_issue_edit_custom_field` (adaptive read-back); JSM E2E assertion (see §JSM-E2E) |
| `src/types/jira/editmeta.rs` | Rustdoc only | NONE | Remove "not used in v1 resolution" from `custom`/`system` fields |

### Dependent Files (unchanged, regression risk zone)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `src/cli/issue/edit.rs` | `resolve_edit_fields` → `resolve_against_editmeta` | MEDIUM |
| `src/cli/issue/create.rs` | `resolve_edit_fields` → `resolve_against_createmeta` | MEDIUM |
| `src/cli/issue/jsm_create.rs` | `JsmRequestBuilder::build()` | MEDIUM — JSM create tests must pass |

### Files Explicitly NOT Changed

- `src/cli/issue/edit.rs`, `create.rs`, `jsm_create.rs` — call sites unchanged
- `src/adf.rs` — no new exports; `text_to_adf` already `pub`
- `src/types/jsm/request_type.rs` — `RequestTypeField.jira_schema` is already `serde_json::Value`; no struct change needed for the JSM path
- All `src/api/jira/` files
- `.github/workflows/` — no CI changes

## Files NOT Changed (Regression Baseline)

All existing `"string"/"text"` arm behavior in `dispatch_field_value` for `...:textfield`,
`summary`, and any other non-ADF field must continue to produce `Value::String(value)` unchanged.
All existing JSM create extra-field behavior for non-ADF fields (`:textfield`, option, date,
array) must send the existing wire form unchanged. The `isAdfRequest` flag must NOT be set
when no ADF conversion occurs for extra fields.

This is the primary regression risk: the `is_adf_field` predicate (and its JSM-facing
`is_adf_field_value` wrapper) must be exact and exclusive — any over-selection accidentally
converts a plain-string field to ADF, producing a guaranteed 400 on that field.

---

## JSM-E2E: E2E Test Recommendation for JSM Path

**Existing test: `test_e2e_jsm_create_request_roundtrip`** (`tests/e2e_live.rs`, gated on
`JR_E2E_JSM_PROJECT`). This test exercises JSM create but does NOT currently pass a
`--field <adf-backed-field>=VALUE` pair. It cannot validate the ADF conversion.

**Recommendation:** Add an assertion to `test_e2e_jsm_create_request_roundtrip` (or a new
companion test) that:
1. Passes `--field description=<value>` via the `--field` generic path (not the dedicated
   `--description` flag) and asserts the created request's description field is ADF on read-back.
2. Optionally: if the EJ instance has a `:textarea` custom field on any request type, test that
   path too; clean-skip if absent.

**Do NOT add a new standalone JSM ADF E2E test function if the roundtrip test can be extended
in-place.** The `JR_E2E_JSM_PROJECT` gate already provides the right conditional scope.

---

## Scope Recommendation

- **Mode:** Feature Mode, full F1–F7 pipeline
- **Estimated new stories:** 2 (Story 1: platform, Story 2: JSM)
- **Estimated effort:** **10 points (LOCKED)** — both probes resolved; no open blockers
- **Can parallelize:** NO — Story 2 depends on the shared `is_adf_field` helper from Story 1
- **Release type:** MINOR (new BCs; spec 2.3.0 → 2.4.0)
- **Cycle:** cycle-012-field-adf-autoconvert (proposed; state-manager to formalize)

### Effort Breakdown

| Item | Story | Pts |
|------|-------|-----|
| `is_adf_field` predicate + constants (platform-facing typed version) | 1 | 0.5 |
| `dispatch_field_value` ADF conversion branch (non-empty) | 1 | 1 |
| `resolve_against_editmeta` empty pre-check + clear-doc | 1 | 1 |
| `resolve_against_createmeta` empty-omit pre-check | 1 | 1 |
| Unit tests: ADF happy path (textarea, environment, description-via-field, customfield bypass) | 1 | 1.5 |
| Unit tests: regression pins (textfield, unknown string, empty-edit clear, empty-create omit) | 1 | 1.5 |
| E2E assertion update (adaptive, both branches) | 1 | 0.5 |
| VP drafting for Story 1 (2–3 VPs) | 1 | 0.5 |
| **Story 1 total** | | **7.5 → 7 pts (round)** |
| `is_adf_field_value` JSM-facing wrapper (thin, delegates to shared logic) | 2 | 0.5 |
| `JsmRequestBuilder::build()` extra-fields ADF branch + `isAdfRequest` accumulation | 2 | 1 |
| `RequestTypeField` metadata lookup in build path (inner jiraSchema extraction) | 2 | 0.5 |
| Unit tests: JSM ADF happy path (description-via-field), empty-omit, non-ADF regression | 2 | 1 |
| E2E assertion for JSM path (in `test_e2e_jsm_create_request_roundtrip`) | 2 | 0.5 |
| VP drafting for Story 2 (1 VP) | 2 | 0.5 |
| **Story 2 total** | | **~4 pts** |
| **Grand total** | | **~10–11 pts → 10 pts (LOCKED)** |

---

## Story Decomposition

### Story 1: Platform ADF auto-conversion + E2E assertion update (7 pts, LOCKED)

**Scope:** `src/cli/issue/field_resolve.rs` + `tests/e2e_live.rs` (platform E2E assertion) + `src/types/jira/editmeta.rs` (rustdoc)

**H2 precondition: CLEARED.** Create-path parity confirmed by live probe.

**AC (sketch):**

*Core detection + non-empty conversion (both platform paths):*
- AC-1: `dispatch_field_value` with `schema.custom == "...:textarea"` and non-empty value sends `text_to_adf(value)` as wire value
- AC-2: `dispatch_field_value` with `schema.system == "environment"` and non-empty value sends `text_to_adf(value)`
- AC-3: `dispatch_field_value` with `schema.system == "description"` and non-empty value sends `text_to_adf(value)` (LOAD-BEARING per M3)
- AC-4: `dispatch_field_value` with `schema.custom == "...:textfield"` sends `Value::String(value)` unchanged (regression pin)
- AC-5: `dispatch_field_value` with unknown `schema.field_type == "string"` and no ADF signal sends `Value::String(value)` unchanged (regression pin)
- AC-6: `customfield_NNNNN` literal-bypass for a `:textarea` field sends `text_to_adf(value)` (M4)

*Empty-value guard (C1):*
- AC-7: `resolve_against_editmeta` with ADF-backed field and empty/whitespace value sets `fields[field_id] = {"type":"doc","version":1,"content":[]}` (clear-doc)
- AC-8: `resolve_against_createmeta` with ADF-backed field and empty/whitespace value OMITS `fields[field_id]` entirely
- AC-9: `dispatch_field_value` ADF branch is only reachable with non-empty/non-whitespace value

*`description` via `--field` alone (M3):*
- AC-10: `jr issue edit FOO-1 --field description="Hello"` (no `--description` flag) succeeds with ADF payload
- AC-11: `jr issue create --project X --summary "T" --field description="Hello"` (no `--description` flag) succeeds with ADF payload

*E2E assertions (M1 + M2):*
- AC-12: `test_e2e_issue_edit_custom_field` passes on the live Jira site with adaptive read-back assertion
- AC-13: create-path `:textarea` live confirmation (H2 low residual; clean-skip if no `:textarea` field on E2E instance)

*Unchanged surface (regression):*
- AC-14: All existing `issue edit --field` and `issue create --field` tests for non-ADF fields pass unchanged
- AC-15: Hinted dispatch (`:option`, `:id`, `:name`, `:asset`) is UNAFFECTED

### Story 2: JSM create ADF auto-conversion + JSM E2E assertion (4 pts)

**Prerequisite:** Story 1 merged (shared `is_adf_field` helper available).

**Scope:** `src/api/jsm/requests.rs` + `tests/e2e_live.rs` (JSM E2E assertion)

**JSM-DISC precondition: CLEARED.** Discriminator confirmed by live probe.

**AC (sketch):**

*Core JSM detection + non-empty conversion:*
- JSM-AC-1: `JsmRequestBuilder::build()` extra_fields bare-kind dispatch — when `jiraSchema.system == "description"`, auto-wraps via `text_to_adf(value)` and sets `isAdfRequest: true` (even when top-level `self.description` is `None`)
- JSM-AC-2: When `jiraSchema.custom` suffix `:textarea` — auto-wraps via `text_to_adf(value)` and accumulates `isAdfRequest: true`
- JSM-AC-3: When `jiraSchema.system == "summary"` or `jiraSchema.custom` suffix `:textfield` — sends `Value::String(value)` unchanged; `isAdfRequest` NOT set for this field
- JSM-AC-4: `isAdfRequest: true` is present in the final POST body whenever any `requestFieldValues` entry is ADF (description + extra_fields combined)

*Empty-value guard (C1 for JSM):*
- JSM-AC-5: `JsmRequestBuilder::build()` with ADF-backed extra field and empty/whitespace value OMITS that field from `requestFieldValues` (create-omit semantics; no empty text node)

*`description` via `--field` alone (M3 for JSM):*
- JSM-AC-6: `jr issue create --request-type RT --field description="Hello"` sends ADF in `requestFieldValues` and `isAdfRequest: true`

*E2E assertion:*
- JSM-AC-7: `test_e2e_jsm_create_request_roundtrip` extended (or companion test) passes with `--field description=<value>` via generic `--field` path; description field on read-back is an ADF object (not a plain string)

*`RequestTypeField` metadata availability:*
- JSM-AC-8: The JSM extra_fields ADF detection has access to `RequestTypeField` metadata (either passed into `JsmRequestBuilder` or looked up from a pre-fetched fields map); if metadata is unavailable for a given field, fall through to `Value::String` (safe default)

*Unchanged surface (regression):*
- JSM-AC-9: Non-ADF extra fields (`:textfield`, option, date, array) pass through as `Value::String` or their existing wire form unchanged
- JSM-AC-10: All existing JSM create tests pass unchanged; `isAdfRequest` is not set when no ADF field is present

---

## Affected BCs (sketch; F2 will draft full text)

Next available: BC-3.4.033 (edit), BC-3.3.013 (create), BC-3.8.019 (JSM).
Current highest: BC-3.4.032, BC-3.3.012, BC-3.8.018 (verified from spec).

| Proposed ID | Surface | Story | Description |
|-------------|---------|-------|-------------|
| BC-3.4.033 | `issue edit --field` | 1 | `:textarea` custom field non-empty → auto ADF |
| BC-3.4.034 | `issue edit --field` | 1 | `environment` system field non-empty → auto ADF |
| BC-3.4.035 | `issue edit --field` | 1 | `description` via `--field` alone (no `--description`) → auto ADF |
| BC-3.4.036 | `issue edit --field` | 1 | Empty/whitespace value for ADF field → clear with empty ADF doc; NOT a 400 |
| BC-3.4.037 | `issue edit --field` | 1 | `customfield_NNNNN` bypass for a `:textarea` field → auto ADF (M4 regression pin) |
| BC-3.3.013 | `issue create --field` | 1 | `:textarea` custom field non-empty → auto ADF (conditional on H2) |
| BC-3.3.014 | `issue create --field` | 1 | `description` via `--field` alone → auto ADF |
| BC-3.3.015 | `issue create --field` | 1 | Empty/whitespace ADF field → omit from request body |
| BC-3.8.019 | `issue create --request-type --field` | 2 | `description` via generic `--field` on JSM create → ADF + `isAdfRequest: true` |
| BC-3.8.020 | `issue create --request-type --field` | 2 | `:textarea` custom field on JSM create → ADF + `isAdfRequest: true` (inferred; live confirmation in F4) |
| BC-3.8.021 | `issue create --request-type --field` | 2 | Empty/whitespace ADF field on JSM create → omit from `requestFieldValues` |
| BC-3.8.022 | `issue create --request-type --field` | 2 | `isAdfRequest: true` set in POST body whenever any `requestFieldValues` entry is ADF (not just when `self.description` is Some) |

*Total: ~12 new BCs. Exact numbering confirmed in F2.*

---

## Proposed VPs (sketch; F2 will draft full text)

| Proposed ID | Module | Tool | Story | Description |
|-------------|--------|------|-------|-------------|
| VP-FIELD-ADF-001 | `field_resolve.rs::dispatch_field_value` | proptest | 1 | For any non-empty `EditMetaField` with `schema.custom == "...:textarea"`, wire value is `{"type":"doc",...}` (never `Value::String`) |
| VP-FIELD-ADF-002 | `field_resolve.rs::dispatch_field_value` | proptest | 1 | For any `EditMetaField` with `schema.custom == "...:textfield"`, wire value is `Value::String` (regression invariant) |
| VP-FIELD-ADF-003 | `field_resolve.rs` (route pre-checks) | unit | 1 | For any ADF-backed field with empty/whitespace value: edit-path → empty ADF doc; create-path → no `fields[field_id]` entry |
| VP-FIELD-ADF-004 | `api/jsm/requests.rs::JsmRequestBuilder::build` | unit | 2 | For any JSM extra field with `jiraSchema.system == "description"` and non-empty value: `requestFieldValues[field_id]` is ADF object AND `isAdfRequest: true` is in body |

*Total: ~4 new VPs.*

---

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression (platform) | MEDIUM-HIGH | `dispatch_field_value` is shared dispatch core. `is_adf_field` predicate over-selection accidentally converts a plain-string field to ADF → guaranteed 400. Full regression suite required. |
| Regression (JSM) | MEDIUM | `JsmRequestBuilder::build()` extra_fields loop is simpler but serves real JSM create operations. `isAdfRequest` flag accumulation must not fire for non-ADF fields. |
| Architecture | LOW | Three product files modified. AC-008 preserved: shared detection logic, route-specific empty-value handling. No interface changes to calling code. |
| Security | NONE | No new network calls, credentials, or deserialization surfaces. `text_to_adf` already in production use for `--description`. |
| Performance | NONE | ADF detection is a `.get()` lookup on an already-deserialized value. `text_to_adf` is O(N) in text length, same order as existing `--description` path. No additional HTTP calls. |
| Story sequencing | LOW | Story 2 depends on the shared `is_adf_field` helper from Story 1. Must not parallelize. |
| JSM field metadata availability | LOW | Story 2 requires `RequestTypeField` metadata in `JsmRequestBuilder`. The metadata is already fetched by `handle_jsm_create` (or its callers) for display purposes; the design must pass or look up the `rt_fields` map inside `build()`. This is a plumbing question for F4, not a scope risk. |

## Regression Baseline

- **Total BC count:** 757 (unchanged until F2 adds ~12 new BCs)
- **Total E2E tests:** 107; 106/107 currently pass
- **Tests in regression risk zone:**
  - Unit tests covering `dispatch_field_value` `"string"/"text"` arm
  - Integration tests for `issue edit --field` and `issue create --field`
  - `tests/e2e_live.rs::test_e2e_issue_edit_custom_field` (failing target; fixed by Story 1)
  - `tests/e2e_live.rs::test_e2e_jsm_create_request_roundtrip` (extended by Story 2)

---

## Design Questions for Human Gate

### DQ-1: `--markdown` for `--field` ADF values?

**Recommended: Option A — `text_to_adf` only this cycle.** `--markdown` stays a `--description`
modifier. Users needing markdown in `environment`/`:textarea` fields file a follow-on.

### DQ-2: CLOSED ✓ (JSM path IN scope — per coordinator message 6)

JSM `--request-type --field` is included in cycle-012 per the scope expansion in the
coordinator's message 6. Addressed in Story 2.

### DQ-3 (H2): CLOSED ✓

Create-path parity confirmed. `:textarea` on create is HIGH-confidence inference. AC-13 closes
the residual in F4. No gate remaining.

### DQ-4 (dry-run preview shape — O6)

For ADF-backed `--field` values in dry-run mode, should `planned_preview` show the raw user
text (readable) or the ADF object (accurate)? Mirror `--description`'s `descriptionAdf` key
approach? Needs a decision before F2 closes BC-3.4.036.

### DQ-5 (E2E create-path AC)

Live create-path E2E (`jr issue create --field <textarea-field>=VALUE`) is in scope for
Story 1 AC-13 as a conditional test (clean-skip if no `:textarea` field on E2E instance).
No additional decision needed.

### DQ-6 (JSM `RequestTypeField` metadata plumbing)

`JsmRequestBuilder::build()` currently receives `extra_fields: HashMap<String, FieldValueSpec>`
but NOT the `RequestTypeField` metadata map. For Story 2, the builder needs access to
`jira_schema` for each field key. Options: (a) pass `rt_fields: &[RequestTypeField]` into
`build()`; (b) pre-resolve ADF fields in `jsm_create.rs` before calling the builder, passing
an extra flag or a pre-computed `adf_fields: HashSet<String>`. Decision for F4; note for F2.

---

## Fold-Into-F2 Notes (Non-Blocking)

### O5: Behavior change on `--field environment=X` (400 → exit-0)

Post-fix, `--field environment=X` flips from a loud 400 to a silent exit-0 write. F2 should
add a BC note about this behavioral change and note that it is the CORRECT behavior.

### O6: Dry-run `planned_preview` shape for ADF `--field` values

`dispatch_field_value` currently sets `planned_preview` to the raw user string for `"string"`
fields. After the fix, ADF-backed fields would set `planned_preview` to an ADF JSON object.
Mirror how `--description` dry-run uses `descriptionAdf` as a separate key. F2 adds a BC.

---

## Surviving Claims (Not Refuted)

- **O1 (mentions asymmetry):** `text_to_adf` does not resolve `@mentions`. `--field env="@Alice"` writes literal text. Acceptable.
- **O2 (multi-line text):** `text_to_adf` handles multi-line text via INV-1 + `hardBreak`. Valid.
- **O3 (hint grammar):** Hinted path (`:option`/`:id`/`:name`/`:asset`) exits before `field_type` match. No ADF conversion on hinted path. Documented behavior.
- **O4 (single-key guard):** Existing single-key guard on `issue edit --field` unchanged.

---

## Open Questions

1. **DQ-1 (`--markdown` for `--field` ADF values):** Confirm Option A (plain text only) is acceptable.
2. **DQ-4 (dry-run preview shape):** Should `planned_preview` for ADF `--field` values show raw text or ADF object in dry-run output?
3. **DQ-6 (JSM metadata plumbing):** Which option for passing `RequestTypeField` metadata into `JsmRequestBuilder::build()`? (a) pass `rt_fields` slice, or (b) pre-resolve in `jsm_create.rs`?

---

## Proposed Cycle Identity

**Name:** `field-adf-autoconvert`
**Proposed number:** `cycle-012`
**Flag for state-manager:** Parked bundles occupy cycle-008 through cycle-011. `cycle-012`
is the next available number. State-manager must formalize when opening the cycle record.

---

## Full Pipeline

F1 (this + human gate) → F2 (spec: ~12 BCs, 4 VPs, 2.3.0→2.4.0; both probes closed) →
F3 (2 stories, adversarial review) → F4 (Story 1: field_resolve.rs + e2e_live.rs; TDD; PR) →
F4 continue (Story 2: jsm/requests.rs + JSM E2E assertion; TDD; PR; depends on Story 1 merged) →
F5 (adversarial: platform predicate over/under-selectivity + JSM flag accumulation paths) →
F6 (proptest VPs + mutation on `is_adf_field` + regression scan) →
F7 (5-dim convergence + E2E nightly confirmation) → MINOR release.
