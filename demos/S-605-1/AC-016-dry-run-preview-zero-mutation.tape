Output AC-016-dry-run-preview-zero-mutation.gif
Output AC-016-dry-run-preview-zero-mutation.webm

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

Type `echo "# AC-016: --dry-run previews the planned change, zero mutation"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --component add:Backend --component remove:Frontend --dry-run`
Enter
Wait+Screen@6s /Planned/
Sleep 800ms

Type `echo "# Only the read-only resolution GET fired -- no PUT at all:"`
Enter
Type `jq -c . /tmp/s605-1-requests.log`
Enter
Wait+Screen@6s /GET/
Sleep 2s
