Output .factory/demos/S-692-1/AC-003-depth-guard-preflight-catch.gif
Output .factory/demos/S-692-1/AC-003-depth-guard-preflight-catch.webm

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

# S-692-1 / issue #692 (DEC-274, BC-7.2.012 depth guard): this is the whole
# point of the story. Before #692, --dry-run only echoed flags — it never
# actually ran the markdown->ADF conversion, so a pathologically nested
# markdown description (which Jira would reject with HTTP 400/CWE-674 guard)
# would sail through a dry-run clean, only to fail on the real write. Now
# the ADF render happens INSIDE the dry-run pre-flight, so the MAX_ADF_DEPTH
# guard trips before any HTTP call: exit 64, error on stderr, stdout EMPTY.

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-692-1"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-config JR_CACHE_DIR=/tmp/jr-demo-cache JR_BASE_URL=http://127.0.0.1:1/fake JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "perl -e 'print(q(> ) x 300 . qq(deep\n))' > /tmp/jr-demo-deep.md"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type "# deep.md = 300 nested blockquote levels (> > > ... deep)"
Enter
Sleep 500ms
Type "cat /tmp/jr-demo-deep.md | jr issue edit DEMO-1 --description-stdin --markdown --dry-run"
Enter
Sleep 2s
Type "echo exit code: $?"
Enter
Sleep 3s
