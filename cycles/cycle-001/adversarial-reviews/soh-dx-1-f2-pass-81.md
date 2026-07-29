---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: 2026-07-29T00:00:00
phase: F2
inputs:
  - .factory/phase-f1-delta/SOH-DX-1/delta-analysis.md
  - .factory/spec-changelog.md
  - .factory/specs/prd/bc-3-issue-write.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/specs/prd/CANONICAL-COUNTS.md
  - .factory/specs/prd/holdout-scenarios.md
  - .factory/specs/prd/README.md
  - .factory/specs/prd/error-taxonomy.md
  - .factory/stories/S-383-platform-inverse-warnings.md
input-hash: "c6057b0"
traces_to: bc-3-issue-write.md
pass: 81
previous_review: null
cycle: cycle-001
bundle: SOH-DX-1
aperture: delta-completeness + AC-falsifiability
spec_version: v1.3.165
date: 2026-07-29
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
---

# Adversarial Review: SOH-DX-1 F2 (Pass 81)

**Aperture:** DELTA-COMPLETENESS + AC-FALSIFIABILITY
**Spec version at evaluation:** v1.3.165 (H-NEW-PREFLIGHT-004 assertion tightened, stdout-only)
**Reviewer basis:** DEC-190 substitute — consistency-validator role, not adversary agent; sibling reviewer files not read

---

## Finding ID Convention

Finding IDs use the format: `ADV-P<PASS>-<SEV>-<SEQ>` (no cycle prefix — no `.factory/current-cycle` file present).

- `ADV`: Fixed prefix identifying adversarial findings
- `P81`: Pass 81
- `<SEV>`: Severity abbreviation (`CRIT`, `HIGH`, `MED`, `LOW`)
- `<SEQ>`: Three-digit sequence within the pass

This pass also uses `P81-NNN` shorthand for internal cross-references (obligation IDs, finding IDs in text). The ADV- prefix form is the canonical finding ID.

---

## Perimeter

Files examined in this pass (all within review perimeter; off-limits files not accessed):

| File | Examined via |
|------|-------------|
| `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` | Full read |
| `.factory/spec-changelog.md` | Lines 1–200 read |
| `.factory/specs/prd/bc-3-issue-write.md` | Targeted grep/sed on §3.8, AC block (lines 3112–3136), Trace fields |
| `.factory/specs/prd/BC-INDEX.md` | Frontmatter + §3.8 section (lines 346–366) |
| `.factory/specs/prd/CANONICAL-COUNTS.md` | Frontmatter + per-file table + Sum row |
| `.factory/specs/prd/holdout-scenarios.md` | Frontmatter + Group 20 block; `grep -c "^### H-"` |
| `.factory/specs/prd/README.md` | Holdout rows (lines 48, 108) |
| `.factory/specs/prd/error-taxonomy.md` | Frontmatter + Section 6 issue-commands block |
| `.factory/stories/S-383-platform-inverse-warnings.md` | Frontmatter + banner + closing note |
| `src/cli/issue/edit.rs` | `grep -n "cannot be combined with"` |
| `src/cli/issue/jsm_create.rs` | `grep -n "cannot be combined with"` |

Off-limits (per isolation constraint, not accessed):
- `.factory/cycles/cycle-001/adversarial-reviews/` (sibling reviews)
- `.factory/cycles/cycle-001/convergence-trajectory.md`
- `.factory/STATE.md`

---

## Dimension A — Upstream Obligation Discharge

### Complete Obligation Enumeration

The delta-analysis.md covers three issues. All obligations enumerated below with F2 disposition.

#### Issue #639 (S-639-1) — Pre-flight guard promotion (BREAKING)

| # | Obligation | Source | F2 Disposition |
|---|-----------|--------|---------------|
| O-639-1 | `src/cli/issue/create.rs` lines 81–90: replace `eprintln!` guards with `JrError::UserError` pre-flight exits | §1 Item-1 table; Trace (a) | **DEFERRED F3/F4** — tracked as S-639-1 Trace item (a) |
| O-639-2 | `tests/issue_create_jsm.rs` — 5 tests invert to exit-64 (AC-1/2/3/5/7); AC-7 rename | §1 blast-radius table; Trace items (a)/(d) | **DEFERRED F3/F4** — DELETE mandates and KEPT clauses fully spec'd in AC bodies |
| O-639-3 | AC-4 test body update: add three absence-of-new-error-string negatives | §1 second table; AC-4 body | **DEFERRED F3/F4** — F18-002 and F24-02 obligations recorded in spec |
| O-639-4 | AC-6 test body update: re-point to exit 0 + absence assertions | §1 second table; AC-6 body | **DEFERRED F3/F4** — obligation recorded in AC-6 KEPT clauses |
| O-639-5 | `Cargo.toml` — version bump to 0.7.0-dev.1 | §1 (DEC-188 clause d); Trace item (c) | **DEFERRED F3** — delivery item (c) |
| O-639-6 | `CHANGELOG.md` — `### Breaking Changes` entry under v0.7.0 | §1 table; Trace item (c) | **DEFERRED F3** — delivery item (c) |
| O-639-7 | `bc-3-issue-write.md` BC-3.8.012 body superseded to exit-64 semantics | §4 Item 1 | **DISCHARGED F2** — [CURRENT BEHAVIOR] block confirmed at v1.3.107 |
| O-639-8 | `bc-3-issue-write.md` BC-3.8.013 body superseded (symmetric) | §4 Item 1 | **DISCHARGED F2** — confirmed |
| O-639-9 | Amendment note at `bc-3-issue-write.md:~481` updated (emit-warn → exit-64) | §5b | **DISCHARGED F2** — "[AMENDED 2026-07-25 SOH-DX-1 DEC-188 #639] … pre-flight `JrError::UserError` exit 64" confirmed |
| O-639-10 | `BC-INDEX.md` rows BC-3.8.012/013 updated to "exits 64 pre-flight" | §4 Item 1 | **DISCHARGED F2** — lines 361–362 confirmed; "[AMENDED DEC-188 2026-07-25]" annotation present |
| O-639-11 | `CLAUDE.md` — dispatch-fork gotcha update (S-288-pr4 qualifier stale after guard) | §1 table; Trace item (b) | **DEFERRED F3/F4** — delivery item (b) |
| O-639-12 | ADR-0014 amendment at 4 sites ("absent → platform path unchanged" claims stale) | §1 table + §4 Item 1; Trace item (a) | **DEFERRED F3/F4** — fourth site enumerated at v1.3.122 |
| O-639-13 | E2E blast-radius scan (`tests/e2e_live.rs` for `--field`/`--on-behalf-of`) | §5e / §2; Trace item (g) | **DISCHARGED F2** — F64-001 recorded; item (g) marked "DISCHARGED at F2" |
| O-639-14 | §5c — idempotency semantics explicit in BC-3.8.012 postcondition | §5c | **DISCHARGED F2** — "ONE check, ONE error, regardless of how many `--field` occurrences" confirmed |
| O-639-15 | No new ADR warranted (guard matches edit.rs pattern; inline comment sufficient) | §5c ruling | **NON-GOAL** — ruling recorded |
| O-639-16 | `src/cli/mod.rs` `--field` and `--on-behalf-of` first help-doc lines updated | §4 Item 1; Trace item (d) | **DEFERRED F3/F4** — delivery item (d) |
| O-639-17 | `jsm_create.rs:~171-172` and two `tests/issue_create_jsm.rs` comment sites corrected | Trace item (e) + F43/F45 | **DEFERRED F3/F4** — 3-site obligation in delivery item (e) |
| O-639-18 | FAMILY-level banner rewrite in `tests/issue_create_jsm.rs:~2381-2391` | F45-002 | **DEFERRED F3/F4** — delivery item (e) extended at v1.3.143 |
| O-639-19 | Holdout scenarios H-NEW-PREFLIGHT-001..006 (F51-001 non-goal overturned) | Holdout ruling | **DISCHARGED F2** — authored at v1.3.164; Note (coverage non-goal) at both BCs superseded |
| O-639-20 | `error-taxonomy.md` Section 6 registration (three DEC-188 conditions) | F52-001 | **DISCHARGED F2** — confirmed at v1.3.150 |
| O-639-21 | `docs/specs/issue-create-preflight-guards.md` feature spec | §4 Item 1 (F-4 ruling); Trace item (f) | **DEFERRED F3** — confirmed file does NOT yet exist (expected) |

#### Issue #627 (S-627-1) — Script false-positive fix

| # | Obligation | Source | F2 Disposition |
|---|-----------|--------|---------------|
| O-627-1 | `scripts/check-bc-no-numeric-test-counts.sh` — regex fix + `--self-test` seam + `--bc-dir` override | §1 Item 2 | **DEFERRED F3** — S-627-1 story scope |
| O-627-2 | `bc-2-issue-read.md` — revert hyphenation workaround | §1 Item 2 | **DEFERRED F3** — after script fix lands on develop |
| O-627-3 | `bc-3-issue-write.md` — revert same hyphenation workaround | §1 Item 2 | **DEFERRED F3** — sequencing constraint same |
| O-627-4 | Sequencing guard: script fix MUST merge before factory-artifacts revert | §1 Item 2 | **DEFERRED F3** — process constraint documented |

#### Issue #626 (S-626-1) — MSRV false-green + SHA pin

| # | Obligation | Source | F2 Disposition |
|---|-----------|--------|---------------|
| O-626-1 | `ci.yml` stable-pin SHA → `fa04a145...` + toolchain input | §1 Item 3 | **DEFERRED F3/F4** — S-626-1 story scope |
| O-626-2 | `ci.yml` msrv job: SHA + toolchain input (1.85.0) + `RUSTUP_TOOLCHAIN` env | §1 Item 3 | **DEFERRED F3/F4** |
| O-626-3..7 | `backfill-release.yml`, `e2e-sweeper.yml`, `e2e.yml`, `release.yml`, `sign-and-publish.yml` — SHA replacement (6 workflow files total) | §1 Item 3 | **DEFERRED F3/F4** |
| O-626-8 | `CLAUDE.md` — `RUSTUP_TOOLCHAIN` override gotcha note | §1 Item 3 | **DEFERRED F3/F4** |
| O-626-9 | SHA verification: `fa04a1451ff1842e2626ccb99004d0195b455a88` confirmed | §5e | **DISCHARGED F2** — delta-analysis.md §5e records P71-001; downstream F3 obligation explicitly PRESERVED |
| O-626-10 | Assess `sign-and-publish.yml`/`backfill-release.yml` defensive `rustup target add` | §5d | **DEFERRED F4** — assessment-only flag; do NOT remove without explicit F4 assessment |
| O-626-11 | S-626-1 story must carry blocking pre-implementation AC pinning SHA | §5e downstream | **DEFERRED F3** — STATE-ONLY; obligation noted as "still stands" |

### Disposition Summary

| Category | Count |
|----------|-------|
| DISCHARGED at F2 | 11 |
| DEFERRED to F3/F4 (story deliverables, tracked) | 19 |
| NON-GOAL (ruling recorded) | 1 |
| ABSENT (obligation missing without disposition) | **0** |

---

## Dimension A — F2 Disposition Analysis

### Item 3: §5e SHA Verification Scrutiny

The delta-analysis.md §5e records: "Verification complete; P71-001 recorded in session-checkpoints.md." The SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` is explicitly quoted in the delta-analysis.md text. The downstream obligation ("S-626-1 blocking AC must pin this SHA") is explicitly preserved as "still stands."

Independent network verification of the SHA against the `dtolnay/rust-toolchain` repository is outside the spec-review scope of this pass. The downstream obligation is properly preserved rather than dissolved — STATE-ONLY is structurally correct for F2.

**Assessment:** DISCHARGED claim supported by evidence within perimeter. No GAP.

### Item 4: Holdout Ruling Discharge

Evidence examined:
- `holdout-scenarios.md` frontmatter: `total_holdouts: 106` ✓
- Group 20 (lines 2573–2736): H-NEW-PREFLIGHT-001..006 present (6 headings, `grep -c` = 106) ✓
- BC-3.8.012 Trace: H-NEW-PREFLIGHT-001/003/004/005/006 cited ✓
- BC-3.8.013 Trace: H-NEW-PREFLIGHT-002/003/004/005 cited ✓
- Note (coverage non-goal) at both BCs: superseded per v1.3.164/v1.3.165 ✓
- CANONICAL-COUNTS.md Group 20 entry: present ✓

H-NEW-PREFLIGHT-006 cited in BC-3.8.012 only (intentional — `--field`-specific JSON envelope; BC-3.8.013 JSON envelope coverage via AC-2/AC-10). Not a gap.

**Assessment:** FULLY DISCHARGED.

---

## Dimension B — AC Falsifiability Audit

### AC Classification Review (all 21 ACs)

| AC | Spec Label | This Pass Verdict | Notes |
|----|-----------|-------------------|-------|
| AC-1 | DISCRIMINATING | CONFIRMED | exit 64 + FULL-STRING pin + `!stderr.contains("Created issue")` + would-otherwise-succeed |
| AC-2 | DISCRIMINATING | CONFIRMED | exit 64 + `assert_json_error_envelope` + `stdout.trim().is_empty()` on would-otherwise-succeed (F46-001 added `mount_platform_create_stubs` MUST) |
| AC-3 | DISCRIMINATING / FALSIFIABLE-COARSE | CONFIRMED | Combined-error string FULL-STRING pinned; two single-flag absence negatives correctly FALSIFIABLE-COARSE (F33-1) |
| AC-4 | DISCRIMINATING | CONFIRMED | F18-002 added third negative; F24-02 added would-otherwise-succeed. Would fail if guard fires unconditionally. |
| AC-5 | DISCRIMINATING | CONFIRMED | `expect(1)` not `expect(N)` — one output regardless of flag repetition; DISCRIMINATING NEGATIVE at F21-03 |
| AC-6 | FALSIFIABLE-COARSE | CONFIRMED | JSM dispatch structurally prevents mis-fire; re-labeled FALSIFIABLE-COARSE at v1.3.117; exit 0 anchor is DISCRIMINATING |
| AC-7 | DISCRIMINATING | CONFIRMED | Bare-name-no-equals variant; `stdout.trim().is_empty()` DISCRIMINATING per F32-2 |
| AC-8 | DISCRIMINATING | CONFIRMED | Two isolated MockServer instances; `received_requests().is_empty()` zero-HTTP normative (F31-2) |
| AC-9 | DISCRIMINATING | CONFIRMED | `!stderr.contains("Project key")` proves step-2 ordering; DISCRIMINATING per F33-1 |
| AC-10 | DISCRIMINATING | CONFIRMED | would-otherwise-succeed + `stdout.trim().is_empty()` genuinely DISCRIMINATING per F33-2 |
| AC-11 | DISCRIMINATING (items 1,2,4,5) / HYGIENE (item 3) | CONFIRMED | F43-01 added items (4)(5); F44-003 corrected item (3) to HYGIENE |
| AC-12 | DISCRIMINATING | CONFIRMED | `count == 2` assertion; any omission of help line fails |
| AC-13 | FALSIFIABLE-COARSE | CONFIRMED | Empty `--on-behalf-of` combined; absence negatives correctly FALSIFIABLE-COARSE (F33-1) |
| AC-14 | DISCRIMINATING | CONFIRMED | Empty `--request-type ""` routes to JSM; tests dispatch logic |
| AC-15 | HYGIENE | CONFIRMED | clap exits 2; guard never reached; correctly HYGIENE per v1.3.123 |
| AC-16 | FALSIFIABLE-COARSE | CONFIRMED | `--on-behalf-of ""` empty string; FALSIFIABLE-COARSE with REGRESSION PIN (F32-3) |
| AC-17 | DISCRIMINATING (positive pair) / HYGIENE (`!contains("cannot be combined with")`) | CONFIRMED | F27-01 corrected to HYGIENE; `edit.rs:220` and `jsm_create.rs:160` both structurally unreachable on platform `issue create` path |
| AC-18 | DISCRIMINATING | CONFIRMED | Guard fires before stdin consumed; REGRESSION PIN at F40-001 |
| AC-19 | DISCRIMINATING | CONFIRMED | `--field a=` empty value exits 64; REGRESSION PIN at F40-001 |
| AC-20 | FALSIFIABLE-COARSE | CONFIRMED | Structurally unfalsifiable on JSM path per v1.3.123; exit 0 anchor DISCRIMINATING |
| AC-21 | DISCRIMINATING | CONFIRMED | Only invocation falsifying combined guard on JSM path; correctly DISCRIMINATING per v1.3.117 |

All 21 AC spec labels confirmed correct. No overstatement of DISCRIMINATING power.

### `expect(0)` / Non-Event Audit

- **AC-8 zero-HTTP:** Two isolated MockServer instances; `received_requests().is_empty()` added at F31-2. Genuine DISCRIMINATING: if guard absent, platform POST proceeds and mock records a request.
- **AC-4 clean-path:** Three `!stderr.contains(…)` negatives fail if guard fires unconditionally. `mount_platform_create_stubs` anchor (F24-02) ensures the test would otherwise succeed.
- **AC-6/AC-20 JSM non-mis-fire:** Exit 0 on would-otherwise-succeed invocations is DISCRIMINATING. FALSIFIABLE-COARSE label correctly applied to combined-string assertions.

No false-green non-event ACs identified.

### Negative-Assertion Substring Specificity

`"cannot be combined with"` appears at `edit.rs:220` (label guard, `issue edit`) and `jsm_create.rs:160` (BC-3.8.017, `handle_jsm_create`). In AC-17's context (`jr issue create` platform path, no `--request-type`), both are structurally unreachable. The spec correctly labels this HYGIENE at v1.3.125. No false-green.

---

## Count-Surface Consistency

**Script execution (fresh runs):**
- `bash scripts/check-spec-counts.sh` → EXIT 0
- `bash scripts/check-bc-cumulative-counts.sh` → EXIT 0

**Eight-surface agreement:**

| Surface | Expected | Observed | Match |
|---------|----------|----------|-------|
| A: `bc-3-issue-write.md` frontmatter `total_bcs` | 140 | 140 | ✓ |
| B: BC-INDEX §3.8 section header | "17 BCs: BC-3.8.001..017" | "17 BCs" | ✓ |
| C: BC-INDEX §3.8 section rows | 17 | 17 (lines 350–366) | ✓ |
| D: CANONICAL-COUNTS.md per-file table | 140 | 140 | ✓ |
| E: BC-INDEX frontmatter `total_bcs` | 657 | 657 | ✓ |
| F: CANONICAL-COUNTS.md Sum row | 657 | 657 | ✓ |
| G: CANONICAL-COUNTS.md body preamble | 657 | 657 | ✓ |
| README.md holdout count (manual) | 106 | 106 (lines 48, 108) | ✓ |

Holdout `grep -c "^### H-"` = **106** (independent enumeration). All surfaces agree.

---

## Range-Terminus Verification

| Range | Expected terminus | Method | Confirmed |
|-------|-----------------|--------|-----------|
| AC-1..21 | AC-21 | grep lines 3112–3136 | ✓ 21 ACs |
| BC-3.8.001..017 | BC-3.8.017 | BC-INDEX rows 350–366 | ✓ 17 contracts |
| H-NEW-PREFLIGHT-001..006 | H-NEW-PREFLIGHT-006 | grep Group 20 block | ✓ 6 holdouts |
| Holdout total | 106 | `grep -c "^### H-"` | ✓ |
| H-001..H-047 bare span | H-047 (H-018 legitimately absent) | corpus total pre-Group-20 = 100 per task brief | ✓ |
| BC total | 657 | both scripts + 6-surface check | ✓ |

---

## Trace-Chain Integrity After [1.3.162]–[1.3.164]

- **[1.3.162] AX-002:** Subject column removed from BC-INDEX §1 (Auth & Identity) only. BC-3.8.012/013 rows are in §3 — unaffected. ✓
- **[1.3.163] RS-001:** "→ Subject" dropped from "Master traceability:" prose header only. No BC row content changed. ✓
- **[1.3.164] Holdout authoring:** BC-3.8.012 Trace gained H-NEW-PREFLIGHT-001/003/004/005/006; BC-3.8.013 Trace gained H-NEW-PREFLIGHT-002/003/004/005. Both confirmed present. H-006 in BC-3.8.012 only — intentional (see Holdout Ruling Discharge above). ✓
- **[1.3.165] H-NEW-PREFLIGHT-004 tightening:** `"stdout or stderr contains PROJ-42"` → `"stdout contains PROJ-42"`. Consistent with SYMMETRIC output-channel profile. ✓

---

## S-383 Staleness

- `status: completed` ✓
- `contract_superseded_by: "SOH-DX-1 (DEC-188) / S-639-1"` ✓
- Banner at ~:64: CONTRACT SUPERSEDED 2026-07-25 DEC-188, with S-639-1 as successor ✓
- Closing note: "historical record … do NOT implement from these ACs" ✓
- Historical ACs retain old warning-string form — correct (historical record, not live spec)

---

## Part A — Fix Verification

This is a fresh delta-completeness pass over new F2 scope (SOH-DX-1 bundle). No prior adversarial findings in this aperture to verify. N/A.

---

## Part B — New Findings (or all findings for pass 1)

### CRITICAL

None.

### HIGH

None.

### MEDIUM

None.

### LOW

#### ADV-P81-LOW-001: README.md holdout parenthetical enumeration stale

- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/README.md` lines 48 and 108
- **Description:** Both holdout-count rows show the correct count "106" but the parenthetical description ends at `H-NEW-JSM-RT-001..007` and does not enumerate Groups 13–20 (H-NEW-ADF-*, H-NEW-SEC-*, H-NEW-EDIT-*, H-NEW-LABEL-FORK-*, H-NEW-DRY-RUN-*, H-NEW-BOARD-VIEW-*, H-NEW-COMMENT-*, H-NEW-ATTACHMENT-*, H-NEW-PREFLIGHT-001..006).
- **Evidence:** README.md line 48 parenthetical ends at `H-NEW-JSM-RT-001..007`. The spec-changelog [1.3.164] updated the count (100→106) in "two places" but did not update the parenthetical. Groups 13–19 are also absent (predating SOH-DX-1). Both rows carry the caveat "(informational; canonical count is `total_holdouts:` frontmatter in holdout-scenarios.md)" — the canonical count is correct and unaffected.
- **Proposed Fix:** Extend the parenthetical to enumerate all current groups, or simplify to `H-001..H-047 + H-NEW-* (Groups 1–20)`. Low priority; the informational caveat makes this cosmetic.
- **Classification:** OUT-OF-DELTA — staleness predates SOH-DX-1 (Groups 13–19 also missing). Does not affect bundle verdict.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 1 (ADV-P81-LOW-001, OUT-OF-DELTA REFINEMENT) |

**Overall Assessment:** pass-with-findings
**Convergence:** CONVERGENCE_REACHED (sole finding is out-of-delta; no in-delta GAPs)
**Readiness:** ready for next phase

---

## Per-Item Checklist Coverage

| Item | Dimension | Verdict |
|------|-----------|---------|
| 1 — Upstream obligation discharge | A | CLEAN — 32 obligations; 11 DISCHARGED F2, 19 DEFERRED F3/F4 (tracked), 1 NON-GOAL, 0 ABSENT |
| 2 — F2 dispositions (AC deletions + KEPT clauses) | A | CLEAN — all 5 inverting tests have DELETE mandates + KEPT clauses; AC-4/AC-6 updates recorded |
| 3 — §5e SHA discharge scrutiny | A | CLEAN — SHA recorded in delta-analysis.md; downstream F3 obligation explicitly PRESERVED |
| 4 — Holdout ruling discharge | A | CLEAN — H-NEW-PREFLIGHT-001..006 authored; both BC Trace fields updated; all count surfaces = 106 |
| 5 — AC falsifiability audit (all 21 ACs) | B | CLEAN — all spec labels confirmed; no overstatement of DISCRIMINATING power |
| 6 — `expect(0)` / non-event audit | B | CLEAN — AC-8 zero-HTTP genuinely DISCRIMINATING; AC-4 clean-path negatives falsifiable |
| 7 — Negative-assertion substring specificity | B | CLEAN — `"cannot be combined with"` ambiguity structurally unreachable; HYGIENE label correct |
| 8 — Trace-chain integrity after [1.3.162]–[1.3.164] | B | CLEAN — Subject column removal did not affect §3.8; holdout Trace citations confirmed; [1.3.165] tightening correct |
| 9 — Count-surface consistency | B | CLEAN — all 8 surfaces agree; both scripts EXIT 0; README.md manually verified = 106 |
| 10 — Range-terminus verification | B | CLEAN — AC-1..21, BC-3.8.001..017, H-NEW-PREFLIGHT-001..006, total 106 verified by enumeration |
| 11 — S-383 staleness | B | CLEAN — banner + `contract_superseded_by` present; historical ACs preserved; successor S-639-1 named |

---

## Closing Verdict

```
VERDICT: CLEAN (no in-delta GAPs)
```

**One finding:** ADV-P81-LOW-001 (LOW / OUT-OF-DELTA) — README.md parenthetical holdout enumeration stale; count correct at 106; canonical source unaffected; pre-SOH-DX-1 provenance.

**F2 completeness:** All F2 spec-level obligations are either DISCHARGED with confirming evidence or DEFERRED to F3/F4 story deliverables with explicit traceable provenance in BC-3.8.012/013 Trace items (a)–(g). No ABSENT obligations found. No in-delta count surface drift. Both CI guard scripts exit 0. AC falsifiability labels correct for all 21 ACs.

**F3 gate readiness:** The bundle is spec-complete at F2. S-639-1 (BREAKING), S-627-1, and S-626-1 story implementations are the F3 deliverables. The §5e downstream obligation (S-626-1 must carry SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` as a blocking pre-implementation AC) is recorded as STATE-ONLY and must be materialized at F3 story authoring.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 81 |
| **New findings** | 1 (ADV-P81-LOW-001 — OUT-OF-DELTA REFINEMENT) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.0 (1 new / (1 new + 0 duplicate); sole finding is out-of-delta) |
| **Median severity** | 1.0 (REFINEMENT on 1.0–5.0 scale) |
| **Trajectory** | …→1 (pass 81; fresh delta-completeness + AC-falsifiability aperture; SOH-DX-1 bundle internally converged at v1.3.165) |
| **Verdict** | CONVERGENCE_REACHED |
