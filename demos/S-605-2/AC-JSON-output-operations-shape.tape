Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-JSON-output-operations-shape.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-JSON-output-operations-shape.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 700
Set Theme "Dracula"
Set Padding 20

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-605-2/target/debug:$PATH"
Enter
Sleep 200ms
Type "export JR_BASE_URL=http://127.0.0.1:9999"
Enter
Sleep 200ms
Type "export JR_AUTH_HEADER='Basic dGVzdDp0ZXN0'"
Enter
Sleep 200ms
Type "clear"
Enter
Show

# `--output json` on the bulk --component path renders the
# {"operations":[{"taskId":...,"action":...,"results":[...]}]} shape --
# pretty-printed via output::render_json (JSON render invariant #526).
Type "jr --no-input issue edit FOO-1 FOO-2 --component add:Backend --output json"
Enter
Sleep 2s
