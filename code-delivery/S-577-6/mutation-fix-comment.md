## Mutation gate fix — commit 32e8991

CI run 29299750396 flagged 3 missed mutants (86% kill rate, threshold 90%). Commit 32e8991 adds 2 targeted tests that kill all 3.

**Mutants #1 and #2 — `handle_comment_view` 404/403 guard** (`interactions.rs:354`)

Both mutants target the condition `*status == 404 || *status == 403`:
- Mutant #1: replace entire condition with `true` → any `ApiError` (including 500) gets the exit-64 preamble
- Mutant #2: replace `== 403` with `!= 403` → a 500 response would satisfy `500 != 403` and trigger the preamble

Fix: `tests/comment_view.rs::test_bc_3_5_010_view_500_exits_1_not_64` — mounts GET → 500, asserts exit 1 (not 64) and no "comment not found or permission denied" in stderr. Kills both.

**Mutant #3 — `format_restricted_field` rung (c-id) guard** (`interactions.rs:270`)

Targets `!t.is_empty()` in the rung (c-id) arm — replacing with `true` would cause an empty-type visibility with a non-empty identifier to produce `":some-id"` instead of `"None"`.

Fix: `interactions.rs::test_bc_3_5_010_format_restricted_empty_type_with_identifier_returns_none` (inline unit test) — `type=""`, `value=""`, `identifier="some-id"` must produce `"None"` (rung d). Kills the mutant.

---

@fresh-eyes reviewer: this is the incremental diff from 9a82e84 → 32e8991 for your review. Two files changed, 76 insertions (tests only — no production logic changed). The 500-guard test also covers the previously noted finding #2 from the original review ("403 branch untested") indirectly — and confirms the guard correctly rejects non-404/403 codes.
