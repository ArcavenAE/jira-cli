# F6 Targeted Hardening — Record (LIGHT)

- **Cycle:** cycle-009 (`jql-relative-date-units`)
- **Phase:** F6 targeted hardening — LIGHT scope per the F1/F2 decision (small pure-function
  validation change, not a new subsystem).
- **Scope:** cycle-009 code delta `bcec4c78`..`805ca0e0` (3 merged commits: `1847ce38` #868
  `fix(jql): reject unsupported relative-date units M/y`, `74abc573` #869 docs supersession
  markers, `805ca0e0` #870 F5 `test(jql): DRY validate_duration error string + hygiene fixes`).
  Code footprint: `src/jql.rs` (`validate_duration` unit-set narrowed to `{w,d,h,m}` + new
  `invalid_duration_error` helper) and `src/cli/mod.rs` (help-text `2M` → `12h`).
- **Local `develop` tip at run time:** `805ca0e0` (contains the full merged cycle-009 change).
- **Date:** 2026-09-22
- **Verdict: HARDENED_WITH_RESIDUALS** — no BLOCKING findings; one MEDIUM policy/tooling residual
  (examine_globs gap for `src/jql.rs`), consistent with the cycle-008
  `CYCLE-008-F6-MUTANTS-EXAMINE-GLOBS-GAP` closure precedent.

## Per-check results

| Check | Verdict | Detail |
|-------|---------|--------|
| Mutation — CI-prescribed `--in-diff` (config `examine_globs`) | **0 mutants generated** (false green) | `git diff bcec4c78..805ca0e0 -- src/ > $DIFF && cargo mutants --in-diff $DIFF --jobs 4 --timeout 240` → `INFO No mutants to filter`, exit 0. Neither changed file (`src/jql.rs`, `src/cli/mod.rs`) is in `.cargo/mutants.toml`'s `examine_globs`, so the standing CI mutation gate structurally generates **zero** mutants for this delta. Same class as `CYCLE-008-F6-MUTANTS-EXAMINE-GLOBS-GAP`. Recorded, not silently passed over → see Residual R1. |
| Mutation — delta, out-of-band override (`--config` + `--in-diff`) | **9/9 CAUGHT = 100%** | Temp override config (`examine_globs = ["src/jql.rs"]`, test scope `--lib jql::`) + `--in-diff` on the same delta diff. `Found 9 mutants to test` / `9 mutants tested in 5m: 9 caught` / `0 missed` / `0 timeout` / `0 unviable`. Baseline `ok` (51s build + 1s test). The temp config was NOT committed; `.cargo/mutants.toml` is unchanged. |
| Security (`cargo deny check`) | **PASS** | exit 0 — `advisories ok, bans ok, licenses ok, sources ok`. No new dependencies added this cycle. Corroborates the green Deny job on #870's CI. |
| Security (`cargo audit`) | **PASS** | 0 vulnerabilities / 360 crate dependencies scanned / 1264 advisories loaded, exit 0. |
| Formal verification (Kani) | **JUSTIFIED SKIP (0-GAP)** | See rationale below. Precedent: cycle-002/003/004/005/012 F6 justified Kani skips. |
| Fuzz (`cargo-fuzz`) | **JUSTIFIED SKIP (0-GAP)** | See rationale below. Precedent: cycle-002/003/004/005/012. |
| Purity boundary | **PASS (intact)** | `validate_duration` and `invalid_duration_error` are pure, total, side-effect-free (see below). |

## Mutation detail — the 9 caught mutants (delta override run)

All 9 land in the cycle-009 delta functions and are all CAUGHT:

- `src/jql.rs:15:5: replace invalid_duration_error -> String with String::new()` — killed by
  the canonical-error-string pin tests.
- `src/jql.rs:15:5: replace invalid_duration_error -> String with "xyzzy".into()` — killed by
  the canonical-error-string pin tests.
- `src/jql.rs:29:16: replace < with >` / `<=` / `==` in `validate_duration` (3 mutants) — killed
  by the `s.len() < 2` length-guard tests (empty / too-short cases).
- `src/jql.rs:29:5: replace validate_duration -> Result<(), String> with Ok(())` — killed by any
  rejection test (e.g. rejects_month / rejects_year / empty).
- `src/jql.rs:41:26: replace || with && in validate_duration` and
  `src/jql.rs:41:29: delete ! in validate_duration` (2 mutants) — killed by the digit-validation
  branch tests.
- **`src/jql.rs:44:8: delete ! in validate_duration`** — the cycle-009 core: this `!` on the
  `if !matches!(unit, 'w' | 'd' | 'h' | 'm')` unit-set guard is the load-bearing narrowing.
  Killed jointly by `validate_duration_rejects_month_uppercase` / `validate_duration_rejects_year`
  (deleting `!` would make the newly-rejected `M`/`y` pass) and by the lowercase-accept tests
  (deleting `!` would make valid `w/d/h/m` error).

Disposition: **no surviving mutants, no equivalent-mutant deferrals.** The delta's test set (unit
canonical-string pins, month/year rejection, uppercase-unit rejection, lowercase-accept, empty
single-source-of-truth pin, and the `validate_duration_never_panics` proptest) gives complete
operator-kill coverage of the change. Note: cargo-mutants does not synthesize a match-arm
literal-set mutant (e.g. re-adding `'M' | 'y'`), so the narrowing is validated via the `delete !`
guard mutant plus the reject/accept assertion tests rather than a direct arm-set mutation — this is
a cargo-mutants operator-catalog limitation, not a coverage gap.

## Kani / cargo-fuzz — JUSTIFIED SKIP (0-GAP) rationale

`validate_duration` is a **pure, total, side-effect-free** function: `fn(&str) -> Result<(), String>`,
no I/O, no global state, no `unsafe`, no arithmetic overflow surface (only `s.len() - unit.len_utf8()`
which is guarded char-safely, already covered by the multibyte test). `invalid_duration_error` is a
pure `String` formatter. Panic-safety is already positively covered by the existing
`validate_duration_never_panics` proptest and the multibyte-final-character test. The change strictly
**narrows** accepted input (removes `M`/`y`), so it introduces **no new attack surface** — it can only
reject more, never accept more. No new arbitrary-byte parser was introduced. Consequently neither a
Kani proof harness nor a cargo-fuzz target would exercise any behavior not already covered by the
existing proptest + the delta's operator-targeted unit tests. Recorded as a justified **0-GAP** skip,
consistent with the cycle-002/003/004/005/012 F6 precedent for pure, total functions.

## Purity boundary

`validate_duration` / `invalid_duration_error` (`src/jql.rs`) take all input as parameters, perform
no file/network/keychain I/O, touch no global mutable state, and call only pure std helpers
(`str::len`, `chars`, `is_ascii_digit`, `format!`). The change keeps the function pure. Purity
boundary **intact**.

## Residuals

1. **`CYCLE-009-F6-MUTANTS-EXAMINE-GLOBS-GAP`** (MEDIUM — surface at the F7 human gate).
   `.cargo/mutants.toml`'s `examine_globs` does not include `src/jql.rs`, so the standing CI
   `--in-diff` mutation gate generates **zero** mutants for this cycle's delta (empirically:
   `No mutants to filter`, exit 0 — a false green). The delta's kill coverage was confirmed
   **100% (9/9)** only via an out-of-band temp-config override in this F6 run; the standing gate
   will continue to skip `src/jql.rs` on future PRs until it is added. **Recommendation:** adding
   `src/jql.rs` to `examine_globs` is **warranted and low-risk** — `src/jql.rs` is a pure,
   security-adjacent module (JQL escaping / injection-relevant validation), fully default-CI-testable
   (all killer tests are inline lib unit tests + one proptest; no keyring/network/Windows gating),
   and the empirical run shows 100% kill with no flooding of un-actionable survivors. This mirrors
   the `FIX-F6-MUTANTS-SCOPE` / P22-001 / D-149 "new/omitted testable file → add to mutants.toml"
   precedent. **Deferred, not enacted here:** adding it is a repo-wide mutation-**policy** change
   that also requires updating `docs/specs/cargo-mutants-policy.md` §Scope and keeping
   `scripts/check-cargo-mutants-policy-citations.sh` + `tests/mutants_glob_existence.rs` green —
   out of LIGHT-F6 scope and reserved for human sign-off at F7, exactly as cycle-008 handled its
   equivalent gap.

## Outcome

**F6 VERDICT: HARDENED_WITH_RESIDUALS.** No BLOCKING findings. Delta mutation kill = 100% (9/9,
out-of-band); security clean (`cargo deny` + `cargo audit` both exit 0, 0 vulns / 0 license issues,
no new deps); Kani/fuzz justified 0-GAP skip; purity intact. `src/` was not modified and no PR was
opened by this phase. The single residual (R1, examine_globs gap for `src/jql.rs`) is the item to
surface at the F7 human gate. **NEXT = Phase F7** (delta convergence + full-tree regression, final
human gate).
