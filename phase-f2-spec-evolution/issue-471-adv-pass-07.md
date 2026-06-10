---
pass: 7
issue: 471
date: 2026-06-10
verdict: CLEAN
novelty: LOW
angle: implementer-determinism
---

# Adversary Pass 7 — BC-7.2.010 (GFM Task Lists → ADF) — CLEAN (Implementer-Determinism Angle)

## Verdict Summary

CLEAN. 0 CRITICAL, 0 HIGH, 0 MEDIUM findings. 2 LOW non-blocking observations.
The spec is implementer-deterministic across forward path, reverse path, normalization,
pruning, and ordering. Both LOW items were applied as editorial polish in F2 finalization
(same commit).

## Review Angle

This pass reviewed BC-7.2.010 specifically for implementer-determinism: given the spec
alone, can a single unambiguous implementation be derived? No dimension was found to be
under-specified or ambiguous in a way that would cause two correct implementations to
diverge in observable output.

Dimensions reviewed:
- Forward path (Options, event dispatch, Approach B reclassification): deterministic.
- localId assignment (DFS pre-order, post-normalization, 1-based counter): deterministic.
- Normalization obligation ordering (normalize_list_item_content before wrap_inlines_as_blocks;
  EC-16 flatten before EC-8 prune): ordering explicitly stated, deterministic.
- Prune criteria (EC-8 hardBreak-only prune — DELIBERATE PRODUCT CHOICE noted): deterministic.
- Reverse path state comparison (case-insensitive "DONE" check, else TODO): deterministic.
- Round-trip lossiness (EC-10 a-g fully enumerated): complete, no hidden lossy transforms.
- Nested task list placement (sibling in taskList.content vs. grandparent hoist for plain list,
  EC-13 vs EC-15 distinction): deterministic, both cases separately specified.

## Findings

### LOW (non-blocking — both applied as editorial polish in F2 finalization)

1. **Stale JSDCLOUD rationale clause (LOW)**: The Required Attributes section stated
   "Counter is 1-based, matching the JSDCLOUD-15228 pattern" — this over-claims the
   source. The cited payload shows item values `"1"`/`"2"`/`"3"` but does not establish
   the list-vs-item base offset; the research §1 illustrative example is actually
   0-based. The over-claim creates confusion: an implementer could read it as mandating
   JSDCLOUD-15228 compliance rather than an internal consistency choice.
   **APPLIED FIX**: reworded to "Counter is 1-based monotonic (any non-empty string is
   schema-valid; 1-based chosen for internal consistency)." The JSDCLOUD justification
   clause was dropped.

2. **additionalProperties:false warning absent (LOW)**: The attrs specification listed
   required fields (`localId`, `state`) but never warned that the attrs objects are
   `additionalProperties: false`. An implementer adding a convenience debugging field
   (e.g., `"source": "jr"`) to the attrs would receive a Jira 400 with no indication
   from the spec that extra keys are forbidden.
   **APPLIED FIX**: added "Schema strictness note" paragraph immediately after the
   `taskItem.content` bullet: "taskList.attrs and taskItem.attrs are
   `additionalProperties: false` — emit ONLY `localId` (and `state` for `taskItem`);
   any extra attribute key is schema-invalid and will cause Jira to return HTTP 400."

## Convergence Determination

Spec is implementer-deterministic. Both LOW items were editorial (no behavioral or
ADF-logic change). F2 finalization is complete. BC-7.2.010 is ready for F3 story
decomposition and F4 TDD implementation.
