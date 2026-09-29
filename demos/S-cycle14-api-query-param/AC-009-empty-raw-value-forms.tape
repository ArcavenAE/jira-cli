Output docs/demo-evidence/S-cycle14-api-query-param/AC-009-empty-raw-value-forms.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-009-empty-raw-value-forms.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 680
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac009c"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# EC-X.16.002-9: three forms all deliver raw=\"\" (a PROVIDED empty
# value, not a missing one): a bare empty-string next token, a short-flag
# attached bare \"=\", and a long-flag attached bare \"=\". All three
# classify as M1 (missing \"=\" -- an empty string has none to split on),
# got: (empty) -- NOT M2, since the empty-NAME check is only reachable
# once a \"=\" has actually been found.
Type `jr api /rest/x -q ''; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 600ms
Type `jr api /rest/x -q=; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 600ms
Type `jr api /rest/x --query-param=; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 2s
