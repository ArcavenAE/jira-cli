Require jr

Output docs/demo-evidence/S-580-1/AC-011-empty-field-name.gif
Output docs/demo-evidence/S-580-1/AC-011-empty-field-name.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 400
Set Padding 20
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-580-1/setup.sh /tmp/jr-demo-cache-vhs-ac011"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-580-1 AC-011: an empty <field> name exits 64 before any HTTP call
# (resolve_field_id's empty-string guard fires after the arity check
# passes -- --issue alone is a valid single mode selector here -- but
# still before the customfield_ bypass / list_fields() resolution path).
Type "jr field options '' --issue FOO-1 --no-input"
Enter
Sleep 1500ms

Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
