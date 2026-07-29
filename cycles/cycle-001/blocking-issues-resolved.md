---
document_type: blocking-issues-resolved
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-05-26T00:00:00
cycle: "cycle-001"
inputs: [STATE.md]
input-hash: "37a375d"
traces_to: STATE.md
---

# Resolved Blocking Issues — cycle-001

<!-- Blocking issues that were resolved and archived from STATE.md.
     Open blocking issues remain in STATE.md. -->

## Formerly in Blocking Issues table

*(The Blocking Issues table was empty at compact-state time — no open blockers at 2026-05-26.)*

## Resolved Drift Items (extracted from STATE.md Drift Items table on 2026-05-26 compact-state run)

These rows had Status = RESOLVED / CLOSED in STATE.md and are archived here. The Drift Items table in STATE.md retains only OPEN / DEFERRED / TO_VERIFY / process-gap / TRACKED / FILED entries.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| DRIFT-002 | NFR-S-B holdout gap | SD-002 = Option A; NFR-S-B holdout now definable (S-1.05). | MEDIUM | **RESOLVED** | 2026-05-04 |
| ADV-P2-S12-001 | S-1.08 body line 274 stale dep | body line 274 updated to "No Wave 0 dependencies…" | MEDIUM | **RESOLVED** | 2026-05-07 |
| OBS-13-1 | JiraClient cosmetic typo | global sweep; 0 remaining matches | LOW | **RESOLVED** | 2026-05-07 |
| OBS-13-2 | Story manifest tooling gap | Story Manifest table (31 rows) added to STORY-INDEX v1.4.1 | LOW | **RESOLVED** | 2026-05-07 |
| CV2-001 | STATE.md stale story count | STATE.md line 54 fixed (30→31, W3:8→W3:9) | MEDIUM | **RESOLVED** | 2026-05-07 |
| CV2-002 | STORY-INDEX S-2.04 BC column incomplete | S-2.04 BC column completed (3→7 BCs); v1.4.2 | MEDIUM | **RESOLVED** | 2026-05-07 |
| CV2-003 | SD-003 holdout gap | H-NEW-VERBOSE-001/002 registered; WAVE-PLAN updated (v1.1.1); S-0.06 cross-link added | MEDIUM | **RESOLVED** | 2026-05-07 |
| S-0.05-DEV | SD-002 doc-vs-code drift (gate canonization) | SD-002 canonized to Option B-revised (`#[cfg(debug_assertions)]`) during S-0.05 implementation. 151-subprocess-test compatibility preserved. Threat model mitigation equivalent to Option A original. Doc updates: SD-002.md (Resolution, Options, Decision Log, version 1.0.1) + S-0.05 (Context, BC, ACs, Implementation Notes, Compliance Rules) + S-0.07 (Context, AC-004, holdout spec SD field) + STATE.md (DEC-007, Current Phase Steps). | MEDIUM | **RESOLVED** | 2026-05-07 |
| S-1.05-AC-001 | Repo-level GitHub Secret Scanning | User enabled secret_scanning + push_protection on Zious11/jira-cli via `gh api PATCH security_and_analysis` (2026-05-08). Verified via `gh api repos/Zious11/jira-cli --jq '.security_and_analysis'` showing both enabled. CI gitleaks job + GitHub native scanner now both active for layered defense. | HIGH | **RESOLVED** | 2026-05-08 |
| S-2.02-DEFER | JSON field-name reconciliation: `transitioned` vs `changed` | Verified canonical field name is `changed` per src/cli/issue/json_output.rs:4-10; documented in S-2.07 v2.0.0 AC-005 and DEC-011; holdout-scenarios.md:84 corrected to `"changed": false` in same factory-artifacts commit | LOW | **RESOLVED** | 2026-05-08 |
| S-2.06-DEFER-01 | src/duration.rs parse_duration calculator | H-018 replaced in place (Option 2) per research-agent recommendation; follow-up Option 4 story queued in Wave 3 as S-3.10 to delete the deprecated calculator. See `.factory/research/H-018-holdout-strategy-research.md`. | LOW | **RESOLVED** | 2026-05-08 |
| WV2-ADV-01 | S-2.07 spec + 11 test docstrings BC-7.3.004 semantic mis-anchor | Story spec re-anchored to BC-7.1.001 + BC-7.4.013-016 (Fix-PR A). Develop-side test docstring re-anchoring deferred as WV2-FIX-A-FOLLOWUP-01. | BLOCKING | **RESOLVED** — 2026-05-08 — Fix-PR A (spec portion resolved; test docstrings deferred as FOLLOWUP-01) | 2026-05-08 |
| WV2-ADV-03 | S-2.06 spec + 2 holdout test names BC-6.2.013 mis-anchor | Story spec re-anchored to BC-6.2.006 (Fix-PR A). Develop-side test name rename deferred as WV2-FIX-A-FOLLOWUP-02. | BLOCKING | **RESOLVED** — 2026-05-08 — Fix-PR A (spec portion resolved; test function names deferred as FOLLOWUP-02) | 2026-05-08 |
| WV2-CV-01 | .factory/specs/prd/cross-cutting.md:316 BC-X.5.005 H1 heading deprecated calculator | Updated to reflect post-S-2.06 dual-function situation (validator is production path). | BLOCKING | **RESOLVED** — 2026-05-08 — Fix-PR A | 2026-05-08 |
| WV2-CV-02 | .factory/stories/WAVE-PLAN.md stale status / S-3.10 gap | Wave 2 status was ACTIVE/draft; Wave 3 showed 9 stories without S-3.10; S-2.06→S-3.10 dependency missing. | DRIFT | **RESOLVED** — 2026-05-08 — Fix-PR A | 2026-05-08 |
| WV2-CV-05 | .factory/STATE.md Phase 3 progress count off-by-one | Phase 3 progress count audit: Wave 0 (7) + Wave 1 (8) + Wave 2 (7) = 22. STATE.md previously claimed 23/31 (74%). Corrected to **22/31 (71%)** in Wave 2 gate-close commit. | DRIFT | **RESOLVED** — 2026-05-08 — Wave 2 gate-close commit | 2026-05-08 |
| WV2-CV-07 | .factory/stories/STORY-INDEX.md + STATE.md S-2.02 SHA typo | SHA typo 75289600 → 7528960 in STATE.md. | DRIFT | **RESOLVED** — 2026-05-08 — Fix-PR A | 2026-05-08 |
| WV2-SEC-01 | src/duration.rs::parse_duration_validate CWE-400 uncontrolled resource consumption | Wave 2 integration-gate security finding. parse_duration_validate reflected unbounded user input into error messages. Added MAX_DURATION_INPUT_LEN = 64 byte cap + 2 regression-pin tests. Not exploitable; defense-in-depth. | MEDIUM | **RESOLVED** — 2026-05-08 — develop @ 6cb9994 (PR #310) | 2026-05-08 |
| PG-365-1 | BC Trace field stale-test-count pattern | BC body Trace fields cite test counts that drift as tests are added. First caught at P4 of #365 F1d. Eliminated numeric counts across bc-2, bc-3, bc-5, bc-7 (9 sites); CI guard `scripts/check-bc-no-numeric-test-counts.sh` added; `spec-guard` CI job wired in ci.yml. | LOW | **RESOLVED** — PR #369 @ 6ca9587 (2026-05-15) | 2026-05-15 |
| DRIFT-010 | risk-register.md header says "Total risks: 34" but Summary table says 36 | Resolved 2026-05-18 by #288 F1d pass-07: risk-register.md lines 5-6 updated to 36 risks (1C/7H/11M/17L), matching body Summary table and CANONICAL-COUNTS. | MEDIUM | **CLOSED** | 2026-05-18 |
| S-288-pr2-PG-2c | No cache-write-error policy for best-effort cache operations | DONE inline during S-288-pr2 (CLAUDE.md gotcha added). | LOW | **RESOLVED inline** | 2026-05-19 |
| S-2.06-DEFER-01 (duplicate entry) | src/duration.rs parse_duration calculator | See above — resolved as S-3.10. | LOW | **RESOLVED** | 2026-05-08 |
| S-2.06-DEFER-01 second mention | S-2.06-DEFER-01 resolved by S-3.10 story queuing | See S-3.10 story delivery. | LOW | **RESOLVED** | 2026-05-08 |
| DEFER-383-1 | docs-cleanup — bc-3-issue-write.md subdomain heading depth harmonization | Delivered as #391 (bc-3 subdomain 3.8 heading harmonized; factory-artifacts commit pushed 2026-05-20); issue closed 2026-05-20. | LOW | **RESOLVED** | 2026-05-20 |
| DEFER-383-2 | docs-cleanup — CANONICAL-COUNTS.md change-attribution wording | DROPPED — premise refuted by validation; attribution already present at CANONICAL-COUNTS.md:55/57. Research: `.factory/research/issue-383-deferred-followups-validation.md` | LOW | **DROPPED** | 2026-05-20 |
| DEFER-383-3 | process-gap — `scripts/check-spec-counts.sh` validates only `definitional_count`, not cumulative `total_bcs` | RESOLVED — delivered as S-392 / PR #393 / issue #392 closed 2026-05-20 | LOW | **RESOLVED** | 2026-05-20 |
| DRIFT-BC2-PROSE | docs — `bc-2-issue-read.md` frontmatter `total_bcs: 93` vs body preamble "92 behavioral contracts" | bc-2-issue-read.md body preamble corrected 92→93 (AC-5, factory-artifacts 5852a4a); the new DRIFT-002 guard now prevents recurrence of this drift class. | LOW | **RESOLVED-BY-S-392** | 2026-05-20 |
| DI-E2E-F5-2 | S-E2E-1 F5 LOW deferred: `sprint current` clean-skip only matched "No active sprint" — kanban/simple board would panic. Provisioning assumption was that board must be Scrum. | LOW | **RESOLVED** — FIX-B in S-E2E-2 (PR #434 @ 2ca9fc1, 2026-05-29): sprint_list and sprint_current now detect "simple board" response and emit a clean SKIP log line instead of panicking. | 2026-05-29 |

---

## Resolved Drift Items extracted from STATE.md on 2026-06-02 (compact-state run)

These rows had Status = RESOLVED / CLOSED / COMPLETE in the Drift Items table and are archived here. The Drift Items table in STATE.md retains only OPEN / DEFERRED / TO_VERIFY / process-gap / TRACKED / FILED entries.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| DRIFT-E2E-1 | E2E cycle-close: mechanical jr-invocation-vs-clap-tree guard | Recommended in DEC-038 [process-gap]. Shipped via PR #443 (merge c395e27, 2026-05-31): tests/e2e_cli_surface_guard.rs validates 25 jr subcommand paths + ~40 (path,flag) assertions against `jr --help` offline at CI time. Post-merge live e2e run 26722732004 = 57/0 SUCCESS. | LOW | **RESOLVED — shipped PR #443 @ c395e27 (2026-05-31); live 57/0 run 26722732004 (DEC-048).** | 2026-05-31 |
| OQ-1 | Sprint coverage gap: ES board 1 = "simple board" (team-managed project). `jr sprint` unsupported for team-managed boards; live suite skips sprint tests but passes green. Real sprint coverage needs company-managed Scrum board or jr enhancement. | LOW | **RESOLVED 2026-05-29** — board recreated as company-managed Scrum (id 3); JR_E2E_BOARD_ID updated 1→3; run 26659977426 20/0 sprint tests RUN+PASS (DEC-036). | 2026-05-29 |
| R-NEW-1 | E2E provisioning: jira-e2e GitHub env + secrets/vars + ES project + board 1 created. | MEDIUM | **COMPLETE 2026-05-29** (DEC-035). | 2026-05-29 |
| E2E-PG-1 | mechanical jr-invocation-vs-clap-tree validator (assumed-CLI-surface defect class, ~10x recurrence) | **RESOLVED 2026-05-31** — tests/e2e_cli_surface_guard.rs shipped via PR #443 (merge c395e27; 11/11 CI; live e2e run 26722732004 = 57/0). See DEC-048 + DRIFT-E2E-1. | self-improvement/test-infra | **CLOSED** | 2026-05-31 |
| DRIFT-E2E-ALT | Gated test `test_e2e_issue_edit_issuetype_multikey_bulk_roundtrip` clean-skips until `JR_E2E_ISSUE_TYPE_ALT` is set in the jira-e2e GitHub Environment AND the E2E project has a 2nd issue type. Live validation of issueType bulk resolution deferred to CI (nightly e2e.yml). Owner: maintainer. Target: next E2E env touch. | LOW | **RESOLVED 2026-06-01** — JR_E2E_ISSUE_TYPE_ALT=Bug set in jira-e2e GitHub Environment (PR #454). Live run 26779732719 = 66/0: test now RUN and PASSES live (DEC-058). | 2026-06-01 |
| BUG-LABEL-400 | jr `issue edit --label add:/remove:` (single key) sends malformed bulk payload → HTTP 400 on real Jira. Root cause: fabricated editedFieldsInput schema (`labels.labelsAction` + `{"name":..}` items) matches no real Jira schema; wiremock-only coverage never validated live. **RESOLVED by fix chain: #447 (single-key PUT /rest/api/3/issue/{key} update.labels) + #448 (multi-key labelsFields schema) + #449 (integer taskId deserializer) + #450 (numeric issue IDs deserializer). Final live run 26735722804 (develop @ cff86d2) = 61/0 ALL GREEN.** | HIGH | **RESOLVED — fix chain #447-#450 live-green (run 26735722804, 61/0, 2026-06-01)** | 2026-06-01 |

---

## Resolved Blocking Issues / Drift Items extracted from STATE.md on 2026-06-14

### WIN-BRANCH-PROTECTION (DEC-096 / DEC-097) — RESOLVED 2026-06-14

| Field | Value |
|-------|-------|
| **ID** | WIN-BRANCH-PROTECTION |
| **Severity** | HIGH |
| **Opened** | 2026-06-14 (DEC-096) |
| **Resolved** | 2026-06-14 (DEC-097) |
| **Root Cause** | clippy→matrix rename (ADR-0016 Decision 3) made the branch-protection required context `Clippy` permanently unsatisfiable — all PRs to develop and main were BLOCKED. |
| **Fix Applied** | PATCH `.../protection/required_status_checks` (scoped endpoint, NOT top-level PUT — preserves code-owner review settings) on BOTH develop AND main branches. New required contexts: Format, Clippy (ubuntu-latest), Clippy (windows-latest), Test (ubuntu-latest), Test (macos-latest), Test (windows-latest), MSRV (1.85.0), Deny (licenses + vulnerabilities) — all app_id 15368. Stale bare `Clippy` context removed. require_code_owner_reviews preserved. |
| **Verification** | `gh pr view 510 --json mergeStateStatus` changed from BLOCKED → CLEAN. PR #510 mergeable. |
| **Lesson** | LESSON-MATRIX-BRANCH-PROTECTION: whenever a CI job is renamed or converted to a matrix, re-verify branch-protection required_status_checks immediately. Use SCOPED endpoint only. |
| **Decision** | DEC-097 |

### Closed Open Issues Tracker row — #510 MERGED (2026-06-14)

| Issue | Title | Resolution |
|-------|-------|------------|
| #510 | S-WIN-5 ci.yml Windows job + XDG→seam migration | SQUASH-MERGED to develop @ 4bd83c7. Squash title: `ci(windows): add windows-latest matrix, .gitattributes eol=lf, XDG→JR env-seam migration, /STACK:8388608 stack fix`. Remote branch deleted. Windows-build F4 COMPLETE (6/6). |

---

## Resolved Blocking Issues / Drift Items extracted from STATE.md on 2026-06-15

### CIGATE-BRANCH-PROTECTION-SWAP (DEC-103) — RESOLVED 2026-06-15

| Field | Value |
|-------|-------|
| **ID** | CIGATE-BRANCH-PROTECTION-SWAP |
| **Severity** | LOW |
| **Opened** | 2026-06-15 (DEC-102; recorded when S-CIGATE-1 ci-gate aggregator was delivered via PR #518 → develop @ e9b2269 and harness-blocked swap was identified as the remaining activation step) |
| **Resolved** | 2026-06-15 (DEC-103; user-executed) |
| **Root Cause** | After ci-gate aggregator job was shipped in ci.yml (PR #518), the 8 per-job required status check contexts on develop and main still needed to be replaced with a single `CI Gate` context to activate the aggregator as the authoritative gate. This was a repo-admin action the harness could not perform. |
| **Fix Applied** | Safe 2-step add-before-remove: (1) added `CI Gate` (app_id 15368) to required_status_checks on both develop and main; (2) removed the 8 old per-job contexts (Format, Clippy (ubuntu-latest), Clippy (windows-latest), Test (ubuntu-latest), Test (macos-latest), Test (windows-latest), MSRV (1.85.0), Deny (licenses + vulnerabilities)). spec-guard promoted to a blocking check via the aggregator. require_code_owner_reviews and strict mode preserved. |
| **Verification** | Both develop and main now have exactly ONE required status check: `CI Gate` (app_id 15368). Verified read-only by user. |
| **Lesson** | LESSON-MATRIX-BRANCH-PROTECTION (already codified DEC-096): the durable fix is an aggregator gate job in ci.yml so that required_status_checks membership is decoupled from individual job names. The aggregator (S-CIGATE-1) is that fix — now activated. |
| **Decision** | DEC-103 |
| **Related** | DEC-096 (matrix-rename fragility class discovered), DEC-097 (intermediate fix: 8 matrixed contexts), DEC-102 (ci-gate aggregator shipped), DEC-103 (swap complete; fragility class structurally eliminated) |

---

## Resolved Blocking Issues extracted from STATE.md on 2026-06-17 (Issue #522 F5 Pass-1 remediation burst)

| ID | Issue | Severity | Resolved | Resolution |
|----|-------|----------|----------|------------|
| F-1 [#522-F5-P1] | proptest `prop_text_to_adf_holds_inv1` strategy `".*"` does NOT match `\n` — LF/CRLF/\n\n paths not generatively covered; rustdoc + AC-014 overstate coverage. | LOW | 2026-06-17 (code @ c70f07d) | test-writer changed both `prop_text_to_adf_holds_inv1` + `prop_492_arbitrary_string_holds_core_invariants` to strategy `"[\r\n\t a-zA-Z0-9]{0,64}"` — explicit charset samples `\r`/`\n`/`\t` generatively. Rustdoc corrected. AC-014 in S-522 prose harmonized byte-for-byte with committed code (snippet `"[\\r\\n\\t a-zA-Z0-9]{0,64}"`; overstated "printable ASCII" corrected to bounded charset description). 235→237 adf tests green; clippy+fmt clean. |
| F-2 [#522-F5-P1] | BC-7.2.011 v1.10.0 inline spec-changelog [1.10.0] states "13 rows" in EC-12 behavior table; actual count is 12. | LOW | 2026-06-17 (.factory commit this burst) | product-owner corrected .factory/specs/prd/bc-7-output-render.md line ~697 inline spec-changelog [1.10.0] entry: "13 rows" → "12 rows" (verified by counting table rows 379-390 = 12 data rows). Global spec-changelog.md [1.3.21] did NOT contain "13 rows" — no change there. count guards unaffected (check-spec-counts.sh + check-bc-cumulative-counts.sh both pass). |
| F-3 [#522-F5-P1] | `text_to_adf("")` and `text_to_adf("\n\n\n")` → empty-paragraph shape unpinned; `assert_no_raw_newline_in_text_nodes` trivially passes on empty. Add explicit positive `assert_eq!` on the `doc > [paragraph > [text("")]]` shape. | LOW | 2026-06-17 (code @ c70f07d) | test-writer added two positive shape tests: `test_text_to_adf_empty_string_shape` and `test_text_to_adf_all_newlines_shape`, both asserting `doc > [paragraph > [text("")]]`. 235→237 adf tests green. |

---

## Resolved Drift Items extracted from STATE.md on 2026-06-17 (Issue #522 follow-ups folded, DEC-118)

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| CLAUDE.md-S522-GOTCHA | root CLAUDE.md block-HTML gotcha | Added push_text/push_code/text_to_adf INV-1 chokepoint gotcha to root CLAUDE.md: Other→space for \r\n/\r/bare-\n, codeBlock preserves \n, HtmlBlock→Algorithm B; block→hardBreak vs inline→space asymmetry; CR-01 HIGH bug note; Unicode-line-sep OOS note. Follow-up from F7 non-blocking item CLAUDE.md-S522-GOTCHA. | LOW | **RESOLVED @ 5a0b7d8** (DEC-118 — human-approved fold-in before PR) | 2026-06-17 |
| MUTANTS-ADF-GLOB | .cargo/mutants.toml examine_globs omits src/adf.rs | Added `src/adf.rs` to `examine_globs` in .cargo/mutants.toml. Canonical `cargo mutants --in-diff <develop...HEAD> --list` now lists 21 src/adf.rs mutants (was 0 — false-green eliminated). Surfaced during F6 (#522); verified in follow-up commit @ 5a0b7d8. | MED | **RESOLVED @ 5a0b7d8** (DEC-118 — human-approved fold-in before PR) | 2026-06-17 |

---

## Resolved Blocking Issues / Drift Items extracted from STATE.md on 2026-06-17 (Issue #522 CYCLE CLOSED, DEC-119)

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| PRE-EXISTING-LONE-CR | src/adf.rs push_text/push_code/text_to_adf | heading+codeBlock raw `\r` survival + bare `\n` Other-ctx (CR-01). EC-11+EC-12+CR-01 fixed. F5 CONVERGED; F6 PASS (1850/0, 100k proptest); F7 5/5 PASS. Shipped in PR #523 @ 53f6d98. BC-7.2.011 v1.11.0. | HIGH | **RESOLVED — shipped in PR #523 @ 53f6d98 (DEC-119)** | 2026-06-17 |

---

## Resolved Drift Items extracted from STATE.md on 2026-06-18 (S-FORK-OPS-SIGN-1 CYCLE CLOSED, DEC-121)

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| FORK-OPS-SIGN-INJECTION | sign-and-publish.yml | CWE-77: github.event.workflow_run.head_branch unquoted in shell with Apple secrets. All inline attacker-controllable context across both signing workflows env-bound. Structural-scope rewrite in F5 surfaced 23 injection sites vs the original 5 hardcoded. | HIGH | **RESOLVED — PR #535 → 1a2a79b (2026-06-18)** | 2026-06-18 |
| FORK-OPS-ALPHA-RACE | sign-and-publish.yml | Non-atomic alpha tag creation (TOCTOU). Atomic alpha-tag via `gh api git/refs` (HTTP 201/422 protocol); `--cleanup-tag` purge dropped. | HIGH | **RESOLVED — PR #535 → 1a2a79b (2026-06-18)** | 2026-06-18 |
| FORK-OPS-NIT-USECROSS-GUARD | sign-and-publish.yml | `rustup target add` step lacked `if: !matrix.use_cross` guard. Was already satisfied by PR #529 (confirmed). Defensive parity step added to alpha-build. | LOW | **RESOLVED — PR #535 → 1a2a79b (2026-06-18)** | 2026-06-18 |
| FORK-OPS-NIT-TMP-PREDICTABLE | sign-and-publish.yml | Predictable /tmp/cs.out + /tmp/spctl.out paths in verify steps (CWE-377/362). Replaced with mktemp + trap EXIT. | LOW | **RESOLVED — PR #535 → 1a2a79b (2026-06-18)** | 2026-06-18 |
| FORK-OPS-NIT-PIPEFAIL | sign-and-publish.yml | `set -e` without `set -o pipefail` on codesign \| tee chains (CWE-390). Changed to `set -eo pipefail` in all 3 verify locations. | LOW | **RESOLVED — PR #535 → 1a2a79b (2026-06-18)** | 2026-06-18 |

---

## Resolved Drift Items extracted from STATE.md on 2026-06-18 (S-TESTTOOL-1 CYCLE CLOSED, DEC-120)

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| MAINT-MUTANTS-GLOBS-01 | mutants.toml examine_globs | `.cargo/mutants.toml` examine_globs expanded to cover `src/api/jira/issues.rs` + `src/cache.rs`. Baseline full-repo scan blind spot eliminated. Fixed in S-TESTTOOL-1 PR #533 → b4a470f. | LOW | **RESOLVED — PR #533 → b4a470f (2026-06-18)** | 2026-06-18 |
| #526-F6-KEYRING-GATE | auth_profiles keyring test gate | `auth_profiles::global_profile_flag_targets_auth_status` gated behind `JR_RUN_KEYRING_TESTS` + early-return guard. Keychain contention hang risk eliminated. Fixed in S-TESTTOOL-1 PR #533 → b4a470f. | LOW | **RESOLVED — PR #533 → b4a470f (2026-06-18)** | 2026-06-18 |

---

## Resolved Drift Items extracted from STATE.md on 2026-06-19 (S-FORK-OPS-BACKFILL CYCLE CLOSED + RELEASED v0.6.0-dev.5)

These 3 MED drift items were marked "IMPLEMENTED-ON-DEVELOP — fully closes at F7/release" and shipped in PR #542 → develop @ 71f33c6 (v0.6.0-dev.5 tag, release.yml run 27832585851).

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| FORK-OPS-BACKFILL-DESTRUCTIVE | release-gap-fill.yml | `gh release delete+recreate` can clobber curated release notes. Fixed: release-gap-fill.yml updated to use non-destructive upsert approach; S-FORK-OPS-BACKFILL-1 story delivered. | MED | **RESOLVED — PR #542 → 71f33c6 (v0.6.0-dev.5, 2026-06-19)** | 2026-06-19 |
| FORK-OPS-BACKFILL-WIN-TARGET | backfill-release.yml | Windows target absent from backfill-release.yml → backfilled releases lacked Windows binary. Fixed: Windows target added; S-FORK-OPS-BACKFILL-1 story delivered. | MED | **RESOLVED — PR #542 → 71f33c6 (v0.6.0-dev.5, 2026-06-19)** | 2026-06-19 |
| FORK-OPS-GITLEAKS-DOC | GITLEAKS_DISABLED | `GITLEAKS_DISABLED` secret-scan opt-out variable undocumented in CLAUDE.md/spec. Fixed: documentation added in S-FORK-OPS-GITLEAKS-DOC-1 story. | MED | **RESOLVED — PR #542 → 71f33c6 (v0.6.0-dev.5, 2026-06-19)** | 2026-06-19 |

---

## 2026-06-19 Maintenance Sweep (Bundle E) — Archive Confirmation

Maintenance sweep 2026-06-19 (develop @ 71f33c6 / v0.6.0-dev.5) confirmed the following 3 items were already correctly archived from STATE.md Drift Items table prior to this sweep. Listed here for audit completeness.

| ID | Archived In | Severity | Archive Date | Confirmation Source |
|----|-------------|----------|--------------|---------------------|
| FORK-OPS-SIGN-INJECTION | "Resolved Drift Items extracted 2026-06-18 (S-FORK-OPS-SIGN-1)" section above | HIGH | 2026-06-18 | spec-coherence.md §3.1; sweep 7+8+11 |
| FORK-OPS-ALPHA-RACE | "Resolved Drift Items extracted 2026-06-18 (S-FORK-OPS-SIGN-1)" section above | HIGH | 2026-06-18 | spec-coherence.md §3.1; sweep 7+8+11 |
| FORK-OPS-GITLEAKS-DOC | "Resolved Drift Items extracted 2026-06-19 (S-FORK-OPS-BACKFILL)" section above | MED | 2026-06-19 | spec-coherence.md §3.1; sweep 7+8+11 |

STATE.md Drift Items table does not contain any of these rows. Archive is complete. Maintenance sweep verdict: GREEN.

---

## Resolved Drift Items extracted from STATE.md on 2026-06-19 (bookkeeping burst — maintenance sweep final reconciliation)

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| MAINT-HOLDOUT-H007-DRIFT | Holdout H-007 | H-007 holdout mechanism was stale — described reactive 400 fallback only, not the proactive ADR-0015 enforcement path added by S-JSM-RESOLUTION-REQUIRED. Updated in factory-artifacts commit aa11887 (2026-06-19 maintenance sweep spec/holdout accuracy pass): H-007 text updated to reflect that `jr issue move` now invokes proactive enforcement BEFORE the POST (REQUIRED branch) per ADR-0015 BC-3.2.013, with reactive BC-3.2.009 400-backstop preserved alongside. | LOW | **RESOLVED — factory-artifacts aa11887 (2026-06-19)** | 2026-06-19 |

---

## Resolved Drift Items extracted from STATE.md on 2026-06-19 (PR #543 merge close-out — develop @ 6bdb251)

PR #543 squash-merged into develop @ 6bdb251 (docs: 2026-06-19 maintenance sweep accuracy fixes (DRIFT-D13/D15/D16, D9, CR-010)). The 5 items below were previously `IN PR #543 (pending merge)` in the STATE.md Drift Items table and are now fully resolved.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| FORK-OPS-BACKFILL-TIMEOUT-PARITY | backfill-release.yml | backfill build job lacked `timeout-minutes` (release.yml=60); minor housekeeping. Fixed in PR #543 (CR-010). | LOW | **RESOLVED — PR #543 → develop @ 6bdb251 (2026-06-19)** | 2026-06-19 |
| DRIFT-D9 | ADR-0014 doc-accuracy | ADR-0014 text doc-accuracy gap identified in 2026-06-19 maintenance sweep. Fixed in PR #543. | LOW | **RESOLVED — PR #543 → develop @ 6bdb251 (2026-06-19)** | 2026-06-19 |
| DRIFT-D13 | CLAUDE.md doc-accuracy | CLAUDE.md doc-accuracy item D13 identified in 2026-06-19 maintenance sweep. Fixed in PR #543. | LOW | **RESOLVED — PR #543 → develop @ 6bdb251 (2026-06-19)** | 2026-06-19 |
| DRIFT-D15 | CLAUDE.md doc-accuracy | CLAUDE.md doc-accuracy item D15 identified in 2026-06-19 maintenance sweep. Fixed in PR #543. | LOW | **RESOLVED — PR #543 → develop @ 6bdb251 (2026-06-19)** | 2026-06-19 |
| DRIFT-D16 | CLAUDE.md doc-accuracy | CLAUDE.md doc-accuracy item D16 identified in 2026-06-19 maintenance sweep. Fixed in PR #543. | LOW | **RESOLVED — PR #543 → develop @ 6bdb251 (2026-06-19)** | 2026-06-19 |

---

## Resolved Drift Items extracted from STATE.md on 2026-06-24 (maintenance sweep 2026-06-22 CLOSED — DEC-131)

PRs #547/#548/#549 squash-merged to develop @ 4022e00. The 5 items below were open in STATE.md Drift Items and are now fully resolved.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| MAINT-SEC-QUINN-PROTO | dependency | RUSTSEC-2026-0185 quinn-proto non-reachable (http3 feature off). Bumped quinn-proto to 0.11.15 in PR #547 hygiene bundle. | LOW | **RESOLVED — PR #547 → develop @ 4022e00 (2026-06-24); RUSTSEC-2026-0185 cleared** | 2026-06-24 |
| MAINT-PF-005-UNWRAP | code-quality | Unguarded-looking `.unwrap()` on `assets[idx].id` in linked.rs:225 (validated non-reachable; .expect() nit). Changed to `.expect()` with explanatory message in PR #547 hygiene bundle. | LOW | **RESOLVED — PR #547 → develop @ 4022e00 (2026-06-24)** | 2026-06-24 |
| H-019-EXIT-DRIFT | holdout | `--profile`/`JR_PROFILE` exit 78 not 64 for `foo:bar` boundary — confirmed real bug, not stale holdout. Exit code corrected from 78→64 in PR #548. | MED | **RESOLVED — PR #548 → develop @ 4022e00 (2026-06-24); H-019 holdout now accurate** | 2026-06-24 |
| MAINT-2026-06-17-SC-03 | ADR location | SC-03: docs/adr/ vs .factory/architecture/adr/ convention discrepancy. ADR-0007..0013 promoted to docs/adr/ and factory ADR index + ADR-0016 row corrected in PR #549. | LOW | **RESOLVED — PR #549 → develop @ 4022e00 (2026-06-24)** | 2026-06-24 |
| DOC-DRIFT-2026-06-22 | doc accuracy | CLAUDE.md src-file-tree stale, CHANGELOG [Unreleased] unpopulated, README version reference v0.3.0→v0.5.0 stale. All fixed in PR #547 hygiene bundle. | LOW | **RESOLVED — PR #547 → develop @ 4022e00 (2026-06-24)** | 2026-06-24 |

---

## Resolved Drift Items extracted from STATE.md on 2026-06-25 (Bundle D + SEC-001 CLOSED — DEC-132)

PRs #551/#552/#553 squash-merged to develop @ 35e20c9. The items below were TRACKED/OPEN in STATE.md Drift Items and are now fully resolved.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| SEC-001 | CWE-674 recursion | Uncontrolled recursion in adf.rs normalize/assign_local_ids/render_node. MAX_ADF_DEPTH=256 guard added; BC-7.2.012 authored; dual code+security review caught real off-by-one (reverse path accepted depth-256) + HIGH error-swallow + 5 mutation survivors — all closed; kill rate locally proven 100% via per-site flip verification. | LOW (upgraded MEDIUM during VSDD) | **RESOLVED — PR #553 → develop @ 35e20c9 (2026-06-25); BC-7.2.012 added** | 2026-06-25 |
| SEC-JR-SERVICE-NAME-GATE | JR_SERVICE_NAME not debug-gated | JR_SERVICE_NAME env var was not guarded by #[cfg(debug_assertions)] unlike JR_BASE_URL/JR_AUTH_HEADER, creating a potential redirect vector. Debug gate added to match canonical seam pattern. | LOW | **RESOLVED — PR #551 → develop @ 35e20c9 (2026-06-25)** | 2026-06-25 |
| DRIFT-CR-008 | test-helper dedup | extract_job_block / block-extraction helpers duplicated across test files. Deduplicated and consolidated in PR #552. | LOW | **RESOLVED — PR #552 → develop @ 35e20c9 (2026-06-25)** | 2026-06-25 |
| KEYRING-GUARD-IDIOM-DRIFT | process-gap | Three co-existing keyring-gate guard idioms; no meta-test enforces canonical form. Canonical idiom established + meta-test tests/keyring_guard_idiom.rs added in PR #552. | LOW | **RESOLVED — PR #552 → develop @ 35e20c9 (2026-06-25)** | 2026-06-25 |
| #532 / S-MAINT-532 | coverage-gap | Login/Refresh/Logout global-`--profile` fallback ungated — issue #532 coverage tests added in PR #552. | LOW | **RESOLVED — PR #552 → develop @ 35e20c9 (2026-06-25); issue #532 closed** | 2026-06-25 |
| DRIFT-331-PAGINATION / S-MAINT-CR-005 | get_issue_types_for_project | Inline reimplementation; already CLOSED-REFUTED 2026-06-24 — intentional/correct per code-reviewer. | LOW | **RESOLVED-REFUTED — S-MAINT-CR-005 CLOSED WON'T-FIX 2026-06-24** | 2026-06-24 |

---

## Resolved 2026-06-27 — BC-sub-clause pass close (DEC-138)

The items below were TRACKED/OPEN in STATE.md Drift Items and are now fully resolved.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| MISSING-BC-SUBCLAUSE-PATTERN | spec/process | Recurring blocker: ADF markdown→ADF behaviors (#471/472/474/483/489/492/522/473), cache D2 warm-hit no-HTTP, and read error-channel/partial_match behaviors lacked dedicated BC sub-clauses — breaking the holdout authoring anchor chain (broken-anchor class). BC-sub-clause pass authored BC-7.2.013 (footnote→ADF), BC-7.2.014 (bare-URL autolink), BC-7.3.010 (JSON render invariant + error channel), BC-6.2.018 (cache warm-hit zero-HTTP), BC-X.10.001 EC-1 (partial_match no-network). Confirmed #474/483/489/522 already bodied — no action needed. 603→605. MEDIUM drift item RESOLVED. | MEDIUM | **RESOLVED — 2026-06-27; DEC-138; factory-artifacts ba60b15** | 2026-06-27 |

---

## Resolved 2026-06-30 — cold-resume snapshot / two spec-only cycles closed (DEC-146/DEC-147)

The items below were TRACKED/OPEN/RESOLVED in STATE.md Drift Items and are archived here on the 2026-06-30 cold-resume snapshot. Develop UNCHANGED @ 3b122a8.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| HOLDOUT-COVERAGE-GAPS-2026-06-25 | holdout coverage | HIGH gaps CLOSED by D4 (2026-06-26). MED gaps CLOSED 2026-06-30 (DEC-146): 8 holdouts (71→79). ALL 3 BLOCKED TARGETS CLOSED 2026-06-30 (DEC-147): `issue edit --label` → BC-3.4.020 + H-NEW-LABEL-FORK-001; `board view` → BC-5.1.005 + H-NEW-BOARD-VIEW-001; `issue edit --dry-run` → BC-3.4.021 + H-NEW-DRY-RUN-001. Holdouts 82. Epic fully closed. | LOW | **RESOLVED — all targets closed 2026-06-30 (DEC-146/147)** | 2026-06-30 |
| HOLDOUT-BLOCKED-TARGETS-BC-PASS | holdout coverage | 3 targets: `issue edit --label` single-vs-bulk fork, `board view` truncation/scrum-vs-kanban, `issue edit --dry-run` plannedChanges. CLOSED 2026-06-30 (DEC-147): BC-3.4.020/021/5.1.005 authored; holdouts H-NEW-LABEL-FORK-001/DRY-RUN-001/BOARD-VIEW-001 delivered. Holdouts 79→82. | MEDIUM | **RESOLVED — BCs authored + holdouts delivered (DEC-147)** | 2026-06-30 |
| E2E-EDGE-CASE-GAPS-2026-06-27 | E2E coverage | All 3 tiers delivered (DEC-141): offline-CLI PR #563 (DEC-139), wiremock PR #564 (DEC-140), holdout spec G-ADF-FOOTNOTE (DEC-141 — H-NEW-ADF-006 re-anchor + H-NEW-ADF-009 + H-NEW-ADF-008 sibling re-anchor; holdouts 70→71). G-ADF-BARE-URL covered by H-NEW-ADF-008 re-anchor to BC-7.2.014. Epic fully closed. | MEDIUM | **RESOLVED — 2026-06-27 (DEC-141)** | 2026-06-27 |
| MUTATION-CI-TIMEOUT | ci-budget | PR #567 squash-merged → develop @ 3b122a8. cargo-mutants HARD-REQUIRED via ci-gate.needs; absolute --timeout 240; `timeout-minutes: 90`; 5 false-green guards; 15/15 CI green. S-MUTATION-CI-TIMEOUT-1 filed (retroactive). Stories 96→97. DEC-144. | MEDIUM | **RESOLVED — 2026-06-28 (DEC-144); PR #567 @ 3b122a8** | 2026-06-28 |
| HOLDOUT-STALE-2026-06-25 | holdout staleness | H-NEW-MP-001 (--story-points→--points) FIXED in D4; H-007 (ADR-0015 mechanism) FIXED in D4 (re-anchored to BC-3.2.013 proactive + BC-3.2.009 fallback). H-019 FIXED. H-028 FALSE POSITIVE. No remaining stale holdouts. | LOW | **RESOLVED — all stale items fixed by D4 (2026-06-26)** | 2026-06-26 |
| DOC-DRIFT-2026-06-25 | doc hygiene | D1 bundle: CLAUDE.md missing BC-7.2.012 Gotchas entry (ADF recursion guard, SEC-001, #553); CHANGELOG [Unreleased] missing #551/#550. All of DRIFT-S3-001/002/003/004 RESOLVED — DRIFT-S3-003 via D2 factory commit 89d94d8; DRIFT-S3-001/002/004 via PR #554 (squash-merged → develop @ aa2cdca). | MEDIUM | **RESOLVED — PR #554 merged 2026-06-25 (develop @ aa2cdca)** | 2026-06-25 |
| PATTERN-HYGIENE-2026-06-25 | code hygiene | D3 bundle: PF-010/011 bare .unwrap() w/o invariant comment in src/cli/assets/schemas.rs; PF-016 src/cli/issue/create.rs 2,880 LOC; PF-017 src/cli/issue/workflow.rs 1,341 LOC. Unwrap-comment hygiene PF-008/012/013/014. | LOW | **RESOLVED — PR #555 merged 2026-06-25 (develop @ 6b395d3). PF-010..014/016/017 closed.** | 2026-06-25 |
| SC-002-SEC-001-STORY-HOUSEKEEPING | spec coherence | D2 factory-only: S-MAINT-SEC-001 story status draft / bcs:[] post-merge #553; ADF_MAX_DEPTH=64 vs shipped MAX_ADF_DEPTH=256. Closed: BC-7.2.012 anchored in story (bcs:[BC-7.2.012]), status→done, ADF_MAX_DEPTH→MAX_ADF_DEPTH 256 corrected; F2-PIECEWISE reclassified RESOLVED-CODIFIED; adr shadow removed. | LOW | **RESOLVED — 2026-06-25; factory commit 89d94d8** | 2026-06-25 |
| F2-PIECEWISE-PROTOCOL | phase-f2 process | Protocol: dispatch consistency-validator after EACH spec-author fix before next adversary pass. Established 2026-06-20, enforced, codified in cycles/cycle-001/lessons.md. Confirmed still enforced 2026-06-25. | LOW | **RESOLVED-CODIFIED — 2026-06-25; protocol enforced; codified in lessons.md** | 2026-06-25 |

---

## Resolved 2026-06-30 — CITATION-DEBT-FILEWIDE cycle CLOSED (DEC-148)

CITATION-DEBT-FILEWIDE-2026-06-30 (MEDIUM drift item) was opened at the end of the BC-SUB-CLAUSE
+ HOLDOUT cycle (DEC-147) to track file-wide ADR-0012 relocation citation debt in
`.factory/specs/prd/` files. This entry records the RESOLVED-PARTIAL closure of that item.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| CITATION-DEBT-FILEWIDE-2026-06-30 | spec/metadata | Pre-existing stale citations in bc-3-issue-write.md, bc-2-issue-read.md, and BC-INDEX.md from ADR-0012 Seam A/B module extractions (create.rs→edit.rs/jsm_create.rs; helpers.rs→field_resolve.rs). **RESOLVED-PARTIAL — `.factory/specs/prd/` perimeter DONE (DEC-148):** 12 relocations + BC-3.4.016 sibling-propagation add + 2 descriptor rewrites + 2 changelog symbol fixes + 1 prose fix in bc-3-issue-write.md; 1 relocation in bc-2-issue-read.md; 11 relocations + 1 symbol correction + 1 add in BC-INDEX.md. 7 adversary passes → 3 consecutive CLEAN. check scripts exit 0. **Remaining product-file ring** (docs/adr/0014:176, docs/specs/jsm-e2e-coverage:49, docs/specs/2026-05-13-search-issue-keys:129, src/api/jira/issues.rs:285 rustdoc, archived docs×2) split to CITATION-DEBT-PRODUCT-FILES-2026-06-30 (MEDIUM, OPEN) per DEC-147 DEFERRAL-PERIMETER-SCOPING. | MEDIUM | **RESOLVED-PARTIAL — DEC-148 (2026-06-30); product-file ring → CITATION-DEBT-PRODUCT-FILES-2026-06-30** | 2026-06-30 |

---

## Resolved 2026-07-02 — CITATION-DEBT-PRODUCT-FILES SHIPPED (DEC-149)

CITATION-DEBT-PRODUCT-FILES-2026-06-30 (MEDIUM drift item, opened DEC-147/DEC-148) tracked
ADR-0012 relocation citation debt in PRODUCT files on the develop branch, requiring a develop PR.
Both PRs shipped 2026-07-02 (human-merged, admin bypass, CI green throughout).

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| CITATION-DEBT-PRODUCT-FILES-2026-06-30 | spec/metadata | ADR-0012 relocation citations in PRODUCT files: docs/adr/0014-jsm-request-type-dispatch.md:176 (HIGH — mislabeled create.rs as "canonical implementation"), docs/specs/jsm-e2e-coverage.md:49 (MED), docs/specs/2026-05-13-search-issue-keys.md:129 (MED), src/api/jira/issues.rs:285 rustdoc (LOW). **RESOLVED — PR #568** `docs: fix ADR-0012 Seam A/B relocation citations (create.rs → edit.rs / jsm_create.rs)`: 7 doc/comment-only citation corrections across 4 product files (docs/adr/0014-jsm-request-type-dispatch.md, docs/specs/jsm-e2e-coverage.md, docs/specs/2026-05-13-search-issue-keys.md, src/api/jira/issues.rs). Cleared the HIGH (ADR-0014 mislabeled create.rs). No behavior change. Adversarially converged (multiple rounds → 3 consecutive clean passes on final diff). Human-merged (admin bypass) after rebase onto #569. develop 3b122a8 → 39caf39. | MEDIUM | **RESOLVED — 2026-07-02; DEC-149; PR #568 @ 39caf39** | 2026-07-02 |
| ANYHOW-RUSTSEC-2026-0190 | security/deps | anyhow 1.0.102 unsoundness advisory (RUSTSEC-2026-0190) discovered while preparing PR #568; freshly-published advisory was turning ci-gate red on all open PRs via cargo-deny. **RESOLVED — PR #569** `chore(deps): bump anyhow 1.0.102 → 1.0.103 (RUSTSEC-2026-0190)`: Cargo.lock + CHANGELOG only; fixed-first per human direction (separation of concerns); #568 rebased onto #569 after. develop e79943b (PR #569) → 39caf39 (PR #568). | HIGH | **RESOLVED — 2026-07-02; DEC-149; PR #569 @ e79943b** | 2026-07-02 |

---

## Resolved 2026-07-02 — MUTANTS-EXAMINE-GLOBS cycle SHIPPED (DEC-150)

PR #570 squash-merged by human 2026-07-02. develop 39caf39 → c4b3aa9. Story worktree cleaned up.
Two drift items closed as part of cycle close-out.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B | mutation coverage | `.cargo/mutants.toml::examine_globs` listed only `src/cli/issue/create.rs` after ADR-0012 Seam A/B split (PRs #556/#558). Surfaced by #568 adversarial gate (DEC-149). **RESOLVED — PR #570** `ci(mutants): restore scope — add edit.rs + jsm_create.rs to examine_globs; fix policy-doc citations (DEC-149)`: added `src/cli/issue/edit.rs` (~99 mutants) and `src/cli/issue/jsm_create.rs` (~9 mutants) to `examine_globs`; corrected function-location citations in policy doc (`docs/specs/cargo-mutants-policy.md`); repointed stale ci.yml:195 scope comment (authorized F5 F-1 MED). Full VSDD pipeline: F1→F3 story #100 (S-MUTANTS-EXAMINE-GLOBS-1 v1.2)→F4 delivery (3 commits: 5486c34, 1da0571, 475a1aa)→F5 CONVERGED (2 fix rounds + 3 clean diverse-lens passes)→consistency-validator CONSISTENT→PR #570 created→mutants job PASS 35s 0-mutant path→human-merged 2026-07-02 (DEC-128 honored). Scope: ~594→~702 mutants (+18%). | MEDIUM | **RESOLVED — 2026-07-02; DEC-150; PR #570; develop @ c4b3aa9** | 2026-07-02 |
| CICD-SETUP-TIMEOUT-MINUTES-STALE | doc hygiene | `.factory/cicd-setup.md` §2 VSDD checklist row claimed `timeout-minutes: 60`; actual value has been 90 since PR #567 (S-MUTATION-CI-TIMEOUT-1, DEC-144, 2026-06-28). Pre-existing drift surfaced by F5 adversarial gate round-1 pass-3 of the MUTANTS-EXAMINE-GLOBS cycle. **RESOLVED — factory-artifacts cycle-close commit 2026-07-02 (DEC-150):** `.factory/cicd-setup.md` §2 timeout-minutes 60→90; §1.1 job-catalog scope shorthand updated; §1.1a scope list updated to all 11 examine_globs entries. Note: this drift item was separate from AC-003 scope (examine_globs coverage prose); both fixed in same factory-artifacts commit per DEC-144/PR #567 as source. | LOW | **RESOLVED — 2026-07-02; DEC-150; factory-artifacts commit** | 2026-07-02 |

---

## Resolved 2026-07-28/29 — F2 adversary grind closure (DEC-190 / DEC-191)

Seven drift items confirmed closed during SOH-DX-1 F2 adversary grind and state compaction on 2026-07-28/29.

| ID | Area | Description | Severity | Status | Resolved Date |
|----|------|-------------|----------|--------|---------------|
| ZERO-HTTP-PROOF-VERIFIED | spec integrity | AC-8 and AC-13 zero-HTTP proof depends on wiremock received_requests() capturing requests to unregistered paths. Verified against wiremock-0.6.5 source: handle_request pushes every request UNCONDITIONALLY before mock_set.handle_request — unmatched paths ARE recorded; spec claim holds; failure mode safe (recording disabled → unwrap() panics loudly). Surfaced as UNVERIFIED in pass-69; resolved by orchestrator against crate source. | INFO | CLOSED — verified correct (2026-07-28) | 2026-07-28 |
| ADVERSARY-AGENT-NONFUNCTIONAL | platform/tooling | Adversary agent dispatches failing at 14-30% rate. Root cause RE-ATTRIBUTED to platform defect GitHub issue #47936 (background subagents terminate mid-work with no result block; NOT a prompting issue). Merged into AGENT-IDLE-NO-REPORT. Route to Anthropic. Engine bugs (a)/(b)/(c) remain real but tracked separately as ENGINE-ADVERSARY-TWO-BUGS. | HIGH | CLOSED — MERGED INTO AGENT-IDLE-NO-REPORT; re-attributed to platform defect #47936 (2026-07-28) | 2026-07-28 |
| SUBSTITUTE-ADVERSARY-RATIFICATION-PENDING | process/gate | Passes 48-52 ran via consistency-validator with adversarial checklist rather than adversary agent; fresh context and adversarial framing preserved but adversary system prompt absent. Required human ruling on DEC-189 window eligibility. | MEDIUM | RESOLVED — DEC-190 (2026-07-27): human instruction "keep grinding to 3 strict" ratified substitute passes as DEC-189 window-eligible; DEC-190 MUST be disclosed at F2 gate | 2026-07-27 |
| PHANTOM-ADR-0017 | spec/metadata | ADR-0017 cited in six real files but appeared missing from docs/adr/. Verified FALSE POSITIVE: ADR-0017 exists at .factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md (ARCH-INDEX.md:34; Accepted 2026-07-15). Prior search missed the documented canonical location (.factory/specs/architecture/decisions/ per ARCH-INDEX.md:3-5 split). | MEDIUM | CLOSED — FALSE POSITIVE (2026-07-28) | 2026-07-28 |
| CANONICAL-COUNTS-STALE-ADR-LOCATIONS | spec/metadata | CANONICAL-COUNTS.md §ADRs claimed ADR-0007..0013 in `.factory/architecture/adr/` (directory does not exist). Corrected per ARCH-INDEX.md:3-5: ADR-0001..0016 in docs/adr/, ADR-0017+ in .factory/specs/architecture/decisions/. Count of 17 preserved and confirmed correct. | LOW | CLOSED — FIXED (2026-07-28 LEDGER-BURST) | 2026-07-28 |
| STRICT-WINDOW-NO-FIXED-POINT | process/criterion | DEC-189's zero-findings redefinition of "clean" had no reachable fixed point on a mature spec — the documented cause of the grinding stall (passes 68+69 returned ZERO findings confirming the fixed point was reachable; DEC-189's criterion blocked closure). Root cause: DEC-189 was stricter than VSDD prescribes. | MEDIUM | CLOSED — RESOLVED by DEC-191 (2026-07-28): VSDD gap-vs-refinement criterion adopted; reachable fixed point confirmed | 2026-07-28 |
| SPEC-INLINE-REVERT-SIGNAL | spec integrity | P73-001 (REFINEMENT, LOW): bc-3-issue-write.md lines ~3427/3484 carry 8a0a2422 hyphenation workarounds with no inline pending-revert-by-S-627-1 marker; the F1 delta-analysis was the sole source of the revert obligation. Fix: carry the revert obligation into the S-627-1 story body. | LOW | CLOSED — DISCHARGED: [PENDING-REVERT-S-627-1] inline annotations added to bc-3-issue-write.md BC-3.9.001 Trace and BC-3.9.003 Trace in spec v1.3.162 (six-axis review remediation) | 2026-07-29 |
