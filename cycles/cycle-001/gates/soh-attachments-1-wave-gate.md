# SOH-ATTACHMENTS-1 Wave Gate Report

**Bundle:** SOH-ATTACHMENTS-1 (issues #576 + #585)
**Gate Date:** 2026-07-23
**Verdict:** PASSED — all 6 gates satisfied

## Telemetry Block (required by validate-wave-gate-completeness hook)

```
GATE_CHECK: gate=1 name=test-suite status=pass note=2319 passed / 0 failed / 100 gated-ignored; clippy -D warnings clean; fmt clean; debug profile (release forbidden by base_url_release_gate const guard #335/SD-002)
GATE_CHECK: gate=2 name=dtu-validation status=skip note=dtu_required false; no dtu-clones; no module-criticality.md — no DTU-covered modules in wave
GATE_CHECK: gate=3 name=adversarial-review status=pass note=novelty LOW-MEDIUM, 0 critical, 0 undispositioned high; 2 new wave-scope originations WAVE-576-02 (LOW/MEDIUM) + WAVE-576-05 (LOW)
GATE_CHECK: gate=4 name=demo-evidence status=pass note=7 deliverables; S-576-1..4 docs/demo-evidence evidence-reports (11+19+18+16 ACs), S-576-5 .factory/demos INDEX 16/16 ACs, S-576-6 facade N/A live-run evidence, FIX-576-DL fix-PR flow
GATE_CHECK: gate=5 name=holdout-eval status=pass note=mean 1.00, min critical 1.00; 12/12 MUST-PASS H-NEW-ATTACHMENT-001..012 executed offline vs mock; 0 below 0.60
GATE_CHECK: gate=6 name=state-update status=pass note=sprint-state + STATE.md updated, factory-artifacts committed
```

---

## Gate 1 — Test Suite

**Status:** PASS

- Suite: `cargo test` (debug profile) — 2319 passed / 0 failed / 100 gated-ignored
- Clippy: `cargo clippy --all-targets -- -D warnings` — clean
- Format: `cargo fmt --all -- --check` — clean
- Cargo deny: clean

**Deviation note (process-gap candidate):** The wave-gate skill template prescribes `cargo test --release`. This repo intentionally forbids release-profile test builds via `const { assert!(cfg!(debug_assertions)) }` in `tests/base_url_release_gate.rs` (security guard #335/SD-002). Canonical debug-profile suite run instead. This is a `[process-gap]` candidate for the engine: wave-gate skill should honor repo-canonical test commands rather than assuming `--release` is safe.

---

## Gate 2 — DTU Validation

**Status:** SKIP

`dtu_required: false` in STATE.md frontmatter. No DTU clones built. No `module-criticality.md` exists in this project. No DTU-covered modules in the SOH-ATTACHMENTS-1 wave scope.

---

## Gate 3 — Adversarial Review

**Status:** PASS

Fresh-context adversary reviewed the full wave diff (S-576-1 through S-576-6 + FIX-576-DL; 7 deliverables; develop base `e33624c1`→`9da03d5b`). Novelty: LOW-MEDIUM. Zero critical findings. Zero undispositioned HIGH findings.

### Findings

**WAVE-576-01** — LOW (new wave-scope origination)
Upload dry-run preview emits to **stdout** (via `print_output`), while delete dry-run preview emits to **stderr** (direct `eprintln!`). Concrete confirmation of P4-006 dry-run channel divergence. Channel inconsistency is real but cosmetic (scripts reading stdout for non-dry-run JSON are unaffected; dry-run preview is human-facing text). **Disposition:** fold into P4-006; target: unify dry-run preview channel in a dedicated story.

**WAVE-576-02** — LOW/MEDIUM (new wave-scope origination)
`src/api/jsm/attachments.rs::post_request_attachment` executes a plain `reqwest::Client::post().json().send()` call bypassing `JiraClient::send()`. This means the blanket-401 auto-refresh loop (S-3.03, BC-1.1.002) does NOT apply to the JSM two-step POST. The multipart/upload justification (`Request::try_clone() → None` per ADR-0017) does not apply here — step-2 is a plain JSON POST, fully clonable. UX-only degradation (user gets 401 → exit 2 + re-auth hint instead of silent refresh). **Disposition:** fold into P3-003 and widen its ledger entry to cover both upload multipart path (original) and post_request_attachment JSON POST path (new); implementation remains deferred.

**WAVE-576-03** — INFO (verified non-defect)
`chrono %z` correctly parses Jira's `+0000` timezone offset in both `--newest` and `--older-than` date-comparison paths. Empirically verified. Not a defect.

**WAVE-576-04** — INFO
EC-3.9.020-7 `--dry-run` annotation is only reachable when `--dry-run` AND `--replace-existing` are both present. This is likely by-design (dry-run without --replace-existing has no deletion preview to show). No action.

**WAVE-576-05** — LOW (new wave-scope origination; new tech-debt entry)
`handle_attachment_upload_jsm` uses a `stale_healed: bool` guard that is command-global (fires at most once per command invocation), but the step-1 upload loop is per-file. If the first file triggers a stale-heal (404/403 → cache invalidate → retry → success) and a subsequent file then hits a second 404, that second 404 propagates as `JrError::ApiError` exit 1 instead of the user-friendly `JrError::UserError` exit 64 path. The second failure is rare in practice (requires two different stale-IDs in one batch), but the exit-code taxonomy diverges from the spec. **Disposition:** new tech-debt entry WAVE-576-05; LOW; implementation deferred.

**WAVE-576-06** — INFO
`--internal` on a non-JSM project costs 2 extra GET requests (P1-004 issue GET + project meta GET) before the silent no-op. This is spec-sanctioned behavior per OQ-9 and EC-3.9.003-7. No action.

### Positive Integration Confirmations

- Three sanitization layers (CWE-116 `display_sanitize_filename`, CWE-22 `sanitize_attachment_filename`, CWE-93 CRLF filename guard) are correctly placed at their respective call sites. Zero cross-story confusion between the three.
- DEC-168 delete-variant call-site audit confirmed correct: `delete_attachment_targeted` is invoked only on single-AID paths; `delete_attachment` (benign-skip semantics) is invoked at bulk/older-than/replace-existing loops. The `msg.contains("not found or already deleted")` check in the replace loop remains intact.
- FIX-576-DL `deserialize_string_or_int_as_string` visitor is correctly scoped to `AttachmentMetadata.id` only; `AttachmentObject.id` (list path, string-only) is unchanged.
- Multi-profile cache boundary preserved: `invalidate_project_meta_cache` in the stale-heal path correctly takes `profile: &str` as its first argument.
- JSON render invariant #526 holds across all new files: all `--output json` paths in `src/cli/issue/attachments.rs` route through `output::render_json` or `output::print_output`.

---

## Gate 3 — Deferred-Findings Disposition Table

| Finding | Disposition | Notes |
|---------|-------------|-------|
| AUDIT-576-003 | RESOLVED-BY-WAVE | Doc-only count-drift between story v1.45 prose "26 tests" and shipped test count 29 (+3 CI kill tests landed after story freeze). Process-gap class PG-576-1. |
| AUDIT-576-004 | RESOLVED-BY-WAVE | deny.toml:282 `cpufeatures` skip — DEC-185 exception; rationale verified at gate. |
| P3-003 | STILL-OPEN-defer | Upload multipart path bypasses blanket-401 auto-refresh. Widened by WAVE-576-02 to also cover `post_request_attachment` JSON POST path. Target: dedicated story. |
| P4-006 | STILL-OPEN-defer | Dry-run preview channel divergence confirmed by WAVE-576-01. Target: unify dry-run channel (upload stdout vs delete stderr). |
| P8-001 | STILL-OPEN-defer | Step-2 429 no-carve-out (BC-3.9.006 spec-level note accepted). Low blast radius. |
| SEC-S576-6-001 | STILL-OPEN-defer | CWE-703 `Drop` `expect` in `AttachmentDropGuard`, MEDIUM. Accepted as tech debt; documented. |
| S-576-1 P1-004 | STILL-OPEN-defer | Phase-5 system-wide observation (not worsened). |
| S-576-1 P4-001 | RESOLVED-BY-WAVE | `#[serde(default)]` present at `src/api/jira/attachments.rs`:92,109 (both `AttachmentObject` and `AttachmentMetadata` fields). Verified by grep. |
| S-576-2 P8-002 | STILL-OPEN-defer | Orphan temp files on SIGINT between step-1 and step-2. Defense-in-depth only; not exploitable. |
| S-576-2 P12 | STILL-OPEN-defer | Defense-in-depth only; not exploitable. |

---

## Gate 4 — Demo Evidence

**Status:** PASS — 7 deliverables

| Deliverable | Evidence Location | ACs |
|-------------|-------------------|-----|
| S-576-1 attachment list | `docs/demo-evidence/S-576-1/evidence-report.md` | 11 |
| S-576-2 attachment download | `docs/demo-evidence/S-576-2/evidence-report.md` | 19 |
| S-576-3 attachment upload (platform) | `docs/demo-evidence/S-576-3/evidence-report.md` | 18 |
| S-576-4 attachment delete | `docs/demo-evidence/S-576-4/evidence-report.md` | 16 |
| S-576-5 JSM visibility | `.factory/demos/S-576-5/` (INDEX 16/16 ACs) | 16 |
| S-576-6 E2E facade | Live-run evidence (run 30041659024 97/97 GREEN post-FIX-576-DL) | N/A |
| FIX-576-DL integer-id fix | Fix-PR flow: PR #642 CI green; e2e run 30040606453 | N/A |

---

## Gate 5 — Holdout Evaluation

**Status:** PASS — mean 1.00, min critical 1.00

All 12 MUST-PASS H-NEW-ATTACHMENT scenarios (H-NEW-ATTACHMENT-001 through H-NEW-ATTACHMENT-012) executed offline against mock wire fixtures. Zero scenarios below the 0.60 floor.

### Per-Scenario Scores

| Scenario | Score | Notes |
|----------|-------|-------|
| H-NEW-ATTACHMENT-001 | 1.00 | |
| H-NEW-ATTACHMENT-001-B | 1.00 | Evaluator completed `self`/`content` fields from realistic Jira shape (evaluator completion, not defect compensation — see INFO note below) |
| H-NEW-ATTACHMENT-002 | 1.00 | |
| H-NEW-ATTACHMENT-003 | 1.00 | |
| H-NEW-ATTACHMENT-004 | 1.00 | Evaluator completed `self`/`content` fields |
| H-NEW-ATTACHMENT-005 | 1.00 | |
| H-NEW-ATTACHMENT-006 | 1.00 | |
| H-NEW-ATTACHMENT-007 | 1.00 | |
| H-NEW-ATTACHMENT-008 | 1.00 | |
| H-NEW-ATTACHMENT-009 | 1.00 | |
| H-NEW-ATTACHMENT-010 | 1.00 | |
| H-NEW-ATTACHMENT-011 | 1.00 | Evaluator completed `self`/`content` fields |
| H-NEW-ATTACHMENT-012 | 1.00 | |

**INFO process note — holdout fixture underspecification class:** Scenarios 001-B, 004, and 011 contain wire fixtures that underspecify `self` and `content` URL fields that real Jira always returns in attachment metadata responses. The holdout evaluator completed these fields from the realistic Jira response shape rather than treating the absence as a defect. This is evaluator completion (resolving fixture ambiguity toward the plausible wire contract), not defect compensation. Recorded as a process-gap candidate: holdout fixture authors should include all required URL fields from the Jira Cloud wire schema. Analogous to the TWIN-ARTIFACT-SWEEP class — fixture completeness is a correctness obligation.

---

## Gate 6 — State Update

**Status:** PASS

- `sprint-state.yaml`: all S-576-* stories status `completed`; SOH-ATTACHMENTS-1 wave-gate entry recorded PASSED 2026-07-23.
- `STATE.md`: frontmatter updated (pipeline ACTIVE, current_step wave-gate-passed, phase_3_status appended WAVE GATE PASSED 2026-07-23); Phase Progress + Current Phase Steps SOH-ATTACHMENTS-1 WAVE GATE PASSED rows added; residual ledger updated (AUDIT-576-003/004 CLOSED, P3-003/P4-006/P8-001 widened/confirmed, WAVE-576-05 new tech-debt, PG-576-3 candidate added); Session Resume Checkpoint replaced.
- `factory-artifacts` branch: single atomic burst commit per TD-VSDD-053 Single-Commit Burst Protocol.

---

## Summary

SOH-ATTACHMENTS-1 wave gate PASSED 2026-07-23. All 6 gates satisfied. Bundle formally closed. Residuals carried forward: P3-003 (widened), P4-006 (confirmed), P8-001, SEC-S576-6-001, WAVE-576-05 (new). New process-gap candidates: PG-576-3 (wave-gate skill prescribes `--release`), holdout fixture underspecification class. Next step: human decision on F5 scoped adversarial refinement dispatch (or ruling that Gate-3 review discharges F5).
