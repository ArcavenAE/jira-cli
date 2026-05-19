# S-288-pr2-cli Adversary Pass 04

## Verdict
FINDINGS — clean-pass counter remains 0/3.

## Findings

### CRITICAL
None.

### HIGH
**H-1 (DOWNGRADED to NIT by orchestrator verification)**: Adversary flagged `use serde_json;` in `src/cli/requesttype.rs:9` as a potential `clippy::single_component_path_imports` violation under `-D warnings`. Adversary noted "If CI is currently green, this finding may be soft (re-classify to LOW)." Orchestrator independently ran `cargo clippy --all-targets --all-features -- -D warnings` and confirmed exit 0 — no warnings. The import is allowed by this codebase's clippy configuration. **Reclassified to L-1 (cosmetic NIT, no action required).**

### MEDIUM

**M-1: BC-X.12.006 and BC-X.12.008 disagree on the "see ___ request types" hint adjective**
- File: `.factory/specs/prd/cross-cutting.md` — BC-X.12.006 (line 695) mandates `"to see all request types"`; BC-X.12.008 §Stale-cache window (line 727) mandates `"to see current types"`.
- The impl (after pass-03 H-2 alignment) emits `"to see all request types"` in both error paths (Ambiguous + None). Tests pin "all request types" + negative guard against "current types".
- **Root cause**: spec-intra-document inconsistency — pass-02 PO update aligned BC-X.12.006 to "all" but did not propagate to BC-X.12.008. Adversary correctly flagged the unanchored BC.
- **Fix**: PO updates BC-X.12.008 §Stale-cache window to match BC-X.12.006: `"see all request types"`. Removes the contradiction; impl + test already match the desired state.

**M-2: Untested numeric-bypass path in `handle_fields`**
- File: `src/cli/requesttype.rs:113-117` — the `name_or_id.chars().all(|c| c.is_ascii_digit())` branch skips `partial_match` and goes directly to the fields HTTP call.
- No integration test exercises this path. A mutation that broke the numeric-bypass condition would pass all current tests.
- BC-X.12.005 explicitly mentions `<NAME|ID>` and the numeric bypass is a deliberate user-facing surface (documented as CLAUDE.md edge case M-1 from pass-03).
- **Fix**: test-writer adds `test_requesttype_fields_numeric_id_bypasses_list_resolution` — mount fields endpoint, set `expect(0)` on list endpoint, invoke `jr requesttype fields 11002 --project HELP`, assert exit 0 + fields shown + zero list calls.

**M-3: `debug_assert!` charset guards stripped in release builds (defense-in-depth gap)**
- File: `src/cache.rs:377-382, 403-408, 443-454, 483-494` — four sites use `debug_assert!(...alphanumeric || '-')` before cache filename construction.
- `debug_assert!` is a no-op in release. The CLAUDE.md collision concern (e.g., sid=`10_1` rtId=`200` vs sid=`10` rtId=`1_200`) is unenforced in release builds.
- Current API trust model (Atlassian IDs numeric) makes exploitation unlikely; severity MEDIUM (defense-in-depth), not CRITICAL.
- **Fix priority**: defer to follow-up issue. Either upgrade to `assert!` OR add a sanitization helper returning `Result`. Not blocking convergence.

**M-4: BC-X.12.008 not-found hint omits `--project <KEY>` that the impl includes**
- File: `.factory/specs/prd/cross-cutting.md:727` (BC-X.12.008 §Stale-cache window) — literal hint: `"Run \`jr requesttype list\` to see current types, or..."` (no `--project`).
- Impl at `src/cli/requesttype.rs:237-241` emits `"Run \`jr requesttype list --project {project_key}\` to see all request types, or..."` (includes flag).
- Test pins impl form. Same root cause as M-1 (BC-X.12.008 not re-aligned during pass-02/pass-03 updates).
- **Fix**: PO updates BC-X.12.008 to include `--project <KEY>` (impl form is more actionable; aligns with BC-X.12.006 ambiguous-hint form).

### LOW / NIT

- **L-1 (was H-1)**: `use serde_json;` import — clippy-clean in this codebase; cosmetic only.
- **L-2**: `find_id_by_name` uses `.expect()` on caller invariant — consistent with `cli/queue.rs::resolve_queue_by_name` precedent. Acceptable.
- **L-3**: `tests/queue.rs` and `tests/requesttype_commands.rs` non-JSM tests are near-duplicate scaffolding. Could be DRY'd via helper — not blocking.

### Process-gap findings (codification follow-up)

**PG-1**: No CI rule prevents bare-name `use crate_name;` imports — codebase has 22+ files using `serde_json::json!` correctly without. Convention not documented; file as follow-up. (False positive here — but the convention-doc gap is real.)

**PG-2**: BC drift between BC-X.12.006 and BC-X.12.008 went undetected through 3 prior passes. Need a `check-bc-cross-reference.sh` audit script that flags BCs mandating overlapping verbatim strings. Codify.

**PG-3**: `debug_assert!`-only defense for release-runtime path constructors is a recurring class. CLAUDE.md should document the convention: variable-filename caches MUST use `assert!` for path safety OR a `Result`-returning sanitizer.

## Reviewed surfaces
- All `src/cli/*.rs` files in scope
- `src/api/jsm/servicedesks.rs`, `src/api/jsm/request_types.rs`, `src/api/jsm/requests.rs`, `src/api/jsm/queues.rs`
- `src/cache.rs` (full)
- `src/config.rs`, `src/main.rs`, `src/lib.rs`, `src/output.rs`, `src/partial_match.rs`, `src/types/jsm/*.rs`
- `tests/requesttype_commands.rs` (13), `tests/queue.rs` (12), `tests/project_meta.rs` (3), `src/cache.rs` `#[cfg(test)] mod`
- `Cargo.toml`, `.github/workflows/ci.yml`
- `.factory/code-delivery/issue-288-pr2-cli/story.md`, `.factory/specs/prd/cross-cutting.md`
- CLAUDE.md (worktree)

## Not reviewed (scope guard)
- pr1-api scope (merged PR #379), pr3 OAuth scope (separate PR), pr4-dispatch scope (Wave 3 pending)
- `tests/auth_profiles.rs` regression (AC-012 declared; out of perimeter)
- Mutation testing scope (out per story)
- Cross-cutting BCs beyond X.12 / X.8.004 (perimeter)

## Triage / routing

| Finding | Severity | Route | Action |
|---------|----------|-------|--------|
| H-1 | DOWNGRADED to L-1 | None | False positive; clippy clean |
| M-1 | MEDIUM | product-owner | Update BC-X.12.008 §Stale-cache window: "see current types" → "see all request types" |
| M-2 | MEDIUM | test-writer | Add `test_requesttype_fields_numeric_id_bypasses_list_resolution` |
| M-3 | MEDIUM | DEFER → follow-up issue | release-build defense-in-depth; non-blocking |
| M-4 | MEDIUM | product-owner | Update BC-X.12.008 hint to include `--project <KEY>` flag |
| L-1..L-3 | LOW/NIT | DEFER | Cosmetic |
| PG-1..PG-3 | process-gap | follow-up issues | Codification |

Sequencing for pass 05 prep:
1. product-owner: M-1 + M-4 (BC-X.12.008 alignment to BC-X.12.006 + impl)
2. test-writer: M-2 (numeric-bypass test)
3. orchestrator re-dispatches adversary

Novelty: **MEDIUM** — M-1/M-4 are real spec-intra-document inconsistencies (BC drift between 006 and 008 that prior passes' impl-side hardening locked in without re-anchoring BC 008). M-2 is a coverage gap. H-1 was a false positive.
