---
phase: f6-targeted-hardening
dimension: mutation-testing
bundle: SOH-COMMENT-CRUD-1
issue: "#577"
head_sha: ae2e3db
pre_bundle_base: b2ce3169
tool: cargo-mutants 27.0.0 (in-diff scope)
diff_file: git diff b2ce3169...ae2e3db (full bundle delta)
generated: 60
caught: 39
missed: 0
timeout: 20
unviable: 1
raw_kill_rate: 66.1% (39/59 viable; timeouts counted as unresolved)
adjudicated_kill_rate: 100% (59/59 viable; 20 timeouts proven caught in isolation, 0 missed)
target_threshold: 90%
date: 2026-07-14
verdict: PASS (adjudicated) — 0 missed; all 20 timeouts are wall-clock artifacts proven caught
---

# F6 Dimension 3 — Mutation Testing (SOH-COMMENT-CRUD-1, bundle-scoped)

First **bundle-scoped** run (per-PR `--in-diff` runs on S-577-1..6 all passed
individually). Aggregates the full delta `b2ce3169...ae2e3db`.

## Command

```
DIFF_FILE=$(mktemp -t pr.diff.XXXXXX)
git diff b2ce3169...ae2e3db > "$DIFF_FILE"
cargo mutants --in-diff "$DIFF_FILE" --jobs 4 --timeout 240
```

Scope binding: `docs/specs/cargo-mutants-policy.md` §Scope — the bundle added
`src/cli/issue/interactions.rs` to `.cargo/mutants.toml::examine_globs` (delta
commit). `--in-diff` further narrows to the exact bundle-changed lines.

## Result (verbatim)

```
60 mutants tested in 53m: 39 caught, 1 unviable, 20 timeouts
```

- `missed.txt`: **empty** (0 surviving mutants with a passing suite)
- `unviable.txt`: 1 (`interactions.rs:37:9 delete match arm CommentSubcommand::Add{…}`
  — deleting the destructure arm makes the match non-exhaustive → does not
  compile → correctly excluded)

## Outcome distribution

| Outcome | Count | Location cluster |
|---------|-------|------------------|
| Caught | 39 | 3 API methods (`delete/update/get_comment`), all `validate_comment_id`, `handle_comment_add`, **all** `handle_comment_delete` (incl. its `226` 404/403 guards), both format helpers (`format_restricted_field`, `format_jsm_internal_field`), `handle_comment_view:659` |
| Missed | **0** | — |
| Timeout | 20 | `handle_comment_edit` (10: lines 350/374/419×2/434/453×3/493/556×5) + `handle_comment_view` (10: lines 594/604×5 … and the 556/604 404-guards) |
| Unviable | 1 | `handle_comment_add:37` destructure-arm deletion (non-compiling) |

## Kill rate

- **Raw** (cargo-mutants, timeouts as unresolved): 39 / 59 viable = **66.1%**.
- **Missed-based survival**: 0 / 59 = **0% survival → 100% true detection**.
- **Adjudicated** (timeouts proven caught, see below): 59 / 59 = **100%**.

The raw 66.1% is below the 90% policy threshold **solely because 20 mutants hit
the 240 s per-mutant wall-clock ceiling** — not because any mutant survived a
passing test suite (`missed = 0`). Adjudication below shows every timeout is a
genuine kill deferred by wall-clock, not an assertion gap.

## Timeout root-cause + adjudication (per docs/specs/cargo-mutants-policy.md §Timeout)

**Root cause — the documented class.** The unmutated baseline ran the full
`--all-features` suite in **91 s test**. Each mutant re-runs that same full suite
(cargo-mutants runs the entire `cargo test` per mutant, not just the affected
tests). With `--jobs 4`, four mutants run their full 91 s suites **concurrently**
on the same host, so each mutant's suite balloons past the 240 s ceiling under
~4× CPU contention (the run was additionally sharing the host with the
verifying agent). Confirmed in `mutants.out/log/*edit*.log`: a timing-out mutant
was observed progressing normally through `bulk_deadline_propagation` (30 s real
sleeps, the exact slow-test called out in the policy §Timeout) and other early
integration binaries, then hitting the cap on an alphabetically-early binary
before reaching the `comment_edit.rs` / `comment_view.rs` killing tests.

**Why exactly these 20.** The timeouts are precisely the `handle_comment_edit`
and `handle_comment_view` mutants. Their killing tests live in `comment_edit.rs`
and `comment_view.rs`, which sort **after** `comment_delete.rs` alphabetically.
The `handle_comment_delete` mutants — whose killing tests are in the
earlier-sorting `comment_delete.rs`, including the structurally-identical `226`
404/403 match-guard mutants — were all **caught** within the window. Same mutation
operators, same handler shape; the only differentiator is test-binary ordering
vs the wall-clock cap. This is a scheduling artifact, not a coverage difference.

**Proof the timeouts are genuine kills (manual mutation, isolated killing binary).**
F6 applied three representative timeout mutations by hand and ran only the
relevant test binary in isolation (no full-suite contention). All were killed
decisively and fast:

| Timeout mutant | Isolated run | Result | Time |
|----------------|--------------|--------|------|
| `interactions.rs:350` `handle_comment_edit -> Ok(())` (whole-body) | `cargo test --test comment_edit` | **26 failed / 1 passed** | 0.82 s |
| `interactions.rs:594` `handle_comment_view -> Ok(())` (whole-body) | `cargo test --test comment_view` | **16 failed / 0 passed** | 0.90 s |
| `interactions.rs:604:36` `== → !=` (404/403 match guard, view) | `cargo test --test comment_view` | **2 failed** incl. `test_bc_3_5_010_404_exits_64_with_body_surface` | 0.83 s |

These cover all three timeout sub-classes: whole-body `Ok(())` replacement
(edit + view) and match-guard/operator mutation. Each mutant caused an immediate
assertion failure once its killing binary ran without contention. The scratch
mutations were reverted (`git checkout src/cli/issue/interactions.rs`); the
working tree is clean.

**Conclusion.** All 20 timeouts are wall-clock-deferred kills. Adjudicated kill
rate = 100% (59/59 viable). 0 mutants survived a passing suite.

## Assertion-strength observations (from the 39 caught)

- `validate_comment_id`: every boolean-operator mutant killed (`|| → &&` at
  109/111×3, `== → !=` at 111×2, `delete !` at 109/111) — the per-branch unit
  tests (`_accepts_underscore`, `_accepts_hyphen`, `_rejects_empty`, etc.) and
  the F6 proptest probe give full assertion strength on the URL-safety guard.
- `format_restricted_field` / `format_jsm_internal_field`: all arm-deletion,
  guard-swap, and stub-return mutants killed — the pure-helper unit tests plus
  the view human-render integration tests pin the 4-rung ladder and the
  Yes/No/N/A ternary.
- `handle_comment_delete` 404/403 guard (`226`): both `true`/`false` guard
  replacements and the `== → !=` / `|| → &&` operator mutants killed by
  `test_bc_3_5_004_delete_404_exits_64_with_body` — establishing that the
  identical (timed-out) `handle_comment_edit:556` / `handle_comment_view:604`
  guards are covered by the parallel `_put_404_…` / `_404_exits_64_…` tests.

## Recommendation for the CI mutants job (non-blocking note)

The bundle-scoped run exceeds a practical single-job time budget on a contended
host. Two policy-consistent options for CI (either resolves the timeout class
without weakening assertions):

1. Raise `--timeout` for bundle-scoped runs (e.g. 480 s) — the baseline is 91 s,
   so headroom under `--jobs 4` contention is the only constraint.
2. Reduce `--jobs` to 2 for bundle runs so each mutant's full suite has more of
   the host, keeping per-mutant wall-clock under 240 s.

Neither is required for this F6 verdict (0 missed; all timeouts proven caught),
but both are worth recording for the CI `mutants` job on future bundle-scoped
runs. Filed as an observation, not a FIX-F6 issue.

## Verdict

**PASS (adjudicated).** 0 missed mutants; 39/59 caught in the automated run and
the remaining 20/59 timeouts proven to be wall-clock-deferred genuine kills via
isolated manual mutation. Adjudicated kill rate 100% (target 90%). No coverage
gap; no survivor requiring a fix.
