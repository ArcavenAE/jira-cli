Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-008-auth-status-env-line.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-008-auth-status-env-line.webm"

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

# S-cycle3-env-tag AC-008 (BC-1.6.047 postcondition 2b / EC-1.6.047-3):
# `jr auth status` prints an "Env:" line in its human-text output, using
# the identical control-char/ANSI-strip + length-cap transform AC-006
# exercises for the table, with the same "-"/blank convention as AC-005.
# Shown here against the "prod" profile (env = "prod").
#
# ADAPTED DEMO — NOT LIVE JIRA. Fake acme-corp.atlassian.net profile URL
# in a throwaway local config.toml under a temp JR_CONFIG_DIR + isolated
# JR_SERVICE_NAME (keeps this demo from touching any real OS keychain
# entry). No network call is made — `auth status` only probes local
# config + keychain presence.
#
# Error path: `jr auth status --profile <unknown>` exits 64 with an
# "unknown profile" error before any Env: line is printed — this is the
# pre-existing strict-profile-lookup guard `status()` already enforces
# (matches switch/remove/logout), exercised here against the same fixture.

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

# NOTE: fixed Sleep, not Wait+Line — synchronous local read (config +
# keychain-presence probe only, no network); Wait+Line's last-terminal-
# line match proved unreliable during tape verification, so a generous
# fixed Sleep is used instead.

# Success path: Env: line appears between Instance: and Auth method:
Type "jr auth status --profile prod"
Enter
Sleep 1500ms

Hide
Type "clear"
Enter
Show

# Error path: unknown profile — exits 64 before any Env: line prints
Type "jr auth status --profile nope"
Enter
Sleep 1500ms

# === Hold final frame ===
Sleep 2s
