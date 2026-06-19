# PR Review: #543 — docs: 2026-06-19 maintenance sweep accuracy fixes

**Verdict: APPROVE**

Documentation-and-CI-only PR. 3 files, +196/-5, no `src/` changes, no behavioral changes. Every claim was independently verified against the working tree.

## Checklist

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all changes are doc/CI accuracy fixes, scoped to the stated DRIFT/CR IDs |
| 2 | Description accuracy | PASS — diff matches the PR body exactly (3 files, line counts, each sub-change) |
| 3 | Test coverage | N/A — no code change; the new ADR is prose, the workflow change is declarative |
| 4 | Demo evidence | N/A — docs/CI-only PR, no acceptance criteria to demo |
| 5 | Commit quality | PASS — `docs:` conventional prefix appropriate for the change set |
| 6 | Diff size | PASS — 201 lines, of which 179 are one new ADR file |
| 7 | Missing changes | PASS — nothing the description claims is absent from the diff |
| 8 | Dependency status | N/A — no upstream PR dependency |

## What I verified (no rubber-stamp)

**Architecture tree entries (DRIFT-D15/D16) — all match real files:**
- `src/cli/auth/tests/` exists (contains `mod.rs` + `snapshots/`). The comment "inline integration tests + insta snapshots" is accurate.
- `src/types/assets/` contains exactly `mod.rs, linked.rs, object.rs, schema.rs, ticket.rs` — the 5 enumerated entries match 1:1.
- `src/types/jsm/` contains exactly `mod.rs, servicedesk.rs, queue.rs, request_type.rs` — the 4 enumerated entries match 1:1.

**ADR-0014 (new file) — content cross-checks against source:**
- ID 0014 fills a genuine gap (existing ADRs jump 0006 → 0015; 0014 was missing despite being referenced in CLAUDE.md gotchas).
- Fork gate `if request_type.is_some() { return handle_jsm_create(...) }` is present verbatim at `src/cli/issue/create.rs:63-64` as an early return — matches the ADR's "Decision 1" and "platform path byte-for-byte unchanged" claim.
- Endpoint `POST /rest/servicedeskapi/request` confirmed in `src/api/jsm/requests.rs:25`.
- `isAdfRequest` / `raiseOnBehalfOf` conditional-inclusion logic (BC-3.8.006 / BC-3.8.009) confirmed in `requests.rs:137-145`.
- `--on-behalf-of` flag → `raiseOnBehalfOf` mapping confirmed at `src/cli/mod.rs:403-406`.
- `write:servicedesk-request` 401 scope hint confirmed at `src/error.rs:211`.
- ADR content is consistent with the existing CLAUDE.md gotcha "jr issue create --request-type dispatch fork (S-288-pr4)".

**CI workflow (CR-010):** `backfill-release.yml` `build` job now has `timeout-minutes: 60`. The parity target `release.yml` `build` job (its matrix-build job) also uses `timeout-minutes: 60`. Both are the cross-platform matrix build jobs, so this is a true apples-to-apples parity fix. 60 minutes is appropriate headroom for a cross-target cargo release build.

**Dead-citation removals (DRIFT-D13):** The 4 removed `Detail: .factory/research/issue-361-*.md` citations and 2 trailing suffixes are dead references behind the information wall; their removal is correct hygiene and does not alter any load-bearing technical prose.

## Findings

None.

## Summary

A clean, low-risk documentation and CI-parity maintenance PR. Every factual claim in the architecture tree and the new ADR-0014 was verified against the actual source files and matched exactly; the CI `timeout-minutes: 60` addition correctly mirrors the `release.yml` build job. No code, tests, or behavior change. Approved.
