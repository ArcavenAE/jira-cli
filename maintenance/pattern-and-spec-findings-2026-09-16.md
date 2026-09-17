# Maintenance Sweep — Pattern Consistency (Sweep 3) & Spec Coherence (Sweep 7)

**Date:** 2026-09-16
**Branch:** develop @ `01e278fc`
**Validator:** consistency-validator
**Mode:** REPORT ONLY (`pattern_consistency.auto_pr = false`) — no fixes applied, no PRs opened.

---

## Sweep 3 — Pattern Consistency (`src/`)

### Methodology note
Given the size of the tree (1,573 test functions, ~40k LOC across `src/cli/`), checks 2
(test naming) and 4 (output-channel discipline) used targeted grep sweeps plus manual
sampling rather than exhaustive per-file reads. Sampling scope is stated per finding.

### Pattern Findings

| Finding ID | Location | Description | Severity | Auto-fixable? | Note |
|---|---|---|---|---|---|
| PAT-001 | `src/cli/field.rs` (1,901 LOC) | Crosses ADR-0012's 1,000-LOC shard threshold but has **no entry** in CLAUDE.md's "Known Size Deviations" section. Confirmed absent via `grep -n "cli/field.rs" CLAUDE.md` (no match). File backs `jr field options <NAME>` (BC-X.14.001..004). | Major | No | Needs either a DOCUMENT-AS-IS entry (with rationale, mirroring `component.rs`/`attachments.rs`) or a sharding pass. |
| PAT-002 | `src/cli/auth/login.rs` (1,869 LOC) | Crosses ADR-0012's 1,000-LOC shard threshold but has **no entry** in CLAUDE.md's "Known Size Deviations" section. Confirmed absent via grep (no match). | Major | No | Same remediation options as PAT-001. |
| PAT-003 | `src/cli/auth/tests/mod.rs` (2,484 LOC) | Largest file under `src/cli/` by LOC; not documented anywhere in CLAUDE.md. ADR-0012's stated rule text ("`src/cli/` files at ≥1,000 LOC are shard candidates") does not explicitly exempt test modules, so this is a literal-text crossing, though the intent of ADR-0012 (production module sharding) plausibly doesn't target inline test files. | Low | No | Recommend either (a) explicitly scoping ADR-0012 to non-test files in its own text, or (b) adding a Known Size Deviations entry for consistency with how `attachments.rs`/`edit.rs` are documented. |
| PAT-004 | `src/cli/issue/edit.rs` (actual 3,287 LOC vs CLAUDE.md's documented ~3,187 LOC); `src/cli/mod.rs` (actual 1,453 LOC vs documented ~1,356 LOC) | Two already-documented Known Size Deviations entries have drifted ~100 LOC past their last-recorded figure without a corresponding CLAUDE.md re-measurement note (the pattern used elsewhere in the same section, e.g. `list.rs`'s "re-measured 2026-08-25"). | Low | No | Documentation-freshness only; not a new shard violation since both files are already flagged as DOCUMENT-AS-IS. Suggest folding into next doc-drift pass. |
| PAT-005 | `src/cli/issue/attachments.rs:1125` (`std::process::exit(1)`) | One deliberate deviation from the "route through `JrError::exit_code()`" convention, bypassing `main.rs`'s normal error-printing path. Carries a clear inline justification comment referencing "P1-007" and BC-2.7.008 fail-soft semantics — this is the **only** non-`main.rs` `process::exit` call in `src/`. | Low (informational) | No | Compliant with CLAUDE.md's "no lint/pattern suppression without justification" spirit, but this "house pattern" for silent exit-1 isn't cross-referenced anywhere in CLAUDE.md's Errors/Output-channel sections — only discoverable by reading the code comment. Consider a one-line pointer in CLAUDE.md's Errors section so future contributors don't rediscover/relitigate it. |

### Clean confirmations (no findings — stated for completeness)

- **Error handling / raw panics:** `grep -rn "panic!("` across `src/cli/` and `src/api/` returns ~55 hits; every hit is inside a `#[test]` function or a `#[cfg(test)]` module using the idiomatic "exhaustive match arm / expect-style" test-failure pattern (e.g. `other => panic!("expected X, got {other:?}")`). **No raw panics found in production (non-test) handler code paths.**
- **`process::exit`:** Exactly one call outside `main.rs` (PAT-005 above); it is justified and documented in-line.
- **Lint suppressions:** Only 2 code-level `#[allow(...)]` attributes exist in `src/` (excluding doc-comments that merely *mention* `#[allow(dead_code)]` as guidance in `src/types/jira/editmeta.rs`): `src/adf.rs:10099` (`#[allow(clippy::too_many_lines)]`, on a documented combinatorial test corpus, with a 5-line justification comment directly above it) and `src/api/refresh_coordinator.rs:56` (`#[allow(dead_code)]`, on a `#[cfg(test)]`-only helper, with a justification doc-comment). **Both suppressions carry the CLAUDE.md-required justification comment; both are compliant.**
- **#526 JSON render invariant:** No direct `serde_json::to_string_pretty` calls exist anywhere under `src/cli/` (all 13 hits repo-wide are in `src/cache.rs` persistence code, `src/adf.rs` test serialization, `src/output.rs`'s own sanctioned wrapper, or a test comment). No `println!("{}", json!(...))` Display-print pattern found. Every `src/cli/` file that branches on `OutputFormat::Json` also references `render_json`/`print_output` (verified via cross-check of all files containing `OutputFormat::Json` — zero files missing the invariant call). **Sweep 3 finds no #526 violations.**
- **Test naming spot-check:** 1,573 `test_*` functions exist; 90 carry an absolute-claim keyword (`never`/`always`/`only`/`exactly`) in the name. A sample of 5 (`test_bc_1_4_033_remediation_message_never_mentions_auth_logout`, `test_backend_io_error_message_never_suggests_relogin`, `test_dpapi_protect_flags_never_set_local_machine_bit`, plus two others) was read in full — in every sampled case the body's assertions match the claim in the name (e.g. explicit `!msg.contains(...)` / bitwise-flag checks). **No name/body mismatch found in the sample**; a full audit of all 90 was out of scope for this pass.

**Sweep 3 Verdict: FINDINGS** (2 Major, 1 Minor structural; 2 Low/informational — no auto-fix applied per config).

---

## Sweep 7 — Spec Coherence (`.factory/specs`, indexes)

### Guard Script Results

| Script | Exit Code | Result |
|---|---|---|
| `scripts/check-spec-counts.sh` | 0 | PASS — "Check passed: 8 bc files validated" |
| `scripts/check-bc-cumulative-counts.sh` | 0 | PASS — "OK: all cumulative BC counts verified (769 total across 9 files; Surface H footer checked where present)" |
| `scripts/check-bc-no-numeric-test-counts.sh` | 0 | PASS — "OK: no numeric test counts in BC Trace/Source fields" |
| `scripts/check-bc-citation-symbols.sh` | 0 | PASS — "Check passed: 525 citations checked" |
| `scripts/check-cargo-mutants-policy-citations.sh` | 0 | PASS — "Check passed: 22 bullets parsed, 77 (file, fn) pairs validated" |

All five automated guards pass with exit code 0.

### Canonical Count Cross-Check (vs. task baseline: 769 BCs / 86 VPs / 118 holdout / 185 stories)

| Metric | Source | Value found | Matches baseline? |
|---|---|---|---|
| BCs | `BC-INDEX.md` frontmatter `total_bcs` + `check-bc-cumulative-counts.sh` | 769 (cumulative, incl. range-collapsed; 539 individually-bodied `#### BC-` headings) | YES |
| Holdout scenarios | `.factory/specs/prd/holdout-scenarios.md` frontmatter `total_holdouts: 118`; independently counted 118 unique `### H-*` headings | 118 | YES |
| Stories | `.factory/stories/STORY-INDEX.md` frontmatter `total_stories: 185` | 185 | YES |
| VPs | *(see SPEC-001 below — no single source of truth found)* | N/A | Could not verify |

### Spec-Coherence Findings

| Finding ID | Location | Description | Severity | Auto-fixable? | Note |
|---|---|---|---|---|---|
| SPEC-001 | Repo-wide (`.factory/`) | No `VP-INDEX.md` or equivalent canonical Verification-Property registry exists. `CANONICAL-COUNTS.md` has BC/NFR/Holdout/Risk/ADR/Security-Decision/Cache-Type sections but **no VP-count section**. VP identifiers in this repo are namespaced per-feature (e.g. `VP-674-014`, `VP-AUTHDX-024`, `VP-576-001`, `VP-COMPONENT-024`) rather than a flat sequential `VP-NNN` scheme, so the task's "86 VPs" baseline cannot be checked against a single artifact. This is a **known, already-tracked** gap: backlog story `.factory/stories/S-PG-VP-REGISTRY-1-l4-verification-registry.md` ("Build an L4 Verification Property registry (ARCH-INDEX-equivalent for VPs)", status: draft, priority P2, 8 pts) exists specifically to close it. | Medium | No | Not new drift — pre-existing, self-disclosed backlog item. Recommend prioritizing S-PG-VP-REGISTRY-1 or, short of that, documenting the namespaced-VP convention as accepted design in CLAUDE.md so future sweeps don't re-flag it as an anomaly. |
| SPEC-002 | `.factory/stories/` vs `.factory/specs/prd/bc-*.md` | Proxy cross-reference of all 539 individually-bodied BC IDs against literal `BC-X.YY.NNN` citations anywhere under `.factory/stories/` (incl. `STORY-INDEX.md`) surfaced 180 BCs with no literal citation. Manual sampling of 5 (`BC-2.2.022`, `BC-2.2.023`, `BC-1.1.005`, `BC-3.1.001`, `BC-2.1.003`) showed these are **not** genuine orphans: e.g. `BC-3.1.001` traces to pre-existing v1 tests (`tests/cli_handler.rs:~58`, `tests/issue_commands.rs:~1646`) predating the VSDD story pipeline entirely, and others are covered via range-style citations in story text (e.g. "`BC-2.2.033/BC-2.3.041`" style groupings) that a literal-ID grep can't resolve. `STORY-INDEX.md`'s own "Gap Register — Unanchored Holdouts" section formally tracks only ~12 holdout-linked BCs (H-009, H-010, H-011, H-012, H-015, H-017, H-018, H-019, H-021, H-023, H-024, H-026), not general BC coverage. **No script analogous to `check-bc-cumulative-counts.sh` exists to verify BC→story/test coverage** — today it's grep-and-eyeball only, which this sweep's own proxy demonstrates is unreliable at 33% false-positive-prone scale. | Medium | No | Recommend a dedicated `check-bc-story-coverage.sh` guard that understands (a) range-collapsed BC-anchor citations and (b) the "Pre-existing Test Coverage" / "Gap Register" carve-outs, before any raw orphan count is treated as ground truth. This finding is about **missing tooling**, not a confirmed set of 180 uncovered BCs. |
| SPEC-003 | `.factory/specs/prd/CANONICAL-COUNTS.md` §"L2 domain-spec bc_count vs L3 total_bcs alignment (ADV-P17-003)" | L2 domain-spec `bc_count` values for `bc-01-auth-identity.md`, `bc-02-issue-read.md`, `bc-03-issue-write.md`, `bc-06-config-cache.md` are marked `PENDING` (lagging behind L3 `total_bcs`), and `bc-08-components.md` at L2 **does not exist at all** ("not created") despite 28 BCs existing at L3 for components. This is explicitly self-documented in CANONICAL-COUNTS.md as an accepted, recurring convention ("F2 touched L3 only, same posture as prior bc-1 deltas... L2 not kept in sync per established convention") — not newly discovered drift. | Low (informational) | No | Already tracked by the project's own convention; flagging only per the task's request to spot-check L1→L4 chain integrity. No action recommended beyond what the project already does. |

### Clean confirmations

- All 5 guard scripts: exit 0, zero findings.
- BC / holdout / story canonical counts: all three independently verified against the task's stated baseline and matched exactly (769 / 118 / 185).
- `check-bc-citation-symbols.sh` (525 citations) and `check-cargo-mutants-policy-citations.sh` (77 pairs) both clean — no stale `src/` symbol citations in BC Trace/Source fields or the mutants policy doc.

**Sweep 7 Verdict: FINDINGS** (all Medium/Low, none blocking; all 5 automated guards pass; canonical BC/holdout/story counts confirmed consistent; VP-registry absence and BC-coverage tooling gap are the two substantive items, both pre-existing/known rather than newly introduced regressions).

---

## Overall Summary

| Sweep | Verdict | Blocking findings | Notes |
|---|---|---|---|
| 3 — Pattern Consistency | FINDINGS | 0 (2 Major structural-documentation gaps, not code defects) | `field.rs` and `auth/login.rs` need Known Size Deviations entries; error handling, output-channel discipline, and lint-suppression discipline are otherwise clean. |
| 7 — Spec Coherence | FINDINGS | 0 (all guard scripts green; findings are tooling/documentation gaps) | Canonical counts (769/118/185) all verified. No VP-INDEX exists (known, backlogged). BC→story coverage has no automated guard; manual proxy is unreliable — recommend new tooling, not a claim of 180 real gaps. |

No fixes were applied and no PRs were opened, per `pattern_consistency.auto_pr = false`.
