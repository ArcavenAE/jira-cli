# S-639-1 Demo Transcript

Story: BREAKING — `jr issue create` `--field`/`--on-behalf-of` on the platform path
without `--request-type` now pre-flight exit 64 instead of warn-and-proceed.

Branch: `feat/issue-create-preflight-guards`
Head: `4bfa0c21`
Captured: 2026-08-12

All commands below use fake/isolated env vars (`JR_CONFIG_DIR`, `JR_CACHE_DIR`,
`JR_BASE_URL=http://127.0.0.1:1/fake`, `JR_AUTH_HEADER`) — debug-build-only test
seams documented in CLAUDE.md. No real Jira instance, org, or credentials are
involved. The BC-3.8.012/013 guard fires PRE-FLIGHT, before any HTTP call, so
exit-64 scenarios below never touch the network at all.

## AC-001 / BC-3.8.012 — `--field` without `--request-type`
```
$ jr issue create --project FOO --type Task --summary demo --field customfield_10200=x --no-input
Error: --field is only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to submit a JSM request with custom fields, or drop --field to create a standard platform issue.
$ echo $?
64
```

## AC-002 / BC-3.8.013 — `--on-behalf-of` without `--request-type`
```
$ jr issue create --project FOO --type Task --summary demo --on-behalf-of someone@example.com --no-input
Error: --on-behalf-of is only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to raise a request on behalf of another user, or drop --on-behalf-of to create a standard platform issue.
$ echo $?
64
```

## AC-003 — Both flags together (combined message, exactly ONE error)
```
$ jr issue create --project FOO --type Task --summary demo --field customfield_10200=x --on-behalf-of someone@example.com --no-input
Error: --field and --on-behalf-of are only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to use these flags, or drop them to create a standard platform issue.
$ echo $?
64
```

## AC-004 — Positive control: `--field` WITH `--request-type` (guard correctly scoped)
Same `--field` flag, but with `--request-type` present — this routes to the JSM
dispatch fork (ADR-0014) instead of the platform pre-flight guard. It fails for a
DIFFERENT reason (network unreachable — fake base URL) with a DIFFERENT exit code
(1, not 64), proving the guard does not fire on this path.
```
$ jr issue create --project FOO --type Task --summary demo --field customfield_10200=x --request-type "IT Help" --no-input
Error: Could not reach 127.0.0.1 — check your connection
$ echo $?
1
```
