---
audit_id: GATE-AUDIT-576
feature: SOH-ATTACHMENTS-1
issues: "#576 + #585"
spec_version_audited: 1.3.78
bc_count: 657 (33 new BCs; BC-2.7.001..012 + BC-3.9.001..020 + BC-X.8.010)
holdout_count: 100 (12 new; Group 19, H-NEW-ATTACHMENT-001..012)
vp_count: 35 (5 new; VP-576-001..005)
stories: "S1..S5"
auditor: consistency-audit-agent (fresh context, SOH-ATTACHMENTS-1 F2 gate)
audit_date: 2026-07-17
protocol: FRESH-CONTEXT PRE-GATE CONSISTENCY AUDIT — perimeter-level, independent of adversary loop
source_instructions: teammate message from team-lead, 2026-07-17
verdict: GAPS-FOUND — 2 LOW gaps, 1 INFO item; neither gap is blocking the F2 gate
---

# Pre-Gate Consistency Audit — SOH-ATTACHMENTS-1 F2

## Audit Protocol

This audit is a PERIMETER-LEVEL consistency check, NOT a re-run of the adversary loop. The adversary loop (40 passes, STRICT-converged at p38/p39/p40 CLEAN×3) checked internal consistency within the perimeter it was shown. This audit checks whether the perimeter itself is correct. "Previously-converged" does not mean "correct." All claims are derived from fresh reads of the artifacts listed; prior consistency reports were not treated as evidence.

Artifacts read: `prd-delta-576.md`, `STATE.md`, `research/issue-576-attachments-api-2026-07-15.md`, `security-review-576.md`, `impact-boundary-576.md`, `CANONICAL-COUNTS.md`, `BC-INDEX.md`, `bc-2-issue-read.md`, `bc-3-issue-write.md`, `cross-cutting.md`, `holdout-scenarios.md`, `spec-changelog.md`.

---

## Perimeter Question 1: Scope Completeness vs Source Issues #576 + #585

**Verdict: CLEAN**

The ratified scope from DEC-179 (F1 approval) and DEC-180 (adversary-pass-1 scope expansion) comprises:

| Surface | Covering BCs | Status |
|---------|-------------|--------|
| `jr issue attachment list` (table + `--filter` mime/name/size-max, `--newest N`) | BC-2.7.001..006 | ✓ |
| `attachment download <KEY> --id <AID>` single-file (`--out`, `--force`, overwrite-refuse) | BC-2.7.007 (line 743: "`--force` flag bypasses this check and overwrites silently") | ✓ |
| `attachment download` batch (`--all`, `--out-dir`, `--newest`) | BC-2.7.008..010 | ✓ |
| Filename sanitization (CWE-22, Windows device names, SHA-1 prefix for batch, bare basename for single) | BC-2.7.011 | ✓ |
| Download error table (KEY-404, AID-404, AID-403, KEY-403, auth) | BC-2.7.012 | ✓ |
| `attachment upload <KEY> <FILE...>` platform POST | BC-3.9.001..002 | ✓ |
| Upload `--public` (servicedeskapi two-step, gate) | BC-3.9.003..007 | ✓ |
| Upload `--internal` (servicedeskapi, OQ-9 silent no-op on non-JSM) | BC-3.9.004, BC-3.9.011 | ✓ |
| Upload `--replace-existing` (list-first → gate → delete → upload, R3.12 ≥1-match gate) | BC-3.9.017..018 | ✓ |
| Upload `--dry-run` (requires `--replace-existing`) | BC-3.9.020 | ✓ |
| Upload errors (KEY-404/403, 413 too-large, auth) | BC-3.9.009, BC-3.9.012..014 | ✓ |
| `attachment delete <AID>` single-file (confirmation gate, DEC-174 mechanism) | BC-3.9.008, BC-3.9.015 | ✓ |
| `attachment delete` multi-ID bulk (2+ positional → `--yes` required, R3.8a) | BC-3.9.013, BC-3.9.015 | ✓ |
| `attachment delete --older-than <DURATION>` (chrono semantics, `--yes` required) | BC-3.9.016, BC-3.9.019 | ✓ |
| Delete errors | BC-3.9.010 | ✓ |
| serviceDeskId resolution via existing ProjectMeta cache (NOT a new cache) | BC-X.8.010 | ✓ |
| `#585` absorbed: `contentUrl` field in attachment-object serialization | BC-2.7.002 (VP-576-004 pin: `"self"` omitted, `"content"` → `"contentUrl"`) | ✓ |

Single-download bare-basename vs batch SHA-1-prefix distinction: BC-2.7.007 governs single-file path (bare sanitized basename or `--out <PATH>`); BC-2.7.010 governs batch path (`<sha1-of-id>_<sanitized-basename>`). Both paths are correctly distinct and covered.

No ratified surface is missing a covering BC.

---

## Perimeter Question 2: Cross-Cutting Perimeter

**Verdict: GAPS-FOUND — 1 LOW gap**

### Items Verified CLEAN

**Edge-case-catalog (inline-EC convention acceptance)**: Accepted and recorded at P16-INFO (prd-delta line 313). Impact-boundary R3.14 retro-annotation documents: "edge-case-catalog.md inline-EC convention accepted as deliberate (no content action required)." Acceptance IS recorded. CLEAN.

**NFR catalog**: Impact-boundary §2.3 maps all attachment surfaces to EXISTING NFRs (JSON render invariant, `--no-input`, exit codes, idempotency, output channel profiles, `allow_hyphen_values`). No new NFR-catalog entries required. CLEAN.

**docs/specs/attachments.md**: Correctly classified as F4 delivery obligation (P14-008 retro-annotation: "this is an F4 delivery obligation — it must exist by the time the feature ships, not necessarily before F2 spec-writing begins"). Not a blocking F2 perimeter gap. CLEAN.

**Error taxonomy**: Impact-boundary R3.14 + prd-delta P16-001 (4 new override rows added: attachment list 404, attachment download 404, attachment delete 404 split two-sub-case, attachment upload 413). CLEAN.

### GAP-AUDIT-576-001 (LOW): Product-side perimeter deliverables not BC-promoted

The following obligations are recorded in impact-boundary §3.1 and §3.3/§3.4 but have NOT been promoted to BC-level delivery-task ECs:

| Obligation | Where recorded | BC-level EC? | #577 precedent |
|-----------|---------------|-------------|----------------|
| `docs/specs/json-output-shapes.md` — add attachment rows | impact-boundary §3.1 (line 194) | No | EC-3.5.012-5(h) added at DEC-170 gate closure |
| `README.md` command table — add `jr issue attachment` rows | impact-boundary §3.3 (implied by new subcommand tree) | No | EC-3.5.012-5(f) added at pass 35 |
| `CHANGELOG.md` — `feat(issue): attachment list/download/upload/delete` entry | impact-boundary §3.1 (line 195) | No | Covered by EC-3.5.012-5 family |
| `CLAUDE.md` — 4 gotcha items + src-tree + AI Agent Notes | impact-boundary §3.4 | No | EC-3.5.012-5(g) added at pass 35 |
| `tests/e2e_cli_surface_guard.rs` — SURFACE entries for `attachment` subcommands | impact-boundary §3.3 | No | covered in surface guard BC |
| `.cargo/mutants.toml` — globs for `src/cli/issue/attachments.rs` + `src/api/jira/attachments.rs` | impact-boundary §3.3 | No | — |

For #577 (comment CRUD), these obligations were escalated to BC-level delivery tasks (EC-3.5.012-5(f)+(g)+(h)+(i)) at the DEC-170 F2 gate closure because the consistency audit caught the gap. For #576, the obligations exist only in the impact-boundary artifact.

**Risk**: F3 story writers reading the prd-delta scope table without consulting impact-boundary §3.1/§3.3/§3.4 may miss these product-side deliverables. The story template typically references the prd-delta scope table as the primary checklist.

**Severity: LOW** — The obligations ARE documented (impact-boundary §3.1/§3.4 is a required F2 input per convention), the adversary passes converged without surfacing this as a finding, and the story writer protocol mandates reading the impact-boundary. However, the #577 precedent shows that BC-promotion was the correct mitigation for exactly this class of risk at the DEC-170 closure.

**Disposition for gate presentation**: Flag for human review. If the gate approver accepts the impact-boundary-level recording as sufficient, the gap is closed. Alternatively, the state-manager may add a delivery-obligation note to the prd-delta S1/S3/S5 scope rows at gate closure, mirroring the DEC-170 pattern.

---

## Perimeter Question 3: Story-Decomposition Readiness

**Verdict: CLEAN**

The S1-S5 scope table in prd-delta-576.md is complete. Verified:

| Story | BCs allocated | VPs allocated | Depends_on |
|-------|--------------|--------------|------------|
| S1 (list + filter) | BC-2.7.001..006 (6) | VP-576-001 | — |
| S2 (download) | BC-2.7.007..012 (6) | VP-576-002 (delete gate) | — |
| S3 (upload platform + --replace-existing + --dry-run path-c) | BC-3.9.001..002, BC-3.9.009, BC-3.9.012, BC-3.9.014, BC-3.9.017..018, BC-3.9.020 path-c (8) | VP-576-003 (replace-existing ordering), VP-576-004 (JSON transform) | S1 |
| S4 (delete) | BC-3.9.008, BC-3.9.010, BC-3.9.013, BC-3.9.015..016, BC-3.9.019, BC-3.9.020 paths-a/b (7) | VP-576-002 (allocations in S2 for delete gate test) | — |
| S5 (JSM visibility) | BC-3.9.003..007, BC-3.9.011, BC-X.8.010 (7, plus deferred probe obligations BC-3.9.007 EC-2 + BC-3.9.011) | VP-576-005 | S3 |

Total BC allocation: 6+6+8+7+7 = 34 slots across 5 stories covering all 33 BCs (BC-3.9.020 is shared: path-c in S3, paths-a/b in S4). All 5 VPs allocated. All 12 Group-19 holdouts allocated by story.

depends_on edges recorded: S5→S3 (JSM gate mechanics, BC-3.9.017 ships S3), S3→S1 (curated-serialization plumbing, VP-576-004 full cross-path test). Both are traceable in prd-delta scope table and BC annotations.

Deferred probe obligation (P2-3c INCONCLUSIVE): prd-delta lines 122-130 explicitly record that the S5 implementer must: (1) live-capture `POST /rest/servicedeskapi/request/{id}/attachment` response; (2) update BC-3.9.007 EC-2 and BC-3.9.011; (3) add a JSON Output Shape Contracts row in bc-3-issue-write.md; (4) mark P2-3c SATISFIED in the research file. This obligation is correctly allocated to S5 and is traceable.

F3 story authoring may proceed.

---

## Perimeter Question 4: Security Perimeter

**Verdict: GAP-AUDIT-576-002 (LOW) — Scoped sign-off recommended before F4 S4 delivery; not blocking F2**

The security review (`security-review-576.md`) was conducted at spec v1.3.44 (fix round A). Input hash fa52806. Verdict: APPROVE (1 MEDIUM, 5 LOW, 1 INFO — all resolved). Review covered 27 BCs: BC-2.7.001..012, BC-3.9.001..014, BC-X.8.010.

**Delta since v1.3.44 to v1.3.78 — security-relevant changes NOT seen by the reviewer:**

1. **P7-001: CWE-88 AID numeric validation** (v1.3.47, after review). `^[0-9]+$` guard added across all delete surfaces (BC-3.9.008/013/015/016/020). This STRENGTHENS the security posture — it closes AID injection by rejecting non-numeric IDs before any HTTP call. The security reviewer would likely have required this; it was not in scope of their review. This is a net-positive defensive addition.

2. **BC-3.9.015..020 not reviewed** (added in round B, after review). The 6 new BCs cover: delete confirmation gate (BC-3.9.015, DEC-174 `eprint!+read_line`), multi-ID bulk `--yes` requirement (BC-3.9.016, R3.8a), `--replace-existing` ordering (BC-3.9.017, R3.8b gate-before-delete invariant), zero-match path (BC-3.9.018), `--older-than` duration semantics (BC-3.9.019), `--dry-run` (BC-3.9.020). None introduce new attack surfaces. The gate-before-delete ordering invariant (R3.8b) closes a data-loss race condition — a defensive change.

3. **P40-I2 closed at micro-round**: BC-3.9.008 AID validation CWE-88/CWE-22 dual-mapping note added. This is documentation clarity, not a security behavior change.

**Assessment**: The delta since v1.3.44 is entirely defensive (validation added, confirmation gates added, ordering invariants enforced). No new attack surfaces were introduced. The security reviewer's APPROVE verdict is not undermined by the delta.

**Recommendation**: The F2 gate is not blocked. Before F4 S4 delivery (the delete story, which implements BC-3.9.015..016/019/020 for the first time in production code), a lightweight scoped sign-off on BC-3.9.015..020 for AID injection handling and gate ordering is prudent. This aligns with DEC-168 precedent (security review required for new access-control surfaces).

---

## Perimeter Question 5: Count/Index Final State

**Verdict: CLEAN with one INFO item**

Spot-check of all 8 check-bc-cumulative-counts.sh surfaces:

| Surface | Claim | Verified | Source |
|---------|-------|----------|--------|
| A — per-file frontmatter | bc-1=57, bc-2=106, bc-3=140, bc-4=32, bc-5=36, bc-6=43, bc-7=93, cross-cutting=150 | ✓ | Grepped frontmatter |
| D — CANONICAL-COUNTS.md per-file table | Sum=657, individually-bodied=427 | ✓ | CANONICAL-COUNTS.md read |
| E — BC-INDEX.md frontmatter total_bcs | 657 | ✓ | BC-INDEX.md grep |
| F — CANONICAL-COUNTS.md Sum row | 657 | ✓ | CANONICAL-COUNTS.md read |
| G — grand-total prose | "Canonical grand total: 657" | ✓ | CANONICAL-COUNTS.md read |

Arithmetic check: 57+106+140+32+36+43+93+150 = 657 ✓; 46+64+111+22+18+33+49+84 = 427 ✓

Holdout total: `holdout-scenarios.md` frontmatter `total_holdouts: 100` (12 new Group-19 items confirmed present). ✓

VP total: 35 (bc-3 footer confirms unchanged). ✓

BC-INDEX version: v6.33 (consistent with STATE.md). ✓

Both guards (check-bc-cumulative-counts.sh + check-spec-counts.sh) confirmed exit 0 in prd-delta closing micro-round echo-breaker. ✓

**INFO — STATE.md spec version**: STATE.md `current_step` references "spec v1.3.77" (the last adversary pass result). The closing micro-round (cosmetics fold, 1.3.77→1.3.78) has been applied to bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, prd-delta-576.md, and spec-changelog.md. STATE.md has not yet been updated to reflect v1.3.78. The state-manager should update STATE.md `current_step` to reflect spec v1.3.78 at gate presentation. This is a documentation lag, not a consistency error — the live spec IS at v1.3.78.

prd-delta-576.md frontmatter: `spec_version_after: 1.3.78` ✓ (matches BC changelogs)

---

## Perimeter Question 6: Carried-Cosmetics Ledger

**Verdict: CLEAN**

The closing-round cosmetics fold (prd-delta-576.md lines 709-728, rows 1-14) records:

| Row | Item | Disposition | Load-bearing? |
|-----|------|-------------|---------------|
| 1 | P38-I1: BC-2.7.002 `302/303-redirects` parity | FOLD | n/a — applied |
| 2 | P39-I1: impact-boundary §2.2 table-head annotation | FOLD | n/a — applied |
| 3 | P39-I2: EC-2.7.001-2 N==M clause | FOLD | n/a — applied |
| 4 | P39-I3: H-NEW-ATTACHMENT-007 id 60004 description | FOLD | n/a — applied |
| 5 | P40-I1: VP-576-003 assertion (b) reword | FOLD | n/a — applied |
| 6 | P40-I2: CWE-88/CWE-22 dual-mapping note | FOLD | n/a — applied |
| 7 | P40-I3: dry-run path-b/c holdout coverage observation | DISPOSITION ONLY | No — path-b/c ECs fully specified in BC bodies; coverage observation only |
| 8 | INFO-1: triple blank lines after EC-2.7.008-6 | FOLD | n/a — applied |
| 9 | INFO-2: EC-2.7.008-5/EC-2.7.008-2 redundant pair | ACCEPTED-CARRIED | No — cosmetic; "merging risks renumbering downstream; carry to F3 cleanup" |
| 10 | INFO-3: BC-2.7.012 download-scope multi-sentence comment | ACCEPTED-CARRIED | No — cosmetic; "folding to one sentence would lose DEC-168/read-vs-write divergence context" |
| 11 | INFO-6: collision-skip exit-0 re-run holdout | ACCEPTED-CARRIED | No — "F3 test-matrix item; not a window cosmetic" |
| 12 | INFO-8: STATE.md version trailing | N/A | No — "self-heals each burst; not a spec artifact" |
| 13 | INFO-15: impact-boundary BC-3.9.004 INCONCLUSIVE annotation | ACCEPTED-CARRIED | No — "already correctly annotated per prior pass; no substantive change needed" |
| 14 | INFO-NEW-5: BC-3.9.009 Trace missing P24-001 citation | FOLD | n/a — applied |

Counts: **8 FOLD** (rows 1-6, 8, 14) + **1 DISPOSITION ONLY** (row 7) + **4 ACCEPTED-CARRIED** (rows 9-11, 13) + **1 N/A** (row 12) = 14 items total.

All 4 accepted-carried items are cosmetic. None affects observable behavior, BC semantics, holdout assertions, or VP pass/fail criteria. None is load-bearing.

---

## Findings Summary

| ID | Severity | Verdict | Description |
|----|----------|---------|-------------|
| GAP-AUDIT-576-001 | LOW | Gap | Product-side perimeter deliverables (`docs/specs/json-output-shapes.md`, `README.md`, `CHANGELOG.md`, `CLAUDE.md`, e2e surface guard, mutants.toml) recorded only in impact-boundary §3.1/§3.3/§3.4 — not BC-promoted as delivery-task ECs. Contrast: #577's EC-3.5.012-5(f)+(g)+(h)+(i) at DEC-170 gate closure. Risk: story writers may miss product-side deliverables if impact-boundary is not consulted. |
| GAP-AUDIT-576-002 | LOW | Gap | Security review (v1.3.44, APPROVE) predates CWE-88 AID validation (P7-001, v1.3.47) and BC-3.9.015..020. Delta is entirely defensive (no new attack surfaces). Recommend scoped spot-check before F4 S4 (delete story) delivery. Not blocking the F2 gate. |
| INFO-AUDIT-576-001 | INFO | Note | STATE.md `current_step` still references "spec v1.3.77"; live spec is v1.3.78 after cosmetics fold. State-manager update needed at gate presentation. |

**Overall gate verdict: GAPS-FOUND — 2 LOW gaps, 1 INFO item. Neither gap blocks the F2 gate.** The spec is internally consistent, all 33 BCs are present and correctly allocated, the 40-pass adversary convergence was genuine, and the cosmetics fold was applied correctly. The two gaps are process/delivery-tracking risks, not behavioral-spec deficiencies.

---

## Gate Presentation Checklist

For the gate presenter to action before or at the human gate decision:

1. **GAP-AUDIT-576-001**: Decide disposition — either (a) accept impact-boundary §3.1/§3.4 recording as sufficient and document the decision, or (b) add delivery-obligation notes to prd-delta scope rows S1/S3/S5 at gate closure mirroring the DEC-170 EC-3.5.012-5 pattern. Recommended: option (b) for parity with the #577 precedent.

2. **GAP-AUDIT-576-002**: Record a state-manager note in STATE.md that BC-3.9.015..020 + CWE-88 AID validation require a scoped security spot-check before F4 S4 delivery (delete story). No action required before the F2 gate itself.

3. **INFO-AUDIT-576-001**: State-manager updates STATE.md `current_step` and phase progress table to reflect spec v1.3.78 (post-cosmetics-fold) before gate presentation.

---

*Audit conducted 2026-07-17. Fresh context — prior consistency reports were not used as evidence. All claims verified against artifact text at time of audit.*
