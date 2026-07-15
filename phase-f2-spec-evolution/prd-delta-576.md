---
document_type: prd-delta
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
spec_version_before: 1.3.42
spec_version_after: 1.3.44
bc_count_before: 624
bc_count_after: 651
holdout_count_before: 88
holdout_count_after: 88
---

# PRD Delta — SOH-ATTACHMENTS-1 Attachment Read/Write (issues #576 + #585)

## Summary

F2 spec evolution for the SOH-ATTACHMENTS-1 feature bundle (issues #576 + #585). Adds 27
new individually-bodied BCs across three BC files, establishing the full aspirational
behavioral specification for `jr attachment list`, `jr attachment download`, `jr attachment
upload`, and `jr attachment delete`. Issue #585 (contentUrl surface) is absorbed into
BC-2.7.002. All design decisions ratified by DEC-179.

---

## Scope

| Story | Feature | BC coverage |
|-------|---------|------------|
| S1 | `jr attachment list` (list + filter) | BC-2.7.001..006 |
| S2 | `jr attachment download` (single/batch/newest) | BC-2.7.007..012 |
| S3 | `jr attachment upload` (platform POST) | BC-3.9.001..002, BC-3.9.009, BC-3.9.012 |
| S4 | `jr attachment delete` | BC-3.9.008, BC-3.9.010, BC-3.9.013 |
| S5 | `jr attachment upload --public/--internal` (JSM visibility) | BC-3.9.003..007, BC-3.9.011, BC-3.9.014, BC-X.8.010 |

---

## BC Enumeration

### Section 2.7 — Attachment Read (bc-2-issue-read.md)

12 new individually-bodied BCs appended as `### 2.7 Attachment Read`.

| BC ID | Title |
|-------|-------|
| BC-2.7.001 | Attachment list table output (id, filename, mimeType, size, created, author; profile 2) |
| BC-2.7.002 | Attachment list JSON shape including contentUrl; #526 invariant; closes #585 |
| BC-2.7.003 | --filter mime=<glob> client-side mimeType filter |
| BC-2.7.004 | --filter name=<glob> client-side filename filter; JRACLOUD-96384 |
| BC-2.7.005 | --filter size-max=<bytes> client-side size filter |
| BC-2.7.006 | Unknown/inaccessible KEY → exit 64; error taxonomy |
| BC-2.7.007 | Single-file download: redirect-following, no ?redirect=false, streaming, overwrite-refuse, JSDCLOUD-10841 |
| BC-2.7.008 | --all batch download to --out-dir; fail-soft; dir-not-exist exit 64 |
| BC-2.7.009 | --newest N top-N by created desc |
| BC-2.7.010 | Default output path SHA-1(attachment-id)_basename; --out override |
| BC-2.7.011 | sanitize_attachment_filename CWE-22 5-step algorithm; containment check |
| BC-2.7.012 | Unknown KEY/AID exit 64; match-by-id invariant (JRACLOUD-96384/-78388) |

### Section 3.9 — Attachment Write (bc-3-issue-write.md)

14 new individually-bodied BCs appended as `### 3.9 Attachment Write`.

| BC ID | Title |
|-------|-------|
| BC-3.9.001 | Platform upload POST; X-Atlassian-Token; streaming; no cap; 413/400 |
| BC-3.9.002 | JSM upload, no flag → platform POST (internal by default, P2-4a) |
| BC-3.9.003 | --public → servicedeskapi two-step; DEC-174 confirmation gate; --yes bypass |
| BC-3.9.004 | --internal → two-step public:false; no gate; non-JSM = silent no-op (OQ-9) |
| BC-3.9.005 | --public on non-JSM → exit 64 |
| BC-3.9.006 | temporaryAttachmentId ~1h TTL; second-step failure retry hint |
| BC-3.9.007 | Post-upload echo; P2-3c deferred; JSDCLOUD-10841 ban |
| BC-3.9.008 | attachment delete → DELETE/id; 404 = exit 64 + body (DEC-168) |
| BC-3.9.009 | attachment upload --output json shape; #526 invariant |
| BC-3.9.010 | attachment delete --output json shape |
| BC-3.9.011 | --public --output json deferred-probe (P2-3c); S5 obligation |
| BC-3.9.012 | Upload error taxonomy |
| BC-3.9.013 | Delete error taxonomy |
| BC-3.9.014 | --public confirmation gate mechanics: eprint!+read_line, NOT dialoguer |

### BC-X.8.010 — serviceDeskId cache (cross-cutting.md)

1 new individually-bodied BC inserted in `### X.8 Projects & Queues` between BC-X.8.009 and `### X.9`.

| BC ID | Title |
|-------|-------|
| BC-X.8.010 | (profile, projectKey) → serviceDeskId cache; model-b writer; 7-day TTL; deserialize failure = cache miss |

---

## Ratified Design Rulings (DEC-179)

All the following were ratified at the F1 gate (DEC-179):

- **Default path**: No visibility flag → platform POST for both JSM and non-JSM issues.
- **P2-4a (CONFIRMED)**: Platform POST to JSM issue is INTERNAL by default (not customer-visible). Refutes the "footgun" hypothesis from Part 1 research.
- **--internal non-JSM = OQ-9 silent no-op**: `--internal` expresses intent already satisfied by platform POST; no error or warning.
- **--public non-JSM = exit 64**: Asymmetric from --internal; public requires servicedeskapi flow — no silent fallback.
- **DEC-174 confirmation gate**: `eprint!` + `io::stdin().lock().read_line()` is the ratified interactive mechanism. `dialoguer::Confirm` is forbidden (returns `Err(NotConnected)` on piped stderr before reading input).
- **DEC-168 precedent on delete**: 404 on a targeted DELETE = exit 64 + surface Jira body (NOT silent exit 0). Same ruling as comment delete (BC-3.5.004).
- **JSDCLOUD-10841**: servicedeskapi `links.content` URLs return 404 for content downloads. Always use platform `/rest/api/3/attachment/content/{id}`.
- **JRACLOUD-97046**: `?redirect=false` breaks some file formats. Must use redirect-following (reqwest default).
- **GHSA-9857-6MW7-FQ2M**: reqwest 0.13.4 strips `Authorization`/`Cookie` on cross-host redirects. Correct behavior for CDN download.
- **CWE-22 filename sanitization**: 5-step `sanitize_attachment_filename` algorithm required for server-supplied filenames in download path.

---

## Deferred Probe Obligations

Two BCs carry explicit delivery obligations gated on S5 live E2E capture:

- **BC-3.9.007 EC-3.9.007-2 + BC-3.9.011** (P2-3c INCONCLUSIVE): The response schema of `POST /rest/servicedeskapi/request/{id}/attachment` on Atlassian Cloud is unpublished and unconfirmed. The S5 implementer MUST:
  1. Issue a live E2E request against the `EJ` test project with `jr attachment upload <JSM-KEY> <file> --public --yes`.
  2. Capture the response body verbatim.
  3. Update BC-3.9.007 EC-3.9.007-2 and BC-3.9.011 with the confirmed schema.
  4. Add a row to the `## JSON Output Shape Contracts` table in bc-3-issue-write.md for `attachment upload --public`.
  5. Mark P2-3c as SATISFIED in `.factory/research/issue-576-attachments-api-2026-07-15.md`.

---

## ADR Reference

- **DEC-179**: F1 gate approval for SOH-ATTACHMENTS-1; all design rulings ratified.
- **ADR-0017** (Accepted, 2026-07-15): Codifies the first multipart/streaming HTTP surface — reqwest `multipart` + `stream` features and `tokio-util` direct dependency. Path: `.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`. Gate: DEC-179 item 7. Note: ADR-0017 lives in the factory-side decisions directory (`.factory/specs/architecture/decisions/`), not the product-repo `docs/adr/` directory (which holds ADR-0001..0016). The convention for counting factory-side ADRs in CANONICAL-COUNTS.md is to be settled by the state-manager at burst close — CANONICAL-COUNTS ADR count is not bumped here pending that ruling.

---

## STATE.md Note (for state-manager)

STATE.md `Convergence Status` currently cites "ARCH-INDEX v0.16". Additionally, `.factory/specs/architecture/ARCH-INDEX.md` now exists (bootstrapped with ADR-0017 reference as a planned entry), alongside `.factory/architecture/adr-index.md`. The state-manager may wish to reconcile the ARCH-INDEX version line at burst close. BC-INDEX is now at v6.13 (from v6.12); STATE.md should be updated accordingly.

---

## Security Review Finding Dispositions (v1.3.44 fix round)

Applied from `.factory/phase-f2-spec-evolution/security-review-576.md` (verdict: SPEC-CHANGES-REQUIRED).

| Finding ID | Severity | BC Updated | Change | Status |
|------------|----------|-----------|--------|--------|
| SEC-576-001 | LOW (CWE-22) | BC-2.7.011 | Added Windows device-name caller note; extended unit test matrix with `CON`, `NUL`, `COM1`, `nul.txt` | APPLIED |
| SEC-576-002 | MEDIUM (CWE-22) | BC-2.7.011 | Replaced containment check with two-step `canonicalize(out_dir)` + `starts_with` procedure | APPLIED |
| SEC-576-003 | LOW (CWE-522) | BC-2.7.007 | Added EC-2.7.007-3: wiremock test asserting `Authorization` absent from redirect-target | APPLIED |
| SEC-576-004 | LOW (CWE-93) | BC-3.9.001 | Added multipart filename encoding note (reqwest percent-encodes) + SQ-6 unit test requirement | APPLIED |
| SEC-576-005 | LOW (CWE-352) | BC-3.9.001, BC-3.9.003 | Added EC-3.9.001-5 + BC-3.9.003 Step-1 parallel note: wiremock tests MUST assert `X-Atlassian-Token: no-check` | APPLIED |
| SEC-576-006 | LOW (correctness) | BC-X.8.010 | Added stale-ID self-healing clause: delete cache + retry once on step-1 404/403 | APPLIED |
| SEC-576-007 | INFO (CWE-22) | BC-2.7.011 | Added step 5.5: trailing whitespace/dot strip for Windows predictability | APPLIED |

Spec version bumped to 1.3.44 by this fix round. BC count unchanged at 651.

---

## Consistency Review Round 1 Finding Dispositions

Applied from `.factory/phase-f2-spec-evolution/consistency-report-576-r1.md` (verdict: GAPS-FOUND).
CONS-576-005 routed to security reviewer.

| Finding ID | Severity | File(s) Touched | Change | Status |
|------------|----------|----------------|--------|--------|
| CONS-576-001 | MEDIUM | BC-INDEX.md | BC-2.7.011 row: correct char scrub, correct length cap, step 5.5, two-step containment, Windows device-name note; Source → attachments.rs | APPLIED |
| CONS-576-002 | LOW | bc-3-issue-write.md | All BC-3.9.x Source citations: interactions.rs/issues.rs/jsm/requests.rs → attachments.rs/jira/attachments.rs/jsm/attachments.rs | APPLIED |
| CONS-576-003 | LOW | cross-cutting.md | BC-X.8.010 Source: jsm/requests.rs::attach_temporary_file → jsm/attachments.rs::attach_temporary_file | APPLIED |
| CONS-576-004 | LOW | BC-INDEX.md | All 11 remaining Section 2.7 rows Source: interactions.rs → attachments.rs | APPLIED |
| CONS-576-005 | LOW | (routed to security reviewer) | security-review-576.md verdict annotation | DEFERRED |
| CONS-576-006 | LOW | impact-boundary-576.md | §R2.2 annotation: --internal non-JSM exit-64 clause superseded by OQ-9 silent no-op | APPLIED |
| CONS-576-007 | INFO | spec-changelog.md | [1.3.43] ADR-0017 reference: "planned" → "Accepted 2026-07-15" with path | APPLIED |

BC count unchanged: 651. Spec version unchanged at 1.3.44. Both guards exit 0.

---

## Consistency Review Round 2 Finding Dispositions

Applied from `.factory/phase-f2-spec-evolution/consistency-report-576-r2.md` (verdict: GAPS-FOUND).

| Finding ID | Severity | File(s) Touched | Change | Status |
|------------|----------|----------------|--------|--------|
| CONS-576-002 residual + NEW-003 sweep | LOW | bc-3-issue-write.md, BC-INDEX.md | TWIN-ARTIFACT-SWEEP: all remaining `interactions.rs` attachment-BC citations replaced — 12 bc-3 body Source fields + 13 BC-INDEX Section 3.9 rows + BC-3.9.006 bonus (requests.rs → jsm/attachments.rs). Zero-residual confirmed. | APPLIED |
| NEW-001 | LOW | bc-3-issue-write.md | BC-3.9.001: "10 MB per file" sentence removed; replaced with "instance-configured limit (INCONCLUSIVE — P2-3c; defer to implementer)" | APPLIED |
| NEW-004 | LOW | CANONICAL-COUNTS.md | BC-X.4.009 counting note: total_bcs 149→150; "624 sum" → "651 sum"; "623" → "650" | APPLIED |
| NEW-005 | LOW | impact-boundary-576.md | §R2.3 BC-3.9.012 row: PHASE-DOC-RETRO-ANNOTATION added — "same JSM-only gate as --public" superseded by OQ-9 for --internal; BC-3.9.004 is correct current spec | APPLIED |

BC count unchanged: 651. Spec version unchanged at 1.3.44. Both guards exit 0.

---

## Worklog Reference

Full CREATE sub-burst details in: `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md`

- Sub-burst 1: BC-2.7.001..012 (bc-2-issue-read.md)
- Sub-burst 2: BC-3.9.001..014 (bc-3-issue-write.md)
- Sub-burst 3: BC-X.8.010 (cross-cutting.md)
- INTEGRATE: BC-INDEX.md, CANONICAL-COUNTS.md, frontmatter totals, spec-changelog, this file
