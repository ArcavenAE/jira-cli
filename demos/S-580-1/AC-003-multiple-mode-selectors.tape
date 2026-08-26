Require jr

Output docs/demo-evidence/S-580-1/AC-003-multiple-mode-selectors.gif
Output docs/demo-evidence/S-580-1/AC-003-multiple-mode-selectors.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 400
Set Padding 20
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-580-1/setup.sh /tmp/jr-demo-cache-vhs-ac003"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-580-1 AC-003: two-or-more mode selectors (--type + --issue together)
# -> exit 64, same message, zero HTTP (BC-X.14.001 Invariant 1).
Type "jr field options customfield_10084 --type Bug --issue FOO-1 --no-input"
Enter
Sleep 1500ms

Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
