Output ".factory/demos/S-588-1/AC-COMPOSE-sort-priority-asc-composes-with-status-filter.gif"
Output ".factory/demos/S-588-1/AC-COMPOSE-sort-priority-asc-composes-with-status-filter.webm"

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

# S-588-1 -- BC-2.1.025 Behavior + Precondition 1 (no field-name allowlist)
# + Postcondition 5 (--sort is not a filter source): `jr issue list --sort
# priority:asc --status "In Progress"` shows `--sort` composing cleanly
# alongside an existing WHERE-clause filter -- the `--status` filter lands
# in the WHERE clause exactly as it would without `--sort`, while `--sort`
# only ever touches ORDER BY. The `priority` field name is passed straight
# through to Jira UNVALIDATED (no local field-name allowlist) and the
# standard `key ASC` secondary sort is appended.
#
# ADAPTED DEMO -- NOT LIVE JIRA. `DEMO` is a fake project key served by a
# throwaway local Python HTTP mock (fixed canned JSON, no real Jira
# instance/org/credentials involved), reached only via the debug-only
# JR_BASE_URL/JR_AUTH_HEADER test seams documented in CLAUDE.md "AI Agent
# Notes" (inert in release builds). `--verbose --verbose-bodies` surfaces
# the real outgoing HTTP request body on stderr so the composed JQL is
# directly visible -- this is the real code path, not a canned string.
# See evidence-report.md in this directory for the mock.

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-588-1"
Enter
Type "python3 /Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-588-1/mock_server.py & sleep 0.5"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-config-588 JR_CACHE_DIR=/tmp/jr-demo-cache-588 JR_BASE_URL=http://127.0.0.1:8936 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl' RUST_LOG=warn"
Enter
Type "rm -rf /tmp/jr-demo-config-588 /tmp/jr-demo-cache-588"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type `jr --no-input --verbose --verbose-bodies --output json issue list --project DEMO --sort priority:asc --status "In Progress" 2>&1 | grep -E '\[verbose\] body|^\[\]'`
Enter
Sleep 2500ms
