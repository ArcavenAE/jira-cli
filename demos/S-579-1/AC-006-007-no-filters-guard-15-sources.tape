Output ".factory/demos/S-579-1/AC-006-007-no-filters-guard-15-sources.gif"
Output ".factory/demos/S-579-1/AC-006-007-no-filters-guard-15-sources.webm"

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1400
Set Height 560
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 40ms
Set Shell "bash"

# S-579-1 AC-006 (BC-2.1.006 amendment -- filter-source enumeration 14->15)
# + AC-007 (BC-2.1.023 Edge Case EC-2.1.023-4 -- `--updated-recent` counts
# as a filter source, it does not bypass project scoping): `jr issue list
# --updated-recent 60d` with no `--project` / no configured project and no
# other filter falls through to the amended "no filters specified" exit-64
# guard, whose stderr literal now enumerates 15 sources ending
# "... --updated-recent, or --jql.". Zero-HTTP guard -- this fires before
# any network call, so no mock server is needed for this recording.

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-579-1"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-config-579-noproj JR_CACHE_DIR=/tmp/jr-demo-cache-579-noproj"
Enter
Type "rm -rf /tmp/jr-demo-config-579-noproj /tmp/jr-demo-cache-579-noproj && mkdir -p /tmp/jr-demo-config-579-noproj /tmp/jr-demo-cache-579-noproj"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type "jr --no-input issue list --updated-recent 60d"
Enter
Sleep 1500ms

Type `echo "exit=$?"`
Enter
Sleep 1500ms
