# VHS Demo — S-578-3 AC-007
# `:asset` cold-cache workspace-discovery failure taxonomy at the JSM call
# site (VP-578-022, one of three independently-asserted call sites): 403/404
# -> "Assets is not available..." (exit 64); 200 + zero entries ->
# "No Assets workspace found..." (exit 64); 401 -> standard NotAuthenticated
# mapping (exit 2). The mock server is restarted between each sub-demo to
# switch GET /rest/servicedeskapi/assets/workspace's response.

Output docs/demo-evidence/S-578-3/AC-007-asset-cold-cache-taxonomy.gif
Output docs/demo-evidence/S-578-3/AC-007-asset-cold-cache-taxonomy.webm

Require jr

Set Shell "zsh"
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
Type "cd $(git rev-parse --show-toplevel)"
Enter
Sleep 500ms
Type "source /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/setup_ac007_base.sh"
Enter
Sleep 3s
Type "bash /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/switch_ac007.sh 403"
Enter
Sleep 2s
Type "clear"
Enter
Sleep 500ms
Show

# === Demo: AC-007 — 403 -> Assets not available on this Jira site ===

Type "jr issue create --project HELP --request-type 'Password Reset' --summary test --field 'cf:asset=456' --no-input"
Enter
Wait+Screen /Error/
Sleep 2s

Hide
Type "bash /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/switch_ac007.sh empty"
Enter
Sleep 2s
Type "clear"
Enter
Sleep 500ms
Show

# === Demo: AC-007 — 200 + zero workspace entries -> No Assets workspace found ===

Type "jr issue create --project HELP --request-type 'Password Reset' --summary test --field 'cf:asset=456' --no-input"
Enter
Wait+Screen /Error/
Sleep 2s

Hide
Type "bash /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/switch_ac007.sh 401"
Enter
Sleep 2s
Type "clear"
Enter
Sleep 500ms
Show

# === Demo: AC-007 — 401 -> standard NotAuthenticated mapping (exit 2), not a bespoke Assets message ===

Type "jr issue create --project HELP --request-type 'Password Reset' --summary test --field 'cf:asset=456' --no-input"
Enter
Wait+Screen /Error/
Sleep 2s

Hide
Type "pkill -f 'mock_jsm_server.py --port 18615'"
Enter
Show

Sleep 2s
