Output .factory/demos/S-639-1/AC-004-field-with-request-type-positive-control.gif
Output .factory/demos/S-639-1/AC-004-field-with-request-type-positive-control.webm

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 520
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 40ms
Set Shell "bash"

# S-639-1 positive control: the SAME --field flag WITH --request-type does
# NOT hit the pre-flight guard — it is scoped to the platform path only.
# --request-type routes to the JSM dispatch fork (ADR-0014), which attempts
# a real HTTP call (to a fake, unreachable base URL here) and fails with a
# DIFFERENT error/exit code (network error, exit 1) — never the BC-3.8.012
# "only valid with --request-type" message. This proves the guard is scoped
# to the platform path, not a blanket rejection of --field.

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-639-1"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-config JR_CACHE_DIR=/tmp/jr-demo-cache JR_BASE_URL=http://127.0.0.1:1/fake JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type 'jr issue create --project FOO --type Task --summary demo --field customfield_10200=x --request-type "IT Help" --no-input'
Enter
Sleep 3s

Type "echo EXIT=$?  # NOT 64 — different code path, guard correctly scoped"
Enter
Sleep 2s
