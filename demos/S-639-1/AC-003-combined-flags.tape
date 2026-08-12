Output .factory/demos/S-639-1/AC-003-combined-flags.gif
Output .factory/demos/S-639-1/AC-003-combined-flags.webm

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

# S-639-1: --field AND --on-behalf-of together (no --request-type) fire the
# COMBINED-check branch first, producing exactly ONE error, not two.

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

Type "jr issue create --project FOO --type Task --summary demo --field customfield_10200=x --on-behalf-of someone@example.com --no-input"
Enter
Sleep 2s

Type "echo EXIT=$?"
Enter
Sleep 2s
