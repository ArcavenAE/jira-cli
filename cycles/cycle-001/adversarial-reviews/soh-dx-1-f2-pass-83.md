---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: consistency-validator
timestamp: 2026-07-29T00:00:00
phase: F2
inputs:
  - .factory/specs/prd/bc-3-issue-write.md
  - .factory/specs/prd/error-taxonomy.md
  - .factory/specs/prd/holdout-scenarios.md
  - .factory/spec-changelog.md
  - src/main.rs
  - src/output.rs
  - src/error.rs
  - src/cli/issue/create.rs
  - tests/issue_create_jsm.rs
  - Cargo.toml
  - rust-toolchain.toml
  - .github/workflows/ci.yml
input-hash: "bd030c3"
traces_to: .factory/specs/prd/bc-3-issue-write.md
pass: 83
previous_review: null
# Additional context fields
cycle: cycle-001
bundle: SOH-DX-1
aperture: emit-site / observable-contract
spec_version: v1.3.166
date: 2026-07-29
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
---

# Adversarial Review: jira-cli (Pass 83)

## Aperture

Every externally observable contract in the SOH-DX-1 delta verified at its
emit site (`file::symbol`). Specifically: exit-code mapping, stream routing
(stdout vs. stderr), error-string identity across all three spec surfaces,
JSON envelope shape, guard ordering relative to HTTP and project-key
resolution, and whether mandated tests would fail vs. pass against the
current binary.

## Perimeter

- `.factory/specs/prd/bc-3-issue-write.md` (§3.8; AC-1..21; S-639-1 F4 obligations)
- `.factory/specs/prd/error-taxonomy.md` Section 6
- `.factory/specs/prd/holdout-scenarios.md` Group 20 (H-NEW-PREFLIGHT-001..006)
- `.factory/spec-changelog.md` `[1.3.161]`..[`1.3.166]`
- `src/main.rs`, `src/output.rs`, `src/error.rs`, `src/cli/issue/create.rs`
- `tests/issue_create_jsm.rs`, `tests/json_error_shape.rs`
- `Cargo.toml`, `rust-toolchain.toml`, `.github/workflows/ci.yml`
- `.github/workflows/sign-and-publish.yml`, `.github/workflows/backfill-release.yml`
- `scripts/check-spec-counts.sh`, `tests/claude_md_citations.rs`
- `CLAUDE.md` (Output channels section)

## Isolation

No files from `.factory/cycles/cycle-001/adversarial-reviews/`, `.factory/cycles/cycle-001/convergence-trajectory.md`, or `.factory/STATE.md` were read. All verdicts are reached from spec + code alone.

---

## Observable-Contract Table (Item 2)

| Observable | Asserted stream (spec) | Actual stream (code) | Emit-site citation | Verdict |
|---|---|---|---|---|
| `--field` w/o `--request-type` → `JrError::UserError` message | stderr | NOT emitted (old `eprintln!` warning instead; exit 0) | `src/cli/issue/create.rs::handle_create` ~:78-90 | MISMATCH — pre-F3 implementation gap (expected at F2) |
| `--field` w/o `--request-type` → exit code 64 | 64 | 0 (warn-and-proceed) | `src/error.rs::JrError::exit_code()` ~:94 | MISMATCH — pre-F3 |
| `--on-behalf-of` w/o `--request-type` → error + exit 64 | stderr / 64 | old `eprintln!` / exit 0 | `src/cli/issue/create.rs::handle_create` ~:86-90 | MISMATCH — pre-F3 |
| Combined `--field + --on-behalf-of` → ONE combined error + exit 64 | stderr / 64 | TWO independent warnings / exit 0 | `src/cli/issue/create.rs::handle_create` ~:78-90 | MISMATCH — pre-F3 |
| `--output json` error path → `{"code":N,"error":"..."}` on stderr | stderr | stderr | `src/main.rs::main` ~:132-145 (eprintln! JSON block) | MATCH (path correct; guard not yet implemented) |
| `--output json` error path → stdout empty | stdout | stdout (empty) | `src/main.rs::main` error path (no stdout write) | MATCH |
| Human-mode error → `"Error: {msg}"` on stderr | stderr | stderr | `src/main.rs::main` ~:143 `eprintln!("Error: {e}")` | MATCH |
| JSON success → issue JSON on stdout | stdout | stdout | `src/cli/issue/create.rs::handle_create` ~:249 `println!` | MATCH |
| Human-mode success → `"Created issue X"` on stderr | stderr | stderr | `src/output.rs::print_success` ~:46 `eprintln!` | MATCH — critical emit-site verified |
| Human-mode success → `stdout.trim().is_empty()` | stdout empty | stdout empty | `src/cli/issue/create.rs::handle_create` ~:269-277 (no println! on Table path) | MATCH |
| `JrError::UserError` exit code | 64 | 64 | `src/error.rs::JrError::exit_code()` ~:94 | MATCH |
| Guard ordering: fires BEFORE project-key resolution | before ~:92 | ~:78-90 is before ~:92 | `src/cli/issue/create.rs::handle_create` line ordering | MATCH — ordering correct |
| Guard ordering: fires AFTER JSM dispatch fork | after ~:49 | ~:78-90 is after ~:49 | `src/cli/issue/create.rs::handle_create` ~:49 vs ~:78 | MATCH |
| Guard fires BEFORE any HTTP | before HTTP calls | ~:78-90 precedes CMDB/team HTTP | `src/cli/issue/create.rs::handle_create` ordering | MATCH (spec assertion verified) |
| JSON envelope key order — spec says "unspecified" | "parse individually" | BTreeMap → `{"code":N,"error":"..."}` (alphabetical) | `src/main.rs` ~:136 `serde_json::json!({...})`; `Cargo.toml` serde_json default (no `preserve_order`) | MATCH — spec correctly accounts for BTreeMap ordering |

---

## Checklist Coverage

### 1. Exit-code contracts

`JrError::UserError` → exit code 64. Verified at `src/error.rs::JrError::exit_code()` ~:94. The `src/main.rs` error path at ~:124-148 correctly extracts the exit code via `e.chain().find_map(|cause| cause.downcast_ref::<JrError>()).map(|je| je.exit_code())`. The mapping is correct and un-ambiguous: 64 is the unique code for `UserError`.

### 2. Stream contracts

Exhaustively verified above. Key findings:

- **Errors (both modes) → stderr.** `src/main.rs::main` ~:132-145: both the JSON arm (`eprintln!("{}", json!({"error":...,"code":...}))`) and the human arm (`eprintln!("Error: {e}")`) use `eprintln!`. Stdout is EMPTY on the error path. Confirmed.
- **JSON success → stdout.** `src/cli/issue/create.rs::handle_create` ~:249/~:265 uses `println!` (stdout). Confirmed.
- **Human-mode success → stderr.** `src/output.rs::print_success` ~:46 is `eprintln!`. `src/cli/issue/create.rs::handle_create` ~:272 calls `output::print_success(...)`. This is the emit site that caused v1.3.165's defect (incorrectly asserting stdout); v1.3.166 corrects the holdout to stderr. Verified correct.

The CLAUDE.md profile 4 description ("stdout for `--output json`") is ambiguous and has caused two spec defects. See finding ADV-P83-MEDIUM-002.

### 3. Error-string identity across four surfaces

Verified byte-by-byte across `bc-3-issue-write.md` fenced blocks, `error-taxonomy.md` §6 table, and `holdout-scenarios.md` Group 20. All three strings are **byte-identical** across all surfaces:

| String | bc-3 fenced block | error-taxonomy row | holdout scenario |
|---|---|---|---|
| `--field` single-flag | Confirmed | Line 192 ✓ | H-NEW-PREFLIGHT-001 ✓ |
| `--on-behalf-of` single-flag | Confirmed | Line 193 ✓ | H-NEW-PREFLIGHT-002 ✓ |
| Combined both flags | Confirmed | Line 194 ✓ | H-NEW-PREFLIGHT-003 ✓ |

No drift found. The spec also correctly notes that the human-mode renderer prepends `"Error: "` (from `src/main.rs` ~:143), and holdout assertions use `contains()` to tolerate that prefix.

### 4. JSON envelope shape

`src/main.rs::main` ~:134-140 emits:
```rust
eprintln!("{}", serde_json::json!({"error": e.to_string(), "code": exit_code}));
```

`serde_json` is declared as `serde_json = "1"` in `Cargo.toml` with no `preserve_order` feature. The default Map type is `BTreeMap`, so key order is alphabetical: `{"code":N,"error":"..."}`. `e.to_string()` on `JrError::UserError(msg)` yields `msg` directly (thiserror `#[error("{0}")]` pattern, no "Error: " prefix in the JSON field). H-NEW-PREFLIGHT-006 correctly says "key order is unspecified — parse fields individually" — this matches reality. The assertion `contains("--field is only valid with --request-type")` would succeed on the `"error"` field value. No spec defect here.

### 5. Guard ordering, observably

**Current code** `src/cli/issue/create.rs::handle_create`:

1. ~:49: `if request_type.is_some()` → JSM dispatch fork (return early)
2. ~:78-90: warn-and-proceed code (will become guards at F3)
3. ~:92-108: project-key resolution (prompts in interactive mode)
4. ~:111+: HTTP calls (team resolution, CMDB fields, POST /rest/api/3/issue)

The spec asserts guards fire "BEFORE project-key resolution, BEFORE interactive prompts, BEFORE any HTTP." The current code structure puts the warn-and-proceed block at ~:78-90 — correct placement for the guards. The spec's ordering assertion is **verified as structurally correct** for the current code layout. An F3 implementer placing `JrError::UserError` returns at the same location will satisfy all ordering ACs.

The combined-check must fire before both single-flag checks (spec v1.3.159 F67-001 correction). The spec at BC-3.8.012 ordering section says "before BOTH individual single-flag checks." An F3 implementer must structure the guard as: first combined check (both flags present), then single-flag `--field`, then single-flag `--on-behalf-of`. The spec correctly specifies this ordering; the implementation doesn't exist yet.

### 6. Would mandated tests fail against current build?

**Tests that PASS against current binary (warn-and-proceed) but test SUPERSEDED behavior:**

| Test name | Location | What it tests | Status |
|---|---|---|---|
| `test_platform_create_field_flag_emits_warning_without_request_type` | `tests/issue_create_jsm.rs` ~:2420 | Exit 0 + old warning string (S-383 AC-1) | PASSES on current binary, tests SUPERSEDED behavior |
| `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type` | `tests/issue_create_jsm.rs` ~:2493 | Exit 0 + old warning (S-383 AC-2) | PASSES on current binary, tests SUPERSEDED behavior |
| `test_platform_create_both_inverse_flags_emit_independent_warnings` | `tests/issue_create_jsm.rs` ~:2564 | Exit 0 + two warnings (S-383 AC-3) | PASSES on current binary, tests SUPERSEDED behavior |
| `test_platform_create_field_idempotent_one_warning_per_logical_flag` | `tests/issue_create_jsm.rs` ~:2687 | Exit 0 + old warning exactly once (S-383 AC-5) | PASSES on current binary, tests SUPERSEDED behavior |
| `test_platform_create_malformed_field_one_warning_no_exit_64` | `tests/issue_create_jsm.rs` ~:2812 | Exit 0 + old warning for malformed field (S-383 AC-7) | PASSES on current binary, tests SUPERSEDED behavior |

These five tests will **FAIL** once F3 implements the exit-64 guards. They are S-383 tests that the spec has marked for replacement. The spec correctly tracks them as F3 invertion targets ("S-639-1 ACs supersede S-383 same-numbered ACs"). The banner comment at `tests/issue_create_jsm.rs` ~:2381-2391 contains three false clauses identified by spec v1.3.142 (F45-002) as an F3 correction obligation.

**Tests mandated by spec (S-639-1 ACs) that would FAIL against current binary:**

H-NEW-PREFLIGHT-001..003 and H-NEW-PREFLIGHT-006 would all fail against current binary (current binary exits 0 with warning, spec requires exit 64 with error). This is expected at F2.

**Tests/holdouts that PASS against both old and new binary (intentional regression pins):**

- H-NEW-PREFLIGHT-004: neither `--field` nor `--on-behalf-of` → exit 0 (regression pin; expected)
- H-NEW-PREFLIGHT-005: JSM path with both flags → exit 0 non-mis-fire (expected)
- AC-4 (`test_platform_create_without_inverse_flags_emits_no_new_warnings`): clean path → passes both binaries (spec acknowledges vacuity)

### 7. Crate / version / CI reality

**Cargo.toml**: `rust-version = "1.85"`. `serde_json = "1"` (no `preserve_order`). Confirmed.

**rust-toolchain.toml**: `channel = "stable"`. No MSRV pin.

**ci.yml MSRV job** (line 70):
```yaml
- uses: dtolnay/rust-toolchain@c93f4f9c67595668add93d3d6895795ce52d8c2d  # 1.85.0
```
There is **NO** `with: toolchain: '1.85.0'` input. Without this input, `dtolnay/rust-toolchain` reads `rust-toolchain.toml` → installs `stable`, not 1.85.0. The `# 1.85.0` comment is **misleading** — the job actually validates stable. This is the MSRV false-green defect that #626 in SOH-DX-1 is supposed to fix. **See ADV-P83-MEDIUM-001.**

**SHA pin**: All uses in `ci.yml` (~:70, ~:98), `sign-and-publish.yml` (~:53), and `backfill-release.yml` (~:68) are pinned to `c93f4f9c67595668add93d3d6895795ce52d8c2d`. The spec (delta-analysis.md line 65/85 and session-checkpoints.md P71-001) mandates updating to `fa04a1451ff1842e2626ccb99004d0195b455a88` in S-626-1. The current pin is a valid SHA (confirmed real 2026-03-27) but is **not** the master-ancestor SHA. **See ADV-P83-LOW-001.**

**ci-gate.needs** (`ci.yml` ~:438):
```yaml
needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]
```
Complete and unchanged. ✓

**`rustup target add` steps**:
- `sign-and-publish.yml` ~:64: `run: rustup target add ${{ matrix.target }}` ✓
- `backfill-release.yml` ~:79: `run: rustup target add ${{ matrix.target }}` ✓

Both present, as spec asserted (P71-003 do-not-remove constraint satisfied).

### 8. CLAUDE.md profile taxonomy defect assessment

**Current profile 4 wording** (`CLAUDE.md` Output channels section):
> "**Symmetric** — stdout for `--output json`, stderr for human-readable errors in either mode; state-changing commands that also print a result use this profile."

**Assessment: DEFECTIVE (ambiguous).** The phrase "stdout for `--output json`" correctly describes the JSON data path but does NOT distinguish between:
- JSON SUCCESS data → stdout (via `output::render_json` / `print_output` → `println!`)
- Human-mode SUCCESS notification → **stderr** (via `output::print_success` → `eprintln!`)

Two independent reviewers have interpreted "stdout for `--output json`" as "success → stdout in all modes," and in both cases this caused spec errors:
1. Prior CRITICAL defect (cited in task briefing)
2. v1.3.165 defect: H-NEW-PREFLIGHT-004 asserted "stdout contains PROJ-42" — corrected to "stderr contains Created issue PROJ-42" in v1.3.166

The root cause is that the profile 4 description never explicitly states what happens to human-mode success output. The profile describes ONE path (JSON data → stdout) and ONE error behavior (stderr) but omits the third path (human-mode success notification → stderr via `print_success`).

**Proposed corrected wording:**

> **4. Symmetric** — `--output json` success data to stdout (via `output::render_json` → `println!`); human-mode success notifications to stderr (via `output::print_success` → `eprintln!`); errors to stderr in both modes. State-changing commands that return structured data on success use this profile. **Important:** human-mode success echoes use `print_success` (→ stderr), NOT `print_output` (→ stdout). The JSON data path and the human-mode notification path are on DIFFERENT channels — both emit to stderr or stdout but in opposite directions. Do not infer "success goes to stdout" from "stdout for `--output json`."

**Finding ADV-P83-MEDIUM-002 below documents this as an in-delta REFINEMENT.**

### 9. #661 doc staleness

PR #661 (`d460701d`, 2026-07-29) modified two files. Neither CLAUDE.md description reflects the post-merge state:

**`scripts/check-spec-counts.sh`:** Gained a POL-11 coverage floor check:
```bash
if [ "$BC_FILES_PROCESSED" -eq 0 ]; then
  echo "ERROR: no bc-*.md files found in $FACTORY — nothing to validate" >&2
  exit 2
fi
```
CLAUDE.md (~:367-370) describes the script as "Exits 0 if frontmatter counts match body counts. Exits 1 with specific mismatch details if drift is detected" — does NOT mention `exit 2` on zero-files-found. The description is stale for the exit-2 path.

**`tests/claude_md_citations.rs`:** Gained `CITATION_FLOOR: usize = 74` (floor(0.75 × 99)) at ~:416. CLAUDE.md (~:385-390) describes the test but does NOT mention the floor or its rationale. Without this, a future maintainer who guts the CLAUDE.md citation format would see the test pass vacuously (all citations extracted = 0 < 74 is false, so the floor prevents this).

**Provenance:** Both changes are in commit `d460701d` (2026-07-29). The commit message explicitly states these defects are "PRE-EXISTING and OUT-OF-DELTA relative to the active SOH-DX-1 cycle." This is an OUT-OF-DELTA finding. **See ADV-P83-LOW-002.**

### 10. Test-symbol citations

All test names cited in spec as EXISTING (from S-383) are confirmed present in `tests/issue_create_jsm.rs`:
- `test_platform_create_field_flag_emits_warning_without_request_type` ~:2420 ✓
- `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type` ~:2493 ✓
- `test_platform_create_both_inverse_flags_emit_independent_warnings` ~:2564 ✓
- `test_platform_create_without_inverse_flags_emits_no_new_warnings` ~:2631 ✓
- `test_platform_create_field_idempotent_one_warning_per_logical_flag` ~:2687 ✓
- `test_jsm_create_with_field_and_request_type_does_not_fire_bc_3_8_012` ~:2748 ✓
- `test_platform_create_malformed_field_one_warning_no_exit_64` ~:2812 ✓

`assert_json_error_envelope` cited in spec as currently at `tests/json_error_shape.rs ~:63` — CONFIRMED: `tests/json_error_shape.rs` line 63. The spec notes it will be PROMOTED to `tests/common/fixtures.rs` in F3; this is an expected F3 task, not a phantom.

Test names marked as **F3 deliverables** (do NOT exist yet, correctly absent):
- `test_platform_create_field_flag_exits_64_without_request_type` (AC-1 new name)
- `test_platform_create_on_behalf_of_exits_64_without_request_type` (AC-2 new name)
- `test_platform_create_both_flags_without_request_type_combined_error_once` (AC-3 new name)
- `test_platform_create_help_flags_requires_request_type_in_help` (AC-12)
- `test_jsm_create_with_both_flags_and_request_type_does_not_fire_guards` (AC-21)

These are correctly not present; they are F3 story deliverables in S-639-1.

---

## Finding ID Convention

Finding IDs use the format `ADV-P<PASS>-<SEV>-<SEQ>` (no cycle prefix: `current-cycle` file absent).

---

## Part A — Fix Verification

Not applicable: pass 83 is the first adversarial review pass on the emit-site / observable-contract aperture for spec v1.3.166. No prior findings on this aperture to verify.

---

## Part B — New Findings

### CRITICAL

None.

### HIGH

None.

### MEDIUM

#### ADV-P83-MEDIUM-001: ci.yml MSRV job installs stable, not 1.85.0 — false-green MSRV check

- **Severity:** MEDIUM
- **Classification:** GAP
- **Delta attribution:** IN-DELTA (issue #626, SOH-DX-1 bundle)
- **Category:** ci-correctness
- **Provenance:** Pre-existing defect, first documented in `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` lines 65/85/86.
- **Location:** `.github/workflows/ci.yml` ~:70
- **Description:** `dtolnay/rust-toolchain` is invoked with no `with: toolchain:` input. Without this input, the action reads `rust-toolchain.toml` → installs `stable`, not 1.85.0. The comment `# 1.85.0` is misleading. The `cargo check --all-features` step therefore runs under stable Rust, making the MSRV job a false-green validator.
- **Evidence:**
  ```yaml
  - uses: dtolnay/rust-toolchain@c93f4f9c67595668add93d3d6895795ce52d8c2d  # 1.85.0
  # NO with: toolchain: '1.85.0'
  ```
  `rust-toolchain.toml` says `channel = "stable"`. Without a `toolchain:` input, the action reads `rust-toolchain.toml` and installs `stable`.
- **Proposed Fix:** S-626-1 (F3 story) must add `with: {toolchain: "1.85.0"}` to the dtolnay step AND `env: RUSTUP_TOOLCHAIN: "1.85.0"` to the `cargo check` step so the env var outranks `rust-toolchain.toml`. Fix scope also includes `coverage` job line ~:98 and the five other workflow files per delta-analysis.md.

---

#### ADV-P83-MEDIUM-002: CLAUDE.md output-channel profile 4 description is ambiguous and has caused two spec defects

- **Severity:** MEDIUM
- **Classification:** REFINEMENT
- **Delta attribution:** IN-DELTA (the defect has caused two spec errors in this bundle's F2 window)
- **Category:** spec-fidelity / documentation
- **Provenance:** v1.3.165 defect introduced 2026-07-29 (spec author applied attachment-upload profile-4 reasoning to `issue create`); v1.3.166 corrects holdout H-NEW-PREFLIGHT-004 Expected bullet 3.
- **Location:** `CLAUDE.md` "Output channels" section, profile 4 entry
- **Description:** Current wording: "stdout for `--output json`, stderr for human-readable errors in either mode." Does NOT state that human-mode success notifications go to stderr via `print_success` (`src/output.rs::print_success` ~:46 is `eprintln!`). Two reviewers independently applied profile 4 reasoning and produced wrong stream assertions. Root cause: the profile description describes the JSON data path (stdout) but omits the human notification path (stderr), creating a false equivalence between "JSON mode → stdout" and "success → stdout."
- **Proposed Fix** (presented for human-gate; does not modify any spec file):

  > **4. Symmetric** — `--output json` success data to stdout (via `output::render_json` → `println!`); human-mode success notifications to stderr (via `output::print_success` → `eprintln!`); errors to stderr in both modes. State-changing commands that return structured data on success use this profile. **IMPORTANT:** human-mode success echoes route through `print_success` (→ stderr), NOT `print_output` (→ stdout). The two paths are on opposite channels — do not infer "success → stdout" from "stdout for `--output json`."

---

### LOW

#### ADV-P83-LOW-001: `dtolnay/rust-toolchain` SHA pin stale across 4 workflow files

- **Severity:** LOW
- **Classification:** GAP
- **Delta attribution:** IN-DELTA (issue #626, SOH-DX-1 bundle)
- **Category:** ci-correctness
- **Provenance:** Pre-existing. Documented in `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` line 85 and `.factory/cycles/cycle-001/session-checkpoints.md` P71-001 (partially discharged out-of-band). SHA `c93f4f9c67595668add93d3d6895795ce52d8c2d` is real (2026-03-27) but NOT the master-ancestor. SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` is confirmed real (2026-06-30, "Add 1.96.1 patch release") and IS a master ancestor.
- **Location:** `.github/workflows/ci.yml` ~:70/~:98, `.github/workflows/sign-and-publish.yml` ~:53, `.github/workflows/backfill-release.yml` ~:68
- **Description:** All 4 uses pin `c93f4f9c67595668add93d3d6895795ce52d8c2d`. Mandated: `fa04a1451ff1842e2626ccb99004d0195b455a88`.
- **Proposed Fix:** S-626-1 must update all 4 (and any other workflow files containing the same SHA) to `fa04a1451ff1842e2626ccb99004d0195b455a88`. Note: when the ci.yml MSRV job is re-pinned, verify that the `# 1.85.0` comment remains accurate — `fa04a145` is tagged "Add 1.96.1 patch release", so the comment should be adjusted or the `toolchain: '1.85.0'` input is what controls the actual version, not the SHA.

---

#### ADV-P83-LOW-002: CLAUDE.md descriptions of `scripts/check-spec-counts.sh` and `tests/claude_md_citations.rs` stale after #661

- **Severity:** LOW
- **Classification:** REFINEMENT
- **Delta attribution:** OUT-OF-DELTA (commit `d460701d`, 2026-07-29; commit message explicitly states "PRE-EXISTING and OUT-OF-DELTA relative to the active SOH-DX-1 cycle")
- **Category:** documentation
- **Location:** `CLAUDE.md` ~:367-370 (`check-spec-counts.sh` description), ~:385-390 (`claude_md_citations.rs` description)
- **Description:** `scripts/check-spec-counts.sh` gained POL-11 coverage floor: exits 2 (not just 0/1) when zero bc files processed. `tests/claude_md_citations.rs` gained `CITATION_FLOOR: usize = 74` constant preventing vacuous pass when `extract_path_citations` returns empty. Neither addition is documented in CLAUDE.md.
- **Proposed Fix:** Add one-line note to each CLAUDE.md description: for check-spec-counts.sh mention `exit 2` on empty-spec-directory; for claude_md_citations.rs mention CITATION_FLOOR floor check. Low urgency (out-of-delta).

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 2 |
| LOW | 2 |

**Overall Assessment:** pass-with-findings
**Convergence:** CONVERGENCE_REACHED (zero in-delta GAPs; two MEDIUM and two LOW findings; all IN-DELTA items are pre-tracked CI issues and documentation ambiguity; no spec GAPs found)
**Readiness:** ready for next phase

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 83 |
| **New findings** | 4 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 1.0 (4/4 — first pass on emit-site/observable-contract aperture at v1.3.166) |
| **Median severity** | 2.0 (LOW–MEDIUM range; no CRITICAL or HIGH) |
| **Trajectory** | first pass on this aperture (emit-site verification) for spec v1.3.166 |
| **Verdict** | CONVERGENCE_REACHED |

ADV-P83-MEDIUM-001 and ADV-P83-LOW-001 confirm pre-tracked CI issues from delta-analysis.md (#626);
ADV-P83-MEDIUM-002 is the mandatory item-8 taxonomy assessment; ADV-P83-LOW-002 is the mandatory item-9
#661 staleness check. No in-delta spec GAPs found. All observable contracts verified at
their emit sites; the spec (v1.3.166) is correct and consistent across bc-3-issue-write.md,
error-taxonomy.md, and holdout-scenarios.md. The implementation gap (create.rs still
warn-and-proceed) is an expected pre-F3 state, not a spec defect.

---

**VERDICT: CLEAN (no in-delta GAPs)**
