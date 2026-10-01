Output docs/demo-evidence/FIX-P5-002/AC-1-comment-view-newline.gif
Output docs/demo-evidence/FIX-P5-002/AC-1-comment-view-newline.webm

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
Type "source docs/demo-evidence/FIX-P5-002/setup.sh /tmp/jr-demo-fixp5-002-before /tmp/jr-demo-fixp5-002.log before"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# EC-17a: comment author.displayName = "Eve\nRestricted: None", no real
# "visibility" field (so the REAL Restricted field is "Restricted: None").
# BEFORE the fix, sanitize_terminal_text PRESERVES the embedded \n, so a
# FAKE "Restricted: None" line appears right after "Author: Eve" -- before
# the real Created/Updated/JSM-internal/Restricted fields even print.
Type `echo "=== BEFORE (develop 769365ab): jr issue comment view -- fake line appears ==="`
Enter
Wait+Screen /fake line/
Sleep 500ms

Type "jr issue comment view FOO-1 --id 9001"
Enter
Wait+Screen /Demo comment body/
Sleep 2500ms

Hide
Type "source docs/demo-evidence/FIX-P5-002/setup.sh /tmp/jr-demo-fixp5-002-after /tmp/jr-demo-fixp5-002.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# AFTER FIX-P5-002: sanitize_terminal_line replaces \n with a single space,
# so the Author field collapses to one line ("Eve Restricted: None") and
# the REAL Restricted: field two lines later is completely unaffected.
Type `echo "=== AFTER (this fix): single line, real Restricted: field unaffected ==="`
Enter
Wait+Screen /unaffected/
Sleep 500ms

Type "jr issue comment view FOO-1 --id 9001"
Enter
Wait+Screen /Demo comment body/
Sleep 2500ms
