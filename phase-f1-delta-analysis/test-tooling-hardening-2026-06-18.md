---
cycle: test-tooling-hardening-2026-06-18
phase: F1
date: 2026-06-18
base_commit: 6f24748
intent: enhancement
feature_type: infrastructure
trivial_scope: true
severity: N/A
items:
  - MAINT-MUTANTS-GLOBS-01
  - "#526-F6-KEYRING-GATE"
status: orchestrator-approved
---

# F1 Delta Analysis — Test-Tooling Hardening (2026-06-18)

Cycle covers two scoped process-gap items. Neither touches production `src/` runtime
behavior or any behavioral contract.

---

## 1. Impact Boundary

### Item 1 — MAINT-MUTANTS-GLOBS-01

**Proposed change:** Add `src/api/jira/issues.rs` and `src/cache.rs` to
`examine_globs` in `.cargo/mutants.toml`.

**Files touched:**

| File | Change type | Runtime behavior changed? | BC impact? |
|------|------------|--------------------------|------------|
| `.cargo/mutants.toml` | MODIFIED | No | No |
| `docs/specs/cargo-mutants-policy.md` § "Scope" | MODIFIED (doc) | No | No |

No `src/` production file is modified. The change expands the file set that
`cargo-mutants` evaluates during the full-baseline scan
(`.cargo/mutants.toml::examine_globs`). The PR-diff-scoped `--in-diff` path
already covers any changed line in ANY file; this fix closes the gap only in the
standalone `cargo mutants --jobs 4` full-baseline invocation (local developer
workflow documented in `docs/specs/cargo-mutants-policy.md` § "Local Invocation").

The CI `mutants` job runs `--in-diff` only, so CI behavior is unchanged for PRs
that do not touch these files. For PRs that DO touch `issues.rs` or `cache.rs`,
the `--in-diff` narrowing already scopes them correctly — the gap only affected
developers running the baseline scan locally.

### Item 2 — #526-F6-KEYRING-GATE

**Proposed change:** Add `#[ignore = "…"]` + `JR_RUN_KEYRING_TESTS` guard to
`tests/auth_profiles.rs::global_profile_flag_targets_auth_status`.

**Files touched:**

| File | Change type | Runtime behavior changed? | BC impact? |
|------|------------|--------------------------|------------|
| `tests/auth_profiles.rs` | MODIFIED | No | No |

No `src/` production file is modified. The test itself is not semantically
changed — its assertion logic remains identical. The gate is a test-harness
scheduling annotation, not a behavioral change.

**Why the test touches keychain:** The test config sets `auth_method = "api_token"`
for both profiles. When `jr --profile sandbox auth status` executes with a
present profile, `src/cli/auth/status.rs::status()` reaches the credential probe
branch (`auth::load_api_token().is_ok()` — first statement of the credential-present
arm). `load_api_token()` calls `keyring::Entry::get_password()` on both the
`KEY_EMAIL` and `KEY_API_TOKEN` keychain entries (`src/api/auth.rs::load_api_token`). On Linux CI without a
secret-service daemon, or under macOS Keychain contention, this call can block
waiting for the daemon or prompt for GUI authorization. The `.is_ok()` wrapper
means it never panics, but it CAN hang.

---

## 2. Affected Specs / Stories / Tests

### Specs needing delta updates

| Doc | Section | Required change |
|-----|---------|----------------|
| `docs/specs/cargo-mutants-policy.md` § "Scope" | Scope table | Add `src/api/jira/issues.rs` and `src/cache.rs` with rationale |
| `CLAUDE.md` § "AI Agent Notes" cargo-mutants entry | One-liner mention | No change required — the entry references `docs/specs/cargo-mutants-policy.md` as the authoritative doc; updating the policy doc is sufficient |

### CLAUDE.md assessment

The CLAUDE.md note at the bottom of the "Build & Test" section mentions
`cargo mutants --in-diff "$DIFF_FILE"` for the PR-diff path but does not enumerate
the `examine_globs` list. No CLAUDE.md update is needed for Item 1 — the policy
doc is the right place. For Item 2, CLAUDE.md § "AI Agent Notes" already documents
the `JR_RUN_KEYRING_TESTS=1` + `#[ignore]` pattern fully. No CLAUDE.md change needed.

### New tests needed

**Item 1 (config change):** `.cargo/mutants.toml` is a TOML file; it has no unit
test surface in the Rust test harness. Verification is by direct tool invocation
(see §6 Verification Strategy). No new test files are warranted.

**Item 2 (test annotation):** The fix is a `#[ignore]` attribute + env-var guard
on an existing test. CI already has `test_every_ignored_test_has_gate_guard`
(in `tests/e2e_live.rs`) which validates that every `#[ignore]` test has a matching
early-return guard. That meta-test will automatically cover the newly-gated test
once the guard is added. No additional new test is needed.

> **CORRECTION (2026-06-18, F5 round-3):** The claim above is inaccurate.
> `test_every_ignored_test_has_gate_guard` reads `tests/e2e_live.rs` via
> `include_str!("e2e_live.rs")` and scans ONLY that file for the `e2e_enabled()`
> guard. It does NOT read `tests/auth_profiles.rs` and does not check the
> `JR_RUN_KEYRING_TESTS` guard. It would pass even if the new guard were absent.
> Real verification: `grep -c '#\[ignore' tests/auth_profiles.rs` → 3, plus
> confirming the test appears as `ignored` under plain `cargo test`.

---

## 3. Regression Risk

### Item 1 — MAINT-MUTANTS-GLOBS-01

**Risk: LOW.**

Adding globs to `examine_globs` expands what cargo-mutants scans during a full
baseline run. It cannot break CI for existing PRs: the CI job uses `--in-diff`
which scopes to lines changed in the PR diff. A PR that does not touch
`issues.rs` or `cache.rs` generates zero mutants in those files regardless of
`examine_globs`. A PR that does touch them was already being mutation-tested via
`--in-diff` (the diff-scope overrides the glob-scope). The only user-facing change
is that `cargo mutants --jobs 4` (the local baseline) now covers two more files,
potentially surfacing surviving mutants that were previously invisible. This is
exactly the desired outcome, not a regression.

**Single risk to flag:** if the newly-in-scope functions have surviving mutants
that drop the kill rate below 90% on the first full-baseline run, the developer
will see warnings. This is by design and does not block CI. The deferral policy
in `docs/specs/cargo-mutants-policy.md` § "Deferral Policy" applies: file
follow-up issues per surviving-mutant cluster, whitelist genuinely unkillable
mutants with justification comments.

### Item 2 — #526-F6-KEYRING-GATE

**Risk: LOW.**

The test `global_profile_flag_targets_auth_status` will now be skipped by default
(`cargo test`) and run only when `JR_RUN_KEYRING_TESTS=1`. This is the correct
behavior for a test that touches the system keychain. The regression risk is
theoretical: if a future developer makes a change that breaks the global
`--profile` flag propagation into `auth status`, the test would now only catch it
when explicitly opted into keyring tests.

Mitigating factor: `tests/auth_profiles.rs::precedence_flag_overrides_env_overrides_config`
(ungated, no keyring touch — it calls `auth list --output json` which does not
reach the credential probe) continues to validate profile-flag propagation through
`auth list`. The `global_profile_flag_targets_auth_status` test adds coverage of
the `auth status` handler specifically. The risk of missing a regression is
accepted given the flakiness risk it currently poses on CI.

---

## 4. LESSON-F1-SIBLING-CASE

> **NOTE (2026-06-18, F5 round-5):** §4 Item 1 sibling table updated — `issues.rs` rationale now
> includes `list_comments` to match the shipped `.cargo/mutants.toml` comment and
> `docs/specs/cargo-mutants-policy.md` Scope entry. `list_comments` landed in `issues.rs` via S-525
> and is a legitimate mutation target; it was absent from this table's original draft.

### Item 1 Siblings: Other high-risk src/ files missing from examine_globs

Cross-referencing the policy doc scope rationale ("high line coverage but untested
assertion strength") against the codebase:

| File | Risk assessment | Recommendation | Rationale |
|------|----------------|---------------|-----------|
| `src/api/pagination.rs` | MEDIUM | EXCLUDE this cycle | Serde deserialization structs + `items()` helper. Logic is simple (field access); mutation survivors would be caught by the many integration tests in `tests/issue_commands.rs`, `tests/search_issue_keys.rs`. Low payoff vs cost of adding to baseline. |
| `src/api/jira/issues.rs` | HIGH | INCLUDE (proposed) | `search_issues`, `search_issue_keys`, and `list_comments` — JRACLOUD-95368 anti-loop guard, `seen_keys` dedup, `has_more` sentinel, cursor-vs-offset pagination branch (S-525 also added `list_comments`). These are exactly the kind of subtle multi-path logic where mutation testing adds value. Strong test coverage in `tests/search_issue_keys.rs` and `tests/rate_limit_cap_tests.rs` makes the kill rate feasible. |
| `src/cache.rs` | HIGH | INCLUDE (proposed) | TTL logic, per-profile path construction, model-a vs model-b error-handling split (`write_cmdb_fields_cache` and `write_object_type_attr_cache` swallow errors; others propagate). Mutations of TTL comparisons or path-join calls would be invisible to integration tests that mock the filesystem via `JR_CACHE_DIR`. The existing test surface in `tests/multi_profile_fields.rs` and `tests/project_meta.rs` covers cache reads but not write-error paths. |
| `src/api/jira/users.rs` | MEDIUM | DEFER | Contains the `USER_PAGE_SIZE`-advance pagination workaround (JRACLOUD-71293). Interesting but test coverage via `tests/user_commands.rs` is limited. Adding it without new targeted tests risks a low kill rate and a noisy first run. Better addressed in a dedicated "users pagination hardening" cycle. |
| `src/jql.rs` | LOW | EXCLUDE | JQL escaping/validation. Property-tested via proptest in `src/jql.rs` inline tests. Mutation survivors would almost certainly be caught. Adding it increases baseline cost without proportional benefit. |
| `src/api/jira/bulk.rs` | Already in scope | — | Already in `examine_globs`. |
| `src/cli/issue/create.rs` | Already in scope | — | Already in `examine_globs`. |

**Recommendation for this cycle:** Add only `src/api/jira/issues.rs` and
`src/cache.rs` as proposed. `src/api/jira/users.rs` is a candidate for a
subsequent cycle once targeted pagination tests exist.

### Item 2 Siblings: Other ungated keyring-touching tests

Searched for keyring-touching patterns (keyring API calls, auth login/refresh/
logout against configured profiles, `set_password`, `get_password`, `login_token`)
across all test files. Findings:

**`tests/auth_profiles.rs`**

| Test | Lines | Keyring touch? | Gated? | Action |
|------|-------|---------------|--------|--------|
| `auth_switch_unknown_profile_exits_64` | ~45 | No (exits 64 before creds probe) | N/A | None |
| `auth_list_shows_no_profiles_for_fresh_install` | ~56 | No (empty profiles → no creds probe) | N/A | None |
| `auth_status_fresh_install_no_profiles_succeeds` | ~72 | No (early-return at `profiles.is_empty()`) | N/A | None |
| `auth_status_unknown_profile_exits_64` | ~83 | No (exits 64 at unknown-profile guard before creds probe) | N/A | None |
| `auth_logout_unknown_profile_exits_64` | ~105 | No (exits 64 before keyring) | N/A | None |
| `auth_remove_active_profile_exits_64` | ~128 | No (exits 64 before keyring) | N/A | None |
| `precedence_flag_overrides_env_overrides_config` | ~151 | No (`auth list --output json` does not reach credential probe) | N/A | None |
| `global_profile_flag_targets_auth_status` | ~203 | **YES** — reaches `load_api_token()` | **NOT gated** | **Gate this cycle** |
| `auth_login_creates_new_profile_with_url` | ~253 | YES — calls `login_token` (keyring write) | Gated correctly | None |
| `auth_login_with_jr_profile_pointing_to_unrelated_profile_still_creates_target` | ~303 | YES — calls `login_token` (keyring write) | Gated correctly | None |

**`tests/multi_cloudid_disambiguation.rs`**

Several tests at lines ~287, ~350, ~585, ~733, ~820, ~911 are `#[ignore]` +
`JR_RUN_KEYRING_TESTS` gated. The ungated tests in this file call
`jr auth login --help` (no keyring touch) or assert on CLI structure. Properly
gated.

**`tests/oauth_refresh_integration.rs`**

All keyring-touching tests (`AC-002`, `AC-009`..`AC-011`) use `#[ignore]` +
`JR_RUN_KEYRING_TESTS`. Properly gated.

**`tests/auth_output_json.rs`**

`test_auth_login_emits_json_when_output_json_set` at line ~336 is `#[ignore]` +
`JR_RUN_KEYRING_TESTS` gated. Properly gated.

**`tests/oauth_flow_holdouts.rs`**

`test_s_1_06_h_001_auth_status_no_profiles` at line ~80 calls `jr auth status`
against an empty XDG_CONFIG_HOME. The code path hits the early-return at
`profiles.is_empty() && profile_arg.is_none()` before reaching the credential
probe. No keyring touch. No gate needed.

**`tests/auth_login_config_errors.rs`**

Single test `auth_login_oauth_surfaces_malformed_config_without_overwriting` at
line ~19. Exercises `jr auth login --oauth` against a broken config — exits before
any keyring operation (config parse error). No keyring touch. No gate needed.

**Summary:** `global_profile_flag_targets_auth_status` is the ONLY ungated
test with a confirmed keyring touch. All other candidates either exit before the
keyring path or are already correctly gated. This cycle's scope for Item 2 is
correctly bounded to a single test.

---

## 5. Story Decomposition Recommendation

**ONE story** covering both items.

Rationale:
- Both are configuration/annotation changes with zero production code surface.
- Both fit trivial-scope classification (single file per item, no new BCs, no arch
  change, regression risk LOW).
- Combined diff is tiny: `+2` lines to `.cargo/mutants.toml`, `+1` line to
  `docs/specs/cargo-mutants-policy.md`, and `+2` lines to `tests/auth_profiles.rs`
  (the `#[ignore]` attribute + early-return guard, mirroring the sibling pattern at
  line 252 and 302 of that file).
- A single PR keeps the audit trail clean — both items are test-tooling hygiene
  with identical review concerns.

Quick-dev routing applies: F1 → F4 (single story, worktree → implement → PR →
pr-reviewer → merge) → regression suite → F7 lite → PATCH.

Skipped: F2 (no spec change beyond policy doc update), F3 (no new stories beyond
the one implementation story), F5 (no behavioral logic to adversarially review),
F6 (no formal hardening warranted for config/annotation changes).

> **CORRECTION (2026-06-18, F5 round-3):** The routing note above was superseded
> in practice. The full F1–F7 pipeline ran: F2 produced spec deltas
> (`docs/specs/multi-profile-auth.md`), F3 added AC-003 and the new ungated
> regression test, and F5 adversarial reviews surfaced multiple findings
> (guard-form I-1 HIGH, false-verifier claim) that required story revisions.
> CLAUDE.md was also updated (keyring-roster extension). The "skip F2/F5/CLAUDE.md"
> assumption proved incorrect for this cycle.

---

## 6. Verification Strategy (F4)

### Item 1 — MAINT-MUTANTS-GLOBS-01

**Proving the files are now in scope:**

```bash
# After applying the change, list all mutants cargo-mutants would generate.
# Both files should appear in the output.
cargo mutants --list 2>/dev/null | grep -E "issues\.rs|cache\.rs"
```

Expected: multiple lines for each file (function names from `issues.rs` and
`cache.rs`). Before the fix, this command produces zero lines for those files.

**Proving the baseline scan runs without configuration error:**

```bash
# Dry-run: generate mutants but do not execute tests (fast sanity check).
cargo mutants --list-files 2>/dev/null | grep -E "issues\.rs|cache\.rs"
```

**CI gate:** The `mutants` CI job runs `--in-diff`, so it is unaffected. No CI
change is needed. Document the local-baseline expansion in `docs/specs/cargo-mutants-policy.md`.

### Item 2 — #526-F6-KEYRING-GATE

**Proving the test skips by default:**

```bash
# With the gate applied, this must NOT run the test.
cargo test --test auth_profiles global_profile_flag_targets_auth_status
# Expected: "test global_profile_flag_targets_auth_status ... ignored"
```

**Proving the test runs when opted in:**

```bash
JR_RUN_KEYRING_TESTS=1 cargo test --test auth_profiles -- \
  --include-ignored global_profile_flag_targets_auth_status
# Expected: test runs and passes (or is recorded as requiring live keychain).
```

**Proving the meta-test still passes (no missing guard):**

```bash
cargo test --test e2e_live test_every_ignored_test_has_gate_guard
# Expected: passes — the new ignore will have the guard.
```

> **CORRECTION (2026-06-18, F5 round-3):** The meta-test above does NOT verify the
> `JR_RUN_KEYRING_TESTS` guard in `tests/auth_profiles.rs`. It scans only
> `tests/e2e_live.rs` and checks for `e2e_enabled()`. Real verification for the
> new gate is: `grep -c '#\[ignore' tests/auth_profiles.rs` → 3, plus confirming
> `cargo test --test auth_profiles global_profile_flag_targets_auth_status` shows
> the test as `ignored`.

**CI gate:** Standard `cargo test` in CI (which does not pass `--include-ignored`)
will skip the test automatically once `#[ignore]` is applied.

---

## 7. Files NOT Changed (Regression Baseline)

All `src/` production files are unchanged. The following are specifically confirmed
NOT modified:

- `src/api/jira/issues.rs` — no code change, only added to mutation scan scope
- `src/cache.rs` — no code change, only added to mutation scan scope
- `src/cli/auth/status.rs` — no code change, behavior unchanged
- `src/api/auth.rs` — no code change
- All `src/cli/`, `src/api/`, `src/types/`, `src/adf.rs` — unchanged

Test files NOT modified (regression baseline for test suite):

- `tests/multi_cloudid_disambiguation.rs`
- `tests/oauth_refresh_integration.rs`
- `tests/auth_output_json.rs`
- `tests/oauth_flow_holdouts.rs`
- All other `tests/` files

---

## 8. Multi-Repo Assessment

Single-repo project. Not applicable.

---

## Human Approval Gate

Items in scope are confirmed as:

1. **MAINT-MUTANTS-GLOBS-01** — Add `src/api/jira/issues.rs` and `src/cache.rs` to
   `.cargo/mutants.toml::examine_globs`. Update `docs/specs/cargo-mutants-policy.md`
   § "Scope" to reflect the addition.

2. **#526-F6-KEYRING-GATE** — Gate `tests/auth_profiles.rs::global_profile_flag_targets_auth_status`
   with `#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to run"]`
   and an `if std::env::var("JR_RUN_KEYRING_TESTS").is_err() { return; }` early-return,
   mirroring the pattern at lines 252–255 and 302–305 of the same file.

Scope is trivial. One story. Orchestrator-approved; ran full F1–F7 per human directive.
