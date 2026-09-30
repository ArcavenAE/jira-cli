Output docs/demo-evidence/FIX-P5-001/AC-2-issue-list-table-vs-json.gif
Output docs/demo-evidence/FIX-P5-001/AC-2-issue-list-table-vs-json.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1400
Set Height 650
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms
Set WaitTimeout 15s

Hide
Type "source docs/demo-evidence/FIX-P5-001/setup.sh /tmp/jr-demo-fixp5-list /tmp/jr-demo-fixp5.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# AFTER FIX (fix/FIX-P5-001). The mock issue FOO-10's summary carries FIVE
# distinct hostile payloads in one string: an SGR color sequence, an
# OSC-0 window-title sequence (BEL-terminated), a C1 CSI introducer
# (U+009B) followed by bytes that would continue a 7-bit CSI sequence but
# are NOT consumed as one, a bidi-override pair (U+202E), and a bare CRLF.
# Table mode (default) through cat -v: no ^[ (raw ESC) and no M-^[ (C1)
# anywhere in the output.
Type `echo "=== jr issue list (table, default) -- cat -v ==="`
Enter
Wait+Screen /cat -v/
Sleep 500ms

Type `jr issue list --jql "project = FOO" | cat -v`
Enter
Wait+Screen /FOO-11/
Sleep 2s

Type `echo "=== --output json: same fixture, unsanitized (BC-7.1.006 EC-12) ==="`
Enter
Wait+Screen /EC-12/
Sleep 500ms

Type `jr issue list --jql "project = FOO" --output json | python3 -c "import json,sys; d=json.load(sys.stdin); s=d[0]['fields']['summary']; print(repr(s)); assert chr(0x1b) in s and chr(0x9b) in s and chr(0x202e) in s; print('JSON round-trip: raw hostile bytes all present, unsanitized')"`
Enter
Wait+Screen /unsanitized/
Sleep 2s
