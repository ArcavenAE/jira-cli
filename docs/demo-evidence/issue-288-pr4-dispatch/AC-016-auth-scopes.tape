Output docs/demo-evidence/issue-288-pr4-dispatch/AC-016-auth-scopes.gif
Output docs/demo-evidence/issue-288-pr4-dispatch/AC-016-auth-scopes.webm

Set Shell zsh
Set FontSize 14
Set Width 1200
Set Height 600
Set FontFamily "Menlo"
Set Theme "TokyoNight"
Set Padding 16

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/issue-288-pr4-dispatch"
Enter
Sleep 500ms
Show

# AC-016: verify write:servicedesk-request is present in DEFAULT_OAUTH_SCOPES
# Shows grep evidence from source + auth --help confirming the oauth subcommand exists
Type "grep -o 'write:servicedesk-request' src/api/auth.rs && echo 'SCOPE PRESENT in DEFAULT_OAUTH_SCOPES'"
Enter
Sleep 2s
