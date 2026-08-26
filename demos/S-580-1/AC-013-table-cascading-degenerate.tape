Require jr

Output docs/demo-evidence/S-580-1/AC-013-table-cascading-degenerate.gif
Output docs/demo-evidence/S-580-1/AC-013-table-cascading-degenerate.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 500
Set Padding 20
Set TypingSpeed 40ms

# --- Hidden setup: isolated fake profile pointed at a local mock Jira
# server (mock_editmeta_server.py) serving GET
# /rest/api/3/issue/DEMO-1/editmeta, so the M1 (--issue) enumeration
# mechanism (get_editmeta, reused verbatim -- AC-007) can be demonstrated
# end-to-end without a real Jira instance. The mock server is started by
# the recording harness BEFORE this tape runs (see evidence-report.md).
Hide
Type "source docs/demo-evidence/S-580-1/setup.sh /tmp/jr-demo-cache-vhs-ac013a http://127.0.0.1:18766"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-580-1 AC-009/AC-010/AC-013: table output, ID/Label columns, cascading
# child indented under its parent, and a degenerate entry (missing id AND
# label) rendered with the NULL_GLYPH "-" / "(unnamed)" placeholders
# rather than being dropped.
Type "jr field options customfield_10084 --issue DEMO-1 --no-input"
Enter
Sleep 2s
