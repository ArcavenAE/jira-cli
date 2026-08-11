---
document_type: research
date: 2026-08-10
decision_id: DEC-246-FOLLOWUP
story_id: S-626-1
topic: >-
  External validation of the six environmental assumptions underpinning the
  binary-trust layer of `scripts/check-ci-gate.sh` (401 lines of security-relevant
  shell merged to `develop` via PR #667 / `a5e1d087` without adversarial review):
  `/usr/bin` + `/bin` writability on `ubuntu-latest`; usrmerge equivalence of the
  two Linux allowlist entries; `/opt/homebrew/bin` + `/usr/local/bin` writability
  on `macos-latest`; whether `RUNNER_OS` can be UNSET (not merely overwritten);
  the exact `RUNNER_OS` value domain and the `*)` fail-closed arm; and whether
  `json="$(</dev/stdin)"` is a genuine fork-free builtin read over a pipe.
status: conclusive
confidence: high
verification_method: >-
  Primary sources only — official GitHub documentation pages fetched verbatim,
  the `actions/runner` and `actions/runner-images` repositories at `main`,
  Ubuntu/Canonical package and documentation sources, the GNU Bash reference
  manual, and Homebrew's own installer. Supplemented by TWO classes of local
  empirical evidence that are legitimately decidable off-platform: (a) direct
  execution of `bash` against `$(</dev/stdin)` on bash 3.2.57 and 5.3.9,
  including a PATH-emptied control that proves no external binary is involved;
  (b) `scripts/check-ci-gate.sh --self-test` run locally to confirm the
  fail-closed `*)` arm behaviourally. One genuine production datapoint is used:
  GitHub Actions run 31432422878 on `a5e1d087`. Every factual assertion carries a
  URL and a 2026-08-10 access date. Nothing in this document was executed against
  live GitHub Actions infrastructure by this pass.
sources:
  - https://docs.github.com/en/actions/reference/runners/github-hosted-runners
  - https://docs.github.com/en/actions/reference/workflows-and-actions/variables
  - https://github.com/actions/runner/blob/main/src/Runner.Worker/RunnerContext.cs
  - https://github.com/actions/runner/blob/main/src/Runner.Worker/Handlers/ScriptHandler.cs
  - https://github.com/actions/runner/blob/main/src/Runner.Worker/StepsRunner.cs
  - https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md
  - https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md
  - https://github.com/actions/runner-images/blob/main/images/macos/scripts/build/install-homebrew.sh
  - https://github.com/actions/runner-images/issues/10484
  - https://packages.ubuntu.com/noble/amd64/jq/filelist
  - https://documentation.ubuntu.com/rockcraft/1.19/explanation/usrmerge/
  - https://wiki.debian.org/UsrMerge
  - https://docs.brew.sh/Installation
  - https://github.com/Homebrew/install/blob/master/install.sh
  - https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html
---

# `check-ci-gate.sh` shell-trust layer — external assumption validation

## Provenance note — READ FIRST

This is the **third pass** in a series. Read in order:

1. `.factory/research/dec-246-github-actions-gating-semantics.md` (2026-08-09)
2. `.factory/research/gh-actions-open-semantics-2026-08-10.md` (2026-08-10)
3. **this document**

Passes 1 and 2 validated GitHub Actions' *gating* semantics — what `needs`
reports and when. This pass validates the *environmental* assumptions of the
binary-trust layer that commits `736fea28` / `23ace476` added to
`scripts/check-ci-gate.sh`. It does not re-review that code's logic; the team
lead has already verified the code as quoted in the brief and those facts are
taken as given, not re-derived.

Recovery labels use the same vocabulary as passes 1 and 2:

- `RECORDED` — the finding pre-exists in a project artifact or in the script's
  own comments.
- `NEWLY-RESEARCHED` — established on 2026-08-10 against a cited primary source.
- `INFERRED` — a deduction from primary facts, not a documented statement.

**No verdict in this document was softened from INCONCLUSIVE to CONFIRM.** Two
sub-claims (Q1b, Q3b) are INCONCLUSIVE-on-primary and carried as labelled
inferences with the exact settling experiment specified, even though both
inferences are high-confidence and one of them would, if I were being sloppy,
read naturally as "obviously true."

**Source-tier discipline.** GitHub-hosted issues and community discussions are
user-authored, not documentation; they are labelled **SECONDARY** at every point
of use and never form the sole basis for a CONFIRM. One deviation from pass 2's
method is deliberate and is flagged where used: **local execution of `bash`** is
treated as PRIMARY evidence for Q6, because Q6 is a question about `bash`, not
about GitHub, and the same `bash` is available here.

---

## Lead finding — NO REFUTE, and the reason that is not reassuring

**Nothing in the merged code is refuted. All six assumptions hold as stated.**
Per the brief's instruction I lead with this so it is not buried: there is no
emergency here, and no assumption underpinning `736fea28` / `23ace476` was found
to be false.

**That is the narrow answer. The broad answer is the one worth your attention,
and I am stating it in the exact terms the brief invited:**

> **The trust property holds on the decision path only because `/usr/bin`
> requires root to write. Everything else in the allowlist is decoration.**

That is not a criticism of the code, which says so itself — `resolve_trusted_jq`'s
`HONEST SCOPE` paragraph already records that GitHub-hosted runners grant
passwordless `sudo` and that `sudo cp /tmp/shim /usr/bin/jq` defeats any
directory allowlist. This pass **confirms that paragraph is correct** against
primary sources (§Q1), and confirms it is the operative fact:

| Layer | Status after this pass |
|---|---|
| Linux allowlist `{/usr/bin, /bin}` | **One directory, not two** — `/bin` is a symlink to `/usr/bin` on Ubuntu 24.04 (§Q2). Tightest possible list. |
| What it actually stops | Exactly one vector: a `$GITHUB_PATH`/`PATH` shim in a runner-writable directory. Confirmed real and confirmed closed (§Q1, §Q2). |
| What it does not stop | The same attacker, one word longer: `sudo cp shim /usr/bin/jq`. `sudo` is passwordless and **documented** (§Q1). |
| macOS allowlist | **Trusts a directory the attacker can write to WITHOUT sudo** (`/opt/homebrew/bin`, §Q3). Test-leg only, not the decision path — but the self-test's security property is weaker than the code's framing implies. Stated plainly, as instructed. |

**The one thing that would change my assessment** — a finding that `/usr/bin` is
runner-writable without privilege escalation on current `ubuntu-latest` — is
**not established by any primary source I could find** (§Q1b). It rests on
standard Ubuntu filesystem convention. I have not softened that into a CONFIRM.
It is a ~10-minute experiment (§E1) and it is the single highest-value one here,
because a REFUTE there would void the guard on the decision path entirely.

One observation outside the six questions is recorded in §"Adjacent finding"
because it bears on the same seam and no project record currently names it
correctly.

---

## Repository and platform state this document is grounded against

| Fact | Value | How verified (2026-08-10) |
|---|---|---|
| `develop` HEAD | `a5e1d087` | `git log --oneline -1` |
| Script under validation | `scripts/check-ci-gate.sh`, 1,420 lines | `wc -l` |
| Decision-path jobs | `ci-gate`, `spec-guard` — both `runs-on: ubuntu-latest` | given by brief; not re-derived |
| Self-test coverage | 17/17 jq-trust checks pass locally | `bash scripts/check-ci-gate.sh --self-test` |
| **Production run on `a5e1d087`** | run `31432422878`: `CI Gate` **success**, `Spec Guards` **success**, `Test (macos-latest)` **success** | `gh run view 31432422878 --json jobs` |
| `ubuntu-latest` → | Ubuntu 24.04 | GitHub Docs, runners reference |
| `macos-latest` → | macOS 26, arm64 | GitHub Docs, runners reference |

**The production run matters and is used as evidence twice below.** `CI Gate` and
`Spec Guards` succeeding on `a5e1d087` means `resolve_trusted_jq`'s **strict
branch actually accepted the real runner's real `jq` under `RUNNER_OS=Linux`** on
a live `ubuntu-latest` host. `Test (macos-latest)` succeeding means the same
under `RUNNER_OS=macOS` via the `#[cfg(unix)]` subprocess tests. That is not an
inference about where `jq` lives — it is the guard itself reporting that it found
`jq` in an allowlisted directory on both platforms.

---

## Q1 — Are `/usr/bin` and `/bin` writable by `runner` without sudo? Is `jq` at `/usr/bin/jq`?

**Label:** `NEWLY-RESEARCHED`.

**Verdict: split.**

- **Q1a — `jq` resolves to `/usr/bin/jq` on current `ubuntu-latest`: CONFIRM.**
- **Q1b — `/usr/bin` and `/bin` are NOT runner-writable without sudo:
  INCONCLUSIVE on primary sources.** High-confidence `INFERRED` from standard
  Ubuntu filesystem convention. Not softened. See §E1.
- **Q1c — the security conclusion: the allowlist is void against the modeled
  attacker anyway, because passwordless `sudo` is documented: CONFIRM.**

### Q1a — `jq` location

PRIMARY: `actions/runner-images`, `images/ubuntu/Ubuntu2404-Readme.md` at `main`,
https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md
(accessed 2026-08-10). `jq` appears in the **"Installed apt packages"** section,
verbatim:

> jq 1.7.1-3ubuntu0.24.04.2

It is an **apt package**, not a Homebrew or manually-installed binary. That
matters, because the install location is then a matter of Debian packaging
record, not of image-build scripting.

PRIMARY: Ubuntu package file list for `jq` on noble/amd64,
https://packages.ubuntu.com/noble/amd64/jq/filelist (accessed 2026-08-10). The
package installs, verbatim:

> /usr/bin/jq

**CONFIRM: `jq` is at `/usr/bin/jq` on `ubuntu-latest`.**

Corroborated behaviourally by production run `31432422878`: `CI Gate` and
`Spec Guards` both succeeded with `RUNNER_OS=Linux` strict mode engaged, which is
only possible if `command -v jq` resolved into `{/usr/bin, /bin}`.

**One fragility worth recording (not a security finding).** The Ubuntu 24.04
image also ships Homebrew at `/home/linuxbrew` — the readme notes it "requires
manual PATH configuration." `/home/linuxbrew/.linuxbrew/bin` is **not** in the
Linux allowlist. If a future image change, or an action such as `setup-*`, ever
puts a Homebrew `jq` ahead of `/usr/bin` on `PATH`, the gate **fails closed**
(exit 2, CI break) rather than open. That is the correct direction, and it is the
same class as the CI-BREAK-1 macOS incident the script's own comments record.

The default `ubuntu-24.04` `PATH` places `/usr/local/bin` **before** `/usr/bin`
(SECONDARY: https://github.com/actions/runner-images/issues/11414, accessed
2026-08-10, which shows an observed runner `PATH` of
`…:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:…`).
`/usr/local/bin` is **not** in the Linux allowlist. This is exactly the guard
working as designed: a shim dropped in the earlier-searched `/usr/local/bin`
wins `command -v` and is then **rejected** by directory membership.

### Q1b — writability

**No primary source states the ownership or mode bits of `/usr/bin` on the
GitHub-hosted Ubuntu image.** I looked for one in the runner-images readme, the
image build scripts, and GitHub's hosted-runners documentation, and there is
none. A targeted web-grounded search returned the same result: the standard
Ubuntu convention (`root:root`, `0755`) is asserted everywhere and documented for
the hosted image nowhere.

What *is* primary:

- The job user is `runner`, an unprivileged account (`/Users/runner/`-style paths
  in the image readmes; `RUNNER_USER=runner` in the observed environment above).
- `/usr/bin` under the Filesystem Hierarchy Standard and Debian policy is a
  system directory owned by `root`.

**`INFERRED`, high confidence: `/usr/bin` is `root:root 0755` and not writable by
`runner` without `sudo`.** I am labelling this rather than confirming it, because
the whole trust property of the merged code rests on this one bit and it deserves
a real measurement, not a convention argument. §E1 settles it in about ten
minutes.

`/bin` inherits the answer identically — it is the same directory (§Q2).

### Q1c — why Q1b's answer changes less than it looks like it should

PRIMARY: GitHub Docs, "GitHub-hosted runners",
https://docs.github.com/en/actions/reference/runners/github-hosted-runners
(accessed 2026-08-10), §"Administrative privileges", verbatim:

> The Linux and macOS virtual machines both run using passwordless `sudo`.

> Windows virtual machines are configured to run as administrators with User
> Account Control (UAC) disabled.

SECONDARY, corroborating the mechanism:
https://github.com/actions/runner-images/issues/10484 (accessed 2026-08-10)
shows the sudoers entry verbatim as `runner ALL=(root) NOPASSWD:ALL` in
`/etc/sudoers.d/runner`.

**The threat model the guard is written against is "arbitrary execution in an
earlier step of the same job."** That attacker has passwordless `sudo` by
platform design. So:

| Attack | Cost | Guard outcome |
|---|---|---|
| `$GITHUB_PATH` shim in `$RUNNER_TEMP/bin` | 1 line | **REJECTED** — dir not in allowlist |
| Shim in `/usr/local/bin` (earlier on `PATH`) | 1 line | **REJECTED** — dir not in allowlist |
| `sudo cp /tmp/shim /usr/bin/jq` | 1 line | **ACCEPTED** — the shim *is* the trusted path |

**CONFIRM: the directory allowlist raises the cost of forging the gate's decision
by one word (`sudo`), not by any meaningful margin.** `resolve_trusted_jq`'s
`HONEST SCOPE` paragraph states this correctly and must not be removed or
softened; this pass validates it against the primary source it cites.

**This is not an argument for deleting the guard.** It closes the cheaper,
likelier, and more plausibly-accidental vector (a `PATH` mutation by a
third-party action that never intended compromise), it fails closed, and it costs
nothing. It is an argument against the guard ever being described as preventing a
determined attacker from forging the decision — which the code already avoids
doing.

---

## Q2 — usrmerge: is `/bin` a symlink to `/usr/bin`?

**Label:** `NEWLY-RESEARCHED`.

**Verdict: CONFIRM.** And it has one consideration worth recording, which
**strengthens** rather than weakens the allowlist.

PRIMARY (Canonical documentation): "Usrmerge implementation", Rockcraft
documentation, https://documentation.ubuntu.com/rockcraft/1.19/explanation/usrmerge/
(accessed 2026-08-10), verbatim:

> the first long-term release with this behavior was Ubuntu 24.04 LTS

> `/bin` becoming a symbolic link to `/usr/bin`

PRIMARY (upstream definition): Debian Wiki, "UsrMerge",
https://wiki.debian.org/UsrMerge (accessed 2026-08-10), verbatim:

> the /{bin,sbin,lib}/ directories becoming symbolic links to /usr/{bin,sbin,lib}/

**`ubuntu-latest` is Ubuntu 24.04** (GitHub Docs, runners reference, accessed
2026-08-10 — the `ubuntu-latest` label links to the same image readme as
`ubuntu-24.04`). Therefore `/bin` is a symlink to `/usr/bin` on the decision-path
runner.

### The consideration, and why it cuts in the guard's favour

**The Linux allowlist is not two directories. It is one directory under two
names.** `/usr/bin` and `/bin` are the same inode; anything writable in one is
writable in the other, and `/usr/bin/jq` and `/bin/jq` are the same file. This has
three consequences:

1. **No equivalence gap exists.** A concern of the form "the attacker writes
   `/bin/jq` to dodge a `/usr/bin`-only check" is incoherent — they are the same
   write, and both spellings are allowlisted.
2. **No normalization is needed, and adding one would be a regression.**
   `is_trusted_jq_dir` is pure string comparison against
   `${resolved%/*}`. Resolving symlinks (`realpath`, `readlink -f`) would
   reintroduce an external-binary dependency on the decision path — precisely
   what `736fea28` removed — to solve a problem that does not exist. **Do not
   add path canonicalization here.**
3. **`command -v` returns whichever `PATH` spelling matched**, unresolved. Since
   the observed runner `PATH` lists `/usr/bin` before `/bin`, the resolved value
   is `/usr/bin/jq` in practice; the `/bin` entry is defensive redundancy that
   costs nothing and covers a `PATH` reordering. Keeping it is correct.

**Net: the Linux allowlist is the tightest list expressible — a single physical
directory — and the `/bin` entry is free insurance.** `RECORDED` note for the
next reviewer: the two entries are not independent, so "we trust two directories"
overstates the surface. It is one.

**Fragility, not a vulnerability.** If a `PATH` entry ever carried a trailing
slash (`/usr/bin/`), `command -v` would yield `/usr/bin//jq` and `${resolved%/*}`
would yield `/usr/bin/`, which is not string-equal to `/usr/bin` → **fail
closed** (CI break, not a false green). The runner's real `PATH` has no trailing
slashes. Worth knowing if the gate ever hard-fails with a confusing message.

---

## Q3 — The macOS allowlist: where does `jq` resolve, and is `/opt/homebrew/bin` runner-writable?

**Label:** `NEWLY-RESEARCHED`.

**Verdict: split.**

- **Q3a — `jq` resolves to `/opt/homebrew/bin/jq` on current `macos-latest`
  (macOS 26, arm64): CONFIRM.**
- **Q3b — `/opt/homebrew/bin` is writable by `runner` WITHOUT sudo:
  INCONCLUSIVE on primary sources, but the inference chain is strong and
  every link in it is primary.** `INFERRED`, high confidence. The prior research
  in this series that indicated this **holds up**. See §E2.
- **Q3c — consequence: yes, the macOS allowlist trusts a directory the attacker
  can write to unprivileged. Stated plainly, as instructed.**

### Q3a — location

PRIMARY: `actions/runner-images`, `images/macos/macos-26-arm64-Readme.md` at
`main`,
https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md
(accessed 2026-08-10). OS version `macOS 26.5.2 (25F84)`, arm64. `jq` listed
verbatim as:

> jq 1.8.2

PRIMARY: `actions/runner-images`,
`images/macos/scripts/build/install-homebrew.sh` at `main`,
https://github.com/actions/runner-images/blob/main/images/macos/scripts/build/install-homebrew.sh
(accessed 2026-08-10). `jq` is installed **via Homebrew**, verbatim:

> brew_smart_install jq

and the script contains **no `sudo` invocations at all** — it installs as the
current (image-build) user.

PRIMARY: GitHub Docs, runners reference (accessed 2026-08-10) confirms
`macos-latest` is arm64. Homebrew's supported Apple Silicon prefix is
`/opt/homebrew` (https://docs.brew.sh/Installation, accessed 2026-08-10:
"Homebrew to its default, supported, best prefix (`/opt/homebrew` for Apple
Silicon"). **Therefore `jq` is at `/opt/homebrew/bin/jq`.**

Corroborated behaviourally by production run `31432422878`: `Test (macos-latest)`
succeeded, which requires the `#[cfg(unix)]` subprocess tests' `evaluate_needs()`
calls to have accepted the runner's real `jq` under inherited `RUNNER_OS=macOS`.
`/opt/homebrew/bin` is the only allowlist member that can explain that on an
arm64 image.

This also confirms the `/usr/local/bin` entry is **dead weight on current
images** — it was correct for Intel macOS runners and is retained for
compatibility. Harmless, and the script's CI-BREAK-1 comment already explains
why it is there.

### Q3b — writability

**No primary source states `/opt/homebrew`'s ownership on the GitHub-hosted macOS
image.** But every link in the chain below is primary, which is a materially
better position than Q1b:

1. PRIMARY — Homebrew installer, https://github.com/Homebrew/install/blob/master/install.sh
   (accessed 2026-08-10): the prefix is chowned to the installing user, with
   group `admin` on macOS —
   `execute_sudo "${CHOWN[@]}" "${USER}:${GROUP}" "${HOMEBREW_REPOSITORY}"`,
   with `GROUP=admin` on macOS.
2. PRIMARY — https://docs.brew.sh/Installation (accessed 2026-08-10):
   "you don't need _sudo_ after Homebrew's initial installation". Homebrew's
   entire design premise is a **user-writable prefix**.
3. PRIMARY — `install-homebrew.sh` (above) installs formulae **without `sudo`**.
   This is only possible if the prefix is writable by the invoking user.
4. PRIMARY — the macOS image readmes use `/Users/runner/` paths throughout: the
   image-build user is `runner`, the same account jobs run as.

**`INFERRED`, high confidence: `/opt/homebrew` and `/opt/homebrew/bin` are owned
by `runner` (group `admin`) and writable without `sudo`.** A secondary
observation of `drwxr-xr-x … runner admin` on `/opt/homebrew` was found and is
consistent, but is not load-bearing here — the four primary links above are.

`/usr/local/bin` on macOS is conventionally `root:wheel`-owned but has
historically been group-writable on Homebrew-Intel systems for the same reason;
this pass did **not** establish its permissions on the current image, and does
not need to, since it is unreachable on arm64.

### Q3c — what this means, plainly

**The macOS allowlist trusts a directory the attacker can write to without
privilege escalation.** On a `macos-latest` job, an earlier step can run

```
cp /tmp/shim /opt/homebrew/bin/jq
```

with no `sudo`, and `resolve_trusted_jq` accepts it: the path is absolute,
executable, and its directory is an allowlist member. **On that leg the directory
allowlist provides no security value** — it rejects a shim placed *elsewhere*
while accepting one placed in the obvious place.

**Scope, stated precisely so this is not over-read:**

- This is **not** the decision path. `ci-gate` and `spec-guard` are both
  `ubuntu-latest`; the macOS entries are reached only by the `test` job's
  `macos-latest` leg via `#[cfg(unix)]` subprocess tests.
- The consequence is that **the self-test's own security property is weaker than
  the code's framing implies** — which is exactly what the brief anticipated, and
  it is true. The self-test check `macos-opt-homebrew-bin-trusted` asserts a
  runner-writable directory is *trusted*. Read as a compatibility assertion (its
  actual purpose, per the CI-BREAK-1 comment) that is correct. Read as a security
  assertion it is inverted.
- **This does not warrant removing the entry.** Removing `/opt/homebrew/bin`
  reproduces CI-BREAK-1 verbatim — the exact production break the entry was added
  to fix. The correct action is a comment, not a code change (§Recommendation 3).

---

## Q4 — Can `RUNNER_OS` be UNSET, not merely overwritten?

**Label:** `NEWLY-RESEARCHED`. This is the question with the highest chance of a
REFUTE, because the strict branch is gated on `[ -n "${RUNNER_OS}" ]` and prior
research only established resistance to *overwriting*.

**Verdict: CONFIRM — `RUNNER_OS` cannot be unset or emptied for a later `run:`
step by any in-job mechanism.** The mechanism is stronger and more general than
the "regeneration overwrites it back" argument the script's comment records.

### The decisive source: `run:` step environment assembly order

PRIMARY (source): `actions/runner`,
`src/Runner.Worker/Handlers/ScriptHandler.cs` at `main`,
https://github.com/actions/runner/blob/main/src/Runner.Worker/Handlers/ScriptHandler.cs
(accessed 2026-08-10). A `run:` step's process environment is assembled in this
order — the handler receives `Environment` **already populated** with the global
environment (where `$GITHUB_ENV` writes accumulate) and the step's own `env:`,
and then applies:

1. `AddPrependPathToEnvironment();` — the `$GITHUB_PATH` mechanism.
2. **Runtime contexts, written last, unconditionally:**

```csharp
foreach (var context in ExecutionContext.ExpressionValues)
{
    if (context.Value is IEnvironmentContextData runtimeContext && runtimeContext != null)
    {
        foreach (var env in runtimeContext.GetRuntimeEnvironmentVariables())
        {
            Environment[env.Key] = env.Value;
        }
    }
}
```

PRIMARY (source): `actions/runner`, `src/Runner.Worker/RunnerContext.cs` at
`main`,
https://github.com/actions/runner/blob/main/src/Runner.Worker/RunnerContext.cs
(accessed 2026-08-10):

```csharp
foreach (var data in this)
{
    yield return new KeyValuePair<string, string>(
        $"RUNNER_{data.Key.ToUpperInvariant()}",
        data.Value as StringContextData);
}
```

**Three properties follow, and the first two are read directly off the source:**

1. **`Environment[env.Key] = env.Value` is an unconditional assignment, applied
   LAST.** It is not `TryAdd`, not a null-guard, not conditional on absence.
   Whatever `RUNNER_OS` was in the inherited environment — set by an earlier
   step's `$GITHUB_ENV` write, emptied by one, or declared in a workflow/job/step
   `env:` block — is **overwritten** by the runner's own value immediately before
   the process is launched.
2. **There is no conditional that would skip a key.** `GetRuntimeEnvironmentVariables`
   emits one `RUNNER_<KEY>` for every entry in the context, with no allowlist,
   denylist, or emptiness filter.
3. **`INFERRED`: the `os` key is always present in `RunnerContext`.** This pass
   did not locate the population site. GitHub Docs, "Variables reference"
   (accessed 2026-08-10), lists `RUNNER_OS` as a default environment variable
   "available to every step in a workflow", which is the documentation-level
   statement of the same thing. Combined with property 2, `RUNNER_OS` is set to
   the true value in every `run:` step.

### Answering the brief's exact sub-questions

- **`echo "RUNNER_OS=" >> $GITHUB_ENV` — does an empty-string write survive to
  the next step?** **No.** The write lands in the global environment, which is
  applied *before* the runtime context; step 2 above overwrites it. `CONFIRM`.
- **`unset RUNNER_OS`** — a shell `unset` affects only the shell it runs in.
  There is no cross-step mechanism to unset an environment variable; `$GITHUB_ENV`
  only sets. The gate step's own shell could `unset RUNNER_OS`, but the gate
  step's `run:` line is byte-pinned (M2-i) and its `env:` key set is pinned
  (M2-o). `CONFIRM`.
- **Does the "regeneration" argument the script's comment cites hold?** Yes, and
  this pass **upgrades it**: the script's comment attributes the protection to
  `RunnerContext` regeneration having "no allowlist gap." The source shows a
  simpler and more robust reason — **ordering**. The runtime context is written
  last into the step's environment dictionary. That defeats *every* in-job
  mechanism at once (`$GITHUB_ENV`, workflow `env:`, job `env:`, step `env:`),
  not just the one the comment names. The choice of `RUNNER_OS` over
  `GITHUB_ACTIONS` as the strict-mode trigger is **correct**, and correct for a
  better reason than recorded.

### Caveat, carried forward from pass 2

Pass 2 established that `actions/runner`'s public source is **not** an oracle for
server-side workflow *parsing* (it rejects anchors that production has accepted
since 2025-09-18). **That caveat does not apply here.** Step execution and
environment assembly happen *on the runner* — this is the code that actually
runs. This is the same distinction pass 2's Q-F(2) relied on, and it is the
authoritative layer for this question.

**Residual:** the deployed runner version may differ from `main`. The behaviour is
stable across the runner's history and is not a recently-changed area, so I am
recording this as CONFIRM rather than INCONCLUSIVE — but §E3 settles it directly
if you want zero inference.

---

## Q5 — Exact `RUNNER_OS` values and the `*)` fail-closed arm

**Label:** `NEWLY-RESEARCHED` (values) + `NEWLY-RESEARCHED` (behaviour,
established empirically).

**Verdict: CONFIRM on both halves.**

### The value domain

PRIMARY: GitHub Docs, "Variables reference",
https://docs.github.com/en/actions/reference/workflows-and-actions/variables
(accessed 2026-08-10), verbatim:

> The operating system of the runner executing the job. Possible values are
> `Linux`, `Windows`, or `macOS`.

**Exact casing: `Linux`, `Windows`, `macOS`.** Note `macOS` — lowercase `m`,
capital `OS`. `trusted_jq_dirs_for`'s `macOS)` arm matches byte-for-byte. There
is no `Darwin`, no `MacOS`, no `mac-os`. The `Windows` arm is deliberately
unpopulated (documented in the function's comment) and therefore falls through to
the same fail-closed outcome as an unmodeled value — correct, since no
`windows-latest` job invokes this script today.

The same page also states, verbatim:

> You can't overwrite the value of the default environment variables named
> `GITHUB_*` and `RUNNER_*`. Currently you can overwrite the value of the `CI`
> variable.

**Do not lean on this sentence.** The script's own comment already records that
docs and source disagree here — `FileCommandManager.cs`'s `$GITHUB_ENV` write
blocklist is verbatim `{ "NODE_OPTIONS" }`, with no `GITHUB_*`/`RUNNER_*` prefix
filter. **That tension is resolved by Q4, not by this sentence**: the docs'
claim is *true in effect* for `run:` steps, but the enforcement is the
write-ordering in `ScriptHandler.cs`, not a write-time blocklist. Cite Q4's
source, not this sentence.

### The `*)` arm — fail-closed confirmed behaviourally

The brief asked for this to be confirmed as **actual behaviour** rather than
assumed. It is, and the confirmation is direct rather than by reading:

`bash scripts/check-ci-gate.sh --self-test` (run locally, 2026-08-10) reports
**17/17 checks pass**, including:

```
[PASS] unmodeled-os-rejects-every-dir (expected=untrusted, actual=untrusted)
[PASS] strict-mode-triggers-on-runner-os-alone (expected=fail:2, actual=fail:2)
[PASS] linux-rejects-macos-only-homebrew-dir (expected=untrusted, actual=untrusted)
[PASS] linux-rejects-arbitrary-writable-dir (expected=untrusted, actual=untrusted)
[PASS] reject-path-prepend-shim-in-untrusted-dir (expected=fail:2, actual=fail:2)
[PASS] reject-dirname-shim-lying-about-trusted-dir (expected=fail:2, actual=fail:2)
[PASS] reject-relative-path-jq-regardless-of-mode (expected=fail:2, actual=fail:2)
```

**CONFIRM: an unmodeled `RUNNER_OS` yields an empty allowlist, `is_trusted_jq_dir`
returns non-zero for every candidate directory, and `resolve_trusted_jq` fails
with exit 2.** This is the actual code path executing, not an inference from
reading the `case` statement. The mechanism: `trusted_jq_dirs_for`'s `*)` arm
prints nothing; `is_trusted_jq_dir`'s `while read` loop body never executes;
control reaches `return 1`.

Note that `linux-rejects-macos-only-homebrew-dir` also confirms the two OS
allowlists do not leak into each other — a `RUNNER_OS=Linux` job cannot be
tricked into trusting `/opt/homebrew/bin`, which is what keeps Q3's weakness
confined to the macOS test leg and off the decision path.

---

## Q6 — `json="$(</dev/stdin)"`: genuine builtin, and reliable over a pipe?

**Label:** `NEWLY-RESEARCHED`, established **empirically and decisively**.

**Verdict: CONFIRM on every sub-question. No failure mode found where it differs
from `cat` in a way that matters.**

**Method note.** This is the one place I deviate from pass 2's primary-sources-only
method, deliberately: Q6 is a question about `bash`, not about GitHub, and `bash`
is available here. Local execution is therefore **primary evidence for this
question**, not a substitute for it. All results below are from actual runs on
2026-08-10 against bash **3.2.57** (`/bin/bash`) and bash **5.3.9**
(`/opt/homebrew/bin/bash`). `ubuntu-24.04` ships bash 5.2.x, bracketed by these
two.

### Is it a genuine builtin redirect with no external binary?

PRIMARY (documentation): GNU Bash reference manual, "Command Substitution",
https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html
(accessed 2026-08-10), verbatim:

> The command substitution `$(cat file)` can be replaced by the equivalent but
> faster `$(< file)`.

and, on command substitution generally:

> Bash performs the expansion by executing command … and replacing the command
> substitution with the standard output of the command, with any trailing
> newlines deleted.

**PRIMARY (execution) — the decisive control.** The manual says "faster"; it does
not say "invokes no external binary," which is the property the code actually
needs. So I tested that property directly, with `PATH` pointed at a nonexistent
directory and a scrubbed environment:

```
$ printf 'needsjson-here\n' | env -i bash -c 'PATH=/nonexistent; j="$(</dev/stdin)"; printf "rc=%s val=[%s]\n" "$?" "$j"'
rc=0 val=[needsjson-here]

$ printf 'needsjson-here\n' | env -i bash -c 'PATH=/nonexistent; j="$(cat /dev/stdin)"; printf "rc=%s val=[%s]\n" "$?" "$j"'
bash: line 1: cat: command not found
rc=127 val=[]
```

Identical result on bash 3.2.57 and 5.3.9. **CONFIRM: `$(</dev/stdin)` reads
successfully with no executable reachable on `PATH` at all, while `$(cat …)`
fails with 127 under the same conditions.** No external binary is involved — this
is a proof, not an inference, and it is exactly the property the removal of
external binaries from the decision path was meant to achieve.

### Does `/dev/stdin` behave reliably when stdin is a pipe?

The gate invokes `echo "${NEEDS_JSON}" | bash scripts/check-ci-gate.sh`. Tested
in that exact shape:

```
$ NEEDS_JSON='{"fmt":{"result":"success"},"deny":{"result":"skipped"}}'
$ echo "${NEEDS_JSON}" | bash /tmp/gatetest.sh
read 56 bytes: {"fmt":{"result":"success"},"deny":{"result":"skipped"}}
```

**CONFIRM.** Works on both bash versions.

### Failure modes probed, and what each showed

| Condition | `$(</dev/stdin)` | `$(cat /dev/stdin)` | Differs? |
|---|---|---|---|
| Empty input, `set -euo pipefail` | `rc=0`, `len=0`, script continues | same | **No** |
| Non-empty, `set -euo pipefail` | `rc=0`, value correct, continues | same | **No** |
| Large input (2 MB / 4 MB) | full length read, no truncation | same | **No** |
| Trailing newlines (`\n\n\n`) | stripped (documented) | stripped | **No** |
| Embedded newlines | **retained** | retained | **No** |
| NUL byte in input | warns `ignored null byte in input`, drops the byte | identical warning, identical result | **No** |
| stdin closed (`0<&-`) | blocks | blocks | **No** |

**The `set -e` / `set -o pipefail` interaction the brief asked about is a
non-issue.** Empty input yields `rc=0`, not a failure — so `set -e` does not
abort, and `pipefail` has nothing to fail on. This matters because a gate that
aborted on empty input would be fail-*closed* in a confusing way; instead it
proceeds with an empty `json`, which downstream `jq` parsing then rejects on its
own terms.

**Two behaviours worth recording, neither a defect:**

1. **Trailing-newline stripping is documented and intentional** — the manual
   sentence quoted above. `echo` appends a newline; `$(<…)` removes it. The two
   cancel. This is why the round-trip is byte-exact for the JSON payload.
2. **NUL bytes are silently dropped with a warning on stderr** by *both* forms.
   `toJSON(needs)` cannot produce a NUL, so this is unreachable on the decision
   path. Recorded because a future reviewer testing adversarial payloads will
   hit it and should know it is not specific to `$(<…)`.

The self-test additionally covers the relevant adversarial case behaviourally:

```
[PASS] reject-cat-shim-for-main-stdin-read (real stdin honored despite $PATH cat shim)
```

**CONFIRM: `$(</dev/stdin)` is immune to a `PATH`-based `cat` shim by
construction**, which is the security property that motivated the change from
`cat`. This is the one place in the merged shell delta where the trust property
holds unconditionally — it depends on no filesystem permission, no `sudo`
boundary, and no GitHub behaviour.

---

## Adjacent finding — outside the six questions, recorded because no project record names it correctly

**Label:** `INFERRED`. **Not a REFUTE, and not a new exposure** — it is the same
modeled attacker with the same capability. Recorded for accuracy of the record
only.

`resolve_trusted_jq`'s comment states:

> CLAUDE.md's round-13 IMPORTANT-2 note previously described this exposure as
> `$GITHUB_ENV` -> `BASH_ENV` (an environment-variable model); the actual
> channel is `PATH` -> WHICH BINARY RUNS, a different mechanism…

**"The actual channel" reads as though `BASH_ENV` were superseded. It is not —
both channels are live and independent.** `CLAUDE.md`'s round-12 CRITICAL closed
`BASH_ENV` by pinning the gate step's `env:` key set (M2-o) and the workflow's
top-level `env:` key set. Those pins read **`ci.yml`**. They do not, and cannot,
see a `BASH_ENV` value written by an earlier step via `$GITHUB_ENV`, which
reaches the gate step's process environment through the global-environment path
in `ScriptHandler.cs` (§Q4) without appearing in any YAML.

`INFERRED` consequence: an earlier step writing `BASH_ENV=/tmp/shim.sh` to
`$GITHUB_ENV` would have that file sourced by `bash scripts/check-ci-gate.sh`.
A shim ending in `exit 0` ends the shell before the gate runs.

**Why this is not an emergency:** (a) it requires the same arbitrary-execution
capability that already yields `sudo cp /tmp/shim /usr/bin/jq`, so it adds
nothing to the attacker's reach; (b) `resolve_trusted_jq`'s absolute-path check
independently rejects the narrower variant where the shim defines a `jq` **shell
function** — `command -v jq` returns the bare string `jq`, which is not absolute
(self-test: `reject-relative-path-jq-regardless-of-mode`). **Not independently
verified against a live runner by this pass.** The fix is a one-sentence comment
correction, not code (§Recommendation 4).

---

## Verdict summary

| # | Question | Label | Verdict (2026-08-10) | Confidence |
|---|---|---|---|---|
| Q1a | `jq` at `/usr/bin/jq` on `ubuntu-latest` | NEWLY-RESEARCHED | **CONFIRM** — apt package `jq 1.7.1-3ubuntu0.24.04.2`; Ubuntu filelist gives `/usr/bin/jq`; corroborated by live green `CI Gate` on `a5e1d087` | HIGH |
| Q1b | `/usr/bin`, `/bin` NOT runner-writable without sudo | INFERRED | **INCONCLUSIVE on primary sources** — no primary source states mode bits for the hosted image; rests on standard Ubuntu convention. **Not softened.** §E1 settles it | MEDIUM-HIGH on the inference; LOW on documentation |
| Q1c | Passwordless `sudo` voids the allowlist anyway | NEWLY-RESEARCHED | **CONFIRM** — GitHub Docs verbatim: "The Linux and macOS virtual machines both run using passwordless `sudo`." The guard stops a no-sudo `PATH` shim and nothing else | HIGH |
| Q2 | `/bin` is a symlink to `/usr/bin` | NEWLY-RESEARCHED | **CONFIRM** — Canonical docs: Ubuntu 24.04 LTS is the first LTS with usrmerge; `/bin` → `/usr/bin`. Consideration: the Linux allowlist is **one directory under two names**, which *strengthens* it. Do NOT add path canonicalization | HIGH |
| Q3a | `jq` at `/opt/homebrew/bin/jq` on `macos-latest` | NEWLY-RESEARCHED | **CONFIRM** — macOS 26 arm64, `jq 1.8.2` installed by `brew_smart_install jq`; corroborated by live green `Test (macos-latest)`. `/usr/local/bin` entry is dead weight on arm64 but harmless | HIGH |
| Q3b | `/opt/homebrew/bin` runner-writable without sudo | INFERRED | **INCONCLUSIVE on primary sources** — but all four links (Homebrew chowns prefix to `$USER:admin`; brew needs no sudo post-install; runner-images installs brew without sudo; build user is `runner`) are primary. Prior research in this series **holds up** | HIGH on the inference |
| Q3c | macOS allowlist trusts an attacker-writable dir | INFERRED | **CONFIRM, stated plainly** — on the `macos-latest` test leg the allowlist has essentially no security value. **Test-leg only, not the decision path.** Entry must NOT be removed (reproduces CI-BREAK-1) | HIGH |
| Q4 | Can `RUNNER_OS` be UNSET, not just overwritten? | NEWLY-RESEARCHED | **CONFIRM — no.** `ScriptHandler.cs` writes runtime contexts LAST via unconditional `Environment[env.Key] = env.Value`, after global env (`$GITHUB_ENV`) and step `env:`. Defeats every in-job mechanism at once — a **stronger and more general** reason than the script's comment records | HIGH |
| Q5 | Exact `RUNNER_OS` values; `*)` fail-closed | NEWLY-RESEARCHED | **CONFIRM both** — docs verbatim `Linux` / `Windows` / `macOS` (note casing, matches the `case` arms byte-for-byte). Fail-closed confirmed **behaviourally**, not assumed: `--self-test` 17/17 incl. `unmodeled-os-rejects-every-dir` | HIGH |
| Q6 | `$(</dev/stdin)` builtin, fork-free, pipe-safe | NEWLY-RESEARCHED | **CONFIRM** — reads successfully with `PATH=/nonexistent` while `$(cat …)` fails 127; identical on bash 3.2.57 and 5.3.9; no divergence from `cat` on empty / 4 MB / NUL / `set -euo pipefail` / closed-stdin. Immune to a `PATH` `cat` shim by construction | HIGH |

**Zero REFUTE. Two INCONCLUSIVE-on-primary sub-claims (Q1b, Q3b), both labelled
`INFERRED` rather than promoted.**

---

## Which questions can only be settled empirically, and the exact minimal experiment

Two, both cheap. Each is a throwaway workflow in a scratch repository; neither
touches this repository's `ci.yml`.

**E1 — `/usr/bin` writability on `ubuntu-latest` (settles Q1b). Highest value.**
This is the single measurement that could change the assessment on the **decision
path**.

```yaml
runs-on: ubuntu-latest
steps:
  - run: |
      id
      stat -c '%U %G %a %n' /usr/bin /bin /usr/local/bin
      readlink -f /bin
      command -v jq && stat -c '%U %G %a %n' "$(command -v jq)"
      # the actual question — must FAIL:
      touch /usr/bin/__probe && echo "WRITABLE-NO-SUDO" || echo "not writable (expected)"
      sudo -n true && echo "passwordless sudo available"
```

~10 minutes. A `WRITABLE-NO-SUDO` result is a **REFUTE of Q1b** and voids the
guard on the decision path — report immediately.

**E2 — `/opt/homebrew/bin` writability on `macos-latest` (settles Q3b).**

```yaml
runs-on: macos-latest
steps:
  - run: |
      id
      stat -f '%Su %Sg %Sp %N' /opt/homebrew /opt/homebrew/bin /usr/local/bin
      command -v jq
      touch /opt/homebrew/bin/__probe && echo "WRITABLE-NO-SUDO (expected)" || echo "not writable"
```

~10 minutes. `WRITABLE-NO-SUDO` **confirms** Q3b as expected; it is not a
surprise and not an emergency, but it converts §Q3c from `INFERRED` to measured.

**E1 and E2 can share one workflow file with two jobs.**

**Not requiring an experiment**, and deliberately so:

- **Q6** was settled by local execution, which is primary evidence for a question
  about `bash`.
- **Q5**'s fail-closed behaviour was settled by running the self-test, which
  exercises the real code path.
- **Q4** is settled on runner source, which is the authoritative layer for step
  execution (unlike workflow parsing — see pass 2's caveat). §E3, below, is
  optional belt-and-braces: a job whose step 1 runs
  `echo "RUNNER_OS=" >> "$GITHUB_ENV"` and whose step 2 runs
  `echo "[${RUNNER_OS}]"`, expecting `[Linux]`. ~5 minutes if you want zero
  inference.

---

## Recommendations

1. **Run E1.** It is ten minutes and it is the only open question that bears on
   the decision path. Everything else in this document can wait; this cannot,
   because a REFUTE there means the merged guard does nothing at all on
   `ubuntu-latest`.
2. **Do not add path canonicalization to `is_trusted_jq_dir`** (§Q2). `/bin` and
   `/usr/bin` are the same directory, so there is no equivalence gap to close,
   and `realpath`/`readlink` would reintroduce an external-binary dependency on
   the decision path — undoing the point of `736fea28`. Add a one-line comment in
   `trusted_jq_dirs_for` recording that the two Linux entries denote one physical
   directory (usrmerge), so a future reader does not mistake the list for two
   independent trust grants.
3. **Add one sentence to the macOS branch of `trusted_jq_dirs_for`** recording
   §Q3c plainly: `/opt/homebrew/bin` is owned by `runner` and writable without
   `sudo`, so on the macOS test leg these entries are a **compatibility**
   assertion (CI-BREAK-1), not a security one. **Do not remove the entry** —
   that reproduces the production break it exists to fix. The self-test check
   `macos-opt-homebrew-bin-trusted` should carry the same note, since read as a
   security assertion it is inverted.
4. **Correct `resolve_trusted_jq`'s "the actual channel is `PATH`" sentence**
   (§Adjacent finding). Both `$GITHUB_ENV`→`BASH_ENV` and `$GITHUB_PATH`→`PATH`
   are live and independent; the YAML `env:`-key pins close the former only for
   values declared *in `ci.yml`*, not for values written at runtime via
   `$GITHUB_ENV`. Change "the actual channel is" to "a second, independent
   channel is". One word of accuracy on a comment that is otherwise the best
   documentation in the file.
5. **Upgrade the `RUNNER_OS` justification comment** (§Q4). The comment credits
   "regeneration with no allowlist gap"; the source shows the real mechanism is
   **write ordering** in `ScriptHandler.cs` — runtime contexts applied last,
   unconditionally, after global and step env. That is a stronger property (it
   defeats `$GITHUB_ENV`, workflow `env:`, job `env:`, and step `env:`
   simultaneously) and it deserves the better citation:
   `actions/runner :: src/Runner.Worker/Handlers/ScriptHandler.cs`.
6. **Do not cite the "Variables reference" `GITHUB_*`/`RUNNER_*` non-overwrite
   sentence as the reason `RUNNER_OS` is trustworthy** (§Q5). The script's own
   comment correctly notes docs and source disagree on the write-blocklist. Q4
   resolves the tension: the docs' claim is true in effect, but for a reason the
   docs do not give. Cite Q4's source.
7. **Record in `CLAUDE.md` that the `ci-gate` binary-trust layer's security
   property is bounded by passwordless `sudo`** (§Q1c), in the same paragraph
   that records the knowingly-unpinned `uses:` values on the decision path. The
   two residuals are the same residual: whatever runs before the gate step in the
   `ci-gate` job can forge the decision, and no in-script check can prevent it.
   `resolve_trusted_jq`'s `HONEST SCOPE` paragraph says this; `CLAUDE.md` does
   not.

---

## Research methods

| Tool | Calls | Purpose |
|---|---|---|
| WebFetch | 14 | GitHub docs, `actions/runner` + `actions/runner-images` source at `main`, Ubuntu/Canonical/Debian package + docs pages, Homebrew installer, GNU Bash manual |
| WebSearch | 6 | Locating primary pages and the relevant runner-images issues |
| Perplexity (`ask`) | 3 | Locating primary sources for runner user/UID, `/opt/homebrew` ownership, runner `PATH`; **used only to find sources, never cited as one** |
| Bash (local, empirical) | 5 | `$(</dev/stdin)` semantics on bash 3.2.57 + 5.3.9 incl. the `PATH=/nonexistent` control; `--self-test` execution |
| `gh` (production data) | 2 | Run `31432422878` job outcomes on `a5e1d087` |
| Training data | 0 assertions | Every factual claim carries a URL and a 2026-08-10 access date, or is a reproducible local command shown inline |

**Not done, and not claimed:** nothing in this document was executed against live
GitHub Actions infrastructure by this pass. Q1b and Q3b are INCONCLUSIVE for
exactly that reason and each has a specified experiment rather than an inferred
answer. The one production datapoint used (run `31432422878`) is an *existing*
CI run read after the fact, not an experiment this pass conducted.

**Reading hazard carried forward from passes 1 and 2:**
`.factory/cycles/cycle-001/burst-log.md` contains bytes that make plain `grep`
treat it as binary and return **silent false negatives**. Always use `grep -a`.
