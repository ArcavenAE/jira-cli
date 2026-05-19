---
document_type: delta-analysis-report
feature_name: "JrError::InsufficientScope Display refactor"
issue: 382
created: 2026-05-19
spec_version_at_analysis: "N/A"
status: approved
intent: "enhancement"
feature_type: "backend"
scope: "standard"
severity: "N/A"
sources:
  - impact-boundary.md (architect, F1-Step-3; revised F1d adversary-pass-01 F-01 + F-03)
  - affected-artifacts.md (business-analyst, F1-Step-4; revised F1d adversary-pass-01 F-02 + F-04 + F-06 + F-07)
  - design-validation.md (research-agent, pre-F2 gate; revised F1d adversary-pass-01 F-01 + F-05)
  - po-decision-bc-parameterization.md (product-owner, F1d adversary-pass-01 F-02)
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

**Status: APPROVED by human.**

### Feature Type Classification

**Classified type:** `backend`

**Rationale:** No CLI surface changes (flags, subcommands). No UX changes beyond error message text in stderr. No external API contract changes. No new external dependencies. All changes confined to `src/error.rs`, `src/api/client.rs`, `src/cli/issue/create.rs`, and their corresponding test files.

**Status: APPROVED by human.**

### Trivial Scope Classification

**Classified scope:** `STANDARD`

**Rationale:** Fails the single-file impact-boundary check. The change touches a shared error type (`src/error.rs`) with Display assertions across multiple test files at multiple layers (unit, integration, holdout). Requires: (1) structural modification to `JrError::InsufficientScope` adding a second field, (2) updating two construction call-sites in `src/error.rs` tests and one in `src/api/client.rs`/`src/cli/issue/create.rs`, (3) modifying BC-1.6.042 in-place, and (4) verifying H-012 and H-NEW-JSM-RT-003 holdout scenarios. Full F1-F7 is appropriate. Regression risk is LOW-MEDIUM (Rust exhaustive-match catches missed construction sites at compile time, but the test surface is wide).

**Status: APPROVED by human.**

### Severity Classification

**Classified severity:** `N/A` (enhancement, not bug-fix)

---

## BC Decision

**BC-1.6.042:** Parameterized in-place under option (a) — PO decision (adversary-pass-01 F-02). See `po-decision-bc-parameterization.md`.

- Behavior line updated to replace the hardcoded `write:jira-work` assertion with a runtime-parameterized-field contract: `None` falls back to `write:jira-work` (preserves all existing test pins); `Some("write:servicedesk-request")` for the JSM path.
- BC count is stable (57 cumulative in bc-1). BC-INDEX title, row, and Source cell are unchanged. CANONICAL-COUNTS.md is unchanged.
- BC-1.6.047 candidate **withdrawn** — both paths are instantiations of one parameterized behavior; splitting overstates the distinction and inflates BC count with no analytical gain.

---

## Impact Assessment

### Component Impact Table

| Component | Change Type | Notes |
|-----------|-------------|-------|
| `src/error.rs` | MODIFIED | `InsufficientScope` variant gains `required_scope: Option<String>` field; `#[error]` uses expression-argument form per validation Q-1 |
| `src/api/client.rs` | MODIFIED | 2 construction sites (lines 700, 969) gain `required_scope: None` (back-compat fallback; preserves `"write:jira-work"` Display text for platform-write path) |
| `src/cli/issue/create.rs` | MODIFIED | 1 construction site (line 1983) gains `required_scope: Some("write:servicedesk-request".to_string())` |
| `src/error.rs` unit test T-1b (line 131) | MODIFIED | `insufficient_scope_exit_code`: construction call updated to add `required_scope: None`; assertion (exit code 2) unchanged |
| `src/error.rs` unit test T-1 (line 171) | MODIFIED | `insufficient_scope_display_includes_workarounds`: construction call updated to add `required_scope: None`; assertion text UNCHANGED (fallback renders historical `write:jira-work` literal) |
| `tests/api_client.rs` T-2 (line 100) | UNCHANGED | Falls back to historical literal via `None` branch at C-2; assertion passes unmodified |
| `BC-1.6.042` | MODIFY (option-a, in-place) | Behavior line parameterized; no new BC added; no BC-INDEX or CANONICAL-COUNTS change |
| `BC-1.6.047` (candidate) | WITHDRAWN | PO decision: not needed |

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

**Refinement 2 — scope-name lookup table (Q-2):** Per-construction-site values confirmed against Atlassian OAuth scopes docs. Note: `parse_error()` in `client.rs:969` has access to `response.url().path()` but we do NOT thread endpoint inference here — path-based mapping is fragile and maintenance-heavy. `None`-fallback preserves existing behavior cheaply. Additional endpoints deferred.

| Construction Site | File | Line | `required_scope` Value |
|-------------------|------|------|------------------------|
| C-1: blanket-401 early-exit | `src/api/client.rs` | 700 | `None` |
| C-2: `parse_error()` helper | `src/api/client.rs` | 969 | `None` |
| C-3: JSM re-wrap | `src/cli/issue/create.rs` | 1983 | `Some("write:servicedesk-request".to_string())` |

`None` at C-1 and C-2 is correct: these are endpoint-agnostic paths; conservative fallback to `"write:jira-work"` is the right behavior and preserves test pins T-1 and T-2.

**Refinement 3 — narrowed test-change scope (Q-5):** Two test construction-call updates needed in `src/error.rs` (lines 131 + 171), NOT three. The architect's F1 impact-boundary entry for `tests/api_client.rs:100` (T-2) overstates the required change. Under the `None`→`"write:jira-work"` fallback design, T-2 passes unmodified. A new unit test must be added per issue AC-3 to pin the `Some` branch.

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
| `src/error.rs` | Variant struct-widening + `#[error]` template update + 2 construction call updates (T-1 at line 171 + T-1b at line 131) | LOW (compile-time exhaustive-match catches all missed sites) |
| `src/api/client.rs` | Two construction sites add `required_scope: None` | LOW (additive back-compat field) |
| `src/cli/issue/create.rs` | One construction site adds `required_scope: Some("write:servicedesk-request".to_string())` | LOW |
| `.factory/specs/prd/bc-1-auth-identity.md` | BC-1.6.042 Behavior line parameterized in-place (option a; see `po-decision-bc-parameterization.md`) | LOW |

### Dependent Files (unchanged; depend on modified files)

| File Path | Depends On | Regression Risk |
|-----------|-----------|----------------|
| `tests/api_client.rs` | `src/error.rs` (via Display output match) | LOW — T-2 passes unmodified (None-fallback); T-7, T-8, T-9 are negation/non-literal tests |
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

### Docs/Index Surfaces Verified Unchanged

These spec and doc files reference `InsufficientScope` behavior or BC-1.6.042. They require no edits under option (a) parameterization but must be verified after implementation confirms accuracy.

| File | Reference | Why Unchanged | Verify Action |
|------|-----------|---------------|---------------|
| `CLAUDE.md` (Gotchas section) | No test-seam env-var or hidden behavior introduced | No new `JR_*` env-var; no architectural edge case; no dispatch behavior change | Confirm no `JR_*` or behavioral gotcha introduced during F4 |
| `.factory/specs/prd/BC-INDEX.md` (line 122) | Source cell cites `tests/api_client.rs:99-144` | BC count stable (57); BC-1.6.042 ID and title unchanged; T-2 passes unmodified via None-fallback | Confirm `tests/api_client.rs:99-144` citation still resolves correctly post-F4 |
| `.factory/specs/prd/CANONICAL-COUNTS.md` | BC cumulative count (57 in bc-1) | No new BC added; BC-1.6.047 candidate withdrawn | Confirm count unchanged post-F4 |
| `.factory/specs/prd/edge-case-catalog.md` (line 78) | `Covered by BC-1.6.042; holdout H-012` | BC-1.6.042 still covers this edge case under parameterization | Confirm edge-case description aligns with updated BC-1.6.042 Behavior line |
| `.factory/specs/prd/holdout-scenarios.md` (lines 138–145, H-012) | `write:jira-work` substring assertion | None-fallback preserves `write:jira-work` in Display; H-012 passes unmodified | Run H-012 in validation; confirm `write:jira-work` present in None-path Display |
| `.factory/specs/prd/holdout-scenarios.md` (lines 658–682, H-NEW-JSM-RT-003) | `write:servicedesk-request` in stderr | Satisfied by call-site injection at C-3; `Some("write:servicedesk-request")` reinforces this | Run H-NEW-JSM-RT-003; confirm `write:servicedesk-request` present |

---

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | LOW | `None` fallback preserves all existing Display text for platform-write 401 paths. Only T-1 and T-1b unit tests need construction-call updates (adding a field, assertions unchanged). T-2 (integration test) passes unmodified. Rust exhaustive match catches missed construction sites at compile time. |
| Architecture | ZERO | `error.rs` is pure-core (no I/O, no side effects). No module boundaries change. No new dependencies. Variant field widening with back-compat `None` path. |
| Security | ZERO | No auth flow change. No secret handling. No trust boundary change. The scope name in Display is a user-facing hint, not a token or credential. |
| Performance | ZERO | `Option<String>` allocation only on `InsufficientScope` error paths (cold path; no performance impact). |

---

## Regression Baseline

- **Tests in regression risk zone (asserting on InsufficientScope Display or dispatch):** 10 total (T-1, T-1b, T-2 through T-9)
- **Tests requiring source change:** 2 (T-1b at `src/error.rs:131` + T-1 at `src/error.rs:171` — construction-call update only; assertions unchanged)
- **Tests unaffected despite Display change:** 8 (T-2 through T-9 — all pass via `None` fallback or pin non-literal assertions)
- **New test required:** 1 (per issue AC-3 — `test_insufficient_scope_display_uses_required_scope_when_some` pins the `Some` Display branch)
- **Risk zone test files:** `src/error.rs` (inline), `tests/api_client.rs`, `tests/oauth_flow_holdouts.rs`, `tests/issue_create_jsm.rs`

---

## Scope Recommendation

- **Mode:** Feature Mode / Full F1-F7 (STANDARD scope)
- **F2:** Modify BC-1.6.042 in-place (option a; already done by PO); no new BC. Spec version: PATCH bump.
- **F3:** ONE story, ~2 story points. File: `S-X.YY-error-scope-refactor.md`.
- **F4:** Per-story delivery (worktree → stubs → failing tests → TDD → adversary 3/3 → demos LOCAL ONLY → push → pr-manager 9-step).
- **F5/F6/F7:** Single-story scope — per-story adversarial review likely sufficient; F6 mutation testing in PR-scope CI.
- **Can parallelize:** No — single story, single author.

---

## Open Questions

All questions resolved. Status recorded below.

**Q-1: Approve STANDARD scope?**
**Decision: APPROVED by human.** The back-compat `Option` design has a wide test surface; STANDARD classification is correct regardless of the additive-only nature of the field.

**Q-2: Approve Option (a) structured-field design with thiserror expression-argument idiom?**
**Decision: APPROVED by human.** Expression-arg form `scope_hint = required_scope.as_deref().unwrap_or("write:jira-work")`, NOT naive `{required_scope:?}`. Cite `NotAuthenticated { hint: String }` as in-project precedent.

**Q-3: Approve scope-name lookup table?**
**Decision: APPROVED by human.** `None` for C-1 and C-2 platform-write paths; `Some("write:servicedesk-request")` for C-3 JSM path. Confirmed against Atlassian OAuth scopes docs (classic scope names).

**Q-4: Any other endpoints to surface `Some(...)` for now?**
**Decision: Minimal (3 sites only). Additional endpoints deferred to incremental PRs.** `parse_error()` has access to `response.url().path()` but path-based endpoint inference is fragile and maintenance-heavy. The `None`-fallback preserves existing behavior cheaply. If a fourth scope surface (e.g., Confluence write) arises, the same per-construction-site re-wrap pattern (match arm on `JrError::InsufficientScope`) can be applied without modifying the central client. No further scope expansion for #382.

---

## Change Log

- [REVISED 2026-05-19 per F1d adversary-pass-01 — all 7 findings addressed]
  - F-01 (architect): `src/error.rs:131` added as 2nd test construction site. Regression baseline updated to 2 test construction-call updates needed (lines 131 + 171), not 1. Risk Assessment row updated to reflect corrected count.
  - F-02 (PO): BC-1.6.042 decision finalized as option (a) parameterize in-place. BC-1.6.047 candidate withdrawn. BC-INDEX and CANONICAL-COUNTS confirmed unchanged. Component Impact Table updated. `po-decision-bc-parameterization.md` added as source.
  - F-03 (architect): "Docs/Index Surfaces Verified Unchanged" subsection added to "Files NOT Changed" — enumerates `CLAUDE.md`, `BC-INDEX.md`, `CANONICAL-COUNTS.md`, `edge-case-catalog.md:78`, `holdout-scenarios.md:138-145` (H-012), `holdout-scenarios.md:658-682` (H-NEW-JSM-RT-003).
  - F-04 (business-analyst): `edge-case-catalog.md:78` added to "Docs/Index Surfaces Verified Unchanged" table with verify action.
  - F-05 (research-agent): design-validation.md Refinement 3 updated to cite 2 test construction sites; Q-2 rephrased to be accurate about `parse_error()` endpoint-access capability vs. deferral decision.
  - F-06 (business-analyst): `BC-INDEX.md:122` Source cell added to "Docs/Index Surfaces Verified Unchanged" — Source citation remains accurate under option (a).
  - F-07 (business-analyst): `CLAUDE.md` Gotchas section added to "Docs/Index Surfaces Verified Unchanged" — no new test-seam env-var or hidden behavior introduced.
  - Open Questions: Q-1, Q-2, Q-3 marked APPROVED by human. Q-4 collapsed to "Minimal (3 sites only); additional endpoints deferred to incremental PRs."
