---
document_type: research-brief
issue: 663
producer: research-agent
timestamp: 2026-08-13
status: complete
subject: "auth switch: global --profile duplicates positional <NAME>; error-path usage strings disagree"
mode: brownfield-feature
---

# Research Brief — Issue #663: `auth switch` `--profile` / usage-string inconsistency

## 0. Scope & method

Verified every issue claim against the actual source at repo root and against the
compiled debug binary (`target/debug/jr`, built 2026-08-13). clap mechanism claims
verified against clap-rs source via Context7 (`/clap-rs/clap`) and cross-checked
with the clap docs.rs API + clap issue tracker via Perplexity. The issue text was
treated as untrusted input; all three reported usage strings were reproduced
empirically (Section 2). Code locations are cited symbol-form per project convention.

---

## 1. Current definition (verified against source)

### 1.1 Global `--profile` flag
- Declared ONCE at the top level: `src/cli/mod.rs :: Cli.profile`
  — `#[arg(long, global = true)]`, `pub profile: Option<String>`, doc string
  "Override the active profile (precedence: this flag > JR_PROFILE > config > \"default\")".
- Because it is `global = true`, clap **propagates it to every subcommand**, including
  `auth switch`. This is intentional for the many subcommands where it is meaningful.

### 1.2 `auth switch` positional `<NAME>`
- `src/cli/mod.rs :: AuthCommand::Switch { name: String }` — a **required positional**,
  doc "Profile name to make active. Must already exist in config." No subcommand-level
  `#[arg(long)] profile` field (unlike `Logout`/`Status`/`Refresh`, which each declare
  their own `profile: Option<String>`).

### 1.3 Dispatch
- `src/main.rs` `AuthCommand::Switch { name } =>
  cli::auth::handle_switch(&name, cli.profile.as_deref(), &cli.output)`.
  The positional `name` is the switch target; `cli.profile` (the global flag) is
  passed as `cli_profile`.

### 1.4 Resolution — is `--profile` genuinely ignored by `auth switch`?
`src/cli/auth/switch.rs :: handle_switch`:
1. `Config::load_with(cli_profile)` — loads global config; `cli_profile` only affects
   `Config::active_profile_name` via `config.rs :: resolve_active_profile_name`
   (`src/config.rs :: Config::load_with`, line ~325).
2. `handle_switch_in_memory(config.global, target)` — validates and sets
   `global.default_profile = Some(target)` where **`target` is the positional `name`**.
3. `config.save_global()`.

The **write path depends only on the positional**. `--profile` does **not** change what
gets written. It is therefore effectively a **no-op for the outcome**, with ONE residual
side effect: `Config::load_with` validates that the resolved active profile exists in
`[profiles]` when the profiles map is non-empty (`src/config.rs`, ~line 345). So
`--profile X` forces a load-time existence check on `X` — which is exactly why the
reporter observed that `jr auth switch --profile X X` (same value twice, both must be
real) is the incantation that "finally works": both the flag AND the positional must
name existing profiles, but only the positional is the true argument.

**Conclusion:** `--profile` on `auth switch` is a semantic no-op that reads as
"the argument you're supposed to use," and its only observable effect is an extra
existence constraint — pure confusion, zero benefit. Issue claim CONFIRMED.

---

## 2. Usage-string mechanism (three signatures) — reproduced + explained

Reproduced verbatim from `target/debug/jr`:

| Invocation | Usage line printed |
|---|---|
| `jr auth switch --help` | `Usage: jr auth switch [OPTIONS] <NAME>` |
| `jr auth switch` (bare) | `Usage: jr auth switch <NAME>` |
| `jr auth switch --profile foo` | `Usage: jr auth switch --profile <PROFILE> <NAME>` |

Also confirmed `jr auth switch --profile foo foo` reaches the handler with
target = positional `foo` (error `unknown profile: foo` originates in
`handle_switch_in_memory`, not from the flag) — proving the positional is the real target.

**Why clap prints three different strings (verified against clap source):**

- **`--help`** renders the *canonical/full* usage: the `[OPTIONS]` placeholder
  collapses all optional args + the required positional → `[OPTIONS] <NAME>`.
- **Error paths** do NOT use the full usage. Every clap error is built with
  `Usage::new(self.cmd).required(&self.required).create_usage_with_title(&[])`
  (clap `clap_builder/src/parser/validator.rs` for the missing-required case;
  `clap_builder/src/parser/parser.rs :: match_arg_error` for unknown-arg cases).
  `create_usage_with_title` emits **only the required args plus the args already
  present in the parse matcher** — NOT the `[OPTIONS]` summary.
  - Bare `jr auth switch`: nothing supplied → usage = required-only = `<NAME>`.
  - `jr auth switch --profile foo`: `--profile` was *supplied*, so clap promotes the
    already-used optional arg into the required-usage line → `--profile <PROFILE> <NAME>`.
    This is the documented clap behavior shown in clap's own `04_03_relations` example,
    where a supplied `-c config.toml` is promoted into the missing-required usage:
    `Usage: 04_03_relations[EXE] -c <CONFIG> ... <INPUT_FILE|--spec-in <SPEC_IN>>`.
    (Source: clap `examples/tutorial_derive/04_03_relations.md`.)

**Key takeaway for the fix:** The `<NAME>` (bare error) vs `[OPTIONS] <NAME>` (--help)
divergence is **inherent, universal clap behavior** — it happens for EVERY jr subcommand
with a required positional, not just `auth switch`. It is NOT specifically fixable per
subcommand short of `override_usage` (brittle, discouraged). The reporter's request to
"print the same signature everywhere" is therefore not achievable through idiomatic clap.
The genuinely jr-fixable divergence is the **third** form (`--profile <PROFILE>` promoted
into the usage) — and that only exists because `--profile` is accepted on `auth switch`
at all. Remove `--profile` from switch and the third signature disappears; the remaining
two-way difference is the same universal clap behavior every other subcommand exhibits.

---

## 3. Fix options in clap-derive terms

Project constraint (CLAUDE.md): "`--profile NAME` flag overrides JR_PROFILE for one
invocation; precedence flag > env > config > default." A GLOBAL removal/hide is WRONG —
`--profile` must remain meaningful for all other subcommands. The fix MUST be scoped
to `auth switch`.

### Option 1a — `hide = true` on the global `--profile` → REJECTED
`--profile` is declared once on `Cli`. `hide = true` would hide it from *every*
subcommand's `--help`, including the many where it is meaningful. clap 4 derive provides
**no per-subcommand override to hide/disable a propagated global arg** (confirmed:
docs.rs clap Arg; clap discussion #4134; users.rust-lang.org "clap ignore global argument
in sub-command"). Not viable.

### Option 1b — `conflicts_with = "profile"` on the `Switch` positional → PARTIAL / risky
`#[arg(conflicts_with = "profile")]` on `name`. clap resolves conflicts by arg ID across
the command hierarchy, so a subcommand positional *can* reference the global arg's ID.
This is the clap-idiomatic try. BUT:
- **Incomplete:** it fires only when BOTH are supplied (`--profile X Y`). The case
  `jr auth switch --profile X` (flag, no positional) still hits the missing-required path
  and STILL prints `--profile <PROFILE> <NAME>` — the exact third usage string the issue
  objects to is not eliminated.
- **Reliability risk:** conflicts involving `global = true` args have documented
  edge-case bugs where the conflict is not enforced (clap issues #5335, #5358). Relying
  on it for a correctness guard is fragile.
- The resulting error message still names `--profile`, reinforcing rather than removing
  the confusion.

### Option 2 — `--profile` as an alias for the positional → REJECTED
`--profile` is a global, semantically-distinct override; aliasing it to the switch
positional would entrench the double-name confusion the issue wants removed, and cannot
be expressed cleanly (a global optional cannot "become" a required positional).

### Option 3 (RECOMMENDED) — runtime guard rejecting `--profile` on `auth switch`
Add a guard at the `AuthCommand::Switch` dispatch arm (`src/main.rs`) — or at the top of
`switch.rs :: handle_switch` — that returns `JrError::UserError` (exit 64) when
`cli.profile.is_some()`:

> `--profile is not valid for 'auth switch'. The profile to activate is the positional
> argument. Try: jr auth switch <NAME>`

Why this is the cleanest option that satisfies (a) remove double-name ambiguity and
(b) usage-string consistency:
- **Deterministic** — no dependency on clap's flaky global-arg conflict machinery.
- **Consistent, project-idiomatic error** — flows through the central handler at
  `src/main.rs` (~lines 124-147), so it produces exit 64 and, under `--output json`,
  the canonical `{"error": "...", "code": 64}` envelope automatically (satisfies the
  #526 JSON render invariant, no extra work). Matches CLAUDE.md "Errors: always suggest
  what to do next."
- **Kills the third usage string** — once `--profile` is a hard error on switch, users
  are told exactly what to type; the confusing `--profile X X` incantation is gone.
- Mirrors the existing pattern already in `run()` where `--profile` is validated centrally
  (`src/main.rs` ~line 159 `validate_profile_name`) and DEC-188's exit-64 pre-flight
  guards in `issue create` (precedent for a manual exit-64 guard rather than a clap
  `requires`/`conflicts` attribute — CLAUDE.md explicitly notes clap `requires` yields
  exit 2, not the desired exit-64 `UserError`).

**Optional belt-and-suspenders:** add Option 1b's `conflicts_with = "profile"` as a
clap-level second line of defense, but do NOT rely on it alone. Primary enforcement is
the runtime guard.

**On the residual `<NAME>` vs `[OPTIONS] <NAME>` divergence:** document as accepted
(universal clap behavior). Do not pursue `override_usage` to force identical strings —
it is brittle and would have to be replicated across the whole CLI to be consistent.

---

## 4. BC / spec impact

| BC | File | Impact |
|---|---|---|
| **BC-1.2.018** "Global `--profile` propagates to all auth subcommands via `subcmd.profile.or(cli.profile)`" | `bc-1-auth-identity.md:212` | **AMEND** — carve out `auth switch` as the explicit exception where `--profile` is now rejected (exit 64). Note switch has no subcommand-level `profile` field, so it consumes only the global flag. |
| **BC-1.1.008** "Global `--profile` propagates to `auth status` via main.rs composition" | `bc-1-auth-identity.md:106` | Review only — status is unaffected, but confirm wording does not imply switch also honors `--profile`. |
| **BC-1.1.003** "`auth switch <unknown>` exits 64" | `bc-1-auth-identity.md:51` | Unaffected (positional path). The new guard is a *sibling* behavior. |
| **NEW BC (add)** "`auth switch --profile <X>` exits 64 (flag rejected; use positional)" | `bc-1-auth-identity.md` | **ADD** — new behavioral contract for the guard, including the `--output json` `{"error","code":64}` envelope. Trace to `src/main.rs` Switch arm / `switch.rs::handle_switch` + central error handler. |
| **BC-7.4.014** "`auth switch --output json` success shape `{profile,action,ok}`" | `bc-7-output-render.md:799` | Unaffected on success; the new error path uses the standard error envelope, not this shape. |
| **BC-1.1.007** profile precedence chain | `bc-1-auth-identity.md:95` | Unaffected — precedence semantics for other subcommands unchanged. |

No ADR change required (no architectural decision reversed). A one-line CLAUDE.md gotcha
noting "`--profile` is rejected on `auth switch` (use the positional)" is warranted in
the same commit.

---

## 5. Risks / inconclusive

- **clap global-arg conflict reliability (documented):** `conflicts_with` against a
  `global = true` arg has known enforcement bugs (clap #5335, #5358). This is WHY the
  recommendation is a runtime guard, not a clap attribute. If Option 1b is added as a
  secondary defense, its behavior must be covered by an integration test, not assumed.
- **No per-subcommand hide for a global arg (confirmed, not inconclusive):** clap 4
  derive cannot hide/disable a propagated global arg for a single subcommand. The only
  clap-native alternative is to de-globalize `--profile` and re-add it per-subcommand via
  flattened `Args` — a large, out-of-scope refactor that would touch every command. Avoid.
- **Full usage-string unification is NOT achievable idiomatically:** the `--help`
  (`[OPTIONS] <NAME>`) vs error-path (`<NAME>`) difference is inherent to clap's
  required-only error usage. Reporter's "match --help everywhere" cannot be met without
  `override_usage`; recommend accepting it and documenting. The recommended guard removes
  the one *jr-specific* divergence (the promoted `--profile <PROFILE>` form).
- **`--profile` still appears in `jr auth switch --help` OPTIONS list** because it is a
  global arg. The runtime guard makes it a hard error at runtime but does not remove it
  from help text (global args always list). If the reporter wants it gone from switch's
  help too, that requires the de-globalize refactor above — recommend NOT doing it; the
  runtime rejection + help doc note is sufficient and low-risk.

---

## Sources
- clap source (Context7 `/clap-rs/clap`): `clap_builder/src/parser/validator.rs`
  (`Usage::new(...).required(...).create_usage_with_title`), `clap_builder/src/parser/parser.rs`
  (`match_arg_error`), `examples/tutorial_derive/04_03_relations.md` (supplied-arg promotion
  into missing-required usage), `examples/git-derive.rs` (`args_conflicts_with_subcommands`).
- clap Arg API: https://docs.rs/clap/latest/clap/struct.Arg.html
- clap global-arg conflict edge cases: clap issues #5335, #5358; discussion #4134;
  https://users.rust-lang.org/t/clap-ignore-global-argument-in-sub-command/101701
  (via Perplexity, 2026-08-13).
- Source of truth: `src/cli/mod.rs`, `src/cli/auth/switch.rs`, `src/cli/auth/mod.rs`,
  `src/main.rs`, `src/config.rs`; empirical reproduction from `target/debug/jr`.
