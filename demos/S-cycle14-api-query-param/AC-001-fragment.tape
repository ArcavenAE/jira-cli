Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-fragment.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-fragment.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac001d"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001 / EC-X.16.001-5: a "#fragment" is reattached AFTER the assembled
# query; detection only scans the pre-fragment part for "?". Per RFC 9112
# section 3.2 the fragment is never transmitted to the server at all --
# the mock server's fragment_received_by_server field proves this: it is
# always empty, confirming jr's own reqwest client never puts the "#..."
# on the wire even though it built "?k=v" ahead of it locally.
Type "jr api '/s#f' -q k=v | python3 -m json.tool"
Enter
Wait+Screen /fragment_received_by_server/
Sleep 2s
