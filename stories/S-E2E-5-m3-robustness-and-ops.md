---
document_type: story
story_id: "S-E2E-5"
title: "E2E M3: suite robustness, secret-leak guard, and e2e-sweeper CI workflow"
wave: feature-followup
status: draft
intent: enhancement
feature_type: infrastructure
scope: trivial
severity: small
trivial_scope: false
issue: TBD
points: 3
priority: P2
tdd_mode: strict
estimated_effort: small
mode: feature
depends_on: []
bc_anchors: []
# BC delta: EMPTY — this story adds CI/ops hardening with no new product behavioral contracts.
# The sweeper workflow and failure classification are pure CI ops; the secret-leak guard is
# a test-infrastructure safety check. None of these assertions verify a behavioral contract
# in BC-INDEX.md.
# BC status: no BC authorship required.
# Status=draft: the spec-first gate (S-7.01) does not block dispatch for
# infrastructure-only stories with explicit justification above.
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: [NFR-T-E2E-1]
adr_refs: []
sd_refs: []
parent_phase: F3-story-decomposition
spec_source: "docs/specs/e2e-test-enhancements.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 7
created: "2026-05-30"
traceability_note: >
  BC delta is EMPTY. This story is pure CI/ops hardening: a sweeper workflow, failure
  classification in e2e.yml, a secret-leak guard gated test, a leak-detection log, and
  adoption of poll_jql for the create-then-search assertion. All traces are to NFR-T-E2E-1
  and design spec §7.1/§7.2. No BC-S.SS.NNN clause is verified by any AC in this story.
files_created:
  - .github/workflows/e2e-sweeper.yml   # NEW — daily sweeper, non-blocking, close-only
files_modified:
  - tests/e2e_live.rs     # MODIFIED — poll_jql adoption, secret-leak guard, leak-detection log
  - .github/workflows/e2e.yml  # MODIFIED — 401-vs-connection failure classification
breaking_change: false
assumption_validations: []
risk_mitigations: []
last_updated: "2026-05-30"
changelog:
  - date: "2026-05-30"
    phase: F3-story-decomposition
    author: story-writer
    summary: Initial story creation.
---

# S-E2E-5 — E2E M3: Suite Robustness, Secret-Leak Guard, and E2E Sweeper CI Workflow

## Source of Truth

Design spec: `/Users/zious/Documents/GITHUB/jira-cli/docs/specs/e2e-test-enhancements.md`
Sections: §7 (Milestone M3) — §7.1 Suite-side, §7.2 CI/ops
PRD delta: `.factory/phase-f2-spec-evolution/prd-delta-e2e-enhancements.md` (BC delta = EMPTY)
Predecessor stories: S-E2E-1 (PR #433), S-E2E-2 (PR #434)
Foundation: S-E2E-3 (provides `poll_jql`; this story adopts it and extends `e2e.yml`)

**No new BCs. Changes touch `tests/e2e_live.rs`, `.github/workflows/e2e.yml`, and a new
`.github/workflows/e2e-sweeper.yml`. Zero `src/` changes.**

## Dependency Justification

**S-E2E-5 has `depends_on: []`** — it is logically independent of S-E2E-3 and S-E2E-4. The
sweeper workflow and `e2e.yml` failure classification are entirely CI-side and do not depend on
any helper added by S-E2E-3. The only intra-E2E dependency is that AC-002 (adopt `poll_jql`)
requires `poll_jql` to be available in `tests/e2e_live.rs` — if S-E2E-3 has not yet landed, the
implementer can either stub `poll_jql` locally or sequence S-E2E-5 after S-E2E-3. In the wave
plan, S-E2E-5 is scheduled last ("logically last") but has no hard dependency.

## Goal

Harden the E2E suite against operational failure modes:

1. Adopt `poll_jql` to eliminate the latent flake in the create-then-search assertion.
2. Add a secret-leak guard (gated test) that ensures stdout/stderr never contain auth material.
3. Add a leak-detection log at suite start that warns (never fails) when orphaned open issues exist.
4. Create `e2e-sweeper.yml` — a daily CI workflow that closes orphaned E2E issues left by
   cancelled/aborted runs that skip the per-run teardown.
5. Improve `e2e.yml` failure classification to distinguish expired-token 401 from
   connection/site errors (different remediation paths).

## Traceability

| Traceability target | Type | Description |
|--------------------|------|-------------|
| NFR-T-E2E-1 | NFR (MEDIUM) | Obligation to keep the E2E suite runnable and wired into CI |
| Design spec §7.1 | Suite-side | `poll_jql` adoption, secret-leak guard, leak-detection log |
| Design spec §7.2 | CI/ops | `e2e-sweeper.yml`, `e2e.yml` failure classification |

## Behavioral Contracts

None — pure ops/CI. BC delta is EMPTY.

## Acceptance Criteria

### AC-001 — Adopt `poll_jql` for create-then-search assertion (traces to NFR-T-E2E-1; spec §7.1)

The existing create-then-search assertion in the write flow (or any equivalent test that
creates an issue and then searches for it by JQL) is updated to use `poll_jql` in
`SkipOnEmpty` mode instead of a bare `issue list --jql` call without retry.

Before this change: a bare `issue list --jql "project=<E2E> AND summary ~ e2e"` may return 0
results immediately after creation (JQL index lag is explicit in JRACLOUD-97427; lag can range
seconds to minutes). This is a latent flake — it passes in warm environments but fails on cold
indexing after first provisioning.

After this change: the assertion uses `poll_jql` in `SkipOnEmpty` mode. If the index is cold
and returns 0 results after the full poll budget, the test emits an `eprintln!` skip notice
and returns without failure (pure index lag, not a `jr` regression). If results appear, they
are validated normally.

**Requires S-E2E-3's `poll_jql`.** If S-E2E-3 has not landed yet, sequence this AC after S-E2E-3.

Spec reference: §7.1 — "Adopt **`poll_jql`** for the create-then-search assertion(s) (the
current summary-filter list test does not retry → latent flake on a cold index)."

### AC-002 — Secret-leak guard test (traces to NFR-T-E2E-1; spec §7.1)

`test_e2e_no_secret_in_output`: a new `#[ignore]`-gated test (with `e2e_enabled()` guard first)
that:

1. Extracts the base64 token from `JR_AUTH_HEADER` (the part after `"Basic "`).
2. Extracts the service-account email from `JR_E2E_EMAIL` env var (if set; if unset, skip the
   email check but still run the base64 check).
3. Runs one normal `--output json` command (e.g., `issue list --jql "project=<E2E> AND
   summary ~ e2e" --output json`).
4. Asserts that neither stdout NOR stderr contains the base64 token string.
5. If `JR_E2E_EMAIL` was set: asserts that neither stdout NOR stderr contains the email string.

This is a cheap, high-value, portable regression guard — a future code change that accidentally
logs auth headers will be caught by this test on the next live run.

**Verification:** `grep -n "test_e2e_no_secret_in_output" tests/e2e_live.rs` → 1 match.
`grep -n "e2e_enabled" tests/e2e_live.rs` count ≥ `grep -c "#\[ignore\]"` (meta-guard still
passes).

Spec reference: §7.1 — "run a normal `--output json` command and assert that neither stdout nor
stderr contains the base64 token or the service-account email. Cheap, high-value, portable."

### AC-003 — Leak-detection log at suite start (traces to NFR-T-E2E-1; spec §7.1)

A new always-run (NOT `#[ignore]`) function `log_orphaned_issue_count()` or equivalent is
called at the start of `test_every_ignored_test_has_gate_guard` (or as a separate always-run
test, ordered to run first alphabetically, e.g., `test_aaaaa_leak_detection_log`) that:

1. If `JR_RUN_E2E != "1"`: no-op (returns early; does NOT make any live call).
2. If `JR_RUN_E2E == "1"`: runs `issue list --jql "project=<E2E> AND summary ~ 'e2e' AND
   statusCategory != Done" --output json`; counts the array length; emits
   `eprintln!("E2E leak-detection: {} orphaned open E2E issues found", count)`.
3. NEVER fails (exits 0) regardless of the count. This is a warn-only signal visible in CI
   logs; it does not gate the suite.

**JQL correctness (F-02):** use `summary ~ "e2e"` (tokenized full-text; matches the `e2e` term
embedded in `[e2e <run_label>]` summaries). Do NOT use `labels ~ "e2e-"` — the `~` operator is
not supported on the `labels` field (HTTP 400).

**Best-effort only:** `summary ~ "e2e"` is tokenized, not substring/prefix — Jira strips
punctuation. Over-matching is acceptable in the dedicated disposable E2E project.

Spec reference: §7.1 — "count pre-existing **open** E2E issues via the best-effort `summary ~ 'e2e'`
predicate … `eprintln!` the number (warn-only, never fails) — visible drift signals a broken teardown."

### AC-004 — `e2e-sweeper.yml` workflow (traces to NFR-T-E2E-1; spec §7.2)

`.github/workflows/e2e-sweeper.yml` is created with:

```yaml
on:
  schedule:
    - cron: "0 7 * * *"   # 07:00 UTC daily (offset from main e2e.yml at 06:00)
  workflow_dispatch:

concurrency:
  group: jira-e2e          # shared serialization group with e2e.yml — never interleaves
  cancel-in-progress: false

jobs:
  sweep:
    runs-on: ubuntu-latest
    environment: jira-e2e
    timeout-minutes: 10
    permissions:
      contents: read
    if: github.event_name != 'pull_request'
    steps:
      - uses: actions/checkout@v4
      - name: Set up Rust
        uses: dtolnay/rust-toolchain@stable
      - name: Build jr (debug)
        run: cargo build
      - name: Compose auth header
        run: echo "JR_AUTH_HEADER=Basic $(printf '%s:%s' "${{ secrets.JR_E2E_EMAIL }}" "${{ secrets.JR_E2E_API_TOKEN }}" | base64 -w0)" >> "$GITHUB_ENV"
      - name: Sweep orphaned E2E issues
        env:
          JR_BASE_URL: ${{ vars.JR_E2E_BASE_URL }}
          JR_E2E_PROJECT: ${{ vars.JR_E2E_PROJECT }}
          JR_E2E_STATUS_DONE: ${{ vars.JR_E2E_STATUS_DONE }}
        run: |
          STATUS_DONE="${JR_E2E_STATUS_DONE:-Done}"
          for key in $(./target/debug/jr issue list \
            --jql "project=$JR_E2E_PROJECT AND summary ~ \"e2e\" AND statusCategory != Done AND created <= -1d" \
            --output json | jq -r '.[].key' 2>/dev/null || true); do
            ./target/debug/jr issue move "$key" "$STATUS_DONE" || true
          done
```

Verified field by field:
- `on.schedule.cron` is present (daily sweep, offset from `e2e.yml`'s 06:00 UTC).
- `on.workflow_dispatch` is present.
- `concurrency.group: jira-e2e` — SAME group as `e2e.yml` to serialize; never interleaves with
  the main run.
- `concurrency.cancel-in-progress: false`.
- `environment: jira-e2e` on the sweep job.
- `timeout-minutes: 10` (or lower; not absent or above 15).
- `if: github.event_name != 'pull_request'` on the job (belt-and-suspenders).
- JQL: `project=$JR_E2E_PROJECT AND summary ~ "e2e" AND statusCategory != Done AND created <= -1d`
  (best-effort tokenized match; NOT `labels ~ "e2e-"` which is invalid; `created <= -1d`
  excludes issues from the current run).
- `|| true` on both the `jq` pipeline and the `jr issue move` — best-effort, never fails the
  workflow.
- Close-only (transitions to Done); NO delete.

**JQL correctness (F-02):** `summary ~ "e2e"` is the correct tokenized predicate. Do NOT use
`labels ~ "e2e-"` (labels does not support the `~` operator; HTTP 400).

Verification:
- `grep -n "jira-e2e\|cancel-in-progress\|timeout-minutes" .github/workflows/e2e-sweeper.yml` → matches for all three.
- `grep -n "labels ~" .github/workflows/e2e-sweeper.yml` → 0 matches.
- `grep -n "pull_request_target" .github/workflows/e2e-sweeper.yml` → 0 matches.

Spec reference: §7.2 — "New `e2e-sweeper.yml` — scheduled daily, non-blocking, `concurrency: jira-e2e`
(shares the serialization group so it never interleaves with the main run). Closes
`project=$JR_E2E_PROJECT AND summary ~ "e2e" AND statusCategory != Done AND created <= -1d`."

### AC-005 — `e2e.yml` failure classification (traces to NFR-T-E2E-1; spec §7.2)

`.github/workflows/e2e.yml` is updated with a step that classifies the test run outcome:

- If the `cargo test` step exits non-zero and the test log contains HTTP 401 as the first
  failure: emit a distinct log message indicating "AUTH FAILURE — rotate the API token in the
  `jira-e2e` GitHub Environment before expiry" (different remediation from a connection error).
- If the `cargo test` step exits non-zero and there is no 401 but a connection/DNS error:
  emit a distinct log message indicating "CONNECTION FAILURE — the Jira site may have been
  deactivated due to inactivity (check the reactivation window)".
- Both messages appear in the workflow log and are distinguishable by log readers.
- The workflow itself remains non-blocking (no `required:` check; failure does not gate PRs).

Implementation note: this classification can be as simple as a shell `if/elif` in a
`if: failure()` step that greps the test output file or uses the existing step output.
Exact implementation is up to the implementer; the contract is that the two failure classes
produce distinct, actionable log messages.

Spec reference: §7.2 — "**`e2e.yml` failure classification**: distinguish a first-call **401**
(expired/revoked token → 'rotate token') from a **connection/site-not-found** error (possible
inactivity deactivation → 'reactivate site within the grace window'). Different remediation,
different log message."

### AC-006 — `test_every_ignored_test_has_gate_guard` still passes (traces to NFR-T-E2E-1; spec §9)

After all changes in this story, the always-run source meta-guard
`test_every_ignored_test_has_gate_guard` in `tests/e2e_live.rs` continues to exit 0 in
`cargo test --test e2e_live` (without `JR_RUN_E2E=1`). The new `test_e2e_no_secret_in_output`
gated test (AC-002) has `e2e_enabled()` as its first statement — the meta-guard enforces this.

The leak-detection log function (AC-003) is always-run (NOT `#[ignore]`) and does NOT need
`e2e_enabled()` — it returns early if `JR_RUN_E2E != "1"` by a different guard.

Verification: `cargo test --test e2e_live` (without env) exits 0.

### AC-007 — No `src/` changes (architecture boundary; spec §7.1)

`git diff --name-only HEAD` does NOT include any file under `src/`. All changes are in
`tests/e2e_live.rs` and `.github/workflows/`.

Verification: `grep -rn "poll_jql\|log_orphaned\|secret_in_output" src/` → 0 matches.

## Out of Scope

- Foundation helpers (`poll_jql`, shape matchers) — S-E2E-3.
- New gated command-family tests (transitions, changelog, assign, link, error paths) — S-E2E-4.
- Per-test wall-clock guard mapping hung calls to exit 124 — listed in spec §7.1 as "optional,
  low priority"; deferred.
- Any JSM expansion — declared non-goal in spec §2.
- Token-expiry early-warning step (~30 days before expiry) — listed in spec §8 as a future item.

## Implementation Strategy

**TDD order:**

1. **Leak-detection log (AC-003)** — add the always-run leak-detection function. Wire it up.
   Run `cargo test --test e2e_live` to confirm it passes (returns early without `JR_RUN_E2E=1`
   set, so no live call is made).

2. **Secret-leak guard test (AC-002)** — add the `#[ignore]`-gated `test_e2e_no_secret_in_output`.
   Verify `test_every_ignored_test_has_gate_guard` still passes.

3. **`poll_jql` adoption (AC-001)** — update the create-then-search assertion to use `poll_jql`
   in `SkipOnEmpty` mode. Requires S-E2E-3 to be merged first (or `poll_jql` to be present).

4. **`e2e-sweeper.yml` (AC-004)** — write the new workflow file. Verify grep checks.

5. **`e2e.yml` failure classification (AC-005)** — add the failure classification step to the
   existing workflow. Verify the step is behind `if: failure()` or equivalent.

6. **Final verification (AC-006–AC-007).** `cargo test --test e2e_live` exits 0.

**Branch:** `test/e2e-enhancements` (same feature branch as S-E2E-3/S-E2E-4; or a separate
commit if the implementer sequences this after S-E2E-3/S-E2E-4).

**Commit message:**
```
test(e2e): M3 robustness — secret-leak guard, poll_jql adoption, sweeper, failure classification
```

**PR target:** `develop`.

## Quality Gate Self-Check

| Criterion | AC | Notes |
|-----------|----|-------|
| `cargo test --test e2e_live` (no env) exits 0 | AC-006 | Meta-guard passes; leak-detection fn is always-run + early-returns |
| `grep -n "test_e2e_no_secret_in_output" tests/e2e_live.rs` → 1 match | AC-002 | Secret-leak guard present |
| `grep -n "e2e_enabled\(\)" tests/e2e_live.rs` count ≥ `grep -c "#\[ignore\]"` | AC-006 | Meta-guard invariant preserved |
| `cat .github/workflows/e2e-sweeper.yml` exists | AC-004 | Sweeper file created |
| `grep -n "jira-e2e\|cancel-in-progress\|timeout-minutes" .github/workflows/e2e-sweeper.yml` → ≥3 matches | AC-004 | Sweeper has concurrency group + cancel-in-progress + timeout |
| `grep -n "labels ~" .github/workflows/e2e-sweeper.yml` → 0 matches | AC-004 | No invalid JQL in sweeper |
| `grep -n "pull_request_target" .github/workflows/e2e-sweeper.yml` → 0 matches | AC-004 | No PR-target trigger |
| `grep -n "summary ~ " .github/workflows/e2e-sweeper.yml` → ≥1 match | AC-004 | Correct JQL predicate |
| `grep -n "AUTH FAILURE\|CONNECTION FAILURE\|rotate\|reactivate" .github/workflows/e2e.yml` → ≥2 matches | AC-005 | Distinct failure messages present |
| `grep -rn "poll_jql\|log_orphaned\|secret_in_output" src/` → 0 matches | AC-007 | No src/ contamination |
| `cargo test` exits 0 | smoke | Full suite green |
| `cargo fmt --all -- --check` exits 0 | lint | No format drift |
| `cargo clippy --all-targets -- -D warnings` exits 0 | lint | Zero warnings |
| `bash scripts/check-spec-counts.sh` exits 0 | invariant | No BC frontmatter changed |
| `bash scripts/check-bc-cumulative-counts.sh` exits 0 | invariant | No count surfaces touched |
| `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 | invariant | No BC bodies with numeric counts |

## Token Budget Estimate

| Item | Tokens (approx) |
|------|----------------|
| This story file | ~5 k |
| Design spec §7.1 + §7.2 (M3) | ~3 k |
| S-E2E-1 story (e2e.yml structure + concurrency conventions) | ~5 k |
| `tests/e2e_live.rs` current state (post S-E2E-3/S-E2E-4; ~950 LOC to read) | ~13 k |
| `.github/workflows/e2e.yml` current state (~80 LOC to read + modify) | ~2 k |
| Tool outputs (`cargo test`, `cargo clippy`, grep verifications, script exits) | ~3 k |
| BC files: 0 (none loaded — BC delta empty) | 0 |
| **Total** | **~31 k** |

Well within a single-agent context window (~200 k). No split required.
LOC delta: `tests/e2e_live.rs` +~40 LOC; `.github/workflows/e2e-sweeper.yml` +~50 LOC new;
`.github/workflows/e2e.yml` +~15 LOC. Zero `src/` LOC changes.

## Tasks

- [ ] Confirm branch `test/e2e-enhancements` is current; read `tests/e2e_live.rs` in full
- [ ] Read `.github/workflows/e2e.yml` — understand current structure before modifying
- [ ] Read S-E2E-1 `.github/workflows/` section — understand concurrency/environment conventions
- [ ] Add always-run leak-detection log function (AC-003): early-return if `JR_RUN_E2E != "1"`;
  run JQL `project=<E2E> AND summary ~ "e2e" AND statusCategory != Done`; `eprintln!` count
- [ ] `cargo test --test e2e_live` — exits 0 (leak-detection fn always-run, returns early without env)
- [ ] Add `#[ignore]`-gated `test_e2e_no_secret_in_output` (AC-002): extract base64 token from
  `JR_AUTH_HEADER`; optionally extract email from `JR_E2E_EMAIL`; run one live command; assert
  neither token nor email in stdout or stderr
- [ ] `cargo test --test e2e_live` — exits 0 (meta-guard passes with new gated test)
- [ ] Update the existing create-then-search assertion to use `poll_jql` in `SkipOnEmpty` mode (AC-001)
- [ ] `cargo test --test e2e_live` — exits 0
- [ ] Create `.github/workflows/e2e-sweeper.yml` (AC-004): daily cron offset from e2e.yml;
  `concurrency: jira-e2e`; `cancel-in-progress: false`; `environment: jira-e2e`;
  `timeout-minutes: 10`; `if: github.event_name != 'pull_request'`; sweep JQL with `summary ~ "e2e"`;
  `|| true` on both jq and move; close-only
- [ ] Verify `grep -n "labels ~" .github/workflows/e2e-sweeper.yml` → 0 matches (AC-004)
- [ ] Verify `grep -n "pull_request_target" .github/workflows/e2e-sweeper.yml` → 0 matches (AC-004)
- [ ] Verify `grep -n "summary ~ " .github/workflows/e2e-sweeper.yml` → ≥1 match (AC-004)
- [ ] Add failure classification step to `.github/workflows/e2e.yml` (AC-005): `if: failure()`;
  grep test output for 401 vs connection error; emit distinct actionable log messages
- [ ] Verify `grep -n "AUTH FAILURE\|CONNECTION FAILURE\|rotate\|reactivate" .github/workflows/e2e.yml` → ≥2 matches
- [ ] Verify `grep -rn "poll_jql\|log_orphaned\|secret_in_output" src/` → 0 matches (AC-007)
- [ ] `cargo test --test e2e_live` — exits 0 (meta-guard + leak-detection + unit tests all pass)
- [ ] `cargo test` — exits 0
- [ ] `cargo fmt --all -- --check` — exits 0
- [ ] `cargo clippy --all-targets -- -D warnings` — exits 0
- [ ] `bash scripts/check-spec-counts.sh && bash scripts/check-bc-cumulative-counts.sh && bash scripts/check-bc-no-numeric-test-counts.sh` — all exit 0
- [ ] Commit: `test(e2e): M3 robustness — secret-leak guard, poll_jql adoption, sweeper, failure classification`

## Previous Story Intelligence

**Predecessor: S-E2E-1 (PR #433)** — provides `e2e.yml` structure, concurrency group conventions,
and the `jira-e2e` Environment. The sweeper workflow mirrors the same conventions exactly.

**Predecessor: S-E2E-2 (PR #434)** — FIX-C lesson: always-run tests that assert environmental
state (`JR_RUN_E2E != "1"`) are structurally fragile. The leak-detection log function avoids
this by checking `JR_RUN_E2E` via a normal env-var read and returning early, not by asserting
the absence of the var in an always-run test.

**From S-E2E-3 (dependency context):** `poll_jql` in `SkipOnEmpty` mode is the correct API
for AC-001. The existing create-then-search test will wrap its bare `issue list` call with
`poll_jql("... AND summary ~ e2e ...", ..., SkipOnEmpty)`.

**JQL correctness lesson (spec §7.2 F-02):** the `labels` field does NOT support `~` (CONTAINS)
in JQL. Use `summary ~ "e2e"` for the sweeper and leak-detection log. Do NOT use `labels ~ "e2e-"`.
This is enforced by a grep check in the quality gate self-check.

**Atlassian search-lag context (JRACLOUD-97427):** the summary `~` predicate is tokenized
full-text, not substring. The `[e2e ...]` bracket is stripped; Jira matches on the `e2e` token.
Over-matching in the dedicated disposable E2E project is acceptable — the sweeper is a backstop,
not a precise selector.

## Architecture Compliance Rules

1. **Zero `src/` changes.** All changes are in `tests/e2e_live.rs` and `.github/workflows/`.
   If any `src/` change is needed, STOP and escalate.

2. **Sweeper uses the same `concurrency: jira-e2e` group as `e2e.yml`.** This serializes the
   sweeper with the main run and prevents interleaving. Do NOT use a different group name.

3. **No `pull_request_target` in `e2e-sweeper.yml`.** Same security constraint as `e2e.yml`.

4. **Sweeper JQL uses `summary ~ "e2e"`, NOT `labels ~ "e2e-"`.** The latter is invalid JQL
   (HTTP 400). Enforced by grep check AC-004.

5. **Sweeper is close-only (no delete) and best-effort (`|| true`).** Individual move failures
   must not abort the sweep loop. The sweeper is a backstop cleanup, not a correctness gate.

6. **Leak-detection log always-run function MUST NOT make live calls when `JR_RUN_E2E != "1"`.**
   It reads the env var and returns early. It is NOT a `#[ignore]`-gated test. It is NOT subject
   to `e2e_enabled()` because it IS always-run (gating it would defeat the purpose of a
   "always-run leak detector").

7. **`e2e.yml` remains non-blocking.** The failure classification step uses `if: failure()` to
   add informational log messages. It does NOT set a status check. The workflow itself does not
   become a required check on any branch.

## Library & Framework Requirements

No new `Cargo.toml` dependencies.

| Crate/Tool | Already available | Usage in this story |
|------------|------------------|---------------------|
| `serde_json` | Yes (dev-dep) | JSON parsing in secret-leak guard (AC-002) |
| `assert_cmd` | Yes (dev-dep) | Subprocess invocation (unchanged) |
| `std::env` | stdlib | `JR_AUTH_HEADER`, `JR_E2E_EMAIL`, `JR_RUN_E2E` reads |
| `jq` (CI tool) | Yes (in ubuntu-latest) | `jq -r '.[].key'` in sweeper step |
| GitHub Actions `actions/checkout@v4` | Yes (existing) | Checkout in sweeper |
| `dtolnay/rust-toolchain@stable` | Yes (existing) | Rust setup in sweeper |

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `tests/e2e_live.rs` | MODIFY | Add leak-detection fn (~10 LOC) + secret-leak guard test (~20 LOC) + `poll_jql` adoption (~5 LOC change) |
| `.github/workflows/e2e-sweeper.yml` | CREATE | Daily sweeper workflow (~50 LOC) |
| `.github/workflows/e2e.yml` | MODIFY | Add failure classification step (~15 LOC) |

**Files NOT to create or touch:** All of `src/`, `Cargo.toml`, `deny.toml`,
`.github/workflows/ci.yml`, `.github/workflows/release.yml`, `CLAUDE.md` (no new JR_* env vars
in this story — all env vars were documented in S-E2E-1/S-E2E-3), `tests/common/`, all snapshot
files, all other `tests/*.rs` files, `STORY-INDEX.md` (state-manager updates that), all BC
count surfaces.

## Branch / PR Plan

- Branch: `test/e2e-enhancements`
- Target: `develop`
- Commit: `test(e2e): M3 robustness — secret-leak guard, poll_jql adoption, sweeper, failure classification`
- PR body: reference this story (S-E2E-5), design spec §7, S-E2E-3 (poll_jql), and S-E2E-1
  (sweeper mirrors e2e.yml conventions)
- CHANGELOG entry: Add under `[Unreleased]` — "Hardened E2E suite (M3): secret-leak guard
  test, `poll_jql` adoption for create-then-search, daily orphan sweeper
  (`.github/workflows/e2e-sweeper.yml`), and `e2e.yml` 401-vs-connection failure classification."
