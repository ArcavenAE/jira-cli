---
document_type: story
story_id: "S-526"
title: "Replace all direct JSON serialization call sites in src/cli/ with output::render_json (CR-002, issue #526)"
wave: feature-followup
status: ready
intent: enhancement
feature_type: refactor
scope: standard
severity: low
trivial_scope: false
issue: 526
points: 2
priority: low
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: cli
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  - BC-7.1.001
bcs:
  - BC-7.1.001
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f1-delta-analysis/bundle-c-2026-06-17.md §CR-002"
implementation_strategy: tdd
module_criticality: LOW
files_modified:
  - src/cli/issue/create.rs      # 7 sites: lines 263, 279, 758, 1100, 1262, 1486, 2721 (handle_jsm_create compact json! Display)
  - src/cli/issue/workflow.rs    # 8 sites: lines 294, 419, 931, 1037, 1052, 1082, 1106, 1172
  - src/cli/issue/links.rs       # 4 sites: lines 99, 197, 216, 278
  - src/cli/auth/login.rs        # 1 site: line 334
  - src/cli/auth/logout.rs       # 1 site: line 43
  - src/cli/auth/switch.rs       # 1 site: line 44
  - src/cli/auth/remove.rs       # 1 site: line 122
  - src/cli/auth/list.rs         # 1 site: line 51
  - src/cli/auth/refresh.rs      # 1 site: line 141
  - src/cli/project.rs           # 1 site: compact json! Display in `jr project fields --output json` (Adversarial Round 2 finding C-1/F-2; previously deferred as CR-006 "accepted deviation" — now migrated in this story)
files_created: []
breaking_change: false
assumption_validations: []
risk_mitigations: []
created: "2026-06-17"
last_updated: "2026-06-17"
retroactive: false
---

# S-526 — Replace all direct JSON serialization call sites in `src/cli/` with `output::render_json` (CR-002)

## F2 Spec Note

**F2: no BC delta; CR-002 is governed by existing output BCs.**

This story is a refactor — it changes the implementation path used to serialize JSON
output. For all `to_string_pretty` sites the output is byte-identical. For two sites
(`handle_jsm_create` in `src/cli/issue/create.rs` and the `jr project fields --output
json` arm in `src/cli/project.rs`) the output changes from compact to pretty-printed
JSON (see [Behavior-Change Disclosure](#behavior-change-disclosure) below). No new
behavioral contract is required; BC-7.1.001 governs all JSON output and already
requires structured JSON without mandating compact vs. pretty format.

**Scope expansion (Adversarial Round 2, finding C-1/F-2):** `src/cli/project.rs`
contains a compact `json!` Display site in the `jr project fields --output json` arm.
This site was previously identified in F1 analysis as CR-006 "accepted deviation" but
that classification is superseded — the site is now migrated in this story, making the
claim "all `OutputFormat::Json` arms route through `output::render_json`" fully true.

The story's acceptance criteria trace to **BC-7.1.001** (`--output table` uses
comfy-table renderer; `--output json` emits structured JSON), which is the governing
contract for all CLI JSON output. The refactor moves from direct `serde_json::to_string_pretty` calls (dispersed across
CLI handler files) to the centralized `output::render_json` helper, which is literally
`Ok(serde_json::to_string_pretty(data)?)`. Output is byte-identical for all
`to_string_pretty` sites; the two compact Display sites (`handle_jsm_create` and
`jr project fields`) are the exceptions covered by the Behavior-Change Disclosure.

The auth-command JSON shape contracts (BC-7.4.013 through BC-7.4.016) and the issue
JSON shape contracts (BC-7.4.001 through BC-7.4.012) remain fully in force and are
not modified in any way.

## Source of Truth

F1 delta analysis: `.factory/phase-f1-delta-analysis/bundle-c-2026-06-17.md §CR-002`

Governing BC: `.factory/specs/prd/bc-7-output-render.md §BC-7.1.001`

Helper definition: `src/output.rs::render_json` (line 20–22)

## Summary

Replace all direct JSON serialization call sites in `src/cli/` with
`output::render_json(...)`. The migration covers all `serde_json::to_string_pretty(...)`
sites AND all compact `serde_json::json!(...).to_string()` (Display) sites — including
`src/cli/issue/create.rs` (`handle_jsm_create`) and `src/cli/project.rs` (`jr project
fields --output json`). The implementer must enumerate every `OutputFormat::Json =>`
arm across `src/cli/` and confirm zero bypass sites remain; the exact count will be
confirmed during implementation. The helper is:

```rust
pub fn render_json<T: Serialize>(data: &T) -> anyhow::Result<String> {
    Ok(serde_json::to_string_pretty(data)?)
}
```

For all `to_string_pretty` sites the substitution is purely mechanical and output bytes
are identical. The only semantic difference for those sites is the error type:
`serde_json::to_string_pretty` returns `serde_json::Error`; `render_json` converts it
to `anyhow::Error` via `?`. At all those sites this conversion was already happening via
the caller's own `?` propagation — `render_json` just makes it explicit and centralized.

Two sites currently emit compact one-line JSON via `serde_json::json!(...).to_string()`
(Display): `handle_jsm_create` (`src/cli/issue/create.rs`) and the `jr project fields
--output json` arm (`src/cli/project.rs`). Migrating both to `output::render_json`
changes their output from compact to pretty-printed. This is an intentional consistency
fix — see [Behavior-Change Disclosure](#behavior-change-disclosure).

`src/cli/sprint.rs` already uses `output::render_json` at 3 sites and is NOT in scope.
`src/cache.rs`, `src/config.rs`, and `src/adf.rs` use `serde_json::to_string_pretty`
for non-output purposes (cache serialization, config serialization, test helpers) and
are explicitly OUT of scope.

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-7.1.001 | `--output table` uses comfy-table renderer; `--output json` emits structured JSON. All migrated sites in `src/cli/` implement the `--output json` path. All `to_string_pretty` sites are byte-identical; 2 compact Display sites (`handle_jsm_create` and `jr project fields`) change from compact to pretty-printed (see Behavior-Change Disclosure). |

## Story Narrative

As a maintainer of the `jr` CLI codebase, I want all JSON output in CLI handlers to
route through `output::render_json` instead of calling `serde_json::to_string_pretty`
directly or using compact `serde_json::json!` Display printing, so that any future
global JSON transform (syntax highlighting, `_meta` envelope per NFR-O-P, structured
error wrapping) requires a change in exactly one place rather than 25. This also
eliminates the existing inconsistency where `jr issue create --request-type --output
json` emitted compact JSON while every other `jr` JSON output was pretty-printed.

## Acceptance Criteria

### AC-001 — Byte-identical JSON output on all `to_string_pretty` migrated sites (traces to BC-7.1.001 postcondition: `--output json` emits structured JSON)

Every command whose JSON output path passes through a migrated `to_string_pretty` site
must produce byte-for-byte identical output before and after this change. (The two
compact Display sites — `handle_jsm_create` and `jr project fields` — are explicitly
excluded from this AC; their output change is intentional and disclosed.)

**Verification method:** The existing test suite (integration tests in `tests/`,
snapshot tests under `src/snapshots/`) must pass without modification. No snapshot
files may require regeneration. Specifically: auth JSON snapshot tests
(`jr__cli__auth__*`), issue workflow snapshots (`jr__cli__issue__json_output__*`), and
all `--output json` integration tests that touch `create`, `workflow`, `links`, or
`auth` commands must continue to pass.

### AC-002 — Every `OutputFormat::Json` arm in `src/cli/` routes through `output::render_json` or `output::print_output` (traces to BC-7.1.001: centralized JSON render path)

After the change, ALL of the following grep commands return zero matches in `src/cli/`:

```
grep -rn "serde_json::to_string_pretty" src/cli/
```

For the compact `json!` Display pattern, a single-line grep is INSUFFICIENT because
`println!` and `serde_json::json!` may span multiple lines. Use multiline-capable scan:

```
# Multiline-aware: finds json! used outside of render_json (any .to_string() / Display path)
rg -U 'serde_json::json!\(' src/cli/ | grep -v 'render_json'
```

However, regex-based negative matching on multi-line patterns is fragile. The
**preferred and authoritative verification method** is an **enumeration-based audit**:

1. Collect every `OutputFormat::Json =>` match arm across `src/cli/`:
   ```
   rg -n 'OutputFormat::Json' src/cli/
   ```
2. For every arm found, confirm the JSON serialization path calls
   `output::render_json(...)` or `output::print_output(...)` — NOT
   `serde_json::to_string_pretty`, NOT `serde_json::json!(...).to_string()`,
   NOT `serde_json::to_writer`, NOT any other bypass.
3. Record the arm count in the PR description. At time of story authoring the
   expected count is approximately 26 arms across `src/cli/`; the implementer
   must confirm the exact count by enumeration, NOT by trusting a prior analysis.

**No arm may use a compact-JSON Display bypass.** The two sites that did
(`handle_jsm_create` in `create.rs` and `jr project fields` in `project.rs`) are
migrated in this story.

**Justified exceptions:** None. If during implementation an arm is found that
genuinely cannot use `render_json` (e.g., a non-`anyhow::Result` return context or a
deliberate inline diagnostic), it must be documented with an inline `// AC-002 exception:
<reason>` comment and acknowledged in this AC before the PR is opened.

**[process-gap] Adversarial Round 2 — strengthened codification note (C-1/F-2):**
The original AC used `grep -rn 'println!.*serde_json::json!'` to catch compact Display
sites. This grep is LINE-ANCHORED: it only matches if both tokens appear on the same
source line. Multi-line `println!( ... serde_json::json!( ... ) ... )` call sites are
invisible to it. The `src/cli/project.rs:82-95` site was missed for exactly this reason,
causing AC-002's "universal" claim to be FALSE while the grep returned zero matches.

**The fix is structural, not syntactic:** centralization ACs that assert "all X routes
through Y" MUST NOT rely on single-line grep negation. They must use one of:
- **Enumeration:** list every arm, verify each one by inspection (this AC's approach).
- **Multiline-capable scan:** `rg -U` / `grep -zoP` / `ast-grep` that matches across
  line boundaries.
- **Static analysis:** a clippy lint or build-time check that forbids the banned pattern
  at the AST level.

Single-line grep negation passes vacuously on multi-line call sites and gives false
confidence. This is a confirmed S-7.02 cycle-closing codification candidate: **"ACs
asserting output-path centralization must use enumeration or multiline-aware scanning,
never single-line grep negation."**

### AC-003 — Full test suite passes with at most two snapshot updates (traces to BC-7.1.001: existing behavior preserved)

`cargo test` passes. No test logic is added, removed, or modified. The only files
changed are the 10 CLI handler files listed in `files_modified`, plus at most two
snapshot file updates: one for `handle_jsm_create` JSON output and one for
`jr project fields --output json` (each reflecting compact → pretty-printed change —
see Behavior-Change Disclosure). All other snapshot files must remain byte-identical.

### AC-004 — `cargo clippy -- -D warnings` and `cargo fmt --all -- --check` are clean (traces to BC-7.1.001: implementation quality gate)

The migrated files must pass clippy with zero warnings and be formatted per `rustfmt`.
In particular: no unused import warnings (if `serde_json` is no longer referenced at
a file level, its `use serde_json;` may need removal or adjustment; verify per file).

## Behavior-Change Disclosure

**Two intentional non-byte-identical changes in this story.**

| Command | Payload fields (unchanged) | Before | After |
|---------|---------------------------|--------|-------|
| `jr issue create --request-type <RT> --output json` | `{"key": "<ISSUE-KEY>"}` only | Compact single-line | Pretty-printed multi-line (standard `render_json` format) |
| `jr project fields --output json` | (fields list unchanged) | Compact single-line | Pretty-printed multi-line (standard `render_json` format) |

**Rationale — `handle_jsm_create`:** (`src/cli/issue/create.rs`) emitted compact JSON
via `serde_json::json!({...}).to_string()` (Display), bypassing `output::render_json`
entirely. The payload is `{"key": "<ISSUE-KEY>"}` — only the issue key is returned
(the `requestTypeId` and `serviceDeskId` fields that appeared in an earlier draft of
this story were incorrect; the actual emitted payload contains only `key`).

**Rationale — `jr project fields`:** (`src/cli/project.rs:82-95`) emitted compact JSON
via the same `json!` Display pattern. This site was identified in F1 analysis as CR-006
"accepted deviation" but that deferral is superseded: the site is migrated here.
Migrating both sites to `render_json` aligns them with every other `jr` JSON output path.

**Consumer impact:** `jq`, `python -m json.tool`, and all standards-compliant JSON
parsers handle both compact and pretty-printed JSON identically. Only consumers doing
byte-exact string matching on the raw output are affected. Such consumers are outside
the supported use-case for `--output json` (structured data, not raw bytes).

**All `to_string_pretty` sites remain byte-identical.** These two compact-to-pretty
changes are the only output changes in the story.

## Tasks

### T-1: Verify `output::render_json` is in scope at all 10 files and enumerate all OutputFormat::Json arms

Before making any changes:

1. Confirm `output::render_json` is accessible (directly or via `use crate::output;`)
   in each of the 10 target files. Add the import where missing.

2. Run `rg -n 'OutputFormat::Json' src/cli/` to enumerate every JSON output arm.
   Record the count and file list. Any arm NOT already using `output::render_json` or
   `output::print_output` is a migration candidate — add it to the task list if not
   already covered below. This enumeration is the authoritative input for AC-002.

Files to check: `src/cli/issue/create.rs`, `src/cli/issue/workflow.rs`,
`src/cli/issue/links.rs`, `src/cli/auth/login.rs`, `src/cli/auth/logout.rs`,
`src/cli/auth/switch.rs`, `src/cli/auth/remove.rs`, `src/cli/auth/list.rs`,
`src/cli/auth/refresh.rs`, `src/cli/project.rs`.

### T-2: Migrate `src/cli/issue/create.rs` (7 sites)

Lines (approximate at time of analysis; verify before editing):

| Line | Pattern | Notes |
|------|---------|-------|
| 263 | `println!("{}", serde_json::to_string_pretty(&issue_json)?)` | Direct println; replace inner call |
| 279 | `println!("{}", serde_json::to_string_pretty(&json_response)?)` | Direct println |
| 758 | `println!("{}", serde_json::to_string_pretty(&payload)?)` | Dry-run path |
| 1100 | `serde_json::to_string_pretty(&json_output::edit_response(key, &changed_fields))?` | Returns into a let-binding |
| 1262 | `serde_json::to_string_pretty(&json_output::edit_response(...))` | Returns into a let-binding |
| 1486 | `println!("{}", serde_json::to_string_pretty(&payload)?)` | Dry-run path |
| 2721 | `println!("{}", serde_json::json!({"key": key, ...}))` | handle_jsm_create; compact Display site — **output changes from compact to pretty-printed** (intentional; see Behavior-Change Disclosure) |

Replacement pattern for the compact site (line 2721):
```rust
// Before
println!("{}", serde_json::json!({"key": key}));
// After
println!("{}", output::render_json(&serde_json::json!({"key": issue_key}))?);
```

Replacement pattern for `println!("{}", serde_json::to_string_pretty(&X)?)`:
```rust
println!("{}", output::render_json(&X)?);
```

Replacement pattern for `let s = serde_json::to_string_pretty(&X)?`:
```rust
let s = output::render_json(&X)?;
```

### T-3: Migrate `src/cli/issue/workflow.rs` (8 sites)

Lines (approximate):

| Line | Pattern |
|------|---------|
| 294 | `serde_json::to_string_pretty(&json_output::move_response(key, new_status, true))?` |
| 419 | `serde_json::to_string_pretty(&json_output::move_response(...))` |
| 931 | `println!("{}", serde_json::to_string_pretty(&payload)?)` |
| 1037 | `serde_json::to_string_pretty(&json_output::unassign_response(&key, false))?` |
| 1052 | `serde_json::to_string_pretty(&json_output::unassign_response(&key, true))?` |
| 1082 | `serde_json::to_string_pretty(&json_output::assign_unchanged_response(...))` |
| 1106 | `serde_json::to_string_pretty(&json_output::assign_changed_response(...))` |
| 1172 | `println!("{}", serde_json::to_string_pretty(&comment)?)` |

Note: The F1 analysis listed "7 sites" in the summary table but enumerated 8 line
numbers. The actual count is **8 sites** confirmed by grep (line 931 being the
additional `println!` dry-run path).

### T-4: Migrate `src/cli/issue/links.rs` (4 sites)

Lines (approximate):

| Line | Pattern |
|------|---------|
| 99 | `serde_json::to_string_pretty(&json_output::link_response(...))` |
| 197 | `serde_json::to_string_pretty(&json_output::unlink_response(false, 0))?` |
| 216 | `serde_json::to_string_pretty(&json_output::unlink_response(true, count))?` |
| 278 | `serde_json::to_string_pretty(&json_output::remote_link_response(...))` |

### T-2.5: Migrate `src/cli/project.rs` (1 compact Display site)

The `jr project fields --output json` arm uses a compact `serde_json::json!` Display
pattern (Adversarial Round 2 finding C-1/F-2; previously logged as CR-006 deferred).
Locate the arm in `src/cli/project.rs` (approximately lines 82-95 per F1 analysis;
verify before editing) and replace the compact `json!(...)` pattern with
`output::render_json(...)`. Add `use crate::output;` if absent.

Output format changes from compact single-line to pretty-printed multi-line. This is
the second intentional behavior change in this story (see Behavior-Change Disclosure).

### T-5: Migrate auth files (6 files, 1 site each)

| File | Line | Pattern |
|------|------|---------|
| `src/cli/auth/login.rs` | 334 | `serde_json::to_string_pretty(&auth_json_response(&target, "login"))` |
| `src/cli/auth/logout.rs` | 43 | `serde_json::to_string_pretty(&auth_json_response(&target, "logout"))` |
| `src/cli/auth/switch.rs` | 44 | `serde_json::to_string_pretty(&auth_json_response(target, "switch"))` |
| `src/cli/auth/remove.rs` | 122 | `serde_json::to_string_pretty(&auth_json_response(target, "remove"))` |
| `src/cli/auth/list.rs` | 51 | `Ok(serde_json::to_string_pretty(&arr)?)` in a fn returning `anyhow::Result<String>` |
| `src/cli/auth/refresh.rs` | 141 | `let payload = serde_json::to_string_pretty(&refresh_success_payload(flow))` |

For `auth/list.rs` line 51: the function returns `anyhow::Result<String>`, so:
```rust
// Before
Ok(serde_json::to_string_pretty(&arr)?)
// After
output::render_json(&arr)
```
(The `Ok(...)` wrapper is removed because `render_json` already returns `anyhow::Result<String>`.)

### T-6: Remove orphaned `serde_json` imports (if any)

After all substitutions, run `cargo clippy -- -D warnings`. If any file now has an
unused `use serde_json;` or unused `serde_json::` path at the import level, remove it.
In most files `serde_json` is used elsewhere (for type constructors, `json!` macro,
etc.) so imports will not become orphaned — but verify per file.

### T-7: Enumerate OutputFormat::Json arms, run full test suite, confirm green

```bash
# Step 1: Confirm zero bypass sites remain (see AC-002 enumeration-based method)
rg -n 'OutputFormat::Json' src/cli/   # enumerate all arms; verify each routes through render_json
grep -rn "serde_json::to_string_pretty" src/cli/   # must return 0 matches
rg -U 'serde_json::json!\(' src/cli/ | grep -v 'render_json'  # must return 0 matches

# Step 2: Full build and test
cargo test
cargo clippy -- -D warnings
cargo fmt --all -- --check
```

Record the total `OutputFormat::Json` arm count in the PR description. All must pass
with zero modifications to any test file. At most two snapshot files may be updated
(one for `handle_jsm_create`, one for `jr project fields --output json` — both
reflecting compact → pretty-printed format change).

## Previous Story Intelligence

N/A — this is the first story in its refactor mini-arc. Predecessor context from
F1 analysis: `src/cli/sprint.rs` already uses `output::render_json` at 3 sites (the
reference implementation); it should be used as a model for the import style and
call-site pattern.

## Architecture Compliance Rules

- **Pure/Effectful boundary:** `output::render_json` is a pure function (takes a
  `&T: Serialize`, returns `anyhow::Result<String>`). Callers are CLI handler
  functions (effectful). No boundary violation.
- **Module layering:** `src/output.rs` is the designated output-rendering module.
  CLI handlers (`src/cli/**`) already depend on it for `render_table` and
  `print_output`. Adding `render_json` imports follows the existing dependency direction.
- **No new modules.** No new files. No new public API surface. The helper already
  exists at `src/output.rs::render_json`.
- **Two intentional output changes.** `handle_jsm_create` (`src/cli/issue/create.rs`)
  and `jr project fields` (`src/cli/project.rs`) change from compact to pretty-printed
  JSON. Both are disclosed and expected. All `to_string_pretty` sites must produce
  byte-identical output — if any of those change even whitespace, revert and investigate.

## Library & Framework Requirements

No new dependencies. All existing:

| Crate | Version (from Cargo.toml) | Usage |
|-------|--------------------------|-------|
| `serde_json` | existing | `to_string_pretty` (inside `render_json`; no call-site change) |
| `anyhow` | existing | Error type for `render_json` return |
| `serde` | existing | `Serialize` bound on `render_json` |

Do NOT add any new `Cargo.toml` entries.

## File Structure Requirements

Files to MODIFY (10 files):

| File | Change |
|------|--------|
| `src/cli/issue/create.rs` | Replace 6 `serde_json::to_string_pretty` + 1 compact `serde_json::json!` Display site with `output::render_json`; add `use crate::output;` if absent |
| `src/cli/issue/workflow.rs` | Replace 8 sites; add import if absent |
| `src/cli/issue/links.rs` | Replace 4 sites; add import if absent |
| `src/cli/auth/login.rs` | Replace 1 site; add import if absent |
| `src/cli/auth/logout.rs` | Replace 1 site; add import if absent |
| `src/cli/auth/switch.rs` | Replace 1 site; add import if absent |
| `src/cli/auth/remove.rs` | Replace 1 site; add import if absent |
| `src/cli/auth/list.rs` | Replace 1 site; restructure `Ok(...)` wrapper |
| `src/cli/auth/refresh.rs` | Replace 1 site; add import if absent |
| `src/cli/project.rs` | Replace 1 compact `serde_json::json!` Display site (Adversarial Round 2 C-1/F-2; formerly CR-006 deferred); add import if absent |

Files explicitly NOT modified:
- `src/output.rs` — helper already exists; no changes needed
- `src/cache.rs` — non-output use of `serde_json::to_string_pretty`; out of scope
- `src/config.rs` — uses `toml::to_string_pretty`, not `serde_json`; out of scope
- `src/adf.rs` — test-only `serde_json::to_string_pretty` uses; out of scope
- Any test file — AC-003 requires zero test changes

## Token Budget Estimate

| Component | Estimated tokens |
|-----------|----------------|
| Story spec (this file) | ~4,000 |
| 10 CLI handler files (read + edit) | ~27,000 |
| `src/output.rs` (read for reference) | ~500 |
| Cargo.toml (verify no dep changes) | ~500 |
| Test run output (cargo test) | ~2,000 |
| Clippy/fmt output | ~500 |
| **Total estimate** | **~34,500** |

Well within a single agent context window (~200k tokens). No story split required.

## Out of Scope

The following are explicitly NOT in scope for this story:

- Any change to `src/output.rs` (the helper already exists)
- Any behavior change to JSON output format, field order, or content **except** the
  intentional compact → pretty-printed change at `handle_jsm_create` (disclosed above)
- Any new tests or test changes
- Migration of `to_string_pretty` in `src/cache.rs`, `src/config.rs`, or `src/adf.rs`
- Migration of `src/cli/sprint.rs` (already uses `render_json`)
- CR-006 ("accepted deviation" for `src/cli/project.rs`) — this is NO LONGER deferred; `project.rs` is migrated in this story (see T-2.5)
- Adding a `_meta` envelope or any other JSON transform (NFR-O-P; tracked separately)
- Syntax highlighting or colorized JSON output (separate feature)
- Any change to BC-7.4.013 through BC-7.4.016 (auth JSON shapes are unchanged)

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | `auth/list.rs` — function returns `anyhow::Result<String>` directly, currently wraps with `Ok(...)` | Replace `Ok(serde_json::to_string_pretty(&arr)?)` with `output::render_json(&arr)` — no `Ok()` wrapper needed since `render_json` already returns `anyhow::Result<String>` |
| EC-002 | Dry-run paths (`workflow.rs:931`, `create.rs:758`, `create.rs:1486`) use `println!("{}", ...)` pattern | Replace the inner `serde_json::to_string_pretty(&X)?` with `output::render_json(&X)?` |
| EC-003 | A file that currently imports `serde_json` only for `to_string_pretty` becomes import-orphaned | Remove the now-unused import to satisfy clippy `-D warnings` |
| EC-004 | Multi-line call sites (e.g., `links.rs:99`, `workflow.rs:1082`) span multiple lines | Preserve argument formatting; only the function name changes |

## Estimated Complexity

**2 story points.** The work is mechanical find-and-replace across 10 files (all
`to_string_pretty` sites + 2 compact `json!` Display sites, plus 10 potential import
adjustments). There is no algorithm design, no new test authoring. Two intentional
behavior changes: `handle_jsm_create` and `jr project fields` output format (compact →
pretty-printed). The primary risk is missing a site or introducing an unused-import
warning — both are caught by AC-002 (enumeration-based arm audit) and AC-004 (clippy).
