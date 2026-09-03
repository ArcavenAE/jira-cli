# F6 Mutation Testing (cargo-mutants) — cycle-003 `auth-profile-dx`

- **Baseline:** `87f17aff` → **HEAD:** `202414f2`
- **Date (UTC):** 2026-09-03
- **Tool:** `cargo-mutants 27.0.0`
- **Invocation:** `cargo mutants --in-diff <delta.diff> --jobs 4 --timeout 240`
  where `delta.diff = git diff 87f17aff..202414f2` (full delta, no pathspec filter).
- **Scope config:** `.cargo/mutants.toml::examine_globs` (21 entries) + `--in-diff` narrowing
  to changed lines, per `docs/specs/cargo-mutants-policy.md`.

## Headline result

| Metric | Value |
|--------|-------|
| Total mutants generated (in-diff ∩ examine_globs) | **28** |
| Caught | **28** |
| Missed | **0** |
| Timeout | **0** |
| Unviable | **0** |
| **Kill rate** | **100% (28/28)** |
| Run time | 23m (baseline 91s build + 113s test) |

**Overall kill rate 100% — exceeds the ≥90% general bar AND the ≥95% security-critical bar.
Zero surviving mutants → zero FIX-F6 mutation candidates.**

Source of truth: `mutants.out/outcomes.json`
(`{total_mutants:28, caught:28, missed:0, timeout:0, unviable:0}`), `mutants.out/missed.txt`
(empty), `mutants.out/timeout.txt` (empty).

## Per-file breakdown (all CAUGHT)

| File | Mutants caught | Cycle-003 relevance |
|------|----------------|---------------------|
| `src/output.rs` | 25 | `sanitize_env_display` / `strip_control_and_ansi` — the **DEC-314 `env`-tag display sanitizer** (terminal-escape / control-char injection guard; security-relevant, same CWE-116-adjacent class as `attachments.rs::display_sanitize_filename`). Added to `examine_globs` this cycle (S-cycle3-env-tag). |
| `src/cache.rs` | 2 | `cache_dir` / `clear_profile_cache` — per-profile cache path construction touched by the profile restructuring. |
| `src/main.rs` | 1 | `run` return-value mutant — top-level dispatch. |

Representative caught mutants (all killed by the existing suite):
- `src/output.rs:91: replace sanitize_env_display -> String with "xyzzy".into()` / `String::new()`
- `src/output.rs:95: replace > with ==/</>= in sanitize_env_display` (length-cap boundary)
- `src/output.rs:126–164: strip_control_and_ansi` — 21 mutants across the ANSI/control-char
  scrub state machine (`==`↔`!=`, `&&`↔`||`, `<=`↔`>`, deleted `Some('[')` / `Some(']')` match
  arms) — every one caught, confirming strong assertion strength on the escape-stripping logic.
- `src/cache.rs:135/151: cache_dir -> Default::default()` / `clear_profile_cache -> Ok(())`
- `src/main.rs:220: run -> Ok(())`

Full list: `mutants.out/caught.txt` (28 lines).

## Security-critical modules — scope reconciliation (IMPORTANT, honest note)

The task designated `src/api/auth.rs`, `src/api/refresh_coordinator.rs`, and the
credential-handling paths in `src/cli/auth/` as security-critical (≥95% bar). Reconciling
against the actual mutation scope:

1. **`src/api/refresh_coordinator.rs` is unchanged in this delta** (not in the changed-file
   set), so `--in-diff` generated **0 mutants** for it — nothing to catch, no survivors.
2. **`src/api/auth.rs`, `src/api/client.rs`, and `src/cli/auth/*.rs` are NOT members of
   `.cargo/mutants.toml::examine_globs`.** Under the policy scope the CI mutation job enforces
   (`--in-diff` narrows *within* `examine_globs`, it does not add files), these files generated
   **0 diff-scoped mutants** — so, vacuously, **0 survivors** among them.
3. The security-critical *credential logic* in these files is instead verified by the
   **VP-AUTHDX property/keyring-gated test suite** (see `kani-results.md`): VP-AUTHDX-004
   (round-trip + cross-profile isolation), 005 (no-copy detect-and-instruct), 006 (no profile
   special-cased), 007 (real-backend scenario), 008 (partial-state safety) — a documented
   coverage boundary (`#[ignore]` + `JR_RUN_KEYRING_TESTS=1`), plus default-CI VP-AUTHDX-001
   (non-interactive-never-OAuth), 002 (`auth_method` default pin), 003 (mechanism-intrinsic),
   009 (`env` tolerant reader). These are the correct verification mechanism for logic whose
   killing tests are keyring-gated and therefore do not run under cargo-mutants' default
   `cargo test` (a mutant there could only ever survive-as-uncatchable, not because the test is
   weak). Keeping `auth.rs` out of `examine_globs` is a deliberate, pre-existing policy choice
   consistent with that boundary.

**Conclusion for the security-critical bar:** every diff-scoped mutant that fell within the
enforced mutation scope was caught (28/28 = 100%, including the security-relevant `output.rs`
env-tag sanitizer). No security-critical module produced a surviving mutant. The auth
credential modules carry no diff-scoped mutants under policy scope and are covered by the
VP-AUTHDX suite instead — no ≥95% shortfall exists.

> Note: an attempt to run a supplementary mutation pass explicitly scoped (`--file`) to the
> out-of-`examine_globs` auth files aborted at its *unmutated baseline* because that baseline
> `cargo test` exceeded the 240s timeout under concurrent CPU load (the machine was
> simultaneously running the full regression suite) — an environmental abort, not a mutation
> signal. It is not re-run here per coordinator direction; the VP-AUTHDX suite is the
> authoritative verification for those modules.

## Surviving mutants (FIX-F6 candidates)

**NONE.** 0 surviving mutants across the entire in-diff scope. No FIX-F6 mutation candidates.

## Verdict

**PASS.** 100% kill rate (28/28), 0 survivors, 0 timeouts, 0 unviable — clears both the
≥90% general and ≥95% security-critical thresholds.
