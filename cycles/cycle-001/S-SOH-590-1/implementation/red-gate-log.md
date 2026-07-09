# Red Gate Log — S-SOH-590-1

**Date:** 2026-07-09
**Story:** S-SOH-590-1 (story #104) — case-insensitive HTTP method on `jr api -X`
**Route:** quick-dev (TRIVIAL)
**Branch:** `fix/S-SOH-590-1-api-method-case` (deleted post-merge)
**Base:** develop @ 159e1be (v0.6.0-dev.8)
**F4 dispatch authorized by:** human, 2026-07-09 (DEC-165, quick-dev route)

## Summary

Red Gate verified 2026-07-09 by orchestrator.

- **Test commit cec775e (Red Gate state):** `test_parse_api_method_uppercase_delete_dispatches_http_delete` FAILED — clap invalid value `'DELETE'`, exit 2, no HTTP dispatch. `test_parse_api_method_mixed_case_dispatches_http_delete` FAILED — clap exit 2, tip similar value `'delete'`. `test_parse_api_method_lowercase_delete_dispatches_http_delete` PASSED — pre-existing path (clap enum `delete` already accepted, HTTP DELETE dispatched correctly).
- **Green Gate at cb3b471:** all 3 tests PASS.
- **Full suite at Green Gate:** 2010 passed / 0 failed / 93 ignored.

## Red Gate State (cec775e — BEFORE implementation)

| Test | State | Failure Mode | AC |
|------|-------|-------------|-----|
| `test_parse_api_method_uppercase_delete_dispatches_http_delete` | FAIL | clap exits 2: invalid value `'DELETE'` for `--method <METHOD>`. No HTTP dispatch reached. | AC-001 (uppercase) |
| `test_parse_api_method_mixed_case_dispatches_http_delete` | FAIL | clap exits 2: invalid value `'dElEtE'` for `--method <METHOD>`. Tip: similar value `'delete'`. No HTTP dispatch reached. | AC-002 (mixedcase) |
| `test_parse_api_method_lowercase_delete_dispatches_http_delete` | PASS | Pre-existing path: clap enum `delete` (lowercase) already accepted; HTTP DELETE dispatched correctly. Inverted regression-pin passes vacuously. | AC-003 (regression) |

### Failure Analysis — AC-001 (uppercase)

`src/cli/mod.rs` defines the `-X`/`--method` arg as a `clap::ValueEnum` (`HttpMethod`). Without `ignore_case = true` on the `#[arg]`, clap performs case-sensitive value matching. `DELETE` (uppercase) does not match the enum variant `delete`, so clap exits 2 with "invalid value" before any HTTP dispatch. Correct Red state — `ignore_case = true` attribute was absent.

### Failure Analysis — AC-002 (mixedcase)

Same root cause: `dElEtE` (mixed case) does not match `delete`. Clap exit 2 with the "tip: similar value 'delete'" message, which is characteristic of near-match heuristics without case-folding. Correct Red state.

### Passing Test Analysis — AC-003 (regression pin)

`delete` (lowercase) was already accepted by the pre-existing clap enum. This test pins that the fix does not break the existing lowercase path. Passes vacuously at Red Gate time.

## Green Gate State (cb3b471 — AFTER implementation)

Fix: added `ignore_case = true` to the `#[arg(short = 'X', long = "method", ...)]` attribute on the `method` field in `src/cli/mod.rs`. Single-attribute, single-site change (~1 LOC).

| Test | State | Notes |
|------|-------|-------|
| `test_parse_api_method_uppercase_delete_dispatches_http_delete` | PASS | `DELETE` now accepted; HTTP DELETE dispatched; wiremock 200 returned. |
| `test_parse_api_method_mixed_case_dispatches_http_delete` | PASS | `dElEtE` now accepted; HTTP DELETE dispatched. |
| `test_parse_api_method_lowercase_delete_dispatches_http_delete` | PASS | Regression-pin holds; lowercase path unaffected. |

Full suite: 2010 passed / 0 failed / 93 ignored. Zero regressions.

## TDD Discipline

- Tests committed in Red Gate commit cec775e before implementation commit cb3b471.
- Fix is minimal: single `ignore_case = true` attribute. No scope creep.
- Quick-dev route (TRIVIAL): no stub-architect phase; test-writer wrote tests directly against the public CLI surface via `assert_cmd`.

## Notes

- CHANGELOG.md entry added per AC requirements (closes #590, closes #582).
- BC-X.1.011 (micro-BC) authored by product-owner post-merge (spec v1.3.27); BC-INDEX.md update deferred due to TD-031 validate-stable-anchors hook lockout (243 pre-existing volatile line-cites; see drift item BC-INDEX-TD031-EDIT-LOCKOUT).
- Issues #590 and #582 close on release per CHANGELOG milestone.
