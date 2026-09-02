Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-006-auth-list-table-hostile-env-sanitized.gif"
Output "/Users/zious/Documents/GITHUB/jira-cli/.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-006-auth-list-table-hostile-env-sanitized.webm"

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

# S-cycle3-env-tag AC-006 (BC-1.6.046 EC-1.6.046-2): a profile whose `env`
# value contains an ANSI CSI escape sequence (\x1b[31m ... \x1b[0m) and raw
# CR/LF control bytes renders a stripped ENV cell in the table — no raw
# control bytes reach the terminal, and the CSI sequence's bracket/param
# bytes do not survive as literal text either. A second profile whose
# `env` value is 55 chars (over the 40-char display cap) renders truncated
# with a "…" marker.
#
# ADAPTED DEMO — NOT LIVE JIRA. Fake acme-corp*.atlassian.net profile URLs
# in a throwaway local config.toml under a temp JR_CONFIG_DIR. `auth list`
# reads local config only; no network call is made. The hostile `env`
# string is crafted test input, not attacker-supplied live data.
#
# Success path only — this AC has no error path of its own (BC-6.1.015
# Invariant: no validator/allowlist on `env`; any string, including one
# with control chars, is accepted and stored verbatim — this recording
# demonstrates the DISPLAY-layer sanitization, not a rejection).

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

# NOTE: fixed Sleep, not Wait+Line — these are synchronous local reads (no
# network, no spinner); Wait+Line's last-terminal-line match proved
# unreliable during tape verification (the shell returns to an empty
# prompt on the line after the command's real output, so a pattern
# matching the output text itself never lands on the "last line"), so a
# generous fixed Sleep is used instead.

# cat -v reveals the raw config: real ESC/CR bytes are on disk
Type "cat -v /tmp/jr-demo-envtag/fixture-hostile/config.toml"
Enter
Sleep 1200ms

Type "clear"
Enter
Sleep 300ms

# The table strips the ANSI/control bytes and caps the long value
Type "jr auth list"
Enter
Sleep 1500ms

# === Hold final frame ===
Sleep 2s
