Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-004-exit64-json.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-004-exit64-json.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 360
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac004j config-no-project.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-004 / EC-X.7.002-4, --output json mode: same exit-64 condition, JSON
# render invariant (#526) -- routed through output::render_json, pretty-
# printed {"error": "...", "code": 64} envelope, zero HTTP calls.
Type "jr --output json user list --no-input"
Enter
Sleep 1500ms
Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
