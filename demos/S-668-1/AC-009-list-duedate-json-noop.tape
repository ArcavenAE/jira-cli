Output ".factory/demos/S-668-1/AC-009-list-duedate-json-noop.gif"
Output ".factory/demos/S-668-1/AC-009-list-duedate-json-noop.webm"

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

# S-668-1 AC-9 (BC-2.2.032 JSON-mode clause): `issue list --duedate
# --output json` is a silent no-op on JSON shape — identical output to the
# same query without --duedate. Diffing the two invocations' JSON proves
# byte-for-byte equality (empty diff = pass) and that no --duedate warning
# was written to stderr.
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

Type 'jr --no-input --output json issue list --jql "project = PROJ" --duedate > /tmp/with-flag.json 2>/tmp/with-flag.stderr'
Enter
Sleep 800ms
Type 'jr --no-input --output json issue list --jql "project = PROJ" > /tmp/without-flag.json 2>/tmp/without-flag.stderr'
Enter
Sleep 800ms
Type "diff /tmp/with-flag.json /tmp/without-flag.json && echo 'JSON IDENTICAL (AC-9 pass)'"
Enter
Sleep 800ms
Type "wc -l /tmp/with-flag.stderr /tmp/without-flag.stderr"
Enter
Sleep 2s
