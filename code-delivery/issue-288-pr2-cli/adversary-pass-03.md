# S-288-pr2-cli Adversary Pass 03

## Verdict
FINDINGS — clean-pass counter remains 0/3.

## Findings

### CRITICAL

**C-1: BC-X.8.004 verbatim error-message drift in `require_service_desk`**
- File: `src/api/jsm/servicedesks.rs` lines 121-126
- BC-X.8.004 + BC-X.12.003 mandate: `Project "<KEY>" is a <type> project. {label} a Jira Service Management project. Run "jr project list" to find a JSM project.`
- Impl produces: `"<KEY>" is a <type> project. {label} a Jira Service Management project. Run "jr project list" to see available projects.`
- Two distinct drifts: (1) missing `Project ` prefix; (2) wrong closing clause `see available projects` vs BC-mandated `find a JSM project`. The `[UPDATED 2026-05-18]` BC revision explicitly hardened the closing to JSM-specific wording.
- Blast radius: every JSM "wrong project" error message in the binary.
- **Fix**: update template in servicedesks.rs to BC verbatim.

**C-2: AC-010 test asserts the WRONG closing sentence (L-288-pr1-01 anti-pattern recurrence)**
- File: `tests/queue.rs:489-492` (the test added by pass-01 H-5)
- Asserts `stderr.contains("Run \"jr project list\" to see available projects.")` — the IMPL string, NOT the BC-mandated `Run "jr project list" to find a JSM project.`
- Test was written to match an out-of-spec implementation; now "validates" the drift. Same anti-pattern as pass-02 H-1 (`.or_else()` JSON key acceptance).
- **Fix**: update assertion to BC verbatim closing.

### HIGH

**H-1: `resolve_request_type_id` ExactMultiple branch uses case-SENSITIVE filter, losing case-variant IDs**
- File: `src/cli/requesttype.rs:211-222`
- Impl: `types.iter().filter(|t| t.name == matched_name)` — case-sensitive comparison.
- If three types are named `"Password Reset"`, `"password reset"`, `"PASSWORD RESET"`, filter only matches the one whose name === `matched_name` (the first case-variant from partial_match's iterator order). The other IDs are silently dropped — defeating the very purpose of the disambiguation error.
- Story explicitly directed: "matches `cli/queue.rs` precedent for duplicate queue names." `cli/queue.rs::resolve_queue_by_name` uses `q.name.to_lowercase() == name_lower` correctly. requesttype.rs does NOT mirror.
- No test catches this (no ExactMultiple-with-case-variants fixture exists).
- **Fix**: `.filter(|t| t.name.to_lowercase() == matched_name.to_lowercase())` + add fixture test.

**H-2: `Required` column emits `yes`/`no` but BC-X.12.005 mandates `YES`/`NO`**
- File: `src/cli/requesttype.rs:153`
- Impl: `if f.required { "yes" } else { "no" }`
- BC: "Default table output shows columns: Field Name, Required (YES/NO), Type."
- Tests pin column header only with `||` accept-either-case — drift invisible.
- **Fix**: uppercase output; tighten test to YES/NO verbatim.

**H-3: `tests/project_meta.rs::require_service_desk_errors_for_software_project` passes a label violating the documented `call_site_label` invariant**
- File: `tests/project_meta.rs:121` passes `"queue commands"` (lowercase, no parens, no verb).
- servicedesks.rs rustdoc mandates: "The label MUST be a full noun-phrase ending in the matching verb."
- Composed error: `"DEV" is a Jira Software project. queue commands a Jira Service Management project. Run "jr project list" to see available projects.` — ungrammatical.
- The test only asserts presence of substrings so it passes, but it documents the wrong contract for future callers who copy the pattern.
- **Fix**: update test label to the realistic form (e.g., `"Queue commands (\`jr queue\`) require"`).

### MEDIUM

**M-1: Numeric request-type names unreachable via `fields`**
- `name_or_id.chars().all(|c| c.is_ascii_digit())` short-circuits to ID-bypass. A Jira admin who names a request type `"100"` (legal Atlassian display name) cannot be referenced by name.
- BC intentional ("numeric → bypass") but edge case undocumented.
- **Fix**: CLAUDE.md gotcha; defer behavior change.

**M-2: No cache-corruption regression test for new cache families**
- Sibling caches (`team`, `workspace`, `cmdb_fields`) have `corrupt_*_cache_returns_none` regression tests. New `request_types_*.json` and `request_type_fields_*.json` lack the parallel guard.
- S-7.01 sibling-coverage axis: blast radius = 2 caches → MEDIUM.
- **Fix**: add two regression tests in `src/cache.rs` `#[cfg(test)] mod tests`.

**M-3: Asymmetric cache-write error handling vs sibling writers (process-gap candidate)**
- New request-type writers swallow errors; all other writers propagate via `?`. Rustdoc rationale cites "scripted pipeline like `jr requesttype list --output json | jq`" — but the same argument applies to every other cache. Inconsistency will confuse future maintainers.
- **Fix**: add CLAUDE.md gotcha codifying "best-effort cache write" as the project's chosen pattern OR convert all writers to one model.

**M-4: AC-005 column-header assertion is weak (accept-either-case)**
- Test asserts `contains("Field") || contains("field")` — could match `fieldId` cell content; would not catch dropping `Field Name` header entirely.
- **Fix**: pin verbatim `"Field Name"` + `"Type"` + `"Required"` (with H-2's YES/NO casing).

**M-5: Optional fields (`helpText`, `issueTypeId`) untested for null value**
- BC allows `<str>|null` but no fixture exercises null. Test asserts presence-of-key only.
- **Fix priority**: add a null-fixture test OR document as known gap.

### LOW / NIT

- **L-1**: Possibly redundant `use serde_json;` in cli/requesttype.rs (verify and remove if so).
- **L-2**: `#[derive(Default)]` on `RequestType` could produce empty-id cache filenames (debug_assert tolerates empty `.chars().all()`). Remove derive or document.
- **L-3**: `ExactMultiple` carries only the first case-variant name — display non-deterministic across calls.
- **L-4**: `clear_profile_cache` not tested against new families (defer; relies on `remove_dir_all`).

### Process-gap findings (codification follow-up)

**PG-1**: No CLAUDE.md gotcha for "BC-mandated user-visible string updates that don't propagate to existing impl." Both passes 01/02/03 had recurrent BC-string drift. Convention: *"Tests pinning user-facing strings MUST assert every sentence of the BC quote, not just a discriminating substring."*

**PG-2**: No CLAUDE.md policy on cache-write error propagation. M-3 codification.

## Reviewed surfaces
- src/cli/requesttype.rs (full, 251 LOC)
- src/cli/mod.rs, src/cli/queue.rs (full)
- src/api/jsm/servicedesks.rs (full)
- src/api/jsm/request_types.rs (full)
- src/cache.rs (full including cross-profile tests)
- src/config.rs, src/main.rs (full)
- src/partial_match.rs (excerpts), src/types/jsm/request_type.rs (full)
- src/output.rs (excerpts)
- tests/requesttype_commands.rs (full, 12 tests)
- tests/queue.rs (full incl. AC-010 regression)
- tests/project_meta.rs (full)
- .factory/specs/prd/cross-cutting.md (BC-X.12.001..008, BC-X.8.004 with [UPDATED 2026-05-18] revisions)
- .factory/code-delivery/issue-288-pr2-cli/story.md (full)
- CLAUDE.md (worktree)

## Not reviewed (scope guard)
- Prior adversary reports (deliberate fresh-context)
- pr1-api scope (merged PR #379)
- pr4-dispatch scope (Wave 3 pending; confirmed absent from issue create surfaces)
- tests/auth_profiles.rs regression (out of perimeter for this story)
- CI workflow files (story declared no CI changes)
- Mutation testing scope (out-of-scope per story)

## Triage / routing

| Finding | Severity | Route | Action |
|---------|----------|-------|--------|
| C-1 | CRITICAL | implementer | Fix template in servicedesks.rs to BC verbatim |
| C-2 | CRITICAL | test-writer | Fix tests/queue.rs:489-492 to BC closing verbatim |
| H-1 | HIGH | implementer + test-writer | `.to_lowercase()` compare + add case-variant fixture test |
| H-2 | HIGH | implementer + test-writer | Uppercase YES/NO + tighten pin |
| H-3 | HIGH | test-writer | Update tests/project_meta.rs label to realistic form |
| M-1 | MEDIUM | implementer (docs) | CLAUDE.md gotcha; defer behavior |
| M-2 | MEDIUM | test-writer | Add 2 corrupt-cache regression tests |
| M-3 | MEDIUM | implementer (docs) | CLAUDE.md cache-write policy gotcha |
| M-4 | MEDIUM | test-writer | Tighten AC-005 column-header pin |
| M-5 | MEDIUM | DEFER | File as follow-up issue (low impact; out-of-scope edge) |
| L-1 | LOW | implementer | Verify + remove if unused |
| L-2 | LOW | implementer | Remove `Default` from RequestType OR document |
| L-3..L-4 | LOW/NIT | DEFER | Non-blocking |
| PG-1, PG-2 | process-gap | follow-up issues | Codify |

Sequencing for pass 04 prep:
1. implementer: C-1, H-1, H-2, M-1 (docs), M-3 (docs), L-1, L-2
2. test-writer: C-2, H-1 (case-variant test), H-2 (YES/NO pin), H-3 (label fix), M-2 (corrupt-cache tests), M-4 (column header pin), AC-003 also extended to pin "Project " prefix + "find a JSM project" closing
3. orchestrator re-dispatches adversary

Novelty: **HIGH** — C-1/C-2 are new defects revealed by fresh-context BC↔impl triangulation. H-1 is a real logic bug with concrete data-loss behavior. The L-288-pr1-01 anti-pattern recurred AGAIN in C-2 — confirms PG-1 codification is overdue.
