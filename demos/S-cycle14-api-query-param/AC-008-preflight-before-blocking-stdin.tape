Output docs/demo-evidence/S-cycle14-api-query-param/AC-008-preflight-before-blocking-stdin.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-008-preflight-before-blocking-stdin.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac008 /tmp/jr-demo-mock-requests.log"
Enter
Sleep 500ms
Type "clear"
Enter
# Open a FIFO for writing in the background and never close it or write to
# it -- a held-open stdin producer. If -q validation ran AFTER
# resolve_body's \"-d @-\" stdin read (a buggy ordering), the command below
# would hang indefinitely waiting for stdin. It does not hang: -q
# validation (Postcondition 1) runs strictly BEFORE resolve_body.
Type "rm -f /tmp/jr-demo-heldopen.fifo && mkfifo /tmp/jr-demo-heldopen.fifo && (exec 3>/tmp/jr-demo-heldopen.fifo; sleep 30) & disown"
Enter
Sleep 500ms
Show

# AC-008 / Postcondition 1, EC-X.16.002-4: -q's M1 error fires immediately
# even with -d @- present and stdin held open by a never-writing,
# never-closing producer -- \"timeout 5\" is just a recording safety net,
# not required for correctness (the real proof is the exit code AND the
# elapsed wall-clock time, both visible below).
Type `time timeout 5 jr api /rest/x -X POST -d @- -q bad < /tmp/jr-demo-heldopen.fifo; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 800ms
Hide
Type "kill %1 2>/dev/null; rm -f /tmp/jr-demo-heldopen.fifo"
Enter
Show
Sleep 1500ms
