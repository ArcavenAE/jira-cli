---
document_type: adversarial-findings
story_id: S-471
pass: 1
reviewer: adversarial-review
target_file: .factory/stories/S-471-adf-task-lists.md
date: "2026-06-10"
finding_count: 11
severity_breakdown:
  CRITICAL: 1
  HIGH: 3
  MEDIUM: 4
  LOW: 3
---

# Adversarial Pass 1 — S-471 GFM Task Lists → ADF

## Finding Summary

| ID | Severity | Title | Status |
|----|----------|-------|--------|
| F-001 | CRITICAL | Stale adf::tests hardcoded count (132 baseline / 149 target) | Resolved — see §Resolution |
| F-002 | HIGH | AC-006 under-asserts: no assertion that inner nodes are `listItem` not `taskItem`, no state-drop confirmation | Resolved |
| F-003 | HIGH | AC-014 grandparent-hoist only tests doc-root; non-root case unspecified | Resolved |
| F-004 | HIGH | localId DFS preorder assignment unpinned; no concrete-values test | Resolved |
| F-005 | MEDIUM | EC-16 ordering/trim undertested: trailing-empty-paragraph trim and both-empty sequences missing | Resolved |
| F-006 | MEDIUM | hardBreak-only prune has no dedicated assertion | Resolved |
| F-007 | MEDIUM | AC-008 panel/alert path unverified; may arrive as blockquote-unwrapped rather than `panel > taskList` | Resolved |
| F-008 | MEDIUM | AC-012 nested reverse-path 2-space indentation unpinned | Resolved |
| F-009 | LOW | AC-017 is process gate (replace-not-delete), not an independent automated assertion; AC-to-test asymmetry unexplained | Resolved |
| F-010 | LOW | AC-003 reverse casing `[X]`→`[x]` forward and reverse not split into distinct assertions | Resolved |
| F-011 | LOW | Process gap: frozen count in Definition of Done line (`149`) tied to frozen baseline (`132`) | Resolved (same as F-001) |

---

## Detailed Findings

### F-001 — CRITICAL: Stale adf::tests hardcoded count

**Location:** Test Coverage Summary (line ~499): `net new test count = +16`. Expected adf::tests count after: 149 (132 from post-#483 + 17 new).
Also: Definition of Done line (line ~538): `adf::tests` count increases to 149 (132 baseline post-#483 + 17 new).

**Problem:** PRs #488, #490, #491 merged to develop after #483 added a combined ~23 tests (net +19 from prior 136 → 155). The frozen "132" baseline and "149" target are both wrong. The actual `grep -c '#\[test\]' src/adf.rs` on develop is 155.

**Risk:** An implementer using the hardcoded target 149 would wrongly conclude the implementation is INCOMPLETE (149 < 155) or would not know when to stop adding tests.

**Fix:** Remove all frozen integers. Replace with a derive-at-implementation-time instruction referencing the delta. Also resolves process gap F-011.

---

### F-002 — HIGH: AC-006 under-asserts inner node type and state-drop

**Location:** AC-006, lines ~231–243; Test Coverage table row for `test_task_list_in_list_item_normalized_to_nested_bullet_list`.

**Problem:** AC-006 states the output shape is `listItem > [bulletList > [listItem > paragraph(...)]]` and says "No `taskList` node appears inside any `listItem`." But it does NOT assert:
- The inner nodes are `listItem` (NOT `taskItem`) — an implementer could emit `bulletList > [taskItem]` which is invalid ADF (bulletList can only contain listItem).
- The `state` attribute is absent/dropped on those inner `listItem` nodes.
- The checkbox state (TODO/DONE) from the original `taskItem` is dropped (EC-10(b) lossiness).

An implementer passing an under-specified test could produce `bulletList > [taskItem]` (INVALID) and still pass AC-006 as written.

**Fix:** AC-006 must explicitly assert inner nodes are `listItem` (not `taskItem`), carry no `state` attr, and the checkbox state is dropped.

---

### F-003 — HIGH: AC-014 grandparent hoist only covers doc-root case

**Location:** AC-014, lines ~344–355; EC-015.

**Problem:** The only test input `"- [ ] outer\n  - plain inner"` has the `taskList` at document root, so "grandparent" is the document root itself. An implementer could hardcode "append to doc root" and pass this test while completely breaking non-root nesting (e.g., a task item with a nested plain list inside a blockquote or panel).

**Fix:** Either add a second AC/test for the non-root case (if a valid GFM input can produce it), or explicitly scope AC-014 to doc-root and justify why non-root cannot arise from valid markdown (e.g., blockquote → taskList is normalized by AC-007 before hoist runs, so the only valid inputs that reach hoist are top-level lists).

---

### F-004 — HIGH: localId DFS preorder unpinned; no concrete-value test

**Location:** AC-010 (round-trip), Implementation Notes (lines ~424–426); no AC explicitly pins localId ordering.

**Problem:** No AC asserts CONCRETE localId values for a known input. The BC makes the single document-wide monotonic DFS pre-order, container-before-children, pruned-nodes-skip counter load-bearing. Without a pinned test, an implementer could assign per-list counters (restart at 1 each list) or random UUIDs and still pass all 17 ACs.

**Fix:** Add a dedicated AC and named test `test_task_list_localid_dfs_preorder_assignment`. Use the BC's worked example: a 2-item task list → taskList.localId="1", item1.localId="2", item2.localId="3" (1-based, container before children). Add a second assertion that an empty (pruned) item does NOT consume a counter slot.

---

### F-005 — MEDIUM: EC-16 ordering/trim undertested

**Location:** AC-015 lines ~359–371.

**Problem:** AC-015 covers the normal two-paragraph case (`line1\n\n  line2` → `[text("line1"), hardBreak, text("line2")]`). Missing assertions:
1. Trailing-empty-paragraph trim: `"- [ ] x\n\n  "` → `[text("x")]`, no trailing hardBreak.
2. Both-empty flatten→trim→prune: `"- [ ]\n\n  "` → item pruned entirely (EC-16 runs before EC-8 prune is load-bearing).

Without these, an implementer may leave trailing hardBreaks or fail to prune the all-empty case, and no test catches it.

**Fix:** Add assertions/tests for trailing-empty-paragraph trim and the both-empty sequence.

---

### F-006 — MEDIUM: hardBreak-only prune has no dedicated assertion

**Location:** AC-009 lines ~278–284.

**Problem:** AC-009 covers EC-8 (empty-content prune) and EC-9 (empty taskList prune) with named tests `test_empty_task_item_pruned` and `test_empty_task_list_pruned`. But the hardBreak-only prune — a DELIBERATE PRODUCT CHOICE per BC (not schema-forced) — has no dedicated named test. It's mentioned in AC-009 prose but shares the same two test names, which focus on zero-content items.

**Fix:** Add an explicit named test for the hardBreak-only case: a `taskItem` containing only a `hardBreak` node is pruned to nothing.

---

### F-007 — MEDIUM: AC-008 panel/alert path unverified

**Location:** AC-008 lines ~264–271.

**Problem:** AC-008's test input `"> [!NOTE]\n> - [ ] item"` routes through the GFM alert → panel path (PR #487, BC-7.2.009). It is unverified whether pulldown emits the taskList as `panel > taskList` (preserved by the `_ => out.push(child)` catch-all) or whether the GFM alert handler unwraps the blockquote containing the task list via AC-007's normalization pass before the panel node is formed.

If the alert → panel transformation runs before the task-list builder produces a `taskList` node, the panel may contain `paragraph` nodes (via blockquote normalization) rather than a `taskList`. The test could silently pass in the wrong shape.

**Fix:** Note that F4 must empirically confirm the alert path yields `panel > taskList`. Reference BC-7.2.009 (panel.content permits taskList). Mark AC-008 as needing F4 empirical confirmation. Specify a fallback test construction if empirical check fails.

---

### F-008 — MEDIUM: AC-012 nested reverse-path indentation unpinned

**Location:** AC-012 lines ~317–327.

**Problem:** AC-012 states "`adf_to_text` renders nested task lists with 2-space indentation per nesting level" but pins NO rendered string. An implementer could emit 4-space indentation, tab indentation, or no indentation at all and pass AC-012 as written.

**Fix:** Add a reverse-path assertion that a nested task list renders with correct 2-space indentation (e.g., input `"- [ ] outer\n  - [x] nested"` → `adf_to_text` output contains `"- [ ] outer\n  - [x] nested"`).

---

### F-009 — LOW: AC-017 is a process gate, not an independent automated assertion

**Location:** AC-017 lines ~390–401.

**Problem:** AC-017 ("Replacement of the breaking test") maps to `test_markdown_task_list_emits_task_list_node` which is already AC-001's test. The Test Coverage Summary counts 17 tests but only 16 are net-new (1 is a replace). This creates an apparent AC-to-test asymmetry: reviewers may expect 17 distinct new test functions from 17 ACs.

**Fix:** Make the asymmetry explicit in the story: AC-017 is a review-verified checklist item (replace-not-delete), not an additional automated assertion. The test count is 17 named tests + 1 replacement = 17 names appearing in the file after merge, net +16 from the baseline.

---

### F-010 — LOW: AC-003 forward/reverse casing not split

**Location:** AC-003 lines ~195–201.

**Problem:** AC-003 combines two distinct behaviors: (1) `[X]` uppercase input → forward path produces `state: "DONE"`, and (2) round-trip via `adf_to_text` renders `- [x]` (lowercase x, casing normalization). The single pinned test `test_markdown_task_uppercase_x_emits_done_state` focuses on the forward state but the reverse casing behavior is not pinned by a dedicated assertion.

**Fix:** Either split AC-003 into AC-003a (forward: `[X]` → `state: "DONE"`) and AC-003b (reverse: re-renders as `[x]`), or extend the existing test to explicitly assert the `adf_to_text` output casing.

---

### F-011 — LOW: Process gap (same root as F-001)

Resolved by F-001 fix. No separate action required.

---

## Resolution

All findings were resolved in the revised `S-471-adf-task-lists.md` produced during adversarial pass 1. Changes made per finding:

**F-001/F-011 (stale counts):** Removed frozen integers `132` and `149` from Test Coverage Summary and Definition of Done. Replaced with derive-at-implementation-time instruction: "Baseline = `grep -c '#\[test\]' src/adf.rs` on the branch's merge-base with develop (currently 155 on 2026-06-10). After S-471, count increases by net +18 (19 new test names added, 1 old name removed). Verify the delta is +18, not an absolute target." Note: the original F-001 claim of "+16" was based on 17 original story tests. Addressing F-004 and F-006 added 2 more test names (`test_task_list_localid_dfs_preorder_assignment` and `test_hardbreak_only_task_item_pruned`), correcting the net delta to +18.

**F-002 (AC-006 under-asserts):** AC-006 strengthened to explicitly assert: inner nodes are `listItem` (NOT `taskItem`), carry no `state` attribute, and the checkbox state is dropped (documented EC-10(b) lossiness).

**F-003 (AC-014 grandparent non-root):** Added justification scoping AC-014 to the doc-root case with explicit rationale: blockquote→taskList is normalized by AC-007 (unconditional), and panel→taskList passes through (AC-008); the only inputs reaching hoist are top-level task items at document root. Added a note that the non-root case cannot arise from valid GFM markdown in this implementation.

**F-004 (localId unpinned):** Added AC-018 `test_task_list_localid_dfs_preorder_assignment` pinning concrete localId values: 2-item task list → taskList="1", item1="2", item2="3". Added second assertion that a pruned empty item does NOT consume a counter slot: `"- [ ] keep\n- [ ]\n- [ ] also"` → dense localIds "1","2","3" (empty middle item pruned, no gap).

**F-005 (EC-16 ordering undertested):** Extended AC-015 with two additional sub-assertions: trailing-empty-paragraph trim and the both-empty→prune sequence.

**F-006 (hardBreak-only prune):** Added dedicated named test `test_hardbreak_only_task_item_pruned` to AC-009's pinned tests.

**F-007 (AC-008 alert path):** Added an F4 empirical confirmation note to AC-008. Referenced BC-7.2.009 panel.content permits taskList. Specified fallback test construction.

**F-008 (AC-012 indentation unpinned):** AC-012 extended to pin the rendered string for nested task lists with explicit 2-space indentation assertion.

**F-009 (AC-017 process gate):** Added explicit note to AC-017 clarifying it is a review-verified checklist item (not a 17th independent test). Noted the AC-to-test asymmetry is intentional: 17 ACs map to 17 named tests in the file, but one is a replacement of a pre-existing test, so the net new count is +16.

**F-010 (AC-003 casing):** Extended AC-003's pinned test note to explicitly assert the reverse `adf_to_text` output renders `- [x]` (lowercase x). Added sub-assertions to the test name.

**Story AC count after revision: 18 ACs** (added AC-018 for localId DFS preorder; AC-017 is process-gate/review-verified; see revised story for authoritative list).
**Test name count after revision: 19 distinct test function names** (19 new names added, 1 old name removed → net +18 from baseline of 155).

**Stories count: 67** (unchanged — this is a story revision, not a new story addition).
