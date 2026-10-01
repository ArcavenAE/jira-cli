Output docs/demo-evidence/FIX-P5-002/AC-4-user-list-color-gate.gif
Output docs/demo-evidence/FIX-P5-002/AC-4-user-list-color-gate.webm

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
Type "source docs/demo-evidence/FIX-P5-002/setup.sh /tmp/jr-demo-fixp5-002-cr2 /tmp/jr-demo-fixp5-002.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# CR-2: render_table_with_styles now structurally gates a StyledCell's fg
# on colored::control::SHOULD_COLORIZE -- VHS runs in a real pty, so the
# Active column's check/cross glyphs render in color here by default.
Type `echo "=== jr user list --project FOO (real pty, color) ==="`
Enter
Wait+Screen /real pty/
Sleep 500ms

Type "jr user list --project FOO"
Enter
Wait+Screen /Carol Unknown/
Sleep 2s

# NO_COLOR=1 suppresses the structural color at the renderer level.
Type `echo "=== NO_COLOR=1 jr user list --project FOO (no color) ==="`
Enter
Wait+Screen /no color/
Sleep 500ms

Type "NO_COLOR=1 jr user list --project FOO"
Enter
Wait+Screen /Carol Unknown/
Sleep 2s

# cat -v makes raw ESC bytes visible: Bob's row shows escape markers
# around the cross glyph with color, nothing without.
Type `echo "=== cat -v proof: color present, escape markers visible ==="`
Enter
Wait+Screen /escape markers/
Sleep 500ms

Type "jr user list --project FOO | grep Bob | cat -v"
Enter
Wait+Screen /Bob Inactive/
Sleep 2s

Type `echo "=== cat -v proof: NO_COLOR=1 -- zero escape markers ==="`
Enter
Wait+Screen /zero escape markers/
Sleep 500ms

Type "NO_COLOR=1 jr user list --project FOO | grep Bob | cat -v"
Enter
Wait+Screen /Bob Inactive/
Sleep 2s
