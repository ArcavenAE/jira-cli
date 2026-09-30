Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-006-help-wording.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-006-help-wording.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 400
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac006"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-006: the stale "custom field"-only wording (pre-#861: "Discover
# custom-field allowed options" / "Enumerate a custom field's allowed
# options") is corrected to reflect that this command now also serves
# SYSTEM fields, not just custom select fields.
Type `jr field --help | grep -i "custom or system"`
Enter
Wait+Screen /custom or system/
Sleep 1s

Type `jr field options --help | grep -i "custom or system"`
Enter
Wait+Screen /custom or system/
Sleep 2s
