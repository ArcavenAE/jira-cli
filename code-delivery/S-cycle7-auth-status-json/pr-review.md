# PR Review — #807 `feat(auth): add --output json to auth status, retire NFR-O-N`

**Verdict: APPROVE** — 0 BLOCKING, 0 MAJOR, 2 MINOR, 1 NIT, 4 INFO.

Reviewed at `0992e5c80622388d6c8d2515f19334c504776c56` (`feat/cycle7-auth-status-json` → `develop`).
Fresh-eyes review of the diff, PR description, and test evidence only.

> **Note on scope:** I began this review at `6c75a642` and a doc-fix commit
> (`0992e5c8`, three `docs/specs/` files) landed mid-review. I re-reviewed the delta
> and this verdict covers the full `origin/develop...0992e5c8` range — see
> "Addendum: commit `0992e5c8`" at the bottom.

---

## What I verified (not a rubber stamp)

Every one of the 8 changed files was read in full or in diff context:
`.cargo/mutants.toml`, `CHANGELOG.md`, `CLAUDE.md`, `src/cli/auth/mod.rs`,
`src/cli/auth/status.rs`, `src/cli/auth/tests/mod.rs`, `src/main.rs`,
`tests/auth_status_json.rs`.

**1. BC-1.6.050 schema correctness — VERIFIED.**
`build_status_json` emits exactly six keys via one `serde_json::json!` literal:
`profile` (string), `url` (`Option<&str>` → string|null), `env` (string|null),
`auth_method` (string|null), `status` (`AuthState`, kebab-case-serialized →
`"unset"`/`"no-credentials"`/`"configured"`), `oauth_app` (string|null).
`AuthState` in `src/api/auth.rs` carries `#[serde(rename_all = "kebab-case")]`
and `Serialize`-only, so the wire vocabulary matches the CHANGELOG claim.
Key-set equality (no extras, none missing) is asserted twice — once on the pure
builder (inline `..._full_schema_api_token`) and once end-to-end on real stdout
(`..._status_success_dispatch_arms_covered`, sorted `assert_eq!` against the
literal 6-element array, which is the stronger form).

**2. Pure/effectful boundary — VERIFIED.**
`build_status_json` takes six plain scalars, calls `derive_auth_state` and
`output::render_json`, and touches nothing else. No keychain symbol, no
`Config::load`, no `peek_oauth_app_source` in its body. This is enforced
mechanically, not just by inspection: `test_bc_1_6_050_json_builder_is_probe_free`
brace-balances the function body out of the source text and asserts the absence
of `load_oauth_tokens`, `load_api_token`, `try_load_oauth_app_credentials`,
`peek_oauth_app_source(`, and `Config::load`. The `extract_fn_body` helper is a
real brace-depth walker, not a line-window heuristic — it will not silently pass
if the function grows.

**3. Single-probe invariant (BC-1.6.048) — VERIFIED.**
`probe_matching_kind_credential(&target_profile, method)` appears exactly once in
`status()`, computed **before** the `match output` fork, and its `bool` result is
consumed by both arms: the `Credentials:` line in the `Table` arm and the
`matching_kind_present` parameter in the `Json` arm. There is no second probe on
either path, so the two channels are structurally incapable of disagreeing.
`peek_oauth_app_source()` is likewise called at most once per invocation (once in
each mutually-exclusive arm, gated on `method == "oauth"`).

**4. `output::render_json` routing (#526) — VERIFIED.**
`build_status_json` ends in `crate::output::render_json(&obj)`; there is no direct
`serde_json::to_string_pretty` and no compact `json!` Display print anywhere in the
diff. The returned `String` is emitted with a single `println!("{json}")`, which is
byte-identical in shape to the existing `handle_list` pattern in
`src/cli/auth/list.rs` (`println!("{rendered}")`). Pretty-printing is pinned
behaviorally by `..._routes_through_render_json_pretty` (asserts a newline, a
leading `{`, and 2-space indentation) rather than by asserting the call site — a
mutant that swapped in a compact serializer would be caught.

**5. Human-text invariant — VERIFIED by diff inspection.**
All six `println!` format strings in the `Table` arm (`"Profile:     {target}"`,
`"Instance:    {url}"`, `"Env:         {}"`, `"Auth method: {method}"`,
`"Credentials: stored in keychain"` / `"Credentials: not found"`,
`"OAuth app:   {}"`) are character-identical to the pre-diff versions, in the same
order, with the same `render_env_line` sanitizer and the same
`unwrap_or("(not configured)")` placeholders. The refactor only hoisted the
`Option<&str>` bindings above the fork. Default-CI regression coverage for the text
channel exists and is real (`..._dispatch_arms_covered` asserts `Credentials: not
found`, `Profile:`, `Instance:`, presence of `OAuth app:` on the oauth profile, and
**absence** of `OAuth app:` on the api_token profile) — so the story is not relying
solely on the keyring-gated AC-006 test for text-channel protection.

**6. Test gating — VERIFIED CORRECT.**
`tests/auth_status_json.rs` has 8 `#[test]` functions; exactly 3 carry
`#[ignore = "keyring-gated: ..."]` and they are exactly AC-006/007/008, each with a
belt-and-braces in-body `JR_RUN_KEYRING_TESTS != "1"` early return (matching the
repo's documented two-layer gate idiom). The 5 default-CI integration tests and all
6 new inline tests carry no `#[ignore]`. The keychain-free strategy in
`..._dispatch_arms_covered` is sound: an isolated `JR_SERVICE_NAME`
(`jr-test-b2-nocred-dispatch`) guarantees `load_api_token`/`load_oauth_tokens`
return `Err(NoEntry)` deterministically, giving `matching_kind_present == false`
with no prompt on any CI host. The `jr()` helper scrubs 18 `JR_*`/figment env vars,
so developer-machine state cannot leak in.

**7. `.cargo/mutants.toml` — VERIFIED, including the over-exclusion risk.**
`src/cli/auth/status.rs` is added to `examine_globs` (so `build_status_json` and the
`status()` dispatch arms ARE mutated), and four `exclude_re` entries are added — an
operator/expression regex (`.+ in <fn>$`) and a whole-body regex
(`replace <fn> .*$`) for each of `probe_matching_kind_credential` and
`peek_oauth_app_source`. I specifically checked that these do **not** accidentally
swallow the pure sibling `peek_oauth_app_source_for_test`: regex A is `$`-anchored
immediately after the function name, and regex B requires a literal space after it,
whereas the sibling continues with `_for_test`. Neither matches. The pure helper
therefore stays in mutation scope, exactly as the inline comment claims.
`tests/mutants_glob_existence.rs` (the always-run orphan-glob guard) is satisfied
since `status.rs` exists.

**8. Doc fallout — VERIFIED in the same PR.**
`CLAUDE.md` architecture-tree line for `status.rs` updated (`human text only; no
JSON path` → `human text + --output json (BC-1.6.050)`), and the NFR-O-N gap bullet
rewritten to an implemented/RETIRED statement. `CHANGELOG.md` `[Unreleased] > Added`
entry is present, accurate, and correctly documents the EC-1.6.050-2 fresh-install
carve-out and the `oauth_app` null-vs-label rule. All three `oauth_app` values the
CHANGELOG lists (`"embedded"`/`"keychain"`/`"(none)"`) are exactly the subset of
`OAuthAppSource::label()` that `peek_oauth_app_source` can actually return — it
never yields `flag`/`env`/`prompt`. No overclaim.

**9. Error/edge paths — VERIFIED.**
Unknown profile still exits 64 through the pre-existing `JrError::UserError` guard
placed **before** any probe, and AC-009 asserts the shared
`assert_json_error_envelope` contract (JSON error on stderr, empty stdout, exit 64).
The fresh-install early return is untouched and still emits human text on stderr
with exit 0 and empty stdout, even with `--output json` — AC-010 is a real
regression guard on that, matching the CHANGELOG's explicit out-of-scope framing.

**10. Diff size / coherence — VERIFIED.**
+1,445 / −32 across 8 files, but only ~136 lines are production code in one file;
the remainder is tests (1,296) plus docs/config. Every file in the diff is
attributable to this story. No unrelated changes, no drive-by refactors, no new
dependencies, no `#[allow]` suppressions, no `unsafe`, no let-chains (MSRV 1.85
safe — the `if method == "oauth"` guards are plain `if`s).

---

## Findings

### MINOR-1 — PR description overstates the new-test count (category: description)

| Field | Value |
|---|---|
| Severity | suggestion (MINOR) |
| Category | description |
| Finding | The PR body reports "14 default-CI + 3 keyring-gated + 1 inline = 18 new tests" and a `tests-14/14 default CI` badge. The actual diff adds **14** new tests total: 6 inline in `src/cli/auth/tests/mod.rs` + 8 in `tests/auth_status_json.rs`, of which 3 are `#[ignore]`d. So the real split is **11 default-CI + 3 keyring-gated = 14**. The "1 inline" row also double-counts `test_bc_1_6_050_json_field_names_match_list_json`, which is already one of the 6 inline tests. |
| Suggestion | Correct the Test Evidence table and badge to `11 default-CI + 3 keyring-gated = 14 new tests`. Nothing in the code or tests needs to change — this is a description-accuracy fix only. Worth doing because these counts get cited downstream in convergence reports. |

### MINOR-2 — Four commits use a non-conventional `wip(...)` type (category: commit quality)

| Field | Value |
|---|---|
| Severity | nit/suggestion (MINOR) |
| Category | commit quality |
| Finding | `6e051950`, `aec6d346`, `7f3b277e`, `ee842afb` use the type `wip(...)`, which is not in the project's allowed Conventional Commit set (`feat:`, `fix:`, `docs:`, `chore:`, `ci:`, `test:` per CLAUDE.md § Conventions). No commit on the branch carries the `feat:` type that actually describes the change; the feature itself lands under `wip(...)`. Story ID scoping is otherwise good — every commit is scoped `(S-cycle7-auth-status-json)`. |
| Suggestion | Harmless if this merges as a squash (the PR title is already correctly `feat(auth): ...`). Please confirm the merge is a **squash** so the `wip` types do not reach `develop`'s history. If a merge commit is used instead, rewrite the four subjects to `feat(auth):`/`test(auth):` first. |

### INFO-1 — `oauth_app: "(none)"` is a human placeholder in a machine channel

`OAuthAppSource::None.label()` returns the literal string `"(none)"`, so an oauth
profile with no resolvable app source emits `"oauth_app": "(none)"` rather than
`null`. Every other absent-value field in this object (`url`, `env`,
`auth_method`) uses JSON `null`. A downstream parser must therefore special-case
the sentinel string for this one field. This is what BC-1.6.050 specifies and the
CHANGELOG documents it explicitly, so I am **not** asking for a change — flagging
only so the asymmetry is a known, deliberate property of the contract rather than
something a future reader "fixes" by accident. If the vocabulary is ever revisited,
`null` would be the more consistent encoding.

### INFO-2 — `env` verbatim in JSON vs sanitized in text (intentional, matches house style)

The JSON `env` field is byte-verbatim while the text `Env:` line routes through
`output::sanitize_env_display`. This means `--output json` can carry raw control
characters / ANSI sequences into a consumer's terminal if the value is `cat`ed
directly. I agree with the design: the value originates in the user's own
`config.toml` (not external input), and lossless machine channel + sanitized human
channel is the exact same load-bearing asymmetry the project already documents for
`issue edit`'s `description` echo. `..._status_json_env_verbatim_lossless` pins it
with a `\x01`-containing fixture, so a future "consistency fix" would fail CI
loudly. No action.

### INFO-3 — Probe now runs before the first `println!` in the text path

Pre-diff, the credential probe happened *after* the `Profile:`/`Instance:`/`Env:`/
`Auth method:` lines were printed; it is now hoisted above the `match output` fork,
so it runs before any output. Stdout bytes are unaffected (the invariant holds), but
on macOS a keychain-access prompt — or `peek_oauth_app_source`'s stderr warning on a
locked keychain — will now appear *before* the status lines rather than interleaved
after them. Cosmetic ordering only, on a channel no contract pins. Noting it so the
behavior change is on the record.

### INFO-4 — No demo evidence directory (project-wide convention, not a PR gap)

`docs/demo-evidence/` does not exist anywhere in this repository, for this or any
prior story — this project uses insta snapshots and assert_cmd subprocess tests as
its evidence channel instead. The PR body documents the skip as a human decision
consistent with sibling Wave-2 stories A and B1, with a reasonable justification
(keychain state is not reproducible on a CI host). I am therefore **not** treating
the absent recording as blocking; doing so would flag every PR in this repo. The
default-CI `..._dispatch_arms_covered` test does exercise the real binary end-to-end
on both output modes and both auth methods, which is credible substitute evidence
for an output-only change.

---

## Checklist result

| # | Item | Result |
|---|---|---|
| 1 | Diff coherence | PASS — all 8 files attributable to the story; no unrelated changes |
| 2 | Description accuracy | PASS with MINOR-1 (test counts overstated; architecture/traceability sections accurate) |
| 3 | Test coverage of changed lines | PASS — both `status()` dispatch arms, both auth methods, and the pure builder covered in DEFAULT CI; only genuinely keychain-dependent assertions are gated |
| 4 | Demo evidence | N/A — see INFO-4; documented skip, no repo-wide convention exists |
| 5 | Commit quality | PASS with MINOR-2 (`wip(...)` type ×4; story ID present on all) |
| 6 | Diff size | PASS — 1,445 insertions but only ~136 production LOC; no shard-threshold impact (`status.rs` well under 1,000 LOC) |
| 7 | Missing changes | PASS — no AC unimplemented; doc fallout (CLAUDE.md, CHANGELOG.md) and mutation config landed in the same PR, not deferred |
| 8 | Dependency status | PASS — `derive_auth_state` resolves from `src/api/auth.rs` on `develop` (PR #806 merged); import compiles |

Neither MINOR finding affects correctness or merge safety. Approving.

---

## Addendum: commit `0992e5c8` (docs-only, landed mid-review)

`docs(S-cycle7-auth-status-json): fix stale no-json claims in specs + mutants-policy
exclusion registry` — 3 files, +34/−3, all under `docs/specs/`. Reviewed in full:

- **`docs/specs/multi-profile-auth.md`** — the `jr auth status` CLI-surface block no
  longer claims "Human text only — no --output json support for this subcommand"; it
  now documents the flag and the exact 6-key object with the BC-1.6.050/story
  citation. The key list matches the implementation and `CHANGELOG.md` byte-for-byte.
  **Correct.** This was genuine doc fallout that the original 8-file diff had missed —
  good catch by the first review cycle.
- **`docs/specs/e2e-live-jira-testing.md`** — the E2E read-coverage row previously
  justified excluding `auth status` on *two* grounds ("emits no JSON and makes no API
  call"); one of those is now false. The rewrite keeps the exclusion but re-bases it on
  the still-true ground only ("now supports `--output json` (BC-1.6.050) but makes no
  Jira API call, so the E2E exclusion still stands"). This is the honest fix rather
  than deleting the row or silently widening E2E scope. **Correct.**
- **`docs/specs/cargo-mutants-policy.md`** — adds a `src/cli/auth/status.rs` entry to
  the exclusion registry covering both functions and explaining why two regexes are
  needed per function. I cross-checked the prose against the four actual patterns in
  `.cargo/mutants.toml`: the A/B operator-vs-whole-body split, the file+function
  anchoring, and the explicit statement that `peek_oauth_app_source_for_test` stays in
  scope all match the config exactly. This closes the policy-doc/config divergence that
  adding `status.rs` to `examine_globs` would otherwise have created. **Correct.**

The `Spec Guards (BC counts, numeric-count lint, citation checks, mutants policy scope)`
CI job — which runs `scripts/check-cargo-mutants-policy-citations.sh` — is **green** at
this SHA, so the new registry entry's symbol citations resolve against real `src/` code.

### NIT-1 — loose AC citations in the new policy-doc prose (category: description)

| Field | Value |
|---|---|
| Severity | nit |
| Category | description |
| Finding | The new `cargo-mutants-policy.md` entry credits "the AC-004 source-scan + call-count wiring tests" and "the AC-012/AC-013 wiring tests that assert `peek_oauth_app_source` is called in the right code path". Against this PR's actual suite: AC-004 is the two `oauth_app` shape tests (no call-count assertion exists for `probe_matching_kind_credential`), AC-013 is the purity source-scan, and AC-012 is a pure documentation artifact with no test at all (the PR's own traceability table lists it as `N/A`). The real default-CI evidence for both functions being wired correctly is `test_bc_1_6_050_status_success_dispatch_arms_covered`, which the prose does not name. |
| Suggestion | Non-blocking, and no CI guard covers AC-id prose. When convenient, replace the AC-number references with the concrete test name `test_bc_1_6_050_status_success_dispatch_arms_covered` (plus `peek_oauth_app_source_for_test`'s inline unit tests) — the repo's own citation convention prefers symbol-form over identifiers that drift. |

### Merge precondition (not a finding)

Because `0992e5c8` re-triggered the pipeline, several checks at this SHA were still
`pending` when I reviewed (`Test` on all three OSes, `Coverage`, `Clippy (windows)`,
and most `Mutation Testing (Shard)` jobs). The already-green set includes `Format`,
`Clippy (ubuntu)`, `MSRV (1.85.0)`, `Deny`, `Secret Scan`, `dependency-review`,
`Mutation Test Plan`, and crucially `Spec Guards`. The delta is documentation-only, so
I have no code-correctness reason to expect a change in outcome — but per the repo's
own `strict: false` caveat in CLAUDE.md, **confirm `ci-gate` is green at
`0992e5c8` before merging**; do not carry forward the green result from `6c75a642`.
