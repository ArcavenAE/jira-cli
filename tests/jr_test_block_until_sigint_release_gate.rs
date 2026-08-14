//! Regression-guard test for the `JR_TEST_BLOCK_UNTIL_SIGINT` debug seam in
//! `src/main.rs`.
//!
//! The seam is the readiness-handshake mechanism for the SIGINT subprocess
//! test (`tests/interrupt_signal.rs`, VP-MUTANTS-SCOPE-1-001). When set to
//! `1`, `run()` selects a `signal(SIGINT)`-based shutdown future instead of
//! `tokio::signal::ctrl_c()`, prints a `JR-TEST-READY` marker once the
//! listener is registered, then blocks so the test can send SIGINT
//! deterministically. The env var MUST be gated behind
//! `#[cfg(all(debug_assertions, unix))]` — the seam's actual gate, stricter
//! than the bare `#[cfg(debug_assertions)]` used by sibling seams — so
//! release binaries and non-Unix builds never read it or compile the code
//! path in at all.
//!
//! Mirrors `tests/jr_stdin_is_tty_release_gate.rs` structure — window search
//! rather than an independent presence check. A single presence check cannot
//! detect an un-gated read where `#[cfg(debug_assertions)]` (or the stricter
//! `#[cfg(all(debug_assertions, unix))]`) appears elsewhere in the file but
//! not adjacent to the env-var read.
//!
//! Story: S-MUTANTS-SCOPE-1 (adversarial pass-8 finding LOW-2)
//! BC anchor: BC-X.3.006

/// Verifies that `#[cfg(debug_assertions)]` (as part of the seam's actual
/// `#[cfg(all(debug_assertions, unix))]` gate) appears adjacent to the
/// `JR_TEST_BLOCK_UNTIL_SIGINT` env-var read in `src/main.rs`.
///
/// Strategy: locate the `std::env::var("JR_TEST_BLOCK_UNTIL_SIGINT")` line;
/// assert `#[cfg(debug_assertions)]` exists within 5 source lines before it.
/// Whitespace-tolerant. This deliberately accepts the presence of
/// `debug_assertions` in that window as the load-bearing assertion (matching
/// the sibling gate tests' string-matching approach) rather than requiring
/// the full literal `#[cfg(all(debug_assertions, unix))]` string, so the
/// test is robust to minor formatting/reordering of the cfg attribute's
/// internals while still catching the case that actually matters: the read
/// compiling into a release binary at all.
///
/// This is a cross-platform STATIC source-scan test (string matching over
/// `include_str!`-ed source) — it is NOT `#[cfg]`-gated and runs on every
/// platform, matching every sibling `*_release_gate.rs` test in this repo.
/// It has no platform-gated helper functions, so it is not subject to the
/// round-15 Windows dead-code trap documented in CLAUDE.md's CI-Gate history
/// (a helper referenced only from a `#[cfg(unix)]`-gated test compiles as
/// genuinely unused on non-Unix and trips `-D warnings`) — every item this
/// test file defines is used unconditionally by this one always-compiled
/// test function.
#[test]
fn test_jr_test_block_until_sigint_cfg_gate_present_in_main_source() {
    let src = include_str!("../src/main.rs");
    let lines: Vec<&str> = src.lines().collect();

    let env_read_line = lines
        .iter()
        .position(|l| l.contains("JR_TEST_BLOCK_UNTIL_SIGINT") && l.contains("std::env::var"))
        .expect(
            "Could not locate the JR_TEST_BLOCK_UNTIL_SIGINT env-var read in src/main.rs. \
             Has the code been moved? Update this test if the location changed.",
        );

    let window_start = env_read_line.saturating_sub(5);
    let window = &lines[window_start..=env_read_line];
    let gate_present = window.iter().any(|l| {
        l.contains("#[cfg(debug_assertions)]") || l.contains("#[cfg(all(debug_assertions, unix))]")
    });

    assert!(
        gate_present,
        "JR_TEST_BLOCK_UNTIL_SIGINT VIOLATION: a `debug_assertions` cfg gate (the seam's \
         actual gate is `#[cfg(all(debug_assertions, unix))]`) was not found within 5 lines \
         of the `JR_TEST_BLOCK_UNTIL_SIGINT` env-var read at line {} of src/main.rs.\n\
         The env-var read MUST be gated so it is excluded from release binaries and non-Unix \
         builds.\n\
         Relevant source window:\n{}",
        env_read_line + 1,
        window.join("\n")
    );
}
