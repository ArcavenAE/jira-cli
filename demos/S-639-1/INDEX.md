# S-639-1 Demo Evidence

Story: BREAKING — `jr issue create` `--field`/`--on-behalf-of` on the platform path
without `--request-type` now pre-flight exit 64 instead of warn-and-proceed
(DEC-188, BC-3.8.012/013 [AMENDED]).

Branch: `feat/issue-create-preflight-guards`
Head: `4bfa0c21`
Captured: 2026-08-12

This is a CLI error-behavior story. Coverage below is intentionally focused on the
guard's decision logic — not all 21 ACs — using VHS terminal recordings plus a
plain-text transcript as a precise, greppable backup of the same four scenarios.

## Recording method

All commands run against fake/isolated config — no real Jira instance, org ID, or
credentials are involved:

- `JR_CONFIG_DIR` / `JR_CACHE_DIR` → scratch dirs (`/tmp/jr-demo-config`, `/tmp/jr-demo-cache`)
- `JR_BASE_URL=http://127.0.0.1:1/fake` → unroutable dummy instance URL
- `JR_AUTH_HEADER=Basic ZmFrZTpmYWtl` → dummy fake credential (base64 of `fake:fake`)

All four are documented `#[cfg(debug_assertions)]`-gated test seams (CLAUDE.md "AI
Agent Notes") — inert in release builds. The pre-flight guard fires **before any HTTP
call**, so the three exit-64 scenarios below never reach the network at all; the
positive-control scenario (AC-004) does reach the (fake, unreachable) network, which
is itself the evidence that it got past the guard.

## Evidence

| AC | BC Anchor | Video | Tape Source | Command | Exit Code | Result |
|----|-----------|-------|--------------|---------|-----------|--------|
| AC-001 | BC-3.8.012 | `AC-001-field-without-request-type.gif` / `.webm` | `AC-001-field-without-request-type.tape` | `jr issue create … --field customfield_10200=x --no-input` (no `--request-type`) | **64** | Pre-flight `UserError`: "--field is only valid with --request-type …" |
| AC-002 | BC-3.8.013 | `AC-002-on-behalf-of-without-request-type.gif` / `.webm` | `AC-002-on-behalf-of-without-request-type.tape` | `jr issue create … --on-behalf-of someone@example.com --no-input` (no `--request-type`) | **64** | Pre-flight `UserError`: "--on-behalf-of is only valid with --request-type …" |
| AC-003 | BC-3.8.012 + BC-3.8.013 combined | `AC-003-combined-flags.gif` / `.webm` | `AC-003-combined-flags.tape` | Both `--field` and `--on-behalf-of` together, no `--request-type` | **64** | ONE combined `UserError` (not two separate errors): "--field and --on-behalf-of are only valid with --request-type …" |
| AC-004 (positive control) | Guard scope (ADR-0014 JSM dispatch fork) | `AC-004-field-with-request-type-positive-control.gif` / `.webm` | `AC-004-field-with-request-type-positive-control.tape` | Same `--field` flag, **with** `--request-type "IT Help"` | **1** (not 64) | Guard does NOT fire — routes to the JSM dispatch fork and fails on network unreachability instead (`Could not reach 127.0.0.1 — check your connection`), proving the guard is scoped to the platform path only |

## Plain-text backup transcript

`demo-transcript.md` — the same four commands run directly against the debug binary
(`./target/debug/jr`), with verbatim stderr and the real `$?` captured immediately
after each invocation. Provided as a precise, greppable companion to the videos
above (exact string matching for BC-3.8.012/013 wording, exact exit codes).

## What is deliberately NOT covered here

Per the recording brief, this evidence set is scoped to the pre-flight guard's core
decision logic (the four scenarios above) and does not attempt to demonstrate the
other 17+ ACs in the story (e.g. `--output json` error envelope shape, malformed/empty
`--field` values, repeated `--field` occurrences, interactive-mode behavior) — those
are covered by the story's automated test suite, not by this demo evidence.

## Regeneration

The `.tape` files use `Output` paths relative to `.factory/demos/S-639-1/…`, which
resolve correctly only when `vhs` is invoked from the directory that has `.factory/`
as an immediate child — i.e. the **top-level repo root** (`/Users/zious/Documents/GITHUB/jira-cli`,
where `.factory/` is its own worktree on the `factory-artifacts` branch), not from
inside `.worktrees/S-639-1/`. The tapes themselves `cd` into the story worktree and
build/run the binary from there via a hidden setup block.

To regenerate against a different head:

```bash
cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-639-1   # build first
cargo build
cd /Users/zious/Documents/GITHUB/jira-cli                       # then run vhs from repo root
for t in .factory/demos/S-639-1/*.tape; do
  vhs "$t"
done
```
