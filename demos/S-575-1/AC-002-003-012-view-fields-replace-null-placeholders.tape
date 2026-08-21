Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-002-003-012-view-fields-replace-null-placeholders.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-002-003-012-view-fields-replace-null-placeholders.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 900
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

# AC-002 / BC-2.3.041 Postcondition 1: `--fields` on `issue view` mirrors
# the list twin's REPLACE semantics via the new get_issue-family client
# method (BC-2.6.052) -- fields= on the GET is exactly the requested CSV.
# AC-003 / BC-2.2.033 Postcondition 2: named IssueFields struct fields NOT
# in the request (description, priority, assignee, ...) serialize as JSON
# null; the unnamed requested field (comment) flows through IssueFields.extra
# verbatim.
# AC-012 / BC-2.3.041 Postcondition 3: `key` is always present regardless
# of the --fields CSV contents.
Type "jr --no-input issue view DEMO-102 --fields summary,comment --output json"
Enter
Sleep 2s
