Output docs/demo-evidence/S-cycle14-api-query-param/AC-005-empty-value-allowed.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-005-empty-value-allowed.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 520
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac005b"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# EC-X.16.001-1 / contrast for AC-005's M1: "k=" (empty VALUE, non-empty
# NAME) is ALLOWED -- NOT an error, unlike a missing "=" entirely.
Type "jr api /rest/x -q k= | python3 docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py"
Enter
Wait+Screen /k=/
Sleep 2s
