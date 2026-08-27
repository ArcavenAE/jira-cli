# VHS Demo — S-578-3 AC-002
# JSM `issue create --field` kind-aware dispatch: bare/:id/:name hints all
# route through JsmRequestBuilder::build() to a successful JSM request
# submission — the kind-aware requestFieldValues wire-shape difference
# (string-wrap vs {"id":...}/{"name":...}) is verified at the wire level by
# tests/issue_create_jsm.rs::test_bc_3_8_008_build_kind_aware_dispatch_{id,name,option_bare_parity}
# (not observable from stdout — jr's success output is `{"key": "..."}`
# regardless of which kind wrapped which field).

Output docs/demo-evidence/S-578-3/AC-002-kind-aware-dispatch.gif
Output docs/demo-evidence/S-578-3/AC-002-kind-aware-dispatch.webm

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
Type "source /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/setup_ac002.sh"
Enter
Sleep 3s
Type "clear"
Enter
Sleep 500ms
Show

# === Demo: AC-002 — kind-aware --field dispatch (bare, :id, :name) on the JSM path ===

Type "jr issue create --project HELP --request-type 'Password Reset' --summary 'Bare hint (string-wrap)' --field 'cf_plain=Widget A' --no-input --output json"
Enter
Wait+Screen /key/
Sleep 1s

Type "jr issue create --project HELP --request-type 'Password Reset' --summary 'Id hint' --field 'cf_owner:id=10001' --no-input --output json"
Enter
Wait+Screen /key/
Sleep 1s

Type "jr issue create --project HELP --request-type 'Password Reset' --summary 'Name hint' --field 'cf_severity:name=High' --no-input --output json"
Enter
Wait+Screen /key/
Sleep 1s

Hide
Type "pkill -f 'mock_jsm_server.py --port 18610'"
Enter
Show

Sleep 2s
