---
phase: f6-targeted-hardening
dimension: fuzz-testing
bundle: SOH-COMMENT-CRUD-1
issue: "#577"
head_sha: ae2e3db
pre_bundle_base: b2ce3169
tool: none (justified skip — project precedent) + transient proptest probe on delta pure fns
date: 2026-07-14
verdict: PASS (justified skip + delta probe clean)
---

# F6 Dimension 2 — Fuzz Testing (SOH-COMMENT-CRUD-1)

## No cargo-fuzz setup exists in this repo

```
$ ls fuzz/ 2>/dev/null || echo "no fuzz dir"
no fuzz dir
```

There is no `fuzz/` directory, no `cargo fuzz` target, and no cargo-fuzz
setup anywhere in the repo. This matches the established precedent for every
prior F6 cycle (ADF-CODE-MARK-EXCLUSIVITY #571, issue-407, issue-483,
issue-474, S-FORK-OPS-BACKFILL): the project uses proptest at elevated case
counts as its fuzz substitute rather than introducing a new toolchain
mid-cycle.

## Delta fuzz-surface assessment

The bundle delta touches two production files, `src/cli/issue/interactions.rs`
(the four comment handlers + `validate_comment_id` + two format helpers) and
`src/api/jira/issues.rs` (`delete_comment` / `update_comment` / `get_comment`),
plus the `src/main.rs` `try_parse` intercept and the `JR_STDIN_IS_TTY` seam.

### ADF parser paths are REUSED, not modified (cited, not re-fuzzed)

```
$ git diff b2ce3169...ae2e3db --stat -- src/adf.rs
(empty — src/adf.rs is unchanged in the bundle)
```

The comment handlers call `adf::markdown_to_adf`, `adf::text_to_adf`, and
`adf::adf_to_text` unchanged. These are the highest fuzz-value functions in
the codebase and are already covered by:

- 10 existing proptests in `src/adf.rs::tests` (`grep -c 'proptest!\|fn prop_'`
  → 10), exercising `markdown_to_adf` / `adf_to_text` / `text_to_adf` over
  randomized nested-container / task-list / CR-LF / mark-composition inputs.
- The `MAX_ADF_DEPTH = 256` recursion guard (BC-7.2.012, SEC-001, CWE-674) on
  both the forward and reverse paths — pathological nesting exits 64 rather
  than stack-overflowing.

The delta introduces **no new ADF surface** and no new panic/crash path in the
parser. Re-fuzzing the parser here would only re-exercise coverage that is
already green in the full-regression pass. The EC-3.5.010-2(a) depth-error
propagation into `handle_comment_view` is directly unit-tested
(`test_bc_3_5_010_ec2a_adf_error_propagates_exit64`, builds a 257-deep node).

### New pure functions — transient proptest probe (this F6)

The three new pure functions are the delta's genuinely new fuzz surface:
`validate_comment_id`, `format_restricted_field`, `format_jsm_internal_field`.
They already carry targeted unit tests, but F6 added a **transient** proptest
probe (added to `interactions.rs::tests`, run, then reverted — NOT committed to
the product tree) to confirm totality and the security invariant at scale.

Command:

```
cargo test --lib f6probe   # 6 properties, ProptestConfig::with_cases(4000)
```

Result: **6 passed / 0 failed** at 4,000 generator cases each.

| Probe property | Target | Result |
|----------------|--------|--------|
| `f6probe_validate_id_accepts_only_url_safe` | Every id `validate_comment_id` **accepts** contains only `[0-9A-Za-z_-]` and none of `/ ? # % . space \ & : @` (URL-path-safety / injection invariant) | PASS |
| `f6probe_validate_id_never_panics` | Total over arbitrary Unicode strings (`\PC*`) | PASS |
| `f6probe_jsm_internal_total` | Returns exactly one of `"Yes"/"No"/"N/A"` over arbitrary property arrays (bool + stringly-typed variants) | PASS |
| `f6probe_jsm_internal_non_array` | Total on non-array / null / scalar inputs → `"N/A"` | PASS |
| `f6probe_restricted_total` | Never returns empty string over arbitrary `{type,value,identifier}` string triples | PASS |
| `f6probe_restricted_wrong_types` | Tolerates absent keys / null / numeric-typed fields without panic | PASS |

The security-critical property is the first one: it proves that no input
`validate_comment_id` accepts can carry a path-traversal (`.`, `/`), query
(`?`, `&`), fragment (`#`), or percent-encoding (`%`) metacharacter into the
raw-interpolated URL path segment in `delete_comment`/`update_comment`/
`get_comment`. This is the runtime backstop for the CWE-1283/CWE-20 precondition
those API methods document.

Scratch-test discipline: the probe was added inside the existing
`#[cfg(test)] mod tests` block, run via `cargo test --lib f6probe`, and removed
with `git checkout src/cli/issue/interactions.rs`. Working tree is clean
(`git diff --stat src/cli/issue/interactions.rs` → empty). Nothing was
committed.

## No new crash / panic / I/O surface added by the delta

- **No new `unsafe`**: `grep -nE '\bunsafe\b' src/cli/issue/interactions.rs` → 0.
- **No new `unwrap`/`expect`/`panic!`/`todo!`** in non-test code. Two
  `unreachable!()` arms exist (`handle_comment_add`/`handle_comment_edit`
  variant destructure) but are provably unreachable — the `mod.rs` dispatch
  routes only the `Add` variant to `handle_comment_add` and only the `Edit`
  variant to `handle_comment_edit`.
- **I/O surface**: stdin reads use `tokio::task::spawn_blocking` (runtime-safe);
  file reads use `std::fs::read_to_string` with a `NotFound → exit 64` remap and
  other IO errors propagated. Standard CLI file-read behavior; no new network
  primitive (the three API methods reuse the existing `JiraClient` get/put/delete
  plumbing).

## Verdict

**PASS (justified skip)** — no cargo-fuzz setup exists (project precedent); the
delta's only new fuzz surface (three pure helpers) was probed at 4,000
proptest cases with the URL-safety security invariant holding; the reused ADF
parser paths are covered by 10 existing proptests + the depth guard and were
not modified by the delta.
