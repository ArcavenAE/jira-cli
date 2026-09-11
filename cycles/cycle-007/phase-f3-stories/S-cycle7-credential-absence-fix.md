---
document_type: story
level: ops
story_id: "S-cycle7-credential-absence-fix"
epic_id: "AUTH-CORRECTNESS-DX-1"
title: "load_api_token credential-absence sites: parsing --profile remediation + exit 2 (issues #784 + #786)"
wave: 1
status: draft
intent: bug-fix
feature_type: correctness
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
producer: story-writer
timestamp: "2026-09-10T00:00:00"
phase: 3
inputs:
  - ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md"
  - ".factory/phase-f2-spec-evolution/cycle-007-verification-delta.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - "src/api/auth.rs"
  - "src/cli/mod.rs"
input-hash: "d0a488c"
traces_to: ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md §3"
cycle: cycle-007-auth-correctness-dx
estimated_effort: medium
estimated_days: 2.5
target_module: "src/api/auth.rs"
subsystems: ["SS-03"]
# SS-03 owns this story's scope because src/api/auth.rs (load_api_token,
# its inline BC-1.4.032/033/034 test cluster, and the two shared
# expected-message/exit-code assertion helpers this F3 pass-7 fix also
# touches) is the auth-credential-storage subsystem's canonical file, per
# ARCH-INDEX Subsystem Registry. Unchanged by this revision — the pass-7
# fix stays entirely inside the same file/subsystem already anchored here.
depends_on: []
blocks: []
behavioral_contracts:
  - BC-1.4.032
  - BC-1.4.033
  - BC-1.4.034
  # NEGATIVE PIN (F3 adversary pass-2, finding LOW-1): BC-1.1.004 is
  # DELIBERATELY EXCLUDED from this array. It is cited in the body's
  # Behavioral Contracts table and traced by AC-006/AC-008 as the
  # regression guard proving this story's #786 exit-code reclassification
  # did NOT over-reach into `src/cli/auth/status.rs`'s unrelated
  # unknown-profile site (PRD delta §5.1 scope-narrowing, #786). BC-1.1.004
  # itself is UNCHANGED by this story (no diff touches that BC's own file)
  # — it is referenced only as a boundary/regression anchor, not
  # implemented or amended here, so it correctly stays OUT of the
  # canonical `bcs:`/`behavioral_contracts:` implementation-tracking
  # arrays. A frontmatter-coherence checker cross-referencing the body's
  # BC table against these arrays should treat this comment as the
  # authoritative "why" for that one intentional asymmetry.
bcs:
  - BC-1.4.032
  - BC-1.4.033
  - BC-1.4.034
verification_properties:
  - VP-AUTHDX-027
  - VP-AUTHDX-028
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0020"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-007/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: HIGH
points: 8
acceptance_criteria_count: 10
assumption_validations: []
risk_mitigations: []
created: "2026-09-10"
version: "1.0"
last_updated: "2026-09-11"
breaking_change: true
retroactive: false
origin: >
  cycle-007 auth-correctness-dx, Wave 1 of 2, no deps within this cycle.
  `load_api_token`'s two credential-absence error branches
  (`src/api/auth.rs::load_api_token`, both-absent and partial-namespaced-pair)
  currently (a) recommend a remediation command, `jr auth login {profile}`
  (positional), that does NOT parse against the real clap surface — `--profile`
  is `#[arg(long)]`-only, so a user or an AI agent literally cannot execute the
  suggested fix as written (issue #784, HIGH); and (b) return
  `JrError::UserError` (exit 64), which is indistinguishable from an ordinary
  usage error to any script/agent that inspects exit codes, even though
  `error-taxonomy.md`'s own `NotAuthenticated` variant ("no token in keychain")
  already exists for exactly this class of failure (issue #786, MEDIUM). This
  story fixes both defects at the SAME two lines of `load_api_token` (one code
  path, two error branches) and deliberately does NOT touch
  `src/cli/auth/status.rs`'s unrelated unknown-profile site (BC-1.1.004 stays
  exit 64 — "profile does not exist" is a usage error, categorically distinct
  from "profile exists but has no stored credentials"). F2
  (`cycle-007-prd-delta.md` §3, six adversary fix rounds on the surrounding
  BC-1.6.04x vocabulary work, none touching this story's own BC-1.4.032/033/034
  content after the initial amendment) was human-APPROVED at the F1 gate
  (2026-09-10) as part of the 6-issue `auth-correctness-dx` bundle.
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. This is a
> security-sensitive auth-module correctness fix (`module_criticality: HIGH`,
> `src/api/auth.rs`) with a breaking exit-code change — every guard test must
> be a genuine RED-before-GREEN proof (clap round-trip, exit-code assertion),
> never a facade.

> **Execute:** `/vsdd-factory:deliver-story S-cycle7-credential-absence-fix`

> **STORY REVISED (2026-09-11, F3 adversary pass-10, finding MEDIUM-1) —
> Task 7a's own instructions are EXTENDED, not reversed: the two shared
> expected-message helpers and their prefix-free contract (locked at
> pass-7 and AC-010) stay exactly as written, but a THIRD class of
> pre-existing site the pass-7 fix missed is now closed — the point where
> `assert_user_error_exit_64` (renamed `assert_not_authenticated_exit_2`),
> `absence_guard_proptests::assert_absent_err_and_no_write`, and
> `prop_vp_authdx_008_namespaced_partial_state_safety`'s inline duplicate
> each BUILD the `msg` string they return/use, via `format!("{err:#}")` —
> the FULL `Display`-rendered error text. Once Task 7 lands,
> `JrError::NotAuthenticated`'s own Display impl (`#[error("Not
> authenticated. {hint}")]`, `src/error.rs::18`) prepends `"Not
> authenticated. "` to that text, while `expected_bc_1_4_032_absent_message`/
> `expected_bc_1_4_033_partial_message` correctly stay prefix-free per
> AC-010's locked hint-field contract — so EVERY pre-existing full-equality
> `assert_eq!(msg, expected_bc_1_4_03{2,3}_..._message(...))` site (12 of
> them, grep-verified against the real, current `src/api/auth.rs`;
> enumerated in the new **Task 7a Reconciliation Table** below) would fail
> at GREEN-gate time under a literal, unextended reading of the pass-7
> bullets alone. **LOCKED FIX:** the 3 message-CONSTRUCTION sites — not the
> 12 downstream comparison sites — are corrected to destructure
> `JrError::NotAuthenticated { hint }` and return/build `hint.clone()`
> instead of `format!("{err:#}")`; this is the single point of the fix, and
> the 12 downstream sites converge automatically with zero edits of their
> own. Task 7a's three affected sub-bullets are amended below with this
> instruction, and the new **Task 7a Reconciliation Table** section (after
> the Tasks list) gives the exhaustive per-site before/after audit this
> pass asked for. `expected_bc_1_4_032_absent_message`/
> `expected_bc_1_4_033_partial_message` are UNCHANGED by this fix beyond
> pass-7's own already-directed `--profile` wording rewrite — they stay
> prefix-free, per AC-010, exactly as pass-7 locked; the assertion SIDE is
> what changes, never the helper. Does not touch product code, does not
> change any AC's assertion content/exit code/message text, and does not
> touch any BC/VP spec. No re-estimate — `points`/`estimated_days` are
> unchanged (this closes a suite-convergence gap in Task 7a's own existing
> instructions, not new scope).

> **STORY REVISED (2026-09-10, F3 adversary pass-7, finding MEDIUM-1) —
> points re-estimated 5 → 8 (`estimated_effort: small` → `medium`,
> `estimated_days` 1.5 → 2.5); a new **Task 7a** added (see the Tasks list)
> and the File Structure Requirements table gained a dedicated row for the
> existing test module. Root cause: this story's own AC-001 (new test
> `test_bc_1_4_032_credential_absence_exits_2_not_64`, asserting exit 2)
> directly contradicts THREE existing shared test helpers in
> `src/api/auth.rs`'s inline `#[cfg(test)]` module that still assert the
> OLD contract (exit 64 `JrError::UserError`, positional `jr auth login
> {profile}` message) — `assert_user_error_exit_64` (`~3708-3722`, ~12 call
> sites), `expected_bc_1_4_032_absent_message` (`~3687-3692`), and
> `expected_bc_1_4_033_partial_message` (`~3696-3701`) — plus TWO more
> sites the original pass missed: the `absence_guard_proptests` module's
> own `assert_absent_err_and_no_write` helper (`~4109-4126`, duplicates the
> same assertion inline rather than calling `assert_user_error_exit_64`,
> backs `prop_vp_authdx_005`/`prop_vp_authdx_006`) and a second inline
> duplicate directly inside `prop_vp_authdx_008_namespaced_partial_state_
> safety` (`~4221-4225`, goes through neither helper). None of these ~12
> pre-existing tests were covered by any original Task, so the suite could
> not converge post-implementation without this fix. One test —
> `test_bc_1_4_033_remediation_message_never_mentions_auth_logout`
> (`~3960-3984`) — asserts only message substrings (`.contains("jr auth
> login")` / `!.contains("jr auth logout")`) with no exit-code or
> error-variant check, so it SURVIVES this story's change unmodified and
> must not be "fixed" or duplicated (LOW-1; also noted at AC-005 below).
> Does not touch product code or any BC/VP spec; no AC added or removed
> (acceptance_criteria_count stays 10) — this is scope completion for the
> existing AC-001/AC-002 contract, not new behavior.

> **STORY REVISED (2026-09-10, F3 adversary pass-4, finding MEDIUM-1 —
> SUPERSEDES the pass-2 revision below for Task 10/10a and the "Mutation
> Testing Scope" section):** the whole-file `src/api/auth.rs` addition to
> `.cargo/mutants.toml` `examine_globs` (originally Task 10, paired with
> Task 10a's `load_api_token` `exclude_re`) is DROPPED from this story, not
> merely re-scoped. Rationale: `examine_globs` has no sub-file targeting, so
> adding whole-file `auth.rs` pulls in ~15-20 PRE-EXISTING keyring-gated
> functions this story never touches (`load_oauth_tokens`, `store_*`,
> `clear_*`, `profile_has_stored_credentials`, `probe_stored_credential_kind`,
> `peek/load/probe_oauth_app_credentials`, legacy-flat helpers, etc.) beyond
> `load_api_token` alone — the nightly full-scope run
> (`mutants-nightly.yml`, no `--in-diff`, already at its 24-shard/300m
> runtime ceiling) would flood with un-killable false survivors from code
> this story's own diff does not change, just to gain a mutation signal for
> `load_api_token`'s two changed branches. Making the whole-file add
> "honest" would require enumerating/excluding all ~15-20 pre-existing
> functions — scope creep well beyond this story's own two-branch fix.
> **LOCKED RESOLUTION:** Task 10 and Task 10a below are REMOVED — this
> story makes NO `.cargo/mutants.toml` edit. The pass-2 "Mutation Testing
> Scope — `load_api_token` Exclusion" section's rationale is RETAINED below
> as a historical/deferred-design note only (it correctly diagnoses the
> false-survivor problem and documents a workable `exclude_re` shape for
> whenever the expansion is actually undertaken) — it is NOT an instruction
> to edit `.cargo/mutants.toml` as part of this story. The whole-file
> `src/api/auth.rs` `examine_globs` expansion is recorded as an explicit
> DEFERRED follow-up in the new **Deferred: `src/api/auth.rs`
> Mutation-Scope Expansion** section below, which extends the gap
> `docs/specs/cargo-mutants-policy.md`'s existing FIX-F6-1/FIX-F6-A note
> already anticipated ("closing this gap needs either an in-CI
> keychain-injection seam or a broad, carefully-scoped `exclude_re`
> allowlist for the keyring-gated functions... tracked as a follow-up,
> FIX-F6-A"). This story's own correctness scope (AC-001 through AC-010 and
> their tests) is UNCHANGED — only the mutation-testing-scope Tasks (10,
> 10a) and the File Structure Requirements row for `.cargo/mutants.toml`
> are dropped. `S-cycle7-auth-state-derivation`'s (B1) own Task 14 is
> revised in lockstep (its "confirm src/api/auth.rs entry exists, or add it
> if this story lands first" fallback is removed — B1 must not add
> `src/api/auth.rs` to `examine_globs` under any circumstance either). Does
> not touch product code or any BC/VP spec.

> **STORY REVISED (2026-09-10, F3 adversary pass-1, finding F-1, MEDIUM):**
> each AC below now carries an explicit **Test method** tag
> (`DEFAULT CI` or `keyring-gated`), reconciling the story's stated test
> method with what is actually achievable given `load_api_token`'s own
> documented coverage boundary. `load_api_token`/`load_oauth_tokens` read
> and write the REAL OS keychain with **no in-memory injection seam** — this
> is not new to this story; it is VP-AUTHDX-005/006's own explicit
> "Coverage boundary" note (`bc-1-auth-identity.md`), which states a keychain
> injection seam "is a tracked follow-up — not implemented as part of this
> fix." VP-AUTHDX-027's "(b) exit-code/message assertion against an injected
> absent-credential state" phrase therefore means "a freshly-chosen,
> never-used profile name" (an absent-by-construction fixture), NOT a
> mocked/dependency-injected keychain read — exercising it still requires the
> real keyring backend, exactly like every existing `load_api_token` test in
> `src/api/auth.rs` (`load_api_token_returns_err_for_missing_profile`,
> `load_api_token_propagates_backend_error_not_absent_message`, etc., all
> `#[ignore]+JR_RUN_KEYRING_TESTS=1`). This story does **not** attempt to
> build the keychain injection seam that VP-AUTHDX-005 explicitly defers —
> that remains out of scope. AC-001/AC-002/AC-005 (and AC-007's
> credential-absence half) are therefore keyring-gated, consistent with that
> precedent; AC-003/AC-004/AC-006/AC-008 (and AC-007's unknown-profile half)
> need no keychain at all and run in DEFAULT CI. This is a pure test-method
> clarification — it does not change any AC's assertion content, exit code,
> or message text, and does not touch product code.

# S-cycle7-credential-absence-fix — Credential-absence remediation parses; exits 2, not 64

## Narrative

- **As a** `jr` user or AI agent whose profile has no stored API-token credentials
- **I want to** receive an error whose suggested remediation command actually
  parses, and whose exit code distinguishes "you're not authenticated" from
  "you asked for something invalid"
- **So that** I (or my scripting/agent tooling) can programmatically detect
  and self-heal a credential-absence failure without hand-parsing stderr text,
  and so that copy-pasting the suggested command actually works on the first try

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-1.4.032 | PRIMARY (amended) | Postcondition 2 (both-namespaced-keys-absent branch: message + exit code), Invariant 6 |
| BC-1.4.033 | PRIMARY (amended) | Postcondition 2 (exactly-one-namespaced-key-present branch: message + exit code), Invariant 2 (SR-009) |
| BC-1.4.034 | CROSS-REFERENCE ONLY (amended) | H1/Postcondition 1 quote BC-1.4.032's message verbatim (no independent code change); F4 doc-fallout obligation (CHANGELOG breaking-change entry) |
| BC-1.1.004 | NEGATIVE PIN, deliberately UNCHANGED | Confirms `src/cli/auth/status.rs`'s unknown-profile site stays exit 64 — proves this story's scope narrowing (PRD delta §5.1) did not over-reach |

## Acceptance Criteria

### AC-001 (traces to BC-1.4.032 postcondition 2)
`load_api_token(profile)`'s both-namespaced-keys-absent branch (`src/api/auth.rs::load_api_token`, the `(None, None)` match arm, currently `~line 798`) returns `JrError::NotAuthenticated { hint }` (`exit_code() == 2`) with `hint` set to exactly:
`"No credentials stored for profile '{profile}'. This version of jr requires per-profile credentials — run \`jr auth login --profile {profile}\` to set them up."`
— identically whether or not the legacy shared flat `email`/`api-token` pair is present in the keychain (Postcondition 2's symmetric outcome; the legacy-pair existence check, Postcondition 1, is unaffected by this story and stays existence-only).
**Test:** `test_bc_1_4_032_credential_absence_exits_2_not_64`. **Test method: keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`)** — `load_api_token` has no in-memory injection seam (VP-AUTHDX-005's own documented coverage-boundary note); the "absent credential" fixture is a freshly-chosen, never-used profile name exercised against the REAL keyring backend, the same pattern as every other `load_api_token` test in `src/api/auth.rs`.

### AC-002 (traces to BC-1.4.033 postcondition 2)
`load_api_token(profile)`'s exactly-one-namespaced-key-present branch (`src/api/auth.rs::load_api_token`, the `_` catch-all match arm, currently `~line 807`) returns `JrError::NotAuthenticated { hint }` (`exit_code() == 2`) with `hint` set to exactly:
`"Incomplete credentials stored for profile '{profile}' — run \`jr auth login --profile {profile}\` to fix this."`
**Test:** `test_bc_1_4_033_partial_write_exits_2_and_recommends_login_not_logout`. **Test method: keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`)** — same reasoning as AC-001: no injection seam exists for `load_api_token`'s partial-write branch.

### AC-003 (traces to BC-1.4.032 postcondition 2 / VP-AUTHDX-027 property a)
The literal remediation string `jr auth login --profile <profile>` — with `<profile>` substituted for a representative value, e.g. `default` — parses through the real clap surface (`Cli::try_parse_from(["jr","auth","login","--profile","default"])`) and resolves successfully to `AuthCommand::Login { profile: Some("default".to_string()), .. }`, producing NO clap usage error.

**NOTE (LOW-2, F3 adversary pass-1):** `src/cli/mod.rs` defines a `--profile` flag at TWO levels — a global `Cli.profile` (`#[arg(long, global = true)]`, top-level, applies to every subcommand) AND a Login-LOCAL `profile` field on `AuthCommand::Login` itself (`#[arg(long)]`). The assertion above (`AuthCommand::Login { profile: Some("default".to_string()), .. }`) targets the Login-LOCAL field specifically — that is the field `load_api_token`'s remediation string is instructing the user to populate (the subcommand-scoped `--profile` accepted after `login`), not `Cli.profile` (which would also successfully parse the same token string but bind it to a DIFFERENT field entirely, at the top-level `Cli` struct, and would NOT prove this BC's specific remediation command works). The test author must destructure `AuthCommand::Login`'s own `profile` field, not `Cli.profile`, when asserting AC-003/AC-004's outcomes — asserting the wrong field would let a test pass even if `AuthCommand::Login`'s local `profile` field were renamed or removed, defeating the point of this regression guard.

**Test:** `test_bc_1_4_032_remediation_command_parses_against_clap`. **Test method: DEFAULT CI** — pure `Cli::try_parse_from` round-trip; no keychain call at all.

### AC-004 (traces to VP-AUTHDX-027 property a, negative regression anchor)
The OLD positional form `["jr","auth","login","default"]` (no `--profile` flag) FAILS to bind `"default"` to `AuthCommand::Login`'s `profile` field — either a clap parse error, or a successful parse where `profile` is `None` and `"default"` is rejected/unconsumed — proving the pre-cycle-007 remediation string was genuinely broken, not merely stylistically different. This test must be part of the SAME test module as AC-003 so a reviewer sees both anchors together.
**Test:** `test_bc_1_4_032_remediation_command_parses_against_clap` (negative-anchor assertion within the same test). **Test method: DEFAULT CI** — same clap-only test as AC-003; no keychain.

### AC-005 (traces to BC-1.4.033 invariant 2, SR-009)
The partial-write branch's error message NEVER contains the substring `"logout"` (a substring-absence assertion) — `jr auth logout` is a no-op for api-token profiles (BC-1.2.013, amended) and must never be recommended as a fix for this state. The message recommends only `jr auth login --profile <profile>` (primary fix) or, implicitly via general docs, `jr auth remove <profile>` (abandon-and-restart) — neither of which is `logout`.
**Test:** `test_bc_1_4_033_partial_write_exits_2_and_recommends_login_not_logout` (substring-absence assertion within the same test). **Test method: keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`)** — rides in the same test body as AC-002, which requires the real keyring backend.

**NOTE (LOW-1, F3 adversary pass-7):** the PRE-EXISTING test
`test_bc_1_4_033_remediation_message_never_mentions_auth_logout`
(`src/api/auth.rs:~3960-3984`) already asserts this exact property —
`.contains("jr auth login")` and `!.contains("jr auth logout")` against the
raw formatted message — and it SURVIVES this story's implementation change
completely unmodified: it has no exit-code or `JrError` variant assertion,
and the `--profile` wording change does not remove either substring. Do
**not** "fix" or touch this test as part of Task 7a's rewrite sweep, and do
not write a byte-for-byte duplicate of it for this new AC — the new test
above either (a) reuses/references the existing test's coverage in its doc
comment rather than re-asserting the identical substring-absence check, or
(b) if the new keyring-gated test body is kept separate for AC-002/AC-005
co-location reasons (as specified above), its doc comment must say so
explicitly, so a reviewer does not read the two as redundant duplicates
that should be merged.

### AC-006 (traces to BC-1.1.004, unchanged — VP-AUTHDX-028 property 1, NEGATIVE pin)
`jr auth status --profile <name-not-in-config>` still exits **64** with `JrError::UserError` and stderr containing `unknown profile` — `src/cli/auth/status.rs`'s unknown-profile branch is NOT modified by this story (no diff touches that file). This is the regression guard proving the #786 reclassification did not over-reach into the unrelated "profile does not exist" site.
**Test:** `test_bc_1_1_004_unknown_profile_stays_exit_64`. **Test method: DEFAULT CI** — `status.rs`'s unknown-profile check (`config.global.profiles.contains_key(&target)`) fires BEFORE any credential probe, so no keychain backend is touched or needed.

### AC-007 (traces to VP-AUTHDX-028 property 2, the load-bearing discriminator)
In one test module, both AC-001/AC-002's credential-absence exit code (2, `NotAuthenticated`) and AC-006's unknown-profile exit code (64, `UserError`) are asserted against DIFFERENT profile-name/keychain-state fixtures, so a mutant that unifies the two sites onto a single exit code (in either direction) fails at least one assertion.
**Test:** `test_auth_credential_absence_vs_unknown_profile_are_distinct_codes`. **Test method: MIXED, co-located for reviewer proximity** — this module's credential-absence-exit-2 assertion (the AC-001/AC-002 half) is `#[ignore]+JR_RUN_KEYRING_TESTS=1` (keyring-gated, per AC-001/AC-002); its unknown-profile-exit-64 assertion (the AC-006 half) has no such gate and runs in DEFAULT CI. Both assertions live in the same file/module (not necessarily the same `#[test]` function) so a reviewer sees the discriminator in one place; do NOT force them into a single `#[test]` fn merely to satisfy "one test module," since that would make the whole discriminator keyring-gated and lose AC-006's own default-CI coverage.

### AC-008 (traces to BC-1.1.004 unchanged / VP-AUTHDX-028 property 3, EC-1.6.050-1 tie-in)
`jr auth status --output json --profile <unknown>` emits the STANDARD `{"error": "...", "code": 64}` JSON error envelope (`error-taxonomy.md` Section 1's JSON Error Shape) — the unknown-profile exit-64 check fires before any output-format-specific success-schema code path could run (independent of this story's own scope, but this story's exit-code discriminator work is what this AC pins against regressing).
**Test:** `test_bc_1_1_004_unknown_profile_json_envelope_is_standard_error_shape`. **Test method: DEFAULT CI** — same reasoning as AC-006: the unknown-profile check fires before any keychain probe in either output mode.

### AC-009 (traces to BC-1.4.034 cross-reference / F4 doc-fallout obligation)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Fixed` (or `Changed`, per this project's breaking-change convention) entry documenting: (a) the credential-absence remediation command now reads `jr auth login --profile <profile>` (was a non-parsing positional form), and (b) the exit code for both `load_api_token` credential-absence branches changed from 64 to 2 — styled after the existing BC-1.2.051/DEC-321 CHANGELOG breaking-change precedent, and explicitly noting `src/cli/auth/status.rs`'s unrelated unknown-profile exit-64 site (BC-1.1.004) is UNAFFECTED.
**Test:** N/A (doc artifact; verified by PR review / `scripts/check-*.sh` guards where applicable, not a `#[test]`)

### AC-010 (traces to BC-1.4.032 postcondition 2 hint-field clarification, F2 fix round 6, finding L-2)
Both AC-001 and AC-002's quoted strings are constructed as the `hint` FIELD of `JrError::NotAuthenticated { hint }` — relying on `JrError`'s existing `#[error("Not authenticated. {hint}")]` Display impl (`src/error.rs::18`) to prepend `"Not authenticated. "` at render time — never a hand-rolled `format!` string that duplicates or omits that prefix. The exit-code/message tests (AC-001/AC-002) assert via a `.contains(...)` substring check against the QUOTED hint text (which does not include the prefix), not a full-string equality against the rendered Display output.
**Test:** covered by AC-001/AC-002's own test bodies (construction-site review, not a separate test). **Test method: keyring-gated** (inherits AC-001/AC-002's gate — no separate test to tag).

## Test Method Summary (F3 adversary pass-1, finding F-1)

| AC | Test method | Why |
|----|-------------|-----|
| AC-001 | keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`) | `load_api_token` both-absent branch; no injection seam (VP-AUTHDX-005) |
| AC-002 | keyring-gated | `load_api_token` partial-write branch; same reason |
| AC-003 | DEFAULT CI | pure clap round-trip, no keychain |
| AC-004 | DEFAULT CI | pure clap round-trip (negative anchor), no keychain |
| AC-005 | keyring-gated | rides in AC-002's test body |
| AC-006 | DEFAULT CI | `status.rs` unknown-profile check fires before any probe |
| AC-007 | mixed, co-located | credential-absence half keyring-gated, unknown-profile half DEFAULT CI |
| AC-008 | DEFAULT CI | unknown-profile check fires before any probe, both output modes |
| AC-009 | N/A (doc) | CHANGELOG entry, not a `#[test]` |
| AC-010 | keyring-gated | inherits AC-001/AC-002's gate (construction-site review only) |

This reconciles the story's stated test methods with VP-AUTHDX-005/006's own
documented "no in-memory injection seam... tracked follow-up, not
implemented as part of this fix" coverage boundary — no test claims DEFAULT
CI coverage it cannot actually achieve, and no achievable DEFAULT CI
coverage (AC-003/004/006/008, and AC-007's discriminator half) is left
mis-described as keyring-gated.

> **STORY REVISED (2026-09-10, F3 adversary pass-2, finding MEDIUM-1) —
> SUPERSEDED at F3 pass-4 (see the pass-4 banner above): the Task 10
> `examine_globs` addition and Task 10a `exclude_re` this revision
> introduced are DROPPED, not merely reworded. This banner is retained
> verbatim below for audit-trail continuity (it documents the correct
> false-survivor diagnosis and the `exclude_re` shape a future expansion
> should reuse), but Task 10/10a and the `.cargo/mutants.toml` diff it
> describes are NOT part of this story's burst.**
>
> Original pass-2 text: Task 10's `.cargo/mutants.toml` `examine_globs` addition for
> `src/api/auth.rs` is now paired with a JUSTIFIED `exclude_re` scoping
> mutation coverage AWAY from `load_api_token` — the whole function, not
> merely this story's two changed branches — because (confirmed by
> inspection of `src/api/auth.rs`'s existing inline test module) EVERY
> `load_api_token_*` test is `#[ignore = "requires keyring backend..."]`
> (`load_api_token_returns_err_for_missing_profile`,
> `load_api_token_default_profile_has_no_legacy_fallback`,
> `load_api_token_cross_profile_isolation`,
> `load_api_token_propagates_backend_error_not_absent_message`), and
> `.cargo/mutants.toml`'s `additional_cargo_test_args = ["--all-features"]`
> carries no `--include-ignored`. Without the exclusion, adding whole-file
> `src/api/auth.rs` to `examine_globs` would report every mutant inside
> `load_api_token` — including this story's own two changed branches — as
> MISSED/survived under `cargo mutants --in-diff` on this story's own PR
> gate, the exact partially-false-coverage anti-pattern
> `S-cycle7-auth-state-derivation`'s F-1 fix eliminated for the renderer
> half of this same cycle. See the new **Mutation Testing Scope**
> section below for the exact `exclude_re` text (mirrors the S-575-1
> precedent already in `.cargo/mutants.toml:~132`) and Task 10's revised
> wording. This is completeness of the LOCKED "examine_globs addition
> in-scope" decision (F3 pass-1), not a reversal — it does not touch
> product code or any BC/VP spec.

## Mutation Testing Scope — `load_api_token` Exclusion (F3 adversary pass-2, MEDIUM-1; HISTORICAL/DEFERRED — see F3 pass-4 banner above)

> **STATUS (F3 adversary pass-4, MEDIUM-1):** this section is RETAINED as a
> historical/deferred-design note only. It is NOT applied by this story —
> Task 10/10a (below) that would have added this `.cargo/mutants.toml` diff
> are REMOVED. See the **Deferred: `src/api/auth.rs` Mutation-Scope
> Expansion** section (after the Tasks list) for the current disposition:
> this `exclude_re` shape is a correct starting point for whichever future
> story actually undertakes the whole-file `auth.rs` `examine_globs`
> expansion, alongside a comparable allowlist sweep for the ~15-20 other
> keyring-gated functions in that file.

**Problem this section closes:** whole-file `src/api/auth.rs` in
`examine_globs` (Task 10) without scoping would flood both this story's
own `--in-diff` PR gate and the nightly full-scope run with un-actionable
"survivor" noise from `load_api_token` — a function whose ENTIRE test
surface is keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`, no
`--include-ignored` in `.cargo/mutants.toml`'s `additional_cargo_test_args`,
no CI keyring backend). This is the exact gap
`docs/specs/cargo-mutants-policy.md`'s FIX-F6-1 note already flagged and
deferred ("closing this gap needs either an in-CI keychain-injection seam
or a broad, carefully-scoped `exclude_re` allowlist for the keyring-gated
functions... tracked as a follow-up, FIX-F6-A") — this story is where
FIX-F6-A is finally paid down, for `load_api_token` specifically.

**Scope decision:** exclude the WHOLE `load_api_token` function, not only
this story's two changed branches (`auth.rs:801-816`, the `(None, None)`
and partial-pair match arms). Rationale: the `(Some, Some)` success arm and
the pre-match `?`-propagation reads (`legacy_flat_pair_exists()?`,
`read_keyring_optional(...)?`) are EQUALLY keyring-gated
(`load_api_token_cross_profile_isolation`,
`load_api_token_propagates_backend_error_not_absent_message`) — scoping the
exclusion to only this story's two branches would leave the identical
false-survivor class unresolved for the untouched arms of the same
function, defeating the "honest coverage signal" goal. Other keyring-gated
functions in `auth.rs` (`load_oauth_tokens`, `store_api_token`,
`store_oauth_tokens`, etc.) are NOT excluded by this story — they remain a
documented residual of the same FIX-F6-A class, out of this story's scope,
to be closed by whichever future story next needs whole-file `auth.rs`
mutation signal to be trustworthy for those functions too.

**Exact `.cargo/mutants.toml` diff (append to the existing `exclude_re`
array, immediately after the S-575-1 entry at `.cargo/mutants.toml:~132`):**

```toml
# JUSTIFIED EXCLUSION (S-cycle7-credential-absence-fix, F3 adversary
# pass-2, finding MEDIUM-1) — see docs/specs/cargo-mutants-policy.md
# §Exclusions and its FIX-F6-1/FIX-F6-A deferral note.
#
# Every mutant inside `load_api_token` (src/api/auth.rs) is reachable
# ONLY by keyring-gated tests: all `load_api_token_*` tests carry
# `#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to
# run"]` and are exercised only via
# `JR_RUN_KEYRING_TESTS=1 cargo test -- --include-ignored`.
# `.cargo/mutants.toml`'s `additional_cargo_test_args = ["--all-features"]`
# carries no `--include-ignored`, and CI has no keyring backend — so under
# the default mutation run, every mutant in this function would hang or
# report MISSED regardless of its actual correctness.
#
# `load_api_token` has no in-memory credential-injection seam — this is
# VP-AUTHDX-005's own documented coverage boundary (`bc-1-auth-identity.md`:
# "a keychain injection seam is a tracked follow-up — not implemented as
# part of this fix"), not a gap this story is obligated to close. The
# real-keychain-backend-probe alternative is tracked separately as
# OBS-PB-1 (out of scope this cycle — see
# `.factory/cycles/cycle-007/phase-f3-stories/dependency-graph-extended.md`
# EC-1.6.049-2/EC-1.6.050-3).
#
# Scope is the WHOLE function (not just this story's two changed
# `(None, None)`/partial-pair branches) — see this story's "Mutation
# Testing Scope" section for why partial scoping would leave the same
# false-survivor class unresolved for `load_api_token`'s untouched arms
# (the (Some, Some) success path and the `?`-propagation reads).
#
# Regex is anchored to FILE + exact FUNCTION NAME, not file:line:col
# (unlike the single-mutant S-575-1 exclusion above) — an allowlist
# covering every mutant cargo-mutants can generate inside one function
# needs to survive future in-function refactors without per-mutant
# line:col churn. cargo-mutants 27.1.0's `Mutant::styled_parts`
# (src/mutant.rs) appends " in <function_name>" to every mutant genre
# EXCEPT `FnValue` (whole-function-body replacement, which embeds the
# function name inline as "replace load_api_token ... with ..." instead);
# the two regexes below cover both shapes. Each matches ONLY mutants whose
# enclosing function is `load_api_token` in this one file — never
# `load_oauth_tokens`, any other `auth.rs` function, or
# `S-cycle7-auth-state-derivation`'s new `derive_auth_state` (which is
# fully default-CI-testable and MUST NOT be excluded).
#
# VERIFY BEFORE LANDING (mirrors the `auth_windows_store.rs` FIX-F6-1
# "confirm before landing" precedent, docs/specs/cargo-mutants-policy.md):
# run a scoped dry-run enumeration (e.g. `cargo mutants --file
# src/api/auth.rs --list`) against the POST-implementation code and confirm
# (a) every listed `load_api_token` mutant matches at least one of the two
# regexes below, and (b) no mutant belonging to any other function is
# inadvertently matched. If a mutant shape appears that neither regex
# covers (e.g. a new cargo-mutants Genre), add a third narrowly-scoped
# regex rather than loosening these two.
'^src/api/auth\.rs:\d+:\d+: replace load_api_token .*$',
'^src/api/auth\.rs:\d+:\d+: .+ in load_api_token$',
```

These two lines are appended INTO the existing `exclude_re = [...]` array
(`.cargo/mutants.toml:132-134`), not a second array — `exclude_re` accepts
multiple entries and the file already documents one.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `load_api_token` (both-absent branch) | `src/api/auth.rs` | Effectful (keychain reads via `read_keyring_optional`) |
| `load_api_token` (partial-write branch) | `src/api/auth.rs` | Effectful (keychain reads) |
| `AuthCommand::Login` clap surface | `src/cli/mod.rs` | Pure (derive-macro parse target; no code change, parse-target only) |
| `JrError::NotAuthenticated` | `src/error.rs` | Pure (error type + Display impl; pre-existing, no change) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-1.4.032-1 | `"default"` profile, legacy flat pair present, namespaced keys absent | Identical exit-2 error with `--profile default` remediation — legacy-pair presence changes nothing observable |
| EC-1.4.032-3 | Non-`"default"` profile (e.g. `"sandbox"`) with absent namespaced keys, legacy flat pair still exists | Identical error to `"default"`'s — no profile is special-cased |
| EC-1.4.032-4 | User runs `jr auth login --profile <profile>` once | Subsequent `load_api_token(profile)` calls succeed via the ordinary namespaced-keys-present path; legacy pair (if any) remains untouched |
| EC-1.4.033-1 | `default:email` present, `default:api-token` absent, AND a complete legacy flat pair also exists | Namespaced partial-write state still takes precedence (namespaced keys checked first) — surfaces this story's partial-write `Err` |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/api/auth.rs::load_api_token` | Effectful-shell | Reads OS keychain (`read_keyring_optional`); the two error-message branches this story touches are pure string construction wrapped in an effectful function |
| `src/cli/mod.rs::AuthCommand` | Pure-core (parse target) | Clap derive surface; this story adds no new code here, only exercises the existing derive as a parse-target for AC-003/AC-004 |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~3,500 |
| Referenced code files (`src/api/auth.rs` relevant region, `src/error.rs`, `src/cli/mod.rs::AuthCommand`) | ~6,000 |
| Test files (`src/api/auth.rs` full BC-1.4.032/033/034 test cluster incl. Task 7a's ~12 pre-existing tests + proptest module, new/modified integration test file) | ~6,500 |
| Tool outputs overhead (cargo test/clippy runs, grep) | ~3,000 |
| **Total** | **~19,000** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~10%** |

Well under the 20-30% threshold — no split needed.

## Tasks

1. [ ] Write failing tests for AC-001/AC-002 (exit-code + hint-substring assertions against an injected absent-credential state) — `test-writer`
2. [ ] Write failing tests for AC-003/AC-004 (clap round-trip + negative positional-form anchor) — `test-writer`
3. [ ] Write failing tests for AC-005 (substring-absence `"logout"` check) — `test-writer`
4. [ ] Write failing tests for AC-006/AC-007 (unknown-profile stays 64, discriminator module) — `test-writer`
5. [ ] Write failing test for AC-008 (`--output json` unknown-profile envelope) — `test-writer`
6. [ ] Verify Red Gate: all new tests fail against current code (positional form / exit 64)
7. [ ] Implement: change `load_api_token`'s two `Err(...)` constructions from `JrError::UserError(format!(...))` to `JrError::NotAuthenticated { hint: format!(...) }`, updating the remediation string from `jr auth login {profile}` to `jr auth login --profile {profile}` in both branches — `implementer`
7a. [ ] **(F3 adversary pass-7, MEDIUM-1; EXTENDED at F3 pass-10, MEDIUM-1 — see the "Task 7a Reconciliation Table" section after the Tasks list for the exhaustive per-site audit)** In the SAME commit as Task 7, update the ~12 PRE-EXISTING keyring-gated BC-1.4.032/033/034 tests in `src/api/auth.rs`'s inline `#[cfg(test)]` module (`~3680-4232`) that pin the OLD `load_api_token` contract, so the full suite (new AC-001/002/005/007/010 tests + these pre-existing ones) converges together — `implementer`:
    - Rewrite `expected_bc_1_4_032_absent_message` (`~3687-3692`) and `expected_bc_1_4_033_partial_message` (`~3696-3701`) to return the `` `jr auth login --profile {profile}` `` form. Keep both returning the raw hint text only (no `"Not authenticated. "` prefix) — per AC-010, assertions compare against the hint field, not the full Display-rendered string.
    - Rewrite `assert_user_error_exit_64` (`~3708-3722`) to assert `JrError::NotAuthenticated { .. }` and `exit_code() == 2` (rename it, e.g. `assert_not_authenticated_exit_2`, so the name reflects the new contract — a lingering `_exit_64` name on a function that now asserts exit 2 is itself a defect). Update all of its call sites (`~3755, 3773, 3800, 3830, 3834, 3860, 3864, 3889, 3911, 3936, 4010, 4043`) to the new name. **(F3 adversary pass-10, MEDIUM-1)** ALSO change what the renamed function RETURNS: today it returns `format!("{err:#}")` (`~3721`) — the FULL `Display`-rendered string. `JrError::UserError`'s Display is a pass-through (`#[error("{0}")]`), so this happens to equal the raw message today; but `JrError::NotAuthenticated`'s Display (`#[error("Not authenticated. {hint}")]`, `src/error.rs::18`) PREPENDS `"Not authenticated. "`, which would break every downstream full-equality `assert_eq!(msg, expected_bc_1_4_03{2,3}_..._message(...))` site if `format!("{err:#}")` were kept. Instead, downcast, `match`/`if let` on `JrError::NotAuthenticated { hint }`, and return `hint.clone()` (the raw `hint` FIELD, never a hand-rolled or Display-derived string) — this is the ONE place this fix needs to happen for this helper; do NOT edit the ~10 downstream `assert_eq!` call sites individually (Section A of the Task 7a Reconciliation Table below), and do NOT add the `"Not authenticated. "` prefix to `expected_bc_1_4_032_absent_message`/`expected_bc_1_4_033_partial_message` instead — that would violate AC-010's locked prefix-free hint-field contract.
    - Rewrite `absence_guard_proptests::assert_absent_err_and_no_write` (`~4109-4126`) — it duplicates the same `matches!(je, JrError::UserError(_))` / `exit_code()==64` assertion INLINE rather than delegating to `assert_user_error_exit_64`; it backs `prop_vp_authdx_005_detect_and_instruct_correctness` (`~4141`) and `prop_vp_authdx_006_no_profile_is_special_cased` (`~4180`). **(F3 adversary pass-10, MEDIUM-1)** Apply the SAME return-value fix as above: this function also builds its return via `format!("{err:#}")` (`~4125`) — change it to destructure `JrError::NotAuthenticated { hint }` and return `hint.clone()`, so the two downstream full-equality sites at `~4153` (inside `prop_vp_authdx_005_...`) and `~4189` (inside `prop_vp_authdx_006_...`) converge without their own edits.
    - Rewrite the separate inline duplicate assertion inside `prop_vp_authdx_008_namespaced_partial_state_safety` (`~4221-4225`) — it goes through neither helper and re-asserts `JrError::UserError`/`exit_code()==64` directly. **(F3 adversary pass-10, MEDIUM-1)** Apply the SAME return-value fix: this site builds `msg` inline via `format!("{err:#}")` at `~4226` — change it to destructure `JrError::NotAuthenticated { hint }` and build `msg` from `hint.clone()`, so the downstream full-equality assertion at `~4227` converges without its own edit.
    - Leave `test_bc_1_4_033_remediation_message_never_mentions_auth_logout` (`~3960-3984`) untouched — see AC-005's LOW-1 note above; it has no exit-code/variant assertion, asserts substrings only, and survives unmodified regardless of the prefix (neither `"jr auth login"` nor `"jr auth logout"` appears inside `"Not authenticated. "`).
    - Scope boundary: this task touches ONLY the credential-absence sites listed above, all inside `load_api_token`'s BC-1.4.032/033/034 test cluster. It MUST NOT touch any exit-64 assertion belonging to `src/cli/auth/status.rs`'s unrelated unknown-profile negative-pin coverage (AC-006/AC-007/AC-008, BC-1.1.004) — those are a categorically different site (Task 8 confirms `status.rs` stays byte-for-byte untouched) and stay exit 64 by design.
8. [ ] Confirm `src/cli/auth/status.rs`'s unknown-profile branch is byte-for-byte untouched (diff review — no file change expected there)
9. [ ] Refactor: confirm no other call site constructs an equivalent message that also needs the same fix (grep for `"jr auth login {`/`"jr auth login \`" literal patterns in `src/`)
10. [ ] ~~Add `src/api/auth.rs` to `.cargo/mutants.toml` `examine_globs`~~ — **REMOVED (F3 adversary pass-4, finding MEDIUM-1).** This task is dropped entirely, not merely reworded: whole-file `src/api/auth.rs` has no sub-file `examine_globs` targeting available, so adding it would pull ~15-20 PRE-EXISTING keyring-gated functions this story never touches into the nightly full-scope mutation run, flooding it with un-actionable false survivors. See the "STORY REVISED (F3 adversary pass-4, finding MEDIUM-1)" banner near the top of this file and the **Deferred: `src/api/auth.rs` Mutation-Scope Expansion** section below (after this Tasks list). This story makes NO `.cargo/mutants.toml` edit. (The pass-3 scope-reconciliation note that previously lived here — confirming Task 10 covers only `auth.rs`, never `list.rs`/`status.rs` — is moot now that Task 10 is removed; `list.rs`'s entry remains owned exclusively by `S-cycle7-auth-state-derivation`'s Task 14 and `status.rs`'s by `S-cycle7-auth-status-json`'s Task 15, unaffected by this change.)
10a. [ ] ~~Append `load_api_token`-scoped `exclude_re` entries~~ — **REMOVED (F3 adversary pass-4, finding MEDIUM-1).** Moot once Task 10 is dropped: with `src/api/auth.rs` never entering `examine_globs` via this story, there is nothing for this exclusion to scope. The rationale and exact regex text are RETAINED in the "Mutation Testing Scope — `load_api_token` Exclusion" section above as a historical/deferred-design note for whichever future story undertakes the deferred whole-file `auth.rs` expansion (see the Deferred section below) — but no `.cargo/mutants.toml` edit is made by this story.
11. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` (or `Changed`, per this project's breaking-change convention) documenting the shipped behavior (AC-009), before creating the PR
12. [ ] Update `docs/specs/issue-create-preflight-guards.md` or any other doc citing the old `jr auth login {profile}` positional form as a valid example, if found by grep (doc-fallout sweep; not expected to find any per F1/F2 scoping, but confirm)
13. [ ] F-1 closure verification (Test Method Summary table above): run `cargo test` with NO flags/env and confirm AC-003/AC-004/AC-006/AC-008 (and AC-007's unknown-profile half) execute and pass; then run `JR_RUN_KEYRING_TESTS=1 cargo test -- --include-ignored` and confirm AC-001/AC-002/AC-005/AC-010 (and AC-007's credential-absence half) execute and pass, AND that all ~12 Task-7a-rewritten pre-existing tests (plus the 3 `absence_guard_proptests` property cases) pass against the new implementation — confirm neither set is mis-tagged (no keyring-needed test accidentally lacks `#[ignore]`, no keychain-free test is needlessly gated), and confirm `test_bc_1_4_033_remediation_message_never_mentions_auth_logout` still passes unmodified (LOW-1)

## Task 7a Reconciliation Table (F3 adversary pass-10, MEDIUM-1 — comprehensive audit)

Grounded against the real, currently-existing `src/api/auth.rs` source (read
and grep-verified line-by-line before this table was written, not
approximate reasoning from the story text alone). "Today" describes the
PRE-existing (unmodified) code; "Must become" describes the state required
for the full suite — new AC-001/002/005/007/010 tests plus every
pre-existing test in this cluster — to converge GREEN once Task 7/7a land.
The table distinguishes ROOT-CAUSE construction sites (Section A — where
the actual code edit happens), DOWNSTREAM sites that converge automatically
once Section A is fixed (Sections B-D), a substring-only survivor that must
NOT be touched (Section E, LOW-1), and an unrelated negative pin that must
also stay untouched (Section F). No site in Sections A-D is left where a
mechanical, unextended application of Task 7a's pass-7 bullets alone would
produce a red or non-converging assertion.

#### A. Message-construction / root-cause sites (the ONLY 3 places the literal `format!("{err:#}")` → `hint`-field edit is made)

| Site | Today | Must become |
|------|-------|-------------|
| `assert_user_error_exit_64` return, `~3721` (function `~3708-3722`) | Downcasts to `JrError`, asserts `matches!(je, JrError::UserError(_))` + `exit_code()==64` (full-eq comparison style: N/A here, this is the construction site), returns `format!("{err:#}")` — today equals the raw message with no prefix because `UserError`'s Display is `#[error("{0}")]` (pass-through) | Renamed `assert_not_authenticated_exit_2`; asserts `matches!(je, JrError::NotAuthenticated { .. })` + `exit_code()==2`; **destructures and returns `hint.clone()`** (the `hint` FIELD), never `format!("{err:#}")` |
| `absence_guard_proptests::assert_absent_err_and_no_write` return, `~4125` (function `~4109-4126`) | Same shape, inline (does not delegate to the shared helper); returns `format!("{err:#}")` | Asserts `NotAuthenticated`/`exit_code()==2`; returns the destructured `hint.clone()`, not `format!("{err:#}")` |
| `prop_vp_authdx_008_namespaced_partial_state_safety` inline duplicate, `~4226` (`let msg = format!("{err:#}");`, block `~4219-4227`) | Same shape, inline a second time; asserts `JrError::UserError`/`exit_code()==64` directly, builds `msg` via `format!("{err:#}")` | Asserts `NotAuthenticated`/`exit_code()==2` directly; builds `msg` from the destructured `hint` field, not `format!("{err:#}")` |

#### B. Call sites of `assert_user_error_exit_64` → `assert_not_authenticated_exit_2` (12 sites — mechanical rename only; message-content correctness is inherited from Section A, not fixed per-site)

| Call site | Enclosing test | Captures return value? | Downstream full-eq site | Change needed beyond the rename |
|---|---|---|---|---|
| `~3755` | `test_bc_1_4_032_absent_namespaced_keys_no_legacy_pair_returns_actionable_exit64` | yes (`msg`) | `~3756` (vs `expected_bc_1_4_032_absent_message`) | none — converges once Section A lands |
| `~3773` | `test_bc_1_4_032_absent_namespaced_keys_legacy_pair_present_returns_identical_actionable_exit64` | yes (`msg`) | `~3774` | none |
| `~3800` | `test_bc_1_4_032_no_copy_invariant_legacy_pair_untouched_and_no_percred_written` | no (discarded) | none — this test never compares message text | none |
| `~3830` | `test_bc_1_4_032_default_profile_not_special_cased_identical_to_other_profiles` | yes (`default_msg`) | `~3836` | none |
| `~3834` | same test | yes (`sandbox_msg`) | `~3837` | none |
| `~3860` | `test_bc_1_4_032_repeated_calls_return_same_err_no_first_call_side_effect` | yes (`msg1`) | `~3870` (plus a `msg1==msg2` self-comparison at `~3866-3869`, unaffected either way) | none |
| `~3864` | same test | yes (`msg2`) | only the `msg1==msg2` self-comparison, not directly against `expected_*` | none |
| `~3889` | `test_bc_1_4_033_namespaced_partial_email_present_returns_incomplete_credentials_error` | yes (`msg`) | `~3890` (vs `expected_bc_1_4_033_partial_message`) | none |
| `~3911` | `test_bc_1_4_033_namespaced_partial_token_present_returns_incomplete_credentials_error` | yes (`msg`) | `~3912` | none |
| `~3936` | `test_bc_1_4_033_partial_precedence_over_legacy_pair_present` | yes (`msg`) | `~3937` (plus an unaffected `!msg.contains("No credentials stored")` check) | none |
| `~4010` | `test_vp_authdx_007_keyring_gated_end_to_end_detect_and_instruct_scenario` (loop over `["default","sandbox"]`) | yes (`msg`) | `~4011` | none |
| `~4043` | `test_bc_1_4_034_single_relogin_permanently_resolves_the_breaking_change` | no (discarded) | none — this test never compares message text after the first failed call | none |

All 12 sites need only the mechanical `assert_user_error_exit_64` →
`assert_not_authenticated_exit_2` rename (already directed by Task 7a's
second bullet). NONE of them needs an additional edit for the
message-comparison mismatch — that is fully absorbed by Section A's 3
root-cause fixes.

#### C. Full-equality `assert_eq!` sites against `expected_bc_1_4_032_absent_message` (8 sites)

| Site | Today | Must become |
|------|-------|-------------|
| `~3756` | `assert_eq!(msg, expected_bc_1_4_032_absent_message("default"))` — passes today because `msg` carries no prefix (via `assert_user_error_exit_64`, `UserError`'s pass-through Display) | Passes again once Section A's fix lands (`msg` is the destructured `hint`, still prefix-free) — **no edit to this line itself** |
| `~3774` | same pattern | same — no edit to this line |
| `~3836` | same pattern (`default_msg`) | same |
| `~3837` | same pattern (`sandbox_msg`) | same |
| `~3870` | same pattern (`msg1`) | same |
| `~4011` | same pattern, inside the `for profile in [...]` loop | same |
| `~4153` (proptest `prop_vp_authdx_005_detect_and_instruct_correctness`) | `assert_eq!(msg1, expected_bc_1_4_032_absent_message("default"))`, `msg1` from `assert_absent_err_and_no_write` | same — converges once Section A's `assert_absent_err_and_no_write` fix lands |
| `~4189` (proptest `prop_vp_authdx_006_no_profile_is_special_cased`) | `assert_eq!(msg, expected_bc_1_4_032_absent_message(&profile))`, `msg` from `assert_absent_err_and_no_write` | same |

#### D. Full-equality `assert_eq!` sites against `expected_bc_1_4_033_partial_message` (4 sites)

| Site | Today | Must become |
|------|-------|-------------|
| `~3890` | `assert_eq!(msg, expected_bc_1_4_033_partial_message("sandbox"))` | converges once Section A + the already-directed `expected_bc_1_4_033_partial_message` body rewrite land — no edit to this line |
| `~3912` | same pattern | same |
| `~3937` | same pattern (plus an unaffected `!msg.contains("No credentials stored")` check) | same |
| `~4227` (proptest `prop_vp_authdx_008_namespaced_partial_state_safety`) | `assert_eq!(msg, expected_bc_1_4_033_partial_message(&profile))`, `msg` built inline at `~4226` | converges once Section A's inline fix (`~4226`) lands |

#### E. Substring-only survivor (LOW-1 — must NOT be touched)

| Site | Today | Must become |
|------|-------|-------------|
| `test_bc_1_4_033_remediation_message_never_mentions_auth_logout` (`~3962-3984`), `msg = format!("{err:#}")` at `~3971` | `.contains("jr auth login")` / `!.contains("jr auth logout")` against the FULL Display string; no exit-code/variant assertion at all | UNCHANGED — the `"Not authenticated. "` prefix contains neither substring, so this test passes before AND after Task 7/7a with zero edits. Do not rewrite; do not duplicate for a new AC (see AC-005's own LOW-1 note above) |

#### F. Unrelated exit-64 negative-pin sites (unchanged — different file, different BC)

| Site | Today | Must become |
|------|-------|-------------|
| `src/cli/auth/status.rs`'s unknown-profile branch (AC-006/AC-007/AC-008, BC-1.1.004) | `JrError::UserError`, exit 64, stderr contains `unknown profile` | UNCHANGED — byte-for-byte untouched (Task 8). Never confuse with Sections A-D's credential-absence sites; AC-007's discriminator test exists specifically to keep these two exit codes from ever being unified |

**Convergence guarantee:** with Section A's 3 fixes applied (return the
destructured `hint` field, not `format!("{err:#}")`) and the mechanical
rename applied at Section B's 12 call sites, every site in Sections C and D
passes WITHOUT any further per-site edit — the mismatch MEDIUM-1 (F3 pass-10)
identified is fully closed at its 3 root-cause construction points, not by
touching all 12 downstream comparison sites individually. Section E's
survivor and Section F's negative pin require zero edits either way. This
table supersedes any mechanical, line-by-line application of Task 7a's
bullets that stops at the rename/message-text steps without also fixing
what the helpers RETURN — that partial application is exactly what left the
suite RED at GREEN-gate time before this pass's fix.

## Deferred: `src/api/auth.rs` Mutation-Scope Expansion (F3 adversary pass-4, MEDIUM-1)

**Standing item — NOT this story's task, recorded here for cycle-007
traceability.** Adding whole-file `src/api/auth.rs` to `.cargo/mutants.toml`
`examine_globs` requires a comprehensive keyring-gated-function `exclude_re`
sweep (~15-20 functions: `load_api_token`, `load_oauth_tokens`, `store_*`,
`clear_*`, `profile_has_stored_credentials`, `probe_stored_credential_kind`,
`peek/load/probe_oauth_app_credentials`, the legacy-flat-pair helpers, and
others — the full set every `#[ignore = "requires keyring backend..."]`
test in that file's inline test module backs), not merely the two branches
this story's own diff touches. Without that comprehensive sweep, the
whole-file add floods both this story's `--in-diff` PR gate and the nightly
full-scope run (`mutants-nightly.yml`, already at its 24-shard/300m runtime
ceiling) with un-killable false survivors from code no story in this cycle
changes.

This deferral is not new — it extends the gap `docs/specs/cargo-mutants-
policy.md`'s existing FIX-F6-1 note already flagged and deferred for this
exact file: *"`src/api/auth.rs` and `src/cli/auth/login.rs` are NOT added to
`examine_globs`... Closing this gap needs either an in-CI
keychain-injection seam or a broad, carefully-scoped `exclude_re` allowlist
for the keyring-gated functions — both out of scope for FIX-F6-1; tracked
as a follow-up (mutation-results.md §5, FIX-F6-A)."* Cycle-007 does not pay
down FIX-F6-A; it is deferred to a dedicated mutation-hardening effort.

**What cycle-007 delivers instead:** `derive_auth_state`'s
(`S-cycle7-auth-state-derivation`, B1) correctness is proven by its
exhaustive default-CI truth-table unit tests (VP-AUTHDX-024/025, AC-001
through AC-003/AC-011 in that story) — a stronger, more direct guarantee
than a mutation-testing signal would add for a pure, total, 2-input
function. `load_api_token`'s two changed branches (this story) are proven
by AC-001/AC-002's keyring-gated exit-code/hint-text tests. Neither story's
own correctness depends on the deferred `examine_globs` expansion; only the
FILE-WIDE mutation-testing SIGNAL for `auth.rs` (as a whole, including the
~15-20 pre-existing functions neither story touches) remains deferred.

**Scope of the future follow-up, when undertaken:** (a) enumerate every
keyring-gated function in `src/api/auth.rs` at that time (the list above is
a snapshot, not a guarantee — functions may be added/renamed/removed
between now and then); (b) write one `exclude_re` pair per function (or a
broader file+match pattern if the regex count becomes unwieldy), mirroring
this story's own retained-but-unapplied "Mutation Testing Scope —
`load_api_token` Exclusion" section above as a worked example of the
required shape; (c) run the section's "VERIFY BEFORE LANDING" dry-run
discipline against the then-current file before landing; (d) add the file
to `examine_globs` and the exclusions in the SAME commit, exactly as this
story's own (now-removed) Task 10/10a would have done for `load_api_token`
alone.

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|----------------------|
| S-cycle3-credential-absence-guard (cycle-003) | Introduced the two `load_api_token` error branches this story amends (`JrError::UserError`/exit 64, positional `{profile}` remediation) — the ORIGINAL, now-defective design this story corrects | No-copy detect-and-instruct pattern (never touch the legacy flat pair); `EC-1.4.032-*`/`EC-1.4.033-*` edge-case numbering this story's ACs reuse | The positional remediation string was never actually round-tripped against the real clap surface at cycle-003 time — `profile` is `#[arg(long)]`-only, so it silently never parsed; this story's AC-003/AC-004 close that verification gap permanently |
| S-cycle4-honest-fail-message (cycle-004) | Established the "construct via the `hint` field of `JrError::NotAuthenticated { hint }`, let the shared Display impl prepend the prefix" construction pattern this story's AC-010 follows | Reuse the existing `NotAuthenticated` variant rather than inventing a new error type for "no credential found" | N/A — first cross-reference; no prior gotcha specific to this pattern surfaced |
| S-cycle3-remove-logout-semantics (cycle-003) | Established that `jr auth logout` is a no-op for api-token profiles (BC-1.2.013, amended) | SR-009: never recommend `jr auth logout` as a fix for an api-token credential problem | This story's AC-005 is the regression guard that keeps that precedent from silently eroding if the partial-write message is ever touched again |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `load_api_token` never reads, copies, or is influenced by the legacy shared flat `email`/`api-token` pair's VALUES | BC-1.4.032 Invariant 1 (unaffected by this story — no change to Postcondition 1's existence-only check) | Existing tests (`load_api_token_default_profile_has_no_legacy_fallback` etc.) must continue passing unmodified |
| No profile is special-cased (`"default"` and every other name go through the identical branches) | BC-1.4.032 Postcondition 4 | `test_bc_1_4_032_credential_absence_exits_2_not_64` MUST exercise at least one non-`"default"` profile name, not `"default"` alone |
| `src/cli/auth/status.rs`'s unknown-profile site is NEVER changed by this cycle | PRD delta §5.1 (locked scope narrowing) | AC-006/AC-007/AC-008; diff review confirms zero lines changed in `status.rs` |
| Genuine keychain backend errors propagate via `?`, never coerced into the "no stored credential" message | BC-1.4.032 Invariant 4 | Existing test `load_api_token_propagates_backend_error_not_absent_message` (line ~3434) must continue passing unmodified — this story touches only the `(None, None)` and partial-pair match arms, not the `?`-propagation paths above them |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `clap` | Per `Cargo.toml` pin (existing dependency, unchanged) | `Cli::try_parse_from` round-trip test for AC-003/AC-004 |
| `assert_cmd` | Per `Cargo.toml` pin (existing dev-dependency, unchanged) | Exit-code/stderr integration assertions for AC-001/AC-002/AC-006/AC-008 (mirrors existing pattern in `tests/auth_profiles.rs`) |

No new library is introduced by this story — it reuses the exact tools/versions already pinned in `Cargo.toml`.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/auth.rs` | modify | `load_api_token`'s two error branches: message text + `JrError::UserError`→`JrError::NotAuthenticated` |
| `src/cli/mod.rs` | read-only (no modify) | Parse target for AC-003/AC-004's clap round-trip test — confirms `--profile` is `#[arg(long)]`-only, unchanged |
| `tests/auth_profiles.rs` (or a new `tests/auth_credential_absence.rs` if the implementer judges the existing file too large) | modify or create | Integration tests for AC-001/AC-002/AC-006/AC-007/AC-008 |
| `src/api/auth.rs` inline `#[cfg(test)]` module | modify | Unit-level tests for AC-003/AC-004/AC-005 if colocated tests are preferred over a new integration file (implementer's choice, per existing project convention of both inline and `tests/`-directory coverage) |
| `src/api/auth.rs` inline `#[cfg(test)]` module — existing BC-1.4.032/033/034 test cluster (`~3680-4232`) | **modify (Task 7a, F3 adversary pass-7, MEDIUM-1)** | Rewrite `assert_user_error_exit_64`→`assert_not_authenticated_exit_2`, `expected_bc_1_4_032_absent_message`, `expected_bc_1_4_033_partial_message`, `absence_guard_proptests::assert_absent_err_and_no_write`, and `prop_vp_authdx_008`'s inline duplicate assertion — plus all ~12 call sites — from the old exit-64/positional contract to exit-2/`--profile`. Do NOT modify `test_bc_1_4_033_remediation_message_never_mentions_auth_logout` (LOW-1: survives unchanged, no exit-code/variant assertion). Do NOT touch `src/cli/auth/status.rs`'s unrelated unknown-profile exit-64 tests (BC-1.1.004, owned by Task 8's byte-for-byte-untouched confirmation). |
| `.cargo/mutants.toml` | **no modify (F3 adversary pass-4, MEDIUM-1)** | Task 10/10a (the whole-file `src/api/auth.rs` `examine_globs` addition + its `load_api_token`-scoped `exclude_re`) are REMOVED — see the "Deferred: `src/api/auth.rs` Mutation-Scope Expansion" section above. This story makes NO `.cargo/mutants.toml` edit. (`list.rs`/`status.rs` remain owned by `S-cycle7-auth-state-derivation`/`S-cycle7-auth-status-json` respectively, unaffected by this change — F3 pass-3, MED-1.) |
| `CHANGELOG.md` | modify | `[Unreleased]` breaking-change entry (AC-009 / Task 11) |
