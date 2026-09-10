## Fresh-eyes PR review — PR #796

**Verdict: APPROVE.** No blocking findings. One SUGGESTION and three NITs, none of which need to hold up the merge.

Scope reviewed: `git diff cef4a021..92da86cc` — 4 files, +62/-32. Base (`develop`) is at `cef4a021`, identical to this PR's merge-base, so the tested tree is the merged tree (relevant given `strict: false` on `develop`).

---

### What I verified (not a rubber stamp)

| Check | Result |
|---|---|
| `cargo clippy --tests --all-features -- -D warnings` on PR head | clean |
| `cargo test --test e2e_cli_surface_guard` | 10/10 pass — `jr api` path still declared in `SURFACE`; parser-consistency guard did not flag the new `mention_account_id` invocation |
| `cargo test --test claude_md_citations` | 61/61 pass |
| `cargo test --test e2e_live` (offline guards) | 30 pass / 77 ignored — incl. `test_every_ignored_test_has_gate_guard` and `test_no_test_function_exceeds_line_budget` (the latter matters: the four skip messages grew) |
| `actionlint .github/workflows/e2e.yml` | exit 0 |
| YAML duplicate-key scan (strict PyYAML loader that raises on any duplicate mapping key) | none; the 4 new keys land at the correct 10-space indent inside the `Run live E2E tests` step's `env:` mapping, sourced from `${{ vars.* }}` (not `secrets.*`) and never spliced into a `run:` body |
| Every new `e2e.yml` comment vs. the code it describes | accurate — `JR_E2E_PARENT_KEY`/`JR_E2E_CHILD_TYPE` really are independently `_ => return` gated (so "both must be set" holds), `JR_E2E_EDIT_FIELD` really requires a `=` (`Ok(f) if f.contains('=')`), and `JR_E2E_JSM_RESOLUTION` really is checked first in `jsm_discover_resolution` before the `jr issue resolutions` fallback |
| `mention_account_id` precedence | env override first (trimmed, non-empty) → `return`; only then `/myself`. Matches both the rustdoc and the CLAUDE.md / spec prose exactly |
| Clean-skip semantics still correct | yes — `fetch_raw` returns `None` on spawn failure, non-zero exit, or unparseable JSON, so `mention_account_id` → `None` → early return with a `[SKIP]` line, never a panic or a false-green |
| Teardown for the now-actually-running tests | unchanged and adequate — `MentionCommentDropGuard` on the comment path, `--label e2e-<run_id>` + `best_effort_close` on create/edit, `jsm_self_close` on the JSM path |
| Commit hygiene | two cleanly-scoped Conventional Commits; commit 1 is tests+docs only, commit 2 is `e2e.yml` only. Diff is 94 lines total, well under the 500-line flag |
| PR description vs. diff | accurate, including the "no `src/` change" claim (`git diff --stat` confirms: no `src/` file touched) |

The core design call is sound. A self-mention proves exactly what VP-674-014/015/016/017 exist to prove — that live Jira accepts and persists a `mention` ADF node carrying a given `accountId` — and the round trip is genuinely independent of whose accountId it is. Trading an out-of-band manual variable for a runtime `/myself` lookup is the right call for tests that have silently never executed.

---

### Findings

| # | Severity | Category | Finding |
|---|---|---|---|
| 1 | suggestion | missing | `JR_E2E_MENTION_ACCOUNT_ID` is documented as a settable `jira-e2e` environment variable but is not threaded through `e2e.yml` — the documented override is unreachable in CI |
| 2 | nit | description | The four `[SKIP]` messages describe a narrower condition than the one that actually triggers them |
| 3 | nit | coherence | `mention_account_id` runs the same `/myself` lookup four times per suite run |
| 4 | nit | coherence | In the JSM test, the harness/mention-target resolution was hoisted above the `JR_E2E_JSM_PROJECT` gate |

#### 1. `JR_E2E_MENTION_ACCOUNT_ID` override is documented but not wired into `e2e.yml` — SUGGESTION

`docs/specs/e2e-live-jira-testing.md` §8 — the table headed *"Configuration inventory (GitHub Environment `jira-e2e`)"* — now lists `JR_E2E_MENTION_ACCOUNT_ID` as `variable (optional override)` and instructs the reader in bold: *"**Set this var** only to mention a different CONTROLLED test account instead."* CLAUDE.md carries the same claim. But `JR_E2E_MENTION_ACCOUNT_ID` appears nowhere in `.github/workflows/e2e.yml` (`grep MENTION` → no match), so a maintainer who follows that instruction and sets the variable will see no effect: the tests will keep self-mentioning, silently.

This is a pre-existing gap (the variable was never wired), so it is not a defect this PR introduces, and I am not blocking on it. I am raising it because it is *the same defect class commit `92da86cc` exists to fix* — its own message says these vars were "documented and read by the test suite but never actually wired into the workflow's `env:` block" — and because commit `c0322efc` strengthens the doc's assertion that the override is available. Fixing it is one line in the block this PR already edits:

```yaml
          # Optional override: a CONTROLLED test account's accountId to mention instead of
          # the authenticated CI account. Unset → the four test_e2e_mention_* tests
          # self-discover the target via GET /rest/api/3/myself (self-mention default).
          JR_E2E_MENTION_ACCOUNT_ID: ${{ vars.JR_E2E_MENTION_ACCOUNT_ID }}
```

Alternatively, if leaving it unwired is deliberate (e.g. you want the self-mention path to be the only CI behavior), say so in the doc row so the bolded "Set this var" instruction isn't misleading. Either resolution is fine; the current state — documented-as-settable, not settable — is the one to avoid.

#### 2. `[SKIP]` messages name a narrower cause than the one that fires them — NIT

All four messages read `... and GET /rest/api/3/myself returned no accountId ...`. `mention_account_id` also returns `None` when `fetch_raw` fails to spawn the subprocess, gets a non-zero exit, or cannot parse the stdout as JSON — none of which is "returned no accountId". Operationally nothing is lost, because `fetch_raw` already prints a `[WARN] fetch_raw: ...` line naming the real cause immediately above. Worth noting that the rustdoc on `mention_account_id` gets this exactly right (*"the `/myself` lookup fails or carries no `accountId`"*) — it is only the four user-facing strings that narrow it. Something like `... and GET /rest/api/3/myself did not yield an accountId ...` would cover both.

#### 3. Four identical `/myself` subprocess calls per run — NIT

`mention_account_id(&h)` is called once per test, so a full live run spawns `jr api /rest/api/3/myself` four times with an identical result. Harmless — the suite runs `--test-threads=1` and this is a trivial authenticated GET, matching the PR's own "negligible" assessment. A `static OnceLock<Option<String>>` would collapse it to one if you ever want it; not worth churning the diff for now.

#### 4. JSM test: mention-target resolution hoisted above the JSM-project gate — NIT

In `test_e2e_mention_jsm_create_roundtrip`, `let h = e2e_harness();` + `mention_account_id(&h)` now sit ahead of the `JR_E2E_JSM_PROJECT` check. When that variable is unset, the test now pays for a `/myself` round trip before skipping, and reports the mention-target skip reason rather than the more specific "JSM project not configured" one. Cosmetic only, and moot in the canonical repo where `JR_E2E_JSM_PROJECT=EJ` is set. The equivalent hoist in the other three tests is *required* (the harness is now a parameter) and correct; only here is the gate ordering swappable, and only here does swapping buy anything.

---

### Checklist results

1. **Diff coherence** — PASS. Two commits, cleanly separated, both on-topic. No unrelated changes; no `src/` touched.
2. **Description accuracy** — PASS. Every claim I spot-checked (clippy clean, 10/10 + 61/61 guards, actionlint exit 0, no `src/` diff, additive-only `env:` keys) holds.
3. **Test coverage** — PASS (with the caveat inherent to the change). No new offline test is possible here: the whole point is a live-Jira-gated path. The offline guards that *can* cover it (`e2e_cli_surface_guard`, `test_every_ignored_test_has_gate_guard`, `test_no_test_function_exceeds_line_budget`) all pass, and the PR body records an orchestrator-run live verification of the self-discovery path.
4. **Demo evidence** — N/A, correctly declared. Not a story, no ACs to demo, no product behavior change. The live-Jira dry-run write-up under Test Evidence is the right substitute.
5. **Commit quality** — PASS. Conventional Commits, scoped subjects, informative bodies.
6. **Diff size** — PASS. 94 lines across 4 files.
7. **Missing changes** — see finding 1 (the one thing the diff arguably should have included, non-blocking).
8. **Dependency status** — PASS. #674/#794/#795 are all merged; branch is even with `develop` at `cef4a021`, `MERGEABLE`, no rebase needed.

---

**Verdict: APPROVE.** Merge when CI is green. Finding 1 is worth resolving either here or in a follow-up — your call which.
