# S-576-4 Step 4.5 — Adversarial Convergence Passes

**Story:** S-576-4 (attachment delete — `jr issue attachment delete`)
**Criterion:** STRICT (window: 3 consecutive CLEAN passes required)
**Outcome:** CONVERGED STRICT — 2026-07-21
**Window:** p9 CLEAN / p10 CLEAN / p11 CLEAN
**Total passes:** 11 | **Fix rounds:** 5 | **Human overrides:** 0

---

## Pass 1 — FINDINGS (1M)

**Verdict:** FINDINGS
**Finding count:** 1 MEDIUM
**ID:** P1-001

**Finding:** `parse_age_duration` — char-boundary panic on multi-byte input + i64 multiply overflow on large age values. The duration arithmetic path converted `age_days * SECS_PER_DAY` without checking for i64 overflow; on sufficiently large inputs this panicked. Additionally, iterating over bytes instead of chars in the string parser triggered a char-boundary panic on non-ASCII input.

**Fix round 1:** i64 multiply overflow guard (saturating cast or explicit clamp); char-aware iteration in `parse_age_duration`.

**Story version after fix:** v1.31

---

## Pass 2 — FINDINGS (2M)

**Verdict:** FINDINGS
**Finding count:** 2 MEDIUM
**IDs:** P2-001, P2-002

**Infra note:** This verdict was delivered via message resend after two API-error kills (HTTP 529 + 500). This is a RECURRENCE of the same class of infra disruption observed in S-576-2 pass-2. Classified as watch item for escalation.

**Finding P2-001:** `chrono TimeDelta::try_seconds` fallibility band — the second distinct overflow band. After the P1-001 i64 multiply fix, the next downstream fallible operation was the conversion into a `chrono::TimeDelta` via `try_seconds`, which can itself return `None` on out-of-range input. This band was invisible before the P1 fix because P1 was the first failure point.

**Finding P2-002:** AC-009 multi-AID fan-out path — unimplemented and untested. When multiple attachment IDs are passed to the delete command, the fan-out loop path had no implementation and no tests covering it.

**Fix round 2:** `try_seconds` fallibility guard (handle `None` case with appropriate error); AC-009 multi-AID fan-out implementation + integration tests.

**Story version after fix:** v1.32

---

## Pass 3 — FINDINGS (1M)

**Verdict:** FINDINGS
**Finding count:** 1 MEDIUM
**ID:** P3-001

**Finding:** Human dry-run tables missing both forms — the `--dry-run` flag produced neither JSON nor human-readable tabular output; only a bare text message was emitted. Both output forms (JSON via `--output json --dry-run` and human table via `--dry-run` alone) were required by the story spec.

**Fix round 3:** Implement both dry-run output forms (JSON shape + human-readable table).

**Story version after fix:** v1.33

---

## Pass 4 — FINDINGS (1M)

**Verdict:** FINDINGS
**Finding count:** 1 MEDIUM
**ID:** P4-001

**Finding:** AC-003 stdout/stderr text contradiction in story v1.33. The acceptance criterion AC-003 in the story said "stdout" for the deletion confirmation message, but the spec (bc-3-issue-write.md) mandated "stderr". This was a story-level transcription error, not a spec error. The spec is authoritative.

**Fix round 4:** Correct AC-003 text from "stdout" to "stderr" in the story. Story v1.33 → v1.34.

**Story version after fix:** v1.34

---

## Pass 5 — NITPICK_ONLY

**Verdict:** NITPICK_ONLY
**Finding count:** 0 actionable

**Finding:** Visibility nit — a minor comment/documentation phrasing issue with no behavioral impact. Discharged via commit 7193b7db.

**No fix round required.** Streak: 0/3 (pass-7 was the first CLEAN in the window; this pass broke the streak possibility — see pass-7 below).

---

## Pass 6 — FINDINGS (1M)

**Verdict:** FINDINGS
**Finding count:** 1 MEDIUM
**ID:** P6-001

**Finding:** DateTime NaiveDate subtraction panic — the third distinct overflow band in the duration arithmetic onion. After P1-001 (i64 multiply) and P2-001 (chrono TimeDelta) were fixed, the remaining fallible operation was the `NaiveDate` subtraction via `checked_sub_signed`. Without the guard, a DateTime difference on extreme dates panicked. This was the deepest layer of the fallible-arithmetic onion; it only became reachable after the first two layers were fixed.

**Process note:** This three-fix-round onion is the evidence basis for codifying **FALLIBLE-ARITHMETIC-SWEEP** as a process lesson: when guarding numeric user input, enumerate EVERY downstream fallible operation at once, not just the immediately visible first one.

**Fix round 5 (partial — also covers P8-001):** MAX_AGE_SECS clamp before duration construction + `checked_sub_signed` with explicit error path.

**Story version after fix:** v1.34 (count syncs and 7 unit pins added; no version bump since AC-003 was already fixed)

---

## Pass 7 — CLEAN (pre-window)

**Verdict:** CLEAN
**Finding count:** 0

Pass 7 was CLEAN but did not start the convergence window because it followed FINDINGS passes without an unbroken preceding CLEAN. Streak: 1/3 candidate started.

---

## Pass 8 — FINDINGS (1M)

**Verdict:** FINDINGS
**Finding count:** 1 MEDIUM
**ID:** P8-001

**Finding:** Empty-AID list vacuous-truth bypass — when an empty list of attachment IDs was passed, the validation loop exited vacuously (all zero iterations = no error = success). This allowed the command to proceed past validation with no attachments to delete, producing a misleading success response. A sibling-parity guard was needed to reject the empty-AID case explicitly.

**Fix round 5 (continued — same round as P6-001):** Sibling-parity guard: reject empty AID list before entering the fan-out loop.

**Streak reset to 0/3.**

---

## Pass 9 — CLEAN (window 1/3)

**Verdict:** CLEAN
**Finding count:** 0

Window started. Streak: 1/3.

---

## Pass 10 — CLEAN (window 2/3)

**Verdict:** CLEAN
**Finding count:** 0

Streak: 2/3.

---

## Pass 11 — CLEAN (window 3/3) — CONVERGED

**Verdict:** CLEAN
**Finding count:** 0

**WINDOW COMPLETE. STRICT CONVERGENCE ACHIEVED.**

Streak: 3/3. Criterion met. S-576-4 Step 4.5 CONVERGED STRICT.

---

## Convergence Summary

| Pass | Verdict | Findings | Fix round |
|------|---------|----------|-----------|
| p1 | FINDINGS | 1M (P1-001 parse_age_duration overflow) | R1 |
| p2 | FINDINGS | 2M (P2-001 chrono TimeDelta; P2-002 multi-AID) | R2 |
| p3 | FINDINGS | 1M (P3-001 dry-run tables) | R3 |
| p4 | FINDINGS | 1M (P4-001 AC-003 channel) | R4 |
| p5 | NITPICK_ONLY | 0 actionable | — |
| p6 | FINDINGS | 1M (P6-001 DateTime panic) | R5 |
| p7 | CLEAN | 0 | — |
| p8 | FINDINGS | 1M (P8-001 empty-AID vacuous) | R5 (same) |
| p9 | CLEAN | 0 | — (window 1/3) |
| p10 | CLEAN | 0 | — (window 2/3) |
| p11 | CLEAN | 0 | — (window 3/3) **CONVERGED** |

**Trajectory shorthand:** 1→2→1→1→0→1→0→1→0→0→0

---

## Notable Observations

### Duration-overflow onion (FALLIBLE-ARITHMETIC-SWEEP codification candidate)

Three consecutive fix rounds addressed three distinct overflow bands in the same arithmetic pipeline:
1. **P1-001** — i64 multiply overflow (`age_days * SECS_PER_DAY`)
2. **P2-001** — chrono `TimeDelta::try_seconds` fallibility
3. **P6-001** — `NaiveDate::checked_sub_signed` panic

Each band was hidden by the preceding one: the earlier panic masked the later overflow path. This is the canonical evidence for codifying the **FALLIBLE-ARITHMETIC-SWEEP** rule: *when guarding numeric user input, enumerate ALL downstream fallible operations in a single sweep pass, not just the first.*

### Infra watch: 529/500 kills (RECURRENCE)

Pass 2 verdict was delivered via message resend after two API-error kills (HTTP 529 + 500). This is the second occurrence of this class (first was S-576-2 pass-2). Elevated to watch item for session-level escalation.

### Zero human overrides

All 11 passes ran without human adjudication. The p5 NITPICK_ONLY verdict (visibility nit discharged via 7193b7db) was handled autonomously.

### Spec UNCHANGED

`bc-3-issue-write.md` was not modified during S-576-4 Step 4.5 convergence. All findings were story-level (AC text corrections, implementation gaps).

---

_Generated: 2026-07-21 | Worktree HEAD: b0792a9a | Story: S-576-4 v1.34_
