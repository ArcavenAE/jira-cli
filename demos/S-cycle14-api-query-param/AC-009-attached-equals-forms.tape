Output docs/demo-evidence/S-cycle14-api-query-param/AC-009-attached-equals-forms.gif
Output docs/demo-evidence/S-cycle14-api-query-param/AC-009-attached-equals-forms.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 680
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-api-query-param/setup.sh /tmp/jr-demo-cache-ac009a"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# EC-X.16.002-5: -q=v (short-flag attached, ONE \"=\") -- clap's own
# attached-value parsing strips exactly one leading \"=\", delivering
# raw=\"v\" (not \"=v\"). \"v\" has no \"=\" of its own -> M1, got: v.
Type `jr api /rest/x -q=v; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 700ms

# EC-X.16.002-6: -q==v (short-flag attached, TWO \"=\") -- only the FIRST
# \"=\" is stripped by clap, delivering raw=\"=v\". parse_query_param then
# splits THAT on its own first \"=\": empty NAME -> M2, got: =v.
Type `jr api /rest/x -q==v; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 700ms

# EC-X.16.002-7: --query-param==v (long-flag attached form) -- BYTE-
# IDENTICAL outcome to -q==v above, even though the long-flag parser has
# no separate \"strip one leading =\" step (clap_lex's split_once already
# produces the same raw=\"=v\").
Type `jr api /rest/x --query-param==v; echo "exit=$?"`
Enter
Wait+Screen /exit=64/
Sleep 2s
