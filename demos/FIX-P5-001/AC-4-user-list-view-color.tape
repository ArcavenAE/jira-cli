Output docs/demo-evidence/FIX-P5-001/AC-4-user-list-view-color.gif
Output docs/demo-evidence/FIX-P5-001/AC-4-user-list-view-color.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 15
Set Width 1300
Set Height 650
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms
Set WaitTimeout 15s

Hide
Type "source docs/demo-evidence/FIX-P5-001/setup.sh /tmp/jr-demo-fixp5-user /tmp/jr-demo-fixp5.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# VHS runs in a real pty, so colored-crate output IS colorized by default.
# format_active's Active-column glyph coloring moved from ANSI-bytes-in-
# String to a structural comfy_table::Cell::fg() attribute (active_cell,
# BC-7.1.006) -- green check / red cross should render in color here.
Type `echo "=== jr user list --project FOO (color forced by real pty) ==="`
Enter
Wait+Screen /color forced/
Sleep 500ms

Type "jr user list --project FOO"
Enter
Wait+Screen /Carol Unknown/
Sleep 2s

# --no-color suppresses the Active column's structural color the same way
# it suppresses every other colored-crate color in jr (active_cell gates on
# colored::control::SHOULD_COLORIZE, not comfy_table's own TTY check).
Type `echo "=== jr user list --project FOO --no-color ==="`
Enter
Wait+Screen /no-color/
Sleep 500ms

Type "jr user list --project FOO --no-color"
Enter
Wait+Screen /Carol Unknown/
Sleep 2s

# Bob's hostile display name ("Bob <SGR-red>Hostile<SGR-reset> Name")
# renders as clean text -- no raw ESC survives -- while the Active glyphs
# (check/cross/em-dash) are untouched.
Type `echo "=== hostile display_name stripped, Active glyphs intact -- cat -v ==="`
Enter
Wait+Screen /cat -v/
Sleep 500ms

Type "jr user list --project FOO --no-color | grep Bob | cat -v"
Enter
Wait+Screen /Bob Hostile Name/
Sleep 2s

Type `echo "=== jr user view acc-2 (same hostile name, single-record view) ==="`
Enter
Wait+Screen /single-record/
Sleep 500ms

Type "jr user view acc-2 | cat -v"
Enter
Wait+Screen /Active/
Sleep 2s
