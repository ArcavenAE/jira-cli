Output AC-015-label-component-mutex-exit64.gif
Output AC-015-label-component-mutex-exit64.webm

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

Type `echo "# AC-015 (error path): --label + --component on one key -> exit 64, zero HTTP"`
Enter
Sleep 500ms

Type `jr --no-input issue edit FOO-1 --label add:foo --component add:bar; echo "EXIT:$?"`
Enter
Wait+Screen@6s /EXIT:/
Sleep 800ms

Type `echo "# Proof of zero HTTP: the mock server log file was never created"`
Enter
Type `ls /tmp/s605-1-requests.log 2>&1 || echo "NO REQUESTS SENT -- zero HTTP confirmed"`
Enter
Wait+Screen@6s /confirmed/
Sleep 2s
