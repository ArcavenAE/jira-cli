---
document_type: delta-analysis-report
feature_name: "JrError::InsufficientScope Display refactor"
issue: 382
created: 2026-05-19
spec_version_at_analysis: "N/A"
status: draft
intent: "enhancement"
feature_type: "backend"
scope: "standard"
severity: "N/A"
sources:
  - impact-boundary.md (architect, F1-Step-3)
  - affected-artifacts.md (business-analyst, F1-Step-4)
  - design-validation.md (research-agent, pre-F2 gate per L-288-pr4-06)
---

# Delta Analysis Report: JrError::InsufficientScope Display Refactor

## Feature Request

- **Issue:** [#382 — JrError::InsufficientScope Display refactor](https://github.com/Zious11/jira-cli/issues/382)
- **Context:** Deferred from PR #381 / issue #288 (JSM request-type support)
- **Date:** 2026-05-19

`JrError::InsufficientScope` Display contains a hardcoded `"write:jira-work"` literal. After PR #381 added JSM support requiring `write:servicedesk-request`, the generic error message is stale: it names `write:jira-work` as the only scope workaround regardless of which command failed. This refactor makes the scope reference structured and dynamic.

---

## Classifications

### Intent Classification

**Classified intent:** `enhancement`

**Rationale:** The code path functions correctly today — the 401 scope-mismatch error is caught and surfaced. The message content is contextually inaccurate for JSM calls, not broken. No wrong behavior, only stale Display text. Signals: "refactor", "stale text", "hardcoded" — characteristic of an enhancement, not a bug-fix.

### Feature Type Classification

**Classified type:** `backend`

**Rationale:** No CLI surface changes (flags, subcommands). No UX changes beyond error message text in stderr. No external API contract changes. No new external dependencies. All changes confined to `src/error.rs`, `src/api/client.rs`, `src/cli/issue/create.rs`, and their corresponding test files.

### Trivial Scope Classification

**Classified scope:** `STANDARD`

**Rationale:** Fails the single-file impact-boundary check. The change touches a shared error type (`src/error.rs`) with Display assertions across multiple test files at multiple layers (unit, integration, holdout). Requires: (1) structural modification to `JrError::InsufficientScope` adding a second field, (2) updating three construction call-sites, (3) updating one unit test construction call, (4) modifying BC-1.6.042, and (5) verifying H-012 and H-NEW-JSM-RT-003 holdout scenarios. Full F1-F7 is appropriate. Regression risk is LOW-MEDIUM (Rust exhaustive-match catches missed construction sites at compile time, but the test surface is wide).

### Severity Classification

**Classified severity:** `N/A` (enhancement, not bug-fix)

---

## Impact Assessment

### Component Impact Table

| Component | Change Type | Notes |
|-----------|-------------|-------|
| `src/error.rs` | MODIFIED | `InsufficientScope` variant gains `required_scope: Option<String>` field; `#[error]` uses expression-argument form per validation Q-1 |
| `src/api/client.rs` | MODIFIED | 2 construction sites (lines 700, 969) gain `required_scope: None` (back-compat fallback; preserves `"write:jira-work"` Display text for platform-write path) |
| `src/cli/issue/create.rs` | MODIFIED | 1 construction site (line 1983) gains `required_scope: Some("write:servicedesk-request".to_string())` |
| `src/error.rs` unit test T-1 (line 170) | MODIFIED | Construction call updated to add `required_scope: None`; assertion text UNCHANGED (fallback renders historical literal) |
| `tests/api_client.rs` T-2 (line 100) | UNCHANGED | Falls back to historical literal via `None` branch; assertion passes unmodified |
| `BC-1.6.042` | MODIFY | Change "literal substring `write:jira-work`" requirement to "resolved scope name from construction site" |
| `BC-1.6.047` (new candidate) | DEFER to F2 | May fold into BC-1.6.042 modification rather than adding a separate BC |

### Validation Refinements (from design-validation.md)

Three refinements established by the research-agent validation gate (L-288-pr4-06) before F2 proceeds:

**Refinement 1 — thiserror idiom (Q-1):** Use the expression-argument form, NOT naive Option interpolation. Naive `{required_scope:?}` renders `Some("x")` / `None` literals to end-users. Correct template:

```rust
#[error(
    "Insufficient token scope: {message}\n\n\
     The Atlassian API gateway rejects granular-scoped personal tokens on POST \
     requests. Workarounds:\n  \
     • Use a classic token with \"{scope_hint}\" scope instead of granular scopes, or\n  \
     • Try OAuth 2.0 (run \"jr auth login --oauth\") — may avoid this bug, not verified\n\n\
     See https://github.com/Zious11/jira-cli/issues/185 for details.",
    scope_hint = required_scope.as_deref().unwrap_or("write:jira-work")
)]
InsufficientScope {
    message: String,
    required_scope: Option<String>,
},
```

In-project precedent: `JrError::NotAuthenticated { hint: String }` (same structured-hint-field pattern). External precedent: gh CLI #9117 desired-pattern (runtime-resolved scope name + actionable recovery command).

**Refinement 2 — scope-name lookup table (Q-2):** Per-construction-site values confirmed against Atlassian OAuth scopes docs:

| Construction Site | File | Line | `required_scope` Value |
|-------------------|------|------|------------------------|
| C-1: blanket-401 early-exit | `src/api/client.rs` | 700 | `None` |
| C-2: `parse_error()` helper | `src/api/client.rs` | 969 | `None` |
| C-3: JSM re-wrap | `src/cli/issue/create.rs` | 1983 | `Some("write:servicedesk-request".to_string())` |

`None` at C-1 and C-2 is correct: these are endpoint-agnostic paths; conservative fallback to `"write:jira-work"` is the right behavior and preserves test pins T-1 and T-2.

**Refinement 3 — narrowed test-change scope (Q-5):** The architect's F1 impact-boundary entry for T-2 (`tests/api_client.rs:100`) overstates the required change. Under the `None`→`"write:jira-work"` fallback design, T-2 passes unmodified. Only T-1 needs a construction-call update (one field added). A new unit test must be added per issue AC-3 to pin the `Some` branch.

---

## Files Changed

### New Files

| File Path | Purpose |
|-----------|---------|
| _(none required)_ | All changes are in-place modifications |
| New unit test (inline in `src/error.rs`) | `test_insufficient_scope_display_uses_required_scope_when_some` — pins the `Some("write:servicedesk-request")` Display branch per issue AC-3 |

### Modified Files

| File Path | Change Type | Risk |
|-----------|-------------|------|
| `src/error.rs` | Variant struct-widening + `#[error]` template update + T-1 construction call update | LOW (compile-time exhaustive-match catches all missed sites) |
| `src/api/client.rs` | Two construction sites add `required_scope: None` | LOW (additive back-compat field) |
| `src/cli/issue/create.rs` | One construction site adds `required_scope: Some("write:servicedesk-request".to_string())` | LOW |
| `.factory/specs/prd/bc-1-auth-identity.md` | BC-1.6.042 modified; BC-1.6.047 decision made in F2 | LOW |

### Dependent Files (unchanged; depend on modified files)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `tests/api_client.rs` | `src/error.rs` (via Display output match) | LOW — T-2 passes unmodified; T-7, T-8, T-9 are negation/non-literal tests |
| `tests/oauth_flow_holdouts.rs` | `src/error.rs` (dispatch, not Display literal) | LOW — T-3/T-4/T-5 pin `"Insufficient token scope"` prefix only, no `write:jira-work` pin |
| `tests/issue_create_jsm.rs` | `src/cli/issue/create.rs` (call-site enriched message) | LOW — T-6 pins `write:servicedesk-request` injected at C-3; still passes with `Some(...)` |
| `src/lib.rs` | `src/error.rs` (re-export) | NONE — no import path changes |

---

## Files NOT Changed (Regression Baseline)

These files must not be modified during implementation. All their tests must continue to pass.

- `src/api/auth.rs` — `DEFAULT_OAUTH_SCOPES` constant is not changing; scope list is unaffected
- `src/cli/auth/` (all files) — auth flow not changing
- `src/cli/issue/list.rs`, `view.rs`, `workflow.rs` — unrelated command handlers
- `src/cli/assets.rs`, `board.rs`, `sprint.rs`, `worklog.rs` — unrelated
- `src/cache.rs`, `src/config.rs`, `src/jql.rs`, `src/adf.rs`, `src/duration.rs` — unrelated
- `tests/oauth_flow_holdouts.rs` — dispatch assertions only; no Display literal pins that would break
- `tests/issue_create_jsm.rs` — satisfied by call-site injection at C-3; no change needed
- `tests/bulk_*.rs`, `tests/search_*.rs`, `tests/migration_*.rs` — unrelated
- `.factory/specs/prd/bc-3-issue-write.md` — BC-3.8.009 satisfied at call-site; no modification needed
- `.factory/specs/prd/cross-cutting.md` — BC-X.3.005 dispatch logic unchanged
- `src/error.rs:129-136` (exit_code test) — wildcard `JrError::InsufficientScope { .. } => 2` arm; no change

---

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | LOW | `None` fallback preserves all existing Display text for platform-write 401 paths. Only T-1 unit test needs a construction-call update (adding a field). T-2 (integration test) passes unmodified. Rust exhaustive match catches missed construction sites at compile time. |
| Architecture | ZERO | `error.rs` is pure-core (no I/O, no side effects). No module boundaries change. No new dependencies. Variant field widening with back-compat `None` path. |
| Security | ZERO | No auth flow change. No secret handling. No trust boundary change. The scope name in Display is a user-facing hint, not a token or credential. |
| Performance | ZERO | `Option<String>` allocation only on `InsufficientScope` error paths (cold path; no performance impact). |

---

## Regression Baseline

- **Tests in regression risk zone (asserting on InsufficientScope Display or dispatch):** 9 total (T-1 through T-9)
- **Tests requiring source change:** 1 (T-1 — construction-call update only; assertion unchanged)
- **Tests unaffected despite Display change:** 8 (T-2 through T-9 — all pass via `None` fallback or pin non-literal assertions)
- **Risk zone test files:** `src/error.rs` (inline), `tests/api_client.rs`, `tests/oauth_flow_holdouts.rs`, `tests/issue_create_jsm.rs`

---

## Scope Recommendation

- **Mode:** Feature Mode / Full F1-F7 (STANDARD scope)
- **F2:** Modify BC-1.6.042; decide on BC-1.6.047 (fold vs new). Spec version: PATCH bump.
- **F3:** ONE story, ~2 story points. File: `S-X.YY-error-scope-refactor.md`.
- **F4:** Per-story delivery (worktree → stubs → failing tests → TDD → adversary 3/3 → demos LOCAL ONLY → push → pr-manager 9-step).
- **F5/F6/F7:** Single-story scope — per-story adversarial review likely sufficient; F6 mutation testing in PR-scope CI.
- **Can parallelize:** No — single story, single author.

---

## Open Questions for Human Approval

a. **Approve STANDARD scope?** (vs trivial route — the back-compat `Option` design may qualify as additive-only if F2 adversary confirms no literal replacement is required, but the business-analyst classified STANDARD based on test breadth)

b. **Approve Option (a) structured-field design with thiserror expression-argument idiom?** (expression-arg form `scope_hint = required_scope.as_deref().unwrap_or("write:jira-work")`, NOT naive `{required_scope:?}`)

c. **Approve scope-name lookup table?** (`None` for C-1 and C-2 platform-write paths; `Some("write:servicedesk-request")` for C-3 JSM path)

d. **Any other endpoints to surface `Some(...)` for now?** (Other write endpoints — `PUT /rest/api/3/issue/{key}` edit, `POST /rest/api/3/issue/{key}/transitions`, `POST /rest/api/3/issue/{key}/comment` — currently route through C-1/C-2 with `None`/`write:jira-work` fallback. Should any of these get explicit `Some("write:jira-work")` instead of relying on fallback, for clarity? Or defer to a future pass?)
