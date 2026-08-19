Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-006-jql-single-match-single-key-path.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-006-jql-single-match-single-key-path.webm"

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

# AC-006: a --jql query matching exactly ONE dummy issue (FOO-9) routes to
# the single-key path (S-605-1's native update-verb PUT), NOT this story's
# bulk multiselectComponents path. The request log below proves it: a
# single PUT /issue/FOO-9 fires, with NO POST /bulk/issues/fields at all.
Type "echo -n > /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 300ms
Type 'jr --no-input issue edit --jql "key = FOO-9" --component add:Backend'
Enter
Sleep 2s

Type "cat /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 2s
