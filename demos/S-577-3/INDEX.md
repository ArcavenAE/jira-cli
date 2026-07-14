# S-577-3 Demo Evidence

Story: `comment delete` handler + JR_STDIN_IS_TTY seam + shared --id validation  
Branch: `feat/comment-delete-handler`  
Head: `3d9b7db`  
Test file: `tests/comment_delete.rs`  
Release gate: `tests/jr_stdin_is_tty_release_gate.rs`  
Captured: 2026-07-13

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test --test comment_delete` | 10/10 green |

## Per-AC Evidence

All 9 story ACs used test-run captures via `cargo test -- <test_name> --nocapture`.
No raw binary invocations: the handler tests require a wiremock HTTP stub (AC-001/002/004/005/008/009)
or rely on the JR_STDIN_IS_TTY seam set via `Command::env` in the subprocess harness (AC-004/009).
Running the raw binary without a wiremock server would fail on auth/connection.

| AC | BC Anchor | Demo File | Test Function | Method | Result |
|----|-----------|-----------|---------------|--------|--------|
| AC-001 | BC-3.5.002 | `ac-001-002-delete-204.txt` | `test_bc_3_5_002_delete_204_human_output_yes` | test-run capture | ok |
| AC-002 | BC-3.5.002 | `ac-001-002-delete-204.txt` | `test_bc_3_5_002_delete_204_json_output_key_set` | test-run capture | ok |
| AC-003 | BC-3.5.003 | `ac-003-no-input-refusal.txt` | `test_bc_3_5_003_no_input_without_yes_exits_64_no_delete` | test-run capture | ok |
| AC-004 | BC-3.5.003 | `ac-004-interactive-cancel.txt` | `test_bc_3_5_003_interactive_cancel_json_key_set` | test-run capture (JR_STDIN_IS_TTY=1 via Command::env) | ok |
| AC-005 | BC-3.5.004 | `ac-005-404-body-surface.txt` | `test_bc_3_5_004_delete_404_exits_64_with_body` | test-run capture | ok |
| AC-006 | BC-3.5.002 EC-3.5.002-1 | `ac-006-invalid-id.txt` | `test_bc_3_5_002_ec1_delete_invalid_id_regex_exits_64` | test-run capture | ok |
| AC-007 | BC-3.5.003 / BC-3.5.006 | `ac-007-release-gate.txt` | `test_jr_stdin_is_tty_cfg_gate_present_in_main_source` | test-run capture | ok |
| AC-008 | BC-3.5.002 EC-3.5.002-2 | `ac-008-url-encoding.txt` | `test_bc_3_5_002_ec2_delete_key_url_encoding` | test-run capture (server-side URL assertion) | ok |
| AC-009 | BC-3.5.003 EC-3.5.003-3 | `ac-009-eof-exit-130.txt` | `test_bc_3_5_003_ec3_delete_prompt_eof_exits_130` | test-run capture (JR_STDIN_IS_TTY=1 via Command::env) | ok |

## Extra Tests (Mutation-Kill, Not AC-Mapped)

Two extra tests in `tests/comment_delete.rs` beyond the 9 AC-mapped ones:

| Test | Kills |
|------|-------|
| `test_bc_3_5_003_interactive_confirm_y_sends_delete` | `&&` → `\|\|` mutant at answer-check condition; confirms "y" stdin sends the DELETE |
| `test_bc_3_5_004_delete_500_exits_1_not_64` | Guard mutations in 404/403 re-wrap block; 500 propagates as exit 1 (not exit 64) |

Both pass in `full-suite.txt`.

## Key Implementation Notes

- AC-004 and AC-009 require `JR_STDIN_IS_TTY=1` via `Command::env` in the test subprocess.
  Without the seam, piped stdin auto-sets `no_input=true` → exit 64 (not exit 130 for AC-009,
  not interactive cancel for AC-004). The seam suppresses the auto-flip in debug builds only.
- AC-003 uses `--no-input` flag directly — the seam is irrelevant to this path.
- AC-007 (`jr_stdin_is_tty_release_gate.rs`) uses the adjacency-window pattern (not bare
  presence check) to verify `#[cfg(debug_assertions)]` is within 5 lines of the env-var
  read in `src/main.rs`.
- AC-008 inspects `server.received_requests().await[0].url.as_str()` server-side to verify
  the wire-level URL — the URL encoding lives in `delete_comment` in `src/api/jira/issues.rs`
  (delivered in S-577-2).
