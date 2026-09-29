Output docs/demo-evidence/S-cycle14-api-query-param/AC-005-m1-error-table-and-json.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-005-m1-error-table-and-json.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 640
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac005 /tmp/jr-demo-mock-requests.log"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-005 / BC-X.16.002 M1 (no "=" at all): exit 64, JrError::UserError,
# BEFORE any HTTP call -- table mode.
Type `jr api /rest/x -q novalue; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 800ms

# Same M1 condition, --output json: the {\"error\":..,\"code\":64} envelope
# goes to STDERR (repo-wide #526-adjacent convention), stdout stays empty.
Type `jr api /rest/x -q novalue --output json; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 800ms

# Proof of zero HTTP calls for BOTH invocations above: the mock server's
# request log (truncated to empty by setup.sh just before this recording)
# still has zero lines.
Type "wc -l /tmp/jr-demo-mock-requests.log"
Enter
Wait+Screen /0 \/tmp/
Sleep 2s
