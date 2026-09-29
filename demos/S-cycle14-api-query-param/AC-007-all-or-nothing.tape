Output docs/demo-evidence/S-cycle14-api-query-param/AC-007-all-or-nothing.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-007-all-or-nothing.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac007 /tmp/jr-demo-mock-requests.log"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-007 / Postcondition 3, Invariant 3, EC-X.16.002-3: two -q flags, the
# SECOND is malformed -- the WHOLE invocation fails before any HTTP call
# (the well-formed FIRST pair is never sent), and the error reported is
# the FIRST malformed value encountered in flag order.
Type `jr api /rest/x -q good=1 -q bad; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 800ms
Type "wc -l /tmp/jr-demo-mock-requests.log"
Enter
Wait+Screen /0 \/tmp/
Sleep 2s
