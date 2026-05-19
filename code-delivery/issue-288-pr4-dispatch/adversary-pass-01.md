# S-288-pr4-dispatch Adversary Pass 01

## Verdict
FINDINGS — counter remains 0/3.

## Findings

### CRITICAL

**C-01: 401 scope hint NEVER fires for OAuth `InsufficientScope` 401s**
- `src/cli/issue/create.rs:1934-1944` only matches `JrError::NotAuthenticated`
- Atlassian OAuth scope-mismatch produces `JrError::InsufficientScope` (`src/api/client.rs:696-704`)
- `InsufficientScope` `Display` mentions `write:jira-work`, NEVER `write:servicedesk-request`
- Test uses Basic auth (bypasses scope path entirely) so passes spuriously
- **Fix**: implementer extends map_err to match `InsufficientScope` + test-writer adds OAuth-scope test

**C-02: Silent-drop of `--team`, `--points`, `--parent`, `--to`, `--account-id` on JSM path**
- `JsmCreateArgs` (1771-1785) omits 5 platform-only fields silently dropped at dispatch
- No warning, no error — user sees nothing
- BC-3.8.010 pattern (--type warning) should extend to all platform-only flags
- **Fix**: implementer extends warning pattern to cover all 5 flags + test-writer adds 5 warning tests

### HIGH

**H-01: BC-3.8.003 verb drift — impl uses "Run", BC mandates "Use"**
- create.rs:2005 + create.rs:2017 emit "Run"
- BC-3.8.003 spec text mandates "Use"
- Test pins impl wording (locked-in drift, L-288-pr2-02 anti-pattern)
- Sibling drift in cli/requesttype.rs:227 (Wave 2)
- **Fix**: align BC to impl "Run" (Wave 2 pass-02 M-2 precedent) — PO updates BC-3.8.003

**H-02: BC-3.8.002 missing-project hint uses generic platform string**
- Impl emits generic "Project key is required. Use --project or configure .jr.toml..."
- BC-3.8.002 mandates "project is required for JSM request creation"
- No test for the missing-project exit-64 path
- **Fix**: implementer emits BC-mandated string + test-writer adds test

**H-03: BC-3.8.005 missing-summary exit-64 has no test pin**
- Impl 1885-1889 raises the error; no integration test
- **Fix**: test-writer adds `test_jsm_create_missing_summary_exits_64`

**H-04: MatchResult::None (request type not found) has no test pin**
- Impl 2014-2026 emits cache-deletion hint; no test
- **Fix**: test-writer adds `test_jsm_create_request_type_not_found_exits_64`

### MEDIUM

**M-01 (L-288-pr2-02 recurrence)**: `||` accept-either at `tests/issue_create_jsm.rs:1311`
- `stderr.contains("jr auth refresh") || stderr.contains("jr auth login")` — both must appear; split.

**M-02**: BC-3.8.008 cross-source override (`--field summary=X` overrides `--summary X`) no test pin.

**M-03**: AC-014 proptest C.3 doesn't pin `raiseOnBehalfOf` at TOP level (no `!body["requestFieldValues"]["raiseOnBehalfOf"]` negative pin).

**M-04**: `JsmCreateArgs` rustdoc doesn't document intentional exclusion of platform-only flags. Pairs with C-02 root cause.

**M-05**: Stale Red-Gate comments in `src/cli/issue/create.rs:1642,1655,1676,1695,1723,1737-1739` reference Step-2/Step-4 lifecycle that's complete.

**M-06**: `?` operator on `write_request_type_cache` (best-effort writer) at create.rs:1974 — function never returns Err. Misleading; should be `let _ = ...`.

### LOW / NIT
- **L-01**: `expect(...)` on unreachable invariant at create.rs:1828 — defer.
- **L-02**: JSDSERVER-4564 priority caveat not in CLAUDE.md gotcha — defer.
- **L-03**: partial_match sibling test for case-match — defer.

### Process-gap findings
- **PG-01**: No grep-based pre-commit/CI rule for `||` accept-either patterns. L-288-pr2-02 has no enforcement teeth.
- **PG-02**: No unified JSM body-shape snapshot (insta snapshot of `JsmRequestBuilder::build` would freeze shape).
- **PG-03**: Story didn't enumerate cross-flag interaction matrix (which platform flags warn/error/pass-through on JSM path).
- **PG-04**: BC verbatim-phrase enforcement is one-directional — no script scans BC quoted strings for presence in `src/`.

## Reviewed surfaces
- Full read: src/cli/issue/create.rs, src/api/jsm/requests.rs, src/api/jsm/servicedesks.rs, src/api/auth.rs, src/cli/auth/tests/mod.rs, src/cli/mod.rs, src/error.rs, src/api/client.rs (401 dispatch path), src/cache.rs, src/cli/requesttype.rs (sibling), tests/issue_create_jsm.rs
- Specs: bc-3-issue-write.md, story.md
- Configs: .cargo/mutants.toml, CLAUDE.md, CHANGELOG.md

## Not reviewed (scope guard)
- pr1-api / pr2-cli (merged)
- BC-1.3.023, BC-X.3.005 detailed text (out of perimeter for verbatim cross-check this pass)
- ADR-0014
- src/types/jsm/* (pr1 scope)
- Pre-existing platform create.rs semantics (regression baseline)

## Triage / routing

| Finding | Severity | Route | Action |
|---------|----------|-------|--------|
| C-01 | CRITICAL | implementer + test-writer | Extend map_err to InsufficientScope; add OAuth-scope test |
| C-02 | CRITICAL | implementer + test-writer | Extend --type warning to 5 more flags; add 5 warning tests |
| H-01 | HIGH | product-owner | Update BC-3.8.003 verb "Use" → "Run" (Wave 2 precedent) |
| H-02 | HIGH | implementer + test-writer | Emit BC-mandated missing-project string; add test |
| H-03 | HIGH | test-writer | `test_jsm_create_missing_summary_exits_64` |
| H-04 | HIGH | test-writer | `test_jsm_create_request_type_not_found_exits_64` |
| M-01 | MEDIUM | test-writer | Split `||` at line 1311 |
| M-02 | MEDIUM | test-writer | Cross-source override test |
| M-03 | MEDIUM | test-writer | Proptest C.3 negative pin |
| M-04 | MEDIUM | implementer | `JsmCreateArgs` rustdoc — document exclusions |
| M-05 | MEDIUM | implementer | Remove stale Red-Gate comments |
| M-06 | MEDIUM | implementer | `?` → `let _` on best-effort writer |
| L-01..L-03 | LOW | DEFER | Cosmetic |
| PG-01..PG-04 | process-gap | follow-up issues | Codify |

Sequencing for pass 02 prep:
1. PO: H-01 (BC-3.8.003 verb alignment) — parallel
2. implementer: C-01, C-02, H-02, M-04, M-05, M-06 — sequential after PO
3. test-writer: C-01, C-02 (5 tests), H-02, H-03, H-04, M-01, M-02, M-03 — after impl

Novelty: **HIGH** — first pass surfaced 2 CRITICAL functional bugs (C-01 401 wrong-branch + C-02 silent-drop) the test suite couldn't catch. Wave 2 cycle had 30+ findings in 8 rounds; pass 01 yield is consistent.
