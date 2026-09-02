# Demo Evidence — S-cycle3-credential-absence-guard

**Story:** No-copy detect-and-instruct guard for absent per-profile API-token credentials (DEC-326)
**BCs:** BC-1.4.032 (new, redesigned), BC-1.4.033 (new, redesigned), BC-1.4.034 (new), BC-1.4.025 / BC-1.4.029 (amended)
**VPs:** VP-AUTHDX-005, VP-AUTHDX-006, VP-AUTHDX-007, VP-AUTHDX-008

## Nature of this story — why the evidence looks like this

This story modifies one function, `load_api_token` (`src/api/auth.rs`), on the
credential-resolution hot path. There is no new subcommand, flag, or table
output — the observable CLI behavior is a single actionable error message
(exit 64) on the branch where a profile has no per-profile keychain
credentials, and the deeper invariant being verified (the legacy shared flat
`email`/`api-token` pair is never read, copied, or deleted) is a
keychain-internal fact that only a real-backend test can prove.

Two kinds of evidence are provided:

1. **CLI-level demo** — running the actual `jr` binary against a throwaway
   config + keychain namespace, showing the real exit-64 error message a user
   sees.
2. **Gated keyring test suite** — the authoritative evidence for the no-copy
   invariant and for every branch (both-absent, legacy-present, namespaced-
   partial), run against the real macOS Keychain Services backend from
   within a single test process.

## Recording tool status: VHS not usable; CLI demo captured via direct transcript; keychain-CLI cross-process seeding turned out to be flaky too

Per the demo-recorder protocol, VHS was the first choice for this CLI
product. It was **not attempted this time** — the prior story in this same
cycle (`S-cycle3-percred-storage`) already exhaustively diagnosed VHS's
browser-automation input layer as non-functional in this execution sandbox
(see that story's `demos/README.md` § "Recording tool status") and that
finding is a property of the sandbox, not of this story's code, so it was not
re-litigated here. Plain-text transcripts of directly-executed commands are
used instead, per that story's precedent.

**A second, unrelated instability surfaced in this pass, specific to this
story's evidence, and is documented in detail inside
`AC-001-002-003-cli-detect-and-instruct.txt`'s trailing NOTE:** seeding a
legacy flat keychain pair via the `security` CLI and then reading it back
from a *different* process (the `jr` binary) worked cleanly on the first
attempt in this session, but hung indefinitely on a second attempt later in
the session — diagnosed as a macOS `SecurityAgent` GUI confirmation dialog
queued behind an earlier one this headless sandbox has no way to answer. Once
that happened, no further live `jr`-invocation seeded via raw `security`
commands was attempted (specifically, the namespaced-partial-pair scenario
for AC-007/008/009/010 was never attempted as a live CLI demo, to avoid a
third hang). Every hung background task was stopped via TaskStop; `ps aux`
was checked afterward and confirmed zero orphaned `jr`/`security` processes;
every throwaway keychain item created during this session was individually
deleted and a final metadata-only `security dump-keychain` grep confirms none
remain. One diagnostic `security dump-keychain -d` command (which would have
echoed real secret values) was started by mistake while investigating the
hang and was killed via TaskStop within seconds, before producing any
output — no secret values were read, printed, or logged.

This is exactly why the gated `cargo test` suite (real backend, single
process, no cross-process ACL confirmation needed) is the AUTHORITATIVE
evidence for this story, not a substitute of convenience — it is immune to
the specific cross-process flakiness that hit the CLI-level demo, and it is
what the demo-recorder task brief itself designates as authoritative for
this story's keychain-internal invariants (the no-copy guarantee).

## Evidence map

| AC | BC / VP | What it proves | Evidence |
|----|---------|-----------------|----------|
| AC-001 | BC-1.4.032 postcondition 2, EC-1.4.032-1 | absent namespaced keys + legacy pair PRESENT → identical actionable exit-64 error | CLI demo Scenario 2 (`AC-001-002-003-cli-detect-and-instruct.txt`) + `test_bc_1_4_032_absent_namespaced_keys_legacy_pair_present_returns_identical_actionable_exit64` (gated suite) |
| AC-002 | BC-1.4.032 postcondition 2 | absent namespaced keys + legacy pair ABSENT → byte-identical error text | CLI demo Scenario 1 (`AC-001-002-003-cli-detect-and-instruct.txt`) + `test_bc_1_4_032_absent_namespaced_keys_no_legacy_pair_returns_actionable_exit64` (gated suite) |
| AC-003 | BC-1.4.032 invariant 1, postcondition 3 | legacy flat pair's byte content identical before/after any number of `load_api_token` calls in the absent-namespaced state — no write, no delete | CLI demo Scenario 2's BEFORE/AFTER `security find-generic-password` reads (byte-identical) + `sandbox:email`/`sandbox:api-token` confirmed never written; authoritative: `test_bc_1_4_032_no_copy_invariant_legacy_pair_untouched_and_no_percred_written` (gated suite) |
| AC-004 | BC-1.4.032 VP-AUTHDX-006 | no `"default"`-only branch — proptest over arbitrary profile names, `"default"` always included as a generated case | `prop_vp_authdx_006_no_profile_is_special_cased` + `test_bc_1_4_032_default_profile_not_special_cased_identical_to_other_profiles` (`AC-004-011-gated-keyring-test-suite.txt`) |
| AC-005 | BC-1.4.032 VP-AUTHDX-005 | proptest over arbitrary legacy `(email, token)` pairs (or none): Err with actionable message regardless of legacy state, legacy bytes unchanged, repeated calls return the same Err | `prop_vp_authdx_005_detect_and_instruct_correctness` + `test_bc_1_4_032_repeated_calls_return_same_err_no_first_call_side_effect` (`AC-004-011-gated-keyring-test-suite.txt`) |
| AC-006 | BC-1.4.032 VP-AUTHDX-007 (F6 target, MANDATORY) | end-to-end scenario against the real OS keychain backend: pre-seeded legacy pair, first post-upgrade invocation, exit-64, legacy pair byte-unchanged, no namespaced pair ever written | `test_vp_authdx_007_keyring_gated_end_to_end_detect_and_instruct_scenario` (`AC-004-011-gated-keyring-test-suite.txt`) |
| AC-007 | BC-1.4.033 postcondition 1/2 | exactly one of `<profile>:email`/`<profile>:api-token` present → distinct `Err` with the Incomplete-credentials message, never a silently-incomplete `Ok` | `test_bc_1_4_033_namespaced_partial_email_present_returns_incomplete_credentials_error`, `test_bc_1_4_033_namespaced_partial_token_present_returns_incomplete_credentials_error` (`AC-004-011-gated-keyring-test-suite.txt`) — no CLI-level demo attempted (see "Recording tool status" above) |
| AC-008 | BC-1.4.033 EC-1.4.033-1 | namespaced-partial + legacy pair also present → namespaced-partial error still fires (namespaced check runs first) | `test_bc_1_4_033_partial_precedence_over_legacy_pair_present` (`AC-004-011-gated-keyring-test-suite.txt`) |
| AC-009 | BC-1.4.033 VP-AUTHDX-008 | proptest over the 2-member namespaced partial-state set → Err + exact remediation message + no write side-effects | `prop_vp_authdx_008_namespaced_partial_state_safety` (`AC-004-011-gated-keyring-test-suite.txt`) |
| AC-010 | BC-1.4.033 invariant 2 (SR-009) | partial-write error text never names `jr auth logout` as a remediation step | `test_bc_1_4_033_remediation_message_never_mentions_auth_logout` (`AC-004-011-gated-keyring-test-suite.txt`) |
| AC-011 | BC-1.4.025 regression-confirmation clause | `load_oauth_tokens`'s existing test suite passes byte-for-byte unchanged as part of this story's PR | `AC-011-load-oauth-tokens-regression-baseline.txt` — 4/4 passed, 5.01s |
| AC-012 | BC-1.4.034 F4 doc-fallout | CHANGELOG `[Unreleased] > Changed` (Breaking) entry | Not a runtime-demoable AC — verify via `git diff` / `CHANGELOG.md` review during PR, not this evidence set |

`BC-1.4.034` (the one-time breaking-change contract) is exercised implicitly
by every scenario above: each Err is exactly what a pre-cycle-003 profile now
hits once, and `test_bc_1_4_034_single_relogin_permanently_resolves_the_breaking_change`
(gated suite) directly proves the "exactly once" shape (a single
successful namespaced write permanently resolves the failure for that
profile).

## Safety: real developer keychain and config were never touched

- Every CLI demo command used `JR_CONFIG_DIR=/tmp/jr-demo-cfg-cred-absence`
  (a throwaway directory, not `~/.config/jr/`) and a freshly-generated,
  never-reused `JR_SERVICE_NAME` value per scenario — never the compiled-in
  default `jr-jira-cli` service.
- `JR_SERVICE_NAME`/`JR_CONFIG_DIR` overrides are `#[cfg(debug_assertions)]`-
  gated and have no effect in release builds (SEC-JR-SERVICE-NAME-GATE);
  only the debug binary built in this worktree was ever invoked.
- Every throwaway keychain item created via `security add-generic-password`
  during this session was individually deleted with
  `security delete-generic-password`; a final metadata-only
  `security dump-keychain | grep jr-jira-cli-demo-cred-absence` confirms zero
  remaining items.
- The gated test suite (`AC-004-011-gated-keyring-test-suite.txt`,
  `AC-011-load-oauth-tokens-regression-baseline.txt`) self-namespaces into
  `jr-jira-cli-test-<pid>-<counter>` via `with_test_keyring`, serialized by
  `KEYRING_TEST_ENV_MUTEX` — the same isolation mechanism
  `S-cycle3-percred-storage`'s demo evidence documents.
- No source or test file was modified to produce this evidence — only files
  under this `demos/` directory and throwaway `/tmp` scratch files were
  written.

## Commands run (verbatim)

```
# CLI-level demo (both scenarios; see the .txt transcript for exact output)
JR_CONFIG_DIR=/tmp/jr-demo-cfg-cred-absence JR_SERVICE_NAME=<throwaway> \
  ./target/debug/jr issue list --profile sandbox --no-input

# Gated keyring test suite (authoritative)
JR_RUN_KEYRING_TESTS=1 cargo test --lib -- --include-ignored --test-threads=1 \
  bc_1_4_032 bc_1_4_033 bc_1_4_034 vp_authdx absence_guard_proptests
# → 14 passed; 0 failed; finished in 46.76s

# AC-011 regression baseline
JR_RUN_KEYRING_TESTS=1 cargo test --lib -- --include-ignored --test-threads=1 oauth_tokens
# → 4 passed; 0 failed; finished in 5.01s
```

## Files in this directory

| File | Description |
|------|--------------|
| `README.md` | This file |
| `AC-001-002-003-cli-detect-and-instruct.txt` | CLI-level demo transcript: both-absent (AC-002) and legacy-present (AC-001/AC-003) scenarios, plus a detailed NOTE explaining the keychain-prompt flakiness encountered and why AC-007–010 have no CLI-level demo |
| `AC-004-011-gated-keyring-test-suite.txt` | `cargo test` transcript: 14/14 tests covering AC-004 through AC-010 (both-absent, legacy-present, no-`"default"`-special-case, no-copy invariant, VP-AUTHDX-005/006/007/008, namespaced-partial branch, SR-009 message check) |
| `AC-011-load-oauth-tokens-regression-baseline.txt` | `cargo test` transcript: `load_oauth_tokens`'s existing suite, 4/4 green, confirming zero regression (BC-1.4.025) |
