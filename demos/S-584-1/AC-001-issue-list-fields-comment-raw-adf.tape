Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/AC-001-issue-list-fields-comment-raw-adf.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/AC-001-issue-list-fields-comment-raw-adf.webm"

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

# AC-001 / BC-2.2.034 Postcondition 1: `jr issue list --fields comment
# --output json` returns `.fields.comment.comments[].body` as the RAW ADF
# object Jira returned (type=doc / version=1 / content=[...]) -- never a
# flattened plain-text string. The mock server echoes back the SAME
# non-trivial ADF fixture (a strong-marked text run + a two-item bullet
# list) used by the S-584-1 wiremock test s584_1_fixture_comment_adf().
Type "jr --no-input issue list --jql 'project = PROJ' --fields summary,comment --output json"
Enter
Sleep 2s

# Highlight: no adf_to_text call site runs on this path -- the body is
# still a structured ADF document, not the flattened "**STRONGWORD**"
# markdown-ish string `issue comments` would produce (see AC-003).
Type "jr --no-input issue list --jql 'project = PROJ' --fields summary,comment --output json | jq '.[0].fields.comment.comments[0].body.type, .[0].fields.comment.comments[0].body.content[0].content[1]'"
Enter
Sleep 2s
