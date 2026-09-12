# PR Review — #805 `fix(docs): correct --oauth help text overclaims (issue #790)`

**Verdict: APPROVE** (contingent on `ci-gate` going green — see INFO-1)
**covered_sha:** `5b411e93a5c84ae09d804d5e8067a4a2ee546f9b`
**Reviewed:** all 3 changed files (`src/cli/mod.rs`, `tests/oauth_help_text.rs`, `CHANGELOG.md`), +341/-9

---

## What I verified (not a rubber stamp)

The core defect is real and the fix is correct. I independently confirmed the runtime
behavior the new doc comments describe, rather than trusting the PR description:

1. **The primary claim being removed was genuinely false.** `jr` ships an embedded OAuth
   app (ADR-0006); `--client-id`/`--client-secret` are an optional BYO override. The new
   first paragraph's env-var claim is also accurate — `jr auth login --help` independently
   documents `Prefer $JR_OAUTH_CLIENT_ID over this flag` on `--client-id`. Correct fix.

2. **The guard-precedes-notice ordering (AC-003) is real.** `src/cli/auth/login.rs:473`
   calls `check_noninteractive_oauth_guard(args.no_input, args.oauth)?` and only reaches
   `emit_oauth_deprecation_notice` at `:481`. `src/cli/auth/refresh.rs:124` → `:131` has the
   same ordering. The `?` propagates before the notice. AC-003 is a legitimate regression pin.

3. **The Red Gate was real, not theatre.** I rendered `jr auth login --help` from the
   pre-fix tree and confirmed the literal string `printed to stderr in human-output mode`
   appears verbatim and unwrapped in the `--oauth` block — so AC-002 genuinely failed before
   the fix. Same for `requires your own OAuth app` (AC-001). Not a vacuous assertion.

4. **The block extractor does not panic and does not false-green.** Both `      --oauth`
   and `      --api-token` headers exist at 6-space indent in both `auth login --help` and
   `auth refresh --help`. Clap's 6-space pad is guaranteed by `-h, --help` always carrying a
   short flag, so the needle is stable. The prose mention of `` `--api-token` `` inside the
   `--oauth` block does not premature-match (it is not 6-space-prefixed).

5. **Refresh's asymmetry claim (pass-2 F1) is correct.** `refresh.rs` resolves the flow from
   the profile's stored `auth_method` via `chosen_flow_for_profile` — `--oauth` never reaches
   it — so a non-interactive `jr auth refresh --oauth` on an api-token profile really does
   skip the guard and really does emit the notice. The final Refresh wording is accurate.

6. **No security surface, no dependency change.** `assert_cmd`/`tempfile` were already in
   `[dev-dependencies]`. `JR_CONFIG_DIR` is a `#[cfg(debug_assertions)]` seam, valid in tests.
   AC-003 makes no network/keychain call because the guard short-circuits first. Confirmed.

No blocking findings. Findings below are all non-blocking.

---

## SUGGESTION-1 — Login's replacement wording drops the gate that actually governs the notice (the same error pass-2 F1 fixed for Refresh)

**Severity:** suggestion · **Category:** doc-accuracy / coherence
**File:** `src/cli/mod.rs`, `AuthCommand::Login::oauth` doc comment

This PR lands two different framings for the same behavior, and Login got the weaker one.

The notice is gated on **output format only**:

```rust
// src/cli/auth/mod.rs
/// BC-1.2.049 Postcondition 2: ... stderr-only, human-output-mode-only. Gated on
/// OUTPUT FORMAT, not TTY-ness (EC-1.2.049-1: never emitted under `--output json`,
/// regardless of interactivity).
pub fn emit_oauth_deprecation_notice(output: crate::cli::OutputFormat) {
    if matches!(output, crate::cli::OutputFormat::Table) { ... }
}
```

Refresh's final wording captures that correctly:
> "A deprecation notice is printed in human-output (Table) mode unless the non-interactive
> OAuth guard rejects the refresh first."

Login's does not:
> "when the non-interactive guard does not reject first, a deprecation notice **may be
> emitted on interactive runs**."

Two problems:

- **It deletes the one accurate clause the original had.** The pre-fix text said "in
  human-output mode" — the actual gate. The replacement drops it and substitutes
  interactivity, which is *not* the gate. A user reading this expects a notice from an
  interactive `jr auth login --oauth --output json`; they will not get one (EC-1.2.049-1).
  Net effect: on this specific point the Login help is now *less* accurate than before, in a
  PR whose entire thesis is doc accuracy.
- **It's the exact framing pass-2 F1 rejected.** The CHANGELOG in this very diff explains at
  length why interactivity-gated phrasing is wrong and output-format-gated phrasing is right
  — then leaves Login interactivity-gated. The two siblings now disagree.

Minor secondary nit in the same sentence: for Login the guard *always* fires when
non-interactive + `--oauth`, so "when the guard does not reject first" and "on interactive
runs" are the same condition stated twice.

Suggested reword, mirroring the Refresh wording exactly:

```rust
/// DEPRECATED (BC-1.2.049): retained as an accepted alias — a deprecation
/// notice is printed in human-output (Table) mode unless the
/// non-interactive OAuth guard rejects the login first. Prefer letting the
/// interactive picker default to OAuth, or pass `--api-token` explicitly
/// for the other mechanism.
```

I'm not blocking because "may be emitted" is hedged rather than affirmatively false, the
primary defect (`requires your own OAuth app`) is correctly fixed, and there is zero runtime
impact. A reviewer who reads the PR's own stated AC-002 ("wording must be consistent with
the confirmed-correct runtime behavior") strictly could reasonably call this blocking — the
call is the maintainer's.

---

## SUGGESTION-2 — AC-002's login test has no positive pin, so SUGGESTION-1 slipped through

**Severity:** suggestion · **Category:** coverage
**File:** `tests/oauth_help_text.rs::test_help_text_oauth_flag_does_not_overclaim_unconditional_notice`

Adversary pass-2 OBS-A added a positive assertion to the *refresh* test precisely so "a
future reword that simply removes both claims cannot silently pass":

```rust
assert!(block.contains("human-output"), ...);  // refresh test
```

The login test never got the same treatment — it is negative-only. That gap is not
hypothetical: it is exactly why the login wording could lose "human-output" in this PR
without any test objecting. Adding the symmetric pin would close SUGGESTION-1 and keep it
closed:

```rust
assert!(
    block.contains("human-output"),
    "--oauth help block must pin the output-format-gated framing (EC-1.2.049-1) — \
     the notice is suppressed under --output json regardless of interactivity.\n\
     Current --oauth block:\n{block}"
);
```

---

## SUGGESTION-3 — AC-004 cannot detect the drift its name and docstring promise

**Severity:** suggestion · **Category:** coverage
**File:** `tests/oauth_help_text.rs::test_clap_conflicts_with_usage_rendering_unaffected_by_doc_change`

The docstring promises the `conflicts_with`-driven rendering is pinned "byte-for-byte
identical before AND after" so "an accidental attribute change would be caught immediately."
The body asserts only that `      --oauth` is present, `      --api-token` is present, and
the usage line lacks `<--oauth|--api-token>`.

**Deleting `conflicts_with = "api_token"` outright would pass all three assertions.** Clap
renders two independent optional flags as `[--oauth] [--api-token]` whether or not they
conflict — so the negative assertion on the usage line is true in both the conflicting and
non-conflicting worlds. The test therefore cannot catch removal of the mutual exclusion,
which is the one attribute it names.

Per `CLAUDE.md`'s test-naming convention, "a name asserting a guarantee its body doesn't
check is a defect, not a style deviation" — so this is worth fixing rather than renaming.
A genuine pin costs one subprocess and actually observes the attribute:

```rust
// conflicts_with is enforced at parse time -> clap exit 2.
let conflict = Command::cargo_bin("jr").unwrap()
    .args(["auth", "login", "--oauth", "--api-token"])
    .output().expect("failed to run conflicting flags");
assert_eq!(
    conflict.status.code(), Some(2),
    "--oauth and --api-token must remain mutually exclusive (clap exit 2); \
     conflicts_with may have been dropped. stderr: {}",
    String::from_utf8_lossy(&conflict.stderr)
);
```

---

## NIT-1 — duplicated block extractor

`oauth_option_block` and `refresh_oauth_option_block` have byte-identical bodies, differing
only in panic text. One helper taking a `subcommand: &str` label (used in both the panic
message and to pick the stdout capture) removes ~20 duplicated lines.

## NIT-2 — extractor needle bakes in indentation and uses unanchored `find`

`"      --api-token"` is matched with `str::find`, not line-anchored. Because a clap help
*body* line is indented 10 spaces, a body line beginning with `--api-token` would contain
the 6-space needle as a substring and be mistaken for the next header. Not reachable today
(clap emits each paragraph unwrapped to a non-TTY, and no body paragraph starts with that
token), but it is latent. A line-anchored scan states the intent and removes the coupling:

```rust
let end = rest.lines().skip(1)
    .position(|l| l.starts_with("      --") && !l.starts_with("      --oauth"))
```

Related latent risk: all the multi-word substring assertions assume clap does not wrap. That
holds now (no wrapping to a non-TTY), but enabling clap's `wrap_help` feature would silently
make the negative assertions vacuous — always-true. Normalizing the block
(`block.split_whitespace().collect::<Vec<_>>().join(" ")`) before asserting would make them
wrap-independent.

## NIT-3 — PR description misstates the test count and the test mechanism

Not merged code, but it is the artifact a human reviewer reads, and on a PR about
overclaiming it is worth correcting:

- **Count.** Badge says `tests-4/4 new`, the table says "New tests | 4 added", and the
  Detailed Test Results table lists 4 rows. The file contains **5** `#[test]` functions —
  `test_help_text_refresh_oauth_flag_does_not_overclaim_unconditional_notice` is missing from
  every count and from the results table. Commit `9f5b50ad`'s own message says "All 5
  oauth_help_text tests pass," so the body simply wasn't resynced after the sibling fix.
- **Mechanism.** The body says the tests "lock the corrected wording via
  `Cli::command().render_help()` substrings" and that "**AC-004** calls `Cli::command()`
  directly and inspects `arg_by_id("oauth")` attributes." None of that is in the diff —
  `Cli::command()`, `render_help()`, and `arg_by_id` appear nowhere in
  `tests/oauth_help_text.rs`. Every test shells out via
  `assert_cmd::Command::cargo_bin("jr")` and substring-matches `--help` stdout. Calling these
  "clap-introspection tests" (5 occurrences) overstates it; they are subprocess help-text
  assertions. The distinction matters: the described `arg_by_id` approach *would* have caught
  SUGGESTION-3's `conflicts_with` drift, and the implemented approach does not.

## NIT-4 — CHANGELOG entry narrates the internal review process

The 21-line entry embeds pipeline vocabulary ("adversary pass-1 OBS-1, adversary pass-2 F1",
"the interim reword", "A subsequent adversary pass found…"). A reader of a released
CHANGELOG cares about the corrected behavior, not the order in which reviewers found it.
Consider collapsing to the outcome (both `--oauth` docs corrected; the false "requires your
own OAuth app" claim removed; notice gating stated accurately) and leaving the pass history
in the PR. Noting that the adjacent entry is comparably verbose, so this may be house style.

---

## Checklist

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all 3 files serve the one story; no unrelated edits |
| 2 | Description accuracy | NIT-3 — test count (4 vs 5) and test mechanism both misstated |
| 3 | Test coverage | PASS with SUGGESTION-2/-3 — changed lines are doc comments, pinned by string assertions; two pins weaker than advertised |
| 4 | Demo evidence | Absent; accepted — see INFO-2 |
| 5 | Commit quality | PASS — conventional format, story ID + AC refs in all 4 subjects, logically separated |
| 6 | Diff size | PASS — +341/-9, of which 307 is the new test file |
| 7 | Missing changes | PASS — both `Login` and `Refresh` corrected; CHANGELOG present (AC-005) |
| 8 | Dependency status | PASS — upstream story A merged; base `develop@08021685` is current |

## INFO-1 — `ci-gate` has not gone green yet; my approval is contingent on it

At review time: Clippy (ubuntu), Format, MSRV, Deny, Spec Guards, gitleaks and all 8 mutation
shards pass, but **`Test (ubuntu-latest)`, `Test (macos-latest)`, `Test (windows-latest)`,
`Clippy (windows-latest)` and `Coverage` are all still pending.** The three `Test` jobs are
the only ones that execute `tests/oauth_help_text.rs`, so the PR body's "AC-001…AC-004 PASS"
rows are not yet corroborated by CI. My structural verification above (help output rendered
locally, headers confirmed present, pre-fix strings confirmed matching) gives me good
confidence they will pass, but do not merge on this approval until `ci-gate` itself is green.

Separately, per `CLAUDE.md`: branch protection runs `strict: false` on `develop`, so a green
gate is computed against the base as of the last run. This PR is only hours old and
`mergeable: MERGEABLE`, so staleness is not a concern here — just don't bank the green if it
sits.

## INFO-2 — no demo evidence; not blocking here, but a deliberate deviation

My checklist normally treats absent `docs/demo-evidence/<STORY-ID>/` recordings as blocking.
I'm not blocking, and want the reasoning on record rather than silent: the entire user-visible
delta is static `--help` text, and the exact strings are asserted directly in CI, so a
recording would add presentation value but no verification value. Worth noting the PR's
justification ("no behavioral or UI surface to record") is slightly overstated — `jr auth
login --help` and `jr auth login --oauth --no-input` are both trivially VHS-recordable, and a
help-text story is arguably the cheapest possible demo. If the wave gate wants uniform
evidence, a single ~10-second VHS capture of both commands would close it.
