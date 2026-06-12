---
title: "F1 Delta Analysis — Windows Build Target"
phase: F1
feature: windows-build
base_ref: 587206e
base_version: 0.6.0-dev.1
date: 2026-06-12
author: architect
status: draft
---

# F1 Delta Analysis — Windows Build Target

## 1. Classification

**Feature** — new deployment artifact and platform support. Not a bug-fix
(nothing is broken today; Windows simply produces no artifact). Not a
pure enhancement to an existing feature; this adds a new target
dimension to the release pipeline AND requires runtime correctness on a
new OS.

**Routing recommendation: full Feature Mode (F1–F7), NOT quick-dev.**

Rationale: this feature spans three distinct concern areas, each requiring
genuine engineering and testing:

1. Release pipeline changes (CI/release.yml surgery, packaging format,
   smoke-step adaptation)
2. Cargo.toml dependency change (`keyring` feature flag) that affects
   credential storage behavior on a new OS — a correctness-critical surface
3. Runtime path-discovery semantics that diverge on Windows from the
   documented Linux/macOS behavior

Quick-dev would skip BC/NFR consideration for a change that warrants
an NFR (NFR-P-W1: supported platforms), a behavioral contract for
config/cache path discovery on Windows, and a CI regression-protection
decision. Those gaps would become real bugs in the release artifact.

---

## 2. Grounding — What the Files Actually Show

### 2.1 Release Pipeline (`release.yml`)

The current build matrix has four rows:

```
x86_64-apple-darwin   macos-latest   (native)
aarch64-apple-darwin  macos-latest   (cross via rustup target add)
x86_64-unknown-linux-gnu  ubuntu-latest  (native)
aarch64-unknown-linux-gnu ubuntu-latest  (cross via cross-rs)
```

Every step in the job is written as a bash `run:` block with no
`shell:` override, which means GitHub Actions defaults to bash on all
runners. On `windows-latest`, the default shell is PowerShell (pwsh),
not bash. The existing `run:` blocks would fail immediately on a Windows
runner unless the steps add `shell: bash` (which works via Git for
Windows) or are rewritten for PowerShell.

Affected steps:
- **Build step**: `if [ "${{ matrix.use_cross }}" = "true" ]` — bash syntax,
  fails under pwsh. Also, `cross` is Linux-only; the Windows row would
  never use it.
- **Package step**: `cd target/...`, `tar czf .../jr`, `sha256sum`/`shasum` —
  three problems: (a) the binary is `jr.exe` on Windows, not `jr`;
  (b) `tar czf` is available on Windows via Git Bash but `.tar.gz` is not
  the conventional Windows format; (c) `sha256sum` is not installed on
  `windows-latest` by default (requires choco or git bash equivalent;
  `CertUtil -hashfile` is the native alternative).
- **Verify-embedded-OAuth step**: uses heredoc `cat > file <<EOF`, sets
  `XDG_CONFIG_HOME=$HOME/.config`, runs `find .../release/build -path ...`,
  greps `embedded_oauth.rs`. All of this is bash/Unix-shaped. On Windows:
  `HOME` is undefined (use `USERPROFILE`), `XDG_CONFIG_HOME` is not used
  by `jr` on Windows (the `dirs` crate ignores XDG on Windows — see §2.4),
  `find` is not a standard Windows tool.
- **Upload-artifact step**: uses glob `jr-*.tar.gz` and `jr-*.sha256`.
  The glob would need to extend to `jr-*.zip` and `jr-*.sha256` for the
  Windows artifact (or the `.sha256` suffix can stay, just the archive
  format changes).
- **Release step** (separate `release` job on `ubuntu-latest`): downloads
  artifacts with `merge-multiple: true` and passes `jr-*.tar.gz` and
  `jr-*.sha256` to `softprops/action-gh-release`. Adding `jr-*.zip`
  to the `files:` glob would pick up the Windows archive. This job runs
  on Linux so no runner-compat issue here.

### 2.2 `Cargo.toml` and Dependency Portability

**keyring v3.6.3** — `{ features = ["apple-native", "linux-native"] }`.
The crate's feature model is:
- `apple-native` → macOS Keychain (security-framework)
- `linux-native` → Linux kernel keyring / libsecret
- `windows-native` → Windows Credential Manager (wincred via `windows-sys`)

`windows-native` is NOT in the current feature list. On a Windows build
without this feature, keyring will compile (the crate degrades gracefully)
but will use a mock/null backend, meaning credential storage silently
fails at runtime. This is a hard functional blocker for auth — `jr auth login`
would appear to succeed but tokens would not persist between invocations.
Adding `windows-native` to the features list enables the Windows Credential
Manager backend. The three platform features are mutually non-exclusive
(each is `cfg`-gated to its OS at compile time) so listing all three
simultaneously in `[dependencies]` is correct and safe; only the
platform-appropriate feature is compiled on each target.

**reqwest**: `default-features = false, features = ["json", "rustls"]`.
`rustls` is pure-Rust TLS, cross-compiles without system libraries. ADR-0003
explicitly chose rustls over native-tls for cross-compilation reasons. No
Windows blocker here; this is already the correct choice.

**dirs v6.0.0**: cross-platform but behavior differs.
- macOS/Linux: `home_dir()` → `$HOME`; the code then appends `.config/jr`
  or `.cache/jr` to get the XDG-style paths.
- Windows: `home_dir()` → `C:\Users\<User>`. The code would produce
  `C:\Users\<User>\.config\jr` and `C:\Users\<User>\.cache\jr`. These are
  technically valid Windows paths but diverge from the Windows conventional
  locations (`%APPDATA%\jr` = `dirs::config_dir()`, `%LOCALAPPDATA%\jr` =
  `dirs::cache_dir()`). Users expect Windows apps to use AppData; a `.config`
  folder in their home directory is unusual and may be hidden by Explorer.
  The correct fix would be: on Windows, prefer `dirs::config_dir()` and
  `dirs::cache_dir()` instead of `home_dir().join(".config")` and
  `home_dir().join(".cache")`. This is a UX decision that also affects
  documentation.

**colored v3.1.1**: already depends on `windows-sys 0.61.2` (confirmed in
Cargo.lock). Windows VT/ANSI is supported on Windows 10 1511+ via
`ENABLE_VIRTUAL_TERMINAL_PROCESSING`. The `colored` crate handles this.
The `--no-color`/`NO_COLOR` code in `main.rs` is cross-platform.

**dialoguer v0.12.0** → **console v0.16.3** → depends on `windows-sys 0.61.2`.
Interactive prompts work on Windows. No blocker.

**comfy-table v7.2.2** → **crossterm v0.29.0** → depends on `winapi` and
`crossterm_winapi`. Table rendering works on Windows. No blocker.

**open v5.3.5**: cross-platform. The crate uses platform-appropriate
browser-launch mechanisms (macOS: `open`, Linux: `xdg-open`, Windows:
`ShellExecuteW` or `cmd.exe /c start`). However, in the Cargo.lock, the
`open` crate's recorded deps are `is-wsl`, `libc`, and `pathdiff` — these
are the Linux/macOS deps recorded on the host (macOS) build. The Windows
deps (winapi or windows-rs) would appear in a Windows build's lock file.
The crate is fully supported on Windows. No source code change needed.

**tokio "full"**: cross-platform. `tokio::signal::ctrl_c()` used in
`main.rs:339` is the cross-platform API (works on Windows via
`SetConsoleCtrlHandler`). No Unix-only signal handling detected.

**pulldown-cmark, serde, serde_json, anyhow, thiserror, clap, futures,
rand, urlencoding, url, base64, chrono, figment, toml**: all pure-Rust,
fully cross-platform.

### 2.3 `build.rs`

`build.rs` already has a `#[cfg(windows)]` branch using `BCryptGenRandom`
for XOR key generation (lines 86–125). The Windows path is implemented and
documented. A `compile_error!` fires for any non-unix/non-windows host
(line 69–74). The build script is Windows-ready.

### 2.4 Config/Cache Path Discovery

`src/config.rs::global_config_dir()` (line 466):
```rust
if let Ok(xdg) = std::env::var("XDG_CONFIG_HOME") {
    PathBuf::from(xdg).join("jr")
} else {
    dirs::home_dir().unwrap_or_else(|| PathBuf::from("~")).join(".config").join("jr")
}
```

On Windows:
- `XDG_CONFIG_HOME` is typically not set (Windows ignores XDG).
- The fallback produces `C:\Users\<User>\.config\jr`.
- The Windows canonical location is `C:\Users\<User>\AppData\Roaming\jr`
  (`dirs::config_dir()`).

`src/cache.rs::cache_root()` (line 67): same pattern — falls back to
`home_dir().join(".cache").join("jr")` → `C:\Users\<User>\.cache\jr`
instead of the Windows canonical `C:\Users\<User>\AppData\Local\jr`
(`dirs::cache_dir()`).

Functional impact: the paths work as writable directories on Windows, so
the binary would not crash. However:
1. Users would need to know `%USERPROFILE%\.config\jr\config.toml` to hand-
   edit their config — not the Windows-idiomatic location.
2. Documentation says `~/.config/jr/config.toml` which is already misleading
   on Windows.
3. The release smoke step in `release.yml` sets `XDG_CONFIG_HOME=$HOME/.config`
   explicitly — this works on Linux/macOS, but on a Windows runner `$HOME`
   is not set (use `$USERPROFILE`) and even if it were, `XDG_CONFIG_HOME`
   is not honored by the `dirs` crate on Windows.

Decision required: adopt Windows-conventional paths (`dirs::config_dir()`,
`dirs::cache_dir()`) on Windows, OR document the non-standard `.config`
location and treat it as acceptable. See Open Question 5.

### 2.5 OAuth Callback Listener

`src/api/auth.rs` uses `std::net::TcpListener::bind("127.0.0.1:...")` and
`tokio::net::TcpListener`. Both are cross-platform. The loopback HTTP
listener pattern works on Windows. No change needed in the auth code for
the callback listener itself.

### 2.6 TTY Detection

`std::io::IsTerminal::is_terminal()` (stdlib, Rust 1.70+). Stable and
cross-platform on Windows (uses `GetConsoleMode`). No issue.

### 2.7 Hardcoded Unix Paths in Source

Grep results show NO `std::os::unix`, `nix::`, `libc::`, or Unix signal
APIs in `src/`. The XDG env var usage is in config/cache and is a UX
issue (see §2.4), not a compile-time blocker. The only platform-specific
source code is `build.rs` which already has proper `#[cfg(unix)]` /
`#[cfg(windows)]` branching.

No `std::os::unix::fs`, `PermissionsExt`, chmod calls, or permission-bit
manipulation found in `src/`. File I/O uses portable `std::fs`.

### 2.8 Integration Test Portability

Tests use `tempfile::TempDir` (cross-platform) and set `XDG_CONFIG_HOME`
/ `XDG_CACHE_HOME` as environment variables via `.env()` on `Command`
builders. On Windows, `dirs` ignores `XDG_CONFIG_HOME` — meaning the
config directory isolation would fail if tests run on Windows and the
binary's path-discovery logic is not updated to use `dirs::config_dir()`
on Windows. Consequence: if Windows CI tests are added and the path
logic is not fixed, every integration test that sets `XDG_CONFIG_HOME`
as the isolation mechanism would silently write to the real Windows user
directories instead of the temp directory.

The `insta` snapshot tests contain JSON and table output. No platform-
dependent content (no path separators, no CRLF) in the existing snapshots.
No `.gitattributes` exists; the repo could receive CRLF-contaminated files
if a Windows committer writes snapshot files. Low risk short-term; mitigate
with a `.gitattributes` entry (`*.snap text eol=lf`) before adding Windows
CI.

Keyring-gated tests (`JR_RUN_KEYRING_TESTS=1`, `#[ignore]`) call the real
system keychain. On Windows this means the Windows Credential Manager.
These tests should continue to work with `windows-native` enabled but
will prompt the Windows Credential Manager dialog in CI (or silently
succeed if running headlessly). The existing gating (`#[ignore]`, env var)
provides adequate protection.

### 2.9 Existing BCContracts and NFRs Impacted

No existing BC explicitly governs supported platforms; the current spec
assumes macOS and Linux (inherited from `global_config_dir()`'s XDG paths
and the release matrix). The following are POTENTIALLY impacted:

- **BC-6.1.001 / BC-6.1.002** (config load from `~/.config/jr/config.toml`):
  the `~/.config` path is Linux/macOS idiom; on Windows a different path
  is produced. The BC text as written is implicitly platform-specific.
- **BC-1.1.001 and related auth BCs**: keyring credential storage. Without
  `windows-native`, auth fails silently on Windows. This BC is violated by
  the current `Cargo.toml` on a Windows target.
- **NFR-S-B** (JR_AUTH_HEADER only debug-gated): unchanged; Windows-irrelevant.
- **NFR-S-F** (cargo-deny supply chain): adding `windows-native` to keyring
  may pull in new transitive crates (wincred/windows-sys). These need a
  `deny.toml` skip entry IF they introduce duplicate windows-sys versions.
  Existing `deny.toml` already skips `windows-sys 0.45` (via jni) vs
  `0.61.2` (majority of tree); adding `windows-native` in keyring may add
  another windows-sys version — needs verification at implementation time.

New NFR required: **NFR-P-W1** — Supported Platforms. Currently implicit
(macOS/Linux). Adding Windows means the NFR catalog must enumerate the
support tier: full support for `x86_64-pc-windows-msvc` (pre-built binary
distributed); macOS and Linux remain as before.

---

## 3. Target Recommendation

**Primary target: `x86_64-pc-windows-msvc`**

Rationale:
- MSVC toolchain is available natively on `windows-latest` GitHub Actions
  runners with no additional setup.
- MSVC is the dominant Windows toolchain for end-user binaries (vs GNU which
  requires a MinGW runtime).
- `reqwest + rustls` (pure Rust, no OpenSSL) means no system DLL dependency
  — the binary is self-contained.
- The `aarch64-pc-windows-msvc` target exists and is supported by Rust but
  GitHub Actions `windows-latest` runs on x86_64; cross-compiling to
  aarch64-windows requires a separate setup and no `cross` support for MSVC
  targets. Defer to a future cycle.
- The `-gnu` (MinGW) variant requires the MinGW runtime and is less common
  for distributed binaries. Defer.

**Deferred:**
- `aarch64-pc-windows-msvc` — runner/toolchain gap; defer to a future cycle
- `i686-pc-windows-msvc` (32-bit) — no user demand; defer indefinitely

---

## 4. Scope Decisions

### 4.1 Keyring Feature (Must Fix)

Add `windows-native` to the `keyring` features list in `Cargo.toml`:
```toml
keyring = { version = "3", features = ["apple-native", "linux-native", "windows-native"] }
```
This is a compile-time requirement for functional auth on Windows. Without
it the binary compiles but credential storage silently fails. Severity:
**hard blocker**.

After adding `windows-native`, run `cargo deny check` to verify no new
version conflicts. A `deny.toml` skip entry may be required if keyring's
Windows deps pull in a new windows-sys version.

### 4.2 Release Pipeline (Must Fix)

The Windows build job must be a **separate matrix row** with explicit
`shell: bash` on all `run:` steps (Git Bash is pre-installed on
`windows-latest`) OR use PowerShell equivalents. Recommendation:
add `shell: bash` to all `run:` steps in the Windows row — this is the
path of least resistance and keeps the shell consistent.

Changes required:
1. **Matrix addition**: new row `{ target: x86_64-pc-windows-msvc, os: windows-latest }`.
2. **Build step**: bash with `shell: bash` override; no `cross` (Windows
   supports native build of the MSVC target via `rustup target add`).
3. **Package step**: Windows-specific step producing:
   - `jr-<version>-x86_64-pc-windows-msvc.zip` (PowerShell
     `Compress-Archive` or 7-Zip/zip via Git Bash)
   - `jr-<version>-x86_64-pc-windows-msvc.zip.sha256`
   Binary to package: `target/x86_64-pc-windows-msvc/release/jr.exe`
   Checksum: `sha256sum` is available via Git Bash on `windows-latest`.
4. **Verify-embedded-OAuth step**: gate with `if: runner.os != 'Windows'`
   (the step is non-trivially hard to port: heredoc, XDG, find+grep). The
   build.rs BCryptGenRandom path is already tested by the build itself
   failing loudly if entropy is unavailable. The smoke check's purpose
   (confirm constants populated) can be replicated with a simpler PowerShell
   step, but this can be added in a follow-up. For v1, **skip the smoke
   on Windows** with a clear comment explaining the deferral.
5. **Upload-artifact step**: add `jr-*.zip` to the path glob.
6. **Release step**: add `jr-*.zip` to the `files:` glob.

### 4.3 Config/Cache Path Discovery

On Windows, `dirs::home_dir().join(".config").join("jr")` produces an
unusual path. Two options:

**Option A — Accept current behavior**: keep the `.config` and `.cache`
fallback. Document Windows paths in CLAUDE.md and eventual user-facing
docs as `%USERPROFILE%\.config\jr\config.toml`. Low implementation cost,
but non-idiomatic.

**Option B — Use `dirs::config_dir()` / `dirs::cache_dir()` on Windows**:
produce `%APPDATA%\jr\config.toml` and `%LOCALAPPDATA%\jr` (cache) on
Windows, unchanged on macOS/Linux. Requires `#[cfg(windows)]` branches
in `global_config_dir()` and `cache_root()`. Also requires updating the
integration test isolation mechanism (XDG_CONFIG_HOME won't work on Windows;
need a different env var or compile-time cfg).

Recommendation: **Option B** for correctness and user-friendliness, but
this adds scope. If the human wants to defer it, Option A is acceptable
for a v1 Windows artifact with a documented known limitation.

### 4.4 Integration Test Isolation on Windows

If Windows CI is added (see §4.5), the test isolation mechanism needs
attention. Two sub-options:
- Use `dirs::config_dir()` on Windows (Option B above) and add a
  corresponding `APPDATA`/`LOCALAPPDATA` override for tests.
- Alternatively, add a `JR_CONFIG_DIR` / `JR_CACHE_DIR` test-seam env
  var (debug-only, like `JR_BASE_URL`) that overrides path discovery
  regardless of OS, eliminating the XDG workaround entirely.

The second sub-option (`JR_CONFIG_DIR` / `JR_CACHE_DIR` env seam) is
cleaner and would work on all platforms including macOS/Linux.

### 4.5 CI Scope (Human Gate Decision)

**Option 1 — Release build only (no Windows CI testing)**: add the Windows
row to `release.yml` only. `ci.yml` stays macOS/Linux. Pros: minimal
runner cost, simplest change, gets a Windows artifact out fast. Cons:
Windows-specific regressions won't be caught until a release tag is pushed;
no green signal that tests pass on Windows.

**Option 2 — Add Windows to CI `test` matrix**: add `windows-latest` to the
`os: [ubuntu-latest, macos-latest]` matrix in `ci.yml`. Pros: regressions
caught on every PR; integration tests run on Windows. Cons: additional
runner-minutes (~30 min/run × 2 per PR at 1.0× cost); some tests will
likely fail on v1 (XDG isolation issue; keyring-gated tests need Credential
Manager setup). These failures must be investigated before adding Windows
to CI.

Recommendation: **Option 1 for v1** (release-build-only). Then, in a
follow-up cycle after the path-discovery and test-isolation issues are
addressed, add `windows-latest` to CI. This derisks the release artifact
getting out quickly while not shipping broken CI.

### 4.6 ADR Needed

This feature warrants a new **ADR-0016: Windows Build Target**. Key
decisions to record: (a) `x86_64-pc-windows-msvc` as primary target,
(b) `aarch64-pc-windows-msvc` deferred, (c) `.zip` artifact format,
(d) conventional vs XDG path policy on Windows, (e) CI-only vs
release-and-CI scope decision.

---

## 5. Impact Boundary

### Files Changed (Release Pipeline)
- `.github/workflows/release.yml` — matrix addition, platform-specific
  packaging step, smoke-step gate, upload/release glob additions
- `Cargo.toml` — `keyring` features: add `windows-native`
- `deny.toml` — likely a new `[[bans.skip]]` for any new windows-sys
  version pulled by keyring's Windows deps

### Files Changed (Source, if Option B path fix is in scope)
- `src/config.rs::global_config_dir()` — `#[cfg(windows)]` branch
- `src/cache.rs::cache_root()` — `#[cfg(windows)]` branch

### Files Changed (Documentation)
- `CLAUDE.md` — add Windows paths; add `JR_CONFIG_DIR`/`JR_CACHE_DIR`
  if env-seam approach is adopted; document Windows artifact format
- `docs/adr/0016-windows-build-target.md` — new ADR

### Files Not Changed
- `src/api/auth.rs` — OAuth callback listener is cross-platform
- `src/main.rs` — Ctrl+C via `tokio::signal::ctrl_c()` is cross-platform
- `src/api/auth.rs` (keyring usage) — service name is a plain string, no
  Unix assumptions; Windows Credential Manager accepts the same key names
- `build.rs` — already has `#[cfg(windows)]` BCryptGenRandom branch
- All test files (unless Windows CI is added, in which case XDG isolation
  needs a fix)

### Existing BCs Impacted
- BC-6.1.001 / BC-6.1.002 (config path) — will need a platform-conditional
  clause or a separate platform-scoped statement
- BC-1.1.001 and surrounding auth BCs — implicitly assume a working keyring;
  the `windows-native` feature fix is a prerequisite

### New BCs/NFRs Required
- **NFR-P-W1** (new): Supported Platforms. Define `x86_64-pc-windows-msvc`
  as a supported platform with a distributed pre-built artifact. Define
  macOS and Linux tiers explicitly.
- **BC-6.1.W01** (new, optional): Windows config path. If Option B is
  adopted, specify `%APPDATA%\jr\config.toml` as the canonical Windows
  config path.

---

## 6. Regression Risk

**Risk to existing four targets: LOW.**

- The `keyring` feature addition (`windows-native`) is cfg-gated at
  compile time; it adds no code to macOS/Linux builds.
- The `release.yml` matrix addition is a new row; the four existing rows
  are not modified.
- The packaging step is entirely new for the Windows row; the existing
  `tar czf jr` command is unchanged on macOS/Linux rows.
- `build.rs` is already correct; no changes needed.
- Source changes (if Option B path fix): `#[cfg(windows)]` branches are
  dead code on macOS/Linux.
- The `deny.toml` skip entry (if needed) would be additive and scoped to
  Windows-only crates.

**Risk to Windows target: MEDIUM (first release of a new artifact).**

- The embedded-OAuth smoke step will be skipped on Windows (no verification
  of embedded credentials in CI). The BCryptGenRandom path is tested
  implicitly by the build succeeding.
- If the keyring `windows-native` feature is omitted by mistake, auth
  silently fails at runtime. Mitigate by verifying in the Windows release
  binary that `jr auth status` returns a useful error (not silent failure)
  if no credential is stored.
- No Windows integration tests in CI (Option 1 recommendation) means
  runtime regressions on Windows are only caught by user reports or
  manual testing.

---

## 7. Open Questions for the Human Gate

The following decisions require human input before F2 (Spec Evolution)
can proceed:

**1. Which Windows target(s)?**
Recommendation: `x86_64-pc-windows-msvc` only. Confirm or add
`aarch64-pc-windows-msvc` to scope (requires cross-compilation setup;
not supported by `cross` for MSVC targets; would need a separate toolchain
investigation).

**2. Artifact format for Windows?**
Recommendation: `.zip` (PowerShell `Compress-Archive`; universally
extractable on Windows without third-party tools; conventional for CLI
tools on Windows). Alternative: `.tar.gz` of `jr.exe` (consistent with
other targets; extractable via Git Bash or WSL; less familiar to pure-
Windows users). Note: the `softprops/action-gh-release` step already
accepts arbitrary files; both formats upload cleanly.

**3. Windows CI testing (ci.yml) or release-build-only?**
Recommendation: release-build-only for v1 (Option 1). Add Windows to CI
in a follow-up cycle after integration-test isolation is fixed. Confirm
or override.

**4. Keyring backend / Windows Credential Manager acceptance?**
The `windows-native` feature stores credentials in Windows Credential
Manager under the service name `jr-jira-cli` (configurable via
`JR_SERVICE_NAME`). This is the correct integration point; confirm this
is the desired credential store (vs. an alternative like a config-file
token). No user-facing change in behavior — same as macOS Keychain /
Linux kernel keyring.

**5. Config and cache path convention on Windows?**
Option A: Accept `%USERPROFILE%\.config\jr\config.toml` (minimal code
change, non-idiomatic Windows). Option B: Use `%APPDATA%\jr\config.toml`
and `%LOCALAPPDATA%\jr` cache (idiomatic, requires `#[cfg(windows)]`
branches in config.rs and cache.rs, plus test-isolation updates). Confirm
which to include in this cycle.

**6. Embedded-OAuth smoke step on Windows?**
Recommendation: gate it `if: runner.os != 'Windows'` for v1. The
BCryptGenRandom XOR path is tested implicitly by the build; a full smoke
step port to PowerShell or bash-on-Windows can be added later. Confirm
or request the ported smoke step be in scope.

**7. ADR for this decision?**
Recommend ADR-0016 recording the Windows target choice, format, path
convention, and CI deferral. Confirm or defer the ADR.

---

## 8. Recommended Scope for This Cycle

**In scope (minimum viable Windows artifact):**
1. `Cargo.toml`: add `windows-native` to keyring features
2. `release.yml`: add `x86_64-pc-windows-msvc` matrix row with `.zip`
   packaging, smoke-step gate (`if: runner.os != 'Windows'`), and glob
   additions
3. `deny.toml`: add any required `[[bans.skip]]` entries for new Windows-
   only transitive deps
4. `docs/adr/0016-windows-build-target.md`: record the decisions
5. `CLAUDE.md`: document Windows config path and any new env vars

**Conditionally in scope (pending Open Question 5):**
6. `src/config.rs` + `src/cache.rs`: `#[cfg(windows)]` path branches
   (Option B)

**Out of scope for this cycle:**
- `aarch64-pc-windows-msvc` target
- Windows CI testing in `ci.yml`
- PowerShell-native embedded-OAuth smoke step
- `i686-pc-windows-msvc` (32-bit)
- WSL-specific behavior or testing
