Require jr

Output docs/demo-evidence/S-580-1/AC-013-json-array-shape.gif
Output docs/demo-evidence/S-580-1/AC-013-json-array-shape.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 600
Set Padding 20
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-580-1/setup.sh /tmp/jr-demo-cache-vhs-ac013b http://127.0.0.1:18766"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-580-1 AC-013: --output json returns the normalized array verbatim,
# pretty-printed via output::render_json (JSON render invariant #526) --
# the SAME degenerate entry that renders as "-"/"(unnamed)" in table mode
# emits raw JSON null for both id and label here (no glyph substitution
# in JSON mode).
Type "jr field options customfield_10084 --issue DEMO-1 --output json --no-input"
Enter
Sleep 2s
