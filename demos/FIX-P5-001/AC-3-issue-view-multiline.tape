Output docs/demo-evidence/FIX-P5-001/AC-3-issue-view-multiline.gif
Output docs/demo-evidence/FIX-P5-001/AC-3-issue-view-multiline.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1300
Set Height 720
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms
Set WaitTimeout 15s

Hide
Type "source docs/demo-evidence/FIX-P5-001/setup.sh /tmp/jr-demo-fixp5-view /tmp/jr-demo-fixp5.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# FOO-2's description is ADF: paragraph "Line one <SGR-red>RED<SGR-reset>
# end" + hardBreak + paragraph "Line two with bidi <U+202E>override<U+202E>
# done". adf_to_text renders hardBreak as a literal \n (RAW, unsanitized --
# ADF rendering is untouched by this BC). render_table's Description cell
# then sanitizes: the \n survives (EC-9, multi-line cell still renders
# across two lines) while the SGR sequence and bidi overrides are stripped.
Type `echo "=== jr issue view FOO-2 -- multi-line Description cell, cat -v ==="`
Enter
Wait+Screen /cat -v/
Sleep 500ms

Type "jr issue view FOO-2 | cat -v"
Enter
Wait+Screen /Line two/
Sleep 2s

Type `echo "=== raw ESC byte count across the whole table (expect 0) ==="`
Enter
Wait+Screen /expect 0/
Sleep 300ms
Type `jr issue view FOO-2 | grep -c $'\x1b' || echo "0 (clean)"`
Enter
Wait+Screen /clean/
Sleep 2s
