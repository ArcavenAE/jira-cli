Output ".factory/demos/S-668-1/AC-001-view-json-duedate-set.gif"
Output ".factory/demos/S-668-1/AC-001-view-json-duedate-set.webm"

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 480
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 40ms
Set Shell "bash"

# S-668-1 AC-1 (BC-2.3.036 [AMENDED] / BC-2.2.028): `jr issue view --output
# json` includes `.fields.duedate` verbatim when the fixture has one set.
#
# ADAPTED DEMO — NOT LIVE JIRA. `PROJ-1` is a fake issue key served by a
# throwaway local Python HTTP mock (fixed canned JSON, no real Jira
# instance/org/credentials involved) reached only via the debug-only
# JR_BASE_URL/JR_AUTH_HEADER test seams documented in CLAUDE.md "AI Agent
# Notes" (inert in release builds). See README.md in this directory for the
# exact mock fixture used.

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-668-1"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-config-668 JR_CACHE_DIR=/tmp/jr-demo-cache-668 JR_BASE_URL=http://127.0.0.1:8934 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type 'jr --no-input --output json issue view PROJ-1 | jq ".fields.duedate"'
Enter
Sleep 2s
