Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-013-scope-selection-guards.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-013-scope-selection-guards.webm"

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

# AC-013 Part 1: neither --project nor --all-projects -> application-level
# exit 64 guard (DEC-188, JrError::UserError), naming both flags. Zero HTTP
# (JR_BASE_URL points at the local mock; the guard fires pre-flight).
Type "jr --no-input component rename A B"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-013 Part 2: BOTH supplied locally (--project X --all-projects, both on
# the subcommand's own arg list) -> clap conflicts_with -> exit 2.
Type "jr --no-input component rename A B --project FOO --all-projects"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-013 Part 3 (fix burst 7 finding): the GLOBAL --project flag propagates
# into the subcommand's local field via clap's global-value inheritance, so
# clap's conflicts_with never fires for THIS combination -- an
# application-level guard rejects it separately, exit 64, naming the global
# flag explicitly.
Type "jr --no-input --project FOO component rename A B --all-projects"
Enter
Sleep 2s
