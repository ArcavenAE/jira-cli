# F1 Architect Input — Issue #346

Issue: chore(ci): add cargo-mutants to CI scoped to bulk + edit modules with 90% kill-rate target
Source: F6 hardening review of PR #110-pr2, 2026-05-10.
Date: 2026-05-16

---

## Impact Boundary

| Component | File | Change Type | Justification |
|-----------|------|-------------|---------------|
| CI workflow | `.github/workflows/ci.yml` | MODIFIED | Add `mutants` job. The existing workflow is 107 lines across 7 jobs (fmt, clippy, test, msrv, deny, coverage, spec-guard, security). A single additional job keeps the file under ~150 lines — no extraction to a separate workflow file is warranted at this size. |
| `.gitignore` | `.gitignore` | MODIFIED | `mutants.out/` directory (cargo-mutants default output) must be added. Currently not present. The `.factory/` entry already ignores the factory dir; `mutants.out/` at repo root is a separate artifact directory. |
| CLAUDE.md | `CLAUDE.md` | MODIFIED | Two additions: (1) a line in the "Build & Test" section showing the local invocation command; (2) a line in the "AI Agent Notes" section noting that cargo-mutants is a binary tool, not a `Cargo.toml` dependency, and should never be added as one. |
| Docs spec | `docs/specs/cargo-mutants-policy.md` | NEW | The issue's acceptance criteria include documented policy (kill-rate threshold, scope, whitelist mechanism for surviving mutants). A standalone spec is warranted because: (a) the threshold is configurable and needs a single source of truth, (b) the whitelist pattern (inline `#[mutants::skip]` attribute with justification comment) needs a standing convention before F4 uses it, and (c) `docs/specs/` already has per-feature spec files for comparable CI and test policies. |
| Mutants config | `.mutants.toml` | NEW | cargo-mutants supports a project-level config file for default flags (timeout, file scope, output dir). Setting `timeout_multiplier` and `test_timeout` in config rather than in CI YAML keeps the CI step clean and makes local runs match CI behavior by default. |
| `Cargo.toml` | `Cargo.toml` | NO CHANGE | cargo-mutants is a standalone binary tool installed via `cargo install cargo-mutants`; it is not a crate dependency. Adding it to `[dev-dependencies]` would be incorrect and is explicitly flagged here so F4 does not make that mistake. |
| GitHub Action pin | CI YAML inline | MODIFIED (part of ci.yml) | `sourcefrog/cargo-mutants-action` requires a pinned SHA per project convention (see existing `actions/checkout@de0fac2e`, `Swatinem/rust-cache@e18b497796c1`, etc.). F4 must resolve the current SHA for `sourcefrog/cargo-mutants-action` before writing the job step. Alternatively the job can use `cargo install cargo-mutants` directly (raw invocation pattern) which avoids the GitHub Action dependency entirely and sidesteps the SHA-pin research; see Architecture Delta below. |

---

## Architecture Delta

### Option A: Extend `ci.yml` with a `mutants` job using raw `cargo install` invocation (RECOMMENDED)

Add a single new job to `.github/workflows/ci.yml` that:
1. Runs only on `pull_request` events (not on `push` to develop/main) — enforced by `if: github.event_name == 'pull_request'` at job level, matching the existing `security` job's pattern.
2. Installs cargo-mutants via `cargo install cargo-mutants` (no GitHub Action dependency; avoids SHA-pin research burden in F4 and ongoing SHA-rotation maintenance).
3. Runs `cargo mutants --in-diff origin/${{ github.base_ref }} --file src/cli/issue/create.rs --file src/api/jira/bulk.rs --file src/types/jira/bulk.rs` to scope mutation to the three designated files and to restrict mutations to lines changed in the PR diff, amortizing cost on small PRs.
4. Exits non-zero if kill rate drops below 90%. cargo-mutants reports outcomes in `mutants.out/`; the kill-rate check can be implemented as a short shell script reading `mutants.out/missed.txt` and `mutants.out/caught.txt` line counts — or by using `--minimum-test-count` if a future cargo-mutants version supports a kill-rate flag directly.
5. Sets `timeout-minutes: 45` to handle full-file mutation runs on the 1,601-LOC `create.rs` file; with `--in-diff` scoping this will typically complete in 5-15 min on PRs that touch only a few lines, but the ceiling must accommodate baseline or broad-diff PRs.

**Why raw `cargo install` over `sourcefrog/cargo-mutants-action`:**

The GitHub Action wraps the same binary and offers no features beyond what raw invocation provides at this scope. It introduces one more pinned SHA to maintain per the project's StepSecurity convention (see #368). cargo-mutants installs in ~90s via `cargo install`; combined with `Swatinem/rust-cache` the binary itself is cacheable via the tools cache path. The raw pattern is already established in the project for similar tools (gitleaks uses a GitHub Action because it integrates with the Gitleaks cloud service; cargo-mutants has no equivalent service dependency).

### Option B: Extract to `.github/workflows/mutants.yml`

Unnecessary at this scope. A separate workflow file is warranted when a job has different trigger conditions, different permissions, or substantially different secrets from the host workflow. The `mutants` job shares the same trigger subset (`pull_request`), the same secrets (none needed), and the same permissions (`contents: read` default). Keeping it in `ci.yml` ensures it appears in the same PR status check group, simplifying reviewer experience.

### `--in-diff` scoping decision

`--in-diff origin/${{ github.base_ref }}` is the correct form for GitHub Actions PRs. This restricts mutation to lines that differ from the PR base branch, not to the entire file. On a PR that touches only `build_labels_edited_fields` (e.g., from #345), only mutants in that function are generated. On a PR that rewrites bulk.rs substantially, the full file is in scope. This is the correct amortization strategy and matches the issue's stated intent.

A consequence: PRs that do NOT touch any of the three scoped files will generate zero mutants, and the job will exit 0 immediately. This is correct behavior — no false failures, no wasted CI minutes.

### Kill-rate threshold enforcement

cargo-mutants does not natively support a percentage kill-rate exit code as of v24.x. The threshold must be computed from `mutants.out/caught.txt` and `mutants.out/missed.txt` counts via a shell one-liner. F4 should implement this as an inline shell step, not a separate script file, to keep the policy visible in the CI YAML. If cargo-mutants adds native threshold support before F4 begins, F4 should use it.

### `.mutants.toml` configuration scope

Recommended contents:
- `timeout_multiplier = 3.0` — prevents false "unviable" results on the bulk async code paths where single test timeout is short but mutation of `.await` chains can cause hangs.
- Explicit file scope (the three designated files) — ensures local `cargo mutants` invocations without flags still hit the correct scope.
- Do NOT set the kill-rate threshold in `.mutants.toml` — it belongs in the CI step's shell logic where it is most visible to reviewers.

---

## Regression Risk

| Component | Risk Level | Rationale |
|-----------|------------|-----------|
| `.github/workflows/ci.yml` | MEDIUM | Any syntax error in the YAML or incorrect `--in-diff` ref format silently breaks the new job. The existing jobs are unaffected by adding a new job (GitHub Actions jobs are independent). The `if: github.event_name == 'pull_request'` guard prevents the job from running on `push` to develop/main, bounding blast radius to PRs. Risk is mitigated by keeping the job structure identical to the existing `security` job which uses the same guard. |
| Kill-rate baseline miss | HIGH (first run only) | The issue scopes to `src/cli/issue/create.rs` (1,601 LOC), `src/api/jira/bulk.rs` (870 LOC), and `src/types/jira/bulk.rs` (284 LOC). The kill rate on first baseline run may be below 90%, particularly for defensive guard branches in `create.rs` that are exercised only by integration tests (which run in-process under cargo-mutants but may have timing sensitivity in async paths). F4 must run a local baseline before merging and either fix gaps or apply justified `#[mutants::skip]` whitelist annotations. |
| False-positive surviving mutants | MEDIUM | Two known surviving-mutant patterns are likely based on recent code: (1) `if remaining_keys.is_empty()` early-return guards in the bulk edit path — if the integration tests that exercise the early-return branch are slow or flaky under mutation, the mutant survives. (2) `has_more` guard-abort logic in `src/api/jira/issues.rs` — not in scope for this issue but the same pattern exists in the bulk path. F4 should specifically check `handle_edit_bulk_labels` and `handle_edit_bulk_fields` for boolean-flip mutants on guard conditions. |
| `#[mutants::skip]` whitelist misuse | LOW | If F4 whitelists surviving mutants without justification comments, the policy becomes unenforceable. The `cargo-mutants-policy.md` spec must establish that `#[mutants::skip]` requires a comment of the form `// mutants::skip: <reason>` before F4 applies any annotation. This is a convention risk, not a code risk. |
| `mutants.out/` artifact leakage | LOW | If `.gitignore` is not updated, `mutants.out/` (containing full mutation results including source snippets) could be committed accidentally. Single-line `.gitignore` addition is the entire mitigation. |
| CI cost overrun | LOW | With `--in-diff` scoping on typical PRs, the job cost is 5-15 min. The `timeout-minutes: 45` ceiling is sufficient for baseline-scope runs. If a PR replaces all three files wholesale (unlikely), the job will be long but not stalled. |
| `cargo install` cache miss | LOW | The first CI run that doesn't hit the Swatinem cache will install cargo-mutants from scratch (~90s). Subsequent runs with a warm cache will skip the install. This is the same tradeoff the project already accepts for `cargo-llvm-cov` via `taiki-e/install-action`. |
| Security surface | NONE | No new secrets required. No new network calls from the test harness. cargo-mutants modifies source files in-place and restores them — it does not execute arbitrary code outside the test suite. `github.event_name == 'pull_request'` guard matches existing `security` job pattern; no GITHUB_TOKEN permission escalation needed. |

### Likely surviving mutant patterns (preemptive call for F4)

Based on `src/cli/issue/create.rs` post-#340/#345 and `src/api/jira/bulk.rs`:

1. **Boolean-flag short-circuit in `handle_edit_bulk_labels`**: the `if adds.is_empty() && removes.is_empty()` bail check at the top of the function. The mutation `adds.is_empty() || removes.is_empty()` could survive if the integration tests do not exercise the case where exactly one of `adds`/`removes` is empty and the other is not, without the bail firing.

2. **`await_bulk_task` grace-period branch**: `JR_BULK_UNKNOWN_GRACE_SECS` is debug-only and exercised only in integration tests. A mutant that changes the grace-period comparison operator or the `Unknown` arm match could survive if the mutation timeout is shorter than the grace period under mutation. This is the most likely source of a below-90% result on first baseline.

3. **`build_labels_edited_fields` object-vs-array branch** (added by #345): the `if label_ops.len() == 1` branch. If the proptest added by #345 runs under cargo-mutants, it will catch this. If proptest strategies are not executed by cargo-mutants (proptest runs require the `proptest` feature and generate random inputs), this mutant may survive. F4 should verify that cargo-mutants exercises proptest-gated tests by checking whether `cargo test` (which cargo-mutants runs internally) includes proptest.

4. **`types/jira/bulk.rs` serde derives**: mutations to `#[serde(rename_all)]` or field name strings in derive attributes typically produce compile errors (unviable mutants), not survivors. These inflate the unviable count but do not reduce the kill rate. Expect ~20-40 unviable mutants from this file.

---

## Recommendation

**Scope: STANDARD**

CI job + CLAUDE.md documentation + `.gitignore` update + `.mutants.toml` config + `docs/specs/cargo-mutants-policy.md` + local baseline run with all surviving mutants either fixed or whitelisted with justification.

The issue author's "~1 hour for setup + initial gap-fixing" estimate implies STANDARD scope was intended. MINIMAL (job-only, defer baseline) would leave the PR in a state where the job could fail on merge of a later PR due to an unknown kill rate — that is the wrong order of operations. MAXIMAL (extracted workflow file, GitHub Action, project-wide config for all modules) is out of scope; the issue scopes explicitly to three files.

**Trivial-scope eligible? NO**

Multi-file change touching CI infrastructure (`ci.yml`), user-visible documentation (`CLAUDE.md`), developer-visible documentation (`docs/specs/`), project config (`.mutants.toml`), and `.gitignore`. The CI job itself requires a kill-rate threshold shell step that is non-trivial to validate without a baseline run. F4 will also need to address any surviving mutants (fix or whitelist), which constitutes non-trivial code review work. Does not qualify as trivial under F1 criteria.
