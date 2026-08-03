# S-626-1 Demo Evidence

Story: Fix rust-toolchain SHA pins + MSRV false-green + comfy-table pin + CLAUDE.md gotcha (closes #626)
Branch: `ci/fix-toolchain-sha-msrv`
Head: `64e2a4bc`
Last full regeneration: 2026-08-03

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test` (aggregate) | 2343 passed / 0 failed / 100 ignored |
| `full-suite.txt` | `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features --locked` | Compiling jr → Finished, exit 0 |
| `full-suite.txt` | `cargo clippy --all-targets -- -D warnings` | clean (exit 0) |
| `full-suite.txt` | `cargo fmt --all -- --check` | clean (exit 0) |

Baseline per story v1.3 scope note was 2341 passed / 100 ignored. This run shows 2343 (+2) because
delivery commits added two AC-9 regression-guard tests (`test_board_view_omits_team_column_when_field_unconfigured`
and `test_issue_list_omits_team_column_when_field_unconfigured`). See `full-suite.txt` for full discrepancy note.

## Regeneration Log

All 11 artifacts verified at head `64e2a4bc` (2026-08-03). Each artifact carries its own
per-file `# Head:` stamp. Status per artifact:

| Artifact | Head | Captured | Status | Reason |
|----------|------|----------|--------|--------|
| `AC-001.txt` | 64e2a4bc | 2026-08-03 | reproduced-clean | Static file check (delta-analysis.md); content unchanged |
| `AC-002.txt` | 64e2a4bc | 2026-08-03 | reproduced-clean | SHA grep correct; BSD grep ordering non-deterministic (noted in file) |
| `AC-003.txt` | 64e2a4bc | 2026-08-03 | transcript-fidelity fix | sed range corrected from '58,87p' to '59,86p' — prior showed 28 lines but range 58-87 produces 30 (blank lines at 58, 87 omitted by mistake) |
| `AC-004.txt` | 64e2a4bc | 2026-08-03 | regenerated | Prior cited non-existent comment text at wrong line numbers; RUSTUP_TOOLCHAIN at :80 (actual :86); comment rewritten in docs commits |
| `AC-005.txt` | 64e2a4bc | 2026-08-03 | reproduced-clean | grep and sed output match actual files exactly |
| `AC-006.txt` | 64e2a4bc | 2026-08-03 | regenerated | Prior captured stale gotcha title claiming rust-toolchain.toml overrides `rustup override`; claimed RUSTUP_TOOLCHAIN is "highest-precedence" (incorrect — `+toolchain` ranks above it); line shifted from 218 to 219 |
| `AC-007.txt` | 64e2a4bc | 2026-08-03 | reproduced-clean | All zeros confirmed |
| `AC-008.txt` | 64e2a4bc | 2026-08-03 | regenerated | Prior cited prohibited internal factory path (`# Ref: .factory/...`) as CONFIRMED; actual comment is `# See: issue #626.` per ruling ADV-P1-LOW-001; prior also omitted `--locked` and captured warm no-op |
| `AC-009.txt` | 64e2a4bc | 2026-08-03 | regenerated (coverage claim corrected) | Prior falsely claimed removing the outer OutputFormat::Table check would produce non-empty team_displays; corrected: tests pin only the inner field_id guard, not the outer Table gate |
| `full-suite.txt` | 64e2a4bc | 2026-08-03 | regenerated | Fresh run; timing values updated; cargo clean output reflects current state |

**Completeness: 11/11 artifacts verified and stamped. No artifact left with only the global INDEX head stamp.**

## Defects Corrected (Cumulative — All Rounds)

**Round 1 (Jul-30 → Jul-31) — F-03 and F-04:**

**F-03 (HIGH) — AC-009.txt false-green test filter (Round 1):**
The Jul-30 artifact recorded filter substrings `board_view_kanban_omits_team_col_when_field_unconfigured`
and `issue_list_omits_team_col_when_field_unconfigured`, neither of which is a substring of any
real test name. Re-running the recorded command produced `running 0 tests; test result: ok` —
exit 0 with zero tests exercised. The correct names (with `test_` prefix) are
`test_board_view_omits_team_column_when_field_unconfigured` and
`test_issue_list_omits_team_column_when_field_unconfigured`. The corrected artifact shows
`running 2 tests` with both passing.

**F-04 (MEDIUM) — AC-003.txt MSRV capture indistinguishable from warm-cache no-op (Round 1):**
The Jul-30 artifact captured only `Finished 'dev' profile … in 0.19s` — no toolchain identity,
no `Checking` line. The corrected artifact adds `rustc --version` output (`rustc 1.85.0
(4d91de4e4 2025-02-17)`), `rustup show active-toolchain` output (`1.85.0-aarch64-apple-darwin
(overridden by environment variable RUSTUP_TOOLCHAIN)`), and a cold `Compiling jr …` line.

**Additional Round-1 staleness corrected:**
- `Head:` updated from `b51fc26a` to `64e2a4bc` (three docs commits landed after Jul-30)
- AC-003: `--locked` added to command; ci.yml comment scope updated (:74-83, 10 lines); env
  line reference updated (:85-86)
- AC-002: second dtolnay use in ci.yml corrected from line :106 to line :112 (coverage job)
- full-suite.txt: test name references corrected; MSRV command updated with `--locked` and
  toolchain identity

**Round 2 (Jul-31 → Aug-03) — Five artifacts corrected:**

**AC-004 (HIGH) — Stale comment text and line numbers:**
Prior captured `77: # the 1.85.0 MSRV toolchain. --all-features is intentional.` — this
comment was rewritten to the 10-line wiremock-scope block in a docs commit. RUSTUP_TOOLCHAIN
was recorded at :80; actual is :86. Regenerated with 6-line grep output matching head.

**AC-006 (HIGH) — Factually wrong gotcha title and precedence claim:**
Prior captured stale title claiming `rust-toolchain.toml` overrides `rustup override` and the
`dtolnay/rust-toolchain` action's `toolchain` input. The delivered CLAUDE.md documents a
corrected, narrower claim: toml outranks `rustup default` only. Prior also claimed
`RUSTUP_TOOLCHAIN` is "the highest-precedence override" — incorrect; `+toolchain` ranks above
it. Line number shifted from 218 to 219. Regenerated with actual delivered text.

**AC-008 (HIGH) — Inverted acceptance criterion (internal path CONFIRMED as present):**
Prior recorded `Cargo.toml:23` as `# Ref: .factory/research/msrv-let-chains-comfy-table-2026-07-30.md`
and stamped CONFIRMED. AC-8 requires that path NOT appear (ruling ADV-P1-LOW-001 — internal
paths must not appear in a manifest published to crates.io). The delivered file correctly uses
`# See: issue #626.` at the end of a 5-line comment block. Prior also omitted `--locked` and
captured a warm 0.19s no-op without toolchain identity. Regenerated with correct content,
`--locked`, real Compiling line, and toolchain identity.

**AC-009 (MEDIUM) — False coverage claim about outer Table gate:**
Prior claimed "A regression that removed the outer OutputFormat::Table check would produce a
non-empty team_displays Vec even without a field_id." This is false: both tests use
write_config_without_team_field (team_field_id = None), so removing the outer Table check
leaves the inner else { Vec::new() } firing — team_displays stays empty regardless.
The tests pin the INNER if let Some(field_id) guard only. Corrected with detailed
before/after analysis of the actual control-flow structure.

**AC-003 (LOW) — Transcript fidelity: sed range vs. displayed output:**
Prior used `sed -n '58,87p'` but displayed 28 lines corresponding to lines 59-86. Line 58
is a blank separator and line 87 is a blank separator; both were omitted. Command corrected
to `sed -n '59,86p'` so command and transcript agree exactly.

## Per-AC Evidence

This story has no user-visible behaviour change by design — it is regression evidence proving
nothing broke. AC-9 (the in-tree let-chain rewrites) is the highest-risk element because it
touched output-formatting code paths (`board.rs` and `list.rs`). The AC-9 evidence is the
sharpest proof: tests mount issues carrying team UUIDs, then confirm the rewritten branch
correctly suppresses the Team column when the field is unconfigured.

| AC | What Changed | Demo File | Command / Check | Result |
|----|-------------|-----------|----------------|--------|
| AC-001 | SHA verification (blocking gate) | `AC-001.txt` | Read delta-analysis.md §5e | PASS |
| AC-002 | 7 new-SHA occurrences across 6 files | `AC-002.txt` | `grep -n fa04a145` across 6 files | PASS |
| AC-003 | msrv job: toolchain input + RUSTUP_TOOLCHAIN env | `AC-003.txt` | `sed -n '59,86p' ci.yml` + MSRV check with toolchain identity proof | PASS |
| AC-004 | msrv comment accuracy: # 1.85.0 | `AC-004.txt` | `grep -n 1.85.0 ci.yml` | PASS |
| AC-005 | rustup target add steps preserved | `AC-005.txt` | `grep E0463`/`rustup target add` both files | PASS |
| AC-006 | CLAUDE.md gotcha added | `AC-006.txt` | `grep -n rust-toolchain.toml.*outranks CLAUDE.md` | PASS |
| AC-007 | Old SHA c93f4f9c absent | `AC-007.txt` | `grep -rc c93f4f9c .github/workflows/` → all 0 | PASS |
| AC-008 | comfy-table pinned to 7.2.1 | `AC-008.txt` | `grep comfy-table Cargo.toml/lock` + MSRV check with Compiling line | PASS |
| AC-009 | 3 in-tree let-chains rewritten + 2 new tests | `AC-009.txt` | before/after diff + `cargo test --test team_column_parity` (running 2 tests) | PASS |

**Total: 9/9 ACs covered. All checks green.**

## Key Implementation Notes

- The story has no user-visible behaviour change by design. All evidence is regression proof.
- AC-3 and AC-8 share the same acceptance check (`RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features --locked`).
  Both are jointly load-bearing: the comfy-table pin ensures the dep tree compiles at 1.85.0;
  the in-tree let-chain rewrites (AC-9) ensure jr's own source also compiles at 1.85.0.
- The 7 SHA occurrences across 6 files reflect ci.yml having two dtolnay/rust-toolchain uses:
  the msrv job (:70, toolchain "1.85.0") and the coverage job (:112, toolchain "stable").
  The test job (:42) uses NO dtolnay/rust-toolchain action.
- AC-9 test non-vacuousness: `running 2 tests` with correct function names
  `test_board_view_omits_team_column_when_field_unconfigured` and
  `test_issue_list_omits_team_column_when_field_unconfigured`. Each test mounts issues with
  team UUID data present so the rewritten `else { Vec::new() }` branch must actively suppress
  the column — passing on data, not on an empty response. Positive anchors on Assignee/Summary
  confirm the table rendered.
- AC-9 test coverage scope: the two tests pin the INNER `if let Some(field_id) = team_field_id`
  guard (the new else { Vec::new() } branch). They do NOT independently pin the outer
  `matches!(output_format, OutputFormat::Table)` gate — because with team_field_id = None,
  removing the outer Table check has no effect on the test result. See AC-009.txt corrected
  coverage claim section for full analysis.
- The `--all-targets` flag in clippy is intentional and matches project CLAUDE.md convention.
  Note: `cargo check --all-features --locked` in the MSRV check deliberately omits `--all-targets`
  because wiremock (a dev-dependency) requires Rust >=1.88.0; that is the CI comment at
  ci.yml :74-83 and is correct, not an oversight.
- rustup toolchain list confirms 1.85.0 available: `1.85.0-aarch64-apple-darwin` listed.
  All MSRV captures show `RUSTUP_TOOLCHAIN=1.85.0 rustup show active-toolchain` →
  `1.85.0-aarch64-apple-darwin (overridden by environment variable RUSTUP_TOOLCHAIN)`.
