# Maintenance Sweep Report — 2026-08-25

**Trigger:** human-requested (routine periodic hygiene pass). **Mode:** brownfield/Rust CLI. **develop @ `00df3823`** (dev pre-release `v0.7.0-dev.2`, shipped this session prior to the sweep). **Sweeps run: 6** (dependency, doc drift, pattern consistency, holdout freshness, tech debt, release confirmation); DTU, accessibility, and design-drift = N/A (non-UI CLI product, `dtu_required: false`); no performance-benchmark harness exists in-repo, so sweep 5 is a size/build-only spot check folded into the doc-drift pass rather than a standalone report.

## Sweep verdicts

| # | Sweep | Agent | Verdict | HIGH+ |
|---|-------|-------|---------|-------|
| 1 | Dependency audit | dx-engineer | CLEAN | 0 |
| 2 | Documentation drift | consistency-validator | 10 findings, 6 auto-fixed via PR #737 | 0 |
| 3 | Pattern consistency | code-reviewer | CLEAN | 0 |
| 4 | Holdout freshness | holdout-evaluator | COVERAGE GAP (0/106 cover 3 new flags) | 0 (coverage gap, not a defect) |
| 5 | Performance | — | N/A — no benchmark harness in-repo | — |
| 6 | DTU validation | — | N/A — `dtu_required: false` | — |
| 8 | Tech debt | — | no overdue items | 0 |
| 9 | Accessibility | — | N/A — non-UI CLI product | — |
| — | Release confirmation (folded in) | — | `release.yml` run 32858800028 CONFIRMED SUCCESS | — |

## Key findings

1. **Dependency audit — CLEAN.** `cargo audit`: 0 RUSTSEC advisories matched against a 1,226-entry advisory DB, 358 crates scanned, exit 0. `cargo deny check`: `advisories ok, bans ok, licenses ok, sources ok`, exit 0, with 4 non-fatal config-drift warnings (3 unused `deny.toml` license allow-list entries — `BSD-2-Clause`/`OpenSSL`/`Unicode-DFS-2016` — plus the `cpufeatures` unmatched-skip entry, all log-only, no crate in the graph currently needs them). No yanked or unmaintained crates. Highest severity found: **LOW** (the config-drift items themselves), not a real advisory. 5 cargo Dependabot PRs — #688, #727, #728, #729, #730 — remain HELD OPEN, all blocked on the pre-existing `syn` 2.0-vs-3.0 duplicate-version ban in `deny.toml` (`multiple-versions = "deny"`); this is unchanged from prior sweeps except that #730 is newly opened since the last pass. **DEFERRED — needs a human ecosystem-convergence decision** (accept the duplicate, wait for the ecosystem to converge on `syn` 3.0, or relax the ban); not resolved by this sweep. Full detail: `dependency-audit.md`, raw output `dependency-audit-raw.log`.

2. **Documentation drift — 10 findings, 6 auto-fixed.** Auto-fixed via cleanup PR #737 (`docs: maintenance doc sweep 2026-08-25`, OPEN → `develop`, MERGEABLE, awaiting human merge per `auto_merge: false`):
   - README.md: the `jr issue list` Commands-table row was missing `--fields <CSV>`, `--updated-recent <duration>`, `--sort <field>:asc|desc`, `--component NAME`, and the four date filters (`--created-after`/`--created-before`/`--updated-after`/`--updated-before`) — all real, shipped flags confirmed against `src/cli/mod.rs`/`src/cli/issue/list.rs`. Added, plus a note that `--fields` also applies to `jr issue view`.
   - README.md: the mise/Windows install section was stale — `v0.6.0` has shipped a Windows asset (`x86_64-pc-windows-msvc.zip`) since 2026-08-13; the "no Windows asset yet" wording was removed. Version-pin example refreshed `v0.5.0`→`v0.6.0`.
   - CLAUDE.md: applied the standing DEC-299 trim — dropped "Confluence" from the "future Confluence/JSM/Assets support adds sibling directories" architectural line (Confluence write-support remains a standing out-of-scope decision, DEC-299).
   - CLAUDE.md: "Known Size Deviations" LOC figures corrected against a fresh `wc -l` (not trusted from any prior figure) — `cli/issue/list.rs` 1,256→2,012 LOC, `cli/issue/create.rs` 394→530 LOC — plus three new entries for previously-undocumented over-threshold files: `cli/issue/attachments.rs` (~3,472 LOC), `cli/mod.rs` (~1,356 LOC), `cli/issue/helpers.rs` (~1,113 LOC), all marked DOCUMENT-AS-IS consistent with the section's existing style.
   - CLAUDE.md: added the missing `api/jsm/attachments.rs` entry to the `src/` module-tree diagram under `api/jsm/`.

   **Deferred / human-judgment (intentionally not touched by PR #737):**
   - README LICENSE badge vs. missing `LICENSE` file — left untouched per the user's standing license-decision-deferred preference; not a new finding, just re-confirmed still applicable.
   - STORY-INDEX.md declares `total_stories: 156`; on-disk story files under `stories/` (excluding `STORY-INDEX.md` itself, across the flat directory plus `wave-0`/`wave-1`/`wave-2`/`wave-3` subdirectories) count to 152. Needs a real reconciliation pass (find the 4 missing/miscounted stories), not a doc tweak — new Drift Item opened (see below), cross-referenced against the pre-existing MEDIUM `STORY-INDEX-DENOMINATOR-UNRECONCILED` item.

   Both spec-count guard scripts (`check-spec-counts.sh`, `check-bc-cumulative-counts.sh`) PASS with no drift. Full detail: `doc-drift-findings.md`.

3. **Pattern consistency — CLEAN, 0 real defects.** `grep -rn "#\[allow("` across `src/`: 2 real attributes found, both test-scoped (`#[allow(clippy::too_many_lines)]` on a combinatorial ADF corpus test; `#[allow(dead_code)]` on `#[cfg(test)]`-only `reset_for_test`), both carrying explanatory comments — zero un-justified suppressions in lib/bin code. No production `unsafe` code found. No let-chain syntax found (MSRV 1.85 compliance intact). JSON render invariant (#526) intact — every `--output json` path traced through `output::render_json`/`print_output`; no direct `serde_json::to_string_pretty` or compact `json!` Display-printing call sites outside the documented helper. The only actionable item this sweep was the CLAUDE.md size-figure drift, already captured under sweep 2 and folded into PR #737 rather than opened as a separate pattern-hygiene PR. Full detail: `pattern-findings.md`.

4. **Holdout freshness — COVERAGE GAP flagged.** 106 holdout scenarios total in the current set. 0 of them exercise any of the 3 flags shipped this cycle by `list-read-ergonomics` (`--updated-recent`, `--sort`, `--fields`). This is a coverage gap in the hidden black-box holdout set specifically — the underlying features already carry full behavioral-contract, unit, and integration test coverage from their own F4 delivery (Step-4.5 convergence, CI green); the holdout set was simply never extended to include them. Flagged **LOW/MEDIUM** for product-owner follow-up, not a defect. New Drift Item opened (see below).

5–6. **Performance / DTU — N/A.** No benchmark harness exists in this repo to regression-test against (a binary-size/build-time spot check was folded into the doc-drift pass instead — no anomaly observed). `dtu_required: false` in STATE.md frontmatter; no third-party service clones to validate.

8. **Tech debt — no overdue items.** Standing DEFERRED items carried forward unchanged: the now-5 (was 4) HELD-OPEN cargo Dependabot PRs blocked on the `syn` 2/3 ecosystem split (sweep 1); `ADOPT-MERGE-METHOD-RULESETS` (MEDIUM); `S-TRAIL-DERIVATION-GUARD-1` (P2/draft); AX23-001 ratification (PENDING); the still-owed F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING hygiene sweep (~140 items, benign, pre-existing); the 10-story `SELF-IMPROVEMENT` epic `S-PG-*` backlog (all `draft`, need PO BC-authorship before `ready` per S-7.01).

9. **Accessibility — N/A.** `jr` is a CLI tool with no graphical UI surface.

**Release confirmation (bonus, folded into this sweep):** `release.yml` run 32858800028, triggered by the `v0.7.0-dev.2` tag push earlier this session, was `in_progress` at the time it was last recorded. Confirmed via `gh run view 32858800028`: `status: completed`, `conclusion: success`. This resolves the standing "confirm release.yml run's outcome" resume candidate.

## Recommended follow-up deliverables (all human-gated; `auto_merge: false`)

- **PR #737 (already opened, docs-only, auto-PR eligible):** the 6 auto-fixable doc-drift findings from sweep 2. Awaiting human merge.
- **STORY-INDEX reconciliation (factory-only, human-judgment):** find and resolve the 156-declared vs. 152-on-disk story-file count gap. Cross-referenced against the pre-existing `STORY-INDEX-DENOMINATOR-UNRECONCILED` (MEDIUM) drift item.
- **Holdout refresh (product-owner):** author holdout scenarios covering `--updated-recent`, `--sort`, and `--fields` — LOW/MEDIUM priority, no urgency given full BC/test coverage already exists.
- **`syn` 2/3 Dependabot decision (human):** 5 PRs (#688/#727/#728/#729/#730) remain blocked on the `deny.toml` duplicate-version ban; needs an explicit human call on ecosystem-convergence timing.
- **(Optional) `deny.toml` cosmetic cleanup:** drop the 3 unused license allow-list entries and the unmatched `cpufeatures` skip — log-only, no urgency.

## Verdict

**No CRITICAL or HIGH findings anywhere in the sweep.** 0 reachable security or correctness defects. Findings are documentation hygiene (fixed via PR #737), one story-count bookkeeping gap needing reconciliation, and one holdout-coverage gap needing product-owner follow-up. No code changes were required or made. Sweep is CLEAN on the safety axis; follow-ups are hygiene/coverage improvements awaiting human prioritization, consistent with the 2026-06-25 sweep's precedent verdict shape.
