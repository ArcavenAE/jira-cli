# S-288-pr2-cli Adversary Pass 07

## Verdict
FINDINGS — clean-pass counter remains 0/3.

## Findings

### CRITICAL
None.

### HIGH
None.

### MEDIUM

**M-1: AC-011 negative-path is unanchored — no test exercises "no project configured" error**
- Story AC-011 (`story.md:171-176`) explicitly states BOTH the positive path AND the negative path: "When no `--project` flag is given but the active profile has a project configured, ... uses the profile project. **When neither flag nor profile project is configured, exits 64 with actionable message.**"
- Pinned test `test_requesttype_list_uses_profile_project_when_no_flag` covers only the positive path.
- Impl (`src/cli/requesttype.rs:27-33`) has the error: `"No project configured. Run \"jr init\" or pass --project. Run \"jr project list\" to see available projects."` — but no test asserts it.
- Grep for `"No project configured"` across `tests/` returns 0 hits.
- **Fix**: add `test_requesttype_list_errors_when_no_project_flag_or_profile_project` — write config without `[profiles.default].project`, invoke `jr requesttype list --no-input` (no `--project`), assert exit 64 + `"No project configured"` + `"Run \"jr init\" or pass --project"`. No HTTP mocks needed (error fires pre-network).

**M-2: L-288-pr1-01 violation — accept-either `||` in numeric-bypass test**
- `tests/requesttype_commands.rs:1403-1406`:
  ```rust
  assert!(
      stdout.contains("What do you need?") || stdout.contains("Nominee"),
      "..."
  );
  ```
- Fixture emits BOTH names; impl iterates `fields_response.request_type_fields.iter().map(...)` so both should always appear. A regression dropping one row would still pass via the OR.
- The same test file at line 1060 explicitly invokes this policy: *"Pinned strictly — no .or_else() escape hatch."* Inconsistency, not deliberate.
- **Fix**: split into two separate asserts (mirroring AC-005 YES/NO pattern at lines 605-615).

### LOW / NIT

**L-bonus (orchestrator-added): line 590 negative pin uses wrong substring**
- `tests/requesttype_commands.rs:590`: `!stdout.contains("\nsummary")`.
- comfy-table renders rows with `│` borders → field_id leakage would appear as `│ summary` not `\nsummary`. Pin matches nothing it claims to guard.
- Compensated by positive pin (`stdout.contains("What do you need")`), so no test-failure risk.
- **Fix**: change to `!stdout.contains("│ summary")` (matches the actual border-rendered prefix).

**L-1**: `RequestType::Default` debug_assert empty-string vacuous-true (latent risk; rustdoc warns; defer).
**L-2**: parameter naming inconsistency `call_site_label` vs `context_label` across story prose (cosmetic; impl correct; defer).
**L-3**: BC-X.12.007 says "Field" while BC-X.12.005 says "Field Name" (terminology drift in spec; impl matches 005; defer to spec cleanup).

### Process-gap findings
None this pass — content-level issues.

## Reviewed surfaces
- Full src/, tests/, spec/story, CLAUDE.md
- Cross-checked: src/cli/issue/ (no pr4 creep), src/api/jsm/requests.rs (untouched)

## Not reviewed (scope guard)
- pr1-api source (assumed converged via PR #379)
- pr4-dispatch, pr3 OAuth (out of scope)
- ADR-0014 details
- holdout-scenarios.md (catalog-level)
- tests/auth_profiles.rs (per AC-012 must remain green without modification)

## Triage / routing

| Finding | Severity | Route | Action |
|---------|----------|-------|--------|
| M-1 | MEDIUM | test-writer | Add AC-011 negative-path test |
| M-2 | MEDIUM | test-writer | Split `||` into two asserts |
| L-bonus | LOW | test-writer | Fix `\nsummary` → `│ summary` negative pin |
| L-1..L-3 | LOW | DEFER | Cosmetic / latent |

Sequencing:
1. test-writer: M-1 + M-2 + L-bonus (single dispatch)
2. orchestrator re-dispatches adversary

Novelty: **MEDIUM** — M-1 is a genuine AC coverage gap missed by 6 prior passes; M-2 is L-288-pr1-01 recurrence in an adjacent test (passes hardened most but not all). Real defects, small fixes.
