Require jr

Output docs/demo-evidence/S-580-1/AC-002-zero-mode-selectors.gif
Output docs/demo-evidence/S-580-1/AC-002-zero-mode-selectors.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 400
Set Padding 20
Set TypingSpeed 40ms

# --- Hidden setup: isolated fake profile so config/auth resolve; no HTTP
# call is ever made on this path -- resolve_field_context's pure arity
# check (BC-X.14.001 Invariant 1) fires and rejects BEFORE any network call.
Hide
Type "source docs/demo-evidence/S-580-1/setup.sh /tmp/jr-demo-cache-vhs-ac002"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-580-1 AC-002: zero mode selectors (no --type/--request-type/--issue)
# -> exit 64, "specify exactly one of --type, --request-type, --issue".
Type "jr field options customfield_10084 --no-input"
Enter
Sleep 1500ms

Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
