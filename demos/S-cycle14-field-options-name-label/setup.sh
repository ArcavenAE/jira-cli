#!/usr/bin/env bash
# Shared hidden setup for the S-cycle14-field-options-name-label
# (`jr field options` system-field label fallback, issue #861) VHS demos.
#
# Scrubs every ambient JR_*-prefixed env var first (so a developer/CI
# shell's stray JR_PROFILE/JR_CACHE_DIR/etc. can never leak into a
# recording), then builds a fresh, isolated fake profile + cache dir per
# invocation — no real ~/.config/jr, ~/.cache/jr, or keychain entry is
# ever touched, and no real Jira instance is ever contacted (JR_BASE_URL
# always points at the local mock server — see mock_field_options_server.py).
#
# cwd is left at the repo root (this story has no cwd-resolution concern),
# matching the S-cycle14-api-query-param precedent.
#
# Args:
#   $1 = JR_CACHE_DIR to use (a fresh throwaway dir; caller picks a unique
#        path per recording so concurrent/sequential runs never share state)
#   $2 = optional: path to the mock server's request-log file. If given, it
#        is truncated to empty here so an error/pre-flight-guard recording's
#        "the mock log stayed empty/unchanged" check reflects only THIS
#        recording's traffic.
#
# Always sets JR_BASE_URL=http://127.0.0.1:8793 -- pair with
# mock_field_options_server.py running on that port before sourcing this.

for _v in $(env | sed -n 's/^\(JR_[A-Za-z0-9_]*\)=.*/\1/p'); do
  unset "$_v"
done

JR_DEMO_TMP="$(mktemp -d)"
export JR_CONFIG_DIR="$JR_DEMO_TMP/config"
export JR_CACHE_DIR="$1"
mkdir -p "$JR_CONFIG_DIR" "$JR_CACHE_DIR"
cp "docs/demo-evidence/S-cycle14-field-options-name-label/fixtures/config.toml" "$JR_CONFIG_DIR/config.toml"

export JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'
export JR_BASE_URL='http://127.0.0.1:8793'
export PATH="$PWD/target/debug:$PATH"

if [ -n "$2" ]; then
  : > "$2"
fi
