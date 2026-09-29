Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-fresh-query.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-001-fresh-query.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 520
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

# --- Hidden setup: fresh fake profile, JR_BASE_URL pointed at the local
# mock echo server. No real Jira instance is ever contacted.
Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac001a"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-001: BC-X.16.001 Behavior 1 / Postcondition 2 -- fresh query, no
# existing "?" in the path. NAME/VALUE percent-encoded exactly once via
# urlencoding::encode: space -> %20, "=" inside the VALUE -> %3D. The mock
# server echoes back query_raw (still percent-encoded, exactly as sent on
# the wire) so the encoding is visible directly, not just asserted.
Type "jr api /rest/api/3/search/jql -q jql='project = FOO ORDER BY created' -q maxResults=5"
Enter
Wait+Screen /query_raw/
Sleep 2s
