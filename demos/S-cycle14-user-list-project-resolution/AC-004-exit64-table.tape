Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-004-exit64-table.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-004-exit64-table.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 360
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

# --- Hidden setup: no local flag, no global flag, no .jr.toml, and the
# active profile has no configured project default -- none of the three
# resolution sources can resolve a project.
Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac004t config-no-project.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-004 / EC-X.7.002-4: none of {local, global, configured default}
# resolve -- exit 64 (JrError::UserError) with the byte-identical pinned
# message, before any HTTP call (the mock server -- reachable at
# JR_BASE_URL -- never receives a request for this invocation).
Type "jr user list --no-input"
Enter
Sleep 1500ms
Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
