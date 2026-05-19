# Issue #382 F1d Adversary Pass 07

## Verdict
**CLEAN — counter advances to 2/3**

Prior CLEAN declaration upheld under fresh-context scrutiny.

## Construction-Site & Line-Number Verification (all EXACT)

| Claim | Live source | Status |
|---|---|---|
| `src/api/client.rs:700` (C-1) | `return Err(JrError::InsufficientScope {` | EXACT |
| `src/api/client.rs:969` (C-2) | `return JrError::InsufficientScope { message }.into();` | EXACT |
| `src/cli/issue/create.rs:1983` (C-3) | `anyhow::anyhow!(JrError::InsufficientScope {` | EXACT |
| `src/cli/issue/create.rs:1982` (M-2) | `Ok(JrError::InsufficientScope { message }) => {` | EXACT |
| `src/error.rs:75` (M-1 wildcard) | `JrError::InsufficientScope { .. } => 2,` | EXACT |
| `src/error.rs:131` (T-1b) | `JrError::InsufficientScope {` | EXACT |
| `src/error.rs:171` (T-1) | `let err = JrError::InsufficientScope {` | EXACT |
| `tests/api_client.rs:136` (T-2 assertion) | `s.contains("write:jira-work"),` | EXACT |
| BC-1.6.042 location at `bc-1-auth-identity.md:467` | confirmed | EXACT |

## Rust Semantics Verification — `.filter(|s| !s.is_empty())` on `Option<&str>`

Verified compiles and behaves as specified:
- `None` → fallback to `"write:jira-work"` ✓
- `Some("")` → filter returns None → fallback ✓
- `Some("write:servicedesk-request")` → renders verbatim ✓

Empty-Some policy correctly implemented. AC-4 testable as designed.

## Findings
None.

## Observations (LOW, non-blocking)

- **O-01**: BC-1.6.042 says callers MUST pass non-empty ASCII scope names, but `.filter(|s| !s.is_empty())` only filters empty — not non-ASCII. No in-scope caller violates (all 3 callers pass static ASCII literals). Documentation contract, not enforced invariant.
- **O-02**: Edge-case input variants (newlines, quotes, very long) — no in-scope caller can supply. Theoretical for #382.
- **O-03**: C-01 integration test comment references `src/api/client.rs:696-704` line range that will drift after refactor. Doc comment, not load-bearing.
- **O-04**: BC-1.6.042 Source `tests/api_client.rs:99-144` is 1-line off (function `async fn` at line 100). Pre-existing, not introduced by #382.
- **O-05**: JSM scope name renders twice in Display (C-3 enrichment + scope_hint). Already documented and accepted in "Known Cosmetic" subsection.
- **O-06**: Test C-01 substring assertion `jr auth login` robust to refactor (substring within `jr auth login --oauth`).

## Self-Validation Loop (3 iterations)

1. Initial pass identified 3 potential edge cases (non-ASCII, newline, very-long). All re-categorized as LOW Observations (caller-contract documentation, not impl enforcement).
2. Re-checked all line numbers, BC citations, holdout ranges. Matched or near-exact with documented pre-existing off-by-ones.
3. Verified `.filter(|s| !s.is_empty())` Rust semantics independently. Compiles and behaves correctly in all 3 branches.

## L-288-pr2-02 Compliance
2 references in `tests/issue_create_jsm.rs` (lines 1366, 1570). C-01 test uses 3 separate strict `assert!` calls. AC-3 specified as two-part assertion. COMPLIANT.

## Cross-Artifact Consistency (S-7.01)
All 4 sibling artifacts agree on: 3 prod sites, 2 test sites, T-2 UNCHANGED, AC-7 destructure fix, 8 doc surfaces, AC-1..AC-7 (AC-3 two-part, AC-4 Empty-Some), BC-1.6.047 WITHDRAWN, BC-1.6.042 parameterized in-place, Empty-Some policy, byte-for-byte preserved template. NO DRIFT.

## Spec-Implementation Gap Probe
All 5 BC-1.6.042 postcondition substrings testable and produced by proposed thiserror template. AC-3, AC-4, AC-5 collectively pin all 3 branches (Some/non-empty, Some/empty, None). Exit code 2 pinned by existing wildcard arm.

## Novelty Assessment
**VERY LOW** — only LOW Observations (cosmetic). Prior CLEAN upheld.

## Verdict
**CLEAN — counter advances to 2/3.**
