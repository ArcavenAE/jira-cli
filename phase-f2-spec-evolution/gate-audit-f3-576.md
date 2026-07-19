---
audit_id: GATE-AUDIT-F3-576
bundle: SOH-ATTACHMENTS-1
spec_version: 1.3.93
auditor: pre-gate-consistency-agent (fresh-context)
audit_date: 2026-07-18
verdict: GATE-READY
guard_exit_codes:
  check_spec_counts: 0
  check_bc_cumulative_counts: 0
findings:
  - id: AUDIT-576-001
    severity: INFO
    title: Input-hash verification methodology is opaque
  - id: AUDIT-576-002
    severity: LOW
    title: Two PR-merge probe gates require live Jira access (not spec-dischargeable)
  - id: AUDIT-576-003
    severity: LOW
    title: S3 interim-rejection test must be removed by S5 (sequencing obligation)
  - id: AUDIT-576-004
    severity: LOW
    title: sha1 crate direct dependency not yet in Cargo.toml (cargo-deny unknown)
  - id: AUDIT-576-005
    severity: INFO
    title: attachments.rs combined LOC at S3+S4+S5 completion may breach ADR-0012 shard threshold
---

# Pre-Gate Consistency Audit: SOH-ATTACHMENTS-1 (F3)

Spec version: v1.3.93 (frozen post-cosmetics fold).  
Adversary convergence: STRICT-CLEAN × 3 at passes 75/76/77 (74 fix rounds total).  
Stories: S-576-1 v1.18, S-576-2 v1.30, S-576-3 v1.38, S-576-4 v1.27, S-576-5 v1.31.

---

## 1. Version / Hash Coherence

### 1.1 Spec-changelog top entry

Top entry in `.factory/spec-changelog.md` is `## [1.3.93] - 2026-07-19`. Type: PATCH.  
Summary: "Pre-gate cosmetics fold for SOH-ATTACHMENTS-1" — error-taxonomy.md, prd-delta-576.md, ADR-0017 touched; BC-INDEX unchanged.  
**CONFIRMED.**

### 1.2 prd-delta `spec_version_after`

`spec_version_after: 1.3.93` in `.factory/phase-f2-spec-evolution/prd-delta-576.md` frontmatter.  
**CONFIRMED.**

### 1.3 BC-INDEX version

`index_version: v6.36` in `.factory/specs/prd/BC-INDEX.md` frontmatter.  
`last_updated: 2026-07-18` — last substantive change was adversary pass-11 micro-round (BC-X.8.010 row; spec v1.3.86). No BC-INDEX changes were made in rounds 42–77; the BC-INDEX was correctly left at v6.36 through those rounds.  
**CONFIRMED: v6.36 is current and correct.**

### 1.4 Story input-hashes

STORY-INDEX `last_updated` documents the hash refresh from old to current values:

| Story | Old hash | Current hash |
|---|---|---|
| S-576-1 | 7e3a22e | 5c14ae6 |
| S-576-2 | 7e3a22e | 5c14ae6 |
| S-576-3 | 7480c29 | 528bf23 |
| S-576-4 | 42d5a3c | 889765b |
| S-576-5 | 6268499 | 3fe188d |

S1 and S2 sharing the same hash is structurally consistent (they reference the same input-file set). All five story files show changelog entries with "Pre-gate hash refresh @ v1.3.93 — no content change."

**Verification methodology note (AUDIT-576-001):** The hash values are not reproducible by standard SHA-1/SHA-256 of concatenated file contents, or by `git hash-object`. The hash methodology is internal to the story-writer agent. The STORY-INDEX narrative provides the sole corroborating record of old→new values. This is informational — no spec defect, but a human approver cannot independently recompute the hashes.

### 1.5 BC-INDEX bc-3 rows vs v1.3.88 claim

Spec-changelog v1.3.88 changed BC-3.9.012 and BC-3.9.013 error-taxonomy tables (401/network cells, corrected from stale backtick/colon forms to loose-substring assertions with full literals cited in parentheticals). The changelog states: "BC-INDEX rows verified to not quote stale strings — no index changes."

Spot-check confirmed: BC-INDEX rows for BC-3.9.012 and BC-3.9.013 use exit-code notation only ("401 exit 2; 5xx exit 1; network exit 1") — they do NOT quote the full message strings. The v1.3.88 no-BC-INDEX-change claim is **VERIFIED CORRECT.**

---

## 2. Guard Script Exit Codes

```
$ bash scripts/check-spec-counts.sh
EXIT: 0

$ bash scripts/check-bc-cumulative-counts.sh
EXIT: 0   ("657 total across 8 files")
```

Both guards pass. BC count 657 (624 + 33 new), holdout count 100 (88 + 12 new), VP count 35.

---

## 3. Perimeter Completeness

### 3.1 BC coverage

All 33 new BCs are accounted for:

- BC-2.7.001–006 → S1 (attachment list)
- BC-2.7.007–012 → S2 (attachment download)
- BC-3.9.001–002, 009, 012, 014, 017–018, 020 (path-c) → S3 (upload platform)
- BC-3.9.008, 010, 013, 015–016, 019, 020 (delete paths) → S4 (delete)
- BC-3.9.003–007, 011, 020 (visibility-annotation clause), BC-X.8.010 → S5 (JSM visibility)

BC-3.9.020 spans S3/S4/S5 with clause-scoped ownership (see Check 4). No BC in the prd-delta enumeration table is orphaned.  
**COMPLETE.**

### 3.2 Holdout anchors

Group 19 (H-NEW-ATTACHMENT-001–012):

| Holdout | Story |
|---|---|
| H-NEW-ATTACHMENT-001 | S1 |
| H-NEW-ATTACHMENT-002/003/007 | S2 |
| H-NEW-ATTACHMENT-004/010 | S3 |
| H-NEW-ATTACHMENT-005/006/012 | S4 |
| H-NEW-ATTACHMENT-008/009/011 | S5 |

All 12 holdout anchors are present across the 5 stories.  
**COMPLETE.**

### 3.3 VP distribution

| VP | Story | Description |
|---|---|---|
| VP-576-001 | S2 | proptest for `sanitize_attachment_filename` |
| VP-576-002 | S4 | delete gate confirm/cancel variants |
| VP-576-003 | S3 | DELETE-before-POST ordering invariant |
| VP-576-004 | S1 (list half) + S3 (full cross-path) | curated JSON shape list + upload cross-path |
| VP-576-005 | S5 | combined-gate single-prompt pin |

All 5 VPs (VP-576-001 through VP-576-005) are distributed. No VP is orphaned.  
**COMPLETE.**

### 3.4 Probe gates

Both deferred probe gates are present:

- **BC-2.7.001 completeness probe** (S1 AC-011 item 5): "PRE-DELIVERY GATE — implementer must verify `fields.attachment` is non-paginated via `GET /rest/api/3/issue/{key}?fields=attachment` before PR merge." Tracked in S1 frontmatter `assumption_validations: ["BC-2.7.001:fields-attachment-completeness-probe"]`.
- **P2-3c deferred probe** (S5 obligation): "implementer must live-capture servicedeskapi response schema and update BC-3.9.007/BC-3.9.011 before PR merge." Explicitly called out in S5 AC section and STORY-INDEX row.

Both are correctly scoped as implementation-time PR-merge gates, not pre-gate spec obligations.  
**PRESENT AND CORRECTLY SCOPED.**

### 3.5 PRE-F4-UNICODE pipeline obligation

`PRE-F4-UNICODE-DISPLAY-SANITIZATION` obligation note is present in S3 and S4 (noting that Unicode bidi-control sanitization is a pipeline-level obligation for a future F4 pass, NOT a delivery gate for this bundle). The display-sanitization CWE-116 requirement (ASCII 0x00–0x1F/0x7F) is fully addressed within this bundle by `display_sanitize_filename` (BC-2.7.011, earliest consumer S1).  
**PRESENT AND CORRECTLY SCOPED.**

### 3.6 Delivery obligations (a)–(f) per story

prd-delta Scope table has rows for all 5 stories, each with labeled delivery obligations per the GAP-AUDIT-576-001 ruling (§§3.1/3.3/3.4). S1 obligations include README, CHANGELOG, e2e-surface-guard SURFACE entries, json-output-shapes.md rows, CLAUDE.md src-tree amendment, and `.cargo/mutants.toml` examine_globs entries — the add-at-creation precedent is explicitly documented. S2–S5 each have scoped delivery obligations noting mid-bundle CHANGELOG scoping (P3-018/P4-002/P5-006: no story advertises unshipped subcommands from a downstream story).  
**COMPLETE.**

---

## 4. Cross-Artifact Coherence

### 4.1 EC-3.9.020-7/8 clause-scoped ownership

BC-3.9.020 THREE-CATEGORY DRY-RUN TAXONOMY:
- **EC-3.9.020-7** (confirmation gates suppressed by `--dry-run`): realized in S3 AC-008. BC-INDEX row confirms "S3 (path-c body + EC-3.9.020-7 gate-suppression/AC-008)".
- **EC-3.9.020-8** (eligibility guard `--public` on non-JSM NOT suppressed by `--dry-run`): realized in S5 (because `--public` is S5-only). BC-INDEX row confirms "S5 (EC-3.9.020-7 visibility-annotation clause + EC-3.9.020-8)".

Story tables, prd-delta BC enumeration, and BC-INDEX row are mutually consistent.  
**COHERENT.**

### 4.2 ADR-0017 amendments

ADR-0017 covers: reqwest `stream` feature (S2), reqwest `multipart` feature + `tokio-util ^0.7 io-util` (S3), sha1 crate (S2, new direct dep). All 5 stories carry `adr_refs: ["ADR-0017"]`. The v1.3.93 cosmetics fold touched ADR-0017 (command name + attachment ID type clarification + amendment note). The file structure tables in all stories are consistent with ADR-0017.  
**COHERENT.**

### 4.3 Dependency graph evolution

Original DEC-184 plan (v1.3.81): "S3→S1, S5→S3".  
Final actual deps: S2/S3/S4←S1, S5←{S3,S4}.

Evolution documented:
- S2 gaining depends_on S-576-1: documented in S2 changelog P1-011 fix round.
- S4 gaining depends_on S-576-1: also documented in early adversary passes (S4 needs S1's `list_attachments`/`filter_attachments_older_than` plumbing).
- S5 gaining depends_on S-576-4: documented in S5 changelog P4-004 fix round — "S-576-5 EJ teardown deletes uploaded attachment via `jr issue attachment delete` — S-576-4 deliverable — so S-576-5 must depend on S-576-4."

STORY-INDEX rows confirm all five dep relationships. No standing artifact contradicts the final dep graph.  
**COHERENT AND DOCUMENTED.**

---

## 5. Convergence-Record Sanity

### 5.1 STORY-INDEX `last_updated`

`last_updated: "2026-07-18 (Pre-gate hash refresh @ v1.3.93: all 5 stories input-hashes refreshed — S-576-1/2: 7e3a22e→5c14ae6; S-576-3: 7480c29→528bf23; S-576-4: 42d5a3c→889765b; S-576-5: 6268499→3fe188d. S-576-1 v1.17→v1.18, S-576-2 v1.29→v1.30, S-576-3 v1.37→v1.38, S-576-4 v1.26→v1.27, S-576-5 v1.30→v1.31. Prior: pre-gate fold stale narrative count fix.)"`

This correctly describes the final state of the spec-freeze and hash refresh.  
**CURRENT.**

### 5.2 Story frontmatter status

All 5 stories have `status: draft` — the correct template value for F3 pre-implementation stories (not yet delivered, not stale "in-progress"). No story has been incorrectly stamped as `approved` or `delivered`.  
**CORRECT.**

---

## 6. Readiness Gaps — What the Adversarial Loop Cannot Catch

### AUDIT-576-001 (INFO) — Input-hash verification opacity

The factory-internal input-hash values (5c14ae6, 528bf23, 889765b, 3fe188d) are not reproducible by standard SHA-1, SHA-256, or git-hash-object on the current files. An independent auditor cannot cryptographically confirm that the input-spec files are exactly at the v1.3.93-frozen state. Confidence derives entirely from STORY-INDEX narrative corroboration. Not a spec defect; not a blocker.

### AUDIT-576-002 (LOW) — Two PR-merge probe gates require live Jira access

The spec correctly defers two obligations to implementation time, but a human approver should know these gates are NOT dischargeable from spec artifacts alone:

1. **BC-2.7.001 completeness probe** (S1): blocks S1 PR merge. The implementer must issue `GET /rest/api/3/issue/{key}?fields=attachment` against a live Jira Cloud instance and confirm the `fields.attachment` object is non-paginated (returns all attachments in one response). If Atlassian has introduced pagination since the spec was authored, BC-2.7.001 would need revision before S1 merges.

2. **P2-3c deferred probe** (S5): blocks S5 PR merge. The implementer must live-capture the servicedeskapi `POST /rest/servicedeskapi/request/{key}/attachment` response schema against the EJ test project and update BC-3.9.007/BC-3.9.011 with the confirmed shape. The current BCs are marked INCONCLUSIVE pending this capture.

Neither gate is a spec defect; both are correctly flagged. Human approver should ensure the implementing engineer has live EJ access before starting S5.

### AUDIT-576-003 (LOW) — S3 interim-rejection test must be removed by S5

S3 AC-017 ships a temporary test `test_bc_3_9_001_public_internal_interim_rejection_exits_64` that asserts `--public`/`--internal` on upload exits 64 (because S5 hasn't wired those flags yet). S5 carries an explicit obligation to remove this test. If S5 is ever merged without removing it, the test will conflict with S5's wired `--public` pathway. This is correctly specified but represents a cross-PR surgical edit dependency that must survive branch/review handoff — a human process risk, not a spec gap.

### AUDIT-576-004 (LOW) — sha1 crate not yet in Cargo.toml; cargo-deny outcome unknown

S2 (BC-2.7.010) introduces `sha1` as a new direct dependency for computing `SHA-1(attachment-id)` as the default output filename prefix. `sha1` is not in the current `Cargo.toml`. First compile of S2 will add it. `cargo deny check` has not yet evaluated it. The `sha1` crate (legacy) may trigger an advisory for non-cryptographic-use context, though use here is keyed on attachment IDs, not passwords — this is NOT a security issue, but `deny.toml` may require an `allow` entry. Implementer should check `cargo deny check` output when adding the dep.

### AUDIT-576-005 (INFO) — attachments.rs combined LOC may breach ADR-0012 shard threshold

S1 creates `src/cli/issue/attachments.rs`. S3, S4, and S5 all add to this same file. At bundle completion, the combined attachment handler module may exceed the ADR-0012 1,000-LOC shard candidate threshold. Known deviation class per ADR-0012 (documented-as-is precedent exists for `edit.rs` at 2,067 LOC and `workflow.rs` at ~1,277 LOC). Not a pre-gate blocker; mention in the S5 story review if LOC is approaching 1,500+.

---

## Summary

| Check | Result |
|---|---|
| Version / hash coherence | PASS (hash methodology opaque but corroborated by STORY-INDEX narrative) |
| Guard scripts | PASS (both EXIT 0) |
| Perimeter completeness — BCs | PASS (33/33 covered) |
| Perimeter completeness — holdouts | PASS (12/12 anchored) |
| Perimeter completeness — VPs | PASS (5/5 distributed) |
| Perimeter completeness — probe gates | PASS (both present, correctly scoped as PR-merge gates) |
| Perimeter completeness — delivery obligations | PASS (all 5 stories have (a)–(f) rows) |
| Cross-artifact coherence — EC-3.9.020-7/8 | PASS (clause split consistent across story/prd-delta/BC-INDEX) |
| Cross-artifact coherence — ADR-0017 | PASS (all stories carry adr_refs; content consistent) |
| Cross-artifact coherence — dep-graph evolution | PASS (P1-011/P4-004 change records present; no contradiction) |
| Convergence-record sanity | PASS (STORY-INDEX current; all stories status: draft) |

**VERDICT: GATE-READY**

No blocking or medium-severity findings. Five LOW/INFO findings are documented above — all represent known implementation-time risks or informational observations, not spec defects. The bundle is ready for human gate approval.
