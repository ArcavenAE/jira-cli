---
phase: f6-targeted-hardening
bundle: ADF-CODE-MARK-EXCLUSIVITY
head_sha: d7875e6
pre_bundle_base: 0d8a8a5
merge_commit: 7ba4cf4 (fix), d7875e6 (changelog)
issue: "#571"
bc_anchors: [BC-7.2.015, BC-7.2.007]
verification_properties: [VP-571-001, VP-571-002, VP-571-003, VP-571-004, VP-571-005]
regression_current: 2007/0/93
gate_verdict: GO
date: 2026-07-08
---

# F6 — Targeted Hardening Summary

Bundle **ADF-CODE-MARK-EXCLUSIVITY** on `develop` @ `d7875e6` (already merged via PR #593 / #594). Delta verified independently of prior review conclusions and phase-f5 artifacts (information-asymmetry wall observed).

## Independent delta confirmation

`git diff 0d8a8a5..d7875e6 --stat`:

```
 CHANGELOG.md                                       |   9 +
 CLAUDE.md                                          |   2 +-
 src/adf.rs                                         | 594 +++++++++++-
 tests/adf_code_mark_exclusivity.rs                 | 499 +++++++++++
 tests/issue_create_jsm.rs                          | 237 +++++
 (+ code-delivery demo assets)
 18 files changed, 1635 insertions(+), 19 deletions(-)
```

Production `src/` delta: `src/adf.rs` (single file) — the `push_code` allowlist-filter change closing BC-7.2.015 (also closing the BC-7.2.007 EC-2 follow-up from issue #474). Test delta: new `tests/adf_code_mark_exclusivity.rs` (H-NEW-ADF-010 Calls A–D, platform path) + extension of `tests/issue_create_jsm.rs` (Call E, JSM path). Confirmed.

## Per-dimension results

| # | Dimension | Result | Notes |
|---|-----------|--------|-------|
| 1 | Formal verification (proptest — Kani substitute) | **PASS** | VP-571-001 held at `PROPTEST_CASES=2000` (10× default). All 5 VPs covered by proof-strength or integration-strength artifacts. See `kani-results.md`. |
| 2 | Fuzz testing | **PASS (justified skip)** | No cargo-fuzz setup in repo (project precedent). VP-571-001 proptest at 2000-case count on `markdown_to_adf` is the substitute; delta introduces no new panic / I/O surface. See `fuzz-results.md`. |
| 3 | Mutation testing (`--in-diff`) | **PASS** | 1 mutant generated, 1 caught → **100.0% kill rate** (target 90%). Mutant `src/adf.rs:1282:9 replace push_code with ()` killed in 4.2 s. See `mutation-results.md`. |
| 4a | cargo deny check | **PASS (exit 0)** | advisories/bans/licenses/sources ok. 3 unused-license-allowance warnings (baseline, non-fatal). |
| 4b | cargo audit | **PASS (exit 0)** | 347 crates scanned, 0 vulnerabilities. |
| 4c | Semgrep | **SKIP (justified)** | Not installed on host — project standard is cargo-deny + cargo-audit + clippy. Manual audit of `src/adf.rs`: 0 real `unsafe`, 0 new panic / I/O surface. |
| 4d | BC-7.2.015 SEC framing | **PASS** | Restrictive-only allowlist filter; no untrusted-input execution; no `href` scheme validation change. |
| 5a | cargo test (full regression) | **PASS — 2007/0/93** | 0 failures across full workspace. |
| 5b | cargo clippy --all-targets -- -D warnings | **CLEAN (exit 0)** | Zero warnings. |
| 5c | cargo fmt --all -- --check | **CLEAN (exit 0)** | No formatting drift. |
| 6 | DTU adversarial (7b) | **N/A (justified)** | No external-service interaction change. `push_code` is a pure-core emit-site filter; JSM/Jira APIs unchanged. `dtu_required=false`. |
| 7 | Accessibility (7d) | **N/A (justified)** | CLI-only feature. No UI surface, no new human-facing text. |

## Regression evidence

- **cargo test full-workspace: 2007 passed, 0 failed, 93 ignored.**
- Reverse-path MUST-STAY-GREEN (VP-571-004): `test_render_marks_code_and_strong`, `test_render_strong_with_code_applies_code_innermost` — both green.
- BC-7.2.011 CR/LF MUST-STAY-GREEN: `test_push_code_normalizes_lone_cr_in_inline_code`, `test_push_code_normalizes_bare_lf_to_space` — both green.
- BC-7.2.012 depth-guard MUST-STAY-GREEN: `test_max_adf_depth_constant_is_256`, `test_markdown_to_adf_depth_256_blockquote_is_err`, `test_adf_to_text_depth_256_is_err` — all green.

## Security escalation

No CRITICAL or HIGH findings across cargo deny, cargo audit, manual audit, or BC-7.2.015 SEC-framing review. No `security-reviewer` escalation. No BLOCK condition.

## Findings requiring fix-PR

**None.** No FIX-F6-NNN issues opened.

## Gate verdict: **GO** for F7 (Delta Convergence)

Quality-gate criteria all met:

- [x] Formal proofs / substitute PASS (proptest at 2000 cases).
- [x] Fuzz clean or justified skip (justified skip; substitute PASS).
- [x] Mutation kill rate ≥ 90% (100% — 1/1).
- [x] No unresolved CRIT/HIGH security findings (0 across all channels).
- [x] Full regression green (2007/0/93).
- [x] clippy clean, fmt clean.

Ready for F7 delta convergence. State-manager owns commit of these artifacts to `.factory/phase-f6-hardening/` on the factory-artifacts branch.
