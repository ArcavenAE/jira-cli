Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-004-m3-unchanged.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-004-m3-unchanged.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 620
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac004"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-004: M3 (JSM requesttype-fields, --request-type) is NOT modified by
# this story -- normalize_from_valid_values already read id-from-".value"
# and label-from-".label" correctly before this fix, and still does.
# Numeric "10" bypasses request-type NAME resolution (existing convention).
Type `jr field options Priority --request-type 10 --project EJ`
Enter
Wait+Screen /Highest/
Sleep 1s

# Error path (pre-existing, unaffected): a field absent from this request
# type's own field list still exits 64 with the same message as before
# this story -- the M1/M2 label-fallback fix never touches M3's dispatch
# or its error taxonomy.
Type `jr field options Components --request-type 10 --project EJ; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 2s
