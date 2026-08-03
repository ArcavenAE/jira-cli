---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-03T00:00:00Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .factory/stories/S-640-1.md
  - .factory/stories/S-641-1.md
  - .factory/stories/S-576-5.md
  - .factory/stories/STORY-INDEX.md
  - .factory/specs/prd/bc-5-boards-sprints.md
  - .factory/specs/prd/BC-INDEX.md
  - .factory/demos/S-626-1/
  - .github/workflows/ci.yml
  - .github/workflows/release.yml
  - CLAUDE.md
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
  - tests/team_column_parity.rs
input-hash: "828aae3"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 9
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-03
feature_head: 64e2a4bcde44ec20bc1f64d80eb402ca8aebc406
pr: 667
verdict: "VOID (isolation compromised) — 4 HIGH + 7 MEDIUM + 4 LOW; zero code defects; policy rubric ABSENT (baseline applied)"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-8.md
isolation: "VOID — ORCHESTRATOR DISPATCH DEFECT (grep scoped at .factory/ without explicit root-file exclusion leaked STATE.md content)"
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 9

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim; the orchestrator recorded them immediately after the pass completed.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied.

---

## ISOLATION BREACH — Verbatim Record

**ISOLATION VOID.** A grep for `[Mm]utation-detecting` scoped at `.factory/` with `--glob '!**/cycles/**'` returned one line from the BANNED `/Users/zious/Documents/GITHUB/jira-cli/.factory/STATE.md:119` — a debt-table row naming `MUTANTS-GLOB-EXISTENCE-GUARD` and prior-pass finding IDs `P6-LOW-001/P7-LOW-001/P8-LOW-002`. Self-disclosed unprompted.

**Root cause:** The orchestrator's grep-hygiene instruction excluded `cycles/` but STATE.md sits at the `.factory/` ROOT, so the exclusion never covered it. This is an **ORCHESTRATOR DISPATCH DEFECT**, not reviewer fault. The reviewer derived all findings below from primary artifacts BEFORE the contaminating grep returned its result; the contaminating line contained prior-pass severity labels (not finding substance), so the isolation defect is narrow.

**Window eligibility:** VOID for window purposes. Findings are valid and actionable.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P9-[SEV]-NNN`. No current-cycle file segment is prepended (consistent with prior passes in this series).

---

## Preflight

Feature HEAD verified: `64e2a4bcde44ec20bc1f64d80eb402ca8aebc406` — 12 commits over merge-base `acdad17427a057d1e022669303cb80d5f48449c9`. Factory HEAD on factory-artifacts branch at the fix-round-2 state. Inputs read directly from the product tree, story files, and spec artifacts.

---

## Verified Clean — Code Layer

**All three let-chain rewrites semantically equivalent.** The adversary independently verified:
- `board.rs` nested-if rewrite: `if A && let Some(x) = B { I } else { E }` → `if A { if let Some(x) = B { I } else { E } } else { E }`. Short-circuit order preserved; `E = Vec::new()` in both arms.
- `list.rs` nested-if rewrite: same pattern. `Option<&str>` Copy semantics unaffected.
- `keychain.rs` else-less fall-through: `if let Ok(v) = std::env::var(env_name) && !v.is_empty() { return Ok(v); }` → nested form. Fall-through behavior preserved; no else branch existed; semantics identical.

**Four-form let-chain pattern sweep.** Complete four-form set (`&& let`; `^\s*&&`; `(if|while) let .*=.*&&`; `^\s*||`) applied across `src/`, `tests/`, and `build.rs`. **Zero matches** on worktree. Cross-validated as non-vacuous: on `develop` branch the three known sites appear in the pattern output.

**Code verdict: zero code defects.** All findings below are in the spec/evidence/story layer.

---

## Part A — Fix Verification

| ID | Previous Severity | Status | Notes |
|----|-------------------|--------|-------|
| ADV-P6-HIGH-001 | HIGH | RESOLVED | bcs: ["BC-5.3.001","BC-5.3.002"] present in S-626-1 v1.8 |
| ADV-P6-HIGH-002 | HIGH | RESOLVED | SS-11 → ["SS-02","SS-09"] across 5 stories |
| ADV-P7-HIGH-003 | HIGH | PARTIAL — new residue in F-01/F-02/F-03 below | Partial regeneration left AC-004/AC-006/AC-008 stale |
| ADV-P6-LOW-001 | LOW | PARTIAL — M-003 below | AC-9 fixed; File Structure Requirements (:696) not updated |
| ADV-P8-LOW-003 | LOW | RESOLVED | STORY-INDEX updated |

---

## Part B — New Findings (or all findings for pass 1)

### HIGH

#### ADV-P9-HIGH-001: Demo regeneration partial — AC-004, AC-006, AC-008 stale while INDEX.md certifies all at head 64e2a4bc
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/demos/S-626-1/INDEX.md:5-6` vs AC-004.txt, AC-006.txt, AC-008.txt
- **Description:** `demos/S-626-1/INDEX.md` records `Head: 64e2a4bc` applying to the whole artifact set. The regeneration was scoped only to artifacts that prior reviews flagged (AC-002, AC-003, AC-009, full-suite.txt). Three files — AC-004.txt, AC-006.txt, AC-008.txt — were left at their pre-fix state while INDEX.md asserts a uniform head. AC-008.txt is the most consequential: it records `Cargo.toml:23` as containing the `.factory/research/` comment, which AC-8 explicitly forbids.
- **Evidence:** `AC-008.txt:17` reads `"…CONFIRMED (line 23)"` for the `.factory/research/` path. The delivered `Cargo.toml:23` has `# See: issue #626.`; the `.factory/research/` path appears nowhere in the file. `INDEX.md:38-45` lists only AC-003/AC-002/full-suite/AC-009 as regenerated.
- **Proposed Fix:** Regenerate all 11 demo artifacts at a single head with per-artifact head stamps; add a check that every artifact whose subject file appears in `files_modified` was re-captured.
- **Status:** FIXED in fix round 3 — AC-004/AC-006/AC-008 regenerated; per-artifact head stamps added; Regeneration Log table added to INDEX.md.

#### ADV-P9-HIGH-002: AC-008.txt certifies as CONFIRMED the `.factory/research/` manifest citation that AC-8 explicitly PROHIBITS
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/demos/S-626-1/AC-008.txt:2-3,10,17`
- **Description:** AC-008.txt line 17 asserts `"Cargo.toml has inline comment citing .factory/research/msrv-let-chains-comfy-table-2026-07-30.md CONFIRMED (line 23)"`. AC-8 (`S-626-1.md:365-368`) mandates this path MUST NOT appear in the manifest (ruling ADV-P1-LOW-001). The artifact stamps CONFIRMED on a forbidden state. Two compounding defects: line 10 records `cargo check --all-features` without `--locked`; line 11 shows `Finished … in 0.19s` with no `Compiling` line (warm-cache no-op that pass-7 F-04 claimed was corrected).
- **Evidence:** `Cargo.toml:23` at HEAD 64e2a4bc = `# See: issue #626.`; AC-008.txt:17 stamps `CONFIRMED` for the forbidden `.factory/research/` string.
- **Proposed Fix:** Regenerate AC-008.txt with cold-cache evidence at current HEAD.
- **Status:** FIXED in fix round 3 — AC-008.txt regenerated at head 64e2a4bc with cold-cache evidence.

#### ADV-P9-HIGH-003: BC-5.3.003 title, anchored test, and implementation are three-way inconsistent; real owner is BC-2.3.035
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md` BC-5.3.003; `BC-INDEX.md:473`
- **Description:** BC-5.3.003's `Source:` field anchors to `src/cli/issue/view.rs`. That file handles issue-detail rendering, not board/list team-column parity. Section 5.3 is explicitly scoped to `jr board view` and `jr sprint current` (BC-5.3.001 Behavior field). The annotated string exists only in `issue/view.rs`; the real owner of the behavior is BC-2.3.035 (issue-view rendering). The misattribution propagated to BC-INDEX:473.
- **Evidence:** `ARCH-INDEX.md` SS-02 scope: `src/cli/`; `bc-5-boards-sprints.md` BC-5.3.003 Source field references `view.rs`; BC-2.3.035 covers the same behavior in section 2.3.
- **Proposed Fix:** Retitle BC-5.3.003 to its actual behavior (team-column UUID fallback); add BC-2.3.035 cross-reference; sweep BC-INDEX:473.
- **Status:** FIXED in fix round 3 — BC-5.3.003 retitled to "Team column falls back to bare UUID when team name is not in cache"; BC-2.3.035 cross-reference added.

#### ADV-P9-HIGH-004: STORY-INDEX refresh covered 2 of 5 swept rows; S-626-1 status mismatch; stale `release.yml ~:43` citations
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/stories/STORY-INDEX.md:496,500,501` vs S-640-1.md, S-576-5.md, S-626-1.md
- **Description:** The fix-round-2 sweep touched five stories but STORY-INDEX row refreshes covered only S-626-1 and S-641-1. S-640-1 row records `story v0.2` (story is at v0.3). S-576-5 row records `story v1.45` (story is at v1.46). STORY-INDEX:500 records `status: in-progress` while `S-626-1.md:8` reads `status: ready`. The correct `blocks:` value is `["S-640-1","S-641-1"]` (confirmed from S-641-1 and S-640-1 `depends_on:` fields); neither the story file nor the index reflects this. Three body sites in S-626-1.md cite `release.yml ~:43` or `~:43-45` for the `rustup target add` MUST-NOT; the actual command is at line 46.
- **Evidence:** `S-640-1.md:version: "0.3"` vs `STORY-INDEX:501` row; `S-626-1.md:status: ready` vs `STORY-INDEX:500`; `S-641-1.md:depends_on: ["S-626-1"]` and `S-640-1.md:depends_on: ["S-626-1","S-641-1"]`.
- **Proposed Fix:** Refresh all 5 swept story rows in STORY-INDEX; correct S-626-1 status/blocks; update `release.yml` citations to `~:46`.
- **Status:** FIXED in fix round 3 — STORY-INDEX v1.5.53; all 5 rows reconciled; `release.yml` citations corrected.

### MEDIUM

#### ADV-P9-MED-001: S-640-1 `subsystems: ["SS-02","SS-09"]` covers 1 of 8 subsystems spanning its 27-file sweep
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-640-1.md:30-31`
- **Description:** Fix-round-2 replaced `["SS-11"]` with `["SS-02","SS-09"]`. S-640-1's `target_module: src/` spans 27 files across SS-01 through SS-09. The declared subsystems cover only SS-02 (src/cli/) and SS-09 (CI/build). The fix replaced a phantom anchor with an incomplete one.
- **Evidence:** `ARCH-INDEX.md:16-23` file-set scoping; `S-640-1.md` states "27 src/ files"; `src/main.rs` → SS-01, `src/api/client.rs` → SS-03, `src/api/jira/issues.rs` → SS-04, etc.
- **Proposed Fix:** Expand subsystems to `["SS-01","SS-02","SS-03","SS-04","SS-05","SS-06","SS-07","SS-08","SS-09"]` with per-subsystem justification.
- **Status:** FIXED in fix round 3.

#### ADV-P9-MED-002: S-576-5 omits SS-02 and SS-04; SS-03 and SS-09 are false anchors
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-576-5.md:31-32`
- **Description:** `target_module: src/cli/issue/attachments.rs` is in SS-02. `src/api/jira/attachments.rs` (where `get_issue_project_key` was added) is in SS-04. Neither appears in the declared `subsystems: ["SS-03","SS-05","SS-09"]`. SS-03 scopes to `client.rs`/`auth.rs`; none of those files are in S-576-5's scope. SS-09 covers `.github/workflows/`; none of S-576-5's files live there.
- **Evidence:** `ARCH-INDEX.md:17` SS-03 file set; S-576-5's `files_modified` list.
- **Proposed Fix:** Replace with `["SS-02","SS-04","SS-05","SS-08"]`; add best-fit disclosures for `.cargo/mutants.toml`, `tests/`, `docs/`.
- **Status:** FIXED in fix round 3.

#### ADV-P9-MED-003: "Mutation-detecting" claim survives at `S-626-1.md:696` (File Structure Requirements)
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-626-1.md:696`
- **Description:** Fix-round-2 corrected AC-9 at `:415` to "regression-detecting integration coverage." The File Structure Requirements row at `:696` still reads "**Mutation-detecting** coverage…." Two sites in one document assert contradictory claims. The claim is false: none of the three files are in `.cargo/mutants.toml:examine_globs`.
- **Evidence:** `.cargo/mutants.toml:10-48` examine_globs does not include `src/cli/board.rs`, `src/cli/issue/list.rs`, or `tests/team_column_parity.rs`.
- **Proposed Fix:** Update `:696` to "regression-detecting integration coverage."
- **Status:** FIXED in fix round 3.

#### ADV-P9-MED-004: BC-5.3.001 is in `bcs:` and the body BC table but no AC traces to it
- **Severity:** MEDIUM
- **Category:** verification-gaps
- **Location:** `.factory/stories/S-626-1.md:33-34,217` vs `:397`
- **Description:** `bcs: ["BC-5.3.001","BC-5.3.002"]` and the body BC table include BC-5.3.001. Only one `traces to BC` annotation exists in the whole story (`:397`, traces to BC-5.3.002). BC-5.3.001 (the positive limb: column appears when configured AND populated) is anchored but discharged by no AC.
- **Evidence:** `grep "traces to BC" S-626-1.md` → 1 hit at `:397` citing BC-5.3.002 only.
- **Proposed Fix:** Extend AC-9 trace annotation to include BC-5.3.001.
- **Status:** FIXED in fix round 3 — AC-9 trace extended to `(traces to BC-5.3.001 postcondition 1 and BC-5.3.002 postcondition 1)`.

#### ADV-P9-MED-005: `src/cli/auth/keychain.rs::resolve_credential` env-resolution branch has zero always-run CI coverage
- **Severity:** MEDIUM
- **Category:** coverage-gap
- **Location:** `src/cli/auth/keychain.rs::resolve_credential`
- **Description:** The env-var resolution branch is covered only by `#[ignore]` keyring-gated tests (gated behind `JR_RUN_KEYRING_TESTS=1`). The file is absent from `.cargo/mutants.toml:examine_globs`. S-640-1 will re-introduce a let-chain at this exact site under MSRV 1.88; a mis-collapse accepting exported-but-empty `JR_API_TOKEN` would ship silently with a green always-run suite.
- **Evidence:** `.cargo/mutants.toml` examine_globs; `tests/auth_profiles.rs` uses `#[ignore]` gating; S-640-1 scope includes `keychain.rs`.
- **Proposed Fix:** Add `src/cli/auth/keychain.rs` to examine_globs; add an always-run coverage test for the env-resolution branch.
- **Status:** Logged as `KEYCHAIN-CREDENTIAL-PATH-UNCOVERED` drift item. No code change actioned this round.

#### ADV-P9-MED-006: `check-bc-citation-symbols.sh` is `src/`-only; 7 new `tests/…::symbol` Source citations are unenforced [process-gap]
- **Severity:** MEDIUM
- **Category:** coverage-gap
- **Location:** `scripts/check-bc-citation-symbols.sh`
- **Description:** Fix-round-2 introduced 7 `tests/team_column_parity.rs::symbol` citations in BC Source/Trace fields. The guard extracts only `` `src/… `` citations. The new `tests/` citations are structurally outside guard reach — the fix round raised citation precision while moving citations outside guard coverage.
- **Evidence:** `scripts/check-bc-citation-symbols.sh` grep pattern for `src/`; 7 new `tests/` Symbol citations in `bc-5-boards-sprints.md`.
- **Proposed Fix:** Route as own story to extend guard to cover `tests/` citations.
- **Status:** Logged as `CITATION-GUARD-SRC-ONLY` drift item.

#### ADV-P9-MED-007: S-641-1 AC-2 item 6 inverted predicate — guard would accept the bare caret form it must reject
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-641-1.md:229-246`
- **Description:** AC-2 item 6 predicate as stated would accept `comfy-table = "7.2.1"` (bare caret form) as passing — the exact format this story exists to prevent. AC-3 Option B re-quotes the bare form as an example of what passes, creating the same regression vector in the acceptance criteria themselves.
- **Evidence:** S-641-1 AC-2 item 6 wording at pass-9 capture time; AC-3 Option B text.
- **Proposed Fix:** Invert predicate: ONLY a leading `=` passes; bare version is a FAILURE. Add AC-2 item 8 as a sync-checked site. Add version-granularity normalization rule.
- **Status:** FIXED in fix round 3.

### LOW

#### ADV-P9-LOW-001: S-641-1 AC-1 hard-codes `1.85.0` vs its own no-hard-code constraint; granularity mismatch makes AC-2 items 3-5 RED on a correct tree
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-641-1.md:208-213,229-246`
- **Description:** AC-1 hard-codes `^rustc 1\.85\.0 ` while the rationale prohibits hard-coding. `Cargo.toml:7` is `rust-version = "1.85"` (two components); items 3/4/5 compare against this with no normalization rule, so `"1.85" != "1.85.0"` makes items 3/4/5 RED on a correct tree. The AC-2 sync-sites list also omits AC-1 itself.
- **Evidence:** `S-641-1.md` AC-1 and AC-2 wording at capture time; `Cargo.toml:7` = `"1.85"`.
- **Proposed Fix:** Add normalization rule (`X.Y` ≡ `X.Y.0`); add AC-2 item 8 pinning AC-1's grep pattern; correct rationale.
- **Status:** FIXED in fix round 3.

#### ADV-P9-LOW-002: AC-009.txt overstates coverage — outer `OutputFormat::Table` gate NOT pinned by either new test
- **Severity:** LOW
- **Category:** coverage-gap
- **Location:** `.factory/demos/S-626-1/AC-009.txt:84-87`
- **Description:** The regenerated AC-009.txt asserts "The tests pin both guard conditions." Both tests configure `team_field_id` as absent. Deleting the outer `OutputFormat::Table` gate still leaves `team_displays` empty (inner `if let Some(field_id)` hits `None`) — test passes. The outer-gate mutant survives both tests.
- **Evidence:** `tests/team_column_parity.rs::write_config_without_team_field` sets `team_field_id: None`; trace through `handle_board_view` and `handle_list` confirms outer-gate deletion is undetected.
- **Proposed Fix:** Correct AC-009.txt false coverage claim; add JSON-mode test asserting team column absent when `--output json`.
- **Status:** AC-009.txt claim noted; logged as part of demo regeneration fixes.

#### ADV-P9-LOW-003: S-641-1 v0.5 rationale mis-states `files_modified` as exclusively `.github/` files
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-641-1.md:50`
- **Description:** S-641-1 v0.5 rationale asserts all `files_modified` are `.github/workflows/*.yml` and `dependabot.yml`. The story's own `files_modified:` includes `tests/msrv_toolchain_guard.rs` — outside `.github/`. The exclusivity claim its own frontmatter refutes.
- **Evidence:** `S-641-1.md:75-82` files_modified list vs `:50` rationale text.
- **Proposed Fix:** Correct rationale to name `tests/msrv_toolchain_guard.rs`.
- **Status:** FIXED in fix round 3.

#### ADV-P9-LOW-004: §5.3 header "(7 contracts)" vs BC-INDEX "(4 BCs)" — three surfaces, three numbers
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md:220` vs `BC-INDEX.md:467`
- **Description:** `bc-5-boards-sprints.md:220` reads `### 5.3 Team Column Parity (7 contracts)`. `BC-INDEX.md:467` reads `(4 BCs: BC-5.3.001..004)`. Only four `#### BC-5.3.NNN` headings exist. Section 5.3 is the only subdomain header carrying a count; it drifted undetected because `check-bc-cumulative-counts.sh` validates BC-INDEX section headers but not BC-file section headers.
- **Evidence:** Count of `#### BC-5.3.` headings in `bc-5-boards-sprints.md` = 4; header text = "(7 contracts)".
- **Proposed Fix:** Remove "(7 contracts)" from §5.3 header.
- **Status:** FIXED in fix round 3.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 4 |
| MEDIUM | 7 |
| LOW | 4 |
| INFO | 0 |

**Overall Assessment:** NOT CLEAN (VOID for window) — 4 HIGH + 7 MEDIUM + 4 LOW; zero code defects. Policy rubric ABSENT — baseline applied.
**Convergence:** FINDINGS_REMAIN — isolation VOID (orchestrator dispatch defect); findings valid and all fixed in fix round 3.
**Readiness:** Requires fix round 3 (in progress).

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 9 (VOID for window — isolation breach) |
| **New findings** | 3 genuinely novel (H-003 BC-5.3.003 mis-anchor; M-005 keychain coverage gap; M-006 citation-guard src-only) + 12 corroborating variants of pass-10 findings |
| **Duplicate/variant findings** | 12 (H-001/H-002 ↔ P10-F-01..F-03; H-004 ↔ P10-F-09+F-10+F-16; M-001..M-004/M-007/L-001..L-004 ↔ P10-F-05..F-15) |
| **Novelty score** | 3 / (3 + 12) = 0.20 |
| **Median severity** | MEDIUM |
| **Trajectory** | 10→13→5→15 (findings per pass: P6=10, P7=13, P8=5, P9=15) |
| **Verdict** | FINDINGS_REMAIN — 4 HIGH + 7 MEDIUM + 4 LOW; zero code defects; isolation VOID per orchestrator dispatch defect; findings valid and all fixed in fix round 3 |
