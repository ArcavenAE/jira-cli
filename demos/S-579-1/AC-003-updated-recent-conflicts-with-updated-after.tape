Output ".factory/demos/S-579-1/AC-003-updated-recent-conflicts-with-updated-after.gif"
Output ".factory/demos/S-579-1/AC-003-updated-recent-conflicts-with-updated-after.webm"

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

# S-579-1 AC-003 (BC-2.1.023 Edge Case EC-2.1.023-2 -- asymmetric
# conflicts_with, human-locked DEC-298): `--updated-recent` + `--updated-after`
# -> clap `conflicts_with` rejection, exit 2. This is a pure clap-derive
# validation error -- it fires BEFORE any HTTP call, so no mock server is
# needed for this recording (zero network I/O on this path).
#
# Deliberately asymmetric: `--updated-recent` does NOT conflict with
# `--updated-before` (mirrors the pre-existing `--recent` x `--created-after`
# asymmetry) -- shown as a second, non-conflicting invocation below.

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-579-1"
Enter
Type "alias jr=./target/debug/jr"
Enter
Type "clear"
Enter
Sleep 300ms
Show

Type "jr issue list --updated-recent 60d --updated-after 2026-01-01"
Enter
Sleep 1500ms

Type `echo "exit=$?"`
Enter
Sleep 1500ms
