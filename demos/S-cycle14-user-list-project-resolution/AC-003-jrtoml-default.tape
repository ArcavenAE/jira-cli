Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-003-jrtoml-default.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-003-jrtoml-default.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 460
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

# --- Hidden setup: fresh fake profile with NO project default, but a
# .jr.toml written into the fresh cwd with project = "BAR" (4th arg).
Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac003a config-no-project.toml BAR"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-003 / EC-X.7.002-3 (.jr.toml sub-cell): no local flag, no global flag --
# a bare `jr user list` falls back to resolve_user_list_project's
# Config::project_key chain, which consults .jr.toml first.
Type "cat .jr.toml"
Enter
Sleep 800ms
Type "jr user list --no-input"
Enter
Sleep 2s
