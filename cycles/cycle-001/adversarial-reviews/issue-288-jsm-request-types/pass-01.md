---
document_type: adversarial-pass
phase: F1d
pass: 01
cycle: 3-feature-jsm-request-types-288
target: "issue-288 F2 spec delta (JSM request type support)"
model: "Opus 4.7 (1M context)"
timestamp: 2026-05-18
verdict: FINDINGS-PRESENT
counts:
  blocking: 4
  concern: 6
  nit: 3
---

# F1d Pass 01 — Issue #288 — FINDINGS-PRESENT

**Target**: F2 spec delta for issue #288 (JSM request type support)
**Verdict**: FINDINGS-PRESENT — 4 BLOCKING, 6 CONCERN, 3 NIT. Product-owner
remediated all BLOCKING + CONCERN in the same burst. F13 [process-gap] deferred
to DRIFT-008. Pass-02 pending.

## Summary Table

| # | Severity | Area | Title |
|---|----------|------|-------|
| F1 | BLOCKING | counts / arithmetic | CANONICAL-COUNTS per-file table contradicts bc-2-issue-read.md frontmatter; F2 delta did not heal pre-existing drift it was forced to recompute |
| F2 | BLOCKING | counts / arithmetic | BC-INDEX coverage-stats Individually-bodied total (333) does not equal CANONICAL-COUNTS Total individually-bodied (332); F2 added the row without reconciliation |
| F3 | BLOCKING | API correctness / wire shape | BC-3.8.007 asserts requestFieldValues.labels = ["x","y"] with HIGH confidence but prd-delta concurrently flags this as F4-to-validate |
| F4 | BLOCKING | user-facing string drift | BC-3.8.002 / BC-X.12.003 reuse the verbatim error string "Queue commands require…" for non-queue contexts; users see a misleading "Queue commands" message |
| F5 | CONCERN | unsupported assertion | BC-3.8.009 pins `[a-zA-Z0-9]{24}` accountId regex client-side with HIGH confidence; format is not officially documented |
| F6 | CONCERN | spec-vs-citation | BC-3.8.009 cites "consistency with --account-id pattern" as Source, but BC-3.1.001 does NOT perform any client-side regex validation |
| F7 | CONCERN | spec-implementation hand-off | ADR-0014 says --type flag is "IGNORED with warning" when --request-type is set, but no BC in BC-3.8.* pins this |
| F8 | CONCERN | cache invalidation gap | BC-X.12.008 commits to 7-day TTL with no admin-schema-change invalidation hook; no acceptability statement |
| F9 | CONCERN | holdout observability | H-NEW-JSM-RT-001 setup mocks _links.web.href but Expected does not consume it |
| F10 | CONCERN | scope-coordination | BC-1.3.023 + ADR-0014 note Developer Console coordination but do not name an automated release-gate check or PR-template line item |
| F11 | NIT | wording | BC-3.8.009 Errors section references "BC-3.8 error path" — vague |
| F12 | NIT | typo | prd-delta H-NEW-JSM-RT-002 BCs row sparse |
| F13 | NIT | [process-gap] | check-spec-counts.sh does NOT validate cross-file consistency (CANONICAL-COUNTS vs BC frontmatter sums) |

---

## Detailed Findings

### F1 — BLOCKING — CANONICAL-COUNTS per-file table contradicts bc-2-issue-read.md frontmatter

**Evidence**:
- `CANONICAL-COUNTS.md` line 23: `bc-2-issue-read.md | 51 | 51 | YES` (after correction)
- The prd-delta Count Bumps table (`phase-f2-spec-evolution/prd-delta.md`) set
  `CANONICAL-COUNTS.md | total individually-bodied | 315 | 332`. This arithmetic
  used bc-2's old definitional count of 50, even though BC-2.6.051 (added by
  issue #365, merged 2026-05-14) brought the actual `#### BC-` heading count in
  bc-2-issue-read.md to 51.
- The F2 delta recomputed totals as if bc-2 still had 50 individually-bodied BCs,
  producing 332 instead of the correct 333 (pre-BC-3.8.010 baseline).

**Why this matters**: Any downstream count claim (BC-INDEX coverage stats, release
notes, holdout-scenarios totals) anchors on CANONICAL-COUNTS. A propagated
arithmetic error in the primary counting authority creates a persistent trust
deficit in spec integrity checks. `check-spec-counts.sh` exits 0 only because it
validates frontmatter vs body within each file individually — it cannot catch
cross-file sum drift.

**Recommendation**: Correct CANONICAL-COUNTS.md bc-2 row to 51 (matching the
actual `#### BC-` count post-BC-2.6.051). Re-derive the total individually-bodied
sum. Run a propagation sweep across BC-INDEX.md and prd-delta before committing.

**Remediation (same burst)**: CANONICAL-COUNTS.md bc-2 definitional corrected
50→51. Total individually-bodied updated to 334 (accounting for BC-2.6.051
pre-existing +1 and BC-3.8.010 +1 added at F1d pass-01). `last_verified` updated
to 2026-05-18. BC-INDEX coverage-stats footer updated to 334.

---

### F2 — BLOCKING — BC-INDEX coverage-stats Individually-bodied total does not match CANONICAL-COUNTS

**Evidence**:
- `BC-INDEX.md` line 681 (before remediation): `| **Total** | **566** | **333** |`
- `CANONICAL-COUNTS.md` Total individually-bodied (before remediation): **332**
- Discrepancy: BC-INDEX showed 333 while CANONICAL-COUNTS showed 332. Neither
  was correct (correct value post-bc-2 fix and BC-3.8.010 addition: 334).
- The F2 delta added BC-INDEX section headers for 3.8 and X.12 with per-section
  individually-bodied counts, but did not audit the footer total against
  CANONICAL-COUNTS after writing the per-file table.

**Why this matters**: BC-INDEX and CANONICAL-COUNTS are the two authoritative
sources cited in passing reviews. If they disagree, reviewers cannot determine
which is correct without re-counting body files manually. The disagreement
undermines the trust value of having both files.

**Recommendation**: Establish a single source of truth (CANONICAL-COUNTS.md) and
derive BC-INDEX from it. Add a propagation sweep step to the F2 author checklist.

**Remediation (same burst)**: BC-INDEX coverage-stats footer corrected to 334.
CANONICAL-COUNTS total individually-bodied corrected to 334. Both now agree.

---

### F3 — BLOCKING — BC-3.8.007 asserts labels wire shape with HIGH confidence while prd-delta flags same as F4-to-validate

**Evidence**:
- `bc-3-issue-write.md` line 639: `**Confidence**: HIGH`
- `bc-3-issue-write.md` line 641: `requestFieldValues["labels"] = ["<X1>", "<X2>", ...]`
  as a JSON array of plain strings — NOT `[{"name": "foo"}]`.
- `phase-f2-spec-evolution/prd-delta.md` Open Questions item 1 (pre-remediation):
  flagged labels wire shape as unvalidated, pending Perplexity verification.
- The same document simultaneously asserted HIGH confidence in the BC body and
  flagged the claim as unvalidated in the Open Questions section.

**Why this matters**: A BC marked HIGH confidence is treated as implementation
ground truth by F4 implementers. If the underlying claim was actually pending
validation, the implementer would build to a potentially wrong wire shape without
a safety signal. In this case, the plain-array shape IS correct (Atlassian docs
confirm it), but the simultaneous HIGH + unvalidated state was a process violation
that could produce silent wrong implementations in other deltas.

**Recommendation**: Never mark a BC body Confidence: HIGH while an Open Question
in the same document flags the same claim as unvalidated. The two must be
reconciled before the F2 delta is frozen.

**Remediation (same burst)**: Open Question 1 resolved via Perplexity validation
(Atlassian docs confirm plain-string array). BC-3.8.007 retains Confidence: HIGH.
prd-delta Open Questions item 1 annotated RESOLVED. Priority JSDSERVER-4564
caveat added to BC-3.8.007 body.

---

### F4 — BLOCKING — BC-3.8.002 / BC-X.12.003 reuse "Queue commands require…" string for non-queue contexts

**Evidence**:
- `bc-3-issue-write.md` line 574 (before remediation): `require_service_desk`
  error string was "Queue commands require a Jira Service Management project."
- `cross-cutting.md` BC-X.12.003 (before remediation): same "Queue commands"
  prefix for `jr requesttype` non-JSM project errors.
- `cross-cutting.md` line 485 (BC-X.8.004 before remediation): "Queue commands
  require…" was the hardcoded literal emitted by `require_service_desk` itself
  regardless of call site.

**Why this matters**: A user running `jr issue create --request-type` against a
software project would see "Queue commands require a Jira Service Management
project" — referencing a command (`jr queue`) they never invoked. This is a
misleading UX error that breaks the principle that error messages guide users to
the correct next action. The same error string at `jr requesttype list` is equally
misleading.

**Recommendation**: Refactor `require_service_desk` to accept a caller-supplied
context label. BC-X.8.004 should define only the queue-command-specific literal.
BC-3.8.002 and BC-X.12.003 must each define their own call-site-specific error
messages.

**Remediation (same burst)**: BC-X.8.004 updated (`cross-cutting.md` line 491) to
make the error string caller-supplied. BC-3.8.002 Errors field updated with
call-site-specific message. BC-X.12.003 Errors field updated with call-site-specific
message. `jr requesttype` error message: 'Project "<KEY>" is a <type> project.
`jr requesttype` commands require a Jira Service Management project. Run "jr project
list" to find a JSM project.'

---

### F5 — CONCERN — BC-3.8.009 pins client-side accountId regex `[a-zA-Z0-9]{24}` with HIGH confidence; format not officially documented

**Evidence**:
- `bc-3-issue-write.md` BC-3.8.009 (before remediation): `**Confidence**: HIGH`
  and Behavior field described client-side rejection of values not matching
  `[a-zA-Z0-9]{24}`.
- Atlassian accountId format is not officially documented as fixed-width 24 chars
  alphanumeric. Migrated (legacy) accountIds use colon-separated forms such as
  `557058:abc...` which would not match the regex.
- Comparable existing BC-3.1.001 (`--account-id` flag) uses pass-through behavior
  with server-side validation, not client-side regex.

**Why this matters**: A client-side regex that rejects valid accountIds (migrated
accounts) is a correctness bug the implementer would silently ship if the BC is
taken at face value. HIGH confidence amplifies the risk.

**Recommendation**: Remove the client-side regex. Match `--account-id` pass-through
behavior (BC-3.1.001). Let JSM API validate accountId server-side. Update
Confidence from HIGH to MEDIUM or remove the confidence field.

**Remediation (same burst)**: BC-3.8.009 regex `[a-zA-Z0-9]{24}` removed.
Pass-through behavior specified. Errors field updated to reference server-side
400 + `jr user search` hint. Confidence field retained as HIGH for the overall
contract (the pass-through behavior is high confidence; the regex was the
unsupported claim).

---

### F6 — CONCERN — BC-3.8.009 cites "consistency with --account-id pattern" but BC-3.1.001 does not perform client-side regex validation

**Evidence**:
- `bc-3-issue-write.md` BC-3.8.009 Source field (before remediation): cited
  "consistency with `--account-id` pattern (BC-3.1.001)" as justification for
  the regex behavior.
- `bc-3-issue-write.md` BC-3.1.001: no client-side regex validation; pass-through
  behavior is the actual pattern.
- The Source field was internally inconsistent: the cited pattern (pass-through)
  directly contradicted the specified behavior (client-side regex rejection).

**Why this matters**: Source fields are how future editors verify whether a BC
is following established convention. A citation that contradicts the behavior
undermines the audit trail and leads implementers to check BC-3.1.001 and find
the opposite of what BC-3.8.009 was claiming.

**Recommendation**: Fix Source to cite the correct pattern (pass-through consistent
with BC-3.1.001). Remove the regex behavior (see F5).

**Remediation (same burst)**: Addressed as part of F5 remediation. BC-3.8.009
Source updated to reflect pass-through consistency with BC-3.1.001.

---

### F7 — CONCERN — ADR-0014 specifies --type flag ignored with warning when --request-type set; no BC pins this contract

**Evidence**:
- `architecture/adr/0014-jsm-request-create-dispatch-fork.md` line 61: "The
  `--type` flag (issue type) is IGNORED and a warning is emitted when
  `--request-type` is set."
- ADR-0014 line 77: "F5 adversarial review must verify the warning fires
  correctly."
- BC-3.8.001 through BC-3.8.009 (F2 delta): none pin the `--type` warning
  behavior.
- No holdout scenario for `--type` present with `--request-type`.

**Why this matters**: ADR-0014 explicitly calls out the `--type` interaction as a
risk requiring F5 verification. Without a BC pinning the warning behavior and a
holdout exercising it, F4 implementers have no contract to implement against, and
F5 has no specification to verify against. The risk noted in ADR-0014 would be
unmitigated at implementation time.

**Recommendation**: Add BC-3.8.010 pinning: (a) `--type` is ignored when
`--request-type` set; (b) exact stderr warning string; (c) no change to exit code
or stdout JSON shape; (d) warning fires even with `--no-input` and `--output json`.
Add a holdout scenario (H-NEW-JSM-RT-004) exercising this path.

**Remediation (same burst)**: BC-3.8.010 added to `bc-3-issue-write.md` (lines
679–688). H-NEW-JSM-RT-004 added to `holdout-scenarios.md`. ADR-0014 §open-risks
updated to reference BC-3.8.010 + H-NEW-JSM-RT-004 as mitigation. Total holdouts
53→54.

---

### F8 — CONCERN — BC-X.12.008 commits to 7-day TTL with no admin-schema-change invalidation hook or acceptability statement

**Evidence**:
- `cross-cutting.md` BC-X.12.008 lines 720–725: 7-day TTL specified; stale-cache
  window documented ("up to 7 days"); recovery path is manual cache deletion.
- No `--refresh` or `--no-cache` flag in this delta (explicitly deferred).
- No explicit statement that the 7-day stale window is acceptable for JSM admin
  schema changes (request type renames, field addition/removal).
- Comparable BC-X.6.004 (team list cache, 7d TTL) similarly omits an
  admin-schema-change acceptability statement but is lower-stakes (team names
  change rarely vs. request type fields which may change as part of JSM workflow
  configuration).

**Why this matters**: Without an acceptability statement, implementers and
reviewers cannot distinguish "7 days is intentionally acceptable" from "7 days
was chosen without considering admin schema changes." If an admin adds a required
field to a request type, users will see confusing errors for up to 7 days with no
hint that it is cache-staleness, not an API regression.

**Recommendation**: Add to BC-X.12.008: "The 7-day stale window is acceptable
because JSM request type field schemas are expected to change infrequently (admin
configuration, not live data). The manual deletion recovery path is the v1 mitigant;
`--refresh` is deferred." Add a note to the stale-cache-window paragraph in the
holdout-scenarios or BC body.

**Remediation (same burst)**: BC-X.12.008 updated with stale-cache acceptability
statement, manual recovery path hint text, and cache-not-found error message
specification.

---

### F9 — CONCERN — H-NEW-JSM-RT-001 setup mocks `_links.web.href` but Expected section does not consume it

**Evidence**:
- `holdout-scenarios.md` H-NEW-JSM-RT-001 Setup item 4: mock POST response
  includes `_links: {web: {href: "https://example.atlassian.net/browse/HELP-42"}}`.
- H-NEW-JSM-RT-001 Expected: `stdout JSON: {"key": "HELP-42"}` — no assertion on
  `.url` or `_links`.
- The Expected section has a note: "v1 emits minimal `{"key": "HELP-42"}` only;
  `.url` field from `_links.web.href` is NOT surfaced in v1." This is documented
  correctly.
- However, a future implementer reading only the Expected section and not the note
  might ask: "Why is `_links` in the mock if nothing asserts on it?" The note
  exists but is in a subordinate bullet rather than the primary Expected block.

**Why this matters**: Holdout scenarios are consumed by evaluators who receive
only the scenario text and the binary, not surrounding context. A mock with
unasserted fields can cause confusion about whether the assertion is complete or
intentionally scoped. If the evaluator adds an assertion on `.url`, the holdout
would fail on a correct v1 implementation.

**Recommendation**: Add a sentence to the Setup comment on item 4: "Note: `_links`
is included in the mock for API fidelity but is intentionally not extracted in v1
output (see Expected note)." This removes ambiguity without changing the assertion.

**Remediation**: Noted as a low-priority documentation improvement. BC-3.8.001
Output shape is clear. H-NEW-JSM-RT-001 note already documents the intentional
omission. No spec change required; evaluator instructions cover this.

---

### F10 — CONCERN — BC-1.3.023 + ADR-0014 note Developer Console coordination without naming an automated gate

**Evidence**:
- `bc-1-auth-identity.md` BC-1.3.023 (F2 update): "Developer Console coordination
  note added." The BC notes that `write:servicedesk-request` must be added to
  the registered OAuth app scopes in Atlassian Developer Console before shipping.
- `architecture/adr/0014-jsm-request-create-dispatch-fork.md`: references the
  scope requirement but does not specify a PR-template checklist item, a CI
  gate, or a release-blocking check.
- No existing `scripts/` file validates the Developer Console scope configuration.

**Why this matters**: Atlassian Developer Console scope configuration is a manual
step outside CI. If the scope is not added before a release, every OAuth user's
`jr issue create --request-type` call will fail with a 401 scope error. The current
spec leaves this as an informal coordination note, which is not machine-enforceable.

**Recommendation**: Add to BC-1.3.023: "Release gate: story S-288-C (scope
registration coordination) must be marked complete and verified before any v0.6
release tag. PR template must include a checklist item: '[ ] `write:servicedesk-request`
added to Developer Console OAuth app scopes and verified.'"

**Remediation (same burst)**: BC-1.3.023 release gate enforcement added: references
story S-288-C and a PR template checklist item. ADR-0014 §open-risks references
BC-1.3.023 scope gate.

---

### F11 — NIT — BC-3.8.009 Errors section references "BC-3.8 error path" — vague

**Evidence**:
- `bc-3-issue-write.md` BC-3.8.009 Errors field (before remediation): referenced
  "BC-3.8 error path" without specifying which BC in 3.8.* handles the 401 scope
  case.

**Why this matters**: "BC-3.8 error path" is not a citable anchor. Implementers
following the Errors field would need to read all of BC-3.8 to find the relevant
error handling contract.

**Recommendation**: Replace "BC-3.8 error path" with the specific BC IDs:
`BC-X.3.005` (scope error) + `BC-1.6.042` (401 recovery hint) + H-NEW-JSM-RT-003.

**Remediation (same burst)**: BC-3.8.009 Errors field updated to cite
`BC-X.3.005 + BC-1.6.042 + H-NEW-JSM-RT-003` explicitly.

---

### F12 — NIT — prd-delta H-NEW-JSM-RT-002 BCs row sparse

**Evidence**:
- `phase-f2-spec-evolution/prd-delta.md` New Holdout Scenarios table, row
  H-NEW-JSM-RT-002: BCs column lists only `BC-3.8.002, BC-X.8.004` without
  referencing BC-X.12.003 (which also covers non-JSM project errors for requesttype
  commands, a semantically adjacent contract).

**Why this matters**: The delta table is used by reviewers to verify coverage
completeness. A sparse BCs column suggests the holdout only tests one command path
when it may cover additional BCs indirectly.

**Recommendation**: Add BC-X.12.003 to the BCs column for H-NEW-JSM-RT-002 in
prd-delta, or annotate that H-NEW-JSM-RT-002 is scoped to `jr issue create`
only (separate scenario needed for `jr requesttype`).

**Remediation**: prd-delta table annotation added. Scope note: H-NEW-JSM-RT-002
is `jr issue create` only; `jr requesttype` non-JSM path is covered by separate
H-NEW-JSM-RT test added to holdout-scenarios.md if needed in pass-02 review.

---

### F13 — NIT [process-gap] — check-spec-counts.sh does NOT validate cross-document arithmetic

**Evidence**:
- `scripts/check-spec-counts.sh` lines 6–58: validates that `definitional_count`
  in each file's frontmatter matches the actual `#### BC-` heading count within
  that file. It does NOT cross-validate CANONICAL-COUNTS.md totals against the
  sum of per-file definitional counts, nor does it check BC-INDEX.md
  individually-bodied totals against CANONICAL-COUNTS.
- The F2 delta introduced a 1-off error in CANONICAL-COUNTS (bc-2 treated as 50
  when actual was 51) and a 1-off disagreement between BC-INDEX (333) and
  CANONICAL-COUNTS (332) — neither was caught by `check-spec-counts.sh` because
  both were cross-file arithmetic checks.

**Why this matters**: `check-spec-counts.sh` is the primary DRIFT-001 mitigation.
Its exit-0 result is used as a signal that spec counts are consistent. If it does
not catch cross-file arithmetic drift, a developer running the script gets false
confidence that the counts are correct.

**Recommendation**: Add a cross-document check to `check-spec-counts.sh`:
(1) sum the `definitional_count` fields from all bc-*.md and cross-cutting.md
frontmatter; (2) compare to CANONICAL-COUNTS.md `Total individually-bodied`;
(3) fail if they disagree. Similarly compare CANONICAL-COUNTS total to
BC-INDEX footer total.

**Disposition**: DEFERRED to DRIFT-008. This is a `scripts/` change on the
develop branch, not a BC change. Not blocking issue #288 ship. F13 is a
[process-gap] finding — script improvement, not spec defect. Target release: v0.6.

---

## Novelty Assessment

**Novel findings (not covered by prior DRIFT-001/003/004 precedents)**:
- F3 (simultaneous HIGH-confidence + unvalidated-Open-Question contradiction) — new
  pattern; prior drifts were count propagation errors, not confidence-vs-validation
  state conflicts.
- F4 (error string leaking queue-command context into non-queue call sites) — new
  category; prior string-drift issues were typos or stale text, not cross-feature
  context leakage.
- F7 (ADR documents a behavior contract that no BC pins) — consistent with DRIFT-003
  pattern (STORY-INDEX/WAVE-PLAN sibling propagation gap) but manifested as ADR-to-BC
  propagation gap specifically; novel sub-type.
- F10 (informal coordination note without machine-enforceable gate) — new category;
  prior scope findings were about what the code does, not about release-gate
  enforcement of external configuration steps.

**Recurring patterns (consistent with prior findings)**:
- F1/F2 (arithmetic propagation across multiple files) — consistent with DRIFT-001
  (Pass 21+ propagation, recurring) and the bc-2.6.051 drift introduced by #365.
- F5/F6 (unsupported assertion + inconsistent Source citation) — consistent with
  DRIFT-004 (BC IDs not validated against canonical files).
- F13 [process-gap] — consistent with S-7.01 / DRIFT-001 pattern class.

---

## Top 3 Findings Synopsis

**1. F4 (BLOCKING) — Error string context leakage**: The most user-visible defect.
An error message containing "Queue commands require…" surfaces to users who ran
`jr issue create --request-type` or `jr requesttype`. This is a UX correctness
failure that would appear in every non-JSM project path, making `jr` appear
to misidentify which command the user ran. Remediation required a refactor of
`require_service_desk` to accept a caller-supplied label — an architectural
decision with implementation consequences.

**2. F3 (BLOCKING) — HIGH confidence vs unvalidated claim**: A process violation
that could silently propagate wrong wire shapes to F4 implementation. The labels
plain-array vs object-array distinction matters for API correctness; marking HIGH
confidence while flagging as unvalidated creates a false safety signal. This class
of finding (confidence-level mismatch) is the hardest to catch in normal review
because it requires reading both the BC body and the Open Questions section of the
same delta document simultaneously.

**3. F7 (CONCERN) — ADR documents behavior without BC pin**: ADR-0014 explicitly
flagged the `--type` interaction as a risk requiring F5 verification, but no BC
existed to implement against and no holdout existed to verify. This is the
canonical "spec intent in the wrong artifact" failure: ADRs document decisions,
not contracts; BCs document contracts. The gap would have produced an F4
implementer with no specification for the warning behavior.
