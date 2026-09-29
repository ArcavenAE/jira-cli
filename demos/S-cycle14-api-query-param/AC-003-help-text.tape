Output docs/demo-evidence/S-cycle14-api-query-param/AC-003-help-text.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-003-help-text.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 460
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac003c"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-003 / VP-API-QP-003(e): --help pins the literal substring "do not
# pre-encode" -- since values are NOT trimmed and ARE encoded downstream,
# the help text warns callers not to pre-encode a value themselves (a
# pre-encoded "%20" would itself get re-encoded to "%2520").
Type "jr api --help | grep -i 'pre-encode'"
Enter
Wait+Screen /pre-encode/
Sleep 2s
