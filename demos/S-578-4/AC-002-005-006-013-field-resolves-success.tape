# S-578-4 — AC-002 (DEC-188 guard removed, VP-578-017), AC-005 (customfield_NNNNN
# bypass), AC-006 (createmeta source substitution: get_issue_types_for_project +
# get_createmeta_fields, S-580-1/S-331 reused verbatim), AC-013 (create-path echo),
# AC-015 (field resolution runs after project/type, before POST).
#
# `jr issue create --field a=b` used to exit 64 with "--field is only valid with
# --request-type" (DEC-188). This demo shows the reversal: the SAME invocation
# shape now resolves the field via createmeta and creates the issue (exit 0).
# `--verbose` (RUST_LOG scoped to the `jr` crate only, to keep hyper/reqwest DEBUG
# noise out of frame) makes the two createmeta GETs and the create POST visible —
# proof this really talks to a backend, not a stub returning canned text.
#
# Backend: a minimal local mock Jira server (mock/mock_jira.py in this directory)
# serving just the createmeta issuetypes/fields endpoints and the create POST —
# NOT a live Jira instance (see CLAUDE.md: never run state-changing commands
# against live Jira). JR_BASE_URL/JR_AUTH_HEADER are the documented debug-only
# test seams (see CLAUDE.md "AI Agent Notes"); JR_CONFIG_DIR/JR_CACHE_DIR isolate
# this run from any real profile/cache on the recording machine.
#
# NOTE: Sleep is used instead of Wait+Line for hidden setup steps — Wait+Line was
# verified non-functional against the installed vhs 0.11.0 binary (see
# AC-016-help-text-reversal.tape's header note for the reproduction). Each hidden
# setup command is typed as its own Type/Enter pair (not chained with && or &) so
# `cd`/`export` reliably persist in the same interactive shell session.
Output AC-002-005-006-013-field-resolves-success.gif
Output AC-002-005-006-013-field-resolves-success.webm

Require cargo
Require python3

Set Shell "bash"
Set FontSize 15
Set Width 1300
Set Height 550
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
Type "python3 docs/demo-evidence/S-578-4/mock/mock_jira.py 18571 >/tmp/mock-578-4-002.log 2>&1 &"
Enter
Sleep 500ms
Type "until curl -s -o /dev/null http://127.0.0.1:18571/rest/api/3/field; do sleep 0.2; done"
Enter
Sleep 1s
Type "export JR_BASE_URL=http://127.0.0.1:18571 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl' RUST_LOG=jr=debug"
Enter
Sleep 500ms
Type "clear"
Enter
Sleep 500ms
Show

Type "jr issue create --project DEMO --type Task --summary 'New feature request' --field customfield_10050=VENDOR-REF-99 --no-input --verbose"
Enter
Sleep 3s
