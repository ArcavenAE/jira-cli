Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-literal-qmark-in-value.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-literal-qmark-in-value.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 520
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac001e"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001 / EC-X.16.001-9: the existing query component's own last byte is
# a literal "?" that is part of query CONTENT, not a delimiter -- still
# &-joined, never mistaken for the EC-8 empty-query-component case.
Type "jr api '/s?jql=why?' -q k=v | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py"
Enter
Wait+Screen /jql=why/
Sleep 2s
