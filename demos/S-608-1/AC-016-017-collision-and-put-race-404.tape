Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-016-017-collision-and-put-race-404.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/AC-016-017-collision-and-put-race-404.webm"

Require jr

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 14
Set Width 1200
Set Height 700
Set Theme "Dracula"
Set Padding 20

Hide
Type "export PATH=/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-608-1/target/debug:$PATH"
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

# AC-016: NEW collides with an existing component name -- the dummy mock
# server's PUT for this specific component returns a 400 name-collision
# body, surfaced verbatim (ApiError(400,...), exit 1) -- no client-side
# pre-flight existence-check GET is fired before the PUT.
Type "jr --no-input component rename Frontend Anything --project DEMOA"
Enter
Sleep 2s

Hide
Type "clear"
Enter
Show

# AC-017: the resolver's GET succeeds (component is found in the project's
# component list), but the follow-up PUT races to a 404 on the dummy mock
# server (simulating a concurrent delete) -> ApiError(404), exit 1 --
# DISTINCT from AC-004's exit-64 not-found path (resolver-time vs
# mutation-time 404 have different exit codes and error shapes).
Type "jr --no-input component rename RaceComp Renamed --project DEMOA"
Enter
Sleep 2s
