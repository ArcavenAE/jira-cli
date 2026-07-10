# PR #573 Review — `docs(readme): document mise install path`

**Verdict: REQUEST_CHANGES**

The section is a genuinely useful addition and structurally fits the README, but two claims are inaccurate as written and one presentation choice is inconsistent with the rest of the file. All fixable with copy edits — no code / workflow impact.

Author: external contributor (arcaven). Review was performed against the diff, the current `README.md`, `.github/workflows/release.yml`, `gh release list/view` output for `Zious11/jira-cli`, and mise's primary documentation. No commands from the diff were executed.

Per operator instruction on this task, this review is NOT posted to GitHub — it is captured here for the human reviewer to relay if they choose.

---

## Findings

### 1. [MAJOR] "SLSA provenance" + "once per-release attestations are published" is overclaiming and forward-looking

> mise's `github:` backend … (once per-release attestations are published) natively verifies GitHub Artifact Attestations and SLSA provenance in Rust without invoking `gh` or `slsa-verifier`.

Two problems, verified against mise's primary docs:

- **"SLSA provenance"** — mise's default automatic verification path for a plain `github:owner/repo` install is **GitHub Artifact Attestations** (via the internal `jdx/sigstore-verification` Rust crate). SLSA-provenance verification exists in mise only as a tool-plugin metadata field (`slsa_provenance_path` in `mise.jdx.dev/tool-plugin-development.html`) that a plugin author explicitly declares — it does not run automatically for `github:Zious11/jira-cli`. This is overclaiming.
- **"once per-release attestations are published"** — mise's attestation verification is already shipping (regression-tracked in `jdx/mise` discussion #7577 as far back as v2025.12.12). The parenthetical reads like the mise-side support is pending; it's not. What IS pending is this repo publishing attestations (that's the scope of PR #574, not merged). The sentence conflates the two sides of the pipeline.

In this repo TODAY, no attestations are published (`gh api repos/Zious11/jira-cli/attestations/sha256:test` → 404). Merging the sentence as written implies to a reader that mise + this repo already provide a chain-of-trust story. They don't.

Suggested rewrite (or drop the paragraph until #574 lands):

> mise's `github:` backend auto-selects the release asset matching your OS and architecture and extracts the `jr` binary. When a release ships GitHub Artifact Attestations (planned — see #574), mise natively verifies them in Rust without invoking `gh` or `slsa-verifier`.

### 2. [MAJOR] `<owner>` placeholder is inconsistent with the rest of the README and leaves the canonical example unrunnable

The existing Install section uses concrete strings:
- `curl … Zious11/jira-cli/main/install.sh …`
- `git clone https://github.com/Zious11/jira-cli.git`
- `brew install zious11/tap/jr` (Coming soon)

The new section uses `<owner>` in the fenced code blocks and then explains, in prose only, that "for the canonical upstream that's this repository's owner" — but never names the owner. A user copy-pasting the mise command hits a literal `<owner>` and has to backtrack to the curl URL a few lines up to guess the intended value.

Suggested: mirror the surrounding convention. Make the code block runnable against the canonical upstream, and add a single follow-up sentence for forks:

```bash
mise use github:Zious11/jira-cli@latest
```

> Replace `Zious11` with a fork's owner if you install from a downstream distribution.

### 3. [MINOR] Prerelease tag glob overreaches this repo's actual channels

> To track prerelease builds cut from `develop` (`v*-dev.*`, `v*-beta.*`, `v*-rc.*`) …

`gh release list` shows only `-dev.N` prereleases (`v0.5.0-dev.*`, `v0.6.0-dev.*`) and stable `v0.5.0`. No `-beta.*` or `-rc.*` tag has ever been cut. Not misleading enough to be a blocker — the shape *is* what mise's `prerelease` flag would opt into — but the enumeration falsely implies this repo has a documented beta/RC channel. Either narrow to `v*-dev.*` (what actually exists) or add a hedge ("if ever cut").

### 4. [MINOR] Silent Windows-on-`@latest` gotcha

v0.5.0 (the current `latest` stable) shipped **without** a Windows asset — Windows support (`x86_64-pc-windows-msvc`) was added later and appears only in the `v0.6.0-dev.*` prereleases. A Windows user running the recommended default command:

```bash
mise use github:Zious11/jira-cli@latest
```

will resolve to v0.5.0 and get an "no matching asset" failure from mise's backend, because `prerelease = true` is required to reach the version that actually has a Windows zip. Worth one line of text ("Windows users currently need `prerelease = true` — the first stable Windows build lands with v0.6.0"), or the section could omit Windows advice entirely until v0.6.0 is out.

### 5. [MINOR] "extracts the `jr` binary onto your `PATH`" is imprecise

mise installs into `~/.local/share/mise/installs/…` and exposes the binary via shims in a mise-managed directory that the user's shell must have activated (`mise activate`). "Onto your `PATH`" is a plausible simplification for a README, but readers who don't already have `mise activate` in their shell profile will be surprised. A single link to mise's own "Getting Started" or a "(assumes `mise activate` in your shell profile)" parenthetical would prevent the class of "I installed it but `jr` isn't found" reports.

### 6. [NIT] `mise which jr` fragility in the xattr line

```bash
xattr -d com.apple.quarantine "$(mise which jr)"
```

`mise which jr` requires that mise already resolves `jr` in the *current shell environment* (mise activation + project cd'd in, or `-g` global install). In the failure mode being addressed — the binary won't launch — the user often hasn't yet run it under a shell where mise is active. In that case `mise which jr` prints nothing and `xattr -d com.apple.quarantine ""` errors out unhelpfully. Wrapping with a guard, or showing the raw install path form (`~/.local/share/mise/installs/github-<owner>-jira-cli/<ver>/jr`), would be more robust.

### 7. [NIT] Placement is fine

The section slots correctly between the one-liner and "From source" — mise is a working install path today, so it belongs above `Coming soon`. No change needed. Noting: `Homebrew tap (planned)` and `Crates.io (planned)` remain in the Coming soon block; if you want a coherent "package managers" story, a future PR could group these — out of scope here.

---

## What is accurate and worth preserving

- **`prerelease = true` under `[tools]` in `mise.toml`** — documented and correct (Aqua-backend docs describe canonical semantics; discussion #9323 confirms it applies to the `github:` backend).
- **`@latest` excluding prereleases by default** — accurate; this is the exact semantic the `prerelease = true` opt-in addresses.
- **Release-asset shape** — mise's `github:` backend will match `jr-vX.Y.Z-<target>.tar.gz` / `.zip` from this repo's `release.yml` correctly for macOS/Linux (all four target triples) and Windows (from v0.6.0-dev.2 onward).
- **Owner-agnostic intent** — respect for downstream forks that publish their own signed builds is reasonable framing; just needs to not sacrifice the canonical-upstream example (finding #2).

---

## Recommendation

Request changes on findings 1 and 2 (both are user-facing accuracy issues); take findings 3–5 as strongly recommended copy edits; 6 and 7 are optional. Once #1 is scoped to what mise actually does today and #2 gives the reader a runnable canonical example, the section is a net improvement to the README.
