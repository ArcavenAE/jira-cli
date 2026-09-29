Output docs/demo-evidence/S-cycle14-api-query-param/AC-002-repeated-names-and-comma.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-002-repeated-names-and-comma.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac002"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-002 / Behavior 2, Postcondition 4: repeated -q NAME=... occurrences
# are ALL sent, in flag order -- no dedup, no last-wins collapsing.
Type "jr api /rest/api/3/search -q fields=summary -q fields=status | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py"
Enter
Wait+Screen /fields=summary&fields=status/
Sleep 800ms

# EC-X.16.001-13: a comma INSIDE one VALUE is never split into multiple
# pairs -- no value_delimiter on the clap flag. One -q occurrence, one
# pair; the comma is just another byte, percent-encoded once (%2C).
Type "jr api /rest/x -q 'fields=summary,status' | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py"
Enter
Wait+Screen /summary%2Cstatus/
Sleep 2s
