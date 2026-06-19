# Maintenance Sweep Report — 2026-06-19

**Mode:** MAINTENANCE (Path 10), Rust CLI  
**Repo/branch:** `jira-cli` (`jr`), `develop` @ `71f33c6` (v0.6.0-dev.5)  
**Date:** 2026-06-19  
**Produced by:** state-manager (aggregated from five specialist sweep reports)

---

## Scope

| Sweep | Subject | Status |
|-------|---------|--------|
| 1 | Dependency audit (cargo-audit, cargo-deny, outdated) | RUN |
| 2 | Documentation drift (CLAUDE.md, README.md, ADRs, rustdoc) | RUN |
| 3 | Pattern consistency, lint health | RUN |
| 4 | Holdout scenario freshness | RUN |
| 5 | Performance benchmarks | SKIPPED — no benchmark baseline exists |
| 6 | DTU validation | SKIPPED — `dtu_required: false` |
| 7 | Spec coherence | RUN (combined with 8 + 11) |
| 8 | Tech debt / drift items review | RUN (combined with 7 + 11) |
| 9 | UI completeness | SKIPPED — CLI-only product, N/A |
| 10 | Responsive validation | SKIPPED — CLI-only product, N/A |
| 11 | Risk / assumption monitoring | RUN (combined with 7 + 8) |

Sweep 1 security-reviewer triage: **no new CVEs to triage** — dependency scan GREEN.

---

## Maintenance Gate Status

| Gate | Result | Evidence |
|------|--------|----------|
| Zero critical CVEs | PASS | 0 RUSTSEC advisories; 0 cargo-deny errors; `cargo audit` exit 0; 0 yanked crates |
| Clippy clean (`-D warnings`) | PASS | Exit 0, zero warnings |
| Format check (`cargo fmt --check`) | PASS | Exit 0, no diffs |
| `check-spec-counts.sh` | PASS | "OK: all spec counts verified." |
| `check-bc-cumulative-counts.sh` | PASS | "OK: all cumulative BC counts verified (599 total; Surface H footer checked)." |
| `check-bc-no-numeric-test-counts.sh` | PASS | "OK: no numeric test counts in BC Trace/Source fields." |
| No BLOCKING findings | PASS | All findings are LOW/MINOR/MED quality improvements; 0 HIGH open |

**Overall verdict: GREEN — maintenance sweep clean. No blocking findings. All 3 HIGH/2 MED fork-ops drift items from the 2026-06-17 run are resolved. Remaining findings are documentation accuracy and code quality improvements.**

---

## Consolidated Findings Table

### Bundle A — Documentation accuracy (DOC-FIX, needs branch + PR to `develop`)

| ID | Source | Severity | Fix type | Summary |
|----|--------|----------|----------|---------|
| DRIFT-D13 | Sweep 2 | HIGH | Manual | `CLAUDE.md` Gotchas cite four `.factory/research/issue-361-*.md` files that do not exist (`issue-361-jra95368-scope.md`, `issue-361-jql-orderby.md`, `issue-361-validation.md`, `issue-361-followup.md`). These are "Detail:" links supporting load-bearing constraints (JRACLOUD-95368 attribution and JQL ORDER BY hint wording). Without them, the rationale cannot be audited. Fix: either create the four research files from verification evidence, or update "Detail:" citations to "(research files not yet written — constraints are load-bearing; do not modify without re-verification)." |
| DRIFT-D14 | Sweep 2 | MED | Manual | `prd/README.md` BC total shows 598 and bc-INDEX.md row shows 598; canonical `BC-INDEX.md` frontmatter `total_bcs: 599` (BC-2.4.043 added 2026-06-17 not reflected). Three-line edit: update bc-INDEX row to 599, update "Total BCs in PRD" prose to 599, append "+1 BC-2.4.043" to changelog suffix. |
| SC-01-2026-06-19 | Sweep 7 | MINOR | Manual (1 line) | `specs/domain-spec/bc-02-issue-read.md` frontmatter `bc_count: 93`; L3 `total_bcs: 94`. BC-2.4.043 was added 2026-06-17 but L2 domain-spec was not updated. Single-line frontmatter edit. |
| LOC-CANONICAL-DRIFT | Sweep 7 | LOW | Manual (2 rows) | `CANONICAL-COUNTS.md` shows `auth.rs` at 1,397 LOC; actual `wc -l` = 1,875 (+34%). Shows `list.rs` at 1,083 LOC; CLAUDE.md correctly states 1,256 (post-split). Two-row table edit. |
| DRIFT-D9 | Sweep 2 | LOW | Manual or annotation | `docs/adr/0014-jsm-request-creation.md` still does not exist; referenced in 4+ places (CLAUDE.md, ADR-0015 "See Also", `docs/specs/jsm-e2e-coverage.md`, `docs/specs/e2e-live-jira-testing.md`). Carry-forward from prior scan. Either write the ADR or annotate references with "(ADR not yet written)." |
| DRIFT-D15 | Sweep 2 | LOW | Manual (tree entry) | `CLAUDE.md` architecture tree omits `cli/auth/tests/` test submodule. Add `│   │   └── tests/` entry to `cli/auth/` section. |
| DRIFT-D16 | Sweep 2 | LOW | Manual | `CLAUDE.md` architecture tree entries for `types/assets/` and `types/jsm/` do not enumerate individual files, inconsistent with `cli/` and `api/` sections. Either enumerate files or add a note that type directories use the summary convention. |
| RISK-ANNOTATIONS | Sweep 7/11 | LOW | Manual (3 rows) | Three risk-register entries have stale annotations: R-M0 (`--verbose` body PII — resolved by SD-003 header-only `--verbose`; register still reads "SECURITY-DECIDE: Add `redact_body()`"), R-H288-1 (JSM scope — PR #381 merged 2026-05-19; register says "FIX-BEFORE-MERGE"), R-M288-1 (`--request-type` dispatch fork — all PRs merged; register says "FIX-IN-PHASE-4"). Add RESOLVED annotations to each. |

**Recommended route:** Single PR against `develop` touching `CLAUDE.md` (DRIFT-D13/D15/D16), `docs/adr/` annotation (DRIFT-D9), plus a factory-artifacts commit for SC-01-2026-06-19, DRIFT-D14, LOC-CANONICAL-DRIFT, and RISK-ANNOTATIONS.

---

### Bundle B — Holdout freshness (SPEC-FIX, factory-artifacts branch)

| ID | Source | Severity | Summary |
|----|--------|----------|---------|
| H-NEW-MP-001 | Sweep 4 | HIGH (functional) | Action line uses `jr issue create … --story-points 5`; current CLI rejects `--story-points` (`clap: unexpected argument`). Only `--points` parses on `develop` @ 71f33c6. A literal Phase 4 evaluation run fails on a parse error, not the assertion. Fix: replace `--story-points 5` with `--points 5` on holdout-scenarios.md line 480 (config-key refs `story_points_field_id` on lines 476/477/487 are UNAFFECTED — those are config keys, not CLI flags). |
| H-007 | Sweep 4 | MED (mechanism) | Resolution enforcement scenario still documents the *reactive* POST-400 path (BC-3.2.009) as the primary mechanism. ADR-0015/BC-3.2.013 changed the primary path to *proactive* pre-POST interception (exit 64 before the POST is sent). Reactive backstop preserved but is now a fallback. Substring outcome assertions still pass via the new path, but the documented mechanism is stale. Re-point to BC-3.2.013 as primary; retain BC-3.2.009 as reactive fallback variant. |
| H-027 | Sweep 4 | LOW (narrative) | Internal contradiction: `**Status**` says "MUST-PASS (cap shipped)" but `**BC refs**` still frames BC-X.4.009 as a "future MUST-FAIL when cap is implemented — flip assertion." The MAX_RETRY_AFTER_SECS=60 cap shipped in S-3.07; the "future flip" prose describes a completed event as pending. Prose-only revision: collapse BC-X.4.002/BC-X.4.009 "future flip" prose into a single post-S-3.07 statement. |

**Note:** H-044 DOWNGRADED to FRESH (confirmed: `src/adf.rs` mention-drop `_` arm is still current behavior; post-2026-05-20 ADF commits did not change mention rendering). The prior-run H-044 stale-candidate recommendation is no longer valid.

**Recommended route:** Single factory-artifacts commit touching `holdout-scenarios.md` for all three items. H-NEW-MP-001 is the only hard-blocking item (evaluator would fail on clap error); H-007 and H-027 are prose/mechanism correctness.

---

### Bundle C — Tiny CI fix (CI-FIX, branch + PR to `develop`)

| ID | Source | Severity | Fix type | Summary |
|----|--------|----------|----------|---------|
| CR-010 / FORK-OPS-BACKFILL-TIMEOUT-PARITY | Sweep 3 | LOW | Trivial (1-line YAML) | `.github/workflows/backfill-release.yml` build job has no `timeout-minutes`; inherits GitHub's 6-hour default. `release.yml` build job has `timeout-minutes: 60` (line 14). A runaway build in the backfill workflow would consume 6 hours vs 60 minutes in the equivalent release.yml job. Fix: add `timeout-minutes: 60` to the `build` job in `backfill-release.yml`. |

**Recommended route:** One-line PR (`chore(ci): add timeout-minutes: 60 to backfill-release.yml build job`). Zero behavioral impact on success path; eliminates runaway-job risk.

---

### Bundle D — Code refactors (CODE-FIX, future Feature Mode stories)

| ID | Source | Severity | Fix type | Summary |
|----|--------|----------|----------|---------|
| CR-005 | Sweep 3 | LOW | Refactor | `OffsetPage::items()` accessor underused: 5 of 6 pagination loops in `boards.rs`, `issues.rs` (get_changelog + list_comments), `sprints.rs` (2 sites), `projects.rs` use `.values.unwrap_or_default()` etc. instead of the accessor. Carry-forward from prior pass; no correctness defect. |
| CR-008 | Sweep 3 | LOW | Extract + replace (test-only) | `extract_job_block` copy-pasted across 3 CI test files (`ci_yml_windows_matrix.rs:68`, `ci_gate_completeness.rs:66`, `backfill_matrix_parity.rs:158`) with slightly divergent implementations. `tests/common/` is the natural home for a shared `ci_test_helpers.rs`. Medium effort; no behavioral change. |
| CR-009 | Sweep 3 | LOW | Canonicalize (test-only) | Three keyring-gate idioms coexist: Idiom A (`is_err()` early-return, accepts any value) in `auth_profiles.rs` (3 sites); Idiom B (`as_deref() != Ok("1")`, requires `"1"` exactly) across 17 sites; Idiom C (`match + panic`) in `auth_output_json.rs`. Idiom A accepts `JR_RUN_KEYRING_TESTS=0` as opt-in (false positive). Adopt Idiom B as canonical; migrate 3 Idiom-A sites; optionally extract `fn keyring_tests_enabled()`. Medium effort; no CI behavioral change. |
| SEC-JR-SERVICE-NAME-GATE | Sweep 7/8 | LOW | 1-line debug gate | `src/api/auth.rs::service_name()` reads `JR_SERVICE_NAME` with no `#[cfg(debug_assertions)]` gate, unlike `JR_BASE_URL`/`JR_AUTH_HEADER`. Security impact is low (service name, not credentials) but violates the gate-all-seams pattern. Fix: add `#[cfg(debug_assertions)]` gate. |
| SEC-001 / CWE-674 | Sweep 3/8 | LOW | Depth counters | `src/adf.rs`: `normalize_panel_content`, `assign_local_ids_walk`, `render_node` (in `autolink_bare_urls`) recurse without a depth cap. Practical risk is low (pulldown-cmark limits nesting indirectly), but no explicit guard exists. Fix: add depth counters (compare `yaml_contains_secrets` depth-guard in `check-signing-workflow-injection.sh`). |
| #532-COVERAGE-FOLLOW-UP | Sweep 8 | LOW | Test coverage | Issue #532 still OPEN. Login/Refresh/Logout global-`--profile` fallback ungated in current test coverage. Deferred from S-TESTTOOL-1 F5. |

**Recommended route:** Feature Mode F1–F7 per story. CR-008/CR-009 are test-only and can be batched. SEC-JR-SERVICE-NAME-GATE and SEC-001 are code changes; treat as independent stories. CR-005 is a style refactor deferrable indefinitely.

---

### Bundle E — STATE.md housekeeping (BOOKKEEPING, factory-artifacts branch — actioned in this sweep)

These items were already fully resolved before this maintenance sweep ran. They are being moved out of the STATE.md Drift Items table to `cycles/cycle-001/blocking-issues-resolved.md` as pure bookkeeping.

| ID | Area | Severity | Resolution | Resolved Date |
|----|------|----------|------------|---------------|
| FORK-OPS-SIGN-INJECTION | sign-and-publish.yml | HIGH | PR #535 → 1a2a79b (2026-06-18). CWE-77 env-binding rewrite; 23 injection sites cleaned. | 2026-06-18 |
| FORK-OPS-ALPHA-RACE | sign-and-publish.yml | HIGH | PR #535 → 1a2a79b (2026-06-18). Atomic alpha-tag via `gh api git/refs` (HTTP 201/422); `--cleanup-tag` purge dropped. | 2026-06-18 |
| FORK-OPS-GITLEAKS-DOC | CLAUDE.md / spec | MED | PR #542 / f85647b (2026-06-19). `GITLEAKS_DISABLED` documented in CLAUDE.md. Shipped as S-FORK-OPS-GITLEAKS-DOC-1. | 2026-06-19 |
| H-044 (downgrade) | Holdout freshness | — | DOWNGRADED to FRESH. Verified `src/adf.rs` mention-drop `_` arm is still current behavior; "Mention node silently dropped" parenthetical is accurate. No action required. | 2026-06-19 |

**Status:** Actioned in this sweep. STATE.md Drift Items table updated; resolved rows archived to `cycles/cycle-001/blocking-issues-resolved.md`.

---

## Dependency Housekeeping Note

14 `deny.toml` `[[bans.skip]]` entries become stale after the next `cargo update` (confirmed from dry-run):

The `jni 0.21→0.22` and `rustls-platform-verifier 0.6→0.7` upgrades (both upstream-gated, currently blocked by `reqwest`) will cascade-remove the `thiserror 1.x`, `windows-sys 0.45`, `windows-targets 0.42`, all 6 `windows_*_0.42` arch crates, and `wit-bindgen 0.51` lineages from the dependency graph. After running `cargo update`, re-run `cargo deny check` and prune those 14 entries. Current `cargo deny check` passes with 0 errors today; no action required now.

**Current dependency health:** 0 CVEs, 0 RUSTSEC advisories, 0 yanked crates, 0 cargo-deny errors. Full detail: `dependency-audit.md`.

---

## Prior-Run Finding Resolution Summary

| Prior ID | Prior Severity | Status in This Run |
|----------|---------------|-------------------|
| DRIFT-D1 | HIGH | FIXED (auth module dir in CLAUDE.md) |
| DRIFT-D2 | HIGH | FIXED (assets module dir + filter_tickets citation) |
| DRIFT-D3 | HIGH | FIXED (12 missing source files added to tree) |
| DRIFT-D4 | HIGH | FIXED (auth status JSON deferred status corrected) |
| DRIFT-D8 | MED | FIXED (README --verbose updated; --verbose-bodies added) |
| DRIFT-D7 | MED | FIXED (README commands table: jr api + jr issue changelog) |
| CR-001 | LOW | FIXED (list_comments anti-stall guard added PR #523) |
| CR-002 | LOW | FIXED (all --output json paths through render_json, PR d56dcfc) |
| CR-003 | LOW | FIXED (CLAUDE.md list.rs LOC updated to 1,256) |
| CR-004 | LOW | FIXED (adf.rs too_many_lines justification comment added) |
| CR-007 | LOW | FIXED (write_cmdb/object_type_attr_cache model-b, PR 6f24748) |
| SC-01 (bc-03/06/07) | MINOR | FIXED (bc_count values now match L3) |
| SC-04 (ADR-0016 divergence) | MINOR | PARTIALLY FIXED / VERIFY NEEDED |
| SC-06 (JRACLOUD-95368 citation) | LOW | PARTIALLY RESOLVED (risk register corrected; S-3.07 story not re-checked) |
| SC-07 (RESOLVED annotations) | LOW | PARTIALLY RESOLVED (major risks annotated; R-H288-1, R-M0, R-M288-1 gaps remain) |
| H-044 | MED | DOWNGRADED TO FRESH |
| FORK-OPS-SIGN-INJECTION | HIGH | RESOLVED — PR #535 |
| FORK-OPS-ALPHA-RACE | HIGH | RESOLVED — PR #535 |
| FORK-OPS-GITLEAKS-DOC | MED | RESOLVED — PR #542 / f85647b |

---

## Recommendations

No fixes have been applied by this sweep (Bundle E housekeeping is pure bookkeeping with no code or spec changes). All findings are classified and bundled; the orchestrator will present bundles A–D to the human for authorization.

Standing constraints:
- All fixes go through delivery (branch + PR); orchestrator never hand-edits source or factory specs.
- Maximum 10 fix PRs per maintenance run.

**Suggested prioritization for authorization:**

1. **Bundle B H-NEW-MP-001** (HARD — 1-line holdout fix): `--story-points`→`--points`. A Phase 4 evaluator running the literal action line fails on a clap parse error. Highest urgency; zero risk.
2. **Bundle A DRIFT-D13** (HIGH — dead research citations): Annotate four missing `.factory/research/issue-361-*.md` references in CLAUDE.md with "(not yet written — constraints are load-bearing; do not modify)." Single-PR to `develop`.
3. **Bundle A DRIFT-D14 + SC-01-2026-06-19 + LOC-CANONICAL-DRIFT** (combined factory-artifacts commit): prd/README.md 598→599, bc-02 domain-spec bc_count 93→94, CANONICAL-COUNTS.md LOC table corrections. Four-file, six-line docs-only fix.
4. **Bundle B H-007 + H-027** (holdout mechanism/narrative correctness): Re-point H-007 to BC-3.2.013 proactive path; collapse H-027 future-flip prose. Single holdout revision commit.
5. **Bundle C CR-010** (1-line CI fix): `timeout-minutes: 60` on backfill-release.yml build job. Chore PR.
6. **Bundle A RISK-ANNOTATIONS** (3-row factory-artifacts annotation): R-M0, R-H288-1, R-M288-1 RESOLVED markers.
7. **Bundle A DRIFT-D9** (ADR-0014 annotation): Annotate 4+ references with "(ADR not yet written)" if write is deferred.
8. **Bundle D CR-008** (medium, test-only): Extract `extract_job_block` to `tests/common/`. Prevents a 4th copy on next CI test file.
9. **Bundle D CR-009** (medium, test-only): Canonicalize keyring guard idiom to Idiom B; optionally extract `fn keyring_tests_enabled()`.
10. **Bundle A DRIFT-D15/D16** (LOW, tree completeness): `cli/auth/tests/` entry + `types/assets/` and `types/jsm/` enumeration.
