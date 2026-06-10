---
document_type: adversarial-review-log
issue: 471
bc: BC-7.2.010
pass: 1
reviewer: adversary (read-only pass — could not write)
persisted_by: product-owner
date: 2026-06-10
status: resolved
---

# Adversarial Pass 1 Findings — BC-7.2.010 (Issue #471)

12 findings total: 2 CRITICAL, 4 HIGH, 4 MEDIUM, 2 LOW.

---

## Findings (verbatim)

### F-471-01 — CRITICAL: EC-5 produces invalid ADF (`listItem > listItem`)

EC-5 / normalization obligation #1 specifies a nested task-list-in-listItem unwrap producing
`listItem > [listItem > paragraph]` — INVALID ADF (a listItem cannot directly contain a listItem;
the listItem content model permits paragraph/bulletList/orderedList/codeBlock/mediaSingle). FIX:
the converted taskItems must be re-wrapped in a `bulletList` node: correct target is
`listItem > [paragraph?, bulletList > [listItem > paragraph, ...]]`. Rewrite EC-5 and obligation #1
precisely; remove the self-contradictory "valid bulletList nesting" claim and make it actually
produce a bulletList.

---

### F-471-02 — HIGH: localId counter scope unspecified

localId counter scope is unspecified. FIX: state explicitly that localId is a SINGLE per-document
counter shared across ALL taskList AND taskItem nodes, monotonically increasing, never reset
(guarantees document-wide uniqueness, including nested task lists per EC-13). Make the worked
example consistent with this (and ideally aligned with JSDCLOUD-15228's 1-based sequence — pick
one scheme and make the example match the stated rule).

---

### F-471-03 — HIGH: EC-6 / obligation #2 asserts unverified empirical pre-condition as settled fact

Blockquote normalization (obligation #2 / EC-6) is asserted as settled fact
("`> - [ ] item` parses as `blockquote > taskList`") but F1 OQ-4 flagged this as an UNRESOLVED
empirical pre-condition. FIX: downgrade to CONDITIONAL — "if pulldown-cmark emits
`blockquote > taskList` (to be confirmed by an F4 parser test), unwrap as follows; if it does
not, this arm is unnecessary." Do NOT cite a not-yet-written test as if it pins existing behavior.
Remove the forward-reference framing in **Source**.

---

### F-471-04 — HIGH: Malformed/non-task markers unaddressed

Malformed/non-task markers (`[]` no space, `[*]`, `[-]`, `[  ]` multi-space, `[ x]`) are
unaddressed. FIX: add an edge case (mirroring BC-7.2.009 EC-1 "parser leniency" rigor) stating
that only `[ ]`, `[x]`, `[X]` emit TaskListMarker; all other bracket forms stay literal text in a
normal bulletList.

---

### F-471-05 — HIGH: EC-10 round-trip stability contradicted by lossy transforms

Round-trip "stable/semantically equivalent" (EC-10) is contradicted by lossy transforms. FIX:
scope EC-10's stability claim to "top-level task lists with no normalization applied," and add an
explicit lossiness disclosure (matching BC-7.2.009 precedent) that: (a) mixed-list promotion is
lossy (plain bullets become checkboxes on re-parse), (b) listItem/blockquote unwrapping
permanently drops the checkbox. Document these as deliberate, same class as BC-7.2.006/009
table/nesting lossiness.

---

### F-471-06 — MEDIUM: Two nesting directions unspecified; `taskItem > bulletList` is invalid ADF

Two nesting directions unspecified, and a real content-model violation: a plain bulletList nested
inside a taskItem (`- [ ] outer\n  - plain inner`) → taskItem.content is INLINE-only, so
`taskItem > bulletList` is INVALID ADF. FIX: specify both nesting directions, and add a
normalization obligation for block content (nested list) inside a taskItem. Per the inline-only
content model, decide and specify: does a nested block list inside a task item get hoisted out as a
sibling taskList/bulletList, or flattened? Choose the ADF-valid option and specify it precisely.

---

### F-471-07 — MEDIUM: Whitespace-only / hardBreak-only task item handling underspecified

Whitespace-only / hardBreak-only task item handling underspecified vs prune logic. FIX: specify
whether a whitespace-only taskItem is pruned or trimmed; align with the inline-only model.

---

### F-471-08 — MEDIUM: Trace lists two names for the same blockquote test

Trace lists TWO names for the same blockquote test (`test_task_list_in_blockquote_normalized_to_paragraphs`
AND `test_task_list_in_blockquote_normalized`). FIX: pick ONE convention-compliant name
(`test_<verb>_<subject>_<expected_outcome>` → the `_to_paragraphs` form) and remove the
duplicate.

---

### F-471-09 — MEDIUM: taskItem in `is_empty_block_container` without reconciliation

taskList/taskItem added to `is_empty_block_container` prune set, but taskItem is inline-content
while that function is named for block containers. FIX: reconcile — state why taskItem (inline
content) belongs there and that emptiness is measured by empty content array; or clarify the
mechanism.

---

### F-471-10 — LOW: Count surfaces (scripts) — verify after edits

Count surfaces — already verified clean by both scripts; just re-run scripts/check-spec-counts.sh
and scripts/check-bc-cumulative-counts.sh after your edits to confirm they STILL pass (no count
change expected; BC count stays 594).

---

### F-471-11 — LOW: Headline `Confidence: HIGH` marginally overstated

Headline `Confidence: HIGH` is marginally stronger than research warrants for top-level-doc
placement (research rates that sub-claim MEDIUM-HIGH). FIX: qualify to "HIGH on node shape;
MEDIUM-HIGH on top-level doc placement (single best sandbox-probe candidate)."

---

### F-471-12 — MEDIUM: Multi-paragraph task item unspecified

Multi-paragraph task item (`- [ ] line1\n\n  line2`) — pulldown emits two paragraphs inside the
item; flattening to inline is lossy (paragraph break lost) and unspecified. FIX: specify the
inline-flattening contract for multi-block task-item bodies (and note any lossiness).

---

## Resolution

Each finding is addressed in the BC-7.2.010 revision committed alongside this file:

| ID | Severity | Resolution |
|----|----------|-----------|
| F-471-01 | CRITICAL | EC-5 rewritten: inner taskItems are now re-wrapped in a `bulletList` node producing the ADF-valid shape `listItem > [bulletList > [listItem > paragraph, ...]]`. Obligation #1 prose updated to match; "valid bulletList nesting" claim removed. |
| F-471-02 | HIGH | localId counter scope now explicitly stated: single per-document counter shared across ALL taskList and taskItem nodes, monotonically increasing from 1 (matching JSDCLOUD-15228's 1-based sequence). Worked example updated to use 1-based counter (`"1"` for taskList, `"2"`, `"3"` for taskItems). Counter rule now appears in required-attributes prose and is consistent with the JSON example. |
| F-471-03 | HIGH | EC-6 and obligation #2 downgraded to CONDITIONAL: language now reads "if pulldown-cmark emits `blockquote > taskList` (to be confirmed by an F4 parser test), unwrap as follows; if it does not, this arm is a no-op." Forward-reference test citation removed from Source. |
| F-471-04 | HIGH | Added EC-14 (new edge case): malformed/non-task bracket forms (`[]`, `[*]`, `[-]`, `[  ]`, `[ x]`) stay as literal text in a normal bulletList — only `[ ]`, `[x]`, `[X]` produce TaskListMarker. Added test name `test_malformed_task_markers_stay_literal_text` in Trace. |
| F-471-05 | HIGH | EC-10 scoped to "top-level task lists with no normalization applied." Added explicit lossiness disclosure: (a) mixed-list promotion is lossy (plain bullets become checkboxes on re-parse); (b) listItem/blockquote unwrapping permanently drops the checkbox indicator. Labeled "deliberate, same class as BC-7.2.006/009 table/nesting lossiness." |
| F-471-06 | MEDIUM | Added EC-15 (new edge case): plain bulletList nested inside a taskItem (`- [ ] outer\n  - plain inner`) — taskItem.content is inline-only, so a nested block list is INVALID ADF. The nested list is hoisted out as a sibling node: inline text from the taskItem is preserved in taskItem.content; the nested list is appended as a sibling bulletList/taskList after the taskItem in the parent taskList. Added normalization obligation #4. Both nesting directions now specified. |
| F-471-07 | MEDIUM | Added to EC-8 body: a taskItem containing only whitespace text is pruned (same path as empty); a taskItem containing only a `hardBreak` is also pruned (no semantic content). Trim-before-prune behavior noted. |
| F-471-08 | MEDIUM | Duplicate test name removed from Trace. The canonical name is `test_task_list_in_blockquote_normalized_to_paragraphs` (convention-compliant); the shorter `test_task_list_in_blockquote_normalized` alias was removed. |
| F-471-09 | MEDIUM | Added reconciliation note in `is_empty_block_container` paragraph: taskItem holds inline content (not block), but the prune mechanism is the same — empty `content` array produces an invalid ADF node regardless of content model type. The function name refers to "container" in the sense of "node whose content array must be non-empty"; taskItem qualifies. |
| F-471-10 | LOW | Both check scripts re-run after edits (see script results in final response). BC count confirmed at 594. |
| F-471-11 | LOW | Confidence headline updated to "HIGH on node shape; MEDIUM-HIGH on top-level doc placement (single best sandbox-probe candidate)." |
| F-471-12 | MEDIUM | Added EC-16 (new edge case): multi-paragraph task item — when pulldown emits a paragraph-wrapped body (e.g., two blank-line-separated paragraphs inside a task item), the paragraph wrappers are stripped and inline content is concatenated with a `hardBreak` separator. This is a lossy transform (paragraph break becomes a line break). Noted as deliberate, same class as other inline-flattening lossiness. |
