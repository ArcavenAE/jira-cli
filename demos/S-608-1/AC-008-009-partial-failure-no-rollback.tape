Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-008-009-partial-failure-no-rollback.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-008-009-partial-failure-no-rollback.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 800
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

# AC-008/AC-009: per-project atomicity on the local dummy mock server.
# Dummy projects DEMOA and DEMOB both have a component named exactly
# "SharedFail" -- DEMOA's PUT succeeds, DEMOB's PUT is mocked to return a
# 400 name collision. DEMOA's already-committed rename is NOT rolled back
# by DEMOB's failure (continue-on-error, no cross-project transaction);
# exit 1 reflects the partial failure (a partial-success batch must not
# look identical to a fully-successful one to a script).
Type "jr --no-input component rename SharedFail Renamed --all-projects --output json"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# Same fan-out, table mode.
Type "jr --no-input component rename SharedFail Renamed --all-projects"
Enter
Sleep 2s
