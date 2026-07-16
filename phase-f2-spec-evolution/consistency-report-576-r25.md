---
document_type: consistency-report
round: 25
spec_version: 1.3.55
date: 2026-07-16
validator: cv-f2-576-r25 (fresh context, no prior round visibility)
verdict: CONSISTENT
bc_count: 657
holdout_count: 98
vp_count: 33
priority_checks: P15-001 (BC-2.7.011 214-byte cap), P15-002/R3.12 (BC-3.9.017 step-2 gate rewrite; EC-3.9.017-9..12; BC-3.9.014 THREE consumers; EC-3.9.003-5 extended; EC-3.9.020-7 extended; BC-3.9.018 zero-match alignment; VP-576-003 --yes rationale; H-NEW-ATTACHMENT-004 Call B; H-NEW-ATTACHMENT-010 NEW), P15-003 (BC-3.9.005 en-dash→ASCII), P15-004 (EC-2.7.007-10 --filter conflicts_with --id), P15-005 (BC-2.7.006 403 row), P15-006 (EC-2.7.007-11 --out directory path), P15-007 (EC-2.7.008-10 + EC-2.7.009-3 filtered-to-zero), P15-INFO-1 (H-001/H-003 GET fixtures ?fields=attachment), STATE.md three-site 33 verification
level: ops
version: "1.0"
status: pass
producer: cv-f2-576-r25
timestamp: 2026-07-16T00:00:00
phase: 2
inputs:
  - ".factory/specs/prd/bc-2-issue-read.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576.md"
  - ".factory/phase-f2-spec-evolution/prd-delta-576-worklog.md"
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/CANONICAL-COUNTS.md"
  - ".factory/spec-changelog.md"
  - ".factory/phase-f1-delta-analysis/impact-boundary-576.md"
  - ".factory/STATE.md"
input-hash: "83560ef"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 25 (post-P15 remediation)

**Spec version**: 1.3.55 | **BCs**: 657 | **Holdouts**: 98 | **VPs**: 33 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r25 (fresh-context consistency validator, round 25) |
| **Artifacts Scanned** | 10 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, prd-delta-576.md, prd-delta-576-worklog.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, impact-boundary-576.md, STATE.md) |
| **Focus** | Post-P15 adversary-pass remediation verification — spec v1.3.55 |
| **Prior round** | consistency-report-576-r24.md (CONSISTENT at v1.3.54) |

---

## Summary

| # | Check | Result |
|---|-------|--------|
| P15-001 | BC-INDEX.md BC-2.7.011 row: "214-byte cap" (not "255-byte cap") | pass |
| P15-002a | BC-3.9.017 step 2 rewritten: ≥1-match → confirmation gate; no-gate condition explicit | pass |
| P15-002b | EC-3.9.017-9 added (non-interactive ≥1-match no-`--yes` → exit 64; zero DELETE/POST) | pass |
| P15-002c | EC-3.9.017-10 added (gate fires ONLY on nonempty match; zero-match always non-interactive-safe) | pass |
| P15-002d | EC-3.9.017-11 added (combined `--public`+≥1-match → ONE combined prompt; not two gates) | pass |
| P15-002e | EC-3.9.017-12 added (`--yes` single-bypass for all gate conditions) | pass |
| P15-002f | EC-3.9.017-8 extended (covers all three cancel paths: --public, replace-existing, combined) | pass |
| P15-002g | BC-3.9.014 heading: "THREE consumers (P15-002)" | pass |
| P15-002h | BC-3.9.014 body: THREE consumers listed with prompt text for each | pass |
| P15-002i | EC-3.9.003-5 extended to three BC-3.9.017 entry points; P15-002/R3.12 noted | pass |
| P15-002j | EC-3.9.020-7 extended to cover ALL three gate consumers on dry-run | pass |
| P15-002k | BC-3.9.018 P15-002/R3.12 zero-match alignment paragraph added | pass |
| P15-002l | VP-576-003 `--yes` requirement rationale updated | pass |
| P15-002m | H-NEW-ATTACHMENT-004 Call B Action: `--replace-existing --yes`; explanatory note added | pass |
| P15-002n | H-NEW-ATTACHMENT-010 added (non-interactive ≥1-match --replace-existing no-`--yes` → exit 64) | pass |
| P15-002o | impact-boundary-576.md R3.12 section added | pass |
| P15-003 | BC-INDEX.md BC-3.9.005 row: ASCII `--public` (no en-dash) | pass |
| P15-004 | BC-2.7.007 EC-2.7.007-10 added (`--filter` conflicts_with `--id` → exit 2) | pass |
| P15-005 | BC-2.7.006 403 row added (exit 1, consistent with BC-2.7.012) | pass |
| P15-006 | BC-2.7.007 EC-2.7.007-11 added (`--out <PATH>` naming existing directory → exit 64) | pass |
| P15-007a | BC-2.7.008 EC-2.7.008-10 added (filtered-to-zero non-empty → canonical string + exit 0 + JSON) | pass |
| P15-007b | BC-2.7.009 EC-2.7.009-3 added (same filtered-to-zero behavior for --newest path) | pass |
| P15-INFO-1 | H-NEW-ATTACHMENT-001 Calls A+B and H-NEW-ATTACHMENT-003: `?fields=attachment` canonical form | pass |
| R3.12 keystone | BC-3.9.017 ↔ BC-3.9.014 ↔ EC-3.9.003-5 ↔ EC-3.9.020-7 ↔ BC-3.9.018 ↔ VP-576-003 ↔ H-004/H-010 ↔ impact-boundary: coherent, no circularity | pass |
| — | Counts: BC 657 / holdouts 98 / VP 33 on all primary surfaces | pass |
| — | [1.3.55] in spec-changelog.md | pass |
| — | [1.3.55] in prd-delta-576.md frontmatter (`spec_version_after: 1.3.55`) | pass |
| — | prd-delta-576.md frontmatter `holdout_count_after: 98` | pass |
| — | BC-INDEX.md `last_updated` v6.15 note, holdout 97→98, spec v1.3.55 | pass |
| — | CANONICAL-COUNTS.md holdout total 98; Group 19 entry updated to ..010 | pass |
| — | holdout-scenarios.md `total_holdouts: 98`; `version: "1.5.3"`; preamble "98 holdout scenarios" | pass |
| — | Residue scan: no live "255-byte cap" claims; no en-dash `–-public`; no "two consumers" | pass |
| — | Residue scan: no stale ungated `--replace-existing` language | pass |
| — | Residue scan: no stale holdout 97 in primary counting artifacts | pass |
| — | State.md: three DEC-179/BC estimate sites say 33 and are internally consistent | pass (INFO-8) |
| — | Guard: check-spec-counts.sh exits 0 | pass |
| — | Guard: check-bc-cumulative-counts.sh exits 0 | pass |
| INFO-1..4 | Carry-forward cosmetics from R21/R22/R23 | carry-forward |
| INFO-6 | Carry-forward: no collision-skip re-run holdout | carry-forward |
| INFO-7 | Carry-forward R24: BC-INDEX BC-3.9.020 row summary omits upload path c | carry-forward |
| INFO-8 | NEW R25: STATE.md not updated for P15 pass (live rows still show v1.3.54 / 97 holdouts / 33 VP) | new INFO |
| INFO-9 | NEW R25: prd-delta-576-worklog.md has no P14/P15 entries (worklog ends at P13) | new INFO |

All 35 behavioral checks pass. Two new INFO-level cosmetic/protocol gaps (INFO-8, INFO-9). No behavioral contradictions.

---

## Guard Script Output

### check-spec-counts.sh

```
OK: all spec counts verified.
```

### check-bc-cumulative-counts.sh

```
OK: all cumulative BC counts verified (657 total across 8 files; Surface H footer checked where present).
```

Both guards exit 0. No count drift.

---

## Priority Check Closure Table

### P15-001 — BC-INDEX.md BC-2.7.011 row "214-byte cap"

**Quote-verified verbatim** (`BC-INDEX.md` line 230):

> | BC-2.7.011 | `sanitize_attachment_filename` CWE-22 path-traversal mitigation: 5.5-step algorithm (basename extraction, pseudo-name `.`/`..` reject, NUL-byte reject, char scrub `/`/`\`/`:` → `_` only, **214-byte cap**, trailing-dot/whitespace strip SEC-576-007); containment: `canonicalize(out_dir)` then `Path::starts_with`...

**Result**: BC-INDEX.md row for BC-2.7.011 now reads "214-byte cap". No live "255-byte cap" claim found in any `.factory/specs/prd/` file (the only occurrences of "255 bytes" in bc-2 are in the context of the POSIX filename limit calculation: `41-byte SHA-1 prefix + 214-byte cap = 255 bytes total`). CORRECTED ✓

---

### P15-002a — BC-3.9.017 step-2 gate rewrite

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.017 step 2 headline, line 3725):

> 2. **Gate step (fire ALL pending confirmation gates BEFORE any destructive call)**: evaluate gate-triggering conditions from the results of step 1 and the supplied flags:

**Quote-verified** — the step-2 body enumerates gate-triggering conditions: (a) `--public` present, OR (b) ≥1 same-filename match found; no-op when `--public` absent AND zero matches AND no `--yes`; `--dry-run` suppresses ALL gates. Also verified at line 3736:

> This step supersedes the prior "no-op when no `--public`" wording (P15-002/R3.12 ruling). **One gate per invocation, ever.**

**Result**: Step-2 completely rewritten. Prior ungated `--replace-existing` path closed. REWRITTEN ✓

---

### P15-002b..e — EC-3.9.017-9..12 added

**Quote-verified verbatim** (`bc-3-issue-write.md` lines 3759–3765):

> **EC-3.9.017-9** (non-interactive, ≥1 match, no `--yes` — P15-002/R3.12): `--replace-existing` in non-interactive mode (`--no-input` or stdin not a TTY) when step 1 found ≥1 same-filename match and `--yes` is absent → exit 64 before any DELETE: `"Use --yes to confirm deletion of existing same-filename attachments."` (actionable hint). Zero DELETEs issued; zero upload POST issued. This is the non-interactive arm of the gate added by P15-002.

> **EC-3.9.017-10** (gate fires ONLY on nonempty match — P15-002/R3.12): the --replace-existing confirmation gate fires ONLY when step 1 finds ≥1 same-filename match. Zero same-filename matches → gate step is a no-op on the replace path (no prompt, no stdin read). `--replace-existing` with zero matches is always non-interactive-safe — no `--yes` required when no existing attachments would be deleted.

> **EC-3.9.017-11** (combined gate — single prompt for `--public` + ≥1 match — P15-002/R3.12): when `--public` AND ≥1 same-filename match are BOTH present, the gate in step 2 fires as ONE combined prompt (not two separate gates) covering both consequences.

> **EC-3.9.017-12** (`--yes` single-bypass for all gate conditions — P15-002/R3.12): `--yes` is the single bypass for the entire step-2 gate regardless of what triggered it — `--public` only, ≥1 match only, or both combined.

**Result**: All four new ECs present. Each covers a distinct gate path. ADDED ✓

---

### P15-002f — EC-3.9.017-8 extended

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.017-8, line 3757):

> **EC-3.9.017-8** (gate cancelled in step 2): user cancels any confirmation gate (--public, --replace-existing, or combined); exit 0; `"Upload cancelled."`; no DELETEs issued; no upload; mirrors BC-3.9.014 EC-3.9.014-2.

**Result**: EC-3.9.017-8 now covers all three cancel paths. Pre-P15 text only covered `--public` gate cancellation; now covers all three BC-3.9.014 consumers. EXTENDED ✓

---

### P15-002g/h — BC-3.9.014 THREE consumers

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.014 heading, line 3587):

> #### BC-3.9.014: Upload confirmation gate mechanics — `eprint!` to stderr + `io::stdin().lock().read_line()`; NOT `dialoguer::Confirm`; mirrors BC-3.5.007/BC-3.5.008; **THREE consumers (P15-002)**

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.014 body, lines 3595–3598):

> **Three consumers (P15-002/R3.12)**: this gate mechanism is used by THREE distinct upload triggers, all sharing the same `eprint!+read_line` mechanics and three-way branch:
> 1. `--public` standalone (BC-3.9.003): fires regardless of same-filename match count, whenever `--public` is present.
> 2. `--replace-existing` with ≥1 same-filename match (BC-3.9.017 step 2): fires only when pre-flight finds ≥1 match; zero matches → no gate.
> 3. Combined `--public` + ≥1 match (BC-3.9.017 step 2): fires as ONE combined prompt, NOT two separate gates.

**Quote-verified** — prompt text for all three consumers at lines 3601–3604:
- Consumer 1 (`--public` only, N ≤ 3): `"Upload <filename1>, ... to <KEY> as customer-visible (public)? [y/N] "`
- Consumer 2 (`--replace-existing` ≥1 match, no `--public`): `"Replace existing attachment(s) on <KEY>:\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "`
- Consumer 3 (combined): `"Upload to <KEY> as customer-visible (public) and replace existing attachment(s):\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "`

**Result**: BC-3.9.014 heading and body both state THREE consumers. All three prompt variants present. EXPANDED ✓

---

### P15-002i — EC-3.9.003-5 extended to three entry points

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.003-5, line 3322):

> **EC-3.9.003-5** (invoked from BC-3.9.017 `--replace-existing` step 4, OR from BC-3.9.018 `--replace-existing` zero-match path, OR from the P15-002/R3.12 `--replace-existing`-with-≥1-match-gate path): the confirmation gate defined in this BC is NOT re-presented. **Step-4 path (BC-3.9.017, ≥1 match + `--public`)**: the combined gate (BC-3.9.014 consumer 3) was resolved at BC-3.9.017 step 2 ... **Step-4 path (BC-3.9.017, ≥1 match, no `--public`)**: the replace-existing gate (BC-3.9.014 consumer 2) was resolved at step 2 — gate is satisfied; BC-3.9.003 gate MUST NOT fire on JSM upload. **Zero-match path (BC-3.9.018, P7-002)**: the gate was also resolved at BC-3.9.017 step 2 ... Gate state: RESOLVED (do not prompt again). One gate per invocation, ever. (P15-002/R3.12 extended three entry points to this suppression path.)

**Result**: Three explicit entry-point clauses present. Suppression is annotated as extended by P15-002/R3.12. EXTENDED ✓

---

### P15-002j — EC-3.9.020-7 extended to ALL three consumers

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.020-7, line 3872):

> **EC-3.9.020-7** (`--replace-existing --dry-run` — path c, ALL gate suppression): ALL BC-3.9.014 confirmation gates are **SUPPRESSED** on `--dry-run`; no stdin read; no `eprint!` prompt — regardless of which gate(s) would otherwise trigger. This covers ALL three gate consumers: (1) `--public` gate: suppressed even when `--public` is present; (2) `--replace-existing`-with-≥1-match gate (P15-002/R3.12): suppressed even when pre-flight finds same-filename matches; (3) combined gate: suppressed. ... P14-009; P15-002/R3.12 (extended to cover replace-existing match gate).

**Result**: EC-3.9.020-7 explicitly enumerates all three consumers. P15-002/R3.12 extension noted. EXTENDED ✓

---

### P15-002k — BC-3.9.018 P15-002/R3.12 zero-match alignment paragraph

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.018, line 3787):

> **P15-002/R3.12 zero-match alignment**: the new `--replace-existing` match gate (EC-3.9.017-9..12) does NOT fire on this path. Zero same-filename matches → gate step is a no-op on the replace path (BC-3.9.017 EC-3.9.017-10). This path (BC-3.9.018) is therefore always non-interactive-safe for the match gate: `--replace-existing` with zero same-filename matches never requires `--yes` and never exits 64 due to the match gate. The `--public` gate (consumer 1) remains independent and still fires on this path when `--public` is present (resolved at BC-3.9.017 step 2 before reaching BC-3.9.003).

**Result**: Paragraph present. States P15-002 gate does NOT fire on zero-match path. Cross-references EC-3.9.017-10. Clarifies `--public` gate is independent. ADDED ✓

---

### P15-002l — VP-576-003 `--yes` rationale updated

**Quote-verified verbatim** (`bc-3-issue-write.md` VP-576-003, line 3767, excerpt):

> ... The `--yes` flag is **required** on this test path because `--replace-existing` with ≥1 match now triggers the P15-002/R3.12 gate — without `--yes`, a non-interactive test environment would exit 64 before the DELETE. The `--yes` flag bypasses the gate, making the test fully deterministic. Pins BC-3.9.017 step-3 → step-4 ordering, the invariant paragraph "no destructive API call may be issued while any confirmation gate OR eligibility guard remains unresolved," and EC-3.9.017-10/12 (gate fires on match; --yes bypasses). P14-007; P15-002 (VP note updated).

**Result**: VP-576-003 now explains why `--yes` is required on this test path: the P15-002/R3.12 gate would cause a non-interactive test to exit 64 without it. UPDATED ✓

---

### P15-002m — H-NEW-ATTACHMENT-004 Call B: `--replace-existing --yes`

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-004 Call B Action, line 2230):

> **Action B**: `jr issue attachment upload FOO-1 upload.txt --replace-existing --yes`

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-004 Expected B, line 2242):

> - Note: `--yes` is required here because `--replace-existing` with ≥1 same-filename match triggers the P15-002/R3.12 confirmation gate; without `--yes`, the test (non-interactive) would exit 64 before the DELETE (BC-3.9.017 EC-3.9.017-9). See also H-NEW-ATTACHMENT-010 for the non-interactive-without-`--yes` exit-64 path.

**Result**: Call B action now includes `--yes`. Explanatory note correctly points to EC-3.9.017-9 and H-NEW-ATTACHMENT-010. UPDATED ✓

---

### P15-002n — H-NEW-ATTACHMENT-010 added

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-010 heading, line 2461):

> ### H-NEW-ATTACHMENT-010: `attachment upload --replace-existing` in non-interactive mode with ≥1 same-filename match and no `--yes` → exit 64; zero DELETEs, zero upload POSTs (MUST-PASS)

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-010 Expected, lines 2477–2483):

> - Exit code = **64** (usage error — not 0, not 1, not 130).
> - stderr contains `"Use --yes to confirm deletion of existing same-filename attachments."` (the exact canonical hint from BC-3.9.017 EC-3.9.017-9).
> - stdout is empty (no JSON output — no upload occurred).
> - Wiremock: zero requests to `DELETE /rest/api/3/attachment/50001`.
> - Wiremock: zero requests to `POST /rest/api/3/issue/FOO-1/attachments`.
> - The pre-flight `GET ?fields=attachment` WAS issued (list step fires before the gate check).

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-010 Status, line 2490):

> **Status**: MUST-PASS. Pins BC-3.9.017 EC-3.9.017-9 (non-interactive, ≥1 match, no `--yes` → exit 64; zero DELETE, zero POST). Contrast with H-NEW-ATTACHMENT-004 Call C (zero-match, gate no-op) and H-NEW-ATTACHMENT-004 Call B (≥1 match + `--yes`, gate bypassed). P15-002/R3.12.

**Result**: H-NEW-ATTACHMENT-010 present. Setup concrete (wiremock with `GET ?fields=attachment` returning 1 match; `.expect(0)` assertions on DELETE and POST). Action concrete (`--replace-existing --no-input`). Expected concrete. Contrast section correctly distinguishes from H-004 Call C (zero-match no gate) and Call B (--yes bypass). ADDED ✓

---

### P15-002o — impact-boundary-576.md R3.12

**Quote-verified verbatim** (`impact-boundary-576.md` R3.12 section, lines 791–807):

> ### R3.12 `--replace-existing` ≥1-match confirmation gate (P15-002/R3.12)
>
> **Orchestrator ruling (P15-002, adversary pass-15, 2026-07-16)**: `attachment upload --replace-existing` MUST require a confirmation gate whenever the pre-flight `GET ?fields=attachment` (BC-3.9.017 step 1) finds ≥1 same-filename attachment that would be deleted.
>
> **Ruling**: This is a **pattern-extension** of R3.8b ("no destructive call before a pending confirmation gate") and R3.3 (delete confirmation gate precedent)...
>
> **Spec impact**: BC-3.9.017 step 2 rewritten (P15-002); EC-3.9.017-9..12 added; BC-3.9.014 expanded to THREE consumers; EC-3.9.003-5 extended; EC-3.9.020-7 extended; BC-3.9.018 zero-match alignment noted; VP-576-003 `--yes` rationale updated; H-NEW-ATTACHMENT-010 added (holdouts 97→98).

**Result**: R3.12 section present. Ruling text covers all gate variants (interactive/non-interactive/combined/--yes/zero-match/dry-run). DEC-180 precedent basis cited. Spec impact summary matches all verified changes. ADDED ✓

---

### P15-003 — BC-3.9.005 row en-dash → ASCII

**Quote-verified verbatim** (`BC-INDEX.md` line 377 — Python unicode scan confirmed no `–` (U+2013) character):

> | BC-3.9.005 | `--public` on non-JSM issue → exit 64; canonical message "--public is only supported on Jira Service Management (JSM) issues."...

**Result**: BC-3.9.005 row uses ASCII `--public` (two ASCII hyphens). No en-dash. FIXED ✓

---

### P15-004 — BC-2.7.007 EC-2.7.007-10 (`--filter` conflicts_with `--id`)

**Quote-verified verbatim** (`bc-2-issue-read.md` EC-2.7.007-10, line 751):

> **EC-2.7.007-10** (`--filter` with `--id` — clap conflict): `--filter <FILTER>` MUST be declared with `conflicts_with = "id"` (clap `conflicts_with` → exit 2 when `--filter` is supplied together with `--id`). `--filter` applies only to `--all` and `--newest N` batch paths; it has no defined semantics on the single-ID path (the AID already uniquely identifies one attachment). Applies to all `--filter` variants (mime/name/size-max). P15-004.

**Result**: EC-2.7.007-10 present. Prescribes clap `conflicts_with = "id"`, exit 2, applies to all `--filter` variants. ADDED ✓

Also verified that BC-2.7.007 CLI flags line (line 757) now includes `--filter` with `conflicts_with = "id"` annotation.

---

### P15-005 — BC-2.7.006 403 row

**Quote-verified verbatim** (`bc-2-issue-read.md` BC-2.7.006 error table, lines 690–696):

> | Condition | Exit code | stderr |
> |-----------|-----------|--------|
> | KEY 404 (not found / no access) | 64 | `"Issue <KEY> not found or not accessible."` |
> | **403** | **1** | **`"Permission denied: cannot access issue <KEY>."`** |
> | 401 | 2 | Not authenticated + `jr auth login` hint |
> | 5xx | 1 | `API error (<N>)` |
> | Network error | 1 | Connectivity hint |

**Quote-verified** Trace at line 698 includes "P15-005 (403 row added — consistent with BC-2.7.012 403 = exit 1)".

**Result**: 403 row present with exit 1 and canonical permission-denied message. Consistent with BC-2.7.012. ADDED ✓

---

### P15-006 — BC-2.7.007 EC-2.7.007-11 (`--out <PATH>` existing directory)

**Quote-verified verbatim** (`bc-2-issue-read.md` EC-2.7.007-11, line 753):

> **EC-2.7.007-11** (`--out <PATH>` names an existing directory): if the user-specified `--out <PATH>` resolves to a path that already exists as a **directory**, `jr` exits 64 before any download: `"output path is a directory: <PATH>"`. Checked pre-download in the same pre-flight family as the overwrite-refuse guard (BC-2.7.007 Overwrite behavior). No file is created and no streaming request is issued. P15-006.

**Result**: EC-2.7.007-11 present. Exit code 64. Canonical message `"output path is a directory: <PATH>"`. Pre-flight guard (no streaming issued). ADDED ✓

---

### P15-007a — BC-2.7.008 EC-2.7.008-10 (filtered-to-zero non-empty)

**Quote-verified verbatim** (`bc-2-issue-read.md` EC-2.7.008-10, line 794):

> **EC-2.7.008-10** (filtered-to-zero on a non-empty issue): when `--all` is used with one or more `--filter` flags and the filter set matches zero attachments from a non-empty issue (i.e., the issue has ≥1 attachments but none pass the filter), the behavior is **distinct** from EC-2.7.008-1 (empty-issue path): → exit 0; stderr: `"No attachments matched the filter on <KEY>."` (canonical string; different from `"No attachments on <KEY>."` which is the empty-issue message); JSON mode: stdout `{"downloaded":[]}` (empty array, consistent with EC-2.7.008-6 uniform `downloaded` array shape); no download requests issued. P15-007.

**Result**: EC-2.7.008-10 present. Distinct from empty-issue EC-2.7.008-1. Canonical string `"No attachments matched the filter on <KEY>."`. JSON `{"downloaded":[]}`. No download requests. ADDED ✓

---

### P15-007b — BC-2.7.009 EC-2.7.009-3 (filtered-to-zero for --newest)

**Quote-verified verbatim** (`bc-2-issue-read.md` EC-2.7.009-3, line 819):

> **EC-2.7.009-3** (filtered-to-zero on a non-empty issue): when `--newest N` is used with one or more `--filter` flags and the filter set matches zero attachments from a non-empty issue (i.e., the issue has ≥1 attachments but none pass the filter), the behavior is distinct from the empty-issue case: → exit 0; stderr: `"No attachments matched the filter on <KEY>."` (canonical string; matches EC-2.7.008-10; different from the empty-issue message); JSON mode: stdout `{"downloaded":[]}` (empty array); no download requests issued. P15-007.

**Result**: EC-2.7.009-3 present. Same canonical string as EC-2.7.008-10 (correct cross-reference). ADDED ✓

---

### P15-INFO-1 — H-NEW-ATTACHMENT-001 and H-NEW-ATTACHMENT-003 GET fixtures

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-001 Call A, line 2073):

> 2. Wiremock mounts `GET /rest/api/3/issue/FOO-1?fields=attachment` returning 200 with `"attachment": []` in the `fields` object.

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-001 Call B, line 2077):

> 2. Wiremock mounts `GET /rest/api/3/issue/FOO-2?fields=attachment` returning 200 with two attachment objects:

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-003 Setup, line 2154):

> 2. Wiremock mounts `GET /rest/api/3/issue/FOO-3?fields=attachment` with three attachments:

**Result**: All three list-GET fixtures use the canonical `?fields=attachment` form. UPDATED ✓

---

## R3.12 Keystone Coherence Check

### Keystone K-1: BC-3.9.017 step-2 gate mechanics ↔ BC-3.9.014 consumers — no overlap, no gap

BC-3.9.017 step 2 defines four sub-cases:
- `--dry-run` → ALL gates suppressed (references BC-3.9.020 EC-3.9.020-7)
- `--yes` supplied → bypass
- Non-interactive, gate would trigger → exit 64 EC-3.9.017-9
- Interactive, gate triggers → prompt per BC-3.9.014

BC-3.9.014 defines three consumers with distinct prompt texts. BC-3.9.017 step 2 references the correct consumer (2 for replace-existing-only, 3 for combined). No overlap: consumer 1 (`--public` standalone) fires from BC-3.9.003 independently; consumers 2+3 fire from BC-3.9.017 step 2 only. **No gap: every trigger condition has exactly one prompt variant. COHERENT ✓**

### Keystone K-2: Guard evaluation order — eligibility → gate → --yes

BC-3.9.017 step 0 fires the non-JSM eligibility check (BC-3.9.005) BEFORE the gate step (step 2). Within step 2: `--dry-run` suppression → `--yes` bypass → non-interactive exit 64 → interactive prompt. EC-3.9.003-7 order (JSM eligibility → interactive/non-interactive branch → `--yes`) is consistent with step-0/step-2 ordering. The behavioral outcome is identical: eligibility fires first; `--yes` always bypasses; non-interactive without `--yes` exits 64. **COHERENT, no circularity ✓**

### Keystone K-3: EC-3.9.003-5 suppression covers all entry points

Three entry points enumerated in EC-3.9.003-5:
1. BC-3.9.017 step 4 (≥1 match + `--public`): combined gate resolved at step 2; BC-3.9.003 gate MUST NOT re-fire
2. BC-3.9.017 step 4 (≥1 match, no `--public`): replace-existing gate resolved at step 2; BC-3.9.003 gate MUST NOT re-fire
3. BC-3.9.018 zero-match path: gate resolved at step 2 (even with no DELETEs)

All three paths end with "gate state: RESOLVED, do not prompt again." **One gate per invocation, ever. COHERENT ✓**

### Keystone K-4: EC-3.9.020-7 dry-run suppression covers all three consumers

EC-3.9.020-7 explicitly enumerates "(1) `--public` gate; (2) `--replace-existing`-with-≥1-match gate (P15-002/R3.12); (3) combined gate: suppressed." This is the complete set of BC-3.9.014 consumers. **ALL THREE COVERED ✓**

### Keystone K-5: BC-3.9.018 zero-match alignment ↔ EC-3.9.017-10 — no contradiction

EC-3.9.017-10 (step-2 level): "gate fires ONLY when step 1 finds ≥1 same-filename match. Zero matches → gate step is a no-op."

BC-3.9.018 P15-002 alignment (BC level): "the new `--replace-existing` match gate (EC-3.9.017-9..12) does NOT fire on this path... always non-interactive-safe for the match gate."

Both say the same thing from different vantage points. **COHERENT, no contradiction ✓**

### Keystone K-6: EOF three-way branch inherited by new consumer

BC-3.9.017 step 2 at line 3734: "Gate mechanics always follow BC-3.9.014 (`eprint!+read_line`, NOT `dialoguer::Confirm`; three-way branch (a) y/yes → proceed, (b) other/empty → cancel exit 0, (c) EOF/IO-error → `JrError::Interrupted` exit 130)."

The new replace-existing gate consumer inherits the full three-way branch including EOF → exit 130. **INHERITED CORRECTLY ✓**

### Keystone K-7: H-NEW-ATTACHMENT-004 Call B ↔ H-NEW-ATTACHMENT-010 — complementary coverage

H-004 Call B: `--replace-existing --yes` → exit 0; DELETE + POST issued; `--yes` pins EC-3.9.017-12 bypass.
H-004 Call C: `--replace-existing` zero-match → exit 0; no DELETE; no `--yes` needed; pins EC-3.9.017-10.
H-010: `--replace-existing --no-input` with ≥1 match → exit 64; zero DELETE, zero POST; pins EC-3.9.017-9.

Three-way coverage: pass (--yes), no-op (zero-match), exit-64 (non-interactive with match). **No overlap, full coverage ✓**

---

## BC-3.9.014 Prompt Text Verification

The three prompt variant texts in BC-3.9.014 (lines 3601–3604) are cross-checked against BC-3.9.017 step 2 (lines 3731–3733):

| Consumer | BC-3.9.014 text | BC-3.9.017 step-2 text | Match? |
|----------|----------------|------------------------|--------|
| 1 (`--public` only, N≤3) | `"Upload <filename1>, ... to <KEY> as customer-visible (public)? [y/N] "` | not prescribed (delegates to BC-3.9.014) | ✓ |
| 2 (replace-existing only) | `"Replace existing attachment(s) on <KEY>:\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "` | same text quoted at line 3732 | ✓ |
| 3 (combined) | `"Upload to <KEY> as customer-visible (public) and replace existing attachment(s):\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "` | same text quoted at line 3733 | ✓ |

No mismatch between BC-3.9.014 and BC-3.9.017 prompt text variants.

---

## Cross-Artifact Count Verification

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |
| Guard output | verified | — | verified | — | 657 |

P15 added 0 new BCs. PASS ✓

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter | 98 | PASS ✓ |
| `holdout-scenarios.md` preamble | "98 holdout scenarios" | PASS ✓ |
| `holdout-scenarios.md` version | "1.5.3" | PASS ✓ |
| `CANONICAL-COUNTS.md` holdout section | 98 | PASS ✓ |
| `CANONICAL-COUNTS.md` Group 19 entry | H-NEW-ATTACHMENT-001..010 | PASS ✓ |
| `BC-INDEX.md` last_updated note | `97→98 (H-NEW-ATTACHMENT-010 added)` | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 98 | PASS ✓ |
| `spec-changelog.md` [1.3.55] Impact table | "Holdout count: 98 (+1: H-NEW-ATTACHMENT-010)" | PASS ✓ |

P15 added 1 holdout (H-NEW-ATTACHMENT-010). 97→98. PASS ✓

### VP Counts

VP count 33 (unchanged from P14). Verified via:

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `BC-INDEX.md` last_updated note (line 5) | "BC count unchanged (657); BC-INDEX v6.15" (VP note: "33 VP unchanged") | PASS ✓ |
| `spec-changelog.md` [1.3.55] Impact table | "VP count: 33 (unchanged)" | PASS ✓ |
| `prd-delta-576.md` P15 section | "VPs: 33 (unchanged)." | PASS ✓ |

---

## STATE.md New-BC Estimate Verification

The task required verification that the PO's correction of the bundle new-BC estimate (~27 → 33) landed at THREE sites in STATE.md and is internally consistent.

**Site 1** — DEC-179 row (STATE.md line 100):

> (9) scale: 5 stories, 1 wave, ~27 new behavioral contracts estimated **(actual delivered: 33; Sections 2.7/3.9/X.8, 624→657)**

**Site 2** — Pipeline position note (STATE.md line 282):

> **5 stories (S-576-1..5), 1 wave, 33 new BCs delivered (Sections 2.7/3.9/X.8, 624→657; F1 estimate was ~27).**

**Site 3** — Artifact registry (STATE.md line 354):

> | SOH-ATTACHMENTS-1 F2 prd-delta-576 (2026-07-15) — **33 new behavioral contracts** (F1 est. 27); spec v1.3.43→v1.3.54; worklog |

**Internal consistency check**: All three sites agree the actual delivered count is 33. The arithmetic 12+20+1=33 (BC-2.7.001..012 + BC-3.9.001..020 + BC-X.8.010) maps to the section references "Sections 2.7/3.9/X.8". The base count 624+33=657 matches the canonical grand total. The original F1 estimate ~27 is preserved as historical context at all three sites.

**RESULT**: All three STATE.md sites say 33. Internally consistent. Arithmetic confirmed (12+20+1=33; 624+33=657). VERIFIED ✓

**NOTE (INFO-8)**: STATE.md live status rows (current_step, Current Phase, pipeline tracker) were NOT updated for the P15 pass. They still show spec v1.3.54, holdouts 97, VP 33. See INFO-8 below. The task explicitly prohibited editing STATE.md; this deviation is reported only.

---

## Residue Scan

### "255-byte cap" residue

Live claims for "255-byte cap" (as a sanitization cap): **NONE** found in `.factory/specs/prd/`. The BC-INDEX.md line 5 references it only as a historical notation ("255-byte cap"→"214-byte cap" change). Occurrences of "255 bytes" in bc-2 refer to the POSIX total-filename-length limit (41-byte prefix + 214-byte cap = 255 bytes total), which is correct.

### En-dash `–-public` residue

Python unicode scan of BC-INDEX.md and bc-3-issue-write.md: **ZERO en-dash (U+2013) characters** found adjacent to a hyphen in any `--public` context. CLEAN ✓

### Ungated `--replace-existing` language

Scan for "ungated", "no gate", or unqualified "no-op" language for the replace-existing path: **NO stale ungated language** found outside the legitimate zero-match and dry-run gate-suppression contexts. CLEAN ✓

### "Two consumers" (stale)

Grep for "two consumers" or "2 consumers": **NO results**. CLEAN ✓

### Stale holdout 97 in primary counting artifacts

Grep for "total_holdouts: 97", "holdout_count: 97", "holdouts: 97" in holdout-scenarios.md, CANONICAL-COUNTS.md, prd-delta-576.md: **NO results**. CLEAN ✓

---

## 1. L2 to L3 Requirement Coverage

_N/A — ops-level spec-evolution round check. This section applies to story decomposition validation at the Phase 2 gate; this report is scoped to F2 patch correctness (post-P15 adversary pass)._

## 2. L3 to L4 Verification Property Coverage

_N/A — ops-level spec-evolution round check. VP coverage is verified qualitatively in the Priority Check Closure Table (VP-576-003 rationale updated, verified verbatim)._

## 3. Dependency Acyclicity

_N/A — ops-level spec-evolution round check. No story dependency graph applies; this report checks spec artifact internal consistency._

## 4. Architecture Alignment

_N/A — ops-level spec-evolution round check. Architecture alignment is validated at the Phase 2 story decomposition gate, not at patch-round level._

## 5. Acceptance Criteria Quality

_N/A — ops-level spec-evolution round check. AC quality is verified qualitatively via the EC and BC checks in the Priority Check Closure Table._

## 6. Story Sizing

_N/A — ops-level spec-evolution round check. Story sizing applies to the Phase 2 story decomposition gate._

## 7. Priority Consistency

_N/A — ops-level spec-evolution round check. Priority consistency is verified at Phase 2 story decomposition._

## 8. L1 to L2 to L3 to L4 Chain Completeness

_N/A — ops-level spec-evolution round check. Chain completeness is verified at the Phase 2 gate. The P15 pass adds no new BCs (count unchanged at 657) and one holdout (97→98); traceability from H-NEW-ATTACHMENT-010 → BC-3.9.017 EC-3.9.017-9 is confirmed in the Priority Check Closure Table._

## 9. AC Completeness Coverage

_N/A — ops-level spec-evolution round check. AC completeness is verified at the Phase 2 gate; this report is scoped to P15 patch correctness._

## 10. ASM/R Traceability

_N/A — ops-level spec-evolution round check. ASM/R traceability is verified at the Phase 2 gate._

---

## Cross-Reference Validation

### ID Consistency

| Check | Status | Notes |
|-------|--------|-------|
| EC-3.9.017-9..12 added; all four cite BC-3.9.014 and BC-3.9.017 consistently | pass | No orphaned EC IDs |
| BC-3.9.014 THREE consumers heading cites P15-002; body enumerates consumers 1/2/3 | pass | Bidirectional: BC-3.9.017 step 2 references BC-3.9.014 consumers 2+3 correctly |
| EC-3.9.003-5 three entry points cite BC-3.9.017 step 4 (two paths) and BC-3.9.018 (one path) | pass | No dangling references |
| EC-3.9.020-7 cites P15-002/R3.12 and enumerates all three gate consumers | pass | Cross-ref correct |
| BC-3.9.018 P15-002 alignment paragraph cites EC-3.9.017-10 | pass | Bidirectional consistent |
| VP-576-003 rationale updated; Trace field cites P15-002 (step-2 gate rewrite) | pass | Source updated |
| H-NEW-ATTACHMENT-010 cites EC-3.9.017-9; Status section cites P15-002/R3.12 | pass | Bidirectional: EC-3.9.017-9 is pinned by H-010 |
| H-NEW-ATTACHMENT-004 Call B note cites EC-3.9.017-9 and references H-010 | pass | Cross-reference correct |
| BC-INDEX.md BC-2.7.011 row "214-byte cap" corrected; row summary consistent with bc-2 body | pass | No residue of "255-byte cap" in live claims |
| BC-INDEX.md BC-3.9.005 row uses ASCII `--public` | pass | No en-dash residue |
| impact-boundary-576.md R3.12 spec impact summary matches verified changes | pass | Impact summary enumerates all 9 P15 sub-changes |

### Naming Convention Compliance

| Convention | Expected Pattern | Status |
|-----------|-----------------|--------|
| BC naming | BC-S.SS.NNN | pass — all new ECs follow EC-3.9.017-N and EC-3.9.020-N pattern |
| VP naming | VP-NNN (VP-576-NNN) | pass — VP-576-003 naming consistent |
| EC naming | EC-S.SS.NNN-N | pass — EC-3.9.017-9..12 sequential, no gaps |
| Holdout naming | H-NEW-ATTACHMENT-NNN | pass — H-NEW-ATTACHMENT-010 follows established sequence |

### Canonical Frontmatter Validation

| Artifact | spec_version | version | holdout_count | Status |
|----------|-------------|---------|---------------|--------|
| prd-delta-576.md | `spec_version_after: 1.3.55` | — | `holdout_count_after: 98` | pass |
| holdout-scenarios.md | — | `1.5.3` | `total_holdouts: 98` | pass |
| spec-changelog.md | `[1.3.55]` entry present | — | 98 in impact table | pass |
| BC-INDEX.md | `last_updated` entry for v6.15 | `index_version: v6.15` | 97→98 noted | pass |
| CANONICAL-COUNTS.md | — | — | 98 in holdout table | pass |

---

## Spec vs Implementation Drift

_This report covers spec-evolution artifact drift only (F2 patch round). Implementation source code is out of scope for this validation round — no product source was modified by P15. The following table covers spec artifact drift relative to the canonical version._

| Artifact | Spec Version After P15 | Consistency Status | Notes |
|----------|------------------------|-------------------|-------|
| bc-3-issue-write.md | v1.3.55 (footer updated) | consistent | BC-3.9.017 step 2, EC-3.9.017-9..12, BC-3.9.014 THREE consumers, EC-3.9.003-5, EC-3.9.020-7, BC-3.9.018 alignment — all applied |
| bc-2-issue-read.md | v1.3.55 (Trace fields updated) | consistent | BC-2.7.006 403 row, EC-2.7.007-10/11, EC-2.7.008-10, EC-2.7.009-3 — all applied |
| holdout-scenarios.md | version 1.5.3 | consistent | H-NEW-ATTACHMENT-010 added; H-004 Call B updated to `--yes`; H-001/H-003 GET fixtures updated |
| BC-INDEX.md | index_version v6.15 | consistent | BC-2.7.011 "214-byte cap"; BC-3.9.005 ASCII `--public`; holdout 97→98; last_updated |
| CANONICAL-COUNTS.md | — | consistent | Group 19 updated to ..010; holdout total 98 |
| spec-changelog.md | [1.3.55] added | consistent | Impact table matches all P15 changes |
| prd-delta-576.md | spec_version_after 1.3.55, holdout_count_after 98 | consistent | P15 section complete; all 9 findings dispositioned |
| impact-boundary-576.md | R3.12 section added | consistent | Gate ruling, DEC-180 precedent basis, spec impact summary |
| STATE.md | live rows NOT updated for P15 | STALE (INFO-8) | DEC-179/BC estimate corrections (three sites, ~27→33) are correct; live status rows (current_step, Current Phase, pipeline tracker) still show v1.3.54 / 97 holdouts |
| prd-delta-576-worklog.md | last entry P13 | STALE (INFO-9) | P14/P15 entries absent; worklog diverged from prd-delta-576.md at P14 |

---

## Findings

### Critical

None.

### Major

None. Zero behavioral contradictions introduced. All P15 changes are correctly applied.

### Minor

The following INFO-level annotation gaps remain or are newly identified; none affect behavior or block pipeline progression.

- **INFO-1** (carry-forward R21/R22/R23/R24): Double blank lines between EC-2.7.008-6 and EC-2.7.008-7 in `bc-2-issue-read.md`. Not introduced or worsened by P15.
- **INFO-2** (carry-forward R21/R22/R23/R24): EC-2.7.008-2/EC-2.7.008-5 redundant pair. Not introduced or worsened by P15.
- **INFO-3** (carry-forward R21/R22/R23/R24): BC-2.7.012 "KEY or AID 5xx" combined-scope row is correct but imprecise about which endpoint applies. Not introduced or worsened by P15.
- **INFO-4** (carry-forward R22/R23/R24): H-NEW-ATTACHMENT-003 BC refs footer does not explicitly mention "Call B2". Not introduced or worsened by P15.
- **INFO-5 — RESOLVED** (was R23, resolved P14): `bc-3-issue-write.md` footer was stale; corrected by P14. Carry-forward note only for audit trail.
- **INFO-6** (carry-forward R23/R24): No holdout for the collision-skip exit-0 path (re-run `--all` on an issue where files were already downloaded → all skip → exit 0, empty `downloaded` array). Not introduced or worsened by P15.
- **INFO-7** (carry-forward R24): `BC-INDEX.md` BC-3.9.020 row summary uses `attachment delete --dry-run:` as its lead text, while the BC body was retitled at P14-010 to include upload path (c). Cosmetic BC-INDEX summary inconsistency; authoritative BC body is correct. Not worsened by P15.
- **INFO-8** (NEW R25): `STATE.md` live status rows were **NOT updated** for the P15 pass. The `current_step` field (line 15) still reads spec v1.3.54, holdouts 97, VP 33; the "Current Phase" row (line 43) still shows "Spec v1.3.54. BC 657. Holdouts 97. VP 33." and the pipeline tracker row (line 57) ends at P14. The task explicitly directed "do not edit STATE.md yourself." This is a protocol deviation — state-manager ordinarily updates STATE.md at each fix round. The DEC-179/BC estimate corrections (three sites, ~27→33) are confirmed correctly landed. STATE.md stale status is non-blocking for the spec validation.
- **INFO-9** (NEW R25): `prd-delta-576-worklog.md` has no entries for P14 or P15 fix rounds. The worklog ends at P13 (line ~ending). P14 and P15 fix-round dispositions are recorded only in `prd-delta-576.md`. This split is cosmetically inconsistent — earlier passes (P1–P13) used both artifacts in tandem — but non-blocking. The `prd-delta-576.md` P15 section is complete and accurate.

---

## Validation Gate Result

**PASS**

All 35 behavioral check areas pass. Two new INFO-level protocol/cosmetic gaps (INFO-8 STATE.md not updated; INFO-9 worklog ends at P13). Five carry-forward INFO items (INFO-1..4, INFO-6, INFO-7). INFO-5 remains resolved from P14. Spec version 1.3.55 is consistent across all active spec artifacts. Both guard scripts exit 0.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 35 |
| **Passed** | 35 |
| **Resolved** | 1 (INFO-5 from R23, resolved P14 — audit note only) |
| **Failed** | 0 |
| **Warnings (INFO)** | 8 (INFO-1..4 carry-forward; INFO-6 carry-forward; INFO-7 carry-forward; INFO-8 new; INFO-9 new) |
| **Overall Status** | consistent |

Round 25 is a PATCH-level validation confirming 9 P15 adversary-pass fixes: (1) BC-3.9.017 step-2 gate rewrite: ≥1 same-filename match → confirmation gate required; EC-3.9.017-9..12 added; BC-3.9.014 expanded to THREE consumers; EC-3.9.003-5 extended; EC-3.9.020-7 extended; BC-3.9.018 zero-match alignment; VP-576-003 rationale; H-NEW-ATTACHMENT-004 Call B; H-NEW-ATTACHMENT-010 (P15-002/R3.12); (2) BC-INDEX BC-2.7.011 "214-byte cap" (P15-001); (3) BC-INDEX BC-3.9.005 en-dash→ASCII (P15-003); (4) BC-2.7.007 EC-2.7.007-10 --filter conflicts_with --id (P15-004); (5) BC-2.7.006 403 row (P15-005); (6) BC-2.7.007 EC-2.7.007-11 --out directory (P15-006); (7) BC-2.7.008/009 filtered-to-zero ECs (P15-007); (8) H-001/H-003 GET fixtures ?fields=attachment (P15-INFO-1); (9) impact-boundary R3.12 added. Spec version advances from 1.3.54 to 1.3.55. BC count unchanged at 657; holdout count advances from 97 to 98; VP count unchanged at 33.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r25) with no visibility into prior round reports.

1. **Independent artifact read**: All ten input artifacts were read fresh. Findings were formed before cross-referencing the P15 worklog.
2. **Quote-based closure**: Every P15 priority check is verified by verbatim quotation from the authoritative artifact. Quotes are not paraphrased.
3. **Residue scans**: Targeted greps and Python unicode scans for "255-byte cap", en-dash, "two consumers", ungated `--replace-existing` language, stale holdout 97.
4. **R3.12 keystone**: Seven keystone checks (gate mechanics ↔ consumers, guard order, EC-3.9.003-5 suppression, EC-3.9.020-7 all-consumers, BC-3.9.018 zero-match, EOF branch inheritance, H-004/H-010 complementary coverage) traced through artifact text.
5. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
6. **Count sweep**: BC (657), holdout (98), VP (33) verified across all relevant surfaces.
7. **STATE.md**: Three DEC-179 BC estimate sites verified (all say 33, arithmetic 12+20+1=33 confirmed); live status rows noted as stale (INFO-8).
