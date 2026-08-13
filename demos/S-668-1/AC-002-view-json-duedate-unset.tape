Output ".factory/demos/S-668-1/AC-002-view-json-duedate-unset.gif"
Output ".factory/demos/S-668-1/AC-002-view-json-duedate-unset.webm"

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

# S-668-1 AC-2 (BC-2.3.036 [AMENDED]): `jr issue view --output json` shows
# `.fields.duedate` as JSON `null` (key PRESENT, not omitted) when unset.
#
# ADAPTED DEMO — NOT LIVE JIRA. `PROJ-2` is a fake issue key served by a
# throwaway local Python HTTP mock (fixed canned JSON). See AC-001's tape
# header for the full isolation-seam explanation.

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

Type 'jr --no-input --output json issue view PROJ-2 | jq "{hasKey: (.fields | has(\"duedate\")), value: .fields.duedate}"'
Enter
Sleep 2s
