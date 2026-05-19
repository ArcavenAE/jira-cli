# S-288-pr2-cli Adversary Pass 02

## Verdict
FINDINGS — clean-pass counter remains 0/3.

## Findings

### CRITICAL
None.

### HIGH

**H-1 (pass02): JSON output key `requestTypeFields` violates BC-X.12.007/AC-007 mandated key `fields` — test was *loosened* to match impl (L-288-pr1-01 anti-pattern recurrence)**
- `src/types/jsm/request_type.rs:42-46`: `RequestTypeFieldsResponse` uses `#[serde(rename_all = "camelCase")]` → serializes `request_type_fields` as `"requestTypeFields"`.
- `src/cli/requesttype.rs:154-159`: handler passes `&fields_response` directly to `output::print_output` (no JSON shaping).
- BC-X.12.007: `{canRaiseOnBehalfOf, canAddRequestParticipants, fields: [...]}` — mandates **`fields`**.
- AC-007: same.
- `tests/requesttype_commands.rs:858-866`: test accepts EITHER `fields` OR `requestTypeFields`:
  ```rust
  let field_arr = obj.get("fields").or_else(|| obj.get("requestTypeFields"))
  ```
- The inline test-writer comment explicitly states "story normalizes requestTypeFields → fields in the CLI output" — but the normalization was never implemented. Test was relaxed instead of the impl being fixed. Exact pattern L-288-pr1-01 forbids.
- **Fix**: handler-side JSON shaping (re-serialize to `{canRaiseOnBehalfOf, canAddRequestParticipants, fields: [...]}` via an intermediate `serde_json::Value`); restore test to pin `fields` only.

**H-2 (pass02): Hint suffix drifts between two error branches within same handler AND drifts from BC verbatim**
- BC-X.12.006 mandates: `"Run \`jr requesttype list --project <KEY>\` to see all request types"`.
- `src/cli/requesttype.rs:200-201` (Ambiguous branch): emits `"...to see available types."` — wrong adjective.
- `src/cli/requesttype.rs:210-216` (None branch): emits `"...to see current types, or delete..."` — wrong adjective (different from Ambiguous).
- Two distinct adjectives across two branches in the same handler is inconsistent.
- Tests pin only the command prefix; suffix drift is invisible to CI.
- **Fix**: align both branches to BC's "see all request types" (or update BC to a single canonical phrase + tighten test).

### MEDIUM

**M-1 (pass02): `find_id_by_name` `.expect()` relies on a caller invariant that depends on `partial_match::Exact` returning a candidate-list entry — refactor of partial_match could panic confusingly**
- `src/cli/requesttype.rs:220-226`: `.expect("matched name from partial_match::Exact must exist in types — caller invariant")`.
- Safer pattern: change `partial_match` to return the matched index or struct ref directly, OR have `find_id_by_name` return `Option<String>` and let the caller treat None as internal error.
- **Fix priority**: defensive; acceptable for now if guarded by comment + invariant docstring.

**M-2 (pass02): Numeric-ID path bypasses cache, partial_match, and existence check — typo `jr requesttype fields 99999` returns raw API 404 with no curated hint**
- `src/cli/requesttype.rs:108-112`: numeric-ID branch passes through to API immediately.
- BC-X.12.005 says "bypass as in BC-3.8.004" — likely by design — but UX inconsistent with name-based not-found.
- No test exercises this path.
- **Fix priority**: doc the behavior in BC OR add curated 404 handling. Defer if BC declares this OK.

**M-3 (pass02 / process-gap): Test for AC-007 was added in same PR that violates L-288-pr1-01 anti-pattern**
- The `.or_else()` accept-either-key pattern in `tests/requesttype_commands.rs:858-866` is exactly the lesson L-288-pr1-01 codified. The test-writer knew and added the comment "story normalizes ..." while not noticing the normalization wasn't implemented.
- Codification: PR-template question — *"Do any test assertions use `.or_else()`, `.contains() || .contains()`, or accept-either-of-X patterns?"*
- Or grep-lint: scan `tests/` diff for `.or_else(|| obj.get(` and require comment justification.

**M-4 (pass02): New cache families (`request_types_<sid>.json`, `request_type_fields_<sid>_<rtId>.json`) not documented in CLAUDE.md "Cache format changes" gotcha**
- Existing gotcha mentions only `cmdb_fields.json`. Add the two new cache file paths.

**M-5 (pass02): Cache filename numeric-ID assumption is comment-only, not runtime-asserted — defense-in-depth gap (theoretical path-traversal)**
- `src/cache.rs:452-458`: SAFETY comment only.
- **Fix**: `debug_assert!(service_desk_id.chars().all(|c| c.is_ascii_alphanumeric() || c == '-'))` at the cache-write boundary. Cheap insurance.

**M-6 (pass02): `Some("")` empty-string search bypasses cache and forwards `?searchQuery=` to API — UX inconsistency**
- `src/cli/requesttype.rs:76`: `search.is_some()` accepts `Some("")`.
- **Fix**: treat `Some("")` as `None` for cache + URL composition. Trivial 1-line guard.

### LOW / NIT
- **L-1/L-2**: Tests use loose `contains()||contains()` for capitalized column headers. Could pin canonical case.
- **L-3**: "Run `jr init`" hint inherited from queue.rs — pre-existing, not a new defect.
- **L-4**: `0000000000000000000000` accepted as "valid" numeric ID — combined with M-2, low-impact.
- **L-5**: Test config uses `[instance]` + `[profiles.default].project` — works only because JR_BASE_URL short-circuits; not realistic. Test-only concern.
- **L-6**: Cache write clones entire Vec — performance NIT for >100 types (rare).

### Process-gap findings (codification follow-up)
- **PG-1 (pass02)**: L-288-pr1-01 lesson is in CLAUDE.md but not enforced at gate. PR template question OR grep-lint required.
- **PG-2 (pass02)**: Two consecutive error branches in same handler with different adjectives. Convention: "shared error-hint suffixes MUST be identical unless behaviorally different."
- **PG-3 (pass02)**: BCs mandating verbatim strings need tests that pin >=2/3 of the phrase (not just the command prefix).

## Reviewed surfaces
- src/cli/requesttype.rs (full 227 LOC)
- src/cli/mod.rs (RequestType + command name pin)
- src/cli/queue.rs (full file with BC-X.8.004 label)
- src/api/jsm/servicedesks.rs (require_service_desk + template)
- src/cache.rs (new structs + R/W + cross-profile tests)
- src/config.rs (ProfileConfig.project)
- src/main.rs (RequestType dispatch arm)
- src/types/jsm/request_type.rs (struct serde shapes feeding JSON output)
- src/api/jsm/request_types.rs (URL + pagination + searchQuery forwarding)
- src/output.rs (verified serde pass-through)
- tests/requesttype_commands.rs (all 12 tests)
- tests/queue.rs (BC-X.8.004 phrase pin)
- tests/project_meta.rs
- .factory/specs/prd/cross-cutting.md (BC-X.12.001..008, BC-X.8.004)
- .factory/code-delivery/issue-288-pr2-cli/story.md (AC-001..AC-012)
- CLAUDE.md (worktree-local)

## Not reviewed (scope guard)
- src/api/jsm/queues.rs, src/api/pagination.rs::ServiceDeskPage (unchanged dependencies)
- src/error.rs (unchanged)
- pr1-api scope (S-288-pr1-api): RequestType / RequestTypeFieldsResponse types inherited; H-1 fix CAN happen handler-side in pr2 without touching pr1
- pr4-dispatch scope (no scope creep observed)

## Triage / routing (orchestrator decision)

| Finding | Severity | Route | Rationale |
|---------|----------|-------|-----------|
| H-1 | HIGH | implementer + test-writer | Handler-side JSON shape; restore test pin to `fields` only |
| H-2 | HIGH | implementer | Align both error branches to BC verbatim "see all request types"; test-writer adds pin |
| M-1 | MEDIUM | DEFER | Defensive refactor; acceptable for now (caller invariant correct, comment present) |
| M-2 | MEDIUM | DEFER → BC clarification | BC-X.12.005 says "bypass" — log as DOCUMENT-AS-IS or add small follow-up issue for curated 404 |
| M-3 | process-gap | (resolves with H-1 fix) | Codification deferred to PG-1 |
| M-4 | MEDIUM | implementer | One-line CLAUDE.md gotcha addition |
| M-5 | MEDIUM | implementer | debug_assert on cache-filename components |
| M-6 | MEDIUM | implementer | Treat `Some("")` as `None` for search |
| L-1..L-6 | LOW/NIT | DEFER | No contract violations |
| PG-1..PG-3 | process-gap | follow-up issues | Codify in CLAUDE.md or PR template |

Sequencing for pass 03 prep:
1. implementer: H-1 (JSON shape), H-2 (verb alignment in both branches), M-4 (CLAUDE.md), M-5 (debug_assert), M-6 (empty-search guard)
2. test-writer: H-1 (pin `fields` only, remove `.or_else`), H-2 (pin full BC suffix in both branches)
3. orchestrator re-dispatches adversary pass 03

Novelty: MEDIUM-HIGH. H-1 + M-3 process-gap recurrence is the most concerning finding (lesson codified, lesson violated in same PR).
