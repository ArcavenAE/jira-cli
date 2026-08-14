Output .factory/demos/S-692-1/AC-004-table-mode-render-ok.gif
Output .factory/demos/S-692-1/AC-004-table-mode-render-ok.webm

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 30ms
Set Shell "bash"

# S-692-1 / issue #692 (DEC-274): human/table mode doesn't dump raw ADF
# JSON (poor UX) — instead it prints a "markdown rendering: enabled" line
# followed by a "description (ADF): rendered OK" confirmation, proving the
# same conversion succeeded without a wall of JSON.

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-692-1"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-config JR_CACHE_DIR=/tmp/jr-demo-cache JR_BASE_URL=http://127.0.0.1:1/fake JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type "jr issue edit DEMO-1 --description '**bold** text' --markdown --dry-run"
Enter
Sleep 3s
