Output docs/demo-evidence/S-cycle14-api-query-param/AC-004-zero-flag-unchanged.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-004-zero-flag-unchanged.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 500
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac004b"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-004 / Behavior 5, Postcondition 1: zero --query-param flags at all ->
# the path handed to the request is byte-identical to normalize_path's
# own output -- pre-existing jr api behavior (BC-X.1.007/BC-X.1.011) is
# completely unaffected by this cycle's change. query_raw is empty.
Type "jr api /rest/api/3/myself | python3 -m json.tool"
Enter
Wait+Screen /query_raw/
Sleep 2s
