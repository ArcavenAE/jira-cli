---
round: r43
spec_version_checked: 1.3.80
prev_spec_version: 1.3.79
fix_round: SEC-576-V2-ROUND
date: 2026-07-17
verdict: GAPS-FOUND
medium_gaps: 0
low_gaps: 2
info_findings_new: 2
info_findings_resolved: 0
---

# Consistency Validation Report — Round 43 (cv-576-r43)

**Feature:** SOH-ATTACHMENTS-1 (issues #576 + #585)
**Spec version checked:** v1.3.80 (immediately after SEC-576-v2 security fix round)
**Prior spec version:** v1.3.79
**Date:** 2026-07-17
**Verdict:** GAPS-FOUND — 2 LOW gaps, 2 INFO findings

---

## 1. Scope

This is the F2-PIECEWISE-PROTOCOL consistency check for the SEC-576-V2-ROUND (v1.3.79→v1.3.80).
F2 gate was APPROVED (DEC-184). Four findings from `security-review-576-v2.md` were applied:

- **SEC-576-009** (LOW, CWE-22): `?redirect=false` prohibition promoted from Trace field to
  BC-2.7.007 step 2 body clause.
- **SEC-576-010** (INFO): EC-2.7.007-12 added — single-id overwrite-refuse pre-flight numbered EC.
- **SEC-576-008** (INFO): BC-2.7.010 server-ID trust assumption note for batch-mode IDs.
- **SEC-576-011** (MEDIUM, CWE-116): BC-2.7.011 display-sanitization primary clause; cross-references
  added to BC-2.7.008, BC-2.7.010, BC-3.9.015 step 1, BC-3.9.017 step 2.

Files examined:
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-2-issue-read.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/bc-3-issue-write.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/prd-delta-576.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/spec-changelog.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/security-review-576-v2.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/BC-INDEX.md`

Protocol: verbatim-verification at claim time, double-insertion sweep (grep counts), echo-breaker
audit per finding, taxonomy classification check, keystone coherence, cross-reference symmetry,
version-bump completeness, S2/S4 allocation coherence check.

---

## 2. Check 1 — Verbatim Remediation Verification (all 4 findings)

### 2.1 SEC-576-009 (LOW, CWE-22) — `?redirect=false` prohibition in BC-2.7.007 step 2

**Requirement (finding):** "Add to BC-2.7.007 step 2 (or as a new EC): The content URL MUST be
`GET /rest/api/3/attachment/content/{id}` with no additional query parameters. The `?redirect=false`
parameter (JRACLOUD-97046) MUST NOT be appended — it changes the redirect behavior and would bypass
the CDN redirect that EC-2.7.007-3's credential-stripping test validates."

**Verbatim at bc-2-issue-read.md line 734 (step 2):**
> `**`?redirect=false` is prohibited on this endpoint (JRACLOUD-97046, SEC-576-009)**: The content
> URL MUST be issued with no additional query parameters — appending `?redirect=false` changes the
> server's redirect behavior and invalidates the credential-stripping invariant established by
> EC-2.7.007-3. The download MUST follow Jira's CDN redirect via reqwest's default redirect policy;
> no custom redirect policy is permitted on this endpoint.`

**Assessment:** SATISFIES the finding. The clause is in the step 2 wire path body (not only the
Trace field), cites JRACLOUD-97046 and SEC-576-009, explains the redirect-behavior consequence, and
ties the prohibition to the EC-2.7.007-3 credential-stripping invariant. **PASS.**

Trace field (line 780) also updated with `v1.3.80 — SEC-576-009 (CWE-22: `?redirect=false`
prohibition promoted from CRITICAL note in "Redirect following" paragraph to explicit body clause
in step 2 wire path)`. **PASS.**

---

### 2.2 SEC-576-010 (INFO) — EC-2.7.007-12 single-id overwrite-refuse pre-flight

**Requirement (finding):** "Add EC-2.7.007-12 to BC-2.7.007 defining: (1) Exit code (suggest
exit 64), (2) Error message (e.g., `File already exists: <path>. Use --force to overwrite.`),
(3) Scope: applies when `--out <PATH>` targets an existing regular file without `--force`,
(4) `--force` semantics: silently overwrites (mirrors BC-2.7.008 batch path)."

**Verbatim at bc-2-issue-read.md line 774:**
> `**EC-2.7.007-12** (single-`--id` overwrite-refuse pre-flight — `--out <PATH>` targets an existing
> regular file without `--force` — SEC-576-010): When `--out <PATH>` is supplied and the resolved
> path already exists as a regular file and `--force` is absent, `jr` exits 64 before any download:
> `"File already exists: <path>. Use --force to overwrite."` Checked pre-download in the same
> pre-flight family as EC-2.7.007-6 (parent-exists) and EC-2.7.007-11 (is-directory), firing before
> the step-1 metadata GET per P32-001 ordering (fail cheap/offline first). `--force` bypasses this
> check and overwrites the existing file silently upon download completion — mirrors the batch path
> `--force` semantics in BC-2.7.008. **Stderr-clause taxonomy (§2.7 taxonomy, P25/P30)**: this is
> an ERROR exit (exit 64), not a hint; JSON mode: this check fires pre-HTTP and exits 64 before any
> output is produced — no manifest envelope is emitted (consistent with EC-2.7.007-6 and
> EC-2.7.007-11 behavior).`

**Assessment:** Satisfies all four items: exit 64 ✓, exact error message ✓, scope (`--out <PATH>`
+ existing regular file + no `--force`) ✓, `--force` silently overwrites (mirrors BC-2.7.008
batch path) ✓. Pre-HTTP ordering per P32-001 is also present, which is a strengthening beyond
the finding's requirements. Taxonomy classification as ERROR/exit-64 is correct (see Check 4).
**PASS.**

---

### 2.3 SEC-576-008 (INFO) — BC-2.7.010 server-ID trust assumption note

**Requirement (finding):** Add a note clarifying that the "always numeric" invariant for
server-supplied batch IDs is a trust assumption about the Jira Cloud API, that a rogue server
is outside the threat model, and that implementers MAY apply `^[0-9]+$` validation as
defense-in-depth.

**Verbatim at bc-2-issue-read.md lines 870–871:**
> `**Trust assumption for server-supplied IDs in batch mode (SEC-576-008, INFO)**: the assertion
> that `fields.attachment[].id` values are numeric-only rests on the behavioral invariant of the
> legitimate Jira Cloud API. For single-`--id` mode the numeric invariant holds by construction —
> the user-supplied AID is validated against `^[0-9]+$` before any HTTP call (BC-2.7.007 AID
> validation, CWE-88). For batch mode (`--all`/`--newest N`) the IDs originate from server API
> responses and carry no client-side `^[0-9]+$` validation — the spec accepts this on the basis
> that a legitimate Jira server always returns numeric attachment IDs. A compromised or rogue server
> returning non-numeric IDs in batch responses is outside the stated threat model for this check.
> Implementers MAY apply `^[0-9]+$` validation to server-supplied batch IDs before using them in
> the degenerate-fallback naming path as additional defense-in-depth.`

**Assessment:** Satisfies the finding. Explains both modes, draws the trust-boundary line at "a
legitimate Jira server", explicitly states the rogue-server threat is outside the threat model, and
includes the MAY defense-in-depth note. BC-2.7.010 Trace updated with `v1.3.80 — SEC-576-008`.
**PASS.**

---

### 2.4 SEC-576-011 (MEDIUM, CWE-116) — display-sanitization primary clause in BC-2.7.011

**Requirement (finding):** Add a new BC-2.7.011 note or subsection mandating that all ASCII
control characters 0x00–0x1F and 0x7F in server-supplied filenames MUST be replaced with `?`
before writing to any TTY output. Distinct from disk-write path. Cross-reference from BC-3.9.015,
BC-3.9.017, BC-2.7.008, BC-2.7.010.

**Primary clause at bc-2-issue-read.md line 931 (BC-2.7.011):**
> `**Display sanitization for terminal output (SEC-576-011 — CWE-116)**: When any server-supplied
> attachment `filename` value is written to a TTY (confirmation prompts, collision-skip warnings,
> degenerate-name warnings, table cells, or any other human-readable stderr/stdout) — distinct from
> the disk-write path governed by `sanitize_attachment_filename` above — ALL ASCII control characters
> in the byte range 0x00–0x1F and 0x7F MUST be replaced with `?` before writing.`

**Assessment:** Satisfies the finding. Control-character range 0x00–0x1F and 0x7F matches the
requirement verbatim. Display-only / RAW-in-JSON/disk/API distinction is stated. `--no-color`
exclusion noted. `display_sanitize_filename` helper pattern prescribed. Taxonomy classification
correct (see Check 4). Earliest-consumer note present (S2). Cross-references in clause and in
individual BCs (see Check 6). **PASS.**

---

## 3. Check 2 — ECHO-BREAKER AUDIT

All newly-authored sentences examined. Grounding:

| Sentence group | Grounding |
|----------------|-----------|
| SEC-576-009 step-2 clause (`?redirect=false` → invalidates EC-2.7.007-3) | EC-2.7.007-3 (SEC-576-003 resolution, licensed BC clause); JRACLOUD-97046 (cited in Trace); "The download MUST follow Jira's CDN redirect via reqwest's default redirect policy" repeats Redirect following paragraph, not the security review text |
| EC-2.7.007-12 exit message (`"File already exists: <path>. Use --force to overwrite."`) | BC-2.7.007 Overwrite behavior paragraph (line 744): same wording pre-existed; EC-2.7.007-12 promotes it to a numbered EC |
| EC-2.7.007-12 mirrors batch path `--force` semantics | BC-2.7.008 Overwrite behavior paragraph (explicit cross-reference) |
| EC-2.7.007-12 taxonomy classification as ERROR/exit-64, no manifest envelope | EC-2.7.007-6 and EC-2.7.007-11 pattern (pre-HTTP exit 64, no output); §2.7 taxonomy (P25/P30) |
| SEC-576-008 batch-mode trust assumption: "legitimate Jira server always returns numeric IDs" | BC-2.7.007 AID validation paragraph (CWE-88 `^[0-9]+$`); R3.10 fallback naming rule in BC-2.7.010 |
| SEC-576-011 primary clause: "display-only; RAW value continues for disk writes, JSON output, API calls" | P27-001 (RAW/path keystone, EC-2.7.007-7 / EC-2.7.008-6 `filename` semantics); BC-2.7.011 disk-write pipeline (pre-existing) |
| "Earliest consumer: S2; S4 story-writers must allocate display-sanitization at confirmation prompt call sites per DEC-184 R3.13" | DEC-184 R3.13 (earliest-consumer story allocation principle); story S2 = attachment download (BC-2.7.007..012); story S4 = attachment delete (BC-3.9.015) |
| Display-sanitization cross-refs in BC-2.7.008 / BC-2.7.010 / BC-3.9.015 / BC-3.9.017 | Each is a derivative of the primary BC-2.7.011 clause — not re-derived from the security review text; each cites "per BC-2.7.011 display-sanitization requirement" |

**Assessment:** No newly-authored sentence is merely echoed from the security review text. All are
grounded in: (a) pre-existing BC-licensing clauses; (b) external research artifacts cited in the
Trace field (JRACLOUD-97046, GHSA-9857-6MW7-FQ2M); or (c) standing process decisions (DEC-184
R3.13, §2.7 taxonomy per P25/P30). **ECHO-BREAKER PASS.**

---

## 4. Check 3 — Double-Insertion Sweep

Grep-count verification on edited regions:

| Pattern | File | Count | Expected |
|---------|------|-------|----------|
| `redirect=false.*prohibited.*endpoint` | bc-2-issue-read.md | 1 | 1 |
| `EC-2.7.007-12` | bc-2-issue-read.md | 3 | 3 (frontmatter trace + body EC + Trace field) |
| `Display sanitization for terminal output` | bc-2-issue-read.md | 1 | 1 |
| `Display-sanitization cross-reference.*SEC-576-011` | bc-2-issue-read.md | 2 | 2 (BC-2.7.008 + BC-2.7.010) |
| `SEC-576-011` | bc-3-issue-write.md | 5 | 5 (frontmatter trace + BC-3.9.015 body + BC-3.9.015 Trace + BC-3.9.017 body + BC-3.9.017 Trace) |

**Assessment:** No double insertions detected. All counts match expected. **PASS.**

---

## 5. Check 4 — §2.7 Stderr-Clause Taxonomy Remains Closed

**EC-2.7.007-12 classification:** The EC body explicitly states: `"**Stderr-clause taxonomy
(§2.7 taxonomy, P25/P30)**: this is an ERROR exit (exit 64), not a hint"`. Classified as
ERROR/exit-64. **PASS.**

**Display-sanitization taxonomy claim:** The BC-2.7.011 primary clause states: `"**Stderr-clause
taxonomy (§2.7 taxonomy, P25/P30)**: display sanitization applies in human mode only; it is not a
new hint or error class — it modifies the display channel of existing warnings and prompts already
classified in this taxonomy."` The claim holds: no new unclassified stderr clause was introduced.
The cross-references in BC-2.7.008 (collision-skip warning), BC-2.7.010 (degenerate-name warning),
BC-3.9.015 step 1 (delete confirmation prompt), and BC-3.9.017 step 2 (replace prompt) are all
modifications to already-classified clauses. No new hint or error type was added. **PASS.**

---

## 6. Check 5 — Keystones Undisturbed

**K-filename-semantics (P27-001): filename=RAW/path=on-disk**

EC-2.7.007-7 (line 766): `downloaded[].filename` is still described as "the RAW Jira
`attachment.filename` (pre-sanitization); the on-disk basename... is recoverable from `path`."
The display-sanitization primary clause explicitly states: "The sanitization is display-only:
the RAW value continues to be used for disk writes (the `sanitize_attachment_filename` pipeline
above), JSON output (`downloaded[].filename`, attachment list array), and all Jira API calls."
**P27-001 UNDISTURBED.**

**BC-2.7.011 disk-write pipeline NOT altered:** The display-sanitization clause is a new section
at the end of BC-2.7.011, explicitly "distinct from the disk-write path governed by
`sanitize_attachment_filename` above." The 5.5-step algorithm and containment check are
unchanged. **PASS.**

**EC-2.7.008-6 JSON RAW-value semantics:** Still says `downloaded[].filename` is "the RAW Jira
`attachment.filename` (pre-sanitization)." The display-sanitization primary clause reaffirms
"RAW value retained in JSON mode." **PASS.**

**API calls unaffected:** Primary clause confirms RAW value in API calls. No API call modification
anywhere in the v1.3.80 delta. **PASS.**

---

## 7. Check 6 — Cross-Reference Symmetry

The BC-2.7.011 primary clause lists four cross-referenced sites: BC-2.7.008 Overwrite behavior
(collision-skip warnings), BC-2.7.010 degenerate-name warning, BC-3.9.015 step 1 (delete
confirmation prompt), BC-3.9.017 step 2 (`--replace-existing` prompt).

**Reciprocal verification:**

| Site | Reciprocal cross-reference present? |
|------|--------------------------------------|
| BC-2.7.008 Overwrite behavior (line 792) | YES: `"**Display-sanitization cross-reference (SEC-576-011)**: `<filename>` in any collision-skip warning is a server-supplied value and MUST be display-sanitized (all ASCII control characters 0x00–0x1F and 0x7F replaced with `?`) before writing to a TTY, per BC-2.7.011 display-sanitization requirement."` **PASS.** |
| BC-2.7.010 degenerate-name warning (line 869) | YES: `"**Display-sanitization cross-reference (SEC-576-011)**: the `<raw>` value in the degenerate-name warning... MUST be display-sanitized (all ASCII control characters 0x00–0x1F and 0x7F replaced with `?`) before writing to a TTY, per BC-2.7.011 display-sanitization requirement."` **PASS.** |
| BC-3.9.015 step 1 (line 3662) | YES: `"**`<filename>` MUST be display-sanitized** (all ASCII control characters 0x00–0x1F and 0x7F replaced with `?`) before writing to the TTY per BC-2.7.011 display-sanitization requirement (SEC-576-011 — CWE-116)"` **PASS.** |
| BC-3.9.017 step 2 (line 3764) | YES: `"**Display-sanitization cross-reference (SEC-576-011)**: all `<filenameN>` values enumerated in any gate prompt... MUST be display-sanitized (all ASCII control characters 0x00–0x1F and 0x7F replaced with `?`) per BC-2.7.011 display-sanitization requirement before writing to the TTY."` **PASS.** |

**Sweep for other `<filename>`-class values in §2.7 + §3.9 prompt/warning sites:**

- BC-2.7.001 attachment list table: covered by the primary clause scope statement "table cells"
  in BC-2.7.011 — no dedicated cross-reference in BC-2.7.001. The finding did not require a
  cross-reference here (item 5 in the finding was "(table rendering may handle this but should be
  explicit)" and was explicitly excluded from the required SPEC-CHANGES-REQUIRED cross-reference
  list). Acceptable absence.
- BC-2.7.012 error strings: do not display `<filename>`-class values (display key or AID only).
- BC-3.9.008 success echo: displays AID (`"Deleted attachment <AID>."`) — no filename. No cross-ref needed.
- BC-3.9.013 error taxonomy: references `<filename>` indirectly via BC-3.9.015 only; no
  independent filename-display call site.

**Assessment:** All four required sites carry the reciprocal cross-reference with the correct
control-character range. The BC-2.7.001 absence is not a required cross-reference per the finding.
**PASS.**

---

## 8. Check 7 — Version-Bump Surface Completeness

| Surface | Status |
|---------|--------|
| bc-2-issue-read.md frontmatter trace v1.3.80 entry | PRESENT (line 26): "v1.3.80 — Security fix round SEC-576-v2..." with all four SEC-576-xxx citations. **PASS.** |
| bc-3-issue-write.md frontmatter trace v1.3.80 entry | PRESENT (line 107): "v1.3.80 — Security fix round SEC-576-v2 (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.015 step 1 display-sanitization cross-reference added (SEC-576-011 CWE-116); BC-3.9.017 step 2 display-sanitization cross-reference added (SEC-576-011 CWE-116); BC-3.9.015 and BC-3.9.017 Trace fields updated; BC count unchanged (140/35)". **PASS.** |
| prd-delta-576.md frontmatter `spec_version_after: 1.3.80` | PRESENT (line 8). **PASS.** |
| prd-delta-576.md SEC-576-V2-ROUND dispositions section | PRESENT (lines 756–771): all four findings enumerated with disposition, file, and resolution. **PASS.** |
| spec-changelog.md [1.3.80] entry | PRESENT (lines 10–36): BC count 657 ✓, Holdout count 100 ✓, VP count 35 ✓. **PASS.** |
| BC-INDEX v6.33 unchanged (no BC rows modified) | CLAIMED correct by spec-changelog: "BC-INDEX.md \| Verified, NO change \| No BC rows modified; v6.33 unchanged". See **GAP-R43-001** below — this claim is contestable under GAP-M-001/INFO-10 precedent. |

**GAP-R43-001 (LOW): BC-INDEX rows stale for all 6 BC bodies modified in v1.3.80.**

BC-2.7.011 now contains a primary CWE-116 display-sanitization requirement in addition to its
pre-existing CWE-22 disk-write algorithm. The BC-INDEX row for BC-2.7.011 (line 230) describes
only the CWE-22 sanitization pipeline and does not mention the new CWE-116 display-sanitization
clause. An implementer reading BC-INDEX as a summary would not see the new security requirement.

Similarly, BC-2.7.007 (EC-2.7.007-12 added), BC-2.7.008 (display-sanitization cross-reference
added to Overwrite behavior), BC-2.7.010 (trust assumption note + display-sanitization
cross-reference added), BC-3.9.015 (display-sanitization cross-reference in step 1), and
BC-3.9.017 (display-sanitization cross-reference in step 2) all have new body content not
reflected in their BC-INDEX rows.

The GAP-M-001/INFO-10 precedent class (established in r26/r39) covers exactly this pattern:
"body-updated-index-not." BC-INDEX rows are not authoritative (BC bodies are), so this is a
tracking-only staleness, not a behavioral contradiction. The most significant case is BC-2.7.011
where a new distinct security class (CWE-116) was added without any BC-INDEX row update.

**Severity: LOW** (matches INFO-10 precedent; BC bodies are authoritative; no behavioral
contradiction; BC-INDEX is a summary/navigation tool). However, given that BC-2.7.011 now spans
two distinct security classes (CWE-22 and CWE-116), a row-level description update is warranted
before F3 story-writers rely on BC-INDEX as their primary navigation tool.

---

## 9. Check 8 — Guard Scripts

Both guards were run against the repository root:

```
$ bash scripts/check-spec-counts.sh
OK: all spec counts verified.
EXIT: 0

$ bash scripts/check-bc-cumulative-counts.sh
OK: all cumulative BC counts verified (657 total across 8 files; Surface H footer checked where present).
EXIT: 0
```

**Both guards: EXIT 0. PASS.**

---

## 10. Check 9 — SEC-576-011 S2/S4 Allocation Coherence

The BC-2.7.011 primary clause states:
> `**Earliest consumer: S2** (Story 2 — first surface to write server-supplied filenames to
> human-readable output; S4 story-writers must allocate display-sanitization at confirmation prompt
> call sites per DEC-184 R3.13).`

From prd-delta-576.md Scope table:
- S2 = `jr issue attachment download` (BC-2.7.007..012): first surface with filename display
  (download warnings)
- S3 = `jr issue attachment upload` including `--replace-existing` (BC-3.9.001..002, BC-3.9.009,
  BC-3.9.012, BC-3.9.014, BC-3.9.017, BC-3.9.018, BC-3.9.020): BC-3.9.017 step 2 gate displays
  server-supplied filenames in confirmation prompts
- S4 = `jr issue attachment delete` (BC-3.9.008, BC-3.9.010, BC-3.9.013, BC-3.9.015, BC-3.9.016,
  BC-3.9.019, BC-3.9.020): BC-3.9.015 step 1 displays server-supplied filename in confirmation
  prompt

**S2 as "earliest consumer":** COHERENT. S2 is the first story in story-order that writes
server-supplied filenames to any human-readable output (download collision-skip warnings at
BC-2.7.008, degenerate-name warnings at BC-2.7.010). The `display_sanitize_filename` helper
must exist by S2 story close. **COHERENT.**

**"S4 story-writers must allocate display-sanitization at confirmation prompt call sites":**
PARTIALLY COHERENT — the clause names S4 but omits S3. BC-3.9.017 step 2 (S3-owned) also has a
confirmation prompt that displays server-supplied filenames, and the v1.3.80 fix already added the
display-sanitization cross-reference there. However, the primary clause's allocation guidance
statement only calls out S4. An S3 story-writer reading only the BC-2.7.011 primary clause (without
reading BC-3.9.017 step 2) would see only the S4 call-out and might miss the S3 obligation.

**GAP-R43-002 (LOW): BC-2.7.011 display-sanitization primary clause omits S3 from the allocation
guidance sentence.**

The sentence "S4 story-writers must allocate display-sanitization at confirmation prompt call sites
per DEC-184 R3.13" should read "S3 and S4 story-writers must allocate display-sanitization at
confirmation prompt call sites" — or the S3 call-out should appear elsewhere in the clause. S3
story-writers are not directly alerted by the primary clause to their display-sanitization
obligation at BC-3.9.017 step 2 confirmation prompts. The cross-reference in BC-3.9.017 step 2
itself is correct and complete, so the requirement is specified at the point of implementation; the
gap is in the primary clause's allocation summary.

Note: this is NOT a behavioral contradiction — BC-3.9.017 step 2 carries the full cross-reference
and requirement. The gap is in the navigability of the allocation summary for S3 story-writers.

**Severity: LOW** (BC-3.9.017 step 2 has the explicit cross-reference; no implementer who reads
BC-3.9.017 can miss the requirement; the gap is in the primary clause's summary, not in the
requirement itself).

---

## 11. Additional Observation — Double Closing-Count Line in prd-delta-576.md SEC-576-V2-ROUND

The SEC-576-V2-ROUND section closes with two consecutive count lines:

- **Line 771:** `"**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP
  count: 35 (unchanged). Spec version: 1.3.80. BC-INDEX version: v6.33 (unchanged — no BC rows
  modified).**"` ← CORRECT
- **Line 773:** `"**BC count at this round: 657 (unchanged). Holdout count: 100 (unchanged). VP
  count: 35 (unchanged). Spec version: 1.3.79. Both guards exit 0.**"` ← STALE

Line 773 is a copy-paste residue from a prior round's closing line that was not removed or updated:
it incorrectly states "Spec version: 1.3.79" in a section that records the 1.3.79→1.3.80 round,
and uses the alternate "Both guards exit 0" format rather than the format established in line 771.

**Severity: INFO** (tracking-only; no behavioral consequence; both correct counts are on line 771).

---

## 12. Summary

### Gap Table

| ID | Severity | Check | Description |
|----|----------|-------|-------------|
| GAP-R43-001 | LOW | Check 7 (version-bump) | BC-INDEX rows stale for all 6 BC bodies modified in v1.3.80 — most critical is BC-2.7.011 row (describes only CWE-22 disk-write pipeline; new CWE-116 display-sanitization primary clause not reflected). Matches GAP-M-001/INFO-10 gap class. |
| GAP-R43-002 | LOW | Check 9 (S2/S4 allocation) | BC-2.7.011 display-sanitization primary clause allocation sentence names S4 but omits S3. S3-owned BC-3.9.017 step 2 confirmation prompt also displays server-supplied filenames and has the cross-reference; but primary clause's navigation summary is incomplete for S3 story-writers. |
| INFO-R43-001 | INFO | Check 7 (double line) | prd-delta-576.md line 773 (SEC-576-V2-ROUND section): stale copy-paste residue closing-count line states "Spec version: 1.3.79" instead of 1.3.80 — prior round artifact alongside correct line 771. |

### Checks Passed

| Check | Result |
|-------|--------|
| 1. Verbatim remediation (4 findings) | PASS — all 4 remediations present and satisfy finding requirements |
| 2. Echo-breaker audit | PASS — all sentences grounded in BC-licensing clauses, not echoed from security review |
| 3. Double-insertion sweep | PASS — all counts match expected; no duplicate content |
| 4. §2.7 taxonomy: EC-2.7.007-12 ERROR/exit-64; display-sanitization not a new class | PASS |
| 5. Keystones: P27-001 undisturbed; disk pipeline unchanged; JSON RAW unchanged | PASS |
| 6. Cross-reference symmetry: 4 required sites carry reciprocal cross-refs | PASS |
| 7a. bc-2/bc-3 frontmatter trace v1.3.80 entries | PASS |
| 7b. prd-delta-576.md frontmatter + dispositions section | PASS |
| 7c. spec-changelog.md [1.3.80] with counts 657/100/35 | PASS |
| 7d. BC-INDEX row staleness | LOW GAP (GAP-R43-001) |
| 8. Guard scripts (check-spec-counts + check-bc-cumulative-counts) | PASS — both exit 0 |
| 9. S2/S4 allocation coherence | LOW GAP (GAP-R43-002) |

---

## 13. Verdict

**GAPS-FOUND** — 2 LOW gaps and 1 INFO finding.

No behavioral contradictions. All four security findings (SEC-576-009/010/008/011) are correctly
applied and satisfy their requirements as stated in `security-review-576-v2.md`. The keystones are
coherent, the taxonomy is closed, and both guard scripts exit 0. The gaps are tracking/navigation
quality issues that do not block implementation.

**Required before F3 story decomposition:**
- GAP-R43-001: update BC-INDEX rows for BC-2.7.011 (at minimum) to reflect new CWE-116
  display-sanitization primary clause; optionally also update BC-2.7.007, BC-2.7.008, BC-2.7.010,
  BC-3.9.015, BC-3.9.017 rows per INFO-10 precedent.
- GAP-R43-002: add S3 to the allocation guidance sentence in BC-2.7.011 primary clause:
  "S3 and S4 story-writers must allocate display-sanitization at confirmation prompt call sites."
- INFO-R43-001: remove stale line 773 from prd-delta-576.md SEC-576-V2-ROUND section (or correct
  "Spec version: 1.3.79" to "1.3.80").
