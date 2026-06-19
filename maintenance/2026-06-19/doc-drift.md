---
document_type: maintenance-finding
scope: doc-drift
date: 2026-06-19
commit: 71f33c6
branch: develop
prior_run: .factory/maintenance/2026-06-17/doc-drift.md
severity_summary: {HIGH: 1, MED: 1, LOW: 3}
---

# Documentation Drift — Scan 2026-06-19

Surfaces checked: `CLAUDE.md`, `README.md`, `docs/adr/`, `.factory/specs/prd/README.md`, `.factory/research/` (reference integrity), module-level tree accuracy. Read-only scan; no code or documentation was modified.

Prior run: `.factory/maintenance/2026-06-17/doc-drift.md` (commit 53f6d98)
This run: commit 71f33c6 (v0.6.0-dev.5)

---

## PRIOR-RUN STATUS

| ID | Prior Severity | Status | Notes |
|----|---------------|--------|-------|
| DRIFT-D1 | HIGH | FIXED | `CLAUDE.md` tree now shows `cli/auth/` as a module directory with all shards listed |
| DRIFT-D2 | HIGH | FIXED | `CLAUDE.md` tree now shows `cli/assets/` as a module directory; Gotcha citation corrected to `cli/assets/tickets.rs::filter_tickets` |
| DRIFT-D3 | HIGH | FIXED | All 12 previously-missing files now appear in the architecture tree (bulk, resolutions, refresh_coordinator, JSM api/types, api passthrough, changelog, field_resolve, json_output, editmeta) |
| DRIFT-D4 | HIGH | FIXED | `CLAUDE.md` Conventions now correctly reads: "auth status has no `--output json` support (NFR-O-N: deferred; neither single-profile nor multi-profile JSON is implemented)" |
| DRIFT-D5 | MED | FIXED | `list.rs` tree description now says "list only (JQL composition, filter application)"; Known Size Deviations LOC figure updated to 1,256 and verified accurate (wc -l = 1256) |
| DRIFT-D6 | MED | FIXED | README Exit Codes table now includes exit code 124 (`Timeout / deadline exceeded`) |
| DRIFT-D7 | MED | FIXED | README Commands table now includes `jr api` and `jr issue changelog` |
| DRIFT-D8 | MED | FIXED | README `--verbose` description updated to "Show HTTP method + URL per request (header-only since v0.6 / SD-003; does NOT print bodies)"; `--verbose-bodies` row added |
| DRIFT-D9 | LOW | STILL OPEN | `docs/adr/0014-jsm-request-creation.md` still does not exist; CLAUDE.md and docs/adr/0015 still reference ADR-0014 |
| DRIFT-D10 | LOW | PARTIALLY FIXED | `prd/README.md` now shows 598 (was 573 previously). However BC-INDEX.md frontmatter shows `total_bcs: 599` (BC-2.4.043 added 2026-06-17) while prd/README.md still shows 598 — new one-count drift introduced |
| DRIFT-D11 | LOW | FIXED | CLAUDE.md Gotcha now reads "method + URL only" (no "status") |
| DRIFT-D12 | LOW | FIXED | README Commands table now includes `jr requesttype list` and `jr requesttype fields` |

**Prior findings resolution: 9 of 12 FIXED, 1 STILL OPEN (D9), 1 PARTIALLY FIXED with new sub-drift (D10), 1 unchanged (see NEW D10 variant below).**

---

## NEW FINDINGS

### HIGH

---

**DRIFT-D13** — CLAUDE.md Gotchas: four `.factory/research/issue-361-*.md` files referenced but do not exist

- **Location:** CLAUDE.md, two Gotcha entries:
  - Line ~231: "Detail: `.factory/research/issue-361-jra95368-scope.md`, `-jql-orderby.md`."
  - Line ~290: "Detail: `.factory/research/issue-361-validation.md`, `-followup.md`."
- **Stale claim:** Both Gotchas cite four research files as supporting evidence for load-bearing behavioral rules (JRACLOUD-95368 attribution correction, ORDER BY hint wording, citation discipline policy).
- **Reality:** None of the four files exist in `.factory/research/`:
  - `issue-361-jra95368-scope.md` — MISSING
  - `issue-361-jql-orderby.md` — MISSING
  - `issue-361-validation.md` — MISSING
  - `issue-361-followup.md` — MISSING
- **Impact:** The JRACLOUD-95368 Gotcha contains two load-bearing constraints that MUST NOT be changed (the ORDER BY hint wording and the `"JRACLOUD-95368"` literal pinned in tests). Without the research evidence files, there is no way to verify the rationale. An agent or developer following "Detail:" to audit the JRACLOUD ticket attribution will hit dead links and cannot confirm the "NOT -94632/-92049/-85546" claim. This is the same citation-discipline gap that ADR-0014 represents.
- **Fix type:** Manual — either create the four research files from scratch (reconstructing the verification evidence for JRACLOUD-95368 vs -94632/-92049/-85546 and the JQL ORDER BY constraint), OR update the Gotcha citations to "(research files not yet written)" with a comment that the constraints are load-bearing and must not be changed without re-verification.

---

### MED

---

**DRIFT-D14** — prd/README.md BC total (598) lags BC-INDEX.md frontmatter (599) by 1

- **Location:** `.factory/specs/prd/README.md` line ~49-51; `.factory/specs/prd/BC-INDEX.md` frontmatter `total_bcs: 599`.
- **Stale claim:** `prd/README.md` Document Map table row for BC-INDEX.md shows `598` and the prose "Total BCs in PRD: 598". The body counts the same BC sequence ending at BC-7.2.011 (#492) but does not include BC-2.4.043 (added 2026-06-17, Bundle C CR-001 list_comments anti-stall guard).
- **Reality:** BC-INDEX.md frontmatter `total_bcs: 599` is the canonical count as of 2026-06-17 commit. The prd/README.md was not updated when BC-2.4.043 was added.
- **Impact:** Process gap — `check-bc-cumulative-counts.sh` does not guard the prd/README.md surface (noted as known limitation in prior scan). Advisory doc only but the count drift undermines trust in the document map.
- **Fix type:** Manual — update prd/README.md Document Map row for BC-INDEX.md from 598 to 599 and update the "Total BCs in PRD: 598" prose to 599, appending "+1 BC-2.4.043" to the changelog suffix.

---

### LOW

---

**DRIFT-D9** (CARRIED FORWARD) — `docs/adr/0014-jsm-request-creation.md` still does not exist

- **Status:** No change since prior scan. ADR-0014 is referenced by CLAUDE.md Gotcha "Detail: ADR-0014", by `docs/adr/0015-proactive-resolution-enforcement.md` ("See Also: ADR-0014"), by `docs/specs/e2e-live-jira-testing.md`, and by `docs/specs/jsm-e2e-coverage.md`. The file does not exist.
- **Fix type:** Manual — create `docs/adr/0014-jsm-request-creation.md` documenting the `issue create --request-type` dispatch fork to `POST /rest/servicedeskapi/request`; OR annotate all references with "(ADR not yet written)".

---

**DRIFT-D15** — CLAUDE.md architecture tree does not list `cli/auth/tests/` test submodule

- **Location:** CLAUDE.md architecture tree, `cli/auth/` section (lines ~34-43).
- **Stale claim:** The tree lists `cli/auth/` shards ending at `switch.rs` with no mention of a `tests/` subdirectory.
- **Reality:** `src/cli/auth/tests/mod.rs` exists as a test submodule with a `snapshots/` directory of insta snapshot files. The test submodule is compiled as part of the crate.
- **Severity rationale:** LOW because test submodules are convention-following infrastructure, not production behavior. But the omission means the tree is still not a complete map of the `cli/auth/` module.
- **Fix type:** Manual (low priority) — add `│   │   └── tests/` entry to the auth module section of the architecture tree.

---

**DRIFT-D16** — CLAUDE.md architecture tree `types/assets/` and `types/jsm/` do not enumerate individual files

- **Location:** CLAUDE.md architecture tree lines ~85-91.
- **Current text:**
  - `├── types/assets/  # Serde structs for Assets API responses (AssetObject, ConnectedTicket, LinkedAsset, etc.)`
  - `├── types/jsm/     # Serde structs for JSM API responses (ServiceDesk, Queue, RequestType, etc.)`
- **Reality:** Both are module directories with individual files not listed:
  - `types/assets/`: `mod.rs`, `linked.rs`, `object.rs`, `schema.rs`, `ticket.rs`
  - `types/jsm/`: `mod.rs`, `queue.rs`, `request_type.rs`, `servicedesk.rs`
  - `types/jira/` similarly uses the "comma-separated list on one line" shorthand: `issue.rs, board.rs, sprint.rs, user.rs, team.rs, project.rs, worklog.rs` — this is an inconsistent convention. Other module directories enumerate files individually.
- **Severity rationale:** LOW because all type structs are mentioned by name in the inline comment (AssetObject, ConnectedTicket, etc.), so navigation is not seriously impaired. The inconsistency with the `cli/` and `api/` sections (which enumerate every file) could mislead a contributor.
- **Fix type:** Manual (low priority) — either enumerate individual files for `types/assets/` and `types/jsm/` to match the depth of the `cli/` and `api/` sections, or add a note that type directories use the summary convention.

---

## SUMMARY

| ID | Severity | Source Doc | Summary | Fix Type |
|----|----------|-----------|---------|----------|
| DRIFT-D13 | HIGH | CLAUDE.md | Four `.factory/research/issue-361-*.md` files cited in two Gotchas do not exist | Manual |
| DRIFT-D14 | MED | prd/README.md | BC total shows 598, BC-INDEX.md frontmatter says 599 (BC-2.4.043 not reflected) | Manual |
| DRIFT-D9 | LOW | docs/adr/ CLAUDE.md | ADR-0014 file still missing; referenced in 4+ places | Manual |
| DRIFT-D15 | LOW | CLAUDE.md | `cli/auth/tests/` test submodule not in architecture tree | Manual |
| DRIFT-D16 | LOW | CLAUDE.md | `types/assets/` and `types/jsm/` enumerate no individual files in tree | Manual |

**Total open findings: 5 (1 HIGH, 1 MED, 3 LOW)**

---

## VERIFICATION CHECKS (confirmed clean)

| Check | Result |
|-------|--------|
| CLAUDE.md tree: all listed files exist in `src/` | PASS — every file in the tree was verified present |
| `src/` production files not in tree | PASS — no substantive production file missing; minor gaps are test submodule (D15) and types enumeration style (D16) |
| `list.rs` LOC (Known Size Deviations claims 1,256) | PASS — `wc -l` = 1,256 |
| README Commands table: `jr api` present | PASS |
| README Commands table: `jr issue changelog` present | PASS |
| README Commands table: `jr requesttype list/fields` present | PASS |
| README Global Flags: `--verbose` description updated | PASS — "Show HTTP method + URL per request (header-only since v0.6 / SD-003; does NOT print bodies)" |
| README Global Flags: `--verbose-bodies` entry present | PASS |
| README Exit Codes: exit code 124 present | PASS |
| CLAUDE.md `auth status` JSON claim | PASS — "auth status has no `--output json` support (NFR-O-N: deferred; neither single-profile nor multi-profile JSON is implemented)" |
| CLAUDE.md `--verbose` Gotcha: "method + URL only" (no "status") | PASS |
| ADRs 0001-0006, 0015-0016: files exist | PASS |
| CLAUDE.md docs/specs/ references: all 11 files exist | PASS |
| CLAUDE.md docs/superpowers/ references: all 3 files exist | PASS |
| Error.rs exit codes match README table (0/1/2/64/78/124/130) | PASS |
| `observability.rs` LOC claim (~39 LOC) | PASS — `wc -l` = 39 |
| `view.rs` LOC claim (~287 LOC) | PASS — `wc -l` = 287 |
| `comments.rs` LOC claim (~61 LOC) | PASS — `wc -l` = 61 |
| `api/assets/schemas.rs` LOC claim (~44 LOC) | PASS — `wc -l` = 44 |
| CLAUDE.md architecture `cli/auth/` as module directory | PASS |
| CLAUDE.md architecture `cli/assets/` as module directory | PASS |
| CLAUDE.md Gotcha `cli/assets/tickets.rs::filter_tickets` citation | PASS |
| `prd/README.md` BC total updated from 573 to 598+ | PASS (partially — see D14) |

---

## VERDICT

**Improved significantly from prior scan.** 9 of 12 prior findings were fully remediated between commits 53f6d98 and 71f33c6. All HIGH and MED findings from the prior scan are resolved. The architecture tree is now substantially accurate.

**1 new HIGH finding (DRIFT-D13):** Four research files cited in load-bearing CLAUDE.md Gotchas (JRACLOUD-95368 attribution and citation discipline) do not exist. The Gotchas themselves are correct behavioral guidance, but the "Detail:" citations are dead links that cannot be followed to audit the reasoning. This matters because the JRACLOUD-95368 Gotcha constrains test literals and user-facing strings that must not be changed without re-verification.

The remaining findings (D14 MED, D9/D15/D16 LOW) are process/housekeeping gaps with no runtime impact.
