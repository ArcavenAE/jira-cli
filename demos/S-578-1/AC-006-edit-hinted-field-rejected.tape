Require jr

Output docs/demo-evidence/S-578-1/AC-006-edit-hinted-field-rejected.gif
Output docs/demo-evidence/S-578-1/AC-006-edit-hinted-field-rejected.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 500
Set Padding 20
Set TypingSpeed 40ms

# --- Hidden setup: point jr at a fake profile so config/auth resolve, but no
# HTTP call is ever made -- the S-578-1 interim guard fires BEFORE any HTTP
# call on the edit path, so no live/mock Jira server is required here.
Hide
Type "source docs/demo-evidence/S-578-1/setup-edit.sh /tmp/jr-demo-cache-vhs-edit"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-578-1 AC-006/EC-1: a :kind-hinted --field on `issue edit` is rejected by
# the interim guard (reject_unsupported_hint_kinds) before any HTTP call.
Type "jr issue edit SOME-1 --field cf:id=10042 --no-input"
Enter
Sleep 1500ms

Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
