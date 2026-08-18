Output R7-edit-component-summary-atomic-put.gif
Output R7-edit-component-summary-atomic-put.webm

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

Type `echo "# Round-7 atomicity: --component + --summary in one edit -> a SINGLE combined PUT"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --component add:Backend --summary "New"`
Enter
Wait+Screen@6s /summary/
Sleep 800ms

Type `echo "# Exactly one PUT was sent, carrying update.components AND fields.summary together:"`
Enter
Type `jq -c 'select(.method=="PUT")' /tmp/s605-1-requests.log | wc -l | xargs -I{} echo "PUT count: {}"`
Enter
Wait+Screen@6s /count/
Sleep 800ms

Type `jq -c 'select(.method=="PUT")' /tmp/s605-1-requests.log`
Enter
Wait+Screen@6s /summary/
Sleep 2s
