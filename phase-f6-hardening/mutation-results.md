---
phase: f6-targeted-hardening
dimension: mutation-testing
bundle: S-FORK-OPS-BACKFILL
head_sha: 83a141ad
pre_bundle_base: 45ddf7a
tool: cargo-mutants --in-diff
verdict: PASS (no mutable production targets in-diff)
date: 2026-06-19
---

# F6 — Mutation Testing (in-diff scope)

## Verdict: PASS — no mutants generated (diff contains no production code)

## Command (per docs/specs/cargo-mutants-policy.md)

```
git diff 45ddf7a..HEAD > "$DIFF_FILE"   # 1037 lines
cargo mutants --in-diff "$DIFF_FILE" --jobs 4
```

## Result

```
INFO No mutants to filter
exit code: 0
```

## Interpretation

`cargo-mutants` mutates **production functions** within the in-diff line ranges. The in-diff scope intersected with the project's `examine_globs` (all under `src/`) yields **zero functions** because the diff touches no `src/` file. The 1037-line diff is entirely:

- `.github/workflows/backfill-release.yml` (YAML — not Rust, not examined)
- `tests/backfill_matrix_parity.rs` (a test file — cargo-mutants does not mutate test code)
- `docs/specs/fork-friendly-release-ops.md`, `CLAUDE.md` (docs)

`No mutants to filter` is the expected and correct outcome for a delta that contains no production code. Kill rate is therefore vacuously satisfied (0 mutants generated → 0 survivors → no threshold breach). No module-criticality threshold is engaged.

**PASS.**
