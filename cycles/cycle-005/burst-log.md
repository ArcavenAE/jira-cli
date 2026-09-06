---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-06T18:30:00Z
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

<!-- Repeat for each burst. Maintain chronological order. -->
