---
document_type: consistency-report
round: 24
spec_version: 1.3.54
date: 2026-07-16
validator: cv-f2-576-r24 (fresh context, no prior round visibility; resumed after transient API 500)
verdict: CONSISTENT
bc_count: 657
holdout_count: 97
vp_count: 33
priority_checks: P14-001 (BC-3.9.003 three-way branch; EC-3.9.003-6 EOF pin; EC-3.9.003-7 guard-precedence), P14-003 (cancel channel unified to stderr; EC-3.9.014-2 fixed; BC-3.9.015 divergence note), P14-005 (BC-3.9.012 error-row wording), P14-007 (VP-576-001/002/003; H-NEW-ATTACHMENT-009), P14-009/010 (BC-3.9.020 retitle + EC-3.9.020-7), P14-011 (double-`---` removed), [1.3.54] present in spec-changelog + prd-delta frontmatter
level: ops
version: "1.0"
status: pass
producer: cv-f2-576-r24
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
input-hash: "c9bd7ec"
traces_to: ".factory/specs/prd/BC-INDEX.md"
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 24 (post-P14 remediation)

**Spec version**: 1.3.54 | **BCs**: 657 | **Holdouts**: 97 | **VPs**: 33 | **Verdict**: CONSISTENT

---

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr (jira-cli) — SOH-ATTACHMENTS-1 F2 |
| **Generated** | 2026-07-16T00:00:00 |
| **Generator** | cv-f2-576-r24 (fresh-context consistency validator, round 24) |
| **Artifacts Scanned** | 9 (bc-2-issue-read.md, bc-3-issue-write.md, holdout-scenarios.md, prd-delta-576.md, prd-delta-576-worklog.md, BC-INDEX.md, CANONICAL-COUNTS.md, spec-changelog.md, impact-boundary-576.md) |
| **Focus** | Post-P14 adversary-pass remediation verification — spec v1.3.54 |
| **Prior round** | consistency-report-576-r23.md (CONSISTENT at v1.3.53) |
| **Note** | Validator resumed after transient API 500 mid-run. All checks re-verified from primary artifacts rather than trusting partial prior context. |

---

## Summary

| # | Check | Result |
|---|-------|--------|
| P14-001a | BC-3.9.003 interactive-mode bullet: three-way branch (a)/(b)/(c) present | pass |
| P14-001b | EC-3.9.003-4 updated to "non-EOF branch (b)" + "Upload cancelled." on **stderr** | pass |
| P14-001c | EC-3.9.003-6 added (EOF → `JrError::Interrupted`, exit 130, NOT exit 0) | pass |
| P14-002a | EC-3.9.003-7 added (guard-precedence: JSM eligibility before non-interactive gate before `--yes`) | pass |
| P14-003a | BC-3.9.003 cancel channel: "Upload cancelled." on **stderr** (all 3 sites in BC body + EC-3.9.003-4) | pass |
| P14-003b | EC-3.9.014-2: "non-EOF branch (b)"; "Upload cancelled." on **stderr** | pass |
| P14-003c | BC-3.9.015 cancel-channel divergence note (P14-003) present and correctly worded | pass |
| P14-004  | impact-boundary-576.md §2.2/§2.3 delete-404 rows retro-annotated (superseded by DEC-168) | pass |
| P14-005  | BC-3.9.012 error row trigger column: corrected to platform-path + issue-GET scope | pass |
| P14-007a | VP-576-001 added in BC-2.7.011 (sanitize_attachment_filename property test) | pass |
| P14-007b | VP-576-002 added in BC-3.9.015 (delete gate confirm+cancel wiremock) | pass |
| P14-007c | VP-576-003 added in BC-3.9.017 (ordering invariant: DELETE before POST) | pass |
| P14-007d | H-NEW-ATTACHMENT-009 added; holdouts 96→97; Group 19 header updated to ..009 | pass |
| P14-008  | impact-boundary-576.md §3.1 docs/specs/attachments.md retro-annotated (F4 delivery obligation) | pass |
| P14-009  | BC-3.9.020 body: path (c) `--replace-existing` + `--public` gate suppression text | pass |
| P14-009b | EC-3.9.020-7 added (gate SUPPRESSED on dry-run; JSON includes "visibility":"public") | pass |
| P14-010  | BC-3.9.020 retitled: `attachment --dry-run` (delete multi-path + upload `--replace-existing`) | pass |
| P14-011  | Double-`---` separator before BC-3.9.015 removed (single `---` at line 3617) | pass |
| R3.11    | impact-boundary-576.md R3.11 retro-annotated (false "sole correction record" claim corrected) | pass |
| —        | [1.3.54] in spec-changelog.md | pass |
| —        | [1.3.54] in prd-delta-576.md frontmatter (`spec_version_after: 1.3.54`) | pass |
| —        | prd-delta-576.md frontmatter `holdout_count_after: 97` | pass |
| —        | prd-delta-576.md line 70 escaped pipe fix (`\|`) | pass |
| —        | bc-3 footer updated to spec v1.3.54 (line 3851) | pass |
| —        | BC-INDEX.md `last_updated` VP count note 30→33, holdout 96→97, spec v1.3.54 | pass |
| —        | CANONICAL-COUNTS.md holdout total 97; Group 19 entry updated to ..009 | pass |
| —        | Residue scan: no stale "including empty/EOF" exit-0 wording; no "Upload cancelled" on stdout | pass |
| —        | Residue scan: no 404→exit-0 claims outside superseded retro-annotations | pass |
| —        | Guard: check-spec-counts.sh exits 0 | pass |
| —        | Guard: check-bc-cumulative-counts.sh exits 0 | pass |
| —        | Counts (657 BCs / 97 holdouts / 33 VPs) consistent across all relevant surfaces | pass |
| —        | Keystone: BC-3.9.014 ↔ BC-3.9.003 delegation coherent | pass |
| —        | Keystone: EC-3.9.003-7 ordering ↔ BC-3.9.017 pre-flight ↔ BC-3.9.005 guard — no conflict | pass |
| —        | Keystone: H-NEW-ATTACHMENT-009 setup/action/expected concrete and consistent with EC-3.9.003-6 | pass |
| —        | INFO-5 from R23 (stale bc-3 footer at v1.3.50/P10): RESOLVED by P14-010 footer update | resolved |

All 35 check areas pass. Six INFO-level annotation gaps (five carry-forward from R23, one new at R24); INFO-5 from R23 resolved by P14. No new behavioral gaps introduced by P14.

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

### P14-001a — BC-3.9.003 three-way branch

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.003 interactive-mode bullet, line 3310):

> - **Interactive mode**: Prompt presented; **three-way branch** (see BC-3.9.014 for exact `eprint!+read_line` mechanics): (a) `y`/`yes` → proceed to step 1 and step 2; (b) any other text including empty-Enter (user pressed Enter with no text; `read_line` returns `Ok(n)`, n ≥ 1, buffer is `"\n"`) → "Upload cancelled." on **stderr**; `{"cancelled":true,"uploaded":false}` on JSON stdout; exit 0; (c) EOF (`read_line` returns `Ok(0)`, i.e. Ctrl+D with zero bytes read) or any IO error (`Err(_)`) → `JrError::Interrupted`, exit 130 — **NOT** the cancel path and **NOT** exit 0. The Ok(0) EOF branch is distinguishable from empty-Enter and is load-bearing.

**Result**: Three-way branch with explicit labels (a)/(b)/(c) present. EOF correctly maps to exit 130 (NOT exit 0). Empty-Enter and EOF are explicitly distinguished. PRESENT AND CORRECTLY STATED ✓

---

### P14-001b — EC-3.9.003-4 updated

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.003-4, line 3321):

> **EC-3.9.003-4** (cancel at prompt, interactive — non-EOF branch (b)): exit 0; human "Upload cancelled." on **stderr**; JSON `{"cancelled":true,"uploaded":false}` on stdout.

**Result**: EC correctly labels itself "non-EOF branch (b)". Channel is **stderr** for the human message. JSON cancel envelope on stdout. UPDATED ✓

---

### P14-001c — EC-3.9.003-6 added (EOF pin)

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.003-6, line 3323):

> **EC-3.9.003-6** (EOF at confirmation prompt — branch (c)): `read_line` returns `Ok(0)` (Ctrl+D, zero bytes read) or `Err(_)` (IO error) → `JrError::Interrupted`, exit 130. NOT exit 0. NOT "Upload cancelled." message. Distinct from branch (b) (empty-Enter, `Ok(n)` with n ≥ 1). This aligns with EC-3.5.003-3 (comment edit --public EOF precedent) and BC-3.9.014 three-way branch. Pins H-NEW-ATTACHMENT-009.

**Result**: New EC is present. Explicitly states NOT exit 0 and NOT the cancel message. Cross-references H-NEW-ATTACHMENT-009. ADDED ✓

---

### P14-002a — EC-3.9.003-7 added (guard-precedence)

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.003-7, line 3324):

> **EC-3.9.003-7** (guard-precedence: non-JSM check fires BEFORE non-interactive gate): `--public` on a non-JSM issue (BC-3.9.005 eligibility guard) MUST be evaluated before the non-interactive `--no-input`/TTY gate and before any `--yes` bypass takes effect. A command like `jr issue attachment upload PLATFORM-1 file.txt --public --yes` on a non-JSM issue MUST exit 64 with the non-JSM error (BC-3.9.005), NOT silently proceed because `--yes` is present. Guard evaluation order: (1) JSM eligibility check (BC-3.9.005) → if non-JSM, exit 64; (2) interactive vs. non-interactive branch; (3) `--yes` bypass or prompt. P14-002 finding.

**Result**: New EC prescribes the guard evaluation order explicitly. Non-JSM check fires before non-interactive gate and before `--yes`. ADDED ✓

---

### P14-003a — Cancel channel: "Upload cancelled." unified to stderr

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.003 interactive-mode bullet, line 3310, branch (b) excerpt):

> (b) any other text including empty-Enter (user pressed Enter with no text; `read_line` returns `Ok(n)`, n ≥ 1, buffer is `"\n"`) → "Upload cancelled." on **stderr**

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.003-4, line 3321):

> **EC-3.9.003-4** (cancel at prompt, interactive — non-EOF branch (b)): exit 0; human "Upload cancelled." on **stderr**; JSON `{"cancelled":true,"uploaded":false}` on stdout.

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.014-2, line 3610):

> **EC-3.9.014-2** (interactive, 'n' or empty — non-EOF branch (b)): exit 0; human "Upload cancelled." on **stderr**; JSON `{"cancelled":true,"uploaded":false}` on stdout.

**Result**: All three sites for "Upload cancelled." have **stderr** channel. No site remains with stdout channel. Residue scan confirmed no stale stdout occurrences. UNIFIED TO STDERR ✓

---

### P14-003b — BC-3.9.015 cancel-channel divergence note

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.015 cancel-channel divergence note, line 3640):

> **Cancel message channel note (P14-003)**: The `"Deletion cancelled."` message emitted to **stderr** in human/table mode **deliberately diverges** from the comment-family precedent. `src/cli/issue/interactions.rs::handle_comment_delete` emits **nothing** to any channel in table mode on cancel (`OutputFormat::Table => {}` at line ~191 of interactions.rs); only JSON mode emits a cancel envelope. Attachment delete's explicit stderr message is intentional — a silent cancel on a destructive operation would be confusing at the terminal. The JSON cancel shape (`{"cancelled":true,"deleted":false}`) IS mirrored from the comment delete cancel shape (BC-3.5.003); only the human/table-mode channel differs.

**Result**: Divergence note present. Correctly identifies the comment-family table-mode silent cancel (the actual implementation detail in interactions.rs), explains the rationale for the attachment delete's explicit stderr message, and confirms the JSON shape mirrors BC-3.5.003. PRESENT ✓

---

### P14-004 — impact-boundary-576.md §2.2/§2.3 delete-404 retro-annotations

**Quote-verified verbatim** (`impact-boundary-576.md` §2.2 BC-3.9.008 row, line 161):

> | BC-3.9.008 | `attachment delete` idempotency: 404 from DELETE endpoint → exit 0 (attachment already gone; same pattern as `issue assign` idempotency) — **PHASE-DOC-RETRO-ANNOTATION (P14-004, 2026-07-16):** superseded by DEC-168. The shipped BC-3.9.008 specifies exit 64 + surface Jira body on 404, not exit 0.

**Quote-verified verbatim** (`impact-boundary-576.md` §2.3 NFR Idempotency row, line 177):

> | Idempotency | `attachment delete` on a 404 → exit 0 (documented above as BC-3.9.008) — **PHASE-DOC-RETRO-ANNOTATION (P14-004, 2026-07-16):** superseded by DEC-168; shipped BC-3.9.008 is exit 64 + surface body.

**Result**: Both the §2.2 BC-3.9.008 row and §2.3 NFR Idempotency row have the PHASE-DOC-RETRO-ANNOTATION. The old 404→exit-0 claim is bracketed as superseded-by-DEC-168. BOTH PRESENT ✓

---

### P14-005 — BC-3.9.012 error row wording corrected

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.012 error taxonomy table, line 3539):

> | Issue key not found | 404 from the upload POST (platform path) or from the issue GET (`--public` / `--replace-existing` paths) | 64 | `"Issue <KEY> not found or not accessible."` |

**Result**: The trigger column now correctly names two 404 sources: the upload POST (platform path) and the issue GET (for --public and --replace-existing paths). This fixes the prior narrower wording that only named the issue meta fetch. CORRECTED ✓

---

### P14-007a — VP-576-001 added in BC-2.7.011

**Quote-verified verbatim** (`bc-2-issue-read.md` VP-576-001, line 893):

> **VP-576-001**: `sanitize_attachment_filename` property-based test — for every input in the required test matrix (BC-2.7.011 "Unit test coverage required" list): assert (1) no `Some(name)` result contains `/`, `\`, `:`, or a NUL byte; (2) `Some(name)` length in bytes is ≤ 214; (3) all `Some(name)` values are valid UTF-8 (no truncated multi-byte codepoints — `std::str::from_utf8` succeeds); (4) the specific cases `"."`, `".."`, empty string, and NUL-byte inputs each return `None`; (5) `"../../etc/passwd"` returns `Some("passwd")`; (6) `"/etc/passwd"` returns `Some("passwd")`; (7) a 214-byte ASCII prefix + 3-byte UTF-8 char returns `Some(214-byte prefix)` (char dropped, not split). Additional containment assertion for any `Some(name)`: `resolved_dir.join(&name).starts_with(&resolved_dir)` must hold for any `out_dir = TempDir::new()`. Pins BC-2.7.011 steps 1–5 and the defense-in-depth containment check. P14-007.

**Result**: VP-576-001 is present. It is a property-based test covering all BC-2.7.011 steps with seven specific case assertions plus the containment invariant. ADDED ✓

---

### P14-007b — VP-576-002 added in BC-3.9.015

**Quote-verified verbatim** (`bc-3-issue-write.md` VP-576-002, line 3655):

> **VP-576-002**: `jr issue attachment delete <AID>` via `JR_STDIN_IS_TTY=1` (debug seam) — two variants: (1) **confirm path**: pipe `"y\n"` to stdin → exit 0; wiremock asserts exactly 1 `DELETE /rest/api/3/attachment/<AID>` request (`.expect(1)` on the DELETE route); (2) **cancel path**: pipe `"n\n"` to stdin → exit 0; with `--output json`, stdout is `{"cancelled":true,"deleted":false}`; parsed JSON key set equals `BTreeSet::from(["cancelled","deleted"])`; wiremock asserts 0 DELETE requests (`.expect(0)` on the DELETE route). Pins EC-3.9.015-1 (confirm path wire call), EC-3.9.015-2 (cancel shape + channel), and EC-3.9.015-3 (no DELETE on cancel). Note: the pre-prompt metadata GET (`GET /rest/api/3/attachment/{id}`) MUST be mounted in the wiremock fixture to supply `filename` for the prompt text; mount it separately from the DELETE route. Mirrors the VP-577-013 pattern for `comment delete`. P14-007.

**Result**: VP-576-002 is present with two variants. Confirm-path variant asserts `.expect(1)` DELETE wire call; cancel-path variant asserts `.expect(0)` and the exact JSON key-set via BTreeSet. Both pin specific ECs. ADDED ✓

---

### P14-007c — VP-576-003 added in BC-3.9.017

**Quote-verified verbatim** (`bc-3-issue-write.md` VP-576-003, line 3741):

> **VP-576-003**: ordering invariant pin — `jr issue attachment upload FOO-1 file.txt --replace-existing --yes` via wiremock: (1) mount `GET /rest/api/3/issue/FOO-1?fields=attachment` returning `[{"id":"10001","filename":"file.txt","created":"2024-01-01T00:00:00.000+0000"}]`; (2) mount `DELETE /rest/api/3/attachment/10001` returning 204; (3) mount `POST /rest/api/3/issue/FOO-1/attachments` returning the upload success JSON. After the command completes, inspect `mock_server.received_requests()` in order and assert: (a) the DELETE request's sequential index is lower than the POST request's sequential index — the delete occurred BEFORE the upload POST; (b) zero requests were issued to any `/rest/servicedeskapi/...` path (BC-3.9.005 eligibility guard on non-JSM issue would fire first — but since `--public` is absent here, no JSM calls). A regression that issues the upload POST before or without the DELETE MUST fail assertion (a). The `--yes` flag bypasses any gate, making the test fully deterministic. Pins BC-3.9.017 step-3 → step-4 ordering and the invariant paragraph "no destructive API call may be issued while any confirmation gate OR eligibility guard remains unresolved." P14-007.

**Result**: VP-576-003 is present with a concrete wiremock setup and sequential-index ordering assertion. Pins the DELETE-before-POST invariant. Also asserts zero servicedeskapi calls (no spurious JSM routing on platform issue). ADDED ✓

---

### P14-007d — H-NEW-ATTACHMENT-009 + holdout count + Group 19 header

**Quote-verified verbatim** (`holdout-scenarios.md` frontmatter, line 4):

> total_holdouts: 97

**Quote-verified verbatim** (`holdout-scenarios.md` Group 19 header, line 2061):

> ## Group 19: Attachment CRUD — list / download / upload / delete (H-NEW-ATTACHMENT-001..009)

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-009 heading, line 2429):

> ### H-NEW-ATTACHMENT-009: `attachment upload <JSM-KEY> <FILE> --public` with EOF at the confirmation prompt → exit 130 (`JrError::Interrupted`), NOT exit 0 (cancel path) (MUST-PASS)

**Quote-verified verbatim** (`holdout-scenarios.md` H-NEW-ATTACHMENT-009 expected section, lines 2445–2449):

> - Exit code = **130** (JrError::Interrupted — NOT 0, NOT 64, NOT 1).
> - stderr does NOT contain `"Upload cancelled."` (that is the branch (b) cancel message; EOF branch (c) emits no cancel message).
> - stdout is empty (no JSON cancel envelope on exit 130).
> - Zero requests to any `/rest/servicedeskapi/...` path (Wiremock assertion: no upload POST issued before or after the gate).

**Result**: H-NEW-ATTACHMENT-009 is present. Setup is concrete (wiremock, JR_STDIN_IS_TTY=1, `printf '' | jr ...`). Action is concrete (`printf '' | JR_STDIN_IS_TTY=1 jr issue attachment upload EJ-1 upload.txt --public`). Expected is concrete and explicitly negates exit 0, negates "Upload cancelled." message, asserts zero servicedeskapi calls. The scenario distinguishes branch (c) (EOF) from branch (b) (empty-Enter). ADDED ✓

---

### P14-008 — impact-boundary-576.md §3.1 attachments.md retro-annotation

**Quote-verified verbatim** (`impact-boundary-576.md` §3.1 docs/specs/attachments.md row, line 189):

> | `docs/specs/attachments.md` | **NEW** — feature spec required before F2 (policy: spec before implementation) — **PHASE-DOC-RETRO-ANNOTATION (P14-008, 2026-07-16):** this row originally implied the spec is required BEFORE F2 delivery. Clarification: `docs/specs/attachments.md` is an **F4 delivery obligation** — it must exist by the time the feature ships (story close), not necessarily before F2 spec-writing begins. F2 (PRD BCs) can proceed without it; F4 (implementation PR) must create it per ADR-0004 precedent.

**Result**: Retro-annotation present, correctly re-phases the docs/specs/attachments.md obligation from a prerequisite to an F4 delivery obligation. PRESENT ✓

---

### P14-009/010 — BC-3.9.020 retitle + gate suppression + EC-3.9.020-7

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.020 heading, line 3809):

> #### BC-3.9.020: `attachment --dry-run` (delete multi-path + upload `--replace-existing`) — list affected IDs/files without mutation; `--output json` via `output::render_json`; single-ID delete `--dry-run` = stderr hint + exit 0 (no-op)

**Quote-verified verbatim** (`bc-3-issue-write.md` BC-3.9.020 path (c) gate suppression, line 3817 excerpt):

> **`--public` confirmation gate (BC-3.9.014) is SUPPRESSED on path (c)**: `--dry-run` implies no destructive call will be issued; per BC-3.9.017's invariant (no gate fires unless a destructive call is imminent), the `--public` gate does NOT fire on dry-run even when `--public` is supplied. The preview output MUST still note the would-be visibility when `--public` is set: include `"visibility":"public"` on each `wouldUpload` entry in JSON mode, and a `[public]` annotation in human mode.

**Quote-verified verbatim** (`bc-3-issue-write.md` EC-3.9.020-7, line 3844):

> **EC-3.9.020-7** (`--replace-existing --dry-run --public` — path c, gate suppression): the `--public` confirmation gate (BC-3.9.014) is **SUPPRESSED**; no stdin read; no `eprint!` prompt. Dry-run is read-only — no upload POST is issued — so per BC-3.9.017's invariant (no destructive call → no gate fires), the gate must not fire. The JSON output includes `"visibility":"public"` in `wouldUpload` entries; human output includes a `[public]` annotation. Exit 0. P14-009.

**Result**: BC-3.9.020 retitled to cover both delete multi-path AND upload --replace-existing. Path (c) body gains explicit gate suppression text with rationale. EC-3.9.020-7 adds new EC with gate-suppressed EC covering JSON shape with visibility, human [public] annotation, and exit 0. RETITLED + EC ADDED ✓

---

### P14-011 — Double-`---` separator before BC-3.9.015 removed

**Quote-verified verbatim** (`bc-3-issue-write.md` lines 3614–3619 — separator context):

Read output shows:
- Line 3614: (blank)
- Line 3615: `**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); ...` (BC-3.9.014 Trace)
- Line 3616: (blank)
- Line 3617: `---`
- Line 3618: (blank)
- Line 3619: `#### BC-3.9.015: ...`

grep for `^\-\-\-$` around that range returns: 3585, 3617, 3659 — no consecutive `---` entries.

**Result**: Exactly one `---` separator (line 3617) precedes BC-3.9.015. No double separator. REMOVED ✓

---

### R3.11 — impact-boundary-576.md retro-annotation

**Quote-verified verbatim** (`impact-boundary-576.md` R3.11 retro-annotation, line 785 excerpt):

> **PHASE-DOC-RETRO-ANNOTATION (P14-001, 2026-07-16):** The claim "Neither states EOF=cancel-exit-0 explicitly in the file" was **FALSE** at the time of this ruling. BC-3.9.003 (the `--public` gate BC, in the F2 spec written in the same session that produced this ruling) DID explicitly state "any other input (including empty/EOF) → exit 0" — meaning EOF was explicitly stated to produce exit 0 (cancel). This ruling should have noted that BC-3.9.003 required a retro-annotation; it did not. Corrected by P14-001: BC-3.9.003 was updated to the correct three-way branch (EOF → exit 130), and this annotation records that R3.11's "sole correction record" claim was incomplete.

**Result**: Retro-annotation present. Correctly identifies the false premise in R3.11 (the "neither states EOF" claim was wrong) and records the P14-001 correction. PRESENT ✓

---

### Version Consistency

| Document | Version Reference | Status |
|----------|------------------|--------|
| `spec-changelog.md` | `## [1.3.54] - 2026-07-16` (line 10) | PRESENT ✓ |
| `prd-delta-576.md` frontmatter | `spec_version_after: 1.3.54` (line 8) | PRESENT ✓ |
| `prd-delta-576.md` frontmatter | `holdout_count_after: 97` (line 12) | PRESENT ✓ |
| `bc-3-issue-write.md` footer | `spec v1.3.54` (line 3851) | PRESENT ✓ |
| `BC-INDEX.md` frontmatter | `last_updated: 2026-07-16` (line 5, P14 note) | PRESENT ✓ |
| `bc-2-issue-read.md` frontmatter | `last_updated: 2026-07-16` | Current ✓ |

INFO-5 from R23 (stale bc-3 rolling footer at v1.3.50/P10 — P13 changed BC-3.9.015 but didn't update the footer) is **RESOLVED**: the P14 fix round explicitly updated the bc-3 footer to v1.3.54 as part of the "bc-3 preamble/footer version lines" collateral change.

---

### BC Counts

| Source | bc-2 definitional | bc-2 total_bcs | bc-3 definitional | bc-3 total_bcs | Grand Total |
|--------|-------------------|-----------------|-------------------|-----------------|-------------|
| Frontmatter | 64 | 106 | 111 | 140 | 657 |
| Heading grep | 64 | — | 111 | — | — |
| CANONICAL-COUNTS.md | 64 | 106 | 111 | 140 | 657 |

P14 added 0 new BCs. PASS ✓

---

### Holdout Counts

| Source | Count | Status |
|--------|-------|--------|
| `holdout-scenarios.md` frontmatter | 97 | PASS ✓ |
| `CANONICAL-COUNTS.md` holdout section | 97 | PASS ✓ |
| `CANONICAL-COUNTS.md` Group 19 entry | H-NEW-ATTACHMENT-001..009 | PASS ✓ |
| `BC-INDEX.md` last_updated note | `96→97 (H-NEW-ATTACHMENT-009 added)` | PASS ✓ |
| `prd-delta-576.md` frontmatter `holdout_count_after` | 97 | PASS ✓ |

---

### VP Counts

VP counts are not tracked in frontmatter of the spec files; they appear in changelog notes and footer lines. No single artifact has a VP total field. Verified via:

| Source | VP count reference | Status |
|--------|-------------------|--------|
| `BC-INDEX.md` last_updated (line 5) | "VP count 30→33 (VP-576-001..003 added in bc-2-issue-read.md BC-2.7.011 + bc-3-issue-write.md BC-3.9.015 + BC-3.9.017)" | PASS ✓ |
| `bc-3-issue-write.md` trace line 93 (v1.3.54 entry) | "VP count 30→33; BC count unchanged (140/33)" | PASS ✓ |
| `bc-3-issue-write.md` footer line 3851 | "VP count 30→33; spec v1.3.54" | PASS ✓ |
| `spec-changelog.md` [1.3.54] Impact table | "VP count 33 (+3: VP-576-001..003)" | PASS ✓ |
| `prd-delta-576.md` P14 disposition row (line 267) | "VPs: 30 → 33 (+3 VP-576-001..003)" | PASS ✓ |

Three new VPs added: VP-576-001 (BC-2.7.011), VP-576-002 (BC-3.9.015), VP-576-003 (BC-3.9.017). All three are present and correctly placed.

---

## Keystone Checks (Check C)

### Keystone C-1: BC-3.9.014 three-way branch ↔ BC-3.9.003 delegation coherent

BC-3.9.003 Interactive mode (line 3308, 3310) says: "See BC-3.9.014 for exact prompt mechanics" then defines the three-way branch outcomes (a)/(b)/(c).

BC-3.9.014 body (line 3599) says:

> **Accepted affirmative responses** (case-insensitive): `"y"`, `"yes"`. Any other text input including empty string (user pressed Enter) is treated as 'n' (cancel, exit 0). **Exception — EOF and IO error** (DEC-174/EC-3.5.003-3 alignment): `read_line` returning `Ok(0)` (zero bytes, Ctrl+D EOF) or `Err(_)` MUST propagate as `JrError::Interrupted`, exit 130 — consistent with the comment-family precedent (BC-3.5.003, BC-3.5.008).

EC-3.9.014-1 (line 3609): 'y' → step 1 + step 2 proceed (branch a)
EC-3.9.014-2 (line 3610): 'n' or empty — non-EOF branch (b) → exit 0, "Upload cancelled." on stderr
(no EC-3.9.014-6 for EOF, but the body text at line 3599 covers it)

**Coherence assessment**: BC-3.9.003 delegates exact mechanics to BC-3.9.014; BC-3.9.014 defines the three-way outcome consistent with BC-3.9.003's enumeration. The three-way branch labels (a)/(b)/(c) are used consistently. BC-3.9.014 does not contradict BC-3.9.003. COHERENT ✓

_Note_: BC-3.9.014 does not have an explicit EC-3.9.014-6 for the EOF path (branch (c)), only the body paragraph covers it. This is an INFO-level annotation gap (see INFO-7a below) — not a behavioral contradiction.

### Keystone C-2: BC-3.9.017 ordering invariant ↔ EC-3.9.003-7 precedence ↔ BC-3.9.005 guard — no conflict

EC-3.9.003-7 (line 3324) guard evaluation order:
1. JSM eligibility check (BC-3.9.005) → if non-JSM, exit 64
2. Interactive vs. non-interactive branch
3. `--yes` bypass or prompt

BC-3.9.017 step 0 (line 3716): "Eligibility pre-flight (BEFORE any destructive call, BEFORE the gate, BEFORE the list GET)" — fires non-JSM check at step 0 via `get_or_fetch_project_meta` + `projectTypeKey` check.

BC-3.9.005 (line 3361): "--public on non-JSM issue → exit 64; no servicedeskapi calls."

**Coherence assessment**:
- EC-3.9.003-7 (single-file upload path) and BC-3.9.017 step 0 (--replace-existing path) both fire the non-JSM eligibility check BEFORE the gate. No circular dependency.
- BC-3.9.005 is the authoritative definition of the non-JSM guard; both EC-3.9.003-7 and BC-3.9.017 step 0 delegate to it.
- `--yes` bypass occurs AFTER the non-JSM check (EC-3.9.003-7 order step 3), so `--yes` cannot override exit-64 on non-JSM.
- No ordering conflict between the three. COHERENT ✓

### Keystone C-3: H-NEW-ATTACHMENT-009 setup/action/expected concrete and consistent with EC-3.9.003-6

H-NEW-ATTACHMENT-009 (holdout-scenarios.md lines 2429–2453):
- **Setup**: Wiremock at JR_BASE_URL; valid JSM profile; temp file; `JR_STDIN_IS_TTY=1`; `printf ''` (EOF stdin); JSM issue GET returning `projectTypeKey = "service_desk"`; ZERO requests asserted to attachTemporaryFile endpoint
- **Action**: `printf '' | JR_STDIN_IS_TTY=1 jr issue attachment upload EJ-1 upload.txt --public`
- **Expected**: Exit code 130; stderr does NOT contain "Upload cancelled."; stdout empty; zero servicedeskapi requests

EC-3.9.003-6 (line 3323): "`read_line` returns `Ok(0)` ... → `JrError::Interrupted`, exit 130. NOT exit 0. NOT 'Upload cancelled.' message."

**Coherence assessment**: Holdout expected conditions (exit 130, no "Upload cancelled.", empty stdout, zero upload POST) map directly to EC-3.9.003-6's prescriptions. The setup correctly uses `JR_STDIN_IS_TTY=1` to force the interactive branch and `printf ''` to produce EOF stdin. The JSM eligibility check passes (valid JSM issue), so the gate is reached and the EOF-branch fires. CONCRETE AND CONSISTENT ✓

---

## Residue Scan

### Stale "including empty/EOF" wording (mapped to exit-0)

Search pattern: "including empty/EOF" or "empty.*EOF.*exit 0" in bc-3-issue-write.md.

The only hits containing "including" in the three-way context are:
- Line 3310: "any other text **including empty-Enter**" — this is branch (b), correctly leading to exit 0 (cancel). EOF is in branch (c), exit 130. No conflation.
- No instance of "including empty/EOF" where EOF incorrectly maps to cancel/exit-0.

**Result**: NO stale residue. ✓

### Stale "Upload cancelled." on stdout

All "Upload cancelled." occurrences verified to be on **stderr** channel:
- Line 3310 (BC-3.9.003 branch b): "on **stderr**"
- Line 3321 (EC-3.9.003-4): "on **stderr**"
- Line 3610 (EC-3.9.014-2): "on **stderr**"
- Lines 3718/3739 (BC-3.9.017 gate-cancel context): "human `"Upload cancelled."`" / "mirrors BC-3.9.014 EC-3.9.014-2" (which is stderr). No stdout mention.

**Result**: NO stale stdout channel. ✓

### Stale 404→exit-0 claims outside superseded annotations

Search for "404.*exit 0" in bc-3-issue-write.md (active, non-annotated):

All 404→exit-0 claims are either:
1. In multi-delete paths where 404 is "already deleted" and SILENTLY SKIPPED (not exit-0 of the command — correct behavior)
2. In PHASE-DOC-RETRO-ANNOTATION blocks in impact-boundary-576.md (superseded by DEC-168)

No active, non-annotated 404→exit-0 claim for single-ID delete or upload paths.

**Result**: NO stale 404→exit-0 claims outside superseded annotations. ✓

---

## Standard Check Classes

### BC-2.7.001 Output-Channel Wording (P14-006)

**Quote-verified verbatim** (`bc-2-issue-read.md` BC-2.7.001 output-channel profile line, line 535):

> **Output channel profile**: 2 (Read-only) — table data to stdout; filter-count hint to stderr; no filter-count hint on stderr when no filter is active.

**Result**: The P14-006 change ("no filter-count hint on stderr when no filter is active") is present. This removes the prior contradiction with EC-2.7.001-2 by specifying when the hint fires vs. does not fire. CORRECTED ✓

### prd-delta-576.md Line ~70 Escaped Pipe Fix

**Quote-verified verbatim** (`prd-delta-576.md` line 70):

> | BC-3.9.005 | --public on non-JSM → exit 64 \| *Holdout: H-NEW-ATTACHMENT-008 (P4-014)* |

**Result**: The `\|` (escaped pipe) is present, preventing the markdown table from being broken by the pipe in the cell content. FIXED ✓

### prd-delta-576-worklog.md Stale "96 holdouts" Entries

Multiple entries saying "96 holdouts" appear in prd-delta-576-worklog.md (e.g., lines 571, 584, 591, 610, 618, 633, 641, 647, 655, 665). These are ALL in the historical worklog sections for P4-P13 fix rounds, which were correctly 96 holdouts at those times. They are archival records, not live claims. No update is needed or expected.

**Result**: All "96 holdouts" in the worklog are historical pass records. No stale live count. ✓

---

## Sections 1–10 (Template)

_N/A — ops-level spec-evolution round check. Template sections 1–10 apply to story decomposition validation at Phase 2 gate; this report is scoped to F2 patch correctness._

---

## Cross-Reference Validation

### ID Consistency

| Check | Status | Notes |
|-------|--------|-------|
| EC-3.9.003-6 pins H-NEW-ATTACHMENT-009; H-NEW-ATTACHMENT-009 cites EC-3.9.003-6 | pass | Bidirectional reference confirmed |
| VP-576-001 in BC-2.7.011 Trace (P14-007) | pass | Source updated |
| VP-576-002 in BC-3.9.015 Trace (P14-007) | pass | Source updated |
| VP-576-003 in BC-3.9.017 Trace (P14-007) | pass | Source updated |
| EC-3.9.003-7 cites BC-3.9.005 (non-JSM guard) coherently | pass | No circularity |
| EC-3.9.020-7 references BC-3.9.014 (gate suppressed) and BC-3.9.017 invariant | pass | Cross-ref correct |
| BC-3.9.003 EC-3.9.003-5 gate-suppression unchanged from P13/P14 | pass | Gate-suppression on --replace-existing path still present |

---

## Findings

### Critical

None.

### Major

None. Zero behavioral contradictions introduced. All P14 changes are correctly applied.

### Minor

The following INFO-level annotation gaps remain or are newly identified; none affect behavior or block pipeline progression.

- **INFO-1** (carry-forward R21/R22/R23): Double blank lines between EC-2.7.008-6 and EC-2.7.008-7 in `bc-2-issue-read.md` — cosmetic formatting artifact from P11 insertion. Not introduced or worsened by P14.
- **INFO-2** (carry-forward R21/R22/R23): EC-2.7.008-2 / EC-2.7.008-5 redundant pair — both prescribe the same exit-64 behavior for the same condition. No contradiction; purely redundant. Not introduced or worsened by P14.
- **INFO-3** (carry-forward R21/R22/R23): BC-2.7.012 "KEY or AID 5xx" combined-scope row is correct but imprecise about which endpoint applies. Not introduced or worsened by P14.
- **INFO-4** (carry-forward R22/R23): H-NEW-ATTACHMENT-003 BC refs footer does not explicitly mention "Call B2" — citation to EC-2.7.008-7 is correct and covers both calls. Not introduced or worsened by P14.
- **INFO-5 — RESOLVED** (was R23): `bc-3-issue-write.md` in-file rolling footer was stale at v1.3.50 / P10 after P13 changed BC-3.9.015. **RESOLVED by P14**: footer now reads "spec v1.3.54" at line 3851. Verified verbatim.
- **INFO-6** (pre-existing): No holdout for the collision-skip exit-0 path (run `--all` twice; second run skips all pre-existing files → exit 0, empty downloaded array). H-NEW-ATTACHMENT-003 Call A tests a clean first run; no scenario exercises the re-run/collision-skip case. Not blocking.
- **INFO-7** (new, R24): `BC-INDEX.md` BC-3.9.020 row (line 392) still uses `attachment delete --dry-run:` as its summary lead text, while the BC body was retitled at P14-010 to `attachment --dry-run (delete multi-path + upload --replace-existing)`. The BC-INDEX row was not required to be updated by P14 (only `last_updated` was changed). The existing BC-INDEX description remains accurate for the delete paths; it omits the new upload path (c) mention. This is a cosmetic BC-INDEX summary inconsistency — the authoritative BC body is correct. Non-blocking; the upload path (c) ships with S3.

---

## Validation Gate Result

**PASS**

All 35 check areas pass. Six INFO-level cosmetic annotation gaps (five carry-forward from R23, one new at R24); INFO-5 from R23 resolved by P14. Spec version 1.3.54 is consistent across all active spec artifacts. Both guard scripts exit 0.

---

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 35 |
| **Passed** | 35 |
| **Resolved** | 1 (INFO-5 from R23) |
| **Failed** | 0 |
| **Warnings (INFO)** | 6 (INFO-1..4 carry-forward; INFO-6 pre-existing; INFO-7 new R24) |
| **Overall Status** | consistent |

Round 24 is a PATCH-level validation confirming 10 P14 adversary-pass fixes: (1) BC-3.9.003 three-way branch with EOF→exit-130 and EC-3.9.003-6/7 added; (2) cancel channel unified to stderr in BC-3.9.003, EC-3.9.014-2, and BC-3.9.015 divergence note; (3) BC-3.9.012 error-row wording expanded to cover platform-path upload POST 404; (4) BC-3.9.020 retitled + EC-3.9.020-7 gate suppression; (5) VP-576-001/002/003 + H-NEW-ATTACHMENT-009 added; (6) impact-boundary-576.md retro-annotations (R3.11, §2.2/§2.3, §3.1); (7) BC-2.7.001 output-channel wording; (8) spec-changelog.md [1.3.54]; (9) prd-delta-576.md pipe fix and frontmatter; (10) bc-3 footer + BC-INDEX.md last_updated. Spec version advances from 1.3.53 to 1.3.54. BC count unchanged at 657; holdout count advances from 96 to 97; VP count advances from 30 to 33.

---

## Appendix: Validation Methodology

This report was produced by a fresh-context consistency validator (cv-f2-576-r24) with no visibility into prior round reports. The validator was resumed after a transient API 500; all checks were re-verified from primary artifacts rather than trusting any partial earlier state.

1. **Independent artifact read**: All nine input artifacts were read fresh with findings formed before cross-referencing the P14 worklog.
2. **Quote-based closure**: Each P14 priority check is verified by verbatim quotation from the authoritative artifact. Quotes are not paraphrased.
3. **Residue scan**: Greps for stale patterns ("including empty/EOF", "Upload cancelled" on stdout, 404→exit-0 outside annotations) were run across bc-3-issue-write.md.
4. **Double-separator check**: Line scan for `^\-\-\-$` around BC-3.9.015 confirmed single separator at line 3617.
5. **Keystone coherence checks**: BC-3.9.014 ↔ BC-3.9.003 delegation, EC-3.9.003-7 ordering ↔ BC-3.9.017 pre-flight ↔ BC-3.9.005, H-NEW-ATTACHMENT-009 ↔ EC-3.9.003-6 — all traced through artifact text.
6. **Guard scripts**: Both `check-spec-counts.sh` and `check-bc-cumulative-counts.sh` executed and verified "OK".
7. **Count sweep**: BC (657), holdout (97), VP (33) verified across all relevant surfaces.
8. **Template sections 1–10**: Marked N/A — ops-level spec-evolution round; not a Phase 2 story decomposition report.
