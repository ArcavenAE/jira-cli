Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-009-empty-field-guard.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-009-empty-field-guard.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 480
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac009 /tmp/jr-demo-field-options-requests.log"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-009 (EC-X.14.001-15, pre-existing, unaffected by this story): an
# empty <field> exits 64 BEFORE any cache read or HTTP call. Documented
# here for completeness -- this story's label-fallback fix never touches
# resolve_field_id's empty-string guard.
Type `jr field options "" --issue FOO-1; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 1s

# Proof of zero HTTP calls: the mock server's request log (truncated to
# empty by setup.sh just before this recording) still has zero lines.
Type "wc -l /tmp/jr-demo-field-options-requests.log"
Enter
Wait+Screen /0 \/tmp/
Sleep 2s
