---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: 2026-07-29T00:00:00Z
phase: F2
inputs:
  - .factory/specs/prd/bc-3-issue-write.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/spec-changelog.md
  - .factory/phase-f1-delta/SOH-DX-1/delta-analysis.md
  - .factory/stories/S-383-platform-inverse-warnings.md
  - .factory/cycles/cycle-001/session-checkpoints.md
  - .factory/cycles/cycle-001/convergence-trajectory.md
  - .factory/STATE.md
  - src/cli/issue/create.rs
  - src/cli/issue/jsm_create.rs
  - tests/issue_create_jsm.rs
  - tests/issue_create_json.rs
  - tests/json_error_shape.rs
  - tests/common/mod.rs
  - tests/common/fixtures.rs
  - src/adf.rs
  - Cargo.toml
  - Cargo.lock
  - rust-toolchain.toml
  - .github/workflows/ci.yml
  - .github/workflows/sign-and-publish.yml
  - .github/workflows/backfill-release.yml
  - docs/adr/0014-jsm-request-type-dispatch.md
input-hash: "0f920f9"
traces_to: .factory/specs/prd/bc-3-issue-write.md
pass: 76
bundle: SOH-DX-1
aperture: reality-check
spec_version: v1.3.163
previous_review: null
basis: DEC-190 substitute (consistency-validator, not adversary agent)
---

# Adversarial Review: SOH-DX-1 F2 (Pass 76)

## Finding ID Convention

Finding IDs use the format: `ADV-<CYCLE>-P<PASS>-<SEV>-<SEQ>`

- `ADV`: Fixed prefix identifying adversarial findings
- `<CYCLE>`: Cycle prefix from `.factory/current-cycle` — no current-cycle file exists; cycle segment omitted (fallback form: `ADV-P<PASS>-<SEV>-<SEQ>`)
- `<PASS>`: Two-digit pass number (`P76`)
- `<SEV>`: Severity abbreviation (`CRIT`, `HIGH`, `MED`, `LOW`)
- `<SEQ>`: Three-digit sequence within the pass

## Aperture

Reality-check only. This pass verifies the spec's **factual assertions about the world** — crate APIs, crate versions, existing source-code behavior, test symbol existence, CI/workflow claims, SHA pin claims, and Atlassian/Jira API claims. Internal consistency has been exhausted across 74+ prior passes; internal coherence is explicitly NOT this pass's remit.

## Perimeter (files actually read)

- `.factory/specs/prd/bc-3-issue-write.md` (PRIMARY — BC-3.8.012/013 bodies, delivery obligations block, ACs 1-21, ECs 1-10)
- `.factory/specs/prd/BC-INDEX.md` (section 3.8, index_version field)
- `.factory/spec-changelog.md` (entries 1.3.161, 1.3.162, 1.3.163; and 1.3.107-1.3.163 trail for SOH-DX-1)
- `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` (full; §5e SHA verification section)
- `.factory/stories/S-383-platform-inverse-warnings.md`
- `.factory/cycles/cycle-001/session-checkpoints.md` (checkpoint containing P71-001 SHA verification)
- `.factory/cycles/cycle-001/convergence-trajectory.md` (SHA confirmation entry)
- `.factory/STATE.md` (SHA blocking AC entry, F3 obligations)
- `src/cli/issue/create.rs` (lines 17-110)
- `src/cli/issue/jsm_create.rs` (grep — markdown guard location)
- `tests/issue_create_jsm.rs` (test symbols, lines 2370-2395, 2420-2820)
- `tests/issue_create_json.rs` (lines 407-415, received_requests pattern)
- `tests/json_error_shape.rs` (assert_json_error_envelope implementation)
- `tests/common/mod.rs`, `tests/common/fixtures.rs`
- `src/adf.rs` (grep — AX23-001 test symbols)
- `Cargo.toml`, `Cargo.lock`
- `rust-toolchain.toml`
- `.github/workflows/ci.yml` (lines 58-110, 435-446)
- `.github/workflows/sign-and-publish.yml` (lines 50-80)
- `.github/workflows/backfill-release.yml` (lines 60-90)
- `.github/workflows/release.yml`, `e2e.yml`, `e2e-sweeper.yml` (SHA grep)
- `docs/adr/0014-jsm-request-type-dispatch.md` (amendment sites)

---

## Part A — Fix Verification (pass >= 2 only)

This is pass 76 of the overall SOH-DX-1 F2 series, but pass 1 for the reality-check aperture on spec version v1.3.163. No prior reality-check findings exist to verify.

| ID | Previous Severity | Status | Notes |
|----|-------------------|--------|-------|
| — | — | N/A | No prior reality-check pass findings to verify |

---

## Part B — New Findings (or all findings for pass 1)

### CRITICAL

_None._

### HIGH

_None._

### MEDIUM

_None._

### LOW

#### ADV-P76-LOW-001: delta-analysis.md §5e SHA verification status is stale

- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` § "5e. Verified `fa04a145` SHA must be confirmed pre-F4"
- **Type:** REFINEMENT (documentation inconsistency only; no behavioral or structural gap)
- **In-delta:** YES

**Description:** The F1 delta-analysis artifact states "The full SHA has not been confirmed in this analysis — F2 must include the verification step…before F4 embeds it in 6 workflow files." This text predates the out-of-band verification recorded in the session checkpoints (done during adversarial passes 48-70 per checkpoint evidence). The F1 artifact was never updated to reflect completion of that step.

**Evidence:**
- `delta-analysis.md §5e` current text: "The full SHA has not been confirmed in this analysis — F2 must include the verification step (git log on the upstream repo or Perplexity research) before F4 embeds it in 6 workflow files. Substituting an unverified SHA defeats the security purpose of pinning."
- `session-checkpoints.md`: "P71-001 PARTIALLY DISCHARGED out-of-band: full SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` confirmed real (2026-06-30, 'Add 1.96.1 patch release'); ancestor of master CONFIRMED (behind_by: 0)."
- `convergence-trajectory.md`: identical SHA confirmation record.
- `STATE.md`: carries "blocking pre-impl AC with VERIFIED full 40-char SHA `fa04a1451ff1842e2626ccb99004d0195b455a88`" for S-626-1.

**Impact:** An implementer reading only `delta-analysis.md` would incorrectly believe SHA verification is still outstanding at F2 and would perform redundant verification work. Low risk because STATE.md and convergence-trajectory correctly carry the verified SHA forward. No behavioral gap — the correct SHA is already embedded in the S-626-1 blocking AC record.

**Proposed Fix:** Append a one-line note to `delta-analysis.md §5e`: "DISCHARGED out-of-band (session-checkpoints.md P71-001): SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` confirmed real (2026-06-30, 'Add 1.96.1 patch release') and master ancestor (behind_by: 0). Embedded as blocking AC in S-626-1."

---

## Checklist Coverage

### Item 1 — Crate API claims

**VERIFIED-CORRECT.** All spec assertions about third-party crate API surfaces are accurate:

- **wiremock 0.6** (`Cargo.lock`: 0.6.5): `server.received_requests().await.unwrap()` — confirmed pattern exists in `tests/issue_commands.rs:120`, `tests/multi_profile_fields.rs:211-213`, and `tests/issue_create_json.rs:411`. API is correct for wiremock 0.6.x.
- **assert_json_error_envelope** behavior: spec claims it "strict-parses ALL of stderr as JSON." Confirmed: implementation at `tests/json_error_shape.rs:63` calls `serde_json::from_str(stderr.trim())` — parses the full trimmed stderr. Assertion fields `error` (non-empty string) and stdout emptiness confirmed.
- **dialoguer 0.12** (`Cargo.lock`: 0.12.0): spec's claim that `interact_text()` short-circuits (`ErrorKind::NotConnected`) on non-TTY stderr under assert_cmd is a behavior assertion established empirically in F4 for S-577; accepted as carried evidence.
- **clap 4** (`Cargo.lock`: 4.6.1): no `#[arg(requires = "request_type")]` on `--field` or `--on-behalf-of` — confirmed by grep of `src/cli/mod.rs`. Guards are hand-rolled in `handle_create` per MUST-NOT directive. Confirmed correct.
- No false serde_json, reqwest, keyring, proptest, or insta API claims found in delta scope.

### Item 2 — Crate versions

**VERIFIED-CORRECT.** All version numbers cited in the spec match `Cargo.toml` and `Cargo.lock`:

| Crate | Cargo.toml spec | Cargo.lock actual |
|-------|----------------|------------------|
| clap | "4" | 4.6.1 |
| wiremock | "0.6" | 0.6.5 |
| assert_cmd | "2" | 2.2.2 |
| dialoguer | "0.12" | 0.12.0 |
| serde_json | "1" | 1.x (consistent) |
| reqwest | "0.13" | 0.13.x (consistent) |
| keyring | "3" | 3.x (consistent) |
| insta | "1" | 1.48.0 |
| proptest | "1" | 1.x (consistent) |

### Item 3 — Existing src/ behavior

**VERIFIED-CORRECT.** Every control-flow claim verified against `src/cli/issue/create.rs`:

- **Dispatch fork at line 49**: `if request_type.is_some()` → `return handle_jsm_create(...)` — confirmed.
- **Guard placement at ~:81**: `if !field_pairs.is_empty()` is at line 81 exactly; `if on_behalf_of.is_some()` is at line 86. These are BEFORE project-key resolution (which begins at the `let project_key = ...` block following line 93). Spec claims "step 2 before project-key resolution at step 3" — confirmed correct.
- **Current guards are eprintln! not exit-64**: Confirmed — the current code still uses `eprintln!("warning: --field is ignored...")`. The spec correctly describes the CURRENT state as warn-and-proceed and mandates the DEC-188 flip to `return Err(JrError::UserError(...))` as a F4 delivery obligation.
- **`--markdown requires --description` guard is in jsm_create.rs ~:175, NOT create.rs**: Confirmed — `src/cli/issue/jsm_create.rs:175` has the guard; `src/cli/issue/create.rs` has no such guard. The stale citation in `tests/issue_create_jsm.rs ~:2373-2374` ("verify against create.rs lines 333-343") is correctly identified by the spec as a dead citation requiring F4 correction.
- **ADR-0014 amendment sites exist**: `docs/adr/0014-jsm-request-type-dispatch.md` confirmed to contain "byte-for-byte the same code path" (line 60), "path POSTs to `/rest/api/3/issue` (unchanged)" (line 82), and "The platform path is byte-for-byte unchanged" (line 161) — three of the four amendment sites. Spec mandate to amend at F4 is grounded.

### Item 4 — Test symbol citations

**VERIFIED-CORRECT.** All existing test symbols verified to exist in `tests/issue_create_jsm.rs`:

| Symbol | Actual line | Spec citation |
|--------|------------|---------------|
| `test_platform_create_field_flag_emits_warning_without_request_type` | 2420 | AC-1 current name |
| `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type` | 2493 | AC-2 current name |
| `test_platform_create_both_inverse_flags_emit_independent_warnings` | 2564 | AC-3 current name |
| `test_platform_create_without_inverse_flags_emits_no_new_warnings` | 2631 | AC-4 current name |
| `test_platform_create_field_idempotent_one_warning_per_logical_flag` | 2687 | AC-5 current name |
| `test_jsm_create_with_field_and_request_type_does_not_fire_bc_3_8_012` | 2748 | AC-6 current name |
| `test_platform_create_malformed_field_one_warning_no_exit_64` | 2812 | AC-7 current name |
| `mount_platform_create_stubs` | 2395 | Helper MUST be called |

Additional symbols verified:
- `received_requests` pattern at `tests/issue_create_json.rs ~:411`: line 411 confirmed (`server.received_requests().await.expect("requests recorded")`).
- AX23-001 (v1.3.162) symbols in `src/adf.rs`: `test_bc_7_2_015_mixed_range_surrounding_marks_retained` at line 3061 ✓; `test_bc_7_2_015_multi_mark_wrapper_only_code_node_stripped` at line 3090 ✓.
- New test names (F4 rename targets) correctly DO NOT exist yet — confirmed by grep returning zero hits.
- `write_profile_config` and `tests/common/assertions.rs` do not exist yet — correctly identified as F4 deliverables. `tests/common/mod.rs` currently has only `fixtures`, `mock_server`, `yaml` modules. `assert_json_error_envelope` currently lives only in `tests/json_error_shape.rs:63` — consistent with spec's promotion-at-F4 mandate.

No phantom test names found in this pass.

### Item 5 — CI / workflow claims

**VERIFIED-CORRECT.** All CI claims verified:

- **ci-gate includes msrv**: `ci.yml:438` — `needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]` — confirmed.
- **`sign-and-publish.yml ~:64` has `rustup target add`**: Confirmed at line 64 — `run: rustup target add ${{ matrix.target }}`. Do-not-remove rationale (E0463 on non-pre-installed cross-compilation targets) documented in adjacent comment. Rationale is factually sound.
- **`backfill-release.yml ~:79` has `rustup target add`**: Confirmed at line 79. Same rationale.
- **All 6 workflows currently use `c93f4f9c67595668add93d3d6895795ce52d8c2d`**: Confirmed in all 6 files: `ci.yml:70`, `ci.yml:98`, `sign-and-publish.yml:53`, `backfill-release.yml:68`, `release.yml:38`, `e2e-sweeper.yml:74`, `e2e.yml:80`.
- **MSRV job has NO `with: toolchain:` input**: Confirmed — `ci.yml:70-72` has no `with:` block and no `RUSTUP_TOOLCHAIN` env override. This is the confirmed MSRV false-green that #626 fixes.

### Item 6 — The #626 SHA pin claim

**ONE FINDING (ADV-P76-LOW-001).** See Part B above.

- All 6 workflows confirmed to use `c93f4f9c67595668add93d3d6895795ce52d8c2d`.
- `fa04a1451ff1842e2626ccb99004d0195b455a88` confirmed real and master ancestor per session-checkpoints.md — but `delta-analysis.md §5e` still says verification is pending.
- `c93f4f9c` not a master ancestor (confirmed in convergence-trajectory: "is real (2026-03-27) but NOT master ancestor").

### Item 7 — MSRV consistency

**VERIFIED-CORRECT (known defect correctly documented).** Three-way check:

- `Cargo.toml`: `rust-version = "1.85"` — MSRV is 1.85.
- `rust-toolchain.toml`: `channel = "stable"` — workspace toolchain is stable, NOT 1.85.
- `ci.yml` MSRV job (`name: MSRV (1.85.0)`): Uses SHA `c93f4f9c` (comment `# 1.85.0`) but NO `with: toolchain: "1.85.0"` input and NO `RUSTUP_TOOLCHAIN` env override. `cargo check` reads `rust-toolchain.toml` → runs against stable, not 1.85.

Three-way disagreement confirmed — this IS the documented MSRV false-green that issue #626 fixes. The spec correctly identifies the defect, states the fix, and records the comment accuracy risk as a flagged risk in S-626-1. No spec defect.

### Item 8 — Atlassian/Jira API claims

**VERIFIED-CORRECT.** No unsourced or CLAUDE.md-contradicting Jira API claims found in delta scope. The false "reporter identity" claim was removed in v1.3.108 per changelog. BC-3.8.012/013 guard rationale claims are design decisions, not sourced API facts. EC-3.8.012-10 project-type-agnostic guard claim confirmed correct by source code inspection.

---

## Recurring Defect Class Coverage

- **POL-11 false-green:** No ungrounded `expect(0)` acceptance criteria without would-otherwise-succeed setup found. All ACs asserting `stdout.trim().is_empty()` are correctly paired with `mount_platform_create_stubs` MUST clauses.
- **TWIN-ARTIFACT-SWEEP:** Over-propagation in v1.3.144 was caught and fully corrected in v1.3.145 — historical trail entries restored to `fixtures.rs` while spec body correctly uses `assertions.rs`. No residual over-propagation found.
- **Under-propagation:** BC-3.8.012 and BC-3.8.013 amendments are consistently applied in both bc-3-issue-write.md body AND BC-INDEX.md section 3.8 rows. No propagation gap found.
- **Range-terminus inference:** AC-1..AC-21 (21 ACs), EC-3.8.012-1..10 (10 ECs) — ranges verified by scanning the spec body. All entries present.
- **Citation form:** No bare `file:NN-MM` citations found in the current spec body. Symbol-form citations used throughout.
- **AC negative-assertion specificity:** The spec employs a rigorous three-tier taxonomy (DISCRIMINATING / FALSIFIABLE-COARSE / HYGIENE) explicitly documented per AC. No unspecific or shared-substring negatives found.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 1 (ADV-P76-LOW-001 — REFINEMENT, IN-DELTA) |

**Overall Assessment:** pass-with-findings
**Convergence:** CONVERGENCE_REACHED — 0 GAPs found; 1 non-blocking REFINEMENT
**Readiness:** ready for next phase — spec is clear to proceed to F3/F4

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 76 |
| **New findings** | 1 (ADV-P76-LOW-001 — REFINEMENT/LOW) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.0 (1 new / 1 total; single-shot reality-check aperture — iterative convergence criterion does not apply) |
| **Median severity** | LOW |
| **Trajectory** | N/A — first reality-check pass for v1.3.163; prior passes used different apertures |
| **Verdict** | CONVERGENCE_REACHED — 0 GAPs; 1 LOW REFINEMENT (non-blocking) |
