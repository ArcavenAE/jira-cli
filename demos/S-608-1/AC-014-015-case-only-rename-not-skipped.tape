Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-014-015-case-only-rename-not-skipped.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-014-015-case-only-rename-not-skipped.webm"

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

# AC-014: case-only rename ("CaseOnly" -> "caseonly"), single-project form.
# partial_match's case-insensitive lookup FINDS the component but must NOT
# treat OLD/NEW as "the same" and skip the PUT -- the PUT fires with
# body {"name":"caseonly"}, exit 0.
Type "jr --no-input component rename CaseOnly caseonly --project DEMOA --output json"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-015: identical case-only rename under --all-projects. Dummy projects
# DEMOA and DEMOB both have a component named exactly "CaseOnly" -> BOTH
# get PUT {"name":"caseonly"} (2 total calls) -- neither is skipped for
# casing reasons.
Type "jr --no-input component rename CaseOnly caseonly --all-projects --output json"
Enter
Sleep 2s
