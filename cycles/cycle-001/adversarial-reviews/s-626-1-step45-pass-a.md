---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: code-reviewer
timestamp: 2026-07-30T00:00:00
phase: 5
inputs:
  - src/cli/auth/keychain.rs
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - tests/team_column_parity.rs
input-hash: "830066c"
traces_to: S-626-1.md
story: S-626-1
step: 4.5
pass: A
aperture: semantic-equivalence
date: 2026-07-30
reviewer: code-reviewer
isolation: sibling reviews not read
previous_review: null
---

# Adversarial Review: S-626-1 Let-Chain Rewrite (Pass A)

## Aperture

Semantic equivalence only: is every let-chain rewrite in commit `cc7f6da5`
a provably identical program? Not style, not tidiness — identical control
flow, branch reachability, binding scope, and side-effect count across every
combination of guard conditions.

## Finding ID Convention

Finding IDs use the format: `ADV-P<PASS>-<SEV>-<SEQ>` (no cycle prefix — no
`.factory/current-cycle` file exists in this repo).

- `ADV`: Fixed prefix
- `PA`: Pass A of step 4.5
- `<SEV>`: `CRIT`, `HIGH`, `MED`, `LOW`
- `<SEQ>`: Three-digit sequence

## Files Reviewed

- `src/cli/auth/keychain.rs` (original from `git show origin/develop:...` + worktree)
- `src/cli/board.rs` (original from `git show origin/develop:...` + worktree)
- `src/cli/issue/list.rs` (original from `git show origin/develop:...` + worktree)
- `tests/team_column_parity.rs` (test coverage analysis, item 7)
- `tests/issue_read_holdouts.rs` (test coverage analysis, item 7)

---

## Per-Site Case Analysis

### Site 1 — `src/cli/auth/keychain.rs::resolve_credential` (~line 50)

**Before (let-chain):**
```rust
if let Ok(v) = std::env::var(env_name)
    && !v.is_empty()
{
    return Ok(v);
}
```

**After (nested if):**
```rust
if let Ok(v) = std::env::var(env_name) {
    if !v.is_empty() {
        return Ok(v);
    }
}
```

| `env_name` state | `std::env::var` result | `v.is_empty()` | BEFORE outcome | AFTER outcome  | Equal? |
|------------------|------------------------|----------------|----------------|----------------|--------|
| Not set          | `Err(_)`               | N/A            | fall-through   | fall-through   | ✓      |
| Set to `""`      | `Ok("")`               | true           | fall-through   | fall-through   | ✓      |
| Set to non-empty | `Ok("val")`            | false          | `return Ok(v)` | `return Ok(v)` | ✓      |

**Binding scope:** `v` binds in BEFORE only when both conditions succeed. In AFTER,
`v` binds inside the outer `if let` block and is used only inside the inner `if` body.
No other code between the two arms references `v`. No scope-leak.

**Evaluation order:** `std::env::var(env_name)` called exactly once in both. The
empty check `!v.is_empty()` called at most once (when `Ok`). Identical.

**Result: All 3 paths semantically identical.**

---

### Site 2 — `src/cli/board.rs::handle_view` team_displays (~line 231)

The original let-chain guard had two conditions with a single shared `else { Vec::new() }`:
- Condition 1: `matches!(output_format, OutputFormat::Table)`
- Condition 2: `let Some(field_id) = team_field_id`

The single `else` fired if EITHER condition was false — covering two distinct input
cases (non-Table, and Table-but-None). The rewrite introduces an explicit inner else.

| `output_format`  | `team_field_id` | `uuids.any(Some)` | BEFORE result       | AFTER result             | Equal? |
|------------------|-----------------|-------------------|---------------------|--------------------------|--------|
| Non-Table        | None            | N/A               | `Vec::new()` (else) | `Vec::new()` (outer else)| ✓      |
| Non-Table        | Some(_)         | N/A               | `Vec::new()` (else) | `Vec::new()` (outer else)| ✓      |
| Table            | None            | N/A               | `Vec::new()` (else) | `Vec::new()` (inner else)| ✓      |
| Table            | Some(f)         | false             | `Vec::new()`        | `Vec::new()`             | ✓      |
| Table            | Some(f)         | true              | `Vec<String>`       | `Vec<String>`            | ✓      |

The critical risky path — **Table + `team_field_id = None`** (row 3) — maps to the
new inner `else { Vec::new() }`. This is provably identical to the shared else of the
original let-chain.

**Body verbatim:** The `uuids` computation, `team_map` build, and `collect()` are
copied character-for-character with only indentation changes. No expressions added,
removed, or reordered.

**Side-effect count:** `client.verbose()` once before the expression in both. `issues.iter()`
for team_id only on Table+Some path. `crate::cache::read_team_cache` only when any uuid
is Some. All identical.

**Result: All 5 paths semantically identical.**

---

### Site 3 — `src/cli/issue/list.rs::handle_list` team_displays (~line 523)

Structurally identical transformation to Site 2. Same guard conditions, same body,
same inner/outer else placement. Comment text inside the body is re-indented but not
altered.

| `output_format`  | `team_field_id` | `uuids.any(Some)` | BEFORE result       | AFTER result             | Equal? |
|------------------|-----------------|-------------------|---------------------|--------------------------|--------|
| Non-Table        | None            | N/A               | `Vec::new()` (else) | `Vec::new()` (outer else)| ✓      |
| Non-Table        | Some(_)         | N/A               | `Vec::new()` (else) | `Vec::new()` (outer else)| ✓      |
| Table            | None            | N/A               | `Vec::new()` (else) | `Vec::new()` (inner else)| ✓      |
| Table            | Some(f)         | false             | `Vec::new()`        | `Vec::new()`             | ✓      |
| Table            | Some(f)         | true              | `Vec<String>`       | `Vec<String>`            | ✓      |

**Result: All 5 paths semantically identical.**

---

## Checklist Coverage (Items 1–8)

1. **Before/after obtained from source.** `git show origin/develop:<path>` for
   originals; worktree files for current; `git show cc7f6da5` for the diff. Not
   based on story description alone.

2. **Per-site case analysis with truth tables.** Done — see Site 1, 2, 3 tables above.

3. **if/else-expression sites (board.rs ~232, list.rs ~524) — three-outcome analysis.**
   Done. Rows cover: outer false; outer true + inner None; outer true + inner Some (×2
   sub-cases). The outer-true / inner-None case maps cleanly to the new inner else. No
   path is lost.

4. **`keychain.rs` shape and early-return ordering.** The original guard `!v.is_empty()`
   is a plain boolean (not a binding), appended with `&&`. The rewrite moves it to a
   nested `if`. Early-return fires only when both `Ok` and non-empty. Empty-string check
   ordering is preserved: env var is checked before the no-input fallback in both versions.

5. **Side effects and evaluation order.** Verified for all three sites. No expression
   called more times, fewer times, or in different order. The `client.verbose()` call
   precedes the if-expression in both board.rs and list.rs.

6. **Behaviour under both output formats.** Table and JSON (and any other OutputFormat
   variant) produce identical values. The JSON path hits `Vec::new()` via the outer
   else — same as before.

7. **Test coverage of changed paths.** Addressed under findings (A-PA-LOW-001 below).
   The passing suite (2341 passed / 0 failed / 100 ignored) does NOT exercise Path B
   (Table + `team_field_id = None`) for `board.rs` or `list.rs` — only for `sprint.rs`
   (which was NOT modified by this commit). This is a pre-existing gap. The code
   transformation is provably correct by inspection regardless.

8. **Scope discipline.** Commit `cc7f6da5` changes exactly 98 lines across exactly 3
   files, all constituting minimum-footprint let-chain removal. No renames, no logic
   changes, no opportunistic refactoring.

---

## Part B — New Findings (Pass A)

### LOW

#### ADV-PA-LOW-001: Path B (Table + team_field_id = None) untested for board.rs and list.rs

- **Severity:** LOW
- **Category:** coverage-gap
- **Location:** `tests/team_column_parity.rs` (missing tests); `src/cli/board.rs::handle_view` ~line 254; `src/cli/issue/list.rs::handle_list` ~line 549
- **Description:** The outer-true / inner-None path (Table output + `team_field_id = None`) is exercised in `sprint_current_omits_team_column_when_field_unconfigured` for `sprint.rs`, but no analogous test exists for `board view` or `issue list`. The rewrite is provably correct by inspection (the new inner `else { Vec::new() }` covers exactly what the original shared else covered), but the passing suite does not provide behavioral evidence for this specific path in the changed files.
- **Evidence:** `tests/team_column_parity.rs` contains `sprint_current_omits_team_column_when_field_unconfigured` (line 183) using `write_config_without_team_field`, and `board_view_kanban_shows_team_column_when_populated` + `board_view_kanban_omits_team_column_when_no_issue_has_team` for board.rs — but neither board test calls `write_config_without_team_field`. No issue-list test exercises Table + unconfigured team field.
- **Proposed Fix:** Add `board_view_kanban_omits_team_col_when_field_unconfigured` and `issue_list_omits_team_col_when_field_unconfigured` tests to `tests/team_column_parity.rs` using `write_config_without_team_field`. Not required to merge this PR — gap pre-exists the commit.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0     |
| HIGH     | 0     |
| MEDIUM   | 0     |
| LOW      | 1     |

**Overall Assessment:** pass-with-findings
**Convergence:** findings remain — one LOW coverage gap (pre-existing, not a behavioural regression)
**Readiness:** ready for next phase; LOW finding is advisory only

## Novelty Assessment

| Field                          | Value                                        |
|-------------------------------|----------------------------------------------|
| **Pass**                       | A (step 4.5, first pass)                     |
| **New findings**               | 1                                            |
| **Duplicate/variant findings** | 0                                            |
| **Novelty score**              | 1.0 (1 / (1 + 0))                            |
| **Median severity**            | 1.5 (LOW)                                    |
| **Trajectory**                 | pass A: 1 LOW                                |
| **Verdict**                    | FINDINGS_REMAIN (advisory only; no GAPs)     |

VERDICT: CLEAN (no behavioural differences)
