# H-028 Root-Cause Finding — Invalid config profile key on `jr auth list`

- **Date:** 2026-06-25
- **Investigation type:** READ-ONLY (no source/config modified, no commits)
- **Source claim:** `.factory/maintenance/2026-06-25/holdout-freshness.md` line 8
- **Binary under test:** `target/debug/jr` (debug build, `JR_CONFIG_DIR` isolation seam)

## VERDICT: (B) — STALE / INCORRECT HOLDOUT FINDING. NOT a regression.

The H-028 sweep finding is a **false positive**. `jr auth list` (both `--output json`
and human) **already exits 64** with the exact expected message
`invalid profile name "foo:bar" in config.toml` when a hand-edited config contains
an invalid profile key. There is **no regression**, and the claim that "config-key
validation no longer fires on the listing path" is empirically false against current
`develop` (HEAD `35e20c9`). H-019/#548 did not touch the config-file-boundary validation
loop at all.

The sweep finding should be **deleted/corrected**; no code change is warranted.

## Expected vs. Actual

| | Sweep CLAIMED (H-028) | ACTUAL (reproduced 2026-06-25) |
|---|---|---|
| `auth list --output json` | exit 0, empty table, invalid key silently filtered | **exit 64**, JSON error `{"code":64,"error":"invalid profile name \"foo:bar\" in config.toml; …"}` |
| `auth list` (human) | exit 0, empty table | **exit 64**, stderr `Error: invalid profile name "foo:bar" in config.toml; …` |
| `auth switch "foo:bar"` | exit 64 (sweep agrees) | exit 64 (confirmed) |
| control (valid-only config) | n/a | exit 0, one-row JSON array (correct) |

The actual `auth list` behavior **matches the holdout expectation**. The sweep's
"exit 0 + empty table" observation could not be reproduced and is presumed to be a
flawed repro (e.g., the temp config was not actually being read — see Blast Radius note
on the `JR_CONFIG_DIR` vs `XDG_CONFIG_HOME` seam, or a different/empty config path).

### Exact reproduction (isolated temp config)

config.toml:
```toml
default_profile = "default"
[profiles.default]
url = "https://example.atlassian.net"
auth_method = "api_token"
[profiles."foo:bar"]
url = "https://bad.example.net"
auth_method = "api_token"
```

```
$ JR_CONFIG_DIR=$TMPD target/debug/jr auth list --output json ; echo EXIT=$?
{"code":64,"error":"invalid profile name \"foo:bar\" in config.toml; allowed: A-Z a-z 0-9 _ - up to 64 chars; reserved Windows names (CON, NUL, AUX, PRN, COM1-9, LPT1-9) excluded"}
EXIT=64

$ JR_CONFIG_DIR=$TMPD target/debug/jr auth list ; echo EXIT=$?
Error: invalid profile name "foo:bar" in config.toml; allowed: A-Z a-z 0-9 _ - up to 64 chars; reserved Windows names (CON, NUL, AUX, PRN, COM1-9, LPT1-9) excluded
EXIT=64

$ JR_CONFIG_DIR=$TMPD target/debug/jr auth switch "foo:bar" ; echo EXIT=$?
Error: invalid profile name "foo:bar" in config.toml; …
EXIT=64
```

## Responsible code path

The config-file-boundary validation is a single shared chokepoint that runs for
**every** command going through `Config::load*`, including `auth list`:

- `src/config.rs::Config::load_inner` (lines ~298–307): iterates `global.profiles.keys()`
  and calls `validate_profile_name(name)`, wrapping any error via `.map_err` into the
  `"… in config.toml; …"` message. This loop runs **before** `active_profile_name` is
  resolved and **before** the strict active-profile-existence check — i.e., it gates on
  the mere *presence* of any invalid key in the map, regardless of which command runs or
  which profile is active.
- `src/config.rs::validate_profile_name` (lines ~115–149): rejects `:` as an invalid
  charset character (`is_ascii_alphanumeric() || '_' || '-'`).
- `src/cli/auth/list.rs::handle_list` (line 61): `Config::load_with(cli_profile)?` — the
  `?` propagates the boundary error out of the handler before any table/JSON is built.
  This is the same `Config::load_with` entry point used by `auth switch` and friends.

Because the validation lives in `load_inner` (not in any per-command handler), `auth list`,
`auth switch`, `issue list`, etc. all reject identically. There is **no listing-specific
bypass**.

## Why H-019/#548 did not regress this (commit-level evidence)

`git show d2a6f89` (H-019, #548) touched `src/config.rs` in exactly three ways:

1. `validate_profile_name`: split the empty/too-long branch and changed the internal
   variant from `JrError::ConfigError` (exit 78) → `JrError::UserError` (exit 64) for
   empty / too-long / invalid-charset names. **Behavioral effect on the config-file
   boundary: none** — that boundary already re-wraps the error into a fresh
   `JrError::UserError(... "in config.toml" ...)` via `.map_err`, so its variant and
   message were exit-64 / "in config.toml" both before and after #548.
2. Added a one-line clarifying comment above the `.map_err` in the config-key loop.
   (`// map_err supplies a file-locating message; keep even though validate_profile_name
   now returns UserError.`) — comment only, no logic change.
3. Added tests, including a **regression guard for exactly this boundary**:
   `src/config.rs::config_load_rejects_invalid_profile_key_in_config` (lines ~1509–1559),
   which writes `[profiles."bad:name"]`, calls `Config::load()`, and asserts
   `JrError::UserError` + `exit_code() == 64` + message contains `"invalid profile name"`
   and `"bad:name"`.

The config-key boundary loop has fired on every `Config::load*` path since the
multi-profile feature landed (#275, commit `c7675c1`) — long before #548. H-019 only
changed the **flag/env path** variant (exit 78 → 64); the config-file path was already
exit 64.

### Regression guard currently PASSES on HEAD
```
$ cargo test --lib config_load_rejects_invalid_profile_key_in_config
test config::tests::config_load_rejects_invalid_profile_key_in_config ... ok
test result: ok. 1 passed; 0 failed; …
```
This is a stronger statement than the manual repro: an automated test pins the
config-file-boundary exit-64 contract and is green. A real regression would have turned
this test red.

## Reconciliation with the #548 CHANGELOG statement

The #548 CHANGELOG line — *"The config-file boundary (`[profiles."foo:bar"]` in
config.toml) already exited 64 and is unchanged"* — refers to the **same** `load_inner`
profile-key loop investigated here. It is accurate. The H-028 sweep misread this as a
*different* path that the listing command bypasses; no such bypass exists. `auth list`
goes through `Config::load_with`, hits the loop, and exits 64.

## Blast radius — which commands validate config keys

- **Validate (exit 64 on any invalid `[profiles."…"]` key):** every command that calls
  `Config::load` / `Config::load_with` — `auth list`, `auth switch`, `auth status`,
  `auth remove`, `auth refresh`, `issue *`, `board`, `sprint`, etc. The check is map-wide
  and command-agnostic.
- **Lenient exception:** `Config::load_lenient*` (used only by `jr auth login`) still runs
  the **same profile-key validation loop** — it only skips the *active-profile-existence*
  check, not the key-charset check. So even `auth login` rejects a pre-existing invalid
  key in the map.
- **Not affected:** the `--profile` flag / `JR_PROFILE` env path (a different validation
  site at `load_inner` line ~329, `validate_profile_name(&active_profile_name)?`), which
  is the actual subject of H-019/#548.

## Recommended remediation

**Holdout-expectation / sweep correction only. No code fix. No test change.**

1. **Correct the sweep entry.** In `.factory/maintenance/2026-06-25/holdout-freshness.md`,
   reclassify H-028 from "NEW regression from #548" to **FALSE POSITIVE / could-not-reproduce**.
   `auth list` exits 64 with `invalid profile name "foo:bar" in config.toml` as the holdout
   expects. Revert the summary lines that bumped "coverage gaps 6→7" / "stale 4→3" on the
   basis of H-028, and the line `H-028 PASS→STALE (NEW regression from #548)`.
2. **Keep H-028 PASS in the holdout corpus** (`.factory/specs/prd/holdout-scenarios.md`) —
   the expectation is correct and already enforced by the automated regression guard
   `config_load_rejects_invalid_profile_key_in_config`. No re-pointing to a different
   command is needed; the original expectation holds for `auth list`.
3. **Optional (low priority, not required):** if desired, add a thin end-to-end CLI-surface
   assertion that `jr auth list` against a config with an invalid key exits 64, to pin the
   handler-level wiring in addition to the existing `Config::load` unit test. This is
   belt-and-suspenders; the unit-level guard already covers the load path that `auth list`
   shares.

## Citations
- `src/config.rs::Config::load_inner` (profile-key validation loop, ~L298–307; flag/env
  validation `validate_profile_name(&active_profile_name)?`, ~L329)
- `src/config.rs::validate_profile_name` (~L115–149)
- `src/cli/auth/list.rs::handle_list` (L57–72; `Config::load_with(cli_profile)?` at L61)
- `src/config.rs::config_load_rejects_invalid_profile_key_in_config` (regression guard, ~L1509–1559)
- `git show d2a6f89` (#548 / H-019 diff)
- Sweep claim: `.factory/maintenance/2026-06-25/holdout-freshness.md:8`
