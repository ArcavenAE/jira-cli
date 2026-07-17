---
document_type: prd-delta
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
spec_version_before: 1.3.42
spec_version_after: 1.3.75
bc_count_before: 624
bc_count_after: 657
holdout_count_before: 88
holdout_count_after: 100
---

# PRD Delta — SOH-ATTACHMENTS-1 Attachment Read/Write (issues #576 + #585)

## Summary

F2 spec evolution for the SOH-ATTACHMENTS-1 feature bundle (issues #576 + #585). Adds 33
new individually-bodied BCs across three BC files, establishing the full aspirational
behavioral specification for `jr issue attachment list`, `jr issue attachment download`, `jr issue attachment
upload`, and `jr issue attachment delete`. Issue #585 (contentUrl surface) is absorbed into
BC-2.7.002. All design decisions ratified by DEC-179.

---

## Scope

| Story | Feature | BC coverage |
|-------|---------|------------|
| S1 | `jr issue attachment list` (list + filter) | BC-2.7.001..006. **VP-576-004 allocation (P24-002)**: VP-576-004's list half is home to S1 (BC-2.7.002); the full cross-path test (list + upload) lands at S3 (R3.13 earliest-consumer principle; S3 depends_on S1 for shared curated-serialization plumbing); NOT part of the S1 acceptance matrix as a whole — the S1 matrix includes only the list half. |
| S2 | `jr issue attachment download` (single/batch/newest) | BC-2.7.007..012 |
| S3 | `jr issue attachment upload` (platform POST + `--replace-existing` + `--dry-run` path-c) | BC-3.9.001..002, BC-3.9.009, BC-3.9.012, BC-3.9.014, BC-3.9.017, BC-3.9.018, BC-3.9.020 (path-c: `--replace-existing --dry-run` + EC-3.9.020-6 clap guard). **BC-3.9.014 gate mechanics ship with S3** (earliest gate consumer, required by BC-3.9.017 step 2's ≥1-match gate; S5 consumes them for the `--public`/combined variants — S5 `depends_on` S3; F3 must encode this edge). [P16-002 ORCHESTRATOR RULING: BC-3.9.014 reallocated S5→S3] **BC-3.9.007 scope note (P17-005)**: BC-3.9.007 EC-3.9.007-1 platform-echo clause is exercised in S3 (BC-3.9.001 + BC-3.9.009 ship with S3; earliest-consumer principle per R3.13). **BC-3.9.017 split note (P20-005, P34-002)**: non-public `--replace-existing` path (EC-3.9.017-1..10) ships with S3; EC-3.9.017-12 (`--yes` universal bypass) non-public arm also ships with S3 (VP-576-003 pins EC-3.9.017-10/12); EC-3.9.017-11 (combined single-prompt) and the step-4 BC-3.9.003 public-routing are S5-realized (S5 depends_on S3 for gate mechanics). **VP-576-004 allocation (P24-002, r34 gap-closure)**: VP-576-004 (curated attachment-object JSON transformation pin) full cross-path test (list BC-2.7.002 + upload BC-3.9.009) lands at S3; S3 depends_on S1 for the shared curated-serialization plumbing (R3.13 earliest-consumer principle; list half home BC-2.7.002 S1; upload half home BC-3.9.009 S3). |
| S4 | `jr issue attachment delete` | BC-3.9.008, BC-3.9.010, BC-3.9.013, BC-3.9.015, BC-3.9.016, BC-3.9.019, BC-3.9.020 |
| S5 | `jr issue attachment upload --public/--internal` (JSM visibility) | BC-3.9.003..007, BC-3.9.011, BC-X.8.010. **BC-3.9.014 gate mechanics consumed here** for `--public` standalone (consumer 1) and combined `--public`+≥1-match (consumer 3) — gate mechanics ship with S3 (above); S5 depends_on S3 for this. **EC-3.9.020-7 path-c `--public` annotation**: the `"visibility":"public"` annotation on `wouldUpload` entries in `--replace-existing --dry-run --public` (path-c) is activated only when `--public` is supplied; its end-to-end behavior is verified in S5 — S3 implements the annotation plumbing keyed on the flag. [P16-002 ORCHESTRATOR RULING] **BC-3.9.007 scope note (P17-005)**: S5 owns JSM echo clauses (EC-3.9.007-2, P2-3c deferred); platform-echo clause (EC-3.9.007-1) ships with S3. **BC-3.9.017 split note (P20-005, P34-002)**: EC-3.9.017-11 (combined single-prompt) and the step-4 BC-3.9.003 `--public` routing are S5-realized; EC-3.9.017-12 (`--yes` universal bypass) combined arm is verified in S5 (VP-576-005) — non-public arm already ships with S3 (VP-576-003; P34-002); S5 depends_on S3 for the underlying `--replace-existing` delete-and-upload mechanics. **VP-576-005 allocation (P23-003)**: VP-576-005 (combined-gate single-prompt pin) is verified in S5 (S5 depends_on S3) — exercises the combined `--public` JSM two-step (EC-3.9.017-11/12); textual home BC-3.9.017; NOT part of the S3 acceptance matrix (contrast VP-576-003, genuinely S3 — non-public `--replace-existing`). **VP-576-004 allocation (P24-002)**: VP-576-004 (curated attachment-object JSON transformation pin) full cross-path test (list BC-2.7.002 + upload BC-3.9.009) lands at S3; S3 depends_on S1 for the shared curated-serialization plumbing (R3.13 earliest-consumer principle; list half home BC-2.7.002 S1; upload half home BC-3.9.009 S3). |

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

20 individually-bodied BCs in `### 3.9 Attachment Write` (14 original + 6 added adversary pass-1 round B).

| BC ID | Title |
|-------|-------|
| BC-3.9.001 | Platform upload POST; X-Atlassian-Token; streaming; no cap; 413/400 |
| BC-3.9.002 | JSM upload, no flag → platform POST (internal by default, P2-4a) |
| BC-3.9.003 | --public → servicedeskapi two-step; DEC-174 confirmation gate; --yes bypass |
| BC-3.9.004 | --internal → two-step public:false; no gate; non-JSM = silent no-op (OQ-9) |
| BC-3.9.005 | --public on non-JSM → exit 64 \| *Holdout: H-NEW-ATTACHMENT-008 (P4-014)* |
| BC-3.9.006 | temporaryAttachmentId ~1h TTL; second-step failure retry hint |
| BC-3.9.007 | Post-upload echo; P2-3c deferred; JSDCLOUD-10841 ban |
| BC-3.9.008 | attachment delete → DELETE/id; 404 = exit 64 + body (DEC-168) |
| BC-3.9.009 | attachment upload --output json shape; #526 invariant |
| BC-3.9.010 | attachment delete --output json shape |
| BC-3.9.011 | --public --output json deferred-probe (P2-3c); S5 obligation |
| BC-3.9.012 | Upload error taxonomy; S3 (--public non-JSM exit 64 row and non-interactive without --yes row activate at S5 — --public path is S5-only) |
| BC-3.9.013 | Delete error taxonomy |
| BC-3.9.014 | --public confirmation gate mechanics: eprint!+read_line, NOT dialoguer |
| BC-3.9.015 | delete single-ID confirmation gate: eprint!+read_line; non-interactive exit 64; --yes bypass; cancel `{"cancelled":true,"deleted":false}` |
| BC-3.9.016 | --older-than always requires --yes (no interactive prompt for bulk); --dry-run exempt; clap mutual-exclusion positional-AID vs --issue/--older-than |
| BC-3.9.017 | --replace-existing: delete-ALL-same-filename (OQ-6) then upload; non-atomic race documented (JRACLOUD-96384/-78388); MUST NOT assert atomicity; S3 (step-2 gate interaction with --public confirmation gate completes at S5) |
| BC-3.9.018 | --replace-existing zero-match: skip delete phase; silent idempotent plain upload |
| BC-3.9.019 | --older-than: --issue KEY required; duration.rs parser; chrono client-side comparison; invalid duration exit 64; bulk JSON `{"count":N,"deleted":true,"ids":[]}` |
| BC-3.9.020 | --dry-run multi-attachment preview: no mutations; JSON `{"attachments":[{filename,id}],"dryRun":true,"ids":[...]}`; single-ID --dry-run = stderr hint + exit 0; S4 (path c — upload --replace-existing --dry-run — ships with S3) |

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

## Scope Note — Human Ruling R1 (ADV-003 from Adversary Pass 1) [DELIVERED: Round B BCs authored 2026-07-15]

Human ruling R1 (recorded 2026-07-15, adversary pass-1 finding ADV-003): the flags `--replace-existing`, `--older-than`, and `--dry-run` for `jr issue attachment delete` are **IN SCOPE** for SOH-ATTACHMENTS-1. These flags are intentionally deferred to fix round B (new BCs); they are NOT silently out of scope. This package is intentionally partial for those three flags; their BCs will be authored in round B before story decomposition.

---

## Deferred Probe Obligations

Two BCs carry explicit delivery obligations gated on S5 live E2E capture:

- **BC-3.9.007 EC-3.9.007-2 + BC-3.9.011** (P2-3c INCONCLUSIVE): The response schema of `POST /rest/servicedeskapi/request/{id}/attachment` on Atlassian Cloud is unpublished and unconfirmed. The S5 implementer MUST:
  1. Issue a live E2E request against the `EJ` test project with `jr issue attachment upload <JSM-KEY> <file> --public --yes`.
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

Spec version bumped to 1.3.44 by this fix round. BC count at this round: 651 (pre-adversary-pass-1 round B; adversary pass-1 round B subsequently added BC-3.9.015..020 → 657).

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
| CONS-576-005 | LOW | (routed to security reviewer) | security-review-576.md verdict annotation | RESOLVED (security-review-576.md verdict: APPROVE, status: final) |
| CONS-576-006 | LOW | impact-boundary-576.md | §R2.2 annotation: --internal non-JSM exit-64 clause superseded by OQ-9 silent no-op | APPLIED |
| CONS-576-007 | INFO | spec-changelog.md | [1.3.43] ADR-0017 reference: "planned" → "Accepted 2026-07-15" with path | APPLIED |

BC count at this round: 651 (pre-adversary-pass-1 round B). Spec version: 1.3.44. Both guards exit 0.

---

## Consistency Review Round 2 Finding Dispositions

Applied from `.factory/phase-f2-spec-evolution/consistency-report-576-r2.md` (verdict: GAPS-FOUND).

| Finding ID | Severity | File(s) Touched | Change | Status |
|------------|----------|----------------|--------|--------|
| CONS-576-002 residual + NEW-003 sweep | LOW | bc-3-issue-write.md, BC-INDEX.md | TWIN-ARTIFACT-SWEEP: all remaining `interactions.rs` attachment-BC citations replaced — 12 bc-3 body Source fields + 13 BC-INDEX Section 3.9 rows + BC-3.9.006 bonus (requests.rs → jsm/attachments.rs). Zero-residual confirmed. | APPLIED |
| NEW-001 | LOW | bc-3-issue-write.md | BC-3.9.001: "10 MB per file" sentence removed; replaced with "instance-configured limit (INCONCLUSIVE — P2-3c; defer to implementer)" | APPLIED |
| NEW-004 | LOW | CANONICAL-COUNTS.md | BC-X.4.009 counting note: total_bcs 149→150; "624 sum" → "651 sum"; "623" → "650" | APPLIED |
| NEW-005 | LOW | impact-boundary-576.md | §R2.3 BC-3.9.012 row: PHASE-DOC-RETRO-ANNOTATION added — "same JSM-only gate as --public" superseded by OQ-9 for --internal; BC-3.9.004 is correct current spec | APPLIED |

BC count at this round: 651 (pre-adversary-pass-1 round B). Spec version: 1.3.44. Both guards exit 0.

---

## Worklog Reference

Full CREATE sub-burst details in: `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md`

- Sub-burst 1: BC-2.7.001..012 (bc-2-issue-read.md)
- Sub-burst 2: BC-3.9.001..014 (bc-3-issue-write.md)
- Sub-burst 3: BC-X.8.010 (cross-cutting.md)
- INTEGRATE: BC-INDEX.md, CANONICAL-COUNTS.md, frontmatter totals, spec-changelog, this file

---

## Consistency Review Round 3 Finding Dispositions

| Finding ID | Severity | File(s) Touched | Change | Status |
|------------|----------|----------------|--------|--------|
| NEW-R3-002 | LOW | bc-3-issue-write.md | BC-3.9.007 JSDCLOUD-10841 paragraph: `(BC-2.7.005)` → `(BC-2.7.007)` (wrong cross-ref); zero-residual sweep confirmed | APPLIED |
| NEW-R3-001 | LOW | prd-delta-576.md | Frontmatter `spec_version_after: 1.3.43` → `1.3.44` | APPLIED |

BC count at this round: 651 (pre-adversary-pass-1 round B). Both guards exit 0.

---

## Consistency Review Round 4 Finding Dispositions

| Finding ID | Severity | File(s) Touched | Change | Status |
|------------|----------|----------------|--------|--------|
| NEW-R4-001 | LOW | bc-2-issue-read.md | Footer BC count/style: "52 (representative set; BC-INDEX.md carries all 94)" → "64 individually-bodied (cumulative 106 incl. range-collapsed; see BC-INDEX.md)" | APPLIED |
| NEW-R4-003 | LOW | bc-3-issue-write.md | Footer Last-updated narrative: prepended 2026-07-15 SOH-ATTACHMENTS-1 F2 entry; relabelled prior entry as "Previous update 2026-07-09". Count line (105/134) left unchanged — already updated by CREATE burst | APPLIED |
| NEW-R4-002 | INFO | CANONICAL-COUNTS.md | ADR count update (27→28) — RESOLVED: 27→28 was a miscount encoding error; actual count 17 incl. ADR-0017; CANONICAL-COUNTS verified correct; resolved at pass-22 burst by state-manager (P34-003) | RESOLVED |

BC count at this round: 651 (pre-adversary-pass-1 round B). Both guards exit 0.

---

## Adversary Pass 1 Fix Round A Finding Dispositions

Source: adversary pass-1 findings. Human rulings: R1 (--replace-existing/--older-than/--dry-run IN scope, round B), R2 (delete y/N + --yes gate, round B), R3 (holdout scenarios, round B). Fix round A = corrections to existing BC text only; no new BCs; no count changes.

| Finding | Severity | File(s) Touched | Status | What changed |
|---------|----------|----------------|--------|-------------|
| ADV-001 (HIGH) | HIGH | bc-3-issue-write.md, cross-cutting.md, prd-delta-576.md | APPLIED | SWEEP: all `jr attachment` → `jr issue attachment`; 9 hits in bc-3, 1 in cross-cutting, 9 in prd-delta (incl. 1 line-split residual); zero-residual confirmed |
| ADV-002 (HIGH) | HIGH | bc-3-issue-write.md | APPLIED | BC-3.9.008 body rewritten: ID-only delete (no KEY positional), OQ-7 ruling noted, success echo updated to `"Deleted attachment <AID>."`, KEY-ownership paragraph removed; BC-3.9.010/013 Traces updated with OQ-7 reference |
| ADV-005 (MED) | MED | bc-3-issue-write.md | APPLIED | BC-3.9.012 `--public` non-JSM error: `"--public is only supported on JSM issues."` → `"--public is only supported on Jira Service Management (JSM) issues."` |
| ADV-006 (MED) | MED | bc-2-issue-read.md | APPLIED | BC-2.7.007: write-to-temp+atomic-rename clause; cleanup-on-error; EC-2.7.007-4 (error mid-stream → temp deleted, exit 1); EC-2.7.007-5 (Ctrl+C/SIGINT → temp deleted, exit 130) |
| ADV-007 (MED) | MED | bc-2-issue-read.md | APPLIED | BC-2.7.012: ENOSPC, EACCES/read-only, other-OS-write-error rows added to error taxonomy table [P13-001 correction: originally misapplied to BC-2.7.006; relocated to BC-2.7.012 at P13-001] |
| ADV-008 (MED) | MED | bc-3-issue-write.md | APPLIED | BC-3.9.001: retry-interaction clause — streaming non-cloneable; rebuild from file path per attempt; fresh ReaderStream; mid-stream 429 impossible; JiraClient retry loop not applicable; cite ADR-0017 |
| ADV-009 (MED) | MED | bc-2-issue-read.md | APPLIED | BC-2.7.011 step 5: 255-byte cap → UTF-8-safe 214-byte cap (floor_char_boundary semantics); multi-byte truncation boundary test case added |
| ADV-010 (MED) | MED | bc-2-issue-read.md | APPLIED | BC-2.7.011 step 5: cap 214 bytes (41-byte SHA-1 prefix); BC-2.7.010: combined-name length cap note (214 + 41 = 255 ≤ NAME_MAX) |
| ADV-011 (MED) | MED | bc-3-issue-write.md | APPLIED | BC-3.9.001: allow_hyphen_values rationale; `--` separator note; EC-3.9.001-6 (stdin/`-` as FILE → exit 64) |
| ADV-012 (MED) | MED | bc-2-issue-read.md | APPLIED | BC-2.7.007: selector-required (clap required-group) clause; bare `jr issue attachment download <KEY>` with no selector → clap exit 2 |
| ADV-014 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.003/004/005: filter composition with --all and --newest noted in each BC body |
| ADV-015 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.007: EC-2.7.007-6 (--out missing parent dir → exit 64); BC-2.7.008: EC-2.7.008-4 (out-dir exists but not-a-directory → exit 64), EC-2.7.008-5 (clarification) |
| ADV-016 (LOW) | LOW | bc-3-issue-write.md | APPLIED | BC-3.9.012 issue-404 string: `"Issue <KEY> not found."` → `"Issue <KEY> not found or not accessible."` |
| ADV-017 (LOW) | LOW | bc-3-issue-write.md | APPLIED | JSON Output Shape Contracts table: upload array row + delete single/bulk rows added; `--public` row stays deferred |
| ADV-018 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.002: contentUrl rename clause; thumbnail omitted note added to BC-2.7.001 and BC-2.7.002 |
| ADV-019 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.001: EC-2.7.001-3 (null/missing author → "(anonymous)" in table); BC-2.7.002: null author → `"author": null` JSON note |
| ADV-020 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.001: CLI flags enumeration clause (list surface); BC-2.7.007: CLI flags enumeration clause (download surface) |
| ADV-021 (LOW) | LOW | bc-3-issue-write.md | APPLIED | BC-3.9.010: bulk-delete partial-failure non-atomicity stated; exit code follows HTTP error; per-AID error lines in human mode; no partial-success JSON shape |
| ADV-022 (INFO) | INFO | bc-2-issue-read.md, bc-3-issue-write.md | APPLIED | BC-2.7.011: containment-check coverage/mutation exemption note (intentionally unreachable); BC-3.9.011: EJ-teardown obligation (must delete uploaded attachment; jsm_self_close alone insufficient) |
| ADV-003 residue | INFO | prd-delta-576.md | APPLIED | Scope Note section added before Deferred Probe Obligations: R1 ruling — --replace-existing/--older-than/--dry-run IN scope for round B; NOT silently out of scope |

**BC count at this round: 651 (adversary pass-1 round B subsequently added BC-3.9.015..020 → 657). Spec version: 1.3.44 at this round. Both guards exit 0.**

**Zero-residual proof for ADV-001:** `grep -rn "\bjr attachment\b" .factory/specs/prd/ .factory/phase-f2-spec-evolution/prd-delta-576.md | grep -v "jr issue attachment"` → (no output)

---

## Adversary Pass 14 Fix Round Finding Dispositions

Source: Adversary Pass 14 (Consistency Review). 1 HIGH / 2 MEDIUM / 6 LOW / 2 INFO findings. Spec version bump: 1.3.53 → 1.3.54. No new BCs. Holdouts: 96 → 97 (+1 H-NEW-ATTACHMENT-009). VPs: 30 → 33 (+3 VP-576-001..003).

| Finding | Severity | File(s) Touched | Status | What changed |
|---------|----------|----------------|--------|-------------|
| P14-001 (HIGH) | HIGH | bc-3-issue-write.md, holdout-scenarios.md, impact-boundary-576.md | APPLIED | BC-3.9.003 interactive-mode bullet rewritten as explicit three-way branch (a) y/yes → proceed; (b) other/empty → cancel exit 0 stderr; (c) EOF Ok(0)/Err → JrError::Interrupted exit 130. EC-3.9.003-4 updated (branch b, stderr). EC-3.9.003-6 added (EOF → exit 130). BC-3.9.003 Trace updated. H-NEW-ATTACHMENT-009 added (holdout 97). R3.11 in impact-boundary-576.md retro-annotated (false claim that BC-3.9.003 did not state EOF=cancel corrected). |
| P14-002 (MEDIUM) | MEDIUM | bc-3-issue-write.md | APPLIED | EC-3.9.003-7 added: non-JSM eligibility guard (BC-3.9.005) fires BEFORE non-interactive gate — `--public --yes` on a non-JSM issue must exit 64 not proceed. Guard evaluation order pinned. |
| P14-003 (MEDIUM) | MEDIUM | bc-3-issue-write.md | APPLIED | BC-3.9.003 cancel path: "Upload cancelled." changed from stdout to stderr. EC-3.9.014-2 updated (non-EOF branch (b), stderr). BC-3.9.015 cancel-channel divergence note added (attach delete deliberately emits "Deletion cancelled." to stderr, unlike comment-family table-mode which emits nothing per interactions.rs `OutputFormat::Table => {}`). |
| P14-004 (LOW) | LOW | impact-boundary-576.md | APPLIED | §2.2 BC-3.9.008 row retro-annotated: "404 → exit 0" superseded by DEC-168 (shipped BC-3.9.008 = exit 64 + surface body). §2.3 NFR idempotency row retro-annotated similarly. |
| P14-005 (LOW) | LOW | bc-3-issue-write.md | APPLIED | BC-3.9.012 error table row "Issue key not found": trigger column changed from "404 on issue meta fetch" to "404 from the upload POST (platform path) or from the issue GET (--public / --replace-existing paths)". |
| P14-006 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.001 output-channel profile line: "no stderr output when no filter is active" → "no filter-count hint on stderr when no filter is active" (removes contradiction with EC-2.7.001-1 which emits to stderr for zero attachments). Pre-existing TD-031 violations (46 bare `:NNN` line cites) converted to `:~NNN` approximate form to unblock the hook. |
| P14-007 (LOW) | LOW | bc-2-issue-read.md, bc-3-issue-write.md, spec-changelog.md, BC-INDEX.md | APPLIED | VP-576-001 added in BC-2.7.011 (sanitize_attachment_filename property test). VP-576-002 added in BC-3.9.015 (delete confirmation gate wiremock confirm+cancel variants). VP-576-003 added in BC-3.9.017 (--replace-existing ordering invariant: DELETE before POST). VP count 30→33 updated in bc-3-issue-write.md preamble + footer and spec-changelog.md Impact table. |
| P14-008 (LOW) | LOW | impact-boundary-576.md | APPLIED | §3.1 `docs/specs/attachments.md` row retro-annotated: this is an F4 delivery obligation (by story close), not a prerequisite for F2 spec authoring. |
| P14-009 (LOW) | LOW | bc-3-issue-write.md | APPLIED | BC-3.9.020 path (c) (`--replace-existing --dry-run --public`): `--public` confirmation gate explicitly SUPPRESSED on dry-run (no destructive call issued → BC-3.9.017 invariant: gate does not fire). Preview JSON includes `"visibility":"public"` in wouldUpload entries. EC-3.9.020-7 added. |
| P14-010 (INFO) | INFO | bc-3-issue-write.md | APPLIED | BC-3.9.020 heading retitled from "attachment delete --dry-run" to "`attachment --dry-run` (delete multi-path + upload `--replace-existing`)" to reflect that the BC covers both delete and upload path-c dry-run. Source field updated to add `handle_attachment_upload` for path c. |
| P14-011 (INFO) | INFO | bc-3-issue-write.md | APPLIED | Double `---` separator before BC-3.9.015 removed (only one is needed between BCs). |

**BC count at this round: 657 (unchanged). Holdout count: 97 (+1). VP count: 33 (+3). Spec version: 1.3.54. Both guards exit 0.**

---

## Adversary Pass 15 Fix Round Finding Dispositions

Source: Adversary Pass 15 (Consistency Review). 2 MEDIUM / 5 LOW / 2 INFO findings. Spec version bump: 1.3.54 → 1.3.55. No new BCs. Holdouts: 97 → 98 (+1 H-NEW-ATTACHMENT-010). VPs: 33 (unchanged).

| Finding | Severity | File(s) Touched | Status | What changed |
|---------|----------|----------------|--------|-------------|
| P15-001 (MEDIUM) | MEDIUM | BC-INDEX.md | APPLIED | BC-2.7.011 row: "255-byte cap" → "214-byte cap" (alignment with BC-2.7.011 body and VP which consistently state the 214-byte platform limit). Sweep found no other 255-byte-cap references in .factory/. |
| P15-002 (MEDIUM) | MEDIUM | bc-3-issue-write.md, holdout-scenarios.md, impact-boundary-576.md | APPLIED | BC-3.9.017 step 2 rewritten: `--replace-existing` ≥1 same-filename match → confirmation gate required (R3.12). EC-3.9.017-9..12 added (non-interactive exit 64; zero-match gate no-op; combined `--public`+match single-prompt; `--yes` single-bypass). BC-3.9.014 expanded to THREE consumers with additional prompt variant text. EC-3.9.003-5 extended to cover three entry points. EC-3.9.020-7 extended to cover ALL gate consumers on dry-run. BC-3.9.018 zero-match P15-002 alignment note. VP-576-003 `--yes` rationale updated. H-NEW-ATTACHMENT-004 Call B updated to `--replace-existing --yes`. H-NEW-ATTACHMENT-010 added (holdout 98). R3.12 added to impact-boundary-576.md. |
| P15-003 (LOW) | LOW | BC-INDEX.md | APPLIED | BC-3.9.005 row: en-dash "–-public" → ASCII "--public". |
| P15-004 (LOW) | LOW | bc-2-issue-read.md, BC-INDEX.md | APPLIED | BC-2.7.007 `--filter` flag note updated to encode `conflicts_with = "id"` — clap exits 2 when `--filter` and `--id` are combined. EC-2.7.007-10 added. |
| P15-005 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.006 error table: 403 row added (`Permission denied: cannot access issue <KEY>.`, exit 1). |
| P15-006 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.007: EC-2.7.007-11 added (`--out <PATH>` naming an existing directory → exit 64 `"output path is a directory: <PATH>"`). |
| P15-007 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.008: EC-2.7.008-10 added (batch download filtered-to-zero on non-empty issue: `"No attachments matched the filter on <KEY>."` + exit 0; JSON `{"downloaded":[]}`). BC-2.7.009: EC-2.7.009-3 added (same behavior for `--newest` path). |
| P15-INFO-1 (INFO) | INFO | holdout-scenarios.md | APPLIED | H-NEW-ATTACHMENT-001 Call A/B setup and H-NEW-ATTACHMENT-003 setup: `GET /rest/api/3/issue/FOO-N` → `GET /rest/api/3/issue/FOO-N?fields=attachment` (canonical query-param form alignment). |
| P15-INFO-2 (INFO) | INFO | — | NO ACTION | Dry-run metadata asymmetry is documented and deliberate (`wouldDelete` lists existing; `wouldUpload` lists intended; no round-trip guarantee). No spec change required. |

**BC count at this round: 657 (unchanged). Holdout count: 98 (+1). VP count: 33 (unchanged). Spec version: 1.3.55. Both guards exit 0.**

---

## Adversary Pass 16 Fix Round Finding Dispositions

Source: Adversary Pass 16 (Consistency Review). 2 MEDIUM / 3 LOW / 1 INFO findings. Spec version bump: 1.3.55 → 1.3.56. No new BCs. Holdouts: 98 (unchanged). VPs: 33 (unchanged).

| Finding | Severity | File(s) Touched | Status | What changed |
|---------|----------|----------------|--------|-------------|
| P16-001 ([process-gap]) | MEDIUM | error-taxonomy.md, impact-boundary-576.md | APPLIED | error-taxonomy.md: 4 new override rows added after existing `404 — comment delete/edit/view` row: (1) `404 — attachment list` (read-path canonical only; BC-2.7.006); (2) `404 — attachment download` (canonical only; BC-2.7.012/EC-2.7.007-1); (3) `404 — attachment delete` split two-sub-case row (DELETE 404 canonical+body per DEC-168 BC-3.9.008/013; pre-prompt metadata-GET 404 canonical only BC-3.9.015; multi/bulk 404 benign-skip exception BC-3.9.013); (4) first 413 row in product (`attachment upload` — `"Attachment too large…"` + exit 1; BC-3.9.001/BC-3.9.012). `last_updated` updated to 2026-07-16. impact-boundary-576.md: R3.14 added documenting that error-taxonomy.md and edge-case-catalog.md were omitted from F1 §3.2 perimeter scan (process-gap retro-annotation; inline-EC convention accepted for edge-case-catalog.md; prevention note). |
| P16-002 (ORCHESTRATOR RULING) | MEDIUM | prd-delta-576.md (Scope table), impact-boundary-576.md | APPLIED | prd-delta-576.md Scope table: BC-3.9.014 reallocated S5→S3 (gate mechanics ship with S3, the earliest consumer via BC-3.9.017 step 2's ≥1-match gate; S5 consumes them for `--public`/combined variants; F3 must encode S5 depends_on S3). S3 row updated with BC-3.9.014 and note. S5 row updated with note referencing gate mechanics from S3. impact-boundary-576.md: R3.13 added (ORCHESTRATOR RULING — BC-3.9.014 S3/S5 allocation; rationale: S3 is earliest gate consumer; EC-3.9.020-7 path-c note; spec impact summary). |
| P16-003 (LOW) | LOW | bc-3-issue-write.md, holdout-scenarios.md | APPLIED | bc-3-issue-write.md BC-3.9.003: Step 0 added (issue existence validation: `GET /rest/api/3/issue/{key}`; 404→exit 64 EC-3.9.012-2; `fields.project.key` passed to `get_or_fetch_project_meta`). projectTypeKey source pinned to `get_or_fetch_project_meta` (NOT issue GET's embedded `fields.project.projectTypeKey`). Key-derivation asymmetry vs BC-3.9.017 step 0 documented (BC-3.9.017 derives project key from key-string prefix because no issue GET has run yet; BC-3.9.003 uses issue GET first then `fields.project.key`; paths are guaranteed-equivalent; "deliberately equivalent" note extended). BC-3.9.003 Trace updated. holdout-scenarios.md: H-NEW-ATTACHMENT-008 step 2 fixture wording updated (projectTypeKey from `GET /rest/api/3/project/SOFTWARE` via `get_or_fetch_project_meta`, NOT from issue GET). H-NEW-ATTACHMENT-009 step 2 fixture wording updated similarly (`GET /rest/api/3/project/EJ`). |
| P16-004 (LOW) | LOW | holdout-scenarios.md | APPLIED | H-NEW-ATTACHMENT-007 step-2 mount: `GET /rest/api/3/issue/FOO-5` → `GET /rest/api/3/issue/FOO-5?fields=attachment` (canonical query-param form; aligns with P15-INFO-1 convention). |
| P16-005 (LOW) | LOW | bc-3-issue-write.md | APPLIED | BC-3.9.015 Metadata-fetch failure clause extended from 404-only to full taxonomy: 403 → exit 1 (`"Permission denied: cannot access attachment <AID>."` aligned with BC-2.7.012); 401 → exit 2 (`JrError::NotAuthenticated`; standard auth taxonomy; `jr auth login` hint); 5xx/network → exit 1 (standard API/transport taxonomy §1). All fire BEFORE the confirmation prompt; gate never presented on metadata-fetch failure. BC-3.9.015 Trace updated. |
| P16-INFO | INFO | impact-boundary-576.md | APPLIED | edge-case-catalog.md inline-EC convention accepted as deliberate (no content action required). Disposition documented alongside error-taxonomy.md omission in R3.14 perimeter-scan retro-annotation. |

**BC count at this round: 657 (unchanged). Holdout count: 98 (unchanged). VP count: 33 (unchanged). Spec version: 1.3.56. Both guards exit 0.**

---

## Adversary Pass 17 Fix Round Finding Dispositions

Source: Adversary Pass 17 (Consistency Review). 1 MEDIUM / 4 LOW / 2 INFO findings. Spec version bump: 1.3.56 → 1.3.57. No new BCs. Holdouts: 98 (unchanged). VPs: 33 (unchanged).

| Finding | Severity | File(s) Touched | Status | What changed |
|---------|----------|----------------|--------|-------------|
| P17-001 (MEDIUM) | MEDIUM | bc-3-issue-write.md | APPLIED | BC-3.9.014 Source field corrected: `::handle_attachment_upload (implementation pending — story S5)` → `src/cli/issue/attachments.rs (implementation pending — story S3, gate mechanics; consumed by S5 --public/combined per R3.13)`. Aligns with R3.13 reallocation and BC-INDEX.md row already updated in P16. |
| P17-002 (LOW) | LOW | impact-boundary-576.md | APPLIED | §1.1 table: `upload_attachment(client, key, paths)` → `upload_attachments(client, key, paths)` (plural; name aligned to BC body). R2.1 table: `attach_to_request(client, issue_key, temp_ids, public)` → `post_request_attachment(client, issue_key, temp_ids, public)` (name aligned to BC body). R3.7 full function list: `upload_attachment` → `upload_attachments`; SQ-3 prose: `upload_attachment` → `upload_attachments`. All four sites (§1.1 table, SQ-3 prose, R2.1 table, R3.7 list) annotated "(name aligned to BC body, P17-002)". |
| P17-003 (LOW) | LOW | bc-3-issue-write.md | APPLIED | EC-3.9.003-5 extended with Step-0 suppression clause: when BC-3.9.003 is entered from BC-3.9.017 step 4, Step 0 (issue GET) is SKIPPED — existence validated by BC-3.9.017 step 1's `?fields=attachment` GET; project meta resolved at BC-3.9.017 step 0; exactly ONE issue GET per invocation on the combined path. Holdouts H-NEW-ATTACHMENT-004/008/009 verified coherent (none exercise the `--replace-existing --public` combined path; no fixture alignment needed). |
| P17-004 (LOW) | LOW | bc-3-issue-write.md | APPLIED | EC-3.9.017-9 extended with two sub-variants (A) `--replace-existing` only: existing message; (B) combined `--public` + ≥1 match: `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."` BC-3.9.014 Non-interactive path section extended with three message variants enumerated explicitly (symmetric with three interactive prompt variants): (1) `--public` only; (2) `--replace-existing` ≥1 match no `--public`; (3) combined. |
| P17-005 (LOW) | LOW | bc-3-issue-write.md, prd-delta-576.md | APPLIED | BC-3.9.007 EC-3.9.007-1 extended with allocation note: exercised in S3 (BC-3.9.001 + BC-3.9.009; R3.13 earliest-consumer principle); S5 owns JSM echo clauses (EC-3.9.007-2). prd-delta-576.md Scope table: S3 row note added (BC-3.9.007 EC-3.9.007-1 platform-echo ships with S3). S5 row note added (S5 owns EC-3.9.007-2 JSM echo clauses). |
| P17-006 (INFO) | INFO | bc-3-issue-write.md | APPLIED | Upload cancel row added to JSON Output Shape Contracts table: `attachment upload (cancel)` → `{"cancelled":true,"uploaded":false}` (2 keys alphabetical; BC-3.9.003/BC-3.9.014/BC-3.9.017). Placed between `--replace-existing --dry-run` row and `--public` row. |
| P17-007 (INFO) | INFO | bc-2-issue-read.md | APPLIED | EC-2.7.009-1 annotated: appended `(arg-level \`Arg::allow_negative_numbers\`, clap 4 — verified against docs.rs 4.6.1, P17-007)`. Confirms the arg-level method is available in clap 4.6.1 (the version pinned in Cargo.lock). |

**BC count at this round: 657 (unchanged). Holdout count: 98 (unchanged). VP count: 33 (unchanged). Spec version: 1.3.57. Both guards exit 0.**

---

## Adversary Pass 18 Fix Round Finding Dispositions

Source: Adversary Pass 18 (Consistency Review). 1 HIGH / 1 MEDIUM / 3 LOW / 2 INFO findings. Spec version bump: 1.3.57 → 1.3.58. No new BCs. Holdouts: 98 (unchanged). VPs: 33 (unchanged).

| Finding | Severity | File(s) Touched | Status | What changed |
|---------|----------|----------------|--------|-------------|
| P18-001 (HIGH) | HIGH | bc-3-issue-write.md | APPLIED | JSON Output Shape Contracts table: attachment upload cancel row label corrected — removed "or non-interactive without `--yes`" clause (non-interactive path exits 64 per EC-3.9.014-3, not the exit-0 cancel shape); label now "(cancel — interactive 'n' or empty)" matching interactive-only scope. |
| P18-002 (MEDIUM) | MEDIUM | error-taxonomy.md, impact-boundary-576.md | APPLIED | Three 403 canonical-string override rows added to error-taxonomy.md §3 (after comment-family 403 row): `403 — attachment list` (BC-2.7.006; exit 1; canonical issue string; Jira body NOT surfaced); `403 — attachment download` (BC-2.7.012/EC-2.7.007-1b; exit 1; canonical issue or attachment string); `403 — attachment delete pre-prompt metadata-GET` (BC-3.9.015; exit 1; canonical attachment string). R3.14 note in impact-boundary-576.md retro-annotated: P16-001 "all 403/404 divergences" claim was false — three 403 rows were absent until P18-002. |
| P18-003 (LOW) | LOW | bc-2-issue-read.md | APPLIED | EC-2.7.003-2: "clap-or-application pre-flight check" → "application pre-flight check". Rationale: this validation exits 64; a clap value_parser rejection exits 2 — "clap-or-" was inaccurate and contradicted the mandated exit code. |
| P18-004 (LOW) | LOW | bc-2-issue-read.md | APPLIED | BC-2.7.010: path-non-determinism ruling paragraph added — `path` value is as-constructed by `jr` (verbatim `--out`, or out-dir + filename), NOT canonicalized, NOT made absolute; snapshot tests must redact/normalize; exact-match only with controlled cwd. EC-2.7.007-7 and EC-2.7.008-6 `path` descriptions updated with P18-004 cross-reference. |
| P18-005 (LOW) | LOW | holdout-scenarios.md, CANONICAL-COUNTS.md | APPLIED | Group numbering taxonomy note added near top of holdout-scenarios.md: groups 16–18 unused/reserved; do NOT renumber. Second "## Group 8: CI Citation Guard" header retitled "## Group 8b: CI Citation Guard" to resolve duplicate heading. CANONICAL-COUNTS.md Group 8 entry updated to Group 8b. HOLDOUT-GROUP-8-DUPLICATE-HEADING drift item closed. |
| P18-I1 (INFO) | INFO | bc-3-issue-write.md | APPLIED | JSON Output Shape Contracts table header: added parenthetical "(attachment rows pending S1–S5 delivery — spec-only today)". |
| P18-I2 (INFO) | INFO | ADR-0017-first-multipart-streaming-http-surface.md | APPLIED | §Decision item 3: feature note added — `io-util` transitively enables `io`; `io` alone is the minimal feature flag for `ReaderStream`; implementer may use either. |

**BC count at this round: 657 (unchanged). Holdout count: 98 (unchanged). VP count: 33 (unchanged). Spec version: 1.3.58.**

---

## Adversary Pass 19 Fix Round Finding Dispositions

Source: Adversary Pass 19 (Consistency Review r29). 1 MEDIUM / 3 LOW / 2 INFO findings. Spec version bump: 1.3.58 → 1.3.59. No new BCs. Holdouts: 98 (unchanged). VPs: 33 (unchanged).

| Finding | Severity | File(s) Touched | Status | What changed |
|---------|----------|----------------|--------|-------------|
| P19-001 (MEDIUM) | MEDIUM | bc-2-issue-read.md, bc-3-issue-write.md, BC-INDEX.md, impact-boundary-576.md | APPLIED | BC-2.7.002 title, JSON example, and curated-fields cross-ref updated to BTreeMap-alphabetical key order: `{author, contentUrl, created, filename, id, mimeType, size}`; authoritative ordering clause added (cites `preserve_order` NOT enabled in this crate; bare struct declaration order does NOT guarantee alphabetical JSON emission). BC-3.9.009 body key sequence updated to alphabetical with P19-001 citation. BC-INDEX.md rows for BC-2.7.002 and BC-3.9.009 updated. impact-boundary-576.md BC-2.7.002 table row (§2.1) updated (TWIN-ARTIFACT-SWEEP). |
| P19-002 (LOW) | LOW | bc-2-issue-read.md | APPLIED | EC-2.7.001-2 extended with JSON-mode clause: filter-count hint fires unconditionally in all output modes (empirical: `src/cli/issue/list.rs::handle_list` ~line 580 `eprintln!` fires after `output::print_output` with no `output_format` guard; corroborated by `src/cli/board.rs::handle_view` ~line 283). Deliberate-asymmetry note added: EC-2.7.001-1 zero-attachment hint IS suppressed in JSON mode (empty `[]` is self-describing); EC-2.7.001-2 filter-count hint is NOT suppressed (filtered JSON array gives no indication of total count). |
| P19-003 (LOW) | LOW | bc-2-issue-read.md | APPLIED | EC-2.7.007-5 downgraded from bare MUST to best-effort MUST. Implementation-strategy note added: cleanup runs in the `tokio::signal::ctrl_c()` select! arm at `src/main.rs:~393` (calls `std::process::exit(130)`); does NOT run via Drop guards — release profile uses `panic = abort` and `std::process::exit()` does not invoke destructors. Not holdout/VP-pinned: SIGINT timing is non-deterministic in CI; EC-2.7.007-4 and H-NEW-ATTACHMENT-002 are the tested proxies for temp-file correctness. |
| P19-004 (LOW) | LOW | bc-3-issue-write.md | APPLIED | BC-3.9.001 CLI flags line: `--dry-run` annotated with `(requires --replace-existing — EC-3.9.020-6, clap requires, exit 2)`. BC-3.9.001 Trace field updated with P19-004 annotation. |
| P19-I1 (INFO) | INFO | bc-3-issue-write.md | APPLIED | BC-3.9.001 human-table spec: explicit note added that the 4-column upload echo table (Filename / Size / ID / Created) deliberately differs from the 6-column list table (BC-2.7.001: ID / Filename / Type / Size / Created / Author) — upload echo is a minimal confirmation of what was just sent; list is the full read metadata surface. |
| P19-I2 (INFO) | INFO | — | NO ACTION (recorded) | Pre-existing duplicate BC number 043: BC-2.4.043 = list_comments anti-stall guard (§2.4 Comments); BC-2.5.043 = changelog `--field` filter (§2.5 Changelog). Numbering collision from Bundle-C parallel surface expansion; distinct bodies, no semantic overlap. Spec-maintenance drift item; renumbering is out-of-scope for a fix round. Ledgered for orchestrator. |
| GAP-P19-FWD-001 (MEDIUM, CV r29 gap) | MEDIUM | prd-delta-576.md (this file), spec-changelog.md, impact-boundary-576.md | APPLIED | prd-delta-576.md: `spec_version_after` 1.3.58→1.3.59; P19 dispositions section appended. spec-changelog.md [1.3.59]: prd-delta-576.md + impact-boundary-576.md added to Changed Requirements; BC/holdout/VP count rows added to Impact Assessment. impact-boundary-576.md BC-3.9.004 row: INFO-15 illustrative/INCONCLUSIVE annotation. |

**BC count at this round: 657 (unchanged). Holdout count: 98 (unchanged). VP count: 33 (unchanged). Spec version: 1.3.59. Both guards exit 0.**

---

## Adversary Pass 20 Fix Round Finding Dispositions

Source: Adversary Pass 20. 1 MEDIUM / 5 LOW / 1 INFO findings. Spec version bump: 1.3.59 → 1.3.60. No new BCs. Holdouts: 98→99 (+1 H-NEW-ATTACHMENT-011). VPs: 33→35 (+2: VP-576-004, VP-576-005).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P20-001 (MEDIUM) | MEDIUM | bc-3-issue-write.md, holdout-scenarios.md, CANONICAL-COUNTS.md, BC-INDEX.md | APPLIED | BC-3.9.004 restructured: Step 0 added (inherits BC-3.9.003 Step 0: issue GET existence validation + BC-3.9.005 `get_or_fetch_project_meta` detection mechanism); full HTTP sequence enumerated for (a) JSM branch and (b) non-JSM OQ-9 silent no-op branch; Trace updated. H-NEW-ATTACHMENT-011 holdout added (BC-3.9.004 EC-3.9.004-1: `--internal` non-JSM → silent platform POST, exit 0, zero servicedeskapi calls; offline-testable; mirrors H-NEW-ATTACHMENT-008 assertion style). Holdout count 98→99. |
| P20-002 (LOW) | LOW | bc-3-issue-write.md | APPLIED | BC-3.9.014 N≤3 prompt template: `, ...` removed; `<filenameN>` placeholder used — ≤3 variant lists ALL filenames comma-separated, no trailing ellipsis. |
| P20-003 (LOW) | LOW | bc-2-issue-read.md, BC-INDEX.md | APPLIED | BC-2.7.007 Wire path section: explicit clause added — `--out <PATH>` does NOT skip step 1; `GET /rest/api/3/attachment/{id}` (step 1, metadata fetch) is issued unconditionally; rationale: uniform wire story + pre-stream existence validation before any bytes written; accepted cost: one extra GET. BC-INDEX.md BC-2.7.007 row updated. |
| P20-004 (LOW) | LOW | impact-boundary-576.md | APPLIED | §1.1 download row retro-annotated per PHASE-DOC-RETRO-ANNOTATION pattern: "(superseded: delivered spec adds --output json manifest to stdout, EC-2.7.007-7; human mode remains no-stdout-data)". |
| P20-005 (LOW) | LOW | prd-delta-576.md (this file) | APPLIED | Scope table S3 row: BC-3.9.017 split note added (non-public `--replace-existing` path ships with S3; combined `--public` ECs EC-3.9.017-11/12 and step-4 BC-3.9.003 routing are S5-realized; S5 depends_on S3). Scope table S5 row: BC-3.9.017 split note added (combined `--public` ECs EC-3.9.017-11/12 are S5-realized; S5 depends_on S3 for underlying mechanics). |
| P20-006 (LOW) | LOW | bc-2-issue-read.md, bc-3-issue-write.md, BC-INDEX.md | APPLIED | VP-576-004 added to BC-2.7.002 (curated attachment-object JSON transformation pin: `"self"` OMITTED and `"content"` RENAMED to `"contentUrl"` in every jr serialization — list + upload; anchor BC-2.7.002, cross-ref BC-3.9.009). VP-576-005 added to BC-3.9.017 (combined-gate single-prompt pin: `--replace-existing --public` with ≥1 match fires EXACTLY ONE prompt; `--yes` bypasses both; cancel issues zero DELETE + zero POST; anchor BC-3.9.017, cross-ref EC-3.9.017-11/12). VP count 33→35. |
| P20-007 (INFO) | INFO | — | NO ACTION (recorded) | BC-NUMBER-043-DUPLICATE drift item (pre-existing BC-2.4.043/BC-2.5.043 numbering collision from P19-I2). Already ledgered. No action this round. |

**BC count at this round: 657 (unchanged). Holdout count: 99 (+1 H-NEW-ATTACHMENT-011). VP count: 35 (+2: VP-576-004, VP-576-005). Spec version: 1.3.60. Both guards exit 0.**

## Adversary Pass 21 Fix Round Finding Dispositions

Source: Adversary Pass 21. 1 HIGH / 1 MEDIUM / 3 LOW / 1 INFO findings. Spec version bump: 1.3.60 → 1.3.61. No new BCs. Holdouts: 99→100 (+1 H-NEW-ATTACHMENT-012). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P21-001 (HIGH) | HIGH | bc-3-issue-write.md, holdout-scenarios.md, CANONICAL-COUNTS.md, BC-INDEX.md | APPLIED | BC-3.9.010 bulk-delete paragraph rewritten: "If any single DELETE fails mid-batch, jr stops at the first failure" replaced with correct statement that 404 is NOT a failure on bulk path — benign-skip per EC-3.9.010-4/BC-3.9.013; 404'd AID excluded from count/ids; iteration continues; first NON-404 failure stops batch; "404 → exit 64" removed from bulk enumeration; single-vs-bulk 404 divergence cross-ref sentence added (BC-3.9.008 exits 64 on single-AID 404; BC-3.9.013 benign-skip on bulk — intentionally asymmetric). H-NEW-ATTACHMENT-012 holdout added (3-AID bulk delete; middle AID 40002 returns 404; count=2; ids=["40001","40003"]; exit 0; wiremock asserts 3 DELETE calls; pins EC-3.9.010-4/BC-3.9.013). Holdout count 99→100. |
| P21-002 (MEDIUM) | MEDIUM | bc-3-issue-write.md | APPLIED | VP-576-005: plain `GET /rest/api/3/issue/EJ-1` mount (1) removed — BC-3.9.017 step 0 derives project key from issue-key string prefix (`EJ-1`→`EJ`) without an issue GET; EC-3.9.003-5 P17-003 mandates exactly ONE issue GET per invocation (the `?fields=attachment` GET at step 1). Mounts renumbered: (1) GET /rest/api/3/project/EJ, (2) GET /rest/api/3/issue/EJ-1?fields=attachment, (3)–(5) remainder. Assert (d) added: wiremock strict mode verifies ZERO plain GET /rest/api/3/issue/EJ-1 requests without query parameters. |
| P21-003 (LOW) | LOW | holdout-scenarios.md | APPLIED | Group 19 header range bumped from "(H-NEW-ATTACHMENT-001..010)" to "(H-NEW-ATTACHMENT-001..012)" — header was already behind H-NEW-ATTACHMENT-011 (added P20-001); corrected to reflect both 011 and new 012. |
| P21-004 (LOW) | LOW | bc-3-issue-write.md, BC-INDEX.md | APPLIED | BC-3.9.004 branch-(a) HTTP sequence: "project GET (cache-miss only)" expanded to "project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: GET /rest/api/3/project/{key} + GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId)". Branch (b) non-JSM sequence verified correct (only project GET, no servicedesk pagination) — left unchanged. BC-INDEX.md BC-3.9.004 row updated. |
| P21-005 (LOW) | LOW | bc-3-issue-write.md, BC-INDEX.md | APPLIED | EC-3.9.004-4 added to BC-3.9.004 (Step-0 suppression when entered from BC-3.9.017 step 4 on `--replace-existing --internal` path — existence validated by step 1 `?fields=attachment` GET; ONE issue GET per invocation; symmetric with EC-3.9.003-5 P17-003 on `--replace-existing --public` path). BC-3.9.017 step 4 text extended: "Step-0 suppression on `--internal` path (BC-3.9.004 EC-3.9.004-4)" cross-ref added. BC-3.9.004 Trace and BC-INDEX row updated. |
| P21-006 (INFO) | INFO | bc-2-issue-read.md, BC-INDEX.md | APPLIED | BC-2.7.012 KEY-404 row: annotation "(batch paths only — `--id` does not server-verify KEY per BC-2.7.007)" added to KEY-404 condition cell. BC-INDEX.md BC-2.7.012 row updated with equivalent annotation. |

**BC count at this round: 657 (unchanged). Holdout count: 100 (+1 H-NEW-ATTACHMENT-012). VP count: 35 (unchanged). Spec version: 1.3.61. Both guards exit 0.**

---

## Adversary Pass 22 Fix Round Finding Dispositions

Source: Adversary Pass 22. 1 MEDIUM / 2 LOW / 1 INFO findings. Spec version bump: 1.3.61 → 1.3.62. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P22-001 (MEDIUM) | MEDIUM | bc-3-issue-write.md, BC-INDEX.md | APPLIED | BC-3.9.003 non-interactive bullet corrected: "exit 64 before any HTTP" → "exit 64 before any servicedeskapi call and before any upload POST (the Step-0 issue GET and project-meta resolution have already run — EC-3.9.003-7 evaluates eligibility first)" (P22-001(a)). BC-3.9.012 table row trigger for "Non-interactive without `--yes` (`--public`)" corrected: "local" → "local (after Step-0 issue GET + meta fetch)" (P22-001(b)). Mechanical sweep of all "before any HTTP" occurrences across `.factory/specs/prd/` and `.factory/phase-f2-spec-evolution/` confirmed: all remaining instances are genuinely pre-HTTP (clap-level conflicts, AID/id validation, file-existence checks, resolution mutual-exclusion, no-fields bail guards — none of which have a preceding mandated GET on their own path); the only instance contradicted by a preceding mandated GET was line 3316 of bc-3-issue-write.md, now corrected (P22-001(c)). H-NEW-ATTACHMENT-008 Setup step 2 and H-NEW-ATTACHMENT-010 Expected line 5 both already assert the pre-gate GETs fire — coherent with corrected phrasing; no changes needed (P22-001(d)). BC-3.9.003 Trace updated (P22-001). BC-INDEX.md BC-3.9.003 and BC-3.9.012 rows updated. |
| P22-002 (LOW) | LOW | bc-3-issue-write.md, BC-INDEX.md | APPLIED | EC-3.9.016-6 reworded: "proceed to BC-3.9.008 for each AID serially; JSON shape per BC-3.9.010" → "issue the DELETE wire call of BC-3.9.008 for each AID serially; 404 handling per BC-3.9.013 bulk exception (benign skip); JSON shape per BC-3.9.010." Removes the ambiguous "proceed to" phrasing that literally imported single-AID exit-64 semantics; replaces with explicit 404-is-benign-skip reference matching the surrounding bulk-path exception. BC-INDEX.md BC-3.9.016 row updated. |
| P22-003 (LOW) | LOW | bc-2-issue-read.md, BC-INDEX.md | APPLIED | BC-2.7.012 "Unknown issue key" body prose prepended with batch-only caveat: "**Unknown issue key** (batch paths only — `--all`/`--newest`; the `--id` path does not server-verify KEY per BC-2.7.007):" — aligning the prose with the table row annotation already added in P21-006. BC-INDEX.md BC-2.7.012 row updated. |
| P22-004 (INFO) | INFO | prd-delta-576.md | SUPERSEDED | NEW-R4-002 status updated to RESOLVED at P34 adjudication: 27→28 was a miscount encoding error; actual count 17 incl. ADR-0017; CANONICAL-COUNTS verified correct; resolved at pass-22 burst by state-manager (P34-003). Previously: NEW-R4-002 deferral text verified present in prd-delta-576.md (line 226): "ADR count update (27→28) — DEFERRED to state-manager; not assigned to spec-steward". Deferral item now RESOLVED. |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.62. Both guards exit 0.**

## Adversary Pass 23 Fix Round Finding Dispositions

Source: Adversary Pass 23. 1 MEDIUM / 2 LOW / 1 INFO findings. Spec version bump: 1.3.62 → 1.3.63. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P23-001 (MEDIUM) | MEDIUM | bc-3-issue-write.md, BC-INDEX.md | APPLIED | VP-576-005: explicit servicedesk-list mount (2) added for `GET /rest/servicedeskapi/servicedesk` (BC-X.8.010 cache-miss GET-2 — `get_or_fetch_project_meta` pagination call to resolve `serviceDeskId`; match is `serviceDesk.projectId == project.id` per H-NEW-ATTACHMENT-009 wording, NOT `projectKey` per BC-3.9.003 step 1 P6-001 correction). Was vaguely attributed to mount (1) as "+ service desk meta" with no separate mount number or licensing BC clause. Mounts renumbered from (1)-(5) to (1)-(7) (mount (4) is test-env step `JR_STDIN_IS_TTY=1`). Wire-completeness ECHO-BREAKER LIST-B enumeration added: 6 HTTP calls × licensing BC clause each. BC-INDEX.md BC-3.9.017 row updated. |
| P23-002 (LOW) | LOW | bc-3-issue-write.md, BC-INDEX.md | APPLIED | ORCHESTRATOR RULING encoded: eligibility guards (BC-3.9.005 non-JSM exit-64 check, BC-3.9.017 step 0 validity checks) are NOT dry-run-suppressed — they fire unconditionally before any list GET even on `--dry-run`. Distinction from GATES (BC-3.9.014 confirmation prompts, which ARE suppressed). Changes: (a) EC-3.9.020-7 extended with "GATES vs ELIGIBILITY GUARDS" distinction sentence before "Exit 0." (P23-002 citation added to EC-3.9.020-7 citation line); (b) EC-3.9.020-8 added (new EC: `--replace-existing --dry-run --public` on non-JSM → eligibility guard fires at BC-3.9.017 step 0, exit 64, no preview emitted; mirrors EC-3.9.005-3); (c) EC-3.9.005-3 extended with dry-run non-suppression cross-ref to EC-3.9.020-8; (d) BC-3.9.005 Trace updated with P23-002 citation; (e) BC-3.9.020 Trace updated with P23-002 citation (EC-3.9.020-7 distinction + EC-3.9.020-8). BC-INDEX.md BC-3.9.005 and BC-3.9.020 rows updated. New EC-3.9.020-8 added to BC-3.9.020 row. |
| P23-003 (LOW) | LOW | bc-3-issue-write.md, BC-INDEX.md, prd-delta-576.md | APPLIED | VP-576-005 annotated with story allocation: "verified in S5 (S5 depends_on S3) — exercises the combined `--public` JSM two-step; textual home BC-3.9.017 (S3) per the EC-3.9.017-11/12 S5-realized pattern; NOT part of the S3 acceptance matrix (contrast VP-576-003, genuinely S3)". BC-INDEX.md BC-3.9.017 row updated. prd-delta-576.md S5 scope row updated with VP-576-005 allocation note. |
| P23-004 (INFO) | INFO | bc-3-issue-write.md | APPLIED | JSON Output Shape Contracts table `attachment upload --replace-existing --dry-run` row: appended "(with `--public`: wouldUpload entries include `"visibility":"public"` — EC-3.9.020-7; P23-004)" to the Notes column. No behavioral change — this annotation was already specified in EC-3.9.020-7; the table row lacked the cross-reference. |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.63. Both guards exit 0.**

## Adversary Pass 24 Fix Round Finding Dispositions

Source: Adversary Pass 24. 1 MEDIUM / 1 LOW findings. Spec version bump: 1.3.63 → 1.3.64. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P24-001 (MEDIUM) | MEDIUM | bc-3-issue-write.md, BC-INDEX.md | APPLIED | BC-3.9.009 body download-exclusion fix: sentence "This curated form is the canonical attachment-object JSON shape across all `jr` attachment operations — upload, list, and download JSON outputs all use this shape." narrowed to "...for `jr` attachment upload and list operations — upload and list JSON outputs use this shape (download is excluded — it uses the distinct `{"downloaded":[...]}` manifest per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7)." Confirmed by grep: the normative claim was isolated to bc-3-issue-write.md:~3474; no other site in .factory/specs/, phase-f2-spec-evolution/, or phase-f1-delta-analysis/ repeats "download ... curated shape" in a normative claim (old consistency-report snapshots are historical, not authoritative). BC-INDEX.md BC-3.9.009 row updated with P24-001 citation. |
| P24-002 (LOW) | LOW | bc-2-issue-read.md, prd-delta-576.md | APPLIED | VP-576-004 annotated with story allocation (mirrors P23-003 pattern + R3.13 earliest-consumer principle): "list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); the full cross-path test lands at S3 — S3 depends_on S1 for the shared curated-serialization plumbing (earliest consumer S1 ships it, per the R3.13 principle). NOT part of the S1 acceptance matrix as a whole; the S1 matrix includes only the list half." prd-delta-576.md S1 scope row: VP-576-004 allocation one-liner added. S3 scope row: VP-576-004 full cross-path test landing note added (r34 gap-closure: note initially mis-landed in S5 row during P24 round; r34 added it to S3 row; S5 row note retained as accurate contextual info for S5 implementers — its wording says "lands at S3", does NOT claim S5-verification). |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.64. Both guards exit 0.**

## Adversary Pass 25 Fix Round Finding Dispositions

Source: Adversary Pass 25. 2 LOW + 1 INFO findings (first zero-MEDIUM-and-above pass). Spec version bump: 1.3.64 → 1.3.65. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P25-001 (LOW) | LOW | bc-2-issue-read.md, holdout-scenarios.md, BC-INDEX.md | APPLIED | ORCHESTRATOR RULING (hint-vs-error distinction): In `--output json` mode on partial batch failure — (a) per-file failure warnings ARE emitted to stderr (failures are ERRORS, not hints; consistent with model-b cache-writer warning convention); (b) `Downloaded N of M` summary is NOT emitted in JSON mode (it is a HINT; covered by EC-2.7.008-6's no-hints rule). Changes: (1) EC-2.7.008-6 "No stderr hints" sentence replaced with two-part hint-vs-error clause (per-file warnings unconditional; summary suppressed in JSON mode); (2) EC-2.7.008-7 "summary prints actual N of M" mode-scoped to human mode only; (3) Per-file download error policy paragraph point (3) updated — "from the N count in the summary" scoped to "human-mode summary"; (4) BC-2.7.008 Trace updated with P25-001 citation. H-NEW-ATTACHMENT-003 Call B2 Expected B2: three new assertions added — stderr CONTAINS per-file warning for AID 20021; stderr does NOT contain "Downloaded"; two additional MUST-FAIL bullets. Why-hidden and Status sections updated. BC-INDEX.md BC-2.7.008 row updated. ECHO-BREAKER LIST-B: H-NEW-ATTACHMENT-003 Call B2 stderr assertions licensing BC: EC-2.7.008-6 (P25-001). |
| P25-002 (LOW) | LOW | bc-2-issue-read.md, BC-INDEX.md | APPLIED | BC-2.7.011 containment step-1 case (c) reworded — pure does-not-apply exclusion for `--out <PATH>`: the user-supplied path is trusted operator input (BC-2.7.007/BC-2.7.010); neither step 1 (`canonicalize(out_dir)`) nor step 2 (`starts_with`) of the containment check applies to `--out`-supplied paths. Verification per instruction: the temp-file-placement section (Write-to-temp + atomic-rename in BC-2.7.007) does NOT reference `canonicalize(out_dir)` for the `--out` path — simplified to pure does-not-apply exclusion (instruction branch taken). Old case (c) implied the containment check ran on the `--out` path, contradicting BC-2.7.007/BC-2.7.010's trusted-operator-input ruling. BC-2.7.011 Trace updated with P25-002 citation. BC-INDEX.md BC-2.7.011 row updated. |
| P25-I01 (INFO) | INFO | impact-boundary-576.md | APPLIED | R3.9b PHASE-DOC-RETRO-ANNOTATION added: BC-2.7.007 step 1 constructs the content URL from the attachment id directly and does NOT read the metadata `content` field; metadata is used solely to obtain the canonical `filename`. The `content`-URL-from-metadata path described in R3.9b was superseded by the id-direct-construction rule during F2 spec finalisation. |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.65. Both guards exit 0.**

---

## Adversary Pass 26 Fix Round Finding Dispositions

Source: Adversary Pass 26 (second consecutive zero-MEDIUM pass). 3 LOW + 1 INFO findings. Spec version bump: 1.3.65 → 1.3.66. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P26-001 (LOW) | LOW | bc-2-issue-read.md, error-taxonomy.md, BC-INDEX.md | APPLIED | BC-2.7.012 error table: KEY-403 batch-paths-only row added after KEY-404 row — `"Permission denied: cannot access issue <KEY>."`, exit 1, batch paths only (`--all`/`--newest`); mirrors BC-2.7.006 P15-005 row; error-taxonomy row 95 issue-GET sub-variant citation changed from `BC-2.7.006` to `BC-2.7.012 batch paths only` (BC-2.7.006 kept for row 94 attachment-list); BC-2.7.012 Trace updated (P26-001). BC-INDEX.md BC-2.7.012 row updated. |
| P26-002 (LOW) | LOW | holdout-scenarios.md | APPLIED | H-NEW-ATTACHMENT-003 Expected A bullet 2: bare examples `evil.txt` and `__.evil.txt` struck; replaced with SHA-1-prefixed form only: `<sha1("20003")>_evil.txt` (basename sanitized to `evil.txt`, then batch SHA-1 prefix applied). Contradicts bullet 1's unconditional-SHA-1-prefix mandate eliminated; both bullets now consistent with BC-2.7.010 batch naming. |
| P26-003 (LOW) | LOW | bc-2-issue-read.md, impact-boundary-576.md, BC-INDEX.md | APPLIED | RULING: option (b), partial struct + Option typing. (1) BC-2.7.007 step 1: partial-struct absent-tolerance clause added — metadata deserialization uses a PARTIAL struct requiring only `filename` (id implied by the request); all other fields (`created`, `author`, `mimeType`, `size`, `content`) are absent-tolerant — the step's sole purpose is canonical-filename retrieval, and fixtures/servers may omit metadata fields. BC-2.7.007 Trace updated (P26-003). (2) impact-boundary-576.md §1.1 `src/types/jira/attachment.rs` description: PHASE-DOC-RETRO-ANNOTATION added — `created` and `author` are `Option` in the shipped design; deserialization MUST tolerate null/absent `author` (BC-2.7.002 null-author) and absent `created`; the LIST-path full struct and the download metadata partial struct share the same Rust type via `Option` typing; the step-1 metadata fetch uses the partial form (P26-003). (3) H-002 fixtures left AS-IS (confirmed correct under ruling). BC-INDEX.md BC-2.7.007 row updated. |
| P26-004 (INFO) | INFO | bc-3-issue-write.md, BC-INDEX.md | APPLIED | BC-3.9.019 Source field softened: `src/duration.rs::parse_age_duration` hard-citation replaced with `parse_age_duration` (S4 location TBD — `src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling, per impact-boundary R3.9a). BC-3.9.019 Trace updated (P26-004). BC-INDEX.md BC-3.9.019 row updated with location-TBD note. |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.66. Both guards exit 0.**

---

## Adversary Pass 27 Fix Round Finding Dispositions

Source: Adversary Pass 27. 1 MEDIUM / 2 LOW / 1 INFO findings. Spec version bump: 1.3.66 → 1.3.67. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P27-001 (MEDIUM) | MEDIUM | bc-2-issue-read.md, holdout-scenarios.md, bc-3-issue-write.md, BC-INDEX.md | APPLIED | ORCHESTRATOR RULING option (b): `downloaded[].filename` = RAW Jira `attachment.filename` (pre-sanitization); on-disk basename (post-sanitization, post-SHA-1-prefix in batch mode) is recoverable from `path`. Deliberate pairing: `filename` = what Jira calls it; `path` = where it landed. Changes: (1) EC-2.7.007-7: explicit `filename` semantics clause appended — RAW name; on-disk basename in `path`; deliberate pairing documented; BC-2.7.007 Trace updated (P27-001). (2) EC-2.7.008-6: same `filename` semantics clause appended; BC-2.7.008 Trace updated (P27-001). (3) H-NEW-ATTACHMENT-003 Call B2 Expected B2: manifest corrected — `"filename":"ok.txt"` (RAW Jira name, NOT `<sha1-of-20020>_ok.txt`); discriminating assertion added: `jq '.downloaded[0].filename'` = `"ok.txt"` AND `basename(path)` = `<sha1("20020")>_ok.txt` (these two MUST differ); additional MUST-FAIL bullet added for SHA-1-prefixed `filename`; Why-hidden and Status sections updated. Sweep confirmed: no other Group-19 manifest assertions carry sha1-prefixed `filename` values; H-007 and other scenarios reference sha1 forms only in filesystem paths (on-disk names), not in JSON manifest `filename` fields. (4) JSON Output Shape Contracts table download rows (~bc-3-issue-write.md:3219-3220): Notes column updated — `filename` = RAW Jira name; `path` basename = on-disk name; deliberate pairing cited. (5) BC-INDEX.md BC-2.7.007 and BC-2.7.008 rows updated with P27-001 notes. |
| P27-002 (LOW) | LOW | holdout-scenarios.md | APPLIED | H-NEW-ATTACHMENT-007 fixture description corrected: `id="60003"` overlong name (251 `a` + `.txt` = 255 bytes) was described as "(at the length-cap boundary)" — corrected to "(exceeds the 214-byte sanitizer cap — BC-2.7.011 step 5; truncated to 214, then 41-byte SHA-1 prefix = 255-byte on-disk name at NAME_MAX)". Missing length-cap assertion added to Expected section: "the on-disk basename after the SHA-1 prefix underscore is ≤ 214 bytes" (pins BC-2.7.011 step 5 — assert `len(basename(path).split('_', 1)[1].encode('utf-8')) <= 214`). H-NEW-ATTACHMENT-007 Status updated with P27-002 citation. Licensing BC: BC-2.7.011 step 5. |
| P27-003 (LOW) | LOW | bc-2-issue-read.md, BC-INDEX.md | APPLIED | ORCHESTRATOR RULING: collision-skip warning = HINT, suppressed in JSON mode. EC-2.7.008-6 channel policy extended: "Collision-skip warnings (P27-003): collision-skip warnings are NON-ERROR hints — suppressed in `--output json` mode (same class as the `Downloaded N of M` summary and `--filter` exclusions which are silent; the manifest's omission of the skipped file IS the machine signal, consistent with EC-2.7.008-10 filtered-to-zero precedent). Human mode unchanged." BC-2.7.008 Trace updated (P27-003). BC-INDEX.md BC-2.7.008 row updated with P27-003 collision-skip hint classification note. |
| P27-INFO-1 (INFO) | INFO | — | NO ACTION | Single-vs-multi dry-run metadata asymmetry is deliberate and already documented as P15-INFO-2 family. No spec change required. |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.67. Both guards exit 0.**

---

## Adversary Pass 28 Fix Round Finding Dispositions

Source: Adversary Pass 28. 2 MEDIUM findings. Spec version bump: 1.3.67 → 1.3.68. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P28-001 (MEDIUM) | MEDIUM | bc-3-issue-write.md, BC-INDEX.md | APPLIED | EC-3.9.020-8 wire enumeration corrected: the terminal sentence "no HTTP calls beyond step-0 issue GET and meta fetch" replaced with accurate description of what fires on the `--replace-existing --dry-run --public` non-JSM path. The `--replace-existing` path (BC-3.9.017 step 0) derives the project key from the issue-key string prefix — no issue GET has run yet at that pre-flight point. The only HTTP call is the project-meta fetch (`GET /rest/api/3/project/{key}` — cache-miss); the `GET /rest/servicedeskapi/servicedesk` pagination does NOT fire because the project is NOT `service_desk`. New wording: "no HTTP calls beyond the project-meta fetch (`GET /rest/api/3/project/{key}` — cache-miss; no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`); no issue GET occurs on the `--replace-existing` step-0 path (project key derived from the issue-key string prefix per BC-3.9.017 step 0)." BC-3.9.020 Trace updated with P28-001 citation. BC-INDEX.md BC-3.9.020 row updated with P28-001 wire-enumeration corrected note. Sweep confirmed: the phrase "step-0 issue GET" appeared only in bc-3-issue-write.md:~3895 (the corrected EC body) and in `.factory/phase-f2-spec-evolution/consistency-report-576-r33.md` (historical snapshot — not authoritative; left as-is). |
| P28-002 (MEDIUM) | MEDIUM | holdout-scenarios.md | APPLIED | H-NEW-ATTACHMENT-009 Expected bullet 4 narrowed — the over-broad "Zero requests to any `/rest/servicedeskapi/...` path" assertion contradicted the scenario's own setup step 3 which mounts `GET /rest/servicedeskapi/servicedesk` (the JSM meta-resolution call that fires BEFORE the gate during `get_or_fetch_project_meta`). Replaced with POST-only assertion: "Zero requests to the upload POSTs — `POST .../attachTemporaryFile` and `POST .../request/{key}/attachment` — before or after the gate. (The `GET /rest/servicedeskapi/servicedesk` meta-resolution call DOES fire before the gate during JSM detection — it is mounted in setup step 3; assert only that the upload POSTs are absent.)" Licensing BC added (BC-3.9.003 step 1 / BC-X.8.010 for the GET; BC-3.9.014 gate for the POST absence). Mirrors VP-576-005 cancel-variant's servicedeskapi-POST-only assertion style. Status updated with P28-002 citation. Holdout frontmatter: version 1.5.4→1.5.5; trace entry added. |

**Mount-vs-Assertion Sweep (P28-002 proactive sweep — all Group-19 holdouts + VP-576-002/003/005):**

| Scenario | Zero/no-requests assertions | Mounts in setup that could be violated | Verdict |
|---|---|---|---|
| H-NEW-ATTACHMENT-001 | None | N/A | OK |
| H-NEW-ATTACHMENT-002 | None | N/A | OK |
| H-NEW-ATTACHMENT-003 | None on forbidden paths | N/A | OK |
| H-NEW-ATTACHMENT-004 | "DELETE NOT called (no mock mounted)" Call C | No DELETE mounted on Call C path; GET ?fields + POST mounted | OK |
| H-NEW-ATTACHMENT-005 | `.expect(0)` on DELETE in cancel/non-interactive paths | DELETE mount with `.expect(0)` is the mechanism; no servicedeskapi assertions | OK |
| H-NEW-ATTACHMENT-006 | `.expect(0)` on DELETE mounts for dry-run path | Correctly isolated by wiremock teardown between calls | OK |
| H-NEW-ATTACHMENT-007 | None on servicedeskapi | N/A | OK |
| H-NEW-ATTACHMENT-008 | "Zero requests to any `/rest/servicedeskapi/...` path" | No servicedeskapi mounts; non-JSM project → servicedesk GET never fires | OK |
| H-NEW-ATTACHMENT-009 | WAS: "Zero requests to any `/rest/servicedeskapi/...`" — setup step 3 mounts `GET /rest/servicedeskapi/servicedesk` which DOES fire pre-gate | CONTRADICTION → FIXED by P28-002 (narrowed to POST-only assertion) | FIXED |
| H-NEW-ATTACHMENT-010 | "Zero requests to DELETE" and "Zero requests to POST /attachments" | No DELETE or POST mounts for this non-interactive exit-64 path | OK |
| H-NEW-ATTACHMENT-011 | "Wiremock strict-mode: zero requests to any `/rest/servicedeskapi/...` path" | No servicedeskapi mounts; non-JSM project → servicedesk GET never fires | OK |
| H-NEW-ATTACHMENT-012 | None on forbidden paths | N/A | OK |
| VP-576-002 | `.expect(0)` on DELETE in cancel variant; no servicedeskapi zero-claim | Separate metadata GET + DELETE mounts; no servicedeskapi | OK |
| VP-576-003 | "(b) zero requests to any `/rest/servicedeskapi/...`" | FOO key → non-JSM; no servicedeskapi mounts → GET never fires | OK |
| VP-576-005 | "(c) cancel variant: ZERO servicedeskapi POST requests" | Mount (2) is GET /servicedeskapi/servicedesk (fires pre-gate at step 0); assertion scoped to POSTs only — consistent | OK |

Additional contradictions found: **0** (only H-NEW-ATTACHMENT-009 had the P28-002 defect class; all others are consistent).

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.68. Both guards exit 0.**

---

## Adversary Pass 29 Fix Round Finding Dispositions

Source: Adversary Pass 29. 1 LOW finding. Spec version bump: 1.3.68 → 1.3.69. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P29-001 (LOW) | LOW | prd-delta-576.md | APPLIED | Stale duplicate closing-summary line deleted from the P28 dispositions section. The line "**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.67. Both guards exit 0.**" was a leftover from the P27 footer that was not removed when the P28 section was appended; the correct P28 line ("Spec version: 1.3.68") was already present immediately above it. Deleted line is quoted verbatim in the confirmation message. No BC bodies touched; no bc-2/bc-3 frontmatter trace entries owed this round. |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.69. Both guards exit 0.**

## Adversary Pass 30 Fix Round Finding Dispositions

Source: Adversary Pass 30. 1 MEDIUM / 2 LOW / 1 INFO finding. Spec version bump: 1.3.69 → 1.3.70. No new BCs. Holdouts: 100 (unchanged). VPs: 35 (unchanged).

| Finding ID | Severity | File(s) Touched | Status | Change |
|------------|----------|----------------|--------|--------|
| P30-001 (MEDIUM) | MEDIUM | bc-3-issue-write.md, BC-INDEX.md | APPLIED | BC-3.9.003 step 1: self-heal cross-reference sentence added — a step-1 404/403 on `POST .../attachTemporaryFile` FIRST triggers the BC-X.8.010 SEC-576-006 self-heal (invalidate `project_meta.json` cache for `(profile, projectKey)` → re-call `get_or_fetch_project_meta` once → re-attempt step 1); only post-retry failure falls through to BC-3.9.012 (post-retry 404 → exit 64; post-retry 403 → exit 1 per BC-X.8.010 step 4); retry is single-attempt. BC-3.9.012: step-1 attachTemporaryFile 403/404 carve-out added before EC-3.9.012-1 — post-retry exit codes quoted verbatim from BC-X.8.010 step 4 (404→exit 64 `"Service desk for <projectKey> not found after refresh."`; 403→exit 1 permission denied); all other codes map on first occurrence without self-heal. BC-3.9.006 "stale-sdId cache is not a root cause here" scoping note verified — it refers to step 2 endpoint keying off `issueKey` not `serviceDeskId`; no contradiction; unchanged. Holdout grep for `attachTemporaryFile` + step-1 404/403: zero scenarios found; no holdout additions this round (S5 live-capture-adjacent coverage noted). BC-3.9.003 and BC-3.9.012 Traces updated. BC-INDEX rows BC-3.9.003 and BC-3.9.012 synced. |
| P30-002 (LOW) | LOW | bc-3-issue-write.md, BC-INDEX.md | APPLIED | BC-3.9.019 pre-deletion summary `"Deleting N attachment(s) older than <duration> from <KEY>."` classified as **HINT — suppressed in `--output json` mode** (count carried in JSON `"count"` field; per EC-2.7.008-6 hint-vs-error principle; "Human mode only." annotation added). BC-3.9.019 Trace updated. BC-INDEX BC-3.9.019 row synced. §3.9 STDERR ENUMERATION (full round) — see table below. No additional unclassified emissions found beyond BC-3.9.019 pre-deletion summary. |
| P30-003 (LOW) | LOW | ADR-0017 | APPLIED | §Rationale ~line 114 stale call-site corrected: `src/api/jira/issues.rs` (or a new `attachments.rs`) → `src/api/jira/attachments.rs` (per CONS-576-002 sweep — BC-3.9.x Source fields and impact-boundary §1.1 name `src/api/jira/attachments.rs`; the parenthetical `(or a new attachments.rs)` dropped as superseded). Inline annotation added: "(call-site corrected per CONS-576-002, P30-003)". ADR is append-annotated; no structural ADR content changed. |
| P30-I01 (INFO) | INFO | bc-3-issue-write.md, BC-INDEX.md | APPLIED | BC-3.9.016 CLI flags line: `<AID>...` positional shorthand annotated — "(positional, 1+ when used — optional under the required selector group; bare `delete` → exit 2 per the clap section; mutually exclusive with --issue/--older-than form)". BC-3.9.016 Trace updated. BC-INDEX BC-3.9.016 row synced. |

**§3.9 STDERR ENUMERATION TABLE (P30-002 round)**

| BC | Emission | Category | JSON-mode behavior | Notes |
|---|---|---|---|---|
| BC-3.9.001 | 413: `"Attachment too large: the file exceeds the server-configured limit."` | ERROR | emitted | unconditional |
| BC-3.9.001 | 400: Jira error body | ERROR | emitted | unconditional |
| BC-3.9.003/014 | Confirmation gate prompts (3 consumer variants) | GATE-PROMPT | not applicable | interactive-only by construction; non-interactive path exits 64 instead |
| BC-3.9.003/014 | Non-interactive exit-64 hints (3 variants) | ERROR | emitted | unconditional (exit 64) |
| BC-3.9.003/014 | `"Upload cancelled."` (interactive cancel branch (b)) | HINT | suppressed | JSON has `{"cancelled":true,"uploaded":false}`; human mode only |
| BC-3.9.005 | `"--public is only supported on Jira Service Management (JSM) issues."` | ERROR | emitted | unconditional |
| BC-3.9.006 | `"Temporary attachment IDs may have expired. Try the upload again."` (step-2 failures) | ERROR | emitted | fires on non-zero exits; analogous to per-file failure warnings (EC-2.7.008-6 pattern) |
| BC-3.9.008/013 | AID validation: `"invalid attachment id: '<VALUE>' (must be numeric)"` | ERROR | emitted | unconditional |
| BC-3.9.008 | 404: `"Attachment <AID> not found or not accessible."` + Jira body | ERROR | emitted | unconditional |
| BC-3.9.008/013 | 403, 401, 5xx, network errors | ERROR | emitted | unconditional |
| BC-3.9.012 | All rows in error-taxonomy table | ERROR | emitted | unconditional (see carve-out for step-1 404/403 added P30-001) |
| BC-3.9.015 | Gate prompt: `"Delete attachment <filename> (<AID>)? [y/N] "` | GATE-PROMPT | not applicable | interactive-only by construction |
| BC-3.9.015 | Non-interactive exit-64: `"Use --yes to confirm deletion without a prompt."` | ERROR | emitted | unconditional (exit 64) |
| BC-3.9.015 | `"Deletion cancelled."` (interactive cancel) | HINT | suppressed | JSON has `{"cancelled":true,"deleted":false}`; human mode only |
| BC-3.9.015 | Metadata-fetch 404/403/401/5xx/network | ERROR | emitted | unconditional (all fire before gate) |
| BC-3.9.016 | `"--older-than requires --yes to confirm bulk deletion."` | ERROR | emitted | unconditional (exit 64) |
| BC-3.9.016 | `"--yes is required to delete multiple attachments without a confirmation prompt."` | ERROR | emitted | unconditional (exit 64) |
| BC-3.9.017 | Gate prompts (3 consumer variants) | GATE-PROMPT | not applicable | interactive-only by construction |
| BC-3.9.017 | Non-interactive exit-64 hints (2 sub-variants) | ERROR | emitted | unconditional (exit 64) |
| BC-3.9.017 | `"Upload cancelled."` (cancel) | HINT | suppressed | JSON has `{"cancelled":true,"uploaded":false}`; human mode only |
| BC-3.9.019 | `"Deleting N attachment(s) older than <duration> from <KEY>."` | **HINT** | **suppressed** | **FIXED P30-002** — count in JSON `"count"` field; EC-2.7.008-6; human mode only |
| BC-3.9.019 | `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."` | ERROR | emitted | unconditional (exit 64) |
| BC-3.9.019 | Malformed-created-timestamp skip warning | ERROR | emitted | fires per-item; operation continues; unconditional (analogous to per-file download warnings) |
| BC-3.9.020 | `"--dry-run has no effect on single-ID delete; omit the flag."` | HINT | suppressed | explicitly stated: "NO stderr hint in JSON mode" |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.70. Both guards exit 0.**

---

## P31 Dispositions (adversary pass 31, 2026-07-17) — 2 LOW + 1 INFO

| Finding | Severity | Artifacts | Status | Resolution |
|---|---|---|---|---|
| P31-001 (LOW) | LOW | holdout-scenarios.md | APPLIED | H-NEW-ATTACHMENT-002 error-path Expected exit-code tightened. The scenario mounts a metadata-200/content-500 response — exactly one conformant code: exit 1 (EC-2.7.007-4 mid-stream error; BC-2.7.012 5xx row). Changed "Exit code != 0 (exit 1 or exit 64)" → "Exit code = 1 (EC-2.7.007-4 mid-stream error; BC-2.7.012 5xx row)". Holdout trace entry added. |
| P31-002 (LOW) | LOW | bc-2-issue-read.md, BC-INDEX.md | APPLIED | Manifest `size` semantics established as bytes written to disk (uniform across single and batch). Three changes: (1) EC-2.7.008-6: `size` semantics sentence added — `downloaded[].size` is the byte count written to disk, identical to EC-2.7.007-7, NOT the list-reported `fields.attachment[].size`; in normal operation the two coincide (atomic rename fires only on complete stream) but written-bytes is authoritative. (2) BC-2.7.008 Batch metadata source sentence scoped — list response supplies filename/size/contentUrl for NAMING, filtering, and pre-download purposes; manifest `size` field is written-bytes per EC-2.7.008-6. (3) "Shape aligns with EC-2.7.007-7 for a uniform download response type" → "Shape and field semantics align with EC-2.7.007-7 for a uniform download response type" (now true for both shape and field semantics). BC-2.7.008 Trace and BC-INDEX row updated. |
| P31-003 (INFO) | INFO | bc-3-issue-write.md, BC-INDEX.md | APPLIED | BC-3.9.012 step-1 carve-out extended. Added sentence: "A post-retry 401/5xx/network response maps per BC-X.8.010 step 4 (401 → exit 2; 5xx/network → exit 1) — the same universal codes as first-occurrence." This eliminates the ambiguity in "first occurrence" phrasing which could be misread as those codes only applying once. The carve-out previously covered only 403/404 post-retry; 401/5xx/network were stated to map on first-occurrence without clarifying what happens post-retry (they map identically). BC-3.9.012 Trace and BC-INDEX row updated. |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.71. Both guards exit 0.**

---

## P32 Dispositions (adversary pass 32, 2026-07-17) — 1 LOW

| Finding | Severity | Artifacts | Status | Resolution |
|---|---|---|---|---|
| P32-001 (LOW) | LOW | bc-2-issue-read.md, BC-INDEX.md | APPLIED | BC-2.7.007 `--out` pre-flight ordering pinned. The `--out` unconditional step-1 paragraph never stated whether the local pre-flight checks (EC-2.7.007-6 parent-exists, EC-2.7.007-11 path-is-directory, overwrite-refuse) fire before or after the step-1 metadata GET. A double-fault (404 AID + bad `--out`) would yield nondeterministic stderr across conforming implementations. ORCHESTRATOR RULING: local checks fire first (fail cheap/offline first; AID-regex-before-HTTP precedent). Ordering sentence appended to the `--out` UNCONDITIONAL two-step paragraph: "On the `--out` path, the local pre-flight checks (EC-2.7.007-6 parent-exists, EC-2.7.007-11 path-is-directory, overwrite-refuse) fire BEFORE the step-1 metadata GET — fail cheap/offline first (AID-regex-before-HTTP precedent, P32-001); on a double-fault the local check's message wins." BC-2.7.007 Trace and BC-INDEX row updated. **Holdout double-fault check**: H-002 and H-003 are auth/profile holdouts unrelated to attachment download — neither asserts a double-fault stderr message. No other H-NEW-ATTACHMENT-* holdout constructs a double-fault fixture. List B is EMPTY (no holdout assertion changes). |

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.72. Both guards exit 0.**

---

## P33 Dispositions (adversary pass 33, 2026-07-17) — 1 LOW (footer-currency class)

| Finding | Severity | Artifacts | Status | Resolution |
|---|---|---|---|---|
| P33-001 (LOW) | LOW | bc-3-issue-write.md | APPLIED | bc-3 footer corrected. The footer pass-narrative was stale: (a) "Last updated" named pass-30 as most-recent, omitting P31 (confirmed in frontmatter trace v1.3.71). (b) Sequence jumped directly 30→24, omitting P26/P27/P28 — all three confirmed by frontmatter trace (v1.3.66, v1.3.67, v1.3.68 respectively). P25 and P29 confirmed absent from bc-3 (no frontmatter trace entries and zero body Trace citations). P32 confirmed absent from bc-3 (only touched bc-2-issue-read.md). Fix: (1) New "Last updated" entry for P33 (this correction) added at top. (2) P31 entry inserted as second entry. (3) P28/P27/P26 entries inserted between P30 and P24. (4) spec v1.3.70 annotation added to end of P30 entry. bc-3 frontmatter trace entry v1.3.73 added. No BC-INDEX row changes owed (footer-only fix — no BC body or BC-INDEX row content changed). |

**ECHO-BREAKER LIST A (spec changes):** bc-3 footer: "Last updated" advanced from pass-30 to pass-33 (this correction); P31 entry added; P28/P27/P28 entries inserted between P30 and P24; P25/P29/P32 confirmed absent and not added. bc-3 frontmatter trace: v1.3.73 entry added.

**ECHO-BREAKER LIST B (holdout assertion changes): EMPTY.** No holdout assertions changed; footer corrections are metadata-only.

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.73. Both guards exit 0.**

---

## P34 Dispositions (adversary pass 34, 2026-07-17) — 2 MEDIUM / 2 LOW / 1 INFO

| Finding | Severity | Artifacts | Status | Resolution |
|---|---|---|---|---|
| P34-001 (MEDIUM) | MEDIUM | impact-boundary-576.md | APPLIED | PHASE-DOC-RETRO-ANNOTATION added at two SQ-5/R2.5 sites: SQ-5 (~line 281) `exit 64` and R2.5 (~line 538) `exit 64` both annotated "(superseded in shipped spec: 413 → exit 1 per BC-3.9.001/BC-3.9.012/error-taxonomy row 102 — the graceful-handling ruling stands, the exit code refined to 1 (server-side error family) in F2; P34-001)". BCs NOT touched. |
| P34-002 (MEDIUM) | MEDIUM | prd-delta-576.md (Scope table S3+S5 rows) | APPLIED | Scope table S3 row BC-3.9.017 split note: "combined `--public` ECs (EC-3.9.017-11/12)" split — EC-3.9.017-12 (`--yes` universal bypass) non-public arm now explicitly scoped to S3 (VP-576-003 pins EC-3.9.017-10/12); EC-3.9.017-11 (combined single-prompt) remains S5-realized. Scope table S5 row BC-3.9.017 split note: analogous split — EC-3.9.017-12 combined arm verified in S5 (VP-576-005); non-public arm ships with S3 (VP-576-003). |
| P34-003 (LOW) | LOW | prd-delta-576.md (NEW-R4-002 row ~226; P22-004 row ~420) | APPLIED | NEW-R4-002 row: Status DEFERRED → RESOLVED; text updated: "27→28 was a miscount encoding error; actual count 17 incl. ADR-0017; CANONICAL-COUNTS verified correct; resolved at pass-22 burst by state-manager (P34-003)". P22-004 row: Status CONFIRMED → SUPERSEDED; text updated noting NEW-R4-002 is now RESOLVED at P34 adjudication with same summary. CANONICAL-COUNTS ADR section NOT touched (already correct). |
| P34-004 (LOW) | LOW | bc-2-issue-read.md, BC-INDEX.md | APPLIED | EC-2.7.008-1: JSON-mode clause added — empty issue on `--all` returns `{"downloaded":[]}` in JSON mode; `"No attachments on <KEY>."` is a HINT suppressed in JSON mode (EC-2.7.008-6 taxonomy); EC-2.7.001-1 unification clarified as canonical STRING only, not JSON shape. BC-2.7.008 Trace updated. EC-2.7.009-4 added to BC-2.7.009: empty issue on `--newest` follows EC-2.7.008-1 (cross-ref EC). BC-2.7.009 Trace updated. BC-INDEX BC-2.7.008 and BC-2.7.009 rows synced. BC-INDEX frontmatter bumped v6.31→v6.32. bc-2 frontmatter trace entry v1.3.74 added. |
| P34-005 (INFO) | INFO | CANONICAL-COUNTS.md | APPLIED | Grand-total prose line ~55: "+27 BC-2.7.001..012 + BC-3.9.001..014 + BC-X.8.010 added 2026-07-15" corrected to "+33 (=+27 initial CREATE 2026-07-15 + 6 round-B BC-3.9.015..020) BC-2.7.001..012 + BC-3.9.001..014 + BC-X.8.010 added 2026-07-15". Lines 66/79 (already correct) unchanged. |

**ECHO-BREAKER LIST A (spec changes):** bc-2-issue-read.md: EC-2.7.008-1 JSON-mode clause added; EC-2.7.009-4 empty-issue EC added; BC-2.7.008 Trace updated; BC-2.7.009 Trace updated; frontmatter trace entry v1.3.74 added. BC-INDEX.md: BC-2.7.008 row synced (P34-004 EC-2.7.008-1 JSON-mode clause); BC-2.7.009 row synced (EC-2.7.009-4 cross-ref); frontmatter last_updated + index_version bumped v6.31→v6.32. impact-boundary-576.md: SQ-5 (~line 281) + R2.5 (~line 538) PHASE-DOC-RETRO-ANNOTATION added. prd-delta-576.md: S3+S5 scope-table BC-3.9.017 split note split per EC-3.9.017-11/12 (P34-002); NEW-R4-002 row DEFERRED→RESOLVED; P22-004 row CONFIRMED→SUPERSEDED with RESOLVED summary (P34-003). CANONICAL-COUNTS.md: grand-total "+27" → "+33 (=+27+6)" (P34-005). spec-changelog.md: [1.3.74] entry added. prd-delta-576.md: spec_version_after 1.3.73→1.3.74; P34 dispositions appended.

**ECHO-BREAKER LIST B (holdout assertion changes): EMPTY.** No holdout BCs or assertions changed this round.

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.74. Both guards exit 0.**

---

## P35 Dispositions (adversary pass 35, 2026-07-17) — 1 LOW / 2 INFO

| Finding | Severity | Artifacts | Status | Resolution |
|---|---|---|---|---|
| P35-001 (LOW) | LOW | impact-boundary-576.md | APPLIED | R3.9b (~line 755) bullet "Derive the default output filename (`<sha1>_<sanitized-basename>`) without a separate list call" annotated with PHASE-DOC-RETRO-ANNOTATION: "(superseded: single-id download uses the BARE sanitized basename — no SHA-1 prefix; SHA-1 prefixing is batch-only per R3.10 / BC-2.7.010; P35-001)". BCs not touched. |
| P35-002 (INFO) | INFO | impact-boundary-576.md | APPLIED | R3.2 (~line 636) illustrative `--dry-run` JSON shape: inline note added after the backtick-quoted shape — "(key ordering in F1 illustrations is illustrative; canonical order is BTreeMap-alphabetical per P19-001 — authoritative shapes in BC-3.9.019/BC-3.9.020; P35-002)". R3.5 (~lines 670-671) BC-3.9.019 and BC-3.9.020 table rows: parenthetical cross-ref added to each JSON shape — "(illustrative key order; see R3.2 P35-002 note)". No BC body changes. |
| P35-003 (INFO) | INFO | holdout-scenarios.md | APPLIED | H-NEW-ATTACHMENT-002 Expected bullet 4: "stdout or stderr contains a success message referencing `notes.txt`." tightened to "stderr contains a progress/completion message referencing `notes.txt` (BC-2.7.007 profile 3: nothing on stdout in human mode; all progress and hints go to stderr; P35-003).". H-NEW-ATTACHMENT-004 Expected A bullet 1: "stdout/stderr contains `upload.txt` and `30001`" tightened to "stdout contains `upload.txt` and `30001` (BC-3.9.001 profile 4: human echo to stdout; P35-003)". Status lines for both scenarios updated with P35-003 citations (plus retroactive P31-001 citation added to H-NEW-ATTACHMENT-002 Status, which was missing from that round). holdout-scenarios.md frontmatter: trace entry v1.5.6 added; version bumped 1.5.5→1.5.6. |

**ECHO-BREAKER LIST A (spec changes):** impact-boundary-576.md: R3.9b PHASE-DOC-RETRO-ANNOTATION added (P35-001); R3.2 BTreeMap key-order inline note added (P35-002); R3.5 BC-3.9.019/BC-3.9.020 rows cross-ref parentheticals added (P35-002). holdout-scenarios.md: H-NEW-ATTACHMENT-002 Expected bullet 4 tightened to stderr-only (P35-003); H-NEW-ATTACHMENT-004 Expected A bullet 1 tightened to stdout-only (P35-003); H-NEW-ATTACHMENT-002 Status updated with P31-001 + P35-003 citations; H-NEW-ATTACHMENT-004 Status updated with P35-003 citation; frontmatter trace entry v1.5.6 added; version bumped 1.5.5→1.5.6. prd-delta-576.md: spec_version_after 1.3.74→1.3.75; P35 dispositions appended. spec-changelog.md: [1.3.75] entry added. BC-INDEX.md: NO row changes (no BC bodies changed this round; impact-boundary and holdout-scenarios changes are documentation-only).

**ECHO-BREAKER LIST B (holdout assertion changes):** H-NEW-ATTACHMENT-002 Expected bullet 4: "stdout or stderr contains a success message referencing `notes.txt`." → "stderr contains a progress/completion message referencing `notes.txt` (BC-2.7.007 profile 3: nothing on stdout in human mode; all progress and hints go to stderr; P35-003)." H-NEW-ATTACHMENT-004 Expected A bullet 1: "Exit code = 0. `POST /attachments` called with `X-Atlassian-Token: no-check` header. stdout/stderr contains `upload.txt` and `30001`." → "Exit code = 0. `POST /attachments` called with `X-Atlassian-Token: no-check` header. stdout contains `upload.txt` and `30001` (BC-3.9.001 profile 4: human echo to stdout; P35-003)."

**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP count: 35 (unchanged). Spec version: 1.3.75. Both guards exit 0.**
