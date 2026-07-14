## PR #619 Review — chore(comments): correct stale stub claims in src comments (#577)

> Note: recorded as a review comment because GitHub blocks the PR author from formally approving their own PR. The verdict below is an unambiguous APPROVE.

### VERDICT: APPROVE

A clean, correctly-scoped comment-only fix. Both replacement comments are accurate against the shipped code, and the diff contains zero behavior change (only comment text on 4 lines across 2 files).

### Spot-check results (all CONFIRMED)

**Finding 1 — `src/cli/issue/mod.rs` dispatch comment — ACCURATE**
- `handle_comment_edit` (`interactions.rs::handle_comment_edit`) is fully implemented — no `todo!()`.
- Visibility flags are genuinely deferred: the destructure binds `internal: _`, `public: _`, `yes: _` (ignored), and the HTTP PUT step passes `None` for visibility with the inline note `body-only (None = no visibility flag, this story's scope)`.
- The "consumed in S-577-5" attribution matches the repo's own forward reference (CLAUDE.md: "will also be used by the comment_edit integration tests when S-577-5 is implemented (VP-577-029)").
- The mechanical claim (whole `Edit` variant passed so the handler can destructure) matches the signature `handle_comment_edit(sub: CommentSubcommand, ...)`.

**Finding 2 — `src/cli/issue/interactions.rs` test comment — ACCURATE**
- `handle_comment_view` (`interactions.rs::handle_comment_view`) is fully implemented — no `todo!()`.
- `tests/comment_view.rs` exists with 14 subprocess tests exercising the handler, so "its own subprocess coverage in tests/comment_view.rs" is correct.
- The test itself (`test_bc_3_5_010_ec2a_adf_error_propagates_exit64`) does call `adf_to_text` directly and is genuinely independent of the handler — the revised wording is more accurate than the removed "the handle_comment_view stub being todo!() does NOT affect this test."

**Red Gate provenance docstrings intentionally untouched — CONFIRMED CORRECT**
- The `//! Red Gate: ... is todo!()` docstrings in `tests/comment_edit.rs`, `tests/comment_view.rs`, `tests/comment_delete.rs`, `tests/issue_open.rs` describe the *historical* Red Gate snapshot (why each test failed against the stub at TDD time), not the code's current state. Leaving them untouched is consistent with the established convention already shipped in `comment_delete.rs`. Correctly scoped out.

**No other stale stub language in the 2 changed files — CONFIRMED**
- Grep for stub/todo!/unimplemented/"when implemented"/"not yet" across both changed files returns nothing. No stubs remain anywhere in `src/cli/issue/`.

### Findings

**NIT (non-blocking):** The module-level docstrings in `tests/comment_edit.rs` and `tests/comment_view.rs` use present-tense phrasing — `//! Red Gate: all tests FAIL because handle_comment_edit is todo!()` — which reads as a current-state claim even though the handler now ships. This is arguably the same stale-claim class this PR sweeps in `src/`, just in `tests/`. The PR deliberately classifies these as provenance (a defensible, convention-consistent decision — `comment_delete.rs` already ships identical phrasing), so this is not a merge blocker. If a future sweep wants to harden against reader confusion, prefixing with "At Red Gate:" or past tense ("failed because ... was todo!()") would remove the ambiguity. No action required for this PR.

### Checklist summary
- Diff coherence: all 4 changed lines relate to #577. ✓
- Description accuracy: PR body matches the actual changes. ✓
- Diff size: trivial (2 files, 4 lines). ✓
- Correctness: both comments now match shipped behavior. ✓

Recommend merge.
