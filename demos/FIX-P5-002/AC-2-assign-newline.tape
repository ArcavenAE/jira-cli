Output docs/demo-evidence/FIX-P5-002/AC-2-assign-newline.gif
Output docs/demo-evidence/FIX-P5-002/AC-2-assign-newline.webm

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
Type "source docs/demo-evidence/FIX-P5-002/setup.sh /tmp/jr-demo-fixp5-002-before2 /tmp/jr-demo-fixp5-002.log before"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# FOO-1 has exactly one assignable user matching "Mallory", whose
# displayName is the hostile "Mallory\nEve" -- disambiguate_user's
# single-match short-circuit returns it directly (no ambiguity logic).
# BEFORE the fix, sanitize_terminal_text preserves the \n: the success
# message splits across two lines.
Type `echo "=== BEFORE (develop 769365ab): jr issue assign -- splits across two lines ==="`
Enter
Wait+Screen /two lines/
Sleep 500ms

Type "jr issue assign FOO-1 --to Mallory --no-input"
Enter
Wait+Screen /Eve/
Sleep 2500ms

Hide
Type "source docs/demo-evidence/FIX-P5-002/setup.sh /tmp/jr-demo-fixp5-002-after2 /tmp/jr-demo-fixp5-002.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# AFTER FIX-P5-002: sanitize_terminal_line collapses the \n to a single
# space -- the success message is one line: "Assigned FOO-1 to Mallory Eve".
Type `echo "=== AFTER (this fix): single line, 'Assigned FOO-1 to Mallory Eve' ==="`
Enter
Wait+Screen /single line/
Sleep 500ms

Type "jr issue assign FOO-1 --to Mallory --no-input"
Enter
Wait+Screen /Eve/
Sleep 2500ms
