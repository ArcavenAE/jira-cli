# Windows-Build Feature Cycle (F4) — Pre-Implementation Verification Research

**Date:** 2026-06-13
**Researcher:** research-agent (external verification)
**Scope:** Verify load-bearing, externally-grounded technical claims in the Windows-build feature cycle BEFORE implementing remaining stories (S-WIN-1..5).
**Skepticism mandate:** Prior F2 research on this cycle had two claims corrected (rustls-platform-verifier not webpki-roots; no colon-sanitization needed). This pass re-verifies against primary sources and treats Perplexity deep-research synthesis as a *lead*, not a verdict — every verdict below is anchored to a primary source (crate Cargo.toml / docs.rs platform table / runner-images manifest / Rust edition guide).

> **CRITICAL META-FINDING:** During this research, the Perplexity `sonar-deep-research` model produced **two confidently-worded but factually WRONG** synthesized answers that were caught and overturned by primary sources:
> 1. It claimed keyring's Windows feature is named `wincred` pulling `windows-sys 0.45`. **FALSE** — primary source (keyring v3.6.3 Cargo.toml) shows the feature is `windows-native` pulling `windows-sys 0.60`.
> 2. It claimed reqwest's bare `rustls` feature "exclusively maps to webpki-roots... does NOT use rustls-platform-verifier." **FALSE** — primary source (reqwest v0.13.0 Cargo.toml) shows `rustls = ["__rustls-aws-lc-rs", "dep:rustls-platform-verifier", "__rustls"]`.
>
> Both fabrications are exactly the failure class the user warned about. **All verdicts below rest on primary sources, not the deep-research prose.**

---

## Grounded versions (from `Cargo.toml` / `deny.toml`)

| Dependency | Version in Cargo.toml | Relevant features |
|------------|----------------------|-------------------|
| edition | `2024` | rust-version `1.85` |
| `dirs` | `6` | — |
| `keyring` | `3` | `["apple-native", "linux-native"]` (NO `windows-native` currently) |
| `reqwest` | `0.13` | `default-features = false, features = ["json", "rustls"]` |
| `rustls` (via reqwest) | `0.23.4` (transitive) | TLS path |

`deny.toml` existing `windows-sys` skips: **0.45** (via jni/rustls-platform-verifier) and **0.61** (broad graph). **No 0.60 skip exists.**

---

## Verdict Table

| Claim | Verdict | Primary citation | Correction needed |
|-------|---------|------------------|-------------------|
| **C-V1** — `dirs` 6 Windows path semantics | **CONFIRMED** | docs.rs/dirs/6.0.0 `config_dir`/`cache_dir` platform tables | None |
| **C-V2(a)** — keyring `windows-native` feature → Win Credential Manager | **CONFIRMED** | keyring v3.6.3 `Cargo.toml` `[features]` + docs.rs | None |
| **C-V2(b)** — windows-sys covered by existing deny skips? | **REFUTED** | keyring v3.6.3 Cargo.toml pulls **windows-sys 0.60**; deny.toml has only 0.45 + 0.61 | **YES — add `[[bans.skip]]` for windows-sys 0.60** |
| **C-V3** — windows-latest ships Git Bash `zip` + `sha256sum` | **PARTIALLY-CONFIRMED** | sha256sum: coreutils (CONFIRMED). `zip`: NOT in Git-for-Windows / not in runner Tools manifest (REFUTED) | **YES — do NOT assume `zip` on PATH; use 7z/Compress-Archive or install zip** |
| **C-V4** — Linux clippy does NOT lint `#[cfg(windows)]`; separate Windows clippy job required | **CONFIRMED** | Rust Reference (conditional compilation) + clippy-as-compiler-driver semantics | Minor: job may *target* Windows via `--target` OR run on a Windows runner |
| **C-V5** — native msvc build + Windows cert-store TLS verification | **CONFIRMED** | reqwest v0.13.0 Cargo.toml (`rustls` → `dep:rustls-platform-verifier` + aws-lc-rs); rustls-platform-verifier 0.6 docs | Note: backend is **aws-lc-rs**, not ring |
| **C-V6** — Rust 2024 `set_var`/`remove_var` are `unsafe` | **CONFIRMED** | Rust 2024 Edition Guide "Newly unsafe functions" | None |

---

## Per-Claim Detail

### C-V1 — `dirs` 6 Windows path semantics — CONFIRMED

Primary source: docs.rs/dirs/6.0.0 per-function platform tables.

`config_dir()`:

| Platform | Value | Example |
|----------|-------|---------|
| Linux | `$XDG_CONFIG_HOME` or `$HOME/.config` | `/home/alice/.config` |
| macOS | `$HOME/Library/Application Support` | `/Users/Alice/Library/Application Support` |
| **Windows** | **`{FOLDERID_RoamingAppData}`** | **`C:\Users\Alice\AppData\Roaming`** |

`cache_dir()`:

| Platform | Value | Example |
|----------|-------|---------|
| Linux | `$XDG_CACHE_HOME` or `$HOME/.cache` | `/home/alice/.cache` |
| macOS | `$HOME/Library/Caches` | `/Users/Alice/Library/Caches` |
| **Windows** | **`{FOLDERID_LocalAppData}`** | **`C:\Users\Alice\AppData\Local`** |

- (a) **CONFIRMED:** `config_dir()` → `{FOLDERID_RoamingAppData}` (Roaming = `%APPDATA%`). The docs use the Known-Folder identifier; `%APPDATA%` is the environment-variable name for the same folder. They are the same location.
- (b) **CONFIRMED:** `cache_dir()` → `{FOLDERID_LocalAppData}` (Local = `%LOCALAPPDATA%`).
- (c) **CONFIRMED:** XDG appears ONLY in the Linux rows of both tables. The Windows column references no XDG variable. `dirs` is the XDG-aware-on-Unix crate; on Windows it resolves via known folders only.

**Note on the deep-research narrative:** The Perplexity answer for C-V1 reached the *correct* conclusion but was padded with fabricated specifics (a "PR #87", a "windows_ignores_xdg_vars" test, a multi-version evolution story). These details were NOT verified and should be disregarded; the docs.rs platform table is the authority. The *conclusion* (Roaming config / Local cache / no XDG on Windows) is sound.

Spec anchors BC-6.1.014, BC-6.2.016, S-WIN-1 are correct as written. **No correction needed.**

Sources:
- https://docs.rs/dirs/6.0.0/dirs/fn.config_dir.html
- https://docs.rs/dirs/6.0.0/dirs/fn.cache_dir.html

---

### C-V2 — keyring `windows-native` feature + windows-sys dependency

**(a) Feature name + backend — CONFIRMED.** Primary source: keyring v3.6.3 `Cargo.toml` `[features]`:

```toml
windows-native = ["dep:windows-sys", "dep:byteorder"]
apple-native   = ["dep:security-framework"]
linux-native   = ["dep:linux-keyutils"]
```

docs.rs/keyring/3.6.3 confirms: *"windows-native: Provides access to the Windows Credential Store on Windows."* (= Windows Credential Manager / wincred backend). The feature name is **`windows-native`** — symmetric with the `apple-native` / `linux-native` features already enabled in jr's Cargo.toml. ADR-0016 Decision 5b is correct.

> The Perplexity deep-research claim that the feature is `wincred` pulling windows-sys 0.45 is **REFUTED** by the Cargo.toml — there is no `wincred` feature in keyring 3.x.

**(b) windows-sys version + deny.toml coverage — REFUTED (correction required). [SCOPE ANNOTATION 2026-06-13: this finding correctly identified windows-sys 0.60 but did NOT trace the full transitive fan-out — see annotation at end of this section. Corrected count: 7 arch crates skipped per tier, not 8; windows_i686_gnullvm has no 0.42 tier and is not skipped; total entries = 17 exactly.]** Primary source: keyring v3.6.3 `Cargo.toml`:

```toml
[target.'cfg(target_os = "windows")'.dependencies]
byteorder   = { version = "1.2", optional = true }
windows-sys = { version = "0.60", features = ["Win32_Foundation", "Win32_Security_Credentials"], optional = true }
```

keyring's `windows-native` pulls **windows-sys 0.60** — a version **not currently skipped** in `deny.toml` (which only skips 0.45 and 0.61). Under `bans.multiple-versions = "deny"`, the graph would then carry **three** distinct windows-sys versions (0.45, 0.60, 0.61). In 0.x SemVer the minor is the effective major, so 0.60 and 0.61 are incompatible and Cargo will NOT unify them. `cargo deny check bans` will therefore **FAIL** until a new skip is added.

**Required correction — add to `deny.toml` in the SAME commit that adds `keyring` `windows-native`:**

```toml
[[bans.skip]]
name = "windows-sys"
version = "0.60"
reason = "keyring v3.6.3 windows-native feature requires windows-sys 0.60 (Win32_Security_Credentials); jni (via rustls-platform-verifier) requires 0.45 and the broad graph (clap/tokio/reqwest) requires 0.61. Three semver-incompatible 0.x majors; unification blocked upstream until keyring bumps windows-sys."
```

> NOTE: `windows-sys` is `cfg(target_os = "windows")`-gated, so this duplicate only materializes when building/checking for a Windows target. Confirm whether `cargo deny check` in jr's CI runs against the Windows target graph (cargo-deny evaluates all targets by default unless `[graph] targets` is restricted). If jr's deny config is target-restricted to host-only, the skip may not be strictly required for a Linux-host `cargo deny` run — but adding the skip is the safe, forward-compatible action and is required the moment a Windows-target deny check runs. Verify jr's `[graph]` section in deny.toml (not present in current file → cargo-deny defaults to all targets → skip IS needed).

Sources:
- https://github.com/hwchen/keyring-rs/blob/v3.6.3/Cargo.toml
- https://docs.rs/keyring/3.6.3/keyring/
- https://crates.io/crates/windows-sys/0.60.0

> **[SCOPE ANNOTATION — implementation-confirmed, 2026-06-13]**
>
> This finding correctly identified that `windows-sys 0.60` was not covered by the existing
> `deny.toml` skip entries and that a new skip was required. However, it did NOT trace the
> transitive dependency fan-out that a new `windows-sys` minor mechanically introduces.
>
> **What the research missed:** `windows-sys 0.60` transitively pulls `windows-targets 0.53.x`
> and 7 `windows_*` architecture crates at the 0.53.x tier. Combined with the pre-existing
> 0.42.x lineage (jni → windows-sys 0.45 → rustls-platform-verifier) and the 0.52.x lineage
> (ring → windows-sys 0.52), the S-WIN-3 Cargo.lock carries `windows-targets` at **three**
> versions (0.42.2, 0.52.6, 0.53.5) and 7 `windows_*` arch crate families at the same
> three tiers. Note: `windows_i686_gnullvm` is NOT skipped — it has no 0.42 tier (the
> i686-gnullvm stub did not exist in the 0.42 generation); only 2 versions appear in
> Cargo.lock (0.52.6, 0.53.1) and `cargo deny` tolerates it without a skip; adding a skip
> would produce an unmatched-skip error.
>
> **Corrected full scope (implementation-confirmed via `cargo deny check` EXIT 0 in S-WIN-3
> worktree):** `cargo deny check` under `bans.multiple-versions = "deny"` required exactly
> **17** `[[bans.skip]]` entries — not 1 — to pass: 1 (`windows-sys 0.60`) + the 0.42 tier
> (`windows-targets 0.42` + 7 `windows_*` arch crates at 0.42) + the 0.53 tier
> (`windows-targets 0.53` + 7 `windows_*` arch crates at 0.53) = 1 + 2 × (1 + 7) = 17.
> The 0.52.6 lineage is left as the single un-skipped canonical version.
>
> **Root cause of research gap:** C-V2(b) was a per-crate point claim ("windows-sys 0.60
> needs a skip") and did not apply the windows-sys ecosystem rule that each minor version
> ships a paired `windows-targets` minor and full arch-crate tier. The downstream
> architecture-delta §5.3 and ADR-0016 Decision 5b both inherited this gap by propagating
> the single-entry characterization. All three have been corrected (2026-06-13).
>
> **Process lesson (codified as PG-WIN3-001 in architecture-delta §10):** When enabling any
> Cargo feature that pulls a NEW `windows-sys` minor, budget the deny skip set as a tier
> (~9 entries per new `windows-targets` lineage), not a single `windows-sys` entry.

---

### C-V3 — windows-latest runner: Git Bash `zip` + `sha256sum` — PARTIALLY-CONFIRMED

**`sha256sum` — CONFIRMED available.** Git for Windows bundles GNU coreutils, which includes `sha256sum.exe` at `C:\Program Files\Git\usr\bin\sha256sum.exe`. It is on PATH under `shell: bash` (Git Bash) on windows-2022/windows-2025 runners. No reports of it being missing.

**`zip` — REFUTED (NOT guaranteed).** This is a genuine release-artifact correctness risk and contradicts the spec's risk-acceptance.

Evidence (multiple independent primary/community sources):
1. **MSYS2 package index** lists `zip` as a *separately installable* package (`pacman -S zip`) — it is NOT part of the coreutils/base set Git for Windows bundles. (https://packages.msys2.org/package/zip)
2. **Git for Windows runner manifest** (Windows2022-Readme / Windows2025-Readme): Git 2.54.0.windows.1 is listed; the "Tools" section lists `7zip` and `zstd` but **does NOT list `zip`** (the Info-ZIP Unix command) as an installed tool.
3. **Azure CLI issue #27842** ("Missing 'zip' command"): documents `bash: line N: zip: command not found` and confirms `zip` must be installed manually in MSYS2/Git-Bash-style environments. (https://github.com/Azure/azure-cli/issues/27842)
4. **actions/runner-images #9361**: 7-Zip was *removed* from windows-latest (closed "not planned"), showing GitHub actively trims compression tools — you cannot assume any particular zip/7z tool is present long-term. (https://github.com/actions/runner-images/issues/9361)
5. Widespread community guides exist solely to add `zip.exe` to `C:\Program Files\Git\usr\bin` from GnuWin32 — their existence is proof of default absence.
6. Cross-platform-zip guidance (mysticmind.dev, zip-release action) universally recommends 7z/`Compress-Archive`/RUNNER_OS-branching on Windows *because* `zip` is unavailable there.

**Required correction to ADR-0016 Decision 2 / S-WIN-4:** Do NOT rely on the Unix `zip` command being on the windows-latest PATH. The release-artifact zip step on Windows MUST use one of:
- PowerShell `Compress-Archive` (`shell: pwsh` / `shell: powershell`) — most reliable, always present;
- `7z a` (if 7-Zip present — but #9361 shows it can be removed; verify or install);
- a cross-platform action (e.g. `TheDoctor0/zip-release`) that uses 7z on Windows;
- explicitly install `zip` (choco/scoop/GnuWin32) before the bash zip step.

`sha256sum` may continue to be used as-is in a bash step (CONFIRMED present). The mixed dependency (sha256sum-ok, zip-not-ok) means a single `shell: bash` step that does both `zip ...` then `sha256sum ...` will fail at the `zip` line. Split the archive creation (PowerShell/7z) from the checksum (bash `sha256sum`), or compute the checksum in PowerShell too (`Get-FileHash -Algorithm SHA256`).

Sources:
- https://github.com/actions/runner-images/blob/main/images/windows/Windows2022-Readme.md
- https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md
- https://packages.msys2.org/package/zip
- https://github.com/Azure/azure-cli/issues/27842
- https://github.com/actions/runner-images/issues/9361
- https://mysticmind.dev/how-to-create-a-cross-platform-zip-archive-using-github-actions/

---

### C-V4 — Linux clippy does not lint `#[cfg(windows)]`; separate Windows clippy job required — CONFIRMED

Rust resolves `#[cfg(...)]` predicates *before* name resolution, type-checking, and linting. Clippy is a rustc compiler driver — it only ever sees the items the compiler includes for the **active compilation target**. When `cargo clippy` runs on `ubuntu-latest` (default target `x86_64-unknown-linux-gnu`), `#[cfg(windows)]` evaluates false, so those items are stripped before clippy runs and are **never linted**. Therefore a Linux-only clippy run cannot enforce `-D warnings` on Windows-only branches; a job whose *target* is Windows is required.

**Refinement (minor correction to phrasing):** What matters is the **compilation target**, not the host OS. Two valid ways to lint `#[cfg(windows)]` with `-D warnings`:
1. Run clippy natively on a `windows-latest` runner (target defaults to msvc). ← simplest, matches ADR-0016 Decision 3 amended.
2. Cross-lint from any host: `cargo clippy --target x86_64-pc-windows-msvc` (requires `rustup target add x86_64-pc-windows-msvc`; note cross-*linking* native Windows deps may still need the MSVC target std, which `rustup` provides for check/clippy without a full MSVC linker for pure check passes).

The architecture-delta §4.1 / S-WIN-5 AC-006 premise (a dedicated Windows clippy job is genuinely required because Linux clippy skips cfg(windows) code) is **CONFIRMED**. The adversary's correction of ADR-0016's original (false) claim stands. Recommend the report/story note that option 1 (native windows runner) is the chosen mechanism, since a native-build job is needed anyway for C-V5.

Sources:
- Rust Reference — Conditional compilation: https://doc.rust-lang.org/reference/conditional-compilation.html
- Clippy is a rustc driver (operates post-cfg-strip): https://doc.rust-lang.org/clippy/

---

### C-V5 — native msvc build + Windows system-cert-store TLS verification — CONFIRMED

Primary source: reqwest v0.13.0 `Cargo.toml`:

```toml
default     = ["default-tls", "charset", "http2", "system-proxy"]
default-tls = ["rustls"]
rustls      = ["__rustls-aws-lc-rs", "dep:rustls-platform-verifier", "__rustls"]
__rustls    = ["dep:hyper-rustls", "dep:tokio-rustls", "dep:rustls", "__tls"]

rustls-platform-verifier = { version = "0.6", optional = true }
rustls                   = { version = "0.23.4", optional = true, default-features = false, features = ["std", "tls12"] }
```

- (a) **Native build — CONFIRMED clean.** `reqwest` + `rustls` on `x86_64-pc-windows-msvc` builds natively on a windows-latest runner with the standard Rust+MSVC toolchain (preinstalled on the image). No OpenSSL, no vcpkg, no cross-compilation gymnastics. The crypto provider is **aws-lc-rs** (via `__rustls-aws-lc-rs`), which ships prebuilt/CMake-buildable bindings that compile under MSVC. (Correction to a common assumption: it is **aws-lc-rs**, not ring — the deep-research "ring backend" claim is wrong for reqwest 0.13's default `rustls` feature.)
- (b) **Windows cert-store verification — CONFIRMED.** jr's exact feature set (`features = ["json", "rustls"]`, `default-features = false`) activates the `rustls` feature, which pulls **`dep:rustls-platform-verifier` 0.6**. Per rustls-platform-verifier 0.6 docs, on Windows it verifies the server certificate chain against the **Windows platform certificate store via the Windows API** (CertGetCertificateChain / CryptoAPI), with OS CA constraints and revocation (OCSP/CRL) taken into account. Atlassian (`*.atlassian.net`) chains to publicly-trusted roots present in the Windows root store, so authenticated HTTPS to Atlassian **works out of the box on Windows** with no bundled-roots gap.

> This directly **confirms the prior F2 C4 correction** (rustls-platform-verifier, NOT webpki-roots) and **REFUTES** the Perplexity deep-research claim that reqwest's `rustls` feature uses webpki-roots without the platform verifier. The Cargo.toml is unambiguous: `dep:rustls-platform-verifier` is in the `rustls` feature's dependency list.

NFR-P-W1 and ADR-0003/ADR-0016 are correct. **No correction needed**, but recommend the spec explicitly name the verifier (rustls-platform-verifier 0.6) and the provider (aws-lc-rs) to prevent the webpki-roots misconception from recurring.

Sources:
- https://github.com/seanmonstar/reqwest/blob/v0.13.0/Cargo.toml
- https://docs.rs/rustls-platform-verifier/0.6.0/rustls_platform_verifier/

---

### C-V6 — Rust 2024 `std::env::set_var`/`remove_var` are `unsafe` — CONFIRMED

Per the Rust 2024 Edition Guide, "Newly unsafe functions": `std::env::set_var` and `std::env::remove_var` **are marked `unsafe` in the 2024 edition** and require an `unsafe` block (plus, by jr convention, a `// SAFETY:` justification). The `unsafe` marker is edition-gated (still safe to call from 2018/2021 even on the same compiler), motivated by data-race hazards of mutating the process environment while other threads read it. jr is `edition = "2024"`, so the S-WIN-2 tests' single-threaded / mutex-guarded usage with SAFETY comments is **correct and required**.

ADR/story anchor for S-WIN-2 is correct. **No correction needed.**

Sources:
- https://doc.rust-lang.org/edition-guide/rust-2024/newly-unsafe-functions.html

---

## Actions Required Before F4 Implementation

1. **(BLOCKER, C-V2b)** Add `[[bans.skip]]` for `windows-sys 0.60` to `deny.toml` in the same commit that adds keyring `windows-native`. Verify jr's deny.toml has no `[graph] targets` restriction (it does not → all-target evaluation → skip is needed). Without it, `cargo deny check` fails.
2. **(BLOCKER, C-V3)** Amend ADR-0016 Decision 2 + S-WIN-4: the Windows release-artifact zip step MUST NOT use the Unix `zip` command (not on PATH). Use `Compress-Archive` (pwsh) or 7z/cross-platform action; keep `sha256sum` in a separate bash step (or use `Get-FileHash -Algorithm SHA256`).
3. **(NOTE, C-V5)** Update spec wording to name **rustls-platform-verifier 0.6** + **aws-lc-rs** explicitly, to inoculate against the recurring "webpki-roots" misconception.
4. **(NOTE, C-V4)** Confirm the Windows clippy job runs natively on `windows-latest` (chosen mechanism) and reuses the same job as the native build (C-V5) where practical.
5. No changes needed for C-V1 or C-V6.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 5 | dirs 6 Windows semantics; keyring windows-native feature/deps; clippy + cfg(windows); reqwest rustls TLS path; Git-for-Windows zip/sha256sum. **2 of 5 returned confidently-wrong syntheses (keyring wincred/0.45; reqwest webpki-roots) — both overturned by primary-source WebFetch.** |
| Perplexity perplexity_reason | 1 | Logical synthesis: does windows-sys 0.60 require a new deny.toml skip under multiple-versions=deny + 0.x semver. |
| Perplexity perplexity_search | 1 | Locate actions/runner-images Windows manifests. |
| Perplexity perplexity_ask | 1 | Rust 2024 set_var/remove_var unsafe (single factual lookup, C-V6). |
| Context7 | 0 | (Primary-source Cargo.toml fetches via WebFetch were more direct for version-exact verification.) |
| WebFetch | 9 | PRIMARY-SOURCE verification: dirs 6 config_dir/cache_dir docs.rs tables; keyring v3.6.3 Cargo.toml (x3); reqwest v0.13.0 Cargo.toml; rustls-platform-verifier 0.6 docs; Windows2022/2025 runner manifests; runner-images #9361. |
| WebSearch | 2 | Corroborate zip-not-available community evidence; runner-image zip.exe PATH. |
| Read | 4 | jr Cargo.toml, deny.toml, persisted Perplexity outputs (keyring, reqwest, zip). |
| Training data | 0 areas | No verdict rests on model knowledge; every verdict cites a primary source. |

**Total MCP tool calls:** 8 (5 research + 1 reason + 1 search + 1 ask).
**Training data reliance:** low — all six verdicts are anchored to primary sources (crate Cargo.toml, docs.rs platform tables, runner-images manifests, MSYS2 package index, Rust edition guide). Perplexity deep-research was used as a lead generator; two of its syntheses were factually refuted and discarded.
