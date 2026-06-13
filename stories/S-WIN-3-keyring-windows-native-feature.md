---
document_type: story
story_id: "S-WIN-3"
title: "Add keyring windows-native feature to Cargo.toml; verify deny.toml compatibility"
wave: feature-followup
status: ready
intent: feature
feature_type: backend
mode: feature
scope: small
severity: MEDIUM
trivial_scope: false
points: 2
priority: P0
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0.5
target_module: cargo
subsystems: []
depends_on: []
blocks: ["S-WIN-4"]
bc_anchors: []
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors:
  - NFR-P-W1
  - NFR-S-F
adr_refs:
  - ADR-0016
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-001/windows-build/delta-analysis.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations: ["R-W1"]
created: "2026-06-12"
last_updated: "2026-06-13 (F-WIN3-RA-101 count correction: 7 arch crates, 17 entries exact)"
breaking_change: false
files_modified:
  - Cargo.toml    # keyring: add "windows-native" to features list
  - deny.toml     # REQUIRED: add 17 [[bans.skip]] entries across three windows-targets tiers — windows-sys 0.60 + windows-targets {0.42, 0.53} + 7 windows_* arch crates × {0.42, 0.53} = 1 + 2×(1+7) = 17. Arch crates: windows_aarch64_gnullvm, windows_aarch64_msvc, windows_i686_gnu, windows_i686_msvc, windows_x86_64_gnu, windows_x86_64_gnullvm, windows_x86_64_msvc. windows_i686_gnullvm is NOT skipped (no 0.42 tier; only 0.52.6+0.53.1 in Cargo.lock; cargo deny tolerates it). 0.52.6 is the single canonical un-skipped version (cargo-deny needs only N-1 skipped per version cluster). Scope correction per F-WIN3-IMPL-102 / architecture-delta §5.3 / ADR-0016 Decision 5b scope correction / PG-WIN3-001 / F-WIN3-RA-101.
---

# S-WIN-3 — Keyring `windows-native` Feature

## Source of Truth

Delta analysis: `.factory/cycles/cycle-001/windows-build/delta-analysis.md §4.1`
Architecture delta: `.factory/cycles/cycle-001/windows-build/architecture-delta.md §5`
ADR-0016: `.factory/architecture/adr/0016-windows-build-target.md §Decision 5b`
NFR-P-W1: `.factory/specs/prd/nfr-catalog.md §NFR-P-W1`

## Behavioral Contracts

No new BC is produced by this story. The `windows-native` keyring feature is a
compile-time enablement of an OS credential-store backend. The existing
BC-1.4.027 (per-profile keychain key layout) already governs credential storage
behavior; the `windows-native` feature makes BC-1.4.027 hold on Windows.

**NFR-P-W1** is the tracing NFR: a fully functional Windows binary requires
credentials to persist across invocations, which requires the Windows Credential
Manager backend (`windows-native`).

## Story Narrative

As a developer building `jr` for Windows,
I want the `keyring` crate to use the `windows-native` feature,
so that credentials are stored in Windows Credential Manager and `jr auth login`
works correctly on Windows (credentials persist between invocations),
and I want `cargo deny check` to remain clean after the feature is added.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~800 |
| Cargo.toml (relevant section) | ~200 |
| deny.toml (relevant section) | ~300 |
| architecture-delta.md §5 | ~500 |
| **Total** | **~1,800** |

Very small. No splitting required.

## Previous Story Intelligence

**N/A — first story in this Windows-build feature cycle (keyring is independent).**

This story is independent of S-WIN-1 and S-WIN-2. It touches `Cargo.toml` and
`deny.toml` (both changes are required — see C-V2(b) correction). No `src/` source
code changes.

**Colon-in-keychain-key portability (load-bearing gotcha):**
`src/api/auth.rs` uses per-profile keys of the form `<profile>:oauth-access-token`.
The colon character is valid in Windows Credential Manager target names (verified
against keyring-rs v3.6.3 `src/windows.rs` and `CredWriteW` docs — architecture-delta.md §5.2).
No change to `src/api/auth.rs` is required. F4 must NOT modify auth.rs.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| All three platform features listed | ADR-0016 §Decision 5b | `Cargo.toml` must list `["apple-native", "linux-native", "windows-native"]`. The three features are mutually non-exclusive; each is `cfg`-gated to its OS at compile time. |
| No auth.rs change | architecture-delta.md §5.2 | The keyring abstraction handles platform differences internally. Service name `jr-jira-cli` and per-profile key naming are portable to Windows unchanged. No changes to `src/api/auth.rs`. |
| deny.toml required | C-V2(b) research finding (`.factory/research/windows-build-f4-preflight-verification.md`); NFR-S-F | The `windows-native` feature of keyring v3.6.3 pulls `windows-sys = "0.60"` (confirmed from keyring Cargo.toml primary source). jr's deny.toml has existing skips only for 0.45 and 0.61. With `bans.multiple-versions = "deny"` and 0.x semver (0.60 and 0.61 are incompatible; Cargo will NOT unify them), adding `windows-native` WITHOUT a skip entry **will cause `cargo deny check` to fail**. A `[[bans.skip]]` entry for `windows-sys` version `0.60` MUST be added in the SAME commit as the Cargo.toml change. This is not conditional — the skip is required. |
| No new source code | N/A | This story adds a string to Cargo.toml and a `[[bans.skip]]` entry to deny.toml. No `src/` files change. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| keyring | 3.x (current Cargo.toml) | Add `"windows-native"` to the existing features list. The three platform features are cfg-gated at keyring's compile time; all three can be listed simultaneously. |
| windows-sys | 0.60 (transitive via keyring `windows-native`) | keyring v3.6.3 declares `windows-sys = { version = "0.60", ... }` under `cfg(target_os = "windows")`. Cargo cannot unify 0.60 with the existing 0.45 (jni/rustls-platform-verifier) or 0.61 (clap/tokio/reqwest) under 0.x semver — three incompatible versions. A `[[bans.skip]]` entry is required in deny.toml. Research citation: C-V2(b), `.factory/research/windows-build-f4-preflight-verification.md`. |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `Cargo.toml` | MODIFY | Change `keyring = { version = "3", features = ["apple-native", "linux-native"] }` to `keyring = { version = "3", features = ["apple-native", "linux-native", "windows-native"] }` |
| `deny.toml` | MODIFY (REQUIRED, not conditional) | Add exactly 17 `[[bans.skip]]` entries across three windows-targets tiers in the same commit as the Cargo.toml change. Formula: 1 (windows-sys 0.60) + 2×(1+7) = 17. Full scope (F-WIN3-IMPL-102 / architecture-delta §5.3 / ADR-0016 Decision 5b scope correction / PG-WIN3-001 / F-WIN3-RA-101): windows-sys 0.60 (keyring windows-native), windows-targets {0.42, 0.53} (transitive from windows-sys version tiers), and 7 windows_* arch crates × {0.42, 0.53} tiers (windows_aarch64_gnullvm, windows_aarch64_msvc, windows_i686_gnu, windows_i686_msvc, windows_x86_64_gnu, windows_x86_64_gnullvm, windows_x86_64_msvc). **windows_i686_gnullvm is NOT in the skip set** — it has no 0.42 tier (only 0.52.6 and 0.53.1 appear in Cargo.lock), so cargo deny tolerates it with no skip entry required; adding a skip would be unmatched. The 0.52.6 tier is the single canonical un-skipped version; cargo-deny requires skipping only N-1 tiers per name (so 0.42 + 0.53 are skipped, 0.52.6 is left as the un-skipped canonical). Each entry is mechanical (name + version + reason); estimated ~80 lines total. The lead entry for windows-sys 0.60: `[[bans.skip]] / name = "windows-sys" / version = "0.60" / reason = "keyring v3.6.3 windows-native feature requires windows-sys 0.60 (Win32_Security_Credentials); jni (via rustls-platform-verifier) requires 0.45 and the broad graph (clap/tokio/reqwest) requires 0.61. Three semver-incompatible 0.x majors; unification blocked upstream until keyring bumps windows-sys."` |

## Acceptance Criteria

### AC-001 — `Cargo.toml` lists all three platform features for keyring
(traces to NFR-P-W1 — Windows binary must have functional credential storage; ADR-0016 §Decision 5b)

`Cargo.toml` contains `keyring = { version = "3", features = [..., "windows-native"] }`.
All three platform features (`apple-native`, `linux-native`, `windows-native`) are listed.

Pinned by: `tests/keyring_windows_native_feature_present.rs::test_keyring_has_windows_native_feature`
(source-text grep of Cargo.toml confirming `windows-native` is listed)

---

### AC-002 — `deny.toml` contains the full windows-sys 0.60 + transitive skip set and `cargo deny check` passes
(traces to NFR-S-F — cargo-deny supply chain hardening; R-W1 mitigation; C-V2(b) BLOCKER finding; scope correction: F-WIN3-IMPL-102 / architecture-delta §5.3 / ADR-0016 Decision 5b / PG-WIN3-001)

`deny.toml` contains `[[bans.skip]]` entries for `name = "windows-sys"` `version = "0.60"` AND
the transitive fan-out: `windows-targets` versions `{0.42, 0.53}` plus the 7 windows_* arch
crates (windows_aarch64_gnullvm, windows_aarch64_msvc, windows_i686_gnu, windows_i686_msvc,
windows_x86_64_gnu, windows_x86_64_gnullvm, windows_x86_64_msvc) each at versions `{0.42, 0.53}`.
**windows_i686_gnullvm is NOT in the skip set** — it has no 0.42 tier and cargo deny
tolerates it; a skip entry would be unmatched (canonical un-skipped version: 0.52.6).
The 0.52.6 tier of windows-targets and the 7 windows_* arch crates is left as the canonical
un-skipped version (cargo-deny needs only N-1 skips per name cluster).
Total: exactly 17 skip entries (formula: 1 + 2×(1+7) = 17; ~80 lines). All entries are in
the SAME commit as the `windows-native` Cargo.toml change.

Running `cargo deny check` exits 0 after all changes are applied.

Concrete verification: the test `test_deny_toml_has_windows_sys_0_60_skip` greps `deny.toml` for
a `windows-sys` skip entry whose version field matches `0.60`. The implementer extended the test
to also assert a `windows-targets` version `0.53` skip entry and a representative `windows_x86_64_msvc`
version `0.53` skip entry (pinning the transitive tier per F-WIN3-IMPL-102). Without the full set,
`cargo deny check` fails with `bans.multiple-versions` violations across the windows-targets /
arch-crate subtree (transitive fan-out from windows-sys 0.60 dragging in the 0.53 tier alongside
the existing 0.42 lineage from jni and the 0.52.6 lineage from ring).

Pinned by:
1. `tests/keyring_windows_native_feature_present.rs::test_deny_toml_has_windows_sys_0_60_skip` (extended — also asserts windows-targets 0.53 and a representative windows_* 0.53 skip per F-WIN3-IMPL-102)
2. CI `cargo deny check` step (always-on in the existing `deny` job in `ci.yml`).

---

### AC-003 — `cargo build --release --target x86_64-pc-windows-msvc` succeeds in CI
(traces to NFR-P-W1 — release build must succeed; ADR-0016 §Decision 1)

The Windows release build in the `release.yml` CI matrix succeeds without linker
errors or missing-feature compile failures. The `windows-native` feature enables
the Windows Credential Manager backend.
_This AC is validated by S-WIN-4 (release.yml matrix) executing and producing the artifact._

---

### AC-004 — macOS and Linux builds are unaffected
(traces to NFR-P-W1 invariant — existing platform builds must remain green)

Adding `windows-native` to the features list does not change the macOS or Linux
build artifacts (the feature is cfg-gated at compile time in keyring's source).
`cargo test` on Ubuntu and macOS CI runners passes with no new failures.

Pinned by: existing CI runs on `ubuntu-latest` and `macos-latest` (no new test).

---

## Out of Scope (explicit)

- **`src/api/auth.rs` changes**: not needed. Keyring abstraction handles platform differences.
- **Release pipeline matrix**: implemented in S-WIN-4.
- **Windows CI job**: implemented in S-WIN-5.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `keyring` crate backend selection | `Cargo.toml` features | N/A (compile-time) | `windows-native` enables Windows Credential Manager backend via cfg-gated conditional compilation in keyring v3 |

**Dependency anchor:** `depends_on: []` — independent of all other S-WIN-* stories.
Can be implemented in parallel with S-WIN-1, S-WIN-2, S-WIN-4.

**Blocks: ["S-WIN-4"]** — S-WIN-4 (`depends_on: ["S-WIN-3"]`) requires the `windows-native`
feature to be present for the Windows release build to link successfully. S-WIN-5 also
needs the feature at runtime but does not declare a hard dependency in its frontmatter
(its AC gates on the build succeeding, not on this story's merge status directly).

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC / BC |
|----|--------|-------------|-------------------|---------|
| EC-001 | C-V2(b) BLOCKER — `.factory/research/windows-build-f4-preflight-verification.md`; R-W1; implementation-confirmed scope correction: F-WIN3-IMPL-102, architecture-delta §5.3, ADR-0016 Decision 5b scope correction, PG-WIN3-001, F-WIN3-RA-101 | `windows-native` in keyring v3.6.3 pulls `windows-sys = "0.60"`. A new windows-sys minor version drags in a new windows-targets tier (0.53) plus the matching 7 windows_* arch-crate versions (0.53 tier), each of which collides with the pre-existing 0.42 lineage (from jni) and the 0.52.6 lineage (from ring) under `bans.multiple-versions = "deny"`. windows_i686_gnullvm is NOT included — it has no 0.42 tier (only 0.52.6+0.53.1 in Cargo.lock) and cargo deny tolerates it without a skip. The transitive fan-out is exactly 17 [[bans.skip]] entries (formula: 1 + 2×(1+7) = 17; windows-sys 0.60 + windows-targets {0.42, 0.53} + 7 arch crates × {0.42, 0.53}); 0.52.6 is the single un-skipped canonical. The original spec estimated "1 entry / trivial 4 lines" — that underestimated the transitive tier; the implementation confirmed the full scope (F-WIN3-IMPL-102). | Add the full 17 [[bans.skip]] entries (~80 lines) across all three tiers in the same commit as the Cargo.toml change. Each entry is mechanical (name + version + reason). This is a REQUIRED change, not a conditional fallback. | AC-002 |
| EC-002 | architecture-delta.md §5.2 | Per-profile keychain keys contain colons (e.g., `default:oauth-access-token`) | Colon is valid in Windows Credential Manager target names (verified); no key sanitization needed | (no test; architecture decision, not runtime behavior) |
| EC-003 | ADR-0016 §Decision 5b | All three platform features listed simultaneously | Each feature is cfg-gated to its OS in keyring's source; listing all three is the documented-correct approach; macOS/Linux builds remain unaffected | AC-004 |

---

## Test Coverage Summary

| Test name | File | NFR/AC |
|-----------|------|--------|
| `test_keyring_has_windows_native_feature` | `tests/keyring_windows_native_feature_present.rs` (new) | AC-001 |
| `test_deny_toml_has_windows_sys_0_60_skip` | `tests/keyring_windows_native_feature_present.rs` (new) | AC-002 |

`test_keyring_has_windows_native_feature` is a source-text grep of `Cargo.toml` confirming
`"windows-native"` is present in the keyring features list. This mirrors the pattern of
`tests/base_url_release_gate.rs` (source-text assertion). The test never executes
Credential Manager code — it just confirms the feature declaration is present.

`test_deny_toml_has_windows_sys_0_60_skip` is a source-text grep of `deny.toml` confirming
a `[[bans.skip]]` entry exists for `windows-sys` with `version = "0.60"`. This guards
against the C-V2(b) BLOCKER: if the skip is absent, `cargo deny check` will fail when
the Windows build target graph materializes three incompatible windows-sys versions.

---

## Holdout Scenarios

**H-WIN-5: Windows `jr auth login` credentials persist**
After `jr auth login` on a Windows runner with `JR_RUN_KEYRING_TESTS=1`,
`jr auth status` returns the stored credentials in the same profile.
Windows Credential Manager entry is created under service `jr-jira-cli`.
_This is a keyring-gated test; validated manually or via `JR_RUN_KEYRING_TESTS=1` in CI._

---

## Dependency Analysis

**depends_on: []** — This story is independent. Wave 1 in the Windows-build wave schedule.

**No cycle.** S-WIN-4 (`depends_on: ["S-WIN-3"]`) requires this story for the Windows
release build to link successfully — hence `blocks: ["S-WIN-4"]`. S-WIN-5 also needs
the feature at runtime but can be dispatched in parallel; the final Windows CI green
requires all stories merged. There is no dependency loop.

---

## Tasks

1. Read current `Cargo.toml` to find the exact `keyring` dependency line.
2. Add `"windows-native"` to the keyring features list in `Cargo.toml`.
3. Read current `deny.toml` to find the existing `[[bans.skip]]` entries for `windows-sys`.
4. Add the full 17 `[[bans.skip]]` entries to `deny.toml` in the SAME commit as step 2: windows-sys 0.60, windows-targets {0.42, 0.53}, and the 7 windows_* arch crates × {0.42, 0.53} (formula: 1 + 2×(1+7) = 17) — see File Structure Requirements for the complete list and reason strings. Note: windows_i686_gnullvm is NOT in the list (no 0.42 tier; 0.52.6 canonical; cargo deny tolerates it). (REQUIRED, not conditional — C-V2(b) + F-WIN3-IMPL-102 + F-WIN3-RA-101 scope correction. 0.52.6 is the single un-skipped canonical per name; skip only N-1 tiers.)
5. Run `cargo deny check` — must exit 0 with both changes applied.
6. Create `tests/keyring_windows_native_feature_present.rs` with two source-text grep assertions: `test_keyring_has_windows_native_feature` (Cargo.toml) and `test_deny_toml_has_windows_sys_0_60_skip` (deny.toml).
7. Run `cargo test --test keyring_windows_native_feature_present` — both tests pass.
8. Run `cargo test --lib` (full unit test suite) — no regressions.
9. Run `cargo clippy -- -D warnings` — zero warnings.

## Story Points and Effort

**2 story points.** Very small change; a one-line edit to Cargo.toml plus the
required deny.toml ~17 skip entries (all mechanical) and two lightweight source-text tests.

Breakdown:
- F4 implementation (Cargo.toml edit + deny.toml 17 skip entries across windows-sys/windows-targets/arch-crate tiers + two source-text tests): 1 SP
- F5/F7 adversarial review + PR: 1 SP

Note: deny.toml change is now REQUIRED (not conditional) per C-V2(b) research finding.
The overall size estimate remains 2 SP because every entry in the 17-entry / ~80-line
deny.toml block is mechanical (name + version + reason) — the entry COUNT is larger than
originally estimated ("1 entry / 4 lines"), but no algorithmic or design complexity was
added. The research finding removed decision uncertainty; the implementation confirmed
the full transitive scope (F-WIN3-IMPL-102 / architecture-delta §5.3 / ADR-0016 Decision
5b scope correction / PG-WIN3-001). Count verified by F-WIN3-RA-101: 7 arch crates (not 8;
windows_i686_gnullvm omitted — no 0.42 tier), formula 1 + 2×(1+7) = 17 exactly. The work
is still xsmall in effort terms.
