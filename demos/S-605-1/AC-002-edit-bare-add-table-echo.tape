Output AC-002-edit-bare-add-table-echo.gif
Output AC-002-edit-bare-add-table-echo.webm

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

Type `echo "# AC-002/AC-012: bare --component Backend (no prefix) normalizes to ADD"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --component Backend`
Enter
Wait+Screen@6s /components/
Sleep 800ms

Type `echo "# Captured PUT body -- bare input became {\"add\":{\"name\":\"Backend\"}}:"`
Enter
Type `jq -c 'select(.method=="PUT")' /tmp/s605-1-requests.log`
Enter
Wait+Screen@6s /add/
Sleep 2s
