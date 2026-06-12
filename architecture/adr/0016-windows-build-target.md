---
document_type: architecture-decision-record
adr_number: "0016"
status: Accepted
date: 2026-06-12
supersedes: []
superseded_by: []
related: ["ADR-0003", "ADR-0006", "BC-6.1.001", "BC-6.1.002", "BC-1.4.027", "BC-6.1.014", "BC-6.2.016", "BC-6.2.017"]
---

# ADR-0016: Windows Build Target (x86_64-msvc, .zip, %APPDATA%/%LOCALAPPDATA% Paths, Credential Manager, Windows CI)

## Status

**Accepted** (2026-06-12). Scoped to cycle-001 windows-build feature (v0.6.0 target).

## Context

As of v0.6.0-dev.1 (commit 587206e), `jr` ships pre-built binaries for four targets:
`x86_64-apple-darwin`, `aarch64-apple-darwin`, `x86_64-unknown-linux-gnu`, and
`aarch64-unknown-linux-gnu`. No Windows artifact exists. The `release.yml` matrix
and all packaging steps are written for Unix runners with bash, `tar`, and `sha256sum`.

Windows users must build from source (`cargo build --release`), which is a significant
barrier. Windows is a primary platform for many Jira users; the absence of a pre-built
binary represents a distribution gap.

F1 delta analysis (`.factory/cycles/cycle-001/windows-build/delta-analysis.md`) identified
the following concrete blockers:

1. **keyring crate:** `windows-native` feature absent — credential storage silently fails
   at runtime on Windows (null backend).
2. **release.yml:** no Windows matrix row; packaging uses `tar czf` and `jr` (no `.exe`);
   smoke step uses `XDG_CONFIG_HOME` and heredoc — both fail on Windows runners.
3. **config/cache paths:** `dirs::home_dir().join(".config")` / `.join(".cache")` produce
   non-idiomatic Windows paths (`%USERPROFILE%\.config\jr`) instead of conventional
   AppData locations.
4. **Test isolation:** integration tests set `XDG_CONFIG_HOME`/`XDG_CACHE_HOME` for path
   isolation, but `dirs` ignores XDG on Windows — tests would write to the real user
   directories in Windows CI.
5. **No Windows CI job:** regressions on Windows are undetectable until a release tag is
   pushed.

Five decisions were presented at the human gate on 2026-06-12. All five were confirmed.
This ADR records them as locked decisions.

## Decisions

### Decision 1: Target `x86_64-pc-windows-msvc` ONLY this cycle

**Decision:** Ship one Windows target: `x86_64-pc-windows-msvc`. Native build on
`windows-latest` GitHub Actions runner via `rustup target add`.

**Deferred:** `aarch64-pc-windows-msvc` — no native runner available; cross-compilation
for MSVC targets is not supported by `cross-rs`; requires a separate toolchain investigation.
Deferred to a future cycle.

**Not in scope:** `i686-pc-windows-msvc` (32-bit) — no user demand identified.
`x86_64-pc-windows-gnu` (MinGW) — requires MinGW runtime DLL; inferior distribution story
for end-users.

**Rationale:** MSVC toolchain is available natively on `windows-latest`. `reqwest + rustls`
(pure Rust TLS, per ADR-0003) performs the TLS handshake and crypto in pure Rust
(aws-lc-rs/ring) — no OpenSSL and no Schannel for the TLS protocol itself. This gives
a redistributable binary with no TLS-stack DLL dependency.

**Qualification (reqwest 0.13 default behavior):** reqwest 0.13 changed the `rustls`
default to verify certificate roots via `rustls-platform-verifier`, which on Windows
delegates root discovery to the Windows certificate store (CryptoAPI). This means there
is a soft runtime dependency on the Windows trust store for certificate root validation —
not for the TLS protocol stack itself. This is the upstream default and is acceptable:
`jr` constructs the HTTP client with a bare `Client::builder()…build()` in
`src/api/client.rs` (no explicit TLS config), so the 0.13 default applies. Atlassian
endpoints (`*.atlassian.net`) chain to publicly-trusted roots present in the Windows
store on any standard Windows installation.

The alternative (`rustls-tls-webpki-roots` feature) would bundle Mozilla roots at build
time, eliminating any OS-store reliance, but loses enterprise-CA and CRL support and
pins roots at compile time. That trade-off is not warranted here; the upstream default is
the correct choice.

**ADR-0003 cross-reference:** The existing choice of `rustls` over `native-tls` (ADR-0003)
was made explicitly for cross-compilation reasons. That decision pays off here: no TLS
linking issues on Windows.

### Decision 2: Artifact format `.zip`

**Decision:** Package the Windows binary as `jr-<version>-x86_64-pc-windows-msvc.zip`
(contains `jr.exe`). Checksum as `jr-<version>-x86_64-pc-windows-msvc.zip.sha256`.

**Deferred:** `.tar.gz` of `jr.exe` — technically extractable via Git Bash or WSL, but
unfamiliar to pure-Windows users and not a Windows-conventional format.

**Rationale:** `.zip` is natively extractable on Windows 10+ via File Explorer and
PowerShell `Expand-Archive` without third-party tools. CLI tools on Windows (e.g.,
`ripgrep`, `fd`, `bat`, `delta`) universally distribute as `.zip`. This matches user
expectations. The `softprops/action-gh-release` step accepts arbitrary file types;
`.zip` uploads cleanly alongside the existing `.tar.gz` artifacts.

**Implementation note:** Use `shell: bash` with `zip -j` (available via Git Bash on
`windows-latest`). Alternatively, PowerShell `Compress-Archive` is acceptable. Either
produces an equivalent `.zip`. `sha256sum` is available via Git Bash on Windows runners.

### Decision 3: Add Windows job to `ci.yml` (full CI regression protection)

**Decision:** Add `windows-latest` to the `test` matrix in `ci.yml`. The Windows CI job
runs `cargo test`, `cargo clippy -- -D warnings`, and implicitly depends on the
test-isolation seam (Decision 5) being implemented first.

**Rationale:** Windows CI on every PR provides regression protection. Without it, any
Windows-specific break is only detected when a release tag is pushed. The human gate
overrode the F1 recommendation (which had suggested release-build-only for v1) in favor
of full CI protection.

**Prerequisite:** The `JR_CONFIG_DIR`/`JR_CACHE_DIR` test-isolation seam (Decision 5)
must be implemented before Windows is added to `ci.yml`. Without the seam, tests set
`XDG_CONFIG_HOME`/`XDG_CACHE_HOME`, which `dirs` ignores on Windows, causing tests to
write to the real user profile.

**Scope note for `fmt` and `deny` jobs:** These run on `ubuntu-latest` only. The `clippy`
job runs on `ubuntu-latest` only; Windows clippy is folded into the `test` matrix step
(Windows `test` job runs `cargo clippy -- -D warnings` before `cargo test`). This avoids
adding a separate `windows-latest` clippy job at extra runner cost.

### Decision 4: Config/cache paths use idiomatic Windows conventions

**Decision:** On Windows, resolve configuration to `%APPDATA%\jr` (`dirs::config_dir()`)
and cache to `%LOCALAPPDATA%\jr` (`dirs::cache_dir()`). Unix behavior (`~/.config/jr`,
`~/.cache/jr/v1/`) is unchanged.

**Implementation:** `#[cfg(windows)]` / `#[cfg(not(windows))]` branches in:
- `src/config.rs::global_config_dir()`
- `src/cache.rs::cache_root()`

The cache versioning root `v1/` is preserved on both platforms. Full paths:
- Windows config: `%APPDATA%\jr\config.toml`
  (`dirs::config_dir().unwrap_or(USERPROFILE\AppData\Roaming).join("jr")`)
- Windows cache: `%LOCALAPPDATA%\jr\v1\<profile>\`
  (`dirs::cache_dir().unwrap_or(USERPROFILE\AppData\Local).join("jr").join("v1").join(profile)`)

**`APPDATA`/`LOCALAPPDATA` defensive fallback:** The `unwrap_or_else` branch reads
`APPDATA` (or `LOCALAPPDATA`) directly as a last resort when `dirs` fails. The empty-string
case must be filtered the same way as the debug seam — `APPDATA=""` is treated as
unavailable and falls through to `PathBuf::from(".")` (the `./jr` defensive path). Use
`.ok().filter(|s| !s.is_empty()).map(PathBuf::from)` in the fallback closure. This keeps
the unset and empty cases both routing to the `./jr` defensive fallback: the `APPDATA`
(config) path is consistent with BC-6.1.014 EC-1; the `LOCALAPPDATA` (cache) path is
consistent with BC-6.2.016 EC-1. Concrete snippet in architecture-delta.md §1.2.
- macOS/Linux config: unchanged (`$XDG_CONFIG_HOME/jr` or `~/.config/jr`)
- macOS/Linux cache: unchanged (`$XDG_CACHE_HOME/jr/v1/<profile>` or `~/.cache/jr/v1/<profile>`)

**Rationale:** Windows users expect AppData locations. A `.config` folder in the home
directory is unusual and may be hidden by Windows Explorer. `%APPDATA%` (Roaming) is
correct for config (survives roaming profile sync in enterprise environments); `%LOCALAPPDATA%`
(Local) is correct for cache (machine-local, not synced).

`XDG_CONFIG_HOME`/`XDG_CACHE_HOME` semantics remain Unix-only. On Windows, these env vars
are not consulted (they are not meaningful Windows concepts). The new `JR_CONFIG_DIR`/
`JR_CACHE_DIR` debug seam (Decision 5) provides the isolation mechanism for tests on all
platforms.

**BC impact:** Windows config-path behavior is fully captured by the new BC-6.1.014.
BC-6.1.001 and BC-6.1.002 cover config MIGRATION semantics (`[instance]/[fields]` →
`[profiles.default]`, idempotent write-back) and are NOT path-discovery contracts; no
platform-conditional clause is required in those BCs. Cache path behavior on Windows is
captured by BC-6.2.016 and the BC-6.2.004 platform-conditional update.

### Decision 5: `JR_CONFIG_DIR`/`JR_CACHE_DIR` debug-only env seam for test isolation

**Decision:** Add `JR_CONFIG_DIR` and `JR_CACHE_DIR` debug-only environment variable
overrides, read at the path-resolution site in `global_config_dir()` and `cache_root()`.
Gated by `#[cfg(debug_assertions)]`, consistent with the existing `JR_BASE_URL` and
`JR_AUTH_HEADER` debug seam pattern (SD-002).

**Design:** In `src/config.rs::global_config_dir()`, before the OS branch:
```
#[cfg(debug_assertions)]
// Empty string is treated as unset — mandated by BC-6.2.017 EC-1/EC-5.
if let Some(dir) = std::env::var("JR_CONFIG_DIR").ok().filter(|s| !s.is_empty()) {
    return PathBuf::from(dir);
}
// then: #[cfg(windows)] dirs::config_dir() branch, else XDG/home branch
```

Identical pattern in `src/cache.rs::cache_root()` for `JR_CACHE_DIR`.

The seam is read BEFORE the `#[cfg(windows)]` / `#[cfg(not(windows))]` OS split,
so it provides a single cross-platform isolation mechanism. When `JR_CONFIG_DIR` is
set, neither the XDG path nor the Windows AppData path is consulted.

**Subprocess boundary:** Integration tests use `assert_cmd` (subprocess invocation of the
`jr` binary). Environment variables are the only cross-process isolation mechanism that
works here. In-process state cannot be used. The `JR_CONFIG_DIR`/`JR_CACHE_DIR` env vars
are set via `.env("JR_CONFIG_DIR", dir.path())` on the `Command` builder — exactly the
same pattern as the existing `XDG_CONFIG_HOME`/`XDG_CACHE_HOME` usage, making migration
of test helpers mechanical.

**Existing XDG tests:** On macOS and Linux, tests can continue to set `XDG_CONFIG_HOME`/
`XDG_CACHE_HOME` OR migrate to `JR_CONFIG_DIR`/`JR_CACHE_DIR`. The new seam works on all
platforms. The existing XDG-based isolation also continues to work on Unix because the code
checks `XDG_CONFIG_HOME` in the `#[cfg(not(windows))]` branch. Both mechanisms coexist.

**Migration scope for test files:** All test files that set `XDG_CONFIG_HOME` or
`XDG_CACHE_HOME` must be updated to also set (or switch to) `JR_CONFIG_DIR`/`JR_CACHE_DIR`
for Windows CI compatibility. The primary affected helper is `jr_isolated()` in
`tests/auth_output_json.rs:69` and the ad-hoc `.env("XDG_*")` calls in ~12 other test files.

**Release gate:** `JR_CONFIG_DIR` and `JR_CACHE_DIR` have NO effect in release binaries
(`cargo build --release` sets `cfg(not(debug_assertions))`). The `#[cfg(debug_assertions)]`
gate is the same mechanical guarantee as `JR_BASE_URL`. A regression test
(`tests/config_dir_release_gate.rs`) pins this guarantee.

### Decision 5b: Keyring — Windows Credential Manager (`windows-native` feature)

**Decision:** Add `windows-native` to the `keyring` crate's feature list:
```toml
keyring = { version = "3", features = ["apple-native", "linux-native", "windows-native"] }
```

**Rationale:** Without `windows-native`, the keyring crate degrades to a null backend on
Windows — `jr auth login` appears to succeed but credentials are not persisted. The next
invocation fails with an auth error. This is a hard functional blocker. All three platform
features (`apple-native`, `linux-native`, `windows-native`) are `cfg`-gated per-OS at
compile time; listing all three is correct.

The per-profile keychain layout in `src/api/auth.rs` (service name `jr-jira-cli`,
per-profile keys `<profile>:oauth-access-token`, `<profile>:oauth-refresh-token`,
shared keys `email`, `api-token`) uses plain string identifiers that Windows Credential
Manager accepts without modification. No source changes to `auth.rs` are required.

**Gotcha — colon in profile-namespaced keys:** keyring `windows-native` stores credentials
as `CRED_TYPE_GENERIC` entries via `CredWriteW`. Windows Credential Manager validates only
that the target name is non-empty and within length limits — it does NOT prohibit the colon
character. The `<profile>:oauth-access-token` scheme is therefore portable to Windows
unchanged with no key sanitization required (verified against keyring-rs v3.6.3
`src/windows.rs` + Microsoft `CredWriteW` documentation, 2026-06-12).

**`deny.toml` note:** `windows-native` pulls in `windows-sys` (wincred backend). The
existing `deny.toml` already skips the `windows-sys 0.45` / `0.61.2` version conflict.
Adding `windows-native` may introduce a new windows-sys version. Verify `cargo deny check`
at implementation time and add a `[[bans.skip]]` entry if needed.

### Decision 5c: Embedded-OAuth smoke step gated off on Windows

**Decision:** The "Verify embedded OAuth app present" step in `release.yml` is gated with
`if: runner.os != 'Windows'` for this cycle.

**Rationale:** The step uses bash heredoc, `XDG_CONFIG_HOME=$HOME/.config`, `find`, and
`grep` — all Unix-shaped. Porting to PowerShell or Git Bash is feasible but out of scope
for v1. The `build.rs` BCryptGenRandom path (the Windows entropy source for XOR key
generation) is tested implicitly by the build succeeding: `compile_error!` fires on any
non-unix/non-windows host (build.rs line 69–74), and BCryptGenRandom failure at build time
is fatal. The embedded constant check is the gap; a follow-up cycle can port it.

**ADR-0006 cross-reference:** ADR-0006 documents the XOR obfuscation scheme. The smoke
step verifies that `build.rs` populated the obfuscated constants at build time. For
Windows v1, this verification is deferred. The binary is still correct if built with the
OAuth secrets env vars present.

## Consequences

**Positive:**
- Windows users get a pre-built `.zip` binary from GitHub Releases.
- Credential storage works correctly via Windows Credential Manager.
- Config and cache are at conventional Windows AppData locations — no user confusion.
- Windows CI on every PR catches regressions before release.
- The `JR_CONFIG_DIR`/`JR_CACHE_DIR` seam eliminates the XDG-only isolation fragility
  and works identically on all three platforms.

**Negative / Trade-offs:**
- `aarch64-pc-windows-msvc` is not available this cycle (deferred).
- The embedded-OAuth smoke step is not verified on Windows builds for v1.
- Adding `windows-latest` to `ci.yml` increases runner cost (~30 min per PR at 1.0× rate).
- Test files using `XDG_CONFIG_HOME`/`XDG_CACHE_HOME` for isolation must be migrated
  (mechanical change, tracked in F4 implementation scope).
- Windows config-path behavior is fully captured by BC-6.1.014; no change to
  BC-6.1.001/BC-6.1.002 is outstanding (those BCs govern migration semantics, not
  path discovery).

**OAuth loopback (port 53682):** The `TcpListener::bind("127.0.0.1:53682")` in `auth.rs`
is cross-platform. On Windows, the Windows Firewall may prompt the user on first run to
allow the inbound connection. This is a documented user-facing consequence, not a code
change. The prompt is a one-time event per user profile.

## See Also

- ADR-0003 — `reqwest + rustls` (cross-platform TLS; underpins clean Windows build)
- ADR-0006 — Embedded OAuth app and XOR obfuscation (`build.rs` BCryptGenRandom path)
- BC-6.1.014 — Windows config path (new BC; fully captures Windows path-discovery behavior)
- BC-6.2.016, BC-6.2.017 — Windows cache path and debug seam (new BCs)
- BC-6.1.001, BC-6.1.002 — Config migration contracts (no Windows clause required; these
  govern `[instance]/[fields]` → `[profiles.default]` migration semantics only)
- BC-1.4.027 — Per-profile keychain keys contract (`<profile>:oauth-access-token` / `<profile>:oauth-refresh-token`; requires `windows-native` to hold)
- `.factory/cycles/cycle-001/windows-build/delta-analysis.md` — F1 scope analysis
- `docs/specs/` — feature spec for this cycle (F2 output)
- `.factory/cycles/cycle-001/windows-build/architecture-delta.md` — concrete design
