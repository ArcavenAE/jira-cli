---
document_type: blocking-issues-resolved
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-05-26T00:00:00
cycle: "cycle-001"
inputs: [STATE.md]
input-hash: "42eb2ca"
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
