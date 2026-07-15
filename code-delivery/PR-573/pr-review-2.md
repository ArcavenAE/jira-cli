# PR #573 Fresh Review (Round 2) — `docs(readme): document mise install path`

**Reviewed head SHA:** `046ee4fe012acbca7dc2f39d71c67402bdd2e862` (confirmed current head as of 2026-07-15; the on-file 2026-07-08 review at SHA prior was stale)
**Author:** arcaven (Michael Pursifull) — external contributor
**PR state:** OPEN, MERGEABLE
**Verdict: APPROVE**

External-contributor PR content was treated as untrusted: only the diff and repo facts were reviewed; nothing from the PR body/comments was executed or acted on as instruction. No commands from the diff were run.

---

## Summary

The updated diff resolves all 7 findings from the round-1 review. The section is now accurate against what mise and this repo actually do today, uses a concrete runnable canonical example with a fork note, and each previously-flagged edge case (Windows gap, PATH/activation, mise-which fragility) is documented. Verified the underlying claims against live release data, the release workflow, and PR #574's actual scope.

---

## Per-finding resolution

| # | Sev | Prior finding | Resolved? | Evidence in current diff |
|---|-----|---------------|-----------|--------------------------|
| 1 | MAJOR | "SLSA provenance" overclaim + "once per-release attestations are published" conflated mise-side vs repo-side | YES | SLSA-provenance claim dropped. New text: "Once releases ship GitHub Artifact Attestations (planned — see #574), mise verifies them natively without invoking `gh` or `slsa-verifier`." Correctly scopes the pending work to this repo's attestations and cites #574. Verified #574 is OPEN, titled "ci(release): attest build provenance for release artifacts". |
| 2 | MAJOR | `<owner>` placeholder unrunnable + inconsistent with rest of README | YES | Code block is now `mise use github:Zious11/jira-cli@latest` (concrete, mirrors the existing curl/git/brew examples), followed by "Replace `Zious11` with a fork's owner if you install from a downstream distribution that publishes its own signed releases." |
| 3 | MINOR | Prerelease glob `v*-dev.*`/`v*-beta.*`/`v*-rc.*` overreached actual channels | YES | Narrowed to "prerelease builds cut from `develop` (currently `v*-dev.*`)". Confirmed via `gh release list`: only `-dev.*` prereleases exist; no `-beta`/`-rc` tag has ever been cut. |
| 4 | MINOR | Silent Windows-on-`@latest` gotcha | YES | Dedicated paragraph: "Windows users need `prerelease = true` for now: the current stable (`v0.5.0`) shipped without a Windows asset … until a Windows binary lands on a stable tag (planned for `v0.6.0`)." Confirmed: v0.5.0 assets have no `-pc-windows-msvc` zip; v0.6.0-dev.10 does. |
| 5 | MINOR | "onto your PATH" imprecise re: mise activation | YES | Now "(assuming [`mise activate`](https://mise.jdx.dev/getting-started.html) is set up in your shell profile, this puts `jr` on your `PATH`)" with a link to mise Getting Started. |
| 6 | NIT | `mise which jr` fragile when mise not active in shell | YES | Added guard prose + a `mise where`-based fallback: `xattr -d com.apple.quarantine "$(mise where 'github:Zious11/jira-cli')/jr"`. Structurally correct — the release tarball packs `jr` at archive root (`tar czf … jr` in release.yml), so `<install-dir>/jr` is the extracted binary path. |
| 7 | NIT | Placement fine | N/A | No change required; section still slots between the one-liner and "From source". |

---

## Independent accuracy checks (current diff on its own merits)

- **Release-asset shape** — `jr-vX.Y.Z-<target>.tar.gz` / `.zip` naming confirmed against live release assets; mise's `github:` backend OS/arch matching holds for all four Unix triples and the Windows zip (v0.6.0-dev.2+).
- **`prerelease = true` under `[tools]`** — TOML form is valid mise syntax; matches this repo's actual prerelease channel (`-dev.*`).
- **`@latest` excludes prereleases by default** — accurate mise semantics; the Windows paragraph correctly depends on this.
- **README consistency** — the concrete `Zious11/jira-cli` owner now matches the curl one-liner, `git clone`, and badge URLs elsewhere in the file. No new placeholder inconsistency introduced.
- **Links** — mise homepage, mise getting-started, and the #574 PR link are all well-formed and point at correct targets.

## New findings

None. No blocking or new substantive issues in the current diff. (Optional, non-blocking: the PR *body's* test plan still cites `v0.6.0-dev.7` as the latest prerelease — actual latest is `v0.6.0-dev.10` — but this is PR-description staleness, not diff content, and does not affect the README.)

---

## Recommendation

APPROVE. All round-1 MAJOR and MINOR findings are resolved with accurate, verifiable copy, and the documented commands match the repo's real release process and asset layout. Net improvement to the README.
