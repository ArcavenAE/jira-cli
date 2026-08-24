Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/AC-004-view-table-mode-unaffected.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/AC-004-view-table-mode-unaffected.webm"

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

# AC-004 / BC-2.3.042 Edge Case EC-2.3.042-2 (error path): `--fields` is
# JSON-only (BC-2.3.041 Precondition 2), so combining `--fields comment`
# with the default table-mode output never reaches view.rs's table-mode
# description-row adf_to_text call site at all -- it exits 64 PRE-HTTP.
Type "jr --no-input issue view PROJ-584 --fields summary,comment; echo EXIT=$?"
Enter
Sleep 2s

# Control case: the table-mode description row's adf_to_text call site
# itself is untouched by this story -- a plain `issue view` (no --fields)
# against a different fixture issue still flattens its description ADF
# to plain text in the table.
Type "jr --no-input issue view PROJ-585"
Enter
Sleep 2s
