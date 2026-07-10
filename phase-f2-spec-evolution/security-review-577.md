---
document_type: security-review
level: spec
version: "1.0"
status: complete
producer: security-reviewer
timestamp: 2026-07-09
phase: phase-f2-spec-evolution
issue: 577
trigger: DEC-168 ruling 4
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/prd/holdout-scenarios.md"
  - ".factory/research/issue-577-comment-crud-jsdpublic-2026-07-09.md"
  - ".factory/phase-f1-delta-analysis/delta-analysis-577-comment-crud.md"
input-hash: "fe49b86"
traces_to: "BC-3.5.002..BC-3.5.012, VP-577-001..VP-577-007, H-NEW-COMMENT-001..H-NEW-COMMENT-004"
total_findings: 3
critical: 0
high: 0
medium: 0
low: 3
files_reviewed: 4
verdict: FINDINGS
severity_summary: "3 LOW, 5 INFO — no CRITICAL, no HIGH, no MEDIUM"
---

# Security Review — Issue #577 SOH-COMMENT-CRUD-1 F2 Spec Delta

**Scope**: Pre-implementation spec-level audit of BC-3.5.002..BC-3.5.012,
VP-577-001..VP-577-007, H-NEW-COMMENT-001..H-NEW-COMMENT-004 (spec v1.3.28, 2026-07-09).

**Trigger**: DEC-168 ruling 4 ("security reviewer pass at F2 pre-spec-crystallization").

---

## Executive Summary

The SOH-COMMENT-CRUD-1 F2 spec delta is security-sound at its core. The body-only PUT
invariant (BC-3.5.005 / DEC-168 ruling 1) correctly inverts the original footgun claim:
omitting `properties` preserves Jira's `sd.public.comment` state; the dangerous path is
explicitly sending a `properties` array the caller does not fully control. The spec
enforces fail-absent behavior, always-confirm on `--public`, and visibility labelling in
`comment view`. Three LOW items require minor spec text corrections before F3 story
decomposition; none require reopening any DEC-168 ruling.

---

## Findings

### SEC-577-001: Misleading non-interactive exit-64 message for `--public` (LOW)

- **Severity:** LOW
- **CWE:** CWE-1021 (Improper Restriction of Rendered UI Layers — misleading security message)
- **OWASP:** N/A
- **Location:** BC-3.5.008 item 1
- **Attack Vector:** Not exploitable; the gate (requiring `--yes`) is intact. Risk is that a
  user or operator misreads the message and makes an incorrect decision about whether the
  confirmation applies to their context.
- **Impact:** Operator confusion on non-JSM issues or already-public comments. The specced
  exit-64 stderr is `"Making an internal JSM comment publicly visible. Use --yes to
  confirm."` This asserts the comment is currently internal and on a JSM project, but
  BC-3.5.007 chose Option (a): always confirm, no GET — so neither fact is verified. On
  a non-JSM issue (where `--public` is silently ignored by Jira), the message is
  factually wrong and may cause operators to incorrectly believe the command has JSM
  semantics it does not have.
- **Evidence:** BC-3.5.008 item 1 stdout: `"Making an internal JSM comment publicly
  visible. Use --yes to confirm."` combined with BC-3.5.007 rationale: "Confirmation
  always required... no GET of current state required."
- **Proposed Mitigation:** Change the non-interactive exit-64 message to: `"This will set
  the comment's visibility to public. Use --yes to confirm."` The interactive prompt at
  BC-3.5.008 item 2 is already correct: `"This will make the comment publicly visible to
  the customer. Continue? [y/N] "` — no change needed there.
- **Status:** open

---

### SEC-577-002: `--stdin` + positional text mutual exclusion unspecified (LOW)

- **Severity:** LOW
- **CWE:** CWE-1283 (Improper Handling of Ambiguous Input)
- **OWASP:** N/A
- **Location:** BC-3.5.009 (missing EC)
- **Attack Vector:** No direct exploit. A script that pipes stdin AND passes positional text
  encounters undefined behavior: clap may reject it, accept one silently, or concatenate.
  Undefined body source on a write command is a correctness hazard.
- **Impact:** Unpredictable PUT body content if both `--stdin` and positional text are
  supplied simultaneously. Could overwrite a comment with the wrong body.
- **Evidence:** BC-3.5.009 EC-3.5.009-2 covers `--file`+`--stdin`; EC-3.5.009-3 covers
  `--file`+positional. No EC covers `--stdin`+positional.
- **Proposed Mitigation:** Add EC-3.5.009-4: `"--stdin and positional text are mutually
  exclusive (clap conflicts_with); exit 2."` One additional clap annotation in the story.
- **Status:** open

---

### SEC-577-003: JSDCLOUD-6050 hint timing inconsistency between `--internal` and `--public` (LOW)

- **Severity:** LOW
- **CWE:** None (spec consistency; no security vulnerability)
- **OWASP:** N/A
- **Location:** EC-3.5.006-1 vs EC-3.5.007-1
- **Attack Vector:** N/A — the inconsistency has no exploitable consequence.
- **Impact:** EC-3.5.006-1 (`--internal`) specifies the hint fires **after submission**.
  EC-3.5.007-1 (`--public`) specifies the hint fires **before the PUT is sent**. An
  implementer writing tests for both paths will encounter asymmetric ordering requirements
  with no stated rationale. If a test asserts hint-before-PUT on the `--internal` path it
  will fail; if tests change to match the discrepancy, the asymmetry becomes a regression
  trap.
- **Evidence:** EC-3.5.006-1: "emit a stderr hint **after submission**". EC-3.5.007-1:
  "emit a stderr hint **before the PUT is sent**."
- **Proposed Mitigation:** Unify to "before the PUT is sent" for both paths (preferable —
  the operator sees the caveat before the API call, consistent with confirmation pattern).
  Apply to both EC-3.5.006-1 and EC-3.5.007-1.
- **Status:** open

---

### SEC-577-004: Serde key-absence implementation-guidance gap (INFO)

- **Severity:** INFO
- **CWE:** CWE-116 (Improper Output Encoding — partial analog; key presence/absence in
  serialized wire body)
- **Location:** BC-3.5.005 / VP-577-001
- **Impact:** A naive `#[derive(Serialize)]` with `Option<Vec<...>>` serializes as
  `"properties": null` when `None`, violating the body-only PUT invariant. VP-577-001
  would catch this at test time (`get("properties").is_none()` fails for `null`), but
  the spec does not warn the implementer proactively.
- **Proposed Mitigation:** Add a note in BC-3.5.005 that `update_comment`'s PUT body
  struct MUST NOT include a `properties` field at all on the body-only path — use a
  separate body struct or conditional JSON construction, not `Option<Vec<...>>` with
  default serde derive.
- **Status:** info / VP covers at test time

---

### SEC-577-005: Visibility label display prominence (INFO)

- **Severity:** INFO
- **CWE:** CWE-1021 (minor; visibility state could scroll off terminal)
- **Location:** BC-3.5.010 human output format
- **Impact:** The spec requires an `"Internal"`/`"Public"`/`"N/A"` label in the summary
  row. For a long comment body (multi-screen terminal output), the visibility label in the
  header row may scroll off before the operator reads the body. No spec change is required;
  story writer should be aware the label must appear before the body begins rendering.
- **Status:** info / accepted

---

### SEC-577-006: Error-body surfacing scope not explicitly bounded (INFO)

- **Severity:** INFO
- **CWE:** CWE-209 (Generation of Error Message Containing Sensitive Information — partial
  analog; Jira 404 DELETE body is not PII-bearing in practice)
- **Location:** BC-3.5.004 / EC-3.5.004-1
- **Impact:** Research (Claim 3 CONFIRMED) shows Jira's 404 body for DELETE comment is
  typically `{"errorMessages":["Comment with id 'X' does not exist."],"errors":{}}` — no
  accountIds, ADF, or email. The spec is consistent with the project's existing
  `extract_error_message` convention (BC-7.3.001/002) which already surfaces API error
  bodies throughout the codebase. The `--verbose-bodies` PII warning (SD-003) covers
  diagnostic logging, not the error-surfacing path.
- **Status:** info / accepted per project convention

---

### SEC-577-007: ADF injection surface via untrusted `--file`/`--stdin` (INFO)

- **Severity:** INFO
- **CWE:** CWE-20 (Improper Input Validation — covered by existing guards)
- **Location:** BC-3.5.009; `src/adf.rs`
- **Impact:** All body sources flow through existing guarded `markdown_to_adf`/`text_to_adf`
  pipelines. SEC-001 recursion-depth guard (MAX_ADF_DEPTH = 256, BC-7.2.012, CWE-674) applies.
  CRLF injection protection (BC-7.2.011 INV-1) applies. No new attack surface introduced.
  H-NEW-SEC-001 and H-NEW-SEC-002 pin this behavior.
- **Status:** info / covered by SEC-001

---

### SEC-577-008: Missing holdouts for `--internal`/`--public` wire shapes (INFO)

- **Severity:** INFO
- **CWE:** None (test coverage gap)
- **Location:** VP-577-002 (BC-3.5.006), VP-577-003 (BC-3.5.007) — Verification Properties
  not elevated to holdouts
- **Impact:** The wire-level boolean correctness of `"internal": true` and `"internal":
  false` (vs string `"true"`/`"false"`, per research JSDCLOUD-9766 red flag) is tested via
  VP-577-002/003 in the BC spec but not pinned as holdout scenarios. A regression to string
  form would pass compilation and normal tests but silently send incorrect JSON to Jira.
- **Proposed Mitigation:** Consider elevating VP-577-002 and VP-577-003 to holdout scenarios
  (Group 15 additions) in the same F3 story that writes the wire-shape integration tests.
- **Status:** info / VPs cover; elevation optional

---

## Summary Table

| ID | Severity | CWE | Location | Status |
|----|----------|-----|----------|--------|
| SEC-577-001 | LOW | CWE-1021 | BC-3.5.008 item 1 | open — spec text fix |
| SEC-577-002 | LOW | CWE-1283 | BC-3.5.009 (missing EC) | open — add EC-3.5.009-4 |
| SEC-577-003 | LOW | none | EC-3.5.006-1 / EC-3.5.007-1 | open — unify hint timing |
| SEC-577-004 | INFO | CWE-116 | BC-3.5.005 | info / VP covers |
| SEC-577-005 | INFO | CWE-1021 | BC-3.5.010 human output | info / accepted |
| SEC-577-006 | INFO | CWE-209 | BC-3.5.004 / EC-3.5.004-1 | info / accepted per convention |
| SEC-577-007 | INFO | CWE-20 | BC-3.5.009 / adf.rs | info / covered by SEC-001 |
| SEC-577-008 | INFO | none | VP-577-002, VP-577-003 | info / VPs cover |

---

## Positive Findings (Defensive Measures Present)

1. **Body-only default eliminates GET-then-PUT race** (BC-3.5.005 / DEC-168 ruling 1):
   DEC-168 replaced the F1 GET-preserve-PUT pattern with a body-only default. This
   eliminates the TOCTOU race where stale GET state could inadvertently flip visibility.
   Simpler invariants are more implementable correctly.

2. **Fail-absent on unknown state** (DEC-168 design): No "safe default" is assumed for
   visibility. Body-only is property-preserving by Atlassian's architectural design
   (research Claim 1 REFUTED-footgun). No code path defaults to "make public" on an
   ambiguous state.

3. **Default N on all confirmation prompts** (EC-3.5.003-1 / BC-3.5.008): Both `comment
   delete` and `comment edit --public` default to cancel (N) on Enter. This is the correct
   fail-safe direction for destructive or data-exposure-risk operations.

4. **`--public` confirmation fires before any HTTP** (BC-3.5.008): H-NEW-COMMENT-002
   validates this with `.expect(0)` on both GET and PUT. No partial state is possible from
   a cancelled confirmation.

5. **Visibility label always rendered in `comment view`** (BC-3.5.010): Human output
   specifies `"Internal"`/`"Public"`/`"N/A"` label, addressing the research red flag about
   copy-paste risk. The `"N/A"` case correctly handles non-JSM comments.

6. **`--internal`/`--public` mutual exclusion is clap-enforced, not logic-enforced**
   (BC-3.5.011): Constraint fires at parse time before any handler code runs; impossible
   to bypass through handler logic paths.

---

## Recommendations Priority

### Immediate (before F3 story decomposition)

1. **BC-3.5.008 item 1** — Change exit-64 stderr to: `"This will set the comment's
   visibility to public. Use --yes to confirm."` (removes false "internal JSM" assertion).
   SEC-577-001.

2. **BC-3.5.009** — Add EC-3.5.009-4: `"--stdin and positional text are mutually
   exclusive (clap conflicts_with); exit 2."` SEC-577-002.

3. **EC-3.5.006-1 / EC-3.5.007-1** — Unify JSDCLOUD-6050 hint timing to "before the PUT
   is sent" for both `--internal` and `--public` paths. SEC-577-003.

### Before Release

4. **BC-3.5.005** — Add implementation note: the PUT body struct for the body-only path
   MUST NOT include a `properties` field at serialization time; use a separate struct or
   conditional JSON construction. SEC-577-004.

5. **VP-577-002 / VP-577-003** — Consider elevating to holdout scenarios to pin boolean
   vs string form for `"internal": true/false`. SEC-577-008.

### Post-Release

6. Monitor JSDCLOUD-6050 resolution; if Atlassian fixes portal lag for property edits,
   remove the JSDCLOUD-6050 hint from EC-3.5.006-1 and EC-3.5.007-1 in a follow-up spec
   amendment.

---

## Audit Notes by Dimension

### Dimension 1 — Visibility-flip attack surface (BC-3.5.005 invariant tightness)

BC-3.5.005 uses precise language: the `"properties"` key MUST NOT be present — "not as
an empty array, not as `null`, not as any value." VP-577-001 operationalizes this with
`serde_json::...get("properties").is_none()` — correctly distinguishing key-absent from
`"properties": null` or `"properties": []`. H-NEW-COMMENT-001 also mounts GET with
`.expect(0)`, confirming no GET roundtrip on the default path. The three code paths
(`None` = body-only, `Some(true)` = `--internal`, `Some(false)` = `--public`) are cleanly
separated at the API-layer function signature. No path through the spec allows properties
to leak onto the body-only call. Finding: SEC-577-004 (INFO).

### Dimension 2 — `--public` gate completeness

`comment delete` and `comment edit` are distinct clap subcommands with separate
invocations. `--yes` on a `comment delete` call cannot affect a `comment edit` call —
they never share in-process state. BC-3.5.008 gate fires before any HTTP (H-NEW-COMMENT-002
`.expect(0)` on both GET and PUT). Default-N convention is consistent with the project's
destructive-operation safety convention. Finding: SEC-577-001 (LOW — message wording).

### Dimension 3 — Information disclosure via `comment view`

BC-3.5.010 specifies `"Internal"`/`"Public"`/`"N/A"` in the human summary row, directly
addressing the research red flag. JSON path passes the full `properties` array through
`output::render_json`. Finding: SEC-577-005 (INFO — display prominence only).

### Dimension 4 — Error-body surfacing (BC-3.5.004)

Jira 404 DELETE body is not PII-bearing (confirmed by research Claim 3). BC-3.5.004
is consistent with the project's existing `extract_error_message` convention (BC-7.3.001
/002). The `--verbose-bodies` PII warning (SD-003) concerns diagnostic logging, not error
surfacing. Finding: SEC-577-006 (INFO).

### Dimension 5 — JSDCLOUD-6050 caveat handling

Both EC-3.5.006-1 (--internal) and EC-3.5.007-1 (--public) emit a JSDCLOUD-6050 hint.
The hint cites the bug ticket number. `comment view` is a specced follow-up verification
primitive. The hint approach is consistent with the project's best-effort treatment of
other undocumented API behaviors. Finding: SEC-577-003 (LOW — timing inconsistency).

### Dimension 6 — Untrusted input / ADF injection

BC-3.5.009 explicitly names `src/adf.rs::markdown_to_adf` and `src/adf.rs::text_to_adf`
as the conversion functions. SEC-001 recursion-depth guard (MAX_ADF_DEPTH = 256,
BC-7.2.012, CWE-674) applies to all forward-path callers, including these functions.
`--file PATH` reads a file and passes it through the same guarded pipeline — no shell
execution, no template evaluation. Finding: SEC-577-007 (INFO / covered).

### Dimension 7 — CWE mapping

See Summary Table above for consolidated CWE citations per finding.
