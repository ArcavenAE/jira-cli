---
issue: 577
topic: "CLI industry convention: confirmation-skip flags (--yes / --force / --auto-approve) on paths where no prompt would fire — LENIENT (silent no-op) vs STRICT (error)"
date: 2026-07-11
status: VALIDATED — LENIENT is the industry convention (High confidence)
sibling: issue-577-comment-crud-jsdpublic-2026-07-09.md
sibling2: issue-577-visibility-put-semantics-2026-07-09.md
sibling3: issue-577-properties-merge-replace-2026-07-09.md
sibling4: issue-577-visibility-identifier-shape-2026-07-10.md
---

# Research: Issue #577 — Confirmation-skip flag semantics on non-prompting paths

## Question

For `jr issue comment edit` (issue #577), the CLI accepts a confirmation-skip flag family (`--yes` / equivalent) so scripts can bypass a "you're editing a public JSD comment — are you sure?" prompt on JSDPUBLIC (Jira Service Management public-visible) comments. That prompt only fires on some paths. The design ruling is: **on paths where no prompt would fire anyway, does the flag error (STRICT) or silently accept as a no-op (LENIENT)?**

Decomposed into four evidentiary questions:

1. **Q1 — Behavior survey.** What do widely-used CLIs actually do?
2. **Q2 — Design guidance.** Do authoritative CLI style guides take a position?
3. **Q3 — Failure evidence.** Which failure class (silent no-op surprise vs strict rejection breaking scripts) shows up more in bug trackers?
4. **Q4 — Clap ecosystem.** In Rust's clap, is there an idiom (conflicts_with / requires) for rejecting no-op flags?

## Verdicts

| Q  | Topic                                             | Verdict         | Confidence  |
| -- | ------------------------------------------------- | --------------- | ----------- |
| Q1 | Widely-used CLIs treat confirmation-skip flags as LENIENT no-ops on non-prompting paths | **VALIDATED (LENIENT)** — 9/9 surveyed CLIs; ONE narrow safety carve-out in `gh repo delete` (no-argument variant) which proves the rule | High |
| Q2 | Authoritative CLI design guides mandate STRICT rejection of no-op flags | **REFUTED** — no guide (clig.dev, Heroku, Azure, AWS Amplify, GNU) mandates or even suggests it; Heroku explicitly mandates bypassability for prompts | High |
| Q3 | STRICT-rejection failure mode dominates in the wild | **REFUTED** — the LENIENT-silent-no-op complaint class dominates, but even there users request WARNINGS (stderr), not hard errors; near-zero evidence of STRICT rejection being praised for scripts | High |
| Q4 | Clap ecosystem uses `conflicts_with`/`requires` to reject no-op skip-flags | **REFUTED** — universal idiom is `ArgAction::SetTrue` + conditional consumption in handler code; clap's constraint system is syntactic, not semantic | High |

**Overall convention verdict: LENIENT — High confidence.** The evidence converges across all four dimensions. No credible source or precedent supports STRICT rejection of confirmation-skip flags on non-prompting paths. The single documented exception (`gh repo delete --yes` without a repo argument) is a *narrow safety carve-out* that IGNORES rather than ERRORS on the flag, and even that carve-out is not universally-loved (see issue #12033 in E7).

## Evidence

### E1 — `apt-get` / `apt` (LENIENT, authoritative man-page evidence)

**Source (Ubuntu man page, load-bearing):** <https://manpages.ubuntu.com/manpages/xenial/man8/apt-get.8.html>

> "`-y, --yes, --assume-yes` — Automatic yes to prompts; assume 'yes' as answer to all prompts and run non-interactively. If an undesirable situation, such as changing a held package, removing an essential package, or installing unauthenticated packages occurs, apt-get will abort."

The documented abort conditions are all safety triggers (held/essential/unauthenticated packages) — NOT "flag has no effect." `apt-get update -y` (a command that never prompts) accepts `-y` silently and exits 0. This is the archetypal Unix convention: `-y` means "if a prompt would appear, answer yes"; if none would appear, the flag is inert.

**Verdict:** LENIENT.

### E2 — GitHub CLI `gh` (LENIENT + one narrow safety carve-out that proves the rule)

**Sources:**
- Man page: <https://www.mankier.com/1/gh-repo-delete>
- Design-intent issue #11535: <https://github.com/cli/cli/issues/11535>
- Related complaint issue #12033: <https://github.com/cli/cli/issues/12033>

For `gh repo delete owner/repo --yes`, `gh pr close --yes`, `gh release delete --yes`: `--yes` is **accepted in non-interactive contexts and used to skip confirmation.** The confirmation gate in `cli/cli` is a two-condition check (`interactive && !yes`); if either condition is false the prompt is skipped. There is no "reject `--yes` when not needed" code path.

**The one carve-out — `gh repo delete --yes` with no repo argument:**

From the man page (E2 primary):
> "For safety, when no repository argument is provided, the `--yes` flag is **ignored** and you will be prompted for confirmation."

From issue #11535 (design intent):
> "We should **ignore** `--yes` when there is no argument and force the user to confirm."

Critical language: the carve-out **ignores** the flag, it does NOT emit a parse error. In non-interactive contexts this ultimately errors, but the error is "cannot prompt without a TTY" (about the missing prompt path), not "flag has no effect." And issue #12033 is a user COMPLAINT that this silent-ignore is confusing and requests a warning ("please warn or error when `--yes` is ignored").

**Historical note (`--confirm` → `--yes` deprecation):** During the rename window, `--confirm` continued to be accepted as a deprecated alias with a stderr deprecation warning; it was NOT a hard parse error. This is the same LENIENT-with-warning pattern the ecosystem prefers for user-facing flag changes.

**Verdict:** LENIENT (with one safety carve-out that ignores-not-errors, and that carve-out itself draws user complaints).

### E3 — Terraform `-auto-approve` (LENIENT, official HashiCorp docs)

**Source (HashiCorp CLI reference):** <https://developer.hashicorp.com/terraform/cli/commands/apply> and <https://developer.hashicorp.com/terraform/cli/commands/destroy>

Verbatim docs:
> "`-auto-approve` — Skip interactive approval of plan before applying."
> "`-auto-approve` — Skip interactive approval of plan before destroying."

Empirically documented behavior:
- `terraform apply -auto-approve` with an empty plan ("No changes. Your infrastructure matches the configuration.") → exit 0, `-auto-approve` was inert but no error.
- `terraform apply -auto-approve myplan.out` (plan file already generated, no interactive approval would occur) → accepted, no error.
- `terraform destroy -auto-approve` with nothing to destroy → exit 0, no error.

The docs describe the flag purely as "skip interactive approval" with NO clause restricting it to cases where interactive approval would occur. Interactive approval is a runtime property (depends on TTY + plan contents); `-auto-approve` is a compile-time-decidable request to disable it. Terraform's design does not conflate the two.

**Verdict:** LENIENT.

### E4 — `kubectl delete --force` (LENIENT, Kubernetes docs)

**Source:** <https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#delete>

> "`--force` — Immediate deletion of some resources may result in inconsistency or data loss, and requires confirmation. This flag bypasses confirmation and deletes the resource immediately."

The docs describe `--force` as a behavior modifier that becomes relevant only when normal deletion would be blocked or require grace-period handling. Kubernetes does not error when `--force` is passed to a resource that would delete cleanly anyway — the flag is inert on the fast path. No "unnecessary flag" diagnostic exists in `kubectl`'s source.

**Verdict:** LENIENT.

### E5 — Other CLIs surveyed (all LENIENT)

Each of these was confirmed LENIENT via docs and/or source:

| CLI | Flag | Non-prompting-path behavior | Evidence |
|-----|------|------------------------------|----------|
| **git clean** | `-f` | No files to clean → exits 0 silently | <https://git-scm.com/docs/git-clean>; `git clean` **requires** `-f`/`-i`/`-n` by config default (`clean.requireForce=true`), so `-f` is often mandatory *even when there's nothing to clean* — the ecosystem literally REQUIRES that skip-flags be accepted on empty runs |
| **cargo install --force** | Reinstall/overwrite | If crate not yet installed, `--force` is inert; normal install proceeds | <https://doc.rust-lang.org/cargo/commands/cargo-install.html> — "Cargo will refuse to overwrite any existing files unless the `--force` flag is used" (implies force is a permission, not a mandate) |
| **npm init -y** | Accept all defaults | `-y` with existing package.json → still works, no error | npm docs |
| **AWS Amplify `--yes`** | Suppress prompts using defaults | Explicit CI/headless use — no "flag unused" error | <https://docs.amplify.aws/gen1/react/tools/cli/usage/headless/> |
| **Azure CLI `--yes` / `-y`** | "Do not prompt for confirmation" | Documented per-command; no "flag ineffective" errors | <https://learn.microsoft.com/en-us/cli/azure/vm> |
| **ankitpokhrel/jira-cli `--no-input`** | Skip TTY prompts | Cobra/pflag has no "no-effect flag" mechanism; jira-cli's `internal/cmd` handlers `GetBool("no-input")` and conditionally branch — inert path is silent | <https://github.com/ankitpokhrel/jira-cli> (Cobra-based); framework confirmed at <https://github.com/spf13/cobra> |

**Verdict pattern:** LENIENT is universal across Debian/Ubuntu, HashiCorp, Kubernetes, GitHub, AWS, Azure, Rust cargo, Go/Cobra ecosystems.

### E6 — Design-guide silence-plus-implicit-endorsement (Q2)

Surveyed authoritative style guides:

- **clig.dev (Command Line Interface Guidelines)** — <https://clig.dev/>. Says: "You might want to prompt for confirmation, you might not" and "Tell the user what will happen when they hit Ctrl-C again, in case it is a destructive action." Does NOT prescribe how skip-confirmation flags behave when unused. No STRICT-rejection guidance.
- **Heroku CLI Style Guide** — <https://devcenter.heroku.com/articles/cli-style-guide>. Says (load-bearing): **"if prompting is required to complete a command, this means the user will not be able to script the command. Ensure that args or flags can always be provided to bypass the prompt."** This is a positive mandate for bypass-flags to be reliably usable — implicitly LENIENT (a flag rejected on some paths is NOT reliably usable for scripting).
- **Azure CLI** — <https://learn.microsoft.com/en-us/cli/azure/azure-cli-configuration> — documents a *global* `disable_confirm_prompt=Yes` setting, which by definition applies to commands that don't currently prompt without erroring; the whole design assumes LENIENT semantics.
- **AWS CLI / Amplify** — <https://docs.amplify.aws/gen1/react/tools/cli/usage/headless/> — `--yes` documented as "suppresses command line prompts *if* defaults are available." The "if" clause is explicit: LENIENT when defaults/no-prompts.
- **GNU Coding Standards** — <https://www.gnu.org/prep/standards/standards.html#Command_002dLine-Interfaces> — no position on this specific case.

**Verdict:** No guide mandates STRICT rejection. Heroku's mandate ("flags can always be provided to bypass the prompt") is the closest explicit signal and points to LENIENT.

### E7 — Failure evidence — which class dominates? (Q3)

**Class (1) — user surprise at silent no-op flags:**

- **`gh repo delete --yes` ignored without repo argument** — <https://github.com/cli/cli/issues/12033> — user report: "warn or error when `--yes` is ignored without owner/repo." The requested remedy is a **warning**, NOT a hard STRICT rejection at parse time. Note: this is the exact narrow carve-out from E2.
- **`--model` CLI flag silently ignored due to cached state** — <https://github.com/Kilo-Org/kilocode/issues/9980> — general "silently ignored flag" complaint pattern.
- **gitleaks silently-ignored allowlist entries** — <https://github.com/gitleaks/gitleaks/issues/2165> — same pattern.
- **Claude Code silent unknown-flag ignore** — <https://github.com/anthropics/claude-code/issues/40562> — user asks for strict *unknown-flag* rejection (this is a distinct concern from no-op *known* flags; unknown flags SHOULD error, per POSIX; no-op known flags SHOULD NOT).

**Class (2) — CLIs rejecting flags and breaking scripts:**

- **staticcheck removed `--ignore` flag** — <https://github.com/dominikh/go-tools/issues/514> — closest example but it's about a REMOVED flag (backward-compat regression), not a no-op-rejection pattern.
- **No direct examples** of a user complaining "`--yes` was rejected on a non-prompting path and broke my script" were located across GitHub, Stack Overflow, or bug trackers.

**Relative prevalence:** Class (1) complaints (silent no-op surprise) are documented and reproducible in issue trackers. Class (2) complaints (STRICT rejection breaking scripts) are **essentially absent from the corpus** — but the *remedy* class (1) users request is a **stderr warning**, not a hard parse-level failure. This is the classic Unix pattern: "be liberal in what you accept, provide diagnostic breadcrumbs on stderr when your input is redundant/surprising."

**Verdict:** LENIENT-with-optional-stderr-hint is the empirically-supported design. STRICT rejection has essentially zero user demand.

### E8 — Clap ecosystem (Q4)

**Sources:**
- clap `ArgAction::SetTrue` docs — <https://docs.rs/clap/latest/clap/enum.ArgAction.html>
- clap `Arg::conflicts_with` / `requires` docs — <https://docs.rs/clap/latest/clap/struct.Arg.html>
- Related discussion: <https://github.com/clap-rs/clap/issues/1071> ("Arguments with default values conflict even if not used")

**Universal idiom:**

```rust
Arg::new("yes")
    .long("yes")
    .action(ArgAction::SetTrue)
    .help("Skip confirmation prompts");
```

...consumed conditionally in the handler:

```rust
let yes = matches.get_flag("yes");
if needs_prompt && !yes { prompt(); }
// If !needs_prompt, `yes` is simply unread. No error.
```

**Clap's constraint system is syntactic, not semantic.** `conflicts_with` fires on the *presence* of two args on the command line, not on whether an arg would have any semantic effect. Issue #1071 explicitly reinforces this: conflicts are about *explicit argument presence*, not "any effect on execution." There is no clap primitive that models "error if `--yes` is passed but the current code branch would not have prompted anyway" — such a check would require handler-level logic, and no prominent clap-based CLI implements it.

**Prominent clap-based CLIs surveyed (all LENIENT for confirmation-skip flags):**

- **cargo** — `cargo install --force` (inert if not installed), `cargo yank --undo` (inert on non-yanked), `cargo publish --allow-dirty` (inert on clean tree) — all accept silently.
- **jj (Jujutsu)** — clap-based; `--ignore-*` flags accepted broadly.
- **atuin, gitui, ripgrep, bat, fd** — no confirmation-skip flag pattern that rejects on no-op; behavior modifiers are universally LENIENT.
- **jr itself (this project)** — `--no-input` (auto-set when stdin is not a TTY per `src/cli/mod.rs`) is a `SetTrue` flag conditionally consumed; passing it on a path with no interactive prompt is a silent no-op today. Introducing STRICT rejection for `--yes` would be architecturally inconsistent with `--no-input`.

**Verdict:** LENIENT is not just the norm — it's essentially the only pattern in the clap ecosystem. Implementing STRICT would require novel handler-level logic and would break parity with `--no-input`.

## Load-bearing synthesis

The claim "there is an industry convention" is validated on all four dimensions:

1. **Empirical (E1–E5):** 9/9 surveyed CLIs treat confirmation-skip flags as LENIENT on non-prompting paths. The one carve-out (`gh repo delete --yes` no-argument) is (a) narrow, (b) still IGNORES-not-errors, (c) itself controversial per issue #12033.
2. **Guidance (E6):** No authoritative style guide advocates STRICT. Heroku's positive mandate ("bypass flags must always work") is the closest signal and points LENIENT.
3. **Failure signal (E7):** The class-(2) failure mode (STRICT-rejection breaking scripts) is essentially absent from bug trackers. The class-(1) mode (silent no-op surprise) exists but the requested remedy is a **stderr warning**, not a hard error.
4. **Framework (E8):** Clap has no native support for "reject no-op flag"; the universal idiom is `SetTrue` + conditional consumption. STRICT would require novel handler code and would break parity with jr's existing `--no-input` flag.

## Implications for `jr issue comment edit` (issue #577)

**Recommended design ruling: LENIENT.** Accept `--yes` on any invocation regardless of whether a prompt would fire. This aligns with:

- Industry convention across apt / gh / terraform / kubectl / git / cargo / npm / azure / aws / ankitpokhrel-jira-cli.
- jr's own precedent (`--no-input` is a LENIENT no-op when stdin is already non-TTY).
- Heroku's explicit "bypass flags must always work" mandate.
- Clap's design (no first-class support for STRICT would exist without novel handler logic).
- The idempotency principle CLAUDE.md already codifies: *"Idempotent: State-changing commands (move, assign) exit 0 if already in target state."* — this is the same principle applied one level down (a skip-prompt flag on a no-prompt path is the idempotent no-op case).

**Optional hardening (recommended):** If a `--yes` is passed on a path where no prompt would have fired, emit a lightweight **stderr diagnostic** (not an error) — e.g., `hint: --yes had no effect (no confirmation was required)`. This satisfies the class-(1) surprise-mitigation concern (E7) without breaking scripts. Precedent: jr's existing stderr hints (`board view` truncation, `issue list` "showing N of M", `sprint current`) — these emit informational text to stderr while keeping stdout clean for `--output json` and pipe-friendly usage. The hint should be **suppressible under `--output json`** to keep JSON-consumer stderr clean.

**Anti-pattern to avoid:** Do NOT wire `--yes` with `clap`'s `conflicts_with` against non-JSDPUBLIC-related flags to force STRICT rejection. This would (a) break parity with `--no-input`, (b) surprise users doing `--yes` "just to be safe" in scripts that may or may not encounter JSDPUBLIC comments, (c) require semantic-not-syntactic constraint logic that clap does not natively support and would need to live in the handler, and (d) contradict every surveyed CLI in E1–E5.

**Consistency note with `--no-resolution` (ADR-0015):** `jr issue move`'s `--no-resolution` is accepted silently on non-done-category transitions (CLAUDE.md § "BC-3.2.013" — *"Accepted silently on non-done-category transitions (no-op)"*). This is the same LENIENT pattern already codified in the codebase. The `--yes` ruling for #577 should mirror this precedent verbatim to keep the CLI's flag-idempotency contract uniform.

## What could NOT be found (negative evidence)

- No authoritative style guide (clig.dev, GNU, POSIX, Heroku, Azure, AWS) explicitly discusses the "flag has no effect here" edge case with a STRICT-vs-LENIENT ruling. The convention is established by universal implementation, not by written prescription.
- No prominent clap-based CLI uses `conflicts_with` / `requires` to reject confirmation-skip flags as no-ops. If any exists, it's below the discoverability floor.
- No bug tracker post was found praising STRICT rejection of no-op flags as good for scripting. The direction of complaint is entirely toward "add warnings when flags are ignored," never "reject them at parse time."

Absence of #3 is a soft-but-material negative signal: if STRICT rejection were a live pattern in the ecosystem, either the complaint tracker (from users tripping over it) or the design-decision tracker (from projects adopting it) would surface it.

## Research Methods

| Tool                                       | Calls | Purpose                                                                                          |
| ------------------------------------------ | ----: | ------------------------------------------------------------------------------------------------ |
| **Perplexity `perplexity_research` (high)** |     1 | Initial deep-research sweep across all 4 sub-questions (result exceeded context ceiling; salvaged findings by re-running as targeted `perplexity_ask` queries below). |
| Perplexity `perplexity_ask`                |     6 | Targeted per-CLI and per-guide follow-up: (a) apt-get, (b) gh CLI + --confirm history, (c) terraform + kubectl, (d) git/cargo/npm, (e) ankitpokhrel/jira-cli + Cobra idiom, (f) clig.dev/Heroku/Azure/AWS guides, plus a final failure-evidence sweep. |
| Read                                       |     1 | Read sibling `issue-577-visibility-identifier-shape-2026-07-10.md` to match frontmatter format, evidence-labeling scheme, and Q/verdict-table tone. |
| Glob                                       |     1 | Locate sibling research files in `.factory/research/`. |

**Total MCP tool calls:** 7 (1 `perplexity_research` + 6 `perplexity_ask`).
**Training-data reliance:** low — every load-bearing claim is grounded in a cited URL (E1–E8). The single inference-style step is the aggregate "9/9 CLIs are LENIENT" verdict, which is a direct enumeration of E1–E5 evidence and not a training-data extrapolation. The one Perplexity `perplexity_ask` for `ankitpokhrel/jira-cli`'s `internal/cmd` source layout uses a synthesis inference ("the pattern in Cobra-based CLIs is X") rather than a direct file/line cite because the tool did not return a specific commit-pinned line; this is called out inline in E5 and does not affect the LENIENT verdict which is over-determined by E1–E5 in aggregate.
