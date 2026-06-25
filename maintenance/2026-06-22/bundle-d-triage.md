# Bundle D — Maintenance Cleanup Triage

**Base:** `develop` @ `4022e00` (`docs(adr): promote ADR-0007..0013 to docs/adr/ (SC-03) (#549)`)
**Date:** 2026-06-22
**Scope:** SCOPING TRIAGE ONLY — no code changed. Assess + recommend.

---

## Item 1 — CR-008 (DRIFT-CR-008): `extract_job_block` test-helper duplication

### (a) Real? — YES, confirmed verbatim triplication

`fn extract_job_block<'a>(yaml: &'a str, job_name: &str) -> Option<&'a str>` is duplicated, body-identical (modulo the param name `ci_yml` vs `yaml` and comment density), in three integration-test files:

| File | Def line | Call sites |
|------|----------|-----------|
| `tests/ci_yml_windows_matrix.rs` | 68 | 4 (lines 127, 453, 506, 520) |
| `tests/ci_gate_completeness.rs` | 66 | 6 (lines 178, 244, 338, 416, 493, 563) |
| `tests/backfill_matrix_parity.rs` | 158 | 10 (lines 307, 356, 404, 446, 497, 540, 596, 695, 750, 812) |

Total: 3 definitions, 20 call sites. The algorithm (find `  <job>:\n` at two-space indent, scan to next same-indent job key or EOF) is byte-for-byte the same logic in all three.

**Related but NOT duplicate (leave alone):**
- `ci_gate_completeness.rs::parse_needs_set` (line 114) — unique to that file.
- `backfill_matrix_parity.rs::extract_build_matrix_targets` (line 84) — unique.
- `release_yml_windows_matrix.rs::step_block` (line 69) — different algorithm (step, not job); not part of this drift.
- `keyring_windows_native_feature_present.rs::parse_bans_skip_blocks` — unrelated.

### (b) Minimal fix
Add the shared helper to `tests/common/` and register it. Current `tests/common/mod.rs` only has:
```rust
pub mod fixtures;
pub mod mock_server;
```
Two clean options:
- **Option A (preferred):** new file `tests/common/yaml.rs` with `pub fn extract_job_block(...)`, add `pub mod yaml;` to `tests/common/mod.rs`. Each of the 3 test files already does `mod common;` (the pattern is established — 10+ test files reference `common`), so they switch to `common::yaml::extract_job_block` and delete their local copy.
- **Option B:** put it directly in `tests/common/mod.rs`. Slightly less tidy given the file is currently a pure re-export hub.

Note: the 3 files differ in the param name and the `expect`/`unwrap_or_else` panic messages at the *call sites* — those stay; only the function body is shared. Verify each of the 3 files actually declares `mod common;` (some matrix/CI test files may not yet — if a file lacks it, add `mod common;` at top).

### (c) Behavior change / risk — NONE
Pure test-internal refactor. No `src/` touched, no public API, no `jr` runtime behavior. Risk: a call site passes the slice to assertions; identical fn body means identical slices. Only failure mode is a missed `mod common;` declaration → compile error caught immediately.

### (d) Size — SMALL
~3 files edited (delete ~35 LOC body ×3, add ~3 `use`/path-qualify lines) + 1 new file (`tests/common/yaml.rs`, ~40 LOC) + 1 line in `tests/common/mod.rs`. Net roughly: 5 files, ~ -70 / +50 LOC.

### (e) Blockers / open questions — NONE
Trivial. Optional nicety: a one-line doc-comment on the shared helper noting it's the canonical job-block extractor for CI-YAML guard tests.

---

## Item 2 — CR-009 (KEYRING-GUARD-IDIOM-DRIFT): keyring-gate idiom unification

### (a) Real? — YES, two idioms coexist

CLAUDE.md documents the gate as `JR_RUN_KEYRING_TESTS=1`. Two run-time check idioms are in use:

**Strict canonical — `!= Ok("1")` (skip unless exactly "1"):**
- `tests/multi_cloudid_disambiguation.rs` — 6 sites (lines 289, 352, 587, 735, 822, 913)
- `tests/oauth_refresh_integration.rs` — 12 sites (243, 335, 435, 516, 579, 649, 747, 892, 1031, 1154, 1341)
- `tests/auth_output_json.rs` — 1 site (line 337, a `match` on `.as_deref()` with explicit `Some("1")` arm — strict, richer message)

**Loose — `is_err()` (skip only when the var is UNSET; any value incl. "0"/"false" runs):**
- `tests/auth_profiles.rs` — 3 sites (lines 210, 322, 372)
- `src/api/auth.rs` — 1 site (line 1349, inside `with_test_keyring`)

So the loose idiom is the minority: **4 sites across 2 files**. The bug: with `is_err()`, `JR_RUN_KEYRING_TESTS=0` (or `=false`) RUNS the keychain test, contradicting the documented "`=1` to run" contract. Low practical impact (these are `#[ignore]` and only run with `--include-ignored`), but it is a genuine semantic divergence.

### (b) Minimal fix
Convert the 4 loose sites to the canonical strict form:
```rust
if std::env::var("JR_RUN_KEYRING_TESTS").as_deref() != Ok("1") {
    eprintln!("SKIP: set JR_RUN_KEYRING_TESTS=1 to run keychain tests");
    return;
}
```
The 3 `auth_profiles.rs` sites currently `return` silently (no SKIP eprintln) — converting them gives a free consistency win on the skip message too. The `src/api/auth.rs::with_test_keyring` site returns silently by design (it wraps the body) — convert the predicate to `!= Ok("1")` but keep the early `return` (no eprintln needed there; it's a wrapper, not a test body).

**Shared-helper consideration (asked):** A shared `fn keyring_tests_enabled() -> bool { std::env::var("JR_RUN_KEYRING_TESTS").as_deref() == Ok("1") }` would prevent recurrence. Placement is awkward: the `src/api/auth.rs` site is in `src/` (inline test mod), while the others are integration tests under `tests/`. A `tests/common/` helper can't be shared with the `src/` inline test. **Recommendation:** put the helper in `tests/common/` for the integration tests; leave `src/api/auth.rs::with_test_keyring` to inline the canonical predicate (it's already a single private wrapper fn — one site, self-documenting). Do NOT over-engineer a crate-visible helper just to share one `src/` site.

**Meta-test consideration (asked):** A guard test (à la `base_url_release_gate.rs`) could grep all test files for `JR_RUN_KEYRING_TESTS` and assert none use the `is_err()` form. Worth it given this is the second idiom-drift CR in the bundle (recurrence signal). Cheap (~40 LOC, one file). Recommend including it.

### (c) Behavior change / risk — effectively NONE for CI
These tests are `#[ignore]` + keyring-gated; CI never runs them (`--include-ignored` not used in `ci.yml`). The only "change" is that `JR_RUN_KEYRING_TESTS=0` will now correctly SKIP in the 4 converted sites. No `jr` runtime behavior. No public API. Risk: trivially low.

### (d) Size — SMALL
4 predicate edits + optional shared helper (~5 LOC) + optional meta-test (~40 LOC). ~3-4 files. With meta-test + helper: ~5 files, ~ +60 / -8 LOC.

### (e) Blockers / open questions
- Q: include the meta-test guard? (Recommend YES — recurrence justifies it.)
- Q: add SKIP eprintln to the 3 silent `auth_profiles.rs` sites? (Recommend YES — free consistency.)
- No blockers. Touches CLAUDE.md only if we want to add a one-line "canonical idiom is `!= Ok(\"1\")`" note (recommend a short note under the existing keyring-test bullet).

---

## Item 3 — SEC-001 (CWE-674): uncontrolled recursion in `src/adf.rs`

### (a) Real? — YES, but with important nuance. HIGHEST-RISK ITEM.

`src/adf.rs` is 10,531 LOC. There is **no** `MAX_DEPTH` / depth guard / recursion limit anywhere in the source (grep for `MAX_DEPTH|max_depth|depth_limit|recursion_limit|nesting_limit` returns nothing in non-test code).

**Recursive functions confirmed (tree-walking, self- or mutually-recursive):**
- `normalize_list_item_content` (line 1610) — recurses on nested `blockquote`/`panel`/`taskList` (calls itself).
- `normalize_panel_content` (line 1798) — unwraps + recursively normalizes nested panels/blockquotes.
- `assign_local_ids_walk` (line 2002) — recurses into every node's `content` array (unbounded by node type).
- `AdfRenderer::render_node` / `render_children` (lines 2069 / 2322) — mutually recursive over the full tree (paragraph→children→node→…), used by `adf_to_text`.
- `autolink_bare_urls` (line 193) → walks node vecs; `split_text_node_on_urls` (line 235).
- `is_empty_block_container` (line 1493) — inspects content (shallow but called within recursive contexts).

**Important nuance on the builder:** `markdown_to_adf` does NOT build via recursion — `AdfBuilder` is **stack-based** (`stack: Vec<PartialNode>`, `start()`/`end()` push/pop). So the parse/build phase won't recurse to stack overflow on its own. **The actual recursion exposure is in the post-processing passes** (`normalize_*`, `assign_local_ids_walk`) and the **reverse render** (`adf_to_text`), which recurse over the already-built tree depth-first. Deeply-nested input (e.g. thousands of nested blockquotes `> > > …` or nested lists) produces a deeply-nested `Value` tree, and those passes then recurse to a depth proportional to nesting.

**Reachability — CONFIRMED untrusted-input path.** `markdown_to_adf` / `text_to_adf` are called from user-supplied free text:
- `src/cli/issue/create.rs:179, 181, 925, 927` (`--description` create/edit)
- `src/cli/issue/workflow.rs:1159, 1161` (`issue comment`)
- `src/cli/worklog.rs:33` (`worklog add --message`)
- `src/api/jsm/requests.rs:96, 98` (JSM request description)

So a user (or AI agent) passing pathologically nested markdown via `--description` / a comment could drive recursion depth = nesting depth. Whether it overflows the 8 MB stack (Unix) / 8 MB configured stack (Windows, per WIN-STACK) depends on per-frame size and depth; markdown nesting in the thousands is plausible via a scripted/agent payload.

**Secondary concern — pulldown-cmark parse stack:** unverified here (Perplexity unavailable this session). pulldown-cmark 0.13's parser is event-based and largely iterative, but block-nesting handling may still allocate proportional to depth. This needs a quick validation before finalizing the fix (does pulldown itself cap nesting, or pass through unlimited depth?). FLAG for the implementing story.

**Secondary concern — serde_json serialize:** the final `Value` is serialized to JSON for the API body. serde_json's serializer recurses over the tree too; default deserialize recursion limit is 128 but SERIALIZE of a hand-built deep tree can also overflow. Another reason to cap depth at the source (markdown→ADF) rather than only in our walkers.

### (b) Minimal fix — design-dependent (see open questions)
Strategy options (a real design decision, not mechanical):
1. **Cap at parse time (preferred):** thread a depth counter through `AdfBuilder` start/end (increment on container push, decrement on pop). On exceeding `MAX_NESTING_DEPTH`, either (a) return a clean `JrError::UserError("markdown nesting exceeds N levels")` (exit 64), or (b) clamp/flatten deeper nodes. Capping here protects ALL downstream passes (normalize, assign_local_ids, render, serde serialize) in one place because the tree can't get deeper than N.
2. **Cap in each recursive pass:** thread depth into `normalize_*`, `assign_local_ids_walk`, `render_node`. More sites, more error-plumbing, easy to miss one. Not recommended.
3. **Iterative rewrite (explicit work-stack):** eliminates stack-overflow risk entirely but is a large, behavior-sensitive rewrite of well-tested functions. Out of proportion for a maintenance bundle.

Recommend Option 1 (single choke point at build time) plus a defensive depth assert in `adf_to_text` if the renderer can receive externally-sourced ADF (it can — e.g. `issue view` rendering API responses; an attacker-controlled Jira instance under `JR_BASE_URL` is debug-only, but a compromised/hostile real instance could return deeply-nested ADF). So the reverse path may ALSO need a guard even if the forward path is capped.

### (c) Behavior change / risk — YES, BEHAVIOR-CHANGING + SECURITY-RELEVANT
- Introduces a new failure mode (error or truncation) on previously-accepted (if pathological) input. This is an observable contract change → needs a **BC** (new behavioral contract) and likely a short spec under `docs/specs/`.
- Must decide error-vs-clamp (see open questions) — affects exit code and `--output json` error shape.
- Needs careful tests: a proptest already nests to depth 5 (`gen_node`, line 8938, `prop_recursive(5, 24, 3, …)`) — add explicit deep-nesting tests at/above the cap, both forward (markdown→ADF) and reverse (ADF→text). Must NOT regress the existing depth-5 proptest or the large existing adf test suite.
- Risk: setting the limit too low breaks legitimate deeply-nested docs; too high doesn't prevent overflow. Needs an empirically-chosen constant (measure actual overflow depth on the 8 MB stack).

### (d) Size — MEDIUM (largest of the bundle by risk, not necessarily LOC)
Code: ~1 file (`src/adf.rs`) + error plumbing in the ~4 call sites if errors propagate (create.rs, workflow.rs, worklog.rs, jsm/requests.rs — these currently call the infallible `markdown_to_adf`; making it fallible changes the signature → ripples to all call sites). Plus tests (~100-200 LOC) + a BC + a spec doc. Estimate: 5-7 files, ~ +150 / -20 LOC, dominated by call-site fallibility plumbing and tests.

**Signature-fallibility caveat:** `markdown_to_adf(&str) -> Value` is currently infallible. If we choose "error on exceed," it becomes `-> Result<Value, _>`, touching every call site. If we choose "clamp/truncate," it stays infallible (smaller blast radius). This is a real factor in the error-vs-clamp decision.

### (e) Blockers / OPEN DESIGN QUESTIONS — must be resolved before implementation
1. **What is the limit?** Needs empirical measurement of overflow depth on the 8 MB stack (Unix + the Windows 8 MB PE stack per WIN-STACK). Pick a constant with comfortable margin (e.g. 100-ish), not the overflow depth.
2. **Behavior on exceed — error vs clamp/truncate?**
   - Error (exit 64, `JrError::UserError`) is honest and keeps output valid, but makes `markdown_to_adf` fallible → ripples to all call sites and needs a `--output json` error path.
   - Clamp/truncate keeps the fn infallible (smaller change) but silently alters user content — a surprising lossy behavior that itself needs documenting.
3. **Forward only, or also guard the reverse `adf_to_text` path?** (Hostile/compromised real Jira instance could return deep ADF to `issue view`.) Likely both.
4. **pulldown-cmark own depth behavior** — validate (Perplexity/docs) whether the parser caps nesting or passes unlimited depth, since our cap may be moot if pulldown overflows first during event generation.
5. Needs a BC + a `docs/specs/adf-recursion-depth.md` (follows the per-feature-spec convention, ADR-0004).

---

## Item 4 — SEC-JR-SERVICE-NAME-GATE: debug-gate `JR_SERVICE_NAME`

### (a) Real? — YES, confirmed ungated

`src/api/auth.rs:15-16`:
```rust
fn service_name() -> String {
    std::env::var("JR_SERVICE_NAME").unwrap_or_else(|_| DEFAULT_SERVICE_NAME.to_string())
}
```
**No `#[cfg(debug_assertions)]` gate.** Compare `JR_BASE_URL` (gated at both read sites, pinned by `tests/base_url_release_gate.rs`) and `JR_AUTH_HEADER` (SD-002, gated). `service_name()` is the single resolver; it is called from:
- `auth.rs:202` (`Entry::new(&service_name(), key)` — the keychain entry constructor)
- `auth.rs:327, 337` (other keychain ops)

So `JR_SERVICE_NAME` controls the **keyring service namespace** for ALL credential reads/writes, in release binaries today.

### (b) Security implication — assess
The threat is **NOT** a token-leak-to-attacker-endpoint like `JR_BASE_URL` (it doesn't redirect network requests). The exposure is:
- **Release binaries honor `JR_SERVICE_NAME`** → an attacker who can set the env var (compromised shell init, malicious wrapper, PaaS env override) can redirect keyring lookups to a *different service namespace*. Effect: `jr` reads/writes credentials under an attacker-chosen service name. This could (1) cause `jr` to read attacker-planted tokens (credential-confusion → send the user's requests with attacker's token, or trick the user into an attacker-controlled session), or (2) cause newly-minted tokens to be written under a namespace the attacker can enumerate. Lower severity than the `JR_BASE_URL` direct-redirect, but it is a credential-boundary env override that has no business being live in a release binary. It exists purely as a test-isolation seam (used by `with_test_keyring` and the oauth/cloudid integration tests with `JR_SERVICE_NAME=jr-s303-test`).

**Conclusion:** legitimate to gate behind `#[cfg(debug_assertions)]`. It is a pure test seam; no documented production use. Mechanical pattern, mirrors `JR_BASE_URL`/`JR_AUTH_HEADER`.

### (c) Behavior change / risk — LOW, but verify test isolation still works
Gating means release binaries always use `DEFAULT_SERVICE_NAME` and ignore `JR_SERVICE_NAME`. Risk: the keyring integration tests (`oauth_refresh_integration.rs`, `multi_cloudid_disambiguation.rs`, `src/api/auth.rs::with_test_keyring`) rely on `JR_SERVICE_NAME` for namespace isolation — those run as **debug** test binaries (`cfg!(debug_assertions)` is true under `cargo test`), so the gate keeps the seam active for them. CONFIRM the gate is `#[cfg(debug_assertions)]` (active in test builds) and not a `#[cfg(not(test))]` form (which would break tests). The `base_url_release_gate.rs` pattern (`test_335_debug_assertions_active_in_test_binary`) already proves debug_assertions is on in test binaries — reuse that reasoning.

### (d) Size — SMALL
Code: ~1 file (`src/api/auth.rs::service_name`) — wrap the env read in `#[cfg(debug_assertions)]` (one read site, simpler than `JR_BASE_URL`'s two sites). Plus a new release-gate test `tests/service_name_release_gate.rs` mirroring `base_url_release_gate.rs` (~80 LOC, source-grep + debug_assertions const-assert). Plus a CLAUDE.md line under the `JR_*` test-seam section (the doc convention explicitly requires adding a parallel line in the same commit). Estimate: 3 files, ~ +95 / -2 LOC.

### (e) Blockers / open questions
- Confirm the exact gate form (`#[cfg(debug_assertions)]`, NOT `#[cfg(not(test))]`) so the keyring integration tests retain isolation.
- The release-gate test must locate the gated read via source-grep — write it to tolerate the single-site form (the `base_url` test searches for `JR_BASE_URL && std::env::var` within 5 lines of `#[cfg(debug_assertions)]`; mirror exactly).
- CLAUDE.md fallout: add `JR_SERVICE_NAME` to the `JR_*` env-var list (codified doc-fallout pattern from #335/#357). The CLAUDE.md citation guard (`tests/claude_md_citations.rs`) will check any file path cited — keep the citation to `tests/service_name_release_gate.rs` accurate.
- No blockers. Lowest-risk security item.

---

## Item 5 — #532 / S-MAINT-532: profile-fallback coverage gap

### (a) Real? — YES, confirmed test gap (no code defect)

The global `--profile` flag is composed into a subcommand-level "effective profile" in `src/main.rs`:
```rust
let effective_profile = profile.or_else(|| cli.profile.clone());
```
at four auth-subcommand dispatch sites:
- line 145 — **Login** (`handle_login`)
- line 161 — **Status** (`status`)
- line 172 — **Refresh** (`refresh_credentials`)
- line 192 — **Logout** (`handle_logout`)

**Status** has an ungated coverage test: `tests/auth_profiles.rs::test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64` (line 281) — runs `jr --profile ghost auth status`, asserts exit 64, no keyring needed. This is the explicit "ungated substitute" pattern (the keyring-gated `global_profile_flag_targets_auth_status` at line 209 is the keyring version).

**Login, Refresh, Logout** have NO equivalent ungated test for the global-`--profile`→subcommand fallback composition. If someone deleted `.or_else(|| cli.profile.clone())` from the Login/Refresh/Logout arms, only keyring-gated tests (which CI skips) would catch it — so the regression would pass CI. That's the gap #532 names.

Note: the *pure resolvers* ARE unit-tested (`resolve_logout_target_defaults_to_active` at `src/cli/auth/tests/mod.rs:377`; `prepare_login_target` tests at lines 518+; `chosen_flow_for_profile_inspects_passed_profile_not_active` at line 57). The gap is specifically the **main.rs dispatch-level composition** (the `.or_else` fallback), not the resolvers.

### (b) Minimal fix
Add 3 ungated CLI tests in `tests/auth_profiles.rs` mirroring `test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64`:
- `jr --profile ghost auth logout` → exit 64 (unknown profile) — proves global `--profile` reaches `handle_logout`.
- `jr --profile ghost auth refresh` → exit 64 — proves it reaches `refresh_credentials`. (Refresh on an unknown profile: `Config::load_with(Some("ghost"))` errors on the strict load → non-zero; confirm exact exit code via a dry run when implementing.)
- `jr --profile ghost auth login --no-input` (no `--url`) → non-zero — proves it reaches `handle_login`/`prepare_login_target`. (Login on an unknown profile under `--no-input` with no `--url` → the "--url required" error path. Confirm exit code.)

All three use the `ghost`/unknown-profile trick so they need no keyring and no network — same mechanism as the existing Status test. Place them next to the Status test (line ~281) in `tests/auth_profiles.rs`.

### (c) Behavior change / risk — NONE
Test-only addition. No `src/` change. Pure coverage. Risk: must verify the exact exit code each path produces on an unknown profile (Login/Refresh have URL-required and load-error branches that may differ from Status's clean exit 64) — assert the real behavior, don't assume 64 uniformly.

### (d) Size — SMALL
1 file (`tests/auth_profiles.rs`), ~3 tests, ~ +75 LOC, 0 deletions.

### (e) Blockers / open questions
- Confirm exact exit codes for `auth login`/`auth refresh` against an unknown profile under `--no-input` (run them once during implementation; the strict `Config::load_with` may surface a different `JrError` variant than Status). No design decision — just assert observed behavior.
- No blockers. Lowest-effort item in the bundle.

---

## Per-Item Summary Table

| Item | Real? | Size (files / LOC) | Behavior-change? | Risk | BC/spec touch |
|------|-------|--------------------|------------------|------|---------------|
| 1 CR-008 helper dedup | YES (3 defs, 20 calls) | ~5 files / ~ -70/+50 | NO | very low (test-only) | none |
| 2 CR-009 keyring idiom | YES (4 loose sites) | ~5 files / ~ +60/-8 | NO (CI never runs these) | very low | optional CLAUDE.md note |
| 3 SEC-001 ADF recursion | YES (6 recursive fns, no guard) | 5-7 files / ~ +150/-20 | **YES** + security | **HIGH** | **BC + spec required** |
| 4 JR_SERVICE_NAME gate | YES (ungated, single site) | 3 files / ~ +95/-2 | minor (release ignores env) | LOW (mechanical) | CLAUDE.md line required |
| 5 #532 profile fallback | YES (test gap only) | 1 file / ~ +75 | NO | very low (test-only) | none |

---

## RECOMMENDED PR PLAN

Your hypothesis was: SEC-001 alone; group mechanical test/refactor (CR-008 + #532, maybe CR-009); JR_SERVICE_NAME alone or with SEC-001. **I largely agree, with one revision: split the security items rather than merging JR_SERVICE_NAME into SEC-001, and keep CR-009 with the mechanical group (it's test-internal, not a behavior change).**

Rationale for revision:
- SEC-001 is behavior-changing, needs a BC + spec + open design decisions + possibly a fallible-signature ripple. It will iterate (review, depth-constant tuning, error-vs-clamp). Bundling the trivially-mechanical JR_SERVICE_NAME gate into it would hold a 1-day change hostage to a multi-day design discussion. Keep them separate.
- JR_SERVICE_NAME is a mechanical mirror of an existing, well-understood pattern (`base_url_release_gate`). It's "security-relevant" but not "behavior-design-open" — it belongs with mechanical work, but as its own focused security PR so the security framing/review is clean and not diluted by test-refactor noise.
- CR-009 is genuinely test-only (CI never runs keyring tests). It carries no runtime risk and pairs naturally with CR-008 (both are test-helper hygiene; CR-009 may even add a `tests/common/` helper alongside CR-008's).

### PR 1 — "test hygiene: helper dedup + keyring-gate idiom + profile-fallback coverage" (MECHANICAL, test-only)
- **Items:** CR-008 (1) + CR-009 (2) + #532 (5)
- **Files:** `tests/common/mod.rs`, new `tests/common/yaml.rs`, `tests/ci_yml_windows_matrix.rs`, `tests/ci_gate_completeness.rs`, `tests/backfill_matrix_parity.rs`, `tests/auth_profiles.rs`, `src/api/auth.rs` (1 predicate in inline test mod), `tests/multi_cloudid_disambiguation.rs` / `tests/oauth_refresh_integration.rs` (no change — already canonical), optional new keyring-idiom meta-test, optional `tests/common/` keyring helper.
- **Risk:** very low. No `src/` runtime change (the one `src/api/auth.rs` edit is inside `#[cfg(test)]`/test-helper code). No public API.
- **BC/spec:** none. Optional one-line CLAUDE.md note on the canonical keyring idiom.
- Note: `src/api/auth.rs` edit is test-only; if your VSDD process wants `src/` and `tests/` PRs separated, CR-009's auth.rs predicate could move to PR 3, but it's cleaner kept with its 3 sibling `tests/` sites.

### PR 2 — "sec: cap ADF recursion depth (CWE-674)" (BEHAVIOR-CHANGING, security)
- **Items:** SEC-001 (3) — its own PR.
- **Files:** `src/adf.rs`, the ~4 `markdown_to_adf`/`text_to_adf` call sites if the fn becomes fallible (`src/cli/issue/create.rs`, `src/cli/issue/workflow.rs`, `src/cli/worklog.rs`, `src/api/jsm/requests.rs`), new tests in `src/adf.rs` test mod, new `docs/specs/adf-recursion-depth.md`, a new BC in `.factory/specs/prd/`.
- **Risk:** HIGH (only item that changes runtime behavior + introduces a new failure mode).
- **BC/spec:** REQUIRED. Resolve the 5 open design questions (limit value, error-vs-clamp, forward+reverse, pulldown-cmark behavior, BC text) BEFORE coding — this should go through the full VSDD Feature-Mode pipeline (design spec first), not a quick patch.
- **Blocking pre-work:** validate pulldown-cmark's own nesting behavior; measure empirical overflow depth.

### PR 3 — "sec: debug-gate JR_SERVICE_NAME (mirror JR_BASE_URL)" (MECHANICAL, security)
- **Items:** JR_SERVICE_NAME (4) — its own focused security PR.
- **Files:** `src/api/auth.rs` (gate the `service_name()` env read), new `tests/service_name_release_gate.rs`, `CLAUDE.md` (add `JR_SERVICE_NAME` to the `JR_*` seam list — same-commit doc-fallout rule).
- **Risk:** LOW. Mechanical mirror of an audited pattern; verify keyring integration tests still isolate (gate must be `#[cfg(debug_assertions)]`, active in test builds).
- **BC/spec:** no spec; CLAUDE.md line required.

### Suggested order
1. **PR 3** first (JR_SERVICE_NAME) — smallest, lowest-risk, closes a real (if low-severity) release-binary credential-boundary seam; fully independent.
2. **PR 1** next (test hygiene) — independent, unblocks nothing but cleans the tree and adds the #532 coverage guard before any future auth refactor.
3. **PR 2** last (SEC-001) — needs design work + BC + spec; don't rush it. Run it through full VSDD Feature Mode. It's independent of 1 and 3, so ordering is by readiness, not dependency.

No inter-PR dependencies — all three can proceed in parallel if reviewer bandwidth allows; the order above is by risk/readiness (ship the cheap certain wins first, let the design-heavy security change take its time).

### Deviation from your hypothesis
- You floated "JR_SERVICE_NAME with SEC-001." I recommend AGAINST — keep them separate so the open-design security PR doesn't gate the mechanical one. Otherwise your instinct (SEC-001 solo; mechanical group; JR_SERVICE_NAME standalone-security) is sound. I also explicitly placed CR-009 in the mechanical group (it's test-only, no runtime change) rather than leaving it ambiguous.
