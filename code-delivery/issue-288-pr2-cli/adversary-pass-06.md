# S-288-pr2-cli Adversary Pass 06

## Verdict
FINDINGS — clean-pass counter remains 0/3.

## Findings

### CRITICAL
None.

### HIGH
None.

### MEDIUM

**M-1: Cell-content assertion uses accept-either OR (L-288-pr1-01 recurrence)**
- File: `tests/requesttype_commands.rs:580` — `stdout.contains("summary") || stdout.contains("What do you need")`
- `summary` is the field_id; never rendered into the table by the impl. BC-X.12.005 mandates "Field Name (from `name`)". If a mutation swaps `f.name.clone()` for `f.field_id.clone()`, this test still passes via the `"summary"` branch.
- **Fix**: tighten to `stdout.contains("What do you need")` only.

**M-2: AC-001 column-header assertions accept lowercase variants**
- File: `tests/requesttype_commands.rs:198, 202` — `contains("Name") || contains("name")` and `contains("Description") || contains("description")`
- `comfy-table` emits headers verbatim. Lowercase OR branch is gratuitous accept-either.
- **Fix**: tighten to canonical case only.

**M-3: ExactMultiple test doesn't pin BC-mandated quoted-name segment verbatim**
- File: `tests/requesttype_commands.rs:834`
- BC-X.12.006 mandates: `Multiple request types named "<name>" found (IDs: ...). Pass the numeric ID directly.`
- Test asserts `contains("Multiple request types named")` + IDs + `contains("Pass the numeric ID directly.")` — but NOT the `"<name>" found (IDs:` segment.
- **Fix**: add `assert!(stderr.contains("named \"password reset\" found (IDs:"))` to lock the BC quoting.

**M-4: Cache-deletion-hint path is literal `~/.cache/jr/v1/...` — wrong when XDG_CACHE_HOME is set (system-level / spec defect)**
- File: `src/cli/requesttype.rs:235-241`; BC-X.12.008 also uses literal path.
- For an XDG_CACHE_HOME=/custom/cache user, actual file is at `/custom/cache/jr/v1/<profile>/...`, not `~/.cache/jr/...`.
- Impl faithfully copies BC, so this is also a spec defect.
- **Defer to follow-up issue**: requires BC-X.12.008 revision to mandate runtime-resolved path + impl change to use `cache::cache_dir(profile).join(...)`. Out of pr2 perimeter without a spec amendment cycle.

**M-5: Ambiguous error doesn't pin "Ambiguous request type" literal prefix verbatim**
- File: `tests/requesttype_commands.rs:696-701, 706`
- Test asserts candidate names + Run-hint, but not the BC-mandated `Ambiguous request type "<name>" matches:` prefix.
- **Fix**: add `assert!(stderr.contains("Ambiguous request type \"Password\""))`.

### LOW / NIT
- **L-1**: `RequestType::Default` impl is documentation-only mitigation; debug_assert on cache writer could prevent empty-id persistence. DEFER.
- **L-2**: Cross-profile test constructs RequestType directly (acceptable; pub(crate) wrapper API is sufficient). DEFER.
- **L-3**: `find_id_by_name` `.expect()` relies on partial_match invariant (correct today; defensive risk). DEFER.
- **L-4**: `write_minimal_config` uses legacy `[instance]` shape — triggers migration on every test, mild stderr clutter. DEFER (sibling-consistent with other test files).

### Process-gap findings
**PG-1**: L-288-pr1-01 "no accept-either" precision rule recurringly violated across AC-001/AC-005 column-content assertions. Multiple passes hardened some assertions but missed adjacent ones. Codify: CI lint or grep-check that fails when `assert!(... .contains("X") || .contains` patterns appear in `tests/*.rs` for new integration tests, OR a checklist item in test-writer agent prompt.

## Reviewed surfaces
- Full src/ files in scope
- Full tests/ files in scope
- Spec/story artifacts
- CLAUDE.md (worktree), .cargo/mutants.toml

## Not reviewed (scope guard)
- Wave 1 (pr1-api, merged), Wave 3 (pr4-dispatch, pending)
- Prior adversary reports (fresh-context constraint)
- ADR documents (no ADR-0014 referenced in story scope)
- docs/specs/*, tests/auth_*.rs (story declares regression-only)

## Triage / routing

| Finding | Severity | Route | Action |
|---------|----------|-------|--------|
| M-1 | MEDIUM | test-writer | Tighten cell-content assertion |
| M-2 | MEDIUM | test-writer | Tighten column-header to canonical case |
| M-3 | MEDIUM | test-writer | Pin verbatim quoted-name segment |
| M-4 | MEDIUM | DEFER → follow-up issue | System-level: BC-X.12.008 revision + impl path change |
| M-5 | MEDIUM | test-writer | Pin "Ambiguous request type" prefix verbatim |
| L-1..L-4 | LOW | DEFER | Cosmetic |
| PG-1 | process-gap | follow-up issue | Codify grep-lint or checklist |

Sequencing for pass 07 prep:
1. test-writer: M-1, M-2, M-3, M-5 (4 small assertion tightenings)
2. orchestrator files follow-up issues for M-4 + PG-1
3. orchestrator re-dispatches adversary

Novelty: **MEDIUM** — M-1/M-2 are L-288-pr1-01 pattern recurrences in adjacent assertions; M-3/M-5 are BC verbatim-pinning gaps. No CRITICAL/HIGH findings; impl is correct, gaps are at the test-precision tail.
