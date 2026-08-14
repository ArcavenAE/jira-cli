Output .factory/demos/S-692-1/AC-001-stdin-markdown-adf-preview.gif
Output .factory/demos/S-692-1/AC-001-stdin-markdown-adf-preview.webm

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 700
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 30ms
Set Shell "bash"

# S-692-1 / issue #692 (DEC-274): `jr issue edit --dry-run` now reads
# --description-stdin and renders the markdown to ADF locally, emitting BOTH
# the raw input (plannedChanges.description) and the rendered ADF document
# (plannedChanges.descriptionAdf) — with zero HTTP calls. All config/auth/
# base-url below are fake; the dry-run short-circuit fires before any
# network access, so no real Jira instance is ever contacted.

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

Type "printf '1. item one\n\n   ```\n   code\n   ```\n\n2. item two\n' | jr issue edit DEMO-1 --description-stdin --markdown --dry-run --output json"
Enter
Sleep 3s
