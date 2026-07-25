# F5 Scoped Adversarial Refinement — SOH-ATTACHMENTS-1
## Convergence Summary

**Bundle:** SOH-ATTACHMENTS-1 (issues #576 + #585)
**Criterion:** STRICT (human ruling 2026-07-23: F5 runs as its own phase; Gate-3 wave review did not discharge it)
**Status:** CONVERGED 2026-07-24
**Window:** rounds 12/13/14 CLEAN×3

---

## Run Statistics

| Field | Value |
|-------|-------|
| Total rounds | 14 |
| Fix PRs | 8 (#644, #645, #646, #647, #648, #649, #650, #651, #652) |
| Fix PRs merged by | Human (DEC-173) |
| Convergence window | r12 CLEAN (1/3) → r13 CLEAN (2/3) → r14 CLEAN (3/3) |
| Spec version range | v1.3.99 (pre-F5) → v1.3.106 (F5 final) |
| BC-INDEX version | v6.38 → v6.44 |
| BC count | 657 (unchanged throughout F5) |
| develop at convergence | db207b81 |

---

## Novelty Trajectory

| Round | Verdict | Novel Findings | Notes |
|-------|---------|---------------|-------|
| r1 | GAPS | 6L/1C | Containment repair, RFC3339 --newest parser, 404 parity, quote guard, NetworkError taxonomy |
| r2 | GAPS | 2L/1C | Backslash guard asymmetry, rustdoc sync |
| r3 | GAPS | 1H/2L | r3 HIGH: BC-2.7.012 download-404 canonical-only restoration + containment canonicalization |
| r4 | GAPS | 1L | Docstring accuracy |
| r5 | GAPS | 1L/1I | Research-backed disk-error taxonomy, classify_write_error, Windows P9-001 |
| r6 | GAPS | 1L/1I | Doc-fallout sync |
| r7 | GAPS | 2L/1I | EC-3.9.006-7 429 trip-wire pin |
| r8 | CLEAN* | 1L | Dup of ledgered P8-001 → ruled clean per F5-R8-001 |
| r9 | GAPS | 1L novel + 1I | 1L novel + 1I dup of P4-006 per F5-R9-002 |
| r10 | CLEAN | 0 | 1I enhancement note (F5-R10-001 enhancement, not defect) |
| r11 | GAPS | 1L novel | Dead single-mode branch removal + SEC-576-001 consolidation guard |
| r12 | CLEAN (1/3) | 0 | 1L dup of WAVE-576-05 → ruled clean per F5-R12-001; STRICT window starts |
| r13 | CLEAN (2/3) | 0 | 1I by-design (documented EC) |
| r14 | CLEAN (3/3) | 0 | 3I documented; WINDOW COMPLETE → CONVERGED |

*r8 ruling: duplicate-of-ledgered findings do not reset the STRICT window (F5-R8-001).

---

## Fix PR Inventory

| PR | ID | Round | Summary | Merged SHA |
|----|-----|-------|---------|------------|
| #644 | FIX-F5-006 | r1 cluster | Containment repair, RFC3339 --newest parser, 404 parity, quote guard, NetworkError taxonomy | c33ae7c3 |
| #646 | FIX-F5-007 | r2 | Backslash guard symmetry + rustdoc sync | 31a3dfdb |
| #647 | FIX-F5-008 | r3 HIGH | BC-2.7.012 download-404 canonical-only restoration + containment canonicalization | d28a19c5 |
| #648 | FIX-F5-009 | r4 | Docstring accuracy | e0f44b98 |
| #649 | FIX-F5-010 | r5 | Research-backed disk-error taxonomy, classify_write_error 4 io sites + tmp-path leak fix + Windows P9-001 reconciliation + mutation hardening | 81c637b9 |
| #650 | FIX-F5-011 | r6 | Doc-fallout sync | 58ef7104 |
| #651 | FIX-F5-012 | r7 | EC-3.9.006-7 429 trip-wire pin | 58d3d079 |
| #652 | FIX-F5-013 | r11 | Dead single-mode branch removal + SEC-576-001 consolidation guard | db207b81 |

Note: PR #645 is not listed above (numbering gap; not a SOH-ATTACHMENTS-1 F5 fix PR).

---

## Spec Co-Evolution

| Version | Change |
|---------|--------|
| v1.3.99 | Pre-F5 baseline (wave gate); BC count 657 |
| v1.3.100 | BC-3.9.006 network split (FIX-F5-006 r1 cluster) |
| v1.3.101 | Trace refresh |
| v1.3.102 | BC-2.7.012 hybrid disk-error strings; research-backed (research/f5-r5-001-disk-error-taxonomy-2026-07-24.md) |
| v1.3.103 | Permission-row dest parenthetical; P9-001 reconciliation |
| v1.3.104 | Four io sites |
| v1.3.105 | EC-3.9.006-7 deliberate 429 asymmetry; discharges P8-001 |
| v1.3.106 | EC-X.8.010-2 per-command heal scope; discharges WAVE-576-05 DOCUMENT-AS-IS |

BC-INDEX: v6.38 → v6.44. BC count 657 UNCHANGED throughout F5.

---

## Rulings Applied

| ID | Round | Ruling |
|----|-------|--------|
| F5-R5-002 | r5 | Duplicate-of-ledgered findings do not reset the STRICT window |
| F5-R8-001 | r8 | r8 1L finding = dup of ledgered P8-001; ruled clean; STRICT window not reset |
| F5-R9-002 | r9 | r9 1I finding = dup of P4-006; excluded from novelty count |
| F5-R12-001 | r12 | r12 1L finding = dup of WAVE-576-05; ruled clean 1/3; STRICT window starts |

Discharge pattern: codify accepted edges into spec ECs so fresh adversaries read them as intended behavior, not defects.

---

## Residual Ledger — Final State

| Item | Status | Notes |
|------|--------|-------|
| P3-003 | OPEN | OAuth-bypass (widened, phase-5/backlog); multipart path bypasses blanket-401 auto-refresh |
| P4-006 | OPEN | Dry-run channel divergence (stdout vs stderr human-preview); backlog |
| P8-001 | CLOSED | Discharged by EC-3.9.006-7 (spec v1.3.105); deliberate 429 asymmetry codified |
| WAVE-576-05 | CLOSED | Discharged by EC-X.8.010-2 DOCUMENT-AS-IS (spec v1.3.106); per-command heal scope codified |
| SEC-S576-6-001 | ACCEPTED DEBT | CWE-703 Drop expect MEDIUM; accepted at wave gate; unchanged |
| F5-R1-003 | DEFERRED | JSM echo envelope spec-level; deferred to backlog |

**Enhancement candidates (not defects):**

| ID | Round | Description |
|----|-------|-------------|
| F5-R10-001 | r10 | JSM 401 scope-hint parity |
| F5-R14-001 | r14 | Typed sentinel for benign-404 |
| F5-R14-003 | r14 | Cancel-message channel symmetry |
| SEC-F5-002 | carried | Control-char guard completeness; pre-existing LOW |

---

## Process Observations

**(a) Orchestrator fix-routing over-reach:** F5-R1-004 fix direction targeted shared `get_attachment_metadata` without checking BC-2.7.012, causing r3 HIGH F5-R3-001. Pattern: fix sub-agent must cross-check all BC anchors before targeting shared functions.

**(b) validate-pr-review-posted hook conflicts with DEC-173:** 2 data points (PR #648, #651) where self-authored-PR reality collided with hook expectations. Backlog item: PR-MANAGER-HOOK-VS-DEC-128-CONFLICT.

**(c) Loop-exhaust pattern:** Rounds 4-9 findings were predominantly doc-fallout of the loop's own fix commits. Spec-codification of accepted edges (v1.3.105/106) is what broke the rediscovery cycle. Lesson: codify accepted behaviors into EC/spec EARLY to collapse the adversary's finding space.

**(d) Windows CI runner surfaced real cross-platform contract collision:** P9-001 × BC-2.7.012 interaction that no macOS-local gate caught. Windows CI runners provide genuine incremental value for platform-sensitive contracts.

---

## Secondary Review-Tier Pass (Step 7)

**Date:** 2026-07-24
**Reviewer:** Secondary adversary (fresh context; no prior round artifacts read)
**Scope:** `src/cli/issue/attachments.rs`, `src/api/jira/attachments.rs`, `src/api/jsm/attachments.rs`, `src/cli/mod.rs` (clap definitions), `tests/attachment_{list,download,upload,delete,jsm}.rs`
**Delta:** `e33624c1~1..db207b81`
**Report:** `phase-f5-adversarial/SOH-ATTACHMENTS-1/secondary-review.md`

### Verdict: PASS

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 4 |
| INFO | 3 |
| **Total** | **7** |

### Cross-Model Unique Finding

**L2 — safe_name guard duplication** (`src/api/jira/attachments.rs::upload_attachments` + `src/api/jsm/attachments.rs::attach_temporary_file`): The SEC-576-004 CRLF/NUL/double-quote/backslash `Content-Disposition` guard is copy-pasted identically in both upload functions. This guard was extended twice during F5 (r1: added `"`, r2: added `\`), demonstrating the lockstep-update risk. The secondary reviewer independently identified this as the highest-value refactor candidate. **This finding was never raised in 14 primary F5 rounds** — cross-model blind spot confirmed. Refactor candidate: extract to `fn safe_content_disposition_filename(raw: &str) -> String` shared by both call sites.

### Recorded Dissent

**L3 — EC-3.9.006-7 ruling (deliberate 429 no-retry on step-2):** The secondary reviewer disputes the ruling that `post_request_attachment` should not retry on 429. The ADR-0017 multipart-body-not-clonable constraint does not apply to step-2 (it is a simple JSON POST with a trivially-rebuildable `serde_json::json!` body). Under rate limiting, step-1 retries but step-2 fails immediately, leaving dangling temporary attachment IDs that expire on Atlassian's side. The reviewer argues this strengthens the future-enhancement candidacy for STEP2-429-RETRY. Dissent **recorded** but ruling stands (deliberate asymmetry codified in spec v1.3.105 EC-3.9.006-7; no change to primary verdict). This aligns with F5-R9/R8 history where the same asymmetry was observed; the STEP2-429-RETRY enhancement candidate is now ledgered.

### Finding Disposition

| ID | Severity | Disposition |
|----|----------|-------------|
| L1 | LOW | New — temp file leaked on Ctrl+C during streaming download. Enhancement candidate. |
| L2 | LOW | **Cross-model unique** — safe_name guard duplication; refactor candidate SAFE-NAME-GUARD-EXTRACTION. |
| L3 | LOW | Duplicate of P8-001 (EC-3.9.006-7 deliberate 429 asymmetry) + recorded dissent. Ruling STANDS. Enhancement candidate STEP2-429-RETRY ledgered. |
| L4 | LOW | Duplicate of SEC-F5-001 (batch_path_is_within_dir fail-open; defense-in-depth; acknowledged). |
| I1 | INFO | By-design: std::process::exit(1) pattern. No action. |
| I2 | INFO | Redundant Content-Type header nit. Cosmetic. Enhancement candidate CONTENT-TYPE-HEADER-NIT ledgered. |
| I3 | INFO | glob_inner recursion note. No action (MIME types are short in practice). |

### Duplicates

- **L4 = SEC-F5-001** (fail-open containment check; acknowledged defense-in-depth residual from F5-R3-002)
- **L1 = P8-002** (temp file leak on Ctrl+C; carried in enhancement backlog per F5-R14-001 signal)

### Final F5 Verdict

**CONVERGED (primary STRICT ×3 CLEAN + Step-7 secondary review-tier PASS).**

Primary: 14 rounds / 8 fix PRs / window pass-12/pass-13/pass-14 CLEAN×3.
Secondary (Step 7): PASS — 0 CRITICAL / 0 HIGH / 0 MEDIUM / 4 LOW / 3 INFO; 1 cross-model unique finding (L2, highest refactor value); 1 recorded dissent (L3 EC-3.9.006-7). Both enhancement candidates ledgered as Drift Items.

SOH-ATTACHMENTS-1 F5 is FULLY CLOSED. NEXT: F6 targeted hardening.
