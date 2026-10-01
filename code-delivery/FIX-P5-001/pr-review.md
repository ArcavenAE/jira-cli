## PR Review — #891 (FIX-P5-001, SEC-001) — Cycle 1

**Verdict: REQUEST_CHANGES** (1 blocking, 8 non-blocking)

The sanitization fix is correct and complete: `sanitize_table_cell` runs inside `render_table` and `render_table_with_styles`, so every caller is covered. That includes the 9 direct `render_table` sites (`issue/attachments.rs` x4, `assets/view.rs` x2, `assets/schemas.rs`, `auth/list.rs`, `issue/view.rs`), roughly 30 `print_output` sites, and the 2 `user.rs` styled sites. There is no other production `comfy_table::Table` construction, and no other caller puts `colored` ANSI into cells. The JSON arms stay raw and lossless. Clippy (`-D warnings`) and `fmt --check` are clean, and the targeted tests pass (output:: 49, cli::user 9, table_output_sanitization 34).

### Blocking

**B-1: The styled path has no tests for its sanitization or its styling.** No test anywhere calls `render_table_with_styles` or `print_output_with_styles`. `jr user list`/`view` (whose display name and email are server-supplied) render only through this path. A regression to `Cell::new(&c.text)` would reopen SEC-001 for user commands, and every test would still pass. `fg` application is also unverified. `test_bc_7_1_006_rendered_table_still_shows_active_glyph...` uses `format_user_row` + plain `render_table`, which is not the production path. `test_bc_7_1_006_structural_cell_styling_technique_survives_rendering` exercises only `comfy_table`.
Fix:
- Add a unit test with hostile `StyledCell`s (plain and colored) through `render_table_with_styles`, asserting that no ESC or C1 bytes survive.
- Add a hostile-display-name `jr user list` case, table and JSON, to `tests/table_output_sanitization.rs`.
- Optionally, extract the private `Table` builder so a test can call `force_no_tty().enforce_styling()` and assert that `fg` is applied.

### Non-blocking

- **N-1: Some comments are stale Red Gate text that now describes the opposite of the code.**
  - `output.rs` test-section headers say "`todo!()` stub ... MUST currently FAIL" and "NOT wired into `render_table` yet".
  - The `tests/table_output_sanitization.rs` module doc still says the sanitizer is an unwired stub.
  - `user.rs` test docs still say "`format_active` does TODAY via `colored`" and "F6's job".
- **N-2: The `sanitize_table_cell` rustdoc has inaccurate claims.**
  - "`print_output`'s Table arm is its only production call site" is false (there are 9 direct sites plus the styled variant).
  - "EC-1..EC-12 ... once implemented" is outdated: EC-13 exists and the function is implemented.
- **N-3: The CLAUDE.md size entry is out of date.** It says "~1,004 LOC" (actual: 1,118 after `7d289d75`) and "EC-1..EC-12 pins" (EC-13 is also pinned).
- **N-4: There is duplication.** `render_table_with_styles` repeats `render_table`'s setup and header-sanitize block, and `print_output_with_styles` repeats `print_output`. Extract a private `base_table(headers)` helper, or make `render_table` delegate to the styled version.
- **N-5: `format_user_row_styled` depends on column order.** It indexes `plain[0]`, `[1]`, and `[3]` and discards `[2]`, so reordering `format_user_row` would silently put values in the wrong columns. Build the row from `user` fields instead.
- **N-6: Color handling works but has one small behavior change.** `--no-color`/`NO_COLOR` is correctly preserved through the `SHOULD_COLORIZE` gate, and the tests use a mutex-serialized RAII guard. However, color now also requires `comfy_table`'s TTY check, so `CLICOLOR_FORCE=1` with piped stdout no longer colors the Active glyph. This is minor; accept it or note it in the CHANGELOG.
- **N-7: Unicode coverage is limited to override characters.** LRM/RLM/ALM (U+200E/U+200F/U+061C) and zero-width characters are not stripped; this matches the existing set, so it is acceptable as a documented residual. U+0085 is listed twice, which is harmless.
- **N-8: Some output is outside BC-7.1.006's scope.** Human-mode output that bypasses the table (success messages that echo server strings, raw `jr api` output) is not sanitized. Consider a follow-up.

### Edge-case coverage

EC-1 through EC-13 each have inline pins. Three proptests run at 1000 cases (whole-string invariant with `\n` count `<=`, identity on clean input, and exact `\n` preservation when there is no unterminated escape), and their generator reasoning is sound. End-to-end table/JSON asymmetry is covered for `field options` and `issue list`. The only gap is B-1.

---

## PR Review — #891 (FIX-P5-001, SEC-001) — Cycle 2

**Verdict: APPROVE.** No findings are blocking, so the review has converged. This review covers commit `924975f0`.

### B-1: Closed

The new tests call the styled path directly:
- Unit tests in `src/output.rs` pass hostile `StyledCell::plain`, `StyledCell::colored` and header values through `render_table_with_styles`. There is also a table/JSON call test for `print_output_with_styles`.
- `tests/table_output_sanitization.rs` has an end-to-end `jr user list` case in both table mode (sanitized) and `--output json` mode (raw, round-trips exactly).

**Mutation check.** I reverted `src/output.rs:91` to `Cell::new(&c.text)` to confirm the tests catch the regression:
- Both new styled unit tests failed.
- `test_bc_7_1_006_user_list_table_mode_strips_hostile_display_name` also failed. Its stdout showed the raw `\u{1b}[31mFAKE...` in the Display Name column.
- I then restored the file and confirmed the worktree is clean.

The regression is now caught at two independent layers.

### N-1 / N-2 / N-3

- **N-2: Fixed.** The rustdoc now names both chokepoints. I confirmed by grep that there are 9 direct production `render_table` sites; the call in `user.rs` is test-only. The rustdoc now cites EC-1..EC-13.
- **N-3: Fixed.** CLAUDE.md says ~1,235 LOC, and the actual count is 1,234. It says ~424 LOC of production code, and `#[cfg(test)]` is at line 424.
- **N-1: Mostly fixed.** Three stale Red Gate comments remain (non-blocking):
  - `src/cli/user.rs:424`: "GREEN today … once `format_active`'s styling moves to structural `Cell` attributes". That move has already happened.
  - `tests/table_output_sanitization.rs:237`: "`sanitize_table_cell`, which doesn't exist in any call graph yet". This is now false.
  - `tests/table_output_sanitization.rs:321`: "Expected GREEN today".

### New non-blocking findings

- **NB-a:** `test_bc_7_1_006_print_output_with_styles_does_not_error_on_hostile_cells` only asserts `Ok(())`, so it cannot detect a dispatch-site bypass. Its doc says so, and the end-to-end test covers that path.
- **NB-b:** The `jr user list` table-mode end-to-end test has no positive assertion that the display name reached stdout (for example `contains("pwned")`).
- N-4 through N-8 remain out of scope, as agreed. None of them is blocking.

### Gates (worktree at `924975f0`)

- `cargo fmt --all -- --check`: clean.
- `cargo clippy --all-targets -- -D warnings`: clean.
- `cargo test`: 5,854 passed, 0 failed.
