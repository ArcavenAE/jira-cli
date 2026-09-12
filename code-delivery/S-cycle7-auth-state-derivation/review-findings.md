# Review Findings — S-cycle7-auth-state-derivation

PR: #806 — `feat(auth): derive AuthState from pure helper; wire auth list to probe-based 3-state status`
Branch: `feat/cycle7-auth-state-derivation`

## Convergence Table

| Cycle | HEAD at Review | Findings | Blocking | Non-Blocking | Fixed | Remaining |
|-------|---------------|----------|----------|--------------|-------|-----------|
| 1 | `6d3030f9` | 3 | 2 | 1 | 3 | 0 |
| 2 | `5ced48ca` | in progress | — | — | — | — |

## Cycle 1 Findings (HEAD: `6d3030f9`)

| ID | Severity | Finding | Fix Commit | Status |
|----|----------|---------|-----------|--------|
| B-1 | BLOCKING | `docs/specs/multi-profile-auth.md` STATUS set missing `no-credentials` — documented only `{configured, unset}` | `5ced48ca` | RESOLVED |
| B-2 | BLOCKING | `docs/specs/cargo-mutants-policy.md` `probe_matching_kind_credential` exclusion class undocumented | `5ced48ca` | RESOLVED |
| NB-1 | NON-BLOCKING | `test_bc_1_6_049_list_probes_at_most_once_per_url_profile` binds `_results` but never asserts map values; `results.insert(name, true)` mutation survives with all 103 tests green | `5ced48ca` | RESOLVED |

## Cycle 1 Fix Details

**B-1 fix:** `docs/specs/multi-profile-auth.md` line 266 updated:
- Before: `STATUS ∈ {configured, unset}`
- After: `STATUS ∈ {configured, no-credentials, unset}` with derivation semantics documented (BC-1.6.048/049)

**B-2 fix:** `docs/specs/cargo-mutants-policy.md` new section added after `issues.rs` entry:
- Documents `probe_matching_kind_credential` exclusion class (keychain-gated/no-seam, NOT timeout)
- Documents two-regex design (Regex A: operator/expression mutants; Regex B: body-replacement)
- Documents accepted-survivor status of `handle_list` mutants and scope boundaries

**NB-1 fix:** `test_bc_1_6_049_list_probes_at_most_once_per_url_profile` updated:
- Closure now returns `profile == "with-url-1"` (true for with-url-1, false for with-url-2)
- Added 4 map invariant assertions:
  1. `results.get("with-url-1") == Some(&true)` (probe return stored faithfully)
  2. `results.get("with-url-2") == Some(&false)` (kills `results.insert(name, true)` mutation)
  3. `!results.contains_key("no-url")` (url=None profiles absent from map)
  4. `results.len() == 2` (exactly 2 entries)

## Cycle 2 Findings (HEAD: `d42d288e`)

| ID | Severity | Finding | Status |
|----|----------|---------|--------|
| — | — | No new blocking findings | — |
| NIT-1 | NIT | `.cargo/mutants.toml` comment attributes `derive_auth_state` to list.rs glob (it lives in auth.rs) | Accepted — no correctness impact |

**Verdict: APPROVE**  
`covered_sha: d42d288e5bdff17336cf1b32a4edf711f2b452fb`  
Reviewer: pr-reviewer-cycle2 + stale-reviewer (independent)

## Final State

- CI Gate: PASS (run 34667161012)
- Blocking findings: 0
- Review convergence: APPROVED after cycle 2
- HEAD at approval: `d42d288e5bdff17336cf1b32a4edf711f2b452fb`
- **Status: READY-TO-MERGE (stop before merge — human UI squash-merge required)**
