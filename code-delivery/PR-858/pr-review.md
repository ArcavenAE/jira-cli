## Fresh-eyes review — PR #858

**Verdict: APPROVE** — 0 blocking, 2 suggestions, 1 nit.

Reviewed both changed files (`.github/workflows/release.yml`, `CHANGELOG.md`) against the 8-item checklist. Because `release.yml` is `on: push: tags: ["v*"]` only, **none of this PR's green checks exercise the changed wiring** — as the PR description itself flags. I therefore re-derived the DAG semantics from the GitHub Actions expression rules rather than treating CI green as evidence, and independently verified the SHA pin and the action's version delta against upstream.

---

### 1. DAG semantics — independently verified, correct

The load-bearing question is whether the explicit `if:` actually replaces the implicit "all `needs` succeeded" gate. It does, and for a documented reason worth stating explicitly since the whole change rests on it:

> GitHub's expressions reference: *"A default status check of `success()` is applied unless you include one of these functions"* — `success()`, `always()`, `cancelled()`, `failure()`.

`!cancelled()` **contains** `cancelled()`, so the implicit `success()` is suppressed and the written expression is the entire gate. Had the condition been e.g. `if: ${{ needs.build.result == 'success' && needs.attest.result != 'failure' }}` (no status function), the implicit `success()` would still have been ANDed in and a skipped `attest` would have cascade-skipped `release` — i.e. exactly the regression the comment warns about. The comment at lines 218–227 states this correctly.

All four claimed cases hold:

| `build` | `attest` | Evaluation | Result |
|---|---|---|---|
| `success` | `success` | `T && T && ('success' != 'failure')` | **runs** ✅ |
| `success` | `failure` | `T && T && ('failure' != 'failure')` → F | **blocked** ✅ fail-closed |
| `success` | `skipped` | `T && T && ('skipped' != 'failure')` | **runs** ✅ no fork regression |
| `failure` | (skipped) | `('failure' == 'success')` → F | **blocked** ✅ |

Two further cases I checked that the PR table does not enumerate, both of which also behave correctly:

- **`build` fails → what is `needs.attest.result`?** `attest`'s own `if: vars.ATTESTATIONS_ENABLED == 'true'` contains *no* status-check function, so `attest` retains its implicit `success()` on `needs: build`. A failed `build` therefore yields `attest = skipped`, not some third value — and `release` is blocked by the `build` clause regardless. No unexpected `needs.attest.result` is reachable here.
- **`attest` exceeds `timeout-minutes: 15`.** This was my main concern, since `'cancelled' != 'failure'` would be a fail-**open** hole admitted by the `!=` comparison. Confirmed against GitHub docs: a job terminated by `timeout-minutes` concludes as `failure`, not `cancelled`. So a hung/timed-out attestation blocks the release as intended. (`cancelled()` is scoped to *workflow* cancellation, and a workflow-level cancel trips `!cancelled()` and blocks `release` anyway.)

**`!cancelled()` is the correct top-level guard, and better than `always()` here.** With `always()`, cancelling a release run mid-flight would still publish the GitHub Release from whatever artifacts existed. `!cancelled()` correctly declines to publish out of a cancelled run while still tolerating a skipped/failed dependency. The two guards are not interchangeable for a publishing job.

`needs.<job>.result` is populated for skipped needs (`success` | `failure` | `cancelled` | `skipped`), so the `skipped` case reads a real value rather than an empty string — the expression is well-defined in every reachable state.

Scope check: `build`, `release`, `attest` are the only three jobs in the file, and nothing declares `needs: release` or `needs: attest`, so there is no second-order cascade to reason about.

### 2. SHA pin — verified against upstream

`refs/tags/v4.2.2` in `actions/attest-build-provenance` resolves to `4d101475d8b20a2381f78447822ac1eab6504dd8` — byte-identical to the pin, and the trailing `# v4.2.2` comment is truthful. The prior pin `0f67c3f...` likewise matches `v4.1.1`, so the bump is a genuine forward move and v4.2.2 is the current latest release. `subject-path` remains a valid, non-deprecated input at the pinned SHA, and no new *required* input was introduced, so the existing `with:` block stays complete.

### 3. Findings

| # | Severity | Category | File |
|---|---|---|---|
| S-1 | suggestion | description | `CHANGELOG.md` |
| S-2 | suggestion | missing | `release.yml` / fork-ops doc |
| N-1 | nit | description | PR body |

---

**[SUGGESTION] S-1 — the CHANGELOG understates the version delta on two counts.**

The entry describes the bump as *"an embedded `actions/attest` 4.2.0→4.2.1 tar/OCI update, irrelevant to this non-container Rust release."* Comparing the two pinned SHAs upstream, the actual delta is:

- embedded `actions/attest` **4.1.1 → 4.2.0 → 4.2.1** (two bumps, not one), plus an internal `actions/checkout` 7.0.0 → 7.0.1;
- and `actions/attest` v4.2.0 is not a tar/OCI release. It contains: *"Read subjects from `GITHUB_ARTIFACTS_LIST`"*, *"Support SHA-2 subject digests"*, *"split checksums on any line ending so LF files parse on Windows"*, and `@actions/glob` **0.6.1 → 0.7.0**.

That last one is the reason this is worth correcting rather than shrugging off: `@actions/glob` is the engine that expands this workflow's own `subject-path` patterns (`release-assets/*.tar.gz`, `release-assets/*.zip`). I found no breaking change in that minor bump and I am **not** asking for the pin to change — the bump is fine. But "irrelevant to this non-container Rust release" is the kind of claim a future reader will rely on when deciding whether a provenance regression could have originated here, and the glob-resolution path is squarely in scope. Suggest rewording to something like:

> Bumps `actions/attest-build-provenance` v4.1.1 → v4.2.2 (embedded `actions/attest` 4.1.1 → 4.2.1). Functional changes are subject-resolution only — `@actions/glob` 0.6.1→0.7.0, SHA-2 subject digests, `GITHUB_ARTIFACTS_LIST` subject sourcing, and a Windows checksum line-ending fix. The OCI/registry changes do not apply to this non-container release.

**[SUGGESTION] S-2 — the fail-closed gate changes outcomes for one opted-in fork population, and that is not documented anywhere.**

`release.yml`'s own comment (the `attest` job, lines ~258–262) records that attestations *"are unavailable on GHES and on private forks without GitHub Enterprise Cloud."* Under the previous parallel design, such a fork that set `ATTESTATIONS_ENABLED=true` got a **failing `attest` job but a successfully published release**. After this change it gets **no release at all** — `attest` fails, and the new gate blocks `release`.

That is the correct and intended semantic, and it is opt-in, so it is not a blocker. But it is a real behavior change for a population the file explicitly anticipates, and today nothing tells them about it. Since this repo already maintains `docs/specs/fork-friendly-release-ops.md` for exactly this class of variable, suggest a sentence there (or in the `attest` job comment) along the lines of: *"Setting `ATTESTATIONS_ENABLED=true` in an environment where attestations are unavailable (GHES, private fork without GHEC) will now block the release entirely, not merely publish it without provenance."* This is the kind of thing that is cheap to write down now and expensive to rediscover from a failed release later.

**[NIT] N-1 — the PR body's "local `code-reviewer` pass returned a clean verdict" is not evidence for the part that needs evidence.**

No change requested to the code; this is about how the claim reads. The PR correctly flags that CI does not exercise the wiring, then offers a prior automated review as partial assurance. For a change whose entire risk is a semantic rule in someone else's documentation, a prior model-generated review and CI green are the same category of non-evidence. The manually-traced 4-case table is the real evidence and it stands on its own — I'd lead with that and drop the reviewer-pass line.

### 4. What I verified and found no issue with

Since a clean verdict should be auditable, explicitly:

- **Diff coherence** — both hunks serve the stated purpose; no unrelated edits, no drive-by changes to the `build` job or to the other pinned actions in the file.
- **Comment accuracy** — the replacement comments on both jobs describe the new relationship correctly, including the non-obvious "the explicit `if:` replaces the implicit gate, so it must re-assert `build` success itself" point, which is the single easiest thing to get wrong here.
- **No lost invariant** — the `attest`/`release` fan-in from the same immutable `build` artifacts is preserved, so the TOCTOU/CWE-362 property claimed by the retained comment still holds. Sequencing `attest` before `release` strictly improves it: provenance now exists before anything is published.
- **Permissions** — untouched. `attest` keeps its job-level `id-token: write` + `attestations: write` (which override, not extend, the workflow-level `contents: write`); `release` still inherits `contents: write`. Adding `attest` to `needs` does not alter either job's token scope.
- **Structural pins** — `tests/release_yml_windows_matrix.rs`, `tests/backfill_matrix_parity.rs`, and `scripts/check-signing-workflow-injection.sh` all parse this file and all pass on this PR, so the `build` matrix and injection-guard surfaces are unchanged.
- **Diff size** — 45/10 lines, well under the 500-line threshold.
- **Commit quality** — `ci(release): ...` is conventional-commit conformant and accurately scoped.
- **Demo evidence** — N/A. CI/release-infrastructure change with no user-visible `jr` surface; there is no acceptance criterion a recording could demonstrate.
- **Dependencies** — the referenced upstream PR (#574) is merged; this applies cleanly on top of it.

### 5. One thing for the merger, not the author

Per this repo's documented `strict: false` branch-protection posture, a green gate is computed against `develop` as of the last run, not against its tip at merge time. This PR's checks are green but `Test (windows-latest)` was still pending at review time — worth confirming the full gate has gone green, and re-checking its age if `develop` has moved, before merging.

---

**Approving.** The DAG change is correct in all four claimed states plus the two unclaimed ones I checked, the `!cancelled()` guard is the right choice over `always()` for a publishing job, and the SHA pin is verified against upstream. The two suggestions are documentation-accuracy items that can land in this PR or a follow-up; neither gates the merge.
