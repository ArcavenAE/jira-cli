Output AC-013-edit-json-echo.gif
Output AC-013-edit-json-echo.webm

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

Type `echo "# AC-013: --output json -- changed_fields.components is a normalized STRING, not an array"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --component Backend --output json`
Enter
Wait+Screen@6s /changed_fields/
Sleep 2500ms
