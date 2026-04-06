# `--asset` Name Resolution Design Spec

**Issue:** #101
**Status:** Draft
**Date:** 2026-04-05

## Problem

`jr issue list --asset` requires an object key (e.g., `OBJ-18`). To find that key, a user or AI agent must first run `jr assets search` with an AQL query, parse the result, then pass the key. This three-step process requires AQL knowledge and breaks the single-command workflow.

## Solution

Accept asset names in addition to object keys. If the value doesn't match the `SCHEMA-NUMBER` key pattern, resolve it by searching Assets via AQL, then disambiguate if needed.

```
# Key (existing behavior, unchanged)
jr issue list --project PROJ --asset OBJ-18

# Name (new behavior)
jr issue list --project PROJ --asset "Acme Corp"
```

## Detection Logic

Use `validate_asset_key` (already in `jql.rs`) to distinguish keys from names:

- `validate_asset_key` succeeds → treat as key, skip resolution
- `validate_asset_key` fails → treat as name, resolve via AQL

This is unambiguous: valid keys follow `<alphanumeric>-<digits>` (e.g., `CUST-5`, `SRV-42`). Human-readable names never match this pattern.

## Resolution Flow

New function: `resolve_asset(client, input, no_input) -> Result<String>` in `src/cli/issue/helpers.rs`.

```
1. validate_asset_key(input) succeeds → return input (key passthrough)
2. Fetch workspace_id via get_or_fetch_workspace_id() (cached, 7-day TTL)
3. Escape input for AQL: escape \ then " (same as jql::escape_value)
4. search_assets(workspace_id, Name like "<escaped_input>", limit=25, include_attributes=false)
5. Filter and disambiguate results:
   a. Zero results → error
   b. One result → return result.object_key
   c. Multiple results → use partial_match on labels, then:
      - Exact match → return that asset's key
      - Ambiguous + no_input → error with disambiguation list
      - Ambiguous + interactive → dialoguer selection prompt
```

### AQL Escaping

User input is interpolated into AQL: `Name like "<input>"`. Only double quotes and backslashes are special within AQL quoted strings. Parentheses, single quotes, and AQL operators are not special inside quotes.

Escape strategy: `input.replace('\\', "\\\\").replace('"', "\\\"")` — identical to the existing `escape_value` function in `jql.rs`.

### Disambiguation Display

Use the `label` field from `AssetObject` for human-readable display. The `label` reflects the object type's configured label attribute (usually Name, but configurable). This is the same identifier Jira shows throughout its UI.

Format for non-interactive error:
```
Multiple assets match "Acme":
  OBJ-11 (Acme Corp - West)
  OBJ-18 (Acme Corp - East)
Use a more specific name or pass the object key directly.
```

Format: `{object_key} ({label})` per line.

Interactive prompt shows the same format as selection options.

## Handler Integration

In `src/cli/issue/list.rs`, replace the early `validate_asset_key` call:

```rust
// Before:
if let Some(ref key) = asset_key {
    crate::jql::validate_asset_key(key).map_err(JrError::UserError)?;
}

// After:
let asset_key = if let Some(raw) = asset_key {
    Some(helpers::resolve_asset(client, &raw, no_input).await?)
} else {
    None
};
```

Everything downstream stays unchanged:
- `get_or_fetch_cmdb_fields` — receives resolved key
- `build_asset_clause` — receives resolved key, builds `aqlFunction("Key = \"...\"")` JQL
- No changes to `jql.rs`, `mod.rs`, or API layer

## Precedent: `--assignee` Resolution

This follows the same pattern as `resolve_user` in `helpers.rs`:

| Aspect | `--assignee` | `--asset` |
|--------|-------------|-----------|
| Special keyword | `"me"` → `currentUser()` | None |
| API search | `search_users(name)` | `search_assets(workspace_id, AQL)` |
| Disambiguation | `partial_match` on display names | `partial_match` on labels |
| Interactive | `dialoguer` selection | `dialoguer` selection |
| Non-interactive | Error with candidate list | Error with candidate list |
| Passthrough | N/A (always resolves) | Key pattern → skip resolution |

## Error Messages

| Scenario | Message |
|----------|---------|
| No matches | `No assets matching "Acme" found. Check the name and try again.` |
| Multiple + `--no-input` | `Multiple assets match "Acme":\n  OBJ-11 (Acme Corp - West)\n  OBJ-18 (Acme Corp - East)\nUse a more specific name or pass the object key directly.` |
| Assets unavailable | Existing 404/403 error from `get_or_fetch_workspace_id` |
| Workspace not found | Existing error from `get_or_fetch_workspace_id` |

## Testing

### Unit Tests (in `helpers.rs` or `tests/cli_handler.rs`)

1. **Key passthrough**: `resolve_asset(client, "OBJ-18", false)` returns `"OBJ-18"` without API calls
2. **Single match**: AQL returns one result → returns its `object_key`
3. **Multiple matches, exact label**: AQL returns multiple but `partial_match` finds exact → returns that key
4. **Multiple matches, ambiguous**: AQL returns multiple, no exact → error with list
5. **No matches**: AQL returns empty → error

### Handler Tests (wiremock)

1. **Name resolution end-to-end**: `--asset "Acme"` triggers AQL search, resolves to key, produces correct JQL with `aqlFunction("Key = \"OBJ-18\"")`

### What Doesn't Need Testing

- Key format validation — already tested in `jql.rs`
- `build_asset_clause` — already tested, receives resolved key unchanged
- AQL search pagination — already tested in `search_assets`

## Files Changed

| File | Change Type | Description |
|------|------------|-------------|
| `src/cli/issue/helpers.rs` | Modify | Add `resolve_asset` function |
| `src/cli/issue/list.rs` | Modify | Replace `validate_asset_key` with `resolve_asset` |
| `tests/cli_handler.rs` | Modify | Add handler test for name resolution |

## Out of Scope

- Accepting names in other asset commands (`jr assets view`, `jr assets tickets`) — separate issue
- Searching by attributes other than Name — YAGNI
- Schema-scoped search (limit to specific object type) — YAGNI, disambiguation handles cross-type matches
- Wildcard or regex support — AQL `like` already does substring matching
