Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-005-011-empty-malformed-csv-rejection.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-005-011-empty-malformed-csv-rejection.webm"

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

# AC-005 / BC-2.2.033 Edge Cases EC-2.2.033-4/EC-2.2.033-5: an empty
# --fields CSV exits 64 PRE-HTTP -- an empty segment is REJECTED, not
# silently dropped.
Type "jr --no-input issue list --jql 'project = DEMO' --fields '' --output json"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# Same guard: an embedded empty segment ("summary,,status") is rejected
# too, not silently collapsed to ["summary","status"].
Type "jr --no-input issue list --jql 'project = DEMO' --fields 'summary,,status' --output json"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-011 / BC-2.3.041 Edge Case EC-2.3.041-3: the same empty-CSV guard on
# `issue view`, independently enforced on that path.
Type "jr --no-input issue view DEMO-102 --fields '' --output json"
Enter
Sleep 2s
