Output AC-007-create-initial-components.gif
Output AC-007-create-initial-components.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set TypingSpeed 15ms
Require jr

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-605-1/target/debug:$PATH"
Enter
Type "export JR_BASE_URL=http://127.0.0.1:9999 JR_AUTH_HEADER='Basic dGVzdDp0ZXN0'"
Enter
Type "rm -f /tmp/s605-1-requests.log; clear"
Enter
Show

Type `echo "# AC-007: issue create --component X --component Y sets the initial components array"`
Enter
Sleep 500ms

Type `jr --no-input issue create --project FOO --type Task --summary "New feature" --component Backend --component Frontend`
Enter
Wait+Screen@6s /Created/
Sleep 800ms

Type `echo "# Captured POST body -- fields.components, CLI input order:"`
Enter
Type `jq -c 'select(.method=="POST") | .body.fields.components' /tmp/s605-1-requests.log`
Enter
Wait+Screen@6s /Backend/
Sleep 2s
