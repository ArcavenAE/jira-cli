Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-001-002-single-project-rename-success.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-001-002-single-project-rename-success.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 700
Set Theme "Dracula"
Set Padding 20

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-608-1/target/debug:$PATH"
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

# AC-001/AC-002: single-project rename against a local dummy mock server
# (DEMOA project, dummy data only -- NOT real Jira). Resolves "ExactBack"
# scoped to DEMOA, PUTs {"name":"Renamed"}. --output json shows the exact
# BC-8.3.001 Postcondition 2 success shape.
Type "jr --no-input component rename ExactBack Renamed --project DEMOA --output json"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# Same rename, table mode.
Type "jr --no-input component rename ExactBack Renamed --project DEMOA"
Enter
Sleep 2s
