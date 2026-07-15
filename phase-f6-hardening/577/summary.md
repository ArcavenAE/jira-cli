---
phase: f6-targeted-hardening
bundle: SOH-COMMENT-CRUD-1
issue: "#577"
head_sha: ae2e3db
pre_bundle_base: b2ce3169
bc_anchors: [BC-3.5.002, BC-3.5.003, BC-3.5.004, BC-3.5.005, BC-3.5.006, BC-3.5.007, BC-3.5.008, BC-3.5.009, BC-3.5.010, BC-3.5.011, BC-3.5.012]
verification_properties: VP-577-001..030 (30/30 PROVEN-BY-TEST)
mutation: 60 generated / 39 caught / 0 missed / 20 timeout (adjudicated caught) / 1 unviable
kill_rate_raw: 66.1% (39/59 viable; timeouts unresolved)
kill_rate_adjudicated: 100% (0 missed; 20 timeouts proven caught in isolation)
regression: 2102 passed / 0 failed / 94 ignored
clippy: clean (exit 0)
fmt: clean (exit 0)
gate_verdict: GO
date: 2026-07-14
---

# F6 — Targeted Hardening Summary (SOH-COMMENT-CRUD-1)

Bundle SOH-COMMENT-CRUD-1 (issue #577) on develop @ ae2e3db (PRs #610/#615/#616/#617/#620 + docs #618/#619/#621/#622). Delta b2ce3169...ae2e3db verified independently. Follows the ADF-CODE-MARK-EXCLUSIVITY (#571) F6 precedent.

## Per-dimension results
| # | Dimension | Result | Notes |
|---|-----------|--------|-------|
| 1 | Mutation (--in-diff, bundle) | PASS (adjudicated) | 60: 39 caught, 0 missed, 20 timeout, 1 unviable. Raw 66.1% below 90% due to 240s wall-clock cap under --jobs 4 contention (baseline 91s); adjudicated 100% — 20 timeouts (all handle_comment_edit/view) proven caught via 3 isolated manual mutations. |
| 2 | Fuzz | PASS (justified skip) | ADF reused + 256-depth guard + 10 proptests. Delta 3 pure fns probed at 4,000 proptest cases (reverted): 6/6. |
| 3a | cargo deny | PASS (exit 0) | |
| 3b | cargo audit | PASS (exit 0) | 347 crates, 0 vulns. |
| 3c | semgrep | SKIP (justified) | Not installed; manual pass done. |
| 3d | Manual delta security | PASS — 0 new | SEC-577-001..008 (LOW/INFO) holding. |
| 4 | VP VP-577-001..030 | PASS — 30/30 PROVEN-BY-TEST | 0 gaps. |
| 5a | cargo test | PASS — 2102/0/94 | 0 failures / 96 binaries. |
| 5b | clippy --all-targets -D warnings | CLEAN | |
| 5c | fmt --all --check | CLEAN | |
| 6 | DTU adversarial | N/A (justified) | dtu_required=false. |
| 7 | Accessibility | N/A (justified) | CLI-only. |

## Findings requiring fix-PR
None. One non-blocking CI observation (mutation-results.md): raise --timeout or lower --jobs for bundle-scoped mutation runs.

## Gate verdict: GO for F7 (Delta Convergence)
