---
drift_item: WIN-CI-GATE-AGGREGATOR
phase: F1 Delta Analysis
date: 2026-06-14
analyst: architect
traces_to: STATE.md DEC-096, DEC-097, DEC-101
---

# Phase F1 Delta Analysis — WIN-CI-GATE-AGGREGATOR

## 1. Classification

**Enhancement** (CI-infra hardening).

This is not a bug fix — the acute branch-protection breakage was already resolved in DEC-097. It is an enhancement that eliminates a recurring fragility class: any future change to the `strategy.matrix.os` values in `ci.yml` will silently invalidate required status check contexts, forcing another emergency `PATCH required_status_checks` as happened with DEC-096. The aggregator converts that O(n-matrix-legs) maintenance surface into a single stable context.

## 2. Routing Recommendation

**Quick-dev** (single story, no spec change, no new BCs).

Justification:
- One file changes: `.github/workflows/ci.yml` (add `ci-gate` job + optional hermetic test).
- No behavioral contracts are added, removed, or modified. The BC catalog (597 BCs) is untouched — this is a CI pipeline change, not product behavior.
- No NFR (42) or ADR (16) entries need new content, though ADR-0016 §5 "CI" is a candidate for an informational note (non-blocking, can be a CLAUDE.md bullet).
- The branch-protection migration step is a repo-admin action that runs AFTER the PR merges and ci-gate is observed green — not a code-review gate.
- Comparable in scope to the `JR_BULK_UNKNOWN_GRACE_SECS` seam additions that shipped as single-story quick-dev PRs.
- Full F2/F3 spec-crystallization is disproportionate for a ~15-line `ci.yml` addition with zero product-behavior surface area.

## 3. Impact Boundary

### Files Changed (expected)

| File | Change |
|------|--------|
| `.github/workflows/ci.yml` | Add `ci-gate` aggregator job (15–25 lines) |
| `CLAUDE.md` | Optional: add bullet under "Key Decisions" noting `ci-gate` is the single required check (mirrors DEC-097 pattern) |
| `docs/adr/ADR-0016.md` | Optional: informational note in §5 CI section — "ci-gate is the required status check; add new CI jobs to ci-gate.needs, not to branch protection" |

### Files NOT Changed

All `src/` code, all `tests/`, all `.factory/specs/prd/` BC files, NFR catalog, story files, Cargo.toml.

### BC / NFR / ADR / Story Impact

- **BCs (597):** Zero. No behavioral contract is added or changed.
- **NFRs (42):** Zero. No non-functional requirement is added or changed.
- **ADRs (16):** Zero required changes. ADR-0016 §5 could receive an informational sentence (author's discretion; non-blocking).
- **Stories (74):** Zero. No story file is modified; the new story is standalone.

## 4. Design of the `ci-gate` Job

### Which jobs to `needs:`

Gate on the **currently-required** set only — the 5 jobs that map to the 8 previously-required contexts:

```
needs: [fmt, clippy, test, msrv, deny]
```

Rationale for each:
- `fmt` → emits `Format` (single-leg, already required)
- `clippy` → emits `Clippy (ubuntu-latest)` + `Clippy (windows-latest)` (matrix, previously required)
- `test` → emits `Test (ubuntu-latest)` + `Test (macos-latest)` + `Test (windows-latest)` (matrix, previously required)
- `msrv` → emits `MSRV (1.85.0)` (single-leg, previously required)
- `deny` → emits `Deny (licenses + vulnerabilities)` (single-leg, previously required)

### Advisory jobs — do NOT gate on them

| Job | Reason to exclude |
|-----|-------------------|
| `coverage` | `fail_ci_if_error: false` on codecov upload; advisory by design |
| `spec-guard` | Consumes `factory-artifacts` branch; can flap independently of code correctness; currently not required |
| `security` | `if: github.event_name == 'pull_request'` — skips on push; including it in `ci-gate` would make push-triggered runs of `ci-gate` depend on a skipped job (see skipped-job trap below) |
| `mutants` | `if: github.event_name == 'pull_request'` — same skipped-job trap; mutation testing is slow and PR-only by design |

If the team wants to promote `spec-guard` or `security` to required, add them to `ci-gate.needs` in a separate PR — keep this one minimal.

### The Skipped-Job Trap (critical)

A naive aggregator using `needs: [...]` with no `if:` clause passes when an upstream is **skipped**. GitHub reports skipped jobs as `success` in branch-protection evaluation — meaning a matrix leg that is conditionally excluded would silently satisfy the gate.

The pattern that handles this correctly:

```yaml
ci-gate:
  name: CI Gate
  runs-on: ubuntu-latest
  needs: [fmt, clippy, test, msrv, deny]
  if: ${{ always() }}
  steps:
    - name: Fail if any required job failed or was cancelled
      if: >-
        ${{ contains(needs.*.result, 'failure') ||
            contains(needs.*.result, 'cancelled') }}
      run: exit 1
```

Two load-bearing properties:
1. `if: ${{ always() }}` — guarantees `ci-gate` runs and reports a result even when an upstream fails. Without this, a failed upstream causes `ci-gate` to be skipped (not failed), which GitHub evaluates as `success` and permits merge — the worst possible failure mode.
2. `contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled')` — explicitly rejects `failure` and `cancelled`. Does NOT reject `skipped`; a skipped required leg (e.g. if we later add a PR-only job to `needs`) would pass through. This is intentional for the current `needs` set — all five gating jobs run unconditionally on both push and PR.

The `security` and `mutants` jobs are correctly excluded from `needs` because they carry `if: github.event_name == 'pull_request'` and would produce `skipped` on push events, making them unreliable in the aggregator.

### Hermetic Test (optional but recommended)

A test in `tests/ci_gate_completeness.rs` (or a bash script) that:
- Reads `.github/workflows/ci.yml`
- Asserts a job named `ci-gate` exists
- Asserts `ci-gate.needs` contains every job in an expected list

This catches the next drift: someone adds a new required-candidate CI job and forgets to add it to `ci-gate.needs`. Cost: ~30 lines of test. Recommendation: include in this PR.

## 5. Branch-Protection Migration

**This is a repo-admin action. The harness cannot perform it** (same harness-blocked constraint as DEC-097).

### Ordering (critical — wrong order = lock-out)

1. Merge the PR adding `ci-gate` to `ci.yml` into `develop`.
2. Observe `ci-gate` reporting `success` on at least one push/PR run on `develop`.
3. ONLY THEN: PATCH `required_status_checks` on `develop` and `main` to replace the 8 current contexts with the single `ci-gate` context.

**Never remove the old required contexts before `ci-gate` is confirmed green.** If you remove them first and `ci-gate` is broken or missing, you have no gating check and merges are unprotected.

### API Payload (develop and main — same body)

```json
{
  "checks": [
    { "context": "CI Gate", "app_id": 15368 }
  ]
}
```

`"CI Gate"` must match the `name:` field of the job exactly. If no `name:` is set, it defaults to the job key `ci-gate`. Set `name: CI Gate` in the job definition to get a human-readable context name.

`strict: false` is preserved (omit from payload to keep existing value per PATCH semantics confirmed in DEC-097 research).

### Commands (gh CLI)

```bash
# Verify current state first
gh api repos/{owner}/jira-cli/branches/develop/protection/required_status_checks

# Apply to develop
gh api --method PATCH \
  repos/{owner}/jira-cli/branches/develop/protection/required_status_checks \
  -f 'checks[][context]=CI Gate' \
  -F 'checks[][app_id]=15368'

# Apply to main (same payload)
gh api --method PATCH \
  repos/{owner}/jira-cli/branches/main/protection/required_status_checks \
  -f 'checks[][context]=CI Gate' \
  -F 'checks[][app_id]=15368'
```

Replace `{owner}` with the actual org/user. Verify with a follow-up `gh api GET` call.

## 6. Regression Risk

**LOW.**

Mitigations:
- `if: ${{ always() }}` ensures `ci-gate` always runs and always reports; it cannot silently pass.
- The `failure`/`cancelled` check is explicit; skipping only applies to jobs not in `needs`, which is the correct behavior.
- The old required contexts remain active during the transition window — no gap where unprotected merges could land.
- The ordered migration (add job → confirm green → swap protection) prevents lock-out.
- The optional hermetic test pins `ci-gate.needs` enumeration so future CI-job additions are caught at CI time.
- No product code changes; no risk of behavioral regression.

One residual risk: if the `ci-gate` job itself has a YAML syntax error, the workflow fails to parse and all jobs (including `ci-gate`) fail. This is caught before merge because the PR itself would show red. Not unique to this change.

## 7. Open Questions for Human Gate

1. **Job name choice:** Use `name: CI Gate` (human-readable context) or leave unnamed so the context is `ci-gate` (kebab-case)? Either works; the branch-protection PATCH must match exactly.
2. **Include `spec-guard` in `needs`?** `spec-guard` consumes the `factory-artifacts` branch and validates `.factory/specs/prd/` BC files. It currently runs but is not required. Do you want to promote it to a blocking check via the aggregator?
3. **Hermetic test — yes or no?** The test adds ~30 lines to `tests/` and would be the only test file that reads a YAML workflow file. Useful for drift prevention; slightly unusual for a Rust project.
4. **ADR-0016 note:** Should a sentence be appended to `docs/adr/ADR-0016.md` §5 noting the `ci-gate` convention, or is a CLAUDE.md bullet sufficient?
5. **Timing:** This is a standalone LOW-priority enhancement. Is it worth doing now as a clean-up PR before the next feature cycle, or defer further?
