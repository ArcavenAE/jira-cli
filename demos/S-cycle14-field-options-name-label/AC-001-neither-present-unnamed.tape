Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-001-neither-present-unnamed.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-001-neither-present-unnamed.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac001d"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001 / EC-X.14.001-7 & EC-X.14.001-10, cross-referenced by AC-005
# (BC-X.14.003 rendering contract, byte-for-byte UNCHANGED): an entry
# carrying NEITHER "value" NOR "name" still renders as a row -- never
# dropped -- degrading only its own label to "(unnamed)" (table).
Type `jr field options "Legacy Probe" --issue FOO-1`
Enter
Wait+Screen /unnamed/
Sleep 1s

# Same entry, --output json: label is `null`, never a substituted string
# -- same degenerate-entry rendering contract this story does not touch.
Type `jr field options "Legacy Probe" --issue FOO-1 --output json`
Enter
Wait+Screen /null/
Sleep 2s
