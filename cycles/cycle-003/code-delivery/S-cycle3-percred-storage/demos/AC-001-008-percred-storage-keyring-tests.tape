# VHS Demo — S-cycle3-percred-storage
#
# FALLBACK NOTE: this tape is preserved as the intended recording script,
# but VHS could not produce a .gif/.webm in the demo-recorder's execution
# sandbox — headless Chrome + ttyd both launched successfully, but no
# keystroke ever reached the terminal (confirmed by inspecting a rendered
# frame: the terminal stayed frozen at its initial ">" glyph with the typed
# command never appearing), so every `Wait+Line` timed out. This is an
# environment limitation of the go-rod/CDP input-delivery layer VHS depends
# on in this sandbox, NOT a macOS keychain permission prompt (the same
# `cargo test` commands below were separately verified to run cleanly with
# zero prompts and zero hangs when run directly). Evidence for this tape's
# ACs is instead captured as a plain-text transcript:
#   AC-001-008-percred-storage-keyring-tests.txt
#
# Covers AC-001, AC-002, AC-004, AC-005, AC-006, AC-007, AC-008
# (BC-1.4.031 postconditions 1/2/4, VP-AUTHDX-004, EC-1.4.031-1/2)
#
# This is an INTERNAL keychain-storage mechanism story (store_api_token /
# load_api_token). There is no new CLI surface to demo directly — the
# authoritative evidence is the gated keyring test suite passing against
# the REAL OS keychain backend (macOS Keychain Services here), run under a
# THROWAWAY per-test service namespace (jr-jira-cli-test-<pid>-<n>, assigned
# automatically by src/api/auth.rs::tests::with_test_keyring / unique_test_service)
# so the developer's real "jr-jira-cli" keychain entries are never touched.
#
# Recorded from inside the story worktree; self-locates to the worktree
# root via `git rev-parse --show-toplevel` (see "Never hardcode absolute
# paths" convention).

Output AC-001-008-percred-storage-keyring-tests.gif
Output AC-001-008-percred-storage-keyring-tests.webm

Require cargo

Set Shell "zsh"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 700
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 30
Set TypingSpeed 40ms

Hide
Type "cd $(git rev-parse --show-toplevel)"
Enter
Sleep 1s
Type "clear"
Enter
Sleep 500ms
Show

# === AC-001/002/004/005/006/007/008: keyring-gated unit + proptest suite ===
# JR_RUN_KEYRING_TESTS=1 opts into the real-backend tests (normally #[ignore]d
# and no-op'd). Every case below self-namespaces into a fresh, unique
# "jr-jira-cli-test-<pid>-<n>" keychain service — never the real
# "jr-jira-cli" service a developer's actual credentials live under.
Type "JR_RUN_KEYRING_TESTS=1 cargo test --lib -- --include-ignored --test-threads=1 api_token_ bc_1_4_031"
Enter
Wait+Line@45s /test result: ok/
Sleep 2s
