# PR Review — #617: `jr issue comment edit` core (S-577-4)

**Verdict:** APPROVE (no blocking findings)
**Branch:** `feat/comment-edit-core` → `develop`
**Diff:** 4 files, +1037 / −25 (`interactions.rs` handler, `tests/comment_edit.rs` NEW 13 tests, `.cargo/mutants.toml`, `CHANGELOG.md`)

## Verification against the review checkpoints

| # | Checkpoint | Result |
|---|------------|--------|
| 1 | Pipeline order (id → body source → empty guard → ADF → PUT → output) | PASS — matches docstring pin exactly |
| 2 | `changed_fields.body` carries raw pre-trim value | PASS — `let raw = body;` before trim; JSON emits `"body": raw`; ADF built from `trimmed`. AC-002 asserts both channels |
| 3 | 404/403 two-line preamble `comment not found or permission denied: KEY#ID\n<Jira error>` | PASS — verbatim `format!`; AC-010 pins both lines |
| 4 | File-not-found uses `ErrorKind::NotFound` matching (not blanket `map_err`) | PASS — closure matches NotFound only; other IO errors fall through `e.into()` (exit 1) |
| 5 | PUT uses `update_comment(key, id, adf_body, None)` (no `properties`) | PASS — AC-003 wire-asserts exactly one key `"body"` |
| 6 | 13 tests cover BC-3.5.005 / BC-3.5.009 | PASS — 13 test fns present, wire-level + mutation-kill coverage |

## Findings

### ADVISORY — 403 branch has no positive behavioral test
Category: test-coverage. The guard handles `*status == 404 || *status == 403`, but only 404 is asserted for the exit-64 + dual-line preamble path. The `== 403` mutant is incidentally killed by the 500 test (AC-013), yet no test confirms a real 403 response produces the preamble. A regression narrowing the guard to 404-only would still pass the suite.
Suggestion: add a 403 variant mirroring `test_bc_3_5_005_put_404_exits_64_with_dual_stderr`.

### ADVISORY — body-source precedence relies on out-of-diff clap guard
Category: coherence. Resolution is `--file` > `--stdin` > positional via an `else if` chain. Silent precedence is only safe if clap enforces mutual exclusion (PR cites S-577-1 AC-012, not visible in this diff). If that guard regresses, conflicting sources would be masked rather than rejected.
Suggestion: none required for this PR; note for S-577-5 regression coverage.

### NITPICK — `--markdown` tested only with positional text
Category: test-coverage. The modifier applies to any body source; no test exercises `--markdown` + `--file`/`--stdin`.

### NITPICK — mutants.toml entry fully removed
Category: coherence. The entire `exclude_re` block is deleted (not narrowed), consistent with S-577-4 being the last remaining `todo!()` stub. Remaining TOML verified valid.

## What was verified (no rubber-stamp)
- Pipeline ordering read line-by-line against the six-step docstring contract.
- Raw-echo vs trimmed-ADF asymmetry confirmed correct in both JSON and wire channels.
- NotFound remap confirmed scoped (permission-denied / is-a-directory propagate as exit 1).
- 404/403 re-wrap confirmed to preserve the original error for all non-404/403 statuses (`Err(e)`).
- Human-mode output confirmed on stderr with empty stdout (Symmetric profile); JSON mode routes through `output::render_json` (#526 invariant).

No correctness defects, no spec deviations, no missing changes in the diff.
