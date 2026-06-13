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
last_updated: "2026-06-12"
breaking_change: false
files_modified:
  - Cargo.toml    # keyring: add "windows-native" to features list
  - deny.toml     # CONDITIONAL: add [[bans.skip]] entry only if cargo deny check exits 1 after Cargo.toml change
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

This story is independent of S-WIN-1 and S-WIN-2. It touches only `Cargo.toml`
(and conditionally `deny.toml`). No source code changes.

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
| deny.toml conditional | architecture-delta.md §5.3; NFR-S-F | Run `cargo deny check` after the Cargo.toml change. If it exits 0, no deny.toml change needed. If it exits 1 due to a `windows-sys` version conflict, add the minimal `[[bans.skip]]` entry. Do not pre-emptively add a skip entry. |
| No new source code | N/A | This story adds only a string to Cargo.toml (and conditionally deny.toml). No `src/` files change. |

## Library and Framework Requirements

| Library | Version | Constraint |
|---------|---------|-----------|
| keyring | 3.x (current Cargo.toml) | Add `"windows-native"` to the existing features list. The three platform features are cfg-gated at keyring's compile time; all three can be listed simultaneously. |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `Cargo.toml` | MODIFY | Change `keyring = { version = "3", features = ["apple-native", "linux-native"] }` to `keyring = { version = "3", features = ["apple-native", "linux-native", "windows-native"] }` |
| `deny.toml` | MODIFY (conditional) | If `cargo deny check` exits 1 after the Cargo.toml change, add `[[bans.skip]]` entry for the conflicting `windows-sys` version. If it exits 0, no change. |

## Acceptance Criteria

### AC-001 — `Cargo.toml` lists all three platform features for keyring
(traces to NFR-P-W1 — Windows binary must have functional credential storage; ADR-0016 §Decision 5b)

`Cargo.toml` contains `keyring = { version = "3", features = [..., "windows-native"] }`.
All three platform features (`apple-native`, `linux-native`, `windows-native`) are listed.

Pinned by: `tests/keyring_windows_native_feature_present.rs::test_keyring_has_windows_native_feature`
(source-text grep of Cargo.toml confirming `windows-native` is listed)

---

### AC-002 — `cargo deny check` passes after the Cargo.toml change
(traces to NFR-S-F — cargo-deny supply chain hardening; R-W1 mitigation)

Running `cargo deny check` exits 0 after `windows-native` is added.
If a `windows-sys` version conflict is detected and a `[[bans.skip]]` entry is
added to `deny.toml`, that entry must be minimally scoped (specific version, not
a blanket skip) and include a comment explaining the source.

Pinned by: CI `cargo deny check` step (always-on in the existing `deny` job in `ci.yml`).

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
| EC-001 | architecture-delta.md §5.3; R-W1 | `windows-native` in keyring v3.6.3 pulls in a `windows-sys` version that conflicts with an existing ban in `deny.toml` | `cargo deny check` exits 1; add minimal `[[bans.skip]]` entry; document the source crate and version in a comment | AC-002 |
| EC-002 | architecture-delta.md §5.2 | Per-profile keychain keys contain colons (e.g., `default:oauth-access-token`) | Colon is valid in Windows Credential Manager target names (verified); no key sanitization needed | (no test; architecture decision, not runtime behavior) |
| EC-003 | ADR-0016 §Decision 5b | All three platform features listed simultaneously | Each feature is cfg-gated to its OS in keyring's source; listing all three is the documented-correct approach; macOS/Linux builds remain unaffected | AC-004 |

---

## Test Coverage Summary

| Test name | File | NFR/AC |
|-----------|------|--------|
| `test_keyring_has_windows_native_feature` | `tests/keyring_windows_native_feature_present.rs` (new) | AC-001 |

The test is a source-text grep of `Cargo.toml` confirming `"windows-native"` is present
in the keyring features list. This mirrors the pattern of `tests/base_url_release_gate.rs`
(source-text assertion). The test never executes Credential Manager code — it just
confirms the feature declaration is present.

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
2. Add `"windows-native"` to the keyring features list.
3. Run `cargo deny check` (on a Unix host; the bans check is platform-independent).
4. If `cargo deny check` exits 1: identify the conflicting `windows-sys` version, add a minimal `[[bans.skip]]` entry with a source comment to `deny.toml`.
5. Create `tests/keyring_windows_native_feature_present.rs` with source-text grep assertion.
6. Run `cargo test --test keyring_windows_native_feature_present` — passes.
7. Run `cargo test --lib` (full unit test suite) — no regressions.
8. Run `cargo clippy -- -D warnings` — zero warnings.

## Story Points and Effort

**2 story points.** Very small change; mostly a one-line edit to Cargo.toml plus the
conditional deny.toml update and a lightweight source-text test.

Breakdown:
- F4 implementation (Cargo.toml edit + deny.toml check + source-text test): 1 SP
- F5/F7 adversarial review + PR: 1 SP
