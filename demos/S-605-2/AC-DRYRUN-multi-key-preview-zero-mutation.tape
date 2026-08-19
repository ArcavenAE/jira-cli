Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-DRYRUN-multi-key-preview-zero-mutation.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-DRYRUN-multi-key-preview-zero-mutation.webm"

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

# --dry-run preview for a multi-key --component edit (mixed add:/remove:):
# table mode shows the affected dummy issues + planned changes, with ZERO
# mutating requests sent to the local mock server.
Type "echo -n > /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 300ms
Type "jr --no-input issue edit FOO-1 FOO-2 --component add:Backend --component remove:Docs --dry-run"
Enter
Sleep 2s

Type "grep -cE 'PUT |POST /rest/api/3/bulk' /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 2s
