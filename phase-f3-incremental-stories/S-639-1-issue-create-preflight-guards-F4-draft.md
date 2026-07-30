> **F4 DRAFT — NOT THE DELIVERED ARTIFACT.**
> This is a pre-authored draft of `docs/specs/issue-create-preflight-guards.md`,
> which is deliverable (f) of story S-639-1. It was created during F3 in the main
> worktree by mistake and relocated here to preserve the work.
>
> At F4, recreate this file at `docs/specs/issue-create-preflight-guards.md` inside
> the S-639-1 worktree so it lands via pull request. **Verify the content against the
> then-current spec before use** — it was drafted at spec v1.3.167 and may have
> drifted. Do not copy it forward unchecked.

# Feature Spec: `jr issue create` Pre-flight Guards for `--field` and `--on-behalf-of`

**Status:** Ready for implementation (F4)
**Issue:** #639
**Epic:** SOH-DX-1 (DEC-188)
**Semver impact:** BREAKING — 0.6.0-dev.11 → 0.6.0-dev.12 (version-retarget ruling 2026-07-29; no train bump; see spec-changelog.md [1.3.169])
**BC references:** BC-3.8.012, BC-3.8.013
**Story:** `.factory/stories/S-639-1.md`

---

## Problem

`jr issue create --field KEY=VALUE` and `jr issue create --on-behalf-of USER` silently warn to
stderr and proceed on the platform path (no `--request-type`). This makes the flags appear to do
something useful when they do not. The current behavior is classified as a behavioral defect per
DEC-188: warn-and-proceed is strictly worse than a clear exit-64 error.

## Behavior Change (BREAKING)

**Before (v0.6.x, warn-and-proceed):**
```
$ jr issue create --project PROJ --summary "Task" --field foo=bar
warning: --field is ignored without --request-type
<creates issue successfully>
```

**After (v0.6.0-dev.12, pre-flight exit-64):**
```
$ jr issue create --project PROJ --summary "Task" --field foo=bar
jr: error: --field is only valid with --request-type (JSM service-desk requests).
Add --request-type <NAME> to submit a JSM request with custom fields, or drop --field to create a standard platform issue.
exit code 64
```

## Error Messages

The error messages are verbatim behavioral contracts (load-bearing strings — do NOT paraphrase):

### `--field` only:
```
--field is only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to submit a JSM request with custom fields, or drop --field to create a standard platform issue.
```

### `--on-behalf-of` only:
```
--on-behalf-of is only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to raise a request on behalf of another user, or drop --on-behalf-of to create a standard platform issue.
```

### Both `--field` and `--on-behalf-of` (combined guard fires, not two separate errors):
```
--field and --on-behalf-of are only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to use these flags, or drop them to create a standard platform issue.
```

## Guard Placement

The guard fires in `src/cli/issue/create.rs::handle_create`, AFTER the JSM dispatch fork
(`if request_type.is_some()` at ~:49) returns, BEFORE project-key resolution, BEFORE any HTTP
calls. If `--request-type` is present, the fork returns and the guard is never reached (JSM path
handles these flags correctly).

Guard logic:
```
match (field_present, on_behalf_of_present) {
    (true, true)  => combined error message
    (true, false) => --field only message
    (false, true) => --on-behalf-of only message
    (false, false) => no-op (continue platform path)
}
```

Exit code: 64 (`JrError::UserError`).

## Output Channel

Human mode: error to stderr, nothing to stdout.
JSON mode (`--output json`): structured JSON error envelope via `output::render_json` (JSON render invariant #526).

## Test Coverage Obligations

1. `tests/issue_create_preflight.rs` (new file) with 6 tests covering:
   - `--field` only: exit 64 + stderr exact message
   - `--on-behalf-of` only: exit 64 + stderr exact message
   - Both: exit 64 + combined message
   - `--output json` with `--field`: JSON error envelope shape
   - `--field` with `--request-type` (should succeed / reach JSM path): NOT exit 64
   - `--on-behalf-of` with `--request-type` (should succeed): NOT exit 64

2. `assert_json_error_envelope` promoted from `tests/json_error_shape.rs` to
   `tests/common/assertions.rs` (delete original file after promotion).

3. `tests/common/fixtures.rs` gains `write_profile_config` helper for pre-migrated
   `[profiles.default]`-shaped config (used by preflight tests to avoid auth errors
   masking the preflight error).

4. 5 existing tests renamed to `test_<verb>_<subject>_<expected_outcome>` convention:
   - `handle_create_warns_field_without_request_type` → `test_create_field_without_request_type_exits_64`
   - `handle_create_warns_on_behalf_without_request_type` → `test_create_on_behalf_of_without_request_type_exits_64`
   - `test_create_field_without_rt_warns` → `test_create_field_without_request_type_warns` (if exists)
   - (see S-639-1.md delivery checklist for authoritative rename table)

## Non-interactive Behavior

The guard fires identically in TTY and non-TTY mode. No prompt. No `--no-input` variant.
Exit 64 unconditionally when `--field` or `--on-behalf-of` is present without `--request-type`.

## Holdout Scenarios

| ID | Scenario | Behavior |
|----|----------|---------|
| H-NEW-PREFLIGHT-001 | `--field` without `--request-type` | exit 64, stderr contains `--field is only valid with --request-type` |
| H-NEW-PREFLIGHT-002 | `--on-behalf-of` without `--request-type` | exit 64, stderr contains `--on-behalf-of is only valid with --request-type` |
| H-NEW-PREFLIGHT-003 | Both flags without `--request-type` | exit 64, stderr contains combined message |
| H-NEW-PREFLIGHT-004 | Platform create with neither flag | exit 0, issue created (regression) |
| H-NEW-PREFLIGHT-005 | `--field` WITH `--request-type` | not exit 64 (JSM path handles) |
| H-NEW-PREFLIGHT-006 | `--on-behalf-of` WITH `--request-type` | not exit 64 (JSM path handles) |

## Breaking Change Notice (for CHANGELOG)

```
BREAKING: `jr issue create --field`/`--on-behalf-of` without `--request-type` now
exits 64 instead of warn-and-proceeding. Scripts that relied on warn-and-proceed behavior
must be updated: either add `--request-type` to submit a JSM request, or drop the
unsupported flags.
```

## Files Modified at F4

| File | Change |
|------|--------|
| `src/cli/issue/create.rs` | Add pre-flight guard after JSM fork (~:49) |
| `src/cli/issue/jsm_create.rs` | Verify --field/--on-behalf-of still reach JSM path correctly |
| `src/cli/mod.rs` | Confirm field/on_behalf_of accessible in handle_create scope |
| `tests/issue_create_preflight.rs` | New test file (6 tests) |
| `tests/common/assertions.rs` | Add `assert_json_error_envelope` (promoted from json_error_shape.rs) |
| `tests/json_error_shape.rs` | Delete after promotion |
| `tests/common/fixtures.rs` | Add `write_profile_config` helper |
| `CHANGELOG.md` | BREAKING change entry |
| `docs/specs/issue-create-preflight-guards.md` | This file (already created) |

## See Also

- BC-3.8.012: `--field` without `--request-type` behavioral contract
- BC-3.8.013: `--on-behalf-of` without `--request-type` behavioral contract
- ADR-0014: JSM request-type dispatch fork
- DEC-188: Decision to promote from warn-and-proceed to exit-64
- `.factory/stories/S-639-1.md`: Full implementation story with all 21 ACs
