---
document_type: prd-delta
feature: e2e-test-enhancements
branch: test/e2e-enhancements
design_spec: docs/specs/e2e-test-enhancements.md
f1_delta_analysis: .factory/phase-f1-delta-analysis/delta-analysis.md
date: 2026-05-29
bc_delta: EMPTY
prd_delta: NONE
nfr_delta: NONE
edge_case_delta: NONE
---

# PRD Delta — Live-Jira E2E Test Enhancements

## 1. Delta Classification

| Dimension | Decision |
|-----------|----------|
| BC delta | EMPTY — no new BCs; all assertions cover existing shipped contracts |
| PRD body change | NONE — prd.md is not modified |
| NFR change | NONE — nfr-catalog.md is not modified |
| Edge-case catalog change | NONE — edge cases are already bodied in existing BCs |
| Architecture delta | NONE — no new subsystems; e2e.yml/e2e-sweeper.yml are test-layer only |

This decision mirrors the precedent set by S-E2E-1 (PR #433) and S-E2E-2 (PR #434), which also
carried an empty BC delta. The feature adds live test coverage and test-infrastructure hardening;
it does not introduce or change any behavioral contract.

## 2. Behavior-to-BC Binding Table

The F1 delta analysis listed indicative BC IDs in its BC Coverage Map section. This table
confirms each coverage area against the canonical BC-INDEX.md and corrects one transposition.

| Coverage Area | F1 Indicative ID | Confirmed BC-INDEX ID | Verification |
|---------------|------------------|-----------------------|--------------|
| `issue list` default 16-field set | BC-2.2.028 | **BC-2.2.028** | Exact match. Section 2.2 row: "`search_issues` default fields list: 16 fields in EXACT order." |
| `issue view --output json` raw response | BC-2.3.032 | **BC-2.3.032** | Exact match. Section 2.3 row: "GETs `/rest/api/3/issue/<key>` with `--output json` returning raw JSON." |
| `issue comments` pagination | BC-2.4.039 | **BC-2.4.039** | Exact match. Section 2.4 row: "paginates at 100/page with `expand=properties`." |
| `issue changelog` filter/reverse | BC-2.5.043..046 | **BC-2.5.043, BC-2.5.044, BC-2.5.045, BC-2.5.046** | Exact match. All 4 changelog BCs present in Section 2.5. |
| `issue assign --to me` via `/myself` | BC-3.1.003 | **BC-3.1.003** | Exact match. Section 3.1 row: "resolves current user via `/myself`." |
| Single-key `issue move` idempotency | BC-3.2.001 | **BC-3.2.001** | Exact match. Section 3.2 row: "idempotent when current == target (by status name)." |
| Edit echo asymmetry — table marker `(updated)` | BC-3.4.012 | **BC-3.4.012** | Exact match. Section 3.4 row: "echoes one stderr line per changed field; `--description` shows literal marker `(updated)`." |
| Edit echo asymmetry — JSON raw input string | BC-3.4.013 | **BC-3.4.013** | Exact match. Section 3.4 row: "`changed_fields.description` carries the raw user-supplied input string." |
| `issue link` — POST / default type "Relates" | BC-3.6.001 | **BC-3.6.001** | Exact match. Section 3.6 row: "POSTs `/rest/api/3/issueLink`; default type 'Relates'." |
| `client.delete_issue_link` — DELETE 204 | BC-3.6.004 | **BC-3.6.004** | Exact match. Section 3.6 row: "DELETEs `/rest/api/3/issueLink/10001`; accepts 204." |
| `client.list_link_types()` — returns types | BC-3.6.005 | **BC-3.6.005** | Exact match. Section 3.6 row: "returns 3 link types from `/rest/api/3/issueLinkType`." |
| `client.list_boards()` — GET with query params | BC-5.1.001 | **BC-5.1.001** | Exact match. Section 5.1 row: "GETs `/rest/agile/1.0/board` with query params." |
| `sprint current` truncation + `--all` | BC-5.2.005 | **BC-5.2.005** | Exact match. Section 5.2 row: "truncates to 30 by default; with `--all` returns full set." |
| `search_issues` dedup (JRACLOUD-95368) | BC-6.2.051 (F1 typo) | **BC-2.6.051** | CORRECTION: F1 wrote `BC-6.2.051` (which does not exist; Section 6.2 ends at BC-6.2.015). The correct ID is `BC-2.6.051` in Section 2.6 (API Layer): "`search_issues` deduplicates results in-place on all exit paths (JRACLOUD-95368 mitigation)." |
| `--output json` error shape | BC-7.1.005 | **BC-7.1.005** | Exact match. Section 7.1 row: "`--output json` error shape: `{\"error\": \"<message>\", \"code\": <exit>}` to stderr." |
| `JrError::exit_code()` mapping | BC-7.3.006 | **BC-7.3.006** | Exact match. Section 7.3 row: "`JrError::exit_code()` mapping." |
| 401 → exit 2, universal | BC-X.3.002 | **BC-X.3.002** | Exact match. Section X.3 row: "401 → `Not authenticated` + `jr auth login` exit 2 (universal across all subcommands)." |
| `client.add_worklog()` — POST 201 | BC-X.5.001 | **BC-X.5.001** | Exact match. Section X.5 row: "POSTs `/issue/<key>/worklog`; returns Worklog; accepts 201." |
| `team list` cache-first (7d TTL) | BC-X.6.004 | **BC-X.6.004** | Exact match. Section X.6 row: "`team list` cache-first (7d TTL); `--refresh` forces re-fetch." |

## 3. Behavior-Without-BC Flags

**None.** All behaviors asserted by the E2E test milestones (M1 deepen, M2 new gated tests,
M3 sweeper + failure classification) trace to existing BCs confirmed above.

The F1 error-path note ("404→1, 400 malformed JQL→1, 401 bad auth→2") traces through
BC-7.3.006 (exit-code mapping table) and BC-X.3.002 (401→exit-2 universal), which are both
confirmed. The error-shape assertion traces to BC-7.1.005.

## 4. Summary

- **BC-INDEX.md**: unchanged.
- **prd.md**: unchanged.
- **nfr-catalog.md**: unchanged.
- **Any BC file**: unchanged.
- **F1 correction recorded**: `BC-6.2.051` in the delta analysis is a transposition; the
  correct canonical ID is `BC-2.6.051`. This correction is informational only — no BC file
  changes are required because the BC itself is correct; only the F1 indicative reference
  was wrong.
- **Proceeding to F3** (incremental story authoring for S-E2E-3/4/5) with zero spec artifacts
  to modify.
