Output docs/demo-evidence/S-cycle14-api-query-param/AC-003-no-trim-whitespace.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-003-no-trim-whitespace.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 600
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac003b"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-003 / EC-X.16.001-10/11 (D-380): NEITHER NAME nor VALUE is trimmed --
# intentionally differs from -H/--header's parse_header, which DOES trim.
# A whitespace-only NAME (" ") is not empty, so it's allowed (not the
# empty-NAME error); leading/trailing VALUE whitespace is preserved and
# percent-encoded like any other byte (%20).
Type "jr api /rest/x -q ' =v' -q 'k= v ' | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py"
Enter
Wait+Screen /%20/
Sleep 2500ms
