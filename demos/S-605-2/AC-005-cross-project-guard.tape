Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-005-cross-project-guard.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-005-cross-project-guard.webm"

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

# AC-005: keys spanning 2+ distinct projects (dummy FOO-1 + dummy BAR-1)
# with --component exit 64 BEFORE any HTTP call -- component ids are
# project-scoped, so a single bulk edit cannot correctly target more than
# one project. This guard is purely client-side string parsing (no mock
# server round-trip needed at all), so the request log stays empty.
Type "echo -n > /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 300ms
Type "jr --no-input issue edit FOO-1 BAR-1 --component add:Backend"
Enter
Sleep 2s

Type "echo exit code is $?"
Enter
Sleep 1s

Type "wc -l < /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 2s
