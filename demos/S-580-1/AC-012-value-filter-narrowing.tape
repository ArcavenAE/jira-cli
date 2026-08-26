Require jr

Output docs/demo-evidence/S-580-1/AC-012-value-filter-narrowing.gif
Output docs/demo-evidence/S-580-1/AC-012-value-filter-narrowing.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 400
Set Padding 20
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-580-1/setup.sh /tmp/jr-demo-cache-vhs-ac012 http://127.0.0.1:18766"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-580-1 AC-012: --value <substring> narrows the list client-side
# (case-insensitive, id-or-label match). "silver" matches the "Silver"
# parent, so the parent AND its "Silver Plus" child are retained --
# a self-matching parent keeps all of its children unfiltered. "Gold"
# and the degenerate entry are excluded (no match source).
Type "jr field options customfield_10084 --issue DEMO-1 --value silver --no-input"
Enter
Sleep 2s
