#!/usr/bin/env bash
# Shared hidden setup for the FIX-P5-001 (SEC-001-RENDER-TABLE-ANSI-SANITIZE,
# BC-7.1.006) VHS demos -- `output::render_table` table-mode ANSI/control
# sequence sanitization.
#
# Scrubs every ambient JR_*-prefixed env var first (so a developer/CI
# shell's stray JR_PROFILE/JR_CACHE_DIR/etc. can never leak into a
# recording), then builds a fresh, isolated fake profile + cache dir per
# invocation -- no real ~/.config/jr, ~/.cache/jr, or keychain entry is
# ever touched, and no real Jira instance is ever contacted (JR_BASE_URL
# always points at the local mock server -- see mock_server.py).
#
# Modeled verbatim on the S-cycle14-field-options-name-label precedent's
# setup.sh.
#
# Args:
#   $1 = JR_CACHE_DIR to use (a fresh throwaway dir; caller picks a unique
#        path per recording so concurrent/sequential runs never share state)
#   $2 = optional: path to the mock server's request-log file. If given, it
#        is truncated to empty here.
#   $3 = optional: "before" to prepend the BEFORE (pre-fix, develop-tip
#        2ee422e0) binary's target/debug onto PATH instead of this
#        worktree's own AFTER binary. Any other value (or omitted) uses the
#        AFTER binary, which is jr's normal demo-recording default.
#
# Always sets JR_BASE_URL=http://127.0.0.1:8793 -- pair with
# mock_server.py running on that port before sourcing this.

for _v in $(env | sed -n 's/^\(JR_[A-Za-z0-9_]*\)=.*/\1/p'); do
  unset "$_v"
done

JR_DEMO_TMP="$(mktemp -d)"
export JR_CONFIG_DIR="$JR_DEMO_TMP/config"
export JR_CACHE_DIR="$1"
mkdir -p "$JR_CONFIG_DIR" "$JR_CACHE_DIR"
cp "docs/demo-evidence/FIX-P5-001/fixtures/config.toml" "$JR_CONFIG_DIR/config.toml"

export JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'
export JR_BASE_URL='http://127.0.0.1:8793'

if [ "$3" = "before" ]; then
  export PATH="/private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/f6ec5b34-521e-434c-a4df-6b2d915fe360/scratchpad/before-develop/target/debug:$PATH"
else
  export PATH="$PWD/target/debug:$PATH"
fi

if [ -n "$2" ]; then
  : > "$2"
fi
