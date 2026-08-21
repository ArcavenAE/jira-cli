Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-001-007-list-fields-replace-key-present.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-001-007-list-fields-replace-key-present.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 760
Set Theme "Dracula"
Set Padding 20

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-575-1/target/debug:$PATH"
Enter
Sleep 200ms
Type "export JR_CONFIG_DIR=/private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/23ccb3c3-87f8-4b0c-9a98-aaa77c9e3b75/scratchpad/jr-demo-config"
Enter
Sleep 200ms
Type "export JR_BASE_URL=http://127.0.0.1:9977"
Enter
Sleep 200ms
Type "export JR_AUTH_HEADER='Basic ZGVtbzpkZW1v'"
Enter
Sleep 200ms
Type "clear"
Enter
Show

# AC-001 / BC-2.2.033 Postcondition 1: `--fields` on `issue list` REPLACES
# BASE_ISSUE_FIELDS entirely -- the fields sent to the mock's
# POST /rest/api/3/search/jql are exactly the requested CSV, no union.
# AC-007 / BC-2.2.033 Postcondition 3: `key` is always present in the
# output regardless of the --fields CSV.
Type "jr --no-input issue list --jql 'project = DEMO' --fields summary,status,comment --output json"
Enter
Sleep 2s
