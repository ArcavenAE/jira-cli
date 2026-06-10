---
document_type: adversarial-findings
story_id: S-471
pass: 2
reviewer: adversarial-review
target_file: .factory/stories/S-471-adf-task-lists.md
date: "2026-06-10"
finding_count: 5
severity_breakdown:
  CRITICAL: 0
  HIGH: 0
  MEDIUM: 2
  LOW: 3
---

# Adversarial Pass 2 — S-471 GFM Task Lists → ADF

## Source Read

Re-read `src/adf.rs` around the cited lines to confirm implementation substrate.

- `is_empty_block_container` (~line 744–764): confirmed structural-only check. `REQUIRES_CONTENT`
  is a const `[&str; 8]` array. Emptiness test is exactly `c.is_empty()` on the `content` array.
  No whitespace trimming, no `hardBreak` handling. Confirmed the existing pin test is at ~line 2753:
  `test_is_empty_block_container_membership` iterates the 8 types in a for-loop.

- `AdfBuilder::end` prune gate (~line 597–611): `is_empty_block_container(&node)` is called ONCE,
  after the `match kind { ... }` arm produces a `Some(node)`. This is the ONLY call site for the
  prune gate in the `end()` path. The `End(TagEnd::Item)` arm is a match arm within the same
  `end()` method — so it produces its node and that node passes through the same prune gate at
  line 608. EC-16 inline-flattening for `TaskItem` finalization MUST happen inside the `TagEnd::Item`
  match arm (i.e., BEFORE the `Some(node)` is returned to the prune gate at line 608), not in a
  separate post-finish() pass.

## Finding Summary

| ID | Severity | Title | Status |
|----|----------|-------|--------|
| F-P2-001 | MEDIUM | `is_empty_block_container` structural-only; whitespace-only / hardBreak-only taskItem NOT prunable by membership alone | Resolved — see §Resolution |
| F-P2-002 | MEDIUM | EC-16-before-EC-8 ordering not pinned; lifecycle placement unspecified; both-empty ordering hedge undermines contract | Resolved — see §Resolution |
| O-P2-001 | LOW | AC ordering anomaly: AC-018 placed before AC-017 | Resolved — see §Resolution |
| O-P2-002 | LOW | Delta analysis EC subset (EC-1..EC-12 only) not acknowledged in story | Resolved — see §Resolution |
| O-P2-003 | LOW | AC-008 provisional F4-empirical note intact | No change required — confirmed intact |

---

## Detailed Findings

### F-P2-001 — MEDIUM: `is_empty_block_container` structural-only; taskItem predicate insufficient

**Location:** Story File Structure item 9 (Implementation Notes line re: `is_empty_block_container`);
AC-009; `src/adf.rs` lines 744–764.

**Confirmed by source read:** `is_empty_block_container` checks exactly one condition:
`is_required && content.is_empty()`. "Empty" means zero-length array. A `taskItem` with
`content: [{"type":"hardBreak"}]` has a **non-empty** content array (length 1) and would NOT
be pruned by structural membership alone — even after adding `"taskItem"` to `REQUIRES_CONTENT`.
Similarly a `taskItem` with `content: [{"type":"text","text":"   "}]` (whitespace-only text)
has a non-empty content array and would not be pruned.

**Risk:** Adding `"taskItem"` to `REQUIRES_CONTENT` is NECESSARY but INSUFFICIENT to implement
AC-009's hardBreak-only and whitespace-only prune semantics. An implementer who reads only
"add `taskItem` to `is_empty_block_container`" will miss that a new emptiness branch is needed.

**Required fix:** The story's actionable instructions must state that `is_empty_block_container`
needs a second emptiness branch — a "structurally-empty inline content" predicate — that applies
ONLY to `taskItem`. This branch considers a `taskItem` as effectively empty when ALL of its
content nodes are either (a) whitespace-only text nodes (text trimmed is empty) or (b) `hardBreak`
nodes, with NO other content. The structural-only (`c.is_empty()`) branch for the existing 8
container types MUST NOT be altered.

**Regression guard:** The existing `test_is_empty_block_container_membership` pin at ~line 2753
iterates the 8 types and checks `c.is_empty()` semantics. AC-009's regression assertion must
confirm those 8 types retain structural-only emptiness semantics (the loop still passes).

---

### F-P2-002 — MEDIUM: EC-16-before-EC-8 ordering not lifecycle-pinned; both-empty hedge is wrong

**Location:** AC-015 (EC-16/EC-8 ordering); File Structure items 6 and 9; Implementation Notes.

**Confirmed by source read:** `is_empty_block_container` is called once at line 608, AFTER
the `match kind` arm returns a `Some(node)`. The `End(TagEnd::Item)` arm for a task item
lives inside that same `match kind` block. Therefore EC-16 inline-flattening MUST be placed
INSIDE the `End(TagEnd::Item)` match arm — where it executes as part of producing the finalized
`taskItem` node — so that by the time line 608's prune gate evaluates the node, the flattening
has already run.

**Problem 1 — Lifecycle placement unspecified:** The story (File Structure item 6 and
Implementation Notes) says "Add `TagEnd::Item` finalization for TaskItem" and "EC-16 runs before
EC-8 prune" but does NOT specify WHERE in the code the EC-16 flatten runs. An implementer
could place it in a post-`finish()` pass over the built tree, which would invert the ordering:
post-finish() runs AFTER the prune gate fires during `end()`, meaning the prune gate would
evaluate the unflattened `[paragraph, paragraph]` structure (non-empty → NOT pruned), leaving
a stray non-pruned taskItem in the both-empty case.

**Problem 2 — Both-empty ordering hedge is wrong:** AC-015 currently contains the sentence:
"If EC-8 ran first on each paragraph, the behavior would be identical in this case". This is
INCORRECT. EC-8 in the prune gate fires once per node at line 608. If EC-16 flatten does NOT
run before the prune gate, the prune gate sees `content: [paragraph(""), paragraph("")]`
(two empty paragraphs — a non-empty content array) and would NOT prune the taskItem. The
behavior is NOT identical regardless of ordering — the two-paragraph shape is non-empty by
structural count and would NOT be pruned. This hedge must be removed and replaced with the
correct invariant.

**Required fixes:**
1. Specify WHERE EC-16 flatten runs: INSIDE the `End(TagEnd::Item)` finalization arm, BEFORE
   the arm returns `Some(taskItem_node)` to the prune gate at line 608.
2. Remove the incorrect "behavior would be identical if EC-8 ran first" hedge from AC-015.
   Replace with: the both-empty input `"- [ ]\n\n  "` is the distinguishing test — if flatten
   runs first the taskItem content is empty and is pruned (correct); if the prune gate runs
   first on `[paragraph, paragraph]` (non-empty array) it would NOT prune, leaving a stray
   taskItem node (bug). The ordering is a real, test-pinned behavioral contract.
3. Confirm AC-015's both-empty sub-assertion is phrased to FAIL if prune-before-flatten is
   implemented: the assertion must state the taskItem (or its enclosing taskList) is ABSENT
   from the output.

---

### O-P2-001 — LOW: AC ordering anomaly (AC-018 before AC-017)

**Location:** Story body — AC-018 appears at lines ~482–510 (before AC-017 at lines ~514–534).

**Problem:** AC-018 is placed physically before AC-017, breaking the ascending numeric order
expected by readers and breaking the AC-count summary assumption that ACs appear in sequence.

**Required fix:** Reorder so AC-017 precedes AC-018.

---

### O-P2-002 — LOW: Delta analysis EC subset not acknowledged

**Location:** Story body — no callout that the F1 delta analysis EC list (EC-1..EC-12) is an
earlier subset of the full BC/story EC list (EC-1..EC-16).

**Problem:** A reader comparing the story's Edge Cases table (EC-001 through EC-017) against
the F1 delta analysis section "§4 Edge Cases" (EC-1..EC-12 only) may assume the delta analysis
is authoritative and the story's EC-013..EC-016 are additions that need delta-analysis sign-off.
This could cause the implementer to question whether EC-013..EC-016 are in scope.

**Required fix:** Add a one-line note in the story (e.g., in the Edge Cases section header or
as a footnote) stating: "The F1 delta analysis lists EC-1..EC-12 (an earlier subset); the BC
body and this story are authoritative for the full EC-1..EC-16 list. Do not edit the delta
analysis."

---

### O-P2-003 — LOW: AC-008 provisional F4-empirical note

**Location:** AC-008, lines ~288–308.

**Status:** CONFIRMED INTACT. The F4-empirical confirmation note is present, the fallback
test construction is specified, and BC-7.2.009 is correctly cited. No change required.

---

## Resolution

All five findings resolved. Changes made to `S-471-adf-task-lists.md`:

**F-P2-001 (is_empty_block_container structural-only):**
- File Structure item 9 expanded: explicitly states that adding `"taskItem"` to `REQUIRES_CONTENT`
  is necessary but INSUFFICIENT. Specifies the "structurally-empty inline content" branch for
  `taskItem` only (whitespace-only text nodes and/or hardBreak nodes with no other content).
  States the existing structural-only semantics for the 8 existing types MUST NOT change.
- Implementation Notes expanded with the same detail.
- AC-009 expanded with a regression assertion: the 8 existing container types retain
  structural-only emptiness semantics (existing `test_is_empty_block_container_membership` pin
  must still pass after adding the `taskItem` branch).

**F-P2-002 (EC-16-before-EC-8 ordering not pinned):**
- File Structure item 6 updated: specifies EC-16 inline-flattening runs INSIDE the
  `End(TagEnd::Item)` finalization arm, BEFORE returning `Some(taskItem_node)` to the prune
  gate at ~line 608.
- Implementation Notes expanded: states the flatten runs inside the match arm, not in a
  post-finish() pass.
- AC-015 revised: removed the incorrect "behavior would be identical if EC-8 ran first" hedge.
  Replaced with the correct invariant: the both-empty `"- [ ]\n\n  "` input OBSERVABLY
  distinguishes the two orderings — flatten-first produces empty content → pruned; prune-first
  on `[paragraph, paragraph]` (non-empty array) would NOT prune (bug). The both-empty
  sub-assertion is explicitly phrased to FAIL if prune-before-flatten is implemented (asserts
  taskItem/taskList is ABSENT from output).

**O-P2-001 (AC ordering):**
- Reordered: AC-017 now appears before AC-018 in the story body.

**O-P2-002 (delta analysis EC subset):**
- Added a one-line note in the Edge Cases section header: "Note: The F1 delta analysis
  lists EC-1..EC-12 (an earlier subset). The BC body and this story are authoritative
  for the full EC-1..EC-16 list. Do not edit the delta analysis."

**O-P2-003 (AC-008 note):** No change required — confirmed intact.

**AC count after revision: 18** (unchanged — no new ACs added).
**Test name count after revision: 19** (unchanged).
**Stories count: 67** (unchanged — story revision, not a new story addition).
