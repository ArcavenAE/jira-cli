Output "/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-578-2/docs/demo-evidence/S-578-2/AC-009-asset-hint-malformed-shapes-error.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-578-2/docs/demo-evidence/S-578-2/AC-009-asset-hint-malformed-shapes-error.webm"
Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 20
Set Width 1200
Set Height 600
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 30
Set TypingSpeed 50ms

Hide
Type `export PATH="/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-578-2/target/debug:$PATH"`
Enter
Sleep 300ms
Require jr
Type "python3 docs/demo-evidence/S-578-2/mock_server.py asset_malformed 8099 >/tmp/jr-demo-mock-ac009.log 2>&1 & MOCKPID=$!"
Enter
Sleep 800ms
Type "rm -rf /tmp/jr-demo-ac009 && mkdir -p /tmp/jr-demo-ac009/cache /tmp/jr-demo-ac009/config"
Enter
Sleep 300ms
Type `export JR_BASE_URL="http://127.0.0.1:8099" JR_AUTH_HEADER="Basic dGVzdDp0ZXN0" JR_CACHE_DIR="/tmp/jr-demo-ac009/cache" JR_CONFIG_DIR="/tmp/jr-demo-ac009/config"`
Enter
Sleep 300ms
Type "clear"
Enter
Sleep 300ms
Show

Type "jr --no-input issue edit TEST-1 --field customfield_10001:asset="
Enter
Sleep 2s
Type "jr --no-input issue edit TEST-1 --field customfield_10001:asset=:12345"
Enter
Sleep 2s
Type "jr --no-input issue edit TEST-1 --field customfield_10001:asset=W:Y:Z"
Enter
Sleep 2s
Type "jr --no-input issue edit TEST-1 --field customfield_10001:asset=abc"
Enter
Sleep 2s

Sleep 2s

Hide
Type "kill $MOCKPID 2>/dev/null; wait $MOCKPID 2>/dev/null"
Enter
Sleep 400ms
Show
