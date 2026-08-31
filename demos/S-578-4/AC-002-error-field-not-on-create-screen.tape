# S-578-4 — AC-002 error path (pairs with the success tape). Confirms the
# reversal cuts BOTH ways: a `--field` that fails now fails with a
# createmeta-RESOLUTION error ("is not on the Create screen"), never the old,
# now-deleted DEC-188 guard string "--field is only valid with --request-type".
# Also exercises AC-005's cache-first NAME resolution path (this field is
# looked up by human display name via GET /rest/api/3/field — the customfield_
# bypass form is exercised separately in the paired success tape).
#
# Backend: same local mock Jira server as the AC-002 success tape (see that
# tape's header note for the JR_BASE_URL/JR_AUTH_HEADER/JR_CONFIG_DIR rationale).
# The mock is configured (via MOCK_LIST_FIELDS_JSON) to know about a field named
# "Vendor Portal ID" globally, but to OMIT it from the Create screen's field
# list — reproducing the exact server-side condition BC-3.3.011's taxonomy
# row 3 targets.
Output AC-002-error-field-not-on-create-screen.gif
Output AC-002-error-field-not-on-create-screen.webm

Require cargo
Require python3

Set Shell "bash"
Set FontSize 15
Set Width 1300
Set Height 400
Set FontFamily "Menlo"
Set Padding 20
Set TypingSpeed 30ms

Hide
Type "cd $(git rev-parse --show-toplevel)"
Enter
Sleep 500ms
Type "cargo build --quiet --bin jr"
Enter
Sleep 3s
Type "export PATH=$PWD/target/debug:$PATH"
Enter
Sleep 500ms
Type "export JR_CONFIG_DIR=/tmp/jr-demo-578-4/config JR_CACHE_DIR=/tmp/jr-demo-578-4/cache"
Enter
Sleep 500ms
Type `export MOCK_LIST_FIELDS_JSON='[{"id":"customfield_10099","name":"Vendor Portal ID","custom":true,"schema":{"type":"string"}}]'`
Enter
Sleep 500ms
Type "python3 docs/demo-evidence/S-578-4/mock/mock_jira.py 18572 >/tmp/mock-578-4-002err.log 2>&1 &"
Enter
Sleep 500ms
Type "until curl -s -o /dev/null http://127.0.0.1:18572/rest/api/3/field; do sleep 0.2; done"
Enter
Sleep 1s
Type "export JR_BASE_URL=http://127.0.0.1:18572 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'"
Enter
Sleep 500ms
Type "clear"
Enter
Sleep 500ms
Show

Type "jr issue create --project DEMO --type Task --summary 'New feature request' --field 'Vendor Portal ID=XYZ' --no-input"
Enter
Sleep 1s
Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
