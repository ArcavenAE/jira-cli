---
document_type: story
story_id: "S-MUTANTS-SCOPE-GUARDS-1"
title: "CITATION-GUARDS Story A: mutants-policy function-location guard + examine_globs file-existence guard (DEC-150)"
wave: feature-followup
status: draft
intent: ci-hardening
feature_type: infrastructure
mode: feature
scope: small
severity: LOW
trivial_scope: false
points: 3
priority: P1
tdd_mode: strict
estimated_effort: small
estimated_days: 1.0
target_module: ci-infrastructure
subsystems: []
depends_on: []
# blocks: [S-BC-CITATION-GUARD]  # Story B (Guard 1) is planned-not-yet-authored; no story file exists; add entry when Story B is dispatched
behavioral_contracts: []
# BC status: policy-doc-only (no BC). Governing artifact: docs/specs/cargo-mutants-policy.md.
# No product behavioral contract governs CI-infrastructure scope guards. The S-7.01 Spec-First
# Gate does not apply to CI-infrastructure stories where the governing artifact is an internal
# policy doc (not a product contract). Status=draft is correct during authoring; status may
# advance to ready when story convergence completes — NO BC prerequisite applies for
# policy-doc-only stories (per S-MUTATION-CI-TIMEOUT-1/DEC-144 precedent; L-4 fix).
# Pattern: S-MUTANTS-EXAMINE-GLOBS-1 (DEC-149), S-MUTATION-CI-TIMEOUT-1 (DEC-144), S-TESTTOOL-1 (MAINT-MUTANTS-GLOBS-01).
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: "docs/specs/cargo-mutants-policy.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-07-02"
version: "1.17"
last_updated: "2026-07-02"
breaking_change: false
retroactive: false
origin: >
  DEC-150 process-gap dispositions: MUTANTS-POLICY-CITATION-GUARD (Guard 2) and
  MUTANTS-GLOB-EXISTENCE-GUARD (Guard 3). Root cause DEC-149 (CITATION-GUARDS bundle):
  ADR-0012 Seam A/B left cargo-mutants-policy.md §Scope function-location bulleted list citing
  handle_jsm_create in create.rs after it relocated to jsm_create.rs; this false coverage
  claim survived without detection because no CI guard existed. Symmetric gap for Guard 3:
  .cargo/mutants.toml examine_globs entries are exact file paths — a refactor that moves or
  renames a file silently kills coverage with no CI alert. F1 delta analysis:
  .factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md §2 (Guards 2+3).
  Stories recommended: 2 (wave_order: guards-2-3-first per F1 §7). This is Story A.
changelog:
  - "1.17 (2026-07-02): Adversary pass 22 fixes (MED-1-P22/MED-2-P22/LOW-3-P22):
    MED-1-P22 (threshold binding, HIGH): bash Guard 2 now mandates `local FLOOR=11` used in
    BOTH the comparison `[ \"$N\" -lt \"$FLOOR\" ]` AND the message interpolation
    `expected >= ${FLOOR}`. Without this binding, a mutation weakening the comparison
    (11→5) while leaving the message literal unchanged would survive the `expected >= 11`
    substring assertion. Rust `assert_examine_globs_coverage_floor` helper now declares
    `const FLOOR: usize = 11` used in both `entries.len() < FLOOR` AND the format string
    `expected >= {FLOOR}`. Updated: Task 2 SCOPE-COVERAGE-FLOOR spec (new binding rationale),
    Task 3 helper spec (FLOOR symbol + mutation analysis), AC-003 floor paragraph
    (${FLOOR} interpolation note), AC-004 coverage-floor bullet (FLOOR symbol), Task 8
    self-verify (FLOOR binding check). Note: the substring pin (`expected >= 11`) still proves
    message fidelity when FLOOR=11; the FLOOR symbol binding is what closes the
    comparison-mutation window where message and comparison previously diverged independently.
    MED-2-P22 (Fixture F qualifier distribution): Fixture F extended from 4 to 7 fn pairs by
    adding three shapes that dominate the real §Scope set: (1) `mock_scoped_async_fn` defined
    as `pub(super) async fn` (pub visibility scoping + async qualifier); (2) `mock_crate_fn`
    as `pub(crate) fn` (pub visibility scoping); (3) `mock_indented_fn` as 4-space-indented
    `pub async fn` inside `impl MockStruct { ... }` block (impl-block indentation — the
    `[[:space:]]*` leading anchor in the grep regex admits any leading whitespace). All three
    verified against the definition-anchored grep regex. Policy bullet updated to name all 7 fns.
    Summary assertion updated 4→7 pairs. `SomeStruct` still filtered — M=7 not M=8.
    Propagated to: Task 2 Fixture F spec, AC-002 row F (4→7 pairs), Task 8 self-verify.
    LOW-3-P22 (Fixture E hermetic SRC_ROOT): Fixture E now sets `SRC_ROOT=\"$tmp_E\"` (hermetic
    parity with Fixtures F and G; prior behavior relied on REPO_ROOT fallthrough). All three
    malformed-bullet traces exit before filesystem access (shape-guard / traversal-guard failures
    before grep), so test outcome is unaffected. Variable isolation note updated to reflect that
    Fixture E now sets both POLICY_DOC and SRC_ROOT. Updated: Task 2 Fixture E spec."
  - "1.16 (2026-07-02): Adversary pass 19 fixes (F-1/F-2/F-3/F-4/F-5/F-6):
    F-1 (HIGH, threshold-weakening window): (a) Fixture H RED call assertions extended to
    substring-match `expected >= 11` AND `got 2` (pins threshold and count format in the
    SCOPE-COVERAGE-FLOOR message — kills mutations weakening 11→[3..10]). (b) Fixture H gains a
    companion GREEN call (N=11 boundary): POLICY_DOC reassigned to policy_h_boundary.md with 11
    bullets and all 11 fns defined in mock_h_boundary.rs; asserts rc_h2=0 AND output does NOT
    contain SCOPE-COVERAGE-FLOOR: (proves floor does not fire at exact threshold; kills
    mutations weakening `< 11` to `<= 11`). (c) Rust test 5 gains `assert!(msg.contains(\"got 3\"))`
    to pin the count format in the MUTANTS-GLOBS-COVERAGE-FLOOR panic message. (d) New 6th Rust
    test `test_coverage_floor_does_not_panic_at_exact_threshold`: inline 11-entry mock, catch_unwind
    on assert_examine_globs_coverage_floor, asserts result.is_ok() — boundary GREEN proof.
    F-2 (MED, factual error): traversal guard prose rewritten to remove 'belt-and-suspenders'
    claim — `[[ \"$file\" == *\"..\"* ]]` is the SOLE defense; the regex character class `[.]` is
    literal (not wildcard) so `src/../etc/passwd.rs` satisfies the regex. Fixture E extended
    from 2 to 3 malformed bullets: third bullet `` `src/../escape.rs` — `some_fn` `` added with
    detailed trace showing traversal guard fires as SOLE rejection mechanism; assertions updated
    from TWICE to THREE TIMES.
    F-3 (MED, qualifier alternation unfixtured): Fixture F mock source and policy bullet extended
    to include mock_const_fn (`const fn`), mock_unsafe_fn (`unsafe fn`), mock_extern_fn
    (`extern \"C\" fn`) in addition to mock_fn_alpha (`pub fn`); all 4 defined in mock src;
    expected summary assertion updated from 1→4 pairs validated.
    F-4 (MED, message erosion): covered by F-1(a)/(c) — `expected >= 11` and `got 2` substrings
    now explicitly asserted in Fixture H and `got 3` in test 5.
    F-5 (MED, snake_case filter unfixtured): `SomeStruct` added to Fixture F policy bullet
    (backtick-quoted, non-snake-case); asserted as filtered — M=4 not M=5; AC-002 row F updated.
    F-6 (LOW, fixture-count integrity): fixtures_run counter added: initialized to 0 before
    Fixture A, incremented after each fixture's assertions (×8), checked
    `[ \"$fixtures_run\" -eq 8 ] || exit 1` after all 8 fixtures with SELF-TEST-FIXTURE-COUNT
    message. Noted in Task 2 (initialization + closing check), AC-002 body, and
    FIXTURE-SHAPE-CHANGE-COVERAGE note (drop-a-fixture vector now machine-pinned). AC-002
    table: Row E TWICE→THREE TIMES; Row F updated to 4 pairs + SomeStruct filter note; Row H
    split into RED (N=2) and GREEN companion (N=11) rows. AC-004: 6th test mentioned. AC-005:
    all four→all five. AC-006: 6th test name added. Task 8: five→six test functions + counter
    and test 5/6 assertions added."
  - "1.15 (2026-07-02): Adversary pass 16 fixes (F-1/F-2/F-3/F-4/F-5/F-6/F-7/F-8):
    F-1 (MED): Canonical run_check idiom changed from `set +e; run_check; rc=$?; set -e` to
    `set +e; output=$(run_check 2>&1); rc=$?; set -e` to capture stdout+stderr into `$output`.
    Explanation updated: command substitution runs run_check in a subshell — mutations to shell
    variables inside run_check do not propagate to the outer shell; fixtures set POLICY_DOC and
    SRC_ROOT in the outer shell BEFORE the call so the subshell inherits them. All eight fixture
    'Calls...' lines updated. AC-002 idiom reference updated.
    F-2 (LOW): `file=\"\"` initialization bullet added to Token extraction algorithm (before
    backtick-token extraction loop) to ensure $file is always bound under set -u when no
    src/-path token is found in a bullet group.
    F-3 (LOW): Fixture D isolation note fixed: 'prior fixtures B/C/F/G' → 'prior fixtures A/B/C'
    (F and G run AFTER D, not before). Fixture E isolation note updated to 'prior fixtures A/B/C/D'.
    F-4 (LOW): --policy-doc-alone gate rationale corrected: when --policy-doc is supplied WITHOUT
    --self-test, the decisive blocking clause is [ -z \"\${POLICY_DOC+x}\" ] (POLICY_DOC is set),
    not the self_test condition. Both conditions documented: POLICY_DOC+x clause alone is
    sufficient; self_test=1 provides an independent additional block.
    F-5 (LOW): Both PIN messages rewording: 'Update this PIN when [bullets/entries] are
    intentionally added/removed' → 'Update this PIN when [bullets/entries] are intentionally
    removed (the floor is a lower bound; additions never fire it)'. Four locations updated:
    Task 2 SCOPE-COVERAGE-FLOOR message, Task 3 helper #3 message, AC-003 floor paragraph,
    AC-004 coverage-floor bullet.
    F-6 (LOW): Fixture G rationale precision fix: backtick extraction produces ONE candidate
    token (the file-path token `src/mock_mod.rs`); the file-path-skip step consumes it; the
    snake_case filter never runs (no remaining tokens). Previous wording 'produces zero candidate
    tokens' was imprecise.
    F-7 (LOW): All 'lines 15–31' citations changed to 'lines 16–31' — line 15 is the §Scope
    intro prose ('cargo-mutants runs against:'), not the first bullet; bullets begin at line 16.
    Six locations in body.
    F-8 (LOW): Arg-parse snippet in Flags section gains `# --self-test) self_test=1 ;;` example
    case-branch comment to show the mechanism that sets self_test=1."
  - "1.14.1 (2026-07-02): Errata — Fixture H printf skeleton inconsistency: original printf
    produced ONE `^- ` bullet line with two fn names (N=1), but prose said '2 bullets' and
    'N=2'. Fixed printf to produce TWO separate `^- ` lines — one per file/fn pair — and
    split mock source into two separate files ($tmp_H/src/mock_h.rs + $tmp_H/src/mock_h2.rs),
    each containing its own fn definition. Trace now correct: N=2 bullets parsed, SCOPE-EMPTY
    does not fire (N>0), floor fires (2<11 AND CANONICAL_MODE=1), rc=1,
    SCOPE-COVERAGE-FLOOR: in output."
  - "1.14 (2026-07-02): Adversary pass 15 fixes (MED-1/MED-2/MED-3/MED-4/MED-5/MED-6/L-1/L-2/L-3/L-5):
    MED-1: Fixture H added (SCOPE-COVERAGE-FLOOR RED-provable): sets CANONICAL_MODE=1 + 2-bullet
    well-formed mock (both fns defined in mock src) → floor fires (N=2 < 11) → rc=1 + output
    contains SCOPE-COVERAGE-FLOOR:. Fixture H is the ONLY fixture that sets CANONICAL_MODE=1.
    SEVEN→EIGHT cascade: --self-test header, run_check paragraph (B through H), trap ${tmp_H:-},
    AC-002 row H, Task 8, File Structure, RED-gate note.
    MED-2: Guard 3 coverage-floor made RED-provable. New shared helper
    fn assert_examine_globs_coverage_floor(entries: &[String]) extracted; test 1 now calls it
    (not inline assert!). 5th Rust test test_coverage_floor_panics_when_entries_below_threshold
    added: inline mock TOML with 3 entries, catch_unwind on assert_examine_globs_coverage_floor,
    asserts MUTANTS-GLOBS-COVERAGE-FLOOR in panic message. AC-004 coverage-floor bullet updated
    (shared helper required; do NOT inline). AC-005 'all three' → 'all four'. AC-006 adds 5th
    test name. Task 3 helpers section gains 3rd helper. Task 8 four→five tests.
    MED-3: failed=1 variable removed from shape-guard arm (was redundant: exit predicate is
    rc=1 iff offenders list non-empty). Bullet-continuation grammar and Fixture E proof updated.
    MED-4: Fixture G Task-2 assertion and AC-002 table rows F/G gain dollar-sign end-anchor ($).
    MED-5: Process gap POLICY-DOC-ZERO-PAIR-OPT-OUT registered in Out of Scope.
    MED-6: Process gap EXTRACTION-SET-PIN registered in Out of Scope.
    L-1: FIXTURE-SHAPE-CHANGE-COVERAGE note extended with preamble-grep loosening residual
    (in-process model cannot kill ^# anchor-weakening mutations; accepted gap).
    L-2: Test 4 downcast form replaced with exact copy-pasteable Err-arm
    (downcast_ref::<String> || downcast_ref::<&str>); same form used in new test 5.
    L-3: Traversal guard [[ \"$file\" != *\"..\"* ]] added alongside shape regex in MED-3 block.
    L-5: Fixture A mock extended to two missing fns (handle_nonexistent_fn_selftest +
    another_missing_fn_selftest) in one bullet; both DEAD lines required in output assertion
    (kills break-for-continue mutation). AC-002 row A updated."
  - "1.13 (2026-07-02): Adversary pass 12 fixes (HIGH-1/L-2/L-3/L-4/L-5/L-6/L-7):
    HIGH-1: Preamble check 2 grep tautology fixed — `grep -q \"CI-MUTANTS-CITE-001\"
    \"${BASH_SOURCE[0]}\"` always self-matched (the pattern-argument line contains the literal);
    changed to `grep -Eq '^#.*CI-MUTANTS-CITE-001' \"${BASH_SOURCE[0]}\"` (comment-anchored,
    cannot self-satisfy). Prior-art rationale corrected: JRACLOUD-95368 pin asserts RUNTIME
    stderr from a separate source file; this is a STATIC comment pin in the same file — the
    `^#` anchor is the analogous static approach. Updated preamble check 1 and Task 8.
    L-2: Mandated shared `fn extract_examine_globs_or_panic(value: &toml::Value) -> Vec<String>`
    called by BOTH test 1 AND test 4 (empty-Vec panic lives in the shared helper; test 4
    catch_unwind catches removal of the panic — previously the claim held only if test 1
    inlined the panic). Updated Task 3 helper-function spec and AC-004.
    L-3: Fixture G rationale rewritten — 'serde'/'structs'/'for'/'X' are excluded because NOT
    BACKTICKED (plain prose), not because of snake_case filter; backtick extraction step finds
    zero candidates and the snake_case filter is never reached.
    L-4: Variable isolation added to Fixtures D and E — `unset SRC_ROOT POLICY_DOC` before each;
    prevents prior fixtures (B/C/F/G set SRC_ROOT to temp dirs) from leaking into D and E which
    rely on run_check's default `SRC_ROOT=\"${SRC_ROOT:-$REPO_ROOT}\"`.
    L-5: Bash syntax self-check moved from preamble check 1 (inside --self-test) to top-of-file
    unconditional before arg parsing (matches prior art placement exactly). Preamble section now
    has only one check (CI-MUTANTS-CITE-001 literal pin). Task 2 and Task 8 updated.
    L-6: Disambiguated K (offender count) from N (bullet count) in prose: error-format summary
    line description and AC-003 now use K for offender count; N reserved for bullet count
    (SCOPE-EMPTY/SCOPE-COVERAGE-FLOOR/positive-coverage-summary). Regex unchanged.
    L-7: Fixture B mock source file given same mkdir -p + printf skeleton treatment as A/F:
    `mkdir -p \"$tmp_B/src/cli/issue\"` + `printf ... > \"$tmp_B/src/cli/issue/create.rs\"`."
  - "1.12.1 (2026-07-02): Errata — 3 consistency residues missed in v1.12:
    (1) Flags section `--self-test` bullet (line ~450): 'run all six self-test fixtures ... exit 0
    if all six pass' → seven (both occurrences); the F-M-5 cascade did not reach this bullet.
    (2) run_check function-pattern paragraph (line ~623): 'Fixtures B through F would never run'
    → 'Fixtures B through G'; the enumeration was incomplete after Fixture G was added.
    (3) AC-001 Format note (line ~1072): 'The script MUST parse bullet lines (`^- \\`src/...`)'
    still described the old grammar. Updated to F-H-1 grammar: script parses ALL `^- ` dash
    bullets in §Scope range; file = first backticked `src/` token in assembled group; bullet with
    no valid token → malformed offender. Note preserved that real §Scope bullets all happen to
    carry `src/`-path tokens; grammar change only affects malformed-bullet handling."
  - "1.12 (2026-07-02): Adversary pass 11 fixes (F-H-1/F-M-1/F-M-2/F-M-3/F-M-4/F-M-5/F-L-1):
    F-H-1 (HIGH): Bullet-start grammar redesigned from `^- \\`src/` to `^- ` (any dash bullet).
    File path = first backtick token starting with `src/` in the assembled group. Bullet with NO
    valid src/-path token → shape-guard offender. SCOPE-EMPTY = N=0 `^- ` bullets. Fixture E now
    reachable (previously shape-guard was dead code; SCOPE-EMPTY fired instead because malformed
    bullets never entered loop). Updated: bullet-continuation grammar, Fixture E trace comment
    (parenthetical), shape-guard prose (A/B/C/D/F well-formed; E deliberately malformed),
    SCOPE-EMPTY definition, AC-002/AC-003.
    F-M-1 (HIGH-adjacent): Definition-anchored grep fixed from bare `\"$file\"` to `\"$SRC_ROOT/$file\"`;
    invariant note added: ALL filesystem accesses in run_check are $SRC_ROOT-prefixed (existence
    check and grep both).
    F-M-3 (MED): SCOPE-EMPTY 'exit 1' → 'return 1'; SCOPE-COVERAGE-FLOOR 'exit 1' → 'return 1'
    (run_check must return not exit — MED-1 contract; AC-003 observable behavior unchanged: exit 1
    at top level).
    F-M-4 (MED): Shape-guard prose rewritten: 'four self-test fixture mock docs are all well-formed
    (follow `^- \\`src/` pattern); none trigger this path' → 'Fixtures A/B/C/D/F use well-formed
    skeletons; Fixture E is deliberately malformed to exercise this path'.
    F-M-5 (MED): Fixture G added (file-existence-only class): one bullet
    `- \\`src/mock_mod.rs\\` — serde structs for X`; mock file exists but is empty; no fn names
    extracted; asserts rc=0 AND `^Check passed: 1 bullets parsed, 0 \\(file, fn\\) pairs validated`.
    SIX→SEVEN cascade throughout: --self-test header, RED-gate note, trap adds ${tmp_G:-},
    AC-002 table row G added, Task 8 count, File Structure description.
    F-M-2 (MED, note-only): Maintenance Touchpoints: glob dev-dep compile latency sentence added
    (MUTANTS-FIRST-SCOPED-PR-CALIBRATION watch item reference).
    F-L-1 (LOW): Task 8 self-verify: `cargo deny check` step added (verify glob = 0.3 license)."
  - "1.11 (2026-07-02): Adversary pass 10 fixes (F-MED-1/F-MED-2/F-MED-3/L-1/L-2/L-4/L-5/L-7):
    F-MED-1: Fixture B output assertions folded in (DEAD: + not found in + handle_jsm_create);
    Fixture E summary-line regex assertion added (^[0-9]+ stale citation(s) found in .+ §Scope$).
    F-MED-2: Fourth Rust test added to Task 3 — test_detect_missing_examine_globs_key_panics_with_key_missing_message
    (std::panic::catch_unwind on mock TOML without examine_globs key; asserts MUTANTS-GLOBS-KEY-MISSING
    in panic message); propagated to AC-004/AC-006/Task 8.
    F-MED-3: self_test=0 initialization added before CANONICAL_MODE=0 in arg-parser idiom
    (prevents set -u abort on canonical CI; prior art check-signing-workflow-injection.sh:68).
    L-1: Fixture A hermetic isolation added — SRC_ROOT=$tmp_A + empty stub $tmp_A/src/adf.rs
    (mirrors B/F hermetic pattern; prevents real src/adf.rs from affecting test outcome).
    L-2: AC-005 'assertion block OR new test' parenthetical removed — separate test is mandatory.
    L-4: CI-MUTANTS-CITE-001 literal pin added as preamble check 2 in --self-test
    (grep -q CI-MUTANTS-CITE-001 BASH_SOURCE[0]; mirrors JRACLOUD-95368 pattern).
    L-5: AC-007 CHANGELOG pin relaxed from byte-for-byte to content-equivalent-modulo-wrapping
    (key strings: topic prefix, DEC-150, file paths, capability descriptions must all be present).
    L-7: bash -n BASH_SOURCE[0] syntax self-check added as preamble check 1 in --self-test
    (mirrors check-signing-workflow-injection.sh:66; surfaces syntax errors before fixtures run).
    L-3/L-6: no action (verified correct per coordinator)."
  - "1.10.1 (2026-07-02): Errata — 2 consistency fixes from v1.10:
    (1) run_check function-pattern paragraph (line ~556): 'Fixtures B, C, and D would never run'
    → 'Fixtures B through F would never run' (enumeration was incomplete after E/F were added).
    (2) --policy-doc Flags description: 'fixtures use this naturally' (ambiguous in in-process
    model) → reworded to state the actual gate: the decisive exemption is that --self-test was
    supplied at arg-parse time, so the [ \"$self_test\" = \"0\" ] condition is false and
    CANONICAL_MODE is never set to 1 regardless of whether --policy-doc was also supplied."
  - "1.10 (2026-07-02): Adversary pass 9 fixes (F-MED-1/F-MED-2/LOW-1/LOW-2/LOW-3):
    F-MED-1: CANONICAL_MODE=1 discriminator added — arg parser sets it only when neither
    --self-test nor --policy-doc supplied; SCOPE-COVERAGE-FLOOR condition changed from
    'no --policy-doc flag' to [ \"${CANONICAL_MODE:-0}\" = \"1\" ]; Flags section updated with
    exact idiom; AC-003 floor paragraph updated; stale --src-root rationale in Flags (claiming
    jsm_create.rs false-green) corrected to hermetic-isolation rationale (v1.9.1 Fixture B fix
    was body-only; Flags section now consistent).
    F-MED-2: Fixture E added (two malformed bullets; asserts rc=1 AND 'DEAD: malformed bullet
    skipped:' twice) — covers zero-fixture gap on MED-5 malformed-bullet path.
    LOW-1: Fixture F added (success-path; mock fn definition in mock src file; asserts rc=0 AND
    '^Check passed: 1 bullets parsed, 1 (file, fn) pairs validated') — kills omitted-summary and
    inverted-polarity mutants (POL-11).
    LOW-2: [ -f \"$SRC_ROOT/$file\" ] slash-joined concatenation pinned explicitly in Task 2
    file-existence-only note.
    LOW-3: FIXTURE-SHAPE-CHANGE-COVERAGE process-gap note added to Out of Scope.
    Cascades: fixture count FOUR→SIX throughout (--self-test header, RED-gate staging note,
    trap variable list adds ${tmp_E:-} ${tmp_F:-}, Task 8, AC-002 header/table/trap, File
    Structure Requirements)."
  - "1.9.1 (2026-07-02): Errata — Fixture B rationale was factually wrong: claimed 'without
    --src-root, greps jsm_create.rs where handle_jsm_create IS defined — exit 0 false-green'.
    Factually: algorithm greps the FILE CITED IN THE BULLET (create.rs), which holds only an
    import today, so the grep returns DEAD even without SRC_ROOT. True purpose of SRC_ROOT is
    hermetic isolation — fixture outcome must not depend on real create.rs drifting (e.g. if
    handle_jsm_create were re-added). Rewritten accordingly."
  - "1.9 (2026-07-02): Adversary pass 8 fixes (MED-1/MED-2/MED-3/MED-4/MED-5/LOW-1/LOW-2/LOW-3):
    MED-1: run_check function pattern added (check logic returns, never exits; each fixture uses
    set +e; run_check; rc=$?; set -e canonical idiom verbatim); all fixture assertions updated
    to rc=1 form.
    MED-2: temp hygiene trap updated to default-expansion form
    trap 'rm -rf \"${tmp_A:-}\" \"${tmp_B:-}\" \"${tmp_C:-}\" \"${tmp_D:-}\"' EXIT — prevents
    unbound-variable abort under set -u when early failure leaves tmp_X unset.
    MED-3: default variable initialization added to run_check preamble:
    SRC_ROOT=\"${SRC_ROOT:-$REPO_ROOT}\" + POLICY_DOC=\"${POLICY_DOC:-$REPO_ROOT/docs/specs/...}\"
    — prevents unbound-variable hard false-red on every canonical CI run.
    MED-4: exact printf skeletons added to all four fixtures (A: adf.rs/handle_nonexistent_fn;
    B: create.rs/handle_jsm_create + structureless mock would trip SCOPE-EMPTY; C: two bullets
    foo.rs/fn_alpha + bar.rs/fn_beta; D: ## Scope/## Terminator empty).
    MED-5: shape-guard updated to emit DEAD: malformed bullet skipped: <line text> offender line
    and set failed=1 (malformed §Scope is drift, not noise); AC-003 error-format list extended;
    AC-002 fixture table updated; no existing fixture expectations change (all skeletons well-formed).
    LOW-1: line numbers ~622/~635 dropped from Task 5 placement (heading names are stable anchors).
    LOW-2: job name corrected to 'Spec Guards (BC counts, numeric-count lint, mutants policy scope)'
    — includes still-active check-bc-no-numeric-test-counts step; propagated to Task 4/Task 8/
    AC-006/Maintenance Touchpoints; Task 4 deviation note updated with numeric-count rationale.
    LOW-3: bullet-continuation grammar pinned in Task 2 (continuation = ^[[:space:]]{2,} AND not
    ^- ; group terminates at blank line/next bullet/scope boundary; prevents prose lines 33-38
    swallowing into cache.rs bullet and extracting examine_globs as a fn name)."
  - "1.8 (2026-07-02): Adversary pass 7 fixes (MED-1/MED-2/LOW-1/Obs-a/Obs-b):
    MED-1: Fixture C item (b) added POLICY_DOC binding (was SRC_ROOT-only — would have parsed
    real policy doc against empty src-root, producing 11 real-file DEAD lines instead of
    src/foo.rs/src/bar.rs). Item (a) now explicitly says 'written to $tmp_C/policy.md'.
    MED-2: SCOPE-COVERAGE-FLOOR guard added to Task 2 (canonical-mode-only, N < 11 → exit 1;
    mirrors Guard 3 entries.len()>=11 pin; self-test fixtures exempt via --policy-doc; SCOPE-EMPTY
    unconditional, checked first; Fixture D unaffected — N=0 fires SCOPE-EMPTY regardless of mode).
    Reflected in AC-003 + Task 8 self-verify.
    LOW-1: Fixture A rewritten to IN-PROCESS semantics matching B/C/D (was 'Pass via --policy-doc
    <tmp_A>' CLI-arg phrasing; now 'Sets internal variable POLICY_DOC=$tmp_A/policy.md').
    Obs-a: Positive coverage summary pinned to N=11, M=21 in Task 2 + AC-003 + Task 8
    (src/types/jira/bulk.rs contributes 0 to M, 1 to N; M=3+2+3+1+1+0+1+2+3+3+2=21 verified).
    Obs-b: Processing-loop sentence added to Task 2 parsing algorithm (shape-guard continue
    context: execute inside bullet loop, skip without aborting)."
  - "1.7.1 (2026-07-02): Errata — consistency check: AC-007 CHANGELOG description diverged from
    Task 6 canonical string (AC-007 had bare paths + '+' separators; Task 6 had backtick-quoted
    filenames + capability parentheticals + 'and'). Fix: AC-007 CHANGELOG paragraph replaced with
    single-source reference to Task 6 ('the entry text matches the canonical string specified in
    Task 6 byte-for-byte'). No other content changed."
  - "1.7 (2026-07-02): Adversary pass 6 fixes (H-GT-1/M-GT-1/M-GT-2/L-GT-1/L-GT-2 + process gap note):
    H-GT-1: AC-001 rewritten — Guard 2 GREEN only AFTER Task 5 SWEEP (pre-SWEEP: 4 DEAD extractions
    are the RED-gate evidence); deleted 'without any citation fixes needed' claim; PR attribution
    corrected (#568 = citation fix, #570 = mutants.toml scope restore); Task 5 sequencing made
    explicit. Previous Story Intelligence rewritten with correct attribution. Traceability row updated.
    EC-006 note corrected. Architecture Mapping dependency note updated. M-GT-1: Out of Scope 'Scope
    change column' → 'Change column' (actual header: | Date | Cycle | Change |). M-GT-2: Task 6 +
    AC-007 CHANGELOG entry format changed to bolded topic prefix: - **CI: ...(DEC-150):** ... (matches
    CHANGELOG.md convention). L-GT-1: Task 4 'after the existing four steps' changed to 'at the end of
    the steps list, after check-bc-cumulative-counts (DRIFT-002)' (job has 7 steps). L-GT-2: Behavioral
    Contracts table §Absolute Timeout Ceiling row dropped (conflated per-mutant --timeout 240 H3 with
    90-min wall-clock budget; guards affect neither; row removed). Added INTERNAL-PR-CITATION-RIGOR
    process-gap note to Out of Scope."
  - "1.6.1 (2026-07-02): Errata — 2 cascade gaps from v1.6 F-3/F-4 interaction:
    (1) AC-003: 'Fixture D (AC-002)' stale location ref after F-3 move → 'Fixture D (Task 2)'.
    (2) Fixture C semantic conflict with F-4 missing-file rule: when SRC_ROOT is an empty dir,
    the script emits 'DEAD: src/foo.rs not found' + 'DEAD: src/bar.rs not found' (file-missing
    path fires first; fn_alpha/fn_beta never appear in output). Fixed in BOTH Task 2 Fixture C
    description (assertions updated to DEAD: src/foo.rs/bar.rs not found; explicit note that
    fn names do NOT appear) and AC-002 table row C (same assertion update). Purpose preserved:
    still proves collect-ALL-offenders invariant and also pins F-4 missing-file output format."
  - "1.6 (2026-07-02): Adversary pass 5 fixes (F-1/F-2/F-3/F-4/F-5/F-6/F-7/F-8/F-9/F-10/F-11):
    F-1: summary-line regex de-hardcoded from literal path to .+ placeholder (Fixture A/B run with
    --policy-doc <tmp>, not canonical path); Task 2 error-format uses <policy-doc-path> placeholder.
    F-2: Fixture B 'Invokes:' rewritten to IN-PROCESS semantics (POLICY_DOC/SRC_ROOT internal vars;
    no re-invocation; F-H2 CLI fence fires at arg-parser entry only). F-3: Fixtures C+D moved from
    AC-002 to Task 2 (single source of truth); AC-002 rewritten as brief assertion table + reference
    to Task 2. F-4: missing-cited-file behavior specified (DEAD: fn not found in file for each fn;
    file-existence-only → DEAD: <file> not found). F-5: Task 8 coverage-summary uses exact canonical
    regex. F-6: Task 5 specifies WHERE ## Guards goes (after ## Spec Anchor, before ## Future Path)
    + must-NOT constraint (not between ## Scope and ### Sibling Candidates). F-7: MUTANTS-GLOBS-KEY-
    MISSING message extended with 'or examine_globs is present but empty'. F-8: Fixture A --src-root
    option removed (omit; grep runs against real repo tree). F-9: Task 7 CLAUDE.md bullet adds
    --src-root to flag list. F-10: RED-gate staging note added to Tasks intro. F-11: test function
    renamed test_reject_nonexistent_examine_globs_entry_returns_dead_list (verb-first); propagated
    across Task 3 + AC-005 + AC-006."
  - "1.5 (2026-07-02): Adversary pass 4 fixes (F-C1/F-C2/F-C3/F-H1/F-H2/F-H3/F-H4/F-H5/F-H6/F-O3/F-O4):
    F-C1: Windows separator normalization in glob format string (CARGO_MANIFEST_DIR backslash → forward-slash
    before passing to glob 0.3); Task 8 Windows-matrix caveat added. F-C2: coverage-floor assertion
    entries.len()>=11 + MUTANTS-GLOBS-KEY-MISSING loud error on missing examine_globs key; AC-004/AC-005/
    AC-006 updated. F-C3: SCOPE-EMPTY guard (exit 1 if 0 bullets parsed) + positive coverage summary on
    success (Check passed: N bullets, M pairs); AC-002/AC-003 extended. F-H1: Out of Scope gains
    POLICY-DOC-NON-SCOPE-CITATIONS paragraph (citations outside §Scope, e.g. Changelog/Root Cause rows,
    not caught by Guard 2 — deliberate). F-H2: --src-root without --self-test → exit 64 usage error added
    to Flags section. F-H3: Task 6 now specifies ###Added sub-header under [Unreleased]. F-H4: Job name
    changed from 'Spec Guards (BC counts, citation checks, mutants scope)' to 'Spec Guards (BC counts,
    mutants policy scope)' — 'citation checks' is Story B domain; deviation from F1 §5 noted with
    rationale. F-H5: --locked CI builds fail rationale corrected everywhere (this repo's CI does NOT pass
    --locked; reworded to 'repo policy + downstream --locked consumers'). F-H6: cargo test --all-features
    full-suite run added to Task 8 self-verify. F-O3: key bare I-N/C-N/O-N provenance labels
    pass-versioned throughout body text. F-O4: Maintenance Touchpoints section added after Edge Cases."
  - "1.4.1 (2026-07-02): Consistency errata — four stale 'two fixtures'/'both fixtures' residues
    missed when Fixture C was added in pass 3: (1) Task 2 --self-test flag description (line ~248):
    'run both self-test fixtures … exit 0 if both pass' → 'run all three self-test fixtures … exit 0
    if all three pass'; (2) File Structure Requirements table row for check-cargo-mutants-policy-
    citations.sh: 'two fixtures (dead-symbol + import-only)' → 'three fixtures (dead-symbol +
    import-only + empty-src-root)'; (3) AC-002 heading: '(RED-provable, two fixtures)' → 'three
    fixtures'; (4) AC-002 body: '--self-test runs TWO fixtures:' → 'THREE fixtures'. Zero grep hits
    for case-insensitive two-fixture/both-fixture/both-pass after fix."
  - "1.4 (2026-07-02): Adversary pass 3 fixes (C-1/H-1/H-2/M-1/M-2/M-3/L-1/L-2/L-3/L-4/L-5/L-6/O-1):
    Task 5 is now the SINGLE authoritative SWEEP checklist (both handle_jsm_create occurrences on
    create.rs bullet + seen_keys/has_more on issues.rs bullet enumerated explicitly); Task 2 SWEEP
    note defers to Task 5; H-1/M-2: Fixture A/B self-test output must assert offender-line +
    summary-line format (not just exit code/token presence); AC-003 removes inline-comment escape
    hatch; M-1: AC-005 gains third fixture path via TOML parse → validate_globs to kill polarity
    mutant; M-3: canonical heading ## Guards only (no '## CI Guards' alt); L-1: test renamed to
    test_resolve_all_examine_globs_entries_to_real_files (verb-first convention); L-3: (I-6 FIX)
    labels disambiguated by adversary pass number; L-4: frontmatter gate comment corrected to
    policy-doc-only ready condition; L-5: file-path shape guard added to Task 2; L-6: EC-006 removed
    (PR #570 already merged); L-2: one-line note about job-name in Task 4; O-1: Fixture C (empty
    src-root) added to Task 2 + AC-002."
  - "1.3 (2026-07-02): Adversary pass 2 fixes (C-1/C-2/C-3/C-4/I-1 through I-8/O-4): Task 5 SWEEP
    extended to un-backtick seen_keys/has_more in issues.rs bullet (false-red C-1); --src-root flag
    added to script for Fixture B (C-2 — without it Fixture B false-greens on real src/); portability
    fix grep-oP→grep-oE + \\b→([^[:alnum:]_]|$) (C-3 BSD grep); || true on all may-match-zero grep
    calls (C-4 set -euo pipefail abort); broadened fn regex for const/unsafe/extern qualifiers (I-1);
    SCRIPT_DIR repo-root convention specified (I-2); absolute glob paths via CARGO_MANIFEST_DIR (I-3);
    fence-skip justification corrected — defensive rule only, not triggered by §Whitelist-Convention
    (I-4); Cargo.lock added to file set → 8-file set (I-5); mktemp-before-trap ordering (I-6); globset
    forward-compat claim softened (I-7); validate_globs helper fn required in Guard 3 (I-8); AC-004
    snapshot annotation; MSRV note; STORY-INDEX 7-file→8-file."
  - "1.2 (2026-07-02): Consistency-validator fixes (5 mismatches): AC-007 Cargo.toml sentence corrected
    from NOT-modified to IS-modified; Task 8 self-verify step added for glob=0.3 in [dev-dependencies];
    F1 §4 Cargo.toml deviation note added to Governance Note section; STORY-INDEX 6-file set→7-file set
    (last_updated + row); STORY-INDEX manifest row blocks corrected (Story B not yet authored)."
  - "1.1 (2026-07-02): Adversary pass 1 revisions (C-1/C-2/C-3/C-4/I-1 through I-7/O-1/O-4): upgraded
    to definition-anchored grep (not plain grep-q); §Scope correctly identified as bulleted list (not
    table); token extraction grammar with explicit false-positive guards and expected (file,fn) pairs;
    --policy-doc flag added for self-test; second self-test fixture (import-only false-green proof);
    blocks: removed (Story B not yet authored); Guard 3 upgraded to glob::glob() expansion (glob=0.3
    dev-dep, Cargo.toml added to files_modified); spec-guard job name aligned to F1 §5 exact wording;
    CI-MUTANTS-CITE-001 error format class named and pin-required; EC-001 corrected (grep-q is
    actively dangerous, not conservative)."
  - "1.0 (2026-07-02): Initial F3 story — S-MUTANTS-SCOPE-GUARDS-1 (story #101, 100→101). CITATION-GUARDS
    Story A: Guard 2 (scripts/check-cargo-mutants-policy-citations.sh + spec-guard CI step) + Guard 3
    (tests/mutants_glob_existence.rs, rides test job). Policy-doc-only governance. 7 ACs. 6-file set.
    F1 delta analysis: citation-guards-2026-07-02-delta.md. DEC-150 origin."
lineage:
  - S-MUTANTS-EXAMINE-GLOBS-1       # DEC-149: fixed the stale citations that triggered this guard need
  - S-MUTATION-CI-TIMEOUT-1         # DEC-144: established mutation gate; this story guards its scope config
  - S-TESTTOOL-1                    # MAINT-MUTANTS-GLOBS-01: last examine_globs expansion; this story guards future ones
  - S-MAINT-DEAD-CITATION-CI        # prior art: same CI-guard pattern (tests/claude_md_citations.rs)
drift_items:
  - MUTANTS-POLICY-CITATION-GUARD
  - MUTANTS-GLOB-EXISTENCE-GUARD
  - DEC-149
  - DEC-150
files_modified:
  - scripts/check-cargo-mutants-policy-citations.sh   # NEW — Guard 2: parse §Scope bulleted list, verify each (file, function) pair
  - tests/mutants_glob_existence.rs                   # NEW — Guard 3: parse examine_globs, assert each glob expands to ≥1 real file (glob::glob() expansion)
  - .github/workflows/ci.yml                          # MODIFY — spec-guard job: +2 steps (self-test + guard) for Guard 2; update job name; Guard 3 needs no CI change
  - docs/specs/cargo-mutants-policy.md                # MODIFY — add §Guards section documenting both guards; fix any stale citations found by script
  - CHANGELOG.md                                      # MODIFY — [Unreleased] entry per CHANGELOG-per-PR hygiene
  - CLAUDE.md                                         # MODIFY — doc-fallout notes for Guards 2+3 in AI Agent Notes (per F1 §4/§10)
  - Cargo.toml                                        # MODIFY — add glob = "0.3" to [dev-dependencies] for Guard 3 glob expansion
  - Cargo.lock                                        # MODIFY — automatically updated by Cargo when glob dev-dep is added; must be committed (repo policy: Cargo.lock always committed; downstream --locked consumers require it; this repo's CI does NOT pass --locked — F-H5 fix)
---

# S-MUTANTS-SCOPE-GUARDS-1 — CITATION-GUARDS Story A: Mutants-Policy Function-Location Guard + Examine-Globs File-Existence Guard

**Status:** DRAFT — F3 complete (2026-07-02); awaiting F4 dispatch.

**Origin:** DEC-150 process-gap dispositions (MUTANTS-POLICY-CITATION-GUARD + MUTANTS-GLOB-EXISTENCE-GUARD).
Triggered by DEC-149 CITATION-DEBT-PRODUCT-FILES cycle: after ADR-0012 Seam A/B extracted
`handle_jsm_create` to `src/cli/issue/jsm_create.rs`, the `docs/specs/cargo-mutants-policy.md`
§Scope function-location bulleted list still cited it in `create.rs` — a false coverage claim. No CI guard
existed to detect it. Guard 3 closes the symmetric gap: a refactor that moves or renames any file
in `.cargo/mutants.toml::examine_globs` silently drops that file from mutation scope with no CI alert.

**F1 delta analysis:** `.factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md`
**Governing spec:** `docs/specs/cargo-mutants-policy.md`
**Story B (Guard 1):** Not yet authored (requires full F2-F7 with new BCs in `cross-cutting.md`; no story file exists yet; the `blocks:` frontmatter entry is commented out until Story B is dispatched).

---

## Governance Note

**Policy-doc-only governance. No BC authored.** The governing artifact is
`docs/specs/cargo-mutants-policy.md`. The `bcs: []` field is intentional. The Spec-First Gate
(S-7.01) does not apply: no behavioral contract governs CI-infrastructure scope-guard configuration.
This pattern follows S-MUTATION-CI-TIMEOUT-1 (DEC-144, PR #567), S-TESTTOOL-1 (MAINT-MUTANTS-GLOBS-01,
PR #533), and S-MUTANTS-EXAMINE-GLOBS-1 (DEC-149) — all policy-doc-only CI-infrastructure stories
with empty `bcs:`.

**Scope classification:** CI guard infrastructure only. Zero production `src/` changes. The mutation
gate on the fix PR itself passes via the 0-mutant path (scripts and test files are not in
`examine_globs` → no killable mutants — DEC-144 precedent confirmed on PR #567 and PR #568).

**F1 §4 vs §11 divergence note (pass-2 I-5):** F1 §4's initial impact-boundary analysis listed
`docs/specs/cargo-mutants-policy.md` as NOT-CHANGED. F1 §11 (story shaping) overrides this:
it prescribes adding a `## Guards` section to document guard behavior. This story follows §11.
The two sections are consistent: §4 tracked what the *checked artifact* changes (scope itself
stays unchanged); §11 prescribes *documenting the guards* in that same file. Adding a §Guards
section is documentation, not a scope modification.

**F1 §4 Cargo.toml deviation note (pass-1 I-6):** F1 §4's file-impact analysis did not include
`Cargo.toml` in the story's file set. Adversary pass 1 finding I-6 added it: Guard 3 requires
`glob = "0.3"` in `[dev-dependencies]` to use `glob::glob()` semantics (forward-compatible with
wildcard examine_globs patterns) rather than bare `Path::exists()`. This is the only file that
diverges from F1 §4's original file set; the deviation is intentional and improves correctness.

**Drift item MUTANTS-ARBITER-OFFLINE-SELFTEST context:** That open drift item (STATE.md §Open Process
Gaps) records the kill-rate arbiter bash having no offline fixture self-test. The new guards in this
story MUST avoid the same gap: `scripts/check-cargo-mutants-policy-citations.sh` MUST ship with a
`--self-test` flag that seeds a stale citation and asserts exit 1, following the
`scripts/check-signing-workflow-injection.sh --self-test` pattern.

---

## Narrative

As a contributor to the `jr` CLI,
I want two lightweight CI guards that verify the cargo-mutants governance documents stay
synchronized with the actual codebase structure,
so that a module refactor (file move, rename, or function relocation) cannot silently
corrupt mutation-test scope without immediate CI detection.

---

## Traceability

| Source | Link |
|--------|------|
| Drift item origin | DEC-150 (MUTANTS-POLICY-CITATION-GUARD + MUTANTS-GLOB-EXISTENCE-GUARD) |
| Root cause cycle | DEC-149 (CITATION-DEBT-PRODUCT-FILES cycle) |
| F1 delta analysis | `.factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md §2` |
| Governing policy doc | `docs/specs/cargo-mutants-policy.md §Scope` |
| Prior art: citation guard | `tests/claude_md_citations.rs` (Guard 3 follows this exact pattern) |
| Prior art: self-test flag | `scripts/check-signing-workflow-injection.sh --self-test` |
| Prior art: CI step fixture | `tests/spec-count-fixtures/run-tests.sh` |
| CI topology source | F1 §3 (spec-guard job verified against live `ci.yml`) |
| Preceding scope story | S-MUTANTS-EXAMINE-GLOBS-1 (DEC-149, PRs #568+#570 MERGED) — PR #568 fixed primary citations; PR #570 (c4b3aa9) restored mutants.toml scope; Task 5 SWEEP in this PR removes residual drift before Guard 2 passes GREEN |
| Open gap context | STATE.md MUTANTS-ARBITER-OFFLINE-SELFTEST (justifies mandatory --self-test) |

---

## Behavioral Contracts

No BC-S.SS.NNN was authored for this cycle. The governing artifact is
`docs/specs/cargo-mutants-policy.md`. Each AC traces to the relevant policy doc section
rather than a BC clause.

| Policy Section | Topic | Guards |
|---------------|-------|--------|
| §Scope | Function-location bulleted list (lines 16–31); examine_globs list | Guard 2 validates §Scope bulleted-list (per-bullet file+function pairs); Guard 3 validates examine_globs entries |
| §CI Integration | --in-diff + examine_globs double-gate; 0-mutant legitimate path | Both guards ride existing CI jobs without changing gate composition |

---

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~4,500 |
| `docs/specs/cargo-mutants-policy.md` (full — §Scope + §CI Integration + §Guards new section) | ~4,500 |
| `.cargo/mutants.toml` (full file, 11 examine_globs entries) | ~400 |
| `scripts/check-signing-workflow-injection.sh` (--self-test prior-art reference) | ~1,000 |
| `scripts/check-bc-no-numeric-test-counts.sh` (bash guard prior-art reference) | ~800 |
| `tests/claude_md_citations.rs` (Guard 3 prior-art reference) | ~3,000 |
| `.github/workflows/ci.yml` (spec-guard job section, lines 110–132) | ~600 |
| F1 delta analysis §2/§3/§7 (Guards 2+3 scope sections) | ~3,000 |
| `CHANGELOG.md` ([Unreleased] section) | ~300 |
| `Cargo.toml` ([dev-dependencies] section) | ~150 |
| **Total** | **~18,250** |

Well within 20% agent context window budget. No splitting required.

---

## Tasks

**RED-gate staging (`tdd_mode: strict`):** Under strict TDD, tests and fixtures are authored
first and observed failing against stubs before the implementation exists. In this story:
Fixture A/B/C/D/E/F/G/H scripts (Task 2) are written first — a stub that unconditionally exits 0 makes
all eight fixtures fail RED. The test functions in Task 3 are written next (empty `validate_globs`
body makes tests fail RED). Only then does the implementer write the bash parsing logic and the
`validate_globs` helper to turn the suite GREEN. Per BC-5.38.001 Red Gate discipline.

1. Read `docs/specs/cargo-mutants-policy.md` §Scope. The function-location format is a
   **BULLETED LIST** (lines 16–31), NOT a markdown table. Each bullet maps a source file path
   (first backtick token) to the functions it contains. The `### Sibling Candidates Considered
   and Deferred` subsection (lines 40–49) is a markdown table of EXCLUDED files — DO NOT parse
   it as §Scope entries. Note the current 11-file scope list and expected (file, fn) pairs in Task 2.

2. Write `scripts/check-cargo-mutants-policy-citations.sh` (Guard 2):

   **Flags:**
   - Default (no flag): validate `docs/specs/cargo-mutants-policy.md` against actual `src/` files.
     The top-level argument parser sets `CANONICAL_MODE=1` when NEITHER `--self-test` NOR
     `--policy-doc` is supplied (i.e., canonical CI invocation). Quote verbatim:
     ```bash
     self_test=0
     CANONICAL_MODE=0
     # … argument parsing loop (example case-branch) …
     # --self-test) self_test=1 ;;
     # after parsing: if neither --self-test nor --policy-doc was supplied:
     if [ "$self_test" = "0" ] && [ -z "${POLICY_DOC+x}" ]; then CANONICAL_MODE=1; fi
     ```
     `self_test=0` is initialized BEFORE the parse loop (prior art: `check-signing-workflow-injection.sh:68`
     `SELF_TEST_MODE=false`). Without this, `set -u` aborts the CANONICAL_MODE gate on
     canonical CI invocations where `$self_test` was never set by a flag. `run_check` reads
     `CANONICAL_MODE` to gate the SCOPE-COVERAGE-FLOOR check.
   - `--policy-doc <path>`: validate the given file instead of the default. REQUIRED for self-test
     mode; without it, self-test would circularly parse the real policy doc. When `--policy-doc`
     is supplied WITHOUT `--self-test`, `CANONICAL_MODE` remains 0 — the decisive exemption is
     the `[ -z "${POLICY_DOC+x}" ]` clause in the CANONICAL_MODE gate: `POLICY_DOC` is set, so
     the clause is false and `CANONICAL_MODE` is never set to 1. When `--self-test` is ALSO
     supplied, the `[ "$self_test" = "0" ]` condition is additionally false (both conditions
     block the assignment; either alone is sufficient).
   - `--src-root <dir>`: redirect all definition-grep file lookups to this directory root instead
     of the real repo root (pass-2 C-2 FIX). REQUIRED for Fixture B — without it, Fixture B's
     outcome depends on whether `handle_jsm_create` drifts back into the real `src/cli/issue/create.rs`
     in future (hermetic isolation: fixture outcome must be determined solely by the controlled
     mock source file, not real-repo state).
     **F-H2 FIX:** `--src-root` passed WITHOUT `--self-test` is a usage error — exit 64 with message
     `Error: --src-root is only valid with --self-test`. This prevents accidental redirect of a real
     guard run to a temp directory, which would silently skip all definition lookups.
   - `--self-test`: run all eight self-test fixtures (below); exit 0 if all eight pass, 1 if any fails.
     The arg parser does NOT set `CANONICAL_MODE=1` when `--self-test` is supplied — fixtures are
     always exempt from the SCOPE-COVERAGE-FLOOR (except Fixture H which explicitly sets CANONICAL_MODE=1
     to exercise the floor).

   **Parsing algorithm — §Scope bulleted list (pass-2 I-2/C-3/C-4 FIX):**
   - **Repo-root resolution (pass-2 I-2):** Use SCRIPT_DIR convention (per
     `scripts/check-signing-workflow-injection.sh:59-60`):
     ```bash
     SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
     REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
     ```
     Lets contributors run the script from any working directory, not only from repo root.
   - **Default variable initialization (MED-3 FIX):** At the top of `run_check` (before any
     parsing), initialize defaults to prevent unbound-variable failures under `set -u` when
     canonical mode is active (no `--policy-doc` or `--src-root` supplied by the caller):
     ```bash
     SRC_ROOT="${SRC_ROOT:-$REPO_ROOT}"
     POLICY_DOC="${POLICY_DOC:-$REPO_ROOT/docs/specs/cargo-mutants-policy.md}"
     ```
     These are the canonical defaults. Self-test fixtures set both variables explicitly before
     calling `run_check`, so the defaults are never active during `--self-test`.
   - Scope extraction: lines from `## Scope` heading (exclusive) to the next `## ` heading or
     `### Sibling Candidates` subsection (exclusive, whichever first). Stops before excluded-files
     table at lines 40–49.
   - Skip fenced code block content (between ` ``` ` markers) within the §Scope range.
     **Defensive only (pass-2 I-4 FIX):** the current §Scope section (lines 16–31) contains no fenced
     code blocks; the §Whitelist-Convention section (~lines 359–388) is OUTSIDE §Scope (never
     reached by the parser). This rule guards against future §Scope additions that include code
     examples — it is not triggered by any current content.
   - **Bullet-continuation grammar (LOW-3 FIX; F-H-1 FIX):** Bullet start matches `^- ` (ANY
     dash bullet within the §Scope range); continuation lines match `^[[:space:]]{2,}` (two or
     more leading spaces) AND do NOT start a new bullet (`^- `). A group terminates at: (1) a
     blank line, (2) the start of the next bullet (`^- `), or (3) the §Scope range boundary
     (next `## ` heading or `### Sibling Candidates`). This prevents the prose after the bulleted
     list (e.g. `docs/specs/cargo-mutants-policy.md` lines 33–38: `Configured in .cargo/mutants.toml...`)
     from being swallowed into the `src/cache.rs` bullet group, which would cause `examine_globs`
     to be extracted as a function name via the token-filter step.
     **File path** = first backtick token starting with `src/` in the assembled group. A bullet
     with NO such token → shape-guard offender (`DEAD: malformed bullet skipped: <bullet start line>`
     appended to offenders list; script exits 1 via non-empty offenders predicate). **N counts ALL `^- ` bullets** (including malformed ones — N is the count of
     dash-bullet lines found, regardless of shape). **SCOPE-EMPTY** = N=0 (zero `^- ` bullets).
   - **Token extraction (pass-2 C-3 portability FIX):** from the group text:
     - **`file=""` initialization (F-2 FIX):** Initialize `file=""` before the backtick-token
       extraction loop so `$file` is always bound under `set -u`, even when a bullet group
       contains no valid `src/`-path token.
     - Extract backtick tokens using `grep -oE` with a pattern matching a backtick, one or more
       non-space non-backtick characters, then a closing backtick. Use `-oE` (POSIX extended RE,
       portable to both GNU and BSD grep) NOT `-oP` (GNU-only PCRE). Excludes multi-word phrases
       like `` `issue create` `` (space prevents match).
     - Skip the file-path token.
     - For tokens with `::` (e.g., `` `JsmRequestBuilder::build` ``): extract part after last `::`
       (→ `build`).
     - Filter to tokens matching `^[a-z_][a-z0-9_]*$` — pure snake_case, no `*`, no `/`.
       Excludes `` `handle_edit*` `` (glob char) and any residual prose tokens.
   - **`|| true` on all may-match-zero grep calls (pass-2 C-4 FIX):** with `set -euo pipefail`, any grep
     returning exit 1 (zero matches) aborts the script before all offenders are collected. Every
     grep that may legitimately return zero matches MUST be guarded with `|| true`.
     Pattern per `scripts/check-spec-counts.sh:23`: `actual=$(grep -c '^...' "$f" || true)`.
   - **SWEEP: see Task 5 for the authoritative SWEEP checklist (single source of truth; pass-2 C-1/pass-3 H-2
     FIX).** The expected (file, fn) pairs table above reflects the post-SWEEP state. Verify by
     running the grammar against the updated policy doc — must produce exactly the table entries.

   **Expected (file, fn) pairs** (after Task 5 SWEEP cleanup):

   | File | Function names | Notes |
   |------|---------------|-------|
   | `src/adf.rs` | `markdown_to_adf`, `adf_to_text`, `text_to_adf` | In parenthetical after description |
   | `src/cli/issue/create.rs` | `handle_create`, `parse_field_kv` | After SWEEP removes relocation prose |
   | `src/cli/issue/edit.rs` | `handle_edit`, `handle_edit_bulk_labels`, `handle_edit_bulk_fields` | |
   | `src/cli/issue/jsm_create.rs` | `handle_jsm_create` | |
   | `src/api/jira/bulk.rs` | `await_bulk_task` | |
   | `src/types/jira/bulk.rs` | _(none — file-existence-only)_ | "serde structs" entry; I-4 |
   | `src/api/jsm/requests.rs` | `build` (from `JsmRequestBuilder::build`) | `::` prefix stripped |
   | `src/api/jsm/request_types.rs` | `list_request_types`, `get_request_type_fields` | |
   | `src/cli/requesttype.rs` | `handle_list`, `handle_fields`, `resolve_request_type_id` | |
   | `src/api/jira/issues.rs` | `search_issues`, `search_issue_keys`, `list_comments` | |
   | `src/cache.rs` | `write_cmdb_fields_cache`, `write_object_type_attr_cache` | Continuation-line parens; real fns |

   - **File-existence-only (pass-2 I-4):** `src/types/jira/bulk.rs` cites no fn names ("serde structs for
     bulk API responses"). Check only `[ -f "$SRC_ROOT/$file" ]` (LOW-2 FIX — slash-joined with SRC_ROOT,
     same path construction as the definition-grep step); skip the symbol grep for this entry.

   - **Processing loop (Obs-b):** The extracted §Scope bullets are processed in a loop — one
     iteration per bullet. Each iteration performs file-existence check, token extraction, and
     per-function definition grep, accumulating offenders into a list. The shape-guard `continue`
     (below) and all per-bullet work execute inside this loop; `continue` skips a malformed bullet
     without aborting the loop or exiting the script.

   - **File-path shape guard (L-5 FIX, MED-5 FIX; F-H-1 FIX; L-3 FIX; MED-3 FIX):** Within the processing loop,
     after entering a bullet (start matches `^- `), extract the first backtick token starting
     with `src/` from the assembled group. If none is found (or the path is invalid), validate
     the extracted file path against a safe pattern — also rejecting path-traversal sequences:
     ```bash
     if ! [[ "$file" =~ ^src/[a-zA-Z0-9_/.-]+\.rs$ ]] || [[ "$file" == *".."* ]]; then
       offenders+=("DEAD: malformed bullet skipped: $bullet_line")
       continue
     fi
     ```
     The `[[ "$file" == *".."* ]]` traversal guard (L-3 FIX) is the SOLE defense against
     path-traversal attacks — the regex `^src/[a-zA-Z0-9_/.-]+\.rs$` does NOT reject `..`:
     the `.` inside the character class `[...]` is literal (not a wildcard), so
     `src/../etc/passwd.rs` satisfies the regex (`.` and `/` are both in the class). The
     traversal guard is NOT belt-and-suspenders redundancy; it is the only rejection mechanism
     for `../`-containing paths.
     The `failed=1` variable is removed (MED-3 FIX): the exit predicate is `rc = 1 iff offenders
     list non-empty`. SCOPE-EMPTY and SCOPE-COVERAGE-FLOOR use explicit `return 1`; malformed
     bullets exit 1 by appending to offenders. A separate `failed` flag is redundant.
     A malformed §Scope bullet is drift, not noise: it emits `DEAD: malformed bullet skipped:
     <line text>` into the offenders list. Fixtures A/B/C/D/F/H use well-formed skeletons
     that pass the shape check; Fixture E is deliberately malformed to exercise this path.

   - **Definition-anchored grep — MANDATORY (pass-1 C-1/pass-2 C-3/pass-2 I-1 FIX; F-M-1 FIX):** For each (file, function) pair:
     ```bash
     grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe|const|async|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${function}([^[:alnum:]_]|$)" "$SRC_ROOT/$file"
     ```
     **Invariant (F-M-1 FIX):** ALL filesystem accesses inside `run_check` MUST use `$SRC_ROOT`-prefixed
     paths — the file-existence check (`[ -f "$SRC_ROOT/$file" ]`) and this grep both use `$SRC_ROOT/$file`.
     Never use bare `"$file"` — it resolves against the process CWD, which differs between canonical CI
     runs and self-test fixtures that override `SRC_ROOT` for hermetic isolation.
     Matches function DEFINITIONS ONLY. Improvements vs v1.2 regex:
     - `const/unsafe/extern "ABI"` qualifiers supported (pass-2 I-1 FIX — broadened from `async`-only).
     - `\b` replaced with `([^[:alnum:]_]|$)` (pass-2 C-3 FIX — POSIX-portable; `\b` is GNU-only).
     Does NOT match imports or call sites. A plain `grep -q "$function"` would false-green on
     `use super::jsm_create::{handle_jsm_create};` at `src/cli/issue/create.rs:15` —
     the exact DEC-149 drift class. NEVER use plain `grep -q`.

   - **Missing-cited-file behavior (F-4 FIX):** If the cited source FILE does not exist at all
     (not just missing function): emit `DEAD: <file> not found` (one line; no per-function loop
     attempted). If the file EXISTS but a specific function is not found: emit `DEAD: <function>
     not found in <file>` (one line per function). File-existence-only entries (e.g.
     `src/types/jira/bulk.rs`, no fn names) that are missing emit `DEAD: <file> not found`.
   - **Error format — CI-MUTANTS-CITE-001 (pass-3 H-1/pass-1 O-4 FIX):** Each offender line: `DEAD: <function> not found in <file>` (when file exists, fn missing) or `DEAD: <file> not found` (when file itself is missing).
     Summary line: `K stale citation(s) found in <policy-doc-path> §Scope`
     (exact grammar; K = offender count, a decimal number; distinct from N = bullet count used
     by SCOPE-EMPTY/SCOPE-COVERAGE-FLOOR and the positive-coverage-summary;
     `<policy-doc-path>` is the actual file path used —
     the `--policy-doc` argument if supplied, otherwise the default canonical path
     `docs/specs/cargo-mutants-policy.md`). **F-1 FIX:** Self-test fixtures use `--policy-doc <tmp>`
     so they print the temp path, not the canonical path; self-test assertions MUST match `.+` not
     a literal path. CI invocation (no `--policy-doc`) naturally prints the canonical path.
     The literal `"CI-MUTANTS-CITE-001"` MUST appear in the script's header comment.
     `--self-test` Fixture A MUST capture the script output and assert it contains the substring
     `DEAD: ` and ` not found in `, and that the summary line matches
     `^[0-9]+ stale citation\(s\) found in .+ §Scope$`.
     NO "or inline comment" fallback — the self-test assertion is the pin.
   - **SCOPE-EMPTY guard (F-C3 FIX; F-H-1 FIX; F-M-3 FIX):** After parsing, if zero `^- ` dash-bullet
     lines were found in §Scope (N=0), return 1 immediately with:
     `SCOPE-EMPTY: 0 bullets parsed from §Scope — policy doc restructured or parser broken`
     This prevents an empty-§Scope (restructured section, wrong heading, parser bug) from producing
     a false-green exit 0 by simply finding no offenders in an empty set. SCOPE-EMPTY fires
     unconditionally regardless of mode (N=0 is always wrong — regardless of whether any bullets were
     malformed). NOTE: `run_check` MUST use `return 1`, not `exit 1` — the top-level entry point
     translates the return status to `exit` (MED-1 contract).
   - **SCOPE-COVERAGE-FLOOR (MED-2 FIX, F-MED-1 FIX; MED-1-P22 FIX: single-source threshold symbol):**
     Applied only when `[ "${CANONICAL_MODE:-0}" = "1" ]`
     (set by the arg parser only when neither `--self-test` nor `--policy-doc` was supplied).
     After SCOPE-EMPTY check: declare `local FLOOR=11` and test `[ "$N" -lt "$FLOOR" ]` (the current
     develop-HEAD §Scope bullet count). If the condition fires, return 1 with:
     `SCOPE-COVERAGE-FLOOR: expected >= ${FLOOR} §Scope bullets, got N. Update this PIN when bullets are intentionally removed (the floor is a lower bound; additions never fire it).`
     **Critical (MED-1-P22 FIX):** Both the comparison (`-lt "$FLOOR"`) and the message
     (`expected >= ${FLOOR}`) MUST use the `$FLOOR` variable, NOT the literal `11`. This closes the
     comparison-mutation window: a mutation changing `$FLOOR`'s assignment (`FLOOR=11` → `FLOOR=5`)
     changes both the comparison threshold AND the message, so the Fixture H substring assertion
     `expected >= 11` would fail (message now says `expected >= 5`). Without FLOOR binding, a mutation
     could weaken the comparison to `[ "$N" -lt 5 ]` while leaving the literal `11` in the message
     untouched — the substring assertion would pass despite the weakened guard.
     Mirrors Guard 3's `FLOOR: usize = 11` pin convention (see Task 3). The floor applies ONLY when
     `CANONICAL_MODE=1` — fixtures never set this variable and are therefore always exempt.
     **Interaction with SCOPE-EMPTY:** SCOPE-EMPTY (N=0, unconditional) is checked first and exits
     before the floor check; SCOPE-COVERAGE-FLOOR applies only when 1 ≤ N < 11 and `CANONICAL_MODE=1`.
     Both checks are independent; neither contradicts Fixture D — Fixture D's mock doc has an empty
     §Scope so SCOPE-EMPTY fires regardless (N=0, no mode distinction needed).
   - **Positive coverage summary (F-C3 FIX):** On success (exit 0, zero offenders), print:
     `Check passed: N bullets parsed, M (file, fn) pairs validated`
     where N = total bullets found, M = total (file, function) pairs checked. `src/types/jira/bulk.rs`
     is file-existence-only (0 fn names) — it contributes 1 to N but 0 to M. On develop HEAD
     post-SWEEP (canonical invocation, no `--policy-doc`), the expected output is:
     `Check passed: 11 bullets parsed, 21 (file, fn) pairs validated`
     (N=11 bullets; M=3+2+3+1+1+0+1+2+3+3+2=21 pairs, verified against the expected-pairs table).
     This summary confirms the guard did real work and didn't succeed by vacuously checking nothing.
   - Collect ALL offenders before exiting (no early-abort). Exit 0 if zero; exit 1 if any.
   - Add `#!/usr/bin/env bash` and `set -euo pipefail` at top.
   - **Bash syntax self-check (L-7 FIX; L-5 FIX — top-of-file, unconditional, before arg parsing):**
     ```bash
     bash -n "${BASH_SOURCE[0]}"
     ```
     Validates the script parses without syntax error on every invocation (canonical CI and
     `--self-test`). Adapted from `check-signing-workflow-injection.sh` prior art (which places
     the check unconditionally at file top before arg parsing). A syntax error would otherwise
     make `--self-test` fixture assertions vacuously fail for the wrong reason; placing this at
     file top ensures it fires even in canonical CI invocations where `--self-test` is not passed.

   **`run_check` function pattern (MED-1 FIX — IN-PROCESS exit-isolation):**
   The main check logic MUST be extracted into a function `run_check` that `return`s its status
   (0 or non-zero) — it MUST NOT call `exit` directly. Only the top-level entry point (outside
   `--self-test`) translates the final return status to `exit`. Each fixture invokes it with the
   SINGLE canonical idiom (quote verbatim):
   ```bash
   set +e; output=$(run_check 2>&1); rc=$?; set -e
   ```
   `set +e` temporarily suspends exit-on-error; `output=$(run_check 2>&1)` captures both stdout
   and stderr into `$output` (command substitution runs `run_check` in a subshell — shell variable
   mutations inside `run_check` do not propagate to the outer shell, but fixtures set `POLICY_DOC`
   and `SRC_ROOT` in the outer shell BEFORE the call, so the subshell inherits them); `rc=$?`
   captures the return code; `set -e` re-enables it. Without `set +e`, `run_check` finding a DEAD
   citation in Fixture A would cause exit-on-error to terminate the whole script — Fixtures B
   through H would never run.

   **`--self-test` — EIGHT fixtures required (pass-2 C-4/pass-2 C-2/pass-3 O-1/F-C3 FIX/F-MED-2 FIX/LOW-1 FIX/F-M-5 FIX/MED-1 FIX):**

   **Preamble check (L-4 FIX — run inside `--self-test`, BEFORE any fixture, exit 1 immediately on failure):**
   1. **CI-MUTANTS-CITE-001 literal pin (L-4 FIX; HIGH-1 FIX):**
      ```bash
      grep -Eq '^#.*CI-MUTANTS-CITE-001' "${BASH_SOURCE[0]}"
      ```
      Asserts the exact error-code literal is present in the script header comment (comment
      lines only — lines matching `^#`). The pattern-argument line itself begins with whitespace
      and `grep` (not `#`), so it cannot self-satisfy even if the header comment is deleted —
      closing the tautology in `grep -q "CI-MUTANTS-CITE-001"` (which always matched the
      pattern-argument line itself). Prior art: the JRACLOUD-95368 literal pin in
      `tests/rate_limit_cap_tests.rs` asserts RUNTIME stderr output emitted from a separate
      source file — a RUNTIME assertion. This is a STATIC comment pin: it asserts a comment
      present in the same source file; anchoring to `^#` is the analogous approach for a
      static pin. If the error code is accidentally deleted or renamed, this preamble check
      fails fast before any fixture runs — the literal is load-bearing, not decorative.

   **F-6 FIX — fixture-count integrity pin:** Initialize `fixtures_run=0` immediately before
   Fixture A. After each fixture's assertions complete (before the next fixture begins),
   increment: `fixtures_run=$((fixtures_run + 1))`. After all eight fixtures, assert:
   `[ "$fixtures_run" -eq 8 ] || { echo "SELF-TEST-FIXTURE-COUNT: expected 8 fixtures, got ${fixtures_run}"; exit 1; }`.
   This catches the drop-a-fixture refactor vector — silently removing a fixture leaves the
   remaining fixtures all passing while the guard's coverage shrinks undetected. The counter fires
   before `--self-test` exits 0, so the CI self-test step catches the gap.

   Fixture A (basic dead-symbol — LOW-1 FIX: IN-PROCESS semantics; L-1 FIX: hermetic isolation; L-5 FIX: two missing fns kill break-for-continue mutation):
   Creates tmpdir `$tmp_A`:
   - (a) mock policy-doc written to `$tmp_A/policy.md` with exact skeleton (L-5 FIX: TWO fn names in one bullet):
         ```bash
         printf '## Scope\n- `src/adf.rs` — `handle_nonexistent_fn_selftest`, `another_missing_fn_selftest`\n\n## Terminator\n' \
           > "$tmp_A/policy.md"
         ```
         (two fn names in the same bullet; neither is defined in the empty stub — the guard must
         report BOTH as DEAD; kills a `break`-for-`continue` mutation that stops after the first
         offender in the fn-name loop)
   - (b) mock stub source file at `$tmp_A/src/adf.rs` (empty — neither function is defined):
         ```bash
         mkdir -p "$tmp_A/src"
         touch "$tmp_A/src/adf.rs"
         ```
   - (c) Sets internal variables `POLICY_DOC="$tmp_A/policy.md"` and `SRC_ROOT="$tmp_A"`.
         IN-PROCESS. Hermetic: outcome depends solely on the controlled empty stub, not on the
         real `src/adf.rs` (which defines `markdown_to_adf` etc. — a plain `grep -q` on the
         real file could vacuously pass even for a nonexistent fn if the grep pattern is too broad).
   - Calls `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX canonical idiom).
   - Asserts `rc=1` AND captured output contains BOTH `handle_nonexistent_fn_selftest` AND
     `another_missing_fn_selftest` (two separate assertions or one regex covering both).

   Fixture B (import-only false-green proof — pass-2 C-2/pass-2 I-7 FIX; v1.9.1 rationale fix):
   Uses `--src-root <dir>` for hermetic isolation. The algorithm greps the file cited IN the
   bullet (`src/cli/issue/create.rs`), which currently holds only an import line — so even
   without `SRC_ROOT`, the grep returns DEAD today. However the fixture MUST NOT depend on
   real-repo `create.rs` content remaining stable: if `handle_jsm_create` were ever re-added
   to `create.rs`, the definition-anchored grep would pass against the real file, making the
   fixture falsely green. `SRC_ROOT="$tmp_B"` provides hermetic isolation — the fixture's
   outcome is determined solely by the controlled mock source file, independent of real-repo
   state.
   - Creates tmpdir `$tmp_B`:
     (a) mock policy-doc at `$tmp_B/policy.md` with exact skeleton (MED-4 FIX):
         ```bash
         printf '## Scope\n- `src/cli/issue/create.rs` — `handle_jsm_create`\n\n## Terminator\n' \
           > "$tmp_B/policy.md"
         ```
     (b) mock source file at `$tmp_B/src/cli/issue/create.rs` containing ONLY
         an import line (NO fn definition):
         ```bash
         mkdir -p "$tmp_B/src/cli/issue"
         printf 'use super::jsm_create::{handle_jsm_create};\n' > "$tmp_B/src/cli/issue/create.rs"
         ```
   - Sets internal variables `POLICY_DOC="$tmp_B/policy.md"` and `SRC_ROOT="$tmp_B"`.
     IN-PROCESS (F-2 FIX — no subprocess re-invocation; the F-H2 CLI fence fires only at
     argument-parser entry, not inside the `--self-test` handler).
   - Calls `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX canonical idiom).
   - Asserts `rc=1` AND that the captured output contains `DEAD: `, ` not found in `, and
     `handle_jsm_create`. Proves definition-anchored grep rejects import-only presence.

   Fixture C (empty src-root — all citations dead, pass-3 O-1/F-3 MOVED FROM AC-002; F-4 FIX;
   MED-1 FIX: POLICY_DOC binding added):
   - Creates tmpdir `$tmp_C`:
     (a) mock policy-doc written to `$tmp_C/policy.md` with exact skeleton (MED-4 FIX):
         ```bash
         printf '## Scope\n- `src/foo.rs` — `fn_alpha`\n- `src/bar.rs` — `fn_beta`\n\n## Terminator\n' \
           > "$tmp_C/policy.md"
         ```
     (b) Sets internal variables `POLICY_DOC="$tmp_C/policy.md"` and `SRC_ROOT="$tmp_C"` —
         empty directory; neither `src/foo.rs` nor `src/bar.rs` exists there. IN-PROCESS; F-H2
         CLI fence not involved (inside `--self-test`).
   - Calls `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX canonical idiom).
   - Under the F-4 missing-file rule: the script emits `DEAD: src/foo.rs not found` (file absent —
     no per-function loop attempted) and `DEAD: src/bar.rs not found` (same). The function names
     `fn_alpha`/`fn_beta` do NOT appear in the output — the file-missing path fires first.
   - Asserts `rc=1` AND that output contains BOTH `DEAD: src/foo.rs not found` AND
     `DEAD: src/bar.rs not found` (two DEAD lines).
   - Proves the "collect ALL offenders" invariant across multiple missing files AND pins the F-4
     missing-file output format.

   Fixture D (scope-empty — SCOPE-EMPTY guard, F-C3/F-3 MOVED FROM AC-002; L-4 FIX):
   - **Variable isolation (L-4 FIX):** Execute `unset SRC_ROOT POLICY_DOC` before this fixture.
     Fixture D relies on `run_check`'s default `SRC_ROOT="${SRC_ROOT:-$REPO_ROOT}"` and does not
     set `SRC_ROOT` itself; prior fixtures A/B/C may leave `SRC_ROOT` pointing to a temp dir.
   - Creates tmpdir `$tmp_D`, writes mock policy-doc with exact skeleton (MED-4 FIX):
     ```bash
     printf '## Scope\n\n## Terminator\n' > "$tmp_D/policy.md"
     ```
     (empty §Scope — no bullet lines between headings)
   - Sets internal variable `POLICY_DOC="$tmp_D/policy.md"`. IN-PROCESS.
   - Calls `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX canonical idiom).
   - Asserts `rc=1` with captured output containing `SCOPE-EMPTY:`.
   - Proves the guard does not vacuously exit 0 when §Scope is empty or restructured.

   Fixture E (malformed-bullet shape-guard — F-MED-2 FIX: covers zero-fixture gap on MED-5 path; L-4 FIX; F-2 FIX: third bullet exercises traversal guard; LOW-3-P22 FIX: hermetic SRC_ROOT):
   - **Variable isolation (L-4 FIX; LOW-3-P22 FIX):** Execute `unset SRC_ROOT POLICY_DOC` before
     this fixture, then set `SRC_ROOT="$tmp_E"` (hermetic parity with Fixtures F and G — prior
     fixtures A/B/C/D may leave `SRC_ROOT` pointing to a temp dir). All three malformed-bullet
     traces are shape-guard or traversal-guard failures that exit BEFORE any filesystem access
     (grep never runs), so the SRC_ROOT value does not affect the test outcome. Setting it
     explicitly prevents a REPO_ROOT fallthrough that could interact with a future fixture change.
   - Creates tmpdir `$tmp_E`, writes mock policy-doc with THREE malformed bullets (exact skeleton):
     ```bash
     printf '## Scope\n- not-a-backtick-path — some_fn\n- `docs/foo.md` — non_src_fn\n- `src/../escape.rs` — `some_fn`\n\n## Terminator\n' \
       > "$tmp_E/policy.md"
     ```
     Bullet traces:
     - Bullet 1 (`not-a-backtick-path`): no `src/`-path backtick token → shape-guard fires.
     - Bullet 2 (`` `docs/foo.md` ``): backtick token does not start with `src/` → shape-guard fires.
     - Bullet 3 (`` `src/../escape.rs` ``): backtick token starts with `src/` (extracted as `file`);
       shape regex `^src/[a-zA-Z0-9_/.-]+\.rs$` MATCHES (`.` is literal in the class, so `..` passes
       the regex); traversal guard `[[ "$file" == *".."* ]]` FIRES (SOLE defense) →
       shape-guard fires. This bullet is the RED-proof that the traversal guard is wired to the
       offenders list (kills a mutation that deletes or bypasses the traversal guard).
   - Sets internal variables `POLICY_DOC="$tmp_E/policy.md"` and `SRC_ROOT="$tmp_E"`. IN-PROCESS.
   - Calls `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX canonical idiom).
   - Asserts `rc=1`, that the captured output contains `DEAD: malformed bullet skipped:` THREE TIMES
     (once per malformed bullet, in offender-list order), AND that the summary line matches
     `^[0-9]+ stale citation\(s\) found in .+ §Scope$`.
   - Proves: (1) the shape-guard fires for non-`src/`-path bullets; (2) the traversal guard fires
     for `../`-containing paths even when the regex matches; (3) deleting the offenders-append,
     the shape-guard, or the traversal guard would reduce the offender count below 3 and fail this fixture.

   Fixture F (success path with mock fn definitions — LOW-1 FIX: kills omitted-summary and
   inverted-polarity mutants; F-3 FIX: exercises regex qualifier alternation; F-5 FIX: exercises
   snake_case filter by including a filtered non-snake-case token; MED-2-P22 FIX: extends to cover
   pub(super)/pub(crate) visibility and async fn, plus indented impl-block form):
   - Creates tmpdir `$tmp_F`:
     (a) mock policy-doc at `$tmp_F/policy.md` with exact skeleton (7 snake_case fns + 1 filtered token):
         ```bash
         printf '## Scope\n- `src/mock_mod.rs` — `mock_fn_alpha`, `mock_const_fn`, `mock_unsafe_fn`, `mock_extern_fn`, `mock_scoped_async_fn`, `mock_crate_fn`, `mock_indented_fn`, `SomeStruct`\n\n## Terminator\n' \
           > "$tmp_F/policy.md"
         ```
         `SomeStruct` is backtick-quoted but NOT snake_case — filtered by `^[a-z_][a-z0-9_]*$`;
         it contributes zero fn names and no DEAD line (proving the filter works without adding an offender).
     (b) mock source file at `$tmp_F/src/mock_mod.rs` containing 7 fn definitions with varied qualifiers:
         ```bash
         mkdir -p "$tmp_F/src"
         printf 'pub fn mock_fn_alpha() {}\nconst fn mock_const_fn() -> u32 { 0 }\nunsafe fn mock_unsafe_fn() {}\nextern "C" fn mock_extern_fn() {}\npub(super) async fn mock_scoped_async_fn() {}\npub(crate) fn mock_crate_fn() {}\nimpl MockStruct {\n    pub async fn mock_indented_fn() {}\n}\n' \
           > "$tmp_F/src/mock_mod.rs"
         ```
         Each definition matches the story's definition-anchored grep regex (verified against
         `^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe|const|async|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${function}([^[:alnum:]_]|$)`):
         - `pub fn mock_fn_alpha()` — plain public fn
         - `const fn mock_const_fn()` — `const` qualifier in alternation group
         - `unsafe fn mock_unsafe_fn()` — `unsafe` qualifier in alternation group
         - `extern "C" fn mock_extern_fn()` — `extern "ABI"` qualifier in alternation group
         - `pub(super) async fn mock_scoped_async_fn()` — `pub(\([^)]*\))?` matches `pub(super)`;
           `async` matches the qualifier alternation group (MED-2-P22 FIX)
         - `pub(crate) fn mock_crate_fn()` — `pub(\([^)]*\))?` matches `pub(crate)` (MED-2-P22 FIX)
         - `    pub async fn mock_indented_fn()` — 4-space indent; `[[:space:]]*` matches leading
           spaces; `pub` matched; `async` in alternation; fn defined inside `impl MockStruct { }` block
           (the grep regex does NOT require top-level scope — `[[:space:]]*` allows any leading
           whitespace, so impl-block-indented fns match). (MED-2-P22 FIX)
   - Sets internal variables `POLICY_DOC="$tmp_F/policy.md"` and `SRC_ROOT="$tmp_F"`. IN-PROCESS.
   - Calls `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX canonical idiom).
   - Asserts `rc=0` AND that the captured output matches the regex
     `^Check passed: 1 bullets parsed, 7 \(file, fn\) pairs validated$`.
     (`SomeStruct` is filtered — does not increment M; M=7 not M=8.)
   - Proves: (1) definition-anchored grep succeeds for pub/const/unsafe/extern/pub(super)/pub(crate)/async-qualified and impl-indented fns;
     (2) non-snake-case tokens are filtered and do not increment M or produce DEAD lines;
     (3) positive coverage summary is emitted on success (POL-11 positive-coverage mutant class killed).

   Fixture G (file-existence-only class — F-M-5 FIX: exercises the zero-fn-name path where a
   bullet's file exists but no function names are extracted):
   - Creates tmpdir `$tmp_G`:
     (a) mock policy-doc at `$tmp_G/policy.md` with exact skeleton:
         ```bash
         printf '## Scope\n- `src/mock_mod.rs` — serde structs for X\n\n## Terminator\n' \
           > "$tmp_G/policy.md"
         ```
         (one bullet; file path `src/mock_mod.rs` is the first backtick-quoted `src/` token;
         "serde structs for X" are plain prose — none are backtick-quoted — so the backtick
         extraction step produces ONE candidate token (the file-path token `src/mock_mod.rs`);
         the file-path-skip step consumes it; the snake_case filter never runs (no remaining
         tokens); result: 1 bullet parsed, 0 fn names)
     (b) mock source file at `$tmp_G/src/mock_mod.rs` — EXISTS but is EMPTY:
         ```bash
         mkdir -p "$tmp_G/src"
         touch "$tmp_G/src/mock_mod.rs"
         ```
         File exists, so the file-existence check passes; no fn-name loop iterations (0 fn names).
   - Sets internal variables `POLICY_DOC="$tmp_G/policy.md"` and `SRC_ROOT="$tmp_G"`. IN-PROCESS.
   - Calls `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX canonical idiom).
   - Asserts `rc=0` AND that the captured output matches the regex
     `^Check passed: 1 bullets parsed, 0 \(file, fn\) pairs validated$`.
   - Proves: (1) the success path emits correct N/M counts when M=0 (file-existence-only entry);
     (2) the guard does NOT false-fail when a cited file exists but has zero fn names to verify.

   Fixture H (SCOPE-COVERAGE-FLOOR RED-provable — MED-1 FIX: the only fixture that sets CANONICAL_MODE=1
   to exercise the floor; all other fixtures leave CANONICAL_MODE unset and are exempt; F-1 FIX:
   threshold-specific assertions + N=11 boundary companion call):
   - Creates tmpdir `$tmp_H`:
     (a) mock policy-doc at `$tmp_H/policy.md` with exactly 2 well-formed bullets (one per `^- ` line):
         ```bash
         printf '## Scope\n- `src/mock_h.rs` — `mock_fn_one_selftest`\n- `src/mock_h2.rs` — `mock_fn_two_selftest`\n\n## Terminator\n' \
           > "$tmp_H/policy.md"
         ```
         (2 separate `^- ` dash-bullet lines → N=2; each cites one fn defined in its own mock source
         file — definition-anchored grep succeeds for both; SCOPE-EMPTY does not fire (N>0);
         floor fires because N=2 < 11 and CANONICAL_MODE=1; fixture isolates the floor check
         from the dead-citation path)
     (b) two mock source files — one per bullet — each containing its fn definition:
         ```bash
         mkdir -p "$tmp_H/src"
         printf 'fn mock_fn_one_selftest() {}\n' > "$tmp_H/src/mock_h.rs"
         printf 'fn mock_fn_two_selftest() {}\n' > "$tmp_H/src/mock_h2.rs"
         ```
     (c) companion mock policy-doc `$tmp_H/policy_h_boundary.md` with exactly 11 well-formed bullets
         (boundary case: N=11, the exact floor threshold, MUST NOT fire the floor):
         ```bash
         printf '## Scope\n- `src/mock_h_boundary.rs` — `fn_b01`\n- `src/mock_h_boundary.rs` — `fn_b02`\n- `src/mock_h_boundary.rs` — `fn_b03`\n- `src/mock_h_boundary.rs` — `fn_b04`\n- `src/mock_h_boundary.rs` — `fn_b05`\n- `src/mock_h_boundary.rs` — `fn_b06`\n- `src/mock_h_boundary.rs` — `fn_b07`\n- `src/mock_h_boundary.rs` — `fn_b08`\n- `src/mock_h_boundary.rs` — `fn_b09`\n- `src/mock_h_boundary.rs` — `fn_b10`\n- `src/mock_h_boundary.rs` — `fn_b11`\n\n## Terminator\n' \
           > "$tmp_H/policy_h_boundary.md"
         printf 'fn fn_b01() {}\nfn fn_b02() {}\nfn fn_b03() {}\nfn fn_b04() {}\nfn fn_b05() {}\nfn fn_b06() {}\nfn fn_b07() {}\nfn fn_b08() {}\nfn fn_b09() {}\nfn fn_b10() {}\nfn fn_b11() {}\n' \
           > "$tmp_H/src/mock_h_boundary.rs"
         ```
   - Sets `POLICY_DOC="$tmp_H/policy.md"`, `SRC_ROOT="$tmp_H"`. IN-PROCESS.
   - Sets `CANONICAL_MODE=1` explicitly (this is the ONLY fixture that does so — deliberate,
     to exercise the SCOPE-COVERAGE-FLOOR which requires CANONICAL_MODE=1 AND N < 11).
   - **RED call (N=2):** Calls `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX canonical idiom).
   - Asserts `rc=1` AND that the captured output:
     - contains `SCOPE-COVERAGE-FLOOR:` (guard fires)
     - contains `expected >= 11` (pins the floor threshold — kills mutations weakening 11→[3..10])
     - contains `got 2` (pins the count in the message — confirms the message format is correct)
   - **GREEN companion call (N=11 boundary):** Re-assigns `POLICY_DOC="$tmp_H/policy_h_boundary.md"` (CANONICAL_MODE and SRC_ROOT remain set).
     Calls `set +e; output_h2=$(run_check 2>&1); rc_h2=$?; set -e`.
   - Asserts `rc_h2=0` AND that `output_h2` does NOT contain `SCOPE-COVERAGE-FLOOR:` (floor does NOT
     fire at exactly N=11 — boundary GREEN proof; kills mutations weakening `< 11` to `<= 11`).
   - Unsets `CANONICAL_MODE` after both calls to restore default state for any subsequent code.
   - Proves: (1) the floor fires when N < 11 and CANONICAL_MODE=1; (2) the floor message contains
     `expected >= 11` and `got 2` (threshold + actual count pinned); (3) the floor does NOT fire
     at exactly N=11 (boundary is exclusive); (4) any mutation weakening 11→[3..10] would be
     caught by the `expected >= 11` and `got 2` assertions; mutations weakening `< 11` to `<= 11`
     are caught by the companion GREEN call.

   **Temp hygiene — ordering (MED-2 FIX, pass-2 I-6; F-M-5 FIX; MED-1 FIX):** Register one EXIT trap covering all
   eight fixture dirs (quote verbatim):
   ```bash
   trap 'rm -rf "${tmp_A:-}" "${tmp_B:-}" "${tmp_C:-}" "${tmp_D:-}" "${tmp_E:-}" "${tmp_F:-}" "${tmp_G:-}" "${tmp_H:-}"' EXIT
   ```
   Default-expansion form (`${var:-}`) prevents unbound-variable abort under `set -u` when an
   early failure leaves some `tmp_X` variables unset — the unset var expands to an empty string
   and `rm -rf` skips it safely. Register this trap BEFORE creating any tmpdir. Each fixture
   creates its own `tmp_X=$(mktemp -d)` after the trap is in place. Never inline `mktemp`
   inside `trap`. After all eight fixtures complete, assert the fixture-count integrity pin
   (F-6 FIX): `[ "$fixtures_run" -eq 8 ] || { echo "SELF-TEST-FIXTURE-COUNT: expected 8 fixtures, got ${fixtures_run}"; exit 1; }`.
   `--self-test` exits 0 when ALL EIGHT fixtures behave as expected AND the count integrity pin passes. CI
   `--self-test` step MUST precede the real guard.

3. Write `tests/mutants_glob_existence.rs` (Guard 3):

   **Required helper functions (pass-2 I-8 FIX; L-2 FIX; MED-2 FIX):**
   1. `fn validate_globs(entries: &[String]) -> Vec<String>` — given a list of glob patterns,
      runs `glob::glob()` expansion on each and returns the list of patterns that matched zero
      files. Tests 1, 2, and 3 call this helper.
   2. `fn extract_examine_globs_or_panic(value: &toml::Value) -> Vec<String>` — extracts the
      `examine_globs` array from a parsed TOML Value. If the extracted Vec is empty (key absent
      or renamed), panics with `MUTANTS-GLOBS-KEY-MISSING: examine_globs key not found in
      .cargo/mutants.toml — key renamed, section restructured, or examine_globs is present but
      empty`. BOTH test 1 (`test_resolve_all_examine_globs_entries_to_real_files`) AND test 4
      (`test_detect_missing_examine_globs_key_panics_with_key_missing_message`) MUST call this
      shared helper — this ensures that dropping or weakening the empty-Vec panic in the helper
      is caught by test 4's `catch_unwind` (the guard is not just a comment in test 1).
   3. `fn assert_examine_globs_coverage_floor(entries: &[String])` — **MED-1-P22 FIX: single-source
      threshold symbol.** Declare `const FLOOR: usize = 11;` at the top of the helper body. Use
      `FLOOR` in BOTH the comparison (`entries.len() < FLOOR`) AND the format string
      (`"MUTANTS-GLOBS-COVERAGE-FLOOR: expected >= {FLOOR} examine_globs entries, got {}. ..."`)
      so they cannot diverge. Full panic message:
      `"MUTANTS-GLOBS-COVERAGE-FLOOR: expected >= {FLOOR} examine_globs entries, got {}. Update this PIN when entries are intentionally removed (the floor is a lower bound; additions never fire it)."`.
      **Why FLOOR binding matters:** a mutation changing `entries.len() < FLOOR` to
      `entries.len() < 5` without changing `FLOOR` is impossible — `5` is never written separately.
      A mutation changing `const FLOOR: usize = 11` to `const FLOOR: usize = 5` propagates to both
      the comparison AND the message, so test 5's `assert!(msg.contains("got 3"))` and the companion
      GREEN test 6 (N=11, asserts no panic) together kill it: if FLOOR=5, N=11 would NOT panic but
      test 6 would still pass (N=11 >= 5), while the Fixture H bash assertion `expected >= 11`
      would fail (message now reads `expected >= 5`). In the Rust domain alone, test 6 (N=11,
      catch_unwind result is Ok) would panic if FLOOR were weakened to 12 or above.
      This helper is called by test 1 (real entries from `.cargo/mutants.toml`) AND is the subject
      of `catch_unwind` in test 5 (inline mock with <11 entries). Extracting the assertion into a
      shared helper makes a deletion-or-weakening mutation RED-provable via test 5 — without this,
      test 1's inlined `assert!` could be deleted or weakened and test 1 would still pass vacuously
      on real data (N=11 entries currently satisfies any N>=1 floor). The comment
      `// PIN: update when examine_globs adds/removes entries` MUST appear adjacent in the body.
   This follows the `tests/claude_md_citations.rs::extract_path_citations` pattern: guard
   logic lives in testable helpers, not inlined in test bodies.

   - `test_resolve_all_examine_globs_entries_to_real_files()` (pass-3 L-1 renamed; verb-first form):
     use `include_str!("../.cargo/mutants.toml")` + `toml::from_str::<toml::Value>` to extract
     `examine_globs` entries.
     **F-C2 FIX — two mandatory pre-flight assertions:**
     1. Assert the `examine_globs` key was found: call `extract_examine_globs_or_panic(&value)` —
        if the extracted Vec is empty (key absent or renamed), this shared helper panics with
        `MUTANTS-GLOBS-KEY-MISSING: examine_globs key not found in .cargo/mutants.toml — key
        renamed, section restructured, or examine_globs is present but empty`. This prevents a
        vacuous pass when the key is missing.
     2. Assert coverage floor: call `assert_examine_globs_coverage_floor(&entries)` — the shared
        helper (MED-2 FIX) panics with `MUTANTS-GLOBS-COVERAGE-FLOOR: ...` if `entries.len() < 11`.
        Do NOT inline the `assert!` here; the helper is required so test 5's `catch_unwind` can
        prove the floor is RED-provable.
     Then call `validate_globs` with the extracted entries. Assert the returned `Vec<String>` is empty.
     On failure: the dead-pattern Vec itself is the panic message — collect ALL dead patterns.
   - `test_reject_nonexistent_examine_globs_entry_returns_dead_list()` (F-11 renamed from
     `test_examine_globs_validator_rejects_nonexistent_path`; verb-first convention): call
     `validate_globs` with a one-element slice containing only
     `"src/nonexistent_dummy_for_selftest.rs"`. Assert the returned Vec is non-empty (contains
     the dead pattern).
   - `test_validate_globs_via_toml_parse_returns_dead_entry()` (pass-3 M-1: kills polarity mutant):
     inline mock TOML `examine_globs = ["src/nonexistent_dummy_for_selftest.rs"]`; parse via
     `toml::from_str::<toml::Value>` + extract entries; call `validate_globs`; assert Vec
     non-empty. Exercises the SAME parse→validate_globs code path as the real guard — a
     `is_empty()` vs `!is_empty()` polarity mutant in `validate_globs` is killed. <10ms, no #[ignore].
   - `test_detect_missing_examine_globs_key_panics_with_key_missing_message()` (F-MED-2 FIX;
     L-2 FIX — shared helper ensures RED-provability; mirrors bash Fixture D's SCOPE-EMPTY
     coverage): inline mock TOML WITHOUT the `examine_globs` key (e.g. `foo = ["bar"]` or
     empty `""`); parse via `toml::from_str::<toml::Value>`; wrap the call to
     `extract_examine_globs_or_panic(&value)` in `std::panic::catch_unwind(|| { ... })`;
     use the following exact Err-arm form (copy-pasteable; handles both `String` and `&'static str` panic payloads):
     ```rust
     let err = result.unwrap_err();
     let msg = err.downcast_ref::<String>().map(|s| s.as_str())
         .or_else(|| err.downcast_ref::<&str>().copied())
         .unwrap();
     assert!(msg.contains("MUTANTS-GLOBS-KEY-MISSING"),
         "expected MUTANTS-GLOBS-KEY-MISSING in panic message, got: {}", msg);
     ```
     Verb-first convention: `detect` is the verb; `missing_examine_globs_key` is the subject;
     `panics_with_key_missing_message` is the outcome. <10ms, no `#[ignore]`.
   - `test_coverage_floor_panics_when_entries_below_threshold()` (MED-2 FIX — makes the
     `>= 11` floor RED-provable; kills a mutation that deletes or weakens `assert_examine_globs_coverage_floor`):
     inline mock TOML with exactly 3 entries (below the 11-entry floor):
     ```rust
     let mock_toml = r#"examine_globs = ["src/a.rs", "src/b.rs", "src/c.rs"]"#;
     let value = toml::from_str::<toml::Value>(mock_toml).unwrap();
     let entries = extract_examine_globs_or_panic(&value);
     let result = std::panic::catch_unwind(|| {
         assert_examine_globs_coverage_floor(&entries);
     });
     let err = result.unwrap_err();
     let msg = err.downcast_ref::<String>().map(|s| s.as_str())
         .or_else(|| err.downcast_ref::<&str>().copied())
         .unwrap();
     assert!(msg.contains("MUTANTS-GLOBS-COVERAGE-FLOOR"),
         "expected MUTANTS-GLOBS-COVERAGE-FLOOR in panic message, got: {}", msg);
     assert!(msg.contains("got 3"),
         "expected 'got 3' in MUTANTS-GLOBS-COVERAGE-FLOOR panic message, got: {}", msg);
     ```
     Verb-first: `coverage_floor` is the subject; `panics_when_entries_below_threshold` is the
     outcome. F-1(c) FIX: `got 3` assertion pins the count format — kills mutations that emit
     `got N` with a different N or omit the count entirely. <10ms, no `#[ignore]`.
   - `test_coverage_floor_does_not_panic_at_exact_threshold()` (F-1(d) FIX — boundary GREEN proof:
     proves the floor does NOT fire at N=11, the exact threshold; kills mutations weakening `< 11`
     to `<= 11`):
     inline 11-entry mock (one per each of the 11 entries at the threshold), calls
     `assert_examine_globs_coverage_floor` wrapped in `std::panic::catch_unwind`:
     ```rust
     let entries: Vec<String> = (1..=11).map(|i| format!("src/mock_{}.rs", i)).collect();
     let result = std::panic::catch_unwind(|| {
         assert_examine_globs_coverage_floor(&entries);
     });
     assert!(result.is_ok(), "floor must NOT fire at exactly N=11 (inclusive boundary), got panic");
     ```
     Verb-first convention: `coverage_floor` is the subject; `does_not_panic_at_exact_threshold`
     is the outcome. F-1(d) FIX: this test together with test 5 (N=3 fires floor) proves the
     inclusive boundary — `< 11` means 11 is allowed, 10 and below are rejected. <10ms, no `#[ignore]`.
   - **Absolute path construction (pass-2 I-3 FIX):** `glob::glob()` resolves against PROCESS CWD, NOT
     the repo root. Construct absolute patterns in `validate_globs`:
     `glob(&format!("{}/{}", env!("CARGO_MANIFEST_DIR").replace('\\', "/"), entry))`.
     **F-C1 FIX:** `env!("CARGO_MANIFEST_DIR")` on Windows returns a backslash-separated path
     (e.g. `C:\path\to\project`). `glob` 0.3 treats `\` as an escape metacharacter — all patterns
     would match zero files on Windows, producing a false-RED that blocks the story's own merge on
     `windows-latest`. The `.replace('\\', "/")` call normalizes to forward-slash BEFORE passing to
     `glob`; entries are already forward-slash (`src/foo/bar.rs`), so no double-normalization occurs.
     `CARGO_MANIFEST_DIR` is a compile-time constant set by Cargo to the directory containing
     `Cargo.toml` — the repo root, regardless of where tests are invoked.
   - Add `glob = "0.3"` to `[dev-dependencies]` in `Cargo.toml`. Cargo.lock is updated
     automatically and must be committed (pass-2 I-5 — repo policy: Cargo.lock always committed;
     downstream `--locked` consumers require it. **F-H5 FIX:** this repo's CI does NOT pass
     `--locked`; the rationale is repo policy + downstream consumers, not local CI enforcement).
   - `toml = "1"` is already in `Cargo.toml` main dependencies (not dev-only) — no second entry.
   - **MSRV note (pass-2 I-5):** the test must compile under the project MSRV (Rust 1.85). `glob` 0.3.x
     has a low MSRV; no conflict expected. Verify with `cargo +1.85 test` if uncertain.
   - Test naming follows `test_<verb>_<subject>_<expected_outcome>` convention per
     `docs/specs/test-naming-convention.md`.

4. Modify `.github/workflows/ci.yml`:
   - Update `spec-guard` job `name:` from
     `"Spec Guards (BC counts + no numeric test counts)"` to
     `"Spec Guards (BC counts, numeric-count lint, mutants policy scope)"`.
     **F-H4 FIX — F1 §5 deviation with rationale:** F1 §5 proposed "citation checks, mutants scope"
     but "citation checks" belongs to Story B (Guard 1: BC-citation CI guard, S-BC-CITATION-GUARD),
     which has not shipped yet. Using "citation checks" in Story A's job name prefigures Story B's
     domain and creates ambiguity when Story B ships and updates the same name. Story A's domain is
     specifically "mutants policy scope" (Guard 2 checks mutants policy §Scope citations; Guard 3
     checks examine_globs entries). Story B updates the name when it ships.
   - Add two new steps to the `spec-guard` job at the end of the steps list, after the
     `check-bc-cumulative-counts (DRIFT-002)` step (L-GT-1 FIX — job has 7 steps total
     including harden-runner, checkout, worktree-mount; "four steps" was inaccurate):
     ```yaml
     - name: check-cargo-mutants-policy-citations self-test (Guard 2)
       run: bash scripts/check-cargo-mutants-policy-citations.sh --self-test
     - name: check-cargo-mutants-policy-citations (Guard 2, DEC-150)
       run: bash scripts/check-cargo-mutants-policy-citations.sh
     ```
   - Guard 3 (`tests/mutants_glob_existence.rs`) needs NO ci.yml change — it rides
     the existing `test` job automatically (`cargo test --all-features`).
   - No `ci-gate.needs` change required: `spec-guard` and `test` are already in the gate
     per DEC-096/DEC-097 convention.
   - **Note (pass-3 L-2 / F-H4 FIX, LOW-2 FIX):** Story A sets the name to
     `"Spec Guards (BC counts, numeric-count lint, mutants policy scope)"`. The `numeric-count lint`
     component reflects the still-active `check-bc-no-numeric-test-counts` step already in the job.
     Story B (S-BC-CITATION-GUARD, Guard 1) updates the name further when it ships — it owns the
     "BC citation checks" sub-domain. This is a deliberate deviation from F1 §5 "citation checks,
     mutants scope" wording (see deviation rationale in the name-update bullet above).

5. Modify `docs/specs/cargo-mutants-policy.md`:
   - Add a new `## Guards` section (canonical name; no alternative). **Placement:** insert AFTER
     the `## Spec Anchor` heading and BEFORE the `## Future Path: Job Sharding (Path B)` heading
     (heading names are the stable anchors). MUST NOT be inserted between `## Scope` (line 13) and
     `### Sibling Candidates Considered and Deferred` (line 40) — Guard 2's own extraction logic
     uses the gap between those two headings as its §Scope parser boundary; inserting a new `## `
     heading there would truncate the bulleted list prematurely. Document both guards:
     - Guard 2: `scripts/check-cargo-mutants-policy-citations.sh` — runs in `spec-guard` CI job;
       validates every (file, function) pair in §Scope; exits 1 with offender list on stale citation.
     - Guard 3: `tests/mutants_glob_existence.rs` — runs in `test` CI job; validates every
       `examine_globs` entry resolves to a real file; fails loudly if a refactor orphans a glob.

   **SWEEP-WHOLE-TOUCHED-FILE checklist (pass-2 C-1/pass-3 H-2 FIX — this task is the SINGLE AUTHORITATIVE
   source; Task 2's SWEEP note defers here):**

   Apply the following changes to `§Scope` when modifying this file:

   **create.rs bullet (line 19) — TWO explicit removals required:**
   1. Remove the JSM dispatch fork parenthetical: delete `, JSM dispatch fork to
      \`` handle_jsm_create\`` ` from `handle_create`'s description. The current text is:
      `` `handle_create` (platform-path `issue create` logic, JSM dispatch fork to `handle_jsm_create`) ``
      Simplified to: `` `handle_create` (platform-path `issue create` logic) ``
   2. Remove the relocation-narrative parenthetical entirely: delete `` ; ~10 mutants
      (behavior-dense clusters `handle_edit*` and `handle_jsm_create` relocated by ADR-0012
      Seam A/B — see entries below) ``. After both removals, `handle_create` and `parse_field_kv`
      are the only fn-name tokens extractable from this bullet.

   **issues.rs bullet (lines 27–28) — un-backtick two non-function tokens:**
   1. Change `` `seen_keys` dedup `` → `seen_keys dedup` (plain text; it is a HashSet local variable).
   2. Change `` `has_more` sentinel `` → `has_more sentinel` (plain text; it is a bool struct field).
      After both changes, `search_issues`, `search_issue_keys`, and `list_comments` are the only
      fn-name tokens extractable from this bullet.

   Verify SWEEP completeness by grep: after all changes, running the token-extraction grammar
   against the updated policy doc must produce exactly the (file, fn) pairs in Task 2's table —
   no extra tokens, no missing tokens.

6. Modify `CHANGELOG.md`: Under `## [Unreleased]`, add the entry under the `### Added` sub-header
   (F-H3 FIX — CHANGELOG.md format uses `### Added` / `### Fixed` / `### Changed` / `### Security`
   sub-headers under each `## [version]` section; the entry goes under `### Added`).
   **M-GT-2 FIX — format must match CHANGELOG.md convention (bolded topic prefix):**
   `- **CI: mutants-policy citation guard (Guard 2) + examine_globs existence guard (Guard 3) (DEC-150):** adds \`scripts/check-cargo-mutants-policy-citations.sh\` (validates §Scope function-location bulleted list; CI-MUTANTS-CITE-001; self-test fixtures; SCOPE-EMPTY guard) and \`tests/mutants_glob_existence.rs\` (validates examine_globs entries resolve to real files; coverage floor; MUTANTS-GLOBS-KEY-MISSING guard).`

7. Modify `CLAUDE.md`: Add doc-fallout notes in "AI Agent Notes" section for each guard
   (two bullets, following the `tests/claude_md_citations.rs` bullet as prior art):
   - `scripts/check-cargo-mutants-policy-citations.sh` — runs in spec-guard CI job; validates
     §Scope function-location bulleted list against `src/`; exits 1 with CI-MUTANTS-CITE-001
     offender list if any symbol citation is stale. `--policy-doc` + `--src-root` (self-test only)
     + `--self-test` flags for offline verification. (DEC-150 Guard 2)
   - `tests/mutants_glob_existence.rs` — always-run guard validating every `examine_globs`
     entry in `.cargo/mutants.toml` resolves to ≥1 real file; fails loudly if a refactor
     orphans a glob entry. (DEC-150 Guard 3)

8. Self-verify: read back all modified files. Confirm:
   - `check-cargo-mutants-policy-citations.sh --self-test` exits 0 (preamble checks pass; logic
     correct on all eight fixtures, including Fixture H SCOPE-COVERAGE-FLOOR with CANONICAL_MODE=1). Top-of-file `bash -n "${BASH_SOURCE[0]}"` passes (L-7/L-5 FIX); preamble `grep -Eq '^#.*CI-MUTANTS-CITE-001'` passes (L-4/HIGH-1 FIX).
   - `cargo deny check` passes (verify `glob = 0.3` license is MIT OR Apache-2.0, which is allowed
     per `deny.toml`). (F-L-1)
   - All function names from §Scope bulleted list appear verbatim (as definitions) in their cited source files.
   - Guard 2 prints `Check passed: 11 bullets parsed, 21 (file, fn) pairs validated` when run against develop HEAD post-SWEEP (canonical invocation; `src/types/jira/bulk.rs` contributes 0 to M).
   - `tests/mutants_glob_existence.rs` correctly extracts all 11 current examine_globs entries;
     the coverage-floor assertion passes (FLOOR=11 symbol binding — MED-1-P22 FIX); no MUTANTS-GLOBS-KEY-MISSING panic.
   - `test_detect_missing_examine_globs_key_panics_with_key_missing_message` passes (F-MED-2 FIX:
     MUTANTS-GLOBS-KEY-MISSING guard is RED-provable).
   - ci.yml spec-guard job name updated to `"Spec Guards (BC counts, numeric-count lint, mutants policy scope)"`; two new steps
     present; Guard 3 has NO ci.yml step.
   - CLAUDE.md notes reference correct script names (no invented paths).
   - `Cargo.toml` `[dev-dependencies]` contains `glob = "0.3"` (verify the line is present).
   - `Cargo.lock` is updated and staged in the PR diff (adding a dev-dep modifies Cargo.lock;
     F-H5 FIX: this repo's CI does NOT pass `--locked`; the requirement is repo policy — Cargo.lock
     is always committed alongside Cargo.toml for downstream `--locked` consumers).
   - **F-C1 Windows check:** the glob format string uses `.replace('\\', "/")` on CARGO_MANIFEST_DIR.
     CI validates this on `windows-latest`; local macOS runs will not exercise this branch.
   - **MED-2-P22 FIX:** Fixture F `--self-test` output matches
     `^Check passed: 1 bullets parsed, 7 \(file, fn\) pairs validated$` (M=7; includes
     pub(super) async fn, pub(crate) fn, impl-indented pub async fn; SomeStruct filtered).
   - **MED-1-P22 FIX:** bash Guard 2 uses `local FLOOR=11` in both comparison and message;
     Rust helper uses `const FLOOR: usize = 11` in both comparison and format string.
   - **F-H6:** Run `cargo test --all-features` to confirm the new dev-dep and six test functions
     compile and pass cleanly with no regressions in the existing test suite.
   - `fixtures_run` counter reaches 8 after all fixture assertions; `[ "$fixtures_run" -eq 8 ]`
     passes (F-6 FIX fixture-count integrity pin). Test 5 panic message contains both
     `MUTANTS-GLOBS-COVERAGE-FLOOR` and `got 3` (F-1(c) FIX). Test 6 passes GREEN at N=11 —
     `catch_unwind` result is `Ok(())` (F-1(d) FIX). Fixture E sets `SRC_ROOT="$tmp_E"` (LOW-3-P22 FIX).

---

## Previous Story Intelligence

**S-MUTANTS-EXAMINE-GLOBS-1 (DEC-149, PRs #568+#570 MERGED):**
PR #568 (`docs: fix ADR-0012 Seam A/B relocation citations`) fixed the primary function-location
citations in `docs/specs/cargo-mutants-policy.md` §Scope. PR #570 (`ci(mutants): restore
examine_globs coverage for edit.rs + jsm_create.rs`, commit c4b3aa9) restored the
`.cargo/mutants.toml` scope entries — a separate change.

**H-GT-1 FIX:** PR #568 left the narrative parenthetical on the `create.rs` bullet (backtick-
quoted `handle_jsm_create` in the relocation text) and the backtick-quoted `seen_keys`/`has_more`
on the `issues.rs` bullet intact. Guard 2 therefore reports 4 DEAD extractions on develop HEAD
BEFORE this story's Task 5 SWEEP. The SWEEP is required in this PR; Guard 2 starts GREEN only
AFTER the SWEEP is applied.
Key difference: S-MUTANTS-EXAMINE-GLOBS-1 fixed the primary *existing* drift; this story (a)
adds guards to prevent *future* drift and (b) cleans up the residual narrative-parenthetical
and local-variable-token drift that PR #568 did not address.

**S-MAINT-DEAD-CITATION-CI (2026-06-20, status: draft):**
Direct prior-art story for Guard 3's Rust integration test pattern. That story produced
`tests/claude_md_citations.rs`: `include_str!` + `Path::exists()` for CLAUDE.md citations.
Guard 3 follows the identical approach for `.cargo/mutants.toml::examine_globs`. Key lesson
from DEC-129 (DEAD-CITATION-CI topology): a Rust test running in the `test` job does NOT have
factory-artifacts access — which is exactly why Guard 3 works (`.cargo/mutants.toml` and
`src/` files both live on the develop branch; no cross-branch mount needed).

**S-MUTATION-CI-TIMEOUT-1 (DEC-144, PR #567, 2026-06-28):**
Established the `--timeout 240` absolute ceiling and 5 false-green guards. This story adds
no mutation-gate behavior changes — it only adds guards on the governance documents that
describe the gate. The mutation gate on the fix PR passes via the 0-mutant path
(scripts/tests not in `examine_globs`).

**MUTANTS-FIRST-SCOPED-PR-CALIBRATION watch-item:**
Still PENDING after S-MUTANTS-EXAMINE-GLOBS-1 (the 0-mutant path confirmed again for that PR).
Neither Guard 2 nor Guard 3 are in `examine_globs`. This watch-item remains: first code-change
PR touching `edit.rs` exercises the non-zero-mutant path.

---

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| ci-gate.needs wiring unchanged | DEC-096/DEC-097 | No change to ci-gate composition. Both `spec-guard` and `test` are already in `ci-gate.needs`. New guards ride existing required jobs without branch-protection modifications. |
| Guard 2 in spec-guard job | F1 §3 (CI checkout topology) | `docs/specs/cargo-mutants-policy.md` and `src/` both live on develop. No factory-artifacts mount needed. Spec-guard job correct location for Guard 2. |
| Guard 3 in test job | F1 §3/§4 | `.cargo/mutants.toml` and `src/` both live on develop. Rust integration test rides `test` job — NO ci.yml step needed for Guard 3. Do NOT add a spec-guard step for Guard 3. |
| `--self-test` flag REQUIRED | F1 §7 / MUTANTS-ARBITER-OFFLINE-SELFTEST | Each new bash script MUST include `--self-test` fixture mode to prevent the MUTANTS-ARBITER-OFFLINE-SELFTEST class of gap. The flag seeds a stale fixture and asserts exit 1; run as a separate CI step BEFORE the actual guard check. |
| SWEEP-WHOLE-TOUCHED-FILE-NOT-JUST-TARGET-LINE | DEC-149 (lesson codified) | When modifying `docs/specs/cargo-mutants-policy.md`, scan the entire file for same-class stale references (per S-MUTANTS-EXAMINE-GLOBS-1 AC-002 lesson). |
| Zero `src/` changes | F1 §7 regression baseline | No production Rust source file is modified. Only scripts, one Rust integration test, and documentation files. |
| Mutation gate passes via 0-mutant path | DEC-144 precedent | scripts/tests are not in `examine_globs`. No killable mutants in the fix PR diff. Expected ~32-34s on `--in-diff` run. |
| `toml` crate is already a dependency | Cargo.toml inspection | `toml = "1"` is in main dependencies (not dev-only). Guard 3 test may use it without adding a new dev-dependency. |
| Definition-anchored grep REQUIRED — no plain `grep -q` | pass-1 C-1/pass-2 C-3/pass-2 I-1 adversary findings | Guard 2 MUST use the broadened POSIX-portable regex (v1.3): `grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe\|const\|async\|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${function}([^[:alnum:]_]\|$)"`. Improvements: `const/unsafe/extern "ABI"` qualifiers covered (I-1); `\b` replaced with `([^[:alnum:]_]\|$)` (C-3, portable to BSD grep). Plain `grep -q "$function"` false-greens on `src/cli/issue/create.rs:15` (`use super::jsm_create::{handle_jsm_create};`) — the exact DEC-149 scenario. A PR using plain grep-q MUST NOT merge. |
| §Scope-only parsing; fence-skip defensive | pass-1 C-1/pass-2 I-4 adversary findings | Guard 2 MUST scope parsing to `## Scope` section only (stop before `### Sibling Candidates` subsection at lines 40–49, which lists EXCLUDED files). Fence-skip within §Scope is defensive only — the current §Scope section (lines 16–31) contains no fenced code blocks; §Whitelist-Convention (~lines 359–388) is OUTSIDE §Scope and never reached. |

---

## Library and Framework Requirements

| Tool / Crate | Version | Constraint |
|---|---|---|
| cargo-mutants | @27 (pinned in ci.yml) | No version change. Neither guard affects mutation execution; scope governance only. |
| `toml` crate | 1.x (already in Cargo.toml as main dep) | Used in Guard 3 test to parse `examine_globs` entries from `.cargo/mutants.toml`. Already available; no new entry needed. |
| `glob` crate | 0.3 (add to `[dev-dependencies]`) | Used in Guard 3 test (`glob::glob()`) to expand each examine_globs entry and assert ≥1 match. Handles current exact-path entries correctly. Note (pass-2 I-7): `glob` 0.3 and cargo-mutants' internal glob engine may differ in edge cases for future wildcard patterns — verify against actual cargo-mutants behavior if wildcard examine_globs entries are introduced. Today's entries are all exact paths; no semantic gap exists for them. Add `glob = "0.3"` to `[dev-dependencies]` in `Cargo.toml`. Windows: pass CARGO_MANIFEST_DIR through `.replace('\\', "/")` before formatting glob patterns (F-C1 FIX — glob 0.3 treats `\` as escape metachar). |
| `bash` | /usr/bin/env bash | Guard 2 script uses `set -euo pipefail`. Compatible with ubuntu-latest (GitHub Actions runner). |

One new crate dev-dependency: `glob = "0.3"`. One Cargo.toml change only.

---

## File Structure Requirements

| File | Create / Modify | Description |
|------|-----------------|-------------|
| `scripts/check-cargo-mutants-policy-citations.sh` | CREATE | Guard 2: parse §Scope bulleted list; verify each (file, function) pair via definition-anchored grep; collect ALL offenders (CI-MUTANTS-CITE-001 format); `--policy-doc` + `--src-root` (self-test only) + `--self-test` flags; SCOPE-EMPTY guard; SCOPE-COVERAGE-FLOOR (CANONICAL_MODE=1 only); coverage summary; eight fixtures (dead-symbol + import-only + empty-src-root + scope-empty + malformed-bullets + success-path + file-existence-only + SCOPE-COVERAGE-FLOOR). |
| `tests/mutants_glob_existence.rs` | CREATE | Guard 3: parse `examine_globs` from `.cargo/mutants.toml`; use `glob::glob()` to assert each pattern expands to ≥1 file; inline seeded-failure test proves guard logic. Test names follow `test_<verb>_<subject>_<expected_outcome>`. |
| `.github/workflows/ci.yml` | MODIFY | spec-guard job: update `name:` field; add `--self-test` step; add main guard step for Guard 2. Guard 3 needs NO ci.yml step. No job/matrix/timeout/logic changes beyond these two additions + name update. |
| `docs/specs/cargo-mutants-policy.md` | MODIFY | Add `## Guards` section documenting both guards. SWEEP-WHOLE-TOUCHED-FILE for same-class stale references. |
| `CHANGELOG.md` | MODIFY | Add `[Unreleased]` entry per CHANGELOG-per-PR hygiene. |
| `CLAUDE.md` | MODIFY | Add two doc-fallout bullets in "AI Agent Notes" for Guards 2+3 (following `tests/claude_md_citations.rs` precedent line). |
| `Cargo.toml` | MODIFY | Add `glob = "0.3"` to `[dev-dependencies]`. No other Cargo.toml changes. |
| `Cargo.lock` | MODIFY | Updated automatically by Cargo when glob dev-dep is added. Must be committed as repo policy; downstream `--locked` consumers require it. F-H5 FIX: this repo's CI does NOT pass `--locked`; the rationale is repo policy, not local CI enforcement. (pass-2 I-5) |

---

## Acceptance Criteria

All ACs trace to `docs/specs/cargo-mutants-policy.md` sections (no BC-S.SS.NNN exists for this story).

---

### AC-001 — Guard 2 script passes GREEN on develop HEAD AFTER Task 5 SWEEP is applied
(traces to `docs/specs/cargo-mutants-policy.md §Scope` — function-location bulleted list is the source of truth)

**H-GT-1 FIX — sequencing matters:** `scripts/check-cargo-mutants-policy-citations.sh`
exits 0 ONLY after the Task 5 SWEEP is applied in this PR. BEFORE the SWEEP, the guard
demonstrably reports 4 known dead extractions from the current §Scope on develop HEAD:
- 2× `handle_jsm_create` on the `create.rs` bullet (line 19): the backtick-quoted token
  appears twice in the JSM dispatch fork parenthetical and the relocation-narrative
  parenthetical; `handle_jsm_create` is no longer defined in `create.rs` (moved to
  `jsm_create.rs` by ADR-0012 Seam A) — definition-anchored grep returns DEAD.
- `seen_keys` and `has_more` on the `issues.rs` bullet (lines 27–28): these are backtick-
  quoted local variable / struct field names, not function definitions; definition-anchored
  grep returns DEAD for both.

These 4 pre-SWEEP RED outputs ARE the AC-001 RED-gate evidence under `tdd_mode: strict`.
Task 5 SWEEP MUST be applied before the AC-001 GREEN validation run.

**PR attribution (H-GT-1 FIX):** PR #568 (`docs: fix ADR-0012 Seam A/B relocation citations`)
fixed the primary function-location citations. PR #570 (`ci(mutants): restore examine_globs
coverage`, commit c4b3aa9) restored the `.cargo/mutants.toml` scope entries (edit.rs +
jsm_create.rs). PR #568 left the narrative parenthetical on create.rs:19 and the backtick-quoted
`seen_keys`/`has_more` on issues.rs:27-28 intact — this PR's Task 5 SWEEP removes them.

**Format note (pass-2 C-2 FIX; F-H-1 FIX):** `docs/specs/cargo-mutants-policy.md §Scope` is a BULLETED LIST
(lines 16–31), NOT a markdown table. The script MUST parse ALL `^- ` dash-bullet lines in the
§Scope range (F-H-1 grammar: any dash bullet enters the loop; file = first backticked token
starting with `src/` in the assembled group; a bullet with no valid token → `DEAD: malformed
bullet skipped: <line>` offender). Real §Scope bullets all happen to carry a `src/`-path token;
the grammar change only affects handling of malformed bullets.
The `### Sibling Candidates Considered and Deferred` subsection (lines 40–49) is a table of
EXCLUDED files and MUST NOT be parsed as §Scope entries.

Expected: after the Task 5 SWEEP, every (file, function) pair from the Task 2 table resolves
via definition-anchored grep. `src/types/jira/bulk.rs` is file-existence-only (no function names
cited). If Guard 2 surfaces any additional stale citation after the SWEEP, fix it in this PR.

---

### AC-002 — Guard 2 fails loud on seeded stale citations via `--self-test` (RED-provable, eight fixtures)
(traces to `docs/specs/cargo-mutants-policy.md §Scope` + F1 §7 self-test mandate)

`scripts/check-cargo-mutants-policy-citations.sh --self-test` runs EIGHT fixtures (F-3 FIX/F-MED-2 FIX/LOW-1 FIX/F-M-5 FIX/MED-1 FIX:
complete fixture specifications are in Task 2 — single source of truth). Summary assertions:

| Fixture | Exit | Required output substrings | Summary-line regex |
|---------|------|---------------------------|-------------------|
| A — dead-symbol | 1 | `DEAD: `, ` not found in `, `handle_nonexistent_fn_selftest` AND `another_missing_fn_selftest` (L-5 FIX: both fn names must appear) | `^[0-9]+ stale citation\(s\) found in .+ §Scope$` |
| B — import-only false-green | 1 | `DEAD: `, ` not found in `, `handle_jsm_create` | `^[0-9]+ stale citation\(s\) found in .+ §Scope$` |
| C — empty src-root | 1 | `DEAD: src/foo.rs not found` and `DEAD: src/bar.rs not found` (F-4 missing-file format; fn names do NOT appear) | `^[0-9]+ stale citation\(s\) found in .+ §Scope$` |
| D — scope-empty | 1 | `SCOPE-EMPTY:` | n/a (exits before summary line) |
| E — malformed bullets | 1 | `DEAD: malformed bullet skipped:` appears THREE TIMES (one per malformed bullet; third bullet triggers traversal guard as SOLE defense) | `^[0-9]+ stale citation\(s\) found in .+ §Scope$` |
| F — success path (F-3/F-5/MED-2-P22 FIX) | 0 | output matches `^Check passed: 1 bullets parsed, 7 \(file, fn\) pairs validated$` (`SomeStruct` filtered — M=7 not M=8; includes pub(super)/pub(crate)/async/impl-indented forms) | n/a (exit 0; no stale-citation summary) |
| G — file-existence-only | 0 | output matches `^Check passed: 1 bullets parsed, 0 \(file, fn\) pairs validated$` | n/a (exit 0; no stale-citation summary) |
| H — SCOPE-COVERAGE-FLOOR RED (N=2) | 1 | `SCOPE-COVERAGE-FLOOR:` AND `expected >= 11` (pins threshold) AND `got 2` (pins count format) | n/a (exits before summary line) |
| H — SCOPE-COVERAGE-FLOOR GREEN companion (N=11) | 0 | output does NOT contain `SCOPE-COVERAGE-FLOOR:` (floor must not fire at exact threshold) | n/a (exit 0) |

F-1 FIX note: summary-line regex uses `.+` (not a hard-coded canonical path) because all
fixtures use `POLICY_DOC=<tmp>` (IN-PROCESS; no subprocess) — the temp path is printed, not
the canonical path. CI's real guard (no `--policy-doc`) naturally prints the canonical path.

All fixtures use `set +e; output=$(run_check 2>&1); rc=$?; set -e` (MED-1 FIX) and clean up via the shared
`trap 'rm -rf "${tmp_A:-}" "${tmp_B:-}" "${tmp_C:-}" "${tmp_D:-}" "${tmp_E:-}" "${tmp_F:-}" "${tmp_G:-}" "${tmp_H:-}"' EXIT` (MED-2 FIX/F-M-5 FIX/MED-1 FIX).
**F-6 FIX — fixture-count integrity pin:** `fixtures_run` counter initialized to 0 before Fixture A,
incremented by 1 after each fixture's assertions. After all 8 fixtures: `[ "$fixtures_run" -eq 8 ] || exit 1`
with message `SELF-TEST-FIXTURE-COUNT: expected 8 fixtures, got N`. Catches the drop-a-fixture
refactor vector (silently removing a fixture while keeping all remaining assertions passing).
`--self-test` exits 0 when ALL eight fixtures behave as expected AND the count integrity pin passes. CI `--self-test` step MUST
precede the actual guard step.

---

### AC-003 — Guard 2 error messages follow CI-MUTANTS-CITE-001 format and list ALL offenders
(traces to `docs/specs/cargo-mutants-policy.md §Scope` — CI-MUTANTS-CITE-001 error format)

When Guard 2 finds stale citations or malformed bullets, it:
- Does NOT abort on the first failure; collects ALL offenders first.
- Prints each offender as one of three forms (CI-MUTANTS-CITE-001, MED-5 FIX):
  - `DEAD: <function> not found in <file>` — file exists, function definition absent
  - `DEAD: <file> not found` — cited source file does not exist (F-4)
  - `DEAD: malformed bullet skipped: <line text>` — §Scope bullet fails shape-guard (MED-5)
- Prints a summary line: `K stale citation(s) found in <policy-doc-path> §Scope`
  (where K ≥ 1; K = offender count, distinct from N = bullet count used by
  SCOPE-EMPTY/SCOPE-COVERAGE-FLOOR; `<policy-doc-path>` is the actual path used —
  `--policy-doc` argument or the default canonical path
  `docs/specs/cargo-mutants-policy.md` for CI invocations).
- Exits with code 1.

This format is **CI-MUTANTS-CITE-001** — analogous to CI-CITE-001 from
`tests/claude_md_citations.rs` (list ALL dead paths, then summary). The literal string
`"CI-MUTANTS-CITE-001"` MUST appear in the script's header comment.

**The format is pinned by `--self-test` output assertions, NOT by an inline comment (pass-3 H-1 FIX).**
The inline-comment escape hatch is removed: a comment is always present and never fails — it
cannot detect format drift. Instead, Fixture A (AC-002) MUST capture the script output and assert
the exact substrings `DEAD: ` + ` not found in ` and the summary-line grammar
`^[0-9]+ stale citation\(s\) found in .+ §Scope$` (F-1 FIX: `.+` matches the actual path
printed, which is a temp path when `--policy-doc <tmp>` is used by self-test fixtures).
This follows `tests/claude_md_citations.rs::test_render_dead_citation_message_matches_ci_cite_001`
prior art (byte-for-byte format assertion). A contributor fixing stale citations sees the complete
picture in one CI run, not one-at-a-time.

**Positive coverage summary required (F-C3/Obs-a FIX):** When Guard 2 succeeds (zero offenders, exit 0),
it MUST also print: `Check passed: N bullets parsed, M (file, fn) pairs validated`. On develop HEAD
post-SWEEP (canonical invocation, no `--policy-doc`), the expected byte-pinnable output is:
`Check passed: 11 bullets parsed, 21 (file, fn) pairs validated`
(`src/types/jira/bulk.rs` is file-existence-only — contributes 1 to N and 0 to M; N=11 bullets
total; M=21 pairs from the expected-pairs table in Task 2: 3+2+3+1+1+0+1+2+3+3+2=21). Fixture D
(Task 2) checks that an empty §Scope produces SCOPE-EMPTY exit 1, not a vacuous exit 0 with "0 pairs validated".

**SCOPE-COVERAGE-FLOOR required (MED-2 FIX, F-MED-1 FIX):** When `CANONICAL_MODE=1` (set by the
arg parser only when neither `--self-test` nor `--policy-doc` was supplied), if 1 ≤ N < FLOOR
(where `local FLOOR=11` — see Task 2 single-source binding, MED-1-P22 FIX),
Guard 2 MUST exit 1 with:
`SCOPE-COVERAGE-FLOOR: expected >= ${FLOOR} §Scope bullets, got N. Update this PIN when bullets are intentionally removed (the floor is a lower bound; additions never fire it).`
(When FLOOR=11 this emits `expected >= 11 §Scope bullets, got N` — the literal `11` in the Fixture H
assertion pins the currently expected expansion; the FLOOR variable ensures comparison and message
cannot diverge under a mutation.)
This floor applies only when `CANONICAL_MODE=1` — fixtures never set this variable and are
therefore always exempt. SCOPE-EMPTY (N=0, unconditional) fires before the floor check and is a
separate guard; neither overrides the other.

---

### AC-004 — Guard 3 Rust test passes GREEN on current develop HEAD (all 11 globs resolve)
(traces to `docs/specs/cargo-mutants-policy.md §Scope` — examine_globs list is the source of truth)

`tests::mutants_glob_existence::test_resolve_all_examine_globs_entries_to_real_files` passes
when run with `cargo test --all-features` on develop HEAD. Uses `glob::glob()` to expand each
entry. All 11 current `examine_globs` entries in `.cargo/mutants.toml` (as of 2026-07-02
snapshot; the test enumerates dynamically from the file) resolve to ≥1 real file:
```
src/adf.rs
src/api/jira/bulk.rs
src/types/jira/bulk.rs
src/cli/issue/create.rs
src/cli/issue/edit.rs
src/cli/issue/jsm_create.rs
src/api/jsm/requests.rs
src/api/jsm/request_types.rs
src/cli/requesttype.rs
src/api/jira/issues.rs
src/cache.rs
```
If any pattern resolves to 0 matches, the test fails listing ALL dead patterns. Exact paths
behave identically to `Path::exists()` via `glob::glob()` but are forward-compatible with
future wildcard entries (adversary pass 1 I-6; pass-3 L-3 provenance fix).

**F-C2 FIX — two mandatory pre-flight assertions via shared helpers:**
1. **MUTANTS-GLOBS-KEY-MISSING guard (L-2 FIX):** Test 1 MUST call
   `extract_examine_globs_or_panic(&value)` (the shared helper — Task 3). That helper panics
   with `MUTANTS-GLOBS-KEY-MISSING: examine_globs key not found in .cargo/mutants.toml — key
   renamed, section restructured, or examine_globs is present but empty` when the extracted Vec
   is empty. A missing key must never produce a vacuous test pass (empty Vec →
   validate_globs([]) → empty dead list → test passes despite ZERO coverage).
2. **Coverage floor (MED-2 FIX; MED-1-P22 FIX: FLOOR symbol):** Test 1 MUST call
   `assert_examine_globs_coverage_floor(&entries)` (the shared helper — Task 3). That helper
   declares `const FLOOR: usize = 11;` and panics with
   `"MUTANTS-GLOBS-COVERAGE-FLOOR: expected >= {FLOOR} examine_globs entries, got {}. Update this
   PIN when entries are intentionally removed (the floor is a lower bound; additions never fire it)."`
   if `entries.len() < FLOOR`. Do NOT inline `assert!(entries.len() >= 11, ...)` here;
   the shared helper is required so test 5's `catch_unwind` can prove the floor is RED-provable.
   Current FLOOR value is 11. Fail loud if the count drops below this floor unexpectedly.

**F-MED-2 FIX — MUTANTS-GLOBS-KEY-MISSING guard is RED-provable via a dedicated fourth test:**
`test_detect_missing_examine_globs_key_panics_with_key_missing_message` (Task 3) exercises this
guard in isolation using `std::panic::catch_unwind`. See AC-005 / Task 3 for the full spec.
The MUTANTS-GLOBS-KEY-MISSING panic lives in the shared `extract_examine_globs_or_panic` helper
called by BOTH test 1 AND test 4 (L-2 FIX) — dropping or weakening the empty-Vec panic in that
helper would be caught by test 4's `catch_unwind` (the guard is not just a comment in test 1).

**MED-2 FIX — MUTANTS-GLOBS-COVERAGE-FLOOR is RED-provable via a dedicated fifth test:**
`test_coverage_floor_panics_when_entries_below_threshold` (Task 3) exercises the coverage floor
in isolation using `std::panic::catch_unwind` with <11 inline entries. The floor assertion lives
in the shared `assert_examine_globs_coverage_floor` helper — dropping or weakening it would be
caught by test 5's `catch_unwind`. See AC-005 / Task 3 for the full spec.

**F-1(d) FIX — boundary GREEN proof via a dedicated sixth test:**
`test_coverage_floor_does_not_panic_at_exact_threshold` (Task 3) proves the floor does NOT fire
at exactly N=11 using `std::panic::catch_unwind` with an 11-entry inline mock. Together with test 5
(N=3, floor fires), this pins the inclusive `< 11` boundary — mutations weakening `< 11` to `<= 11`
are caught by the GREEN assertion in test 6. See AC-006 / Task 3 for the full spec.

---

### AC-005 — Guard 3 Rust test fails deterministically on a seeded dead glob (RED-provable)
(traces to `docs/specs/cargo-mutants-policy.md §Scope` — inline self-proof of guard logic)

`tests::mutants_glob_existence::test_reject_nonexistent_examine_globs_entry_returns_dead_list`
(F-11 renamed from `test_examine_globs_validator_rejects_nonexistent_path`):
- Calls the `validate_globs` helper (required by Task 3 / I-8) with a one-element slice
  containing only `"src/nonexistent_dummy_for_selftest.rs"` (NOT read from `.cargo/mutants.toml`).
- Asserts the returned `Vec<String>` is non-empty — containing the dead pattern.
- The test PASSES when the Vec is non-empty — proving the `validate_globs` helper correctly
  identifies non-matching patterns. Tests guard LOGIC, not just the `glob` crate API.

**M-1 FIX — TOML-parse path via a separate mandatory test (kills polarity mutant):**
`test_reject_nonexistent_examine_globs_entry_returns_dead_list` exercises the slice path only.
The TOML parse path MUST be a separate standalone test `test_validate_globs_via_toml_parse_returns_dead_entry`
(L-2 FIX: the "or a new test" parenthetical choice is foreclosed by Task 3 / AC-006 — the separate
test is mandatory). That test:
- Inlines a mock TOML string: `examine_globs = ["src/nonexistent_dummy_for_selftest.rs"]`
- Parses via `toml::from_str::<toml::Value>` + extracts `examine_globs` (same code as AC-004 uses).
- Calls `validate_globs` with the extracted entries.
- Asserts the returned Vec is non-empty.
This exercises the SAME parse→validate_globs→dead-list code path as the real guard, ensuring a
`is_empty()` vs `!is_empty()` polarity mutant in `validate_globs` is killed by this test.

All five (slice variant, TOML-parse variant, MUTANTS-GLOBS-KEY-MISSING panic variant,
MUTANTS-GLOBS-COVERAGE-FLOOR panic variant, and coverage-floor-boundary GREEN variant) are
always-run (no `#[ignore]`), require no network access, and complete in <10ms.

---

### AC-006 — Test naming, CI wiring, and conventional-commit type
(traces to `docs/specs/test-naming-convention.md` + CHANGELOG-per-PR hygiene)

**Rust test naming:** All test functions in `tests/mutants_glob_existence.rs` follow the
`test_<verb>_<subject>_<expected_outcome>` convention (L-1 fix — verb-first form):
- `test_resolve_all_examine_globs_entries_to_real_files` (renamed from `test_all_examine_globs_resolve_to_real_files`)
- `test_reject_nonexistent_examine_globs_entry_returns_dead_list` (F-11 renamed; verb-first: `reject` is the verb)
- `test_validate_globs_via_toml_parse_returns_dead_entry` (verb: `validate_globs`, outcome: `returns_dead_entry`)
- `test_detect_missing_examine_globs_key_panics_with_key_missing_message` (F-MED-2 FIX; verb: `detect`, subject: `missing_examine_globs_key`, outcome: `panics_with_key_missing_message`)
- `test_coverage_floor_panics_when_entries_below_threshold` (MED-2 FIX; verb: `coverage_floor`, outcome: `panics_when_entries_below_threshold`)
- `test_coverage_floor_does_not_panic_at_exact_threshold` (F-1(d) FIX; verb: `coverage_floor`, subject: implied, outcome: `does_not_panic_at_exact_threshold` — boundary GREEN proof at N=11)

**CI wiring:**
- Guard 2: two new steps added to `spec-guard` job (self-test step first, main guard step second).
  spec-guard job `name:` updated to `"Spec Guards (BC counts, numeric-count lint, mutants policy scope)"` (F-H4 FIX).
- Guard 3: NO new ci.yml step (rides `test` job automatically). If a spec-guard step for Guard 3
  is found in the PR, it is a bug — remove it.

**Conventional-commit type:** PR title uses `ci:` prefix (CI infrastructure change).
The commit adding `tests/mutants_glob_existence.rs` uses `test:` prefix.

---

### AC-007 — Doc fallout: policy doc, CLAUDE.md, CHANGELOG.md all updated; no src/ change
(traces to `docs/specs/cargo-mutants-policy.md` — documentation consistency)

**`docs/specs/cargo-mutants-policy.md`:** A `## Guards` section is added (canonical name; M-3 fix)
documenting Guard 2 (`scripts/check-cargo-mutants-policy-citations.sh`) and Guard 3
(`tests/mutants_glob_existence.rs`): what each guard checks, which CI job runs it, how to
reproduce locally, and what action to take on failure.

**`CLAUDE.md`:** Two new bullets added to the "AI Agent Notes" section:
- One for Guard 2: script name, CI job (`spec-guard`), trigger condition, `--self-test` flag.
- One for Guard 3: test file name, CI job (`test`), trigger condition.

**`CHANGELOG.md`:** One `[Unreleased]` entry added under `### Added`; the entry content is equivalent to the canonical string specified in Task 6 (L-5 FIX: exact line-wrapping may differ to fit the repo's CHANGELOG column width — the topic prefix `**CI: mutants-policy citation guard (Guard 2) + examine_globs existence guard (Guard 3) (DEC-150):**`, the file paths `scripts/check-cargo-mutants-policy-citations.sh` and `tests/mutants_glob_existence.rs`, and the capability descriptions `CI-MUTANTS-CITE-001`, `SCOPE-EMPTY guard`, `coverage floor`, `MUTANTS-GLOBS-KEY-MISSING guard` must all be present).

**No `src/` Rust source file is modified.** `Cargo.toml` IS modified: `glob = "0.3"` is added to
`[dev-dependencies]` for Guard 3 glob expansion (adversary pass-1 I-6 fix). No `tests/` file other than
`tests/mutants_glob_existence.rs` is modified.

---

## Regression Risk

| Area | Risk | Rationale |
|------|------|-----------|
| PRs not touching §Scope bulleted list or examine_globs | NONE | Neither guard fires on unrelated changes; both are isolated to their respective config files |
| Guard 2 false-positive on Guard 2's own delivery PR | LOW | The delivery PR changes `scripts/` and `docs/`; no `src/` symbols are introduced. Guard 2 passes via the 0-offenders path. |
| Guard 3 false-positive | NONE | All 11 current `examine_globs` entries resolve. If S-MUTANTS-EXAMINE-GLOBS-1 has NOT merged yet, Guard 3 still passes (it validates file existence, not function location). |
| ci-gate false-block | NONE | No changes to ci-gate logic, timeout, or false-green guards. Guard 2 rides `spec-guard` (already in ci-gate.needs); Guard 3 rides `test` (already in ci-gate.needs). |
| Script `set -euo pipefail` behavior | LOW | Any unhandled error in Guard 2 will exit non-zero, surfacing failures rather than hiding them. |

---

## Out of Scope (explicit)

**Guard 1 (BC-CITATION-CI-GUARD).** The `scripts/check-bc-citation-symbols.sh` guard that validates
BC body Trace:/Source: citations against develop's `src/` tree is Story B (S-BC-CITATION-GUARD),
not this story. It requires full F2-F7 (new BCs in cross-cutting.md, parser grammar for citation
forms). Do not add it here.

**No `tests/` symbol-existence guard (Guard 3 v2).** Guard 3 checks file existence only — NOT
whether the cited function names in the examines-globs comment annotations are correct. The function
comments in `.cargo/mutants.toml` (e.g., `# HIGH-value: handle_edit, ...`) are documentation, not
machine-read. They are validated separately by Guard 2 (policy doc §Scope) and by human review.

**No `src/` code changes.** This story is governance infrastructure only.

**`MUTANTS-ARBITER-OFFLINE-SELFTEST` drift item.** This story adds `--self-test` to Guard 2 and
inline failure tests to Guard 3, establishing the correct pattern. The kill-rate arbiter bash itself
(the existing mutation gate) is NOT modified — closing that item is a separate story if ever
prioritized.

**Policy-doc function citations OUTSIDE §Scope (F-H1 FIX — POLICY-DOC-NON-SCOPE-CITATIONS).**
Guard 2 deliberately parses §Scope ONLY (lines 16–31). The policy doc also contains function names
in other sections that Guard 2 will NOT catch:
- `## Changelog` table (line ~658+): function names in the "Change" column (actual header: `| Date | Cycle | Change |`) (e.g. `handle_edit`,
  `handle_jsm_create`, `parse_field_kv` in the DEC-149 row at line ~662).
- `### Root Cause: Real Wall-Clock Sleeps in \`bulk.rs\` Scope` (line ~104): `bulk.rs` and function
  names cited in the root-cause narrative.
These citations are outside §Scope by design. Extending Guard 2 to parse the full file was rejected
(adversary pass 4 F-H1): whole-file parsing carries false-red risk from changelog prose that happens
to contain function-name strings in non-citation contexts. The follow-up candidate to address these
non-§Scope citations is **POLICY-DOC-NON-SCOPE-CITATIONS** (registered by coordinator at cycle close
per F-H1 disposition). No action required in this story.

**Process gap note — FIXTURE-SHAPE-CHANGE-COVERAGE (LOW-3 FIX; L-1 FIX; F-6 FIX):** Any fixture-invocation-shape
refactor must enumerate what coverage was lost. The v1.8 LOW-1 IN-PROCESS refactor (converting
Fixture A from CLI-arg invocation to in-process semantics) silently moved the CLI arg-parser path
out of test coverage — a `--policy-doc` CLI arg was no longer tested by any fixture. The
`--src-root`-without-`--self-test` exit-64 fence (F-H2) remains unfixtured and accepted (testing
it would require a subprocess invocation). When refactoring fixture invocation shape in future,
document the coverage delta explicitly in the changelog entry and Gap Register.
The **drop-a-fixture vector** (silently removing one fixture while keeping all remaining assertions passing)
is now machine-pinned by the `fixtures_run` counter (F-6 FIX): any refactor that removes a fixture
without decrementing the counter will cause the integrity pin to fail with
`SELF-TEST-FIXTURE-COUNT: expected 8 fixtures, got N`. If a fixture is intentionally removed, update
both the counter check and the header count (`EIGHT fixtures required`) in the same commit.

Additional residual — **preamble-grep loosening (L-1 FIX):** the in-process test model cannot kill
pattern-weakening mutations in the preamble `grep -Eq '^#.*CI-MUTANTS-CITE-001'` check. Because
all fixtures run in-process (no subprocess re-invocation), a mutation that broadens the regex
(e.g., `'^.*CI-MUTANTS-CITE-001'` removing the `^#` anchor) still passes all fixtures — the
pattern still matches the comment line. This is an accepted coverage gap: the `^#` anchor's value
is preventing a RUNTIME false-green when the literal appears in non-comment lines (the pattern-
argument line itself), which is a static property that only matters in a live invocation, not in
the in-process test model. Mutation testing of bash scripts is not in scope for this project.

**Process gap note — INTERNAL-PR-CITATION-RIGOR:** Internal PR-number attributions (PR #NNN
references within the factory) deserve the same verify-before-cite discipline applied to
JRACLOUD-*/GitHub issue IDs. H-GT-1 found that PR #570 was misattributed as the citation-fix PR
(it was the mutants.toml change); PR #568 was the actual citation fix. Disposition at cycle close.

**Process gap note — POLICY-DOC-ZERO-PAIR-OPT-OUT (MED-5):** A §Scope bullet whose file exists
but whose backtick-quoted tokens contain zero snake_case fn-name candidates passes Guard 2 with
0 (file, fn) pairs validated for that bullet. This is the legitimate case for serde-struct-only
files like `src/types/jira/bulk.rs` (Fixture G covers this path). However, it is also gameable:
omitting backtick quotes around function names in a bullet makes them invisible to the token
extractor, allowing stale citations to pass silently. Acknowledged Guard-2 gaming vector.
Follow-up candidate: `POLICY-DOC-ZERO-PAIR-OPT-OUT` — add an opt-out annotation syntax (e.g.,
`# serde-structs-only`) required for zero-pair bullets, so that zero-pair bullets without the
annotation are flagged as suspicious. Not in scope for this story.

**Process gap note — EXTRACTION-SET-PIN (MED-6):** Guard 2 validates the COUNT of extracted
(file, fn) pairs (via SCOPE-COVERAGE-FLOOR and the positive-coverage summary) but does not
machine-pin the extracted SET. A count-preserving swap — replacing one valid (file, fn) pair
with a different valid pair — passes Guard 2. The follow-up mechanism: `--dump-extracted-pairs`
flag that serializes the extracted set to a golden-file snapshot, enabling set-level regression
detection on PR diff. Not in scope for this story.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| Guard 2 script | `scripts/check-cargo-mutants-policy-citations.sh` | N/A (bash script) | Reads policy doc + `src/` files; no state mutation; exits with structured error messages |
| Guard 3 test | `tests/mutants_glob_existence.rs` | N/A (test) | Reads `.cargo/mutants.toml` + asserts path existence; no network, no state mutation |
| CI job update | `.github/workflows/ci.yml` (spec-guard job) | N/A (CI config) | Additive steps only; guard 3 rides test job with no ci.yml change |
| Policy doc | `docs/specs/cargo-mutants-policy.md` | N/A (documentation) | New §Guards section; SWEEP-WHOLE-TOUCHED-FILE pass |
| Release log | `CHANGELOG.md` | N/A (documentation) | [Unreleased] entry |
| Agent notes | `CLAUDE.md` | N/A (documentation) | Two doc-fallout bullets in AI Agent Notes |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — all modified files are
CI infrastructure, documentation, or test files. No cross-subsystem interaction.

**Dependency anchor justification:** `depends_on: []` — all prerequisite mutation gate
infrastructure is already merged (PRs #568+#570 are the most recent; #570 @ c4b3aa9). `blocks:` is commented
out — Story B (Guard 1, S-BC-CITATION-GUARD) is planned-not-yet-authored; no story file exists yet.
Story A (Guards 2+3) should deliver first as a stable reference before Story B is dispatched
(wave ordering per F1 §7), but that ordering is documented in the comment, not enforced via a
`blocks:` entry until Story B exists.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | F1 §6 / pass-1 C-1 adversary finding | A function name appears in an import (`use`) or call site in the cited file but NOT as a definition | Guard 2 MUST use definition-anchored grep — this EC is an ACTIVE RISK, not a conservative choice. `src/cli/issue/create.rs:15` has `use super::jsm_create::{handle_jsm_create};` — a plain `grep -q handle_jsm_create create.rs` returns true (false-green). The definition-anchored regex rejects import/call lines. See Architecture Compliance Rules. | AC-001, AC-002 Fixture B |
| EC-002 | F1 §6 | A function is renamed (not moved) after §Scope was last updated | Guard 2 flags it as a stale citation (correct — citation IS stale; fix the policy doc) | AC-002 |
| EC-003 | F1 §4 | Guard 2 delivery PR itself modifies `docs/specs/cargo-mutants-policy.md` | Guard 2 must pass on the updated policy doc, not the pre-change version; AC-001 requires GREEN after fix | AC-001 |
| EC-004 | Guard 3 | A future `examine_globs` expansion adds a file that does not yet exist in the working tree | Guard 3 test fails immediately; the expansion PR must ensure the file exists at merge time | AC-004 |
| EC-005 | Guard 3 / adversary pass 1 I-6 (L-3 fix) | `examine_globs` contains a wildcard pattern (e.g., `src/cli/issue/*.rs`) instead of an exact path | Guard 3 uses `glob::glob()` semantics; wildcard entries are handled correctly without code changes. Current config uses exact paths only (all 11 entries exact); `glob::glob()` handles these identically to `Path::exists()`. Forward-compatible: if wildcards are introduced, no test update required. | AC-004 |
| ~~EC-006~~ | Removed (L-6) | ~~S-MUTANTS-EXAMINE-GLOBS-1 has NOT merged~~ | Vacuous — PRs #568+#570 both merged before this story was written; the scenario can never occur. H-GT-1 FIX: Guard 2 passes GREEN only AFTER this PR's Task 5 SWEEP — not unconditionally on develop HEAD. The original EC-006 removal rationale (PR #570 pre-fixed all stale citations) was inaccurate; see AC-001 for corrected sequencing. | N/A |

---

## Maintenance Touchpoints

*(F-O4 FIX)* Known future triggers that require updating this story's artifacts:

- **§Scope bullet added to `docs/specs/cargo-mutants-policy.md`:** Guard 2's SWEEP grammar picks
  up the new bullet automatically — no code change required. The expected (file, fn) pairs table
  in Task 2 should be updated in the same PR to document the new entry.

- **`examine_globs` wildcard introduced (e.g. `src/cli/issue/*.rs`):** Guard 3 uses `glob::glob()`
  semantics and handles wildcards without code changes (pass-1 I-6, EC-005). Re-verify behavior
  against actual cargo-mutants glob engine on that PR; semantics may diverge for complex patterns
  (pass-2 I-7 softened claim). Windows separator normalization (F-C1) applies to wildcard patterns
  as well.

- **`.cargo/mutants.toml` schema bump (e.g. `examine_globs` renamed):** Guard 3's
  MUTANTS-GLOBS-KEY-MISSING panic fires immediately. The coverage-floor assertion also fires.
  Investigate the schema change, update the key name in `validate_globs`, and adjust the PIN
  comment to match the new entry count.

- **Story B (S-BC-CITATION-GUARD, Guard 1) ships:** Story B updates the `spec-guard` job
  `name:` field (currently `"Spec Guards (BC counts, numeric-count lint, mutants policy scope)"`) to include its
  BC-citation domain. Story B owns that name-update.

- **`glob` dev-dep compile latency (F-M-2):** Story A's `glob = "0.3"` dev-dep adds a small
  incremental compile step to the `cargo-mutants` baseline. The MUTANTS-FIRST-SCOPED-PR-CALIBRATION
  watch item (see Previous Story Intelligence) fires on the next code-change PR that touches
  `edit.rs` — that PR should confirm `--timeout 240` headroom still holds after the glob crate
  is included in the dev build graph.

---

## Story Points and Effort

**3 story points** (two new files + three documentation/CI modifications; no Rust production code).

Breakdown:
- `scripts/check-cargo-mutants-policy-citations.sh` (bash guard + `--self-test` fixture): 1.0 SP
- `tests/mutants_glob_existence.rs` (Rust test + seeded-failure sub-test): 0.75 SP
- `.github/workflows/ci.yml` (name update + 2 steps for Guard 2): 0.25 SP
- `docs/specs/cargo-mutants-policy.md` (§Guards section + SWEEP): 0.5 SP
- `CHANGELOG.md` + `CLAUDE.md` (documentation): 0.5 SP

Comparable stories: S-MAINT-DEAD-CITATION-CI (3 SP, CI guard + test file + doc-fallout),
S-FORK-OPS-SIGN-1 (5 SP, bash guard + CI wiring). Estimate 3 SP — two small files and
targeted documentation updates with no Rust production code.
