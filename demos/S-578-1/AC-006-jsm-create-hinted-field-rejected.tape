Require jr
Require python3

Output docs/demo-evidence/S-578-1/AC-006-jsm-create-hinted-field-rejected.gif
Output docs/demo-evidence/S-578-1/AC-006-jsm-create-hinted-field-rejected.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 500
Set Padding 20
Set TypingSpeed 40ms

# --- Hidden setup: `jr issue create --request-type` resolves the service
# desk (an HTTP GET) BEFORE the S-578-1 interim guard runs, unlike the edit
# path. A minimal local mock server (GET-only: project meta, service-desk
# list, request-type list) lets that resolution succeed so the guard's exit
# 64 can be demonstrated without a real Jira instance. No mutating endpoint
# is served -- if the guard failed to fire, the POST would 501, not "not yet
# supported".
Hide
Type "python3 docs/demo-evidence/S-578-1/mock_jsm_server.py 18765 & disown"
Enter
Type "sleep 1"
Enter
Type "export JR_BASE_URL=http://127.0.0.1:18765"
Enter
Type "source docs/demo-evidence/S-578-1/setup-edit.sh /tmp/jr-demo-cache-vhs-jsm"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# S-578-1 AC-006/EC-1: a :kind-hinted --field on the JSM `issue create`
# path is rejected by the same interim guard, after service-desk/request-type
# resolution succeeds but before the (never-reached) POST.
Type "jr issue create --project DEMO --request-type 'Get IT Help' --summary Demo --field cf:id=10042 --no-input"
Enter
Sleep 2500ms

Type "echo EXIT_CODE=$?"
Enter
Sleep 2s

Hide
Type "pkill -f mock_jsm_server.py"
Enter
Show
