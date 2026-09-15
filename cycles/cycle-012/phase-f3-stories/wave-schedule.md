---
document_type: wave-schedule
level: ops
version: "1.0"
status: active
producer: story-writer
timestamp: "2026-09-13T00:00:00"
cycle: cycle-012-field-adf-autoconvert
inputs:
  - ".factory/cycles/cycle-012/phase-f3-stories/dependency-graph.md"
  - ".factory/cycles/cycle-012/phase-f3-stories/STORY-INDEX.md"
input-hash: "5fe181c"
phase: F3
traces_to: ".factory/cycles/cycle-012/phase-f3-stories/STORY-INDEX.md"
---

# cycle-012 Wave Schedule

## Wave Summary

| Wave | Stories | Points | Can Start? | Unblocked By |
|------|---------|--------|-----------|-------------|
| Wave 1 | S-cycle12-platform-adf-autoconvert | 13 | Immediately | N/A (no dependencies) |
| Wave 2 | S-cycle12-jsm-adf-autoconvert | 13 | After Wave 1 merges | Story 1 provides `is_adf_field_value (pub(crate))` |

## Wave Plan

### Wave 1 (no dependencies)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-cycle12-platform-adf-autoconvert | 13 | XL | 1 story/agent |

### Wave 2 (depends on Wave 1)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-cycle12-jsm-adf-autoconvert | 13 | XL | 1 story/agent |

## Wave 1

**Start condition:** Immediately — no dependencies.

### S-cycle12-platform-adf-autoconvert (13 pts)

Files modified in Wave 1:

| File | Change Type |
|------|-------------|
| `src/cli/issue/field_resolve.rs` | ADD: `is_adf_schema`, `is_adf_field`, `is_adf_field_value`; ADF branch in `dispatch_field_value`; empty-clear/omit pre-checks; `field_markers` in `FieldResolutionOutputs` |
| `src/cli/issue/edit.rs` | MODIFY: extended `--markdown + --field description=` guard (AC-007); table-emit loop reads `field_markers` first |
| `src/cli/issue/create.rs` | MODIFY: NET-NEW step 2c guard `--markdown + --field description=` (AC-006); create-path table-emit reads `field_markers` |
| `src/types/jira/editmeta.rs` | VERIFY: `EditMetaFieldSchema.system`/`.custom` are `Option<String>` (None not "") |
| `tests/issue_edit_field.rs` | ADD/MODIFY: VP-FIELD-ADF-001/002/003 platform-path tests |
| `tests/issue_create*.rs` | ADD/MODIFY: VP-FIELD-ADF-002/003 create-path + createmeta fidelity tests |
| `CHANGELOG.md` | ADD: combined `### Fixed` entry under [Unreleased] |

**Wave 1 merge gate:** All non-E2E `cargo test` pass; `cargo clippy -- -D warnings` clean;
VP-FIELD-ADF-001 proptest GREEN; VP-FIELD-ADF-002 all axes GREEN;
VP-FIELD-ADF-003 Axes A/B/D-platform/E/F/G/H GREEN;
AC-006 (NET-NEW create guard) GREEN; AC-007 (extended edit guard) GREEN.

## Wave 2

**Start condition:** Wave 1 (S-cycle12-platform-adf-autoconvert) must be merged to
`develop`. `is_adf_field_value` must be available at `pub(crate)` visibility.

### S-cycle12-jsm-adf-autoconvert (13 pts)

Files modified in Wave 2:

| File | Change Type |
|------|-------------|
| `src/cli/issue/jsm_create.rs` | MODIFY: ADF detection/conversion loop; `isAdfRequest` accumulation; empty-omit guard; `get_request_type_fields` call with fail-open |
| `src/api/jsm/requests.rs` | MODIFY: `build()` assembly-order fix — move `description` insert to AFTER extra-fields loop; ABSENT-check strictness fix in proptest at ~lines 335–338 (`.unwrap_or(false)` → `.is_none()`) |
| `src/cli/issue/field_resolve.rs` | VERIFY ONLY: `is_adf_field_value` at `pub(crate)` (from Wave 1) |
| `tests/issue_create_jsm.rs` | ADD/MODIFY: VP-FIELD-ADF-004 all axes; VP-FIELD-ADF-003 Axis C; VP-578-015 bare-form stub additions; ABSENT-check strictness fix in `test_jsm_create_plain_description_absent_when_no_description_flag` ~lines 823–831 |
| `tests/e2e_live.rs` | MODIFY: AC-016 JSM ADF live-E2E test — `test_e2e_jsm_create_adf_field_description_roundtrip` gated on `JR_RUN_E2E` + `JR_E2E_JSM_PROJECT` |
| `CHANGELOG.md` | VERIFY: Story 1 entry already covers JSM create; extend minimally if not |

**Wave 2 merge gate:**
- **Checkbox A (OBS-1):** VP-FIELD-ADF-004 axes (a)-(f) authored/GREEN; VP-FIELD-ADF-003 Axis D JSM sub-case GREEN; Axis (e) M-1 sub-assertion confirmed.
- **Checkbox B (item 5a):** `build()` assembly-order source reorder applied in `src/api/jsm/requests.rs` AND `test_bc_3_8_019_build_description_supersedes_extra_field_description_entry` GREEN.
- Both checkboxes independently ticked by the gate reviewer — Checkbox B is NOT satisfied by Checkbox A alone.

## File Overlap Notes

**Wave 1 / Wave 2 file overlap — SAFE (sequential not parallel):**

`src/cli/issue/field_resolve.rs` is modified in Wave 1 (adding `is_adf_field_value`)
and referenced in Wave 2 (via `field_resolve::is_adf_field_value`). Since Wave 2
begins only after Wave 1 merges, there is no concurrent modification conflict.

`CHANGELOG.md` is modified in Wave 1 (combined entry added) and verified in Wave 2
(no duplicate entry). Sequential order ensures the entry exists before Wave 2's
verify step.

**No parallel Wave is possible for this cycle** — the two stories have a hard
compile-time dependency (Wave 2's `jsm_create.rs` must call a function that Wave 1's
`field_resolve.rs` defines). Parallelizing would require a stub that exposes the
`pub(crate)` signature first, which is not worth the overhead for a 2-story cycle.

## Pipeline Overlap Plan

| Parallel Activity | When |
|------------------|------|
| Wave 2 stubs (`jsm_create.rs` scaffold) | Cannot start — hard compile-time dependency on `is_adf_field_value (pub(crate))` from Wave 1; no meaningful stub is possible before Wave 1 merges |
| Wave 2 tests | Cannot start until Wave 1 merges (same hard dependency) |
| Wave 2 implementation | Start after Wave 1 merged and Wave 2 Red Gate verified |

No intra-wave parallelism: one story per wave. This cycle executes strictly sequentially.

## Total Cycle Timeline

| Phase | Duration (estimate) | Notes |
|-------|---------------------|-------|
| Wave 1 F4 (implement + test) | 4-5 days | 13 pts; platform edit + create + proptest |
| Wave 1 PR review + merge | 1-2 days | includes adversarial review pass |
| Wave 2 F4 (implement + test) | 5-6 days | 13 pts; DQ-6 decision gates axes (b)-(f) |
| Wave 2 PR review + merge | 1-2 days | includes OBS-1 gate verification |
| **Total** | **~11-15 days** | Sequential; no parallel wave possible |

## Critical Path

S-cycle12-platform-adf-autoconvert (13 pts) → S-cycle12-jsm-adf-autoconvert (13 pts)

**Total critical-path length: 26 pts** (~11–15 days; see Total Cycle Timeline above). Both stories are on the critical path — there is no off-path work in this cycle. No parallelism is possible due to the hard compile-time dependency on `is_adf_field_value (pub(crate))` defined in Story 1 and consumed in Story 2.
