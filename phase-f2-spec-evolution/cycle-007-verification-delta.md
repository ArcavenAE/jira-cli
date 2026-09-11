---
document_type: f2-verification-delta
phase: phase-f2-spec-evolution
producer: formal-verifier
cycle: cycle-007-auth-correctness-dx
feature: "auth-correctness-dx"
status: complete
timestamp: 2026-09-10
project: jira-cli
mode: BROWNFIELD
intent: feature
inputs:
  - ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/prd/edge-case-catalog.md"
  - ".factory/specs/prd/error-taxonomy.md"
  - ".factory/phase-f1-delta-analysis/cycle-007-auth-delta-analysis.md"
  - ".factory/phase-f1-delta-analysis/issue-triage-auth-cluster-2026-09-10.md"
vp_count_before: 77
vp_count_after: 82
vp_count_basis: >
  STATE.md tracks 76 VPs at the F1-gate burst. The product-owner already minted
  VP-AUTHDX-024 (BC-1.6.048, present in bc-1-auth-identity.md) for the shared
  vocabulary parity invariant, taking the running total to 77 BEFORE this delta.
  This delta allocated 4 (VP-AUTHDX-025..028), taking the total to 81; the
  cycle-007 F2-M1 adversary-finding follow-on (see §7) adds ONE more,
  VP-AUTHDX-029 (BC-1.6.048 Postcondition 3, the `auth status` HUMAN-TEXT third
  channel), taking the total to 82. The "before: 77 / after: 82" figures are
  stated on STATE's tracked basis for continuity; state-manager reconciles
  STATE.md's VP count to 82 at F2 close.
new_vps:
  - VP-AUTHDX-025
  - VP-AUTHDX-026
  - VP-AUTHDX-027
  - VP-AUTHDX-028
  - VP-AUTHDX-029
confirmed_vps:
  - VP-AUTHDX-024
updated_vps: []
related_bcs:
  - BC-1.6.048
  - BC-1.6.049
  - BC-1.6.050
  - BC-1.4.032
  - BC-1.4.033
  - BC-1.4.034
  - BC-1.1.004
input-hash: "fc636d3"
---

# Verification Delta — cycle-007 `auth-correctness-dx`

Companion to `.factory/phase-f2-spec-evolution/cycle-007-prd-delta.md`. This is
the F2 Step-4 (formal-verifier) output: it OWNS the final VP-id assignment for
the cycle and defines the proof strategy + test mechanism for each new VP.

The cycle's PRD delta authored 3 new BCs (BC-1.6.048/049/050) + amended 3
(BC-1.4.032/033/034) + resolved BC-1.6.047's contingency, and the product-owner
already minted **VP-AUTHDX-024** (the `auth list`/`auth status` vocabulary-parity
SAFETY INVARIANT, on BC-1.6.048). This delta allocates the remaining, per-BC
dedicated verification properties the amended/new BCs need beyond that shared
parity invariant.

---

## 1. VP-ID Reconciliation (own the sequence)

**Continue the `VP-AUTHDX-NNN` sequence from 025.** VP-AUTHDX-024 is the highest
existing id in the `AUTHDX` scope (minted by the product-owner on BC-1.6.048).
This delta allocates the next four contiguous ids:

| New VP | Primary BC | Issue(s) | Surface pinned (one-line) |
|--------|-----------|----------|---------------------------|
| **VP-AUTHDX-025** | BC-1.6.049 | #788 | `auth list` STATUS is a real credential PROBE, not `url.is_some()` |
| **VP-AUTHDX-026** | BC-1.6.050 | #787 | `auth status --output json` full 6-key schema, routed through `output::render_json` |
| **VP-AUTHDX-027** | BC-1.4.032 + BC-1.4.033 | #784 + #786 | recovery command PARSES against clap **and** credential-absence exits **2** at both `auth.rs` sites |
| **VP-AUTHDX-028** | BC-1.1.004 (NEGATIVE pin) | #786 | unknown-profile stays exit **64** — the two failure classes stay distinct |

The sequence is dense and contiguous: `024..028`, every id used, none skipped,
none reused.

**Collision check.** A repo-wide grep for `VP-AUTHDX-025`/`026`/`027`/`028`
returns NO pre-existing match anywhere in the tree — these ids are unallocated.
The `AUTHDX` scope is the collision firewall (all cycle-003/004/007 auth VPs use
it); a new `VP-AUTHDX-NNN` id cannot collide with any `VP-674-*`/`VP-571-*`/
`VP-396-*` issue-scoped id. This delta does NOT attempt to resolve the open,
non-blocking `VP-COUNT-RECONCILIATION` follow-up — it only guarantees the four
new ids are firewalled by contiguity within the `AUTHDX` scope.

**VP total handoff to state-manager:** 76 (STATE baseline) → 77 (VP-AUTHDX-024,
product-owner) → 81 (VP-AUTHDX-025..028, this delta) → **82** (VP-AUTHDX-029, the
cycle-007 F2-M1 follow-on, §7 below). State-manager sets STATE.md's VP count to
**82** at F2 close.

---

## 2. Registration Surface & Propagation

**This project has no `VP-INDEX.md` and no `verification-architecture/`
directory** (`find` confirmed — the only `ARCH-INDEX.md` is
`.factory/specs/architecture/ARCH-INDEX.md`, an ADR + subsystem registry that
indexes ZERO VPs: `grep -c "VP-" .factory/specs/architecture/ARCH-INDEX.md`
returns `0`). Per the standing Project Convention (documented in
`verification-delta-398.md` §"Project Convention Note", reaffirmed in
`verification-delta-571.md` and `verification-delta-674.md` §2), VPs are
registered **inline** as `**Verification Properties**:` subsections within the
BC bodies, plus their authoritative allocation record in this delta.

**ARCH-INDEX.md — NO CHANGE (documented no-op).** It tracks no verification
subsystem and no VP ids; adding a VP row would fabricate a structure the repo
does not use. The verification subsystem for the auth surface is SS-02 (CLI
Layer, `src/cli/auth/`) / SS-08-equivalent (`src/api/auth.rs`) per the existing
Subsystem Registry; no new subsystem is introduced by this cycle.

**No VP-count frontmatter surface, no VP guard script** (pre-confirmed by the
orchestrator and re-verified: no BC file frontmatter carries a `total_vps`
field — only `total_bcs`/`definitional_count`; `scripts/check-spec-counts.sh`
and `check-bc-cumulative-counts.sh` govern BC counts only). VP counts live
exclusively in STATE.md (state-manager reconciles) and this delta. No
count-guard is affected by these four allocations.

**Inline BC-body citation handoff (attempted this pass).** BC-1.6.049 and
BC-1.6.050 currently state "None uniquely dedicated to this BC beyond
VP-AUTHDX-024"; that wording predates this delta. The formal-verifier now
dedicates VP-AUTHDX-025 to BC-1.6.049 and VP-AUTHDX-026 to BC-1.6.050, and adds
VP-AUTHDX-027/028 to the BC-1.4.032/033/1.1.004 surfaces. If a stable-anchor or
count-propagation hook blocks a given BC-body edit (the cycle-007 PRD-delta pass
already reported `validate-count-propagation` firing repeatedly and a
stable-anchor block on `nfr-catalog.md`), the citation is recorded HERE as the
authoritative allocation and the BC-body add is left as a product-owner handoff
— see §6 for the exact per-file outcome. The delta doc is authoritative for
allocation regardless of the inline-citation outcome (same model as
verification-delta-674 §2).

---

## 3. Verification Toolchain In Scope (and the Kani/cargo-fuzz Justified-Skip)

**In scope for this cycle:**
- **example-based / injected-fixture `#[test]` unit tests** for the PURE
  three-state derivation logic (`derive_auth_state` and its call sites) — runs in
  DEFAULT CI with an injected `matching_kind_present: bool` outcome, no
  keychain needed (per VP-AUTHDX-024's already-stated coverage boundary). The
  `auth_method`-matching that selects WHICH credential kind to probe lives in the
  CALLER; the pure function receives the already-computed boolean.
- **clap round-trip unit test** for "the suggested recovery command parses" —
  parse the literal remediation string through `AuthCommand`'s derive surface
  (`Cli::try_parse_from`) and assert it resolves to `AuthCommand::Login { profile:
  Some(_), .. }` with exit-code 0 from the parser (not clap's exit-2 usage
  error). This is the exact mechanism the F1/PRD delta calls out: #784's whole
  defect is that the OLD positional `jr auth login {profile}` string did NOT
  parse (`profile` is `#[arg(long)]`-only), so the remediation was itself broken.
- **CLI/exit-code integration tests** (`tests/`, `assert_cmd`-style with the
  `JR_*` debug seams) for the credential-absence exit-2 sites and the
  unknown-profile exit-64 negative pin, plus JSON-shape assertions for
  `auth status --output json`.
- **cargo-mutants** on the delta diff (the F4 story adds the new
  `derive_auth_state` helper + the `status.rs` JSON builder to
  `.cargo/mutants.toml` §examine_globs if not already covered by the
  `src/cli/auth/`/`src/api/auth.rs` globs — an F4 checkpoint, see §5).

**Kani / cargo-fuzz — JUSTIFIED-SKIP (0-GAP), per the cycle-002/003/004/005
precedent (STATE.md Skip Log; verification-delta-674 §3).** This project has
NEVER provisioned Kani or a cargo-fuzz harness for any module (confirmed: no
`kani`/`kani-verifier` crate in `Cargo.toml`, no `fuzz/` directory). The
established substitution applies directly here, and this cycle is an even weaker
Kani/fuzz candidate than cycle-005:
- **No new pure arithmetic/overflow/OOB surface.** The only new pure logic is
  `derive_auth_state(url: Option<Url>, matching_kind_present: bool) ->
  AuthState`: a total, PURE function to a 3-value enum. The `matching_kind_present`
  boolean means "a stored credential of the kind MATCHING the profile's configured
  `auth_method` is present" — the CALLER computes it via the kind-specific probe
  (`auth_method == oauth` → `load_oauth_tokens().is_ok()`; `api_token` →
  `load_api_token().is_ok()`, the same check `status.rs`'s text path already
  performs) and passes the outcome in; the `auth_method`-matching lives in the
  CALLER, never inside `derive_auth_state`. There is no `unsafe`, no arithmetic,
  no array indexing — the defect classes Kani is strongest at are absent.
- **The state space is TINY and FINITE, not a candidate for a bounded model
  checker.** `derive_auth_state`'s entire input domain is exactly two dimensions —
  `{url: None, Some} × {matching_kind_present: true, false}` = four
  equivalence classes. (`auth_method` is NOT a third input dimension of the pure
  function: the caller has already collapsed it into which probe produced
  `matching_kind_present`, so the truth table the pure function maps is
  `(url, matching_kind_present) → AuthState`.) An EXHAUSTIVE example-based test
  enumerates the whole domain — there is nothing for Kani's symbolic exploration
  to add over an enumerated `#[test]`; the "universal property" IS the finite
  four-class truth table.
  - **Two-state (not three-way) domain — OBS-PB-1.** `matching_kind_present` is a
    `bool`, not a `Result<bool>`: the shipped caller computes it via
    `load_oauth_tokens().is_ok()`/`load_api_token().is_ok()`, and `load_*` collapse
    BOTH credential-absence AND keychain backend-error into `Err` (→ `.is_ok()` =
    `false`). There is therefore no realizable `Err`/fail-closed third arm to model
    — an `Ok(false)`/`Err` split would be dead code in production. Distinguishing a
    keychain BACKEND ERROR from credential-absence is OUT OF SCOPE for cycle-007
    (tracked as standing item OBS-PB-1); cycle-007 preserves the shipped `.is_ok()`
    behavior, so the pure domain is exactly the four classes above.
- **The correctness-critical claims are EFFECTFUL** (does `auth list` actually
  probe? does `--output json` route through `render_json`? does the process exit
  2 vs 64? does the suggested string parse?) — all observable only through the
  CLI boundary / clap parser / HTTP-free keychain probe, entirely out of
  Kani/fuzz reach.
- **Fuzzing's value (crash-finding on untrusted bytes) is N/A** — there is no new
  untrusted-byte parsing surface in this cycle (auth-state derivation consumes
  already-parsed config + a boolean probe, not raw input).

**0-GAP statement:** skipping Kani and cargo-fuzz introduces NO coverage gap
relative to this cycle's BC set, because every correctness claim in
BC-1.6.048/049/050 and BC-1.4.032/033 is either (a) a FINITE truth table fully
enumerated by an example test (the pure derivation), (b) an effectful CLI/exit-
code/parse behavior only observable through the process boundary
(assert_cmd/clap/wiremock, out of Kani/fuzz reach entirely), or (c) a keyring-
gated real-backend scenario (already covered by VP-AUTHDX-024's coverage-
boundary clause + VP-AUTHDX-005/006/007's established `JR_RUN_KEYRING_TESTS=1`
pattern). This is a documented substitution, not an omission.

---

## 4. New Verification Properties

### VP-AUTHDX-025 — `auth list` STATUS is a real credential PROBE, not `url.is_some()`
**Primary BC**: BC-1.6.049 (#788). **Realizes**: BC-1.6.048's vocabulary for the
`list` call site specifically.
**Technique**: example-based / injected-fixture `#[test]` for the pure
derivation + call-count assertion (DEFAULT CI, no keychain — the probe is
injected/mocked). Complements VP-AUTHDX-024 (which pins that `list` and `status`
AGREE); this VP pins that `list`'s value is DERIVED FROM THE PROBE at all —
i.e. it is not the old URL-only ternary.
**Property**:
1. **Differential (the #788 defect, killed directly):** a profile with
   `url: Some(_)` AND the kind-specific matching-kind-present probe
   (`load_oauth_tokens`/`load_api_token`, selected by `auth_method` per
   BC-1.6.048 Postcondition 2) yielding `matching_kind_present = false` —
   INCLUDING the mismatched-kind case (an `oauth`-method profile holding ONLY a
   stored api-token pair → the matching OAuth kind is absent →
   `matching_kind_present = false`) — renders
   **`no-credentials`**, NOT `configured` — in BOTH `render_list_table`'s STATUS
   column and `render_list_json`'s `"status"` field. A mutant reverting either
   renderer to `url.is_some()`-only would render `configured` for this fixture
   and FAIL this assertion. Contrast anchor: the same profile with the matching
   kind present (`matching_kind_present = true`) → `configured`; `url: None` →
   `unset`. Because the
   probe is KIND-SPECIFIC (not existence-only), this differential oracle DOES
   distinguish the mismatched-kind case (oauth-method + api-token-only →
   not-configured) — an existence-only `profile_has_stored_credentials` probe
   would wrongly report that profile as `configured`; this VP therefore pins the
   corrected kind-specific derivation, matching BC-1.6.048 Postcondition 2 and §3.
2. **Conditional-probe call-count (BC-1.6.049 Postcondition 4 / Invariant 1):**
   `auth list` against N profiles issues AT MOST N kind-specific matching-kind
   probe calls (`load_oauth_tokens`/`load_api_token`) — exactly one per
   `url.is_some()` profile, and ZERO for any `url: None` profile (never probed).
   Assert the kind-specific matching-kind probe is invoked exactly K times where
   K = count of URL-present profiles, over a mixed N-profile fixture spanning all
   three states.
3. **Both renderers use the SAME vocabulary (Invariant 2):** the table and JSON
   paths never diverge on the value set — asserted structurally by both calling
   the shared derivation helper (tie-in to VP-AUTHDX-024's call-site regression
   test; this VP does not re-prove parity, it proves the value is probe-derived).
**Suggested names**: `test_bc_1_6_049_list_status_derives_from_probe_not_url`
(differential), `test_bc_1_6_049_list_probes_at_most_once_per_url_profile`
(call-count). **F6 target**: `src/cli/auth/list.rs::render_list_table` /
`render_list_json`; shared helper in `src/api/auth.rs`.
**EC coverage**: EC-1.6.049-1 (legacy-flat-only → `no-credentials`, via the
BC-1.4.032 no-copy probe exclusion), EC-1.6.049-2 (a backend probe error
collapses to `no-credentials` with NO stderr warning — cycle-007 preserves the
shipped `.is_ok()` behavior; the backend-error-vs-absence distinction is OBS-PB-1,
out of scope).

### VP-AUTHDX-026 — `auth status --output json` full 6-key schema + `render_json` routing
**Primary BC**: BC-1.6.050 (#787). **Also realizes**: BC-1.6.047 Postcondition 2a
(`env` verbatim/lossless), retires NFR-O-N.
**Technique**: CLI/JSON-shape integration test (`tests/`, assert_cmd + serde
round-trip / injected-probe fixture). Two `auth_method` variants + a human-text-
unchanged regression.
**Property**:
1. **Full schema (Postcondition 1):** on `--output json` success, exactly ONE
   JSON OBJECT (never an array) is printed to stdout with EXACTLY the six keys
   `profile`, `url`, `env`, `auth_method`, `status`, `oauth_app` — set-equality
   on the key set (no extra keys, none missing). `profile` is a string; `url` /
   `env` / `auth_method` / `oauth_app` are string-or-`null`; `status` is one of
   `"unset"`/`"no-credentials"`/`"configured"`.
2. **`oauth_app` always present (Postcondition 4):** the KEY is present in the
   object even when `auth_method != "oauth"` — value `null` for an `api_token`
   profile, a real source label (`embedded`/`keychain`/`(none)`) for an `oauth`
   profile. One test per `auth_method` variant asserts both the value and the
   key's unconditional presence (guards a mutant that omits the key when null).
3. **`env` verbatim/lossless (Postcondition 3 = BC-1.6.047 2a):** `env` echoes
   the profile's configured `env` byte-for-byte, `null` when unset — realizes
   BC-1.6.047's previously-contingent obligation.
4. **`render_json` routing (Postcondition 5, #526 invariant):** output is
   PRETTY-PRINTED and routed through `output::render_json` — asserted by matching
   the pretty (multi-line, 2-space-indented) shape `render_json` produces, NOT a
   compact `json!` Display or a raw `to_string_pretty`. (Guards the #526 render
   invariant at this new call site.)
5. **`status` shares the vocabulary (Postcondition 2):** the `status` value is
   computed via the SAME shared derivation helper as `list` (tie-in to
   VP-AUTHDX-024) — never a bare `credentials: bool`.
6. **Human-text unchanged (Postcondition 6):** a byte-for-byte regression
   asserting the default (non-JSON) `Profile:`/`Instance:`/`Env:`/`Auth
   method:`/`Credentials:`/`OAuth app:` output is IDENTICAL to pre-cycle-007 —
   `--output json` is purely additive.
**Suggested names**: `test_bc_1_6_050_status_json_full_schema_api_token`,
`test_bc_1_6_050_status_json_oauth_app_present_when_oauth`,
`test_bc_1_6_050_status_json_routes_through_render_json_pretty`,
`test_bc_1_6_050_status_human_text_byte_for_byte_unchanged`.
**F6 target**: `src/cli/auth/status.rs::status` (new `&OutputFormat` param + JSON
builder). **EC coverage**: EC-1.6.050-1 (unknown profile → standard exit-64 error
envelope BEFORE this schema — see VP-AUTHDX-028), EC-1.6.050-2 (fresh-install
zero-profiles early-return, unchanged, no stdout JSON), EC-1.6.050-3 (a backend
probe error collapses to `no-credentials` with NO stderr warning — cycle-007
preserves the shipped `.is_ok()` behavior; the backend-error-vs-absence
distinction is OBS-PB-1, out of scope — object STILL printed).

### VP-AUTHDX-027 — recovery command PARSES **and** credential-absence exits 2 (both `auth.rs` sites)
**Primary BC**: BC-1.4.032 (both-absent) + BC-1.4.033 (partial-namespaced-pair) —
the two error branches of the SAME `load_api_token` code path (#784 + #786).
**Technique**: two-part —
(a) **clap round-trip unit test** (the "suggested command parses" mechanism), and
(b) **CLI/exit-code integration test** for the exit-2 reclassification (keyring-
gated where it depends on real stored credentials, per the VP-AUTHDX-005/006/007
`JR_RUN_KEYRING_TESTS=1` pattern; the exit-code/message shape itself is
assertable against an injected absent-credential state).
**Property**:
1. **(a) Remediation command parses (#784, the HIGH defect):** the literal
   remediation string emitted in BOTH error messages —
   `jr auth login --profile <profile>` — when parsed through the actual clap
   surface (`Cli::try_parse_from(["jr","auth","login","--profile","<profile>"])`)
   resolves successfully to `AuthCommand::Login { profile: Some("<profile>"), .. }`
   and does NOT produce a clap usage error. **NEGATIVE regression anchor:** the
   OLD positional form `["jr","auth","login","<profile>"]` MUST fail to bind
   `<profile>` to the `profile` field (it is `#[arg(long)]`-only) — asserting the
   old string was genuinely broken, so a mutant reverting the message to the
   positional form is caught by the parse test, not merely by a string compare.
2. **(b) Credential-absence exits 2, both branches (#786):**
   - BC-1.4.032 both-namespaced-keys-absent → `load_api_token` returns
     `JrError::NotAuthenticated`, `exit_code() == 2`, message
     `"No credentials stored for profile '{profile}'…run \`jr auth login
     --profile {profile}\`…"` (contains the parsing `--profile` form). Legacy
     pair present or absent yields the IDENTICAL error (Postcondition 2's
     symmetric outcome).
   - BC-1.4.033 exactly-one-namespaced-key-present (partial write) →
     `JrError::NotAuthenticated`, `exit_code() == 2`, message
     `"Incomplete credentials stored for profile '{profile}' — run \`jr auth
     login --profile {profile}\`…"`.
   - **Both messages carry the `--profile` form** (ties (a) and (b) together —
     the string a user is told to run is the string the parse test in (a) proves
     valid).
   - **Oracle is a `hint`-substring assertion, not full-string equality:** each
     quoted credential-absence message above is the `hint` field of
     `JrError::NotAuthenticated`, whose `Display` impl PREPENDS
     `"Not authenticated. "` before the hint. The test therefore asserts the
     rendered error CONTAINS the quoted substring (a contains-assertion is the
     correct oracle), NOT a prefix-free equality against the whole `Display`
     output.
3. **Message-recommendation guard (BC-1.4.033 Invariant 2, SR-009):** the
   partial-write message recommends `jr auth login --profile <profile>` (or
   `jr auth remove <profile>`), NEVER `jr auth logout` (a no-op for api-token
   creds) — asserted by a substring-absence check on `"logout"` in the message.
**Suggested names**: `test_bc_1_4_032_remediation_command_parses_against_clap`
(the round-trip + old-positional-negative anchor),
`test_bc_1_4_032_credential_absence_exits_2_not_64`,
`test_bc_1_4_033_partial_write_exits_2_and_recommends_login_not_logout`.
**F6 target**: `src/api/auth.rs::load_api_token` (both error branches);
`src/cli/mod.rs::AuthCommand::Login` clap surface (parse target).
**EC coverage**: EC-1.4.032-1 (default profile, legacy present → same exit-2
error with `--profile default`), EC-1.4.032-4 (login-once remediation satisfies
the error).
**Coverage boundary:** the exit-code + message-shape assertions run against an
injected/no-credential state; the end-to-end real-keychain confirmation
(legacy pair untouched, no namespaced write) is the VP-AUTHDX-007 keyring-gated
scenario — already updated in lockstep to the exit-2 / `--profile` wording. This
VP does not duplicate that gated scenario; it pins the parse + exit-code contract
in default CI.

### VP-AUTHDX-028 — NEGATIVE pin: unknown-profile stays exit 64 (the two failure classes stay distinct)
**Primary BC**: BC-1.1.004 (deliberately UNCHANGED by cycle-007) — the negative
half of the #786 narrowing (PRD delta §5.1).
**Technique**: CLI/exit-code integration test. This is the discriminator that
guards the scope-narrowing decision — it proves the #786 reclassification did
NOT over-reach into the unknown-profile site.
**Property**:
1. **Unknown profile stays 64 (BC-1.1.004 unchanged):** `jr auth status
   --profile <name-not-in-config>` exits **64** with `JrError::UserError` and
   stderr containing `unknown profile` — NOT exit 2, NOT `NotAuthenticated`.
2. **The two classes are DISTINCT (the load-bearing discriminator):** "profile
   does not exist" (usage error → 64, BC-1.1.004) and "profile exists but has no
   stored credentials" (authentication error → 2, BC-1.4.032/033) resolve to
   DIFFERENT exit codes and DIFFERENT `JrError` variants. Assert both in one test
   module so a mutant that unifies the two sites onto a single code (either
   direction) fails at least one assertion. This is the exact invariant PRD delta
   §5.1 locked: reclassifying `status.rs`'s unknown-profile site to 2 would have
   contradicted the tested `auth switch`/`logout`/`remove` "profile not found →
   64" convention (BC-1.1.003/005/006) and `error-taxonomy.md`'s Config/Profile
   section.
3. **JSON envelope (EC-1.6.050-1 tie-in):** `jr auth status --output json
   --profile <unknown>` emits the STANDARD `{"error": "...", "code": 64}`
   envelope (error-taxonomy Section 1's JSON Error Shape), never BC-1.6.050's
   success object — the exit-64 fires BEFORE any success-schema code is reached.
**Suggested names**: `test_bc_1_1_004_unknown_profile_stays_exit_64`,
`test_auth_credential_absence_vs_unknown_profile_are_distinct_codes` (the
two-class discriminator). **F6 target**: `src/cli/auth/status.rs` (unknown-profile
branch, unchanged) vs. `src/api/auth.rs::load_api_token` (credential-absence
branch, now exit 2). **EC coverage**: EC-1.6.050-1.
**Note on registration surface:** BC-1.1.004 is a compact/short-form BC with no
`**Verification Properties**:` subsection (it predates the subsectioned format).
VP-AUTHDX-028's authoritative allocation is THIS delta; a cross-reference is
added to the BC-1.4.032 amendment context (which already discusses the §5.1
distinction) rather than restructuring the short-form BC-1.1.004 body.

---

## 5. F4 / F6 Checkpoints (carried forward)

1. **cargo-mutants examine_globs (F4).** Confirm the new `derive_auth_state`
   helper (`src/api/auth.rs`) and the `status.rs` JSON builder fall within an
   existing `.cargo/mutants.toml` §examine_globs entry (the `src/cli/auth/` and
   `src/api/auth.rs` surfaces). If a new file is introduced for the shared
   helper, ADD it to examine_globs in the same F4 burst (guarded by
   `tests/mutants_glob_existence.rs`).
2. **Keyring-gated confirmation (F6).** VP-AUTHDX-027's real-backend half reuses
   the VP-AUTHDX-007 `JR_RUN_KEYRING_TESTS=1` scenario (already updated to the
   exit-2 / `--profile` wording in lockstep) — no NEW keyring-gated test is
   required by this cycle; the default-CI exit-code/parse assertions carry the
   regression weight.
3. **BC-1.6.046 insta snapshot (F4).** Per BC-1.6.049's cross-reference note,
   BC-1.6.046's 3-profile `auth list` insta fixture MUST be regenerated in the
   same F4 burst that ships BC-1.6.049 — its "All STATUS cells `configured`" line
   changes once probing is real. VP-AUTHDX-025's differential assertion is the
   mechanism proving the regenerated snapshot is probe-derived, not URL-derived.
4. **NFR-O-N retirement doc-fallout (F4).** BC-1.6.050 Invariant 2 obliges the F4
   story to update CLAUDE.md's NFR-O-N gotcha in the same burst. Not a VP, but a
   convergence checklist item VP-AUTHDX-026 sits alongside.

---

## 6. Files written / handoff outcome (absolute paths)

**Written (new):**
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/cycle-007-verification-delta.md` (this file — authoritative VP-025..028 allocation)

**Inline BC-body citation adds (LANDED — no hook block encountered):**
- `.factory/specs/prd/bc-1-auth-identity.md`:
  - VP-AUTHDX-025 → BC-1.6.049 `**Verification Properties**:` subsection (added
    as the dedicated VP; the prior "None uniquely dedicated…" wording revised).
  - VP-AUTHDX-026 → BC-1.6.050 `**Verification Properties**:` subsection (same).
  - VP-AUTHDX-027 → BC-1.4.032 `**Verification Properties**:` subsection (full
    bullet) AND BC-1.4.033's subsection (concise cross-reference bullet, to avoid
    duplicating the shared VP body across the two branches of one code path).
  - No `#### BC-` heading was added or removed, so `total_bcs`/`definitional_count`
    frontmatter and both BC count-guards are UNAFFECTED (VP citations are body text).
- VP-AUTHDX-028 (BC-1.1.004, the NEGATIVE pin): BC-1.1.004 is a compact/short-form
  BC with NO `**Verification Properties**:` subsection (predates the subsectioned
  format). Rather than restructure a short-form BC, VP-AUTHDX-028's authoritative
  allocation is THIS delta (§4); its distinct-code relationship is already
  cross-referenced from the VP-AUTHDX-027 bullet on BC-1.4.032. No BC-1.1.004 edit
  made — deliberate, not a hook block.

**Not committed** — per instruction, state-manager commits at F2 close and sets
STATE.md's VP count to **82** (the F2-close total including VP-AUTHDX-029, §7).

**VP-AUTHDX-024 well-formedness confirmation:** VP-AUTHDX-024 (BC-1.6.048) is
WELL-FORMED as written — it states a clear property (list/status parity for the
same keychain state), a concrete verification method (proptest over the
profile-config state space + a call-site regression asserting a single shared
`derive_auth_state` helper), and an explicit coverage boundary (pure derivation
in default CI with injected probe; real-backend agreement keyring-gated). No
complementary VP is needed for it — the four new VPs (025 per-command probe
realization, 026 status JSON schema, 027 parse+exit-code, 028 distinct-code
negative pin) are the per-BC realizations that complement, and do not duplicate,
024's shared-invariant scope. **Domain scope (L-1 clarification):** VP-AUTHDX-024's
credential state domain is `present` / `absent` / `mismatched-kind` only — there
is NO `probe-error`/`Err` credential state; it is retired under the two-state
`matching_kind_present: bool` design (§3, OBS-PB-1), where `load_*().is_ok()`
collapses both credential-absence and any keychain backend error into `false`.
Neither §4 nor VP-024's proptest domain enumerates a probe-error state.

---

## 7. F2-M1 follow-on — VP-AUTHDX-029 (`auth status` HUMAN-TEXT channel parity)

**Provenance.** Adversary finding **F2-M1 [MEDIUM]**, cycle-007 F2 fix round
(2026-09-10), the formal-verifier's separate follow-on flagged in
`cycle-007-prd-delta.md` §14 ("VP work — F2-M1, a new VP covering the text
channel — is formal-verifier's separate follow-on, not part of this round").

**Gap closed.** The product-owner revised BC-1.6.048 Postcondition 3 to state the
channel relationship precisely: the two MACHINE channels — `auth list` STATUS
(BC-1.6.049) and `auth status --output json` `status` (BC-1.6.050) — both render
the full 3-state `derive_auth_state(url, matching_kind_present)` value and agree
with EACH OTHER (this is exactly **VP-AUTHDX-024**'s invariant, kept as-is). The
`auth status` HUMAN-TEXT `Credentials:` line (BC-1.6.050 Postcondition 6) is a
DIFFERENT, narrower channel: a 2-valued PROJECTION of the `matching_kind_present`
boolean (credential-present vs credential-absent) that does NOT read `url` and is
NOT the 3-state auth-state. For a `(url: None, creds-present)` profile the text
line therefore shows credential-present while the machine `status` shows `unset` —
an intentional, documented divergence, not a bug. VP-AUTHDX-024 compares only the
two MACHINE channels against each other; it does NOT cover the human-text channel
at all. A mutant that lets the `auth status` text `Credentials:` line diverge from
its OWN `matching_kind_present` source therefore passed every VP in the corpus.
VP-AUTHDX-029 closes that hole — pinning the text line to the boolean projection,
WITHOUT over-asserting text↔machine-`status` equality on the divergent cell.

**Allocation.** VP-AUTHDX-029 is the next contiguous id after VP-AUTHDX-028 (this
delta's highest). A repo-wide grep for `VP-AUTHDX-029` returns no pre-existing
match — the id is unallocated; the `AUTHDX` scope is the collision firewall as in
§1. Sequence remains dense and contiguous: `024..029`.

| New VP | Primary BC | Finding | Surface pinned (one-line) |
|--------|-----------|---------|---------------------------|
| **VP-AUTHDX-029** | BC-1.6.048 (Postcondition 3) | F2-M1 | `auth status` HUMAN-TEXT `Credentials:` line agrees with the `matching_kind_present` BOOLEAN (credential-presence projection) — NOT the 3-state machine `status` (the two machine channels' full-3-state agreement stays VP-AUTHDX-024) |

**Property (full text registered inline in the BC body).** For the SAME profile
against the SAME keychain state, the credential-presence value shown in
`auth status`'s human-text `Credentials:` line is the two-valued PROJECTION of the
SAME `matching_kind_present` boolean the caller computes
(`load_oauth_tokens().is_ok()`/`load_api_token().is_ok()`, selected by the
profile's `auth_method`) — credential-present vs credential-absent — never a value
that drifts from its OWN source probe. This is a two-value projection, NOT the
3-state `derive_auth_state`: the text line does NOT read `url`. The oracle
therefore asserts the text line tracks `matching_kind_present`, and explicitly
does NOT assert the text line equals the machine `status` on the
`(url: None ∧ matching_kind_present = true)` cell — there the text correctly shows
credential-present while the machine `status` shows `unset` (the intentional,
documented divergence). The mismatched-credential-kind case (EC-1.6.048-2) IS in
scope FOR THE BOOLEAN: an `oauth`-method profile holding ONLY a stored api-token
pair has `matching_kind_present = false`, so the text line shows credential-absent
and the machine channels render `no-credentials` — consistent because the boolean
is false, not because the text line renders the 3-state auth-state.

**Proof strategy.** Example-based / differential `#[test]` at DEFAULT CI (no
keychain), using an INJECTED probe result. The text-line oracle is over the
`matching_kind_present: bool` DIRECTLY — the human-text `Credentials:` path
collapses `auth_method` and the stored credential state into that boolean by
selecting the kind-specific probe
(`load_oauth_tokens().is_ok()`/`load_api_token().is_ok()`) and projects it to a
two-valued credential-present/absent display, independent of `url`. (The full
3-state `derive_auth_state(url: Option<Url>, matching_kind_present: bool)`
signature remains the MACHINE-channel value that VP-AUTHDX-024 pins list↔status
parity over; VP-AUTHDX-029 does NOT re-prove that parity, and does NOT route the
text line through `derive_auth_state`.) SAME mechanism family (injected boolean,
pure projection) as VP-AUTHDX-024/025. **Kani / cargo-fuzz
JUSTIFIED-SKIP** per the standing precedent in §3 and VP-AUTHDX-024's coverage
boundary: the derivation is a small total pure function over a three-value enum
with no arithmetic, indexing, or untrusted-byte parsing, so there is no
overflow/OOB surface for Kani and no fuzz-input surface for cargo-fuzz; a
differential example-based test is the complete and appropriate mechanism.

**F6 target.** `src/cli/auth/status.rs::status`'s human-text `Credentials:` path
(the two-valued `matching_kind_present` projection). This VP does NOT assert
parity against `src/cli/auth/list.rs`'s renderers or the JSON builder's 3-state
`derive_auth_state` value — that machine-channel full-3-state parity stays
VP-AUTHDX-024's scope.

**Registration surface (LANDED).** `.factory/specs/prd/bc-1-auth-identity.md` —
VP-AUTHDX-029 added as a dedicated bullet in **BC-1.6.048**'s `**Verification
Properties**:` subsection, alongside VP-AUTHDX-024. No `#### BC-` heading was
added or removed, so `total_bcs`/`definitional_count` frontmatter and both BC
count-guards (`check-spec-counts.sh`, `check-bc-cumulative-counts.sh`) are
UNAFFECTED — VP citations are body text. Also in this follow-on: BC-INDEX.md's
BC-1.6.049 title cell was reconciled to match that BC's current H1 (title-text
only; no count, id, or row change).

**VP total.** 81 → **82**. State-manager sets STATE.md's VP count to 82 at F2
close. **Not committed** — per instruction.
