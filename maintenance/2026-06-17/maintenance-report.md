# Maintenance Sweep Report — 2026-06-17

**Mode:** MAINTENANCE (Path 10), Rust CLI  
**Repo/branch:** `jira-cli` (`jr`), `develop` @ `53f6d98`  
**Date:** 2026-06-17  
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
| Zero critical CVEs | PASS | 0 RUSTSEC advisories; 0 cargo-deny errors; `cargo audit` exit 0 |
| Clippy clean (`-D warnings`) | PASS | Exit 0, zero warnings |
| Format check (`cargo fmt --check`) | PASS | Exit 0, no diffs |
| `check-spec-counts.sh` | PASS | "OK: all spec counts verified." |
| `check-bc-cumulative-counts.sh` | PASS | "OK: all cumulative BC counts verified (598 total; Surface H footer checked)" |
| `check-bc-no-numeric-test-counts.sh` | PASS | "OK: no numeric test counts in BC Trace/Source fields." |
| No BLOCKING findings | PASS | All findings are LOW/MINOR/MED quality improvements |

**Overall verdict: GREEN — maintenance sweep clean. No action required before next delivery cycle. All findings are documentation accuracy and code quality improvements.**

---

## Consolidated Findings Table

### Bundle A — Documentation accuracy (DOC-FIX, needs branch + PR to `develop`)

| ID | Source | Severity | Fix type | Summary |
|----|--------|----------|----------|---------|
| DRIFT-D1 | Sweep 2 | HIGH | Manual | `CLAUDE.md` architecture tree lists `cli/auth.rs` as a flat file; reality is module directory `cli/auth/{mod,keychain,list,login,logout,refresh,remove,status,switch,tests}/`. |
| DRIFT-D2 | Sweep 2 | HIGH | Manual | `CLAUDE.md` tree lists `cli/assets.rs` as flat file; reality is `cli/assets/{mod,search,view,tickets,schemas}/`. Gotcha citation `cli/assets.rs::filter_tickets` stale — correct path is `cli/assets/tickets.rs::filter_tickets`. |
| DRIFT-D3 | Sweep 2 | HIGH | Manual | Architecture tree missing 12 production source files (~3,500 LOC): `api/jira/bulk.rs` (881), `api/jira/resolutions.rs` (55), `api/refresh_coordinator.rs` (165), `api/jsm/request_types.rs` (75), `api/jsm/requests.rs` (337), `cli/api.rs` (355), `cli/issue/changelog.rs` (847), `cli/issue/field_resolve.rs` (877), `cli/issue/json_output.rs` (182), `types/jira/bulk.rs` (746), `types/jira/changelog.rs` (126), `types/jira/editmeta.rs` (73). JSM subsection also omits `request_types.rs` and `requests.rs`. |
| DRIFT-D4 / OQ-5 | Sweep 2 | HIGH | Manual | `CLAUDE.md` claims "`auth status --output json` covers single-profile JSON." Reality: `auth/status.rs` has zero JSON output code — neither single-profile nor multi-profile JSON is implemented. The "single-profile is done; multi-profile deferred" framing is factually wrong on both counts. |
| DRIFT-D8 | Sweep 2 | MED | Manual | `README.md` global flags table describes `--verbose` as "Show HTTP request/response details." Per SD-003 (v0.6 breaking change), `--verbose` is header-only (method + URL); body inspection requires `--verbose-bodies`. `--verbose-bodies` is absent from README entirely. |
| DRIFT-D7 | Sweep 2 | MED | Manual | `README.md` Commands table missing `jr api` (API passthrough, `cli/api.rs`, 355 LOC) and `jr issue changelog` (`cli/issue/changelog.rs`, 847 LOC). Both fully implemented and dispatched. `jr requesttype list/fields` also absent (DRIFT-D12). |
| DRIFT-D12 | Sweep 2 | LOW | Manual | `README.md` Commands table missing `jr requesttype list` and `jr requesttype fields <NAME\|ID>`. |
| README exit-124 | Sweep 2 | MED | Automated-possible | `README.md` Exit Codes table lists 0/1/2/64/78/130 but omits code 124 (`DeadlineExceeded`, added for bulk timeout in issue #333). |
| CR-003 | Sweep 3 | LOW | Manual (DOC-FIX) | `CLAUDE.md` "Known Size Deviations" records `list.rs` at 1,083 LOC; actual is 1,256 LOC (173 lines of undocumented growth, likely date-filter expansion). |
| CR-004 | Sweep 3 | LOW | Code comment (1 line) | `src/adf.rs:8483` carries `#[allow(clippy::too_many_lines)]` with no justification comment. Policy requires justification or refactor. A one-line comment suffices. |
| DRIFT-D11 | Sweep 2 | LOW | Manual | `CLAUDE.md` verbose Gotcha says "method + URL + status only." No response status is logged in `api/client.rs`. Should read "method + URL only." |

**Recommended route:** Single PR against `develop` touching `CLAUDE.md`, `README.md`. Can batch all Bundle A items into one PR.

---

### Bundle B — Factory spec accuracy (SPEC-FIX, factory-artifacts branch)

| ID | Source | Severity | Fix type | Summary |
|----|--------|----------|----------|---------|
| SC-01 | Sweep 7 | MINOR | Manual frontmatter edit | L2 `bc_count` stale in 4 domain-spec files: `bc-02` (92 vs 93), `bc-03` (77 vs 107), `bc-06` (39 vs 42), `bc-07` (85 vs 90). bc-03 gap of -30 is the most stale (Feature Mode expansion). |
| SC-02 / PG-A / DRIFT-README | Sweep 7 | LOW | Manual | `.factory/specs/prd/README.md` Document Map has stale counts throughout (total 573 vs canonical 598, plus stale per-file rows for bc-3/6/7 and cross-cutting). Pre-tracked as PG-A. |
| SC-03 | Sweep 7 | MINOR | Decision + doc | ADR-0015 lives in `docs/adr/` while all factory-created ADRs 0007-0014 and 0016 live in `.factory/architecture/adr/`. Convention inconsistency; either relocate ADR-0015 or annotate `CANONICAL-COUNTS.md`. |
| SC-04 | Sweep 7 | MINOR | Manual merge | ADR-0016 exists in two locations (`docs/adr/` and `.factory/architecture/adr/`) with divergent content — the `.factory` copy (which `adr-index.md` links to) is missing the CI-Gate (S-CIGATE-1) paragraph present in the `docs/adr/` copy. Apply the 3-line addition to `.factory/architecture/adr/0016-windows-build-target.md`. |
| SC-05 | Sweep 7 | LOW | Manual (optional) | 4 `code-delivery/` story.md files (`issue-331`, `issue-333`, `issue-350`, `issue-365`) are not in the STORY-INDEX manifest. Historical gap from pre-index convention. Optional retroactive entries. |
| SC-06 | Sweep 7 | LOW | Manual spec edit | `stories/wave-3/S-3.07-*.md` and `architecture/risk-register.md` (R-NEW-S307-1) cite `JRACLOUD-94632/-92049/-85546`. These are misattributed per CLAUDE.md gotcha (issue #361/PR #364). Correct ticket is `JRACLOUD-95368`. Replace in both files. |
| SC-07 | Sweep 7 | LOW | Manual | Risk register lacks `RESOLVED` annotations for ~12 completed `FIX-IN-PHASE-3` items (R-C1, R-H1..H6, R-L12/13, R-M4 partial, R-NEW-AR-1..5, R-NEW-S307-1). All resolving stories confirmed merged to `develop`. Add `RESOLVED — <story-id> MERGED <PR#>` to each row. |
| ADR-0014 | Sweep 2 | LOW | Investigation then create or annotate | `docs/adr/0014-jsm-request-creation.md` does not exist. Referenced from CLAUDE.md, ADR-0015 "See Also", and `docs/specs/jsm-e2e-coverage.md`. ADR numbers jump 0006→0015. Either write the missing ADR-0014 or annotate references with "(ADR not yet written)." |

**Recommended route:** Factory-artifacts commit for SC-01/02/03/04/05/06/07. ADR-0014 may need a PR to `develop` (if written) or a `docs/adr/` annotation.

---

### Bundle C — Code quality (CODE-FIX, via Feature Mode F1–F7)

| ID | Source | Severity | Fix type | Summary |
|----|--------|----------|----------|---------|
| CR-001 | Sweep 3 | LOW | 1–3 line change | `api/jira/issues.rs::list_comments` lacks the anti-stall guard present in `get_changelog` (guard: if `next <= start_at { break/err }`). A pathological Jira response with `has_more=true` but no `start_at` advance would loop forever. |
| CR-002 | Sweep 3 | LOW | Mechanical batch | 24 sites in `src/cli/` call `serde_json::to_string_pretty` directly inside `println!` instead of `output::render_json`. The two are functionally equivalent but inconsistency prevents future centralized JSON transforms (syntax highlighting, `_meta` envelope). Affected: `cli/issue/create.rs` (4), `cli/issue/workflow.rs` (2), `cli/issue/links.rs` (4), `cli/auth/{login,logout,remove,refresh,list}.rs`, `cli/sprint.rs`. |
| CR-007 | Sweep 3 | LOW | 1–2 line change + doc | `api/assets/objects.rs:189` calls `let _ = cache::write_object_type_attr_cache(...)` silently discarding errors. The function itself propagates via `?` (model A), but its only caller uses silent discard without a rustdoc choice or `eprintln!` (model B). Inconsistent with the two-model policy documented in CLAUDE.md. |

**Recommended route:** Feature Mode PR(s) against `develop`. CR-001 and CR-007 are small enough to combine; CR-002 is a mechanical batch with no behavioral change.

---

### Bundle D — Holdout freshness (SPEC-FIX, factory-artifacts branch)

| ID | Source | Confidence | Summary |
|----|--------|------------|---------|
| H-007 | Sweep 4 | HIGH | Resolution enforcement scenario documents *reactive* POST-400 rewrite as the primary mechanism. ADR-0015/BC-3.2.013 changed the primary path to *proactive* pre-POST interception. The reactive backstop (BC-3.2.009) is preserved but is now a fallback. Substring outcomes survive but the documented mechanism is stale. Recommend revision to re-point to BC-3.2.013 and describe the proactive path; retain reactive variant as a documented fallback. |
| H-044 | Sweep 4 | MED | ADF scenario parenthetical "Mention node silently dropped (current behavior)" may be stale after the post-2026-05-20 ADF expansion (#471/#472/#474/#483/#489/#492/#522). Core assertion (heading + paragraph render, no panic) is robust; only the mention-drop parenthetical is at risk. Recommend re-verifying against a current ADF fixture. |
| H-027 | Sweep 4 | LOW | Internal contradiction: `Status` says "MUST-PASS (cap shipped)" but `BC refs` line says "future MUST-FAIL when cap is implemented — flip assertion." The cap shipped in S-3.07; the "future flip" prose describes a completed event as pending. Prose-only revision; no behavior change. |

Note: the holdout file has no `lifecycle_status` field on any scenario. Adopting that field for the three stale candidates (A/B/C above) requires a schema addition to `holdout-scenarios.md`; the recommendation is recorded here pending that schema decision.

---

### Quick win — PR #519 (dependabot: codecov-action 6.0.1 → 7.0.0)

Assessment: **SAFE TO MERGE.**

The v7.0.0 change is a GPG signing-key migration (`codecovsecurity` → `codecovsecops`). The actual code change between 6.0.1 and 7.0.0 is two commits (license CI removal + version bump). The inputs used by `ci.yml` (`files`, `token`, `fail_ci_if_error`) are stable across the version boundary. `fail_ci_if_error: false` means even a Codecov upload failure does not block CI. Merging to the new SHA-pinned reference is a supply-chain hardening step.

---

## Recommendations

No fixes have been applied. This was a read-only sweep. All findings are classified and bundled; the orchestrator will present the bundles to the human for authorization.

Standing constraints:
- All fixes go through delivery (branch + PR); orchestrator never hand-edits source or factory specs.
- Maximum 10 fix PRs per maintenance run.

**Suggested prioritization for authorization:**

1. **Bundle A DOC-FIX PR** (DRIFT-D1/D2/D3/D4 + DRIFT-D8/D7/D12/exit-124 + CR-003/CR-004/DRIFT-D11): single PR to `develop` correcting CLAUDE.md architecture tree and README. Highest signal-to-noise; directly affects developer navigation and AI agent accuracy.
2. **Bundle B SC-04 + SC-06**: two-file factory-artifacts commit — ADR-0016 `.factory` copy gains CI-gate note (3 lines); S-3.07 + risk-register gain correct JRACLOUD-95368 citation. Small, high-precision.
3. **Bundle B SC-01**: four frontmatter `bc_count` edits in L2 domain-spec files. Cosmetic but closes the CANONICAL-COUNTS.md PENDING flags.
4. **Bundle C CR-001**: 1–3 line guard in `list_comments` matching `get_changelog` anti-stall pattern.
5. **Bundle D H-007**: holdout revision re-pointing resolution enforcement from reactive to proactive mechanism.
6. **Merge PR #519**: no code change; one-click dependabot merge.
7. **Bundle C CR-002**: mechanical 24-site batch replacing `serde_json::to_string_pretty` with `output::render_json`.
8. **Bundle B SC-07**: risk register RESOLVED annotations (~12 rows). Cosmetic completeness.
9. **Bundle D H-044 / H-027**: holdout prose revisions (re-verify mention-drop, collapse future-flip prose).
10. **Bundle B SC-02/SC-05**: README.md Document Map counts (pre-tracked PG-A) and optional STORY-INDEX retroactive entries.
