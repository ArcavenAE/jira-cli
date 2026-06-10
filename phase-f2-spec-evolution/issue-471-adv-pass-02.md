---
document_type: adversarial-review-log
issue: 471
bc: BC-7.2.010
pass: 2
reviewer: adversary (read-only pass — could not write)
persisted_by: product-owner
date: 2026-06-10
status: resolved
---

# Adversarial Pass 2 Findings — BC-7.2.010 (Issue #471)

12 findings total: 1 CRITICAL, 5 HIGH, 4 MEDIUM, 1 LOW, 1 process-gap.

---

## Findings (verbatim from adversarial pass)

### F-01 — CRITICAL: EC-16 and EC-8 give contradictory/undefined guidance at the hardBreak boundary

EC-16 multi-paragraph flattening concatenates paragraphs with a `hardBreak` separator, but gives
no guidance on the edge case where one paragraph is empty/whitespace (e.g., `- [ ] x\n\n  ` or
`- [ ]\n\n  y`). EC-8 says "a taskItem containing only a hardBreak is pruned" — but if EC-16
produces leading or trailing hardBreaks (before/after a pruned-empty paragraph), the item may
end up starting or ending with a hardBreak, which is semantically meaningless and undefined.
The two ECs are mechanically incompatible without an explicit trim rule.

---

### F-02 — HIGH: EC-15 / obligation #4 specifies an invalid ADF output ("bulletList sibling inside the parent taskList")

EC-15 / normalization obligation #4 says the nested plain list is "appended as a sibling node
after the `taskItem` in the parent `taskList` (or converted to a bulletList sibling)."
This is INVALID: `taskList.content` is a tuple schema permitting ONLY `taskItem` and `taskList`
nodes — a `bulletList` is NOT allowed there. The "(or converted to a bulletList sibling)" option
is schema-forbidden. FIX: the ADF-valid resolution is to hoist the nested block list OUT of the
`taskList` entirely, to the GRANDPARENT block level (as a sibling node AFTER the taskList, not
after the taskItem inside the taskList).

---

### F-03 — HIGH: EC-13 nested taskList contradicts taskItem.content=inline-only and the tuple lead-with-taskItem rule

EC-13 says "no normalization applied; taskList permits nested taskList" — but does not specify
WHERE the nested taskList lives in the parent taskList's content array. The tuple schema says:
first element MUST be a `taskItem`; subsequent elements are `anyOf [taskItem, taskList]`. A
nested taskList therefore CANNOT be the first element, and CANNOT be inside a taskItem (inline-
only). The actual valid ADF placement is: nested taskList is a SIBLING element in the parent
taskList's content array, immediately AFTER the parent taskItem that owns the nested checkbox
items. EC-13 must specify this placement precisely, and must be reconciled with obligation #4
(nested TASK list → sibling taskList inside parent taskList content; nested PLAIN list → hoisted
to grandparent level outside the taskList — these are different behaviors for two distinct cases).

---

### F-04 — HIGH: localId assignment order is ambiguous vs Approach B reclassification and pruning

The BC states localId is assigned using "a single per-document monotonically increasing counter
... starting at `'1'`" but never specifies WHEN the counter fires relative to (a) Approach B
post-hoc reclassification of `bulletList` → `taskList` (which fires at `End(Tag::List)`, after
children are already built), and (b) pruning (which removes nodes that already received a
localId). This leaves open whether a pruned node "used" a counter slot (creating a gap) or
whether the counter is assigned in a post-normalization pass. The worked example (container=`"1"`,
items=`"2"`,`"3"`) is only consistent with a DFS-pre-order walk of the FINAL tree. FIX: specify
exactly when localId is assigned — recommended: a SINGLE final-tree DFS pre-order walk after all
normalization and pruning is complete, so (i) pruned nodes never consume a counter slot and (ii)
the container is numbered before its children. State this decoupling explicitly.

---

### F-05 — HIGH: EC-10 lossiness ledger is incomplete

EC-10 lists three lossy transforms: (a) mixed-list promotion, (b) listItem normalization/EC-5,
(c) blockquote unwrapping/EC-6. It omits: (d) nested-plain-list hoist (EC-15), (e)
multi-paragraph flattening (EC-16), and (f) `[X]` → `[x]` casing normalization (EC-2 — not
identity-preserving; original `[X]` is lost). All six lossy transforms must be enumerated for the
round-trip disclosure to be complete.

---

### F-06 — HIGH: Line "stable for the five canonical cases" is a copy-paste artifact from BC-7.2.009

The reverse-path paragraph ends with "...makes the markdown→ADF→text round-trip stable for the
five canonical cases." Task lists have TWO states (TODO/DONE), not five. "Five canonical cases"
is verbatim from BC-7.2.009 (which has five GFM alert kinds). This is a copy-paste artifact and
is incorrect.

---

### F-07 — HIGH: `is_empty_block_container` reconciliation note defines emptiness as "content array is empty" but EC-8 prunes a hardBreak-only taskItem (content array NOT empty)

The reconciliation note in the `is_empty_block_container` section states: "a node whose `content`
array is empty produces invalid ADF regardless of whether the content model is block-level or
inline-level." But EC-8 specifies pruning "a task item containing only a hardBreak node" — that
taskItem's content array is NOT empty (it has one hardBreak element). The prune criterion and the
reconciliation note are mechanically incompatible. FIX: either (a) broaden the prune criterion to
"empty OR contains only structurally-empty inline content (whitespace-only text and/or
hardBreaks)," or (b) note the hardBreak-only case as a separate semantic-emptiness check distinct
from structural emptiness, and update EC-8 and the prune-set note consistently.

---

### F-08 — MEDIUM: EC-8's hardBreak-only prune is a deliberate product choice, not ADF-invalidity

EC-8 prunes a hardBreak-only taskItem without labeling this as a DELIBERATE PRODUCT CHOICE.
A lone hardBreak is schema-valid ADF (hardBreak IS in the inline_node set). A future implementer
may "correct" this as over-pruning. FIX: explicitly label the hardBreak-only prune as a
deliberate product choice (not schema-forced), so the intent is unambiguous.

---

### F-09 — MEDIUM: Trace lists `test_task_list_in_blockquote_normalized_to_paragraphs` unconditionally, but EC-6 / obligation #2 are CONDITIONAL on F4 probe result

The Trace section lists `test_task_list_in_blockquote_normalized_to_paragraphs` as a test that
will exist, but obligation #2 / EC-6 is explicitly CONDITIONAL (the F4 parser probe may reveal
that pulldown does NOT emit `blockquote > taskList`, in which case no normalization arm is needed
and this test would instead assert a different structure). The trace should flag this test as
F4-conditional.

---

### F-10 — MEDIUM: Builder mechanics section never describes how the TaskListMarker event itself is consumed

The "Builder mechanics" section describes Approach B post-hoc reclassification but never states
WHAT happens to the `Event::TaskListMarker(bool)` event itself — how does the builder capture the
checked/unchecked state? The narrative skips from "pulldown emits TaskListMarker(bool)" to "emits
taskList instead of bulletList" without explaining the mechanism. FIX: add a sentence specifying
that the `TaskListMarker` event flips the in-progress `listItem` into a taskItem candidate and
captures its TODO/DONE state for use when the item is finalized at `End(Tag::Item)`.

---

### F-11 — LOW: Worked-example localId provenance claim may conflict with the research's own 0-based example

The text says "deterministic and matches the JSDCLOUD-15228 accepted payload (`'1'`/`'2'`/`'3`')".
The research doc §1 Top-Line Recommendation shows a 0-based example (`taskList.localId: "0"`,
items `"1"`/`"2"`). The JSDCLOUD-15228 actual values are cited differently in different places.
FIX: either pin the actual JSDCLOUD-15228 values precisely, or drop the specific provenance claim
and just say "1-based, any non-empty unique string is schema-valid" — do not imply the exact
sequence is mandatory.

---

### F-12 — MEDIUM [process-gap]: BC over-prescribes implementation mechanics

[process-gap] The BC prescribes Approach B by name, private method signatures (`normalize_list_item_content`,
`is_empty_block_container`), and build-loop mechanics — this is a recurring over-prescription
pattern from BC-7.2.006/007/008/009 (#470–#483). The BC should specify OBSERVABLE BEHAVIOR +
helper name anchors (sufficient for test-writer), not implementation plans. Full mechanics belong
in a `docs/specs/adf-task-list.md` implementation spec. This does not block convergence but
should be noted as a structural debt item. Tag: [process-gap].

---

## Resolution

Each finding is addressed in the BC-7.2.010 revision committed alongside this file:

| ID | Severity | Resolution |
|----|----------|-----------|
| F-01 | CRITICAL | Added a GENERAL hardBreak boundary rule to EC-16: after concatenating paragraphs with hardBreak separators, collapse/trim any leading or trailing hardBreaks AND any hardBreak adjacent to a pruned-empty paragraph — so taskItem.content never begins or ends with a hardBreak. Explicit output specified for `- [ ] x\n\n  ` (`taskItem.content: [text("x")]` — the trailing empty paragraph yields nothing and the separator hardBreak between "x" and the empty paragraph is dropped). |
| F-02 | HIGH | EC-15 and obligation #4 rewritten: the nested plain list is hoisted OUT of the `taskList` entirely to the GRANDPARENT block level as a sibling node AFTER the taskList. The "(or converted to a bulletList sibling)" option that the schema forbids is removed. Marked as lossy (nesting/association lost). |
| F-03 | HIGH | EC-13 rewritten to specify the exact ADF placement: a nested taskList is a SIBLING element in the parent taskList's content array, placed immediately AFTER the parent taskItem (not inside it, and not as the first/lead element — the parent taskItem is the lead). Reconciliation with obligation #4 added: nested TASK list → sibling taskList inside parent taskList content; nested PLAIN list → hoisted to grandparent level outside the taskList. |
| F-04 | HIGH | localId assignment rule rewritten: localIds are assigned in a SINGLE post-normalization, post-pruning DFS pre-order walk of the final ADF tree. Pruned nodes never consume a counter slot. The container is numbered before its children. This is stated as "decoupled from build/emit order." The worked example (container="1", items="2","3") is now explicitly consistent with the stated final-tree walk. |
| F-05 | HIGH | EC-10 lossiness ledger extended to enumerate all six lossy transforms: (a) mixed-list promotion, (b) listItem normalization (EC-5), (c) blockquote unwrapping (EC-6), (d) nested-plain-list hoist to grandparent (EC-15), (e) multi-paragraph flattening (EC-16), (f) `[X]`→`[x]` casing normalization (EC-2). |
| F-06 | HIGH | "stable for the five canonical cases" replaced with "stable for top-level task lists with TODO/DONE items, modulo localId values and the lossy transforms in EC-10." |
| F-07 | HIGH | `is_empty_block_container` reconciliation note updated: the prune criterion is now stated as "empty OR contains only structurally-empty inline content (whitespace-only text and/or hardBreaks)," covering both the empty-array case and the hardBreak-only EC-8 case. EC-8 and the reconciliation note are now consistent. |
| F-08 | MEDIUM | EC-8 updated to explicitly label the hardBreak-only prune as a "DELIBERATE PRODUCT CHOICE (not schema-forced — a lone hardBreak is schema-valid ADF inline content)," preventing future over-correction. |
| F-09 | MEDIUM | Trace updated: `test_task_list_in_blockquote_normalized_to_paragraphs` is now marked "(F4-conditional — depends on F4 parser probe result for obligation #2 / EC-6)." |
| F-10 | MEDIUM | Builder mechanics section updated: added a sentence specifying that the `TaskListMarker(bool)` event flips the in-progress listItem into a taskItem candidate and captures the TODO/DONE state for use when the item is finalized at `End(Tag::Item)`. |
| F-11 | LOW | Provenance claim simplified: no longer claims to match JSDCLOUD-15228's exact counter values; instead states "1-based, matches the JSDCLOUD-15228 pattern; any non-empty unique string is schema-valid." The research §1 example used 0-based (`"0"`/`"1"`/`"2"`); the BC chooses 1-based as a convention and states so without pinning JSDCLOUD values. |
| F-12 | MEDIUM [process-gap] | Logged as deferred process-gap. Builder-mechanics prose trimmed to an observable-behavior + helper-name anchor summary; a forward-reference to `docs/specs/adf-task-list.md` is added for full implementation mechanics. Full Approach-B detail remains (trimming the full section would lose load-bearing helper names and the post-hoc reclassification contract), but the most plan-like step-by-step internal detail is deferred to the implementation spec. This does not block convergence. |
