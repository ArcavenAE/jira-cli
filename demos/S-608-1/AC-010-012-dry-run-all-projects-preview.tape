Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-010-012-dry-run-all-projects-preview.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-010-012-dry-run-all-projects-preview.webm"

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

# AC-010: --dry-run --all-projects against the local dummy mock server.
# ZERO PUT calls are issued (VP-COMPONENT-008) -- the mock server would
# reject any PUT to a non-mocked path, so a successful preview here is
# itself evidence of zero mutation. Dummy project DEMOA has a single
# unambiguous "DupDemo" match (previewed as a target); dummy project DEMOC
# has TWO components both named "DupDemo"/"DUPDEMO" (case-insensitively
# equal) -- an intra-project duplicate, surfaced as a "wouldFail" entry
# (Step-4.5 fix burst 4, Invariant-1 extension) rather than silently picked.
Type "jr --no-input component rename DupDemo Renamed --all-projects --dry-run --output json"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# Same preview, table mode: "DRY RUN -- no changes will be made." header,
# one target line, one "WOULD FAIL --" line.
Type "jr --no-input component rename DupDemo Renamed --all-projects --dry-run"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-012: numeric OLD under --dry-run --all-projects -- BC-8.3.002's
# pre-flight rejection fires FIRST, exit 64, ZERO HTTP (not even
# list_projects) -- the rejection and the dry-run preview are mutually
# exclusive outcomes for this input.
Type "jr --no-input component rename 10042 Renamed --all-projects --dry-run"
Enter
Sleep 2s
