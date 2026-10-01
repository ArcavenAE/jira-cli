## PR Review — #894 (FIX-P5-002, BC-7.1.006 CR-1/CR-2) — Cycle 1

**Verdict: REQUEST_CHANGES** (1 blocking, 2 non-blocking). This review covers commit `3ef98c15`.

The code changes are correct and complete. The one blocking finding is comment-only.

### Verified

- **CR-1 wiring is complete.** `sanitize_terminal_line` is used at every sink the PR description names:
  - `interactions.rs:663-676`: all 6 labeled fields. The ADF body at `:695` correctly stays on `sanitize_terminal_text`.
  - `workflow.rs:1087,1111`: both assign success messages.
  - `helpers.rs`: `disambiguation_labels` (289/292/296), the non-interactive `ExactMultiple` path (369/370/373), and `Ambiguous` (402). The `Ambiguous` value feeds both the error message and the `Select` items. The `None`/`all_names` echo is at 430.
  - `sanitize_terminal_text` now has exactly one caller (`interactions.rs:695`), which matches its new rustdoc.
- **Policy parity.** The per-character closure in `sanitize_terminal_line` is identical to `sanitize_table_cell`'s, except that `'\n'` becomes `Replace(' ')`. A proptest checks that both functions give the same output on input without `\n`. Another proptest checks that the output never contains `\n`.
- **CR-2 gate.** `render_table_with_styles_inner` applies `fg` only when `SHOULD_COLORIZE.should_colorize()` is true. Production code always passes `force_styling=false`, so no other behavior changes. Two tests force styling on and cover both directions. They serialize the global `colored` override with a mutex and restore it through an RAII guard.
- **Caller-list correction is accurate.**
  - `resolve_assignee` is called from `workflow.rs:1061` (assign `--to`).
  - `resolve_assignee_by_project` is called from `create.rs:350` (create `--to`).
  - `resolve_user` is called from `list.rs:302,307` (`--assignee`/`--reporter`).
  - `resolve_at_name_candidate` is in `mentions.rs`.
- **The F-005 retraction is accurate.** The `MatchResult::Ambiguous` arm carries only display-name strings.
- **Tests:** `cargo test --lib output::` reports 63 passed, 0 failed, matching the PR's claim.

### Blocking

**B-1 (MEDIUM): Stale Red-Gate comments now make false claims about the shipped code.** The PR's stated scope includes doc accuracy with no new false claims. These comments came from the failing-tests commit `df79e4e9` and were not updated after the implementation landed:
- `src/output.rs:1448-1452` says `sanitize_terminal_line` "is a `todo!()` stub … not yet wired into any call site … MUST FAIL".
- `src/output.rs:~1612` says "today it applies `fg` UNCONDITIONALLY … that check currently lives only in `active_cell`". The same doc comment contradicts this a paragraph later.
- `src/output.rs:~1651` says "Expected GREEN today: this is `render_table_with_styles`'s existing unconditional-`fg`-application behavior".
- `tests/table_output_sanitization.rs:1575-1581` says the function is a "`todo!()` stub, NOT YET wired … all currently still route through … `sanitize_terminal_text` … expected to FAIL (RED)".
- `tests/table_output_sanitization.rs:~1617, ~1679, ~1721` say "Expected RED today: … still sanitizes … via `sanitize_terminal_text`".
- `tests/table_output_sanitization.rs:~1772` says "the underlying `sanitize_terminal_text` call already covers …". The disambiguation path now uses `sanitize_terminal_line`.

Fix: reword each comment to describe the current behavior, for example "pins EC-17 behavior; RED before 8f206627". This is a docs-only commit with no code or test-logic change.

### Non-blocking

- **N-1:** `CLAUDE.md` says `output.rs` is "1,662 LOC". `wc -l` reports 1669. Suggest "~1,669".
- **N-2:** The `sanitize_terminal_text` rustdoc says "exactly one sanitization implementation … does not duplicate or fork the policy". `sanitize_terminal_line` copies the per-character closure; only the core scanner is shared. A proptest guards against drift. Either soften the wording or extract a shared helper. This could go in OUTPUT-SANITIZER-CLEANUP-NITS.

### Acknowledged, tracked, out of scope (D-396)

CREATE-TO-ECHO-SANITIZE (F-003, correctly documented in CHANGELOG as a new residual), AMBIGUOUS-PICKER-ACCOUNT-LABELS, and OUTPUT-SANITIZER-CLEANUP-NITS.

---

## PR Review — #894 (FIX-P5-002, BC-7.1.006 CR-1/CR-2) — Cycle 2

**Verdict: APPROVE.** This review covers commit `33286d9a` (the B-1 fix).

### Verified

- Commit `33286d9a` touches only comments/doc-comments in `src/output.rs` and
  `tests/table_output_sanitization.rs`. No executable code, test assertions, or test logic
  changed.
- No remaining stale claims: no "`todo!()` stub", no "Expected RED today", no "unconditional
  `fg`" language survives anywhere the commit touched. Re-checked against the actual call sites
  (`interactions.rs:663-676`, `workflow.rs:1087/1111`, `helpers.rs:289`) and the CR-2 gate
  (`output.rs:112-119`) — all consistent with the reworded comments.
- Tests re-run: `cargo test --lib output::` 63/63 passed; `cargo test --test
  table_output_sanitization` 58/58 passed — same counts as cycle 1, confirming no test-logic
  drift.
- N-1 and N-2 (cycle 1 non-blocking NITs) are unchanged by this commit, as expected (it didn't
  touch CLAUDE.md or `sanitize_terminal_text`'s rustdoc).

### Non-blocking (new, does not block approval)

- **N-3:** `StyledCell::colored`'s doc comment (`src/output.rs:58-61`, inherited from base PR
  #891, not introduced by this PR) still says the caller alone decides whether to colorize and
  describes `fg` as applied unconditionally by the renderer. As of CR-2, `render_table_with_styles`
  itself also gates `fg` on `SHOULD_COLORIZE`, so this doc comment is now slightly stale — a
  one-line reword would bring it in line with the already-correct `render_table_with_styles_inner`
  doc comments. Pre-existing from #891's base, out of this PR's D-396 scope; tracked alongside
  `OUTPUT-SANITIZER-CLEANUP-NITS`.

### Convergence

Cycle 1: REQUEST_CHANGES (B-1 blocking) → implementer fix (commit `33286d9a`) → Cycle 2: **APPROVE**.
0 blocking findings remain. Converged in 2 cycles.
