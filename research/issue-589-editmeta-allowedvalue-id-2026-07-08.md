# Research: Issue #589 — AllowedValue.id Required-String vs Atlassian Schema

**Date:** 2026-07-08
**Bundle:** SOH-BUGS-1
**Status:** VALIDATED

## Summary

`jr issue edit --field` (and the `--dry-run` path) deserializes the entire
editmeta response via serde. `AllowedValue.id` is a required `String`. Any Jira
project whose `allowedValues` entries lack `id` — a schema-valid condition per the
Atlassian OpenAPI specification — causes a serde deserialization failure and an
unhandled error surface, blocking the edit entirely.

## Root Cause (Code Investigation)

**Failure path:**

```
src/cli/issue/edit.rs::handle_edit (dry-run branch)
  → src/cli/issue/field_resolve.rs::resolve_edit_fields Phase 2
      (comment: "editmeta fetch")
    → src/api/jira/issues.rs::get_editmeta
      → src/api/client.rs::get<T> → serde_json::from_slice
```

**Failing struct:**

`src/types/jira/editmeta.rs::AllowedValue`

```rust
pub struct AllowedValue {
    pub id: String,          // ← required; no Option<>
    pub name: Option<String>,
    pub value: Option<String>,
    // …
}
```

The editmeta response is `HashMap<String, EditMetaField>`. Serde must successfully
deserialize ALL entries in the HashMap to produce a usable result — including fields
the user is NOT editing. A single `allowedValues` entry lacking `id` in ANY field
causes the entire deserialization to fail.

**Error surface:** `serde_json` Display message
`"missing field \`id\` at line 1 column NNNNN"` propagated via
`src/main.rs` eprintln path. Exit code 1.

**The failure is strictly pre-mutation:** even `--dry-run` cannot succeed because
the deserialization failure occurs before any mutation is attempted or reported.

## External Research (Perplexity, 2026-07-08)

**Atlassian OpenAPI schema:**

`FieldMetadata.allowedValues` is typed as a generic object array with NO required
properties (source: developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/).
There is no guarantee that `id` is present. The field is described as "the list of
values allowed in the field" with each entry being an untyped object.

**Field-type survey — known id-absent shapes:**

| Field type | Key field | id present? |
|------------|-----------|-------------|
| User/group pickers | `accountId` (user) or `groupId`/`name` (group) | No `id` (GDPR migration removed it from user pickers) |
| Assets / plugin fields | Arbitrary; provider-defined | Not guaranteed |
| `sd-customerrequesttype` | Undocumented shape | Not confirmed |
| Standard `issuetype`, `priority`, `status` | Yes, `id` present | Yes |

**Ecosystem posture (7 client libraries surveyed):**

All seven surveyed Jira API client libraries use loose typing for `allowedValues`:

- `go-jira` — `interface{}` / `map[string]interface{}`
- `jira-python` (pycontribs) — generic dict
- `atlassian-python-api` — untyped
- `atlassian-connect-go` — `interface{}`
- OpenAPI-generated Rust `jira-api-v2-rs` — `serde_json::Value`
- Dart `atlassian_apis` — `Object?`
- `ankitpokhrel/jira-cli` (Go reference CLI) — `interface{}`

A required `id: String` is an **ecosystem outlier**. No other surveyed library
imposes a required `id` constraint on `allowedValues` entries.

**Citation discipline note:** JRASERVER-61594 ("option values hidden by admin") is
adjacent topic (disabled options) but is NOT evidence for the missing-`id` symptom.
Per CLAUDE.md citation discipline, it is NOT cited here as evidence. No
confirmed JRACLOUD/JRASERVER ticket documents the exact missing-`id`
deserialization failure.

## Recommended Fix

**Blast radius:** small and contained.

1. **`src/types/jira/editmeta.rs`** — change `AllowedValue.id` from `String` to
   `Option<String>`. Consider making all `AllowedValue` fields optional to match the
   Atlassian schema's no-required-properties guarantee:
   ```rust
   pub struct AllowedValue {
       pub id: Option<String>,
       pub name: Option<String>,
       pub value: Option<String>,
       // …
   }
   ```

2. **`src/cli/issue/field_resolve.rs`** — 4 use sites of `av.id` (approximately at
   lines ~496, ~514, ~521, ~545 — confirm with `grep -n "av\.id"`) need
   `Option`-aware handling. Pattern: `av.id.as_deref().unwrap_or("<no-id>")` for
   display, or `.ok_or_else(|| JrError::…exit_64…)` for resolution paths that
   genuinely require a resolvable id.

3. **Tests** — add a fixture test exercising editmeta deserialization with an
   `allowedValues` entry that has no `id` field (simulating user/group picker fields).
   The fixture should confirm graceful handling (no panic, no serde error).

**No API surface change, no CLI surface change.** This is a pure type-tightening fix.

## Verdict

VALIDATED. Root cause confirmed. Fix is bounded to `editmeta.rs` + 4 sites in
`field_resolve.rs` + fixture test. Ecosystem outlier classification confirmed by
external research.
