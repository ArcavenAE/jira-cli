# Red Gate Log — S-SOH-589-1

**Date:** 2026-07-09
**Story:** S-SOH-589-1 (story #105) — tolerate id-absent editmeta allowedValues in `issue edit --field`
**Route:** standard bug-fix (HIGH)
**Branch:** `fix/S-SOH-589-1-allowedvalue-id-option` (deleted post-merge)
**Base:** develop @ 4f3960e0 (S-SOH-590-1 delivered)
**F4 dispatch authorized by:** human, 2026-07-09 (DEC-165, standard bug-fix route)

## Summary

Red Gate verified 2026-07-09 by orchestrator.

- **Red Gate state — commits 1e9c770 (stub) / 614963f (tests authored, uppercase-renamed):** 4 tests FAILED with genuine serde "missing field `id`" assertion errors. At 614963f the test expectations were renamed to uppercase to reflect the correct future behavior; all 4 remained RED. 56 pre-existing tests passed throughout (no regressions introduced by stubs).
- **Green Gate at 86907e5:** all 4 story tests PASS; full suite 2016 passed / 0 failed / 93 ignored.
- **Adversarial-round tests (commits 347c30e→6094d32):** authored after Green Gate as part of Step 4.5 adversarial convergence; post-date Red Gate by design (not part of the original TDD Red Gate).

## Red Gate State (614963f — BEFORE implementation)

| Test | State | Failure Mode | AC |
|------|-------|-------------|-----|
| `test_allowed_value_id_optional_deserializes_when_absent` | FAIL | serde: missing field `id`; `AllowedValue.id` was `String` (required), JSON had no `id` key | AC-001 (id absent) |
| `test_allowed_value_id_optional_deserializes_when_null` | FAIL | serde: missing field `id`; `AllowedValue.id` was `String` (required), JSON had `"id": null` | AC-002 (id null) |
| `test_field_resolve_exits_64_when_all_values_lack_id` | FAIL | serde: missing field `id`; resolver never reached; all-absent case untestable | AC-003 (id=None exit-64) |
| `test_field_resolve_skips_values_without_id_in_partial_match` | FAIL | serde: missing field `id`; partial-match skip path unreachable while type was String | AC-004 (partial-match skip) |

### Failure Analysis

`src/types/jira/editmeta.rs::AllowedValue` defined `id: String` — a required serde field. Atlassian's editmeta API does not guarantee `id` is present on all allowedValues (ecosystem outlier vs standard Jira fields). When an instance returns an allowedValue without `id`, serde deserialization panics/errors at the `AllowedValue` boundary before any logic runs. The fix: change `id: String` → `id: Option<String>` and update all 4 use sites in `src/cli/issue/field_resolve.rs` to handle `None` (EC-3.4.016-8: skip in partial_match, exit 64 when all values lack id).

## Green Gate (86907e5)

| Test | State | Notes |
|------|-------|-------|
| `test_allowed_value_id_optional_deserializes_when_absent` | PASS | `id: None` deserialized correctly |
| `test_allowed_value_id_optional_deserializes_when_null` | PASS | `id: None` deserialized correctly from null |
| `test_field_resolve_exits_64_when_all_values_lack_id` | PASS | exit 64 + actionable message |
| `test_field_resolve_skips_values_without_id_in_partial_match` | PASS | None values skipped; Some values still matched |

**Full suite at Green Gate:** 2016 passed / 0 failed / 93 ignored.

## Adversarial-Round Tests (347c30e→6094d32 — post-Green Gate)

Adversarial passes p1/p2 identified additional edge-case gaps. Tests added in adversarial fix rounds:

- `test_allowed_value_id_none_not_included_in_match_candidates` — pin that None-id values are excluded from candidate set (not just skipped silently)
- `test_field_resolve_mixed_some_and_none_ids_matches_on_some` — regression-pin for mixed Some/None list, confirms Some values still resolve correctly

These tests post-date the Red Gate commit by design (adversarial round, not TDD round); they did not exist at the Red Gate timestamp.
