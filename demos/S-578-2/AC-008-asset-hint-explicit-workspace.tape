Output "/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-578-2/docs/demo-evidence/S-578-2/AC-008-asset-hint-explicit-workspace.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-578-2/docs/demo-evidence/S-578-2/AC-008-asset-hint-explicit-workspace.webm"
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
Type "python3 docs/demo-evidence/S-578-2/mock_server.py asset_explicit_workspace 8099 >/tmp/jr-demo-mock-ac008.log 2>&1 & MOCKPID=$!"
Enter
Sleep 800ms
Type "rm -rf /tmp/jr-demo-ac008 && mkdir -p /tmp/jr-demo-ac008/cache /tmp/jr-demo-ac008/config"
Enter
Sleep 300ms
Type `export JR_BASE_URL="http://127.0.0.1:8099" JR_AUTH_HEADER="Basic dGVzdDp0ZXN0" JR_CACHE_DIR="/tmp/jr-demo-ac008/cache" JR_CONFIG_DIR="/tmp/jr-demo-ac008/config"`
Enter
Sleep 300ms
Type "clear"
Enter
Sleep 300ms
Show

Type "jr --no-input --output json issue edit TEST-1 --field customfield_10002:asset=wsXYZ:456 --dry-run"
Enter
Sleep 2s

Sleep 2s

Hide
Type "kill $MOCKPID 2>/dev/null; wait $MOCKPID 2>/dev/null"
Enter
Sleep 400ms
Show
