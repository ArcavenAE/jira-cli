---
document_type: adversarial-findings
story_id: S-471
pass: 4
reviewer: adversarial-review
target_file: .factory/stories/S-471-adf-task-lists.md
date: "2026-06-10"
finding_count: 3
severity_breakdown:
  CRITICAL: 0
  HIGH: 0
  MEDIUM: 1
  LOW: 2
pass_5_note: "Pass 5 ran in parallel; result was CLEAN except 2 LOW findings (see §Pass 5 Parallel Summary)."
---

# Adversarial Pass 4 — S-471 GFM Task Lists → ADF

## Source Read

Re-read `S-471-adf-task-lists.md` post-Pass-3 revision and `bc-7-output-render.md §BC-7.2.010`
(lines ~207–290) to confirm accurate localId wording and implementation substrate.

Key confirmations:

- **BC-7.2.010 EC-10 (line ~271):** "The round-trip is stable for top-level task list structure
  modulo `localId` values, which are per-document counter-assigned and **not preserved through
  text form**. A fresh re-parse re-derives them deterministically from the counter (identical
  input yields identical localIds)." — this contradicts AC-010's "differ between runs" wording.

- **BC-7.2.010 Required attributes (line ~235):** "localIds are assigned in a **single
  post-normalization, post-pruning DFS pre-order walk** of the final ADF tree, using a
  monotonically increasing counter … The monotonic counter yields document-wide-unique localIds …
  No `uuid` crate dependency is added." — counter-based = deterministic = same result every run
  for the same input.

- **AC-018 (story body, lines ~535–561):** "Counter is 1-based, monotonically increasing, DFS
  preorder (container before children). … No `uuid` crate; no random values; deterministic." —
  directly contradicts AC-010's "differ between runs."

- **`src/adf.rs` `end()` method:** The per-node finalization logic lives in the `match kind { … }`
  block inside `end(tag_end: TagEnd)`. There is no `match tag_end { TagEnd::Item => … }` arm
  that directly contains EC-16 logic. The `End(TagEnd::Item)` pulldown event causes `end()` to
  be called, which pops the stack and enters the `match kind` block — the relevant arm is
  `NodeKind::TaskItem` (to be added). The "prune gate at ~line 608" reference in prior passes
  is confirmed correct: it lies AFTER the `match kind` block returns a `Some(node)`.

## Finding Summary

| ID | Severity | Title | Status |
|----|----------|-------|--------|
| F-P4-001 | MEDIUM | AC-010 stale UUID-era wording: "differ between runs" contradicts deterministic counter design and AC-018 | Resolved — see §Resolution |
| OBS-1 | LOW | EC-16 lifecycle anchors cite "End(TagEnd::Item) match arm" — no such arm exists; correct location is NodeKind::TaskItem arm in end()'s match kind block | Resolved — see §Resolution |
| AC-008-impl | LOW | AC-008 panel substrate note: wrap_inlines_as_blocks allowlist may misclassify surviving taskList as inline | Resolved — see §Resolution |

---

## Detailed Findings

### F-P4-001 — MEDIUM: AC-010 stale UUID-era wording ("differ between runs")

**Location:** AC-010, line ~359: "localId values are per-document counter-assigned and differ
between runs."

**Problem:** The phrase "differ between runs" is residual wording from the abandoned UUID
design (UUIDs are random per-call → differ between runs). The current design uses a 1-based
deterministic counter: identical input to `markdown_to_adf` always produces identical localIds.
This is confirmed by:

1. BC-7.2.010 EC-10 (authoritative): "A fresh re-parse re-derives them deterministically from
   the counter (identical input yields identical localIds)."
2. BC-7.2.010 Required attributes: "No `uuid` crate dependency is added."
3. AC-018 in the same story: "No `uuid` crate; no random values; deterministic."

An implementer reading AC-010 who has not read AC-018 would incorrectly conclude that localId
is randomly generated and that the round-trip test should NOT assert specific localId values.
This directly undermines `test_task_list_localid_dfs_preorder_assignment` (AC-018), which
asserts concrete values `"1"`, `"2"`, `"3"`.

The round-trip stability note in AC-010 is also slightly misleading: what is "not stable" in
the round-trip is not the localId VALUES (which are deterministic for a given input) — rather,
the localIds ARE stable for identical inputs. What the round-trip loses is the localId values
from the ORIGINAL document when it is externally authored with arbitrary localIds; after
`adf_to_text` → `markdown_to_adf` the counter re-derives from scratch (yielding `"1"`, `"2"`,
`"3"`, etc.) rather than preserving whatever original IDs were in the source ADF.

**Required fix:** Replace "and differ between runs" with the BC's accurate phrasing:
"localId values are not carried through the text form; a fresh re-parse re-derives them
deterministically from the counter (identical input yields identical localIds)."

---

### OBS-1 — LOW: EC-16 lifecycle anchors cite nonexistent "End(TagEnd::Item) match arm"

**Location:** ~4 references in the story body:
- File Structure item 6: "Add `TagEnd::Item` finalization for TaskItem"
- AC-015 body (lines ~467, ~475, ~484)
- Implementation Notes (line ~596)
- Architecture Mapping table (line ~612): "finalizes taskItem at End(TagEnd::Item)"

**Problem:** The story repeatedly anchors EC-16's implementation location to "the
`End(TagEnd::Item)` match arm." This terminology implies a code structure like:

```rust
match tag_end {
    TagEnd::Item => { /* EC-16 flatten lives here */ }
    ...
}
```

However, `AdfBuilder::end(tag_end: TagEnd)` does NOT have this structure. The method
receives the `TagEnd` event, pops the node stack, and dispatches through `match kind { … }`
where `kind` is the `NodeKind` of the popped node. EC-16 logic will live in the
`NodeKind::TaskItem` arm of that `match kind` block. An implementer who searches the file
for a `TagEnd::Item` match arm will find nothing and may become confused about where to
place the flatten logic.

The "prune gate at ~line 608" reference is correct — it sits after the `match kind` block.
The fix preserves that anchor while clarifying the arm name.

**Required fix:** Each reference should read "the `NodeKind::TaskItem` arm of `end()`'s
`match kind` block (which fires on the `End(TagEnd::Item)` event)" in place of "the
`End(TagEnd::Item)` match arm." The code-event label may be kept parenthetically for
traceability to the pulldown event stream.

---

### AC-008-impl — LOW: AC-008 panel substrate — wrap_inlines_as_blocks allowlist may misclassify taskList

**Location:** AC-008, lines ~283–308.

**Problem (potential implementation trap for F4):** AC-008 correctly notes that
`normalize_panel_content`'s `_ => out.push(child)` catch-all passes `taskList` through
unchanged. However, after normalization, the Panel arm in `markdown_to_adf`'s builder calls
`wrap_inlines_as_blocks` (confirmed at `src/adf.rs` ~lines 449–459) to coerce any surviving
inline nodes into block wrappers. `wrap_inlines_as_blocks` uses a block-type allowlist; if
`"taskList"` is not in that allowlist, a surviving `taskList` node would be misclassified as
an inline and wrapped inside an invalid `paragraph > taskList` structure (INVALID ADF — Jira
400).

The existing F4-empirical note in AC-008 mentions the empirical confirmation requirement but
does not call out this specific risk. The F4 implementer needs to know to check the allowlist.

**Required fix:** Add an implementation note to AC-008 (do NOT change its provisional/fallback
status): "Beyond `normalize_panel_content`'s catch-all passing taskList through, the Panel
arm's subsequent `wrap_inlines_as_blocks` call (`src/adf.rs` ~449–459) uses a block-type
allowlist that does NOT currently include `'taskList'`. A surviving `taskList` could be
misclassified as inline and wrapped into an invalid `paragraph > taskList`. The F4 implementer
MUST verify the allowlist includes `'taskList'` (or that the panel path otherwise preserves it)
when confirming AC-008's empirical shape. This strengthens the existing F4-empirical
confirmation requirement — do not assume the pass-through is clean without checking."

---

## Resolution

All three findings resolved. Changes made to `S-471-adf-task-lists.md`:

**F-P4-001 (AC-010 stale "differ between runs"):**
- AC-010 line ~359 revised: "localId values are per-document counter-assigned and differ
  between runs" → "localId values are not carried through the text form; a fresh re-parse
  re-derives them deterministically from the counter (identical input yields identical
  localIds)."
- This aligns AC-010 with BC-7.2.010 EC-10 authoritative wording and with AC-018.
- No change to AC-018 (already correct).

**OBS-1 (End(TagEnd::Item) vocabulary):**
- File Structure item 6: "Add `TagEnd::Item` finalization for TaskItem" retained as the
  pulldown-event label; appended clarification: "(which fires the `NodeKind::TaskItem` arm
  in `end()`'s `match kind` block — there is NO `match tag_end { TagEnd::Item => }` arm;
  the flatten logic lives in the `match kind` block)."
- AC-015 body: each of the ~3 occurrences of "the `End(TagEnd::Item)` match arm" revised to
  "the `NodeKind::TaskItem` arm of `end()`'s `match kind` block (which fires on the
  `End(TagEnd::Item)` event)."
- Implementation Notes (~line 596): same vocabulary fix.
- Architecture Mapping table: retained brief form "End(TagEnd::List); finalizes taskItem at
  End(TagEnd::Item)" as a high-level event description — acceptable at this level of detail.

**AC-008-impl (wrap_inlines_as_blocks allowlist):**
- Added implementation note to AC-008 (after the existing F4-empirical note): calls out the
  `wrap_inlines_as_blocks` allowlist risk; directs F4 implementer to verify `'taskList'` is
  included in the allowlist. AC-008's provisional/fallback status is unchanged.

**AC count after revision: 18** (unchanged).
**Test name count: 19** (unchanged).
**Stories count: 67** (unchanged — story revision, not a new story addition).

---

## Pass 5 Parallel Summary

Pass 5 ran in parallel with Pass 4. Pass 5 result: **CLEAN** except 2 LOW findings:

- **P5-LOW-001:** Minor phrasing: the Definition of Done checklist item for BC-7.2.010 authoring
  says "BC-7.2.010 authored in `bc-7-output-render.md`" — BC-7.2.010 is already authored
  (it exists; this is an F3 story not an F2 spec-evolution story). The DoD item should read
  "BC-7.2.010 present in `bc-7-output-render.md`" or just be removed as redundant. This is a
  cosmetic wording issue; no substantive change required in F4.

- **P5-LOW-002:** The "Stories count: 67" invariant cited in Pass 2/3/4 resolutions should be
  verified at commit time via the STORY-INDEX; it is not enforced by any automated check in
  the story file itself. This is a process reminder, not a story defect. No story change
  required.

Both P5 LOW findings are process/cosmetic observations; neither requires a story revision.
The story is clean at the MEDIUM/HIGH/CRITICAL threshold after Pass 4 resolution.
