Output ".factory/demos/S-588-1/AC-004-sort-malformed-direction-exits-64-pre-http.gif"
Output ".factory/demos/S-588-1/AC-004-sort-malformed-direction-exits-64-pre-http.webm"

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1300
Set Height 520
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 40ms
Set Shell "bash"

# S-588-1 AC-004 (BC-2.1.024 Edge Case EC-2.1.024-3..7 -- malformed-input
# rejection): `--sort updated:sideways` (an invalid direction segment) is
# rejected by local syntax validation BEFORE any HTTP call -- exit 64, exact
# stderr string `Invalid --sort "<value>". Use <field>:asc or <field>:desc
# (e.g., updated:desc).`. This is a pure clap-arg-value parse/validate
# error (`parse_sort` in src/cli/issue/list.rs) -- it fires pre-HTTP, so no
# mock server is needed for this recording (zero network I/O on this path,
# same class as `missing ':'`, `empty field`, `empty direction`, and a
# second embedded `:'` -- all five malformed shapes share this one error
# path and exit code).

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-588-1"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type "jr --no-input issue list --project DEMO --sort updated:sideways"
Enter
Sleep 1500ms

Type `echo "exit=$?"`
Enter
Sleep 1500ms
