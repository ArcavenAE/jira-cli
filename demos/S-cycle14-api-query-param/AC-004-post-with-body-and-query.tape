Output docs/demo-evidence/S-cycle14-api-query-param/AC-004-post-with-body-and-query.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-004-post-with-body-and-query.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 620
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac004a"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-004 / Behavior 4, Postcondition 5: query-param assembly is
# METHOD-ORTHOGONAL and fully independent of -d/--data's body -- same -q
# assembly whether GET or POST, and the body is never inspected for
# query-mergeable content. The mock echoes both "query_raw" and the
# parsed "body" so both channels are visible in one response.
Type `jr api /rest/api/3/issue -X POST -d '{"fields":{"summary":"demo"}}' -q notifyUsers=false | python3 -m json.tool`
Enter
Wait+Screen /notifyUsers/
Sleep 2500ms
