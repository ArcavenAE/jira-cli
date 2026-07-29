---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: 2026-07-29T00:00:00
phase: F2
inputs:
  - prd/bc-3-issue-write.md
  - prd/holdout-scenarios.md
  - prd/error-taxonomy.md
  - prd/CANONICAL-COUNTS.md
  - prd/README.md
  - src/cli/issue/create.rs
  - src/output.rs
  - tests/issue_create_echo.rs
input-hash: "bf09759"
traces_to: bc-3-issue-write.md
pass: 79
previous_review: soh-dx-1-f2-pass-78.md
cycle: cycle-001
bundle: SOH-DX-1
aperture: holdout-scenario-quality
spec_version: v1.3.165
date: 2026-07-29
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
---

# Adversarial Review — SOH-DX-1 F2, Pass 79
## Aperture: Holdout Scenario Quality — Group 20 (H-NEW-PREFLIGHT-001..006)

Six new holdout scenarios covering issue #639 (BREAKING: `jr issue create --field`
and `--on-behalf-of` without `--request-type` flip from warn-and-proceed to pre-flight exit 64).
Reviewed against spec v1.3.165, error-taxonomy.md, `src/cli/issue/create.rs`, `src/output.rs`,
and `tests/issue_create_echo.rs`. No sibling adversarial-review files read.

---

## Finding ID Convention

Finding IDs for this pass: `ADV-C001-P79-<SEV>-<SEQ>` (cycle-001, pass 79).

One CRITICAL in-delta GAP was found (P79-001). Three additional observations are refinements
or informational. The checklist sections below record evidence supporting each verdict.

---

## Perimeter (Files Actually Read)

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/holdout-scenarios.md` — PRIMARY (Group 20, H-NEW-PREFLIGHT-001..006; also H-NEW-ATTACHMENT-* and H-NEW-COMMENT-* for house-style benchmarking)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-3-issue-write.md` — BC-3.8.012 and BC-3.8.013 bodies (current behavior, error strings, EC entries, guard ordering)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/error-taxonomy.md` — Section 6 DEC-188 pre-flight error strings and exit codes
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/CANONICAL-COUNTS.md` — holdout count verification (106)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/README.md` — holdout count (106) at two sites
- `/Users/zious/Documents/GITHUB/jira-cli/src/cli/issue/create.rs` — current implementation (warns and proceeds; guard not yet present)
- `/Users/zious/Documents/GITHUB/jira-cli/src/cli/issue/jsm_create.rs` — JSM path for H-NEW-PREFLIGHT-005 fixture coherence verification
- `/Users/zious/Documents/GITHUB/jira-cli/src/output.rs` — `print_success` output channel (`eprintln!` → stderr)
- `/Users/zious/Documents/GITHUB/jira-cli/tests/issue_create_echo.rs` — BC-3.4.014 tests confirming Table-mode stdout is empty and "Created issue" goes to stderr

---

## Per-Scenario: Would-Fail Against Current Build

Current `src/cli/issue/create.rs` (lines 78–90) warns via `eprintln!` and proceeds
(exit 0, POST called). The guard implementing exit 64 pre-flight is NOT yet present.
`src/output.rs::print_success` uses `eprintln!`, so Table-mode success messages go to **stderr**, not stdout.

| Scenario | Fails Against Current? | Decisive assertion(s) |
|---|---|---|
| H-NEW-PREFLIGHT-001 | FAIL-CORRECT | Exit code = 64 fails (current exits 0); POST called violates `.expect(0)` |
| H-NEW-PREFLIGHT-002 | FAIL-CORRECT | Exit code = 64 fails (current exits 0); POST called violates `.expect(0)` |
| H-NEW-PREFLIGHT-003 | FAIL-CORRECT | Exit code = 64 fails (current exits 0); POST called violates `.expect(0)` |
| H-NEW-PREFLIGHT-004 | FAIL-DEFECT | "stdout contains PROJ-42" fails against BOTH current AND future binary — Table mode `print_success` → `eprintln!` → stderr; stdout is empty (see ADV-C001-P79-CRITICAL-001) |
| H-NEW-PREFLIGHT-005 | PASS | JSM path unchanged; all guard strings absent from current code; mocks support JSM flow end-to-end |
| H-NEW-PREFLIGHT-006 | FAIL-CORRECT | Exit code = 64 fails (current exits 0); stdout not empty (JSON success written to stdout) |

---

## Checklist Coverage

### Item 1 — Decisive Falsifiability Test

001, 002, 003, 006: Each asserts exit code = 64 + zero HTTP (`.expect(0)`). Current binary
exits 0 and calls POST. Both fail independently. Falsifiable. ✓

004: See ADV-C001-P79-CRITICAL-001. The scenario is the BREAKING-CHANGE REGRESSION PIN. Exit
code = 0 and POST-called assertions are non-vacuous (an unconditionally-firing guard fails
both). However, "stdout contains PROJ-42" fails against both current and correct-future binary
because `print_success` → `eprintln!` → stderr. The broken channel assertion makes the scenario
non-passable at Phase 4, which is worse than not testing the case at all.

005: Passes against current binary (expected for a JSM non-mis-fire regression pin). Guards
absent from current code; JSM path mocks complete. ✓

### Item 2 — Fixture Coherence

001, 002, 003: Only `POST /rest/api/3/issue` with `.expect(0)` mounted. With guard present,
zero HTTP issued; no other mocks needed. Correct. ✓

004: `POST /rest/api/3/issue` → 201 with `{"key":"PROJ-42"}` and
`GET /rest/api/3/issue/PROJ-42` → 200. GET mock is unreachable in Table mode (only JSON path
calls GET). Unmounted `.expect()` does not fail on zero calls. POST correctly supports the flow. ✓

005: Three mocks: servicedesk GET → HELP (id=1), requesttype GET → "General Request" (id=10),
servicedeskapi POST → 201 HELP-1. `handle_jsm_create` steps 4, 6, 9 are all mocked. No CMDB
or supplemental calls fire on the JSM path. `.expect(1)` on POST is correctly placed. ✓

006: Only `POST /rest/api/3/issue` with `.expect(0)`. Pre-migrated config requirement prevents
config-migration stderr from contaminating the JSON parse assertion. ✓

### Item 3 — Verbatim Error-String Fidelity

Checked against `error-taxonomy.md §6` DEC-188 table and BC-3.8.012/013 fenced blocks:

- 001: exact match to error-taxonomy.md row 1 ✓
- 002: exact match to error-taxonomy.md row 2 ✓
- 003: exact match to error-taxonomy.md row 3 ✓
- 006: contains-check substring of row-1 string; appropriate for JSON envelope ✓

No drift, paraphrase, or truncation found.

### Item 4 — Information Asymmetry

Setup/Action/Expected sections do not leak internal function names, file paths, or
control-flow descriptions. Negative assertions reference user-visible CLI strings only. Status
and BC refs carry Rust type names (`JrError::UserError`) as metadata, consistent with the
H-NEW-ATTACHMENT-* and H-NEW-COMMENT-* house style. "Why hidden" sections are marked hidden. ✓

### Item 5 — Non-vacuity of Non-Event Assertions

004: "POST called exactly once" and "exit code = 0" are non-vacuous: an unconditionally-firing
guard fails both. Two absent-guard-string assertions are non-vacuous (unconditional guard would
emit the string even without the flag). The "stdout contains PROJ-42" assertion is vacuous in
the wrong direction — it always fails; see ADV-C001-P79-CRITICAL-001.

005: Three absent-guard-string assertions are independently discriminating (invocation carries
both `--field` and `--on-behalf-of`; a guard mis-firing on the JSM path would emit one). The
`.expect(1)` POST assertion is non-vacuous. ✓

### Item 6 — Negative-Assertion Substring Specificity

- `"--field is only valid with --request-type"` vs combined `"--field and --on-behalf-of are only valid"`: non-overlapping on `"is only"` vs `"are only"`. ✓
- `"--on-behalf-of is only valid with --request-type"` vs combined: non-overlapping on `"is only"` vs `"are only"`. ✓
- `"is ignored on the platform create path"`: present in old warning; absent from all new guard strings. ✓
- `"cannot be combined with"` trap (BC-3.8.017 / issue-#396 label guard): not used in any PREFLIGHT assertion. ✓

### Item 7 — Output-Channel Correctness

001, 002, 003: Error path; assertions use `stderr.contains(...)` and `stdout.trim().is_empty()`. Correct for human-mode errors. ✓

004: See ADV-C001-P79-CRITICAL-001. Action has no `--output json`. Table-mode `print_success` → `eprintln!` → stderr. Assertion "stdout contains PROJ-42" is wrong channel. DEFECT.

005: `--output json`. JSM JSON output via `println!` → stdout. "stdout contains HELP-1" correct. ✓

006: `--output json` error path. JSON envelope to stderr. `stdout.trim().is_empty()` correct. ✓

### Item 8 — MUST-PASS Designation

All six scenarios carry `(MUST-PASS)`. Task brief stated "three of the six"; actual authoring
tagged all six. Having all six MUST-PASS is defensible for 001–003, 005–006. For 004 the
MUST-PASS designation amplifies the impact of ADV-C001-P79-CRITICAL-001: a broken MUST-PASS
permanently depresses the `must-pass ≥ 0.6` gate threshold. See P79-002 (INFO).

### Item 9 — Coverage Completeness

| Case | Scenario | Status |
|---|---|---|
| `--field` alone → exit 64 | H-NEW-PREFLIGHT-001 | COVERED ✓ |
| `--on-behalf-of` alone → exit 64 | H-NEW-PREFLIGHT-002 | COVERED ✓ |
| Both flags → ONE combined error | H-NEW-PREFLIGHT-003 | COVERED ✓ |
| Neither flag → platform create normal | H-NEW-PREFLIGHT-004 | COVERED (broken assertion — see ADV-C001-P79-CRITICAL-001) |
| Either/both flags WITH `--request-type` → JSM non-mis-fire | H-NEW-PREFLIGHT-005 | COVERED ✓ |
| `--field` without `--request-type`, `--output json` | H-NEW-PREFLIGHT-006 | COVERED ✓ |
| Malformed `--field` (no `=`) on platform path → guard fires (NOT BC-3.8.008 error) | — | GAP (see P79-003) |
| `--on-behalf-of` `--output json` error envelope | — | UNCOVERED |
| Interactive TTY mode on platform guard | — | UNCOVERED (AC-level only; acceptable) |

### Item 10 — Exclusion Soundness

Issue #627 (guard-script regex fix + prose revert): CI scripts and spec prose only; no `jr`
binary behavior change. Exclusion CORRECT. ✓

Issue #626 (SHA pins + MSRV resolution order): `Cargo.lock` SHA pins and toolchain settings;
no user-observable CLI behavior change. Exclusion CORRECT. ✓

### Item 11 — Count Arithmetic

All three authoritative sites agree: `total_holdouts: 106` (frontmatter) = "106" (CANONICAL-COUNTS.md line 111) = "106" (README.md lines 48 and 108).

Independent count: `grep -c '^### H-' holdout-scenarios.md` = **106** ✓

Distribution: H-001..H-047 (H-018 absent=46) + H-NEW-MP-001 + H-NEW-VERBOSE-001/002 + H-NEW-AUTH-002 + H-NEW-JSM-RT-001..007 + H-CITE-001..003 + H-NEW-ADF-001..010 + H-NEW-SEC-001..002 + H-NEW-EDIT-FIELD/TYPE-001..002 each + H-NEW-CHANGELOG-001 + H-NEW-WORKLOG-ADD-001 + H-NEW-LINK-001 + H-NEW-QUEUE-VIEW-001 + H-NEW-LABEL-FORK/DRY-RUN/BOARD-VIEW-001 each + H-NEW-COMMENT-001..005 + H-NEW-ATTACHMENT-001..012 + H-NEW-PREFLIGHT-001..006 = 106 ✓

H-018 absence confirmed by enumeration (heading shows H-017 → H-019; no H-018 heading found). ✓

README enumeration outdated (ends at H-NEW-JSM-RT-007); explicit "(informational)" qualifier present; see P79-004.

### Item 12 — Range-Terminus Verification

H-NEW-PREFLIGHT-001..006: six headings confirmed by enumeration via `grep -n "^### H-NEW-PREFLIGHT"` (001, 002, 003, 004, 005, 006 — no gap, no 007). Maximum = 6. ✓

H-018 absence confirmed by enumeration (item 11). ✓

---

## Part B — New Findings (or all findings for pass 1)

### ADV-C001-P79-CRITICAL-001

**ID**: ADV-C001-P79-CRITICAL-001
**Severity**: CRITICAL
**Classification**: GAP (verification gap — MUST-PASS scenario reliably fails at Phase 4; non-passable as written)
**Delta**: IN-DELTA (Group 20 authored 2026-07-29; SOH-DX-1 began 2026-07-25; factory files untracked, no git SHA)
**Location**: `holdout-scenarios.md` H-NEW-PREFLIGHT-004, Expected bullet 3

**Evidence**:
`src/output.rs::print_success` (line 45–47) uses `eprintln!` — writes to **stderr**:
```rust
pub fn print_success(msg: &str) {
    eprintln!("{}", msg.green());
}
```
`src/cli/issue/create.rs` Table path (line 272) calls `output::print_success(&format!("Created issue {}", response.key))` — "Created issue PROJ-42" goes to stderr.

`tests/issue_create_echo.rs` (BC-3.4.014, lines 188–197) independently confirms:
```
// stdout must be empty in table mode (all output on stderr)
assert!(stdout.is_empty(), ...)
assert!(stderr.contains("Created issue PROJ-1"), ...)
```

H-NEW-PREFLIGHT-004 Expected bullet 3 asserts: "stdout contains `PROJ-42`" with justification "profile 4: human echo goes to stdout." This is incorrect. Profile 4 routes JSON output to stdout; Table-mode success messages go to stderr via `print_success` → `eprintln!`. The precision fix (lineage P35-003/P36-001 referenced in the spec trace) correctly applied "stdout" to `--output json` scenarios, but H-NEW-PREFLIGHT-004 uses no `--output json` — it is Table mode.

**Impact**: H-NEW-PREFLIGHT-004 is MUST-PASS. The "stdout contains PROJ-42" assertion fails against both the current binary AND the correctly-implemented new binary. The evaluator cannot satisfy this assertion in Table mode regardless of guard implementation. This makes the scenario permanently FAILING, directly reducing the `must-pass ≥ 0.6` gate score.

**Remedy**: Change Expected bullet 3 from:
> stdout contains `"PROJ-42"` (the created issue key returned by the mock; profile 4: human echo goes to stdout)

to:
> stderr contains `"Created issue PROJ-42"` (Table-mode `print_success` → `eprintln!` → stderr; `stdout.trim().is_empty()` verifies stdout is empty in Table mode per BC-3.4.014)

---

### P79-002 (INFO)

**ID**: P79-002
**Severity**: INFO
**Classification**: INFO (task-brief discrepancy; no defect in scenarios)
**Delta**: IN-DELTA

All six scenarios carry `(MUST-PASS)`. Task brief stated "three of the six are tagged MUST-PASS." No scenario change needed; the task brief was inaccurate. Combined with ADV-C001-P79-CRITICAL-001, a broken MUST-PASS is more dangerous than a broken non-must-pass.

---

### P79-003 (LOW)

**ID**: P79-003
**Severity**: LOW
**Classification**: REFINEMENT (edge case explicitly documented in BC-3.8.012)
**Delta**: IN-DELTA

BC-3.8.012 states: "A malformed `--field` (e.g., `--field bareflagnoequals`) still triggers the single pre-flight error (presence of `--field` is sufficient; format validation per BC-3.8.008 applies only on the JSM path)." No PREFLIGHT scenario covers this case. A regression replacing the guard with `parse_field_kv` validation would produce a BC-3.8.008 error instead of the BC-3.8.012 guard string — undetected by current scenarios. Low priority; primary contract is covered by H-NEW-PREFLIGHT-001.

---

### P79-004 (LOW)

**ID**: P79-004
**Severity**: LOW
**Classification**: REFINEMENT (cosmetic; count is correct at all authoritative sites)
**Delta**: IN-DELTA

README.md lines 48 and 108 enumerate holdout scenarios only through H-NEW-JSM-RT-001..007, omitting Groups 13–20 (H-NEW-PREFLIGHT-001..006 and 25+ others). Both lines carry the explicit qualifier "(informational; canonical count is `total_holdouts:` frontmatter in holdout-scenarios.md)." Count (106) is correct. Low priority.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 1 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 2 |
| INFO | 1 |

**Overall Assessment:** fail
**Convergence:** FINDINGS_REMAIN
**Readiness:** blocked on ADV-C001-P79-CRITICAL-001 (H-NEW-PREFLIGHT-004 broken MUST-PASS assertion)

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 79 |
| **New findings** | 1 |
| **Duplicate/variant findings** | 3 |
| **Novelty score** | 0.25 (1 new / 4 total) |
| **Median severity** | LOW (P79-002 INFO, P79-003 LOW, P79-004 LOW; ADV-C001-P79-CRITICAL-001 is the sole new finding) |
| **Trajectory** | ↑1 (1 new in-delta GAP from Group 20 scenario quality; Group 20 is entirely new to this pass) |
| **Verdict** | FINDINGS_REMAIN |
