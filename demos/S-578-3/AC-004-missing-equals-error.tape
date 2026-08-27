# VHS Demo — S-578-3 AC-004
# `--field cf:option` with NO `=` at all resolves to the SAME pre-existing
# "missing '=' " exit-64 error the platform path uses (EC-3.8.008-2) — NOT
# a hint-syntax parse error, since `parse_field_kv`'s step-1 split-on-first-
# '=' never finds an '=' and the pair never reaches step 2's :kind
# extraction. Error path only — this AC has no distinct success case.

Output docs/demo-evidence/S-578-3/AC-004-missing-equals-error.gif
Output docs/demo-evidence/S-578-3/AC-004-missing-equals-error.webm

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
Type "source /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/setup_ac004.sh"
Enter
Sleep 3s
Type "clear"
Enter
Sleep 500ms
Show

# === Demo: AC-004 — `--field cf:option` (no `=` at all) is the pre-existing missing-'=' error ===

Type "jr issue create --project HELP --request-type 'Password Reset' --summary test --field 'cf:option' --no-input"
Enter
Wait+Screen /Error/
Sleep 2s

Hide
Type "pkill -f 'mock_jsm_server.py --port 18612'"
Enter
Show

Sleep 2s
