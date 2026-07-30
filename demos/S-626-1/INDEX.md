# S-626-1 Demo Evidence

Story: Fix rust-toolchain SHA pins + MSRV false-green + comfy-table pin + CLAUDE.md gotcha (closes #626)
Branch: `ci/fix-toolchain-sha-msrv`
Head: `b51fc26a`
Captured: 2026-07-30

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test` (aggregate) | 2343 passed / 0 failed / 100 ignored |
| `full-suite.txt` | `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features` | clean (exit 0) |
| `full-suite.txt` | `cargo clippy --all-targets -- -D warnings` | clean (exit 0) |
| `full-suite.txt` | `cargo fmt --all -- --check` | clean (exit 0) |

Baseline per story v1.3 scope note was 2341 passed / 100 ignored. This run shows 2343 (+2) because
head commit `b51fc26a` added two AC-9 regression-guard tests. See `full-suite.txt` for full
discrepancy note.

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
| AC-003 | msrv job: toolchain input + RUSTUP_TOOLCHAIN env | `AC-003.txt` | `sed -n ci.yml` + MSRV check | PASS |
| AC-004 | msrv comment accuracy: # 1.85.0 | `AC-004.txt` | `grep -n 1.85.0 ci.yml` | PASS |
| AC-005 | rustup target add steps preserved | `AC-005.txt` | `grep E0463`/`rustup target add` both files | PASS |
| AC-006 | CLAUDE.md gotcha added | `AC-006.txt` | `grep -n rust-toolchain.toml.*outranks CLAUDE.md` | PASS |
| AC-007 | Old SHA c93f4f9c absent | `AC-007.txt` | `grep -rc c93f4f9c .github/workflows/` → all 0 | PASS |
| AC-008 | comfy-table pinned to 7.2.1 | `AC-008.txt` | `grep comfy-table Cargo.toml/lock` + MSRV check | PASS |
| AC-009 | 3 in-tree let-chains rewritten + 2 new tests | `AC-009.txt` | before/after diff + `cargo test --test team_column_parity` | PASS |

**Total: 9/9 ACs covered. All checks green.**

## Key Implementation Notes

- The story has no user-visible behaviour change by design. All evidence is regression proof.
- AC-3 and AC-8 share the same acceptance check (`RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features`).
  Both are jointly load-bearing: the comfy-table pin ensures the dep tree compiles at 1.85.0;
  the in-tree let-chain rewrites (AC-9) ensure jr's own source also compiles at 1.85.0.
- The 7 SHA occurrences across 6 files reflect ci.yml having two dtolnay/rust-toolchain uses:
  the msrv job (:70, toolchain "1.85.0") and the stable/test job (:106, toolchain stable).
- AC-9 test non-vacuousness: each test mounts issues with team UUID data present so the
  rewritten `else { Vec::new() }` branch must actively suppress the column — passing on data,
  not on an empty response. Positive anchors on Assignee/Summary confirm the table rendered.
- The `--all-targets` flag in clippy is intentional and matches project CLAUDE.md convention.
  Note: `cargo check --all-features` in the MSRV check deliberately omits `--all-targets`
  because wiremock (a dev-dependency) requires Rust >=1.88.0; that is the CI comment at
  ci.yml :73-77 and is correct, not an oversight.
