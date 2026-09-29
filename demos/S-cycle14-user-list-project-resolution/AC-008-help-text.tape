Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-008-help-text.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-008-help-text.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 620
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac008 config-no-project.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-008 / VP-USER-LIST-PROJECT-001(d): jr user list --help exits 0 and its
# --project help text now reads "overrides the configured default project"
# / "Required when no project is configured in `.jr.toml` or the active
# profile" -- reflecting the new fallback chain instead of implying the
# flag is unconditionally required.
Type "jr user list --help"
Enter
Sleep 2500ms
