# Research: Issue #590 / #582 — `jr api -X DELETE` Rejected (HTTP Method Case-Sensitivity)

**Date:** 2026-07-08
**Bundle:** SOH-BUGS-1
**Issues:** #590 (bug form), #582 (feature form — "uppercase `-X` support")
**Status:** VALIDATED, reproduced offline byte-for-byte

## Summary

`jr api -X DELETE /path` fails with a clap parse error before any I/O occurs.
Uppercase HTTP method strings (DELETE, GET, POST, PUT, PATCH) are rejected by
clap's `ValueEnum` matching, which is case-sensitive by default. This deviates from
the established conventions of both `curl -X` and `gh api -X`.

## Root Cause (Code Investigation)

**Location:** `src/cli/api.rs::HttpMethod` (ValueEnum definition) +
`src/cli/mod.rs` (the `-X / --method` `#[arg]` annotation for `jr api`).

clap 4.x `ValueEnum` matching is **case-sensitive kebab-case** by default. The
`HttpMethod` variants are `Get`, `Post`, `Put`, `Patch`, `Delete`; their derived
kebab-case possible-values are `get`, `post`, `put`, `patch`, `delete`. An uppercase
input like `DELETE` does not match any of these.

**Offline reproduction (byte-for-byte):**

```
$ jr api -X DELETE /x
error: invalid value 'DELETE' for '--method <METHOD>'
  [possible values: get, post, put, patch, delete]
```

Lowercase parses correctly and reaches the network layer, confirmed via
`JR_BASE_URL=http://127.0.0.1:1` producing a connection error (not a parse error).

## Fix

**Single-site change:** add `ignore_case = true` to the `-X / --method` `#[arg]`
in `src/cli/mod.rs`.

```rust
#[arg(
    short = 'X',
    long = "method",
    value_enum,
    ignore_case = true,           // ← add this
    default_value = "get",
)]
method: HttpMethod,
```

This preserves the lowercase possible-values in `--help` output (clap renders
the variants, not the user input) and matches the established `curl`/`gh api`
convention where `-X DELETE`, `-X delete`, and `-X Delete` are all accepted.

**Side note — scope check:** Other `value_enum` args in `src/cli/mod.rs` and
sibling files should be inspected to confirm none carry a similar case-sensitivity
issue for externally-conventional values (e.g. HTTP verbs, status names, output
format keywords). Scope limited to `--method` for this fix; a CI guard is
out-of-scope for this bundle.

**Issue relationship:** #590 is the bug report and #582 is the feature-form request
("support uppercase -X flag"). They describe the same root cause. Both close with
this fix. CHANGELOG entry required (both issue numbers referenced).

## Test Coverage

Add a parse test confirming:
- `-X DELETE` → `HttpMethod::Delete` (bug form)
- `-X delete` → `HttpMethod::Delete` (existing happy path, regression guard)
- `-X Delete` → `HttpMethod::Delete` (mixed-case, convention check)

Test location: inline unit test in `src/cli/api.rs` or integration surface test in
`tests/`. CLI surface guard in `tests/e2e_cli_surface_guard.rs` is not affected
(it checks subcommand/flag existence, not value parsing).

## Verdict

VALIDATED. Reproduced offline byte-for-byte. Fix is a single `ignore_case = true`
attribute addition. No API surface change. Issues #590 and #582 both close with
this fix.
