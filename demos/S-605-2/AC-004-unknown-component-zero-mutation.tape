Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-004-unknown-component-zero-mutation.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-004-unknown-component-zero-mutation.webm"

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

# AC-004: an unknown component name on a bulk (2+ key) --component edit
# resolves against the dummy FOO project's component list BEFORE any bulk
# POST is built -- an unknown name exits 64 with ZERO bulk POST calls.
Type "echo -n > /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 300ms
Type "jr --no-input issue edit FOO-1 FOO-2 --component add:NoSuchComponent"
Enter
Sleep 2s

Type "echo exit code is $?"
Enter
Sleep 1s

Type "grep -c 'POST /rest/api/3/bulk/issues/fields' /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 2s
