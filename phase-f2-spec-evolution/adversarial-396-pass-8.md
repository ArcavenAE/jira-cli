---
document_type: adversarial-pass-report
issue: "#396"
pass: 8
date: "2026-05-22"
verdict: CLEAN (substantively) — 3 observations swept
findings_count: 0
severities: "0 CRITICAL, 0 HIGH, 0 MEDIUM, 0 LOW"
observations_actioned: 3
clean_pass_count: 2
---

# Adversarial Pass 8 Report — Issue #396: `issue edit --field NAME=VALUE`

**Date**: 2026-05-22  
**Verdict**: Substantively CLEAN (0 CRITICAL/HIGH/MEDIUM/LOW). 3 observations swept.  
**Clean pass count**: 2 of 3 required.

---

## Observations

### OBS-1 (serde rename gap — borderline-HIGH impact): `allowed_values` missing `#[serde(rename = "allowedValues")]`

**Finding**: `prd-delta-396.md §5` showed the `EditMetaField` struct with
`allowed_values: Option<Vec<AllowedValue>>` but NO `#[serde(rename = "allowedValues")]`
attribute. The Jira editmeta API returns this key as `"allowedValues"` (camelCase).
Without the rename, serde deserializes `allowed_values` to `None` for every option
field — BC-3.4.016 would fail at runtime with EC-3.4.016-3 ("field has no configured
option values") for every valid single-select field, even when `allowedValues` is
populated. This is a runtime silent failure, not a compile error.

The rest of the struct was audited:
- `EditMetaField.name/schema/operations/required` — all match JSON keys exactly.
- `EditMetaFieldSchema.field_type` — already carries `#[serde(rename = "type")]`.
- `EditMetaFieldSchema.system/custom` — match exactly.
- `AllowedValue.id/value/name` — all match exactly.

**Resolution**: Added `#[serde(rename = "allowedValues")]` to the `allowed_values` field
in the prd-delta §5 struct block. Added a "Serde rename audit" note block below the
struct confirming the audit findings — the block is copy-paste-correct for the implementer.

**Files changed**:
- `.factory/phase-f2-spec-evolution/prd-delta-396.md` — §5 struct block

---

### OBS-2 (tautological VP sub-assertion): VP-396-011 datetime step 4 proved nothing

**Finding**: `verification-delta-396.md` VP-396-011 datetime sub-case step 4 read:
"(Optional robustness check): run with `"not-a-date"` — assert exit code 0 (client-side
validation is deliberately absent; server validates)."
The PUT mock in that sub-case returns 204 unconditionally. Asserting exit code 0 after a
204 mock is a tautology — it tests only that the mock returns what it was told, not
that the implementation transmits the value without modification. A client that
transformed `"not-a-date"` to `""` or rejected it client-side before the PUT would
still hit exit 0 if the mock didn't check the body.

**Resolution**: Rewrote step 4 as a positive, non-tautological assertion: mount a
separate PUT mock with a body match requiring `{"fields": {"customfield_10070": "not-a-date"}}`
(exact junk string verbatim). Assert PUT mock was matched. Assert exit code 0. This
tests that the value was transmitted byte-for-byte — if the implementation were to
transform or reject the value client-side, the body-match mock would not be reached
and the test would fail, catching the regression.

**Files changed**:
- `.factory/phase-f2-spec-evolution/verification-delta-396.md` — VP-396-011 datetime step 4

---

### OBS-3 (`find_field_by_name` signature mis-anchor): BC-3.4.015 Trace cited a helper with wrong return type

**Finding**: `bc-3-issue-write.md:1257` Trace cited
`src/api/jira/fields.rs::find_field_by_name` as a new function. The resolution
algorithm (Step 2b) requires exact-match-then-substring with the ability to surface
multiple candidates (EC-3.4.015-2: multiple matches → exit 64 naming candidates).
`Option<Field>` — the implied return type of a `find_field_by_name` helper — cannot
represent the ambiguous-match case. Any implementer reading the Trace as a design
signal would build a helper with the wrong shape, then need to refactor when
implementing EC-3.4.015-2.

**Resolution** (option a — recommended): Dropped `find_field_by_name` from the
BC-3.4.015 Trace entirely. `resolve_edit_fields` is the spec-anchored orchestrator
that owns the exact-match-then-substring logic and all exit-64 ambiguity handling.
Any field-lookup helper it calls internally is an implementation detail of
`resolve_edit_fields` — it need not be named in the BC Trace, which is a spec
artifact. Trace now reads: `src/cli/issue/helpers.rs::resolve_edit_fields (new,
orchestrates resolution pipeline — owns exact-match-then-substring logic and all
exit-64 ambiguity handling; any field-lookup helper it calls is an implementation
detail not spec-anchored here)`.

**Files changed**:
- `.factory/specs/prd/bc-3-issue-write.md` — BC-3.4.015 Trace

---

## Resolution Summary

| Observation | Impact | Resolution |
|-------------|--------|------------|
| OBS-1 | Borderline-HIGH (runtime silent failure on all option fields) | `#[serde(rename = "allowedValues")]` added to `allowed_values`; full struct audited; serde rename audit note added. |
| OBS-2 | Low (tautological test) | VP-396-011 datetime step 4 rewritten — now asserts junk value appears byte-for-byte in PUT body, not just exit code. |
| OBS-3 | Medium (wrong Trace anchor misleads implementer) | `find_field_by_name` dropped from BC-3.4.015 Trace; `resolve_edit_fields` clarified as the spec-anchored orchestrator that owns ambiguity handling. |

**VP count**: 12 — unchanged. **Total BCs**: 583 — unchanged.

**Guard scripts**:
- `check-spec-counts.sh`: exit 0
- `check-bc-cumulative-counts.sh`: exit 0 (583 total across 8 files; Surface H verified)
