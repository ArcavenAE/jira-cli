Output AC-017-F1-dry-run-bare-and-unknown-name.gif
Output AC-017-F1-dry-run-bare-and-unknown-name.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set TypingSpeed 15ms
Require jr

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-605-1/target/debug:$PATH"
Enter
Type "export JR_BASE_URL=http://127.0.0.1:9999 JR_AUTH_HEADER='Basic dGVzdDp0ZXN0'"
Enter
Type "rm -f /tmp/s605-1-requests.log; clear"
Enter
Show

Type `echo "# AC-017: bare --component X under --dry-run normalizes to add:X, matching the live echo"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --component Backend --dry-run`
Enter
Wait+Screen@6s /Planned/
Sleep 1500ms

Type `echo "# F1 (error path): unresolvable name under --dry-run"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --component add:Nonexistent --dry-run`
Enter
Wait+Screen@6s /Error/
Sleep 2s
