---
document_type: story
level: ops
story_id: "S-cycle7-auth-status-json"
epic_id: "AUTH-CORRECTNESS-DX-1"
title: "auth status --output json full schema + human-text derivation re-sourcing (issue #787, retires NFR-O-N)"
wave: 2
status: draft
intent: enhancement
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
  - "src/cli/auth/status.rs"
  - "src/main.rs"
input-hash: "f728e9e"
traces_to: ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md §2"
cycle: cycle-007-auth-correctness-dx
estimated_effort: medium
estimated_days: 3
target_module: "src/cli/auth/status.rs"
subsystems: ["SS-02", "SS-01"]
depends_on: ["S-cycle7-auth-state-derivation"]
blocks: []
behavioral_contracts:
  - BC-1.6.050
  - BC-1.6.047
  - BC-1.6.048
bcs:
  - BC-1.6.050
  - BC-1.6.047
  - BC-1.6.048
verification_properties:
  - VP-AUTHDX-026
  - VP-AUTHDX-029
  # VP-AUTHDX-024 is intentionally NOT listed here (F3 adversary pass-2,
  # finding LOW-3). Its full two-machine-channel parity is an EMERGENT
  # INTEGRATION property realized only once THIS story lands alongside
  # S-cycle7-auth-state-derivation (B1) — no single story's own
  # unit/AC-level tests can assert it alone. This story contributes two
  # structural half-proofs toward it (AC-002: shared `derive_auth_state`
  # call-site; AC-011: field-name parity with `render_list_json`), but the
  # actual runtime parity proof is `wave-holdout-scenarios.md`'s
  # H-W2-INT-001 (a Wave-2 wave-gate artifact, not a story AC). See
  # `dependency-graph-extended.md`'s VP-to-Stories Matrix, "VP-AUTHDX-024
  # frontmatter-vs-coverage note", for the full explanation — this comment
  # exists so a frontmatter-keyed VP checker does not flag this story for
  # omitting a VP its own body/Behavioral-Contracts table cross-references.
holdout_anchors: []
nfr_anchors: ["NFR-O-N"]
adr_refs: ["ADR-0020"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-007/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: MEDIUM
points: 8
acceptance_criteria_count: 13
assumption_validations: []
risk_mitigations: []
created: "2026-09-10"
version: "1.0"
last_updated: "2026-09-10"
breaking_change: false
retroactive: false
origin: >
  cycle-007 auth-correctness-dx, Wave 2, depends_on:
  [S-cycle7-auth-state-derivation] because `status()`'s JSON `"status"` field
  and the human-text `Credentials:` line's re-sourced derivation both consume
  the shared `derive_auth_state` helper `S-cycle7-auth-state-derivation`
  introduces in `src/api/auth.rs` — this story cannot compile/pass its own
  tests until that helper exists. `jr auth status` has never had `--output
  json` support (NFR-O-N, documented gap). This story adds an `&OutputFormat`
  parameter to `status()`, threaded from `main.rs`, and on `--output json`
  emits a 6-key JSON object modeled on `render_list_json`'s per-profile shape
  (issue #787). The existing human-text output is proven byte-for-byte
  UNCHANGED in all cases (including the mismatched-credential-kind case) —
  only its INTERNAL derivation is re-sourced through the shared helper. F2
  (`cycle-007-prd-delta.md`, six adversary fix rounds — see BC-1.6.050's own
  STATUS/round notes, especially round 3/F6's correction of an
  over-claimed "output correction" and round 6/M-1's text-vs-machine-channel
  scope correction) was human-APPROVED at the F1 gate (2026-09-10).
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. This is a
> security-sensitive auth-module correctness/enhancement story
> (`module_criticality: MEDIUM`) with a subtle byte-for-byte-unchanged
> regression requirement on the human-text channel — every guard test must be
> a genuine RED-before-GREEN proof (including the negative "text output did
> NOT change" regression), never a facade.

> **Execute:** `/vsdd-factory:deliver-story S-cycle7-auth-status-json`

> **STORY REVISED (2026-09-10, F3 adversary pass-1, finding F-1, MEDIUM —
> corresponding fix to `S-cycle7-auth-state-derivation`'s B1 revision):**
> `status()`'s 6-key JSON object construction is extracted into a small PURE
> builder function (implementer's naming choice, e.g.
> `build_status_json(profile, url, env, auth_method, matching_kind_present,
> oauth_app) -> serde_json::Value`) that `status()` (still effectful, still
> performing the identical single kind-specific probe it already performs for
> the human-text `Credentials:` line) calls after computing its inputs. This
> gives AC-001/AC-003/AC-004/AC-005/AC-011 a DEFAULT-CI injection point
> (construct the builder's inputs directly, no keychain, no config load) —
> mirroring B1's `render_list_table`/`render_list_json` split. AC-006/AC-007/
> AC-008, which must actually exercise `status()`'s real `println!` text
> path and/or a real mismatched-credential-kind keychain fixture, remain
> keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`) — there is no seam that
> makes those three genuinely keychain-free (see VP-AUTHDX-005's own
> "no in-memory injection seam" coverage-boundary note on
> `load_oauth_tokens`/`load_api_token`, which this story's `status()` calls
> unchanged). AC-013 (NEW) is the purity/default-CI confirmation, mirroring
> B1's AC-014. This is a pure story-level/implementation-shape revision — it
> does not change BC-1.6.050's own text and does not touch product code.

> **STORY REVISED (2026-09-10, F3 adversary pass-2, finding LOW-3):** added
> a frontmatter comment (above, next to `verification_properties:`)
> explaining why VP-AUTHDX-024 is deliberately absent from this story's own
> `verification_properties:` array even though this story's AC-002/AC-011
> and the Behavioral Contracts table's BC-1.6.048 cross-reference row both
> touch it — VP-AUTHDX-024's full parity is closed at the Wave 2 gate via
> `wave-holdout-scenarios.md`'s H-W2-INT-001, not by this story's own
> frontmatter. See `dependency-graph-extended.md`'s VP-to-Stories Matrix for
> the full cross-reference. Pure documentation clarification — no AC,
> assertion, or product code changed.

> **STORY REVISED (2026-09-10, F3 adversary pass-3, findings LOW-1 and
> MED-1):**
>
> **LOW-1:** AC-001 through AC-006 now each carry an explicit
> `(traces to ... VP-AUTHDX-026)` tag — this story's frontmatter already
> declared `verification_properties: [VP-AUTHDX-026, VP-AUTHDX-029]`, but no
> AC body explicitly cited VP-AUTHDX-026 (coverage was real via the
> prescribed test names + the BC Clause/VP-to-Stories matrices in
> `dependency-graph-extended.md`, but the labeling was asymmetric with
> `S-cycle7-auth-state-derivation`, whose ACs all carry explicit VP tags).
> Pure labeling fix — no assertion content changed.
>
> **MED-1:** this story's own effectful residual — the kind-specific
> credential probe `status()` performs (currently the inline `creds_ok`
> match, `src/cli/auth/status.rs:144-147`) and the impure
> `peek_oauth_app_source()` wrapper (`status.rs:36-49`, which calls
> `try_load_oauth_app_credentials()`, a real keychain read) — is now
> explicitly named, scoped, and `exclude_re`'d rather than left as an
> undocumented false-survivor once Task 15 adds `status.rs` to
> `examine_globs`. AC-013's F-1 purity split already correctly moved the
> 6-key JSON object ASSEMBLY out of the probe's path (that part is fully
> default-CI-testable); MED-1 closes the gap for the probe CALL SITES
> themselves, which AC-006/AC-007/AC-008 exercise only under
> `#[ignore]+JR_RUN_KEYRING_TESTS=1` (confirmed: `peek_oauth_app_source`,
> as opposed to the already-tested pure `peek_oauth_app_source_for_test`,
> has zero default-CI test coverage today — grep-confirmed at F3
> pass-3 time). See the new **Mutation Testing Scope** section below.
> Task 11 and Task 15 are revised accordingly, and `status.rs`'s
> `examine_globs` ownership (previously ambiguous between this story's
> Task 15 and `S-cycle7-credential-absence-fix`'s Task 10) is now
> reconciled: this story owns it EXCLUSIVELY, since it is the only
> cycle-007 story that modifies `status.rs`. This is completeness of the
> F-1 injection-seam fix, not a reversal of it, and does not touch product
> code or any BC/VP spec text.

> **STORY REVISED (2026-09-10, F3 adversary pass-4, finding LOW-1):** the
> File Structure Requirements table's test-placement row is corrected.
> AC-011's test compares the pure JSON-builder's key set against
> `render_list_json`'s key set by calling BOTH functions DIRECTLY as
> `pub(crate)` symbols with injected/dummy inputs (per its own AC/Test text,
> unchanged) — `pub(crate)` symbols are NOT visible from the `tests/`
> integration crate (a separate compilation unit), so this test MUST be
> inline (`src/cli/auth/tests/mod.rs` or an inline `#[cfg(test)] mod`,
> matching the existing `list_table_snapshot`/`list_json_shape` precedent at
> `src/cli/auth/tests/mod.rs:519`/`:526`). AC-011's own body was always
> correct about calling these functions DIRECTLY; only the File Structure
> Requirements destination table incorrectly routed it to `tests/`. See the
> revised table below. This does not change any AC's assertion content and
> does not touch product code or any BC/VP spec.

# S-cycle7-auth-status-json — `auth status --output json` full schema, retires NFR-O-N

## Narrative

- **As a** `jr` user or AI agent scripting against `jr auth status`
- **I want to** get a structured, machine-parseable JSON object (matching
  `auth list`'s per-profile shape) when I pass `--output json`, instead of
  only ever getting human-formatted text
- **So that** I can programmatically check a specific profile's auth state
  (`unset`/`no-credentials`/`configured`) without scraping stdout text, and so
  that `auth status`'s reported state can never silently disagree with `auth
  list`'s STATUS column for the same profile against the same keychain state

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-1.6.050 | PRIMARY (new) | Postconditions 1-6; Invariants 1-2; EC-1.6.050-1/2/3/4 |
| BC-1.6.047 | CROSS-REFERENCE (amended) | Postcondition 2a (`env` field verbatim/lossless — realized, not redesigned, by this story) |
| BC-1.6.048 | CROSS-REFERENCE (new, primary owner is `S-cycle7-auth-state-derivation`) | Postcondition 3 (as revised round 6 — the text-channel 2-state projection this story's `status.rs` re-sourcing must satisfy); this story does NOT modify `derive_auth_state` itself |

**Depends on** `S-cycle7-auth-state-derivation` for the `derive_auth_state(url, matching_kind_present) -> AuthState` helper this story's JSON `"status"` field and text-channel re-sourcing both consume — see that story for `derive_auth_state`'s own spec and tests.

## Acceptance Criteria

### AC-001 (traces to BC-1.6.050 postcondition 1, VP-AUTHDX-026)
`status()` (`src/cli/auth/status.rs`) gains an `&OutputFormat` parameter, threaded from `main.rs`'s single `AuthCommand::Status` dispatch call site (`main.rs:~277-279`, mirroring the existing `output: &cli.output`/`output: cli.output` pattern already used for `handle_login`/`refresh_credentials`). On `--output json` success, emits exactly ONE JSON object (never an array — `status` is single-profile-scoped) with EXACTLY the six keys `profile`, `url`, `env`, `auth_method`, `status`, `oauth_app` (set-equality — no extra keys, none missing). Per the F-1 fix, the object is assembled by a PURE builder function (`status()` calls it after computing its inputs) — the schema/key-set assertion is made by constructing the builder's inputs directly, not by invoking `status()` end-to-end.
**Test:** `test_bc_1_6_050_status_json_full_schema_api_token` (calls the pure JSON-builder directly with constructed inputs). **Test method: DEFAULT CI** (no keychain, no config load — per the F-1 fix).

### AC-002 (traces to BC-1.6.050 postcondition 2, VP-AUTHDX-026)
The `"status"` field is computed via the SAME shared `derive_auth_state` helper `S-cycle7-auth-state-derivation` introduced for `auth list` — never a second, independently-computed value, and never a bare `credentials: bool` field.
**Test:** `test_bc_1_6_050_status_json_status_uses_shared_derivation` (call-site structural regression, mirrors `S-cycle7-auth-state-derivation`'s AC-010). **Test method: DEFAULT CI** (source-scan, no keychain).

### AC-003 (traces to BC-1.6.050 postcondition 3 / BC-1.6.047 postcondition 2a, VP-AUTHDX-026)
`"env"` is VERBATIM/LOSSLESS — the profile's configured `env` string byte-for-byte, `null` when unset — realizing BC-1.6.047's previously-contingent JSON obligation (no sanitization, no truncation; contrast the human-text channel's sanitized `Env:` line, unaffected by this story).
**Test:** `test_bc_1_6_050_status_json_env_verbatim_lossless` (pure JSON-builder, injected `env` values). **Test method: DEFAULT CI**.

### AC-004 (traces to BC-1.6.050 postcondition 4, VP-AUTHDX-026)
`"oauth_app"` KEY is ALWAYS present in the object (never omitted) — `null` when `auth_method != "oauth"`; a real source label (`embedded`/`keychain`/`(none)`, via the existing `peek_oauth_app_source` resolver) when `auth_method == "oauth"`. One test per `auth_method` variant guards the omit-when-null mutant.
**Test:** `test_bc_1_6_050_status_json_oauth_app_present_when_oauth`, `test_bc_1_6_050_status_json_oauth_app_null_when_api_token` (pure JSON-builder, injected `oauth_app` label/`null`). **Test method: DEFAULT CI**.

### AC-005 (traces to BC-1.6.050 postcondition 5 / #526 invariant, VP-AUTHDX-026)
Output is PRETTY-PRINTED and routed through `output::render_json` — never a raw `serde_json::to_string_pretty` call or a compact `json!` `Display`-printed string (the #526 render invariant applies at this new call site).
**Test:** `test_bc_1_6_050_status_json_routes_through_render_json_pretty` (pure JSON-builder output piped through `output::render_json`, no keychain). **Test method: DEFAULT CI**.

### AC-006 (traces to BC-1.6.050 postcondition 6, as revised round 3/round 6, VP-AUTHDX-026)
The existing human-text output (`println!`-based `Profile:`/`Instance:`/`Env:`/`Auth method:`/`Credentials:`/`OAuth app:` lines) is byte-for-byte UNCHANGED IN ALL CASES — for correctly-configured profiles AND for a mismatched-credential-kind profile (BC-1.6.048 EC-1.6.048-2) alike. The pre-existing `Credentials:` check (`method == "oauth" => load_oauth_tokens(...).is_ok() else load_api_token(...).is_ok()`, currently `src/cli/auth/status.rs:144-147`) is preserved literally; only its computed `bool` is now ALSO passed to the pure JSON builder (F-1 fix) for the `"status"` field, satisfying BC-1.6.048 Postcondition 3's single-derivation requirement without reimplementing or altering the text path's own output.
**Test:** `test_bc_1_6_050_status_human_text_byte_for_byte_unchanged` (two fixtures: correctly-configured, and mismatched-kind). **Test method: keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`)** — this test must exercise `status()`'s REAL `println!` output against a real stored (or deliberately mismatched-kind) credential; `load_oauth_tokens`/`load_api_token` have no in-memory injection seam (per VP-AUTHDX-005's own documented coverage-boundary note), so this cannot run in default CI. Not affected by the F-1 fix — the F-1 fix only relocates the JSON-side assembly, not `status()`'s real credential probe.

### AC-007 (traces to BC-1.6.048 postcondition 3, as revised round 6 / VP-AUTHDX-029)
The `auth status` human-text `Credentials:` line agrees with the RAW `matching_kind_present` boolean (the identical kind-specific probe call that also feeds the JSON `"status"` field via the pure builder) — never a value that drifts from its own source probe. This VP does NOT assert the text line equals the 3-state `"status"` value (that would be unsatisfiable — see AC-008).
**Test:** `test_vp_authdx_029_status_text_agrees_with_matching_kind_present`. **Test method: keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`)** — same reasoning as AC-006: this must observe the real probe outcome driving BOTH channels for the same real keychain state, not an injected value.

### AC-008 (traces to BC-1.6.050 EC-1.6.050-4, VP-AUTHDX-029's explicit non-assertion)
For a profile with `url: None` whose stored credential IS present for the configured `auth_method` (e.g. `url` cleared back to unset after a prior successful login), the JSON `"status"` field renders `"unset"` (`derive_auth_state`: `url.is_none()` always wins) while the human-text `Credentials:` line renders `"Credentials: stored in keychain"` (it never reads `url`). This is an INTENTIONAL, documented divergence — the test asserts BOTH observed values explicitly and asserts this is NOT flagged as a failure by VP-AUTHDX-029 (which only compares text vs. `matching_kind_present`, never text vs. `"status"`).
**Test:** `test_bc_1_6_050_ec4_url_none_credential_present_divergence_is_intentional`. **Test method: keyring-gated (`#[ignore]+JR_RUN_KEYRING_TESTS=1`)** — requires a REAL stored matching-kind credential to observe the divergence against the real probe outcome; the JSON-side half (`"status": "unset"`) could be produced by the pure builder alone, but the text-side half (`"Credentials: stored in keychain"`) requires `status()`'s real `println!` path, so the whole fixture stays keyring-gated for reviewer proximity with AC-006/AC-007 rather than being split.

### AC-009 (traces to BC-1.6.050 EC-1.6.050-1, tie-in to VP-AUTHDX-028 from `S-cycle7-credential-absence-fix`)
`jr auth status --output json --profile <unknown>` emits the STANDARD `{"error": "...", "code": 64}` envelope — never this story's 6-key success object. The pre-existing exit-64 unknown-profile check (BC-1.1.004, unchanged this cycle) fires BEFORE any output-format-specific success-schema code path — and therefore BEFORE any keychain probe — is reached, regardless of `--output json` being set.
**Test:** `test_bc_1_6_050_ec1_unknown_profile_json_still_standard_error_envelope`. **Test method: DEFAULT CI** (the unknown-profile check fires before any credential probe, so no keychain backend is needed).

### AC-010 (traces to BC-1.6.050 EC-1.6.050-2)
Fresh install, zero profiles configured, no explicit `--profile`, `--output json` supplied → the existing early-return ("No profiles configured. Run `jr init`...") remains human-text-only on stderr with exit 0 and NO stdout JSON. This story does NOT introduce a new JSON shape (e.g. `{}` or `null`) for this state — explicitly out of scope, per BC-1.6.050's own framing.
**Test:** `test_bc_1_6_050_ec2_fresh_install_no_json_output`. **Test method: DEFAULT CI** (zero profiles means no keychain probe is ever reached).

### AC-011 (traces to BC-1.6.050 invariant 1)
`status --output json`'s object and `list --output json`'s per-profile object use the SAME field names for every field they share (`url`, `env`, `auth_method`, `status`) — a script/agent that already parses one already knows how to read the shared fields of the other.
**Test:** `test_bc_1_6_050_json_field_names_match_list_json` (schema-key comparison, not a full-value comparison — compares the pure JSON builder's key set against `render_list_json`'s key set using injected/dummy inputs on both sides). **Test method: DEFAULT CI**.

### AC-012 (traces to BC-1.6.050 invariant 2, NFR-O-N retirement doc-fallout)
`CLAUDE.md`'s standing NFR-O-N gotcha entry (`"auth status has no --output json support (NFR-O-N: deferred; ... src/cli/auth/status.rs::status() writes human text only via println!)"`) is updated in the SAME burst that ships this code — either removed outright or corrected to state the gap is closed, per the BC-1.4.034 same-burst doc-fallout precedent. The SEPARATE, pre-existing-blocked `nfr-catalog.md` row-text edit (TD-031 stable-anchor debt, unrelated to this cycle's diff) remains explicitly DEFERRED and is NOT attempted by this story — it is a carried-forward maintenance-sweep task per `cycle-007-prd-delta.md` §7, not a blocker for this story's own completion.
**Test:** N/A (doc artifact; verified by PR review, not a `#[test]`)

### AC-013 (traces to BC-1.6.050 postcondition 2 / BC-1.6.048 postcondition 2 "Preferred implementation shape"; NEW — F3 adversary pass-1, finding F-1: JSON-builder purity / default-CI coverage confirmation)
The 6-key JSON object assembly is a PURE function (implementer's naming choice, e.g. `build_status_json`) taking `profile`, `url`, `env`, `auth_method`, `matching_kind_present: bool`, and `oauth_app` as plain arguments — it performs NO keychain access, NO config load, and calls `derive_auth_state` exactly the way `S-cycle7-auth-state-derivation`'s renderers do (same shared helper, same "precomputed input in, formatted value out" shape). `status()` itself remains the effectful caller: it computes `matching_kind_present` via the SAME single kind-specific probe call that already drives the human-text `Credentials:` line (never a second, duplicate probe — AC-002/AC-007's own invariant), then passes it to this pure builder. This closes the F-1 gap under which AC-001/AC-003/AC-004/AC-005/AC-011's schema/field tests were previously reachable only by invoking `status()` end-to-end.
**Test:** `test_bc_1_6_050_json_builder_is_probe_free` (source-scan mirroring `S-cycle7-auth-state-derivation`'s AC-004/AC-014 pattern) PLUS a PR-time confirmation that AC-001/AC-003/AC-004/AC-005/AC-009/AC-010/AC-011's test functions carry no `#[ignore]` attribute and need no `JR_RUN_KEYRING_TESTS` env var (Task 14 below). **Test method: DEFAULT CI**.

## Mutation Testing Scope — `probe_matching_kind_credential` / `peek_oauth_app_source` Exclusion (F3 adversary pass-3, MED-1)

**Problem this section closes:** Task 15 adds whole-file `src/cli/auth/status.rs`
to `.cargo/mutants.toml` `examine_globs`. Without scoping, that would report
every mutant inside this story's real kind-specific credential probe (the
inline `creds_ok` match at `status.rs:144-147`, EXTRACTED per this fix into
a named function — see Task 11 below) and inside the pre-existing
`peek_oauth_app_source()` (`status.rs:36-49`, which calls
`try_load_oauth_app_credentials()`, a real keychain read) as MISSED/survived
under `cargo mutants --in-diff` on this story's own PR gate. AC-013's F-1
purity split already correctly isolated the pure 6-key JSON-builder from
this probe (that part IS fully default-CI-testable, per AC-001/003/004/005/
009/010/011/013) — MED-1 closes the gap for the probe CALL SITES themselves,
which AC-006/AC-007/AC-008 exercise only under
`#[ignore]+JR_RUN_KEYRING_TESTS=1` (no in-memory injection seam exists for
`load_oauth_tokens`/`load_api_token`/`try_load_oauth_app_credentials` —
VP-AUTHDX-005/006's own documented coverage boundary, the identical
precedent Story A's and B1's own exclusions cite).

**Scope decision:** exclude TWO named functions in `status.rs`:
1. `probe_matching_kind_credential(profile: &Profile, auth_method: &str) ->
   bool` (NEW — the `creds_ok` match extracted into its own function per
   Task 11, so it can be file+function-name anchored; this function is
   file-local to `status.rs` and independent of `S-cycle7-auth-state-
   derivation`'s identically-named `list.rs` function — the two are NOT
   shared code, each file owns its own copy, consistent with this story
   NOT depending on `list.rs` for anything beyond the shared
   `derive_auth_state` helper).
2. `peek_oauth_app_source` (PRE-EXISTING, unmodified by this story) — its
   pure sibling `peek_oauth_app_source_for_test` remains fully
   default-CI-tested (`src/cli/auth/tests/mod.rs:1029-1106`) and is
   explicitly NOT excluded; only the impure wrapper is.

Both functions are genuinely untestable in default CI — excluding them is
what makes whole-file `status.rs` in `examine_globs` an HONEST coverage
signal for `build_status_json`, `derive_auth_state`'s call site (AC-002),
and the rest of this story's own default-CI-tested diff, rather than a
partially-false one.

**Exact `.cargo/mutants.toml` diff (append to the existing `exclude_re`
array, after Story A's and B1's entries):**

```toml
# JUSTIFIED EXCLUSION (S-cycle7-auth-status-json, F3 adversary pass-3,
# finding MED-1) — mirrors Story A's load_api_token and
# S-cycle7-auth-state-derivation's probe_matching_kind_credential
# exclusion designs (file+function-name anchored, two-shape). See
# docs/specs/cargo-mutants-policy.md §Exclusions / FIX-F6-A.
#
# `probe_matching_kind_credential` (src/cli/auth/status.rs) — the real
# load_oauth_tokens/load_api_token probe status() performs — and
# `peek_oauth_app_source` (pre-existing, calls
# try_load_oauth_app_credentials, a real keychain read) have no in-memory
# injection seam. AC-006/007/008's tests exercise them only via
# #[ignore]+JR_RUN_KEYRING_TESTS=1; the pure sibling
# peek_oauth_app_source_for_test is fully default-CI-tested and is NOT
# covered by this exclusion.
#
# VERIFY BEFORE LANDING: run `cargo mutants --file src/cli/auth/status.rs
# --list` against the POST-implementation code and confirm every listed
# mutant in these two functions matches one of the four regexes below, and
# no mutant belonging to `build_status_json`, `status()`'s own dispatch
# body, or `peek_oauth_app_source_for_test` is inadvertently matched.
'^src/cli/auth/status\.rs:\d+:\d+: replace probe_matching_kind_credential .*$',
'^src/cli/auth/status\.rs:\d+:\d+: .+ in probe_matching_kind_credential$',
'^src/cli/auth/status\.rs:\d+:\d+: replace peek_oauth_app_source .*$',
'^src/cli/auth/status\.rs:\d+:\d+: .+ in peek_oauth_app_source$',
```

These four lines are appended INTO the existing `exclude_re = [...]` array,
not a second array.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `status()` (`&OutputFormat` threading + effectful dispatch) | `src/cli/auth/status.rs` | Effectful-shell (calls `probe_matching_kind_credential` once, passes its `bool` to both the text branch and the pure JSON builder) |
| `probe_matching_kind_credential` (NEW; F3 adversary pass-3 finding MED-1 — extracted from the inline `creds_ok` match) | `src/cli/auth/status.rs` | Effectful-shell (invokes `load_oauth_tokens`/`load_api_token`) — the one genuinely untestable-in-default-CI residual this story's own diff introduces; `exclude_re`'d per the Mutation Testing Scope section above |
| `peek_oauth_app_source` (PRE-EXISTING, unmodified) | `src/cli/auth/status.rs` | Effectful-shell (invokes `try_load_oauth_app_credentials`) — pre-existing residual, newly brought into `examine_globs` scope by this story's Task 15; `exclude_re`'d alongside `probe_matching_kind_credential` |
| JSON object builder (NEW; F3 adversary pass-1 finding F-1, mirrors `S-cycle7-auth-state-derivation`'s renderer split) | `src/cli/auth/status.rs` (e.g. `build_status_json`, implementer's naming choice) | Pure-core (REVISED, F-1 fix) — takes `matching_kind_present`/`url`/`env`/`auth_method`/`oauth_app` as plain arguments, calls `derive_auth_state`, performs NO keychain access or config load |
| `derive_auth_state` (consumed, not modified) | `src/api/auth.rs` (owned by `S-cycle7-auth-state-derivation`) | Pure-core |
| `main.rs::AuthCommand::Status` dispatch | `src/main.rs` | Effectful-shell (thin parameter-threading change only) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-1.6.050-1 | `jr auth status --output json --profile <unknown>` | Standard `{"error": ..., "code": 64}` envelope, never this BC's success object (AC-009) |
| EC-1.6.050-2 | Fresh install, zero profiles, no explicit `--profile`, `--output json` | Unchanged early-return behavior, no stdout JSON (AC-010) |
| EC-1.6.050-3 | A backend keychain error collapses to `.is_ok() == false` (OBS-PB-1, out of scope this cycle) | `"status"` renders `"no-credentials"` identically to ordinary absence, NO stderr warning; JSON object still printed in full |
| EC-1.6.050-4 | `url: None` with matching-kind credential present | Machine `"status"`: `"unset"`; text `Credentials:`: "stored in keychain" — intentional divergence (AC-008) |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `status()`'s JSON object construction (extracted, F-1 fix) | pure-core | Field assembly from already-resolved `profile`/`url`/`env`/`auth_method`/`matching_kind_present`/`oauth_app` values is a pure `serde_json::json!` build, now lifted into its own standalone function taking those values as plain parameters — no IO, directly unit-testable with injected inputs in DEFAULT CI |
| `probe_matching_kind_credential` (NEW, MED-1) | effectful-shell | The real `load_oauth_tokens`/`load_api_token` invocation, extracted from the inline `creds_ok` match so it can be `exclude_re`'d by file+function name; no in-memory injection seam — `status()` computes `matching_kind_present` ONCE by calling this and feeds both the text branch and the pure JSON builder from it |
| `peek_oauth_app_source` (pre-existing, unmodified) | effectful-shell | Reads the OS keychain via `try_load_oauth_app_credentials`; no in-memory injection seam. Its pure sibling `peek_oauth_app_source_for_test` remains default-CI-tested and unaffected |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~5,200 |
| Referenced code files (`src/cli/auth/status.rs` full file, `src/main.rs` dispatch region, `src/output.rs::render_json`, `S-cycle7-auth-state-derivation`'s `derive_auth_state`) | ~6,000 |
| Test files (pure-JSON-builder default-CI tests, keyring-gated human-text regression tests, purity source-scan) | ~5,800 |
| Tool outputs overhead (cargo test/clippy runs, grep) | ~3,500 |
| **Total** | **~20,500** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~10%** |

Well under the 20-30% threshold — no split needed.

## Tasks

1. [ ] Confirm `S-cycle7-auth-state-derivation`'s `derive_auth_state` is merged/available before starting (dependency precondition)
2. [ ] Write failing tests for AC-001 through AC-005 (JSON schema, shared-derivation call-site, `env` verbatim, `oauth_app` presence, `render_json` routing) — calling the pure JSON-builder function DIRECTLY with constructed inputs, per the F-1 fix — `test-writer`
3. [ ] Write failing test for AC-006 (human-text byte-for-byte-unchanged regression, two fixtures — KEYRING-GATED, real `status()` invocation) — `test-writer`
4. [ ] Write failing tests for AC-007/AC-008 (VP-AUTHDX-029 text-vs-`matching_kind_present` agreement + the EC-1.6.050-4 intentional-divergence worked example — KEYRING-GATED, real `status()` invocation) — `test-writer`
5. [ ] Write failing tests for AC-009/AC-010 (unknown-profile JSON envelope, fresh-install no-JSON — DEFAULT CI, no keychain touched on these paths) — `test-writer`
6. [ ] Write failing test for AC-011 (field-name parity with `list --output json`, pure builder vs. `render_list_json`, DEFAULT CI) — `test-writer`
7. [ ] Write failing test for AC-013 (F-1: JSON-builder purity source-scan) — `test-writer`
8. [ ] Verify Red Gate: all new tests fail against current `status()` (no `&OutputFormat` param, `println!`-only, no JSON builder)
9. [ ] Implement: add `&OutputFormat` parameter to `status()`; thread from `main.rs`'s `AuthCommand::Status` dispatch call site — `implementer`
10. [ ] Implement: extract the 6-key JSON object assembly into a PURE builder function taking `profile`/`url`/`env`/`auth_method`/`matching_kind_present`/`oauth_app` as plain arguments and calling `derive_auth_state` — NO keychain access, NO config load inside the builder (F-1 fix) — `implementer`
11. [ ] Implement: extract the existing inline `creds_ok` match (`status.rs:144-147`) into a small NAMED function `probe_matching_kind_credential(profile: &Profile, auth_method: &str) -> bool` (F3 adversary pass-3, MED-1 — named specifically so it can be `exclude_re`'d by file+function name, mirroring Story A's and B1's design). `status()` calls this ONCE — the SAME single kind-specific probe call the human-text `Credentials:` check already performs — do not duplicate the probe call; compute `matching_kind_present` once and feed both the text branch AND the pure JSON builder (Task 10) from it — `implementer`
12. [ ] Confirm the human-text `println!` lines themselves are BYTE-FOR-BYTE untouched (diff review — only the surrounding function signature/control flow changes, never the format strings)
13. [ ] Update `CLAUDE.md`'s NFR-O-N gotcha entry in the SAME burst (AC-012)
14. [ ] F-1 closure verification: confirm AC-001/AC-003/AC-004/AC-005/AC-009/AC-010/AC-011/AC-013's test functions carry NO `#[ignore]` attribute and require no `JR_RUN_KEYRING_TESTS` env var — run `cargo test` (default, no flags/env) and confirm all of them execute and pass; confirm AC-006/AC-007/AC-008 remain correctly keyring-gated (NOT accidentally left running in default CI against an unavailable real keychain, and NOT silently skipped without the `#[ignore]` marker)
15. [ ] Add `src/cli/auth/status.rs` to `.cargo/mutants.toml` `examine_globs`. **Ownership reconciliation (F3 adversary pass-3, MED-1, supersedes the earlier "if not already added by B1" hedge):** this story owns `status.rs`'s `examine_globs` entry EXCLUSIVELY — `S-cycle7-auth-state-derivation` (B1) no longer adds `status.rs` (see B1's own revised Task 14), and `S-cycle7-credential-absence-fix` (A) never added it (see A's own revised Task 10). No "confirm rather than duplicate" check is needed for THIS file; `status.rs` is not present in `examine_globs` until this story's PR lands.
15a. [ ] **(F3 adversary pass-3, MED-1)** In the SAME commit as Task 15's `examine_globs` addition, append the four `probe_matching_kind_credential`/`peek_oauth_app_source`-scoped `exclude_re` entries specified in this story's "Mutation Testing Scope" section above to `.cargo/mutants.toml`'s `exclude_re` array, together with that section's justification comment. Run the section's "VERIFY BEFORE LANDING" dry-run check before the PR is opened. `build_status_json`, `derive_auth_state`'s call site, and `peek_oauth_app_source_for_test` remain fully default-CI-testable and MUST NOT be swept into this exclusion.
16. [ ] Add a CHANGELOG entry under `[Unreleased] > Added` describing the new `auth status --output json` support, before creating the PR

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|----------------------|
| S-cycle7-auth-state-derivation (this cycle, Wave 1, HARD DEPENDENCY) | Introduced `derive_auth_state(url, matching_kind_present: bool) -> AuthState` and the caller-side kind-specific probe selection rule this story reuses verbatim — no redesign | Compute `matching_kind_present` ONCE per profile via the kind-specific probe, then feed it to `derive_auth_state`; never call `probe_stored_credential_kind` for this purpose | `derive_auth_state` is PURE and takes a plain `bool`, not `Result<bool>` — a `Result`-typed signature was drafted and explicitly REJECTED at F2 (see that story's Architecture Compliance Rules) |
| S-cycle7-auth-state-derivation (F3 adversary pass-1, finding F-1) | Established the "effectful probe in the handler, pure formatter takes the precomputed value" split for `list.rs`'s renderers — this story's JSON builder follows the identical split | Extract the pure formatting/construction step into its own function taking plain arguments; keep the ONE real keychain probe call in the effectful caller and feed its result to both the pure step and any other consumer (here: the text branch) | The temptation is to leave probing inline "since we're already computing it here for the text line" — resist it; a probe call embedded inside a formatter/builder function is exactly what makes that function's tests unable to run in DEFAULT CI |
| S-cycle3-env-tag (cycle-003) | Established `render_list_json`'s per-profile JSON object shape this story's schema is modeled on (F1 §5.3 recommendation) | Field-name reuse across `list`/`status` JSON (`url`/`env`/`auth_method`/`status`) for script/agent consistency | N/A |
| S-cycle4-honest-fail-message (cycle-004) | Established the "the human-text channel's existing output must not change" discipline for a re-sourced internal check | A construction-site-only change (re-routing through a shared helper) can be verified as "no behavior change" by asserting literal output bytes are identical before/after, not just by code review | The temptation to describe a re-sourcing as a "correction" when the output is actually unchanged is a real, repeated F2 defect class in THIS cycle (see BC-1.6.050's round-3/F6 fix) — phrase Task/PR descriptions carefully to avoid repeating it |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| The human-text `Credentials:` line's literal PRINTED output must not change, for any profile shape, including mismatched-kind | BC-1.6.050 Postcondition 6 (as revised round 3/6) | AC-006; the implementer must NOT alter the `println!("Credentials: ...")` format strings or branch structure — only the SOURCE of the `bool` feeding that branch may be re-routed through a shared computation |
| The JSON `"status"` field and the text `Credentials:` line must derive from the SAME single kind-specific probe call per profile — never two separate probe invocations | BC-1.6.048 Postcondition 3 (as revised round 6) | AC-002/AC-007; a mutant/refactor introducing a second probe call for one channel is a spec violation even if both calls would return the same value in practice |
| `--output json` is a PURELY ADDITIVE alternate path — it must never suppress, alter, or gate the pre-existing default text output's own logic | BC-1.6.050 Postcondition 6 | AC-006; the `&OutputFormat` parameter selects WHICH channel is printed, it does not change what either channel prints |
| Output must route through `output::render_json`, never a raw `serde_json` call | #526 JSON render invariant (project-wide, CLAUDE.md) | AC-005 |
| The 6-key JSON object builder must be PURE — no keychain access, no config load; `status()` computes `matching_kind_present`/`url`/`env`/`auth_method`/`oauth_app` and passes them in as plain arguments | F3 adversary pass-1 finding F-1 (this story's own implementation-shape fix, mirroring `S-cycle7-auth-state-derivation`'s renderer split) | AC-001, AC-003, AC-004, AC-005, AC-011, AC-013; a mutant/refactor that reintroduces a keychain or config call inside the builder is a spec violation |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `serde_json` | Per `Cargo.toml` pin (existing dependency, unchanged) | JSON object construction (`serde_json::json!`) |
| `assert_cmd` | Per `Cargo.toml` pin (existing dev-dependency, unchanged) | CLI/JSON-shape integration assertions |

No new library is introduced — this story reuses the exact tools/versions already pinned in `Cargo.toml`.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/cli/auth/status.rs` | modify | `&OutputFormat` parameter; extract a PURE 6-key JSON-object-builder function (F-1 fix); extract the inline `creds_ok` match into a NAMED `probe_matching_kind_credential` function (MED-1) so it also feeds that builder |
| `src/main.rs` | modify | Thread `&cli.output` (or `cli.output`) into the `AuthCommand::Status` dispatch call site (`~line 277-279`) |
| `CLAUDE.md` | modify | Update/remove NFR-O-N gotcha entry (Task 13/AC-012) |
| `src/cli/auth/tests/mod.rs` (inline `#[cfg(test)] mod`, matching the `list_table_snapshot`/`list_json_shape` precedent at `src/cli/auth/tests/mod.rs:519`/`:526`) | modify | **(F3 adversary pass-4, LOW-1 — corrects the destination previously given below)** AC-011's field-name-parity test — it calls the pure JSON-builder AND `render_list_json` DIRECTLY as `pub(crate)` symbols with injected/dummy inputs, which CANNOT compile from the `tests/` integration crate. MUST be inline. |
| `tests/` (existing `tests/auth_profiles.rs` or a new file, implementer's judgment) | modify or create | DEFAULT-CI pure-JSON-builder unit tests (AC-001/003/004/005/009/010/013) + KEYRING-GATED human-text regression/integration tests (AC-006/007/008) |
| `.cargo/mutants.toml` | modify | Add `src/cli/auth/status.rs` to `examine_globs` (Task 15, owned exclusively by this story); append the `probe_matching_kind_credential`/`peek_oauth_app_source` `exclude_re` entries (Task 15a, MED-1) |
| `CHANGELOG.md` | modify | `[Unreleased] > Added` entry (Task 16) |
