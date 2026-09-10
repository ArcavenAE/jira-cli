# Dependency Audit — Raw Findings Summary (2026-09-10)

Scan-only sweep. No analysis, no fixes, no PRs opened. Raw command output captured in:
`/Users/zious/Documents/GITHUB/jira-cli/.factory/maintenance/dependency-audit-raw-2026-09-10.log`

Branch at scan time: `develop` (confirmed via `git branch --show-current`).

## Commands run and exit status

| Command | Exit status |
|---|---|
| `git branch --show-current` | 0 (output: `develop`) |
| `cargo audit` | 0 |
| `cargo deny check` | 0 |
| `cargo tree --duplicates` | 0 |
| `grep -A2 'name = "chacha20"' Cargo.lock` | 0 |

`cargo-audit` was already installed — no install step was needed.

## cargo audit — verbatim advisory/warning lines

```
Crate:     chacha20
Version:   0.10.0
Warning:   yanked
Dependency tree:
chacha20 0.10.0
└── rand 0.10.2
    └── jr 0.7.0-dev.5

warning: 1 allowed warning found
```

No RUSTSEC advisory IDs were emitted (only a `yanked` warning, no CVE/RUSTSEC ID attached to it in this output). 1243 advisories loaded from the RustSec advisory-db; scanned 358 crate dependencies.

## cargo deny check — verbatim warning/result lines

```
warning[license-not-encountered]: license was not encountered
  ┌─ /Users/zious/Documents/GITHUB/jira-cli/deny.toml:8:6
8 │     "BSD-2-Clause",
  unmatched license allowance

warning[license-not-encountered]: license was not encountered
   ┌─ /Users/zious/Documents/GITHUB/jira-cli/deny.toml:15:6
15 │     "OpenSSL",
   unmatched license allowance

warning[license-not-encountered]: license was not encountered
   ┌─ /Users/zious/Documents/GITHUB/jira-cli/deny.toml:13:6
13 │     "Unicode-DFS-2016",
   unmatched license allowance

warning[unmatched-skip]: skipped crate 'cpufeatures = ^0.2' was not encountered
    ┌─ /Users/zious/Documents/GITHUB/jira-cli/deny.toml:280:9
280 │ name = "cpufeatures"
281 │ version = "0.2"
282 │ reason = "sha1 v0.10.7 (ADR-0017 S-576-2 dependency for BC-2.7.010 batch-download SHA-1 path prefix) requires cpufeatures 0.2.17; chacha20 v0.10.0 (via rand v0.10.1) requires cpufeatures 0.3.0. Unavoidable until sha1 0.11 or rand's chacha20 unify on the same cpufeatures major. Authorized DEC-185."

warning[yanked]: detected yanked crate (try `cargo update -p chacha20`)
   ┌─ /Users/zious/Documents/GITHUB/jira-cli/Cargo.lock:30:1
30 │ chacha20 0.10.0 registry+https://github.com/rust-lang/crates.io-index
   yanked version
   ├ chacha20 v0.10.0
     └── rand v0.10.2
         └── jr v0.7.0-dev.5

advisories ok, bans ok, licenses ok, sources ok
```

Final result line: `advisories ok, bans ok, licenses ok, sources ok` — cargo deny check **passed** (exit 0). No `error[...]` lines were emitted, only `warning[...]` lines (3× license-not-encountered, 1× unmatched-skip, 1× yanked).

No RUSTSEC advisory IDs appeared in cargo-deny output either.

## cargo tree --duplicates — verbatim output

```
getrandom v0.3.4
└── rand_core v0.9.5
    ├── rand v0.9.4
    │   └── proptest v1.11.0
    │       [dev-dependencies]
    │       └── jr v0.7.0-dev.5 (/Users/zious/Documents/GITHUB/jira-cli)
    ├── rand_chacha v0.9.0
    │   └── proptest v1.11.0 (*)
    └── rand_xorshift v0.4.0
        └── proptest v1.11.0 (*)

getrandom v0.4.2
├── rand v0.10.2
│   └── jr v0.7.0-dev.5 (/Users/zious/Documents/GITHUB/jira-cli)
└── tempfile v3.27.0
    ├── dialoguer v0.12.0
    │   └── jr v0.7.0-dev.5 (/Users/zious/Documents/GITHUB/jira-cli)
    ├── insta v1.48.0
    │   [dev-dependencies]
    │   └── jr v0.7.0-dev.5 (/Users/zious/Documents/GITHUB/jira-cli)
    ├── proptest v1.11.0 (*)
    └── rusty-fork v0.3.1
        └── proptest v1.11.0 (*)
    [dev-dependencies]
    └── jr v0.7.0-dev.5 (/Users/zious/Documents/GITHUB/jira-cli)

rand v0.9.4 (*)

rand v0.10.2 (*)

rand_core v0.9.5 (*)

rand_core v0.10.1
├── chacha20 v0.10.0
│   └── rand v0.10.2 (*)
├── getrandom v0.4.2 (*)
└── rand v0.10.2 (*)

serde_spanned v0.6.9
├── toml v0.8.23
│   └── figment v0.10.19
│       └── jr v0.7.0-dev.5 (/Users/zious/Documents/GITHUB/jira-cli)
└── toml_edit v0.22.27
    └── toml v0.8.23 (*)

serde_spanned v1.1.1
└── toml v1.1.4+spec-1.1.0
    └── jr v0.7.0-dev.5 (/Users/zious/Documents/GITHUB/jira-cli)

toml v0.8.23 (*)

toml v1.1.4+spec-1.1.0 (*)

toml_datetime v0.6.11
├── toml v0.8.23 (*)
└── toml_edit v0.22.27 (*)

toml_datetime v1.1.1+spec-1.1.0
└── toml v1.1.4+spec-1.1.0 (*)

winnow v0.7.15
└── toml_edit v0.22.27 (*)

winnow v1.0.0
├── toml v1.1.4+spec-1.1.0 (*)
└── toml_parser v1.1.3+spec-1.1.0
    └── toml v1.1.4+spec-1.1.0 (*)
```

Duplicate crate families surfaced: `getrandom` (v0.3.4, v0.4.2), `rand` (v0.9.4, v0.10.2), `rand_core` (v0.9.5, v0.10.1), `serde_spanned` (v0.6.9, v1.1.1), `toml` (v0.8.23, v1.1.4+spec-1.1.0), `toml_datetime` (v0.6.11, v1.1.1+spec-1.1.0), `winnow` (v0.7.15, v1.0.0).

Note: no `syn` duplicate (2.0-vs-3.0 convergence concern mentioned in the task) appeared in this run's `cargo tree --duplicates` output.

## chacha20 in Cargo.lock

```
name = "chacha20"
version = "0.10.0"
source = "registry+https://github.com/rust-lang/crates.io-index"
```

Only one version present: **0.10.0** (the yanked version flagged by both `cargo audit` and `cargo deny check` above).

## Files written

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/maintenance/dependency-audit-raw-2026-09-10.log` (raw combined stdout+stderr log)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/maintenance/dependency-audit-raw-summary-2026-09-10.md` (this file)
