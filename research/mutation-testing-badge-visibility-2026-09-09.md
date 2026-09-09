# Research: Surfacing an Advisory Nightly Mutation-Testing Signal (cargo-mutants) on GitHub

**Type:** general (technology / CI reporting)
**Date:** 2026-09-09
**Author:** research agent
**Repo:** `jr` (Zious11/jira-cli), Rust CLI
**Status:** complete

## Context

The repo has two mutation-testing signals from `cargo-mutants`:

1. **Per-PR blocking gate** — diff-scoped (`--in-diff`), N=8 shards, pooled kill-rate
   `>= 90%`, wired into the required `ci-gate` in `.github/workflows/ci.yml`. Already
   covered by the existing `CI` status badge (`ci.yml/badge.svg`).
2. **Nightly advisory run** — `.github/workflows/mutants-nightly.yml`: full (non-diff)
   scope, N=16 shards, cron `0 8 * * *`, pools the kill rate in a
   `mutants-nightly-report` job whose summary step **always `exit 0`** and only emits a
   `::warning::` if the rate is `< 90%`. It is deliberately never wired into
   `ci-gate.needs` and must never block a merge.

**The problem:** a naive GitHub Actions workflow-status badge for the nightly would be
**misleading** — because the workflow always exits 0, the badge would be permanently
green regardless of the actual kill rate. We need an *honest* way to surface signal (2).

Existing README badges (verified in `README.md`): GitHub Actions `badge.svg` for CI and
E2E, `img.shields.io/github/v/release` (release + pre-release), static shields badges
(License MIT, MSRV 1.85), and codecov.

Verified repo detail: the nightly workflow already computes exactly the number we'd want
to surface. `mutants-nightly-report` prints two lines to the job log today:
`Nightly pooled summary: <caught> caught / <missed> missed / …` and
`Nightly pooled kill rate: <N>% (target >= 90%, advisory only …)`. It does **not** yet
write `$GITHUB_STEP_SUMMARY` and does **not** publish the number anywhere durable.

---

## Q1 — Does cargo-mutants have native badge / dashboard / kill-rate reporting?

**No native badge or dashboard.** As of the current release, cargo-mutants has no
built-in badge, web dashboard, or published "mutation score" metric. Reporting is
terminal output plus files written to the `mutants.out/` directory. The official "Using
the results" docs describe outcomes and iteration but define no badge, dashboard, or
named score. [1][2]

**Version verification (done against actual current docs, not training data):**
- Latest tagged release is **27.1.0, released 2026-06-02**. [3][4] There is an
  "Unreleased" section in the changelog above 27.1.0, but no newer tagged release as of
  2026-09-09. A third-party tracker independently lists `v27.1.0 (2026-06-02)`. [5]
- **This matches the repo's pin** — `mutants-nightly.yml` installs
  `cargo-mutants@27.1.0` via `taiki-e/install-action`. The pin is current, not stale.
  (Note: an early Perplexity pass reported 26.2.0 / 2026-01-31 as "latest"; that was
  stale — the changelog confirms 27.0.0 on 2026-03-07 and 27.1.0 on 2026-06-02
  superseded it. Flagging the conflict and siding with the primary changelog source.)

**Machine-readable outputs (the raw material for any external metric).** `mutants.out/`
contains: [6]
- `outcomes.json` — results for all tested mutants, **summary counts by outcome**, and
  the cargo-mutants version. (This is exactly what the nightly workflow already uploads
  per shard and re-pools via `jq '.caught // 0'` etc.)
- `mutants.json` — description of every generated mutant.
- `caught.txt`, `missed.txt`, `timeout.txt`, `unviable.txt`, `previously_caught.txt`.
- `lock.json`, `diff/`, `logs/`.

The docs warn the directory layout and file formats **may change between versions**, so
any tooling built on them should tolerate schema drift. [6] (The repo already does this
defensively: `jq '.caught // 0'` with numeric-regex guards.)

**Conclusion:** there is no native badge to adopt. Any badge/metric must be computed by
CI (which this repo already does) and surfaced by a mechanism external to cargo-mutants.

---

## Q2 — The honest way to badge a numeric CI-computed metric (shields.io)

Two shields.io badge families fit a computed number that isn't a simple pass/fail:

### Endpoint badge
`https://img.shields.io/endpoint?url=<URL-to-your-JSON>`. Shields fetches your JSON and
renders it. Your JSON must follow the Shields schema: [7]
```json
{ "schemaVersion": 1, "label": "mutation", "message": "92%", "color": "brightgreen" }
```
- `schemaVersion`: required, currently must be `1`.
- `label`: required left text (empty string omits the left side).
- `message`: required right text, **cannot be empty**.
- `color`: optional (default `lightgrey`); named color or hex/rgb/hsl.
- `labelColor`: optional.

Because CI controls `color`, you can encode a threshold: e.g. `brightgreen >= 90`,
`yellow >= 75`, `red` below. The color is computed once, in CI, alongside the number.

### Dynamic JSON badge
`https://img.shields.io/badge/dynamic/json?url=<URL>&query=$.killRate&suffix=%`.
Shields reads an arbitrary JSON doc and extracts one value via a JSONPath `query`;
presentation (`label`, `prefix`, `suffix`, `color`, style) is set via query params. [8]
Useful when a public JSON already exists in another shape. For threshold coloring the
**endpoint** form is usually easier (CI computes the color once).

### Where the JSON has to live (publish target)
Shields must fetch the endpoint **anonymously**, so the JSON must be public. Options: [7][8][9][10]

| Target | How | Pros | Cons / cost |
|---|---|---|---|
| **GitHub Gist** (via `schneegans/dynamic-badges-action`) | Action writes Shields JSON to a gist; README points endpoint badge at the raw gist URL | No commits in repo; stable raw URL; simplest to wire | **Requires a PAT with `gist` scope** stored as `GIST_SECRET`; a write-capable credential now lives in a scheduled workflow; external resource to preserve; may also need Dependabot secret |
| **Orphan `badges`/`metrics` branch** | CI commits `mutation.json` to a dedicated branch; badge points at `raw.githubusercontent.com/.../badges/mutation.json` | Data owned by repo; auditable history; no external token if using repo write perms | CI needs repo write; concurrent runs can race/force-push; generated commits can trigger workflows unless filtered |
| **GitHub Pages** | Deploy JSON to `OWNER.github.io/REPO/mutation.json` | Clean stable origin; good if docs already publish | Pages deploy adds config/complexity; propagation/caching lag; file is public |

### `schneegans/dynamic-badges-action`
The de-facto action for the gist route. Inputs: `auth` (the token), `gistID`, `filename`,
`label`, `message`, `color`. It writes the `schemaVersion:1` JSON to the gist for you. [10][11]
```yaml
- uses: schneegans/dynamic-badges-action@<pinned-sha>
  with:
    auth: ${{ secrets.GIST_SECRET }}     # PAT with `gist` scope
    gistID: ${{ vars.GIST_ID }}          # not secret → repo variable
    filename: mutation.json
    label: mutation (nightly)
    message: 92%
    color: brightgreen
```
Gist ID is public (repo variable); the PAT is the sensitive part.

### Security / maintenance tradeoffs (the crux for an *advisory* metric)
- The gist PAT is a **write-capable credential** that would now sit in a `schedule`-triggered
  workflow. Must be a dedicated, `gist`-scoped, rotatable token; must never be exposed to
  fork-PR workflows. This repo's `harden-runner` egress-audit posture and its heavy
  ci-gate supply-chain discipline mean adding a new PAT is a real, reviewable increase in
  attack surface — not free.
- Shields / raw.githubusercontent / Pages all cache; a fresh value may lag.
- A badge is an **asynchronously published artifact**, not the result of the latest commit
  — for a *nightly* metric that's actually fine (it's inherently a rolling snapshot), but
  the badge should link to the workflow run so viewers can inspect the source.
- **Verdict for this repo:** a full dynamic-badge pipeline is honest and looks polished,
  but the PAT + publish-target + caching machinery is **disproportionate for an advisory,
  never-blocking metric** whose primary audience is maintainers, not badge-scanning users.

---

## Q3 — What comparable Rust OSS projects actually do

Evidence (flagged where inconclusive): [12][13][14]
- **cargo-mutants itself** (`sourcefrog/cargo-mutants`) runs incremental (`branch-mutants`,
  `pr-mutants`) and a sharded full job in Actions, and **archives `mutants.out` via
  `actions/upload-artifact`**. Its README and workflow show **no mutation-score badge and
  no dedicated job-summary report** — results live in workflow logs + downloadable
  artifacts. This is the reference project and it deliberately does **not** badge a score. [12][13]
- Other indexed repos (e.g. `tgies/uls`) add "incremental PR + weekly full" cargo-mutants
  CI, but the retrieved material did not expose whether they badge/summary/doc it —
  **inconclusive** for those. [14]
- **tokio / ripgrep:** could **not** verify from search that they currently run
  cargo-mutants at all; no reliable statement possible. (Absence of evidence, not evidence
  of absence.)

**General finding:** a continuously-updated README mutation-score badge is **uncommon** in
the Rust ecosystem. The prevailing pattern is artifact-oriented (upload `mutants.out`) plus
log output; a job summary of killed/survived/timeout counts is the "nice but less common"
step up; a live badge is rare. Maintainers frequently *avoid* a mutation-score badge on
purpose because the number legitimately fluctuates with tool version, test nondeterminism,
exclusions, and diff-vs-full scope — exactly the volatility that would make a badge noisy.

---

## Q4 — Is `$GITHUB_STEP_SUMMARY` the idiomatic home for an advisory per-run metric?

**Yes.** `$GITHUB_STEP_SUMMARY` is the idiomatic place for an advisory, per-run metric
(kill rate, coverage, bench numbers) that should be visible to reviewers **without**
becoming a status check or a permanently-green badge. Writing a summary does **not** create
a pass/fail check — presentation is decoupled from enforcement, which is exactly the honest
property we want here. [15]

Capabilities / conventions: [15]
- Renders GitHub-flavored Markdown: headings, tables, lists, links, bold/italic,
  blockquotes, inline + fenced code.
- **1 MiB per step** limit; exceeding it fails the summary upload with an annotation but
  does **not** change step/job status.
- Use `if: always()` on the reporting step so the summary publishes even after upstream
  failures (the nightly's report job already runs `if: always()`).
- Keep it compact: headline number + small table + a "this is advisory" note + a link to
  the run/artifacts. Put big reports in artifacts (this repo already uploads per-shard
  `outcomes.json` with 7-day retention).
- Idiomatic shape example:
  ```bash
  {
    echo "## Nightly mutation testing (full scope, advisory)"
    echo
    echo "| Metric | Value |"
    echo "|---|---:|"
    echo "| Caught / Missed / Timeout / Unviable | ${caught_total} / ${missed_total} / ${timeout_total} / ${unviable_total} |"
    echo "| Pooled kill rate | **${kill_rate}%** (target ≥ 90%) |"
    echo
    echo "_Advisory only — this workflow never fails a merge._"
  } >> "$GITHUB_STEP_SUMMARY"
  ```

The step summary appears on the run's summary page, per job/step — precisely where a
maintainer who opens the nightly run expects to see the headline number, and where nobody
mistakes it for a merge gate.

---

## Q5 — Recommendation for THIS repo

Ranked by the repo's own stated priorities (honesty first, then effort, then maintenance):

### 1. TOP: `$GITHUB_STEP_SUMMARY` line in the existing `mutants-nightly-report` job
Add the pooled counts + kill rate (the numbers the job already computes) to
`$GITHUB_STEP_SUMMARY`, ideally with a small table and an explicit "advisory only" note.
- **Honesty:** highest. It's a per-run snapshot, not a static claim; it cannot show
  fake-green because it isn't a status check at all. It reports the true number even when
  it's below 90%.
- **Effort:** minimal — one extra block appended to the report step that already pools the
  data. No new secret, no publish target, no README change strictly required.
- **Maintenance / security:** ~zero. No PAT, no new attack surface, no caching, nothing to
  rotate — which matters given this repo's supply-chain-hardened CI posture.
- **Fit:** matches what the reference project (cargo-mutants itself) and the broader Rust
  ecosystem actually do — surface in-run, don't badge a volatile score.

### 2. Pair the top choice with a short prose docs section (near-free add-on)
Add a few lines to `README.md` (or `docs/specs/cargo-mutants-policy.md`) stating: the PR
gate is the enforced 90% signal (already badged via `CI`), and the nightly full-scope run
is advisory — where to find it (link to `mutants-nightly.yml` runs) and that the headline
number is in each run's job summary. This is the honest substitute for a nightly badge:
it points readers at the real signal without a misleading green square. Effort trivial,
maintenance nil.

### 3. Dynamic shields endpoint badge (gist via `schneegans/dynamic-badges-action`)
Only if a visible, color-coded README number is genuinely wanted. It *is* honest (shows
the real percentage with threshold color), but it introduces a `gist`-scoped PAT in a
scheduled workflow, a publish target to maintain, and caching lag — **disproportionate for
an advisory metric** and an increase in credential attack surface this repo otherwise
avoids. If ever adopted, prefer the gist route (no repo-write, no orphan-branch race),
pin the action by SHA, use a dedicated rotatable token, and keep it out of fork-PR
contexts. Recommend **deferring** unless there's explicit demand for a README number.

### 4. SKIP: a naive GitHub Actions workflow-status badge for the nightly
Explicitly reject. Because `mutants-nightly-report` always `exit 0` by design, a
`mutants-nightly.yml/badge.svg` would be **permanently green regardless of the actual kill
rate** — the exact misleading "fake-green" outcome to avoid. Do not add it. (If a
workflow-status badge were ever wanted, it would require making the report step fail below
threshold — which contradicts the whole advisory design and would turn the nightly into a
merge-adjacent gate.)

### Bottom line
Do **#1 + #2**: emit the pooled kill rate to `$GITHUB_STEP_SUMMARY` in the nightly report
job and add a short prose note pointing maintainers to it. That is the honest, near-zero-
effort, zero-new-secret path that matches ecosystem norm and this repo's security posture.
Treat the dynamic shields badge (#3) as an optional future enhancement, not now. Never add
the naive nightly status badge (#4).

*(Per task scope: this is research only — no workflow, README, or source file was modified.)*

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 (timed out at 300s) | Attempted single-pass deep synthesis of all 5 questions; timed out, so decomposed into targeted `perplexity_ask`/`perplexity_search` calls below |
| Perplexity perplexity_ask | 4 | (a) cargo-mutants native badge/output/version; (b) shields endpoint vs dynamic JSON badges, publish targets, gist PAT, tradeoffs; (c) `$GITHUB_STEP_SUMMARY` idiom/capabilities/limits; (d) what comparable Rust OSS projects do |
| Perplexity perplexity_search | 1 | Verify current cargo-mutants release version/date against changelog + trackers |
| Read | 2 | `mutants-nightly.yml` (actual workflow under study), `README.md` (existing badge inventory) |
| Glob | 1 | Locate README |
| Training data | 0 areas | Version and feature claims verified against live sources; not relied on |

**Total MCP tool calls:** 6 (1 research attempt [timed out] + 4 ask + 1 search)
**Training data reliance:** low — cargo-mutants version (27.1.0 / 2026-06-02), output
files, shields schema, and `$GITHUB_STEP_SUMMARY` behavior are all sourced from live
docs/changelog; version conflict between sources was flagged and resolved against the
primary changelog.

## Sources
1. cargo-mutants — Using the results: https://mutants.rs/using-results.html
2. cargo-mutants — Display and output: https://mutants.rs/output.html
3. cargo-mutants changelog (27.1.0 = 2026-06-02): https://mutants.rs/changelog.html
4. cargo-mutants releases: https://github.com/sourcefrog/cargo-mutants/releases
5. dev.co cargo-mutants overview (independent version tracker): https://dev.co/testing/open-source/cargo-mutants
6. cargo-mutants — `mutants.out` directory reference: https://mutants.rs/mutants-out.html
7. Shields.io endpoint badge: https://shields.io/badges/endpoint-badge
8. Shields.io dynamic JSON badge: https://shields.io/badges/dynamic-json-badge
9. Shields.io badges index: https://shields.io/badges
10. schneegans/dynamic-badges-action (marketplace): https://github.com/marketplace/actions/dynamic-badges
11. schneegans/dynamic-badges-action README: https://github.com/Schneegans/dynamic-badges-action/blob/master/README.md
12. sourcefrog/cargo-mutants repo: https://github.com/sourcefrog/cargo-mutants
13. sourcefrog/cargo-mutants CI workflow: https://github.com/sourcefrog/cargo-mutants/blob/main/.github/workflows/tests.yml
14. tgies/uls (cargo-mutants CI example): https://github.com/tgies/uls
15. GitHub Docs — Workflow commands (Adding a job summary / `$GITHUB_STEP_SUMMARY`): https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands
