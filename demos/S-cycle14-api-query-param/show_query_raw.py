#!/usr/bin/env python3
"""Tiny stdin-JSON filter used by the VHS `.tape` recordings in this
directory to print just the mock echo server's `query_raw` field (the
raw, still-percent-encoded query string jr actually sent on the wire),
optionally prefixed with a label. Kept as its own file — rather than an
inline `python3 -c "..."` one-liner in a `.tape` file's `Type` string —
because VHS's tape-file lexer chokes on nested quotes/brackets inside a
quoted `Type` argument.

Usage: <producer> | python3 show_query_raw.py ["label"]
"""
import json
import sys

label = sys.argv[1] + " " if len(sys.argv) > 1 else ""
data = json.load(sys.stdin)
print(f"{label}{data['query_raw']}")
