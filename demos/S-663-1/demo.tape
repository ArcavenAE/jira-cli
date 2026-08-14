# Demo evidence for S-663-1 / issue #663
# `jr auth switch --profile <X> <NAME>` now rejects the --profile flag
# with an exit-64 UserError instead of silently accepting it.
#
# Run from repo root with: vhs .factory/demos/S-663-1/demo.tape

Output .factory/demos/S-663-1/demo.gif

Set Shell "bash"
Set FontSize 16
Set Width 1200
Set Height 700
Set Padding 20
Set Theme "Dracula"

Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-663-1/target/debug:$PATH"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-config"
Enter
Type "clear"
Enter
Sleep 500ms

Type "# S-663-1: jr auth switch rejects the global --profile flag"
Enter
Sleep 1s

Type "# 1) --profile on 'auth switch' now exits 64 with a guard message"
Enter
Type "jr auth switch --profile sandbox sandbox"
Enter
Sleep 2s
Type `echo "exit code: $?"`
Enter
Sleep 1500ms

Type "clear"
Enter
Type "# 2) Same guard under --output json: envelope on stderr, stdout empty"
Enter
Type "jr --output json auth switch --profile sandbox sandbox"
Enter
Sleep 2s
Type `echo "exit code: $?"`
Enter
Sleep 1500ms

Type "clear"
Enter
Type "# 3) Correct usage still works: positional NAME, no --profile flag"
Enter
Type "jr auth switch sandbox"
Enter
Sleep 2s
Type "jr auth switch acme"
Enter
Sleep 2s

Type "clear"
Enter
Type "# 4) JR_PROFILE env var is unaffected -- only the CLI flag trips the guard"
Enter
Type "JR_PROFILE=sandbox jr auth switch acme"
Enter
Sleep 2500ms
