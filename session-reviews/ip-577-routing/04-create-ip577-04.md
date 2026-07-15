## Summary

When a story spec enumerates behavioral variants (error conditions, output modes, flag combinations) without listing the specific test-function names that cover each variant, an accounting gap opens at adversary review time. The adversary counts from the spec's stated variant list; the implementer's actual test count is derived from implementation. Both may be internally consistent, but neither can quickly verify the other — leading to MEDIUM adversary findings and fix rounds that could have been avoided.

This is the 3rd confirmed recurrence of this gap in a single project.

## Evidence — 3 recurrences in one bundle (jira-cli SOH-COMMENT-CRUD-1)

**Recurrence 1 — F3 adversary pass-25 (story S-577-6):**
S-577-6 specified 11 ACs but the story-writer derived a test count of 11 from those ACs. The adversary found that AC-3 enumerated 4 sub-variants requiring separate test functions (one per visibility flag combination), giving a true test function count of 15, not 11. The spec did not enumerate the per-variant test names. Fix required a story rewrite and AC revision before the story could proceed to F4.

**Recurrence 2 — F4 wave-C, S-577-4 step-4.5 pass-1 (MEDIUM finding):**
AC-7 enumerated a 404-preamble error condition without naming the test function that exercises it (`test_comment_edit_returns_404_on_missing_comment`). The adversary flagged a MEDIUM for missing test coverage; the implementer had written the test but it was not traceable from the AC text. Required a pass-1 fix round.

**Recurrence 3 — F4 wave-C, S-577-6 step-4.5 pass-1 (MEDIUM finding):**
AC-11 enumerated a fallback-token variant for the JSM visibility path without naming the test function. Same pattern as recurrence 2. MEDIUM adversary finding, pass-1 fix round.

**Total cost across 3 recurrences:** ~3 extra adversary pass-fix rounds (one per recurrence); plus the F3 story rewrite.

## Root Cause

Story-writers enumerate behavioral variants (error conditions, flag combinations, edge cases) in AC bodies because the spec mandates covering them. But the AC text says "test that X returns 404" without saying "and the test function for this is `test_foo_returns_404_on_bar`." When the implementer writes that test, it exists; when the adversary reviews the story, it can only confirm the test exists by searching the test file by hand — if the name is non-obvious, the adversary may assume the test is missing.

The count is always computable from the names. The names are only computable from listing them explicitly.

## Proposed Fix

**Story-writer checklist addition:**

> For any AC that enumerates N behavioral variants (e.g., "handles 3 error conditions: X, Y, Z"), the AC body MUST list the test-function name for each variant:
> ```
> - [ ] `test_foo_on_x` — covers variant X
> - [ ] `test_foo_on_y` — covers variant Y
> - [ ] `test_foo_on_z` — covers variant Z
> ```
> The total test count for the story emerges from counting these entries, not from counting ACs. An adversary can verify coverage by running `cargo test -- --list | grep test_foo`.

**Adversary checklist addition:**

> For any AC that lists behavioral variants, verify that per-variant test function names are present in the AC body. If they are absent, this is a LOW finding (story-writer gap, not implementation gap) that warrants a story revision before step-4.5 proceeds.

## Severity

LOW process-gap for individual instances; MEDIUM aggregate cost when recurrence is 3× in one bundle.

## Source

jira-cli SOH-COMMENT-CRUD-1 session review 2026-07-15 (IP-577-04). Codified in `.factory/cycles/cycle-001/lessons.md` as PG-F4-7 (SPEC-ENUMERATED-VARIANTS-WITHOUT-ENUMERATED-TESTS, recurrence 3) and PG-F3-2. Related: #481 (AC-named test targets must be verifiable at story-authoring time), #602 (test-input recipes without physical-reachability verification).
