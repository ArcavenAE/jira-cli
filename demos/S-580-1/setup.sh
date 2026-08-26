#!/usr/bin/env bash
# Shared setup for the S-580-1 `jr field options` VHS demos. Sets up an
# isolated fake profile (JR_CONFIG_DIR) and cache dir (JR_CACHE_DIR, arg $1)
# so config/auth resolve deterministically without touching a developer's
# real ~/.config/jr or ~/.cache/jr. JR_BASE_URL points `jr` at the local
# mock server (arg $2) for the mocked M1 --issue recordings; the server-free
# arity/empty-name recordings never dial out (Step 1 of `handle()` is a pure
# arity check that returns before any HTTP call), so JR_BASE_URL is
# harmless to set unconditionally.
export JR_CONFIG_DIR=/tmp/jr-demo-cfg-s580-1-vhs
export JR_CACHE_DIR="$1"
mkdir -p "$JR_CONFIG_DIR"
cp docs/demo-evidence/S-580-1/fixtures/config.toml "$JR_CONFIG_DIR/config.toml"
export JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'
if [ -n "$2" ]; then
  export JR_BASE_URL="$2"
fi
export PATH="$PWD/target/debug:$PATH"
