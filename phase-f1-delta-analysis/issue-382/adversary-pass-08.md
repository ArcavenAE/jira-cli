# Issue #382 F1d Adversary Pass 08

## Verdict
**CLEAN — counter advances to 3/3. F1d CONVERGED.**

No CRITICAL or IMPORTANT findings. Ten LOW observations, all confirmatory or cosmetic.

## Independent Fact Verification (all TRUE)

| Claim | Evidence |
|---|---|
| `src/error.rs:75` exit_code wildcard arm | confirmed |
| `src/error.rs:131,171` test construction sites | confirmed |
| `src/api/client.rs:700,969` prod construction sites | confirmed |
| `src/cli/issue/create.rs:1982,1983` M-2 + C-3 | confirmed verbatim |
| `tests/api_client.rs:136` assertion | confirmed |
| Existing #[error] contains `(while PUT/GET succeed)` | confirmed verbatim |
| BC-1.6.042 Empty-Some policy at line 474 | confirmed |
| Cargo.toml: thiserror "2", edition 2024, MSRV 1.85 | confirmed |
| JrError lacks #[non_exhaustive] | confirmed |

All factual anchors resolve correctly against live codebase.

## HARD Checks (all PASS)

1. AC-7 sufficiency: implementer can apply destructure fix verbatim from spec
2. Design template: shows FULL `#[error(...)]` block including parenthetical
3. Test naming convention: both new tests use `test_` prefix per CLAUDE.md
4. Cargo.toml pins (thiserror v2, edition 2024, MSRV 1.85): covers all design needs; `.filter()` stable since 1.27, `as_deref` since 1.40
5. Impact-boundary line 21 (M-2) explicitly cites `required_scope` field name
6. Exit code 2 preserved via wildcard match at error.rs:75 (unchanged by additive field)

## Observations (LOW, non-blocking)

- **O-1**: AC-7 description sufficient; implementer can apply verbatim
- **O-2**: Design template complete; full #[error] block shown
- **O-3**: Test naming convention applied consistently
- **O-4**: thiserror/cargo/edition pins covered by Cargo.toml; no actionable gap
- **O-5**: Variant signature `required_scope: Option<String>` consistent across artifacts
- **O-6**: Exit code 2 preserved by wildcard
- **O-7** [pending intent verification]: `affected-artifacts.md` Section 6 uses `scope_hint` (the expression-arg alias) in 4 narrative places vs `required_scope` (actual field name) used elsewhere. Authoritative artifacts (design template + AC-1 + BC body) consistent on `required_scope`. Not blocking.
- **O-8**: No `#[non_exhaustive]` on JrError; external code must match exhaustively. Only M-2 consumer site; AC-7 covers. No external breakage risk.
- **O-9**: Construction-site enumeration exhaustive (3 prod + 2 test verified via grep)
- **O-10**: T-N labeling internally consistent post pass-05 harmonization

## Novelty Assessment
**VERY LOW** — Only O-7 (naming cosmetic) is genuinely novel from fresh-context. All others are confirmations.

The F1d artifact set has converged:
- One BC modified (BC-1.6.042) + Empty-Some policy
- Seven explicit ACs covering signature, template, two tests, regression, all production sites, destructure compile-fix
- Verbatim thiserror template paste-ready
- Exact line numbers for all 5 construction call sites
- 10 test sites in risk zone enumerated with explicit Needs-Update verdicts
- 8 docs/index surfaces verified-unchanged
- Empty-Some defensive policy with pinning test (AC-4)

**An F4 TDD implementer can begin work without ambiguity.**

## Verdict
**CLEAN. Counter advances to 3/3. F1d CONVERGED. Ready for F4.**
