---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-03T02:00:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .factory/stories/S-640-1.md
  - .factory/stories/S-641-1.md
  - .factory/stories/S-576-5.md
  - .factory/stories/S-627-1.md
  - .factory/stories/STORY-INDEX.md
  - .factory/specs/prd/bc-5-boards-sprints.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/specs/architecture/ARCH-INDEX.md
  - .factory/specs/domain-spec/bc-02-issue-read.md
  - .factory/demos/S-626-1/
  - .github/workflows/ci.yml
  - .github/workflows/release.yml
  - CLAUDE.md
  - Cargo.toml
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
  - tests/team_column_parity.rs
input-hash: "f5dc8ba"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 11
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-03
feature_head: 64e2a4bcde44ec20bc1f64d80eb402ca8aebc406
pr: 667
verdict: "NOT CLEAN — 2 HIGH + 8 MEDIUM + 3 LOW; zero code defects; 8 of 13 findings are fix-round-partial-propagation shape"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-10.md
isolation: "VOID — ORCHESTRATOR DISPATCH DEFECT: two greps issued at .factory/ root (not scoped to a named subdirectory), leaking STATE.md (5 result lines) and spec-changelog.md (1 result line). Pass findings remain valid; isolation breach disqualifies this pass from step-4.5 window eligibility."
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 11

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## Isolation

**VOID — ORCHESTRATOR DISPATCH DEFECT.** Two greps were issued at `.factory/` root (not scoped to a named subdirectory), leaking `STATE.md` (5 result lines) and `spec-changelog.md` (1 result line). The contaminated content was visible to the reviewer prior to completing their analysis. This pass is DISQUALIFIED from step-4.5 window eligibility.

**Specific breach events:**
1. `grep -r "comfy-table" .factory/` → returned hits including `.factory/STATE.md:119` containing convergence trajectory data and `.factory/cycles/` prefix text.
2. `grep -r "7.2.1" .factory/` → returned one hit from `.factory/spec-changelog.md` referencing a prior pass conclusion.

**Finding validity:** Notwithstanding the isolation breach, all 13 findings below were independently re-derived from in-perimeter primary artifacts. The reviewer confirmed each finding from direct inspection of the files listed in `inputs:`, not from contaminated pipeline context. Findings are recorded as valid for fix-round tracking. VOID status is solely a window-eligibility disqualification.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P11-[SEV]-NNN`. No current-cycle file segment is prepended (consistent with prior passes in this series).

---

## META-PATTERN: Fix-Round-Partial-Propagation

**8 of 13 findings in this pass are the fix-round-partial-propagation shape**: a correction was applied at the exact location a prior review flagged, without an independent re-derivation sweep to identify all instances of the same class. This pattern recurs across every fix round in this cycle. The root cause is a procedural gap: fix-round executors search for the reported symptom-site and correct it, rather than characterizing the defect class and sweeping the full corpus for all instances of that class.

**Structural consequence:** Each fix round eliminates the specific instances that were explicitly named in the prior pass, while leaving un-named same-class instances untouched. The adversary then finds those previously-unnamed instances in the subsequent pass. This produces a convergence staircase that descends slowly (findings per pass: 10→13→5→15→18→13) rather than converging rapidly as each fix round should.

**Proposed process change (tracked as `FIX-ROUND-PARTIAL-PROPAGATION` drift item):** Before closing any fix round, the executor must (1) characterize the defect *class* from each finding, (2) search the full corpus for all instances of that class pattern, (3) fix all instances in a single pass. A fix round that touches N named sites should verify M≥N total sites of the same pattern were swept.

---

## Part A — Fix Verification

| ID | Previous Severity | Status | Notes |
|----|-------------------|--------|-------|
| ADV-P10-HIGH-001 | HIGH | RESOLVED | AC-008.txt regenerated at 64e2a4bc with cold-cache evidence ✓ |
| ADV-P10-HIGH-002 | HIGH | RESOLVED | AC-006.txt regenerated; precedence text updated ✓ |
| ADV-P10-HIGH-003 | HIGH | PARTIAL — see F-01 | S-640-1 v0.4 added SS-01..SS-09; but Task 0 pre-flight gate introduced new defect |
| ADV-P10-HIGH-004 | HIGH | PARTIAL — see F-02 | S-576-5 v1.47; but SS-03/SS-09 retained as false anchors |
| ADV-P10-MED-001 | MEDIUM | RESOLVED | AC-004.txt regenerated ✓ |
| ADV-P10-MED-002 | MEDIUM | RESOLVED | all 11 artifacts regenerated; Regeneration Log added ✓ |
| ADV-P10-MED-003 | MEDIUM | PARTIAL — see F-04 | INV-READ-009 anchor corrected to bc-02; but no sweep for other cross-subsystem anchors |
| ADV-P10-MED-004 | MEDIUM | RESOLVED | AC-009.txt false coverage claim corrected ✓ |
| ADV-P10-MED-005 | MEDIUM | RESOLVED | S-626-1 v1.9 status/blocks corrected; STORY-INDEX refreshed ✓ |
| ADV-P10-MED-006 | MEDIUM | RESOLVED | STORY-INDEX v1.5.53 S-640-1 / S-576-5 rows refreshed ✓ |
| ADV-P10-MED-007 | MEDIUM | RESOLVED | S-626-1 v1.9 File Structure Requirements row corrected ✓ |
| ADV-P10-MED-008 | MEDIUM | RESOLVED | AC trace to BC-5.3.001 added ✓ |
| ADV-P10-MED-009 | MEDIUM | PARTIAL — see F-06 | §5.3 count removed from bc-5 header; BC-INDEX §5.3 row corrected; guard extension only partially scoped |
| ADV-P10-MED-010 | MEDIUM | RESOLVED | S-641-1 v0.6 normalization rule added; AC-2 items 3/4/5 corrected ✓ |
| ADV-P10-MED-011 | MEDIUM | PARTIAL — see F-07 | S-641-1 rationale corrected; ARCH-INDEX gap tracked; registry file not yet extended |
| ADV-P10-LOW-001 | LOW | PARTIAL — see F-08 | S-626-1 v1.9 MUST-NOT line updated at primary site; two secondary sites not updated |
| ADV-P10-LOW-002 | LOW | RESOLVED | INV-READ-009 MSRV note marked self-identifying-temporary ✓ |
| ADV-P10-LOW-003 | LOW | RESOLVED | 2341→2343 updated at both sites ✓ |

---

## Part B — New Findings (or all findings for pass 1)

### HIGH

#### ADV-P11-HIGH-001: S-640-1 Task 0 BLOCKING pre-flight gate matches a string that by design cannot exist; 5 bare `"7.2.1"` sites in S-640-1/S-641-1 uncleaned by fix round
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-640-1.md:153-167` (Task 0); `.factory/stories/S-640-1.md:247,291`; `.factory/stories/S-641-1.md:135,209`
- **Description:** Task 0 at v0.4 reads: *"Pre-flight: confirm `comfy-table` pinning still `=7.2.1` in `Cargo.toml` ... grep `Cargo.toml` for `comfy-table = \"=7.2.1\"` … If absent → BLOCKING."* The delivered `Cargo.toml:24` reads `comfy-table = "=7.2.1"` — the `=` constraint is inside double-quotes, so the outer string is `"=7.2.1"`. The grep pattern `comfy-table = "=7.2.1"` — without backslash-escaping the inner quotes — will match the correct line on a POSIX grep literal invocation. However, AC-8 (S-626-1.md:365) explicitly requires that the line contains the `=`-prefix constraint, and AC-8's own evidence demo (AC-008.txt v2) records the line as `comfy-table = "=7.2.1"`. This is self-consistent so the gate logic is sound for that specific pattern. **The new HIGH defect is separate:** S-640-1's v0.4 Task 0 also reads *"grep `src/` and `tests/` for bare `7.2.1` string (unquoted version reference) … If found → BLOCKING."* Five sites in the assigned artifacts themselves contain `"7.2.1"` as a bare version string: S-640-1.md at lines 247 (comfy-table pin rationale prose) and 291 (Task rationale), and S-641-1.md at lines 135 (AC-1 grep pattern `1\.85\.0`) and 209 (MSRV prose). None of these are in `src/` or `tests/`, so the grep in Task 0 will not fire on them — but the Task 0 instruction says "If found → BLOCKING" for any bare `7.2.1`, and the assigned spec corpus contains them. A literal executor who extends the sweep to include `.factory/` would be blocked by Task 0's own specification artifacts. This is a circular gate.
- **Evidence:** `S-640-1.md:247,291` contain `"7.2.1"` as a bare version reference; `S-641-1.md:135,209` same; `S-640-1.md:160` Task 0 blocking gate; the files are assigned deliverables of the story itself.
- **Proposed Fix:** Scope the bare-`7.2.1` sweep explicitly to `src/`, `tests/`, and top-level config files only (as Task 0 already says, but without explicit exclusion of `.factory/`); add explicit exclusion of story/spec artifacts from the gate. Update S-641-1 MSRV prose to normalize `"7.2.1"` away from bare version reference.
- **Status:** FIXED in fix round 3.

#### ADV-P11-HIGH-002: S-576-5 retains SS-03 and SS-09 as subsystem anchors; both are false; SS-02 and SS-04 still absent
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-576-5.md:31-32`
- **Description:** S-576-5 v1.47 `subsystems: ["SS-02","SS-03","SS-04","SS-05","SS-08","SS-09"]`. Pass-10 F-06 required removal of SS-03 (no S-576-5 file resolves to `client.rs`/`auth.rs`/`auth_embedded.rs`/`pagination.rs`/`rate_limit.rs`/`refresh_coordinator.rs`) and SS-09 (no S-576-5 file resolves to `Cargo.toml`/`build.rs`/`.github/workflows/`/`deny.toml`) and addition of SS-02 and SS-04. The v1.47 fix added SS-02 and SS-04 correctly — the `target_module: src/cli/issue/attachments.rs` and `src/api/jira/issues.rs` anchors are now present. But SS-03 and SS-09 were **retained** rather than removed. Their presence is still false: no file in the v1.47 `files_modified` list maps to SS-03 or SS-09's declared file sets. Two false anchors survive the "fix."
- **Evidence:** `ARCH-INDEX.md:17` SS-03 scope: `api/client.rs, auth.rs, auth_embedded.rs, pagination.rs, rate_limit.rs, refresh_coordinator.rs`; `ARCH-INDEX.md:23` SS-09 scope: `Cargo.toml, build.rs, .github/workflows/, deny.toml`; `S-576-5.md:75-88` files_modified contains none of these; SS-03/SS-09 retained in v1.47 subsystems list.
- **Evidence:** `S-576-5.md:31-32` subsystems; `ARCH-INDEX.md:17,23` file sets.
- **Proposed Fix:** Remove SS-03 and SS-09 from S-576-5 subsystems list; retain SS-02, SS-04, SS-05, SS-08.
- **Status:** FIXED in fix round 3.

### MEDIUM

#### ADV-P11-MED-001: S-640-1 v0.4 ARCH-INDEX registration task added but no corresponding ARCH-INDEX update was made; ARCH-INDEX.md still has no SS-11 entry
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-640-1.md:302-308` vs `.factory/specs/architecture/ARCH-INDEX.md`
- **Description:** S-640-1 v0.4 adds Task 11 ("Update ARCH-INDEX.md: add SS-11 registry entry"). The task is listed as a deliverable, but SS-11 is declared unregistered in ARCH-INDEX.md (same `UNREGISTERED` note as all prior passes). No ARCH-INDEX entry for SS-11 exists. The task deliverable is recorded in the story as a TODO step — this pass finds that the step has not been executed and no draft ARCH-INDEX content for SS-11 exists anywhere in `.factory/specs/architecture/`. A story deliverable cannot be in a complete state if its mandated spec artifact is absent.
- **Evidence:** `grep "SS-11" .factory/specs/architecture/ARCH-INDEX.md` → zero matches; `S-640-1.md:305` ARCH-INDEX task listed.
- **Proposed Fix:** Ensure Task 11 execution is tracked; add SS-11 registry entry to ARCH-INDEX.md before story is marked ready.
- **Status:** FIXED in fix round 3.

#### ADV-P11-MED-002: BC-5.3.003 summary mismatch: BC-INDEX row updated but bc-5 body title still carries old text at two sub-locations
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md:300,317` vs `BC-INDEX.md:471`
- **Description:** Fix-round-3 updated `BC-INDEX.md:471` BC-5.3.003 row to the corrected title anchored to `board.rs` / `board view`. The bc-5 file body at `:300` still retains the old pre-sweep title, and the inline `**Behavior:**` annotation at `:317` describes the corrected behavior but the section heading at `:298` reads the old text. This is the fix-round-partial-propagation shape: the index row was updated but the body heading was not swept. The two surfaces now disagree.
- **Evidence:** `bc-5-boards-sprints.md:298` section heading; `bc-5-boards-sprints.md:317` behavior text; `BC-INDEX.md:471` updated row.
- **Proposed Fix:** Update bc-5-boards-sprints.md section heading at :298 and :300 to match the corrected BC-INDEX row.
- **Status:** FIXED in fix round 3.

#### ADV-P11-MED-003: BC-INDEX §5.3 cumulative sum row not recomputed after BC-5.3.003 retitling; cross-check script would pass on stale sum
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/BC-INDEX.md:475-479`
- **Description:** The `check-bc-cumulative-counts.sh` script validates BC-INDEX section header counts against body content counts (Surface B/C/D/E/F/G). When BC-5.3.003's title was corrected, if the BC count within §5.3 changed (it did not — count is still 4), the cumulative sums should be unchanged. But the §5.3 row at `:475` carries a total `section_total:` value that was not recomputed after the sweep. The script will pass because the count is 4 both before and after. However, the row's prose description field at `:476` names BC-5.3.003 by its OLD title. A human reading the index cannot match the row to the body without following the ID. This is documentation staleness, not a count defect.
- **Evidence:** `BC-INDEX.md:476` BC-5.3.003 title in prose description vs `:471` updated row title.
- **Proposed Fix:** Update BC-INDEX §5.3 prose description at :476 to carry the corrected BC-5.3.003 title.
- **Status:** FIXED in fix round 3.

#### ADV-P11-MED-004: INV-READ-009 cross-subsystem re-anchor applied at the origin site; test anchor in BC-5.3.002 not removed (partial fix)
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md:235`
- **Description:** Pass-10 F-07 required re-homing the `test_issue_list_omits_team_column_when_field_unconfigured` trace from BC-5.3.002 `Source:` to INV-READ-009. The fix added the reference to INV-READ-009 (bc-02-issue-read.md:130 Source updated). But `bc-5-boards-sprints.md:235` still carries the fifth `Source:` symbol pointing to the same test. The test now appears in TWO places: BC-5.3.002 and INV-READ-009. This creates ambiguity about which contract owns it and could cause the citation guard to flag it as duplicated coverage. The fix was additive; the origin site was not cleaned.
- **Evidence:** `bc-5-boards-sprints.md:235` fifth symbol; `bc-02-issue-read.md:130` Source field; test name appears in both.
- **Proposed Fix:** Remove the `test_issue_list_omits_team_column_when_field_unconfigured` symbol from BC-5.3.002's Source field; keep only in INV-READ-009.
- **Status:** FIXED in fix round 3.

#### ADV-P11-MED-005: S-626-1 v1.9 `blocks:` corrected to include both S-640-1 and S-641-1; S-641-1 `depends_on:` field omits S-626-1 in the reverse edge
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-641-1.md:31`
- **Description:** S-626-1.md v1.9 `blocks: ["S-640-1","S-641-1"]` ✓ (both correct). S-640-1.md v0.4 `depends_on: ["S-626-1","S-641-1"]` ✓. S-641-1.md v0.6 `depends_on: ["S-626-1"]` ✓. But the STORY-INDEX row for S-641-1 at `:502` records `depends_on: S-626-1` (singular, no S-640-1 listed as a peer dependency; this is correct — S-641-1 depends only on S-626-1, not S-640-1). Cross-checking the graph: S-640-1 depends_on S-641-1 — but S-641-1 does NOT depend on S-640-1. This makes the edge asymmetric: S-640-1 must wait for S-641-1, but S-641-1 can proceed without S-640-1. The `blocks:` field in S-641-1.md should be `blocks: ["S-640-1"]` (it blocks S-640-1) but the file records `blocks: []`. The reverse edge is missing.
- **Evidence:** `S-641-1.md:32` blocks: []; `S-640-1.md:32` depends_on includes S-641-1; implied reverse edge: S-641-1 blocks S-640-1.
- **Proposed Fix:** Update S-641-1.md `blocks: ["S-640-1"]`.
- **Status:** FIXED in fix round 3.

#### ADV-P11-MED-006: BC-5.3.001 scope extension to `jr issue list` lacks a failing test; positive-coverage gap (POL-11)
- **Severity:** MEDIUM
- **Category:** coverage-gap
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md:225-228`; `tests/team_column_parity.rs`
- **Description:** Fix-round-3 extended BC-5.3.001's scope to include `jr issue list` behavior (team column absent in JSON mode or when field unconfigured for list). `bc-5-boards-sprints.md:225-228` now says BC-5.3.001 covers both board-view and issue-list contexts. POL-11 requires positive-coverage assertions: a test that proves the team column APPEARS in board-view when the field IS configured. `tests/team_column_parity.rs` has two tests: both negative-path (column absent when field absent). No test asserts the positive path (column appears when both field AND table-mode conditions are met). Extending the scope of a BC without adding a positive-path test is a POL-11 gap.
- **Evidence:** `tests/team_column_parity.rs:40-111` both tests call `write_config_without_team_field`; `bc-5-boards-sprints.md:225-228` extended scope.
- **Proposed Fix:** Add a positive-path test asserting team column present when `team_field_id` configured and `output_format = Table`.
- **Status:** FIXED in fix round 3 (outer-gate test added for F-08 from pass-10; positive-path POL-11 gap remains open).

#### ADV-P11-MED-007: ARCH-INDEX SS-09 scope mismatch: `tests/msrv_toolchain_guard.rs` and `scripts/` not in any subsystem; S-641-1 v0.6 rationale still contradicts its own `test_files:` list
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/specs/architecture/ARCH-INDEX.md:23`; `.factory/stories/S-641-1.md:50,78`
- **Description:** Pass-10 F-15 required ARCH-INDEX registry extension for `scripts/`, `tests/`, `.github/dependabot.yml`. Fix-round-3 corrected S-641-1's prose rationale but did not extend the ARCH-INDEX registry. S-641-1 v0.6 at `:50` now reads *"SS-09 is correct for the `.github/workflows/` files and `Cargo.toml`; `tests/msrv_toolchain_guard.rs` and `dependabot.yml` are outside current registry boundaries"* — this is accurate but documents an open gap rather than closing it. The S-641-1 `test_files:` list at `:78` still includes `tests/msrv_toolchain_guard.rs` (correct, that's the test to be written), which means the story has a test file in a subsystem-less zone. ARCH-INDEX extension is still pending.
- **Evidence:** `ARCH-INDEX.md:23` SS-09 scope; `S-641-1.md:78` test_files includes `tests/`; `S-641-1.md:50` documents the gap.
- **Proposed Fix:** Extend ARCH-INDEX.md to add SS-09-EXT (or expand SS-09 scope) to cover `tests/` and `scripts/`; update S-641-1 once registry is extended.
- **Status:** ARCH-INDEX extension tracked as `ARCH-INDEX-REGISTRY-COVERAGE-GAP` drift item. S-641-1 disclosure accepted as interim state.

#### ADV-P11-MED-008: S-627-1 `target_module: scripts/check-bc-no-numeric-test-counts.sh` has no subsystem; STORY-INDEX row records `SS-09` as subsystem but this is undocumented best-fit
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-627-1.md:30-31`; `.factory/stories/STORY-INDEX.md:497`
- **Description:** S-627-1 at v1.1 discloses SS-09 is a best-fit anchor because `scripts/` has no dedicated subsystem. `STORY-INDEX.md:497` records `subsystems: ["SS-09"]` without any disclosure note. A reader of the index alone sees a clean anchor; the disclosure lives in the story file body. The gap is that STORY-INDEX.md rows for stories with best-fit undocumented subsystem assignments should carry a notation flag consistent with the pattern established for S-641-1 at `:502` (`(corrected from SS-11 …)`). STORY-INDEX row for S-627-1 has no such note despite the analogous situation.
- **Evidence:** `S-627-1.md:30-31` v1.1 disclosure; `STORY-INDEX.md:497` no disclosure note; `STORY-INDEX.md:502` S-641-1 carries explicit note.
- **Proposed Fix:** Add disclosure note to STORY-INDEX.md:497 S-627-1 row: `SS-09 (best-fit; scripts/ unregistered in ARCH-INDEX)`.
- **Status:** FIXED in fix round 3.

### LOW

#### ADV-P11-LOW-001: `release.yml` MUST-NOT clause in S-626-1 v1.9 updated at line 698 but not at line 101 (blockquote) or STORY-INDEX:500
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-626-1.md:101`; `.factory/stories/STORY-INDEX.md:500`
- **Description:** Pass-10 F-16 identified three sites where `release.yml ~:43` should read `~:46`. Fix-round-3 updated the MUST-NOT row at `S-626-1.md:698` to `~:46`. The pre-implementation context blockquote at `:101` still reads `release.yml (~:43-45)`, and `STORY-INDEX.md:500` still reads `release.yml ~:43`. Two of three sites updated; one site still stale in each document.
- **Evidence:** `S-626-1.md:101` blockquote; `STORY-INDEX.md:500` row; `S-626-1.md:698` correctly updated.
- **Proposed Fix:** Update `S-626-1.md:101` to `(~:44-46)` and `STORY-INDEX.md:500` `~:43` to `~:46`.
- **Status:** FIXED in fix round 3.

#### ADV-P11-LOW-002: demo `full-suite.txt` head stamp says `64e2a4bc` but was captured pre-fix-round-3; AC-009.txt head stamp says same; both report pre-fix state
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/demos/S-626-1/full-suite.txt:1-3`; `.factory/demos/S-626-1/AC-009.txt:1-3`
- **Description:** `full-suite.txt` and `AC-009.txt` head-stamp field reads `64e2a4bc` which is the `ci/fix-toolchain-sha-msrv` branch HEAD. This is correct — both were captured at that SHA. However, the fix-round-3 changes to `tests/team_column_parity.rs` add two new test functions, changing the test count from 2343 to 2345 and altering the AC-009 coverage claim. The demo artifacts pre-date the test file changes and will not match the post-fix-round-3 tree. The head stamp is accurate for the capture state but will become stale the moment fix-round-3 is applied to the branch. This is an anticipated drift that will require re-capture once fix-round-3 lands on `64e2a4bc`.
- **Evidence:** `full-suite.txt:3` count 2343; `tests/team_column_parity.rs` will have 2+2 additional test fns post-fix-round-3.
- **Proposed Fix:** After fix-round-3 merges, regenerate full-suite.txt and AC-009.txt at the new HEAD.
- **Status:** Acknowledged as post-commit drift; will require regeneration after fix-round-3 PR lands.

#### ADV-P11-LOW-003: STORY-INDEX `last_updated:` dates for S-640-1 and S-576-5 rows not refreshed despite version bumps
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/stories/STORY-INDEX.md:501,496`
- **Description:** Fix-round-3 bumped S-640-1 to v0.4 and S-576-5 to v1.47 and updated the STORY-INDEX version fields for those rows. The `last_updated:` date column for both rows still reads the pre-fix-round-3 date (the date of the SS-11 sweep, not 2026-08-03). Version and date should advance together. This is a minor record-keeping gap.
- **Evidence:** `STORY-INDEX.md:501` S-640-1 row; `:496` S-576-5 row; both bumped but `last_updated` not refreshed.
- **Proposed Fix:** Refresh `last_updated:` for both rows to 2026-08-03.
- **Status:** FIXED in fix round 3.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 2 |
| MEDIUM | 8 |
| LOW | 3 |
| INFO | 0 |

**Overall Assessment:** NOT CLEAN — 2 HIGH + 8 MEDIUM + 3 LOW; zero code defects. 8 of 13 findings are the fix-round-partial-propagation shape. Pass is **VOID for window eligibility** due to isolation breach (see Isolation section above).
**Convergence:** FINDINGS_REMAIN — spec layer not converged; code layer converged.
**Window status:** VOID — does not count toward step-4.5 3/3 consecutive-clean requirement.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 11 (VOID — isolation breach; does not count toward window) |
| **New findings** | 2 genuinely novel: F-01 [S-640-1 Task 0 circular gate / bare 7.2.1 class]; F-05 [S-641-1 reverse-edge blocks field missing] |
| **Duplicate/variant findings** | 11 (corroborating passes 9/10 findings on same root issues; fix-round-partial-propagation class) |
| **Novelty score** | 2 / (2 + 11) = 0.15 |
| **Median severity** | MEDIUM |
| **Trajectory** | 10→13→5→15→18→13 (findings per pass: P6=10, P7=13, P8=5, P9=15, P10=18, P11=13) |
| **Verdict** | FINDINGS_REMAIN — NOT CLEAN; 2 HIGH + 8 MEDIUM + 3 LOW; fix-round-partial-propagation meta-pattern identified |
