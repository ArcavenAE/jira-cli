Output docs/demo-evidence/FIX-P5-001/AC-5-auth-list-unchanged.gif
Output docs/demo-evidence/FIX-P5-001/AC-5-auth-list-unchanged.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 420
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms
Set WaitTimeout 15s

Hide
Type "source docs/demo-evidence/FIX-P5-001/setup.sh /tmp/jr-demo-fixp5-auth /tmp/jr-demo-fixp5.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# `jr auth list` performs no HTTP at all (pure config + keychain-probe
# render) -- unaffected by this fix's render_table wiring beyond routing
# through the same sanitize_table_cell chokepoint, which is a no-op here
# since every value (profile name, URL, env tag, auth method, status) is
# jr's own config/derived text, never server-supplied. Included as a cheap
# "nothing regressed" check, per BC-7.1.006's own Source citation of
# auth/list.rs's render_list_table as an unaffected existing render_table
# call site.
Type `echo "=== jr auth list -- unchanged, zero HTTP calls ==="`
Enter
Wait+Screen /zero HTTP/
Sleep 500ms

Type "jr auth list"
Enter
Wait+Screen /no-credentials/
Sleep 1500ms

Type "wc -l /tmp/jr-demo-fixp5.log"
Enter
Wait+Screen /jr-demo-fixp5.log/
Sleep 2s
