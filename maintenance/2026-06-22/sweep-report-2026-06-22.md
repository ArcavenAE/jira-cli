# Maintenance Sweep — 2026-06-22

**Mode:** brownfield/Rust
**Branch:** develop @ ed236d4
**Sweeps run:** 1, 2, 3, 4, 5, 7, 8
**Sweep 6 (DTU):** N/A — dtu_required:false
**Sweep 9 (a11y):** N/A — no UI (CLI-only)

**Headline:** ZERO reachable critical/HIGH bugs; both HIGH-tagged findings validated NON-REACHABLE.

---

## Consolidated Findings Table (post-triage)

| ID | Sweep | Finding | Raw Sev | Triaged Sev | Disposition |
|----|-------|---------|---------|-------------|-------------|
| RUSTSEC-2026-0185 | 1 Dep | quinn-proto 0.11.14 QUIC mem-exhaustion (CWE-400, CVSS 7.5) | HIGH | LOW (non-reachable) | http3 feature off; quinn not compiled into jr binary (cargo tree zero quinn). Remediation: routine `cargo update -p quinn-proto`->0.11.15 lockfile bump to clear audit noise. Normal PR path. |
| PF-005 | 3 Pattern | unwrap() on assets[idx].id, linked.rs:225 | HIGH | LOW (non-reachable) | Orchestrator-validated FALSE POSITIVE: needs_enrichment filter (linked.rs:192 `a.id.is_some()`) guarantees Some. Nit: change to `.expect("id present — needs_enrichment filter guarantees")` for refactor-safety, matching line 224. |
| MAINT-2026-06-17-SC-03 | 2 Doc | ADRs 0007-0013 only in .factory/architecture/adr/, not docs/adr/ canonical | MED | MED | Confirmed (known drift). Needs routing decision + doc PR. |
| H-019-EXIT-DRIFT | 4 Holdout | --profile flag & JR_PROFILE env exit 78 (EX_CONFIG) not 64 (EX_USAGE) for foo:bar boundary | — | MED (needs triage) | NEW. Ambiguous: real exit-code semantics bug OR intentional-but-stale holdout. Needs product-owner judgment before routing. |
| PF-003 / DRIFT-CR-008 | 3 Pattern | extract_job_block dup x3 test files | MED | LOW | Confirmed; already tracked S-MAINT-CR-008 (draft). |
| PF-004 / KEYRING-GUARD-IDIOM-DRIFT | 3 Pattern | 2 keyring guard idioms (is_err vs !=Ok("1")) | MED | LOW | Confirmed; already tracked S-MAINT-CR-009 (draft). |
| DRIFT-331-PAGINATION | 3 Pattern | inline pagination in get_issue_types_for_project | LOW | RESOLVED-REFUTED | code-reviewer confirms intentional/documented/correct. Recommend closing S-MAINT-CR-005 as moot. |
| DOC-CLAUDE-TREE | 2 Doc | CLAUDE.md arch tree omits 6 mod.rs files | LOW | LOW | Auto-fixable doc PR. |
| DOC-CHANGELOG | 2 Doc | CHANGELOG [Unreleased] empty vs 3 merged commits since v0.6.0-dev.6 | LOW | LOW | Populate [Unreleased]. |
| DOC-README-VER | 2 Doc | README install.sh pins v0.3.0 (stable v0.5.0) | LOW | LOW | Doc fix. |
| DOC-ADR0014-FNAME | 2 Doc | ADR-0014 filename mismatch docs/adr vs .factory | LOW | LOW | Doc fix (pairs with SC-03). |
| PG-A / DRIFT-README | 7 Spec | prd/README.md Document Map stale 599/142 vs 602/145 (unguarded 9th surface) | LOW | LOW | Count fix; consider extending check-bc-cumulative-counts.sh. |
| PF-001/002/006 | 3 Pattern | redundant allow(dead_code); non-adjacent justification; sprint.rs render_json idiom split | LOW | LOW | Idiom nits. |
| PERF-BASELINE | 5 Perf | No bench infra; first baseline established (7.1MB, jr --help p50=8ms) | LOW | LOW | PERF-BASELINE-ABSENT now has data. Rec LOW story: scripts/perf-check.sh + hyperfine. |
| Holdout stale (H-NEW-MP-001, H-007, H-027) | 4 | --story-points rename, ADR-0015 mechanism, cap narrative | LOW | LOW | product-owner holdout refresh. |
| Holdout coverage-gaps (6) | 4 | ADF wave #471-#522 ZERO holdout; issue edit --field/--type/--label/--dry-run; bulk nested schema; changelog; worklog add; link/queue | LOW | LOW | product-owner write new scenarios (backlog). |
| S-PG-MERGE-AUTH-BYPASS | 8 TechDebt | merge-auth protocol (DEC-128) | MED | MED | Story 91 draft — highest-value process fix. |

---

## Summary

- **Critical:** 0
- **Reachable HIGH:** 0 (both HIGH-tagged findings validated non-reachable)
- **MED:** 3
  - MAINT-2026-06-17-SC-03 (ADR location drift — confirmed known)
  - H-019-EXIT-DRIFT (exit-code semantics — needs PO triage)
  - S-PG-MERGE-AUTH-BYPASS (merge-auth protocol — story 91 draft)
- **LOW:** ~14 (most already tracked or trivial doc/lockfile hygiene)
- **RESOLVED:** 1 (DRIFT-331-PAGINATION refuted — intentional/correct per code-reviewer)

---

## Per-Sweep Detail Files

| Sweep | File |
|-------|------|
| 1 — Dependency audit | `dependency-audit.md` |
| 2 — Documentation drift | `doc-drift-findings.md` |
| 3 — Code pattern scan | `pattern-findings.md` |
| 4 — Holdout freshness | `holdout-freshness.md` |
| 5 — Performance baseline | `performance-baseline.md` |
| 7 — Spec coherence | `spec-coherence-findings.md` |
| 8 — Tech debt | (findings embedded in S-PG-MERGE-AUTH-BYPASS story 91 + Drift Items) |

Raw dependency scan log: `dependency-audit-raw.log`
