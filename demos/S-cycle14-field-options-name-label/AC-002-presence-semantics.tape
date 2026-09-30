Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-002-presence-semantics.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-002-presence-semantics.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 620
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac002"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-002 / EC-X.14.001-12: the fallback is PRESENCE-based, never
# emptiness-based. "Severity Probe" carries two fixtures:
#   id 300: {"value": "", "name": "Blank But Named"}  -> value WINS,
#     even though it is the empty string -- label renders BLANK, never
#     falls through to the populated name.
#   id 301: {"value": null, "name": "Falls Through"}  -> a wire "null"
#     deserializes to a truly ABSENT value -- this one DOES fall through.
Type `jr field options "Severity Probe" --issue FOO-1 --output json`
Enter
Wait+Screen /Falls Through/
Sleep 1s

# Same fixture, table mode: id 300's row renders with a blank Label cell
# (not "Blank But Named"), id 301's row renders "Falls Through".
Type `jr field options "Severity Probe" --issue FOO-1`
Enter
Wait+Screen /Falls Through/
Sleep 2s
