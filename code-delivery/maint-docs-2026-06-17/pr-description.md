## Summary

Documentation-accuracy sweep for 2026-06-17 maintenance cycle. Fixes twelve drift findings (DRIFT-D1..D12) and two code-review comment issues (CR-003, CR-004). **Docs + 1 justification comment only — zero behavior change.**

- CLAUDE.md architecture tree corrected: `auth/` and `assets/` are now module directories (not flat files), 12 previously-unlisted production files added, JSM `api/jsm/` subsection expanded
- CLAUDE.md OQ-5 correction: `auth status` has *no* `--output json` support (was incorrectly claiming single-profile JSON was implemented)
- CLAUDE.md `--verbose` Gotcha: remove stale "+ status" — only method + URL are logged
- README.md: exit code 124 added; `jr issue changelog` + `jr api` + `jr requesttype` commands added; `--verbose`/`--verbose-bodies` Global Flags updated to reflect SD-003
- `src/adf.rs`: justification comment added above `#[allow(clippy::too_many_lines)]` (CR-003)
- `src/cli/mod.rs`: stale doc-comment "headers + status + URL" → "method + URL only" (CR-004)

## Finding IDs Addressed

| ID | Location | Severity | Change |
|----|----------|----------|--------|
| DRIFT-D1 | CLAUDE.md arch tree | HIGH | `cli/auth.rs` → `auth/` module directory |
| DRIFT-D2 | CLAUDE.md arch tree + Gotcha | HIGH | `cli/assets.rs` → `assets/` module directory; filter_tickets citation fixed |
| DRIFT-D3 | CLAUDE.md arch tree | HIGH | 12 missing production files added |
| DRIFT-D4 (OQ-5) | CLAUDE.md Conventions | HIGH | auth status JSON claim corrected to "not implemented" |
| DRIFT-D5 | CLAUDE.md arch tree + Known Size Deviations | MED | list.rs description + LOC 1083→1256 |
| DRIFT-D6 | README.md Exit Codes | MED | exit code 124 added |
| DRIFT-D7 | README.md Commands | MED | jr api + jr issue changelog rows added |
| DRIFT-D8 | README.md Global Flags | MED | --verbose SD-003 + --verbose-bodies row |
| DRIFT-D9 | docs/adr/ | LOW | out of scope (create ADR-0014); not addressed in this PR |
| DRIFT-D10 | .factory/specs/prd/README.md | LOW | out of scope (tracked PG-A); not addressed in this PR |
| DRIFT-D11 | CLAUDE.md Gotcha | LOW | --verbose "+ status" removed |
| DRIFT-D12 | README.md Commands | LOW | jr requesttype list/fields rows added |
| CR-003 | src/adf.rs | — | justification comment above #[allow(clippy::too_many_lines)] |
| CR-004 | src/cli/mod.rs | — | stale doc-comment corrected |

## Change Classification

**Docs + 1 comment, no behavior change.** No Rust logic, no API call changes, no test changes, no schema changes. Safe to land on `develop` at any time.

## Pre-Merge Evidence

| Check | Result |
|-------|--------|
| `cargo fmt --all -- --check` | PASS (no format changes needed) |
| `cargo build` | PASS |
| `cargo clippy -- -D warnings` | PASS (0 warnings) |
| Local code review (full diff) | CLEAN — one HIGH finding (auth status JSON claim) already resolved before this commit |

## Dependencies

None — standalone doc sweep, no upstream story PRs required.

## Risk Assessment

- **Blast radius:** Documentation and one code comment. No runtime code path changes.
- **Performance impact:** None.
- **Rollback:** `git revert b00f6fe` restores prior docs state with no side effects.
