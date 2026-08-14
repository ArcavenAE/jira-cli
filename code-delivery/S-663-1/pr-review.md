## PR Review — S-663-1 `auth switch --profile` guard (fresh-eyes, diff-only)

**Verdict: APPROVE** — no blocking findings. Four non-blocking findings below.

> Posting note: `gh pr review 696 --approve` was attempted first and rejected by GitHub —
> `Review Can not approve your own pull request (addPullRequestReview)`, because the
> authenticated `gh` account is the PR author. Re-posted as a review of type COMMENT via
> `gh pr review 696 --comment --body-file …` (review id 4932340888). The APPROVE verdict is
> carried in this body rather than in the API review state, because GitHub does not permit
> an author account to set APPROVE or REQUEST_CHANGES on its own PR. A human approval from a
> different account is still required to satisfy branch protection.

### What I verified (not a rubber stamp)

- **Guard placement (`src/main.rs:239-258`)** — the `if cli.profile.is_some()` check is the first statement in the `AuthCommand::Switch` arm. The `Command::Auth` arm does no `Config::load_with` of its own before dispatching (unlike `Assets`/`Me`/etc., which load at line 176/278/…), and `handle_switch` is the only thing that reads config or the keychain on this path. So the claim "fires before any config/keychain I/O" holds. The one thing that *does* run earlier is `config::validate_profile_name` at `src/main.rs:159-161` — AC-6 pins that ordering explicitly rather than papering over it, which is the right call.
- **Keying** — `cli.profile.is_some()` is the parsed CLI flag only. `JR_PROFILE` reaches the program through figment's `Env::prefixed("JR_")` inside `Config::load_inner`, never through `cli.profile`, so the direnv-scoped workflow genuinely cannot trip the guard. AC-5 pins it end-to-end (env set, switch succeeds, `default_profile` persisted).
- **Exit code** — `JrError::UserError` → 64 (`src/error.rs:94`); `main` finds it by walking `e.chain()` and downcasting (`src/main.rs:125-128`), so the `.into()` into `anyhow` does not lose the code. Correctly *not* a clap `conflicts_with`, which would give 2.
- **JSON envelope** — AC-2 routes through the shared `assert_json_error_envelope` helper, which asserts stdout empty, stderr parses as JSON, non-empty `error`, and `code == 64`. Channel separation preserved.
- **Regression risk to the other six subcommands** — the diff touches nothing outside the `Switch` arm. `Login`/`Status`/`Refresh`/`Logout` keep `profile.or_else(|| cli.profile.clone())`; `List`/`Remove` keep `cli.profile.as_deref()` passthrough. AC-7/AC-8 pin all six behaviorally, including the "must not emit the Switch-only message" negative assertion. I found no existing test, script, or workflow that passed `--profile` to `auth switch`, so nothing else breaks.
- **Happy path** is still covered by the pre-existing `tests/auth_output_json.rs:128` (plain `auth switch default --output json` → success envelope) — the new suite did not need to re-pin it.
- Commit is conventional + `!` + a `BREAKING CHANGE:` trailer; 432 lines, ~93% tests.

### Findings

| # | Severity | Category | Finding |
|---|----------|----------|---------|
| 1 | suggestion | description | `--profile` on `auth switch` was **not** a pure no-op — the description understates what changed |
| 2 | suggestion | coherence | Dead argument at `src/main.rs:258` |
| 3 | suggestion | description | README not updated for a user-facing breaking change |
| 4 | nit | coverage | No pin for the leading-flag placement `jr --profile X auth switch Y` |

---

**[SUGGESTION] `--profile` was not a silent no-op — it suppressed the active-profile existence check** (`src/cli/auth/switch.rs:38`, `src/config.rs:220-222`/`:349`)

The PR body, the CHANGELOG entry, and the code comment at `src/main.rs:241-245` all describe the flag's only effect as "forcing an extra, confusing existence-check on `--profile`'s own value". That is not quite the whole picture: `handle_switch` passes `cli_profile` into `Config::load_with`, which is the **strict** loader — it errors with `unknown profile: …` unless the *resolved active* profile exists. Passing `--profile <valid>` therefore *replaced* the resolved active profile, letting `auth switch` run in a state where the resolved one is dangling. Post-guard, `jr auth switch <valid>` in that state exits 64 with `unknown profile: <dangling>` and there is no longer a CLI flag to get past it.

I checked how reachable that state is before calling this blocking, and it is narrow: `auth remove` already refuses to delete the profile named by `default_profile` (`src/cli/auth/remove.rs:44-51`), so supported commands cannot create it — it takes a hand-edited `config.toml` or a `JR_PROFILE` typo (and for the env case `--profile` never fully helped anyway, since the env var still poisons the next command). Hence: non-blocking. But it is worth closing properly, because `auth switch` has no legitimate need for a valid *current* profile — it validates its own target in `handle_switch_in_memory`:

```rust
// src/cli/auth/switch.rs:38
let mut config = Config::load_with(cli_profile)?;   // strict
// → Config::load_lenient_with(None)?               // target is validated below anyway
```

That one-line change makes `auth switch` the self-healing command it reads as, and makes the guard unambiguously a pure removal of a confusing flag. If you'd rather keep it out of scope, the cheaper alternative is a sentence in the CHANGELOG migration note saying that a `config.toml` whose `default_profile` names a missing profile must now be fixed by editing the file.

**[SUGGESTION] Dead argument now that the guard is above it** (`src/main.rs:258`)

```rust
cli::auth::handle_switch(&name, cli.profile.as_deref(), &cli.output).await
```

Past the guard, `cli.profile` is provably `None`, so this reads as though the flag still composes into the handler when it cannot. `handle_switch` has exactly one caller, so either pass `None` explicitly or drop the parameter. Leaving it live is the kind of thing a future refactor "restores" by accident — and if you take finding 1, the parameter disappears anyway.

**[SUGGESTION] README is the surface users read, and it still promises the old behavior** (`README.md:307`, `README.md:246`)

`README.md:307` documents `--profile NAME` as "Override the active profile for this invocation" with no exception, and the `jr auth switch <NAME>` row at `:246` doesn't mention the rejection. CHANGELOG (release notes) and CLAUDE.md (contributor memory) were both updated; the one doc an end user hits after `jr auth switch --profile x y` exits 64 was not. A clause on the `--profile` row — "rejected on `auth switch`; the positional `<NAME>` is the target" — would close it. Note `jr auth switch --help` still lists `--profile` as accepted (it's `global = true`), so the README is the only place this can be signposted ahead of time.

**[NIT] Order coverage misses the placement the README itself documents** (`tests/auth_profiles.rs:659-701`)

AC-4 covers `switch --profile foo foo` and `switch realprofile --profile bogus`, but not `jr --profile foo auth switch bar` — the leading-global-flag form shown at `README.md:352` and the form AC-7 uses for all six other subcommands. It works identically today (clap globals), so this is a cheap regression pin, not a bug.

### Not raised as findings, but noted

- **CI is not green yet at review time.** Format, gitleaks, spec-guards, signing-injection guard, and dependency-review pass; Test (×3), Clippy (×2), MSRV, Deny, Coverage, and Mutation testing were all still `pending`. This approval is contingent on `CI Gate` going green — please don't merge on the partial set.
- **Demo evidence is not reviewable from the PR.** The body cites `.factory/demos/S-663-1/demo.gif`, which is not in the diff and not in the repo tree, so I could not verify any AC visually. The in-repo convention (`docs/demo-evidence/<STORY-ID>/`) was last used around #638 and the most recent feature PR (#691) skipped it too, so this is consistent with current practice rather than a regression — flagging only so the gap is a known one.
