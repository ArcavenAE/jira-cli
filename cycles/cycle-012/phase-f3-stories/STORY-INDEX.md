---
document_type: story-index
level: ops
version: "1.0"
status: active
producer: story-writer
timestamp: "2026-09-13T00:00:00"
cycle: cycle-012-field-adf-autoconvert
total_stories: 2
total_points: 26
inputs:
  - ".factory/cycles/cycle-012/phase-f3-stories/S-cycle12-platform-adf-autoconvert.md"
  - ".factory/cycles/cycle-012/phase-f3-stories/S-cycle12-jsm-adf-autoconvert.md"
input-hash: "1b2bec7"
---

# cycle-012 Story Index

## Summary

| Metric | Value |
|--------|-------|
| Total stories | 2 |
| Total story points | 26 |
| Waves | 2 |
| Priority | P0 (all stories) |
| Feature mode | Brownfield incremental |

## Story List

| Story ID | Title | Points | Wave | Status | BCs | Priority |
|----------|-------|--------|------|--------|-----|----------|
| S-cycle12-platform-adf-autoconvert | Platform ADF auto-conversion for `--field` on rich-text fields (edit + create paths) | 13 | 1 | draft | BC-3.3.013/014/015, BC-3.4.033/034/035/036/037 | P0 |
| S-cycle12-jsm-adf-autoconvert | JSM ADF auto-conversion for `--field` on rich-text fields (JSM create path) | 13 | 2 | draft | BC-3.8.019/020/021/022 | P0 |

## Dependency Summary

```
Wave 1: S-cycle12-platform-adf-autoconvert (13 pts, no dependencies)
             |
             ↓
Wave 2: S-cycle12-jsm-adf-autoconvert (13 pts, depends on Wave 1)
```

Dependency graph is ACYCLIC. See `dependency-graph.md` for full proof.

## BC Coverage

All 12 new cycle-012 BCs are covered:

| BC Group | BCs | Story |
|----------|-----|-------|
| Platform create | BC-3.3.013, BC-3.3.014, BC-3.3.015 | S-cycle12-platform-adf-autoconvert |
| Platform edit | BC-3.4.033, BC-3.4.034, BC-3.4.035, BC-3.4.036, BC-3.4.037 | S-cycle12-platform-adf-autoconvert |
| JSM create | BC-3.8.019, BC-3.8.020, BC-3.8.021, BC-3.8.022 | S-cycle12-jsm-adf-autoconvert |

## VP Coverage

| VP | Story |
|----|-------|
| VP-FIELD-ADF-001 | S-cycle12-platform-adf-autoconvert (proptest + example-based), S-cycle12-jsm-adf-autoconvert (shared predicate via `is_adf_field_value`; no new VP-001 tests authored in Story 2) |
| VP-FIELD-ADF-002 | S-cycle12-platform-adf-autoconvert (all axes: dry-run JSON/TABLE, live echo, create-path echo) |
| VP-FIELD-ADF-003 | S-cycle12-platform-adf-autoconvert (Axes A/B/D-platform/E/F/G/H), S-cycle12-jsm-adf-autoconvert (Axis C, Axis D JSM) |
| VP-FIELD-ADF-004 | S-cycle12-platform-adf-autoconvert (Axes h1/h2: platform-path exit-64 guards AC-006/AC-007), S-cycle12-jsm-adf-autoconvert (Axes a-g) |

## F4 Gate Summary

**Story 1 gate (Checkbox A + B not applicable — Story 1 has no OBS-1):**
- VP-FIELD-ADF-001 proptest passing GREEN
- VP-FIELD-ADF-002 all axes GREEN
- VP-FIELD-ADF-003 Axes A/B/D-platform/E/F/G/H GREEN
- AC-006 (NET-NEW step 2c guard) GREEN (was RED pre-implementation)
- AC-007 (extended edit guard) GREEN (was RED pre-implementation)
- CHANGELOG combined entry added

**Story 2 gate (requires Story 1 merged first):**
- Checkbox A (OBS-1): VP-FIELD-ADF-004 axes (a)-(f) authored/GREEN; VP-FIELD-ADF-003 Axis D JSM sub-case GREEN; Axis (e) M-1 sub-assertion confirmed (all 6 OBS-1 items)
- Checkbox B (item 5a): `build()` assembly-order source reorder applied + Axis (g) GREEN
- BOTH checkboxes independently ticked by gate reviewer
