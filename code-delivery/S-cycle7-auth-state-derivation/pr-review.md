# PR Review — PR #806 (`feat/cycle7-auth-state-derivation` → `develop`)

**Verdict: APPROVE** (revised — supersedes the REQUEST_CHANGES verdict I posted earlier)

**Covered SHA:** `d42d288e5bdff17336cf1b32a4edf711f2b452fb`
**Earlier verdicts from me on this PR:** REQUEST_CHANGES against `6d3030f9…` (superseded).

**Review chain covered.** The branch was force-pushed/advanced four times during review;
I have read every delta, so this verdict covers the complete current head:
`6d3030f9` (full file-by-file review) → `5ced48ca` (spec/policy docs + AC-009 test
strengthening) → `0c034cb7` (8 lines of test keychain isolation) → `d42d288e` (6-line
CHANGELOG macOS note).

---

## CORRECTION / RETRACTION — my BLOCKING-1 finding was mis-attributed

I previously reported a **blocking** defect: that the new keychain probe in `handle_list`
made two integration tests hang indefinitely on macOS. **I am retracting that finding.**
It does not hold up, and the causal mechanism I proposed is implausible. Recording the
full reasoning because a code change (`0c034cb7`) was made on the strength of my
original claim.

**What I actually observed (all real):**
1. During a `cargo mutants --in-diff` baseline (which runs the entire test suite),
   cargo reported two tests running >60 s: `precedence_flag_overrides_env_overrides_config`
   and `test_bc_1_2_018_auth_list_remove_profile_flag_still_honored_not_rejected`.
2. Re-running the first in isolation: hung >200 s, no completion, killed with SIGTERM.
   `SecurityAgent` (the macOS keychain-dialog process) was alive at that moment.
3. The same test with `JR_SERVICE_NAME` set in the parent env: passed in 1.00 s.

**Why I now believe (3) was coincidence, not causation.** Controls run after the fact:
- Invoking the built binary directly against the **real** `jr-jira-cli` keychain service,
  with a config of URL-having profiles and no `JR_SERVICE_NAME` (i.e. exactly the
  unpatched condition): **0.047 s**, no prompt, correct `no-credentials` output.
- `tests/oauth_flow_holdouts.rs::test_s_1_06_h_003_profile_precedence_chain` — which
  calls `jr auth list` four times against four URL-having profiles (including one named
  `default`) and was **never** patched with `JR_SERVICE_NAME`: **1.11 s**, passes.
- Full `auth_profiles` suite with `JR_SERVICE_NAME` scrubbed from the env: 46 passed in
  1.02 s.

**Mechanism analysis.** The only way the probe can block is a macOS ACL consent dialog,
which requires the keychain item to *exist* and the calling binary to be off its ACL.
The hung test's profiles are `from-config` / `from-env` / `from-flag` — names that would
not match any real stored credential. So the ACL path could not have fired for that
test regardless of this PR. The far more likely explanation is a transient
keychain-unlock/consent dialog pending on the host during that window (plausibly raised
by the concurrent full-suite mutants baseline), behind which any keychain-touching
process blocked; once it cleared, the blocking vanished. My `JR_SERVICE_NAME` run
happened after it cleared.

**Status:** NOT a demonstrated PR-caused defect. Not reproducible on this host in the
unpatched condition. **Retracted as blocking.**

**On the fix that was applied anyway (`0c034cb7`).** The two `.env("JR_SERVICE_NAME", …)`
additions are still worthwhile defensive hygiene, and I have no objection to keeping
them: they isolate tests from the developer's real keychain namespace, matching the
convention CLAUDE.md already establishes for cache- and keyring-touching tests, and they
close the residual ACL-dialog risk for any developer whose real profile names happen to
collide with a fixture's. Two observations for whoever carries this forward, neither
blocking:
- The durable form would be `.env("JR_SERVICE_NAME", …)` inside `auth_profiles.rs`'s
  own `jr()` helper (and `oauth_flow_holdouts.rs`'s `jr_cmd()`), so future `auth list`
  tests inherit isolation by construction rather than per-call-site. Right now
  `tests/oauth_flow_holdouts.rs:191` still probes the real service unisolated.
- The chosen values are fixed strings rather than per-test-unique. That is safe here
  because these paths only ever *read*, but it would not be if a future test in the
  same file writes credentials.

---

## Remaining findings (none blocking)

### SUGGESTION-1 — PR body's "no writes" claim is inaccurate

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | description / blast-radius accuracy |
| Location | `src/cli/auth/list.rs::probe_matching_kind_credential` → `src/api/auth.rs::load_oauth_tokens` (~619-627, ~648-657) |

This one is verified by code reading and stands. `load_oauth_tokens` lazy-migrates the
`default` profile: when the namespaced pair is absent or partial and the legacy flat
OAuth keys are present, it calls `store_oauth_tokens(...)` and then deletes
`KEY_OAUTH_ACCESS_LEGACY` / `KEY_OAUTH_REFRESH_LEGACY`. A `default` profile with
`auth_method = "oauth"` and legacy keys will therefore have its keychain rewritten by
`jr auth list`. The PR's Risk Assessment says "Data impact: None — read-only keychain
probe, no writes."

No credential-loss path exists (store precedes delete; a failed store leaves the legacy
pair intact), and this migration already fires on every other command that loads OAuth
tokens — hence non-blocking. But the claim should be corrected, since the command being
changed is otherwise purely informational.

### SUGGESTION-2 — `.is_ok()` collapses genuine keyring backend errors into `no-credentials`

| Field | Value |
|-------|-------|
| Severity | suggestion |
| Category | correctness / error handling |
| Location | `src/cli/auth/list.rs::probe_matching_kind_credential` |

`read_keyring_optional`'s rustdoc in `src/api/auth.rs` explains at length why
`.ok()`-style collapsing is wrong: "a permission-denied, locked-keyring, or platform
error looks identical to a missing entry … hides the real problem from the user."
`.is_ok()` reintroduces exactly that collapse — on a locked keyring or a host without
secret-service, every profile renders `no-credentials`, a new false negative replacing
the old false positive. The `Result<bool>` alternative was recorded as rejected at F2
round 4, so this is a deliberate design point; consider a stderr warning when the probe
fails for a reason other than absence (stderr keeps it out of `--output json`).

### ~~SUGGESTION-3~~ — macOS consent-prompt risk undocumented — **RESOLVED in `d42d288e`**

On a host where the probed items *do* exist, a newly installed `jr` binary can raise a
keychain ACL prompt from what is now a credential-reading listing command.
`d42d288e` adds a six-line **macOS note** to the CHANGELOG entry covering exactly this:
the dialog text users will see, that granting once silences it, and that it does not
appear on Linux or Windows. Verified accurate — the per-binary-ACL consent model is
macOS-specific; Windows Credential Manager and Linux secret-service do not gate reads
this way. Closed.

### NIT-1 — `three_profile_fixture` builds four profiles

`src/cli/auth/tests/mod.rs` — the `unset-url` addition makes the helper name inaccurate;
`list_json_shape`'s own comment acknowledges it.

### NIT-2 — brace-counting source-scan extractor is literal-fragile

`tests/auth_list_status.rs::extract_fn_body` plus two inline copies in
`src/cli/auth/tests/mod.rs` count `{`/`}` without skipping string literals. Correct today
(every brace in both renderer bodies balances, including `format!("{marker} {name}")`),
but an unbalanced brace in a future literal would silently truncate the extracted body
and make the purity guards pass vacuously. Consider one shared helper with a comment
noting the limitation.

### RESOLVED during review

- `docs/specs/multi-profile-auth.md:266` declared `STATUS ∈ {configured, unset}` and
  ~458-460 still listed this work as an out-of-scope follow-up — both fixed in `5ced48ca`.
- `docs/specs/cargo-mutants-policy.md` § Scope had no bullet for the new
  `src/cli/auth/list.rs` `examine_globs` entry — added in `5ced48ca`.
- AC-009's counting closure returned a constant, leaving the `HashMap::from_iter([...])`
  constant-map mutants unkilled — strengthened in `5ced48ca` with per-profile return
  values plus map-content and map-length assertions.

---

## What was verified as sound

**1. Three-state logic and boundary conditions.** `derive_auth_state` matches on
`Option<&str>` first, so `url = None` yields `Unset` irrespective of
`matching_kind_present`; `Some(_)` splits on the bool. Rustdoc truth table, serde
`kebab-case` output, and `as_str()` all agree, and
`test_bc_1_6_048_auth_state_as_str_agrees_with_serde` locks the table and JSON channels
together so they cannot drift. The exhaustive 4-class test also asserts determinism
across two consecutive calls plus a proptest over arbitrary URL strings confirming the
URL is never parsed.

Kind selection was checked against runtime behavior: `probe_matching_kind_credential`
routes `auth_method == "oauth"` to `load_oauth_tokens` and everything else — including
`None`/legacy, passed as `""` by `collect_probe_results` — to `load_api_token`. That
mirrors `JiraClient::from_config`'s `auth_method.unwrap_or("api_token")` +
`load_auth_from_keychain` match exactly, so a legacy `auth_method: None` profile holding
only OAuth tokens correctly reports `no-credentials`: the next real command would fail
too. No false-negative class introduced.

**2. Renderers are genuinely pure.** In the diff, both renderers take
`&HashMap<String, bool>` and call only `derive_auth_state`; the keychain imports are used
solely inside `probe_matching_kind_credential`. Structurally, the AC-004/AC-010/AC-014
source-scans extract each renderer body by brace balance, deny `load_oauth_tokens`,
`load_api_token`, `probe_matching_kind_credential`, and `collect_probe_results`, and
positively require `derive_auth_state(`. `collect_probe_results` is the probe's only
caller, and `handle_list` invokes it once before the renderer fork — no double-probe.

**3. Tests are differential, not trivially passing.** Mixed `probe_results` injection
with per-row / per-profile assertions, so both the `url.is_some()`-reversion class and an
"ignore the new parameter" implementation fail: an `oauth` profile with a URL and `false`
must render `no-credentials` while an `api_token` profile with `true` must render
`configured` (asserted on the located row, not a whole-table `contains`); JSON key
set-equality in both directions plus vocabulary membership; a column-targeted ANSI/plain
check that extracts the STATUS cell by comfy-table separators so the URL column's
`(unset)` placeholder cannot mask a mutated STATUS arm; and a probe-count assertion of
exactly 2 for 2 URL-having profiles and 0 for `url: None`.

Local results at the covered SHA: `cargo test --lib cli::auth` → 102 passed;
`api::auth::tests::test_bc_1_6_048*` → 5 passed; `cargo test --test auth_list_status`
→ 1 passed; `cargo test --test auth_profiles` → 46 passed.

**4. `exclude_re` scope covers only `probe_matching_kind_credential` (verified
empirically).** `cargo mutants --list --in-diff` returns exactly 10 mutants, all in
`src/cli/auth/list.rs`: 5 on `collect_probe_results`, 2 on `render_list_table`, 2 on
`render_list_json`, 1 on `handle_list`. Zero mutants from
`probe_matching_kind_credential` appear — including its `auth_method == "oauth"` operator
mutants — positive proof that Regex A fires, while every other function in the file still
reports its mutants, proving nothing else was suppressed. Regex B requires a literal
space after the function name, so a future `probe_matching_kind_credential_v2` would not
be silently swallowed. The `examine_globs` addition resolves to a real file, satisfying
`tests/mutants_glob_existence.rs`. The `handle_list` mutant is declared an accepted
survivor but looks likely to be killed, since `tests/auth_profiles.rs` and
`tests/oauth_flow_holdouts.rs` parse `auth list --output json` stdout that an `Ok(())`
body would leave empty.

**5. Diff coherence, size, dependencies.** 8 files, +1181/-32 at the original head; every
change traces to BC-1.6.048 / BC-1.6.049 / BC-1.6.046 with no unrelated edits. Bulk is
tests (614 lines in `src/cli/auth/tests/mod.rs`, 169 in the new `tests/auth_list_status.rs`);
production delta ~195 lines. Conventional Commits with story-scoped subjects. Branch is
current with `develop` (`develop` is an ancestor), so the `strict: false` stale-base
hazard in CLAUDE.md does not apply. #803 merged; no unmerged dependency. The JSON render
invariant (#526) is unaffected — the renderer still returns a string to `handle_list`'s
single `println!`, with `status` now serialized via `AuthState`'s serde impl.

**Demo evidence:** recorded as skipped by human decision with a stated rationale
(multi-profile keychain states impractical to stage on the dev host). Accepted — all
three `AuthState` arms have DEFAULT-CI coverage plus a snapshot pin.

---

## Checklist

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS |
| 2 | Description accuracy | PASS with SUGGESTION-1 (the "no writes" claim is wrong; non-blocking) |
| 3 | Test coverage | PASS — differential, mutation-aware, all ACs in default CI |
| 4 | Demo evidence | N/A — explicitly skipped by human decision with rationale |
| 5 | Commit quality | PASS |
| 6 | Diff size | PASS — majority tests; production delta ~195 lines |
| 7 | Missing changes | PASS — spec vocabulary and mutants-policy docs updated |
| 8 | Dependency status | PASS — #803 merged; branch current with `develop` |

**CI at time of review:** 14 checks passing, 0 failing, remainder (Test macos/windows,
Coverage, mutation shards) still pending on `0c034cb7`. Approval is on code grounds and
does not waive the `ci-gate` requirement in the pre-merge checklist.

**Note:** the story worktree carries an uncommitted `CHANGELOG.md` modification at the
time of writing. This approval covers `0c034cb7` only; if that change is committed and
pushed, the head moves past the covered SHA.
