Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-007-auth-list-json-env-verbatim.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-007-auth-list-json-env-verbatim.webm"

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 520
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 40ms
Set Shell "bash"

# S-cycle3-env-tag AC-007 (BC-1.6.047 postcondition 1): every profile
# object in `jr auth list --output json` carries an "env" key that is
# NEVER omitted — the raw configured string (control chars/ANSI escapes
# unmodified) when set, or null when unset. This is the JSON-channel
# counterpart to AC-006's table demo: the SAME hostile fixture is used
# here to show the deliberate asymmetry (CLAUDE.md issue #398 convention)
# — JSON stays byte-for-byte verbatim/lossless where the table sanitizes.
#
# ADAPTED DEMO — NOT LIVE JIRA. Fake acme-corp*.atlassian.net profile URLs
# in a throwaway local config.toml under a temp JR_CONFIG_DIR. No network
# call is made; `--output json` routes through output::render_json per
# CLAUDE.md #526.
#
# Error path: the same malformed-env-type config from the AC-004/005 demo
# also fails under --output json (deserialization happens before any
# render-mode branch, so both modes share the same error path).

Hide
Type "cd $(git rev-parse --show-toplevel)"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-envtag/fixture-hostile JR_CACHE_DIR=/tmp/jr-demo-envtag/cache JR_SERVICE_NAME=jr-demo-envtag"
Enter
Type 'export PATH="$(pwd)/target/debug:$PATH"'
Enter
Type "clear"
Enter
Sleep 300ms
Show

# NOTE: fixed Sleep, not Wait+Line — synchronous local read, no network;
# Wait+Line's last-terminal-line match proved unreliable during tape
# verification, so a generous fixed Sleep is used instead.

# Success path: raw ESC escapes and CR/LF bytes survive verbatim in JSON
Type "jr --output json auth list"
Enter
Sleep 1500ms

Hide
Type "clear"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-envtag/fixture-badtype"
Enter
Show

# Error path: malformed env type fails the same way under --output json
Type "jr --output json auth list"
Enter
Sleep 1500ms

# === Hold final frame ===
Sleep 2s
