---
bundle: SOH-DX-1
issues: "#639, #627, #626"
ratified: 2026-07-25
intent: enhancement
feature_type: infrastructure
trivial_scope: false
severity: N/A
wave: 1
stories_proposed: S-639-1, S-627-1, S-626-1
---

# Delta Analysis — SOH-DX-1

Bundle of three independent enhancements ratified 2026-07-25 after fresh-context probe validation.

---

## 1. Impact Boundary

### Item 1 — #639: warn→error promotion (BREAKING)

**Nature:** MODIFIED existing behavior — pre-flight exit-64 replaces stderr-warning+exit-0 for
`--field` and `--on-behalf-of` when used without `--request-type` on `jr issue create`.

| Component | Change Type | Notes |
|-----------|-------------|-------|
| `src/cli/issue/create.rs` | MODIFIED | Lines 81–90: `eprintln!` guard block replaced with `return Err(JrError::UserError(...))` pre-flight exits. Guard modeled on `src/cli/issue/edit.rs::handle_edit` mutual-exclusion block. Placement unchanged (BEFORE platform POST, AFTER dispatch fork at line 49). |
| `tests/issue_create_jsm.rs` | MODIFIED | 5 tests invert: AC-1 (`test_platform_create_field_flag_emits_warning_without_request_type`), AC-2 (`test_platform_create_on_behalf_of_flag_emits_warning_without_request_type`), AC-3 (`test_platform_create_both_inverse_flags_emit_independent_warnings`), AC-5 (`test_platform_create_field_idempotent_one_warning_per_logical_flag`), AC-7 (`test_platform_create_malformed_field_one_warning_no_exit_64` → **MUST BE RENAMED**: post-flip the name `no_exit_64` directly contradicts the new behavior; rename to `test_platform_create_malformed_field_without_request_type_exits_64` following the `test_<verb>_<subject>_<expected_outcome>` convention). All flip from exit-0 assertions to exit-64. ~~AC-4 unaffected~~ — **AC-4 test BODY must be updated** (adversary pass-3 F-05): `test_platform_create_without_inverse_flags_emits_no_new_warnings` remains exit-0 but its negative assertions become vacuously true post-flip; at F3 add explicit absence-of-new-error-substrings assertions (`"--field is only valid with"` and `"--on-behalf-of is only valid with"` must be absent from stderr on the clean path). ~~AC-6 genuinely unchanged~~ — **AC-6 test BODY must be updated** (pass-6 F-1): `~~`test_jsm_create_field_flag_doesnt_fire_bc3_8_012_on_jsm_path`~~ → `test_jsm_create_with_field_and_request_type_does_not_fire_bc_3_8_012`` (pass-4 correction; real symbol at `tests/issue_create_jsm.rs:2748`) currently asserts absence of the old BC-3.8.012 warn string; once warn strings are removed that negative assertion goes vacuous. At F3 re-point to assert exit 0 + absence of the NEW error substrings (`"--field is only valid with"` and the combined-flag string) to keep the JSM-regression gate meaningful. |
| `Cargo.toml` | MODIFIED | Version bump to `0.7.0-dev.1` (DEC-188 clause (d): breaking change rides the 0.6→0.7 train bump). Must be in S-639-1's commit. |
| `CHANGELOG.md` | MODIFIED | `### Breaking Changes` entry under the 0.7.0 section. SEMVER resolved: this is a MINOR bump (DEC-188 clause (d)). |
| `.factory/specs/prd/bc-3-issue-write.md` (factory-artifacts) | MODIFIED | BC-3.8.012 body superseded: "warning path, not an error path" → "exit-64 pre-flight UserError before any HTTP". BC-3.8.013 body superseded identically. Amendment note at ~line 481 (the `[UPDATED 2026-05-18 issue #288; amended 2026-05-19 issue #383]` block) updated to reflect exit-64 behavior. **No total_bcs change** — supersession amends existing bodies, no new BC numbers. BC count stays at 657. |
| `.factory/specs/prd/BC-INDEX.md` (factory-artifacts) | MODIFIED | Section 3.8 rows for BC-3.8.012 and BC-3.8.013: summary text updated to reflect "exits 64 pre-flight" behavior. Section header comment updated. |
| `CLAUDE.md` | MODIFIED | S-288-pr4 dispatch-fork gotcha at line 248 (`"absent → platform path byte-for-byte unchanged"`) becomes stale — after #639 the platform path is no longer byte-for-byte unchanged when `--field` or `--on-behalf-of` are present (it exits 64 pre-flight instead). Must be updated in the SAME commit as the code change. Distinct from the Item 3 CLAUDE.md change (toolchain masking gotcha); both land on develop but in separate story commits. |
| `docs/adr/0014-jsm-request-type-dispatch.md` | MODIFIED | Line 161 carries the same `"byte-for-byte unchanged"` claim about the platform path. Requires an amendment note in the same commit (not a new ADR — see §4 "no new ADR warranted"). |

**Asymmetry rationale to encode in spec:** `--on-behalf-of` and `--field` are self-declared
JSM-only flags (their semantics are undefined on the platform path and they declare their purpose
in their names/help text) → caller error (exit 64). `--team`/`--points` (BC-3.8.010/011) stay
warn-only because they are general platform flags the JSM API happens not to support — the
flag choice is ambiguous, not self-evidently wrong.

### Item 2 — #627: PG-365-1 guard regex latent false-positive

**Nature:** MODIFIED CI script; MODIFIED factory-artifacts spec files (revert workaround).

| Component | Change Type | Notes |
|-----------|-------------|-------|
| `scripts/check-bc-no-numeric-test-counts.sh` | MODIFIED | Line 55 PATTERN: add left-boundary negative-class `[^[:alnum:].#-]` (or equivalent POSIX ERE negative lookaround workaround) before `[0-9]+`. The boundary must exclude digits that are part of CWE-NNN, BC-S.SS.NNN dotted IDs, `#NNN` issue refs, and `vN.N.NNN` version strings. True-positive forms ("16 wiremock tests", "3 tests", etc.) must still trigger. Add `--self-test` and `--bc-dir` CLI seam (copy pattern from `scripts/check-bc-citation-symbols.sh` lines 261–302). Hardcoded `BC_DIR` at line 14 becomes the fallback default; `--bc-dir` overrides it. |
| `.factory/specs/prd/bc-2-issue-read.md` (factory-artifacts) | MODIFIED | Revert commit 8a0a2422 hyphenation workaround: restore "wiremock tests" (unhyphenated) in Trace fields where the workaround was applied. |
| `.factory/specs/prd/bc-3-issue-write.md` (factory-artifacts) | MODIFIED | Same revert: restore "wiremock tests" in affected Trace fields. Also intersects with Item 1 edits (BC-3.8.012/013 supersession) — both touch bc-3 but at non-overlapping sections; deliver as atomic factory-artifacts commit after script fix is merged. |
| `.github/workflows/ci.yml` | DEPENDENT | spec-guard job at lines 121–128 runs the script via `bash scripts/check-bc-no-numeric-test-counts.sh`. No ci.yml change required — it inherits the fixed script after develop merge. |

**Hard sequencing constraint:** script fix on develop MUST merge before factory-artifacts
revert is applied. The ci.yml spec-guard fetches factory-artifacts into a worktree and runs
the script from develop — if the old PATTERN runs against reverted bc files ("wiremock tests"),
it flags them. Script-first ordering eliminates this window.

### Item 3 — #626: rust-toolchain SHA pins + MSRV false-green

**Nature:** MODIFIED CI workflow files; MODIFIED CLAUDE.md.

| Component | Change Type | Notes |
|-----------|-------------|-------|
| `.github/workflows/ci.yml` | MODIFIED | Line 98 (stable pin): `c93f4f9c` → verified master-ancestor SHA with `toolchain` input declared + add `with: {toolchain: stable}`. Line 70 (msrv job, currently `c93f4f9c` with comment `# 1.85.0`): update SHA + add `with: {toolchain: "1.85.0"}` input. Add `env: {RUSTUP_TOOLCHAIN: "1.85.0"}` to the `cargo check` step of the msrv job so it outranks rust-toolchain.toml's `channel = "stable"`. |
| `.github/workflows/backfill-release.yml` | MODIFIED | Line 68: same SHA replacement + explicit `toolchain: stable` input. |
| `.github/workflows/e2e-sweeper.yml` | MODIFIED | Line 74: same. |
| `.github/workflows/e2e.yml` | MODIFIED | Line 80: same. |
| `.github/workflows/release.yml` | MODIFIED | Line 38: same. |
| `.github/workflows/sign-and-publish.yml` | MODIFIED | Line 53: same. |
| `CLAUDE.md` | MODIFIED | Add gotcha note under "Gotchas" section: `rust-toolchain.toml` outranks `rustup default` — the msrv job's `dtolnay/rust-toolchain` installs 1.85.0 but without `RUSTUP_TOOLCHAIN` env the `cargo check` step follows the toml's `channel = "stable"`, making the msrv job silently validate stable not 1.85.0. The `RUSTUP_TOOLCHAIN` env fix is the correct override (process-level, outranks toml). |
| `sign-and-publish.yml` (defensive `rustup target add`, lines ~58–64) | DEPENDENT | The E0463 comment at line 60 + `rustup target add` at line 64 exist because cross-compilation targets are not pre-installed by the SHA-pinned stable toolchain. After the SHA fix these steps may still be needed for musl/windows cross-compilation targets — assess at F4 whether they can be removed. Flag only; do NOT remove in this story. |
| `backfill-release.yml` (same pattern, lines ~73–79) | DEPENDENT | Same as above. |

---

## 2. Regression Risk Assessment

| Item | Module | Risk Level | Rationale |
|------|--------|------------|-----------|
| #639 | `src/cli/issue/create.rs` | HIGH | BREAKING exit-code change. Any caller passing `--field` or `--on-behalf-of` without `--request-type` flips from exit-0 to exit-64. Wiremock test suite covers the inversion. E2E tests: `e2e_live.rs` must be scanned for any invocations of `issue create --field` without `--request-type`; if found, those scenarios become exit-64 in live runs. |
| #639 | `tests/issue_create_jsm.rs` | HIGH | 5 tests invert. Inversion affects assertions on exit code, stderr content (error message vs warning), and stdout (no `{"key":...}` on exit-64). Test bodies require significant rewrite, not just a one-line flip. |
| #627 | `scripts/check-bc-no-numeric-test-counts.sh` | LOW | Script-only change. Regression risk is false-negative (new regex passes a violation that should be caught). Property to preserve: true-positive forms still trigger. Self-test seam validates this. |
| #627 | factory-artifacts bc-2/bc-3 | LOW | Spec-file revert. Risk is CI red if script fix hasn't landed yet — sequencing constraint above eliminates. |
| #626 | `.github/workflows/*.yml` | LOW | SHA substitutions in 6 files. All 6 currently use the same `c93f4f9c` SHA (same broken pin). Risk is introducing a bad SHA. Mitigation: validate `fa04a145...` against dtolnay/rust-toolchain git log before F4. |
| #626 | MSRV `cargo check` env fix | MEDIUM | After the fix, `cargo check` in the msrv job runs under 1.85.0 for real. If any current codebase code uses a feature requiring >1.85.0, CI will fail. This is the desired behavior (surfaces real violations) but may require a fix to codebase or MSRV bump. Risk is latent, not introduced by the change. |

### Tests Pinning Current Exit-0 Behavior (Item 1 blast radius)

Exact test identifiers in `tests/issue_create_jsm.rs` that assert exit-0 and must invert to exit-64:

1. `test_platform_create_field_flag_emits_warning_without_request_type` (AC-1, line ~2420)
2. `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type` (AC-2, line ~2493)
3. `test_platform_create_both_inverse_flags_emit_independent_warnings` (AC-3, line ~2564)
4. `test_platform_create_field_idempotent_one_warning_per_logical_flag` (AC-5, line ~2687)
5. `test_platform_create_malformed_field_one_warning_no_exit_64` (AC-7, line ~2812)

Tests that remain exit-0:
- ~~`test_platform_create_without_inverse_flags_emits_no_new_warnings` (AC-4) — unaffected~~ →
  **exit code stays 0 but test BODY requires update** (adversary pass-3 F-05): negative assertions
  are vacuously true post-flip; F3 must add assertions that the new error substrings
  `"--field is only valid with"` and `"--on-behalf-of is only valid with"` are ABSENT from
  stderr on the clean (no-flag) path. Without this, a regression that emits the error
  unconditionally would pass AC-4 silently.
- ~~`test_jsm_create_with_field_and_request_type_does_not_fire_bc_3_8_012` (AC-6) — genuinely unchanged~~ → **test BODY must be updated** (pass-6 F-1): old negative assertion against BC-3.8.012 warn string goes vacuous once warn strings are removed; F3 must re-point to assert exit 0 + absence of new error substrings (`"--field is only valid with"`, combined-flag string) to keep the JSM-dispatch regression gate meaningful. (Real symbol confirmed at `tests/issue_create_jsm.rs:2748`.)
- `test_jsm_create_without_request_type_uses_platform_path` (AC-002) — no `--field`/`--on-behalf-of`, unaffected.

---

## 3. Story Decomposition

### Proposed Stories

**S-639-1**: warn→error promotion for `--field` and `--on-behalf-of` on platform path

- Scope: `src/cli/issue/create.rs` guard block (lines 81–90 rewrite); `tests/issue_create_jsm.rs`
  (5 test inversions); `CHANGELOG.md`; factory-artifacts BC-3.8.012/013 supersession + BC-INDEX.md
  rows + amendment note at bc-3-issue-write.md ~line 481.
- Feature type: backend + spec
- BREAKING CHANGE flag: yes

**S-627-1**: fix PG-365-1 guard regex + self-test seam + factory-artifacts revert

- Scope: `scripts/check-bc-no-numeric-test-counts.sh` (regex + seam);
  factory-artifacts bc-2-issue-read.md + bc-3-issue-write.md (revert hyphenation).
- Feature type: infrastructure
- Two-phase delivery: script fix PR to develop first; factory-artifacts revert commit after develop merge.

**S-626-1**: fix rust-toolchain SHA pins + MSRV job masking + CLAUDE.md gotcha

- Scope: 6 `.github/workflows/*.yml` files (SHA substitution + `toolchain` input);
  `.github/workflows/ci.yml` (msrv job `RUSTUP_TOOLCHAIN` env + `toolchain` input);
  `CLAUDE.md` (gotcha note).
- Feature type: infrastructure

### Dependency Ordering

```
Wave 1 (parallel): S-639-1, S-626-1, S-627-1 (develop phase)
Wave 1b (after S-627-1 merges to develop): S-627-1 factory-artifacts revert
```

All three stories are code-independent. The factory-artifacts phase of S-627-1 is a
hard post-merge step, not a blocking dependency on the other two stories.

---

## 4. Spec Evolution Needs for F2

### Item 1 (S-639-1)

| Artifact | Change | Branch |
|----------|--------|--------|
| `bc-3-issue-write.md` | BC-3.8.012 body: supersede "Errors: None — this is a warning path, not an error path." → exit-64 UserError semantics with verbatim error string carrying both remedies inline. Add supersession note `[SUPERSEDED 2026-07-25 SOH-DX-1 #639]`. | factory-artifacts |
| `bc-3-issue-write.md` | BC-3.8.013 body: same supersession treatment. | factory-artifacts |
| `bc-3-issue-write.md` | Amendment note at ~line 481 (`[UPDATED 2026-05-18 issue #288; amended 2026-05-19 issue #383]`): append second amendment noting the exit-64 promotion. | factory-artifacts |
| `BC-INDEX.md` | Rows BC-3.8.012 and BC-3.8.013: update summary text to "exits 64 pre-flight (without `--request-type`)". Section 3.8 header comment updated. | factory-artifacts |
| `CHANGELOG.md` | `### Breaking Changes` entry for the flag-promotion behavior change. | develop |

No new BCs, no total_bcs change. The `check-spec-counts.sh` and `check-bc-cumulative-counts.sh`
scripts will pass because only BC bodies change, not counts.

**No new ADR warranted.** The guard pattern (hand-rolled `JrError::UserError` exit-64 before
HTTP) matches the existing mutual-exclusion guard in `edit.rs::handle_edit` (lines ~167–222).
Inline comment in `create.rs` pointing to the edit.rs model is sufficient documentation.
**ADR-0014 amendment required** (`docs/adr/0014-jsm-request-type-dispatch.md:~161`): the
"byte-for-byte unchanged" claim about the platform path becomes false post-#639; add an
amendment note in the same commit as the code change.

### Item 2 (S-627-1)

No new BCs or VPs. The spec changes are purely correctional (revert a workaround introduced
because the lint was broken). No F2 spec evolution document needed beyond the story body.

### Item 3 (S-626-1)

No new BCs or VPs. CLAUDE.md addition is the only spec-adjacent change.

**No new ADR warranted.** The SHA pin policy (pin to master-ancestor SHA + explicit `toolchain`
input) is self-evident from the commit context and CLAUDE.md gotcha entry.

---

## 5. F1 Analysis Surfaces — Items Validations May Have Missed

**Fresh-context consistency audit confirmations (2026-07-25):** exactly 5 inverting tests
(AC-1/2/3/5/7 enumerated above — count confirmed); zero E2E blast radius (no `issue create --field`
without `--request-type` in `tests/e2e_live.rs`); no `#626`/`#627` merge hazard on ci.yml (Items 2
and 3 both touch ci.yml but at non-overlapping sections: Item 3 modifies toolchain pin lines 70/98;
Item 2 is DEPENDENT-only with no ci.yml edit required).

### 5a. Test count discrepancy (Item 1)

The human's scope says "~3 tests invert to exit-64." Careful enumeration yields **5 tests** (AC-1,
AC-2, AC-3, AC-5, AC-7). F2 spec should enumerate all 5 by function name to avoid partial rewrite.

### 5b. BC-3.3.001 amendment note also requires update (Item 1)

The amendment note at `bc-3-issue-write.md:~481` (the `[UPDATED 2026-05-18 issue #288; amended
2026-05-19 issue #383]` block) currently reads: "the platform path now emits stderr warnings
(see BC-3.8.012, BC-3.8.013)". After the promotion, this becomes "the platform path now exits
64 pre-flight (see BC-3.8.012, BC-3.8.013)". This note was cited in the human's scope but its
specific edit content was not enumerated — flag for F2 to address.

### 5c. Idempotency semantics under new error (Item 1)

AC-5 tested that multiple `--field` occurrences emit exactly ONE warning. Under the new behavior,
the pre-flight should still produce ONE error message regardless of how many `--field` flags are
passed (the guard fires on `!field_pairs.is_empty()` — one check, one error). F2 spec should
make this explicit in the new BC-3.8.012 postcondition.

### 5d. `sign-and-publish.yml` and `backfill-release.yml` defensive `rustup target add` (Item 3)

The E0463 comments at `sign-and-publish.yml:~60` and `backfill-release.yml:~74` (with defensive
`rustup target add` at the next line) exist because the SHA-pinned stable toolchain does not
include cross-compilation targets for musl/windows. After the SHA fix these steps remain
necessary for cross-compilation; they are NOT a symptom of the broken SHA (they are a build
requirement). F4 should verify they remain in place and not treat them as fix artifacts.

### 5e. Verified `fa04a145` SHA must be confirmed pre-F4 (Item 3)

The human's scope identifies `fa04a145...` as a genuine master-ancestor SHA for
dtolnay/rust-toolchain. The full SHA has not been confirmed in this analysis — F2 must include
the verification step (git log on the upstream repo or Perplexity research) before F4 embeds
it in 6 workflow files. Substituting an unverified SHA defeats the security purpose of pinning.

---

## 6. Affected-Files Summary

### develop branch changes

```
src/cli/issue/create.rs
tests/issue_create_jsm.rs
CHANGELOG.md
scripts/check-bc-no-numeric-test-counts.sh
.github/workflows/ci.yml
.github/workflows/backfill-release.yml
.github/workflows/e2e-sweeper.yml
.github/workflows/e2e.yml
.github/workflows/release.yml
.github/workflows/sign-and-publish.yml
CLAUDE.md
```

### factory-artifacts branch changes

```
.factory/specs/prd/bc-3-issue-write.md   (BC-3.8.012/013 supersession + amendment note + workaround revert)
.factory/specs/prd/bc-2-issue-read.md    (workaround revert only)
.factory/specs/prd/BC-INDEX.md           (BC-3.8.012/013 row updates)
```

### Files NOT changed (regression baseline)

```
src/cli/issue/jsm_create.rs           (JSM dispatch path — unaffected by #639)
src/cli/issue/edit.rs                  (model for guard pattern; read-only reference)
src/api/client.rs                      (no HTTP layer changes)
tests/issue_create_json.rs             (platform-path tests; AC-002 in jsm file also unaffected)
.github/workflows/dependency-review.yml (no rust-toolchain usage)
.github/workflows/scorecards.yml        (no rust-toolchain usage)
.github/workflows/sync-upstream.yml     (no rust-toolchain usage)
.factory/specs/prd/bc-*.md             (except bc-2 and bc-3)
rust-toolchain.toml                    (deliberately NOT changed; stays channel=stable)
```

---

## 7. Open Questions for F1 Gate

1. ~~**SEMVER impact of #639**~~: RESOLVED — DEC-188 clause (d): breaking change rides the
   0.6→0.7 train bump; version becomes `0.7.0-dev.1`. `Cargo.toml` bump and
   `### Breaking Changes` entry are S-639-1 deliverables (see §1 impact table).

2. **Verified SHA for dtolnay/rust-toolchain**: `fa04a145` was identified as a genuine master
   ancestor but the full 40-char SHA must be confirmed before F4. Assign research step to S-626-1.

3. ~~**E2E blast radius**~~: confirmed ZERO — `tests/e2e_live.rs` contains no `issue create --field`
   invocations on the platform path. No E2E test changes required. (Audit-confirmed 2026-07-25.)

4. **BC-3.3.001 amendment note wording**: the exact new text for the amendment note at
   bc-3-issue-write.md:~481 should be drafted at F2, not left to the implementer.

---

*Approved scope: ratified 2026-07-25. Phase F1 complete pending human F1 gate confirmation.*
