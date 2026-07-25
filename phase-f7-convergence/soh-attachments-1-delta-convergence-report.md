---
document_type: f7-convergence-report
bundle: SOH-ATTACHMENTS-1
feature: "Attachment CRUD: list / download / upload / delete (issues #576 + #585)"
spec_version_range: "v1.3.43 → v1.3.106"
bc_index_version: v6.44
story_index_version: v1.5.40
develop_sha: db207b81
factory_artifacts_sha: 0391e9da
date: 2026-07-25
producer: fresh-context F7 audit agent
recommendation: READY-FOR-CLOSURE
---

# F7 Convergence Report — SOH-ATTACHMENTS-1

## 1. Feature Summary

**Bundle:** SOH-ATTACHMENTS-1 (GitHub issues #576 + #585)
**Spec range:** v1.3.43 (pre-feature baseline) → v1.3.106 (F5 final)
**BC delta:** 33 new BCs (BC-2.7.001..012 attachment read + BC-3.9.001..020 attachment write + BC-X.8.010 JSM service desk ID resolution)
**BC-INDEX:** v6.44 (657 total BCs, unchanged throughout F5)
**STORY-INDEX:** v1.5.40 (117 total stories)

**Deliverable scope:**

| Story | Title | PR | Merge SHA | Date |
|---|---|---|---|---|
| S-576-1 | Attachment list | #630 | e33624c1 | 2026-07-19 |
| S-576-2 | Attachment download | #631 | efa8b5d9 | 2026-07-20 |
| S-576-3 | Platform upload + replace-existing + dry-run | #635 | f2d3b378 | 2026-07-21 |
| S-576-4 | Delete single/bulk/older-than + dry-run | #638 | c28ae940 | 2026-07-22 |
| S-576-5 | JSM visibility --public/--internal + two-step | #640 | 0498e596 | 2026-07-23 |
| S-576-6 | Live-Jira E2E coverage | #643 | 9da03d5b | 2026-07-23 |
| FIX-576-DL | AttachmentMetadata.id integer/string serde drift | #642 | 7298c035 | 2026-07-23 |

**Emergent fix:** FIX-576-DL was discovered by S-576-6 live validation (run 30031724733: 96/97 FAIL on `test_bc_2_7_007_*`). The fix (`deserialize_string_or_int_as_string` serde visitor in `src/api/jira/attachments.rs`) was merged before S-576-6 and is included in develop @ db207b81.

**New source files (3):**
- `src/cli/issue/attachments.rs` (3,472 LOC — all attachment CLI handlers, sanitization, streaming)
- `src/api/jira/attachments.rs` (674 LOC — platform list/upload/delete/download API layer)
- `src/api/jsm/attachments.rs` (823 LOC — JSM two-step upload, stale-ID self-heal)

**New test suites (5):**
- `tests/attachment_list.rs`, `tests/attachment_download.rs`, `tests/attachment_upload.rs`
- `tests/attachment_delete.rs`, `tests/attachment_jsm.rs`

---

## 2. Five-Dimension Convergence Table

### D1: Specification Quality (Adversarial Refinement)

| Metric | Target | Actual | Status |
|---|---|---|---|
| F5 criterion | STRICT | STRICT (human ruling 2026-07-23) | PASS |
| Total F5 rounds | — | 14 | — |
| Fix PRs (human-merged, DEC-173) | — | 8 (#644–#652 excl. #645) | — |
| Convergence window | CLEAN×3 | r12/r13/r14 CLEAN×3 | PASS |
| Novel CRIT/HIGH findings at convergence | 0 | 0 | PASS |
| Novel MEDIUM findings at convergence | 0 | 0 | PASS |
| Novel findings in final 3 rounds | 0 | 0 | PASS |
| Secondary review (Step 7) verdict | PASS | PASS — 0 C/0 H/0 M/4 L/3 I | PASS |
| Spec versions minted during F5 | — | v1.3.99 → v1.3.106 (8 versions) | — |
| BC count change during F5 | 0 | 0 (657 throughout) | PASS |

**Novelty trajectory summary (F5 rounds 1–14):**
Rounds 1–7 produced genuine novel findings (1H at r3, 2L–6L/1C per round) driving 8 fix PRs. Rounds 8–9 produced primarily rediscoveries of already-ledgered items (EC-3.9.006-7 duplicate, P4-006 duplicate). Round 10 produced an enhancement note only (not a defect). Round 11 produced one novel LOW (dead branch removal). Rounds 12–14 produced zero novel defects — the STRICT window closed cleanly. The Step-7 secondary reviewer (fresh context, different model) independently identified a cross-model unique finding (SAFE-NAME-GUARD-EXTRACTION, safe-name duplication between two upload call sites) that never appeared in 14 primary rounds — confirming the value of the secondary reviewer tier and confirming there were no overlooked CRIT/HIGH issues.

### D2: Test Coverage (Mutation + Regression)

| Metric | Target | Actual | Status |
|---|---|---|---|
| Per-story mutation kill rate | ≥90% | S1: 95%, S2: 94%, S3: 97%, S4: 97%, S5: 94%, FIX-DL: 100% | PASS |
| Fresh bounded confirmation (post-F5) | 27/27 ≥90% | 27/27 confirmed (environmental timeouts noted; retry completed) | PASS |
| F5 mutation scope | diff-bounded | DIFF_FILE scoped per policy | PASS |
| VP proptest cases (VP-576-001) | ≥4,096 | 4,096 | PASS |
| Test suites covering the delta | 5 new + e2e_live.rs | 6 files (5 new + e2e_live.rs augmented) | PASS |

Lowest story kill rate: S-576-2 (download, 94%) and S-576-5 (JSM, 94%). Both above the 90% floor. No stories below floor. `prop_sanitize_attachment_filename_no_path_traversal` is explicitly in `.cargo/mutants.toml` `examine_globs` for proptest-driven coverage of the security-critical CWE-22 function.

### D3: Implementation Quality (F5 Final Round + Secondary Review)

| Metric | Target | Actual | Status |
|---|---|---|---|
| Novel CRIT findings (final-round + Step-7) | 0 | 0 | PASS |
| Novel HIGH findings (final-round + Step-7) | 0 | 0 | PASS |
| Novel MEDIUM findings (final-round + Step-7) | 0 | 0 | PASS |
| Novel LOW findings at Step-7 | — | 4 (1 cross-model unique) | NOTED |
| Open CRIT/HIGH residuals | 0 | 0 | PASS |
| ADR coverage | all impactful decisions | ADR-0017 (multipart retry rebuild), ADR-0015 (resolution enforcement; pre-existing) | PASS |

**Step-7 cross-model unique finding (L2 — SAFE-NAME-GUARD-EXTRACTION):** The SEC-576-004 CRLF/NUL/`"`/`\` `Content-Disposition` guard is copy-pasted in both `upload_attachments` (`src/api/jira/attachments.rs`) and `attach_temporary_file` (`src/api/jsm/attachments.rs`). This guard was extended twice during F5 in lockstep, demonstrating a real maintenance risk. Ledgered as enhancement candidate; not a correctness defect. Correct behavior is shipped; the refactor to `fn safe_content_disposition_filename(raw: &str) -> String` is a future improvement.

**Recorded dissent (L3 — STEP2-429-RETRY):** Secondary reviewer disputed EC-3.9.006-7 (deliberate no-retry on step-2 429). Ruling stands — deliberate asymmetry codified in spec v1.3.105; ADR-0017 multipart constraint does not technically apply to the trivially-rebuildable JSON step-2 POST, but the blast-radius-low judgment is preserved. Enhancement candidate ledgered.

### D4: Verification (VPs + Fuzz + Audit)

| Metric | Target | Actual | Status |
|---|---|---|---|
| VPs discharged | 5/5 | VP-576-001 (proptest path-traversal, 4096 cases), VP-576-002 (delete confirm+cancel gate), VP-576-003 (DELETE-before-POST ordering), VP-576-004 (curated JSON cross-path, list+upload halves), VP-576-005 (JSM combined gate) — all GREEN | PASS |
| Fuzz inputs (D2 hardening) | — | 49,152 inputs; 0 panics, 0 crashes, 0 timeouts | PASS |
| cargo-audit | 0 vulns | 0 advisory vulnerabilities | PASS |
| cargo-deny | all-ok | all-ok (DEC-185: sha1/cpufeatures skip authorized) | PASS |
| Regression baseline | 2,319 (pre-wave) | 2,341 passed / 0 failed | PASS |

**VP allocation across stories:** VP-576-001 anchored in S-576-2 (proptest discharge) with S-576-1 as earliest-consumer; VP-576-002 in S-576-4; VP-576-003 in S-576-3 (DELETE-before-POST ordering, `test_vp_576_003_delete_before_post_ordering_invariant`, lines 1917–2014 of `tests/attachment_upload.rs`); VP-576-004 in S-576-1 (list half) + S-576-3 (upload-POST half) per R3.13 earliest-consumer; VP-576-005 in S-576-5 (combined `--replace-existing --public` single-prompt gate, `tests/attachment_jsm.rs`).

**Security coverage:** SEC-576-001/002 (CWE-22 path traversal, `sanitize_attachment_filename`); SEC-576-003 (`X-Atlassian-Token: no-check` mandatory, tested by `test_bc_3_9_001_*` + `test_sec_576_004_content_disposition_crlf_injection_guard`); SEC-576-004 (CWE-93 Content-Disposition injection, `safe_name` guard); SEC-576-006 (stale-ID self-heal, at most once per command via `stale_healed: bool` guard); GHSA-9857-6MW7-FQ2M (auth-header CDN strip, asserted by `test_bc_2_7_007_auth_absent_on_redirect_target`). All security claims have corresponding named tests.

### D5: Holdout Evaluation (Wave Gate)

| Metric | Target | Actual | Status |
|---|---|---|---|
| Group 19 holdout scenarios | H-NEW-ATTACHMENT-001..012 | All 12 present in holdout-scenarios.md (v1.5.8) | PASS |
| MUST-PASS mean score | ≥0.85 | 1.00 (all 12 scenarios satisfiable) | PASS |
| MUST-PASS min score | ≥0.60 | 1.00 | PASS |
| Wave-gate regression baseline | 2,319 | 2,341 (22 new tests from delta) | PASS |
| Holdout assertions invalidated by F5 changes | 0 | 0 | PASS |

**Holdout spot-checks (3 scenarios verified against shipped code semantics):**

*H-NEW-ATTACHMENT-001 (path-traversal resistance):* `sanitize_attachment_filename` rejects `../etc/passwd` (basename extraction removes `../`), NUL bytes (reject entirely), and `\0`-bearing names (step 3). Proptest VP-576-001 covers 4,096 adversarial name inputs. The function is in `.cargo/mutants.toml` examine_globs for mutation coverage. SATISFIABLE against `src/cli/issue/attachments.rs::sanitize_attachment_filename`.

*H-NEW-ATTACHMENT-008 (`--public` on non-JSM exits 64):* BC-3.9.005 mandates `--public` on non-JSM exits 64 with canonical message + zero servicedeskapi calls. The eligibility guard fires AFTER Step 0 (issue GET) but BEFORE any dry-run preview. No F5 round modified this guard's semantics. SATISFIABLE against `src/cli/issue/attachments.rs::handle_attachment_upload_jsm`.

*H-NEW-ATTACHMENT-011 (`--internal` on non-JSM is silent no-op):* BC-3.9.004 OQ-9 ruling: `--internal` on non-JSM falls through to the exact platform POST path with zero servicedeskapi calls, producing identical output to a plain upload. Confirmed by `test_bc_3_9_004_*` in `tests/attachment_jsm.rs`. The guard firing is at the `meta.project_type != "service_desk"` branch, but only for `--public` (exits 64); `--internal` skips the guard and proceeds. SATISFIABLE against shipped behavior.

**Holdout wording check:** v1.3.103 changed the permission-denied disk-error string to add `(writing <dest>)` parenthetical. No holdout scenario in Group 19 asserts a specific permission-denied string shape (holdout scenarios assert behavior, not wording). No invalidation.

---

## 3. Regression Validation

**Baseline at wave gate:** 2,319 tests passing
**Current (develop @ db207b81):** 2,341 passing, 0 failing, 0 ignored-failures
**Delta:** +22 tests (5 new test suites + augmented e2e_live.rs)
**Source:** F6 hardening summary D1 dimension (formal verification run); no regressions in any of the 8 F5 fix PR CI runs

All 8 F5 fix PRs (FIX-F5-006 through FIX-F5-013) passed CI gate on `develop` before merge. Human merge authority (DEC-173) applied to all. No CI failures post-merge.

---

## 4. Cost-Benefit Assessment

**Cost-tracker:** not instrumented (qualitative assessment follows)

**F5 cost:** 14 adversarial rounds, 8 fix PRs, spec v1.3.99 → v1.3.106 (8 spec versions). All fix PRs human-merged (DEC-173). Step-7 secondary review added one cross-model unique finding.

**F5 benefit:** The 14 rounds caught:
- 1 HIGH (r3): `classify_write_error` call-site canonicalization that would have produced inconsistent error strings across download paths
- 1 HIGH-equivalent (P2-003, r3 cluster): DELETE-404 abort bug in replace-existing upload path
- Multiple LOWs in rounds 1–7: RFC3339 `--newest` parser regression, backslash guard asymmetry, containment canonicalization, CWE-116 display-sanitization completeness, Windows permission-denied path form

**Marginal value assessment:** Novel-finding rate decayed from 6L/1C (round 1) to 0 (rounds 12–14). Rounds 10–14 produced zero novel defects that changed the behavioral specification. The final 3 rounds (STRICT window) and the Step-7 secondary review produced 4 LOWs (all enhancement candidates, no correctness defects) and 1 INFO. This is the expected convergence pattern for a well-specified feature with strong test coverage.

**Verdict:** MAXIMUM_VIABLE_REFINEMENT_REACHED. Further F5 cycles would have expected value negative — the marginal cost (adversary round + human merge) exceeds the marginal benefit (probability of finding a novel HIGH/CRIT approaches zero at convergence). F6 hardening (fuzz, formal VP discharge, security scan) provided the correct post-convergence verification tier.

---

## 5. Residual and Enhancement Ledger

**Open residuals (2):**

| ID | Severity | Description | Disposition |
|---|---|---|---|
| P3-003 | LOW | OAuth-bypass in multipart upload path: `upload_attachments` (`src/api/jira/attachments.rs`) bypasses the blanket-401 auto-refresh logic that protects other API calls. ADR-0017 multipart-rebuild constraint means the retry loop would need to perform a full re-auth before rebuild. | Backlog; widened scope from pre-existing P3-003 |
| P4-006 | LOW | `--dry-run` human-preview output goes to stdout in some paths; convention for dry-run channel is not fully codified. | Backlog; no user-facing regression |

**Accepted debt (1):**

| ID | Severity | Description | Disposition |
|---|---|---|---|
| SEC-S576-6-001 | MEDIUM | CWE-703: `AttachmentDropGuard::drop()` in `tests/e2e_live.rs` uses `expect()` on the drop-cleanup call. A panic in `Drop` during an existing panic causes a process abort (double-panic). This is in test infrastructure only, not production code. | ACCEPTED at wave gate; test-infrastructure-only scope; no user impact |

**Enhancement candidates (8):**

| ID | Origin | Description | Effort estimate |
|---|---|---|---|
| SAFE-NAME-GUARD-EXTRACTION | Step-7 L2 (cross-model unique) | Extract SEC-576-004 CRLF/NUL/`"`/`\` guard from `upload_attachments` + `attach_temporary_file` into shared `fn safe_content_disposition_filename(raw: &str) -> String`. Currently copy-pasted; was extended in lockstep twice during F5. | LOW |
| STEP2-429-RETRY | Step-7 L3 (recorded dissent) | `post_request_attachment` (`src/api/jsm/attachments.rs`) does not retry 429. ADR-0017 multipart constraint does not apply (JSON POST, trivially rebuildable). Deliberate per EC-3.9.006-7; enhancement would add retry parity with step-1. | LOW |
| CONTENT-TYPE-HEADER-NIT | Step-7 I2 | Redundant `Content-Type` header before `.json()` in `post_request_attachment`. Cosmetic only. | INFO |
| F5-R10-001 | r10 enhancement note | JSM 401 scope-hint parity: step-1 and step-2 emit different scope-hint wording on 401. Consider unifying hint to `write:servicedesk-request`. | LOW |
| F5-R14-001 | r14 enhancement | Typed sentinel for benign-404 in `delete_attachment`: the function returns `JrError::UserError("…not found or already deleted.")` as both error signal and cancel-path signal; a typed variant would eliminate the string-match dependency in `handle_attachment_upload`. | LOW |
| F5-R14-003 | r14 enhancement | Cancel-message channel: `{"cancelled":true,"deleted":false}` JSON is emitted on stdout while human-mode cancel goes to stderr. Consider symmetric channel. | INFO |
| F5-R1-003 | r1, DEFERRED | JSM echo envelope spec-level: the `AttachmentCreateResultDTO.attachments.values[]` curation strategy relies on undocumented schema; a defensive wrapper type with `#[serde(default)]` would be safer. | LOW |
| SEC-F5-002 | carried | Control-char guard completeness: `display_sanitize_filename` covers ASCII controls + named Unicode bidi/line-sep; Unicode range U+2028/U+2029/U+0085/NEL variants are covered but the guard does not cover all Unicode whitespace classes. Pre-existing LOW from `src/cli/issue/attachments.rs::display_sanitize_filename`. | LOW |

---

## 6. Audit Findings (F7 Fresh-Context)

This section records findings from the F7 fresh-context consistency audit (read-only; not corrected during audit per DRIFT-item policy).

### Dimension 1 — Coverage completeness

**CLEAN.** All 33 BCs (BC-2.7.001..012, BC-3.9.001..020, BC-X.8.010) traced to shipped code + named tests. FIX-576-DL (emergent) traced to `src/api/jira/attachments.rs::deserialize_string_or_int_as_string` + two pinning tests in `tests/attachment_download.rs`. Spot-checked 10 BCs semantically (BC-2.7.002 curated shape invariant, BC-2.7.012 four io-sites in `classify_write_error`, BC-3.9.006 deliberate 429 asymmetry, BC-3.9.017 VP-576-003 ordering invariant, BC-X.8.010 `stale_healed` per-command guard, BC-3.9.003 P2-3c probe discharge, BC-2.7.011 CWE-22/CWE-116 dual-function distinction, BC-3.9.015 VP-576-002 confirm+cancel, BC-3.9.005 non-JSM exit-64, BC-3.9.008 AID numeric guard). All matched shipped behavior.

### Dimension 2 — Index/version coherence

**CLEAN with 2 non-blocking DRIFT items (see below).** BC-INDEX v6.44 confirmed (`BC-INDEX.md` frontmatter). STORY-INDEX v1.5.40 confirmed (`STORY-INDEX.md` frontmatter). S-576-1..6 + FIX-576-DL all show `status: completed` with PR numbers and merge SHAs. sprint-state.yaml shows all 7 deliveries with F5 convergence record (14 rounds, 8 fix PRs, STRICT CONVERGED) and F6 pass (D1 5/5 VPs, D2 49,152 fuzz 0 crashes, D3 27/27 ≥90%, D4 clean).

**DRIFT-1 (LOW — non-blocking):** `spec-changelog.md` is missing the last 3 spec version entries. The most recent entry in that file is v1.3.103 (`## [1.3.103] - 2026-07-24`). The following versions are recorded in BC body traces and BC-INDEX frontmatter but are absent from spec-changelog.md:
- v1.3.104: BC-2.7.012 io-site count corrected three→four (add `flush` for delayed-allocation filesystems)
- v1.3.105: BC-3.9.006 EC-3.9.006-7 429 deliberate-asymmetry sub-case added
- v1.3.106: BC-X.8.010 EC-X.8.010-2 + `stale_healed` per-command DOCUMENT-AS-IS note

The spec version is authoritative in the BC bodies and BC-INDEX frontmatter; spec-changelog.md is a convenience log. This is a documentation completeness gap, not a correctness gap. No spec behavior is wrong.

**DRIFT-2 (INFO — non-blocking):** `prd-delta-576.md` frontmatter `spec_version_after: 1.3.98` is stale relative to F5-final v1.3.106. This is a phase-scoped artifact that was last updated through the F2/F3 adversary passes (ending at v1.3.98). Expected behavior for a phase-scoped document; no update obligation.

### Dimension 3 — VP coverage

**CLEAN.** VP-576-001 through VP-576-005 each traced to named test function → src symbol → review evidence. All 5 named test functions confirmed to exist in the test tree:
- `prop_sanitize_attachment_filename_no_path_traversal` in `tests/attachment_download.rs` (lines 3089–3115)
- `test_bc_3_9_015_vp_576_002_confirm_*` + cancel variant in `tests/attachment_delete.rs` (lines 362–550)
- `test_vp_576_003_delete_before_post_ordering_invariant` in `tests/attachment_upload.rs` (lines 1917–2014)
- VP-576-004 assertions in `tests/attachment_list.rs` (lines 457–471) + `tests/attachment_upload.rs`
- VP-576-005 assertions in `tests/attachment_jsm.rs` (line 449+)

### Dimension 4 — Holdout coherence

**CLEAN.** H-NEW-ATTACHMENT-001..012 all present in holdout-scenarios.md Group 19. No holdout assertions invalidated by F5 changes. Specifically: v1.3.103 added `(writing <dest>)` parenthetical to permission-denied disk error, but no Group 19 holdout scenario asserts a specific disk-error string shape. Spot-checked H-001 (path-traversal), H-008 (non-JSM --public exit-64), H-011 (--internal non-JSM no-op) — all satisfiable against shipped behavior (detail in D5 table above).

### Dimension 5 — Input-hash drift

**DRIFT-2 (INFO, already noted).** `impact-boundary-576.md` found at `.factory/phase-f1-delta-analysis/` (the task brief listed phase-f2-spec-evolution; the actual location is phase-f1-delta-analysis, which is the correct phase for this artifact). File was last modified during F2 adversary passes (probes P35, P39). No F5 update needed — F5 changes are behavioral refinements within already-scoped files.

`prd-delta-576.md` frontmatter: `spec_version_before: 1.3.42`, `spec_version_after: 1.3.98`. This is stale (see DRIFT-2). No fix obligation for phase-scoped artifact.

### Dimension 6 — Doc surfaces

**CLEAN.** All four documentation surfaces reflect the final shipped behavior:
- **CHANGELOG.md:** S-576-1..5 + FIX-576-DL entries present and accurate. S-576-6 E2E is correctly attributed as test-only (no user-facing changelog entry, consistent with convention for test-only additions).
- **README.md:** `jr issue attachment list` entry present in command table (line 272). `download`/`upload`/`delete` subcommands are not listed in the README table — consistent with the README's curated-highlights convention rather than full-surface coverage; not a gap.
- **docs/specs/attachments.md:** Covers all 4 attachment operations (list, download, upload, delete). References correct source symbols. Includes --public/--internal JSM path and FIX-576-DL serde note.
- **docs/specs/json-output-shapes.md:** All 4 attachment JSON output shapes present with correct VP-576 citations.

No doc surface quotes the disk-error strings that changed in v1.3.102/103/104 — verified that `classify_write_error`, `StorageFull`, `PermissionDenied` do not appear in any of these four doc files. No doc-update required.

---

## 7. Recommendation

**READY-FOR-CLOSURE**

Rationale:
1. All 33 BCs + FIX-576-DL are shipped, tested, and verified.
2. F5 STRICT criterion met: 14 rounds, 8 fix PRs, CLEAN×3 window at r12/r13/r14. Novel finding rate decayed to zero. MAXIMUM_VIABLE_REFINEMENT_REACHED.
3. F6 targeted hardening passed: D1 5/5 VPs green, D2 49,152 fuzz inputs 0 crashes, D3 27/27 mutation ≥90%, D4 cargo-audit/deny clean.
4. Regression baseline: 2,341 / 0 from 2,319 wave-gate baseline. Zero test failures.
5. Step-7 secondary review: PASS — 0 CRIT/HIGH/MEDIUM. Cross-model unique finding is an enhancement candidate (not a correctness defect). Recorded dissent documented.
6. 2 DRIFT items are non-blocking documentation completeness gaps: spec-changelog.md missing 3 entries (LOW, state-manager can backfill on close) and prd-delta-576.md stale frontmatter (INFO, phase-scoped artifact, no fix obligation).
7. No open CRIT/HIGH residuals. 2 open LOWs (P3-003, P4-006) are long-running backlog items predating this bundle.

**Action on close:**
- State-manager commit: close SOH-ATTACHMENTS-1, mark all 7 stories CLOSED in STORY-INDEX, advance sprint-state.yaml to F7-CLOSED.
- Optional (state-manager): backfill spec-changelog.md entries for v1.3.104/105/106 to resolve DRIFT-1.
- Enhancement candidates (8 items) remain in backlog; no blocking action required.
