---
document_type: story
story_id: "S-525"
title: "Add anti-stall guard to list_comments pagination; align cache write-error model (CR-001, CR-007, issue #525)"
wave: feature-followup
status: ready
intent: bug-fix
feature_type: fix
scope: standard
severity: medium
trivial_scope: false
issue: 525
points: 3
priority: medium
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: api
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  - BC-2.4.043
bcs:
  - BC-2.4.043
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: ".factory/phase-f1-delta-analysis/bundle-c-2026-06-17.md §CR-001, §CR-007"
implementation_strategy: tdd
module_criticality: MEDIUM
files_modified:
  - src/api/jira/issues.rs          # list_comments: add if next_start_at <= start_at { return Err(...) } guard + conditional advance
  - src/cache.rs                    # write_object_type_attr_cache + write_cmdb_fields_cache: propagate (model-a) → swallow+warn (model-b); add rustdoc
  - src/api/assets/objects.rs       # remove let _ = at write_object_type_attr_cache call site; replace with .ok() (now infallible — Err swallowed inside writer)
  - src/api/assets/linked.rs        # remove let _ = at write_cmdb_fields_cache call site; replace with .ok() (now infallible)
  - CLAUDE.md                       # add two Gotchas entries documenting model-b behavior of write_object_type_attr_cache and write_cmdb_fields_cache
  - tests/comments.rs               # add test_list_comments_stall_guard_returns_error_when_start_at_does_not_advance and normal-advance test
files_created:
  - (new tests in existing files; no new source files)
breaking_change: false
assumption_validations: []
risk_mitigations: []
created: "2026-06-17"
last_updated: "2026-06-17"
retroactive: false
---

# S-525 — Add anti-stall guard to `list_comments` pagination; align cache write-error model (CR-001, CR-007)

## F2 Spec Note

**CR-001 (BC-2.4.043):** New behavioral sub-contract. `list_comments` in
`src/api/jira/issues.rs` is the only offset-paginated loop without a stall guard.
All other offset-pagination functions either use a fixed-advance pattern or already
carry the guard (reference: `get_changelog::if next <= start_at { return Err }`).

**CR-007:** Convention-governed. No new BC. The two-model policy is documented in
CLAUDE.md Gotchas (cache-write error handling) and in the `write_fields_cache` and
`write_request_type_cache` rustdoc. `write_object_type_attr_cache` and
`write_cmdb_fields_cache` are model (a) writers today — they propagate `?`. Their
only call sites already silence errors with `let _ =`, creating a documentation
mismatch. Converting to model (b) (swallow + warn) makes the writer self-documenting
and removes the need for call-site `let _ =` suppression.

## Source of Truth

F1 delta analysis: `.factory/phase-f1-delta-analysis/bundle-c-2026-06-17.md §CR-001`
and `§CR-007`

Governing BC (CR-001): `.factory/specs/prd/bc-2-issue-read.md §BC-2.4.043`

Reference guard implementation: `src/api/jira/issues.rs::get_changelog`
(lines ~620–628)

Reference model-b writer: `src/cache.rs::write_fields_cache` (lines ~337–350)
and `src/cache.rs::write_request_type_cache` (lines ~483+)

## Summary

Two co-located fixes shipped in one PR:

**CR-001 — anti-stall guard for `list_comments`:** Insert a non-advancing-offset
check inside `list_comments` in `src/api/jira/issues.rs`. After fetching each page
(and before advancing `start_at`), if `next_start_at <= start_at`, return
`Err(anyhow::anyhow!("Jira comment pagination did not advance (startAt {} → {}) — aborting to prevent infinite loop", start_at, next_start_at))`.
Advance `start_at` only when `next_start_at > start_at`. This mirrors `get_changelog`
exactly. F1 sibling analysis confirmed `list_comments` is the only vulnerable
offset-pagination loop.

**CR-007 — cache-write model alignment:** Convert `write_object_type_attr_cache`
(in `src/cache.rs`) and `write_cmdb_fields_cache` (in `src/cache.rs`) from propagate
(model a) to swallow+warn (model b). Add rustdoc to each writer documenting the
chosen model, mirroring `write_fields_cache`. Remove the now-redundant `let _ =`
suppressions at call sites in `src/api/assets/objects.rs` (line 189) and
`src/api/assets/linked.rs` (line 34); after the writer change these calls use
`.ok()` — the canonical, warning-free idiom for discarding a `Result<()>` on a
now-infallible model-b writer. Also add CLAUDE.md Gotchas entries for both writers
documenting their model-b behavior and the `.ok()` call-site convention.

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-2.4.043 | After each page fetch inside `list_comments`, if `next_start_at <= start_at`, return `Err(…"aborting to prevent infinite loop"…)`. `start_at` advances only when `next_start_at > start_at`. |

**CR-007 note:** Convention-governed by the two-model cache-write policy (see CLAUDE.md
Gotchas "Cache-write error handling — two models"). No BC number.

## Story Narrative

As a `jr` CLI user issuing `jr issue comments <KEY>` on an issue with many pages of
comments, I want the command to fail with a clear error rather than hang forever if
the Jira API returns a malformed pagination response that never advances the comment
offset, so that `jr` does not stall my terminal or consume unbounded memory.

As a maintainer, I want `write_object_type_attr_cache` and `write_cmdb_fields_cache`
to be self-documenting model-b (swallow+warn) writers so that call sites do not need
`let _ =` suppression and code readers can understand the error-handling intent from
the writer's rustdoc alone.

## Acceptance Criteria

### AC-001 — `list_comments` aborts with Err on non-advancing offset (traces to BC-2.4.043 postcondition)

`list_comments` in `src/api/jira/issues.rs` MUST, on every loop iteration after
fetching a page with `has_more = true`, check whether `next_start_at <= start_at`. If
the condition is true, the function MUST return:

```
Err(anyhow::anyhow!(
    "Jira comment pagination did not advance (startAt {} → {}) — aborting to prevent infinite loop",
    start_at,
    next_start_at
))
```

`start_at` MUST only be assigned `next_start_at` when `next_start_at > start_at` (the
guard fires before the assignment). The guard MUST be evaluated after collecting the
page's comments but before the next iteration fetch. The guard wording MUST NOT include
any JRACLOUD-NNNNN issue number.

The guard structure must mirror `get_changelog`:
```
if next_start_at <= start_at {
    return Err(anyhow::anyhow!("Jira comment pagination did not advance (startAt {} → {}) — aborting to prevent infinite loop", start_at, next_start_at));
}
start_at = next_start_at;
```

The `limit`-capping path (where `all.len() >= cap`) continues to `break` before the
guard — the guard is only reached when `has_more = true` and the cap has not been hit.

### AC-002 — Wiremock tests verify guard fires and normal pagination still works (traces to BC-2.4.043 precondition + postcondition)

Two new tests added to `tests/comments.rs`:

**Test 1 — stall guard:** `test_list_comments_stall_guard_returns_error_when_start_at_does_not_advance`
- Wiremock stub: `GET /rest/api/3/issue/TEST-1/comment?startAt=0&*` returns a response
  with `startAt: 0`, `maxResults: 100`, `total: 200`, `isLast: false` (or equivalent
  `has_more = true`), and a non-empty `comments` array (e.g., one comment). This
  simulates a non-advancing offset scenario.
- The second page request (if any) MUST NOT be reached — the guard fires after page 1.
- Assert: `list_comments("TEST-1", None)` returns `Err(e)` where
  `e.to_string().contains("aborting to prevent infinite loop")`.
- Assert: the result is `Err`, not `Ok`.

**Test 2 — normal pagination:** `test_list_comments_paginates_correctly_when_offset_advances`
(may already exist as `list_comments_paginated` — if so, verify it covers the
post-guard code path; add a new test only if coverage is absent)
- Wiremock: page 1 returns `startAt: 0, total: 2, comments: [c1]`, page 2 returns
  `startAt: 1, total: 2, comments: [c2]`, second page `isLast: true`.
- Assert: `list_comments("TEST-1", None)` returns `Ok([c1, c2])`.

Both tests use `JiraClient::new_for_test(base_url, auth_header)` per the existing
pattern in `tests/comments.rs`.

### AC-003 — `write_object_type_attr_cache` and `write_cmdb_fields_cache` converted to model-b (convention-governed, no BC)

**`src/cache.rs::write_object_type_attr_cache`:**
- Body changed: wrap the existing `write` logic in an `if let Err(e) = { ... }` block
  and emit `eprintln!("warning: failed to write object_type_attrs cache: {e}")` on
  error; return `Ok(())` unconditionally.
- Rustdoc added: "Best-effort writer: swallows disk-write errors with `eprintln!` and
  returns `Ok(())`. A missed write costs at most one extra HTTP call on the next
  invocation. Cache write failures MUST NOT break a successful API call. Chosen model:
  (b) swallow + warn — this cache is a read-acceleration shortcut, not a
  correctness-critical store."
- Call site `src/api/assets/objects.rs:189`: remove `let _ =`; replace with
  `cache::write_object_type_attr_cache(profile, type_id, &cached).ok();` — `.ok()`
  is the canonical, warning-free idiom (Err swallowed inside the model-b writer;
  `.ok()` on the `Result<()>` discard is idiomatic and clippy-clean).

**`src/cache.rs::write_cmdb_fields_cache`:**
- Same model-b conversion: wrap existing propagate logic in error-check arm; emit
  `eprintln!("warning: failed to write cmdb_fields cache: {e}")` on error; return
  `Ok(())` unconditionally.
- Rustdoc added (mirroring `write_fields_cache` and the `write_object_type_attr_cache`
  rustdoc above).
- Call site `src/api/assets/linked.rs:34`: remove `let _ =`; replace with
  `cache::write_cmdb_fields_cache(profile, &fields).ok();` — same `.ok()` idiom.

**New tests** in `tests/cache.rs` (or inline in `src/cache.rs` test module):
- `test_write_object_type_attr_cache_swallow_io_error_returns_ok`: use a read-only or
  non-existent directory path to trigger a write failure; assert the function returns
  `Ok(())` and does NOT panic.
- `test_write_cmdb_fields_cache_swallow_io_error_returns_ok`: same pattern for
  `write_cmdb_fields_cache`.

Both tests mirror the existing `write_request_type_cache` swallow test pattern (see
`src/cache.rs` tests at lines 1548–1549).

### AC-004 — Full regression green; clippy and fmt clean

`cargo test` passes with all existing tests plus the new tests. `cargo clippy --
-D warnings` emits zero warnings. `cargo fmt --all -- --check` is clean. No existing
test logic is modified.

## Tasks

### T-1: Add stall guard to `list_comments` in `src/api/jira/issues.rs`

Locate `list_comments` (approximately lines 636–674 at time of analysis). The loop
currently ends with:
```rust
if !has_more {
    break;
}
start_at = next;
```

Change to:
```rust
if !has_more {
    break;
}
if next <= start_at {
    return Err(anyhow::anyhow!(
        "Jira comment pagination did not advance (startAt {} → {}) — aborting to prevent infinite loop",
        start_at,
        next
    ));
}
start_at = next;
```

Where `next` is the existing variable holding `page.next_start()`. Variable names must
match what is already in scope. The guard fires only when `has_more = true`; if
`has_more = false` the `break` exits before reaching the guard.

### T-2: Add wiremock tests in `tests/comments.rs`

**Test 1 (stall guard fires):**

```rust
#[tokio::test]
async fn test_list_comments_stall_guard_returns_error_when_start_at_does_not_advance() {
    // Stub: page returns has_more=true but startAt stays at 0
    // Assert: Err containing "aborting to prevent infinite loop"
}
```

Use `wiremock::MockServer::start().await` + `Mock::given(method("GET"))...respond_with(...)`.
The response body must set `total > len(comments)` and `startAt: 0` so `next_start` == 0
== `start_at` (triggers the guard). One comment in the response array is sufficient.

**Test 2 (normal multi-page advance):**

Check whether `list_comments_paginated` (line 105 in `tests/comments.rs`) already
covers a two-page advance scenario that exercises the post-guard code path. If yes,
no second new test is required and this step is a verification only. If the existing
test uses a limit path that bypasses `has_more`, add:

```rust
#[tokio::test]
async fn test_list_comments_paginates_correctly_when_offset_advances() {
    // Two pages, first has startAt=0/total=2/isLast=false, second has startAt=1/isLast=true
    // Assert: Ok([c1, c2])
}
```

### T-3: Convert `write_object_type_attr_cache` in `src/cache.rs` to model-b

Current body (approximately lines 406–442):
- Reads existing cache file (may fail gracefully already on read)
- Inserts new entry
- `let content = serde_json::to_string_pretty(&cache)?;`
- `std::fs::write(&path, content)?;`
- `Ok(())`

Change the fallible final two lines from direct propagation to wrapped check:
```rust
let result = (|| -> Result<()> {
    let content = serde_json::to_string_pretty(&cache)?;
    std::fs::write(&path, content)?;
    Ok(())
})();
if let Err(e) = result {
    eprintln!("warning: failed to write object_type_attrs cache: {e}");
}
Ok(())
```

Or use the identical pattern as `write_fields_cache`:
```rust
let result = write_cache(profile, "object_type_attrs.json", &cache);
if let Err(e) = result {
    eprintln!("warning: failed to write object_type_attrs cache: {e}");
}
Ok(())
```

Note: `write_object_type_attr_cache` does NOT use the generic `write_cache` helper
(it manually manages a per-object-type map merge). The closure-based pattern is safer
than refactoring to use `write_cache`.

Add rustdoc above the function signature.

### T-4: Convert `write_cmdb_fields_cache` in `src/cache.rs` to model-b

Current body (approximately lines 294–303): calls `write_cache(...)` and propagates
via implicit `?`-less return. Change to:
```rust
pub fn write_cmdb_fields_cache(profile: &str, fields: &[(String, String)]) -> Result<()> {
    let result = write_cache(
        profile,
        "cmdb_fields.json",
        &CmdbFieldsCache {
            fields: fields.to_vec(),
            fetched_at: Utc::now(),
        },
    );
    if let Err(e) = result {
        eprintln!("warning: failed to write cmdb_fields cache: {e}");
    }
    Ok(())
}
```

Add rustdoc above the function signature.

### T-5: Remove `let _ =` suppressions at call sites

`src/api/assets/objects.rs:189`:
```rust
// Before
let _ = cache::write_object_type_attr_cache(profile, type_id, &cached);
// After
cache::write_object_type_attr_cache(profile, type_id, &cached).ok();
```

`src/api/assets/linked.rs:34`:
```rust
// Before
let _ = cache::write_cmdb_fields_cache(profile, &fields);
// After
cache::write_cmdb_fields_cache(profile, &fields).ok();
```

### T-6: Add swallow-behavior tests in `tests/cache.rs` (or `src/cache.rs` inline tests)

Locate the test module in `src/cache.rs` (or `tests/cache.rs` if integration-style).
The existing `write_request_type_cache` tests at lines 1548–1549 call the function
with valid paths — these are NOT the swallow tests. For swallow behavior:

```rust
#[test]
fn test_write_object_type_attr_cache_swallow_io_error_returns_ok() {
    // Create a path that will fail: a directory where a file should be, or a read-only path
    // Assert: write_object_type_attr_cache(profile, type_id, &[]) returns Ok(())
    // Hint: use a TempDir-based approach with JR_CACHE_DIR seam (debug build only)
    //       or test a path directly by calling write_object_type_attr_cache with a
    //       profile that maps to a non-writable cache dir.
}
```

If the cache path override seam (`JR_CACHE_DIR`) is not usable in unit tests (it's
debug-only via the env override), use a direct path: construct the cache path manually
and confirm the writer returns `Ok(())` even when the write fails. See
`src/cache.rs::tests` for the pattern used with `TempDir` at lines 1032, 1095–1096.

### T-7: Add CLAUDE.md Gotchas entries

Add two new entries in the "Gotchas" section of `CLAUDE.md` (after the existing
cache-write two-model entry):

- `write_object_type_attr_cache` (`src/cache.rs`): model-b writer — swallows disk
  errors with `eprintln!("warning: …")` and returns `Ok(())`. Its call site in
  `src/api/assets/objects.rs` does NOT use `let _ =`; errors are absorbed inside
  the writer. Do not re-introduce `let _ =` or `?` at the call site.
- `write_cmdb_fields_cache` (`src/cache.rs`): same model-b convention. Call site in
  `src/api/assets/linked.rs` does NOT use `let _ =`.

### T-8: Run full test suite and quality gates

```bash
cargo test
cargo clippy -- -D warnings
cargo fmt --all -- --check
```

All must pass. The new tests (T-2 stall guard + T-6 swallow behavior) must be green.
No existing test logic changed.

## Previous Story Intelligence

N/A — first story in Bundle C delivery. No predecessor stories in this mini-arc.

Predecessor context from F1 analysis:
- `get_changelog` (same file, `src/api/jira/issues.rs`) is the reference guard
  implementation. Copy its guard structure verbatim — do not invent a new pattern.
- `write_fields_cache` and `write_request_type_cache` (in `src/cache.rs`) are the
  reference model-b writers. Mirror their rustdoc and their `if let Err(e) = result {
  eprintln!(...) }` pattern exactly.
- F1 analysis confirmed only `list_comments` is vulnerable among offset-paginated
  loops (boards, sprints, queues are bounded by known totals or have implicit advance
  guarantees). Do NOT add guards to other loops in this story.

## Architecture Compliance Rules

- **Pure/Effectful boundary:** `list_comments` is an effectful function (async HTTP).
  The guard is a pure check (`if next <= start_at`) inserted before a state mutation
  (`start_at = next`). No boundary violation.
- **Module layering:** `src/cache.rs` is the designated cache layer; `src/api/assets/`
  depends on it. Converting writers to model-b does not change the dependency direction.
- **No new modules.** No new files (apart from test additions within existing files).
  No new public API surface.
- **Error wording constraint:** The error message from the guard MUST NOT contain any
  `JRACLOUD-NNNNN` issue number. Use the generic wording:
  `"Jira comment pagination did not advance (startAt {} → {}) — aborting to prevent infinite loop"`.
  This is BC-2.4.043's normative wording (verbatim from `.factory/specs/prd/bc-2-issue-read.md`).
- **Cache-write model symmetry:** Both converted writers must match the `write_fields_cache`
  pattern (lines 337–350 in `src/cache.rs`) exactly. Do not introduce a third pattern.
- **No new `Cargo.toml` entries.** All dependencies already present.

## Library & Framework Requirements

No new dependencies. All existing:

| Crate | Version (from Cargo.toml) | Usage |
|-------|--------------------------|-------|
| `anyhow` | existing | `anyhow::anyhow!(...)` for the guard Err |
| `wiremock` | dev-dependency, existing | new stall-guard test in `tests/comments.rs` |
| `tokio` | dev-dependency, existing | `#[tokio::test]` async test runtime |
| `serde_json` | existing | cache serialization (unchanged) |

Do NOT add any new `Cargo.toml` entries.

## File Structure Requirements

Files to MODIFY (5 files):

| File | Change |
|------|--------|
| `src/api/jira/issues.rs` | Add stall guard in `list_comments` loop body (3–6 lines) |
| `src/cache.rs` | Convert `write_object_type_attr_cache` and `write_cmdb_fields_cache` to model-b; add rustdoc to each |
| `src/api/assets/objects.rs` | Remove `let _ =` at `write_object_type_attr_cache` call site (line ~189) |
| `src/api/assets/linked.rs` | Remove `let _ =` at `write_cmdb_fields_cache` call site (line ~34) |
| `CLAUDE.md` | Add two Gotchas entries for model-b writers |

Files to ADD TESTS to (existing test files):

| File | New Tests |
|------|-----------|
| `tests/comments.rs` | `test_list_comments_stall_guard_returns_error_when_start_at_does_not_advance` (required); normal-advance test (if not already covered) |
| `src/cache.rs` (inline tests) or `tests/cache.rs` | `test_write_object_type_attr_cache_swallow_io_error_returns_ok`, `test_write_cmdb_fields_cache_swallow_io_error_returns_ok` |

Files explicitly NOT modified:
- `src/api/jira/issues.rs` functions other than `list_comments`
- Any other paginator (`get_changelog`, `search_issues`, `search_issue_keys`,
  `list_boards`, `list_sprints`, queue paginators)
- Cache TTL values or cache struct shapes
- Any test file logic OTHER than adding the new tests listed above

## Token Budget Estimate

| Component | Estimated tokens |
|-----------|----------------|
| Story spec (this file) | ~5,000 |
| `src/api/jira/issues.rs` (read + edit, ~700 LOC) | ~7,000 |
| `src/cache.rs` (read relevant sections + edit, ~450 LOC in scope) | ~5,000 |
| `src/api/assets/objects.rs` (read + 1-line edit) | ~2,500 |
| `src/api/assets/linked.rs` (read + 1-line edit) | ~1,000 |
| `tests/comments.rs` (read + add 1–2 tests, ~400 LOC existing) | ~4,000 |
| `tests/cache.rs` or inline tests (read + add 2 tests) | ~2,000 |
| `CLAUDE.md` (read Gotchas section + add 2 entries) | ~2,000 |
| Test run output (`cargo test`) | ~2,000 |
| Clippy/fmt output | ~500 |
| **Total estimate** | **~31,000** |

Well within a single agent context window. No story split required.

## Out of Scope

- Anti-stall guards for boards, sprints, queue, or other paginated loops — F1 analysis
  confirmed they are either bounded or use a fixed-advance pattern with no reported
  stalls. Adding guards to them in this story would be untargeted scope creep.
- Any change to cursor-based paginators (`search_issues`, `search_issue_keys`) — those
  use the JRACLOUD-95368 repeated-token guard (BC-2.6.050, BC-2.6.051), not the
  offset-advance guard.
- Cache TTL changes, cache struct shape changes, or cache format version bump.
- Any change to `write_fields_cache` or `write_request_type_cache` — those are already
  model-b writers (reference implementations, not targets).
- The `write_object_type_attr_cache` read-fail path (already handles gracefully with
  `unwrap_or_else` — this is not a model-b conversion issue).
- Adding `write_object_type_attr_cache` to `write_cache` generic helper — the function
  manages a per-key map merge that is not compatible with the generic helper.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | Server returns `has_more = true` with `next_start_at == start_at` (zero advance) | Guard fires; `Err("…aborting to prevent infinite loop")` returned |
| EC-002 | Server returns `has_more = true` with `next_start_at < start_at` (regression — offset went backwards) | Same `Err` path (guard is `<=`, covers both zero and negative advance) |
| EC-003 | Final page with `has_more = false` | Loop exits via `break` before guard is evaluated; `Ok(all)` returned |
| EC-004 | `list_comments` with `limit` cap hit exactly on page boundary | `break` via limit-cap path before guard; `Ok(truncated)` returned |
| EC-005 | `write_object_type_attr_cache` fails due to disk-full | `eprintln!("warning: failed to write object_type_attrs cache: {e}")` emitted; `Ok(())` returned; calling code in `objects.rs` continues normally |
| EC-006 | `write_cmdb_fields_cache` fails due to read-only directory | `eprintln!("warning: failed to write cmdb_fields cache: {e}")` emitted; `Ok(())` returned; `get_or_fetch_cmdb_fields` returns the field list normally |
| EC-007 | `write_object_type_attr_cache` called when existing cache file is unreadable | Read failure already handled by `unwrap_or_else` (starts fresh); write then proceeds; model-b conversion only affects the final write step |

## Estimated Complexity

**3 story points.** CR-001 requires a 3-line guard insertion plus one new wiremock
test (moderate: need to construct a non-advancing pagination response). CR-007 is a
3-line body change per writer plus call-site `let _ =` removal and two new swallow
behavior tests. The CLAUDE.md documentation is straightforward. Primary risks: the
wiremock test must correctly construct a non-advancing offset response (verify the
field names `startAt`/`total`/`isLast` match what `OffsetPage<Comment>` deserializes
from) and the model-b closure pattern for `write_object_type_attr_cache` must not
introduce unintended behavior changes for the read path.
