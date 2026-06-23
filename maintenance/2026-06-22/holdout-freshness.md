# Maintenance Sweep 4 — Holdout Scenario Freshness

- **Date**: 2026-06-22
- **Product baseline**: `develop` @ ed236d4 ("fix(ci): make verify-signatures step actually exercise correctly in a signing-configured fork")
- **Holdout file**: `.factory/specs/prd/holdout-scenarios.md` (`total_holdouts: 60`, version 1.1.2, last_updated 2026-05-20)
- **Prior runs**: `.factory/maintenance/2026-06-19/holdout-freshness.md` (develop @ 71f33c6) and `.factory/maintenance/2026-06-17/holdout-freshness.md` (develop @ 53f6d98)
- **Build**: `cargo build` → exit 0 (clean). Binary: `target/debug/jr`.
- **Mode**: READ-ONLY staleness sweep. No code changes, no commits, holdout file NOT modified. NOT a Phase 4 holdout evaluation — no scenarios run against full wiremock fixtures. Mechanically-checkable scenarios (CLI surface, flag existence, exit codes, fresh-install JSON shape, profile-name validation, test-file presence) were executed against the freshly built debug binary under isolated `JR_CONFIG_DIR`/`JR_CACHE_DIR`/`JR_SERVICE_NAME`.
- **Scenario count reconciliation**: frontmatter `total_holdouts: 60` now matches the 60 `### H-*` headers on disk. Prior reports said "57" because they predate the three H-CITE-001/002/003 scenarios (added 2026-06-19, S-MAINT-DEAD-CITATION-CI). The H-018 numbering gap (retired S-3.10) is intentional and already excluded.

## Summary

- **Total scenarios**: 60
- **PASS / FRESH (no action)**: 56
- **STALE (recommend revision)**: 4 — H-NEW-MP-001 (hard CLI drift), H-019 (exit-code expectation drift, NEW this run), H-007 (mechanism drift), H-027 (narrative drift)
- **CLI-surface drift (functional breakage)**: 1 confirmed-persisting — H-NEW-MP-001 (`--story-points` long form no longer parses)
- **Coverage gaps (shipped feature areas with ZERO holdouts)**: 6 areas (see table) — chiefly the entire ADF markdown→ADF wave (#471/#472/#474/#483/#489/#522), `issue edit`, and bulk operations.
- **Net change vs 06-19 run**: H-NEW-MP-001 + H-007 + H-027 confirmed STILL OPEN (holdout file unchanged since 2026-05-20). **NEW: H-019 exit-code drift surfaced** by executing the three boundaries against the binary this run (prior runs only cross-checked flag existence, not exit codes). MUST-FIX narrative staleness (H-036/H-045/H-046/H-NEW-MP-001) unchanged-soft.

## Per-Scenario Results (mechanically checked + all STALE)

| Scenario | Status | Evidence |
|----------|--------|----------|
| H-001 (`auth status` fresh) | **PASS** | exit 0; stderr `No profiles configured…`. Verified live. |
| H-002 (`auth list --output json` fresh) | **PASS** | exit 0; stdout `[]`. Verified live. |
| H-015 (`--all`+`--limit` mutual-exclusion) | **PASS** | exit non-zero; stderr `the argument '--all' cannot be used with '--limit <LIMIT>'`. Verified live. |
| H-020 (json error shape `{error,code}`) | **PASS** | `auth switch ghost` → exit 64; stderr `{"code":64,"error":"unknown profile: ghost; known: default"}`. Parseable, has `error`(str)+`code`(64). Verified live. |
| H-019 (`foo:bar` rejected at THREE boundaries → each exit 64) | **STALE (NEW)** | Config-load boundary (H-019b/H-028) → exit **64** ✓. BUT `--profile foo:bar` flag → exit **78** (`Profile name contains invalid characters…`); `JR_PROFILE=foo:bar` env → exit **78**. Holdout says "each → exit 64"; two of three boundaries return 78, not 64. Expectation no longer holds against the current binary. |
| H-028 (hand-edited `[profiles."foo:bar"]`) | **PASS** | exit 64; stderr `invalid profile name "foo:bar" in config.toml; allowed: …`. Matches. Verified live. |
| H-033 (`remote-link --url ftp://…` rejected) | **UNCHECKABLE-OFFLINE** | Scheme-allowlist check sits AFTER config/instance resolution. With no profile → exit 78 (no-instance) before reaching the scheme check; with a configured profile the command attempts network and timed out in the sandbox. Flag `--url` present; not a drift — evaluator must mount a configured profile + wiremock `expect(0)` per the scenario setup. |
| H-027 (rate-limit cap abort) | **STALE (narrative)** | `tests/rate_limit_cap_tests.rs` + `tests/rate_limit_cap_ac003.rs` present (cap shipped, S-3.07). Internal contradiction unchanged: `**Status**` says cap shipped, but BC-X.4.009 framing still describes a "future MUST-FAIL … flip the assertion". Carry-forward from 06-17/06-19. |
| H-007 (`issue move … Done` resolution hint) | **STALE (mechanism)** | ADR-0015/BC-3.2.013 proactive pre-POST interception supersedes the reactive POST-400 fixture. Substrings (`--resolution`, `jr issue resolutions`) still surface, via a different path. `issue move` flags `--resolution`/`--no-resolution`/`--to` all present. Carry-forward — still open. |
| H-NEW-MP-001 (multi-profile story-points field) | **STALE (hard CLI drift)** | Action line `jr issue create … --story-points 5` → `error: unexpected argument '--story-points' found` (clap). Only `--points` parses (`--points 5` reaches the field-config check: "Story points field not configured…"). Confirmed live. Config-key refs `story_points_field_id` are unaffected. Fix: `--story-points`→`--points` on the Action line. Carry-forward from 06-19, still unfixed. |
| H-036 / H-045 / H-046 (MUST-FIX pins) | **PASS (soft narrative-stale)** | Test files present (`issue_list_assets.rs`, `worklog_commands.rs`, `issue_open.rs`). All shipped; "Current code fails this holdout" prose now historically inaccurate. Soft cleanup only. |
| H-NEW-VERBOSE-001/002 | **PASS** | Global `--verbose` / `--verbose-bodies` present on every probed subcommand; `tests/verbose_bodies.rs` present. SD-003 v0.6 split encoded correctly. |
| H-NEW-AUTH-002 | **PASS** | `tests/auth_header_release_gate.rs` present (release gate). Requires release build to evaluate fully; surface intact. |
| H-NEW-JSM-RT-001..007 | **PASS** | `issue create` flags `--request-type`/`--type`/`--field`/`--markdown`/`--description-stdin` all present; `requesttype fields` present; `tests/issue_create_jsm.rs` present. |
| H-CITE-001/002/003 | **PASS** | `tests/claude_md_citations.rs` present; library-level fixture scenarios (no CLI surface). |
| H-044 (ADF `issue view`, mention-drop) | **FRESH** | Confirmed FRESH in 06-19 run (mention still dropped); no ADF change since affects it. Core assertion (heading+paragraph render, no panic) robust. |
| All other H-003..H-043 | **FRESH** | Every referenced subcommand + flag present on the built binary (auth/issue/assets/sprint/worklog/team/user/requesttype/api/me/project/board/queue/init/completion). No removed/renamed surface. |

## Coverage-Gap Table (shipped feature areas vs holdout coverage)

| Feature area | Shipped? | Holdout coverage | Gap severity |
|--------------|----------|------------------|--------------|
| Auth / profiles / OAuth / multi-cloudId | yes | H-001..005, H-011, H-016, H-019, H-028, H-029, H-047, H-NEW-AUTH-002, H-NEW-MP-001 | covered |
| Issue read / list / JQL / filters | yes | H-008..010, H-021..023, H-031, H-032, H-035, H-043, H-044 | covered |
| Issue move / transitions / resolution | yes | H-006, H-007 | covered |
| Assets / CMDB / AQL | yes | H-017, H-023..025, H-036..039 | covered |
| Sprint / board read | yes | H-040..043 | covered (board view/list itself thin) |
| Rate limit / retry / 429 / 401-scope | yes | H-012, H-013, H-022, H-027 | covered |
| Worklog list pagination | yes | H-045 | covered |
| JSM request types (`create --request-type`) | yes | H-NEW-JSM-RT-001..007 | covered |
| CI citation guard | yes | H-CITE-001..003 | covered |
| Verbose / PII-bodies (SD-003) | yes | H-NEW-VERBOSE-001/002 | covered |
| **ADF markdown→ADF wave (#471 task-list, #472 footnotes, #474 subsup/heading-attr, #483 GFM panels, #489/#492 block-HTML, #522 CR/LF, #473 bare-URL autolink)** | **yes** | **NONE** (only H-NEW-JSM-RT-007 touches `--markdown`, and only as a `--field` *conflict guard*, not rendering correctness) | **HIGH — large, recently-churned behavioral surface; zero black-box acceptance pin** |
| **`issue edit` (`--field`, `--type`, `--label`, `--dry-run`, `--no-parent`, description-echo asymmetry #398)** | **yes** (flags confirmed: `--field --type --label --dry-run --jql --no-parent --no-points --markdown …`; tests `issue_edit_*.rs` present) | **NONE** | **HIGH — entire write-path subcommand uncovered, incl. single/bulk routing forks (#446, #331)** |
| **Bulk operations (transition / field / label, nested wire schema FIX-BULK-TRANSITION-001)** | **yes** (`issue_bulk.rs`, `issue_bulk_pr2.rs`, bulk grace/timeout gates) | **NONE** | **MEDIUM-HIGH — load-bearing nested-vs-flat wire schema with no acceptance pin** |
| **`issue changelog`** | yes | NONE | LOW-MEDIUM |
| **`worklog add` (duration parsing 2h/1h30m/1d/1w)** | yes | NONE (only `worklog list` via H-045) | LOW-MEDIUM |
| **`issue link` / `unlink` / `link-types`** | yes | NONE | LOW |
| **`queue list` / `queue view` (JSM service desks)** | yes | NONE | LOW |
| **`board view` / `board list` truncation** | yes | partial (H-040/043 are sprint-side) | LOW |

## Findings Detail

1. **H-NEW-MP-001 hard CLI drift (unchanged, highest priority).** `--story-points` removed from clap; only `--points` parses. Literal Action fails on a parse error before reaching the multi-profile assertion. Fix: `--story-points 5` → `--points 5` (line ~480). Config keys `story_points_field_id` unaffected.

2. **H-019 exit-code drift (NEW this run).** Holdout claims all three `foo:bar` boundaries → exit 64. Live: config-load boundary → 64 (correct), but `--profile` flag and `JR_PROFILE` env → exit **78** with `Profile name contains invalid characters (use a-z, 0-9, -, _)`. The flag/env paths reject via the config-error code (78), not the validation-error code (64). Either the holdout's "each → exit 64" should be relaxed to "each → exit non-zero (64 at config-load boundary; 78 at flag/env boundary)" OR the product should be aligned to 64 across all three. Flagged as STALE pending a product decision; mechanically reproducible, so the current "each → exit 64" expectation is wrong against the build. (H-028 isolates the config-load boundary and PASSES at 64.)

3. **H-007 mechanism drift (carry-forward).** Reactive POST-400 fixture superseded by ADR-0015 proactive pre-POST interception. Re-point to BC-3.2.013, retain BC-3.2.009 as documented fallback.

4. **H-027 narrative drift (carry-forward).** MAX_RETRY_AFTER_SECS=60 cap shipped; "future MUST-FAIL flip" prose describes a past event as pending. Prose-only collapse.

5. **MUST-FIX narrative (soft).** H-036/H-045/H-046/H-NEW-MP-001 "Current code fails this holdout" lines are historically inaccurate (all shipped, test files confirmed). Convert to past-tense closure notes; bundle with H-NEW-MP-001's hard `--points` fix.

6. **Coverage gaps (genuine missing-coverage of SHIPPED behavior).** The 2026-04/05 ADF markdown wave, `issue edit`, and bulk operations all shipped with internal `tests/*.rs` coverage but ZERO holdout (black-box acceptance) scenarios. These are the highest-value targets for new holdouts: ADF rendering is a panic-prone, recently-churned surface; `issue edit` and bulk have load-bearing single/bulk routing forks and asymmetric wire schemas explicitly flagged in CLAUDE.md as "do not unify."

## Recommendation

- **Hard fix (1):** H-NEW-MP-001 `--story-points`→`--points`.
- **Decide + fix (1):** H-019 exit-code expectation (relax to non-zero, or align product to 64).
- **Prose/mechanism revision (2):** H-007 (re-point BC-3.2.013), H-027 (collapse cap narrative).
- **Soft cleanup:** four MUST-FIX `**Status**` lines → past-tense closure.
- **New holdouts (coverage):** author acceptance scenarios for the ADF markdown wave (panel/task-list/footnote/subsup/block-HTML round-trips), `issue edit --field/--type/--label/--dry-run` (incl. single↔bulk routing fork), and bulk transition nested-schema. None of these have a black-box pin today.

**FINDINGS: 4 stale, 6 coverage-gaps**
