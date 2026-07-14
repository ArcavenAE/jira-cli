# PR Review — PR #616 (S-577-6, comment view handler)

**Verdict: APPROVED_WITH_COMMENTS** (green light to merge; all findings non-blocking)

Fresh-eyes review of the PR description, diff, and test evidence only.
This is a small, focused, well-tested read-only handler. No merge-blocking
correctness defects found.

## Checklist verification

- **Diff coherence:** All changes relate to S-577-6 (handler + 2 pure helpers +
  inline tests + `.cargo/mutants.toml` narrowing). No stray changes.
- **Description accuracy:** PR body matches the diff.
- **Architecture compliance:** JSON path routes through `output::render_json`
  (satisfies #526 invariant, no `to_string_pretty`); raw `serde_json::Value`
  passthrough (no typed round-trip, lossless); non-404/403 errors correctly
  re-propagate the original `e`.
- **mutants.toml:** `exclude_re` narrowed from `handle_comment_(edit|view)` to
  `handle_comment_(edit)`, re-enabling mutation coverage on the now-implemented
  `handle_comment_view`. Consistent with delivering this story.
- **Test coverage:** All 4 rungs, three JSM-internal cases, 404, invalid-id,
  JSON passthrough, body-absent, and the ADF depth-error path covered (15 tests).

## Logic traces (all correct)

- **4-rung restricted ladder:** Arms evaluate top-to-bottom; role/group with a
  value hits rung (a) and never reaches (c)/(d), so later arms only fire for
  non-role/group types. Rung-c-id case (`type=Team, value="", identifier=AlphaTeam`
  → `Team:AlphaTeam`) and all-empty role/group case (→ `None`) resolve as intended.
  No unreachable/contradictory arm.
- **JSM internal:** Iterates `properties`, matches key `sd.public.comment`, reads
  `value.internal` as bool; stringly-typed `"true"` and unknown keys both fall to
  `N/A`. Correct.
- **Error path:** 404/403 → `JrError::UserError` with two-line body surface
  (`\n{message}`); other statuses re-propagate. Correct.

## Findings

### [NON_BLOCKING] Shared-assumption risk on JSM internal property key (correctness / info-asymmetry)
Handler keys off `properties[].key == "sd.public.comment"` with nested
`value.internal`. Code and wiremock fixtures were authored together — if the
property shape is wrong, both are wrong in lockstep and the green suite won't
catch it. Worth a one-time confirmation against a live JSM comment
(`jr issue comment view … --output json`).

### [NON_BLOCKING] 403 branch untested (test-coverage)
Handler treats 404 and 403 identically, but only the 404 path is exercised. A
sibling 403 test would pin the "permission denied" half of the combined message.

### [NON_BLOCKING] Visibility with a value but missing/empty `type` renders `None` (edge case)
A malformed visibility object like `{"value":"X"}` (no `type`) falls through every
rung to `_ => "None"`, silently dropping the value. Real Jira always includes
`type`, so acceptable — flagged for conscious acknowledgment.

### [NON_BLOCKING / NIT] Rung (c) first arm could tighten its pattern (simplification)
`(t, _, _) if !t.is_empty() && !value.is_empty()` re-checks `!value.is_empty()`
in the guard; `(t, false, _) if !t.is_empty()` reads more clearly. Pure style.

## Recommended follow-ups (non-blocking)
1. Confirm `sd.public.comment` property shape against live Jira.
2. Add a 403 test mirroring the 404 test.
