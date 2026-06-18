---
document_type: phase-f1-delta-analysis
feature: fork-ops-signing-hardening
intent: bug-fix
severity: HIGH
feature_type: infrastructure
scope: standard
trivial: false
created: 2026-06-18
blocking_decision: DEC-104
---

# Phase F1 Delta Analysis: Fork-Ops Signing Hardening

## Feature Summary

Resolve two HIGH-severity drift items (FORK-OPS-SIGN-INJECTION + FORK-OPS-ALPHA-RACE)
that block signing enablement (DEC-104), and fold in three related LOW nits from the same
file set. All five items are confined to two GitHub Actions workflow files:

- `.github/workflows/sign-and-publish.yml`
- `.github/workflows/backfill-release.yml`

Both files are INERT in the canonical repo (`vars.SIGNING_ENABLED` is unset). The fix
unblocks downstream fork signing enablement without affecting CI in the canonical repo.

---

## Classification

| Field | Value |
|-------|-------|
| Intent | `bug-fix` (security hardening) |
| Feature type | `infrastructure` (CI/CD workflow) |
| Scope | `standard` (two files, not trivial — two HIGH security items require careful reasoning) |
| Severity | HIGH (CWE-77 shell injection with Apple secrets in scope; TOCTOU race on tag creation) |
| Expedited | No — workflows are INERT in canonical repo; no production risk |
| Blocking | DEC-104 (fork signing enablement) |

---

## Items to Fix

### HIGH-1: FORK-OPS-SIGN-INJECTION (CWE-77)

**File:** `.github/workflows/sign-and-publish.yml`
**Job:** `stable-sign`
**Step:** "Extract release metadata" (lines 358–378)

**Current injection point (line 361):**
```yaml
      - name: Extract release metadata
        id: meta
        run: |
          TAG="${{ github.event.workflow_run.head_branch }}"
```

`${{ github.event.workflow_run.head_branch }}` is interpolated inline into the shell
`run:` block. A branch name containing shell metacharacters (semicolons, backticks,
`$()`) could execute arbitrary commands inside a runner that has Apple Developer ID
secrets (APPLE_CERTIFICATE_P12, APPLE_SIGNING_IDENTITY, etc.) and `contents: write`
permissions in scope via the `release` environment.

**Trigger context:** This job runs on `workflow_run` events from the "Release" workflow
(`release.yml`), which fires on `push: tags: ["v*"]`. In the canonical repo, the
`stable-sign` job is additionally gated on `vars.SIGNING_ENABLED == 'true'` (line 339),
making it fully inert. However, the injection vulnerability is real and must be fixed
before SIGNING_ENABLED is enabled (DEC-104).

**Standard mitigation (GitHub recommended pattern):** pass the untrusted value through an
`env:` block and reference it as a quoted shell variable (`"$BRANCH"`), never inline
`${{ }}` in the shell body. GitHub's "Understanding the risk of script injections"
documentation (https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions#understanding-the-risk-of-script-injections)
explicitly states this as the canonical fix: use `env:` to bind context values before the
`run:` block, then reference `$ENV_VAR` (never `${{ expression }}`) inside the script.

**Proposed fix:**
```yaml
      - name: Extract release metadata
        id: meta
        env:
          HEAD_BRANCH: ${{ github.event.workflow_run.head_branch }}
        run: |
          TAG="$HEAD_BRANCH"
          VERSION="${TAG#v}"
          ...
```

---

### HIGH-2: FORK-OPS-ALPHA-RACE (TOCTOU)

**File:** `.github/workflows/sign-and-publish.yml`
**Job:** `alpha-sign`
**Step:** "Generate alpha version" (lines 142–158)

**Current check-then-create logic (lines 145–156):**
```yaml
        run: |
          DATE=$(date -u +%Y%m%d)
          # Count existing tags today (more reliable than releases)
          EXISTING=$(git ls-remote --tags origin "refs/tags/alpha-${DATE}.*" | wc -l | tr -d ' ')
          SEQ=$((EXISTING + 1))
          TAG="alpha-${DATE}.${SEQ}"
          VERSION="${TAG}"
          echo "tag=$TAG" >> "$GITHUB_OUTPUT"
          echo "version=$VERSION" >> "$GITHUB_OUTPUT"
          echo "Alpha release: $TAG"

          # Clean up any stale release/tag with the same name
          gh release delete "$TAG" --cleanup-tag --yes 2>/dev/null || true
```

The sequence is: (1) count existing tags to compute SEQ; (2) construct TAG; (3) delete
any existing release/tag with that name; (4) later create a new release with that tag.
Between steps 1 and 4, a concurrent develop push could trigger a second `alpha-sign`
run that computes the same SEQ (same count at observation time), generating the same tag.
Both runs delete the "stale" release the other just created, producing race-to-last-write
semantics.

**Mitigation:** Use atomic tag creation. Attempt `git push origin
refs/tags/$TAG:refs/tags/$TAG` and treat a non-zero exit (remote already has the tag) as
a collision signal — increment SEQ and retry. Git's remote tag push is atomic at the
server level: the remote atomically reserves the ref or rejects the push. A retry loop
eliminates the check-decide-write window. The existing `gh release delete` cleanup can be
retained as a best-effort stale-release purge but must run AFTER the atomic tag is
reserved.

---

### LOW-1: FORK-OPS-NIT-USECROSS-GUARD

**File:** `.github/workflows/sign-and-publish.yml`
**Job:** `alpha-build`
**Step:** "Install Rust" (lines 52–55)

`sign-and-publish.yml`'s `alpha-build` job uses `dtolnay/rust-toolchain` with
`targets: ${{ matrix.target }}` but has no defensive `rustup target add` step.
The `release.yml` pattern (line 43–45) adds:
```yaml
      - name: Ensure cross-target installed (defensive)
        if: ${{ !matrix.use_cross }}
        run: rustup target add ${{ matrix.target }}
```
Since `alpha-build` only builds native macOS targets and does not use `cross`, the
`use_cross` matrix field is absent — the guard simplifies to unconditional. Adding a
`rustup target add` step achieves defensive parity with `release.yml`.

---

### LOW-2: FORK-OPS-NIT-TMP-PREDICTABLE (CWE-377/362)

**Files:** `.github/workflows/sign-and-publish.yml` (both `alpha-sign` and `stable-sign`
verify steps), `.github/workflows/backfill-release.yml` (`sign` verify step)

The "Verify signatures" steps added by PR #530 (commit 99f212d) use predictable paths:
```bash
set -e
codesign -dvv "$BIN" 2>&1 | tee /tmp/cs.out
spctl --assess --type install --verbose=4 "$PKG" 2>&1 | tee /tmp/spctl.out
```

On ephemeral GitHub Actions macOS runners, symlink attacks (CWE-362) and temp-file
collisions (CWE-377) are theoretical, but the pattern is incorrect. Fix: replace with
`mktemp` and clean up via `trap`:
```bash
CS_OUT=$(mktemp)
SPCTL_OUT=$(mktemp)
trap 'rm -f "$CS_OUT" "$SPCTL_OUT"' EXIT
codesign -dvv "$BIN" 2>&1 | tee "$CS_OUT"
```

---

### LOW-3: FORK-OPS-NIT-PIPEFAIL (CWE-390)

**Files:** same three verify steps as LOW-2

The verify step scripts use `set -e` without `set -o pipefail`:
```bash
set -e
codesign -dvv "$BIN" 2>&1 | tee /tmp/cs.out
```

Without `pipefail`, if `codesign` exits non-zero, the pipe `codesign ... | tee` still
succeeds because `tee` exits 0. `set -e` only catches the last pipeline command.
A failing `codesign` silently produces empty output; subsequent `grep` checks
misattribute the failure. Fix: change `set -e` to `set -eo pipefail`.

---

## Impact Assessment Table

| Artifact | Status | Notes |
|----------|--------|-------|
| PRD (BC-S.SS.NNN) | UNCHANGED | No existing BCs cover signing workflow behavior. No new BCs needed — this is a CI/CD workflow fix, not a `jr` product behavioral contract. |
| Architecture | UNCHANGED | No `src/` changes. All `.factory/specs/architecture/` files are unaffected. |
| NFR catalog | UNCHANGED | No NFRs cover signing workflow security. No new NFRs needed. |
| UX / design | N/A | Infrastructure-only change. |
| Stories | NEW (1 story) | `docs/specs/fork-friendly-release-ops.md` needs a security notes delta. One tracking story S-FORK-OPS-SIGN-1 recommended. |
| Tests (Rust) | UNCHANGED | No Rust test files are touched. `tests/e2e_cli_surface_guard.rs` is unaffected. |
| Verification properties (VP-NNN) | UNCHANGED | No VPs cover CI/CD workflow files. |
| `docs/specs/fork-friendly-release-ops.md` | MODIFIED | Add "Security constraints" section: env-var binding requirement for `workflow_run` context values; atomic tag loop pattern for alpha channel. |

---

## Files Changed Table

| File | Change Type | Items |
|------|-------------|-------|
| `.github/workflows/sign-and-publish.yml` | MODIFIED | HIGH-1 (env-var binding), HIGH-2 (atomic tag), LOW-1 (rustup guard), LOW-2 (mktemp), LOW-3 (pipefail) |
| `.github/workflows/backfill-release.yml` | MODIFIED | LOW-2 (mktemp in verify step), LOW-3 (pipefail in verify step) |
| `docs/specs/fork-friendly-release-ops.md` | MODIFIED | Security constraints section |

---

## Files NOT Changed (Regression Baseline)

**All Rust source (`src/`):** No changes. The `jr` binary behavior, API calls, output
rendering, authentication, and all product features are completely unchanged.

**All Rust tests (`tests/`):** No changes. The full cargo test suite (unit, integration,
property-based, snapshot, E2E) is unaffected. The workflows being modified are INERT in
the canonical repo (`SIGNING_ENABLED` unset), so no test exercises them.

**All other workflows:** `ci.yml`, `release.yml`, `e2e.yml`, `e2e-sweeper.yml`,
`dependency-review.yml`, `release-gap-fill.yml`, `scorecards.yml`, `sync-upstream.yml`
are all unchanged. The `release.yml` → `sign-and-publish.yml` triggering relationship
is preserved: `sign-and-publish.yml` continues to listen on `workflow_run: workflows:
["Release"]`; the fix only changes the internal shell logic, not the `on:` trigger or
workflow name. No other workflow references `sign-and-publish.yml` or
`backfill-release.yml` by name.

**CI Gate:** The `ci-gate` required status check is unaffected. The modified workflows
do not run in the canonical repo.

**All spec files except fork-friendly-release-ops.md:** All BC files, NFR catalog,
holdout scenarios, ADRs, and all `.factory/specs/architecture/` files are unchanged.

---

## Regression Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Product regression | NEAR-ZERO | No `src/` changes. Workflows are INERT in canonical repo. All Rust tests pass against unchanged code. |
| CI regression | NEAR-ZERO | `ci.yml` and `ci-gate` are unaffected. The two modified workflows do not participate in the CI gate. |
| Architecture regression | NONE | No architectural changes. |
| Security sensitivity | HIGH | Even though product-regression risk is near-zero, the items are security-critical: CWE-77 injection with Apple Developer ID secrets in scope must be reviewed with full security diligence before SIGNING_ENABLED is set. |
| Release triggering relationship | NONE | `release.yml` → `sign-and-publish.yml` `workflow_run` trigger is unchanged. |
| Concurrent alpha run behavior | IMPROVED | After the alpha-race fix, concurrent develop pushes resolve deterministically via atomic tag creation. |

---

## Security Validation

### CWE-77 Mitigation (FORK-OPS-SIGN-INJECTION)

The proposed env-var mitigation is the GitHub-documented standard. GitHub's official
security hardening guide ("Security hardening for GitHub Actions", section "Understanding
the risk of script injections") explicitly states:

> "Instead of using `${{ expression }}` in your scripts, consider using an intermediate
> environment variable."

This is the same pattern recommended by StepSecurity's actionlint and enforced by the
`zizmor` static analysis tool. Binding the untrusted value to an env var means the shell
receives it as a literal environment variable value — shell parsing of the `run:` block's
string interpolation happens before env var expansion, so metacharacters in the value are
never interpreted as shell syntax.

Note: a scan of all `${{ }}` expressions in `stable-sign`'s shell scripts should be
performed during F5 to confirm no other `workflow_run` context values are inline-expanded.
The `head_branch` on line 361 is the identified injection point, but sibling fields
(e.g., `head_sha`, `head_commit.message`) should be verified as either safe (used only
in non-shell contexts like `uses:` parameters) or also moved to env vars.

### TOCTOU Mitigation (FORK-OPS-ALPHA-RACE)

Atomic tag push (`git push origin TAG:TAG`) eliminates the check-then-create window.
Git's remote tag creation is atomic at the server level: two concurrent runs attempting
to push the same tag name will have one succeed and one receive a "tag already exists"
rejection. A retry loop that increments SEQ until the push succeeds is the canonical
pattern. `git push --force` must NOT be used (would defeat atomicity); `--force-with-lease`
does not help for new tags. The existing `gh release delete --cleanup-tag` can be kept as
a best-effort purge on the retry path, after the new tag is successfully reserved.

---

## Existing Spec Coverage

No existing BC-S.SS.NNN identifiers cover signing workflow behavior. The fork-ops
infrastructure is documented in:
- `docs/specs/fork-friendly-release-ops.md` (authoritative spec for this subsystem)
- `.factory/STATE.md` Drift Items: FORK-OPS-SIGN-INJECTION, FORK-OPS-ALPHA-RACE,
  FORK-OPS-NIT-USECROSS-GUARD, FORK-OPS-NIT-TMP-PREDICTABLE, FORK-OPS-NIT-PIPEFAIL
- `.factory/research/fork-release-ops-integration.md`
- `.factory/research/issue-210-macos-signing-notarize.md`

No new BC-S.SS.NNN identifiers are appropriate for CI/CD workflow behavior.
Do NOT invent FR-NNN identifiers.

---

## Recommended Scope for F2–F7

### F2 (Spec Evolution)
Minimal. Update `docs/specs/fork-friendly-release-ops.md` with a "Security constraints"
section: (1) all `workflow_run` context values that enter shell scripts MUST be bound via
`env:`; (2) alpha tag generation uses an atomic push loop — read-decide-write is
prohibited. No BC, NFR, or architecture document changes.

### F3 (Stories)
One story: `S-FORK-OPS-SIGN-1` — fix all five items in two workflow files + update
spec. ACs trace to Drift Item IDs (FORK-OPS-SIGN-INJECTION, FORK-OPS-ALPHA-RACE,
FORK-OPS-NIT-USECROSS-GUARD, FORK-OPS-NIT-TMP-PREDICTABLE, FORK-OPS-NIT-PIPEFAIL).
Delivery includes STATE.md Drift Item status updates.

### F4 (Delta Implementation)
Single-story YAML edit. No Rust code changes. One PR for both workflow files + spec doc.

### F5 (Adversarial Refinement)
1 round max. Focus: (a) scan ALL `${{ }}` inline expansions in `stable-sign` and
`alpha-sign` shell scripts, not just line 361; (b) verify retry loop has a maximum bound
to prevent infinite loops; (c) confirm `mktemp` temp files cleaned up on error paths;
(d) verify `pipefail` interacts correctly with existing `|| { ...; exit 1; }` patterns.

### F6 (Formal Hardening)
Minimal. No Rust code, no property proofs, no mutation testing. Security scan
(`cargo deny check`) is unaffected. Human review of workflow YAML YAML is the
verification mechanism — formal tooling does not apply to shell scripts in CI files.

### F7 (Convergence)
Standard: STATE.md Drift Items for all five items marked RESOLVED; spec changelog entry;
no VP or BC count changes needed.
