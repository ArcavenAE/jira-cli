Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-merge-existing-query.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-merge-existing-query.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 520
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac001b"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001 / EC-X.16.001-4: path already has a non-empty, non-&-terminated
# query -- new pairs are &-joined onto it: /x?a=1 + -q b=2 => ?a=1&b=2.
Type "jr api '/x?a=1' -q b=2 | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py"
Enter
Wait+Screen /a=1&b=2/
Sleep 1500ms
