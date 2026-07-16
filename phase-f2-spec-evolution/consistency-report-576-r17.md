---
report_id: consistency-report-576-r17
round: 17
spec_version: 1.3.46
bc_count: 657
holdout_count: 96
verdict: GAPS-FOUND
gap_count: 2
gap_severity_breakdown: "LOW×2"
prior_round: consistency-report-576-r16.md
date: 2026-07-16
adversary_pass: 7 (post-remediation)
validator: cv-f2-576-r17 (fresh context, no prior round memory)
---

# Consistency Report — SOH-ATTACHMENTS-1 F2 — Round 17

**Spec version:** 1.3.46 · **BCs:** 657 · **Holdouts:** 96 · **Verdict:** GAPS-FOUND (2 gaps: LOW×2)

---

## 1. Surface Coverage

All surfaces in the mandated surface set were read independently (fresh context):

| Surface | File | Status |
|---------|------|--------|
| BC-2.7 (Attachment Read) | `.factory/specs/prd/bc-2-issue-read.md` | Read |
| BC-3.5 (Comment CRUD — gate ECs) | `.factory/specs/prd/bc-3-issue-write.md` (§3.5) | Read |
| BC-3.9 (Attachment Write) | `.factory/specs/prd/bc-3-issue-write.md` (§3.9) | Read |
| BC-X.8 (Projects & Queues) | `.factory/specs/prd/cross-cutting.md` (§X.8) | Read |
| BC-INDEX | `.factory/specs/prd/BC-INDEX.md` | Read |
| CANONICAL-COUNTS | `.factory/specs/prd/CANONICAL-COUNTS.md` | Read |
| holdout-scenarios | `.factory/specs/prd/holdout-scenarios.md` | Read (Group 19, H-007 extension) |
| prd-delta | `.factory/phase-f2-spec-evolution/prd-delta-576.md` | Read (frontmatter) |
| prd-delta worklog | `.factory/phase-f2-spec-evolution/prd-delta-576-worklog.md` | Read (P6+R16+P7 sections) |
| spec-changelog | `.factory/spec-changelog.md` | Read |
| impact-boundary (all revisions) | `.factory/phase-f1-delta-analysis/impact-boundary-576.md` | Read (P6-annotated lines 408, 490-492) |

---

## 2. R16 Gap Closure

### GAP-R16-001 — WITHDRAWN residue in impact-boundary-576.md line 408: CONFIRMED CLOSED

**Status: CLOSED ✓**

**Quote — impact-boundary-576.md line 408 (current state with fix present):**
> `...is WITHDRAWN — P6-004 simplification. **[SUBSEQUENTLY REVISED — see R2.3/lines 490-492: BC-X.8.010 IS REWRITTEN TO REUSE, not withdrawn; BC survives as the resolution+self-heal reuse-contract; counts 657/96 unchanged]** `require_service_desk` already avoids the repeated paginated scan via the existing `ProjectMeta` cache.]**`

The "[SUBSEQUENTLY REVISED]" inline annotation is PRESENT ✓; it correctly points readers to lines 490-492 for the authoritative ruling; the WITHDRAWN sentence is preserved as an audit record (not deleted) ✓; the contradiction between line 408 and lines 490-492 is resolved.

**Note on worklog traceability:** The R16 Micro-Fix worklog entry records "1 finding, GAP-R16-002 only" — the impact-boundary fix for GAP-R16-001 is not logged there. The "[SUBSEQUENTLY REVISED]" annotation is present in the artifact but its fix round is unattributed in the worklog. This is a minor audit-trail gap; the spec artifact itself is correct.

### GAP-R16-002 — spec-changelog.md missing [1.3.46] entry: CONFIRMED CLOSED

**Status: CLOSED ✓**

**Quote — spec-changelog.md line 10:**
> `## [1.3.46] - 2026-07-16`

Entry present ✓; PATCH type noted (GAP-R15-001 terminology sync, EC-3.5.003-3 + EC-3.5.008-5) ✓.

**Quote — prd-delta-576.md frontmatter:**
> `spec_version_after: 1.3.46`

prd-delta frontmatter updated to 1.3.46 ✓.

---

## 3. P7 Keystone Closure Table

### P7-001 — AID-validation contract at ALL SEVEN surfaces with canonical invalid-AID string

**Overall Status: PRESENT WITH ONE MINOR INCONSISTENCY — see GAP-R17-001**

#### Verification of the seven surfaces

**Surface 1 — BC-3.9.008 (bc-3-issue-write.md line 3425):**
> `**AID validation (P7-001, CWE-88)**: each supplied `<AID>` is validated against `^[0-9]+$` BEFORE any HTTP call. A non-numeric or path-traversal-shaped AID (e.g., `"10001/../../issue/X"`) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; no HTTP requests are issued. This fires before both the single-AID confirmation gate (BC-3.9.015) and the bulk `--yes` check (BC-3.9.016).`

`^[0-9]+$` PRESENT ✓; BEFORE any HTTP call ✓; fires before gate AND --yes check (explicit ordering) ✓; canonical string `<VALUE>` form ✓

**Surface 2 — BC-3.9.013 (bc-3-issue-write.md line 3563, P7-001 correction paragraph):**
> `**AID validation (P7-001 correction — prior "does NOT validate" text reversed)**: `jr` validates each supplied `<AID>` against `^[0-9]+$` BEFORE any API call. An invalid AID (non-numeric, empty, or path-traversal-shaped such as `"10001/../../issue/X"`) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; zero HTTP calls issued. Precedent: EC-3.5.002-1 + `src/api/jira/issues.rs:~600` raw-interpolation precondition.`

"prior 'does NOT validate' text reversed" PRESENT as correction marker ✓; old text NOT present (confirmed: no surviving "does NOT validate" clause in spec bodies) ✓; `<VALUE>` form ✓

Also confirmed: EC-3.9.013-3 (bc-3 line 3569):
> `**EC-3.9.013-3** (non-numeric/invalid AID, e.g., `"10001/../../issue/X"`): exit 64; stderr `"invalid attachment id: '<VALUE>' (must be numeric)"`; zero HTTP calls issued (P7-001 CWE-88 correction — no server request made).`

EC-3.9.013-3 present ✓; `<VALUE>` form ✓; taxonomy table row (bc-3 line 3556) also present ✓

Also confirmed: BC-INDEX BC-3.9.013 row:
> `| BC-3.9.013 | Delete error taxonomy: **invalid AID (non-numeric) exit 64 zero HTTP** (P7-001 CWE-88 — prior "sent verbatim" text reversed); AID 404 exit 64 + Jira body surfaced (DEC-168); 403 exit 1; 401 exit 2; 5xx exit 1; network exit 1 | ...`

P7-001 citation in BC-INDEX ✓; "prior 'sent verbatim' text reversed" correction marker ✓

**Surface 3 — BC-3.9.015 (bc-3-issue-write.md line 3617):**
> `**AID validation fires before the gate (P7-001)**: `jr` validates `<AID>` against `^[0-9]+$` before any HTTP call, including the pre-prompt metadata GET (step 1 below). A non-numeric or path-traversal-shaped AID → exit 64; stderr: `"invalid attachment id: '<AID>' (must be numeric)"`; no HTTP calls issued; gate not presented.`

`^[0-9]+$` PRESENT ✓; fires before gate and pre-prompt metadata GET (explicit ordering) ✓; HOWEVER: canonical string uses `<AID>` not `<VALUE>` — **see GAP-R17-001**

BC-INDEX BC-3.9.015 row:
> `| BC-3.9.015 | ... **AID validated `^[0-9]+$` before gate and metadata-GET** (P7-001: invalid → exit 64, zero HTTP); ...; three-way branch: 'y'/'yes' → delete; empty-Enter → cancel exit 0; EOF (`Ok(0)`) or IO-error → `JrError::Interrupted` exit 130; mirrors BC-3.5.003/EC-3.5.003-3 (divergence note removed — P5-001 ruling) | ... (P5-001 correction; P7-001) |`

P7-001 citation in BC-INDEX ✓

**Surface 4 — BC-3.9.016 (bc-3-issue-write.md line 3655):**
> `**AID validation (P7-001, multi-AID form)**: on the multi-AID bulk form (2+ positional `<AID>` arguments), each AID is validated against `^[0-9]+$` BEFORE the `--yes` check and any API calls. Any invalid AID (non-numeric, path-traversal-shaped) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; no HTTP calls issued.`

`^[0-9]+$` PRESENT ✓; BEFORE the --yes check (explicit ordering) ✓; `<VALUE>` form ✓

BC-INDEX BC-3.9.016 row confirms P7-001 citation ✓

**Surface 5 — BC-3.9.020 path-b (bc-3-issue-write.md line 3802):**
> `**Multi-AID `--dry-run` metadata fan-out (path b)**: **AID validation fires first (P7-001)**: each supplied AID is validated against `^[0-9]+$` before any metadata fetch. An invalid AID (non-numeric, path-traversal-shaped) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; zero HTTP calls issued (even on dry-run — invalid input is rejected before any read-only GET).`

`^[0-9]+$` PRESENT ✓; "fires first" before dry-run fan-out (explicit ordering) ✓; "even on dry-run" explicit ✓; `<VALUE>` form ✓

BC-INDEX BC-3.9.020 row confirms P7-001 citation ✓

**Surface 6 — BC-2.7.007 (bc-2-issue-read.md line 715):**
> `**AID validation (P7-001, CWE-88)**: before issuing any HTTP request, `jr` validates `<AID>` against `^[0-9]+$`. A non-numeric or path-traversal-shaped AID (e.g., `"10001/../../issue/X"`) → exit 64; stderr: `"invalid attachment id: '<AID>' (must be numeric)"`; no HTTP calls issued. This fires before step 1 below.`

`^[0-9]+$` PRESENT ✓; fires before step 1 (explicit ordering) ✓; HOWEVER: canonical string uses `<AID>` not `<VALUE>` — **see GAP-R17-001**

BC-INDEX BC-2.7.007 row:
> `| BC-2.7.007 | Single-file download — **AID validated against `^[0-9]+$` before step 1** (P7-001: invalid → exit 64, zero HTTP); ...`

P7-001 citation in BC-INDEX ✓

**Surface 7 — BC-2.7.012 taxonomy row (bc-2-issue-read.md line 908):**
> `| Invalid `--id` AID (non-numeric, e.g. path-traversal) | 64 | `"invalid attachment id: '<AID>' (must be numeric)"` (no HTTP) |`

Invalid-AID row PRESENT in taxonomy table ✓; "(no HTTP)" annotation confirms zero-HTTP constraint ✓; HOWEVER: canonical string uses `<AID>` not `<VALUE>` — **see GAP-R17-001**

BC-INDEX BC-2.7.012 row:
> `| BC-2.7.012 | ... **invalid AID (non-numeric) → exit 64 zero HTTP** (P7-001 row added to taxonomy table); ...`

P7-001 citation in BC-INDEX ✓

#### H-007 malicious-AID assertion (holdout-scenarios.md line 107)

> `**Extended assertion (P7-001, CWE-88 — malicious-AID exit-64 zero-HTTP guard)**: On any attachment command that accepts a user-supplied `<AID>` positional argument (`attachment delete <AID>`, `attachment download <KEY> --id <AID>`), a path-traversal-shaped AID (e.g., `"10001/../../issue/FOO-1"`) or any non-numeric value (e.g., `"abc"`, `"../secret"`) → exit 64; stderr contains `"invalid attachment id: '...' (must be numeric)"`; **zero HTTP calls** issued. Assert with wiremock `expect(0)` on `GET /rest/api/3/attachment/...` and `DELETE /rest/api/3/attachment/...`. Validation fires before any gate, before the pre-prompt metadata GET, and before any streaming request — regardless of `--dry-run`, `--yes`, or `--no-input` flags.`

New malicious-AID assertion PRESENT ✓; wiremock `expect(0)` requirement PRESENT ✓; covers all 7 surfaces (confirmed in BC refs line: "BC-3.9.013 EC-3.9.013-3; BC-3.9.008; BC-3.9.015; BC-3.9.016; BC-3.9.020 path-b; BC-2.7.007; BC-2.7.012") ✓; uses `'...'` as partial-match pattern (intentional — test assertion, not literal string spec) ✓

Note: H-007 uses `'...'` (ellipsis) as a partial-match pattern, not `<VALUE>` or `<AID>`. This is appropriate for a holdout test assertion where the validator checks for a substring match rather than the exact interpolated string. Not a gap.

#### Interaction ordering — validation BEFORE gates, BEFORE --yes, BEFORE dry-run fan-outs

All 7 surfaces state validation fires BEFORE subsequent operations:

| Surface | Ordering Statement |
|---------|-------------------|
| BC-3.9.008 | "fires before both the single-AID confirmation gate (BC-3.9.015) and the bulk `--yes` check (BC-3.9.016)" |
| BC-3.9.013 | "BEFORE any API call" (taxonomy BC — no separate gate/--yes to precede; ordering implicit) |
| BC-3.9.015 | "before any HTTP call, including the pre-prompt metadata GET... gate not presented" |
| BC-3.9.016 | "BEFORE the `--yes` check and any API calls" |
| BC-3.9.020 path-b | "AID validation fires first... even on dry-run — invalid input is rejected before any read-only GET" |
| BC-2.7.007 | "before issuing any HTTP request... This fires before step 1 below" |
| BC-2.7.012 | "(no HTTP)" annotation in taxonomy table |

Ordering is CONSISTENT and EXPLICIT at 6/7 surfaces; the BC-2.7.012 taxonomy row expresses the constraint structurally (no HTTP column value) rather than as a prose ordering claim, which is appropriate for a taxonomy table. ✓

---

### P7-002 — BC-3.9.018 gate-suppression paragraph + EC-3.9.018-4 + EC-3.9.003-5 extended to both entry points

**Status: CLOSED ✓**

#### EC-3.9.003-5 extended to both entry points (bc-3-issue-write.md line 3315):
> `**EC-3.9.003-5** (invoked from BC-3.9.017 `--replace-existing` step 4, OR from BC-3.9.018 `--replace-existing` zero-match path): the confirmation gate defined in this BC is NOT re-presented. **Step-4 path (BC-3.9.017)**: the gate was resolved at BC-3.9.017 step 2 — if cancelled there, BC-3.9.003 is never reached; if passed, proceeding to step 4 implies the gate is satisfied. **Zero-match path (BC-3.9.018, P7-002)**: the gate was also resolved at BC-3.9.017 step 2 — it fires before any destructive call (upload POST included), even when no DELETEs are needed. In both cases: only the servicedeskapi wire steps (step 1: `attachTemporaryFile`; step 2: `post_request_attachment`) execute on this call path. Gate state: RESOLVED (do not prompt again). One gate per invocation, ever.`

Both entry points PRESENT ✓; Step-4 path (BC-3.9.017) PRESENT ✓; Zero-match path (BC-3.9.018, P7-002) PRESENT ✓; "One gate per invocation, ever." PRESENT ✓

#### BC-3.9.018 gate-suppression paragraph (bc-3-issue-write.md line 3742):
> `**Gate suppression on `--public` zero-match path (P7-002)**: when `--replace-existing --public` reaches the zero-match path, BC-3.9.017 step 2 (gate step) fires BEFORE the upload — even though no DELETEs are needed, the upload POST is a destructive call per BC-3.9.017's invariant ("no destructive API call may be issued while any applicable confirmation gate remains pending"). The gate resolves exactly once. When the upload then proceeds to BC-3.9.003 (JSM `--public` path), the gate MUST NOT re-fire — it was already resolved at BC-3.9.017 step 2. This extends EC-3.9.003-5's suppression key to the BC-3.9.018 entry point. **One gate per invocation, ever.**`

P7-002 marker PRESENT ✓; gate fires before upload on zero-match path (explicit) ✓; "MUST NOT re-fire" language PRESENT ✓; cross-reference to EC-3.9.003-5 PRESENT ✓; "One gate per invocation, ever." PRESENT ✓

#### EC-3.9.018-4 (bc-3-issue-write.md line 3747):
> `**EC-3.9.018-4** (zero-match `--public`, gate suppression): gate resolves at BC-3.9.017 step 2 (fires once before the upload, even with zero DELETEs pending); BC-3.9.003's gate MUST NOT re-fire at this entry point; upload proceeds per BC-3.9.003 wire steps only (EC-3.9.003-5 mechanism extended to this path).`

EC-3.9.018-4 PRESENT ✓; gate-suppression mechanism stated ✓; cross-reference to EC-3.9.003-5 PRESENT ✓

#### Gate-suppression coherence across three texts:

The P7-002 gate-suppression rule is stated three times consistently:

| Text | Location | "One gate per invocation, ever." present |
|------|----------|------------------------------------------|
| EC-3.9.003-5 | bc-3 line 3315 | ✓ |
| BC-3.9.017 step 4 gate-suppression note | bc-3 line 3705 | ✓ |
| BC-3.9.018 gate-suppression paragraph | bc-3 line 3742 | ✓ |

All three texts are mutually consistent; each states suppression fires at the BC-3.9.017 step-2 gate; each cross-references EC-3.9.003-5 or step 4. ✓

---

### P7-003 — BC-2.7.010 batch degenerate fallback `<sha1>_<aid>`, single bare `<aid>`, matching impact-boundary R3.10

**Status: CLOSED ✓**

#### BC-2.7.010 degenerate fallback body (bc-2-issue-read.md line 830):
> `**Degenerate-name fallback (R3.10 ruling)**: if `sanitize_attachment_filename` returns `None` or an empty string (rejects path-traversal, NUL bytes, etc.), the fallback depends on mode: **single-`--id` mode** → raw attachment `id` string (bare, no prefix — consistent with single-id bare naming); **batch mode (`--all`/`--newest N`)** → `<sha1-of-id>_<id>` (SHA-1 prefix of the id + raw id — consistent with the normal batch naming scheme, and zero special-cases in batch collision logic).`

Single-id degenerate → bare `<id>` (no prefix) PRESENT ✓; Batch degenerate → `<sha1-of-id>_<id>` PRESENT ✓; R3.10 ruling cited PRESENT ✓

#### BC-2.7.010 batch degenerate example (bc-2-issue-read.md line 842):
> `- `id="20003"`, `filename=".."` → sanitization returns `None` → fallback `<sha1("20003")>_20003` (batch degenerate: SHA-1 prefix + raw id, R3.10)`

Batch degenerate example showing `<sha1("20003")>_20003` form PRESENT ✓; R3.10 cited ✓

#### Single-id degenerate example (bc-2-issue-read.md line 837):
> `- `id="10042"`, `filename=".."` → sanitization returns `None` → fallback `10042``

Single-id degenerate example → bare numeric id (no prefix) PRESENT ✓

#### Impact-boundary R3.10 ruling (impact-boundary-576.md line 767):
> `**Degenerate-name fallback:** if the sanitized basename is empty (e.g., filename was entirely path-separators or control characters and nothing survives sanitization), fall back to the attachment ID as the filename (`<aid>` for single; `<sha1>_<aid>` for batch).`

R3.10 single: `<aid>` (bare) → BC-2.7.010 single: "raw attachment `id` string (bare, no prefix)" ✓ MATCHES
R3.10 batch: `<sha1>_<aid>` → BC-2.7.010 batch: "`<sha1-of-id>_<id>`" ✓ MATCHES

#### BC-INDEX BC-2.7.010 row:
> `| BC-2.7.010 | Default output filename: **single-`--id`** = bare sanitized basename (no SHA-1 prefix; peer-convention alignment — curl/gh pattern); **batch (`--all`/`--newest`)** = `<sha1-of-id>_<sanitized-basename>` ...; degenerate fallback (sanitization → None/empty): **single-id** = raw id (bare); **batch** = `<sha1>_<id>` (R3.10 ruling — batch stays uniformly prefixed, zero special-cases in collision logic); ... | ... (SOH-ATTACHMENTS-1 F2; P7-003) |`

Single-id degenerate fallback PRESENT in BC-INDEX ✓; Batch degenerate `<sha1>_<id>` PRESENT in BC-INDEX ✓; R3.10 ruling cited ✓; P7-003 citation PRESENT ✓

---

## 4. New Findings (Round 17)

### GAP-R17-001 — Canonical invalid-AID error string uses `<AID>` at 3 of 9 body occurrences vs worklog-canonical `<VALUE>` (LOW)

**Severity:** LOW
**Files:** `.factory/specs/prd/bc-3-issue-write.md`, `.factory/specs/prd/bc-2-issue-read.md`

**Finding:**

The P7-001 worklog entry specifies the canonical exit-64 string as:
> `"invalid attachment id: '<VALUE>' (must be numeric)"`

However, across the nine body-text occurrences of the canonical string (seven BC bodies + two table rows), three use `<AID>` as the placeholder rather than `<VALUE>`:

| Location | Placeholder | Assessment |
|----------|-------------|------------|
| BC-3.9.008 body (bc-3 line 3425) | `<VALUE>` | CONSISTENT ✓ |
| BC-3.9.013 taxonomy table (bc-3 line 3556) | `<VALUE>` | CONSISTENT ✓ |
| BC-3.9.013 correction paragraph (bc-3 line 3563) | `<VALUE>` | CONSISTENT ✓ |
| EC-3.9.013-3 (bc-3 line 3569) | `<VALUE>` | CONSISTENT ✓ |
| BC-3.9.015 body (bc-3 line 3617) | `<AID>` | **INCONSISTENT — outlier within bc-3** |
| BC-3.9.016 body (bc-3 line 3655) | `<VALUE>` | CONSISTENT ✓ |
| BC-3.9.020 path-b body (bc-3 line 3802) | `<VALUE>` | CONSISTENT ✓ |
| BC-2.7.007 body (bc-2 line 715) | `<AID>` | Systematic bc-2 usage |
| BC-2.7.012 taxonomy table (bc-2 line 908) | `<AID>` | Systematic bc-2 usage |

The bc-3.9.015 `<AID>` usage is the most actionable gap: it is an outlier within bc-3, where the established norm is `<VALUE>`. The two bc-2 surface uses of `<AID>` are systematic (bc-2 has no pre-P7 uses of `<VALUE>` for comparison), creating a bc-2 vs bc-3 convention split.

The holdout H-007 uses `'...'` as a partial-match pattern — this is intentional for a test assertion and is not a gap.

**Impact:** LOW. The behavioral contract is unambiguous: regardless of placeholder name, the runtime string substitutes the actual value the user supplied. An implementer reading any surface would write `format!("invalid attachment id: '{}' (must be numeric)", value)`. No semantic ambiguity exists. The gap is a documentation tidiness issue that violates the "ONE canonical invalid-AID string everywhere" requirement from P7-001.

**Fix:** In bc-3-issue-write.md, BC-3.9.015 body (line 3617): change `"invalid attachment id: '<AID>' (must be numeric)"` → `"invalid attachment id: '<VALUE>' (must be numeric)"` to match the in-file norm. For bc-2, either align to `<VALUE>` globally (2 occurrences: lines 715 and 908) or formally establish `<AID>` as the bc-2 convention and document the split. The simpler fix is global alignment to `<VALUE>` (3 changes total).

---

### GAP-R17-002 — P7 Fix Round behavioral changes not captured in a spec version bump (LOW)

**Severity:** LOW
**Files:** `.factory/spec-changelog.md`, `.factory/phase-f2-spec-evolution/prd-delta-576.md`, `.factory/specs/prd/bc-2-issue-read.md`

**Finding:**

The P7 Fix Round (2026-07-16) applied substantial behavioral changes to the spec — 7-surface CWE-88 AID validation, new EC-3.9.018-4, extended EC-3.9.003-5, extended H-007 — but the spec version was NOT bumped:

**Quote — spec-changelog.md (highest entry):**
> `## [1.3.46] - 2026-07-16`

No `[1.3.47]` entry exists for P7. The [1.3.46] entry covers only the GAP-R15-001 terminology sync (EC-3.5.003-3 / EC-3.5.008-5, R15 Micro-Fix — a smaller change).

**Quote — prd-delta-576.md frontmatter:**
> `spec_version_after: 1.3.46`

This reflects the pre-P7 state.

**Quote — bc-2-issue-read.md frontmatter:**
> `last_updated: 2026-07-15`

bc-2 was modified by P6 (P6-003, 2026-07-16) and P7 (P7-001 AID validation, P7-003 BC-2.7.010 degenerate fallback, 2026-07-16), but last_updated was not updated for either modification. The bc-3 last_updated (2026-07-16) is current from the R15 Micro-Fix but also covers P7 modifications incidentally (same date).

**Impact:** LOW. The behavioral specs are correct. The missing version entry means spec-changelog.md's highest version (1.3.46) does not correspond to the current spec state, and prd-delta-576.md reports a spec version that precedes P7 behavioral additions. This is the same pattern as GAP-R16-002 (R15 Micro-Fix not in changelog), which was fixed in the R16 Micro-Fix round.

**Fix:** (1) Add a `## [1.3.47] - 2026-07-16` MINOR entry to spec-changelog.md (MINOR because P7 added new CWE-88 behavioral contracts at 7 surfaces, not just a terminology sync). (2) Update prd-delta-576.md frontmatter `spec_version_after: 1.3.46` → `1.3.47`. (3) Update bc-2-issue-read.md frontmatter `last_updated: 2026-07-15` → `2026-07-16`.

---

## 5. Standard Check-Class Summary

| Check class | Result | Notes |
|-------------|--------|-------|
| BC count 657 across all surfaces | PASS ✓ | BC-INDEX `total_bcs: 657`; bc-3 `total_bcs: 140 / definitional_count: 111`; bc-2 `total_bcs: 106 / definitional_count: 64`; cross-cutting `total_bcs: 150 / definitional_count: 84`; prd-delta `bc_count_after: 657`; CANONICAL-COUNTS Sum 657 |
| Holdout count 96 across all surfaces | PASS ✓ | holdout-scenarios.md `total_holdouts: 96`; prd-delta `holdout_count_after: 96` |
| Old "does NOT validate" sentence gone (grep) | PASS ✓ | No surviving "does NOT validate" text in spec bodies; only occurrence is the P7-001 correction marker "prior 'does NOT validate' text reversed" at bc-3 line 3563 (not the stale text itself) |
| Old "sent verbatim" text gone | PASS ✓ | BC-3.9.013 "prior 'sent verbatim' text reversed" is the correction marker in BC-INDEX, not residue in the body; no "sent verbatim" claim in bc-3 taxonomy body |
| P7-001 present at BC-3.9.008 | PASS ✓ | `^[0-9]+$` before any HTTP call; fires before gate and --yes; `<VALUE>` form |
| P7-001 present at BC-3.9.013 | PASS ✓ | Correction paragraph + taxonomy table row + EC-3.9.013-3; `<VALUE>` form |
| P7-001 present at BC-3.9.015 | PASS (canonical string inconsistency) | `^[0-9]+$` before gate and pre-prompt GET; HOWEVER uses `<AID>` not `<VALUE>` — GAP-R17-001 |
| P7-001 present at BC-3.9.016 | PASS ✓ | `^[0-9]+$` BEFORE --yes check and API calls; `<VALUE>` form |
| P7-001 present at BC-3.9.020 path-b | PASS ✓ | `^[0-9]+$` fires first, even on dry-run; `<VALUE>` form |
| P7-001 present at BC-2.7.007 | PASS (canonical string inconsistency) | `^[0-9]+$` before step 1; HOWEVER uses `<AID>` not `<VALUE>` — GAP-R17-001 |
| P7-001 present at BC-2.7.012 taxonomy row | PASS (canonical string inconsistency) | Invalid-AID row in taxonomy table "(no HTTP)"; HOWEVER uses `<AID>` not `<VALUE>` — GAP-R17-001 |
| P7-001 canonical string uniqueness | **FAIL** | GAP-R17-001 — 3 of 9 body occurrences use `<AID>` vs worklog-canonical `<VALUE>`; BC-3.9.015 is the most actionable (within-file outlier) |
| P7-001 interaction ordering consistent | PASS ✓ | All 7 surfaces confirm validation fires before gates / --yes / dry-run fan-outs |
| P7-001 H-007 malicious-AID assertion | PASS ✓ | Line 107: extended assertion present; wiremock `expect(0)` on both GET and DELETE endpoints; 7-surface BC refs present; `'...'` partial-match appropriate |
| BC-INDEX rows for all 7 AID surfaces | PASS ✓ | All 7 rows confirmed with P7-001 citation and AID validation notation |
| P7-002 BC-3.9.018 gate-suppression paragraph | PASS ✓ | Line 3742: "Gate suppression on --public zero-match path (P7-002)" present; destructive-call invariant stated; "One gate per invocation, ever." present |
| P7-002 EC-3.9.018-4 | PASS ✓ | Line 3747: present; zero-match --public gate suppression; cross-reference to EC-3.9.003-5 |
| P7-002 EC-3.9.003-5 extended to both entry points | PASS ✓ | Line 3315: both step-4 (BC-3.9.017) and zero-match (BC-3.9.018, P7-002) paths explicitly stated |
| P7-002 gate-suppression 3-text coherence | PASS ✓ | EC-3.9.003-5, BC-3.9.017 step 4, BC-3.9.018 paragraph — all state "One gate per invocation, ever." consistently |
| P7-003 BC-2.7.010 single degenerate: bare `<aid>` | PASS ✓ | Line 837 example; line 830 "raw attachment id string (bare, no prefix)" |
| P7-003 BC-2.7.010 batch degenerate: `<sha1>_<aid>` | PASS ✓ | Line 842 example `<sha1("20003")>_20003 (batch degenerate: SHA-1 prefix + raw id, R3.10)` |
| P7-003 BC-2.7.010 matches impact-boundary R3.10 | PASS ✓ | R3.10 `<aid>` single / `<sha1>_<aid>` batch maps exactly to BC-2.7.010 body and BC-INDEX row |
| P7-003 BC-INDEX BC-2.7.010 row | PASS ✓ | Row updated: single-id bare / batch SHA-1-prefix / R3.10 degenerate fallback, P7-003 citation |
| GAP-R16-001 closure (impact-boundary WITHDRAWN residue) | PASS ✓ | "[SUBSEQUENTLY REVISED]" annotation at line 408 resolves contradiction with lines 490-492 |
| GAP-R16-002 closure (spec-changelog [1.3.46] entry) | PASS ✓ | [1.3.46] confirmed in spec-changelog.md; prd-delta spec_version_after: 1.3.46 |
| P7 changes in spec-changelog | **FAIL** | GAP-R17-002 — no [1.3.47] entry for P7 behavioral additions |
| prd-delta spec_version_after reflects P7 | **FAIL** | GAP-R17-002 — reads 1.3.46; should be 1.3.47 after P7 behavioral changes |
| bc-2 last_updated reflects P6+P7 modifications | **FAIL** | GAP-R17-002 — reads 2026-07-15; P6 (P6-003) and P7 both modified bc-2 on 2026-07-16 |
| Cache Types count at 7 (P6-004) | PASS ✓ | Inherited from R16 PASS; no P7 regression signals; CANONICAL-COUNTS at 7 |
| BC-3.9.003 step-1: get_or_fetch_project_meta reuse | PASS ✓ | Inherited from R16 PASS; no P7 regression signals |
| BC-X.8.010: reuse-contract (P7 minor fold-in) | PASS ✓ | P7 minor fold-in softened "no new reader/writer functions" to "implementer's choice at S5" — no new cache FILE; behavioral semantics unchanged |
| Four-gate mechanism coherence (EC-3.5.003-3/008-5/3.9.014/3.9.015-5) | PASS ✓ | Inherited from R16 PASS; all four gates use DEC-174 read_line Ok(0)/Err mechanism language |
| BC heading counts match CANONICAL-COUNTS | PASS ✓ | bc-3: 111, bc-2: 64, cross-cutting: 84 — all match |
| ADR-0017 in both ADR indices | PASS ✓ | Inherited from R16 PASS; no P7 regression signals |
| Security review verdict APPROVE | PASS ✓ | Inherited from R16 PASS; CONS-576-005 "RESOLVED (security-review-576.md verdict: APPROVE, status: final)" |
| Stale count residue (650/656/~26) in impact-boundary | PASS ✓ | Inherited from R16 PASS; P7 did not touch impact-boundary |
| spec-changelog highest entry [1.3.46] is current | **FAIL** | GAP-R17-002 — P7 post-dates [1.3.46] without a new version entry |

---

## 6. Summary

**Verdict: GAPS-FOUND — 2 gaps (LOW×2); spec is implementation-ready.**

All three P7 keystones are verifiably present in the normative spec documents with quote-based confirmation:

- **P7-001** (AID validation at 7 surfaces): All seven surfaces have `^[0-9]+$` validation language, BEFORE ordering, and BC-INDEX rows with P7-001 citations. The old "does NOT validate" and "sent verbatim" stances are replaced by correction markers and new content. H-007's malicious-AID assertion is present with wiremock `expect(0)` enforcement. ONE minor inconsistency found: the canonical string placeholder uses `<AID>` in 3 of 9 occurrences (BC-3.9.015, BC-2.7.007, BC-2.7.012) vs the worklog-canonical `<VALUE>` — see GAP-R17-001.

- **P7-002** (BC-3.9.018 gate suppression): All three texts confirmed: BC-3.9.018 gate-suppression paragraph, EC-3.9.018-4, and EC-3.9.003-5 extended to both entry points (BC-3.9.017 step-4 path AND BC-3.9.018 zero-match path). "One gate per invocation, ever." stated in all three texts. The coherent three-text rule is:
  - Gate resolves at BC-3.9.017 step 2 (fires once before any destructive call)
  - BC-3.9.003's gate MUST NOT re-fire on step-4 path (BC-3.9.017) or zero-match path (BC-3.9.018)
  - EC-3.9.003-5 is the suppression mechanism; EC-3.9.018-4 applies it to the zero-match entry point

- **P7-003** (BC-2.7.010 degenerate fallback): single-`--id` degenerate → bare `<id>` (no prefix); batch degenerate → `<sha1-of-id>_<id>` (prefix + raw id, R3.10). Both forms match impact-boundary R3.10 exactly. BC-INDEX row updated with P7-003 citation.

Both R16 gaps are confirmed closed: GAP-R16-001 (WITHDRAWN residue in impact-boundary) resolved by the "[SUBSEQUENTLY REVISED]" annotation at line 408; GAP-R16-002 (spec-changelog [1.3.46] entry) resolved by the [1.3.46] entry and prd-delta spec_version_after: 1.3.46.

Two new gaps:

**GAP-R17-001 (LOW):** The P7-001 canonical invalid-AID error string placeholder is `<VALUE>` at 6 of 9 body occurrences but `<AID>` at 3 (BC-3.9.015 in bc-3 at line 3617 — a within-file outlier; BC-2.7.007 at line 715 and BC-2.7.012 at line 908 — systematic bc-2 usage). The behavioral contract is unambiguous (both placeholders substitute the actual user-supplied value); the gap is documentation tidiness violating "ONE canonical invalid-AID string everywhere." Fix: change BC-3.9.015 line 3617 `<AID>` → `<VALUE>` (mandatory — within-file outlier); optionally align bc-2 lines 715 and 908 to `<VALUE>` globally (3 changes total, all in body text only).

**GAP-R17-002 (LOW):** P7 Fix Round behavioral changes are not captured in a spec version bump. spec-changelog.md highest entry is [1.3.46]; no [1.3.47] entry exists for P7's CWE-88 additions. prd-delta spec_version_after reads 1.3.46. bc-2 last_updated reads 2026-07-15 despite P6 and P7 modifications on 2026-07-16. Fix: add [1.3.47] MINOR entry to spec-changelog.md; update prd-delta spec_version_after → 1.3.47; update bc-2 last_updated → 2026-07-16.

Both gaps are documentation/metadata issues with no effect on BC behavioral semantics or implementation readiness.

---

*Report generated: 2026-07-16 | Validator: cv-f2-576-r17 (fresh context) | No fixes applied — report only.*
