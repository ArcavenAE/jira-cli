Output docs/demo-evidence/issue-288-pr4-dispatch/AC-001-jsm-create-help.gif
Output docs/demo-evidence/issue-288-pr4-dispatch/AC-001-jsm-create-help.webm

Set Shell zsh
Set FontSize 14
Set Width 1200
Set Height 700
Set FontFamily "Menlo"
Set Theme "TokyoNight"
Set Padding 16

Hide
Type "cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/issue-288-pr4-dispatch"
Enter
Sleep 500ms
Show

# AC-001/AC-002: jr issue create --help shows --request-type, --field, --on-behalf-of flags
# Verifies clap wiring: dispatch fork exists (AC-001) and platform path is unchanged (AC-002)
Type "./target/debug/jr issue create --help"
Enter
Sleep 2s
