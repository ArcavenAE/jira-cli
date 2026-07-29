---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: 2026-07-29T00:00:00
phase: F2
inputs:
  - .factory/specs/prd/holdout-scenarios.md
  - .factory/specs/prd/bc-3-issue-write.md
  - .factory/specs/prd/error-taxonomy.md
  - .factory/spec-changelog.md
input-hash: "d839f76"
traces_to: .factory/specs/prd/holdout-scenarios.md
pass: 82
previous_review: null
# Additional context fields
cycle: cycle-001
bundle: SOH-DX-1
aperture: holdout-falsifiability + channel-correctness
spec_version: v1.3.166
date: 2026-07-29
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
---

# Adversarial Review: jira-cli (Pass 82)

## Aperture

Adversarial verification of Group 20 (H-NEW-PREFLIGHT-001..H-NEW-PREFLIGHT-006) at spec v1.3.166. Six MUST-PASS scenarios covering the BC-3.8.012 / BC-3.8.013 pre-flight guards introduced by #639 / DEC-188: `--field` and `--on-behalf-of` exit 64 before any HTTP when used without `--request-type` on the platform create path. Focus: (1) would each scenario FAIL against the CURRENT (pre-implementation) build, (2) can each scenario PASS against a CORRECT implementation, (3) channel-correctness with emit-site citations, (4) verification of the [1.3.166] CRITICAL correction to H-NEW-PREFLIGHT-004.

## Perimeter

Files read:

- `.factory/specs/prd/holdout-scenarios.md` (Group 20 lines 2573–2762; frontmatter)
- `.factory/specs/prd/bc-3-issue-write.md` (BC-3.8.012, BC-3.8.013 via grep + changelog trace)
- `.factory/specs/prd/error-taxonomy.md` (Section 6 Issue Commands, lines 186–194)
- `.factory/specs/prd/CANONICAL-COUNTS.md` (holdout count verification)
- `.factory/specs/prd/README.md` (two holdout sites, lines 48 and 108)
- `.factory/spec-changelog.md` ([1.3.164], [1.3.165], [1.3.166])
- `src/cli/issue/create.rs` (full file — guard sites, platform create logic, output arms)
- `src/cli/issue/jsm_create.rs` (lines 1–415 — JSM routing, JSON output path at line 361)
- `src/output.rs` (full file — `print_success` emit site at line 46)
- `src/main.rs` (lines 120–160 — error rendering, JSON envelope at lines 133–140)
- `src/error.rs` (`UserError` exit_code = 64, line 94)
- `tests/issue_create_echo.rs` (BC-3.4.014 four-site `stdout.is_empty()` assertions)

## Isolation

No files from `.factory/cycles/cycle-001/adversarial-reviews/`, `.factory/cycles/cycle-001/convergence-trajectory.md`, or `.factory/STATE.md` were read. All verdicts are reached from spec + code alone.

---

## Falsifiability Table (Items 1 + 2)

| Scenario | Would FAIL against current build? | Could PASS against correct implementation? | Notes |
|----------|-----------------------------------|--------------------------------------------|-------|
| H-NEW-PREFLIGHT-001 | **YES** | **YES** | Current: warn + proceed, exit 0, POST called. Scenario expects exit 64, no POST. Both assertions independently fail. |
| H-NEW-PREFLIGHT-002 | **YES** | **YES** | Symmetric to 001 for `--on-behalf-of`. Same reasoning. |
| H-NEW-PREFLIGHT-003 | **YES** | **YES** | Current: two independent warnings + proceed, exit 0, POST called. Scenario expects exit 64, combined error, no POST. |
| H-NEW-PREFLIGHT-004 | **NO** (regression pin) | **YES** | Clean-path regression pin. Current behavior already satisfies all assertions. Against a WRONG unconditional guard: exit-0 and POST-called-once fail independently — non-vacuous. |
| H-NEW-PREFLIGHT-005 | **NO** (non-mis-fire pin) | **YES** | JSM routing fork at `create.rs` ~:49 fires before guard sites ~:81/86 — no guard today. Against a WRONG unconditional guard: exit-0 and `.expect(1)` on JSM POST fail — non-vacuous. |
| H-NEW-PREFLIGHT-006 | **YES** | **YES** | Current: warn + proceed, exit 0, stdout has created-issue JSON. Scenario expects exit 64, empty stdout, JSON envelope on stderr. |

**On H-004 and H-005 not failing against current:** Both are intentional regression/non-mis-fire pins. Their non-event assertions are genuinely non-vacuous (each fails against the corresponding wrong implementation). "Why hidden" sections in both scenarios document the falsification target explicitly.

---

## Channel-Audit Table (Item 3)

| Scenario | Assertion | Claimed channel | Emit site | Correct? |
|----------|-----------|-----------------|-----------|----------|
| 001 | stderr contains single-flag `--field` error | stderr | `src/main.rs` ~:143 human-mode arm: `eprintln!("Error: {e}")` | YES |
| 001 | stderr does NOT contain old warn string | stderr | Absence check | YES |
| 001 | stdout is empty | stdout | No `println!` on Err path in `main.rs` | YES |
| 002 | stderr contains single-flag `--on-behalf-of` error | stderr | `src/main.rs` ~:143 | YES |
| 002 | stdout is empty | stdout | Same as 001 | YES |
| 003 | stderr contains combined error | stderr | `src/main.rs` ~:143 | YES |
| 003 | stderr does NOT contain single-flag-001/002/old-warn strings | stderr | Absence checks; correct channel | YES |
| 003 | stdout is empty | stdout | Same as 001 | YES |
| 004 | **stderr** contains "Created issue PROJ-42" | **stderr** | `src/output.rs::print_success` line 46: `eprintln!("{}", msg.green())`. Called at `create.rs::handle_create` ~:272 (Table arm). **The [1.3.166] correction.** | YES (corrected) |
| 004 | `stdout.trim().is_empty()` | stdout | Table arm (~:269–277): only `print_success` + field-echo `eprintln!` calls; no `println!` | YES |
| 004 | stderr does NOT contain guard strings | stderr | Guard absent on clean path | YES |
| 005 | **stdout** contains "HELP-1" | **stdout** | `src/cli/issue/jsm_create.rs` line 361: `println!("{}", output::render_json(&serde_json::json!({"key": issue_key}))?)` — JSON mode writes `{"key":"HELP-1"}` to stdout via `println!` | YES |
| 005 | stderr does NOT contain any guard string | stderr | Guard not reached; routing fork at `create.rs` ~:49 dispatches to `jsm_create` before guard sites | YES |
| 006 | `stdout.trim().is_empty()` | stdout | No `println!` on Err path in `main.rs`; discriminating: guard-absent would write created-issue JSON to stdout | YES |
| 006 | stderr has JSON envelope | **stderr** | `src/main.rs` ~:134–140 JSON arm: `eprintln!("{}", serde_json::json!({"error": e.to_string(), "code": exit_code}))` | YES |
| 006 | `"error"` field contains guard string | — | `e.to_string()` = raw `JrError::UserError` message (no "Error: " prefix in JSON mode; prefix added only in human arm ~:143) | YES |
| 006 | `"code"` = 64 | — | `JrError::UserError` exit_code = 64 (`src/error.rs` line 94, tested line 113) | YES |

**No positive two-channel assertions in Group 20.** The [1.3.165] incorrect "stdout or stderr" assertion was corrected by [1.3.166]. All two-channel assertions in Group 20 are negative — legitimate.

---

## Checklist Coverage (Items 4–12)

**Item 4 — [1.3.166] correction:** Correct and complete. `src/output.rs::print_success` line 46 is `eprintln!` (stderr). `create.rs` Table arm (~:269–277) has no `println!` — stdout is empty. `tests/issue_create_echo.rs` has four `stdout.is_empty()` assertions under BC-3.4.014. H-004 falsifiability intact: a wrong unconditional-guard implementation exits 64 → exit-0 assertion fails; POST not called → POST-called-once assertion fails. Both assertions carry falsification independently. Changelog records the regression honestly: [1.3.166] names the defect, its source (profile-4 reasoning over-generalized from attachment upload to issue create), its impact (permanently unsatisfiable MUST-PASS), and the correction.

**Item 5 — Fixture coherence:** H-001/002/003: zero HTTP before the guard; POST with `.expect(0)` is the decisive proof. H-004: Table mode never executes the follow-up GET (JSON arm only); GET stub harmless (no `.expect()`). H-005: servicedeskapi stubs sufficient; `jsm_create.rs` JSON path emits `{"key":…}` directly (line 361) with no follow-up GET; `--field priority=High` and `--on-behalf-of` are passed directly to `JsmRequestBuilder` without HTTP validation. H-006: guard fires before POST; pre-migrated config note correctly prevents migration-line stderr contamination.

**Item 6 — Verbatim error-string fidelity:** All three strings verified against `error-taxonomy.md` Section 6 lines 192–194. Exact match in all cases.

**Item 7 — Information asymmetry:** One REFINEMENT (ADV-P82-LOW-001): H-004 Expected bullet 3 contains parenthetical source citations. Behavioral assertion itself is correct and purely observable.

**Item 8 — Non-vacuity:** H-004: "exit 0" and "POST called once" fail against an unconditional-guard implementation. H-005: "exit 0" and `.expect(1)` on JSM POST fail against a mis-firing guard. All non-event assertions are non-vacuous.

**Item 9 — Substring specificity:** H-003 negative substrings: `"--field is only valid"` does not appear in combined `"--field and --on-behalf-of are only valid"` (combined uses "and" + "are", single-flag uses "is"); `"--on-behalf-of is only valid"` does not appear in combined `"--on-behalf-of are only valid"`. Verified non-overlapping. "cannot be combined with" trap not applicable — absent from all Group 20 error strings.

**Item 10 — Coverage completeness:** Six cases covered: `--field` alone, `--on-behalf-of` alone, both, neither (regression pin), JSM path (non-mis-fire pin), `--output json` mode. Minor uncovered ECs (multiple `--field`, malformed `--field`, `--on-behalf-of` + `--output json`) are covered by ACs in bc-3-issue-write.md. No CRITICAL gap.

**Item 11 — Exclusion soundness:** #627 (guard-script regex + prose revert) and #626 (SHA pins + MSRV resolution order) change no `jr` binary CLI behavior. Both exclusions are sound.

**Item 12 — Counts:** `grep -c '^### H-'` = 106. Frontmatter = 106. H-018 absent (confirmed). CANONICAL-COUNTS.md = 106 with full enumeration including H-NEW-PREFLIGHT-001..006. H-NEW-PREFLIGHT range maxima verified by enumeration: 001–006 (no 007). README.md enumeration stale at both sites (see ADV-P82-LOW-002); count (106) is correct and authoritative.

---

## Finding ID Convention

Finding IDs use the format `ADV-P<PASS>-<SEV>-<SEQ>` (no cycle prefix: `current-cycle` file absent).

---

## Part A — Fix Verification

Not applicable: pass 82 is the first adversarial review pass on the holdout-falsifiability + channel-correctness aperture for Group 20 (H-NEW-PREFLIGHT-001..006). No prior findings on this aperture to verify.

---

## Part B — New Findings

### CRITICAL

None.

### HIGH

None.

### MEDIUM

None.

### LOW

#### ADV-P82-LOW-001: H-004 Expected bullet contains source-code citations (information asymmetry)

- **Severity:** LOW
- **Classification:** REFINEMENT
- **Delta attribution:** IN-DELTA (introduced by v1.3.166, 2026-07-29)
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/holdout-scenarios.md` line 2684 — H-NEW-PREFLIGHT-004 Expected bullet 3
- **Description:** The Expected bullet reads (abbreviated): _"stderr contains 'Created issue PROJ-42' (Table-mode `print_success` → `eprintln!` → stderr; `src/output.rs::print_success` and `src/cli/issue/create.rs::handle_create`)."_ The parenthetical contains function names and file paths inside the Expected (observable assertion) section. Per aperture item 7, implementation detail in Expected is a defect.
- **Evidence:** The behavioral assertion ("stderr contains 'Created issue PROJ-42'") is correct and purely observable. The citation (`src/output.rs::print_success`, `src/cli/issue/create.rs::handle_create`, `tests/issue_create_echo.rs`) is explanatory — it tells evaluators WHERE to look in source, but evaluators without source access cannot exploit this. Zero impact on testability.
- **Proposed Fix:** Move the parenthetical citation to the "Why hidden" section. Retain only "stderr contains 'Created issue PROJ-42'" in Expected.

---

#### ADV-P82-LOW-002: README.md holdout enumeration stale at both sites

- **Severity:** LOW
- **Classification:** REFINEMENT
- **Delta attribution:** Compounded IN-DELTA ([1.3.164] updated count 100→106 but did not update enumeration); underlying drift is OUT-OF-DELTA (stale since Groups 8b/9 were added without updating README)
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/README.md` line 48 (Document Map) and line 108 (Supplement Index)
- **Description:** Both sites show count 106 (correct) but enumeration "H-001..H-047 + H-NEW-MP-001 + H-NEW-VERBOSE-001/002 + H-NEW-AUTH-002 + H-NEW-JSM-RT-001..007" — missing Groups 8b through 20 (12 later groups). [1.3.164] updated the count at both sites but not the enumeration description.
- **Evidence:** CANONICAL-COUNTS.md line 111 and line 115 show the full correct enumeration through H-NEW-PREFLIGHT-001..006. Both README sites self-disclaim "(informational; canonical count is `total_holdouts:` frontmatter in holdout-scenarios.md)." Count is authoritative and correct. No CI guard protects README enumeration.
- **Proposed Fix:** Update both README enumeration descriptions to match CANONICAL-COUNTS.md §Expected. Apply as a housekeeping PATCH alongside the next delta touching README.md.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 2 |

**Overall Assessment:** pass-with-findings
**Convergence:** CONVERGENCE_REACHED (zero in-delta GAPs; two LOW REFINEMENTs only)
**Readiness:** ready for next phase

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 82 |
| **New findings** | 2 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.00 (2/2 — first pass on this aperture) |
| **Median severity** | 1.5 (LOW) |
| **Trajectory** | first pass on Group 20 holdout-falsifiability aperture |
| **Verdict** | CONVERGENCE_REACHED |

---

**VERDICT: CLEAN (no in-delta GAPs)**
