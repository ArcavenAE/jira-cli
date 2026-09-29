Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-007-all-pagination.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-007-all-pagination.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 460
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

# --- Hidden setup: active profile has a configured default (project =
# "PAG"), no local/global flag -- the resolved project must be applied to
# EVERY paginated page, not just page 1.
Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac007 config-default-project.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-007 / Postcondition 5: once resolved (here, via the configured
# default -- no local/global flag at all), every paginated page carries
# the same projectKeys=<resolved-key>. The mock server returns 2 users on
# page 1 (startAt=0) and an empty page at startAt=100, ending pagination --
# demonstrating the resolved key is threaded through to every --all page,
# not just the first.
Type "jr user list --all --no-input"
Enter
Sleep 2s
