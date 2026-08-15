---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-08-15T00:00:00
phase: f2
inputs: [.factory/specs/prd/bc-8-components.md, .factory/phase-f2-spec-evolution/prd-delta-components.md, .factory/specs/prd/BC-INDEX.md, .factory/phase-f2-spec-evolution/verification-delta-components.md]
input-hash: "fec4827"
traces_to: .factory/phase-f2-spec-evolution/prd-delta-components.md
pass: 9
previous_review: .factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p8.md
---

# Adversarial Review: Component Management Bundle (Pass 9)

Adversarial Spec-Delta Review — Component Management (F2, pass 9). VERDICT: NOT CLEAN. 0 CRIT,
1 HIGH, 0 MEDIUM, 1 LOW, 2 INFO.

## Finding ID Convention

Finding IDs use the format: `ADV-P9-<SEV>-<SEQ>` (no cycle prefix — no `.factory/current-cycle`
file present for this bundle at review time).

## Part A — Fix Verification (pass >= 2)

| ID | Previous Severity | Status | Notes |
|----|-------------------|--------|-------|
| ADV-P8-MED-001 (BC-8.1.008 H1 omits `rename`) | MEDIUM | RESOLVED | H1 now reads "on `edit`/`delete`/`rename`", matching body/branch (2)/Trace/prd-delta/BC-INDEX |
| ADV-P8-LOW-001 (prd-delta VP-range handoff note stale) | LOW | RESOLVED | Range updated to 001..028; VP-citation-changes list extended with BC-3.4.020/BC-3.4.021 |

## Part B — New Findings

### HIGH

#### ADV-P9-HIGH-001: BC-8.2.008 H1 claims delete is "idempotent-friendly (exit 0)" — contradicts its own body, VP-COMPONENT-024, EC-8.2.008-1, and prd-delta

- **Severity:** HIGH
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.2.008 H1 (~L1322) vs Idempotency
  section (~L1334-1342), VP-COMPONENT-024 (~L1348-1362), EC-8.2.008-1 (~L1344-1346);
  `prd-delta-components.md` summary (~L69) and taxonomy (~L173)
- **Description:** The H1 reads "…a 404 on the target component is idempotent-friendly
  (exit 0)" but every other surface defining this BC's own behavior says the opposite: component
  delete is explicitly NOT idempotent. The Idempotency section states plainly "there is no
  idempotent-retry special case for component delete (unlike `issue move`'s already-in-target-
  state idempotency)" — a source-not-found at resolution time is the ordinary not-found exit-64
  path, and a `DELETE` call that itself races and 404s is `ApiError(404)` exit 1. VP-COMPONENT-024
  (the CANONICAL statement of this taxonomy, extended to `edit`/`rename`) pins exactly this:
  "NOT exit 0/idempotent-skip". EC-8.2.008-1 pins the race case as exit 1. `prd-delta-
  components.md`'s summary and taxonomy rows both describe delete as non-idempotent. The H1 is
  the sole outlier among five corroborating surfaces (body, VP, EC, prd-delta summary, prd-delta
  taxonomy) and appears to be stale pre-DEC-279 draft wording that survived 9 review passes
  because nothing downstream cites the H1 text itself.
- **Evidence:** H1 (L1322): "…a 404 on the target component is idempotent-friendly (exit 0)".
  Idempotency (L1334-1342): "…this is the ordinary not-found exit-64 path — NOT treated as
  'already deleted, exit 0'…there is no idempotent-retry special case for component delete". VP-
  COMPONENT-024 (L1348-1350): "SOURCE `NAME|ID` not found at resolution time → exit 64
  (`JrError::UserError`, ordinary not-found path, BC-8.1.008), zero `DELETE` calls issued — NOT
  exit 0/idempotent-skip." EC-8.2.008-1 (L1344-1346): concurrent-delete race → `ApiError(404)`,
  exit 1. `prd-delta-components.md` summary (~L69) and taxonomy (~L173): both state delete is
  NOT idempotent (source-not-found exit 64; DELETE-race exit 1) — matching `BC-INDEX.md`'s
  existing L662 row, which is already correct and unaffected by this finding.
- **Impact:** A story-writer or implementer reading only the H1 (the highest-visibility summary
  line of the BC, and the one that appears verbatim in tables-of-contents-style scans) could
  implement a false-success exit-0 on an irreversible delete operation — exactly the failure
  class DEC-279 (delete safety) exists to prevent. Title↔postcondition contradiction on a
  delete-safety-critical BC is HIGH, not MEDIUM: unlike ADV-P8-MED-001 (a scope-omission on a
  shared taxonomy BC), this is a direct behavioral reversal in the title of the taxonomy's own
  origin BC.
- **Proposed Fix:** Rewrite the H1 to match the body/VP/EC/prd-delta, e.g.: "BC-8.2.008:
  `--output json` delete result: `{"deleted","movedIssuesTo","affectedIssueCount",
  "affectedIssues"}`; component delete is NOT idempotent — source-not-found → exit 64,
  concurrent-delete race → exit 1." (mirrors `BC-INDEX.md`'s already-correct L662 wording).
  Title-only; no behavioral change. `BC-INDEX.md`'s Section-8 row for BC-8.2.008 requires no
  change — it already matches the body.

### LOW

#### ADV-P9-LOW-001: BC-8.2.002 `--output json` literal is a 3-key subset of BC-8.2.008's canonical 4-key shape — missing `affectedIssues`

- **Severity:** LOW
- **Category:** spec-fidelity
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.2.002 `--output json` literal
  (~L843-844) vs BC-8.2.008 canonical shape (~L1329-1331)
- **Description:** BC-8.2.002's inline `--output json` literal reads `{"deleted": "<sourceId>",
  "movedIssuesTo": "<targetId>", "affectedIssueCount": N}` — three keys. BC-8.2.008's Behavior
  section defines the canonical, DEC-279-driven shape as four keys: `{"deleted": "<sourceId>",
  "movedIssuesTo": "<targetId>" (or `null` under `--orphan`), "affectedIssueCount": N,
  "affectedIssues": ["<KEY-1>", ...]}`. The two literals describe the SAME wire response (both
  cite BC-8.2.007's snapshot as the source of `N`/the affected set) but only BC-8.2.008 carries
  `affectedIssues` — the reconstruction-record array that DEC-279/VP-COMPONENT-017 exists to
  guarantee (per BC-8.2.008's own Trace-adjacent text at ~L1227/L1271: "giving the user a
  reconstructable record independent of…", "defeating DEC-279's [reconstruction guarantee]").
  An implementer or test-writer building the JSON-emission code from BC-8.2.002 alone (the BC
  that actually defines the `--move-to` disposition's HTTP call and is the more natural
  "how do I build this payload" reference) would drop the fourth key, silently defeating the
  DEC-279 guarantee BC-8.2.008 is the canonical owner of.
- **Evidence:** BC-8.2.002 (L843-844): `` `--output json`: `{"deleted": "<sourceId>",
  "movedIssuesTo": "<targetId>", "affectedIssueCount": N}` `` — 3 keys, no `affectedIssues`.
  BC-8.2.008 (L1329-1331): `` `{"deleted": "<sourceId>", "movedIssuesTo": "<targetId>" (or
  `null` under `--orphan`), "affectedIssueCount": N, "affectedIssues": ["<KEY-1>", ...]}` `` — 4
  keys, canonical per BC-8.2.008's own H1 (once corrected by HIGH-1 above) and body.
- **Proposed Fix:** Replace BC-8.2.002's inline literal with an explicit cross-reference to
  BC-8.2.008's canonical shape ("`--output json` — see BC-8.2.008 for the full canonical
  4-key shape, including `affectedIssues`"), rather than duplicating (and risking future
  re-divergence of) the literal in two places. Recommended over adding `affectedIssues` inline
  a second time, since a second literal copy is exactly the mechanism that let this drift by
  one key in the first place.

### INFO

#### ADV-P9-INFO-001: BC-8.1.007 M1 lacks BC-8.2.002's config-default-project-mismatch documentation parity note

- **Severity:** INFO
- **Category:** documentation-parity
- **Location:** `.factory/specs/prd/bc-8-components.md` BC-8.1.007 M1 (~L446-473) vs BC-8.2.002's
  "Config-default-project scope" note (~L897-913)
- **Description:** BC-8.2.002 (the `delete` numeric-source project-derivation mechanism) carries
  an explicit paragraph stating that its project-mismatch check compares the confirming `GET`'s
  `project` field only against an EXPLICITLY-SUPPLIED `--project KEY` flag value — it does not
  separately check a `.jr.toml` config-default project, and that omission is deliberate (the
  confirming `GET`'s `project` field is unconditionally authoritative regardless of what
  `--project`/config says, so there is no flag-mismatch case a config check could additionally
  guard). BC-8.1.007's M1 section — which explicitly mirrors BC-8.2.002 M1's mechanism ("mirroring
  BC-8.2.002 M1's numeric-SOURCE confirmation on `delete` exactly (same mechanism, same shape of
  call…)") and even copies its mismatch error message shape verbatim — has no equivalent note.
  This is correct-by-derivation (the same reasoning applies identically to `edit`'s numeric-
  source check), not a behavioral gap, but the missing parity note is a documentation-
  completeness nit for a reader who consults BC-8.1.007 alone.
- **Proposed Fix:** Add the same "config-default project mismatch is not checked (only an
  explicitly-supplied `--project` flag is compared; the confirming `GET`'s `project` field is
  authoritative)" note to BC-8.1.007's M1 section, for parity with BC-8.2.002.

#### ADV-P9-INFO-002 [process-gap]: prd-delta "VP citation changes" handoff list still omits three extended-VP mappings from pass 5/7

- **Severity:** INFO
- **Category:** process-gap
- **Location:** `.factory/phase-f2-spec-evolution/prd-delta-components.md` "VP citations"
  handoff bullet, "VP citation changes" sub-list (~L282-287)
- **Description:** The pass-8 fix-burst corrected the VP range (001..026 → 001..028) and added
  BC-3.4.020/BC-3.4.021 to the "VP citation changes" list, but the list remains incomplete: it
  omits BC-8.1.007→VP-COMPONENT-004/024 (both EXTENDED in the pass-5 fix-burst — BC-8.1.007's
  own body at ~L558 and ~L686 cites both) and BC-8.3.001→VP-COMPONENT-004/024 (same pass-5
  extension, cited at ~L1466/L1471), and it omits BC-3.4.017→VP-396-005 (the pass-7 fix-burst's
  explicit citation of the pre-existing base VP for BC-3.4.017, per
  `adversarial-spec-delta-review-components-p7.md` MEDIUM-3 and `verification-delta-
  components.md` L600/L740). The authoritative `verification-delta-components.md` §3 map already
  carries all of these mappings correctly — no VP citation is actually lost — but an architect
  registering VP-INDEX entries purely from this prd-delta handoff note (rather than cross-
  checking verification-delta-components.md §3) would under-populate BC-8.1.007's,
  BC-8.3.001's, and BC-3.4.017's VP-INDEX rows.
- **Evidence:** `prd-delta-components.md` L282-287 lists only: BC-8.4.001, BC-8.4.005,
  BC-8.1.005/BC-8.1.007/BC-8.2.008 (new VP-022/023/024 — this is the pass-3 MINTING citation,
  not the pass-5 EXTENSION of VP-004/024 to BC-8.1.007), BC-3.4.020 (new VP-027), BC-3.4.021 (new
  VP-028). `bc-8-components.md` L558-560 (BC-8.1.007): "VP-COMPONENT-004 **[EXTENDED 2026-08-15,
  P5 fix-burst]**…". L1466-1468 (BC-8.3.001): same EXTENDED VP-COMPONENT-004 citation.
  `verification-delta-components.md` L600: "BC-3.4.017→VP-396-005 (base, non-`VP-COMPONENT-*`
  VP)".
- **Recurring pattern:** This is the same "map list not re-synced when a VP is extended to a new
  BC home" class flagged as MEDIUM-2 in pass 6 and closed (for a different pair of BCs) in pass
  8's LOW-1. The authoritative source (`verification-delta-components.md` §3) has been complete
  and correct since pass 8; the recurring defect is specifically this prd-delta handoff
  convenience-list falling out of sync with it. Recommend the architect (or whoever next touches
  this handoff note) treat `verification-delta-components.md` §3 as the sole source of truth and
  either regenerate this bullet from it mechanically, or replace the enumerated list with a
  pointer to §3 to remove the duplicate-maintenance surface entirely.
- **Proposed Fix:** Add BC-8.1.007→VP-COMPONENT-004/024 (EXTENDED, pass 5), BC-8.3.001→
  VP-COMPONENT-004/024 (EXTENDED, pass 5), and BC-3.4.017→VP-396-005 (pass 7) to the "VP citation
  changes" list.

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 1 |
| MEDIUM | 0 |
| LOW | 1 |
| INFO | 2 |

**Overall Assessment:** pass-with-findings
**Convergence:** findings remain — iterate
**Readiness:** requires revision (title/literal/doc-consistency only; no behavioral defect —
HIGH severity reflects the title's contradiction of a delete-safety-critical postcondition, not
a design gap)

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 9 |
| **New findings** | 2 (HIGH-1, LOW-1) |
| **Duplicate/variant findings** | 0 |
| **Novelty score** | 2 / (2 + 0) = 1.0 (both residues are one-surface title/literal fixes; no
behavioral defect — novelty rated LOW in substance despite the raw score, same qualitative
posture as pass 8) |
| **Median severity** | 3.5 (HIGH=4, LOW=2, average of the two substantive findings) |
| **Trajectory** | P7: 3 MED + 1 LOW → P8: 1 MED + 1 LOW → P9: 1 HIGH + 1 LOW |
| **Verdict** | FINDINGS_REMAIN (both trivially fixable in this same burst; the HIGH is a title-
only correction with an unusually consequential blast radius — a delete-safety BC's own H1 — not
a widening of scope; expect CONVERGENCE_REACHED at pass 10) |

Novelty LOW — both residues are one-surface doc fixes (a stale pre-DEC-279 title and a
literal-subset), no behavioral defect. The HIGH severity on HIGH-1 reflects consequence
(a delete-safety title reversal), not novelty or scope growth.
