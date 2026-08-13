Output ".factory/demos/S-668-1/AC-008-list-without-flag-omits-column.gif"
Output ".factory/demos/S-668-1/AC-008-list-without-flag-omits-column.webm"

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

# S-668-1 AC-8 (BC-2.2.032 opt-in clause): `jr issue list` WITHOUT
# --duedate omits the Due Date column entirely — it is NOT always-on
# (contrast with `issue view`'s AC-4).
#
# ADAPTED DEMO — NOT LIVE JIRA. `PROJ` is a fake project key against a
# throwaway local Python HTTP mock, same fixture as AC-006 minus the flag.
# See AC-001's tape header for the full isolation-seam explanation.

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

Type 'jr --no-input issue list --jql "project = PROJ"'
Enter
Sleep 2s
