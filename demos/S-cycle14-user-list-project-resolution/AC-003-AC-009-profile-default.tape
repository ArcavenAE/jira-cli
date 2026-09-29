Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-003-AC-009-profile-default.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-003-AC-009-profile-default.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 460
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

# --- Hidden setup: two-profile config -- "default" has NO project default,
# "alt" has project = "BAZ". No .jr.toml ancestor.
Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac003b config-alt-profile.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-003 EC-X.7.002-5 / AC-009: a non-default --profile's OWN configured
# project default resolves -- requires threading &Config through to
# handle_list without reloading (handle/handle_list must not call
# Config::load/load_with themselves, or --profile selection would be
# silently ignored). "default" profile has no project; "alt" has BAZ.
Type "jr --profile alt user list --no-input"
Enter
Sleep 2s
