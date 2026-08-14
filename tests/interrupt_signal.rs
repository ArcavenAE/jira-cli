//! VP-MUTANTS-SCOPE-1-001 (BC-X.3.006): out-of-process SIGINT observation.
//!
//! Spawns the compiled `jr` binary, sends it a real `SIGINT`, and asserts on
//! the REAL child process's exit code and REAL stderr. This is the only test
//! shape that can kill the `130` literal-substitution mutant and the
//! `eprintln!("\nInterrupted")` statement-deletion mutant on `run()`'s
//! `tokio::select!` ctrl_c fork — an in-process test cannot observe
//! `std::process::exit` or a sibling process's own stderr (see
//! `.factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md`,
//! "Why refactor alone is insufficient").
//!
//! `#[cfg(unix)]`-gated (`SIGINT`/`libc::kill` are Unix-only; `tokio::signal::
//! ctrl_c()` itself is portable, but the *test delivery mechanism* is not —
//! see BC-X.3.006 and the Out of Scope section of S-MUTANTS-SCOPE-1). Raw
//! `std::process::Command` is used instead of `assert_cmd`, because
//! `assert_cmd` exposes no running-`Child` handle and cannot deliver a
//! mid-run signal.
//!
//! ## Readiness-handshake seam contract (REQUIRED, implementer must match)
//!
//! `tokio::signal::ctrl_c()` only registers its OS-level signal listener the
//! first time it is polled inside `select!` (BC-X.3.006 EC-1 — the
//! "registration race"). Sending `SIGINT` before that registration completes
//! falls through to the process's default disposition (immediate
//! termination, NOT exit 130, NOT `"\nInterrupted\n"`). A fixed `sleep` is
//! explicitly forbidden as a substitute (architecture rule, BC-X.3.006 EC-1) —
//! this test instead requires a deterministic, debug-only readiness seam:
//!
//! - Env var `JR_TEST_BLOCK_UNTIL_SIGINT=1`, read only in
//!   `#[cfg(all(debug_assertions, unix))]` builds — stricter than the
//!   `#[cfg(debug_assertions)]`-only seam convention used by `JR_STDIN_IS_TTY`
//!   / `JR_BASE_URL` / etc. (see CLAUDE.md "AI Agent Notes"): this seam adds
//!   a `unix` conjunct because `SIGINT` delivery via `libc::kill` is
//!   Unix-only.
//! - When set, `run()` — after entering `run_until_shutdown` (i.e. once the
//!   `ctrl_c` future has actually been polled at least once) — prints the
//!   literal line `JR-TEST-READY` to stdout, then blocks using a `work`
//!   future that never resolves (`std::future::pending::<()>()`) so the only
//!   way the process can end is via the shutdown/interrupt arm.
//! - This test does not care which subcommand is invoked (the seam
//!   short-circuits before real dispatch) — `me` is used because it needs no
//!   positional arguments.
//!
//! The seam is implemented in `src/main.rs` (see `block_until_sigint_test_seam`
//! / `JR_TEST_BLOCK_UNTIL_SIGINT`, S-MUTANTS-SCOPE-1). If the readiness marker
//! never arrives, this test fails via a bounded-timeout panic rather than
//! hanging the suite — see `READY_TIMEOUT` below.
//!
//! Everything the `#[cfg(unix)]` test below needs lives inline inside that
//! single `#[cfg(unix)] #[test]` function — no helper function or const is
//! declared outside of it — so there is nothing left over to orphan as
//! dead code on a non-Unix build (round-15 CLAUDE.md Windows dead-code-lint
//! hazard; see `docs/specs/cargo-mutants-policy.md` history and
//! S-MUTANTS-SCOPE-1 AC-011).

#[cfg(unix)]
#[test]
fn test_sigint_during_run_exits_130_with_byte_exact_interrupted_stderr() {
    use std::io::{BufRead, BufReader, Read};
    use std::process::{Command, Stdio};
    use std::sync::mpsc;
    use std::time::{Duration, Instant};

    const READY_MARKER: &str = "JR-TEST-READY";
    const READY_TIMEOUT: Duration = Duration::from_secs(10);

    let mut child = Command::new(env!("CARGO_BIN_EXE_jr"))
        .env("JR_TEST_BLOCK_UNTIL_SIGINT", "1")
        // Subcommand choice is irrelevant once the readiness seam
        // short-circuits real dispatch (see module doc). "me" needs no
        // positional args.
        .arg("me")
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("failed to spawn compiled jr binary (CARGO_BIN_EXE_jr)");

    let stdout = child
        .stdout
        .take()
        .expect("child stdout was not piped — Stdio::piped() should guarantee this");
    let stderr = child
        .stderr
        .take()
        .expect("child stderr was not piped — Stdio::piped() should guarantee this");

    // Reader thread: watches stdout for the deterministic readiness marker.
    // This is NOT a fixed sleep (BC-X.3.006 EC-1 forbids that) — we block on
    // the marker itself, bounded only by READY_TIMEOUT so a missing/broken
    // seam fails this test with a clear panic instead of hanging the suite.
    let (ready_tx, ready_rx) = mpsc::channel::<String>();
    let stdout_reader_handle = std::thread::spawn(move || {
        let reader = BufReader::new(stdout);
        for line in reader.lines() {
            match line {
                Ok(l) => {
                    let is_ready = l.trim() == READY_MARKER;
                    if ready_tx.send(l).is_err() {
                        break;
                    }
                    if is_ready {
                        break;
                    }
                }
                Err(_) => break,
            }
        }
    });

    let mut saw_ready = false;
    let deadline = Instant::now() + READY_TIMEOUT;
    while Instant::now() < deadline {
        let remaining = deadline.saturating_duration_since(Instant::now());
        match ready_rx.recv_timeout(remaining) {
            Ok(line) if line.trim() == READY_MARKER => {
                saw_ready = true;
                break;
            }
            Ok(_) => continue,
            Err(_) => break,
        }
    }

    if !saw_ready {
        let _ = child.kill();
        let _ = child.wait();
        let _ = stdout_reader_handle.join();
        panic!(
            "child jr process never printed the '{READY_MARKER}' readiness marker \
             within {READY_TIMEOUT:?}. The #[cfg(all(debug_assertions, unix))]-gated \
             seam (env var JR_TEST_BLOCK_UNTIL_SIGINT=1) is expected to print this marker \
             to stdout immediately after entering run_until_shutdown, then block on a \
             never-resolving work future until interrupted. See VP-MUTANTS-SCOPE-1-001 \
             / BC-X.3.006 EC-1 and this file's module doc comment for the full contract. \
             This failure indicates the seam (block_until_sigint_test_seam / \
             JR_TEST_BLOCK_UNTIL_SIGINT in src/main.rs) has regressed, or that signal \
             registration/stdout flushing broke — not a missing implementation."
        );
    }

    // Deterministic handshake complete — safe to signal now without racing
    // tokio::signal::ctrl_c()'s first-poll registration (BC-X.3.006 EC-1).
    // SAFETY: `child.id()` is a valid, live PID for a process we spawned and
    // have not yet reaped; `libc::kill` with SIGINT is the standard idiom for
    // delivering an interrupt to a specific child process in an integration
    // test (see `.factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md`).
    unsafe {
        libc::kill(child.id() as libc::pid_t, libc::SIGINT);
    }

    let stderr_reader_handle = std::thread::spawn(move || {
        let mut stderr = stderr;
        let mut buf = String::new();
        let _ = stderr.read_to_string(&mut buf);
        buf
    });

    let status = child
        .wait()
        .expect("failed to wait on child jr process after sending SIGINT");
    let _ = stdout_reader_handle.join();
    let captured_stderr = stderr_reader_handle.join().unwrap_or_default();

    // AC-009 / BC-X.3.006 Behavior item 2: exit code == 128 + SIGINT.
    assert_eq!(
        status.code(),
        Some(130),
        "expected exit code 130 (128 + SIGINT) on graceful Ctrl+C interrupt, got {:?} \
         (captured stderr: {captured_stderr:?})",
        status.code()
    );

    // AC-009 / BC-X.3.006 Behavior item 2: byte-exact stderr contribution —
    // eprintln!("\nInterrupted") appends its own trailing '\n'.
    assert_eq!(
        captured_stderr, "\nInterrupted\n",
        "expected byte-exact stderr \"\\nInterrupted\\n\" on SIGINT \
         (BC-X.3.006 Behavior item 2), got {captured_stderr:?}"
    );
}
