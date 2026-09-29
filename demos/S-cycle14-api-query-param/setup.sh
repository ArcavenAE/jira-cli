#!/usr/bin/env bash
# Shared hidden setup for the S-cycle14-api-query-param (`jr api
# --query-param`/`-q NAME=VALUE`, issue #583) VHS demos.
#
# Scrubs every ambient JR_*-prefixed env var first (so a developer/CI
# shell's stray JR_PROFILE/JR_CACHE_DIR/etc. can never leak into a
# recording), then builds a fresh, isolated fake profile + cache dir per
# invocation — no real ~/.config/jr, ~/.cache/jr, or keychain entry is
# ever touched, and no real Jira instance is ever contacted (JR_BASE_URL
# always points at the local mock server — see mock_query_echo_server.py).
#
# Unlike the sibling S-cycle14-user-list-project-resolution demos, this
# story has no `.jr.toml`/cwd-resolution concern (it is about query-string
# assembly, not project-default resolution), so the cwd is deliberately
# left at the repo root — every recorded `Type` command below references
# helper scripts by their repo-relative `docs/demo-evidence/...` path, and
# those paths must keep resolving after `source`-ing this file.
#
# Args:
#   $1 = JR_CACHE_DIR to use (a fresh throwaway dir; caller picks a unique
#        path per recording so concurrent/sequential runs never share state)
#   $2 = optional: path to the mock server's request-log file. If given, it
#        is truncated to empty here so an error-path recording's "the mock
#        log stayed empty" check reflects only THIS recording's traffic.
#
# Always sets JR_BASE_URL=http://127.0.0.1:8792 -- pair with
# mock_query_echo_server.py running on that port before sourcing this.

for _v in $(env | sed -n 's/^\(JR_[A-Za-z0-9_]*\)=.*/\1/p'); do
  unset "$_v"
done

JR_DEMO_TMP="$(mktemp -d)"
export JR_CONFIG_DIR="$JR_DEMO_TMP/config"
export JR_CACHE_DIR="$1"
mkdir -p "$JR_CONFIG_DIR" "$JR_CACHE_DIR"
cp "docs/demo-evidence/S-cycle14-api-query-param/fixtures/config.toml" "$JR_CONFIG_DIR/config.toml"

export JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'
export JR_BASE_URL='http://127.0.0.1:8792'
export PATH="$PWD/target/debug:$PATH"

if [ -n "$2" ]; then
  : > "$2"
fi
