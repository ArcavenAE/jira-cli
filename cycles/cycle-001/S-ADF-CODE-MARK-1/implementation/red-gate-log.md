---
document_type: red-gate-log
level: ops
version: "1.0"
status: complete
producer: test-writer
timestamp: "2026-07-07T00:00:00"
phase: 3
inputs:
  - ".factory/stories/S-ADF-CODE-MARK-1.md"
  - ".factory/specs/prd/bc-7-output-render.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-571.md"
input-hash: "429c68d"
traces_to: "BC-7.2.015"
test_writer_agent: "claude-sonnet-4-6"
red_gate_verified: true
---

# Red Gate Log: S-ADF-CODE-MARK-1 — ADF code-mark exclusivity

## Summary

| Story | Tests Written | All Fail (Red)? | Gate |
|-------|---------------|-----------------|------|
| S-ADF-CODE-MARK-1 | 10 (8 new anchors + 1 rewrite + 2 GREEN retention anchors) | 8 RED (expected), 2 GREEN (expected) | PASSED |

## Tests Written

### S-ADF-CODE-MARK-1 — BC-7.2.015 anchor matrix

| Test Name | AC | BC Anchor | Pre-fix Status |
|-----------|-----|-----------|----------------|
| `assert_marks_eq` helper | AC-001 | BC-7.2.015 precondition | helper (no pre-fix status) |
| `assert_link_mark_with_href` helper | AC-001 | BC-7.2.015 precondition | helper (no pre-fix status) |
| `test_markdown_inline_code_mark_and_composition` (assertion rewritten) | AC-002 | BC-7.2.015 EC-1 / BC-7.2.007 EC-2 | RED |
| `test_bc_7_2_015_plain_code_baseline` | AC-003 | CONTROL | GREEN (retention anchor) |
| `test_bc_7_2_015_strong_stripped_from_code_node` | AC-003 | EC-1 | RED |
| `test_bc_7_2_015_em_stripped_from_code_node` | AC-004 | EC-2 | RED (CONFIRMED-INPUT) |
| `test_bc_7_2_015_strike_stripped_from_code_node` | AC-004 | EC-3 | RED (CONFIRMED-INPUT) |
| `test_bc_7_2_015_subsup_stripped_from_code_node` | AC-004 | EC-4 | RED (CONFIRMED-INPUT) |
| `test_bc_7_2_015_link_preserved_on_code_node` | AC-005 | EC-5 | GREEN (retention anchor) |
| `test_bc_7_2_015_mixed_range_surrounding_marks_retained` | AC-006 | EC-6 | RED (code node) |
| `test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped` | AC-006 | VP-571-003 | RED (code node) |
| `test_bc_7_2_015_alert_wrapper_strong_code_stripped` | AC-007 | PANEL-ANCHOR | RED (CONFIRMED-INPUT) |

## Red Gate Pre-fix Evidence

Command run: `cargo test --lib -- test_bc_7_2_015_ test_markdown_inline_code_mark_and_composition`

Branch state: `fix/571-adf-code-mark-exclusivity` — NO `push_code` filter applied.

### Actual emitted marks per anchor (pre-fix)

| Anchor | Input | Actual marks on code node | Status |
|--------|-------|--------------------------|--------|
| control | `` `x` `` | `["code"]` | GREEN (expected) |
| EC-1 (strong) | `` **`x`** `` | `["strong", "code"]` | RED (expected — proven by prior test) |
| EC-2 (em) | `` _`x`_ `` | `["em", "code"]` | RED — **CONFIRMED-INPUT** |
| EC-3 (strike) | `` ~~`x`~~ `` | `["strike", "code"]` | RED — **CONFIRMED-INPUT** |
| EC-4 (subsup sup) | `` ^`x`^ `` | `["subsup", "code"]` | RED — **CONFIRMED-INPUT** |
| EC-5 (link preserved) | `` [`x`](https://ex/) `` | `["link", "code"]` | GREEN (retention anchor, expected) |
| EC-6 code node | `` **a `b` c** `` | `["strong", "code"]` on "b" | RED (expected) |
| multi-mark wrapper code node | `` _a **b `c` d** e_ `` | `["em", "strong", "code"]` on "c" | RED (expected) |
| PANEL-ANCHOR | `> [!NOTE]\n> **\`x\`**` | `["strong", "code"]` on "x" in panel | RED — **CONFIRMED-INPUT** |
| `test_markdown_inline_code_mark_and_composition` rewrite | `` **bold `code` bold** `` | `["strong", "code"]` on "code" | RED (expected) |

Full test run output: 10 tests run; 8 FAILED (RED), 2 passed (GREEN).

## Task 3 Adjudication Outcomes

All empirically unconfirmed anchors resolved as **CONFIRMED-INPUT**:

- **EC-2 (em)**: tight wrap `_\`x\`_` DOES compose — `em` mark is present alongside `code` in `active_marks` at `push_code` invocation time. Valid regression pin. No spec-companion required.
- **EC-3 (strike)**: tight wrap `~~\`x\`~~` DOES compose — `strike` mark is present. Valid regression pin.
- **EC-4 (subsup sup)**: tight wrap `^\`x\`^` DOES compose — `subsup` mark is present alongside `code`. Valid regression pin. H-NEW-ADF-010 Calls B and E retain the `^\`code\`^` form unchanged.
- **PANEL-ANCHOR**: `> [!NOTE]\n> **\`x\`**` DOES produce `[strong, code]` inside `panel.content` — class-transfer argument from EC-1 confirmed empirically. Valid regression pin.

Task 3 is a **no-op**: all expected-RED regression pins came back RED. No MIXED-RANGE or DEMOTE outcomes. No spec-companion commits required.

## EC-4 Outcome — Downstream Binding

**EC-4 outcome: CONFIRMED-INPUT.** H-NEW-ADF-010 Calls B and E in
`.factory/specs/prd/holdout-scenarios.md` retain the `^\`code\`^` input form
unchanged. No spec updates required for the empirical-check propagation note.
The "primary regression target" framing for Calls B and E is validated.

## MUST-STAY-GREEN Verification

| Test | Status |
|------|--------|
| `test_render_marks_code_and_strong` | GREEN |
| `test_render_strong_with_code_applies_code_innermost` | GREEN |
| `test_push_code_normalizes_lone_cr_in_inline_code` | GREEN |
| `test_push_code_normalizes_bare_lf_to_space` | GREEN |

## Regression Check

| Existing Tests | Status |
|----------------|--------|
| 992 pre-existing tests (non-BC-7.2.015) | All pass |
| 4 MUST-STAY-GREEN reverse-path tests | All pass |
| 2 BC-7.2.015 GREEN retention anchors (control + EC-5) | Pass |

## Hand-Off to Implementer

Story S-ADF-CODE-MARK-1 is ready for implementation (Task 4).

Implementation guidance:
- Apply the `push_code` allowlist filter in `src/adf.rs::push_code`: filter a clone of `active_marks`, retaining only marks whose `type` is `"link"` or `"annotation"`, then append `{"type":"code"}` and call `dedup_marks_by_type`.
- Do NOT mutate `self.active_marks` (VP-571-003 node-scoped stripping — sibling text nodes must retain their marks).
- Do NOT touch `push_text`, `text_to_adf`, `adf_to_text`, or `apply_marks` semantics.
- After fix: all 8 RED anchors above must turn GREEN. EC-5 and control must remain GREEN. MUST-STAY-GREEN list must remain GREEN.
- `grep -n '"type": "code"' src/adf.rs` — exactly 1 match must be outside `#[cfg(test)] mod tests` (the emit site in `push_code`).
