Output F1-edit-numeric-component-ids.gif
Output F1-edit-numeric-component-ids.webm

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

Type `echo "# F1 hardening: numeric --component values wire as {id:...}, never {name:...}"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --component add:10001 --component remove:10002`
Enter
Wait+Screen@6s /components/
Sleep 800ms

Type `echo "# Captured PUT body -- numeric add/remove targets wire by id:"`
Enter
Type `jq -c 'select(.method=="PUT")' /tmp/s605-1-requests.log`
Enter
Wait+Screen@6s /id/
Sleep 2s
