Output docs/demo-evidence/S-cycle14-api-query-param/AC-006-m2-error.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-006-m2-error.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac006 /tmp/jr-demo-mock-requests.log"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-006 / BC-X.16.002 M2 (empty NAME, e.g. \"=v\"): exit 64, a message
# DISTINCT from M1's -- \"NAME cannot be empty\" vs. \"must be in
# NAME=VALUE format\". Zero HTTP calls, same as M1.
Type `jr api /rest/x -q '=v'; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 800ms
Type "wc -l /tmp/jr-demo-mock-requests.log"
Enter
Wait+Screen /0 \/tmp/
Sleep 2s
