# Demo Evidence — S-cycle3-percred-storage

**Story:** Per-profile API-token keychain storage: `store_api_token`/`load_api_token` (DEC-315)
**BCs:** BC-1.4.031 (new), BC-1.4.027 / BC-1.1.009 / BC-1.1.010 / BC-1.2.017 (amended)
**VP:** VP-AUTHDX-004

## Nature of this story — why the evidence looks like this

This story is an **internal keychain-storage mechanism**, not a directly CLI-visible
feature. It adds `store_api_token(profile, email, token)` / `load_api_token(profile)`
(`src/api/auth.rs`) and rewires two existing call sites (`login_token`,
`JiraClient::from_config`) to use them. There is no new subcommand, flag, or table
output to point a camera at — the observable behavior is entirely about *which
keychain keys get written/read*, so the authoritative evidence is the gated keyring
test suite executing against the **real OS keychain backend** (macOS Keychain
Services on this recording machine), not a terminal-UI walkthrough.

## Recording tool status: VHS attempted, fell back to captured transcripts

Per the demo-recorder protocol, VHS was the first choice (this is a CLI/Rust
product). It was attempted and did **not** work in this execution sandbox:

- `vhs` 0.11.0, `ttyd` 1.7.7, and headless Google Chrome (via `go-rod`) all launch
  successfully — confirmed a real headless Chrome process spawns with
  `--headless --remote-debugging-port=0 --user-data-dir=/var/folders/.../rod/user-data/...`
  and `ttyd` independently answers `curl` with `200` when run standalone.
- Despite that, **no typed keystroke ever reached the terminal.** A minimal probe
  tape (`Type "echo hello-vhs"` + `Enter`, then a fixed `Sleep`, no `Wait+Line`)
  rendered a `.gif` whose only visible content was the terminal's initial `>`
  glyph — the command was never echoed, confirming input delivery through the
  `go-rod`/CDP layer is broken in this sandbox, not a rendering or timing issue.
  Every `Wait+Line /pattern/` tape consequently timed out with
  `last value was: >`.
- This is **not** the macOS-keychain-prompt failure mode the task anticipated as a
  reason to fall back. That was checked separately and ruled out first: the exact
  `cargo test` commands below were run directly (outside VHS) multiple times and
  completed in 3-31s with **zero interactive prompts and zero hangs** — macOS did
  not challenge access to any of the throwaway `jr-jira-cli-test-*` keychain
  services these tests create. The blocker is specifically VHS's browser-automation
  input path in this sandbox.
- The two `.tape` scripts are kept in this directory as the intended recording
  source (each carries a `FALLBACK NOTE` explaining this), in case a future
  recording pass in a working VHS environment wants to reuse them verbatim — no
  source or test files were touched to work around this; only demo scripts and
  captured output were added.

**Fallback:** plain-text transcripts of the exact commands and their full output,
captured directly (not through VHS), stored alongside the `.tape` files:

- `AC-001-008-percred-storage-keyring-tests.txt`
- `AC-003-009-percred-storage-wiring-tests.txt`

## Evidence map

| AC | BC / VP | What it proves | Evidence |
|----|---------|-----------------|----------|
| AC-001 | BC-1.4.031 postcondition 1 | `store_api_token(profile, email, token)` writes `email` under `<profile>:email` and `token` under `<profile>:api-token` | `test_bc_1_4_031_api_token_email_key_default_profile`, `test_bc_1_4_031_api_token_email_key_sandbox_profile`, `test_bc_1_4_031_api_token_key_default_profile`, `test_bc_1_4_031_api_token_key_sandbox_profile`, `test_bc_1_4_031_api_token_keys_symmetric_with_oauth_key_shape` — in `AC-001-008-percred-storage-keyring-tests.txt` |
| AC-002 | BC-1.4.031 postcondition 2 | `load_api_token(profile)` returns exactly the pair written, no shared/flat fallback | `store_and_load_per_profile_api_token_round_trip`, `load_api_token_cross_profile_isolation` — in `AC-001-008-percred-storage-keyring-tests.txt` |
| AC-003 | BC-1.4.031 postcondition 3 | `JiraClient::from_config`'s `api_token` branch reads via `load_api_token(profile_name)`, never the old flat-key reader (proven by a profile with ONLY the legacy flat pair failing to authenticate) | `test_from_config_api_token_branch_reads_namespaced_never_legacy_flat` — in `AC-003-009-percred-storage-wiring-tests.txt` |
| AC-004 | BC-1.4.031 postcondition 4 | `oauth_client_id`/`oauth_client_secret` untouched by this story's diff | Not independently demoed (a diff-scope claim, not runtime behavior) — verified via `git diff` review during implementation; no `store_oauth_app_credentials`/`load_oauth_app_credentials` call sites appear in this story's commits |
| AC-005 | BC-1.4.031 VP-AUTHDX-004 | bounded-generator property test: round-trip + cross-profile isolation for any profile/email/token | `percred_proptests::prop_bc_1_4_031_round_trip_and_cross_profile_isolation` (12 cases, real keychain I/O) — in `AC-001-008-percred-storage-keyring-tests.txt` |
| AC-006 | BC-1.4.031 VP-AUTHDX-004 (F6 target) | AC-005's round-trip property proven against the **real** OS keychain backend, not a mock | Same proptest run above — `with_test_keyring` no-ops unless `JR_RUN_KEYRING_TESTS=1`, and every case in the transcript ran against real macOS Keychain Services (no mock backend is usable here per the test's own doc comment — `keyring`'s mock backend has no identity-based persistence across `Entry::new()` calls) |
| AC-007 | BC-1.4.031 EC-1.4.031-2 (I-5) | a genuine keychain BACKEND error (not `NoEntry`) propagates as its own distinct error, never coerced into "no stored credential" | `load_api_token_propagates_backend_error_not_absent_message` (simulated via an empty `JR_SERVICE_NAME`, which every backend rejects with `Err(Error::Invalid(..))` before any I/O) — in `AC-001-008-percred-storage-keyring-tests.txt` |
| AC-008 | BC-1.4.031 EC-1.4.031-1 | brand-new profile, no namespaced or legacy keys → actionable error, not a panic or silent empty success | `load_api_token_returns_err_for_missing_profile`, `load_api_token_default_profile_has_no_legacy_fallback` (proves NO `"default"`-only legacy fallback, unlike `load_oauth_tokens`) — in `AC-001-008-percred-storage-keyring-tests.txt` |
| AC-009 | BC-1.1.009 / BC-1.1.010 / BC-1.2.017 Effects clauses | `jr auth login --profile <new>` writes `<new>:email`/`<new>:api-token` via `store_api_token`, never a shared/flat pair | `test_login_token_writes_namespaced_pair_not_shared_flat` — in `AC-003-009-percred-storage-wiring-tests.txt` |

## Safety: real developer keychain was never touched

Every test above self-namespaces into a **throwaway** keychain service before
touching the OS keychain at all:

- `src/api/auth.rs::tests::with_test_keyring` / `unique_test_service()` generates
  `jr-jira-cli-test-<pid>-<counter>` and sets `JR_SERVICE_NAME` to it for the
  duration of the test (restored afterward), serialized by
  `KEYRING_TEST_ENV_MUTEX` so concurrent tests never collide.
- `tests/api_token_percred_wiring.rs::unique_service()` does the identical thing
  independently (`jr-jira-cli-test-<tag>-<pid>-<counter>`).
- The real, compiled-in default service name (`jr-jira-cli`, used by every release
  binary and by a developer's actual `jr auth login`) is never referenced by any
  of these tests. `JR_SERVICE_NAME` overrides are gated
  `#[cfg(debug_assertions)]`-only in `src/api/auth.rs::service_name()` and are
  restored to their prior value at the end of every test scope.
- No demo command in this evidence set touched `~/.config/jr/` or ran outside a
  `with_test_keyring`/`unique_service`-scoped namespace.

## Commands run (verbatim, matches the `.txt` transcripts)

```
JR_RUN_KEYRING_TESTS=1 cargo test --lib -- --include-ignored --test-threads=1 api_token_ bc_1_4_031
JR_RUN_KEYRING_TESTS=1 cargo test --test api_token_percred_wiring -- --include-ignored --test-threads=1
```

Both exited 0. 15/15 and 2/2 tests passed respectively, in 20.32s and 3.49s.

## Files in this directory

| File | Description |
|------|-------------|
| `README.md` | This file |
| `AC-001-008-percred-storage-keyring-tests.txt` | Captured transcript: `cargo test` output for AC-001/002/005/006/007/008 |
| `AC-001-008-percred-storage-keyring-tests.tape` | VHS script that was intended to record the above (non-functional in this sandbox — see FALLBACK NOTE in the file) |
| `AC-003-009-percred-storage-wiring-tests.txt` | Captured transcript: `cargo test` output for AC-003/009 |
| `AC-003-009-percred-storage-wiring-tests.tape` | VHS script that was intended to record the above (non-functional in this sandbox — see FALLBACK NOTE in the file) |
