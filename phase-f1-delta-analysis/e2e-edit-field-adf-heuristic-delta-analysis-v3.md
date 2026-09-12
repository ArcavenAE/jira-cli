---
document_type: delta-analysis-report
feature_name: "ADF auto-conversion for --field on ADF-backed fields (edit + create)"
created: 2026-09-12
spec_version_at_analysis: "2.3.0"
status: SUPERSEDED
intent: "feature"
feature_type: "backend"
scope: "standard"
severity: "N/A"
cycle_proposed: "cycle-012-field-adf-autoconvert (PROPOSED — state-manager must formalize number)"
supersedes: "e2e-edit-field-adf-heuristic-delta-analysis-v2.md (adversarial review; SUPERSEDED)"
adversarial_review_incorporated: true
h2_probe_status: "CONFIRMED-for-system-fields + low-residual-for-textarea-custom-on-create (see §H2 Precondition; research/createmeta-schema-probe-2026-09-12.md)"
standing_item_ref: "E2E-EDIT-FIELD-ADF-HEURISTIC"
---

# Delta Analysis Report v3: ADF Auto-Conversion for `--field` on ADF-Backed Fields

> **SUPERSEDES** v1 (`e2e-edit-field-adf-heuristic-delta-analysis.md`, test-infra Route A) and
> v2 (`e2e-edit-field-adf-heuristic-delta-analysis-v2.md`, Route B first pass).
> Both prior files are retained with `status: SUPERSEDED`.
>
> **Adversarial review findings incorporated:** C1, H1, H2, M1, M2, M3, M4, M5, O5, O6.
> Surviving (non-refuted) claims O1–O4 are documented at the end of this document.

## Feature Request

`jr issue edit --field NAME=VALUE` and `jr issue create --field NAME=VALUE` currently send
the value as a plain JSON string for all `schema.type == "string"` fields. Jira Cloud REST
v3 requires an ADF object on write for `environment`, `description`, and
`...:textarea` custom fields. Today these paths return
`API error (400): … Operation value must be an Atlassian Document`.

**Research basis:** `.factory/research/e2e-environment-adf-field-2026-09-11.md` (complete).
**Pre-existing failure evidence:** `test_e2e_issue_edit_custom_field` fails deterministically
on `develop` tip `30bb1a18` with the exact 400 above.

---

## Classifications

**Intent:** `feature` — adds new product capability (ADF auto-conversion).

**Feature type:** `backend` — Rust product logic, no new CLI flags, no UX surface.

**Scope:** `standard` — full F1–F7 pipeline. NOT quick-dev.

**Spec version bump:** 2.3.0 → 2.4.0 (MINOR; new BCs added).

---

## H2 PRECONDITION — RESOLVED ✓

**Status: CONFIRMED-for-system-fields + low-residual-for-`:textarea`-custom-on-create.**
Full evidence: `.factory/research/createmeta-schema-probe-2026-09-12.md`.

**Live probe findings (read-only, E2E Jira Cloud instance):**

The probe confirmed that createmeta and editmeta return `schema.custom`/`schema.system`
**identically** — byte-for-byte — for every field type that could be cross-checked:

| Field kind | `schema.system` | `schema.custom` | Endpoints confirmed |
|-----------|:---:|:---:|:---:|
| `environment` (system) | `"environment"` | key ABSENT | createmeta + editmeta |
| `description` (system) | `"description"` | key ABSENT | createmeta + editmeta |
| `customfield_10001` (team custom) | absent | `"...:atlassian-team"` | createmeta + editmeta |
| `customfield_10044` (textfield custom) | absent | `"...:textfield"` | createmeta only |

**Key implementation detail — absent vs None:** On system fields, the `custom` JSON key is
**entirely absent** from the response (not `null`, not `""`). On custom fields, the `system`
JSON key is entirely absent. This is already handled correctly: `EditMetaFieldSchema.custom`
and `.system` are both `Option<String>` with `serde` default deserialization — a missing key
deserializes to `None`, not a panic or error. The predicate must use `.as_deref()` against
`Option<String>`, which it already does. No struct change needed.

**Low residual (`:textarea` custom field on create — NOT a blocker):** The probed instance
had no `:textarea` custom fields. The `:textarea` pattern on the create path is inferred from:
(1) the `:textfield` analog observed in createmeta (`schema.custom` populated with the
full `com.atlassian.jira.plugin.system.customfieldtypes:textfield` key);
(2) byte-for-byte parity confirmed on every field type that could be cross-checked.
Confidence is HIGH. The primary fix target (`Environment`, a system field) is fully confirmed
on both paths and is NOT affected by this residual.

**F4 acceptance requirement for this residual:** Story 1 AC-13 (below) explicitly requires
a live E2E confirmation that `issue create --field <textarea-field>=VALUE` succeeds on an
instance with a `:textarea` field configured. If no such field exists on the E2E instance,
AC-13 is a clean skip with a note; the inference remains the operative evidence.

**Create-path scope consequence:** Full create-path parity with edit-path is achievable via
the shared `is_adf_field` predicate. No scope change or fallback strategy needed. H2 is
downgraded from a blocker to a confirmed precondition with a low-priority F4 confirmation.

---

## ADF Detection Set

| Condition | ADF-backed? | Source |
|-----------|-------------|--------|
| `meta.schema.system.as_deref() == Some("environment")` | YES | Official v3 docs; JRACLOUD-75814 |
| `meta.schema.system.as_deref() == Some("description")` | YES (LOAD-BEARING — see M3) | Official v3 docs |
| `meta.schema.custom.as_deref() == Some("com.atlassian.jira.plugin.system.customfieldtypes:textarea")` | YES | Official v3 docs |
| `meta.schema.custom.as_deref() == Some("com.atlassian.jira.plugin.system.customfieldtypes:textfield")` | NO — plain string | Official v3 docs |
| Any other `schema.field_type == "string"` | UNKNOWN — fall through to plain string (safe default) | Research Q2 |

**Implementation note — absent key vs `None`:** On system fields (`environment`, `description`),
the `custom` JSON key is **entirely absent** from the API response (not `null`, not `""`). On
custom fields, the `system` JSON key is entirely absent. `EditMetaFieldSchema.custom` and
`.system` are both `Option<String>` — a missing JSON key deserializes to `None` with serde's
default behavior. The predicate uses `.as_deref()` against `Option<String>`, which correctly
handles `None` (produces `None`, not a panic). No struct change is needed; this is already
correct. Confirmed by the H2 live probe: `{"type":"string","system":"environment"}` — no
`custom` key present for system fields; `{"type":"string","custom":"...:textfield","customId":N}`
— no `system` key present for custom fields.

---

## C1: Empty-Value Guard (CRITICAL — Top Priority)

**Finding:** `text_to_adf("")` emits `{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":""}]}]}` which contains an empty `text` node. Jira rejects this with a 400 (JRACLOUD-79318: empty text nodes are invalid ADF).

**Required behavior:**
- Empty or all-whitespace value on the **edit** path → send `{"type":"doc","version":1,"content":[]}` (the valid "clear field" ADF doc).
- Empty or all-whitespace value on the **create** path → **omit the field entirely** from the request body (do not set it; `None` on required fields is caught later by Jira's required-field validation, not our code's responsibility).

**This is an asymmetry `dispatch_field_value` alone cannot express** — see H1.

---

## H1: Redesigned Fix Surface (Route-Specific Pre-Check)

**Finding:** `dispatch_field_value` has no edit-vs-create context (`FieldMetaSource` is
consumed upstream in `resolve_edit_fields`). The unconditional `outputs.fields[field_id] = wire_value`
write means `dispatch_field_value` cannot choose "omit the field" for the create path.

**Chosen redesign: route-specific pre-check (Option A — minimal signature change).**

Instead of threading a context parameter into `dispatch_field_value`, the empty-value
special case is handled in the two route functions *before* calling dispatch:

```
resolve_against_editmeta (EDIT path):
    if is_adf_field(&meta.schema) && value.trim().is_empty() {
        fields[field_id] = empty_adf_doc();   // clear the field
        continue;                              // skip dispatch
    }

resolve_against_createmeta (CREATE path):
    if is_adf_field(&adapted.schema) && value.trim().is_empty() {
        continue;  // omit the field entirely — do NOT set fields[field_id]
    }

dispatch_field_value "string"/"text" arm (SHARED):
    if is_adf_field(&meta_field.schema) {
        wire_value = text_to_adf(&value);  // value is guaranteed non-empty here
    } else {
        wire_value = Value::String(value.clone());  // unchanged
    }
```

where `is_adf_field(schema: &EditMetaFieldSchema) -> bool` is a small standalone function
(not a closure) so it can be called from all three locations.

**Impact on Architecture Compliance Rule 1 (AC-008):** The non-empty ADF conversion is
still shared via `dispatch_field_value`. The empty-value ROUTING asymmetry is placed in
the two route-specific callers where the context is naturally available. AC-008 is preserved
for the conversion logic; it was never about pre-flight routing.

**Corrected touch surface (v2 claim was wrong):**
- `dispatch_field_value` — MODIFIED (ADF conversion branch added to `"string"/"text"` arm)
- `resolve_against_editmeta` — MODIFIED (empty-value pre-check + clear-with-empty-doc)
- `resolve_against_createmeta` — MODIFIED (empty-value pre-check + omit)
- New standalone helper `is_adf_field` — NEW (file-scope, not public)

All three functions live in `src/cli/issue/field_resolve.rs`. The fix is still a single-file
product change, but it touches three functions, not one.

---

## M3: `description` via `--field` Alone Is Load-Bearing

**Finding (adversarial review):** The edit Gate-B and create-D2 collision guards fire only
when the dedicated `--description`/`--description-stdin` flag ALSO appears. A call like
`jr issue edit FOO-1 --field description="Hello"` (no `--description`) passes both guards
and reaches `dispatch_field_value`. The v2 "collision-guarded upstream" framing was
misleading.

**Correction:** `description` in the ADF detection predicate is LOAD-BEARING for both edit
and create paths when the user passes `--field description=VALUE` alone. This is correct
behavior: the user explicitly asked to set the `description` field, and the product should
auto-convert to ADF just as it does for `environment`/`:textarea`.

**Required:** Dedicated BC + AC for `--field description=VALUE` alone (no `--description`
flag) on both edit and create paths.

---

## M4: `customfield_NNNNN` Bypass Regression Pin

**Finding:** A user invoking `--field customfield_10042=text` (literal-bypass form,
BC-3.4.015 Step 1) where `customfield_10042` is a `:textarea` field: the literal ID is
looked up in the meta by ID (Phase 2/3 resolves by field_id directly), so
`meta_field.schema.custom` is correctly populated → ADF detection fires → conversion
happens correctly. This is the right behavior, but it is untested today.

**Required:** Pinned regression AC/VP for the `customfield_NNNNN` bypass form on a
`:textarea` field: assert the wire value is ADF, not the plain string.

---

## Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements | ~6–8 new BCs | BC-3.4.033–037 (edit path: happy path textarea, happy path environment, happy path description-via-field-alone, empty clear, customfield bypass); BC-3.3.013–015 (create path: happy path, omit-empty, description-via-field-alone); see BC sketch below |
| Architecture | 1 file, 3 functions + 1 new helper | `field_resolve.rs`: `dispatch_field_value` + `resolve_against_editmeta` + `resolve_against_createmeta` + new `is_adf_field`; `editmeta.rs` rustdoc |
| UX Screens | 0 | CLI-only; no new flags |
| Stories | 1 story (merged per M2) | Product fix + E2E assertion update in one story + one PR (see §Story Decomposition) |
| Existing Tests | All `dispatch_field_value` string-arm tests, E2E `test_e2e_issue_edit_custom_field` | Full regression suite required |
| Verification Properties | 2–3 new VPs | VP for ADF detection predicate; VP for non-ADF textfield non-conversion (regression); VP for customfield bypass |

## Files Changed

### New Files

None.

### Modified Files

| File Path | Change Type | Risk | Functions Affected |
|-----------|------------|------|--------------------|
| `src/cli/issue/field_resolve.rs` | Logic extension (3 functions + 1 new helper) | MEDIUM-HIGH | `dispatch_field_value` (ADF branch), `resolve_against_editmeta` (empty pre-check), `resolve_against_createmeta` (empty-omit pre-check), new `is_adf_field` helper |
| `tests/e2e_live.rs` | Test assertion update | LOW | `test_e2e_issue_edit_custom_field` (adaptive read-back assertion — see M1); `discover_safe_edit_field` field-selection unchanged |
| `src/types/jira/editmeta.rs` | Rustdoc only | NONE | Remove "not used in v1 resolution" from `custom`/`system` fields |

### Dependent Files (unchanged but in regression risk zone)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `src/cli/issue/edit.rs` | `resolve_edit_fields` → `resolve_against_editmeta` | MEDIUM — all `--field` edit tests must pass |
| `src/cli/issue/create.rs` | `resolve_edit_fields` → `resolve_against_createmeta` | MEDIUM — all `--field` create tests must pass |

### Files Explicitly NOT Changed

- `src/cli/issue/jsm_create.rs` — JSM create path OUT OF SCOPE this cycle (DQ-2 confirmed)
- `src/cli/issue/edit.rs`, `create.rs` — call sites unchanged
- `src/adf.rs` — no new exports; `text_to_adf` already `pub`
- All `src/api/` files
- `.github/workflows/` — no CI changes
- `.factory/specs/architecture/` — no architecture section changes

## Files NOT Changed (Regression Baseline)

All existing `"string"/"text"` arm behavior for `...:textfield`, `summary`, and any other
non-ADF field must continue to produce `Value::String(value)` unchanged. This is the primary
regression risk: the `is_adf_field` predicate must be exact and exclusive.

## M1: Adaptive E2E Read-Back Assertion

**Finding:** The v2 assertion strategy ("assert `type == "doc"`") breaks for the `...:textfield`
clean-skip fallback path (where `discover_safe_edit_field` returns a plain-string custom field
because no `:textarea` is available). A flat `as_str()` comparison breaks on ADF read-back.
The assertion must handle both branches.

**Required adaptive assertion logic for `test_e2e_issue_edit_custom_field`:**

```
When wire_key is Some(wk):
    let raw = fresh_get["fields"][&wk];
    if raw.is_string() {
        // field is a plain-string textfield: compare as string
        assert_eq!(raw.as_str(), Some(expected_value));
    } else if raw.is_object() {
        // field is ADF-backed (textarea / environment): validate structurally
        assert_eq!(raw["type"].as_str(), Some("doc"),
            "ADF read-back must be a doc node");
        // Optional deeper check: adf_to_text round-trip includes the written text
    } else {
        panic!("Unexpected field read-back shape: {raw}");
    }
```

This covers:
- `:textarea` custom field selected → ADF object read-back
- `Environment` system field selected → ADF object read-back
- `...:textfield` custom field selected (fallback if no ADF field on screen) → plain string

## M2: Single Story (Product Fix + E2E Together)

**Finding:** Story 1 (product fix) alone changes the E2E failure from a 400 to an assertion
failure (the test still panics, just differently). Splitting them means the E2E suite is
broken between Story 1 merge and Story 2 merge.

**Required:** Product fix and E2E assertion update ship in ONE story and ONE PR.
The "can parallelize: no" framing from v2 was correct; the consequence is they must be
IN THE SAME PR, not just sequenced.

## Scope Recommendation

- **Mode:** Feature Mode, full F1–F7 pipeline
- **Estimated new stories:** 1 (product fix + E2E assertion update, merged per M2)
- **Estimated effort:** **7 points (LOCKED)** — H2 confirmed; create-path parity requires no scope expansion; see breakdown below
- **Can parallelize:** N/A — single story
- **Release type:** MINOR (new BCs; spec 2.3.0 → 2.4.0)
- **Cycle:** cycle-012-field-adf-autoconvert (proposed; state-manager to formalize)

### M5: Revised Effort Estimate

| Item | Pts |
|------|-----|
| `is_adf_field` predicate + constants | 0.5 |
| `dispatch_field_value` ADF conversion branch (non-empty) | 1 |
| `resolve_against_editmeta` empty pre-check + clear-doc | 1 |
| `resolve_against_createmeta` empty-omit pre-check (H2 confirmed — no scope expansion) | 1 |
| Unit tests: ADF happy path (textarea, environment, description-via-field, customfield bypass) | 1.5 |
| Unit tests: regression pins (textfield, unknown string, empty-edit clear, empty-create omit) | 1.5 |
| E2E assertion update (adaptive, both branches) | 1 |
| VP drafting (2–3 VPs for F6) | 0.5 |
| **Total** | **~8 pts** |

**Locked at 7 pts.** H2 confirmed create-path parity; no fallback strategy needed. The range
(6–10) from the adversarial review is resolved: 7 pts reflects the full scope including the
create-path arm and the F4 `:textarea`-on-create confirmation AC (low cost; clean-skip allowed).

---

## Story Decomposition

### Story 1 (ONLY story): ADF auto-conversion + E2E assertion update (7 pts, LOCKED)

**Scope:** `src/cli/issue/field_resolve.rs` + `tests/e2e_live.rs` + `src/types/jira/editmeta.rs` (rustdoc only)

**H2 precondition: CLEARED.** Create-path parity confirmed by live probe. Full create-path arm is in scope.

**AC (sketch):**

*Core detection + non-empty conversion (both paths):*
- AC-1: `dispatch_field_value` with `schema.custom == "...:textarea"` and non-empty value sends `text_to_adf(value)` as wire value
- AC-2: `dispatch_field_value` with `schema.system == "environment"` and non-empty value sends `text_to_adf(value)`
- AC-3: `dispatch_field_value` with `schema.system == "description"` and non-empty value sends `text_to_adf(value)` (LOAD-BEARING per M3 — `--field description=VALUE` alone path)
- AC-4: `dispatch_field_value` with `schema.custom == "...:textfield"` sends `Value::String(value)` unchanged (regression pin)
- AC-5: `dispatch_field_value` with unknown `schema.field_type == "string"` and no ADF signal sends `Value::String(value)` unchanged (regression pin)
- AC-6: `customfield_NNNNN` literal-bypass for a `:textarea` field sends `text_to_adf(value)` (M4 — predicate fires because field_id lookup reaches the adapted schema)

*Empty-value guard (C1):*
- AC-7: `resolve_against_editmeta` with ADF-backed field and empty/whitespace value sets `fields[field_id] = {"type":"doc","version":1,"content":[]}` and skips `dispatch_field_value` (clear-doc, never routes empty through `text_to_adf`)
- AC-8: `resolve_against_createmeta` with ADF-backed field and empty/whitespace value OMITS `fields[field_id]` entirely (field absent from create body)
- AC-9: `dispatch_field_value`'s ADF branch is only reachable with a non-empty/non-whitespace value (guaranteed by the pre-checks in AC-7/8)

*`description` via `--field` alone (M3):*
- AC-10: `jr issue edit FOO-1 --field description="Hello"` (no `--description` flag) succeeds with ADF payload (not plain string)
- AC-11: `jr issue create --project X --summary "T" --field description="Hello"` (no `--description` flag) succeeds with ADF payload

*E2E assertions (M1 + M2):*
- AC-12: `test_e2e_issue_edit_custom_field` passes on the live Jira site with the adaptive read-back assertion (handles both ADF object and plain-string read-back)
- AC-13: create-path `:textarea` live confirmation (H2 low residual, F4 close): a live E2E `issue create --field <textarea-field>=VALUE` against an instance with a `:textarea` field configured succeeds (exits 0, ADF payload accepted); clean-skip if no `:textarea` field exists on the E2E instance, with a note that the `:textfield`-pattern + cross-endpoint parity inference remains the operative evidence

*Unchanged surface (regression):*
- AC-14: All existing `issue edit --field` and `issue create --field` tests for non-ADF fields pass unchanged
- AC-15: Hinted dispatch (`:option`, `:id`, `:name`, `:asset`) is UNAFFECTED (hinted path exits before the `field_type` match)

---

## Affected BCs (sketch; F2 will draft full text)

Next available: BC-3.4.033 (edit family), BC-3.3.013 (create family).
Current highest: BC-3.4.032, BC-3.3.012 (verified from spec).

| Proposed ID | Surface | Description |
|-------------|---------|-------------|
| BC-3.4.033 | `issue edit --field` | `:textarea` custom field non-empty → auto ADF |
| BC-3.4.034 | `issue edit --field` | `environment` system field non-empty → auto ADF |
| BC-3.4.035 | `issue edit --field` | `description` via `--field` alone (no `--description`) → auto ADF |
| BC-3.4.036 | `issue edit --field` | Empty/whitespace value for ADF field → clear with empty ADF doc; NOT a 400 |
| BC-3.4.037 | `issue edit --field` | `customfield_NNNNN` bypass for a `:textarea` field → auto ADF (M4 regression pin) |
| BC-3.3.013 | `issue create --field` | `:textarea` custom field non-empty → auto ADF (conditional on H2) |
| BC-3.3.014 | `issue create --field` | `description` via `--field` alone → auto ADF |
| BC-3.3.015 | `issue create --field` | Empty/whitespace ADF field → omit from request body |

*Total: ~8 new BCs. Exact numbering assigned in F2.*

---

## Proposed VPs (sketch; F2 will draft full text)

| Proposed ID | Module | Tool | Description |
|-------------|--------|------|-------------|
| VP-FIELD-ADF-001 | `field_resolve.rs::dispatch_field_value` | proptest | For any non-empty `EditMetaField` with `schema.custom == "...:textarea"`, wire value is `{"type":"doc",...}` (never `Value::String`) |
| VP-FIELD-ADF-002 | `field_resolve.rs::dispatch_field_value` | proptest | For any `EditMetaField` with `schema.custom == "...:textfield"`, wire value is `Value::String` (regression invariant) |
| VP-FIELD-ADF-003 | `field_resolve.rs` (route pre-checks) | unit | For any ADF-backed field with empty/whitespace value: edit-path produces empty ADF doc; create-path produces no `fields[field_id]` entry |

*Total: ~3 new VPs.*

---

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | MEDIUM-HIGH | `dispatch_field_value` is the shared dispatch core for both `issue edit --field` and `issue create --field`. The `is_adf_field` predicate must be strictly exclusive — any over-selection accidentally converts a plain-string field to ADF, producing a guaranteed 400 on that field. Full regression suite (unit + integration + E2E nightly) required. The empty-value pre-checks in `resolve_against_editmeta` and `resolve_against_createmeta` add two new early-exit branches, each of which must not fire on non-ADF fields. |
| Architecture | LOW | Three functions modified in one file; one new standalone helper. AC-008 (shared dispatch) is preserved: ADF conversion logic lives in `dispatch_field_value`, empty-value routing is in the two route-specific callers where context is available. No interface changes to any public API or calling code in `edit.rs`/`create.rs`. |
| Security | NONE | No new network calls, credentials, or deserialization surfaces. `text_to_adf` is already in production use for `--description`. |
| Performance | NONE | ADF detection is a struct field lookup on an already-deserialized value. `text_to_adf` is O(N) in text length; same order as the existing `--description` path. No additional HTTP calls. |
| Create-path detection (H2) | LOW residual | H2 CONFIRMED: system fields (`environment`, `description`) directly observed on both paths byte-for-byte. `:textarea` custom field on create is inferred (HIGH confidence) but not directly observed — AC-13 closes this in F4. No blocker; no scope change. |

## Regression Baseline

- **Total BC count:** 757 (unchanged until F2 adds ~8 new BCs)
- **Total E2E tests:** 107; 106/107 currently pass
- **Tests in regression risk zone:**
  - Unit tests covering `dispatch_field_value` `"string"/"text"` arm (all must continue to produce `Value::String` for non-ADF fields)
  - Integration tests for `issue edit --field` and `issue create --field` (full set)
  - `tests/e2e_live.rs::test_e2e_issue_edit_custom_field` (the failing target; fixed by this cycle)
- **E2E validation:** nightly live-Jira run (non-blocking CI); confirms the product fix on a real Jira instance

## Design Questions for Human Gate

### DQ-1: `--markdown` for `--field` ADF values?

**Recommended: Option A — `text_to_adf` only this cycle.** `--markdown` stays a `--description`
modifier. Users needing markdown in `environment`/`:textarea` fields file a follow-on.

### DQ-2: JSM create path (`jsm_create.rs`) — in or out of scope?

**Recommended: OUT OF SCOPE.** `jsm_create.rs` does not route through `dispatch_field_value`.
Record as a follow-on standing item.

### DQ-3 (H2): CLOSED ✓

Probe confirmed (`research/createmeta-schema-probe-2026-09-12.md`): createmeta populates
`schema.system` and `schema.custom` identically to editmeta. System fields (`environment`,
`description`) directly confirmed on both paths. `:textarea` custom-field suffix on create is
inferred at HIGH confidence; AC-13 in F4 closes the residual. No scope change. F2 may proceed.

---

## Fold-Into-F2 Notes (Non-Blocking)

### O5: Behavior change on `--field environment=X` (silent success vs loud 400)

Post-fix, `--field environment=X` flips from a loud 400 to a silent exit-0 write. Combined
with partial-name substring matching (if `env` resolves to `environment`), a typo like
`--field env=X` would silently write to `environment`. F2 should add a BC note about this
behavioral change (400 → exit-0) and note that it is the CORRECT behavior — the prior 400
was the defect. No product change required; documentation and CHANGELOG entry.

### O6: Dry-run `planned_preview` shape for ADF `--field` values

`dispatch_field_value` currently sets `outputs.planned_preview` to the raw user string for
`"string"` fields. After the fix, ADF-backed fields would set `planned_preview` to an ADF
JSON object (the `text_to_adf` output). Specify whether dry-run output shows the raw text
(more readable) or the ADF object (more accurate). Mirror how `--description` dry-run uses
`descriptionAdf` as a separate key (see `edit.rs` lines ~771–772). F2 should add a BC for
the dry-run preview shape of ADF `--field` values.

---

## Surviving Claims (Not Refuted by Adversarial Review)

These v2 claims were reviewed and are CORRECT; F2/F5 must not re-litigate them:

- **O1 (mentions asymmetry):** `text_to_adf` does not resolve `@mentions`; this is consistent
  with the design. `--field environment="@Alice"` will write the literal text, not a mention
  node. The mention-resolution path is gated on `--markdown` + `resolve_mentions` pre-pass;
  `--field` ADF conversion uses plain `text_to_adf`. Acceptable.
- **O2 (multi-line text):** `text_to_adf` handles multi-line text (INV-1 enforcement via
  `push_text`; `\n` normalizes to `hardBreak` in non-codeBlock context, per `adf.rs`).
  Multi-line `--field environment="line1\nline2"` is valid.
- **O3 (hint grammar):** The `:option`/`:id`/`:name`/`:asset` hint path exits `dispatch_field_value`
  BEFORE the `field_type` match. A user explicitly using a hint on an ADF field
  (e.g., `--field environment:id=VALUE`) takes the hinted path with no ADF conversion. This is
  documented behavior; the hint is the user's explicit override.
- **O4 (single-key guard):** The existing single-key guard on `issue edit --field` (C-1 guard,
  BC-3.4.0XX) is unchanged. ADF conversion does not affect the bulk vs single key routing.

---

## Open Questions

1. **DQ-1 (`--markdown` for `--field` ADF values):** Confirm Option A (plain text only, `text_to_adf`) is acceptable for this cycle. If Option B (markdown support, threads `--markdown` flag into dispatch) is also wanted now, story estimate increases by ~2 pts and `dispatch_field_value`'s signature changes.

2. **DQ-2 (JSM create path):** Confirm `jsm_create.rs` ADF conversion is OUT OF SCOPE for this cycle and recorded as a follow-on standing item.

3. **DQ-3 / H2: CLOSED ✓** Probe confirmed (`research/createmeta-schema-probe-2026-09-12.md`). Create-path parity confirmed for system fields; `:textarea` custom field on create is HIGH-confidence inference. F4 AC-13 closes the residual. No gate remaining on H2.

4. **DQ-4 (dry-run preview shape — O6):** For ADF-backed `--field` values in dry-run mode, should `planned_preview` show the raw user text (readable) or the ADF object (accurate)? Mirror `--description`'s `descriptionAdf` key approach? Needs a decision before F2 closes BC-3.4.036.

5. **DQ-5 (E2E create-path AC):** If H2 confirms create-path parity, a live create-path E2E AC (`jr issue create --field <textarea-field>=VALUE` succeeds) should be added to `tests/e2e_live.rs`. Confirm this is in scope for Story 1 or explicitly deferred.

## Proposed Cycle Identity

**Name:** `field-adf-autoconvert`
**Proposed number:** `cycle-012`
**Flag for state-manager:** Parked bundles occupy cycle-008 through cycle-011. `cycle-012`
is the next available number. State-manager must formalize when opening the cycle record.

---

## Full Pipeline

F1 (this + human gate) → F2 (spec: ~8 BCs, 3 VPs, 2.3.0→2.4.0; H2 closed, no probe dependency) →
F3 (1 story, adversarial review) → F4 (implement: field_resolve.rs + e2e_live.rs; TDD; PR) →
F5 (adversarial: focus on predicate over/under-selectivity + empty-guard paths) →
F6 (proptest VPs + mutation on `is_adf_field` + regression scan) →
F7 (5-dim convergence + E2E nightly confirmation) → MINOR release.
