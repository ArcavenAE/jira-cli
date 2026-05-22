---
document_type: adversarial-pass-report
issue: "#396"
pass: 4
date: "2026-05-22"
verdict: NOT-CLEAN
findings_count: 4
severities: "0 CRITICAL, 0 HIGH, 4 MEDIUM, 0 LOW"
observations_actioned: 1
observations_passed: 3
---

# Adversarial Pass 4 Report — Issue #396: `issue edit --field NAME=VALUE`

**Date**: 2026-05-22  
**Verdict**: NOT-CLEAN → RESOLVED  
**Findings**: 4 MEDIUM  
**Observations**: 4 (O-1: no action; O-2: actioned; O-3: no action; O-4: no action)

---

## Findings

### F-1 (MEDIUM — implementation-contract contradiction): `resolve_edit_fields` signature incompatible with `parse_field_kv` output

**Finding**: `parse_field_kv` (at `src/cli/issue/create.rs:1982-1997`) returns
`HashMap<String, String>` using last-wins `map.insert(key, value)`. Duplicate
`--field` keys are collapsed AT PARSE TIME. But the canonical `resolve_edit_fields`
signature in BC-3.4.015 had `field_pairs: &[(String, String)]` — an ordered,
duplicate-preserving slice. These are structurally incompatible. Additionally,
EC-3.4.017-10 incorrectly stated "the two entries are both added to the `fields`
JSON object; the second write-wins" — which never happens: `parse_field_kv` collapses
to `{"summary": "B"}` before `resolve_edit_fields` ever runs.

**Resolution**:

1. **BC-3.4.015 signature** (applied in prior burst): `field_pairs` parameter changed
   from `&[(String, String)]` to `&HashMap<String, String>` with explanatory note
   that `parse_field_kv` returns `HashMap<String, String>` and collapses duplicates
   AT PARSE TIME via `map.insert(key, value)` last-wins semantics.

2. **EC-3.4.017-10 rewritten**: removed the incorrect "two entries are both added to
   the `fields` JSON object; the second write-wins" language. Replaced with accurate
   mechanism: `parse_field_kv` collapses the duplicate key AT PARSE TIME via
   `map.insert(key, value)`; the HashMap retains only the LAST value ("B");
   `resolve_edit_fields` never sees both entries — it receives `{"summary": "B"}` as
   a single-entry HashMap. End state B-wins is correct; mechanism is parse-time
   collapse, not `resolve_edit_fields` write-wins.

3. **prd-delta §9 call site** updated: added clarifying note that `field_pairs` is
   `&HashMap<String, String>` (NOT `&[(String, String)]`), with reference to
   `parse_field_kv` last-wins semantics and EC-3.4.017-10.

**Files changed**:
- `.factory/specs/prd/bc-3-issue-write.md` — BC-3.4.015 signature, EC-3.4.017-10
- `.factory/phase-f2-spec-evolution/prd-delta-396.md` — §9 call-site note

---

### F-2 (MEDIUM — process-gap): VP test-strategy permanence not documented

**Finding**: The 12 VPs exist as full `### VP-` headings with detailed test strategy
ONLY in `verification-delta-396.md`. The BC bodies have one-line VP citations. It was
unclear whether the detailed strategies are meant to be permanent spec records or
transient F2/F3 artifacts — no explicit decision was recorded.

**Resolution**: Added explicit decision note to `verification-delta-396.md` Project
Convention Note section, immediately before the VP location mapping table:

> **VP permanence decision (F-2, 2026-05-22)**: The `### VP-NNN` headings with full
> test strategy detail in this file are intentionally a **transient F2/F3 working
> artifact** consumed by the test-writer in F4. They are NOT the permanent spec record.
> The permanent spec record for each VP is the one-line VP citation in the BC body's
> `**Verification Properties**` section. The test-writer uses the detailed strategies
> to author tests; once tests exist, the delta detail is superseded by the test file
> itself. No migration of `### VP-NNN` blocks to BC bodies is required or intended.

This implements the recommended option (a): BC-body one-liners are the canonical
long-term reference; verification-delta detail is an intentional transient artifact.

**Files changed**:
- `.factory/phase-f2-spec-evolution/verification-delta-396.md` — Project Convention Note

---

### F-3 (MEDIUM — EC ordering): EC-3.4.015-20 appeared before EC-3.4.015-19

**Finding**: In BC-3.4.015 Edge Cases, EC-3.4.015-20 ("`operations` lacks `set`")
appeared at approximately line 1202 BEFORE EC-3.4.015-19 ("Resolution failure under
`--dry-run`") at approximately line 1207. ECs within a BC must appear in numeric order.

**Resolution**: Swapped the two EC blocks so EC-3.4.015-19 now precedes EC-3.4.015-20.
Behavior is unchanged — only the presentation order was corrected to match the numeric
sequence (-18, -19, -20).

**Files changed**:
- `.factory/specs/prd/bc-3-issue-write.md` — EC-3.4.015-19 and EC-3.4.015-20 order

---

### F-4 (MEDIUM — type-dispatch semantic gap): No `option` arm in BC-3.4.015 Step 4

**Finding**: BC-3.4.015 Step 4 enumerated dispatch arms for `string`/`text`, `number`,
`date`/`datetime`, `user`, and `array`/`any`/unknown (exit 64), but had NO `option` arm.
The full type dispatch matrix for `resolve_edit_fields` was not visible in one place.

**Resolution** (applied in prior burst): Added explicit `option` arm to BC-3.4.015
Step 4:

```
- option: → dispatch to BC-3.4.016 Step 4a. Resolve VALUE against
  editmeta.fields[id].allowedValues (human label → option id); wire payload is
  {"id": "<optionId>"}. This arm must be handled BEFORE the unknown→exit-64 arm.
```

The `option` arm dispatch is now visible in the single-entry-point Step 4 table.
The note "This arm must be handled BEFORE the unknown→exit-64 arm" prevents future
implementers from accidentally catching `option` in the catch-all branch.

**Files changed**:
- `.factory/specs/prd/bc-3-issue-write.md` — BC-3.4.015 Step 4

---

## Observations

### O-1 (no action): `customfield_NNNNN` customId field in `EditMetaFieldSchema`

The `customId: 10176` in the editmeta JSON response example is not modeled in
`EditMetaFieldSchema`. Observation noted — not actioned. The `customId` is already
derivable by stripping `"customfield_"` from the key; adding it as a struct field
adds no resolution value for v1. Deferred to v2 if needed.

---

### O-2 (actioned): `AllowedValue.name` field parsed-but-unused; not justified in §5

**Finding**: The prd-delta §5 struct-field-usage block documented why
`EditMetaField.required/operations/system` are parsed but not used in v1, but
`AllowedValue.name` (also parsed, also unused in v1) had no justification.

**Resolution**: Added `AllowedValue.name` entry to prd-delta §5 struct-field-usage
block:

- `name` is a secondary label present on some Jira option types (e.g., cascade-select
  children) but not on standard single-select options.
- v1 resolution matches `AllowedValue.value` only.
- Retained because: (1) omitting it would cause `#[serde(deny_unknown_fields)]` panics;
  (2) future v2 option resolution may prefer `name` for some field families.
- Guidance on clippy suppression and comment text provided.

**Files changed**:
- `.factory/phase-f2-spec-evolution/prd-delta-396.md` — §5 AllowedValue.name entry

---

### O-3 (no action): process-gap (separate from F-2)

Noted. No product-owner action required.

---

### O-4 (no action)

Noted. No action.

---

## Resolution Summary

| Finding | Severity | Resolution |
|---------|----------|------------|
| F-1 | MEDIUM | EC-3.4.017-10 rewritten to state parse-time HashMap collapse via `parse_field_kv`; `resolve_edit_fields` never sees duplicates. prd-delta §9 call-site note updated to name `&HashMap<String, String>` type explicitly. BC-3.4.015 signature already updated in prior burst. |
| F-2 | MEDIUM | Explicit VP permanence decision added to verification-delta-396.md Project Convention Note: detail in this file is transient F2/F3 artifact; BC body one-liners are canonical permanent record. |
| F-3 | MEDIUM | EC-3.4.015-19 and EC-3.4.015-20 reordered to numeric sequence (-19 before -20). |
| F-4 | MEDIUM | `option` arm added to BC-3.4.015 Step 4 type dispatch (applied in prior burst). |
| O-2 | Observation | `AllowedValue.name` justification added to prd-delta §5 struct-field-usage block. |

**Final VP count**: 12 (VP-396-001 through VP-396-012) — unchanged.

**Guard script results**:
- `check-spec-counts.sh`: exit 0 — OK
- `check-bc-cumulative-counts.sh`: exit 0 — OK (583 total across 8 files; Surface H footer verified)
