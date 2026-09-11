---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-09-11T00:00:00Z
inputs: []
input-hash: "0ed191e"
traces_to: "cycles/cycle-007/phase-f3-stories/S-cycle7-credential-absence-fix.md"
previous_review: "cycles/cycle-007/adversarial-reviews/pass-2.md"
phase: F4-per-story-convergence
step: "Step 4.5"
pass: 3
cycle: cycle-007-auth-correctness-dx
story: S-cycle7-credential-absence-fix
story_label: "Story A"
target: "fix/cycle7-credential-absence @ 754b6940 vs develop"
reviewer: "OpenAI Codex CLI (cross-vendor)"
sandbox: "read-only; fresh context (no prior pass state)"
verdict: NOT-CLEAN
novelty: MEDIUM
counts:
  high: 0
  medium: 1
  low: 0
  info: 0
counter_status: "0/3 CLEAN (reset; MED finding present)"
pass_01_disposition: "NOT-CLEAN (doc drift; fixed @ 24b65d1a)"
pass_02_disposition: "NOT-CLEAN (stale exit64/positional terminology; swept @ 754b6940)"
raw_output: "/tmp/codex-review-storyA-p3/codex-review.json  [scratch — ephemeral; this file is the durable record]"
---

# Adversarial Review: cycle-007 Story A — Per-Story Convergence (Pass 3)

**Story:** `S-cycle7-credential-absence-fix` (Story A)
**Cycle:** cycle-007 (`auth-correctness-dx`)
**Phase:** F4 delta implementation — per-story convergence (Step 4.5)
**Reviewer:** OpenAI Codex CLI (cross-vendor; fresh context, read-only sandbox)
**Target:** branch `fix/cycle7-credential-absence` @ `754b6940` vs `develop`
**Verdict:** NOT CLEAN — 1 MEDIUM finding (`ADV-cycle007-P3-MED-01`)
**Novelty:** MEDIUM — the equals-form hint gap is a genuine new surface not raised in passes 1 or 2.

## Finding ID Convention

Finding IDs for this per-story convergence loop: `ADV-cycle007-P{N}-{SEV}-{NN}`
(resets to 01 per pass per VSDD convention). This pass: one finding, `ADV-cycle007-P3-MED-01`.

---

## Reviewed Files

Codex `reviewed[]` list (verbatim from raw output):

- `CHANGELOG.md`
- `docs/specs/multi-profile-auth.md`
- `src/api/auth.rs`
- `tests/auth_credential_absence.rs`
- `src/api/client.rs`
- `src/error.rs`
- `src/main.rs`
- `src/profile.rs`
- `src/config.rs`
- `src/cli/mod.rs`
- `src/cli/auth/mod.rs`
- `src/cli/auth/login.rs`
- `src/cli/auth/status.rs`
- `tests/common/assertions.rs`

---

## Part A — Fix Verification (Passes 1 and 2)

| ID | Pass | Previous Root Cause | Status | Evidence |
|----|------|---------------------|--------|---------|
| (pass-1 findings) | 1 | Doc drift: `docs/specs/multi-profile-auth.md` missing BC-1.6.048/049 entries; `CHANGELOG.md` `[Unreleased]` absent | RESOLVED | Remediation burst committed @ `24b65d1a`; files confirmed updated by pass-2 reviewer |
| (pass-2 findings) | 2 | Stale exit-64/positional terminology in `tests/auth_credential_absence.rs` assertion strings and inline comments | RESOLVED | Swept @ `754b6940`; no regressions observed in pass-3 review |

Both prior passes were reviewed by the same reviewer family (Claude adversary).
This is the first cross-vendor pass; no pass-1 or pass-2 finding state was visible
to the Codex reviewer (fresh context, read-only sandbox).

---

## Part B — New Findings

### HIGH

*(none)*

### MEDIUM

#### ADV-cycle007-P3-MED-01: Space-form hint breaks for leading-hyphen profile names

- **Severity:** MEDIUM
- **Category:** edge-case / hint correctness
- **Confidence:** HIGH
- **Location:** `src/api/auth.rs::NotAuthenticated` hint construction (:809 and :824)

- **Description:** Both `JrError::NotAuthenticated` hint arms emit the remediation
  suggestion in space form:

  ```
  jr auth login --profile {profile}
  ```

  For a profile named `-prod`, the hint becomes `jr auth login --profile -prod`.
  `src/cli/mod.rs` declares the global `--profile` flag without `allow_hyphen_values`.
  clap therefore parses `-prod` as a flag token, not as the value for `--profile`.
  The user following this hint gets a clap parse error (exit 2), not a successful
  login — re-triggering the credential-absence failure class that Story A was written
  to fix (GitHub #784).

- **Evidence:**
  - `src/config.rs` (profile name loading from `[profiles.<name>]`): no restriction
    on leading hyphens; a profile named `-prod` is a valid `Config` state.
  - `src/cli/mod.rs` `--profile` clap attribute: `long = "profile"`, no
    `allow_hyphen_values` present.
  - `src/api/auth.rs:809` / `:824`: hint assembled via
    `format!("jr auth login --profile {profile}")` (space form, raw profile name string).
  - `src/profile.rs` `Profile(String)` newtype: `From<String>` is infallible; no
    restriction on string content; `-prod` is a representable value.

- **Proposed Fix:**
  1. Change both hint construction sites from space form to equals form:
     ```rust
     format!("jr auth login --profile={profile}")
     ```
     The equals form (`--long=value`) is parsed by clap independently of
     `allow_hyphen_values` and therefore works for all profile name strings.
  2. Add a clap round-trip test (in `tests/auth_credential_absence.rs` or a new file)
     that constructs `Profile("-prod".to_string())`, calls the hint construction path,
     and asserts the emitted string contains `--profile=-prod` (equals form), not
     `--profile -prod` (space form).

- **Status:** BEING FIXED on `fix/cycle7-credential-absence` — equals-form change to
  both `:809` and `:824` sites plus leading-hyphen clap round-trip test, in the same
  micro-commit.

### LOW

*(none)*

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH     | 0 |
| MEDIUM   | 1 |
| LOW      | 0 |

**Overall Assessment:** NOT CLEAN — 1 MEDIUM finding open; being fixed this cycle.
**Convergence:** FINDINGS_REMAIN — 0 of 3 required CLEAN passes achieved; iterate.
**Readiness:** Requires fix commit on `fix/cycle7-credential-absence` before Pass 4.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 3 |
| **New findings** | 1 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.0 (1 new / 1 total) |
| **Median severity** | 2.0 (MED on 1–5 scale) |
| **Trajectory** | NOT-CLEAN → NOT-CLEAN → NOT-CLEAN (P1/P2/P3) |
| **Verdict** | FINDINGS_REMAIN |

---

## Per-Story Convergence Tracker (Step 4.5)

| Pass | Reviewer | Verdict | Root cause / finding summary | Resolution |
|------|----------|---------|------------------------------|-----------|
| Pass 1 | Claude adversary (same-family) | NOT CLEAN | Doc drift — `docs/specs/multi-profile-auth.md` missing BC-1.6.048/049 entries; `CHANGELOG.md` `[Unreleased]` absent | Fixed @ `24b65d1a` |
| Pass 2 | Claude adversary (same-family) | NOT CLEAN | Stale exit-64/positional terminology in `tests/auth_credential_absence.rs` assertions and inline comments | Swept @ `754b6940` |
| Pass 3 | OpenAI Codex CLI (cross-vendor) | NOT CLEAN | `ADV-cycle007-P3-MED-01`: space-form hint in `src/api/auth.rs::NotAuthenticated` (:809, :824) breaks for leading-hyphen profile names; equals-form required | BEING FIXED on `fix/cycle7-credential-absence` |

**Clean pass counter:** 0 of 3 required CLEAN passes achieved.
**Minimum passes still required:** 3 consecutive CLEAN passes after the equals-form fix is committed.
**Next pass:** Pass 4 — after implementer commits equals-form change + round-trip test; fresh reviewer
against the updated branch tip.

---

## Notes

- The Codex raw JSON output is at `/tmp/codex-review-storyA-p3/codex-review.json`
  (scratch, ephemeral). This `pass-3.md` file is the durable factory record.
- Per Step 4.5 discipline, all three passes to date have been NOT CLEAN. The core
  code change (credential-absence → exit 2, BC-1.6.048/BC-1.6.049) has been confirmed
  correct across all passes; the remaining open issue is purely in the hint
  construction string and a missing test.
