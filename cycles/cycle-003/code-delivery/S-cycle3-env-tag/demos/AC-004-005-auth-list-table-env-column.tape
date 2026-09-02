Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-004-005-auth-list-table-env-column.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-004-005-auth-list-table-env-column.webm"

Require bash

Set FontFamily "Menlo"
Set FontSize 16
Set Width 1200
Set Height 480
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 24
Set TypingSpeed 40ms
Set Shell "bash"

# S-cycle3-env-tag AC-004 (BC-1.6.046 postcondition — Behavior): `jr auth
# list` (table mode) prints headers NAME, URL, ENV, AUTH, STATUS in that
# order — ENV is a new 5th column between URL and AUTH.
#
# S-cycle3-env-tag AC-005 (BC-1.6.046 EC-1.6.046-1): the ENV cell renders
# a blank cell (zero visible chars) for env = Some(""), and "-" for a
# profile with no `env` key at all (None). These two ACs both surface in
# the single table this command prints, so one recording covers both:
# "staging" (env = "") renders blank, "legacy" (no env key) renders "-",
# "prod" (env = "prod") renders the tagged value.
#
# ADAPTED DEMO — NOT LIVE JIRA. All profile URLs are fake
# (acme-corp*.atlassian.net) served from a throwaway local config.toml
# under a temp JR_CONFIG_DIR — no real Jira instance, org, or credentials
# involved. `auth list` reads local config only; no network call is made.
#
# Error path for the ENV field's tolerant-reader contract (AC-001, schema
# level): a config.toml with `env` set to a non-string TOML type fails
# deserialization loudly instead of silently coercing or panicking.

Hide
Type "cd $(git rev-parse --show-toplevel)"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-envtag/fixture-normal JR_CACHE_DIR=/tmp/jr-demo-envtag/cache JR_SERVICE_NAME=jr-demo-envtag"
Enter
Type 'export PATH="$(pwd)/target/debug:$PATH"'
Enter
Type "clear"
Enter
Sleep 300ms
Show

# Success path: 5-column table, ENV between URL and AUTH
# NOTE: fixed Sleep, not Wait+Line — `auth list` is a synchronous local
# config read (no network, no spinner); Wait+Line's last-terminal-line
# match proved unreliable against comfy-table's box-drawing output during
# tape verification, so a generous fixed Sleep is used instead.
Type "jr auth list"
Enter
Sleep 1500ms

Hide
Type "clear"
Enter
Type "export JR_CONFIG_DIR=/tmp/jr-demo-envtag/fixture-badtype"
Enter
Show

# Error path: malformed env value (wrong TOML type) fails loudly
Type "jr auth list"
Enter
Sleep 1500ms

# === Hold final frame ===
Sleep 2s
