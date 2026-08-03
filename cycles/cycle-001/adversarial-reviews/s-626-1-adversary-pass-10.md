---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-03T01:00:00Z
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
pass: 10
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-08-03
feature_head: 64e2a4bcde44ec20bc1f64d80eb402ca8aebc406
pr: 667
verdict: "NOT CLEAN — 4 HIGH + 11 MEDIUM + 3 LOW; zero code defects; policy rubric ABSENT (baseline applied)"
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-9.md
isolation: "CLEAN — every grep scoped to a named subdirectory, never .factory/ root; three banned-path filenames visible as text inside in-perimeter files (disclosed)"
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 10

## Provenance

This artifact is a **DIRECT CAPTURE** of adversary reviewer output relayed by the orchestrator, recorded same-session. The reviewer's findings were relayed verbatim immediately after the pass completed.

**Policy rubric:** `.factory/policies.yaml` does not exist. Baseline applied (POL-11 positive-coverage, S-7.01 partial-fix discipline, semantic-anchoring severity ladder, six mandated axes).

---

## Isolation

**CLEAN.** I read no banned path. I did not open `.factory/cycles/**`, `.factory/STATE.md`, `sidecar-learning.md`, `spec-changelog.md`, or any `*adversary-pass*`/`*step45*`/`*convergence-trajectory*`/`ADV-*INDEX*`/`burst-log*`/`session-checkpoints*` artifact. Every grep was scoped to a named subdirectory (`.factory/specs/`, `.factory/stories/`, `.factory/demos/`, `.worktrees/S-626-1/`, `src/`) — never `.factory/` root.

**Incidental exposure (disclosed, not concealed):** three banned-path *filenames* appeared as quoted text inside files that are in my assigned perimeter. (a) `/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-626-1/AC-001.txt` lines 5–6 quote `.factory/cycles/cycle-001/session-checkpoints.md` and `.factory/cycles/cycle-001/convergence-trajectory.md`. (b) `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-626-1/.github/workflows/ci.yml` lines 212–214 cite `.factory/cycles/cycle-001/S-346/implementation/red-gate-log.md`. In all three cases only the path string was visible; I opened none of them and inherited no prior-pass conclusion. I re-derived every finding below from primary artifacts.

**Limitation stated explicitly:** I have no Bash, so I could not compile, run tests, or run git. All claims about semantic equivalence are from reading both versions of the code; all claims about evidence staleness are from comparing recorded artifact text against the delivered files at the paths given.

---

## Finding ID Convention

Finding IDs for this pass use the format `ADV-P10-[SEV]-NNN`. No current-cycle file segment is prepended (consistent with prior passes in this series).

---

## PER-AXIS RESULTS

**Axis 1 — BC Title / Subsystem Label Sync: FINDINGS (F-05, F-06, F-07, F-13, F-15).** All five symbols named in BC-5.3.002's new `Source:` exist in the delivered `tests/team_column_parity.rs`; BC titles in the story body table match BC-INDEX verbatim; SS-11 is correctly identified as unregistered. But three subsystem assignments do not resolve against the registry's declared file sets, and one BC→test anchor crosses a subsystem boundary.

**Axis 2 — VP-INDEX ↔ Architecture Doc Coherence: N/A-with-justification.** No `VP-INDEX.md`, `verification-architecture.md`, `verification-coverage-matrix.md`, or `invariants.md` exists anywhere under `.factory/specs/`. ADR-0017 was path-corroborated as PRESENT at `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md` — a draft "missing ADR" finding dropped as a pathing artifact.

**Axis 3 — Invariant-to-BC Orphan Detection: FINDING (F-07, contributing).** No `invariants.md` / DI-NNN namespace exists; the operative invariant namespace is `INV-READ-NNN` in `domain-spec/bc-02-issue-read.md`. INV-READ-009 (the amended one) is enforced by no BC and now traces to no test, while the test that does verify it was anchored into an unrelated BC section.

**Axis 4 — Story Frontmatter-Body Coherence: FINDINGS (F-11, F-12, F-09, F-10).** Sampled all five touched stories plus S-640-1. `acceptance_criteria_count: 9` ✓ (AC-1..AC-9). Body BC table ↔ frontmatter `bcs:` bidirectionally complete ✓. But no AC traces to BC-5.3.001, one v1.8 correction propagated to only one of two sites, and STORY-INDEX rows disagree with the story files they describe.

**Axis 5 — CI-as-Code / POL-11: PASS with observations (+ F-14 on routing sufficiency).** The `mutants` job is exemplary: runtime-computed kill rate, malformed-JSON guard, integer-coercion guard, and H-1 schema-drift guard. `check-bc-citation-symbols`, `check-cargo-mutants-policy-citations`, and `check-bc-cumulative-counts` all pair real runs with `--self-test`/negative-fixture invocations ✓. The `msrv` job's missing positive-coverage assertion is accepted and routed — reporting only the routing-sufficiency defect (F-14).

**Axis 6 — Partial-Fix Regression Discipline: FINDINGS (F-01, F-02, F-03, F-04, F-10, F-11, F-16, F-17).** Revert residue is **zero** (verified below). But the fix round itself propagated incompletely in five distinct places.

---

## Revert Residue Verification (all clean)

| Surface | Value | Verdict |
|---------|-------|---------|
| `Cargo.toml:7` | `rust-version = "1.85"` | ✓ |
| `Cargo.toml:24` | `comfy-table = "=7.2.1"` (exact, `=` prefix) | ✓ |
| `Cargo.lock:357-358` | `comfy-table` / `7.2.1` — `--locked` will resolve | ✓ |
| `README.md:8` | `MSRV-1.85` badge | ✓ |
| `ci.yml:60,70,72,86` | `MSRV (1.85.0)` / `# 1.85.0` / `toolchain: "1.85.0"` / `RUSTUP_TOOLCHAIN: "1.85.0"` | ✓ |
| `rust-toolchain.toml` | `channel = "stable"` unchanged (per MUST-NOT) | ✓ |
| `CLAUDE.md:163` + `:219` | Convention + Gotcha, both at 1.85/1.85.0 | ✓ |
| `CHANGELOG.md:9-34` | 1.85.0 throughout; no unqualified upstream-rendering claim | ✓ |
| Orphaned clippy allows | `#[allow(...)]` set byte-identical to `develop`: only `adf.rs:8905 too_many_lines` and `refresh_coordinator.rs:56 dead_code`, both pre-existing. Zero `collapsible_if` allows. | ✓ |
| `1.88` in `src/` | Only the three intentional MSRV comments (`board.rs:231`, `keychain.rs:50`, `list.rs:523`) — exactly the three CLAUDE.md:163 promises to delete | ✓ |

---

## Let-Chain Sweep and Semantic Equivalence

**Complete four-form sweep over all `*.rs` including `tests/` and `build.rs`: zero matches on worktree.**

Cross-validation against `develop` confirmed all three known let-chains found (including the let-first form at `keychain.rs:50-52`). Pattern is non-vacuous.

**Semantic equivalence — all three rewrites verified:**

**`board.rs` and `list.rs` — equivalent.** `if A && let Some(x) = y { BODY } else { E }` became `if A { if let Some(x) = y { BODY } else { E } } else { E }`. Short-circuit order preserved (`matches!(output_format, Table)` still evaluated first). Both non-match paths yield identical `Vec::new()`. `E` is a `Vec::new()` literal — no side effects, so duplicating it is safe.

**`keychain.rs::resolve_credential` — equivalent.** `if let Ok(v) = std::env::var(env_name) && !v.is_empty() { return Ok(v); }` became nested `if`. Critical: the original had **no `else` arm** — on `Err` or empty it fell through to the `no_input` block. The rewrite also has no `else` on either level, so both `Err(_)` and `Ok("")` still fall through identically. `std::env::var` called exactly once in both. Flag (line 47) still wins over env, env still wins over prompt. **This was the highest-risk rewrite and it is correct.**

**Code verdict: zero code defects.** The delivered code is clean.

---

## Fix-Round Verification (Part B)

| # | Item | Verdict |
|---|------|---------|
| 1 | `bc-5-boards-sprints.md` BC-5.3.001..004 `Source:` → symbol form | **INCOMPLETE** — four of five symbols correctly anchored; fifth (`test_issue_list_omits_team_column_when_field_unconfigured`) is a cross-subsystem mis-anchor (F-07). Section header count stale (F-13). |
| 2 | `bc-02-issue-read.md` INV-READ-009 restatement | **CORRECT** — meaning preserved; let-chain prescription removed; citation symbol-form; one new un-listed MSRV-cleanup site created (F-17). |
| 3 | `BC-INDEX.md` corresponding rows | **INCOMPLETE** — rows 471-474 internally consistent ✓, but §5.3 header disagrees with BC file (F-13). |
| 4 | `S-626-1.md` v1.8 | **INCOMPLETE** — subsystems/bcs/behavioral_contracts/AC-9 trace landed correctly ✓; "mutation-detecting" reached AC-9 but not File Structure Requirements (F-11); no AC traces BC-5.3.001 (F-12). |
| 5 | SS-11 sweep across S-627-1/S-640-1/S-641-1/S-576-5 | **WRONG** — SS-11 diagnosis right; three of four replacement assignments do not resolve against registry declared file sets (F-05 HIGH, F-06 HIGH, F-15 MEDIUM). |
| 6 | `STORY-INDEX.md` v1.5.52 rows | **INCOMPLETE** — S-626-1 row contradicts story file on `status` and `blocks` (F-09); S-640-1 and S-576-5 rows not refreshed despite files being bumped (F-10). |
| 7 | Regenerated demo evidence at `64e2a4bc` | **NEW-DEFECT-INTRODUCED** — F-03/F-04 defects in INDEX.md genuinely fixed ✓; but only 5 of 11 artifacts regenerated while INDEX.md asserts head `64e2a4bc` for the set. AC-008/AC-006/AC-004 stale (F-01 HIGH, F-02 HIGH, F-03 MEDIUM); AC-009 introduced new false coverage claim (F-08). |

---

## Part A — Fix Verification

| ID | Previous Severity | Status | Notes |
|----|-------------------|--------|-------|
| ADV-P6-HIGH-001 | HIGH | RESOLVED | bcs: ["BC-5.3.001","BC-5.3.002"] present ✓ |
| ADV-P6-HIGH-002 | HIGH | PARTIAL — see F-05, F-06 | SS-11 removed; replacement anchors incomplete |
| ADV-P7-HIGH-003 | HIGH | PARTIAL — see F-01, F-02, F-03, F-04 | Partial regeneration; INDEX.md claims full coverage |
| ADV-P7-MED-001 | MEDIUM | PARTIAL — see F-01 | AC-008.txt still has warm-cache no-op capture |
| ADV-P8-LOW-003 | LOW | PARTIAL — see F-09, F-10 | STORY-INDEX updated for 2 of 5 rows |

---

## Part B — New Findings (or all findings for pass 1)

### HIGH

#### ADV-P10-HIGH-001: `AC-008.txt` is stale and certifies as PASS a Cargo.toml state that VIOLATES AC-8
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/demos/S-626-1/AC-008.txt:2-3,10,17`
- **Description:** The artifact records the delivered `Cargo.toml` as containing `# Ref: .factory/research/msrv-let-chains-comfy-table-2026-07-30.md` at line 23 and asserts `CONFIRMED (line 23)`. The delivered `Cargo.toml` at head `64e2a4bc` has `# See: issue #626.` at line 23; the `.factory/research/` path appears **nowhere** in the file. AC-8 (`S-626-1.md:365-368`) mandates the exact opposite: this path MUST NOT appear in the published manifest (ruling ADV-P1-LOW-001). Two further defects: line 10 records `cargo check --all-features` **without `--locked`**, contradicting `INDEX.md:72`; line 11 shows `Finished … in 0.19s` with no `Compiling` line — the verbatim F-04 warm-no-op pattern `INDEX.md:32-36` claims was corrected.
- **Evidence:** `Cargo.toml:23` at HEAD 64e2a4bc = `# See: issue #626.`; `AC-008.txt:17` stamps `CONFIRMED` for the `.factory/research/` path; `AC-008.txt:11` shows 0.19s finish with no Compiling line.
- **Proposed Fix:** Regenerate AC-008.txt with a cold-cache proof at current HEAD.
- **Status:** FIXED in fix round 3 — AC-008.txt regenerated at head 64e2a4bc with cold-cache evidence.

#### ADV-P10-HIGH-002: `AC-006.txt` is stale and records the superseded, factually-incorrect precedence text as CONFIRMED
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/demos/S-626-1/AC-006.txt:2,4-7,13-14`
- **Description:** The artifact captures `sed -n '215,220p' CLAUDE.md` with the gotcha at line 218. In the delivered `CLAUDE.md`, `## Gotchas` is at line 217 and the gotcha at line 219. The recorded *text* claims RUSTUP_TOOLCHAIN is *"the highest-precedence override"* and that the toml *"overrides `rustup default`, `rustup override`, and the `toolchain` input"*. The delivered text publishes the ordered chain `+toolchain > RUSTUP_TOOLCHAIN env > directory override > rust-toolchain.toml > rustup default` — so a directory override **outranks** RUSTUP_TOOLCHAIN. Assertion line 14 — *"Entry documents: rust-toolchain.toml outranks dtolnay/rust-toolchain toolchain input CONFIRMED"* — validates a claim the delivered file deliberately no longer makes (this is the MEDIUM-001 mechanism correction from pass-3).
- **Evidence:** `CLAUDE.md:217-219` delivered text vs `AC-006.txt:4-7` captured text; the precedence chain reversal is material.
- **Proposed Fix:** Regenerate AC-006.txt from current CLAUDE.md.
- **Status:** FIXED in fix round 3 — AC-006.txt regenerated at head 64e2a4bc.

#### ADV-P10-HIGH-003: `S-640-1` `subsystems: ["SS-02","SS-09"]` is materially incomplete; contradicts `target_module: src/`
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-640-1.md:30-31`
- **Description:** The story's scope is "fix 49 `collapsible_if` clippy errors across **27 `src/` files**" with `target_module: src/`. SS-02 scopes to `src/cli/` only. Approximating the sweep set from the nested-`if` construct pattern across `src/`: ~26 files. Their subsystem spread: `src/main.rs` → SS-01; 11 files under `src/cli/` → SS-02; `src/api/client.rs`, `src/api/auth.rs`, `src/api/refresh_coordinator.rs` → SS-03; `src/api/jira/{issues,bulk,sprints}.rs` → SS-04; `src/api/jsm/queues.rs` → SS-05; `src/api/assets/{objects,workspace}.rs` → SS-06; `src/types/jira/bulk.rs` → SS-07; `src/adf.rs`, `src/config.rs` → SS-08. The v0.3 rationale concedes the shortcut: "SS-02 covers **the dominant directory**" — but dominant is not "owns the scope", and `target_module: src/` in the same frontmatter contradicts the SS-02-only anchor.
- **Evidence:** `ARCH-INDEX.md:16` SS-02 file set: `src/cli/`; S-640-1 `target_module: src/`; nested-if pattern appears in `src/api/auth.rs` (SS-03) and `src/adf.rs` (SS-08).
- **Proposed Fix:** Expand to all nine subsystems with per-subsystem justification.
- **Status:** FIXED in fix round 3 — S-640-1 v0.3→v0.4; subsystems `["SS-01".."SS-09"]` with per-subsystem justification.

#### ADV-P10-HIGH-004: `S-576-5` `subsystems` omits SS-02 and SS-04; contradicts its own `target_module`
- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-576-5.md:31-32`
- **Description:** `target_module: src/cli/issue/attachments.rs`, `subsystems: ["SS-03","SS-05","SS-09"]`. The story's declared file scope includes `src/cli/issue/attachments.rs`, `src/cli/mod.rs`, `src/cli/issue/mod.rs`, `src/cli/issue/interactions.rs` (**SS-02**, `src/cli/`); `src/api/jsm/{attachments,servicedesks,mod}.rs` (**SS-05** ✓); `src/api/jira/issues.rs` (**SS-04**, `src/api/jira/` — where `get_issue_project_key` was added); plus `.cargo/mutants.toml`. **SS-02 is missing even though it owns the file named in `target_module`** — a direct self-contradiction. **SS-04 is missing** despite the story adding a function to `src/api/jira/issues.rs`. **SS-03 does not resolve**: `ARCH-INDEX.md:17` scopes SS-03 to `client.rs`/`auth.rs`/`auth_embedded.rs`/`pagination.rs`/`rate_limit.rs`/`refresh_coordinator.rs` — none appear in S-576-5's scope. SS-03 retention flagged LOW (pending intent verification from prior human ruling); SS-02/SS-04 omissions are not intent questions — both are direct contradictions.
- **Evidence:** `ARCH-INDEX.md:17` SS-03 file set; S-576-5 files_modified list; `get_issue_project_key` added to `src/api/jira/issues.rs`.
- **Proposed Fix:** Replace with `["SS-02","SS-04","SS-05","SS-08"]`; remove SS-03/SS-09 as false anchors; add best-fit disclosures.
- **Status:** FIXED in fix round 3 — S-576-5 v1.46→v1.47; subsystems corrected.

### MEDIUM

#### ADV-P10-MED-001: `AC-004.txt` cites `ci.yml` line numbers and comment text that do not exist at head `64e2a4bc`
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/demos/S-626-1/AC-004.txt:5-6`
- **Description:** The recorded `grep` output shows five hits at lines `60, 70, 72, 77, 80`, with line 77 reading `# the 1.85.0 MSRV toolchain. --all-features is intentional.` and `RUSTUP_TOOLCHAIN: "1.85.0"` at line 80. In the delivered `ci.yml`, line 77 reads `# — the same defect class as comfy-table 7.2.2 — and requires Rust ≥1.88.`; `RUSTUP_TOOLCHAIN` is at line 86; and the same grep returns **six** hits (60, 70, 72, 76, 82, 86) because the expanded 10-line comment block contains `1.85.0` twice. The artifact is from the pre-comment-expansion state and directly contradicts `AC-003.txt:53`, which correctly cites the comment block as `ci.yml :74-83 (10 lines)`.
- **Evidence:** `AC-004.txt:5-6` vs delivered `ci.yml` content; `AC-003.txt:53` internally inconsistent with `AC-004.txt`.
- **Proposed Fix:** Regenerate AC-004.txt from current ci.yml.
- **Status:** FIXED in fix round 3 — AC-004.txt regenerated.

#### ADV-P10-MED-002: Demo regeneration has no completeness assertion; `INDEX.md` claims a head for artifacts it did not regenerate [process-gap]
- **Severity:** MEDIUM
- **Category:** coverage-gap
- **Location:** `.factory/demos/S-626-1/INDEX.md:5-6,38-45`
- **Description:** `Head: 64e2a4bc` and `Captured: 2026-07-31 (regenerated; …)` are stated for the artifact set as a whole. The "Additional staleness corrected" list enumerates only AC-003, AC-002, and full-suite. The remaining six (AC-001, AC-004, AC-005, AC-006, AC-007, AC-008) were left at the Jul-30 capture. Three of those six are now provably wrong (F-01, F-02, F-03); AC-005 and AC-007 survive only by luck. The regeneration was scoped to *the artifacts a review flagged* rather than *every artifact whose subject file changed*, and nothing in the process forces the two to agree. This is the **generative root cause** of the stale-demo class.
- **Evidence:** `INDEX.md:38-45` lists five refreshed artifacts; AC-008.txt mtime predates AC-003.txt by evidence comparison; F-01/F-02/F-03 prove three unrefreshed artifacts are wrong.
- **Proposed Fix:** Regenerate **all** demo artifacts at a single head with per-artifact head stamp; add a check that every artifact whose subject file appears in `files_modified` was re-captured.
- **Status:** FIXED in fix round 3 — all 11 artifacts regenerated; per-artifact head stamps added; Regeneration Log table added to INDEX.md.

#### ADV-P10-MED-003: `issue list` test anchored into BC-5 "Boards & Sprints"; real owner INV-READ-009 amended in same round but given no trace
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md:235` (fifth `Source:` symbol); cross-reference `bc-02-issue-read.md:130`
- **Description:** BC-5.3.002's `Source:` names `tests/team_column_parity.rs::test_issue_list_omits_team_column_when_field_unconfigured`. That test exercises `jr issue list` (`src/cli/issue/list.rs::handle_list`), which section 5.3 explicitly scopes **out**: BC-5.3.001 Behavior reads *"Affects `jr sprint current` and `jr board view`"*; Key Invariants at `:271` treats `issue list` as the contrasting case. The genuine owner is **INV-READ-009** in `bc-02-issue-read.md:130`, whose Source column is `cli/issue/list.rs::handle_list` — yet INV-READ-009 received no reference to the new test. The round amended the correct invariant and anchored its test to the wrong contract.
- **Evidence:** `bc-5-boards-sprints.md:271` Key Invariants; `bc-02-issue-read.md:130` INV-READ-009 Source; five symbols in BC-5.3.002 Source; fourth symbol is `test_board_view` (correct), fifth is `test_issue_list` (wrong subsystem).
- **Proposed Fix:** Re-home the `issue list` test anchor from BC-5.3.002 to INV-READ-009; add `tests/team_column_parity.rs::test_issue_list_omits_team_column_when_field_unconfigured` to INV-READ-009's Source field.
- **Status:** FIXED in fix round 3.

#### ADV-P10-MED-004: `AC-009.txt` claims both guard conditions pinned; outer Table-gate mutant survives both new tests
- **Severity:** MEDIUM
- **Category:** coverage-gap
- **Location:** `.factory/demos/S-626-1/AC-009.txt:84-87`
- **Description:** The regenerated artifact asserts: *"A regression that removed the outer `OutputFormat::Table` check would produce a non-empty `team_displays` Vec even without a field_id, causing the 'Team' column to appear — failing the negative assertion. … **The tests pin both guard conditions.**"* This is false. Both new tests configure `team_field_id` as **absent** (`write_config_without_team_field`). Trace the hypothesised regression: delete the outer `if matches!(output_format, OutputFormat::Table)` → control flows to `if let Some(field_id) = team_field_id` which is `None` → `team_displays` still empty → test still passes. The outer-gate mutant survives both tests. Only the inner `if let` is pinned.
- **Evidence:** `tests/team_column_parity.rs:72-76` `write_config_without_team_field` sets no `team_field_id`; trace through `handle_board_view` confirms outer-gate deletion is undetected.
- **Proposed Fix:** Correct the false coverage claim in AC-009.txt; add a JSON-mode test asserting team column absent when `--output json`.
- **Status:** AC-009.txt false coverage claim corrected in fix round 3; outer-gate coverage gap remains open.

#### ADV-P10-MED-005: STORY-INDEX S-626-1 row contradicts story file on `status` and `blocks`; three-way disagreement
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/STORY-INDEX.md:500` vs `S-626-1.md:8,32`
- **Description:** STORY-INDEX:500 states `status: in-progress (PR #667 open)`; `S-626-1.md:8` states `status: ready`. STORY-INDEX:500 states `blocks:[S-640-1]`; `S-626-1.md:32` states `blocks: []`. The reverse edges: `S-641-1.md:31` declares `depends_on: ["S-626-1"]` and `S-640-1.md:32` declares `depends_on: ["S-626-1","S-641-1"]`, so the correct value is `blocks: [S-640-1, S-641-1]`. The story file has neither; the index has one of two. Part B item 6 asserts this row was refreshed to match the story file — on both fields it does not.
- **Evidence:** `S-626-1.md:8` status; `S-626-1.md:32` blocks; `S-641-1.md:31` depends_on; `S-640-1.md:32` depends_on; `STORY-INDEX.md:500` row.
- **Proposed Fix:** Correct S-626-1.md status/blocks to `status: ready` and `blocks: ["S-640-1","S-641-1"]`; refresh STORY-INDEX row.
- **Status:** FIXED in fix round 3 — S-626-1 v1.8→v1.9; STORY-INDEX v1.5.52→v1.5.53.

#### ADV-P10-MED-006: SS-11 sweep bumped S-640-1 and S-576-5 but did not refresh their STORY-INDEX rows
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/STORY-INDEX.md:501` (S-640-1) and `:496` (S-576-5)
- **Description:** `STORY-INDEX.md:501` records `story v0.2` for S-640-1; `S-640-1.md:50` is `version: "0.3"`. `STORY-INDEX.md:496` records `story v1.45` for S-576-5; `S-576-5.md:71` is `version: "1.46"`. The sweep touched four story files and refreshed two rows (S-626-1, S-641-1); the other two rows were left behind. The index's own convention proves rows are expected to carry this: `:502` (S-641-1) explicitly records `subsystems:[SS-09] (corrected from SS-11 …; v0.5 2026-07-31)` — so S-640-1 and S-576-5 are inconsistent with the pattern the same round established two rows away.
- **Evidence:** `S-640-1.md:version: "0.3"` vs `STORY-INDEX:501`; `S-576-5.md:version: "1.46"` vs `STORY-INDEX:496`.
- **Proposed Fix:** Refresh S-640-1 and S-576-5 rows in STORY-INDEX with current versions and subsystem notes.
- **Status:** FIXED in fix round 3 — STORY-INDEX v1.5.53.

#### ADV-P10-MED-007: v1.8 "mutation-detecting" correction propagated to AC-9 but not to File Structure Requirements
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-626-1.md:696`
- **Description:** v1.8 correction removed "mutation-detecting" from AC-9 (`:415`). The File Structure Requirements row at `:696` still reads "**Mutation-detecting** coverage for `else { Vec::new() }` branches; guards vacuous passes." Two sites in one document assert contradictory things about the same file. The claim is false: the three files are absent from `.cargo/mutants.toml:examine_globs`.
- **Evidence:** `S-626-1.md:415` corrected vs `:696` unchanged; `.cargo/mutants.toml:examine_globs` does not include `board.rs`, `list.rs`, or `team_column_parity.rs`.
- **Proposed Fix:** Update `:696` to "regression-detecting integration coverage."
- **Status:** FIXED in fix round 3.

#### ADV-P10-MED-008: BC-5.3.001 is in `bcs:` and body BC table but no AC traces to it
- **Severity:** MEDIUM
- **Category:** verification-gaps
- **Location:** `.factory/stories/S-626-1.md:33-34,217` vs `:397`
- **Description:** `bcs: ["BC-5.3.001","BC-5.3.002"]` and the body BC table include BC-5.3.001. Grepping the whole story for `traces to BC` yields exactly one hit — `:397`, traces to BC-5.3.002. BC-5.3.001 (the positive limb: column **appears** when configured AND populated) appears anchored to the story yet is discharged by no AC. The rewrite does affect it — the positive path now runs through two nested conditions — and the story's own body table says so ("Partial"). No AC obliges anyone to verify it.
- **Evidence:** `grep "traces to BC" S-626-1.md` → 1 hit; body BC table `:217` includes BC-5.3.001.
- **Proposed Fix:** Extend AC-9 trace annotation to include BC-5.3.001.
- **Status:** FIXED in fix round 3.

#### ADV-P10-MED-009: `bc-5` §5.3 header says "(7 contracts)"; BC-INDEX says "(4 BCs)"; mapping table implies 6 [process-gap]
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-5-boards-sprints.md:220` vs `BC-INDEX.md:467` and `:826`
- **Description:** Three surfaces, three numbers: `bc-5-boards-sprints.md:220` → `(7 contracts)`; `BC-INDEX.md:467` → `(4 BCs: BC-5.3.001..004)`; `BC-INDEX.md:826` maps `R4 BC-1138a..f → BC-5.3.001..004` (six upstream sub-items collapsed into four). Only four `#### BC-5.3.NNN` headings exist. Section 5.3 is the **only** subdomain header in the file carrying a parenthetical count — it reconciles against nothing. `check-bc-cumulative-counts.sh` validates BC-INDEX section headers but not the BC file's own section headers, so this drifted undetected even though the fix round had this section open.
- **Evidence:** Count of `#### BC-5.3.` headings = 4; header text = "(7 contracts)"; BC-INDEX:467 = "(4 BCs)".
- **Proposed Fix:** Remove "(7 contracts)" from §5.3 header; extend guard to cover BC-file subdomain headers.
- **Status:** FIXED in fix round 3 (header count removed); guard extension tracked as drift item.

#### ADV-P10-MED-010: S-641-1's AC-1 and AC-2 mutually inconsistent on version granularity; as specified, AC-2 guard fails on the current tree
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-641-1.md:208-213` (AC-1) vs `:229-246` (AC-2)
- **Description:** AC-1 hard-codes three components: `^rustc 1\.85\.0 ` (note deliberately). AC-2 reads `Cargo.toml:7` as canonical — `rust-version = "1.85"` (**two** components). Items 3/4/5 require ci.yml's `toolchain: "1.85.0"` and `MSRV (1.85.0)` to "match the canonical version" with no normalization rule stated. `"1.85" != "1.85.0"` makes items 3/4/5 RED on a correct tree. Item 2 handles the ambiguity for README (`MSRV-{major}.{minor}` **or** `MSRV-{major}.{minor}.{patch}`) — so the omission in 3/4/5 is an inconsistency within AC-2. Status: `draft` and "exact assertion TBD at elaboration" (`:241`) mitigates, but the normalization rule must be settled or the guard is false-green-prone.
- **Evidence:** `S-641-1.md:208` AC-1 grep; `:229-246` AC-2 items; `Cargo.toml:7` = `"1.85"`.
- **Proposed Fix:** Add normalization rule (`X.Y` ≡ `X.Y.0`); add AC-2 item 8 pinning AC-1's grep pattern; correct v0.5 rationale.
- **Status:** FIXED in fix round 3 — S-641-1 v0.5→v0.6.

#### ADV-P10-MED-011: SS-09's registry file set does not cover `scripts/`, `tests/`, or `.github/dependabot.yml`; S-641-1's exclusivity claim contradicted by its own `files_modified` [process-gap]
- **Severity:** MEDIUM
- **Category:** spec-fidelity
- **Location:** `ARCH-INDEX.md:23`; `S-627-1.md:30-31`; `S-641-1.md:75-82` and `:50`
- **Description:** `ARCH-INDEX.md:23` scopes SS-09 to exactly `Cargo.toml`, `build.rs`, `.github/workflows/`, `deny.toml`. Three assignments fall outside: (a) **S-627-1** → SS-09 with `target_module: scripts/check-bc-no-numeric-test-counts.sh`; `scripts/` is in no subsystem's file set (S-627-1's v1.1 note discloses this honestly). (b) **S-641-1** → SS-09, but `files_modified` includes `.github/dependabot.yml` (outside `.github/workflows/`) and `tests/msrv_toolchain_guard.rs` (`tests/` in no subsystem) — while v0.5 rationale at `:50` asserts **all** files are `.github/workflows/*.yml` and `dependabot.yml`, contradicting its own `files_modified:` and `test_files:` lists. (c) The same `tests/` gap applies to S-626-1's `tests/team_column_parity.rs`. Underlying cause: no subsystem owns `scripts/`, `tests/`, or `.github/*.yml` outside `workflows/`.
- **Evidence:** `ARCH-INDEX.md:23` SS-09 scope; `S-641-1.md:50` vs `:75-80`; `S-627-1.md:30-31` disclosure note.
- **Proposed Fix:** Add registry entries for `scripts/`, `tests/`, `.github/dependabot.yml`; correct S-641-1 rationale.
- **Status:** FIXED in fix round 3 (S-641-1 rationale corrected); registry extension tracked as `ARCH-INDEX-REGISTRY-COVERAGE-GAP` drift item.

### LOW

#### ADV-P10-LOW-001: `release.yml` MUST-NOT protection cites a line range that excludes the line it protects
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-626-1.md:698` and `:101`
- **Description:** In the delivered `release.yml` the step name is at `:43` and `rustup target add ${{ matrix.target }}` is at **`:46`**. The v1.6 LOW-004 correction moved AC-5's table cell to `~:45` but three other sites still say 43: the MUST-NOT line (`:698`, `release.yml ~:43`), the pre-implementation blockquote (`:101`, `release.yml (~:43-45)`), and `STORY-INDEX.md:500` (`release.yml ~:43`). All three ranges terminate at or before 45 and therefore exclude line 46 — the protected statement itself. These are `~`-prefixed approximate refs, which is why this is LOW.
- **Evidence:** `release.yml:46` = `run: rustup target add ${{ matrix.target }}`; `S-626-1.md:698` = `~:43`.
- **Proposed Fix:** Update all three sites to `~:46`.
- **Status:** FIXED in fix round 3.

#### ADV-P10-LOW-002: INV-READ-009's new MSRV note is an un-listed MSRV-raise cleanup site
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/specs/domain-spec/bc-02-issue-read.md:130`; cross-reference `CLAUDE.md:163`
- **Description:** The restatement appends *"Implemented as nested `if` blocks (not a let-chain; let-chains require Rust ≥1.88; MSRV is 1.85)."* `CLAUDE.md:163` defines the cleanup contract: *"Temporary — delete this entry and the **three citing in-code comments** when MSRV is raised to ≥1.88."* The three in-code comments (`board.rs:231`, `keychain.rs:50`, `list.rs:523`) are enumerated. INV-READ-009 is a **fourth citing site** — in `.factory/` rather than `src/`, created by this round — not listed in the cleanup obligation. S-640-1 raises MSRV to 1.88 and re-introduces let-chains; following `CLAUDE.md:163` literally, the executor deletes the convention entry and three `src/` comments but leaves INV-READ-009 asserting the now-stale "MSRV is 1.85" note.
- **Evidence:** `CLAUDE.md:163` cleanup list = 3 comments; `bc-02-issue-read.md:130` new MSRV note not in list.
- **Proposed Fix:** Mark INV-READ-009's MSRV note as self-identifying-temporary with an explicit removal trigger for MSRV ≥1.88.
- **Status:** FIXED in fix round 3 — INV-READ-009 MSRV note marked self-identifying-temporary.

#### ADV-P10-LOW-003: AC-9 and Task 7d state test-count target as 2341; demo shows 2343
- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/stories/S-626-1.md:444` and `:631` vs `.factory/demos/S-626-1/full-suite.txt:3`
- **Description:** AC-9's "Regression evidence" (`:444`) records *"cargo test → 2341 passed"* and Task 7d (`:631`) instructs *"cargo test baseline unchanged (2341 passed … **target**)"*. `full-suite.txt:3` reports 2343. The delta is fully explained: `develop`'s `tests/team_column_parity.rs` had 7 `#[tokio::test]` functions; the delivered file has 9. So the arithmetic is sound — this is a stale target, not a discrepancy. But Task 7d's instruction is self-defeating: the same AC that authorizes the test file demands the count be unchanged.
- **Evidence:** `full-suite.txt:3` = `2343 passed`; `S-626-1.md:444` = `2341 passed`; `S-626-1.md:631` = `2341`.
- **Proposed Fix:** Update 2341→2343 at both sites.
- **Status:** FIXED in fix round 3.

---

## Observations (non-blocking)

- **POL-11 / `msrv` job:** no positive-coverage assertion; accepted and routed to S-641-1 AC-1/AC-2 — see F-14 for routing-sufficiency defect. Mitigating factor: at the pinned SHA `toolchain:` is a hard-required input, so dropping the `with:` block fails loudly.
- **POL-11 / `spec-guard`:** `check-bc-no-numeric-test-counts.sh` is the only step in that job with neither a `--self-test` companion nor a runtime-computed count. S-627-1 adds the `--self-test` seam.
- **POL-11 / `test` job:** `cargo test --all-features` asserts nothing about `running N tests > 0`. Low risk but the class is live in this repo (F-03 was precisely a filter-scoped zero-test false-green).
- **`ci-gate`:** guard tests only `failure` and `cancelled`, not `skipped`. Pre-existing and untouched.
- **De-facto VP namespace:** VP IDs active in stories and `CLAUDE.md` with no registry file. `verification_properties: []` defensible on the merits; factual claim about registry absence is correct.
- **Two coexisting ADR namespaces:** `docs/adr/0001..0016-*.md` (product) and `.factory/specs/architecture/decisions/ADR-00NN-*.md` (spec). `docs/adr/0017-*.md` would collide. Not a defect today.
- **AC-002.txt, AC-005.txt, AC-007.txt, AC-001.txt verified accurate.** All SHA sites and line numbers match; AC-003's MSRV capture satisfies all three demanded proofs. AC-009's counts reconcile exactly with 9 test functions in the delivered file.
- **Non-vacuousness genuine** for the branch new tests do cover: both assert `contains("Team").not()` after positive assertions, so the negative cannot pass on an empty table. F-08 is about which branch is covered, not vacuity.

---

## Convergence Assessment

**New substantive gaps: 18 (4 HIGH + 11 MEDIUM + 3 LOW). Code defects: 0.**

Mis-anchoring findings (always blocking): 3 — F-05, F-06, F-07. Process-gap tags: 4 — F-04, F-13, F-15.

**Judgment: NOT converged.**

The delivered **code** has converged. All three let-chain rewrites are semantically exact. Revert residue is zero. I would sign off on the code today.

The **spec and evidence layers have not converged**. Two patterns account for most findings:

1. **Fix-at-the-flagged-site, not at the class.** Five of seven Part B items propagated to exactly the location a prior review named and no further: "mutation-detecting" reached AC-9 but not File Structure Requirements (F-11); the release.yml line fix reached AC-5 but not the MUST-NOT clause, blockquote, or STORY-INDEX (F-16); the SS-11 sweep bumped four story files but refreshed two of four index rows (F-10); the demo regeneration refreshed flagged artifacts and left three others misrepresenting the tree (F-01/F-02/F-03/F-04).

2. **Corrections made without independently re-deriving the target.** The SS-11 replacements were not checked against `ARCH-INDEX`'s declared file sets — producing an S-640-1 anchor contradicting its own `target_module: src/` (F-05), an S-576-5 anchor missing the subsystem owning its own target_module file (F-06), and an S-641-1 exclusivity claim its own `files_modified` refutes (F-15). The BC→test anchoring exercise amended the correct invariant (INV-READ-009) then filed its test under a different subsystem's BC (F-07).

**F-01 and F-08 deserve sharpest emphasis.** F-01: the AC-8 demo artifact certifies CONFIRMED-PASS a `Cargo.toml` state AC-8 explicitly forbids. F-08: the regenerated AC-9 artifact newly asserts both guard conditions are pinned, when the outer `OutputFormat::Table` gate survives deletion under both new tests. A story whose entire subject is "exit code 0 did not mean what we thought it meant" has shipped an evidence set containing a PASS stamp on a violation and a coverage claim a five-minute branch trace refutes.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 4 |
| MEDIUM | 11 |
| LOW | 3 |
| INFO | 0 |

**Overall Assessment:** NOT CLEAN — 4 HIGH + 11 MEDIUM + 3 LOW; zero code defects. Policy rubric ABSENT — baseline applied.
**Convergence:** FINDINGS_REMAIN — spec and evidence layers not converged; code layer converged.
**Readiness:** Requires fix round 3.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 10 (WINDOW-ELIGIBLE — clean isolation) |
| **New findings** | 5 genuinely novel: F-04 [process-gap] demo completeness root cause; F-08 outer Table-gate mutant; F-13 §5.3 three-way count + guard gap; F-16 MUST-NOT range excludes protected line; F-18 stale 2341 test target |
| **Duplicate/variant findings** | 13 (corroborating pass-9 findings on same root issues) |
| **Novelty score** | 5 / (5 + 13) = 0.28 |
| **Median severity** | MEDIUM |
| **Trajectory** | 10→13→5→15→18 (findings per pass: P6=10, P7=13, P8=5, P9=15, P10=18) |
| **Verdict** | FINDINGS_REMAIN — NOT CLEAN; 4 HIGH + 11 MEDIUM + 3 LOW; zero code defects; 3 mis-anchoring findings block convergence unconditionally |
