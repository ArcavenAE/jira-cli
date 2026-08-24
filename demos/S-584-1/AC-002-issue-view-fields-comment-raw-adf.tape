Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/AC-002-issue-view-fields-comment-raw-adf.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/AC-002-issue-view-fields-comment-raw-adf.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 760
Set Theme "Dracula"
Set Padding 20

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-584-1/target/debug:$PATH"
Enter
Sleep 200ms
Type "export JR_CONFIG_DIR=/private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/9bab8252-896e-401f-947c-8524ea51fa8a/scratchpad/jr-demo-config"
Enter
Sleep 200ms
Type "export JR_BASE_URL=http://127.0.0.1:9584"
Enter
Sleep 200ms
Type "export JR_AUTH_HEADER='Basic ZGVtbzpkZW1v'"
Enter
Sleep 200ms
Type "clear"
Enter
Show

# AC-002 / BC-2.3.042 Postcondition 1: `jr issue view <KEY> --fields
# comment --output json` returns `.fields.comment.comments[].body` as the
# SAME raw ADF object as AC-001 (the `issue view` twin of the `issue list`
# demo) -- same s584_1_fixture_comment_adf() fixture, same mechanism
# (IssueFields.extra's #[serde(flatten)] passthrough), different command.
Type "jr --no-input issue view PROJ-584 --fields summary,comment --output json"
Enter
Sleep 2s

Type "jr --no-input issue view PROJ-584 --fields summary,comment --output json | jq '.fields.comment.comments[0].body.type, .fields.comment.comments[0].body.content[0].content[1]'"
Enter
Sleep 2s
