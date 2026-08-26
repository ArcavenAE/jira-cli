Require jr

Output docs/demo-evidence/S-580-1/AC-014-graceful-degrade.gif
Output docs/demo-evidence/S-580-1/AC-014-graceful-degrade.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 400
Set Padding 20
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-580-1/setup.sh /tmp/jr-demo-cache-vhs-ac014 http://127.0.0.1:18766"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-580-1 AC-014: a field with no enumerable options (free-text field,
# no allowedValues) degrades gracefully -- exit 0 (never an error), a
# classified hint on stderr, and an empty result on stdout.
Type "jr field options customfield_20000 --issue DEMO-1 --no-input"
Enter
Sleep 1500ms

Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
