Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-003-omitted-summary-null-EC7-fix.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/AC-003-omitted-summary-null-EC7-fix.webm"

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

# AC-003 / BC-2.2.033 Postcondition 2, the EC-2.2.033-7 regression this
# story fixed (IssueFields.summary made Option<String>, commit 2981294c
# "fix(issue): make IssueFields.summary Option<String> (Adversary Pass 5)"):
# `--fields status` OMITS "summary" from the request entirely -- this used
# to be a hard deserialization failure when Jira's response genuinely
# lacked a summary key. It now succeeds and "summary" renders as JSON null.
Type "jr --no-input issue list --jql 'project = DEMO' --fields status --output json"
Enter
Sleep 2s
