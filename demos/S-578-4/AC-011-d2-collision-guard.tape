# S-578-4 — AC-011: create-path D2 ten-member collision guard. A dedicated
# flag (--summary) and a --field targeting the SAME wire key ("summary") is
# rejected exit 64, zero HTTP, BEFORE project/type resolution.
#
# This guard fires before any HTTP call, so a real backend isn't required for
# correctness — but the demo still points JR_BASE_URL at a live local mock
# server (started, never actually contacted) plus --verbose, precisely to make
# the ZERO-HTTP claim independently checkable on screen: the [verbose] GET/POST
# lines that appear in the AC-002 success tape are conspicuously ABSENT here.
Output AC-011-d2-collision-guard.gif
Output AC-011-d2-collision-guard.webm

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
Type "python3 docs/demo-evidence/S-578-4/mock/mock_jira.py 18573 >/tmp/mock-578-4-011.log 2>&1 &"
Enter
Sleep 500ms
Type "until curl -s -o /dev/null http://127.0.0.1:18573/rest/api/3/field; do sleep 0.2; done"
Enter
Sleep 1s
Type "export JR_BASE_URL=http://127.0.0.1:18573 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl' RUST_LOG=jr=debug"
Enter
Sleep 500ms
Type "clear"
Enter
Sleep 500ms
Show

Type "jr issue create --project DEMO --type Task --summary 'My Summary' --field summary=Other --no-input --verbose"
Enter
Sleep 1s
Type "echo EXIT_CODE=$?  # no [verbose] GET/POST lines above -- zero HTTP fired"
Enter
Sleep 2s
