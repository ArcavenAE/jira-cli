---
document_type: dependency-graph
level: ops
version: "1.0"
status: active
producer: story-writer
timestamp: "2026-09-13T00:00:00"
cycle: cycle-012-field-adf-autoconvert
inputs:
  - ".factory/cycles/cycle-012/phase-f3-stories/S-cycle12-platform-adf-autoconvert.md"
  - ".factory/cycles/cycle-012/phase-f3-stories/S-cycle12-jsm-adf-autoconvert.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/phase-f2-spec-evolution/cycle-012-verification-delta.md"
input-hash: "50014be"
---

# cycle-012 Dependency Graph

## Node Inventory

| Story | Title | Points | Wave | Status | BCs | VPs |
|-------|-------|--------|------|--------|-----|-----|
| S-cycle12-platform-adf-autoconvert | Platform ADF auto-conversion (edit + create paths) | 13 | 1 | draft | BC-3.3.013/014/015/BC-3.4.033/034/035/036/037 | VP-FIELD-ADF-001/002/003/004 |
| S-cycle12-jsm-adf-autoconvert | JSM ADF auto-conversion (create path) | 13 | 2 | draft | BC-3.8.019/020/021/022 | VP-FIELD-ADF-001/003/004 |

**Total cycle-012 story points:** 26

## Adjacency List

```
S-cycle12-platform-adf-autoconvert → S-cycle12-jsm-adf-autoconvert
```

**Reason:** Story 2 (`jsm_create.rs` resolution layer) calls `is_adf_field_value` from
`field_resolve.rs`, which is defined and first implemented in Story 1. Story 2 cannot
be implemented until this function exists at `pub(crate)` visibility.

## Blocks Consistency Check

| Story | `depends_on` | `blocks` | Consistent? |
|-------|-------------|---------|-------------|
| S-cycle12-platform-adf-autoconvert | [] | [S-cycle12-jsm-adf-autoconvert] | Yes — Story 2's `depends_on` contains Story 1 |
| S-cycle12-jsm-adf-autoconvert | [S-cycle12-platform-adf-autoconvert] | [] | Yes — Story 1's `blocks` contains Story 2 |

## Topological Sort (Cycle-Freedom Proof)

Adjacency list (directed edges = "must-complete-before"):

```
[1] S-cycle12-platform-adf-autoconvert
         |
         v
[2] S-cycle12-jsm-adf-autoconvert
```

**DFS traversal (Kahn's algorithm):**
- Initial in-degree: Story 1 = 0, Story 2 = 1
- Enqueue Story 1 (in-degree 0) → Process → reduce Story 2's in-degree to 0 → Enqueue Story 2
- Result: [Story 1, Story 2] — complete topological order, no cycle.

**Dependency graph is ACYCLIC.** A reverse edge `S-cycle12-jsm-adf-autoconvert → S-cycle12-platform-adf-autoconvert` does not exist and MUST NOT be added.

## BC Clause Coverage Matrix

| BC | Clause | Type | Covering AC | Story |
|----|--------|------|-------------|-------|
| BC-3.3.013 | Detection: `:textarea` custom field → `text_to_adf` on create path | postcondition | AC-002, AC-012 | S-cycle12-platform-adf-autoconvert |
| BC-3.3.013 | Create-path echo: `(adf)` marker | postcondition | AC-012 | S-cycle12-platform-adf-autoconvert |
| BC-3.3.014 | Detection: `system == "description"` / `system == "environment"` on create path | precondition | AC-001, AC-002 | S-cycle12-platform-adf-autoconvert |
| BC-3.3.014 | EC-3.3.014-5: `--markdown + --field description=VALUE` exits 64 (NET-NEW) | edge-case | AC-006 | S-cycle12-platform-adf-autoconvert |
| BC-3.3.013 | Createmeta fidelity: `custom` (`":textarea"`) preserved → `is_adf_field` fires on create path (lossy `None`→`""` deserialization kills) | precondition | AC-013(a), AC-002 | S-cycle12-platform-adf-autoconvert |
| BC-3.3.014 | Createmeta fidelity: `system` (`"description"`/`"environment"`) preserved → `is_adf_field` fires on create path (lossy `None`→`""` deserialization kills) | precondition | AC-013(a), AC-002 | S-cycle12-platform-adf-autoconvert |
| BC-3.3.015 | Platform create: empty ADF-backed field → OMIT from POST | postcondition | AC-004, AC-005 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.033 | `dispatch_field_value` ADF branch fires for `:textarea` | postcondition | AC-002 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.033 | Dry-run `planned_preview` = ADF object (not display string) | postcondition | AC-008 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.033 | Table shows `(adf)` from `field_markers` | postcondition | AC-003, AC-009, AC-010 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.033 | Live echo: JSON channel carries raw user-supplied input string (not ADF object; #398 invariant) | postcondition | AC-010 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.034 | Detection via `schema.system == "environment"`; non-empty → `text_to_adf`; behavior flip 400→exit-0 | postcondition | AC-001, AC-002 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.034 | Combined CHANGELOG entry: all 400→exit-0 flips + empty-value clear/omit + assembly-order | item 4 | AC-015 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.035 | `--field description=VALUE` via `--field`-alone M3 path succeeds | postcondition | AC-002, AC-011 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.035 | EC-3.4.035-3: `--markdown + --field description=VALUE` exits 64 with correct message | edge-case | AC-007 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.036 | Edit empty → clear-doc `{"type":"doc","version":1,"content":[]}` | postcondition | AC-004 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.036 | Dry-run TABLE `(adf-clear)` from `field_markers` | postcondition | AC-009 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.036 | Dry-run JSON `planned_preview` = clear-doc (not display string; not absent) | postcondition | AC-008(b) | S-cycle12-platform-adf-autoconvert |
| BC-3.4.036 | Live echo: JSON channel carries raw empty/whitespace input; TABLE shows `(adf-clear)` (#398 invariant) | postcondition | AC-010 | S-cycle12-platform-adf-autoconvert |
| BC-3.4.037 | `customfield_NNNNN` bypass form still fires `is_adf_field` | postcondition | AC-002 | S-cycle12-platform-adf-autoconvert |
| BC-3.8.019 | `description`/`environment` system fields detected on JSM path via `jira_schema.system` | precondition | AC-002, AC-004 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.019 | Non-empty → ADF object in `requestFieldValues`; `isAdfRequest` accumulated | postcondition | AC-004 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.019 | EC-3.8.019-2: fail-open on metadata fetch failure | edge-case | AC-003, AC-008 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.019 | Assembly-order: `self.description` supersedes `--field description=` extra-field entry in `build()` (EC-3.8.019-4, Checkbox B) | postcondition | AC-006 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.020 | `:textarea` custom fields detected on JSM path via `jira_schema.custom` | postcondition | AC-004 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.020 | `isAdfRequest` ABSENT (not `false`) when no ADF conversion | postcondition | AC-004, AC-010 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.021 | Empty ADF-backed JSM extra field → OMIT from `requestFieldValues` | postcondition | AC-007 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.021 | `isAdfRequest` NOT accumulated for omitted field | postcondition | AC-007 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.021 | EC-3.8.021-3: empty guard not reached under fail-open | edge-case | AC-008 | S-cycle12-jsm-adf-autoconvert |
| BC-3.8.022 | `isAdfRequest: true` accumulated and in POST body when ANY extra field is ADF-converted | postcondition | AC-004 | S-cycle12-jsm-adf-autoconvert |

## VP-to-Stories Matrix

| VP | Stories Exercising It | Axes / Notes |
|----|----------------------|-------------|
| VP-FIELD-ADF-001 | S-cycle12-platform-adf-autoconvert | Proptest + example-based; `is_adf_schema` allowlist; risk-symmetric predicate |
| VP-FIELD-ADF-001 | S-cycle12-jsm-adf-autoconvert | AC-002 uses `is_adf_field_value` (shared predicate from VP-001); no new VP-001 tests in Story 2 |
| VP-FIELD-ADF-002 | S-cycle12-platform-adf-autoconvert | All axes: dry-run JSON, dry-run TABLE, live echo, create-path echo |
| VP-FIELD-ADF-003 | S-cycle12-platform-adf-autoconvert | Axes A/B/D-platform/E/F/G/H |
| VP-FIELD-ADF-003 | S-cycle12-jsm-adf-autoconvert | Axis C (JSM empty-omit); Axis D JSM sub-case |
| VP-FIELD-ADF-004 | S-cycle12-platform-adf-autoconvert | Axes h1/h2 ONLY (platform-path uniform-exit-64 guards; NET-NEW create guard AC-006 + edit guard-extension AC-007) |
| VP-FIELD-ADF-004 | S-cycle12-jsm-adf-autoconvert | Axes (a)-(g); h1/h2 owned by Story 1 (see row above) |
| _VP-578-015_ | _S-cycle12-jsm-adf-autoconvert_ | _regression (scope narrowed per delta §7 carve-out; audited in AC-010/AC-011) — NOT a cycle-012-owned VP_ |

## NFR-to-Stories Matrix

No P0/P1 NFRs specific to this cycle's ADF autoconvert feature are registered in
`prd-supplements/nfr-catalog.md` as new. The existing NFR for field resolution
(NFR-O-L: correctness of `issue edit --field`) is implicitly extended to cover the
new ADF conversion paths.

| NFR | Stories Implementing It | Validation Method |
|-----|------------------------|-------------------|
| NFR-O-L (implied) | S-cycle12-platform-adf-autoconvert | Unit + wiremock + proptest |
| NFR-O-L (implied) | S-cycle12-jsm-adf-autoconvert | Unit + wiremock |

## Edge Case Coverage Matrix

| Source | EC/Error ID | Description | Story | AC/EC Reference |
|--------|-------------|-------------|-------|----------------|
| BC-3.3.014 | EC-3.3.014-5 | `--markdown + --field description=VALUE` on create path → exit 64 | S-cycle12-platform-adf-autoconvert | AC-006 |
| BC-3.4.035 | EC-3.4.035-3 | `--markdown + --field description=VALUE` on edit path → exit 64, correct message | S-cycle12-platform-adf-autoconvert | AC-007 |
| BC-3.8.019 | EC-3.8.019-2 | RT-fields fetch failure → fail-open: single warning + plain-string fallback | S-cycle12-jsm-adf-autoconvert | AC-003, AC-008 |
| BC-3.8.019 | EC-3.8.019-4 | `build()` assembly-order: `self.description` supersedes `--field description=` extra-field entry (VP-FIELD-ADF-004 Axis g, Checkbox B) | S-cycle12-jsm-adf-autoconvert | AC-006 |
| BC-3.8.020 | EC-3.8.020-5 | `:textarea` JSM fail-open (paired with EC-3.8.019-2): fetch failure degrades `:textarea`-backed bare fields to `Value::String`; functionally covered by AC-008 uniform fail-open | S-cycle12-jsm-adf-autoconvert | AC-008 |
| BC-3.8.021 | EC-3.8.021-3 | Empty guard not reached under fail-open (empty bare value → `Value::String("")`, present) | S-cycle12-jsm-adf-autoconvert | AC-008 |
| BC-3.4.033 | JRACLOUD-79318 | Empty-text-node 400: `text_to_adf("")` produces empty text node; empty pre-check must fire BEFORE `text_to_adf` | S-cycle12-platform-adf-autoconvert | AC-004 |
| BC-3.8.021 | JRACLOUD-79318 (JSM) | Same as above for JSM path; empty bare ADF field omitted (not sent to `text_to_adf`) | S-cycle12-jsm-adf-autoconvert | AC-007 |

## Gap Register

| Gap ID | Level | Source | Clause/Item | Justification | Resolution Target |
|--------|-------|--------|-------------|---------------|-------------------|
| GAP-C12-001 | L2 | EC-3.8.019-2 (accepted residual) | Documentation-only behavioral edge: an ADF-backed `field_id` is present on the Jira instance but is absent from a _successfully-fetched_ (partially-returning) RT metadata response → the plain-string write to `requestFieldValues` may yield a server 400 that is indistinguishable from an ordinary unknown-field 400, with no `jr` diagnostic or warning (delta §5 item 6 L-2 note). | Accepted residual. VP-FIELD-ADF-004 Axis (f) itself (fetch succeeded, NAME not in returned list → string-wrap, no warning, `isAdfRequest` unchanged — the I-1 regression pin) IS authored THIS cycle at F4 Story 2 (DQ-6-gated alongside Axes (b)–(e)). The ONLY accepted residual is the edge where the RT metadata response omits an ADF-backed field_id — low probability per live probe (delta §5 item 6: "the live probe confirmed field_id == 'description' was present in the test-instance RT field list"). No test is required or possible for this edge without a partially-returning stub. | documentation-only, no test |
| GAP-C12-002 | L3 | BC-3.8.017 | JSM `--request-type` path: `--markdown + --field description=VALUE` guard status at F4. | The JSM guard is ALREADY IMPLEMENTED AND TESTED: BC-3.8.017 mandates uniform exit-64 for `--markdown + --field description=VALUE` on the JSM create path; the pre-existing test `tests/issue_create_jsm.rs::test_jsm_create_markdown_field_description_conflict_exits_64` pins this behavior (delta §5 item 18 + delta line ~1135 confirm the guard exists). NO Story 2 implementation work is required for this guard. | already covered — verify no regression only |

## Wave Dependency Diagram

```
Wave 1 (starts immediately):
  ┌──────────────────────────────────────────────────────────────────┐
  │ S-cycle12-platform-adf-autoconvert (13 pts)                      │
  │ Implements: is_adf_schema / is_adf_field / is_adf_field_value    │
  │             field_markers, dispatch_field_value ADF branch       │
  │             empty-clear/omit guards, step 2c and extended guards │
  └──────────────────────────────────────────────────────────────────┘
                               │
                               │ provides: is_adf_field_value (pub(crate))
                               │
                               ▼
Wave 2 (after Wave 1 merges):
  ┌──────────────────────────────────────────────────────────────────┐
  │ S-cycle12-jsm-adf-autoconvert (13 pts)                           │
  │ Implements: jsm_create.rs resolution layer ADF detection         │
  │             build() assembly-order fix                           │
  │             DQ-6 type/signature decision + VP-004 tests          │
  └──────────────────────────────────────────────────────────────────┘
```
