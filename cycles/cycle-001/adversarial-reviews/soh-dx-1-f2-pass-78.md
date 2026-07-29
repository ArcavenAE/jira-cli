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
  - .factory/phase-f1-delta/SOH-DX-1/delta-analysis.md
  - prd/BC-INDEX.md
  - prd/holdout-scenarios.md
  - prd/nfr-catalog.md
  - prd/error-taxonomy.md
input-hash: "bf70fc3"
traces_to: bc-3-issue-write.md
pass: 78
previous_review: null
cycle: cycle-001
bundle: SOH-DX-1
aperture: verification-adequacy
spec_version: v1.3.163
date: 2026-07-29
basis: DEC-190 substitute (consistency-validator, not adversary agent)
isolation: sibling reviews not read
---

# Adversarial Review — SOH-DX-1 F2, Pass 78
## Aperture: Verification Adequacy

Does the verification design for SOH-DX-1 actually catch a broken implementation? This
review examines whether the mandated tests and verification properties would FAIL if the
implementation were wrong, rather than whether the spec text is internally consistent.

---

## Finding ID Convention

Finding IDs for this pass: `ADV-C001-P78-<SEV>-<SEQ>` (cycle-001, pass 78).

No findings were identified. The remainder of this document records the checklist evidence
supporting the CLEAN verdict.

---

## Perimeter (Files Actually Read)

- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-3-issue-write.md` —
  PRIMARY (BC-3.8.012/013 bodies, §3.8, delivery obligations, AC-1..21, trace, note on VP
  deliberate non-goal)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/BC-INDEX.md` — spec version
  provenance (v1.3.163 recorded here; v1.3.162 in bc-3 frontmatter)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/holdout-scenarios.md` — full
  holdout inventory (grepped for SOH-DX-1 / BC-3.8.012 / BC-3.8.013 / on-behalf-of)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/nfr-catalog.md` — grepped for
  SOH-DX-1, DEC-188, breaking-change, SEMVER NFR entries
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/error-taxonomy.md` — Section 6
  Issue Commands subsection (F52-001 registration, v1.3.150)
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md`
  — impact boundary, regression risk assessment, story decomposition, F2 spec evolution needs
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/stories/S-383-platform-inverse-warnings.md`
  — historical story superseded by S-639-1; AC namespace note
- `/Users/zious/Documents/GITHUB/jira-cli/src/cli/issue/create.rs` — current implementation
  (still has OLD eprintln! behavior; S-639-1 not yet implemented)
- `/Users/zious/Documents/GITHUB/jira-cli/tests/issue_create_jsm.rs` (lines 2420–2870) —
  current test bodies for AC-1..7 (still test OLD exit-0 behavior)
- `/Users/zious/Documents/GITHUB/jira-cli/.cargo/mutants.toml` — examine_globs scope
- `/Users/zious/Documents/GITHUB/jira-cli/docs/specs/cargo-mutants-policy.md` — scope
  citation for `src/cli/issue/create.rs`
- `/Users/zious/Documents/GITHUB/jira-cli/Cargo.toml` + `Cargo.lock` — wiremock version
  (0.6.5) and dependency declarations
- `/Users/zious/Documents/GITHUB/jira-cli/tests/issue_create_json.rs` (lines 344–411) —
  confirmed `received_requests()` pattern in existing tests

---

## Checklist Coverage

### Item 1 — Verification-Property Adequacy

The spec explicitly declares "Holdout-scenario and VP coverage are a deliberate non-goal
for S-639-1" in both BC-3.8.012 and BC-3.8.013. **Zero formal VPs** are assigned to this
delta.

Assessment: the VP-level concerns are fully absorbed into the 21 AC suite:

| VP-level concern | AC capturing it | Would fail if implementation is wrong? |
|---|---|---|
| Zero HTTP on guarded path | AC-8 (`received_requests().is_empty()` on isolated MockServer) | YES — guard-absent path attempts HTTP |
| Guard fires before project-key resolution | AC-9 (`!stderr.contains("Project key")` DISCRIMINATING) | YES — wrong order produces "Project key" on stderr |
| Guard fires before interactive prompts | AC-9 + AC-11 (same ordering observable) | YES |
| Guard fires regardless of `--output json` | AC-2/AC-10 (json mode), AC-1 (human mode) | YES — both modes tested |
| JSM path non-mis-fire | AC-6/AC-20/AC-21 | YES — exit 0 on JSM path would fail if guard mis-fires |
| Idempotency per logical flag | AC-5 (multiple `--field` occurrences → ONE error) | YES — multiple errors would fail the assertion |
| Combined error fires before individual errors | AC-3 (combined error string asserted) | YES — if `--field`-only check fires first, combined string absent |

The deliberate non-goal rationale is sound: both guards are `!field_pairs.is_empty()` and
`on_behalf_of.is_some()` checks with no network interaction. Any holdout scenario would
duplicate exactly what AC-1..8 already assert.

**Defects a VP-less suite MISSES:** None identified for this specific delta. A VP would
add no discriminating power over the existing ACs for pure pre-flight boolean guards.

VERDICT: CLEAN. No VP gap.

---

### Item 2 — Guard-Behavior Test Adequacy for #639

The 21 ACs cover the following distinct behavioral cases:

| Case | ACs covering it | Guard-absent would fail the test? |
|---|---|---|
| `--field` present alone, platform path | AC-1 (human), AC-10 (json) | YES — exit-0 instead of exit-64 |
| `--on-behalf-of` present alone, platform path | AC-2 (json), AC-8ii (zero-HTTP) | YES |
| Both flags together | AC-3 (combined error) | YES — combined string absent if single-flag check fires first |
| Neither flag (clean path regression) | AC-4 (would-otherwise-succeed, exit-0) | N/A — correct behavior tested |
| Multiple `--field` occurrences (idempotency) | AC-5 | YES — wrong count of errors |
| `--field` on JSM path (non-mis-fire regression) | AC-6/AC-21 | YES — guard mis-fire → exit-64 |
| Malformed `--field` (no `=`) | AC-7 | YES — old behavior was exit-0 |
| Zero-HTTP proof | AC-8 | YES — any HTTP emitted is caught |
| Ordering pin (before project-key resolution) | AC-9 (`!stderr.contains("Project key")`) | YES — wrong order → "Project key" appears |
| `--field` alone, json mode | AC-10 | YES |
| Interactive path (TTY via JR_STDIN_IS_TTY=1) | AC-11 | YES |
| Help-text contains "requires --request-type" | AC-12 | YES if delivery item (d) omitted |
| `--on-behalf-of` on JSM path | AC-20/AC-21 | YES |
| Empty `--on-behalf-of ""` | AC-16 | YES — empty value still triggers `is_some()` |
| `--field a=` (empty value after key) | AC-19 | YES |
| `--markdown --field` ordering (BC-3.8.012 before BC-3.8.017) | AC-17 | YES |

Each AC uses a "would-otherwise-succeed" invocation (with `mount_platform_create_stubs`
or equivalent) — meaning a guard-absent run completes normally and the positive exit-64
assertion has genuine discriminating power.

VERDICT: CLEAN. All distinct behavioral cases are covered.

---

### Item 3 — Ordering-Invariant Verification

The spec claims guards fire: BEFORE project-key resolution (step 3), BEFORE interactive
prompts, BEFORE all pre-POST helper HTTP (steps 3–5), and BEFORE the platform POST (step 6).

**AC-9 pins ordering vs. project-key resolution:**
- Invocation: `jr issue create --field a=b` with no `--project` and no profile-level
  project key
- Discriminating assertion: `!stderr.contains("Project key")` (LABELED DISCRIMINATING in spec)
- Would fail if guard is at wrong position: if guard is placed AFTER project-key resolution,
  the missing-project error `"Project key is required..."` appears on stderr and the assertion
  fails. If guard is at step 2 (correct), project-key resolution never runs and the string
  is absent.

**AC-8 pins ordering vs. all HTTP:**
- Uses `received_requests().await.unwrap().is_empty()` on isolated MockServer
- Would fail if ANY HTTP is issued before the guard fires
- The mock set includes `expect(0)` on GET /rest/api/3/field (first reachable HTTP if
  guard-absent; labeled DISCRIMINATING in spec) — superseded by the NORMATIVE
  `received_requests()` assertion which catches ALL HTTP including unregistered paths

**Assessment:** These are ORDER-sensitive assertions (not merely end-state). They distinguish
the correct order from a wrong order. A guard placed at step 4 (after project-key resolution)
would cause AC-9 to fail. A guard placed after any HTTP call would cause AC-8 to fail.

VERDICT: CLEAN. Ordering invariants are pinned by genuinely falsifiable order-sensitive assertions.

---

### Item 4 — Zero-HTTP Proof Soundness

**wiremock version:** 0.6.5 (confirmed in `Cargo.lock`).

**`received_requests()` behavior:** In wiremock 0.6.5, `MockServer::received_requests()`
returns ALL requests received by the server, regardless of whether they match a registered
mock. An unregistered-path request triggers a 404 response from wiremock AND is still
recorded in `received_requests()`. This was confirmed via:
1. The existing test at `tests/issue_create_json.rs:411` uses this pattern identically
2. The spec changelog entry (v1.3.129 F31-2) explicitly notes this: "catches ALL HTTP
   including unregistered endpoints that 404 silently past expect(0)"
3. The `unwrap()` panics if request recording is unavailable, producing test failure rather
   than silent pass

**Isolated MockServer requirement:** AC-8 mandates a DEDICATED MockServer instance (MUST
NOT call `mount_platform_create_stubs` on it). This prevents cross-test request contamination.
The wiremock FIFO mock-matching rationale is cited in the spec (same pattern as
`tests/issue_create_jsm.rs` BC-3.9.006 fixture).

**Why `expect(0)` alone is insufficient:** An unregistered path would 404 without tripping
`expect(0)` on registered mocks (as documented by spec note v1.3.129 F31-2). The
`received_requests().is_empty()` pattern supersedes `expect(0)` and is labeled NORMATIVE
in the spec.

VERDICT: CLEAN. Zero-HTTP proof is sound and detects requests to unregistered paths.
`received_requests()` is confirmed to work in wiremock 0.6.5 via existing test evidence.

---

### Item 5 — Regression-Protection for the Breaking Change

The breaking change: `--field`/`--on-behalf-of` without `--request-type` flips from exit-0
to exit-64. The clean-path regression test is AC-4.

**AC-4 specification:**
- Invocation: `jr issue create --project PROJ --type Task --summary "test" --output json`
  (neither flag present)
- `mount_platform_create_stubs` MUST be called (ensures the command would otherwise succeed;
  without stubs the test fails for the wrong reason)
- Assertions: exit 0; absence of new error substrings ("--field is only valid with",
  "--on-behalf-of is only valid with", combined string)

**Would an unconditional guard break AC-4?** YES:
- An unconditional guard (`if true { return Err(JrError::UserError(...)) }`) would produce
  exit 64 on the clean path, failing the `exit 0` assertion
- The new negative assertions additionally catch a "soft" regression (emitting error strings
  without exit-64), though this is belt-and-suspenders over the exit-0 pin

**AC-6/AC-20/AC-21 vacuity concern:** After implementation removes the old `eprintln!`
warn strings, the existing AC-6/AC-20/AC-21 bodies (which assert absence of OLD warn
strings) become vacuously true for their negative assertions. The spec explicitly mandates
body updates at F3: "At F3 re-point to assert exit 0 + absence of the NEW error substrings."
These mandates are in the authoritative BC Trace (BC-3.8.012 and BC-3.8.013). If properly
executed at F3, the tests regain discriminating power. This is a F3 story authoring quality
concern, not a F2 spec adequacy gap.

VERDICT: CLEAN. Regression protection is adequate. AC-4 is non-vacuous (mount stubs +
exit-0 + new-string absence). The AC-6/20/21 vacuity-to-non-vacuity transition is explicitly
mandated.

---

### Item 6 — Holdout-Scenario Coverage

Grepped `holdout-scenarios.md` for: `SOH-DX-1`, `BC-3.8.012`, `BC-3.8.013`,
`on-behalf-of`, `pre-flight.*exit.64`, `DEC-188`. **Result: 0 matching holdout scenarios.**

The spec explicitly declares: "Holdout-scenario and VP coverage are a deliberate non-goal
for S-639-1. The 21 ACs (AC-1..21) fully cover every observable exit path for both
BC-3.8.012 and BC-3.8.013... Because both guards are pure pre-flight input-validation
checks with no network interaction, there is no integration surface for a holdout scenario
to probe — any holdout assertion would duplicate what the ACs already assert."

**Breaking change coverage:** This delta IS a breaking change (exit-0 → exit-64 for
existing callers). The holdout evaluator (Phase 4) has no scenario to independently verify
this behavior from the binary. HOWEVER, a holdout scenario for this behavior would be:
`jr issue create --project P --type T --summary S --field a=b` → exit 64, stderr contains
"--field is only valid with". This is byte-for-byte what AC-1 asserts. The "any holdout
assertion would duplicate the ACs" rationale is accurate.

**Adequacy assessment:** The holdout evaluator DOES independently observe behavior — but
for these pure string-check guards, the AC suite provides equivalent coverage via the
binary process-spawn pattern (`assert_cmd` + `Command::cargo_bin`). The absence is
deliberately reasoned and the rationale is sound.

VERDICT: CLEAN. 0 holdout scenarios; deliberate non-goal with adequate justification.

---

### Item 7 — Mutation-Testing Scope

`src/cli/issue/create.rs` is listed in `.cargo/mutants.toml::examine_globs`:
```
"src/cli/issue/create.rs",
```
The `docs/specs/cargo-mutants-policy.md` §Scope confirms: "`src/cli/issue/create.rs` —
`handle_create` (platform-path `issue create` logic) and `parse_field_kv`".

**New guard code location:** The DEC-188 guards are in `handle_create`. At F4, they will
be new/changed lines in the PR diff. The CI invocation uses `cargo mutants --in-diff
$DIFF_FILE` which narrows mutations to CHANGED lines only. The new guard lines ARE in the
diff, so mutations of:
- `!field_pairs.is_empty()` → guard-absent or inverted → killed by AC-4 (exit-0 regression)
  or AC-1 (exit-64 expectation fails)
- `on_behalf_of.is_some()` → similar kills
- `return Err(JrError::UserError(...))` → killed by any AC asserting exit 64

**Kill rate:** For simple boolean guards that are fully AC-covered, expect near-100% kill
rate. The existing `create.rs` mutations have an established test suite (the pre-DEC-188
AC suite); post-DEC-188, the inverted tests provide strong guard coverage.

VERDICT: CLEAN. Guard mutations will be caught by the AC suite.

---

### Item 8 — NFR / Error-Taxonomy Registration

**Error taxonomy:** All three DEC-188 pre-flight conditions are registered in
`error-taxonomy.md` Section 6 "Issue Commands" subsection (added v1.3.150, F52-001,
2026-07-27):

| Condition | Error String | Exit Code |
|---|---|---|
| `--field` without `--request-type` (BC-3.8.012) | `"--field is only valid with --request-type..."` | 64 |
| `--on-behalf-of` without `--request-type` (BC-3.8.013) | `"--on-behalf-of is only valid with --request-type..."` | 64 |
| Both flags without `--request-type` (combined, BC-3.8.012 governs) | `"--field and --on-behalf-of are only valid with..."` | 64 |

Exit code 64 is correct per `JrError::exit_code()` for `JrError::UserError` variants.
Error strings are verbatim copies from the BC fenced blocks. This registration is IN-DELTA
(v1.3.150, dated 2026-07-27).

**NFR catalog:** No NFR entries are required for this behavioral flag-validation change.
SEMVER implications (0.7.0-dev.1 bump) are governed by DEC-188 (release policy), not an
NFR catalog entry. The breaking-change CHANGELOG entry is a delivery obligation in the BC
Trace, not an NFR concern.

VERDICT: CLEAN. Error taxonomy correctly registered with correct exit codes.

---

### Item 9 — False-Green Sweep Across the ACs

Checked every AC asserting a non-event (exit 0, empty stdout, absence of substring) to
determine whether it pins a would-otherwise-succeed invocation:

**AC-4 (exit 0, clean path):** `mount_platform_create_stubs` MUST be called. Without stubs,
the test fails for the wrong reason (no response to the POST). With stubs, an unconditional
guard would produce exit-64, catching the regression. NOT false-green.

**AC-6 (JSM path, exit 0, no guard fires):** OLD body asserts absence of old warn strings.
These become vacuous after implementation removes `eprintln!`. The spec MANDATES body update
at F3 to assert: exit 0 + absence of new error substrings. If update is performed, NOT
false-green. If update is omitted, the JSM non-mis-fire assertion degrades to HYGIENE.
This is a F3 story authoring risk, explicitly mandated to fix in both delta-analysis.md
and the BC Trace.

**AC-20 / AC-21 (JSM path with `--on-behalf-of` + `--request-type`):** Same vacuity risk
as AC-6. Same mandate. Same F3 authoring concern.

**AC-8 (zero-HTTP, isolated MockServer):** Exit code not the assertion target. The
`received_requests().is_empty()` assertion would pass vacuously only if the test binary
makes no requests — which is true when the guard fires correctly (no HTTP). If the guard
is absent, the binary makes HTTP calls, and `received_requests()` becomes non-empty. NOT
false-green.

**AC-12 (help-text pin, count == 2):** `stdout.matches("requires --request-type").count() == 2`
after whitespace normalization. This would pass vacuously if "requires --request-type"
appears MORE than twice in the help output. Checking the current help text (delivery
obligation (d) adds the substring to both `--field` and `--on-behalf-of` first doc lines),
the count-2 assertion is specifically discriminating: exactly 2 occurrences means BOTH
flags were updated. NOT false-green for the intended defect class.

**Summary of false-green risk:** The AC-6/AC-20/AC-21 vacuity-to-non-vacuity issue is the
only substantive risk. It is ALREADY IDENTIFIED in the spec and MANDATED to be fixed at
F3. No unmarked vacuous assertions found that the spec has not already addressed.

VERDICT: CLEAN at spec level. The mandate for AC-6/AC-20/AC-21 body updates is explicit
and in the authoritative BC Trace.

---

## Part B — New Findings (or all findings for pass 1)

No findings. All nine checklist items resolved CLEAN.

The spec at v1.3.163 for SOH-DX-1 has undergone approximately 50+ adversary correction
rounds (v1.3.107 through v1.3.163 for this bundle) and the verification design is mature.
The AC suite is well-specified with labeled discriminating assertions, ordered proofs, and
explicit body-update mandates for tests that transition from old to new behavior.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 0 |

**Overall Assessment:** pass
**Convergence:** CONVERGENCE_REACHED
**Readiness:** ready for next phase

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 78 |
| **New findings** | 0 |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 0.00 (0 new / 0 total) |
| **Median severity** | N/A (no findings) |
| **Trajectory** | →0 (converged; zero new findings this pass) |
| **Verdict** | CONVERGENCE_REACHED |
