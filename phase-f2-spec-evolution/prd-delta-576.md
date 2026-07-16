---
document_type: prd-delta
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
spec_version_before: 1.3.42
spec_version_after: 1.3.54
bc_count_before: 624
bc_count_after: 657
holdout_count_before: 88
holdout_count_after: 97
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
| S1 | `jr issue attachment list` (list + filter) | BC-2.7.001..006 |
| S2 | `jr issue attachment download` (single/batch/newest) | BC-2.7.007..012 |
| S3 | `jr issue attachment upload` (platform POST + `--replace-existing` + `--dry-run` path-c) | BC-3.9.001..002, BC-3.9.009, BC-3.9.012, BC-3.9.017, BC-3.9.018, BC-3.9.020 (path-c: `--replace-existing --dry-run` + EC-3.9.020-6 clap guard) |
| S4 | `jr issue attachment delete` | BC-3.9.008, BC-3.9.010, BC-3.9.013, BC-3.9.015, BC-3.9.016, BC-3.9.019, BC-3.9.020 |
| S5 | `jr issue attachment upload --public/--internal` (JSM visibility) | BC-3.9.003..007, BC-3.9.011, BC-3.9.014, BC-X.8.010 |

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
| NEW-R4-002 | INFO | CANONICAL-COUNTS.md | ADR count update (27→28) — DEFERRED to state-manager; not assigned to spec-steward | DEFERRED |

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
