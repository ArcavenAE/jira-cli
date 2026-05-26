---
document_type: f1-business-analyst-input
phase: phase-f1-delta-analysis
producer: business-analyst
issue: 327
status: draft
created: 2026-05-26
project: jira-cli
mode: BROWNFIELD
---

# F1 Business Analyst Input — Issue #327 (`rand` 0.9.4 → 0.10.1)

**Feature:** Bump `rand` from `0.9.4` to `0.10.1`
**Issue link:** https://github.com/Zious11/jira-cli/issues/327
**Research source:** `.factory/research/rand-0.10-migration-assessment.md` (all 8 questions answered; verdict: SMALL-MIGRATION-NEEDED, ≤30 LOC)

---

## BC Mapping

The migration touches exactly one production call site: `generate_state()` in `src/api/auth.rs`.
The function's externally observable behavior — 64-character lowercase hex string from 32 OS-CSPRNG bytes,
used as the OAuth CSRF state parameter — is identical before and after the rename.

### BCs reviewed

| BC ID | Summary | File | Disposition | Justification |
|---|---|---|---|---|
| BC-1.5.035 | `generate_state()` produces 32 bytes from OsRng encoded as 64 hex chars | `.factory/specs/prd/bc-1-auth-identity.md` (line 395) | **unchanged** | The BC specifies observable output: 32 bytes → 64 hex chars. The migration renames the RNG type (`OsRng → SysRng`) and trait (`TryRngCore → TryRng`) but does not change the byte count, encoding, or CSPRNG source (both are thin wrappers over `getrandom(2)` / `BCryptGenRandom`). The BC description currently reads "OsRng" — this rustdoc-level wording is an implementation detail, not a behavioral contract. The BC body does not enumerate the type name; it is safe to leave the BC body as-is. No behavioral amendment needed. |
| BC-1.5.040 | OAuth callback validates state (CSRF check) before token exchange | `.factory/specs/prd/bc-1-auth-identity.md` (line 445) | **unchanged** | State mismatch logic is in the callback handler (`src/api/auth.rs:898`), which reads the state string but does not depend on which RNG generated it. CSRF check behavior is unaffected by the symbol rename. |
| BC-1.5.031 | Embedded OAuth callback URL is exactly `http://127.0.0.1:53682/callback` | `.factory/specs/prd/bc-1-auth-identity.md` (line 355) | **unchanged** | Not touched by the migration. Referenced only because it is in the same `oauth_login` code path that calls `generate_state()`. |
| BC-1.5.039 | OAuth token stored post-login under per-profile keychain keys | `.factory/specs/prd/bc-1-auth-identity.md` (line 435) | **unchanged** | Token storage happens after state validation. Not affected by the symbol rename. |
| BC-1.3.023 | DEFAULT_OAUTH_SCOPES includes `offline_access`, CMDB scopes, `write:jira-work`, `write:servicedesk-request` | `.factory/specs/prd/bc-1-auth-identity.md` (line 264) | **unchanged** | Scope constant is defined in `src/api/auth.rs:34-63`. The migration edits lines 1074-1106 only. Scope definition untouched. |

### BCs searched but not found

A targeted grep of `.factory/specs/` for `OsRng`, `SysRng`, `TryRngCore`, `TryRng`, `generate_state`,
`CSRF`, `rand`, and `entropy` found no additional behavioral contracts in `bc-2-issue-read.md`,
`bc-3-issue-write.md`, `bc-4-assets-cmdb.md`, `bc-5-boards-sprints.md`, `bc-6-config-cache.md`,
`bc-7-output-render.md`, `cross-cutting.md`, or `nfr-catalog.md`.

No BC found in any file that covers the `rand` type name, the `TryRngCore/TryRng` trait,
or the token-size/entropy invariant as a standalone behavioral contract.
The 32-byte / 256-bit entropy floor is captured implicitly in BC-1.5.035 ("32 bytes") and
is preserved by the migration (same `try_fill_bytes` call, same byte count, same CSPRNG backend).

**Summary: all relevant BCs are `unchanged`. No BC requires amendment for this migration.**

---

## Story Risk Zone

Stories that touched `src/api/auth.rs` or the OAuth login flow — their tests must remain green post-migration.

| Story ID | Title | Relevance | Status | File |
|---|---|---|---|---|
| S-1.06 | OAuth flow holdout suite | Directly anchors BC-1.1.001, BC-1.1.002; test suite exercises the `oauth_login` path that calls `generate_state()` | merged (PR #300) | `.factory/stories/wave-1/S-1.06-oauth-flow-holdout-suite.md` |
| S-1.08 | Keychain per-profile layout holdout | Anchors BC-1.4.027, BC-1.4.025; tests token storage/retrieval in `src/api/auth.rs` | merged (PR #302) | `.factory/stories/wave-1/S-1.08-keychain-roundtrip-holdout.md` |
| S-3.01 | Shard-split `src/cli/auth.rs` | Refactored auth CLI dispatcher; regression-tested against BC-1.1.001, BC-1.4.027, BC-7.4.013–016 | completed (PR #319) | `.factory/stories/wave-3/S-3.01-refactor-auth-rs-shard-split.md` |
| S-3.03 | Investigate + wire `refresh_oauth_token` | Anchors BC-1.4.026; edits `src/api/auth.rs` refresh token path (distinct from `generate_state` but in same file) | completed (PR #321) | `.factory/stories/wave-3/S-3.03-refresh-oauth-token-investigation.md` |
| S-3.04 | Multi-cloudId `--cloud-id` flag + prompt | Anchors BC-1.5.038, BC-1.1.007, BC-1.5.031; edits `oauth_login` in `src/api/auth.rs` — same function that calls `generate_state()` | completed (PR #320) | `.factory/stories/wave-3/S-3.04-multi-cloudid-disambiguation.md` |
| issue-288-pr4-dispatch | JSM `issue create --request-type` dispatch + OAuth scope addition | Modifies `DEFAULT_OAUTH_SCOPES` in `src/api/auth.rs` and adds BC-1.3.023 scope pin | completed (PR #381) | `.factory/code-delivery/issue-288-pr4-dispatch/story.md` |

**All are in the regression zone.** The migration patches the `generate_state` call site inside `oauth_login`
(called at `src/api/auth.rs:577`) which is the same function these stories' tests exercise via the OAuth flow
holdout suite (`tests/oauth_flow_holdouts.rs`).

---

## Test Coverage Map

### Unit tests (directly in `src/api/auth.rs`)

| Test name | Lines | What it pins | Notes |
|---|---|---|---|
| `test_generate_state_is_hex` | `src/api/auth.rs:1185-1194` | All 64 chars are `[0-9a-f]` | Calls `generate_state()` directly; renames do not change the entry point |
| `test_generate_state_is_64_hex_chars` | `src/api/auth.rs:1196-1202` | Exactly 64 characters returned | Same — post-migration call is byte-identical from test perspective |
| `test_generate_state_is_not_deterministic` | `src/api/auth.rs:1205-1224` | 8 calls produce 8 distinct values | Probabilistic sanity check on OS CSPRNG liveness |

These three tests exercise the full post-migration code path. They call `generate_state()` directly,
so the rename of internal types (`OsRng → SysRng`, `TryRngCore → TryRng`) is transparent to them.
No test modification expected or required.

### Integration tests

| File | Coverage of `generate_state` path | Gate |
|---|---|---|
| `tests/oauth_flow_holdouts.rs` | Exercises `oauth_login` path; state is generated but its hex-format is not independently asserted at integration level (the unit tests own that pin) | No gate — runs in CI unconditionally |
| `tests/oauth_embedded_login.rs` | `#[ignore]` — returns early unless `JR_RUN_OAUTH_INTEGRATION=1`; stubs `unimplemented!()` per BC-1.3.024 | Ignored in routine CI |
| `tests/oauth_refresh_integration.rs` | Covers refresh path (`refresh_oauth_token`), not login/`generate_state` | Relevant to regression zone but not directly to `generate_state` |
| `tests/auth_profiles.rs` | Covers profile resolution, login config writes; does not invoke `generate_state` end-to-end via HTTP mock | In regression zone (S-1.06, S-3.04) |

No integration test constructs an end-to-end OAuth login via wiremock that would catch a compile-time
symbol-rename failure. However, this is moot: the compiler itself will catch any symbol-resolution failure
at `cargo build` (Step 1 of the test plan in the research assessment).

### Property tests (proptest)

No `proptest!` block in `src/api/auth.rs` uses `rand` directly. The existing `proptest!` macro
at `src/cli/issue/create.rs` (label-coalesce path) pulls `rand 0.9` transitively through proptest 1.x —
this is a separate dependency subtree unaffected by the `jr` direct-dep bump to `rand 0.10`.

---

## VP Extension Needs

The project does not maintain a formal Verification Properties (VP-NNN) directory.
A search of `.factory/specs/` found no `VP-` identifiers or a `verification-properties/`
subdirectory. The L2 domain spec directory (`.factory/specs/domain-spec/`) contains
`state-machines.md` which references rand/OsRng indirectly, and `bc-01-auth-identity.md`.

| Item searched | Result |
|---|---|
| `.factory/specs/verification-properties/` | Does not exist |
| `VP-` pattern in any `.factory/**/*.md` | No matches |
| NFR catalog entries for entropy/CSPRNG | No matches in `nfr-catalog.md` |
| Holdout H-047 (closest related holdout — CSRF state validation path) | Covers multi-cloudId disambiguation, not generate_state entropy. Status: MUST-PASS. Not affected. |

**Conclusion:** No VP extension needed. The 32-byte entropy invariant is implicitly captured by
BC-1.5.035 ("32 bytes") and by the three unit tests. No formal VP artifact exists in this project
that governs the `generate_state` path.

---

## Feature Type Classification

**Classification: `infrastructure`**

Justification: This is a Cargo dependency version bump that touches one helper function in one
source file (`src/api/auth.rs`). There is no new CLI surface, no new API endpoint, no new user-visible
behavior, no schema change, and no UX change. The only change is adapting to the upstream library's
renamed symbols (`OsRng → SysRng`, `TryRngCore → TryRng`). This fits the `infrastructure` tier:
build/dependency-level change with a thin runtime footprint (one function, one call site).

---

## Intent Classification

**Classification: `enhancement`**

Justification: This is a dependency-stack improvement — upgrading to the latest major version of `rand`
for correctness (resolving CI failure due to breaking symbol rename), security hygiene (0.10.1 is the
patched release for GHSA-cq8v-f236-94qc, though our code path is unaffected), and ecosystem alignment.

**Convention check:** All four existing F1 analyses reviewed used `enhancement` for non-bug-fix
dependency or capability improvements:
- `issue-396/delta-analysis.md`: `intent: enhancement`
- `issue-398/delta-analysis.md`: `intent: "enhancement"`
- `issue-388/delta-analysis.md`: `intent: enhancement`
- `issue-382/delta-analysis.md`: `intent: enhancement`

This migration matches that convention. (The `test-hardening` intent in issue-407 was specifically
for a test-only story with no production code change — not applicable here.)

---

## Cross-Cutting Concerns

### 1. GHSA-cq8v-f236-94qc soundness bug — no doc amendment needed

The research assessment (`.factory/research/rand-0.10-migration-assessment.md`, Question 3) confirms
the bug does not affect this codebase: it requires `ThreadRng` + a custom `log` logger + reseed during
a logger borrow — none of which apply to `jr`. No project document claims "our rand version is patched"
or references the GHSA in a way that would require update.

A search of `.factory/` for `GHSA-cq8v-f236-94qc` and `RUSTSEC-2026-0097` found no references.
No doc amendment required.

### 2. `deny.toml` — `[[bans.skip]]` entries REQUIRED

`deny.toml` has `bans.multiple-versions = "deny"` (line 20) and currently has no `[[bans.skip]]`
entries for `rand` or `rand_core`. After the bump:

- `jr` direct dep → `rand 0.10`
- `proptest 1.x` → `rand 0.9` (transitive, dev-dep)
- Possibly `quinn-proto` (via reqwest/rustls) → `rand 0.9` (transitive, runtime)

`cargo deny check` will fail until `[[bans.skip]]` entries are added for `rand 0.9`, `rand 0.10`,
and likely `rand_core 0.9`/`rand_core 0.10`. The research assessment (Question 6) provides the
exact TOML to add and the rationale strings. This is a **required** scope item for the F4
implementation story — `cargo deny check` is a CI gate.

The existing `[[bans.skip]]` pattern for `getrandom 0.2/0.3/0.4` (three semver-incompatible majors,
same rationale) is the direct analogue. The `deny.toml` amendment follows that established pattern.

No existing `[[bans.skip]]` entry mentions `chacha20` or `cpufeatures`. These are new transitive
dependencies introduced by `rand 0.10`'s internal ChaCha-based PRNGs. Because `deny.toml` currently
does not have any entry for these crates, they will be accepted as single-version transitive deps
with no `[[bans.skip]]` needed — `multiple-versions = "deny"` only fires on duplicates.
If a future dep also pulls `chacha20` or `cpufeatures` at a different version, a skip entry would
then be needed. No action required now.

### 3. `Cargo.toml` version specifier

The current specifier is `rand = "0.9"`. It must become `rand = "0.10"`. The Dependabot PR (#327)
likely already contains this change — the F4 implementer should verify against the PR diff rather
than re-doing it.

### 4. BC-1.5.035 description text — cosmetic, not a spec amendment

BC-1.5.035 reads: "produces 32 bytes from OsRng encoded as 64 hex chars." After migration, `OsRng`
is renamed to `SysRng` in the source. The BC body (`bc-1-auth-identity.md` line 395-401) contains
the word "OsRng" in a descriptive context ("from OsRng"). This is an implementation-detail reference
in a behavioral-contract description. Two options:

- **Option A (recommended):** Leave BC-1.5.035 as-is. The behavioral claim (32 bytes, 64 hex chars)
  is what matters and remains true. "OsRng" as a casual label for "OS CSPRNG" remains accurate
  at the semantic level even when the Rust type is named `SysRng`.
- **Option B:** Update the BC body to read "from `SysRng` (formerly `OsRng`)" for implementation
  fidelity.

This decision belongs to the architect's F2 spec-evolution pass. Flagged here as a cosmetic
consideration, not a behavioral change. BC disposition above is `unchanged` under either option.

---

## Summary for Architect

| Dimension | Assessment |
|---|---|
| BCs affected | 1 (BC-1.5.035 — cosmetic description drift only; behavior unchanged) |
| BC classification | All unchanged — no behavioral delta |
| Stories in regression zone | 6 (S-1.06, S-1.08, S-3.01, S-3.03, S-3.04, issue-288-pr4-dispatch) |
| Unit tests that must pass | 3 (`test_generate_state_is_hex`, `test_generate_state_is_64_hex_chars`, `test_generate_state_is_not_deterministic` — `src/api/auth.rs:1185-1224`) |
| VP extension | None — no VP infrastructure exists in this project |
| Feature type | `infrastructure` |
| Intent | `enhancement` |
| Required scope items | (1) Symbol renames in `src/api/auth.rs` (4 edits, ≤30 LOC); (2) `rand = "0.10"` in `Cargo.toml`; (3) `[[bans.skip]]` additions in `deny.toml` for `rand 0.9`, `rand 0.10`, `rand_core 0.9`, `rand_core 0.10` |
| No-new-tests verdict | Confirmed — existing unit tests exercise the renamed call site identically |
