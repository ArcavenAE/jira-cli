# Check 1 — Formal Verification (Kani)

VERDICT: JUSTIFIED SKIP (no Kani infra; new pure invariants are total-by-construction + property/unit covered)

## Infra
- No Kani harness infrastructure in the repo (confirmed: no `kani` in Cargo.toml, no `#[kani::proof]`, no `Cargo.toml` kani deps). Repo's proof stack is proptest/insta/cargo-mutants.

## New pure invariants in the delta and their coverage

### classify_401_body(message: &str, hint: &str) -> JrError  (src/api/client.rs)
Body:
```
if message.to_ascii_lowercase().contains("scope does not match") {
    JrError::InsufficientScope { message: message.to_string(), required_scope: None }
} else {
    JrError::NotAuthenticated { hint: hint.to_string() }
}
```
- CLASSIFICATION TOTALITY is provable by structural inspection: no unwrap, no indexing, no
  slicing, no arithmetic. `to_ascii_lowercase()` + `contains()` + `to_string()` never panic on
  any &str. The function is total (returns exactly one of two variants) for every input pair.
  A Kani proof would add nothing over inspection here.
- Already covered by 7 inline unit tests (mod classify_401_body_tests) that pin exactly the
  invariant classes a proof would target: exact-match, real-wire-substring, case-insensitivity
  (3 casings), login-hint passthrough, refresh-hint passthrough, empty-message → NotAuthenticated,
  near-miss substrings ("scope does not", "does not match", "scope mismatch", ...) → NotAuthenticated.

### is_insufficient_scope_error(&anyhow::Error) -> bool  (src/cli/board.rs)
```
err.chain().find_map(|c| c.downcast_ref::<JrError>()).is_some_and(|e| matches!(e, InsufficientScope{..}))
```
- Pure chain scan; total (anyhow chain iteration terminates, downcast is safe). Covered by the
  context-wrapped-chain unit test (fires through `.context(...)`) + pass-through tests.

## Recommendation
Skip Kani (no infra, disproportionate to a 2-branch string classifier + a chain scan). The
existing property-style unit tests already assert totality across the adversarial input classes
(empty, near-miss, case-varied, wrapped-chain). A proptest "no panic for arbitrary String" would
be low marginal value given structural totality; not added to avoid leaving an uncommitted
working-tree edit at develop tip (state-manager records F6 results; F6 does not itself commit).
