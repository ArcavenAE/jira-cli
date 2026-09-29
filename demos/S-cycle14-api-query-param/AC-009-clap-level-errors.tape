Output docs/demo-evidence/S-cycle14-api-query-param/AC-009-clap-level-errors.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-009-clap-level-errors.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 680
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac009b"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# EC-X.16.002-8: -q -x=1 -- \"-x=1\" is a hyphen-LEADING space-separated
# token; -q has no allow_hyphen_values (same as -H/--header), so clap
# treats \"-x\" as a new, unrecognized flag -- exit 2, a CLAP error, never
# reaching parse_query_param's M1/M2 taxonomy at all.
Type `jr api /rest/x -q -x=1; echo "exit=$?"`
Enter
Wait+Screen /exit=2/
Sleep 900ms

# EC-X.16.002-10: -q as the LAST argv token (no following value at all,
# not even an empty one) -- clap itself rejects a genuinely MISSING value
# before parse_query_param ever runs -- exit 2, not 64.
Type `jr api /rest/x -q; echo "exit=$?"`
Enter
Wait+Screen /exit=2/
Sleep 2s
