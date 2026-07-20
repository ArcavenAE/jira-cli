# S-576-2 Step 4.5 Adversarial Convergence — 12 Passes

**Story:** S-576-2 (`jr issue attachment download`)
**Bundle:** SOH-ATTACHMENTS-1
**Criterion:** STRICT
**Date converged:** 2026-07-20
**Window:** p10 CLEAN / p11 CLEAN / p12 NITPICK_ONLY
**Passes:** 12 / Fix rounds: 9 / Human overrides: 0

---

## Trajectory

`p1 FINDINGS(1H/6M/3L/[pg]) → p2 FINDINGS(1M/O-1/O-2/O-3) → p3 FINDINGS(1M/2L) → p4 NITPICK_ONLY(1/3) → p5 FINDINGS(2M) → p6 FINDINGS(1M) → p7 all-LOW(2L) → p8 FINDINGS(1M/spec-truth-up) → p9 FINDINGS(1M) → p10 CLEAN(1/3) → p11 CLEAN(2/3) → p12 NITPICK_ONLY(3/3 CONVERGED)`

---

## Pass-by-Pass Narrative

### Pass 1 — FINDINGS (1H / 6M / 3L / [process-gap])

**P1-001 (HIGH):** Lexicographic-sort BC violation. `jr issue attachment download --all` emitted files in API-returned order, not the BTreeMap-alphabetical (filename) order required by BC-2.7.008. Jira's ordering is nondeterministic across requests — this was a correctness defect, not cosmetic.

**P1-002 (MEDIUM) + P1-003..P1-007 (MEDIUM/LOW):** Canonical error string mismatches, --force help-text imprecision, serde residual from S-576-1 P4-001 deferred obligation, story count nits.

**[process-gap]:** Test assertion weakening — an assertion had been downgraded to a form that would pass even when the behavioral invariant was violated. Flagged for wave-gate codification (story-writer BC-letter pinning convention).

**Fix round 1:** BTreeMap insertion in download handler; canonical string hardened; test assertion restored to strict form; serde `#[serde(default)]` added (P4-001 residual); count sync. Story v1.33.

---

### Pass 2 — FINDINGS (1M / O-1 / O-2 / O-3)

**P2-001 (MEDIUM):** Canonical string mismatch — error message wording diverged from the BC-2.7.012 error-table row; test pinned the wrong string and would have passed a non-conformant implementation.

**O-1 (process-gap):** `process::exit(1)` direct-call in an error path instead of routing through `JrError` — bypasses structured exit-code system. Accepted as engine follow-up suggestion (JrError::SilentExit); not story-blocking.

**O-2/O-3:** Count nits in story frontmatter.

**Fix round 2:** Canonical string aligned to BC table row; count sync. Story v1.34.

---

### Pass 3 — FINDINGS (1M / 2L)

**P3-001 (MEDIUM):** --force help text remained imprecise. The wording implied `--force` was a general overwrite flag; BC-2.7.007 specifies it bypasses the overwrite-refuse pre-flight check specifically. Semantics matter for user mental model and are load-bearing contract text.

**P3-002/P3-003 (LOW):** Missing coverage annotation, minor story count drift.

**Fix round 3:** `--force` help text rewritten to BC-2.7.007-precise wording; coverage annotation added; count sync. Story v1.35.

---

### Pass 4 — NITPICK_ONLY (window 1/3)

**F-P4-001 (LOW):** Serde field annotation residue — one `AttachmentObject` field still lacked `#[serde(default)]`; the annotation pattern from fix-round-1 was incomplete.

**F-P4-002 (LOW):** Story count for adversarial regression pins understated by 1.

No MEDIUM or above. Fix round 4: serde annotation completed; count sync. Window streak 1/3.

---

### Pass 5 — FINDINGS (2M) — window resets

**P5-001 (MEDIUM):** Vacuous cleanup test — the `--newest` path test returned early without asserting the key behavioral invariant (newest-only selection from among multiple attachments). The test existed and passed but proved nothing about the code's correctness.

**P5-002 (MEDIUM):** None-branch coverage gap — the error handling for a `None` return from the attachment iterator was present in code but no test exercised it. Adversary identified the untested branch via code inspection.

**Fix round 5:** Vacuous test replaced with an assertion-bearing test (P5-001); None-branch test added (P5-002). Story v1.36 (count +2 integration tests). Window resets.

---

### Pass 6 — FINDINGS (1M) — window resets

**P6-001 (MEDIUM):** `#[allow]` suppression violation. A `clippy::too_many_arguments` warning had been suppressed on a handler function without refactoring. CLAUDE.md policy prohibits suppression without refactoring or an explicit justified comment.

**Fix round 6:** Handler refactored to accept a struct parameter, eliminating the `too_many_arguments` violation and removing the `#[allow]`. Clippy clean. Window resets.

---

### Pass 7 — all-LOW (2L)

**P7-001 (LOW):** Stale label — `DownloadArgs` struct had been renamed during the pass-6 refactor but one in-code comment and a test snapshot still referenced the old name `AttachmentDownloadArgs`.

**P7-002 (LOW):** Visibility modifier on a helper function was `pub(crate)` where `pub(super)` was the narrower correct scope per module design.

**Fix round 7:** Struct-name label corrected in comment and snapshot; visibility corrected to `pub(super)`. Story v1.37 (P7-001 struct-name label noted in changelog).

---

### Pass 8 — FINDINGS (1M / spec-truth-up) — window resets

**P8-001 (MEDIUM / CWE-116):** Success path hint echoed a server-supplied filename without routing through `display_sanitize_filename`. Violation of BC-2.7.011 every-call-site obligation and CWE-116 (improper output neutralization for logs). SEC-576-011.

**P8-002 (spec-truth-up):** EC-2.7.007-5 SIGINT temp-file cleanup note in spec claimed a cleanup mechanism existed. Adversary found no registry, no `Drop` invocation, and no tokio `ctrl_c` handler in `main.rs` — the note described aspirational prose, not implemented reality. Spec change required to correct the record.

**Fix round 8:** Success hint sanitized (P8-001, SEC-576-011, CWE-116); spec v1.3.97 authored (EC-2.7.007-5 corrected — SIGINT cleanup NOT implemented; orphaned `tmp_<random-hex>` files accepted as best-effort residual, deferred to S-576 bundle tracked debt); story AC-018 extended with DISPLAY-SANITIZATION bullet; Architecture Compliance Rules table extended with future-proofing row. Story v1.36 → v1.38 (AC-018 + count 27→28 sub-round 1.37). Window resets.

---

### Pass 9 — FINDINGS (1M) — window resets

**P9-001 (MEDIUM / CWE-116):** Rename-error path also echoed a sanitized filename in an error message but lacked the `display_sanitize_filename` call. Same CWE-116 class as P8-001; adjacent sibling path missed during fix-round-8 sweep. Adversary independently identified the adjacent path rather than relying solely on pass-8 fix documentation.

**Fix round 9:** Rename-error message path sanitized (P9-001, CWE-116); regression pin test added as 29th integration test (7th adversarial pin). Story v1.38 count update (28→29). Window resets.

---

### Pass 10 — CLEAN (window 1/3)

No findings of any severity. Adversary independently verified: all 29 integration tests, clippy clean, fmt clean, BTreeMap-alphabetical sort, serde hardening, canonical error strings, `display_sanitize_filename` call sites, `#[allow]` absence, BC-2.7.011 every-call-site compliance, spec v1.3.97 reality alignment. Window starts (1/3).

---

### Pass 11 — CLEAN (window 2/3)

No findings of any severity. Adversary verified: CWE-116 sanitization complete at all output sites, no residual `#[allow]` suppressions, no stale struct-name references, spec-reality alignment confirmed (EC-2.7.007-5 orphaned-tmp residual documented as tracked debt). Window continues (2/3).

---

### Pass 12 — NITPICK_ONLY (window 3/3 — STRICT CONVERGED)

Single LOW observation: single-path containment parity — defense-in-depth symmetry between the single-id and batch paths could optionally be made more uniform. Adversary noted this path is provably unreachable given the existing guard; the parity is optional defense-in-depth symmetry, not a correctness gap.

No fix round. Observation deferred as optional parity at S-576-3/4. Window 3/3 — **STRICT CONVERGED**.

---

## Accepted Residuals

| ID | Severity | Description | Disposition |
|----|----------|-------------|-------------|
| O-1 | process-gap | `process::exit(1)` direct-call bypasses JrError routing | Engine follow-up: JrError::SilentExit. Wave-gate codification list. |
| pass-1-process-gap | process-gap | Test-weakening via assertion downgrade — story-writer BC-letter pinning convention not codified | Wave-gate codification. Story-writer convention: BC-letter assertions must never be weakened. |
| P8-002-orphan-temp | LOW | Orphaned `tmp_<random-hex>` on SIGINT — no registry/Drop, `std::process::exit(130)` called directly | Spec-recorded v1.3.97. Tracked as S-576 bundle debt. |
| P12-containment-parity | LOW | Single-path containment parity provably unreachable; defense-in-depth symmetry optional | Optional parity at S-576-3/4. |

---

## Watch Item

`factory-dispatcher` PostToolUse hook timed out twice (fail-closed) on `spec-changelog.md` edits — RECURRENCE 2. Flagged for session-review.
