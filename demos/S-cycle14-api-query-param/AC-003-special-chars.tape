Output docs/demo-evidence/S-cycle14-api-query-param/AC-003-special-chars.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-003-special-chars.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 640
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac003a"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-003 / Behavior 3, Postcondition 3: NAME/VALUE encoded EXACTLY ONCE
# via urlencoding::encode -- "*" -> %2A, "%" -> %25 (never double-decoded),
# "+" -> %2B (never left as a literal plus), non-ASCII "cafe(accent)" ->
# UTF-8 percent-encoded (%C3%A9). Never url::form_urlencoded::byte_serialize
# (which would map a space to "+" instead of %20).
Type "jr api /rest/x -q 'glob=*' -q 'pct=%' -q 'plus=+' -q 'summary=café' | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py"
Enter
Wait+Screen /%2A/
Sleep 2500ms
