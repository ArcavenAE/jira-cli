---
document_type: story
level: ops
story_id: "S-cycle4-dpapi-storage-fix"
epic_id: "WINDOWS-CORRECTNESS-1"
title: "Windows DPAPI-encrypted-file fallback for oversized OAuth tokens (durable fix, #759)"
wave: 1
status: draft
intent: bug-fix
feature_type: backend
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 13
priority: P0
tdd_mode: strict
producer: story-writer
timestamp: "2026-09-04T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md"
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/affected-files.txt"
input-hash: "322bbf1"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md"
cycle: cycle-004-windows-correctness
estimated_effort: large
estimated_days: 5
target_module: src/api/auth_windows_store.rs
subsystems: ["SS-03"]
depends_on: []
blocks: ["S-cycle4-honest-fail-message"]
behavioral_contracts:
  - "BC-1.4.035"
  - "BC-1.4.036"
  - "BC-1.4.037"
  - "BC-1.4.038"
  - "BC-1.4.040"
  - "BC-1.4.028"
bcs:
  - "BC-1.4.035"
  - "BC-1.4.036"
  - "BC-1.4.037"
  - "BC-1.4.038"
  - "BC-1.4.040"
  - "BC-1.4.028"
verification_properties:
  - "VP-AUTHDX-010"
  - "VP-AUTHDX-011"
  - "VP-AUTHDX-012"
  - "VP-AUTHDX-013"
  - "VP-AUTHDX-014"
  - "VP-AUTHDX-015"
  - "VP-AUTHDX-016"
  - "VP-AUTHDX-018"
  - "VP-AUTHDX-022"
  - "VP-AUTHDX-023"
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0021", "ADR-0016", "ADR-0020"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 20
assumption_validations: []
risk_mitigations: []
created: "2026-09-04"
version: "1.3"
last_updated: "2026-09-04"
breaking_change: false
retroactive: false
origin: >
  cycle-004 windows-correctness, Wave 1 (no deps, file-disjoint from
  S-cycle4-cloud-id-correctness). Implements DEC-334/DEC-335's durable fix for #759:
  jr auth login --oauth deterministically fails on Windows because store_oauth_tokens
  writes the OAuth access/refresh pair straight to keyring::Entry::set_password, which
  on the windows-native backend hard-fails at 2560 bytes (keyring::Error::TooLong).
  Introduces a new sibling module (src/api/auth_windows_store.rs) implementing a
  keyring-first, DPAPI-encrypted-file fallback with backend-selection-level atomicity,
  a stale-keyring-shadow-closing delete-first write ordering, a four-way typed
  discrimination on the read path, delete-both-backends on clear, and a host-independent
  profile-name path-traversal guard. This is the foundational module
  S-cycle4-honest-fail-message's message-differentiation logic depends on (the marker
  error types DpapiFallbackFailed/ProfilePathEscape this story creates).
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced (`todo!()` scaffolds + Red Gate
> density check >= 0.5 required before Step 4 dispatch). This is new, security-critical
> credential-storage logic, not a facade/DTU candidate.

> **Execute:** `/vsdd-factory:deliver-story S-cycle4-dpapi-storage-fix`

# S-cycle4-dpapi-storage-fix — Windows DPAPI-encrypted-file OAuth-token fallback

> **Revision note (v1.2 → v1.3, F3 re-review comprehensive fix pass, 2026-09-04):**
> (1) added AC-020, closing BC-1.4.037 Invariant 3's coverage gap (the "zero new
> dependency-graph nodes" / `deny.toml` reason-field-update claim) with a dedicated,
> testable manifest source-text assertion — the prior pass had left this Invariant covered
> only by Task 18 and an Architecture Compliance Rule row, neither of which is a runtime
> AC; `acceptance_criteria_count` 19→20 corrected to match; (2) added a `CHANGELOG.md`
> row to File Structure Requirements — Task 20 already required a CHANGELOG entry, but the
> file itself was missing from this table, and it is concurrently edited by all three other
> cycle-004 stories (see `conflict-report.md` §1/§4, `wave-schedule.md` §2/§3);
> (3) appended additional BC-clause trace annotations to AC-005 (`VP-AUTHDX-022`), AC-007
> (`BC-1.4.036 postcondition 4`, which this AC's non-Windows-non-engagement proof also
> establishes for the read path), AC-009 (`BC-1.4.036 invariant 2`; `VP-AUTHDX-015`),
> AC-011 (`VP-AUTHDX-015`), and AC-015 (`BC-1.4.038 postcondition 3`) — closing gaps found
> by `dependency-graph-extended.md`'s re-derived §6 BC Clause Coverage Matrix (F3 re-review
> Finding #2) where these ACs already exercised the clause in substance but the trace
> annotation omitted it, and adding the VP citations F3 re-review Finding #3 requested.
>
> **Revision note (v1.1 → v1.2, F3 combined story-review pass — adversarial + consistency,
> 2026-09-04):** (1) added AC-019, closing a coverage gap where BC-1.4.035 Postcondition 5
> (`store_pair` failure surfaces `DpapiFallbackFailed`) had no covering AC — the prior ACs
> only exercised store SUCCESS (AC-013/014) and non-Windows non-engagement (AC-007);
> `acceptance_criteria_count` 14→19 corrected to match the body (was already stale against
> 18 before this pass; see the manifest's §4 table for the reconciled total); (2) reframed
> the BC-1.4.040 table row and added a Related-BCs cross-reference to BC-6.1.004/BC-6.1.005,
> matching the F2 Pass-20 gate-audit reclassification of that guard from a live CWE-22
> closure to defense-in-depth (no change to the guard's implemented behavior or to
> AC-017/AC-018); (3) appended an explicit `VP-AUTHDX-011` trace annotation to AC-001,
> AC-002, AC-003, AC-004, and AC-006, which already covered that VP's routing property in
> substance but omitted the citation every other AC carries for its anchoring VP.

## Anchor Justification

**Subsystem anchor:** `SS-03` owns this story's scope because `auth_windows_store.rs` is a
thin sibling module extending `src/api/auth.rs`'s credential-storage responsibility — the
same anchor rationale ARCH-INDEX.md already gives `src/api/auth_embedded.rs` (also
zero-HTTP) — per `architecture-delta.md` §2.1's "Anchor justification" note (verified
against ARCH-INDEX.md's Subsystem Registry during F2, not re-litigated here).

**Dependency anchors:** `depends_on: []` — this story creates the foundational
`auth_windows_store.rs` module and the marker error types (`DpapiFallbackFailed`,
`ProfilePathEscape`, `CorruptSecretFile`) from scratch; nothing in cycle-004 must land
before it.

**Blocks anchor:** `S-cycle4-honest-fail-message` depends on this story because its
message-differentiation logic at `oauth_login`'s and `refresh_oauth_token_with_url`'s
`map_err` closures (BC-1.4.039 Postcondition 1) branches on
`e.downcast_ref::<DpapiFallbackFailed>()` and `e.downcast_ref::<ProfilePathEscape>()` —
both types are defined in `src/api/auth_windows_store.rs`, which this story creates. This
also implements DEC-335's bundling instruction: honest-fail-message cannot compile, let
alone land, before this story's marker types exist, so the `depends_on` edge structurally
enforces "ship in the same release, this story first" rather than the independent
fast-follow sequencing F1 §12 item 6 offered as an alternative.

## Source of Truth

- `.factory/specs/prd/bc-1-auth-identity.md` §1.4: BC-1.4.035, BC-1.4.036, BC-1.4.037,
  BC-1.4.038, BC-1.4.040 (all read in full for this story), BC-1.4.028 (AMENDED, read in
  full).
- `ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md` §1-5, §7-9 (module design,
  dependency decision, clear-path adapter, path-traversal guard).
- `architecture-delta.md` §2.1 (module interface table), §3 (modified-components table),
  §6 (purity boundary map), §9 (residual design questions + architect guidance).

## Narrative

As a `jr` user on Windows authenticating via `jr auth login --oauth`, I want my OAuth
access and refresh tokens to persist reliably even when they exceed Windows Credential
Manager's 2560-byte blob-size ceiling, so that OAuth 2.0 — the recommended default auth
mechanism as of cycle-003 — actually works on Windows instead of failing deterministically
on the very first login attempt.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-1.4.035 | NEW | `store_oauth_tokens` gains keyring-first/DPAPI-fallback routing on `keyring::Error::TooLong`, with delete-keyring-first-then-DPAPI-store ordering (closes STALE-KEYRING-SHADOWS-DPAPI) |
| BC-1.4.036 | NEW | `load_oauth_tokens` gains a DPAPI-file-fallback branch, four-way typed discrimination (`ProfilePathEscape` first, then corrupt-envelope, then backend/IO, then genuine-absence) |
| BC-1.4.037 | NEW | New module `src/api/auth_windows_store.rs`: pure `envelope::{encode,decode,wrap,unwrap}`, impure `dpapi::{protect,unprotect}` (sole `unsafe` FFI), atomic temp-write-fsync-and-rename, age-gated stale-temp cleanup |
| BC-1.4.038 | NEW | `clear_profile_oauth_pair`/`clear_profile_creds` delete the DPAPI file too, via a new `clear_dpapi_file_tolerating_path_escape` adapter; attempt-all/first-error-propagated fan-out |
| BC-1.4.040 | NEW (defense-in-depth — Pass-20 gate-audit reclassification, F2) | `reject_unsafe_profile_component` — host-independent, character-level profile-name guard (30-vector reserved/separator/colon/NUL/trailing-dot-or-space rejection), wired as `file_path`'s mandatory first statement on both cfg arms of all three entry points. Sits BEHIND the PRIMARY, live gate `validate_profile_name` (BC-6.1.004/BC-6.1.005, `src/config.rs`), which already restricts every profile name reaching this call site — at config-load and at the CLI-flag/resolved-active-profile-name boundary — to ASCII `[A-Za-z0-9_-]` ≤64 chars with reserved-Windows-name stems excluded, a strict superset of the vectors this guard rejects; this guard hardens against (a) a future relaxation of that primary gate's charset/reserved-name list and (b) a validation-call-site regression bypassing it, not a live CWE-22 closure. No change to the guard's implemented behavior (AC-017/AC-018 unchanged) — framing only. |
| BC-1.4.028 | AMENDED | `load_oauth_tokens`'s partial-keyring-state branch extended with the same four-way `load_pair` discrimination BC-1.4.036 defines, before falling through to the pre-existing "partial" error |

**Related BCs (defense-in-depth layering, F2 Pass-20 gate-audit correction):**
BC-6.1.004, BC-6.1.005 — the PRIMARY, live `validate_profile_name` gate (`src/config.rs`)
that BC-1.4.040's `reject_unsafe_profile_component` guard sits behind. See
`bc-1-auth-identity.md`'s BC-1.4.040 body (Confidence/Source/Origin/Description fields) for
the full reclassification rationale — F2 is frozen and not re-litigated here; this story
only mirrors that framing in its own BC table row above.

## Acceptance Criteria

### AC-001 — Both-fit keyring write is unchanged
When both `set_password` calls succeed, the pair is stored in the keyring exactly as
before this cycle; any stale DPAPI file for the profile is best-effort removed (failure to
remove never fails the call).
(traces to BC-1.4.035 postcondition 1; VP-AUTHDX-011)

### AC-002 — Refresh-overflow routes the whole pair to DPAPI, deleting the ENTIRE existing keyring pair first
Access `set_password` succeeds, refresh returns `TooLong` → BEFORE calling
`auth_windows_store::store_pair`, both `<profile>:oauth-access-token` (incl. the
just-written value) AND `<profile>:oauth-refresh-token` are deleted via
`delete_credential_tolerating_no_entry` (tolerating `NoEntry` on either key); only then is
the whole pair written to the DPAPI file.
(traces to BC-1.4.035 postcondition 2; VP-AUTHDX-011)

### AC-003 — Access-overflow routes the whole pair to DPAPI without ever attempting the refresh write, deleting the existing pair first
Access `set_password` itself returns `TooLong` → refresh is never attempted against
keyring; the profile's entire existing keyring pair is deleted first, then the whole pair
routes to `auth_windows_store::store_pair`.
(traces to BC-1.4.035 postcondition 3; VP-AUTHDX-011)

### AC-004 — Non-`TooLong` errors propagate unchanged, no DPAPI engagement
Any `Err` other than `TooLong` (lock/permission/backend error) propagates unchanged; no
DPAPI engagement occurs.
(traces to BC-1.4.035 postcondition 4; VP-AUTHDX-011)

### AC-005 — Delete-keyring-first ordering (crash-safety)
The keyring-pair delete in AC-002/AC-003 happens BEFORE `auth_windows_store::store_pair`
is invoked, never after — a process kill in the window between leaves NEITHER backend
holding a pair (clean "no stored OAuth token" state on next read), never both backends
holding a complete pair simultaneously.
(traces to BC-1.4.035 postcondition 6, invariant 1; VP-AUTHDX-022)

### AC-006 — Stale-keyring-shadow closure (STALE-KEYRING-SHADOWS-DPAPI, VP-AUTHDX-022)
Given a profile with a PRE-EXISTING complete, fitting keyring pair, and a fresh
`store_oauth_tokens` call whose write returns `TooLong` (tested for both the
access-overflow arm and the refresh-overflow-after-access-succeeded arm) — after the call
returns `Ok`, both namespaced keyring keys are absent, the DPAPI file holds the fresh
pair, and a subsequent `load_oauth_tokens` returns the fresh DPAPI pair, never the stale
keyring values. KEYRING-GATED (`#[ignore]` + `JR_RUN_KEYRING_TESTS=1`, additionally +
`JR_FORCE_DPAPI_FALLBACK=1` on non-Windows).
(traces to BC-1.4.035 postcondition 2/3/6, invariant 1; VP-AUTHDX-022; VP-AUTHDX-011)

### AC-007 — DPAPI fallback structurally unreachable on macOS/Linux in release builds
`store_oauth_tokens`'s `TooLong` match arms call `engage_dpapi_fallback`, never
`should_fallback_to_dpapi` directly; on `#[cfg(not(windows))]` in a release build this is
hardcoded `false` regardless of the error variant — `auth_windows_store::store_pair`/
`load_pair` are never reached and `DpapiFallbackFailed` can never be produced on a
non-Windows release build.
(traces to BC-1.4.035 invariant 3; BC-1.4.036 postcondition 4 — this same non-engagement
proof establishes `load_pair`'s macOS/Linux no-op for the read path; VP-AUTHDX-013)

### AC-008 — `JR_FORCE_DPAPI_FALLBACK` debug-only test seam, and its release-gate
In a `#[cfg(debug_assertions)]` build with `JR_FORCE_DPAPI_FALLBACK=1` set,
`engage_dpapi_fallback` on `#[cfg(not(windows))]` returns `should_fallback_to_dpapi(err)`
(true IFF `TooLong`, never unconditionally true). A dedicated
`tests/jr_force_dpapi_fallback_release_gate.rs` source-text-scan pin asserts
`#[cfg(debug_assertions)]` appears within 5 source lines of the env-var read, ships in the
SAME commit as the seam, per the established `JR_*` seam convention.
(traces to BC-1.4.035 invariant 3; VP-AUTHDX-023)

### AC-009 — Read path: both keys absent, DPAPI file present → transparent success
`load_oauth_tokens`, both namespaced keyring keys absent, calls `auth_windows_store::load_pair`;
`Ok(Some((access, refresh)))` is indistinguishable from a keyring-backed load.
(traces to BC-1.4.036 postcondition 2a, invariant 2 — `auth status`'s presence check
reports "authenticated" identically regardless of backend; VP-AUTHDX-015)

### AC-010 — Read path four-way discrimination: `ProfilePathEscape` first, then corrupt-envelope, then backend/IO, then genuine absence
On any `Err`, discrimination runs in this order: (1) `ProfilePathEscape` → distinct exit-64
invalid-profile-name error; (2) genuine corrupt-envelope condition → distinct force-re-login
error naming the profile, never coerced into "no stored OAuth token"; (3) genuine
backend/IO error on an existing file → distinct non-corruption error, never the corruption
message; (4) `Ok(None)` → fall through to the existing `"default"`-only legacy-flat-key
check, then the unchanged "No stored OAuth token" error. Applies identically to BOTH the
both-absent branch and the (BC-1.4.028 AMENDED) exactly-one-key-present partial branch.
(traces to BC-1.4.036 postconditions 2/3, invariants 1/3; BC-1.4.028 amended behavior
items 1-5; VP-AUTHDX-015)

### AC-011 — Precedence-ordering asymmetry preserved
Both-absent checks the DPAPI file BEFORE the legacy `"default"`-only fallback;
exactly-one-key-present checks the existing legacy recovery FIRST, DPAPI only as an
additional fallback — this asymmetry is intentional and must not be collapsed.
(traces to BC-1.4.036 postcondition 5; VP-AUTHDX-015)

### AC-012 — Envelope round-trip and corrupt/unrecognized rejection (pure, VP-AUTHDX-014)
`envelope::decode(envelope::encode(access, refresh)) == (access, refresh)` byte-for-byte
for any UTF-8 pair including values well above 2560 bytes; `envelope::unwrap(envelope::wrap(p)) == p`;
structurally malformed input to `decode`/`unwrap` yields a distinct `Err`, never a panic,
never silently coerced to empty/absent.
(traces to BC-1.4.037 postconditions 1/2; VP-AUTHDX-014)

### AC-013 — Atomic temp-write-fsync-and-rename, age-gated stale-temp cleanup
`store_pair` builds the full file in memory, writes to a `.tmp-<suffix>` sibling in the
same directory, `fsync`s it, then `rename`s over the final path — never a truncated/partial
file at the final path on process-kill (sequencing alone) or power-loss (fsync-before-rename).
Before writing, a best-effort cleanup pass removes ONLY `*.tmp-*` siblings older than
`STALE_TMP_THRESHOLD` (30s); a fresh (<30s) sibling is preserved (assumed another
process's in-flight write).
(traces to BC-1.4.037 postcondition 3; VP-AUTHDX-012)

### AC-014 — DPAPI USER-scope-only flag invariant + real round-trip
`dpapi::protect` never sets `CRYPTPROTECT_LOCAL_MACHINE` (`dwFlags & CRYPTPROTECT_LOCAL_MACHINE == 0`,
a compile-reachable, Windows-COMPILED assertion independent of headless-runtime
reachability); on Windows, `dpapi::unprotect(dpapi::protect(p)) == p` byte-for-byte for any
plaintext including values above 2560 bytes.
(traces to BC-1.4.037 postcondition 4; VP-AUTHDX-010 sub-properties a and b)

### AC-015 — Clear paths delete both backends, attempt-all/first-error-propagated
`clear_profile_oauth_pair`/`clear_profile_creds` each additionally call
`auth_windows_store::remove_if_present` via a new `clear_dpapi_file_tolerating_path_escape`
adapter; every deletion step is attempted unconditionally regardless of an earlier step's
failure; the first genuine error encountered (in fixed attempt order) is the one
propagated, after all attempts complete.
(traces to BC-1.4.038 postconditions 1/2/3/4; VP-AUTHDX-018)

### AC-016 — Clear path tolerates `ProfilePathEscape` as a no-op, on every OS
A guard-rejecting profile name (containing `:`, or a reserved device-name stem such as
`con`) clears successfully via `clear_profile_oauth_pair`/`clear_profile_creds` — the
DPAPI-removal step returns `Ok(())` (never a genuine error, never a user-visible message)
— identically on Windows, macOS, and Linux. Runs in DEFAULT CI, no `JR_FORCE_DPAPI_FALLBACK`
seam needed (the guard rejects before any keychain/DPAPI touch).
(traces to BC-1.4.038 postcondition 4, invariant 3, edge case EC-1.4.038-5; VP-AUTHDX-018)

### AC-017 — Path-traversal guard: exhaustive 30-vector rejection, host-independent, cross-platform default CI
`reject_unsafe_profile_component` rejects (as the typed `ProfilePathEscape` marker, before
any FS op): an empty string; the profile equal to exactly `.` or `..`; any embedded NUL
byte; any `/` or `\` anywhere (both separators, every host — also catches UNC prefixes);
any `:` anywhere (drive-letter prefix, NTFS ADS suffix); a trailing `.` or trailing space;
and the 30-name Windows reserved-device-name set (ADR-0021 §9, case-insensitive,
stem-matched, leading-space-trimmed) — asserted with NO `#[cfg(windows)]` gate on a
Linux/macOS CI runner, proving the recognizer (not the host OS) does the rejecting; an
ordinary alphanumeric/`_`/`-` name is unaffected.
(traces to BC-1.4.040 postconditions 1-7, invariant 3; VP-AUTHDX-016 sub-properties a-c)

### AC-018 — Guard wiring: all three entry points invoke the guard first, on both cfg arms
On a default (Linux/macOS) CI runner, calling `store_pair`, `load_pair`, and
`remove_if_present` DIRECTLY with a guard-failing profile name returns `Err` downcastable
to `ProfilePathEscape`, emitted BEFORE any filesystem operation and before each function's
own OS-specific short-circuit (`DpapiFallbackFailed`, `Ok(None)`, `Ok(())` respectively) —
a SEPARATE test from the pure-recognizer unit cases, since it verifies wiring, not
correctness in isolation. Also includes a design-conformance assertion that fails if the
guard is re-implemented via `std::path::Path`/`Component` (drive-letter/UNC/ADS-colon
vectors asserted rejected on a non-Windows CI host, where `std::path` would wrongly
accept them).
(traces to BC-1.4.040 postcondition 8; VP-AUTHDX-016 sub-property d)

### AC-019 — Genuine `store_pair` failure surfaces `DpapiFallbackFailed`, asserted by type (F3 story-review Finding #1)
When `store_oauth_tokens` routes into `auth_windows_store::store_pair` (via AC-002/AC-003's
`TooLong`-routing arms) and `store_pair` itself then fails — on Windows, from a genuine
filesystem/DPAPI-layer fault (disk full, a DPAPI syscall failure, permission denied on the
secrets directory; EC-1.4.037-2); cross-platform on KEYRING-GATED runs, from the
`#[cfg(not(windows))]` stub's unconditional `Err` return (AC-007) — the error propagated
out of `store_oauth_tokens` is explicitly asserted, via
`e.downcast_ref::<DpapiFallbackFailed>()` returning `Some(_)`, to carry the
`DpapiFallbackFailed` marker, not merely inferred from the call returning `Err`. This is
distinct from VP-AUTHDX-022's existing "delete-then-fail" assertions, which confirm neither
backend is left populated after such a failure but stop short of asserting the propagated
error's TYPE — this AC is the first to assert the marker specifically, which is the exact
thing `S-cycle4-honest-fail-message`'s Site 1/Site 3 message-selection logic (BC-1.4.039)
depends on being present to downcast against. The message TEXT selected for a
`DpapiFallbackFailed` marker is out of scope here (`S-cycle4-honest-fail-message`); this AC
verifies only that the marker itself is produced and survives propagation.
**Coverage boundary:** the cross-platform portion is KEYRING-GATED (`#[ignore]` +
`JR_RUN_KEYRING_TESTS=1`, + `JR_FORCE_DPAPI_FALLBACK=1` on non-Windows — same boundary as
AC-006/AC-015), reusing the `#[cfg(not(windows))]` stub's unconditional failure (AC-007) as
the fault source; a genuine disk-full/permission-denied fault on the real Windows write
path is the Windows-only tail, exercisable via a fault-injection seam over `store_pair`'s
temp-write step (mirrors VP-AUTHDX-012 sub-property (2)'s coverage boundary).
(traces to BC-1.4.035 postcondition 5)

### AC-020 — Dependency-graph neutrality: `windows-sys` promotion introduces zero new nodes, `deny.toml` reason field updated in the same change (F3 re-review Finding #2)
A manifest source-text assertion test, added to `tests/keyring_windows_native_feature_present.rs`
(mirroring that file's existing `parse_bans_skip_blocks`/`block_contains_name_and_version`
pattern rather than inventing a second one), pins two things in the SAME commit that
promotes `windows-sys` to a direct `[target.'cfg(windows)'.dependencies]` entry: (1) the
declared `windows-sys` version in that new section is the SAME `0.60.x` line already
present transitively via `keyring`'s `windows-native` feature (never a version bump
introduced alongside the promotion) — this is the operational, testable form of "zero new
dependency-graph nodes," since promoting an already-present transitive dependency to
direct, at the same version, adds no new crate/version pair to the resolved dependency
graph; (2) `deny.toml`'s existing `windows-sys` `"0.60"` `[[bans.skip]]` block's `reason`
field, re-read after the change, contains a reference to this module (`auth_windows_store`
or "DPAPI") alongside its existing `keyring`/`windows-native` wording — never left stale,
naming only the pre-cycle-004 justification. This test does not itself run `cargo tree`
(no such invocation exists elsewhere in this test suite's pattern); it is a manifest-text
pin consistent with this file's established convention, not a build-graph diff.
(traces to BC-1.4.037 invariant 3)

> **VP-coverage observation for orchestrator (F3 story-review Finding #1, VP sub-question)
> — possible F2 VP gap, F2 frozen, NOT edited here.** No existing VP anchored to
> BC-1.4.035 specifically asserts the PRODUCTION path this AC covers — that a genuine
> `store_pair` failure (as opposed to a manually-constructed error value) actually PRODUCES
> a `DpapiFallbackFailed`-downcastable error that `store_oauth_tokens` then propagates.
> The three candidates considered and ruled out: **VP-AUTHDX-011** (`TooLong`-triggered
> DPAPI-fallback ROUTING — asserts store_pair is CALLED on `TooLong`, not what error TYPE
> a failing call returns); **VP-AUTHDX-012** (backend-selection atomicity / no-split /
> atomic-write sequencing — asserts the FILE's on-disk state after a fault, never the error
> TYPE `store_pair`/`store_oauth_tokens` returns to the caller); **VP-AUTHDX-017**
> (honest-fail message selection at BC-1.4.039 — explicitly verified "via constructed error
> values" per its own Verification Method, i.e. it ASSUMES a `DpapiFallbackFailed`-wrapped
> error is handed to it and asserts only which message text gets selected downstream, never
> that a real `store_pair` failure actually manufactures that marker in the first place).
> AC-019 above closes the observable gap at the story level without inventing a new VP ID
> (out of scope for F3); flagging here, and in `decomposition-manifest.md`, for whoever is
> authorized to decide whether `bc-1-auth-identity.md` should gain a formal VP anchor for
> this production-path property in a future F2 amendment.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `envelope::{encode,decode,wrap,unwrap}` | `src/api/auth_windows_store.rs` | Pure Core |
| `should_fallback_to_dpapi` | `src/api/auth_windows_store.rs` | Pure Core |
| `reject_unsafe_profile_component` / `file_path` | `src/api/auth_windows_store.rs` | Pure Core |
| `store_pair` / `load_pair` / `remove_if_present` | `src/api/auth_windows_store.rs` | Effectful Shell |
| `dpapi::{protect,unprotect}` | `src/api/auth_windows_store.rs` (`#[cfg(windows)]`) | Effectful Shell (`unsafe` FFI) |
| `engage_dpapi_fallback`, `clear_dpapi_file_tolerating_path_escape` | `src/api/auth.rs` | Pure Core (former) / Effectful Shell (latter, delegates to `remove_if_present`) |
| `store_oauth_tokens`, `load_oauth_tokens`, `clear_profile_oauth_pair`, `clear_profile_creds` | `src/api/auth.rs` | Effectful Shell (unchanged classification) |

## UX Screens

N/A — CLI-only, no UI surface.

## Design System Components

N/A — not a UI story.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-1.4.035-2 | Previously-oversized refresh token shrinks below the keyring ceiling after rotation | Next successful keyring-first write removes the now-stale DPAPI file as best-effort; failure to remove doesn't fail the call |
| EC-1.4.036-1 | DPAPI file exists but was created under a different Windows user account | `CryptUnprotectData` fails; indistinguishable from ordinary corruption; same force-re-login message |
| EC-1.4.036-2 | Namespaced-partial keyring state AND a complete valid DPAPI file coexist | Prefer the DPAPI file, warn via stderr, don't error outright |
| EC-1.4.037-2 | Disk full / secrets dir not writable during temp-write | Write fails before rename; existing final-path file (if any) untouched; surfaces as `DpapiFallbackFailed` |
| EC-1.4.038-1 | Pair lives entirely in the DPAPI file (keyring never touched) | Both keyring deletes hit `NotFound`/tolerate-absent; DPAPI removal is the only real deletion; call still succeeds |
| EC-1.4.038-6 | A DPAPI file exists on disk under a name the CURRENT guard would reject (out-of-band/legacy) | NOT found or removed by `remove_if_present` (guard rejects before existence check); accepted, documented residual — confidentiality unaffected (DPAPI still gates decryption); no test required |
| EC-1.4.040-7 | Reserved device-name stem with trailing extension (`con.txt`) | Rejected per the stem-match rule (match runs after trailing-dot/space rejection) |
| EC-1.4.040-10 | Leading-space-prefixed reserved stem (`" CON"`) | Rejected (stem-normalization trims leading spaces before matching); a leading-space NON-reserved name is unaffected |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `auth_windows_store::envelope::*`, `should_fallback_to_dpapi`, `reject_unsafe_profile_component` | Pure Core | Deterministic byte/string transforms and predicates, no I/O or syscalls; unit-testable on any OS/CI runner (architecture-delta.md §6) |
| `auth_windows_store::store_pair` / `load_pair` / `remove_if_present` | Effectful Shell | File I/O + (on Windows) DPAPI syscalls; the `#[cfg(not(windows))]` arms are still shell-classified by role even though they perform no actual I/O |
| `auth_windows_store::dpapi::{protect,unprotect}` | Effectful Shell (`unsafe`) | Windows-only FFI; the sole `unsafe` code in the module tree |
| `store_oauth_tokens` / `load_oauth_tokens` / `clear_profile_oauth_pair` / `clear_profile_creds` (post-change) | Effectful Shell (unchanged) | Already effectful before this cycle; the new routing logic they call is itself pure/impure-split per the rows above |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|---------------|-----------------|
| This story spec | ~5,800 |
| BC files (6 BCs: 1.4.035/036/037/038/040/028) | ~14,000 |
| ADR-0021 (relevant sections §1-5, §7-9) | ~7,000 |
| `src/api/auth.rs` (relevant ~400 LOC: existing OAuth pair, error-message call sites) | ~5,000 |
| New `src/api/auth_windows_store.rs` (to be written, ~350-450 LOC) | ~5,500 |
| Existing test files to extend (`tests/auth_*`, `oauth_refresh_integration.rs`) | ~3,500 |
| `cargo test` + keyring-gated output | ~1,000 |
| **Total** | **~41,800** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~21%** |

At the upper edge of the 20-30% target. DEC-335 locks this cycle's F3 scope at 4 stories
(dpapi-storage-fix / honest-fail-message / windows-docs / cloud-id-correctness) — this
story is not further split at F3 per that decision. **Recommendation for F4:** if the
implementer's actual working context (real file sizes once `auth_windows_store.rs` is
drafted, plus test-output volume) pushes meaningfully past this estimate, consider
splitting the F4 TDD delivery into two sequential sub-passes within this one story
(write-path: BC-1.4.035/037/040; read+clear-path: BC-1.4.036/038/028) — this is an F4
scheduling choice, not a re-opening of the F3 story boundary.

## Tasks

1. [ ] Write failing tests (test-writer) for the pure `envelope`/`should_fallback_to_dpapi`/
   `reject_unsafe_profile_component` functions (AC-012, AC-017)
2. [ ] Write failing tests for the guard-wiring oracle (AC-018) and the cross-platform
   `#[cfg(not(windows))]` no-op arms (AC-007, VP-AUTHDX-013)
3. [ ] Implement `src/api/auth_windows_store.rs` to pass Tasks 1-2 (minimum code per test)
4. [ ] Write failing tests for `store_oauth_tokens`'s routing/rollback (AC-001-005),
   gated appropriately (default CI for pure predicate; `#[ignore]`+`JR_RUN_KEYRING_TESTS=1`
   +`JR_FORCE_DPAPI_FALLBACK=1` for the state/ordering core, AC-006)
5. [ ] Implement the `store_oauth_tokens` routing change, `engage_dpapi_fallback`
   call-site wrapper, and the `JR_FORCE_DPAPI_FALLBACK` debug-only seam
6. [ ] Write and ship `tests/jr_force_dpapi_fallback_release_gate.rs` in the SAME commit
   as the seam (AC-008)
7. [ ] Write failing tests for `load_oauth_tokens`'s DPAPI-fallback branch and four-way
   discrimination (AC-009-011), split by keyring pre-state per VP-AUTHDX-015's coverage
   boundary (both-absent: default CI; exactly-one-present: keyring-gated)
8. [ ] Implement the `load_oauth_tokens` change (BC-1.4.036, amended BC-1.4.028)
9. [ ] Write failing tests for atomic temp-write-fsync-rename + age-gated cleanup
   (AC-013) and the DPAPI FFI USER-scope-flag + round-trip (AC-014, Windows-only/Windows-compiled)
10. [ ] Implement `store_pair`'s Windows write path and `dpapi::{protect,unprotect}`
11. [ ] Write failing tests for `clear_profile_oauth_pair`/`clear_profile_creds`'s
    delete-both-backends + attempt-all fan-out + `ProfilePathEscape` tolerance (AC-015-016)
12. [ ] Implement `clear_dpapi_file_tolerating_path_escape` and wire it into both clear
    functions
13. [ ] Verify purity boundaries against the table above
14. [ ] Update STATE.md (state-manager, not this story's implementer)
15. [ ] Write property-based tests: `proptest` for envelope round-trip (AC-012) and for
    `reject_unsafe_profile_component`'s exhaustive rejection (AC-017), bounded/adversarial
    generators per VP-AUTHDX-014/016
16. [ ] Verify Red Gate (all new tests fail before implementation)
17. [ ] Refactor
18. [ ] Confirm `Cargo.toml`/`deny.toml` changes (promote `windows-sys` to a direct
    `[target.'cfg(windows)'.dependencies]` entry; update the existing `[[bans.skip]]`
    `reason` field) — zero new dependency-graph nodes (ADR-0021 §5)
19. [ ] Run `load_oauth_tokens`'s FULL existing pre-cycle-004 test suite byte-for-byte
    green as an explicit gate on this story's PR (regression-critical)
20. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` describing the Windows OAuth
    storage fix, before creating the PR
21. [ ] Write a failing test (F3 story-review Finding #1) that, on top of the AC-006/AC-015
    keyring-gated harness, additionally asserts the error `store_oauth_tokens` propagates
    on a `store_pair` failure downcasts to `DpapiFallbackFailed` via
    `e.downcast_ref::<DpapiFallbackFailed>()` (AC-019) — not merely that the call returns
    `Err`; add a Windows-only fault-injection case over the real temp-write step for the
    genuine-fault production path
22. [ ] Add the dependency-graph-neutrality/`deny.toml`-reason-field assertion to
    `tests/keyring_windows_native_feature_present.rs`, in the SAME commit as Task 18's
    `Cargo.toml`/`deny.toml` changes (AC-020, F3 re-review Finding #2)

## Previous Story Intelligence

N/A — first story in the `WINDOWS-CORRECTNESS-1` epic; no completed cycle-004 stories
exist yet. Carrying forward from cycle-003's closest analog
(`S-cycle3-percred-storage`, `S-cycle3-credential-absence-guard`): (1) reuse
`read_keyring_optional`'s `Err(keyring::Error::NoEntry)`-vs-other-`Err` distinguishing
pattern for the keyring side of this story's routing logic — do not write a second copy;
(2) the `JR_SERVICE_NAME`-style `env_lock` mutex serialization pattern from
`tests/oauth_refresh_integration.rs` is REQUIRED here too (BC-1.4.035's VP-AUTHDX-011/012/022
Trace notes) for every test that sets/reads/unsets `JR_FORCE_DPAPI_FALLBACK` — the
seam-engaged and env-UNSET legacy-message test classes assert opposing outcomes from the
SAME call site and must never interleave under `cargo test`'s default parallelism.

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|-----------|
| `reject_unsafe_profile_component` MUST be a host-independent character-level scan, NEVER `std::path::Path`/`Component` | BC-1.4.040 Postconditions 1-8; ADR-0021 §9 | AC-017/AC-018's design-conformance assertion; `std::path` produces the WRONG answer on a Linux CI runner for Windows-shaped vectors |
| `file_path` is the SOLE call site of the guard, invoked as the FIRST statement of `store_pair`/`load_pair`/`remove_if_present` on BOTH cfg arms | BC-1.4.040 Postcondition 8 | AC-018's guard-wiring oracle |
| Routing decisions driven ONLY by the typed `keyring::Error::TooLong` variant, never a hardcoded byte-budget pre-flight guess | BC-1.4.035 Invariant 2 | AC-001-004's routing tests |
| DPAPI engagement gated at the `engage_dpapi_fallback` call site, `#[cfg(windows)]`; `#[cfg(not(windows))]` hardcoded `false` in release builds | BC-1.4.035 Invariant 3; ADR-0021 §1 | AC-007; `tests/jr_force_dpapi_fallback_release_gate.rs` |
| `dpapi::protect`/`unprotect` are the ONLY `unsafe` code in this module tree | BC-1.4.037 Invariant 2 | Code review + AC-014's compiled-constant assertion |
| `CRYPTPROTECT_LOCAL_MACHINE` NEVER set — USER scope only | BC-1.4.037 Postcondition 4 | AC-014 |
| Delete-keyring-first, then DPAPI-store — never the reverse | BC-1.4.035 Postcondition 6 | AC-005/AC-006 |
| Age-gated (30s) `*.tmp-*` cleanup — never a blanket delete | BC-1.4.037 Postcondition 3 | AC-013 |
| Every clear-path deletion step is attempted unconditionally; first genuine error propagated after all attempts complete | BC-1.4.038 Postcondition 4 | AC-015 |
| `windows-sys` promoted to a direct `cfg(windows)` dependency introduces ZERO new dependency-graph nodes | BC-1.4.037 Invariant 3; ADR-0021 §5 | `cargo tree` diff at F4; `deny.toml` `[[bans.skip]]` reason-field update in the same change; AC-020's manifest source-text assertion (F3 re-review Finding #2) |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` |
| No let-chains (MSRV 1.85) | CLAUDE.md | `cargo check` under `RUSTUP_TOOLCHAIN=1.85.0` |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `windows-sys` | `0.60.2` (already transitively present via `keyring`'s `windows-native` feature; promoted to a direct `[target.'cfg(windows)'.dependencies]` entry) | `Win32_Security_Cryptography` + `Win32_Foundation` features, for the `CryptProtectData`/`CryptUnprotectData` FFI wrapper |
| `keyring` | pinned version unchanged | Existing keychain backend, unchanged API surface |
| `proptest` (dev-dependency, already present) | bounded + adversarial generators | Envelope round-trip (AC-012) and guard exhaustive-rejection (AC-017) property tests |

**Explicitly rejected per F1 §6 / ADR-0021 §5:** the higher-level `windows` crate (a
genuinely NEW top-level dependency, unlike `windows-sys` which is already present) and
`windows-dpapi` (young, lightly-audited). Do not introduce either without a fresh
architecture decision.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/auth_windows_store.rs` | CREATE | New sibling module: `envelope::*`, `should_fallback_to_dpapi`, `reject_unsafe_profile_component`, `file_path`, `store_pair`, `load_pair`, `remove_if_present`, `dpapi::{protect,unprotect}` (`#[cfg(windows)]`), `DpapiFallbackFailed`, `ProfilePathEscape`, `CorruptSecretFile` marker types |
| `src/api/mod.rs` | MODIFY | Add module declaration for `auth_windows_store` |
| `src/api/auth.rs` | MODIFY | `store_oauth_tokens` (routing + rollback), `load_oauth_tokens` (DPAPI-fallback branch + 4-way discrimination + amended partial-state branch), `clear_profile_oauth_pair`/`clear_profile_creds` (DPAPI-removal step via new `clear_dpapi_file_tolerating_path_escape` adapter), new `engage_dpapi_fallback` function with the `JR_FORCE_DPAPI_FALLBACK` debug-only seam |
| `Cargo.toml` | MODIFY | New `[target.'cfg(windows)'.dependencies]` section: `windows-sys` with `Win32_Security_Cryptography` + `Win32_Foundation` features |
| `deny.toml` | MODIFY | Update the existing `windows-sys` `"0.60"` `[[bans.skip]]` entry's `reason` field to name this module's DPAPI usage alongside keyring's `windows-native` feature |
| `tests/jr_force_dpapi_fallback_release_gate.rs` | CREATE | Source-text-scan pin: `#[cfg(debug_assertions)]` within 5 lines of the `JR_FORCE_DPAPI_FALLBACK` read (AC-008) |
| `tests/auth_profiles.rs`, `tests/api_token_percred_wiring.rs`, `tests/keyring_guard_idiom.rs` | MODIFY | Extend with DPAPI-aware sibling assertions (`TooLong` idiom case); do not rewrite existing assertions |
| `tests/oauth_refresh_integration.rs` | MODIFY | Extend with the keyring-gated DPAPI round-trip / stale-shadow-closure scenarios (AC-006), reusing the existing `env_lock`-style mutex pattern |
| `tests/keyring_windows_native_feature_present.rs` | MODIFY | Add pins for the new direct `windows-sys` dependency entry if the version graph changes, AND the dependency-graph-neutrality/deny.toml-reason-field assertion (AC-020, F3 story-review Finding #2) |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Fixed` entry per Task 20 (F3 story-review Finding #1) — this file is ALSO edited by `S-cycle4-cloud-id-correctness` (Wave 1, parallel), `S-cycle4-honest-fail-message` (Wave 2), and `S-cycle4-windows-docs` (Wave 2); see `conflict-report.md` §1/§4 and `wave-schedule.md` §2/§3 for the cross-story `[Unreleased]`-section hotspot analysis — each story appends its OWN distinct bullet line, so this is a trivial append-collision, not a real conflict |

**Files NOT to touch:** `src/cli/auth/login.rs`, `src/cli/auth/refresh.rs`,
`src/cli/auth/logout.rs`, `src/cli/auth/remove.rs`, `src/cli/auth/status.rs`,
`src/api/refresh_coordinator.rs`, `src/api/client.rs` — all DEPENDENT (F1 §5.3), no code
change expected in any of them; only the underlying `store_oauth_tokens`/`load_oauth_tokens`/
`clear_profile_*` behavior changes beneath them. `src/api/jira/tenant.rs` and
`src/cli/auth/login.rs`'s `cloud_id_override` plumbing are `S-cycle4-cloud-id-correctness`'s
scope, not this story's.

## Out of Scope

- The message-text differentiation at Sites 1/3 (`DpapiFallbackFailed`/`ProfilePathEscape`
  rendering, honest-fail wording) — `S-cycle4-honest-fail-message` (BC-1.4.039).
- `cloud_id` acquisition, `fetch_cloud_id`, `login_token` changes — `S-cycle4-cloud-id-correctness`
  (BC-1.2.052/053/054).
- README/documentation changes — `S-cycle4-windows-docs`.
- Windows-only real-syscall/manual validation gating (F4 CI spike for `windows-latest`
  DPAPI reachability; F7 required manual Windows smoke-test) — see "Windows Validation"
  below; this story specifies and implements the code, the spike/manual-gate are
  F4/F7 process steps, not additional story scope.

## Windows Validation (DEC-335)

Per DEC-335 and F1 §10 / architecture-delta §9 item 3: this story's cross-platform-testable
seams (the pure `envelope`/`should_fallback_to_dpapi`/`reject_unsafe_profile_component`
functions, the routing decision, the atomic-write sequencing, the age-gated cleanup) run in
default CI. The genuinely Windows-only bits (the real `CryptProtectData`/`CryptUnprotectData`
syscalls, `CredWriteW`'s actual `TooLong` trigger, a full end-to-end `jr auth login --oauth`
round-trip) require:

1. **F4 CI spike (REQUIRED, not optional):** determine whether `windows-latest` GitHub
   Actions CI can exercise `CryptProtectData` end-to-end in its headless, ephemeral
   per-job user context. Record the outcome in the F4 delivery notes. If inconclusive,
   AC-014's sub-property (b) (real round-trip) falls back to manual validation while
   sub-property (a) (the `dwFlags` USER-scope assertion) remains automated regardless.
2. **F7 manual Windows smoke-test gate (REQUIRED, not optional):** a human performs the
   exact #759 repro steps (`jr auth login --oauth` with the default 8-scope set) on a real
   Windows 11 install, confirming the OAuth token now persists via the DPAPI fallback and
   `jr auth status`/a subsequent API call succeed. This gate must be scheduled and its
   outcome recorded before cycle-004's F7 delta-convergence gate closes — "CI is green"
   must not stand in for "verified on the platform this fixes."

## Dependency Analysis

**depends_on: []** — root story, Wave 1, alongside `S-cycle4-cloud-id-correctness` (file-disjoint:
this story touches `src/api/auth.rs`/`src/api/auth_windows_store.rs`; cloud-id-correctness
touches `src/cli/auth/login.rs`/`src/cli/auth/refresh.rs`/`src/api/jira/tenant.rs` — zero
file overlap, safe to run in parallel).

**blocks:** `S-cycle4-honest-fail-message` — see Anchor Justification above for the
specific technical reason (marker-type compile dependency).

## Story Points and Effort

**13 story points** (large — at the story-point ceiling per this codebase's "no story
exceeds 13 points" rule). Breakdown:
- New module (`envelope`, guard, routing predicate, pure functions): 3 SP
- `store_oauth_tokens` routing/rollback + stale-shadow closure (VP-AUTHDX-022): 3 SP
- `load_oauth_tokens` DPAPI-fallback + four-way discrimination + amended partial-state: 2.5 SP
- Atomic file write (temp-write-fsync-rename + age-gated cleanup) + DPAPI FFI wrapper: 2 SP
- Clear-path delete-both-backends + attempt-all fan-out + `ProfilePathEscape` tolerance: 1.5 SP
- Dependency/deny.toml wiring + release-gate test + property tests: 1 SP

Risk: HIGH (module criticality HIGH — core credential-storage module, 6 BCs, 10 VPs, the
single largest story in this cycle). Mitigations: keyring-gated state cores are explicitly
called out per BC's own CI-classification corrections (Pass-8 adversarial review); the
pure/impure seam design (architecture-delta §6) maximizes default-CI coverage before any
Windows-only or keyring-gated tier is needed.
