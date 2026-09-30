Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-001-m2-createmeta.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-001-m2-createmeta.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 620
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac001b"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001 (M2 createmeta path): system field "Components", same fallback
# code path (normalize_from_allowed_values_at_depth) reused by --type.
# Fixture allowedValues are {id, name} only -- no "value" key.
Type "jr field options Components --type Task --project FOO"
Enter
Wait+Screen /Backend/
Sleep 1s

# Error path (pre-existing, unaffected by this story): an unresolvable
# project still exits 64 with the same message as before this fix --
# the label-fallback change never touches M2's project-resolution error
# taxonomy.
Type `jr field options Components --type Task --project BADPROJ; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 2s
