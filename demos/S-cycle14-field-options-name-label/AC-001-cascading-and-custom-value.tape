Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-001-cascading-and-custom-value.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-001-cascading-and-custom-value.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 640
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac001c"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001 / EC-X.14.001-11: a cascading custom field ("Category"). The
# parent and one child carry "value" (unchanged); the OTHER child carries
# only "name" -- the fallback applies recursively into cascading children,
# not just at the top level.
Type `jr field options Category --issue FOO-1`
Enter
Wait+Screen /Storage Only/
Sleep 1s

# Cross-reference: an ordinary custom select field ("Environment") whose
# entries already carry "value" -- byte-for-byte unaffected by this fix
# (the fallback only activates on value's ABSENCE, per Architecture
# Compliance Rule "presence-based, not emptiness-based").
Type `jr field options Environment --issue FOO-1`
Enter
Wait+Screen /Production/
Sleep 2s
