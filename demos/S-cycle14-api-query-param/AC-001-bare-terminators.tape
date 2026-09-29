Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-bare-terminators.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-bare-terminators.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac001c"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001 / EC-X.16.001-8: query component is empty (bare "?"-terminated
# path) or already ends in "&" -- new pairs are appended with NO separator
# (never "?&" or "??" / "&&").
Type "jr api '/rest/api/3/search?' -q new=2 | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py '?-terminated ->'"
Enter
Wait+Screen /new=2/
Sleep 800ms
Type "jr api '/rest/api/3/search?a=1&' -q new=2 | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py '&-terminated ->'"
Enter
Wait+Screen /a=1&new=2/
Sleep 1500ms
