Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-001-002-bulk-add-and-mixed-add-remove.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/AC-001-002-bulk-add-and-mixed-add-remove.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 700
Set Theme "Dracula"
Set Padding 20

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-605-2/target/debug:$PATH"
Enter
Sleep 200ms
Type "export JR_BASE_URL=http://127.0.0.1:9999"
Enter
Sleep 200ms
Type "export JR_AUTH_HEADER='Basic dGVzdDp0ZXN0'"
Enter
Sleep 200ms
Type "clear"
Enter
Show

# AC-001: bulk `--component add:X` against 2+ keys routes through the async
# bulk-fields endpoint (POST /bulk/issues/fields -> POST body's
# multiselectComponents single-object wire shape -> polled to COMPLETE).
# Dummy project FOO, dummy issues FOO-1/FOO-2, dummy component "Backend" --
# all placeholder data against a LOCAL mock server (127.0.0.1:9999), not
# real Jira.
Type "jr --no-input issue edit FOO-1 FOO-2 --component add:Backend"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-002: mixed add:/remove: on the SAME bulk invocation issues TWO
# sequential bulk POSTs (ADD fully polled to completion, then REMOVE) --
# never one coalesced POST. The request log below (captured by the local
# mock server) proves two distinct POST /bulk/issues/fields calls fired.
Type "echo -n > /tmp/mock_jira_605_2_requests.log"
Enter
Sleep 300ms
Type "jr --no-input issue edit FOO-1 FOO-2 --component add:Backend --component remove:Docs"
Enter
Sleep 2s

Type "grep 'POST /rest/api/3/bulk/issues/fields' /tmp/mock_jira_605_2_requests.log | cat -n"
Enter
Sleep 2s
