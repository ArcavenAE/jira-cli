Output docs/demo-evidence/FIX-P5-001/AC-1-before-after-field-options.gif
Output docs/demo-evidence/FIX-P5-001/AC-1-before-after-field-options.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 15
Set Width 1300
Set Height 620
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms
Set WaitTimeout 15s

Hide
Type "source docs/demo-evidence/FIX-P5-001/setup.sh /tmp/jr-demo-fixp5-before /tmp/jr-demo-fixp5.log before"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# BEFORE FIX: develop tip 2ee422e0 (pre-FIX-P5-001), built in a separate
# temporary worktree. render_table had NO sanitize_table_cell chokepoint at
# this commit -- a server-supplied option label's raw ANSI/control bytes
# went straight into the comfy_table cell and out to the terminal.
Type `echo "=== BEFORE FIX (develop tip 2ee422e0) -- jr field options, cat -v ==="`
Enter
Wait+Screen /BEFORE FIX/
Sleep 500ms

Type "jr field options customfield_10300 --issue FOO-1 | cat -v"
Enter
Wait+Screen /Plain/
Sleep 2s

Hide
Type "source docs/demo-evidence/FIX-P5-001/setup.sh /tmp/jr-demo-fixp5-after /tmp/jr-demo-fixp5.log"
Enter
Sleep 300ms
Type "clear"
Enter
Show

# AFTER FIX: this worktree's binary (fix/FIX-P5-001, BC-7.1.006). Same
# hostile fixture, same command -- output::sanitize_table_cell now strips
# every ANSI/control sequence before the cell reaches comfy_table.
Type `echo "=== AFTER FIX (fix/FIX-P5-001) -- jr field options, cat -v ==="`
Enter
Wait+Screen /AFTER FIX/
Sleep 500ms

Type "jr field options customfield_10300 --issue FOO-1 | cat -v"
Enter
Wait+Screen /Plain/
Sleep 1s

Type `echo "=== raw ESC byte count in AFTER output (expect 0) ==="`
Enter
Wait+Screen /expect 0/
Sleep 300ms
Type `jr field options customfield_10300 --issue FOO-1 | grep -c $'\x1b' || echo "0 (clean)"`
Enter
Wait+Screen /clean/
Sleep 1s

# --output json is NEVER sanitized (BC-7.1.006 EC-12) -- the identical
# hostile payload round-trips through JSON unsanitized. Proven via a real
# serde_json-equivalent parse (python3 json), not string matching.
Type `echo "=== --output json is never sanitized (EC-12) ==="`
Enter
Wait+Screen /EC-12/
Sleep 500ms
Type `jr field options customfield_10300 --issue FOO-1 --output json | python3 -c "import json,sys; d=json.load(sys.stdin); print(repr(d[0]['label'])); assert chr(0x1b) in d[0]['label']; print('raw ESC preserved in JSON: OK')"`
Enter
Wait+Screen /preserved in JSON/
Sleep 2s
