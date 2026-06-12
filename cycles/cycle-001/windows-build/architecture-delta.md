---
document_type: architecture-delta
feature: windows-build
cycle: cycle-001
base_ref: 587206e
base_version: 0.6.0-dev.1
date: 2026-06-12
author: architect
status: accepted
adr: ADR-0016
traces_to: .factory/architecture/README.md
---

# Architecture Delta — Windows Build Target

This document covers the concrete architectural decisions for the windows-build feature
cycle. It is structured as a delta: only the changes from the existing architecture are
described. The baseline architecture is in `.factory/architecture/`.

The five decisions locked at the F1 human gate are implemented here. See ADR-0016 for
rationale. This document provides the "how" concrete enough for a product-owner to derive
BCs/NFRs and for F4 implementers to proceed without re-designing.

---

## 1. Per-OS Path Resolution Strategy

### 1.1 Current State

`src/config.rs::global_config_dir()` (line 466):
```rust
pub fn global_config_dir() -> PathBuf {
    if let Ok(xdg) = std::env::var("XDG_CONFIG_HOME") {
        PathBuf::from(xdg).join("jr")
    } else {
        dirs::home_dir()
            .unwrap_or_else(|| PathBuf::from("~"))
            .join(".config")
            .join("jr")
    }
}
```

`src/cache.rs::cache_root()` (line 67):
```rust
pub fn cache_root() -> PathBuf {
    if let Ok(xdg) = std::env::var("XDG_CACHE_HOME") {
        PathBuf::from(xdg).join("jr")
    } else {
        dirs::home_dir()
            .unwrap_or_else(|| PathBuf::from("~"))
            .join(".cache")
            .join("jr")
    }
}
```

On Windows, `dirs::home_dir()` returns `C:\Users\<User>`, producing `C:\Users\<User>\.config\jr`
and `C:\Users\<User>\.cache\jr`. These are functional but non-idiomatic Windows paths.

### 1.2 Target Design

Both functions receive a `#[cfg(windows)]` / `#[cfg(not(windows))]` split. The
`JR_CONFIG_DIR`/`JR_CACHE_DIR` debug seam (§2) is consulted first, before the OS branch.

**`global_config_dir()` — target shape:**

```rust
pub fn global_config_dir() -> PathBuf {
    // Debug-only isolation seam (§2). Checked before OS branch.
    // Empty string is treated as unset — mandated by BC-6.2.017 EC-1/EC-5.
    #[cfg(debug_assertions)]
    if let Some(dir) = std::env::var("JR_CONFIG_DIR").ok().filter(|s| !s.is_empty()) {
        return PathBuf::from(dir);
    }

    #[cfg(windows)]
    {
        // Windows: %APPDATA%\jr  (e.g., C:\Users\Alice\AppData\Roaming\jr)
        // APPDATA fallback also filters empty string: unset and empty both route to ".".
        // This keeps BC-6.1.014 EC-1 consistent with the seam's empty-filter contract.
        dirs::config_dir()
            .unwrap_or_else(|| {
                std::env::var("APPDATA")
                    .ok()
                    .filter(|s| !s.is_empty())
                    .map(PathBuf::from)
                    .unwrap_or_else(|| PathBuf::from("."))
            })
            .join("jr")
    }

    #[cfg(not(windows))]
    {
        // Unix: $XDG_CONFIG_HOME/jr or ~/.config/jr (unchanged)
        if let Ok(xdg) = std::env::var("XDG_CONFIG_HOME") {
            PathBuf::from(xdg).join("jr")
        } else {
            dirs::home_dir()
                .unwrap_or_else(|| PathBuf::from("~"))
                .join(".config")
                .join("jr")
        }
    }
}
```

**`cache_root()` — target shape:**

```rust
pub fn cache_root() -> PathBuf {
    // Debug-only isolation seam (§2). Checked before OS branch.
    // Empty string is treated as unset — mandated by BC-6.2.017 EC-1/EC-5.
    #[cfg(debug_assertions)]
    if let Some(dir) = std::env::var("JR_CACHE_DIR").ok().filter(|s| !s.is_empty()) {
        return PathBuf::from(dir);
    }

    #[cfg(windows)]
    {
        // Windows: %LOCALAPPDATA%\jr  (e.g., C:\Users\Alice\AppData\Local\jr)
        // LOCALAPPDATA fallback also filters empty string: unset and empty both route to ".".
        // This keeps BC-6.2.016 EC-1 consistent with the seam's empty-filter contract.
        dirs::cache_dir()
            .unwrap_or_else(|| {
                std::env::var("LOCALAPPDATA")
                    .ok()
                    .filter(|s| !s.is_empty())
                    .map(PathBuf::from)
                    .unwrap_or_else(|| PathBuf::from("."))
            })
            .join("jr")
    }

    #[cfg(not(windows))]
    {
        // Unix: $XDG_CACHE_HOME/jr or ~/.cache/jr (unchanged)
        if let Ok(xdg) = std::env::var("XDG_CACHE_HOME") {
            PathBuf::from(xdg).join("jr")
        } else {
            dirs::home_dir()
                .unwrap_or_else(|| PathBuf::from("~"))
                .join(".cache")
                .join("jr")
        }
    }
}
```

**`cache_dir()` is unchanged:**

```rust
pub fn cache_dir(profile: &str) -> PathBuf {
    cache_root().join("v1").join(profile)
}
```

The `v1/` versioning root is preserved on all platforms. The per-profile path under
Windows becomes `%LOCALAPPDATA%\jr\v1\<profile>\`.

### 1.3 Resulting Paths by Platform

| Platform | Config | Cache (per-profile) |
|----------|--------|---------------------|
| macOS/Linux (XDG set) | `$XDG_CONFIG_HOME/jr/` | `$XDG_CACHE_HOME/jr/v1/<profile>/` |
| macOS/Linux (XDG unset) | `~/.config/jr/` | `~/.cache/jr/v1/<profile>/` |
| Windows | `%APPDATA%\jr\` | `%LOCALAPPDATA%\jr\v1\<profile>\` |
| Any (debug, JR_CONFIG_DIR set) | `$JR_CONFIG_DIR/` | `$JR_CACHE_DIR/v1/<profile>/` (seam sets `cache_root()`; `cache_dir(profile)` still appends `/v1/<profile>/`) |

Note: `%APPDATA%` and `%LOCALAPPDATA%` are Windows environment variable names. `dirs::config_dir()`
resolves `%APPDATA%` (Roaming) and `dirs::cache_dir()` resolves `%LOCALAPPDATA%` (Local). The
`APPDATA`/`LOCALAPPDATA` direct env fallbacks in the `unwrap_or_else` branches are defensive
only; `dirs` should always succeed on Windows with a user profile.

### 1.4 Config File Path

`global_config_path()` is unchanged — it appends `config.toml` to `global_config_dir()`:

```rust
pub fn global_config_path() -> PathBuf {
    global_config_dir().join("config.toml")
}
```

On Windows: `%APPDATA%\jr\config.toml`. On Unix: unchanged.

### 1.5 Scope Invariant

`XDG_CONFIG_HOME`/`XDG_CACHE_HOME` env vars are consulted **only** on the `#[cfg(not(windows))]`
branch. They have no effect on Windows builds. This is intentional: XDG is a freedesktop
specification, not a Windows convention.

---

## 2. Test-Isolation Seam (CRITICAL)

### 2.1 Problem Statement

Integration tests in `tests/` use `assert_cmd` to invoke the `jr` binary as a subprocess.
The current isolation pattern (e.g., `tests/auth_output_json.rs::jr_isolated()`) sets
`XDG_CONFIG_HOME` and `XDG_CACHE_HOME` on the `Command` builder:

```rust
cmd.env("XDG_CONFIG_HOME", config_dir.path())
   .env("XDG_CACHE_HOME", cache_dir.path())
```

On Unix, `global_config_dir()` checks `XDG_CONFIG_HOME` first and resolves to the temp
directory. On Windows, `dirs` does not consult XDG env vars — the `#[cfg(windows)]` branch
calls `dirs::config_dir()` regardless. Setting `XDG_CONFIG_HOME` on a Windows runner has
no effect: tests would write to the real `%APPDATA%\jr` of the CI runner user.

### 2.2 Solution: `JR_CONFIG_DIR` / `JR_CACHE_DIR` Debug Seam

Add two debug-only env var overrides read at the top of `global_config_dir()` and
`cache_root()`, before the OS branch. This gives a single cross-platform isolation
mechanism that works by intercepting path resolution at the entry point, prior to any
OS-specific logic.

**Key properties:**

- `#[cfg(debug_assertions)]` — compiled out in `--release` builds. No production attack surface.
- Read before `#[cfg(windows)]` — works on Windows and Unix identically.
- Works across subprocess boundary — env vars propagate to child processes, which is how
  `assert_cmd` invokes `jr`.
- No in-process state — the seam is purely env-var-driven, compatible with parallel test
  execution (`cargo test` runs tests in parallel by default).
- No XDG replacement — existing Unix tests can continue using `XDG_CONFIG_HOME` and just
  add `JR_CONFIG_DIR` to their `.env()` calls for Windows compatibility. Both mechanisms
  work on Unix (the debug seam takes precedence when set).

**Implementation location:**
- `src/config.rs::global_config_dir()` — first lines of the function body, before all
  other logic.
- `src/cache.rs::cache_root()` — first lines of the function body, before all other logic.

### 2.3 Test Helper Migration

The primary helper (`tests/auth_output_json.rs::jr_isolated()`) sets both XDG vars today.
Migration: add `JR_CONFIG_DIR` and `JR_CACHE_DIR` alongside the XDG vars. The XDG vars
can remain (they are harmless on Unix and ignored on Windows):

```rust
fn jr_isolated(config_dir: &TempDir, cache_dir: &TempDir) -> Command {
    let mut cmd = Command::cargo_bin("jr").unwrap();
    cmd.env("XDG_CONFIG_HOME", config_dir.path())   // Unix isolation (unchanged)
       .env("XDG_CACHE_HOME", cache_dir.path())      // Unix isolation (unchanged)
       .env("JR_CONFIG_DIR", config_dir.path())      // Cross-platform isolation (NEW)
       .env("JR_CACHE_DIR", cache_dir.path())         // Cross-platform isolation (NEW)
       // ... rest unchanged
```

The `JR_CONFIG_DIR`/`JR_CACHE_DIR` values should be the same paths as `XDG_*` — the temp
directory root, not the `jr/` subdirectory. The seam returns `PathBuf::from(dir)` directly,
WITHOUT the `.join("jr")` suffix that the XDG and OS branches append. This is a deliberate
asymmetry: integration-test helpers must pass the path EXCLUDING the `jr/` segment (the same
value they pass to `XDG_CONFIG_HOME`), and the seam uses it as the final directory. Because
the seam takes precedence over XDG on Unix debug builds, an already-migrated test that sets
both will resolve to `<dir>` rather than `<dir>/jr` — isolation is preserved (still under the
TempDir) but the literal resolved path changes by the `jr/` segment.

**F4 MUST** grep the existing test suite for literal `/jr/config.toml`, `/jr/v1/`, or similar
path-string assertions before adding `JR_CONFIG_DIR`/`JR_CACHE_DIR` to shared test helpers,
since such assertions would break under the no-suffix seam.

### 2.4 Test Files Requiring Migration

All test files that set `XDG_CONFIG_HOME` or `XDG_CACHE_HOME` on a `Command` builder
must add the corresponding `JR_CONFIG_DIR`/`JR_CACHE_DIR` env vars. The following files
are affected (grep of `XDG_CONFIG_HOME` or `XDG_CACHE_HOME` in `tests/`):

| File | Migration needed |
|------|-----------------|
| `tests/auth_output_json.rs` | `jr_isolated()` helper — add `JR_CONFIG_DIR`, `JR_CACHE_DIR` |
| `tests/issue_list_assets.rs` | Lines ~167-168 — add both vars |
| `tests/issue_resolution.rs` | Lines ~29-30 — add both vars |
| (all other test files using `.env("XDG_*")`) | Same pattern |

Additionally, `src/config.rs` inline unit tests use `std::env::set_var("XDG_CONFIG_HOME")`
(unsafe in Rust 2024). These are in-process unit tests that DO modify global env state.
On Windows, these tests still need `std::env::set_var("JR_CONFIG_DIR")` added, because the
`global_config_dir()` function will check `JR_CONFIG_DIR` before XDG. Alternatively,
those tests can set both. F4 must handle this.

**Note on `src/cache.rs` unit tests:** Same pattern — the cache unit tests use
`std::env::set_var("XDG_CACHE_HOME")`. On Windows they need `JR_CACHE_DIR` added.

### 2.5 Release Gate Test

A new regression test `tests/config_dir_release_gate.rs` must verify that `JR_CONFIG_DIR`
and `JR_CACHE_DIR` are gated by `#[cfg(debug_assertions)]` at both read sites. This
mirrors `tests/base_url_release_gate.rs`, which is a **source-adjacency grep test** — NOT
a runtime binary execution test. A `cargo test` binary runs in debug mode and cannot
observe release behavior at runtime; the gate must therefore be verified at the source
level.

**Required assertions (mirroring `base_url_release_gate.rs` pattern exactly):**

1. **`src/config.rs` — `JR_CONFIG_DIR` read site:** `include_str!("../src/config.rs")`
   into a string, locate the `std::env::var("JR_CONFIG_DIR")` call, and assert that
   `#[cfg(debug_assertions)]` appears within ~5 lines before that call (source-adjacency
   check). This ensures the gate cannot be accidentally removed without breaking the test.

2. **`src/cache.rs` — `JR_CACHE_DIR` read site:** identical source-adjacency check using
   `include_str!("../src/cache.rs")`, locating `std::env::var("JR_CACHE_DIR")` and
   asserting `#[cfg(debug_assertions)]` within ~5 lines prior.

3. **Compile-time cfg assertion:** include a `const { assert!(cfg!(debug_assertions)); }`
   block in the test (identical to `base_url_release_gate.rs`) to make the test itself
   fail to compile when accidentally run in a release profile.

Both read sites must be pinned — mirroring how `base_url_release_gate.rs` guards both
`config.rs` (the `Config::base_url()` site) AND `client.rs` (the
`JiraClient::from_config()` site). A guard on only one of the two seam sites leaves the
other site unprotected against accidental gate removal.

### 2.6 Composition With the OS Branch

The seam composes cleanly with the OS path split:

```
JR_CONFIG_DIR non-empty? → return PathBuf::from(JR_CONFIG_DIR)  [debug only; empty treated as unset per BC-6.2.017]
     ↓ (unset, empty, or release build)
#[cfg(windows)] → dirs::config_dir().join("jr")
#[cfg(not(windows))] → XDG_CONFIG_HOME or home/.config/jr
```

There is no ambiguity: when the debug seam is set, neither the Windows nor Unix OS branch
is evaluated for that invocation.

---

## 3. `release.yml` Changes

### 3.1 New Matrix Row

Add a new matrix entry to the `build` job:

```yaml
- target: x86_64-pc-windows-msvc
  os: windows-latest
```

No `use_cross` field (defaults to false/absent). No cross-compilation needed: the MSVC
toolchain is available natively on `windows-latest`. The existing `Install cross` step
is gated `if: matrix.use_cross`, so it correctly skips for Windows.

### 3.2 Build Step

The existing `Build` step uses a bash `if/else` on `matrix.use_cross`. This step already
works on Windows with `shell: bash` because Git Bash is pre-installed on `windows-latest`.
No change to the build step is needed — the Windows row will execute the `else` branch
(`cargo build --release --target ${{ matrix.target }}`).

`shell: bash` must be specified on all `run:` steps in the build job (currently absent).
F4 must add `shell: bash` to each `run:` step in the `build` job. This is safe for all
existing rows (macOS and Linux already use bash; adding an explicit `shell: bash` is a no-op).

### 3.3 Package Step

The existing `Package` step packages `jr` (no `.exe`) into a `.tar.gz`. This fails on
Windows for two reasons: the binary is `jr.exe`, and `.tar.gz` is non-idiomatic.

Design: make the `Package` step platform-conditional via `if: runner.os != 'Windows'`
for the tar/shasum block, and add a separate Windows-specific package step:

**Unix package step** (unchanged, restricted to non-Windows):
```yaml
- name: Package (Unix)
  if: runner.os != 'Windows'
  shell: bash
  run: |
    cd target/${{ matrix.target }}/release
    tar czf ../../../jr-${{ github.ref_name }}-${{ matrix.target }}.tar.gz jr
    cd ../../..
    if command -v sha256sum &>/dev/null; then
      sha256sum jr-${{ github.ref_name }}-${{ matrix.target }}.tar.gz \
        > jr-${{ github.ref_name }}-${{ matrix.target }}.tar.gz.sha256
    else
      shasum -a 256 jr-${{ github.ref_name }}-${{ matrix.target }}.tar.gz \
        > jr-${{ github.ref_name }}-${{ matrix.target }}.tar.gz.sha256
    fi
```

**Windows package step** (new):
```yaml
- name: Package (Windows)
  if: runner.os == 'Windows'
  shell: bash
  run: |
    cd target/${{ matrix.target }}/release
    zip ../../../jr-${{ github.ref_name }}-${{ matrix.target }}.zip jr.exe
    cd ../../..
    sha256sum jr-${{ github.ref_name }}-${{ matrix.target }}.zip \
      > jr-${{ github.ref_name }}-${{ matrix.target }}.zip.sha256
```

`zip` is available via Git Bash on `windows-latest`. `sha256sum` is also available via
Git Bash. Using `shell: bash` makes both commands portable without PowerShell equivalents.

Alternative: PowerShell `Compress-Archive`. Either is acceptable. The Git Bash approach
keeps the implementation in bash throughout and is simpler.

### 3.4 Smoke Step Gate

The existing "Verify embedded OAuth app present" step must be gated off on Windows:

```yaml
- name: Verify embedded OAuth app present
  if: runner.os != 'Windows'
  ...
```

Rationale: the step uses bash heredoc, `XDG_CONFIG_HOME=$HOME/.config`, `find`, and `grep`
against the built binary. On Windows: `$HOME` is undefined; `XDG_CONFIG_HOME` is not
honored by `jr`; the `jr.exe` binary cannot be exec'd without Windows-compatible bash
invocation (the step exec's the binary directly). Porting is deferred.

The `build.rs` BCryptGenRandom path is verified implicitly: if entropy is unavailable at
build time, `build.rs` panics and the build fails before the smoke step is reached.

### 3.5 Upload-Artifact Step

The current `path:` glob is:
```yaml
path: |
  jr-*.tar.gz
  jr-*.sha256
```

The Windows artifact is `jr-*.zip` (not `.tar.gz`). The `.sha256` suffix is shared.
Update:
```yaml
path: |
  jr-*.tar.gz
  jr-*.zip
  jr-*.sha256
```

This glob picks up both Unix `.tar.gz` archives and the Windows `.zip` archive, plus all
checksum files.

### 3.6 Release Job

The `release` job runs on `ubuntu-latest` (no runner compatibility issue). The `files:`
glob in `softprops/action-gh-release` must include `.zip`:
```yaml
files: |
  jr-*.tar.gz
  jr-*.zip
  jr-*.sha256
```

This glob runs on Linux; both Unix and Windows artifacts are available via
`actions/download-artifact` with `merge-multiple: true`.

---

## 4. `ci.yml` Windows Job

### 4.1 Test Matrix Addition

Add `windows-latest` to the `test` job matrix:
```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
```

The Windows test job runs:
1. `cargo clippy --all --all-features --tests -- -D warnings` (Windows clippy, debug build)
2. `cargo test --all-features` (all tests, debug build)

The debug build activates `#[cfg(debug_assertions)]`, which enables the `JR_CONFIG_DIR`/
`JR_CACHE_DIR` seam. Tests that set these vars will isolate correctly.

The `shell:` for `run:` steps in `ci.yml` does not need to be overridden — `ci.yml`
uses `run: cargo ...` commands, which are cross-platform (`cargo` is a cross-platform
binary). No bash syntax is present in the current `ci.yml` test/clippy steps.

### 4.2 Tests at Risk on Windows

The following categories of tests require attention before Windows CI is added:

**Category A: Already gated correctly (`#[cfg(unix)]`)**

- `tests/issue_edit_field.rs::test_bc_3_4_015_cache_write_failure_warns_and_exits_0` (line 1123)
- `tests/issue_edit_field.rs::test_bc_3_4_015_cache_write_failure_warning_on_stderr_not_stdout` (line 1190)

Both use `#[cfg(unix)]` and `std::os::unix::fs::PermissionsExt` for read-only directory
testing. These are correctly excluded on Windows already. No action needed.

**Category B: Test isolation via XDG (require migration to JR_CONFIG_DIR/JR_CACHE_DIR)**

All test files that set `XDG_CONFIG_HOME`/`XDG_CACHE_HOME` on a subprocess `Command`.
On Unix these work; on Windows they are silently ignored by the binary (dirs does not
consult XDG on Windows after the `#[cfg(windows)]` branch is active).

After the path-resolution fix (§1) and seam addition (§2), these tests must add
`JR_CONFIG_DIR`/`JR_CACHE_DIR` alongside the XDG vars. The test binary compiled in debug
mode will pick up the seam.

Primary affected files:
- `tests/auth_output_json.rs` (helper `jr_isolated`)
- `tests/issue_list_assets.rs`
- `tests/issue_resolution.rs`
- All other test files discovered by `grep -r "XDG_CONFIG_HOME\|XDG_CACHE_HOME" tests/`

**Category C: Snapshot tests (line endings)**

The repo has no `.gitattributes`. `insta` snapshot files (`tests/snapshots/*.snap`) could
receive CRLF line endings if Windows committers write them. This would cause snapshot
mismatches across platforms.

Mitigation: add a `.gitattributes` entry before the first Windows CI run:
```
*.snap text eol=lf
```

This forces LF on all snapshot files regardless of committer OS. F4 must add this file.

**Category D: Keyring-gated tests (`JR_RUN_KEYRING_TESTS=1`, `#[ignore]`)**

These call the real system keychain. On Windows with `windows-native` enabled, they call
Windows Credential Manager. In a headless CI environment, Credential Manager should
succeed without a UI prompt (service accounts have access). The existing `#[ignore]` gate
and `JR_RUN_KEYRING_TESTS=1` env var protect against accidental execution.

Status: no Windows-specific action needed. The existing gating is sufficient. The tests
are not run in standard `cargo test` without `--include-ignored`.

**Category E: E2E tests (`JR_RUN_E2E=1`, `#[ignore]`)**

E2E tests make live Jira API calls. They are gated by `JR_RUN_E2E=1` and `#[ignore]`.
The Windows `ci.yml` test step does not set `JR_RUN_E2E` — E2E tests will not run.

Status: no action needed. The existing two-layer gate (workflow-level `JR_E2E_ENABLED` +
test-level `JR_RUN_E2E`) applies on Windows the same as macOS/Linux.

**Category F: `/tmp` path assumptions**

No hardcoded `/tmp` paths found in `tests/`. Tests use `tempfile::TempDir::new()` which
resolves to `%TEMP%` on Windows. No action needed.

**Category G: `insta` snapshot reviewer paths**

`insta` uses `INSTA_UPDATE` env var for snapshot update mode. No platform-specific
behavior expected. No action needed.

**Category H: `cargo test` parallelism on Windows**

`cargo test` runs tests in parallel by default. The `ENV_MUTEX` pattern in `src/config.rs`
and `src/cache.rs` unit tests (a `Mutex<()>` serializing tests that mutate global env
vars) is platform-agnostic. No action needed for unit tests.

For subprocess integration tests, each test launches an isolated subprocess with its own
env vars — parallelism is safe because each process sees its own environment.

### 4.3 `fmt` and `deny` Jobs

`fmt` and `deny` run only on `ubuntu-latest`. No Windows runner needed — formatting and
license checking are platform-independent. No change to these jobs.

---

## 5. Keyring `windows-native` Feature

### 5.1 Cargo.toml Change

Current:
```toml
keyring = { version = "3", features = ["apple-native", "linux-native"] }
```

Target:
```toml
keyring = { version = "3", features = ["apple-native", "linux-native", "windows-native"] }
```

The three features are mutually non-exclusive and each is `cfg`-gated to its OS at compile
time. Adding `windows-native` adds dead code on macOS and Linux (the Cargo feature is
compiled in, but the OS-conditional Rust code is inactive). This is standard practice and
confirmed correct by the keyring crate documentation.

### 5.2 Credential Manager Key Layout

The per-profile keychain layout in `src/api/auth.rs` uses:
- Service name: `jr-jira-cli` (configurable via `JR_SERVICE_NAME`)
- Shared keys: `email`, `api-token`, `oauth_client_id`, `oauth_client_secret`
- Per-profile keys: `<profile>:oauth-access-token`, `<profile>:oauth-refresh-token`

Windows Credential Manager stores credentials as entries with a `target_name` (the
composite of service and username), `username`, and `credential_blob`. The `keyring` crate
maps this transparently. The colon separator in `<profile>:oauth-access-token` is valid
in Windows Credential Manager target names.

**Gotcha — colon in profile-namespaced keys:** keyring `windows-native` uses
`CRED_TYPE_GENERIC` credentials via `CredWriteW`. Windows Credential Manager validates only
that the target name is non-empty and within length limits — the colon character is accepted
without restriction. The `<profile>:oauth-access-token` / `<profile>:oauth-refresh-token`
naming scheme is portable to Windows UNCHANGED with no sanitization required (verified
against keyring-rs v3.6.3 `src/windows.rs` + Microsoft `CredWriteW` documentation,
2026-06-12).

No source changes to `src/api/auth.rs` are required. The keyring abstraction handles the
platform difference internally.

### 5.3 `deny.toml` Verification

After adding `windows-native`, run `cargo deny check` to verify no new version conflicts.
The existing `deny.toml` has `[[bans.skip]]` entries for `windows-sys 0.45` (from `jni`)
vs `0.61.2` (majority tree). The `windows-native` feature in keyring v3.6.3 uses
`windows-sys 0.61` (same major as the majority tree). A new skip entry is unlikely needed,
but must be verified at F4 implementation time. If `cargo deny check` exits 1, add the
minimal `[[bans.skip]]` entry for the specific version conflict.

---

## 6. OAuth Loopback (Port 53682)

### 6.1 Cross-Platform Status

The OAuth callback listener in `src/api/auth.rs` uses:
```rust
std::net::TcpListener::bind("127.0.0.1:53682")  // synchronous bind
tokio::net::TcpListener  // async accept
```

Both are fully cross-platform. `127.0.0.1` forces IPv4 loopback, avoiding the
macOS/Chrome `localhost` → `::1` (IPv6) resolution issue (ADR-0006). This same binding
behavior is correct on Windows — the Windows TCP stack listens on `127.0.0.1` IPv4
without ambiguity.

No code changes required for the OAuth loopback listener.

### 6.2 Windows Firewall

On first run, Windows Firewall may present a dialog asking the user to allow inbound
connections to `jr.exe` on port 53682. This is a one-time user-facing event.

Design position: this is a documented consequence, not a code change. The firewall prompt
only appears for inbound connections; the `jr` OAuth flow binds the listener momentarily
during the authorization callback (the browser redirects to `http://127.0.0.1:53682/callback`,
which is a loopback connection — traffic never leaves the machine). Windows Firewall
typically does not block loopback connections; the prompt may not appear at all. However,
enterprise firewall policies vary. This is documented in the CHANGELOG for the Windows
release.

---

## 7. DTU Re-Assessment

**DTU_REQUIRED: false for this delta.**

The windows-build feature introduces no new external service dependencies. The change set
is:
- A new build target (compiler/toolchain change)
- A new CI runner (`windows-latest`)
- A new Cargo feature (`windows-native` in keyring — uses Windows Credential Manager,
  which is a local OS API, not an external service)
- Runtime path changes (OS APIs via the `dirs` crate — local OS, not network)

The six DTU integration surface categories from the baseline `dtu-assessment.md` are
unchanged:

| Category | Status |
|----------|--------|
| Inbound data sources | None — unchanged |
| Outbound operations | Atlassian REST API — unchanged |
| Identity & access | Atlassian OAuth 2.0 — unchanged |
| Persistence & state | OS keychain (now includes WCM) — local OS API, not external |
| Observability & export | None — unchanged |
| Enrichment & lookup | None — unchanged |

Windows Credential Manager is an OS-level API accessed via the `windows-sys` crate
(statically linked). It is not a network service. It does not require a DTU behavioral
clone. No new third-party API integration is introduced.

---

## 8. ADR-Index Update

ADR-0016 must be added to the ADR registry in `.factory/architecture/adr-index.md`:

| ADR | Title | Status | Architecture Section |
|-----|-------|--------|---------------------|
| [ADR-0016](adr/0016-windows-build-target.md) | Windows Build Target (x86_64-msvc, .zip, AppData Paths, WCM, CI) | **Accepted** | this document |

---

## 9. BC/NFR Candidates for Product-Owner

The following new BCs and NFR updates are surfaced by this architecture. These are handed
to the product-owner for F2 PRD delta work. They are NOT written here — this section is
an input brief, not spec output.

### New NFR

**NFR-P-W1 — Supported Platforms (new)**

Define the supported platform tier. Proposed content:
- `x86_64-pc-windows-msvc`: full support, pre-built `.zip` artifact distributed via
  GitHub Releases, CI-tested on every PR.
- `x86_64-apple-darwin`, `aarch64-apple-darwin`: full support (unchanged).
- `x86_64-unknown-linux-gnu`: full support (unchanged).
- `aarch64-unknown-linux-gnu`: full support (unchanged).
- `aarch64-pc-windows-msvc`: not supported this cycle; deferred.

### New BCs

**BC-6.1.W01 — Windows config path (new)**

When running on Windows, `jr` resolves the global configuration directory to
`%APPDATA%\jr\` (equivalent to `dirs::config_dir()` + `\jr`). The configuration file
is at `%APPDATA%\jr\config.toml`. XDG environment variables (`XDG_CONFIG_HOME`) are
not consulted on Windows.

**BC-6.1.W02 — Windows cache path (new)**

When running on Windows, `jr` resolves the cache root to `%LOCALAPPDATA%\jr\` (equivalent
to `dirs::cache_dir()` + `\jr`). Per-profile cache is at `%LOCALAPPDATA%\jr\v1\<profile>\`.
The `v1/` versioning root is present on all platforms.

**BC-6.2.W01 — Debug config/cache seam (new)**

When the `JR_CONFIG_DIR` environment variable is set in a debug build, `jr` uses that
directory as the config root, bypassing the OS-determined path. When `JR_CACHE_DIR` is
set in a debug build, `jr` uses that directory as the cache root. These overrides have
no effect in release builds. (Mirrors BC pattern established by BC-T.1.001 for
`JR_BASE_URL`.)

### Updated BCs

**BC-6.2.004** — Cache root path (currently Unix-implicit)

Add a platform-conditional clause: "On Windows, the cache root is `%LOCALAPPDATA%\jr\`
(see BC-6.2.016). On macOS and Linux, the cache root is as specified above."

**BC-6.1.001, BC-6.1.002** — NO change required. These BCs govern config MIGRATION
semantics (`[instance]/[fields]` → `[profiles.default]`, idempotent write-back). They are
NOT path-discovery contracts. Windows config-path behavior is fully captured by the new
BC-6.1.014. No platform-conditional clause is needed in BC-6.1.001 or BC-6.1.002.

### Provisional W-ID Reconciliation

The W-IDs used as placeholders above map to the delivered BC IDs as follows:

`BC-6.1.W01 → BC-6.1.014` (Windows config path)
`BC-6.1.W02 → BC-6.2.016` (Windows cache path; landed in the cache subsection, not config)
`BC-6.2.W01 → BC-6.2.017` (Debug config/cache seam)

### Updated NFRs

Any existing NFR covering build/packaging must acknowledge the new artifact format
(`.zip` for Windows, `.tar.gz` for Unix).

---

## 10. Risk Register Delta

| Risk ID | Description | Severity | Mitigation |
|---------|-------------|----------|------------|
| R-W1 | `windows-native` keyring feature pulls incompatible `windows-sys` version | MEDIUM | Run `cargo deny check` at F4; add `[[bans.skip]]` if needed |
| R-W2 | `JR_CONFIG_DIR` debug seam present in debug builds of the final release binary (expected) — ensure `#[cfg(debug_assertions)]` gate is not accidentally removed | LOW | `tests/config_dir_release_gate.rs` regression test pins the gate |
| R-W3 | Snapshot test CRLF contamination from Windows committers | LOW | Add `.gitattributes` with `*.snap text eol=lf` before Windows CI is active |
| R-W4 | Embedded-OAuth smoke step skipped on Windows — embedded creds not verified for Windows artifact | MEDIUM | Documented accepted risk for v1; ported smoke step deferred to follow-up cycle |
| R-W5 | XDG isolation tests not migrated before Windows CI added — tests write to real CI user profile | HIGH | Migration of test helpers is F4 prerequisite before `windows-latest` is added to `ci.yml` |
