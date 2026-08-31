# S-578-4 — AC-003 + AC-004: BC-3.8.013's --on-behalf-of pre-flight guard is
# UNCHANGED in mechanism (Architecture Compliance Rule 5) — only its trigger
# scope widens now that the old combined --field+--on-behalf-of check (DEC-188)
# is gone. Two invocations, same guard, same error string in both:
#   1. --on-behalf-of alone (AC-004, wire-for-wire regression pin, VP-578-019)
#   2. --field + --on-behalf-of together (AC-003, VP-578-018) -- the standalone
#      guard now fires even with --field present, since the combined check that
#      used to pre-empt it no longer exists. --field never contributes to this
#      error on the platform path.
# Both guards fire pre-HTTP (step 2, before step 2a's field-hint parse and
# step 2b's D2 guard) -- no backend is contacted; JR_BASE_URL still points at
# the local mock (see AC-002's success tape) purely so a real, dialable target
# exists, underscoring that these are genuinely uncalled endpoints, not an
# artifact of missing config.
Output AC-003-004-on-behalf-of-guards.gif
Output AC-003-004-on-behalf-of-guards.webm

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
Type "python3 docs/demo-evidence/S-578-4/mock/mock_jira.py 18575 >/tmp/mock-578-4-003.log 2>&1 &"
Enter
Sleep 500ms
Type "until curl -s -o /dev/null http://127.0.0.1:18575/rest/api/3/field; do sleep 0.2; done"
Enter
Sleep 1s
Type "export JR_BASE_URL=http://127.0.0.1:18575 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'"
Enter
Sleep 500ms
Type "clear"
Enter
Sleep 500ms
Show

Type "jr issue create --project DEMO --type Task --summary 'New feature request' --on-behalf-of 712020:abc123 --no-input"
Enter
Sleep 1s
Type "echo EXIT_CODE=$?"
Enter
Sleep 1s
Type "jr issue create --project DEMO --type Task --summary 'New feature request' --field customfield_10050=X --on-behalf-of 712020:abc123 --no-input"
Enter
Sleep 1s
Type "echo EXIT_CODE=$?"
Enter
Sleep 2s
