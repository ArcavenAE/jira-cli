Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-006-empty-string-passthrough.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-006-empty-string-passthrough.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 460
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

# --- Hidden setup: active profile HAS a configured default (project =
# "PAG") -- this is the interesting case for EC-X.7.002-6: does an empty
# string fall back to that configured default, or pass through as-is?
Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac006 config-default-project.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-006 / EC-X.7.002-6 / D-380: --project "" (empty string, local or
# global) passes through as Some(String::new()) and resolves the project
# key to the empty string WITHOUT consulting the configured default -- the
# active profile's configured default here is "PAG", but the mock server
# receives projectKeys= (empty), not projectKeys=PAG. Matching jr
# queue/jr requesttype's existing empty-string pass-through behavior.
Type `jr user list --project "" --no-input`
Enter
Sleep 2s
