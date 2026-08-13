Output ".factory/demos/S-668-1/AC-006-list-duedate-column-position.gif"
Output ".factory/demos/S-668-1/AC-006-list-duedate-column-position.webm"

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

# S-668-1 AC-6 + AC-7 (BC-2.2.032 column-position + empty-rendering
# clauses): `jr issue list --duedate` shows the Due Date column at
# Key, Type, Status, Priority, [Due Date], Assignee, Summary (no
# --points/--assets/--team passed), rendering the fixture value verbatim
# for PROJ-1 (AC-6) and "-" for PROJ-2's unset duedate (AC-7) — both rows
# come from the same mock fixture/invocation.
#
# ADAPTED DEMO — NOT LIVE JIRA. `PROJ` is a fake project key against a
# throwaway local Python HTTP mock. See AC-001's tape header for the full
# isolation-seam explanation.

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

Type 'jr --no-input issue list --jql "project = PROJ" --duedate'
Enter
Sleep 2s
