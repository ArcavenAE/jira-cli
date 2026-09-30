Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-001-priority-name-fallback.gif
Output docs/demo-evidence/S-cycle14-field-options-name-label/AC-001-priority-name-fallback.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 560
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh /tmp/jr-demo-cache-ac001a"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001: system field "Priority" (M1 --issue path). The mock's editmeta
# fixture ships allowedValues shaped like REAL Jira -- {id, name, iconUrl},
# NO "value" key -- the exact #861 defect shape. Pre-fix this rendered
# every row as "(unnamed)"; post-fix, normalize_from_allowed_values_at_depth
# falls back to `name`.
Type "jr field options Priority --issue FOO-1"
Enter
Wait+Screen /Highest/
Sleep 1s

# Same fixture, --output json: `label` is now the resolved name string,
# never `null`, for these rows.
Type "jr field options Priority --issue FOO-1 --output json"
Enter
Wait+Screen /Highest/
Sleep 2s
