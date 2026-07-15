# PR #574 — Fresh Code Review (re-review after head update)

**PR title:** ci(release): attest build provenance for release artifacts
**Author:** ArcavenAE / `arcaven` (external contributor — content treated as UNTRUSTED, diff-only review)
**Reviewed head SHA:** `3c379486e1f6356e526918adc53c9760026065cb` (confirmed current at review time)
**Base:** `develop`
**Reviewer:** fresh-context PR reviewer (Opus) — correctness/design focus; deep security analysis handled by the parallel security re-review
**Prior reviews superseded:** `PR-574/pr-review.md` (COMMENT, on the 2026-07-08 head) and `PR-574/security-review.md` (MERGE-WITH-CHANGES, 2026-07-08)
**Diff surface (this head):** `.github/workflows/release.yml` (+57), `CHANGELOG.md` (+1), `CLAUDE.md` (+1/-1), `docs/specs/fork-friendly-release-ops.md` (+1)

## Verdict: **APPROVE — pending a mechanical rebase**

The head was substantially reworked since 2026-07-08. The new implementation is materially better than what the two prior reviews assessed: it replaces the `gh release download` shell block with an `actions/download-artifact` fan-in from the same immutable `build` artifacts the `release` job consumes, and it adds the fork opt-in gate. Every change-warranting finding from both prior reviews (PR-review MAJOR-1/MAJOR-2; security SEC-001 LOW and SEC-002 MEDIUM) is resolved or adequately documented. No new correctness or design defect blocks merge.

The **only** thing preventing merge is a mechanical CHANGELOG rebase conflict (`mergeStateStatus: DIRTY`), plus the fact that CI has not run (GitHub is holding the workflow run — see below). Neither is a code defect.

---

## Design verification (the load-bearing question)

**Does `attest` attest the same bytes `release` publishes?** Yes, verified:

| Aspect | `release` job | `attest` job (new) |
|---|---|---|
| Dependency | `needs: build` | `needs: build` |
| Fetch | `actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c # v8`, `merge-multiple: true` | `actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c # v8`, `merge-multiple: true`, `path: release-assets` |
| Artifact set | all `build` artifacts (no name filter) | all `build` artifacts (no name filter) |
| Then | softprops uploads `jr-*.tar.gz`/`.zip`/`.sha256` verbatim | attests `release-assets/*.tar.gz` + `*.zip` |

Both jobs are **siblings fanning in from the same immutable `build` outputs** — identical download-artifact SHA and `merge-multiple` semantics. `softprops/action-gh-release` copies the archives byte-for-byte, so the attested digests equal the published-asset digests. There is **no publish-then-attest window** (the old TOCTOU / CWE-362, SEC-002) because nothing is re-fetched from the release page. `gh attestation verify <downloaded-asset>` will match by digest. Confirmed correct.

**No divergence between attested subjects and released assets:** every attested subject (`*.tar.gz`/`*.zip`) is a released asset, and every released archive is attested. The `.sha256` sidecars are released but deliberately not attested (integrity metadata already covered by the archive digest) — an intentional, documented subset, not a gap.

**Fork gate wiring is correct:** `if: vars.ATTESTATIONS_ENABLED == 'true'`. An undefined repo variable evaluates to `''`, so the job skips (fail-safe, matching `SIGNING_ENABLED`/`HOMEBREW_TAP_REPO`/etc. per `docs/specs/fork-friendly-release-ops.md`). Critically, `attest` is **not** a `needs:` of `release` — the inline comment correctly explains that coupling them would let a fork's skipped `attest` cascade-skip its entire release. Because they are independent siblings, the gate on `attest` cannot affect `release`. This is the right dependency graph.

---

## Resolution of prior-review findings

### Prior PR review (`pr-review.md`)

| Finding | Status on `3c379486` |
|---|---|
| MAJOR-1 — signed darwin binaries + `.pkg`/`.dmg` ship unattested | **Addressed (as scoped).** The coverage boundary is now an explicit inline comment in the job ("…re-signs the darwin binaries and emits `.pkg`/`.dmg` with DIFFERENT digests after notarization — those are not covered here and need their own attest step in that workflow…gated on the same variable. Out of scope for this PR."), plus CHANGELOG + spec. This is exactly prior-review suggestion (b): the gap is now visible in-code, not just PR narrative. Real coverage gap remains but is honestly declared and correctly deferred. |
| MAJOR-2 — no fork opt-in gate | **Resolved.** `if: vars.ATTESTATIONS_ENABLED == 'true'`; registered in `CLAUDE.md` release-ops list and the `fork-friendly-release-ops.md` variable table. |
| MINOR-1 — action one patch behind (v4.1.0) | **Resolved.** Bumped to `actions/attest-build-provenance@0f67c3f4856b2e3261c31976d6725780e5e4c373 # v4.1.1`. I independently verified `0f67c3f…` is the `v4.1.1` tag commit via the GitHub API. |
| MINOR-2 — `GITHUB_REF_NAME` vs `github.ref_name` style | **Moot.** The `gh release download` step is gone; the attest job has no `ref_name` reference. |
| MINOR-3 — `!cancelled() && needs.release.result` redundancy | **Moot.** That `if:` construct was removed; the gate is now the single `vars.ATTESTATIONS_ENABLED` expression. |
| MINOR-4 — re-run behavior undocumented | **Moot.** No longer downloads from the release page; the re-run-to-cover-signed-assets workaround no longer applies (coverage boundary documented instead). |
| MINOR-5 — stale prior-run assets attested | **Resolved.** Fans in from this run's immutable `build` artifacts only; the stale-asset class is eliminated. |
| NIT-1/NIT-2 — permission-comment phrasing | Superseded; see new N2 below. |
| NIT-3 — no CHANGELOG entry | **Resolved.** Accurate `### Added` entry present (subject to the rebase in N1). |

### Prior security review (`security-review.md`)

| Finding | Status on `3c379486` |
|---|---|
| SEC-001 (LOW, CWE-77) — `${{ github.repository }}` inline in a shell `run` block | **Resolved.** No shell `run` block remains in the attest job; the inline expression is gone entirely. |
| SEC-002 (MEDIUM→HIGH, CWE-362) — TOCTOU: attest downloads from published release | **Resolved.** Implemented precisely the recommended fix: `actions/download-artifact` fan-in from the in-run `build` artifacts. No external fetch, no window. |
| SEC-003 (INFO) — `.sha256` attested via `*` glob | **Resolved.** `subject-path` is now explicit `release-assets/*.tar.gz` + `release-assets/*.zip`; sidecars excluded, with an explanatory comment. |
| SEC-004 (INFO, CWE-284) — no fork opt-in gate | **Resolved.** Same as MAJOR-2. |
| SEC-005 (INFO) — `egress-policy: audit` vs `block` | **Unchanged / accepted.** Repo-wide convention; the new job is consistent (`audit`). Not a regression. |
| SEC-006 (INFO, CWE-390) — download script lacks `set -euo pipefail` | **Moot / improved.** No shell download script anymore. `download-artifact` fails loudly on error, and an empty `subject-path` makes `attest-build-provenance` fail loudly ("no subjects") rather than silently no-op'ing. |

---

## New findings on this head

### N1 — MERGE BLOCKER (mechanical, not a code defect): CHANGELOG rebase conflict
`gh pr view` reports `mergeable: CONFLICTING`, `mergeStateStatus: DIRTY`. Root cause: the `0.6.0-dev.10` bundle release on 2026-07-15 (develop `56d5126`) moved all entries into a dated `## [0.6.0-dev.10]` section, leaving `## [Unreleased]` **empty**. The PR's CHANGELOG hunk inserts under a `### Added` that existed in the PR's base under `## [Unreleased]` but no longer exists there on develop, so the hunk does not apply. **Action:** contributor rebases on current `develop` and relocates the entry to the now-empty `## [Unreleased]` → `### Added`. No behavioral change; pure text placement. (The `release.yml`, `CLAUDE.md`, and `fork-friendly-release-ops.md` hunks are unaffected — the conflict is CHANGELOG-only.)

### N2 — NIT: `contents: read` permission is likely unnecessary; the comment overstates it
The job declares `id-token: write`, `attestations: write`, `contents: read` with the comment "attest-build-provenance needs all three; none is inherited." `attest-build-provenance` requires only `id-token: write` + `attestations: write`. Since the download now goes through the Actions artifacts API (not the Contents API) and there is no `checkout`/`gh` call, `contents: read` is unused. It is a harmless over-grant of the most minimal read scope, so this is non-blocking — but the comment is imprecise. Optional: drop `contents: read`, or reword to "attest-build-provenance needs `id-token: write` + `attestations: write`; job-level `permissions:` fully replaces the workflow block so both must be redeclared here."

### N3 — INFO (positive): fail-loud on empty artifact set
If `download-artifact` yields no matching archives, `attest-build-provenance` errors on an empty `subject-path` rather than reporting a misleading "0 subjects" success. This closes the old SEC-006 false-confidence concern by design. No action.

### N4 — INFO (accepted tradeoff): orphan attestations if `release` fails
Because `attest` is `needs: build` (not `needs: release`), if `release` fails while `attest` succeeds, provenance is published to Rekor for bytes that never reached a public release. This is benign — an orphan transparency-log entry; digest-based verification still works for anyone holding the bytes — and the decoupling is the correct choice (coupling would reintroduce the fork-gate cascade-skip). No action.

### CI has NOT run — flag for the merging maintainer
`statusCheckRollup` is empty; `gh pr checks 574` reports no checks. This is consistent with GitHub holding workflow runs on an external-contributor PR that touches `.github/workflows/`, pending maintainer approval. Two consequences the maintainer should note:
1. The held run must be manually approved before any CI signal exists.
2. Even when approved, PR CI cannot exercise the `attest` job — the `Release` workflow triggers only on `push: tags: ["v*"]`, so the job first runs against a real tag post-merge. Validation therefore rests on the contributor's fork smoke-test (`gh attestation verify` + `mise`, per the PR body) plus this static review. A maintainer may wish to confirm on a throwaway tag after merge, or accept the fork evidence.

---

## Bottom line
Design is now correct and the implementation resolves both prior change-warranting security items and both prior MAJOR items. Action bump verified (`0f67c3f…` = v4.1.1). Docs (CHANGELOG, CLAUDE.md, spec table) are consistent with the workflow behavior. **Approve once the contributor rebases to clear the CHANGELOG conflict (N1);** N2 is an optional cleanup. Untrusted-contributor caution: the diff is CI-config only, append-only, no application code, all actions SHA-pinned — low blast radius, but the held workflow run should be reviewed before approval.
