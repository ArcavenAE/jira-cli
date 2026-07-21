# S-576-6 Story Adversarial Review — Pass Narrative

**Story**: S-576-6 `jr issue attachment` Live-Jira E2E Coverage
**Bundle**: SOH-ATTACHMENTS-1
**Phase**: F3 story-level convergence (story v1.0 → v1.7)
**Criterion**: STRICT (any delta-attributable LOW resets window)
**Result**: CONVERGED STRICT — 10 passes / 7 fix rounds; window p8/p9/p10 CLEAN×3
**Date**: 2026-07-21
**Human overrides**: 0

---

## Pass 1 — FINDINGS (5M + 5L)

**Verdict**: FINDINGS (10 findings — most extensive pass of this convergence)

**Findings applied:**

- **P1-001 (MEDIUM)**: AC-001 step 6 used `download <key> <aid>` (positional AID) — positional AID doesn't exist; corrected to `download <key> --id <aid> --out`. BC-2.7.007 table row corrected. AC-008 SURFACE entry for download gains `--id`.
- **P1-002 (MEDIUM)**: Dead citation `.factory/research/issue-576-attachments-api-2026-07-15.md` — that file does not document the servicedeskapi response schema. Replaced throughout: AC-006 step 1 reads BC-3.9.011 directly; step 3 creates dated artifact `.factory/research/issue-576-p2-3c-probe-<YYYY-MM-DD>.md`; Task 1/4 updated; Token Budget row removed (~38K→~36K, ~19%→~18%); File Structure row changed to CREATE (conditional, dated); Spec Reference Links updated.
- **P1-003 (MEDIUM)**: Architecture Compliance Rules JSM gate row described gate as "first statement" — but `test_every_ignored_test_has_gate_guard` mandates `e2e_enabled()` first. Gate reworded to "fires first AFTER `e2e_enabled()`".
- **P1-004 (MEDIUM)**: Frontmatter `depends_on` missing `S-576-1` — S1 provides the list/serialize surface exercised in AC-001. Added.
- **P1-005 (MEDIUM)**: AC-010 teardown-on-failure used `assert!` panics that would skip sequential cleanup. Drop-guard pattern mandated for AC-002 (public attachment permanent until deleted); collect-results-then-assert acceptable for AC-001/003/004.
- **P1-006 (LOW)**: AC-004 Discriminator paragraph claimed live E2E can observe wire routing — it cannot. Softened to: assert success + echo shape only.
- **P1-007 (LOW)**: Windows-runner rationale in AC-001 step 2 note and Out-of-Scope was wrong — e2e runs ubuntu-only; filename constraints are hygiene best practice, not CI requirement. Corrected.
- **P1-008 (LOW)**: AC-001 step 1 used `e2e_cmd()` — correct helper is `e2e_harness()` + `h.cmd()`. Updated.
- **P1-009 (LOW)**: AC-006 framing was PERFORM-first (implied S6 is the primary discharge owner). Reframed VERIFY-first — S5 is authoritative; S6 probe branch is explicitly-defensive fallback (expected unreachable if S5 landed).
- **P1-010 (LOW)**: AC-003 step 5 used phrase "OQ-9 asymmetry assertion" — OQ-9 is about asymmetry proof; this is a single-side check. Reworded to "OQ-9 single-side assertion".

**Story version**: v1.0 → v1.1. input-hash updated.

---

## Pass 2 — FINDINGS (1M)

**Verdict**: FINDINGS

**Findings applied:**

- **P2-001 (MEDIUM)**: AC-001 step 1 sweeper-label backstop was false — the CI sweeper (e2e.yml `if: always()` teardown, JQL `labels=e2e-$GITHUB_RUN_ID`) can only pick up orphaned issues if step 1 sets the label. `seed_issue(&h, &rl, &summary)` applies `--label <rl>` internally; step 9 sweeper claim grounded; EC-10 updated to state the sweeper works BECAUSE step 1 sets the label.
- **P2-002 (LOW)**: AC-006 step 2 probe command lacked the full required env var set — `E2eHarness::cmd` panics if `JR_E2E_BASE_URL` absent. Added `JR_E2E_BASE_URL`, `JR_AUTH_HEADER`, `JR_E2E_PROJECT`, `JR_E2E_JSM_PROJECT=EJ`.
- **P2-003 (INFO)**: Task 2 `#[tokio::test]` mention dropped — only sync `#[test]` is correct (Drop-guard teardown requires sync; async tests may not execute Drop on panic).

**Story version**: v1.1 → v1.2. input-hash unchanged.

---

## Pass 3 — FINDINGS (1M)

**Verdict**: FINDINGS

**Findings applied:**

- **P3-001 (MEDIUM)**: AC-002/003/005 JSM echo-shape was overstated against the P2-3c deferrals:
  - (a) `--internal` was treated as "confirmed shape" when both paths are deferred by BC-3.9.011; mirrored the pre/post-P2-3c split for `--internal`.
  - (b) `BC-3.9.009` citation dropped from JSM `--internal` path — BC-3.9.009 EC-3.9.009-4 explicitly excludes this path; cited BC-3.9.011 + BC-3.9.007 EC-3.9.007-2 instead.
  - (c) `contentUrl` removed from pre-P2-3c minimum for `--public` and from `--internal` operative minimum — servicedeskapi `links.content` is banned/404 per JSDCLOUD-10841; weaker minimums adopted: public: id+filename non-empty; internal: no top-level `"public"` key.
- **P3-002 (LOW)**: AC-001 step 1 replaced hand-rolled label formula with canonical `run_label()` helper reference and `seed_issue()` for issue creation.
- **P3-003 (LOW)**: AC-003 heading/step-5/NOTE and BC table row removed `OQ-9` label — OQ-9 governs NON-JSM asymmetry; EJ `--internal` shape check is BC-3.9.011 territory. Reworded.

**Story version**: v1.2 → v1.3. input-hash unchanged.

---

## Pass 4 — FINDINGS (2M) — Partial-Fix Propagation Class (S-7.01)

**Verdict**: FINDINGS

**Findings applied:**

- **P4-001 (MEDIUM)**: Task 6 body still used phrase "OQ-9 asymmetry (no public key in array elements)" — P3 fix round had corrected the BC table row and AC-003 but left Task 6 untouched. Grep sweep: confirmed zero `OQ-9` and "in array elements" survivors after fix. AC-006 step 4 updated to pin AC-002/AC-003/AC-005 (was AC-002/005 only).
- **P4-002 (MEDIUM)**: AC-001 step 1 cited `seed_issue(&h, &key)` 2-arg form — real helper signature at `tests/e2e_live.rs:530` is `seed_issue(h, label, summary)` (3 args). Corrected; `summary` variable added carrying `[e2e <rl>]` marker; grep sweep confirms no other `seed_issue` citation remained stale.
- **LOW** (from P3): AC-003 step 2 and AC-004 step 2 harmonized to match AC-002 Gate-2 skip-if-empty wording `(dynamic RT discovery per jsm-e2e-coverage.md §4.2; skip if list empty per §3.2)`.

**Story version**: v1.3 → v1.4. input-hash unchanged.

---

## Pass 5 — NITPICK_ONLY

**Verdict**: NITPICK_ONLY (no MEDIUM+ findings; window not reset by LOW under STRICT criterion)

**Nits applied (P5-001 + P5-002):**

- **P5-001 (LOW)**: Four floor assertions (AC-002 step 4, AC-003 step 5, AC-005 `--internal` operative minimum, BC table row BC-3.9.011) caveated as conditional on AC-006 discharge outcome — each carries `(pre-P2-3c working assumption; corrected by the AC-006 capture if the confirmed servicedeskapi shape differs)` or equivalent.
- **P5-002 (LOW)**: AC-001 step 9 bare `jr issue move` replaced with `best_effort_close(&h, &key)` helper reference; `--label` backreference corrected from `<run_label>` to `<rl>` for consistency.

**Story version**: v1.4 → v1.5. input-hash unchanged.

---

## Pass 6 — NITPICK_ONLY

**Verdict**: NITPICK_ONLY

**Nit applied:**

- Task 4 gained ordering clarifier — implementer must write the Task-5 test skeleton first, then run it for the live capture; this fallback path is expected unreachable when S5 discharged (AUDIT-576-002 satisfied). Clarifier prevents implementer from attempting to write assertions without a live run.

**Story version**: v1.5 → v1.6. input-hash unchanged.

---

## Pass 7 — FINDINGS (1M)

**Verdict**: FINDINGS (window reset; clean streak reset to 0)

**Finding applied:**

- **P7-001 (MEDIUM)**: AC-002 step 5 had wrong task pointer — "per AC-006 Task 6" should be "per AC-006 (Task 4 — the discharge task, which runs the Task-5 skeleton)". A second stale "Task 6" reference was found at the P2-3c callout block (~line 107). Full Task N cross-reference audit performed post-fix: Task 1 flagging in Task 1 body (correct); Task 4 references in Task 1/Task 5/Task 8/Architecture Compliance (all correct); Task 5 forward reference in Task 4 (correct); Tasks 4–6 sequencing in Architecture Compliance (correct). Total incorrect Task N refs fixed: 2.

**Story version**: v1.6 → v1.7. input-hash unchanged.

---

## Pass 8 — CLEAN (window 1/3)

**Verdict**: CLEAN

No findings. Window progress: 1/3.

---

## Pass 9 — CLEAN (window 2/3)

**Verdict**: CLEAN

No findings. Window progress: 2/3.

---

## Pass 10 — CLEAN (window 3/3) — CONVERGED STRICT

**Verdict**: CLEAN

No findings. Window p8/p9/p10 CLEAN×3. **CONVERGED STRICT.**

---

## Summary

| Metric | Value |
|--------|-------|
| Total passes | 10 |
| Fix rounds | 7 |
| Human overrides | 0 |
| Story version | v1.0 → v1.7 |
| Final window | p8/p9/p10 CLEAN×3 |
| Trajectory | 10→1→1→2→0→0→1→0→0→0 |
| Spec changed | Yes (v1.3.97 → v1.3.98; S6-SCOPE-ROUND; zero new BCs) |

**Process note**: Adversary caught 10 MEDIUM-class defects pre-implementation — including two partial-fix propagation regressions (S-7.01 class: p4 caught P3-fix survivors at Task 6 and in the seed_issue arity). This validates that story-level convergence is load-bearing for facade/E2E stories, not ceremonial.
