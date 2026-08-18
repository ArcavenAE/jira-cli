Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-HELP-rename-cli-surface.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-HELP-rename-cli-surface.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 900
Set Theme "Dracula"
Set Padding 20

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-608-1/target/debug:$PATH"
Enter
Sleep 200ms
Type "clear"
Enter
Show

# CLI surface: positional OLD/NEW, --project, --all-projects, --dry-run
# (S-608-1 story instruction item 1).
Type "jr component rename --help"
Enter
Sleep 4s
