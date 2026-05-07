# Red Gate Log — S-0.04 (BC-6.3.001)

**Date:** 2026-05-07
**Story:** S-0.04 — Migrate 14 field-read sites to `config.active_profile()`
**Test file:** `tests/multi_profile_fields.rs`
**Branch:** `fix/multi-profile-fields-active`

## Summary

8 tests written. 6 FAIL (behavioral — correct Red state). 2 PASS (unit contract
tests that verify `Config::active_profile()` itself is correct). Red Gate verified.

## Test Results (pre-fix)

```
running 8 tests
test test_bc_6_3_001_active_profile_returns_per_profile_field_ids ... ok
test test_bc_6_3_001_field_ids_survive_toml_save_round_trip ... ok
test test_bc_6_3_001_sandbox_profile_uses_sandbox_story_points_field_id ... FAILED
test test_bc_6_3_001_error_message_references_profiles_section_not_fields ... FAILED
test test_bc_6_3_001_points_column_present_after_save_round_trip ... FAILED
test test_bc_6_3_001_list_points_warning_references_profiles_section ... FAILED
test test_bc_6_3_001_board_view_shows_team_after_save_round_trip ... FAILED
test test_bc_6_3_001_sprint_current_shows_team_and_points_after_save_round_trip ... FAILED

test result: FAILED. 2 passed; 6 failed; 0 ignored; 0 measured; 0 filtered out
```

## Failure Analysis

| Test | Failure Mode | BC Clause |
|------|-------------|-----------|
| `test_bc_6_3_001_sandbox_profile_uses_sandbox_story_points_field_id` | Process exits non-zero: "Story points field not configured" — code reads `config.global.fields` (empty post-round-trip) instead of sandbox profile's `customfield_10099` | BC-6.3.001 postcondition / H-NEW-MP-001 |
| `test_bc_6_3_001_points_column_present_after_save_round_trip` | Points column absent from table output because `config.global.fields.story_points_field_id` is `None` | BC-6.3.001 postcondition (AC-002) |
| `test_bc_6_3_001_sprint_current_shows_team_and_points_after_save_round_trip` | Neither Points nor Team column present — both field IDs read from `config.global.fields` (None) | BC-6.3.001 postcondition (AC-003) |
| `test_bc_6_3_001_board_view_shows_team_after_save_round_trip` | Team column absent — `config.global.fields.team_field_id` is `None` | BC-6.3.001 postcondition (AC-004) |
| `test_bc_6_3_001_error_message_references_profiles_section_not_fields` | Error says `[fields]` not `[profiles.<name>]` | BC-6.3.001 postcondition (AC-005) |
| `test_bc_6_3_001_list_points_warning_references_profiles_section` | Warning says `[fields].story_points_field_id` not `[profiles.<name>]` | BC-6.3.001 postcondition (AC-006) |

## Passing Tests

| Test | Why it passes | Notes |
|------|--------------|-------|
| `test_bc_6_3_001_active_profile_returns_per_profile_field_ids` | `Config::active_profile()` is already correct | Documents the contract; confirms `active_profile()` returns per-profile data |
| `test_bc_6_3_001_field_ids_survive_toml_save_round_trip` | TOML serialization/deserialization of `GlobalConfig` preserves `[profiles.*]` field IDs | Confirms the data survives round-trip at the struct level |

## Lib Baseline

```
test result: ok. 600 passed; 0 failed; 10 ignored; 0 measured; 0 filtered out
```

Baseline preserved. Zero regressions.

## Hand-off to Implementer

All 6 behavioral tests fail for correct reasons (assertion errors, not build
errors). Fix the 14 call sites listed in S-0.04 and update the 2 error message
strings to make each test pass. The two unit tests must continue to pass.

Fix pattern: `config.global.fields.X` → `config.active_profile().X`
