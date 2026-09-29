Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-001-local-project.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-001-local-project.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 420
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

# --- Hidden setup: fresh fake profile (no configured project default), no
# .jr.toml ancestor, JR_BASE_URL pointed at the local mock server. No real
# Jira instance is ever contacted.
Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac001 config-no-project.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001: local --project flag alone resolves (clap-required String ->
# Option<String>, unchanged short = 'p' alias). No global flag, no
# configured default anywhere -- the local flag is the sole source.
Type "jr user list --project FOO --no-input"
Enter
Sleep 2s
