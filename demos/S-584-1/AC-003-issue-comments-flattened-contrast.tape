Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/AC-003-issue-comments-flattened-contrast.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/AC-003-issue-comments-flattened-contrast.webm"

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

# AC-003 / BC-2.2.034 Postcondition 2: the PRE-EXISTING, unrelated `jr issue
# comments <KEY>` command run against the SAME PROJ-584 fixture issue (same
# s584_1_fixture_comment_adf() ADF body served by the mock) still renders
# FLATTENED plain text via adf::adf_to_text -- confirming the new
# `--fields comment` raw-ADF path (AC-001/AC-002) and this pre-existing
# flattening path remain fully independent and do not regress each other.
Type "jr --no-input issue comments PROJ-584"
Enter
Sleep 2s

# Contrast callout: same underlying ADF, two different renderings --
# `issue list/view --fields comment` => raw ADF object (AC-001/AC-002);
# `issue comments` => flattened plain text (STRONGWORD / bullet markers),
# never JSON, never a raw type:doc structure.
Type "jr --no-input issue comments PROJ-584 | grep -c type || echo no-raw-adf-json-in-issue-comments-output"
Enter
Sleep 2s
