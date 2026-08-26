Require jr

Output docs/demo-evidence/S-578-1/AC-004-bare-field-not-rejected.gif
Output docs/demo-evidence/S-578-1/AC-004-bare-field-not-rejected.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 500
Set Padding 20
Set TypingSpeed 40ms

# --- Hidden setup: same fake profile as the hinted-field demo. This time the
# --field pair is BARE (no :kind tag), so the S-578-1 interim guard does NOT
# fire -- the command proceeds past the guard to the (unreachable, fake-host)
# HTTP call and fails there instead, proving the guard was never tripped.
Hide
Type "source docs/demo-evidence/S-578-1/setup-edit.sh /tmp/jr-demo-cache-vhs-bare"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-578-1 AC-004: a bare (unhinted) --field NAME=VALUE pair is NOT rejected
# by the interim guard -- notice there is no "not yet supported" message.
# It proceeds past the guard to the HTTP call, which fails on the fake host
# (network error), demonstrating the guard was never tripped for this form.
Type "jr issue edit SOME-1 --field cf=10042 --no-input"
Enter
Sleep 4s

Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
