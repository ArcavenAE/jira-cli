---
document_type: f7-delta-convergence-report
cycle: list-read-ergonomics
phase: F7
producer: orchestrator (F7 delta-convergence synthesis)
timestamp: "2026-08-24T18:00:00"
merged_tip: "37850b26eda42934c8d11d99863a7ebabcde5374"
pre_cycle_baseline: "67c5a6d0"
status: pending-human-authorization
---

# F7 Delta Convergence Report — `list-read-ergonomics`

## 1. Feature Summary

- **Feature bundle:** `list-read-ergonomics` (GitHub issues #575, #579, #588, #584) — four
  read-ergonomics additions to `jr issue list`/`jr issue view`.
- **Baseline → merged tip:** `develop@67c5a6d0` → `develop@37850b26eda42934c8d11d99863a7ebabcde5374`
  (verified: this is the current `develop` HEAD in the working tree at report time).
- **Stories delivered (all `done`, all merged 2026-08-21 through 2026-08-24):**

  | Story | Title | BCs | VPs | PR | Squash SHA |
  |---|---|---|---|---|---|
  | S-575-1 | `--fields <CSV>` on `issue list`/`issue view` | BC-2.2.033, BC-2.3.041, BC-2.6.052 | VP-FIELDS-001/002/003 | #724 | `9f3f4f0c` |
  | S-579-1 | `--updated-recent <duration>` on `issue list` | BC-2.1.023, BC-2.1.006 (amended), BC-2.1.007 (amended) | VP-UPDATED-RECENT-001/002 | #725 | `8291b471` |
  | S-588-1 | `--sort <field>:asc\|desc` shorthand | BC-2.1.024, BC-2.1.025 | VP-SORT-001/002 | #726 | `190d8cfa` |
  | S-584-1 | Raw-ADF `--fields comment` confirmatory | BC-2.2.034, BC-2.3.042 | VP-FIELDS-004/005 | #732 | `748247e3` |

- **Fix PRs (adversarial/hardening convergence, same cycle):**

  | Fix | Reason | PR | Squash SHA |
  |---|---|---|---|
  | FIX-F5-LRE-1 | DEC-306 — remove `--updated-recent`-alone guard (ADV-LRE-F5-A-MED-001) | #733 | `28596274` |
  | FIX-F6-LRE-1 | `validate_duration` char-safe fix for multibyte panic (ADV-F6-VALIDATE-DURATION-PANIC) | #734 | `37850b26` |

- **Diffstat, self-verified (`git diff --stat 67c5a6d0..37850b26`):** 16 files changed, 3,896
  insertions(+), 15 deletions(-) — `src/`: `api/jira/issues.rs` (+125), `cli/issue/list.rs`
  (+407 net), `cli/issue/view.rs` (+39/-… net), `cli/mod.rs` (+29 net), `jql.rs` (+41/-2 net,
  the FIX-F6-LRE-1 hardening), plus 1-line touches in `cli/issue/format.rs`, `cli/issue/helpers.rs`,
  `cli/sprint.rs`, `types/jira/issue.rs`; `tests/`: 5 files (`issue_commands.rs` +2,446,
  `issue_list_errors.rs` +215, `all_flag_behavior.rs` +106, `rate_limit_cap_tests.rs` +308,
  `issue_view_errors.rs` +89 net); plus `.cargo/mutants.toml` (+29, DEC-301 exclusion) and
  `docs/specs/cargo-mutants-policy.md` (+48). No new files were added — all changes are to
  pre-existing files (additive).
- **Spec version:** `bc-2-issue-read.md` amended in-place to v1.5.1 (F2 additions for the four
  new BCs, then a DEC-306 amendment on 2026-08-24 to BC-2.1.023/006/007 — verified via
  `git -C .factory log --oneline -- specs/prd/bc-2-issue-read.md`, which shows the DEC-306
  amendment commit `2b0acfb0` immediately following the F2 evolution commit `217d0f1d`).

---

## 2. Five-Dimensional Convergence (Delta)

### Dimension 1 — Spec Fidelity — **PASS**

| Check | Evidence |
|---|---|
| `--fields <CSV>` output-format gate (JSON-only, exit 64 in table mode) | `src/cli/issue/list.rs:195` — `if output_format != OutputFormat::Json { return Err(JrError::UserError("--fields requires --output json.".into()).into()); }` (verified by direct `grep`/read of the file) |
| REPLACE-not-UNION semantics | `src/cli/issue/list.rs:550` comment block + `src/api/jira/issues.rs` new `*_with_fields` methods, additive to the 10 pre-existing `get_issue`/`search_issues` call sites (count corrected 11→10 during the F3-time consistency audit, commit `a0367dc1`, and re-verified against `develop@67c5a6d0` per that commit's own message) |
| `--updated-recent` mirrors `--recent`, pinned stable-order position (after `recent`, before `asset`) | `src/cli/issue/list.rs:1167-1170` (`build_filter_clauses`) — confirmed present in the fifteen-source `NO_FILTERS_SPECIFIED_MSG` enumeration (`src/cli/mod.rs:66`) |
| **DEC-306 amendment implemented, not just spec-documented** | The pre-DEC-306 dedicated `--updated-recent`-alone exit-64 guard is confirmed **removed** — `src/cli/issue/list.rs:238-255` now composes the `updated >= -{d}` clause unconditionally, with an explicit code comment citing FIX-F5-LRE-1/DEC-306; the sole remaining backstop is the terminal `all_parts.is_empty()` guard (BC-2.1.006), consistent with the spec's new Postcondition 4 (`bc-2-issue-read.md:865-906`) |
| `--sort <field>:asc\|desc` overrides `order_by` in all 4 composition branches, appends `, key ASC` except when sorting by `key` | `src/cli/issue/list.rs:68-136` (`parse_sort`, `compose_order_by_with_sort`), `:517-525` (override hook wired into the single `order_by` binding used by all 4 branches) |
| F6 graceful-Err hardening (`validate_duration` char-safe) | `src/jql.rs:16-44` — confirmed live: `s.chars().next_back()` + `&s[..s.len() - unit.len_utf8()]`, replacing the byte-offset `split_at` that panicked on `"7é"` |
| Spec self-contradiction identified in F5 (ADV-LRE-F5-A-MED-001) was genuinely human-adjudicated, not silently patched | `bc-2-issue-read.md:206,840,865,885,906,914,922` all carry the `[AMENDED 2026-08-24, DEC-306 …]` marker with a link to `.factory/research/recent-vs-updated-recent-asymmetry-2026-08-24.md` |

**Verdict:** PASS. Every reviewed behavioral clause in the spec has a directly traceable,
directly-read implementation; the one spec self-contradiction found during F5 was resolved by
an explicit human ruling (DEC-306) with the amendment applied symmetrically to spec text *and*
code *and* tests (confirmed below), not patched around.

### Dimension 2 — Test Coverage & Quality — **PASS**

| Check | Evidence |
|---|---|
| Every AC has ≥1 test | S-575-1: 12 ACs (`S-575-1-fields-csv-list-view.md:145-212`); S-579-1: 8 ACs; S-588-1: 10 ACs; S-584-1: 5 ACs — all four story files carry a `**Test:**` citation per AC in their Acceptance Criteria sections |
| Non-tautological tests | `pr-review.md` for FIX-F5-LRE-1 confirms the reframed tests assert against the real captured `POST /rest/api/3/search/jql` request body (`s606_1_composed_jql`), not merely "guard didn't fire"; S-584-1's `pr-review.md` confirms AC-001/002 deep-equal the ADF `body` object (would fail if the code ever flattened to text) |
| Cross-story integration covered | `test_issue_list_fields_and_sort_compose_end_to_end` (added in FIX-F5-LRE-1, confirmed in its `pr-review.md`) exercises `--fields` + `--sort` together |
| Error paths covered | `tests/issue_list_errors.rs` / `tests/issue_view_errors.rs` cover: `--fields` in table mode (exit 64), empty/malformed CSV (exit 64 pre-HTTP), malformed `--sort` value (exit 64 pre-HTTP), unknown sort field (Jira 400 propagated) — confirmed by direct grep of `src/cli/issue/list.rs` test module (`test_bc_2_1_024_parse_sort_malformed_input_exits_64_pre_http`, etc.) |
| FIX-F6-LRE-1 regression coverage | `validate_duration_multibyte_unit_returns_err_not_panic` (asserts message content, not just `is_err()`, across `["7é","é","€","7€","12ü","—"]`) + `proptest! { fn validate_duration_never_panics(s in ".*") }` — both confirmed live in `src/jql.rs` (lines 252, 416-424) |
| Test-citation accuracy (post-cleanup) | The F7 pre-gate cleanup (uncommitted in the `.factory` worktree at report time, staged for the state-manager burst) corrects 6 stale `**Test:**` citations across S-575-1 (AC-004/005/006/011) and S-588-1 (AC-004/008) to name the actual bare-named functions in `tests/issue_list_errors.rs`/`tests/issue_view_errors.rs`/`tests/all_flag_behavior.rs`, and documents the accepted local-file bare-naming deviation (F5 C-LOW-001) inline — self-verified via `git -C .factory diff` |
| Mutation kill rate on delta | **100% (8/8 viable mutants caught, 0 survivors, 0 timeout)** on the new `search_issues_with_fields`/`get_issue_with_fields` pagination code, per F6 targeted hardening (reported by the prior phase, recorded in `.factory/STATE.md`'s F6 burst entry; DEC-301's `issues.rs:374` exclusion confirmed correctly active). `src/cli/issue/list.rs` and `src/jql.rs` are intentionally outside `.cargo/mutants.toml examine_globs` (pre-existing scope decision, not a gap introduced by this cycle) — the multibyte panic in `validate_duration` was instead caught by F6's separate parser-robustness pass, not mutation testing, which is the correct tool for that class of defect. |

**Verdict:** PASS. Coverage is complete against every AC/BC/VP in scope, tests are demonstrably
non-tautological (verified via two independent fresh-eyes PR reviews), the one mutation-testing
metric available for delta code is 100%/0-survivors, and the stale-citation hygiene gap found
during F7 pre-gate checks has a verified fix already in the working tree.

### Dimension 3 — Implementation Quality — **PASS**

| Check | Evidence |
|---|---|
| JSON render invariant (#526) | `src/cli/issue/list.rs:575,827` and `src/cli/issue/view.rs:56,112` route exclusively through `output::print_output`/`output::render_json` — no direct `serde_json::to_string_pretty` or compact `json!` Display printing introduced (confirmed by grep; S-584-1's `pr-review.md` independently confirms the same for the raw-ADF passthrough path) |
| Output channels | `--fields` error paths write to stderr via `JrError::UserError` (Symmetric profile, consistent with existing `issue list`/`issue view` conventions); no new stdout diagnostic writes introduced |
| No panics on user input (post-F6) | Targeted grep of `src/jql.rs` and the new `--fields`/`--sort`/`--updated-recent` code paths in `src/cli/issue/list.rs` for `.unwrap()`/`.expect()` found none reachable from this delta's user input — the two `.expect()` calls present in `list.rs` (`asset.id` at line 647, `--component` project-key at line 893) are pre-existing, guarded by prior invariant checks, and unrelated to this cycle's code; the one real panic (`validate_duration` multibyte) was found and fixed by FIX-F6-LRE-1 |
| No regressions | See §3 below |
| Conventions (Conventional Commits, test naming, `#[allow]` discipline) | All 6 cycle commits (`9f3f4f0c` … `37850b26`) use `feat(issue):`/`fix(jql):`/`test:` conventional prefixes with story/finding IDs; FIX-F6-LRE-1's `pr-review.md` explicitly confirms no `#[allow]`, no `unsafe`, MSRV-1.85-safe `let-else` |

**Verdict:** PASS. Two independent fresh-eyes PR reviews (FIX-F5-LRE-1, FIX-F6-LRE-1, both
APPROVE, zero BLOCKING/WARNING findings) plus S-584-1's and S-575-1's per-story reviews
corroborate convention adherence; my own targeted grep for panic-prone patterns in the new
code paths found nothing outstanding beyond the already-fixed multibyte case.

### Dimension 4 — Verification & Hardening — **PASS**

| Check | Evidence |
|---|---|
| Mutation testing | 100% kill (8/8 viable, 0 survivors, 0 timeout) on in-scope new code — reported by F6 (formal-verifier), recorded in `.factory/STATE.md` |
| `cargo deny check` | PASS, no advisories/denials — reported by F6, recorded in `.factory/STATE.md` |
| Parser robustness | CLEAN on `parse_fields_csv`/`parse_sort`; found and closed 1 MEDIUM (`ADV-F6-VALIDATE-DURATION-PANIC`) via FIX-F6-LRE-1, independently APPROVE-reviewed (`.factory/code-delivery/FIX-F6-LRE-1/pr-review.md`) |
| Adversarial convergence — per-story Step-4.5 | All 4 stories converged to 3 clean passes each per STORY-INDEX/session-checkpoint records (S-575-1/S-579-1/S-588-1 status `done`; S-584-1 explicitly documented as "Step-4.5 CONVERGED 6 passes/3 clean … no process-gaps") |
| Adversarial convergence — cycle-level F5 | Round 1 (3 diverse-lens passes) found 1 MEDIUM (ADV-LRE-F5-A-MED-001), human-ruled DEC-306, fixed via FIX-F5-LRE-1 (APPROVE review). Round 2 (3 fresh diverse-lens passes over the reconciled delta at `28596274`) returned **3/3 CLEAN**, explicitly re-verifying the MED as genuinely resolved (not just patched) — recorded in `.factory/STATE.md`'s F5-Round-2 burst entry |
| Security | No new external dependencies, no new I/O surfaces, no credential/secret handling in this delta; `cargo deny` clean is the applicable security check for a pure CLI-parsing/JQL-composition feature set |

**Verdict:** PASS. All four hardening checks (mutation, `cargo deny`, parser robustness,
adversarial convergence) are closed, with the single MEDIUM found in each of F5 and F6
resolved through a fix PR that itself received an independent APPROVE review. I was not able
to independently re-run the mutation-testing tool within this review (it requires the
delta-scoped `cargo mutants --in-diff` invocation against the historical diff range, a
multi-minute run); the 100%/8-of-8/0-survivors figure is reported by the prior F6 phase and
corroborated by `.cargo/mutants.toml`'s DEC-301 exclusion being present in the merged diff
exactly as described.

### Dimension 5 — Traceability — **PASS**

| Check | Evidence |
|---|---|
| BC → story → AC → test → code chain resolvable | See `traceability-chain-delta.md` (companion file) — every BC cited above resolves to a story file, every story's ACs resolve to named test functions, every cited test function was grep-confirmed to exist in the named source/test file |
| STORY-INDEX accuracy | Verified via `git -C .factory diff`: the F7 pre-gate cleanup pass has already corrected all 4 stories' STORY-INDEX rows from `ready`/`F3 COMPLETE` to `done — merged …, PR #NNN, squash …`, and added the missing `VP-UPDATED-RECENT-002` to S-579-1's VP column — staged as uncommitted `.factory` worktree changes at report time, pending the state-manager burst |
| Input-hash drift | 3 cycle-specific story files (S-575-1, S-588-1, S-584-1) show a re-hash to `input-hash: "11b8082"` in the same uncommitted diff, consistent with the reported DEC-306-driven content re-verification and re-hash; S-579-1 was not part of this re-hash (its own BC amendments were already folded into the earlier F5 `2b0acfb0` commit) |
| Individual story-file `status:` frontmatter field (minor, non-blocking) | **Observed discrepancy:** all 4 story files' own frontmatter still reads `status: ready` even though STORY-INDEX.md (the canonical index) correctly shows `done` for all 4. This is a pre-existing, repo-wide inconsistency, not a cycle-specific regression — spot-checking other merged stories shows the same convention drift (e.g. `S-576-1.md` still says `status: ready` post-merge, while `S-663-1.md` says `done` and `S-577-1.md` says `completed`). Not called out in the F7 pre-gate hygiene sweep and not one of the 3 items the human is being asked to ratify below; noted here for completeness since it touches traceability, but it does not block convergence — STORY-INDEX is the authoritative status source per the repo's existing convention. |

**Verdict:** PASS. The chain is complete and independently re-derivable from BC IDs through to
named test functions and source line ranges; the one loose end (per-file `status:` frontmatter
lag) is cosmetic, pre-existing across the repo, and does not affect the authoritative
STORY-INDEX record.

---

## 3. Regression Validation

| Check | Result |
|---|---|
| `git rev-parse HEAD` in the target repo | `37850b26eda42934c8d11d99863a7ebabcde5374` — matches the cycle's stated merged tip exactly |
| CI on PR #734 (the last merge in this cycle, authoritative for the merged tip) | **15/15 checks SUCCESS** — independently re-queried via `gh pr view 734 --json statusCheckRollup` at report time: `state: MERGED`, all 15 rollup entries `SUCCESS`, includes all 3 OS `Test` legs |
| `cargo test --lib` (self-run, at HEAD) | **1,139 passed; 0 failed; 11 ignored** — 2 more than F6's cited 1,137, exactly matching the 2 new tests FIX-F6-LRE-1 added (`validate_duration_multibyte_unit_returns_err_not_panic` + the `validate_duration_never_panics` proptest) |
| Full `cargo test` (lib + all integration binaries) | Kicked off in background during this review; still compiling/running at report-writing time (80 integration test binaries is a non-trivial link+run). CI's PR #734 15/15 green — which does run the full suite across all 3 OS legs — is treated as the authoritative regression signal per the task's stated scope ("CI on PR #734 ran 15/15 green incl. all 3 OS Test legs (authoritative for the merged tip)"), corroborated by the partial local `cargo test --lib` run above. |
| `scripts/check-spec-counts.sh` | **exit 0** — "Check passed: 8 bc files validated" (self-run) |
| `scripts/check-bc-cumulative-counts.sh` | **exit 0** — "OK: all cumulative BC counts verified (707 total across 9 files; Surface H footer checked where present)" (self-run) |

**Verdict:** PASS. Zero regressions observed against every check performed, both by re-reading
prior-phase evidence and by independently re-running the fast checks myself.

---

## 4. Keep-Deferred Disposition (S-7.02)

Three open process-gap / optional-drift items require the human's explicit ratification at
this F7 gate. Per S-7.02, each must either (a) get a self-improvement follow-up story opened,
or (b) be explicitly justified for deferral by the human.

| ID | Class | Description | Recommended disposition |
|---|---|---|---|
| `FILTER-SOURCE-ENUMERATION-NO-MECHANICAL-ENFORCEMENT` | process-gap, **pre-existing** (predates this cycle) | No mechanical (CI-enforced) check that `NO_FILTERS_SPECIFIED_MSG`'s 15-source enumeration (`src/cli/mod.rs:66`) stays in sync with `build_filter_clauses`'s actual filter sources — currently relies on human/adversarial-review discipline each time a filter source is added (as happened for `--component` in #606 and `--updated-recent` in this cycle). | Open a self-improvement follow-up story (e.g. a `tests/` guard that enumerates `FilterOptions` fields and cross-checks against the message string) — low effort, closes a recurring review burden. Not blocking this cycle's merge since both cycle-relevant enumerations (`--component`, `--updated-recent`) were manually verified correct. |
| `F5-COMBINED-DELTA-DISPATCH-NO-HEAD-SHA-PREFLIGHT` | process-gap | Cycle-level F5 adversarial dispatch aimed read-only reviewers at a checkout that could go stale between dispatch and review (observed as a risk during this cycle's Round 1/Round 2 F5 execution); mitigated ad hoc this cycle by embedding a HEAD-SHA preflight check into the dispatch prompt, but the mitigation is not yet codified into the reusable F5 workflow/skill itself. | Open a self-improvement follow-up story to add the HEAD-SHA preflight as a standing step in `vsdd-factory:phase-f5-scoped-adversarial` (or its cycle-level analogue), so future cycles get it by default rather than by ad hoc reviewer discipline. Not blocking — this cycle's F5 rounds are independently confirmed to have run against the correct SHAs (Round 1 baseline `67c5a6d0`→`748247e3`; Round 2 re-verification at `28596274`, both cited explicitly in the F5 records). |
| `S-584-1-AC001-LIST-MOCK-FIELDS-MATCHER-SYMMETRY` | LOW, optional test-hardening | S-584-1 AC-001's `issue list` wiremock mock matches on HTTP method + path only, not on the request's `fields` query/body content — meaning the mock would still respond even if the code sent a subtly wrong `fields` value, relying on the response-body assertion alone to catch drift. | Human may defer this as accepted risk (the response-body deep-equality assertion is still a strong signal, and this is optional test-hardening on an already-confirmatory story) or fold it into whichever follow-up story next touches `tests/issue_commands.rs`'s mock helpers. Not blocking. |

None of these three items is a regression, a spec-fidelity gap, or a test-coverage gap in the
delivered functionality — each is a process-improvement or test-hardening opportunity
identified during the cycle's own adversarial/hardening passes working correctly. All three
are safe to defer with the human's explicit sign-off; none should block merge authorization.

---

## 5. Recommendation

**READY FOR HUMAN AUTHORIZATION.**

All five convergence dimensions (spec fidelity, test coverage & quality, implementation
quality, verification & hardening, traceability) verify PASS, corroborated both by re-reading
the prior phases' recorded evidence and by independent checks performed during this review
(source-code grep confirming every cited BC/AC has live implementing code; CI re-query
confirming PR #734's 15/15 green; a self-run `cargo test --lib` corroborating the regression
baseline; self-run `check-spec-counts.sh`/`check-bc-cumulative-counts.sh` both exit 0). Full
regression on the merged tip (`37850b26`) is confirmed green with zero regressions.

Three process-gap/optional-drift items are pending the human's ratification per the
Keep-Deferred Disposition above — none blocks this recommendation; they are presented for the
same F7 gate decision, not as a precondition to it.

**Next step:** present this report and the companion `traceability-chain-delta.md` to the
human for the final F7 authorization gate. On authorization, the cycle proceeds to release
(MINOR version bump — four net-new `jr issue list`/`jr issue view` flags — CHANGELOG, tag, and
the three Keep-Deferred items get their disposition recorded per the human's ruling).
