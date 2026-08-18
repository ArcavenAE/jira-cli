Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-003-004-numeric-old-project-mismatch-notfound.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-003-004-numeric-old-project-mismatch-notfound.webm"

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

# AC-003: numeric OLD, M1 confirming GET on the local dummy mock server --
# component 10042 actually belongs to dummy project DEMOB, but --project
# DEMOA is supplied -> exit 64 pre-flight mismatch, ZERO PUT calls.
Type "jr --no-input component rename 10042 NewName --project DEMOA"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-004: numeric OLD, confirming GET 404s -> exit 64, ALWAYS the
# project-qualified not-found message (never the project-less variant).
Type "jr --no-input component rename 999999999 NewName --project DEMOA"
Enter
Sleep 2s
