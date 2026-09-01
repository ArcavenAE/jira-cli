---
context: bc-1
title: "Auth & Identity"
total_bcs: 71   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 60   # count of `#### BC-` headings in this file
last_updated: 2026-09-01
source_pass: 3
trace: |
  - Adversary pass-2 fix round, cycle-003 `auth-profile-dx` (2026-09-01, same day): AMENDED BC-1.6.046 (H-2 — added Ownership clause + EC-1.6.046-2, terminal display-sanitization contract for the `ENV` table cell: control-character/ANSI-escape strip + length cap), BC-1.6.047 (H-2 — Postcondition 2 split into 2a JSON-verbatim/lossless (per issue #398 convention) and 2b human-text-sanitized; EC-1.6.047-1 scope-narrowed to JSON channel only; EC-1.6.047-3 added for human-text sanitization; Invariant 3 added pinning the channel split as permanent — resolves the contradiction with bc-6's BC-6.1.015 cross-reference), BC-1.1.014 (M-1 — new EC-1.1.014-4: the O-1/SR-011 outgoing-mechanism credential-clear now fires on a non-interactive mechanism switch too, not just BC-1.1.013's interactive re-declaration; recommended informational stderr notice on such a switch), BC-1.1.013 (M-1 — EC-1.1.013-2 cross-references EC-1.1.014-4), BC-1.2.051 (L-1 — "clear-then-relogin" renamed to "relogin-then-replace" in Postcondition 1 and Invariant 2, resolving the self-contradiction with this BC's own I-6 no-clear-before-confirmed-replacement rule), BC-1.1.013 (L-2 — Invariant 2/SR-012 wording corrected: an explicit flag always DETERMINES THE OUTCOME, not necessarily that the flag's own mechanism is used — `--oauth` non-interactively determines a fail-fast exit 64 per BC-1.1.016, not oauth usage). Summary Stats table and Note recomputed (M-2): §1.1 15→16, §1.4 9→10, Total 58→60/60 HIGH; Note "69 total…11 new" → "71 total…13 new" (11 from the F2 pass + 2 from the F2-gate fix pass). No BC added or removed — total_bcs (71) and definitional_count (60) unchanged from the pre-adversary-pass-2 values; table now matches definitional_count.
  - F2-gate fix pass, cycle-003 `auth-profile-dx` (2026-09-01, same day, ADR-0020 F2-gate amendment): REDESIGNED BC-1.4.032 (no-copy detect-and-instruct, HUMAN DECISION, was copy-then-delete) and BC-1.4.033 (partial-write recovery narrowed to the namespaced-pair case only, legacy-partial branch removed since there is no more copy step to interrupt); REWROTE VP-AUTHDX-005/006/007/008 oracles for the no-copy model (VP-AUTHDX-007 relabeled a mandatory keyring-gated SCENARIO per SR-014). AMENDED BC-1.1.013 (SR-012 consolidated mechanism-selection precedence statement; O-1/SR-011 re-declaration credential-clear EC), BC-1.1.014 (SR-010 — `JR_EMAIL`/`JR_API_TOKEN` presence is no longer an independent non-interactive trigger on an interactive TTY; VP-AUTHDX-001 matrix extended with the airtight-guard cells), BC-1.2.013 (I-3/SR-015 — `auth logout` on an api-token profile emits an informational stderr notice, exit 0, not a silent no-op), BC-1.2.014 (I-4/SR-008 — credential-deletion steps reordered BEFORE config-entry removal; genuine keychain errors surfaced, not swallowed), BC-1.2.048 (O-6 — narrowed to `login`/`refresh` only; SR-013 — VP-AUTHDX-003 F6 target corrected to `refresh.rs::refresh_credentials`; O-1/SR-011 cross-ref), BC-1.2.050 (O-2/CV-2 — `--api-token` inert-with-notice on `refresh`), BC-1.2.051 (I-6 — `refresh` must not clear existing api-token creds until a replacement is confirmed obtainable), BC-1.4.031 (new EC-1.4.031-2 backend-error-vs-absent distinction, I-5; VP-AUTHDX-004 generator bounded to valid credential strings, O-3), BC-1.6.046 (new EC-1.6.046-1 — `Some("")` vs `None` table-rendering distinction, O-4). ADDED BC-1.1.016 (airtight non-interactive OAuth guard covering explicit `--oauth` and implicit oauth-method `refresh`, ADR-0020 §Decision 8/architecture-delta §2.3, closes I-1), BC-1.4.034 (one-time re-login breaking-change contract for BC-1.4.032, with F4 CHANGELOG doc-fallout obligation). BC count 69→71 (58→60 individually-bodied). See ADR-0020 (as amended 2026-09-01, F2-gate) and `.factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` (as amended 2026-09-01).
  - F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-312..325, ADR-0020, ADR-0011 amended): AMENDED BC-1.1.009/010, BC-1.2.013/014/017, BC-1.4.025/027/029, BC-1.6.046 for per-profile API-token credential storage (DEC-315), non-destructive `auth logout` + 4-step `auth remove` (DEC-322), and the `auth list` ENV column (DEC-324). ADDED BC-1.1.013/014/015 (OAuth-default-at-creation + non-interactive regression pins + runtime-default-unchanged pin, DEC-313), BC-1.2.048/049/050/051 (no-per-command-auth-switch invariant, `--oauth` deprecation, new `--api-token` flag, `auth refresh` override removal, DEC-313/321/323), BC-1.4.031/032/033 (per-profile API-token keychain functions, one-time lazy migration, partial-state handling, DEC-315), BC-1.6.047 (`env` tag JSON-shape contract, DEC-314/324). BC count 58→69 (47→58 individually-bodied). See `.factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` and `.factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`.
  - F2 spec evolution, bucket1-defects bundle (2026-08-13, issue #663): BC-1.2.018 AMENDED — carves out `auth switch` as the explicit exception to global `--profile` propagation (previous unqualified text retained inline for audit trail); BC-1.2.047 NEW — `auth switch --profile <X>` rejected with exit 64 (guard fires in `src/main.rs` before `Config::load_with`; standard `--output json` error envelope). BC count 57→58 (46→47 individually-bodied). See `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md`.
  - L2: .factory/specs/domain-spec/bc-01-auth-identity.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.1
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.1
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.8-3.9
---

# BC-1 — Auth & Identity

71 behavioral contracts across 6 subdomains: OAuth flow (1.1), Profile management (1.2),
Embedded OAuth app (1.3), Token keychain (1.4), OAuth state machine (1.5), Auth error handling (1.6).

---

## Subdomains

### 1.1 OAuth Flow & Profile Resolution

#### BC-1.1.001: `auth list` against fresh-install returns empty JSON array

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~53`
**Subject**: Auth & Identity
**Behavior**: When no `~/.config/jr/config.toml` exists (or no `[profiles.*]` keys), `jr auth list --output json` exits 0 and stdout is `[]`.
**Effects**: stdout = `[]`, exit 0, no HTTP, no keychain access.
**Edge cases**: fresh install with no config file at all.
**Error taxonomy**: none.
**Trace**: Pass 3 BC-001; L2 E-01-01

---

#### BC-1.1.002: `auth status` against fresh install exits 0 with helpful stderr

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~62`
**Subject**: Auth & Identity
**Behavior**: `jr auth status` against an uninitialized config exits 0 and prints `No profiles configured` to stderr. Supports first-run probes by setup scripts/CI.
**Edge cases**: no config.toml; no `[profiles]` section.
**Error taxonomy**: none — intentionally success.
**Trace**: Pass 3 BC-002

---

#### BC-1.1.003: `auth switch <unknown>` exits 64

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~42`
**Subject**: Auth & Identity
**Behavior**: Switching to an unknown profile exits 64 (`UserError`) with no config mutation.
**Error taxonomy**: `JrError::UserError` (exit 64).
**Trace**: Pass 3 BC-003

---

#### BC-1.1.004: `auth status --profile <unknown>` exits 64 with "unknown profile"

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~78`
**Subject**: Auth & Identity
**Behavior**: Explicit `--profile` flag naming absent profile → exit 64; stderr contains `unknown profile`.
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-004

---

#### BC-1.1.005: `auth logout --profile <unknown>` exits 64

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~98`
**Subject**: Auth & Identity
**Behavior**: Logout against unknown profile exits 64 with `unknown profile` in stderr.
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-005

---

#### BC-1.1.006: `auth remove <active>` is rejected with exit 64

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~120`
**Subject**: Auth & Identity
**Behavior**: Removing the currently-active profile exits 64 with stderr `cannot remove active`. No file changes, no keychain deletion.
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-006

---

#### BC-1.1.007: Profile resolution precedence: flag > JR_PROFILE env > config.default_profile > "default"

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~142`; `src/config.rs:~95`
**Subject**: Auth & Identity
**Behavior**: `Config::load_with(cli_profile)` resolves active profile via precedence chain. Test populates three profiles (from-config / from-env / from-flag) — flag wins. `Config.active_profile_name` set accordingly.
**Effects**: `auth list --output json` returns exactly one element with `"active": true`.
**Trace**: Pass 3 BC-007

---

#### BC-1.1.008: Global `--profile` flag propagates to `auth status` via main.rs composition

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~193`
**Subject**: Auth & Identity
**Behavior**: `jr --profile sandbox auth status` (no subcommand-level `--profile`) targets sandbox. main.rs composes effective profile via `subcmd.profile.or(cli.profile)`.
**Effects**: stderr/stdout reflect sandbox URL/name.
**Trace**: Pass 3 BC-008 → superseded by BC-030 (R1)

---

#### BC-1.1.009: `auth login --profile <new>` creates profile even when profile doesn't yet exist

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — the Effects clause's keychain-write description changes from shared/flat to per-profile-namespaced; the config-write behavior itself is unchanged.

**Confidence**: HIGH (`#[ignore]`-gated by JR_RUN_KEYRING_TESTS)
**Source**: `tests/auth_profiles.rs:~241`; ADR-0020 §Decision 1
**Subject**: Auth & Identity
**Behavior**: Login uses lenient config load (skips strict active-profile-existence check), then writes `[profiles.NEW]` with URL + auth_method.
**Effects**: writes config; writes the new profile's own `<NEW>:email`/`<NEW>:api-token` keychain pair (DEC-315) for an `api_token`-method profile, or `<NEW>:oauth-access-token`/`<NEW>:oauth-refresh-token` for an `oauth`-method profile — never a shared/flat pair.

**Previous version (superseded by DEC-315, retained for audit trail):**
> **Effects**: writes config, writes shared `email`/`api-token` keychain keys.

**Trace**: Pass 3 BC-009; F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315) — Effects amended for per-profile keychain storage; cross-reference BC-1.4.031 (new per-profile storage functions), BC-1.4.032 (REDESIGNED no-copy detect-and-instruct contract — this `auth login` writes the namespaced pair directly; it never relies on, or triggers, a migration from any pre-existing shared-key install).

---

#### BC-1.1.010: `auth login --profile X` succeeds even when JR_PROFILE points to absent profile

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — clarifies that the credential writes this login flow performs are per-profile-namespaced, not shared/flat.

**Confidence**: HIGH (`#[ignore]`-gated)
**Source**: `tests/auth_profiles.rs:~290`; ADR-0020 §Decision 1
**Subject**: Auth & Identity
**Behavior**: Login uses lenient load throughout — top-level + internal reloads in login_token/login_oauth. `JR_PROFILE=ghost` doesn't abort creation of a different profile.
**Effects**: any keychain credentials written during this flow target the profile actually being created/logged into (the `--profile X` value), namespaced per DEC-315/BC-1.4.031 — never the `JR_PROFILE`-resolved (absent) profile and never a shared/flat pair.
**Trace**: Pass 3 BC-010 → refined by BC-029 (R1); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315) — Effects clause added for per-profile keychain storage clarity.

---

#### BC-1.1.011: `auth refresh --no-input` against unconfigured profile exits 64 naming "no URL configured"

**Confidence**: HIGH
**Source**: `tests/auth_refresh.rs:~43`
**Subject**: Auth & Identity
**Behavior**: With `--no-input` AND no profile URL configured, refresh exits 64 with stderr matching `no URL configured` + `jr auth login` + `--url`. Critically: stderr does NOT contain `panic`. Credentials NOT cleared on failure.
**Error taxonomy**: `JrError::UserError`.
**Trace**: Pass 3 BC-011 → refined by BC-025 (R1)

---

#### BC-1.1.012: Malformed config TOML errors exit 78 and does NOT overwrite the file

**Confidence**: HIGH
**Source**: `tests/auth_login_config_errors.rs:~18`
**Subject**: Auth & Identity
**Behavior**: When `~/.config/jr/config.toml` is malformed, `auth login --oauth ...` exits 78. Stderr contains `toml` or `parse`. The on-disk file is byte-identical to before (no silent overwrite). This is BC-1139 from Pass 3.
**Error taxonomy**: `JrError::ConfigError` (exit 78).
**Trace**: Pass 3 BC-012; BC-1139 (R4 tightened)

---

#### BC-1.1.013: `auth login` bare and interactive defaults to OAuth, mirroring `jr init`

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5; `src/cli/init.rs::handle` (reference picker); `src/cli/auth/login.rs::handle_login` (F4 target)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313)

**Description**: `jr auth login` invoked bare (no `--oauth`/`--api-token` flag) in an interactive TTY session presents the same `["OAuth 2.0 (recommended)", "API Token"]` `dialoguer::Select` picker `jr init` already uses, defaulting the cursor to OAuth (`.default(0)`). This closes the pre-cycle-003 inconsistency where `jr init`'s picker already defaulted to OAuth while bare `jr auth login` silently defaulted to the API-token flow.

**Preconditions**:
1. `jr auth login [--profile <name>] [--url <url>]` is invoked with neither `--oauth` nor `--api-token` present.
2. Stdin is a TTY and `--no-input` is not set (interactive mode — see BC-1.1.014 for the non-interactive counterpart).

**Postconditions**:
1. The mechanism-selection picker is presented with items `["OAuth 2.0 (recommended)", "API Token"]` and `.default(0)` (OAuth pre-selected).
2. The user's selection is written as the new (or updated) profile's `auth_method` and drives which flow (`login_oauth`/`login_token`) actually runs for this invocation.
3. This is a creation-time/re-declaration event only — see BC-1.2.048 for the invariant that no *other*, later invocation may change the mechanism without going through `auth login` again.

**Invariants**:
1. Behavior is identical to `jr init`'s existing picker — no divergent copy, wording, or default between the two entry points.
2. **Creation-time mechanism-selection precedence (SR-012, consolidated statement, F2-gate fix — the single authoritative ordering for every BC in this cluster that touches mechanism selection; wording corrected, adversary pass-2 fix L-2):** explicit `--oauth`/`--api-token` flag (BC-1.2.049/BC-1.2.050) **>** non-interactive env-var/`--no-input` default (BC-1.1.014) **>** interactive OAuth-default picker (this BC). Each tier is consulted only when every tier above it does not apply: an explicit flag always DETERMINES THE OUTCOME — not necessarily that the flag's own mechanism is the one actually used. For `--api-token` this outcome is "use api_token" (the flag's mechanism runs directly); for `--oauth` under an interactive trigger this outcome is likewise "use oauth" (the flag's mechanism runs directly), but for `--oauth` under a NON-INTERACTIVE trigger the determined outcome is instead a fail-fast exit 64 per BC-1.1.016 — the flag still fully determines what happens, it just does not mean "oauth is used." Absent any explicit flag, a non-interactive trigger's api-token default applies; only when neither an explicit flag nor a non-interactive trigger is present does this BC's interactive picker run.

**Edge Cases**:
- EC-1.1.013-1: `--oauth` or `--api-token` supplied explicitly → the picker is skipped entirely; the flag's mechanism is used directly (see BC-1.2.049/BC-1.2.050).
- EC-1.1.013-2: An existing profile re-running bare interactive `auth login` re-presents the picker (still defaulting to OAuth) — this is the "re-declaration" path DEC-321/BC-1.2.051 relies on for changing a profile's mechanism. **(O-1/SR-011, F2-gate fix)** When the re-declaration selects a DIFFERENT mechanism than the profile's current `auth_method` (oauth→api_token or api_token→oauth), the OUTGOING mechanism's per-profile credentials MUST be cleared as part of the same `auth login` invocation — reusing the same per-kind clear branches `auth remove` uses (`clear_profile_creds`'s OAuth-pair and API-token-pair deletion, ADR-0020 §Decision 7 / BC-1.2.014) — before or alongside writing the new mechanism's credentials. This prevents a stale, unreachable-but-still-present secret (e.g. an abandoned OAuth refresh token on a profile that switches to api-token) from lingering in the keychain indefinitely. A SAME-mechanism re-declaration (oauth→oauth, api_token→api_token) is a plain overwrite via the existing `store_api_token`/`store_oauth_tokens` write — no separate clear step is needed, since the write already replaces the prior value in place. **(M-1, adversary pass-2 fix)** This clear-on-mechanism-change requirement is NOT limited to this EC's interactive re-declaration path — it applies identically when a mechanism change is reached via BC-1.1.014's non-interactive default path; see BC-1.1.014 EC-1.1.014-4 for that case, which this EC's clear mechanism is shared with verbatim.

**Verification Properties**: None dedicated to this BC. **[TRIAGED 2026-09-01, F2 VP-delta pass]** The original draft candidate (bare interactive `auth login` → picker shown, default cursor index 0) is an example-based UI-presentation assertion (specific picker text/default-selection behavior), not an invariant or property — DEMOTED to an ordinary F4 test acceptance criterion anchored directly to this BC's Postcondition 1 (test-writer implements as a standard `dialoguer::Select` presentation/default-index unit test, no proptest/Kani/trybuild warranted). EC-1.1.013-2's re-declaration credential-clear guarantee (O-1/SR-011) is likewise an ordinary F4 test acceptance criterion (assert the outgoing mechanism's keychain keys are absent after a mechanism-switching re-declaration), not a dedicated VP — it reuses `auth remove`'s already-tested per-kind clear branches rather than introducing new clearing logic.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; ADR-0020 §Decision 5; F2-gate fix (2026-09-01) — SR-012 consolidated precedence Invariant added, O-1/SR-011 re-declaration credential-clear requirement added to EC-1.1.013-2; cross-reference `src/cli/init.rs::handle` (model implementation), BC-1.2.014 (the per-kind clear branches this EC reuses), BC-1.2.048 (the general mechanism-is-intrinsic invariant this EC's clear step keeps honest).

---

#### BC-1.1.014: `auth login` in non-interactive mode always selects API-token and never launches a browser

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5 (regression-safety pin); `src/cli/auth/login.rs::handle_login` (F4 target)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313) — regression-safety contract

**Description**: This is a negative-space contract pinning DEC-313's explicit "CI stays token-first" guarantee: introducing an OAuth-default picker for the interactive path (BC-1.1.013) must never cause a non-interactive invocation to attempt OAuth (which would require a browser and is unrunnable in CI/automation).

**Preconditions**:
1. `jr auth login` is invoked with neither `--oauth` nor `--api-token`, AND at least one of: `--no-input` is set, or stdin is not a TTY. **(SR-010, HUMAN DECISION, F2-gate fix — reverses the original draft's third disjunct)** `JR_EMAIL`/`JR_API_TOKEN` presence, BY ITSELF, on an otherwise-interactive TTY session with neither `--no-input` nor non-TTY stdin, is NOT a non-interactive trigger — it does NOT suppress BC-1.1.013's picker. An interactive TTY session always shows the OAuth-default picker regardless of whether `JR_EMAIL`/`JR_API_TOKEN` happen to be set in the environment; those env vars matter only as the CREDENTIAL SOURCE once a non-interactive trigger (`--no-input`/non-TTY) already applies, never as an independent trigger of their own. This removes the original design's standalone "env vars present → api_token even on a TTY" behavior.

**Postconditions**:
1. The mechanism-selection picker (BC-1.1.013) is NOT presented.
2. The profile's `auth_method` is set to `api_token` and `login_token`'s flow runs.
3. No browser is launched under any circumstance reachable via this precondition set.

**Invariants**:
1. This is a byte-for-byte-unchanged guarantee relative to pre-cycle-003 non-interactive `auth login` behavior — BC-1.1.013's new interactive default must not regress this path.

**Edge Cases**:
- EC-1.1.014-1: `--no-input` set but `JR_EMAIL`/`JR_API_TOKEN` absent and no `--email`/`--token` flags supplied → falls through to the pre-existing non-interactive credential-resolution error path (unchanged), not a picker.
- EC-1.1.014-2: stdin redirected from a file/pipe (non-TTY) without `--no-input` explicitly passed → still classified non-interactive; same guarantee applies (mirrors `main.rs`'s existing auto-`--no-input` TTY detection).
- EC-1.1.014-3 (SR-010, F2-gate fix): an INTERACTIVE TTY session (no `--no-input`, stdin IS a TTY), with `JR_EMAIL`/`JR_API_TOKEN` BOTH set in the environment, and neither `--oauth` nor `--api-token` supplied → BC-1.1.013's picker IS presented; `auth_method` is NOT silently forced to `api_token` by env-var presence alone. This is the negative-space case pinning SR-012's precedence table (BC-1.1.013 Invariant 2): env-var presence sits below the interactive-picker tier, not above it.
- EC-1.1.014-4 (M-1, adversary pass-2 fix — non-interactive mechanism switch must not orphan outgoing credentials): when this BC's Precondition 1 fires against an EXISTING profile whose CURRENT `auth_method` is `oauth` (e.g. `jr auth login prod` run in CI, where `prod.auth_method == "oauth"` from a prior interactive setup), Postcondition 2's unconditional set of `auth_method = api_token` is a MECHANISM CHANGE, not a first-time declaration — identical in kind to BC-1.1.013 EC-1.1.013-2's interactive re-declaration case, just reached non-interactively. The O-1/SR-011 outgoing-mechanism credential-clear (BC-1.1.013 EC-1.1.013-2, reusing `clear_profile_creds`'s OAuth-pair deletion branch, ADR-0020 §Decision 7 / BC-1.2.014) is NOT scoped to the interactive path only: it MUST fire identically here — `prod:oauth-access-token`/`prod:oauth-refresh-token` MUST be cleared as part of this same non-interactive `auth login` invocation, before or alongside writing the new `api_token` credentials, so the outgoing OAuth refresh token never lingers, unreachable, in the keychain. A SAME-mechanism non-interactive re-run (`auth_method` already `api_token`) is an ordinary overwrite — no clear step needed, mirroring BC-1.1.013 EC-1.1.013-2's same-mechanism case. **(Recommended, not a MUST)**: because this switch can happen with no picker and no confirmation prompt possible non-interactively, `handle_login` SHOULD additionally emit an informational stderr notice when an existing profile's `auth_method` changes via this non-interactive path, e.g. `"Profile '<profile>' auth method changed from 'oauth' to 'api_token'."`, so the flip is observable to whoever/whatever is running the script rather than being entirely silent. Unlike the credential-clear requirement (a MUST, mirroring O-1/SR-011's existing severity), the stderr notice is a SHOULD.

**Verification Properties**:
- **VP-AUTHDX-001 — Non-interactive invocation never launches the OAuth browser flow (SAFETY INVARIANT, PROMOTED 2026-09-01, F2 VP-delta pass, merges draft candidates VP-cycle3-002/003; CORRECTED and MATRIX-EXTENDED same day at the F2 gate — SR-010 fixes the trigger set, ADR-0020 §Decision 8/architecture-delta §2.3 add two new cells closing adversarial finding I-1).**
  **Property, base case (`auth login`, no explicit flag):** for ANY non-interactive trigger condition in the 2-member set `{--no-input set, stdin not a TTY}` — `JR_EMAIL`/`JR_API_TOKEN` presence is REMOVED from this trigger set per SR-010 (see the negative-space cell below) — crossed with any credential-completeness state, `jr auth login` invoked with neither `--oauth` nor `--api-token` NEVER binds an OAuth callback listener on port 53682 and NEVER attempts to open a browser; the resolved `auth_method` is always `api_token`.
  **Property, negative-space cell (SR-010):** an INTERACTIVE TTY session (no `--no-input`, stdin IS a TTY) with `JR_EMAIL`/`JR_API_TOKEN` both present MUST still present BC-1.1.013's picker — `auth_method` is never silently forced to `api_token` by env-var presence alone. This cell exists specifically to catch a regression of the original (pre-F2-gate) design, which incorrectly treated env-var presence as an independent, TTY-overriding trigger.
  **Property, extended cells (ADR-0020 §Decision 8 / architecture-delta §2.3, closes adversarial finding I-1):** (1) `jr auth login --oauth` (the explicit, deprecated-alias flag), invoked under ANY non-interactive trigger → exit 64, stderr `"OAuth requires an interactive terminal; use --api-token for non-interactive auth."`, and NEVER binds the callback listener or opens a browser — a FAIL-FAST exit, not a silent api-token substitution (contrast with the base case, which has no explicit flag to override). (2) `jr auth refresh` against a profile whose stored `auth_method == "oauth"` (no flag needed — implicit selection), invoked under ANY non-interactive trigger → the identical exit-64 failure, identical message, and the identical NEVER-launches guarantee. Both extended cells are declared in full at BC-1.1.016 (the airtight non-interactive OAuth guard) — cited here, not duplicated, per this corpus's VP-declared-once convention.
  This is regression-critical per F1 delta-analysis §3 (a CI-breaking regression class: a script or agent running `jr` non-interactively must never hang waiting on a browser redirect, and — per the extended cells — must never even reach that hang via an explicit flag or an oauth-method profile's `refresh`).
  **Verification method**: property test (`proptest`) enumerating the 2-member non-interactive trigger set × credential-presence/absence for the base case, asserting `no_browser_launched` and `auth_method == "api_token"`; a dedicated negative-space test for the SR-010 cell (interactive TTY + env vars present → picker IS shown, mechanism NOT forced); and the extended-cell proptests declared at BC-1.1.016 covering the `--oauth`-explicit and implicit-oauth-profile-`refresh` matrix cells. Fixed regression seeds retained: (a) `--no-input --email <e> --token <t>`, (b) CI-style non-TTY stdin with `JR_EMAIL`/`JR_API_TOKEN` set, (c) interactive TTY with `JR_EMAIL`/`JR_API_TOKEN` set (SR-010 negative-space seed). **F6 target**: `src/cli/auth/login.rs::handle_login`, `src/cli/auth/refresh.rs::refresh_credentials` (extended cells).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; ADR-0020 §Decision 5; F2-gate fix (2026-09-01, SR-010) — Precondition 1's third disjunct reversed (env-var presence no longer an independent trigger on an interactive TTY), EC-1.1.014-3 and VP-AUTHDX-001's negative-space cell added; ADR-0020 §Decision 8 / architecture-delta §2.3 (closes I-1) — VP-AUTHDX-001 extended with the two airtight-guard cells, declared in full at BC-1.1.016; adversary pass-2 fix (2026-09-01, M-1) — EC-1.1.014-4 added, extending the O-1/SR-011 outgoing-mechanism credential-clear to the non-interactive mechanism-switch path (previously anchored only to BC-1.1.013's interactive re-declaration); cross-reference BC-1.1.013 (interactive counterpart, SR-012 precedence table; EC-1.1.013-2 now cross-refs back to EC-1.1.014-4), BC-1.1.011 (related non-interactive failure path, unaffected by this BC), BC-1.1.016 (the airtight guard for explicit-flag and implicit-oauth-profile `refresh`).

---

#### BC-1.1.015: `JiraClient::from_config`'s `.unwrap_or("api_token")` runtime default for an unset `auth_method` is unchanged

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5 (regression pin); `src/api/client.rs::JiraClient::from_config`
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313) — regression-safety pin

**Description**: DEC-313 makes OAuth the default at profile-*creation* time (BC-1.1.013), but explicitly does NOT change the fallback `jr` uses at *runtime* when a profile's `auth_method` field is absent altogether (e.g. a hand-edited config, or any future code path that omits it). This BC pins that the two are independent: the creation-time UX default and the runtime absent-field default are allowed to differ, and this cycle intentionally leaves the runtime default unchanged.

**Preconditions**:
1. A `ProfileConfig` exists with `auth_method: None` (field entirely absent or explicitly null in `config.toml`).
2. `JiraClient::from_config` is called for that profile.

**Postconditions**:
1. `let auth_method = profile.and_then(|p| p.auth_method.as_deref()).unwrap_or("api_token")` resolves to `"api_token"` — byte-for-byte identical to pre-cycle-003 behavior.
2. `jr` attempts api-token (Basic) auth using the profile's stored per-profile api-token credential — or, if absent, surfaces BC-1.4.032's actionable detect-and-instruct error (never a copied/migrated legacy credential) — never a silent OAuth attempt against absent tokens.

**Invariants**:
1. This fallback is deliberately conservative: an unset `auth_method` must never silently attempt to launch an OAuth browser flow at HTTP-client-construction time.
2. `Config::base_url`'s `profile.auth_method.as_deref() == Some("oauth")` branch is unaffected by this BC — it already reads the intrinsic per-profile field and has no absent-field ambiguity to resolve.

**Edge Cases**:
- EC-1.1.015-1: a profile created via BC-1.1.013's new OAuth-default picker always has `auth_method` explicitly set to `"oauth"` or `"api_token"` — this BC's absent-field path is unreachable for profiles created through the new creation flow; it remains reachable only via hand-edited config or legacy profiles predating `auth_method`'s introduction.

**Verification Properties**:
- **VP-AUTHDX-002 — Runtime-default-unchanged regression pin (PROMOTED 2026-09-01, F2 VP-delta pass, was VP-cycle3-004).** Property: for a `ProfileConfig` with `auth_method` absent/`None` (any TOML shape that produces this — key omitted entirely, or explicitly `null`), `JiraClient::from_config`'s `.unwrap_or("api_token")` resolves to exactly `"api_token"`, byte-for-byte identical to the pre-cycle-003 value, regardless of any other field on the profile (url, env, cloud_id). Promoted because this is the exact mechanism DEC-313 requires must NOT flip, and a silent regression here (e.g. a future refactor changing the fallback literal) would misroute existing hand-edited or legacy configs into an unintended OAuth attempt. **Verification method**: property test (`proptest`, arbitrary `ProfileConfig` field combinations holding `auth_method: None` fixed) asserting the resolved value is always `"api_token"`; a literal string-pin unit test is retained as the fixed regression seed. **F6 target**: `src/api/client.rs::JiraClient::from_config`.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; ADR-0020 §Decision 5 (verbatim regression-pin language); cross-reference BC-1.1.013/BC-1.1.014 (creation-time vs. runtime-default distinction).

---

#### BC-1.1.016: Non-interactive OAuth guard fails fast for explicit `--oauth` and implicit oauth-method `refresh` — never just the no-flag default

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 8; architecture-delta §2.3; `src/cli/auth/login.rs::handle_login`, `src/cli/auth/refresh.rs::refresh_credentials` (F4 targets)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, F2-gate hardening — closes adversarial finding I-1)

**Description**: BC-1.1.014 pins that the no-explicit-flag DEFAULT path never launches OAuth non-interactively. That check alone leaves a gap: `jr auth login --oauth` (the explicit, deprecated-alias flag) or `jr auth refresh` against an already-oauth-method profile, invoked non-interactively, would still attempt the full 3LO flow — binding the callback listener on port 53682 and/or trying to open a browser with no human present to complete the redirect. In CI this hangs, or fails unpredictably far downstream, instead of failing fast at the command boundary. This BC closes that gap: ANY non-interactive trigger combined with EITHER an explicit `--oauth` flag OR an implicit oauth-method-profile `refresh` selection MUST fail fast, before any network/listener/browser code is reached.

**Preconditions**:
1. A non-interactive trigger state holds: `--no-input` is set, OR stdin is not a TTY.
2. EITHER (a) `jr auth login --oauth …` or `jr auth refresh --oauth …` is invoked (the explicit, deprecated-alias flag is present), OR (b) `jr auth refresh <profile>` is invoked (no flag, or an inert `--api-token`, per BC-1.2.051) against a profile whose stored `auth_method == "oauth"`.

**Postconditions**:
1. The command exits 64 (`JrError::UserError`).
2. Stderr is exactly: `"OAuth requires an interactive terminal; use --api-token for non-interactive auth."` — a fixed constant string, no value interpolation.
3. The callback listener (port 53682) is NEVER bound, and no browser-open call is ever made — this check is a precondition evaluated BEFORE any network call, listener setup, or browser-open attempt in both `auth login`'s and `auth refresh`'s handlers, not a timeout on, or best-effort cancellation of, an already-started flow.
4. `--output json` gets the same `{"error": "<message>", "code": 64}` envelope as any other exit-64 UserError (per the #526 JSON-render invariant).

**Invariants**:
1. This guard is strictly broader than BC-1.1.014's — BC-1.1.014 covers the no-flag DEFAULT (which silently substitutes `api_token`, not a hard failure); this BC covers every OTHER non-interactive path that would otherwise reach the OAuth flow (explicit flag, or an already-oauth profile's implicit `refresh` selection), all of which fail fast rather than substitute.
2. The guard fires identically whether the OAuth provider would have been reachable or not at the network layer — it depends only on the interactivity/flag/profile-mechanism state, never on network reachability.

**Edge Cases**:
- EC-1.1.016-1: `jr auth login --oauth` non-interactively for a BRAND NEW profile (no prior `auth_method`) → still fails fast per Precondition 2(a); this BC does not carve out an exception for profile creation.
- EC-1.1.016-2: `jr auth refresh <profile>` non-interactively where `<profile>.auth_method == "api_token"` → this BC's Precondition 2(b) does NOT match (no explicit `--oauth` flag, and the profile's own mechanism is api_token) — refresh proceeds via the ordinary api-token relogin path, unaffected.
- EC-1.1.016-3: `jr auth refresh --api-token <profile>` where `<profile>.auth_method == "oauth"`, invoked non-interactively → Precondition 2(b) still matches ("implicit oauth-method profile `refresh` selection," since `--api-token` has no override power per BC-1.2.051 and the profile's own stored mechanism is what actually gets selected) — this BC's fail-fast guard fires despite the (inert) `--api-token` flag being present.

**Verification Properties**:
- Declared, in full, as the two extended cells of **VP-AUTHDX-001** (BC-1.1.014) — not duplicated here. VP-AUTHDX-001's extended-cell proptest matrix directly covers this BC's Preconditions 2(a) and 2(b).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, F2-gate hardening pass); ADR-0020 §Decision 8; architecture-delta §2.3 (concrete decision-point flowchart); resolves adversarial finding I-1; cross-reference BC-1.1.014 (the narrower no-flag-default sibling this BC extends), BC-1.2.048/BC-1.2.051 (the `auth_method`-is-intrinsic invariant this guard's "implicit oauth-method profile" branch depends on).

---

### 1.2 Profile Lifecycle Management

#### BC-1.2.013: `auth logout` is a non-destructive, OAuth-session-clear-only operation — preserves the profile entry and all non-OAuth-session credentials

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-322; RE-AMENDED same day at the F2 gate, I-3/SR-015)** — restates `logout`'s scope as an explicit, deliberate design decision (session-clear only) now that DEC-315 removes the single "shared keys" bucket the previous wording relied on; also confirms `logout` remains OAuth-specific by design (does not grow API-token-clearing behavior — resolves F1 Open Question 6). The F2-gate fix additionally requires an informational stderr notice on an api-token profile, replacing the original design's silent no-op.

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/api/auth.rs:~24, 88-97`; `src/cli/auth/logout.rs::handle_logout`; ADR-0020 §Decision 7
**Subject**: Auth & Identity
**Behavior**: Deletes `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token` via `delete_credential`. Profile config entry is preserved in full — `url`, `cloud_id`, `env`, and (for an `api_token`-method profile) the per-profile `<profile>:email`/`<profile>:api-token` pair are all PRESERVED, not cleared. The shared/flat `oauth_client_id`/`oauth_client_secret` (BYO OAuth **app**-credential pair) are also untouched — a different axis entirely. Re-login (`jr auth login <profile>`, no flags needed) needs no re-entry of URL/email/token for an `api_token` profile, since those survive `logout` intact.
**Effects**: `jr auth logout` on an `api_token`-method profile is a no-op with respect to that profile's credentials — by design, not by omission (ADR-0020 §Decision 7): "logout" is a session-clear concept (ending a live OAuth session while keeping the profile ready for frictionless re-login); API-token auth has no session to end. Deleting the API-token credential outright is `auth remove`'s job (BC-1.2.014, amended), not `logout`'s.

**Informational notice, not a silent no-op (I-3/SR-015, F2-gate fix):** `jr auth logout` against an `api_token`-method profile MUST emit an informational message to stderr rather than exiting silently: `"This profile uses API-token auth — nothing to log out; use \`jr auth remove <profile>\` to delete stored credentials."` (profile name interpolated in place of `<profile>`). Exit code is **0** — this is a successful, expected outcome for this profile kind, not an error; the message exists purely so a human or script watching stderr can tell the command genuinely had nothing to clear, rather than silently succeeding with no observable signal at all. Under `--output json`, the notice is stderr-only (never stdout), consistent with the Output-channels convention and the #526 JSON-render invariant — a JSON consumer sees exit 0 and no stdout payload change from the pre-fix no-op behavior.

**Previous version (superseded by DEC-315/DEC-322 restatement, retained for audit trail):**
> **Behavior**: Deletes `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token` via `delete_credential`. Profile config entry preserved. Shared keys (`email`, `api-token`, `oauth_client_id`, `oauth_client_secret`) untouched. Re-login uses preserved API-token/OAuth credentials.

**Trace**: Pass 3 BC-013-R; F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-322) — restated as explicit session-clear-only design decision; ADR-0020 §Decision 7 resolves F1 Open Question 6; F2-gate fix (2026-09-01, I-3/SR-015) — informational stderr notice added, replacing the silent no-op; cross-reference BC-1.2.014 (amended — `remove`'s full-delete contrast, itself F2-gate-fixed for step ordering), BC-1.4.031 (per-profile api-token pair this BC now explicitly preserves), BC-1.4.033 (SR-009 — this BC's non-destructive contract is why `jr auth logout` is removed from that BC's remediation message).

---

#### BC-1.2.014: `auth remove <name>` performs four-step delete, credentials before config entry: OAuth tokens, API-token credential pair, cache directory, config entry

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-322; RE-AMENDED same day at the F2 gate, I-4/SR-008)** — gains a fourth delete step for the new per-profile `<name>:email`/`<name>:api-token` pair (DEC-315), making `remove`'s "delete everything this profile owns" contract symmetric across both credential kinds. The F2-gate fix additionally REORDERS the four steps so credential deletion happens BEFORE config-entry removal, and tightens error handling so a genuine (non-`NoEntry`) keychain error aborts the command rather than being silently swallowed.

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/cli/auth/remove.rs::handle_remove`; `src/cache.rs:~82`; `tests/auth_profiles.rs:~120`; ADR-0020 §Decision 7
**Subject**: Auth & Identity
**Behavior**: Errors if name == active (exit 64 first, before any step runs). Then four steps, in this ORDER (I-4/SR-008, F2-gate fix — credential deletion now precedes config-entry removal, so a failure partway through leaves the profile's config entry intact and re-`remove`-able): (1) delete `<name>:oauth-access-token`/`<name>:oauth-refresh-token` keychain keys, (2) delete `<name>:email`/`<name>:api-token` keychain keys (DEC-315), (3) `cache::clear_profile_cache(name)` removes `~/.cache/jr/v1/<name>/` (no-op if absent), (4) remove `[profiles.<name>]` from config — LAST, only after every credential-deletion step above has completed without a surfaced error. `clear_profile_creds`/`clear_all_credentials` (`src/api/auth.rs`) each gain the per-profile API-token pair as an additional deletable-key branch. **Error-surfacing tightened (I-4/SR-008):** a `keyring::Error::NoEntry` result on any individual key-delete is treated as success (the credential is already absent — nothing to do), exactly as before; but any OTHER (genuine backend) keychain error — permission denied, backend unavailable — now ABORTS the command with that error surfaced to the user, non-zero exit, and does NOT proceed to steps 3/4. This replaces the prior "all four steps are best-effort, partial state does not cascade" framing for the two credential-deletion steps specifically: a real backend error is no longer silently swallowed. Cache-directory removal (step 3) remains best-effort (a stale cache dir is a low-stakes leftover, unlike a lingering credential).
**Effects**: after `auth remove <name>` succeeds, NEITHER credential kind survives for that profile — this makes `remove` (not `logout`, see BC-1.2.013 amended) the sole full-delete operation for API-token credentials. Because config-entry removal is now the LAST step, a command that aborts on a genuine keychain error leaves `[profiles.<name>]` in place — the user can re-run `jr auth remove <name>` after resolving the backend problem, and the retry re-attempts every credential-deletion step (some of which may already report `NoEntry`-success from the first, partially-completed attempt) before finally removing the config entry. **No namespaced credential survives a recreated same-named profile (I-4/SR-008 completeness guarantee):** because ALL FOUR steps — including both credential-deletion steps — complete (or are confirmed already-absent) before the config entry is removed, a later `jr auth login <name>` recreating a profile with the same name never inherits a leftover namespaced credential from a prior profile's incomplete removal; the two credential-deletion steps are independently, exhaustively attempted regardless of which keys happen to still be present.

**Previous version (superseded by DEC-315, retained for audit trail):**
> **Behavior**: Three-step: (1) remove `[profiles.<name>]` from config, (2) delete `<name>:oauth-*` keychain keys, (3) `cache::clear_profile_cache(name)` removes `~/.cache/jr/v1/<name>/`. Step (3) is no-op if dir absent. All three are best-effort; partial state does not cascade. Errors if name == active (exit 64 first).

**Previous version (superseded by F2-gate fix I-4/SR-008, retained for audit trail):**
> **Behavior**: Four steps: (1) remove `[profiles.<name>]` from config, (2) `cache::clear_profile_cache(name)` removes `~/.cache/jr/v1/<name>/` (no-op if absent), (3) delete `<name>:oauth-access-token`/`<name>:oauth-refresh-token` keychain keys, (4) delete `<name>:email`/`<name>:api-token` keychain keys (NEW, DEC-315). All four steps are best-effort; partial state does not cascade.

**Edge Cases**:
- EC-1.2.014-1 (I-4/SR-008, F2-gate fix): a genuine keychain backend error on step 1 or step 2 (e.g. Secret Service unavailable) → command aborts before steps 3/4 run; `[profiles.<name>]` remains in config; a re-run of `jr auth remove <name>` is the documented recovery path once the backend issue is resolved.
- EC-1.2.014-2 (I-4/SR-008, F2-gate fix): both credential-deletion steps report `NoEntry` (the profile had no stored credentials of either kind — e.g. it was already partially cleaned up by a prior failed attempt) → treated as success for both steps; the command proceeds to cache-clear and config removal normally.

**Verification Properties**:
- VP-1.2.014-001 (I-4/SR-008, F2-gate fix): a simulated genuine (non-`NoEntry`) keychain error injected at the OAuth-pair or API-token-pair delete step aborts `handle_remove` before the config entry is removed; `[profiles.<name>]` is still present in config after the aborted call; both credential-deletion steps are independently re-attempted on a subsequent retry.

**Trace**: Pass 3 BC-014-R; F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315/DEC-322) — fourth delete step added; ADR-0020 §Decision 7; F2-gate fix (2026-09-01, I-4/SR-008) — step order reversed (credentials before config entry) and real keychain errors surfaced rather than swallowed; cross-reference BC-1.2.013 (amended — `logout`'s narrower, non-destructive contrast, and its own I-3/SR-015 fix), BC-1.4.031 (the per-profile pair now deleted here).

---

#### BC-1.2.015: `auth refresh --help` includes the `--oauth` flag

**Confidence**: HIGH
**Source**: `tests/auth_refresh.rs:~7`
**Subject**: Auth & Identity
**Behavior**: `jr auth refresh --help` exits 0; stdout contains both `refresh` and `--oauth`.
**Trace**: Pass 3 BC-026 (R1)

---

#### BC-1.2.016: `auth refresh --oauth --help` is accepted in either flag order

**Confidence**: HIGH
**Source**: `tests/auth_refresh.rs:~26`
**Subject**: Auth & Identity
**Behavior**: clap accepts both `--oauth --help` and `--help --oauth`, exit 0.
**Trace**: Pass 3 BC-027 (R1)

---

#### BC-1.2.017: `auth login --profile X` against `JR_PROFILE=ghost` succeeds creating profile X

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — clarifies per-profile keychain writes for this flow. (Note: the F1 delta analysis' impact table cites this contract as "BC-1.1.017"; this file has no BC-1.1.017 — the intended reference is this BC, BC-1.2.017, which covers the identical `auth login --profile X` lenient-load creation flow the F1 report describes. Reconciled here; flagged for the integrate pass.)

**Confidence**: HIGH (`#[ignore]`-gated)
**Source**: `tests/auth_profiles.rs:~282`; ADR-0020 §Decision 1
**Subject**: Auth & Identity
**Behavior**: Round-5 regression fix. Both internal reloads in login flow use `load_lenient_with`. Test sets `JR_PROFILE=ghost`, runs `jr auth login --profile fresh --url https://fresh.example`, asserts `[profiles.fresh]` written.
**Effects**: keychain credentials written for `fresh` target `fresh:email`/`fresh:api-token` (or `fresh:oauth-*`), namespaced per DEC-315/BC-1.4.031 — never a shared/flat pair, and never the absent `ghost` profile's namespace.
**Trace**: Pass 3 BC-029 (R1); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315) — Effects clause added; ID-reconciliation note re: F1 report's "BC-1.1.017" citation.

---

#### BC-1.2.018: Global `--profile` propagates to all auth subcommands EXCEPT `auth switch` (rejected, exit 64) — composed via `subcmd.profile.or(cli.profile)` for Login/Status/Refresh/Logout, passed through directly for List/Remove

**STATUS: UPDATED (2026-08-13, issue #663)** — carves out `auth switch` as an explicit exception to the propagation rule this BC previously stated unconditionally. Previous (pre-#663) version retained below for audit trail.

**Confidence**: HIGH
**Source**: `tests/auth_profiles.rs:~188`; `src/main.rs` (`AuthCommand::Switch` guard, new — see BC-1.2.047; `AuthCommand::List`/`Remove` dispatch arms, pre-existing, unaffected)
**Subject**: Auth & Identity
**Behavior**: Round-10 regression fix. `main.rs` composes `subcmd.profile.or(cli.profile)` for `AuthCommand::Login`, `Status`, `Refresh`, and `Logout` — each of these four declares its own subcommand-level `profile: Option<String>` field to compose with. **[CLARIFIED 2026-08-13, adversary pass-1 LOW-2]** `AuthCommand::List` and `AuthCommand::Remove` have NO subcommand-level `profile` field at all — for these two, `cli.profile.as_deref()` is passed straight through with no `.or()` step (there is nothing else to compose against). They still HONOR the global `--profile` flag, via this simpler direct-pass-through mechanism rather than the four-way `.or()` composer. **`auth switch` is the sole exception to "the global flag has effect at all"**: it also has no subcommand-level `profile` field, but as of issue #663 the global `--profile` flag is REJECTED outright (exit 64) rather than passed through — see BC-1.2.047 for the full rejection contract. Do not read "sole exception" as implying `List`/`Remove` ignore `--profile` — they honor it; only `Switch` rejects it.

**Previous version (superseded by issue #663, retained for audit trail):**
> **Behavior**: Round-10 regression fix. main.rs now composes `subcmd.profile.or(cli.profile)`.
>
> (Unqualified — no `auth switch` carve-out. Pre-#663, `--profile` was silently accepted on `auth switch` and had no effect on the switch target, its only side effect being an extra existence-check constraint inside `Config::load_with`. See research brief `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md` §1.4 for the confirmed no-op mechanism this reversed-to-rejection replaces.)

**Trace**: Pass 3 BC-030 (R1); F2 amended (2026-08-13, issue #663) — `auth switch` carve-out; see BC-1.2.047; F2 adversary pass-1 fix round (2026-08-13, LOW-2) — title/Behavior clarified so `List`/`Remove`'s direct-pass-through propagation is not misread as unaffected-by-omission; `Switch` remains the only subcommand where `--profile` is rejected rather than honored

---

#### BC-1.2.047: `auth switch --profile <X>` is rejected with exit 64 — the switch target is the positional `<NAME>` only

**Confidence**: HIGH
**Source**: `src/main.rs` (`AuthCommand::Switch` dispatch arm, guard fires before `Config::load_with`); `src/cli/auth/switch.rs::handle_switch`; research brief `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md`
**Subject**: Auth & Identity
**Origin**: NEW (issue #663)

**Description**: `auth switch` takes its target profile from the required positional `<NAME>` only — it has no subcommand-level `profile: Option<String>` field (unlike `Login`/`Status`/`Refresh`/`Logout`, each of which composes `subcmd.profile.or(cli.profile)` per BC-1.2.018). Before #663, the GLOBAL `--profile` flag (declared `global = true` on `Cli`, propagated by clap to every subcommand including `auth switch`) was silently accepted but had no effect on the switch target — its only observable side effect was forcing `Config::load_with`'s active-profile-existence check to additionally validate the flag's value, producing the confusing `jr auth switch --profile X X` incantation the issue reports. This BC replaces that silent no-op with an explicit rejection.

**Preconditions**:
1. `jr auth switch <NAME>` is invoked with the global `--profile` flag also supplied (`jr auth switch --profile <X> <NAME>`, in either flag/positional order).

**Postconditions**:
1. The guard fires in `src/main.rs`, in the `AuthCommand::Switch` dispatch arm, BEFORE `Config::load_with` is called — so a nonexistent `--profile` value does NOT first trip `Config::load_with`'s active-profile existence-check side effect. The rejection is unconditional on `cli.profile.is_some()`, independent of whether `<X>` or `<NAME>` name real profiles.
2. Exit code 64 (`JrError::UserError`).
3. **Human mode** (stderr): `--profile is not valid for 'auth switch'. The profile to activate is the positional argument. Try: jr auth switch <NAME>` — a fixed constant string, no value interpolation.
4. **`--output json`**: the standard `{"error": "<message>", "code": 64}` envelope (per the #526 JSON render invariant — no bespoke formatter; this flows through the same central error handler as every other exit-64 `UserError` in `jr`).
5. No config read/write and no keychain access occurs — the guard fires before any of `handle_switch`'s three steps (`Config::load_with`, `handle_switch_in_memory`, `config.save_global()`).

**Invariants**:
1. This guard is `Switch`-only. `AuthCommand::Login`/`Status`/`Refresh`/`Logout` are unaffected — each continues to compose `subcmd.profile.or(cli.profile)` exactly as BC-1.2.018 (amended) describes. `AuthCommand::List`/`Remove` are also unaffected — they continue to pass `cli.profile.as_deref()` straight through with no `.or()` composition (BC-1.2.018's LOW-2 clarification): `--profile` remains fully honored on both, never rejected.
2. The positional `<NAME>` remains the sole way to specify the switch target; this BC does not change `handle_switch_in_memory`'s write logic. BC-1.1.003's unknown-profile exit-64 path is unaffected — it fires on a bad positional; this BC fires on a supplied `--profile` flag regardless of positional validity.

**Edge Cases**:
- EC-1.2.047-1: `jr auth switch --profile foo foo` (both real profiles — the "confusing incantation" the issue reports) → still exits 64; the flag is rejected regardless of whether its value coincides with the positional or names a real profile.
- EC-1.2.047-2: `jr auth switch --profile bogus realprofile` → exits 64 on the `--profile` guard, NOT on a "bogus profile does not exist" message — the guard fires before any profile-existence check is reachable.
- EC-1.2.047-3: `jr auth switch realprofile --profile bogus` (flag supplied after the positional) → same exit-64 rejection; clap's global-arg parsing accepts either order, and the guard is order-independent (checks `cli.profile.is_some()`, not argument position).
- EC-1.2.047-4 (adversary pass-1 MEDIUM-2 — guard keys ONLY on the `--profile` FLAG, never on the resolved active profile / `JR_PROFILE` / config default): `JR_PROFILE=sandbox jr auth switch realprofile` (the global `--profile` FLAG is absent — only the `JR_PROFILE` environment variable is set) → NOT rejected; the guard checks `cli.profile.is_some()` only, which reflects solely whether the `--profile` CLI flag was passed, and is `None`/false regardless of `JR_PROFILE`, `config.default_profile`, or any other stage of the profile-resolution precedence chain (BC-1.1.007). The switch proceeds normally to `handle_switch_in_memory("realprofile")`, exit 0 on success. This is load-bearing for the direnv-scoped-sandbox workflow (CLAUDE.md: "combine with direnv to scope a repo to a sandbox site") — a directory-scoped `JR_PROFILE` export must not make `auth switch` unusable in that directory. Only an explicit `--profile` (or `--profile=X`) token on the command line trips the guard; `JR_PROFILE`, `.envrc`, and `config.toml`'s `default_profile` are all inert with respect to this guard by construction (`cli.profile` is populated exclusively from clap parsing the `--profile` argument — CLAUDE.md's documented precedence chain "flag > env > config > default" describes ACTIVE-PROFILE RESOLUTION, a separate concern from this guard's flag-presence check).
- EC-1.2.047-5 (NEW, adversary pass-4 INFO — syntactically-INVALID `--profile` value pre-empts this BC's guard): `jr auth switch --profile 'in!valid' realprofile` → still exits 64, but via a DIFFERENT, EARLIER check than this BC's guard: `config::validate_profile_name` (`src/config.rs`, called unconditionally from `run()` — `src/main.rs`, at the very top of `run()`, whenever `cli.profile.is_some()` — BEFORE the `match cli.command` dispatch that contains the `AuthCommand::Switch` arm this BC's guard lives in) rejects any `--profile` value containing characters outside `[a-zA-Z0-9_-]` with stderr `"Profile name contains invalid characters (use a-z, 0-9, -, _)"` — NOT this BC's `"--profile is not valid for 'auth switch'…"` message. Both paths exit 64 and both are triggered by the mere presence of `--profile` on `auth switch`, but the STDERR TEXT differs depending on whether the supplied value is syntactically valid: a syntactically-valid value (e.g. `--profile foo`) reaches this BC's Switch-arm guard and gets the "not valid for 'auth switch'" message (BC-1.2.047 Postcondition 3); a syntactically-INVALID value (e.g. `--profile 'in!valid'`) never reaches the Switch-arm guard at all — `validate_profile_name` rejects it first, with the charset message. Both exit-64 paths are correct and unambiguous once this ordering is understood; a test asserting the WRONG message for a charset-invalid `--profile` value on `auth switch` would be testing the wrong layer.

**Explicitly out of scope** (research brief §3, human-ruled): clap `conflicts_with = "profile"` as a belt-and-suspenders second layer — dropped from scope entirely; documented unreliable for `global = true` args (clap issues #5335, #5358) and incomplete for the flag-without-positional case, so it is not pursued even as a secondary defense. Usage-string full unification (`<NAME>` vs `[OPTIONS] <NAME>` vs the pre-#663 promoted third form) is accepted as universal, unavoidable clap behavior (inherent to `--help` vs missing-required-arg usage rendering) and is NOT pursued via `override_usage`.

**Verification Properties**:
- VP-663-001: `jr auth switch --profile foo foo` (both existing profiles) → exit 64; stderr contains `"--profile is not valid for 'auth switch'"`; no config file write (mtime unchanged); no keychain access.
- VP-663-002 (**[CORRECTED, adversary pass-3 HIGH-1]**): `jr auth switch --profile foo foo --output json` → exit 64; **stdout is EMPTY**; **stderr** parses as JSON; parsed object keys == `{"error", "code"}`; `code == 64`. Channel-separation invariant (#526), source-verified: `src/main.rs`'s error-exit handler uses `eprintln!` for the `OutputFormat::Json` arm — the envelope is never written to stdout. **Previous version (original F2 delta pass, INCORRECT from authoring, retained for audit trail — do NOT re-implement):** "stdout parses as JSON; parsed object keys == {\"error\", \"code\"}" — this VP was written with the wrong channel from its initial authoring (not a pass-2 regression — BC-1.2.047 Postcondition 4 itself was always channel-agnostic and correct); pass-3 (fresh context, source-verified against `src/main.rs` and `tests/common/assertions.rs::assert_json_error_envelope`) is the first pass to catch and correct it.
- VP-663-003 (adversary pass-1 MEDIUM-2, pins EC-1.2.047-4): with `JR_PROFILE=sandbox` set in the environment and NO `--profile` flag on the command line, `jr auth switch realprofile` → exit 0; `[profiles.default].default_profile` (or the config's active-profile pointer) is updated to `realprofile`; the exit-64 guard does NOT fire. Negative-space companion to VP-663-001/002: confirms the guard is flag-presence-gated, not resolved-profile-gated.

**Trace**: F2 spec evolution (2026-08-13, issue #663); research brief `.factory/research/bucket1-663-auth-switch-profile-2026-08-13.md` §3 Option 3 (recommended), §4; cross-reference BC-1.2.018 (amended sibling), BC-1.1.003 (unaffected sibling — unknown-profile positional path), BC-7.4.014 (unaffected — success-shape BC, this BC covers only the error path); F2 adversary pass-1 fix round (2026-08-13): EC-1.2.047-4 + VP-663-003 added (MEDIUM-2 — guard keys on the `--profile` flag only, never `JR_PROFILE`/config default, protecting the direnv-scoped-sandbox workflow); BC-1.2.018 title/Behavior clarified re: List/Remove propagation mechanism (LOW-2); F2 adversary pass-3 fix round (2026-08-13, fresh context): VP-663-002 corrected — it had the JSON error envelope on stdout since its original authoring; source-verified (`src/main.rs`'s error-exit handler, `tests/common/assertions.rs::assert_json_error_envelope`) that the envelope is on stderr, stdout empty, matching Postcondition 4's channel-agnostic wording, which was correct all along (HIGH-1); F2 adversary pass-4 fix round (2026-08-13): EC-1.2.047-5 added — pins that `config::validate_profile_name` (`src/main.rs`'s `run()`, before command dispatch) rejects a syntactically-invalid `--profile` value with the charset message BEFORE this BC's Switch-arm guard is ever reached, so a charset-invalid value never surfaces this BC's "not valid for 'auth switch'" message (INFO, source-verified against `src/config.rs::validate_profile_name`)

---

#### BC-1.2.048: Once `auth_method` is set at profile creation, no per-command flag changes which mechanism an invocation uses

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5/§6; `.factory/STATE.md` DEC-313
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313) — negative-space invariant

**Description**: `auth_method` is an intrinsic, per-profile property, not a per-invocation choice. This BC states the general "no per-command auth switch" invariant DEC-313 establishes; BC-1.2.051 states its specific, previously-non-compliant instance (`auth refresh --oauth`'s prior override power, now removed).

**Preconditions**:
1. A profile exists with `auth_method` already set (via `auth login`'s creation-time flow, BC-1.1.013/BC-1.1.014, or a prior `auth login` re-declaration).
2. `jr auth login` or `jr auth refresh` operating against that profile is invoked, with or without a flag that historically could have implied a different mechanism (e.g. `--oauth`, `--api-token`). **(O-6, F2-gate fix)** Narrowed from the original draft's "any `jr` subcommand": `--oauth`/`--api-token` are declared ONLY on `login`/`refresh` (`LoginArgs`/`RefreshArgs`, ADR-0020 §Decision 5) — no other subcommand accepts either flag at all, so no other subcommand can be a site of the per-command-override behavior this BC rules out. Every OTHER `jr` subcommand already, trivially, uses the profile's stored `auth_method` via `JiraClient::from_config` (BC-1.1.015) — that is a separate, pre-existing runtime-read contract, not an instance of this BC's flag-based-override invariant.

**Postconditions**:
1. The invocation uses exactly the profile's stored `auth_method` — no flag on `login`/`refresh` (the only two commands declaring either flag) changes which mechanism is used for that invocation, except `login` itself performing a creation-time re-declaration (Postcondition 2).
2. The only way to change a profile's mechanism is to re-run `jr auth login <profile>` (interactively re-picking, or with `--oauth`/`--api-token` explicit) — a creation-time-shaped re-declaration, not a per-command override.

**Invariants**:
1. This invariant is scoped to *mechanism selection*, not credential *rotation* — `auth refresh` still rotates/relogs credentials for the profile's existing mechanism (BC-1.2.051); it just no longer changes which mechanism.
2. **Re-declaration credential hygiene (O-1/SR-011)**: the sole way to change a profile's mechanism — re-running `jr auth login <profile>` (Postcondition 2) — clears the OUTGOING mechanism's per-profile credentials as part of that same invocation (see BC-1.1.013 EC-1.1.013-2). This prevents a profile that switches mechanism from leaving a stale, unreachable secret (e.g. an abandoned OAuth refresh token on a profile that switched to api-token) sitting in the keychain indefinitely.

**Edge Cases**:
- EC-1.2.048-1: `--oauth`/`--api-token` supplied to `auth refresh` → accepted syntactically (deprecated-alias parity, BC-1.2.049/050) but has zero effect on mechanism selection for that invocation (BC-1.2.051).

**Verification Properties**:
- **VP-AUTHDX-003 — `auth_method`-is-intrinsic invariant: no per-command mechanism override (SAFETY INVARIANT, PROMOTED 2026-09-01, F2 VP-delta pass, merges draft candidates VP-cycle3-005/010/011).** Property: for the full cross product of {profile's stored `auth_method` ∈ `{oauth, api_token}`} × {flag passed to `auth refresh` ∈ `{none, --oauth, --api-token}`}, the mechanism actually used by the invocation is ALWAYS the profile's stored `auth_method`, never the flag — specifically: an `api_token` profile with `--oauth` supplied never binds an OAuth callback listener and never launches a browser; an `oauth` profile with `--api-token` supplied never shows an api-token prompt. This is the general invariant this BC states; BC-1.2.051 documents its specific previously-non-compliant instance (the removed `chosen_flow_for_profile` override). Promoted because it is the central architectural guarantee DEC-313/DEC-321 introduce (auth mechanism as an intrinsic, non-overridable profile property) and a regression here silently reopens the exact security/UX defect (a flag forcing an unwanted OAuth browser flow or unwanted credential prompt) DEC-321 was written to close. **Verification method**: property test (`proptest`) over the 2×3 mechanism/flag matrix, asserting `actual_mechanism_used == profile.auth_method` and the associated no-browser/no-prompt side-effect predicates on every generated case; the two concrete cases from the original candidates (api_token profile + `--oauth`; oauth profile + `--api-token`) are retained as fixed regression seeds. **F6 target**: `src/cli/auth/refresh.rs::refresh_credentials` (SR-013, F2-gate fix — this is now the SOLE citable F6 target: `chosen_flow_for_profile` is REMOVED entirely by DEC-321, not merely simplified, so it is not a durable entry point to cite going forward; the original dual-citation naming both functions is corrected here so test-writer/formal-verifier are not pointed at a function that will not exist post-implementation).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; ADR-0020 §Decision 5; F2-gate fix (2026-09-01) — O-6 narrows Precondition 2 to `login`/`refresh` only, SR-013 corrects VP-AUTHDX-003's F6 target, O-1/SR-011 adds Invariant 2 cross-referencing BC-1.1.013's re-declaration credential-clear requirement; cross-reference BC-1.2.051 (specific `auth refresh` resolution — VP-AUTHDX-003 declared here, cited not duplicated at BC-1.2.051), BC-1.1.013/014/015.

---

#### BC-1.2.049: `--oauth` on `auth login`/`auth refresh` is retained as a deprecated-but-accepted alias with a stderr-only deprecation notice

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5; DEC-323
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-313/DEC-323)

**Description**: `--oauth` is not removed. It continues to function exactly as before (selects/declares the OAuth mechanism on `login`; is a syntactically-accepted no-op on mechanism selection on `refresh`, per BC-1.2.051), but now emits a one-line deprecation notice pointing at the new `--api-token`/creation-time-picker semantics. No removal date is set.

**Preconditions**:
1. `jr auth login --oauth …` or `jr auth refresh --oauth …` is invoked.

**Postconditions**:
1. Functional behavior is unchanged from pre-cycle-003 (`login`: selects OAuth; `refresh`: see BC-1.2.051 for its now-inert mechanism-override semantics).
2. A deprecation notice is written to **stderr only**, in human-output mode only — never emitted when `--output json` is set, and never written to stdout under any output mode (preserving the #526 JSON-render invariant).
3. Exit code and all other observable behavior (config writes, keychain writes, HTTP calls) are byte-for-byte unchanged from the pre-deprecation `--oauth` path.

**Invariants**:
1. No hard removal date exists for `--oauth` as of this cycle (F1 Open Question 4 remains open, by design — not resolved here).
2. Scripts/CI that already pass `--oauth` continue to succeed with identical exit codes and stdout; only stderr gains a new line in human mode.

**Edge Cases**:
- EC-1.2.049-1: `--oauth --output json` → no deprecation notice on stderr either — the notice is gated on OUTPUT FORMAT, not TTY-ness: `--output json` suppresses it regardless of interactivity, since a JSON consumer has no use for an unstructured stderr line and the notice must never contaminate scripted stderr-parsing either. (Documented explicitly so this isn't confused with a TTY-interactivity gate.)
- EC-1.2.049-2: `--oauth` combined with the new `--api-token` flag on the same invocation → mutually exclusive, clap-level rejection (exit 2), consistent with existing `conflicts_with` conventions on this CLI surface.

**Verification Properties**: None dedicated to this BC. **[TRIAGED 2026-09-01, F2 VP-delta pass]** The original draft candidates (deprecation notice absent under `--output json`; present on stderr in human mode) are output-channel/wording checks for one specific new CLI message — the same shape as the corpus's many existing channel-placement unit tests (e.g. BC-2.7.001's stderr truncation hints), not a cross-cutting property distinct from the general #526 JSON-render invariant this codebase already enforces architecturally. DEMOTED to two ordinary F4 test acceptance criteria anchored directly to this BC's Postcondition 2/EC-1.2.049-1 (test-writer implements as standard stdout/stderr capture assertions, one per output mode; no proptest/Kani/trybuild warranted).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-313; DEC-323; ADR-0020 §Decision 5; cross-reference BC-1.2.015/016 (pre-existing `--oauth` flag-presence pins, unaffected), BC-1.2.050 (`--api-token` coequal flag), BC-1.2.051 (`refresh`'s specific inert-override behavior).

---

#### BC-1.2.050: `auth login`/`auth refresh` gain an explicit `--api-token` flag, symmetric with `--oauth`

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 5; DEC-323
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-323)

**Description**: A new, non-deprecated `--api-token` boolean flag is added to `LoginArgs`/`RefreshArgs` as `--oauth`'s coequal, explicit opt-in — resolving F1 Open Question 5 in favor of an explicit flag over interactive-picker-only creation-time selection. This gives non-interactive users an unambiguous way to declare `api_token` even when `JR_EMAIL`/`JR_API_TOKEN` are not yet set (e.g. scripting profile creation with `--email`/`--token` flags instead of env vars).

**Preconditions**:
1. `jr auth login --api-token [--profile <name>] [--url <url>] [--email <e>] [--token <t>]` is invoked.

**Postconditions**:
1. The mechanism-selection picker (BC-1.1.013) is skipped; `auth_method` is set to `api_token` directly.
2. On `auth login`, this flag behaves as the direct, symmetric counterpart to `--oauth` — both are accepted flags that fully bypass the interactive picker.
3. On `auth refresh`, `--api-token` is syntactically accepted (parity with `--oauth`'s BC-1.2.049 acceptance) but is a no-op on mechanism selection per BC-1.2.051/BC-1.2.048 — `refresh` always follows the profile's own stored `auth_method`. **(O-2/CV-2, F2-gate fix)** Because the flag is inert here, `auth refresh --api-token <profile>` MUST emit the same class of stderr-only, human-mode-only notice BC-1.2.049 requires for `--oauth`'s deprecation line — worded for inertness rather than deprecation, e.g. `"--api-token has no effect on 'auth refresh' — the profile's own stored mechanism is always used."` — for symmetry: a user should not be left silently guessing whether either flag did anything on `refresh`. This notice is NEW (unlike `--oauth`'s, it is not a deprecation notice, since `--api-token` itself is not deprecated — only its effect on `refresh` specifically is inert) and follows the identical output-channel rules as BC-1.2.049 (stderr-only, human-mode-only, never under `--output json`).

**Invariants**:
1. `--api-token` and `--oauth` are mutually exclusive on the same invocation (clap `conflicts_with`, exit 2 on both present).
2. `--api-token` is NOT deprecated — it is the modern, non-legacy explicit-selection surface introduced alongside `--oauth`'s demotion.
3. **Flag scope, consolidated (O-2 confirmation, F2-gate fix)**: `--api-token` is FUNCTIONAL on `auth login` (Postconditions 1/2 — it directly selects the mechanism) and INERT-WITH-NOTICE on `auth refresh` (Postcondition 3) — these are its only two declaring commands (BC-1.2.048's O-6 narrowing); it is not declared on, and has no meaning on, any other subcommand.

**Edge Cases**:
- EC-1.2.050-1: `--api-token` supplied together with `--no-input` and complete `--email`/`--token` (or `JR_EMAIL`/`JR_API_TOKEN`) → succeeds identically to the pre-existing non-interactive path (BC-1.1.014), just with the mechanism now explicit rather than implied by non-interactivity alone.
- EC-1.2.050-2: `--api-token` supplied interactively with incomplete credentials → falls through to the existing interactive credential-prompt behavior for the api-token flow (unchanged).

**Verification Properties**: None dedicated to this BC. **[TRIAGED 2026-09-01, F2 VP-delta pass]** The original draft candidates are both ordinary example-based CLI tests, not invariants: (a) the explicit-flag-selection case is a specific instance already subsumed by VP-AUTHDX-001's non-interactive-never-browser property (BC-1.1.014) plus this BC's own Postcondition 1 — no independent property remains once that invariant is proven; (b) `--oauth`/`--api-token` mutual exclusion is a standard clap `conflicts_with` arity check, the same shape as many pre-existing mutually-exclusive flag pairs on this CLI surface (e.g. `--resolution`/`--no-resolution`, `--description`/`--description-stdin`) that this corpus has never elevated to VP status. DEMOTED to two ordinary F4 test acceptance criteria anchored directly to this BC's Postcondition 1 / Invariant 1 (test-writer implements as standard flag-combination unit tests).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-323; ADR-0020 §Decision 5; F2-gate fix (2026-09-01, O-2/CV-2) — inert-with-notice requirement added to Postcondition 3, flag-scope Invariant 3 added; cross-reference BC-1.1.013/014 (picker/non-interactive defaults this flag bypasses), BC-1.2.049 (`--oauth`'s parallel deprecated-alias contract), BC-1.2.048 (O-6 — the login/refresh-only scope this BC's flag participates in).

---

#### BC-1.2.051: `auth refresh --oauth`/`--api-token` no longer override the profile's stored `auth_method` — refresh always follows the intrinsic mechanism

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 6; DEC-321; `src/cli/auth/mod.rs::chosen_flow_for_profile` (F4 target for removal/simplification)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-321) — resolves F1 Open Question 8

**Description**: Pre-cycle-003, `chosen_flow_for_profile` let a per-invocation `--oauth` flag on `auth refresh` override the target profile's stored `auth_method` for that one call — the only place in the codebase where a per-command flag outranked a profile's intrinsic mechanism. DEC-321 removes this override entirely: `auth refresh` always follows the profile's own `auth_method`. Changing a profile's mechanism requires `auth login <profile>` re-declaration (BC-1.1.013's picker, or `--oauth`/`--api-token` explicit), never a `refresh`-time flag.

**Preconditions**:
1. A profile exists with a stored `auth_method` (`oauth` or `api_token`).
2. `jr auth refresh [--oauth | --api-token] <profile>` is invoked, where the supplied flag (if any) names a DIFFERENT mechanism than the profile's stored `auth_method`.

**Postconditions**:
1. `refresh`'s **"relogin-then-replace"** (renamed, adversary pass-2 fix L-1 — the prior "clear-then-relogin" term is self-contradicting against this BC's own Invariant 2 / I-6, which forbids a literal clear-then-fetch sequence; the correct order is obtain-and-confirm the new value FIRST, then replace the old one, never the reverse) always re-logs in via the profile's own intrinsic `auth_method` — the supplied `--oauth`/`--api-token` flag has NO effect on which mechanism is used.
2. The flag is still syntactically accepted (no clap error) — this is a silent behavior narrowing, not a hard error, consistent with BC-1.2.049/050's deprecated/parity-alias framing. The flag additionally carries the same deprecation-notice contract as `login`'s `--oauth` (BC-1.2.049) when it is the legacy `--oauth` spelling; `--api-token` on `refresh` is non-deprecated parity per BC-1.2.050.
3. `chosen_flow_for_profile`'s prior `oauth_override: bool` behavior is removed — the function (if retained at all) resolves solely from the profile's stored `auth_method`.

**Invariants**:
1. This closes the sole pre-cycle-003 exception to "auth_method is intrinsic" (BC-1.2.048) — after this BC, there are zero per-command mechanism overrides anywhere in `jr`.
2. **(I-6, F2-gate fix; term corrected, adversary pass-2 fix L-1) `refresh`'s relogin-then-replace must not clear existing credentials until a replacement is confirmed obtainable.** For an `api_token`-method profile, `auth refresh`'s relogin step MUST NOT delete or overwrite the profile's existing `<profile>:email`/`<profile>:api-token` pair until the new credential value has been obtained and validated as usable — extending BC-1.1.011's "credentials NOT cleared on failure" invariant (originally stated for the unconfigured-profile case) to this relogin path as well. Concretely, this rules out a literal "clear-then-fetch" sequence (delete the old pair, then attempt to obtain the new one) in favor of either: (a) obtain/confirm the new credential value first, then call `store_api_token` (which overwrites both keys atomically-in-effect, per BC-1.4.031/033's existing write behavior) — never a separate delete step beforehand; or (b) route through `auth login`'s existing re-declaration path (BC-1.1.013 EC-1.1.013-2's clear-then-write sequencing), which already only clears the OUTGOING mechanism's credentials once the new mechanism's write has a confirmed value to write. Either way, a `refresh` that fails to obtain a usable replacement (network error, invalid re-entered credential, user cancels an interactive re-prompt) MUST leave the profile's existing, still-working credential pair completely intact — a failed `refresh` must never leave a profile in a WORSE (credential-less) state than before the command was run.

**Edge Cases**:
- EC-1.2.051-1: `jr auth refresh --oauth <profile>` where `<profile>.auth_method == "api_token"` → refresh proceeds as an api-token credential refresh/relogin; NO OAuth browser flow is launched. This is a documented, intentional behavior change from pre-cycle-003 (the flag previously WOULD have forced an OAuth relogin) — flagged as a breaking change in ADR-0020's Breaking-Change Acknowledgment.
- EC-1.2.051-2: `jr auth refresh <profile>` with no flag at all → unaffected; always followed the stored `auth_method` already.
- EC-1.2.051-3 (I-6, F2-gate fix): `jr auth refresh <profile>` for an `api_token`-method profile where the relogin step fails to obtain a usable replacement credential (e.g. transient network error contacting Jira to validate the re-entered token, or an interactive re-prompt is cancelled) → the command exits non-zero, but `<profile>:email`/`<profile>:api-token` are UNCHANGED from their pre-`refresh` values; a subsequent `jr` invocation against that profile continues to authenticate successfully with the old, still-intact credential. This is the api-token-specific instance of BC-1.1.011's "credentials NOT cleared on failure" invariant.

**Verification Properties**: This BC's specific instances (an `api_token` profile with `refresh --oauth`; an `oauth` profile with `refresh --api-token`) are covered by **VP-AUTHDX-003**, declared at BC-1.2.048 (the general "`auth_method` is intrinsic" invariant this BC is the previously-non-compliant special case of) — not duplicated here. The original draft candidates VP-cycle3-010/011 were the two concrete generated-case seeds folded into VP-AUTHDX-003's proptest matrix at promotion time (2026-09-01, F2 VP-delta pass).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-321; ADR-0020 §Decision 6 (resolves F1 delta analysis Open Question 8); F2-gate fix (2026-09-01, I-6) — Invariant 2 and EC-1.2.051-3 added, extending BC-1.1.011's not-cleared-on-failure guarantee to the relogin path; adversary pass-2 fix (2026-09-01, L-1) — Postcondition 1 and Invariant 2's "clear-then-relogin" term renamed to "relogin-then-replace" to resolve the self-contradiction against this BC's own I-6 no-clear-before-confirmed-replacement rule; cross-reference BC-1.2.048 (general invariant, VP-AUTHDX-003 declared there), BC-1.2.015/016 (pre-existing `--oauth`-on-refresh flag-presence pins — still true, only the override BEHAVIOR changes, not the flag's continued existence), BC-1.1.011 (the not-cleared-on-failure invariant this fix extends).

---

### 1.3 Embedded OAuth App

#### BC-1.3.019: Embedded OAuth app `Debug` redacts client_secret

**Confidence**: HIGH
**Source**: `src/api/auth_embedded.rs:~34, 220-239`
**Subject**: Auth & Identity
**Behavior**: `format!("{:?}", EmbeddedOAuthApp{...})` never emits plaintext secret. Custom Debug impl substitutes `<redacted>`. This is BC-1168 from Pass 3 R4.
**Trace**: Pass 3 BC-019; BC-1168 (R4)

---

#### BC-1.3.020: Build with empty XOR inputs → `embedded_oauth_app()` returns None

**Confidence**: HIGH
**Source**: `src/api/auth_embedded.rs:~100`
**Subject**: Auth & Identity
**Behavior**: Setting `JR_BUILD_OAUTH_CLIENT_ID=""` at build time → binary returns `None` from embedded accessor. BYO/prompt fallback proceeds.
**Trace**: Pass 3 BC-020

---

#### BC-1.3.021: `embedded_oauth_app_present()` checks presence without decoding

**Confidence**: HIGH
**Source**: `src/api/auth_embedded.rs:~132`
**Subject**: Auth & Identity
**Behavior**: Presence check inspects only `EMBEDDED_ID.is_some_and(|s| !s.is_empty())`. Does NOT invoke `decode()`. Used by `auth status` to report `OAuthAppSource::Embedded` without materializing plaintext.
**Trace**: Pass 3 BC-021; BC-022-R (R1)

---

#### BC-1.3.022: `OAuthAppSource` resolution chain: Flag > Env > Keychain > Embedded > Prompt > None

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/api/auth_embedded.rs:~46`; `src/cli/auth/status.rs::peek_oauth_app_source`
**Subject**: Auth & Identity
**Behavior**: First non-None-equivalent source wins; lower-priority sources never short-circuit higher. `auth status` reports source via this chain.
**Trace**: Pass 3 BC-022-R

---

#### BC-1.3.023: DEFAULT_OAUTH_SCOPES includes `offline_access`, CMDB scopes, `write:jira-work`, and `write:servicedesk-request`

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~34` (line 59 is the concat! literal site)
**Subject**: Auth & Identity
**Behavior**: DEFAULT_OAUTH_SCOPES is: `read:jira-work write:jira-work read:jira-user read:servicedesk-request write:servicedesk-request read:cmdb-object:jira read:cmdb-schema:jira offline_access`. The embedded `jr` OAuth app's Developer Console registration MUST include `write:servicedesk-request` or the authorize call will reject with `invalid_scope` for all new OAuth logins and token refreshes. The pinning test `default_oauth_scopes_pins_the_full_set_with_offline_access` in `src/cli/auth/tests/mod.rs` MUST be kept in lockstep with `auth.rs:~59` — it must be updated in the same commit as any change to the scope constant. Regression test asserts no double spaces and the full exact scope string.
**Effects**: Scope addition affects every OAuth-authenticated user on next token refresh or new login. CI cannot catch a Developer Console registration mismatch — manual staging validation is required before release when this constant is modified.

**Maintainer coordination:** when changing `DEFAULT_OAUTH_SCOPES`, the maintainer also updates the embedded `jr` OAuth app's permissions in the Atlassian Developer Console (https://developer.atlassian.com/console/myapps/ → My apps → jr → Permissions → Configure → Add) before tagging a release. Existing users will be prompted to re-consent on their next OAuth login or token refresh (Atlassian auto-handles this UX; see [Atlassian managing-OAuth-apps docs](https://developer.atlassian.com/cloud/oauth/getting-started/managing-oauth-apps/)). CHANGELOG entries for any release that changes this constant MUST mention the re-consent prompt so users aren't surprised. No CI hook, no PR template; the existing code comment at `src/api/auth.rs:~46` is the implementer-side reminder, the maintainer checklist lives in CLAUDE.md OAuth Gotcha section.

> **[UPDATED 2026-05-18 issue #288 + F1d pass-01 fix-applied + scope-simplified per research-validated risk profile]** `write:servicedesk-request` added to enable `jr issue create --request-type` JSM submission (BC-3.8.001).
> - **Previous (pre-#288):** Scope string was `read:jira-work write:jira-work read:jira-user read:servicedesk-request read:cmdb-object:jira read:cmdb-schema:jira offline_access` (no `write:servicedesk-request`).

**Trace**: Pass 3 BC-035 (R1); issue #288 F2 (2026-05-18); issue #288 F1d adversary pass-01 (2026-05-18 — release gate enforcement added); issue #288 F1d pass-01 scope-simplified (2026-05-18 — PR template gate removed per research-validated risk profile)

---

#### BC-1.3.024: Embedded OAuth integration test is `#[ignore]`-gated and stubs `unimplemented!()`

**Confidence**: HIGH
**Source**: `tests/oauth_embedded_login.rs:~13`
**Subject**: Auth & Identity
**Behavior**: Test intentionally `unimplemented!()` when `JR_RUN_OAUTH_INTEGRATION=1`. Without that env var, test early-returns. Guards against false coverage signals.
**Trace**: Pass 3 BC-028 (R1)

---

### 1.4 Token Keychain Layout

#### BC-1.4.025: `default` profile lazy-migrates legacy flat OAuth keys; non-default profiles never inherit

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — adds a regression-confirmation clause: this OAuth-token migration's own code and behavior are UNCHANGED by cycle-003; a separate, sibling migration for API-token credentials is added alongside it (BC-1.4.032), not merged into it.

**Confidence**: HIGH (PROMOTED from MEDIUM in R1)
**Source**: `src/api/auth.rs:~111`
**Subject**: Auth & Identity
**Behavior**: `load_oauth_tokens(profile)`: if both namespaced keys present → return. If both missing → ONLY `"default"` reads legacy flat keys, copies to namespaced, deletes legacy. Non-default profiles error on partial state with actionable message. Two `if profile == "default"` guards at lines 124 and 151.
**Regression confirmation (cycle-003)**: this function and its test suite (`auth.rs::tests`, dedicated unit tests covering default-partial-recovery and non-default non-inheritance) are explicitly a MUST-NOT-TOUCH regression baseline for cycle-003 — the new API-token migration (BC-1.4.032) mirrors this function's PATTERN in a separate, sibling function, never by modifying `load_oauth_tokens` itself. A diff-zero regression check against this function's existing test suite is a mandatory CI gate for any cycle-003 PR touching `src/api/auth.rs`.
**Trace**: Pass 3 BC-023-R; F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01) — regression-confirmation clause added; cross-reference BC-1.4.032 (the new, sibling API-token migration this BC's pattern is mirrored into, not merged with).

---

#### BC-1.4.026: `refresh_oauth_token` signature is `(profile: &str)` only — resolves credentials internally

**Confidence**: HIGH (PROMOTED from LOW in R1)
**Source**: `src/api/auth.rs:~700`; CLAUDE.md
**Subject**: Auth & Identity
**Behavior**: Function takes only `profile: &str`. Internally resolves keychain → embedded. No production callers as of v0.5.0-dev.7 — exists for future 401 auto-refresh. Re-introducing `client_id/_secret` would break embedded-OAuth path.
**Trace**: Pass 3 BC-024-R

---

#### BC-1.4.027: Per-profile keychain keys: `<profile>:oauth-access-token` / `<profile>:oauth-refresh-token`; `<profile>:email` / `<profile>:api-token`

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — the previous "Shared keys… are NOT namespaced" claim becomes FALSE for `email`/`api-token`, which are now namespaced per-profile (BC-1.4.031). Only `oauth_client_id`/`oauth_client_secret` (the BYO **OAuth app**-credential pair) remain shared/flat — a genuinely different axis (one OAuth app registration per keychain, not per profile).

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~24`; ADR-0020 §Decision 1
**Subject**: Auth & Identity
**Behavior**: All OAuth token storage/retrieval uses namespaced keys (`<profile>:oauth-access-token`/`-refresh-token`). All API-token credential storage/retrieval ALSO uses namespaced keys (`<profile>:email`/`<profile>:api-token`, DEC-315) — symmetric with the OAuth pair. The ONLY remaining shared/flat keychain keys are `oauth_client_id` and `oauth_client_secret` (the BYO OAuth **app** credential pair, explicitly out of scope for DEC-315's per-profile restructuring, since a BYO app registration is inherently one-per-keychain).

**Previous version (superseded by DEC-315, retained for audit trail):**
> **Behavior**: All OAuth token storage/retrieval uses namespaced keys. Shared keys (`email`, `api-token`, `oauth_client_id`, `oauth_client_secret`) are NOT namespaced.

**Trace**: Pass 3 BC-1153 (R4); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-315) — split shared-vs-namespaced claim; ADR-0020 §Decision 1; cross-reference BC-1.4.031 (new per-profile API-token functions), BC-1.4.030 (unaffected — governs the still-shared OAuth **app**-credential resolver).

---

#### BC-1.4.028: `load_oauth_tokens` errors on PARTIAL state (one token present, other missing)

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1249`
**Subject**: Auth & Identity
**Behavior**: Access-token without refresh-token (or vice versa) → `Err`. Prevents silent half-credential use.
**Trace**: Pass 3 BC-1156 (R4)

---

#### BC-1.4.029: `load_oauth_tokens("sandbox")` does NOT inherit legacy flat keys

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-315)** — adds a cross-reference confirming the identical non-inheritance guarantee holds for the new per-profile API-token reader.

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1323`; ADR-0020 §Decision 2
**Subject**: Auth & Identity
**Behavior**: Lazy migration is `default`-profile-only by design. "sandbox" only reads `sandbox:oauth-*` namespaced keys.
**Cross-reference (cycle-003)**: the identical guarantee holds for `load_api_token`: `load_api_token("sandbox")` only ever reads `sandbox:email`/`sandbox:api-token` namespaced keys and never inherits the legacy flat `email`/`api-token` pair, regardless of whether that legacy pair still exists in the keychain (BC-1.4.032 EC-1.4.032-3).
**Trace**: Pass 3 BC-1158 (R4); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01) — cross-reference added; see BC-1.4.032 for the new function's own non-inheritance contract.

---

#### BC-1.4.030: `resolve_refresh_app_credentials` prefers KEYCHAIN over EMBEDDED

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1347`
**Subject**: Auth & Identity
**Behavior**: BYO user does NOT silently flip onto embedded mid-session. Keychain wins.
**Trace**: Pass 3 BC-1159 (R4)

---

#### BC-1.4.031: Per-profile API-token keychain storage: `store_api_token(profile, …)` / `load_api_token(profile)`

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 1; DEC-315; `src/api/auth.rs` (F4 target — new functions, mirroring `store_oauth_tokens`/`load_oauth_tokens`)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-315)

**Description**: API-token credentials (`email`, `api-token`) move from shared, account-level flat keychain keys to per-profile-namespaced keys (`<profile>:email`, `<profile>:api-token`), symmetric with the OAuth token pair's existing `<profile>:oauth-access-token`/`-refresh-token` namespacing (BC-1.4.027, amended). This reverses the mixed-scoping invariant BC-1.4.027 previously documented as intentional.

**Preconditions**:
1. `store_api_token(profile, email, token)` is called for a given profile (typically from `login_token`, `src/cli/auth/login.rs`).

**Postconditions**:
1. `email` is stored under key `<profile>:email`; `token` is stored under key `<profile>:api-token`.
2. `load_api_token(profile)` reads back the SAME namespaced pair — no shared/flat fallback for a profile whose namespaced keys are already present.
3. `JiraClient::from_config`'s `api_token` branch (`load_auth_from_keychain`) reads via `load_api_token(profile_name)`, never the old flat-key reader.
4. The shared/flat `oauth_client_id`/`oauth_client_secret` keys (the BYO **OAuth app** credential pair — a different axis) are explicitly OUT of scope and remain shared/flat; this BC does not touch them.

**Invariants**:
1. This is a straight signature change (profile-scoped, mirroring the OAuth pair byte-for-byte in shape) — not a new storage backend or isolation boundary (Windows Credential Manager posture, SEC-WCM-DOC, is unaffected).
2. Two profiles with distinct `auth_method: api_token` never share a credential pair — each profile's `load_api_token` reads only its own namespaced keys, with no exception for `"default"` (BC-1.4.032, redesigned: there is no migration/copy step for any profile, `"default"` included, that could otherwise create a cross-profile sharing exception here).

**Edge Cases**:
- EC-1.4.031-1: a brand-new profile with no namespaced keys and no legacy flat keys present (and not `"default"`) → `load_api_token` returns the same actionable "no stored credential, run `jr auth login`" error `load_oauth_tokens` already produces for its non-default absent case (BC-1.4.025's error shape, mirrored).
- EC-1.4.031-2 (I-5, F2-gate fix): `load_api_token`/`store_api_token` MUST distinguish a keychain BACKEND error (Secret Service unavailable, permission denied, headless CI with no keyring daemon running) from a genuine key-absent result — mirroring `load_oauth_tokens`'s existing `Err(keyring::Error::NoEntry)`-vs.-any-other-`Err` handling byte-for-byte (ADR-0020 §Decision 1). A backend error propagates as its own distinct error naming the backend problem (e.g. `"keychain unavailable: {e}"`) and is NEVER coerced into BC-1.4.032's "no stored credential — run `jr auth login`" message: that message would misdirect a headless-CI user into repeatedly re-running a login that cannot succeed for the same underlying environmental reason (no keychain backend to write to). This distinction applies at every keychain read this BC's functions perform, including the legacy-pair existence check BC-1.4.032 performs on the absent-namespaced-keys path.

**Verification Properties**:
- **VP-AUTHDX-004 — Per-profile API-token store/load round-trip + cross-profile credential isolation (SECURITY INVARIANT, PROMOTED 2026-09-01, F2 VP-delta pass, merges draft candidates VP-cycle3-012/013; generator BOUNDED 2026-09-01, F2-gate fix, O-3).** Two properties, both strengthened by this cycle's per-profile namespacing: (1) **Round-trip correctness**: for ANY profile name and ANY VALID credential string pair `(email, token)` — bounded generators producing realistic values (ASCII API-token-shaped strings; RFC 5321/5322-constrained email-shaped strings), **not** an unbounded arbitrary-byte fuzz including raw NUL/control-character/unpaired-surrogate content (O-3, F2-gate fix: real keychain backends — macOS Keychain, Windows Credential Manager, Linux Secret Service — impose their own limits and encoding constraints on stored secret content, so a generator producing keychain-hostile byte sequences tests the OS backend's own robustness, not this BC's logic, and can produce spurious backend-error failures indistinguishable from a real defect) — `store_api_token(profile, email, token)` followed by `load_api_token(profile)` returns exactly `(email, token)`, and the keychain contains the namespaced pair `<profile>:email`/`<profile>:api-token`, never a flat `email`/`api-token` pair. (2) **Cross-profile isolation**: for ANY two distinct profile names `p1 ≠ p2` and ANY valid credential strings as bounded above, after `store_api_token(p1, e1, t1)`, `load_api_token(p2)` NEVER returns `(e1, t1)` (nor any component of it) — a profile's credentials are never observable from another profile's read path. Promoted because credential cross-contamination is a security-relevant defect class (sandbox/prod credential bleed), not merely a correctness bug, and the round-trip property is the foundational correctness guarantee every other BC in this cluster (detect-and-instruct, partial-state) depends on. **Verification method**: property test (`proptest`, bounded profile-name and valid-credential-string generators per O-3) for both properties; a keyring-gated integration test (`JR_RUN_KEYRING_TESTS=1`, pattern: existing `#[ignore]`-gated tests) proving the property against the REAL OS keychain backend, not just an in-memory double, mirroring BC-6.2.009/010's existing cross-profile cache-isolation test pattern. **F6 target**: `src/api/auth.rs::store_api_token`/`load_api_token` (new functions).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-315; ADR-0020 §Decision 1; F2-gate fix (2026-09-01, I-5/O-3) — EC-1.4.031-2 backend-error-vs-absent distinction added, VP-AUTHDX-004's generator bounded to valid credential strings; cross-reference BC-1.4.027 (AMENDED sibling — the "NOT namespaced" claim this BC reverses for email/api-token specifically), BC-1.4.032 (REDESIGNED — the "no stored credential" message this BC's backend-error distinction must never be coerced into), ADR-0007 (the per-profile-data precedent this ADR extends from config fields to keychain credentials).

---

#### BC-1.4.032: Legacy shared flat `email`/`api-token` keys are NEVER auto-migrated — `load_api_token` detects-and-instructs, never copies

**STATUS: REDESIGNED (2026-09-01, cycle-003 `auth-profile-dx`, F2-gate fix, HUMAN DECISION)** — REPLACES this BC's original copy-then-delete migration design in full. The original F1/F2 draft (lazily copy the shared legacy `email`/`api-token` pair into `<default>:email`/`<default>:api-token` on first read, then best-effort-delete the legacy pair) is REJECTED and REMOVED. `load_api_token` now performs a **no-copy detect-and-instruct** check instead, for every profile including `"default"` — see ADR-0020 §Decision 2 for the human-decided rationale: a Basic-auth email/token pair carries no environment binding, so copying it can silently hand a freshly sandbox/uat-tagged profile the same credential as whatever environment the legacy pair happens to belong to (in practice, usually production, since it predates multi-profile support) — defeating DEC-312's environment-locking goal outright.

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 2/2a/2b (REDESIGNED at F2 gate); `.factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` §3; DEC-315; `src/api/auth.rs::load_oauth_tokens` (the pattern this BC deliberately, only partially mirrors — just the "try namespaced keys first" step is shared; the copy-then-delete steps are NOT)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-315) — REDESIGNED at the F2 gate (HUMAN DECISION); highest-risk new contract in the cycle (F1 delta analysis §3)

**Description**: `load_api_token(profile)` NEVER reads the legacy shared flat `email`/`api-token` pair as a credential value, NEVER copies it into any profile's namespaced slot, and NEVER deletes it — for any profile, including `"default"`. On absent namespaced keys, the function returns an actionable exit-64 error instructing the user to run `jr auth login <profile>` once (see BC-1.4.034 for the resulting one-time breaking-change contract). The legacy pair, if present, is left completely untouched by this code path; a future, separate `jr auth` cleanup command that deletes the now-orphaned legacy keys is a recommended follow-up, not built in this cycle.

**Preconditions**:
1. `load_api_token(profile)` is called for ANY profile name, including `"default"`.
2. Both namespaced keys (`<profile>:email`, `<profile>:api-token`) are absent.

**Postconditions**:
1. `load_api_token` checks, for EXISTENCE ONLY, whether the legacy shared flat `email`/`api-token` pair is present in the keychain. This check exists only to keep the code path's shape symmetric with the OAuth migration's detection step (see Rationale in ADR-0020 §Decision 2) — it does NOT change the error the user sees, and the legacy pair's VALUES are never read as part of this check.
2. Whether the legacy pair is present or absent, the function returns the IDENTICAL actionable error: `JrError::UserError` (exit 64), `"No credentials stored for profile '{profile}'. This version of jr requires per-profile credentials — run \`jr auth login {profile}\` to set them up."`.
3. The legacy flat pair is NEVER copied to `<profile>:email`/`<profile>:api-token` (for `"default"` or any other profile), and NEVER deleted, by this code path.
4. No profile is special-cased: `"default"` and every other profile name go through the identical check above — there is no `"default"`-only branch (the previous design's asymmetry, and the copy step it existed to gate, are both removed).
5. This check is EAGER on every call — there is no "first read after upgrade" migration event to trigger lazily; the function's behavior on this branch is identical on every invocation for the same keychain state.

**Invariants**:
1. **No-copy, permanently.** No code path in `load_api_token`/`store_api_token` ever reads the legacy flat pair's VALUES as a credential, writes them into a namespaced slot, or deletes them — this is not a transitional behavior pending a future cleanup command; it is the permanent contract for this cycle and beyond, absent a separate future ADR.
2. **Idempotency is trivial, not proven-by-repetition.** Because this branch is read-only and has no mutating side effect of its own, every call with the same keychain state produces byte-identical output — there is no "first call migrates, subsequent calls short-circuit" distinction to verify (contrast the OAuth migration's copy-then-short-circuit shape, which this BC deliberately does not reuse past the first lookup step).
3. **No single-flight coordination needed (ADR-0020 §Decision 2b).** Two concurrent `load_api_token` calls for the same profile that both find an absent credential both simply return the same actionable error; neither mutates keychain state, so there is no race to coordinate — unlike `refresh_coordinator.rs`'s OAuth-refresh single-flight, which exists because a concurrent refresh can race a single-use refresh token.
4. **Backend-error exemption (cross-reference BC-1.4.031 EC-1.4.031-2, I-5):** a keychain BACKEND error encountered while checking for the legacy pair's existence is never coerced into this BC's "no stored credential" message — it propagates as its own distinct error naming the backend problem.
5. **Scope discipline**: this code path fires only when `load_api_token` is called for an `api_token`-method profile (or a profile with `auth_method` unset, since that is the runtime default per BC-1.1.015); it never fires for, reads, or conflates with the separate OAuth-token migration (`load_oauth_tokens`), which operates on entirely different keys and is functionally unchanged by this cycle (BC-1.4.025).
6. **This is a one-time, clearly-communicated BREAKING CHANGE (see BC-1.4.034 for the full contract):** every profile that relied on the shared flat `email`/`api-token` pair for api-token auth before this cycle will see `load_api_token` fail with the actionable error above on first use after upgrade, until that profile runs `jr auth login <profile>` exactly once.

**Edge Cases**:
- EC-1.4.032-1: `"default"` profile, legacy flat pair present, namespaced keys absent → the SAME "No credentials stored… run `jr auth login default`" error as any other profile in this state; the legacy pair's presence changes nothing observable to the user (Postcondition 2's symmetric outcome).
- EC-1.4.032-2: `"default"` profile already has namespaced keys (e.g. from a fresh `jr auth login` on a cycle-003-or-later binary, never having had legacy flat keys) → this BC's check is never entered; behaves identically to BC-1.4.031's ordinary namespaced-keys-present success read.
- EC-1.4.032-3: a non-`"default"` profile (e.g. `"sandbox"`) with absent namespaced keys, while a legacy flat pair STILL exists in the keychain → `sandbox` gets the identical error `"default"` would get in the same state (no special-casing) — mirrors BC-1.4.029's OAuth-equivalent non-inheritance guarantee, but here via "no profile is ever special" rather than "only default may migrate."
- EC-1.4.032-4: a user runs `jr auth login <profile>` once, satisfying this BC's error's remediation → subsequent `load_api_token(profile)` calls hit BC-1.4.031's ordinary namespaced-keys-present success path; the legacy flat pair (if it existed) remains untouched in the keychain, inert, and is never read again by any `jr` code path.
- EC-1.4.032-5: exactly one of the two NAMESPACED keys is present (a partial write, distinct from "both absent") → this is NOT this BC's branch at all; see BC-1.4.033 (ADR-0020 §Decision 2a) for the dedicated namespaced-pair partial-write recovery contract.

**Verification Properties**:
- **VP-AUTHDX-005 — Detect-and-instruct correctness: no legacy pair ever read or copied (SAFETY-CRITICAL PROPERTY, REWRITTEN 2026-09-01, F2-gate fix, HUMAN DECISION — supersedes the original copy-then-delete oracle, was PROMOTED 2026-09-01 F2 VP-delta pass merging VP-cycle3-014/015).** Property: for ANY legacy flat `(email, token)` string pair pre-seeded in the keychain (or none at all — presence is irrelevant to the outcome), against the `"default"` profile specifically: (a) **detect-and-instruct correctness**: `load_api_token("default")` with absent namespaced keys returns `Err` with the actionable `"No credentials stored for profile 'default'… run \`jr auth login default\`"` message REGARDLESS of whether a legacy flat pair is present, and `default:email`/`default:api-token` are NEVER written by this call; (b) **legacy-pair inertness**: the legacy flat pair's byte content, if present, is IDENTICAL before and after any number of `load_api_token("default")` calls — no read of its VALUES, no copy, and no delete ever occurs; (c) **stability, not idempotency-of-a-migration**: every subsequent `load_api_token("default")` call in the same absent-namespaced-keys state returns the SAME `Err`, since there is no mutating first-call side effect to short-circuit around (contrasts the old oracle's "first call migrates, subsequent calls are a no-op" shape, which no longer applies because nothing is ever written by this branch). This directly REVERSES the original draft's proof, which asserted the opposite of (a)/(b) — that the first call WOULD copy and delete the legacy pair; that behavior is REMOVED by human decision (ADR-0020 §Decision 2), and this VP now proves its absence rather than its presence. **Verification method**: property test (`proptest`, arbitrary legacy email/token strings, plus a legacy-pair-absent variant) asserting the Err-and-untouched-legacy-pair invariant on every generated case. **F6 target**: `src/api/auth.rs::load_api_token`.
- **VP-AUTHDX-006 — No profile is special-cased: `"default"` and every other profile behave identically on legacy-pair presence (SAFETY INVARIANT, REWRITTEN 2026-09-01, F2-gate fix — broadens scope from "non-default never inherits" to "no profile, including default, ever inherits"; was PROMOTED 2026-09-01 F2 VP-delta pass as VP-cycle3-016).** Property: for ANY profile name (including `"default"` itself) with absent namespaced keys, EVEN WHEN a complete legacy flat pair still exists in the keychain, `load_api_token(profile)` NEVER reads, copies, or is influenced by the legacy pair's VALUES — it surfaces the identical actionable "no stored credential" error for every profile name, with no branch distinguishing `"default"` from any other name, and the legacy flat pair is left byte-for-byte UNCHANGED. Promoted because this is the safety boundary preventing ANY profile — not merely a non-default one — from silently inheriting a different environment's credentials, exactly the class of cross-environment credential leak this per-profile restructuring exists to prevent. The ORIGINAL oracle only protected non-default profiles and explicitly carved `"default"` out as the one profile allowed to inherit; the F2-gate human decision reverses that carve-out entirely. **Verification method**: property test (`proptest`, arbitrary profile names INCLUDING `"default"` itself as a generated case, never excluded) asserting the identical error-and-untouched-legacy-pair invariant holds for every generated name with no special-cased branch. **F6 target**: `src/api/auth.rs::load_api_token`.
- **VP-AUTHDX-007 — Mandatory keyring-gated end-to-end detect-and-instruct SCENARIO (RELABELED 2026-09-01, F2-gate fix, SR-014 — was "Keyring-gated end-to-end migration proof," PROMOTED 2026-09-01 F2 VP-delta pass as VP-cycle3-017; still mandatory, no longer a migration proof since there is no migration to prove).** Scenario: pre-cycle-003 shared flat keys present in the REAL OS keychain, no namespaced pair for any profile → first post-upgrade `jr` invocation against `"default"` (or any other pre-existing api-token profile) fails with the actionable exit-64 "no credentials stored… run `jr auth login {profile}`" error; the legacy shared flat pair is confirmed UNCHANGED (byte-for-byte) in the real keychain after the failed call; NO `<profile>:email`/`<profile>:api-token` namespaced pair is ever written by this call, for `"default"` or any other profile; a `"sandbox"` profile (if configured) observes the identical failure-and-untouched-legacy-pair behavior, not a differentiated one. Remains mandatory (not demoted to an ordinary integration test) for the same reason as the original — F1 delta-analysis §3 names an end-to-end proof against the REAL, non-mockable OS keychain backend as one of the cycle's highest-risk items; unit-level property tests (VP-AUTHDX-005/006) prove the logic against a mocked/in-memory double, and this VP is the only one in the cluster proving the SAME logic against macOS Keychain / Windows Credential Manager / Linux Secret Service, where a platform-specific quirk in the existence-check step could still surface. **Verification method**: keyring-gated integration test (`#[ignore]`, `JR_RUN_KEYRING_TESTS=1`), pattern: existing gated tests in `src/api/auth.rs`/`tests/oauth_refresh_integration.rs`. **F6 target**: `src/api/auth.rs::load_api_token` against the real keyring backend.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-315; ADR-0020 §Decision 2 (ORIGINAL copy-then-delete draft); F1 delta analysis §3 (HIGH regression risk) and §4.1 (migration surface, as originally scoped); F2-gate fix (2026-09-01, HUMAN DECISION) — REDESIGNED in full to the no-copy detect-and-instruct model per ADR-0020 §Decision 2/2a/2b (as amended) and `architecture-delta.md` §3, superseding the copy-then-delete draft; VP-AUTHDX-005/006/007 REWRITTEN in place for the no-copy model (VP-AUTHDX-007 relabeled SR-014); cross-reference BC-1.4.025 (AMENDED — the OAuth-token migration this BC's shape now only partially mirrors, sharing just the "try namespaced keys first" step), BC-1.4.028 (OAuth partial-state `Err` pattern), BC-1.4.031 (EC-1.4.031-2 — the backend-error distinction this BC's existence check must respect), BC-1.4.033 (REWRITTEN — this BC's own partial-write sibling, now namespaced-pair-only), BC-1.4.034 (NEW — the one-time re-login breaking-change contract this BC's Invariant 6 refers to).

---

#### BC-1.4.033: Partial-write recovery for the per-profile API-token pair — namespaced-pair case only (legacy-partial branch removed)

**STATUS: REDESIGNED (2026-09-01, cycle-003 `auth-profile-dx`, F2-gate fix)** — narrows this BC's scope to the namespaced-pair partial-write case only. The original draft's second branch (a partial LEGACY flat pair interrupting a copy-then-delete migration) is REMOVED in full: BC-1.4.032's no-copy redesign removes the copy step, so there is no longer a copy-then-delete sequence for a partial legacy pair to interrupt (ADR-0020 §Decision 2a).

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 2a (REDESIGNED at F2 gate); DEC-315; `src/api/auth.rs::load_oauth_tokens`'s partial-state pattern (BC-1.4.028, mirrored)
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-315) — REDESIGNED at the F2 gate

**Description**: Mirrors BC-1.4.028's OAuth partial-state `Err` contract for the new credential pair, narrowed to the one remaining way a profile can end up in a partial namespaced state: `store_api_token`'s two sequential keychain writes (`<profile>:email`, then `<profile>:api-token`) being interrupted — process killed, keychain backend error, disk full — between the two writes, during a normal `jr auth login <profile>` call. This is unrelated to migration; with BC-1.4.032's copy step removed, there is no copy-then-delete sequence left for a partial LEGACY pair to interrupt (ADR-0020 §Decision 2a: "the mid-migration crash… scenario… dissolves entirely — there is no copy-then-delete sequence left to interrupt").

**Preconditions**:
1. For a namespaced pair (`<profile>:email`/`<profile>:api-token`), exactly one of the two keys is present and the other is absent — regardless of whether a legacy flat pair exists, or is itself partial, elsewhere in the keychain; legacy-pair state never gates this check (BC-1.4.032 never reads it as anything but an existence flag).

**Postconditions**:
1. `load_api_token(profile)` returns `Err` — never a silently-incomplete `Ok` with a placeholder/empty value for the missing field.
2. The error message is actionable: `JrError::UserError` (exit 64), `"Incomplete credentials stored for profile '{profile}' — run \`jr auth login {profile}\` to fix this."` (ADR-0020 §Decision 2a) — a strict subset of BC-1.4.032's "both absent" error's remedy (the identical command), so a user never has to diagnose which case they hit before acting.
3. `jr auth login <profile>` always OVERWRITES both namespaced keys unconditionally — this is already `store_api_token`'s existing behavior (a plain two-key write, not a read-modify-write), so re-running login after a partial-write failure cleanly repairs the profile with no bespoke recovery logic needed in `store_api_token` itself. The read-side guard never converts this recoverable state into a hard lockout.

**Invariants**:
1. Same failure-mode philosophy as BC-1.4.028: prevents silent half-credential use, which could otherwise produce a confusing downstream 401 rather than a clear upfront diagnostic.
2. **(SR-009, F2-gate fix) Remediation messaging drops `jr auth logout` entirely.** The prior draft's message style ("run `jr auth logout`/`jr auth login` to restore a clean state") is WRONG for this credential kind: `jr auth logout` is OAuth-session-clear-only by design (BC-1.2.013, amended) and is a no-op for an api-token profile's credentials — recommending it here would send the user to a command that cannot fix anything. The only two correct remediation commands are `jr auth login <profile>` (overwrite both keys cleanly — the primary fix, Postcondition 2's message) or `jr auth remove <profile>` (clear both keys outright, if the user prefers to abandon the profile instead of repairing it) — never `jr auth logout`.
3. This is now the ONLY partial-state branch for the per-profile API-token pair. The legacy-partial branch the original draft's Precondition 2 described is REMOVED along with BC-1.4.032's copy step (ADR-0020 §Decision 2a).

**Edge Cases**:
- EC-1.4.033-1 (REVISED, F2-gate fix): `default:email` present, `default:api-token` absent, AND a complete legacy flat pair also exists in the keychain → the namespaced partial-write state still takes precedence (namespaced keys are checked first, BC-1.4.031 Postcondition 2) — this surfaces the partial-write `Err` above. Retained only to confirm the namespaced check still runs first; there is no "falling through to the legacy pair" behavior left to guard against, since BC-1.4.032 never reads or copies the legacy pair under any circumstance.
- EC-1.4.033-2 (REMOVED, F2-gate fix): the original draft's "legacy-flat-pair-partial" edge case (one of the two legacy flat keys present, the other absent, interrupting a copy-then-delete) no longer applies — there is no copy step for it to interrupt. If a legacy flat pair happens to be partial for unrelated reasons (e.g. a user's own manual keychain edit), `load_api_token` never inspects it closely enough to notice: BC-1.4.032's legacy-pair check is existence-only and outcome-agnostic (Postcondition 1's "present OR absent, same outcome") and does not distinguish a complete legacy pair from a partial one — both produce the identical "no credentials stored" error.

**Verification Properties**:
- **VP-AUTHDX-008 — No-half-credential safety invariant, NAMESPACED-PAIR case only (SAFETY INVARIANT, REWRITTEN 2026-09-01, F2-gate fix — narrowed from the original 2×2 namespaced/legacy matrix to the single namespaced-pair axis; was PROMOTED 2026-09-01 F2 VP-delta pass merging VP-cycle3-018/019).** Property: for either of the two namespaced partial-state combinations — `email` present/`api-token` absent, or `api-token` present/`email` absent — `load_api_token(profile)` ALWAYS returns `Err` with the actionable `"Incomplete credentials… run jr auth login {profile}"` message, NEVER a panic and NEVER a silently-incomplete `Ok` with a placeholder/empty value. The original draft's legacy-flat-pair partial axis is REMOVED — there is no migration write for a legacy-partial state to interrupt (ADR-0020 §Decision 2a). Promoted because a silent half-credential `Ok` is the exact failure mode that produces a confusing downstream 401 instead of a clear upfront diagnostic (same philosophy as BC-1.4.028's OAuth partial-state `Err`, which this BC mirrors) — this remains a data-integrity safety net, just over a narrower state space than originally drafted. **Verification method**: property test (`proptest`) over the 2-member namespaced partial-state set, asserting `Err` + no-write-side-effects on every generated case; the exact message-substring assertion is retained as a fixed regression seed. **F6 target**: `src/api/auth.rs::load_api_token`.

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-315; ADR-0020 §Decision 2 item 4 (ORIGINAL); F2-gate fix (2026-09-01, HUMAN DECISION) — REWRITTEN to the namespaced-pair-only model per ADR-0020 §Decision 2a (the legacy-partial branch is dissolved, not merely deprioritized, since BC-1.4.032's no-copy redesign removes the copy-then-delete sequence it existed to interrupt); SR-009 — remediation message corrected to drop `jr auth logout` (a no-op for api-token profiles, BC-1.2.013 amended) in favor of `jr auth login`/`jr auth remove` only; VP-AUTHDX-008 narrowed to the namespaced-pair axis; cross-reference BC-1.4.028 (OAuth partial-state pattern this BC mirrors), BC-1.4.032 (REDESIGNED — the no-copy contract this partial-state guard now solely protects), BC-1.2.013 (amended — the `auth logout` non-destructive contract this SR-009 fix is grounded in).

---

#### BC-1.4.034: One-time `jr auth login <profile>` re-login is a mandatory, breaking upgrade step for every pre-cycle-003 api-token profile

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 2 ("This is a one-time, clearly-communicated BREAKING CHANGE") + § Breaking-Change Acknowledgment; DEC-315
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, F2-gate fix) — formalizes the breaking-change contract BC-1.4.032's no-copy redesign requires

**Description**: Because `load_api_token` (BC-1.4.032, redesigned) never copies the legacy shared flat `email`/`api-token` pair into any profile's namespaced slot, EVERY api-token-method profile that existed before cycle-003 (which, prior to this cycle, is every api-token profile — there was no other storage option) loses working authentication on first use after upgrading to a cycle-003-or-later `jr` binary, until that profile runs `jr auth login <profile>` exactly once. This BC pins that this is intentional, one-time, and requires explicit user action — not a bug, not a silent recovery, and not deferred to a later cycle.

**Preconditions**:
1. A profile with `auth_method == "api_token"` (or unset) was created and successfully authenticated using a pre-cycle-003 `jr` binary (i.e., its credentials live only in the legacy shared flat `email`/`api-token` keychain pair, never in a `<profile>:email`/`<profile>:api-token` namespaced pair).
2. The user upgrades to a cycle-003-or-later `jr` binary and invokes any command that resolves auth for that profile, without having run `jr auth login <profile>` since upgrading.

**Postconditions**:
1. The command fails via BC-1.4.032's actionable exit-64 error: `"No credentials stored for profile '{profile}'. This version of jr requires per-profile credentials — run \`jr auth login {profile}\` to set them up."`.
2. Running `jr auth login <profile>` exactly once (no flags required beyond what a normal login needs — `auth_method` is already known from the existing config entry) writes the namespaced `<profile>:email`/`<profile>:api-token` pair and permanently resolves the failure for that profile; no second re-login is ever required for the same profile.
3. This is a PER-PROFILE cost: a user with N pre-cycle-003 api-token profiles must run `jr auth login <profile>` once for each of the N profiles — there is no bulk/one-shot remediation command in this cycle's scope.
4. The legacy shared flat pair remains untouched in the keychain throughout and after this remediation (BC-1.4.032 Invariant 1) — re-login does not depend on, read, or clean up the legacy pair.

**Invariants**:
1. No auto-migration exists or is planned for this cycle — this BC documents a permanent, deliberate cost of the no-copy redesign (ADR-0020 §Decision 2's Rationale), not a temporary rough edge pending a follow-up fix.
2. A future, separate `jr auth` cleanup command that deletes now-orphaned legacy flat keys is a recommended follow-up (ADR-0020 §Decision 2) but is explicitly OUT of this cycle's scope — this BC does not require or imply its existence.

**Edge Cases**:
- EC-1.4.034-1: a profile created FOR THE FIRST TIME on a cycle-003-or-later binary never hits this failure at all — it never had legacy flat credentials to lose; this BC applies only to profiles that pre-date the upgrade.
- EC-1.4.034-2: a user who upgrades but never invokes any command needing that profile's auth (e.g. only ever uses a different, already-migrated profile) never observes the failure — it is lazy-on-use, not eager-on-upgrade (there is no startup-time scan of all profiles).

**Verification Properties**: None dedicated to this BC. This is an ordinary F4 test acceptance criterion (assert the exit-64 error fires for a simulated pre-cycle-003 keychain state, and that a single subsequent `jr auth login <profile>` clears it permanently) anchored directly to BC-1.4.032's Postconditions — not a distinct property beyond what VP-AUTHDX-005/006/007 already prove at the `load_api_token` layer.

**F4 doc-fallout obligation**: this breaking change MUST be called out in the CHANGELOG entry for the release that ships cycle-003 (per the general CHANGELOG-for-breaking-changes convention this corpus already follows for BC-1.2.047/S-663-1 and BC-1.2.051/DEC-321) and in any standalone migration-notes document this cycle produces — the F4 implementing story is responsible for drafting this entry; it is not optional polish.

**Trace**: F2-gate fix, cycle-003 `auth-profile-dx` (2026-09-01); ADR-0020 §Decision 2 ("one-time, clearly-communicated BREAKING CHANGE" + § Breaking-Change Acknowledgment); DEC-315; cross-reference BC-1.4.032 (REDESIGNED — the no-copy contract this BC's breaking-change consequence follows from), BC-1.4.033 (the partial-write sibling — unaffected by this BC), BC-1.2.051/DEC-321 (this corpus's prior breaking-change-acknowledgment precedent).

---

### 1.5 OAuth State Machine

#### BC-1.5.031: Embedded OAuth callback URL is exactly `http://127.0.0.1:53682/callback`

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~374`; CLAUDE.md; ADR-0006
**Subject**: Auth & Identity
**Behavior**: `EMBEDDED_CALLBACK_PORT: u16 = 53682`. IPv4 literal `127.0.0.1` (NOT `localhost` — avoids macOS/Chrome `localhost`→`::1` resolver pitfall). Atlassian validates `redirect_uri` by EXACT string match. Changing this is a breaking release.
**Trace**: Pass 3 BC-031 (R1); BC-1140/1141 (R4)

---

#### BC-1.5.032: `RedirectUriStrategyRequest::Fixed(p)` produces EADDRINUSE friendly error

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~427`
**Subject**: Auth & Identity
**Behavior**: On port-in-use: `"port {p} is in use; the jr OAuth callback needs this port. Set --client-id/--client-secret (or set JR_OAUTH_CLIENT_ID/JR_OAUTH_CLIENT_SECRET) to fall back to a dynamic port."` Contains 5 substrings: `port 53682 is in use`, `the jr OAuth callback needs this port`, `--client-id/--client-secret`, `JR_OAUTH_CLIENT_ID/JR_OAUTH_CLIENT_SECRET`, `dynamic port`.
**Trace**: Pass 3 BC-032 (R1); BC-1161 (R4)

---

#### BC-1.5.033: `ResolvedRedirect` private fields prevent listener detachment from strategy

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~455`
**Subject**: Auth & Identity
**Behavior**: Type-system-enforced TOCTOU-closure. Caller cannot move listener out and derive a redirect_uri from strategy that no longer matches.
**Trace**: Pass 3 BC-033 (R1)

---

#### BC-1.5.034: BYO OAuth uses `DynamicPort` (dynamic `:0`); embedded uses `FixedPort(53682)`

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~927`
**Subject**: Auth & Identity
**Behavior**: `RedirectUriStrategy::FixedPort(53682).redirect_uri() == "http://127.0.0.1:53682/callback"` (IPv4). `DynamicPort(54321).redirect_uri() == "http://localhost:54321/callback"` (localhost). The two literals differ; Atlassian validates by exact match.
**Trace**: Pass 3 BC-1140 (R4)

---

#### BC-1.5.035: `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~882`; Pass 3 R4 §3.10
**Subject**: Auth & Identity
**Behavior**: CSRF state token generation. State is validated at callback step.
**Trace**: Pass 3 BC-1146 (R4)

---

#### BC-1.5.036: OAuth flow has NO PKCE (`code_challenge`/`code_verifier` absent)

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~608`
**Subject**: Auth & Identity
**Behavior**: `build_authorize_url` does not include PKCE parameters. NFR-S-A (MEDIUM): defense-in-depth gap per RFC 8252. Documented as POLICY-DECISION.
**Trace**: Pass 3 BC-1148, BC-1149 (R4)

---

#### BC-1.5.037: `build_authorize_url` percent-encodes hostile `client_id` containing injection chars

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~1043`
**Subject**: Auth & Identity
**Behavior**: `client_id` containing `&redirect_uri=evil.example#frag` → output has `client_id=real_id%26redirect_uri%3Devil.example%23frag` and MUST NOT contain `&redirect_uri=evil.example`.
**Trace**: Pass 3 BC-1149 (R4); Top-30 BC rank #2

---

#### BC-1.5.038: `accessible_resources` first-wins for cloud_id discovery (silent first-only)

**Confidence**: HIGH
**Source**: Pass 3 R4 §3.10; `src/api/auth.rs`
**Subject**: Auth & Identity
**Behavior**: After token exchange, `accessible_resources.first()` is used for cloud_id. No prompt if multiple sites — first is silently used (NEW-INV-179).
**Trace**: Pass 3 BC-1176 (R4)

---

#### BC-1.5.039: OAuth token stored as `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token` post-login

**Confidence**: HIGH
**Source**: `src/api/auth.rs` (post-exchange persistence)
**Subject**: Auth & Identity
**Behavior**: Tokens are namespaced to profile. Profile config written post-storage.
**Trace**: Pass 3 BC-1151 (R4)

---

#### BC-1.5.040: OAuth callback validates state (CSRF check) before token exchange

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~898`; Pass 3 R4 §3.10
**Subject**: Auth & Identity
**Behavior**: State mismatch → abort with error; keychain NOT touched.
**Trace**: Pass 3 H-047 (holdout)

---

#### BC-1.5.041: `extract_query_param` parses `code` and `state` from HTTP GET request line

**Confidence**: HIGH
**Source**: `src/api/auth.rs:~948`
**Subject**: Auth & Identity
**Behavior**: `extract_query_param("GET /callback?code=abc123&state=xyz HTTP/1.1\r\n", "code")` → `Some("abc123")`. Missing param → `None`. No query string → `None`.
**Trace**: Pass 3 BC-1142, BC-1143, BC-1144 (R4)

---

### 1.6 Auth Error Handling & 401 Dispatch

#### BC-1.6.042: 401 + `scope does not match` body → InsufficientScope with 5 required substrings

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~99`
**Subject**: Auth & Identity
**Behavior**: 401 body containing `scope does not match` (case-insensitive) → `JrError::InsufficientScope`. Display MUST contain: `Insufficient token scope`, raw gateway message, **the resolved required scope name** (`write:jira-work` when `required_scope` is `None`, otherwise the call-site-supplied scope name such as `write:servicedesk-request`), `OAuth 2.0`, `github.com/Zious11/jira-cli/issues/185`. Exit code 2.

**Empty-Some policy:** Construction sites MUST pass either `None` or `Some(s)` where `s` is a non-empty ASCII scope name. To enforce this defensively, the Display impl treats `Some("")` identically to `None` — i.e., falls back to `write:jira-work`. The thiserror template MUST use `.filter(|s| !s.is_empty())` between `as_deref()` and `unwrap_or` to enforce this. A unit test MUST pin `Some("")` → fallback behavior.

**Trace**: Pass 3 BC-015; BC-1085 (R4); Top-30 BC rank #1
**Change**: [MODIFIED 2026-05-19 issue #382] Parameterized substring #3 to support runtime-resolved scope name via `JrError::InsufficientScope { required_scope: Option<String> }` field. Backward-compatible: `None` branch preserves historical literal `write:jira-work`. [MODIFIED 2026-05-19 issue #382 pass-02] Added Empty-Some policy: Some("") treated as None per defensive fallback.

---

#### BC-1.6.043: 401 without scope-mismatch substring → NotAuthenticated, NOT InsufficientScope

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~146`
**Subject**: Auth & Identity
**Behavior**: 401 with `Session expired` body → `Not authenticated`. MUST NOT contain `Insufficient token scope`.
**Trace**: Pass 3 BC-016; BC-1086 (R4)

---

#### BC-1.6.044: 401 scope-mismatch match is case-insensitive (`to_ascii_lowercase`)

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~183`
**Subject**: Auth & Identity
**Behavior**: `"Unauthorized; Scope Does Not Match"` (mixed case) → InsufficientScope.
**Trace**: Pass 3 BC-017; BC-1087 (R4)

---

#### BC-1.6.045: Non-401 status with scope-mismatch substring does NOT dispatch to InsufficientScope

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~219`
**Subject**: Auth & Identity
**Behavior**: 403 with `scope does not match policy` → `API error (403)`, NOT InsufficientScope. Status gate prevents broadening.
**Trace**: Pass 3 BC-018; BC-1088 (R4)

---

#### BC-1.6.046: `auth list` table snapshot: 5 columns (NAME, URL, ENV, AUTH, STATUS), active profile with `* ` prefix

**STATUS: AMENDED (2026-09-01, cycle-003 `auth-profile-dx`, DEC-324) — DELIBERATE, ACKNOWLEDGED BREAKING CHANGE** to the previously-pinned 4-column insta-snapshot. The `env` tag (DEC-314) is added as a table column rather than left JSON-only, resolving F1 Open Question 7 at the architecture level (ADR-0020 §Decision 4): the tag's entire purpose — distinguishing prod/sandbox/uat profiles at a glance — is defeated if it is invisible in the one place a human scans all profiles side-by-side.

**Confidence**: HIGH
**Source**: `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` (snapshot regeneration is an F4 implementation-story deliverable, not performed by this F2 spec pass); ADR-0020 §Decision 4
**Subject**: Auth & Identity
**Behavior**: Columns: `NAME, URL, ENV, AUTH, STATUS` — `ENV` inserted between `URL` and `AUTH` (grouping the two profile-identity/environment-facing columns before the two mechanism/health columns). Active profile prefixed `* ` (asterisk-space). Inactive: `  ` (2 spaces). `ENV` cell shows the profile's `env` value verbatim when set (subject to the display-sanitization transform in EC-1.6.046-2), or an empty/placeholder cell when unset — see EC-1.6.046-1 for the exact rendering contract. 3-profile fixture (to be extended in F4 with at least one `env`-tagged profile): default* (api_token), sandbox (oauth), staging (api_token). All STATUS cells `configured`.

**Ownership (H-2, adversary pass-2 fix):** This BC (together with BC-1.6.047's JSON-channel counterpart) is the OWNER of the `env` display-sanitization requirement bc-6's BC-6.1.015 cross-references — bc-6 owns the `ProfileConfig.env: Option<String>` STORAGE contract (raw, lossless, no sanitization at that layer); this BC owns the TERMINAL/human-table DISPLAY-layer sanitization behavior specifically (EC-1.6.046-2). BC-1.6.047 owns the companion JSON-channel behavior (verbatim/lossless, per #398's machine-channel convention) and the human-text (`auth status`) channel's sanitization.

**Previous version (superseded by DEC-324, retained for audit trail):**
> **Behavior**: Columns: `NAME, URL, AUTH, STATUS`. Active profile prefixed `* ` (asterisk-space). Inactive: `  ` (2 spaces). 3-profile fixture: default* (api_token), sandbox (oauth), staging (api_token). All STATUS cells `configured`.

**Edge Cases**:
- EC-1.6.046-1 (O-4, F2-gate fix): the human-table `ENV` cell's blank-vs-placeholder rendering MUST match the JSON contract's `""`-vs-`null` distinction from BC-1.6.047 — these are two OBSERVABLY DIFFERENT states, not one collapsed display. Concretely: `env: Some("")` (a profile whose `env` field is explicitly set to an empty string — e.g. via a hand-edited `config.toml` `env = ""`) renders as a genuinely BLANK cell (zero visible characters between the column's cell boundaries, same as any other column's blank content would render); `env: None` (the field absent/unset entirely — the common case for a profile predating this cycle, or one that never had `env` set) renders with a visible PLACEHOLDER character, `-` (a single hyphen), so a human scanning the table can distinguish "this profile was explicitly tagged with an empty string" from "this profile was never tagged at all." This replaces the original draft's punt ("exact placeholder text… is an F4 implementation-story detail, not fixed by this BC") — the distinction is now fixed at the spec layer because it is the human-table's one required parity point with BC-1.6.047's JSON `""`-vs-`null` contract, not an arbitrary cosmetic choice left to the implementer.
- EC-1.6.046-2 (NEW, H-2, adversary pass-2 fix — display-layer sanitization, resolves the contradiction with bc-6's BC-6.1.015 cross-reference): before a non-empty `env` value is written into the `ENV` cell, it is CONTROL-CHARACTER/ANSI-ESCAPE-STRIPPED and LENGTH-CAPPED — mirroring the class of display-safety transform this corpus already applies elsewhere (`display_sanitize_filename`'s CWE-116 transform, S-576-1), applied here to a different field for the identical reason (an untrusted/hand-edited config value must never corrupt the rendered table or inject terminal control sequences). Concretely: (a) ASCII control characters (`0x00`–`0x1F`, `0x7F`) and ANSI CSI/OSC escape sequences are stripped from the value before insertion into the `comfy-table` cell; (b) the sanitized value is capped to a fixed maximum display length, with a truncation marker appended when capped. This is a DISPLAY-layer transform ONLY — the value bc-6's BC-6.1.015 stores in `config.toml` and returns from `ProfileConfig.env` is NEVER modified, truncated, or rejected by this transform; only the rendered TABLE CELL's bytes are sanitized, at the point this BC's table-formatting code path consumes the stored value. This closes the H-2 contradiction: bc-6's BC-6.1.015 cites this BC (not itself) as the display-sanitization owner, and prior to this EC that citation resolved to a BC that stated the opposite ("displayed verbatim, no rejection, no truncation" — see BC-1.6.047 EC-1.6.047-1, now scoped to the JSON channel only).

**Trace**: Pass 3 BC-1115 (R4); F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01, DEC-314/DEC-324) — 5th column added, ADR-0020 §Decision 4 resolves F1 Open Question 7; F2-gate fix (2026-09-01, O-4) — EC-1.6.046-1 added, fixing the `Some("")`-vs-`None` table-rendering distinction (blank vs. `-` placeholder) to match BC-1.6.047's JSON `""`-vs-`null` contract, replacing the prior "F4 implementation-story detail" punt; adversary pass-2 fix (2026-09-01, H-2) — Ownership clause and EC-1.6.046-2 added, resolving the contradiction with bc-6's BC-6.1.015 cross-reference by making this BC the actual owner of the terminal/human-table display-sanitization contract (control-character/ANSI-escape strip + length cap), scoped to the display layer only — storage stays verbatim per bc-6's BC-6.1.015; cross-reference BC-1.6.047 (AMENDED, H-2 — the JSON-shape sibling contract for `env` display, split into JSON-verbatim vs. human-text-sanitized channels, and the `""`-vs-`null` distinction EC-1.6.046-1 mirrors); the actual insta snapshot file is regenerated as part of the F4 implementing story, not by this spec pass. **Cross-ref confirmed (integrate pass, 2026-09-01):** bc-6's BC-6.1.015 (`ProfileConfig.env: Option<String>`, `bc-6-config-cache.md` §6.1) cites this BC and BC-1.6.047 as its display-layer consumers (see its "Cross-reference (bc-1, not authored here)" clause) — this BC and BC-1.6.047 are confirmed (adversary pass-2, H-2) to actually own that requirement as of EC-1.6.046-2 and BC-1.6.047's channel split, resolving the previous contradiction.

---

#### BC-1.6.047: `env` tag is surfaced unconditionally in `auth list --output json` and `auth status` JSON/text output — JSON channel verbatim/lossless, human/text channel sanitized

**STATUS: AMENDED (2026-09-01, adversary pass-2 fix, H-2)** — splits the channel behavior explicitly. The original draft's Postcondition 2 conflated "JSON and human-text modes alike" under one "verbatim, no rejection, no truncation" rule (EC-1.6.047-1), which directly contradicted BC-1.6.046's (amended) requirement that the human-table `ENV` column be control-character/ANSI-escape-stripped and length-capped before rendering. This amendment resolves the contradiction by scope: the JSON channel (`auth list --output json`, and `auth status`'s JSON output once NFR-O-N is resolved) stays VERBATIM/LOSSLESS — consistent with issue #398's established machine-channel-is-lossless convention (`issue edit` description echo asymmetry) — while the human/text channel (`auth status` text output) applies the SAME terminal display-sanitization transform BC-1.6.046 (amended) applies to `auth list`'s table.

**Confidence**: HIGH
**Source**: ADR-0020 §Decision 4; DEC-314; DEC-324
**Subject**: Auth & Identity
**Origin**: NEW (cycle-003 `auth-profile-dx`, DEC-314/DEC-324)

**Description**: The additive `env`/role tag (schema field itself owned by bc-6's config-schema BCs — cross-ref TODO for the integrate pass) is surfaced in every profile-listing/status output path. This BC covers the JSON-shape contract (verbatim/lossless) AND the `auth status` human-text channel's sanitization contract; BC-1.6.046 (amended) covers the human-TABLE column contract specifically for `auth list`, using the identical sanitization transform this BC requires for `auth status`'s human-text channel. **(H-2, adversary pass-2 fix)** BC-1.6.046 and this BC are jointly the OWNERS of the `env` display-sanitization requirement bc-6's BC-6.1.015 cross-references.

**Preconditions**:
1. At least one configured profile exists, with `env` set to some string or left unset (`None`).

**Postconditions**:
1. `jr auth list --output json` includes an `"env"` key for every profile object: the configured string value when set, or JSON `null` when unset/absent. The key is never OMITTED — every profile object carries the key, only its value varies. This value is VERBATIM/LOSSLESS — no sanitization, stripping, or truncation is ever applied to the JSON channel (H-2, adversary pass-2 fix — see Postcondition 2b for the contrasting human-text rule).
2a. **JSON channel (H-2, adversary pass-2 fix — renumbered/split from the original Postcondition 2):** `jr auth status --output json` (once NFR-O-N's documented gap is resolved — see EC-1.6.047-2), for whichever profile(s) it reports on, surfaces the same `env` value using the same "present with `null` for unset" convention as `list` — no divergence between `list` and `status`'s JSON shapes for this field, and the value remains VERBATIM/LOSSLESS, identical in spirit to issue #398's machine-channel-is-lossless convention (the JSON consumer gets the raw stored string, `""` vs `null` faithfully preserved, regardless of its byte content).
2b. **Human/text channel (NEW, H-2, adversary pass-2 fix):** `jr auth status`'s human-text output surfaces the `env` value through the IDENTICAL terminal display-sanitization transform BC-1.6.046's EC-1.6.046-2 defines for `auth list`'s `ENV` table column (control-character/ANSI-escape strip, then length cap) — this is a DISPLAY-layer transform only; the underlying stored value (and everything the JSON channel reports per Postcondition 2a) is unaffected. `env: None` renders with the same `-` placeholder convention BC-1.6.046 EC-1.6.046-1 defines for the table; `env: Some("")` renders as blank, identically.
3. An old `config.toml` profile entry predating the `env` field deserializes with `env: None` and is displayed identically to a profile that explicitly has no `env` tag set — no migration-required distinction is observable to the user, in either channel.

**Invariants**:
1. No enum/allowlist validation is imposed on `env`'s value — whatever string (or absence) the config carries is accepted; `prod`/`sandbox`/`uat` are examples, not an exhaustive set (ADR-0020 §Decision 4). This is orthogonal to Postcondition 2b's DISPLAY sanitization: sanitization strips/caps how a human-text value RENDERS, it never rejects or validates the underlying value's content.
2. `env` is a human-readable label only — it is NOT an access-control boundary; `url` remains the actual environment lock. This BC does not change auth/authorization behavior in any way, only display.
3. **(H-2, adversary pass-2 fix) Channel-lossless/channel-sanitized split is permanent, mirroring #398:** this is the same architectural pattern CLAUDE.md's `issue edit` description-echo asymmetry already establishes for this codebase (human channel optimizes for scannability/safety, machine channel is lossless) — do NOT collapse the two channels to match each other in either direction; a future change that makes the JSON channel sanitized, or the human channel verbatim, is a regression of this Invariant.

**Edge Cases**:
- EC-1.6.047-1 (SCOPE NARROWED, H-2, adversary pass-2 fix — was previously channel-unqualified, which was the contradiction this amendment fixes): a profile with `env` set to an unusual/arbitrary or hostile string (e.g. `"my-custom-tag"`, or a string containing ANSI escapes/control characters) → in the **JSON channel** (`auth list --output json`, `auth status --output json` once implemented), displayed verbatim, no rejection, no truncation, no stripping — this EC now applies to the JSON channel ONLY. For the **human/text channel** (`auth status` text output, and `auth list`'s table via BC-1.6.046), see EC-1.6.047-3 below — the value is sanitized before display, it is NOT shown verbatim.
- EC-1.6.047-2: `auth status --output json` is NOT currently implemented at all per NFR-O-N (documented gap) — this BC's `status` JSON obligation (Postcondition 2a) is therefore contingent on that gap's resolution; until then, this BC's Postcondition 2b (human-text sanitization) applies to `status`'s only currently-existing output mode, and the JSON obligation applies in full to `list` only. (Flagged explicitly so this BC is not read as silently implementing NFR-O-N's deferred JSON support as a side effect.)
- EC-1.6.047-3 (NEW, H-2, adversary pass-2 fix — human/text channel sanitization, mirrors BC-1.6.046 EC-1.6.046-2): `jr auth status`'s human-text `env` display strips ASCII control characters (`0x00`–`0x1F`, `0x7F`) and ANSI CSI/OSC escape sequences from the value, then caps it to the same fixed maximum display length BC-1.6.046 EC-1.6.046-2 defines (with a truncation marker when capped), before writing it to the terminal. This is the human/text-channel counterpart to BC-1.6.046's table-cell sanitization — same transform, different rendering surface. The stored `config.toml` value is never modified by this transform; only the rendered text is sanitized.

**Verification Properties**: None dedicated to this BC. **[TRIAGED 2026-09-01, F2 VP-delta pass]** Both original draft candidates are ordinary JSON-shape/output-formatting checks (specific field-presence and value assertions for a fixed set of example profiles) — DEMOTED to two ordinary F4 test acceptance criteria anchored directly to Postconditions 1/3 (test-writer implements as standard JSON-shape assertions). The genuine underlying PROPERTY that VP-cycle3-021 was reaching for — "an old `config.toml` with the `env` key absent deserializes indistinguishably from an explicit absence, with no migration required, across the full input space of possible pre-cycle-003 config shapes" — is a schema/deserialization-layer property, not a display-layer one; it is promoted instead at its correct layer as **VP-AUTHDX-009**, declared at BC-6.1.015 in `bc-6-config-cache.md` §6.1 (the `ProfileConfig.env` field's own storage contract). This BC's display layer merely echoes whatever that lower-layer property already guarantees. **(H-2, adversary pass-2 fix)** Postcondition 2b's human-text sanitization and EC-1.6.047-3 are likewise ordinary F4 test acceptance criteria (assert the same control-character/ANSI-strip + length-cap behavior BC-1.6.046's table-cell test already covers, applied to `auth status`'s text output) — no new dedicated VP is warranted; the sanitization LOGIC itself is one shared transform exercised by two call sites (BC-1.6.046's table cell, this BC's status text line).

**Trace**: F2 spec evolution, cycle-003 `auth-profile-dx` (2026-09-01); DEC-314; DEC-324; ADR-0020 §Decision 4; adversary pass-2 fix (2026-09-01, H-2) — STATUS banner added; Postcondition 2 split into 2a (JSON, verbatim/lossless per issue #398 convention) and 2b (human/text, sanitized per BC-1.6.046 EC-1.6.046-2); EC-1.6.047-1 scope-narrowed to the JSON channel only; EC-1.6.047-3 added for the human-text sanitization transform; Invariant 3 added pinning the channel split as permanent; cross-reference BC-1.6.046 (AMENDED — human-table column contract AND joint owner, with this BC, of the display-sanitization requirement), NFR-O-N (`auth status --output json` gap, cited for scope discipline). **Cross-ref confirmed (integrate pass, 2026-09-01):** the `ProfileConfig.env: Option<String>` schema field's additive/tolerant-deserialization storage contract, including VP-AUTHDX-009, is BC-6.1.015 in `bc-6-config-cache.md` §6.1, which cross-links back to this BC and BC-1.6.046 as its display-layer consumers — as of the H-2 fix, this BC and BC-1.6.046 are confirmed to actually own that requirement, resolving the previous verbatim-vs-sanitized contradiction.

---

## Summary Stats

| Subdomain | BCs | Confidence |
|-----------|-----|-----------|
| 1.1 OAuth Flow & Profile Resolution | 16 | All HIGH |
| 1.2 Profile Lifecycle Management | 11 | All HIGH |
| 1.3 Embedded OAuth App | 6 | All HIGH |
| 1.4 Token Keychain Layout | 10 | All HIGH |
| 1.5 OAuth State Machine | 11 | All HIGH |
| 1.6 Auth Error Handling & 401 Dispatch | 6 | All HIGH |
| **Total** | **60** | **60 HIGH** |

**(M-2, adversary pass-2 fix, 2026-09-01)**: table recomputed from actual `#### BC-` headings — was stale at 58 (§1.1 undercounted at 15, §1.4 undercounted at 9) since the F2-gate fix pass added BC-1.1.016 and BC-1.4.034 without updating this table. Table Total (60) now matches frontmatter `definitional_count: 60`.

Note: 71 total BCs (cumulative, incl. range-collapsed) including 11 additional pre-cycle-003 R4 contracts (BC-1140..1178 subset) incorporated inline above, plus 13 new individually-bodied contracts added in cycle-003's `auth-profile-dx` work (2026-09-01, DEC-312..325, ADR-0020/ADR-0011): 11 from the F2 spec evolution pass (BC-1.1.013/014/015, BC-1.2.048/049/050/051, BC-1.4.031/032/033, BC-1.6.047) plus 2 from the same-day F2-gate fix pass (BC-1.1.016, BC-1.4.034). The complete pass-3 BC mapping is in BC-INDEX.md (bc-6/BC-INDEX.md reconciliation of this file's new total is an integrate-pass task, not performed here per the coordination boundary).
