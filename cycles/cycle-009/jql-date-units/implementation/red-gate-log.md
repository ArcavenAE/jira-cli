# Red Gate Log — cycle-009 (jql-relative-date-units)

**Scope:** F4 Red Gate for the `src/jql.rs::validate_duration` fix that rejects the
relative-date units `M` (month) and `y` (year), accepting only case-sensitive
lowercase `{w,d,h,m}`, and emits the F2-approved canonical error string:

```
Invalid duration '{s}'. Use a number followed by w, d, h, or m (e.g., 7d, 4w, 12h). For month or year ranges, use --created-after/--created-before or --updated-after/--updated-before.
```

Worktree: `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/cycle-009-jql-date-units`
Branch: `fix/jql-reject-month-year-units`

All tests below were confirmed to compile and FAIL against the current (pre-fix)
implementation of `validate_duration`, which still accepts `M`/`y` and emits the
old error string (`"...y, M, w, d, h, or m..."`, no trailing hint sentence).

## A. Integration tests (`tests/issue_commands.rs`)

Added after the S-579-1 `--updated-recent` test block (BC-2.1.023), before the
S-588-1 `--sort` section header. Reuses the `s606_1_*` harness helpers
(`s606_1_cmd`, `s606_1_mock_project_exists`, `s606_1_mock_search_empty`,
`s606_1_expect_zero_http`) already defined in the file.

| Test | Result | Failure detail |
|---|---|---|
| `test_issue_list_recent_month_unit_rejects_pre_http` (`--recent 2M`) | **FAILED** (expected) | `assertion left == right failed: --recent 2M (month unit) must exit 64 (UserError), got: Some(0)` |
| `test_issue_list_recent_year_unit_rejects_pre_http` (`--recent 1y`) | **FAILED** (expected) | `assertion left == right failed: --recent 1y (year unit) must exit 64 (UserError), got: Some(0)` |
| `test_issue_list_updated_recent_month_unit_rejects_pre_http` (`--updated-recent 2M`) | **FAILED** (expected) | `assertion left == right failed: --updated-recent 2M (month unit) must exit 64 (UserError), got: Some(0)` |
| `test_issue_list_updated_recent_year_unit_rejects_pre_http` (`--updated-recent 1y`) | **FAILED** (expected) | `assertion left == right failed: --updated-recent 1y (year unit) must exit 64 (UserError), got: Some(0)` |
| `test_issue_list_recent_uppercase_month_single_digit_rejects_pre_http` (`--recent 1M`, case boundary) | **FAILED** (expected) | `assertion left == right failed: --recent 1M (uppercase month unit) must exit 64 (UserError), got: Some(0)` |
| `test_issue_list_recent_lowercase_minutes_does_not_reject` (`--recent 30m`, case boundary — accepted shape) | **PASSED** (control, not part of Red Gate — asserts pre-existing accepted behavior continues to work) | n/a |

Command run:
```
cargo test --test issue_commands -- \
  test_issue_list_recent_month_unit_rejects_pre_http \
  test_issue_list_recent_year_unit_rejects_pre_http \
  test_issue_list_updated_recent_month_unit_rejects_pre_http \
  test_issue_list_updated_recent_year_unit_rejects_pre_http \
  test_issue_list_recent_uppercase_month_single_digit_rejects_pre_http \
  test_issue_list_recent_lowercase_minutes_does_not_reject
```
Result: `test result: FAILED. 1 passed; 5 failed; 0 ignored; 0 measured; 238 filtered out`

Root cause of failures (expected): current `validate_duration` still accepts `2M`,
`1y`, and `1M` as well-formed, so `handle_list` proceeds past validation and issues
a (mocked, zero-assertion) HTTP call, exiting 0 instead of 64 with a
`JrError::UserError`.

## B. Unit tests (`src/jql.rs`, `#[cfg(test)] mod tests`)

Adjusted the two pre-existing tests that encoded the OLD (now-superseded)
contract, per CLAUDE.md's "only modify a test when requirements have changed"
carve-out:

- `validate_duration_valid_months_uppercase` → renamed
  `validate_duration_rejects_month_uppercase`, flipped `.is_ok()` → `.is_err()`.
- `validate_duration_valid_years` → renamed `validate_duration_rejects_year`,
  flipped `.is_ok()` → `.is_err()`.

Added two new tests pinning the canonical F2-approved error string verbatim:

- `validate_duration_month_rejection_uses_canonical_error_string`
- `validate_duration_year_rejection_uses_canonical_error_string`

Added two new tests confirming lowercase units remain accepted (not expected to
fail, control coverage per the task brief):

- `validate_duration_accepts_lowercase_minutes` (`"30m"`)
- `validate_duration_accepts_lowercase_weeks` (`"4w"`)

Left untouched (per instructions): `validate_duration_multibyte_unit_returns_err_not_panic`
and the `proptests::validate_duration_never_panics` proptest — panic-safety
coverage, not part of this Red Gate's scope. Note for the implementer: the
multibyte test's substring assertion (`err.contains("y, M, w, d, h, or m")`) is
pinned to the OLD error phrasing and will need updating to the new phrasing
(`"w, d, h, or m"`) once `validate_duration`'s message changes — flagged here,
not fixed, since touching non-M/y-specific existing assertions was out of scope
for this Red Gate.

Command run: `cargo test --lib jql::`
Result: `test result: FAILED. 45 passed; 4 failed; 0 ignored; 0 measured; 1524 filtered out`

```
test jql::tests::validate_duration_rejects_year ... FAILED
test jql::tests::validate_duration_rejects_month_uppercase ... FAILED
test jql::tests::validate_duration_month_rejection_uses_canonical_error_string ... FAILED
test jql::tests::validate_duration_year_rejection_uses_canonical_error_string ... FAILED

---- jql::tests::validate_duration_rejects_year stdout ----
thread 'jql::tests::validate_duration_rejects_year' panicked at src/jql.rs:216:9:
assertion failed: validate_duration("1y").is_err()

---- jql::tests::validate_duration_rejects_month_uppercase stdout ----
thread 'jql::tests::validate_duration_rejects_month_uppercase' panicked at src/jql.rs:211:9:
assertion failed: validate_duration("2M").is_err()

---- jql::tests::validate_duration_month_rejection_uses_canonical_error_string stdout ----
thread '...' panicked at src/jql.rs:224:43:
called `Result::unwrap_err()` on an `Ok` value: ()

---- jql::tests::validate_duration_year_rejection_uses_canonical_error_string stdout ----
thread '...' panicked at src/jql.rs:237:43:
called `Result::unwrap_err()` on an `Ok` value: ()
```

## Compile / format checks

- `cargo build --tests --test issue_commands` — clean, no errors.
- `cargo build --lib` — clean, no errors.
- `cargo fmt --all -- --check` — clean, no diff.

## Red Gate verdict: SATISFIED

All new tests targeting the M/y-rejection behavior compile and fail against the
current implementation for the correct reason (wrong exit code / wrong `Result`
variant), not a build error. `src/jql.rs::validate_duration`'s function body was
NOT modified — implementation is deferred to F4's implementer step.
