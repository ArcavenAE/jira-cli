# VHS Demo — S-578-3 AC-005
# `:asset` malformed-value catalog on the JSM path — validated at the L2
# call site (`jsm_create.rs::resolve_asset_field_l2`) BEFORE any workspace-
# discovery GET or JSM POST. Four exit-64 cases in the deterministic check
# order (empty value; empty workspace segment with ':' present; extra colon;
# non-numeric objectId) mirroring the platform path's `compose_asset_hint`
# catalog verbatim. All four are error paths — this AC has no success case
# of its own (well-formed :asset values are AC-006's demo).

Output docs/demo-evidence/S-578-3/AC-005-asset-malformed-catalog.gif
Output docs/demo-evidence/S-578-3/AC-005-asset-malformed-catalog.webm

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
Type "source /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/setup_ac005.sh"
Enter
Sleep 3s
Type "clear"
Enter
Sleep 500ms
Show

# === Demo: AC-005 — :asset malformed-value catalog (EC-2a/EC-2c/EC-2d/EC-3), zero HTTP each ===

Type "jr issue create --project HELP --request-type 'Password Reset' --summary test --field 'cf:asset=' --no-input"
Enter
Wait+Screen /Error/
Sleep 1500ms

Type "jr issue create --project HELP --request-type 'Password Reset' --summary test --field 'cf:asset=:777' --no-input"
Enter
Wait+Screen /Error/
Sleep 1500ms

Type "jr issue create --project HELP --request-type 'Password Reset' --summary test --field 'cf:asset=WS:OBJ:X' --no-input"
Enter
Wait+Screen /Error/
Sleep 1500ms

Type "jr issue create --project HELP --request-type 'Password Reset' --summary test --field 'cf:asset=abc' --no-input"
Enter
Wait+Screen /Error/
Sleep 1500ms

Hide
Type "pkill -f 'mock_jsm_server.py --port 18613'"
Enter
Show

Sleep 2s
