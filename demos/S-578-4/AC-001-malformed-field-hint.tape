# S-578-4 — AC-001 step 2a: parse_field_kv hint-parse pass. A malformed
# --field NAME:kind=VALUE hint (an unrecognized `kind`) exits 64 at step 2a,
# before the step 2b D2 collision guard and before project/type resolution
# or any HTTP call — same pure parser S-578-1 already validates, reused
# verbatim on the create path. Pairs with a WELL-FORMED hint (":id" kind) on
# the same invocation shape, succeeding all the way to create (exit 0),
# to show the parser's happy path alongside its error path.
Output AC-001-malformed-field-hint.gif
Output AC-001-malformed-field-hint.webm

Require cargo
Require python3

Set Shell "bash"
Set FontSize 15
Set Width 1300
Set Height 450
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
Type `export MOCK_FIELDS_JSON='[{"fieldId":"customfield_10060","name":"Environment","schema":{"type":"option","custom":"com.atlassian.jira.plugin.system.customfieldtypes:select"},"allowedValues":[{"id":"20001","value":"Production"},{"id":"20002","value":"Staging"}]}]'`
Enter
Sleep 500ms
Type `export MOCK_LIST_FIELDS_JSON='[{"id":"customfield_10060","name":"Environment","custom":true,"schema":{"type":"option","custom":"com.atlassian.jira.plugin.system.customfieldtypes:select"}}]'`
Enter
Sleep 500ms
Type "python3 docs/demo-evidence/S-578-4/mock/mock_jira.py 18574 >/tmp/mock-578-4-001.log 2>&1 &"
Enter
Sleep 500ms
Type "until curl -s -o /dev/null http://127.0.0.1:18574/rest/api/3/field; do sleep 0.2; done"
Enter
Sleep 1s
Type "export JR_BASE_URL=http://127.0.0.1:18574 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'"
Enter
Sleep 500ms
Type "clear"
Enter
Sleep 500ms
Show

Type "jr issue create --project DEMO --type Task --summary 'New feature request' --field 'Environment:badkind=Production' --no-input"
Enter
Sleep 1s
Type "echo EXIT_CODE=$?"
Enter
Sleep 1s
Type "jr issue create --project DEMO --type Task --summary 'New feature request' --field 'Environment:id=20001' --no-input"
Enter
Sleep 1s
Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
