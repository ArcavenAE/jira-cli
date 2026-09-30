# Security Review — PR #888 (`fix/field-options-name-label`)

**Repo:** Zious11/jira-cli
**Branch:** `fix/field-options-name-label` → `develop`
**Issue:** #861
**Worktree reviewed:** `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-cycle14-field-options-name-label`
**Diff basis:** `git diff origin/develop...HEAD`

## Summary

| Severity | Count |
|---|---|
| Critical | 0 |
| High | 0 |
| Medium | 0 |
| Low | 0 |

**No findings. This PR is clean.**

## Scope of change

`jr field options <FIELD>` previously rendered `"(unnamed)"` (table) / `null`
(JSON) for every option of a system-typed field (e.g. `priority`,
`components`) because their `allowedValues` entries carry only `name`, not
`value`, and the normalizer only ever read `value`. The fix is a one-line,
presence-based fallback:

- **File:** `src/cli/field.rs`
- **Function:** `normalize_from_allowed_values_at_depth`
- **Change:** `label: v.value.clone()` → `label: v.value.clone().or_else(|| v.name.clone())`

Both `value` and `name` are pre-existing `Option<String>` fields on the
`AllowedValue` struct (`src/types/jira/editmeta.rs`) that were **already**
being deserialized off the wire before this PR (`name` was previously
parsed-but-unused, per the old doc comment). Only which field feeds the
rendered `label` changes — no new deserialization path, no new sink.

Full diff stat (`git diff origin/develop...HEAD --stat`):

```
CHANGELOG.md               |  19 +++
CLAUDE.md                  |   4 +-
README.md                  |   2 +-
src/api/jira/issues.rs     |   5 +-
src/cli/field.rs           | 410 ++++++++++++++++++++++++++++++++++++++++++++-
src/cli/mod.rs             |   6 +-
src/types/jira/editmeta.rs |  26 ++-
tests/field_options.rs     |  10 +-
8 files changed, 460 insertions(+), 22 deletions(-)
```

## Findings by review area

### 1. Injection / terminal-escape / format-string risk in the new label source (CWE-116, CWE-150)

**Ruled out.** The label — regardless of whether it is sourced from `value`
or `name` — flows through exactly the same two pre-existing, unchanged
sinks, both of which were already receiving `value`-sourced strings before
this PR:

- **Table output:** `src/output.rs::render_table` → `comfy_table::Table::add_row`
  (`UTF8_FULL_CONDENSED` preset). Standard library cell handling; no raw
  ANSI/terminal writes; no manual string formatting of untrusted content
  into a format-string argument.
- **JSON output:** `src/output.rs::render_json` → `serde_json::to_string_pretty`.
  Standard escaping. `field.rs` routes through `output::print_output`,
  satisfying the repo's #526 JSON-render invariant (confirmed by
  inspection — no direct `serde_json::to_string_pretty`/compact `json!`
  Display bypass introduced).

Since `name` and `value` are equally attacker-influenced-by-a-
malicious/compromised-Jira-server strings, and both were already handled
identically at the type level (`Option<String>`) pre-PR, this change adds
**zero new exposure**. No applicable CWE.

### 2. New HTTP/network surface, new dependency, credential/auth-path changes

**Ruled out.**

- `Cargo.toml` / `Cargo.lock`: empty diff — confirmed via `git diff
  origin/develop...HEAD -- Cargo.toml Cargo.lock`. No new dependency.
- No new HTTP call: the only touched API-layer file,
  `src/api/jira/issues.rs`, has a 2-line diff that is a doc-comment wording
  correction only ("custom field's" → "field's (custom or system)");
  function body is byte-for-byte unchanged.
- No auth/credential code appears anywhere in the diff. Full file list:
  `CHANGELOG.md`, `CLAUDE.md`, `README.md`, `src/api/jira/issues.rs`,
  `src/cli/field.rs`, `src/cli/mod.rs`, `src/types/jira/editmeta.rs`,
  `tests/field_options.rs`.

### 3. WRITE-side `field_resolve.rs` — confirmed untouched

`git diff origin/develop...HEAD --stat -- src/cli/issue/field_resolve.rs`
returns **empty** — zero changes. The write-side option-value matching path
(`issue edit --field` / `issue create --field`) still matches against
`value` only via `find_option_match`/`resolve_option_value`. The new doc
comment added to `AllowedValue` (`src/types/jira/editmeta.rs`) explicitly
documents this as a deliberate D-378 "READ-SIDE ONLY" scope boundary. No
cross-contamination between the read-side label-display fix and the
write-side value-matching/API-call logic.

### 4. Doc-comment-only files

- `src/api/jira/issues.rs` — 2-line rustdoc wording fix, no code change.
- `src/cli/mod.rs` — 2 about-text/doc-comment string literal wording
  changes (CLI `--about` text, and a doc comment updated to reference the
  renamed `search_field_list` helper instead of stale `partial_match`
  naming). Cosmetic; no logic change; no user-controlled content in these
  literals.
- `src/types/jira/editmeta.rs` — doc-comment expansion documenting the new
  `name`-fallback consumer and the WRITE-side scope boundary; struct
  fields/derives/serde attributes unchanged.
- `CHANGELOG.md`, `README.md`, `CLAUDE.md` — prose only.

### 5. Test suite addition

`src/cli/field.rs` (+410 lines) and `tests/field_options.rs` (4 line-level
renames/comment updates). All new code in `field.rs` is under
`#[cfg(test)] mod tests`: presence/emptiness matrices (top-level and
cascading-child), a recursive `proptest` strategy (`arb_allowed_value`)
covering the fallback and the output JSON key-set invariant, an M3
regression guard (proves `normalize_from_valid_values` does NOT gain an
unintended `name` fallback), and a `--value` filter test against a
`priority`-shaped fixture. No production code path is added beyond the
single `or_else` fallback reviewed in §1. Test fixtures use only literal/
generated strings; no live network calls; no embedded secrets or real
Jira instance data (consistent with the repo's no-real-data convention).

## Conclusion

This PR is exactly as advertised: a presence-based `Option::or_else`
fallback on an already-parsed, already-typed wire field, feeding the same
two pre-existing, safely-escaped rendering sinks it always fed. No new
attack surface, no new dependency, no new network call, no credential/auth
impact, and the write-side value-matching logic is verifiably untouched.

**Recommendation: approve from a security standpoint.**
