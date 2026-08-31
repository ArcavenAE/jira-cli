# PR Review — S-578-4 (`issue create --field` platform path)

**PR:** #746 — https://github.com/Zious11/jira-cli/pull/746
**Branch:** feature/S-578-4-create-field-support → develop
**Reviewer:** pr-reviewer (fresh-eyes final pre-merge gate, cycle 1)
**Verdict:** APPROVE — ready to merge
**Date:** 2026-08-31

## Scope reviewed
Production: src/cli/issue/create.rs, edit.rs, field_resolve.rs, mod.rs, src/types/jira/editmeta.rs
Docs: CHANGELOG.md, CLAUDE.md, docs/adr/0014-jsm-request-type-dispatch.md
Tests: tests/issue_create_field.rs (new, 2996 LOC), tests/issue_create_jsm.rs (DEC-188 inversions)

## Independently verified
- Tests green locally: issue_create_field 62 + issue_create_jsm 107 + issue_edit_field 90 = 259/259 (matches badge).
- `cargo clippy --all-targets -- -D warnings` clean.
- D2 collision-guard flag→wire-key mapping correct against the real `handle_create` destructuring; zero-HTTP, runs before project/type resolution.
- CreateMetaField→EditMetaField adapter sound; new `Clone` derives on EditMetaFieldSchema/AllowedValue are load-bearing (back the `.clone()` of schema/allowed_values). `operations:["set"]`/`required:false` synthesis matches "createmeta has no operations" rationale.
- Createmeta resolved against the same `issue_type_name` used in the POST body — no validation/wire drift.
- JSM path untouched (removed guard sat after the `request_type.is_some()` fork return; 107 JSM tests confirm).
- Help-text/CHANGELOG/CLAUDE.md/ADR-0014 updates accurate and necessary; DEC-310 correctly scoped to `--field`; `--on-behalf-of` (BC-3.8.013) intact.
- Security CLEAN confirmed: `--field` values reach the wire only as `serde_json::Value` (serde escaping); reused path segments percent-encoded; createmeta pagination bounded.

## Non-blocking observations (no change required)
1. CREATE_D2_GOVERNED_KEYS's `points`/`team` entries are narrative-only — the static loop never consults them (handled by the separate `resolved_id_flags` path). Documented as intentional.
2. CLAUDE.md records field_resolve.rs at ~1,635 LOC; actual 1,650 (within the `~` convention).
3. Interactive-only residual: `--field issuetype=X` without `--type` bypasses the D2 presence check; not reachable on the non-interactive/agent path (which requires `--type`). Same class as the documented display-name residual.

## Merge note
`gh pr view` showed no CI status at review time — confirm `ci-gate` is green before merge. Nothing in the diff blocks it.
