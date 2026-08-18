Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-005-006-007-all-projects-discovery.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-005-006-007-all-projects-discovery.webm"

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

# AC-005: --all-projects exact-equality matching against the local dummy
# mock server's 4 dummy projects. Dummy project DEMOA has a component named
# exactly "ExactBack"; dummy project DEMOB has "ExactBackend" (a superset
# string, NOT equal) -> DEMOA renames, DEMOB is silently skipped -- exact
# case-insensitive equality, never partial_match's substring semantics.
Type "jr --no-input component rename ExactBack Renamed --all-projects --output json"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-006: zero projects contain a component named OLD -> exit 0 (not an
# error), "0 renamed".
Type "jr --no-input component rename ZeroMatchXYZ Renamed --all-projects"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-007: numeric OLD under --all-projects is rejected pre-flight -- exit
# 64, ZERO HTTP (no list_projects, no per-project GETs).
Type "jr --no-input component rename 10042 Renamed --all-projects"
Enter
Sleep 2s
