Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-no-dedup-collision.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-no-dedup-collision.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac001f"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001 / EC-X.16.001-12: path already carries fields=summary; -q
# fields=status does NOT dedup or override it -- both are sent, existing
# text first, unmodified, then the new pair in flag order.
Type "jr api '/s?fields=summary' -q fields=status | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py"
Enter
Wait+Screen /fields=summary&fields=status/
Sleep 2s
