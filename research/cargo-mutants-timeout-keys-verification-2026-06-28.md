# cargo-mutants timeout keys — correctness verification (27.x / 27.1.0)

**Date:** 2026-06-28
**Type:** general (technology correctness verification)
**Tool/version under test:** cargo-mutants 27.x, specifically 27.1.0 (released 2026-06-02)
**Trigger:** Adversarial reviewer F-1 claim — that `.cargo/mutants.toml`'s use of `minimum_test_timeout = 120` as an "absolute ceiling that overrides timeout_multiplier" is inverted.

---

## VERDICT (crisp)

- **(a) Is `minimum_test_timeout` a floor or a ceiling?**
  **FLOOR.** It is a lower bound on the auto-derived per-mutant test timeout. The source doc-comment is verbatim: *"Minimum test timeout, in seconds, as a floor on the autoset value."* The default is **20 seconds**.

- **(b) Exact knob for an ABSOLUTE PER-MUTANT TIMEOUT CEILING:**
  **CLI flag `--timeout <SECS>` only.** There is **NO `.cargo/mutants.toml` config key** for the absolute ceiling. The names `test_timeout` and `timeout` do **not** exist as toml keys in 27.x. `--timeout` is command-line-only (internally `test_timeout`, populated solely from `args.timeout`).

- **(c) Adversary's F-1 claim:**
  **CONFIRMED.** Our config comment/policy is inverted. `minimum_test_timeout = 120` does NOT impose a ceiling and does NOT override `timeout_multiplier`. It raises the *floor* to 120s — i.e. it can only make per-mutant timeouts *longer*, never shorter. With our `timeout_multiplier = 3.0`, the effective per-mutant timeout is `max(baseline × 3.0, 120s)`, which is unbounded above. The claimed "absolute ceiling" behavior is impossible to express via any toml key; it requires the `--timeout` CLI flag.

---

## Detailed findings

### Q1 — `minimum_test_timeout` / `--minimum-test-timeout`: FLOOR

**It is a FLOOR (lower bound), not a ceiling.** Default = **20 seconds**.

- Source `src/config.rs` field doc-comment (verbatim):
  > `minimum_test_timeout` — `Option<f64>` — *"Minimum test timeout, in seconds, as a floor on the autoset value."*
- Source `src/options.rs` (verbatim):
  ```rust
  args.minimum_test_timeout.or(config.minimum_test_timeout).unwrap_or(20f64)
  ```
  → defaults to `20.0` seconds when neither CLI nor config sets it.
- Book (`mutants.rs/timeouts.html`, verbatim):
  > "The default test timeout is 5 times the baseline test time, with a minimum of 20 seconds."
  > "The minimum of 20 seconds for the test timeout can be overridden by the `--minimum-test-timeout` option or the `CARGO_MUTANTS_MINIMUM_TEST_TIMEOUT` environment variable, measured in seconds."

CLI flag `--minimum-test-timeout` **does** map to toml key `minimum_test_timeout` (snake_case). Env var `CARGO_MUTANTS_MINIMUM_TEST_TIMEOUT` is a third source.

### Q2 — Absolute per-mutant ceiling: `--timeout` CLI flag ONLY (no toml key)

- Book (verbatim): *"You can set an explicit timeouts with the `--timeout` option, also measured in seconds."*
- Source `src/options.rs` (verbatim):
  ```rust
  test_timeout: args.timeout.map(Duration::from_secs_f64),
  ```
  Only `args.timeout` (the CLI arg) feeds `test_timeout`. There is **no** `.or(config.test_timeout)` — the `Config` struct has **no such field**.
- Source `src/config.rs`: the only timeout-related toml keys are `build_timeout_multiplier`, `minimum_test_timeout`, and `timeout_multiplier`. **`test_timeout` and `timeout` are absent.**
- Perplexity cross-check (`mutants.rs/timeouts.html`, `mutants.rs/config-file.html`): "There is no `.cargo/mutants.toml` config key for the absolute `--timeout`; it is available only as the `--timeout` command-line option."

**Conclusion:** to enforce a hard per-mutant ceiling you MUST pass `--timeout <SECS>` on the command line (or in CI invocation). It cannot live in `.cargo/mutants.toml`.

### Q3 — `timeout_multiplier` interaction

- Per-mutant timeout (no explicit `--timeout`, baseline measured):
  `effective = max(baseline_test_duration × timeout_multiplier, minimum_test_timeout)`.
  With the default multiplier the doc phrases it as "5 times the baseline ... with a minimum of 20 seconds." Setting `timeout_multiplier = 3.0` replaces the 5× factor with 3×. The `max(..., minimum_test_timeout)` floor still applies. **CONFIRMED.**
- Book (verbatim): *"The multiplier only has an effect if the baseline is not skipped and if `--timeout` is not specified."* So an explicit `--timeout` overrides/supersedes the multiplier path entirely.
- `--baseline=skip` behavior — **CONFIRMED, with the exact fallback value:**
  Book (verbatim): *"The multiplier timeout options cannot be used when the baseline is skipped (`--baseline=skip`), or when the build is in-place (`--in-place`). If no explicit timeouts is provided in these cases, then there is no build timeout and the test timeout default of 300 seconds will be used."*
  → With `--baseline=skip`, `timeout_multiplier` is ignored; absent `--timeout`, the test timeout falls back to **300 seconds** (not 20s, not the multiplier).

### Q4 — CLI flag ↔ toml key mapping (27.x)

| CLI flag | toml key (`.cargo/mutants.toml`) | Source of truth | Default |
|---|---|---|---|
| `--minimum-test-timeout` | `minimum_test_timeout` | CLI or config (CLI wins) | 20s |
| `--timeout-multiplier` | `timeout_multiplier` | CLI or config (CLI wins) | 5× (when applicable) |
| `--build-timeout-multiplier` | `build_timeout_multiplier` | CLI or config (CLI wins) | none (no build timeout by default since 24.7.1) |
| `--timeout` (absolute test ceiling) | **(none — CLI-only)** | CLI args only (`test_timeout`) | none; 300s fallback when baseline skipped |
| `--build-timeout` (absolute build ceiling) | **(none — CLI-only)** | CLI args only | none |

`--timeout` does **NOT** map to `test_timeout` (or `timeout`) in the toml — there is no such key. `--minimum-test-timeout` **does** map to `minimum_test_timeout`. `--timeout-multiplier` **does** map to `timeout_multiplier`.

---

## 27.1.0-specific confirmation

cargo-mutants `NEWS.md` shows **no timeout-behavior changes in 27.0.0 → 27.1.0 or late 26.x**. The last timeout-relevant changes were 24.7.0 (auto-set timeout formula docs) and 24.7.1 ("No build timeouts by default"). The timeout model — FLOOR semantics for `minimum_test_timeout`, CLI-only `--timeout`, 20s floor / 300s skip-baseline fallback — is **stable through 27.1.0**. The source quotes above are from the `main` branch, which post-dates 27.1.0; combined with the empty 27.x changelog, the behavior applies to 27.1.0.

**Caveat:** Source files were read from the `main` branch (latest), not a pinned `v27.1.0` tag checkout. Because the 27.x changelog records no timeout changes, `main` is authoritative for 27.1.0 here. This is the one area where I confirmed via "no-change in changelog" rather than a tag-pinned file read.

---

## Impact on our config + recommended fix

Current `.cargo/mutants.toml`:
```toml
timeout_multiplier = 3.0
# (policy/comment elsewhere claims minimum_test_timeout=120 is an "absolute ceiling
#  that overrides timeout_multiplier when the multiplier result exceeds it")
```

The policy claim is **inverted**. Two corrective options:

1. **If the intent was a FLOOR** (guarantee at least Ns even when baseline is tiny): keep `minimum_test_timeout` but rewrite the comment/policy to say "floor" — and note it can only *raise* the timeout. Pick a value that reflects floor intent (120s floor is large; the default is 20s).

2. **If the intent was an absolute CEILING** (kill any mutant after Ns regardless of baseline — the stated goal): this CANNOT be done in `.cargo/mutants.toml`. Move it to the CI invocation as `cargo mutants --timeout <SECS> ...` (and to the documented local command in CLAUDE.md / `docs/specs/cargo-mutants-policy.md`). Then either drop `minimum_test_timeout` or keep it as a deliberate floor with corrected wording.

Note also: `--timeout` supersedes the multiplier path, so if you add `--timeout`, `timeout_multiplier = 3.0` stops applying to the test timeout (per the book: "The multiplier only has an effect if ... `--timeout` is not specified").

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source synthesis of cargo-mutants timeout model (floor vs ceiling, key mapping, baseline-skip fallback). reasoning_effort=high. |
| Perplexity perplexity_ask | 1 | Confirm absence of a toml key for absolute `--timeout`. |
| WebFetch | 5 | Verbatim reads of authoritative source: `book/src/timeouts.md`, `src/config.rs` (struct field doc-comments), `src/options.rs` (CLI↔config wiring), `mutants.rs/timeouts.html`, `NEWS.md` (27.x changelog), plus one non-hit (`filter_mutants.md`). |
| Read | 1 | Current `.cargo/mutants.toml`. |
| Grep | 1 | Searched cached research output (single-line file). |
| Training data | 0 areas | All load-bearing claims verified against live source/docs. |

**Total MCP tool calls:** 2 (1 perplexity_research + 1 perplexity_ask). WebFetch (5) used for verbatim source/doc quotes.
**Training data reliance:** low — every key claim is backed by a verbatim source-code or official-docs quote with a URL.

### Sources
- `src/config.rs` (Config struct field doc-comments) — https://raw.githubusercontent.com/sourcefrog/cargo-mutants/main/src/config.rs
- `src/options.rs` (CLI↔config wiring, `unwrap_or(20f64)`, `args.timeout.map(...)`) — https://raw.githubusercontent.com/sourcefrog/cargo-mutants/main/src/options.rs
- Book timeouts page — https://mutants.rs/timeouts.html and https://raw.githubusercontent.com/sourcefrog/cargo-mutants/main/book/src/timeouts.md
- Changelog (no 27.x timeout changes) — https://raw.githubusercontent.com/sourcefrog/cargo-mutants/main/NEWS.md
- Config-file page (no absolute-timeout key) — https://mutants.rs/config-file.html
