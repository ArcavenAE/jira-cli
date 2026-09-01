---
context: bc-6
title: "Configuration & Cache"
total_bcs: 44   # cumulative claim (incl. range-collapsed; +3 windows-build F2 2026-06-12: BC-6.1.014, BC-6.2.016, BC-6.2.017; +1 added 2026-06-27: BC-6.2.018 cache warm-hit no-HTTP invariant; +1 added 2026-09-01 cycle-003 auth-profile-dx: BC-6.1.015 `env` config-schema tag)
definitional_count: 34   # count of `#### BC-` headings in this file (+3 windows-build F2 2026-06-12; +1 added 2026-06-27; +1 added 2026-09-01 cycle-003 auth-profile-dx)
last_updated: 2026-09-01
source_pass: 3
adversary_fixes: "F-1/F-2/F-5/F-6 applied 2026-06-12 (windows-build Phase F2 adversarial review); cycle-003 auth-profile-dx F2 spec-evolution 2026-09-01: BC-6.2.015 amended (ADR-0011 hard-fence un-defer, DEC-317), BC-6.1.015 added (`env` tag, DEC-314/ADR-0020 §4); F2-gate fix findings applied 2026-09-01: BC-6.2.015 SR-006 (auth.rs scope + ~60-80 estimate) + CV-1 (ADR-0011 status citation precision), BC-6.1.015 FIX-C (display-sanitization EC + `.jr.toml` injection-path finding: none)"
trace: |
  - L2: .factory/specs/domain-spec/bc-06-config-cache.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.10-2.11
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.5-3.7
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.7
  - NFR draft: .factory/semport/jira-cli/jira-cli-bc-nfr-r-d-draft.md
---

# BC-6 — Configuration & Cache

44 behavioral contracts across 3 subdomains: Configuration (6.1), Cache (6.2),
Multi-profile fields — MUST-FIX (6.3). (+1 BC-6.2.018 added 2026-06-27 cache warm-hit no-HTTP invariant;
+1 BC-6.1.015 added 2026-09-01 cycle-003 `auth-profile-dx`: `env` config-schema tag; BC-6.2.015 amended
2026-09-01 cycle-003: ADR-0011 hard-fence un-defer.)

---

## Subdomains

### 6.1 Configuration

#### BC-6.1.001: Legacy `[instance]/[fields]` blocks migrate to `[profiles.default]` on first load

**Confidence**: HIGH
**Source**: `tests/migration_legacy.rs:93-143`
**Subject**: Config & Cache
**Behavior**: After load, `config.global.profiles["default"]` carries url, cloud_id, team_field_id, story_points_field_id. On-disk file no longer contains `[instance]` or `[fields]` headers.
**Trace**: Pass 3 BC-901

---

#### BC-6.1.002: Migration is idempotent: second load produces byte-identical file

**Confidence**: HIGH
**Source**: `tests/migration_legacy.rs:145-172`
**Behavior**: `after_first == after_second` (byte equality). BC-149 (R1).
**Trace**: Pass 3 BC-902

---

#### BC-6.1.003: Migration write-back uses file-only baseline (no env overlay bleeds to disk)

**Confidence**: HIGH
**Source**: `src/config.rs:240-264`
**Subject**: Config & Cache
**Behavior**: `JR_DEFAULTS_OUTPUT=json jr auth login` for the first time after upgrade does NOT permanently save `output = "json"` to config.
**Trace**: Pass 3 BC-903; BC-153 (R1)

---

#### BC-6.1.004: `validate_profile_name` rejects: empty, >64 chars, non-`[A-Za-z0-9_-]`, reserved Windows names (case-insensitive)

**Confidence**: HIGH
**Source**: `src/config.rs:113-140`
**Subject**: Config & Cache
**Behavior**: Rejected names → `JrError::UserError`. Error message: `"invalid profile name {name:?}; allowed: A-Z a-z 0-9 _ - up to 64 chars; reserved Windows names (CON, NUL, AUX, PRN, COM1-9, LPT1-9) excluded"`. Boundary: `:` rejected; `.` rejected; `/` rejected; `prod-1` allowed; `sandbox_2` allowed.
**Trace**: Pass 3 BC-904; BC-904-R (R1)

---

#### BC-6.1.005: Profile-name validation runs at THREE boundaries: TOML key iteration, resolved active name, CLI flag

**Confidence**: HIGH
**Source**: `src/config.rs:269-282, 308-310`
**Subject**: Config & Cache
**Behavior**: Pass 1: iterates `global.profiles.keys()` after migration. Pass 2: after `resolve_active_profile_name`. Both call `validate_profile_name`. Hand-edited `[profiles."foo:bar"]` fails at pass 1 with context.
**Trace**: Pass 3 BC-152 (R1)

---

#### BC-6.1.006: `resolve_active_profile_name` precedence: cli_flag → env_var → global.default_profile → "default"

**Confidence**: HIGH
**Source**: `src/config.rs::resolve_active_profile_name`
**Behavior**: Each `if let Some(name) = X` checks in order, returning early. Strictly hierarchical.
**Trace**: Pass 3 BC-905; BC-905-R (R1)

---

#### BC-6.1.007: `Config::load_with(cli_profile)` strict — errors with `"unknown profile: <X>; known: <list>"`

**Confidence**: HIGH
**Source**: `src/config.rs:319-328`
**Subject**: Config & Cache
**Behavior**: `if strict && !global.profiles.is_empty() && !global.profiles.contains_key(&name)` → `JrError::UserError`. Fresh install (empty profiles) is allowed.
**Trace**: Pass 3 BC-906; BC-906-R (R1)

---

#### BC-6.1.008: `Config::load_lenient_with` skips active-profile existence check (used ONLY by `jr auth login`)

**Confidence**: HIGH
**Source**: `src/config.rs:285-289`
**Trace**: Pass 3 BC-907; BC-907-R (R1)

---

#### BC-6.1.009: Default `[defaults] output = "table"`

**Confidence**: HIGH
**Source**: `src/config.rs:63-74`
**Trace**: Pass 3 BC-908

---

#### BC-6.1.010: `JR_BASE_URL` env completely overrides profile URL (test/power-user)

**Confidence**: HIGH
**Source**: `src/config.rs:351-353`; `src/api/client.rs:37-65`
**Trace**: Pass 3 BC-909

---

#### BC-6.1.011: `find_project_config()` walks up cwd to filesystem root looking for `.jr.toml`; returns first match

**Confidence**: HIGH
**Source**: `src/config.rs:340-353`
**Subject**: Config & Cache
**Behavior**: `loop { if candidate.exists() { return Some } if !dir.pop() { return None } }`. No XDG fallback.
**Edge case (documented limitation)**: The filesystem walk uses `Path::exists()` which follows symlinks. If `.jr.toml` is a symlink pointing to another file, it is followed without loop detection. A symlink cycle (e.g., `a -> b -> a`) could cause an OS-level error which propagates as an IO error. This is a known limitation of the canonical-path-agnostic design — not a bug to fix in v1.
**Trace**: Pass 3 BC-911; BC-911-R (R1)

---

#### BC-6.1.012: User-facing migration message emitted to stderr exactly once per process

**Confidence**: HIGH
**Source**: `src/config.rs:262-265`
**Behavior**: `"Migrated config to multi-profile layout (single profile \"default\"). Run 'jr auth list' to view profiles."` — only when migration triggers.
**Trace**: Pass 3 BC-151 (R1)

---

#### BC-6.1.013: `JR_PROFILE` env override for active profile; scrubbed by tests to prevent direnv pollution

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:9-32`; `src/config.rs:307`
**Behavior**: 16 env vars scrubbed per test. `JR_PROFILE_OVERRIDE` historical env seam replaced by parameter threading (unsafe POSIX `setenv` avoidance).
**Trace**: Pass 3 BC-154 (R1)

---

#### BC-6.1.014: On Windows, `global_config_dir()` resolves to `%APPDATA%\jr\` via `dirs::config_dir()`; XDG env vars are NOT consulted

**Confidence**: HIGH
**Source**: `src/config.rs::global_config_dir()` (windows-build F2 target design); architecture-delta.md §1.2
**Subject**: Config & Cache
**Behavior**:
- **Precondition**: Running on `x86_64-pc-windows-msvc` (or any `#[cfg(windows)]` target). `JR_CONFIG_DIR` is NOT set (or build is a release build — see BC-6.2.017).
- **Postcondition**: `global_config_dir()` returns `dirs::config_dir().unwrap_or_else(|| std::env::var("APPDATA").ok().filter(|s| !s.is_empty()).map(PathBuf::from).unwrap_or_else(|| PathBuf::from("."))).join("jr")`.
  - Canonical result: `C:\Users\<User>\AppData\Roaming\jr` (i.e., `%APPDATA%\jr`).
  - `global_config_path()` (unchanged) appends `config.toml` → `%APPDATA%\jr\config.toml`.
- **Invariant**: `XDG_CONFIG_HOME` env var is NOT read on Windows. The `#[cfg(not(windows))]` branch handles XDG; the `#[cfg(windows)]` branch calls `dirs::config_dir()` unconditionally.
- **Invariant**: `%APPDATA%` resolves via `dirs::config_dir()` which maps to Windows `CSIDL_APPDATA` (Roaming profile). The `APPDATA` direct-env fallback in `unwrap_or_else` is defensive only; `dirs` should always succeed on a Windows system with a user profile.
- **Unix behavior unchanged**: On `#[cfg(not(windows))]`, `global_config_dir()` continues to honor `XDG_CONFIG_HOME` first, then falls back to `dirs::home_dir().join(".config").join("jr")`. No change to macOS/Linux behavior.

**Edge cases**:
- EC-1: `dirs::config_dir()` returns `None` (Windows Known Folder API failure — rare; `dirs` resolves via `SHGetKnownFolderPath`/`FOLDERID_RoamingAppData` and does NOT consult the `APPDATA` env var, so this is independent of `APPDATA`'s value). The `unwrap_or_else` fallback then reads `APPDATA` directly: `std::env::var("APPDATA").ok()` returns `None` (unset) or `Some("")` (empty), both filtered out by `.filter(|s| !s.is_empty())`; `.map(PathBuf::from)` is not called; `.unwrap_or_else(|| PathBuf::from("."))` yields `"."` → joined with `"jr"` → relative path `./jr`. A set-but-empty `APPDATA=""` is therefore treated identically to an unset `APPDATA` — both route to the `./jr` defensive fallback. Binary proceeds; config file not found is handled by `Config::load_with` returning defaults.
- EC-2: Running in a Windows container with no user profile — same as EC-1. Not a supported deployment scenario for v1.

**Trace**: windows-build F2 2026-06-12; architecture-delta.md §1.2; ADR-0016; F1 decision: Option B adopted

---

#### BC-6.1.015: `ProfileConfig` gains an additive `env: Option<String>` environment/role tag (free-form, tolerant reader, no migration)

**Confidence**: HIGH
**Source**: `src/config.rs::ProfileConfig` (target field — F4 implementation story `S-cycle3-env-tag`, not yet landed as of this F2 pass); ADR-0020 §4 ("Additive `env`/role tag (DEC-314)")
**Subject**: Config & Cache
**Behavior**: `ProfileConfig` gains one new field, `env: Option<String>`. This is a **free-form, human-readable label** — NOT validated against a fixed enum or allowlist. DEC-314's own framing ("prod"/"sandbox"/"uat") is illustrative, not exhaustive: any string value is accepted verbatim. Per-profile `url` remains the actual environment lock (profile = environment + identity); `env` carries no access-control semantics and does not gate which Jira instance a profile talks to.

**Tolerant-reader default (no migration required)**: `Option<T>` fields on `ProfileConfig` deserialize to `None` when the corresponding TOML key is absent, without requiring an explicit `#[serde(default)]` attribute (consistent with every other `Option` field already on this struct). An old `config.toml` written before this field existed deserializes with `env: None` — no forced cache or keychain namespace bump is triggered by this field alone (DEC-314).

**Documented alternative (considered, not adopted this cycle)**: an enum/allowlist-validated shape (rejecting an `env` value outside a fixed `prod|sandbox|uat` set) was considered and explicitly NOT adopted — DEC-314 frames the tag as "lightweight, additive," and a validation contract would be a separate, additive change a future cycle could layer on without altering this BC's storage contract or triggering a migration.

**Edge cases**:
- EC-1: An arbitrary, non-canonical string (e.g. `"staging"`, `"qa-3"`) is accepted verbatim — no rejection, no normalization (case is preserved as typed).
- EC-2: `env = ""` (explicit empty string) deserializes to `Some(String::new())`, distinct from an absent key (`None`). No special-casing collapses empty-string to `None`.
- EC-3: An old `config.toml` with no `env` key under any `[profiles.<name>]` table loads successfully with `env: None` for that profile — `Config::load_with` does not error or warn.
- EC-4 (F2-gate FIX-C, added 2026-09-01): The storage layer performs NO sanitization of `env`'s content — a value containing raw control characters, ANSI escape sequences, or arbitrarily long text is stored and read back verbatim (this BC's STORAGE contract stays verbatim per the "Documented alternative" note above; it does not gain a validation/sanitization step). Sanitization for safe terminal rendering (control-char/ANSI stripping + a length cap, mirroring the repo's `display_sanitize_filename` CWE-116 convention) is a DISPLAY-layer concern, required at that layer, and owned by `bc-1-auth-identity.md`'s display BCs (BC-1.6.046/047) — not by this BC. See the injection-path finding below for why this requirement is defense-in-depth rather than a live untrusted-input vector for this specific field.

**`.jr.toml` injection-path investigation (F2-gate FIX-C, 2026-09-01) — finding: NO, a per-project `.jr.toml` overlay cannot set a profile's `env`.** Verified against `src/config.rs`: `find_project_config()` locates `.jr.toml` by walking up from `cwd`, and its content is parsed via `Figment::new().merge(Toml::file(path)).extract::<ProjectConfig>()` into the `ProjectConfig` struct, which declares only two fields — `project: Option<String>` and `board_id: Option<u64>`. `ProjectConfig` is a structurally separate type from `GlobalConfig`/`ProfileConfig` (which carry `env` and live only in `~/.config/jr/config.toml`, read via a completely separate `Figment` pipeline in `load_inner`); the two are never merged into one struct, and figment's `extract::<ProjectConfig>()` silently ignores any TOML key that isn't one of `ProjectConfig`'s own two fields (there is no `deny_unknown_fields`). Consequently, a `.jr.toml` in a cloned repository — however it is authored, including an `env = "..."` key at the top level or under a `[profiles.*]` table shape it does not actually support — has no code path that reads it into any profile's `env` value. **This bounds the threat**: `env` can only ever be set by editing a profile's own entry in the user's own global `~/.config/jr/config.toml` (or by a future `jr auth`/`jr init` write path), which the user already trusts and controls — it is not reachable from untrusted, cloned-repo content. The display-sanitization requirement in EC-4 above is therefore CWE-116 hygiene / defense-in-depth for this field, not a load-bearing security boundary against a terminal-injection attack via `.jr.toml`. This finding is scoped to `env` only and does not generalize to other `ProfileConfig`/`ProjectConfig` fields (e.g. `project`), which were not investigated as part of this fix.

**Cross-reference (bc-1, not authored here)**: DISPLAY of `env` — the `auth list` table column and the `auth status` human-text output — is a `bc-1-auth-identity.md` concern (BC-1.6.046, amended, for the table; the human-text path of BC-1.6.047 for `auth status`) authored by the parallel cycle-003 F2 burst. This BC covers the config-schema storage contract only, and that storage contract stays VERBATIM regardless of output channel (EC-1/EC-2/EC-4 above) — this includes the JSON channel: per this repo's machine-channel convention (issue #398, `--output json` is lossless), `env` MUST be echoed byte-for-byte in JSON with no sanitization applied. **Display-sanitization requirement (F2-gate FIX-C, corrected adversary pass-2 H-2):** because `env` is free-form and stored verbatim, the control-character/ANSI-escape stripping plus length cap required before rendering applies ONLY to the TERMINAL/human-rendered channel — the `auth list` table cell (owned by BC-1.6.046) and the human-text path of `auth status` (owned by BC-1.6.047) — required at that layer, though bounded to a hygiene/defense-in-depth requirement rather than a proven live attack vector per the `.jr.toml` finding above. This requirement explicitly does NOT extend to the JSON output surface, which stays lossless/verbatim per the paragraph above; BC-1.6.046/047 are the correctly-scoped owners of the terminal-only sanitization contract, not of any JSON-channel behavior. **Flagged for F4 verification**: the implementing story for BC-1.6.046/047 (and any VP/holdout covering them) should include a case where `env` contains raw control characters or ANSI escapes (e.g. `\x1b[31m`, embedded `\r`/`\n`) to confirm (a) the human-text/table display path strips them before terminal output, and (b) the JSON path (if `env` is JSON-surfaced at all) echoes them verbatim.

**Verification Properties**:
- **VP-AUTHDX-009 — `env` tolerant-reader round-trip / deserialization indistinguishability (PROPERTY, PROMOTED 2026-09-01, F2 VP-delta pass, was VP-cycle3-021 relocated to its correct layer).** Property: across the full input space of possible pre-cycle-003 `config.toml` shapes, a config with the `env` key ABSENT deserializes to a `ProfileConfig` with `env: None`, INDISTINGUISHABLE from any other absent-optional-field handling, with NO migration required; and a serialize→deserialize round-trip is stable (`Some(s)` survives as `Some(s)`, `None`/absent survives as `None`, and `Some("")` empty-string is distinguishable from `None`/absent). Old profiles never fail to load because of the new field. Promoted (and relocated from bc-1, where it was originally drafted as a display-layer candidate) because this is a schema/deserialization-layer property, not a display concern — it belongs alongside this BC's own tolerant-reader default and EC-1/EC-2/EC-3 edge cases, which it directly strengthens into a property-test proof. **Verification method**: property test (`proptest`, arbitrary `ProfileConfig` field combinations with/without `env`, including `env = ""`), asserting the tolerant-reader and round-trip invariants on every generated case. **F6 target**: the `ProfileConfig` serde deserialization path in `src/config.rs`.

**Related**: DEC-314; ADR-0020 §4 (per-profile credential ownership / env tagging / OAuth-default ADR); F1 delta analysis (`cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`) §1.2 item 7; bc-1-auth-identity.md BC-1.6.046/047 (display-layer sanitization owner, F2-gate FIX-C cross-reference).
**Trace**: ADR-0020 §4; DEC-314; F1 delta analysis §1.2 item 7; F3 candidate story `S-cycle3-env-tag` (F1 delta analysis §2 item 1); `src/config.rs` (`ProjectConfig`, `find_project_config`, `load_inner` — F2-gate FIX-C `.jr.toml` injection-path investigation, finding: no injection path)

| Version | Date | Author | Change |
|---------|------|--------|--------|
| 1.0.0 | 2026-09-01 | product-owner | Initial BC-6.1.015 (`env` config-schema tag; DEC-314/ADR-0020 §4; genuinely new ID). |
| 1.1.0 | 2026-09-01 | product-owner | **F2-gate fix application (FIX-C):** added EC-4 (storage stays verbatim; display-layer sanitization required, owned by bc-1's BC-1.6.046/047) and the `.jr.toml` injection-path investigation (finding: NO — `ProjectConfig` in `src/config.rs` is a structurally separate, two-field struct never merged into `GlobalConfig.profiles`, so a cloned repo's `.jr.toml` cannot set any profile's `env`; display sanitization is therefore CWE-116 hygiene/defense-in-depth for this field, not a live untrusted-repo attack vector). Cross-reference and Trace updated accordingly. No storage-contract change, no BC ID change, no filename-slug change. |
| 1.2.0 | 2026-09-01 | product-owner | **Adversary pass-2 fix (H-2 secondary, bc-6 side):** narrowed the FIX-C display-sanitization clause, which over-broadly required sanitization "in text/JSON". Corrected: storage stays VERBATIM (unchanged); the control-char/ANSI-strip + length-cap requirement now applies ONLY to the TERMINAL/human-rendered channel (`auth list` table cell, `auth status` human text) — the JSON output channel stays lossless/verbatim per this repo's machine-channel convention (issue #398). Retitled the owners to BC-1.6.046 (table) and the human-text path of BC-1.6.047 specifically, removing any implication that JSON output is sanitized. No storage-contract change, no BC ID change, no filename-slug change, no BC added/removed (count unchanged at 44/34). |

---

### 6.2 Cache

#### BC-6.2.001: `read_cache<T>` returns `Ok(None)` for NotFound; propagates other I/O errors

**Confidence**: HIGH
**Source**: `src/cache.rs:14-34`
**Subject**: Config & Cache
**Behavior**: `NotFound` → `Ok(None)`. Permission-denied → `Err(io::Error)`. Only missing-file maps to None.
**Trace**: Pass 3 BC-1001; BC-1001-R (R1)

---

#### BC-6.2.002: `read_cache<T>` returns `Ok(None)` AND stderr warning for parse failure

**Confidence**: HIGH
**Source**: `src/cache.rs:23-26`; `tests/issue_view_errors.rs:142-206`
**Subject**: Config & Cache
**Behavior**: Literal stderr: `"warning: cache file <name> unreadable (<err>); will refetch"`. No deletion. Single warning per (process, filename). Corrupt file remains until next write.
**Trace**: Pass 3 BC-1002; BC-1002-R (R1)

---

#### BC-6.2.003: TTL check: `(Utc::now() - fetched_at).num_days() >= CACHE_TTL_DAYS (7)`; exactly 7 days is expired

**Confidence**: HIGH
**Source**: `src/cache.rs:7, 30-32`
**Subject**: Config & Cache
**Behavior**: `const CACHE_TTL_DAYS: i64 = 7`. `>= 7` → expired. `7-day-old` is expired. Unit test writes 8-day-old entry.
**Trace**: Pass 3 BC-1003; BC-1003-R (R1)

---

#### BC-6.2.004: Per-profile cache directory — platform-conditional root

**Confidence**: HIGH
**Source**: `src/cache.rs:7, 30, 76-78`
**Behavior**: The per-profile cache directory is platform-conditional. The `v1/` versioning root is present on all platforms; new schema → bump to `v2/`, old files orphan harmlessly.

- **Unix (macOS/Linux)**: `~/.cache/jr/v1/<profile>/` — `XDG_CACHE_HOME` honored when set; `dirs::home_dir()` fallback otherwise.
- **Windows**: `%LOCALAPPDATA%\jr\v1\<profile>\` — `dirs::cache_dir()` used; XDG env vars are NOT consulted on Windows (see BC-6.2.016).

**Platform-conditional clause** [added windows-build F2 2026-06-12]: The `~/.cache/jr/v1/` prefix documented in pre-Windows-build specs applies to Unix only. Windows path is `%LOCALAPPDATA%\jr\v1\<profile>\`.

**Cycle-003 confirmation** [DEC-325(a), ADR-0020 §3, 2026-09-01]: The per-profile credential restructuring (DEC-315) does NOT bump this `v1/` cache-root — DOCUMENTED-UNCHANGED this cycle. A `v1→v2` bump remains an available-but-untriggered lever for a future cycle's separate call; cycle-003's new per-profile keychain layout (`<profile>:email`/`<profile>:api-token`, symmetric with `<profile>:oauth-*`) does not introduce an analogous keychain-namespace version marker — ADR-0020 §3 rejects that as unproven, non-disposable-data infrastructure with no existing lever to reuse (unlike this cache root's `v1/` segment).
**Trace**: Pass 3 BC-1004; platform-conditional update windows-build F2 2026-06-12; cycle-003 confirmation 2026-09-01 (DEC-325a)

---

#### BC-6.2.005: `clear_profile_cache(name)` is no-op when directory doesn't exist (does NOT error)

**Confidence**: HIGH
**Source**: `src/cache.rs:82-88`
**Behavior**: `if dir.exists() { remove_dir_all(dir)? }` — exists() check short-circuits.
**Trace**: Pass 3 BC-1005; BC-1005-R (R1)

---

#### BC-6.2.006: `cmdb_fields.json` stores (id, name) tuples; old ID-only format → cache miss (graceful)

**Confidence**: HIGH
**Source**: `src/cache.rs:237-247`; CLAUDE.md
**Behavior**: Old format → deserialization failure → `Ok(None)` (treated as miss). Auto-expiry via 7d TTL.
**Trace**: Pass 3 BC-1006

---

#### BC-6.2.007: `ProjectMeta` map cache `project_meta.json` keyed by project key; per-entry TTL

**Confidence**: HIGH
**Source**: `src/cache.rs:105-143`; `tests/project_meta.rs`
**Trace**: Pass 3 BC-1007

---

#### BC-6.2.008: `ResolutionsCache` drops resolutions without `id` on write + stderr warning

**Confidence**: HIGH
**Source**: `src/cli/issue/workflow.rs:117-133`
**Behavior**: stderr: `"warning: N resolution(s) lacked an id and were not cached"`.
**Trace**: Pass 3 BC-1008

---

#### BC-6.2.009: Cross-profile isolation: writing `prod` cache does NOT make `sandbox` cache visible

**Confidence**: HIGH
**Source**: `src/cache.rs:389-406`
**Subject**: Config & Cache
**Behavior**: `read_team_cache("sandbox")` returns `None` after writing `prod` team cache. Path construction: `cache_dir(profile) = cache_root().join("v1").join(profile)`.
**Trace**: Pass 3 BC-1011 (R1)

---

#### BC-6.2.010: `clear_profile_cache("prod")` does NOT delete `sandbox` data

**Confidence**: HIGH
**Source**: `src/cache.rs:408-439`
**Behavior**: Write both prod + sandbox; clear prod; assert prod is None AND sandbox is Some.
**Trace**: Pass 3 BC-1012 (R1)

---

#### BC-6.2.011: Corrupt cache files (garbage data + valid-JSON-wrong-shape) both return `Ok(None)`

**Confidence**: HIGH
**Source**: `src/cache.rs:808-861`
**Subject**: Config & Cache
**Behavior**: Two corruption modes: (1) `"not json"` and (2) `{"unexpected": true}`. Both → `Ok(None)`. Format-change resilience.
**Trace**: Pass 3 BC-1013 (R1)

---

#### BC-6.2.012: `write_project_meta` MERGES into existing map; corruption recovery → fresh start + stderr warning

**Confidence**: HIGH
**Source**: `src/cache.rs:146-173`; unit test `project_meta_multiple_projects` (`:563-594`)
**Behavior**: Read-modify-write semantics. Corruption → `"warning: project_meta.json unreadable (<err>); starting fresh — other cached projects will be lost"`.
**Trace**: Pass 3 BC-1014 (R1)

---

#### BC-6.2.013: `write_object_type_attr_cache` MERGES into existing per-type map; same corruption recovery pattern

**Confidence**: HIGH
**Source**: `src/cache.rs:318-354`; unit test `object_type_attr_cache_multiple_types` (`:762-794`)
**Behavior**: Corruption → `"warning: object_type_attrs.json unreadable (<err>); starting fresh — other cached object types will be lost"`.
**Trace**: Pass 3 BC-1015 (R1)

---

#### BC-6.2.014: Cache write is non-atomic (`std::fs::write`); crash mid-write leaves truncated file; read-side resilient

**Confidence**: HIGH
**Source**: `src/cache.rs:42, 171, 351`
**Subject**: Config & Cache
**Behavior**: `std::fs::write(path, content)` — no temp-file + rename, no fsync. Crash → truncated file → next read returns `Ok(None)` + stderr warning → re-fetch proceeds. This is the documented contract, not a bug.
**Trace**: Pass 3 BC-1016 (R1)

---

#### BC-6.2.015: Every cache reader/writer takes `profile: &Profile` as its first parameter (compile-time hard fence via `Profile(String)` newtype)

**Confidence**: HIGH
**Source**: `docs/adr/0011-type-level-profile-fence.md` (Status on develop: Deferred; amendment STAGED per DEC-317 at `.factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md`, to be applied by the F4 newtype story); `src/cache.rs` + `src/api/auth.rs` (target signatures — F4 implementation story `S-cycle3-adr0011-newtype`, not yet landed as of this F2 pass); `.factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` §4 (newtype boundary reconciliation)
**Subject**: Config & Cache
**Behavior**: **[AMENDED 2026-09-01, cycle-003 `auth-profile-dx`, DEC-317]** The soft-fence convention this BC previously described is superseded: the staged ADR-0011 amendment un-defers it (Status: Deferred → Accepted, in place, not a supersession — the decision confirms a documented revisit trigger was met, not a reversal). A `Profile(String)` newtype (`pub struct Profile(String)`, with `impl From<String> for Profile`, `impl AsRef<str> for Profile`, and a `Display` impl) is introduced and threaded through every per-profile boundary this BC previously protected by convention alone. **Target contract (F2-gate reconciliation, SR-006 — corrected 2026-09-01):** ALL cache read/write/clear/invalidate functions in `src/cache.rs` (12+ functions as of ADR-0011's amendment — the exact count is whatever `src/cache.rs` has grown to by implementation time) **PLUS `src/api/auth.rs`'s four per-profile credential functions (`store_api_token`/`load_api_token`/`store_oauth_tokens`/`load_oauth_tokens`)** — added to the fence's in-scope surface at the F2 gate per the staged ADR-0011 amendment §Decision item 2 and architecture-delta.md §4, resolving a genuine scope contradiction (SR-006) where this BC's prior target-contract note omitted `auth.rs` entirely even though architecture-delta.md §4's own newtype-boundary diagram already showed it inside the fence — plus `Config::active_profile_name`, and `JiraClient::profile_name`, all changing signature from `profile: &str` / `String` to `profile: &Profile` / `Profile`. A profile-unaware cache function, credential function, or a call site passing a bare `&str`/hardcoded string literal where a `Profile` is expected, becomes a **compile error** — the hard fence ADR-0011 names, replacing the grep-based soft-fence enforcement pattern below. **Corrected call-site estimate: ~60-80 (was ~50-70)** — the `auth.rs` scope addition plus its own call sites (`JiraClient::load_auth_from_keychain`'s two branches, `login_token`, `clear_profile_creds`/`clear_all_credentials`'s aggregation loops, `auth remove`'s fourth delete step, and the `auth refresh`/`auth login` call sites reading these functions — roughly 8-12 additional sites) revises the original `cache.rs`-only estimate, per architecture-delta.md §4's reconciliation.

**Status as of this amendment**: Design **ACCEPTED, NOT YET IMPLEMENTED**. `src/cache.rs`'s functions, `Config::active_profile_name`, and `JiraClient::profile_name` still use `profile: &str` / `String` as of this writing (F2). Implementation is tracked as F4 story `S-cycle3-adr0011-newtype`, sequenced to land AFTER the per-profile credential-storage/migration stories (`S-cycle3-percred-storage`, `S-cycle3-percred-migration`) so the call-site sweep covers the enlarged, post-restructuring surface exactly once (ADR-0011 § Sequencing). Until that story lands, the PRIOR soft-fence runtime behavior (documented by this BC's 1.0.0 revision) remains the actual contract — this amendment documents the accepted TARGET, not a completed migration.

**Residual (documented, not closed by the newtype)**: a value that is correctly typed as `Profile` but semantically WRONG (e.g., a caller substitutes the wrong profile's `Profile` value) is NOT caught by the type system alone — the compiler enforces "a `Profile` was supplied," not "the CORRECT `Profile` was supplied." Cross-profile isolation tests (BC-6.2.009, BC-6.2.010) remain the operative safety net for this residual class; the compiler becomes the PRIMARY, not sole, safety net (see ADR-0011 § Consequences, Negative/Trade-offs).

**Legacy verification pattern (superseded, retained for historical/soft-fence-only enforcement prior to newtype landing)**: `grep -n 'fn read_cache\|fn write_cache\|fn read_team\|fn write_team\|fn read_project\|fn write_project' src/cache.rs` should show `profile: &str` as first non-self parameter in every result; `grep -E 'fn (read|write)_\w+\((?!.*profile)' src/cache.rs` should return zero matches. These patterns verify the SOFT fence only and remain the operative check until `S-cycle3-adr0011-newtype` lands; once it lands, the operative verification becomes "does `cargo build` succeed with `Profile`-typed signatures throughout" — a compile-time check, not a grep.

**Related**: NFR-SCA-2 — status changed from `DEFER` to resolved-design/FIX-IN-CYCLE (cycle-003) by DEC-317; see `nfr-catalog.md` NFR-SCA-2 row (amended alongside this BC).
**Trace**: `docs/adr/0011-type-level-profile-fence.md` (Status on develop: Deferred; amendment STAGED, not yet applied — see `.factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md`); DEC-317; NFR-SCA-2; Pass 4 R4; CLAUDE.md "Multi-profile boundary" gotcha; F1 delta analysis (`cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`) §1.1/§1.3/§3; `.factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` §4 (newtype boundary reconciliation, `src/api/auth.rs` scope + ~60-80 call-site estimate correction, SR-006)

| Version | Date | Author | Change |
|---------|------|--------|--------|
| 1.0.0 | Pass 4 R4 | product-owner | Initial soft-fence convention BC (`profile: &str`, grep-based verification, `Related: NFR-SCA-2 (deferred)`). |
| 2.0.0 | 2026-09-01 | product-owner | **AMENDED** (cycle-003 `auth-profile-dx`, DEC-317): un-defers ADR-0011 — rewrote Behavior to describe the compile-time hard fence (`Profile(String)` newtype) as the ACCEPTED target contract; documented current not-yet-implemented status and F4 sequencing (`S-cycle3-adr0011-newtype`); flagged the "correctly-typed-but-wrong-value" residual; flipped `Related` cross-reference from "NFR-SCA-2 (deferred)" to "NFR-SCA-2 (resolved-design/FIX-IN-CYCLE)"; retained legacy grep-verification pattern as historical/soft-fence-only, valid until F4 lands. No BC ID change (append-only numbering) and no filename-slug change. |
| 2.1.0 | 2026-09-01 | product-owner | **F2-gate fix application** (SR-006, CV-1): (SR-006) corrected the "Target contract" scope, which had omitted `src/api/auth.rs` entirely, to explicitly include its four per-profile credential functions (`store_api_token`/`load_api_token`/`store_oauth_tokens`/`load_oauth_tokens`) per the staged ADR-0011 amendment §Decision item 2 and architecture-delta.md §4's newtype-boundary reconciliation; corrected the call-site estimate to ~60-80 (was ~50-70). (CV-1) corrected the Source/Trace citation of `docs/adr/0011-type-level-profile-fence.md`'s status — the file on `develop` still reads Status: Deferred; the un-defer is a STAGED amendment at `.factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md`, not yet applied to the repo file, to be applied by the F4 newtype story (`S-cycle3-adr0011-newtype`). No behavioral-contract change beyond citation/scope precision; no BC ID change; no filename-slug change. |

---

#### BC-6.2.016: On Windows, `cache_root()` resolves to `%LOCALAPPDATA%\jr\` via `dirs::cache_dir()`; per-profile path is `%LOCALAPPDATA%\jr\v1\<profile>\`; XDG env vars are NOT consulted

**Confidence**: HIGH
**Source**: `src/cache.rs::cache_root()` (windows-build F2 target design); architecture-delta.md §1.2
**Subject**: Config & Cache
**Behavior**:
- **Precondition**: Running on `#[cfg(windows)]` target. `JR_CACHE_DIR` is NOT set (or build is a release build — see BC-6.2.017).
- **Postcondition**: `cache_root()` returns `dirs::cache_dir().unwrap_or_else(|| std::env::var("LOCALAPPDATA").ok().filter(|s| !s.is_empty()).map(PathBuf::from).unwrap_or_else(|| PathBuf::from("."))).join("jr")`.
  - Canonical result: `C:\Users\<User>\AppData\Local\jr` (i.e., `%LOCALAPPDATA%\jr`).
  - Per-profile path via `cache_dir(profile)` = `cache_root().join("v1").join(profile)`:
    → `%LOCALAPPDATA%\jr\v1\<profile>\`.
- **Invariant**: The `v1/` versioning root is preserved on all platforms (Windows included). Schema bump to `v2/` would orphan old Windows cache files the same as on Unix.
- **Invariant**: `XDG_CACHE_HOME` env var is NOT read on Windows. The `#[cfg(not(windows))]` branch handles XDG; the `#[cfg(windows)]` branch calls `dirs::cache_dir()` unconditionally.
- **Invariant**: `%LOCALAPPDATA%` resolves via `dirs::cache_dir()` which maps to Windows `CSIDL_LOCAL_APPDATA` (Local — NOT Roaming). Per-machine, per-user. This is intentional: cache data should not roam across machines.
- **Unix behavior unchanged**: On `#[cfg(not(windows))]`, `cache_root()` continues to honor `XDG_CACHE_HOME` first, then falls back to `dirs::home_dir().join(".cache").join("jr")`. No change to macOS/Linux behavior.
- **`cache_dir(profile)` function unchanged**: The composed per-profile path function is `cache_root().join("v1").join(profile)` — unchanged on all platforms. Only the `cache_root()` return value differs by platform.

**Edge cases**:
- EC-1: `dirs::cache_dir()` returns `None` (Windows Known Folder API failure — rare; `dirs` resolves via `SHGetKnownFolderPath`/`FOLDERID_LocalAppData` and does NOT consult the `LOCALAPPDATA` env var, so this is independent of `LOCALAPPDATA`'s value). The `unwrap_or_else` fallback then reads `LOCALAPPDATA` directly: `std::env::var("LOCALAPPDATA").ok()` returns `None` (unset) or `Some("")` (empty), both filtered out by `.filter(|s| !s.is_empty())`; `.map(PathBuf::from)` is not called; `.unwrap_or_else(|| PathBuf::from("."))` yields `"."` → joined with `"jr"` → relative `./jr`. A set-but-empty `LOCALAPPDATA=""` is therefore treated identically to an unset `LOCALAPPDATA` — both route to the `./jr` defensive fallback. Cache writes proceed; on next TTL expiry cache is re-fetched from API.
- EC-2: Existing Windows user running pre-BC-6.2.016 build (non-idiomatic `%USERPROFILE%\.cache\jr\` path) — cache is not migrated; old files orphan harmlessly; TTL expiry causes re-fetch. No corruption. Not a blocker for v1.

**Cycle-003 confirmation** [DEC-325(a), ADR-0020 §3, 2026-09-01]: Same confirmation as BC-6.2.004 — DEC-315's per-profile credential restructuring does NOT bump this `v1/` cache-root (Windows or Unix); no keychain-namespace version marker is introduced either (ADR-0020 §3). DOCUMENTED-UNCHANGED this cycle.

**Related BCs**: BC-6.2.004 (platform-conditional root, updated), BC-6.2.017 (debug seam)
**Trace**: windows-build F2 2026-06-12; architecture-delta.md §1.2; ADR-0016; cycle-003 confirmation 2026-09-01 (DEC-325a)

---

#### BC-6.2.017: `JR_CONFIG_DIR` / `JR_CACHE_DIR` env vars override config/cache directory resolution in debug builds; compiled out in release builds

**Confidence**: HIGH
**Source**: `src/config.rs::global_config_dir()` and `src/cache.rs::cache_root()` (windows-build F2 target design); architecture-delta.md §2; `tests/config_dir_release_gate.rs` (new)
**Subject**: Config & Cache
**Behavior**:
- **Precondition (debug path)**: `#[cfg(debug_assertions)]` is active (i.e., debug build). `JR_CONFIG_DIR` env var is set to a non-empty string (see EC-1 for the empty-string case).
- **Postcondition (debug path)**: `global_config_dir()` returns `PathBuf::from(env::var("JR_CONFIG_DIR").unwrap())` immediately, bypassing all OS-specific logic (`#[cfg(windows)]` and `#[cfg(not(windows))]` branches are not evaluated).
- **Symmetric**: `JR_CACHE_DIR` controls `cache_root()` with identical semantics — returns `PathBuf::from(env::var("JR_CACHE_DIR").unwrap())`, bypassing `dirs::cache_dir()` and XDG logic.
- **Precondition (release path)**: `#[cfg(debug_assertions)]` is NOT active (i.e., release build). `JR_CONFIG_DIR` / `JR_CACHE_DIR` may be set.
- **Postcondition (release path)**: `JR_CONFIG_DIR` / `JR_CACHE_DIR` have NO effect. `global_config_dir()` / `cache_root()` proceed to the OS-branch logic as if the env vars were unset. The env-var read code is compiled out via `#[cfg(debug_assertions)]`.
- **Invariant**: The seam is consulted BEFORE the OS-platform branch in BOTH functions (`global_config_dir()` and `cache_root()`). When the debug seam fires, neither the Windows nor the Unix path-resolution branch is evaluated.
- **Invariant**: These seams do not replace `JR_BASE_URL` / `JR_AUTH_HEADER`; they are additive. A debug binary can have all four seams active simultaneously.
- **Invariant**: Env var value is used as-is (no `.join("jr")` suffix appended). The caller supplies the fully-resolved target directory path. This is a deliberate asymmetry with `XDG_CONFIG_HOME`: `global_config_dir()` appends `.join("jr")` for the XDG path but the seam bypasses that append entirely. Callers must therefore supply the `/jr`-suffixed path, NOT the bare XDG value.
- **Invariant (empty-string filter)**: Both seams use `std::env::var("JR_CONFIG_DIR").ok().filter(|s| !s.is_empty())` (and likewise for `JR_CACHE_DIR`). An empty-string value is treated as unset: the OS-branch logic proceeds normally. This applies symmetrically to both env vars.

**Test isolation use case**: Integration tests set `JR_CONFIG_DIR` and `JR_CACHE_DIR` pointing to `TempDir` instances alongside the existing `XDG_CONFIG_HOME` / `XDG_CACHE_HOME` vars. On Unix, XDG vars continue to provide isolation (unchanged). On Windows (debug build), `JR_CONFIG_DIR` / `JR_CACHE_DIR` provide cross-platform isolation because `dirs` ignores XDG on Windows.

**CRITICAL — seam path must be the fully-resolved directory (not the raw XDG value):** ~25 existing test files write their config fixture into a `/jr`-suffixed subdirectory, e.g. `dir.path().join("jr").join("config.toml")`, because under `XDG_CONFIG_HOME` the binary resolves config to `<xdg>/jr/config.toml` (the XDG branch appends `.join("jr")` internally). The debug seam does NOT append `.join("jr")` — it uses the env var value as the final resolved directory. Therefore:

- A helper that writes a fixture to `<TempDir>/jr/config.toml` and sets `JR_CONFIG_DIR=<TempDir>` causes `jr` to look for `<TempDir>/config.toml` — **fixture not found → test fails on Ubuntu and macOS, not just Windows.**
- The correct uniform migration rule is:
  - For each existing `.env("XDG_CONFIG_HOME", X)` → add `.env("JR_CONFIG_DIR", X.join("jr"))`
  - For each existing `.env("XDG_CACHE_HOME", Y)` → add `.env("JR_CACHE_DIR", Y.join("jr"))`
  - The seam value is `<XDG value>.join("jr")` for config and `<XDG value>.join("jr")` for cache (the cache `v1/<profile>` segments are then appended downstream by `cache_dir(profile)` as today).

**The debug seam takes precedence over XDG when both are set.** When a test sets both `XDG_CONFIG_HOME=/tmp/xdg` and `JR_CONFIG_DIR=/tmp/xdg/jr`, the seam value (`/tmp/xdg/jr`) wins; XDG is silently ignored. These two paths refer to the same location that `jr` would resolve under XDG, so isolation is preserved with no behavioral difference. Tests that set them to different values expecting XDG to prevail are incorrect on debug Unix builds and will fail.

**Release gate test**: `tests/config_dir_release_gate.rs` (new) mirrors the pattern of `tests/base_url_release_gate.rs` — a **source-adjacency grep test**, NOT a binary-execution test. `cargo test` runs in debug mode and physically cannot observe release-build behavior at runtime. The test uses `include_str!("../src/config.rs")` and `include_str!("../src/cache.rs")` (or equivalent source reads) and asserts:

1. **Config site**: In `src/config.rs`, `#[cfg(debug_assertions)]` appears within 5 lines of the `std::env::var("JR_CONFIG_DIR")` read inside `global_config_dir()`. This asserts the gate is adjacent to the seam read — the same adjacency the `base_url_release_gate.rs` test enforces for `JR_BASE_URL` in `src/config.rs`.
2. **Cache site**: In `src/cache.rs`, `#[cfg(debug_assertions)]` appears within 5 lines of the `std::env::var("JR_CACHE_DIR")` read inside `cache_root()`. This is a separate, required assertion — gating only the config site but not the cache site leaves `JR_CACHE_DIR` unguarded in release, the same class of defect that required `JR_BASE_URL` to be gated at TWO source sites (`src/config.rs::base_url()` AND `src/api/client.rs::from_config()`).
3. A `const { assert!(cfg!(debug_assertions)) }` compile-time assertion is present in the seam code, confirming the gate is not just a comment but a hard compile-time check.

Both assertions (config site + cache site) are required. A test that checks only one site is non-compliant with this contract.

**Edge cases**:
- EC-1: `JR_CONFIG_DIR` set to empty string (`""`) in debug build — treated as unset by the `filter(|s| !s.is_empty())` guard. `global_config_dir()` proceeds to OS-branch logic. `PathBuf::from("")` is NOT returned. Symmetric behavior for `JR_CACHE_DIR=""`.
  - Contrast with `XDG_CONFIG_HOME=""`: XDG path goes `PathBuf::from("").join("jr")` → relative path `"jr"` (WITH the `jr/` suffix). The seam with empty-string filter produces the full OS-branch result (e.g., `~/.config/jr` or `%APPDATA%\jr`). These are observably different and the empty-string filter is the intentional contract for sane test semantics.
- EC-2: `JR_CONFIG_DIR` / `JR_CACHE_DIR` set in a release build — silently ignored. No warning emitted. Mirrors `JR_BASE_URL` behavior in release builds.
- EC-3: Only `JR_CONFIG_DIR` set (not `JR_CACHE_DIR`) — config dir uses seam, cache dir uses OS logic. The two seams are independent.
- EC-4: Debug seam path and OS path differ (e.g., Windows runner with `JR_CONFIG_DIR=/tmp/test`) — OS path is entirely bypassed. The debug seam overrides regardless of whether the supplied path is Windows-style or Unix-style.
- EC-5: `JR_CACHE_DIR` set to empty string (`""`) in debug build — symmetric to EC-1. Treated as unset; `cache_root()` proceeds to OS-branch logic.

**Related BCs**: BC-6.1.014 (Windows config path), BC-6.2.016 (Windows cache path), BC-6.1.010 (`JR_BASE_URL` seam — pattern this mirrors)
**CLAUDE.md documentation**: `JR_CONFIG_DIR` / `JR_CACHE_DIR` must be added to the "AI Agent Notes" JR_* env var table in CLAUDE.md per the doc-fallout pattern (parallel to `JR_BASE_URL` and `JR_BULK_*` entries).
**Trace**: windows-build F2 2026-06-12; architecture-delta.md §2; ADR-0016; mirrors BC-6.1.010 / `tests/base_url_release_gate.rs` pattern; adversary fixes F-1/F-2/F-5/F-6 applied 2026-06-12

---

#### BC-6.2.018: A warm cache hit (second invocation within TTL) returns the cached value and issues ZERO HTTP calls to the backing API endpoint; this invariant holds for all nine cache families

**Confidence**: HIGH
**Subject**: Config & Cache
**Behavior**: **Behavioral invariant (all 9 families)**: For every cache family, a second invocation within the 7-day TTL (warm hit) returns the cached value and issues ZERO HTTP calls to the backing API endpoint. The HTTP call is entirely bypassed on a warm hit; the first (cold miss) invocation triggers the HTTP request and writes the result back to the cache file.

**Mechanism** (two distinct implementations in `src/cache.rs`):

**(a) 7 families delegate to the generic `read_cache<T>` warm-hit return path** (lines 16–34). `read_cache<T>` is private; the public wrappers below delegate to it:
- **Family 1 (teams)**: `read_team_cache(profile)` / `write_team_cache`
- **Family 3 (workspace ID)**: `read_workspace_cache(profile)` / `write_workspace_cache`
- **Family 4 (CMDB fields)**: `read_cmdb_fields_cache(profile)` / `write_cmdb_fields_cache`
- **Family 6 (Jira fields)**: `read_fields_cache(profile)` / `write_fields_cache`
- **Family 7 (resolutions)**: `read_resolutions_cache(profile)` / `write_resolutions_cache`
- **Family 8 (request types)**: `read_request_type_cache(profile, service_desk_id)` / `write_request_type_cache`
- **Family 9 (request type fields)**: `read_request_type_fields_cache(profile, service_desk_id, rt_id)` / `write_request_type_fields_cache`

On warm hit: `read_cache<T>` returns `Ok(Some(T))` after (1) file read, (2) JSON deserialization, (3) TTL check passes (`num_days() < 7`). No network call before or after this return.

**(b) 2 families implement an equivalent per-entry inline warm path** and do NOT call `read_cache<T>`:
- **Family 2 (project meta)**: `read_project_meta(profile, project_key)` at `src/cache.rs::read_project_meta` — own `path.exists()` check → `from_str::<HashMap<String,ProjectMeta>>` → per-entry `meta.fetched_at` TTL check → returns `Ok(Some(meta.clone()))` on warm hit. Keyed design: TTL is checked per entry, not per file, because multiple project keys share one `project_meta.json` file.
- **Family 5 (object-type attrs)**: `read_object_type_attr_cache(profile, object_type_id)` at `src/cache.rs::read_object_type_attr_cache` — own `path.exists()` → `from_str::<ObjectTypeAttrCache>` → per-file `cache.fetched_at` TTL → `types.get(object_type_id).cloned()` → returns `Ok(Some(Vec<CachedObjectTypeAttr>))` on warm hit. Keyed design: TTL is per-file; lookup is per object type ID.

Both bespoke paths enforce the same behavioral invariant as `read_cache<T>`: warm hit within TTL → cached value returned, ZERO additional HTTP calls.

**D2 verification property**: The warm-hit no-HTTP invariant is the only cache property that output alone cannot verify — output is identical whether the value came from cache or a fresh HTTP call. Two distinct techniques are used across families:

**(i) Wiremock `expect(1)` call-count pin**: configure the mock to fire exactly once (`expect(1)`), make the first request (cold miss), confirm the mock was called, then make the second request (warm hit) and confirm the mock was still called exactly once (not twice). Wiremock asserts the call count automatically on server shutdown. Used by Families 8+9 (`tests/requesttype_commands.rs::test_requesttype_list_cache_hit_no_second_http`, `test_requesttype_fields_cache_hit_no_second_http`) and Family 3 (holdout H-037).

**(ii) Absence-of-mount**: the second-call endpoint is deliberately NOT mounted; any follow-on call to it would return 404 as an unregistered request, surfacing visibly in the test output. Used by Family 6 (`tests/issue_edit_field.rs::test_bc_3_4_015_warm_fields_cache_skips_field_list_http`): the test pre-populates the fields cache and explicitly does NOT mount `GET /rest/api/3/field` — confirmed by the test comment: "Deliberately do NOT mount GET /rest/api/3/field — any call to it would be an unregistered request (wiremock returns 404 which the handler would surface)".

Both techniques prove the zero-follow-on-HTTP property; they are complementary, not interchangeable preferences. New tests for un-pinned families may use either technique; `expect(1)` is preferred when the test spans two binary invocations, absence-of-mount is simpler for single-invocation tests.

**Edge cases**:
- **(EC-1) Expired cache (TTL = 7 days)**: On the 7th day (`num_days() >= 7`), all paths return `Ok(None)`. The caller issues a fresh HTTP request. This is a cold miss, not a warm hit.
- **(EC-2) Corrupt cache file (parse failure)**: `serde_json::from_str` fails → returns `Ok(None)` + stderr warning. The caller issues a fresh HTTP request (self-healing behavior; BC-6.2.002). All 9 families implement this self-heal path.
- **(EC-3) Missing cache file (first run)**: File not found → returns `Ok(None)`. The caller issues an HTTP request (cold miss; BC-6.2.001).
- **(EC-4) Family-8 (request-type) cache is per-`(profile, service_desk_id)` tuple**: The filename is `request_types_<service_desk_id>.json`. Two different service desk IDs have independent warm-hit paths; a warm hit on SID-1 does NOT satisfy SID-2's cache.
- **(EC-5) Family-9 (RT-fields) cache is per-`(profile, service_desk_id, rt_id)` triple**: The filename is `request_type_fields_<service_desk_id>_<rtId>.json`. Independent per-triple.

**Source**: `src/cache.rs::read_cache` (generic warm-hit path — lines 16–34); `src/cache.rs::read_project_meta` (bespoke per-entry inline warm path, lines 159–185); `src/cache.rs::read_object_type_attr_cache` (bespoke per-file inline warm path, lines 389–413); wiremock integration tests that pin `expect(1)` per-family: `tests/requesttype_commands.rs` (`test_requesttype_list_cache_hit_no_second_http`, `test_requesttype_fields_cache_hit_no_second_http`); `tests/issue_edit_field.rs` (`test_bc_3_4_015_warm_fields_cache_skips_field_list_http`); workspace warm-hit: holdout H-037 (workspace ID cache no-HTTP); `tests/cache_warm_hit.rs` (`test_cmdb_fields_warm_cache_skips_http` — call-count-pin technique, Family 4; `test_object_type_attrs_warm_cache_skips_http` — call-count-pin technique, Family 5)

**Trace**: `src/cache.rs::read_cache` (generic warm-hit return path, Families 1/3/4/6/7/8/9); `src/cache.rs::read_project_meta` (bespoke inline warm path, Family 2); `src/cache.rs::read_object_type_attr_cache` (bespoke inline warm path, Family 5); `src/cache.rs::read_workspace_cache`, `read_fields_cache`, `read_request_type_cache`, `read_request_type_fields_cache` (all delegate to `read_cache<T>`); D2 no-HTTP verification: `tests/requesttype_commands.rs` (`test_requesttype_list_cache_hit_no_second_http`, `test_requesttype_fields_cache_hit_no_second_http` — call-count-pin technique, Families 8+9); `tests/issue_edit_field.rs` (`test_bc_3_4_015_warm_fields_cache_skips_field_list_http` — absence-of-mount technique, Family 6); holdout H-037 (call-count-pin technique, Family 3); `tests/cache_warm_hit.rs` (`test_cmdb_fields_warm_cache_skips_http` — call-count-pin technique, Family 4; `test_object_type_attrs_warm_cache_skips_http` — call-count-pin technique, Family 5).

**Coverage note (F2 pass-5, updated S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1)**: All nine families are individually pinned with dedicated no-HTTP tests. **TEST-PINNED families** (dedicated test explicitly pins the no-HTTP property for this specific family): Family 1 (teams), Family 2 (project-meta), Family 7 (resolutions) via `tests/cache_warm_hit.rs` (call-count-pin technique — `expect(1)` across two subprocess invocations); Family 3 (workspace ID) via holdout H-037 (call-count-pin technique); Family 4 (CMDB fields) via `tests/cache_warm_hit.rs` (`test_cmdb_fields_warm_cache_skips_http` — call-count-pin technique, `expect(1)` on `GET /rest/api/3/field`); Family 5 (object-type-attrs) via `tests/cache_warm_hit.rs` (`test_object_type_attrs_warm_cache_skips_http` — call-count-pin technique, `expect(1)` on `GET .../objecttype/.../attributes`); Family 6 (Jira fields) via `tests/issue_edit_field.rs` (`test_bc_3_4_015_warm_fields_cache_skips_field_list_http` — absence-of-mount technique); Families 8+9 (request-type list/fields) via `tests/requesttype_commands.rs` (`test_requesttype_list_cache_hit_no_second_http`, `test_requesttype_fields_cache_hit_no_second_http` — call-count-pin technique).

| Version | Date | Author | Change |
|---------|------|--------|--------|
| 1.0.0 | 2026-06-27 | product-owner | Initial BC-6.2.018 (cache warm-hit no-HTTP invariant; genuinely new ID; D2 dimension anchor) |
| 1.1.0 | 2026-06-27 | product-owner | F2 pass-1 fixes: (F-1) separated behavioral invariant from mechanism — 7 families via `read_cache<T>`, 2 families (project-meta, object-type-attrs) via bespoke inline warm paths; removed overclaim that all 9 route through `read_cache<T>`; (F-2) corrected test file citation from `tests/issue_commands.rs` to `tests/issue_edit_field.rs` in Source and Trace |
| 1.2.0 | 2026-06-27 | product-owner | F2 pass-4 LOW observation fix: added "Coverage honesty note" to Trace field distinguishing TEST-PINNED families (Families 3/6/8/9 with explicit per-family `expect(1)` tests) from families whose zero-HTTP property holds by shared mechanism but lacks an individually-pinned test (Families 1/2/4/5/7). Frames the un-pinned families as candidates for future `expect(1)` coverage; does not overstate proof. No behavioral invariant, BC count, EC, Source, or CANONICAL-COUNTS changed. |
| 1.3.0 | 2026-06-27 | product-owner | F2 pass-5 precision fix: corrected D2 paragraph to acknowledge TWO verification techniques — (i) wiremock `expect(1)` call-count pin (Families 8+9 via `requesttype_commands.rs`, Family 3 via holdout H-037) and (ii) absence-of-mount (Family 6 via `test_bc_3_4_015_warm_fields_cache_skips_field_list_http`). Previous framing falsely implied Family 6 uses `expect(1)` — it does not (confirmed by reading the test: "Deliberately do NOT mount GET /rest/api/3/field"). Coverage honesty note updated: Family 6 now correctly labeled "absence-of-mount technique" not "wiremock `expect(1)`". Trace updated to distinguish techniques per family. No behavioral invariant or BC count changed. |
| 1.4.0 | 2026-06-27 | product-owner | S-CMDB-OBJTYPE-WARM-HIT-COVERAGE-1: coverage note updated — Families 4 (CMDB fields) and 5 (object-type-attrs) are now individually pinned via `tests/cache_warm_hit.rs` (`test_cmdb_fields_warm_cache_skips_http`, `test_object_type_attrs_warm_cache_skips_http`; call-count-pin technique). All nine families are now individually pinned. Source and Trace updated with new test citations. No behavioral invariant, BC count, or EC changed. |

---

### 6.3 Multi-Profile Fields — MUST-FIX (NFR-R-D)

#### BC-6.3.001: Per-profile `story_points_field_id` and `team_field_id` survive `Config::save_global()` and are read by ALL hot-path read sites [MUST-FIX: NFR-R-D — CRITICAL]

**Confidence**: HIGH
**Source**: Multiple sites (BUG: 14 hot-path read sites use `config.global.fields.*`)

> **MUST-FIX (CRITICAL — NFR-R-D):** Current code has 14 hot-path read sites still reading
> from `config.global.fields.story_points_field_id` / `config.global.fields.team_field_id`
> (the legacy `[fields]` block). After ANY `Config::save_global()` call (e.g., `jr auth login`,
> `jr auth switch`, `jr init`), the `[fields]` block is dropped from disk (due to
> `#[serde(default, skip_serializing)]` at `src/config.rs:43-48`). All 14 read sites
> then observe `None` — columns silently disappear. This contract describes the FIXED behavior.

**Spec contract (fixed behavior — round-trip invariant):**
```
For all profiles P and all field-id pairs (sp, team) where:
  config.global.profiles[P].story_points_field_id == Some(sp) AND
  config.global.profiles[P].team_field_id == Some(team)

After config.save_global() followed by Config::load_with(Some(P)):
  config.active_profile().story_points_field_id MUST == Some(sp)
  config.active_profile().team_field_id MUST == Some(team)

AND every read site in the table below MUST observe (sp, team) from active_profile(),
not from global.fields.* (which no longer exists on disk post-save).
```

**Hot-path read sites that MUST be migrated:**

| # | File:Line | Field | Used for |
|---|-----------|-------|----------|
| 1 | `src/cli/issue/list.rs:147` | `story_points_field_id` | `--points` column |
| 2 | `src/cli/issue/list.rs:148` | `team_field_id` | Team column gating |
| 3 | `src/cli/issue/view.rs:28` | `story_points_field_id` | Points display |
| 4 | `src/cli/issue/view.rs:29` | `team_field_id` | Team display |
| 5 | `src/cli/issue/helpers.rs:43` | `team_field_id` | `resolve_team_field()` short-circuit |
| 6 | `src/cli/issue/helpers.rs:194` | `story_points_field_id` | `compose_extra_fields()` |
| 7 | `src/cli/issue/helpers.rs:200` | `team_field_id` | `compose_extra_fields()` |
| 8 | `src/cli/issue/helpers.rs:209` | `story_points_field_id` | `resolve_story_points_field_id()` |
| 9 | `src/cli/sprint.rs:232` | `story_points_field_id` | Sprint issue points |
| 10 | `src/cli/sprint.rs:233` | `team_field_id` | Sprint issue team |
| 11 | `src/cli/board.rs:192` | `team_field_id` | Board view team gating |
| 12 | `src/cli/issue/create.rs:128` | `story_points_field_id` | `--points` field injection in create body |
| 13 | `src/cli/issue/create.rs:277` | `team_field_id` | Team field injection in create body |
| 14 | `src/cli/issue/create.rs:283` | `story_points_field_id` | Points field injection in create body (second site) |

**Fix mechanism (per ADR-0007):** Route all field reads through the `Config::field_id(FieldKind, profile)` accessor introduced in ADR-0007. This accessor resolves to `config.global.profiles[profile].story_points_field_id` (or `team_field_id`), not to the deprecated `config.global.fields.*` path. No fallback to `global.fields.*` is permitted after the fix is applied.

**Fix pattern (equivalent shorthand):** Replace every `config.global.fields.X` read with `config.active_profile().X` (or `config.active_profile_or_err()?.X`). The `Config::field_id` accessor is the preferred call site for new code.

**User-visible symptoms (current bug state):**
1. `jr issue list --points` — points column blank after first save
2. `jr issue list` — Team column disappears
3. `jr issue view <KEY>` — points and team drop off
4. `jr sprint current` — points + team missing
5. `jr board view` — team column missing
6. `jr issue create --points 5` — fails with error pointing at broken legacy block
7. Multi-profile users: silently use wrong field IDs across profiles

**Holdout:** H-NEW-MP-001 — Per-profile field IDs survive `Config::save_global()` round-trip and are observed by all hot-path read sites.

**Error taxonomy:** `JrError::ConfigError("Story points field not configured. Run \"jr init\" or set story_points_field_id under [profiles.<name>] in ~/.config/jr/config.toml")` — note: error message must be updated to reference `[profiles.<name>]` not `[fields]`.

**Error-message strings to update (Phase 3 implementation checklist):**

The following BCs contain pinned stderr/error-message text that references the deprecated `[fields]` section and MUST be updated as part of the NFR-R-D fix:

| BC | File | Current (wrong) text | Required (fixed) text |
|----|------|---------------------|----------------------|
| BC-2.2.021 | `src/cli/issue/list.rs:756-770` | `set [fields].story_points_field_id in ~/.config/jr/config.toml` | `set story_points_field_id under [profiles.<name>] in ~/.config/jr/config.toml` |
| BC-6.3.001 (this) | `src/cli/issue/helpers.rs` | any reference to `[fields]` in ConfigError messages | `[profiles.<name>]` |

These pinned-text changes are load-bearing for the holdout H-NEW-MP-001 verification step.

**Trace**: NFR-R-D; NEW-INV-12; NEW-INV-143; `jira-cli-bc-nfr-r-d-draft.md`; Pass 8 §5.2

---

## Key Invariants

- Profile-name max 64 chars; charset `[A-Za-z0-9_-]`; Windows reserved names blocked
- Migration write-back uses file-only baseline
- Cache TTL: 7 days; `>= 7` is expired (not `> 7`)
- Cache directory: `~/.cache/jr/v1/<profile>/` (Unix); `%LOCALAPPDATA%\jr\v1\<profile>\` (Windows) — see BC-6.2.004, BC-6.2.016
- Config directory: `~/.config/jr/` (Unix); `%APPDATA%\jr\` (Windows) — see BC-6.1.014
- Non-atomic writes are the documented contract; self-heal on read
- Cross-profile cache isolation: convention-enforced today (naming convention, not type system); ADR-0011 amendment (cycle-003 `auth-profile-dx`, DEC-317) ACCEPTS a compile-time `Profile(String)` newtype hard fence as the target — design-accepted, NOT yet implemented (F4 story `S-cycle3-adr0011-newtype`); see BC-6.2.015 (amended)
- `config.active_profile()` is the SOLE source of truth for per-profile custom field IDs post-fix
- `JR_CONFIG_DIR` / `JR_CACHE_DIR` override path resolution in debug builds only; no-op in release — see BC-6.2.017
- XDG env vars (`XDG_CONFIG_HOME`, `XDG_CACHE_HOME`) are consulted ONLY on `#[cfg(not(windows))]` — not on Windows builds
- `ProfileConfig.env: Option<String>` — additive, free-form environment/role tag; tolerant reader (absent key → `None`); no migration required; see BC-6.1.015 (cycle-003, DEC-314/ADR-0020 §4)
- No `v1→v2` cache-root bump and no keychain-namespace version marker this cycle (DEC-325a, ADR-0020 §3) — see BC-6.2.004/BC-6.2.016 confirmations
