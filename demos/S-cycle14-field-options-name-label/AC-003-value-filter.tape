Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-003-value-filter.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-003-value-filter.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac003"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-003 / EC-X.14.001-13: `--value` filters against the RESOLVED label,
# so a system field now also matches via its name-derived fallback label
# -- a downstream consequence of AC-001, not a new filter rule
# (BC-X.14.002's own matching logic is untouched).
Type `jr field options Priority --issue FOO-1 --value high`
Enter
Wait+Screen /Highest/
Sleep 1s

# Boundary: a substring with no match against any resolved label still
# returns zero rows (exit 0, "No results found.") -- the filter itself
# behaves exactly as before this story.
Type `jr field options Priority --issue FOO-1 --value zzz; echo "exit=$?"`
Enter
Wait+Screen /exit=0/
Sleep 2s
