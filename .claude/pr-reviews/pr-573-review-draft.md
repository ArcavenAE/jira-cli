Thanks @arcaven — this is a genuinely useful addition and the section slots in exactly the right place. The mise mechanics you describe check out (we verified the `github:` backend behavior, `prerelease = true`, and the native attestation verification against mise's docs). Two accuracy items need a copy edit before merge, plus a few smaller suggestions.

### Required

**1. The attestation sentence conflates mise-side support with repo-side publishing.**
mise's native verification is already shipped — what's pending is *this repo* publishing attestations (that's #574, not yet merged). Also, automatic verification for a plain `github:` install covers GitHub Artifact Attestations; "SLSA provenance" overstates what runs by default. As written, readers may think a chain-of-trust story exists today. Suggested rewrite:

```
mise's `github:` backend auto-selects the release asset matching your OS
and architecture and extracts the `jr` binary. Once releases ship GitHub
Artifact Attestations (planned — see #574), mise verifies them natively
without invoking `gh` or `slsa-verifier`.
```

(Alternatively: drop the paragraph for now and re-add it when #574 lands.)

**2. Make the canonical example runnable.**
The rest of the Install section uses concrete strings (`Zious11/jira-cli` in the curl one-liner, git clone, tap). A literal `<owner>` in the fenced block means copy-paste fails and the reader has to backtrack. Suggested:

```bash
mise use github:Zious11/jira-cli@latest
```

with a single follow-up sentence: "Replace `Zious11` with a fork's owner if you install from a downstream distribution." (Same for the `mise.toml` snippet.)

### Recommended

**3.** The prerelease glob lists `v*-beta.*` / `v*-rc.*`, but this repo has only ever cut `-dev.*` prereleases. Suggest narrowing to `v*-dev.*` (or hedge with "if cut").

**4.** Windows gotcha worth one line: the current stable (v0.5.0) shipped without a Windows asset, so Windows users need `prerelease = true` until v0.6.0 stable — otherwise `@latest` resolves to a release with no matching asset.

**5.** "extracts the `jr` binary onto your `PATH`" assumes `mise activate` is set up — a "(assumes `mise activate` in your shell profile)" parenthetical or a link to mise's Getting Started would prevent "installed but `jr` not found" reports.

### Optional

**6.** `xattr -d com.apple.quarantine "$(mise which jr)"` — in the exact failure mode this addresses, `mise which jr` may print nothing (mise not yet active in that shell) and the command errors confusingly. Consider showing the raw install path form as a fallback.

Happy to merge once 1–2 are addressed. Appreciate the fork-transparency framing and the tested claims — the smoke-test detail in the description made this easy to review.
