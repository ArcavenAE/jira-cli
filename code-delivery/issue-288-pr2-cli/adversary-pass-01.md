# S-288-pr2-cli Adversary Pass 01

## Verdict
FINDINGS — clean-pass counter does NOT advance (0/3).

## Findings

### CRITICAL
None. (The implementation compiles, the cache boundary is profile-namespaced, the dispatch wiring is in place, and the new commands behave end-to-end.)

### HIGH

**H-1: AC-003 / BC-X.12.003 spec drift — error message missing the word "commands"**
- File: `src/api/jsm/servicedesks.rs:118-123` + caller at `src/cli/requesttype.rs:36`
- BC-X.12.003 mandates the literal phrase `"jr requesttype commands require a Jira Service Management project"`. Impl passes `"jr requesttype"` (no "commands") → renders `"jr requesttype requires a Jira Service Management project"` (also wrong number agreement). Drift on the entire point of the BC-X.8.004 contract.
- Fix: redesign template + label so the BC's verbatim phrase is produced. See M-1.

**H-2: AC-003 test is tautological — asserts what impl emits, not what BC requires**
- File: `tests/requesttype_commands.rs:394-397`
- Asserts only `stderr.contains("jr requesttype")`. Trivially true for the impl's emission; would pass even if the BC-mandated phrase were missing. Textbook L-288-pr1-01 violation.
- Fix: assert the full BC-X.12.003 phrase verbatim.

**H-3: BC-X.12.006 spec drift — `ExactMultiple` documented to proceed, impl errors**
- File: `src/cli/requesttype.rs:181-192` (the `ExactMultiple` arm)
- BC says case-variant duplicates → "treated as Exact, proceeds." Impl returns `JrError::UserError("Multiple request types named ...")` and exits 64.
- Resolution: align BC to the conservative impl (require numeric ID for duplicate names; matches `cli/queue.rs` precedent and is deterministic across Atlassian response ordering). Update BC-X.12.006 + adjust AC-005 wording.

**H-4: BC-X.12.008 spec drift — not-found error missing mandated cache-deletion hint**
- File: `src/cli/requesttype.rs:204-208` (the `MatchResult::None` arm)
- BC-X.12.008 §"Stale-cache window" mandates a second sentence: *"...or delete the cache file at ~/.cache/jr/v1/<profile>/request_types_<service_desk_id>.json if a recent admin change is suspected."*. Impl omits it entirely. Sole recovery path for stale cache + admin rename.
- Fix: append cache-deletion sentence; add test pinning the cache path appears in stderr.

**H-5: AC-010 references a non-existent regression test**
- File: story `.factory/code-delivery/issue-288-pr2-cli/story.md:161-164`
- AC-010 claims `Pinned by: tests/queue.rs`. `grep -c "Queue commands" tests/queue.rs` = 0. The only related assertion is `tests/project_meta.rs:126` (lowercase, weak template). Queue-side text also drifted to plural-noun + singular-verb (`"queue commands requires..."`).
- Fix: add real `tests/queue.rs` assertion pinning the canonical phrase; update story Pinned-by reference; reconcile template grammar.

### MEDIUM

**M-1: Grammatical defect — "queue commands requires" (template-design tension)**
- File: `src/api/jsm/servicedesks.rs:118-123`
- Template hard-codes singular "requires". Cannot produce BC-X.8.004 plural-subject form ("Queue commands ... require") or BC-X.12.003 ("jr requesttype commands require") without dropping "requires" from the template and pushing the verb into the call-site label.
- Fix: change template to `"\"{}\" is a {} project. {} a Jira Service Management project."` (drops "requires"). Callers supply `<noun phrase> <verb>` like `"Queue commands (jr queue) require"` and `"jr requesttype commands require"`. Matches BC-X.8.004 verbatim.

**M-2: AC-006 hint wording drifted — BC says "Use", impl says "Run"**
- File: `src/cli/requesttype.rs:194-203, 204-208`
- BC-X.12.006: hint `"Use \`jr requesttype list --project <KEY>\`"`. Impl emits `"Run \`jr requesttype list ...\`"`. Tests assert only the substring `"requesttype list --project HELP"` — neither verb is pinned.
- Resolution: align BC to impl ("Run" is more imperative, fits CLI ergonomics). Update BC text; tighten test to verbatim "Run".

**M-3: Inconsistent cache-write error handling**
- File: `src/cache.rs:381-399, 424-443` (new writers)
- New writers swallow errors with `eprintln!("warning: ...")` and return `Ok(())`. Every other writer propagates via `?`. Inconsistency silent + undocumented; routes around `JrError` exit-code mapping.
- Fix: document the best-effort pattern in rustdoc on both new writers (intentional choice for cache hygiene — cache write failure must not break a successful read).

**M-4: Cache filename collision risk on `_` in IDs**
- File: `src/cache.rs:420, 430`
- `format!("request_type_fields_{sid}_{rtId}.json")` ambiguous if either ID contains `_`. JSM IDs numeric in practice; defensive only.
- Fix: assert `parse::<u64>()` at the cache-write boundary OR document the numeric-ID assumption.

**M-5: Missing unit tests for cross-profile isolation on new caches (POLICY: multi-profile-cache, CRITICAL)**
- File: `src/cache.rs` `#[cfg(test)] mod tests`
- No analog to `cross_profile_isolation_team_cache` for `request_type_cache` / `request_type_fields_cache`. CRITICAL policy unpinned by direct unit test.
- Fix: add two trivial unit tests mirroring the existing pattern.

**M-6: AC-008/AC-009 cache-hit tests use weak equivalence**
- File: `tests/requesttype_commands.rs:805-896, 908-1007`
- Only compare `len()` or one key between two invocations. Strengthen to `assert_eq!(parsed1, parsed2)`. Pre-mock for project-meta/service-desk-list also missing `expect(N)` — flagged as observation, not blocker.

**M-7: Pre-existing concern about repeated cache warning** — deferred (out of scope; not introduced by this PR).

### LOW / NIT

**L-1: Vacuous-true bug on empty string in numeric-ID detection**
- File: `src/cli/requesttype.rs:104`
- `"".chars().all(|c| c.is_ascii_digit())` → `true`. Defensive guard: `!name_or_id.is_empty() && name_or_id.chars().all(...)`.

**L-2: `find_id_by_name` fallback is dead code**
- File: `src/cli/requesttype.rs:212-218`
- Called only with `matched_name` from `partial_match::Exact` (by construction one of the candidates). `.expect("matched name must exist in types")` is more honest.

**L-3: `Default` derive on cache structs creates Unix-epoch timestamp**
- File: `src/cache.rs:361-365, 403-407`
- `#[derive(Default)]` produces `fetched_at: 1970-01-01T00:00:00Z` → auto-expired. No call site uses `::default()` today. Remove the derive OR document.

**L-4: Story metadata duplicate of H-5** — fixed by H-5 fix.

**NIT-1: `expect(1)` comment phrasing** — pedantic; not actionable.

### Process-gap findings (codification follow-up)

**[process-gap] PG-1: AC test pattern structurally tautological — L-288-pr1-01 not enforced at gate**
- AC-003 assertion at `tests/requesttype_commands.rs:394-397` is a textbook tautology despite L-288-pr1-01.
- Codification: checklist item in story-writer / adversary prompts — *"For every BC-string assertion in a test, grep the BC body for the exact phrase and confirm the test asserts at least 2/3 of it verbatim."*

**[process-gap] PG-2: Story `Pinned by:` references not cross-checked at finalization**
- AC-010 named a test that doesn't exist; surfaced only at adversarial review.
- Codification: `scripts/check-ac-pins.sh` — parse each story's `Pinned by:` line, grep for at least one matching assertion in the named test file; fail story-writer gate if dangling.

**[process-gap] PG-3: BC-X.8.004 contract is free-form `&'static str` — no compile-time guard against label drift**
- H-1, M-1, M-2 all stem from passing free-form strings. Typed enum (`enum CallSiteLabel { QueueCommands, RequestTypeCommands, ... }`) with `Display` producing the BC-correct phrase would make these unrepresentable.
- File as follow-up issue; ~30 LOC refactor.

## Reviewed surfaces
- src/cli/requesttype.rs, src/cli/queue.rs, src/cli/mod.rs
- src/cache.rs
- src/api/jsm/servicedesks.rs, src/api/jsm/request_types.rs
- src/types/jsm/request_type.rs, src/types/jsm/mod.rs
- src/config.rs, src/main.rs, src/output.rs, src/partial_match.rs (excerpts)
- src/api/client.rs (excerpts — new_for_test, profile_name, 401-refresh path)
- tests/requesttype_commands.rs, tests/project_meta.rs, tests/queue.rs (excerpts)
- .factory/code-delivery/issue-288-pr2-cli/story.md
- .factory/specs/prd/cross-cutting.md (BC-X.12.001..008, BC-X.8.004)
- CLAUDE.md (project policies)

## Not reviewed (scope guard)
- .factory/code-delivery/issue-288-pr1-api/ (merged PR #379 perimeter)
- .factory/specs/prd/bc-3-issue-write.md (BC-3.8.001..010 are pr4-dispatch scope)
- src/api/jsm/requests.rs (pr1/pr4 surface)
- docs/superpowers/specs/2026-03-24-jsm-queues-design.md (cross-cycle scope)
- src/api/refresh_coordinator.rs, S-3.03 OAuth internals (unrelated)
- tests/auth_*.rs, tests/oauth_*.rs, tests/bulk_*.rs (unrelated subsystems)

## Triage / routing (orchestrator decision)

| Finding | Severity | Route | Rationale |
|---------|----------|-------|-----------|
| H-1 | HIGH | implementer | Pass `"jr requesttype commands require"` from cli/requesttype.rs; combined with M-1 template redesign |
| H-2 | HIGH | test-writer | Sharpen AC-003 to verbatim BC phrase |
| H-3 | HIGH | product-owner | Update BC-X.12.006 to mandate conservative behavior (matches impl + queue precedent) |
| H-4 | HIGH | implementer + test-writer | Append cache-deletion sentence; add test for cache path in stderr |
| H-5 | HIGH | story-writer + test-writer | Update AC-010 Pinned-by + add real `tests/queue.rs` assertion |
| M-1 | MEDIUM | implementer | Template redesign: drop "requires" from template; verb moves into label |
| M-2 | MEDIUM | product-owner + test-writer | Align BC to impl ("Run"); pin verbatim in test |
| M-3 | MEDIUM | implementer | Rustdoc on best-effort writers |
| M-4 | MEDIUM | implementer | Document numeric-ID assumption OR add assert |
| M-5 | MEDIUM | test-writer | Two cross-profile isolation unit tests (CRITICAL POLICY) |
| M-6 | MEDIUM | test-writer | Tighten cache-hit tests to assert_eq! |
| M-7 | MEDIUM | DEFERRED | Pre-existing, out of scope |
| L-1 | LOW | implementer | Empty-string guard |
| L-2 | LOW | implementer | `.expect()` instead of `.ok_or_else()` |
| L-3 | LOW | implementer | Remove `#[derive(Default)]` from cache structs |
| L-4 | LOW | (resolved by H-5) | n/a |
| NIT-1 | NIT | DEFERRED | Pedantic |
| PG-1 | process-gap | follow-up issue | Codification |
| PG-2 | process-gap | follow-up issue | Codification |
| PG-3 | process-gap | follow-up issue | Codification |

Sequencing:
1. product-owner: H-3, M-2 BC update, H-5 story update (parallel)
2. implementer: H-1, H-4, M-1, M-3, M-4, L-1, L-2, L-3 (sequential — all touch same 2-3 files)
3. test-writer: H-2, H-4-pin, H-5-pin, M-2-pin, M-5, M-6 (after impl changes land)
4. Re-dispatch adversary pass 02 (fresh context)

Novelty: HIGH — H-1, H-3, H-4, H-5 are first-discovery contract drifts not anchored to prior pr1 review notes. H-2 + PG-1 are the L-288-pr1-01 lesson surfacing in practice.
