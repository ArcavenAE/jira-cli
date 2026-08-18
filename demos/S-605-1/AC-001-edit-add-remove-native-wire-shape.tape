Output AC-001-edit-add-remove-native-wire-shape.gif
Output AC-001-edit-add-remove-native-wire-shape.webm

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

Type `echo "# AC-001: edit --component add:X --component remove:Y -> native update-verb wire shape"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --component add:Backend --component remove:Frontend`
Enter
Wait+Screen@6s /components/
Sleep 800ms

Type `echo "# Captured PUT body from the mock Jira server:"`
Enter
Type `jq -c 'select(.method=="PUT")' /tmp/s605-1-requests.log`
Enter
Wait+Screen@6s /update/
Sleep 2s
