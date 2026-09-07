---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-07T01:15:00Z
cycle: "cycle-005"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Burst Log — cycle-005 (adf-mentions)

## Burst: Burst 1 — cycle-005 OPENED (Feature Mode) — adf-mentions bundle confirmed, F1 delta analysis APPROVED (DEC-344) (2026-09-06)

**Parent-commit:** `569d85a8` (`develop` tip; unchanged this burst — no `develop`-side commit; cycle-005 has not started implementation, F1/F2 are spec-only phases).

**Trigger:** human requested a new Feature-Mode cycle following cycle-004's release and close: `adf-mentions` (GitHub #674) — convert markdown mentions (`[~accountid:<id>]` bracket form and `@Name` form) into ADF `mention` nodes on the write path, with a corresponding `adf_to_text` reverse-path update.

**Actions taken:**

1. STATE.md refreshed via one full-content Write (v3.74 → v3.75): frontmatter `phase` → `"cycle-005 (adf-mentions) Phase F1 delta analysis APPROVED; Phase F2 (spec evolution) IN PROGRESS."`, `pipeline` → `ACTIVE`, `current_cycle` → `"cycle-005"`, `feature_mode_bundle` → `adf-mentions`, `dtu_required` → `false` (no third-party service cloned — the feature targets Jira's own REST API user-search/mention surface, already covered by existing DTU-not-required precedent). `cycle_001_status` through `cycle_004_status` preserved unchanged (all CLOSED, historical, intact verbatim); added `cycle_005_status`. `activation_head`/`activation_version` held at `569d85a8`/`v0.7.0-dev.5` (unchanged — no release-side commit this burst).
2. **F1 delta analysis dispatched and completed.** architect produced `phase-f1-delta-analysis/cycle-005/delta-analysis.md` + `affected-files.txt`. business-analyst produced `phase-f1-delta-analysis/cycle-005/artifact-mapping.md` (canonical BC/VP decomposition proposal).
3. **Duplicate artifact reconciled.** An orchestrator coordination error re-dispatched a second business-analyst run against the same F1 scope, producing a second `artifact-mapping.md` at `cycles/cycle-005/phase-f1-delta-analysis/artifact-mapping.md`. The two files were diffed. Both largely overlap, but the duplicate resolves two points more concretely than the canonical: (a) a committed reverse-path BC-7.2.019 that implements `adf_to_text` mention rendering and explicitly closes GitHub issue #202 / NFR-O-I (the canonical left this as an open F2 decision under BC-7.2.004); (b) a 3-way split of `@Name` resolution into BC-X.7.007 (unique match) / BC-X.7.008 (ambiguous) / BC-X.7.009 (zero match), plus VP-674-007/008 (reverse-path render + round-trip property) and VP-674-009/010/011 (tied to the 3-way split and JSM visibility orthogonality) — versus the canonical's single shared-resolver BC-X.7.007 and VP-674-001..006. These genuinely distinct proposals were appended to the canonical `artifact-mapping.md` as an "Alternative decomposition (F2 input)" note. The duplicate file and its now-empty `cycles/cycle-005/phase-f1-delta-analysis/` directory were then removed. Both remain F1 **proposals only** — F2 (architect + product-owner) authors the binding BCs/VPs from either or both.
4. **Tracked follow-up logged (non-blocking):** `VP-COUNT-RECONCILIATION` — the business-analyst's F1 pass surfaced a pre-existing bookkeeping discrepancy: a raw grep found ~177 VP identifiers across `bc-*.md` bodies, versus STATE.md's tracked running total of 55 VPs. Logged under Constraints Carried Forward / Drift-Standing-Items, targeted at a future maintenance/self-improvement cycle; not investigated or resolved this burst.
5. Recorded 1 new Decisions Log entry, **DEC-344** (collision-checked: highest pre-existing ID was DEC-343, confirmed via corpus-wide grep against STATE.md — no collision): human APPROVED the F1 delta-analysis scope in full — two mention input forms (bracket `[~accountid:<id>]` pure post-pass conversion + preflight-validate the accountId via `GET /rest/api/3/user?accountId=`; `@Name` effectful resolution via user search), hard-error `@Name` no-match (exit 64) with a `\@` escape and a `--no-mentions` opt-out, ambiguous-match prompt/error-with-candidates, unique-match resolve+tag, `attrs.text` populated from the resolved display name, wiring across comment add / issue create (platform) / issue edit / JSM `issue create --request-type` (`handle_jsm_create`), reverse-path `adf_to_text` update (affects BC-7.2.004 and `issue view` rendering), and a **new** human requirement for live-Jira E2E test coverage against a controlled test account with self-cleaning teardown. Phase advances F1 → F2.
6. Added a new Phase Progress row for cycle-005 (`F1-DELTA-ANALYSIS`, APPROVED); replaced Current Phase Steps with a cycle-005 Burst-1 table (cycle-004's RELEASED/CLOSED steps table already fully archived in `cycles/cycle-004/burst-log.md`).
7. Updated Convergence Status / Concurrent Cycles prose: cycle-005 `adf-mentions` is now the sole OPEN cycle (Phase F2 in progress); cycle-001/002/003/004 remain CLOSED, historical, unaltered.
8. Condensed the now-historical cycle-004 Constraints-Carried-Forward / Drift-Standing-Items paragraphs (previously full per-burst narrative, Bursts 3-22) into brief historical summary lines, mirroring the compaction already applied to cycle-003 when cycle-004 opened — full per-burst detail remains intact and unchanged at `cycles/cycle-004/burst-log.md`. No content was deleted, only relocated/condensed per the routing rules (STATE.md stays lean; cycle files hold history).
9. Replaced Session Resume Checkpoint (cycle-005 F1-APPROVED/F2-IN-PROGRESS position); the prior CLOSED+RELEASED cycle-004 resting-state checkpoint (v3.74) was archived to `cycles/cycle-004/session-checkpoints.md` with a "Superseded at" note BEFORE the new checkpoint was written.
10. Carried ALL cycle-001/002/003/004 Drift/Standing items forward verbatim (condensed prose per item 8 above, no content lost — full detail remains in each cycle's own burst-log.md).
11. Created cycle-005 scaffolding: `cycles/cycle-005/burst-log.md` (this file) and `cycles/cycle-005/session-checkpoints.md` (empty archive, no checkpoint superseded yet).
12. Did NOT stage the pre-existing unrelated dirty files noted at every prior burst (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left as-is per standing instruction; only cycle-005-init paths plus STATE.md plus the cycle-004 checkpoint-archive append are staged explicitly for this commit.

**Adversary verdict:** N/A — bookkeeping/cycle-open burst (STATE.md + scaffolding + duplicate-artifact reconciliation only), no code or spec-body change; no `adversary` agent dispatched. The F1 scope/design decisions this burst records were reached via architect + business-analyst delta analysis followed by human approval, not an adversarial review pass.

**Outcome:** cycle-005 (`adf-mentions`) is OPEN, Phase F1 APPROVED (DEC-344), Phase F2 (spec evolution) dispatched. No BC/VP/holdout counts changed this burst (742/55/106/172 unchanged) — F1 is analysis-only; new BCs/VPs land at F2. Projected at F1 (to be finalized at F2): ~750-751 BCs / ~61 VPs / 107-111 holdouts / 176-178 stories.

**Files touched (Dim-1): 7 unique files/paths this burst (5 created/modified, 2 removed), all committed in the state-manager's own single atomic commit**

- `STATE.md` (modified)
- `cycles/cycle-004/session-checkpoints.md` (modified — archives the v3.74 checkpoint)
- `cycles/cycle-005/burst-log.md` (created — this file)
- `cycles/cycle-005/session-checkpoints.md` (created — empty archive)
- `phase-f1-delta-analysis/cycle-005/artifact-mapping.md` (modified — "Alternative decomposition (F2 input)" note appended)
- `cycles/cycle-005/phase-f1-delta-analysis/artifact-mapping.md` (removed — duplicate, reconciled into the file above)
- `cycles/cycle-005/phase-f1-delta-analysis/` (removed — now-empty directory)

(`phase-f1-delta-analysis/cycle-005/delta-analysis.md` and `affected-files.txt` were created by the architect in a prior step this same burst, not by this state-manager commit.)

**Dim-2 Attestation:** No BC/VP/holdout INDEX content changed this burst (F1 is analysis-only; the artifact-mapping.md amendment is a proposal note, not a binding BC/VP body). Counts unchanged: 742 BCs / 55 VPs / 106 holdouts / 172 stories. DEC-namespace collision check: DEC-344 is the next sequential ID after DEC-343, no collision.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (this burst is spec-analysis + bookkeeping only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change this burst — cycle-005 is at Phase F1→F2, spec-only. `develop` HEAD unchanged at `569d85a8`.

**Dim-7 Attestation:** N/A — no CI-relevant change this burst (no code, no workflow file touched).

**Codifications:** **DEC-344** — human APPROVED cycle-005 (`adf-mentions`, #674) Phase F1 delta analysis: full scope and design decisions as enumerated in Action 5 above. No BC/VP/holdout added, removed, or renumbered by this burst (742/55/106/172 all unchanged) — F1 proposals recorded as candidates only, pending F2 authorship.

**Closes:** cycle-005 Phase F1 (delta analysis) — human-approved. The duplicate F1 artifact-mapping.md coordination error — reconciled, not left as unresolved drift. **Does NOT close:** cycle-005 itself, which remains open through F2-F7; the `VP-COUNT-RECONCILIATION` tracked follow-up (non-blocking, target a future maintenance/self-improvement cycle); any of the carried-forward cycle-001/002/003/004 standing items (all unchanged, condensed for length only).

### Details

| Agent | Task | Output |
|-------|------|--------|
| architect | F1 delta analysis — architectural impact, affected files | `phase-f1-delta-analysis/cycle-005/delta-analysis.md`, `affected-files.txt` |
| business-analyst (run 1) | F1 delta analysis — BC/VP artifact-mapping proposal | `phase-f1-delta-analysis/cycle-005/artifact-mapping.md` (canonical) |
| business-analyst (run 2, duplicate) | F1 delta analysis — BC/VP artifact-mapping proposal (orchestrator coordination error, re-dispatched) | `cycles/cycle-005/phase-f1-delta-analysis/artifact-mapping.md` (reconciled into canonical this burst, then removed) |
| state-manager | cycle-005 init; duplicate reconciliation (diff + alternative-decomposition note + removal); DEC-344 recording; STATE.md v3.75 full-content Write; archive v3.74 checkpoint; commit + push to `factory-artifacts` | `STATE.md` (v3.75); `cycles/cycle-005/burst-log.md` (this file); `cycles/cycle-005/session-checkpoints.md`; `cycles/cycle-004/session-checkpoints.md` (appended) |

---

## Burst: Burst 2 — Phase F2 spec evolution APPROVED (DEC-346); F2-gate TIGHTENING decision (DEC-345); F2-close INTEGRATE reconciliation; phase advances F2→F3 (2026-09-06)

**Parent-commit:** `569d85a8` (`develop` tip; unchanged this burst — no `develop`-side commit; F2/F3 are spec-only phases, no code merged).

**Trigger:** Phase F2 spec evolution (architect + product-owner + formal-verifier, across multiple INTEGRATE sub-bursts) authored the binding BCs/VPs/holdouts/ADR from the two F1 decomposition proposals, then ran 10 rounds of scoped adversarial review to convergence (passes 7-10 all 0-CRIT/HIGH/MED, cosmetic-only) and a pre-gate consistency audit (CONSISTENT verdict). The human then reviewed the F2 delta at the gate, issued one F2-gate TIGHTENING decision on `@Name` single-result resolution (DEC-345), and APPROVED F2 in full (DEC-346). This state-manager burst is the catch-up/close-out step: recording both decisions in STATE.md (neither had yet been logged there), performing the 6-item F2-close INTEGRATE reconciliation sweep the orchestrator identified as non-blocking propagation gaps, and advancing the tracked phase to F3.

**Actions this burst:**

1. Verified `.factory/` worktree preconditions (`.git` marker, `git rev-parse --git-dir`, branch `factory-artifacts`) — all PASS. No `project.yaml` (single-repo; `.factory-project/` preconditions N/A).
2. Confirmed via direct inspection of `.factory/specs/prd/*.md`, `BC-INDEX.md`, `holdout-scenarios.md`, `cross-cutting.md`, and `.factory/architecture/component-graph.md` that the substantive F2 spec-evolution work (12 new BCs, ADR-0023, 21 VPs across `VP-674-001..021`, 12 holdout scenarios `H-NEW-MENTION-001..012`, the DEC-345 `filter_by_name_match` tightening amendment to BC-X.7.007, and the full Markdown Mentions Delta DAG-verification section in `component-graph.md`) was already present and internally consistent — BC-INDEX.md (`total_bcs: 754`, `index_version: v6.86`), `holdout-scenarios.md` (`total_holdouts: 118`), and `CANONICAL-COUNTS.md`'s per-file/Sum/grand-total rows and `last_verified` narrative all already reflected the final, reconciled state. The gaps were confined to cross-reference/bookkeeping documents that had not been swept in the same pass: `spec-changelog.md`, `CANONICAL-COUNTS.md`'s `## ADRs` section, `system-overview.md`, `specs/prd/README.md`, and the two F2 delta files' `status:` fields.
3. Minted **DEC-345** (F2-gate tightening) and **DEC-346** (F2 approval) in STATE.md's Decisions Log.
4. Performed the 6-item F2-close INTEGRATE cleanup sweep:
   - `spec-changelog.md` `[2.2.0]` entry: corrected "6 existing BCs amended" → **7** (the original text already listed 7 IDs — BC-7.2.004 + 6 cross-reference-only BCs — but the header undercounted); corrected VP count 17→**21** (55→76 running total) and holdout count 9→**12** (106→118 running total); added a new paragraph documenting the post-entry adversarial-convergence and F2-gate tightening additions (pass-2 M-3's 2 holdouts, the F2-gate's BC-X.7.007 amendment + 1 holdout + 1 VP, and 3 further adversarial-pass VPs) that account for the corrected totals, including the JSM `--request-type` wiring (BC-3.8.018) already covered in the original entry.
   - `.factory/architecture/component-graph.md`: **already contained** the full "Markdown Mentions Delta — DAG Verification (Issue #674, F2 2026-09-06)" section with every edge named in the F2 architecture-delta (`cli::issue::mentions → adf`, `→ api::jira::users`, `→ cli::issue::helpers`, `→ error`, plus the four handler→mentions edges) and an explicit "DAG remains acyclic" verdict — no edit needed, confirmed only.
   - `.factory/architecture/system-overview.md`: fixed the dead-symbol citation `AdfToTextRenderer::render_node` → `AdfRenderer::render_node` (the real struct name; `AdfToTextRenderer` does not exist in `src/adf.rs`).
   - `.factory/specs/prd/README.md`: updated both informational holdout rows (Document Map + Supplement Index) from `115` / `H-NEW-MENTION-001..H-NEW-MENTION-009` to `118` / `H-NEW-MENTION-001..H-NEW-MENTION-012`.
   - `.factory/specs/prd/CANONICAL-COUNTS.md` `## ADRs`: bumped "Canonical ADR count: 19" → **23** (ADR-0001..0023, no gaps); added bullets for ADR-0020 (per-profile credential ownership), ADR-0021 (Windows DPAPI fallback), ADR-0022 (tenant_info cloud_id), and ADR-0023 (markdown mention conversion seam); updated the "Location convention" line's upper bound `ADR-0017..0019` → `ADR-0017..0023`. Additionally added the missing **ADR-0023** row to `.factory/architecture/adr-index.md`'s ADR Summary Table (that file's own row set stopped at ADR-0022) — without this, the CANONICAL-COUNTS.md verification instruction ("count rows in adr-index.md Summary Table") would itself have gone out of sync the moment the canonical count was bumped to 23.
   - `.factory/phase-f2-spec-evolution/prd-delta-674.md` and `verification-delta-674.md`: flipped `status: draft` → `status: complete` in both frontmatter blocks (F2 is now human-approved).
5. Re-ran the three required count-verification scripts — all exit 0 (see Dim-2 Attestation).
6. Logged two new process-gap follow-ups (`ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`) alongside the carried-forward cycle-004 process-gap backlog, unchanged.
7. Advanced the tracked phase: `cycle-005 (adf-mentions) Phase F2 spec evolution APPROVED; Phase F3 (incremental story decomposition) IN PROGRESS.`

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched. The 10-pass adversarial-review convergence and pre-gate consistency audit this entry records were run by prior F2 spec-evolution sub-bursts (not by this bookkeeping/INTEGRATE-cleanup burst); their outcome (passes 7-10 all 0-CRIT/HIGH/MED, cosmetic-only; pre-gate audit CONSISTENT) is cited above as context for DEC-346, not re-run here.

**Files touched (Dim-1): 10 unique files/paths this burst (all `.factory/` — 8 modified, 1 archived-content update, 1 this burst's own log entry), all committed in the state-manager's own single atomic commit**

- `.factory/spec-changelog.md` (corrected `[2.2.0]` entry counts + added post-entry-additions paragraph)
- `.factory/specs/prd/CANONICAL-COUNTS.md` (`## ADRs` section: 19→23, 4 new bullets, location-convention range extended)
- `.factory/architecture/adr-index.md` (added missing ADR-0023 Summary Table row)
- `.factory/architecture/system-overview.md` (dead-symbol citation fix: `AdfToTextRenderer` → `AdfRenderer`)
- `.factory/specs/prd/README.md` (2 holdout-count rows: 115→118, `H-NEW-MENTION-001..009` → `..012`)
- `.factory/phase-f2-spec-evolution/prd-delta-674.md` (`status: draft` → `complete`)
- `.factory/phase-f2-spec-evolution/verification-delta-674.md` (`status: draft` → `complete`)
- `STATE.md` (v3.76 — full-content Write)
- `cycles/cycle-005/session-checkpoints.md` (v3.75 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)

**Known hook noise this burst (pre-existing, not caused by this burst's edits, not blocking):** `validate-template-compliance` fired on the `system-overview.md` edit (that file has never carried the `architecture-section-template.md` frontmatter/section structure — pre-existing drift, unrelated to the one-line citation fix made here); `validate-input-hash` fired on the `verification-delta-674.md` edit (this file is one of the 165 factory-wide stale-`input-hash` artifacts tracked under `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING`); `validate-input-hash`/`validate-factory-path-root`/`validate-template-compliance` also reported `FUEL_EXHAUSTED` on the large `spec-changelog.md` edit. All edits were grep/script-verified to have landed correctly regardless (see Actions 4-5 above); logged as `FACTORY-HOOK-FUEL-EXHAUSTED`, a tracked engine-tooling process-gap, not a jira-cli product defect.

**Dim-2 Attestation:** `bash scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `bash scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (754 total across 9 files; Surface H footer checked where present)"). `bash scripts/check-bc-citation-symbols.sh` → exit 0 ("Check passed: 463 citations checked"). Counts entering F3: **754 BCs / 76 VPs (tracked running total; +21 net-new `VP-674-NNN` ids this cycle; the pre-existing `VP-COUNT-RECONCILIATION` gap — raw-grepped VP ids across `bc-*.md` bodies materially exceeding the tracked running total — remains open and non-blocking) / 118 holdout scenarios / 172 stories (unchanged; F3 will add cycle-005's story files)**. DEC-namespace collision check: DEC-345 and DEC-346 are the next two sequential IDs after DEC-344, no collision.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change this burst — cycle-005 remains spec-only through F2/F3. `develop` HEAD unchanged at `569d85a8`.

**Dim-7 Attestation:** N/A — no CI-relevant change this burst (no code, no workflow file touched).

**Codifications:** **DEC-345** — human F2-gate TIGHTENING decision: a lone `@Name` search result whose display name does NOT case-insensitively-substring-match the query now HARD ERRORS (exit 64) via a new pure `filter_by_name_match` pre-filter step inserted between the active-user filter and `disambiguate_user`, rather than silently resolving; `disambiguate_user` itself is unchanged; `MatchResult::None` is thereby unreachable via the mention resolver's call site. Resolves EC-X.7.007-5's former open decision; supersedes the architect's own pass-through recommendation from `delta-analysis.md`. Ref ADR-0023 §7; implemented in BC-X.7.007 (amended in place, `cross-cutting.md`); 1 new holdout scenario (H-NEW-MENTION-012) and 1 new VP (VP-674-021). **DEC-346** — human APPROVED cycle-005 (`adf-mentions`, #674) Phase F2 spec evolution in full: 12 new BCs (BC-7.2.016..019, BC-X.7.007..010, BC-3.3.012/BC-3.4.032/BC-3.5.013/BC-3.8.018) + 7 BCs amended in place (BC-7.2.004 + 6 cross-reference-only amendments) + the DEC-345 BC-X.7.007 tightening amendment; new ADR-0023; 21 VPs (`VP-674-001..021`); 12 holdout scenarios (`H-NEW-MENTION-001..012`, including H-009 the human-required live-Jira E2E round-trip); spec version 2.1.0→2.2.0 (MINOR). Adversarial convergence reached over 10 passes (passes 7-10 all 0-CRIT/HIGH/MED, cosmetic-only); pre-gate consistency audit verdict CONSISTENT. Phase advances F2→F3.

**Closes:** cycle-005 Phase F2 (spec evolution) — human-approved; the 6-item F2-close INTEGRATE reconciliation sweep the orchestrator dispatched (all 6 confirmed landed — 5 required an edit, 1 — `component-graph.md` — was already complete and confirmed only). **Does NOT close:** cycle-005 itself, which remains open through F3-F7; the pre-existing `VP-COUNT-RECONCILIATION` tracked follow-up (still non-blocking); the newly-logged `ADR-COUNT-CANONICAL-GUARD-GAP` and `FACTORY-HOOK-FUEL-EXHAUSTED` process-gaps (both target future engine/maintenance work, neither blocks cycle-005); any of the carried-forward cycle-001/002/003/004 standing items (all unchanged).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Verified F2 spec-evolution artifacts already present/consistent; minted DEC-345/DEC-346; performed 6-item F2-close INTEGRATE cleanup sweep; re-ran count-verification scripts; logged 2 new process-gaps; STATE.md v3.76 full-content Write; archived v3.75 checkpoint; commit + push to `factory-artifacts` | `spec-changelog.md`, `CANONICAL-COUNTS.md`, `adr-index.md`, `system-overview.md`, `README.md` (specs/prd), `prd-delta-674.md`, `verification-delta-674.md`, `STATE.md` (v3.76), `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-005/session-checkpoints.md` |

---

## Burst: Burst 3 — Phase F3 story decomposition APPROVED (DEC-347); input-hash refresh; F4 wave tracking setup; phase advances F3→F4 (2026-09-06)

**Parent-commit:** `569d85a8` (`develop` tip; unchanged this burst — no `develop`-side commit; F3/F4-dispatch are bookkeeping-only, no code merged yet).

**Trigger:** Phase F3 (incremental story decomposition), run by story-writer + adversary across prior sub-bursts, produced 2 stories (`S-cycle5-mention-pure-conversion` Wave 1, `S-cycle5-mention-resolution-wiring` Wave 2) plus a dependency graph and wave schedule, converging over 6 rounds of adversarial story review (passes 5-6 both CLEAN — F-H-01/F-H-02/F-M-01/F-M-02/F-M-03 fixed across earlier passes). The human then reviewed the complete F3 decomposition at the gate and **APPROVED** it in full (DEC-347). This state-manager burst records the decision, refreshes deferred `input-hash` drift left by the prior story-writer/adversary fix rounds (no shell access in those roles), registers the 2 approved stories in the repo's Phase-3/F4 wave-tracking convention (`.factory/sprint-state.yaml`, `cycle_NNN_<bundle>` top-level keys — this repo has no `sprint-state.yaml`/`wave-state.yaml` under `.factory/stories/` or per-cycle; the single top-level `.factory/sprint-state.yaml` is the established convention, confirmed by grepping every prior `cycle_*` section including `cycle_002_field_dx` and `cycle_004_windows_correctness`), and advances the tracked phase to F4.

**Actions this burst:**

1. Verified `.factory/` worktree preconditions (`.git` marker, `git rev-parse --git-dir`, branch `factory-artifacts`) — all PASS. No `project.yaml` (single-repo; `.factory-project/` preconditions N/A).
2. Minted **DEC-347** (F3 human gate APPROVAL) in STATE.md's Decisions Log: 2 stories — `S-cycle5-mention-pure-conversion` (Wave 1, 13 pts, priority P0/module_criticality CRITICAL, 15 ACs, `depends_on: []`, target `src/adf.rs`) + `S-cycle5-mention-resolution-wiring` (Wave 2, 13 pts, priority P0/module_criticality HIGH, 17 ACs, `depends_on: [S-cycle5-mention-pure-conversion]`, target `src/cli/issue/mentions.rs`); acyclic A→B dependency (Kahn-layering proven); 2 sequential waves; critical path 2 stories / 26 points (100% of cycle points). Story count 172→174 (already reflected in STORY-INDEX.md v1.6.16 from prior F3 authoring/fix bursts — this burst recorded the gate decision, it did not itself add the rows).
3. Refreshed deferred `input-hash` drift on the F3 story artifacts, per file:
   - `S-cycle5-mention-pure-conversion.md` — `--check` already clean (`90a5d3a`), no update needed.
   - `S-cycle5-mention-resolution-wiring.md` — DRIFT (`6b68f5f` ≠ computed `86fbb15`); `--update` applied → `86fbb15`.
   - `dependency-graph-extended.md` — DRIFT (`a6eb33d` ≠ computed `e9c8114`); `--update` applied. Because this file's `inputs:` list includes `S-cycle5-mention-resolution-wiring.md` (updated in the prior step), the hash actually written was **`ca77401`**, not the pre-update `e9c8114` snapshot — the cascade is expected and correct (update order matters: resolution-wiring before its dependents).
   - `wave-schedule.md` — DRIFT (`9eea75a` ≠ computed `37e32c0`); `--update` applied. Same cascade effect from the prior two updates → final hash **`b59b05c`**.
   - Re-ran `--check` on all 4 files after updating: all exit 0 (clean).
   - `STORY-INDEX.md` — checked per the orchestrator's dispatch instruction; direct tool invocation returned `compute-input-hash: no inputs: field found in frontmatter` (exit 1). This file carries no `inputs:`/`input-hash:` frontmatter fields at all (confirmed via `grep -n "^inputs\|^input-hash" STORY-INDEX.md` → zero matches) — it is not tracked by the `compute-input-hash` mechanism by design (an index file with no declared inputs, unlike a derived artifact). **No action possible or needed; not a drift case.**
4. Registered the 2 approved stories in `.factory/sprint-state.yaml` under a new top-level `cycle_005_adf_mentions:` section, following this repo's established convention (grepped every prior `cycle_*` top-level key in the file — `cycle_002_field_dx`, `cycle_004_windows_correctness`, etc. — all use this single top-level file, not a per-cycle or per-stories-dir sprint-state/wave-state file): `wave_1_status` = READY (Story A, no deps, not yet dispatched), `wave_2_status` = BLOCKED (Story B, `depends_on: [S-cycle5-mention-pure-conversion]`, Wave 1 not yet merged), with per-story `bc_anchors`/`vp_anchors`/`holdout_anchors`/`points`/`priority`/`module_criticality` fields mirroring the format used by every prior cycle section in this file.
5. Re-ran the two count-verification scripts the orchestrator named (story count changed only; BC/holdout counts unaffected by an F3-gate decision) — both exit 0 (see Dim-2 Attestation).
6. Advanced the tracked phase: `cycle-005 (adf-mentions) Phase F3 story decomposition APPROVED; Phase F4 (delta implementation) IN PROGRESS — Wave 1 (Story A, S-cycle5-mention-pure-conversion).`
7. Carried forward all standing process-gaps unchanged (`VP-COUNT-RECONCILIATION`, `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`, and every cycle-001/002/003/004 historical item) — no new process-gap identified this burst.

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched. The 6-pass adversarial story-convergence loop this entry records (passes 5-6 both CLEAN) was run by prior F3 story-decomposition sub-bursts (story-writer + adversary), not by this bookkeeping burst; cited above as context for DEC-347, not re-run here.

**Files touched (Dim-1): 7 unique files/paths this burst (all `.factory/` — 3 story-artifact input-hash updates, 1 wave-tracking registration, 1 STATE.md rewrite, 2 cycle-005 log files), all committed in the state-manager's own single atomic commit**

- `.factory/cycles/cycle-005/phase-f3-stories/S-cycle5-mention-resolution-wiring.md` (`input-hash` refreshed `6b68f5f` → `86fbb15`)
- `.factory/cycles/cycle-005/phase-f3-stories/dependency-graph-extended.md` (`input-hash` refreshed `a6eb33d` → `ca77401`)
- `.factory/cycles/cycle-005/phase-f3-stories/wave-schedule.md` (`input-hash` refreshed `9eea75a` → `b59b05c`)
- `.factory/sprint-state.yaml` (new `cycle_005_adf_mentions:` top-level section — Wave 1 ready, Wave 2 blocked-on-Wave-1)
- `STATE.md` (v3.77 — full-content Write)
- `cycles/cycle-005/session-checkpoints.md` (v3.76 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)

**Known hook noise this burst (pre-existing, not caused by this burst's edits, not blocking):** none newly observed. The standing `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` debt (165 factory-wide stale artifacts) is unaffected — the 3 files refreshed this burst were addressed because the orchestrator explicitly named them as this cycle's own deferred drift, not as a draw against that separately-tracked batch debt.

**Dim-2 Attestation:** `bash scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `bash scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (754 total across 9 files; Surface H footer checked where present)"). Counts entering F4: **754 BCs / 76 VPs (tracked running total, unchanged this burst) / 118 holdout scenarios (unchanged) / 174 stories (172→174, +2 cycle-005 rows)**. DEC-namespace collision check: DEC-347 is the next sequential ID after DEC-346, no collision.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change this burst — cycle-005 remains spec/tracking-only through F3→F4 dispatch. `develop` HEAD unchanged at `569d85a8`.

**Dim-7 Attestation:** N/A — no CI-relevant change this burst (no code, no workflow file touched).

**Codifications:** **DEC-347** — human APPROVED cycle-005 (`adf-mentions`, #674) Phase F3 story decomposition in full: 2 stories (`S-cycle5-mention-pure-conversion` Wave 1 13pts CRITICAL 15 ACs `depends_on:[]`; `S-cycle5-mention-resolution-wiring` Wave 2 13pts HIGH 17 ACs `depends_on:[S-cycle5-mention-pure-conversion]`); acyclic A→B dependency; 2 sequential waves; critical path 26 points; story count 172→174. Reached via 6 rounds of adversarial story convergence (passes 5-6 CLEAN); all 13 in-scope BCs / 21 VPs / 12 holdouts mapped across the two stories (three-surface EC reconciliation proof). Phase advances F3→F4.

**Closes:** cycle-005 Phase F3 (incremental story decomposition) — human-approved. **Does NOT close:** cycle-005 itself, which remains open through F4-F7; any carried-forward standing item (all unchanged, see Constraints Carried Forward in STATE.md); the newly-registered F4 wave tracking is a `ready`/`blocked` starting state, not a delivery outcome — Wave 1 (`S-cycle5-mention-pure-conversion`) has not yet been dispatched to an implementer.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Minted DEC-347; refreshed 3 stale `input-hash` values (1 already clean); registered 2 stories in `.factory/sprint-state.yaml` F4 wave tracking; re-ran count-verification scripts; STATE.md v3.77 full-content Write; archived v3.76 checkpoint; commit + push to `factory-artifacts` | `S-cycle5-mention-resolution-wiring.md`, `dependency-graph-extended.md`, `wave-schedule.md` (input-hash refresh), `sprint-state.yaml` (new section), `STATE.md` (v3.77), `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-005/session-checkpoints.md` |

---

<!-- Repeat for each burst. Maintain chronological order. -->
