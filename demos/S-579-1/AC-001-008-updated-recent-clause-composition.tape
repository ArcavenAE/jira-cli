Output ".factory/demos/S-579-1/AC-001-008-updated-recent-clause-composition.gif"
Output ".factory/demos/S-579-1/AC-001-008-updated-recent-clause-composition.webm"

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1300
Set Height 560
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 40ms
Set Shell "bash"

# S-579-1 AC-001 / AC-008 (BC-2.1.023 postcondition 1 -- field-swap
# fidelity): `jr issue list --updated-recent 60d` composes the JQL clause
# `updated >= -60d` (the field-swapped analogue of `--recent`'s
# `created >= -{d}` template -- NOT `created >= -60d`).
#
# ADAPTED DEMO -- NOT LIVE JIRA. `DEMO` is a fake project key served by a
# throwaway local Python HTTP mock (fixed canned JSON, no real Jira
# instance/org/credentials involved), reached only via the debug-only
# JR_BASE_URL/JR_AUTH_HEADER test seams documented in CLAUDE.md "AI Agent
# Notes" (inert in release builds). `--verbose --verbose-bodies` surfaces
# the real outgoing HTTP request body on stderr so the composed JQL is
# directly visible -- this is the real code path, not a canned string.
# See README.md / evidence-report.md in this directory for the mock.

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-579-1"
Enter
Type "python3 /Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-579-1/mock_server.py & sleep 0.5"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-config-579 JR_CACHE_DIR=/tmp/jr-demo-cache-579 JR_BASE_URL=http://127.0.0.1:8935 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl' RUST_LOG=warn"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type "jr --no-input --verbose --verbose-bodies --output json issue list --project DEMO --updated-recent 60d 2>&1 | grep -E '\[verbose\]|^\[\]'"
Enter
Sleep 2500ms
