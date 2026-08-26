#!/usr/bin/env bash
# Shared setup for the S-578-1 `issue edit` VHS demos (hinted-field-rejected
# and bare-field-not-rejected). Sets up a fake profile so config/auth
# resolve without a real Jira instance. The interim :kind-hint guard on
# `issue edit` fires BEFORE any HTTP call, so no live/mock server is needed
# for the hinted-field demo; the bare-field demo proceeds past the guard and
# fails on the (fake) network call instead -- expected, and it demonstrates
# the guard was not tripped.
export JR_CONFIG_DIR=/tmp/jr-demo-cfg-vhs
export JR_CACHE_DIR="$1"
mkdir -p "$JR_CONFIG_DIR"
cp docs/demo-evidence/S-578-1/fixtures/config.toml "$JR_CONFIG_DIR/config.toml"
export JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'
export PATH="$PWD/target/debug:$PATH"
