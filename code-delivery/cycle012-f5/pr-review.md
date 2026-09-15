# PR #813 — Fresh-Eyes Pre-Merge Review (cycle-012 F5 finding-fix bundle)

**PR:** #813 — https://github.com/Zious11/jira-cli/pull/813
**Head:** `fix/cycle012-f5-findings` @ d18a986c → **Base:** `develop`
**Reviewer:** pr-reviewer (fresh-eyes, independent judgment)
**Verdict:** **APPROVE**

> Posting note: per the orchestrator's explicit instruction, this verdict was
> reported directly to the operator and was NOT posted to GitHub via
> `gh pr review` (the self-approval/posting path was deliberately blocked for
> this run). This file is the durable local review artifact only.

## Scope

4 files, +83/-9 (mostly a +65 regression test). Fixes cycle-012 Phase F5
review findings on top of the merged ADF-autoconvert feature.

## Findings

No blocking findings. No suggestions requiring change. Two non-blocking nits.

### OBS-1 narrowing — `src/cli/issue/field_resolve.rs` (~560-568) — CORRECT & COMPLETE
- ADF allowlist is `is_adf_schema` (`field_resolve.rs:810`): `system == "description" | "environment"` OR `custom` ending `:textarea`. The two ADF *system* fields are exactly `description`/`environment`, both bare lowercase field_ids (neither starts with `customfield_`). The narrowing `field_id == "description" || field_id == "environment"` matches that set precisely.
- `description` still lowercases (branch) and remains regression-pinned by existing `tests/issue_edit_field_adf.rs:807` (`changed_fields["description"]` via `--field`). AC-011 preserved.
- `environment` handled symmetrically.
- Custom `:textarea` ADF fields (`field_id == customfield_NNNNN`) keep display-name key under BOTH old and new code — no regression, consistent with the "custom field, no dedicated flag" convention.
- Non-ADF system fields (`duedate`/`priority`) restored to display-name keys, matching pre-cycle-012 behavior (`30bb1a18` had no remap at all).

### Regression test — GENUINE (not tautological)
`test_obs_1_non_adf_system_field_changed_fields_key_is_display_name` (tests/issue_edit_field.rs) drives a real non-ADF system field (`duedate`) end-to-end through the JSON path; asserts display-name key `"Due date"` present AND `"duedate"` absent. Exercises the `else { human_name }` branch; fails under pre-fix broadened code. Helpers exist; RED→GREEN confirmed.

### M-3 comment fix — `src/api/jsm/requests.rs` (~229) — ACCURATE
Line 212: `is_adf_request = description_is_adf || self.is_adf_request` — the OR of both channels. New comment correctly states it is NOT gated on description alone. Comment-only.

### H-1 / M-1 CLAUDE.md size deviations — PLAUSIBLE & FORMAT-COMPLIANT
- `field_resolve.rs`: 2,264 on develop + net +5 from diff = 2,269 (matches "~2,269").
- `jsm_create.rs`: 1,341, unchanged (matches "~1,341").
- Both entries follow the established format (LOC, date, growth rationale, DOCUMENT-AS-IS, ADR-0012, citation).

### Conventions — CLEAN
No let-chains; #526 JSON invariant untouched; exit codes untouched; no `#[allow]`/`unsafe`; test name follows `test_<verb>_<subject>_<outcome>`.

## Non-blocking nits (no change required)
- NIT (field_resolve.rs comment): "the other ADF-converted field" is slightly imprecise — custom `:textarea` fields are also ADF-converted; means "the other ADF-converted *system* field." Reads fine in context.
- The `environment` branch has no dedicated positive `changed_fields["environment"]` end-to-end assertion (description covered; new test covers negative). Risk negligible (symmetric with tested `description` branch). Optional future coverage.

## Accepted backlog (out of scope, not blocking)
- M-2 duplication (tracked separately).
- SEC-001.
