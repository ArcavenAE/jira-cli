# F6 Fuzz Testing (cargo-fuzz) — cycle-003 `auth-profile-dx`

- **Baseline:** `87f17aff` → **HEAD:** `202414f2`
- **Date (UTC):** 2026-09-02
- **Tool:** `cargo-fuzz` (binary installed)

## Result: JUSTIFIED SKIP

### Evidence

1. **No `fuzz/` directory exists.** `ls fuzz/` → absent. The repo has no pre-existing
   cargo-fuzz targets to run.
2. **The cycle-003 delta introduces no new untrusted raw-byte-stream parser.** The changed-file
   set (`git diff --name-only 87f17aff..202414f2 -- 'src/**/*.rs'`, 17 files) is entirely:
   - **auth / credential I/O:** `src/api/auth.rs`, `src/cli/auth/*.rs` — structured keychain
     reads/writes over the `keyring` crate's typed `Entry` API; inputs are profile names and
     credential strings, not attacker-controlled byte streams.
   - **client auth-method resolution:** `src/api/client.rs` — an `Option<&str>` fallback
     (`.unwrap_or("api_token")`) and a `match` on a small closed set of method literals.
   - **config schema:** the additive `ProfileConfig.env: Option<String>` field — parsed by
     `serde`/`figment` TOML deserialization, an already-existing (and already broadly
     integration-tested) parse surface, not a new hand-rolled parser.
   - **ADR-0011 `Profile` newtype propagation:** `src/cli/{field,init,mod,requesttype,team}.rs`,
     `src/cli/issue/{field_resolve,jsm_create}.rs` — a type-fence wrapper (`Profile(String)`)
     threaded through call sites; no parsing logic.

   None of these is a decoder/parser over untrusted external bytes (contrast the ADF
   markdown→ADF path or an attachment binary decoder, which *would* warrant a fuzz target).
   The one parse-shaped change (the `env` TOML field) rides `serde` + `figment`, whose robustness
   is out of this delta's scope, and is additionally covered by VP-AUTHDX-009's 1000-case
   tolerant-reader proptest (`src/config.rs::proptests_env_tag`), which exercises the full
   input space of present/absent/arbitrary-string `env` values including `"(?s).*"` (any byte
   sequence incl. newlines).

3. **cycle-002 precedent:** the same JUSTIFIED-SKIP rationale was applied when a delta touched
   structured API + keychain I/O rather than a new raw-input parser.

### What would have changed this verdict

Had the delta added a new byte-stream parser (a new file-format decoder, a hand-written
protocol parser, an attachment/content sniffer), a `libfuzzer` target would have been authored
and run at `-max_total_time=300`. No such surface exists in this delta.

## Verdict

**JUSTIFIED SKIP** — no pre-existing fuzz targets, and the delta introduces no new
untrusted-raw-input parsing surface. The single parse-shaped change (`env` TOML field) is
serde-backed and additionally covered by a 1000-case proptest.
