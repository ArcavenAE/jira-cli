# PR Review — #806 `feat/cycle7-auth-state-derivation`

**Verdict: REQUEST CHANGES**

Reviewed every changed file in the diff (8 files, +1182/-32) against the 8-item checklist.
The implementation itself is correct and the design (probe-then-format split) is the right
call — my findings are two in-tree documentation obligations that this PR leaves violated,
and one test gap I confirmed empirically by mutating the source and watching all 103 tests
stay green.

| # | Severity | Category | Finding |
|---|----------|----------|---------|
| B-1 | **BLOCKING** | missing | `docs/specs/multi-profile-auth.md` still says `STATUS ∈ {configured, unset}` — now false |
| B-2 | **BLOCKING** | missing | Two new `exclude_re` entries not recorded in `docs/specs/cargo-mutants-policy.md`; §Scope has no `src/cli/auth/list.rs` bullet |
| NB-1 | NON-BLOCKING | coverage | `collect_probe_results`' probe→map value mapping is unasserted — #788 reintroducible with all tests green (verified) |
| NB-2 | NON-BLOCKING | coverage | No guard that `handle_list` wires the *real* probe into `collect_probe_results` |
| NB-3 | NON-BLOCKING | description | CHANGELOG entry omits the `Breaking:` marker the PR body declares |
| NB-4 | NON-BLOCKING | description | Probe ignores env-var credentials and adds N keychain reads — worth a documented sentence |
| N-1 | NIT | coherence | `unwrap_or("")` vs production's `unwrap_or("api_token")` |
| N-2 | NIT | coverage | `extract_fn_body` brace counting is literal/comment-blind; guards fail *open* |
| N-3 | NIT | coverage | AC-005 table arm is whole-table `contains`, unlike its row-scoped sibling |
| N-4 | NIT | coverage | AC-004 Guard 3 doc comment overstates what the assertion checks |

---

## BLOCKING

### B-1 — `docs/specs/multi-profile-auth.md` now documents a false contract

**File:** `docs/specs/multi-profile-auth.md` (§ `jr auth list`)

That spec still reads:

```
jr auth list
    ...
    STATUS ∈ {configured, unset}
    JSON: [{"name", "url", "env", "auth_method", "status", "active"}]
```

After this PR the STATUS domain is a three-value set. `docs/specs/` is the directory
CLAUDE.md designates as "one spec per feature, read before implementing", and this
particular file is the canonical `jr auth` surface spec — it was updated by the
*immediately preceding* story in this same cycle (`08021685`, S-cycle7-credential-absence-fix,
PR #803). Leaving it stale means the next person to touch `auth list` reads a two-value
contract for a three-value surface.

**Suggestion:** in the same commit, change that line to the new domain and say what drives
it, e.g.

```
    STATUS ∈ {configured, no-credentials, unset}   (BC-1.6.048/049, #788 —
        derived from a real per-profile keychain probe selected by
        auth_method, NOT from URL presence)
```

No other line in that section needs to change — the JSON key list is still accurate.

### B-2 — new `exclude_re` entries are not recorded in the mutants policy doc

**Files:** `.cargo/mutants.toml` (added), `docs/specs/cargo-mutants-policy.md` (not touched)

The policy doc's **Exclusions** section carries an explicit, mandatory rule:

> - Record the exclusion here with the same justification, kept in sync with the config
>   comment.

This PR adds two `exclude_re` entries for `probe_matching_kind_credential` and records
neither. The doc's "**Current exclusions:**" list still shows only the S-575-1
`issues.rs:374` entry. Separately, `.cargo/mutants.toml`'s own header declares
"Canonical scope definition: `docs/specs/cargo-mutants-policy.md` §Scope", and §Scope has
no bullet for the newly-added `src/cli/auth/list.rs` glob.

Two reasons this is blocking rather than a nit:

1. **Direct precedent on this exact file.** The `src/output.rs` bullet in that same §Scope
   list is annotated "(added S-cycle3-env-tag, per pr-reviewer BLOCKING-1 on PR #752)" —
   the identical omission was raised as BLOCKING on a prior PR and fixed.
2. **CI cannot catch it.** `scripts/check-cargo-mutants-policy-citations.sh` validates
   doc→src (dead citations) and enforces a floor of 11 bullets; it does not validate
   toml→doc. "Spec Guards" is green on this PR *because* the guard is one-directional.
   That makes it a code-review responsibility by construction.

One nuance worth handling deliberately rather than boilerplating: the Exclusions section as
written scopes itself to a *specific* class — "unkillable only in the test-harness execution
model … the mutated code would run forever". These two new exclusions are a **different**
class: keychain-gated, no injection seam. The doc does contemplate that class elsewhere (the
FIX-F6-1 deferral note: "Closing this gap needs either an in-CI keychain-injection seam or a
broad, carefully-scoped `exclude_re` allowlist for the keyring-gated functions"), so the
mechanism choice here is consistent with the documented path forward — but the Exclusions
section needs a short second-class paragraph, not just a new list row.

**Suggestion:**

1. Add a §Scope bullet: `` - `src/cli/auth/list.rs` — `derive_auth_state` wiring,
   `collect_probe_results` (injectable probe loop), `render_list_table`/`render_list_json`
   (pure renderers); `probe_matching_kind_credential` excluded via `exclude_re`
   (keychain-gated, no injection seam) (added S-cycle7-auth-state-derivation) ``
2. Extend the Exclusions preamble with the keychain-gated/no-seam class (one short
   paragraph), then add the two entries to "**Current exclusions:**" with the same
   justification as the toml comment — including *where correctness is positively verified
   by other means*, which per the doc's rule (b) is mandatory. For these two that answer is
   the `auth status` parity: `probe_matching_kind_credential`'s `"oauth"`/`_` dispatch is
   byte-equivalent to `client.rs::load_auth_from_keychain` and `status.rs`' existing probe,
   and *those* are exercised by the `JR_RUN_KEYRING_TESTS` suite.
3. While in the file, the "Current `examine_globs` count: 22 entries" line is now 27. It was
   already stale before this PR and the line self-disclaims ("verify … it has drifted before
   and will drift again"), so this is opportunistic, not a requirement of this PR.

---

## NON-BLOCKING

### NB-1 — `collect_probe_results` never has its *return value* asserted; #788 is reintroducible with a green suite

**File:** `src/cli/auth/list.rs` (`collect_probe_results`), `src/cli/auth/tests/mod.rs`
(`test_bc_1_6_049_list_probes_at_most_once_per_url_profile`)

AC-009 is the only test that touches `collect_probe_results`, and it discards the result:

```rust
let _results = collect_probe_results(&global, |_profile, _auth_method| {
    call_count_clone.fetch_add(1, Ordering::SeqCst);
    true
});
```

It asserts the call *count* (2 of 3 profiles) and nothing about the map. So the line that
carries the probe's answer into the map is unverified. I confirmed this empirically — I
replaced

```rust
results.insert(name.clone(), present);
```

with `results.insert(name.clone(), true);` and re-ran both suites:

```
cargo test --lib cli::auth      → ok. 102 passed; 0 failed
cargo test --test auth_list_status → ok. 1 passed; 0 failed
```

103/103 green under a mutant that restores **exactly the #788 defect** — every URL-having
profile reports `configured` regardless of keychain state. (Source reverted; worktree clean.)

Two consequences. First, the headline defect this story closes has no default-CI regression
barrier at the one place the real probe result is handled. Second, `collect_probe_results` is
inside the `examine_globs` glob this PR adds and is *not* `exclude_re`'d, so this is a live
MISSED mutant against the 90%-on-diff kill-rate gate, which weakens the PR's own claim that
the new glob "now represents a TRUE coverage signal."

**Suggestion:** make the AC-009 closure discriminate and assert the map — ~4 lines, no new
fixture:

```rust
let results = collect_probe_results(&global, |profile, _auth_method| {
    call_count_clone.fetch_add(1, Ordering::SeqCst);
    profile == "with-url-1"          // distinguish true from false
});
// ... existing call-count assertion ...
assert_eq!(results.get("with-url-1"), Some(&true),  "probe=true must be recorded verbatim");
assert_eq!(results.get("with-url-2"), Some(&false), "probe=false must be recorded verbatim");
assert!(!results.contains_key("no-url"), "url=None profile must be absent from the map");
```

That kills the `insert(.., true)` / `insert(.., false)` mutant class and also pins the
"absent means never probed" property the renderer doc comments rely on.

### NB-2 — nothing asserts `handle_list` wires the real probe

No test or guard references the pairing of `handle_list` → `collect_probe_results` →
`probe_matching_kind_credential`; I grepped `src/` and `tests/` and every hit outside
`list.rs` itself is a denylist string or a comment. A refactor that changed

```rust
let probe_results = collect_probe_results(&config.global, probe_matching_kind_credential);
```

to a constant closure would be invisible to CI.

The PR body discloses `handle_list` mutants as accepted survivors with the `main.rs` /
`queue.rs` precedent, and that's a fair posture *for mutation reporting*. But combined with
NB-1 it means the production chain from real keychain result to rendered STATUS has zero
default-CI coverage at both of its remaining links. Given this PR already uses source-scan
guards in three places, a fourth one-liner closes the last one for free:

```rust
let handle_body = extract_fn_body(list_src, "async fn handle_list").expect("handle_list found");
assert!(
    handle_body.contains("collect_probe_results(&config.global, probe_matching_kind_credential)"),
    "handle_list must wire the REAL keychain probe into collect_probe_results — a constant \
     or stub closure here silently reintroduces #788"
);
```

### NB-3 — CHANGELOG entry omits the `Breaking:` marker the PR body declares

The PR body's Risk Assessment says "**Breaking change:** Yes" and calls out table-output
consumers at MEDIUM risk. The CHANGELOG bullet is not marked as breaking, while the sibling
entry immediately below it is (`**Breaking: load_api_token credential-absence branches now
exit 2 (not 64) …**`). The JSON `"status"` field gaining a third value is a
machine-consumer-visible contract change, so the two channels should agree.

Everything else I checked in the entry is accurate: the three values and their meanings, the
kebab-case serialization, the renderer-purity claim, and "selected by the profile's
`auth_method`" all match the code.

**Suggestion:** prefix the entry title with `**Breaking: …**` and add one line for script
authors, e.g. "Scripts matching `status == "configured"` to mean 'has a URL' must now also
handle `no-credentials`."

### NB-4 — probe ignores env-var credentials, and `auth list` now does N keychain reads

`probe_matching_kind_credential` consults only the keychain. A profile that authenticates via
`JR_EMAIL` / `JR_API_TOKEN` (or, in debug builds, `JR_AUTH_HEADER`) will now be reported
`no-credentials` even though every command against it succeeds.

To be clear, this is **not a regression and not a divergence** — `auth status` already has
exactly this posture via the same `match method { "oauth" => …, _ => … }` probe in
`status.rs`, and I verified the new function's dispatch is semantically identical to
`client.rs::load_auth_from_keychain`. But `auth list` is the multi-profile overview users are
most likely to treat as authoritative, and the CHANGELOG frames the new values as ground
truth ("reflects actual credential state").

Related, same low severity: `auth list` goes from zero keychain reads to one per URL-having
profile. On macOS that is N Keychain accesses per invocation. The PR's perf table notes this
and judges it "same order as existing `auth status`", which I agree with for a single
profile — it's N× that for N profiles.

**Suggestion:** one sentence in the CHANGELOG (and/or the `multi-profile-auth.md` edit from
B-1) noting that STATUS reflects *stored* credentials only, and that env-var-supplied
credentials are not probed. No code change warranted.

---

## NITS

- **N-1** `collect_probe_results` passes `p.auth_method.as_deref().unwrap_or("")`, while
  `client.rs::from_config` uses `unwrap_or("api_token")`. Behaviorally identical (both land
  in the `_`/else arm), but `""` is a third spelling of the same default; `"api_token"` would
  make the parity with `load_auth_from_keychain` self-evident to a reader checking that the
  probe matches real credential resolution.
- **N-2** `extract_fn_body`'s brace counting is blind to string literals and comments. It
  works today only because `render_list_table`'s `format!("{marker} {name}")` braces happen
  to balance. A future `format!("{{")`, or a stray `}` in a body comment, would truncate the
  extracted body early — and because the guards are written `if let Some(body) = … { assert!(…) }`,
  a bad extraction makes them **vacuous** rather than failing. Consider
  `.expect("render_list_table body extracted")` instead of `if let`, so the guards fail
  closed.
- **N-3** AC-005's table arm asserts `table.contains("no-credentials")` across the whole
  table, while its AC-006 sibling and both JSON arms are row-scoped. Scope it to the
  `oauth-no-creds` row for symmetry — `find_row` already exists two tests down.
- **N-4** `test_bc_1_6_048_derive_auth_state_is_pure_no_io`'s Guard 3 asserts
  `list_src.contains("derive_auth_state(")` file-wide, but its doc comment says "both
  renderers DO call `derive_auth_state`". AC-010 and AC-014 do the per-renderer version
  correctly; trim the claim here to match the assertion so the name/docstring doesn't assert
  a guarantee the body doesn't check.

---

## What I verified (so this isn't a rubber stamp)

**Review focus 1 — `derive_auth_state` 3-state logic: CORRECT.** `None → Unset` dominates
regardless of `matching_kind_present`; `Some + true → Configured`; `Some + false →
NoCredentials`. Total, deterministic, no IO. Matches the documented truth table exactly, and
the URL string is never parsed (the proptest arm over arbitrary `[a-z]{1,20}` confirms only
`.is_none()` is load-bearing).

**Review focus 2 — renderer purity: CONFIRMED by reading both bodies.** Neither
`render_list_table` nor `render_list_json` references `load_oauth_tokens`, `load_api_token`,
`probe_matching_kind_credential`, or `collect_probe_results`; both derive status solely from
`derive_auth_state(p.url.as_deref(), probe_results.get(name).copied().unwrap_or(false))`. The
`unwrap_or(false)` fallback is safe precisely because the only absent keys are URL-less
profiles, which are `Unset` under either boolean. The F-1 design decision (probe in
`handle_list`, format in the renderers) is the right one and it genuinely bought
default-CI-runnable differential tests — no `#[ignore]`, no `JR_RUN_KEYRING_TESTS` anywhere
in the new tests, as claimed.

**Review focus 3 — test meaningfulness: mostly yes, one confirmed hole (NB-1).** The
`AuthState::as_str()` ↔ serde kebab-case agreement test iterating all three variants is a
genuinely good root-cause fix — it makes table/JSON drift impossible rather than merely
tested. AC-008's bidirectional key-set equality (every expected key present AND no
unexpected key) is the correct shape, not a one-sided `contains`. AC-013's column-targeted
`unset` extraction via the comfy-table separator split is a real improvement over a
whole-table `contains`, which would have passed against the URL column's `(unset)`
placeholder. The snapshot regeneration is honest: adding a `url: None` fixture makes the
previously-unreachable `Unset` arm snapshot-pinned, and the three `no-credentials` rows are
the truthful result of an empty probe map. The gap is NB-1.

**Review focus 4 — `exclude_re` scoping: CORRECTLY SCOPED to
`probe_matching_kind_credential` only.** Regex A
(`^src/cli/auth/list\.rs:\d+:\d+: .+ in probe_matching_kind_credential$`) is `$`-anchored on
the function name; Regex B
(`^src/cli/auth/list\.rs:\d+:\d+: replace probe_matching_kind_credential .*$`) requires a
following space. Neither can match `derive_auth_state`, `collect_probe_results`,
`render_list_table`, `render_list_json`, or `handle_list`, and neither would match a
hypothetical `probe_matching_kind_credential_v2` (Regex A's `$` anchor and Regex B's required
space both block the suffix). The two-regex split is genuinely necessary, not belt-and-braces:
operator mutants are named "… in `<fn>`" while whole-body-replacement mutants are named
"replace `<fn>` -> T with …" and end with the replacement value, so one regex cannot cover
both.

**Review focus 5 — CHANGELOG accuracy: accurate on every technical claim, missing the
`Breaking:` marker (NB-3).**

**Also checked:**
- `probe_matching_kind_credential`'s `"oauth"` vs `_` dispatch is byte-equivalent to
  `client.rs::load_auth_from_keychain` and `status.rs`' probe — a legacy profile with
  `auth_method: None` routes to the api-token probe in all three places. No semantic
  divergence between what `auth list` reports and what the client will actually attempt.
- JSON render invariant (#526) preserved — `render_list_json` still terminates in
  `output::render_json(&arr)`; no `to_string_pretty`, no compact `json!` Display.
- Diff coherence: all 8 files are in scope for BC-1.6.048/049; no drive-by changes. The three
  pre-existing test signature updates (`list_json_shape` count 3→4,
  `test_render_list_table_headers_…`, `test_render_list_json_env_key_…`) are minimal
  parameter fallout, and each carries a comment stating it asserts nothing about STATUS —
  which I verified.
- Commit quality: 9 commits, all Conventional Commits, story-ID scoped, messages describe the
  actual change.
- Locally on the PR head: `cargo clippy --all-targets -- -D warnings` clean,
  `cargo fmt --all -- --check` clean, 102 `cli::auth` unit tests + 1 `auth_list_status`
  integration test pass.
- Diff size is 1182 insertions, over the 500-line review flag — but ~85% is tests and doc
  comments; the production delta is roughly 90 lines. Not a finding, just noting the flag was
  considered and dismissed.
- Dependency status: the PR's stated upstream (#803, S-cycle7-credential-absence-fix) is
  merged on `develop`; no unmerged dependency.
- Demo evidence: recorded as skipped by explicit human decision with a Skip Log, rationale
  being that demonstrating `no-credentials` vs `configured` divergence needs multiple real
  Jira instances with controlled keychain states. Given a human decision is on record and all
  three `AuthState` values are snapshot- and unit-pinned with injected probe results, I'm
  treating this as satisfied rather than blocking.

---

## To clear this review

B-1 and B-2 are documentation-only and mechanical. NB-1 is ~4 lines in an existing test and I
would strongly encourage taking it in the same push, since it is the difference between the
new `examine_globs` entry being a real coverage signal and a nominal one. NB-2 through N-4 are
yours to take or decline.
