Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-005-local-wins-over-global.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-005-local-wins-over-global.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 420
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac005 config-no-project.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-005 / EC-X.7.002-1: BOTH a global --project (before the subcommand) and
# a local --project (after it) are supplied. LOCAL wins unconditionally, via
# clap's own global-value propagation -- no jr-level merge code exists.
# Same observable result as `component create`'s explicit local-over-global
# merge code.
Type "jr --project GLOBAL user list --project LOCAL --no-input"
Enter
Sleep 2s
