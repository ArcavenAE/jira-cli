Output docs/demo-evidence/FIX-P5-002/AC-3-assign-ambiguous-newline.gif
Output docs/demo-evidence/FIX-P5-002/AC-3-assign-ambiguous-newline.webm

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
Type "source docs/demo-evidence/FIX-P5-002/setup.sh /tmp/jr-demo-fixp5-002-before3 /tmp/jr-demo-fixp5-002.log before"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# FOO-9 has TWO assignable users, both with the IDENTICAL hostile
# displayName "Mallory\nEve" (different emails/account IDs). Querying
# --to with the literal string "Mallory\nEve" (bash $'...' ANSI-C
# quoting) exact-matches both -> MatchResult::ExactMultiple -> --no-input
# error lists each duplicate on its own line.
# BEFORE the fix, each duplicate's embedded \n splits its own line into
# two, so the two candidates become visually indistinguishable.
Type `echo "=== BEFORE (develop 769365ab): each candidate's line splits in two ==="`
Enter
Wait+Screen /splits in two/
Sleep 500ms

Type `jr issue assign FOO-9 --to $'Mallory\nEve' --no-input`
Enter
Wait+Screen /more specific name/
Sleep 2500ms

Hide
Type "source docs/demo-evidence/FIX-P5-002/setup.sh /tmp/jr-demo-fixp5-002-after3 /tmp/jr-demo-fixp5-002.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# AFTER FIX-P5-002: sanitize_terminal_line keeps each duplicate on exactly
# ONE line ("Mallory Eve (mallory1@..., account: acc-mallory-1)" /
# "Mallory Eve (mallory2@..., account: acc-mallory-2)") -- distinguishable
# by email/account ID, one line per candidate.
Type `echo "=== AFTER (this fix): each candidate stays on its own single line ==="`
Enter
Wait+Screen /single line/
Sleep 500ms

Type `jr issue assign FOO-9 --to $'Mallory\nEve' --no-input`
Enter
Wait+Screen /more specific name/
Sleep 2500ms
