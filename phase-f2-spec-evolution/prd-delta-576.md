---
document_type: prd-delta
feature: SOH-ATTACHMENTS-1
issues: "#576, #585"
phase: F2
authored: 2026-07-15
spec_version_before: 1.3.42
spec_version_after: 1.3.58
bc_count_before: 624
bc_count_after: 657
holdout_count_before: 88
holdout_count_after: 98
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
| S3 | `jr issue attachment upload` (platform POST + `--replace-existing` + `--dry-run` path-c) | BC-3.9.001..002, BC-3.9.009, BC-3.9.012, BC-3.9.014, BC-3.9.017, BC-3.9.018, BC-3.9.020 (path-c: `--replace-existing --dry-run` + EC-3.9.020-6 clap guard). **BC-3.9.014 gate mechanics ship with S3** (earliest gate consumer, required by BC-3.9.017 step 2's ≥1-match gate; S5 consumes them for the `--public`/combined variants — S5 `depends_on` S3; F3 must encode this edge). [P16-002 ORCHESTRATOR RULING: BC-3.9.014 reallocated S5→S3] **BC-3.9.007 scope note (P17-005)**: BC-3.9.007 EC-3.9.007-1 platform-echo clause is exercised in S3 (BC-3.9.001 + BC-3.9.009 ship with S3; earliest-consumer principle per R3.13). |
| S4 | `jr issue attachment delete` | BC-3.9.008, BC-3.9.010, BC-3.9.013, BC-3.9.015, BC-3.9.016, BC-3.9.019, BC-3.9.020 |
| S5 | `jr issue attachment upload --public/--internal` (JSM visibility) | BC-3.9.003..007, BC-3.9.011, BC-X.8.010. **BC-3.9.014 gate mechanics consumed here** for `--public` standalone (consumer 1) and combined `--public`+≥1-match (consumer 3) — gate mechanics ship with S3 (above); S5 depends_on S3 for this. **EC-3.9.020-7 path-c `--public` annotation**: the `"visibility":"public"` annotation on `wouldUpload` entries in `--replace-existing --dry-run --public` (path-c) is activated only when `--public` is supplied; its end-to-end behavior is verified in S5 — S3 implements the annotation plumbing keyed on the flag. [P16-002 ORCHESTRATOR RULING] **BC-3.9.007 scope note (P17-005)**: S5 owns JSM echo clauses (EC-3.9.007-2, P2-3c deferred); platform-echo clause (EC-3.9.007-1) ships with S3. |

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
