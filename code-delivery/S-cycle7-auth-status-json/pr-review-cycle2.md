## PR Review — Cycle 2 (focused re-review of doc fixes)

**Verdict: APPROVE**

Scope of this pass: re-verification of the three cycle-1 findings (BLOCKING-1, MAJOR-1,
MAJOR-2) against commit `0992e5c8`, plus a check for new issues introduced by the doc
commits. The Rust implementation was cleared in cycle 1 and is unchanged since; I
re-read `src/cli/auth/status.rs`, `src/main.rs`, and `src/cli/auth/mod.rs` only to
confirm the doc claims are true statements about the code.

---

### Cycle-1 findings — resolution status

| ID | Finding | Status | Verification |
|----|---------|--------|--------------|
| BLOCKING-1 | `docs/specs/multi-profile-auth.md` stale "Human text only — no `--output json` support" | **RESOLVED** | Now reads "Supports `--output json` (BC-1.6.050…): emits a 6-key object `{profile, url, env, auth_method, status, oauth_app}`". Key set matches `build_status_json`'s `serde_json::json!` literal exactly (6 keys, same names, same order). |
| MAJOR-1 | `docs/specs/cargo-mutants-policy.md` exclusions registry not updated for the new `exclude_re` pairs | **RESOLVED** | A new entry lands under `## Exclusions` (line ~779) covering **both** newly excluded functions, each with its A/B regex rationale and a positive-coverage justification. All four regexes in `.cargo/mutants.toml` are accounted for, and all four are file-anchored to `status\.rs`, so they cannot silence the `list.rs` siblings or `build_status_json`. `scripts/check-cargo-mutants-policy-citations.sh` passes (22 bullets / 77 pairs). |
| MAJOR-2 | `docs/specs/e2e-live-jira-testing.md:83` stale "it emits no JSON" | **RESOLVED** | Now reads "it now supports `--output json` (BC-1.6.050) but makes no Jira API call, so the E2E exclusion still stands". Both halves verified: the JSON path exists, and `status()` performs only a config load + keychain read — no HTTP client is constructed anywhere in the function. The retained exclusion rationale is now the *correct* one (no API call), not the false one (no JSON). |
| MINOR-2 | PR body field-parity claim | **RESOLVED** | "shares 4 field names with `auth list --output json` (`url`, `env`, `auth_method`, `status`); `profile`/`oauth_app` differ from `name`/`active`" — consistent with the documented `auth list` shape and with `test_bc_1_6_050_json_field_names_match_list_json`. |
| MINOR-1 | PR body test count | **PARTIALLY RESOLVED** | Summary table corrected; four other sites still claim 14 default-CI — see SUGGESTION-3. Non-blocking. |

I also swept `docs/`, `src/`, `tests/`, `README.md`, and `CLAUDE.md` for any remaining
"auth status has no JSON" / NFR-O-N assertions. None survive. `CLAUDE.md`'s deferred-NFR
bullet correctly marks NFR-O-N as RETIRED rather than deleting the line, preserving the
audit trail.

No blocking or major findings remain.

---

### Remaining findings (all non-blocking)

#### [SUGGESTION] `cargo-mutants-policy.md` glob-count prose is now off by three

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | description |
| Finding | `docs/specs/cargo-mutants-policy.md:51` states "Current `examine_globs` count: 22 entries", and line ~1410 repeats "`examine_globs` currently carries 22 entries". `.cargo/mutants.toml` now has **25** entries. This drift is pre-existing (develop was already at 24 vs. a documented 22), but this PR adds a 25th without touching either number. |
| Suggestion | Bump both occurrences to 25 in this PR. The doc already hedges the figure ("it has drifted before and will drift again"), which is why this is a suggestion rather than a blocker — but a PR that adds a glob is the natural place to reconcile it, and leaving it lets the drift compound. |

#### [SUGGESTION] No `## Scope` bullet for the newly added `status.rs` glob

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | description |
| Finding | Every `examine_globs` entry historically gets a matching bullet in `## Scope` naming the functions under test and the story that added it. `src/cli/auth/status.rs` gets an `exclude_re` registry entry but no `## Scope` bullet. (`src/cli/auth/list.rs` and `src/cli/issue/mentions.rs` are missing bullets too — a pre-existing instance of the same class, so this PR is consistent with recent practice rather than uniquely at fault.) |
| Suggestion | Add one bullet: `src/cli/auth/status.rs` — `build_status_json` (pure 6-key JSON assembly), `status()` `OutputFormat` dispatch; `probe_matching_kind_credential` and `peek_oauth_app_source` `exclude_re`'d (added S-cycle7-auth-status-json). The `Spec Guards` job does not enforce this, so it is a convention gap, not a CI failure. |

#### [SUGGESTION] PR body still claims 14 *default-CI* tests in four places

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | description |
| Finding | Actual counts: `tests/auth_status_json.rs` has 8 tests, 3 of them `#[ignore]`+`JR_RUN_KEYRING_TESTS` → 5 default-CI; `src/cli/auth/tests/mod.rs` adds 6 default-CI → **11 default-CI + 3 keyring-gated = 14 total**. The Summary table (body line ~168) was corrected in cycle 1 and now states this correctly. Four other sites were not: the Tests badge ("tests-14/14 default CI + 3 keyring-gated"), the ADR Consequences bullet ("14 new default-CI tests (no keychain), 3 keyring-gated tests"), the Test Evidence row ("Default-CI tests (new) \| 14 pass"), and the Test Flow mermaid node ("14 Default-CI Tests"). The Test Evidence table additionally lists the AC-011 inline test as a separate `1 pass` row, which double-counts against the 6 inline tests already folded into its own 14. |
| Suggestion | Change the four remaining sites to "11 default-CI + 3 keyring-gated (14 new tests total)" and drop or re-label the double-counted AC-011 row. Cosmetic and PR-body-only — no code or test change implied — but "14 default CI" is the number a future reader will quote. |

#### [NIT] Exclusion entry mis-cites AC-013 as positive wiring evidence for `peek_oauth_app_source`

| Field | Value |
|-------|-------|
| Severity | nit |
| Category | description |
| Finding | The new registry entry says correctness is verified by "the AC-012/AC-013 wiring tests that assert `peek_oauth_app_source` is called in the right code path." AC-013 (`test_bc_1_6_050_json_builder_is_probe_free`) asserts the **opposite** — that `peek_oauth_app_source(` does *not* appear in `build_status_json`'s body (that is the purity guard). The genuine positive evidence is the C-1 dispatch test `test_bc_1_6_050_status_success_dispatch_arms_covered`, whose oauth arm asserts `oauth_parsed["oauth_app"].is_string()` — which is only reachable if `peek_oauth_app_source` is called and its label propagates. Similarly, the `probe_matching_kind_credential` justification credits "AC-004 source-scan + call-count wiring tests", where the real default-CI evidence is again C-1 (isolated `JR_SERVICE_NAME` → deterministic `matching_kind_present == false` → `"status":"no-credentials"` on both the api_token and oauth arms). |
| Suggestion | Re-point both justifications at `test_bc_1_6_050_status_success_dispatch_arms_covered` as the named positive-coverage assertion (the thing §F-3 actually requires), keeping AC-013 cited for what it does prove — that the pure builder stays probe-free. The exclusions themselves are substantively justified; only the test attribution is loose. |

---

### What I verified beyond the three fixes

- **Doc-to-code truth check.** Every factual claim added by the doc commit was checked
  against the source, not taken on trust: the 6-key set against the `json!` literal; the
  `status` 3-value vocabulary against `derive_auth_state`; `oauth_app` null-when-not-oauth
  against the `if method == "oauth"` fork in the JSON arm; "no Jira API call" against the
  absence of any client construction in `status()`; and the four `exclude_re` patterns
  against the actual function names and file path.
- **Human-text channel.** The `Table` arm reproduces the original six `println!`s in the
  same order with the same literals and the same `if matching_kind_present` /
  `if method == "oauth"` guards. The refactor hoists the probe to a single call site
  shared by both arms, so the two channels cannot diverge — which is what the story
  claims and what `test_vp_authdx_029_*` pins.
- **Exclusion blast radius.** All four new regexes are anchored to
  `^src/cli/auth/status\.rs:\d+:\d+:`, so `build_status_json` and the `status()` dispatch
  arms stay in mutation scope. That is the right boundary: the pure, newly written logic
  remains under mutation pressure; only the two un-injectable keychain wrappers are
  silenced.
- **No scope creep.** The doc commit touches three spec files and nothing else. No source,
  test, config, or workflow file moved in it.
- **CI.** Format, Clippy (ubuntu), MSRV, Deny, Secret Scan, dependency-review, Mutation
  Test Plan, and Spec Guards are green; `Test`, `Coverage`, Windows Clippy, and most
  mutation shards were still pending when this review ran. `ci-gate` remains the merge
  authority — approval here is not a substitute for it, and per this repo's documented
  `strict: false` posture the gate should be re-checked if `develop` has moved since the
  last green run.
- **Demo evidence.** Carried forward from cycle 1's disposition: the PR documents a
  reasoned waiver (output-only CLI change; a keychain-state terminal recording is not
  reproducible on the CI host), and the observable behavior is covered by the C-1
  end-to-end subprocess test that asserts real stdout JSON from the real binary. I am not
  re-litigating this as blocking, but noting that the waiver — not a recording — is what
  satisfies the evidence requirement here.

Nothing in the doc commit introduces a new correctness, security, or accuracy regression.
The three cycle-1 findings are genuinely closed rather than papered over: in each case the
replacement text is a true statement about the shipped code, and in the e2e case the
*rationale* for the retained exclusion was corrected too, not just the stale clause.
