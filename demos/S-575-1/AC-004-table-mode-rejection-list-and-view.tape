Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-004-table-mode-rejection-list-and-view.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-004-table-mode-rejection-list-and-view.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 700
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

# AC-004 / BC-2.2.033 Precondition 2 + Edge Case EC-2.2.033-3: `--fields`
# combined with TABLE mode (default output, no --output json) on `issue
# list` exits 64 PRE-HTTP with the canonical hint -- zero HTTP calls made
# (the mock server logs nothing for this command; it would if a request
# had gone out).
Type "jr --no-input issue list --jql 'project = DEMO' --fields summary"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-004 / BC-2.3.041 Edge Case EC-2.3.041-2: identical guard on
# `issue view` -- same exit code, same message.
Type "jr --no-input issue view DEMO-102 --fields summary,status"
Enter
Sleep 2s
