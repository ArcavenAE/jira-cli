# VHS Demo — S-578-3 AC-006
# `:asset` L2-side workspace-id resolution in `jsm_create.rs`. Explicit
# `WORKSPACE:OBJECTID` form composes directly with NO cache/API lookup;
# bare `<objectId>` form calls `get_or_fetch_workspace_id` first. Both are
# success paths (exit 0) — the difference (0 vs 1 workspace-discovery GET)
# is a wire/network-level distinction verified by
# tests/issue_create_jsm.rs::test_bc_3_8_008_asset_{explicit_workspace_l2_composes_no_cache_lookup,bare_form_l2_resolves_workspace_before_build}
# (not independently visible from stdout, since both print the same
# `{"key": "HELP-42"}` success line).

Output docs/demo-evidence/S-578-3/AC-006-asset-l2-workspace-resolution.gif
Output docs/demo-evidence/S-578-3/AC-006-asset-l2-workspace-resolution.webm

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
Type "source /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/setup_ac006.sh"
Enter
Sleep 3s
Type "clear"
Enter
Sleep 500ms
Show

# === Demo: AC-006 — explicit WORKSPACE:OBJECTID (no cache lookup) vs bare OBJECTID (resolves first) ===

Type "jr issue create --project HELP --request-type 'Password Reset' --summary 'Explicit workspace:objectId' --field 'cf1:asset=WS-9:777' --no-input --output json"
Enter
Wait+Screen /key/
Sleep 1s

Type "jr issue create --project HELP --request-type 'Password Reset' --summary 'Bare objectId (resolves cached workspace)' --field 'cf2:asset=888' --no-input --output json"
Enter
Wait+Screen /key/
Sleep 1s

Hide
Type "pkill -f 'mock_jsm_server.py --port 18614'"
Enter
Show

Sleep 2s
