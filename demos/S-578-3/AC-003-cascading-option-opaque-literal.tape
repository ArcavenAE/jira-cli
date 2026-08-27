# VHS Demo — S-578-3 AC-003
# JSM `:option` hint on a cascading-shaped value (`Parent>Child`) is treated
# as an OPAQUE literal — no `>`-split exists anywhere in the JSM dispatch
# path (BC-3.4.027's cascading composition is NOT extended to JSM this
# cycle). `jr` does not reject or reinterpret it; the entire "Parent>Child"
# string is sent verbatim. Success path only — AC-003 is about NOT
# rejecting this shape, not an error case.

Output docs/demo-evidence/S-578-3/AC-003-cascading-option-opaque-literal.gif
Output docs/demo-evidence/S-578-3/AC-003-cascading-option-opaque-literal.webm

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
Type "source /private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/783d0dac-654d-4686-a258-5e8c899f9fc5/scratchpad/s578-3-demo/setup_ac003.sh"
Enter
Sleep 3s
Type "clear"
Enter
Sleep 500ms
Show

# === Demo: AC-003 — cascading `>` on :option is an opaque literal (bare-parity string-wrap) ===

Type "jr issue create --project HELP --request-type 'Password Reset' --summary 'Cascading value, sent as-is' --field 'cf:option=Parent>Child' --no-input --output json"
Enter
Wait+Screen /key/
Sleep 2s

Hide
Type "pkill -f 'mock_jsm_server.py --port 18611'"
Enter
Show

Sleep 2s
