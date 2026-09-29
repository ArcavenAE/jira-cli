#!/usr/bin/env bash
# Shared hidden setup for the S-cycle14-user-list-project-resolution
# (`jr user list --project` resolution order, issue #862) VHS demos.
#
# Scrubs every ambient JR_*-prefixed env var first (so a developer/CI shell's
# stray JR_PROFILE/JR_CACHE_DIR/etc. can never leak into a recording), then
# builds a fresh, isolated fake profile + cache dir + cwd per invocation --
# no real ~/.config/jr, ~/.cache/jr, or keychain entry is ever touched, and
# no real Jira instance is ever contacted (JR_BASE_URL always points at the
# local mock server started separately -- see mock_user_search_server.py).
#
# Args:
#   $1 = JR_CACHE_DIR to use (a fresh throwaway dir; caller picks a unique
#        path per recording so concurrent/sequential runs never share state)
#   $2 = config fixture filename under fixtures/ (copied to JR_CONFIG_DIR's
#        config.toml)
#   $3 = optional: contents for a `project = "<value>"` line written into a
#        fresh cwd's .jr.toml (the AC-003 ".jr.toml default" cell). Omit or
#        pass "" for a cwd with no .jr.toml at all.
#
# Always sets JR_BASE_URL=http://127.0.0.1:8791 -- pair with
# mock_user_search_server.py running on that port before sourcing this.

for _v in $(env | sed -n 's/^\(JR_[A-Za-z0-9_]*\)=.*/\1/p'); do
  unset "$_v"
done

JR_DEMO_TMP="$(mktemp -d)"
export JR_CONFIG_DIR="$JR_DEMO_TMP/config"
export JR_CACHE_DIR="$1"
mkdir -p "$JR_CONFIG_DIR" "$JR_CACHE_DIR"
cp "docs/demo-evidence/S-cycle14-user-list-project-resolution/fixtures/$2" "$JR_CONFIG_DIR/config.toml"

export JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'
export JR_BASE_URL='http://127.0.0.1:8791'
export PATH="$PWD/target/debug:$PATH"

CWD_DIR="$JR_DEMO_TMP/cwd"
mkdir -p "$CWD_DIR"
if [ -n "$3" ]; then
  printf 'project = "%s"\n' "$3" > "$CWD_DIR/.jr.toml"
fi
cd "$CWD_DIR" || exit 1
