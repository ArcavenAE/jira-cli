Output .factory/demos/S-692-1/AC-002-bare-description-renders-adf.gif
Output .factory/demos/S-692-1/AC-002-bare-description-renders-adf.webm

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

# S-692-1 / issue #692 (DEC-274): the ADF preview isn't stdin-only — a bare
# --description flag (no --description-stdin) also renders through the same
# markdown_to_adf path and gets the same plannedChanges.descriptionAdf key.

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

Type "jr issue edit DEMO-1 --description '**bold** text' --markdown --dry-run --output json"
Enter
Sleep 3s
